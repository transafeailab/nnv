
clc; clear;

%% Load and parse networks into NNV
load('net_mnist_3_relu.mat');
Nets = SEGNET.parse(net, 'net_mnist_3_relu_avgpool');
%load('net_mnist_3_relu_maxpool.mat');
%N2 = SEGNET.parse(net, 'net_mnist_3_relu_maxpool');
%Nets = [Nets N2];
%load('mnist_dilated_net_21_later_83iou');
%N3 = SEGNET.parse(net, 'mnist_dilated_net_21_later_83iou');
%Nets = [Nets N3];
load('test_images.mat');


Nmax = 100; % maximum allowable number of attacked pixels
de = 0.005	; % size of input set

Nt = 100;

%% create input set
N = 1; % number of tested images 


IS(N) = ImageStar;
GrTruth = cell(1,N);
for l=1:N
    ct = 0;
    flag = 0;
    im = im_data(:,:,l);
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
    d = [1; de-1];
    S = ImageStar(V, C, d, 1-de, 1);
    IS(l) = S; 
    GrTruth{l} = im;
end

%%

%Methods = ["relax-star-random", "relax-star-area", "relax-star-range", "relax-star-bound"];
Methods = ["relax-star-random"];
RFs = [1]; % relaxation factor

N1 = length(Nets);
N2 = length(Methods);
N3 = length(RFs);

% relax-star results
RV = zeros(N1, N2, N3); % average robustness value for N images
RS = zeros(N1, N2, N3); % average robustness sensitivity for N images
VT = zeros(N1, N2, N3);
% original approx-star results (no relaxation)
RV0 = zeros(N1, 1);
RS0 = zeros(N1, 1);
VT0 = zeros(N1, 1); 

%% Verify networks

c = parcluster('local');
numCores = 1;
%RVnumCores = c.NumWorkers;

% verify N1 networks in the Nets array using the original approx-star approach
% t1 = tic;
% for i=1:N1
%     t = tic;
%     [rv, rs, ~, ~, ~, ~, ~] = Nets(i).verify(IS, GrTruth, 'approx-star', numCores);
%     RV0(i) = sum(rv)/length(rv);
%     RS0(i) = sum(rs)/length(rv);
%     VT0(i) = toc(t);
% end
% total_VT0 = toc(t1);

% verify N1 networks in the Nets array using the relax-star approach
t2 = tic;
for i=1:N1
    for j=1:N2
        for k=1:N3
            t = tic;
            [rv, rs, ~, ~, ~, ~, ~] = Nets(i).verify(IS, GrTruth, Methods(j), numCores, RFs(k));
            RV(i, j, k) = sum(rv)/length(rv); 
            RS(i, j, k) = sum(rs)/length(rv);
            VT(i,j,k) = toc(t);
        end
    end
end
total_VT = toc(t2);

%% print results
fprintf("======================== VERIFICATION RESULTS ============================")
Verification_Results = [];
for i=1:N1
   
    T = table;
    str = sprintf("N%d", i);
    ID = [str];
    for j=1:N2
        ID = [ID; str];
    end
    T.Networks = ID;
    
    T.RelaxFactor = [0; RFs];
    rv = [RV0(i); reshape(RV(i, 1, :), [N2, 1])];
    rs = [RS0(i); reshape(RS(i, 1, :), [N2, 1])];
    vt = [VT0(i); reshape(VT(i, 1, :), [N2, 1])];
    impr = (-100*(vt - VT0(i)))/VT0(i);
    T.Relax_Star_Random = [rv rs vt impr];
    %
    rv = [RV0(i); reshape(RV(i, 2, :), [N2, 1])];
    rs = [RS0(i); reshape(RS(i, 2, :), [N2, 1])];
    vt = [VT0(i); reshape(VT(i, 2, :), [N2, 1])];
    impr = (-100*(vt - VT0(i)))/VT0(i);
    T.Relax_Star_Area = [rv rs vt impr];
    %
    rv = [RV0(i); reshape(RV(i, 3, :), [N2, 1])];
    rs = [RS0(i); reshape(RS(i, 3, :), [N2, 1])];
    vt = [VT0(i); reshape(VT(i, 3, :), [N2, 1])];
    impr = (-100*(vt - VT0(i)))/VT0(i);
    T.Relax_Star_Range = [rv rs vt impr];
    %
    rv = [RV0(i); reshape(RV(i, 4, :), [N2, 1])];
    rs = [RS0(i); reshape(RS(i, 4, :), [N2, 1])];
    vt = [VT0(i); reshape(VT(i, 4, :), [N2, 1])];
    impr = (-100*(vt - VT0(i)))/VT0(i);
    T.Relax_Star_Bound = [rv rs vt impr];

    Verification_Results= [Verification_Results; T];
end
Verification_Results
fprintf("*** NOTE FOR EACH APPROACH ***\n");
fprintf("The firt column is the average Robustness Value (RV)\n")
fprintf("The second column is the average Robustness Sensitivity (RS)\n");
fprintf("The third column is the Verification Time (VT)\n");
fprintf("The last column is the improvement in percentage of the Verification Time (VT)\n");

writetable(Verification_Results);


%% Print latex table1

fileID = fopen('RelaxReachPerform.tex', 'w');

N = size(Verification_Results, 1);
for i=1:N
    [rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4] = get_verification_result(Verification_Results, i);
    net_id = floor((i-1)/(N2+1)) + 1;
    if i== 1 || i == 6 || i == 11
        str = sprintf('\\\\multirow{5}{*}{$\\\\mathbf{N_%d}$} & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', net_id, rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
    else
        str = sprintf(' & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
    end
    
    fprintf(fileID, str);
    fprintf(fileID, '\n');
    
end
fclose(fileID);

