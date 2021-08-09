# ParallelFold

Author: [Bozitao Zhong](zbztzhz@sjtu.edu.cn)

This is a modified version of DeepMind's [Alphafold2](https://github.com/deepmind/alphafold) to divide **CPU part** (MSA and template searching) and **GPU part** (prediction model) of Alphafold2 local version.



## How to install 

First you should install Alphafold2. You can choose one of the following methods to install Alphafold locally.

- Use [official version](https://github.com/deepmind/alphafold) from DeepMind with docker. 
- There are some [other versions](https://github.com/kalininalab/alphafold_non_docker) install Alphafold without docker. 
- Also you can use [my guide](https://github.com/Zuricho/Alphafold_local) which based on non_docker version and it can adjust to different cuda versions (cuda driver >= 10.1) 



Then, put these 4 files in your Alphafold folder, this folder should have an original `run_alphafold.py` file, and I use a `run_alphafold.sh` file to run Alphafold easily (learned from [non_docker version](https://github.com/kalininalab/alphafold_non_docker))

4 files:

- `run_alphafold.py`: modified version of original `run_alphafold.py`, it skips featuring steps when there exists `feature.pkl` in output folder
- `run_alphaold.sh`: bash script to run `run_alphafold.py`
- `run_feature.py`: modified version of original `run_alphafold.py`, it exit python process after finished writing `feature.pkl`
- `run_feature.sh`: bash scripts to run `run_feature.py`



## How to run

First, you need CPUs to run `run_feature.sh`:

```bash
./run_feature.sh -d data -o output -m model_1 -f input/test3.fasta -t 2021-07-27
```

>  8 CPUs is enough, according to my test, more CPUs won't help with speed.
>
> GPU can accelerate the hhblits step (but I think you choose this repo because GPU is expensive)

Featuring step will output the `feature.pkl`  and MSA folder in your output folder: `./output/JOBNAME/`

PS: Here I put my input files in an `input` folder to better organize my files, you can remove this.



Second, you can run `run_alphafold.sh` using GPU:

```
./run_alphafold.sh -d data -o output -m model_1,model_2,model_3,model_4,model_5 -f input/test.fasta -t 2021-07-27
```

If you have successfully output `feature.pkl`, you can have a very fast featuring step



I have also upload my scripts in SJTU HPC (using slurm): `sub_alphafold.slurm` and `sub_feature.slurm`



## What is this for

ParallelFold can help you accelerate Alphafold when you want to predict multiple sequences. After dividing the CPU part and GPU part, users can finish feature step by multiple processors.

Using ParallelFold, you can run Alphafold 2~3 times faster than DeepMind's procedure. 



## Other Files

In `./Alphafold` folder, I modified some python files (`hhblits.py`, `hmmsearch.py`, `jackhmmer.py`) , give these steps more CPUs for acceleration. But  these processes have been tested and shown to be unable to accelerate by  providing more CPU. Probably because DeepMind uses a wrapped process, I'm trying to improve it (work in progress).



I have also modified `run_feature.sh` and `run_alphafold.sh` to make them find the alphafold folder, which means that you can use it in another folder. But you need to change `alphafold/common/restrains.py`. In this file it use a relative path to find the restraint file, you need to change it to absolute path.



If you have any question, please send your problem in issues
