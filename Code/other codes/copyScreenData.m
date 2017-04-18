
function copyScreenData(screenDataZIP,objectiveZIP)

mkdir tmp
delete ./tmp/*.si
system(['unzip ' strrep(screenDataZIP,' ','\ ') ' -d ./tmp']);
fileName = '/tmp/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    dataScreen = getInformation(fullfile(pwd,fileName));
    rmdir('tmp','s');
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end

mkdir tmp2
delete ./tmp2/*.si
system(['unzip ' strrep(objectiveZIP,' ','\ ') ' -d ./tmp2']);
fileName = '/tmp2/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    data = getInformation(fullfile(pwd,fileName));
    data.screens = dataScreen.screens;
    for i=length(data.experiments.file)-1:-1:1,
        fileName2 = ['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'];
        if exist(fullfile(pwd,fileName2),'file'),
            experiment = getInformation(fullfile(pwd,fileName2));
            experiment.img.deltaY = dataScreen.img.deltaY;
            experiment.img.deltaX = dataScreen.img.deltaX;
            save(['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'],'-struct','experiment');
        end
    end
    save('./tmp2/Final Configuration.si','-struct','data');
 
    zip(objectiveZIP,'*.si','./tmp2/');
    rmdir('tmp2','s');
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end