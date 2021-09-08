function [Dscore_equated] = dscore_rfm(X_params, X_rescaled, Dscores, type, o)

% [Dscore_equated] = dscore_rfm(X_params, X_rescaled, Dscores, type, o)
% Calculates equated latent D-Score based on the latent parameters
% 
% INPUT: 
%		X_params   - latent parameters of the test
%       X_rescaled - rescaled parameters of the test after equating
%		Dscores    - persons D-score
%		type       - default value is m1
%		o	       -  options
%
% OUTPUT:
%		Dscore_equated - equated D-score 	

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 4
    type = 'm1';
end

if nargin < 5
    o = deltaScoring.scoring.Options;
end



if strcmp(type,'m1')
    P = deltaScoring.scoring.PCR(X_params,Dscores,o);
    if size(X_rescaled,2) > 1
        R = ((1 - P)./ P).^ (ones(size(Dscores,1),1) * (1 ./ X_rescaled(:,2))' );
    else
        R = ((1 - P)./ P);
    end
    
    Ds = (ones(size(Dscores,1),1) * X_rescaled(:,1)' ) ./ ( R .* (1 - (ones(size(Dscores,1),1) * X_rescaled(:,1)' )) + (ones(size(Dscores,1),1) * X_rescaled(:,1)' ) );
    Dscore_equated = mean(Ds,2);
end
