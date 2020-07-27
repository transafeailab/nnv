#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""
import os
import warnings 
warnings.filterwarnings("ignore", category=UserWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)
from src.reluPlexPrinter import reluplexPrinter
from src.sherlockPrinter import sherlockPrinter
from src.kerasPrinter import kerasPrinter
from src.TensorflowPrinter import TensorflowPrinter
from src.onnxPrinter import onnxPrinter
from src.tf_eran_printer import Tf_eran_printer
from src.nnvmt_exceptions import FileExtensionError, OutputFormatError

#function that decides which tool the model file is 
def decideTool(name,inputPath):
    #get the base name of the path:
    basename=os.path.basename(inputPath)
    if (name=="Reluplex") or (name=="reluplex") or (name=="nnet"):
        #if its from reluplex it will end in .nnet. If not throw an error
        if('.nnet' in basename):
            fileType="Reluplex"
        else:
            raise FileExtensionError("Error: Unrecognized Neural Network File Format (Kyle Julian 2016). Expected filename extension .nnet")
    elif name=="Sherlock" or name=="sherlock":
        #check to see if the input file ends in .txt or nothing
        if(".txt" in basename or len(basename.split("."))==1): 
            fileType="Sherlock"
        else:
            raise FileExtensionError("Error: Unrecognized Sherlock format. Expected filename extension .txt or nothing")
    elif name=="Keras" or name=="keras":
        #check to see if the files provided are correct
        if('.h5' in basename or '.hdf5' in basename):
            fileType="Keras"
        else:
            raise FileExtensionError("Error: Unrecognized Keras format. Expected filename extension is .h5")
    elif name =="Tensorflow" or name == "tensorflow":
        #check to see if the files provided are correct
        #print(basename)
        if('heckpoin' in basename):
            fileType="Tensorflow"
        else:
            raise FileExtensionError("Error: Unrecognized Tensorflow format. Expected filename to be 'checkpoint'")
    elif name == 'ONNX' or name == 'onnx':
        #check to see if the provided files are correct
        if ('.onnx' in basename):
            fileType = 'ONNX'
        else:
            raise FileExtensionError("Error: Unrecognized ONNX format. Expected filename extension is .onnx")
    elif name=="mat" or name=="Matfile":
        if('.mat' in basename):
            fileType="mat"
        else:
            raise FileExtensionError("Error: Unrecognized Matfile format. Expected filename extension is .mat")
    else:
        raise NameError("Error: Unrecognized input format. Tools currently supported (Reluplex, Sherlock)")
    return fileType


#function that makes sure tensorflow comes with checkpoint file
#def verify_checkpoint(filepath):
#    if not filepath:
#        raise NameError("Error: Please provide the path to the checkpoint file for the tensorflow model you are attempting to load.")
#    else:
#        basename=os.path.basename(filepath)
#        if basename=="checkpoint":
#            truepath=filepath.replace(basename,"")
#        else:
#            truepath=filepath
#    listed_directory=os.listdir(truepath)
#    if "checkpoint" not in listed_directory:
#        raise NameError("Error: Please provide the path to the checkpoint file for the tensorflow model you are attempting to load.")
#    else: 
#        return truepath



#function that checks if json file is correct
def checkJson(filepath):
    if filepath:
        basename=os.path.basename(filepath)
        if('.json' in basename):
            return 1
        else:
            return 0
    else:
        return 2


#function that chooses which printer to use for keras
def chooseKeras(toolname,printer):
    if toolname=="mat":
        printer.create_matfile()
    elif toolname=="onnx":
        printer.create_onnx_model()
#function that performs Keras printing 
def kerasPrinting(checkNum, inputPath, outputpath, jsonFile,toolname):
    if(checkNum==2):
        printer=kerasPrinter(inputPath,outputpath)
        chooseKeras(toolname,printer)
    elif(checkNum==1):
        printer=kerasPrinter(inputPath,outputpath,jsonFile)
        chooseKeras(toolname,printer)
    else: 
        print("Error: Unrecognized Keras Json format. Expected filename extension is .json")
        printer=None
    return printer
    
#function that decides what the output file should be
def decideOutput(name):
    if name=="mat" or name=="Mat" or name=='Matfile' or name=="matfile":
        outputType="mat"
    elif name=="onnx" or name=="ONNX":
        outputType="onnx"
    elif name=="eran" or name=="ERAN":
        outputType="eran"
    else:
        raise OutputFormatError("Error: Unrecognized output format. Output formats currently supported (Onnx, Mat)")
    return outputType

#function that hadles the parsing and printing
def parseHandler(toolName,outputFormat, inputPath, outputpath,jsonFile):
    if(toolName=="Reluplex" and outputFormat=="mat"):
        printer=reluplexPrinter(inputPath,outputpath)
        printer.create_matfile()
    elif(toolName=="Reluplex" and outputFormat=="onnx"):
        printer=reluplexPrinter(inputPath,outputpath)
        printer.create_onnx_model()
    elif(toolName=="Sherlock" and outputFormat=="mat"):
        printer=sherlockPrinter(inputPath,outputpath)
        printer.create_matfile()
    elif(toolName=="Sherlock" and outputFormat=="onnx"):
        printer=sherlockPrinter(inputPath,outputpath)
        printer.create_onnx_model()
    elif(toolName=="Tensorflow" and outputFormat=="mat"):
#        jsonFile=verify_checkpoint(jsonFile)
        printer=TensorflowPrinter(inputPath,outputpath)
        printer.create_matfile()
    elif(toolName=="ONNX" and outputFormat=='mat'):
        printer=onnxPrinter(inputPath,outputpath)
        printer.create_matfile()
    elif(toolName=="Keras" and outputFormat=="mat"):
        #check the json files
        checkNum=checkJson(jsonFile)
        printer=kerasPrinting(checkNum, inputPath, outputpath, jsonFile,"mat")
    elif(toolName=="Keras" and outputFormat=="onnx"):
        checkNum=checkJson(jsonFile)
        printer=kerasPrinting(checkNum, inputPath, outputpath, jsonFile,"onnx")
    elif (toolName=="mat" and outputFormat=="eran"):
        printer=Tf_eran_printer(inputPath,outputpath)
    else:
        print("Internal Handling Error: ",toolName,outputFormat,inputPath,outputpath)
        printer=None
    return printer
