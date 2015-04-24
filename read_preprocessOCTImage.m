function OCTImage=read_preprocessOCTImage(path2OCTImage)
%read_preprocessOCTImage - reads and preprocesses cartilage OCT image
%  OCTImage=read_preprocessOCTImage(path2OCTImage)
%  Function reads an OCT image from destination given in path2OCTImage and
%  does some preprocessing.
%
%  Function returns preprocessed OCT image.
%
%  In preprocessing image's class is changed to double and its intensities 
%  are scaled between 0 and 1. Then, extra texts and some marks which may 
%  occur in the image are removed. It is assumed that these have maximum 
%  intensity.

%  Sami Vaananen
%  2015-02-08

II = imread(path2OCTImage);
  %   Type of II
  %     class=uint8
  %     size= 2048 2048
  
  
  %Change class to double
  II=double(II);
  II=II-min(II(:));
  II=II./max(II(:));
  %imshow(II)
  
  %There is artefact-like round object. Remove by thresholding. Check that
  %this do not remove anything else.
  OCTImage=II;
  OCTImage(II>0.95)=0;
  %imshow(OCTImage-II~=0)
  

