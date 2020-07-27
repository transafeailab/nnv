#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""


import onnxmltools
from keras.models import load_model
import keras

# Update the input name and path for your Keras model
#keras_model = r'C:\Users\manzand\AnacondaProjects\nnmt\original_networks\MC_16sigX16sigX1tanh.h5'
keras_model = r'C:\Users\manzand\AnacondaProjects\nnmt\original_networks\CartPole_Controller.h5'
jsonfile = r'C:\Users\manzand\AnacondaProjects\nnmt\original_networks\CartPole_Controller.json'

# Load the keras model with json fille
def load_files(jsonfile,keras_model):
    with open(jsonfile, 'r') as jfile:
        model = keras.models.model_from_json(jfile.read())
    model.load_weights(keras_model)	
    return model

# Change this path to the output name and path for the ONNX model
output_onnx_model = r'C:\Users\manzand\AnacondaProjects\nnmt\translated_networks\CartPole_Controller.onnx'

# Load your Keras model w/o json
#model = load_model(keras_model)

# Load your Keras model with json
model = load_files(jsonfile,keras_model)


# Convert the Keras model into ONNX
onnx_model = onnxmltools.convert_keras(model)

# Save as protobuf
onnxmltools.utils.save_model(onnx_model, output_onnx_model)