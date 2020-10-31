function [estimatedDeltas, estimatedSE, sampleDeltas, allEstimates] = itemDeltaBootstrap(itemResponse,options)

% [estimatedDeltas, estimatedSE, sampleDeltas, allEstimates] = estimateItemDeltaBootstrap(itemResponse,options)
% Calculates the bootstrapped item deltas (1 - probability for correct response)
%
% INPUT:
%   itemResponse - dichotomous item response 0/1
%   options      - structure of options, default defined by Option.m
%                   NofSamplesForBootstrapping
%                   sampleProportionForBootstrapping
%                   estTypeForBootstrapping - ['mean', 'mode', 'median' (dafault)]

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


if nargin < 2
    options = deltaScoring.scoring.Options();
end

% Set Options
NofSamples       = options.NofSamplesForBootstrapping;
sampleProportion = options.sampleProportionForBootstrapping;

[NofStudents NofItems] = size(itemResponse);

sampleDeltas = [];

h = waitbar(0,['Bootstrapped 0 samples out of ' num2str(NofSamples)]);

for k = 1:NofSamples
    sampleData = itemResponse(randsample(1:NofStudents,round( NofStudents * sampleProportion )),:);
    sampleDeltas = [sampleDeltas; 1 - mean(sampleData)];
    waitbar(k/NofSamples,h,['Bootstrapped ' num2str(k) ' samples out of ' num2str(NofSamples)]);
end

close(h);

estimatedDeltas = [];
estimatedSE = std(sampleDeltas)';

allEstimates = [min(sampleDeltas)' mean(sampleDeltas)' mode(sampleDeltas)' median(sampleDeltas)' max(sampleDeltas)'];

if strcmp(options.estTypeForBootstrapping,'mean')
    estimatedDeltas = mean(sampleDeltas)';
elseif strcmp(options.estTypeForBootstrapping,'mode')
    estimatedDeltas = mode(sampleDeltas)';
elseif strcmp(options.estTypeForBootstrapping,'median')
    estimatedDeltas = median(sampleDeltas)';
end
