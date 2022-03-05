# Installation

This installation guide is for GPU supports CUDA driver version above 10.1

If you are using CUDA above 11.0, you can refer to [installation guide here](./install.md)

## How to install 

We recommend to install AlphaFold locally, and not using **docker**.

### Setting up conda environment

**Step 1**: Create a conda environment for ParallelFold/AlphaFold

```bash
# Create a miniconda environment for ParallelFold/AlphaFold
conda create -n alphafold python=3.8
conda activate alphafold
```

We recommend you to use python 3.8, python version < 3.7 may have missing packages.

**Step 2**: Install `cudatoolkit` 10.1 and `cudnn`:

```bash
conda install cudatoolkit=10.1 cudnn
```

> - cudatoolkit 10.1 matches cudnn 7.6.5, supports TensorFlow 2.3.0
>   - cudatoolkit supports TensorFlow 2.3.0, while sometimes TensorFlow can't find GPU when using cudatoolkit 10.2
>
> - cudatoolkit 11.3 matches cudnn 8.2.1
> - For higher version of CUDA driver, you can install cudatoolkit 11.2 and TensorFlow 2.5.0 instead

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
patch -p0 < $alphafold_path/setup/openmm.patch
```

**Local cuda**

Based on our test, you need to use local cuda if you install cudatoolkit=10.1, you can skip this step if you are using cudatoolkit 11

Their might be some available modules: `cuda/10.1.243-gcc-8.3.0`, `cuda/10.2.89-gcc-8.3.0`

### References

- [Official version](https://github.com/deepmind/alphafold) from DeepMind with docker. 
- [None docker versions](https://github.com/kalininalab/alphafold_non_docker) install AlphaFold without docker. 
- [My none docker guide](https://github.com/Zuricho/AlphaFold_local) adjusted to different cuda versions (cuda driver >= 10.1) 

