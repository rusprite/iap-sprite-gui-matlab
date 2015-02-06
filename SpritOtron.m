function SpritOtron
    file = uigetfile({'res*.nc';'*.mat';'*.*'}, 'Load results file');
    if file==0
        warndlg('Canceled');
        return
    end

    S = load_sprite_data(file);
    
    S.time_unit = 1; % 1 or 1e-3 or 1e-6
    S.time_unit_name = 's'; % 's' or 'ms' or 'mcs'
    
    S.distance_unit = 1; % 1 or 1000
    S.distance_unit_name = 'm'; % 'm' or 'km'

    S.species_string = getSpeciesString(S);

    variables_details = structfun(@varsummary, S, 'UniformOutput', false);
    variables_details = [fieldnames(variables_details)  struct2cell(variables_details)];
    variables_info = cell(1, size(variables_details,1));
    for i=1:size(variables_details,1)
        variables_info{i} = [variables_details{i,1}, ' : ',  variables_details{i,2}];
    end
    variables_details = strjoin(variables_info, '\n');

    % geometry parameters
    sp = 0.01; % space size

    % Details of data file window
    hFD = figure('Name', 'SpritOtron:details', 'NumberTitle','off',...
        'MenuBar', 'none', 'Units', 'characters',...
        'Position', [20 10 100 30], 'Tag', 'win');
    S.window_details = hFD;

    S.variables_details = uicontrol('Style', 'edit', 'Units', 'normalized',...
        'Position', [sp, sp, (1-3*sp)/2, 1-2*sp],...
        'BackgroundColor', 'w',...
        'String', variables_details, ...
        'Tag', 'edtFun', ...
        'Max', 3, ...
        'Min', 1, ...
        'HorizontalAlignment', 'left' );
    S.variables_details = uicontrol('Style', 'edit', 'Units', 'normalized',...
        'Position', [2*sp+(1-3*sp)/2, sp, (1-3*sp)/2, 1-2*sp],...
        'BackgroundColor', 'w',...
        'String', S.model', ...
        'Tag', 'edtFun', ...
        'Max', 3, ...
        'Min', 1, ...
        'HorizontalAlignment', 'left' );

    % Main window
    % geometry parameters
    columns = 4;
    rows = 10;
    st_w = (1-(columns+1)*sp)/columns;
    st_h = (1-(rows+1)*sp)/rows;

    x_col = @(col) sp+col*(st_w+sp);
    y_row = @(row) sp+(rows-row-1)*(st_h+sp);

    hF = figure('Name', 'SpritOtron', 'NumberTitle','off',...
        'MenuBar', 'none', 'Units', 'characters',...
        'Position', [10 10 100 30], 'Tag', 'win');

    S.window = hF;

    % list of fractions

    S.list = uicontrol('Style', 'listbox', 'Units', 'normalized',...
        'Position', [x_col(0), sp, st_w, 1-sp*2],...
        'BackgroundColor', 'w',...
        'String', S.species_string, ...
        'Tag', 'edtFun');

    % edit fields
    % create before buttons

    make_label = @(pos, text) uicontrol('Style', 'text', 'Units', 'normalized', 'Position', pos, 'String', text, 'BackgroundColor', 'w', 'Tag', 'edtFun');
    make_edit = @(pos, initial_value) uicontrol('Style', 'edit', 'Units', 'normalized', 'Position', pos, 'BackgroundColor', 'w', 'Tag', 'edtFun', 'String', initial_value);

    S.label_t = make_label([x_col(1), y_row(7), st_w, st_h], 't1/t2');
    S.label_z = make_label([x_col(2), y_row(7), st_w, st_h], 'z1/z2');
    S.label_r = make_label([x_col(3), y_row(7), st_w, st_h], 'r1/r2');

    S.edit_t1 = make_edit([x_col(1), y_row(8), st_w, st_h], '');
    S.edit_t2 = make_edit([x_col(1), y_row(9), st_w, st_h], '');
    S.edit_z1 = make_edit([x_col(2), y_row(8), st_w, st_h], num2str(S.z1));
    S.edit_z2 = make_edit([x_col(2), y_row(9), st_w, st_h], num2str(S.z2));
    S.edit_r1 = make_edit([x_col(3), y_row(8), st_w, st_h], num2str(S.r1));
    S.edit_r2 = make_edit([x_col(3), y_row(9), st_w, st_h], num2str(S.r2));

    % plot buttons

    make_button = @(pos, title, cb) uicontrol('Style', 'pushbutton', 'Units', 'normalized', 'Position', pos, 'String', title, 'Callback', {cb,S}, 'Tag', 'btnRight');

    S.button_plot_1_tz  = make_button([x_col(1), y_row(0), st_w, st_h], 'plot_1_tz',  @btnPlot_1_tz);
    S.button_plot_2_tz  = make_button([x_col(2), y_row(0), st_w, st_h], 'plot_2_tz',  @btnPlot_2_tz);
    S.button_plot_23_tz = make_button([x_col(3), y_row(0), st_w, st_h], 'plot_23_tz', @btnPlot_23_tz);

    S.button_plot_1_tr  = make_button([x_col(1), y_row(1), st_w, st_h], 'plot_1_tr',  @btnPlot_1_tr);
    S.button_plot_2_tr  = make_button([x_col(2), y_row(1), st_w, st_h], 'plot_2_tr',  @btnPlot_2_tr);
    S.button_plot_23_tr = make_button([x_col(3), y_row(1), st_w, st_h], 'plot_23_tr', @btnPlot_23_tr);

    S.button_plot_1_zr  = make_button([x_col(1), y_row(2), st_w, st_h], 'plot_1_zr',  @btnPlot_1_zr);
    S.button_plot_2_zr  = make_button([x_col(2), y_row(2), st_w, st_h], 'plot_2_zr',  @btnPlot_2_zr);
    S.button_plot_23_zr = make_button([x_col(3), y_row(2), st_w, st_h], 'plot_23_zr', @btnPlot_23_zr);

    S.button_plot_em_1_tz  = make_button([x_col(1), y_row(3), st_w, st_h], 'plot_em_1_tz',  @btnPlot_em_1_tz);
    S.button_plot_em_2_tz  = make_button([x_col(2), y_row(3), st_w, st_h], 'plot_em_2_tz',  @btnPlot_em_2_tz);
    S.button_plot_em_23_tz = make_button([x_col(3), y_row(3), st_w, st_h], 'plot_em_23_tz', @btnPlot_em_23_tz);

    S.button_plot_em_1_tr  = make_button([x_col(1), y_row(4), st_w, st_h], 'plot_em_1_tr',  @btnPlot_em_1_tr);
    S.button_plot_em_2_tr  = make_button([x_col(2), y_row(4), st_w, st_h], 'plot_em_2_tr',  @btnPlot_em_2_tr);
    S.button_plot_em_23_tr = make_button([x_col(3), y_row(4), st_w, st_h], 'plot_em_23_tr', @btnPlot_em_23_tr);

    S.button_plot_em_1_zr  = make_button([x_col(1), y_row(5), st_w, st_h], 'plot_em_1_zr',  @btnPlot_em_1_zr);
    S.button_plot_em_2_zr  = make_button([x_col(2), y_row(5), st_w, st_h], 'plot_em_2_zr',  @btnPlot_em_2_zr);
    S.button_plot_em_23_zr = make_button([x_col(3), y_row(5), st_w, st_h], 'plot_em_23_zr', @btnPlot_em_23_zr);

    S.button_plot_ss_1_t  = make_button([x_col(1), y_row(6), st_w, st_h], 'plot_ss_1_t',  @btnPlot_ss_1_t);
    S.button_plot_ss_2_t  = make_button([x_col(2), y_row(6), st_w, st_h], 'plot_ss_2_t',  @btnPlot_ss_2_t);
    S.button_plot_ss_23_t = make_button([x_col(3), y_row(6), st_w, st_h], 'plot_ss_23_t', @btnPlot_ss_23_t);
end

function s = varsummary(var)
    if iscell(var)
        s = '{...}';
    elseif ischar(var)
        if length(var)<=16
            s = ['''', reshape(var, 1, numel(var)), '...'''];
        else
            s = ['''', reshape(var(1:16), 1, numel(var(1:16))), '...'''];
        end
        s = strrep(s, '\n', '\\n');
    else
        if numel(var)==1
            s = num2str(var);
        else
            s = ['[', strjoin(arrayfun(@(x) num2str(x), size(var), 'UniformOutput', false), 'x'), ']'];
        end
    end
end

function t = concatenate_t(t1, t2)
    t=[t1(1:(end-1)); t2+t1(end)];
end

function S = concatenate_v(N1, N2)
    % function [t, S] = concato(N1, N2)
    % First dimension of N1  and N2 must be time.

    if numel(size(N1))<2 || numel(size(N2))<2
        error('concato:wrong_dimensions', 'N1 and N2 must have 2 or more dimensions');
    end

    if numel(size(N1))~=numel(size(N2))
        error('concato:wrong_dimensions', 'N1 and N2 must have same dimensions number');
    end
    if size(N1,2)~=size(N2,2)
        error('concato:wrong_dimensions', 'N1 and N2 must be same size in second dimension');
    end

    if numel(size(N1))==2
        S = cat(1, N1((1:end-1), :), N2);
    elseif numel(size(N1))==3
        S = cat(1, N1((1:end-1), :, :), N2);
    elseif numel(size(N1))==4
        S = cat(1, N1((1:end-1), :, :, :), N2);
    end
end

function species_string = getSpeciesString(S)
    species_string = strjoin(S.titles', ' | ');
    species_string = [species_string '| \sigma | \theta | temp | temp_e '];
end

function [t1, t2, z1, z2, r1, r2] = getEditValues(S)
    t1 = str2double(get(S.edit_t1, 'String'));
    t2 = str2double(get(S.edit_t2, 'String'));
    z1 = str2double(get(S.edit_z1, 'String'));
    z2 = str2double(get(S.edit_z2, 'String'));
    r1 = str2double(get(S.edit_r1, 'String'));
    r2 = str2double(get(S.edit_r2, 'String'));
end

function ti = get_index(tt, t, value_if_nan)
    if isnan(t)
        ti = value_if_nan;
    else
        [~, ti] = proximo(tt, t);
    end
end

function [t1i, t2i, z1i, z2i, r1i, r2i] = get_tzr_indexes(S, tt)
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    t1i = get_index(tt, t1, 1);
    t2i = get_index(tt, t2, numel(tt));

    z1i = get_index(S.zzz, z1, 1);
    z2i = get_index(S.zzz, z2, size(S.N1, 3));

    r1i = get_index(S.rrr, r1, 1);
    r2i = get_index(S.rrr, r2, size(S.N1, 4));
end

function [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, tt)
    [~, ~, ~, ~, ~, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, ~] = get_tzr_indexes(S, tt);
    if ~isnan(r2)
        warndlg('Please specify only r1 value for tz plot. r2 ignored');
    end
    r2i = r1i;
end

function [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, tt)
    [~, ~, ~, z2, ~, ~] = getEditValues(S);
    [t1i, t2i, z1i, ~, r1i, r2i] = get_tzr_indexes(S, tt);
    if ~isnan(z2)
        warndlg('Please specify only z1 value for tr plot. z2 ignored');
    end
    z2i = z1i;
end

function [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, tt)
    [~, t2, ~, ~, ~, ~] = getEditValues(S);
    [t1i, ~, z1i, z2i, r1i, r2i] = get_tzr_indexes(S, tt);
    if ~isnan(t2)
        warndlg('Please specify only t1 value for zr plot. t2 ignored');
    end
    t2i = t1i;
end

% TODO Как сделать без копипасты?

function plot_data(S, tt, zz, dd, tit, xlab, ylab)
    figure;
    size_dd = size(dd);
    if numel(size_dd(size_dd~=1))==1
        % line plot
        semilogx(tt, dd);
    else
        % 2d plot
        plot_2d(tt, zz, dd);
        colorbar;
        ylabel(ylab);
    end
    title(tit);
    xlabel(xlab);
end

function ss = time_subscript(S)
    ss = sprintf('time, %s', S.time_unit);
end

function ss = altitude_subscript(S)
    ss = sprintf('z, %s', S.distance_unit);
end

function ss = radius_subscript(S)
    ss = sprintf('r, %s', S.distance_unit);
end

% TZ

function btnPlot_1_tz(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, S.t1);

    if species_index <= S.species_number
        data = reducto(S.N1(t1i:t2i,species_index, z1i:z2i, r1i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_1(t1i:t2i, z1i:z2i, r1i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_1(t1i:t2i, z1i:z2i, r1i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_1(t1i:t2i, z1i:z2i, r1i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_1(t1i:t2i, z1i:z2i, r1i));
        title = 'T_e';
    end

    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;
    title = [title ' @ 1 ' sprintf('r=%f', r1)];

    plot_data(S, S.t1(t1i:t2i)./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), altitude_subscript(S));
end

function btnPlot_2_tz(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, S.t2);

    if species_index <= S.species_number
        data = reducto(S.N2(t1i:t2i,species_index, z1i:z2i, r1i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_2(t1i:t2i, z1i:z2i, r1i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_2(t1i:t2i, z1i:z2i, r1i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_2(t1i:t2i, z1i:z2i, r1i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_2(t1i:t2i, z1i:z2i, r1i));
        title = 'T_e';
    end

    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;
    title = [title ' @ 2 ' sprintf('r=%f', r1)];

    plot_data(S, S.t2(t1i:t2i)./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), altitude_subscript(S));
end

function btnPlot_23_tz(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, tt);

    if species_index <= S.species_number
        data = concatenate_v(S.N2(:,species_index, z1i:z2i, r1i), S.N3(:,species_index, z1i:z2i, r1i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = concatenate_v(S.sigma_2(:,z1i:z2i, r1i), S.sigma_3(:,z1i:z2i, r1i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = concatenate_v(S.theta_2(:,z1i:z2i, r1i), S.theta_3(:,z1i:z2i, r1i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = concatenate_v(S.temp_2(:,z1i:z2i, r1i), S.temp_3(:,z1i:z2i, r1i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = concatenate_v(S.temp_e_2(:,z1i:z2i, r1i), S.temp_e_3(:,z1i:z2i, r1i));
        title = 'T_e';
    end

    data = reducto(data(t1i:t2i, :, :, :));
    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;
    title = [title ' @ 23 ' sprintf('r=%f', r1)];

    plot_data(S, tt(t1i:t2i)./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), altitude_subscript(S));
end

% TR

function btnPlot_1_tr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, S.t1);

    if species_index <= S.species_number
        data = reducto(S.N1(t1i:t2i,species_index, z1i, r1i:r2i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_1(t1i:t2i, z1i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_1(t1i:t2i, z1i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_1(t1i:t2i, z1i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_1(t1i:t2i, z1i, r1i:r2i));
        title = 'T_e';
    end

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;
    title = [title ' @ 1 ' sprintf('z=%f', z1)];

    plot_data(S, S.t1(t1i:t2i)./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), radius_subscript(S));
end

function btnPlot_2_tr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, S.t2);

    if species_index <= S.species_number
        data = reducto(S.N2(t1i:t2i,species_index, z1i, r1i:r2i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_2(t1i:t2i, z1i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_2(t1i:t2i, z1i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_2(t1i:t2i, z1i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_2(t1i:t2i, z1i, r1i:r2i));
        title = 'T_e';
    end

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;
    title = [title ' @ 2 ' sprintf('z=%f', z1)];

    plot_data(S, S.t2(t1i:t2i)./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), radius_subscript(S));
end

function btnPlot_23_tr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, tt);

    if species_index <= S.species_number
        data = concatenate_v(S.N2(:,species_index, z1i, r1i:r2i), S.N3(:,species_index, z1i, r1i:r2i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = concatenate_v(S.sigma_2(:, z1i, r1i:r2i), S.sigma_3(:, z1i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = concatenate_v(S.theta_2(:, z1i, r1i:r2i), S.theta_3(:, z1i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = concatenate_v(S.temp_2(:, z1i, r1i:r2i), S.temp_3(:, z1i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = concatenate_v(S.theta_e_2(:, z1i, r1i:r2i), S.theta_e_3(:, z1i, r1i:r2i));
        title = 'T_e';
    end

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;
    title = [title ' @ 23 ' sprintf('z=%f', z1)];

    data = reducto(data(t1i:t2i, :, :, :));
    plot_data(S, tt(t1i:t2i)./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, data, ...
        title, ...
        time_subscript(S), radius_subscript(S));
end

% ZR

function btnPlot_1_zr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, S.t1);

    if species_index <= S.species_number
        data = reducto(S.N1(t1i,species_index, z1i:z2i, r1i:r2i))';
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_1(t1i, z1i:z2i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_1(t1i, z1i:z2i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_1(t1i, z1i:z2i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_1(t1i, z1i:z2i, r1i:r2i));
        title = 'T_e';
    end

    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;
    title = [title ' @ 1 ' sprintf('t=%f', t1)];

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_2_zr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, S.t2);

    if species_index <= S.species_number
        data = reducto(S.N2(t1i,species_index, z1i:z2i, r1i:r2i))';
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = reducto(S.sigma_2(t1i, z1i:z2i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = reducto(S.theta_2(t1i, z1i:z2i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = reducto(S.temp_2(t1i, z1i:z2i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = reducto(S.temp_e_2(t1i, z1i:z2i, r1i:r2i));
        title = 'T_e';
    end

    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;
    title = [title ' @ 2 ' sprintf('t=%f', t1)];

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_23_zr(h, ev, S)
    species_index = get(S.list, 'Value');
    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, tt);

    if species_index <= S.species_number
        data = concatenate_v(S.N2(:,species_index, z1i:z2i, r1i:r2i), S.N3(:,species_index, z1i:z2i, r1i:r2i));
        title = sprintf('N(%s)', S.titles{species_index});
    elseif species_index == S.species_number + 1
        data = concatenate_v(S.sigma_2(:, z1i:z2i, r1i:r2i), S.sigma_3(:, z1i:z2i, r1i:r2i));
        title = '\sigma';
    elseif species_index == S.species_number + 2
        data = concatenate_v(S.theta_2(:, z1i:z2i, r1i:r2i), S.theta_3(:, z1i:z2i, r1i:r2i));
        title = '\theta';
    elseif species_index == S.species_number + 3
        data = concatenate_v(S.temp_2(:, z1i:z2i, r1i:r2i), S.temp_3(:, z1i:z2i, r1i:r2i));
        title = 'T';
    elseif species_index == S.species_number + 4
        data = concatenate_v(S.temp_e_2(:, z1i:z2i, r1i:r2i), S.temp_e_3(:, z1i:z2i, r1i:r2i));
        title = 'T_e';
    end

    data = reducto(data(t1i, :, :, :))';
    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;
    title = [title ' @ 23 ' sprintf('t=%f', t1)];

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, data, ...
        title, ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

% Em TZ
function btnPlot_em_1_tz(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, S.t1);

    [em_t, em_v] = emissio(S.t1(t1i:t2i), reducto(S.N1(t1i:t2i,species_index, z1i:z2i, r1i)));

    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 1'),  sprintf('r=%f', r1)], ...
        time_subscript(S), altitude_subscript(S));
end

function btnPlot_em_2_tz(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, S.t2);

    [em_t, em_v] = emissio(S.t2(t1i:t2i), reducto(S.N2(t1i:t2i,species_index, z1i:z2i, r1i)));

    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 2'),  sprintf('r=%f', r1)], ...
        time_subscript(S), altitude_subscript(S));
end

function btnPlot_em_23_tz(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tz_indexes(S, tt);

    data = concatenate_v(S.N2(:,species_index, z1i:z2i, r1i), S.N3(:,species_index, z1i:z2i, r1i));
    [em_t, em_v] = emissio(tt(t1i:t2i), reducto(data(t1i:t2i, :, :, :)));

    if isnan(r1), warndlg('Please enter r1 value to prevent r1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.zzz(z1i:z2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 23'),  sprintf('r=%f', r1)], ...
        time_subscript(S), altitude_subscript(S));
end

% Em TR
function btnPlot_em_1_tr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, S.t1);

    [em_t, em_v] = emissio(S.t1(t1i:t2i), reducto(S.N1(t1i:t2i,species_index, z1i, r1i:r2i)));

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 1 '), sprintf('z=%f', z1)], ...
        time_subscript(S), radius_subscript(S));
end

function btnPlot_em_2_tr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, S.t2);

	[em_t, em_v] = emissio(S.t2(t1i:t2i), reducto(S.N2(t1i:t2i,species_index, z1i, r1i:r2i)));

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 2 '), sprintf('z=%f', z1)], ...
        time_subscript(S), radius_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_em_23_tr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_tr_indexes(S, tt);

    data = concatenate_v(S.N2(:,species_index, z1i, r1i:r2i), S.N3(:,species_index, z1i, r1i:r2i));
    [em_t, em_v] = emissio(tt(t1i:t2i), reducto(data(t1i:t2i, :, :, :)));

    if isnan(z1), warndlg('Please enter z1 value to prevent z1=NaN'); end;

    plot_data(S, em_t./S.time_unit, S.rrr(r1i:r2i)./S.distance_unit, em_v, ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 23 '), sprintf('z=%f', z1)], ...
        time_subscript(S), radius_subscript(S));
end

% Em ZR
function btnPlot_em_1_zr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, S.t1);

    tt = S.t1;
    d = S.N1;
    if t1i>1
        dd1 = reducto(d(t1i,species_index, z1i:z2i, r1i:r2i));
        dd2 = reducto(d(t1i-1,species_index, z1i:z2i, r1i:r2i));
        dv = (dd2-dd1)./(tt(t1i-1)-tt(t1i));
    else
        dd1 = reducto(d(t1i,species_index, z1i:z2i, r1i:r2i));
        dd2 = reducto(d(t1i+1,species_index, z1i:z2i, r1i:r2i));
        dv = (dd2-dd1)./(tt(t1i+1)-tt(t1i));
    end

    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, dv', ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 1 ') sprintf('t=%f', t1)], ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_em_2_zr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, S.t2);

    tt = S.t2;
    d = S.N2;
    if t1i>1
        dd1 = reducto(d(t1i,species_index, z1i:z2i, r1i:r2i));
        dd2 = reducto(d(t1i-1,species_index, z1i:z2i, r1i:r2i));
        dv = (dd2-dd1)./(tt(t1i-1)-tt(t1i));
    else
        dd1 = reducto(d(t1i,species_index, z1i:z2i, r1i:r2i));
        dd2 = reducto(d(t1i+1,species_index, z1i:z2i, r1i:r2i));
        dv = (dd2-dd1)./(tt(t1i+1)-tt(t1i));
    end

    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, dv', ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 2 ') sprintf('t=%f', t1)], ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_em_23_zr(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate emissions for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    [t1, t2, z1, z2, r1, r2] = getEditValues(S);
    tt = concatenate_t(S.t2, S.t3);
    [t1i, t2i, z1i, z2i, r1i, r2i] = get_zr_indexes(S, tt);

    data = concatenate_v(S.N2(:,species_index, z1i:z2i, r1i:r2i), S.N3(:,species_index, z1i:z2i, r1i:r2i));
    d = data;

    if t1i>1
        dd1 = reducto(d(t1i,:, :, :));
        dd2 = reducto(d(t1i-1,:, :, :));
        dv = (dd2-dd1)./(tt(t1i-1)-tt(t1i));
    else
        dd1 = reducto(d(t1i,:, :, :));
        dd2 = reducto(d(t1i+1,:, :, :));
        dv = (dd2-dd1)./(tt(t1i+1)-tt(t1i));
    end

    if isnan(t1), warndlg('Please enter t1 value to prevent t1=NaN'); end;

    plot_data(S, S.rrr(r1i:r2i)./S.distance_unit, S.zzz(z1i:z2i)./S.distance_unit, dv', ...
        [sprintf('E(%s) %s', S.titles{species_index}, '@ 23 ') sprintf('t=%f', t1)], ...
        radius_subscript(S), altitude_subscript(S));
    set(gca, 'xscale', 'linear');
end

function btnPlot_ss_1_t(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate sinks and sources for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    warndlg('Under construction');
end

function btnPlot_ss_2_t(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate sinks and sources for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    warndlg('Under construction');
end

function btnPlot_ss_23_t(h, ev, S)
    species_index = get(S.list, 'Value');

    if species_index > S.species_number
        warndlg('Who knows how to calculate sinks and sources for sigma, theta, temp or temp_e? Not me!');
        return;
    end

    warndlg('Under construction');
end

% Dummy callback

function btnPlot(h, ev, S)
    warndlg('Under construction');
end
