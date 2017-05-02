% Original: Created by Cristobal Nettle (2012-2016)
% Modified: By Cesar Reyes  (2017) 

function stimulation(compressData)
% Script for run SampleInterface experiment 
addpath(genpath('lib'))

Stack  = dbstack; Stack.line
if isunix,
    Screen('Preference', 'ConserveVRAM', 64);
    Screen('Preference', 'SkipSyncTests', 1);
%     Screen('Preference', 'SkipSyncTests', 0); 
    oldLevel = Screen('Preference', 'VisualDebugLevel', 1);
end
%CAMBAI EN LA VERSION FINAL!!!!!! linea 1261 tb
if ismac,
oldLevel = Screen('Preference', 'VisualDebugLevel', 0);
oldSkip = Screen('Preference', 'SkipSyncTests',0);
end

% if useProjector is true then the projector run to 120 [Hz]
useProjector = false;

% constant for digital synchronize
FPS_60HZ = 8;
FPS_120HZ = 4;
TRIGGER_TIME_UP = 800;
TRIGGER_TIME_ZERO = 0;
WAIT_TIME_SIGNAL = 0.018; % 18[ms] to mark the start o end of a protocol

% PROJECTOR
if useProjector,
    try
        which setProjector
        error = setProjector(FPS_60HZ);
    catch exceptions
        display(['Error communicating with the projector: setting projector. ' exceptions.message]); Stack  = dbstack; Stack.line
        Screen('Close')
        Screen('CloseAll')
        return
    end
    if(error)
        display('Error communicating with the projector (setting part')
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% LOAD THE SAMPLING INTERFASE FILE %%%%%%%%%%%%%%%%%%%%%%%%%
% either file zip or GUI SI

siFilesNotCharged = false;
nonVisual = ischar(compressData);
% Non-visual
if nonVisual
    delete *.si
    dirName = sprintf('../Log/Exp__%04d_%02d_%02d-%02d.%02d.%02d',round(clock));
    mkdir(dirName)
    system(['unzip ' strrep(compressData,' ','\ ') ' -d ' dirName]);
    siFileName = 'Final Configuration.si';
    if exist(fullfile(dirName,siFileName),'file')
        data = getInformation(fullfile(dirName,siFileName));
    else
        siFilesNotCharged = true;
        disp('ERROR: Can''t open configuration file "Final Configuration.si"');
    end
else % VISUAL
    data = compressData;
    dirName =  pwd;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% SET THE INITIAL PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

data.startedTime = round(clock);
% Creating window
disp(['screen:'])
disp(data.screens.selected);
% win=Screen('OpenWindow',data.screens.selected,0);
win=Screen('OpenWindow',0,0);
priorityLevel=MaxPriority(win);
Priority(priorityLevel);
HideCursor();
[wScreen,hScreen]=Screen('WindowSize',win);
refresh = Screen('GetFlipInterval', win);
data.refresh = refresh;
data.screens.width = wScreen;
data.screens.height = hScreen;
Screen('TextSize',win, 20);
% Set blend function for alpha blending
Screen('BlendFunction', win, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
indexColorFrame = 0;
% exitDemo = false;
settingMaskMode = true;
presentationMaskMode = false;
imgFilesNotCharged =  false;
s1=0;s2=0;
abort = 0;
digitalSync = false;




%Matlab Pool
Screen('DrawText', win, 'Starting...', wScreen/2-170, hScreen/2-50, [150, 150, 0]);
Screen('Flip',win);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% AVALAIBLE KEY TO PRESS %%%%%%%%%%%%%%%%%%%%%%%%%%%

escapeKey = KbName('Escape');
% upKey = KbName('UpArrow');
% downKey = KbName('DownArrow');
% leftKey = KbName('LeftArrow');
% rightKey = KbName('RightArrow');
upKey = KbName('s');
downKey = KbName('d');
leftKey = KbName('f');
rightKey = KbName('g');
speedKey = KbName('a');
inWidthKey = KbName('l');
deWidthKey = KbName('j');
incHeighKey = KbName('i'); 
deHeighKey = KbName('k');
indegreeKey = KbName('n');
dedegreeKey = KbName('m');
squareKey = KbName('z');
ovalKey = KbName('x');
resetKey = KbName('c');
inintensityKey = KbName('q');
deintensityKey = KbName('w');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Charging experiment Data  %%%%%%%%%%%%%%%%%%%%%%%%%

for kexp=length(data.experiments.file)-1:-1:1,
    siFileName = ['Exp' sprintf('%03d',data.experiments.file(kexp+1)) '.si'];
%     if ~siFilesNotCharged && exist(fullfile(pwd,siFileName),'file'),
    if ~siFilesNotCharged && exist(fullfile(dirName,siFileName),'file'),
%         experiment(kexp) = getInformation(fullfile(pwd,siFileName));
        dataExp = getInformation(fullfile(dirName,siFileName));
        % Charging images
        if ~strcmp((dataExp.mode),'Presentation')
            dataExp.img.charge = zeros(1,dataExp.img.files);
            dataExp.img.repeated = 0;
            % Adjustment Bar variables
            if dataExp.sync.is && ~dataExp.sync.isdigital                     
                dataExp.sync.analog.posLeft = (dataExp.sync.analog.posLeft-1)*wScreen/99.0;
                dataExp.sync.analog.posTop = (dataExp.sync.analog.posTop-1)*hScreen/99.0;
                dataExp.sync.analog.posRight = (dataExp.sync.analog.posRight-1)*wScreen/99.0;
                dataExp.sync.analog.posBottom = (dataExp.sync.analog.posBottom-1)*hScreen/99.0;
                dataExp.sync.analog.r = (dataExp.sync.analog.r-dataExp.sync.analog.baseR)/(dataExp.sync.analog.division-1); 
                dataExp.sync.analog.g = (dataExp.sync.analog.g-dataExp.sync.analog.baseG)/(dataExp.sync.analog.division-1); 
                dataExp.sync.analog.b= (dataExp.sync.analog.b-dataExp.sync.analog.baseB)/(dataExp.sync.analog.division-1); 
            end
            if dataExp.beforeStimulus.is && dataExp.beforeStimulus.bar.is
                dataExp.beforeStimulus.bar.posLeft = (dataExp.beforeStimulus.bar.posLeft-1)*wScreen/99.0;
                dataExp.beforeStimulus.bar.posTop = (dataExp.beforeStimulus.bar.posTop-1)*hScreen/99.0;
                dataExp.beforeStimulus.bar.posRight = (dataExp.beforeStimulus.bar.posRight-1)*wScreen/99.0;
                dataExp.beforeStimulus.bar.posBottom = (dataExp.beforeStimulus.bar.posBottom-1)*hScreen/99.0;
            end

            if strcmp(dataExp.mode,'White noise'),
                [dataExp.noise, dataExp.whitenoise.imgToComp,... 
                    dataExp.noiseimg] = setWNimg(dataExp.whitenoise);            
            end
            % Adjustment of stimulus position variables
            dataExp.position = [(wScreen-dataExp.protocol.width)/2+dataExp.img.deltaX ...
                (hScreen-dataExp.protocol.height)/2+dataExp.img.deltaY ...
                (wScreen+dataExp.protocol.width)/2+dataExp.img.deltaX ...
                (hScreen+dataExp.protocol.height)/2+dataExp.img.deltaY];
            
           % Adjustment of position variables of the mask
            dataExp.positionMask = [(wScreen-dataExp.maskStimulus.mask.width)/2+dataExp.img.deltaX ...
                    (hScreen-dataExp.maskStimulus.mask.height)/2+dataExp.img.deltaY ...
                    (wScreen+dataExp.maskStimulus.mask.width)/2+dataExp.img.deltaX ...
                    (hScreen+dataExp.maskStimulus.mask.height)/2+dataExp.img.deltaY];  
            if strcmp(dataExp.mode,'Mask stimulus') && strcmp(dataExp.maskStimulus.protocol.type,'Flicker') && dataExp.maskStimulus.protocol.flicker.bg.isImg,
                dataExp.maskStimulus.protocol.flicker.bg.position = ...
                    [(wScreen-dataExp.maskStimulus.protocol.flicker.bg.width)/2+dataExp.img.deltaX ...
                    (hScreen-dataExp.maskStimulus.protocol.flicker.bg.height)/2+dataExp.img.deltaY ...
                    (wScreen+dataExp.maskStimulus.protocol.flicker.bg.width)/2+dataExp.img.deltaX ...
                    (hScreen+dataExp.maskStimulus.protocol.flicker.bg.height)/2+dataExp.img.deltaY];  
            else
                dataExp.maskStimulus.protocol.flicker.bg.position = [0 0 0 0];
            end
        else
            dataExp.position  = [0,0,wScreen,hScreen];
            dataExp.positionMask = [0,0,wScreen,hScreen];
        end
        experiment(kexp) = dataExp;
        if experiment(kexp).sync.is && experiment(kexp).sync.isdigital
            digitalSync = true;
        end
     else
        siFilesNotCharged = true;
     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Begin comunitation to projector with digitl sync %%%%%%%%%%%%%%
if digitalSync,
    try
        which setProjector
        error = setProjector(FPS_60HZ);
    catch exceptions
        display(['Error communicating with the projector: setting projector. ' exceptions.message]); Stack  = dbstack; Stack.line
        Screen('Close')
        Screen('CloseAll')
        return
    end
    if(error)
        display('Error communicating with the projector (setting part')
        return
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% Charging images per experiment %%%%%%%%%%%%%%%%%%%%%%%%%

lengthProtocols = length(data.experiments.file)-1;

for kexp=1:lengthProtocols,
    
    useDigitalProjector = experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames');
    % charge the image for presentation mode and sets the shift in the 
    % presentation position depending on the previous or next experiment
    if strcmp(experiment(kexp).mode,'Presentation')
        try
            if experiment(kexp).presentation.img.is,
                imgPresentation = imread(experiment(kexp).presentation.img.path);
                if islogical(imgPresentation) || useDigitalProjector,
                    imgPresentation = uint8(imgPresentation);
                end
                
                if useDigitalProjector,
                    imgPresentation = bitshift(imgPresentation,-4) + bitshift(bitshift(imgPresentation,-4),4);
                end
                
                experiment(kexp).img.charge(1) = Screen('MakeTexture',win,imgPresentation);
                switch experiment(kexp).presentation.img.shift,
                    case 0, % no shift
                        experiment(kexp).position = [(wScreen-experiment(kexp).presentation.img.size.width)/2 ...
                            (hScreen-experiment(kexp).presentation.img.size.height)/2 ...
                            (wScreen+experiment(kexp).presentation.img.size.width)/2 ...
                            (hScreen+experiment(kexp).presentation.img.size.height)/2];
                    case 1, % Use conf from previous
                        if kexp > 1,
                            experiment(kexp).position = [(wScreen-experiment(kexp).presentation.img.size.width)/2+experiment(kexp-1).img.deltaX ...
                                (hScreen-experiment(kexp).presentation.img.size.height)/2+experiment(kexp-1).img.deltaY ...
                                (wScreen+experiment(kexp).presentation.img.size.width)/2+experiment(kexp-1).img.deltaX ...
                                (hScreen+experiment(kexp).presentation.img.size.height)/2+experiment(kexp-1).img.deltaY];
                        else
                            error('MATLAB:BadExperimentDefinition','Intentions of using shift from unexistent previous stimulus');
                        end
                    case 2, % Use conf from next
                        if kexp < lengthProtocols
                            experiment(kexp).position = [(wScreen-experiment(kexp).presentation.img.size.width)/2+experiment(kexp+1).img.deltaX ...
                                (hScreen-experiment(kexp).presentation.img.size.height)/2+experiment(kexp+1).img.deltaY ...
                                (wScreen+experiment(kexp).presentation.img.size.width)/2+experiment(kexp+1).img.deltaX ...
                                (hScreen+experiment(kexp).presentation.img.size.height)/2+experiment(kexp+1).img.deltaY];
                        else
                            error('MATLAB:BadExperimentDefinition','Intentions of using shift from unexistent next stimulus');
                        end
                    otherwise, % no shift
                        experiment(kexp).position = [(wScreen-experiment(kexp).presentation.img.size.width)/2 ...
                            (hScreen-experiment(kexp).presentation.img.size.height)/2 ...
                            (wScreen+experiment(kexp).presentation.img.size.width)/2 ...
                            (hScreen+experiment(kexp).presentation.img.size.height)/2];
                end
            end
        catch exceptions
            display([exceptions.identifier ': ' exceptions.message])
            if strcmp(exceptions.identifier,'MATLAB:BadExperimentDefinition'),
                abort = 1;
            else
                experiment(kexp).presentation.img.is = false;
            end
        end
    end
    
    %%% The next code has the goal to charge in memmory the function imread and
    %%% (if they are separate files) the functions to use of Screen.
    if experiment(kexp).protocol.useImages && experiment(kexp).img.files > 0,
        % Load the images of expetiment and fix these as a texture before of the presentation 
        % If it have images for display, get name, ext, initial number, final
        % number
        if experiment(kexp).img.files == 1,
            num = [];
            name = experiment(kexp).img.nInitial;
            ext = [];
            nInit = 1;
        elseif experiment(kexp).img.files > 1
            difference=find((experiment(kexp).img.nInitial==experiment(kexp).img.nFinal)==0);
            nExt = find(experiment(kexp).img.nInitial=='.');
            ext = experiment(kexp).img.nInitial(nExt(end):end);% name of img extension 
            name = experiment(kexp).img.nInitial(1:difference(1)-1);% name of img
            nInit = str2double(experiment(kexp).img.nInitial(difference(1):nExt(end)-1));% initial number of images name
            ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
        end
        
        for j=nInit:experiment(kexp).img.files+nInit-1,
            if experiment(kexp).img.files > 1,
                num = sprintf(ns,j);
            end
            imgName = fullfile(experiment(kexp).img.directory,strcat(name,num,ext)); 
            if exist(imgName,'file'),
                loadedImg = imread(imgName);
                if islogical(loadedImg) || useDigitalProjector,
                    loadedImg = uint8(loadedImg);
                end
                % over 60 hz (useDigitalProjector) the images are compressed using a binary shift
                if useDigitalProjector,
                    if mod(j-nInit,2),
                        loadedImg2 = loadedImg1 + bitshift(bitshift(loadedImg,-4),4);
                        Screen('Close',experiment(kexp).img.charge(j-nInit));
                        experiment(kexp).img.charge((j-nInit-1)/2) = Screen('MakeTexture',win,loadedImg2); 
                    else
                        loadedImg1 = bitshift(loadedImg,-4);
                        experiment(kexp).img.charge((j-nInit)/2+1) = Screen('MakeTexture',win,loadedImg); 
                    end
                else
                    experiment(kexp).img.charge(j-nInit+1) = Screen('MakeTexture',win,loadedImg); 
                end
                
                if ~mod(j,100)
                    Screen('DrawText', win,['Charging experiment ' num2str(kexp) ' img ' num2str(j-nInit+1) ],...
                        wScreen/2-170, kexp*hScreen/(lengthProtocols+1), [150, 150, 0]);
                    display(['Charging experiment ' num2str(kexp) ' img ' num2str(j-nInit+1) ])
                    Screen('Flip',win);
                end
            else
                disp(['Not exist ' imgName ' file, check the image and retry.'])
                return;
            end
        end
    end
    
    if useDigitalProjector,
        experiment(kexp).img.files = ceil(experiment(kexp).img.files/2);
    end

    % If it have images for display in masked stimulus, get name, ext, initial number, final
    % number
    if strcmp(experiment(kexp).mode,'Mask stimulus') && experiment(kexp).maskStimulus.mask.useImages,
        if experiment(kexp).maskStimulus.mask.img.files == 1,
            numMask = [];
            nameMask = experiment(kexp).maskStimulus.mask.img.nInitial;
            extMask = [];
            nInitMask = 1;
        elseif experiment(kexp).maskStimulus.mask.img.files > 1
            differenceMask = find((experiment(kexp).maskStimulus.mask.img.nInitial == experiment(kexp).maskStimulus.mask.img.nFinal)==0);
            nExtMask = find(experiment(kexp).maskStimulus.mask.img.nInitial=='.');
            extMask = experiment(kexp).maskStimulus.mask.img.nInitial(nExtMask(end):end);% name of img extension 
            nameMask = experiment(kexp).maskStimulus.mask.img.nInitial(1:differenceMask(1)-1);% name of img
            nInitMask = str2double(experiment(kexp).maskStimulus.mask.img.nInitial(differenceMask(1):nExtMask(end)-1));% initial number of images name
            nsMask = ['%0' num2str(nExtMask(end)-differenceMask(1)) 'd'];
        end    
        % Load the image for the mask if this mask type is img
        if strcmp(experiment(kexp).maskStimulus.mask.type,'Img') &&...
                experiment(kexp).maskStimulus.mask.img.files > 0,
            for j=nInitMask:experiment(kexp).maskStimulus.mask.img.files+nInitMask-1,
                if experiment(kexp).maskStimulus.mask.img.files > 1,
                    numMask = sprintf(nsMask,j);
                end
                imgNameMask = fullfile(experiment(kexp).maskStimulus.mask.img.directory,strcat(nameMask,numMask,extMask)); 
                if exist(imgNameMask,'file'),
                    loadedImgMask = imread(imgNameMask);
                    if islogical(loadedImgMask) || useDigitalProjector,
%                         loadedImgMask = uint8(loadedImgMask);
                        loadedImgMask = uint8(loadedImgMask);
                    end
                    % over 60 hz (useDigitalProjector) the images are compressed using a binary shift
                    if useDigitalProjector,
                        if mod(j-nInitMask,2),
                            loadedImgMask2 = loadedImgMask1 + bitshift(bitshift(loadedImgMask,-4),4);
                            experiment(kexp).maskStimulus.mask.img.imgpreloaded{(j-nInit-1)/2} = loadedImgMask2; 
                        else
                            loadedImgMask1 = bitshift(loadedImgMask,-4);
                            experiment(kexp).maskStimulus.mask.img.imgpreloaded{(j-nInit)/2+1} = loadedImgMask; 
                        end
                    else
                        experiment(kexp).maskStimulus.mask.img.imgpreloaded{j-nInitMask+1} = loadedImgMask; 
                    end
                    if ~mod(j,100)
                        Screen('DrawText', win,['Charging experiment ' num2str(kexp) ' mask img ' num2str(j-nInitMask+1) ],...
                            wScreen/2-170, kexp*hScreen/(lengthProtocols+1), [150, 150, 0]);
                        display(['Charging experiment ' num2str(kexp) ' mask img ' num2str(j-nInitMask+1) ])
                        Screen('Flip',win);
                    end
                else
                    disp(['Not exist ' imgNameMask ' file, check the image and retry.'])
                    return;
                end
            end
        end
    end
    if useDigitalProjector,
        experiment(kexp).maskStimulus.mask.img.files = ceil(experiment(kexp).maskStimulus.mask.img.files/2);
    end
    clearvars tmp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% SERIAL COMUNICATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% data.serial is another way for save the digital signal 
%Serial COM
down = uint8(0);
up = uint8(1);
change = uint8(2);

% data.serial.is = 0;
% data.serial.com = '/dev/tty.SLAB_USBtoUART';
% data.serial.baudrate = 115200;

if data.sync.isSerial
%Using PTB IOPort commands
    IOPort('CloseAll')
    configString = 'ReceiverEnable=1 BaudRate=115200 StartBits=1 DataBits=8 StopBits=1 Parity=No RTS=0 DTR=1';
    port='/dev/cu.SLAB_USBtoUART';
    [serialCom] = IOPort('OpenSerialPort', port, configString);
    IOPort('Flush', serialCom); %flush data queued to send to device 
    IOPort('Purge', serialCom); %clear existing data queues.
    IOPort('Write', serialCom, up);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Finish the experiment when there are a Error %%%%%%%%%%%%%%%

if siFilesNotCharged || abort
    Screen('DrawText', win, 'Process   aborted  !!', wScreen/2-170, hScreen/2-50, [255, 0, 0]);
    Screen('Flip',win);
    WaitSecs(1);
    Screen('Close');
    Screen('CloseAll');
    Priority(0);
    ShowCursor();
    data.finishedTime = round(clock);
    Screen('Preference', 'SkipSyncTests',oldSkip);
    Screen('Preference', 'VisualDebugLevel', oldLevel );
    if siFilesNotCharged    
        disp(['ERROR: File not found: ' siFileName ' You should restart the interface.']);
    end
    return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%  STARTING THE SAMPLING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this section the code run the protocols for each the Samling Interfase
% file. These might be :
% Presentation: image or solid color for a definited time
% Flicker: display a images for t1 [s] and after display background t2 [s]
% White noise: display a random checkerboard 
% Only stimulus: display a secuence of images 
% Mask Stimulus: display any of the protocols before description but with a mask above.

Screen('DrawText',win,'Experiment ready to be displayed, press any key to continue...',...
    wScreen/2-300,hScreen-100,[0,200,0]);
display('Experiment ready to be displayed, press any key to continue...');
Screen('Flip',win);
pressed = 0;
KbName('UnifyKeyNames');
KbQueueCreate();
KbQueueStart();
while ~pressed,
    pressed = KbQueueCheck();
    WaitSecs(0.2);
end

KbQueueFlush();
KbQueueRelease();


kexp = 1;
% This loop run each experiment's protocol
while(kexp<length(data.experiments.file)),
    if siFilesNotCharged 
        break;
    end
    useDigitalProjector = experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames');
    
    display(['Running experiment ' num2str(kexp) '/' num2str(length(data.experiments.file)-1)...
        ' (some repetitions might be not considered )']);
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%% PRESENTATION  MODE %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if strcmp( experiment( kexp).mode,'Presentation'),
        if experiment(kexp).presentation.img.is,
            Screen('DrawTexture',win,experiment(kexp).img.charge(1),[],experiment(kexp).position);
        else
            Screen('FillRect', win, [experiment(kexp).presentation.r ...
                experiment(kexp).presentation.g experiment(kexp).presentation.b]);
        end
        
        Time(kexp).start = Screen('Flip', win);
        
        if length(experiment) > kexp && ...
           experiment(kexp+1).beforeStimulus.is && ...
           experiment(kexp+1).beforeStimulus.rest,
            Time(kexp).finish = WaitSecs((experiment(kexp).presentation.time - ...
                experiment(kexp+1).beforeStimulus.time)/1000.0 - 0.5*refresh);
        else
            Time(kexp).finish = WaitSecs(experiment(kexp).presentation.time/1000.0 - 0.5*refresh);
        end
    else
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%% Set general parameters for the other protocosl %%%%%%%%%%%
        
        % Set the background images to texture for all experiment with
        % background image 
        if experiment(kexp).img.background.isImg
            imgName = experiment(kexp).img.background.imgName; 
            if exist(imgName,'file'),
                [tmp,tmpMap] = imread(imgName);
                if isempty(tmpMap)
                    if useDigitalProjector,
                        tmp = uint8(tmp);
                        tmp = bitshift(tmp,-4) + bitshift(bitshift(tmp,-4),4);
                    end                    
                    background = Screen('MakeTexture',win,tmp);
                    clear tmp;
                else % it's index color frame and not RGB color
                    indexColorFrame = 1; break;
                end
            else
                imgFilesNotCharged = true; break;
            end
        end
        
        % Set the initial images texture for some protocols
%         if ~strcmp(experiment(kexp).mode,'White noise') && ~strcmp(experiment(kexp).mode,'Mask stimulus'),
        if experiment(kexp).protocol.useImages,
            firstStimulusTexture = experiment(kexp).img.charge(1);
        end
        
        % Set the dimention and position for insert textures
        BSbackgroundColor = [experiment(kexp).beforeStimulus.background.r ...
            experiment(kexp).beforeStimulus.background.g ...
            experiment(kexp).beforeStimulus.background.b];

        BSbarColor = [experiment(kexp).beforeStimulus.bar.r ...
            experiment(kexp).beforeStimulus.bar.g ...
            experiment(kexp).beforeStimulus.bar.b];

        BSbarPosition = [experiment(kexp).beforeStimulus.bar.posLeft, ...
            experiment(kexp).beforeStimulus.bar.posTop, ...
            experiment(kexp).beforeStimulus.bar.posRight, ...
            experiment(kexp).beforeStimulus.bar.posBottom];

        backgroundImgColor = [experiment(kexp).img.background.r ...
            experiment(kexp).img.background.g experiment(kexp).img.background.b];

        baseColorBar = [experiment(kexp).sync.analog.baseR ...
            experiment(kexp).sync.analog.baseG...
            experiment(kexp).sync.analog.baseB];

        colorBar =  [experiment(kexp).sync.analog.r ...
        experiment(kexp).sync.analog.g ...
        experiment(kexp).sync.analog.b];

        positionBar = [experiment(kexp).sync.analog.posLeft ...
            experiment(kexp).sync.analog.posTop ...
            experiment(kexp).sync.analog.posRight ...
            experiment(kexp).sync.analog.posBottom];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%% FLICKER  MODE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if strcmp(experiment(kexp).mode,'Flicker'),
            nRefreshImg = round(experiment(kexp).flicker.dutyCicle...
                /(100.0*experiment(kexp).flicker.fps*refresh));
            nRefreshBackground = round((100-experiment(kexp).flicker.dutyCicle)...
                /(100.0*experiment(kexp).flicker.fps*refresh));
            img = false;
            
            if experiment(kexp).flicker.repetitions == 0
                imgNumber = nInit+1;
                rep = 0;
            else
                imgNumber = nInit;
                rep = 1;
            end
            
            % Set the reference time for the presentation 
            if kexp>1
                vbl = Time(kexp-1).finish;
            else
                vbl = GetSecs;
            end
            
            % Draw background and sync bar before stimulus
            if experiment(kexp).beforeStimulus.is
                Screen('FillRect',win,BSbackgroundColor);
                if experiment(kexp).beforeStimulus.bar.is
                     Screen('FillRect',win,BSbarColor, BSbarPosition);
                end
                Time(kexp).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(kexp).beforeStimulus.time ...
                    /(refresh*1000.0))*refresh-0.5*refresh);
            end
            
            % Draw background Texture
            if experiment(kexp).img.background.isImg
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect', win, backgroundImgColor);
            end
            
            %Set Flicker background image as a texture
            if experiment(kexp).flicker.img.is
                imgName = experiment(kexp).flicker.img.name;
                if exist(imgName,'file'),
                    [tmp,tmpMap] = imread(imgName);
                    if isempty(tmpMap)
                        if useDigitalProjector,
                            tmp = uint8(tmp);
                            tmp = bitshift(tmp,-4) + bitshift(bitshift(tmp,-4),4);
                        end                    
                        flickerBackground = Screen('MakeTexture',win,tmp);
                        clear tmp;
                    else % it's index color frame and not RGB color
                        indexColorFrame = 1; break;
                    end
                else
                    imgFilesNotCharged = true; break;
                end
            end
            
            % the first texture is drawn and useProjector is true check the
            % the comunication to projector
            Screen('DrawTexture', win, firstStimulusTexture,[],experiment(kexp).position);
            if ~rep,
                display('Removing first stimulus');
                Screen('Close',firstStimulusTexture);
            end
            
            b = 0;
            b_serial = 0;

            if data.sync.isSerial
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end    
            
            % Start Digital or Analog Synchronize
            % If use 120Hz and the trigger was select the projector 
            % mark all frame with digital pulse, if the trigger was not 
            % select then mark only for 18[ms] before stimulus. Otherwise
            % show the analog synchronize
            if experiment(kexp).sync.is
                if experiment(kexp).sync.isdigital,
                    try
                        if strcmp(experiment(kexp).sync.digital.mode,'On every frames'), 
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                        else
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                            WaitSecs(WAIT_TIME_SIGNAL); 
                            error = error || setProjector(FPS_60HZ);
                        end
                    catch exceptions
                        display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                    if error,
                        display('Error communicating with the projector: setting trigger')
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                else
                    Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division),positionBar);
                    b = b + 1;
                end
            end
            
            vbl = Screen('Flip',win,vbl);
            
            if ~experiment(kexp).beforeStimulus.is
                Time(kexp).start = vbl;
            end
            
            % if set 'include prev. background' that is repeat using the 
            % previos protocol, otherwise repeat over own
            if experiment(kexp).flicker.repeatBackground,
                nRep = 0;
            else
                nRep = experiment(kexp).flicker.repetitions;
            end
            
            % loop for show ON (img) and OFF (background) flicker and bottom bar
            for j = 2:2*(nRep+1)*experiment(kexp).img.files,
                if img,
                    if experiment(kexp).img.background.isImg
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture',win,background);
                    else
                        Screen('FillRect', win, backgroundImgColor);
                    end
                    
                    % Draw the images-textures of protocol kexp
                    Screen('DrawTexture', win, experiment(kexp).img.charge(imgNumber-nInit+1),[],experiment(kexp).position); 
                    
                    if (~experiment(kexp).flicker.repeatBackground && rep==experiment(kexp).flicker.repetitions ) ...
                         || (experiment(kexp).flicker.repeatBackground && ...
                         experiment(kexp).img.repeated==experiment(kexp).flicker.repetitions),
                        Screen('Close',experiment(kexp).img.charge(imgNumber-nInit+1));
                    end
                    
                    % Analog Synchronize
                    if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                        % Bars are now only presented during images, 
                        % hence b = b + 2;
                        Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                        b = b + 1;
                    end
                    
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshBackground - 0.5) * refresh);
                    if experiment(kexp).flicker.repeatBackground || rep == experiment(kexp).flicker.repetitions;
                        imgNumber = imgNumber + 1;
                        rep = 0;
                    else
                        rep = rep + 1;
                    end
                else
                    if experiment(kexp).flicker.img.is
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture', win, flickerBackground,[],experiment(kexp).position);
                    else
                        Screen('FillRect',win,[0 0 0]);
                        Screen('FillRect', win, [experiment(kexp).flicker.r ...
                        experiment(kexp).flicker.g experiment(kexp).flicker.b]);    
                    end

                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshImg - 0.5) * refresh);
                end
                img = ~img;
            end
            
            Time(kexp).finish = WaitSecs((nRefreshBackground-0.5)*refresh);
            
            % End Digital Synchronize
            % If the trigger was select (120 hz) the projector 
            % return to normal state  (60 hz) and with these end the trigger state.
            % Otherwise mark end for 18 [ms] with the trigger signal 
            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital,
                try  
                    if strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                        error = setProjector(FPS_60HZ); 
                    else
                        error = setProjector(FPS_120HZ); 
                        error = error || setTrigger(TRIGGER_TIME_UP); 
                        WaitSecs(WAIT_TIME_SIGNAL); 
                        error = error || setProjector(FPS_60HZ);
                    end
                catch exceptions
                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
                if error,
                    display('Error communicating with the projector: setting trigger')
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
            end
            
            if experiment(kexp).flicker.img.is
                Screen('Close',flickerBackground);
            end
            
            % if repeat with the prev. background then the index kexp
            % return to kexp-2 (the background) until complete the
            % repetition
            if experiment(kexp).flicker.repeatBackground && kexp>1 && strcmp(experiment(kexp-1).mode,'Presentation') ...
                    && experiment(kexp).img.repeated < experiment(kexp).flicker.repetitions,
                experiment(kexp).img.repeated = experiment(kexp).img.repeated + 1;
                kexp = kexp-2;
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%% ONLY STIMULUS MODE  %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        elseif strcmp(experiment(kexp).mode,'Only stimulus (fps)'),
            % Frames per second
            nRefreshImg = round(1/(experiment(kexp).onlyStimulus.fps*refresh));
            
            if nRefreshImg==1,
                nRefreshImg = 0.5;
            end
            
            % Set the reference time for the presentation
            if kexp>1
                vbl = Time(kexp-1).finish;
            else
                vbl = GetSecs;
            end
            
            % Draw background and sync bar before stimulus
            if experiment(kexp).beforeStimulus.is
                Screen('FillRect',win,BSbackgroundColor);
                if experiment(kexp).beforeStimulus.bar.is
                    Screen('FillRect',win,BSbarColor, BSbarPosition);
                end
                Time(kexp).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(kexp).beforeStimulus.time...
                    /(refresh*1000.0))*refresh-0.5*refresh);
            end
            
            % Draw background Texture
            if experiment(kexp).img.background.isImg
                Screen('FillRect',win,[0 0 0]);
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect', win, backgroundImgColor);
            end
            Screen('DrawTexture', win, firstStimulusTexture,[],experiment(kexp).position);
            
            b = 0;
            b_serial = 0;
            
            % Start Digital or Analog Synchronize
            % If use 120Hz and the trigger was select the projector 
            % mark all frame with digital pulse, if the trigger was not 
            % select then mark only for 18[ms] before stimulus. Otherwise
            % show the analog synchronize
            if experiment(kexp).sync.is
                if experiment(kexp).sync.isdigital, % Digital synchronize
                    try
                        if strcmp(experiment(kexp).sync.digital.mode,'On every frames'), 
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                        else
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                            WaitSecs(WAIT_TIME_SIGNAL); 
                            error = error || setProjector(FPS_60HZ);
                        end
                    catch exceptions
                        display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                    if error,
                        display('Error communicating with the projector: setting trigger')
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                else % Analog synchronize
                    Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division),positionBar);
                    b = b + 1;
                end
            end

            if data.sync.isSerial
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end

            vbl = Screen('Flip',win,vbl);
            
            if ~experiment(kexp).beforeStimulus.is
                Time(kexp).start = vbl;
            end
            
            % if set 'include prev. background' that is repeat using the 
            % previos protocol, otherwise repeat over own
            if experiment(kexp).onlyStimulus.repeatBackground,
                rep = 0;
            else
                rep = experiment(kexp).onlyStimulus.repetitions;
            end
            
            % run the protocol 'rep' times
            for j=1:rep+1, 
                %skip the first stimulus texture displayed above
                if j==1, 
                    tmp = nInit+1; 
                else
                    tmp = nInit; 
                    
                    % Digital Synchronize 
                    % For repetition without prev. background and use projector and not use
                    % trigger, it's mark for 18[ms] the start of repetition.
                    if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && ~strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                        try
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                            WaitSecs(WAIT_TIME_SIGNAL); 
                            error = error || setProjector(FPS_60HZ); 
                        catch exceptions
                            display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                            Screen('Close')
                            Screen('CloseAll')
                            return
                        end
                        if error,
                            display('Error communicating with the projector: setting trigger')
                            Screen('Close')
                            Screen('CloseAll')
                            return
                        end
                    end
                end
                
                % Show the images of protocol and bottom bar if set on
                for k=tmp:nInit+experiment(kexp).img.files-1, 
                    % set the background
                    if experiment(kexp).img.background.isImg
                        Screen('FillRect',win,[0 0 0]);
                        Screen('DrawTexture',win,background);
                    else
                        Screen('FillRect', win, backgroundImgColor);
                    end
                    
                    % draw Texture 
                    Screen('DrawTexture', win, experiment(kexp).img.charge(k-nInit+1),[],experiment(kexp).position); %img, [], experiment(kexp).position);
                   
                    % Analog Syncronize
                    % draw botton bar
                    if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                        Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                        b = b + 1;
                    end
                    
                    if data.sync.isSerial
                        IOPort('Write', serialCom, change);
                        b_serial = b_serial + 1;
                    end
                    
                    if nRefreshImg == 1,
                        vbl = Screen('Flip', win, vbl);
                    else
                        vbl = Screen('Flip', win, vbl + ...
                            (nRefreshImg - 0.5) * refresh);
                    end
                end
                
                Time(kexp).finish = WaitSecs((nRefreshImg - 0.5) * refresh);
                
                % End Digital Synchronize
                % If the trigger was select (120 hz) the projector 
                % return to normal state  (60 hz) and with these end the trigger state.
                % Otherwise mark end for 18 [ms] with the trigger signal 
                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital,
                    try  
                        if strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                            error = setProjector(FPS_60HZ); 
                        else
                            error = setProjector(FPS_120HZ); 
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                            WaitSecs(WAIT_TIME_SIGNAL); 
                            error = error || setProjector(FPS_60HZ);
                        end
                    catch exceptions
                        display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                    if error,
                        display('Error communicating with the projector: setting trigger')
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                end
            end



            if data.sync.isSerial
                IOPort('Write', serialCom, down);
            end
            
            if experiment(kexp).img.background.isImg
                Screen('Close',background);
            end
            
            % if repeat with the prev. background then the index kexp
            % return to kexp-2 (the background)
            if experiment(kexp).onlyStimulus.repeatBackground && kexp>1 && strcmp(experiment(kexp-1).mode,'Presentation') ...
                    && experiment(kexp).img.repeated < experiment(kexp).onlyStimulus.repetitions,
                experiment(kexp).img.repeated = experiment(kexp).img.repeated + 1;
                kexp = kexp-2;
            end
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%% WHITE NOISE MODE %%%%%%%%%%%%%%%%%%%%%%%%%
          
        elseif strcmp(experiment(kexp).mode,'White noise'),
            rng(experiment(kexp).whitenoise.seed);
            % Create the array for run WN stimulus
            [experiment(kexp).whitenoise.noise, ...
              experiment(kexp).whitenoise.imgToComp,... 
              experiment(kexp).whitenoise.noiseimg] ...
                = setWNimg(experiment(kexp).whitenoise);
            
            nRefreshImg = round(1/(experiment(kexp).whitenoise.fps*refresh));
            
            if nRefreshImg==1,
                nRefreshImg = 0.5;
            end
            
             % Set the reference time for the presentation
            if kexp>1
                vbl = Time(kexp-1).finish;
            else
                vbl = GetSecs;
            end
            
            % Draw background and sync bar before stimulus
            if experiment(kexp).beforeStimulus.is
                Screen('FillRect',win,BSbackgroundColor);
                if experiment(kexp).beforeStimulus.bar.is
                    Screen('FillRect',win,BSbarColor, BSbarPosition);
                end
                Time(kexp).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(kexp).beforeStimulus.time/(refresh*1000.0))*refresh-0.5*refresh);
            end
            
            % Draw background Texture
            if experiment(kexp).img.background.isImg
                Screen('FillRect',win,[0 0 0]);
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect', win, backgroundImgColor);
            end
            
            b = 0;
            b_serial = 0;
            
            if data.sync.isSerial
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end
            
            if ~experiment(kexp).beforeStimulus.is
                Time(kexp).start = vbl;
            end
            
            if experiment(kexp).sync.is && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                limit = experiment(kexp).whitenoise.frames/2;
            else
                limit = experiment(kexp).whitenoise.frames;
            end
            for j=1:limit,
                % Set the background
                if experiment(kexp).img.background.isImg
                    Screen('FillRect',win,[0 0 0]);
                    Screen('DrawTexture',win,background);
                else
                    Screen('FillRect', win, backgroundImgColor);
                end
                
                if ~mod(j,1000),
                    disp(['Rep: ' num2str(j) '/' num2str(limit)]);
                end
               
                protocolImage = uint8(0*experiment(kexp).whitenoise.noiseimg);
                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                    for imageCombination = 1:2; 
                        [~, noiseimg] = getRandWNimg(experiment(kexp).whitenoise);
                        saveIndex = (j-1)*2 + imageCombination;
                        if saveIndex<=experiment(kexp).whitenoise.saveImages,
                            if strcmp(experiment(kexp).whitenoise.type,'BW')
                                experiment(kexp).whitenoise.imgToComp(:,:,saveIndex)...
                                    = noiseimg;
                            else
                                experiment(kexp).whitenoise.imgToComp(:,:,:,saveIndex)...
                                    = noiseimg;
                            end
                        end
                        protocolImage = protocolImage + bitshift(bitshift(noiseimg,-4),4*(imageCombination-1));	
                    end
                else
                    [~, noiseimg] = getRandWNimg(experiment(kexp).whitenoise);
                    if j<=experiment(kexp).whitenoise.saveImages,
                        if strcmp(experiment(kexp).whitenoise.type,'BW')
                            experiment(kexp).whitenoise.imgToComp(:,:,j)...
                                = noiseimg;
                        else
                            experiment(kexp).whitenoise.imgToComp(:,:,:,j)...
                                = noiseimg;
                        end
                    end
                    protocolImage = noiseimg;	
                end

                noisetxt = Screen('MakeTexture',win,protocolImage);
                Screen('DrawTexture', win, noisetxt,[],experiment(kexp).position);
                Screen('Close',noisetxt);                
                % Start Digital or Analog Synchronize
                % If use 120Hz and the trigger was select the projector 
                % mark all frame with digital pulse, otherwise
                % show the analog synchronize
                if experiment(kexp).sync.is
                    if experiment(kexp).sync.isdigital && (j == 1), 
                        display('Setting trigger for projector')
                        try
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP);                 
                        catch exceptions
                            display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                            Screen('Close')
                            Screen('CloseAll')
                            return
                        end
                        if error,
                            display('Error communicating with the projector: setting trigger')
                            Screen('Close')
                            Screen('CloseAll')
                            return
                        end
                    else
                        Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                        b = b + 1;
                    end
                end
                
                if data.sync.isSerial
                    % fwrite(serialCom,change);
                    IOPort('Write', serialCom, change);
                    b_serial = b_serial + 1;
                end
                
                if nRefreshImg == 1,
                    vbl = Screen('Flip', win, vbl);
                else
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshImg - 0.5) * refresh);
                end
            end
            
            Time(kexp).finish = WaitSecs((nRefreshImg - 0.5) * refresh);

            % End Digital Synchronize, down the 120[hz] to 60[hz]
            % and finish the trigger
            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital,
                try  
                    error = setProjector(FPS_60HZ);
                catch exceptions
                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
                if error,
                    display('Error communicating with the projector: setting trigger')
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
            end
            
            if data.sync.isSerial
                IOPort('Write', serialCom, down);
            end
            
            if experiment(kexp).img.background.isImg
                Screen('Close',background);
            end
            

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%% MASK STIMULUS MODE %%%%%%%%%%%%%%%%%%%%%%%
        elseif strcmp(experiment(kexp).mode,'Mask stimulus'),
            % Frames per second
            nRefreshImg = round(1/(experiment(kexp).maskStimulus.fps*refresh));
            if nRefreshImg==1,
                nRefreshImg = 0.5;
            end
            % Set flicker time
            if strcmp(experiment(kexp).maskStimulus.protocol.type,'Flicker'),
                nflicker = round(experiment(kexp).maskStimulus.protocol.flicker.imgTime/1000.0...
                    *experiment(kexp).maskStimulus.fps);
                nbackground = round(experiment(kexp).maskStimulus.protocol.flicker.backgroundTime/1000.0...
                    *experiment(kexp).maskStimulus.fps);
                nperiod = nflicker +nbackground;
            end
            % Set rand seed
            if strcmp(experiment(kexp).maskStimulus.protocol.type,'White noise'),
                rng(experiment(kexp).maskStimulus.mask.wn.seed);
            end

           %Set Flicker background image as a texture           
            if experiment(kexp).maskStimulus.protocol.flicker.bg.isImg
                imgName = experiment(kexp).maskStimulus.protocol.flicker.bg.name;
                if exist(imgName,'file'),
                    [tmp,tmpMap] = imread(imgName);
                    if isempty(tmpMap)
                        if useDigitalProjector,
                        tmp = uint8(tmp);
                            tmp = bitshift(tmp,-4) + bitshift(bitshift(tmp,-4),4);
                        end                    
                        MSflickerBackground = Screen('MakeTexture', win,tmp);
                        clear tmp;
                    else % it's index color frame and not RGB color
                        indexColorFrame = 1; break;
                    end
                else
                    imgFilesNotCharged = true; break;
                end                
            end
            
            % Set seed for random number for White noise MASK
            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                rng(experiment(kexp).maskStimulus.mask.wn.seed);
                % create the images to the white noise
                [experiment(kexp).maskStimulus.mask.wn.noise, ...
                 experiment(kexp).maskStimulus.mask.wn.imgToComp, ...
                 experiment(kexp).maskStimulus.mask.wn.noiseimg] ...
                    =  setWNimg(experiment(kexp).maskStimulus.mask.wn);                
            end
            
             % Set seed for random number for White noise sub-Protocol
            if strcmp(experiment(kexp).maskStimulus.protocol.type,'White noise'),
                rng(experiment(kexp).maskStimulus.protocol.wn.seed);
                % create the images to the white noise
                [experiment(kexp).maskStimulus.protocol.wn.noise, ...
                 experiment(kexp).maskStimulus.protocol.wn.imgToComp, ...
                 experiment(kexp).maskStimulus.protocol.wn.noiseimg] ...
                    =  setWNimg(experiment(kexp).maskStimulus.protocol.wn);                
            end    

            % Draw background Texture
            if experiment(kexp).img.background.isImg
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect', win, backgroundImgColor);
            end            

%             if exitDemo==false,
            if settingMaskMode == true,
                %%% INITIAL PARAMETERS MASK %%%%
                vbl = GetSecs;
                angle = 0;
                degreePerFrame = 5;
                intensity = 1;
                intensityStep = 0.1;
                stepSize = 1;
                width = 50;
                height = 60;
                shiftX = 0;
                shiftY = 0;
                s1 = experiment(kexp).maskStimulus.mask.width;
                s2 = experiment(kexp).maskStimulus.mask.height;
                timeReadkey = 0;
                nloop = 0;
                delta = 2; % min pixel inside mask image 
                maskShape = 'oval';
                npresentedflicker = 0;
                nflickerImg = 1;
                disp(nflickerImg);
              

                % Find the color values which correspond to white and black.
                black=BlackIndex(data.screens.selected);
                gray=GrayIndex(data.screens.selected); 
                white=WhiteIndex(data.screens.selected); 
                
                %%%% Set the initial MASK %%%%
                [x, y] = meshgrid(-s1/2:1:s1/2-1, -s2/2:1:s2/2-1);
                ss = max([s1 s2]);
                factor = 1.42;
                imgMask =  uint8(ones(s2, s1)*255);
                rotMask = deg2rad(angle);
                % oval shape
                if strcmp(maskShape,'oval')
                    x = x + shiftX;
                    y = y - shiftY;
                    mask = uint8((((x*cos(rotMask)-y*sin(rotMask))./width).^2+...
                        ((x*sin(rotMask)+y*cos(rotMask))./height).^2 >= 1)*white);
                else % rect shape
                    [xr, yr] = meshgrid(-round(ss*factor/2):1:round(ss*factor/2)-1, -round(ss*factor/2):1:round(ss*factor/2)-1);
                    imgMask =  uint8(ones(ss*factor, ss*factor)*255);                    
                    mask = ((abs(xr) < width) & (abs(yr) < height));
                    mask = uint8((~imrotate(mask,angle,'crop'))*255);
                    if shiftX >= 0 && shiftY >= 0, %move ^>
                        imgMask(shiftY+1:end,1:end-shiftX) = mask(1:end-shiftY,shiftX+1:end);
                    elseif shiftX >= 0 && shiftY <= 0, %move v>
                        imgMask(1:end-abs(shiftY),1:end-shiftX) = mask(abs(shiftY)+1:end,shiftX+1:end);
                    elseif shiftX <= 0 && shiftY <= 0, %move <v
                        imgMask(1:end-abs(shiftY),abs(shiftX)+1:end) = mask(abs(shiftY)+1:end,1:end-abs(shiftX));
                    elseif shiftX <= 0 && shiftY >= 0, %move <^
                        imgMask(shiftY+1:end,abs(shiftX)+1:end) = mask(1:end-shiftY,1:end-abs(shiftX));
                    else
                        imgMask = mask;
                    end
                    mask = imgMask(round((ss-s2)/2)+1:round((ss+s2)/2), round((ss-s1)/2)+1:round((ss+s1)/2));
                end
            end
            
            % Draw background Texture
            if experiment(kexp).img.background.isImg
                Screen('FillRect',win,[0 0 0]);
                Screen('DrawTexture',win,background);
            else
                Screen('FillRect', win, backgroundImgColor);
            end
            
            % Loop for fit mask
%             while exitDemo==false,                
            while settingMaskMode == true,
                nloop = nloop + 1;

                
                %%%%%%%%%%%%%%% INPUTs (mouse and keyboard) %%%%%%%%%%%%%%%
                 % Check the keyboard to see if a button has been pressed
                [keyIsDown,secs, keyCode] = KbCheck;

                
                %%%%%%%%%%%%%%%% SET PARAMETERS  MASK %%%%%%%%%%%%%%%%%%%%%
                % Set the SPEED we want to move the mask
                if KbCheck,
                    if keyCode(speedKey)
                        pixelsPerPress = 40;   
                    else
                        pixelsPerPress = 1;
                    end

                    % Set the INTENSITY we want the mask 
                    if keyCode(inintensityKey)
                        if (nloop - timeReadkey) > 5
                            if intensity <= (1-intensityStep)
                                intensity = intensity + intensityStep;
                            end
                            timeReadkey = nloop;
                        end
                    elseif keyCode(deintensityKey)
                        if (nloop - timeReadkey) > 5
                            if intensity >= (intensityStep)
                                intensity = intensity - intensityStep;
                            end
                            timeReadkey = nloop;
                        end
                    else
                        timeReadkey = nloop;
                    end
    %                 rectColor = [rectColor(1:3) intensity];

                    % Set the ANGLE to mask
                    if keyCode(indegreeKey)
                        angle = mod(angle + degreePerFrame,360);
                    elseif keyCode(dedegreeKey)
                        angle = mod(angle - degreePerFrame,360);
                    end

                    % Set the SHIFT POSITION we want move the mask

                    if keyCode(leftKey) 
                        shiftX = shiftX + pixelsPerPress;
                    elseif keyCode(rightKey)
                        shiftX = shiftX - pixelsPerPress;
                    elseif keyCode(upKey)
                        shiftY = shiftY - pixelsPerPress;
                    elseif keyCode(downKey)
                        shiftY = shiftY + pixelsPerPress;
                    end

                    % Set BOUNDS to make sure the mask doesn't go completely off of
                    % the screen with margin of delta pixels
                    %[0 0 s2 s1]
                    widthLim = abs(width*cos(deg2rad(angle)))+abs(height*sin(deg2rad(angle)));
                    heightLim = abs(width*sin(deg2rad(angle)))+abs(height*cos(deg2rad(angle)));
                    if shiftX < -(RectWidth(experiment(kexp).position)/2 + widthLim) + delta
                      shiftX = -(RectWidth(experiment(kexp).position)/2 + widthLim) + delta;
                    elseif shiftX > (RectWidth(experiment(kexp).position)/2 + widthLim) - delta
                        shiftX = (RectWidth(experiment(kexp).position)/2 + widthLim) - delta;
                    end

                    if shiftY < -(RectHeight(experiment(kexp).position)/2 + heightLim) + delta
                        shiftY = -(RectHeight(experiment(kexp).position)/2 + heightLim) + delta;
                    elseif shiftY > (RectHeight(experiment(kexp).position)/2 + heightLim) - delta 
                        shiftY = (RectHeight(experiment(kexp).position)/2 + heightLim) - delta;
                    end

                    % Set the SIZE (width and height) of the mask
                    if keyCode( inWidthKey ) 
                        width = width + stepSize;
                    elseif keyCode( deWidthKey ) && (width > stepSize)
                        width = width - stepSize;
                    end
                    if keyCode( incHeighKey ) 
                        height = height + stepSize;
                    elseif keyCode( deHeighKey ) && ( height > stepSize )
                        height = height - stepSize;
                    end       
                    % Set the SHAPE of the mask to rectangle or ellipse
                    if keyCode(squareKey)
                        maskShape = 'rect';
                    elseif keyCode(ovalKey)
                        maskShape = 'oval';
                    end                    
                    if keyCode(resetKey)
                        angle = 0;
                        width = 60;
                        height = 50;
                    end

                    
                    % Get mask
                    [x, y] = meshgrid(-s1/2:1:s1/2-1, -s2/2:1:s2/2-1);
                    imgMask =  uint8(ones(s2, s1)*255);
                    rotMask = deg2rad(angle);
                    % oval shape
                    if strcmp(maskShape,'oval')
                        x = x + shiftX;
                        y = y - shiftY;
                        mask = uint8((((x*cos(rotMask)-y*sin(rotMask))./width).^2+...
                            ((x*sin(rotMask)+y*cos(rotMask))./height).^2 >= 1)*255);
                    else %rect shape
                        [xr, yr] = meshgrid(-round(ss*factor/2):1:round(ss*factor/2)-1, -round(ss*factor/2):1:round(ss*factor/2)-1);
                        mask = ((abs(xr) < width) & (abs(yr) < height));
                        mask = uint8((~imrotate(mask,angle,'crop'))*255);
                        imgMask =  uint8(ones(ss*factor, ss*factor)*255);      
                        if shiftX >= 0 && shiftY >= 0, %move ^>
                            imgMask(shiftY+1:end,1:end-shiftX) = mask(1:end-shiftY,shiftX+1:end);
                        elseif shiftX >= 0 && shiftY <= 0, %move v>
                            imgMask(1:end-abs(shiftY),1:end-shiftX) = mask(abs(shiftY)+1:end,shiftX+1:end);
                        elseif shiftX <= 0 && shiftY <= 0, %move <v
                            imgMask(1:end-abs(shiftY),abs(shiftX)+1:end) = mask(abs(shiftY)+1:end,1:end-abs(shiftX));
                        elseif shiftX <= 0 && shiftY >= 0, %move <^
                            imgMask(shiftY+1:end,abs(shiftX)+1:end) = mask(1:end-shiftY,1:end-abs(shiftX));
                        else
                            imgMask = mask;
                        end
                        mask = imgMask(round((ss*factor-s1)/2)+1:round((ss*factor+s1)/2), round((ss*factor-s2)/2)+1:round((ss*factor+s2)/2));
                    end                    
                end
                
                %%%%%%%%%%%%%%%%%%%%% DISPLAY PARAMETERS %%%%%%%%%%%%%%%%%%
                % Set TEXT string with all parameters 
                textString = [' X0 : ' num2str(shiftX)...
                    '\n Y0 : ' num2str(shiftY)...
                    '\n Width : ' num2str(round( 2*width-1))...
                    '\n height : ' num2str(round( 2*height-1 ))...
                    '\n Angle : ' num2str(round(mod(angle,360)))...
                    '\n exit : ' num2str(round(keyCode(escapeKey)))...
                    '\n ifi : ' num2str(1/refresh)...
                    '\n alpha : ' num2str(intensity)];
                
                %%%%%%%%%%%%%%%%%% SET TEXTURE TO SCREEN %%%%%%%%%%%%%%%%%%  

                % Draw texture according to mask 
                switch experiment(kexp).maskStimulus.protocol.type
                    case 'Flicker',
                        if mod(nloop, nperiod) < nflicker
                            if mod(nloop, nperiod) == 0,
                                npresentedflicker = npresentedflicker+1;
                                nflickerImg = mod(npresentedflicker-1, experiment(kexp).img.files)+1;
                            end
                            Screen('DrawTexture', win, experiment(kexp).img.charge(nflickerImg),[],experiment(kexp).position);
                        else
                            if experiment(kexp).maskStimulus.protocol.flicker.bg.isImg 
                                Screen('FillRect',win,[0 0 0]);
                                Screen('DrawTexture', win, MSflickerBackground,[],experiment(kexp).maskStimulus.protocol.flicker.bg.position);
                            else
                                bgnColor = [experiment(kexp).maskStimulus.protocol.flicker.bg.r ...
                                    experiment(kexp).maskStimulus.protocol.flicker.bg.g experiment(kexp).maskStimulus.protocol.flicker.bg.b];
                                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                    bgnColor = bitshift(bgnColor,-4)+bitshift(bitshift(bgnColor,-4),4);	
                                end
                                Screen('FillRect', win, bgnColor, experiment(kexp).position);
                            end     
                        end
                    case 'Images',
                            kimages = mod(nloop,experiment(kexp).img.files);
                            Screen('DrawTexture', win, experiment(kexp).img.charge(kimages+1),[],experiment(kexp).position);
                    case 'Solid color',
                        if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                            pColor = bitshift(experiment(kexp).maskStimulus.protocol.solidColor,-4)+bitshift(bitshift(experiment(kexp).maskStimulus.protocol.solidColor,-4),4);	
                        else
                            pColor = experiment(kexp).maskStimulus.protocol.solidColor;
                        end
                        Screen('FillRect',win,[pColor.r, pColor.g, pColor.b]*intensity, experiment(kexp).position)
                    case 'White noise',
                        protocolImage = uint8(0*experiment(kexp).maskStimulus.protocol.wn.noise);
                        if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                            for imageCombination = 1:2; 
                                [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                                protocolImage = protocolImage + bitshift(bitshift(noiseimg,-4),4*(imageCombination-1));	
                            end
                        else
                            [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                            protocolImage = noiseimg;	
                        end

                        noisetxt = Screen('MakeTexture',win,protocolImage);
                        Screen('DrawTexture', win, noisetxt,[],experiment(kexp).position);
                        Screen('Close',noisetxt);
                end
                
                % Get the masked image depending on the mask type
                if ~strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                    maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, nloop );                                           
                else
                    maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                    if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                        for imageCombination = 1:2; 
                            saveIndex = (nloop-1)*2 + imageCombination;
                            imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );		
                            maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));		
                        end
                    else
                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, nloop );
                        maskImage = imgmaskTemp;
                    end                    
                end
                textureMask = Screen('MakeTexture', win, maskImage);  
                Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);
                Screen('Close',textureMask);
                % Draw Text
                DrawFormattedText(win, textString, 10, 20, [255 255 255]);

                % Flip to the screen
                if nRefreshImg == 1,
                    vbl = Screen('Flip', win, vbl);
                else
                    vbl = Screen('Flip', win, vbl + ...
                        (nRefreshImg - 0.5) * refresh);
                end
                
                if keyCode(escapeKey)
                    settingMaskMode = false;
                    if experiment(kexp).protocol.useImages,
                        for kimg = 1:experiment(kexp).img.files,
                           Screen('Close',experiment(kexp).img.charge(kimg));
                        end
                    end
                    continue;
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%% Run the Final Protocol %%%%%%%%%%%%%%%%
            % When exit of the Loop for fit mask continue with the next
            % protocol
            if ~presentationMaskMode,
                presentationMaskMode = true;
                kexp = kexp + 1;
                continue;
            end

            % counter for signal sync 
            b = 0; 
            b_serial = 0;
            
            % Load the images and fix these as a texture 
            % before of the presentation
            if intensity ~= 0 && experiment(kexp).protocol.useImages && experiment(kexp).img.files > 0, 
                if experiment(kexp).img.files == 1,
                    num = [];
                    name = experiment(kexp).img.nInitial;
                    ext = [];
                    nInit = 1;
                elseif experiment(kexp).img.files > 1
                    difference=find((experiment(kexp).img.nInitial==experiment(kexp).img.nFinal)==0);
                    nExt = find(experiment(kexp).img.nInitial=='.');
                    ext = experiment(kexp).img.nInitial(nExt(end):end);% name of img extension 
                    name = experiment(kexp).img.nInitial(1:difference(1)-1);% name of img
                    nInit = str2double(experiment(kexp).img.nInitial(difference(1):nExt(end)-1));% initial number of images name
                    ns = ['%0' num2str(nExt(end)-difference(1)) 'd'];
                end
                
                for j=nInit:experiment(kexp).img.files+nInit-1,
                    if experiment(kexp).img.files > 1,
                        num = sprintf(ns,j);
                    end
                    
                    imgName = fullfile(experiment(kexp).img.directory,strcat(name,num,ext)); 
                    if exist(imgName,'file'),
                        loadedImg = imread(imgName)*intensity;
                        if islogical(loadedImg) || useDigitalProjector,
                            loadedImg = uint8(loadedImg);
                        end
                        % over 60 hz (useDigitalProjector) the images are compressed using a binary shift
                        if useDigitalProjector,
                            if mod(j-nInit,2),
                                loadedImg2 = loadedImg1 + bitshift(bitshift(loadedImg,-4),4);
                                Screen('Close',experiment(kexp).img.charge(j-nInit));
                                experiment(kexp).img.charge((j-nInit-1)/2) = Screen('MakeTexture',win,loadedImg2); 
                            else
                                loadedImg1 = bitshift(loadedImg,-4);
                                experiment(kexp).img.charge((j-nInit)/2+1) = Screen('MakeTexture',win,loadedImg); 
                            end                            
                        else
                            Screen('Close',experiment(kexp).img.charge(j-nInit+1));
                            experiment(kexp).img.charge(j-nInit+1) = Screen('MakeTexture',win,loadedImg); 
                        end

                        if ~mod(j,100)
                            Screen('DrawText', win,['Charging experiment ' num2str(kexp) ' img ' num2str(j-nInit+1) ],...
                                wScreen/2-170, kexp*hScreen/(lengthProtocols+1), [150, 150, 0]);
                            display(['Charging experiment ' num2str(kexp) ' img ' num2str(j-nInit+1) ])
                            Screen('Flip',win);
                        end
                    else
                        disp(['Not exist ' imgName ' file, check the image and retry.'])
                        return;
                    end
                end
            end
            
           %Set Flicker background image as a texture           
            if experiment(kexp).maskStimulus.protocol.flicker.bg.isImg
                imgName = experiment(kexp).maskStimulus.protocol.flicker.bg.name;
                if exist(imgName,'file'),
                    [tmp,tmpMap] = imread(imgName);
                    if isempty(tmpMap)
                        if useDigitalProjector,
                        tmp = uint8(tmp*intensity);
                        tmp = bitshift(tmp,-4) + bitshift(bitshift(tmp,-4),4);
                        end                    
                        MSflickerBackground = Screen('MakeTexture', win,tmp);
                        clear tmp;
                    else % it's index color frame and not RGB color
                        indexColorFrame = 1; break;
                    end
                else
                    imgFilesNotCharged = true; break;
                end                
            end
            
            % Get the Mask
            s1 = experiment(kexp).maskStimulus.mask.width;
            s2 = experiment(kexp).maskStimulus.mask.height;
            
            [x, y] = meshgrid(-s1/2:1:s1/2-1, -s2/2:1:s2/2-1);
            imgMask =  uint8(ones(s2, s1)*255);
            rotMask = deg2rad(angle);
            if strcmp(maskShape,'oval')% oval shape
                x = x + shiftX;
                y = y - shiftY;
                mask = uint8((((x*cos(rotMask)-y*sin(rotMask))./width).^2+...
                    ((x*sin(rotMask)+y*cos(rotMask))./height).^2 >= 1)*255);
            else % rectangle shape
                mask = ((abs(x) < width) & (abs(y) < height));
                mask = uint8((~imrotate(mask,angle,'crop'))*255);

                if shiftX >= 0 && shiftY >= 0, %move ^>
                    imgMask(shiftY+1:end,1:end-shiftX) = mask(1:end-shiftY,shiftX+1:end);
                elseif shiftX >= 0 && shiftY <= 0, %move v>
                    imgMask(1:end-abs(shiftY),1:end-shiftX) = mask(abs(shiftY)+1:end,shiftX+1:end);
                elseif shiftX <= 0 && shiftY <= 0, %move <v
                    imgMask(1:end-abs(shiftY),abs(shiftX)+1:end) = mask(abs(shiftY)+1:end,1:end-abs(shiftX));
                elseif shiftX <= 0 && shiftY >= 0, %move <^
                    imgMask(shiftY+1:end,abs(shiftX)+1:end) = mask(1:end-shiftY,1:end-abs(shiftX));
                else
                    imgMask(:,:) = mask;
                end
                mask = imgMask;
            end
            
            

            % Draw background and sync bar before stimulus
            if experiment(kexp).beforeStimulus.is
                Screen('FillRect',win,BSbackgroundColor);
                if experiment(kexp).beforeStimulus.bar.is
                    Screen('FillRect',win,BSbarColor, BSbarPosition);
                end
                Time(kexp).start = Screen('Flip', win, vbl);
                vbl = WaitSecs(round(experiment(kexp).beforeStimulus.time/(refresh*1000.0))*refresh-0.5*refresh);
            end
                        
            % Get the masked image depending on the mask type
            j=1;
            if ~strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, j );                                           
            else
                maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                    for imageCombination = 1:2; 
                        saveIndex = (j-1)*2 + imageCombination;
                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );		
                        maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));
                        if experiment(kexp).maskStimulus.mask.wn.saveImages >= saveIndex,
                            if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,saveIndex)...
                                    = imgmaskTemp(:,:,1);   
                            else
                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,saveIndex)...
                                    = imgmaskTemp(:,:,1:3);
                            end
                        end
                    end
                else
                    imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, j );
                    maskImage = imgmaskTemp;
                    if experiment(kexp).maskStimulus.mask.wn.saveImages >= j,
                        if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,j)...
                                = imgmaskTemp(:,:,1);   
                        else
                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,j)...
                                = imgmaskTemp(:,:,1:3);
                        end
                    end
                end                    
            end

            textureMask = Screen('MakeTexture', win, maskImage);
            
            % Get the first image for white noise protocol
            if strcmp(experiment(kexp).maskStimulus.protocol.type,'White noise')
                protocolImage = uint8(0*experiment(kexp).maskStimulus.protocol.wn.noiseimg);
                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                    for imageCombination = 1:2; 
                        [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                        saveIndex = (j-1)*2 + imageCombination;
                        if saveIndex<=experiment(kexp).maskStimulus.protocol.wn.saveImages,
                            if strcmp(experiment(kexp).maskStimulus.protocol.wn.type,'BW')
                                experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,saveIndex)...
                                    = noiseimg;
                            else
                                experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,:,saveIndex)...
                                    = noiseimg;
                            end
                        end
                        protocolImage = protocolImage + bitshift(bitshift(noiseimg,-4),4*(imageCombination-1));	
                    end
                else
                    [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                    if j<=experiment(kexp).maskStimulus.protocol.wn.saveImages,
                        if strcmp(experiment(kexp).maskStimulus.protocol.wn.type,'BW')
                            experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,j)...
                                = noiseimg;
                        else
                            experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,:,j)...
                                = noiseimg;
                        end
                    end
                    protocolImage = noiseimg;	
                end            
            end            
       
            % Draw the  first  stimulus for check the well comunication
            % with projector if it's successful continue  the experiment 
            % otherwise the next experiment is displayed
            if experiment(kexp).protocol.useImages,
                firstStimulusTexture = experiment(kexp).img.charge(1);
                Screen('DrawTexture', win, firstStimulusTexture,[],experiment(kexp).position);
            elseif strcmp(experiment(kexp).maskStimulus.protocol.type,'White noise'),
                firstStimulusTexture = Screen('MakeTexture',win,protocolImage); 
                Screen('DrawTexture', win, firstStimulusTexture,[],experiment(kexp).position);
            elseif strcmp(experiment(kexp).maskStimulus.protocol.type,'Solid color'),
                colorSC = [experiment(kexp).maskStimulus.protocol.solidColor.r,...
                    experiment(kexp).maskStimulus.protocol.solidColor.g,...
                    experiment(kexp).maskStimulus.protocol.solidColor.b];
                Screen('FillRect',win,colorSC*intensity,experiment(kexp).position);
            end
            
            % Draw mask
            Screen('DrawTexture', win, textureMask, [], experiment(kexp).positionMask);
            Screen('Close',textureMask);

            % Start Digital or Analog Synchronize
            % If use 120Hz and the trigger was select the projector 
            % mark all frame with digital pulse, if the trigger was not 
            % select then mark only for 18[ms] before stimulus. Otherwise
            % show the analog synchronize
            if experiment(kexp).sync.is
                if experiment(kexp).sync.isdigital,% digital synchronize
                    try
                        if strcmp(experiment(kexp).sync.digital.mode,'On every frames'), 
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                        else
                            error = setProjector(FPS_120HZ);
                            error = error || setTrigger(TRIGGER_TIME_UP); 
                            WaitSecs(WAIT_TIME_SIGNAL); 
                            error = error || setProjector(FPS_60HZ);
                        end
                    catch exceptions
                        display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                    if error,
                        display('Error communicating with the projector: setting trigger')
                        Screen('Close')
                        Screen('CloseAll')
                        return
                    end
                else % analog synchronize
                    Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                    b = b + 1;
                end
            end

            if data.sync.isSerial
                IOPort('Write', serialCom, change);
                b_serial = b_serial + 1;
            end            

            vbl = Screen('Flip',win,vbl);

            if ~experiment(kexp).beforeStimulus.is
                Time(kexp).start = vbl;
            end

            % if set 'include prev. background' that is repeat using the 
            % previos protocol, otherwise repeat over own
            if experiment(kexp).maskStimulus.repeatBackground,
                rep = 0;
            else
                rep = experiment(kexp).maskStimulus.repetitions;
            end
            
            %loop repetition protocol
            switch experiment(kexp).maskStimulus.protocol.type
                case 'Images'
                    for repProto = 1:rep+1,
                        if repProto==1, 
                            tmp = 2; 
                        else
                            tmp = 1; 
                                % Digital Synchronize 
                                % For repetition without prev. background and use 120HZ and not use
                                % trigger, it's mark for 18[ms] the start of repetition.
                            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && ~strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                try
                                    error = setProjector(FPS_120HZ);
                                    error = error || setTrigger(TRIGGER_TIME_UP); 
                                    WaitSecs(WAIT_TIME_SIGNAL); 
                                    error = error || setProjector(FPS_60HZ); 
                                catch exceptions
                                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end

                                if error,
                                    display('Error communicating with the projector: setting trigger')
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                            end
                        end
                        
                        %loop images of protocol
                        for kimg= tmp:experiment(kexp).img.files,
                            % set the background
                            if experiment(kexp).img.background.isImg
                                Screen('FillRect',win,[0 0 0]);
                                Screen('DrawTexture',win,background);
                            else
                                Screen('FillRect', win, backgroundImgColor);
                            end

%                             % MASK type
%                             imgmask = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );

                            % Get the masked image depending on the mask type
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                                maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                    for imageCombination = 1:2; 
                                        saveIndex = (kimg-1)*2 + imageCombination;
                                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );		
                                        maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));
                                        if experiment(kexp).maskStimulus.mask.wn.saveImages >= saveIndex  && repProto == 1,
                                            if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1);   
                                            else
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1:3);
                                            end
                                        end
                                    end
                                else
                                    imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );
                                    maskImage = imgmaskTemp;
                                    if experiment(kexp).maskStimulus.mask.wn.saveImages >= kimg  && repProto == 1,
                                        if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,kimg)...
                                                = imgmaskTemp(:,:,1);   
                                        else
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,kimg)...
                                                = imgmaskTemp(:,:,1:3);
                                        end
                                    end
                                end                    
                            else
                                maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );                                               
                            end
                            textureMask = Screen('MakeTexture', win, maskImage);

%Revisar, que imagenes del wn se guardaran 
% usar nloop (guarda solo al principio) 
% o kimg (que guarda al principio de casa repeticion)
                            % draw Texture 
                            disp(kimg)
                            Screen('DrawTexture', win, experiment(kexp).img.charge(kimg),[],experiment(kexp).position); 
                            Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);
                            Screen('Close',textureMask);
      
                            %draw botton bar
                            % Analog Sychronize
                            if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                                Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                                b = b + 1;
                            end

                            if data.sync.isSerial
                                IOPort('Write', serialCom, change);
                                b_serial = b_serial + 1;
                            end

                            if nRefreshImg == 1,
                                vbl = Screen('Flip', win, vbl);
                            else
                                vbl = Screen('Flip', win, vbl + ...
                                    (nRefreshImg - 0.5) * refresh);
                            end

                            if repProto == experiment(kexp).maskStimulus.repetitions+1,
                                Screen('Close',experiment(kexp).img.charge(kimg-nInit+1));
                            end
                        end
                    end
                case 'Flicker'
                    for repProto = 1:(rep+1)*experiment(kexp).img.files,
                        if repProto==1, 
                            tmp = 2; 
                        else
                            tmp = 1; 
                            % Digital Synchronize 
                            % For repetition without prev. background and use projector and not use
                            % trigger, it's mark for 18[ms] the start of repetition.
                            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && ~strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                try
                                    error = setProjector(FPS_120HZ);
                                    error = error || setTrigger(TRIGGER_TIME_UP); 
                                    WaitSecs(WAIT_TIME_SIGNAL); 
                                    error = error || setProjector(FPS_60HZ);
                                catch exceptions
                                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                                if error,
                                    display('Error communicating with the projector: setting trigger')
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                            end
                        end
                        % index for images presentation
                        indexImg =  mod(repProto-1,experiment(kexp).img.files)+1;
                        
                        %loop images of protocol
                        for kframe = tmp:nperiod,
                            % set the background
                            if experiment(kexp).img.background.isImg
                                Screen('FillRect',win,[0 0 0]);
                                Screen('DrawTexture',win,background);
                            else
                                Screen('FillRect', win, backgroundImgColor);
                            end

%                             % MASK type
%                             imgmask = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kframe );

                            % Get the masked image depending on the mask type
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                                maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                    for imageCombination = 1:2; 
                                        saveIndex = (kimg-1)*2 + imageCombination;
                                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );        
                                        maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));
                                        if experiment(kexp).maskStimulus.mask.wn.saveImages >= saveIndex  && repProto == 1,
                                            if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1);   
                                            else
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1:3);
                                            end
                                        end
                                    end
                                else
                                    imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );
                                    maskImage = imgmaskTemp;
                                    if experiment(kexp).maskStimulus.mask.wn.saveImages >= kimg  && repProto == 1,
                                        if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,kimg)...
                                                = imgmaskTemp(:,:,1);   
                                        else
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,kimg)...
                                                = imgmaskTemp(:,:,1:3);
                                        end
                                    end
                                end                    
                            else
                                maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );                                               
                            end
                            textureMask = Screen('MakeTexture', win, maskImage);
                            
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise')
                                if experiment(kexp).maskStimulus.mask.wn.saveImages >= kframe,
                                    if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                        experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,kframe)...
                                            = maskImage(:,:,1);   
                                    else
                                        experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,kframe)...
                                            = maskImage(:,:,1:3);
                                    end
                                end
                            end
                            if kframe <= nflicker,
                                % draw the ON period
                                Screen('DrawTexture', win, experiment(kexp).img.charge(indexImg),[],experiment(kexp).position); 
                                Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);
                                Screen('Close',textureMask);
                                
                                % Analog Synchronize
                                if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                                    Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                                    b = b + 1;
                                end

                                if data.sync.isSerial
                                    IOPort('Write', serialCom, change);
                                    b_serial = b_serial + 1;
                                end    
                            else % draw the OFF period
                                if experiment(kexp).maskStimulus.protocol.flicker.bg.isImg 
                                    Screen('FillRect',win,[0 0 0]);
                                    Screen('DrawTexture', win, MSflickerBackground,[],experiment(kexp).maskStimulus.protocol.flicker.bg.position);
                                    Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);  
                                    Screen('Close',textureMask);
                                else
                                    Screen('FillRect', win, [experiment(kexp).maskStimulus.protocol.flicker.bg.r ...
                                    experiment(kexp).maskStimulus.protocol.flicker.bg.g experiment(kexp).maskStimulus.protocol.flicker.bg.b],...
                                    experiment(kexp).position);
                                    Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);  
                                    Screen('Close',textureMask);
                                end
                            end

                            if nRefreshImg == 1,
                                vbl = Screen('Flip', win, vbl);
                            else
                                vbl = Screen('Flip', win, vbl + ...
                                    (nRefreshImg - 0.5) * refresh);
                            end
                        end
                    end
                case 'Solid color'                
                    for repProto = 1:rep+1,
                        if repProto==1, 
                            tmp = 2; 
                        else
                            tmp = 1; 
                            % Digital Synchronize 
                            % For repetition without prev. background and use projector and not use
                            % trigger, it's mark for 18[ms] the start of repetition.
                            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && ~strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                try
                                    error = setProjector(FPS_120HZ);
                                    error = error || setTrigger(TRIGGER_TIME_UP); 
                                    WaitSecs(WAIT_TIME_SIGNAL); 
                                    error = error || setProjector(FPS_60HZ); 
                                catch exceptions
                                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                                if error,
                                    display('Error communicating with the projector: setting trigger')
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                            end
                        end
                        %loop images of protocol
                        for kimg= tmp:experiment(kexp).maskStimulus.protocol.solidColor.nframes,
                            % set the background
                            if experiment(kexp).img.background.isImg
                                Screen('FillRect',win,[0 0 0]);
                                Screen('DrawTexture',win,background);
                            else
                                Screen('FillRect', win, backgroundImgColor);
                            end

%                             % MASK type
%                             imgmask = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );
                            
                            % Get the masked image depending on the mask type
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                                maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                    for imageCombination = 1:2; 
                                        saveIndex = (kimg-1)*2 + imageCombination;
                                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );        
                                        maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));
                                        if experiment(kexp).maskStimulus.mask.wn.saveImages >= saveIndex  && repProto == 1,
                                            if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1);   
                                            else
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1:3);
                                            end
                                        end
                                    end
                                else
                                    imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );
                                    maskImage = imgmaskTemp;
                                    if experiment(kexp).maskStimulus.mask.wn.saveImages >= kimg  && repProto == 1,
                                        if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,kimg)...
                                                = imgmaskTemp(:,:,1);   
                                        else
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,kimg)...
                                                = imgmaskTemp(:,:,1:3);
                                        end
                                    end
                                end                    
                            else
                                maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, kimg );                                               
                            end
                            textureMask = Screen('MakeTexture', win, maskImage);
                            
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise')
                                if experiment(kexp).maskStimulus.mask.wn.saveImages >= kimg,
                                    if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                        experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,kimg)...
                                            = maskImage(:,:,1);   
                                    else
                                        experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,kimg)...
                                            = maskImage(:,:,1:3);
                                    end
                                end
                            end                            

                            % draw Texture 
                            Screen('FillRect',win,colorSC*intensity,experiment(kexp).position);
                            Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);
                            Screen('Close',textureMask);
                            
                            
                            %draw botton bar
                            % Analog Synchronize
                            if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                                Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                                b = b + 1;
                            end

                            if data.sync.isSerial
                                IOPort('Write', serialCom, change);
                                b_serial = b_serial + 1;
                            end

                            if nRefreshImg == 1,
                                vbl = Screen('Flip', win, vbl);
                            else
                                vbl = Screen('Flip', win, vbl + ...
                                    (nRefreshImg - 0.5) * refresh);
                            end
                        end
                    end
                case 'White noise'
                    for repProto = 1:rep+1,
                        if repProto==1, 
                            tmp = 2; 
                        else
                            tmp = 1; 
                            % Digital Synchronize 
                            % For repetition without prev. background and use projector and not use
                            % trigger, it's mark for 18[ms] the start of repetition.
                            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && ~strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                try
                                    error = setProjector(FPS_120HZ);
                                    error = error || setTrigger(TRIGGER_TIME_UP); 
                                    WaitSecs(WAIT_TIME_SIGNAL); 
                                    error = error || setProjector(FPS_60HZ); 
                                catch exceptions
                                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                                if error,
                                    display('Error communicating with the projector: setting trigger')
                                    Screen('Close')
                                    Screen('CloseAll')
                                    return
                                end
                            end
                        end          
                        
                        if experiment(kexp).sync.is && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                            limit = experiment(kexp).maskStimulus.protocol.wn.frames/2;
                        else
                            limit = experiment(kexp).maskStimulus.protocol.wn.frames;
                        end

                        for j=tmp:limit,
                            % Set the background
                            if experiment(kexp).img.background.isImg
                                Screen('FillRect',win,[0 0 0]);
                                Screen('DrawTexture',win,background);
                            else
                                Screen('FillRect', win, backgroundImgColor);
                            end

                            if ~mod(j,1000),
                                disp(['Rep: ' num2str(j) '/' num2str(limit)]);
                            end

                            protocolImage = uint8(0*experiment(kexp).maskStimulus.protocol.wn.noise);
                            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                for imageCombination = 1:2; 
                                    [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                                    saveIndex = (j-1)*2 + imageCombination;
                                    if saveIndex<=experiment(kexp).maskStimulus.protocol.wn.saveImages,
                                        if strcmp(experiment(kexp).maskStimulus.protocol.wn.type,'BW')
                                            experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,saveIndex)...
                                                = noiseimg;
                                        else
                                            experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,:,saveIndex)...
                                                = noiseimg;
                                        end
                                    end
                                    protocolImage = protocolImage + bitshift(bitshift(noiseimg,-4),4*(imageCombination-1));
                                end
                            else
                                [~, noiseimg] = getRandWNimg(experiment(kexp).maskStimulus.protocol.wn);
                                if j<=experiment(kexp).maskStimulus.protocol.wn.saveImages,
                                    if strcmp(experiment(kexp).maskStimulus.protocol.wn.type,'BW')
                                        experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,j)...
                                            = noiseimg;
                                    else
                                        experiment(kexp).maskStimulus.protocol.wn.imgToComp(:,:,:,j)...
                                            = noiseimg;
                                    end
                                end
                                protocolImage = noiseimg;	
                            end
                            
                            % Get the masked image depending on the mask type
                            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                                maskImage = uint8(0*experiment(kexp).maskStimulus.mask.wn.noise);
                                if experiment(kexp).sync.is && experiment(kexp).sync.isdigital && strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                                    for imageCombination = 1:2; 
                                        saveIndex = (j-1)*2 + imageCombination;
                                        imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, saveIndex );        
                                        maskImage = maskImage + bitshift(bitshift(imgmaskTemp,-4),4*(imageCombination-1));
                                        if experiment(kexp).maskStimulus.mask.wn.saveImages >= saveIndex  && repProto == 1,
                                            if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1);   
                                            else
                                                experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,saveIndex)...
                                                    = imgmaskTemp(:,:,1:3);
                                            end
                                        end
                                    end
                                else
                                    imgmaskTemp = getMaskImg( experiment(kexp).maskStimulus.mask, mask, j );
                                    maskImage = imgmaskTemp;
                                    if experiment(kexp).maskStimulus.mask.wn.saveImages >= j  && repProto == 1,
                                        if strcmp(experiment(kexp).maskStimulus.mask.wn.type,'BW')
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,j)...
                                                = imgmaskTemp(:,:,1);   
                                        else
                                            experiment(kexp).maskStimulus.mask.wn.imgToComp(:,:,:,j)...
                                                = imgmaskTemp(:,:,1:3);
                                        end
                                    end
                                end                    
                            else
                                maskImage = getMaskImg( experiment(kexp).maskStimulus.mask, mask, j );                                               
                            end
                            
                            noisetxt = Screen('MakeTexture',win,protocolImage);
                            Screen('DrawTexture', win, noisetxt,[],experiment(kexp).position);
                            Screen('Close',noisetxt);

                            textureMask = Screen('MakeTexture', win, maskImage);                        
                            Screen('DrawTextures', win, textureMask, [], experiment(kexp).positionMask);
                            Screen('Close',textureMask);                        


                            % Analog Synchronize
                            if experiment(kexp).sync.is && ~experiment(kexp).sync.isdigital,
                                Screen('FillRect', win,baseColorBar + colorBar*mod(b,experiment(kexp).sync.analog.division), positionBar);
                                    b = b + 1;
                            end
                            % Serial Synchronize
                            if data.sync.isSerial
                                % fwrite(serialCom,change);
                                IOPort('Write', serialCom, change);
                                b_serial = b_serial + 1;
                            end

                            if nRefreshImg == 1,
                                vbl = Screen('Flip', win, vbl);
                            else
                                vbl = Screen('Flip', win, vbl + ...
                                    (nRefreshImg - 0.5) * refresh);
                            end
                        end     
                    end
            end
            Time(kexp).finish = WaitSecs((nRefreshImg - 0.5) * refresh);
            disp(['Time experiment: ' int2str(Time(kexp).finish-Time(kexp).start)])
            experiment(kexp).maskStimulus.mask.mask = mask;
           
            % End Digital Synchronize
            % If the trigger was select (120 hz) the projector 
            % return to normal state  (60 hz) and with these end the trigger state.
            % Otherwise mark end for 18 [ms] with the trigger signal 
            if experiment(kexp).sync.is && experiment(kexp).sync.isdigital,
                try  
                    if strcmp(experiment(kexp).sync.digital.mode,'On every frames'),
                        error = setProjector(FPS_60HZ); 
                    else
                        error = setProjector(FPS_120HZ); 
                        error = error || setTrigger(TRIGGER_TIME_UP); 
                        WaitSecs(WAIT_TIME_SIGNAL); 
                        error = error || setProjector(FPS_60HZ);
                    end
                catch exceptions
                    display(['Error communicating with the projector: setting trigger. ' exceptions.message]); Stack  = dbstack; Stack.line
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
                if error,
                    display('Error communicating with the projector: setting trigger')
                    Screen('Close')
                    Screen('CloseAll')
                    return
                end
            end
            
            

            if data.sync.isSerial, Port('Write', serialCom, down); end
            
            if experiment(kexp).img.background.isImg
                Screen('Close',background);
            end
            if ~strcmp(experiment(kexp).maskStimulus.protocol.type,'Flicker'),
                if experiment(kexp).maskStimulus.repeatBackground && kexp>1 && strcmp(experiment(kexp-1).mode,'Presentation') ...
                        && experiment(kexp).img.repeated < experiment(kexp).maskStimulus.repetitions,
                    experiment(kexp).img.repeated = experiment(kexp).img.repeated + 1;
                    kexp = kexp - 2;
                end
            end
        else
            disp('Error, the mode nor exist')
        end % end if-else flicker-fps
    end % end if-else presentation
    disp([kexp Time(kexp).start Time(kexp).finish])
    kexp = kexp + 1;
end % end for(experiments)

% Process aborted by the user
% if abort
%     Screen('DrawText', win, 'Process   aborted  !!', wScreen/2-170, hScreen/2-50, [255, 0, 0]);
%     Screen('Flip',win);
%     WaitSecs(1);
% end

%KbQueueRelease();

%% Finishing
if ~siFilesNotCharged && ~indexColorFrame 
    Screen('DrawText',win,'Process done',...
    wScreen/2-300,hScreen-100,[150,30,30]);
    Screen('Flip',win);
    WaitSecs(1);
end
Screen('Close');
Screen('CloseAll');
Priority(0);
ShowCursor();
data.finishedTime = round(clock);
% Descomentar version final
if ismac,
Screen('Preference', 'SkipSyncTests',oldSkip);
Screen('Preference', 'VisualDebugLevel', oldLevel);
end
if data.sync.isSerial, IOPort('CloseAll');end

% Process aborted because there is a missing file
if imgFilesNotCharged
    disp(['ERROR: File not found: ' imgName]);
end

if indexColorFrame
    disp('ERROR: The frames selected are indexed and non RGB, this creates a delay in the stimulation process. Just use other stimuli.');
end

initialFolder = pwd;
cd(dirName)
dirName = [pwd '/'];
cd(initialFolder)

if ~siFilesNotCharged && ~indexColorFrame && nonVisual
    if useProjector && ~exist(fullfile(dirName,siFileName),'file'),
        copyfile('*.si',dirName);
        saveLogFile(data,Time,dirName);
        delete *.si
    else
        saveLogFile(data,Time,dirName);
    end
    
    for kexp=1:lengthProtocols,
        if strcmp(experiment(kexp).mode,'White noise')
            s = experiment(kexp).whitenoise.seed;
            fi = experiment(kexp).whitenoise.imgToComp;
            save([dirName 'Seed_' num2str(kexp) '.mat'],'s');
            save([dirName 'FirstImages_' num2str(kexp) '.mat'],'fi');
        elseif strcmp(experiment(kexp).mode,'Mask stimulus'),
            if strcmp(experiment(kexp).maskStimulus.mask.type,'White noise'),
                disp('Experiment:')
                disp(kexp)
                s = experiment(kexp).maskStimulus.mask.wn.seed;
                fi = experiment(kexp).maskStimulus.mask.wn.imgToComp;
                save([dirName 'MS_Seed_' num2str(kexp) '.mat'],'s');
                save([dirName 'MS_FirstImages_' num2str(kexp) '.mat'],'fi');
                imwrite(mask,[dirName 'mask_imag.png'])
                save([dirName 'Mask_img.mat'],'mask');
            end
        end
    end
end

if nonVisual
    delete *.si
    exit
else
    cd(initialFolder);
    return
end   

end


