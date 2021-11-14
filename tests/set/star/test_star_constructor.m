lb = [1; 1];
ub = [2; 2];

S = Star(lb, ub);

V = S.V;
C = S.C;
d = S.d;
predicate_lb = [-1; -1];
predicate_ub = [1; 1];

S2 = Star(V, C, d, predicate_lb, predicate_ub);