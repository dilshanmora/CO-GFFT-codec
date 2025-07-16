function labels=Label_decoding(label_code)
   Dict=load("Table\Transform_Index\Transform_Index.mat");
    value = struct2cell(Dict(1));
    dict=value{1,1};
    labels = huffmandeco(label_code,dict);

end