%%
S = load_sprite_data('results_phch_40_90_200000.nc');

%%
iNO = 7;
iLya = 68;
iQ = 51;

N_NO = reducto(S.N1(1,iNO,:,1));
N_Lya = reducto(S.N1(1,iLya,:,1));
N_Q = reducto(S.N1(1,iQ,:,1));

figure;
semilogx(N_Q, S.z, N_NO.*N_Lya, S.z);
legend({'Q', 'Ly-a'});