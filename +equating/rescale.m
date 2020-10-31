function res = rescale(deltas,A,B)

Z_x = (1/1.702).*log(deltas ./ (1 - deltas));
Z_xx = A .* Z_x + B;

res = (1 ./ (1 + exp( -1.702 * Z_xx)));