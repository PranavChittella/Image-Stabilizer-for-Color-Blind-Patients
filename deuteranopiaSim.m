

function [imageOut infoLost] = deuteranopiaSim(imageRGB)



[imageHeight imageWidth imageDepth] = size(imageRGB);
imageLMS = zeros(size(imageRGB));
imageOut = zeros(size(imageRGB));
rgbPixel = zeros(3,1);
lmsPixel = zeros(3,1);

% Matrices to convert back and forth from RGB to LMS color spaces
rgb2lms = [17.8824 43.5161 4.11935; 3.45565 27.1554 3.86714; 0.0299566 0.184309 1.46709];
% rgb2lms = [.3811 .5783 .0402; .1967 .7244 .0782; .0241 .1288 .8444];
lms2rgb = inv(rgb2lms);

% Matrix to adjust LMS image to simulate Deuteranopia, Protanope or Tritanope
deutAdjust = [1 0 0; 0.494207 0 1.24827; 0 0 1] ;
% proAdjust = [0 2.02344 -2.52581; 0 1 0; 0 0 1] ;
% triAdjust = [1 0 0; 0 1 0; -0.395913 0.801109 0] ;

% Remove gamma-correction before manipulating image
gamma = 2.1;
imageRGB = imageRGB.^gamma;

for y = 1:imageHeight
    for x = 1:imageWidth
        % Convert input image to LMS colorspace and adjust for Deuteranopia
        rgbPixel(1:3) = imageRGB(y,x,:); % RGB values at that pixel
        lmsPixel(1:3) = rgb2lms*rgbPixel; % LMS values at that pixel
        imageLMS(y,x,:) = deutAdjust*lmsPixel; % adjusted LMS values at that pixel
        
        % Convert image back to RGB color space
        lmsPixel(1:3) = imageLMS(y,x,:); % grab the pixel out of final LMS image
        imageOut(y,x,:) = lms2rgb*lmsPixel; % convert pixel back to RGB
    end % x = 1:imageWidth
end % y = 1:imageHeight

% Gamma-correct imageOut and imageRGB for viewing
imageRGB = imageRGB.^(1/gamma);
imageOut = imageOut.^(1/gamma);

% Gather lost information into infoLost
infoLost = imageRGB - imageOut;

end %function

