function [ label, score ] = predictSign( Region, Models, classes)

if(nargin < 3)
    num_labels = length(Models);
    classes = 1:num_labels;
else
    num_labels = length(classes);
end

%{
I = im2double(Region);
I = rgb2gray(I);
%HSV = rgb2hsv(I);
I = imresize(I, [64,64]);
[M, ~] = imgradient(I);
M = imgaussfilt(M, 2);
%M = mat2gray(M);
S = zeros(num_labels, 1);
k = 1;
for i = classes
    T = Models{i};
    a = sum(T(:));
    %S(k) = sum(sum(T.*M));
    err = abs(T-M);
    %score = sum(sum(T.*M));
    score = sum(sum(err))/a;
    S(k) = score;
    k = k+1;
    
    %imshow(err);
    %pause
end

[maxScore, maxI] = min(S);
label = classes(maxI);
score = maxScore;
%}


X = extractFeatures(Region);

S = zeros(num_labels, 1);
k = 1;
for i = classes
    [~, s] = predict(Models{i}, X');
    S(k) = s(2);
    k = k+1;
end
[maxScore, maxI] = max(S);

label = classes(maxI);
score = maxScore;


end

