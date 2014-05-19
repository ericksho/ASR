% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_main.m : Main Program
%
% acc    : accuracy
% t      : testing time per face in seconds
% stbase : name of the database
% options: experiment options
%
% (c) Domingo Mery - PUC (2013), ND (2014)


function [acc,t] = asr_main(stbase,options)



% input

%%%%%%%%%%%%%%%%%%
% 1. DEFINITIONS
%%%%%%%%%%%%%%%%%%

% general
clb; warning('off','all')
opdef          = asr_defoptions();                   % default options
op             = asr_mergeoptions(options,opdef);    % merging user option with default options

% images
[f,op]         = asr_setimages(stbase,op);           % 'orl','yale','cas','rr','ar','lfwf', etc


op.k           = min([op.k f.imgmax]);               % number of classes <= number of images
op.heigh       = f.h;
op.width       = f.w;

switch op.feat
    case 'gray'
        op.a   = op.w;                               % patch's heigh
        op.b   = op.w;                               % patch's width
        op.ez  = op.a*op.b/(op.patchsub)^2;          % number of pixels
    case 'lbp'
        op.a   = op.w;                               % patch's heigh
        op.b   = op.w;                               % patch's width
        op.ez  = 59;                                 % descriptor's size
end
op.ez0         = 1;                                  % 1 includes descriptor and location, ez+1 includes location only


% labels
op.dD          = Bds_labels(op.R*ones(op.k,1));

dall           = Bds_labels(op.n*ones(op.k,1));      % labels of all images (k subjects with n images per subject)

itrain         = (1:op.n*op.k)';
itest          = op.n:op.n:op.n*op.k;
itrain(itest)  = [];

op.itest       = itest;
op.ntest       = length(itest);
op.dtest       = dall(itest);                        % labels of testing data
op.ix          = itrain;
op.uninorm     = 1;
dtrain         = Bds_labels(op.m*op.n*ones(op.k,1)); % ideal class, k subjects, nxm patches per person
ii             = asr_itfull(itest,op.m);
dtrain(ii,:)   = [];
op.dtrain      = dtrain;


%%%%%%%%%%%%%%%%%%%
% IMAGE ACQUISITION
%%%%%%%%%%%%%%%%%%%
f              = asr_imgselection(f,op);             % selected images after shaprness evaluation (if any)
f              = asr_showimages(f,op);               % display all images and show in yellow the test images

%%%%%%%%%%%%%%%%%%%
% DESCRIPTION
%%%%%%%%%%%%%%%%%%%
if op.blurdic == 1
    [z1,x1]          = asr_patchextraction(f,op);          % z = f(intensity), x = (x,y) location
    op.blur        = 1.5;
    [z2,x2]          = asr_patchextraction(f,op);          % z = f(intensity), x = (x,y) location
    op.blur        = 3;
    [z3,x3]          = asr_patchextraction(f,op);          % z = f(intensity), x = (x,y) location
    op.blur        = 4.5;
    [z4,x4]          = asr_patchextraction(f,op);          % z = f(intensity), x = (x,y) location
    z = [z1;z2;z3;z4];
    x = [x1;x2;x3;x4];
    op.dtrain = [op.dtrain; op.dtrain; op.dtrain; op.dtrain];
    dtrain = op.dtrain;
else
    [z,x]          = asr_patchextraction(f,op);          % z = f(intensity), x = (x,y) location
end
p              = asr_descriptor(z,x,op);             % building of descriptor p = g(z,x)

if op.stoplist == 1
    op         = asr_visualvoc(p,op);                % create a visual vocabulary, stop list & tfidf
end

%%%%%%%%%%%%%%%%%%%
% MODELLING
%%%%%%%%%%%%%%%%%%%
[YP,YC]        = asr_modell(p,dtrain,op);            % (YP,YC): Parent and Children clusters

%%%%%%%%%%%%%%%%
% TESTING
%%%%%%%%%%%%%%%%
op.m           = op.m2;
tic

% extracting patches for testing
op.ix          = itest;
%op.occlusion   = options.occlusion;
%op.distortion  = options.distortion;
%op.blur        = options.blur;
[zt,xt]        = asr_patchextraction(f,op);
pt             = asr_descriptor(zt,xt,op);

if op.stoplist == 1
    [~,op.itf]  = asr_stopout(pt,op);
else
    op.itf     = true(size(pt.z,1),1);
end

% computing distances to clusters
[D,S,IX,YC,Ytest] = asr_dist(pt,YP,YC,op);

% classification
op.IX          = IX;
op.tfidf       = 0;
[ds,vt]        = asr_testing(f,Ytest,YC,D,S,op);

% performance evaluation
t = toc/op.ntest;

acc              = asr_eval(f,ds,itest,dall,vt,op);
fprintf('asr:   testing time = %7.4f sec/face\n',t);
if op.show > 0
    st = ['asr:    performance = ' num2str(round(acc(1)*100)) '%'];
    disp(st)
    if op.show>2
       title(st)
    end
end

