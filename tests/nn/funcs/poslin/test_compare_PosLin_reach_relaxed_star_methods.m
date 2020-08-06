
I0 = ExamplePoly.randVrep; 
I0.outerApprox;
V = [-1 1; 1 1;1 0];
I = Star(V', I0.A, I0.b, I0.Internal.lb, I0.Internal.ub); % input star
X = I.sample(100);

figure;
I.plot;
hold on;
plot(X(1, :), X(2, :), 'ob'); % sampled inputs


S0 = PosLin.reach(I); % exach reach set
S1 = PosLin.reach_star_approx2(I); % new-over-approximate method
S2 = PosLin.reach_relaxed_star_ub(I,0.5, [], 'display'); % over-approximate reach set
S3 = PosLin.reach_relaxed_star_lb_ub(I,0.5, [], 'display'); % over-approximate reach set
S4 = PosLin.reach_relaxed_star_area(I,0.5, [], 'display'); % over-approximate reach set
S5 = PosLin.reach_relaxed_star_random(I, 0.5, [], 'display');
S6 = PosLin.reach_relaxed_star_static(I, 0.5, [], 'display');

Y = PosLin.evaluate(X);

figure;
S2.plot;
hold on;
Star.plots(S0);
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs
title("Approx-star reach set vs. Exact reach set")

figure;
S2.plot;
hold on;
Star.plots(S0);
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs
title("Relax-star-ub reach set vs. Exact reach set")

figure;
S3.plot;
hold on;
Star.plots(S2);
title("Relax-lb-ub vs. no relaxation");

figure;
S4.plot;
hold on;
Star.plots(S0);
hold on;
plot(Y(1, :), Y(2, :), '*'); % sampled outputs
title("Relax-star-area reach set vs. Exact reach set");

figure; 
S2.plot('r'); % relax-star-ub
hold on;
S3.plot('b'); % relax-star-lb-ub
title('relaxed-star-lb-ub(blue) vs relax-star-ub(red)');

figure;
S2.plot('r'); % relax-star-ub
hold on;
S4.plot('y'); % relax-star-area
title('relaxed-star-area(yellow) vs relax-star-ub(red)');

figure;
S5.plot('r'); % relax-star-random
hold on;
S4.plot('y'); %relax-star-area
title('relaxed-star-area(yellow) vs relax-star-random(red)');

figure;
S6.plot('r'); % relax-star-static
hold on;
S4.plot('y'); %relax-star-area
title('relaxed-star-area(yellow) vs relax-star-static(red)');
