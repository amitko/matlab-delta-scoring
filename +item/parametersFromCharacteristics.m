function res = parametersFromCharacteristics(location,discrimination,o)

if nargin < 3
    o = deltaScoring.scoring.Options;
end

if o.model == 1
    res = location;
else
    s = 4 .* discrimination .* (1 - location) .* location;
%    error('Unsupported!!!');
end
