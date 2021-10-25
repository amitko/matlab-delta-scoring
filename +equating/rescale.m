function res = rescale(deltas,A,B)
% res = rescale(deltas,A,B)
% Rescales the item deltas of a test according
% to rescaling constants A and B.

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

Z_x = (1/1.702).*log(deltas ./ (1 - deltas));
Z_xx = A .* Z_x + B;

res = (1 ./ (1 + exp( -1.702 * Z_xx)));