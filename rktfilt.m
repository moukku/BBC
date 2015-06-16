function [output, convpages, kernel]=rktfilt(matrix, kernel, type)
% rktfilt   filters image using rotating kernel method
% 
%   Syntax: [output convpages kernel] = rktfilt(matrix, kernel, type)
%
% OUTPUT.... output matrix. It is the result of the weighing function
%            (specified by TYPE) on the convolved images (CONVPAGES).
% CONVPAGES. convolved images, 1 page per kernel
% KERNEL.... the used kernel. This is provided as output
%            in case the input was fed as a function
% 
% MATRIX.... matrix (image) to be convolved
% KERNEL.... matrix containing kernel (use rktkern to create one)
%            each page of this kernel is convolved separately.
% TYPE...... weighing function: 'max', 'mean', 'min' or 'mix'.
%            default: 'max'
%            'mix' = original RKMT [minmax] method, 'max'-'min'.
% 
%   Example 1: imagesc(rktfilt(matrix,rktkern(5)));
%
%   Example 2: filtered = rktfilt(matrix,rktkern(5),'min');
% 
% 
% Comments:
% - The author of this program needed only the result of 'max' function,
%   hence it is the default. Any weighing function can be applied to CONVPAGES.
%   This can be retrieved by eg.:
%   [filtered convpages] = rktfilt(input, rktkern(7));
% - This program was created for use with 'rktkern.m' for a straight RKT kernel
%   but will of course work with any other filter/kernel.
% 
% References:
% [1] Lee Y-K, Rhodes WT:
% "Nonlinear image processing by a rotating kernel transformation"
% Optics Letters, Vol. 15, No. 23, pp. 1383-1385, 1990.
% [2] Rogowska J, Bryant CM, Brezinski ME:
% "Cartilage thickness measurements from optical coherence tomography"
% J. Opt. Soc. Am. A, Vol. 20, No. 2, pp. 357-367, 2003.
%
% Version 1: 070328.
% Version 2: 070516. Changes from Version 1:
%           1) Convert input to double (lines 63-64)
%              Avoids warnings on Matlab 7 versions
%           2) Try using imfilter before conv2 (lines 67-79)
%              Quicker on intel machines
%
% Author:  Florian Bazant-Hegemark
%          Biophotonics Research Group
%          Gloucestershire Royal Hospital

if nargin < 1
    warning('RKTFILT requires 2 inputs.');
    help rktfilt
    return
elseif nargin < 2
    warning('No kernel specified.')
    help rktfilt
    return
elseif nargin < 3
    type = 'max';
end

matrix=double(matrix);
kernel=double(kernel);

convpages = zeros (size(matrix,1), size(matrix,2), size(kernel,3)); % pre-allocate memory -> quicker
try
    % 'imfilter' is quicker on Intel processors
    % 'try' because it requires the Image Processing Toolbox
    for i=1:size(kernel,3)
        convpages(:,:,i)=imfilter(matrix,kernel(:,:,i),'conv');
    end
catch
    % This should run if 'imfilter' is missing
    % The following 3 lines were in Version 1 (070328)
    for i=1:size(kernel,3)
        convpages(:,:,i)=conv2(matrix,kernel(:,:,i),'same'); %'full' | 'same' | 'valid'
    end
end

switch type
case 'min'
    output = min(convpages,'',3);
case 'mean'
    output = mean(convpages,3);
case 'mix'
    output = max(convpages,'',3)-min(convpages,'',3);
otherwise
    output = max(convpages,'',3);
end