#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

from __future__ import division, print_function, unicode_literals, absolute_import
import numpy as np
import os
from src.NeuralNetParser import NeuralNetParser
from onnx import *
import scipy.io as sio

class Tf_eran_printer(NeuralNetParser):
    def __init__(self,pathToOriginalFile, OutputFilePath,*vals):
        filename=os.path.basename(os.path.normpath(pathToOriginalFile))
        if ".mat" in filename:
            filename=filename.replace('.mat','')
            self.originalFilename=filename
            self.pathToOriginalFile=pathToOriginalFile
            self.originalFile=open(pathToOriginalFile,"r")
            self.outputFilePath=OutputFilePath
            self.final_output_path=self.print_tf_file(pathToOriginalFile,OutputFilePath)
            self.originalFile.close()
        else: 
            print("error: to print into the .tf format please provide a matfile")
    
    #under construction
    def create_matfile(self):
        pass
    #under construction
    def create_onnx_model(self):
        pass

    def print_tf_file(self,input_path,output_path):
        #load the mat file
        mat_contents = sio.loadmat(input_path, squeeze_me=True)
        #get the weights and biases from the .mat file
        weights=mat_contents['W']
        biases=mat_contents['b']
        act_fcns=mat_contents['act_fcns']
        #correct the last weight matrix shape if the matrix is of rank 1
        if len(weights[-1].shape)==1:
            a=weights[-1].reshape((1,weights[-2].shape[1]))
            weights[-1]=a
        #parse the file 
        f=open(os.path.join(self.outputFilePath,self.originalFilename+".tf"),"w+")
        for i in range( weights.shape[0]):
            f.write(self.parse_act_fcns(act_fcns[i]))
            f.write(np.array2string(weights[i].reshape(weights[i].shape[0],weights[i].shape[1]),separator=', ',max_line_width=1000000).replace('\n', '')+"\n")
            if type(biases[i]) is np.ndarray:
                f.write(np.array2string(biases[i],separator=', ',max_line_width=1000000).replace('\n', '')+"\n")
            else:
                f.write(np.array2string(np.array([biases[i]]),separator=', ',max_line_width=1000000).replace('\n', '')+"\n"+"\n")
        f.close()
        return os.path.join(self.outputFilePath,self.originalFilename+".tf")


        
    #helper function that helps convert activation function name to correct .tf file format
    def parse_act_fcns(self,act_fcn):
        if act_fcn=="relu":
            return "ReLU\n"
        elif act_fcn=="sigmoid":
            return "Sigmoid\n"
        elif act_fcn=="tanh":
            return "Tanh\n"
        else: 
            print("Error unrecognized activation function: ",act_fcn)
            return None

