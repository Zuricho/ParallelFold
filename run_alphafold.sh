#!/bin/bash
# Description: AlphaFold non-docker version
# Author: Sanjay Kumar Srikakulam
# Modified by Bozitao Zhong

usage() {
        echo ""
        echo "Usage: $0 <OPTIONS>"
        echo "Required Parameters:"
        echo "-d <data_dir>           Path to directory of supporting data"
        echo "-o <output_dir>         Path to a directory that will store the results."
        echo "-p <model_preset>       Model preset. Use monomer, monomer_ptm, monomer_casp14 or multimer models"
        echo "-i <fasta_path>         Path to a FASTA file containing query sequence(s)"

        echo "Optional Parameters:"
        echo "-t <max_template_date>  Maximum template release date to consider (YYYY-MM-DD format). (default: 2020-12-01)"
        echo "-b <benchmark>          Run multiple JAX model evaluations to obtain a timing that excludes the compilation time (default: 'False')"
        echo "-g <use_gpu>            Enable NVIDIA runtime to run with GPUs (default: 'True')"
        echo "-u <gpu_devices>        Comma separated list of devices to pass to 'CUDA_VISIBLE_DEVICES' (default: 'all')"
        echo "-c <db_preset>          Choose database reduced_dbs or full_dbs (default: 'full_dbs')"
        echo "-r <models_to_relax>    'all': all models are relaxed, 'best': only the most confident model, 'none': no models are relaxed (default: 'all')"
        echo "-m <model_selection>    Names of comma separated model names to use in prediction (default: All 5 models)"
        echo "-R <recycling>          Set cycles for recycling (default: '3')"
        echo "-f <run_feature>        Only run MSA and template search to generate feature file"
        echo "-G <use_gpu_relax>      Disable GPU relax"
        
        echo "Future Parameters (You cannot use them now):"
        echo "-s <skip_msa>           Skip MSA and template step, generate single sequence feature for ultimately fast prediction"
        echo "-q <quick_mode>         Quick mode. Use small BFD database, no templates"
        echo "-e <random_seed>        Set random seed"
        echo "-P <precomputed_msas>   Use precomputed MSAs"
        echo ""
        exit 1
}

while getopts ":d:o:p:i:t:u:c:m:R:r:bgvsqfG" i; do
        case "${i}" in
        d)
                data_dir=$OPTARG
        ;;
        o)
                output_dir=$OPTARG
        ;;
        p)
                model_preset=$OPTARG
        ;;
        i)
                fasta_path=$OPTARG
        ;;
        t)
                max_template_date=$OPTARG
        ;;
        b)
                benchmark=true
        ;;
        g)
                use_gpu=true
        ;;
        u)
                gpu_devices=$OPTARG
        ;;
        c)
                db_preset=$OPTARG
        ;;
        r)
                models_to_relax=$OPTARG
        ;;
        m)
                model_selection=$OPTARG
        ;;
        v)
                visualizaion=true
        ;;
        s)
                skip_msa=true
        ;;
        q)
                quick_mode=true
        ;;
        R)
                recycling=$OPTARG
        ;;
        f)
                run_feature=true
        ;;
        G)
                use_gpu_relax=false
        ;;
        esac
done

# Parse input and set defaults
if [[ "$data_dir" == "" || "$output_dir" == "" || "$model_preset" == "" || "$fasta_path" == "" ]] ; then
    usage
fi

if [[ "$max_template_date" == "" ]] ; then
    max_template_date="2020-12-01"
fi

if [[ "$benchmark" == "" ]] ; then
    benchmark=false
fi

if [[ "$use_gpu" == "" ]] ; then
    use_gpu=true
fi

if [[ "$gpu_devices" == "" ]] ; then
    gpu_devices="0"
fi

if [[ "$db_preset" == "" ]] ; then
    db_preset="full_dbs"
fi

if [[ "$models_to_relax" == "" ]] ; then
    models_to_relax="all"
fi

if [[ "$model_selection" == "" ]] ; then
    model_selection=""
fi

if [[ "$visualizaion" == "" ]] ; then
    visualizaion=false
fi

if [[ "$skip_msa" == "" ]] ; then
    skip_msa=false
fi

if [[ "$quick_mode" == "" ]] ; then
    quick_mode=false
fi

if [[ "$recycling" == "" ]] ; then
    recycling=3
fi

if [[ "$run_feature" == "" ]] ; then
    run_feature=false
fi

if [[ "$use_gpu_relax" == "" ]] ; then
    use_gpu_relax=true
fi


# This bash script looks for the run_alphafold.py script in its current working directory, if it does not exist then exits
#current_working_dir=$(pwd)
alphafold_script="$(readlink -f $(dirname $0))/run_alphafold.py"  


if [ ! -f "$alphafold_script" ]; then
    echo "Alphafold python script $alphafold_script does not exist."
    exit 1
fi

# Export ENVIRONMENT variables and set CUDA devices for use
if [[ "$use_gpu" == true ]] ; then
    export CUDA_VISIBLE_DEVICES=0

    if [[ "$gpu_devices" ]] ; then
        export CUDA_VISIBLE_DEVICES=$gpu_devices
    fi
fi

export TF_FORCE_UNIFIED_MEMORY='1'
export XLA_PYTHON_CLIENT_MEM_FRACTION='4.0'

# Path and user config (change me if required)
parameter_path="$data_dir/params"
bfd_database_path="$data_dir/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt"
small_bfd_database_path="$data_dir/small_bfd/bfd-first_non_consensus_sequences.fasta"
mgnify_database_path="$data_dir/mgnify/mgy_clusters_2018_12.fa"
template_mmcif_dir="$data_dir/pdb_mmcif/mmcif_files"
obsolete_pdbs_path="$data_dir/pdb_mmcif/obsolete.dat"
pdb70_database_path="$data_dir/pdb70/pdb70"
pdb_seqres_database_path="$data_dir/pdb_seqres/pdb_seqres.txt"
uniref30_database_path="$data_dir/uniref30/UniRef30_2021_03"  # We recommend this use the 2020 version of uniclust
uniref90_database_path="$data_dir/uniref90/uniref90.fasta"
uniprot_database_path="$data_dir/uniprot/uniprot.fasta"


if [[ "$db_preset" == "full_dbs" ]] ; then
    small_bfd_database_path=""
fi

if [[ "$db_preset" == "reduced_dbs" ]] ; then
    bfd_database_path=""
    uniref30_database_path=""
fi

# Binary path (change me if required)
hhblits_binary_path=$(which hhblits)
hhsearch_binary_path=$(which hhsearch)
jackhmmer_binary_path=$(which jackhmmer)
kalign_binary_path=$(which kalign)
hmmsearch_binary_path=$(which hmmsearch)
hmmbuild_binary_path=$(which hmmbuild)

# Temporary
# Missing random_seed, use_precomputed_msas
if [[ "$model_preset" == "monomer" || "$model_preset" == "monomer_ptm" ]] ; then
    pdb_seqres_database_path=""
    uniprot_database_path=""
fi

if [[ "$model_preset" == "multimer" ]] ; then
    pdb70_database_path=""
fi

# Run AlphaFold with required parameters
python $alphafold_script \
--fasta_paths=$fasta_path \
--model_names=$model_selection \
--parameter_path=$parameter_path \
--output_dir=$output_dir \
--jackhmmer_binary_path=$jackhmmer_binary_path \
--hhblits_binary_path=$hhblits_binary_path \
--hhsearch_binary_path=$hhsearch_binary_path \
--hmmsearch_binary_path=$hmmsearch_binary_path \
--hmmbuild_binary_path=$hmmbuild_binary_path \
--kalign_binary_path=$kalign_binary_path \
--uniref90_database_path=$uniref90_database_path \
--mgnify_database_path=$mgnify_database_path \
--bfd_database_path=$bfd_database_path \
--small_bfd_database_path=$small_bfd_database_path \
--uniref30_database_path=$uniref30_database_path \
--uniprot_database_path=$uniprot_database_path \
--pdb70_database_path=$pdb70_database_path \
--pdb_seqres_database_path=$pdb_seqres_database_path \
--template_mmcif_dir=$template_mmcif_dir \
--max_template_date=$max_template_date \
--obsolete_pdbs_path=$obsolete_pdbs_path \
--db_preset=$db_preset \
--model_preset=$model_preset \
--benchmark=$benchmark \
--models_to_relax=$models_to_relax \
--use_gpu_relax=$use_gpu_relax \
--recycling=$recycling \
--run_feature=$run_feature \
--logtostderr
