
I = ExamplePoly.randVrep;
I.outerApprox; 
lb = I.Internal.lb;
ub = I.Internal.ub;
V = [0 0; 1 0; 0 1];
I = Star(V', I.A, I.b, lb, ub); % input star


samples = I.sample(10); % sample 10 points in the input star
y = SatLin.evaluate(samples);

figure;
I.plot;
hold on; 
plot(samples(1,:), samples(2,:), '*');
S = SatLin.stepReachStarApprox(I, 1, 'glpk');
figure;
S.plot;
hold on;
plot(y(1, :), y(2, :), 'x');
