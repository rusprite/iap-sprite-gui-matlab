function S = load_sprite_data(file)
    % if netCDF
    if length(file)>=3 && strcmp(file(end-2:end), '.nc')==1
        S = loadnc(file);
        disp(S);
        % TODO ниже написаны три затычки. От них необходимо избавиться,
        % радикально изменив код
        S.zzz = S.z;
        S.rrr = S.r;
        % TODO впредь ожидается, что температура нейтралов тоже будет в
        % файле данных
        S.temp_1 = S.temp_e_1;
        S.temp_2 = S.temp_e_2;
        S.temp_3 = S.temp_e_3;
        S.titles = cellstr(S.titles_species);
    elseif length(file)>=4 && strcmp(file(end-3:end), '.mat')==1
        % TODO mat-файлы сейчас не содержат температуру нейтралов и
        % электронов, поэтому при попытке их нарисавать программа будет
        % выдавать ошибку. Впредь нужно мягко обрабатывать эту ситуацию
        S = load(file, 'titles', 't1', 'N1', 't2', 'N2', 't3', 'N3',...
                       'zzz', 'rrr', 'theta', 'model', 'revision');
        disp(S);
    else
        error('SpritOtron:wrong_file', 'Unknown file format');
    end
    
    S.species_number = size(S.N1,2);
end