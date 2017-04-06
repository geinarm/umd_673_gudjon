
folder = '../input/Training/';
ClassFolders = dir(folder);

counter = 1;
Templates = cell(62, 1);

for i = 1:length(ClassFolders)
    d = ClassFolders(i);
    path = [folder, d.name];
    T = zeros(64, 64);
    if (isdir(path) && ~strcmp(d.name,'.') && ~strcmp(d.name,'..'))
        filename = [path, '/GT-', d.name, '.csv'];
        fileID = fopen(filename, 'r');
        C = textscan(fileID,'%s%d%d%d%d%d%d%d', 'Delimiter',';', 'headerlines', 1);
        fclose(fileID);

        num_samples = length(C{1});
        for k = 1:num_samples
            I = imread([path, '/', C{1}{k}]);
            I = im2double(I);
            x1 = C{4}(k);
            x2 = C{6}(k);
            y1 = C{5}(k);
            y2 = C{7}(k);
            I_ = I(x1:x2, y1:y2, :);
            M = imresize(I_, [64, 64]);
            M = rgb2gray(M);
            %HSV = rgb2hsv(M);
            %S = mat2gray(HSV(:,:, 2));
            [Gmag, ~] = imgradient(M);
            T = T + Gmag;
            
        end
        
        T = mat2gray(T);
        Templates{counter} = T;
        counter = counter+1;
    end
end
