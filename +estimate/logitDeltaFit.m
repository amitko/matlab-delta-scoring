function [params, CI, GF, Results] = logitDeltaFit(itemData,dScores,o)

%[params, CI, GF, Results] = logitDeltaFit(itemData,dScores,o)
% Fits the logistic function (2,3,4 PL) to the observed item performance
%
% INPUT:
%   itemData - dichotomous item response 0/1
%   dScore   - estimated person's dScore
%   o        - options (defaults from Options.m)
%               dScale   - vector with scale values
%               type     - ['prop', 'raw'] fits to the proportions or raw response
%               model    - [1,2,3,...]
%               param_lb - lower boundary of the parameters
%               param_ub - upper boundary of the parameters
%               start_point - starting point of the parameters
%               Model_coefficients - coeffitients of the model
%               StartingPoint - starting point of the optimization
%
% OUTPUT:
%   params  - estimatet values of the parameters
%   CI      - 95% confidence intervals of the estimated parameters
%   GF      - fitted object
%   Results - additional results
%               dScale
%               StartingPoint
%               Model
%               type
%               observedLogitDelta
%               MAD

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 3 || isempty(o)
    o = deltaScoring.scoring.Options;
end

Results.dScale = o.dScale;
Results.StartingPoint = o.StartingPoint;
Results.Model = o.model;
Results.type = o.type;

Results.observedLogitDelta = deltaScoring.scoring.observedLogitDelta(itemData,dScores,o);

if strcmp(o.type,'prop')
    x = o.dScale;
    to_fit = Results.observedLogitDelta;
elseif strcmp(o.type,'raw')
    x = dScores;
    x(find(x <= 0)) = 0.01;
    x(find(x >= 1)) = 0.99;
    to_fit = itemData;
else
    error('Unsupported type');
end


%-----------------------------Fit the data---------------------------------
GF = {};
params = [];
CI = [];
for y = to_fit

    if o.model == 1
        nParams = 1;
        Model_lb = 0.01;
        Model_ub = 0.99;
        start_point = 0.5;
    elseif o.model == 2
        nParams = 2;
        Model_lb = [0.01 0.3];
        Model_ub = [0.99 3];
        start_point = [0.5 1];
    elseif o.model == 3
        nParams = 3;
        Model_lb = [0.01 0.3 0];
        Model_ub = [0.99 5 0.5];
        start_point = [0.5 1 0.1];
    else
        error('Unsuported model!!!');
    end
    
    
        
    Coeff2fit = o.Model_coefficients(1:nParams);

    problemParams = {};
    problemValues = [];
        
    if ~isempty(fieldnames(o.ModelFixedParams))
        for pf = fields(o.ModelFixedParams)'
            problemParams(end+1) = pf;
            problemValues(end+1) = o.ModelFixedParams.(pf{1});
        end
        
        Coeff2fit = setdiff(Coeff2fit,fields(o.ModelFixedParams));
             
        if isempty(Coeff2fit)
            Results.MAD = [];
            return;
        end
        
        ft_ = fittype(o.Models{o.model} ,...
             'dependent',{'y'},'independent',{'x'},...
             'problem', problemParams,...
             'coefficients',setdiff(Coeff2fit,fields(o.ModelFixedParams)));
    else
        ft_ = fittype(o.Models{o.model},...
             'dependent',{'y'},'independent',{'x'},...
             'coefficients',Coeff2fit);
    
    end

    
    iM = ismember(o.Model_coefficients(1:nParams), Coeff2fit);
        
    lb = Model_lb(1:nParams);
    ub = Model_ub(1:nParams);
    sp = start_point(1:nParams);
    lb = lb(iM);
    ub = ub(iM);
    sp = sp(iM);
    

    
     fo_ = fitoptions('method','NonlinearLeastSquares',...
                     'Lower',lb,...
                     'Upper',ub);
        set(fo_,'Startpoint',sp);
        
     
     if isempty(problemValues)
        [cf, G] = fit(x,y,ft_,fo_);
     else
         [cf, G] = fit(x,y,ft_,fo_,'problem',num2cell(problemValues));
     end
     g.parameters = cf;
     g.fit = G;
     GF = [GF, {g} ];

     ci = confint(cf);

     rr = [];
     rc = [];
     countedParams = 0;
     for k = 1:nParams
         if isfield(o.ModelFixedParams,o.Model_coefficients{k})
            rr = [rr o.ModelFixedParams.(o.Model_coefficients{k})];
            rc = [rc 0 0];         
         else
            countedParams = countedParams + 1; 
            rr = [rr cf.(o.Model_coefficients{k})];
            rc = [rc ci(1,countedParams) ci(2,countedParams)];
         end
     end
     CI = [CI; rc];
     params = [params; rr];

end


Results.MAD = deltaScoring.item.MAD(params,Results.observedLogitDelta,o);

% Results.MAD = zeros(size(params,1),1);
% 
% for k = 1:size(params,1)
%     sk = find(Results.observedLogitDelta(:,k) > 0);
%     prc = deltaScoring.scoring.PCR( params(k,:), o.dScale, o );
%     Results.MAD(k) = mean( abs( Results.observedLogitDelta(sk,k) - prc(sk) ))';
%end