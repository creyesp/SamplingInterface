
function str=cell2asciiStr(c)
str = c(1,:);

for i=2:size(c,1),
        str = sprintf('%s\n%s',str,c(i,:));
end