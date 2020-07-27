%/* An example of automatically verifying an FFNN */
%/* construct an NNV network
W1 = [1 -1; 0.5 2; -1 1]; 
b1 = [-1; 0.5; 0]; 

L1 = LayerS(W1, b1, 'poslin');

W2 = [-2 1 1; 0.5 1 1];   
b2 = [-0.5; -0.5];      

L2 = LayerS(W2, b2, 'purelin');  

F = FFNNS([L1 L2]); % construct an NNV FFNN

%F = FFNNS.parse(net);

%/* construct input set
lb = [-1; -2]; % lower bound vector
ub = [1; 0]; % upper bound vector

I = Star(lb, ub); % star input set

%/* Properties   
P = HalfSpace([-1 0], -1.5); % P: y1 >= 1.5

%/* verify the network
nC = 1; % number of cores

[safe, t, cE] = F.verify(I, P, 'exact-star', nC); % exact star method TRAN FM'19

%/* reachable set visualization

% plot the reachable set on some specific directions 

% X = map_mat * Y + map_vec 

map_mat = eye(2); % mapping matrix
map_vec = []; % mapping vector
P_poly = Polyhedron('A', P.G, 'b', P.g); % polyhedron obj

F.visualize(map_mat, map_vec); % plot y1 y2
hold on;
plot(P_poly); % plot unsafe region
title('exact-star', 'FontSize', 13);