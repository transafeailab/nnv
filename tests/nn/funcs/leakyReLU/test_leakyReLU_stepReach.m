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
S = LeakyReLU.stepReach(I, 1, gamma);
Y = LeakyReLU.evaluate(X, gamma);

S2 = LeakyReLU.stepReachMultipleInputs(S, 2, gamma);

figure; 
Star.plots(S2);
hold on; 
plot(Y(1, :), Y(2, :), 'o');