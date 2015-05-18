%score_histoimages


%%  Define INPUTDATA AND EXTRACT BASIC INFO FROM IT %%%%%%%%%%%%%%%%%%%%%%%%%%

%Get filenames
%[filenames, pathname] = uigetfile('*.tif','Select the image file','MultiSelect', 'on');

%Change this according where files are located
pathnameHisto='Nikae_kuvat_Histology\';

if strcmp(getComputerName,'surface3')
  pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';
end

saveluotainsync=true;

%[Path, Images] = uigetfile([pathnameHisto,'*.*'],...
%     'Pick files', 'MultiSelect', 'on');

filenamesHisto={    'NM8MC3L.tif'
    'NM8MC3M.tif'
    'NM8P1L.tif'
    'NM8P1M.tif'
    'NM8SR.tif'
    'NM10MC3L.tif'
    'NM10MC3M.tif'
    'NM10P1L.tif'
    'NM10P1M.tif'
    'NM10SR.tif'
    'NM11MC3L.tif'
    'NM11MC3M.tif'
    'NM11P1L.tif'
    'NM11P1M.tif'
    'NM11SR.tif'
    'NM12MC3L.tif'
    'NM12MC3M.tif'
    'NM12P1L.tif'
    'NM12P1M.tif'
    'NM12SR.tif'
    'NM13MC3L.tif'
    'NM13MC3M.tif'
    'NM13MC3MAA.tif'
    'NM13P1L.tif'
    'NM13SR.tif'
    'NM15MC3L.tif'
    'NM15MC3M.tif'
    'NM15MC3MP.tif'
    'NM15P1M.tif'
    'NM15SR.tif'
    'NM15SRL.tif'
    'NM16MC3L.tif'
    'NM16P1L.tif'
    'NM16P1M.tif'
    'NM16SR.tif'
    'NM16SRL.tif'
    'NM19MC3L.tif'
    'NM19MC3M.tif'
    'NM19P1L.tif'
    'NM19P1M.tif'
    'NM19SR.tif'
    'NM19SRP.tif'
    'NM21MC3L.tif'
    'NM21MC3M.tif'
    'NM21P1L.tif'
    'NM21P1M.tif'
    'NM21SR.tif'
    'NM22MC3L.tif'
    'NM22MC3M.tif'
    'NM22P1L.tif'
    'NM22P1M.tif'
    'NM22SR.tif'
    'NM23MC3L.tif'
    'NM23MC3LAA.tif'
    'NM23MC3M.tif'
    'NM23P1L.tif'
    'NM23P1M.tif'
    'NM23SR.tif'
    'NM24MC3L.tif'
    'NM24MC3M.tif'
    'NM24P1L.tif'
    'NM24P1M.tif'
    'NM24SR.tif'
    'NM24SRP.tif'
    'NM25MC3L.tif'
    'NM25MC3M.tif'
    'NM25P1L.tif'
    'NM25P1M.tif'
    'NM25SR.tif'
    'NM26MC3L.tif'
    'NM26MC3M.tif'
    'NM26P1L.tif'
    'NM26P1M.tif'
    'NM26SR.tif'
    'NM27EX.tif'
    'NM27MC3L.tif'
    'NM27MC3LAA.tif'
    'NM27MC3M.tif'
    'NM27P1L.tif'
    'NM27P1M.tif'
    'NM27SR.tif'
    'NM27SRP.tif'
    'NM30MC3L.tif'
    'NM30MC3M.tif'
    'NM30P1L.tif'
    'NM30P1M.tif'
    'NM30SR.tif'
    'NM31MC3L.tif'
    'NM31MC3M.tif'
    'NM31P1L.tif'
    'NM31P1M.tif'
    'NM31SR.tif'
    'NM33MC3L.tif'
    'NM33MC3LAA.tif'
    'NM33MC3M.tif'
    'NM33P1L.tif'
    'NM33P1M.tif'
    'NM33SR.tif'
  };   
   
% filenames={   'NM81 MC3M Frame 10.tif'
%   'NM82 P1M Frame 1.tif'
%   'NM83 SR Frame 6.tif'
%   'NM84 MC3L Frame 12.tif'
%   'NM85 P1L Frame 1.tif'
%   'NM101 MC3M Frame 6.tif'
%   'NM102 P1M Frame 7.tif'
%   'NM103 SR Frame 9.tif'
%   'NM104 MC3L Frame 1.tif'
%   'NM105 P1L Frame 3.tif'
%   'NM111 MC3M Frame 1.tif'
%   'NM112 P1M Frame 1 .tif'
%   'NM113 SR Frame 18.tif'
%   'NM114 MC3L Frame 1.tif'
%   'NM115 P1L Frame 1.tif'
%   'NM121 Frame 18.tif'
%   'NM122 Frame 14.tif'
%   'NM123 Frame 1.tif'
%   'NM124 Frame 9.tif'
%   'NM125 Frame 7.tif'
%   'NM131 MC3MAA Frame 11.tif'
%   'NM132 P1M Frame 1.tif'
%   'NM133 SR Frame 26.tif'
%   'NM134 MC3L Frame 8.tif'
%   'NM135 P1L 1st Frame 12.tif'
%   'NM136 MC3M Frame 1.tif'
%   'NM151 MC3L Frame 9.tif'
%   'NM152 P1L Frame 11.tif'
%   'NM153SR frame13.tif'
%   'NM154 MC3M 1st Frame 11.tif'
%   'NM154 MC3MP Frame 9.tif'
%   'NM155 P1M Frame 14.tif'
%   'NM156 SRL 2nd Frame 1.tif'
%   'NM161 MC3M 3th Frame 1.tif'
%   'NM162 P1M Frame 1.tif'
%   'NM163 SR Frame 1.tif'
%   'NM164 MC3L Frame 1.tif'
%   'NM165 P1L Frame 3.tif'
%   'NM166 SRL frame 4.tif'
%   'NM191 Frame 1.tif'
%   'NM192 Frame 7.tif'
%   'NM193 SR Frame 1.tif'
%   'NM193 SRP 3 frame 36.tif'
%   'NM194 Frame 5.tif'
%   'NM195 Frame 11.tif'
%   'NM211 MC3L rec5 Frame 20.tif'
%   'NM212 P1L Frame 25.tif'
%   'NM212 P1L retake frame 6.tif'
%   'NM213 SR Frame 17.tif'
%   'NM214 Frame 5.tif'
%   'NM215 Frame 35.tif'
%   'NM215 P1M retake Frame 8.tif'
%   'NM221 MC3M Frame 17.tif'
%   'NM222 P1M Frame 1.tif'
%   'NM223 SR Frame 35.tif'
%   'NM224 MC3L Frame 1.tif'
%   'NM225 P1L Frame 6.tif'
%   'NM231 MC3L 2nd Frame 1.tif'
%   'NM232 P1L 1st Frame 10.tif'
%   'NM233 SR Frame 1.tif'
%   'NM234 MC3M Frame 1.tif'
%   'NM235 P1M Frame 1.tif'
%   'NM236 MC3LAA Frame 1.tif'
%   'NM241 MC3M Frame 7.tif'
%   'NM242 P1M 2nd Frame 8.tif'
%   'NM243 SR Frame 1.tif'
%   'NM244 MC3L Frame 16.tif'
%   'NM245 P1L Frame 1.tif'
%   'NM251 MC3M Frame 2.tif'
%   'NM252 P1M Frame 9.tif'
%   'NM253 SR Frame 49.tif'
%   'NM254 MC3L Frame 23.tif'
%   'NM255 P1L Frame 16.tif'
%   'NM261 Frame 8.tif'
%   'NM262 Frame 1.tif'
%   'NM263 SR Frame 1.tif'
%   'NM264 Frame 2.tif'
%   'NM265 Frame 1.tif'
%   'NM271 MC3LAA Frame 1.tif'
%   'NM272 SR Frame 13.tif'
%   'NM273 Frame 1.tif'
%   'NM274 Frame 1.tif'
%   'NM275 SRP OCD2 Frame 27.tif'
%   'NM277 Frame 1.tif'
%   'NM278 Frame 1.tif'
%   'NM301 P1M Frame 4.tif'
%   'NM302 SR Frame 1.tif'
%   'NM303 MC3L Frame 1.tif'
%   'NM304 P1L Frame 1.tif'
%   'NM305 MC3M Frame 1.tif'
%   'NM311 MC3M Frame 1.tif'
%   'NM312 P1M 2nd Frame 11.tif'
%   'NM313 SR Frame 17.tif'
%   'NM314 MC3L Frame 1.tif'
%   'NM315 P1L 1st Frame 12.tif'
%   'NM331 MC3LAA Frame 17.tif'
%   'NM332 P1L 2nd Frame 6.tif'
%   'NM333 SR Frame 1.tif'
%   'NM334 MC3M 2nd Frame 8.tif'
%   'NM335 P1M 2nd Frame 3.tif'
%   'NM336 MC3L Frame 1.tif'};

N_imHisto=length(filenamesHisto);

%Set this to 1 if you want to set area of interest yourself
%setAreaOfInterestManually=true;
setAreaOfInterestManually=false;

catheder_diameter_mm=0.9; %mm

if 0
  if exist('autoscore_debugdata_generaldata.mat','file')
    save('autoscore_debugdata_generaldata.mat','-append','pathnameHisto',...
      'filenamesHisto','N_imHisto');
  else
    save('autoscore_debugdata_generaldata.mat','pathnameHisto','filenamesHisto','N_imHisto');
  end
  
  
  load('autoscore_debugdata_generaldata.mat')
end

%% Read images

% Data is saved to cells:
%II - original image, where artefacts are removed
%IIrot - rotated image where the cartilage is h
if 0
for ii = 1:N_imHisto
 
  disp(['ii = ',num2str(ii),'  Process ',filenamesHisto{ii}])
  %Read image
  
 % OCTImage=read_preprocessOCTImage(fullfile(pathname, filenames{ii}));
    
  II = imread(fullfile(pathnameHisto, filenamesHisto{ii}));
  %   Type of II
  %     class=uint8
  %     size= 2048 2048
  
  
  %Change class to double
  II=double(II);
  II=II-min(II(:));
  II=II./max(II(:));

  HistoImage=II;
  
  %imshow(II)
  
   
  [~,filename]=fileparts(filenamesHisto{ii});
  if saveluotainsync
    if exist([pathtodata,'autoscore_HISTO_',filename,'.mat'],'file')
      save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'-append','HistoImage');
    else
      save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HistoImage');
    end
  else
    if exist(['autoscore_HISTO_',filename,'.mat'],'file')
      save(['autoscore_HISTO_',filename,'.mat'],'-append','HistoImage');
    else
      save(['autoscore_HISTO_',filename,'.mat'],'HistoImage');
    end
  end
  
end
end
%% Set cartilage surfaces to the Histoimage
if 0
load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually

%clear cellCartSurfaces
load('TMPcellCartSurfaces.mat','cellCartSurfaces')


for ii = 63%[17,22,36,37,46]%1:N_imHisto
  
  disp(['ii = ',num2str(ii),' Set, Process ',filenamesHisto{ii}])
  [~,filename]=fileparts(filenamesHisto{ii});
  
  %Load those variables which are needed in this part of the code
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_HISTO_',filename,'.mat'],'HistoImage');
  else
  s=load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HistoImage');
  end
  
   
  % Show image and ask to set Cartilage surface, and Cartilage-Bone
  % interface, and 100um line
  
  HistoImage=s.HistoImage;
  
  if size(HistoImage,3)>3
    HistoImage=HistoImage(:,:,1:3);
  end
  
  clf
  imshow(HistoImage)
  
  title('Set cartilage surface')
  [x, y] = getline(gca);
  
  line_CartilageSurface=[x,y];
  hold on
  p1=plot(x,y,'y');p2=plot(x,y);set(p1,'LineWidth',4);set(p2,'LineWidth',2,'Color','b')
  

  title('Set cartilage bone Interface')
  [x, y] = getline(gca);
  
  line_CartilageBoneInterface=[x,y];
  hold on
  p1=plot(x,y,'y');p2=plot(x,y);set(p1,'LineWidth',4);set(p2,'LineWidth',2,'Color','b')
  
  title('Set Length of 100um')
  [x, y] = getline(gca);
  
  line_100um=[x,y];
  hold on
  p1=plot(x,y,'y');p2=plot(x,y);set(p1,'LineWidth',4);set(p2,'LineWidth',2,'Color','b')
  
  
  if exist(['autoscore_HISTO_',filename,'.mat'],'file')
    save(['autoscore_HISTO_',filename,'.mat'],'-append',...
      'line_CartilageSurface','line_CartilageBoneInterface',...
      'line_100um');
  else
    save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'-append',...
      'line_CartilageSurface','line_CartilageBoneInterface',...
      'line_100um');
  end
  
  title(['ii = ',num2str(ii),' Cartilagesurfaces ',filenamesHisto{ii}])
  
  IM=hardcopy_cdata(gcf);

  cellCartSurfaces{ii}=IM;
  

end

save('TMPcellCartSurfaces.mat','cellCartSurfaces')

cellCartSurfaces

cellCartSurfaces2=cell(10,10);
cellCartSurfaces2(1:length(cellCartSurfaces))=cellCartSurfaces(1:length(cellCartSurfaces));
cellCartSurfaces2{99}=zeros(size(cellCartSurfaces{1}),'uint8');
cellCartSurfaces2{100}=zeros(size(cellCartSurfaces{1}),'uint8');
for ii=1:numel(cellCartSurfaces2)
  cellCartSurfaces2{ii}=imresize(cellCartSurfaces2{ii},[780,1091]);
end
imwrite(cell2mat(cellCartSurfaces2'),'Debug_HISTCartSurfaces.jpg')

end

%% Rotate images and surfaces, and crop the images

if 0 
  
load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually


clear cellROTHISTOIM
for ii = 1:17%63:N_imHisto
  
  disp(['ii = ',num2str(ii),' Rotate, Process ',filenamesHisto{ii}])
  [~,filename]=fileparts(filenamesHisto{ii});
  
  %Load those variables which are needed in this part of the code
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_HISTO_',filename,'.mat'],'HistoImage',...
    'line_CartilageSurface','line_CartilageBoneInterface',...
      'line_100um');
  else
  s=load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HistoImage',...
    'line_CartilageSurface','line_CartilageBoneInterface',...
      'line_100um');
  end
  
  
  HistoImage=s.HistoImage;
  line_CartilageSurface=s.line_CartilageSurface;
  line_CartilageBoneInterface=s.line_CartilageBoneInterface;
  line_100um=s.line_100um;
  
  if size(HistoImage,3)>3
    HistoImage=HistoImage(:,:,1:3);
  end

  
  %Find angle of cartilage from image cartilage surfaces
  
  %imshow(HistoImage)
  
  %Sort
  line_CartilageSurface=sortrows(line_CartilageSurface,1);
  line_CartilageBoneInterface=sortrows(line_CartilageBoneInterface,1);
  line_100um=sortrows(line_100um,1);
    
  %Find angle:
  x=diff(line_CartilageSurface([end,1],2));
  z=sqrt(diff(line_CartilageSurface([end,1],1)).^2+x.^2);
  angsurf=asind(x/z);
  x=diff(line_CartilageBoneInterface([end,1],2));
  z=sqrt(diff(line_CartilageBoneInterface([end,1],1)).^2+x.^2);
  anginterf=asind(x/z);
  
  angle_cartilageHIST=mean([angsurf,anginterf]);
  th=-angle_cartilageHIST/180*pi; 
 
  HistoImage_horiz=imrotate(HistoImage,-angle_cartilageHIST,'loose');

 
  %Rotate surface of the cartilage
  I=zeros(size(HistoImage(:,:,1)));
  subs=round(line_CartilageSurface(:,[2,1]));
  for  jj=1:size(subs,1)
    tmpsubs=[subs(jj,1)+[-1;0;1],subs(jj,2)+[-1;0;1]];
    tmpsubs(tmpsubs<1)=1;
    tmpsubs(tmpsubs(:,1)>size(I,1),1)=size(I,1);
    tmpsubs(tmpsubs(:,2)>size(I,2),2)=size(I,2);
    I(sub2ind(size(I),tmpsubs(:,1),tmpsubs(:,2)))=jj;
  end
  
  I=imrotate(I,-angle_cartilageHIST,'nearest','loose');
  %imshow(I,[])
  
  subs_surfHori=zeros(size(subs));
  for  jj=1:size(subs,1)
    subs_surfHori(jj,:)=round(mean(findn(I==jj)));
  end
  
  %Rotate bone-cartilage interface
    I=zeros(size(HistoImage(:,:,1)));
  subs=round(line_CartilageBoneInterface(:,[2,1]));
  for  jj=1:size(subs,1)
    tmpsubs=[subs(jj,1)+[-1;0;1],subs(jj,2)+[-1;0;1]];
    tmpsubs(tmpsubs<1)=1;
    tmpsubs(tmpsubs(:,1)>size(I,1),1)=size(I,1);
    tmpsubs(tmpsubs(:,2)>size(I,2),2)=size(I,2);
    I(sub2ind(size(I),tmpsubs(:,1),tmpsubs(:,2)))=jj;
  end
  
  I=imrotate(I,-angle_cartilageHIST,'nearest','loose');
  %imshow(I,[])
  
  subs_surfInterf=zeros(size(subs));
  for  jj=1:size(subs,1)
    subs_surfInterf(jj,:)=round(mean(findn(I==jj)));
  end
  
  
    %Rotate 100um Length
    I=zeros(size(HistoImage(:,:,1)));
  subs=round(line_100um(:,[2,1]));
  for  jj=1:size(subs,1)
    tmpsubs=[subs(jj,1)+[-1;0;1],subs(jj,2)+[-1;0;1]];
    tmpsubs(tmpsubs<1)=1;
    tmpsubs(tmpsubs(:,1)>size(I,1),1)=size(I,1);
    tmpsubs(tmpsubs(:,2)>size(I,2),2)=size(I,2);
    I(sub2ind(size(I),tmpsubs(:,1),tmpsubs(:,2)))=jj;
  end
  
  I=imrotate(I,-angle_cartilageHIST,'nearest','loose');
  %imshow(I,[])
  
  subs_line_100um=zeros(size(subs));
  for  jj=1:size(subs,1)
    subs_line_100um(jj,:)=round(mean(findn(I==jj)));
  end
  
  
  %Make subscript for each surface pixel
  subs=subs_surfHori;
  subs(sum(isnan(subs),2)~=0,:)=[];
  subs_s=sortrows(subs,2);
  subs2=(subs_s(1,2):subs_s(end,2))';
  subs1=zeros(length(subs2),1);

  for jj=1:size(subs,1)-1
    subs1(subs2>=subs(jj,2)&subs2<=subs(jj+1,2))...
      =round(linspace(subs(jj,1),subs(jj+1,1),diff(subs([jj,jj+1],2))+1));
  end
  sub_CartilageSurfaceHIST= [subs1,subs2];
  
  subs=subs_surfInterf;
  subs(sum(isnan(subs),2)~=0,:)=[];
  subs_s=sortrows(subs,2);
  subs2=(subs_s(1,2):subs_s(end,2))';
  subs1=zeros(length(subs2),1);

  for jj=1:size(subs,1)-1
    subs1(subs2>=subs(jj,2)&subs2<=subs(jj+1,2))...
      =round(linspace(subs(jj,1),subs(jj+1,1),diff(subs([jj,jj+1],2))+1));
  end
  sub_CartilageBoneInterfaceHIST= [subs1,subs2];
  
  subs=subs_line_100um;
  subs(sum(isnan(subs),2)~=0,:)=[];
  subs_s=sortrows(subs,2);
  subs2=(subs_s(1,2):subs_s(end,2))';
  subs1=zeros(length(subs2),1);
  for jj=1:size(subs,1)-1
    subs1(subs2>=subs(jj,2)&subs2<=subs(jj+1,2))...
      =round(linspace(subs(jj,1),subs(jj+1,1),diff(subs([jj,jj+1],2))+1));
  end
  sub_100umHIST= [subs1,subs2];
  
  length100umHIST=round(norm(diff(sub_100umHIST([1,end],:))));
  
  %Crop image to that region where both cartilage surface and
  %cartilage-bone interface are defined in each column
  
  leftlimit=max([min(subs_surfHori(:,2)),min(subs_surfInterf(:,2))]);
  rightlimit=min([max(subs_surfHori(:,2)),max(subs_surfInterf(:,2))]);
  
  idxROIHIST_col=false(1,size(HistoImage_horiz,2));
  idxROIHIST_col(leftlimit:rightlimit)=true;  
  
  
  HistoImage_rot=HistoImage_horiz;
  
    if exist(['autoscore_HISTO_',filename,'.mat'],'file')
    save(['autoscore_HISTO_',filename,'.mat'],'-append',...
      'HistoImage_rot','sub_CartilageSurfaceHIST',...
      'sub_CartilageBoneInterfaceHIST','sub_100umHIST','length100umHIST',...
   'idxROIHIST_col');
  else
    save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'-append',...
      'HistoImage_rot','sub_CartilageSurfaceHIST',...
      'sub_CartilageBoneInterfaceHIST','sub_100umHIST','length100umHIST',...
   'idxROIHIST_col');
  end
  
    
  tmp=HistoImage_horiz;
  tmp(:,~idxROIHIST_col,:)=tmp(:,~idxROIHIST_col,:)+0.3;
  tmp(tmp>1)=1;
  
  tmp2=tmp(:,:,3);
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1),sub_CartilageSurfaceHIST(:,2)))=1;
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1)+1,sub_CartilageSurfaceHIST(:,2)))=1;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1),sub_CartilageBoneInterfaceHIST(:,2)))=1;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1)+1,sub_CartilageBoneInterfaceHIST(:,2)))=1;
  tmp(:,:,3)=tmp2;
  tmp2=tmp(:,:,1);
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1),sub_CartilageSurfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1)+1,sub_CartilageSurfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1),sub_CartilageBoneInterfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1)+1,sub_CartilageBoneInterfaceHIST(:,2)))=0;
  tmp(:,:,1)=tmp2;
  tmp2=tmp(:,:,2);
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1),sub_CartilageSurfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageSurfaceHIST(:,1)+1,sub_CartilageSurfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1),sub_CartilageBoneInterfaceHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_CartilageBoneInterfaceHIST(:,1)+1,sub_CartilageBoneInterfaceHIST(:,2)))=0;
  tmp(:,:,2)=tmp2;
  tmp2=tmp(:,:,1);
  tmp2(sub2ind(size(tmp2),sub_100umHIST(:,1),sub_100umHIST(:,2)))=1;
  tmp2(sub2ind(size(tmp2),sub_100umHIST(:,1)+1,sub_100umHIST(:,2)))=1;
  tmp(:,:,1)=tmp2;
  tmp2=tmp(:,:,3);
  tmp2(sub2ind(size(tmp2),sub_100umHIST(:,1),sub_100umHIST(:,2)))=0;
  tmp2(sub2ind(size(tmp2),sub_100umHIST(:,1)+1,sub_100umHIST(:,2)))=0;
  tmp(:,:,3)=tmp2;
  

  cellROTHISTOIM{ii}=tmp;
  
  %clf,imshow(tmp);
  
%   hold on
%   p=plot(subs_surfHori(:,2),subs_surfHori(:,1),'b-');
%   set(p,'LineWidth',2)  
%   p=plot(subs_surfInterf(:,2),subs_surfInterf(:,1),'b-');
%   set(p,'LineWidth',2)  
%   p=plot(subs_line_100um(:,2),subs_line_100um(:,1),'b-');
%   set(p,'LineWidth',2)  
  

end

celltmp=cell(size(cellROTHISTOIM));
for ii=1:numel(cellROTHISTOIM)
  celltmp{ii}=imresize(cellROTHISTOIM{ii},[1000,1300]);
end

celltmp2=cell(10,10);
celltmp2(1:length(celltmp))=celltmp(1:length(celltmp));
celltmp2{99}=zeros(size(celltmp{1}));
celltmp2{100}=zeros(size(celltmp{1}));

imwrite(cell2mat(celltmp2'),'Debug_HISTAlignedCartilage.jpg')


end

%% Calculate ORI and Lesion depth

load('autoscore_debugdata_generaldata.mat');
%  -pathname, -filenames, -N_im, -setAreaOfInterestManually


cellROIHist=cell(1,N_imHisto);
cellORIHist=cell(1,N_imHisto);
for ii = 1:N_imHisto
  
  disp(['ii = ',num2str(ii),' Rotate, Process ',filenamesHisto{ii}])
  [~,filename]=fileparts(filenamesHisto{ii});
  
  %Load those variables which are needed in this part of the code
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
  s=load(['autoscore_HISTO_',filename,'.mat'],'HistoImage_rot',...
    'sub_CartilageSurfaceHIST','sub_CartilageBoneInterfaceHIST',...
      'length100umHIST','idxROIHIST_col');
  else
  s=load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HistoImage_rot',...
    'sub_CartilageSurfaceHIST','sub_CartilageBoneInterfaceHIST',...
      'length100umHIST','idxROIHIST_col');
  end
  
  HistoImage_rot=s.HistoImage_rot;
  sub_CartilageSurfaceHIST=s.sub_CartilageSurfaceHIST;
  sub_CartilageBoneInterfaceHIST=s.sub_CartilageBoneInterfaceHIST;
  length100umHIST=s.length100umHIST;
  idxROIHIST_col=s.idxROIHIST_col;
  
  %Crop image
  maxcart=max(sub_CartilageBoneInterfaceHIST(:,1));
  II=HistoImage_rot(1:maxcart+30,idxROIHIST_col,:);
  
  sub_CartilageSurfaceHIST(:,2)=sub_CartilageSurfaceHIST(:,2)-find(idxROIHIST_col,1)+1;
  sub_CartilageBoneInterfaceHIST(:,2)=sub_CartilageBoneInterfaceHIST(:,2)-find(idxROIHIST_col,1)+1;
  
  sub_CartilageSurfaceHIST(sub_CartilageSurfaceHIST(:,2)<1,:)=[];
  sub_CartilageBoneInterfaceHIST(sub_CartilageBoneInterfaceHIST(:,2)<1,:)=[];

  sub_CartilageSurfaceHIST(sub_CartilageSurfaceHIST(:,2)>size(II,2),:)=[];
  sub_CartilageBoneInterfaceHIST(sub_CartilageBoneInterfaceHIST(:,2)>size(II,2),:)=[];

  
  %Black regions to white
  IIgray=rgb2gray(II);
  II(repmat(IIgray<0.05,[1,1,3]))=1;
  
  %Image above cartilagesurface to median color
  mask=false(size(IIgray));
  for jj=1:length(sub_CartilageSurfaceHIST(:,2)')
    mask(max([1,sub_CartilageSurfaceHIST(jj,1)-100]):sub_CartilageSurfaceHIST(jj,1)-30,sub_CartilageSurfaceHIST(jj,2),1)=true;    
  end
  mask(IIgray==0)=false;
  maskval=median(IIgray(mask));
  for jj=1:length(sub_CartilageSurfaceHIST(:,2)')
    II(1:sub_CartilageSurfaceHIST(jj,1),sub_CartilageSurfaceHIST(jj,2),:)=maskval;    
  end
  %Find cartilage surface

  IIgray=rgb2gray(II);
  %IIgray=II(:,:,3);
  %subplot(1,2,1),imshow(rgb2gray(II)),subplot(1,2,2),imshow(II(:,:,3))
  %clf,imhist(IIgray,100);
  [counts,x]=imhist(IIgray,100);
  idx=find(x>maskval,1);
  % hold on
  %plot([x(idx),x(idx)],[0,counts(idx)],'g')
  diffcounts=[diff(counts);0];
  diffcounts(idx-2:end)=1;
  %[diffcounts,counts,x]
  idxth=(find(diffcounts<0,1,'last'));
  level2=x(idxth);
  %hold on
  %plot([x(idxth),x(idxth)],[0,counts(idxth)],'r')
  
  level = graythresh(IIgray);
  th=max([level,level2]);
  IIBW=IIgray<th;

  
  CC = bwconncomp(IIBW);
  ss=regionprops(CC,'Area');
  areas=[ss.Area];
  
  IIBW(:)=false;
  
  IIBW(CC.PixelIdxList{find(areas==max(areas),1)})=true;
  
  IIBW=imclose(IIBW,strel('arbitrary',true(3,3)));

  
  IIBWori=IIgray<th;

  
  CC = bwconncomp(IIBWori);
  ss=regionprops(CC,'Area');
  areas=[ss.Area];
  
  IIBWori(:)=false;
  
  IIBWori(CC.PixelIdxList{find(areas==max(areas),1)})=true;
  
  IIBWori=imclose(IIBWori,strel('arbitrary',true(3,3)));

  
  [row_cartsurf,col_cartsurf]=find(IIBWori);
  [C,ia,ic] = unique(col_cartsurf) ;
  sub_realcartsurfHIST=[row_cartsurf(ia),col_cartsurf(ia)];
  
  % Score image
   % [lesiondepthratio,lesiondepthmm,rowcol_lesion,BWcart,sub_cartsurf_smoothed,sub_lesion]...
   % =calculateLesionDepth(IIrotCrop,sub_cartsurf,sub_cartbone,catheder_radius,catheder_diameter_mm);
  pixelspermm=length100umHIST/0.1;  
  [ ORIhist,ResultImage,idxcroprow] = calculateORI(IIgray,sub_realcartsurfHIST,pixelspermm);
  
  [lesiondepthratio,lesiondepthmm,rowcol_lesion,BWcart,sub_cartsurf_smoothed,sub_lesion]...
    =calculateLesionDepthHIST(IIBW,sub_realcartsurfHIST,sub_CartilageSurfaceHIST,sub_CartilageBoneInterfaceHIST,pixelspermm);
  
  
  tmp=repmat(IIgray,[1,1,3]);
  
  %ResultImage(:,:,1)= ResultImage(:,:,1)+0.1;
  %ResultImage(:,:,2)= ResultImage(:,:,2)+0.05;
  ResultImage(ResultImage>1)=1;
  tmp(idxcroprow,:,:)=ResultImage;
  
  %rowcol_lesion(2)=rowcol_lesion(2)+find(idxROI_col,1)-1;
  
  if 6-rowcol_lesion(2)>0
    rowcol_lesion(2)=6;
  end
  if size(tmp,2)-rowcol_lesion(2)<=5
    rowcol_lesion(2)=size(tmp,2)-5;
  end
  tmp(rowcol_lesion(1)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],rowcol_lesion(2)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],1)=1;
  tmp(rowcol_lesion(1)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],rowcol_lesion(2)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],2)=0;
  tmp(rowcol_lesion(1)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],rowcol_lesion(2)+[-5,-4,-3,-2,-1,0,1,2,3,4,5],3)=0;
  
  %tmp=repmat(IIgray,[1,1,3]);
  tmp2=tmp(:,:,1);
  tmp2(IIBW)=tmp2(IIBW)+0.1;
  tmp(:,:,1)=tmp2;
  tmp(tmp>1)=1;
  
  tmp(1:max([min(sub_CartilageSurfaceHIST(:,1))-100,1]),:,:)=[];
  
  txt=double(text2im(['ii=',num2str(ii),' ',filename,sprintf(', ORI=%6.4f LdepthR=%3.0f%%, Ldepth=%5.2fmm',ORIhist,lesiondepthratio*100,lesiondepthmm)])==1);
  txt=repmat(txt,[1,1,size(tmp,3)]);
  tmp(1:size(txt,1),1:size(txt,2),:)=txt;
  
  imHISTO_ORILesion=tmp;
  tmp2=imresize(tmp,[600,900]);
  
   cellROIHist{ii}=tmp2;
  
  HISTROI_ORI=ORIhist;
  HISTROI_lesiondepthratio=lesiondepthratio;
  HISTROI_lesiondepthmm=lesiondepthmm;
   
  if exist(['autoscore_HISTO_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','HISTROI_ORI',...
      'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm','imHISTO_ORILesion');
  else
    save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'-append','HISTROI_ORI',...
      'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm','imHISTO_ORILesion');
  end
 
   
  %clf,imshow(tmp)
%   hold on
%   plot(sub_CartilageBoneInterfaceHIST(:,2),sub_CartilageBoneInterfaceHIST(:,1),'b')
%   
%   plot(sub_realcartsurfHIST(:,2),sub_realcartsurfHIST(:,1),'b')
end
  
cellROIHist2=cell(10,10);
cellROIHist2(1:length(cellROIHist))=cellROIHist(1:length(cellROIHist));
cellROIHist2{99}=zeros(size(cellROIHist{1}));
cellROIHist2{100}=zeros(size(cellROIHist{1}));

imwrite(cell2mat(cellROIHist2'),'Debug_ScoreHist.jpg')


