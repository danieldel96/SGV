#!/usr/bin/env python
# coding: utf-8

# In[7]:


import numpy as np
import pandas as pd


# In[8]:


#Converted to python from extractTDFeats.m
#4 signal input arrays
#(4, SigLen)
#assuming np.array input
def extractTDFeats(sample):
    DEADZONE = 0.04 #arbritrary threshold
    feats = []
    for sig in sample:
        #print(" ... New Signal ... ")
        frame_len = len(sig)
        mav = 0
        length = 0
        zero_count = 0
        turns = 0
        
        mav = np.mean(sig)
        #print("Mean Absolute Value: ", mav)   
        
        flag1 = 1
        flag2 = 1
        for i in range(1,frame_len-1):
            idx = i
            fst = sig[idx-1]
            mid = sig[idx]
            lst = sig[idx+1]
            
            #compute zero crossings
            if((mid>=mav and fst>=mav) or (mid<=0 and fst<=0)):
                flag1 = flag2
            elif((mid<DEADZONE) and (mid>-1*DEADZONE) and (fst<DEADZONE) and (fst>-1*DEADZONE)):
                flag1 = flag2
            else:
                flag1 = -1*flag2
            if(flag1 != flag2):
                zero_count = zero_count + 1
                flag1 = flag2
            
            #compute turns (slope changes)
            if((mid>fst and mid>lst) or (mid<fst and mid<lst)):
                if( abs(mid-fst)>DEADZONE or abs(mid-lst)>DEADZONE ):
                    turns = turns+1
                    
            #compute waveform length
            length = length + abs(fst-mid)
        if(pd.isna(mav)):
            mav = 0
        if(pd.isna(length)):
            length = 0
        #feats.append([mav, length, turns])
        feats.append([mav, length, zero_count, turns])        
    return feats


# In[9]:


def main():   
    np_load = np.load('raw_data.npz',allow_pickle=True) # load
    feature_array = []
    dataset = np_load['dataset']
    dataset_class = np_load['dataset_class']
    for i in dataset:
       # print(" --- New Sample --- ")
        feature_array.append(np.array(extractTDFeats(i)).flatten())
  #  print(feature_array)

    print(np.array(feature_array).shape)
    print(dataset_class.shape)
    np.savez('feat_data.npz', feature_array = feature_array, dataset_class = dataset_class)


# In[10]:


if __name__ == "__main__":
    main()


# In[ ]:




