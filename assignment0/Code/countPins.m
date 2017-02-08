
I = imread('../Input/TestImgResized.jpg');
I = im2double(I);
M = findPins(I);

[L, A, N] = classifyPins(I, M);

imwrite(A, '../Output/TestImgResized.jpg');
imshow(A);