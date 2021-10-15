function res = latentLklh(xi,itemResponse,deltaScores,o)
% latentLklh(xi,itemResponse,deltaScores,o)
% Calculates person likelihood on a specific test with a specific item response
% For internal use in estimations


% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

res = -sum(sum( itemResponse .* log(deltaScoring.scoring.PCR(xi, deltaScores, o)) + (ones(size(itemResponse,1),1) - itemResponse) .* log(1 - deltaScoring.scoring.PCR(xi, deltaScores, o)) ));

