function [ compresscolor ] = compressColor( color, frequency )
%COMPRESSCOLOR Reduce the color depth and shift k times according 
%to the frequency
%   example: frequency = 240 and kposition = 2
%  a color: 01101101 -> (01) 10 11 01 -> (01) (01) (01) (01)
nsplits = frequency/60;
colordepth = 8;
nbits = colordepth/(nsplits);
compresscolor = color*0;
colorshifted = bitshift(color,-(colordepth-nbits));
for kshift = 0: nsplits-1,
    compresscolor = compresscolor + bitshift(colorshifted,kshift*nbits);
end

end