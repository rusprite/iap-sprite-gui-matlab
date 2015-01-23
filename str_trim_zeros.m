function r = str_trim_zeros(str)
    ii = find(str==0);
    if numel(ii)==0
        r = str;
    else
        r = str(1:ii(1)-1);
    end
end