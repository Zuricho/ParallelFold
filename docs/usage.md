# Usage

## Run features

Run on CPUs to get features:

```bash
./run_alphafold.sh \
-d data \
-o output \
-p monomer_ptm \
-i input/GA98.fasta \
-t 1800-01-01 \
-m model_1 \
-f

```

`-f` means only run the featurization step, result in a `feature.pkl` file, and skip the following steps.

>  8 CPUs is enough, according to my test, more CPUs won't help with speed

Featuring step will output the `feature.pkl`  and MSA folder in your output folder: `./output/[FASTA_NAME]/`

PS: Here we put input files in an `input` folder to organize files in a better way.



## Run monomer prediction

After the feature step, you can run `run_alphafold.sh` using GPU:

```bash
./run_alphafold.sh \
-d data \
-o output \
-m model_1,model_2,model_3,model_4,model_5 \
-p monomer_ptm \
-i input/GA98.fasta \
-t 1800-01-01 

```

If you have successfully output `feature.pkl`, you can have a very fast featuring step



## Run multimer prediction

```bash
./run_alphafold.sh \
-d data \
-o output \
-m model_1_multimer,model_2_multimer,model_3_multimer,model_4_multimer,model_5_multimer \
-p multimer \
-i input/GA98.fasta \
-t 1800-01-01 

```

## Draw figures

[This function is under repair]

You can run `run_figure.py` to visualize your result: [This will be available soon]

```bash
python3 run_figure.py [SystemName]
```

This python file will create a figure folder in your output folder.

Notice: `run_figure.py` need a local conda environment with matplotlib, pymol and numpy.

