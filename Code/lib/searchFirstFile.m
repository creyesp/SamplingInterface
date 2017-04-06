function pos=searchFirstFile(directory)
list = dir(directory);
pos = 0;
for i=1:length(list),
    if ~list(i).isdir && supportedImageFormat(list(i).name), 
        pos = i;
        break
    end
end
if pos,
    pos = pos-1;
end