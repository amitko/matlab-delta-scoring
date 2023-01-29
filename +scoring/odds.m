function res = odds(b,d)

n = size(b,1); % N of items
m = size(d,1); 

res = ((ones(n,1) * (1-d)') .* ( b *  ones(1,m)) ) ./ ((ones(n,1) * d') .* ((1-b) *  ones(1,m)));