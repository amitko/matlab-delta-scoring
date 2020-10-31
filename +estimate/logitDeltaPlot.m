function h = logitDeltaPlot(GF,observedLogitDelta,o)
% h = logitDeltaPlot(GF,observedLogitDelta,o)
% Plots the fit and the estimated logistics curve
% Returns the figure object
%
% INPUT:
%    GF - output from logitDeltaFit
%    observedLogitDelta - from Results of logitDeltaFit
%    o - options
%           dScale


% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

sk = find(observedLogitDelta > 0);
if isempty(sk)
    return;
end

xLim = [o.dScale(sk(1)) o.dScale(sk(end))];

hold on;
h = plot(GF.parameters,'k-');
set(h, 'LineWidth',2)

plot(o.dScale(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot)),observedLogitDelta(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot)),'k-.', 'LineWidth',2);
xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');
legend('Fitted','Observed','Location','northwest');

hold off;
