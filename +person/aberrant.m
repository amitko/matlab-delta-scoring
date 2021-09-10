function res = aberrant(itemParams,itemDeltas,Dscores,itemResponse,options)
% res = aberrant(itemParams,itemDeltas,Dscores,itemResponse,options)
% Find aberrant person behaviour according
% to the "quantile method" according to
% An Examination of Different Methods of Setting Cutoff Values in Person Fit Research
% Amin Mousavi, Ying Cui & Todd Rogers
%
% INPUT:
%	itemParams   - item parameters
%	itemDeltas   - item deltas
%	Dscores      - persons D-scores
%	itemResponse - dichotomous item response
%
% OUTPUT:
%	res - aberrant indicator 0/1

% Dimitar Atanasov, 2020
% datanasov@ir-statistics.net

if nargin < 5
    options = deltaScoring.scoring.Options;
end

artificialSample = deltaScoring.generate.itemResponse(5000,itemParams,options,[]);
artDscores =  deltaScoring.scoring.dScore(itemDeltas,artificialSample);

ExpectedU = deltaScoring.person.fitU(itemParams,artDscores,artificialSample,options);

Uq = quantile(ExpectedU,options.aberrantQuantile);

observedU = deltaScoring.person.fitU(itemParams,Dscores,itemResponse,options);

res = observedU > Uq;
