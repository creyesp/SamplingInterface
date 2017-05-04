function [ compressimg ] = compresskImg( img, frequency, kposition )
%COMPRESSKIMG Reduce the color depth of an image and shift k times according 
%to the frequency
%   example: frequency = 240 and kposition = 2
%  a pixel: 01101101 -> (01) 10 11 01 -> 00 00 00 (01) -> 00 (01) 00 00
nsplits = frequency/60;
colordepth = 8;
nbits = colordepth/(nsplits);
imgshifted = bitshift(img,-(colordepth-nbits));
compressimg = bitshift(imgshifted,(kposition)*nbits);

end
