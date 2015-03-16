% including util functions
util

z = 70000;
zi = get_z_index(z);
ri = 1;
spi = 18; % electron
level = 0.01;

plot_species_line(S, S.t1, S.N1, spi, zi, ri);

cm = make_contribution_matrix(S.rates1, S.N1, S.reactions_components, spi, zi, ri);
cp = make_contribution_percents(cm);

rr = get_significant_reactions(cp, level);

plot_significant_reactions(cp, S.t1, rr, S.titles_reactions);
title(sprintf('%s @ z=%dkm', str_trim_zeros(S.titles_species(spi,:)), S.z(zi)/1000));
xlabel('t, s');
ylabel('Sinks and Sources');

%%
plot_species_line(S, S.t1, S.N1, 2,  zi, ri);
plot_species_line(S, S.t1, S.N1, 7,  zi, ri);
plot_species_line(S, S.t1, S.N1, 20, zi, ri);
plot_species_line(S, S.t1, S.N1, 32, zi, ri);