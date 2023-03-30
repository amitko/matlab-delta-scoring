function res = lsdmAttributeMAD(item_performance, attribute_performance, Q, model)
% Function irt_attribute_mad(item_performance, attribute_performance, Q, model)
%   Calculates Mean Absolute Difference (MAD) between 
%   true item performance and its attribute recovery.
%
% Input:
%   item_performance - n by m matrix of probabilities p(j,k)
%                       for correct answer  on item j from 
%                       person with ability group k.
%   attribute_performance - p by m matrix of probabilities P(j,k)
%                       for possesing attribute j from person with 
%                       ability group k.
%   Q                - matrix of indicators that item j 
%                       requires attribute k  ( Q(j,k) = 1 ).
%   model     - Type of model: 
%               1 - {X=1} = \cap A_i
%               2 - {X=1} = \cup A_i
%               3 - {X=1} = \cup \bar A_i
%               4 - {X=1} = \cap \bar A_i
%
%   Output:
%       Mean Absolute Difference (MAD) for the set of attributes.

% Dimitar Atanasov(2010)
% datanasov@nbu.bg

[n,m] = size(item_performance);
[nA,mA] = size(attribute_performance);
[nQ,mQ] = size(Q);

if nargin < 4
    model = 1;
end

if n ~= nQ || m ~= nA
    error('Dimension of item performance, attribute performance and Q should agree');    
end

if mA ~= mQ 
    error('Dimension of attribute performance and Q should agree');    
end

pe = deltaScoring.diagnostics.lsdmItemRecovery( attribute_performance, Q, model )';

err = abs( item_performance(:,2:end) - pe(:,2:end));
res = mean(err');

