function [ ORIdiff ] = cost_ORIcutoff2(cutoff2, HistoORIs,OCTORIfit )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here



  N_im=length(HistoORIs);
  ORI=zeros(N_im,1);
  cutoff1=0.05;
  %cutoff2=0.5;
  
 

  
  ORIhisto=HistoORIs;
  for ii=1:N_im
   if cutoff2/(length(OCTORIfit(ii).sub_cartsurf)/OCTORIfit(ii).pixelspermm)>0.99 || cutoff2<cutoff1
    ORI=Inf;
   else  
    [ORI(ii),ResultImage,idxrow_ROIORI]=calculateORI(...
      OCTORIfit(ii).IIrotCrop,OCTORIfit(ii).sub_cartsurf,OCTORIfit(ii).pixelspermm,[cutoff1,cutoff2]);
   end
  end
  
  ORIdiff=mean(abs(ORI-ORIhisto));

end

