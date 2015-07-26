function [data] = yearToPlottable(input)
s_input = sortrows(input,1);

data = zeros(12,1);
m = 1:12;
for i=1:12
    ind = find(s_input(:,1)==m(i));
    if(isempty(ind))
        continue;
    end
    data(i) = s_input(ind,3);
end