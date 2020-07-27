I = I_new;

if ~isempty(I)

    [lb, ub] = I.estimateRanges; 
    map1 = find(ub <= 0); % reset map
    map2 = find(lb < 0 & ub >0); % coarse split map

    x1 = I.V(:, 1) + I.V(:,2:I.nVar+1) * I.predicate_lb; % first test point
    x2 = I.V(:, 1) + I.V(:,2:I.nVar+1) * I.predicate_ub; % second test point
    map3 = find(x1 < 0 & x2 > 0);
    map4 = find(x1 > 0 & x2 < 0);

    map5 = [map3; map4]; % obvious split map
    map6 = setdiff(map2, map5); % a reduced map to find optimized ranges

    xmax = I.getMaxs(map6);
    map7 = find(xmax <= 0); 
    map8 = map6(map7(:)); % the index that has xmax <= 0

    map9 = [map1; map8]; % the final reset map that contains all neurons whose values <= 0

    xmin = I.getMins(map8); % minimum of the index that has xmax <= 0
    map10 = find(xmin < 0);
    map11 = map8(map10(:)); % the neuron indexes that has xmin <0 & xmax > 0

    map12 = [map5; map11]; % the final slit map containing all neurons that can split, i.e. values contain 0

    n_LP = length(map6) + length(map8);
    fprintf('\nNeglected LP: %d/%d = %.3f\%', I.dim - n_LP, I.dim, ((I.dim-n_LP*100)/I.dim));

    V1 = I.V; 
    V1(map9,:) = 0; % reset to zero all neurons whose values <= 0              

    N = length(map12); % there are N neurons to split
    M = 0:2^N-1; % there are 2^N new star sets
    A = de2bi(M)'; % Nx2^N matrix to memorize where the plit is, 0 <-> x <0, 1 <-> x > 0

    % construct 2^N star sets at the same time
    G = length(M);
    S(G) = Star;
    for i=1:G
        V2 = V1;
        V2(map12, :) = A(:,i).*V1(map12, :);
        C21 = -A(:,i).*V1(map12, 2:I.nVar+1);% x >0
        d21 = A(:,i).*V1(map12, 1);
        C22 = (1-A(:,i)).*V1(map12, 2:I.nVar+1); % x < 0
        d22 = -(1-A(:,i)).*V1(map12,1);
        C2 = C21 + C22;
        d2 = d21 + d22;
        S(i) = Star(V2, [I.C; C2], [I.d; d2], I.predicate_lb, I.predicate_ub);
    end



else
S = [];
end