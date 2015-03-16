S = load_sprite_data('results_phch_40_90_200000.nc');

%%
disp([(1:numel(S.z))', S.z]);

%%
%zi = 41; % 80
zi = 31; % 70
ri = 1;
species_index = 18; % e

figure;
plot(S.t1, reducto(S.N1(:, species_index, zi, ri)));
title('e');

figure;
plot(S.t1, reducto(sum(S.N1(:, S.species_neg, zi, ri), 2)));
title('neg');

figure;
plot(S.t1, reducto(sum(S.N1(:, S.species_nege, zi, ri), 2)));
title('neg e');

figure;
plot(S.t1, reducto(sum(S.N1(:, S.species_pos, zi, ri), 2)));
title('pos');

%%
species_index = 14; % CO_4^-

figure;
plot(S.t1, reducto(S.N1(:, species_index, zi, ri)));
title('CO_4^-');


%%
species_index = 2; % O_2^-

figure;
plot(S.t1, reducto(S.N1(:, species_index, zi, ri)));
title('O_2^-');