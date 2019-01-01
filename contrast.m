% William Woods
% EE 368 Final Project
% 6 June 2012

function imageOut = contrast(imageRGB, scale)

% This function enhances the contrast between red and green in an image
%
% Algorithm borrowed from Jonathan Michelson, originally found on:
% http://www.stanford.edu/~zbrand/C3/source_code.htm

[imageHeight imageWidth imageDepth] = size(imageRGB);
imageOut = zeros(size(imageRGB));

% Reduce image by half to make room to increase pixel RGB values
imageRGB = imageRGB/2;

R = imageRGB(:,:,1);
G = imageRGB(:,:,2);
B = imageRGB(:,:,3);


% Determine how close the pixel RGB values are to pure red and green
scaleR = scale / 4;
scaleG = scale / 4;
scaleB = scale / 8;


for y = 1:imageHeight,
    for x = 1:imageWidth,
        point = [imageRGB(y,x,1); imageRGB(y,x,2); imageRGB(y,x,3)];
        
        % For each point, find out how far we are from "red" and "green"
        R_factor = 1 - norm(point - [1 0 0]');
        G_factor = 1 - norm(point - [0 1 0]');
        
        % Make reds more red and greens more green
        R(y,x) = R(y,x) + scaleR * R_factor^2;
        G(y,x) = G(y,x) + scaleG * G_factor^2;   
        
        % Adjust the blue/yellow level based on the red/green contrast
        B(y,x) = B(y,x) + scaleB * scaleG * G_factor - scaleB * scaleR * R_factor;
    end
end

% Put the image back together
imageOut(:,:,1) = R;
imageOut(:,:,2) = G;
imageOut(:,:,3) = B;

% Recover image brightness and ensure it remains within [0 1] range
imageOut = imageOut * 1.5;
imageOut(imageOut > 1) = 1;
imageOut(imageOut < 0) = 0;

end