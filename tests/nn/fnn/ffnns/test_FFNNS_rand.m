neurons = [2 3 3 2];
funcs = ["leakyrelu", "leakyrelu", "purelin"];
%funcs = "leakyrelu";
net = FFNNS.rand(neurons, funcs);

I = ExamplePoly.randVrep;   
V = [0 0; 1 0; 0 1];
I.outerApprox;
lb = I.Internal.lb;
ub = I.Internal.ub;
I = Star(V', I.A, I.b, lb, ub); % input star
X = I.sample(10);

S = net.reach(I, 'exact-star');
Y = net.sample(X);

figure;
Star.plots(S);
hold on;
plot(Y(1, :), Y(2, :), 'x');
