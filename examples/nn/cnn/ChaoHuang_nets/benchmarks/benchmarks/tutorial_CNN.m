%% parse network into NNV
modelfile = 'model_MNIST_CNN_Small.json';
weightfile = 'model_MNIST_CNN_Small.h5';
net = importKerasNetwork(modelfile, 'WeightFile', weightfile, 'OutputLayerType','classification');

nnvNet = CNN.parse(net); % construct an nnvNet object

%% Load an image and construct an input set 
load digit_7.mat; % the first image in JiaMeng data set
im = digit_7/255;
im = im';

% l_infinity norm attack
eps = 0.002;
lb = im - eps;
lb(lb<0) = 0;
ub = im + eps;
ub(ub>1) = 1;

IS = ImageStar(lb, ub);

%% Verify the robustness under l-infinity norm attack
correct_id = 8;
numCore = 1;
nnvNet.dis_opt = 'display';
[rb, cE, cands, vt] = nnvNet.verifyRBN(IS, 8, 'approx-star', 1);

%% plot output ranges
OS = nnvNet.outputSet; 
OS.estimateRanges;

lb1 = reshape(OS.im_lb, [10 1]);
ub1 = reshape(OS.im_ub, [10 1]); 

im_center1 = (lb1 + ub1)/2;
err1 = (ub1 - lb1)/2;
x1 = 0:1:9;
y1 = im_center1;

figure;
e = errorbar(x1,y1,err1);
e.LineStyle = 'none';
e.LineWidth = 1;
e.Color = 'red';
xlabel('Output', 'FontSize', 11);
ylabel('Ranges', 'FontSize', 11);
xlim([0 9]);
title('ImageStar', 'FontSize', 11);
xticks(x1);
xticklabels({'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'});
set(gca, 'FontSize', 10);

