

function saveLogFile(inf,T,pathExp)
division = '\n\n------------------------------------------------------------------------------------------------\n\n';
division2 = '\n************************************************************************************************\n';
name=sprintf('SI Log file %04d_%02d_%02d-%02d.%02d.%02d.txt',round(clock));
text = sprintf(['\t\tSampling Interface log file\n\nStarted date: \t%04d/%02d/%02d %02d:%02d:%02d '...
        ' \nFinished date: \t%04d/%02d/%02d %02d:%02d:%02d \n\nRefresh set at screen selection: \t%.7f [ms] - %.5f [Hz]\n'...
        'Refresh used in stimulation: \t\t%.7f [ms] - %.5f [Hz]\n\nScreen selected: %d\nScreen width: \t%d\nScreen height:'...
        '\t%d\n\n' division2 '\t\tList of sampled modes' division2 division],inf.startedTime,inf.finishedTime,...
        1000*inf.screens.refreshRate,1.0/inf.screens.refreshRate,1000*inf.refresh,1.0/inf.refresh,...
        inf.screens.selected,inf.screens.width,inf.screens.height);
i = 1;
time = 0;
repeated = 0;
while(i<length(inf.experiments.file)),
    time  = time + 1;
    fileName = ['Exp' sprintf('%03d',inf.experiments.file(i+1)) '.si'];
    fullfileName = fullfile(pathExp,fileName);
    if exist(fullfileName,'file'),
        disp(['exp file: ' num2str(i)])
        expData = getInformation(fullfileName);
        exp = getInformation(fullfileName,'print');
        text = sprintf(['%s%s\nReal time duration: %s' division],text,cell2asciiStr(exp)...
            ,datestr(datenum(0,0,0,0,0,T(time).finish-T(time).start+0.5*inf.refresh),...
            'HH:MM:SS.FFF'));
        
        if i>1 && strcmp(expDataPrev.mode,'Presentation') &&...
            ( (strcmp(expData.mode,'Flicker') && expData.flicker.repeatBackground) || ...
            (strcmp(expData.mode,'Only stimulus (fps)') && expData.onlyStimulus.repeatBackground) ),
            if ((strcmp(expData.mode,'Flicker') && repeated<expData.flicker.repetitions) || (strcmp(expData.mode,'Only stimulus (fps)') && repeated<expData.onlyStimulus.repetitions))
                i = i-2;
                repeated = repeated+1;
            else
                repeated = 0;
            end
        else
            expDataPrev = expData;
        end
    end
    i = i+1;
end
text = sprintf(['%s' division2],text);
fid = fopen(fullfile(pathExp,name),'wt');
fwrite(fid,text,'uchar');
fclose(fid);
display(['Log file saved at: ' fullfile(pathExp,name) ]);