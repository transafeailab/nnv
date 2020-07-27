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

I = OS2.toStar;
if ~isa(I, 'Star')
    error('Input is not a star');
end

    if isempty(I)
        S = [];
    else
        [lb, ub] = I.estimateRanges;
        if isempty(lb) || isempty(ub)
            S = [];
        else

            % find all indexes having ub <= 0, then reset the
            % values of the elements corresponding to these indexes to 0
            fprintf('\nFinding all indexes with ub <= 0...');
            map1 = find(ub <= 0); % computation map
            map2 = find(lb <= 0 & ub > 0);
            xmax = I.getMaxs(map2);
            map3 = find(xmax <= 0);
            n = length(map3);
            map4 = zeros(n,1);
            for i=1:n
                map4(i) = map2(map3(i));
            end
            map11 = [map1; map4];
            In = I.resetRow(map11); % reset to zero at the element having ub <= 0
            fprintf('\n%d/%d indexes have ub <= 0', length(map11), length(ub));

            % find all indexes that have lb <= 0 & ub > 0, then
            % apply the over-approximation rule for ReLU
            fprintf("\nFinding all indexes with lb <= 0 & ub >0...");
            map5 = find(xmax > 0);
            n = length(map5);
            map6 = zeros(n,1);
            for i=1:n
                map6(i) = map2(map5(i)); % all indexes having ub > 0
            end

            xmin = I.getMins(map6); 
            map7 = find(xmin <= 0); 
            n = length(map7);
            map8 = zeros(n,1);
            lb1 = zeros(n,1);
            ub1 = zeros(n,1);
            for i=1:n
                map8(i) = map6(map7(i)); % all indexes having lb <= 0 & ub > 0
                lb1(i) = xmin(map7(i));
                ub1(i) = xmax(map7(i));
            end
            fprintf('\n%d/%d indexes have lb <= 0 & ub > 0', length(map8), length(ub));

            m = size(map8, 1); 
            for i=1:m
                fprintf('\n%d: performing approximate PosLin_%d operation using Star', i, map8(i, 1));
                In = PosLin.stepReachStarApprox2(In, map8(i), lb1(i), ub1(i));
            end
            S = In;

        end
    end
