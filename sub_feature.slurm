#!/bin/bash
#SBATCH --job-name=feat_ParaFold
#SBATCH --partition=small
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-node=8
#SBATCH --output=task_file/%j_%x.out
#SBATCH --error=task_file/%j_%x.err


module load miniconda3
source activate alphafold
cd /lustre/home/acct-stu/stu/ParallelFold
./run_feature.sh -d data -o output -m model_1 -f input/* -t 1800-01-01
