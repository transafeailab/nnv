function R = stepReLU_multiple_inputs(P, id)
% P is an array of polyhedra
% id is the index

n = length(P);
R = [];
for i=1:n
    R = [R stepReLU_polyhedron(P(i), id)];
    
end
end

