%% load network and input set
load mnist01.mat;

%% verify the image

numCores = 8; 
N = 100; % number of Images tested maximum is 100
%
eps = 0.15; % epsilon for the disturbance
%
relaxFactor = [0 0.25 0.5 0.75 1]; % relax factor
% relaxFactor =0; % for testing only
methods = ["relax-star-random", "relax-star-area", "relax-star-range", "relax-star-bound"];
%
N1 = length(methods); % timeout for eps = 0.25
N2 = length(relaxFactor);

r = zeros(N1, N2); % percentage of images that are robust
VT = zeros(N1, N2); % total verification time

% use glpk for LP optimization
dis_opt = [];
lp_solver = 'glpk';
t1 = tic;
for i=1:N1
    [IS, Labels] = getInputSet(eps);
    for j=1:N2
        t = tic;
        [r(i,j), ~, ~, ~, ~] = net.evaluateRBN(IS(1:N), Labels(1:N), methods(i), numCores, relaxFactor(j), dis_opt, lp_solver);
        VT(i, j) = toc(t);
    end
end
total_VT = toc(t1);

save mnist01_relaxation2.mat r VT;
%% Plot figures

% robustness
fig1 = figure;
rb_rand = reshape(r(1,:), [1, N2]);
rb_area = reshape(r(2,:), [1, N2]);
rb_range = reshape(r(3,:), [1, N2]);
rb_bound = reshape(r(4,:), [1, N2]);
rb_DeepZ = [0.47 0.47 0.47 0.47 0.47]; % result from ERAN
rb_DeepPoly = [0.67 0.67 0.67 0.67 0.67]; % result from ERAN
plot(relaxFactor, rb_rand, '-*');
hold on;
plot(relaxFactor, rb_area, '-x');
hold on;
plot(relaxFactor, rb_range, '-o');
hold on;
plot(relaxFactor, rb_bound, '-s');
hold on;
plot(relaxFactor, rb_DeepZ, '-v');
hold on;
plot(relaxFactor, rb_DeepPoly, '-+');
legend('relax-star-random', 'relax-star-area', 'relax-star-range', 'relax-star-bound', 'DeepZ', 'DeepPoly');
xlabel('Relaxation Factor (RF)');
ylabel('Robustness');
str = sprintf('\\epsilon = %.2f', eps);
title(str)
ax = gca; 
ax.FontSize = 13;

% verification time
fig2 = figure;
vt_rand = reshape(VT(1,:), [1, N2]);
vt_area = reshape(VT(2,:), [1, N2]);
vt_range = reshape(VT(3,:), [1, N2]);
vt_bound = reshape(VT(4,:), [1, N2]);
vt_DeepZ = [314.7 314.7 314.7 314.7 314.7]; % result from ERAN
vt_DeepPoly = [136.5 136.5 136.5 136.5 136.5]; % result from ERAN
plot(relaxFactor, vt_rand, '-*');
hold on;
plot(relaxFactor, vt_area, '-x');
hold on;
plot(relaxFactor, vt_range, '-o');
hold on;
plot(relaxFactor, vt_bound, '-s');
hold on;
plot(relaxFactor, vt_DeepZ, '-v');
hold on;
plot(relaxFactor, vt_DeepPoly, '-+');
legend('relax-star-random', 'relax-star-area', 'relax-star-range', 'relax-star-bound', 'DeepZ', 'DeepPoly');
xlabel('Relaxation Factor (RF)');
ylabel('Verification Time (s)');
str = sprintf('\\epsilon = %.2f', eps);
title(str)
ax = gca; 
ax.FontSize = 13;

