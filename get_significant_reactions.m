function rr = get_significant_reactions(cp, lev)
% rr = get_significant_reactions(cp)
% cp - contribution percents matrix
% lev - level of significant
% rr - array of singificant reactions indexes
    if nargin < 2
        lev = 0.01;
    end
    rr=[];
    for r=1:size(cp,1)
        m = max(cp(r,:));
        if m > lev
            fprintf('%d\t%f\n',r,m);
            rr=[rr r];
        end
        m2 = min(min(cp(r,:)));
        if m2 < -lev
            fprintf('%d\t%f\n',r,m2);
            rr=[rr r];
        end
    end
end