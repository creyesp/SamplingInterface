function updateTimeMaskStimulus(hObject, eventdata, handles)
    if handles.beforeStimulus.is
	    t = handles.beforeStimulus.time/1000.0;
	else
	    t = 0;
    end

    switch handles.maskStimulus.protocol.type,
        case 'Flicker',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = t + (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 * (handles.maskStimulus.repetitions+1);
            else
                handles.maskStimulus.time = (handles.maskStimulus.protocol.flicker.imgTime...
                    + handles.maskStimulus.protocol.flicker.backgroundTime)...
                    * 1/1000 * (handles.maskStimulus.repetitions+1);		    	
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                    handles.maskStimulus.time),'HH:MM:SS.FFF'));
        case 'Images',
            if ~get(handles.maskStimulusRepWithBackground,'Value')
                handles.maskStimulus.time = handles.img.files/handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions + 1) + t;
            else
                handles.maskStimulus.time = handles.img.files/handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions + 1);
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
                    / handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions+1);
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
                    * 1/handles.maskStimulus.fps...
                    * (handles.maskStimulus.repetitions+1);
            end
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF'));
        otherwise
            set(handles.maskStimulusTime,'String',datestr(datenum(0,0,0,0,0,...
                handles.maskStimulus.time),'HH:MM:SS.FFF')); 
    end
    guidata(hObject,handles);
end