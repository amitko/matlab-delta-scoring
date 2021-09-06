function res = itemPerformance(itemParameters,delta,o)
%Function
%prc(itemDifficultyLevels,itemDiscrimination,th,d,type)
%Calculates the probability for correct performance for the polytomous item
%
% INPUT:
%   itemParameters - row vector of values of the difficulty parameter
%                          for item grades.
%                           


if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options();
end

if nargin < 2
    delta = linspace(0.01,0.99);
end

res = [];

for k = 1:size(itemParameters,1)
    res = [res; deltaScoring.scoring.PCR(itemParameters(k,:), delta, o)];
end

