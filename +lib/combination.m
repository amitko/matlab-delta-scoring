function res=combination(n,k)
% Function res=combination(n,k)
% returns the 0/1 matrix for 
% n_choose_k combinatorial problem

% Dimitar Atanasov, 2009
% datanasov@nbu.bg

C = nchoosek([1:n],k);

res = zeros(size(C,1),n);

for h = 1:size(res,1)
    res(h,C(h,:)) = ones(1,k);
end
