global Lena

DataFolder = '../Data';
OutputFolder = '../Output';

Lena = imread([DataFolder, '/Lena.png']);
Lena = im2double(Lena);

folders = {};
data = dir(DataFolder);

%processFolder('../Data/Tag2', '../Output/Tag2');
%processFolder('../Data/multipleTags', '../Output/multipleTags');


for i = 1:length(data)
    file = data(i);
    if file.isdir && ~strcmp(file.name, '.') && ~strcmp(file.name, '..')
       Input = [DataFolder, '/', file.name];
       Output = [OutputFolder, '/', file.name];


       if ~exist(Output, 'file')
          mkdir(Output); 
       end
       processFolder(Input, Output);
    end
end


function [] = processFolder(Input, Output)
    global Lena
    
    if ~isdir(Output)
       mkdir(Output); 
    end
    fprintf('Folder %s\n', Input);
    
    TagVideoFrames = cell(1,120);
    LenaVideoFrames = cell(1,120);
    CubeVideoFrames = cell(1,120);
    
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
        
        M = doCube(I, Tags);
        CubeVideoFrames{i} = M;
        
        i = i+1;
    end
    
    createVideo(TagVideoFrames, [Output, '/', 'detected.avi']);
    createVideo(LenaVideoFrames, [Output, '/', 'homography.avi']);
    createVideo(CubeVideoFrames, [Output, '/', 'AR.avi']);
    
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
