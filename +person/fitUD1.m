function res = fitUD1(deltas, Dscore, responses)
% fitUD1(deltas, Dscore, responses)
% Calculates UD1 Statistics

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

if size(Dscore,1) ~= size(responses,1)
    error('Dscores not matsh responses');
end

if size(deltas,1) ~= size(responses,2)
    error('Deltas matsh responses');
end

res = zeros(size(Dscore,1),1);

[Ds,Is] = sort(deltas);

for k = 1:size(Dscore,1)
    Gr = responses(k,Is);
    G = Ds <=  Dscore(k);
    %G1 = G(end:-1:1);
    G1 = Ds >=  Dscore(k);

    Lnd = log((1 - Ds)./Ds);
    res(k,:) = ( sum(Lnd .* G) - sum(Lnd .* Gr')) ./ (sum(Lnd .* G) - sum(Lnd .* G1));

end


