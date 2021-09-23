W = rand(3,2);
b = rand(3,1); 
P = ExamplePoly.randHrep('d', 2);
R = layer_reach_polyhedron(W, b, P); 
figure; 
subplot(1,2,1);
P.plot;
subplot(1,2,2);
R.plot;