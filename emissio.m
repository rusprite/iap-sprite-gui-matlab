function [em_t, em_v] = emissio(t, v)
    % function [em_t, em_v] = emissio(t, v)
    % calculates derivalive of 'v' by first dimension
    dt = diff(t);

    dv = diff(v,1,1);
    dt = kron(dt, ones(1,size(v,2)));

    em_v = (dv./dt);
    em_t = t(1:end-1);
end
