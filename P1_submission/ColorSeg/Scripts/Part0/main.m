close all;

InputFolder = '../../Images/TestSet/Frames/';
OutputFolder = '../../Output/Part0/Frames/';
VideoFolder = '../../Output/Part0/';

load('Model.mat');

i = 1;
while exist([InputFolder, int2str(i), '.jpg'], 'file')
    I = imread([InputFolder, int2str(i), '.jpg']);
    I = im2double(I);
    I = imgaussfilt(I, 0.8);
    
    [height, width, ~] = size(I);
    
    Buoys = detectBuoys(I, Model);
    
    %% Draw Buoys
    hold off;
    imshow(I); hold on;
    for k = 1:length(Buoys)
        B = Buoys{k};
        E = bwboundaries(B.Mask);
        plot(E{1}(:, 2), E{1}(:, 1), 'Color', B.Color);
    end
    hold off;
    
    set(gca,'position',[0 0 1 1],'units','normalized');
    F = getframe(gcf);
    [X, ~] = frame2im(F);
    imwrite(X, [OutputFolder, int2str(i), '.jpg']);
    
    i = i+1;
end

%% Create Video
Frames = {};
i = 1;
while exist([OutputFolder, int2str(i), '.jpg'], 'file')
    I = imread([OutputFolder, int2str(i), '.jpg']);
    Frames{end+1} = I;
    i = i+1;
end
createVideo(Frames, [VideoFolder, 'video.avi']);



function [] = createVideo(Frames, name)
    video = VideoWriter(name);
    open(video);
    for i = 1:length(Frames)
       frame = im2frame(Frames{i});
       writeVideo(video, frame);
    end
    close(video);
end