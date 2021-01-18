%% load network and input set
load mnist01.mat;

%% verify the image

numCores = 6; 
N = 100; % number of Images tested maximum is 100
%
eps = [0.05 0.1 0.15 0.2]; % epsilon for the disturbance
% eps = 0.05; % for testing only
%
relaxFactor = [0 0.25 0.5 0.75 1]; % relax factor
% relaxFactor = 0.25; % for testing only
%
methods = ["relax-star-random", "relax-star-area", "relax-star-range", "relax-star-bound"];
% methods = ["relax-star-random"]; % for testing
%
N1 = length(methods); % timeout for eps = 0.25
N2 = length(eps);
N3 = length(relaxFactor);


r = zeros(N1, N2, N3); % percentage of images that are robust
VT = zeros(N1, N2, N3); % total verification time

% use glpk for LP optimization
dis_opt = [];
lp_solver = 'glpk';
t1 = tic;
for i=1:N1
    for j=1:N2
        [IS, Labels] = getInputSet(eps(j));
        for k=1:N3
            t = tic;
            [r(i,j,k), ~, ~, ~, ~] = net.evaluateRBN(IS(1:N), Labels(1:N), methods(i), numCores, relaxFactor(k), dis_opt, lp_solver);
            VT(i, j, k) = toc(t);
        end
    end
end
total_VT = toc(t1);

save mnist01_relaxation.mat r VT;
%% Plot figures
for i=1:N1
    fig = figure;
    rb_rand = reshape(r(i, 1, :), [1, N3]);
    rb_area = reshape(r(i, 2, :), [1, N3]);
    rb_range = reshape(r(i, 3, :), [1, N3]);
    rb_bound = reshape(r(i, 4, :), [1, N3]);
    rb_DeepZ = rand(1, N3);
    rb_DeepPoly = rand(1, N3);
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
    xlabel('RF');
    ylabel('Robustness');
    str = sprintf('\\epsilon = %.2f', eps(i));
    title(str)
end

