function [res] = mergeViewDown(vdata,ddata,N)

res = zeros(N,1);
res = [res, [1:N]'];

for i=1:N
   Iv = find(vdata(:,2)==i);
   Id = find(ddata(:,2)==i);
   if(isempty(Iv) && isempty(Id)) % id hat weder view noch download getätigt
       continue;
   elseif(isempty(Iv))
       res(i,1) = ddata(Id,1);
   elseif(isempty(Id))
       res(i,1) = vdata(Iv,1);
   else % keiner leer
       res(i,1) = ddata(Id,1)+vdata(Iv,1);
   end
end

end