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
%
% OUTPUT:
%	h - figure habdle


% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

s = 'o+*^xdspv><dsp';
hold on;

L = {};

x = 0:0.05:1;
for k = 1:length(GF)

    GFl = GF{k};
    %h = plot([0:0.1:1], GFl.parameters,[  'd-' ],'MarkerSize',10);
    y = feval(GFl.parameters,x);
    h = plot(x,y,['k' s(k) '--']);
    set(h, 'LineWidth',1.2)

    L = [L  ['Fitted ' num2str(k)]];

    if ~isempty(observedLogitDelta)
        sk = find(observedLogitDelta(:,k) > 0);
        if isempty(sk)
            continue;
        end
        xLim = [o.dScale(sk(1)) o.dScale(sk(end))];


        plot(o.dScale(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot)),observedLogitDelta(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot),k),['k' s(k) '-.' ], 'LineWidth',1.2);

        L = [L  ['Observed ' num2str(k)]];
    end
end

xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');
legend(L,'Location','northwest');

hold off;
