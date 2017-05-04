function [ compressimg ] = compressImg( img, frequency )
%COMPRESSIMG Reduce the color depth of an image and repeat k times according 
%to the frequency
%   example: frequency = 240 and kposition = 2
%  a pixel: 01101101 -> (01) 10 11 01 -> (01) (01) (01) (01)
nsplits = frequency/60;
colordepth = 8;
nbits = colordepth/(nsplits);
compressimg = img*0;
imgshifted = bitshift(img,-(colordepth-nbits));
for kshift = 0: nsplits-1,
    compressimg = compressimg + bitshift(imgshifted,kshift*nbits);
end

end

