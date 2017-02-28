close all;
%I1 = imread('../Data/singleTag1.png');
I1 = imread('../Data/Tag0/1.jpg');
%I1 = imread('../Data/multipleTags3.png');
I2 = imread('../Data/T03.png');
Lena = imread('../Data/Lena.png');

I1 = im2double(I1);
I2 = im2double(I2);
Lena = im2double(Lena);

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
Lena = rgb2gray(Lena);

if ~exist('px1', 'var')
    figure
    imshow(I1);
    [px1,py1] = ginput(4);

    close all;
end

%%Rectify pattern
px2 = [1 1 0 0];
py2 = [1 0 0 1];
H = calculateH(px2, py2, px1, py1);
tform = projective2d(H');
ra = imref2d([100, 100],[0, 1],[0, 1]);
Pattern = imwarp(I1,tform, 'OutputView', ra);
figure; imshow(Pattern);

%%Lena
[width, height] = size(Lena);
tform = tform.invert();
ref_in = imref2d(size(Lena), 1/width, 1/height);
ref_out = imref2d(size(I1));
Lena_ = imwarp(Lena,ref_in,tform, 'OutputView', ref_out);

I3 = I1;
I3(Lena_ > 0) = 0;
I3 = I3+Lena_;
figure; imshow(I3);

%{
HInv = inv(H);
I3 = I1;
[width, height] = size(Lena);
for row = 1:height
    for col = 1:width

        p = [col; row; 1];
        p = p.*[1/width; 1/height; 1];
        p_ = HInv*p;
        p_ = p_ ./ p_(3);
        p_ = floor(p_);
        
        if p_(2) < 1 || p_(1) < 1
           continue; 
        end
        
        I3(p_(2), p_(1)) = Lena(row, col);
        
    end    
end

figure
imshow(I3);
%}
