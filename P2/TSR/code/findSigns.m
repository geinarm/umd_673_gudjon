function [ BB ] = findSigns( I )

I = im2double(I);
%I = I(5:end-5, 5:end-5, :);
[height, width, ~] = size(I);

I = imgaussfilt(I, 0.8);
I = imadjust(I,stretchlim(I),[]);

HSV = rgb2hsv(I);
%LAB = rgb2lab(I);

numPixels = width*height;
Pixels = reshape(I, numPixels, 3);
Pixels_hsv = reshape(HSV, numPixels, 3);
%Pixels_lab = reshape(LAB, numPixels, 3);

C_blue = zeros(numPixels, 1);
C_red = zeros(numPixels, 1);
for i = 1:numPixels
    r = Pixels(i, 1);
    g = Pixels(i, 2);
    b = Pixels(i, 3);
    s = Pixels_hsv(i, 2);

    C_blue(i) = max(0, (b-r / (r+g+b)) );
    if b < 0.1
        C_blue(i) = b;
    else
        C_blue(i) = b / (r+g+b) * s;
    end
    if r < 0.1
        C_red(i) = r;
    else
        C_red(i) = r / (r+g+b) * s;
    end

end

Gray_blue = reshape(C_blue, height, width);
Gray_blue = imclose(Gray_blue, strel('disk', 5));
Gray_blue = imfill(Gray_blue);
Gray_blue = imadjust(Gray_blue, [0, 0.6], []);

Gray_red = reshape(C_red, height, width);
Gray_red = imclose(Gray_red, strel('disk', 5));
Gray_red = imfill(Gray_red);
Gray_red = imopen(Gray_red,strel('disk',2));
Gray_red = imadjust(Gray_red, [0, 0.6], []);

BW_red = imbinarize(Gray_red, 0.5);
BW_red = bwconvhull(BW_red ,'object');
BW_red = bwareaopen(BW_red, 300);
BW_blue = imbinarize(Gray_blue, 0.5);
BW_blue = bwconvhull(BW_blue ,'object');
BW_blue = bwareaopen(BW_blue, 300);

%Gray = Gray_red + Gray_blue;
BW = BW_red | BW_blue;
BB = {};

Props = regionprops(BW,'BoundingBox', 'Area');
for i = 1:length(Props)
    p = Props(i);
    bb = p.BoundingBox; 
    w = bb(3);
    h = bb(4);
	%x1 = max(1, ceil(bb(1)));
	%x2 = min(width, ceil(bb(1)+bb(3)));
	%y1 = max(1, ceil(bb(2)));
	%y2 = min(height, ceil(bb(2)+bb(4)));    
    
    ratio = w/h;
    if((ratio < 0.5) || (ratio > 1.5))
       continue; 
    end
    
    if(bb(2) > height/1.5)
        continue; 
    end
    
    %{
    Gray_rect = Gray(y1:y2, x1:x2);
    score = sum(sum(Gray_rect)) / p.Area
    if(score < 1)
       continue; 
    end
    %}
    
    BB{end+1} = bb;
end

end

