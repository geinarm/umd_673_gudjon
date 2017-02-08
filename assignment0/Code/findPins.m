function [ Mask ] = findPins( I )

I = im2double(I);
I = imgaussfilt(I, 1.5);

%% Create grayscale image
Lab = rgb2lab(I);
Gray = sum(Lab, 3);
Gray = mat2gray(Gray);

%% Find objects based on gradient
G = imgradient(Gray);
G = imfill(G);
G = imopen(G, strel('disk', 2));

%% Use adaprive threshold to create binary mask
T = adaptthresh(G, 0.01);
bw = imbinarize(G, T);

%% Reject regions that are to small
Props = regionprops(bw, 'Area');
maxArea = 0;
for i = 1:length(Props)
    maxArea = max(maxArea, Props(i).Area);
end
bw = bwareaopen(bw, floor(maxArea/3));

Mask = bw;

end

