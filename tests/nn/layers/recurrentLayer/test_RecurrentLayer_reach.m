L = RecurrentLayer.rand(2, 2, 2, {'poslin', 'purelin'}); % random generate a vanilla recurrent layer

I1 = Star.rand(2); % random 2-dimensional star set I1
x1 = I1.sample(10); % random points in I1
x1 = x1(:,1);

I2 = Star.rand(2); % random 2-dimensional star set I2
x2 = I2.sample(10); % random points in I2
x2 = x2(:, 1);

I3 = Star.rand(2); % random 2-dimensional star set I3
x3 = I3.sample(10); % random points in I3
x3 = x3(:, 1); 

I = [I1 I2 I3]; % the sequence random star star input sets

x = [x1 x2 x3]; % a sequence of points in the input sets
y = L.evaluate(x); % evaluate the output y of the layer given the input sequence x

fig1 = figure;
subplot(1,3,1);
Star.plots(I1); % plot input set I1
title('Input 1');
hold on; 
plot(x1(1), x1(2), 'x', 'color', 'red'); % plot point x1 in I1

subplot(1,3,2);
Star.plots(I2); % plot input set I2
title('Input 2');
hold on;
plot(x2(1), x2(2), 'x', 'color', 'red'); % plot point x2 in I2

subplot(1,3,3);
Star.plots(I3); % plot input set I3
title('Input 3'); 
hold on;
plot(x3(1), x3(2), 'x', 'color', 'red'); % plot point x3 in I3


[O,H] = L.reach_core(I, 'exact-star', []); % compute exact reachable set of L given input sequence I
[O2, H2] = L.reach_core(I, 'approx-star'); % compute the approximate reachable set of L 

% exact outputs
fig01 = figure;
subplot(1,3,1);
Star.plots(O{1}); % plot the exact reachable sets O1
title('Exact Output 1');
hold on;
y1 = y(:, 1);
plot(y1(1), y1(2), 'x', 'color', 'red');

subplot(1,3,2);
Star.plots(O{2}); % plot the exact reachable sets O2
title('Exact Output 2');
hold on;
y2 = y(:, 2);
plot(y2(1), y2(2), 'x', 'color', 'red');

subplot(1,3,3);
Star.plots(O{3}); % plot the exact reachable sets O3
title('Exact Output 3');
hold on;
y3 = y(:, 3);
plot(y3(1), y3(2), 'x', 'color', 'red');


% approximate outputs
fig04 = figure;
subplot(1,3,1);
Star.plots(O2{1});
title('Approx Output 1'); % plot the approximate reachable set O1
hold on;
y1 = y(:, 1);
plot(y1(1), y1(2), 'x', 'color', 'red');

subplot(1,3,2);
Star.plots(O2{2}); % plot the approximate reachable set O2
title('Approx Output 2');
hold on;
y2 = y(:, 2);
plot(y2(1), y2(2), 'x', 'color', 'red');

subplot(1,3,3);
Star.plots(O2{3}); % plot the approximate reachable set O3
title('Approx Output 3');
hold on;
y3 = y(:, 3);
plot(y3(1), y3(2), 'x', 'color', 'red');