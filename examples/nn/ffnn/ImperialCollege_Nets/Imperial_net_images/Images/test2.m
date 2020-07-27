load net256x6.mat;
load inputSet.mat;
N = 1;

% relaxFactor = 0.9; 

t = tic;
R = net.reach(S_eps_002(3), 'approx-star', 1);
rt = toc(t);

% % verify the network with eps = 0.02
% t = tic;
% [r1, rb1, cE1, cands1] = net.evaluateRBN(S_eps_002(1:N), labels(1:N), 'approx-star', 1, relaxFactor);
% vt1 = toc(t);
% 
% vt2 = 0;
% % % verify the network with eps = 0.05
% % t = tic;
% % [r2, rb2, cE2, cands2] = net.evaluateRBN(S_eps_005(1:N), labels(1:N), 'approx-star', 1, relaxFactor);
% % vt2 = toc(t);
% 
% % buid table 
% epsilon = [0.02; 0.05];
% verify_time = [vt1; vt2];
% safe = [sum(rb1==1); sum(rb2 == 1)];
% unsafe = [sum(rb1 == 0); sum(rb2 == 0)];
% unknown = [sum(rb1 == 2); sum(rb2 == 2)];
% 
% T = table(epsilon, safe, unsafe, unknown, verify_time)

% save verify_net256x4.mat T; 