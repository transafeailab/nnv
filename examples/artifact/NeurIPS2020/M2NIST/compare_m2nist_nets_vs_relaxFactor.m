
%% Load and parse networks into NNV
load('m2nist_62iou_dilatedcnn_avgpool.mat');
Nets = SEGNET.parse(net, 'm2nist_62iou_dilatedcnn_avgpool');
load('m2nist_75iou_transposedcnn_avgpool.mat');
N2 = SEGNET.parse(net, 'm2nist_75iou_transposedcnn_avgpool');
Nets = [Nets N2];
load('m2nist_dilated_72iou_24layer.mat');
N3 = SEGNET.parse(net, 'm2nist_dilated_72iou_24layer.mat');
Nets = [Nets N3];
load('m2nist_6484_test_images.mat');


Nmax = 20; % maximum allowable number of attacked pixels
de = 0.00001; % size of input set


%% create input set
N = 20; % number of tested images 

IS(N) = ImageStar;
GrTruth = cell(1,N);
for l=1:N
    ct = 0;
    flag = 0;
    im = im_data(:,:,l);
    at_im = im;
    for i=1:64
        for j=1:84
            if im(i,j) > 150
                at_im(i,j) = 0;
                ct = ct + 1;
                if ct == Nmax(k)
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

Methods = ["relax-star-random", "relax-star-area", "relax-star-range", "relax-star-bound"];
RFs = [0.25; 0.5; 0.75; 1]; % relaxation factor

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
numCores = c.NumWorkers;

% verify N1 networks in the Nets array using the original approx-star approach
t1 = tic;
for i=1:N1
    t = tic;
    [rv, rs, ~, ~, ~, ~, ~] = Nets(i).verify(IS, GrTruth, 'approx-star', numCores);
    RV0(i) = sum(rv)/length(rv);
    RS0(i) = sum(rs)/length(rv);
    VT0(i) = toc(t);
end
total_VT0 = toc(t1);

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
    str = sprintf("N%d", i+3);
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
        str = sprintf('\\\\multirow{5}{*}{$\\\\mathbf{N_%d}$} & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', net_id + 3, rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
    else
        str = sprintf(' & $%2.2f$ & %2.2f &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ &  $%2.2f$  & $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$  &  $%2.2f$  &  $%2.2f$ &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$  &  $%2.2f$ &  $%2.2f$  &  $%2.2f$  &  $\\\\color{blue}{\\\\downarrow %2.1f\\\\%%%%}$ \\\\\\\\ ', rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4); 
    end
    
    fprintf(fileID, str);
    fprintf(fileID, '\n');
    
end
fclose(fileID);

function [rf, a1, a2, a3, a4, b1, b2, b3, b4, c1, c2, c3, c4, d1, d2, d3, d4] = get_verification_result(VR, i)
    % VR: verification results
    % i : row index  
    vr = VR(i,:);
    rf = vr.RelaxFactor;
    a1 = vr.Relax_Star_Random(1);
    a2 = vr.Relax_Star_Random(2);
    a3 = vr.Relax_Star_Random(3);
    a4 = vr.Relax_Star_Random(4);
    b1 = vr.Relax_Star_Area(1);
    b2 = vr.Relax_Star_Area(2);
    b3 = vr.Relax_Star_Area(3);
    b4 = vr.Relax_Star_Area(4);
    c1 = vr.Relax_Star_Range(1);
    c2 = vr.Relax_Star_Range(2);
    c3 = vr.Relax_Star_Range(3);
    c4 = vr.Relax_Star_Range(4);
    d1 = vr.Relax_Star_Bound(1);
    d2 = vr.Relax_Star_Bound(2);
    d3 = vr.Relax_Star_Bound(3);
    d4 = vr.Relax_Star_Bound(4);
end