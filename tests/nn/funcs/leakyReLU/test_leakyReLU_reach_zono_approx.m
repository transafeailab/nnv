lb = [-1; 1];
ub = [1; 2];
B = Box(lb, ub);
W = rand(2, 2);
I = B.toStar;
I_zono = B.toZono;
I = I.affineMap(W, []);
I_zono = I_zono.affineMap(W, []);
X = I.sample(10);

figure;
I.plot;
hold on;
plot(X(1, :), X(2, :), 'ob'); % sampled inputs

gamma = 0.1;
S = LeakyReLU.reach_star_approx(I, gamma);
S1 = LeakyReLU.reach_zono_approx(I_zono, gamma);
Y = LeakyReLU.evaluate(X, gamma);

figure;
Zono.plots(S1);
hold on;
Star.plots(S);
hold on;
plot(Y(1, :), Y(2, :), 'o');

