I = ExamplePoly.randVrep;   
V = [0 0; 1 0; 0 1];
I.outerApprox;
lb = I.Internal.lb;
ub = I.Internal.ub;
I = Star(V', I.A, I.b, lb, ub); % input star
X = I.sample(10);

figure;
I.plot;
hold on;
plot(X(1, :), X(2, :), 'ob'); % sampled inputs

gamma = 0.1;
S = LeakyReLU.reach_star_approx(I, gamma);
S1 = LeakyReLU.reach_polyhedron_exact(I.toPolyhedron,gamma);
Y = LeakyReLU.evaluate(X, gamma);

figure;
Star.plots(S);
hold on;
S1.plot;
hold on;
plot(Y(1, :), Y(2, :), 'o');
