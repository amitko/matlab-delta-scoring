function [onFocal, onReference] = MPDonDIF(dif)
% [onFocal, onReference] = MPDonDIF(dif)
% dif = pcr_f - pcr_r;


% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net



onFocal     = zeros(1,size(dif,1));
onReference = zeros(1,size(dif,1));

for k=1:size(dif,1)
    I = dif(k,:) > 0;

    onFocal(k)     = mean(abs(dif(k,I == 1)));
    onReference(k) = mean(abs(dif(k,I == 0)));
end

onFocal(isnan(onFocal)) = 0;
onReference(isnan(onReference)) = 0;
