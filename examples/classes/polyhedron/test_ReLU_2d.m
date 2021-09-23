
% test ReLU_2d function
P = ExamplePoly.randHrep;
figure;
P.plot;

R = ReLU_2d(P);
figure;
R.plot;