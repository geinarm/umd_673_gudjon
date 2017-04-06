function [ H ] = calculateH( x1, y1, x2, y2 )
%Calculate homography from (x2,y2) to (x1,y1)


A = zeros(length(x1)*2, 9);

for i = 1:length(x1)
    w = [x2(i), y2(i), 1];
    z = [0, 0, 0];
    c = [x1(i), y1(i)];
    
    A((i-1)*2+1:(i-1)*2+2, :) = ...
        [w, z, -c(1)*w(1), -c(1)*w(2), -c(1);...
         z, w, -c(2)*w(1), -c(2)*w(2), -c(2)];
end

[~, ~, V] = svd(A);
h = V(:, 9);
H = reshape(h,3,3)';
H = H ./ H(3,3);

end

