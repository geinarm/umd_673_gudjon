function [ Lines ] = FindLines( I )
%Find straight lines

Gray = rgb2gray(I);
Gray = imgaussfilt(Gray, 0.8);
[height, width] = size(Gray);

[Gx, Gy] = imgradientxy(Gray);
[Gmag, Gdir] = imgradient(Gx, Gy);

BW = imbinarize(Gmag, 0.7);
Segments = zeros(size(BW));

EdgeIdx = find(BW);
segmentId = 1;
for i = 1:length(EdgeIdx)
    id = EdgeIdx(i);
    if ~BW(id)
        continue; 
    end
    
    pixelCount = 0;
	Frontier = {id};
	dir = Gdir(id);

	while ~isempty(Frontier)
        id = Frontier{1}; 
        Frontier(1) = [];
        
        Neighbors = {id-1, id+height, id+1, id-height};
        Segments(id) = segmentId;
        pixelCount = pixelCount+1;
       
        for k = 1:4
            nid = Neighbors{k};
            if nid < 1
              continue;
            end
            if nid > width*height
              continue;
            end
            if ~BW(nid)
                continue; 
            end
            if abs(Gdir(id) - Gdir(nid)) > 10.0
                continue;
            end
            
            Frontier{end+1} = nid;
            BW(nid) = 0;
        end
	end
    
    if(pixelCount < 30)
       Segments(Segments==segmentId) = 0; 
    else
        segmentId = segmentId+1;
    end
end

numSegments = segmentId-1;
Lines = cell(numSegments, 1);
for i = 1:numSegments
   Idx = find(Segments==i);
   [y, x] = ind2sub(size(Segments), Idx);
   dir = mean(Gdir(Idx));
   
   minX = min(x);
   maxX = max(x);
   
   X = [ones(length(x), 1), x];
   b = X\y;
   
   if(dir>0 && dir<180)
        p1 = [maxX, b(1)+b(2)*maxX];
        p2 = [minX, b(1)+b(2)*minX];
   else
        p1 = [minX, b(1)+b(2)*minX];
        p2 = [maxX, b(1)+b(2)*maxX];
   end
   
   L = struct('Start', p1,...
              'End', p2,...
              'Length', norm(p1-p2),...
              'Slope', b(2),...
              'Intercept', b(1),...
              'GradientDirection', dir);
   Lines{i} = L;
end

end

