% Read the original and watermarked images
original_image1 = imread('right.jpg');
original_image2 = imread('left.jpg');

watermarked_image = imread('watermarked_image.png');

watermarked_image_cropped1 = watermarked_image(1:size(original_image1, 1), 1:size(original_image1, 2));
watermarked_image_cropped2 = watermarked_image(1:size(original_image2, 1), 1:size(original_image2, 2));

watermarked_image_resized1 = imresize(watermarked_image_cropped1, size(original_image1(:, :, 1)));
watermarked_image_resized2 = imresize(watermarked_image_cropped2, size(original_image2(:, :, 1)));

% Calculate MSE
%mse1 = immse(original_image1, watermarked_image_resized1);
%mse2 = immse(original_image2, watermarked_image_resized2);

% Calculate MSE
mse1 = immse(original_image1(:, :, 1), watermarked_image_resized1);
mse2 = immse(original_image2(:, :, 1), watermarked_image_resized2);

% Calculate PSNR
max_pixel_value = 255; % for grayscale images
psnr_value1 = 10 * log10((max_pixel_value ^ 2) / mse1);
psnr_value2 = 10 * log10((max_pixel_value ^ 2) / mse2);
disp(['PSNR of image 1: ', num2str(psnr_value1)]);
disp(['PSNR of image 2: ', num2str(psnr_value2)]);

% Read the original and extracted watermark images
extracted_watermark1 = imread('extracted_watermark_1.png');
extracted_watermark2 = imread('extracted_watermark_2.png');

%disp(size(extracted_watermark1));
%disp(class(extracted_watermark1));

%disp(size(extracted_watermark2));
%disp(class(extracted_watermark2));

% Convert images to binary
original_binary1 = imbinarize(im2gray(original_image1));
original_binary2 = imbinarize(im2gray(original_image2));
extracted_binary1 = imbinarize(extracted_watermark1);
extracted_binary2 = imbinarize(extracted_watermark2);

% Calculate BER
extracted_binary1_resized = imresize(extracted_binary1, size(original_binary1));
extracted_binary2_resized = imresize(extracted_binary2, size(original_binary2));
ber1 = biterr(original_binary1, extracted_binary1_resized) / numel(original_binary1);
ber2 = biterr(original_binary2, extracted_binary2_resized) / numel(original_binary2);
disp(['BER of image 1: ', num2str(ber1)]);
disp(['BER of image 2: ', num2str(ber2)]);

% Convert images to grayscale
original_gray1 = im2gray(original_image1);
original_gray2 = im2gray(original_image2);
extracted_gray1 = im2gray(extracted_watermark1);
extracted_gray2 = im2gray(extracted_watermark2);

% Calculate NC
nc1 = normxcorr2(original_gray1, extracted_gray1);
nc2 = normxcorr2(original_gray2, extracted_gray2);
disp(['NC of image 1: ', num2str(max(nc1(:)))]);
disp(['NC of image 2: ', num2str(max(nc2(:)))]);
