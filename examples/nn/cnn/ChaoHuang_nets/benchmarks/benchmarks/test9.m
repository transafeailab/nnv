% @I: input star set
            
% @l: l = min(x[index]), lower bound at neuron x[index] 
% @u: u = min(x[index]), upper bound at neuron x[index]
% @yl: = logsig(l); output of logsig at lower bound
% @yu: = logsig(u); output of logsig at upper bound
% @dyl: derivative of LogSig at the lower bound
% @dyu: derivative of LogSig at the upper bound

% @S: output star set

% author: Dung Tran
% date: 6/12/2020

I = OS7.toStar;

%[l, u] = I.estimateRanges;
N = I.dim;
inds = 1:N;
fprintf('\nComputing lower bound: ');
l = I.getMins(inds);
fprintf('\nComputing upper-bound: ');
u = I.getMaxs(inds);

yl = logsig(l);
yu = logsig(u);
dyl = logsig('dn', l);
dyu = logsig('dn', u);

% l == u
map1 = find(l == u);
yl1 = yl(map1(:));         
V1 = I.V;
V1(map1, 1) = yl1;
V1(map1, 2:I.nVar+1) = 0;

% l ~= u
map2 = find(l ~= u);
m = length(map2);
V2 = zeros(N, m);
for i=1:m
    V2(map2(i), i) = 1;
end

% new basis matrix
new_V = [zeros(N, I.nVar+1) V2]; 
    
% add new constraints

% C0, d0
n = size(I.C, 1);
C0 = [I.C zeros(n, m)];
d0 = I.d;

% C1, d1, x >= 0
% y is convex when x >= 0
% constraint 1: y <= y'(l) * (x - l) + y(l)
% constarint 2: y <= y'(u) * (x - u) + y(u) 
% constraint 3: y >= (y(u) - y(l)) * (x - l) / (u - l) + y(l);
map1 = find(l >= 0 & l~=u);
a = yl(map1(:));
b = yu(map1(:));
da = dyl(map1(:));
db = dyu(map1(:));

nv = I.nVar+1;
% constraint 1: y <= y'(l) * (x - l) + y(l)
C11 = [-da.*I.V(map1, 2:nv) V2(map1, :)];
d11 = da.*(I.V(map1, 1)-l(map1)) + a;
% constraint 2: y <= y'(u) * (x - u) + y(u) 
C12 = [-db.*I.V(map1, 2:nv) V2(map1, :)];
d12 = db.*(I.V(map1, 1) - u(map1)) + b;
% constraint 3: y >= (y(u) - y(l)) * (x - l) / (u - l) + y(l);
gamma = (b-a)./(u(map1)-l(map1));
C13 = [gamma.*I.V(map1, 2:nv) -V2(map1, :)];
d13 = -gamma.*(I.V(map1, 1)-l(map1)) - a;

C1 = [C11; C12; C13]; 
d1 = [d11; d12; d13];

% C2, d2, x <= 0 
% y is concave when x <= 0
% constraint 1: y >= y'(l) * (x - l) + y(l)
% constraint 2: y >= y'(u) * (x - u) + y(u)
% constraint 3: y <= (y(u) - y(l)) * (x -l) / (u - l) + y(l);

map1 = find(u <= 0 & l~=u);
a = yl(map1(:));
b = yu(map1(:));
da = dyl(map1(:));
db = dyu(map1(:));

% constraint 1: y >= y'(l) * (x - l) + y(l)
C21 = [da.*I.V(map1, 2:nv) -V2(map1, :)];
d21 = -da.*(I.V(map1, 1)-l(map1)) - a;
% constraint 2: y >= y'(u) * (x - u) + y(u) 
C22 = [db.*I.V(map1, 2:nv) -V2(map1, :)];
d22 = -db.*(I.V(map1, 1) - u(map1)) - b;
% constraint 3: y <= (y(u) - y(l)) * (x -l) / (u - l) + y(l);
gamma = (b-a)./(u(map1)-l(map1));
C23 = [-gamma.*I.V(map1, 2:nv) V2(map1, :)];
d23 = gamma.*(I.V(map1, 1)-l(map1)) + a;

C2 = [C21; C22; C23]; 
d2 = [d21; d22; d23];

% C3, d3, l< 0 & u > 0, x >0 or x < 0
%y is concave for x in [l, 0] and convex for x
% in [0, u]
% split can be done here            

map1 = find(l < 0 & u > 0);
a = yl(map1(:));
b = yu(map1(:));
da = dyl(map1(:));
db = dyu(map1(:));

dmin = (min(da', db'))';
% over-approximation constraints 
% constraint 1: y >= min(y'(l), y'(u)) * (x - l) + y(l)
% constraint 2: y <= min(y'(l), y'(u)) * (x - u) + y(u)

% constraint 1: y >= min(y'(l), y'(u)) * (x - l) + y(l)
C31 = [dmin.*I.V(map1, 2:nv) -V2(map1, :)];
d31 = -dmin.*(I.V(map1, 1)-l(map1)) - a;
% constraint 2: y <= min(y'(l), y'(u)) * (x - u) + y(u) 
C32 = [-dmin.*I.V(map1, 2:nv) V2(map1, :)];
d32 = dmin.*(I.V(map1, 1) - u(map1)) + b;
y1 = dmin.*(-l(map1(:))) + a;
y2 = dmin.*(-u(map1(:))) + b;

g2 = (y2 - a)./(-l(map1(:)));
g1 = (y1 - b)./(-u(map1(:)));

% constraint 3: y <= g2 * x + y2
C33 = [-g2.*I.V(map1, 2:nv) V2(map1, :)];
d33 = g2.*I.V(map1, 1) + y2;

% constraint 4: y >= g1 * x + y1
C34 = [g1.*I.V(map1, 2:nv) -V2(map1, :)];
d34 = -g1.*I.V(map1, 1) - y1;

C3 = [C31; C32; C33; C34]; 
d3 = [d31; d32; d33; d34];


new_C = [C0; C1; C2; C3];
new_d = [d0; d1; d2; d3]; 

new_pred_lb = [I.predicate_lb; yl(map2)];
new_pred_ub = [I.predicate_ub; yu(map2)];

S2 = Star(new_V, new_C, new_d, new_pred_lb, new_pred_ub);

