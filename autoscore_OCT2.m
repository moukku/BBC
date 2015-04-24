%Do autoscoring:

%Get filenames:
%[filenames, pathname] = uigetfile('*.tif','Select the image file','MultiSelect', 'on');

%Change this according where files are located
pathname='Nikae kuvat\';

%Set this to 1 if you want to set area of interest yourself
%setAreaOfInterestManually=true;
setAreaOfInterestManually=false;

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
 
 II = imread(fullfile(pathname, filenames{1}));
 
 imsz=size(II);
 
 artefacts=cell(N_im,1);
 
 close all
 f=figure(1);
 
 set(f,'Position',[100,100,512,512])
 
 clear resim
 clear cellCartBoneInterface
 clear cellCartilageRotated
 
 for ii = 1:N_im
   disp(['ii = ',num2str(ii),'  Process ',filenames{ii}])
   %Read image 
   II = imread(fullfile(pathname, filenames{ii}));
   %   Type of II
   %     class=uint8
   %     size= 2048 2048
   
   imsz=size(II);
   
   %Change class to double
   II=double(II);
   II=II-min(II(:));
   II=II./max(II(:));
   %imshow(II)
   
   %There is artefact-like round object. Remove by thresholding. Check that
   %this do not remove anything else.
   II2=II;
   II2(II>0.95)=0;
   %imshow(II-II2~=0)
   
     
   %Save for checking if needed
   %artefacts{ii}=imresize((II-II2)~=0,0.2);
   
   [m,n]=size(II2);
   center_row=m/2;
   center_col=n/2;
   
   imshow(II2)
   
   %% %%%%% FIND CATHEDER RADIUS AND MASK AUTOMATICALLY %%%%%%%%%%%%%%%%%%%
   
   BW=II2>0.21;%imshow(BW)
   
   se=strel('arbitrary',true(5,5));
   BW=imclose(BW,se); imshow(BW)
   
   BW2 = imfill(BW,'holes');%imshow(BW2)
   
   BW2=bwselect(BW2, center_col, center_row);
   
   se = strel('disk',3,0);
 
   
   BW2=imclose(BW2,se); imshow(BW)

   BW2 = imfill(BW2,'holes');%imshow(BW2)

   
%    se=strel('arbitrary',true(7,7));
%    BW=imclose(BW,se);
%    BW2 = imfill(BW,'holes');imshow(BW2)
   
   BWcatheder = bwselect(BW2, center_col, center_row);
   %imshow(BWcatheder)
   
   %Calculate catheders main and minor axes
   Stats = regionprops(BWcatheder,'Area','EquivDiameter','MajorAxisLength',...
     'MinorAxisLength','Centroid');
   
   c=Stats.Centroid;
   
   %If EquivDiameter is over 5% smaller than MajorAxisLength there is most
   %likely something wrong in the segmentation of the catheder
   circleratio=Stats.EquivDiameter/Stats.MajorAxisLength;
   if circleratio<0.95

     %Try to erode image. Do eroding until image has two separate objects
     se=strel('arbitrary',true(3,3));
     
     tmp=BWcatheder;
     jj=0;
     while circleratio<0.95
       jj=jj+1;
              
       tmp=imerode(tmp,se);
      
       tmp = bwselect(tmp, center_col, center_row);
      
       Stats2 = regionprops(tmp,'Area','EquivDiameter','MajorAxisLength',...
     'MinorAxisLength','Centroid');
   
       if Stats2.Area<1000
         warning('Area gets too small. Stop now')
         break
       end
       circleratio=Stats2.EquivDiameter/Stats2.MajorAxisLength;
       
     end
     
     %Grow mask back
     for kk=1:jj
       tmp=imdilate(tmp,se);
     end
     
     BWcatheder=tmp;
     
      Stats = regionprops(BWcatheder,'Area','EquivDiameter','MajorAxisLength',...
     'MinorAxisLength','Centroid');
        c=Stats.Centroid;

     %Try to separate catheder from overlapping object
     %[centers, radii, metric] = imfindcircles(,round(size(II2,1)*0.0469*0.9));
     
     
     %error('EquivDiameter/MajorAxisLength<0.95, There is something wrong in the segmentation of catheder')
   end
   
   [Stats.MinorAxisLength,Stats.EquivDiameter,Stats.MajorAxisLength];
   
   %Plot result
   tmp=II2;
   tmp(BWcatheder)=0.7;
   tmp2=cat(3,tmp,II2,II2);
   clf,imshow(tmp2)
    
   hold on
   
   r=Stats.EquivDiameter/2;
   ang=linspace(0,2*pi,360);  
   xp=r*cos(ang);
   yp=r*sin(ang);
   pp3=plot(c(1)+xp,c(2)+yp,'g:');
   plot(c(1),c(2),'*g')
   
   set(pp3,'LineWidth',3)
   
   zoom(4)
   
   set(f,'Position',[100,100,512,512])

   set(gca,'Position',[0,0,1,1])

   
   an=annotation('textbox',[0.1 0.9 0.8 0.1]);
   set(an,'LineStyle','none')
   set(an,'String',['ii=',num2str(ii),' ',filenames{ii},' Cathederdiameter = ',num2str(round(abs(Stats.EquivDiameter))),' pixels'])
   set(an,'Color',[1,1,1])   
   
 
   resim{ii} = hardcopy_cdata(gcf);
   
   zoom(1/4)
   
   Catheder_radius=Stats.EquivDiameter/2;
   
   %Make catheder mask a bit larger than the actual catheder
   se=strel('arbitrary',true(5,5));
   mask_catheder=imdilate(BWcatheder,se);
   
   %--  END AUTOMATIC CATHEDER SEARCH  ------------------------------------
  
   %Make image which do not have catheder
   IInocath=II2;
   IInocath(mask_catheder)=0;
   %imshow(IInocath)
   
   %% INITIAL SEGMENTATION OF THE CARTILAGE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
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
   

   imshow(BWinitcart)
   
   
   % Rotate cartilage horizontally

   CC = bwconncomp(BWinitcart);
   stats=regionprops(CC,'Area','Orientation');
   
   Angle_cartilage=stats.Orientation;
   
   
   IIrotated=imrotate(IInocath,-Angle_cartilage,'bilinear','crop');
   mask_catheder_rot=imrotate(BWcatheder,-Angle_cartilage,'bilinear','crop');
   BWinitcart_rot=imrotate(BWinitcart,-Angle_cartilage,'bilinear','crop');

   imshow(IIrotated)
   
   cellCartilageRotated{ii} = imresize(IIrotated(end/2:end,:),[400,800]);
 
 
   
   %%% END INITIAL SEGMENTATION OF THE CARTILAGE  %%%%%%%%%%%%%%%%%%%%%%%%%
   
   
   %% SEGMENT CARTILAGE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   %Get box where cartilage condition is analyzed. Default is at the center
   
   if 0 %JUST ONE TEST
   tmp=IIrotated;
   tmp(edge(BWinitcart_rot,'prewitt'))=1;
   himage=imshow(tmp);
   
   
   se=strel(true(3,100));
   IIdil=imdilate(IIrotated,se);
   
   IIerod=imerode(IIrotated,se);
   
   subplot(1,3,1)
   imshow(IIdil)
   subplot(1,3,2)
   imshow(IIerod)
   
   se=fspecial('average',[4,100]);
   end
   
   
   
   
   
   
   
   himage=imshow(IIrotated);
  
   
   %Center line of the cartilage
   [idxobject]=findn(BWinitcart_rot);
   row_meancartilage=round(mean(idxobject(:,1)));
   
   rect_width=round(Catheder_radius*4);
   rect_height=round(Catheder_radius*4);
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
   
   %Filter image with strong horizontal filter
   
   se=fspecial('average', [10,round(0.05*imsz(2))]);
   IIrotHorizontalSmooth=imfilter(IIrotated,se);
   
   imshow(IIrotHorizontalSmooth);
   
   %Use preliminary mask to find average cartilage location.
   IIsmcart=IIrotHorizontalSmooth;
   IIsmcart(~BWinitcart_rot)=0;
   
   IIsmcart(1:end/2,:)=0;
   
   imshow(IIsmcart)
   
   %For each column, calculate location which includes same amount of
   %intensity in both sides
   cumsumIIsmcart=cumsum(IIsmcart,1);
   
   idxmeancart=cumsumIIsmcart > repmat(cumsumIIsmcart(end,:)/2,size(cumsumIIsmcart,1),1);
   
   [row_meancart,col_meancart]=find(idxmeancart);
   
   [C,ia,ic] = unique(col_meancart) ;
   
   submeancart=[row_meancart(ia),col_meancart(ia)];
   
   %Smooth mean cartilage surface a bit
   [B,A] = butter(5,2*0.01);
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

   %Index of first OCT pixel from bottom is needed
   [row,col]=find(flipud(IIrotHorizontalSmooth>0.04));
   
   [C,ia,ic] = unique(col) ;
   
   subfirstOCTbottom=[row(ia),col(ia)];
   subfirstOCTbottom(:,1)=size(IIrotHorizontalSmooth,1)-subfirstOCTbottom(:,1);
   
   tmp=IIrotated;
   tmp(BWmeancart)=1;
   tmp(sub2ind(size(IIrotHorizontalSmooth),subfirstOCTbottom(:,1),subfirstOCTbottom(:,2)))=1;
   imshow(tmp)
   
   IIforthresh=IIrotHorizontalSmooth;
   
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
     y=IIrotHorizontalSmooth(x,submeancart(jj,2));
     
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
   
   Largechange=abs(jump)>Catheder_radius/3;
   
   Largechange=imclose(Largechange,strel(true(round(Catheder_radius/5),1)));
   
   [D,IDX] = bwdist(~Largechange);
   
   rowpos(Largechange)=rowpos(IDX(Largechange));
   
   
     
   %Close image
   BWCartbone=false(size(IIrotHorizontalSmooth));
   kk=0;
   for jj=colpos'
     kk=kk+1;
     BWCartbone(1:rowpos(kk),jj)=true;
   end
   
   se = strel('disk',round(Catheder_radius),4);
   BWCartbone=imclose(BWCartbone,se);
      
   imshow(BWCartbone)
   
   [row,col]=find(flipud(BWCartbone));
   [C,ia,ic] = unique(col) ;
   subcartbone=[row(ia),col(ia)];
   subcartbone(:,1)=size(IIrotHorizontalSmooth,1)-subcartbone(:,1);

   
   
   
   [B,A] = butter(5,2*0.01);
   subcartbone(:,1)=round(filtfilt(B,A,subcartbone(:,1)));
   
   
   f = togglefig('myfig', 1);
   set(f,'Position',[100,100,512,256])
      tmp=IIrotated;
   tmp(BWmeancart)=1;
   tmp(sub2ind(size(IIrotHorizontalSmooth),rowpos,colpos))=1;
   tmp(sub2ind(size(IIrotHorizontalSmooth),subcartbone(:,1),subcartbone(:,2)))=1;
   tmp(sub2ind(size(IIrotHorizontalSmooth),subcartbone(:,1)+1,subcartbone(:,2)))=1;
   %imshow(tmp(end/2:end,:),'border','tight')
   %set(f,'Position',[100,100,512,256])
   %
   %hold on
   %pp=plot(subcartbone(:,2),subcartbone(:,1)-size(IIrotHorizontalSmooth,1)/2,'y-');
   
   
   cellCartBoneInterface{ii} = imresize(tmp(end/2:end,:),[400,800]);
  
   
   %% END SEGMENT CARTILAGE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   
 end
 
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
  