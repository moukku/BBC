function ImageOutput = SobelOma(Image)
% CS638-1 Matlab Tutorial
% TA: Tuo Wang
% tuowang@cs.wisc.edu
% Feb 12th, 2010
 
% % convert it into double type
% Image = double(Image);
% % get the dimensional information
% height = size(Image, 1);
% width = size(Image, 2);
% channel = size(Image, 3);
% % output image
% ImageOutput = zeros(size(Image));
% % kernels
% Gx = [1 2 1; 0 0 0; -1 -2 -1];
% Gy = [1 0 -1; 2 0 -2; 1 0 -1];
% % compute for every pixel
% for i = 2 : height - 1
%    for j = 2 : width - 1
%        for k = 1 : channel
%            tempImage = Image(i - 1 : i + 1, j - 1 : j + 1, k);
%            x = sum(sum(Gx .* tempImage)); 
%            y = sum(sum(Gy .* tempImage));
%            pixValue = sqrt(x^2 + y^2);
%            ImageOutput(i, j, k) = pixValue;
%        end 
%    end
% end
% % display the processed image
% ImageOutput = uint8(ImageOutput);
maskX = [-1 0 1 ; -2 0 2; -1 0 1];
maskY = [-1 -2 -1 ; 0 0 0 ; 1 2 1] ;

resX = conv2(Image, maskX);
resY = conv2(Image, maskY);

magnitude = sqrt(resX.^2 + resY.^2);
direction = atan(resY/resX);
thresh = magnitude < 101;
% magnitude(thresh) = 0;
ImageOutput = magnitude;

end