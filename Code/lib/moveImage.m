function [dx,dy] = moveImage(dx,dy,screen,img)

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
    [handles.img.deltaX,handles.img.deltaY] = moveImage(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);
elseif isunix
    [handles.img.deltaX,handles.img.deltaY] = moveImageUnix(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);    
else
    [handles.img.deltaX,handles.img.deltaY] = moveImageWin(handles.img.deltaX,handles.img.deltaY,...
        handles.screens.selected,img);
end    