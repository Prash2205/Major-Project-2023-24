function extracted_watermark = extractWatermarkFromDecryptedImage(~)
    % Load watermarked image
    watermarked_image = imread('decy.png');

    alpha = 0.30;
    beta = 0.21;

    % Perform DWT
    [LL1_wm, HL1_wm, LH1_wm, HH1_wm] = dwt2(watermarked_image, 'haar');
    [LL2_wm, HL2_wm, LH2_wm, HH2_wm] = dwt2(LL1_wm, 'haar');
    [LL3_wm, HL3_wm, LH3_wm, HH3_wm] = dwt2(LL2_wm, 'haar');

    % Apply SVD to HL3 and LH3
    [Uy_wm, Sy_wm, Vy_wm] = svd(HL3_wm);
    [Uy1_wm, Sy1_wm, Vy1_wm] = svd(LH3_wm);

    % Extract Watermark using modified singular values from watermark embedding
    Swrec = (Sy_wm ) / alpha; % Assuming 'alpha' is the embedding strength for the horizontal detail coefficients
    WMy = Uw * Swrec * Vw';
    
    Swrec1 = (Sy1_wm ) / beta; % Assuming 'beta' is the embedding strength for the vertical detail coefficients
    WMy1 = Uw1 * Swrec1 * Vw1';
    
    % Reconstruction of watermark images
    extracted_watermark_image1 = uint8(Uw' * WMy * Vw);
    extracted_watermark_image2 = uint8(Uw1' * WMy1 * Vw1);

    % Display or save the extracted watermark images
    imshow(extracted_watermark_image1);
    imwrite(extracted_watermark_image1, 'extracted_watermark_image1.png', 'png');
    imshow(extracted_watermark_image2);
    imwrite(extracted_watermark_image2, 'extracted_watermark_image2.png', 'png');

end

