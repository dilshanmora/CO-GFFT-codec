function binVal=decimal2binary(a)

if a>0
 binVal = decimalToBinaryVector(a);

else
 binVal=decimalToBinaryVector(abs(a));
 binVal= double(~binVal);
end

end