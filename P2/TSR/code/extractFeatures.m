function [ X ] = extractFeatures( I )

I = im2double(I);
I = imgaussfilt(I, 0.8);
M = imresize(I, [60, 60]);

Gray = rgb2gray(M);
HSV = rgb2hsv(M);
[~, Gdir] = imgradient(Gray);
Gdir = (Gdir + 180) ./ 360;

%grad_bins = 50;
%h_bins = 50;
%s_bins = 50;

X = zeros(270,1);

quad = 1;
for row = 1:3
    for col = 1:3
        x1 = (col-1)*20 +1;
        x2 = x1+15;
        y1 = (row-1)*20 +1;
        y2 = y1+19;
        
        val_h = HSV(y1:y2, x1:x2, 1);
        val_s = HSV(y1:y2, x1:x2, 2);
        val_g = Gdir(y1:y2, x1:x2);
        
        hist_h = getHist(val_h(:), 10);
        hist_s = getHist(val_s(:), 10);
        hist_g = getHist(val_g(:), 10);
        
        ind = (quad-1)*30 + 1;
        X(ind:ind+29) = [hist_h; hist_s; hist_g];
        quad = quad+1;
    end
end

%{
sel = reshape(Gmag, 64*64, 1) > 0.1;
GP = reshape(Gdir, 64*64, 1);
GP = GP(sel);
gbin = ceil((GP + 180) ./ 360 * grad_bins);
ghist = zeros(grad_bins, 1);
for i = 1:grad_bins
   ghist(i) = sum(gbin==i);
end

HP = reshape(HSV(:, :, 1), 64*64, 1);
hbin = ceil(HP .* h_bins);
hhist = zeros(h_bins, 1);
for i = 1:h_bins
   hhist(i) = sum(hbin==i);
end

SP = reshape(HSV(:, :, 2), 64*64, 1);
sbin = ceil(SP .* s_bins);
shist = zeros(s_bins, 1);
for i = 1:s_bins
   shist(i) = sum(sbin==i);
end

X = [ghist; hhist; shist];
%}
end

function h = getHist(values, bins)
    bin = ceil(values .* bins);
    h = zeros(bins, 1);
    for i = 1:bins
       h(i) = sum(bin==i);
    end
end

