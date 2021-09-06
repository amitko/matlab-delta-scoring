function [res, out] = itemResponse(Persons,itemParams,options,env)

% initial
if nargin < 3 || isempty(options)
    options = deltaScoring.scoring.Options();
end

if nargin < 4
    env = [];
end

out = struct;
J = size(itemParams,1);

if size(Persons,2) == 1
    % Generate persons delta scores
    NofPersons = Persons;
    out.dScore = random('norm',0.5,0.1667,NofPersons,1);
    out.dScore(out.dScore > 1) = 1;
    out.dScore(out.dScore < 0) = 0;
else
    out.dScore = Persons;
    NofPersons = size(Persons,2);
end

% Generate scores
res = [];
for k=1:size(out.dScore,2)
    prc = deltaScoring.scoring.PCR(itemParams,out.dScore(k),options);
    res(k,:) = random('bino',ones(1,J),prc,1,J);
end

res( isnan(res) ) = 0;

if ~isstruct(env)
    return;
end

%cheating occurs
if isfield(env,'cheating') && isstruct(env.cheating)
    out.cheating.cheated = zeros(NofPersons,1);
    out.cheating.persons = zeros(NofPersons,1);
    for k = 1:NofPersons
        if out.dScore(k) >= env.cheating.bellow
            continue;
        end
        out.cheating.persons(k) = 1;
        out.cheating.cheated(k) = random('bino',1,env.cheating.proportion);
    end
    
    res(out.cheating.cheated == 1,env.cheating.onItems) = 1;
end

if isfield(env,'guessing') && isstruct(env.guessing)
    out.guessing.guessed = zeros(NofPersons,1);
    out.guessing.persons = zeros(NofPersons,1);
    for k = 1:NofPersons
        if out.dScore(k) >= env.guessing.bellow
            continue;
        end
        out.guessing.persons(k) = 1;
        out.guessing.guessed(k) = random('bino',1,env.guessing.proportion);
        
        if out.guessing.guessed(k) == 0
            continue;
        end
        
        res(k,env.guessing.onItems) = random('bino',1,0.25,1,size(env.guessing.onItems,2));
        
        if sum(res(k,env.guessing.onItems)) >= 1 
            out.guessing.guessed(k) = 1;
        else
            out.guessing.guessed(k) = 0;
        end
    end
    
end










