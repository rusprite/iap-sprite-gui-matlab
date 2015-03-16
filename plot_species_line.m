function plot_species_line(S, t, N, spi, zi, ri)
    figure;
    semilogx(t, N(:,spi,zi, ri));
    xlabel('t, s');
    ylabel('N, cm^{-3}');
    title(sprintf('%s @ z=%dkm', str_trim_zeros(S.titles_species(spi,:)), S.z(zi)/1000));
    grid on;
end