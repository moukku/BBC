%Score_ORI_images

%Change this according where files are located
pathname='Nikae kuvat\';
pathname_ROI='Nikae_kuvat_OCT_ROI\';

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

catheder_diameter_mm=0.9; %


load('OCTROI.mat','ROI')

%Load cutoff frequencies got from 


%% Score ROIs

cellROIs=cell(1,N_im);
for ii = 52:N_im
  disp(['ii = ',num2str(ii),' Score ROI ',filenames{ii}])
  [~,filename]=fileparts(filenames{ii});
  
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
    ,'catheder_radius','sub_cartsurf','sub_middlecart',...
    'meancartthick','sub_cartbone','idxROI_col');
  else
    s=load([pathtodata,'autoscore_debugdata_',filename,'.mat'],'OCTImagerotated'...
      ,'catheder_radius','sub_cartsurf','sub_middlecart',...
      'meancartthick','sub_cartbone','idxROI_col');
  end
  
  
  OCTImagerotated=s.OCTImagerotated;
  catheder_radius=s.catheder_radius;
  sub_cartsurf=s.sub_cartsurf;
  idxROI_col=s.idxROI_col;
  sub_cartbone=s.sub_cartbone;
  
  if find(idxROI_col,1,'first')<sub_cartsurf(1,2)
    idxROI_col(1:sub_cartsurf(1,2)-1)=0;
  end
  if find(idxROI_col,1,'last')>sub_cartsurf(end,2)
    idxROI_col(sub_cartsurf(end,2)+1:end)=0;
  end
  
  [Nrows,Ncols]=size(OCTImagerotated);
  middle_row=round(Nrows/2);
  
  %Cartilage is in the lower half of the image. Therefore it is enough to
  %work only with the lower half.
  IIrot=OCTImagerotated(middle_row+1:end,:);

  %Crop image


  IIrotCrop=IIrot;
  IIrotCrop(:,~idxROI_col)=[];
  
  %And crop subscripts
  [~,ia]=intersect(sub_cartsurf(:,2),find(~idxROI_col),'stable');
  sub_cartsurf(ia,:)=[];
  sub_cartsurf(:,2)=sub_cartsurf(:,2)-find(idxROI_col,1)+1;
  [~,ia]=intersect(sub_cartbone(:,2),find(~idxROI_col),'stable');
  sub_cartbone(ia,:)=[];
  sub_cartbone(:,2)=sub_cartbone(:,2)-find(idxROI_col,1)+1;

  if 0
    tmp=IIrotCrop;
    sz=size(tmp);
    tmp(sub2ind(sz,sub_cartsurf(:,1),sub_cartsurf(:,2)))=1;
    tmp(sub2ind(sz,sub_cartbone(:,1),sub_cartbone(:,2)))=1;
    imshow(tmp,[])
  end
  
  pixelspermm=(catheder_radius*2/catheder_diameter_mm);
  [ORI,ResultImage,idxrow_ROIORI]=calculateORI(IIrotCrop,sub_cartsurf,pixelspermm);
  
  
  [lesiondepthratio,lesiondepthmm,rowcol_lesion,BWcart,sub_cartsurf_smoothed,sub_lesion]...
    =calculateLesionDepth(IIrotCrop,sub_cartsurf,sub_cartbone,catheder_radius,catheder_diameter_mm);
    
  OCTROI_ORI=ORI;
  OCTROI_lesiondepthratio=lesiondepthratio;
  OCTROI_lesiondepthmm=lesiondepthmm;
  
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','OCTROI_ORI',...
      'OCTROI_lesiondepthratio','OCTROI_lesiondepthmm');
  else
    save([pathtodata,'autoscore_debugdata_',filename,'.mat'],'-append','OCTROI_ORI',...
      'OCTROI_lesiondepthratio','OCTROI_lesiondepthmm');
  end

  tmp=repmat(IIrot,[1,1,3]);
  
  ResultImage(:,:,1)= ResultImage(:,:,1)+0.2;
  ResultImage(:,:,2)= ResultImage(:,:,2)+0.2;
  ResultImage(ResultImage>1)=1;
  tmp(idxrow_ROIORI,idxROI_col,:)=ResultImage;
  
  rowcol_lesion(2)=rowcol_lesion(2)+find(idxROI_col,1)-1;
  
  tmp(rowcol_lesion(1)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],rowcol_lesion(2)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],1)=1;
  
  
    txt=double(text2im(['ii=',num2str(ii),' ',filename,sprintf(', ORI=%5.3f LdepthR=%3.0f%%, Ldepth=%5.2fmm',OCTROI_ORI,OCTROI_lesiondepthratio*100,OCTROI_lesiondepthmm)])==0);
  txt=repmat(txt,[1,1,size(tmp,3)]);
  tmp(1:size(txt,1),1:size(txt,2),:)=txt;
  
  tmp2=imresize(tmp,[500,1000]);

   tmp2=tmp2(1:400,:,:);
 
  
  %imshow(tmp2)
  
  
  cellROIs{ii}=tmp2;
  
end
cellROIs2=cell(10,10);   
cellROIs2(:)=cellROIs(1:100);
imwrite(cell2mat(cellROIs2),'Debug_ORI_Lesion.jpg')

