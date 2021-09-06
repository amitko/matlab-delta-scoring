function [res, expected, variance] = likelihood(dScores,item_parameters,item_response,o)

% based on
% D. Dimitrov, R. Smith. Adjusted Rasch Person-Fit Statistics. J. of
% Applied measurement. 2006
%
%

if nargin < 4
    o = deltaScoring.scoring.Options;
end

probOfPerformance = [];

for k=1:size(item_parameters,1)
    probOfPerformance(end+1,:) = deltaScoring.person.responeseProbability(dScores,item_parameters(k,:),o);
end

% Eqn 5
res = sum(item_response' .* log(probOfPerformance) + ( 1 - item_response)' .* log(1 - probOfPerformance))';

% Eqn 6
expected = sum( probOfPerformance .* log(probOfPerformance)  + (1 - probOfPerformance) .* log(1 - probOfPerformance) )';

%eqn 7
variance = sum( probOfPerformance .* ( 1 - probOfPerformance ) .* (  log (probOfPerformance ./  (1 - probOfPerformance) ).^2  ))';
