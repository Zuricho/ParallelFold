#!/bin/bash
#SBATCH --job-name=model_ParaFold
#SBATCH --partition=dgx2
##SBATCH -w vol08
#SBATCH -N 1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --gres=gpu:1
#SBATCH --output=task_file/%j_%x.out
#SBATCH --error=task_file/%j_%x.err

module purge
module load miniconda3
module load cuda/10.1.243-gcc-8.3.0
source activate af_env
cd /lustre/home/acct-stu/stu/parallelfold
./run_alphafold.sh -d data -o output -m model_1,model_2,model_3,model_4,model_5 -f input/test.fasta -t 2021-07-27

