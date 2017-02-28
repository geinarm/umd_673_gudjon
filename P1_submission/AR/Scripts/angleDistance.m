function [ d ] = angleDistance( a1, a2 )
% returns the shortest distance in degrees from a1 to a2
% positive value for counter-clockwise direction, 
% negative for clockwise

d = a2 - a1;
if d < -180
    d = d+360;
elseif d > 180
   d = d-360; 
end

end

