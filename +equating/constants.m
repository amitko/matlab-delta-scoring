function [A,B]=constants(Base_test_deltas,New_test_deltas,common_items)
% [A,B] = constants(Base_test_deltas,New_test_deltas,common_items)
%              Y        X
% Calculates the rescaling constants, based on common items
% between two test.
%
% INPUT:
%	Base_test_deltas - item deltas of the base test
%	New_test_deltas  - item deltas of the new test
%   common_items     - two columns
%				[base_test_item_id  new_test_item_id]
%
% OUTPUT:
%		A and B

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net


% Calculate Z-score wore the two tests
Z_base = (1/1.702).*log(Base_test_deltas ./ (1 - Base_test_deltas));
Z_new = (1/1.702).*log(New_test_deltas ./ (1 - New_test_deltas));
Z_bc = Z_base(common_items(:,1));
Z_nc = Z_new(common_items(:,2));

% Calculate transformation constants
A = std(Z_bc)/std(Z_nc);
B = mean(Z_bc) - A*mean(Z_nc);
