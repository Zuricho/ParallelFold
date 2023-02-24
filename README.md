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



## Some detail information of modified files

- `run_alphafold.py`: modified version of original `run_alphafold.py`, it has multiple additional functions like skipping featuring steps when exists `feature.pkl` in output folder
- `run_alphafold.sh`: bash script to run `run_alphafold.py`
- `run_figure.py`: this file can help you make figure for your system



## How to run

Visit the [usage page](./docs/usage.md) to know how to run



## What is this for

ParallelFold can help you accelerate AlphaFold when you want to predict multiple sequences. After dividing the CPU part and GPU part, users can finish feature step by multiple processors. Using ParaFold, you can run AlphaFold 2~3 times faster than DeepMind's procedure. 

**If you have any question, please raise issues**







