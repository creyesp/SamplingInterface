function [refresh,h,w]=identifyScreen(screen)
try
    HideCursor();
    oldLevel = Screen('Preference', 'VisualDebugLevel', 0);
    oldSkip = Screen('Preference', 'SkipSyncTests',0);
    [w,h]=Screen('WindowSize',screen);
    win=Screen('OpenWindow', screen);
    refresh = Screen('GetFlipInterval', win);
    Screen('FillRect', win,[0,0,0]);
    Screen('TextFont',win, 'Courier New');
    Screen('TextSize',win, 40);
    Screen('TextStyle', win, 1);
    Screen('DrawText', win, ['Screen ' num2str(screen)], w/2-90, h/2-50, [0, 0, 255]);
    Screen('TextFont',win, 'Times');
    Screen('TextSize',win, 20);
    Screen('TextStyle', win, 2);
    Screen('DrawText', win, 'Hit any key to exit.', w-230, h-30, [255, 0, 0]);
    Screen('Flip',win);
    KbWait;
    Screen('CloseAll');
    Screen('Preference', 'SkipSyncTests',oldSkip);
catch %#ok<CTCH>
    Screen('CloseAll');
    psychrethrow(psychlasterror);
    Screen('Preference', 'SkipSyncTests',oldSkip);
    Screen('Preference', 'VisualDebugLevel', oldLevel );
    ShowCursor();
end
