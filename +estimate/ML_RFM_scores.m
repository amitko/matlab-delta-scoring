function [scores,se, see]=ML_RFM_scores( itemResponse, itemParams, o)
% [scores,se, see]=ML_RFM_scores( itemResponse, itemParams, o)
% Estimates the latent parameters for person abilities, based on
% RFM model, using JML approach.
%
% INPUT:
%		itemResponse - dichotomous item response
%		itemParams  - person D-scores
%		o            - oprions
%
% OUTPUT:
%		scores       - person latent D-scores
%		se           - standard errors of the estimates
%       see          - analitical solution for se

% Dimitar Atanasov, 2020
% datanasov@ir-statistics.net


if nargin < 3
    o = deltaScoring.scoring.Options;
end

scores = zeros(size(itemResponse,1),1);
se     = zeros(size(itemResponse,1),1);
see    = zeros(size(itemResponse,1),1);
% using one-pass high dimensional solution.
%f_ss = @(x) lklh(itemParams,itemResponse,x,o);
%optimOptions = optimoptions('fmincon','Display','iter','MaxFunctionEvaluations',1000000);
%scores = fmincon( f_ss, 0.5*ones(size(itemResponse,1),1) , [], [], [], [],  zeros(size(itemResponse,1),1) .+ 0.01, ones(size(itemResponse,1),1) .* 0.99,[],optimOptions);

calcSE = 0;
if exist('hessian') > 0
    calcSE = 1;
end

for person = 1:size(itemResponse,1)
    
    
    if (sum(itemResponse(person,:)) == length( itemResponse(person,:) ))
        
       scores(person) = 0.99;
       
    elseif (sum(itemResponse(person,:)) == 0)
        
        scores(person) = 0.01;
        
    else

        f_ss = @(x) deltaScoring.estimate.latentLklh(itemParams,itemResponse(person,:),x,o);

        optimOptions = optimoptions('fmincon','Display','none');

        s = fmincon( f_ss, 0.5 , [], [], [], [],  0, 1 ,[],optimOptions);

        scores(person) = s;

        if calcSE > 0
            H = deltaScoring.lib.derivest.hessian(f_ss,s);
            se(person) = sqrt(diag(inv(H)))';
        end
        see(person) = se_est(s,itemParams,o);
    end

end

function res = se_est(d,pars,o)

if size(pars,2) < 2
    pars = [pars  ones(size(pars))];
end

res = (d*(1-d))/sqrt( sum( (pars(:,2)' .^2) .* deltaScoring.scoring.PCR(pars, d, o) .* (1 - deltaScoring.scoring.PCR(pars, d, o))) );
