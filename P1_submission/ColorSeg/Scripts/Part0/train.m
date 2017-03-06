close all;

ImageFolder = '../../Images/TrainingSet/Frames/';
MaskFolder = '../../Images/TrainingSet/CroppedBuoys/';

Model = trainModel(ImageFolder, MaskFolder);           
save('Model.mat', 'Model');


function Model = trainModel(ImageFolder, MaskFolder)
    RedSample = [];
    GreenSample = [];
    YellowSample = [];

    i = 1;
    while exist([ImageFolder, int2str(i), '.jpg'], 'file') > 0
        I = imread([ImageFolder, int2str(i), '.jpg']);
        I = im2double(I);
        I = rgb2hsv(I);
        %I = rgb2lab(I);

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


    %% Save color model
    [R_mu, R_var] = estimate(RedSample(:, 1) ./ RedSample(:, 3));
    [G_mu, G_var] = estimate(GreenSample(:, 1) ./ GreenSample(:, 2));
    [Y_mu, Y_var] = estimate(YellowSample(:, 1));
    Model = struct('RedMean', R_mu, 'RedCov', R_var, ...
                   'GreenMean', G_mu, 'GreenCov', G_var, ...
                   'YellowMean', Y_mu, 'YellowCov', Y_var);

end

function [ mu, sigma ] = estimate( samples )
    mu = mean(samples);
    sigma = std(samples);
end

function [P] = getPixels(I, M)

    c1 = I(:,:, 1);
    c2 = I(:,:, 2);
    c3 = I(:,:, 3);

    P = [c1(M), c2(M), c3(M)];

end