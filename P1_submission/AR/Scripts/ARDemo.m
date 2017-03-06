
close all;
%I = imread('../Data/singleTag1.png');
I = imread('../Data/Tag0/100.jpg');
%I = imread('../Data/multipleTags3.png');

I = im2double(I);


if ~exist('H', 'var')
    Lines = findLines(I);
    Quads = findQuads(Lines);
    Tags = findTags(Quads, I);

    H = Tags{1}.Homography;
    H = inv(H);
end

%fx = 629.302552;
%fy = 635.529018;
%cx = 330.766408;
%cy = 251.004731;

fx = 1406.08415449821;
fy = 1417.99930662800;
cx = 1014.13643417416;
cy = 566.347754321696;
s = 2.2067978308599;

K = [fx, s, cx; 0, fy, cy; 0, 0, 1];

B = inv(K)*H;
%B = K\H;
if det(B) < 0
    fprintf('Flip B\n');
   B = B*-1;
end

L = (norm(B(:,1)) + norm(B(:,2))) / 2;
B = B .* (L^-1);

R = zeros(3);
R(:,1) = B(:, 1);
R(:,2) = B(:, 2);
R(:, 3) = cross(B(:, 2), B(:, 1));
T = B(:, 3);

P = K*[R,T];

Pw = [0 0 0 1; ...
      1 0 0 1; ...
      1 1 0 1; ...
      0 1 0 1; ...
      
      0 0 1 1; ...
      1 0 1 1; ...
      1 1 1 1; ...
      0 1 1 1]';

Pc = P*Pw;
Pc = Pc ./ Pc(3, :);


fig2 = figure;
imshow(I); hold on;

line([Pc(1,1), Pc(1,2)], [Pc(2,1), Pc(2,2)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,2), Pc(1,3)], [Pc(2,2), Pc(2,3)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,3), Pc(1,4)], [Pc(2,3), Pc(2,4)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,4), Pc(1,1)], [Pc(2,4), Pc(2,1)], 'Color', 'Red', 'linewidth', 2);

line([Pc(1,5), Pc(1,6)], [Pc(2,5), Pc(2,6)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,6), Pc(1,7)], [Pc(2,6), Pc(2,7)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,7), Pc(1,8)], [Pc(2,7), Pc(2,8)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,8), Pc(1,5)], [Pc(2,8), Pc(2,5)], 'Color', 'Red', 'linewidth', 2);

line([Pc(1,1), Pc(1,5)], [Pc(2,1), Pc(2,5)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,2), Pc(1,6)], [Pc(2,2), Pc(2,6)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,3), Pc(1,7)], [Pc(2,3), Pc(2,7)], 'Color', 'Red', 'linewidth', 2);
line([Pc(1,4), Pc(1,8)], [Pc(2,4), Pc(2,8)], 'Color', 'Red', 'linewidth', 2);

plot(Pc(1,:), Pc(2, :), '.', 'MarkerSize', 15);
