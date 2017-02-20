function [ Tags ] = findTags( Quads, I )
%Decode tags from quads

Gray = rgb2gray(I);

Tags = {};
for i = 1:length(Quads)
    Quad = Quads{i};
    px1 = Quad.Points(1,:);
    py1 = Quad.Points(2,:);

    px2 = [10, 10, 1, 1];
    py2 = [10, 1, 1, 10];

    H = calculateH(px2, py2, px1, py1);

    tform = projective2d(H');
    ra = imref2d([8, 8],[1, 10],[1,10]);
    Pattern = imwarp(Gray,tform, 'OutputView', ra);
    Pattern = imbinarize(Pattern, 0.5);

    Tag = struct();
    
    % Fix pattern orientation
    if Pattern(3,3)
        Pattern = rot90(rot90(Pattern));
        Tag.Points = Quad.Points(:, [3 4 1 2]);
    elseif Pattern(3,6)
        Pattern = flipud(Pattern);
        Tag.Points = Quad.Points(:, [4 1 2 3]);
    elseif Pattern(6,3)
        Pattern = fliplr(Pattern);
        Tag.Points = Quad.Points(:, [4 1 2 3]);
    elseif Pattern(6,6)
        Tag.Points = Quad.Points;
    else
        fprintf('Bad Tag');
        continue;
    end

    %Decode ID
    tagId = Pattern(4,4) + Pattern(4,5)*2 + Pattern(5,5)*4 + Pattern(5,4)*8;
    Tag.Id = tagId;
    Tag.Pattern = Pattern;
    
    Tags{end+1} = Tag;
end

end

