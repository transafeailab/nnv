#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

from __future__ import print_function
import argparse
import os
import warnings
warnings.filterwarnings("ignore", category=UserWarning)
warnings.filterwarnings("ignore", category=DeprecationWarning)
os.environ['KMP_WARNINGS'] = 'FALSE'
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3'
from tensorflow.python.util import deprecation
deprecation._PRINT_DEPRECATION_WARNINGS = False
from src.nnvmt_handlers import decideTool, decideOutput, parseHandler

#function that gets input format from the user
def commandLineInterface():
    #create a commmand line tool for NNMT using argparse 
    ap=argparse.ArgumentParser(description="Neural Network Model Translation Tool")
    
    #add argument for input file path
    ap.add_argument("-i","--inputFile", required=True, help="path to the input file",dest="input")
    #add argument for output path
    ap.add_argument("-o","--outputFile", required=True, help="output file path",dest="output")
    #add argument for the input file type
    ap.add_argument("-t","--tool", required=True, help='input file type i.e (Reluplex,Keras...)',dest="tool")
    #add argument for the format you want the input file to be translated into
    ap.add_argument("-f","--format", help='output format to be translated to default: matfile (.mat)',dest="outputFormat",default="mat")
    #add optional argument for Keras json files
    ap.add_argument("-j","--json", help='Optional json model for Keras models',dest="config",default=None)
    #parses the arguments and stores them in a dictionary
    args=vars(ap.parse_args())
    return args

#parse aguments
def parseArguments(arguments):
    inputPath=arguments["input"]
    outputPath=arguments["output"]
    inputFileType=arguments["tool"]
    outputFileType=arguments["outputFormat"]
    jsonFile=arguments["config"]
    
    #decideWhichTool
    toolName=decideTool(inputFileType,inputPath)
    #decide which outputFormat
    if(toolName):
        outputFormat=decideOutput(outputFileType)
    #if both names exist then parse the files using the correct printers
    if(toolName and outputFormat):
        parseHandler(toolName,outputFormat,inputPath,outputPath,jsonFile)
        
if __name__=='__main__':
    items=commandLineInterface()
    parseArguments(items)
    

