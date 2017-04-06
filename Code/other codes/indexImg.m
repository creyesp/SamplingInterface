function indexImg(img)
win=Screen('OpenWindow',0,0);
texture = Screen('MakeTexture',win,img,[],[],1);
Screen('DrawTexture',win,texture);
Screen('Flip',win);
WaitSecs(3);
Screen('CloseAll');
