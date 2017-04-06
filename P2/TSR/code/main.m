
%Output = '../output/testSet2/';
Output = '../output/frames/';
%[Images, Names] = readImages('../input/testSet2');
%[Paths, Names] = getImagePaths('../input/testSet2');
[Paths, Names] = getImagePaths('../input/frames');

load('Models');
%load('Templates');
classes = [45, 21, 38, 35, 17, 1, 14, 19];
classes = classes +1; % label numbers start from 1

figure
for k = 1:length(Paths)
    I = imread(Paths{k});
    [height,width, ~] = size(I);
    BB = findSigns(I);

    imshow(I), hold on;
    for j = 1:length(BB)
       bb = BB{j};
       padding = 0;
       x1 = max(1, ceil(bb(1)) -padding);
       x2 = min(width, ceil(bb(1)+bb(3)) +padding);
       y1 = max(1, ceil(bb(2)) -padding);
       y2 = min(height, ceil(bb(2)+bb(4)) +padding);
       ROI = I(y1:y2, x1:x2, :);
       %ROI = I(bb(2):bb(4), bb(1):bb(3), :);
       
       [p, s] = predictSign(ROI, Models, classes);
       if(s < 0)
          continue;
       end
       %[p, s] = predictSign(ROI, Templates, classes);
       rectangle('Position', bb, 'edgecolor', 'green', 'LineWidth', 3);
       str = sprintf('%i (%.2f)', p-1, s);
       text(bb(1), bb(2), str, 'FontSize', 14, 'Color', 'magenta');
    end
    
    set(gca,'position',[0 0 1 1],'units','normalized');
    F = getframe(gcf);
    [M, ~] = frame2im(F);
    
    imwrite(M, [Output, Names{k}, '.jpg']);
end
