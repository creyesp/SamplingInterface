function [dx,dy] = moveImage(dx,dy,screen,img)
<<<<<<< HEAD

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
=======
% Return the new center position to show protocol 
% This function is for run in a Mac OS
% [dx,dy] = moveImage(dx,dy,screen,img)
up = 82;
down = 81;
left = 80;
right = 79;
sUp = -82;
sDown = -81;
sLeft = -80;
sRight = -79;
enter = 40;
esc = 41;
control = 224;
key = 0;

win = Screen('OpenWindow',screen,0);
[w,h]=Screen('WindowSize',win);
% img = imread(imgName);
s_img = size(img);
position = [(w-s_img(2))/2+dx (h-s_img(1))/2+dy (w+s_img(2))/2+dx (h+s_img(1))/2+dy];
img_t = Screen('MakeTexture',win,img);
[sourceFactorOld, destinationFactorOld, colorMaskOld]=Screen('BlendFunction', win, GL_ONE, GL_SRC_ALPHA, [1 1 1 1]);
Screen('TextFont',win, 'Times');
Screen('TextSize',win, 16);
textBackgroundColor = [30 30 30 10];
textBackgroundPos = [w/2-405 h-90 w/2+405 h-55];
textColor = [255 255 255];

while key ~= esc,
    Screen('DrawTexture',win,img_t,[],position);
    Screen('FillRect', win, textBackgroundColor,textBackgroundPos);
    Screen('DrawText', win, 'Press the arrows to move the image (left ctrl + arrow for longer moves), esc to exit and enter to save de position values.', w/2-395, h-80,textColor,textBackgroundColor);
    Screen('Flip',win);
    [d,s,sc] = KbCheck;
    key = find(sc==1);
    if ~isnan(key),
        if length(key)==2
            if key == [up control]
                key = sUp;
            else if key == [down control]
                    key = sDown;
                else if key == [left control]
                        key = sLeft;
                    else if key == [right control]
                            key = sRight;
                        else
                            key = 0;
                        end
                    end
                end
            end
        end
        if length(key)>1
            key = 0;
        end
        switch key
            case sUp
                if position(2)>10
                    position(2) = position(2)-10;
                    position(4) = position(4)-10;
                end                
            case up,
                if position(2)>1
                    position(2) = position(2)-1;
                    position(4) = position(4)-1;
                end
            case sDown
                if position(4)<(h-10)
                    position(4) = position(4)+10;
                    position(2) = position(2)+10;
                end
            case down,
                if position(4)<h
                    position(4) = position(4)+1;
                    position(2) = position(2)+1;
                end
            case sLeft
                if position(1)>10
                    position(1) = position(1)-10;
                    position(3) = position(3)-10;
                end
            case left,
                if position(1)>1
                    position(1) = position(1)-1;
                    position(3) = position(3)-1;
                end
            case sRight
                if position(3)<(w-10)
                    position(3) = position(3)+10;
                    position(1) = position(1)+10;
                end
            case right,
                if position(3)<w
                    position(3) = position(3)+1;
                    position(1) = position(1)+1;
                end
            case enter
                dx = position(1) - (w-s_img(2))/2;
                dy = position(2) - (h-s_img(1))/2;
                break;
            case esc
                break;
            otherwise
        end 
    else
        key = 0;
    end
    WaitSecs(0.1);
end
Screen('BlendFunction', win, sourceFactorOld, destinationFactorOld, colorMaskOld);
Screen('CloseAll');
>>>>>>> f9e35751058790517b587088fee9340ad4d4067b
