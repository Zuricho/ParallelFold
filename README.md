<div align=center>
<img src="./docs/parafoldlogo.png" width="400" >
</div>

# ParaFold

Author: Bozitao Zhong - zbztzhz@gmail.com

:bookmark_tabs: Please cite our [paper](https://arxiv.org/abs/2111.06340) if you used ParaFold (ParallelFold) in you research. 

## Overview

Recent change: **ParaFold now supports AlphaFold 2.3.1**

This project is a modified version of DeepMind's [AlphaFold2](https://github.com/deepmind/alphafold) to achieve high-throughput protein structure prediction. 

We have these following modifications to the original AlphaFold pipeline:

- Divide **CPU part** (MSA and template searching) and **GPU part** (prediction model)



## How to install 

We recommend to install AlphaFold locally, and not using **docker**.

```bash
# clone this repo
git clone https://github.com/Zuricho/ParallelFold.git

# Create a miniconda environment for ParaFold/AlphaFold
# Recommend you to use python 3.8, version < 3.7 have missing packages, python versions newer than 3.8 were not tested
conda create -n parafold python=3.8

pip install py3dmol
# openmm 7.7 is recommended (original alphafold using 7.5.1, but it is not supported now)
conda install -c conda-forge openmm=7.7 pdbfixer

# use pip3 to install most of packages
pip3 install -r requirements.txt

# install cuda and cudnn
# cudatoolkit 11.3.1 matches cudnn 8.2.1
conda install cudatoolkit=11.3 cudnn

# downgrade jaxlib to the correct version, matches with cuda and cudnn version
pip3 install --upgrade --no-cache-dir jax==0.3.25 jaxlib==0.3.25+cuda11.cudnn82 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# install packages for multiple sequence alignment
conda install -c bioconda hmmer=3.3.2 hhsuite=3.3.0 kalign2=2.04

chmod +x run_alphafold.sh
```

## Download the sequence database

You can use the [downloading script from AlphaFold repo](https://github.com/google-deepmind/alphafold/blob/main/scripts/download_all_data.sh). 
The `data` directory should have the following directory structure. Some old versions of AlphaFold might have older database versions, you should update them (reference to AlphaFold repo)

```text
$DOWNLOAD_DIR/                             # Total: ~ 2.62 TB (download: 556 GB)
    bfd/                                   # ~ 1.8 TB (download: 271.6 GB)
        # 6 files.
    mgnify/                                # ~ 120 GB (download: 67 GB)
        mgy_clusters_2022_05.fa
    params/                                # ~ 5.3 GB (download: 5.3 GB)
        # 5 CASP14 models,
        # 5 pTM models,
        # 5 AlphaFold-Multimer models,
        # LICENSE,
        # = 16 files.
    pdb70/                                 # ~ 56 GB (download: 19.5 GB)
        # 9 files.
    pdb_mmcif/                             # ~ 238 GB (download: 43 GB)
        mmcif_files/
            # About 199,000 .cif files.
        obsolete.dat
    pdb_seqres/                            # ~ 0.2 GB (download: 0.2 GB)
        pdb_seqres.txt
    small_bfd/                             # ~ 17 GB (download: 9.6 GB)
        bfd-first_non_consensus_sequences.fasta
    uniref30/                              # ~ 206 GB (download: 52.5 GB)
        # 7 files.
    uniprot/                               # ~ 105 GB (download: 53 GB)
        uniprot.fasta
    uniref90/                              # ~ 67 GB (download: 34 GB)
        uniref90.fasta
```


## Some detail information of modified files

- `run_alphafold.py`: modified version of original `run_alphafold.py`, it has multiple additional functions like skipping featuring steps when exists `feature.pkl` in output folder
- `run_alphafold.sh`: bash script to run `run_alphafold.py`



## How to run

### Run features

Run on CPUs to get features:

```bash
./run_alphafold.sh \
-d data \
-o output \
-p monomer_ptm \
-i input/GA98.fasta \
-t 1800-01-01 \
-m model_1 \
-f

```

`-f` means only run the featurization step, result in a `feature.pkl` file, and skip the following steps.

>  8 CPUs is enough, according to my test, more CPUs won't help with speed

Featuring step will output the `feature.pkl`  and MSA folder in your output folder: `./output/[FASTA_NAME]/`

PS: Here we put input files in an `input` folder to organize files in a better way.



### Run monomer prediction

After the feature step, you can run `run_alphafold.sh` using GPU:

```bash
./run_alphafold.sh \
-d data \
-o output \
-m model_1,model_2,model_3,model_4,model_5 \
-p monomer_ptm \
-i input/GA98.fasta \
-t 1800-01-01 

```

If you have successfully output `feature.pkl`, you can have a very fast featuring step



### Run multimer prediction

```bash
./run_alphafold.sh \
-d data \
-o output \
-m model_1_multimer,model_2_multimer,model_3_multimer,model_4_multimer,model_5_multimer \
-p multimer \
-i input/GA98.fasta \
-t 1800-01-01 

```



## What is this for

ParallelFold can help you accelerate AlphaFold when you want to predict multiple sequences. After dividing the CPU part and GPU part, users can finish feature step by multiple processors. Using ParaFold, you can run AlphaFold 2~3 times faster than DeepMind's procedure. 

**If you have any question, please raise issues**







