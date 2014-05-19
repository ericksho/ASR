% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_modsrc.m : Classification using Sparse Representation Classification
% Robust Face Recognition via Sparse Representation - Wright (PAMI 2007)
%
% (c) Domingo Mery - PUC (2013), ND (2014)
% (c) Erick Svec - PUC (2013)

function [ds,sci,s] = asr_modsrc(yt,D,options)

T      = options.T;      % sparcity
k      = options.k;      % number of classes 1, 2, ... c
% th     = options.scith;  % min accepted value for sci
dtrain = options.dD;     % columns of D for each class



if options.spams == 1               % it uses SPAMS library
    param.L          = T;           % not more than L non-zeros coefficients
    param.eps        = 0;           % optional, threshold on the squared l2-norm of the residual, 0 by default
    param.numThreads = -1;          % number of processors/cores to use; the default choice is -1 (it selects all the available CPUs/cores)
    xt               = full(mexOMP(yt',D,param))';
else                                % it uses OMP library (slower than SPAMS!)
    xt = full(omp(D'*yt',D'*D,T))'; % Sparsity-constrained Orthogonal Matching Pursuit
end

s1 = sum(abs(xt));
s  = zeros(k,1);
ek = zeros(k,1);

% nk = sum(options.ik);
for i=1:k
    if options.ik(i)==1
        ii = dtrain == i;
        s(i)  = sum(abs(xt(:,ii)));
        Rk    = (yt'-D(:,ii)*xt(:,ii)')';         % residual^2
        ek(i) = sum(Rk.*Rk,2);
    end
end
sci = (k*max(s)/s1-1)/(k-1);
%if (sci>=th)
    [~,j] = min(ek(options.ik));
    ds = j;
%else
%    ds = k+1;
%end

