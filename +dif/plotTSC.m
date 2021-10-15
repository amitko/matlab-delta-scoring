function f = plotTSC(focal_params,reference_params,o,visible)
% plotTSC(focal_params,reference_params,o,visible)
% Plots test score for the Focal and reference group

% Dimitar Atanasov, 2020
% datanasov@ir-statistics.net

if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

if nargin < 4
    visible = 'on';
end

f = figure('Visible',visible);

x = linspace(0,1)';

 pcr_f = deltaScoring.scoring.PCR(focal_params,x,o);
 pcr_r = deltaScoring.scoring.PCR(reference_params,x,o);
 plot(x,sum(pcr_f'),'k-', x,sum(pcr_r'),'k--', 'LineWidth',1.5);

 xlabel('D-score');
ylabel('Test score');
legend('Focal', 'Reference', 'Location','northwest');
