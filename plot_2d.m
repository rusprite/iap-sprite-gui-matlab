function plot_2d(x, y, v)
    % function plot_2d(x, y, v)
    [xx, yy] = meshgrid(x, y);
    
    % h = pcolor(xx, yy, v');
    
    h = surf(xx, yy, v');
    view(0,90);
    
    shading interp
    
    set(h, 'EdgeColor', 'none');
    set(gca, 'xscale', 'log');
    % set(gca, 'zscale', 'log');
end