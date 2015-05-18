% This scirpt is meant for plotting results and debugging autoscore
% functions

% Each part of the script is stand-alone so you can run only that part.
% Inputs and outputs of are saved to mat-files. Output images are usually
% saved ad mosaic figures

%%  Define INPUTDATA AND EXTRACT BASIC INFO FROM IT %%%%%%%%%%%%%%%%%%%%%%%%%%

%Get filenames
%[filenames, pathname] = uigetfile('*.tif','Select the image file','MultiSelect', 'on');

%Change this according where files are located
pathname='TyttiKuvat\';
pathtodata='tytti_data\';

%Tytti's images
[filenames, Path] = uigetfile('*.*','Pick files', 'MultiSelect', 'on');
[~, Images] = size(filenames);

N_im=length(filenames);

%Set this to 1 if you want to set area of interest yourself
%setAreaOfInterestManually=true;
setAreaOfInterestManually=false;

catheder_diameter_mm=0.9; % Was it this??

if exist('autoscore_debugdata_generaldataTytti.mat','file')
  save('autoscore_debugdata_generaldataTytti.mat','-append','pathname',...
    'filenames','N_im','setAreaOfInterestManually','catheder_diameter_mm');
else
  save('autoscore_debugdata_generaldataTytti.mat','pathname','filenames','N_im',...
    'setAreaOfInterestManually','catheder_diameter_mm');
end

% END GET INPUTDATA ------------------------------------------------------


%% READ IMAGES AND REMOVE ARTEFACTS, Output: OCTImage %%%%%%
%Input: pathname,filenames,N_im
if 0 %Set to 0 if you don't want to run this part

%Load pathname, filenames and number of files to variables
%  -pathname
%  -filenames
%  -N_im
%  -setAreaOfInterestManually
load('autoscore_debugdata_generaldataTytti.mat')

% Data is saved to cells:
%II - original image, where artefacts are removed
%IIrot - rotated image where the cartilage is h

for ii = 1:N_im
 
  disp(['ii = ',num2str(ii),'  Process ',filenames{ii}])
  %Read image
  
  OCTImage=read_preprocessOCTImage(fullfile(pathname, filenames{ii}));
    
  %imshow(OCTImage)
  
  [~,filename]=fileparts(filenames{ii});
  if exist(['autoscore_debugdataTytti_',filename,'.mat'],'file')
    save([pathtodata,'autoscore_debugdataTytti_',filename,'.mat'],'-append','OCTImage');
  else
    save([pathtodata,'autoscore_debugdataTytti_',filename,'.mat'],'OCTImage');
  end
  
  
end

end

%  END READ IMAGES AND REMOVE ARTEFACTS -----------------------------------
  

%% FIND CATHEDER RADIUS AND MASK AUTOMATICALLY, Output: catheder_BWmask,catheder_radius,catheder_centroid %%%%%%
%Input: OCTImage

if 0

load('autoscore_debugdata_generaldataTytti.mat');

for ii = 1:N_im
  disp(['ii = ',num2str(ii),' Catheder radius, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of code
  s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImage');

    OCTImage=s.OCTImage;
    [x,y] = size(OCTImage);
    
    %User places the catheter on the image
    imshow(OCTImage);
    temp = round(x*0.05);
    if(ii == 1)
        h = imellipse(gca, [x/2-temp, y/2-temp, temp, temp]);
    else
        h = imellipse(gca, position);
    end
    h.setResizable(true);
    h.setFixedAspectRatioMode(true);
    zoom(4);
    wait(h);
    position = getPosition(h);
    
    disp(position)
    
    %Mask the image
    catheder_BWmask = h.createMask();
    
    %Remove catheter from the image
    OCTImage = OCTImage - catheder_BWmask;
    
    
    Stats = regionprops(catheder_BWmask,'Area','EquivDiameter','MajorAxisLength',...
    'MinorAxisLength','Centroid');
    catheder_radius=Stats.EquivDiameter/2;
    catheder_centroid=Stats.Centroid;
    
    save(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'-append','catheder_BWmask',...
    'catheder_radius','catheder_centroid');
end

%--  END AUTOMATIC CATHEDER SEARCH  ------------------------------------
end


%% ALIGN CARTILAGE HORIZONTALLY, output: OCTImagerotated,catheder_BWmask_rot,cartilage_angle
%Input: II,catheder_BWmask

if 1

load('autoscore_debugdata_generaldataTytti.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually


for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Aligning cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  %Load those variables which are needed in this part of the code
  s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),...
    'OCTImage','catheder_BWmask');
 
  OCTImage=s.OCTImage;
  catheder_BWmask=s.catheder_BWmask;
  [OCTImagerotated,cartilage_angle,catheder_BWmask_rot,PointOnCartilage]=...
    alignCartilageHorizontally(OCTImage,catheder_BWmask);
  
   
  cellCartilageRotated{ii} = imresize(OCTImagerotated(end/2:end,:),[400,800]);
  
  save(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'-append','OCTImagerotated',...
    'catheder_BWmask_rot','cartilage_angle','PointOnCartilage');
end

% cellCartilageRotated2=cell(8,7);   
% [cellCartilageRotated2{:}]=deal(zeros(size(cellCartilageRotated{ii})));
% cellCartilageRotated2(1:N_im)=cellCartilageRotated(1:N_im);
% imwrite(cell2mat(cellCartilageRotated2'),'Debug_rotated_imagesTytti.jpg')




%%% END CARTILAGE ROTATION  %%%%%%%%%%%%%%%%%%%%%%%%%
end 

return % Move this further when catheder search works

   
%% FIND CENTERLINE THE CARTILAGE IN VERTICAL DIRECTION, output: sub_cartsurf, sub_middlecart, sub_cartsurf_smoothed, meancartthick, sub_cartbone
%Input: OCTImagerotated,catheder_radius

if 0

load('autoscore_debugdata_generaldataTytti.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellCartilageMeanLowerlayer
saveImage = cell(N_im,1);
for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Initial segmentation of the cartilage, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});

  
  s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImagerotated'...
   ,'catheder_radius');

   OCTImagerotated=s.OCTImagerotated;
   catheder_radius=s.catheder_radius;
   

  [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed,meancartthick,BWcartedge]=...
    segmentCartilageSurfaces(OCTImagerotated,catheder_radius);
   
   
  %Images for plotting 
  %Size of second half of the image
  [Nrows,Ncols]=size(OCTImagerotated);
  IIrot=OCTImagerotated(Nrows/2+1:end,:);

  
%    BWcartbone=false([Nrows/2,Ncols]);
%    BWcartbone(sub2ind([Nrows/2,Ncols],sub_cartbone(:,1),sub_cartbone(:,2)))=true;

   BWcartsurf=false([Nrows/2,Ncols]);
   BWcartsurf(sub2ind([Nrows/2,Ncols],sub_cartsurf(:,1),sub_cartsurf(:,2)))=true;
   
   %
   %
   %CREATE MONTAGE
   %
   %
   temp = IIrot + BWcartsurf;
   if(ii == 1)
        refImage = IIrot + BWcartsurf;
   end
     % Get size of reference image
        [rowsA colsA numberOfColorChannelsA] = size(refImage); 
        % Get size of existing image B. 
        [rowsB colsB numberOfColorChannelsB] = size(temp); 
        % See if lateral sizes match. 
        if rowsB ~= rowsA || colsA ~= colsB 
            % Size of B does not match A, so resize B to match A's size. 
            temp = imresize(temp, [rowsA colsA]);
        end
   saveImage{ii} = temp;
   
   

   BWcartsurf_smooth=false([Nrows/2,Ncols]);
   BWcartsurf_smooth(sub2ind([Nrows/2,Ncols],sub_cartsurf_smoothed(:,1),sub_cartsurf_smoothed(:,2)))=true;

   BWmiddlecart=false([Nrows/2,Ncols]);
   BWmiddlecart(sub2ind([Nrows/2,Ncols],sub_middlecart(:,1),sub_middlecart(:,2)))=true;

   
%    %Create montage for debugging
%    red=IIrot;
%    green=IIrot;
%    blue=IIrot;
%   
%    red(BWcartedge)=1;
%    green(BWcartedge)=1;
%    blue(BWcartedge)=1;
%   
%    blue(BWmiddlecart)=1;
%    blue(BWmiddlecart([end,1:end-1],:))=1;
%    
%    red(BWcartbone)=1;
%    red(BWcartbone([end,1:end-1],:))=1;
%    
%    green(BWcartsurf)=1;
%    green(BWcartsurf([end,1:end-1],:))=1;
%    
%    red(BWcartsurf_smooth)=1;
%    red(BWcartsurf_smooth([end,1:end-1],:))=1;
%    green(BWcartsurf_smooth)=1;
%    green(BWcartsurf_smooth([end,1:end-1],:))=1;
% 
%       
%    tmp1=cat(3,red,green,blue);
%    %imshow(tmp1)
%    
%    cellCartilageMeanLowerlayer{ii} = imresize(tmp1,[400,800]);
   
   
     if exist(['autoscore_debugdata_',filename,'.mat'],'file')
 save(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'-append','sub_cartsurf',...
     'sub_middlecart','sub_cartsurf_smoothed','meancartthick','sub_cartbone');
  else
    save(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'-append','sub_cartsurf',...
     'sub_middlecart','sub_cartsurf_smoothed','meancartthick','sub_cartbone');
     end
  
end
%   saveImage = cell2mat(saveImage);
%     imwrite(saveImage,'image.jpg');

end
%-- END FIND CARTILAGE SURFACES


%% CALCULATE ORI output: ORI
%input: OCTImagerotated, catheder_radius, sub_cartsurf
if 0
load('autoscore_debugdata_generaldataTytti.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellORI

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Calculate ORI, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
   s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImagerotated'...
      ,'catheder_radius','sub_cartsurf');
  else
   s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImagerotated'...
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
  
  disp(ORI)

  
  ResultImage=imresize(ResultImage,[NaN,2000]);
  
  cellORI{ii}=ResultImage;
  
   save(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'-append','ORI');
      
  
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

end

%% CALCULATE LESION DEPTH: output
%input: 
load('autoscore_debugdata_generaldataTytti.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

clear cellLesiondepth

for ii = 1:N_im
  
  disp(['ii = ',num2str(ii),' Calculate Lesiondepth, Process ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
    if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImagerotated'...
    ,'catheder_radius','sub_cartsurf','sub_middlecart','sub_cartsurf_smoothed',...
    'meancartthick','sub_cartbone');
  else
     s=load(fullfile(pathtodata,['autoscore_debugdataTytti_',filename,'.mat']),'OCTImagerotated'...
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