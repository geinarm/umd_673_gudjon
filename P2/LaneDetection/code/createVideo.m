
%[Paths, Names] = getImagePaths('../input/Set1/');
Output = '../output/';
Input = '../output/Set1/';

video = VideoWriter([Output, 'video.avi']);
open(video);

figure;
for k = 1:1260
    fprintf('Frame %i\n', k);
    I = imread([Input, int2str(k), '.jpg']);
    frame = im2frame(I);
    writeVideo(video, frame);
end

close(video);