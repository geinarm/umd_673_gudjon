function [ L, A, ClassName ] = classifyPins( I, M )

I = im2double(I);

[height, width, ~] = size(I);
Pixels = reshape(I, [height*width, 3]);

ClassRGB = {...
    [1 0 0], ...
    [0 1 0], ...
    [0 0 1], ...
    [1 1 0], ...
    [1 1 1]};
ClassName = {...
    'Red', ...
    'Green', ...
    'Blue', ...
    'Yellow', ...
    'White'};

[Labels, numLabels] = bwlabel(M);
L = zeros(height, width);
ClassLabels = zeros(numLabels, 1);
for i = 1:numLabels
    regionIdx = find(Labels==i); 
    P = Pixels(regionIdx, :);
    meanRGB = mean(P);
    
    minDist = inf;
    minClass = 0;
    for k = 1:length(ClassRGB)
       rgb = ClassRGB{k};
       dist = sum((meanRGB - rgb).^2);
       if dist < minDist
           minDist = dist;
           minClass = k;
       end
    end
    
    ClassLabels(i) = minClass;
	L(regionIdx) = minClass;
    Pixels(regionIdx, :) = repmat(ClassRGB{minClass}, [length(regionIdx), 1]);
end

A = reshape(Pixels, [height, width, 3]);

for i = 1:length(ClassName)
    numOcc = sum(ClassLabels==i);
    fprintf('%i %s\n', numOcc, ClassName{i});
end

end

