function D =cal_mse(image_blocks_original,image_blocks_regen)
        [x,y]=size(image_blocks_original);
        n=(x*y);
        image_blocks_regen=round(image_blocks_regen);
        image_blocks_original=round(image_blocks_original);
        
        D=sum(sum((image_blocks_original-image_blocks_regen).^2))/(n);
        

end