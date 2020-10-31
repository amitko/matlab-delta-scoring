function [vals,groups] = latentGroups(score,intervals)

groups = 1:size(intervals,1);
vals = zeros(size(score));
for k = groups(1:end-1)
   vals(score > intervals(k) & score <= intervals(k+1)) = k;
end
groups = groups(1:end-1)


