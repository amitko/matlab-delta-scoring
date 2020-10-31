function res = singleTest(nOfItems, itemDeltas, varargin)
% function res = singleTest(nOfItems, itemDeltas, varargin)
%
% Returnt the item idexex from the itemParams
% which compose a test.
% 
% nOfItems - number of items in teh test.
% itemDeltas - list (column) of estimated item deltas
%
% Optional parameters: ['Name',value] pairs

% Dimitar Atanasov. 2017
% datanasov@ir-statistics.net

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

addRequired(inP,'nOfItems',@isnumeric);
addRequired(inP,'itemDeltas',@isnumeric);

addParameter(inP,'Options',deltaScoring.scoring.Options());

addParameter(inP,'excludedItems',def_excludedItems,@isnumeric);
addParameter(inP,'requiredItems',def_requiredItems,@isnumeric);

addParameter(inP,'addEqualitiesLHS',def_addEqualitiesLHS,@isnumeric);
addParameter(inP,'addEqualitiesRHS',def_addEqualitiesRHS,@isnumeric);
addParameter(inP,'addInequalitiesLHS',def_addInequalitiesLHS,@isnumeric);
addParameter(inP,'addInequalitiesRHS',def_addInequalitiesRHS,@isnumeric);

addParameter(inP,'meanOfDeltas',def_meanOfDeltas,@isnumeric);
addParameter(inP,'meanOfDeltasTolerance',def_meanOfDeltasTolerance,@isnumeric);
addParameter(inP,'deltaDistribution',def_deltaDistribution,@isnumeric);

addParameter(inP,'targetFunction',def_targetFunction,@isnumeric);

%parse(inP, nOfItems, itemParams, abilityScaleValues,varargin{:});
parse(inP, nOfItems, itemDeltas, varargin{:});

disp('===== Compose single test with parameters ====');
inP.Results

% ====== Init Values =====

numItems = size(inP.Results.itemDeltas,1);
itemDeltas = inP.Results.itemDeltas;
lb = zeros(numItems,1);
ub = ones(numItems,1);

IntCon = 1:numItems;


% === Equality constraints ====

% number of items in the test
Ae = [ones(1,numItems)];
be = [nOfItems];


% === Inequality constraints ====
A = [];
b = [];

% sum of deltas greater then the meanOfDeltas - meanOfDeltasTolerance;

A = [A; -itemDeltas' ./ nOfItems];
b = [b; -inP.Results.meanOfDeltas + inP.Results.meanOfDeltasTolerance];

% sum of deltas less then the meanOfDeltas + sumOfDeltasTolerance;

A = [A; itemDeltas' ./ nOfItems ];
b = [b; inP.Results.meanOfDeltas + inP.Results.meanOfDeltasTolerance];

% excluded items forced to be 0 : Ax = 0
if ~isempty(inP.Results.excludedItems)
    zr = zeros(1,numItems);
    zr(inP.Results.excludedItems) = 1;
    Ae = [Ae; zr];
    be = [be; 0];
end

inP.Results.deltaDistribution

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
    
    
    for k = 0:nRange-1
        AA = zeros(1,size(Ae,2));
        AA(itemDeltas > k/nRange & itemDeltas <= (k+1)/ nRange) = 1;
        Ae = [Ae;AA];
        be = [be; inP.Results.deltaDistribution(k+1)];
    end
end


% required items forced to be 1 : Ax = size(requiredItems)
if ~isempty(inP.Results.requiredItems)
    zr = zeros(1,numItems);
    zr(inP.Results.requiredItems) = 1;
    Ae = [Ae; zr];
    be = [be; size(inP.Results.requiredItems,2)];
end

% additional equalities
if ~isempty(inP.Results.addEqualitiesLHS)
    Ae = [Ae; inP.Results.addEqualitiesLHS];
    be = [be; inP.Results.addEqualitiesRHS];
end

% additional inequalities
if ~isempty(inP.Results.addInequalitiesLHS)
    A = [A; inP.Results.addInequalitiesLHS];
    b = [b; inP.Results.addInequalitiesRHS];
end


% Optimized function
if ~isempty(inP.Results.targetFunction)
    f = inP.Results.targetFunction;
else
    f = ones(1,numItems);
end

% ===== Optimizing =======
options = optimoptions('intlinprog','MaxNodes',numItems * 2);
x = intlinprog(f,IntCon,A,b,Ae,be,lb,ub,options);

if abs(sum(x) - nOfItems) > 1
    warning('singleTest:NoItems',['Can not find a required set of items! Review the restrictions! ' num2str(sum(x)) ' of ' num2str(nOfItems) ' items found!!!']);
end

res = find(x > 0);

