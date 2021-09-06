function [focal_params,reference_params,deltasF,deltasR] = paramsForGroups(itemResponse,group,latent,o)
% group 0 - reference, 1 - focal
% params by default are latent 

if nargin < 3 || isempty(latent)
    latent = 1;
end

if nargin < 4 || isempty(o)
    o=deltaScoring.scoring.Options();
end


if unique(group) ~= [0;1]
    error('GROUPS are not well defined');
end

itemResponseF = itemResponse(group == 1,:);
itemResponseR = itemResponse(group == 0,:);


deltasF = deltaScoring.estimate.itemDeltaBootstrap(itemResponseF);
dscoresF = deltaScoring.scoring.dScore(deltasF,itemResponseF);

deltasR = deltaScoring.estimate.itemDeltaBootstrap(itemResponseR);
dscoresR = deltaScoring.scoring.dScore(deltasR,itemResponseR);

if latent
    focal_params     = deltaScoring.estimate.ML_RFM_params(itemResponseF,dscoresF,o);
    reference_params = deltaScoring.estimate.ML_RFM_params(itemResponseR,dscoresR,o);
    %[latentDscores ld_se see] = deltaScoring.estimate.ML_RFM_scores(itemResponse, latentParams)
else
    focal_params     = deltaScoring.estimate.logitDeltaFit(itemResponseF,dscoresF,o);
    reference_params = deltaScoring.estimate.logitDeltaFit(itemResponseR,dscoresR,o);
end


    