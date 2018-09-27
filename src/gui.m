function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 19-Mar-2017 00:33:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

%%%%%%%%%%%%%%%%%%%%%%%%%%FIX PLAY, RELOAD, BALANCE, VOLUME, CHANGING,
%%%%%%%%%%%%%%%%%%%%%%%%%%ENVIRONMENT, WAVE PLOTTING
%%%%%%%%%%%%%%%%%%%%%%%%%%EQUALIZER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.slider1,'Max',5); %5
set(handles.slider2,'Max',5);
set(handles.slider3,'Max',5);
set(handles.slider4,'Max',5);
set(handles.slider5,'Max',5);
set(handles.slider6,'Max',5);
set(handles.slider7,'Max',5);
set(handles.slider8,'Max',5);
set(handles.slider9,'Max',2);

set(handles.slider1,'Min',-10); %-10
set(handles.slider2,'Min',-10);
set(handles.slider3,'Min',-10);
set(handles.slider4,'Min',-10);
set(handles.slider5,'Min',-10);
set(handles.slider6,'Min',-10);
set(handles.slider7,'Min',-10);
set(handles.slider8,'Min',-10);

set(handles.slider1,'Value',-2.5);
set(handles.slider2,'Value',-2.5);
set(handles.slider3,'Value',-2.5);
set(handles.slider4,'Value',-2.5);
set(handles.slider5,'Value',-2.5);
set(handles.slider6,'Value',-2.5);
set(handles.slider7,'Value',-2.5);
set(handles.slider8,'Value',-2.5);
set(handles.slider9,'Value',1);

set(handles.popupmenu2, 'Enable', 'off');
set(handles.reload, 'Enable', 'off');
set(handles.play, 'Enable', 'off');
set(handles.stop, 'Enable', 'off');
set(handles.pause, 'Enable', 'off');

set(handles.VolVal, 'String', get(handles.slider8,'value'));
currentBal = get(handles.slider9,'value');
maxBalance = get(handles.slider9,'max');
left = maxBalance-currentBal;
right= currentBal+0;
set(handles.LeftVal, 'String', left);
set(handles.RightVal, 'String', right);

handles.loaded = 0;
handles.played = 0;
handles.environment = 'DEFAULT';

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    y = handles.environment;
    Fs = handles.fs;
    A = fir1(1000,[20 100]/(Fs/2),'bandpass');
    filtA = filter(A,1,y);
    handles.eq1 = filtA*get(handles.slider1, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);
        
        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    y = handles.environment;
    Fs = handles.fs;
    B = fir1(1000,[100 200]/(Fs/2),'bandpass');
    filtB = filter(B,1,y);
    handles.eq2 = filtB*get(handles.slider2, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);

        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    y = handles.environment;
    Fs = handles.fs;
    C = fir1(1000,[200 600]/(Fs/2),'bandpass');
    filtC = filter(C,1,y);
    handles.eq3 = filtC*get(handles.slider3, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);
        
        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    y = handles.environment;
    Fs = handles.fs;
    D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
    filtD = filter(D,1,y);
    handles.eq4 = filtD*get(handles.slider4, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);

        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    y = handles.environment;
    Fs = handles.fs;
    E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
    filtE = filter(E,1,y);
    handles.eq5 = filtE*get(handles.slider5, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);

        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    y = handles.environment;
    Fs = handles.fs;
    F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
    filtF = filter(F,1,y);
    handles.eq6 = filtF*get(handles.slider6, 'value');

    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);

        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    
    y = handles.environment;
    Fs = handles.fs;
    G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
    filtG = filter(G,1,y);
    handles.eq7 = filtG*get(handles.slider7, 'value');
    
    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;      
        [row,col] = size(y);
        
        handles.environment = y;
        y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
        
        volumeVal = handles.volume;
        y = y*volumeVal;
        
        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
     volumeVal = get(handles.slider8,'value');
     volumeVal = 10^(volumeVal/20);
     set(handles.VolVal, 'String', get(handles.slider8,'value'));
     
     if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;
        y = handles.environment;
        Fs = handles.fs;
        [row,col] = size(y);

        y = y*volumeVal;

        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
    handles.volume = volumeVal;
    
 guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    currentBal = get(handles.slider9,'value');
    maxBalance = get(handles.slider9,'max');
    if(currentBal < 1)
        left = 1;
        right= currentBal;
    else if(currentBal >1)
        left = maxBalance - currentBal;
        right= 1;
    else 
        left = 1;
        right = 1;
        end
    end
        
    set(handles.LeftVal, 'String', left);
    set(handles.RightVal, 'String', right);
    
    if(handles.loaded == 1 && handles.played == 1)
        curr_player = handles.player;
        y = handles.environment;
        Fs = handles.fs;
        [row,col] = size(y);

        volumeVal = handles.volume;
        y = y*volumeVal;
        
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end 

        startAt = get(curr_player,'CurrentSample')+100;
        player = audioplayer(bal_sound,Fs);
        play(player, startAt);

        if(handles.isPaused == 1)
            pause(player);
        end
        
        handles.Fs = Fs;
        handles.player = player;
    end
    
    handles.bal_left = left;
    handles.bal_right = right;
    
 guidata(hObject, handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in reload.
function reload_Callback(hObject, eventdata, handles)
% hObject    handle to reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(handles.loaded == 1 && handles.played == 1)
        wavFile = handles.wavFile;
        y = handles.environment;
        Fs = handles.fs;
        [row,col] = size(y);

        %Check for volume settings first
        volumeVal = handles.volume;
        y = y*volumeVal;

        left = handles.bal_left;
        right= handles.bal_right;
        if (col == 1)
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,1);
        else
            bal_sound(:,1) = left*y(:,1);
            bal_sound(:,2) = right*y(:,2);
        end

        player = audioplayer(bal_sound,Fs);
        play(player,1);
        disp('Reload');
        
        handles.isPaused = 0;
        handles.player = player;
        handles.Fs = Fs;
    end
    
 guidata(hObject, handles);

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(handles.loaded == 1)
        if(handles.played == 0)
            y = handles.environment;
            Fs = handles.fs;
            [row,col] = size(y);

            %Check for volume settings first
            volumeVal = handles.volume;
            y = y*volumeVal;

            left = handles.bal_left;
            right= handles.bal_right;
            if (col == 1)
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,1);
            else
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,2);
            end

            player = audioplayer(bal_sound,Fs);
            handles.Fs = Fs;
            
        else
            player = handles.player;
            
        end

        disp('Play');
        resume(player);      
        
        handles.isPaused = 0;
        handles.played = 1;
        handles.player = player;
    end
    
 guidata(hObject, handles);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(handles.loaded == 1 && handles.played == 1)
        player = handles.player;
        stop(player);
        disp('Stop');
        handles.isPaused = 1;
        handles.player= player;
    end

 guidata(hObject,handles);
% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if(handles.loaded == 1 && handles.played == 1)
        player = handles.player;
        pause(player);
        disp('Pause');
        handles.isPaused = 1;
        handles.player = player;
    end
    
 guidata(hObject,handles);

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

    guidata(hObject, handles);

    %str = get(hObject, 'String');
    val = get(hObject,'Value');

    % Set current data to the selected data set.
    switch val;
    case 1 % User selects peaks.
        if(handles.loaded == 1)
            curr_player = handles.player;
            [y,Fs] = audioread(handles.wavFile);
            handles.environment = y;
            [row,col] = size(y);
 
            A = fir1(1000,[20 100]/(Fs/2),'bandpass');
            filtA = filter(A,1,y);
            handles.eq1 = filtA*get(handles.slider1, 'value');

            B = fir1(1000,[100 200]/(Fs/2),'bandpass');
            filtB = filter(B,1,y);
            handles.eq2 = filtB*get(handles.slider2, 'value');

            C = fir1(1000,[200 600]/(Fs/2),'bandpass');
            filtC = filter(C,1,y);
            handles.eq3 = filtC*get(handles.slider3, 'value');

            D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
            filtD = filter(D,1,y);
            handles.eq4 = filtD*get(handles.slider4, 'value');

            E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
            filtE = filter(E,1,y);
            handles.eq5 = filtE*get(handles.slider5, 'value');

            F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
            filtF = filter(F,1,y);
            handles.eq6 = filtF*get(handles.slider6, 'value');

            G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
            filtG = filter(G,1,y);
            handles.eq7 = filtG*get(handles.slider7, 'value');
            
            y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
            
            volumeVal = handles.volume;
            y = y*volumeVal;

            left = handles.bal_left;
            right= handles.bal_right;

            if (col == 1)
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,1);
            else
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,2);
            end

            startAt = get(curr_player,'CurrentSample')+100;
            player = audioplayer(bal_sound,Fs);
            play(player, startAt);

            if(handles.isPaused == 1)
                pause(player);
            end

            handles.Fs = Fs;
            handles.player = player;
        end

    case 2 % User selects membrane.
        if(handles.loaded == 1)
            curr_player = handles.player;
            y = handles.envsound1;
            Fs = handles.fs;
            [row,col] = size(y);
            handles.environment = y;
            
            A = fir1(1000,[20 100]/(Fs/2),'bandpass');
            filtA = filter(A,1,y);
            handles.eq1 = filtA*get(handles.slider1, 'value');

            B = fir1(1000,[100 200]/(Fs/2),'bandpass');
            filtB = filter(B,1,y);
            handles.eq2 = filtB*get(handles.slider2, 'value');

            C = fir1(1000,[200 600]/(Fs/2),'bandpass');
            filtC = filter(C,1,y);
            handles.eq3 = filtC*get(handles.slider3, 'value');

            D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
            filtD = filter(D,1,y);
            handles.eq4 = filtD*get(handles.slider4, 'value');

            E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
            filtE = filter(E,1,y);
            handles.eq5 = filtE*get(handles.slider5, 'value');

            F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
            filtF = filter(F,1,y);
            handles.eq6 = filtF*get(handles.slider6, 'value');

            G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
            filtG = filter(G,1,y);
            handles.eq7 = filtG*get(handles.slider7, 'value');
            
            y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
            
            volumeVal = handles.volume;
            y = y*volumeVal;
            
            left = handles.bal_left;
            right= handles.bal_right;
            if (col == 1)
            	bal_sound(:,1) = left*y(:,1);
            	bal_sound(:,2) = right*y(:,1);
            else
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,2);
            end

            startAt = get(curr_player,'CurrentSample')+100;
            player = audioplayer(bal_sound,Fs);
            play(player, startAt);

            if(handles.isPaused == 1)
                pause(player);
            end

            handles.Fs = Fs;
            handles.player = player;
        end

    case 3 % User selects sinc.  player = handles.player;
        if(handles.loaded == 1)
            curr_player = handles.player;
            y = handles.envsound2;
            Fs = handles.fs;
            [row,col] = size(y);
            handles.environment = y;
            
            A = fir1(1000,[20 100]/(Fs/2),'bandpass');
            filtA = filter(A,1,y);
            handles.eq1 = filtA*get(handles.slider1, 'value');

            B = fir1(1000,[100 200]/(Fs/2),'bandpass');
            filtB = filter(B,1,y);
            handles.eq2 = filtB*get(handles.slider2, 'value');

            C = fir1(1000,[200 600]/(Fs/2),'bandpass');
            filtC = filter(C,1,y);
            handles.eq3 = filtC*get(handles.slider3, 'value');

            D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
            filtD = filter(D,1,y);
            handles.eq4 = filtD*get(handles.slider4, 'value');

            E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
            filtE = filter(E,1,y);
            handles.eq5 = filtE*get(handles.slider5, 'value');

            F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
            filtF = filter(F,1,y);
            handles.eq6 = filtF*get(handles.slider6, 'value');

            G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
            filtG = filter(G,1,y);
            handles.eq7 = filtG*get(handles.slider7, 'value');
            
            y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;
            
            volumeVal = handles.volume;
            y = y*volumeVal;

            left = handles.bal_left;
            right= handles.bal_right;
            if (col == 1)
            	bal_sound(:,1) = left*y(:,1);
            	bal_sound(:,2) = right*y(:,1);
            else
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,2);
            end

            startAt = get(curr_player,'CurrentSample')+100;
            player = audioplayer(bal_sound,Fs);
            play(player, startAt);

            if(handles.isPaused == 1)
                pause(player);
            end

            handles.Fs = Fs;
            handles.player = player;
        end

    case 4
        if(handles.loaded == 1)
            curr_player = handles.player;
            y = handles.envsound3;
            Fs = handles.fs;
            [row,col] = size(y);
            handles.environment = y;
            
            A = fir1(1000,[20 100]/(Fs/2),'bandpass');
            filtA = filter(A,1,y);
            handles.eq1 = filtA*get(handles.slider1, 'value');

            B = fir1(1000,[100 200]/(Fs/2),'bandpass');
            filtB = filter(B,1,y);
            handles.eq2 = filtB*get(handles.slider2, 'value');

            C = fir1(1000,[200 600]/(Fs/2),'bandpass');
            filtC = filter(C,1,y);
            handles.eq3 = filtC*get(handles.slider3, 'value');

            D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
            filtD = filter(D,1,y);
            handles.eq4 = filtD*get(handles.slider4, 'value');

            E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
            filtE = filter(E,1,y);
            handles.eq5 = filtE*get(handles.slider5, 'value');

            F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
            filtF = filter(F,1,y);
            handles.eq6 = filtF*get(handles.slider6, 'value');

            G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
            filtG = filter(G,1,y);
            handles.eq7 = filtG*get(handles.slider7, 'value');
            
            y = handles.eq1 + handles.eq2 + handles.eq3 + handles.eq4 + handles.eq5 + handles.eq6 + handles.eq7;        
            
            volumeVal = handles.volume;
            y = y*volumeVal;

            left = handles.bal_left;
            right= handles.bal_right;
            if (col == 1)
            	bal_sound(:,1) = left*y(:,1);
            	bal_sound(:,2) = right*y(:,1);
            else
                bal_sound(:,1) = left*y(:,1);
                bal_sound(:,2) = right*y(:,2);
            end
            
            startAt = get(curr_player,'CurrentSample')+100;
            player = audioplayer(bal_sound,Fs);
            play(player, startAt);

            if(handles.isPaused == 1)
                pause(player);
            end

            handles.Fs = Fs;
            handles.player = player;
        end
    end
% Save the handles structure.
guidata(hObject,handles)

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


% --- Executes on mouse press over figure background.
function figure1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider2.
function slider2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider3.
function slider3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider4.
function slider4_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider5.
function slider5_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider6.
function slider6_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider7.
function slider7_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider1 and none of its controls.
function slider1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider2 and none of its controls.
function slider2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider3 and none of its controls.
function slider3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider4 and none of its controls.
function slider4_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider5 and none of its controls.
function slider5_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider6 and none of its controls.
function slider6_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on slider7 and none of its controls.
function slider7_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    set(handles.popupmenu2, 'Enable', 'off');
    set(handles.reload, 'Enable', 'off');
    set(handles.play, 'Enable', 'off');
    set(handles.stop, 'Enable', 'off');
    set(handles.pause, 'Enable', 'off');

    [filename, pathname] = uigetfile({'*.wav'}, 'Select Song');
    fullpathname = strcat(pathname,filename);
    handles.wavFile = fullpathname;
    isPaused = 1;
    handles.isPaused = isPaused;
    handles.volume = 10^(get(handles.slider8, 'value')/20);
    
    currentBal = get(handles.slider9,'value');
    maxBalance = get(handles.slider9,'max');
    if(currentBal < 1)
    handles.bal_left = 1;
    handles.bal_right= currentBal;
    else if(currentBal >1)
            handles.bal_left = maxBalance - currentBal;
            handles.bal_right= 1;
        else
            handles.bal_left = 1;
            handles.bal_right=1;
        end
    end
    
    [y,Fs] = audioread(handles.wavFile);
    handles.environment = y;
    handles.fs = Fs;
    
    [env_filter1,Fs1] = audioread('Trig Room.wav');
    env_sound(:,1) = conv(env_filter1(:,1),y(:,1));
    env_sound(:,2) = conv(env_filter1(:,2),y(:,2));
    handles.envsound1 = env_sound;
    
    [env_filter2,Fs1] = audioread('Deep Space.wav');
    env_sound2(:,1) = conv(env_filter2(:,1),y(:,1));
    env_sound2(:,2) = conv(env_filter2(:,2),y(:,2));
    handles.envsound2 = env_sound2;
    
    [env_filter3,Fs1] = audioread('Bottle Hall.wav');
    env_sound3(:,1) = conv(env_filter3(:,1),y(:,1));
    env_sound3(:,2) = conv(env_filter3(:,2),y(:,2));
    handles.envsound3 = env_sound3;
    
    A = fir1(1000,[20 100]/(Fs/2),'bandpass');
    filtA = filter(A,1,y);
    handles.eq1 = filtA*get(handles.slider1, 'value');
    
    B = fir1(1000,[100 200]/(Fs/2),'bandpass');
    filtB = filter(B,1,y);
    handles.eq2 = filtB*get(handles.slider2, 'value');
    
    C = fir1(1000,[200 600]/(Fs/2),'bandpass');
    filtC = filter(C,1,y);
    handles.eq3 = filtC*get(handles.slider3, 'value');
    
    D = fir1(1000,[600 1400]/(Fs/2),'bandpass');
    filtD = filter(D,1,y);
    handles.eq4 = filtD*get(handles.slider4, 'value');
    
    E = fir1(1000,[1400 3400]/(Fs/2),'bandpass');
    filtE = filter(E,1,y);
    handles.eq5 = filtE*get(handles.slider5, 'value');
    
    F = fir1(1000,[3400 8600]/(Fs/2),'bandpass');
    filtF = filter(F,1,y);
    handles.eq6 = filtF*get(handles.slider6, 'value');
    
    G = fir1(1000,[8600 21400]/(Fs/2),'bandpass');
    filtG = filter(G,1,y);
    handles.eq7 = filtG*get(handles.slider7, 'value');
    
    set(handles.popupmenu2, 'Enable', 'on');
    set(handles.reload, 'Enable', 'on');
    set(handles.play, 'Enable', 'on');
    set(handles.stop, 'Enable', 'on');
    set(handles.pause, 'Enable', 'on');
    axes(handles.axes1);
    set(handles.loadFile, 'String', filename);
    handles.loaded = 1;
    handles.played = 0;
    
guidata(hObject,handles);
