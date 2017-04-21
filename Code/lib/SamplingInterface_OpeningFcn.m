function SamplingInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% Own GUI function that set all parameters of handles struct 
% with initial values
%
% It's Executed just before SamplingInterface is made visible.

delete *.si;

% Set the parameters of <<<Sample format Panel>>
handles.mode = 'Flicker';

% Set the parameters of <<<General options Panel>>
handles.img.directory='...';
filelist = dir_to_Win_ls(dir(handles.img.directory));
handles.list = char('',filelist(3:size(filelist,1),:));
pos = searchFirstFile(handles.img.directory);
if pos==0,
    pos=1;
    handles.img.files = 0;
    handles.img.size.width = 0;
    handles.img.size.height = 0;
else
    handles.img.files = 1;
    imageInfo = imfinfo(fullfile(handles.img.directory,handles.list(pos,:)));
    handles.img.size.width = imageInfo.Width;
    handles.img.size.height = imageInfo.Height;
end
handles.img.totalFiles = 0;
handles.img.nInitial = handles.list(pos,:);
handles.img.nInitialPos = pos;
handles.img.nFinal = handles.list(pos,:);
handles.img.nFinalPos = pos;
handles.img.deltaX = 0;
handles.img.deltaY = 0;
handles.img.background.isImg = false;
handles.img.background.r = 0;
handles.img.background.g = 0;
handles.img.background.b = 0;
handles.img.background.imgName = '...';
handles.img.background.graph = zeros(1,1,3);

% Set the parameters of <<<Reproduction list Panel>>
handles.experiments.number = 0;
handles.experiments.selected = 1;
handles.experiments.file = 0;
handles.experiments.list = 'List of experimets to execute';
handles.time = 0;

% Set the parameters of <<<Selection Screen Panel>>
oldSkip = Screen('Preference', 'SkipSyncTests', 0);
oldLevel = Screen('Preference', 'VisualDebugLevel', 4);
handles.screens.list = Screen('Screens')';
handles.screens.selected = handles.screens.list(end);
[handles.screens.refreshRate,handles.screens.height,handles.screens.width] = ...
    identifyScreen(handles.screens.selected);
Screen('Preference', 'SkipSyncTests',oldSkip);
Screen('Preference', 'VisualDebugLevel', oldLevel);



% Set the parameters of <<<Sample format Panel subsection Digital Signal>>
% handles.bottomBar.is = false;
% handles.bottomBar.useTrigger = false;
% handles.bottomBar.r = 255;
% handles.bottomBar.baseR = 125;
% handles.bottomBar.g = 0;
% handles.bottomBar.baseG = 0;
% handles.bottomBar.b = 0;
% handles.bottomBar.baseB = 0;
% handles.bottomBar.posLeft = 1;
% handles.bottomBar.posTop = 85;
% handles.bottomBar.posRight = 100;
% handles.bottomBar.posBottom = 100;
% handles.bottomBar.division = 4;
% handles.bottomBar.graph = zeros(100,100,3);

handles.sync.is = false;
handles.sync.isdigital = false;
handles.sync.digital.mode = 'On every frames'; % use trigger -> 'Start and end' 'On every frames'
handles.sync.analog.r = 255;
handles.sync.analog.baseR = 125;
handles.sync.analog.g = 0;
handles.sync.analog.baseG = 0;
handles.sync.analog.b = 0;
handles.sync.analog.baseB = 0;
handles.sync.analog.posLeft = 1;
handles.sync.analog.posTop = 85;
handles.sync.analog.posRight = 100;
handles.sync.analog.posBottom = 100;
handles.sync.analog.division = 4;
handles.sync.analog.graph = zeros(100,100,3);

% Set the parameters of <<<Image before stimuling Panel>>
handles.beforeStimulus.is = false;
handles.beforeStimulus.time = 50;
handles.beforeStimulus.rest = false;
handles.beforeStimulus.background.r = 0;
handles.beforeStimulus.background.g = 0;
handles.beforeStimulus.background.b = 0;
handles.beforeStimulus.bar.is = false;
handles.beforeStimulus.bar.r = 255;
handles.beforeStimulus.bar.g = 0;
handles.beforeStimulus.bar.b = 0;
handles.beforeStimulus.bar.posLeft = 1;
handles.beforeStimulus.bar.posTop = 85;
handles.beforeStimulus.bar.posRight = 100;
handles.beforeStimulus.bar.posBottom = 100;
handles.beforeStimulus.graph = zeros(100,100,3);
axes(handles.beforeStimulusGraph);
imshow(handles.beforeStimulus.graph);

% Set general parameter of protocol
% to do 
handles.protocol.width = 0;
handles.protocol.height = 0;
handles.protocol.useImages = false;



% Set the parameters of <<<Option using only Background Panel>>
handles.presentation.r = 0;
handles.presentation.g = 0;
handles.presentation.b = 0;
handles.presentation.time = 1000;
handles.presentation.graph = zeros(1,1,3);
handles.presentation.img.is = false;
handles.presentation.img.path = '...';
handles.presentation.img.shift = 0;
handles.presentation.img.size.width = 0;
handles.presentation.img.size.height = 0;

% Set the parameters of <<<Option using Flicker stimulus Panel>>
handles.flicker.time = 0;
handles.flicker.fps = 1.0/(2.0*handles.screens.refreshRate);
handles.flicker.dutyCicle = 50;
handles.flicker.imgTime = handles.screens.refreshRate*1000;
handles.flicker.backgroundTime = handles.screens.refreshRate*1000;
handles.flicker.repetitions = 0;
handles.flicker.repeatBackground = false;
handles.flicker.r = 0;
handles.flicker.g = 0;
handles.flicker.b = 0;
handles.flicker.img.name = '...';
handles.flicker.img.is = false;
handles.flicker.graph = zeros(1,1,3);
handles.flicker.time = handles.img.files...
            * 1/handles.flicker.fps * (handles.flicker.repetitions+1);
handles.flicker.confFrecuencyused = true;        

% Set the parameters of <<<Option using only Stimulus Panel>>
handles.onlyStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
handles.onlyStimulus.repetitions = 0;
handles.onlyStimulus.repeatBackground = false;
handles.onlyStimulus.time = handles.img.files...
    * 1/handles.onlyStimulus.fps * (handles.onlyStimulus.repetitions+1);

% Set the parameters of <<<Option using white noise Stimulus Panel>>
handles.whitenoise.fps = 30;
handles.whitenoise.blocks = 100;
handles.whitenoise.pxX = 5;
handles.whitenoise.pxY = 5;
handles.whitenoise.reduceSide = 0;
handles.whitenoise.type = 'BW';
handles.whitenoise.frames = 1000;
handles.whitenoise.saveImages = 3;
rng('shuffle');
handles.whitenoise.intensity = uint8([255 255 255]);
handles.whitenoise.seed = rng;
handles.whitenoise.possibleSeed = 0;
handles.whitenoise.seedFile ='...';
handles.whitenoise.time = handles.whitenoise.frames * 1/handles.whitenoise.fps;

% Set the parameters of <<<Option using Mask Stimulus Panel>>
handles.maskStimulus.fps = 1.0/(2.0*handles.screens.refreshRate);
handles.maskStimulus.repeatBackground = false;
handles.maskStimulus.mask.useImages = false;
handles.maskStimulus.mask.width = 0;
handles.maskStimulus.mask.height = 0;
handles.maskStimulus.mask.type = 'background';%('White noise' 'Img' 'Solid color')
handles.maskStimulus.mask.wn.blocks = 100;
handles.maskStimulus.mask.wn.pxY = 5;
handles.maskStimulus.mask.wn.pxX = 5;
handles.maskStimulus.mask.wn.type = 'BW';
handles.maskStimulus.mask.wn.saveImages = 3;
handles.maskStimulus.mask.wn.intensity = [ 255, 255, 255 ];
handles.maskStimulus.mask.wn.seed = rng;
handles.maskStimulus.mask.wn.possibleSeed = 0;
handles.maskStimulus.mask.wn.seedFile ='...';
handles.maskStimulus.mask.wn.graph = zeros(1,1,3);

% handles.maskStimulus.mask.img.name = '...';
handles.maskStimulus.mask.img.directory = '...';
handles.maskStimulus.mask.img.list = 0;
handles.maskStimulus.mask.img.nInitial = 0;
handles.maskStimulus.mask.img.nInitialPos = 1;
handles.maskStimulus.mask.img.nFinal = 0;
handles.maskStimulus.mask.img.nFinalPos = 1;
handles.maskStimulus.mask.img.size.width = 0;
handles.maskStimulus.mask.img.size.height = 0;
handles.maskStimulus.mask.img.files = 0;

handles.maskStimulus.mask.solidColor.r = 0;
handles.maskStimulus.mask.solidColor.g = 0;
handles.maskStimulus.mask.solidColor.b = 0;
handles.maskStimulus.mask.solidColor.graph = zeros(1,1,3);
handles.maskStimulus.protocol.type = ''; % 'Flicker' 'Images' 'Solid color' 'White noise'
handles.maskStimulus.protocol.wn.blocks = 100;
handles.maskStimulus.protocol.wn.pxX = 5;
handles.maskStimulus.protocol.wn.pxY = 5;
handles.maskStimulus.protocol.wn.type = 'BW';
handles.maskStimulus.protocol.wn.frames = 1000;
handles.maskStimulus.protocol.wn.saveImages = 3;
handles.maskStimulus.protocol.wn.intensity = uint8([255 255 255]);
handles.maskStimulus.protocol.wn.seed = rng;
handles.maskStimulus.protocol.wn.possibleSeed = 0;
handles.maskStimulus.protocol.wn.seedFile ='...';
handles.maskStimulus.protocol.flicker.dutyCycle = 0;
handles.maskStimulus.protocol.flicker.periodo = 0;
handles.maskStimulus.protocol.flicker.imgTime = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.backgroundTime = handles.screens.refreshRate*1000;
handles.maskStimulus.protocol.flicker.bg.isImg = false;
handles.maskStimulus.protocol.flicker.bg.name = '...';
handles.maskStimulus.protocol.flicker.bg.r = 0;
handles.maskStimulus.protocol.flicker.bg.g = 0;
handles.maskStimulus.protocol.flicker.bg.b = 0;
handles.maskStimulus.protocol.flicker.bg.graph = zeros(1,1,3);
% falta la grafica
handles.maskStimulus.protocol.solidColor.r = 0;
handles.maskStimulus.protocol.solidColor.g = 0;
handles.maskStimulus.protocol.solidColor.b = 0;
handles.maskStimulus.protocol.solidColor.nframes = 1;
handles.maskStimulus.protocol.solidColor.height = 400;
handles.maskStimulus.protocol.solidColor.width = 400;
handles.maskStimulus.protocol.solidColor.graph = zeros(1,1,3);
handles.maskStimulus.repetitions = 0;
handles.maskStimulus.time = handles.img.files...
    * 1/handles.maskStimulus.fps * (handles.maskStimulus.repetitions+1);

handles.modify = false;
setAllGUIParameters(handles);
% Choose default command line output for SamplingInterface
handles.output = hObject;
% Update handles structure

guidata(hObject, handles);