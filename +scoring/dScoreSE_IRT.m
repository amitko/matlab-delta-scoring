function res = dScoreSE_IRT(parameters, theta)

% Returns the so called d-Score SE for a person
% with a given a given ability theta (on a logit scale)
% over a set of items with IRT parameters [b,a,c];

% left here only for convenience.

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

expected_score = expected.ItemScore(parameters);
deltas = (ones(size(expected_score)) - expected_score)';

itemVar = irT.irt.ItemVariance(parameters,theta);
res = sqrt( deltas.^2 * itemVar);
