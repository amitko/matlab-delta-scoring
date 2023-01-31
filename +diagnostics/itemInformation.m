function res = itemInformation(params,d)
% res = deltaScoring.diagnostics.itemInformation(params,d)
%
% Calculates item information function for set of items 
% on values, defined by column d.
%
% For test information function takes sum(res).

% Dimitar Atanasov, 2023
% datanasov@nbu.bg

P = deltaScoring.scoring.PCR(params,d);

res = [];
for k=1:size(P,2)
    res(k,:) = ((P(:,k) .* ( 1 - P(:,k)).* params(k,2)^2 )  ./ (d .^ 2 .* (1 - d).^2 ))';
end
