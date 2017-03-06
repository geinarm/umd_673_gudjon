function M = isolateBuoy(P)
    P = imfill(P);
    BW = imbinarize(P, 0.5);
    [L, N] = bwlabel(BW);
    Props = regionprops(L, 'Area', 'Perimeter', 'PixelIdxList', 'Centroid');
    
    %figure; imshow(P); title('P');
    %figure; imshow(BW); title('BW');
    
    bestI = 0;
    bestScore = 0;
    for i = 1:N
        props = Props(i);
        circularity = (4 * pi * props.Area) / (props.Perimeter .^ 2);

        if circularity > 0.7 && circularity < Inf && props.Area > 200
            
            %idx = find(BW_);
            w = P(props.PixelIdxList);
            Wsum = sum(w);
            pw = Wsum / props.Area;
            %[py, px] = ind2sub(size(BW), props.PixelIdxList);
            %cx = sum(px.*w) / Wsum;
            %cy = sum(py.*w) / Wsum;
            %cdist = norm([cx;cy] - props.Centroid);
            
            %imshow(BW_); hold on;
            %plot(cx, cy, '.');
            %pause;
            %hold off;
            
            %score = norm([circularity, pw, cdist]);
            score = circularity * pw;
            if score > bestScore && score < Inf
               bestScore = score;
               bestI = i;
            end
        end
    end

    if bestScore < 0.7;
        M = [];
    else
        M = (L==bestI);
    end

end

