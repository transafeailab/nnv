%load logsig_200_50_nnv.mat;
load logsig_200_100_50_nnv.mat;
load inputStar.mat;
load inputSet.mat;
N = 1;

verifyPRM.inputSets = S_eps_05(N);
verifyPRM.correct_ids = labels(N);
verifyPRM.numCores = 1;
verifyPRM.reachMethod = 'approx-star';
verifyPRM.relaxFactor = 0;
verifyPRM.dis_opt = 'display';
verifyPRM.lp_solver = 'linprog';


% verify the network with eps = 5
[r1, rb1, cE1, cands1, vt1] = net.evaluateRBN(verifyPRM);


