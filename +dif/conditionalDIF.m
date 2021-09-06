function dif = conditionalDIF(focal_params,reference_params,o)
% conditionalDIF(focal_params,reference_params,o,visible)
%
%

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

if nargin < 2 || isempty(o)
    o = deltaScoring.scoring.Options;
end


x = linspace(0,1,30)';

dif = zeros(size(focal_params,1),numel(x));

for k = 1:size(focal_params,1)
    pcr_f = deltaScoring.scoring.PCR(focal_params(k,:),x,o);
    pcr_r = deltaScoring.scoring.PCR(reference_params(k,:),x,o);

    dif(k,:) = pcr_f - pcr_r;
end
