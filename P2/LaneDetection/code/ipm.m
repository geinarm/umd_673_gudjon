function [ R, H ] = ipm( I, h, v )

[height, width] = size(I);

center = width/2;
x1 = [center-v, 0, width, center+v];
y1 = [h, height, height, h];
x2 = [1, 1, 2, 2];
y2 = [0, 1, 1, 0];

H = calculateH(x2, y2, x1, y1);

tform = projective2d(H');
ra = imref2d([1024, 1024],[0, 3],[0, 1]);
R = imwarp(I, tform, 'OutputView', ra);

end

