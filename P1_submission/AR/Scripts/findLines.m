function [ Lines ] = findLines( I )
%Find straight lines

Gray = rgb2gray(I);
Gray = imgaussfilt(Gray, 0.8);
[height, width] = size(Gray);

[Gx, Gy] = imgradientxy(Gray);
[Gmag, Gdir] = imgradient(Gx, Gy);

BW = imbinarize(Gmag, 0.7);
Segments = zeros(size(BW));
%figure; imshow(BW);

EdgeIdx = find(BW);
segmentId = 1;
for i = 1:length(EdgeIdx)
    id = EdgeIdx(i);
    if ~BW(id)
        continue; 
    end
    
    pixelCount = 0;
	Frontier = {id};

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
            if abs(Gdir(id) - Gdir(nid)) > 9.0
                continue;
            end
            
            Frontier{end+1} = nid;
            BW(nid) = 0;
        end
	end
    
    if(pixelCount < width*0.05)
       Segments(Segments==segmentId) = 0; 
    else
        segmentId = segmentId+1;
    end
end

%figure; imagesc(Segments);

numSegments = segmentId-1;
Lines = {};
for i = 1:numSegments
   Idx = find(Segments==i);
   [y, x] = ind2sub(size(Segments), Idx);
   dir = mean(Gdir(Idx));
   
   minX = min(x);
   maxX = max(x);
   minY = min(y);
   maxY = max(y);
   
   M = [x, y];
   C = cov(M);
   [V, D] = eig(C);
   E = diag(D);
   if E(end-1) > 1.5 % reject lines that are not straight enough
      continue; 
   end
   
   v = (V(:, end));
   v = v./norm(v);
   p = mean(M);
   s = v(2)/v(1);
   s_ = v(1)/v(2);
   b = [p(2) - p(1)*s, s];
   b_ = [p(1) - p(2)*s_, s_];
   
   rad = deg2rad(dir);
   dv = [cos(rad), sin(-rad)];

   if s > 1 || s < -1
        p1 = [b_(1)+b_(2)*minY, minY];
        p2 = [b_(1)+b_(2)*maxY, maxY];
   else
        p1 = [minX, b(1)+b(2)*minX];
        p2 = [maxX, b(1)+b(2)*maxX];
   end
   
   v = (p2-p1);
   z = cross([v, 0], [dv, 0]);
   if z(3) < 0
        temp = p1;
        p1 = p2;
        p2 = temp;
   end
   
   L = struct('Start', p1,...
              'End', p2,...
              'Length', norm(p1-p2),...
              'Slope', b(2),...
              'Intercept', b(1),...
              'GradientDirection', dir,...
              'Normal', dv,...
              'Center', p);
   Lines{end+1} = L;
end

end

