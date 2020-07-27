# -*- coding: utf-8 -*-
"""
Created on Wed Mar 20 11:49:27 2019

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
import tensorflow as tf
#from tensorflow.python.training import checkpoint_utils as cp


#abstract class for keras printers
class TensorflowPrinter(NeuralNetParser):
    #Instantiate files and create a matfile
    def __init__(self,pathToCkpt, OutputFilePath):
        #get the name of the file without the end extension
        #filename=os.path.basename(os.path.normpath(pathToCkpt))
        #filename=filename.replace('checkpoint','')
        #save the filename and path to file as a class variable
        #self.originalFilename=filename
        self.outputFilePath=OutputFilePath
        self.pathToCkpt = pathToCkpt
        tf.reset_default_graph()
        
            

    #function for creating the matfile
    def create_matfile(self):
        self.final_output_path=self.parse_nn(self.pathToCkpt)
        #self.originalFile.close()
    #function for creating an onnx model
    def create_onnx_model(self):
        print("Sorry this is still under development")
        
    # load the parameters and models
    def load_network(self,pathckpt):
        f = open(pathckpt,'r')
        f = f.readline()
        f = f.split('"')
        b = pathckpt.replace('checkpoint','')
        filename = b+f[1]+'.meta'
        self.originalFilename = f[1]
        with tf.Session() as sess:
            new_saver = tf.train.import_meta_graph(filename)
            new_saver.restore(sess, tf.train.latest_checkpoint(b))
            w = tf.trainable_variables() # create list of weights and biases (tf variables)
            a = []
            #v_names = []
            for i in w:
                if 'optimization' not in i.name:
                    if 'action-exploration' not in i.name:
                        a.append(i)
                        #v_names.append(i.name)
            w = sess.run(a) # convert the list of tf variables of w to np arrays
            w1 = sess.graph.get_operations() #gets all the operations done in the network
            a = []
            for i in w1:
                if 'optimization' not in i.name:
                    if 'initial' not in i.name:
                        if 'gradient' not in i.name:
                            a.append(i)
        sess.close()    
        return w,a    
    
    def get_layers(self,w,w1):
        lys = []
        names = [] # Store names to check later for connections and no duplications
        inp = []
        for i in range(len(w1)):
            if 'Sigmoid' == w1[i].type:
                lys.append(w1[i].type)
                names.append(w1[i].name)
                inp.append(w1[i].node_def.input)
            elif 'Relu' == w1[i].type:
                lys.append('relu')
                names.append(w1[i].name)
                inp.append(w1[i].node_def.input)
            elif 'Tanh' == w1[i].type:
                lys.append(w1[i].type)
                names.append(w1[i].name)
                inp.append(w1[i].node_def.input)
            elif 'MatMul' == w1[i].type:
                if w1[i+2].type not in ['Sigmoid','Relu','Tanh','Softmax']:
                    lys.append(w1[i].type)
                    names.append(w1[i].name)
                    inp.append(w1[i].node_def.input)
            elif 'Softmax' == w1[i].type:
                lys.append(w1[i].type)
                names.append(w1[i].name)
                inp.append(w1[i].node_def.input)
    
        return lys,names,inp
    
    # All activation functions in tf have a "linear" layer prior to it, 
    # need to remove those from the list
    def check_layers(self,l_names,lys,inp_con):
        a = []
        acts = []
        count = 0
        for i in l_names:
            a.append(i.split('/'))
        i = 0
        while i < len(lys)-1:
            if lys[i] == 'MatMul':
                bb = set(a[i]).symmetric_difference(set(a[i+1]))
                if not any(n in 'linear' for n in bb):
                    acts.append('linear')
                else:
                    inp_con.pop(i+1-count)
                    l_names.pop(i-count)
                    count+=1
                i+=1
            else:
                acts.append(lys[i])
                i+=1
        # Add last layer
        if lys[i] == 'MatMul':
            acts.append('linear')
        else:
            acts.append(lys[i])
        return acts
        
    # from the list of all trainable variables, divide them into W and b
    def get_parameters(self,w):
        W = [] # weights
        b = [] # bias
        for i in range(int(len(w)/2)):
            W.append(np.float64(w[2*i]))
            b.append(np.float64(w[2*i+1].reshape(-1,1)))
        return W,b,
        
    # establish the connections from layer to layer
    def layer_connections(self,l_names,inp_con):
        inputs = [0]
        for i in range(1,len(l_names)):
            if not any(n in inp_con[i][0] for n in l_names):
                inputs.append(i+1)
            else:
                inputs.append(l_names.index(inp_con[i][0])+1)
        return inputs           
    
    # reorganize W and b based on connections
    def reorg(self,inputs,W,b,acts):
        i = 0
        count = 0
        while count < len(inputs)-1:
            if inputs[i] == inputs[i+1]:
                W[i] = np.concatenate([W[i],W.pop(i+1)],1)
                b[i] = np.concatenate([np.array(b[i]).reshape(-1,1),np.array(b.pop(i+1)).reshape(-1,1)],0)
                #b[i] = b[i].T
                acts.pop(i+1)
                count+=1
            else:
                i+=1
                count+=1
        return W,b,acts
    
    def reshape(self,W,b):
        if len([b[0]]) != len(W[0]):
            for i in range(len(W)):
                W[i] = W[i].T
        return W,b
    
    # Save the neural network to mat file
    def save_nnmat_file(self,W,b,acts):
        nn1 = dict({'W':W,'b':b,'act_fcns':acts})
        sio.savemat(os.path.join(self.outputFilePath, self.originalFilename+".mat"), nn1)
        return os.path.join(self.outputFilePath, self.originalFilename+".mat")
    #save_nnmat_file(Wf,bf,actsf)
    
    # parse the nn imported from keras as json and h5 files
    def parse_nn(self,pathckpt):
        [w,w1] = self.load_network(pathckpt)
        [lys,l_names,inp_con] = self.get_layers(w,w1)
        acts = self.check_layers(l_names,lys,inp_con)
        [W,b] = self.get_parameters(w)
        inputs = self.layer_connections(l_names,inp_con)
        [Wf,bf,actsf] = self.reorg(inputs,W,b,acts)
        [W,b] = self.reshape(W,b)
        return self.save_nnmat_file(Wf,bf,actsf)
        

