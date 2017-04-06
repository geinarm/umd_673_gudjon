
%[Paths, Names] = getImagePaths('../input/Set1/');
Output = '../output/Set1/';
Input = '../input/Set1/';

%IPM_Frames = {};
%Road_Frames = {};

figure;
for k = 100:1260
    fprintf('Frame %i\n', k);
    
    I = imread([Input, int2str(k), '.jpg']);
    I = im2double(I);
    Gray = rgb2gray(I);
    [height, width] = size(Gray);
    Gray = imgaussfilt(Gray, 0.8);

    %imshow(I);
    %hold on;
    
    %horizon = 430;
    horizon = 440;
    %b = 50;
    b = 50;

    [Road, H] = ipm(Gray, horizon, b);
    [Pts, W] = findLaneMarkers(Road);
    figure;
    imagesc(Road)
    hold on;
    plot(Pts(1, :)*1024, Pts(2, :)*1024, '.', 'Color', 'red');
    
    [LanePoints, Ps] = findLanes(Pts, W, 10);

    for i = 1:length(Ps)
        y = 0:0.05:1;
        x = polyval(Ps{i},y);
        plot(x*1024, y*1024, '-', 'Color', 'green');
    end
    pause

    %set(gca,'position',[0 0 1 1],'units','normalized');
    %F = getframe(gcf);
    %[M, ~] = frame2im(F);
    %IPM_Frames{end+1} = M;

    tform = projective2d(H');
    for i = 1:length(Ps)
        y = 0:0.05:1;
        x = polyval(Ps{i} ,y); 
        Points = [x; y];

        [u, v] = transformPointsInverse(tform, Points(1,:)*3, Points(2,:));
        plot(u, v, '-', 'Color', 'green', 'LineWidth', 2);
    end
    
    set(gca,'position',[0 0 1 1],'units','normalized');
    F = getframe(gcf);
    [M, ~] = frame2im(F);
    
    imwrite(M, [Output, int2str(k), '.jpg']);

end

