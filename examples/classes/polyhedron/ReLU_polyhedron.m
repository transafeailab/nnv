function R = ReLU_polyhedron(P)
% P: polyhedron input set
% R: output set

n = P.Dim; 
R = [];

R1 = P;
for i=1:n
    R1= stepReLU_multiple_inputs(R1, i);
    R = [R R1];
end
end

