function res=dScore(itemDeltas,response,t)

% function res=dScore(itemDeltas,response,t)
%
% Returns the so called d-Score for a person
% with a given response vector over a set
% of items with precalculated deltas;

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin == 2
    t = 'relative_to_d';
end

D = response * itemDeltas;

if strcmp(t,'total')
    res = D;
elseif strcmp(t,'relative_to_n')
    res = D ./ size(itemDeltas,1);
elseif strcmp(t,'relative_to_d')
    res = D ./ sum(itemDeltas);
else
    error('Not supported type!');
end
