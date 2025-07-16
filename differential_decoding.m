function [block_mean,Step_size_mean]=differential_decoding(hcode_size ,hcode_val)
dict=DC_componet_dic();
size_vec_decode = huffmandeco(hcode_size,dict);

k=1;
l=size_vec_decode(1);
Step_size_mean=binaryVectorToDecimal(hcode_val(k:k+l-1));

k=k+l;
val_decode=[];
for i=2:length(size_vec_decode)
    l=size_vec_decode(i);
    if l==0
        val_decode=[val_decode; 0];
        continue
    else
        val_decode=[val_decode; binary2decimal(hcode_val(k:k+l-1))];
    k=k+l;
    end
end
block_mean=(diffdecodevec(val_decode)*Step_size_mean)-Step_size_mean/2;
end