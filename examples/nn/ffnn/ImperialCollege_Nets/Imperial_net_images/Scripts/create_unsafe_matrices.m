function U = create_unsafe_matrices(index)
U=zeros([9,10]);
U(:,index)=1;
for i=1:9
    if i<index
        U(i,i)=-1;
    end
    if i>=index
        U(i,i+1)=-1;
    end
end
end

