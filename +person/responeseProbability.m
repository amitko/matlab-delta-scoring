function res = responeseProbability(delta,item_parameters,o)

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