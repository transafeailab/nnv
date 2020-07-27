#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author:  
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
    
"""

### Example ###
#   from src.PytorchModels import SuperResolutionNet  
#   torch_model = SuperResolutionNet(upscale_factor = 3)
#   PytorchPrinterCNN('https://s3.amazonaws.com/pytorch/test_data/export/superres_epoch100-44c6958e.pth',
#   'C:\Users\manzand\AnacondaProjects\nnvmt\translated_networks\resolution.onnx',torch_model,[1,244,244])


#import os
#from torch import nn
import torch.utils.model_zoo as model_zoo
import torch.onnx
#import torch.nn as nn
#import torch.nn.init as init

# Outside in the terminal, need to type the following steps
#   >> python
#   >> import model
#   >> torch_model = model()
#   >> exec(open('PytorchToONNX.py').read()) 
#   >> PytorchPrinterCNN(Weights,OutputFile, torch_model,, InputSize,*names_of_inputs_and_outputs) 

def PytorchPrinterCNN(WeightsFile, OutputFilePath, torch_model, input_size, batch_size = 1 ,inname = ['inputs'], outname = ['outputs']):
    #get the name of the file without the end extension
    #model_url = 'https://s3.amazonaws.com/pytorch/test_data/export/superres_epoch100-44c6958e.pth'
    # torch_model.load_state_dict(model_zoo.load_url(model_url, map_location=map_location))
    torch_model.load_state_dict(model_zoo.load_url(WeightsFile, map_location = 'cpu'))
    torch_model.train(False)
    
    #batch_size = 1
    # input size of the form [channels, height, widht]
    x = torch.randn(batch_size,input_size[0], input_size[1], input_size[2], requires_grad=True)
    
    # Export the model
    torch.onnx.export(torch_model,               # model being run
                      x,                         # model input (or a tuple for multiple inputs)
                      OutputFilePath,   # where to save the model (can be a file or file-like object)
                      export_params=True,        # store the trained parameter weights inside the model file
                      input_names = inname,   # the model's input names
                      output_names = outname) # the model's output names
    exit()

