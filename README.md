# ParallelFold

<div align=center>
<img src="./figure/parafoldlogo.png" width="400" >
</div>




Author: Bozitao Zhong :postbox:: zbztzhz@sjtu.edu.cn

:station: We are adding new functions to ParallelFold, you can see our [Roadmap](https://trello.com/b/sAqBIxBC/parallelfold).

:bookmark_tabs: Please cite our [Arxiv paper](https://arxiv.org/abs/2111.06340) if you used ParallelFold (ParaFold) in you research. 



**ParallelFold now supports AlphaFold 2.1.1 (maybe we are the first to adapt to multimer version)**

This project is a modified version of DeepMind's [AlphaFold2](https://github.com/deepmind/alphafold) to achieve high-throughput protein structure prediction. 

We have these following modifications to the original AlphaFold pipeline:

- Divide **CPU part** (MSA and template searching) and **GPU part** (prediction model)



## How to install 

We recommend to install AlphaFold locally, and not using **docker**.



### Setting up conda environment

**Step 1**: Create a conda environment for ParallelFold/AlphaFold

```bash
# suppose you have miniconda environment on your cluster, or you can install another miniconda or anaconda
module load miniconda3
source activate base

# Create a miniconda environment for ParallelFold/AlphaFold
conda create -n alphafold python=3.8
conda activate alphafold
```

We recommend you to use python 3.8, python version < 3.7 may have missing packages.



**Step 2**: Install `cudatoolkit` 10.1 and `cudnn`:

```bash
conda install cudatoolkit=10.1 cudnn
```

> Why use cudatoolkit 10.1:
>
> - cudatoolkit supports TensorFlow 2.3.0, while sometimes TensorFlow can't find GPU when using cudatoolkit 10.2

- cudnn version 7.6.5

- For higher version of CUDA driver, you can install cudatoolkit 11.2 and TensorFlow 2.5.0 instead



**Step 3**: Install tensorflow 2.3.0 by pip

```bash
pip install tensorflow==2.3.0
```



**Step 4**: Install other packages with pip and conda

```bash
# Using conda
conda install -c conda-forge openmm=7.5.1 pdbfixer=1.7
conda install -c bioconda hmmer=3.3.2 hhsuite=3.3.0 kalign2=2.04
conda install pandas=1.3.4

# Using pip
pip install biopython==1.79 chex==0.0.7 dm-haiku==0.0.4 dm-tree==0.1.6 immutabledict==2.0.0 jax==0.2.14 ml-collections==0.1.0
pip install --upgrade jax jaxlib==0.1.69+cuda101 -f https://storage.googleapis.com/jax-releases/jax_releases.html
```

>  jax installation reference: https://github.com/google/jax
>
>  - For CUDA 11.1, 11.2, or 11.3, use `cuda111`.
>  - For CUDA 11.0, use `cuda110`.
>  - For CUDA 10.2, use `cuda102`.
>  - For CUDA 10.1, use `cuda101`.
>
>  In newer version of JAX (after 0.1.70), it will not support CUDA 10.1 and lower version. So here we downgrade jaxlib to 0.1.69.

Here you should used cuda 10.1 when you use cuda toolkit 10.1



### Clone This Repo

```bash
git clone https://github.com/Zuricho/ParallelFold.git
alphafold_path="/path/to/alphafold/git/repo"
```

give the executive permission for sh files:

```bash
chmod +x run_feature.sh
chmod +x run_alphafold.sh
```



### Final Steps

**[Not Necessary] Download chemical properties to the common folder**

You need to check if you have the `stereo_chemical_props.txt` file in `alphafold/alphafold/common/ `folder, if you don't have it, you need to download this file:

```
wget -q -P alphafold/alphafold/common/ https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
```

**Apply OpenMM patch**

```bash
# This is you path to your alphafold folder
alphafold_path="/path/to/alphafold/git/repo"
cd ~/.conda/envs/alphafold/lib/python3.8/site-packages/
patch -p0 < $alphafold_path/docker/openmm.patch
```

**Local cuda**

Based on our test, you need to use local cuda if you install cudatoolkit=10.1, you can skip this step if you are using cudatoolkit 11

Their might be some available modules: `cuda/10.1.243-gcc-8.3.0`, `cuda/10.2.89-gcc-8.3.0`



### References

- [Official version](https://github.com/deepmind/alphafold) from DeepMind with docker. 
- [None docker versions](https://github.com/kalininalab/alphafold_non_docker) install AlphaFold without docker. 
- [My none docker guide](https://github.com/Zuricho/AlphaFold_local) adjusted to different cuda versions (cuda driver >= 10.1) 



## Some detail information of modified files

4 files:

- `run_alphafold.py`: modified version of original `run_alphafold.py`, it skips featuring steps when there exists `feature.pkl` in output folder
- `run_alphaold.sh`: bash script to run `run_alphafold.py`
- `run_feature.py`: modified version of original `run_alphafold.py`, it exit python process after finished writing `feature.pkl`
- `run_feature.sh`: bash scripts to run `run_feature.py`
- `run_figure`: this file can help you make figure for your system



## How to run

First, you need CPUs to run `run_feature.sh`:

```bash
./run_feature.sh -d data -o output -m model_1 -f input/test3.fasta -t 2021-07-27
```

>  8 CPUs is enough, according to my test, more CPUs won't help with speed.

Featuring step will output the `feature.pkl`  and MSA folder in your output folder: `./output/JOBNAME/`

PS: Here we put input files in an `input` folder to better organize files.



Second, you can run `run_alphafold.sh` using GPU:

```bash
./run_alphafold.sh -d data -o output -m model_1,model_2,model_3,model_4,model_5 -f input/test.fasta -t 2021-07-27
```

If you have successfully output `feature.pkl`, you can have a very fast featuring step



Finally, you can run `run_figure.py` to visualize your result:

```
python run_figure.py [SystemName]
```

This python file will create a figure folder in your output folder.

Notice: `run_figure.py` need a local conda environment with matplotlib, pymol and numpy.



## Functions

You can using some flags to change prediction model for ParallelFold:

`-x`: Skip AMBER refinement

`-b`: Using benchmark mode - running JAX model for twice, and the second run can used for evaluate running time

**Some more functions are under development.**



~~I have also upload my scripts in SJTU HPC (using slurm): `sub_alphafold.slurm` and `sub_feature.slurm`~~



## What is this for

ParallelFold can help you accelerate AlphaFold when you want to predict multiple sequences. After dividing the CPU part and GPU part, users can finish feature step by multiple processors.

Using ParallelFold, you can run AlphaFold 2~3 times faster than DeepMind's procedure. 



## Other Files

~~I have also modified `run_feature.sh` and `run_alphafold.sh` to make them find the alphafold folder, which means that you can use it in another folder. But you need to change `alphafold/common/restrains.py`. In this file it use a relative path to find the restraint file, you need to change it to absolute path.~~



If you have any question, please send your problem in issues







