function plot_initial_conditions(S)
% usage: plot_initial_conditions(S)
%     or plot_initial_conditions(loadnc('file.nc'))
%     or plot_initial_conditions('file.nc')

    % load calculation results if file name provided as argument
    if ischar(S)
        S = load_sprite_data(S);
    end

    zz = S.z;
    for spi=1:size(S.N1, 2)
        concentration = reducto(S.N1(1, spi, :, 1));
        sp_title = str_trim_zeros(strtrim(S.titles_species(spi, :)));
        fn_prefix = strrep(sp_title, '/', '_');
        fn_prefix = strrep(fn_prefix, '\', '_');
        figure_fn = [fn_prefix '.png'];
        if (numel(find(concentration~=0))>0)
            figure;
            plot(zz, concentration);
            title(sp_title);
            xlabel('z, m');
            ylabel('concentration, cm^{-3}');
            print('-dpng', figure_fn);
        else
            disp(['Skip zero concentration of ' sp_title]);
        end
    end
end