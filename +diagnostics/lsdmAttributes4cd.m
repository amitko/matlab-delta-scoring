function [res at_least] = lsdmAattributes4cd(attr_performance)
% Function lsdmAttributes4cd(attr_performance)
%
% Calculates the probabilities for performing on k
% cognitive attributes.  
%   Input:
%       attr_performance - Attribute performance for the set
%                          of ability levels
%   Output:
%       res - matrix with probabilities of performing
%           k attributes. The rows represnts k,
%           the columns - ability levels.
%       at_least - matrix with probabilities of performing
%           at least k attributes. The rows represnts k,
%           k from 0, the columns - ability levels.

% Dimitar Atanasov, 2010
% datanasov@nbu.bg

res = [];

for t = 1 : size( attr_performance,2 ) % for each ability level
    r = [];
    s = -sort(-attr_performance(:,t));
    for p = 0:size( attr_performance,1 ) % for each  'p'
        r = [r comb_probability( attr_performance(:,t)',p) ];
    end
    res = [res r'];
end

resc = zeros(size(res));

resc(end,:) = res(end,:);

for t = size(res,1)-1:-1:1
    resc(t,:) = resc(t + 1,:) + res( t ,:);
end


at_least = [];
for k = 1 : size( attr_performance,2 )
    for l = 1:size(res,1)
        at_least(l,k) = sum(res(l:end,k));
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

C = combination(n,k);

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
