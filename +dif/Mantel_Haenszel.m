function [a_MH,log_a_MH_SE,da_MH,z,p,MH,type,against]=Mantel_Haenszel(response,score,groups,reference)

group_values = unique(reference);
response_values = unique(response);

if size(group_values,2) > 2
    error('More than two groups');
end

if size(response_values,2) > 2
    error('Response should be dichotomous');
end

A   = [];
B   = [];
C   = [];
D   = [];

for j=1:size(groups,1)
    I = score == groups(j);
    A(j)   = sum(response(I) == 1 & reference(I) == group_values(2) )  + 0.25;
    B(j)   = sum(response(I) == 0 & reference(I) == group_values(2)) + 0.25;
    C(j)   = sum(response(I) == 1 & reference(I) == group_values(1)) + 0.25;
    D(j)   = sum(response(I) == 0 & reference(I) == group_values(1)) + 0.25;   
end

%A(A == 0) = 0.25;
%B(B == 0) = 0.25;
%C(C == 0) = 0.25;
%D(D == 0) = 0.25;

N   =  A + B + C + D;
N_r = A + B;
N_f = C + D;
N_1 = A + C;
N_0 = B + D;

EA = (N_r .* N_1) ./ N;
VA = (N_r .* N_f .* N_1 .* N_0) ./ (N.^2 .* (N - 1 + 0.1));

R = (A .* D) ./ N;
S = (C .* B) ./ N;

Rs = sum(R);
Ss = sum(S);

P = (A+D) ./ N;
Q = (C+B) ./ N;

MH    = ( (abs(sum(A) - sum(EA)) - 0.5 ).^2 ) ./ sum(VA);
a_MH  = Rs ./  Ss;
da_MH = -2.35 * log(a_MH);

%V = 1./A + 1./B + 1./C + 1./D;
%varLog_a = sum( S .* V) / Rs; 

varLog_a = ((sum(P.*R))/(Rs^2) + (sum(P.*S + Q .* R))/(Rs*Ss) +  (sum(Q.*S))/(Ss^2)) / 2;
log_a_MH_SE = sqrt(varLog_a);
z = -log(a_MH)./log_a_MH_SE;

p = cdf('norm',abs(z),0,1,'upper')*2;

if abs(da_MH) < 1
    type = 0;
elseif abs(da_MH) <= 1.5
    type = 1;
else
    type = 2;
end

against = 0;
if type > 0
    if da_MH < 0
        against = 2;
    else
        against = 1;
    end
end