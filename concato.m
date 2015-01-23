function [t, S] = concato(t1, N11, t2, N21)
    % function [t, S] = concato(t1, N1, t2, N2)
    % Concatenates (t1 and t2) to t, (N1, N2) to S
    % First dimension of N1  and N2 must be time,
    % if not, use transpose.
    
    N1 = reducto(N11);
    N2 = reducto(N21);
    
    if numel(size(N1))<2 || numel(size(N2))<2
        error('concato:wrong_dimensions', 'N1 and N2 must have 2 or more dimensions');
    end
    
    if numel(size(N1))~=numel(size(N2))
        error('concato:wrong_dimensions', 'N1 and N2 must have same dimensions number');
    end
    if size(N1,2)~=size(N2,2)
        error('concato:wrong_dimensions', 'N1 and N2 must be same size in second dimension');
    end
    t = concatenate_t(t1, t2);

    size(N1)
    size(N2)
    
    if numel(size(N1))==2
        S = cat(1, N1((1:end-1), :), N2);
    elseif numel(size(N1))==3
        S = cat(1, N1((1:end-1), :, :), N2);
    elseif numel(size(N1))==4
        S = cat(1, N1((1:end-1), :, :, :), N2);
    end
end

function t = concatenate_t(t1, t2)
    t=[t1(1:(end-1)); t2+t1(end)];
end