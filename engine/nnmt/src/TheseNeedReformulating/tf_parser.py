#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

import time
import pandas as pd
import numpy as np
import keras as kr
from sklearn.utils import shuffle
from matplotlib import pyplot as plt
import tensorflow as tf
from tensorflow.python.training import checkpoint_utils as cp
import scipy.io as sio


tf.reset_default_graph()

filename = 'example3'
savefile = 'example3'
nn = 'example3'

# load the parameters and models
with tf.Session() as sess:
    new_saver = tf.train.import_meta_graph(filename+'.meta')
    new_saver.restore(sess, tf.train.latest_checkpoint('./'))
    w = tf.trainable_variables() # create list of weights and biases (tf variables)
    w = sess.run(w) # convert the list of tf variables of w to np arrays
#    graph_def = sess.graph.as_graph_def(add_shapes=True)
#    node_list = graph_def.node
    w1 = sess.graph.get_operations() #gets all the operations done in the network
    #w2 = sess.graph.get_all_collection_keys()
    #w3 = sess.graph.get_operation_by_name('Sigmoid')

# Get activation functions
def get_layers(w1):
    lys = []
    for i in range(len(w1)):
        if 'igmoid' in w1[i].type:
            if w1[i].name == w1[i].type:
                lys.append(w1[i].type)
            else:
                for j in range(len(w)):
                    if w1[i].name == w1[i].type+'_'+str(j):
                        lys.append(w1[i].type)
        elif 'elu' in w1[i].type:
            if w1[i].name==w1[i].type:
                lys.append(w1[i].type)
            else:
                for j in range(len(w)):
                    if w1[i].name == w1[i].type+'_'+str(j):
                        lys.append(w1[i].type)
        elif 'anh' in w1[i].type:
            if w1[i].name==w1[i].type:
                lys.append(w1[i].type)
            else:
                for j in range(len(w)):
                    if w1[i].name == w1[i].type+'_'+str(j):
                        lys.append(w1[i].type)
        elif 'oft' in w1[i].type:
            if w1[i].name==w1[i].type:
                lys.append(w1[i].type)
            else:
                for j in range(len(w)):
                    if w1[i].name == w1[i].type+'_'+str(j):
                        lys.append(w1[i].type)
#    lys = dict({'lys':lys})
    return lys
#lys = get_layers(w1)

# Get the size of the network
def get_shape(filename):
    a = cp.list_variables(filename)
    if a[0][0] == 'Variable':
        ni = a[0][1][0] # number of inputs
        no = a[-1][1][0] # number of outputs (-2) used to access the last weight output size of the list... -1 accesses the bias 
    else:
        ai = []
        bi = []
        for i in range(len(a)):
            if 'w' in a[i][0]:
                ai.append(a[i])
            elif 'b'in a[i][0]:
                bi.append(a[i])
            else:
                print('Names assigned to the variables cannot be recognized')
        ni = ai[0][1][1] 
        no = ai[-1][1][0]
    nl = int(len(a)/2) # number of layers
    return ni,no,nl
#[ni,no,nl] = get_shape(filename)
#
# a1 = cp.load_variable('example1','Variable_1') #another way of accessing the values of the variables
#graph_def = sess.graph.as_graph_def(add_shapes=True)
#node_list = graph_def.node

# get the weights and biases of the network
def get_parameters(w):
    W = [] # weights
    b = [] # bias
    lsize = []
    lsl = []
    bb = []
    for i in range(int(len(w)/2)):
        W.append(w[2*i])
        b.append(w[2*i+1])
        bb.append(list(b[i].T))
#    W = np.array(W)
#    b = np.array(b)
        lsize.append(np.shape(W[i]))
        lsl.append(lsize[i][1]) #number of neurons in each layer
    if len(lsize) == 1:
        n = lsl # number of neurons (total)
    else:
        n = sum(lsl)

#    bb = [list(b[0].T),list(b[1].T)]
#    bb = bb
    return W,bb,lsl,n
#[W,b,lsize,n] = get_parameters(w)

def save_nnmat_file(ni,no,nl,n,lsize,W,b,lys):
    nn1 = dict({'number_of_inputs':ni,'number_of_outputs':no ,'number_of_layers':nl,
                'number_of_neurons':n,'layer_sizes':lsize,'W':W,'b':b,'types_of_layers':lys})
    sio.savemat(savefile+'.mat', mdict={nn:nn1})
#save_nnmat_file(ni,no,nl,n,lsize,W,b,lys)

# parse the nn imported from keras as json and h5 files
def parse_nn(filename,w,w1):
    [ni,no,nl] = get_shape(filename)
    lys = get_layers(w1)
    [W,b,lsize,n] = get_parameters(w)
    save_nnmat_file(ni,no,nl,n,lsize,W,b,lys)
        
parse_nn(filename,w,w1)

sess.close()