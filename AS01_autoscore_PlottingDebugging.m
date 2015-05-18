% This scirpt is meant for plotting results and debugging autoscore
% functions

% Each part of the script is stand-alone so you can run only that part.
% Inputs and outputs of are saved to mat-files. Output images are usually
% saved ad mosaic figures

%%  Define INPUTDATA AND EXTRACT BASIC INFO FROM IT %%%%%%%%%%%%%%%%%%%%%%%%%%

%Get filenames
%[filenames, pathname] = uigetfile('*.tif','Select the image file','MultiSelect', 'on');

%Change this according where files are located
pathname='Nikae kuvat\';

if strcmp(getComputerName,'surface3')
  pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';
end

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

catheder_diameter_mm=0.9; % Was it this??

if exist('autoscore_debugdata_generaldata.mat','file')
  save('autoscore_debugdata_generaldata.mat','-append','pathname',...
    'filenames','N_im','setAreaOfInterestManually','catheder_diameter_mm');
else
  save('autoscore_debugdata_generaldata.mat','pathname','filenames','N_im',...
    'setAreaOfInterestManually','catheder_diameter_mm');
end

% END GET INPUTDATA ------------------------------------------------------


%% READ IMAGES AND REMOVE ARTEFACTS, Output: OCTImage %%%%%%
%Input: pathname,filenames,N_im
if 0

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
  
  OCTImage=read_preprocessOCTImage(fullfile(pathname, filenames{ii}));
    
  %imshow(II)
  
  [~,filename]=fileparts(filenames{ii});
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','OCTImage');
  else
    save(['autoscore_debugdata_',filename,'.mat'],'OCTImage');
  end
  
end

end

%  END READ IMAGES AND REMOVE ARTEFACTS -----------------------------------
  

%% FIND CATHEDER RADIUS AND MASK AUTOMATICALLY, Output: catheder_BWmask,catheder_radius,catheder_centroid %%%%%%
%Input: OCTImage

if 0

load('autoscore_debugdata_generaldata.mat');

Im_catheder_radius=cell(N_im,1);

for ii = 1:N_im
  disp(['ii = ',num2str(ii),' Catheder radius, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of code
  s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImage');

    OCTImage=s.OCTImage;

  [catheder_BWmask,catheder_radius,catheder_centroid]=findCatheder(OCTImage);  
  
    
  save(['autoscore_debugdata_',filename,'.mat'],'-append','catheder_BWmask',...
    'catheder_radius','catheder_centroid');

  
  % Draw catheder's mask and radius into an image. Collect images into a
  % montage
   
   green=OCTImage;
   red=OCTImage;
   blue=OCTImage;

   %Make the mask of the catheder greenish
   green(catheder_BWmask)=green(catheder_BWmask)+0.2;
   green(green>1)=1;
   

   %Draw yellow circle that encloses the catheder
   %Define the thickness of the line in pixels
   linethickness=2;
   
   for jj = 0 : linethickness-1;
     r=catheder_radius+jj;
     c=catheder_centroid;
     ang=linspace(0,2*pi,ceil(catheder_radius*2*pi));
     xp=r*cos(ang);
     yp=r*sin(ang);
   
     red(sub2ind(size(OCTImage),round(c(2)+yp),round(c(1)+xp)))=1;
     green(sub2ind(size(OCTImage),round(c(2)+yp),round(c(1)+xp)))=1;
   end
  

   tmp2=cat(3,red,green,blue);
     
   %Crop image such that only center remains
   [Nrows,Ncols]=size(OCTImage);
   cutsz=0.37;
   tmp3=tmp2(round(cutsz*Nrows):round((1-cutsz)*Nrows),round(cutsz*Ncols):round((1-cutsz)*Ncols),:);
   
   %Shrink image since otherwise montage grows too big
   tmp4=imresize(tmp3,[600,600]);
   
   %Set info about image to the upper left corner of the image
   txt=double(text2im(['ii=',num2str(ii),' ',filename])==0);
   
   txt=repmat(txt,[1,1,size(tmp4,3)]);
   
   tmp4(1:size(txt,1),1:size(txt,2),:)=txt;
   
      %imshow(tmp4)

   Im_catheder_radius{ii}=tmp4;
   
end

Im_catheder_radius2=cell(10,10);   
Im_catheder_radius2(:)=Im_catheder_radius(1:100);
imwrite(cell2mat(Im_catheder_radius2'),'Debug_image_Catheders.jpg')


%--  END AUTOMATIC CATHEDER SEARCH  ------------------------------------
end


%% ALIGN CARTILAGE HORIZONTALLY, output: OCTImagerotated,catheder_BWmask_rot,cartilage_angle
%Input: II,catheder_BWmask

if 0

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually


for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Aligning cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of the code
  s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImage',...
    'catheder_BWmask');
 
  OCTImage=s.OCTImage;
  catheder_BWmask=s.catheder_BWmask;
  [OCTImagerotated,cartilage_angle,catheder_BWmask_rot]=alignCartilageHorizontally(OCTImage,catheder_BWmask);
  
   
  cellCartilageRotated{ii} = imresize(OCTImagerotated(end/2:end,:),[400,800]);
  
  save(['autoscore_debugdata_',filename,'.mat'],'-append','OCTImagerotated',...
    'catheder_BWmask_rot','cartilage_angle');
end

cellCartilageRotated2=cell(10,10);   
cellCartilageRotated2(:)=cellCartilageRotated(1:100);
imwrite(cell2mat(cellCartilageRotated2'),'Debug_rotated_images.jpg')


%%% END CARTILAGE ROTATION  %%%%%%%%%%%%%%%%%%%%%%%%%
end 

   
%% FIND CENTERLINE THE CARTILAGE IN VERTICAL DIRECTION, output: sub_cartsurf, sub_middlecart, sub_cartsurf_smoothed, meancartthick, sub_cartbone
%Input: OCTImagerotated,catheder_radius

if 0

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellCartilageMeanLowerlayer

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Initial segmentation of the cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});    

  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
   ,'catheder_radius');
  else
    s=load([pathtodata,'autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
     ,'catheder_radius');
  end

   OCTImagerotated=s.OCTImagerotated;
   catheder_radius=s.catheder_radius;
   

  [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed,meancartthick,BWcartedge]=...
    segmentCartilageSurfaces(OCTImagerotated,catheder_radius);
   
   
  
   %Find cartilage bone interface by using changing thickness of the
   %cartilage
   %Divide cartilage to N regions
   
   %THIS DID NOT IMPROVE THE RESULT
   
%    for iii=0:0
%      Ncartregion=3;
%      cartparts= round(linspace(leftcart,rightcart,Ncartregion+1));
%      
%      meancartthickparts=zeros(1,length(cartparts)-1);
%      for jj=1:length(cartparts)-1
%        meancartthickparts(jj)=...
%          mean(sub_middlecart(find(sub_middlecart(:,2)==cartparts(jj)):find(sub_middlecart(:,2)==cartparts(jj+1)),1)...
%          -sub_cartsurf_smoothed(find(sub_cartsurf_smoothed(:,2)==cartparts(jj)):find(sub_cartsurf_smoothed(:,2)==cartparts(jj+1)),1));
%      end
%      
%      %Fit a parabel to go along the surface thicknesses.
%      cartpartsz=(rightcart-leftcart)/Ncartregion;
%      cartpartcenter=linspace(leftcart+cartpartsz/2,rightcart-cartpartsz/2,Ncartregion);
%      
%      xx=cartpartcenter';
%      yy=meancartthickparts';
%      H=[ones(size(xx)),xx,xx.^2];
%      th=H\yy;
%      xx2=(leftcart:rightcart)';
%      carthalfthickness2=[ones(size(xx2)),xx2,xx2.^2]*th;
%      
%      subcartboneinterface2=zeros(rightcart-leftcart+1,2);
%      subcartboneinterface2(:,2)=(leftcart:rightcart)';
%      
%      subcartboneinterface2(:,1)=sub_middlecart(find(sub_middlecart(:,2)==leftcart):find(sub_middlecart(:,2)==rightcart),1)...
%        +round(carthalfthickness2);
%      
%      BWcartboneinterface2=false(size(IIsmcart));
%      BWcartboneinterface2(sub2ind(size(IIsmcart),subcartboneinterface2(:,1),subcartboneinterface2(:,2)))=true;
%      BWcartboneinterface2(sub2ind(size(IIsmcart),subcartboneinterface2(:,1)+1,subcartboneinterface2(:,2)))=true;
%    end
   
   
  %Images for plotting 
  %Size of second half of the image
  [Nrows,Ncols]=size(OCTImagerotated);
  IIrot=OCTImagerotated(Nrows/2+1:end,:);

  
   BWcartbone=false([Nrows/2,Ncols]);
   BWcartbone(sub2ind([Nrows/2,Ncols],sub_cartbone(:,1),sub_cartbone(:,2)))=true;

   BWcartsurf=false([Nrows/2,Ncols]);
   BWcartsurf(sub2ind([Nrows/2,Ncols],sub_cartsurf(:,1),sub_cartsurf(:,2)))=true;

   BWcartsurf_smooth=false([Nrows/2,Ncols]);
   BWcartsurf_smooth(sub2ind([Nrows/2,Ncols],sub_cartsurf_smoothed(:,1),sub_cartsurf_smoothed(:,2)))=true;

   BWmiddlecart=false([Nrows/2,Ncols]);
   BWmiddlecart(sub2ind([Nrows/2,Ncols],sub_middlecart(:,1),sub_middlecart(:,2)))=true;

   
   %Create montage for debugging
   red=IIrot;
   green=IIrot;
   blue=IIrot;
  
   red(BWcartedge)=1;
   green(BWcartedge)=1;
   blue(BWcartedge)=1;
  
   blue(BWmiddlecart)=1;
   blue(BWmiddlecart([end,1:end-1],:))=1;
   
   red(BWcartbone)=1;
   red(BWcartbone([end,1:end-1],:))=1;
   
   green(BWcartsurf)=1;
   green(BWcartsurf([end,1:end-1],:))=1;
   
   red(BWcartsurf_smooth)=1;
   red(BWcartsurf_smooth([end,1:end-1],:))=1;
   green(BWcartsurf_smooth)=1;
   green(BWcartsurf_smooth([end,1:end-1],:))=1;

      
   tmp1=cat(3,red,green,blue);
   %imshow(tmp1)
   
   cellCartilageMeanLowerlayer{ii} = imresize(tmp1,[400,800]);
   
   
      
     if exist(['autoscore_debugdata_',filename,'.mat'],'file')
save(['autoscore_debugdata_',filename,'.mat'],'-append','sub_cartsurf',...
     'sub_middlecart','sub_cartsurf_smoothed','meancartthick','sub_cartbone');
  else
   save([pathtodata,'autoscore_debugdata_',filename,'.mat'],'-append','sub_cartsurf',...
     'sub_middlecart','sub_cartsurf_smoothed','meancartthick','sub_cartbone');
     end
  
end  

cellCartilageMeanLowerlayer2=cell(10,10);   
cellCartilageMeanLowerlayer2(:)=cellCartilageMeanLowerlayer(1:100);
imwrite(cell2mat(cellCartilageMeanLowerlayer2'),'Debug_Cartilage_Bone_interface.jpg')

end
%-- END FIND CARTILAGE SURFACES


%% CALCULATE ORI output: ORI
%input: OCTImagerotated, catheder_radius, sub_cartsurf
if 0
load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellORI

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Calculate ORI, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
      ,'catheder_radius','sub_cartsurf');
  else
    s=load([pathtodata,'autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
      ,'catheder_radius','sub_cartsurf');
  end
  OCTImagerotated=s.OCTImagerotated;
  catheder_radius=s.catheder_radius;
  sub_cartsurf=s.sub_cartsurf;
 
  [Nrows,Ncols]=size(OCTImagerotated);
  middle_row=round(Nrows/2);
  
  %Cartilage is in the lower half of the image. Therefore it is enough to
  %work only with the lower half.
  IIrot=OCTImagerotated(middle_row+1:end,:);

    pixelspermm=(catheder_radius*2/catheder_diameter_mm);
  [ORI,ResultImage]=calculateORI(IIrot,sub_cartsurf,pixelspermm);
  
  
  txt=double(text2im(['ii=',num2str(ii),' ',filename,', ORI=',sprintf('%5.3fmm',ORI)])==0);
  txt=repmat(txt,[1,1,size(tmp,3)]);
  ResultImage(1:size(txt,1),1:size(txt,2),:)=txt;

  
  ResultImage=imresize(ResultImage,[NaN,2000]);
  
  cellORI{ii}=ResultImage;
  
  save(['autoscore_debugdata_',filename,'.mat'],'-append','ORI');
      
  
  %imshow(tmp)
  
%   subplot(1,2,1)
%   tmp=IIrot;
%   tmp(sub2ind(size(IIrot),sub_cartsurf(:,1),sub_cartsurf(:,2)))=1;
%   imshow(tmp)
%   
%    
%   subplot(1,2,2)
%   pp=plot(xx,yy);
%   hold on
%   pp2=plot(xx,yyhighfreq,'r-');
%   pp3=plot(xx,yylowfreq,'g-');
% 
%   set(gca,'YDir','reverse')
  
  
   
%sub_cartsurf, sub_middlecart, sub_cartsurf_smoothed, meancartthick, sub_cartbone


end

cellORI2=cell(100,1);   
cellORI2(:)=cellORI(1:100);
imwrite(cell2mat(cellORI2),'Debug_ORI.jpg')
end

%% CALCULATE LESION DEPTH: output
%input: 

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellLesiondepth

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Calculate Lesiondepth, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
    if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
    ,'catheder_radius','sub_cartsurf','sub_middlecart','sub_cartsurf_smoothed',...
    'meancartthick','sub_cartbone');
  else
    s=load([pathtodata,'autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
      ,'catheder_radius','sub_cartsurf','sub_middlecart','sub_cartsurf_smoothed',...
      'meancartthick','sub_cartbone');
  end

  
  OCTImagerotated=s.OCTImagerotated;
  catheder_radius=s.catheder_radius;
  sub_cartsurf=s.sub_cartsurf;
  sub_cartbone=s.sub_cartbone;
  sub_middlecart=s.sub_middlecart;

  [Nrows,Ncols]=size(OCTImagerotated);
  middle_row=round(Nrows/2);

  %Cartilage is in the lower half of the image. Therefore it is enough to
  %work only with the lower half.
  IIrot=OCTImagerotated(middle_row+1:end,:);

  
  %Crop image
  leftlimit=round(sub_cartsurf(1,2)+catheder_radius);
  rightlimit=round(sub_cartsurf(end,2)-catheder_radius);
  
  idxcrop_col=false(1,size(IIrot,2));
  idxcrop_col(leftlimit:rightlimit)=true;  
  
  idxcrop_row=true(size(IIrot,1),1);

  IIrotCrop=IIrot;
  IIrotCrop(:,~idxcrop_col)=[];
  IIrotCrop(~idxcrop_row,:)=[];
  
  %And crop subscripts
  [~,ia]=intersect(sub_cartsurf(:,2),find(~idxcrop_col),'stable');
  sub_cartsurf(ia,:)=[];
  sub_cartsurf(:,2)=sub_cartsurf(:,2)-find(idxcrop_col,1)+1;
  [~,ia]=intersect(sub_cartbone(:,2),find(~idxcrop_col),'stable');
  sub_cartbone(ia,:)=[];
  sub_cartbone(:,2)=sub_cartbone(:,2)-find(idxcrop_col,1)+1;
  [~,ia]=intersect(sub_middlecart(:,2),find(~idxcrop_col),'stable');
  sub_middlecart(ia,:)=[];
  sub_middlecart(:,2)=sub_middlecart(:,2)-find(idxcrop_col,1)+1;

  if 0
    tmp=IIrotCrop;
    sz=size(tmp);
    tmp(sub2ind(sz,sub_cartsurf(:,1),sub_cartsurf(:,2)))=1;
    tmp(sub2ind(sz,sub_cartbone(:,1),sub_cartbone(:,2)))=1;
    tmp(sub2ind(sz,sub_middlecart(:,1),sub_middlecart(:,2)))=1;
    imshow(tmp,[])
  end
  
  [lesiondepthratio,lesiondepthmm,rowcol_lesion,BWcart,sub_cartsurf_smoothed,sub_lesion]...
    =calculateLesionDepth(IIrotCrop,sub_cartsurf,sub_cartbone,catheder_radius,catheder_diameter_mm);
    
  col_lesio=rowcol_lesion(2);
  
  
  
  red=IIrot;
  green=IIrot;
  blue=IIrot;
  
  %Plot mask

  %Translate cropped masks and subscripts back to size of whole image
  tmp=false(length(idxcrop_row),length(idxcrop_col));
  tmp(idxcrop_row,idxcrop_col)=BWcart;
  BWIIrot3=tmp;
  sub_cartsurf_smoothed(:,2)=sub_cartsurf_smoothed(:,2)+find(idxcrop_col,1)-1;
  sub_cartbone(:,2)=sub_cartbone(:,2)+find(idxcrop_col,1)-1;
  sub_lesion(:,2)=sub_lesion(:,2)+find(idxcrop_col,1)-1;
  col_lesio=col_lesio+find(idxcrop_col,1)-1;
  
  green(BWIIrot3)=green(BWIIrot3)+0.2;
  green(green>1)=1;
  red(BWIIrot3)=green(BWIIrot3)+0.2;
  red(green>1)=1;
  
  sz=size(IIrot);
  
  green(sub2ind(sz,sub_cartsurf_smoothed(:,1),sub_cartsurf_smoothed(:,2)))=1;
  green(sub2ind(sz,sub_cartsurf_smoothed(:,1)+1,sub_cartsurf_smoothed(:,2)))=1;

  red(sub2ind(sz,sub_cartbone(:,1),sub_cartbone(:,2)))=1;
  red(sub2ind(sz,sub_cartbone(:,1)+1,sub_cartbone(:,2)))=1;

  blue(sub2ind(sz,sub_lesion(:,1),sub_lesion(:,2)))=1;
  blue(sub2ind(sz,sub_lesion(:,1)+1,sub_lesion(:,2)))=1;

  green(: ,col_lesio+[-1,0,1])= green(: ,col_lesio+[-1,0,1])+0.3;

  green(green>1)=1;
  
  tmp=cat(3,red,green,blue);
  
  
  tmp(round(max(sub_cartbone(:,1))+0.5*pixelspermm):end,:,:)=[];

  tmp(1:round(min(sub_cartsurf_smoothed(:,1))-0.5*pixelspermm),:,:)=[];
  
  
  txt=double(text2im(['ii=',num2str(ii),' ',filename,sprintf(', LdepthR=%3.0f%%, Ldepth=%5.2fmm',maxLesiodepthratio*100,maxLesion_thickness)])==0);
  txt=repmat(txt,[1,1,size(tmp,3)]);
  tmp(1:size(txt,1),1:size(txt,2),:)=txt;

  
  tmp=imresize(tmp,[NaN,2000]);
  
  cellLesiondepth{ii}=tmp;
  
  
  %imshow(tmp)
  
     
end

cellLesiondepth2=cell(100,1);   
cellLesiondepth2(:)=cellLesiondepth(1:100);
imwrite(cell2mat(cellLesiondepth2),'Debug_Lesiondepth.jpg')

return








for kkkk=0:0 %OLD
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
   
   sub_middlecart=[row_meancart(ia),col_meancart(ia)];
   
   %Smooth mean cartilage surface a bit
   [B,A] = butter(5,2*0.005);
   tmp2=round(filtfilt(B,A,sub_middlecart(:,1)));
   
   plot(sub_middlecart(:,2),sub_middlecart(:,1),'-');
   set(gca,'YDir','reverse')
   hold on  
   plot(sub_middlecart(:,2),tmp2,'r-');

   set(gca,'YDir','normal')

   %submeancart(:,1)=tmp2;
   
   BWmiddlecart=false(size(IIsmcart));
   BWmiddlecart(sub2ind(size(IIsmcart),sub_middlecart(:,1),sub_middlecart(:,2)))=true;
   
   imshow(idxmeancart);
   
   tmp=IIrotated;
   tmp(sub2ind(size(IIsmcart),sub_middlecart(:,1),sub_middlecart(:,2)))=1;
   tmp(sub2ind(size(IIsmcart),sub_middlecart(:,1)+1,sub_middlecart(:,2)))=1;
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
   tmp(BWmiddlecart)=1;
   tmp(sub2ind(size(IIrotHorizSmth),subfirstOCTbottom(:,1),subfirstOCTbottom(:,2)))=1;
   imshow(tmp)
   
   IIforthresh=IIrotHorizSmth;
   
   maxval=max(IIforthresh(sub2ind(size(IIforthresh),sub_middlecart(:,1),sub_middlecart(:,2))));
   for jj=1:length(sub_middlecart)
     IIforthresh(1:sub_middlecart(jj,1),sub_middlecart(jj,2))=IIforthresh(sub_middlecart(jj,1),sub_middlecart(jj,2));
   end
   
   IIforthresh(:,1:min(sub_middlecart(:,2)))=0;
   IIforthresh(:,max(sub_middlecart(:,2)):end)=0;
   
   imshow(IIforthresh)
   
   se=[ones(20,5);-ones(20,5)];
   edges= conv2(IIforthresh,se,'same');
   edges(1:end/2,:)=0;
   imshow(edges,[0,max(edges(:))])

   %For each column, try to find location where gradient is highest
   highgrad=zeros(size(sub_middlecart,1),1);
   colpos=zeros(size(sub_middlecart,1),1);
   rowpos=zeros(size(sub_middlecart,1),1);
   for jj=1:size(sub_middlecart,1)

     x = sub_middlecart(jj,1):subfirstOCTbottom(subfirstOCTbottom(:,2)==sub_middlecart(jj,2),1);
     y=IIrotHorizSmth(x,sub_middlecart(jj,2));
     
     clf
     plot(x,y,'-')
     
     if length(y)<16
       rowpos(jj)=sub_middlecart(jj,1)+1;
     else
     [B,A] = butter(5,2*0.01);
     ysmth=filtfilt(B,A,y);
     hold on
     plot(x,ysmth,'r-')
   
     diffysmth=[diff(ysmth);0];
     
     rowpos(jj)=find(min(diffysmth)==diffysmth,1,'first')+sub_middlecart(jj,1);
     end
     colpos(jj)=sub_middlecart(jj,2);
     
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
   sub_cartbone=[row(ia),col(ia)];
   sub_cartbone(:,1)=size(IIrotHorizSmth,1)-sub_cartbone(:,1);

   
   
   
   [B,A] = butter(5,2*0.01);
   sub_cartbone(:,1)=round(filtfilt(B,A,sub_cartbone(:,1)));
   
   
   f = togglefig('myfig', 1);
   set(f,'Position',[100,100,512,256])
      tmp=IIrotated;
   tmp(BWmiddlecart)=1;
   tmp(sub2ind(size(IIrotHorizSmth),rowpos,colpos))=1;
   tmp(sub2ind(size(IIrotHorizSmth),sub_cartbone(:,1),sub_cartbone(:,2)))=1;
   tmp(sub2ind(size(IIrotHorizSmth),sub_cartbone(:,1)+1,sub_cartbone(:,2)))=1;
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
end