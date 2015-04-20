function [lesiondepthratio,lesiondepthmm,rowcol_lesion,BWcart,sub_cartsurf_smoothed,sub_lesion]=calculateLesionDepth(IIrotCrop,sub_cartsurf,sub_cartbone,catheder_radius,catheder_diameter_mm)
%calculateLesionDepth - Calculates the depth of the lesion
%  [lesiondepthratio,lesiondepthmm,col_lesio,BWcart,sub_cartsurf_smoothed,sub_lesion]=calculateLesionDepth(IIrotCrop,sub_cartsurf,sub_cartbone,catheder_radius,catheder_diameter_mm)
%  Function calculates the depth of the lesion in OCT or Histology image
%  
%  Input:
%  IIrotCrop - image of the cartilage. It is assumed image is cropped
%  beforehand.
%  sub_cartsurf - subscripts of the cartilage surface. For each column
%  in the image, there should be one [row,column] pair describing where the
%  surface is located
%  sub_cartbone - subscripts of the cartilabe-bone interface.
%  catheder_radius - Radius of the catheder in pixels
%  catheder_diameter_mm- Diameter of the catheder in millimeters
%
%  Output:
%  lesiondepthratio - Ratio how deep the lesion penetrates. 0 no lesion, 1
%  Lesion penetrates bone
%  lesiondepthmm - Depth of the lesion in millimeters
%  rowcol_lesios - index of the row and column where lesion is located.
%  BWcart - binary mask of the cartilage used during calculation
%  sub_cartsurf_smoothed - subscripts of smoothed cartilage surface (for debugging)
%  sub_lesion - subscripts of layer where lesion is found (for debugging)


%Made by Sami Vaananen
%2015-02-20


  
  pixelspermm=(catheder_radius*2/catheder_diameter_mm);
  
  
  %Smooth cartilage surface in order to find intact surface
  
  [B,A] = butter(3,0.05/(length(sub_cartsurf)/pixelspermm),'low');
  
  sub_cartsurf_smoothed=sub_cartsurf;
  sub_cartsurf_smoothed(:,1)=round(filtfilt(B,A,sub_cartsurf(:,1)));
  sub_cartsurf_smoothed(sub_cartsurf_smoothed<1)=1;
  
  %Segment lesions 
  BWIIrot=im2bw(IIrotCrop,0.13);%0.17
  
  %imshow(BWIIrot)
  
  %Pick only cartilage
  cc=bwconncomp(BWIIrot);
  stats = regionprops(cc,'Area');
  maxarea=[stats.Area]==max([stats.Area]);
  BWIIrot2=false(size(BWIIrot));
  BWIIrot2(cc.PixelIdxList{maxarea})=true;
  
  %imshow(BWIIrot2)
  
  %Fill small holes
  se=strel('arbitrary',true(5,5));
  BWIIrot3=imclose(BWIIrot2,se);
  
  
  %Pick only the region between cartilage surfaces 
  BWIIrot4=false(size(BWIIrot3));
  
  for kk=1:length(sub_cartsurf_smoothed)
    BWIIrot4(sub_cartsurf_smoothed(kk,1):sub_cartbone(kk,1),sub_cartsurf_smoothed(kk,2))=true;
  end
  
  BWIIrot4=BWIIrot4&BWIIrot3;
  %imshow(BWIIrot4)
  
  %If there is large holes inside cartilage, Include them as lesion
  %Fill vertical boundaries of the image
  BWIIrot4(:,[1,end])=1;
  BWIIrot4(1,:)=0;
  
  
  BWHolesfill=imfill(BWIIrot4,'holes');
  BWHoles=BWHolesfill&~BWIIrot4;
  %imshow(BWHoles)
  CC = bwconncomp(BWHoles);
  regprop=regionprops(CC,'Area','centroid');
  areas=[regprop.Area];
  %Include big areas, area threshold is dependent on the depth of the hole.
  %In deeper cartilage region must be bigger
  for kk=1:length(areas)
    c=round(regprop(kk).Centroid(1));
    r=round(regprop(kk).Centroid(2));
    b=sub_cartbone(find(sub_cartbone(:,2)==c,1),1);
    u=sub_cartsurf_smoothed(find(sub_cartsurf_smoothed(:,2)==c,1),1);
    depthratio=(r-u)/(b-u);
    
    if areas(kk)>50+depthratio*500
      [idx_i,idx_j]=ind2sub(size(BWHoles),CC.PixelIdxList{kk});
      [C,ia,ic] = unique(idx_j) ;

      sub_hole=[idx_i(ia),idx_j(ia)];
      BWIIrot4(CC.PixelIdxList{kk})=0;
      for ll=1:size(sub_hole,1);
        BWIIrot4(1:sub_hole(ll,1),sub_hole(ll,2))=0;
      end
    end
  end
  
  
  BWlesion=bwselect(~BWIIrot4,round(size(BWIIrot4,2)/2),2,8);
  
  %imshow(BWlesion)
  
  %Find subscript of the cartilage lesion location
  [row_lesion,col_lesion]=find(flipud(BWlesion));

   %Only one value on each column, i.e., calculate subscripts of the layer
   [C,ia,ic] = unique(col_lesion) ;

   sub_lesion=[row_lesion(ia),col_lesion(ia)];
  
   sub_lesion(:,1)=size(BWlesion,1)-sub_lesion(:,1)+1;
   
     
  
  %Calculate lesion depth for each column of the image
  Lesion_depthratio=zeros(length(sub_lesion),1);
  Lesion_thickness=zeros(length(sub_lesion),1);
  for kk=1:length(sub_lesion)
    
    c=sub_lesion(kk,2);
    Cthick=sub_cartbone(sub_cartbone(:,2)==c,1)-sub_cartsurf_smoothed(sub_cartsurf_smoothed(:,2)==c,1);
    
    Lthick=sub_cartbone(sub_cartbone(:,2)==c,1)-sub_lesion(kk,1);
    Lthick(Lthick<0)=0;

    Lesion_depthratio(kk)=1-Lthick/Cthick;
    
    Lesion_thickness(kk)=(sub_lesion(kk,1)-sub_cartsurf_smoothed(sub_cartsurf_smoothed(:,2)==c,1))/pixelspermm;
  end
  
  Lesion_depthratio(Lesion_depthratio<0)=0;
  Lesion_thickness(Lesion_thickness<0)=0;
  
  maxLesiodepthratio=max(Lesion_depthratio);
  idx_lesiodepth=find(Lesion_depthratio==maxLesiodepthratio,1);
  maxLesion_thickness=Lesion_thickness(idx_lesiodepth); 
  
  
  lesiondepthratio=maxLesiodepthratio;
  lesiondepthmm=maxLesion_thickness;
  rowcol_lesion=sub_lesion(idx_lesiodepth,:);
  BWcart=BWIIrot3;
  
  