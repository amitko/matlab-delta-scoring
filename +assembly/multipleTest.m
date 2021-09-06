function res = multipleTest(nOfTest, nOfItems, itemDeltas, varargin)

% Required items can be alligned with 0

% =====  parse the inputs ====
inP = inputParser;
inP.KeepUnmatched = true;

def_excludedItems = [];
def_requiredItems = [];
def_addEqualitiesLHS = [];
def_addEqualitiesRHS = [];
def_addInequalitiesLHS = [];
def_addInequalitiesRHS = [];
def_targetFunction = [];

def_meanOfDeltas = 0.5;
def_meanOfDeltasTolerance = 0.1;
def_deltaDistribution = [];


addRequired(inP,'nOfTest',@isnumeric);
addRequired(inP,'nOfItems',@isnumeric);

addRequired(inP,'itemDeltas',@isnumeric);
addParameter(inP,'Options',deltaScoring.scoring.Options());

addParameter(inP,'excludedItems',def_excludedItems,@isnumeric);
addParameter(inP,'requiredItems',def_requiredItems,@isnumeric);

addParameter(inP,'addEqualitiesLHS',def_addEqualitiesLHS,@isnumeric);
addParameter(inP,'addEqualitiesRHS',def_addEqualitiesRHS,@isnumeric);
addParameter(inP,'addInequalitiesLHS',def_addInequalitiesLHS,@isnumeric);
addParameter(inP,'addInequalitiesRHS',def_addInequalitiesRHS,@isnumeric);

addParameter(inP,'targetFunction',def_targetFunction,@isnumeric);

addParameter(inP,'meanOfDeltas',def_meanOfDeltas,@isnumeric);
addParameter(inP,'meanOfDeltasTolerance',def_meanOfDeltasTolerance,@isnumeric);
addParameter(inP,'deltaDistribution',def_deltaDistribution,@isnumeric);

parse(inP, nOfTest, nOfItems, itemDeltas, varargin{:});

disp('===== Compose multiple test with parameters ====');
inP.Results

% ====== Check =====
if ~isempty(inP.Results.requiredItems) && (size(inP.Results.requiredItems,1) ~= nOfTest)
    error('Required items does not match teh number of tests!!!');
end

% ====== Init Values =====
numItems = size(inP.Results.itemDeltas,1);
itemDeltas = inP.Results.itemDeltas;

if ~isempty(inP.Results.excludedItems)
    excludedItems = inP.Results.excludedItems;
else
    excludedItems = [];
end

if ~isempty(inP.Results.targetFunction)
    ff = inP.Results.targetFunction;
else
    ff = ones(1,numItems);
end
    

res = [];

for k = 1:nOfTest
    
    % === Equality constraints ====

%    if k == nOfTest
%        shadowTestScale = 0;
%    else
        shadowTestScale = (nOfTest - k);
%    end

    if shadowTestScale == 0
        f = ff;
    else
        f = [ff ff];
    end

% number of items in the test
    if shadowTestScale == 0
        Ae = ones(1,numItems);
        be = nOfItems;
    else
        Ae = [ones(1,numItems), zeros(1,numItems); zeros(1,numItems) , ones(1,numItems) ];
        be = [nOfItems; nOfItems * shadowTestScale ];
    end
    
    % === Inequality constraints ====
    A = [];
    b = [];
        
   
    if ~isempty(inP.Results.deltaDistribution)
        if sum(inP.Results.deltaDistribution,2) ~= nOfItems 
            error('Distribution of deltas does not match nOfItems');
        end

        nRange = size(inP.Results.deltaDistribution,2);

        expectedMeanDelta = (inP.Results.deltaDistribution ./ nOfItems) * ((0:(nRange - 1)) /(nRange - 1))';

        if expectedMeanDelta > inP.Results.meanOfDeltas + inP.Results.meanOfDeltasTolerance || expectedMeanDelta < inP.Results.meanOfDeltas - inP.Results.meanOfDeltasTolerance 
            expectedMeanDelta
            inP.Results.meanOfDeltas
            inP.Results.meanOfDeltasTolerance
            error('Mean of deltas does not correspond the the distribution of deltas required.');
        end


        for l = 0:nRange-1
            AA = zeros(1,numItems);
            AA(itemDeltas > l/nRange & itemDeltas <= (l+1)/ nRange) = 1;
            
            if shadowTestScale == 0
                Ae = [Ae; AA];
                be = [be; inP.Results.deltaDistribution(l+1)];
            else
                Ae = [Ae;[AA zeros(1,numItems)]; [zeros(1,numItems) AA]];
                be = [be; inP.Results.deltaDistribution(l+1); inP.Results.deltaDistribution(l+1) .* shadowTestScale ];
            end
        end
    end


    % excluded items forced to be 0 : Ax = 0
    if ~isempty(excludedItems)
        if shadowTestScale == 0
            zr = zeros(1,numItems);
            zr(excludedItems') = 1;  
        else
            zr = zeros(1,numItems * 2);
            zr([excludedItems' excludedItems' + numItems]) = 1;  
        end
        
        Ae = [Ae; zr];
        be = [be; 0];
    end
    
    % required items forced to be 1 : Ax = size(requiredItems)
    if ~isempty(inP.Results.requiredItems)
        reqItems = inP.Results.requiredItems(k,inP.Results.requiredItems(k,:) > 0);
        if shadowTestScale == 0
            zr = zeros(1,numItems);
        else
            zr = zeros(1,numItems * 2);
        end
        
        zr(reqItems) = 1;
        Ae = [Ae; zr];
        be = [be; size(reqItems,2)];
    end
    
    % additional equalities
    if ~isempty(inP.Results.addEqualitiesLHS)
        if shadowTestScale == 0
            Ae = [Ae; inP.Results.addEqualitiesLHS];
        else
            Ae = [Ae; [inP.Results.addEqualitiesLHS zeros(size(inP.Results.addEqualitiesLHS))]];
        end
        be = [be; inP.Results.addEqualitiesRHS ];
    end

    % additional inequalities
    if ~isempty(inP.Results.addInequalitiesLHS)
        if shadowTestScale == 0
            A = [A; inP.Results.addInequalitiesLHS ];
        else
            A = [A; [inP.Results.addInequalitiesLHS zeros( size(inP.Results.addInequalitiesLHS))]];
        end
        
        b = [b; inP.Results.addInequalitiesRHS];
    end

    

    % ===== Optimizing =======
    %x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub);
    
    if shadowTestScale == 0
        ID = itemDeltas;
    else
        ID = [itemDeltas; itemDeltas];
    end
    inCurrentTest = [];
    inCurrentTest = deltaScoring.assembly.singleTest(nOfItems + nOfItems * shadowTestScale, ID, ...
                                    'addEqualitiesLHS',Ae,...
                                    'addEqualitiesRHS',be,...
                                    'addInequalitiesLHS',A,...
                                    'addInequalitiesRHS',b,...
                                    'targetFunction',f,...
                                    'meanOfDeltasTolerance', inP.Results.meanOfDeltasTolerance,...
                                    'meanOfDeltas', inP.Results.meanOfDeltas...
                                    );

    
    if isempty(inCurrentTest)
        inCurrentTest = zeros(nOfItems,1);
        res = [];
        return;
    end
                                
    res = [res inCurrentTest(1:nOfItems)];
    
    excludedItems = [excludedItems; inCurrentTest(1:nOfItems)];
    
end


