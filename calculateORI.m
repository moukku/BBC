function [ ORI,ResultImage,idxcroprow,filteredsurface ] = calculateORI(OCTImagerotated,sub_cartsurf,pixelspermm,varargin)
%calculateORI - Calculates optical roughness index
%  ORI=calculateORI(OCTImagerotated,sub_cartsurf,pixelspermm);
%
%  function takes as input
%
%  OCTImagerotated: OCT image of cartilage, where cartilage has been 
%  aligned horizontally, 
%  sub_cartsurf: subscribes of the cartilage surface,
%  pixelspermm: how many pixels are in one millimeter
%
%
%  Function return optical roughness index, i.e., ORI.
%
%
%  [ ORI, ResultImage ] = calculateORI(...) returns image for debugging.
%
%  calculateORI(OCTImagerotated,sub_cartsurf,pixelspermm,[cutoff1,cutoff2])
%  allows to define cutoffs of the butterworth filtering of the surface. If
%  only cutoff1 is given the cutoff of high-pass filtering is defined.
%  vector with two elements defines band-pass cutoffs. Default is 0.05

%Sami Vaananen
%2015-2-16

  
  IIrot=OCTImagerotated;
  %pixelspermm=(catheder_radius*2/catheder_diameter_mm);
  
  %imshow(IIrot)
  %hold on
  %plot(sub_cartsurf(:,2),sub_cartsurf(:,1),'-r')
  
  yy=sub_cartsurf(:,1);
  xx=sub_cartsurf(:,2);
  %Scale xx and yy to millimeters
  minxx=min(xx);
  xx=xx-minxx;
  xx=xx/pixelspermm;
  
  yy=yy/pixelspermm;
  
  if nargin==3
  %Highpass with 3rd order butter with cut-off frequency 0.05/1mm
  [B,A] = butter(3,0.05/(length(xx)/pixelspermm),'high');
  elseif numel(varargin{1})==1
    cutoff1=varargin{1};
    [B,A] = butter(3,cutoff1/(length(xx)/pixelspermm),'high');
  elseif numel(varargin{1})==2
    cutoff1=varargin{1}(1);
    cutoff2=varargin{1}(2);
    [B,A] = butter(3,[cutoff1,cutoff2]./(length(xx)./pixelspermm),'bandpass');
  else
    error('Cut-off frequencies are not correct format')
  end
  
  yyhighfreq=filtfilt(B,A,yy);
  
  meanyyhighfreq=mean(yyhighfreq);
  
  ORI=sqrt(sum((yyhighfreq-meanyyhighfreq).^2)/length(yyhighfreq));
  
  %If asked generate result image
  if nargout>1
  yylowfreq=yy-yyhighfreq;
  yylowfreq(yylowfreq<1)=1;
  
  % Plot cartilage surface, low frequency part and above surface high
  % frequency part from where ORI is calculated
  red=IIrot;
  green=IIrot;
  blue=IIrot;
  
  sz=size(IIrot);
 
  
  red(sub2ind(sz,round(yy*pixelspermm),round(xx*pixelspermm+minxx)))=1;
  red(sub2ind(sz,round(yy*pixelspermm+1),round(xx*pixelspermm+minxx)))=1;

  green(sub2ind(sz,round(yy*pixelspermm),round(xx*pixelspermm+minxx)))=0;
  green(sub2ind(sz,round(yy*pixelspermm+1),round(xx*pixelspermm+minxx)))=0;

  idx=min([round(yylowfreq*pixelspermm),repmat(sz(1),length(yylowfreq),1)-1],[],2);
  green(sub2ind(sz,idx,round(xx*pixelspermm+minxx)))=1;
  green(sub2ind(sz,idx+1,round(xx*pixelspermm+minxx)))=1;

  
  minmaxyy=round(minmax(yy(:,1)'*pixelspermm));
  yyhighfreqshift=yyhighfreq*pixelspermm+minmaxyy(1) +min(yyhighfreq*pixelspermm);
  
  %If this do not fit into image move it down
  if sum(yyhighfreqshift<1)
    yyhighfreqshift=yyhighfreqshift+abs(min(yyhighfreqshift))+1;
  end
  
  green(sub2ind(sz,round(yyhighfreqshift),round(xx*pixelspermm+minxx)))=1;
  green(sub2ind(sz,round(yyhighfreqshift+1),round(xx*pixelspermm+minxx)))=1;
  
  blue(sub2ind(sz,round(yyhighfreqshift),round(xx*pixelspermm+minxx)))=1;
  blue(sub2ind(sz,round(yyhighfreqshift+1),round(xx*pixelspermm+minxx)))=1;
  
  red(sub2ind(sz,round(yyhighfreqshift),round(xx*pixelspermm+minxx)))=0;
  red(sub2ind(sz,round(yyhighfreqshift+1),round(xx*pixelspermm+minxx)))=0;
  
  tmp=cat(3,red,green,blue);
  
  
  tmp(round(minmaxyy(2)+0.14*pixelspermm):end,:,:)=[];


  tmp(1:round(min(yyhighfreqshift)-20),:,:)=[];

  idxcroprow=true(size(IIrot,1),1);
  idxcroprow(round(minmaxyy(2)+0.14*pixelspermm):end,:,:)=0;
  idxcroprow(1:round(min(yyhighfreqshift)-20),:,:)=0;
  
  ResultImage=tmp;
  end
  
  if nargout > 3
    
    filteredsurface=[yyhighfreqshift,xx*pixelspermm+minxx];

  end
  
end

