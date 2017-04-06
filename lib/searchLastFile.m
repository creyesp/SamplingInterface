function pos=searchLastFile(directory)
list = dir(directory);
pos = 0;
for i=length(list):-1:1,
    if ~list(i).isdir && supportedImageFormat(list(i).name), 
        pos = i;
        break
    end
end
if pos,
    pos = pos-1;
end
