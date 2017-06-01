function use = UseImagesProtocol( handles )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    switch handles.mode,
        case 'Flicker',
            use = true;
        case 'Only stimulus (fps)',
            use = true;       
        case 'White noise',
            use = false;
        case 'Mask stimulus',
            switch handles.maskStimulus.protocol.type,
                case 'Flicker',
                    use = true;                  
                case 'Images',
                    use = true;                                 
                case 'Solid color',
                    use = false;        
                case 'White noise',
                    use = false;
                otherwise
                    use = false;
            end
        otherwise,
            use = false;
    end
end

