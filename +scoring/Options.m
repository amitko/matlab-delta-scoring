function option = Options(varargin)
% option = Options(varargin)
% Defines the options for DELTA SCORING
% Default Values
%
%         NofSamplesForBootstrapping: 1000
%   sampleProportionForBootstrapping: 0.1000
%            estTypeForBootstrapping: 'mode'
%                             dScale: [21×1 double]
%                             Models: {1×3 cell}
%                         ModelNames: {'RFM1'  'RFM2'  'RFM3'}
%                   ModelFixedParams: [1×1 struct]
%                 Model_coefficients: {'b'  's'  'c'  'd'}
%                              model: 2
%                               type: 'raw'
%                 skipObservedOnPlot: 2
%                   aberrantQuantile: 0.7000
%                                 EM: [1×1 struct]
%                      StartingPoint: [0.5000 1 0.1000]
%                              Lower: [0.0100 0.2000 0]
%                              Upper: [0.9900 5 0.5000]
%                  RFM_params_method: 'constrained'

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


% for bootstrapping
option.NofSamplesForBootstrapping = 1000;
option.sampleProportionForBootstrapping = 0.1;
option.estTypeForBootstrapping = 'mode';

%for logistics fit
option.dScale = [0:0.05:1]';
option.Models = {...
           '1/(1+(((1-x)*b)/(x*(1-b))))',...
           '1/(1+((((1-x)*b)/(x*(1-b)))^s))',...
           'c + ((1-c)/(1+(((1-x)*b)/(x*(1-b)))^s))',...
           };
           %'1-(1/(1+(x/B)^A))',...
           %'1-((1-C)/(1+(x/B)^A))',...
           %'D-((D-C)/(1+(x/B)^A))',...
           %'A + B*x + C*(x^2) + D*(x^3)',...
           %'x^A',...
            %'(A * x ) / (A - x + 1)', ...
            %'x^((A + 0.5)^-2)',...

option.ModelNames = {'RFM1' 'RFM2' 'RFM3'};

option.ModelFixedParams = struct;

option.Model_coefficients = {'b', 's', 'c', 'd'};
option.model = 2;
option.type = 'raw';

% skips first and last observed proportions when plotting in logitDeltaPlot
option.skipObservedOnPlot = 2;

option.aberrantQuantile = 0.7;

% Options for EM algorith
option.EM.startingPoint = [0.5 1 0.2];
option.EM.NofLatentsCategories = 30;
option.EM.NofIterations = 30;
option.EM.OptimisationOptions  = optimset('Display','on');
option.EM.AlgorithmStored = [];
option.EM.priorDistribution.b = [0.5,0.16];
option.EM.priorDistribution.s = [1.2,2];
option.EM.priorDistribution.c = [6,18];
option.EM.MaxParTol = 0.001;

% Optimization options
option.StartingPoint = [0.5, 1, 0.1];
option.Lower         = [0.01, 0.2, 0];
option.Upper         = [0.99, 5, 0.5];
option.RFM_params_method = 'constrained'; % 'fminserch/fmincon'

if nargin > 0
	if mod(nargin,2) ~= 0
	 error('Wrong number og input arguments');
    end

	for k = 1:2:nargin
		option.(varargin{k}) = varargin{k+1};
    end
end
