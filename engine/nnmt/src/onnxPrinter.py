#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

from __future__ import division, print_function, unicode_literals
import numpy as np
import os
from src.NeuralNetParser import NeuralNetParser
import scipy.io as sio
from onnx import *
import onnx
import tensorflow as tf
from onnx_tf.backend import prepare



#abstract class for ONNX printers
class onnxPrinter(NeuralNetParser):
    #function for creating the matfile
    #get the name of the file without the end extension
    def __init__(self,pathToOriginalFile, OutputFilePath,*vals):
        filename = os.path.basename(os.path.normpath(pathToOriginalFile))
        filename=filename.replace('.onnx','')
        #save the filename and path to file as a class variable
        self.originalFilename=filename
        # save original input to pass as an argument to the parse function
        self.pathToOriginalFile=pathToOriginalFile
        self.originalFile=open(pathToOriginalFile,"r")
        self.outputFilePath=OutputFilePath
        tf.reset_default_graph()
    
    #function for creating the matfile
    def create_matfile(self):
        self.final_output_path=os.path.join(self.outputFilePath, self.originalFilename+".mat")
        self.parse_nn(self.pathToOriginalFile,self.final_output_path)
        self.originalFile.close()

    # Load ONNX model
    def load_model(self,input_path):
        onnx_model = onnx.load(input_path)  # load onnx model
        tf_rep = prepare(onnx_model)
        return tf_rep
    
    #Get the dictionary and list of model's tensors
    def inform(self,model):
        #initialize empty lists 
        temp = []
        tensor_list = []
        tensor_dict = model.tensor_dict # Dictionary of tensors
        for key, value in tensor_dict.items(): # Get names of tensors in a list
            temp = [key,value]
            tensor_list.append(temp)
        return tensor_dict,tensor_list
    
    # Get weight, bias and activation functions
    def parameters(self,tensor_dict,tensor_list,model):
        # Get graph and initialize session
        gr = model.graph
        sess = tf.Session(graph = gr)
        #empty lists to store weights, biases and act functions
        W = []
        b = []
        act_fcns = []
        # After creating session, we will get the weights, activation layers and bias
        for i in range(len(tensor_dict)):
            if 'W' in tensor_list[i][0]:
                W.append(np.float64(sess.run(tensor_dict[tensor_list[i][0]])))
            elif 'B' in tensor_list[i][0]:
                b.append(np.float64(sess.run(tensor_dict[tensor_list[i][0]])).reshape(-1,1))
            elif 'elu' in tensor_list[i][1].op.name:
                act_fcns.append('relu')
            elif 'inear' in tensor_list[i][1].op.name:
                act_fcns.append('linear')
            elif 'anh' in tensor_list[i][1].op.name:
                act_fcns.append('tanh')
            elif 'igmoid' in tensor_list[i][1].op.name:
                act_fcns.append('sigmoid')
        return W,b,act_fcns
    
    def reshape(self,W,b):
        if len(b[0]) != len(W[0]):
            for i in range(len(W)):
                W[i] = W[i].T
        return W,b

    
    # Save the nn information in a mat file
    def save_nn_mat_file(self,W,b,lfs,output_path):
        nn1 = dict({'W':W,'b':b,'act_fcns':lfs})
        sio.savemat(output_path, nn1)
    
    # parse the nn imported ONNX with tensorflow backend
    def parse_nn(self,input_path,output_path):
        model = self.load_model(input_path)
        [tensor_dict,tensor_list] = self.inform(model)
        [W,b,lfs] = self.parameters(tensor_dict,tensor_list,model)
        [W,b] = self.reshape(W,b)
        self.save_nn_mat_file(W,b,lfs,output_path)