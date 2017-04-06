close all; hold off;

I = imread('../Input/Set1/100.jpg');
I = im2double(I);

Gray = rgb2gray(I);
%Gray = eye(100);
[height, width] = size(Gray);

[Gmag, Gdir] = imgradient(Gray);

tic
BW = imbinarize(Gmag, 0.6);

Idx = find(BW);
[subI, subJ] = ind2sub(size(BW), Idx);
H = zeros(400, 200);

maxRho = sqrt(2) * width;

for i = 1:length(Idx)
    for k = 1:200
        id = Idx(i);
        mag = Gmag(id);
        x = subJ(i);
        y = subI(i);
        
        theta = (k-1)/200 * pi;
        rho = x*cos(theta) + y*sin(theta);
        rho_id = ceil((rho/maxRho)*200) + 200;

        H(rho_id, k) = H(rho_id, k)+ceil((mag^2)*5);
    end
end

figure;
imagesc(H); hold on;

P  = houghpeaks(H, 20, 'threshold', ceil(0.3*max(H(:))));

figure;
imshow(BW), hold on;
pause(0.5)
hold on
for i = 1:length(P)
    rho_id = P(i, 1);
    theta_id = P(i, 2);
   
    rho = ((rho_id-200)/200) * (maxRho);
    theta = ((theta_id-1)/200) * pi;
   
    x1 = rho*sec(theta);
    x2 = x1 - height/(cos(theta)/sin(theta));
    
    x1 = max(0, min(x1, width));
    x2 = max(0, min(x2, width));
    
    x = min(x1, x2):max(x2, x1);
    y = (rho - x*cos(theta) )/ sin(theta);
    plot(x, y);
end
hold off;
toc
