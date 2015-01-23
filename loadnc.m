function str = loadnc(filename)
    inf = ncinfo(filename);
    inf = inf.Variables;
    
    str = struct;
    
    for i=1:numel(inf)
        name = inf(i).Name;
        data = ncread(filename, name);
        str.(name) = data;
    end
end