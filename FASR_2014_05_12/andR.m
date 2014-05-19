% It filters out indices ii,jj that do not belong to binary region R

function [ii,jj] = andR(ii,jj,R)


[N,M] = size(R);
kk = (ii<1)|(jj<1)|(ii>N)|(jj>M);
ii(kk) = [];
jj(kk) = [];

kk    = sub2ind([N M],ii,jj);
T = zeros(N,M);
T(kk) = 1;
if ~isempty(kk)
    [ii,jj]    = find(and(T,R)==1);
end
