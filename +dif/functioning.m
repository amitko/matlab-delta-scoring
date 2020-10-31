function [TDF, CDIF, NCDIF, t_TDF, t_NCDIF, Results] = functioning (focal_params, reference_params, focalGroup, o)

if nargin < 4
    o = deltaScoring.scoring.Options();
end

%dScale = focalGroup;

dScale = [0.05:0.035:0.095]';

focalGroupSize = size(focalGroup,1);

focal_params_rescaled = deltaScoring.equating.rescale_rfm(focal_params, reference_params, [(1:size(focal_params,1))' (1:size(focal_params,1))'])

Results = struct;
Results.dScale = dScale;

Results.P_F = deltaScoring.scoring.PCR(focal_params_rescaled,dScale,o);

Results.P_R = deltaScoring.scoring.PCR(reference_params,dScale,o);

Results.T_F = sum(Results.P_F,2);
Results.T_R = sum(Results.P_R,2);
Results.d = Results.P_F - Results.P_R;
Results.DT = Results.T_F - Results.T_R;


TDF = std(Results.DT)^2 + mean(Results.DT)^2;
t_TDF = (mean(Results.DT) / std(Results.DT)) * sqrt(focalGroupSize);

CDIF = [];
NCDIF = [];
t_NCDIF = [];
for k = 1:size(Results.d,2)
    c = cov(Results.d(:,k),Results.DT);
    CDIF(:,k) = c(1,2) + mean(Results.d(:,k)) * mean(Results.DT);
    NCDIF(:,k) = std(Results.d(:,k))^2 + mean(Results.d(:,k))^2;
    t_NCDIF(:,k) = (mean(Results.d(:,k)) / std(Results.d(:,k))) * sqrt(focalGroupSize);
end