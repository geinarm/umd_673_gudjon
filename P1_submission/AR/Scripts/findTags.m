close all;

%I = imread('../Data/T01.png');
I = imread('../Data/singleTag1.png');
%I = imread('../Data/multipleTags3.png');
I = im2double(I);
[height, width, ~] = size(I);

Lines = FindLines(I);

tic
Quads = {};
for i = 1:length(Lines)
    l = Lines{i};
	Quad = struct('Lines', {l});
    
    Quad = findQuad(Quad, Lines, 2);
    if length(Quad.Lines) == 4
       Quads{end+1} = Quad; 
    end
end
toc

length(Quads)

figure
imshow(I); hold on;
for i = 5
    Quad = Quads{i};
    for k = 1:4
        l = Quad.Lines(k);
        plot([l.Start(1), l.End(1)], [l.Start(2), l.End(2)], 'LineWidth', 3);
    end
end
hold off;


function [ Quad_ ] = findQuad( Quad, Lines, k )

    p = Quad.Lines(k-1).End;
    r = Quad.Lines(k-1).Length/4;
    
    for i = 1:length(Lines)
        Quad_ = Quad;
        l = Lines{i};
        dist = norm(p-l.Start);
        if dist > r
           continue; 
        end
        Quad_.Lines(k) = l;
        if k == 4
            return;
        else
            Quad_ = findQuad(Quad_, Lines, k+1);
            if length(Quad_.Lines) == 4
               return; 
            end
        end
    end

end