% William Woods
% EE 368 Final Project
% 6 June 2012

% Various permutations of this script were used to produce my results. The
% real meat of the project is in all the functions I made, which are run in
% this script.

clear all

imageRGB = im2double(imread('jla.jpg'));

[sim error] = deuteranopiaSim(imageRGB);
corrected = daltonize(imageRGB, error);
[simCorrected error2] = deuteranopiaSim(corrected);

figure(1)
imshow(imageRGB)
title('Original Image')

figure(2)
imshow(sim)
title('Image as seen by Deuteranopia Patient')

figure(3)
imshow(corrected)
title('Image adjusted for Deuteranopia Patient')

figure(4)
imshow(simCorrected)
title('Adjusted image as seen by Deuteranopia Patient')

imageCon = contrast(imageRGB,8);

imageConSim = deuteranopiaSim(imageCon);
deltaE = deltaE(imageRGB, real(imageCon));

figure(6)
imshow(imageCon)

figure(7)
imshow(imageConSim)

colorAdjust = correctColor(imageRGB);
colorAdSim = deuteranopiaSim(colorAdjust);
deltaE = deltaE(imageRGB, real(colorAdjust));

figure(8)
imshow(colorAdjust)

figure(9)
imshow(colorAdSim)

figure(10)
imagesc(deltaE)
colorbar
title('Delta E')
