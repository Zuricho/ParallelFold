# Installation

This installation guide is for GPU supports CUDA driver version above 11.0

If you are using CUDA 10.1, you can refer to [installation guide here](./install_cuda10.md)

## How to install 

We recommend to install AlphaFold locally, and not using **docker**.

### Setting up conda environment

**Step 1**: Create a conda environment for ParallelFold/AlphaFold

```bash
# Create a miniconda environment for ParaFold/AlphaFold
# Recommend you to use python above 3.8, version < 3.7 have missing packages
conda create -n alphafold python=3.9
conda activate alphafold

# install cuda and cudnn
# cudatoolkit 11.3.1 matches cudnn 8.2.1
conda install cudatoolkit=11.3 cudnn

# install tensorflow
pip install tensorflow==2.5.0

# Using conda
conda install -c conda-forge openmm=7.5.1 pdbfixer=1.7 pandas
conda install -c bioconda hmmer=3.3.2 hhsuite=3.3.0 kalign2=2.04

# Using pip
pip install biopython==1.79 chex==0.0.7 dm-haiku==0.0.4 dm-tree==0.1.6 immutabledict==2.0.0 jax==0.3.0 ml-collections==0.1.0

# Installs the wheel compatible with CUDA 11 and cuDNN 8.2 or newer.
# jax installation reference: https://github.com/google/jax
pip install --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_releases.html
```

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
cd ~/.conda/envs/alphafold/lib/python3.9/site-packages/
patch -p0 < $alphafold_path/setup/openmm.patch
```

**Local cuda**

Based on our test, you need to use local cuda if you install cudatoolkit=10.1, you can skip this step if you are using cudatoolkit 11

### References

- [Official version](https://github.com/deepmind/alphafold) from DeepMind with docker. 
- [None docker versions](https://github.com/kalininalab/alphafold_non_docker) install AlphaFold without docker. 
- [My none docker guide](https://github.com/Zuricho/AlphaFold_local) adjusted to different cuda versions (cuda driver >= 10.1) 
