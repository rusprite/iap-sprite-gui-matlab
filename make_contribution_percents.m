function cp = make_contribution_percents(cm)
% cp = make_contribution_percents(cm)
% cm - contribution matrix
% cp - contribution percents matrix
    cp = zeros(size(cm));
    for t=1:size(cm, 2)
        pos_n = find(cm(:, t) > 0);
        neg_n = find(cm(:, t) < 0);
        pos_s = sum(cm(pos_n, t), 1);
        neg_s = sum(cm(neg_n, t), 1);
        cp(pos_n, t) =   cm(pos_n, t) ./ pos_s;
        cp(neg_n, t) = - cm(neg_n, t) ./ neg_s;
    end
end