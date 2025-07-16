function [image_data,block_x,block_y,image_x,image_y]=image_arrange_block_transform_block(image)
    block_size=8;
    [image_x,image_y]=size(image);
    block_x=ceil(image_x/block_size);
    block_y=ceil(image_y/block_size);
    
    I=zeros(block_x*8,block_y*8);
    I(1:image_x,1:image_y)=image+I(1:image_x,1:image_y);


    image=I;
    image_data=[];
    for i=0:block_x-1    
        for j=0:block_y-1
            image_block=image(block_size*i+1:block_size*i+block_size,block_size*j+1:block_size*j+block_size);  
            image_data=[image_data image_block(:)];            
        end
    end
    
end