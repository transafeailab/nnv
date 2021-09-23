 
% using lower bound and upper bound vector
lb = [1; 1];
ub = [2; 2];

S = Star(lb, ub);


% using center + basis matrix + predicate + predicate lower/upper bound
V = S.V;
C = S.C;
d = S.d;
predicate_lb = [-1; -1];
predicate_ub = [1; 1];

S2 = Star(V, C, d, predicate_lb, predicate_ub);

% using a polyhedron
P = ExamplePoly.randHrep;
S3 = Star(P);

% randomly generate a star set for testing

S4 = Star.rand(3);