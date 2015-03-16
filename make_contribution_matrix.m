function cm = make_contribution_matrix(rates, N, rc, sp_n, zi, ri)
% cm = make_contribution_matrix(rates, N, rc, sp_n, zi, ri)
% rates - rates with size (tN, reactionsN, zN, rN)
% N - concentrations with size (tN, speciesN, zN, rN)
% rc - reaction components matrix
% sp_n - number of specie
% zi - index of z
% ri - index of r
% cm - contribution matrix
    tN = size(N, 1);
    reactions = size(rc, 1);
    cm = zeros(reactions, tN);
    
    for i = 1:tN
        for j = 1:reactions
            n1 = rc(j, 1);
            n2 = rc(j, 2);
            left = rc(j, 3:(3+n1-1));
            right = rc(j, (3+n1):(3+n1+n2-1));
            k = -numel(find(left==sp_n)) + numel(find(right==sp_n));
            cm(j, i) = k*rates(i, j, zi, ri)*prod(N(i, left, zi, ri));
        end
    end
end