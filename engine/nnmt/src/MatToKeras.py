#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

import numpy as np
import os 
from keras.models import model_from_json
import scipy.io as sio
from tensorflow import keras
from keras import models, layers


#Load mat file
def load_mat(input_path):
    W = []
    b = []
    a = []
    mat = sio.loadmat(input_path)
    weight = mat['W'].reshape(1,-1)
    bias = mat['b'].reshape(1,-1)
    act = mat['act_fcns']
    for i in range(bias.size):
        W.append(weight[0][i])
        b.append(bias[0][i].reshape(-1,))
        a.append(act[i].strip()) #Strip to reduce blank spaces in string
        
    return W,b,a
# [W,b,a] = load_mat('CartPolecontroller_0403_tanh.mat')

def create_nn(W,b,a):
    model = models.Sequential()
    model.add(layers.Dense(units = len(W[0]), input_dim=(len(W[0].T)), activation = a[0], weights = [W[0].T,b[0].reshape(-1,)]))
    for i in range(len(b)-1):
        model.add(layers.Dense(b[i+1].size, activation = a[i+1], weights = [W[i+1].T,b[i+1].reshape(-1,)]))
        
    return model
def create_nn1(W,b,a):
    model = models.Sequential()
    model.add(layers.Dense(units = len(W[0]), input_shape=(len(W[0].T),), activation = a[0], weights = [W[0].T,b[0].T.reshape(-1,)]))
    for i in range(len(b)-1):
        model.add(layers.Dense(b[i+1].size, activation = a[i+1], weights = [W[i+1].T,b[i+1].T.reshape(-1,)]))
        
    return model
# model = create_nn(W,b,a)

def save_model(model,output_path,filename):
    file_path=os.path.join(output_path, filename+".h5")
    model.save(file_path)
    return file_path
    
def parse_model(input_path,output_path):
    basename=os.path.basename(input_path)
    filename=basename.replace(".mat","")
    W,b,a = load_mat(input_path)
    model = create_nn(W,b,a)
    path=save_model(model,output_path,filename)
    return path
    

"""
SO FAR, THIS HAS ONLY BEEN TESTED WITH ONE EXAMPLE THAT HAS TANH IN THE HIDDEN 
LAYERS, AND ONE OUTPUT LINEAR LAYER
sECOND EXAMPLE TRIED WAS SUCCESFUL, RESHAPE IS KEY FOR THESE THINGS, MAY NEED TO IMPLEMENT SOME OF THAT
IN THE OTHER PARSERS SO THAT WE ARE CONSISTENT WITH DIMENSIONS 

"""

if __name__=='__main__':
  input_path='/home/musaup/Documents/Research/Tools/nnmt/translated_networks/ACASXU_run2a_1_1_batch_2000.mat'
  output_path='/home/musaup/Documents/Research'
  parse_model(input_path,output_path)
