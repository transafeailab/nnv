labels=dlmread('labels');
labels=labels+1;

N = 50;  
S_eps_002(N) = Star;
S_eps_005(N) = Star;
rb = zeros(1, N); % robustness
cE = cell(1, N); % counter examples
cands = cell(1,N); % candidates

for i=1:N
    fprintf("\nConstruct %d^th input set", i);
    file='image'+string(i);
    im=dlmread(file);
    im=im(1:784)/255;
    im = im';
    eps = 0.02;
    lb=im-eps;
    ub=im+eps;

    lb(lb>1)=1;
    lb(lb<0)=0;
    ub(ub>1)=1;
    ub(ub<0)=0;
    S_eps_002(i) = Star(lb,ub);
    
    eps = 0.05;
    lb=im-eps;
    ub=im+eps;

    lb(lb>1)=1;
    lb(lb<0)=0;
    ub(ub>1)=1;
    ub(ub<0)=0;
    S_eps_005(i) = Star(lb, ub);
end

save inputSet labels S_eps_002 S_eps_005;