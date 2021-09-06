function res = MAD(params,observedLogitDelta,o)

if nargin < 3
    o = deltaScoring.scoring.Options;
end

res = zeros(size(params,1),1);

for k = 1:size(params,1)
    sk = find(observedLogitDelta(:,k) > 0);
    prc = deltaScoring.scoring.PCR( params(k,:), o.dScale, o );
    res(k) = mean( abs( observedLogitDelta(sk,k) - prc(sk) ))';
end
