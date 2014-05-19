%
% TPTSR Face Recognition
%
% Face Recognition by Adaptive Sparse Representations
% (c) Domingo Mery - PUC, 2013

function p = tpt_main(stbase,options)


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



%%%%%%%%%%%%%%%%%%%
% IMAGE ACQUISITION
%%%%%%%%%%%%%%%%%%%

f              = asr_imgselection(f,op);                   % selected images after shaprness evaluation (if any)
f              = asr_showimages(f,op);               % display all images and show in yellow the test images

%%%%%%%%%%%%%%%%%%%
% DESCRIPTION
%%%%%%%%%%%%%%%%%%%


N = op.k*op.n;

% h = 22*2;
% v = 18*2;

h = 110;
v = 90;

% extracting for training
ntrain = length(itrain);
Xtrain = zeros(ntrain,h*v);
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
    I           = imresize(I,[h v]);
    Xtrain(i,:) = I(:)';
end

% extracting for testing
ntest = length(itest);
Xtest = zeros(ntest,h*v);
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
    I          = imresize(I,[h v]);
    Xtest(i,:) = I(:)';
end
if op.show>1
    delete(ft)
end


dtrain = dall(itrain);
dtest  = dall(itest);



%Xtrain = Bft_uninorm(Xtrain);
%Xtest  = Bft_uninorm(Xtest);

Ytrain = Xtrain';
Ytest  = Xtest';



ds = zeros(ntest,1);


n = size(Ytrain,2);

% I = eye(n);

%Abase = inv(Ytrain'*Ytrain+0.0001*I)*Ytrain';
Abase = (Ytrain'*Ytrain)\Ytrain';

if op.k==40
    M = 128;
else
    M = 64;
end

for i_t=1:ntest
    ytest = Ytest(:,i_t);
    e = zeros(n,1);
    A = Abase*ytest;
    for i=1:n
        e(i) = norm(ytest-A(i)*Ytrain(:,i));
    end
    [~,jj] = sort(e,'ascend');
    jjs = jj(1:M);
    Xs = Ytrain(:,jjs);
    Cs = dtrain(jjs);
    % Ib = eye(size(Xs,2));
    %B = inv(Xs'*Xs+0.0001*Ib)*Xs'*ytest;
    B = ((Xs'*Xs)\Xs')*ytest;
    
    D = Inf(op.k,1);
    for i=1:op.k
        ii = find(Cs==i);
        if ~isempty(ii)
            Xss = Xs(:,ii);
            Bss = B(ii);
            % Css = Cs(ii);
            yc = Xss*Bss;
            D(i) = norm(ytest-yc);
        end
    end
    [~,j] = min(D);
    ds(i_t) = j;
end

p              = Bev_performance(dtest,ds);

st = ['tptsr performance = ' num2str(round(p*100)) '%'];
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