<div align=center>
<img src="./docs/parafoldlogo.png" width="400" >
</div>

# ParallelFold

Author: Bozitao Zhong - zbztzhz@gmail.com

:station: We are adding new functions to ParallelFold, you can see our [Roadmap](https://trello.com/b/sAqBIxBC/parallelfold).

:bookmark_tabs: Please cite our [paper](https://arxiv.org/abs/2111.06340) if you used ParallelFold (ParaFold) in you research. 

## Overview

This project is a modified version of DeepMind's [AlphaFold2](https://github.com/deepmind/alphafold) to achieve high-throughput protein structure prediction. 

We have these following modifications to the original AlphaFold pipeline:

- Divide **CPU part** (MSA and template searching) and **GPU part** (prediction model)

**ParallelFold now supports AlphaFold 2.1.2**



## How to install 

We recommend to install AlphaFold locally, and not using **docker**.

For CUDA 11, you can refer to the [installation guide here](./docs/install.md).

For CUDA 10.1, you can refer to the [installation guide here](./docs/install_cuda10.md).



## Some detail information of modified files

- `run_alphafold.py`: modified version of original `run_alphafold.py`, it has multiple additional functions like skipping featuring steps when exists `feature.pkl` in output folder
- `run_alphafold.sh`: bash script to run `run_alphafold.py`
- `run_figure.py`: this file can help you make figure for your system



## How to run

Visit the [usage page](./docs/usage.md) to know how to run



## Functions

You can using some flags to change prediction model for ParallelFold:

`-r`: Skip AMBER refinement [Under repair]

`-b`: Using benchmark mode - running JAX model for twice, and the second run can used for evaluate running time

`-R`: Change the number of cycles in recycling

**More functions are under development.**



## What is this for

ParallelFold can help you accelerate AlphaFold when you want to predict multiple sequences. After dividing the CPU part and GPU part, users can finish feature step by multiple processors. Using ParallelFold, you can run AlphaFold 2~3 times faster than DeepMind's procedure. 

**If you have any question, please send GitHub issues**







