function label_code=Label_encoding(labels)
    Dict=load("Table\Transform_Index\Transform_Index.mat");
    value = struct2cell(Dict(1));
    dict=value{1,1};
    label_code = huffmanenco(labels,dict);

end