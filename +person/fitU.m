function res = fitU( params, Dscore, responses, o)

if size(Dscore,1) ~= size(responses,1)
    error('Dscores not matsh responses');
end

if size(params,1) ~= size(responses,2)
    error('Deltas does not match responses');
end

if nargin < 4
    o = deltaScoring.scoring.Options;
end


[sortedB,I] = sort(params(:,1));
sortedParams = params(I,:);

res = zeros(size(Dscore,1),1);
    
for k = 1:size(Dscore,1)

    prc = deltaScoring.scoring.PCR(sortedParams,Dscore(k),o)';
    prc(prc > 0.9999) = 0.999;
    Lnd = log(prc ./(1 - prc ));

    %GuttmanResponse = prc;
    GuttmanResponse = sortedB <= Dscore(k);
    ReverseGuttman = sortedB > Dscore(k);
    
    res(k,:) =  ( sum(Lnd .* GuttmanResponse) - sum(Lnd .* responses(k,:)')) ./ (sum(Lnd .* GuttmanResponse) - sum(Lnd .* ReverseGuttman));

end


