
lb = [-1; -2; -1];
ub = [1; 1; 1];
B = Box(lb, ub);
I = B.toStar;
X = I.sample(100);

figure;
I.plot;
hold on;
plot3(X(1, :), X(2, :), X(3,:), 'ob'); % sampled inputs

t = tic;
S = PosLin.reach_star_approx(I); % over-approximate reach set
t1 = toc(t);
S1 = PosLin.reach(I); % exach reach set
t = tic;
S2 = PosLin.reach_star_approx2(I); % new-over-approximate method
t2 = toc(t);

Y = PosLin.evaluate(X);

figure;
S.plot;
hold on;
Star.plots(S1);
hold on;
plot3(Y(1, :), Y(2, :), Y(3,:), '*'); % sampled outputs

figure;
Star.plots(S2);
