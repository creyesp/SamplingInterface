function setAllGUIParameters(handles)
% Set all GUI parameters from a struct
% input: handles struct of the GUI

% <<< Sample format Panel >>>
% handles.samplingFormat -> tipo de protocolo (type:'Value')
if strcmp(handles.mode,'Flicker'),
    set(handles.samplingFormat,'Value',1.0);
    set(handles.flickerMenu,'visible','on');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','off');
elseif strcmp(handles.mode,'Only stimulus (fps)'),
    set(handles.samplingFormat,'Value',2.0);
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','on');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','off');
elseif strcmp(handles.mode,'White noise'),
    set(handles.samplingFormat,'Value',2.0);
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','on');
    set(handles.maskStimulusMenu,'visible','off');
else
    set(handles.samplingFormat,'Value',1.0);
    set(handles.flickerMenu,'visible','off');
    set(handles.onlyStimulusMenu,'visible','off');
    set(handles.whiteNoiseMenu,'visible','off');
    set(handles.maskStimulusMenu,'visible','on');
end

% Set the parameters of <<<General options Panel>>
set(handles.nFiles,'String',handles.img.files);
set(handles.imgDirectory,'String',handles.img.directory);
set(handles.imgSizeWidth,'String',handles.img.size.width);
set(handles.imgSizeHeight,'String',handles.img.size.height);
set(handles.imgInitial,'String',char('Initial image',handles.list(2:end,:)));
set(handles.imgInitial,'Value',handles.img.nInitialPos);
set(handles.imgFinal,'String',char('Final image',handles.list(2:end,:)));
set(handles.imgFinal,'Value',handles.img.nFinalPos);

if handles.img.background.isImg
    set(handles.backgroundImg,'Value',1.0);
    set(handles.backgroundColor,'Value',0.0);
else
    set(handles.backgroundImg,'Value',0.0);
    set(handles.backgroundColor,'Value',1.0);
end
set(handles.backgroundR,'String',handles.img.background.r);
set(handles.backgroundG,'String',handles.img.background.g);
set(handles.backgroundB,'String',handles.img.background.b);
set(handles.backgroundImgDirection,'String',handles.img.background.imgName);
handles.img.background.graph(:,:,1) = handles.img.background.r/255.0;
handles.img.background.graph(:,:,2) = handles.img.background.g/255.0;
handles.img.background.graph(:,:,3) = handles.img.background.b/255.0;
axes(handles.imgBackgroundGraph);
imshow(handles.img.background.graph);

% Set the parameters of <<<Reproduction list Panel>>
set(handles.experimentList,'String',handles.experiments.list);


% Set the parameters of <<<Selection Screen Panel>>
set(handles.selectScreen,'String',handles.screens.list);
set(handles.selectScreen,'Value',handles.screens.selected+1);
set(handles.screenHeight,'String',handles.screens.height);
set(handles.screenWidth,'String',handles.screens.width);
set(handles.screenRefreshRateHz,'String',1.0/handles.screens.refreshRate);
set(handles.screenRefreshRateMs,'String',handles.screens.refreshRate);

set(handles.totalTime,'String',datestr(datenum(0,0,0,0,0,handles.time),'HH:MM:SS.FFF'));

% Set the parameters of <<<Sample format Panel subsection Digital Signal>>
% handles.bottomBar.graph = zeros(100,100,3);
if handles.sync.is,
    if handles.sync.isdigital
        set(handles.TypeSynchronization,'value',3)
        set(handles.AnalogsyncPanel,'visible','off')
        set(handles.DigitalsyncPanel,'visible','on')        
        if strcmp(handles.sync.digital.mode,'Start and end')
            set(handles.digitalSyncMode,'value',1);
        else % 'On every frames'
            set(handles.digitalSyncMode,'value',2);
        end
    else
        set(handles.TypeSynchronization,'value',2)
        set(handles.AnalogsyncPanel,'visible','on')
        set(handles.DigitalsyncPanel,'visible','off')        
        % todo lo de la analog sync
    end
else
    set(handles.AnalogsyncPanel,'visible','off')
    set(handles.DigitalsyncPanel,'visible','off')
    set(handles.TypeSynchronization,'value',1)
end
if handles.bottomBar.is,
    set(handles.insertBottomBar,'Value',1.0);
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),1) = ...
            handles.bottomBar.r/255.0 ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),2) = ...
            handles.bottomBar.g/255.0 ;
    handles.bottomBar.graph(floor(handles.bottomBar.posTop): ...
        floor(handles.bottomBar.posBottom),...
        floor(handles.bottomBar.posLeft):...
        floor(handles.bottomBar.posRight),3) = ...
            handles.bottomBar.b/255.0 ;
else
    set(handles.insertBottomBar,'Value',0.0);
end
set(handles.bottomBarDivision,'String',handles.bottomBar.division);
set(handles.imgDeltaX,'String',handles.img.deltaX);
set(handles.imgDeltaY,'String',handles.img.deltaY);
if handles.bottomBar.useTrigger,
    set(handles.addTrigger,'Value',1.0);
else
    set(handles.addTrigger,'Value',0.0);
end

axes(handles.bottomBarGraph);
imshow(handles.bottomBar.graph);
set(handles.stimulusBottomBarLevelR,'String',handles.bottomBar.baseR);
set(handles.stimulusBottomBarLevelG,'String',handles.bottomBar.baseG);
set(handles.stimulusBottomBarLevelB,'String',handles.bottomBar.baseB);
set(handles.stimulusBottomBarCr,'String',handles.bottomBar.r);
set(handles.stimulusBottomBarCg,'String',handles.bottomBar.g);
set(handles.stimulusBottomBarCb,'String',handles.bottomBar.b);
set(handles.stimulusBottomBarL,'String',handles.bottomBar.posLeft);
set(handles.stimulusBottomBarT,'String',handles.bottomBar.posTop);
set(handles.stimulusBottomBarR,'String',handles.bottomBar.posRight);
set(handles.stimulusBottomBarB,'String',handles.bottomBar.posBottom);


% Set the parameters of <<<Image before stimuling Panel>>
set(handles.beforeStimulusTime,'String',handles.beforeStimulus.time);
if handles.beforeStimulus.rest,
    set(handles.beforeStimulusRest,'Value',1.0);
else
    set(handles.beforeStimulusRest,'Value',0.0);
end
set(handles.beforeStimulusBgndR,'String',handles.beforeStimulus.background.r);
set(handles.beforeStimulusBgndG,'String',handles.beforeStimulus.background.g);
set(handles.beforeStimulusBgndB,'String',handles.beforeStimulus.background.b);
set(handles.beforeStimulusBottomBarR,'String',handles.beforeStimulus.bar.r);
set(handles.beforeStimulusBottomBarG,'String',handles.beforeStimulus.bar.g);
set(handles.beforeStimulusBottomBarB,'String',handles.beforeStimulus.bar.b);
set(handles.beforeStimulusBottomBarLeft,'String',handles.beforeStimulus.bar.posLeft);
set(handles.beforeStimulusBottomBarTop,'String',handles.beforeStimulus.bar.posTop);
set(handles.beforeStimulusBottomBarRight,'String',handles.beforeStimulus.bar.posRight);
set(handles.beforeStimulusBottomBarBottom,'String',handles.beforeStimulus.bar.posBottom);
if handles.beforeStimulus.is,
    set(handles.useImgBeforeStimuling,'Value',1.0);
    handles.beforeStimulus.graph(:,:,1) = handles.beforeStimulus.background.r/255.0;
    handles.beforeStimulus.graph(:,:,2) = handles.beforeStimulus.background.g/255.0;
    handles.beforeStimulus.graph(:,:,3) = handles.beforeStimulus.background.b/255.0;
    if handles.beforeStimulus.bar.is
        set(handles.beforeStimulusBottomBar,'Value',1.0);
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
    else
        set(handles.beforeStimulusBottomBar,'Value',0.0);
    end
else
    set(handles.useImgBeforeStimuling,'Value',0.0);
    handles.beforeStimulus.graph = zeros(100,100,3);
    if handles.beforeStimulus.bar.is
        set(handles.beforeStimulusBottomBar,'Value',1.0);
    else
        set(handles.beforeStimulusBottomBar,'Value',0.0);
    end
end
axes(handles.beforeStimulusGraph);
imshow(handles.beforeStimulus.graph);

% Set the parameters of <<<Option using only Background Panel>>
set(handles.presentationR,'String',handles.presentation.r);
set(handles.presentationG,'String',handles.presentation.g);
set(handles.presentationB,'String',handles.presentation.b);
set(handles.presentationTime,'String',handles.presentation.time);
if handles.presentation.img.is,
    set(handles.presentationIsImage,'Value',1.0);
else
    set(handles.presentationIsImage,'Value',0.0);
end
set(handles.presentationImg,'String',handles.presentation.img.path);
set(handles.presentationImgMov,'Value',handles.presentation.img.shift+1); %select between none prev or next protocols position
handles.presentation.graph(:,:,1) = handles.presentation.r/255.0;
handles.presentation.graph(:,:,2) = handles.presentation.g/255.0;
handles.presentation.graph(:,:,3) = handles.presentation.b/255.0;
axes(handles.presentationGraph);
imshow(handles.presentation.graph);

% Set the parameters of <<<Option using Flicker stimulus Panel>>
set(handles.flickerFrequency,'String',handles.flicker.fps);
set(handles.flickerNextFrequency,'String',1.0/(handles.screens.refreshRate));
set(handles.flickerPreviousFrequency,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.flickerImgTime,'String',handles.flicker.imgTime);
set(handles.flickerPreviousImgTime,'String',0);
set(handles.flickerNextImgTime,'String',2*handles.flicker.imgTime);
set(handles.flickerPreviousBgndTime,'String',0);
set(handles.flickerNextBgndTime,'String',2*handles.flicker.backgroundTime);
set(handles.flickerBackgroundTime,'String',handles.flicker.backgroundTime);
if handles.flicker.repeatBackground,
    set(handles.flickerRepWithBackground,'Value',1.0)
else
    set(handles.flickerRepWithBackground,'Value',0.0)
end
steps = handles.flicker.fps*handles.screens.refreshRate;
set(handles.flickerDcSlider, 'SliderStep', [steps steps]);
set(handles.flickerDcSlider, 'Value', 50);
set(handles.flickerDc,'String',handles.flicker.dutyCicle);
set(handles.flickerImageRepetition,'String',handles.flicker.repetitions);
set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0, handles.flicker.time),'HH:MM:SS.FFF'));
set(handles.flickerR,'String',handles.flicker.r);
set(handles.flickerG,'String',handles.flicker.g);
set(handles.flickerB,'String',handles.flicker.b);
if handles.flicker.img.is
    set(handles.flickerUseImg,'Value',1.0);
else
    set(handles.flickerUseImg,'Value',0.0);
end
set(handles.flickerImgDirection,'String',handles.flicker.img.name);
handles.flicker.graph(:,:,1) = handles.flicker.r/255.0;
handles.flicker.graph(:,:,2) = handles.flicker.g/255.0;
handles.flicker.graph(:,:,3) = handles.flicker.b/255.0;
axes(handles.flickerGraph);
imshow(handles.flicker.graph);
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
if handles.flicker.confFrecuencyused,
    set(handles.flickerFreqConf,'Value',1);
    set(handles.flickerTimeConf,'Value',0);
else
    set(handles.flickerFreqConf,'Value',0);
    set(handles.flickerTimeConf,'Value',1);
end


% Set the parameters of <<<Option using only Stimulus Panel>>
set(handles.onlyStimulusFps,'String',handles.onlyStimulus.fps);
set(handles.onlyStimulusNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.onlyStimulusPreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.onlyStimulusImageRepeatition,'String',handles.onlyStimulus.repetitions);
set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.onlyStimulus.time),'HH:MM:SS.FFF'));
if handles.onlyStimulus.repeatBackground,
    set(handles.onlyStimulusRepWithBackground,'Value',1.0);
else
    set(handles.onlyStimulusRepWithBackground,'Value',0.0);
end

% Set the parameters of <<<Option using white noise Stimulus Panel>>
set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.whitenoise.time),'HH:MM:SS.FFF'));
set(handles.whiteNoiseFps,'String',handles.onlyStimulus.fps);
set(handles.whiteNoiseNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.whiteNoisePreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
set(handles.whiteNoiseFrames,'String',handles.whitenoise.frames);
set(handles.whiteNoiseBlocks,'String',handles.whitenoise.blocks);

set(handles.whiteNoisePxsX,'String',handles.whitenoise.pxX);
set(handles.whiteNoisePxsY,'String',handles.whitenoise.pxY);
set(handles.noiseMenu,'Value',1.0);
set(handles.whiteNoiseSaveImages,'String',handles.whitenoise.saveImages);
if exist(handles.whitenoise.seedFile,'file')
    set(handles.useSeed,'Value',1.0);
else
    set(handles.useSeed,'Value',0.0);
end
set(handles.seedFile,'String',handles.whitenoise.seedFile);
set(handles.whiteNoiseIntensityR,'String',handles.whitenoise.intensity(1));
set(handles.whiteNoiseIntensityG,'String',handles.whitenoise.intensity(2));
set(handles.whiteNoiseIntensityB,'String',handles.whitenoise.intensity(3));


% Set the parameters of <<<Option using Mask Stimulus Panel>>
set(handles.maskStimulusFps,'String',handles.maskStimulus.fps);
set(handles.maskStimulusRepeat,'String',handles.maskStimulus.repetitions);
set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
    handles.maskStimulus.time),'HH:MM:SS.FFF'));
set(handles.maskStimulusNextFps,'String',1.0/(handles.screens.refreshRate));
set(handles.maskStimulusPreviousFps,'String',1.0/(3.0*handles.screens.refreshRate));
if handles.maskStimulus.repeatBackground
    set(handles.maskStimulusRepWithBackground,'Value',1.0);
else
    set(handles.maskStimulusRepWithBackground,'Value',0.0);
end

set( handles.imgMaskDirectory , 'String', handles.maskStimulus.mask.img.directory);
set( handles.imgMaskInitial , 'Value', handles.maskStimulus.mask.img.nInitialPos);
set( handles.imgMaskFinal , 'Value', handles.maskStimulus.mask.img.nFinalPos);
set( handles.imgMasknFiles , 'String', handles.maskStimulus.mask.img.files);
set( handles.imgMaskSizeWidth , 'String', handles.maskStimulus.mask.img.size.width);
set( handles.imgMaskSizeHeight , 'String', handles.maskStimulus.mask.img.size.height);

handles.maskStimulus.mask.solidColor.graph(:,:,1) = handles.maskStimulus.mask.solidColor.r;
handles.maskStimulus.mask.solidColor.graph(:,:,2) = handles.maskStimulus.mask.solidColor.g;
handles.maskStimulus.mask.solidColor.graph(:,:,3) = handles.maskStimulus.mask.solidColor.b;
axes(handles.MSSolidColorGraph);
imshow(handles.maskStimulus.mask.solidColor.graph);

handles.maskStimulus.mask.wn.graph(:,:,1) = handles.maskStimulus.mask.wn.intensity(1)/255.0;
handles.maskStimulus.mask.wn.graph(:,:,2) = handles.maskStimulus.mask.wn.intensity(2)/255.0;
handles.maskStimulus.mask.wn.graph(:,:,3) = handles.maskStimulus.mask.wn.intensity(3)/255.0;
axes(handles.MSwhitenoiseIntensityGraph);
imshow( handles.maskStimulus.mask.wn.graph);
set(handles.maskStimulusBlockWNMask,'String',handles.maskStimulus.mask.wn.blocks);
set(handles.maskStimulusPxsXWNMask,'String',handles.maskStimulus.mask.wn.pxX);
set(handles.maskStimulusPxYWNMask,'String',handles.maskStimulus.mask.wn.pxY);
set(handles.maskStimulusSaveimgWNMask,'String',handles.maskStimulus.mask.wn.saveImages);
set(handles.maskStimulusSeedFile,'String',handles.maskStimulus.mask.wn.seedFile);
set(handles.maskStimulusIntensityRWNMask,'String',handles.maskStimulus.mask.wn.intensity(1));
set(handles.maskStimulusIntensityGWNMask,'String',handles.maskStimulus.mask.wn.intensity(2));
set(handles.maskStimulusIntensityBWNMask,'String',handles.maskStimulus.mask.wn.intensity(3));
if exist(handles.maskStimulus.mask.wn.seedFile,'file'),
    set(handles.maskStimulosUseSeed,'Value',1.0);
else
    set(handles.maskStimulosUseSeed,'Value',0.0);
end
switch handles.maskStimulus.mask.wn.type,
    case 'BW', set(handles.maskStimulusWNType,'Value', 1);
    case 'BG', set(handles.maskStimulusWNType,'Value', 3);
    case 'BB', set(handles.maskStimulusWNType,'Value', 2);
    case 'BC', set(handles.maskStimulusWNType,'Value', 4);
    case 'BBGC', set(handles.maskStimulusWNType,'Value', 5);
    case 'BY', set(handles.maskStimulusWNType,'Value', 6);
    case 'BLG', set(handles.maskStimulusWNType,'Value', 7);
    otherwise , set(handles.maskStimulusWNType,'Value', 1);
end

handles.maskStimulus.protocol.flicker.bg.graph(:,:,1) = handles.maskStimulus.protocol.flicker.bg.r;
handles.maskStimulus.protocol.flicker.bg.graph(:,:,2) = handles.maskStimulus.protocol.flicker.bg.g;
handles.maskStimulus.protocol.flicker.bg.graph(:,:,3) = handles.maskStimulus.protocol.flicker.bg.b;
axes(handles.MSflickerGraph);
imshow(handles.maskStimulus.protocol.flicker.bg.graph);


set(handles.maskStimulusImgtimeFlicker,'String',handles.maskStimulus.protocol.flicker.imgTime)
set(handles.maskStimulusFlickerPreviousImgTime,'String',0)
set(handles.maskStimulusFlickerNextImgTime,'String',2*handles.maskStimulus.protocol.flicker.imgTime)
set(handles.maskStimulusBackgroundtimeFlicker,'String',handles.maskStimulus.protocol.flicker.backgroundTime)
set(handles.maskStimulusFlickerPreviousBgTime,'String',0)
set(handles.maskStimulusFlickerNextBgTime,'String',2*handles.maskStimulus.protocol.flicker.backgroundTime)
set(handles.maskStimulusFlickerImgFile,'String',handles.maskStimulus.protocol.flicker.bg.name);
if handles.maskStimulus.protocol.flicker.bg.isImg
    set(handles.maskStimulusFlickerImg,'Value',1.0);
else
    set(handles.maskStimulusFlickerImg,'Value',0.0);
end
set(handles.maskStimulusFlickerR,'String',handles.maskStimulus.protocol.flicker.bg.r);
set(handles.maskStimulusFlickerG,'String',handles.maskStimulus.protocol.flicker.bg.g);
set(handles.maskStimulusFlickerB,'String',handles.maskStimulus.protocol.flicker.bg.b);
% Masked Stimulus - Solod Color protocol -
set(handles.maskStimulusSolidColorProtocolR,'String',handles.maskStimulus.protocol.solidColor.r);
set(handles.maskStimulusSolidColorProtocolG,'String',handles.maskStimulus.protocol.solidColor.g);
set(handles.maskStimulusSolidColorProtocolB,'String',handles.maskStimulus.protocol.solidColor.b);
set(handles.maskstimuluswidthpxSolidColor,'String',handles.maskStimulus.protocol.solidColor.width);
set(handles.maskstimulusheightpxSolidColor,'String',handles.maskStimulus.protocol.solidColor.height);
set(handles.maskStimulusSolidColorNframesProto,'String',handles.maskStimulus.protocol.solidColor.nframes);
handles.maskStimulus.protocol.solidColor.graph(:,:,1) = handles.maskStimulus.protocol.solidColor.r;
handles.maskStimulus.protocol.solidColor.graph(:,:,2) = handles.maskStimulus.protocol.solidColor.g;
handles.maskStimulus.protocol.solidColor.graph(:,:,3) = handles.maskStimulus.protocol.solidColor.b;
axes(handles.MSsolidcolorProtocolGraph);
imshow(handles.maskStimulus.protocol.solidColor.graph);
% Masked Stimulus - White noise protocol -
set(handles.MSwnProtocolNframe,'String',handles.maskStimulus.protocol.wn.frames);
set(handles.MSwnProtocolBlocks,'String',handles.maskStimulus.protocol.wn.blocks);
set(handles.MSwnProtocolXpixel,'String',handles.maskStimulus.protocol.wn.pxX);
set(handles.MSwnProtocolYpixel,'String',handles.maskStimulus.protocol.wn.pxY);
set(handles.MSwnProtocolSaveImages,'String',handles.maskStimulus.protocol.wn.saveImages);
set(handles.MSwnProtocolIntensityR,'String',handles.maskStimulus.protocol.wn.intensity(1));
set(handles.MSwnProtocolIntensityG,'String',handles.maskStimulus.protocol.wn.intensity(2));
set(handles.MSwnProtocolIntensityB,'String',handles.maskStimulus.protocol.wn.intensity(3));
set(handles.MSwnProtocolSeedPath,'String',handles.maskStimulus.protocol.wn.seedFile);
if exist(handles.maskStimulus.protocol.wn.seedFile,'file')
    set(handles.MSwnProtocolSeedSelected,'Value',1);
else
    set(handles.MSwnProtocolSeedSelected,'Value',0);
end

switch handles.maskStimulus.protocol.wn.type,
    case 'BW', set(handles.MSwnProtocolType,'Value', 1);
    case 'BG', set(handles.MSwnProtocolType,'Value', 3);
    case 'BB', set(handles.MSwnProtocolType,'Value', 2);
    case 'BC', set(handles.MSwnProtocolType,'Value', 4);
    case 'BBGC', set(handles.MSwnProtocolType,'Value', 5);
    case 'BY', set(handles.MSwnProtocolType,'Value', 6);
    case 'BLG', set(handles.MSwnProtocolType,'Value', 7);
    otherwise , set(handles.MSwnProtocolType,'Value', 1);
end
