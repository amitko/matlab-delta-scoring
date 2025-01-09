function res = test_function_values(x_,b_,s_,o)

syms x b s

m = str2sym(o.Models(o.model));

nf = matlabFunction(m,'Vars',[x,b,s]);

res = nf(x_,b_,s_);
