
I = imread('../Data/multipleTags3.png');
I = im2double(I);
I = rgb2gray(I);

C = corner(I);

figure
imshow(I); hold on;
scatter(C(:, 1), C(:, 2), '+');
hold off;