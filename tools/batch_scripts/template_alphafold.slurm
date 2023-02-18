#!/bin/bash
#SBATCH --job-name=A501_001
#SBATCH --partition=dgx2
##SBATCH -w vol08
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --gres=gpu:1
#SBATCH --output=task_file/%x_%j.out
#SBATCH --error=task_file/%x_%j.err

module load cuda/10.1.243-gcc-8.3.0
module load miniconda3
source activate alphafold_cuda10
cd /lustre/home/acct-stu/stu/deepocean
/lustre/home/acct-stu/stu/parallelfold/run_alphafold.sh -d /lustre/home/acct-stu/stu/parallelfold/data -o A501_result -m model_1,model_2 -f A501_seq/${SLURM_JOB_NAME}.fasta -t 2021-07-27

