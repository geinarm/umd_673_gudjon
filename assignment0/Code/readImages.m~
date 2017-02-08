function [ Images, Names ] = readImages( folder, extension )
%% Reads all images from a folder

if nargin < 2
   extension = '.jpg';
end

Files = dir(folder);
Images = cell(0);
Names = cell(0);

for i = 1:length(Files)
	[~, name, ext] = fileparts(Files(i).name);
	if strcmp(ext,extension)
        I = imread([folder, '/', Files(i).name]);
        
        k = length(Images)+1;
        Images{k} = I;
        Names{k} = name;
	end
end

end

