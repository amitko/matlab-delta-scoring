function [DIF, DIFT,  HA, HB, HAT, HBT, Results] = testing(focal_params, reference_params, o)

if nargin < 3
    o = deltaScoring.scoring.Options();
end

if ~isfield(o,'alpha')
    alpha = 0.05;
else
    alpha = o.alpha;
end

HA = {};

%dScale = focalGroup;

dScale = [0.05:0.03:0.95]';

Results = struct;

[Results.focal_params_rescaled, Results.opts] = deltaScoring.equating.rescale_rfm(focal_params, reference_params, [(1:size(focal_params,1))' (1:size(focal_params,1))']);

Results.dScale = dScale;

Results.P_F = deltaScoring.scoring.PCR(Results.focal_params_rescaled,dScale,o);

Results.P_R = deltaScoring.scoring.PCR(reference_params,dScale,o);

Results.Z_F = z_transform(Results.P_F);
Results.Z_R = z_transform(Results.P_R);

for k = 1:size(Results.focal_params_rescaled,1)
    [HA{k}.h, HA{k}.p, HA{k}.c, HA{k}.s] = vartest2(Results.Z_F(:,k),Results.Z_R(:,k),'alpha',alpha);
end

DIF = [];
HB ={ };
for k = 1:size(Results.focal_params_rescaled,1)
    if HA{k}.h == 1
        HB{k}.h = 0;
        HB{k}.s.tstat = NaN;        
        HB{k}.p = NaN;        
        continue;
    end
    [HB{k}.h, HB{k}.p, HB{k}.c, HB{k}.s] = ttest2(Results.Z_F(:,k),Results.Z_R(:,k),'alpha',alpha);
end

DIF = zeros(size(Results.focal_params_rescaled,1),1);
for k = 1:size(Results.focal_params_rescaled,1)
    if HA{k}.h == 1
        DIF(k) = 1;
    end
    if HB{k}.h == 1
        DIF(k) = 2;
    end
    
end

HAT = struct;
HBT = struct;
DIFT = 0;

Results.T_R = sum(Results.P_R,2);
Results.T_F = sum(Results.P_F,2);

Results.ZT_F = z_transform(Results.T_F);
Results.ZT_R = z_transform(Results.T_R);

[HAT.h, HAT.p, HAT.c, HAT.s] = vartest2(Results.ZT_F,Results.ZT_R);
if HAT.h == 1
    DIFT = 1;
else
    [HBT.h, HBT.p, HBT.c, HBT.s] = ttest2(Results.ZT_F,Results.ZT_R);
    if HBT.h == 1
        DIFT = 2;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res = z_transform(values)
res = (1/1.702).*log(values ./ (1 - values));