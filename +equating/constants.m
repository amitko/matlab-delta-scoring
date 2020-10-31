function [A,B]=constants(Base_test_deltas,New_test_deltas,common_items)

% constants(Base_test,New_test,common_items)
%              Y        X
% deltas

Z_base = (1/1.702).*log(Base_test_deltas ./ (1 - Base_test_deltas));
Z_new = (1/1.702).*log(New_test_deltas ./ (1 - New_test_deltas));
Z_bc = Z_base(common_items(:,1));
Z_nc = Z_new(common_items(:,2));

A = std(Z_bc)/std(Z_nc);
B = mean(Z_bc) - A*mean(Z_nc);
