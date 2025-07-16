function Encode_CO_GFFT(input_image_path,coded_file,QP)
    % Input of Enocde_CO_GFFT(input_image_path,coded_file,QP)
    % input_image_path --> Input image file in .tif format
    % coded_file       --> Name of the binary output file (.bin extension will be added by the function)
    % QP               --> Quality parameter. Must be a value in the [0,100] interval (100 gives the best quality)
    %
    % example:Encode_CO_GFFT("Images\chess_board.tif","Binary files\chess_board" , 50)
    %
    % Output- a compressed binary file  
    
    %% step size conversion check the QP range
    if QP<50 & QP>=0
        Step_size=round(300-QP*4);
    elseif QP<=100 & QP>=50
        Step_size=round(190-QP*1.8);
    else
        fprintf("Error: QP is to be in rage 0-100.\n")
        hcode = [];  
        return;
    end

    %% read image    
    image = double(imread(input_image_path));
    block_size=8;
    if size(image,3)>1
        fprintf("Error: Input greyscal image.\n")
        hcode = [];  
        return;
    end



    fprintf("CO_GFFT encoder: coding in progress...\n")
    %% image data prepare
    [image_data,block_x,block_y,image_x,image_y]=image_arrange_block_transform_block(image);



    %% quantization paramter
    lamda=0.1155*Step_size*Step_size;
    partition= partioning(Step_size);
    codebook = min(partition)-Step_size/2:Step_size:max(partition)+Step_size/2;
    zero_index=find(codebook==0)-1;
    
    %% DC coding
    Step_size_mean=ceil(Step_size/50);
    block_mean_vector=mean(image_data);
    [hcode_size_mean ,hcode_val_mean,hcode,size_vec_encode]=differential_encoding(block_mean_vector,Step_size_mean);
    [block_mean_qua,Step_size_mean_decode]=differential_decoding(hcode_size_mean ,hcode_val_mean);
   

    %% AC dictionary
    dictionary=load_mat("Table\AC_Tables/dictionary_AC.mat");
    ZRL=cell2mat(dictionary(107,2));
    EOB=cell2mat(dictionary(1,2));
    dictionary(107,:)=[];
    dictionary(1,:)=[];

    %% transform codebook

    % Givens transform
    Transform=load_mat("Transforms\Transforms.mat");
    index_order=load_mat("Transforms\index_order.mat");
    index_reorder=load_mat("Transforms\index_reorder.mat");

    %% selection and AC coding
    % regen image 
    image_blocks_regen=[];


    % transform Index
    labels=[];

    % codewords
    hcode_RLZ_size=[];
    hcode_RLZ_val=[];

    l_all=0;
    coefficients_best_all=[];

    
    for i=1:size(image_data,2)
           
            % fprintf("image block %d\n",i)
            Transform_block=image_data(:,i);
            [Transform_block_regen,L,hcode_size_b,hcode_val_b,l,coefficients_best]= single_block_coding(Transform_block,Transform,block_size,Step_size,dictionary,ZRL,EOB,block_mean_qua(i),lamda,partition,codebook,zero_index,index_order,index_reorder);

            l_all=l_all+l;
            coefficients_best_all=[coefficients_best_all ,coefficients_best];
            % coding vectors
            image_blocks_regen=[image_blocks_regen,Transform_block_regen];
            labels=[labels;L];    
            hcode_RLZ_size=[hcode_RLZ_size,hcode_size_b];
            hcode_RLZ_val=[hcode_RLZ_val,hcode_val_b];
           
    end


    %% transform index coding
    if size(Transform,2)>1
        label_huffman=labels(labels>0);               
        label_code=Label_encoding(label_huffman);
    else
        label_huffman=labels(labels>0);                
        label_code=[];
    end

    %% header
    mid_sequence = [1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 1 1 1 1 1];

    Step_size_binary = dec2bin(Step_size, 10)- '0';
    block_x_binary = dec2bin(block_x, 12)- '0';
    block_y_binary = dec2bin(block_y, 12)- '0';
    x_binary = dec2bin(image_x, 12)- '0';
    y_binary = dec2bin(image_y, 12)- '0';

    %% Coded Vector
    hcode=[Step_size_binary,block_x_binary,block_y_binary,x_binary,y_binary,hcode_RLZ_size,mid_sequence,hcode_RLZ_val,mid_sequence,hcode_size_mean,mid_sequence,hcode_val_mean,mid_sequence,label_code']; 

    %% byte packing
    % Pad with zeros if not divisible by 8
    pad_len = mod(-numel(hcode), 8);       % how many zeros to add (0–7)
    pad_len_binary = dec2bin(pad_len, 8)- '0';
    hcode_padded = [pad_len_binary,hcode, zeros(1, pad_len)];
    % Reshape to 8-bit chunks (rows)
    bitGroups = uint8(reshape(hcode_padded, 8, []).');
    
    % Convert each 8-bit row to a byte (uint8)
    hcode_bytes = uint8(sum(bitGroups .* uint8(2.^(7:-1:0)), 2));
     
    fid = fopen(coded_file+".bin", 'w');  
    fwrite(fid, hcode_bytes, 'uint8');                 
    fclose(fid); 
    hcode =strrep(num2str(hcode_padded), ' ', '');
                              
    fprintf("Completed.\n")
end