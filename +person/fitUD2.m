function res = fitUD2( deltas, Dscore, responses, params, o)

if size(Dscore,1) ~= size(responses,1)
    error('Dscores not matsh responses');
end

if size(params,1) ~= size(responses,2)
    error('Deltas matsh responses');
end

if nargin < 4
    o = deltaScoring.scoring.Options;
end

res = zeros(size(Dscore,1),1);
    
for k = 1:size(Dscore,1)

    prc = deltaScoring.scoring.PCR(params,Dscore(k),o)';
    [Ds,Is] = sort(deltas);
    
    Gr = responses(k,Is);
    G = Ds <= Dscore(k);
    G1 = G(end:-1:1);
    %G1 = Ds >=  Dscore(k);
    
    Lnd = log(prc(Is)./(1 - prc(Is)));
    res(k,:) =  ( sum(Lnd .* G) - sum(Lnd .* Gr')) ./ (sum(Lnd .* G) - sum(Lnd .* G1));

end


