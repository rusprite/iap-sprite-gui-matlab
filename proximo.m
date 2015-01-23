function [nv, i] = proximo(vec, val)
    % function [nv, i] = nearest_value(vec, val)
    % returns nearest value nv for val in vector vec
    % i is index of nearest value
    i = interp1(vec, 1:numel(vec), val, 'nearest');
    nv = vec(i);
end
