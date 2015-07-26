function [res] = to3dCusData(data,startI,endI)
y = 2005:2012;
res = [];
for i=startI:endI
    I = find(data(:,2)==i); % gewisse ID's werden nicht gefunden
    if (isempty(I))
        continue; % gewisse ID's sind nicht vorhanden => auslassen
    end
    dataPerId = data(I,:);
    % produce a col per id
    [m,n] = size(dataPerId);
    if(m<8) % sind nicht alle Jahre vorhanden?
        colPerId = zeros(8,1);
        for k=1:8
            ind = find(dataPerId(:,3)==y(k));
            if isempty(ind)
                continue;
            else
                colPerId(k) = dataPerId(ind,1);
            end
        end
    else % alle Jahre kommen vor
        colPerId = dataPerId(:,1);
    end
    % do stuff with year
    res = [res;colPerId'];
end
end