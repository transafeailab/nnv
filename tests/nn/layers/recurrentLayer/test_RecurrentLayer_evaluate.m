% this example is from following paper (figure 2 in the paper):
% "Verifying Recurrent Neural Networks Using Invariant Inference, Yuval Jacoby, ATVA 2020"

S.Wh = 1;
S.bh = 0;
S.fh = 'poslin';
S.Wo = 1;
S.bo = 0;
S.fo = 'poslin';
S.Wi = 1;

L = RecurrentLayer(S);
x = [0.5 1.5 -1 -3];

[y,h] = L.evaluate(x); 