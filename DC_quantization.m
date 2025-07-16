function [coefficients_qua,index]=DC_quantization(block_mean,Step_size)
        Step_size;
        partition= [0:Step_size:260];
        codebook = min(partition)-Step_size/2:Step_size:max(partition)+Step_size/2;        
        [N,k]=size(block_mean);
        coefficients_qua=[];
        index=[];
        for i=1:k
            [index_k,Hx_qua_k] = quantiz(block_mean(:,i),partition,codebook);
            coefficients_qua=[coefficients_qua Hx_qua_k'];
            index=[index index_k];
        end

end