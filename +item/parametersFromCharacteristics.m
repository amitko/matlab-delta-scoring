function res = parametersFromCharacteristics(location,discrimination,o)
% res =res = parametersFromCharacteristics(location,discrimination,o)
% Calculates the item parameters from item characteristics 
%
% INPUT: 
%	location	
%	discrimination
%	o           - options
%
% OUTPUT
%	res - [b,s]	

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 3
    o = deltaScoring.scoring.Options;
end

if o.model == 1
    res = location;
else
    s = 4 .* discrimination .* (1 - location) .* location;
    res = [location, s];
%    error('Unsupported!!!');
end

