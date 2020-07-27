N = 10000;
reverseStr = '';
for i = 1:N
    ...
    ...
    msg = sprintf('Processed %d/%d', i, N);
    fprintf([reverseStr, msg]);
    reverseStr = repmat(sprintf('\b'), 1, length(msg));
end