% William Woods
% EE 368 Final Project
% 6 June 2012

function imageOut = correctColor(imageRGB)

% This function takes an image and shifts its colors such that a red/green
% color blind viewer will be more likely to better see the image.
%
% Algorithm borrowed from Jonathan Michelson & Tiffany Yun:
% http://www.stanford.edu/~zbrand/C3/source_code.htm

[imageHeight imageWidth imageDepth] = size(imageRGB);
imageOut = zeros(size(imageRGB));

% Convert image to L*a*b* color space
cform1 = makecform('srgb2lab');
imageLAB = applycform(im2double(imageRGB),cform1);

% Scaling and shifting variables
scaleR = 2;
scaleG = 10;
scaleB = 4;
scaleL = .1;
threshold = 75;

% Find the minimum and maximum A to get a feel for relative contrast
a_values = imageLAB(:,:,2);
min_a = min(a_values(:));
max_a = max(a_values(:));


% Adjust LAB values based on their relative red/green values
for y = 1:imageHeight
    for x = 1:imageWidth
       
        L = imageLAB(y,x,1);
        a = imageLAB(y,x,2);
        b = imageLAB(y,x,3);       
        
        % If pixel is red shift L*a*b* values based on
        % functions determined through experimental testing
        if(a > 0 && L < threshold)
            a = a + scaleR * (abs(max_a - a) * abs(L - threshold)^-1)^(1/4);
            b = b + scaleB * sqrt( abs(max_a - a)*abs(L - threshold)^-1);
            L = L + scaleL * sqrt( abs(max_a - a));
        end
    
        % If pixel is green shift L*A*B* values based on
        % functions determined through experimental testing
        if(a < 0 && L < threshold)
            a = a - scaleG * sqrt( abs(min_a - a));
            b = b + scaleB * (abs(min_a - a)*abs(L-threshold)^-1)^(1/3);
            L = L - scaleL * sqrt( abs(min_a - a) ); 
        end
        
        % Put new L*a*b* values into image
        imageLAB(y,x,:) = [L a b];
        
    end
end

% Convert back to RGB color space
cform2 = makecform('lab2srgb');
imageOut = applycform(imageLAB,cform2);

% Ensure pixel values fall within [0 1]
imageOut(imageOut > 1) = 1;
imageOut(imageOut < 0) = 0;

end

     