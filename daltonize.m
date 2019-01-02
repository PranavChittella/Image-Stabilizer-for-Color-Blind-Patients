

function [ imageOut ] = daltonize( imageIn, infoLost )

% This function performs daltonization on the input image. Daltonization
% uses the information removed from the original image during the process
% of simulating color blindness and maps it to frequencies visible to the
% color blind viewer. This process uses and error mapping matrix to perform
% this color assignment.
%
% ***imageIn and infoLost must be the same size***

[imageHeight imageWidth imageDepth] = size(imageIn);
lostPixel = zeros(3,1);
mappedLost = zeros(size(imageIn));

% Error mapping matrix
errorMap = [0 0 0; .7 1 0; .7 0 1];

% Assign lost information to visible spectrum
for y = 1:imageHeight
    for x = 1:imageWidth
        lostPixel(1:3) = infoLost(y,x,:);
        mappedLost(y,x,:) = errorMap*lostPixel;
    end % x = 1:imageWidth
end % y = 1: imageHeight

% Add mapped info to original input image
imageOut = imageIn + mappedLost;

% Ensure output image pixel values fall within [0 1]
imageOut(imageOut > 1) = 1;
imageOut(imageOut < 0) = 0;

end

