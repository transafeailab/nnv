
lb = [-0.5; -0.5];
ub = [0.5; 0.5];

B = Box(lb, ub);
I = B.toZono;

A = [0.5 1; 1.5 -2];
I = I.affineMap(A, []);


I1 = I.toStar;
X = I1.sample(100);

figure;
I.plot;
hold on;
plot(X(1, :), X(2, :), 'ob'); % sampled inputs

t = tic;
S1 = PosLin.reach_star_exact(I1, []); % exact reach set using star
t1 = toc(t);
%t = tic;
%S2 = PosLin.reach_star_exact2(I1, []); % exact reach set using star
%t2 = toc(t);
Y = PosLin.evaluate(X);

figure;
Star.plots(S1);
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs

%figure;
%Star.plots(S2);