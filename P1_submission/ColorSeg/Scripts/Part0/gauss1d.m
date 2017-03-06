function P = gauss1d(I, Mu, Sigma)

[height, width, d] = size(I);
if d > 1
   error('1D gaussian expects a grayscale image'); 
end

P = zeros(height, width);
Pixels = reshape(I, [width*height, 1]);

for k = 1:length(Pixels)
    x = Pixels(k);

    p = exp((-(x-Mu)^2) / (2*Sigma^2) );
    [i,j] = ind2sub([height, width], k);
    P(i,j) = p;
end

end