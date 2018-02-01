%---------------------------------------------------------
% Read image and blur it with a 3x3 or 5x5 Gaussian filter
%---------------------------------------------------------

ImgPath = 'a.bmp';
I= imread(ImgPath);
img(:,:,1)=I;
img(:,:,2)=I;
img(:,:,3)=I;
gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

%---------------------------------------------------------
% Perform sRGB to CIE Lab color space conversion (using D65)
%---------------------------------------------------------

cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'));
lab = applycform(gfrgb,cform);

%---------------------------------------------------------
% Compute Lab average values (note that in the paper this
% average is found from the unblurred original image, but
% the results are quite similar)
%---------------------------------------------------------

l = double(lab(:,:,1)); lm = sum(sum(l))/1024000;
a = double(lab(:,:,2)); am = sum(sum(a))/1024000;
b = double(lab(:,:,3)); bm = sum(sum(b))/1024000;

%---------------------------------------------------------
% Finally compute the saliency map and display it.
%---------------------------------------------------------

sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
sm = mat2gray(sm);

figure, imshow(sm);
se = strel('square', 5);
eg = edge(sm, 'canny', graythresh(sm));
bw = imdilate(eg, se);
bw = imfill(bw, 'holes');

figure, imshow(eg);
figure, imshow(bw);

%--------------------------------------------------------