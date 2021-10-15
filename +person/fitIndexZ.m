function res = fitIndexZ(lklh,Elklh,Vlklk)
% fitIndexZ(lklh,Elklh,Vlklk)
%  Inputs are from person.likelihood
%
% based on
% D. Dimitrov, R. Smith. Adjusted Rasch Person-Fit Statistics. J. of
% Applied measurement. 2006

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

% Eqn 4
res = (lklh - Elklh) ./ sqrt (Vlklk);
