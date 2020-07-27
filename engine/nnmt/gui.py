#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Neural Network Verification Model Translation Tool (NNVMT)

@author: 
  Patrick Musau(patrick.musau@vanderbilt.edu) 
  Diego Manzanas Lopez (diego.manzanas.lopez@vanderbilt.edu)
"""

import tkinter as tk
from src import ToolGUI

def main():
    #root window created. Here that would be the only window but you can later have windows within windows
    root=tk.Tk()
    ToolGUI.Window(root)
    root.mainloop()
    
main()
