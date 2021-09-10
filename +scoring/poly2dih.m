function [DIHscores,Poly,Org] = poly2dih(Response)
% [DIHscores,Poly,Org] = poly2dih(Response)
% Convert polytomous to dihotomous item respone
%
% INPUT:
%	Response - polytomous item response
%
% OUTPUT:
%	DIHscores - dihotomous ite response
%	Poly      - indicator for polytomous items
%	Org       - Labels, etc. for poly items


% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

DIHscores = [];
Poly.Items = {};
Poly.Labels = {};
Org.Labels = {};
Org.isPoly = [];

c = 1;
for k=1:size(Response,2)
    if isequal(unique(Response(:,k)), [0;1])
        DIHscores = [DIHscores, Response(:,k)];
        Poly.Labels = [Poly.Labels; [ num2str(c) '-Q' num2str(k)]];
        p.is = 0;
        p.items = [];
        Poly.Items = [Poly.Items; p];
        Org.Labels = [Org.Labels; ['Q' num2str(k)]];
        Org.isPoly(k) = 0;
        c = c+1;
    else
        levels = unique(Response(:,k));
        pp = [];
        for l = levels(2:end)'
            Correct = Response(:,k) >= l;
            DIHscores = [DIHscores, Correct];
            Poly.Labels = [ Poly.Labels; [ num2str(c) '-Q' num2str(k) '[' num2str(l) ']']];
            pp = [pp size(DIHscores,2)];
            c = c+1;
        end
        Org.Labels = [Org.Labels; ['+Q' num2str(k)]];
        Org.isPoly(k) = 1;
        p.is = 1;
        p.items = pp;
        Poly.Items = [Poly.Items; p];
    end
end
