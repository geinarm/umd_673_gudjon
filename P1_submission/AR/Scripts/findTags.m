close all;

%I = imread('../Data/T01.png');
%I = imread('../Data/singleTag1.png');
I = imread('../Data/multipleTags3.png');
%I = imread('../Data/apriltagrobots.jpg');
I = im2double(I);
[height, width, ~] = size(I);

tic
Lines = FindLines(I);
Quads = findQuads(Lines);
toc

figure
imshow(I); hold on;
for i = 1:length(Lines)
    l = Lines{i};
    plot([l.Start(1), l.End(1)], [l.Start(2), l.End(2)], 'LineWidth', 2);
end
hold off;

figure
imshow(I); hold on;
for i = 1:length(Quads)
    Quad = Quads{i};
    for k = 1:4
        l = Quad.Lines(k);
        line([l.Start(1), l.End(1)], [l.Start(2), l.End(2)], 'LineWidth', 2);
    end
    scatter(Quad.Points(1,:), Quad.Points(2,:));
end
hold off;
