function I_Regen=image_rearrange_block_transform_block(image_blocks_regen,block_size,block_x,block_y)
    M_k=1;
    I_Regen=[];
    %image prepare
    for i=0:block_x-1  
        I_Regen_j=[];
        for j=0:block_y-1
            image_block=image_blocks_regen(:,M_k);                      
            I_Regen_j=[I_Regen_j,reshape(image_block,block_size,block_size)]; 
            M_k=M_k+1;
        end

      I_Regen=[I_Regen;I_Regen_j];
    end
I_Regen=round(I_Regen);

end