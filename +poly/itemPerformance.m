function res = itemPerformance(itemParameters,delta,o)
% res = itemPerformance(itemParameters,delta,o)
%Calculates the probability for correct performance for the polytomous item
%
% INPUT:
%   itemParameters - row vector of values of the difficulty parameter
%                          for item grades.
%	 delta 		   - person ability value
%	 o             - options
%
% OUTPUT:
%	res - probability for correct performance

% Dimitar Atanasov, 2020
% datanasov@ir-statistics.net                            


if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options();
end

if nargin < 2
    delta = linspace(0.01,0.99);
end

res = [];

for k = 1:size(itemParameters,1)
    res = [res; deltaScoring.scoring.PCR(itemParameters(k,:), delta, o)];
end

