function partition= partioning(delta)
co_max=2000;
partition_mid = [-delta/2,delta/2];
partition_side=[3*delta/2:delta:co_max];
partition=[sort(-partition_side),partition_mid,partition_side];
end