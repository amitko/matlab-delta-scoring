function [res, out] = guttman(NofPersons,itemParams,options,reverse)

if nargin < 3 || isempty(options)
    options = deltaScoring.scoring.Options();
end

if nargin < 4
    reverse = 0;
end

out = struct;
J = size(itemParams,1);

% Generate persons delta scores
out.dScore = random('norm',0.5,0.1667,NofPersons,1);
out.dScore(out.dScore > 1) = 1;
out.dScore(out.dScore < 0) = 0;
 

itemCharacteristics = deltaScoring.item.characteristicsFromParameters(itemParams,options);

res = zeros(NofPersons,size(itemParams,1));
% Generate scores
for k = 1:NofPersons
    if reverse == 0
        res(k,itemCharacteristics(:,1) <= out.dScore(k)) = 1;
    else 
        res(k,itemCharacteristics(:,1) > out.dScore(k) ) = 1;
    end
end