load logsig_200_100_50_nnv.mat;
load inputStar.mat;
load inputSet.m
N = 25; 
numCores = 6;
reachMethod = 'approx-star';
% verify the network with eps = 5

[r1, rb1, cE1, cands1, vt1] = net.evaluateRBN(S_eps_05(1:N), labels(1:N), reachMethod, numCores);


% verify the network with eps = 12
[r2, rb2, cE2, cands2, vt2] = net.evaluateRBN(S_eps_12(1:N), labels(1:N), reachMethod, numCores);


% buid table 
epsilon = [0.02; 0.05];
verify_time = [sum(vt1); sum(vt2)];
safe = [sum(rb1==1); sum(rb2 == 1)];
unsafe = [sum(rb1 == 0); sum(rb2 == 0)];
unknown = [sum(rb1 == 2); sum(rb2 == 2)];

T = table(epsilon, safe, unsafe, unknown, verify_time)

save(/results/verify_sigm_3L.mat, 'T', 'r1', 'rb1', 'cE1', 'cands1', 'vt1',  'r2', 'rb2', 'cE2' 'cands2', 'vt2');