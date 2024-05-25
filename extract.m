decrypted_image = imread('watermarked_image.png','png');

alpha = 0.09;
beta = 0.09;

% Wavelet Transform of Decrypted Image
[LL1_dec, HL1_dec, LH1_dec, HH1_dec] = dwt2(decrypted_image, 'haar');
[LL2_dec, HL2_dec, LH2_dec, HH2_dec] = dwt2(LL1_dec, 'haar');
[LL3_dec, HL3_dec, LH3_dec, HH3_dec] = dwt2(LL2_dec, 'haar');
p = size(LL3_dec);

% SVD Decomposition of Watermarked Image
[Uy_wmv, Sy_wmv, Vy_wmv] = svd(HL3_dec);
[Uy1_wmv, Sy1_wmv, Vy1_wmv] = svd(LH3_dec);
q = size(Sy_wmv);

% Calculate Watermark
Sw_rec = (Sy_wmv - Sy) / alpha;
Sw_rec1 = (Sy1_wmv - Sy1) / beta;
watermark_1 = Uw * Sw_rec * Vw';
watermark_2 = Uw1 * Sw_rec1 * Vw1';

% Inverse Wavelet Transform
watermark_image_1 = idwt2(LL3_dec, watermark_1, zeros(size(LH3_dec)), zeros(size(HH3_dec)), 'haar');
watermark_image_2 = idwt2(LL3_dec, zeros(size(HL3_dec)), watermark_2, zeros(size(HH3_dec)), 'haar');

% Display or Save Watermark Images
imshow(watermark_image_1, []);
imshow(watermark_image_2, []);

% Save Watermark Images
imwrite(watermark_image_1, 'extracted_watermark_1.png');
imwrite(watermark_image_2, 'extracted_watermark_2.png');
