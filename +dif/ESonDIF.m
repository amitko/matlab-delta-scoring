function [onFocal, onReference] = ESonDIF(focal_params,reference_params,o)
%

% dif = pcr_f - pcr_r;


% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net


dif = deltaScoring.dif.conditionalDIF(focal_params,reference_params,o)
x = linspace(0,1,30)';

props_focal     = zeros(size(focal_params,1),numel(x));
props_reference = zeros(size(focal_params,1),numel(x));

for k = 1:size(focal_params,1)
    props_focal(k,:)     = deltaScoring.scoring.PCR(focal_params(k,:),x,o);
    props_reference(k,:) = deltaScoring.scoring.PCR(reference_params(k,:),x,o);
end





onFocal     = zeros(1,size(dif,1));
onReference = zeros(1,size(dif,1));




for k=1:size(dif,1)
    I = dif(k,:) > 0;
    p1_onFocal =  mean(abs(props_focal(k,I == 1)));
    p2_onFocal =  mean(abs(props_reference(k,I == 1)));
    p1_onRef =  mean(abs(props_focal(k,I == 0)));
    p2_onRef =  mean(abs(props_reference(k,I == 0)));
    
    onFocal(k) = abs(2*asin(sqrt(p1_onFocal)) - 2*asin(sqrt(p2_onFocal)));
    onReference(k) = abs(2*asin(sqrt(p1_onRef)) - 2*asin(sqrt(p2_onRef)));
    
end

onFocal(isnan(onFocal)) = 0;
onReference(isnan(onReference)) = 0;
