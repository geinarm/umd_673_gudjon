function [ Pts, W ] = findLaneMarkers( I )

filter = fspecial('gaussian',[1 51], 4.5);
numSlices = 30;
thickness = floor(1024/numSlices);
Pts = [];
W = [];
for i = 1:numSlices
    y = ((i-1) * thickness) +1;
    slice = I(y:y+thickness, :);
    
    % Find lane signal and filter it
    S = sum(slice);
    Sf = conv(S, filter, 'same');
    
    % Find peaks
    [P, L] = findpeaks(Sf, 'MinPeakProminence', 2.5);
    for k = 1:length(L)
       pid = size(Pts, 2)+1;
       Pts(:, pid) = [L(k); y+thickness/2];
       W(end+1) = P(k);
    end
end

%figure; imagesc(I); 
%hold on;
%plot(Pts(1, :), Pts(2,:), '.', 'Color', 'red');
%hold off;


Pts(1,:) = Pts(1,:) ./ 1024;
Pts(2,:) = Pts(2,:) ./ 1024;

end

