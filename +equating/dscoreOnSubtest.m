function res = dscoreOnSubtest(itemParameters,itemParamatersRescaled,itemDeltas,dScore,o)
% NOT IN USE

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 5
    o = deltaScoring.scoring.Options;
end


Pd = deltaScoring.scoring.PCR(itemParameters,dScore,o);

Dm = (sum( itemDeltas * ones(size(Pd,1),1)' ) ./ sum( itemDeltas ))';

Pm = deltaScoring.scoring.PCR(itemParamatersRescaled,Dm,o);

if size(itemParamatersRescaled,2) > 1
    R = ((1 - Pd)./ Pd).^ (ones(size(dScore,1),1) * (1 ./ itemParamatersRescaled(:,2))' );
else
    R = ((1 - Pd)./ Pd);
end

Ds = (ones(size(dScore,1),1) * itemParamatersRescaled(:,1)' ) ./ ( R .* (1 - (ones(size(dScore,1),1) * itemParamatersRescaled(:,1)' )) + (ones(size(dScore,1),1) * itemParamatersRescaled(:,1)' ) );
res = mean(Ds,2);

