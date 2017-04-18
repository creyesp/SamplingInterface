
function createScript(file)
[folder,name] = fileparts(file);


if isunix,
    matlab = ['ptb3-matlab'];
    text = sprintf(['#!/bin/sh\n\n' matlab ' -nojvm -nodisplay -r "cd ''' folder '''; stimulation('''...
            name '.zip'')" 2>&1 | grep -v "exclude an item from Time Machine"']);
else
    matlab = [matlabroot '/bin/matlab'];
    text = sprintf(['#!/bin/sh\n\n' matlab ' -nojvm -nodisplay -r "cd ''' folder '''; stimulation('''...
            name '.zip'')" 2>&1 | grep -v "exclude an item from Time Machine"']);
end
    
fid = fopen(fullfile(folder,[name '.command']),'wt');
fwrite(fid,text,'uchar');
fclose(fid);
[succ,msg] = fileattrib(fullfile(folder,[name '.command']),'+x','a');
if succ==0,
    errordlg(['The script couldn''t be set as executable. The error message is: ' msg,'Error']);
end