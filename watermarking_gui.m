function watermarking_gui()
    % Create GUI figure window
    fig = figure('Name', 'Watermarking GUI', 'Position', [100, 100, 1000, 600]);

    % Initialize variables to store images
    coverImage = [];
    watermarkImage = [];
    watermarkedImage = [];
    encryptedImage = [];
    decryptedImage = [];
    extractedWatermark1 = [];
    extractedWatermark2 = [];

    % Create axes for displaying images
    axesCover = axes('Units', 'pixels', 'Position', [50, 350, 200, 200]);
    axesWatermark = axes('Units', 'pixels', 'Position', [300, 350, 200, 200]);
    axesWatermarked = axes('Units', 'pixels', 'Position', [550, 350, 200, 200]);
    axesEncrypted = axes('Units', 'pixels', 'Position', [800, 350, 200, 200]);
    axesDecrypted = axes('Units', 'pixels', 'Position', [300, 50, 200, 200]);
    axesExtracted1 = axes('Units', 'pixels', 'Position', [550, 50, 200, 200]);
    axesExtracted2 = axes('Units', 'pixels', 'Position', [800, 50, 200, 200]);

    % Add UI components
    uicontrol('Style', 'pushbutton', 'String', 'Read Cover Image', ...
              'Position', [50, 300, 150, 30], 'Callback', @readCoverImage);
          
    uicontrol('Style', 'pushbutton', 'String', 'Read Watermark Image', ...
              'Position', [250, 300, 150, 30], 'Callback', @readWatermarkImage);
          
    uicontrol('Style', 'pushbutton', 'String', 'Embed Watermark', ...
              'Position', [450, 300, 150, 30], 'Callback', @embedWatermark);
          
    uicontrol('Style', 'pushbutton', 'String', 'Encrypt Image', ...
              'Position', [650, 300, 150, 30], 'Callback', @encryptImage);
          
    uicontrol('Style', 'pushbutton', 'String', 'Decrypt Image', ...
              'Position', [850, 300, 150, 30], 'Callback', @decryptImage);
    
    uicontrol('Style', 'pushbutton', 'String', 'Extract Watermarks', ...
              'Position', [450, 250, 150, 30], 'Callback', @extractWatermarks);
          
    uicontrol('Style', 'pushbutton', 'String', 'Save Watermarked Image', ...
              'Position', [50, 250, 200, 30], 'Callback', @saveWatermarkedImage);
          
    uicontrol('Style', 'pushbutton', 'String', 'Save Encrypted Image', ...
              'Position', [250, 250, 200, 30], 'Callback', @saveEncryptedImage);
          
    uicontrol('Style', 'pushbutton', 'String', 'Save Decrypted Image', ...
              'Position', [650, 250, 200, 30], 'Callback', @saveDecryptedImage);
    
    uicontrol('Style', 'pushbutton', 'String', 'Save Extracted Watermarks', ...
              'Position', [850, 250, 200, 30], 'Callback', @saveExtractedWatermarks);

    % Function to read cover image
    function readCoverImage(~, ~)
        [file, path] = uigetfile({'*.png;*.jpg;*.jpeg', 'Image files'}, 'Select Cover Image');
        if isequal(file, 0)
            return;
        end
        coverImage = imread(fullfile(path, file));
        imshow(coverImage, 'Parent', axesCover);
    end

    % Function to read watermark image
    function readWatermarkImage(~, ~)
        [file, path] = uigetfile({'*.png;*.jpg;*.jpeg', 'Image files'}, 'Select Watermark Image');
        if isequal(file, 0)
            return;
        end
        watermarkImage = imread(fullfile(path, file));
        imshow(watermarkImage, 'Parent', axesWatermark);
    end
    
% Function to embed watermark
        function embedWatermark(~, ~)
            if isempty(coverImage) || isempty(watermarkImage)
                errordlg('Please select both cover image and watermark image.', 'Error');
            return;
            end
    
            % Check if cover image dimensions match watermark image dimensions
            if size(coverImage, 1) < size(watermarkImage, 1) || size(coverImage, 2) < size(watermarkImage, 2)
                errordlg('Watermark image cannot be larger than cover image.', 'Error');
            return;
            end
        
            % Resize watermark image to match cover image dimensions
            watermarkImageResized = imresize(watermarkImage, [size(coverImage, 1), size(coverImage, 2)]);
    
            % Apply watermark embedding logic (assuming similar logic as provided in the original code)
            alpha = 0.09; % Adjust alpha value as needed
            beta = 0.09;  % Adjust beta value as needed
        
            % Perform DWT on cover image
            [LL1, HL1, LH1, HH1] = dwt2(double(coverImage), 'haar');
        
            % Perform DWT on LL1 (approximation subband)
            [LL2, HL2, LH2, HH2] = dwt2(LL1, 'haar');
        
            % Perform DWT on LL2
            [LL3, HL3, LH3, HH3] = dwt2(LL2, 'haar');
        
            % Apply Singular Value Decomposition (SVD) on HL3 and LH3
            [Uy, Sy, Vy] = svd(HL3);
            [Uy1, Sy1, Vy1] = svd(LH3);
        
            % Apply SVD on watermark image
            [Uw, Sw, Vw] = svd(double(watermarkImageResized));
        
            % Embed watermark by modifying singular values
            Sy_mark = Sy + alpha * Sw;
            Sy1_mark = Sy1 + beta * Sw;
    
            % Reconstruct HL3 and LH3 using modified singular values
            HL3_embedded = Uy * Sy_mark * Vy';
            LH3_embedded = Uy1 * Sy1_mark * Vy1';
        
            % Reconstruct LL2 using embedded HL3 and LH3
            LL2_embedded = idwt2(LL3, HL3_embedded, LH3_embedded, HH3, 'haar', 'db2');
        
            % Reconstruct LL1 using embedded LL2
            LL1_embedded = idwt2(LL2_embedded, HL2, LH2, HH2, 'haar', 'db2');
        
            % Reconstruct watermarked image using embedded LL1 and original HL1, LH1, HH1
            watermarkedImage = uint8(idwt2(LL1_embedded, HL1, LH1, HH1, 'haar', 'db2'));
        
            % Display watermarked image
            imshow(watermarkedImage, 'Parent', axesHandle);
            
        end

    % Function to encrypt the image
    function encryptImage(~, ~)
        if isempty(watermarkedImage)
            errordlg('Please embed the watermark first.', 'Error');
            return;
        end
        % Implement encryption logic
        % Placeholder for now
        encryptedImage = watermarkedImage; % Placeholder
        imshow(encryptedImage, 'Parent', axesEncrypted);
    end

    % Function to decrypt the image
    function decryptImage(~, ~)
        if isempty(encryptedImage)
            errordlg('Please encrypt the image first.', 'Error');
            return;
        end
        % Implement decryption logic
        % Placeholder for now
        decryptedImage = encryptedImage; % Placeholder
        imshow(decryptedImage, 'Parent', axesDecrypted);
    end

    % Function to extract watermarks
    function extractWatermarks(~, ~)
        if isempty(decryptedImage)
            errordlg('Please decrypt the image first.', 'Error');
            return;
        end
        % Implement watermark extraction logic
        % Placeholder for now
        extractedWatermark1 = decryptedImage; % Placeholder
        extractedWatermark2 = decryptedImage; % Placeholder
        imshow(extractedWatermark1, 'Parent', axesExtracted1);
        hold(axesExtracted1, 'on');
        imshow(extractedWatermark2, 'Parent', axesExtracted2);
        hold(axesExtracted1, 'off');
    end

    % Function to save watermarked image
    function saveWatermarkedImage(~, ~)
        if isempty(watermarkedImage)
            errordlg('No watermarked image to save.', 'Error');
            return;
        end
        [file, path] = uiputfile({'*.png', 'PNG files'; '*.jpg', 'JPEG files'}, 'Save Watermarked Image');
        if isequal(file, 0)
            return;
        end
        imwrite(watermarkedImage, fullfile(path, file));
    end

    % Function to save encrypted image
    function saveEncryptedImage(~, ~)
        if isempty(encryptedImage)
            errordlg('No encrypted image to save.', 'Error');
            return;
        end
        [file, path] = uiputfile({'*.png', 'PNG files'; '*.jpg', 'JPEG files'}, 'Save Encrypted Image');
        if isequal(file, 0)
            return;
        end
        imwrite(encryptedImage, fullfile(path, file));
    end

    % Function to save decrypted image
    function saveDecryptedImage(~, ~)
        if isempty(decryptedImage)
            errordlg('No decrypted image to save.', 'Error');
            return;
        end
        [file, path] = uiputfile({'*.png', 'PNG files'; '*.jpg', 'JPEG files'}, 'Save Decrypted Image');
        if isequal(file, 0)
            return;
        end
        imwrite(decryptedImage, fullfile(path, file));
    end

    % Function to save extracted watermarks
    function saveExtractedWatermarks(~, ~)
        if isempty(extractedWatermark1) || isempty(extractedWatermark2)
            errordlg('No extracted watermarks to save.', 'Error');
            return;
        end
        [file, path] = uiputfile({'*.png', 'PNG files'}, 'Save Extracted Watermarks');
        if isequal(file, 0)
            return;
        end
        imwrite(extractedWatermark1, fullfile(path, 'extracted_watermark_1.png'));
        imwrite(extractedWatermark2, fullfile(path, 'extracted_watermark_2.png'));
    end
end
