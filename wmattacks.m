% Choose a watermark attack
attack_choice = input('Choose a watermark attack :\n1. Gaussian noise\n2. Salt and Pepper noise \n');

switch attack_choice
    case 1
        % Noise Addition
        watermarked_image_attacked = imnoise(watermarked_image, 'gaussian', 0, 0.01);
        imwrite(watermarked_image_attacked, 'gaussian_attack.png', 'png');
        
    case 2
        watermarked_image_attacked = imnoise(watermarked_image, 'salt & pepper', 0.02);
        imwrite(watermarked_image_attacked, 'saltpepper_attack.png', 'png');
        
    otherwise
        disp('Invalid choice. Please choose a number between 1 and 8.');
end
