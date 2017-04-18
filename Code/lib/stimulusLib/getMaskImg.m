function [ maskImg ] = getMaskImg( maskStruct, mask, nloop)
%Get a mask image depending on the mask type [White noise, Img, Solid color]
% input : 
%   maskStruct : struct mask
%   mask : array with mask shape
%
% output:
%   maskImg : image with mask, it's two or four layer depending on type
%   mask

    black=0;
     s1 = maskStruct.width;
     s2 = maskStruct.height; 

    switch maskStruct.type
        case 'White noise'
            [~, noiseimg] =  getRandWNimg(maskStruct.wn);
            if strcmp(maskStruct.wn.type,'BW')
                maskImg =  uint8(ones(s2, s1,2));
                maskImg(:,:,1) = noiseimg;
                maskImg(:,:,2) = mask;
            else
                maskImg =  uint8(ones(s2, s1,4));
                maskImg(:,:,1:3) = noiseimg;
                maskImg(:,:,4) = mask;
            end
        case 'Img'
            maskImg =  uint8(ones(s2, s1,4));
            maskImg(:,:,1:3) = maskStruct.img.imgpreloaded{mod(nloop,maskStruct.img.files)+1};
            maskImg(:,:,4) = mask;                            
        case 'Solid color'
            maskImg =  uint8(ones(s2, s1,4));
            maskImg(:,:,1) = uint8(maskStruct.solidColor.r);
            maskImg(:,:,2) = uint8(maskStruct.solidColor.g);
            maskImg(:,:,3) = uint8(maskStruct.solidColor.b);
            maskImg(:,:,4) = mask;
        otherwise
            maskImg =  uint8(ones(s2, s1,2));
            maskImg(:,:,1) = black;
            maskImg(:,:,2) = mask;            
    end
end