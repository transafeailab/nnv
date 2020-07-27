%% Convert net (network object) to mat

% load network
file = 'controller_Lcontainer_3in.mat'; %name of your file
%load(file);

% Define parameters
max = 10; %establish max length for the char matrix of activation functions

% Get NN attributes

W{1} = net.IW{1}; % weights layer one
for i=1:length(net.b)-1 % weights
    W{i+1} = net.LW{i+1,i};
end

for i = 1:length(net.b)
    b{i} = net.b{i}; % bias
    layer_sizes(i) = net.layers{i}.size; % number of neurons in each layer
    str = net.layers{i}.transferFcn; % activation function at layer i
    padded_str = repmat(' ',1, max);
    padded_str(1:min(20,length(str))) = str(1:min(20,length(str))); % add spaces to have same lengths
    activation_fcns(i,:) = padded_str; % activation function at layer i with spaces added
end

% Other parameters
number_of_inputs = size(net.IW{1},2); % inputs to the NN
number_of_outputs = size(W{end},1); % outputs to the NN
number_of_layers = length(b); % number of layers, including hidden and output layers

% Save network
save(file,'W','b','layer_sizes','activation_fcns','number_of_inputs',...
    'number_of_outputs','number_of_layers');