% S must be loaded

for i=1:size(S.titles_species,1)
    figure;
    plot(reducto(S.N1(1,i,:,1)), S.z/1000);
    title(S.titles_species(i,:));
    xlabel('cm^{-3}');
    ylabel('z, km');
    grid on;
    print('-dpng', sprintf('N_%s.png', strrep(str_trim_zeros(S.titles_species(i,:)), '/', '_') ) );
    close all
end