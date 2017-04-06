function [noise, imgToComp, noiseimg] = setWNimg(whitenoise)
%Create zeros array to white noise image 
% black&white size array : [ block*pixelY, block*pixelX , number images to save ]
% RGB size array : [ block*pixelY, block*pixelX , 3,number images to save ]
% 
% Input = Struct whitenoise 
% Return [noise, imgToComp, noiseimg] = setWNimg(whitenoise)

    noise = zeros(whitenoise.blocks*whitenoise.pxY,...
        whitenoise.blocks*whitenoise.pxX);
    if strcmp(whitenoise.type,'BW'), %array 2D
        imgToComp = zeros(whitenoise.blocks*whitenoise.pxY,...
            whitenoise.blocks*whitenoise.pxX,whitenoise.saveImages);
        noiseimg = zeros(size(noise));
    else %array 3D [R G B]
        disp([whitenoise.blocks, whitenoise.pxY, whitenoise.pxX])
        imgToComp = zeros(whitenoise.blocks*whitenoise.pxY,...
            whitenoise.blocks*whitenoise.pxX,...
            3,whitenoise.saveImages);
        noiseimg = zeros([size(noise) 3]);
    end
end