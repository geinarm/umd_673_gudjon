
I1 = imread('../Data/singleTag1.png');
%I1 = imread('../Data/multipleTags3.png');
I2 = imread('../Data/T03.png');
Lena = imread('../Data/Lena.png');

I1 = im2double(I1);
I2 = im2double(I2);
Lena = im2double(Lena);

I1 = rgb2gray(I1);
I2 = rgb2gray(I2);
Lena = rgb2gray(Lena);
Lena = imresize(Lena, size(I2));

if ~exist('px1', 'var')
    figure
    imshow(I1);
    [px1,py1] = ginput(4);

    close all;

    figure
    imshow(I2);
    [px2,py2] = ginput(4);
    %px2 = [width; 0; 0; width];
    %py2 = [height; height; 0; 0];
    

    close all;
end

%H = calculateH(px2, py2, px1, py1);
%H = inv(H);
H = calculateH(px2, py2, px1, py1);

%tform = projective2d(H');
%IProj = imwarp(I1, tform);

tform = maketform('projective', H'); 
imt = imtransform(I1,tform,'XData',[0 100],'YData',[0, 100]);

imshow(IProj);

%{
figure
imshow(I1); hold on;
for i = 1:length(px2)
   p = [px2(i); py2(i); 1]; 
   p_ = H*p;
   p_ = p_ ./ p_(3);
   scatter(p_(1), p_(2));
   scatter(px1(i), py1(i), '.');
end
hold off;

I3 = I1;
[width, height] = size(Lena);
for row = 1:height
    for col = 1:width

        p = [col; row; 1];
        p_ = H*p;
        p_ = p_ ./ p_(3);
        p_ = floor(p_);
        
        I3(p_(2), p_(1)) = Lena(row, col);
        
    end    
end

figure
imshow(I3);
%}