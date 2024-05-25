% Load original watermark images
original_watermark_image1 = imread('right.jpg');
original_watermark_image2 = imread('left.jpg');

extracted_watermark = extractWatermarkFromDecryptedImage();

% Load extracted watermark images
extracted_watermark_image1 = imread('extracted_watermark_image1.png');
extracted_watermark_image2 = imread('extracted_watermark_image2.png');

% Calculate NC for each watermark
NC1 = sum(sum(original_watermark_image1 .* extracted_watermark_image1)) / sqrt(sum(sum(original_watermark_image1 .^ 2)) * sum(sum(extracted_watermark_image1 .^ 2)));
NC2 = sum(sum(original_watermark_image2 .* extracted_watermark_image2)) / sqrt(sum(sum(original_watermark_image2 .^ 2)) * sum(sum(extracted_watermark_image2 .^ 2)));

% Calculate BER for each watermark
% Assuming the watermark images are of the same size
BER1 = sum(sum(abs(original_watermark_image1 - extracted_watermark_image1))) / (size(original_watermark_image1, 1) * size(original_watermark_image1, 2));
BER2 = sum(sum(abs(original_watermark_image2 - extracted_watermark_image2))) / (size(original_watermark_image2, 1) * size(original_watermark_image2, 2));

% Calculate PSNR for each watermark
PSNR1 = psnr(original_watermark_image1, extracted_watermark_image1);
PSNR2 = psnr(original_watermark_image2, extracted_watermark_image2);

% Display the metrics
fprintf('Watermark 1 Metrics:\n');
fprintf('Normalized Correlation (NC): %.4f\n', NC1);
fprintf('Bit Error Rate (BER): %.4f\n', BER1);
fprintf('Peak Signal-to-Noise Ratio (PSNR): %.2f dB\n\n', PSNR1);

fprintf('Watermark 2 Metrics:\n');
fprintf('Normalized Correlation (NC): %.4f\n', NC2);
fprintf('Bit Error Rate (BER): %.4f\n', BER2);
fprintf('Peak Signal-to-Noise Ratio (PSNR): %.2f dB\n', PSNR2);
