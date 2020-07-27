load OS1_data.mat; 

OS2 = ImageStar(V, C, d, lb, ub);

%OS2.getRange(1,1,1);

%linprog([], C, d)

C1 = C(1:13296 - 100, 1:4573);
d1 = d(1:13296-100);