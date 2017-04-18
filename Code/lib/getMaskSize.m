function [ width, height ] = getMaskSize( handles )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

    switch handles.maskStimulus.mask.type,
        case 'White noise' ,
            width = handles.maskStimulus.mask.wn.blocks...
                * handles.maskStimulus.mask.wn.pxX;
            height = handles.maskStimulus.mask.wn.blocks...
                * handles.maskStimulus.mask.wn.pxY;
        case 'Img',
            width = handles.maskStimulus.mask.img.size.width;
            height = handles.maskStimulus.mask.img.size.height;
        case 'Solid color',
            width = handles.protocol.width;
            height = handles.protocol.height;                    
    end
end

