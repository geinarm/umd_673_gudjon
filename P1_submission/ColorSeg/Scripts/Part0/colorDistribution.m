close all;

ImageFolder = '../../Images/TrainingSet/Frames/';
MaskFolder = '../../Images/TrainingSet/CroppedBuoys/';
OutputFolder = '../../Output/Part0/';

RedSample = [];
GreenSample = [];
YellowSample = [];

i = 1;
while exist([ImageFolder, int2str(i), '.jpg'], 'file') > 0
    I = imread([ImageFolder, int2str(i), '.jpg']);
    I = im2double(I);
    I = rgb2hsv(I);
    Mr = imread([MaskFolder, 'R_' ,int2str(i), '.jpg']);
    Mg = imread([MaskFolder, 'G_' ,int2str(i), '.jpg']);
    My = imread([MaskFolder, 'Y_' ,int2str(i), '.jpg']);
    
    Mr = imbinarize(Mr, 0.5);
    Mg = imbinarize(Mg, 0.5);
    My = imbinarize(My, 0.5);
    
    RedSample = [RedSample; getPixels(I, Mr)];
    GreenSample = [GreenSample; getPixels(I, Mg)];
    YellowSample = [YellowSample; getPixels(I, My)];
    
    i = i+1;
end


%% Plot Red
figRed = figure;
plot3(RedSample(:, 1), RedSample(:, 2), RedSample(:, 3), '.');
title('Red Buoy Color Distribution');
xlabel('R');
ylabel('G');
zlabel('B');
saveas(figRed, [OutputFolder, 'R_hist.jpg']);

%% Plot Green
figGreen = figure;
plot3(GreenSample(:, 1), GreenSample(:, 2), GreenSample(:, 3), '.');
title('Green Buoy Color Distribution');
xlabel('R');
ylabel('G');
zlabel('B');
saveas(figGreen, [OutputFolder, 'G_hist.jpg']);

%% Plot Yellow
figYellow = figure;
plot3(YellowSample(:, 1), YellowSample(:, 2), YellowSample(:, 3), '.');
title('Yellow Buoy Color Distribution');
xlabel('R');
ylabel('G');
zlabel('B');
saveas(figYellow, [OutputFolder, 'Y_hist.jpg']);

%% Save color model
[R_mu, R_var] = estimate(RedSample(:, 1) ./ sum(RedSample, 2));
[G_mu, G_var] = estimate(GreenSample(:, 2) ./ sum(GreenSample, 2));
[Y_mu, Y_var] = estimate(sum(YellowSample(:,1:2), 2) ./ sum(YellowSample, 2));
Model = struct('R', [R_mu, R_var], 'G', [G_mu, G_var], 'Y', [Y_mu, Y_var]);
save('Model.mat', 'Model');


function [P] = getPixels(I, M)

    c1 = I(:,:, 1);
    c2 = I(:,:, 2);
    c3 = I(:,:, 3);

    P = [c1(M), c2(M), c3(M)];

end