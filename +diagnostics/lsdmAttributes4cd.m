function [res at_least] = lsdmAttributes4cd(attr_performance)
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

for t = 1 : size( attr_performance,1 ) % for each ability level
    r = [];
    s = -sort(-attr_performance(t,:));
    for p = 0:size( attr_performance,2 ) % for each  'p'
        r = [r deltaScoring.lib.comb_probability( attr_performance(t,:),p) ];
    end
    res = [res; r];
end

resc = zeros(size(res));

resc(end,:) = res(end,:);

for t = size(res,2)-1:-1:1
    resc(:,t) = resc(:,t + 1) + res(:, t);
end


at_least = [];
for k = 1 : size( attr_performance,1 )
    for l = 1:size(res,2)
        at_least(k,l) = sum(res(k,l:end));
    end
end

