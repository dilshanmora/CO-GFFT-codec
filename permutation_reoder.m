function P =permutation_reoder(A)
 P=zeros(length(A));

 for i=1:length(A)
    P(i,A(i))=1;
 end

end