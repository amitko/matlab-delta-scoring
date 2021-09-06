function res = ccr(itemParameters,o)

if nargin < 2
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
pcr = deltaScoring.poly.itemPerformance(itemParameters,x,o);
pcr = [ones(1,size(pcr,2)); pcr; zeros(1,size(pcr,2))];

for k = 1:size(itemParameters,1)+1
    hold on
    plot(x, pcr(k,:) - pcr(k+1,:) , ['k-' t(k) ], 'LineWidth',1.2);
    L = [L, ['Category ' num2str(k-1)]];
    hold off
end

xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');
legend(L,'Location','northwest');
hold off;
