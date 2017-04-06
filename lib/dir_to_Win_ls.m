function lsOutput = dir_to_Win_ls(dirInput)
%dir_to_Win_ls 'dir' to 'ls' Windows version command
%   dir_to_Win_ls allows to use the ls Windows function, over UNIX or
%   Windows, using dir output as an argument for dir_to_win_ls.
%   dir function gives an structure with information about the files in a 
%   directory. The ls command, depending on the OS, gives a vector (UNIX)
%   or a char array (Windows).
%
%   Example: lsOutput = dir_to_Win_ls(dir(pwd));

lsOutput = char(zeros(length(dirInput),260));
maxNameLength = 0;
for i = 1:length(dirInput),
    nameSize = length(dirInput(i).name);
    
    if nameSize>2 && strcmp(dirInput(i).name(1:2),'._')
        lsOutput(i,1:nameSize-2) = dirInput(i).name(3:end);
        if maxNameLength < nameSize-2
            maxNameLength = nameSize-2;
        end
    else
        lsOutput(i,1:nameSize) = dirInput(i).name;
        if maxNameLength < nameSize
            maxNameLength = nameSize;
        end
    end
end
lsOutput = lsOutput(:,1:maxNameLength);  
% In Mac it is possible, don't know why, the files are named with
% ._ before the actual name. This insertion is removed.
% if strcmp(lsOutput(3,1:2),'._'),
%     lsOutput(3:end,1:end-2) = lsOutput(3:end,3:end);
%     lsOutput = lsOutput(:,1:maxNameLength-2);
% else
%     lsOutput = lsOutput(:,1:maxNameLength);    
% end