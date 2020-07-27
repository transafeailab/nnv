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
import onnxmltools

import tensorflow as tf
if type(tf.contrib) != type(tf): tf.contrib._warning = None
import h5py as h5
import json
from pprint import pprint
from tensorflow.keras.models import load_model as loadmodel
import keras
from keras import models
from keras.initializers import glorot_uniform, glorot_normal
from keras.models import load_model
from keras.models import model_from_json
from keras.utils import *
import warnings 
warnings.filterwarnings("ignore", category=UserWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)

#abstract class for keras printers
class kerasPrinter(NeuralNetParser):
    #Instantiate files and create a matfile
    def __init__(self,pathToOriginalFile, OutputFilePath, *vals):
        #get the name of the file without the end extension
        filename=os.path.basename(os.path.normpath(pathToOriginalFile))
        filename=filename.replace('.h5','')
        filename=filename.replace('.hdf5','')
        #save the filename and path to file as a class variable
        self.originalFilename=filename
        self.pathToOriginalFile=pathToOriginalFile
        self.originalFile=open(pathToOriginalFile,"r")
        self.outputFilePath=OutputFilePath
        #if a json file was not specified use the first style parser 
        #otherwise use the second style of parser
        if not vals:
            self.no_json=True
        else:
            self.no_json=False
            self.jsonFile=vals[0]
            

    #function for creating the matfile
    def create_matfile(self):
        if self.no_json:
            self.final_output_path=self.parse_nn_wout_json(self.pathToOriginalFile)
        else:
            self.final_output_path=self.parse_nn(self.jsonFile,self.pathToOriginalFile)
        self.originalFile.close()

    #function for creating an onnx model
    def create_onnx_model(self):
        # Convert the Keras model into ONNX
        if self.no_json:
            model = models.load_model(self.pathToOriginalFile)
        else:
            model = self.load_files(self.jsonFile,self.pathToOriginalFile) 
        self.final_output_path=os.path.join(self.outputFilePath, self.originalFilename)+'.onnx'
        onnx_model = onnxmltools.convert_keras(model)
        # Save as protobuf
        onnxmltools.utils.save_model(onnx_model, self.final_output_path)
        self.originalFile.close()
    
    # Load the plant with parameters included
    def load_files(self, modelfile,weightsfile):
    	with CustomObjectScope({'GlorotUniform': glorot_uniform()}):
            with CustomObjectScope({'GlorotNormal': glorot_normal()}):
                with open(modelfile, 'r') as jfile:
                    model = keras.models.model_from_json(jfile.read())
                model.load_weights(weightsfile)
    	return model
    #model = load_files(modelfile,weightsfile)
    
    #Load the size of the plant
    def get_shape(self, model):
        nl = np.int64(len(model.layers)) # number of all defined layers in keras
        ni = model.get_input_shape_at(0)
        ni = np.int64(ni[1])
        no = model.get_output_shape_at(0)
        no = np.int64(no[1])
        return nl,ni,no
    #[nl,ni,no] = get_shape(model)
    
    def get_layers(self,model,nl):
        config = model.get_config()
        if type(config)==list:
            lys = [] #list of types of layers in the network
            for i in range(0,nl):
                if 'class_name' in config[i]:
                    lys.append(config[i]['class_name']) 
            lfs = [] #list of activation functions
            for i in range(0,nl):
                if 'activation' in config[i]['config']:
                    lfs.append(config[i]['config']['activation'])
                elif 're_lu' in config[i]['config']:
                    if (config[i]['config']['max_value'] == 1.0 and config[i]['config']['threshold'] == 0.0): 
                        lfs.append('relu1')
                    elif (config[i]['config']['max_value'] == 1.0 and config[i]['config']['threshold'] == -1.0):
                        lfs.append('relu2')
        if type(config)==dict:
            l = config['layers']
            lys = []
            for i in range(0,nl):
                if 'class_name' in l[i]:
                    lys.append(l[i]['class_name'])
            lfs = []
            for i in range(0,nl):
                if 'activation' in l[i]['config']:
                    lfs.append(l[i]['config']['activation'])
                elif 're_lu' in l[i]['config']['name']:
                    if (l[i]['config']['max_value'] == 1.0 and l[i]['config']['threshold'] == 0.0): 
                        lfs.append('relu1')
                    elif (l[i]['config']['max_value'] == 1.0 and l[i]['config']['threshold'] == -1.0):
                        lfs.append('relu2')
                    else:
                        lfs.append('relu')
        return(lys,lfs)
    #[lys,lfs] = get_layers(model,nl)   
        
    # Load the size of individual layers and total neurons
    def get_neurons(self,model,nl):
        config = model.get_config()
        if type(config)==dict:
            l = config['layers'] #get the list of layers
            lsize=[]
            for i in range(0,nl):
                if 'units' in l[i]['config']:
                    lsize.append(l[i]['config']['units']) # size of each layer
                    n = np.int64(sum(lsize)) #total number of neurons in NN
        elif type(config)==list:
            lsize=[]
            for i in range(0,nl):
                if 'units' in config[i]['config']:
                    lsize.append(config[i]['config']['units'])
                    n = np.int64(sum(lsize))
        nls = np.int64(len(lsize)) #true number of layers 
        return lsize,n,nls
    #[lsize,n,nls] = get_neurons(model,nl)
    
    def get_parameters(self, model,nl,nls):
        [lys,lfs] = self.get_layers(model,nl)
        w = model.get_weights()
        W = [] #matrix of weights
        b = [] #matrix of biases
        i=0
        j=0
        while (i < nl) and (j < nls+1):
    #        while j < nls:
            if lys[i]=='Activation':
                W.append(0)
                b.append(0)
                i = i+1
            elif lys[i]=='Dense':
                W.append(np.float64(w[2*j].T))
                b.append(np.float64(w[2*j+1].reshape(-1,1)))
                j = j+1
                i = i+1
            else:
                i = i+1 
        return W,b
    #[W,b] = get_parameters(model,nl,nls)

    def fix_activations(self,lys,lfs):
        acts = []
        for i in range(len(lys)-2):
            if (lys[i] == 'Dense' and lys[i+1] =='Dense'):
                acts.append(lfs[i])
            elif lys[i] != 'Dense':
                acts.append(lfs[i])    
        acts.append(lfs[len(lys)-1])
        return acts
        
    # Save the nn information in a mat file
    def save_nnmat_file(self,model,ni,no,nls,n,lsize,W,b,lys,lfs):
        nn1 = dict({'W':W,'b':b,'act_fcns':lfs})
        sio.savemat(os.path.join(self.outputFilePath, self.originalFilename+".mat"),  nn1)
        return os.path.join(self.outputFilePath, self.originalFilename+".mat")
    
    # parse the nn imported from keras as json and h5 files
    def parse_nn(self, modelfile,weightsfile):
        model = self.load_files(modelfile,weightsfile)
        [nl,ni,no] = self.get_shape(model)
        [lys,lfs] = self.get_layers(model,nl)
        #lfs = self.fix_activations(lys,lfs)
        [lsize,n,nls] = self.get_neurons(model,nl)
        [W,b] = self.get_parameters(model,nl,nls)
        return self.save_nnmat_file(model,ni,no,nls,n,lsize,W,b,lys,lfs)
        
    def parse_nn_wout_json(self, modelfile):
        with CustomObjectScope({'GlorotUniform': glorot_uniform()}):
            with CustomObjectScope({'GlorotNormal': glorot_normal()}):
                try:
                    model = models.load_model(modelfile)
                except:
                    pass
                try: 
                    model = loadmodel(modelfile)
                except:
                    print('We cannot load the model, make sure the keras file was saved in a supported version')
                    print(err)
        [nl,ni,no] = self.get_shape(model)
        [lys,lfs] = self.get_layers(model,nl)
        #lfs = self.fix_activations(lys,lfs)
        [lsize,n,nls] = self.get_neurons(model,nl)
        [W,b] = self.get_parameters(model,nl,nls)
        return self.save_nnmat_file(model,ni,no,nls,n,lsize,W,b,lys,lfs)
