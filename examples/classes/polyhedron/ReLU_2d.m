function R = ReLU_2d(P)
% compute RELU of 2-dimensional polyhedron

% H1: x1 <= 0, x2 >= 0
% H1: A1 x <= b1
A1 = [1 0; 0 -1];
b1 = [0; 0];
H1 = Polyhedron('A', A1, 'b', b1);

% H2: x1 >= 0, x2 >= 0
% H2: A2x <= b2, 
A2 = [-1 0; 0 -1];
b2 = [0; 0];
H2 = Polyhedron('A', A2, 'b', b2);


% H3: x1 >= 0, x2 <=0
A3 = [-1 0; 0 1];
b3 = [0; 0];
H3 = Polyhedron('A', A3, 'b', b3); 

% H4: x1 <= 0, x2 <= 0
A4 = [1 0; 0 1];
b4 = [0; 0];
H4 = Polyhedron('A', A4, 'b', b4);

Theta_1 = P.intersect(H1);
Theta_2 = P.intersect(H2);
Theta_3 = P.intersect(H3);
Theta_4 = P.intersect(H4);

R2 = Theta_2; 
R1 = [0 0; 0 1]*Theta_1;
R3 = [1 0; 0 0]*Theta_3;
R4 = [0 0; 0 0]*Theta_4;
 
R = [R1 R2 R3 R4];
end

