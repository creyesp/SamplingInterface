function updateTime(hObject, eventdata, handles)
    if handles.beforeStimulus.is
	    t = handles.beforeStimulus.time/1000.0;
	else
	    t = 0;
    end
    
    if  handles.sync.is && handles.sync.isdigital && strcmp(handles.sync.digital.mode,'On every frames');
        switch handles.mode
            case 'Flicker'
                flickerStimulusTime(handles,t)
            case 'Only stimulus (fps)'
                DigitalonlyStimulusTime(handles,t)
            case 'White noise'
                DigitalwnStimulusTime(handles,t)
            case  'Mask stimulus'
                DigitalMaskStimulusTime(handles,t)
        end
    else
        switch handles.mode
            case 'Flicker'
                flickerStimulusTime(handles,t)
            case 'Only stimulus (fps)'
                onlyStimulusTime(handles,t)
            case 'White noise'
                wnStimulusTime(handles,t)
            case  'Mask stimulus'
                MaskStimulusTime(handles,t)
        end        
    end
    guidata(hObject,handles);
end

function flickerStimulusTime(handles,beforetime)
    axes(handles.flickerSignalGraph);
    periode = 1000.0/handles.flicker.fps;
    tau = 0:periode/100.0:periode;
    signal = tau < handles.flicker.dutyCicle*tau(end)/100.0; 
    area(tau,signal); hold on;
    plot(tau(round(handles.flicker.dutyCicle)+1),1,'ks','MarkerFaceColor',[0 1 0],'MarkerSize',3);
    if handles.flicker.dutyCicle>50
        text(tau(round(handles.flicker.dutyCicle)+1)-6-1.85*periode/10.0,1.2,num2str(tau(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
    else
        text(tau(round(handles.flicker.dutyCicle)+1)+1,1.2,num2str(tau(round(handles.flicker.dutyCicle)+1)),'FontSize',10.0);
    end
    ylabel('Signal'),xlabel('Time [ms]'),xlim([0 tau(end)]),ylim([0 1.5]); hold off;
    handles.flicker.imgTime = 1000.0/handles.flicker.fps*handles.flicker.dutyCicle;
    handles.flicker.backgroundTime = 1000.0/handles.flicker.fps*(1-handles.flicker.dutyCicle);
    if ~get(handles.flickerRepWithBackground,'Value')
        handles.flicker.time = beforetime + (handles.flicker.imgTime+handles.flicker.backgroundTime)/1000.0*handles.img.files*(handles.flicker.repetitions+1);
    else
        handles.flicker.time = beforetime + (handles.flicker.imgTime+handles.flicker.backgroundTime)/1000.0*handles.img.files;
    end

    set(handles.flickerTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.flicker.time),'HH:MM:SS.FFF'));
end


function onlyStimulusTime(handles,t)
    if ~get(handles.onlyStimulusRepWithBackground,'Value')
        handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps...
            * (handles.onlyStimulus.repetitions+1) + t;
    else
        handles.onlyStimulus.time = handles.img.files/handles.onlyStimulus.fps + t;
    end
    set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.onlyStimulus.time),'HH:MM:SS.FFF'));
end

function DigitalonlyStimulusTime(handles,t)
    if ~get(handles.onlyStimulusRepWithBackground,'Value')
        handles.onlyStimulus.time = handles.img.files/handles.sync.digital.frequency...
            * (handles.onlyStimulus.repetitions+1) + t;
    else
        handles.onlyStimulus.time = handles.img.files/handles.sync.digital.frequency + t;
    end
    set(handles.onlyStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.onlyStimulus.time),'HH:MM:SS.FFF'));
end

function wnStimulusTime(handles, t)
    handles.whitenoise.time = handles.whitenoise.frames/handles.whitenoise.fps + t;
    set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.whitenoise.time),'HH:MM:SS.FFF'));
end

function DigitalwnStimulusTime(handles, t)
    handles.whitenoise.time = handles.whitenoise.frames/handles.sync.digital.frequency + t;
    set(handles.whiteNoiseTime,'String',datestr(datenum(0,0,0,0,0,...
        handles.whitenoise.time),'HH:MM:SS.FFF'));
end

function DigitalMaskStimulusTime(handles,t)
    switch handles.maskStimulus.protocol.type,
        case 'Flicker',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = t + (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 * (handles.maskStimulus.repetitions+1)*handles.img.files;
            else
                handles.maskStimulus.time = (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 *handles.img.files;		    	
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                    handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'Images',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.img.files/handles.sync.digital.frequency...
                    * (handles.maskStimulus.repetitions + 1) + t;
            else
                handles.maskStimulus.time = handles.img.files/handles.sync.digital.frequency;
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'Solid color',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.maskStimulus.protocol.solidColor.nframes...
                    / handles.sync.digital.frequency...
                    * (handles.maskStimulus.repetitions+1) + t;
            else
                handles.maskStimulus.time = handles.maskStimulus.protocol.solidColor.nframes...
                    / handles.sync.digital.frequency;
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'White noise',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.maskStimulus.protocol.wn.frames...
                    * 1/handles.sync.digital.frequency...
                    * (handles.maskStimulus.repetitions+1) + t;
            else
                handles.maskStimulus.time = handles.maskStimulus.protocol.wn.frames...
                    * 1/handles.sync.digital.frequency;
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        otherwise
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF')); 
    end         
end

function MaskStimulusTime(handles,t)
    switch handles.maskStimulus.protocol.type,
        case 'Flicker',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = t + (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 * (handles.maskStimulus.repetitions+1)*handles.img.files;
            else
                handles.maskStimulus.time = (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 *handles.img.files;		    	
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                    handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'Images',

            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.img.files/handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions + 1) + t;
            else
                handles.maskStimulus.time = handles.img.files/handles.maskStimulus.fps;
            end
                set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                    handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'Solid color',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.maskStimulus.protocol.solidColor.nframes...
                    / handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions+1) + t;
            else
                handles.maskStimulus.time = handles.maskStimulus.protocol.solidColor.nframes...
                    / handles.maskStimulus.fps;
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'White noise',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.maskStimulus.protocol.wn.frames...
                    * 1/handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions+1) + t;
            else
                handles.maskStimulus.time = handles.maskStimulus.protocol.wn.frames...
                    * 1/handles.maskStimulus.fps;
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        otherwise
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF')); 
    end
end
