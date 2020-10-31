function f = itemPersonMap(itemD,studentsDScore,N_of_bins,hidden,ops)

% function f = itemPersonMap(itemD,studentsDScore,N_of_bins)
%     Plots distribution of person's dScore and items deltas
%     on a common scale.
%
%     default N_of_bins = 20

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net




if nargin < 3 || isempty(N_of_bins)
    N_of_bins = 20;
end

if nargin < 4 || hidden == 0
    f = figure;
else
    f = figure('Visible','off');
end

if nargin < 5
    ops.xlabel = 'Delta Scale';
    ops.title = 'Item-Person Map';
    ops.ylabel = 'frequency (%)';
    ops.legend = {'delta','D-score'};
end

range = linspace(0,1,N_of_bins);
deltasCnt = (histc(itemD,range)./size(itemD,1)) * 100;
dScoreCnt = (histc(studentsDScore,range)/size(studentsDScore,1)) * 100;
bar(range,[deltasCnt dScoreCnt],'histc');
xlim([0 1]);
ylim([0 max([deltasCnt; dScoreCnt])]);
title(ops.title);
ylabel(ops.ylabel);
xlabel(ops.xlabel);
legend(ops.legend);
