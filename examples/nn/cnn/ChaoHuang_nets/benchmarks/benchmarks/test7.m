% S4 = OS4.toStar;
% [S, map8, lb1, ub1, ub2, map2, xmax, map3, map5, map4, map6, map7] = PosLin.reach_star_approx2(S4);

I = OS4.toStar;

if isempty(I)
    S = [];
else
    [lb, ub] = I.estimateRanges;
    if isempty(lb) || isempty(ub)
        S = [];
    else

        % find all indexes having ub <= 0, then reset the
        % values of the elements corresponding to these indexes to 0
        fprintf('\nFinding all neurons (in %d neurons) with ub <= 0...', length(ub));
        map1 = find(ub <= 0); % computation map
        fprintf('\n%d neurons with ub <= 0 are found by estimating ranges', length(map1));

        map2 = find(lb < 0 & ub > 0);
        fprintf('\nFinding neurons with ub <= 0 by optimizing ranges: ');
        xmax = I.getMaxs(map2);
        fprintf('\n%d neurons with ub <= 0 are found by optimizing ranges', length(map2));
        map3 = find(xmax <= 0);
        n = length(map3);
        map4 = zeros(n,1);
        for i=1:n
            map4(i) = map2(map3(i));
        end
        map11 = [map1; map4];
        In = I.resetRow(map11); % reset to zero at the element having ub <= 0
        fprintf('\n%d/%d neurons have ub <= 0', length(map11), length(ub));

        % find all indexes that have lb < 0 & ub > 0, then
        % apply the over-approximation rule for ReLU
        fprintf("\nFinding all neurons (in %d neurons) with lb < 0 & ub >0: ", length(ub));
        map5 = find(xmax > 0);
        map6 = map2(map5(:)); % all indexes having ub > 0
        xmax1 = xmax(map5(:)); % upper bound of all neurons having ub > 0

        xmin = I.getMins(map6); 
        map7 = find(xmin < 0); 
        map8 = map6(map7(:)); % all indexes having lb < 0 & ub > 0
        lb1 = xmin(map7(:));  % lower bound of all indexes having lb < 0 & ub > 0
        ub1 = xmax1(map7(:)); % upper bound of all neurons having lb < 0 & ub > 0
        
        fprintf('\n%d/%d neurons have lb < 0 & ub > 0', length(map8), length(ub));
        fprintf('\nConstruct new star set, %d new predicate variables are introduced', length(map8));
        S = PosLin.multipleStepReachStarApprox_at_one(In, map8, lb1, ub1); % one-shot approximation

    end
end
