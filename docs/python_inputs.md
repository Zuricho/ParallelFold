# AlphaFold Python Input

Author: Bozitao Zhong

AlphaFold: v2.1.2; ParaFold: v1.1



`--fasta_paths`: required

`--is_prokaryote_list`: default all false, optional for multimer, contain a boolean for each fasta file

`--model_names`: default none, only in *ParaFold*

`--data_dir`: required

`--output_dir`: required

`--jackhmmer_binary_path`: auto find by `which jackhmmer`

`--hhblits_binary_path`: auto find by `which hhblits`

`--hhsearch_binary_path`: auto find by `which hhsearch`

`--hmmsearch_binary_path`: auto find by `which hmmsearch`

`--hmmbuild_binary_path`: auto find by `which hmmbuild`

`--kalign_binary_path`: auto find by `which kalign`

`--uniref90_database_path`: required

`--mgnify_database_path`: required

`--bfd_database_path`: required when `--db_preset==full_dbs`

`--small_bfd_database_path`: required when `--db_preset==reduced_dbs`

`--uniclust30_database_path`: required when `--db_preset==full_dbs`

`--uniprot_database_path`: required when `--model_preset==multimer`

`--pdb70_database_path`: required when `--model_preset!=multimer`

`--pdb_seqres_database_path`: required when `--model_preset==multimer`

`--template_mmcif_dir`: required

`--max_template_date`: required

`--obsolete_pdbs_path`: required

`--db_preset`: default `full_dbs`, have choice `full_dbs`, `reduced_dbs`

`--model_preset`: default `full_dbs`, have choice `monomer`, `monomer_casp14`, `monomer_ptm`, `multimer`

`--benchmark`: default false

`--random_seed`: default none

`--use_precomputed_msas`: default false

`--run_relax`: default true

`--use_gpu_relax`: required

`--recycling`: default 3, only in *ParaFold*

`--run_feature`: default false, only in *ParaFold*





