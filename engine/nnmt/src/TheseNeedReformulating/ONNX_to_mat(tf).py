#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""
import onnx
import tensorflow as tf
from onnx_tf.backend import prepare
import numpy as np
import scipy.io as sio

input_path = r'C:\Users\manzand\AnacondaProjects\nnmt\translated_networks\CartPole_Controller.onnx' # Comes from keras
#input_path = r'C:\Users\manzand\AnacondaProjects\nnmt\ONNX\SingleCarController.onnx' # Comes from matlab
#output_path = r'ACC_controller_3_20.mat'

# Load ONNX model
def load_model(input_path):
    onnx_model = onnx.load(input_path)  # load onnx model
    tf_rep = prepare(onnx_model)
    return tf_rep
model = load_model(input_path)

#Get the dictionary and list of model's tensors
def inform(model):
    #initialize empty lists 
    temp = []
    tensor_list = []
    tensor_dict = model.tensor_dict # Dictionary of tensors
    for key, value in tensor_dict.items(): # Get names of tensors in a list
        temp = [key,value]
        tensor_list.append(temp)
    return tensor_dict,tensor_list
[td,tl] = inform(model)

# Get weight, bias and activation functions
def parameters(tensor_dict,tensor_list,model):
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
            W.append(np.float64(sess.run(tensor_dict[tensor_list[i][0]]).T))
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
[W,b,act_fcns] = parameters(td,tl,model)

# Get size parameters of neural network
def net_size(W,b): 
    # Get number of input, output and layer 
    number_of_inputs = np.int64(len(W[0].T))
    number_of_outputs = np.int64(b[-1].size)
    number_of_layers = np.int64(len(b))
    # Get layer sizes
    layer_sizes = []
    for i in range(len(b)):
        layer_sizes.append(np.int64(b[i].size))
    return number_of_inputs,number_of_outputs,number_of_layers,layer_sizes
[ni,no,nl,ls] = net_size(W,b)

def reshape(W,b):
    if len(b[0]) != len(W[0]):
        for i in range(len(W)):
            W[i] = W[i].T
    return W,b
[w,b] = reshape(W,b)
        

# Save the nn information in a mat file
def save_nn_mat_file(W,b,lfs,output_path):
    nn1 = dict({'W':W,'b':b,'act_fcns':lfs})
    sio.savemat(output_path, nn1)
#save_nn_mat_file(W,b,lfs,output_path)

# parse the nn imported ONNX with tensorflow backend
def parse_nn(input_path,output_path):
    model = load_model(input_path)
    [tensor_dict,tensor_list] = inform(model)
    [W,b,lfs] = parameters(tensor_dict,tensor_list,model)
#    [ni,no,nls,lsize] = net_size(W,b)
    save_nn_mat_file(W,b,lfs,output_path)

#parse_nn(input_path,output_path)

