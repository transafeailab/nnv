
clc; clear;

%% Load and parse networks into NNV
Nets = [];
load('net_mnist_3_relu.mat');
net1 = SEGNET.parse(net, 'net_mnist_3_relu_avgpool');
Nets = [Nets net1];
% load('net_mnist_3_relu_maxpool.mat');
% net2 = SEGNET.parse(net, 'net_mnist_3_relu_maxpool');
% Nets = [Nets net2];
% load('mnist_dilated_net_21_later_83iou');
% net3 = SEGNET.parse(net, 'mnist_dilated_net_21_later_83iou');
% Nets = [Nets net3];
load('test_images.mat');


Nmax = 50; % maximum allowable number of attacked pixels
de = [0.005; 0.01; 0.02]	; % size of input set
%de = [0.001; 0.0015; 0.002];
Nt = 150;

%% create input set
N1 = length(de);  

IS(N1) = ImageStar;
GrTruth = cell(1,N1);
for l=1:N1
    ct = 0;
    flag = 0;
    im = im_data(:,:,1);
    at_im = im;
    for i=1:28
        for j=1:28
            if im(i,j) > Nt
                at_im(i,j) = 0;
                ct = ct + 1;
                if ct == Nmax
                    flag = 1;
                    break;
                end
            end
        end
        if flag == 1
            break;
        end
    end

    dif_im = im - at_im;
    noise = -dif_im;
    % Perform robustness analysis
    V(:,:,:,1) = double(im);
    V(:,:,:,2) = double(noise);
    C = [1; -1];
    d = [1; de(l)-1];
    S = ImageStar(V, C, d, 1-de(l), 1);
    IS(l) = S; 
    GrTruth{l} = {im};
end

%%


Methods = ["relax-star-random", "relax-star-area", "relax-star-range", "relax-star-bound"];
N2 = length(Methods);
RFs = [0; 0.25; 0.5; 0.75; 1]; % relaxation factor
N3 = length(RFs);

% relax-star results
RIoU = zeros(N1, N2, N3); % average robust IoU
RV = zeros(N1, N2, N3); % average robustness value for N images
RS = zeros(N1, N2, N3); % average robustness sensitivity for N images
VT = zeros(N1, N2, N3);
% original approx-star results (no relaxation)

%% Verify networks

c = parcluster('local');
numCores = 1;
%RVnumCores = c.NumWorkers;

% verify N1 networks in the Nets array using the relax-star approach
t2 = tic;
for i=1:N1
    for j=1:N2
        for k=1:N3
            t = tic;
            [riou, rv, rs, ~, ~, ~, ~, ~] = net1.verify(IS(i), GrTruth{1,i}, Methods(j), numCores, RFs(k));
            RIoU(i, j, k) = sum(riou)/length(riou);
            RV(i, j, k) = sum(rv)/length(rv); 
            RS(i, j, k) = sum(rs)/length(rv);
            VT(i,j,k) = toc(t);
        end
    end
end
total_VT = toc(t2);

%% print results
fprintf("======================== VERIFICATION TIME IMPROVEMENT FOR NETWORK N1 ============================")
   
N1_verifyTime = table; 
N1_verifyTime.RelaxFactor = RFs;
vt = [];
for i=1:N2
    vt1 = VT(1, i, :);
    vt1 = reshape(vt1, [N3, 1]);
    vt = [vt vt1];
end
N1_verifyTime.de_005 = vt;

vt = [];
for i=1:N2
    vt1 = VT(2, i, :);
    vt1 = reshape(vt1, [N3, 1]);
    vt = [vt vt1];
end
N1_verifyTime.de_01 = vt;

vt = [];
for i=1:N2
    vt1 = VT(3, i, :);
    vt1 = reshape(vt1, [N3, 1]);
    vt = [vt vt1];
end
N1_verifyTime.de_02 = vt;

N1_verifyTime

fprintf("*** NOTE FOR EACH DELTA (de) ***\n");
fprintf("The firt column is the verification time of the relax-star-random method \n")
fprintf("The second column is the verification time of the relax-star-area method \n");
fprintf("The third column is the verification time of the relax-star-range method \n");
fprintf("The last column is the verification time of the relax-star-bound method \n");
writetable(N1_verifyTime);


% %% Print latex table1
% 
% fileID = fopen('RelaxReachPerform.tex', 'w');
% 
% N = size(Verification_Results, 1);
% for i=1:N
%     [rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4] = get_verification_result(Verification_Results, i);
%     net_id = floor((i-1)/(N2+1)) + 1;
%     if i== 1 || i == 6 || i == 11
%         str = sprintf('\\\\multirow{5}{*}{$\\\\mathbf{N_%d}$} & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', net_id, rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
%     else
%         str = sprintf(' & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
%     end
%     
%     fprintf(fileID, str);
%     fprintf(fileID, '\n');
%     
% end
% fclose(fileID);
% 
