
videoFile = '../Input/challenge_video.mp4';
%videoFile = '../Input/project_video.mp4';
DataFolder = '../Input/Set2/';


video = VideoReader(videoFile);
k = 1;
while hasFrame(video)
  I = readFrame(video); 
  imwrite(I, [DataFolder, int2str(k), '.jpg']);
  k = k+1;
end

