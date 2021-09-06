function f = plotConditionalSE(dScores,SE)

% Function plotConditionalSE(dScores,SE)
% plots conditional standard eroor 

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net


f = figure;
[S,I] = sort(dScores);
plot(S,SE(I),'k-','LineWidth',1.2);
xlabel('D-score');
ylabel('Standard error of D-score');
