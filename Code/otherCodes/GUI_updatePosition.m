function varargout = GUI_updatePosition(varargin)
% UPDATEPOSITION MATLAB code for GUI_updatePosition.fig
%      UPDATEPOSITION, by itself, creates a new UPDATEPOSITION or raises the existing
%      singleton*.
%
%      H = UPDATEPOSITION returns the handle to a new UPDATEPOSITION or the handle to
%      the existing singleton*.
%
%      UPDATEPOSITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UPDATEPOSITION.M with the given infile arguments.
%
%      UPDATEPOSITION('Property','Value',...) creates a new UPDATEPOSITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_updatePosition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All infiles are passed to GUI_updatePosition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_updatePosition

% Last Modified by GUIDE v2.5 25-Jul-2017 15:13:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_updatePosition_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_updatePosition_OutputFcn, ...
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


% --- Executes just before GUI_updatePosition is made visible.
function GUI_updatePosition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no outfile args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_updatePosition (see VARARGIN)
addpath('../lib/')
handles.infile.folder = '';
handles.infile.name = '';
handles.ofile.folder = '';
handles.ofile.name = '';
handles.ndx = '';
handles.ndy = '';
% Choose default command line outfile for GUI_updatePosition
handles.outfile = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_updatePosition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_updatePosition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning outfile args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line outfile from handles structure
varargout{1} = handles.outfile;



function originalpath_Callback(hObject, eventdata, handles)
% hObject    handle to originalpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of originalpath as text
%        str2double(get(hObject,'String')) returns contents of originalpath as a double
filename = get(hObject,'String');
if exist(filename,'file')
    [pathstr,name,ext] = fileparts(filename); 
    handles.infile.name = [name,ext];
    handles.infile.folder = pathstr;
    set(handles.originalpath,'String',fullfile(pathstr,[name,ext]));
    guidata(hObject,handles)
else
    errordlg('File does not exist', 'Error')
    set(handles.originalpath,'String',fullfile(handles.infile.folder,handles.infile.name));
end


% --- Executes during object creation, after setting all properties.
function originalpath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to originalpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function savepathTXT_Callback(hObject, eventdata, handles)
filename = get(hObject,'String');
[pathstr,name,ext] = fileparts(filename(:)'); 
if exist(pathstr,'dir')
    handles.ofile.name = [name,ext];
    handles.ofile.folder = pathstr;
    set(handles.savepathTXT,'String',fullfile(pathstr,[name,ext]));
    guidata(hObject,handles)
else
    errordlg('Folder does not exist', 'Error')
    set(handles.savepathTXT,'String',fullfile(handles.ofile.folder,handles.ofile.name));
end


% --- Executes during object creation, after setting all properties.
function savepathTXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to savepathTXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadButtom.
function loadButtom_Callback(hObject, eventdata, handles)
% hObject    handle to loadButtom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name,folder] = uigetfile('.zip','Select original file');
handles.infile.name = name;
handles.infile.folder = folder;
set(handles.originalpath,'String',fullfile(folder,name));

infileFile = fullfile(handles.infile.folder,handles.infile.name);
mkdir tmp2
delete ./tmp2/*.si
system(['unzip ' strrep(infileFile,' ','\ ') ' -d ./tmp2']);
fileName = '/tmp2/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    data = getInformation(fullfile(pwd,fileName));
    
    handles.ndx = data.img.deltaX;
    handles.ndy = data.img.deltaY;
    set(handles.Dx,'String',handles.ndx);
    set(handles.Dy,'String',handles.ndy);
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end	
rmdir('tmp2','s');

guidata(hObject,handles)


% --- Executes on button press in savebuttom.
function savebuttom_Callback(hObject, eventdata, handles)
% hObject    handle to savebuttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[name,folder] = uiputfile('*.zip','Save corrected file');
handles.ofile.name = name;
handles.ofile.folder = folder;
set(handles.savepathTXT,'String',fullfile(folder,name));
guidata(hObject,handles)


% --- Executes on button press in startbuttom.
function startbuttom_Callback(hObject, eventdata, handles)
addpath('../lib/')

% hObject    handle to startbuttom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infileFile = fullfile(handles.infile.folder,handles.infile.name);
% outfileFile = fullfile(handles.ofile.folder,handles.ofile.name);
% updatePosition(infileFile,outfileFile)
mkdir tmp2
delete ./tmp2/*.si
system(['unzip ' strrep(infileFile,' ','\ ') ' -d ./tmp2']);
fileName = '/tmp2/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    data = getInformation(fullfile(pwd,fileName));
    img = ones(data.protocol.height,data.protocol.width)*255;
    if IsOSX,
        [ndx,ndy] = moveImageMac(data.img.deltaX,data.img.deltaY, data.screens.selected,img);
    elseif IsLinux
        [ndx,ndy] = moveImageUnix(data.img.deltaX,data.img.deltaY, data.screens.selected,img);    
    else
        [ndx,ndy] = moveImageWin(data.img.deltaX,data.img.deltaY, data.screens.selected,img);
    end 
    disp(['PROTOCOLS centered to x:',num2str(ndx),' px y: ',num2str(ndy), 'px.'])
    handles.ndx = ndx;
    handles.ndy = ndy;
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end	
rmdir('tmp2','s');
guidata(hObject,handles)




% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
infileFile = fullfile(handles.infile.folder,handles.infile.name);
outfileFile = fullfile(handles.ofile.folder,handles.ofile.name);
mkdir tmp2
delete ./tmp2/*.si
system(['unzip ' strrep(infileFile,' ','\ ') ' -d ./tmp2']);
fileName = '/tmp2/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    data = getInformation(fullfile(pwd,fileName));
    for i=length(data.experiments.file)-1:-1:1,
        fileName2 = ['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'];
        if exist(fullfile(pwd,fileName2),'file'),
            experiment = getInformation(fullfile(pwd,fileName2));
            disp([experiment.img.deltaY experiment.img.deltaX handles.ndy handles.ndx])
            experiment.img.deltaY = handles.ndy;
            experiment.img.deltaX = handles.ndx;
            disp([experiment.img.deltaY experiment.img.deltaX handles.ndy handles.ndx])
            save(['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'],'-struct','experiment');
        end
    end
    data.img.deltaY = handles.ndy;
    data.img.deltaX = handles.ndx;
    save('./tmp2/Final Configuration.si','-struct','data');

    zip(outfileFile,'*.si','./tmp2/');
    rmdir('tmp2','s');
    disp('New protocol was create')
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end	 



function Dx_Callback(hObject, eventdata, handles)
    dx = str2double(get(hObject,'String'));
    handles.ndx = round(dx);
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Dy_Callback(hObject, eventdata, handles)
    dy = str2double(get(hObject,'String'));
    handles.ndy = round(dy);
    guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function Dy_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Dy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
