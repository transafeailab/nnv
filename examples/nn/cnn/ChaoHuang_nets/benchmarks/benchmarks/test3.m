%% parse network into NNV
modelfile = 'model_MNIST_CNN_Small.json';
weightfile = 'model_MNIST_CNN_Small.h5';

% modelfile = 'model_MNIST_CNN_Medium.json';
% weightfile = 'model_MNIST_CNN_Medium.h5';

% modelfile = 'model_MNIST_CNN_Large.json';
% weightfile = 'model_MNIST_CNN_Large.h5';

net = importKerasNetwork(modelfile, 'WeightFile', weightfile, 'OutputLayerType','classification');
nnvNet = CNN.parse(net); % construct an nnvNet object

%% Load an image and create attack
load test_images.mat; 
im = im_data(:,:,1);
im = im/255;

% attack all pixels independently by some bounded disturbance d 
% d = 0.001; % 63 seconds
% d = 0.002; % 100 seconds
% d = 0.003; % 160 seconds
% d = 0.004; % 214 seconds
d = 0.01; 
attack_LB = -d*ones(28, 28);
attack_UB = d*ones(28,28);

%% computing reachable set 

IS = ImageStar(im, attack_LB, attack_UB); % construct an ImageStar input set

t = tic;
OS1 = nnvNet.Layers{1}.reach(IS, 'approx-star');
t1 = toc(t);

t = tic;
OS2 = nnvNet.Layers{2}.reach(OS1, 'approx-star');
t2 = toc(t);

t = tic;
OS3 = nnvNet.Layers{3}.reach(OS2, 'approx-star');
t3 = toc(t);

t = tic;
OS4 = nnvNet.Layers{4}.reach(OS3, 'approx-star');
t4 = toc(t);
% 
t = tic;
OS5 = nnvNet.Layers{5}.reach(OS4, 'approx-star');
t5 = toc(t);

t = tic;
OS6 = nnvNet.Layers{6}.reach(OS5, 'approx-star');
t6 = toc(t);
% 
t = tic;
OS7 = nnvNet.Layers{7}.reach(OS6, 'approx-star');
t7 = toc(t);

t = tic;
OS8 = nnvNet.Layers{8}.reach(OS7, 'approx-star');
t8 = toc(t);

t = tic;
OS9 = nnvNet.Layers{9}.reach(OS8, 'approx-star');
t9 = toc(t);
