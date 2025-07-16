function  [block_regen,L,hcode_size_b,hcode_val_b,l_all,coefficients_best,index]= single_block_coding(macro_block,Transform,block_size,Step_size,dictionary,ZRL,EOB,m,lamda,partition,codebook,zero_index,index_order,index_reorder)

    J_min=10000000;
    l_all=0;
    L=0;
    count_read_best=0;
    macro_block_m=macro_block-mean(macro_block);

       

    for i=1:size(Transform,2)+1
         % for i=1:1

        % forward transform 
        if i <= size(Transform,2)
        coefficients=forward_transform(macro_block_m,i,Transform,index_order);
                  
        else          
        coefficients= dct2(reshape(macro_block_m,8,8));
        coefficients=coefficients(:);
        coefficients = coefficients(index_order(:,64));
        end


        % Qunatization and reconstruction for one step size

        % Qunatization
        [coefficients_qua,index]=AC_quantization(coefficients,Step_size);

       
        % Reconstruction 
         if sum(abs(coefficients_qua))==0          
            blocks_regen_current=ones(64,1)*m;
            hcode_size=[EOB];
            hcode_val=[];
            Rate=(length(hcode_size)+length(hcode_val))/length(index(:));            
         else
            [hcode_size ,hcode_val,l]=AC_vector_encoding(index,dictionary,ZRL,EOB);            
            Rate =(length(hcode_size)+length(hcode_val))/length(index(:));

            % backward transform   
            if i <= size(Transform,2)            
            blocks_regen_current=backward_transform(coefficients_qua,i,Transform,index_reorder)+ m;
            else  
                coefficients_qua = coefficients_qua(index_reorder(:,64));
                blocks_regen_current= idct2(reshape(coefficients_qua,8,8))+ m;
                blocks_regen_current=blocks_regen_current(:);
            end
            mse_value=cal_mse(macro_block,blocks_regen_current);
            J=mse_value+Rate*lamda;

            if J_min>J            
                    J_min=J;
                    l_all=l;
                    mse_value_best=mse_value;
                    block_regen=blocks_regen_current;
                    hcode_size_b=hcode_size;
                    hcode_val_b=hcode_val;
                    L=i;
                    coefficients_best=coefficients_qua;
            end
         end     
    end  

    if L==0 
       block_regen=blocks_regen_current;
       hcode_size_b=hcode_size;
       hcode_val_b=hcode_val;
       coefficients_best=coefficients_qua;
    end


end