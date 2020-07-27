
%% load network and input set
load mnist01.mat;

%% verify the images use linprog

numCores = 6; 
N = 100; % number of Images tested maximum is 100
eps = [0.15];
relaxFactor = [0]; 
% eps = [0.1 0.15 0.2]; % epsilon for the disturbance
% timeout for eps = 0.25
% relaxFactor = [0 0.25 0.5 0.75 1]; % relax factor
K = length(relaxFactor);
M = length(eps);

r = zeros(K, M); % percentage of images that are robust
rb = cell(K, M); % detail robustness verification result
cE = cell(K, M); % detail counterexamples
vt = cell(K, M); % detail verification time
cands = cell(K,M); % counterexample
total_vt = zeros(K, M); % total verification time

dis_opt = []; % dis_opt = 'display' to show the detail computation
lp_solver = 'linprog'; % use linprog as the LP solver

for i=1:K
    for j=1:M
        [IS, Labels] = getInputSet(eps(j)); 
        t = tic;
        [r(i,j), rb{i,j}, cE{i,j}, cands{i,j}, vt{i,j}] = net.evaluateRBN(IS(1:N), Labels(1:N), 'approx-star', numCores, relaxFactor(i), dis_opt, lp_solver);
        total_vt(i,j) = toc(t);
    end
end

%% print the result
T1 = table;
rf = [];
ep = [];
VT = [];
RB = [];
US = [];
UK = [];
for i=1:K
    rf = [rf; relaxFactor(i)*ones(M,1)];
    ep = [ep; eps'];
    unsafe = zeros(M,1);
    robust = zeros(M,1);
    unknown = zeros(M,1);
    for j=1:M
        unsafe(j) = sum(rb{i,j}==0);
        robust(j) = sum(rb{i,j} == 1);
        unknown(j) = sum(rb{i,j}==2);
    end
    RB = [RB; robust];
    US = [US; unsafe];
    UK = [UK; unknown];
    VT = [VT; total_vt(i,:)'];
end
T1.relaxFactor = rf; 
T1.epsilon = ep;
T1.robustness = RB;
T1.unsafe = US;
T1.unknown = UK;
T1.verifyTime = VT;

%% verify the images using glpk 
lp_solver = 'glpk'; % use glpk as the LP solver
for i=1:K
    for j=1:M
        [IS, Labels] = getInputSet(eps(j)); 
        t = tic;
        [r(i,j), rb{i,j}, cE{i,j}, cands{i,j}, vt{i,j}] = net.evaluateRBN(IS(1:N), Labels(1:N), 'approx-star', numCores, relaxFactor(i), dis_opt, lp_solver);
        total_vt(i,j) = toc(t);
    end
end

%% print the result
T2 = table;
rf = [];
ep = [];
VT = [];
RB = [];
US = [];
UK = [];
for i=1:K
    rf = [rf; relaxFactor(i)*ones(M,1)];
    ep = [ep; eps'];
    unsafe = zeros(M,1);
    robust = zeros(M,1);
    unknown = zeros(M,1);
    for j=1:M
        unsafe(j) = sum(rb{i,j}==0);
        robust(j) = sum(rb{i,j} == 1);
        unknown(j) = sum(rb{i,j}==2);
    end
    RB = [RB; robust];
    US = [US; unsafe];
    UK = [UK; unknown];
    VT = [VT; total_vt(i,:)'];
end
T2.relaxFactor = rf; 
T2.epsilon = ep;
T2.robustness = RB;
T2.unsafe = US;
T2.unknown = UK;
T2.verifyTime = VT;

T1
T2