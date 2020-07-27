%% Create a layer graph for a SeriesNetwork and DAG Network
%clc;clear

% Add all the paths to the folders with benchmarks (specific just for my computer (Diego Manzanas))
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Abalone_rings');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Boston_housing');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Engine');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Heat_exchanger');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Pollution_mortality');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Valve');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Torcs');
% addpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Mnist');


%% Load mat model to convert
% load('mnist5x50.mat');
% filesave = 'trials'; % name to save the network as
% file = mnist_5x50;

% Remove path from the MATLAB paths after loading the network (specific just for my computer (Diego Manzanas))
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Abalone_rings');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Boston_housing');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Engine');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Heat_exchanger');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Pollution_mortality');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Relu_benchmarks\Valve');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Torcs');
% rmpath('C:\Users\manzand\Documents\MATLAB\Verification tool NN\Mnist');

%% Get the layers type for the network
% Define input first and start the graph
% lin = imageInputLayer([1 double(file.number_of_inputs)], 'Name', 'input','AverageImage',ones([1 double(file.number_of_inputs)]));
lin = imageInputLayer([1 size(file.W{1},2)], 'Name', 'input','AverageImage',ones([1 size(file.W{1},2)]));
lgraph = layerGraph;
lgraph = addLayers(lgraph,lin);
% lout = regressionLayer('Name','output');
% Convert the hidden layers
% for i=1:file.number_of_layers
%     % if file.act_functions{i} == "relu" % For the ones created in matlab
%     if string(file.activation_fcns(i,:)) == "relu" % For the ones parsed from Keras
%         layer = [fullyConnectedLayer(file.layer_sizes(i),'Name','Operation_'+string(i)) % add an 's' to the end of layer_size for keras benchmarks
%         reluLayer('Name','relu_'+string(i))];
%         disp('Relu layer')
%     % elseif file.act_functions{i} == "linear" % For matlab benchmarks
%     elseif string(file.activation_fcns(i,:)) == "linear" % For keras benchmarks
%         layer = fullyConnectedLayer(file.layer_sizes(i),'Name','linear_'+string(i)); % add an 's' to the end of layer_size for keras benchmarks
%         disp('Linear layer')
%     end
%     lgraph = addLayers(lgraph,layer);
%     %clear layer;
% end
%% For files created in matlab
% Need to be 
for i=1:file.number_of_layers
    % if file.activation_fcns{i} == "relu" % For the ones created in matlab
    if string(file.activation_fcns(i,:)) == "relu  " % For the ones parsed from keras
        layer = [fullyConnectedLayer(file.layer_sizes(i),'Name','Operation_'+string(i)) % add an 's' to the end of layer_size for keras benchmarks
        reluLayer('Name','relu_'+string(i))];
        disp('Relu layer')
    % elseif file.activation_fcns{i} == "linear" % For matlab benchmarks
    elseif string(file.activation_fcns(i,:)) == "linear" % For keras benchmarks
        layer = fullyConnectedLayer(file.layer_sizes(i),'Name','linear_'+string(i)); % add an 's' to the end of layer_size for keras benchmarks
        disp('Linear layer')
    end
    lgraph = addLayers(lgraph,layer);
    %clear layer;
end

% Add output layer
lout = regressionLayer('Name','output');
lgraph = addLayers(lgraph,lout);


%% Define layers of network
% layers = [...
%     imageInputLayer([1 double(file.number_of_inputs)], 'Name', 'input','AverageImage',[1 double(file.number_of_inputs)])
%     fullyConnectedLayer(file.layer_size(1),'Name','l1')
%     reluLayer('Name','relu_1')
%     fullyConnectedLayer(file.layer_size(2),'Name','l2')
%     reluLayer('Name','relu_2')
%     fullyConnectedLayer(file.layer_size(3),'Name','l3')
%     reluLayer('Name','relu_3')
%     regressionLayer('Name','output')];

% %% Create graph and visualize it
% lgraph = layerGraph(layers);
% newlays = lgraph.Layers;
% newlgraph = layerGraph;
% newlgraph = addLayers(newlgraph,newlays);
% figure
% plot(newlgraph)
%% Add weigths and bias values to layers
% for i = 1:1:file.number_of_layers
%     layers(2*i).Weights = file.W{i};
%     layers(2*i).Bias = file.b{i};
% end
newlays = lgraph.Layers;
n = 1;
m = 1;
while n <= length(newlays)
    if class(newlays(n)) == "nnet.cnn.layer.FullyConnectedLayer"
        disp("Adding pretrained values...")
        newlays(n).Weights = file.W{m};
        newlays(n).Bias = file.b{m}; %transpose the bias vector for keras benchmarks
        n = n + 1;
        m = m + 1;
    else
        disp("No values to add")
        n = n + 1;
    end
end

%% Create graphical network 
newlgraph = layerGraph;
newlgraph = addLayers(newlgraph,newlays);
figure
plot(newlgraph)

%% Assemble network
net = assembleNetwork(newlgraph);

% deepNetworkDesigner % Opens visualizer for Series Network

%% Convert to ONNX
% exportONNXNetwork(net,string(filesave)+'.onnx')
