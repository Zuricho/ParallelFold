from __future__ import print_function
import pickle
import sys

try:
    if sys.argv[1][-3:] == 'pkl':
        pkl_file = open(sys.argv[1],'rb')
        result_pkl = pickle.load(pkl_file)
        plddt_score = result_pkl['plddt']
        print(sys.argv[1][:-4],end=", ")
        for i in range(len(plddt_score)):
            print("%.4f"%plddt_score[i],end="")
            if i != len(plddt_score)-1:
                print(", " ,end="")
        print('\n',end="")
        pkl_file.close()
    else:
        print("Usage: python3 plddt.py [AlphaFold predict output plddt file]\n")
except:
    print("Usage: python3 plddt.py [AlphaFold predict output plddt file]\n")
    

