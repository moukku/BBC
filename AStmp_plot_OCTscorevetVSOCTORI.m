%Plot manual OCT vs OCT ORI

[data] = xlsread('Matching images with scores.xlsx','Data for Matlab','A2:F96');

figure(1)
%plot(round(data(:,1)),data(:,2),'b.')
[ax,p1,p2]=plotyy(round(data(round(data(:,1))<2,1)),data(round(data(:,1))<2,2),round(data(round(data(:,1))>1,1)),data(round(data(:,1))>1,3));
set(p1,'Marker','.','Linestyle','none')
set(p2,'Marker','.','Linestyle','none')
title('OCT vet score vs OCT ORI lesiondepth')
xlabel('OCT Average score of the vets')
ylabel(ax(1),'OCT ORI') % left y-axis
ylabel(ax(2),'OCT Lesion depth ratio') % right y-axis


figure(2)

[ax,p1,p2]=plotyy(round(data(round(data(:,4))<2,4)),data(round(data(:,4))<2,5),round(data(round(data(:,4))>1,4)),data(round(data(:,4))>1,6));
set(p1,'Marker','.','Linestyle','none')
set(p2,'Marker','.','Linestyle','none')
title('HISTO vet score vs HISTO ORI lesiondepth')
xlabel('HISTO Average score of the vets')
ylabel(ax(1),'HISTO ORI') % left y-axis
ylabel(ax(2),'HISTO Lesion depth ratio') % right y-axis

figure(3),clf
is0=round(data(:,1))==0;
is1=round(data(:,1))==1;
is2=round(data(:,1))==2;
is3=round(data(:,1))==3;

p0=plot3(data(is0,3),data(is0,2),round(data(is0,1)),'b.');hold on
p1=plot3(data(is1,3),data(is1,2),round(data(is1,1)),'g.');
p2=plot3(data(is2,3),data(is2,2),round(data(is2,1)),'m.');
p3=plot3(data(is3,3),data(is3,2),round(data(is3,1)),'r.');
xlabel('Lesio depth ratio')
ylabel('ORI (mm)')
zlabel('Manual score')

%% Plot images at the same time

[data] = xlsread('Matching images with scores.xlsx','Data for Matlab','A2:F96');
[~,OCTname]=xlsread('Matching images with scores.xlsx','Scores','AS2:AS96');
[~,Histoname]=xlsread('Matching images with scores.xlsx','Scores','AW2:AW96');
scoreall=xlsread('Matching images with scores.xlsx','Scores','V2:V96');
scoreall=round(scoreall);
scoreallOCT=xlsread('Matching images with scores.xlsx','Scores','AR2:AR96');
scoreallOCT=round(scoreallOCT);

  pathtodata='C:\Users\spvaanan\Unison\work\Autoscore_software\';

  OCTHISTO=cell(length(OCTname),1);
 for ii=1:length(OCTname)
   disp(['ii=',num2str(ii)])
   sOCT=load([pathtodata,'autoscore_debugdata_',OCTname{ii},'.mat'],...
     'OCTImagerotated','idxROI_col','ORI','OCTROI_lesiondepthratio',...
     'OCTROI_lesiondepthmm','sub_cartbone','sub_cartsurf');
    
   sHISTO=load([pathtodata,'autoscore_HISTO_',Histoname{ii},'.mat'],'HISTROI_ORI',...
        'HISTROI_lesiondepthratio','HISTROI_lesiondepthmm',...
        'HistoImage_rot','idxROIHIST_col','sub_CartilageBoneInterfaceHIST',...
        'sub_CartilageSurfaceHIST');
  
   OCT=sOCT.OCTImagerotated(size(sOCT.OCTImagerotated,1)/2+1:end,sOCT.idxROI_col);   
   
   sOCT.sub_cartsurf(:,2)=sOCT.sub_cartsurf(:,2)-find(sOCT.idxROI_col,1)+1;
   sOCT.sub_cartsurf(sOCT.sub_cartsurf(:,2)<1,:)=[];
   sOCT.sub_cartsurf(sOCT.sub_cartsurf(:,2)>size(OCT,2),:)=[];
   
   sOCT.sub_cartbone(:,2)=sOCT.sub_cartbone(:,2)-find(sOCT.idxROI_col,1)+1;
   sOCT.sub_cartbone(sOCT.sub_cartbone(:,2)<1,:)=[];
   sOCT.sub_cartbone(sOCT.sub_cartbone(:,2)>size(OCT,2),:)=[];
   
   mincartsurf=min(sOCT.sub_cartsurf(:,1));
   OCT(1:mincartsurf-80,:)=[];
   
   imshow(OCT),hold on, plot(sOCT.sub_cartsurf(:,2),sOCT.sub_cartsurf(:,1))
   plot(sOCT.sub_cartsurf(:,2),sOCT.sub_cartbone(:,1))
   
   OCT=imresize(OCT,[NaN,500]);
   OCT(501:end,:,:)=[];
   OCT=repmat(OCT,[1,1,3]);

   OCTROI_ORI=sOCT.ORI;
   OCTROI_lesiondepthratio=sOCT.OCTROI_lesiondepthratio;
   OCTROI_lesiondepthmm=scoreallOCT(ii);
   
  txt=double(text2im(['ii=',num2str(ii),' ',OCTname{ii}(1:5),sprintf('\n ORI=%6.4f LdR=%3.0f%%, S=%1.0f',OCTROI_ORI,OCTROI_lesiondepthratio*100,OCTROI_lesiondepthmm)])==0);
  txt=repmat(txt,[1,1,size(OCT,3)]);
  txt=imresize(txt,[NaN,500]);
  OCT(1:size(txt,1),1:size(txt,2),:)=txt;
   
   HISTO=sHISTO.HistoImage_rot(:,sHISTO.idxROIHIST_col,:);
   tmp=HISTO(1:50,:,:);
   tmp(repmat(sum(tmp,3)<0.05,[1,1,3]))=NaN; 
   coltmp=squeeze(nanmean(nanmean(tmp,1),2));
   mask=sum(HISTO,3)<0.05;
   tmp1=HISTO(:,:,1);tmp1(mask)=coltmp(1);HISTO(:,:,1)=tmp1;
   tmp1=HISTO(:,:,2);tmp1(mask)=coltmp(2);HISTO(:,:,2)=tmp1;
   tmp1=HISTO(:,:,3);tmp1(mask)=coltmp(3);HISTO(:,:,3)=tmp1;

   sHISTO.sub_CartilageSurfaceHIST(:,2)=sHISTO.sub_CartilageSurfaceHIST(:,2)-find(sHISTO.idxROIHIST_col,1)+1;
   sHISTO.sub_CartilageSurfaceHIST(sHISTO.sub_CartilageSurfaceHIST(:,2)<1,:)=[];
   sHISTO.sub_CartilageSurfaceHIST(sHISTO.sub_CartilageSurfaceHIST(:,2)>size(HISTO,2),:)=[];
   
   sHISTO.sub_CartilageBoneInterfaceHIST(:,2)=sHISTO.sub_CartilageBoneInterfaceHIST(:,2)-find(sHISTO.idxROIHIST_col,1)+1;
   sHISTO.sub_CartilageBoneInterfaceHIST(sHISTO.sub_CartilageBoneInterfaceHIST(:,2)<1,:)=[];
   sHISTO.sub_CartilageBoneInterfaceHIST(sHISTO.sub_CartilageBoneInterfaceHIST(:,2)>size(HISTO,2),:)=[];
   
   mincartsurf=min(sHISTO.sub_CartilageSurfaceHIST(:,1));
   HISTO(1:mincartsurf-80,:,:)=[];
   
   HISTO=imresize(HISTO,[NaN,500]);
   HISTO(501:end,:,:)=[];

   OCTROI_ORI=sHISTO.HISTROI_ORI;
   OCTROI_lesiondepthratio=sHISTO.HISTROI_lesiondepthratio;
   OCTROI_lesiondepthmm=scoreall(ii);
   
   txt=double(text2im(['ii=',num2str(ii),' ',Histoname{ii}(1:5),sprintf(', ORI=%6.4f LdR=%3.0f%%, S=%1.0f',OCTROI_ORI,OCTROI_lesiondepthratio*100,OCTROI_lesiondepthmm)])==0);
   txt=repmat(txt,[1,1,size(HISTO,3)]);
   txt=imresize(txt,[NaN,500]);

  HISTO(1:size(txt,1),1:size(txt,2),:)=txt;

 
   
   OCTHISTO{ii,1}=OCT;
   OCTHISTO{ii,2}=HISTO;
      
   
 end

 for ii=1:numel(OCTHISTO)
   if size(OCTHISTO{ii},1)~=700
     OCTHISTO{ii}=[OCTHISTO{ii};zeros(700-size(OCTHISTO{ii},1),size(OCTHISTO{ii},2),3)];
   end
 end
imwrite(imresize(cell2mat(OCTHISTO),0.7),'OCT_vs_HISTOscoring.jpg')
  
  

