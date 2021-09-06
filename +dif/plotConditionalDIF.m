function f = plotConditionalDIF(dif,opt,visible)

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

if nargin < 3
    visible = 'on';
end

f = figure('Visible',visible);
x = linspace(0,1,size(dif,2))';

I = dif > 0;
 
hold on

bar(x(I == 1),abs(dif(I == 1)),'b');
bar(x(I == 0),abs(dif(I == 0)),'r');

xlabel('D-score');
ylabel('Observed P-difference');
xlim([0,1]);
%xticks(0:.1:1);
set(gca,'xtick',0:.1:1); 

if nargin < 2 || isempty(opt) 
    legend( 'against Reference','against Focal', 'Location','best');
else
    set(gca, 'YLim', [0, opt.yMax]);
    legend( ['against Reference | MPD=', num2str(opt.focal.mpd,'%.3f'), '; ES=', num2str(opt.focal.es,'%.3f')], ...
            ['against Focal | MPD=', num2str(opt.reference.mpd,'%.3f'), '; ES=', num2str(opt.reference.es,'%.3f')], ...
             'Location','best');
end
    
hold off
