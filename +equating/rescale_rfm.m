function [X_params_rescaled, opts] = rescale_rfm(X_params,Y_params,common_items,method_type,o)

% X - New test which should be rescaled on the scale of test Y (base test).
% type - direct | trough_a - type of calculation of the rescaling for s.

% datanasov@ir-statistics.net, 2020

if nargin < 4
    method_type = 'direct';
end

if nargin < 5
    o = deltaScoring.scoring.Options;
end

opts = struct;
X_params_rescaled = zeros(size(X_params));

[opts.bA,opts.bB]= deltaScoring.equating.constants(Y_params(:,1),X_params(:,1),common_items);

 X_params_rescaled(:,1) = deltaScoring.equating.rescale(X_params(:,1),opts.bA,opts.bB);


if size(X_params_rescaled,2) > 1
    
    if strcmp(method_type,'direct')
        opts.sA = std(Y_params(:,2)) / std(X_params(:,2));
        opts.sB = mean(Y_params(:,2)) - opts.sA .* mean(X_params(:,2));

        X_params_rescaled(:,2) = opts.sA .* X_params(:,2) + opts.sB;

    elseif strcmp(method_type,'trough_a')
        Xc = deltaScoring.item.characteristicsFromParameters(X_params,o);
        Yc = deltaScoring.item.characteristicsFromParameters(Y_params,o);

        opts.sA = std(Yc(:,2)) / std(Xc(:,2));
        opts.sB = mean(Yc(:,2)) - opts.sA .* mean(Xc(:,2));

        Xa = opts.sA .* Xc(:,2) + opts.sB;

        X_params_rescaled(:,2) = deltaScoring.item.parametersFromCharacteristics(X_params_rescaled(:,1),Xa,0);

    elseif strcmp(method_type,'log')    

        opts.sA = std(log(Y_params(:,2))) / std(log(X_params(:,2)));
        opts.sB = mean(log(Y_params(:,2))) - opts.sA .* mean(log(X_params(:,2)));

        X_params_rescaled(:,2) = exp(opts.sA .* log(X_params(:,2)) + opts.sB); 
    
    elseif strcmp(method_type,'exp')
        
        t = exp(-X_params(:,2));
        [opts.sA,opts.sB] = deltaScoring.equating.constants(exp(-Y_params(:,2)),t,common_items);
        X_params_rescaled(:,2) = -log(deltaScoring.equating.rescale(t,opts.sA,opts.sB));


    end
end


if size(X_params_rescaled,2) > 2
    X_params_rescaled(:,3) = X_params(:,3);
end

