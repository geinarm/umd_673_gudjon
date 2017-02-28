close all;

%I = imread('../Data/T01.png');
%I = imread('../Data/singleTag1.png');
%I = imread('../Data/multipleTags3.png');
%I = imread('../Data/apriltagrobots.jpg');
I = imread('../Data/Tag2/70.jpg');

I = imresize(I, 0.5);
I = im2double(I);
[height, width, ~] = size(I);

%figure
%imshow(I);

tic
Lines = findLines(I);
Quads = findQuads(Lines);
Tags = findTags(Quads, I);
toc

length(Quads)

figure
labelTags(Tags, I);

figure
imshow(Tags{1}.Pattern);

%{
figure
imshow(I); hold on;
for i = 1:length(Lines)
    l = Lines{i};
    plot([l.Start(1), l.End(1)], [l.Start(2), l.End(2)], 'LineWidth', 2);
    plot([l.Center(1), l.Center(1)+l.Normal(1)*10],...
        [l.Center(2), l.Center(2)+l.Normal(2)*10], 'LineWidth', 1);
    scatter(l.Start(1), l.Start(2), 20, [1 0 0]);
    scatter(l.End(1), l.End(2), 20, [0 0 1]);
end
hold off;
%}



%{
figure
imshow(I); hold on;
color = {'red', 'green', 'blue', 'yellow'};
for i = 1:length(Quads)
    Quad = Quads{i};
    for k = 1:4
        l = Quad.Lines(k);
        line([l.Start(1), l.End(1)], [l.Start(2), l.End(2)], 'LineWidth', 2, 'Color', color{k});
    end
    scatter(Quad.Points(1,:), Quad.Points(2,:));
end
hold off;
%}
