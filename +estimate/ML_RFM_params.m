function [pars,se]=ML_RFM_params( itemResponse, deltaScores, o)

if nargin < 3 
    o = deltaScoring.scoring.Options;
end

deltaScores(deltaScores <= 0.001) = 0.001;
deltaScores(deltaScores >= 0.999) = 0.999;

pars = [];
se = []; 

for item = itemResponse

    f_ss = @(x) lklh(x,item,deltaScores,o);

    fittedParams = o.model;
    if ~isempty(fieldnames( o.ModelFixedParams))
        if isfield(o.ModelFixedParams,'c')
            fittedParams = 2;
        end

        if isfield(o.ModelFixedParams,'s')
             fittedParams = 1;
        end
    end
   
    if strcmp(o.RFM_params_method, 'unconstrained')
        p = fminsearch( f_ss, o.StartingPoint(1:fittedParams)); 
    else  
        optimOptions = optimoptions('fmincon','Display','none');
        p = fmincon( f_ss, o.StartingPoint(1:fittedParams), [], [], [], [], o.Lower(1:fittedParams) ,o.Upper(1:fittedParams),[],optimOptions); 
    end
    
    if ~isempty(fieldnames( o.ModelFixedParams))
        if isfield(o.ModelFixedParams,'c')
            p(:,3) = o.ModelFixedParams.c;
        end

        if isfield(o.ModelFixedParams,'s')
             p(:,2) = o.ModelFixedParams.s;
        end
    end
    
    pars = [pars; p];
    
    H = hessian(f_ss,p);
    
    se = [se; sqrt(diag(inv(H)))'];
end

function res = lklh(xi,itemResponse,deltaScores,o)

if ~isempty(fieldnames( o.ModelFixedParams))
    if isfield(o.ModelFixedParams,'c')
        xi(:,3) = o.ModelFixedParams.c;
    end

    if isfield(o.ModelFixedParams,'s')
        xi(:,2) = o.ModelFixedParams.s;
    end
end

res = -sum( itemResponse .* log(deltaScoring.scoring.PCR(xi, deltaScores, o)) + (ones(size(itemResponse,1),1) - itemResponse) .* log(1 - deltaScoring.scoring.PCR(xi, deltaScores, o)) );

