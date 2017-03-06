function [ Tags ] = findTags( Quads, I )
%Decode tags from quads

Gray = rgb2gray(I);

Tags = {};
for i = 1:length(Quads)
    Quad = Quads{i};
    px1 = Quad.Points(1,:);
    py1 = Quad.Points(2,:);

    px2 = [1, 1, 0, 0];
    py2 = [1, 0, 0, 1];

    try
        H = calculateH(px2, py2, px1, py1);
    catch err
        fprintf('Faild homography\n');
        continue;
    end
    
    tform = projective2d(H');
    ra = imref2d([32, 32],[0, 1],[0, 1]);
    Pattern = imwarp(Gray,tform, 'OutputView', ra);
    Pattern = imbinarize(Pattern, 0.9);
    % trim white pixels from the edges of the pattern
    Pattern([1 2 31 32], :) = 0;
    Pattern(:, [1 2 31 32]) = 0;

    %Find the most likely anker corner
    [ci, cv] = pattOrientation(Pattern);
    if (cv < 2)
        fprintf('Bad Tag\n');
        continue;
    end
    
    Tag = struct();
    % Fix pattern orientation
    if ci == 1
        Pattern = rot90(Pattern, 2);
        Tag.Points = Quad.Points(:, [3 4 1 2]);
        %fprintf('Rotate 180\n');
    elseif ci == 2
        Pattern = rot90(Pattern, 3);
        Tag.Points = Quad.Points(:, [2 3 4 1]);
        %fprintf('Rotate 270\n');
    elseif ci == 3
        Tag.Points = Quad.Points;
        %fprintf('Rotate 0\n');
    elseif ci == 4
        Pattern = rot90(Pattern);
        Tag.Points = Quad.Points(:, [4 1 2 3]);
        %fprintf('Rotate 90\n');
    else
        fprintf('Bad Tag\n');
        continue;
    end
    
    %Correct homography to match orientation
    H = calculateH(px2, py2, Tag.Points(1,:), Tag.Points(2,:));
    %H = H ./ H(3,3);
    
    %Decode ID
    b1 = sum(sum(Pattern(12:15, 12:15)))/16 >= 0.75;
    b2 = sum(sum(Pattern(12:15, 17:20)))/16 >= 0.75;
    b4 = sum(sum(Pattern(17:20, 17:20)))/16 >= 0.75;
    b8 = sum(sum(Pattern(17:20, 12:15)))/16 >= 0.75;
    tagId = b1 + b2*2 + b4*4 + b8*8;
    
    Tag.Id = tagId;
    Tag.Pattern = Pattern;
    Tag.Homography = H;
    
    Tags{end+1} = Tag;
end

end

function [ci, cv] = pattOrientation(P)
    qi1 = P(1:12, 1:12);
    qi2 = P(1:12, 21:32);
    qi3 = P(21:32, 21:32);
    qi4 = P(21:32, 1:12);
    
    qi = [sum(qi1(:)), sum(qi2(:)), sum(qi3(:)), sum(qi4(:))];
    [cv, ci] = max(qi);
end