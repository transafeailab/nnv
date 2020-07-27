load IS_03.mat; 
load mnist03.mat;

outputSet = net.reach(IS_03(6), 'approx-star');
N = 1;
S = outputSet.toStar;
A = S.C;
b = S.d;
f = ones(1, S.nVar);
lb = S.predicate_lb;
ub = S.predicate_ub; 

%options = optimoptions(@linprog, 'Preprocess', 'none');
options = optimoptions('linprog');
tic;
[~, fval1, exitflag1, ~] = linprog(f, A, b, [], [], lb, ub);
toc;

tic;
[~, fval, exitflag, ~] = glpk(f, A, b, lb, ub);
toc;