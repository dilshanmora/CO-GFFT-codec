function P=PSNR_cal(image_blocks_original,image_blocks_regen)
        [x,y]=size(image_blocks_original);
        n=(x*y);
        image_blocks_regen=round(image_blocks_regen);
        image_blocks_original=round(image_blocks_original);
        
        D=sum(sum((image_blocks_original-image_blocks_regen).^2))/(n);
        P=20*log10(255)-10*log10(D);

end