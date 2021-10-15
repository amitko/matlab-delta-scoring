function res = responeseProbability(delta,item_parameters,o)
% res = responeseProbability(delta,item_parameters,o)
% Calculates the probability for correct response from a
% person with ability delta over the set of items with
% parameters, defined in item_parameters.
%
% INPUT
%   delta - Person ability
%   item_parameters - Item parameters [b,s,c]
%   o - Delta Scoring Options

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

if nargin < 3
    o = deltaScoring.scoring.Options;
end

f = fittype(o.Models{o.model});

if o.model == 1
    res = feval(f,item_parameters(:,1),delta);
elseif o.model == 2
    res = feval(f,item_parameters(:,1),item_parameters(:,2),delta);
elseif o.model == 3
    res = feval(f,item_parameters(:,1),item_parameters(:,3),item_parameters(:,2),delta); % Accorting to the alphabetical order of the parameter names
else
    error('Wrong number of parameters');
end
