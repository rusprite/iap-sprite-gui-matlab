function plot_2d(x, y, v)
    % function plot_2d(x, y, v)
    [xx, yy] = meshgrid(x, y);
    h = pcolor(xx, yy, v');
    shading interp
    set(h, 'EdgeColor', 'none');
    set(gca, 'xscale', 'log');
end