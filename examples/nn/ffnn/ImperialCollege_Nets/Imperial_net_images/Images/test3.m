R = net.reach(S_eps_002(1), 'approx-star', 1);
[l1, u1] = R.estimateRanges;
U = [0 0 0 0 -1 0 0 1 0 0];
S1 = R.intersectHalfSpace(U, 0);
R.is_p1_larger_than_p2(5,8)

