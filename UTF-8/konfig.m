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
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% (C) 2014 Mindaugas Baranauskas   
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%

function varargout = konfig(varargin)
% KONFIG MATLAB code for konfig.fig
%      KONFIG, by itself, creates a new KONFIG or raises the existing
%      singleton*.
%
%      H = KONFIG returns the handle to a new KONFIG or the handle to
%      the existing singleton*.
%
%      KONFIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KONFIG.M with the given input arguments.
%
%      KONFIG('Property','Value',...) creates a new KONFIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before konfig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to konfig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help konfig

% Last Modified by GUIDE v2.5 13-Jan-2015 16:04:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @konfig_OpeningFcn, ...
                   'gui_OutputFcn',  @konfig_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before konfig is made visible.
function konfig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to konfig (see VARARGIN)

function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
Darbeliai_nuostatos_senos.lokale={ '' ; '' ; '' ; } ;
if (exist('atnaujinimas','file') == 2) ;
    Darbeliai_nuostatos_senos.tikrinti_versija=1;
else    
    Darbeliai_nuostatos_senos.tikrinti_versija=0;
end;
Darbeliai_nuostatos_senos.diegti_auto=0;  
Darbeliai_nuostatos_senos.stabili_versija=0;
Darbeliai_nuostatos_senos.savita_versija=0;
Darbeliai_nuostatos_senos.url_atnaujinimui='';
Darbeliai_nuostatos_senos.url_versijai='';

try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'));    
    Darbeliai_nuostatos_senos.lokale=Darbeliai.nuostatos.lokale;
    Darbeliai_nuostatos_senos.tikrinti_versija=Darbeliai.nuostatos.tikrinti_versija;
    Darbeliai_nuostatos_senos.diegti_auto=Darbeliai.nuostatos.diegti_auto;
    Darbeliai_nuostatos_senos.stabili_versija=Darbeliai.nuostatos.stabili_versija;
    Darbeliai_nuostatos_senos.savita_versija=Darbeliai.nuostatos.savita_versija;
    Darbeliai_nuostatos_senos.url_atnaujinimui=Darbeliai.nuostatos.url_atnaujinimui;
    Darbeliai_nuostatos_senos.url_atnaujinimui=Darbeliai.nuostatos.url_versijai;
catch err;    
    %warning(err.message);
end;

set(handles.popupmenu2,'String',{lokaliz('Stable version') ; lokaliz('Trunk version')});
switch Darbeliai_nuostatos_senos.stabili_versija 
    case 1
        set(handles.popupmenu2,'Value',1);
    case 0
        set(handles.popupmenu2,'Value',2);
    otherwise
        set(handles.popupmenu2,'Value',3);
end;
set(handles.checkbox1,'Value',Darbeliai_nuostatos_senos.tikrinti_versija);
set(handles.checkbox2,'Value',Darbeliai_nuostatos_senos.diegti_auto);
checkbox1_Callback(hObject, eventdata, handles);

locale_text(hObject, eventdata, handles);

data_file=fullfile('..','lokaliz.mat');
try
    load(fullfile(function_dir,data_file));
catch err;
    LC_info=struct('LANG', {'--'}, 'COUNTRY', {''}, 'VARIANT', {''});
end;
set(handles.text2,'String', {LC_info.LANG ; LC_info.COUNTRY ; LC_info.VARIANT });

cur_lc=java.util.Locale.getDefault();

list={};
for i=1:length(LC_info);
    tmp_lc=java.util.Locale(LC_info(i).LANG,LC_info(i).COUNTRY,LC_info(i).VARIANT);
    mode2=tmp_lc.getLanguage();
    tmp_name=char(tmp_lc.getDisplayName(java.util.Locale(tmp_lc.getLanguage(),tmp_lc.getCountry(),tmp_lc.getVariant())));
    %list{i}=[ char(tmp_lc.getLanguage()) '_' char(tmp_lc.getCountry()) ' - ' tmp_name];
    list{i}=tmp_name;
    
    if strcmp(Darbeliai_nuostatos_senos.lokale{1},LC_info(i).LANG);
        if strcmp(Darbeliai_nuostatos_senos.lokale{2},LC_info(i).COUNTRY);
            if strcmp(Darbeliai_nuostatos_senos.lokale{3},LC_info(i).VARIANT);
                set(handles.popupmenu1,'Value',i);
            end;
        end;
    end;
    
end;
%disp(list);
list=char(list);
list={lokaliz('auto_lang') ; list(2:end,:)};
set(handles.popupmenu1,'String',list);


% Choose default command line output for konfig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes konfig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = konfig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function locale_text(hObject, eventdata, handles)
set(handles.text1,'String',lokaliz('Nuostatos'));
set(handles.pushbutton1,'String',lokaliz('OK'));
set(handles.pushbutton2,'String',lokaliz('Close'));
set(handles.pushbutton3,'String',lokaliz('Pritaikyti'));
set(handles.uipanel1,'Title',lokaliz('Atnaujinimas'));
kalbos_skydelio_pavad=(unique({lokaliz('Lokale'),'Kalba','Locale','Langue'}));
set(handles.uipanel2,'Title',regexprep(sprintf('%s / ',kalbos_skydelio_pavad{:}),' / $',''));
set(handles.checkbox1,'String',lokaliz('Tikrinti paleidimo metu'));
set(handles.checkbox2,'String',lokaliz('Diegti auto'));


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pushbutton3_Callback(hObject, eventdata, handles);
pushbutton2_Callback(hObject, eventdata, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(mfilename);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function_dir=regexprep(mfilename('fullpath'),[ mfilename '$'], '' );
try
    load(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat')); 
catch err;
end;

Darbeliai.nuostatos=[];

switch get(handles.popupmenu2,'Value') 
    case 1
        Darbeliai.nuostatos.stabili_versija=1;
        Darbeliai.nuostatos.url_atnaujinimui='https://github.com/embar-/eeglab_darbeliai/archive/stable.zip' ; 
        Darbeliai.nuostatos.url_versijai='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/stable/Darbeliai.versija';
    case 2
        Darbeliai.nuostatos.stabili_versija=0;
        Darbeliai.nuostatos.url_atnaujinimui='https://github.com/embar-/eeglab_darbeliai/archive/master.zip' ;
        Darbeliai.nuostatos.url_versijai='https://raw.githubusercontent.com/embar-/eeglab_darbeliai/master/Darbeliai.versija';
    otherwise
        Darbeliai.nuostatos.stabili_versija=-1;
        Darbeliai.nuostatos.url_atnaujinimui='';
        Darbeliai.nuostatos.url_versijai='';
end;
Darbeliai.nuostatos.tikrinti_versija=get(handles.checkbox1,'Value');
Darbeliai.nuostatos.diegti_auto=get(handles.checkbox2,'Value');
locale_idx=get(handles.popupmenu1,'Value');

restart_eeglab=0;

if locale_idx > 1;
    lc=get(handles.text2,'String');
    lc=lc([1 2 3] + ((locale_idx - 1) * 3));
    
    tmp_lc=java.util.Locale.getDefault();
    if strcmp(char(tmp_lc.getLanguage()),lc(1));
        if strcmp(char(tmp_lc.getCountry()),lc(2));
            if strcmp(char(tmp_lc.getVariant()),lc(3));
                restart_eeglab=0;
            else
                restart_eeglab=1;
            end;
        else
            restart_eeglab=1;
        end;
    else
        restart_eeglab=1;
    end;
    
    java.util.Locale.setDefault(java.util.Locale(lc(1),lc(2),lc(3)));
    disp(char(java.util.Locale.getDefault()));
    Darbeliai.nuostatos.lokale=lc;    
    
else
    Darbeliai.nuostatos.lokale={ '' ; '' ; '' ; } ;
end;

save(fullfile(Tikras_Kelias(fullfile(function_dir,'..')),'Darbeliai_config.mat'),'Darbeliai');

if restart_eeglab ; 
    %pushbutton2_Callback(hObject, eventdata, handles);
    close([findobj('-regexp','name','EEGLAB*')]);
    clear('lokaliz');
    %locale_text(hObject, eventdata, handles);
	konfig_OpeningFcn(hObject, eventdata, handles);
    drawnow;
    eeglab;
    drawnow;
    %drawnow;
    %pause(1);    
end ;

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1

if (exist('atnaujinimas','file') ~= 2) ;     
    %set(handles.uipanel1,'Visible','off')
    set(handles.checkbox1,'Enable','off');
    set(handles.checkbox2,'Enable','off');
    return; 
end;

if get(handles.checkbox1,'Value')
    set(handles.checkbox2,'Enable','on');
else
    set(handles.checkbox2,'Enable','off');
end;
 
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
