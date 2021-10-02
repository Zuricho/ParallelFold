import os
import sys
import pickle
import matplotlib.pyplot as plt
import numpy as np
from pymol import cmd


system_name = sys.argv[1]
output_dir = "output/"

model_list_all = ["model_1","model_2","model_3","model_4","model_5","model_1_ptm","model_2_ptm","model_3_ptm","model_4_ptm","model_5_ptm"]
model_ptm_list_all = ["model_1_ptm","model_2_ptm","model_3_ptm","model_4_ptm","model_5_ptm"]
model_normal_list_all = ["model_1","model_2","model_3","model_4","model_5"]


# plot figure for maximal 5 models
def plddt_figure(plddt_score_list,system_name,model_name_list,mode="normal"):

    # we need a function to check some requirement for plddt score list
    # UNDER DEVELOPMENT HERE

    # set figure size according to length
    plt.figure(figsize=(len(plddt_score_list[0])/10,4))

    # plot plddt score
    for i in range(len(plddt_score_list)):
        plt.plot(plddt_score_list[i],label=model_name_list[i])

    # color stage in background
    for i in np.arange(0,100,2):
        plt.axhspan(i,i+2,color=plt.get_cmap('YlGnBu')(i/100),alpha=0.4,linewidth=0)

    
    plt.xlim(0,len(plddt_score_list[0])-1)
    plt.ylim(0,100)
    plt.xticks(np.arange(0,len(plddt_score_list[0]),3),np.arange(1,len(plddt_score_list[0])+1,3))
    plt.yticks(np.arange(0,110,10))

    # plot legend
    plt.legend(loc="lower right")

    # different name for types
    if mode == "ptm":
        plt.title("pLDDT score of %s (pTM)"%(system_name))
        plt.tight_layout()
        plt.savefig("figure/pLDDT_pTM.png",dpi=200)
    else:
        plt.title("pLDDT score of %s"%(system_name))
        plt.tight_layout()
        plt.savefig("figure/pLDDT.png",dpi=200)
    plt.close()


def secondary_figure(ss_total_list,system_name,model_name_list,mode="normal"):
    # test plot of secondary structure
    plt.figure(figsize=(len(ss_total_list[0])/10,3))
    plt.imshow(ss_total_list,cmap="PiYG",aspect='auto',vmin=-1.5,vmax=1.5)
    plt.yticks(np.arange(0,len(ss_total_list),1),model_name_list)
    plt.xlabel("Amino acid index")

    if mode == "ptm":
        plt.title("secondary structure of %s (pTM)"%(system_name))
        plt.tight_layout()
        plt.savefig("figure/secondary_structure_pTM.png",dpi=200)
    else:
        plt.title("secondary structure of %s"%(system_name))
        plt.tight_layout()
        plt.savefig("figure/secondary_structure.png",dpi=200)
    plt.close()


# Get Target Secondary Structure
def get_secondary_sturcture(system_name,model_name):
    # Helix is 1, Sheet is -1, Loop is 0
    ss_list = []
    # two types of models
    if os.path.exists("unrelaxed_%s.pdb"%model_name):
        cmd.load("unrelaxed_%s.pdb"%model_name,"%s_%s"%(system_name,model_name))
        cmd.dss()
        for a in cmd.get_model(system_name +" and n. ca").atom:
            if a.ss == 'H':
                ss_list.append(1)
            elif a.ss == 'S':
                ss_list.append(-1)
            else:
                ss_list.append(0)
        cmd.reinitialize()
    elif os.path.exists("relaxed_%s.pdb"%model_name):
        cmd.load("relaxed_%s.pdb"%model_name,"%s_%s"%(system_name,model_name))
        cmd.dss()
        for a in cmd.get_model(system_name +" and n. ca").atom:
            if a.ss == 'H':
                ss_list.append(1)
            elif a.ss == 'S':
                ss_list.append(-1)
            else:
                ss_list.append(0)
        cmd.reinitialize()
    else:
        pass
    return ss_list


def pae_figure(pae_mat,system_name,model_name):
    # plot ptm figure
    plt.subplots(figsize=(6,6))
    plt.imshow(pae_mat,cmap="Greens_r",vmin=0, vmax=35)
    plt.title("Predicted Aligned Error of %s %s"%(system_name,model_name))
    plt.xlabel("scored residue")
    plt.ylabel("aligned residue")
    plt.colorbar(label="Expected positional error (Angstrom)",shrink=0.8)
    plt.savefig("figure/PAE_%s.png"%model_name,dpi=200)


def main():
    os.chdir(output_dir+system_name)
    try:
        os.mkdir("figure")
    except FileExistsError:
        # If the figure folder already exists, skip
        pass

    plddt_score_list = []
    plddt_score_list_ptm = []
    ss_normal_list = []
    ss_ptm_list = []
    model_normal_list = []
    model_ptm_list = []
    for model_name in model_list_all:
        if os.path.exists("result_%s.pkl"%model_name):
            pkl_file = open("result_%s.pkl"%model_name,'rb')
            result_pkl = pickle.load(pkl_file)

            ss_list = get_secondary_sturcture(system_name,model_name)

            plddt_score = result_pkl['plddt']
            if model_name in model_ptm_list_all:
                # plot ptm figure
                pae_figure(result_pkl['predicted_aligned_error'],system_name,model_name)
                plddt_score_list_ptm.append(plddt_score)
                model_ptm_list.append(model_name)
                ss_ptm_list.append(ss_list)
            else:
                plddt_score_list.append(plddt_score)
                model_normal_list.append(model_name)
                ss_normal_list.append(ss_list)

            pkl_file.close()

    if len(model_normal_list) != 0:
        plddt_figure(plddt_score_list,system_name,model_normal_list)
        secondary_figure(ss_normal_list,system_name,model_normal_list)
    if len(model_ptm_list) != 0:
        plddt_figure(plddt_score_list_ptm,system_name,model_ptm_list,mode='ptm')
        secondary_figure(ss_ptm_list,system_name,model_ptm_list,mode="ptm")

    
        
        

if __name__ == "__main__":
    main()