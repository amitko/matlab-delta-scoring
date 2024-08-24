function res = ccr(itemParameters,observedLogitDelta,o)

if nargin < 3
    o = deltaScoring.scoring.Options;
end

c = 'brgymck';
t = 'o+*^xdspv><dsp';
lt{1} = '-';
lt{2} = ':';
lt{3} = '-.';
lt{4} = '--';


x = linspace(0,1,20);

res = figure;
hold on;
L = {};
for k = 1:size(itemParameters,1)    
    pcr = deltaScoring.poly.itemPerformance(itemParameters(k,:),x,o);
    plot(x,pcr,['k-' t(k) ], 'LineWidth',1.2);
    L = [L  ['Fitted ' num2str(k)]];

    if ~isempty(observedLogitDelta) 
        sk = find(observedLogitDelta(:,k) > 0);
        if isempty(sk)
            continue;
        end

        if ~isempty(observedLogitDelta(:,k))
            plot(o.dScale(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot)),observedLogitDelta(sk(o.skipObservedOnPlot:end-o.skipObservedOnPlot),k),['k' t(k) '-.' ], 'LineWidth',1.2);
            L = [L  ['Observed ' num2str(k)]];
        end
    end
end

xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');
legend(L,'Location','northwest');
hold off;
