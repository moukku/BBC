function [ varargout ] = segmentCartilageSurfaces( varargin )
%segmentCartilageSurfaces - Segments the cartilage surface, meanlayer and cartilage-bone interface
%  [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed,meancartthick]=...
%    segmentCartilageSurfaces(OCTImagerotated,catheder_radius);
%  Function gets as input OCT image of cartilage, where cartilage is
%  aligned horizontally before hand. Second input is the radius of the OCT
%  catheder, which diameter is known.
%
%  As output, the function returns substricts of the cartilage surfaces. In
%  substricts there is one row value for each column where cartilage
%  exists.
%    sub_cartsurf - defines the surface of the cartilage
%    sub_middlecart - defines layer at the middle of the cartilage
%    sub_cartbone - defines the cartilage-bone interface in the OCT image
%    sub_cartsurf_smoothed - defines cartilage surface where the line has
%    been smoothed. This can be used to define where the intact cartilage
%    surface had been
%    meancartthick - defines the average thickness of the cartilage
%

OCTImagerotated = varargin{1};
catheder_radius = varargin{2};


[Nrows,Ncols]=size(OCTImagerotated);
middle_row=round(Nrows/2);


%Cartilage is in the lower half of the image. Therefore it is enough to
%work only with the lower half.
IIrot=OCTImagerotated(middle_row+1:end,:);


%Filter image with a strong horizontal filter
%The filter sizes has been found with trial and error.
immasksz=[4,round(catheder_radius*0.7)];
sefilt=fspecial('average', [round(catheder_radius/10),round(catheder_radius)]);
%sefilt=fspecial('gaussian', [round(catheder_radius/8),round(catheder_radius/5)],2);
sestrel=strel('arbitrary',true(immasksz));
%sestrel = strel('ball',round(catheder_radius/2),round(catheder_radius/10));


IIrotHorizSmth=imclose(IIrot,sestrel);
IIrotHorizSmth2=imfilter(IIrotHorizSmth,sefilt);
%imshow(IIrotHorizSmth2,[])

%The threshold value has been found with trial and error
BWcartrot=im2bw(IIrotHorizSmth2,0.2);%0.17

%This shows the region of cartilage which is used to calculate the
%meanlayer of the cartilage
BWcartedge=edge(BWcartrot,'prewitt');


%Calculate cumulative sum of the cartilage intensities in vertical direction
IIsmcart=IIrotHorizSmth2;
IIsmcart(~BWcartrot)=0;

cumsumIIsmcart=cumsum(IIsmcart.^2,1);

%Find layer, where the cumulative sum is half of the tolal value, i.e.,
%middle of the cartilage
idxmeancart=cumsumIIsmcart > repmat(cumsumIIsmcart(end,:)/2,size(cumsumIIsmcart,1),1);

%Find the row and column coordinate of the layer pixels
[row_meancart,col_meancart]=find(idxmeancart);

%Only one value on each column, i.e., calculate subscripts of the layer
[C,ia,ic] = unique(col_meancart) ;

sub_middlecart=[row_meancart(ia),col_meancart(ia)];



%Smooth the middle layer of the cartilagea bit
[B,A] = butter(5,2*0.005);
sub_middlecart(:,1)=round(filtfilt(B,A,sub_middlecart(:,1)));


%Find smoothed surface of cartilage:

se=strel('arbitrary',[10,10]);
BWIIrot=im2bw(IIrot,0.2);
BWIIrot=imclose(BWIIrot,se);
BWIIrot=imfill(BWIIrot,'holes');

cc=bwconncomp(BWIIrot);
stats = regionprops(cc, 'Area');
maxarea=[stats.Area]==max([stats.Area]);
BWIIrot2=false(size(BWIIrot));
BWIIrot2(cc.PixelIdxList{maxarea})=true;

%Calculate subscripts of the cartilage surface
[row_cartsurf,col_cartsurf]=find(BWIIrot2);
[C,ia,ic] = unique(col_cartsurf) ;
sub_cartsurf_smoothed=[row_cartsurf(ia),col_cartsurf(ia)];


%Calculate half thickness of the cartilage, i.e., distance from the
%cartilage surface to the middle layer.


%Find cartilage surface without smoothing. Image closing with 3x3 mask
%is needed to remove some artificial nonsmoothness

%IIrot
BWIIrot=im2bw(IIrot,0.15);
BWIIrot=imclose(BWIIrot,strel('arbitrary',true(3,3)));
CC = bwconncomp(BWIIrot);
areas=regionprops(CC,'Area');
areas=[areas.Area];
idxmaxarea=find(areas==max(areas),1);
BWIIrot=false(size(IIrot));
BWIIrot(CC.PixelIdxList{idxmaxarea})=true;

%Find the row and column coordinate of the layer pixels
[row_cartsurf,col_cartsurf]=find(BWIIrot);

%Only one value on each column, i.e., calculate subscripts of the layer
[C,ia,ic] = unique(col_cartsurf) ;

sub_cartsurf=[row_cartsurf(ia),col_cartsurf(ia)];


%Get surface of the cartilage

if 0
  %For debugging, plot the image
  red=IIrot;
  green=IIrot;
  blue=IIrot;
  
  green(BWIIrot)=green(BWIIrot)+0.2;
  green(green>1)=1;
  
  imshow(cat(3,red,green,blue))
end

%Find common left and righ margin for the cartilage surface and the
%middle layer
leftcart=round(max([min(sub_cartsurf_smoothed(:,2));min(sub_middlecart(:,2));min(sub_cartsurf(:,2))]+catheder_radius*0.5));
rightcart=round(min([max(sub_cartsurf_smoothed(:,2));max(sub_middlecart(:,2));max(sub_cartsurf(:,2))]-catheder_radius*0.5));

%Crop cartilage borders to common limits
idxleft=sub_middlecart(:,2)<leftcart;
idxright=sub_middlecart(:,2)>rightcart;
sub_middlecart(idxleft|idxright,:)=[];

idxleft=sub_cartsurf_smoothed(:,2)<leftcart;
idxright=sub_cartsurf_smoothed(:,2)>rightcart;
sub_cartsurf_smoothed(idxleft|idxright,:)=[];

idxleft=sub_cartsurf(:,2)<leftcart;
idxright=sub_cartsurf(:,2)>rightcart;
sub_cartsurf(idxleft|idxright,:)=[];


%Find Cartilage-Bone interface

meanhalfcartthick=mean(sub_middlecart(:,1)-sub_cartsurf_smoothed(:,1));

%Define cartilage-bone interface by moving the middle layer down the
%distance of meancartthick
sub_cartbone=sub_middlecart;
sub_cartbone(:,1)=sub_middlecart(:,1)+round(meanhalfcartthick);

%Return full average cartilage thickness, since it is clearer to understand
meancartthick=meanhalfcartthick*2;



varargout{1} = sub_cartsurf;
varargout{2} = sub_middlecart;
varargout{3} = sub_cartbone;
varargout{4} = sub_cartsurf_smoothed;
varargout{5} = meancartthick;
varargout{6} = BWcartedge;
