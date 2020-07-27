labels=dlmread('labels');
labels=labels+1;

file='image'+string(2);
im=dlmread(file);
im=im(1:784)/255;

ep=0.02;

lb=im'-ep;
ub=im'+ep;

lb(lb>1)=1;
lb(lb<0)=0;
ub(ub>1)=1;
ub(ub<0)=0;

S=Star(lb,ub);
[R,t]=net.reach(S,'approx-star',1);

