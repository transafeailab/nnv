Pytorch will be run in a slightly different manner due to posibilities of using pretrained models whose architecture is not saved in any specific files and need to be imported.

The steps to follow to convert a Pytorch model are the following:

1) Open a terminal in the nnvmt directory

2) Execute python

  >> python

3) Import model
 
  >> import NN_Model or from XXXX import NN_Model

4) Load model

  >> torch_model = NN_Model(*args)

5) Run Pytorch to ONNX parser file

  >> exec(open(r'src\TheseNeedReformulating\PytorchToONNX.py').read())

6) Convert the model 

  >> PytorchPrinterCNN(WeightsFile, OutputFilePath, torch_model, input_size, batch_size = 1 ,inname = ['inputs'], outname = ['outputs'])

  ### Notes

	- WeightsFile = 'xxxx.pth'

	- OutFilePath = '.../model.onnx'

	- torch_model = torch_model

	- input_size = [channels, height, width]

	- batch_size = optional argument, set to 1 as default

	- inname = name of inputs (optional), set to ['inputs'] as default value

	- outname = name of outputs (optional), set to ['outputs'] as default value