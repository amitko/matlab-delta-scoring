function res=scaledScore(scores,t)

% Dimitar Atanasov, 2020
% datanasov@ir-statistics.net


if nargin == 2
    t = 'range';
end

if strcmp(t,'range')
    minScore = min(scores);
    maxScore = max(scores);
    res = round(100 * (scores - minScore) / (maxScore - minScore));
else
    error('Not supported type!');
end
