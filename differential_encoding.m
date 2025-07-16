function [hcode_size ,hcode_val,hcode,size_vec]=differential_encoding(block_mean,Step_size_mean)

[block_mean_qua,index]=DC_quantization(block_mean,Step_size_mean);
h_index=diffencodevec(index);
dict=DC_componet_dic();

hcode=[cell2mat(dict(ceil(log2(0.1+abs(Step_size_mean)))+1,2)) decimal2binary(Step_size_mean)];
 for i=1:length(h_index)
     if h_index(i)==0
        hcode=[hcode cell2mat(dict(1,2)) ];         
     else             
        hcode=[hcode cell2mat(dict(ceil(log2(0.1+abs(h_index(i))))+1,2)) decimal2binary(h_index(i))];
     end
 end




 hcode_size=[cell2mat(dict(ceil(log2(0.1+abs(Step_size_mean)))+1,2))];
 size_vec=[ceil(log2(0.1+abs(Step_size_mean)))];
 hcode_val=[decimal2binary(Step_size_mean)];

 for i=1:length(h_index)

        if h_index(i)==0
            hcode_size=[hcode_size cell2mat(dict(1,2))];  
            size_vec=[size_vec ;0];
         else             
           hcode_size=[hcode_size cell2mat(dict(ceil(log2(0.1+abs(h_index(i))))+1,2))];
           size_vec=[size_vec ;ceil(log2(0.1+abs(h_index(i))))];
           hcode_val=[hcode_val decimal2binary(h_index(i))];
         end
      
 end


end