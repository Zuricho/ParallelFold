#!/bin/bash

for i in `seq -f "%03g" 2 1 5`
do
    sed "2s/^.*$/#SBATCH --job-name=A501_${i}/g" template_alphafold.slurm > sub_alphafold.slurm
    sbatch sub_alphafold.slurm
done



