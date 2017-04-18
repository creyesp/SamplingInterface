function [dx,dy] = moveImageWin(dx,dy,screen,img)
% Return the new center position to show protocol 
% This function is for run in a Windows OS
% [dx,dy] = moveImage(dx,dy,screen,img)
up = 38;
down = 40;
left = 37;
right = 39;
sUp = -38;
sDown = -40;
sLeft = -37;
sRight = -39;
enter = 13;
esc = 27;
key = 0;

win = Screen('OpenWindow',screen,0);
[w,h]=Screen('WindowSize',win);
s_img = size(img);
position = [(w-s_img(2))/2+dx (h-s_img(1))/2+dy (w+s_img(2))/2+dx (h+s_img(1))/2+dy];
img_t = Screen('MakeTexture',win,img);
[sourceFactorOld, destinationFactorOld, colorMaskOld]=Screen('BlendFunction', win, GL_ONE, GL_SRC_ALPHA, [1 1 1 1]);
Screen('TextFont',win, 'Times');
Screen('TextSize',win, 12);
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
        if length(key)==3
            if key == [17 up 162]
                key = sUp;
            else if key == [17 down 162]
                    key = sDown;
                else if key == [17 left 162]
                        key = sLeft;
                    else if key == [17 right 162]
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