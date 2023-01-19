function [res, row] = trsh4cd(cd_attributes,th)
% Function
%   [res, row] = trsh4cd(cd_attributes,th)

% Dimitar Atanasov, 2023
% datanasov@nbu.bg


if size(cd_attributes,1) ~= size(th,1)
    error('Dimension of the input parameters must agree');
end

res = [];
for k = 1:size(cd_attributes,1)-1
    for l = 1:size(cd_attributes,2)
        I = find(cd_attributes(k,:) < cd_attributes(k,l));
        I1 = find(cd_attributes(k+1,I) > cd_attributes(k+1,l));
        if ~isempty(I1)
            [a1,b1] = find_line_pars([th(k) cd_attributes(k,l)],[th(k+1), cd_attributes(k+1,l)]);
            [a2,b2] = find_line_pars([th(k) cd_attributes(k,I(I1))],[th(k+1), cd_attributes(k+1,I(I1))]);
            x = -(( b1 - b2 )./( a1 - a2 ));
            res(l,I(I1)) = x;
        end
    end
end

row = sort(res(find(res)));

function [a,b] = find_line_pars(p1,p2)
    a = (p1(2) - p2(2))./(p1(1) - p2(1));
    b = p1(2) - a.*p1(1);