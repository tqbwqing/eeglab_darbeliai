function eeg_ikelk_i_eeglab(varargin)
% eeg_ikelk_i_eeglab - Įkėlimas į EEGLAB
% eeg_ikelk_i_eeglab('path','/kelias/iki/katalogo/','files',{'rinkmena.set' 'rinkmena.cnt' 'rinkmena.edf'})
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

if and(nargin, mod(nargin+1, 2)) ;
    if iscellstr(varargin((1:nargin/2)*2-1)); 
        g = struct(varargin{:});
    else  warning(lokaliz('Netinkami parametrai'));
        g=[];     
    end;
else    g=[];
end;

Kelias=pwd;
try Kelias=g(1).path;   catch; end;
try Kelias=g(1).pathin; catch; end;

Rinkmenos={};
try Rinkmenos={g.files}; catch; end;
if isempty(Rinkmenos);
    kd=pwd;
    try  cd(Kelias);
        Rinkmenos=filter_filenames(g.flt_show);
    catch
    end;
    cd(kd);
end;
if isempty(Rinkmenos); return; end;

% statusbar
h=statusbar(lokaliz('Loading data...'));
statusbar('on',h);

Rinkmenos2={};
for f=1:length(Rinkmenos);
    [KELIAS__,Rinkmena__,Prievardis__]=fileparts(fullfile(Kelias,Rinkmenos{f}));
    Rinkmena__=[Rinkmena__ Prievardis__];
    if exist(fullfile(KELIAS__,Rinkmena__ ),'file') == 2;
        Rinkmenos2{end+1,1}=Rinkmenos{f};
        Rinkmenos2{end,2}=KELIAS__;
        Rinkmenos2{end,3}=Rinkmena__;
    end;
end;

Pasirinktu_failu_N=size(Rinkmenos2,1);
if Pasirinktu_failu_N > 0 ;
    try
        disp(' ');
        disp('Įkelsime į EEGLAB:');
        disp([ '[' Kelias ']' ] );
        for f=1:Pasirinktu_failu_N;
            disp(Rinkmenos2{f,1});
        end;
        disp(' ');
        global ALLEEG EEG CURRENTSET;
        ALLEEG=[];
        for f=1:Pasirinktu_failu_N;
            EEG = eeg_ikelk(Rinkmenos2{f,2},Rinkmenos2{f,3});
            try eval(g(1).command) ; catch err; disp(err.message); end;
            [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'study',0,'setname',Rinkmenos2{f,3});
            %[ALLEEG EEG CURRENTSET]=eeg_store(ALLEEG, EEG);
            
            % statusbar
            p=f/Pasirinktu_failu_N;
            if isempty(statusbar(p,h));
                break;
            end;
            
        end;
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, Pasirinktu_failu_N,'retrieve',[1:f] ,'study',0);
        
    catch err; Pranesk_apie_klaida(err);
    end;
end;
eeglab redraw;

if ishandle(h)
    delete(h);
end;

