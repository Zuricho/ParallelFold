#!/bin/bash
#SBATCH --job-name=feature_Af
#SBATCH --partition=small
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-node=8
#SBATCH --output=task_file/%j_%x.out
#SBATCH --error=task_file/%j_%x.err


module load cuda/10.1.243-gcc-8.3.0
module load miniconda3
source activate alphafold_cuda10
cd /lustre/home/acct-stu/stu/parallelfold
./run_feature.sh -d data -o output -m model_1 -f input/* -t 2021-07-27
