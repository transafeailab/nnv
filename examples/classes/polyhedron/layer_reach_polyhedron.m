function R = layer_reach_polyhedron(W, b, P)
% W: affine mapping matrix of the layer
% b: bias vector of the layer
% P: polyhedron input set

% affine mapping

I = W*P + b; 
R = ReLU_polyhedron(I);
end

