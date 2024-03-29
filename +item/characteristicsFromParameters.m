function res = characteristicsFromParameters(item_params,o)
% res = characteristicsFromParameters(item_params,o)
% Calculates the item characteristics from item parameters
%
% INPUT: 
%	item_params - item parameters
%	o           - options
%
% OUTPUT
%	res - [location, discrimination]	

% Dimitar Atanasov, 2017
% datanasov@ir-statistics.net

if o.model == 1
    
    b = item_params(:,1);
    s = ones(size(item_params,1),1);
    a = s ./( (1 - b) .* b .* 4);

elseif o.model == 2
    
    b = item_params(:,1);
    s = item_params(:,2);
    a = s ./( (1 - b) .* b .* 4);

elseif o.model == 3
    b = item_params(:,1);
    s = item_params(:,2);
    a = (( 1 - item_params(:,3)) .* s) ./( (1 - b) .* b .* 4);   
else
    error('Unsupported model!!!');
end

  a(a > 10) = 10;
  
  res = [b, a];   