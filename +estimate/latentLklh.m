function res = latentLklh(xi,itemResponse,deltaScores,o)
res = -sum(sum( itemResponse .* log(deltaScoring.scoring.PCR(xi, deltaScores, o)) + (ones(size(itemResponse,1),1) - itemResponse) .* log(1 - deltaScoring.scoring.PCR(xi, deltaScores, o)) ));

