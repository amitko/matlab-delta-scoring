function res = trueScoreSE(itemDeltas, parameters, dScore, o)
% res = trueScoreSE(itemDeltas, parameters, dScore, o)
% Calculates the true-score SE measure for person's dScode
% on a set of items with delta scores in itemDeltas, 
% logistic parameters of the items and the persons dScore
% 
%  INPUT:
%.   itemDeltas - item's delta scores
%.   parameters - item's logistics parameters
%.   dScore.    - persons dScore
%.   o.         - Options (defaults scoring.Options)

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

res = (sqrt(sum(((itemDeltas.^2 * ones(1,m))' .* (P .* (ones(m,n) - P) ))')) ./ sum(itemDeltas))';
