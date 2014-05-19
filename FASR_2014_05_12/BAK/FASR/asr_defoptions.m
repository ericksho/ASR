% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_defoptions.m : Default options
%
% (c) Domingo Mery - PUC (2013), ND (2014)


function opdef = asr_defoptions()

opdef.dbase        = {'orl','yale','cas','rr','ar','ar+','lfwf','multiPIE','bxgrid_01','bxgrid_02','bxgrid_03'};
opdef.pbase        = {'asr_main','int_main','src_main','tpt_main','lbp_main'};
opdef.nd           = length(opdef.dbase);
opdef.local_data  = '/afs/crc.nd.edu/user/d/dmery/data/images/faces/';


opdef.show         = 0;       % display results: 0 Nathing, 1 Messages, 2 Bars, 3 Images
opdef.k            = 40;      % number of subjects
opdef.n            = 10;      % number of images per subject (training = n-1, testing = 1)
opdef.occlusion    = 0;       % side of the square that simulates an occlussion
opdef.distortion   = 0;       % distortion of the corners of the face image
opdef.blur         = 0;       % bluriness (see asr_blur.m)
opdef.nz           = 32;      % size of blocks when calculating sharpness
opdef.m            = 800;     % number of patches in each training image
opdef.m2           = 800;     % number of patches in each testing image
opdef.alpha        = 0.03;    % weight for coordinates in description
opdef.saliency     = 0;       % location of patches' extraction: 0 everywhere, 1 saliency map, 2 edges
opdef.Q            = 32;      % number of parent clusters
opdef.R            = 20;      % number of child clusters
opdef.s            = 300;     % number of selected test patches
opdef.patchsub     = 2;       % patch subsampling, if patch is 16x16, and patchsub = 2, only 64 pixels = 16x16/2^2 are considered
opdef.sub          = 1;       % subsampling for kd structures (see asr_modell and asr_distance)
opdef.desc         = 3;       % description's method (see asr_descriptor.m)
opdef.cosang       = 0.95;    % cos angle in scalar product by computing similarity
opdef.feat         = 'gray';  % 'gray','lbp' 
opdef.uninorm      = 1;       % 1: z=z/norm(z(:)) (for illumination invariant), 0: z=z
opdef.join         = 1;       % in testing 1/0 builds descriptor with/without location
opdef.modell       = 1;       % 1: ECCV2014, 2:New
opdef.stoplist     = 1;       % 1/0 includes / does not include stop list
opdef.tfidf        = 0;       % >0 build tfidf, and it indicates testing strategy
opdef.blurdic      = 0;       % 1/0 includes / does not include blurred images in the dictionary
opdef.w            = 16;      % pacth size (w*w) pixels
opdef.spams        = 1;       % sparse library: 0 KSVD, 1 SPAMS
opdef.dictionary   = 1;       % dictionary in modelling is computed using 1 kmeans, 0 ksvd.
opdef.Tdata        = 2;       % 2
opdef.dictsize     = 20;      % in sparse representarion of SRC number of coefficients ~= 0
opdef.father       = 0;       % testing patch is similar to 1 father, 0 child, 2 ruben
opdef.iternum      = 30;      %30
opdef.memusage     = 'high';  %'high'
opdef.T            = 20;      %20
opdef.scqth        = 0.1;     % threshold for selected patches by testing
opdef.top_bound    = 0.05;    % 5%   top    : most frequent word to be stopped
opdef.bottom_bound = 0.1;     % 10%  bottom : less frequent word to be stopped
opdef.NV           = 200;     % number of visual words of visual vocabulary
opdef.docu         = 2;       % one document = one subject (1), or one image (2)
opdef.stopth       = 0.9;     % words that are very different from dictionary are eliminates
opdef.vocloc       = 0;       % 1/0 vocabulary includes / doesn't include location

