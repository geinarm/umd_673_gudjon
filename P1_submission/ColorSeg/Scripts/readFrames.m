
videoFile = '../Images/detectbuoy.avi';
DataFolder = '../Images/TrainingSet/Frames/';
Output = '../Images/TrainingSet/CroppedBuoys/';

%{
video = VideoReader(videoFile);
k = 1;
while hasFrame(video)
  I = readFrame(video); 
  imwrite(I, [DataFolder, int2str(k), '.jpg']);
  k = k+1;
end
%}

data = dir(DataFolder);
j = 1;
for i = 1:length(data)
    file = data(i);
    if ~strcmp(file.name, '.') && ~strcmp(file.name, '..')
       I = imread([DataFolder, file.name]);
       [height, width, ~] = size(I);
       
       imshow(I); hold on;
       maskY = roipoly;
       
       imshow(I); hold on;
       maskR = roipoly;
       
       imshow(I); hold on;
       maskG = roipoly;
       
       if isempty(maskY)
           maskY = zeros(height, width);
       end
       if isempty(maskR)
           maskR = zeros(height, width);
       end
       if isempty(maskG)
           maskG = zeros(height, width);
       end
       
       imwrite(maskY, [Output, 'Y_' ,file.name]);
       imwrite(maskR, [Output, 'R_' ,file.name]);
       imwrite(maskG, [Output, 'G_' ,file.name]);
       
       j=j+1;
    end
end