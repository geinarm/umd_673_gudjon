
[Paths, Names] = getImagePaths('../output/frames/');
Output = '../output/';

video = VideoWriter([Output, 'video.avi']);
open(video);

figure;
for k = 1:length(Paths)
    fprintf('Frame %s\n', Names{k});
    I = imread(Paths{k});
    
    [height, width, ~] = size(I);
    if(height ~= 915 || width ~= 1272)
       I = imresize(I, [915, 1272]);
    end
    
    frame = im2frame(I);
    writeVideo(video, frame);
end

close(video);