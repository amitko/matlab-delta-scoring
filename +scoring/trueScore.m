function res = trueScore(itemDeltas, parameters, dScore, o)
% res = trueScore(itemDeltas, parameters, dScore, o)
% Calculates the true-score measure for person's dScode
% on a set of items with delta scores in itemDeltas,
% logistic parameters of the items and the persons dScore
%
%  INPUT:
%   itemDeltas - item's delta scores
%   parameters - item's logistics parameters
%   dScore    - persons dScore
%   o         - Options (defaults scoring.Options)

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 4
    o = deltaScoring.scoring.Options;
end;

if size(parameters,1) ~= size(itemDeltas,1)
    error('Item deltas and parameters does not match');
end;

n = size(parameters,1);
m = size(dScore,1);

P = deltaScoring.scoring.PCR(parameters,dScore,o);

res = ( sum(((itemDeltas * ones(1,m))' .* P )') ./ sum(itemDeltas))';
