function [I] = doLena(Tags, I, L)
    Lout = zeros(size(I));
    
    for i = 1:length(Tags)
        Tag = Tags{i};

        [width, height, ~] = size(L);
        tform = projective2d(Tag.Homography').invert();
        ref_in = imref2d(size(L), 1/width, 1/height);
        ref_out = imref2d(size(I));
        L_ = imwarp(L,ref_in,tform, 'OutputView', ref_out);
        Lout = Lout+L_;
    end
    
    I_r = I(:,:, 1);
    I_g = I(:,:, 2);
    I_b = I(:,:, 3);
    L_r = Lout(:,:,1);
    L_g = Lout(:,:,2);
    L_b = Lout(:,:,3);
    
    I_r(L_r>0) = 0; I_r = I_r+L_r;
    I_g(L_g>0) = 0; I_g = I_g+L_g;
    I_b(L_b>0) = 0; I_b = I_b+L_b;
    
    I = cat(3, I_r, I_g, I_b);
end
