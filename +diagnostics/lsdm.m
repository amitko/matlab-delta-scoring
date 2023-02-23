function res = lsdm(item_performance,Q,type)
% Function lsdm(item_performance,Q,type)
%   Returns Generalized Least Distance Method estimate
%   for ability performance.
%
%   Inout:
%   item_performance - n by m matrix of probabilities p(j,k)
%                       for correct answer  on item j from 
%                       person with ability group k.%       
%   Q                - matrix of indicators that item j 
%                       requires attribute k  ( Q(j,k) = 1 ).
%   type             - Type of model: 
%               1 - {X=1} = \cap A_i
%               2 - {X=1} = \cup A_i
%               3 - {X=1} = \cup \bar A_i
%               4 - {X=1} = \cap \bar A_i

% Dimitar Atanasov (2008)
% datanasov@nbu.bg

if nargin == 2
    type = 1;
end

if type == 1
    a = 0;
    b = 0;
elseif type == 2
    a = 1;
    b = 1;
elseif type == 3
    a = 1;
    b = 0;
elseif type == 4
    a = 0;
    b = 1;
else
    error('Unsupported model');
end
    
Res = [];
for k = item_performance
     kt = ones( size(k) ) - k;
     eps = 0.0001;
     kt( kt < eps )  =  eps;
     k( k < eps ) = eps;
     T =  - lsqnonneg (Q, - ( ( log(k) .* ( 1 - b ) ) + ( log( kt ) .* b ) ));     
     Res = [Res T];
end

res = exp(Res') .* (1 - a) + ( ones( size(Res') ) - exp(Res')) .* a;

