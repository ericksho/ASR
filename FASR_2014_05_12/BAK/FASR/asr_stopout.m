% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_stopout.m : Elimination of stop words
%
% (c) Domingo Mery - PUC (2013), ND (2014)

function [Yfilt,ifilt] = asr_stopout(p,options)

if options.vocloc == 0
    Y = p.z;
else
    Y = p.d;
end
[Yfilt,ifilt] = Bsq_stopout(Y,options);