function [ P ] = gauss3d( I, Mu, Sigma )

[height, width, ~] = size(I);
Pixels = reshape(I, [width*height, 3]);
P = zeros(width*height, 1);
Sinv = inv(Sigma);

for k = 1:length(Pixels)
    x = Pixels(k, :)';

    p = exp((-1/2) * (x-Mu)' * Sinv * (x-Mu));
    
    P(k) = p;
end

P = reshape(P, height, width);

end

