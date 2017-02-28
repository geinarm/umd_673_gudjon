function [ Quads ] = findQuads( Lines )
% Find line segments that form quads

Quads = {};
LineMask = zeros(1, length(Lines));
for i = 1:length(Lines)
    if LineMask(i) > 0
       continue; 
    end
    
    l = Lines{i};
	Quad = struct('Lines', {l});
    LineMask(i) = 1;
    [Quad, LineMask] = findSides(Quad, Lines, LineMask, 2);
    if length(Quad.Lines) == 4
        Quad.Points = findPoints(Quad.Lines);
        Quads{end+1} = Quad; 
    else
        LineMask(i) = 0;
    end
end

end

function [ Quad_, LineMask_ ] = findSides( Quad, Lines, LineMask, k )

    lPrev = Quad.Lines(k-1);
    p = lPrev.End;
    r = lPrev.Length/3;
    dir = lPrev.GradientDirection;
    
    Quad_ = Quad;
    LineMask_ = LineMask;
    
    for i = 1:length(Lines)
        if(LineMask(i) > 0)
           continue; 
        end
        
        LineMask_ = LineMask;
        Quad_ = Quad;
        l = Lines{i};
        da = angleDistance(dir, l.GradientDirection);
        
        if da < 10 || da > 150
           continue; 
        end
        
        dist = norm(p-l.Start);
        if dist > r
           continue; 
        end
        
        Quad_.Lines(k) = l;
        LineMask_(i) = LineMask_(i)+1;
        if k == 4
            return;
        else
            [Quad_, LineMask_] = findSides(Quad_, Lines, LineMask_, k+1);
            if length(Quad_.Lines) == 4
               return; 
            end
        end
    end

end

function [Points] = findPoints(Lines)

    Points = zeros(2, 4);
    for i = 1:4
        a1 = Lines(i).Intercept;
        a2 = Lines(mod(i,4)+1).Intercept;
        b1 = Lines(i).Slope;
        b2 = Lines(mod(i,4)+1).Slope;
        
        d = b1 - b2;
        x = (a2 - a1)/d;
        y = (b1*a2 - b2*a1)/d;
        Points(:, i) = [x;y];
    end
end
