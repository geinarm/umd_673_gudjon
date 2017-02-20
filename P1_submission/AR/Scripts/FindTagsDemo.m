close all;

%I = imread('../Data/T01.png');
%I = imread('../Data/singleTag1.png');
I = imread('../Data/multipleTags3.png');
%I = imread('../Data/apriltagrobots.jpg');
I = im2double(I);
[height, width, ~] = size(I);

%figure
%imshow(I);

tic
Lines = findLines(I);
Quads = findQuads(Lines);
Tags = findTags(Quads, I);
toc

length(Tags)
figure
imshow(I); hold on;
for i = 1:length(Tags)
    t = Tags{i};
    scatter(t.Points(1,:), t.Points(2,:), 20, [1 0 0;0 1 0;0 0 1;1 1 0], 'filled');
    text(t.Points(1,1), t.Points(2,1)-20, ['T',int2str(t.Id)], 'Color', 'red');
end
hold off;

%{
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
%}
