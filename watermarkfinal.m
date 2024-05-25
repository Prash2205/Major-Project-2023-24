
clc
close all
% embedding strength
alpha = 0.09;
beta = 0.09;
%input image
Input_image_1 = imread('eye.png');
dim=1024;
Input_image=preprossesing(Input_image_1,dim);

%3 level dwt
[LL1,HL1,LH1,HH1] = dwt2(Input_image,'haar');
[LL2,HL2,LH2,HH2] = dwt2(LL1,'haar');
[LL3,HL3,LH3,HH3] = dwt2(LL2,'haar');
p = size(LL3);

%applying SVD on HL3&LH3
[Uy,Sy,Vy] = svd(HL3);
[Uy1,Sy1,Vy1] = svd(LH3);
q = size(Sy);

%watermark images
watermark_image1 = imread('right.jpg');
watermark_image_1p=preprossesing(watermark_image1,p(1,1));
watermark_image2 = imread('left.jpg');
watermark_image_2p=preprossesing(watermark_image2 ,p(1,1));

%applying SVD on watermark
[Uw,Sw,Vw] = svd(double(watermark_image_1p));
[Uw1,Sw1,Vw1] = svd(double(watermark_image_2p));

%embed watermark
Smark = Sy + alpha*Sw;
Smark1 = Sy1 + beta*Sw1;

%Rebuild the sub-bands using SVD
HL3_1 = Uy*Smark*Vy';
LH3_1 = Uy1*Smark1*Vy1';

%Apply inverse dwt to get watermarked image
LL2_1 = idwt2(LL3,HL3_1,LH3_1,HH3,'haar','db2');
LL1_1 = idwt2(LL2_1,HL2,LH2,HH2,'haar','db2');
I = idwt2(LL1_1,HL1,LH1,HH1,'haar','db2');
I_1=im2uint8(I);
imwrite(I_1, 'watermarked_image.png', 'png');
%enc
%enc=encrypt();
%decr
%decr=decrypt();
%EXTRACTION


