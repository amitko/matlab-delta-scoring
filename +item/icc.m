function res = icc(itemParameters,o,legendStr)
% res = icc(itemParameters,o)
% Plots ICC curves under given item parameters
%
% INPUT:
%	itemParameters
%	o - options
%
% OUTPUT:
%	res  - figure handle

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if nargin < 2 || isempty(o)
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

cl = 1;
tp = 1;
for k = 1:size(itemParameters,1)

    pcr = deltaScoring.scoring.PCR(itemParameters(k,:),x,o);
    if  isfield(o,'colorPlot') && o.colorPlot == 1
        plot(x,pcr,[c(cl) t(tp) '-.'], 'LineWidth',1.5);
        cl = cl + 1;
        if cl == 8
            tp = tp + 1;
            cl = 1;
        end
    else
        plot(x,pcr,'k-', 'LineWidth',1.5);
    end
end

xlim([0 1]);
ylim([0 1]);
xlabel('D-score');
ylabel('Probability for correct response');

if nargin == 3 && ~isempty(legendStr)
    legend(legendStr);
end
hold off;
