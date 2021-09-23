
% test stepReLU polyhedron function
P = ExamplePoly.randHrep('d', 3);
figure;
P.plot;

R = stepReLU_polyhedron(P, 1);
figure;
R.plot;