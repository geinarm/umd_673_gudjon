
function Buoys = detectBuoys(I, Model)

I = im2double(I);
I = rgb2lab(I);

%Red
P_red = gauss3d(I, Model.RedMean, Model.RedCov);
%Yellow
P_yellow = gauss3d(I, Model.YellowMean, Model.YellowCov);
%Green
P_green = gauss3d(I, Model.GreenMean, Model.GreenCov);

Buoys = {};
B_red = isolateBuoy(P_red);
B_yellow = isolateBuoy(P_yellow);
B_green = isolateBuoy(P_green);

if ~isempty(B_red)
    Buoys{end+1} = struct('Mask', B_red, 'Color', [1 0 0]);
end
if ~isempty(B_yellow)
    Buoys{end+1} = struct('Mask', B_yellow, 'Color', [1 1 0]);
end
if ~isempty(B_green)
    Buoys{end+1} = struct('Mask', B_green, 'Color', [0 1 0]);
end

end