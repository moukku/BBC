function [catheder_BWmask,catheder_radius,catheder_centroid]=findCatheder(OCTImage,varargin)
%findCatheder Finds catheder in OCT image and calculates its mask and radius
%  [catheder_BWmask,catheder_radius,catheder_centroid]=findCatheder(OCTImage)
%   Find the mask, radius and centroid of the catheder in OCT image. 
%
%
%  findCatheder(OCTImage,threshold)
%  Set thresholding value for finding catheder. Default value is 0.21 but
%  it may work in all images

% Made By Sami Vaananen
% 2015-02-09


  [Nrows,Ncols]=size(OCTImage);
  middle_row=round(Nrows/2);
  middle_col=round(Ncols/2);
  
    
  if nargin==1
    %I have found this threshold number with trial and
    %error. It works for all 100 test images but it is not quaranteed that it
    %is always proper threshold. Use with caution.
    threshold=0.21;
  elseif isscalar(varargin{2}) && abs(varargin{2})<=1
    threshold = varargin{2};
  else
    error('Threshold value must be scalar and between [1,0]')
  end
  
  %Threshold OCT image. 
  BW=OCTImage>threshold;%imshow(BW)
  
  %Do initial image closing
  se=strel('arbitrary',true(5,5));
  BW=imclose(BW,se); %imshow(BW)
  
  %Fill holes
  BW2 = imfill(BW,'holes');%imshow(BW2)
  
  %Pick object which covers the center pixel
  BW2=bwselect(BW2, middle_col, middle_row);
  
  %Do image closing and hole filling for the center object with a bigger
  %mask
  se = strel('disk',3,0);
  BW2=imclose(BW2,se); %imshow(BW)
  
  BW2 = imfill(BW2,'holes');%imshow(BW2)
  
  
  catheder_BWmask = BW2;
  %imshow(BWcatheder)
  
  
  %Calculate catheder's major and minor axes, equivalen diameter and
  %centroid
  Stats = regionprops(catheder_BWmask,'Area','EquivDiameter','MajorAxisLength',...
    'MinorAxisLength','Centroid');
  
  
  %If EquivDiameter is over 5% smaller than MajorAxisLength there is most
  %likely something wrong in the segmentation of the catheder.
  %Try to correct this by eroding image until the criterion is satisfied
  %and dilate image back. This corrects image in most cases. If it does not
  %work, give up before size of the object gets very small.
  %Check what EquivDiameter means from Matlab's documentation.
  circleratio=Stats.EquivDiameter/Stats.MajorAxisLength;
  if circleratio<0.95
    
    %Try to erode image. Do eroding until image has two separate objects
    se=strel('arbitrary',true(3,3));
    
    tmp=catheder_BWmask;
    jj=0;
    while circleratio<0.95
      jj=jj+1;
      
      tmp=imerode(tmp,se);
      
      tmp = bwselect(tmp, middle_col, middle_row);
      
      Stats2 = regionprops(tmp,'Area','EquivDiameter','MajorAxisLength',...
        'MinorAxisLength','Centroid');
      
      if Stats2.Area<5000
        warning('Area gets too small. Stop now')
        break
      end
      circleratio=Stats2.EquivDiameter/Stats2.MajorAxisLength;
      
    end
    
    %Grow mask back to initial size before shrinking
    for kk=1:jj
      tmp=imdilate(tmp,se);
    end
    
    catheder_BWmask=tmp;
     
    Stats = regionprops(catheder_BWmask,'Area','EquivDiameter','MajorAxisLength',...
      'MinorAxisLength','Centroid');
  
    
    %Try to separate catheder from overlapping object
    %[centers, radii, metric] = imfindcircles(,round(size(OCTImage,1)*0.0469*0.9));
    
    
    %error('EquivDiameter/MajorAxisLength<0.95, There is something wrong in the segmentation of catheder')
  end
  
  
  catheder_radius=Stats.EquivDiameter/2;
  catheder_centroid=Stats.Centroid;

  %Dilate catheder mask a bit to make sure that it covers whole catheder
  se=strel('arbitrary',true(5,5));
  catheder_BWmask=imdilate(catheder_BWmask,se);


