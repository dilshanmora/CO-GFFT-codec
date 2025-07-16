function x=forward_transform(x1,n,Transforms,index_order)
 
    x=x1;

    a=Transforms{n};


    for i=1:size(a,1)

        x_i=a(i,5);
        y_i=a(i,6);
        ii=x(x_i);
        jj=x(y_i);

        x(x_i)=[a(i,1) a(i,2)]*[ii; jj]; 
        x(y_i)=[a(i,3) a(i,4)]*[ii; jj]; 
    end

    % x=P*x;
    x = x(index_order(:,n));
end