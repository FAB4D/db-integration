function [data] = yearsToPlottable(input)
s_om_view_years = sortrows(input,2);
data = [];
y = 2008:2012;
m = 1:12;
for i=1:5
    I = find(s_om_view_years(:,2)==y(i));
    om_view_per_y = s_om_view_years(I,:);
    om_view_per_y = sortrows(om_view_per_y,1);
    full_om_view_per_y = zeros(1,12);
    for k=1:12
        ind = find(om_view_per_y(:,1)==m(k));
        if (isempty(ind))
            continue;
        end
        full_om_view_per_y(k) = om_view_per_y(ind,3);
    end
    data = [data; full_om_view_per_y]; % row corresponds to year, col to month
end

end