function [ CurvePoints, Curves ] = findLanes( Points, Weights, pth )

Curves = {};
CurvePoints = {};
PointIdx = 1:length(Points);
lastLength = 0;

while ~isempty(Points)
    [~, id] = max(Weights);
    Pts_ = Points;
    Pt = Pts_(:, id);
    num_pts = 0;
    if(lastLength == length(Points))
       break; 
    end
    lastLength = length(Points);
    for i = 1:12
        KD = KDTreeSearcher(Pts_');
        idx_set = rangesearch(KD, Pt', i*0.1);
        Idx = idx_set{1};

        if length(Idx) < 3
            Points(:, id) = [];
            Weights(id) = [];
            PointIdx(id) = [];
            break;
        end

        X = Pts_(:, Idx); %Selected points 
        pointRange = range(X, 2);
        if pointRange(1)*1.25 > pointRange(2)
            Points(:, id) = [];
            Weights(id) = [];
            PointIdx(id) = [];
            break;
        end
        
        P = polyfit(X(2, :), X(1, :), 2);

        Idx_onCurve = pointsOnCurve(P, Points, 0.025);
        Pts_ = Points(:, Idx_onCurve);
        
        if(length(X) == num_pts)
            score = sum(Weights(Idx_onCurve))/length(Idx_onCurve);
            xcross = abs(0.5 - polyval(P, 1));
            if (num_pts > pth) && score > 12 && (xcross < 0.7)% && pointRange(2) > 0.5
                Curves{end+1} = P;
                CurvePoints{end+1} = X;
                Points(:, Idx_onCurve) = [];
                Weights(Idx_onCurve) = [];
                PointIdx(Idx_onCurve) = [];
            else
                Points(:, id) = [];
                Weights(id) = [];
            end
            break; 
        end
        num_pts = length(X);
    end
    
    if length(Points) < pth
       break; 
    end
end

end

function [Idx] = pointsOnCurve(P, Pts, r)
    KD = KDTreeSearcher(Pts');

    y = 0:0.01:1;
    x = polyval(P,y);

    idx_set = rangesearch(KD, [x', y'], r);
    
    Idx = unique(cat(2, idx_set{:})); 

end
