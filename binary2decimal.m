function a=binary2decimal(binVal)


 a =  binaryVectorToDecimal(binVal);

 if ceil(log2(0.1+abs(a)))<length(binVal)
    a=-binaryVectorToDecimal(ones(1,length(binVal)))+a;
 end

end