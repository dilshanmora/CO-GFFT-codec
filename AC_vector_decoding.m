function [coeff,hcode_RLZ_val_update]=AC_vector_decoding(h_code,hcode_RLZ_val)
  coeff=zeros(64,1);
  k_r=0;
  k_s=0;

  h_code_runlength=floor(h_code/ 100);
  h_code_size=rem(h_code, 100);

  for i=1:length(h_code_runlength)-1
        k_r=k_r+h_code_runlength(i)+1;
        coeff(k_r)= binary2decimal(hcode_RLZ_val(k_s+1:k_s+h_code_size(i)));
        k_s=k_s+h_code_size(i);
  end

  if mod(k_r,64)==0
      coeff=[coeff;zeros(64,1)];
  end

  if length(coeff)>64
   coeff=[coeff ;zeros(ceil(length(coeff)/64)*64-length(coeff),1)];
   coeff=reshape(coeff,64,length(coeff)/64);
  end


  hcode_RLZ_val_update=hcode_RLZ_val(k_s+1:end);
end