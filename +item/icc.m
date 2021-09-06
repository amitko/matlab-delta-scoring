function res = icc(itemParameters,o)

if nargin < 2
    o = deltaScoring.scoring.Options;
end

c = 'brgymck';
t = '.x+*odpsh<>v^';
lt{1} = '-';
lt{2} = ':';
lt{3} = '-.';
lt{4} = '--';


x = linspace(0,1);

res = figure;
hold on;

for k = 1:size(itemParameters,1)
    
    pcr = deltaScoring.scoring.PCR(itemParameters(k,:),x,o);
    plot(x,pcr,'k-', 'LineWidth',1.5);
end

xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');

hold off;
