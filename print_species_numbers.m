for i=1:size(S.titles_species,1)
    fprintf('%3d\t%s\n', i, str_trim_zeros(S.titles_species(i,:)));
end