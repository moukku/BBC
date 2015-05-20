function output = FilterImage(ImgRotated)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        
%         kernels = rktkern(27,1);
        %Apply mean and median filter to reduce speckles
    toFilter = imresize(ImgRotated, 0.2);
%     ImgRotated=ImgRotated(round(x/2)+1:end,:);
    kernels = rktkern(31,5);
    [~,~,z] = size(kernels);
    [x,y] = size(toFilter);
    temp = zeros(x,y);
    for(i = 1:z)
        temp(:,:,i) = rktfilt(toFilter,kernels(:,:,i));
    end

    output = zeros(x, y);
    for(k = 1:x)
        for(j = 1:y)
            if(output(k, j) < max(temp(k,j,:)))
                output(k, j) = max(temp(k,j,:));
            end
        end
    end
    
    
    % Get size of reference image
    [rowsA colsA numberOfColorChannelsA] = size(ImgRotated); 
    % Get size of existing image B. 
    [rowsB colsB numberOfColorChannelsB] = size(output); 
    % See if lateral sizes match. 
    if rowsB ~= rowsA || colsA ~= colsB 
        % Size of B does not match A, so resize B to match A's size. 
        output = imresize(output, [rowsA colsA]);
    end
    output = mat2gray(output);
    output = edge(output, 'sobel', [], 'horizontal');
    %Get image Dimensions
    [width, ~] = size(output);

    %Remove small objects from image
    output = bwareaopen(output, round(width * 0.01));

end
