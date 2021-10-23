function res = MAD(params,observedLogitDelta,o)
% res = MAD(params,observedLogitDelta,o)
% Calculates the Mean Absolute Difference between
% opserved probability for correct response and
% predicted probability obtained under the
% selected RFM model.
%
% INPUT:
%	params             - item parameters
%	observedLogitDelta - observed PCR
%	o                  - options
%
% OUTPUT:
% 	res - MAD values

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 3
    o = deltaScoring.scoring.Options;
end

res = zeros(size(params,1),1);

for k = 1:size(params,1)
    sk = find(observedLogitDelta(:,k) > 0);
    prc = deltaScoring.scoring.PCR( params(k,:), o.dScale, o );
    res(k) = mean( abs( observedLogitDelta(sk,k) - prc(sk) ))';
end
