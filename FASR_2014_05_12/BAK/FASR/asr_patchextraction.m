% FASR: Face Recognition by Adaptive Sparse Representations
% =========================================================
%
% asr_patchextraction.m : Patch Extraction
%
% (c) Domingo Mery - PUC (2013), ND (2014)


function     [z,x] = asr_patchextraction(f,options)

ix   = options.ix;
m    = options.m;
a    = options.a;
b    = options.b;
show = options.show;

if show>0
    disp('asr: extracting patches...')
end

if ~isfield(options,'distortion') % border not considered
    distortion = 0;
else
    distortion    = options.distortion;
end

if ~isfield(options,'blur') % blurring
    blur = 0;
else
    blur    = options.blur;
end

if ~isfield(options,'occ') % border not considered
    occ = 0;
else
    occ    = options.occ;
end

if ~isfield(options,'border') % border not considered
    border = 0;
else
    border    = options.border;
end


if ~isfield(options,'triggs') % tan-triggs normalization
    triggs = 0;
else
    triggs    = options.triggs;
end


if ~isfield(options,'saliency') % saliencies
    saliency = 0;
else
    saliency   = options.saliency;
end



N = length(ix);
I = asr_imgload(f,1);
[h,w] = size(I);

U = asr_LUTpatches(h,w,a,b);

if show>1
    ff = Bio_statusbar('Extracting peatures');
    if show>2
        fig2 = figure(2);
    end
end
%switch options.feat
%    case 'gray'
%        ww = a*b;
%    case 'lbp'
%        ww = 59;
%end


z = zeros(N*m,options.ez);
x = zeros(N*m,2);
for i=1:N
    ip = indices(i,m);
    I = asr_imgload(f,ix(i));
    
    if blur~=0
        I = asr_blur(I,blur);
    end
    if triggs==1
        I = tantriggs(I);
    end
    %if colnorm == 1
    % I = (Bft_uninorm(I'))';
    % I = I/max2(I)*255;
    %end
    if distortion~=0
        I = asr_distortion(I,distortion);
    end
    if occ>0
        x1 = randi(size(I,1)-occ,1);
        y1 = randi(size(I,2)-occ,1);
        I(x1:x1+occ-1,y1:y1+occ-1) = 0;
    end
    if show>1
        ff = Bio_statusbar(i/N,ff);
        if show>2
            imshow(I,[]);drawnow
        end
    end
    if std2(I)<1e-12
        fprintf('check image %d in directory %s\n',i,f.path)
        error('Image not found...')
    end
    
    switch saliency
        case 0
            ii        = border+randi(h-a+1-2*border,m,1);
            jj        = border+randi(w-b+1-2*border,m,1);
        case 1
            [~,J_off] = Bim_cssalient(I,1,0);
            R_off     = J_off>0;
            mm = 10*m;
            ii        = border+randi(h-a+1-2*border,mm,1);
            jj        = border+randi(w-b+1-2*border,mm,1);
            [ii,jj]   = andR(ii+round(border+a/2),jj+round(border+b/2),R_off);
            im        = randi(length(ii),m,1);
            ii        = ii(im)-round(border+a/2);
            jj        = jj(im)-round(border+b/2);
        case 2
            % J_off = edge(I,'sobel');
            J_off     = edge(I,'canny',0.1,1);
            R_off     = imdilate(J_off,ones(7,7));
            mm        = 10*m;
            ii        = border+randi(h-a+1-2*border,mm,1);
            jj        = border+randi(w-b+1-2*border,mm,1);
            [ii,jj]   = andR(ii+round(border+a/2),jj+round(border+b/2),R_off);
            im        = randi(length(ii),m,1);
            ii        = ii(im)-round(border+a/2);
            jj        = jj(im)-round(border+b/2);
    end
    
    z(ip,:)           = asr_readpatches(I,ii,jj,U,options);
    x(ip,:)         = [ii jj];
    
    
end
x = x+ones(N*m,1)/2*[a b];
%x(:,1) = x(:,1)/h;
%x(:,2) = x(:,2)/w;
if show>1
    delete(ff)
    if show>2
        close(fig2);
    end
end
if options.uninorm == 1 % normalization
    z         = Bft_uninorm(z);
    x         = [x(:,1)/options.heigh x(:,2)/options.width];
end