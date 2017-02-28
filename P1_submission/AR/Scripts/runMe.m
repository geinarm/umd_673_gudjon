global Lena

DataFolder = '../Data';

Lena = imread([DataFolder, '/Lena.png']);
Lena = im2double(Lena);

folders = {};
data = dir(DataFolder);

processFolder('../Data/Tag0', '../Output/Tag0');

%{
for i = 1:length(data)
    file = data(i);
    if file.isdir && ~strcmp(file.name, '.') && ~strcmp(file.name, '..')
       folders{end+1} = [DataFolder, '/', file.name];
    end
end
%}

function [] = processFolder(Input, Output)
    global Lena
    
    if ~isdir(Output)
       mkdir(Output); 
    end
    fprintf('Folder %s\n', Input);
    
    TagVideoFrames = cell(1,120);
    LenaVideoFrames = cell(1,120);
    %CubeVideoFrames = cell(1,120);
    
    i = 1;
    while exist([Input, '/', int2str(i), '.jpg'], 'file')
        fprintf('Frame %i\n', i);
        I = imread([Input, '/', int2str(i), '.jpg']);
        I = imresize(I, 0.5);
        I = im2double(I);

        Lines = findLines(I);
        Quads = findQuads(Lines);
        Tags = findTags(Quads, I);
        
        M = labelTags(Tags, I);
        TagVideoFrames{i} = M;
        if i == 1
            imwrite(M, [Output, '/detected.jpg']);
        end
        
        M = doLena(Tags, I, Lena);
        LenaVideoFrames{i} = M;
        
        i = i+1;
    end
    
    createVideo(TagVideoFrames, [Output, '/', 'detected.avi']);
    createVideo(LenaVideoFrames, [Output, '/', 'homography.avi']);
    
end

function [] = createVideo(Frames, name)
    video = VideoWriter(name);
    open(video);
    for i = 1:length(Frames)
       frame = im2frame(Frames{i});
       writeVideo(video, frame);
    end
    close(video);
end

%v = VideoReader('../Data/Tag0/Tag0.mp4')
%I = readFrame(v);
%imshow(I);

%{
video = VideoReader(videoFile);
k = 1;
while hasFrame(video)
  I = readFrame(video); 
  imwrite(I, [DataFolder, '/', file.name, '/', int2str(k), '.jpg']);
  k = k+1;
end
%}