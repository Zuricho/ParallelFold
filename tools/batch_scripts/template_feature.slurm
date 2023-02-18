#!/bin/bash
#SBATCH --job-name=A501_001
#SBATCH --partition=small
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --ntasks-per-node=8
#SBATCH --output=task_file/%x_%j.out
#SBATCH --error=task_file/%x_%j.err

echo $SLURM_JOB_NAME

module load cuda/10.1.243-gcc-8.3.0
module load miniconda3
source activate alphafold_cuda10
cd /lustre/home/acct-stu/stu/deepocean

/lustre/home/acct-stu/stu/parallelfold/run_feature.sh -d /lustre/home/acct-stu/stu/parallelfold/data -o A501_result -m model_1 -f A501_seq/${SLURM_JOB_NAME}.fasta -t 2021-07-27
