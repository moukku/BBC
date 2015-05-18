function [OCTImagerotated,cartilage_angle,varargout]=alignCartilageHorizontally(OCTImage,varargin)
%alignCartilageHorizontally - Find cartilage and align it horizontally
%  [OCTImagerotated,catheder_BWmask_rot,cartilage_angle]=alignCartilageHorizontally(OCTImage,catheder_BWmask)
%  Function finds the largest object with high intensity in the OCT image.
%  It is assumed that this is cartilage.
%  Then it calculates the major axis of this object and rotates image such
%  that the major axis is horizontal.

%  [OCTImagerotated,cartilage_angle]=alignCartilageHorizontally(OCTImage_nocatheder)
%  Catheder can also be removed beforehand. Intensity in the center
%  of the image must then be zero.

%  [OCTImagerotated,cartilage_angle,PointOnCartilage]=alignCartilageHorizontally(...)
%  Returns a point on the cartilage. This has usually been given by user.

%  [OCTImagerotated,cartilage_angle]=alignCartilageHorizontally(OCTImage,catheder_BWmask,PointOnCartilage)
%  If point on cartilage is given then it is not asked from user

%  [OCTImagerotated,cartilage_angle,PointOnCartilage,BWinitialcartilageRot]=alignCartilageHorizontally(...)
%  Return that cartilage mask that user has pointed


% Made by Sami Vaananen
% 2015-2-9

  [Nrows,Ncols]=size(OCTImage);
  middle_row=round(Nrows/2);
  middle_col=round(Ncols/2);
  
  if nargin==1
    %Now it is assumed that catheder has been removed earlier from the
    %OCT image
    centerintensity=sum(sum(abs(OCTImage(middle_row-3:middle_row+3,middle_col-3:middle_col+3))));
    if centerintensity
      error('Catheder mask was not given but center of image has nonzero values. Check input.')
    end
    
    IInocath=OCTImage;
    
  else
    %Remove catheder from the image
    catheder_BWmask=varargin{1};
    
    IInocath=OCTImage;
    IInocath(catheder_BWmask)=0;

  end
  
  
  %I found this threshold level with trial and error. It worked with 100
  %images I tested but it is not guaranteed that it works with all possible
  %cartilage OCT images.
  
  %trlevel= 0.14;%graythresh(IInocath);
  %BWinitialcartilage=im2bw(IInocath,trlevel);
  
  %Ask from user which surface to pick
  if nargin>2%Point on cartilage is given
    BWinitialcartilage = pickCartilage(IInocath,varargin{2});
  else
   BWinitialcartilage = pickCartilage(IInocath);
  end
  %   imshow(BWinitialcartilage)

  
  % Rotate cartilage horizontally
  
  CC = bwconncomp(BWinitialcartilage);
  stats=regionprops(CC,'Area','Orientation');
  
  cartilage_angle=stats.Orientation;
  
  %First,rotate mask and make sure it end up to bottom part of theimage
  BWincartRot=imrotate(BWinitialcartilage,-cartilage_angle,'nearest','crop');
  if sum(sum(BWincartRot(1:end/2,:)))>sum(sum(BWincartRot(end/2+1:end,:)))
    %Cartilage is upside down
    
    cartilage_angle=cartilage_angle+180;
    %imshow(BWincartRot)
  end
  
  OCTImagerotated=imrotate(IInocath,-cartilage_angle,'bilinear','crop');
  %imshow(OCTImagerotated)
  BWincartRot=imrotate(BWinitialcartilage,-cartilage_angle,'nearest','crop');
  varargout{3}=BWincartRot;
  
  %catheder_BWmask_rot can be returned only if catheder_BWmask has been
  %given as input. Alsso, if it is not asked do not generate rotated image
  if nargin>1 && nargout>2
    catheder_BWmask_rot=imrotate(catheder_BWmask,-cartilage_angle,'bilinear','crop');
    varargout{1} = catheder_BWmask_rot;
  end