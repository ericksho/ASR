function X = intensities(I,options)
[N,M] = size(I);
nn = fix(N/options.vdiv);
mm = fix(M/options.hdiv);

X = zeros(options.vdiv*options.hdiv.*nn*mm,1);
for p=1:options.vdiv
    for q=1:options.hdiv
        x = I(indices(p,nn),indices(q,mm));
        X(indices((p-1)*options.vdiv+q,nn*mm),1) = x(:)/norm(x(:));
    end
end

end