function x=backward_transform(x1,n,Transforms,index_reorder)
    x1 = x1(index_reorder(:,n));
    a=Transforms{n};
    x=x1;
    for i=size(a,1):-1:1
        x_i=a(i,5);
        y_i=a(i,6);
        ii=x(x_i);
        jj=x(y_i);

        x(x_i)=[a(i,1) a(i,3)]*[ii; jj]; 
        x(y_i)=[a(i,2) a(i,4)]*[ii; jj]; 
    end
end