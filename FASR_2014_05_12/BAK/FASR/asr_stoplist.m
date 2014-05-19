% From Spyrou et al 2010:
% "... most of the cmmon visual words, i.e., those with smallest iDF values,
% are not descriminative and their abscence would facilitate the retrieval
% process. On the other hand, the rarest visual words are in most of the
% cases as result of noise and may distract the retrieval process. To
% overcome those problems, a stop list is created that includes the most
% and the least frequent visual words of the image collection."
%
% From Sivic & Zisserman (2003):
% "Using a stop list the most frequent visual words that occur in almost all
% images are supressed. The top 5% (of the frequency of visual words over 
% all the keyframes) and bottom 10% are stopped."

function options = asr_stoplist(Y,options)

k    = options.k;      % number of subjects
n    = options.n;      % number of images per subject
m    = options.m;      % number of patches per image 
docu = options.docu;   % one document = one subject (1), or one image (2)

if docu == 1
    N = k;             % number of documents
    M = m*(n-1);       % number of patches per document
else
    N = k*(n-1);       % number of documents
    M = m;             % number of patches per document
end
options.ixn            = Bds_labels(M*ones(N,1));

[Voc,ix,i_stop,i_go,...
    kd,kd_go]          = Bsq_stoplist(Y,options);

options.voc            = Voc;
options.ix_voc         = ix;
options.i_stop         = i_stop;
options.i_go           = i_go;
options.kd_voc         = kd;
options.kd_go          = kd_go;

    