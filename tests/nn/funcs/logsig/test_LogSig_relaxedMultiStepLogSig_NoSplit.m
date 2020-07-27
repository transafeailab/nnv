
I = ExamplePoly.randVrep;
I.outerApprox;
V = [0 0; 1 0; 0 1];
I = Star(V', I.A, I.b, I.Internal.lb, I.Internal.ub); % input star

S = LogSig.reach_star_approx_no_split(I);
S1 = LogSig.multiStepLogSig_NoSplit(I);
S2 = LogSig.relaxedMultiStepLogSig_NoSplit(I, 0.5);
X = I.sample(10);
Y = LogSig.evaluate(X);



figure;
I.plot; % input set
hold on;
plot(X(1, :), X(2, :), 'ob'); % sampled inputs

figure;
Star.plots(S, 'blue'); % reach set

figure;
Star.plots(S1, 'red');
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs

figure;
Star.plots(S2, 'red');
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs



