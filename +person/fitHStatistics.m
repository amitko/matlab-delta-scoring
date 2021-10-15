function res = fitHStatistics(item_response)
% fitHStatistics(item_response)
% Calculates the H statistics for the
% dichotomous item response

% Dimitar Atanasov, 2021
% datanasov@ir-statistics.net

scores = sum(item_response')';

[N_persons, N_items] = size(item_response);

if N_persons >= 30000
    res = nan(N_persons,1);
    return;
end

tt = (item_response * item_response') ./  N_items;

t = scores ./  N_items;

    res = [];
for n = 1:N_persons
    tt_ = tt(n,:)';
    tt_(n) = 0;
    t_ = t;
    t_(n) = 0;

    nom = sum( tt_ - t(n) .* t_);

    mm = min(t(n).*(1 - t),t.*(1-t(n)));
    mm(n)= 0;
    denom = sum ( mm ) ;

    res(n,:) = nom/denom;
end


