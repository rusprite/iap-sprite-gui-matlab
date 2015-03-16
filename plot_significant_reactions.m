function plot_significant_reactions(cp, t, rr, titles_reactions)
    line_types = {'-k',   '-b',  '-r',  '-g',  '-m',  '-c',  '-y', ...
                  '--k', '--b', '--r', '--g', '--m', '--c', '--y', ...
                  '-.k', '-.b', '-.r', '-.g', '-.m', '-.c', '-.y'};

    legend_titles = cell(numel(rr), 1);

    figure;
    i = 1;
    for r=rr
        semilogx(t, cp(r,:), line_types{i}); hold on;
        legend_titles{i} = titles_reactions(r, :);
        i = i + 1;
    end
    
    legend(legend_titles);
end