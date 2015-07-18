function reikia_perkurti_meniu=drb_parinktys(hObject, eventdata, handles, veiskmas, darbas, varargin)
% drb_parinktis_ikelti - „Darbelių“ langų parinkčių įkėlimas
%
% (C) 2015 Mindaugas Baranauskas

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Ši programa yra laisva. Jūs galite ją platinti ir/arba modifikuoti
% remdamiesi Free Software Foundation paskelbtomis GNU Bendrosios
% Viešosios licencijos sąlygomis: 2 licencijos versija, arba (savo
% nuožiūra) bet kuria vėlesne versija.
%
% Ši programa platinama su viltimi, kad ji bus naudinga, bet BE JOKIOS
% GARANTIJOS; be jokios numanomos PERKAMUMO ar TINKAMUMO KONKRETIEMS
% TIKSLAMS garantijos. Žiūrėkite GNU Bendrąją Viešąją licenciją norėdami
% sužinoti smulkmenas.
%
% Jūs turėjote kartu su šia programa gauti ir GNU Bendrosios Viešosios
% licencijos kopija; jei ne - rašykite Free Software Foundation, Inc., 59
% Temple Place - Suite 330, Boston, MA 02111-1307, USA.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
%%

if nargin > 5; rinkinys=varargin{1};
else           rinkinys='paskutinis';
end;

pagr_katalog=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
konfig_rinkm=fullfile(Tikras_Kelias(fullfile(pagr_katalog,'..')),'Darbeliai_config.mat');

switch lower(veiskmas)
    case {'ikelti'}
        drb_parinktis_ikelti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin{2:end});
    case {'trinti'}
        drb_parinktis_trinti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin{:});
    case {'irasyti'}
        drb_parinktis_irasyti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin{2:end});
end;


function drb_parinktis_ikelti(hObject, eventdata, handles, konfig_rinkm, darbas, rinkinys, varargin)
%% Įkelti
try eval([ darbas '(''susaldyk'',hObject, eventdata, handles);' ]) ; catch; end;
try
    load(konfig_rinkm);   
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; 
    i=find(ismember(esami,rinkinys));
    Parinktys=saranka(i).parinktys; 
    for j=1:length(Parinktys);
        try
            set(eval(['handles.' Parinktys(j).id ]), ...
                'Value',         Parinktys(j).Value );
            set(eval(['handles.' Parinktys(j).id ]), ...
                'UserData',      Parinktys(j).UserData );
            if Parinktys(j).String_ ;
                set(eval(['handles.' Parinktys(j).id ]), ...
                    'String',        Parinktys(j).String );
            end;
            if Parinktys(j).TooltipString_ ;
                set(eval(['handles.' Parinktys(j).id ]), ...
                    'TooltipString', Parinktys(j).TooltipString );
            end;
        catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
        end;
    end;
catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
end;
drawnow;
guidata(hObject, handles);
try eval([ darbas '(''susildyk'',hObject, eventdata, handles);' ]) ; catch; end;


function drb_parinktis_trinti(hObject, eventdata, handles, konfig_rinkm, darbas, varargin)
%% Trinti
try
    load(konfig_rinkm);
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
    esami_N=length(esami);
    esami_nr=find(~ismember(esami,{'numatytas','paskutinis'}));
    esami=esami(esami_nr);
    if isempty(esami); return; end;
catch %err; Pranesk_apie_klaida(err, 'pop_QRS_i_EEG.m', '-', 0);
    return;
end;
if nargin > 5; trintini_rinkiniai = varargin{1};
else           trintini_rinkiniai = '';
end;
if isempty(trintini_rinkiniai);
    pasirinkti=listdlg('ListString', esami,...
        'SelectionMode','multiple',...
        'PromptString', lokaliz('Trinti:'),...
        'InitialValue',length(esami),...
        'OKString',lokaliz('Trinti'),...
        'CancelString',lokaliz('Cancel'));
else
    pasirinkti=find(ismember(trintini_rinkiniai,esami));
end;
if isempty(pasirinkti); return; end;
saranka=saranka(setdiff([1:esami_N], esami_nr(pasirinkti))); %#ok
eval(['Darbeliai.dialogai.' darbas '.saranka=saranka ;']);

% Įrašymas
try   movefile([konfig_rinkm '~'], [konfig_rinkm '~~' ], 'f'); catch; end;
try   movefile(konfig_rinkm, [konfig_rinkm '~' ], 'f'); catch; end;
try   save(konfig_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 0);
end;

% meniu
drb_meniu(hObject, eventdata, handles, 'visas', darbas);


function drb_parinktis_irasyti(hObject, eventdata, handles, konfig_rinkm, darbas, vardas, komentaras, isimintini)
%%
reikia_perkurti_meniu=0;
if isempty(vardas); 
    a=inputdlg({lokaliz('Pavadinimas:'),lokaliz('Komentaras:')}); 
    if isempty(a); return; end;
    if iscell(a);
        if isempty(a{1});
            vardas='paskutinis';
            komentaras='';
        else
            vardas=a{1};
            komentaras=a{2};
        end;
    end;
end;
    
try
    load(konfig_rinkm);
    eval([ 'saranka=Darbeliai.dialogai.' darbas '.saranka;' ]);
    esami={saranka.vardas}; %#ok
    if and(ismember(vardas,esami),~ismember(vardas,{'numatytas','paskutinis'}));
        ats=questdlg(lokaliz('Perrašyti nuostatų rinkinį?'),...
            lokaliz('Nuostatos jau yra!'),lokaliz('Rewrite'),lokaliz('Cancel'),lokaliz('Cancel'));
        if isempty(ats); return; end;
        if ~strcmp(ats,lokaliz('Rewrite')); return; end;
        reikia_perkurti_meniu=1;
    end;
catch err; Pranesk_apie_klaida(err, mfilename, konfig_rinkm, 0);
    saranka=struct;
end;

% Užduočių parinktys
Parinktys=struct('id','','Value','','UserData','','String_','','String','','TooltipString_','','TooltipString','');
j=1;
for b=1:length(isimintini);
    isimintini_raktai=lower(isimintini(b).raktai);
    isimintini_nariai=isimintini(b).nariai;
    for i=1:length(isimintini_nariai);
        try
            Parinktys(j).id = isimintini_nariai{i} ; 
            
            if ismember({'value'}, isimintini_raktai);
                Parinktys(j).Value    = get(eval(['handles.' isimintini_nariai{i}]), 'Value');
            end;
            
            if ismember({'userdata'}, isimintini_raktai);
                Parinktys(j).UserData = get(eval(['handles.' isimintini_nariai{i}]), 'UserData');
            end;
            
            if ismember({'string'}, isimintini_raktai);
                Parinktys(j).String_  = 1;
                Parinktys(j).String   = get(eval(['handles.' isimintini_nariai{i}]), 'String');
            else
                Parinktys(j).String_  = 0;
            end;
            
            if ismember({'tooltipstring'}, isimintini_raktai);
                Parinktys(j).TooltipString_ = 1;
                Parinktys(j).TooltipString   = get(eval(['handles.' isimintini_nariai{i}]), 'TooltipString');
            else
                Parinktys(j).TooltipString_ = 0;
            end;
            
            j=j+1;
            
        catch err; Pranesk_apie_klaida(err, mfilename, darbas, 0);
        end;
    end;
end;

try
    i=find(ismember(esami,vardas));
    if isempty(i);
        i=length(esami)+1; 
        reikia_perkurti_meniu=1;
    end;
catch
    i=1;
end;

saranka(i).vardas    = vardas ;
saranka(i).data      = datestr(now,'yyyy-mm-dd HH:MM:SS') ;
saranka(i).komentaras= [ komentaras ' ' ] ;
saranka(i).parinktys = Parinktys ;
eval(['Darbeliai.dialogai.' darbas '.saranka=saranka; ']);

% Įrašymas
try   movefile([konfig_rinkm '~'], [konfig_rinkm '~~' ], 'f'); catch; end;
try   movefile(konfig_rinkm, [konfig_rinkm '~' ], 'f'); catch; end;
try   save(konfig_rinkm,'Darbeliai');
catch err; Pranesk_apie_klaida(err, darbas, konfig_rinkm, 0);
end;

% meniu
if reikia_perkurti_meniu;
    drb_meniu(hObject, eventdata, handles, 'visas', darbas);
end;