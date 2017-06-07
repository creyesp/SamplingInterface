function varargout = SamplingInterface(varargin)
% SamplingInterface MATLAB code for SamplingInterface.fig
%      SamplingInterface, by itself, creates a new SamplingInterface or raises the existing
%      singleton*.
%
%      H = SamplingInterface returns the handle to a new SamplingInterface or the handle to
%      the existing singleton*.
%
%      SamplingInterface('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SamplingInterface.M with the given input arguments.
%
%      SamplingInterface('Property','Value',...) creates a new SamplingInterface or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the SamplingInterface before SamplingInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SamplingInterface_OpeningFcn via varargin.
%
%      *See SamplingInterface Options on GUIDE's Tools menu.  Choose "SamplingInterface allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SamplingInterface

% Last Modified by GUIDE v2.5 07-Jun-2017 17:10:02

% Begin initialization code - DO NOT EDIT
addpath('lib');
gui_Singleton = 1;
% SamplingInterface_OpeningFcn is the function that set all initial
% GUI parameters when it's opened
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SamplingInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @SamplingInterface_OutputFcn, ...
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


%val = str2double(get(hObject,'String'));


% UIWAIT makes SamplingInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SamplingInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
% if IsWin
    set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
handles.modify = true;

saveInformation('Default Configuration.dsi', handles);
guidata(hObject,handles);

% --- Executes on button press in startStimulation.
function startStimulation_Callback(hObject, eventdata, handles)
if length(handles.experiments.file) < 2
    errordlg('There''s no experiment loaded to be run','Error');
else
    stimulation(handles);
end

function onlyStimulusFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.onlyStimulus.fps);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.onlyStimulus.fps);
        errordlg('Input must be a number and non negative', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
        set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);

    end
end
updateTime(hObject, eventdata, handles)
% guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of onlyStimulusFps as text
%        str2double(get(hObject,'String')) returns contents of onlyStimulusFps as a double


% --- Executes during object creation, after setting all properties.
function onlyStimulusFps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onlyStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in samplingFormat.
function samplingFormat_Callback(hObject, eventdata, handles)
% hObject    handle to samplingFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
if in==1,
    handles.mode = 'Flicker';
    set(handles.flickerMenu,'visible','on');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','off');
elseif in==2,
    handles.mode = 'Only stimulus (fps)';
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','on');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','off');
elseif in==3
    handles.mode = 'White noise';
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','on');
    set(handles.maskStimulusMenu,'visible','off');
else
    handles.mode = 'Mask stimulus';
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','on');
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function samplingFormat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beforeStimulusRest.
function beforeStimulusRest_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusRest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
handles.beforeStimulus.rest = not(handles.beforeStimulus.rest);
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of beforeStimulusRest


% --- Executes on button press in useImgBeforeStimuling.
function useImgBeforeStimuling_Callback(hObject, eventdata, handles)
% hObject    handle to useImgBeforeStimuling (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.beforeStimulus.is,
    handles.beforeStimulus.graph = zeros(100,100,3);
    handles.beforeStimulus.is = false;
else
    handles.beforeStimulus.is = true;
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b;
    if handles.beforeStimulus.bar.is
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),1) = ...
                handles.beforeStimulus.bar.r ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),2) = ...
                handles.beforeStimulus.bar.g ;
        handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
            floor(handles.beforeStimulus.bar.posBottom),...
            floor(handles.beforeStimulus.bar.posLeft):...
            floor(handles.beforeStimulus.bar.posRight),3) = ...
                handles.beforeStimulus.bar.b ;
    end
end
axes(handles.beforeStimulusGraph);
imshow(handles.beforeStimulus.graph);   
updateTime(hObject, eventdata, handles);


function beforeStimulusBgndB_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.b = in;
        handles.beforeStimulus.graph(:,:,3) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),3) = ...
                    handles.beforeStimulus.bar.b/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBgndB as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndB as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBgndR_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.r = in;
        handles.beforeStimulus.graph(:,:,1) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),1) = ...
                    handles.beforeStimulus.bar.r/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);

% Hints: get(hObject,'String') returns contents of beforeStimulusBgndR as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndR as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusTime_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.time);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.beforeStimulus.time);
        errordlg('Input must be a number and non negative', 'Error')
    else
        handles.beforeStimulus.time = in;
    end
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function beforeStimulusTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBgndG_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.background.g = in;
        handles.beforeStimulus.graph(:,:,2) = in/255.0;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),2) = ...
                    handles.beforeStimulus.bar.g/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBgndG as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBgndG as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBgndG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBgndG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarLeft_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posLeft;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.beforeStimulus.bar.posRight,
              in = handles.beforeStimulus.bar.posLeft;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Right value', 'Error')
        else
            handles.beforeStimulus.bar.posLeft = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarLeft as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarLeft as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarBottom_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posBottom;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.beforeStimulus.bar.posTop,
              in = handles.beforeStimulus.bar.posBottom;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Top value', 'Error')
        else
            handles.beforeStimulus.bar.posBottom = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarBottom as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarBottom as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarBottom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarBottom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarRight_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posRight;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in < handles.beforeStimulus.bar.posLeft,
              in = handles.beforeStimulus.bar.posRight;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.beforeStimulus.bar.posRight = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarRight as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarRight as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarRight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarTop_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = handles.beforeStimulus.bar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
else if (in>100 || in<1),
  in = handles.beforeStimulus.bar.posTop;
  set(hObject,'String',in);
  errordlg('Input must be a number between 1 and 100', 'Error')
    else if in > handles.beforeStimulus.bar.posBottom,
              in = handles.beforeStimulus.bar.posTop;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Bottom value', 'Error')
        else
            handles.beforeStimulus.bar.posTop = in;
            if handles.beforeStimulus.is,
                handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
                handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
                handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
                if handles.beforeStimulus.bar.is,
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),1) = ...
                            handles.beforeStimulus.bar.r/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),2) = ...
                            handles.beforeStimulus.bar.g/255.0 ;
                    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                        floor(handles.beforeStimulus.bar.posBottom),...
                        floor(handles.beforeStimulus.bar.posLeft):...
                        floor(handles.beforeStimulus.bar.posRight),3) = ...
                            handles.beforeStimulus.bar.b/255.0 ;      
                end
                axes(handles.beforeStimulusGraph);
                imshow(handles.beforeStimulus.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarTop as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarTop as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarTop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarTop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarB_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.b = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),3) = ...
                    handles.beforeStimulus.bar.b/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarB as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarB as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarG_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.g = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),2) = ...
                    handles.beforeStimulus.bar.g/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarG as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarG as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beforeStimulusBottomBarR_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.beforeStimulus.bar.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.beforeStimulus.bar.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.beforeStimulus.bar.r = in;
        if handles.beforeStimulus.bar.is,
            handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
                floor(handles.beforeStimulus.bar.posBottom),...
                floor(handles.beforeStimulus.bar.posLeft):...
                floor(handles.beforeStimulus.bar.posRight),1) = ...
                    handles.beforeStimulus.bar.r/255.0 ;
        end
        if handles.beforeStimulus.is,
            axes(handles.beforeStimulusGraph);
            imshow(handles.beforeStimulus.graph);
        end
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of beforeStimulusBottomBarR as text
%        str2double(get(hObject,'String')) returns contents of beforeStimulusBottomBarR as a double


% --- Executes during object creation, after setting all properties.
function beforeStimulusBottomBarR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in beforeStimulusBottomBar.
function beforeStimulusBottomBar_Callback(hObject, eventdata, handles)
% hObject    handle to beforeStimulusBottomBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.beforeStimulus.bar.is
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
    handles.beforeStimulus.bar.is = false;
else
    handles.beforeStimulus.bar.is = true;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),1) = ...
            handles.beforeStimulus.bar.r/255.0 ;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),2) = ...
            handles.beforeStimulus.bar.g/255.0 ;
    handles.beforeStimulus.graph(floor(handles.beforeStimulus.bar.posTop): ...
        floor(handles.beforeStimulus.bar.posBottom),...
        floor(handles.beforeStimulus.bar.posLeft):...
        floor(handles.beforeStimulus.bar.posRight),3) = ...
            handles.beforeStimulus.bar.b/255.0 ;
end
if handles.beforeStimulus.is,
    axes(handles.beforeStimulusGraph);
    imshow(handles.beforeStimulus.graph); 
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of beforeStimulusBottomBar

% --- Executes on button press in insertBottomBar.
function insertBottomBar_Callback(hObject, eventdata, handles)
% hObject    handle to insertBottomBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if handles.bottomBar.is,
    handles.bottomBar.graph = zeros(100,100,3);
    handles.bottomBar.is = false;
else
    handles.bottomBar.is = true;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),1) = ...
            handles.bottomBar.r ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),2) = ...
            handles.bottomBar.g ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),3) = ...
            handles.bottomBar.b ;
end
    axes(handles.bottomBarGraph);
    imshow(handles.bottomBar.graph);   
    guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of insertBottomBar



function stimulusBottomBarCr_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    set(hObject,'String',handles.sync.analog.r);
    errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseR) ' (base level) and 255'], 'Error')
else
    if (in>255 || in<handles.sync.analog.baseR),
        set(hObject,'String',handles.sync.analog.r);
        errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseR) ' (base level) and 255'], 'Error')
    else
        handles.sync.analog.r = in;
        handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
            floor(handles.sync.analog.posBottom),...
            floor(handles.sync.analog.posLeft):...
            floor(handles.sync.analog.posRight),1) = in/255.0;
        if ~handles.sync.isdigital,
            axes(handles.bottomBarGraph);
            imshow(handles.sync.analog.graph);
        end
    end
end
guidata(hObject,handles)



% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarCg_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    set(hObject,'String',handles.sync.analog.g);
    errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseG) ' (base level) and 255'], 'Error')
else
    if (in>255 || in<handles.sync.analog.baseG),
        set(hObject,'String',handles.sync.analog.g);
        errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseG) ' (base level) and 255'], 'Error')
        disp([in handles.sync.analog.g])
    else
        handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
            floor(handles.sync.analog.posBottom),...
            floor(handles.sync.analog.posLeft):...
            floor(handles.sync.analog.posRight),2) = in/255.0;
        if ~handles.sync.isdigital,
            axes(handles.bottomBarGraph);
            imshow(handles.sync.analog.graph);
        end
        handles.sync.analog.g = in;
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarCg as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarCg as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarCb_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.sync.analog.b);
  errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseB) ' (base level) and 255'], 'Error')
else if (in>255 || in<handles.sync.analog.baseB),
  set(hObject,'String',handles.sync.analog.b);
  errordlg(['Input must be a number between ' num2str(handles.sync.analog.baseB) ' (base level) and 255'], 'Error')
    else
        handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
            floor(handles.sync.analog.posBottom),...
            floor(handles.sync.analog.posLeft):...
            floor(handles.sync.analog.posRight),3) = in/255.0;
        if ~handles.sync.isdigital,
            axes(handles.bottomBarGraph);
            imshow(handles.sync.analog.graph);
        end
        handles.sync.analog.b = in;
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarCb as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarCb as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarCb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarT_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    in = handles.sync.analog.posTop;
    set(hObject,'String',in);
    errordlg('Input must be a number between 1 and 100', 'Error')
else
    if (in>100 || in<1),
        in = handles.sync.analog.posTop;
        set(hObject,'String',in);
        errordlg('Input must be a number between 1 and 100', 'Error')
    else
        if in > handles.sync.analog.posBottom,
              in = handles.sync.analog.posTop;
              set(hObject,'String',in);
              errordlg('Input must be equal or lower than Bottom value', 'Error')
        else
            handles.sync.analog.posTop = in;
            handles.sync.analog.graph = zeros(100,100,3);
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),1) = ...
                    handles.sync.analog.r ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),2) = ...
                    handles.sync.analog.g ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),3) = ...
                    handles.sync.analog.b ;                
            if ~handles.sync.isdigital,
                axes(handles.bottomBarGraph);
                imshow(handles.sync.analog.graph);
            end           
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarT as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarT as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarR_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    in = handles.sync.analog.posRight;
    set(hObject,'String',in);
    errordlg('Input must be a number between 1 and 100', 'Error')
else
    if (in>100 || in<1),
        in = handles.sync.analog.posRight;
        set(hObject,'String',in);
        errordlg('Input must be a number between 1 and 100', 'Error')
    else
        if in < handles.sync.analog.posLeft,
              in = handles.sync.analog.posRight;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.sync.analog.posRight = in;
            handles.sync.analog.graph = zeros(100,100,3);
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),1) = ...
                    handles.sync.analog.r ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),2) = ...
                    handles.sync.analog.g ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),3) = ...
                    handles.sync.analog.b ;                
            if ~handles.sync.isdigital,
                axes(handles.bottomBarGraph);
                imshow(handles.sync.analog.graph);
            end          
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarR as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarR as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarB_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    in = handles.sync.analog.posBottom;
    set(hObject,'String',in);
    errordlg('Input must be a number between 1 and 100', 'Error')
else
    if (in>100 || in<1),
        in = handles.sync.analog.posBottom;
        set(hObject,'String',in);
        errordlg('Input must be a number between 1 and 100', 'Error')
    else
        if in < handles.sync.analog.posTop,
              in = handles.sync.analog.posBottom;
              set(hObject,'String',in);
              errordlg('Input must be equal or higher than Left value', 'Error')
        else
            handles.sync.analog.posBottom = in;
            handles.sync.analog.graph = zeros(100,100,3);
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),1) = ...
                    handles.sync.analog.r ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),2) = ...
                    handles.sync.analog.g ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),3) = ...
                    handles.sync.analog.b ;                
            if ~handles.sync.isdigital,
                axes(handles.bottomBarGraph);
                imshow(handles.sync.analog.graph);
            end        
        end
    end
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarB as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarB as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarL_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
    in = handles.sync.analog.posLeft;
    set(hObject,'String',in);
    errordlg('Input must be a number between 1 and 100', 'Error')
else
    if (in>100 || in<1),
        in = handles.sync.analog.posLeft;
        set(hObject,'String',in);
        errordlg('Input must be a number between 1 and 100', 'Error')
    else
        if in > handles.sync.analog.posRight,
            in = handles.sync.analog.posLeft;
            set(hObject,'String',in);
            errordlg('Input must be equal or lower than Right value', 'Error')
        else
            handles.sync.analog.posLeft = in;
            handles.sync.analog.graph = zeros(100,100,3);
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),1) = ...
                    handles.sync.analog.r ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),2) = ...
                    handles.sync.analog.g ;
            handles.sync.analog.graph(floor(handles.sync.analog.posTop): ...
                floor(handles.sync.analog.posBottom),...
                floor(handles.sync.analog.posLeft):...
                floor(handles.sync.analog.posRight),3) = ...
                    handles.sync.analog.b ;                
            if ~handles.sync.isdigital,
                axes(handles.bottomBarGraph);
                imshow(handles.sync.analog.graph);
            end
        end
    end
end
guidata(hObject,handles) 
% Hints: get(hObject,'String') returns contents of stimulusBottomBarL as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarL as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function beforeStimulusGraph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beforeStimulusGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate beforeStimulusGraph


% --- Executes during object creation, after setting all properties.
function bottomBarGraph_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate bottomBarGraph


% --- Executes during object deletion, before destroying properties.
function bottomBarGraph_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function flickerFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  in = str2double(get(handles.flickerNextFrequency,'String'));
  in = round(1.0/(in*handles.screens.refreshRate))+1;
  set(hObject,'String',1.0/(in*handles.screens.refreshRate));
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<=0,
        in = str2double(get(handles.flickerNextFrequency,'String'));
        in = round(1.0/(in*handles.screens.refreshRate))+1;
        set(hObject,'String',1.0/(in*handles.screens.refreshRate));
        errordlg('Input must be a positive number', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
        previousSteps = get(handles.flickerDcSlider,'SliderStep');
        steps = fps*handles.screens.refreshRate;
        set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
        dc = str2double(get(handles.flickerDc,'String'));
        if steps == 1,
            dc = 100;
        else
            if dc ~= 0 && dc ~= 100
                actualPos = dc/(100*previousSteps(1));
                if steps>previousSteps(1),
                    if mod(round(1.0/steps),2) ~= 0
                        dc = steps*actualPos*100;
                    else
                        dc = steps*(actualPos-1)*100;
                    end
                else 
                    if mod(round(1.0/steps),2) ~= 0 
                        dc = steps*(actualPos+1)*100;
                    else
                        dc = steps*actualPos*100;
                    end
                end
            end
        end
        if dc>100, dc = 100; end
        set(handles.flickerDcSlider, 'Value', dc);
        set(handles.flickerDc, 'String', dc);
        set(hObject,'String',fps);
        if get(handles.flickerFreqConf,'Value')
            handles.flicker.fps = fps;
            handles.flicker.dutyCicle = dc;
%             handles.flicker.time = actualizeTemporalGraph(handles);
        end
    end
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 
% Hints: get(hObject,'String') returns contents of flickerFrequency as text
%        str2double(get(hObject,'String')) returns contents of flickerFrequency as a double


% --- Executes during object creation, after setting all properties.
function flickerFrequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flickerR_Callback(hObject, eventdata, handles)
% hObject    handle to flickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.r = in;
        handles.flicker.graph(:,:,1) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerR as text
%        str2double(get(hObject,'String')) returns contents of flickerR as a double


% --- Executes during object creation, after setting all properties.
function flickerR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerG_Callback(hObject, eventdata, handles)
% hObject    handle to flickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.g = in;
        handles.flicker.graph(:,:,2) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerG as text
%        str2double(get(hObject,'String')) returns contents of flickerG as a double


% --- Executes during object creation, after setting all properties.
function flickerG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerB_Callback(hObject, eventdata, handles)
% hObject    handle to flickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.flicker.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.flicker.b = in;
        handles.flicker.graph(:,:,3) = in/255.0;
        axes(handles.flickerGraph);
        imshow(handles.flicker.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerB as text
%        str2double(get(hObject,'String')) returns contents of flickerB as a double


% --- Executes during object creation, after setting all properties.
function flickerB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationR_Callback(hObject, eventdata, handles)
% hObject    handle to presentationR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.r = in;
        handles.presentation.graph(:,:,1) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationR as text
%        str2double(get(hObject,'String')) returns contents of presentationR as a double


% --- Executes during object creation, after setting all properties.
function presentationR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationG_Callback(hObject, eventdata, handles)
% hObject    handle to presentationG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.g = in;
        handles.presentation.graph(:,:,2) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationG as text
%        str2double(get(hObject,'String')) returns contents of presentationG as a double


% --- Executes during object creation, after setting all properties.
function presentationG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationB_Callback(hObject, eventdata, handles)
% hObject    handle to presentationB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.presentation.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.presentation.b = in;
        handles.presentation.graph(:,:,3) = in/255.0;
        axes(handles.presentationGraph);
        imshow(handles.presentation.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationB as text
%        str2double(get(hObject,'String')) returns contents of presentationB as a double


% --- Executes during object creation, after setting all properties.
function presentationB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    
% --------------------------------------------------------------------
function restart_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
delete *.si;
inputHandles = getInformation('Default Configuration.dsi');
handles = replaceHandles(handles,inputHandles);
setAllGUIParameters(handles);
guidata(hObject,handles);


% --------------------------------------------------------------------
function openFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to openFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
[name, direction] = uigetfile({'*.zip'},'Open configuration file');

if IsWin
    separate = '\';
else
    separate = '/';
end

if name~=0,
    temp = [pwd separate 'temporalFolder'];
    mkdir (temp);
    fileattrib(temp,'+w','a','s');
    unzip(fullfile(direction,name),temp);
    inputHandles = getInformation([temp separate 'Final Configuration.si'],0);
    delete([temp separate 'Final Configuration.si']);
    if inputHandles.screens.refreshRate ~= handles.screens.refreshRate
        msg = sprintf(['The refresh rate of the selected file doesn''t match '...
        'with the actual refresh rate. The difference between them are %d [Hz]\n\n'...
         'Are you shure you want to open this file?'],...
        abs(1.0/handles.screens.refreshRate-1.0/inputHandles.screens.refreshRate));
        q = questdlg(msg,...
        'Different refresh rate','Yes','No','No');
        if isempty(q) || strcmp(q,'No')
            return;
        end
    end  
    delete *.si;
    copyfile([temp separate '*.si'],pwd);
    rmdir(temp,'s');
    handles = replaceHandles(handles,inputHandles);
    setAllGUIParameters(handles);
    guidata(hObject,handles);
end


% --------------------------------------------------------------------
function saveFile_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to saveFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
fileName=sprintf('%04d_%02d_%02d-%02d.%02d.%02d.zip',round(clock));
in = uigetdir(pwd,'Select a directory where the file will be saved');
if in~=0
    name = strtrim(inputdlg('Insert the name of the file to be saved. Remember! the default experiment name used by stimulation scripts is "experiment.zip" and should be located at Documents/Matlab/Experiments/ folder, you are aware!','Insert file name',1,cellstr(fileName)));
    if ~isempty(name)
        saveInformation('Final Configuration.si',handles);
        zip(fullfile(in,name{1}),'*.si');
        selection = questdlg(['Do you want to create a Script ' ...
            'that runs the saved file?'],'Exit','Yes','No','Yes'); 
        if ~isempty(selection) && strcmp(selection,'Yes')
            createScript(fullfile(in,name{1}));
        end
        selection = questdlg(['Do you want to close the ' ...
            'Sampling Interface and Matlab?'],'Exit','Yes','No','Yes'); 
        if isempty(selection)
            return
        end

    end
end
guidata(hObject,handles);


function imgDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to imgDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if ~isempty(in),
    if exist(in,'dir'),
        pos = searchFirstFile(in);
        if pos,
            handles.img.directory = in;
            filelist = dir(in);
            filelist = dir_to_Win_ls(filelist);
            handles.list = char('',filelist(3:size(filelist,1),:));
            set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
            set(handles.imgFinal,'String',char('Final Image',handles.list(2:end,:)));
            set(handles.imgInitial,'Value',pos);
            set(handles.imgFinal,'Value',pos);
            set(handles.nFiles,'String',1);
            handles.img.nInitial = handles.list(pos,:);
            handles.img.nInitialPos = pos;
            handles.img.nFinal = handles.list(pos,:);
            handles.img.nFinalPos = pos;
            handles.img.files = 1;
            imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
            if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 &&...
                    (handles.img.size.width ~= imageInfo.Width || ...
                    handles.img.size.height ~= imageInfo.Height),
                answ = questdlg(['The stimulus of this new folder have different size. '...
                    'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                    'Conserve image position','Yes','No','No');
                if ~isempty(answ) && strcmp(answ,'No'),
                    handles.img.deltaX = 0;
                    handles.img.deltaY = 0;
                    set(handles.imgDeltaX,'String',handles.img.deltaX);
                    set(handles.imgDeltaY,'String',handles.img.deltaY);
                end
            end
            handles.img.size.width = imageInfo.Width;
            handles.img.size.height = imageInfo.Height;
            
            set(handles.imgSizeWidth,'String',handles.img.size.width);
            set(handles.imgSizeHeight,'String',handles.img.size.height);
        else
            errordlg('Directory has no supported image file','Error');
            set(handles.imgDirectory,'String',handles.img.directory);
        end
    else
        errordlg('Directory doesn''t exist','Error');
        set(handles.imgDirectory,'String',handles.img.directory);
    end
else
    errordlg('Directory name can''t be empty','Error');
    set(handles.imgDirectory,'String',handles.img.directory);
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function imgDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject,'String',pwd);


% --- Executes on button press in selectDirectory.
function selectDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to selectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = uigetdir;
if in~=0,
    pos = searchFirstFile(in);
    if pos,
        handles.img.directory = in;
        set(handles.imgDirectory,'String',in);
        filelist = dir(in);
        filelist = dir_to_Win_ls(filelist);
        handles.list = char('',filelist(3:size(filelist,1),:));
        set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
        set(handles.imgFinal,'String',char('Final image',handles.list(2:end,:)));
        set(handles.imgInitial,'Value',pos);
        set(handles.imgFinal,'Value',pos);
        set(handles.nFiles,'String',1);
        handles.img.nInitial = handles.list(pos,:);
        handles.img.nInitialPos = pos;
        handles.img.nFinal = handles.list(pos,:);
        handles.img.nFinalPos = pos;
        imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
        if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 && ...
                (handles.img.size.width ~= imageInfo.Width || ...
                handles.img.size.height ~= imageInfo.Height),
            answ = questdlg(['The stimulus of this new folder have different size. '...
                'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                'Conserve image position','Yes','No','No');
            if ~isempty(answ) && strcmp(answ,'No'),
                handles.img.deltaX = 0;
                handles.img.deltaY = 0;
                set(handles.imgDeltaX,'String',handles.img.deltaX);
                set(handles.imgDeltaY,'String',handles.img.deltaY);
            end
        end
        handles.img.size.width = imageInfo.Width;
        handles.img.size.height = imageInfo.Height;
        set(handles.imgSizeWidth,'String',handles.img.size.width);
        set(handles.imgSizeHeight,'String',handles.img.size.height);
        handles.img.files = 1;
    else
        errordlg('Directory has no supported image files','Error');
        set(handles.imgDirectory,'String',handles.img.directory);
    end
        
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);


% --- Executes on selection change in imgInitial.
function imgInitial_Callback(hObject, eventdata, handles)
% hObject    handle to imgInitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',handles.img.nInitialPos);
    return
end
dirlist = dir(handles.img.directory);
pos = get(hObject,'Value');
if pos~=1 && (dirlist(pos+1).isdir || ~supportedImageFormat(dirlist(pos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.img.nInitialPos);
else if pos~=1
        handles.img.nInitial = handles.list(pos,:);
        handles.img.nInitialPos = pos;
        imageInfo = imfinfo(fullfile(handles.img.directory,handles.img.nInitial));
        if handles.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 && ...
                (handles.img.size.width ~= imageInfo.Width || ...
                handles.img.size.height ~= imageInfo.Height),
            answ = questdlg(['The stimulus of this new folder have different size. '...
                'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
                'Conserve image position','Yes','No','No');
            if ~isempty(answ) && strcmp(answ,'No'),
                handles.img.deltaX = 0;
                handles.img.deltaY = 0;
                set(handles.imgDeltaX,'String',handles.img.deltaX);
                set(handles.imgDeltaY,'String',handles.img.deltaY);
            end
        end
        handles.img.size.width = imageInfo.Width;
        handles.img.size.height = imageInfo.Height;
        set(handles.imgSizeWidth,'String',handles.img.size.width);
        set(handles.imgSizeHeight,'String',handles.img.size.height);
        difference=find((handles.img.nInitial==handles.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.img.nInitial=='.');
            ext = handles.img.nInitial(nExt:end);
            name = handles.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%             ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%             files = 0;
%             for i=nInit:nFinal,
%                 num = sprintf(ns,i);
%                 display(fullfile(handles.img.directory,strcat(name,num,ext)));
%                 if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%                     files = files + 1;
%                 end
%             end
            if nFinal - nInit < 0,
                files = 0;
            else
            files = nFinal - nInit + 1;
            end
            set(handles.nFiles,'String',files);
            handles.img.files = files;
        else
            set(handles.nFiles,'String',1);
            handles.img.files = 1;
            files = 1;
        end
    else
        set(handles.nFiles,'String',0);
        handles.img.files = 0;
    end
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns imgInitial contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgInitial


% --- Executes during object creation, after setting all properties.
function imgInitial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgInitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function imgFinal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in imgFinal.
function imgFinal_Callback(hObject, eventdata, handles)
% hObject    handle to imgFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',handles.img.nInitialPos);
    return
end
dirlist = dir(handles.img.directory);
pos = get(hObject,'Value');
if pos~=1 && (dirlist(pos+1).isdir || ~supportedImageFormat(dirlist(pos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.img.nFinalPos);
else
    if pos~=1,
        handles.img.nFinal = handles.list(pos,:);
        handles.img.nFinalPos = pos;
        difference=find((handles.img.nInitial==handles.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.img.nInitial=='.');
            ext = handles.img.nInitial(nExt:end);
            name = handles.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%             ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%             files = 0;
%             for i=nInit:nFinal,
%                 num = sprintf(ns,i);
%                 if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%                     files = files + 1;
%                 end
%             end
            if nFinal - nInit < 0,
                files = 0;
            else
                files = nFinal - nInit + 1;
            end
            set(handles.nFiles,'String',files);
            handles.img.files = files;
        else
            set(handles.nFiles,'String',1);
            handles.img.files = 1;
            files = 1;
        end

    else
        set(handles.nFiles,'String',0);
        handles.img.files = 0;
    end
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns imgFinal contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imgFinal


% --- Executes on button press in addExperiment.
function addExperiment_Callback(hObject, eventdata, handles)
% hObject    handle to addExperiment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames') && mod(handles.maskStimulus.mask.img.files, handles.sync.digital.frequency/60) ~= 0 
    errordlg(['You are trying to add an experiment with digital sync but the file numbers in Mask Images is not multiple per ' num2str(handles.sync.digital.frequency/60)],'Error');
    return      
end    
[handles.protocol.width, handles.protocol.height] = getProtocolSize(handles);
handles.protocol.useImages = UseImagesProtocol(handles);
if strcmp(handles.mode, 'Mask stimulus'),
    [handles.maskStimulus.mask.width, handles.maskStimulus.mask.height] = getMaskSize(handles);
end

if handles.img.files~=0 ...
        || strcmp(handles.mode,'White noise') ...
        || strcmp(handles.maskStimulus.protocol.type,'Solid color')...
        || strcmp(handles.maskStimulus.protocol.type,'White noise'),
    handles.experiments.number = handles.experiments.number+1;
    handles.experiments.file = [handles.experiments.file handles.experiments.number];
%     save(['Exp' sprintf('%03d',handles.experiments.number) '.si'],'-struct','handles');
    saveInformation(['Exp' sprintf('%03d',handles.experiments.number) '.si'],handles);
    if strcmp(handles.mode,'Flicker'),
        newExp = ['Fl - ' get(handles.nFiles,'String') ' file(s) - ' ...
            num2str(handles.flicker.fps,3) ' [Hz] - ' ...
             num2str(handles.flicker.dutyCicle) '% dutyCicle - ' ...
             num2str(handles.flicker.time,4) ' [s]' ];
         if get(handles.flickerRepWithBackground,'Value') && length(handles.experiments.file)>1
            if exist(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si'],'file'),
                inf = getInformation(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si']);
                if strcmp(inf.mode,'Presentation')
                    handles.time = handles.time + (inf.presentation.time/1000)*handles.flicker.repetitions +...
                        handles.flicker.time*(handles.flicker.repetitions+1);
                end
            else
                errordlg('You are trying to add an experiment with prev. background but you not added a previous background stimulus','Error');
                return            
            end                                        
         else
            handles.time = handles.time + handles.flicker.time;
         end
    elseif strcmp(handles.mode,'Only stimulus (fps)'),
        newExp = ['OS - ' get(handles.nFiles,'String') ' file(s) - ' ...
            num2str(handles.onlyStimulus.fps,3) ' [fps] - '];
             newExp = [newExp num2str(handles.onlyStimulus.time,4) ' [s]' ];
         if get(handles.onlyStimulusRepWithBackground,'Value') && length(handles.experiments.file)>1
            if exist(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si'],'file'),
                inf = getInformation(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si']);
                if strcmp(inf.mode,'Presentation')
                    handles.time = handles.time + (inf.presentation.time/1000)*handles.onlyStimulus.repetitions +...
                        handles.onlyStimulus.time*(handles.onlyStimulus.repetitions+1);
                end
            else
                errordlg('You are trying to add an experiment with prev. background but you not added a previous background stimulus','Error');
                return            
            end                    
         else
            handles.time = handles.time + handles.onlyStimulus.time;
         end
    elseif strcmp(handles.mode,'Mask stimulus')
        switch handles.maskStimulus.protocol.type,
            case 'Flicker'
                newExp = ['MS - P(fl - ' num2str(round(handles.maskStimulus.protocol.flicker.dutyCycle*100))...
                    '% - ' num2str(1000/handles.maskStimulus.protocol.flicker.periodo,'%.1f') '[Hz]) - '...
                    get(handles.nFiles,'String') ' file(s) - '];        
            case 'Images',
                newExp = ['MS - P(OS - ' get(handles.nFiles,'String') ' file(s) - ' ...
                    num2str(handles.maskStimulus.fps,3) '[fps]) - '];        
            case 'Solid color'
                newExp = ['MS - P(SC - ' num2str(handles.maskStimulus.protocol.solidColor.nframes) ...
                    ' frame(s) - ' num2str(handles.maskStimulus.fps,3) '[fps]) - '];        
            case 'White noise'
                newExp = ['MS - P(WN - ' num2str(handles.maskStimulus.protocol.wn.frames) ...
                    ' frame(s) - ' num2str(handles.maskStimulus.fps,3) '[fps]) - '];
            otherwise
                errordlg('You are trying to add a experiment without protocol type','Error');
                return
        end
        switch handles.maskStimulus.mask.type,
            case 'White noise'
                if exist(handles.maskStimulus.mask.wn.seedFile,'file')
                    newExp = [newExp 'M(WN) '];
                else
                    errordlg('You are trying to add a white noise mask without seed file','Error');
                    return
                end        
            case 'Img'
                if handles.maskStimulus.mask.img.files > 0,
                    newExp = [newExp 'M(IMG) ' int2str(handles.maskStimulus.mask.img.files) ' files(s)'];
                else
                    errordlg('You are trying to add an imageless mask','Error');
                    return
                end        
            case 'Solid color'
                newExp = [newExp 'M(SC) '];        
            otherwise
                errordlg('You are trying to add a experiment without mask type','Error');
                return        
        end
        
        newExp = [newExp num2str(handles.maskStimulus.time,5) ' [s]' ];

        if get(handles.maskStimulusRepWithBackground,'Value') && length(handles.experiments.file)>1
            if exist(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si'],'file'),
                inf = getInformation(['Exp' sprintf('%03d',handles.experiments.file(end-1)) '.si']);
                if strcmp(inf.mode,'Presentation')
                    handles.time = handles.time + (inf.presentation.time/1000)*...
                      handles.maskStimulus.repetitions+...
                      (handles.maskStimulus.repetitions+1)*...
                      handles.maskStimulus.time; 
                else
                    errordlg('You are trying to add an experiment with prev. background but you not added a previous background stimulus','Error');
                    return
                end
            else
                errordlg('You are trying to add an experiment with prev. background but you not added a previous background stimulus','Error');
                return
            end
        else
            handles.time = handles.time + handles.maskStimulus.time;
        end
    else
        newExp = ['WN - ' num2str(handles.whitenoise.frames) ' frame(s) - ' ...
            num2str(handles.whitenoise.fps,3) ' [fps] - '];
        newExp = [newExp num2str(handles.whitenoise.time,4) ' [s]' ];
        handles.time = handles.time + handles.whitenoise.time;
    end
    handles.experiments.list = char(handles.experiments.list, newExp);
    handles.img.totalFiles = handles.img.totalFiles + handles.img.files;
    set(handles.experimentList,'String',handles.experiments.list);
    handles.experiments.selected = size(handles.experiments.list,1);
    set(handles.experimentList,'Value',handles.experiments.selected);
    set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
        'HH:MM:SS.FFF'));
    guidata(hObject,handles);
else
    errordlg('You are trying to add an imageless experiment','Error');
end

% --- Executes during object creation, after setting all properties.
function experimentList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to handles.experimentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onlyStimulusImageRepeatition_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusImageRepeatition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.onlyStimulus.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.onlyStimulus.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
    else
        handles.onlyStimulus.repetitions = in;
    end
end
updateTime(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of onlyStimulusImageRepeatition as text
%        str2double(get(hObject,'String')) returns contents of onlyStimulusImageRepeatition as a double


% --- Executes during object creation, after setting all properties.
function onlyStimulusImageRepeatition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onlyStimulusImageRepeatition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function flickerImageRepetition_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImageRepetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
    else
        handles.flicker.repetitions = in;
    end
end
updateTime(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of flickerImageRepetition as text
%        str2double(get(hObject,'String')) returns contents of flickerImageRepetition as a double


% --- Executes during object creation, after setting all properties.
function flickerImageRepetition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImageRepetition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in handles.experimentList.
function experimentList_Callback(hObject, eventdata, handles)
% hObject    handle to handles.experimentList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'Value');
if in == handles.experiments.selected && in ~=1,
    inputH = ['Exp' sprintf('%03d',handles.experiments.file(in)) '.si'];
    inputHprev = ['Exp' sprintf('%03d',handles.experiments.file(in-1)) '.si'];
    if exist(inputHprev,'file'),
        hprev = getInformation(inputHprev);
        if strcmp(hprev.mode,'Presentation'),
            tprev = hprev.presentation.time/1000.0;
        end
    end    
    if length(handles.experiments.file)>= in+1,
        inputHnext = ['Exp' sprintf('%03d',handles.experiments.file(in+1)) '.si'];
        if exist(inputHnext,'file'),
            hnext = getInformation(inputHnext);
            switch hnext.mode
                case 'Flicker'
                    rephnext = hnext.flicker.repeatBackground;
                case 'Only stimulus (fps)'
                    rephnext  = hnext.onlyStimulus.repeatBackground;
                case 'Mask stimulus'
                    rephnext  = hnext.maskStimulus.repeatBackground;
                case 'White noise'
                    rephnext = false;
                otherwise
                    rephnext = false;
            end
        else
            errordlg(['Error no exist the ' inputHnext ' file', 'Error'])
            return            
        end  
    else
        rephnext = false;
    end
    expInformation = getInformation(inputH,'print');
   
    h = getInformation(inputH);
    title = ['Experiment ' num2str(in-1) ' information (' inputH ')'];
    q = questdlg(expInformation,title,'Ok','Delete','Ok');
    if ~isempty(q) && strcmp(q,'Delete'),
        fileIndex = handles.experiments.file(in);
        switch h.mode 
            case 'Flicker'
                if h.flicker.repeatBackground,
                    handles.time = handles.time - (h.flicker.time+tprev)*(h.flicker.repetitions+1)+tprev;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;
                else
                    handles.time = handles.time - h.flicker.time;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;                    
                end
            case 'Only stimulus (fps)'
                if h.onlyStimulus.repeatBackground,
                    handles.time = handles.time - (h.onlyStimulus.time+tprev)*(h.onlyStimulus.repetitions+1)+tprev;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;                    
                else
                    handles.time = handles.time - h.onlyStimulus.time;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;                    
                end                
            case 'Mask stimulus'
                if h.maskStimulus.repeatBackground,
                    handles.time = handles.time - (h.maskStimulus.time+tprev)*(h.maskStimulus.repetitions+1)+tprev;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;                    
                else
                    handles.time = handles.time - h.maskStimulus.time;
                    handles.img.totalFiles = handles.img.totalFiles - handles.img.files;                    
                end                
            case 'White noise'
                handles.time = handles.time - h.whitenoise.time;
            case 'Presentation'
                if rephnext,
                    errordlg('Delete the follow protocol before delete this protocol', 'Error')
                    return
                else
                    handles.time = handles.time - h.presentation.time/1000.0;
                end
        end        
        if in==size(handles.experiments.list,1),
            handles.experiments.list = handles.experiments.list(1:in-1,:);
            handles.experiments.file = handles.experiments.file(1:in-1);
        else
            handles.experiments.list = char(handles.experiments.list(1:in-1,:),handles.experiments.list(in+1:end,:));
            handles.experiments.file = [handles.experiments.file(1:in-1)...
                 handles.experiments.file(in+1:end)];
        end
        set(hObject,'String',handles.experiments.list);
        set(hObject,'Value',in-1);
        handles.experiments.selected = in-1;

        delete(['Exp' sprintf('%03d',fileIndex) '.si']);
        set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
            'HH:MM:SS.FFF'));
    end
else
    handles.experiments.selected = in;
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns handles.experimentList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from handles.experimentList


% --- Executes on button press in downExp.
function downExp_Callback(hObject, eventdata, handles)
% hObject    handle to downExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
pos = get(handles.experimentList,'Value');
if pos~=size(handles.experiments.list,1) && pos~=1
    tmp = handles.experiments.list(pos,:);
    handles.experiments.list(pos,:) = handles.experiments.list(pos+1,:);
    handles.experiments.list(pos+1,:) = tmp;
    set(handles.experimentList,'String',handles.experiments.list);
    set(handles.experimentList,'Value',pos+1);
    handles.experiments.selected = pos+1;
    tmp = handles.experiments.file(pos);
    handles.experiments.file(pos) = handles.experiments.file(pos+1);
    handles.experiments.file(pos+1) = tmp;
end
guidata(hObject,handles);

% --- Executes on button press in upExp.
function upExp_Callback(hObject, eventdata, handles)
% hObject    handle to upExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
pos = get(handles.experimentList,'Value');
if pos>2
    tmp = handles.experiments.list(pos,:);
    handles.experiments.list(pos,:) = handles.experiments.list(pos-1,:);
    handles.experiments.list(pos-1,:) = tmp;
    set(handles.experimentList,'String',handles.experiments.list);
    set(handles.experimentList,'Value',pos-1);
    handles.experiments.selected = pos-1;
    tmp = handles.experiments.file(pos);
    handles.experiments.file(pos) = handles.experiments.file(pos-1);
    handles.experiments.file(pos-1) = tmp;
end
guidata(hObject,handles);


% --- Executes on button press in addPresentation.
function addPresentation_Callback(hObject, eventdata, handles)
% hObject    handle to addPresentation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if handles.presentation.time ~= 0
    handles.experiments.number = handles.experiments.number+1;
    handles.experiments.file = [handles.experiments.file handles.experiments.number];
    tmp = handles.mode;
    handles.mode = 'Presentation';
%     save(['Exp' sprintf('%03d',handles.experiments.number) '.si'],'-struct','handles');
    saveInformation(['Exp' sprintf('%03d',handles.experiments.number) '.si'], handles);
    newExp = ['Background R:' num2str(handles.presentation.r) ' G:'...
         num2str(handles.presentation.g) ' B:' ...
         num2str(handles.presentation.b) ' ' ...
         num2str(handles.presentation.time/1000.0) ' [s]'];
    handles.time = handles.time + handles.presentation.time/1000.0;
    handles.experiments.list = char(handles.experiments.list,newExp);
    set(handles.experimentList,'String',handles.experiments.list);
    handles.experiments.selected = size(handles.experiments.list,1);
    set(handles.experimentList,'Value',handles.experiments.selected);
    set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),...
        'HH:MM:SS.FFF'));
    handles.mode = tmp;
    guidata(hObject,handles);
    
    handles.protocol.width = handles.screens.width;
    handles.protocol.height = handles.screens.height;
else
    errordlg('You are trying to add a timeless background','Error');
end


function presentationTime_Callback(hObject, eventdata, handles)
% hObject    handle to presentationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.presentation.time);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.presentation.time);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if in==0
            warndlg('There''s no sense to set this time to 0','Warning');
        end
        handles.presentation.time = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationTime as text
%        str2double(get(hObject,'String')) returns contents of presentationTime as a double


% --- Executes during object creation, after setting all properties.
function presentationTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function figure1_CloseRequestFcn(hObject,eventdata,hanles)
selection = questdlg(['Are you sure you want to close the ' ...
    'Sampling Interface?'],'Exit','Yes','No','Yes'); 
if isempty(selection)
    return
end
switch selection, 
  case 'Yes',
     delete *.si;
     delete *.dsi;
     Screen('Preference', 'SkipSyncTests', 0);
     Screen('Preference', 'VisualDebugLevel', 4);
     delete(gcf);
    otherwise
     return 
end



function bottomBarDivision_Callback(hObject, eventdata, handles)
% hObject    handle to bottomBarDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.sync.analog.division);
  errordlg('Input must be a natural number', 'Error')
else if in<=0 || mod(in,1)~=0,
  set(hObject,'String',handles.sync.analog.division);
  errordlg('Input must be a natural number', 'Error')
    else
        handles.sync.analog.division = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of bottomBarDivision as text
%        str2double(get(hObject,'String')) returns contents of bottomBarDivision as a double


% --- Executes during object creation, after setting all properties.
function bottomBarDivision_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bottomBarDivision (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in searchScreen.
function searchScreen_Callback(hObject, eventdata, handles)
% hObject    handle to searchScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.screens.list = Screen('Screens')';
handles.screens.selected = handles.screens.list(1);
set(handles.selectScreen,'String',handles.screens.list);
set(handles.selectScreen,'Value',handles.screens.selected+1);
guidata(hObject,handles);

% --- Executes on selection change in selectScreen.
function selectScreen_Callback(hObject, eventdata, handles)
% hObject    handle to selectScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(handles.selectScreen,'Value');
if (handles.screens.selected+1)~=in
    q = questdlg(['If you change the selected screen, the experiment list '...
        'will be erased to ensure the refresh rate concordance. Are you '...
        'shure about the change?'],'Screen selection','Yes','No','Yes');
    if ~isempty(q) && strcmp(q,'Yes')
        handles.screens.selected = get(handles.selectScreen,'Value')-1;
        oldSkip = Screen('Preference', 'SkipSyncTests', 0);
        oldLevel = Screen('Preference', 'VisualDebugLevel', 4);
        [handles.screens.refreshRate,handles.screens.height,handles.screens.width] = ...
            identifyScreen(handles.screens.selected);
        set(handles.screenHeight,'String',handles.screens.height);
        set(handles.screenWidth,'String',handles.screens.width);
        set(handles.screenRefreshRateHz,'String',1.0/handles.screens.refreshRate);
        set(handles.screenRefreshRateMs,'String',handles.screens.refreshRate);
        Screen('Preference', 'SkipSyncTests',oldSkip);
        Screen('Preference', 'VisualDebugLevel', oldLevel);
        delete *.si;
        inputHandles = getInformation('Default Configuration.dsi');
        handles.experiments = inputHandles.experiments;
        handles.flicker.fps = 1.0/(2.0*handles.screens.refreshRate);
        handles.onlyStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
        handles.maskStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
        handles.flicker.dutyCicle = 50;
        setAllGUIParameters(handles);
    end
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns selectScreen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from selectScreen


% --- Executes during object creation, after setting all properties.
function selectScreen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectScreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in selectAll.
function selectAll_Callback(hObject, eventdata, handles)
% hObject    handle to selectAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify || handles.img.nInitialPos == 1
    return
end
pos = searchFirstFile(handles.img.directory);
set(handles.imgInitial,'Value',pos);
handles.img.nInitial = handles.list(pos,:);
handles.img.nInitialPos = pos;
pos = searchLastFile(handles.img.directory);
set(handles.imgFinal,'Value',pos);
handles.img.nFinal = handles.list(pos,:);
handles.img.nFinalPos = pos;
difference=find((handles.img.nInitial==handles.img.nFinal)==0);
if ~isempty(difference),
    nExt = find(handles.img.nInitial=='.');
    ext = handles.img.nInitial(nExt:end);
    name = handles.img.nInitial(1:difference(1)-1);
    nInit = str2double(handles.img.nInitial(difference(1):nExt(end)-1));
    nFinal = str2double(handles.img.nFinal(difference(1):nExt(end)-1));
%    files = 0;
%     ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
%     for i=nInit:nFinal,
%         num = sprintf(ns,i);
%         if exist(fullfile(handles.img.directory,strcat(name,num,ext)),'file'),
%             files = files + 1;
%         end
%     end
    files = nFinal - nInit + 1;
    set(handles.nFiles,'String',files);
    handles.img.files = files;
else
    set(handles.nFiles,'String',1);
    handles.img.files = 1;
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);


% --- Executes on button press in onlyStimulusNextFps.
function onlyStimulusNextFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusNextFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
updateTime(hObject, eventdata, handles)

% --- Executes on button press in onlyStimulusPreviousFps.
function onlyStimulusPreviousFps_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusPreviousFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.onlyStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.onlyStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.onlyStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.onlyStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
updateTime(hObject, eventdata, handles)

% --- Executes on button press in flickerNextFrequency.
function flickerNextFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
else
    set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.flickerFrequency,'String',fps);
previousSteps = get(handles.flickerDcSlider,'SliderStep');
dc = str2double(get(handles.flickerDc,'String'));
steps = fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
if dc ~= 0 && dc ~= 100
    actualPos = dc/(100*previousSteps(1));
    if mod(round(1.0/steps),2) ~= 0
        dc = steps*actualPos*100;
    else
        dc = steps*(actualPos-1)*100;
    end
    set(handles.flickerDcSlider, 'Value', dc);
    set(handles.flickerDc, 'String', dc);
end
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.fps = fps;
    handles.flicker.dutyCicle = dc;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 

% --- Executes on button press in flickerPreviousFrequency.
function flickerPreviousFrequency_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousFrequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
fps = 1.0/(in*handles.screens.refreshRate);
set(handles.flickerFrequency,'String',fps);
if in == 1
    set(handles.flickerNextFrequency,'String',1.0/handles.screens.refreshRate);
else
    set(handles.flickerNextFrequency,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.flickerPreviousFrequency,'String',1.0/((in+1)*handles.screens.refreshRate));
previousSteps = get(handles.flickerDcSlider,'SliderStep');
steps = fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
dc = str2double(get(handles.flickerDc,'String'));
if dc ~= 0 && dc ~= 100
    actualPos = dc/(100*previousSteps(1));
        if mod(round(1.0/steps),2) ~= 0 % To odd
            dc = steps*(actualPos+1)*100;
        else
            dc = steps*actualPos*100;
        end
    set(handles.flickerDcSlider, 'Value', dc);
    set(handles.flickerDc, 'String', dc);
end
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.fps = fps;
    handles.flicker.dutyCicle = dc;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 


% --- Executes on slider movement.
function flickerDcSlider_Callback(hObject, eventdata, handles)
% hObject    handle to flickerDcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if ~handles.modify
    return
end
in = get(hObject,'Value');
if in~=0 && in ~=100
    step = get(hObject,'SliderStep');
    in = 100*step(1)*round(in/(100*step(1)));
end
dc = in;
set(handles.flickerDc,'String',dc);
set(hObject,'Value',dc);
if get(handles.flickerFreqConf,'Value'),
    handles.flicker.dutyCicle = dc;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 

% --- Executes during object creation, after setting all properties.
function flickerDcSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerDcSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject, 'Min', 0);
set(hObject, 'Max', 100);
guidata(hObject,handles);



function flickerDc_Callback(hObject, eventdata, handles)
% hObject    handle to flickerDc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flickerDc as text
%        str2double(get(hObject,'String')) returns contents of flickerDc as a double
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>100 || in<0)
  set(hObject,'String',handles.flicker.dutyCicle);
  errordlg('Input must be a number between 0 and 100', 'Error')
else
    if in~=0 && in ~=100
        step = get(handles.flickerDcSlider,'SliderStep');
        in = 100*step(1)*round(in/(100*step(1)));
    end
    handles.flicker.dutyCicle = in;
    set(hObject,'String',handles.flicker.dutyCicle);
    set(handles.flickerDcSlider,'Value',handles.flicker.dutyCicle);
    axes(handles.flickerSignalGraph);
    periode = 1000.0/handles.flicker.fps;
    t = 0:periode/100.0:periode;
    signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
    area(t,signal); hold on;
    plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
    if handles.flicker.dutyCicle>50
        text(t(round(handles.flicker.dutyCicle)+1)-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
    else
        text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',6.0);
    end
    ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function flickerDc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerDc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerUseImg.
function flickerUseImg_Callback(hObject, eventdata, handles)
% hObject    handle to flickerUseImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if get(hObject,'Value')==1.0
    handles.flicker.img.is = true;
    if ~supportedImageFormat(handles.flicker.img.name)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            handles.flicker.img.is = false;
        else
            handles.flicker.img.name = fullfile(fileDirection,fileName);
            set(handles.flickerImgDirection,'String',handles.flicker.img.name);
        end
    end
else
    handles.flicker.img.is = false;
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of flickerUseImg



function flickerImgDirection_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.flicker.img.name = in;
else
    errordlg('The direction inserted is not a valid image file');
end
set(handles.flickerImgDirection,'String',handles.flicker.img.name);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of flickerImgDirection as text
%        str2double(get(hObject,'String')) returns contents of flickerImgDirection as a double


% --- Executes during object creation, after setting all properties.
function flickerImgDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerSelectImg.
function flickerSelectImg_Callback(hObject, eventdata, handles)
% hObject    handle to flickerSelectImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.flicker.img.name = fullfile(fileDirection,fileName);
    set(handles.flickerImgDirection,'String',handles.flicker.img.name);
end
guidata(hObject,handles);


function stimulusBottomBarLevelR_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
    set(hObject,'String',handles.sync.analog.baseR);
    errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.sync.analog.baseR = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelR as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelR as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarLevelG_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
    set(hObject,'String',handles.sync.analog.baseG);
    errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.sync.analog.baseG = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelG as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelG as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stimulusBottomBarLevelB_Callback(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
    set(hObject,'String',handles.sync.analog.baseB);
    errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.sync.analog.baseB = in;
end
guidata(hObject,handles)
% Hints: get(hObject,'String') returns contents of stimulusBottomBarLevelB as text
%        str2double(get(hObject,'String')) returns contents of stimulusBottomBarLevelB as a double


% --- Executes during object creation, after setting all properties.
function stimulusBottomBarLevelB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stimulusBottomBarLevelB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backgroundColor.
function backgroundColor_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
if handles.img.background.isImg,
    set(hObject,'Value',1.0);
    set(handles.backgroundImg,'Value',0.0);
    handles.img.background.isImg = false;
else
    set(hObject,'Value',1.0);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of backgroundColor


% --- Executes on button press in backgroundImg.
function backgroundImg_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if ~handles.img.background.isImg,
    set(hObject,'Value',1.0);
    set(handles.backgroundColor,'Value',0.0);
    handles.img.background.isImg = true;
    if ~supportedImageFormat(handles.img.background.imgName)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            set(handles.backgroundColor,'Value',1.0);
            handles.img.background.isImg = false;
        else
            handles.img.background.imgName = fullfile(fileDirection,fileName);
            set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
        end
    end
else
    set(hObject,'Value',1.0);
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of backgroundImg



function backgroundR_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.r = in;
    handles.img.background.graph(:,:,1) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundR as text
%        str2double(get(hObject,'String')) returns contents of backgroundR as a double


% --- Executes during object creation, after setting all properties.
function backgroundR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundG_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.g = in;
    handles.img.background.graph(:,:,2) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundG as text
%        str2double(get(hObject,'String')) returns contents of backgroundG as a double


% --- Executes during object creation, after setting all properties.
function backgroundG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundB_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in) || (in>255 || in<0),
  set(hObject,'String',handles.img.background.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    handles.img.background.b = in;
    handles.img.background.graph(:,:,3) = in/255.0;
    axes(handles.imgBackgroundGraph);
    imshow(handles.img.background.graph);
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundB as text
%        str2double(get(hObject,'String')) returns contents of backgroundB as a double


% --- Executes during object creation, after setting all properties.
function backgroundB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function backgroundImgDirection_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.img.background.imgName = in;
else
    errordlg('The direction inserted is not a valid image file');
end
set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of backgroundImgDirection as text
%        str2double(get(hObject,'String')) returns contents of backgroundImgDirection as a double


% --- Executes during object creation, after setting all properties.
function backgroundImgDirection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to backgroundImgDirection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in backgroundImgSelect.
function backgroundImgSelect_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundImgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.img.background.imgName = fullfile(fileDirection,fileName);
    set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
end
guidata(hObject,handles);


% --- Executes on button press in flickerTimeConf.
function flickerTimeConf_Callback(hObject, eventdata, handles)
% hObject    handle to flickerTimeConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if (get(hObject,'Value')==0)
    set(hObject,'Value',1.0);
else
    set(handles.flickerFreqConf,'value',0);
    handles.flicker.fps = 1000/(handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
%     handles.flicker.time = actualizeTemporalGraph(handles);
    handles.flicker.confFrecuencyused = false;
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 
% Hint: get(hObject,'Value') returns toggle state of flickerTimeConf



function flickerImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.imgTime);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.imgTime);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.flickerBackgroundTime,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.flicker.imgTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.flicker.backgroundTime ~= 0 || in ~= 1)
        set(handles.flickerPreviousImgTime,'String',0);
        else
            set(handles.flickerPreviousImgTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.flickerNextImgTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in * handles.screens.refreshRate;
        handles.flicker.imgTime = 1000*in;
        set(hObject,'String',handles.flicker.imgTime);
        if get(handles.flickerTimeConf,'Value'),
            handles.flicker.fps = 1 / (in + str2double(get(handles.flickerBackgroundTime,'String'))/1000);
            handles.flicker.dutyCicle = 100 * handles.flicker.fps * in;
%             handles.flicker.time = actualizeTemporalGraph(handles);            
        end
    end
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 
% Hints: get(hObject,'String') returns contents of flickerImgTime as text
%        str2double(get(hObject,'String')) returns contents of flickerImgTime as a double


% --- Executes during object creation, after setting all properties.
function flickerImgTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flickerBackgroundTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerBackgroundTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.flicker.fps);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.flicker.fps);
  errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.flickerImgTime,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.flicker.backgroundTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.flicker.imgTime ~= 0 || in ~= 1)
            set(handles.flickerPreviousBgndTime,'String',0);
        else
            set(handles.flickerPreviousBgndTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.flickerNextBgndTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in*handles.screens.refreshRate;
        handles.flicker.backgroundTime = 1000*in;
        set(hObject,'String',handles.flicker.backgroundTime);
        if get(handles.flickerTimeConf,'Value'),
            handles.flicker.fps = 1 / (in + str2double(get(handles.flickerImgTime,'String'))/1000);
            handles.flicker.dutyCicle = 100 * (1 - handles.flicker.fps * in);
%             handles.flicker.time = actualizeTemporalGraph(handles);
        end
    end
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 
% Hints: get(hObject,'String') returns contents of flickerBackgroundTime as text
%        str2double(get(hObject,'String')) returns contents of flickerBackgroundTime as a double


% --- Executes during object creation, after setting all properties.
function flickerBackgroundTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flickerBackgroundTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in flickerFreqConf.
function flickerFreqConf_Callback(hObject, eventdata, handles)
% hObject    handle to flickerFreqConf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
if (get(hObject,'Value')==0)
    set(hObject,'Value',1.0);
else
    set(handles.flickerTimeConf,'value',0);
    handles.flicker.fps = str2double(get(handles.flickerFrequency,'String'));
    handles.flicker.dutyCicle = str2double(get(handles.flickerDc,'String'));
%     handles.flicker.time = actualizeTemporalGraph(handles);
    handles.flicker.confFrecuencyused = true;
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 
% Hint: get(hObject,'Value') returns toggle state of flickerFreqConf

function actualizeTemporalGraph(handles)
    axes(handles.flickerSignalGraph);
    periode = 1000.0/handles.flicker.fps;
    t = 0:periode/100.0:periode;
    signal = t < handles.flicker.dutyCicle*t(end)/100.0; 
    area(t,signal); hold on;
    plot(t(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
    if handles.flicker.dutyCicle>50
        text(t(round(handles.flicker.dutyCicle)+1)-6-1.85*periode/10.0,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
    else
        text(t(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(t(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
    end
    ylabel('Signal'),xlabel('Time [ms]'),xlim([0 t(end)]),ylim([0 1.5]); hold off;



% --- Executes on button press in flickerPreviousImgTime.
function flickerPreviousImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.imgTime = rr*round(in/rr);
if handles.flicker.imgTime ~= 0 && ...
        (handles.flicker.backgroundTime ~= 0 || handles.flicker.imgTime ~= rr)
    set(handles.flickerPreviousImgTime,'String',rr*(round(handles.flicker.imgTime/rr)-1));
end
set(handles.flickerNextImgTime,'String',rr*(round(handles.flicker.imgTime/rr)+1));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
end
updateTime(hObject, eventdata, handles)


% --- Executes on button press in flickerNextImgTime.
function flickerNextImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.imgTime = rr*round(in/rr);
set(handles.flickerPreviousImgTime,'String',rr*(round(handles.flicker.imgTime/rr)-1));
set(handles.flickerNextImgTime,'String',rr*(round(handles.flicker.imgTime/rr)+1));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 

% --- Executes on button press in flickerPreviousBgndTime.
function flickerPreviousBgndTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerPreviousBgndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = rr*round(in/rr);
if handles.flicker.backgroundTime ~= 0 && ...
        (handles.flicker.imgTime ~= 0 || handles.flicker.backgroundTime ~= rr)
    set(handles.flickerPreviousBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)-1));
end
set(handles.flickerNextBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)+1));
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 


% --- Executes on button press in flickerNextBgndTime.
function flickerNextBgndTime_Callback(hObject, eventdata, handles)
% hObject    handle to flickerNextBgndTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = rr*round(in/rr);
set(handles.flickerPreviousBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)-1));
set(handles.flickerNextBgndTime,'String',rr*(round(handles.flicker.backgroundTime/rr)+1));
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
if(get(handles.flickerTimeConf,'Value'))
    handles.flicker.fps = 1000 / (handles.flicker.imgTime + handles.flicker.backgroundTime);
    handles.flicker.dutyCicle = 100 * handles.flicker.fps * handles.flicker.imgTime/1000;
%     handles.flicker.time = actualizeTemporalGraph(handles);
end
% guidata(hObject,handles);
updateTime(hObject, eventdata, handles) 


% --- Executes on button press in imgSetPos.
function imgSetPos_Callback(hObject, eventdata, handles)
% hObject    handle to imgSetPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
switch handles.mode
    case 'White noise',
        [~, img] = getRandWNimg(handles.whitenoise);
    case 'Mask stimulus'
        switch handles.maskStimulus.protocol.type,
            case 'Solid color', 
                img = ones(handles.maskStimulus.protocol.solidColor.height, handles.maskStimulus.protocol.solidColor.width, 3);
                img(:,:,1) = img(:,:,1)*handles.maskStimulus.protocol.solidColor.r;
                img(:,:,2) = img(:,:,2)*handles.maskStimulus.protocol.solidColor.g;
                img(:,:,3) = img(:,:,3)*handles.maskStimulus.protocol.solidColor.b;
            case 'White noise',
                [~, img] = getRandWNimg(handles.maskStimulus.protocol.wn);
            otherwise, % 'Images', 'Flicker'
                if exist(fullfile(handles.img.directory,handles.img.nInitial),'file'),
                    img = imread(fullfile(handles.img.directory,handles.img.nInitial));
                else
                    errordlg('The stimulus can not be moved because the images is not loaded.');
                    return
                end
        end
    otherwise,
        if exist(fullfile(handles.img.directory,handles.img.nInitial),'file'),
            img = imread(fullfile(handles.img.directory,handles.img.nInitial));
        else
            errordlg('The stimulus can not be moved because the images is not loaded.');
            return
        end
end


if ismac,
    [handles.img.deltaX,handles.img.deltaY] = moveImageMac(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);
elseif isunix
    [handles.img.deltaX,handles.img.deltaY] = moveImageUnix(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);    
else
    [handles.img.deltaX,handles.img.deltaY] = moveImageWin(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);
end 
set(handles.imgDeltaX,'String',handles.img.deltaX);
set(handles.imgDeltaY,'String',handles.img.deltaY);
guidata(hObject,handles);


function imgDeltaX_Callback(hObject, eventdata, handles)
% hObject    handle to imgDeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if handles.screens.width<handles.img.size.width,
    errordlg('The stimulus can not be moved because the screen width is grater than the stimulus width.');
    set(hObject,'String',handles.img.deltaX);
    return    
end
if isnan(in)
  set(hObject,'String',handles.img.deltaX);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen width less the half of the stimulus size ( -' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' < deltaX < ' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' ).'], 'Error');
else if abs(in)>handles.screens.width/2,
  set(hObject,'String',handles.img.deltaX);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen width less the half of the stimulus size ( -' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' < deltaX < ' ...
      num2str((handles.screens.width-handles.img.size.width)/2) ' ).'], 'Error');
    else
        handles.img.deltaX = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of imgDeltaX as text
%        str2double(get(hObject,'String')) returns contents of imgDeltaX as a double


% --- Executes during object creation, after setting all properties.
function imgDeltaX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDeltaX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imgDeltaY_Callback(hObject, eventdata, handles)
% hObject    handle to imgDeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if handles.screens.height<handles.img.size.height,
    errordlg('The stimulus can not be moved because the screen height is grater than the stimulus height.');
    set(hObject,'String',handles.img.deltaY);
    return
end
if isnan(in)
  set(hObject,'String',handles.img.deltaY);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen height less the half of the stimulus size ( -' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' < deltaY < ' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' ).'], 'Error');
else if abs(in)>handles.screens.height/2,
  set(hObject,'String',handles.img.deltaY);
  errordlg(['Input must be a number between with magnitude lower than the '...
      'half of the screen height less the half of the stimulus size ( -' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' < deltaY < ' ...
      num2str((handles.screens.height-handles.img.size.height)/2) ' ).'], 'Error');
    else
        handles.img.deltaY = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of imgDeltaY as text
%        str2double(get(hObject,'String')) returns contents of imgDeltaY as a double


% --- Executes during object creation, after setting all properties.
function imgDeltaY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgDeltaY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.fps);
  errordlg('Input must be a number and non negative', 'Error')
else if in<0,
  set(hObject,'String',handles.whitenoise.fps);
  errordlg('Input must be a number and non negative', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.whiteNoiseNextFps,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.whiteNoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.whiteNoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
        set(handles.whiteNoiseFps,'String',handles.whitenoise.fps);
    end
end
updateTime(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of whiteNoiseFps as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseFps as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseFps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseBlocks_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.blocks);
  errordlg('Input must be a number and positive', 'Error')
else
    if in<=0,
        set(hObject,'String',handles.whitenoise.blocks);
        errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.blocks = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseBlocks as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseBlocks as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseBlocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in whiteNoiseNextFps.
function whiteNoiseNextFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseNextFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.whiteNoiseNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.whiteNoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.whiteNoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.whiteNoiseFps,'String',handles.whitenoise.fps);
updateTime(hObject, eventdata, handles)

% --- Executes on button press in whiteNoisePreviousFps.
function whiteNoisePreviousFps_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePreviousFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.whitenoise.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.whiteNoiseNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.whiteNoiseNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.whiteNoisePreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.whiteNoiseFps,'String',handles.whitenoise.fps);
updateTime(hObject, eventdata, handles)


function whiteNoisePxsX_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.pxX);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.pxX);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.pxX = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoisePxsX as text
%        str2double(get(hObject,'String')) returns contents of whiteNoisePxsX as a double


% --- Executes during object creation, after setting all properties.
function whiteNoisePxsX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseFrames_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.frames);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.frames);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.frames = in;
    end
end
updateTime(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of whiteNoiseFrames as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseFrames as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseFrames_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in onlyStimulusRepWithBackground.
function onlyStimulusRepWithBackground_Callback(hObject, eventdata, handles)
% hObject    handle to onlyStimulusRepWithBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.onlyStimulus.repeatBackground = get(hObject,'Value');
updateTime(hObject, eventdata, handles)


% --- Executes on button press in flickerRepWithBackground.
function flickerRepWithBackground_Callback(hObject, eventdata, handles)
% hObject    handle to flickerRepWithBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.flicker.repeatBackground = get(hObject,'Value');
updateTime(hObject, eventdata, handles)



function whiteNoiseSaveImages_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.saveImages);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
else
    if (in>handles.whitenoise.frames || in<0),
        set(hObject,'String',handles.whitenoise.saveImages);
        errordlg('Input must be a number between 0 and the number of frames', 'Error')
    else
        handles.whitenoise.saveImages = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseSaveImages as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseSaveImages as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseSaveImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in createRandomSeed.
function createRandomSeed_Callback(hObject, eventdata, handles)
% hObject    handle to createRandomSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng('shuffle');
s = rng;
uisave('s','seed.mat');

% --- Executes on button press in useSeed.
function useSeed_Callback(hObject, eventdata, handles)
% hObject    handle to useSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
value = get(hObject,'Value');
if value && ~isstruct(handles.whitenoise.possibleSeed),
    [s,n,f] = searchForSeed();
    if ~isstruct(s),
        set(hObject,'Value',0.0);
    else
        handles.whitenoise.seed = s;
        set(handles.seedFile,'String',fullfile(f,n));
    end
else
    if value
        handles.whitenoise.seed = handles.whitenoise.possibleSeed;
    end
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of useSeed



function seedFile_Callback(hObject, eventdata, handles)
% hObject    handle to seedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && ~isempty(strfind('.mat',in))
    s = load(in);
    if isstruct(s) && isfield(s,'s') && isfield(s.s,'Type') && isfield(s.s,'Seed') && isfield(s.s,'State')
        handles.whitenoise.possibleSeed = s.s;
        rng(s.s);
        if get(handles.useSeed,'Value')
            handles.whitenoise.seed = s.s;
        end
    else
        set(hObject,'String',handles.whitenoise.seedFile);
        errordlg('File has no seed in the correct format. File must have a struct named as ''s'', which should be the seed.','Error');
    end
else
    set(hObject,'String',handles.whitenoise.seedFile);
    errordlg('File has to be a .mat file with the extension in the name','Error');
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of seedFile as text
%        str2double(get(hObject,'String')) returns contents of seedFile as a double


% --- Executes during object creation, after setting all properties.
function seedFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in seedFileSelect.
function seedFileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to seedFileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
[s,n,f] = searchForSeed();
if isstruct(s)
    handles.whitenoise.possibleSeed = s;
    handles.whitenoise.seedFile = fullfile(f,n);
    set(handles.seedFile,'String',handles.whitenoise.seedFile);
    if get(handles.useSeed,'Value')
        handles.whitenoise.seed = s;
    end
end
guidata(hObject,handles);

function [seed,name,folder]=searchForSeed()
[name,folder] = uigetfile('.mat','Select seed file','seed.mat');
s = load(fullfile(folder,name));
if isstruct(s) && isfield(s,'s') && isfield(s.s,'Type') && isfield(s.s,'Seed') && isfield(s.s,'State')
    seed = s.s;
    rng(seed);
else
    seed = 0;
    errordlg('File has no seed in the correct format. File must have a struct named as ''s'', which should be the seed.','Error');
end


% --- Executes on selection change in noiseMenu.
function noiseMenu_Callback(hObject, eventdata, handles)
% hObject    handle to noiseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
switch in,
    case 1, handles.whitenoise.type = 'BW';
    case 2, handles.whitenoise.type = 'BB';
    case 3, handles.whitenoise.type = 'BG';
    case 4, handles.whitenoise.type = 'BC';
    case 5, handles.whitenoise.type = 'BBGC';
    case 6, handles.whitenoise.type = 'BY';
    case 7, handles.whitenoise.type = 'BLG';
    otherwise, handles.whitenoise.type = 'BW';
end
guidata(hObject,handles);

% Hints: contents = cellstr(get(hObject,'String')) returns noiseMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from noiseMenu


% --- Executes during object creation, after setting all properties.
function noiseMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoisePxsY_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.pxY);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.whitenoise.pxY);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.whitenoise.pxY = in;
        handles.protocol.height = handles.whitenoise.pxY * handles.whitenoise.blocks;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoisePxsY as text
%        str2double(get(hObject,'String')) returns contents of whiteNoisePxsY as a double


% --- Executes during object creation, after setting all properties.
function whiteNoisePxsY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoisePxsY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addTrigger.
function addTrigger_Callback(hObject, eventdata, handles)
% hObject    handle to addTrigger (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of addTrigger
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
handles.bottomBar.useTrigger = get(hObject,'Value');
guidata(hObject,handles);
    



function whiteNoiseIntensityG_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.intensity(2));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.whitenoise.intensity(2));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.whitenoise.intensity(2) = uint8(in);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseIntensityG as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseIntensityG as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseIntensityG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseIntensityB_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.intensity(3));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.whitenoise.intensity(3));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.whitenoise.intensity(3) = uint8(in);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseIntensityB as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseIntensityB as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseIntensityB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function whiteNoiseIntensityR_Callback(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.whitenoise.intensity(1));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.whitenoise.intensity(1));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.whitenoise.intensity(1) = uint8(in);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of whiteNoiseIntensityR as text
%        str2double(get(hObject,'String')) returns contents of whiteNoiseIntensityR as a double


% --- Executes during object creation, after setting all properties.
function whiteNoiseIntensityR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to whiteNoiseIntensityR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusNextFps.
function maskStimulusNextFps_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusNextFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.maskStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.maskStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.maskStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.maskStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.maskStimulusFps,'String',handles.maskStimulus.fps);
updateTime(hObject, eventdata, handles)


function maskStimulusFps_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.fps);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.onlyStimulus.fps);
        errordlg('Input must be a number and non negative', 'Error')
    else
        in = ceil(1.0/(in*handles.screens.refreshRate));
        handles.maskStimulus.fps = 1.0/(in*handles.screens.refreshRate);
        if in == 1
            set(handles.maskStimulusNextFps,'String',1.0/handles.screens.refreshRate);
        else
            set(handles.maskStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
        end
        set(handles.maskStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
        set(handles.maskStimulusFps,'String',handles.maskStimulus.fps);
    end
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function maskStimulusFps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusPreviousFps.
function maskStimulusPreviousFps_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusPreviousFps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
in = round(1.0/(in*handles.screens.refreshRate));
handles.maskStimulus.fps = 1.0/(in*handles.screens.refreshRate);
if in == 1
    set(handles.maskStimulusNextFps,'String',1.0/handles.screens.refreshRate);
else
    set(handles.maskStimulusNextFps,'String',1.0/((in-1)*handles.screens.refreshRate));
end
set(handles.maskStimulusPreviousFps,'String',1.0/((in+1)*handles.screens.refreshRate));
set(handles.maskStimulusFps,'String',handles.maskStimulus.fps);
updateTime(hObject, eventdata, handles)
% guidata(hObject,handles);


% --- Executes on button press in maskStimulusRepWithBackground.
function maskStimulusRepWithBackground_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusRepWithBackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
handles.maskStimulus.repeatBackground = get(hObject,'Value');
updateTime(hObject, eventdata, handles)
% Hint: get(hObject,'Value') returns toggle state of maskStimulusRepWithBackground


% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typeMask.
function typeMask_Callback(hObject, eventdata, handles)
% hObject    handle to typeMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end


in = get(hObject,'Value');
if in==1,
    handles.maskStimulus.mask.type = '';
    handles.maskStimulus.mask.useImages = false;
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    if isempty(handles.maskStimulus.protocol.type),
        set(handles.protocolConfigurationMSPanel,'visible','off');
        set(handles.whitenoiseProtoMSPanel,'visible','off');
        set(handles.imgProtoMSPanel,'visible','off');
        set(handles.solidColorProtoMSPanel,'visible','off');
        set(handles.flickerProtoMSPanel,'visible','off');
    end
    set(handles.otherOptionsPanel,'visible','off');
elseif in == 2,
    handles.maskStimulus.mask.type = 'Solid color';
    handles.maskStimulus.mask.useImages = false;
    set(handles.maskConfigurationMSPanel,'visible','on');
    set(handles.solidcolorMaskMSPanel,'visible','on');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');    
elseif in==3,
    handles.maskStimulus.mask.type = 'Img';
    handles.maskStimulus.mask.useImages = true;
    set(handles.maskConfigurationMSPanel,'visible','on');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','on');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
else
    handles.maskStimulus.mask.type = 'White noise';
    handles.maskStimulus.mask.useImages = false;
    set(handles.maskConfigurationMSPanel,'visible','on');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','on'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
end
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns typeMask contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typeMask


% --- Executes during object creation, after setting all properties.
function typeMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typeProtocol.
function typeProtocol_Callback(hObject, eventdata, handles)
% hObject    handle to typeProtocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end

in = get(hObject,'Value');
if in==1,
    handles.maskStimulus.protocol.type = '';
    
    if isempty(handles.maskStimulus.mask.type),
        set(handles.maskConfigurationMSPanel,'visible','off');
        set(handles.solidcolorMaskMSPanel,'visible','off');
        set(handles.whitenoiseMaskMSPanel,'visible','off'); 
        set(handles.imgMaskMSPanel,'visible','off');
    end
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
elseif in==2,
    handles.maskStimulus.protocol.type = 'Flicker';
    
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','on');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','on'); 
    
    set(handles.otherOptionsPanel,'visible','off');
elseif in==3,
    handles.maskStimulus.protocol.type = 'Images';
    
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','on');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','on');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
elseif in==4,
    handles.maskStimulus.protocol.type = 'Solid color';
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','on');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','on');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
elseif in ==5;
    handles.maskStimulus.protocol.type = 'White noise';
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','on');
    set(handles.whitenoiseProtoMSPanel,'visible','on');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','off');
end
updateTime(hObject, eventdata, handles);
% guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns typeProtocol contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typeProtocol


% --- Executes during object creation, after setting all properties.
function typeProtocol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeProtocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maskStimulusBlockWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusBlockWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.blocks);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.maskStimulus.mask.wn.blocks);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.mask.wn.blocks = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusBlockWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusBlockWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusBlockWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusBlockWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusPxsXWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusPxsXWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.pxX);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.maskStimulus.mask.wn.pxX);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.mask.wn.pxX = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusPxsXWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusPxsXWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusPxsXWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusPxsXWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusPxYWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusPxYWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.pxY);
  errordlg('Input must be a number and positive', 'Error')
else if in<=0,
  set(hObject,'String',handles.maskStimulus.mask.wn.pxY);
  errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.mask.wn.pxY = in;
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusPxYWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusPxYWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusPxYWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusPxYWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in maskStimulusWNType.
function maskStimulusWNType_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusWNType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
switch in,
    case 1, handles.maskStimulus.mask.wn.type = 'BW';
    case 2, handles.maskStimulus.mask.wn.type = 'BB';
    case 3, handles.maskStimulus.mask.wn.type = 'BG';
    case 4, handles.maskStimulus.mask.wn.type = 'BC';
    case 5, handles.maskStimulus.mask.wn.type = 'BBGC';
    case 6, handles.maskStimulus.mask.wn.type = 'BY';
    case 7, handles.maskStimulus.mask.wn.type = 'BLG';
    otherwise, handles.maskStimulus.mask.wn.type = 'BW';
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function maskStimulusWNType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusWNType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusPreviewWN.
function maskStimulusPreviewWN_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusPreviewWN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    if ~handles.modify
        return
    end
    [~, noiseimg] = getRandWNimg(handles.maskStimulus.mask.wn);

    if ismac,
        moveImageMac(handles.img.deltaX,handles.img.deltaY,...
            handles.screens.selected,noiseimg);
    elseif isunix
        moveImageUnix(handles.img.deltaX,handles.img.deltaY,...
            handles.screens.selected,noiseimg);    
    else
        moveImageWin(handles.img.deltaX,handles.img.deltaY,...
            handles.screens.selected,noiseimg);
    end
    guidata(hObject,handles);


% --- Executes on button press in maskStimulusCreateRandomSeed.
function maskStimulusCreateRandomSeed_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusCreateRandomSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
rng('shuffle');
s = rng;
handles.maskStimulus.mask.wn.seed = s;
uisave('s','seed.mat');


function maskStimulusSaveimgWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSaveimgWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.saveImages);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
else if (in>handles.maskStimulus.time*handles.maskStimulus.fps || in<0),
  set(hObject,'String',handles.maskStimulus.mask.wn.saveImages);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
else
    handles.maskStimulus.mask.wn.saveImages = in;
end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSaveimgWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSaveimgWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSaveimgWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSaveimgWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulosUseSeed.
function maskStimulosUseSeed_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulosUseSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
value = get(hObject,'Value');
if value && ~isstruct(handles.maskStimulus.mask.wn.possibleSeed),
    [s,n,f] = searchForSeed();
    if ~isstruct(s),
        set(hObject,'Value',0.0);
    else
        handles.maskStimulus.mask.wn.seed = s;
        handles.maskStimulus.mask.wn.seedFile = fullfile(f,n);
        set(handles.maskStimulusSeedFile,'String',handles.maskStimulus.mask.wn.seedFile);
    end
else
    if value
        handles.maskStimulus.mask.wn.seed = handles.whitenoise.possibleSeed;
    end
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of maskStimulosUseSeed



function maskStimulusSeedFile_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSeedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskStimulusSeedFile as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSeedFile as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSeedFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSeedFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusSeedFileSelect.
function maskStimulusSeedFileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSeedFileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
[s,n,f] = searchForSeed();
if isstruct(s)
    handles.maskStimulus.mask.wn.possibleSeed = s;
    handles.maskStimulus.mask.wn.seedFile = fullfile(f,n);
    set(handles.maskStimulusSeedFile,'String',handles.maskStimulus.mask.wn.seedFile);
    if get(handles.maskStimulosUseSeed,'Value')
        handles.maskStimulus.mask.wn.seed = s;
    end
end

guidata(hObject,handles);



function maskStimulusIntensityBWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityBWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.intensity(3));
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.mask.wn.intensity(3));
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.wn.intensity(3) = uint8(in);
        handles.maskStimulus.mask.wn.graph(:,:,3) = in/255.0;
        axes(handles.MSwhitenoiseIntensityGraph);
        imshow( handles.maskStimulus.mask.wn.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusIntensityBWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusIntensityBWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusIntensityBWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityBWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusIntensityGWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityGWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.intensity(2));
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.mask.wn.intensity(2));
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.wn.intensity(2) = uint8(in);
        handles.maskStimulus.mask.wn.graph(:,:,2) = in/255.0;
        axes(handles.MSwhitenoiseIntensityGraph);
        imshow( handles.maskStimulus.mask.wn.graph);        
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusIntensityGWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusIntensityGWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusIntensityGWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityGWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusIntensityRWNMask_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityRWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.wn.intensity(1));
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.mask.wn.intensity(1));
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.wn.intensity(1) = uint8(in);
        handles.maskStimulus.mask.wn.graph(:,:,1) = in/255.0;
        axes(handles.MSwhitenoiseIntensityGraph);
        imshow( handles.maskStimulus.mask.wn.graph);        
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusIntensityRWNMask as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusIntensityRWNMask as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusIntensityRWNMask_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusIntensityRWNMask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidMaskR_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.solidColor.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.maskStimulus.mask.solidColor.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.solidColor.r = in;
        handles.maskStimulus.mask.solidColor.graph(:,:,1) = in/255.0;
        axes(handles.MSSolidColorGraph);
        imshow(handles.maskStimulus.mask.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidMaskR as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidMaskR as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidMaskR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidMaskG_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.solidColor.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.mask.solidColor.g);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.solidColor.g = in;
        handles.maskStimulus.mask.solidColor.graph(:,:,2) = in/255.0;
        axes(handles.MSSolidColorGraph);
        imshow(handles.maskStimulus.mask.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidMaskG as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidMaskG as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidMaskG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidMaskB_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.mask.solidColor.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.mask.solidColor.b);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.mask.solidColor.b = in;
        handles.maskStimulus.mask.solidColor.graph(:,:,3) = in/255.0;
        axes(handles.MSSolidColorGraph);
        imshow(handles.maskStimulus.mask.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidMaskB as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidMaskB as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidMaskB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidMaskB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusImgMaskFile_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusImgMaskFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.maskStimulus.mask.img.name = in;
else
    errordlg('The direction inserted is not a valid image file');
end
set(handles.maskStimulusImgMaskFile,'String',handles.maskStimulus.mask.img.name);
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusImgMaskFile as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusImgMaskFile as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusImgMaskFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusImgMaskFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusImgMaskSelect1.
function maskStimulusImgMaskSelect1_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusImgMaskSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as mask');
if fileName ~= 0
    handles.maskStimulus.mask.img.name = fullfile(fileDirection,fileName);
    set(handles.maskStimulusImgMaskFile,'String',handles.maskStimulus.mask.img.name);
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function whitenoiseMaskMSPanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to whitenoiseMaskMSPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on maskStimulusWNType and none of its controls.
function maskStimulusWNType_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusWNType (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
switch in,
    case 1, handles.maskStimulus.mask.wn.type = 'BW';
    case 2, handles.maskStimulus.mask.wn.type = 'BB';
    case 3, handles.maskStimulus.mask.wn.type = 'BG';
    case 4, handles.maskStimulus.mask.wn.type = 'BC';
    case 5, handles.maskStimulus.mask.wn.type = 'BBGC';
    case 6, handles.maskStimulus.mask.wn.type = 'BY';
    case 7, handles.maskStimulus.mask.wn.type = 'BLG';
    otherwise, handles.maskStimulus.mask.wn.type = 'BW';
end
guidata(hObject,handles);



function maskStimulusFlickerB_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.b);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.flicker.bg.b = in;
        handles.maskStimulus.protocol.flicker.bg.graph(:,:,3) = in/255.0;
        axes(handles.MSflickerGraph);
        imshow(handles.maskStimulus.protocol.flicker.bg.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusFlickerB as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusFlickerB as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusFlickerB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusFlickerG_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.g);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.flicker.bg.g = in;
        handles.maskStimulus.protocol.flicker.bg.graph(:,:,2) = in/255.0;
        axes(handles.MSflickerGraph);
        imshow(handles.maskStimulus.protocol.flicker.bg.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusFlickerG as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusFlickerG as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusFlickerG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusFlickerR_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.flicker.bg.r);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.flicker.bg.r = in;
        handles.maskStimulus.protocol.flicker.bg.graph(:,:,1) = in/255.0;
        axes(handles.MSflickerGraph);
        imshow(handles.maskStimulus.protocol.flicker.bg.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusFlickerR as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusFlickerR as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusFlickerR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusFlickerImgSelect.
function maskStimulusFlickerImgSelect_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerImgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.maskStimulus.protocol.flicker.bg.name = fullfile(fileDirection,fileName);
    imageInfo = imfinfo(handles.maskStimulus.protocol.flicker.bg.name);
    handles.maskStimulus.protocol.flicker.bg.width = imageInfo.Width;
    handles.maskStimulus.protocol.flicker.bg.height = imageInfo.Height;    
    set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
end
guidata(hObject,handles);


function maskStimulusFlickerImgFile_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
imgpath = get(hObject,'String');
if exist(imgpath,'file');
    try
        imageInfo = imfinfo(imgpath);
    catch
      errordlg('Input must be a image file', 'Error')
      set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
      return
    end
    handles.maskStimulus.protocol.flicker.bg.name = imgpath;
    handles.maskStimulus.protocol.flicker.bg.width = imageInfo.Width;
    handles.maskStimulus.protocol.flicker.bg.height = imageInfo.Height;    
    set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
else
    errordlg('Input must be a image file', 'Error')
    set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function maskStimulusFlickerImgFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerImgFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusFlickerImg.
function maskStimulusFlickerImg_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if get(hObject,'Value')==1.0
    handles.maskStimulus.protocol.flicker.bg.isImg  = true;
    if ~supportedImageFormat(handles.maskStimulus.protocol.flicker.bg.name)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            handles.maskStimulus.protocol.flicker.bg.isImg = false;
        else
            handles.maskStimulus.protocol.flicker.bg.name = fullfile(fileDirection,fileName);
            imageInfo = imfinfo(handles.maskStimulus.protocol.flicker.bg.name);
            handles.maskStimulus.protocol.flicker.bg.width = imageInfo.Width;
            handles.maskStimulus.protocol.flicker.bg.height = imageInfo.Height;
            set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
        end
    end
else
    handles.maskStimulus.protocol.flicker.bg.isImg = false;
end
guidata(hObject,handles);
% Hint: get(hObject,'Value') returns toggle state of maskStimulusFlickerImg


% --- Executes on button press in checkbox77.
function checkbox77_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox77 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox77



function maskStimulusRepeat_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusRepeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.repetitions);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.repetitions);
        errordlg('Input must be a number and non negative', 'Error')
    else
        handles.maskStimulus.repetitions = in;
    end
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function maskStimulusRepeat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusRepeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidColorProtocolR_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.r);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.r);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.r = in;
        handles.maskStimulus.protocol.solidColor.graph(:,:,1) = in/255.0;
        axes(handles.MSsolidcolorProtocolGraph);
        imshow(handles.maskStimulus.protocol.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidColorProtocolR as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidColorProtocolR as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidColorProtocolR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidColorProtocolG_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.g);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.g);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.g = in;
        handles.maskStimulus.protocol.solidColor.graph(:,:,2) = in/255.0;
        axes(handles.MSsolidcolorProtocolGraph);
        imshow(handles.maskStimulus.protocol.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidColorProtocolG as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidColorProtocolG as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidColorProtocolG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusSolidColorProtocolB_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.b);
  errordlg('Input must be a number between 0 and 255', 'Error')
else
    if (in>255 || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.b);
        errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.b = in;
        handles.maskStimulus.protocol.solidColor.graph(:,:,3) = in/255.0;
        axes(handles.MSsolidcolorProtocolGraph);
        imshow(handles.maskStimulus.protocol.solidColor.graph);
    end
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of maskStimulusSolidColorProtocolB as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusSolidColorProtocolB as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidColorProtocolB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorProtocolB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusImgtimeFlicker_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusImgtimeFlicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.flicker.imgTime);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.protocol.flicker.imgTime);
        errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.maskStimulusBackgroundtimeFlicker,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.maskStimulus.protocol.flicker.imgTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.maskStimulus.protocol.flicker.backgroundTime ~= 0 || in ~= 1)
        set(handles.maskStimulusFlickerPreviousImgTime,'String',0);
        else
            set(handles.maskStimulusFlickerPreviousImgTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.maskStimulusFlickerNextImgTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in * handles.screens.refreshRate;
        handles.maskStimulus.protocol.flicker.imgTime = 1000*in;
        handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
        handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime/handles.maskStimulus.protocol.flicker.periodo;       

        set(hObject,'String',handles.maskStimulus.protocol.flicker.imgTime);
    end
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function maskStimulusImgtimeFlicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusImgtimeFlicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskStimulusBackgroundtimeFlicker_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusBackgroundtimeFlicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
        errordlg('Input must be a number and non negative', 'Error')
    else
        if str2double(get(handles.maskStimulusImgtimeFlicker,'String'))==0 && in == 0,
            errordlg('Both, background time and image time can''t be equal to zero simultaneously','Error');
            set(hObject,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
            return
        end
        in = round(in/(1000*handles.screens.refreshRate));
        if in == 0 && (handles.maskStimulus.protocol.flicker.imgTime ~= 0 || in ~= 1)
            set(handles.maskStimulusFlickerPreviousBgTime,'String',0);
        else
            set(handles.maskStimulusFlickerPreviousBgTime,'String',1000*(in-1)*handles.screens.refreshRate);
        end
        set(handles.maskStimulusFlickerNextBgTime,'String',1000*(in+1)*handles.screens.refreshRate);
        in = in*handles.screens.refreshRate;
        handles.maskStimulus.protocol.flicker.backgroundTime = 1000*in;
        set(hObject,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
        handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
        handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime./handles.maskStimulus.protocol.flicker.periodo;

      
    end
end
updateTime(hObject, eventdata, handles);



% --- Executes during object creation, after setting all properties.
function maskStimulusBackgroundtimeFlicker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusBackgroundtimeFlicker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusFlickerPreviousImgTime.
function maskStimulusFlickerPreviousImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerPreviousImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.imgTime = rr*round(in/rr);
if handles.maskStimulus.protocol.flicker.imgTime ~= 0 && ...
        (handles.maskStimulus.protocol.flicker.backgroundTime ~= 0 || handles.maskStimulus.protocol.flicker.imgTime ~= rr)
    set(handles.maskStimulusFlickerPreviousImgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.imgTime/rr)-1));
end
set(handles.maskStimulusFlickerNextImgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.imgTime/rr)+1));
set(handles.maskStimulusImgtimeFlicker,'String',handles.maskStimulus.protocol.flicker.imgTime);

handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime/handles.maskStimulus.protocol.flicker.periodo;

updateTime(hObject, eventdata, handles);


% --- Executes on button press in maskStimulusFlickerNextImgTime.
function maskStimulusFlickerNextImgTime_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerNextImgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.imgTime = rr*round(in/rr);
set(handles.maskStimulusFlickerPreviousImgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.imgTime/rr)-1));
set(handles.maskStimulusFlickerNextImgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.imgTime/rr)+1));
set(handles.maskStimulusImgtimeFlicker,'String',handles.maskStimulus.protocol.flicker.imgTime);
handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime/handles.maskStimulus.protocol.flicker.periodo;
updateTime(hObject, eventdata, handles);


% --- Executes on button press in maskStimulusFlickerPreviousBgTime.
function maskStimulusFlickerPreviousBgTime_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerPreviousBgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.backgroundTime = rr*round(in/rr);
if handles.maskStimulus.protocol.flicker.backgroundTime ~= 0 && ...
        (handles.maskStimulus.protocol.flicker.imgTime ~= 0 || handles.maskStimulus.protocol.flicker.backgroundTime ~= rr)
    set(handles.maskStimulusFlickerPreviousBgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.backgroundTime/rr)-1));
end
set(handles.maskStimulusFlickerNextBgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.backgroundTime/rr)+1));
set(handles.maskStimulusBackgroundtimeFlicker,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime/handles.maskStimulus.protocol.flicker.periodo;
updateTime(hObject, eventdata, handles);


% --- Executes on button press in maskStimulusFlickerNextBgTime.
function maskStimulusFlickerNextBgTime_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusFlickerNextBgTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUID
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
rr = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.backgroundTime = rr*round(in/rr);
set(handles.maskStimulusFlickerPreviousBgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.backgroundTime/rr)-1));
set(handles.maskStimulusFlickerNextBgTime,'String',rr*(round(handles.maskStimulus.protocol.flicker.backgroundTime/rr)+1));
set(handles.maskStimulusBackgroundtimeFlicker,'String',handles.maskStimulus.protocol.flicker.backgroundTime);
handles.maskStimulus.protocol.flicker.periodo = handles.maskStimulus.protocol.flicker.imgTime + handles.maskStimulus.protocol.flicker.backgroundTime;
handles.maskStimulus.protocol.flicker.dutyCycle = handles.maskStimulus.protocol.flicker.imgTime/handles.maskStimulus.protocol.flicker.periodo;
updateTime(hObject, eventdata, handles);




function maskStimulusSolidColorNframesProto_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorNframesProto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.nframes);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.nframes);
        errordlg('Input must be a number and non negative', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.nframes = in;
    end
end
updateTime(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function maskStimulusSolidColorNframesProto_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusSolidColorNframesProto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function maskStimulusWNnFrame_Callback(hObject, eventdata, handles)
% hObject    handle to maskStimulusWNnFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maskStimulusWNnFrame as text
%        str2double(get(hObject,'String')) returns contents of maskStimulusWNnFrame as a double


% --- Executes during object creation, after setting all properties.
function maskStimulusWNnFrame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskStimulusWNnFrame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskstimuluswidthpxSolidColor_Callback(hObject, eventdata, handles)
% hObject    handle to maskstimuluswidthpxSolidColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.width);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.width);
        errordlg('Input must be a number and non negative', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.width = in;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function maskstimuluswidthpxSolidColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskstimuluswidthpxSolidColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maskstimulusheightpxSolidColor_Callback(hObject, eventdata, handles)
% hObject    handle to maskstimulusheightpxSolidColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.solidColor.height);
  errordlg('Input must be a number and non negative', 'Error')
else
    if in<0,
        set(hObject,'String',handles.maskStimulus.protocol.solidColor.height);
        errordlg('Input must be a number and non negative', 'Error')
    else
        handles.maskStimulus.protocol.solidColor.height = in;
        handles.protocol.height = in;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function maskstimulusheightpxSolidColor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maskstimulusheightpxSolidColor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function presentationImg_Callback(hObject, eventdata, handles)
% hObject    handle to presentationImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
in = get(hObject,'String');
if exist(in,'file') && supportedImageFormat(in)
    handles.presentation.img.path = in;
    set(handles.presentationImg,'String',handles.presentation.img.path);
    imageInfo = imfinfo(handles.presentation.img.path);
    handles.presentation.img.size.width = imageInfo.Width;
    handles.presentation.img.size.height = imageInfo.Height;
else
    errordlg('The direction inserted is not a valid image file');
end
guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of presentationImg as text
%        

% --- Executes during object creation, after setting all properties.
function presentationImg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationImg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in presentationImgSelect.
function presentationImgSelect_Callback(hObject, eventdata, handles)
% hObject    handle to presentationImgSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
    ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...
    ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
    ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
[fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
if fileName ~= 0
    handles.presentation.img.path = fullfile(fileDirection,fileName);
    set(handles.presentationImg,'String',handles.presentation.img.path);
    imageInfo = imfinfo(handles.presentation.img.path);
    handles.presentation.img.size.width = imageInfo.Width;
    handles.presentation.img.size.height = imageInfo.Height;
end
guidata(hObject,handles);

% --- Executes on selection change in presentationImgMov.
function presentationImgMov_Callback(hObject, eventdata, handles)
% hObject    handle to presentationImgMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
% Here shift = 0 no shift
%      shift = 1 shift equal to the movement used in the previous stim
%      shift = 2 shift equal to the movement used in the next stim
handles.presentation.img.shift = get(hObject,'Value') - 1;
guidata(hObject,handles);
% Hints: contents = cellstr(get(hObject,'String')) returns presentationImgMov contents as cell array
%        contents{get(hObject,'Value')} returns selected item from presentationImgMov


% --- Executes during object creation, after setting all properties.
function presentationImgMov_CreateFcn(hObject, eventdata, handles)
% hObject    handle to presentationImgMov (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in presentationIsImage.
function presentationIsImage_Callback(hObject, eventdata, handles)
% hObject    handle to presentationIsImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
if ~handles.presentation.img.is,
    set(hObject,'Value',1.0);
    handles.presentation.img.is = true;
    if ~supportedImageFormat(handles.presentation.img.path)
        imgFiles = {['*.bmp;*.gif;*.hdf;*.jpeg;*.jpg;*.jp2;*.jpf;*.jpx;*.j2c;*.j2k'...
            ';*.pbm;*.pcx;*.pgm;*.png;*.pnm;*.ppm;*.ras;*.tiff;*.xwd;*.cur;*.fits;*.ico'],...B-
            ['Image files (*.bmp,*.gif,*.hdf,*.jpeg,*.jpg,*.jp2,*.jpf,*.jpx,*.j2c,*.j2k'...
            ',*.pbm,*.pcx,*.pgm,*.png,*.pnm,*.ppm,*.ras,*.tiff,*.xwd,*.cur,*.fits,*.ico)']};
        [fileName,fileDirection] = uigetfile(imgFiles,'Select image to use as background');
        if fileName == 0
            set(hObject,'Value',0.0);
            handles.presentation.img.is = false;
        else
            handles.presentation.img.path = fullfile(fileDirection,fileName);
            set(handles.presentationImg,'String',handles.presentation.img.path);
            imageInfo = imfinfo(handles.presentation.img.path);
            handles.presentation.img.size.width = imageInfo.Width;
            handles.presentation.img.size.height = imageInfo.Height;
        end
    end
else
    set(hObject,'Value',1.0);
end
guidata(hObject,handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function uipushtool13_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function imgMaskDirectory_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = get(hObject,'String');
if ~isempty(in),
    if exist(in,'dir'),
        pos = searchFirstFile(in);
        if pos,
            handles.maskStimulus.mask.img.directory = in;
            set(handles.imgMaskDirectory,'String',in);
            filelist = dir(in);
            filelist = dir_to_Win_ls(filelist);
            handles.maskStimulus.mask.img.list = char('',filelist(3:size(filelist,1),:));
            set(handles.imgMaskInitial,'String',char('Initial image',handles.maskStimulus.mask.img.list(2:end,:)));
            set(handles.imgMaskFinal,'String',char('Final image',handles.maskStimulus.mask.img.list(2:end,:)));
            set(handles.imgMaskInitial,'Value',pos);
            set(handles.imgMaskFinal,'Value',pos);
            set(handles.imgMasknFiles,'String',1);
            handles.maskStimulus.mask.img.nInitial = handles.maskStimulus.mask.img.list(pos,:);
            handles.maskStimulus.mask.img.nInitialPos = pos;
            handles.maskStimulus.mask.img.nFinal = handles.maskStimulus.mask.img.list(pos,:);
            handles.maskStimulus.mask.img.nFinalPos = pos;
            imageInfo = imfinfo(fullfile(handles.maskStimulus.mask.img.directory,handles.maskStimulus.mask.img.nInitial));
            handles.maskStimulus.mask.img.size.width = imageInfo.Width;
            handles.maskStimulus.mask.img.size.height = imageInfo.Height;
            set(handles.imgMaskSizeWidth,'String',handles.maskStimulus.mask.img.size.width);
            set(handles.imgMaskSizeHeight,'String',handles.maskStimulus.mask.img.size.height);
            handles.maskStimulus.mask.img.files = 1;

        else
            errordlg('Directory has no supported image files','Error');
            set(handles.imgMaskDirectory,'String',handles.maskStimulus.mask.img.directory);
        end
    end 
end


% --- Executes during object creation, after setting all properties.
function imgMaskDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgMaskDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in maskStimulusImgMaskSelect.
function maskStimulusImgMaskSelect_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = uigetdir;
if in~=0,
    pos = searchFirstFile(in);
    if pos,
        finalposition = pos;
        filelist = dir(in);
        filelist = dir_to_Win_ls(filelist);
        if  handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames');
            if (size(filelist,1)-2) < handles.sync.digital.frequency/60
                errordlg(['The directory must have at last ' num2str(handles.sync.digital.frequency/60) ' image files'],'Error');
                set(handles.imgMaskDirectory,'String',handles.maskStimulus.mask.img.directory);
                return
            else
                finalposition = pos+handles.sync.digital.frequency/60-1;
            end
        end
        handles.maskStimulus.mask.img.directory = in;
        set(handles.imgMaskDirectory,'String',in);
        handles.maskStimulus.mask.img.list = char('',filelist(3:size(filelist,1),:));
        set(handles.imgMaskInitial,'String',char('Initial image',handles.maskStimulus.mask.img.list(2:end,:)));
        set(handles.imgMaskFinal,'String',char('Final image',handles.maskStimulus.mask.img.list(2:end,:)));
        set(handles.imgMaskInitial,'Value',pos);
        set(handles.imgMaskFinal,'Value',finalposition);
        set(handles.imgMasknFiles,'String',finalposition - pos +1);
        handles.maskStimulus.mask.img.nInitial = handles.maskStimulus.mask.img.list(pos,:);
        handles.maskStimulus.mask.img.nInitialPos = pos;
        handles.maskStimulus.mask.img.nFinal = handles.maskStimulus.mask.img.list(finalposition,:);
        handles.maskStimulus.mask.img.nFinalPos = finalposition;
        imageInfo = imfinfo(fullfile(handles.maskStimulus.mask.img.directory,handles.maskStimulus.mask.img.nInitial));
        % if handles.maskStimulus.mask.img.size.width ~=0 && handles.img.deltaX~=0 && handles.img.deltaY~=0 && ...
        %         (handles.maskStimulus.mask.img.size.width ~= imageInfo.Width || ...
        %         handles.maskStimulus.mask.img.size.height ~= imageInfo.Height),
        %     answ = questdlg(['The stimulus of this new folder have different size. '...
        %         'Would you like to conserve the default image position (Delta X, Delta Y)?'],...
        %         'Conserve image position','Yes','No','No');
        %     if ~isempty(answ) && strcmp(answ,'No'),
        %         handles.img.deltaX = 0;
        %         handles.img.deltaY = 0;
        %         set(handles.imgDeltaX,'String',handles.img.deltaX);
        %         set(handles.imgDeltaY,'String',handles.img.deltaY);
        %     end
        % end
        handles.maskStimulus.mask.img.size.width = imageInfo.Width;
        handles.maskStimulus.mask.img.size.height = imageInfo.Height;
        set(handles.imgMaskSizeWidth,'String',handles.maskStimulus.mask.img.size.width);
        set(handles.imgMaskSizeHeight,'String',handles.maskStimulus.mask.img.size.height);
        handles.maskStimulus.mask.img.files = finalposition - pos + 1;
  
    else
        errordlg('Directory has no supported image files','Error');
        set(handles.imgMaskDirectory,'String',handles.maskStimulus.mask.img.directory);
    end        
end
guidata(hObject,handles);



% --- Executes on selection change in imgMaskInitial.
function imgMaskInitial_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',handles.maskStimulus.mask.img.nInitialPos);
    return
end
dirlist = dir(handles.maskStimulus.mask.img.directory);
initPos = get(hObject,'Value');
endPos = handles.maskStimulus.mask.img.nFinalPos;
if initPos~=1 && (dirlist(initPos+1).isdir || ~supportedImageFormat(dirlist(initPos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.maskStimulus.mask.img.nInitialPos);
else
    if initPos~=1
        if  handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames');
            [initPos, endPos] = fitNimages(initPos,endPos, handles.sync.digital.frequency/60, size(handles.maskStimulus.mask.img.list,1));
        end      
        handles.maskStimulus.mask.img.nInitial = handles.maskStimulus.mask.img.list(initPos,:);
        handles.maskStimulus.mask.img.nInitialPos = initPos;        
        handles.maskStimulus.mask.img.nFinal = handles.maskStimulus.mask.img.list(endPos,:);
        handles.maskStimulus.mask.img.nFinalPos = endPos;
        set( handles.imgMaskFinal , 'Value', endPos);
        set( handles.imgMaskInitial , 'Value', initPos);

        imageInfo = imfinfo(fullfile(handles.maskStimulus.mask.img.directory,handles.maskStimulus.mask.img.nInitial));
        handles.maskStimulus.mask.img.size.width = imageInfo.Width;
        handles.maskStimulus.mask.img.size.height = imageInfo.Height;
        set(handles.imgMaskSizeWidth,'String',handles.maskStimulus.mask.img.size.width);
        set(handles.imgMaskSizeHeight,'String',handles.maskStimulus.mask.img.size.height);
        difference=find((handles.maskStimulus.mask.img.nInitial==handles.maskStimulus.mask.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.maskStimulus.mask.img.nInitial=='.');
            ext = handles.maskStimulus.mask.img.nInitial(nExt:end);
            name = handles.maskStimulus.mask.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.maskStimulus.mask.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.maskStimulus.mask.img.nFinal(difference(1):nExt(end)-1));
            if nFinal - nInit < 0,
                files = 0;
            else
            	files = nFinal - nInit + 1;
            end
            set(handles.imgMasknFiles,'String',files);
            handles.maskStimulus.mask.img.files = files;
        else
            set(handles.imgMasknFiles,'String',1);
            handles.maskStimulus.mask.img.files = 1;
        end
    else
        set(handles.imgMasknFiles,'String',0);
        handles.maskStimulus.mask.img.files = 0;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function imgMaskInitial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgMaskInitial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% size(handles.maskStimulus.mask.img.list,1)
% handles.sync.digital.frequency/60+1
% fitNimages(pos, )
function [ninitPos, nendPos] = fitNimages(initPos, endPos, minimg, lenList)
    ninitPos = initPos;
    nendPos = endPos;
    if initPos > lenList - minimg
        errordlg(['The directory must have at last ' num2str(handles.sync.digital.frequency/60) ' image files'],'Error');
        ninitPos = lenList - minimg + 1;
        nendPos = lenList;
    else
        if (endPos - initPos) <= minimg 
            nendPos = initPos+minimg-1;
        else
            nendPos = floor((endPos-initPos+1)/minimg)*(minimg)+initPos-1;
        end
    end    

% --- Executes on selection change in imgMaskFinal.
function imgMaskFinal_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',handles.maskStimulus.mask.img.nInitialPos);
    return
end
dirlist = dir(handles.maskStimulus.mask.img.directory);
endPos = get(hObject,'Value');
initPos = handles.maskStimulus.mask.img.nInitialPos;
if endPos~=1 && (dirlist(endPos+1).isdir || ~supportedImageFormat(dirlist(endPos+1).name)),
    errordlg('The selected file is not a supported image file','Error');
    set(hObject,'Value',handles.maskStimulus.mask.img.nFinalPos);
else
    if endPos~=1,
        if  handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames');
            [initPos, endPos] = fitNimages(initPos,endPos, handles.sync.digital.frequency/60, size(handles.maskStimulus.mask.img.list,1));
        end      
        handles.maskStimulus.mask.img.nInitial = handles.maskStimulus.mask.img.list(initPos,:);
        handles.maskStimulus.mask.img.nInitialPos = initPos;        
        handles.maskStimulus.mask.img.nFinal = handles.maskStimulus.mask.img.list(endPos,:);
        handles.maskStimulus.mask.img.nFinalPos = endPos;
        set( handles.imgMaskFinal , 'Value', endPos);
        set( handles.imgMaskInitial , 'Value', initPos);
        difference=find((handles.maskStimulus.mask.img.nInitial==handles.maskStimulus.mask.img.nFinal)==0);
        if ~isempty(difference),
            nExt = find(handles.maskStimulus.mask.img.nInitial=='.');
            ext = handles.maskStimulus.mask.img.nInitial(nExt:end);
            name = handles.maskStimulus.mask.img.nInitial(1:difference(1)-1);
            nInit = str2double(handles.maskStimulus.mask.img.nInitial(difference(1):nExt(end)-1));
            nFinal = str2double(handles.maskStimulus.mask.img.nFinal(difference(1):nExt(end)-1));
            if nFinal - nInit < 0,
                files = 0;
            else
                files = nFinal - nInit + 1;
            end
            set(handles.imgMasknFiles,'String',files);
            handles.maskStimulus.mask.img.files = files;
        else
            set(handles.imgMasknFiles,'String',1);
            handles.maskStimulus.mask.img.files = 1;
        end
    else
        set(handles.imgMasknFiles,'String',0);
        handles.maskStimulus.mask.img.files = 0;
    end
end
updateTime(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function imgMaskFinal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imgMaskFinal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imgMaskSelectAll.
function imgMaskSelectAll_Callback(hObject, eventdata, handles)

if ~handles.modify %|| (handles.maskStimulus.mask.img.nInitial == 1)
    return
end
initPos = searchFirstFile(handles.maskStimulus.mask.img.directory);
endPos = searchLastFile(handles.maskStimulus.mask.img.directory);
if  handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames');
    [initPos, endPos] = fitNimages(initPos,endPos, handles.sync.digital.frequency/60, size(handles.maskStimulus.mask.img.list,1));
end      
handles.maskStimulus.mask.img.nInitial = handles.maskStimulus.mask.img.list(initPos,:);
handles.maskStimulus.mask.img.nInitialPos = initPos;        
handles.maskStimulus.mask.img.nFinal = handles.maskStimulus.mask.img.list(endPos,:);
handles.maskStimulus.mask.img.nFinalPos = endPos;
set( handles.imgMaskFinal , 'Value', endPos);
set( handles.imgMaskInitial , 'Value', initPos);

difference=find((handles.maskStimulus.mask.img.nInitial==handles.maskStimulus.mask.img.nFinal)==0);

if ~isempty(difference),
    nExt = find(handles.maskStimulus.mask.img.nInitial=='.');
    ext = handles.maskStimulus.mask.img.nInitial(nExt:end);
    name = handles.maskStimulus.mask.img.nInitial(1:difference(1)-1);
    nInit = str2double(handles.maskStimulus.mask.img.nInitial(difference(1):nExt(end)-1));
    nFinal = str2double(handles.maskStimulus.mask.img.nFinal(difference(1):nExt(end)-1));
    files = nFinal - nInit + 1;
    set(handles.imgMasknFiles,'String',files);
    handles.maskStimulus.mask.img.files = files;
else
    set(handles.imgMasknFiles,'String',1);
    handles.maskStimulus.mask.img.files = 1;
end
guidata(hObject,handles);



function MSwnProtocolNframe_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.frames);
  errordlg('Input must be a number and positive', 'Error')
else
    if in<=0,
        set(hObject,'String',handles.maskStimulus.protocol.wn.frames);
        errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.protocol.wn.frames = in;
    end
end
updateTime(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function MSwnProtocolNframe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolNframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolXpixel_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.pxX);
  errordlg('Input must be a number and positive', 'Error')
else
    if in<=0,
        set(hObject,'String',handles.maskStimulus.protocol.wn.pxX);
        errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.protocol.wn.pxX = in;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolXpixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolXpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolYpixel_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.pxY);
  errordlg('Input must be a number and positive', 'Error')
else
    if in<=0,
        set(hObject,'String',handles.maskStimulus.protocol.wn.pxY);
        errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.protocol.wn.pxY = in;
        handles.protocol.height = handles.maskStimulus.protocol.wn.pxY ...
            * handles.maskStimulus.protocol.wn.blocks;         
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolYpixel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolYpixel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolBlocks_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.blocks);
  errordlg('Input must be a number and positive', 'Error')
else
    if in<=0,
        set(hObject,'String',handles.maskStimulus.protocol.wn.blocks);
        errordlg('Input must be a number and positive', 'Error')
    else
        handles.maskStimulus.protocol.wn.blocks = in;        
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolBlocks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolBlocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in MSwnProtocolType.
function MSwnProtocolType_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
in = get(hObject,'Value');
switch in,
    case 1, handles.maskStimulus.protocol.wn.type = 'BW';
    case 2, handles.maskStimulus.protocol.wn.type = 'BB';
    case 3, handles.maskStimulus.protocol.wn.type = 'BG';
    case 4, handles.maskStimulus.protocol.wn.type = 'BC';
    case 5, handles.maskStimulus.protocol.wn.type = 'BBGC';
    case 6, handles.maskStimulus.protocol.wn.type = 'BY';
    case 7, handles.maskStimulus.protocol.wn.type = 'BLG';
    otherwise, handles.maskStimulus.protocol.wn.type = 'BW';
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolSaveImages_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.saveImages);
  errordlg('Input must be a number between 0 and the number of frames', 'Error')
else
    if (in>handles.whitenoise.frames || in<0),
        set(hObject,'String',handles.maskStimulus.protocol.wn.saveImages);
        errordlg('Input must be a number between 0 and the number of frames', 'Error')
    else
        handles.maskStimulus.protocol.wn.saveImages = in;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolSaveImages_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolSaveImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MSwnProtocolIntensityG_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(2));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(2));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.wn.intensity(2) = uint8(in);
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolIntensityG_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolIntensityG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolIntensityB_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(3));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(3));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.wn.intensity(3) = uint8(in);
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolIntensityB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolIntensityB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MSwnProtocolIntensityR_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
in = str2double(get(hObject,'String'));
if isnan(in)
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(1));
  errordlg('Input must be a number between 0 and 255', 'Error')
else if (in>255 || in<0),
  set(hObject,'String',handles.maskStimulus.protocol.wn.intensity(1));
  errordlg('Input must be a number between 0 and 255', 'Error')
    else
        handles.maskStimulus.protocol.wn.intensity(1) = uint8(in);
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function MSwnProtocolIntensityR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolIntensityR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MSwnProtocolSeedSelected.
function MSwnProtocolSeedSelected_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
value = get(hObject,'Value');
if value && ~isstruct(handles.maskStimulus.protocol.wn.possibleSeed),
    [s,n,f] = searchForSeed();
    if ~isstruct(s),
        set(hObject,'Value',0.0);
    else
        handles.maskStimulus.protocol.wn.seed = s;
        set(handles.MSwnProtocolSeedPath,'String',fullfile(f,n));
    end
else
    if value
        handles.maskStimulus.protocol.wn.seed = handles.maskStimulus.protocol.wn.possibleSeed;
    end
end
guidata(hObject,handles);



function MSwnProtocolSeedPath_Callback(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolSeedPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MSwnProtocolSeedPath as text
%        str2double(get(hObject,'String')) returns contents of MSwnProtocolSeedPath as a double


% --- Executes during object creation, after setting all properties.
function MSwnProtocolSeedPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MSwnProtocolSeedPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MSwnProtocolSeedfileSelect.
function MSwnProtocolSeedfileSelect_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
[s,n,f] = searchForSeed();
if isstruct(s)
    handles.maskStimulus.protocol.wn.possibleSeed = s;
    handles.maskStimulus.protocol.wn.seedFile = fullfile(f,n);
    set(handles.MSwnProtocolSeedPath,'String',handles.maskStimulus.protocol.wn.seedFile);
    if get(handles.MSwnProtocolSeedSelected,'Value')
        handles.maskStimulus.protocol.wn.seed = s;
    end
end
guidata(hObject,handles);


% --- Executes on button press in MSwnProtocolCreateSeed.
function MSwnProtocolCreateSeed_Callback(hObject, eventdata, handles)
rng('shuffle');
s = rng;
uisave('s','seed.mat');


% --- Executes on selection change in TypeSynchronization.
function TypeSynchronization_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end
type = get(hObject,'Value');
% Here shift = 0 no shift
%      shift = 1 shift equal to the movement used in the previous stim
%      shift = 2 shift equal to the movement used in the next stim
switch type,
    case 1, % no sync
        handles.sync.is = false;
        set(handles.DigitalsyncPanel, 'visible', 'off');
        set(handles.AnalogsyncPanel, 'visible', 'off');
        handles.sync.analog.graph = zeros(100,100,3);
    case 2, % analog
        handles.sync.is = true;
        handles.sync.isdigital = false;
        set(handles.DigitalsyncPanel, 'visible', 'off');
        set(handles.AnalogsyncPanel, 'visible', 'on'); 
        top = floor(handles.sync.analog.posTop);
        bottom = floor(handles.sync.analog.posBottom);
        left = floor(handles.sync.analog.posLeft);
        right = floor(handles.sync.analog.posRight);
        handles.sync.analog.graph(top:bottom, left:right, 1) = handles.sync.analog.r;
        handles.sync.analog.graph(top:bottom, left:right, 2) = handles.sync.analog.g;
        handles.sync.analog.graph(top:bottom, left:right, 3) = handles.sync.analog.b;        
        
    case 3, % digital
        handles.sync.is = true;
        handles.sync.isdigital = true;
        set(handles.DigitalsyncPanel, 'visible', 'on');
        set(handles.AnalogsyncPanel, 'visible', 'off');
        handles.sync.analog.graph = zeros(100,100,3);
    case 4; % Serial
        handles.sync.is = true;
        handles.sync.isdigital = false;
        
        set(handles.DigitalsyncPanel, 'visible', 'off');
        set(handles.AnalogsyncPanel, 'visible', 'off');
        handles.sync.analog.graph = zeros(100,100,3);
end
axes(handles.bottomBarGraph);
imshow(handles.sync.analog.graph); 
updateTime(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function TypeSynchronization_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TypeSynchronization (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in digitalSyncMode.
function digitalSyncMode_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end

mode = get(hObject,'value');
modeList = get(hObject,'String');

if mode == 1, % on every frames
    handles.sync.digital.mode = modeList(mode);
    set(handles.frequencylistDigitalSync,'Visible','On');
    switch handles.sync.digital.frequency,
        case 120,
            set(handles.frequencylistDigitalSync,'value',1);
        case 240,
            set(handles.frequencylistDigitalSync,'value',2);
        case 480,
            set(handles.frequencylistDigitalSync,'value',3);
    end
    set(handles.frequencyDigitalSync,'Visible','On');
else
    set(handles.frequencylistDigitalSync,'Visible','off');
    set(handles.frequencyDigitalSync,'Visible','off');
    handles.sync.digital.mode = modeList(mode);
end
updateTime(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function digitalSyncMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to digitalSyncMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function newFile_ClickedCallback(hObject, eventdata, handles)
SamplingInterface_OpeningFcn(hObject, eventdata, handles, []);


% --------------------------------------------------------------------
function newProtocol_ClickedCallback(hObject, eventdata, handles)
if ~handles.modify
    return
end
delete *.si;
inputHandles = getInformation('Default Configuration.dsi');
handles = replaceHandles(handles,inputHandles);
setAllGUIParameters(handles);
guidata(hObject,handles);


% --- Executes on selection change in frequencylistDigitalSync.
function frequencylistDigitalSync_Callback(hObject, eventdata, handles)
% hObject    handle to frequencylistDigitalSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
frequencyList = str2double(get(hObject,'String'));
handles.sync.digital.frequency = frequencyList(get(hObject,'Value'));
updateTime(hObject, eventdata, handles);



% Hints: contents = cellstr(get(hObject,'String')) returns frequencylistDigitalSync contents as cell array
%        contents{get(hObject,'Value')} returns selected item from frequencylistDigitalSync


% --- Executes during object creation, after setting all properties.
function frequencylistDigitalSync_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequencylistDigitalSync (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in otheroptionList.
function otheroptionList_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',1.0);
    return
end

in = get(hObject,'Value');
if in==1,
    if isempty(handles.maskStimulus.mask.type),
        set(handles.maskConfigurationMSPanel,'visible','off');
        set(handles.solidcolorMaskMSPanel,'visible','off');
        set(handles.whitenoiseMaskMSPanel,'visible','off'); 
        set(handles.imgMaskMSPanel,'visible','off');
    end
    if isempty(handles.maskStimulus.protocol.type),
        set(handles.protocolConfigurationMSPanel,'visible','off');
        set(handles.whitenoiseProtoMSPanel,'visible','off');
        set(handles.imgProtoMSPanel,'visible','off');
        set(handles.solidColorProtoMSPanel,'visible','off');
        set(handles.flickerProtoMSPanel,'visible','off');
    end
    
    set(handles.otherOptionsPanel,'visible','off');
    set(handles.gridmaskPanel,'visible','off');
    set(handles.initialpositionmaskPanel,'visible','off');
    set(handles.autoshiftmaskPanel,'visible','off');
elseif in==2,
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off'); 
    
    set(handles.otherOptionsPanel,'visible','on');
    set(handles.autoshiftmaskPanel,'visible','on');    
    set(handles.gridmaskPanel,'visible','off');
    set(handles.initialpositionmaskPanel,'visible','off');

elseif in==3,
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','on');
    set(handles.autoshiftmaskPanel,'visible','off');    
    set(handles.gridmaskPanel,'visible','on');
    set(handles.initialpositionmaskPanel,'visible','off');
elseif in==4,
    set(handles.maskConfigurationMSPanel,'visible','off');
    set(handles.solidcolorMaskMSPanel,'visible','off');
    set(handles.whitenoiseMaskMSPanel,'visible','off'); 
    set(handles.imgMaskMSPanel,'visible','off');
    
    set(handles.protocolConfigurationMSPanel,'visible','off');
    set(handles.whitenoiseProtoMSPanel,'visible','off');
    set(handles.imgProtoMSPanel,'visible','off');
    set(handles.solidColorProtoMSPanel,'visible','off');
    set(handles.flickerProtoMSPanel,'visible','off');
    
    set(handles.otherOptionsPanel,'visible','on');
    set(handles.autoshiftmaskPanel,'visible','off');    
    set(handles.gridmaskPanel,'visible','off');
    set(handles.initialpositionmaskPanel,'visible','on');
end


% --- Executes during object creation, after setting all properties.
function otheroptionList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to otheroptionList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xspacing_Callback(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
spacing = str2double(get(hObject,'String'));
if isnan(spacing)
  set(hObject,'String',handles.maskStimulus.mask.xspacing);
  errordlg('Input must be a integer number', 'Error')
else
    if spacing < 0,
        set(hObject,'String',handles.maskStimulus.mask.xspacing);
        errordlg('Input do not must be a number less than 0', 'Error')
    else
        handles.maskStimulus.mask.spacing.x = spacing;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function xspacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xspacingrep_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
spacinrep = str2double(get(hObject,'String'));
if isnan(spacinrep)
  set(hObject,'String',handles.maskStimulus.mask.spacing.xrep);
  errordlg('Input must be a integer number', 'Error')
else
    if spacinrep < 0,
        set(hObject,'String',handles.maskStimulus.mask.spacing.xrep);
        errordlg('Input do not must be a number less than 0', 'Error')
    else
        handles.maskStimulus.mask.spacing.xrep = spacinrep;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function xspacingrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yspacing_Callback(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ~handles.modify
    return
end
spacing = str2double(get(hObject,'String'));
if isnan(spacing)
  set(hObject,'String',handles.maskStimulus.mask.spacing.y);
  errordlg('Input must be a integer number', 'Error')
else
    if spacing < 0,
        set(hObject,'String',handles.maskStimulus.mask.spacing.y);
        errordlg('Input do not must be a number less than 0', 'Error')
    else
        handles.maskStimulus.mask.spacing.y = spacing;
    end
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function yspacing_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yspacingrep_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end
rep = str2double(get(hObject,'String'));
if isnan(rep)
  set(hObject,'String',handles.maskStimulus.mask.spacing.yrep);
  errordlg('Input must be a integer number', 'Error')
else
    if rep < 0,
        set(hObject,'String',handles.maskStimulus.mask.spacing.yrep);
        errordlg('Input do not must be a number less than 0', 'Error')
    else
        handles.maskStimulus.mask.spacing.yrep = rep;
    end
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function yspacingrep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xspacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in positionRandom.
function positionRandom_Callback(hObject, eventdata, handles)
if ~handles.modify
    set(hObject,'Value',0.0);
    return
end
handles.maskStimulus.mask.spacing.israndom = ~handles.maskStimulus.mask.spacing.israndom;
disp(handles.maskStimulus.mask.spacing.israndom )
guidata(hObject,handles);



% --- Executes on button press in savePositionRandom.
function savePositionRandom_Callback(hObject, eventdata, handles)
    xrep = handles.maskStimulus.mask.spacing.xrep;
    yrep = handles.maskStimulus.mask.spacing.yrep;
    x = handles.maskStimulus.mask.spacing.x;
    y = handles.maskStimulus.mask.spacing.y;
    israndom = handles.maskStimulus.mask.spacing.israndom;
    [handles.maskStimulus.mask.spacing.xposition , handles.maskStimulus.mask.spacing.yposition] = ...
        positionmask(xrep,yrep,x,y,israndom);
    xposition = handles.maskStimulus.mask.spacing.xposition;
    yposition = handles.maskStimulus.mask.spacing.yposition;

    [FileName,PathName] = uiputfile('*.mat','Save position random struct','positionrandom');
    handles.maskStimulus.mask.spacing.pathfile = fullfile(PathName,FileName);
    save(handles.maskStimulus.mask.spacing.pathfile,'xposition','yposition','xrep','yrep','x','y','israndom');    
    set(handles.pathPositionRandom,'String',handles.maskStimulus.mask.spacing.pathfile);
    
    guidata(hObject,handles)

% --- Executes on button press in loadPositionRandom.
function loadPositionRandom_Callback(hObject, eventdata, handles)
if ~handles.modify
    return
end

[name,folder] = uigetfile('.mat','Select seed file','positionrandom.mat');
positionshift = load(fullfile(folder,name));
if isstruct(positionshift) && isfield(positionshift,'x') && isfield(positionshift,'y') 
    handles.maskStimulus.mask.spacing.xposition = positionshift.xposition;
    handles.maskStimulus.mask.spacing.yposition = positionshift.yposition;
    handles.maskStimulus.mask.spacing.xrep = positionshift.xrep;
    handles.maskStimulus.mask.spacing.yrep = positionshift.yrep;
    handles.maskStimulus.mask.spacing.x = positionshift.x;
    handles.maskStimulus.mask.spacing.y = positionshift.y;
    handles.maskStimulus.mask.spacing.israndom = positionshift.israndom;
    handles.maskStimulus.mask.spacing.pathfile = fullfile(folder,name);
else
    errordlg('The file do not has correct format.','Error');
end

set(handles.xspacing,'String',handles.maskStimulus.mask.spacing.x);
set(handles.yspacing,'String',handles.maskStimulus.mask.spacing.y);
set(handles.xspacingrep,'String',handles.maskStimulus.mask.spacing.xrep);
set(handles.yspacingrep,'String',handles.maskStimulus.mask.spacing.yrep);
set(handles.positionRandom,'Value',handles.maskStimulus.mask.spacing.israndom);
set(handles.pathPositionRandom,'String',handles.maskStimulus.mask.spacing.pathfile);
guidata(hObject,handles)



function pathPositionRandom_Callback(hObject, eventdata, handles)
% hObject    handle to pathPositionRandom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pathPositionRandom as text
%        str2double(get(hObject,'String')) returns contents of pathPositionRandom as a double


% --- Executes during object creation, after setting all properties.
function pathPositionRandom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathPositionRandom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inverstedMask.
function inverstedMask_Callback(hObject, eventdata, handles)
handles.maskStimulus.mask.inverse = get(hObject,'Value');
guidata(hObject,handles)
