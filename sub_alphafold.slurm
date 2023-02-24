#!/bin/bash
#SBATCH --job-name=GA98
#SBATCH --partition=a100
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1
#SBATCH --output=task_file/%x_%j.out
#SBATCH --error=task_file/%x_%j.err

module purge
module load miniconda3
source activate parafold

./run_alphafold.sh \
-d data \
-o output \
-p monomer_ptm \
-u 0 \
-i \
input/mono_set1/GA98.fasta \
-t 2020-01-01 \
-r none

