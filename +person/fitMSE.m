function [Outfit, Infit] = fitMSE(item_response, expected_item_score)

[N_persons,N_items] = size(item_response);


if nargin < 2
    E = mean(item_response);
else
    E = expected_item_score';
end
    
V = E.*(1-E);

EE = ones(1,N_persons)'*E;
VV = ones(1,N_persons)'*V;

Outfit = mean( ( (item_response - EE ).^2 ) ./ VV, 2 );
Infit  = sum ( (item_response - EE ).^2 ,2 ) ./ sum(V);
