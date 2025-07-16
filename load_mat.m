function l=load_mat(f)
  l=   load(f);
  value = struct2cell(l(1));
  l=value{1,1};

end