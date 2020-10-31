function res = observedLogitDelta(ItemResponse, Dscore,o)
% observedLogitDelta(ItemResponse, Dscore,o)
% Calculates the proportions of the correct scores
% for different falues of the dScale
%
% INPUT:
%   ItemResponse - dichotomous item response 0/1
%   Dscore       - estimated person's dScore
%   o            - options
%                dScale

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

res = [];

N = size(ItemResponse,1);

d_prev = 0;
for d = o.dScale'
    I = find(Dscore <= d & Dscore > d_prev);
    R = [];
    for Item = ItemResponse
        prop = sum(Item(I))/size(I,1);
        if isnan(prop)
            R = [R 0];
        else
            R = [R prop];
        end;
    end;
    res = [res; R];
    d_prev = d;
end;
