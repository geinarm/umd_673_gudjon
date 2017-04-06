function [ F, L ] = readDataSet( folder )

    ClassFolders = dir(folder);
    
    counter = 1;
    FeatureCell = cell(4000, 1);
    LabelCell = cell(4000, 1);

    for i = 1:length(ClassFolders)
        d = ClassFolders(i);
        path = [folder, d.name];
        if (isdir(path) && ~strcmp(d.name,'.') && ~strcmp(d.name,'..'))
            filename = [path, '/GT-', d.name, '.csv'];
            fileID = fopen(filename, 'r');
            C = textscan(fileID,'%s%d%d%d%d%d%d%d', 'Delimiter',';', 'headerlines', 1);
            fclose(fileID);

            num_samples = length(C{1});
            for k = 1:num_samples
                I = imread([path, '/', C{1}{k}]);
                x1 = C{4}(k);
                x2 = C{6}(k);
                y1 = C{5}(k);
                y2 = C{7}(k);
                I_ = I(x1:x2, y1:y2, :);
                X = extractFeatures(I_);
                FeatureCell{counter} = X';
                LabelCell{counter} = C{8}(k)+1;
                counter = counter+1;
            end
        end
    end
    
    ix=cellfun(@isempty,LabelCell);
    FeatureCell(ix) = [];
    LabelCell(ix) = [];
    F = cell2mat(FeatureCell);
    L = cell2mat(LabelCell);

end

