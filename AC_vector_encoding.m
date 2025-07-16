function [hcode_RLZ_size_v,hcode_val_v,l]=AC_vector_encoding(x,dict,ZRL,EOB)

D_k=100;
l=0;
hcode_RLZ_size_v=[];
hcode_val_v=[];
k=0;
if sum(abs(x))==0
hcode_RLZ_size_v=[EOB]; 
else    
    for i=1:length(x)

        
                if x(i)==0
                    if sum(abs(x(i:end)))==0
                        hcode_RLZ_size_v=[hcode_RLZ_size_v EOB];
                     break;
                    end
                    if i==length(x)
                        hcode_RLZ_size_v=[hcode_RLZ_size_v EOB];
                        break;
                    end
                    k=k+1;
                   
                    if k==16
                        hcode_RLZ_size_v=[hcode_RLZ_size_v ZRL];

                        k=0;
                    else
                        continue
                    end
        
                else
                    value=decimal2binary(x(i));
                    value_length=length(value); 
                                                                                           
                    if value_length>8
                        l=l+1;
                        k=k+1;
                    else
                        hcode_val_v=[hcode_val_v decimal2binary(x(i))];
                        hcode_RLZ_size_v=[hcode_RLZ_size_v dict{k*7+value_length,2}];  
                        % hcode_RLZ_size_v=[hcode_RLZ_size_v dict{find(cell2mat(dict(:,1))==(k*D_k+value_length)),2}];
                        k=0; 
                    end

                end
        

    end

end


end