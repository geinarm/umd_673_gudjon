function M = isolateBuoy(P)
    P = imfill(P);
    se = strel('disk', 3);
    P = imopen(P, se);
    BW = imbinarize(P, 0.15);
    [L, N] = bwlabel(BW);
    Props = regionprops(L, 'Area', 'Perimeter', 'PixelIdxList', 'Centroid');
    
    %imshow(P); title('P');
    %imshow(BW); title('BW');
    
    bestI = 0;
    bestScore = 0;
    for i = 1:N
        props = Props(i);
        circularity = (4 * pi * props.Area) / (props.Perimeter .^ 2);

        if props.Area > 200
            w = P(props.PixelIdxList);
            Wsum = sum(w);
            pw = Wsum / props.Area;

            score = circularity * pw;
            if score > bestScore && score < Inf
               bestScore = score;
               bestI = i;
            end
        end
    end

    if bestScore < 0.2
        M = [];
    else
        M = (L==bestI);
    end

end

