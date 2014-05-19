% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_setimages.m : Definition of all images of the experiment
%
% (c) Domingo Mery - PUC (2013), ND (2014)


function [f,options] = asr_setimages(ix,options)

f.ix_database    = ix;
f.path           = [options.local_data '/faces_' ix '/'];
f.prefix         = 'face_';

options.imgtrain = [];
options.imgtest  = [];
options.sel      = 1;

ix0 = ix;

switch ix
    case 'rr'
        f.extension     = 'bmp';
        f.imgmax        = 114;
        f.resize        = [110 90];
        f.digits        = 2;
        options.smin    = 100;
        options.border  = 10;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
        options.smin    = 90;                                % threshold for sharpness selection
        
    case 'cas'
        f.extension     = 'tif';
        f.imgmax        = 66;
        f.resize        = 1.45;
        f.digits        = 2;
        f.window        = [ 40 149 30 119 ];
        options.smin    = 0;
        options.border  = 10;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'yale'
        f.extension     = 'png';
        f.imgmax        = 38;
        f.resize        = [110 90];
        f.digits        = 2;
        options.border  = 0;
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'orl'
        f.extension     = 'png';
        f.imgmax        = 40;
        f.resize        = [110 90];
        f.digits        = 2;
        options.border  = 10;
        options.smin    = 0;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
        
    case 'multiPIE'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 80;
        f.gray          = 1;
        f.resize        = [110 90];
        fc              = 1.3;
        f.resize        = round([110 90]*fc);
        x               = round(f.resize(1)/2)-55;
        y               = round(f.resize(2)/2)-45;
        f.window        = [ x x+109 y y+89 ];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'bxgrid_01'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 80;
        f.gray          = 1;
        f.resize        = [110 90];
        fc              = 1.1;
        f.resize        = round([110 90]*fc);
        x               = round(f.resize(1)/2)-55;
        y               = round(f.resize(2)/2)-45;
        f.window        = [ x x+109 y y+89 ];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'bxgrid_02'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 50;
        f.gray          = 1;
        f.resize        = [110 90];
        fc              = 1.1;
        f.resize        = round([110 90]*fc);
        x               = round(f.resize(1)/2)-55;
        y               = round(f.resize(2)/2)-45;
        f.window        = [ x x+109 y y+89 ];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
    case 'bxgrid_03'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 76;
        f.gray          = 1;
        f.resize        = [110 90];
        fc              = 1.1;
        f.resize        = round([110 90]*fc);
        x               = round(f.resize(1)/2)-55;
        y               = round(f.resize(2)/2)-45;
        f.window        = [ x x+109 y y+89 ];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
    case 'lfw'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 68;
        f.gray          = 1;
        f.resize        = [110 90];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
    case 'lfwf'
        f.path(end-1)     = [];
        f.extension     = 'bmp';
        f.imgmin        = 0;
        f.imgmax        = 157;
        f.gray          = 1;
        f.resize        = [110 90];
        fc              = 1.2;
        f.resize        = round([110 90]*fc);
        x               = round(f.resize(1)/2)-55;
        y               = round(f.resize(2)/2)-45;
        f.window        = [ x x+109 y y+89 ];
        %f.resize        = [110 90];
        f.digits        = 3;
        options.border  = 10; % 10
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'ar'
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 100;
        f.gray          = 1;
        f.resize        = [110 90];
        f.digits        = 2;
        options.border  = 05; % 10
        options.smin    = 0;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
    case 'ar+'
        ix0              = 'ar';
        f.path(end-1)     = [];
        f.extension     = 'png';
        f.imgmin        = 0;
        f.imgmax        = 100;
        f.gray          = 1;
        f.resize        = [110 90];
        f.digits        = 2;
        options.border  = 05; % 10
        options.smin    = 0;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
        options.imgtrain   = [1:7 14:20];  options.imgtest    = [8:13 21:26]; % for AR
        options.sel = 0;
    otherwise
        error('%s Database does not exist.',ix);
end
f.ti = 1;
f.tf = 1;
I         = asr_imgload(f,1);
[f.h,f.w] = size(I); % dimension of the images height x width

sf = ['data_' ix0 '.mat'];
if ~exist(sf,'file')
    disp('estimating number of images per class...')
    nimg = asr_nimg(f);
    save(sf,'nimg');
else
    x = load(sf);
    nimg = x.nimg;
end
options.nimg = nimg;
