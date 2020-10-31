function f = plotICC(focal_params,reference_params,o)

if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

f = figure();
x = linspace(0,1)';

 pcr_f = deltaScoring.scoring.PCR(focal_params,x,o);
 pcr_r = deltaScoring.scoring.PCR(reference_params,x,o);
 plot(x,pcr_f,'k-', x,pcr_r,'k--', 'LineWidth',1.5);

 xlabel('D-score');
ylabel('Probability for correct response');
legend('Focal', 'Reference', 'Location','northwest');
