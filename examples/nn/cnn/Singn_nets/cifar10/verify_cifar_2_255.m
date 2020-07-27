load cifar_2_255.mat;
load Labels.mat;
load IS_2_255_1.mat;

reachPRM.inputSet = IS;
reachPRM.reachMethod = 'approx-star';
reachPRM.numCores = 1;
reachPRM.relaxFactor = 0;
reachPRM.lp_solver = 'linprog';
reachPRM.dis_opt = 'display';

t = tic;
net.reach(reachPRM);
rt = toc(t);

R = net.outputSet;
R = R.toStar;
[lb, ub] = R.getRanges;
t = tic;
[rb,cands] = CNN.checkRobust(net.outputSet, Labels(1));
ct = toc(t);