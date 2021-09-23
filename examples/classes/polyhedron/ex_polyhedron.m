% creat a new polyhedron object using H-representation

A = [1 0; -1 0; 0 1; 0 -1];
b = [1; 1; 1; 1]; 

% P = {x | Ax <= b, Aex = be}
P1 = Polyhedron('A', A, 'b', b);

% use lower bound and upper bound to construct a polyhedron

lb = [-1; -1];
ub = [1; 1];

P2 = Polyhedron('lb', lb, 'ub', ub);

% creat a random polyhedron for testing

P3 = ExamplePoly.randHrep;

% Affine mapping of a polyhedron
% P -> P' = W*P + b

W = rand(3, 2); % random 3x2 matrix
b = rand(3, 1); % random  3x1 vector

P3_map = W*P3 + b; % affine mapping of P3

%fig = figure;

%subplot(1,2,1);
%P3.plot; 
%subplot(1,2,2);
%P3_map.plot;


%% Intersection of two polyhedron

P31 = ExamplePoly.randHrep;
P32 = ExamplePoly.randHrep; 

P3 = P31.intersect(P32);

fig = figure; 
%subplot(1,3,1);
P31.plot('color', 'red');
hold on;
%subplot(1,3,2);
P32.plot('color', 'blue');
hold on;
%subplot(1,3,3);
P3.plot('color', 'yellow');







