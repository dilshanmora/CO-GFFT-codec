function [I_regen_image]=Decode_CO_GFFT(coded_file,output_file)
    % Inputs of Decode_CO_GFFT(coded_file,output_file)
    % coded_file --> .bin file produced by  Encode_CO_GFFT() 	
    % output_file -->  decoded image file in .tif format (.tif extension will be added by the function) 	
    % example:I=Decode_CO_GFFT("Binary files\chess_board.bin","chess_board" );
    
    fprintf("CO_GFFT deccoder: decoding in progress...\n")
    %% read bin file
    fid = fopen(coded_file, 'r');
    h_code = fread(fid, 'uint8')';
    % Convert bytes to 8-bit binary strings
    bitStrings = dec2bin(h_code, 8);    
    % Convert binary strings to numeric bit array
    bits = bitStrings' - '0';        % transpose to column-wise bits
    h_code = bits(:)';
    fclose(fid);

    %% transform codebook
    Transform=load_mat("Transforms\Transforms.mat");
    index_reorder=load_mat("Transforms\index_reorder.mat");

    %% seperate the binary array
    sequence = [1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1];
    L=length(sequence);
    sequenceString = strrep(num2str(sequence), ' ', '');
    bitArrayString = strrep(num2str(h_code), ' ', '');
    padding_bits = bin2dec(bitArrayString(1:8));
    bitArrayString=bitArrayString(9:end-padding_bits);


    indices = strfind(bitArrayString, sequenceString);
    Step_size_binary = bin2dec(bitArrayString(1:10));
    block_x_binary = bin2dec(bitArrayString(11:22));
    block_y_binary = bin2dec(bitArrayString(23:34));
    x_binary = bin2dec(bitArrayString(35:46));
    y_binary = bin2dec(bitArrayString(47:58));

    hcode_RLZ_size = bitArrayString(59:indices(1)-1)- '0';
    hcode_RLZ_val = bitArrayString(indices(1)+L:indices(2)-1)- '0';
    hcode_size_mean = bitArrayString(indices(2)+L:indices(3)-1)- '0';
    hcode_val_mean = bitArrayString(indices(3)+L:indices(4)-1)- '0';
    label_code = bitArrayString(indices(4)+L:end)- '0';


    %% Mean decode
    [block_mean_qua,Step_size_mean_decode]=differential_decoding(hcode_size_mean,hcode_val_mean);
   
    %% Transform index decode
    labels=Label_decoding(label_code);


    %% AC decoding
    % AC dictionary
    dictionary=load_mat("Table\AC_Tables/dictionary_AC.mat");

    % hufman decode the RL-size vector
    hcode_RLZ_size_vec = huffmandeco(hcode_RLZ_size,dictionary);
    % Finding EOB points
    EOB_idx = [0,find(hcode_RLZ_size_vec == 0)];
    
    I_regen=[];
    k=1;
    for i=2:length(EOB_idx) 
      if  EOB_idx(i)-EOB_idx(i-1)==1
        I_regen=[I_regen,zeros(64,1)]; 
      else
          H_T_code=hcode_RLZ_size_vec(EOB_idx(i-1)+1:EOB_idx(i));
          [coeff,hcode_RLZ_val]=AC_vector_decoding(H_T_code,hcode_RLZ_val);
             for j=1:size(coeff,2)
                if sum(abs(coeff(:,j)))==0                  
                    I_regen=[I_regen,zeros(64,1)]; 
                else
                     if labels(k)<64
                        coefficients=backward_transform(coeff(:,j)*Step_size_binary,labels(k),Transform,index_reorder);
                    else          
                         coefficients=coeff(:,j)*Step_size_binary;
                         coefficients = coefficients(index_reorder(:,64));
                         coefficients=idct2(reshape(coefficients,8,8));            
                         coefficients=coefficients(:);

                     end
                    k=k+1; 
                    I_regen=[I_regen,coefficients];
                end
             end


      end

    end
    

    if length(hcode_RLZ_val)>0
          H_T_code=hcode_RLZ_size_vec(EOB_idx(i)+1:end);
          [coeff,hcode_RLZ_val]=AC_vector_decoding(H_T_code,hcode_RLZ_val);
             for j=1:size(coeff,2)
                if sum(abs(coeff(:,j)))==0                  
                    I_regen=[I_regen,zeros(64,1)]; 
                else
                     if labels(k)<64
                        coefficients=backward_transform(coeff(:,j)*Step_size_binary,labels(k),Transform,index_reorder);
                    else          
                         coefficients=coeff(:,j)*Step_size_binary;
                         coefficients = coefficients(index_reorder(:,64));
                         coefficients=idct2(reshape(coefficients,8,8));            
                         coefficients=coefficients(:);

                     end
                    k=k+1; 
                    I_regen=[I_regen,coefficients];
                end
             end
    end

    %% add means of blocks and regenaration the image
    I_regen=I_regen+block_mean_qua';

  
    I_regen_image=uint8(image_rearrange_block_transform_block(I_regen,8,block_x_binary,block_y_binary));
    I_regen_image=I_regen_image(1:x_binary,1:y_binary);  
    imwrite(I_regen_image,output_file+".tif");

    fprintf("Completed.\n")
end