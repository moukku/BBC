% Optimize ORI between OCT and HISTO

%edit calculateORI.m

  pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';

catheder_diameter_mm=0.9;



%% Check for which images both ORI and HISTO are  defined 0
[~,OCTname]=xlsread('Matching images with scores.xlsx','Scores','AS2:AS96');
[~,Histonametmp]=xlsread('Matching images with scores.xlsx','Scores','AW2:AW96');
scoreallHISTO=xlsread('Matching images with scores.xlsx','Scores','V2:V96');
scoreallHISTO=(scoreallHISTO);
scoreallOCT=xlsread('Matching images with scores.xlsx','Scores','AR2:AR96');
scoreallOCT=(scoreallOCT);

pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';


%% Write meanscores to matfiles
if 0
for ii=1:length(OCTname)
  filename=OCTname{ii};
  vetscore_OCTmean=scoreallOCT(ii);
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','vetscore_OCTmean');
  else
    save([pathtodata,'autoscore_debugdata_',filename,'.mat'],'-append','vetscore_OCTmean');
  end
end


for ii=1:length(Histonametmp)
  filename=Histonametmp{ii};
  vetscore_Histomean=scoreallHISTO(ii);
  if exist(['autoscore_HISTO_',filename,'.mat'],'file')
    save(['autoscore_debugdata_',filename,'.mat'],'-append','vetscore_Histomean');
  else
    save([pathtodata,'autoscore_HISTO_',filename,'.mat'],'-append','vetscore_Histomean');
  end
end
end

%% Plot OCT HISTO images together
im=cell(length(OCTname),2);
im2=cell(length(OCTname),1);
for ii=1:length(OCTname)
  filename=OCTname{ii};
  vetscore_OCTmean=scoreallOCT(ii);
  if exist(['autoscore_debugdata_',filename,'.mat'],'file')
    sOCT=load(['autoscore_debugdata_',filename,'.mat'],'vetscore_OCTmean','imOCT_ORILesioncrop','OCTROI_ORI',...
      'OCTROI_lesiondepthratio');
  else
    sOCT=load([pathtodata,'autoscore_debugdata_',filename,'.mat'],'vetscore_OCTmean','imOCT_ORILesioncrop','OCTROI_ORI',...
      'OCTROI_lesiondepthratio');
  end
  filename=Histonametmp{ii};
  if exist(['autoscore_HISTO_',filename,'.mat'],'file')
    sHISTO=load(['autoscore_debugdata_',filename,'.mat'],'vetscore_Histomean','imHISTO_ORILesion','HISTROI_ORI',...
      'HISTROI_lesiondepthratio');
  else
    sHISTO=load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'vetscore_Histomean','imHISTO_ORILesion','HISTROI_ORI',...
      'HISTROI_lesiondepthratio');
  end
  
  
  im{ii,1}=imresize(sOCT.imOCT_ORILesioncrop,[NaN,700]);
  im{ii,2}=imresize(sHISTO.imHISTO_ORILesion,[NaN,700]);
  szOCT=size(im{ii,1});
  szHISTO=size(im{ii,2});
  
  if szOCT(1)~=szHISTO(1)
    szs1=[szOCT(1),szHISTO(1)];
    [~,idx]=min(szs1);
    im{ii,idx}=[im{ii,idx};zeros([abs(diff(szs1)),700,3],'double')];
  end
  
  tmp=cell2mat(im(ii,:));
  txt1=double(text2im([num2str(ii),' ',sprintf('%3.1f %5.2fum %3.0f%%',sOCT.vetscore_OCTmean,sOCT.OCTROI_ORI*1000,sOCT.OCTROI_lesiondepthratio*100)])==0);
  txt2=double(text2im([num2str(ii),' ',sprintf('%3.1f %5.2fum %3.0f%%',sHISTO.vetscore_Histomean,sHISTO.HISTROI_ORI*1000,sHISTO.HISTROI_lesiondepthratio*100)])==0);
  txt=[txt1;txt2];
  txt=repmat(txt,[1,1,size(tmp,3)]);
  tmp(end-size(txt,1)+1:end,1:size(txt,2),:)=txt;
  im2{ii}=tmp;
end



imwrite(cell2mat(im2),'Debug_Corresponding_OCT_Histo.jpg')

%%


idxOCTORI0 = scoreallOCT==0;
idxHISTOORI0 = scoreallHISTO==0;
idxbothORI0=sum([idxOCTORI0,idxHISTOORI0],2)==2;  


OCTname=OCTname(idxbothORI0);
Histoname=Histonametmp(idxbothORI0);
N_im=length(OCTname);

idxhisto1=find(scoreallHISTO==1);



%% Read Histo ORIs.

HistoORIs=zeros(N_im,1);

sHISTO=struct;
for ii=1:N_im
  [~,filename]=fileparts(Histoname{ii});
s = load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HISTROI_ORI',...
      'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm','sub_CartilageSurfaceHIST',...
      'length100umHIST','HistoImage_rot');
    HistoORIs(ii)=s.HISTROI_ORI;
    s.pixelspermm=s.length100umHIST*10;  
    if ~length(fieldnames(sHISTO))
      sHISTO=s;    
    else
      sHISTO(ii)=s;    
    end
end
  

sHISTOscore1=struct;
for ii=1:length(idxhisto1)
  [~,filename]=fileparts(Histonametmp{idxhisto1(ii)});
s = load([pathtodata,'autoscore_HISTO_',filename,'.mat'],'HISTROI_ORI',...
      'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm','sub_CartilageSurfaceHIST',...
      'length100umHIST','HistoImage_rot');
    s.pixelspermm=s.length100umHIST*10;  
    if ~length(fieldnames(sHISTOscore1))
      sHISTOscore1=s;    
    else
      sHISTOscore1(ii)=s;    
    end
end


%% Score OCT ROIs

% OMAAN FUNKTIOON
% 3)	 Tee optimointialgoritmille cost_function (suomeksi kohdefunktio)
%    a.	Anna optimoitavana muuttujana kynnys2
%    b.	Anna muina muuttujina kynnys1, OCT_rustonpinta_12 ja HISTO_ORI12 
%    c.	Kaistanpäästösuodata OCT_rustonpinta_12 kynnyksien 1 ja 2 avulla -> OCT_rustonpinta_12suodatettu. Pitää tehdä siis loopissa jos sinulla on 12 pintaa yhdessä cellissä tai structissa tai mikä tuo muuttuja sinulla onkin.
%    d.	Laske ORI kullekin pinnalle OCT_rustonpinta_12suodatettu -> OCT_ORI12. Taas loopissa
%    e.	Palautettava cost = mean(OCT_ORI12) – mean(histo_ORI12)
%       i.	Voisi ehkä olla myös cost = mean(OCT_ORI12 –histo_ORI12), mutta en ole ihan varma kumpi parempi. Voit Testata
% 4)	Anna fminsearchille handle tuohon funktioon ja alkuarvaus kynnyksestä 2. Esim 2*kynnys1? Saattaa haluta muitakin parametrejä, mutta ulkoa en nyt muista


cellROIs=cell(1,N_im);
OCTORIfit=struct();
for ii = 1:N_im
  disp(['ii = ',num2str(ii),' Score ROI ',OCTname{ii}])
  [~,filename]=fileparts(OCTname{ii});
  
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
  
  OCTORIfit(ii).IIrotCrop=IIrotCrop;
  OCTORIfit(ii).sub_cartsurf=sub_cartsurf;
  OCTORIfit(ii).pixelspermm=pixelspermm;
  
end

%   ORI=zeros(N_im,1);
%   cutoff1=0.05;
%   cutoff2=0.5;
%   ORIhisto=HistoORIs;
%   for ii=1:N_im
%     [ORI(ii),ResultImage,idxrow_ROIORI]=calculateORI(...
%       OCTORIfit(ii).IIrotCrop,OCTORIfit(ii).sub_cartsurf,OCTORIfit(ii).pixelspermm,[cutoff1,cutoff2]);
%     
%     ORIdiff=mean(abs(ORI-ORIhisto));
%     
%   end
opt=optimset('Display','iter');
 [opt_cutoff2,fval]= fminsearch(@(x) cost_ORIcutoff2(x,HistoORIs,OCTORIfit),0.7,opt);

 
% Save cutoff frequenzy2 to general data
cutoff1=0.05;
cutoff2=opt_cutoff2;
if exist('autoscore_debugdata_generaldata.mat','file')
  save('autoscore_debugdata_generaldata.mat','-append','cutoff1','cutoff2');
else
 error('Mat-file for general data should exist') 
end
 
 %% Check how the surfaces look:
 
 %Filtered surface
 for ii=1:N_im
   
     [OCTORIco2(ii),~,~,filteredsurface]=calculateORI(...
      OCTORIfit(ii).IIrotCrop,OCTORIfit(ii).sub_cartsurf,OCTORIfit(ii).pixelspermm,[cutoff1,cutoff2]);

     [OCTORIco1(ii),~,~,filteredsurfacecutoff1]=calculateORI(...
      OCTORIfit(ii).IIrotCrop,OCTORIfit(ii).sub_cartsurf,OCTORIfit(ii).pixelspermm,[cutoff1]);

     [HISTOORIco1(ii),~,~,HISTOfilteredsurfacecutoff1]=calculateORI(...
      sHISTO(ii).HistoImage_rot,sHISTO(ii).sub_CartilageSurfaceHIST,sHISTO(ii).pixelspermm,[cutoff1]);
    
    
    
   OCTORIfit(ii).filteredsurface=filteredsurface;
   OCTORIfit(ii).filteredsurfacecutoof1=filteredsurfacecutoff1;
   sHISTO(ii).HISTOfilteredsurfacecutoff1=HISTOfilteredsurfacecutoff1;
 end
 
 sprintf('%7.5f,%7.5f,%7.5f\n', [OCTORIco1',OCTORIco2',HISTOORIco1']')
 
 
 %Plot original and filtered surface
 
 for ii=1:N_im

   clf
   plot(linspace(0,1,length(OCTORIfit(ii).filteredsurfacecutoof1(:,2))),OCTORIfit(ii).filteredsurfacecutoof1(:,1)/OCTORIfit(ii).pixelspermm,'-')
   hold on
   plot(linspace(0,1,length(OCTORIfit(ii).filteredsurface(:,2))),OCTORIfit(ii).filteredsurface(:,1)/OCTORIfit(ii).pixelspermm,'-r')

   plot(linspace(0,1,length(sHISTO(ii).HISTOfilteredsurfacecutoff1(:,2))),sHISTO(ii).HISTOfilteredsurfacecutoff1(:,1)/sHISTO(ii).pixelspermm,'-g')
   
   
   pause(2)
 end 
 
 
 
 
