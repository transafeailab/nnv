#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
from tkinter import messagebox
from pathlib import Path
import os
from src.reluPlexPrinter import reluplexPrinter
from src.sherlockPrinter import sherlockPrinter


class Window(tk.Frame):
    
    
    #Here you create a window class that inherits from the Frame Class. Frame is a class from the tkinter module.
    def __init__(self, master=None):
        #paramters that you want to send through to the Frame class
        tk.Frame.__init__(self, master)
        #reference to the master widget which is the tk window
        self.master=master
        #size of the window
        self.master.geometry("500x300")
        #With that we want then to run init_windo which doesn't yet exist
        self.init_window()
        
    #Creation of init Window
    def init_window(self):
        #changing the title of our master widget 
        self.master.title("NNMP: Neural Network Model Parser")
        #allow the widget to take the full space of the root window
        self.pack(fill=tk.BOTH, expand=1)
        #create an initial directory to search
        self.initial_dir=''
        self.filePickerFormat=''
        self.filePickerName=''
        
        #create a label for the combobox
        labelTop=tk.Label(self, text="Select the type of model file for the neural network")
        labelTop.grid(column=0,row=0)
        #create second label
        label2=tk.Label(self, text="Select output format",justify=tk.LEFT)
        label2.grid(column=0, row=3)
        #create a Combo Box
        self.comboModelSelect= ttk.Combobox(self, values=["Select a model format...","Reluplex (.nnet)", "Sherlock (.txt)"])
        self.comboModelSelect.grid(column=0, row=2)
        self.comboModelSelect.current(0)
        
        self.comboModelSelect.bind("<<ComboboxSelected>>",self.edit_Selectable_Files)
        
        #create output Combo Box
        self.comboOutput=ttk.Combobox(self, values=["Select an output format...","Matfile (.mat)", "Onnx (.onnx)"])
        self.comboOutput.grid(column=0,row=4)
        self.comboOutput.current(0)
        
        
        #create a button to select the neural network model path that will edit the model entry box in the gui
        buttonModelEntry=tk.Button(self, text="Set Model Path", command=self.select_model_file)
        buttonModelEntry.grid(column=1,row=5)
        
        #create an entry so that the user can see which model or modes they hva selected
        self.modelFileEntryDefaultString=tk.StringVar(self, value='Path to model...')
        self.modelFileEntry=tk.Entry(self, state='disabled', textvariable=self.modelFileEntryDefaultString,width=30,disabledbackground= "white")
        self.modelFileEntry.grid(column=0, row=5)
    
        
        #create a button to select the model output path and edit the entry for the output path
        buttonModelOutput=tk.Button(self, text='Set Output Path',command=self.select_output_path)
        buttonModelOutput.grid(column=1, row=6)
        
        #create an entry so that the user can see which directory they have selected
        self.modelOutputDefaultString=tk.StringVar(self, value='Output path...')
        self.modelOutputPath=tk.Entry(self, state='disabled', width=30,textvariable=self.modelOutputDefaultString,disabledbackground= "white")
        self.modelOutputPath.grid(column=0, row=6)
        
    
        
        
        
        
        
        #create a button instance
        convertModelsButton= tk.Button(self,text="Convert", command=self.convert_models)
        #placing the button on my window
        convertModelsButton.grid(column=0,row=7)
    def select_model_file(self):
        if(self.comboModelSelect.get()=="Select a model format..."):
            messagebox.showerror("Error","Please select a model format type")
        else:
            filePath=filedialog.askopenfilename(initialdir=str(Path.home()),title="Select network model file",filetypes = ((self.filePickerName,self.filePickerFormat),("All files",self.AllFiles)))
            if(filePath):
                self.modelFileEntryDefaultString.set(filePath)
                self.initial_dir=os.path.basename(os.path.normpath(filePath))
    def select_output_path(self):
        outputdirectory=filedialog.askdirectory(initialdir=self.initial_dir,title="Select Output Directory")
        if(outputdirectory):
            self.modelOutputDefaultString.set(outputdirectory)
    def convert_models(self):
        if(self.comboModelSelect.get()=="Select a model format..."):
            messagebox.showerror("Error","Please select a model format type")
        elif(self.modelFileEntry.get()=='Path to model...'):
            messagebox.showerror("Error","Please specify the path to the model file")
        elif(self.modelOutputPath.get()=='Output path...'):
            messagebox.showerror("Error","Please specify the directory in which you wish to save the file")
        elif(self.comboOutput.get()=="Select an output format..."):
            messagebox.showerror("Error","Please specify the output format")
        else:
            modelFormat=self.comboModelSelect.get()
            fileOutputFormat=self.comboOutput.get()
            file_path=self.modelFileEntry.get()
            outputdirectory=self.modelOutputPath.get()
            if(modelFormat=="Reluplex (.nnet)" and fileOutputFormat=="Matfile (.mat)"):
                printer=reluplexPrinter(file_path,outputdirectory)
                printer.saveMatfile()
                self.master.destroy()
            elif(modelFormat=="Reluplex (.nnet)" and fileOutputFormat=="Onnx (.onnx)"):
                printer=reluplexPrinter(file_path,outputdirectory)
                printer.create_onnx_model()
                self.master.destroy()
            elif(modelFormat=="Sherlock (.txt)" and fileOutputFormat=="Matfile (.mat)"):
                printer=sherlockPrinter(file_path,outputdirectory)
                printer.saveMatfile()
                self.master.destroy()
            elif(modelFormat=="Sherlock (.txt)" and fileOutputFormat=="Onnx (.onnx)"):
                printer=sherlockPrinter(file_path,outputdirectory)
                printer.create_onnx_model()
                self.master.destroy()
    def edit_Selectable_Files(self,event):
        if(self.comboModelSelect.get()=="Reluplex (.nnet)"):
            self.filePickerFormat="*.nnet"
            self.filePickerName="nnet files"
            self.AllFiles="*.*"
        elif(self.comboModelSelect.get()=="Sherlock (.txt)"):
            self.filePickerFormat="*.txt"
            self.filePickerName="Plain Text Files"
            self.AllFiles="*"
            
        







