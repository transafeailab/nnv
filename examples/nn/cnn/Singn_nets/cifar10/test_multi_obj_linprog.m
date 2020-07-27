A = [1 1
    1 1/4
    1 -1
    -1/4 -1
    -1 -1
    -1 1];

b = [2 1 2 1 -1 2];

f1 = [-1 -1/3];

f2 = [1 1]; 

model.modelsense  = 'min';
model.modelname   = 'multiobj';

% Set variables and constraints
% model.vtype       = repmat('B', groundSetSize, 1);
% model.lb          = zeros(groundSetSize, 1);
% model.ub          = ones(groundSetSize, 1);
model.A           = sparse(A);
model.rhs           = b; 
model.multiobj(1).objn     = f1;
model.multiobj(2).objn     = f2;

gurobi_write(model,'multiobj_m.lp')

% Set parameters
params.PoolSolutions = 100;

% Optimize
result = gurobi(model, params);

f = [1 1];
[x,fval] = linprog(f,A,b);
result;