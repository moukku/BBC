% This scirpt is meant for plotting results and debugging autoscore
% functions

% Each part of the script is stand-alone so you can run only that part.
% Inputs and outputs of are saved to mat-files. Output images are usually
% saved ad mosaic figures

%%  GET INPUTDATA AND EXTRACT BASIC INFO FROM IT %%%%%%%%%%%%%%%%%%%%%%%%%%

%Get filenames

%[filenames, pathname] = uigetfile('*.tif','Select the image file','MultiSelect', 'on');

%Change this according where files are located
pathname='Nikae kuvat\';


%path(path,'Z:\Matlab');

filenames={   'NM81 MC3M Frame 10.tif'
  'NM82 P1M Frame 1.tif'
  'NM83 SR Frame 6.tif'
  'NM84 MC3L Frame 12.tif'
  'NM85 P1L Frame 1.tif'
  'NM101 MC3M Frame 6.tif'
  'NM102 P1M Frame 7.tif'
  'NM103 SR Frame 9.tif'
  'NM104 MC3L Frame 1.tif'
  'NM105 P1L Frame 3.tif'
  'NM111 MC3M Frame 1.tif'
  'NM112 P1M Frame 1 .tif'
  'NM113 SR Frame 18.tif'
  'NM114 MC3L Frame 1.tif'
  'NM115 P1L Frame 1.tif'
  'NM121 Frame 18.tif'
  'NM122 Frame 14.tif'
  'NM123 Frame 1.tif'
  'NM124 Frame 9.tif'
  'NM125 Frame 7.tif'
  'NM131 MC3MAA Frame 11.tif'
  'NM132 P1M Frame 1.tif'
  'NM133 SR Frame 26.tif'
  'NM134 MC3L Frame 8.tif'
  'NM135 P1L 1st Frame 12.tif'
  'NM136 MC3M Frame 1.tif'
  'NM151 MC3L Frame 9.tif'
  'NM152 P1L Frame 11.tif'
  'NM153SR frame13.tif'
  'NM154 MC3M 1st Frame 11.tif'
  'NM154 MC3MP Frame 9.tif'
  'NM155 P1M Frame 14.tif'
  'NM156 SRL 2nd Frame 1.tif'
  'NM161 MC3M 3th Frame 1.tif'
  'NM162 P1M Frame 1.tif'
  'NM163 SR Frame 1.tif'
  'NM164 MC3L Frame 1.tif'
  'NM165 P1L Frame 3.tif'
  'NM166 SRL frame 4.tif'
  'NM191 Frame 1.tif'
  'NM192 Frame 7.tif'
  'NM193 SR Frame 1.tif'
  'NM193 SRP 3 frame 36.tif'
  'NM194 Frame 5.tif'
  'NM195 Frame 11.tif'
  'NM211 MC3L rec5 Frame 20.tif'
  'NM212 P1L Frame 25.tif'
  'NM212 P1L retake frame 6.tif'
  'NM213 SR Frame 17.tif'
  'NM214 Frame 5.tif'
  'NM215 Frame 35.tif'
  'NM215 P1M retake Frame 8.tif'
  'NM221 MC3M Frame 17.tif'
  'NM222 P1M Frame 1.tif'
  'NM223 SR Frame 35.tif'
  'NM224 MC3L Frame 1.tif'
  'NM225 P1L Frame 6.tif'
  'NM231 MC3L 2nd Frame 1.tif'
  'NM232 P1L 1st Frame 10.tif'
  'NM233 SR Frame 1.tif'
  'NM234 MC3M Frame 1.tif'
  'NM235 P1M Frame 1.tif'
  'NM236 MC3LAA Frame 1.tif'
  'NM241 MC3M Frame 7.tif'
  'NM242 P1M 2nd Frame 8.tif'
  'NM243 SR Frame 1.tif'
  'NM244 MC3L Frame 16.tif'
  'NM245 P1L Frame 1.tif'
  'NM251 MC3M Frame 2.tif'
  'NM252 P1M Frame 9.tif'
  'NM253 SR Frame 49.tif'
  'NM254 MC3L Frame 23.tif'
  'NM255 P1L Frame 16.tif'
  'NM261 Frame 8.tif'
  'NM262 Frame 1.tif'
  'NM263 SR Frame 1.tif'
  'NM264 Frame 2.tif'
  'NM265 Frame 1.tif'
  'NM271 MC3LAA Frame 1.tif'
  'NM272 SR Frame 13.tif'
  'NM273 Frame 1.tif'
  'NM274 Frame 1.tif'
  'NM275 SRP OCD2 Frame 27.tif'
  'NM277 Frame 1.tif'
  'NM278 Frame 1.tif'
  'NM301 P1M Frame 4.tif'
  'NM302 SR Frame 1.tif'
  'NM303 MC3L Frame 1.tif'
  'NM304 P1L Frame 1.tif'
  'NM305 MC3M Frame 1.tif'
  'NM311 MC3M Frame 1.tif'
  'NM312 P1M 2nd Frame 11.tif'
  'NM313 SR Frame 17.tif'
  'NM314 MC3L Frame 1.tif'
  'NM315 P1L 1st Frame 12.tif'
  'NM331 MC3LAA Frame 17.tif'
  'NM332 P1L 2nd Frame 6.tif'
  'NM333 SR Frame 1.tif'
  'NM334 MC3M 2nd Frame 8.tif'
  'NM335 P1M 2nd Frame 3.tif'
  'NM336 MC3L Frame 1.tif'};

N_im=length(filenames);

%Set this to 1 if you want to set area of interest yourself
%setAreaOfInterestManually=true;
setAreaOfInterestManually=false;


if exist('autoscore_debugdata_generaldata.mat','file')
  save('autoscore_debugdata_generaldata.mat','-append','pathname',...
    'filenames','N_im','setAreaOfInterestManually');
else
  save('autoscore_debugdata_generaldata.mat','pathname','filenames','N_im',...
    'setAreaOfInterestManually');
end

% END GET INPUTDATA ------------------------------------------------------





if 0
%% READ IMAGES AND REMOVE ARTEFACTS, Output: II,Nrows,Ncols,center_row,center_col %%%%%%
%Input: pathname,filenames,N_im


%Load pathname, filenames and number of files to variables
%  -pathname
%  -filenames
%  -N_im
%  -setAreaOfInterestManually
load('autoscore_debugdata_generaldata.mat')

% Data is saved to cells:
%II - original image, where artefacts are removed
%IIrot - rotated image where the cartilage is h

for ii = 1:N_im
  disp(['ii = ',num2str(ii),'  Process ',filenames{ii}])
  %Read image
  IItmp = imread(fullfile(pathname, filenames{ii}));
  %   Type of II
  %     class=uint8
  %     size= 2048 2048
  
  imsz=size(IItmp);
  
  %Change class to double
  IItmp=double(IItmp);
  IItmp=IItmp-min(IItmp(:));
  IItmp=IItmp./max(IItmp(:));
  %imshow(II)
  
  %There is artefact-like round object. Remove by thresholding. Check that
  %this do not remove anything else.
  II2=IItmp;
  II2(IItmp>0.95)=0;
  %imshow(II-II2~=0)
  
  
  %Save for checking if needed
  %artefacts{ii}=imresize((II-II2)~=0,0.2);
  
  [Nrows,Ncols]=size(II2);
  center_row=round(Nrows/2);
  center_col=round(Ncols/2);
  
  %imshow(II2)
  
  II=II2;
  
  [~,filename]=fileparts(filenames{ii});
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','II',...
      'Nrows','Ncols','center_row','center_col');
  else
    save(['autoscore_debugdata_',filename,'.mat'],'II',...
      'Nrows','Ncols','center_row','center_col');
  end
  
end

%  END READ IMAGES AND REMOVE ARTEFACTS -----------------------------------
end
  
if 0
%% FIND CATHEDER RADIUS AND MASK AUTOMATICALLY, Output: catheder_BWmask,catheder_radius,catheder_centroid %%%%%%
%Input: II,center_col,center_row
%
%  -pathname
%  -filenames
%  -N_im
%  -setAreaOfInterestManually
load('autoscore_debugdata_generaldata.mat');

Im_catheder_radius=cell(N_im,1);

for ii = 1:N_im
  disp(['ii = ',num2str(ii),' Catheder radius, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of code
  s=load(['autoscore_debugdata_',filename,'.mat'],'II','center_col',...
    'center_row');
  II=s.II;
  center_col=s.center_col;
  center_row=s.center_row;
  
  BW=II>0.21;%imshow(BW)
  
  %Do initial image closing
  se=strel('arbitrary',true(5,5));
  BW=imclose(BW,se); %imshow(BW)
  
  %Fill holes
  BW2 = imfill(BW,'holes');%imshow(BW2)
  
  %Pick object which covers the center pixel
  BW2=bwselect(BW2, center_col, center_row);
  
  %Do image closing and hole filling for the center object with a bigger
  %mask
  se = strel('disk',3,0);
  BW2=imclose(BW2,se); %imshow(BW)
  
  BW2 = imfill(BW2,'holes');%imshow(BW2)
  
  
  catheder_BWmask = BW2;
  %imshow(BWcatheder)
  
  
  %Calculate catheder's major and minor axes
  Stats = regionprops(catheder_BWmask,'Area','EquivDiameter','MajorAxisLength',...
    'MinorAxisLength','Centroid');
  
  %Get centroid to own variable
  c=Stats.Centroid;
  
  %If EquivDiameter is over 5% smaller than MajorAxisLength there is most
  %likely something wrong in the segmentation of the catheder.
  %Try to correct this by eroding image until the criterion is satisfied
  %and dilate image back. This corrects image in most cases. If it does not
  %work, give up before size of the object gets very small.
  %See what EquivDiameter means from Matlab's documentation.
  circleratio=Stats.EquivDiameter/Stats.MajorAxisLength;
  if circleratio<0.95
    
    %Try to erode image. Do eroding until image has two separate objects
    se=strel('arbitrary',true(3,3));
    
    tmp=catheder_BWmask;
    jj=0;
    while circleratio<0.95
      jj=jj+1;
      
      tmp=imerode(tmp,se);
      
      tmp = bwselect(tmp, center_col, center_row);
      
      Stats2 = regionprops(tmp,'Area','EquivDiameter','MajorAxisLength',...
        'MinorAxisLength','Centroid');
      
      if Stats2.Area<5000
        warning('Area gets too small. Stop now')
        break
      end
      circleratio=Stats2.EquivDiameter/Stats2.MajorAxisLength;
      
    end
    
    %Grow mask back
    for kk=1:jj
      tmp=imdilate(tmp,se);
    end
    
    catheder_BWmask=tmp;
     
    Stats = regionprops(catheder_BWmask,'Area','EquivDiameter','MajorAxisLength',...
      'MinorAxisLength','Centroid');
    c=Stats.Centroid;
    
    
    %Try to separate catheder from overlapping object
    %[centers, radii, metric] = imfindcircles(,round(size(II,1)*0.0469*0.9));
    
    
    %error('EquivDiameter/MajorAxisLength<0.95, There is something wrong in the segmentation of catheder')
  end
  
  
  catheder_radius=Stats.EquivDiameter/2;
  catheder_centroid=Stats.Centroid;

  %Dilate catheder mask a bit to make sure that it covers whole catheder
  se=strel('arbitrary',true(5,5));
  catheder_BWmask=imdilate(catheder_BWmask,se);

  save(['autoscore_debugdata_',filename,'.mat'],'-append','catheder_BWmask',...
    'catheder_radius','catheder_centroid');

  
  % Save result into a image that can added to a montage
   tmp=II;
   
   tmp1_5=tmp;

   tmp1_5(catheder_BWmask)=tmp1_5(catheder_BWmask)+0.2;
   tmp1_5(tmp1_5>1)=1;
   
   r=catheder_radius;
   ang=linspace(0,2*pi,ceil(catheder_radius*2*pi));
   xp=r*cos(ang);
   yp=r*sin(ang);
   
   tmp1=tmp(:,:,1);
   tmp1(sub2ind(size(tmp),round(c(2)+yp),round(c(1)+xp)))=1;
   tmp1_5(sub2ind(size(tmp),round(c(2)+yp),round(c(1)+xp)))=1;

   r=catheder_radius+1;
   ang=linspace(0,2*pi,ceil(catheder_radius*2*pi));
   xp=r*cos(ang);
   yp=r*sin(ang);

   tmp1(sub2ind(size(tmp),round(c(2)+yp),round(c(1)+xp)))=1;
   tmp1_5(sub2ind(size(tmp),round(c(2)+yp),round(c(1)+xp)))=1;

   

   tmp2=cat(3,tmp1,tmp1_5,II);
     
   %Include only center of the image
   [Nrows,Ncols]=size(tmp);
   cutsz=0.37;
   tmp3=tmp2(round(cutsz*Nrows):round((1-cutsz)*Nrows),round(cutsz*Ncols):round((1-cutsz)*Ncols),:);
   
   
   tmp4=imresize(tmp3,[600,600]);
   
   %Set info about image to the upper part of the image
   txt=double(text2im(['ii=',num2str(ii),' ',filename])==0);
   
   tmp4(1:size(txt,1),1:size(txt,2),1)=txt;
   tmp4(1:size(txt,1),1:size(txt,2),2)=txt;
   tmp4(1:size(txt,1),1:size(txt,2),3)=txt;
   
      %imshow(tmp4)

   Im_catheder_radius{ii}=tmp4;
   
end

Im_catheder_radius2=cell(10,10);   
Im_catheder_radius2(:)=Im_catheder_radius(1:100);
imwrite(cell2mat(Im_catheder_radius2'),'Debug_image_Catheders.jpg')


%--  END AUTOMATIC CATHEDER SEARCH  ------------------------------------
end

if 0
%% ALIGN CARTILAGE HORIZONTALLY, output: IIrotated,catheder_BWmask_rot,cartilage_angle
%Input: II,catheder_BWmask,center_col,center_row

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually


for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Rotating cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of the code
  s=load(['autoscore_debugdata_',filename,'.mat'],'II',...
    'catheder_BWmask', 'center_col','center_row');
 
  IInocath=s.II;
  IInocath(s.catheder_BWmask)=0;
  catheder_BWmask=s.catheder_BWmask;
  
  trlevel= 0.14;%graythresh(IInocath);
  
  BWinitcart=im2bw(IInocath,trlevel);
  CC = bwconncomp(BWinitcart);
  stats=regionprops(CC,'Area','Orientation');
  
  areas=[stats.Area];
  idx_maxarea=find(areas==max(areas));
  
  BWinitcart=false(size(IInocath));
  BWinitcart(CC.PixelIdxList{idx_maxarea})=true;
  
  se=strel('arbitrary',true(5,5));
  BWinitcart=imclose(BWinitcart,se);
  
  BWinitcart=imfill(BWinitcart,'holes');
  %   imshow(BWinitcart)

  
  % Rotate cartilage horizontally
  
  CC = bwconncomp(BWinitcart);
  stats=regionprops(CC,'Area','Orientation');
  
  cartilage_angle=stats.Orientation;
  
  
  IIrotated=imrotate(IInocath,-cartilage_angle,'bilinear','crop');
  catheder_BWmask_rot=imrotate(catheder_BWmask,-cartilage_angle,'bilinear','crop');
  
   
  cellCartilageRotated{ii} = imresize(IIrotated(end/2:end,:),[400,800]);
  
  save(['autoscore_debugdata_',filename,'.mat'],'-append','IIrotated',...
    'catheder_BWmask_rot','cartilage_angle');
end

cellCartilageRotated2=cell(10,10);   
cellCartilageRotated2(:)=cellCartilageRotated(1:100);
imwrite(cell2mat(cellCartilageRotated2'),'Debug_rotated_images.jpg')


%%% END CARTILAGE ROTATION  %%%%%%%%%%%%%%%%%%%%%%%%%
end 

   
%% FIND MEAN LAYER OF THE CARTILAGE, output
%Input: IIrotated,Ncols,center_row

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellCartilageMeanLowerlayer

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Initial segmentation of the cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});    

  s=load(['autoscore_debugdata_',filename,'.mat'],'IIrotated'...
   ,'Ncols','center_row','catheder_radius');

   Ncols=s.Ncols;
   center_row=s.center_row;
   catheder_radius=s.catheder_radius;

  %Cartilage is in the second half of the image. Therefore it is enough to
  %woerk with the second half of the image.
  IIrot=s.IIrotated(center_row:end,:);
 
 
  %Filter image with strong horizontal filter
  immasksz=[4,round(catheder_radius*0.7)];
  sefilt=fspecial('average', [round(catheder_radius/10),round(catheder_radius)]);
  %sefilt=fspecial('gaussian', [round(catheder_radius/8),round(catheder_radius/5)],2);
  sestrel=strel('arbitrary',true(immasksz));
  %sestrel = strel('ball',round(catheder_radius/2),round(catheder_radius/10));
  
   
  IIrotHorizSmth=imclose(IIrot,sestrel);
  IIrotHorizSmth2=imfilter(IIrotHorizSmth,sefilt);
  
  BWcartrot=im2bw(IIrotHorizSmth2,0.2);%0.17
  
  
  BWcartrotedge=edge(BWcartrot,'prewitt');

  IIsmcart=IIrotHorizSmth2;
  IIsmcart(~BWcartrot)=0;

   cumsumIIsmcart=cumsum(IIsmcart.^2,1);
   
   idxmeancart=cumsumIIsmcart > repmat(cumsumIIsmcart(end,:)/2,size(cumsumIIsmcart,1),1);
   
   [row_meancart,col_meancart]=find(idxmeancart);
   
   [C,ia,ic] = unique(col_meancart) ;
   
   submeancart=[row_meancart(ia),col_meancart(ia)];
   
   
   
   %Smooth mean cartilage surface a bit
   [B,A] = butter(5,2*0.005);
   submeancart(:,1)=round(filtfilt(B,A,submeancart(:,1)));
  
   BWmeancart=false(size(IIsmcart));
   BWmeancart(sub2ind(size(IIsmcart),submeancart(:,1),submeancart(:,2)))=true;
   BWmeancart(sub2ind(size(IIsmcart),submeancart(:,1)+1,submeancart(:,2)))=true;

   
   %Find upper layer:
   
   se=strel('arbitrary',[10,10]);
   BWIIrot=im2bw(IIrot,0.2);
   BWIIrot=imclose(BWIIrot,se);
   BWIIrot=imfill(BWIIrot,'holes');
   
   cc=bwconncomp(BWIIrot);
   stats = regionprops(cc, 'Area');
   maxarea=[stats.Area]==max([stats.Area]);
   BWIIrot2=false(size(BWIIrot));
   BWIIrot2(cc.PixelIdxList{maxarea})=true;
   
   [row_uppercart,col_uppercart]=find(BWIIrot2);
   
   [C,ia,ic] = unique(col_uppercart) ;
   
   subcartsurf=[row_uppercart(ia),col_uppercart(ia)];
 
   
   %Calculate mean thickness from the cartilage surface to the mean layer.
   
   leftcart=round(max([min(subcartsurf(:,2));min(submeancart(:,2))])+catheder_radius*0.5);
   rightcart=round(min([max(subcartsurf(:,2));max(submeancart(:,2))])-catheder_radius*0.5);

   meancartthick=mean(submeancart(find(submeancart(:,2)==leftcart):find(submeancart(:,2)==rightcart),1)...
     -subcartsurf(find(subcartsurf(:,2)==leftcart):find(subcartsurf(:,2)==rightcart),1));
   
   %Find cartilage bone interface
   subcartbone=submeancart;
   subcartbone(:,1)=submeancart(:,1)+round(meancartthick);
   
   BWlowercart=false(size(IIsmcart));
   BWlowercart(sub2ind(size(IIsmcart),subcartbone(:,1),subcartbone(:,2)))=true;
   BWlowercart(sub2ind(size(IIsmcart),subcartbone(:,1)+1,subcartbone(:,2)))=true;
   BWlowercart(sub2ind(size(IIsmcart),subcartbone(:,1)+2,subcartbone(:,2)))=true;

   %Find cartilage bone interface by using changing thickness of the
   %cartilage
   %Divide cartilage to N regions
   Ncartregion=3;
   cartparts= round(linspace(leftcart,rightcart,Ncartregion+1));
   
   meancartthickparts=zeros(1,length(cartparts)-1);
   for jj=1:length(cartparts)-1
     meancartthickparts(jj)=...
       mean(submeancart(find(submeancart(:,2)==cartparts(jj)):find(submeancart(:,2)==cartparts(jj+1)),1)...
       -subcartsurf(find(subcartsurf(:,2)==cartparts(jj)):find(subcartsurf(:,2)==cartparts(jj+1)),1));   
   end
   
   %Fit a parabel to go along the surface thicknesses. 
   cartpartsz=(rightcart-leftcart)/Ncartregion;
   cartpartcenter=linspace(leftcart+cartpartsz/2,rightcart-cartpartsz/2,Ncartregion);
   
   xx=cartpartcenter';
   yy=meancartthickparts';
   H=[ones(size(xx)),xx,xx.^2];
   th=H\yy;
   xx2=(leftcart:rightcart)';
   carthalfthickness2=[ones(size(xx2)),xx2,xx2.^2]*th;
   
   subcartboneinterface2=zeros(rightcart-leftcart+1,2);
   subcartboneinterface2(:,2)=(leftcart:rightcart)';
   
   subcartboneinterface2(:,1)=submeancart(find(submeancart(:,2)==leftcart):find(submeancart(:,2)==rightcart),1)...
     +round(carthalfthickness2);
   
      BWcartboneinterface2=false(size(IIsmcart));
   BWcartboneinterface2(sub2ind(size(IIsmcart),subcartboneinterface2(:,1),subcartboneinterface2(:,2)))=true;
   BWcartboneinterface2(sub2ind(size(IIsmcart),subcartboneinterface2(:,1)+1,subcartboneinterface2(:,2)))=true;

   
  tmp1=IIrot;
  tmp1(BWcartrotedge)=1;
  tmp1(BWmeancart)=1;
  tmp2=IIrotHorizSmth2;
  tmp2(BWcartrotedge)=1;
  
  %clf,ax1=axes('Position',[0,0.5,1,0.5]);imshow(tmp1,'Border','tight');
  %  ax2=axes('Position',[0,0.0,1,0.5]);imshow(tmp2,'Border','tight');
   
  tmp1=repmat(IIrot,[1,1,3]);
  tmp1(repmat(BWcartrotedge,[1,1,3]))=1;
  
  zeromat=false(size(IIrot));
    
  tmp1(cat(3,zeromat,zeromat,BWmeancart))=1;
  tmp1(cat(3,zeromat,BWmeancart,zeromat))=0.5;
  tmp1(cat(3,BWmeancart,zeromat,zeromat))=0.5;
  
  tmp1(cat(3,zeromat,BWlowercart,zeromat))=1;
  tmp1(cat(3,BWlowercart,zeromat,zeromat))=0;
  tmp1(cat(3,zeromat,zeromat,BWlowercart))=0;

 %tmp1(cat(3,BWcartboneinterface2,zeromat,zeromat))=1;
 % tmp1(cat(3,zeromat,BWcartboneinterface2,zeromat))=0.2;
 %  tmp1(cat(3,zeromat,zeromat,BWcartboneinterface2))=0.2;


   cellCartilageMeanLowerlayer{ii} = imresize(tmp1,[400,800]);



    
end  

cellCartilageMeanLowerlayer2=cell(10,10);   
cellCartilageMeanLowerlayer2(:)=cellCartilageMeanLowerlayer(1:100);
imwrite(cell2mat(cellCartilageMeanLowerlayer2'),'Debug_Cartilage_Bone_interface.jpg')



   %Use preliminary mask to find average cartilage location.
   IIsmcart=IIrotHorizSmth;
   IIsmcart(~BWinitcart_rot)=0;
   
   IIsmcart(1:end/2,:)=0;
   
   imshow(IIsmcart)
   
   %For each column, calculate location which includes same amount of
   %intensity in both sides
   cumsumIIsmcart=cumsum(IIsmcart.^2,1);
   
   idxmeancart=cumsumIIsmcart > repmat(cumsumIIsmcart(end,:)/2,size(cumsumIIsmcart,1),1);
   
   [row_meancart,col_meancart]=find(idxmeancart);
   
   [C,ia,ic] = unique(col_meancart) ;
   
   submeancart=[row_meancart(ia),col_meancart(ia)];
   
   %Smooth mean cartilage surface a bit
   [B,A] = butter(5,2*0.005);
   tmp2=round(filtfilt(B,A,submeancart(:,1)));
   
   plot(submeancart(:,2),submeancart(:,1),'-');
   set(gca,'YDir','reverse')
   hold on  
   plot(submeancart(:,2),tmp2,'r-');

   set(gca,'YDir','normal')

   %submeancart(:,1)=tmp2;
   
   BWmeancart=false(size(IIsmcart));
   BWmeancart(sub2ind(size(IIsmcart),submeancart(:,1),submeancart(:,2)))=true;
   
   imshow(idxmeancart);
   
   tmp=IIrotated;
   tmp(sub2ind(size(IIsmcart),submeancart(:,1),submeancart(:,2)))=1;
   tmp(sub2ind(size(IIsmcart),submeancart(:,1)+1,submeancart(:,2)))=1;
   tmp(edge(BWinitcart_rot,'prewitt'))=1;
   
   %imshow(tmp)
   
   cellMeanCartLayer{ii} = imresize(tmp(end/2:end,:),[400,800]);
 
 
   
   %- END FIND MEAN LAYER OF THE CARTILAGE --------------------------------

   
   %% SEGMENT CARTILAGE-BONE INTERFACE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   
   %- END SEGMENT CARTILAGE-BONE INTERFACE  -------------------------------

   %% Get box where cartilage condition is analyzed. %%%%%%%%%%%%%%%%%%%%%% 
   %Default is at the center
      
   
   himage=imshow(IIrotated);
  
   
   %Center line of the cartilage
   [idxobject]=findn(BWinitcart_rot);
   row_meancartilage=round(mean(idxobject(:,1)));
   
   rect_width=round(catheder_radius*4);
   rect_height=round(catheder_radius*4);
   h_ImRect = imrect(gca,...
     [center_col-rect_height/2, row_meancartilage-rect_height/2 ,rect_width, rect_height]);
   
   %Save default width to figure handle. rectanglePositionCallback needs
   %this info. However, there may be better way to deliver this data to the
   %callback
   data.rectangle_width=rect_width;
   data.rectangle_handle=h_ImRect;
   set(gcf,'UserData',data);
   
   %Add callback which does not allow to change width of the rectangle
   %rectanglePositionCallback( position,width )
   %addNewPositionCallback(h_ImRect,@rectanglePositionCallback);
   h_ImRect.setPositionConstraintFcn(@(p) rectanglePositionCallback(p,width));
   
   %fcn = getPositionConstraintFcn(h)
   
   %Get rectangle coordinates
   if setAreaOfInterestManually
     position = wait(h_ImRect);
   else
     position = getPosition(h_ImRect);
   end
   
   rectmask=createMask(h_ImRect,himage);
   %      imshow(rectmask)
   
  

   %Index of first OCT pixel from bottom is needed
   [row,col]=find(flipud(IIrotHorizSmth>0.04));
   
   [C,ia,ic] = unique(col) ;
   
   subfirstOCTbottom=[row(ia),col(ia)];
   subfirstOCTbottom(:,1)=size(IIrotHorizSmth,1)-subfirstOCTbottom(:,1);
   
   tmp=IIrotated;
   tmp(BWmeancart)=1;
   tmp(sub2ind(size(IIrotHorizSmth),subfirstOCTbottom(:,1),subfirstOCTbottom(:,2)))=1;
   imshow(tmp)
   
   IIforthresh=IIrotHorizSmth;
   
   maxval=max(IIforthresh(sub2ind(size(IIforthresh),submeancart(:,1),submeancart(:,2))));
   for jj=1:length(submeancart)
     IIforthresh(1:submeancart(jj,1),submeancart(jj,2))=IIforthresh(submeancart(jj,1),submeancart(jj,2));
   end
   
   IIforthresh(:,1:min(submeancart(:,2)))=0;
   IIforthresh(:,max(submeancart(:,2)):end)=0;
   
   imshow(IIforthresh)
   
   se=[ones(20,5);-ones(20,5)];
   edges= conv2(IIforthresh,se,'same');
   edges(1:end/2,:)=0;
   imshow(edges,[0,max(edges(:))])

   %For each column, try to find location where gradient is highest
   highgrad=zeros(size(submeancart,1),1);
   colpos=zeros(size(submeancart,1),1);
   rowpos=zeros(size(submeancart,1),1);
   for jj=1:size(submeancart,1)

     x = submeancart(jj,1):subfirstOCTbottom(subfirstOCTbottom(:,2)==submeancart(jj,2),1);
     y=IIrotHorizSmth(x,submeancart(jj,2));
     
     clf
     plot(x,y,'-')
     
     if length(y)<16
       rowpos(jj)=submeancart(jj,1)+1;
     else
     [B,A] = butter(5,2*0.01);
     ysmth=filtfilt(B,A,y);
     hold on
     plot(x,ysmth,'r-')
   
     diffysmth=[diff(ysmth);0];
     
     rowpos(jj)=find(min(diffysmth)==diffysmth,1,'first')+submeancart(jj,1);
     end
     colpos(jj)=submeancart(jj,2);
     
   end
   
   %Find surface pixels which are very off
   
   %Find very large jumps:
      jump=[diff(rowpos);0];
   
   Largechange=abs(jump)>catheder_radius/3;
   
   Largechange=imclose(Largechange,strel(true(round(catheder_radius/5),1)));
   
   [D,IDX] = bwdist(~Largechange);
   
   rowpos(Largechange)=rowpos(IDX(Largechange));
   
   
     
   %Close image
   BWCartbone=false(size(IIrotHorizSmth));
   kk=0;
   for jj=colpos'
     kk=kk+1;
     BWCartbone(1:rowpos(kk),jj)=true;
   end
   
   se = strel('disk',round(catheder_radius),4);
   BWCartbone=imclose(BWCartbone,se);
      
   imshow(BWCartbone)
   
   [row,col]=find(flipud(BWCartbone));
   [C,ia,ic] = unique(col) ;
   subcartbone=[row(ia),col(ia)];
   subcartbone(:,1)=size(IIrotHorizSmth,1)-subcartbone(:,1);

   
   
   
   [B,A] = butter(5,2*0.01);
   subcartbone(:,1)=round(filtfilt(B,A,subcartbone(:,1)));
   
   
   f = togglefig('myfig', 1);
   set(f,'Position',[100,100,512,256])
      tmp=IIrotated;
   tmp(BWmeancart)=1;
   tmp(sub2ind(size(IIrotHorizSmth),rowpos,colpos))=1;
   tmp(sub2ind(size(IIrotHorizSmth),subcartbone(:,1),subcartbone(:,2)))=1;
   tmp(sub2ind(size(IIrotHorizSmth),subcartbone(:,1)+1,subcartbone(:,2)))=1;
   %imshow(tmp(end/2:end,:),'border','tight')
   %set(f,'Position',[100,100,512,256])
   %
   %hold on
   %pp=plot(subcartbone(:,2),subcartbone(:,1)-size(IIrotHorizontalSmooth,1)/2,'y-');
   
   
   cellCartBoneInterface{ii} = imresize(tmp(end/2:end,:),[400,800]);
  
   
   %% END SEGMENT CARTILAGE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
 %  end
 
 cellCartBoneInterface2=cell(10,10);
  cellCartBoneInterface2(:)=cellCartBoneInterface(1:100);

 imwrite(cell2mat(cellCartBoneInterface2'),'Autodetected_CartilageBoneInterface.jpg')

 return
 
 resim2=cell(5,20);
 resim2(:)=resim(1:100);
  imwrite(cell2mat(resim2),'Autodetected_catheders.jpg')
 
   imwrite(cell2mat(cellCartBoneInterface'),'Autodetected_CartilageBoneInterface.jpg')
 
 cellCartilageRotated2=cell(10,10);
 cellCartilageRotated2(:)=cellCartilageRotated(1:100);
 
   imwrite(cell2mat(cellCartilageRotated2'),'Cartilage_rotated.jpg')
  
cellMeanCartLayer2=cell(10,10);   
    cellMeanCartLayer2(:)=cellMeanCartLayer(1:100);
    imwrite(cell2mat(cellMeanCartLayer2'),'Cartilage_middlelayer.jpg')
   