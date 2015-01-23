function r = reducto(v)
    % r = reducto(v)
    % reshame multidimensional matrix reducing dimensions with size 1
    s = size(v);
    if numel(s(s>1))==1
        r = reshape(v, [s(s>1), 1]);
    else
        r = reshape(v, s(s>1));
    end
end

