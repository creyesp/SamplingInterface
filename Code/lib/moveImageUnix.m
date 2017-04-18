<<<<<<< HEAD
function [dx,dy] = moveImageUnix(dx,dy,screenNumber,img)
% Return the new center position to show protocol 
% This function is for run in a Windows OS
% [dx,dy] = moveImage(dx,dy,screen,img)

% Define black and white
% white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
Screen('Preference', 'VisualDebugLevel', 1);

[window, windowRect] = Screen('OpenWindow', screenNumber, black);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% The avaliable keys to press
escapeKey = KbName('ESCAPE');
upKey = 112; %KbName('Up');
downKey = 117; %KbName('Down');
leftKey = 114; %KbName('Left');
rightKey = 115; %KbName('Right');
leftcontrolKey = 38; %KbName('Control_L');

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);

sizeImg = size(img);
% Make a base Rect of 200 by 200 pixels
baseRect = [0 0 sizeImg(2) sizeImg(1)];     


% Set the intial position of the square to be in the centre of the screen
squareX = xCenter+dx;
squareY = yCenter+dy;

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);

% This is the cue which determines whether we exit the demo
exitDemo = false;

imgTexture = Screen('MakeTexture',window,img);
Screen('TextSize',window, 12);
Screen('TextFont',window, 'Times');
textBackgroundColor = [30 30 30 10];
textBackgroundPos = [screenXpixels/2-405 screenYpixels-90 screenXpixels/2+405 screenYpixels-55];
textColor = [255 255 255];

% Loop the animation until the escape key is pressed
while exitDemo == false

    % Check the keyboard to see if a button has been pressed
    [keyIsDown,secs, keyCode] = KbCheck;
    % Set the amount we want our square to move on each button press
    if keyCode(leftcontrolKey)
        pixelsPerPress = 10;
    else
        pixelsPerPress = 1;
    end

    % Depending on the button press, either move ths position of the square
    % or exit the demo
    if keyCode(escapeKey)
        exitDemo = true;
    elseif keyCode(leftKey)
        squareX = squareX - pixelsPerPress;
    elseif keyCode(rightKey)
        squareX = squareX + pixelsPerPress;
    elseif keyCode(upKey)
        squareY = squareY - pixelsPerPress;
    elseif keyCode(downKey)
        squareY = squareY + pixelsPerPress;
    end

    % We set bounds to make sure our square doesn't go completely off of
    % the screen
    if squareX < -baseRect(3)/2
        squareX = -baseRect(3)/2;
    elseif squareX > screenXpixels+baseRect(3)/2
        squareX = screenXpixels+baseRect(3)/2;
    end

    if squareY < -baseRect(4)/2
        squareY = -baseRect(4)/2;
    elseif squareY > screenYpixels+baseRect(4)/2
        squareY = screenYpixels+baseRect(4)/2;
    end

    % Center the rectangle on the centre of the screen
    centeredRect = CenterRectOnPointd(baseRect, squareX, squareY);

    % Draw the rect to the screen
    Screen('DrawTexture',window,imgTexture,[],centeredRect);
    Screen('FillRect', window, textBackgroundColor,textBackgroundPos);
    Screen('DrawText', window, 'Press the arrows to move the image (left ctrl + arrow for longer moves), esc to exit and enter to save de position values.', screenXpixels/2-395, screenYpixels-80,textColor,textBackgroundColor);    
    
    % Flip to the screen
    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);

end
dx = squareX - xCenter;
dy = squareY - yCenter;
% Clear the screen
sca;

end
=======
function [dx,dy] = moveImageUnix(dx,dy,screen,img)
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
escapeKey = KbName('Escape');
win=Screen('OpenWindow',0,0);
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

while ~keyCode(escapeKey),
    [keyIsDown,secs, keyCode] = KbCheck;
%     Screen('DrawTexture',win,img_t,[],position);
%     Screen('FillRect', win, textBackgroundColor,textBackgroundPos);
%     Screen('DrawText', win, 'Press the arrows to move the image (left ctrl + arrow for longer moves), esc to exit and enter to save de position values.', w/2-395, h-80,textColor,textBackgroundColor);
%     Screen('Flip',win);
%     [d,s,sc] = KbCheck;
%     key = find(sc==1);
%     if ~isnan(key),
%         if length(key)==3
%             if key == [17 up 162]
%                 key = sUp;
%             else if key == [17 down 162]
%                     key = sDown;
%                 else if key == [17 left 162]
%                         key = sLeft;
%                     else if key == [17 right 162]
%                             key = sRight;
%                         else
%                             key = 0;
%                         end
%                     end
%                 end
%             end
%         end
%         if length(key)>1
%             key = 0;
%         end
%         switch key
%             case sUp
%                 if position(2)>10
%                     position(2) = position(2)-10;
%                     position(4) = position(4)-10;
%                 end                
%             case up,
%                 if position(2)>1
%                     position(2) = position(2)-1;
%                     position(4) = position(4)-1;
%                 end
%             case sDown
%                 if position(4)<(h-10)
%                     position(4) = position(4)+10;
%                     position(2) = position(2)+10;
%                 end
%             case down,
%                 if position(4)<h
%                     position(4) = position(4)+1;
%                     position(2) = position(2)+1;
%                 end
%             case sLeft
%                 if position(1)>10
%                     position(1) = position(1)-10;
%                     position(3) = position(3)-10;
%                 end
%             case left,
%                 if position(1)>1
%                     position(1) = position(1)-1;
%                     position(3) = position(3)-1;
%                 end
%             case sRight
%                 if position(3)<(w-10)
%                     position(3) = position(3)+10;
%                     position(1) = position(1)+10;
%                 end
%             case right,
%                 if position(3)<w
%                     position(3) = position(3)+1;
%                     position(1) = position(1)+1;
%                 end
%             case enter
%                 dx = position(1) - (w-s_img(2))/2;
%                 dy = position(2) - (h-s_img(1))/2;
%                 break;
%             case esc
%                 break;
%             otherwise
%         end 
%     else
%         key = 0;
%     end
    WaitSecs(0.1);
end
Screen('BlendFunction', win, sourceFactorOld, destinationFactorOld, colorMaskOld);
Screen('CloseAll');exit
>>>>>>> f9e35751058790517b587088fee9340ad4d4067b
