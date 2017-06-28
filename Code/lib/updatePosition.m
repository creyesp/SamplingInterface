function updatePosition(inputFile,outputFile)
% Fix the shift position in a protocol file 
% generated with the Sampling interface
% 	
% This code assume the shift position is 
% equal for all protocol file 

mkdir tmp2
delete ./tmp2/*.si
system(['unzip ' strrep(inputFile,' ','\ ') ' -d ./tmp2']);
fileName = '/tmp2/Final Configuration.si';
if exist(fullfile(pwd,fileName),'file')
    data = getInformation(fullfile(pwd,fileName));
    img = ones(data.protocol.height,data.protocol.width)*255;
	% imageInfo = imfinfo(fullfile(data.img.directory,data.list(end,:)));
	% w = imageInfo.Width;
	% h = imageInfo.Height;
	% img = ones(h,w)*255;

    [ndx,ndy] = moveImageUnix(data.img.deltaX,data.img.deltaY,data.screens.selected,img);
    data.img.deltaX = ndx;
    data.img.deltaY = ndy;
    for i=length(data.experiments.file)-1:-1:1,
        fileName2 = ['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'];
        if exist(fullfile(pwd,fileName2),'file'),
            experiment = getInformation(fullfile(pwd,fileName2));
            experiment.img.deltaY = data.img.deltaY;
            experiment.img.deltaX = data.img.deltaX;
            save(['./tmp2/Exp' sprintf('%03d',data.experiments.file(i+1)) '.si'],'-struct','experiment');
        end
    end
    save('./tmp2/Final Configuration.si','-struct','data');
 
    zip(outputFile,'*.si','./tmp2/');
    rmdir('tmp2','s');
    disp(['ALL PROTOCOLS centered to x:',num2str(ndx),' px y: ',num2str(ndy), 'px.'])
else
    disp('ERROR: Can''t open configuration file "Final Configuration.si" of the screen data zip');
end	