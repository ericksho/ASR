%
% LBP Face Recognition
%
% Face Recognition by Adaptive Sparse Representations
% (c) Domingo Mery - PUC, 2013


function p = int_main(stbase,options)


%%%%%%%%%%%%%%%%%%
% 1. DEFINITIONS
%%%%%%%%%%%%%%%%%%

opdef          = asr_defoptions();                   % default options
op             = asr_mergeoptions(options,opdef);    % merging user option with default options

% images
[f,op]         = asr_setimages(stbase,op);           % 'orl','yale','cas','rr','ar','lfwf', etc

op.k           = min([op.k f.imgmax]);              % number of classes <= number of images

% labels
dall           = Bds_labels(op.n*ones(op.k,1));     % labels of all images (k subjects with n images per subject)

if ~isempty(op.imgtrain)
    itrain = (1:op.n*op.k)';
    itest = op.n:op.n:op.n*op.k;
    itrain(itest) = [];
else
    [itrain,itest] = Bds_ixstratify(dall,(op.n-1)/op.n);% indices for learning and for testing (1-1/n training, 1/n testing)
end

op.itest       = itest;
op.ntest       = length(itest);
op.dtest       = dall(itest);                       % labels of testing data


op.ix          = itrain;
op.uninorm     = 1;


%%%%%%%%%%%%%%%%%%%
% IMAGE ACQUISITION
%%%%%%%%%%%%%%%%%%%

f              = asr_imgselection(f,op);                   % selected images after shaprness evaluation (if any)
f              = asr_showimages(f,op);               % display all images and show in yellow the test images

%%%%%%%%%%%%%%%%%%%
% DESCRIPTION
%%%%%%%%%%%%%%%%%%%

opint.vdiv        = 6;           % one vertical divition
opint.hdiv        = 6;           % one horizontal   divition



I           = asr_imgload(f,1);
[N,M] = size(I);

nn = fix(N/opint.vdiv);
mm = fix(M/opint.hdiv);

M = opint.vdiv*opint.hdiv.*nn*mm;


D = nn*mm;


% extracting for training
ntrain = length(itrain);
Xtrain = zeros(ntrain,M);
if op.show>1
    ft = Bio_statusbar('extracting');
end
for i=1:ntrain
    if op.show>1
        ft          = Bio_statusbar(i/N,ft);
    end
    I           = asr_imgload(f,itrain(i));
    if op.triggs == 1
        I = tantriggs(I);
    end
    
    % [X,Xn]      = Bfx_lbp(I,[],opint);
    Xtrain(i,:) = intensities(I,opint);
end

% extracting for testing
ntest = length(itest);
Xtest = zeros(ntest,M);

for i=1:length(itest)
    if op.show>1
        ft          = Bio_statusbar((i+ntrain)/N,ft);
    end
    I           = asr_imgload(f,itest(i));
    if op.triggs == 1
        I = tantriggs(I);
    end
    if op.distortion~=0
        I           = asr_distortion(I,op.distortion);
    end
    
    if op.occlusion>0
        x1 = randi(size(I,1)-op.occlusion,1);
        y1 = randi(size(I,2)-op.occlusion,1);
        I(x1:x1+op.occlusion-1,y1:y1+op.occlusion-1) = 0;
    end
    if op.show>2
        figure(2)
        imshow(I,[])
    end
    % [X,Xn]      = Bfx_lbp(I,[],opint);
    
    Xtest(i,:)  = intensities(I,opint);
end
if op.show>1
    delete(ft)
end

options.D = D;
options.show = 0;


dtrain = dall(itrain);
dtest  = dall(itest);


ds = Bcl_nbnnxi(Xtrain,dtrain,Xtest,options);


p              = Bev_performance(dtest,ds);
st = ['int   performance = ' num2str(round(p*100)) '%'];
disp(st)

if op.show>2
    
    for i_t = 1:ntest
        ixy = f.sxy(i_t,:);
        if ds(i_t) == dtest(i_t);
            scol = 'g';
        else
            scol = 'r';
        end
        figure(1)
        plot(ixy([1 2 2 1 1]),ixy([3 3 4 4 3]),scol)
        
    end
    
    figure(3)
    
    bar(p*100)
    axis([0 2 0 110])
    title(st)
    
end
