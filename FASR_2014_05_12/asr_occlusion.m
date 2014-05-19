function I = asr_occlusion(I,occ)
x1 = randi(size(I,1)-occ,1);
y1 = randi(size(I,2)-occ,1);
I(x1:x1+occ-1,y1:y1+occ-1) = 0;
