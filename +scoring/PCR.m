function res = PCR(params,delta,o)
% res = PCR(params,delta,o)
% Probability for correct response
% based on estimated parameters of the logistic function
%
%   INPUT:
%     params - logistics parameres
%     delta  - delta values
%     o      - options
%               mmodel

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 3
    o = deltaScoring.scoring.Options;
end

n = size(params,1); % N of items
m = size(delta,1); % N of persons

if o.model == 1  % RFM1 
    res = ones(n,m) ./ (ones(n,m) + deltaScoring.scoring.odds(params(:,1), delta ) .^ones(n,m));
    %res = ones(n,m) ./ (ones(n,m) + (((ones(n,1) * (1-delta)') .* ( params(:,1) *  ones(1,m)) ) ./ ((ones(n,1) * delta') .* ((1-params(:,1)) *  ones(1,m))) ).^ones(n,m));
    %res = ((params(:,1) * ones(1,m)) .* (ones(n,1) * delta')) ./ ((params(:,1) * ones(1,m)) - (ones(n,1) * delta') + ones(n,m) );
elseif o.model == 2 % RFM2
    res = ones(n,m) ./ (ones(n,m) + deltaScoring.scoring.odds(params(:,1), delta ) .^(params(:,2) *  ones(1,m)));
    %res = ones(n,m) ./ (ones(n,m) + (((ones(n,1) * (1-delta)') .* ( params(:,1) *  ones(1,m)) ) ./ ((ones(n,1) * delta') .* ((1-params(:,1)) *  ones(1,m))) ).^(params(:,2) *  ones(1,m)));
elseif o.model == 3 % RFM3
    res = params(:,3) * ones(1,m) + ((ones(n,m) - params(:,3) * ones(1,m) )./  (ones(n,m) + deltaScoring.scoring.odds(params(:,1), delta ) .^(params(:,2) *  ones(1,m))));
    %res = params(:,3) * ones(1,m) + ((ones(n,m) - params(:,3) * ones(1,m) )./  (ones(n,m) + (((ones(n,1) * (1-delta)') .* ( params(:,1) *  ones(1,m)) ) ./ ((ones(n,1) * delta') .* ((1-params(:,1)) *  ones(1,m))) ).^(params(:,2) *  ones(1,m))));
%elseif o.model == 4 % Logistic regession 2PL
%    res = ones(n,m) - ( ones(n,m) ./ ( ones(n,m) + ((ones(n,1) * delta') ./ (params(:,2) * ones(1,m))) .^ (params(:,1) *  ones(1,m))));
%elseif o.model == 5 % Logistic regession 3PL
%    res = ones(n,m) - ( (ones(n,m) - params(:,3) * ones(1,m) ) ./ ( ones(n,m) + ((ones(n,1) * delta') ./ (params(:,2) * ones(1,m))) .^ (params(:,1) *  ones(1,m))));
%elseif o.model == 6 % Logistic regession 4PL
%    res = params(:,4) * ones(1,m) - ( (ones(n,m) - params(:,3) * ones(1,m) ) ./ ( ones(n,m) + ((ones(n,1) * delta') ./ (params(:,2) * ones(1,m))) .^ (params(:,1) *  ones(1,m))));
%elseif o.model == 7 % Cubic
%    res = (ones(m,1) * params(:,1)')' + (ones(m,1) * params(:,2)')' .* (ones(n,1) * delta') + (ones(m,1) * params(:,3)')' .* ((ones(n,1) * delta')).^2 + (ones(m,1) * params(:,4)')' .* ((ones(n,1) * delta')).^3; 
else
    error('Unsupported model!');
end

res = res';

