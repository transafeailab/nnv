function R = stepReLU_polyhedron(P, id)
% stepReLU operation on an polyhedron at a specific index

n = P.Dim; % dimension of the polyhedron

% H1 : x[id] >= 0
A1 = zeros(1, n);
A1(1, id) = -1;
b1 = 0;
H1 = Polyhedron('A', A1, 'b', b1);

% H2: x[id] <= 0
A2 = zeros(1, n);
A2(1, id) = 1;
b2 = 0;
H2 = Polyhedron('A', A2, 'b', b2);

% compute Theta

Theta_1 = P.intersect(H1);
Theta_2 = P.intersect(H2); 

% compute the intermediate reachable set
R1 = Theta_1; 

W = eye(n);
W(id, id) = 0; 

R2 = W*Theta_2;
R = [R1 R2]; % intermediate reachable set
end

