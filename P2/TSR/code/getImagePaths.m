function [ Paths, Names ] = getImagePaths( folder, extension )
%% Reads all images from a folder

if nargin < 2
   extension = '.jpg';
end

Files = dir(folder);
Paths = cell(0);
Names = cell(0);

k=1;
for i = 1:length(Files)
	[~, name, ext] = fileparts(Files(i).name);
	if strcmp(ext,extension)
        path = [folder, '/', Files(i).name];
        Paths{k} = path;
        Names{k} = name;
        k = k+1;
	end
end

end
