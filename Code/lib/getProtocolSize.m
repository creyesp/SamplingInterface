function [ width, height ] = getProtocolSize( handles )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    switch handles.mode,
        case 'Flicker',
            width = handles.img.size.width;
            height = handles.img.size.height;
        case 'Only stimulus (fps)',
            width = handles.img.size.width;
            height = handles.img.size.height;            
        case 'White noise',
            width = handles.whitenoise.blocks*handles.whitenoise.pxX;
            height = handles.whitenoise.blocks*handles.whitenoise.pxY;            
        case 'Mask stimulus',
            switch handles.maskStimulus.protocol.type,
                case 'Flicker',
                    width = handles.img.size.width;
                    height = handles.img.size.height;                    
                case 'Images',
                    width = handles.img.size.width;
                    height =handles.img.size.height;                                        
                case 'Solid color',
                    width = handles.maskStimulus.protocol.solidColor.width;
                    height = handles.maskStimulus.protocol.solidColor.height;                    
                case 'White noise',
                    width = handles.maskStimulus.mask.wn.blocks*handles.maskStimulus.mask.wn.pxX;
                    height = handles.maskStimulus.mask.wn.blocks*handles.maskStimulus.mask.wn.pxY;
                otherwise
                    width = 0;
                    height = 0;
            end
    end
end

