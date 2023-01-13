function [res res_all]=comb_probability(p,k)
% Function [res res_all]=comb_probability(p,k)
% calculates combinatorial probability
% to occur k events from the set A_1,...,A_n 
% with probabilityes p_1,...,p_k
%
% INPUT:
%       p - vector of probabilities p_1,...,p_n
%       k - number of events to occur
%
% OUTPUT:
%       res     - the result probability
%       res_all - emements of the sum. res = sum(res_all)

% Dimitar Atanasov, 2009
% datanasov@nbu.bg

res = 0;
res_all = [];
n = size(p,2);

C = deltaScoring.lib.combination(n,k);

for l = 1:size(C,1)
    tr = 1;
    for m = 1:size(C,2)
        if C(l,m) == 1
            tr = tr * p(m);
        else
            tr = tr * (1 - p(m));
        end
    end
    res_all = [res_all tr]; 
end
res = sum(res_all');
