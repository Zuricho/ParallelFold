#!/bin/bash
#SBATCH --job-name=complex_benchmark
#SBATCH --partition=a100
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:2
#SBATCH --output=task_file/%x_%j.out
#SBATCH --error=task_file/%x_%j.err

module purge
module load miniconda3
source activate parafold

./run_alphafold.sh \
-d data \
-o output \
-p multimer \
-m model_1_multimer_v3,model_2_multimer_v3,model_3_multimer_v3,model_4_multimer_v3,model_5_multimer_v3 \
-u 0,1 \
-i \
input/complex_benchmark/MHC_TCR.fasta \
-t 2022-01-01 -r

