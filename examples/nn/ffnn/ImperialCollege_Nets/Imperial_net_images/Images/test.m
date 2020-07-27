load net256x2.mat;

labels=dlmread('labels');
labels=labels+1;

N = 50; 
eps = 0.02; 
S = [];
rb = zeros(1, N); % robustness
cE = cell(1, N); % counter examples
cands = cell(1,N); % candidates

for i=1:N
    fprintf("\nConstruct %d^th input set", i);
    file='image'+string(i);
    im=dlmread(file);
    im=im(1:784)/255;
    im = im';
    lb=im-eps;
    ub=im+eps;

    lb(lb>1)=1;
    lb(lb<0)=0;
    ub(ub>1)=1;
    ub(ub<0)=0;
    S =[S Star(lb,ub)];
end

t = tic;
[r, rb, cE, cands] = net.evaluateRBN(S, labels(1:N), 'approx-star', 6);
vt = toc(t);