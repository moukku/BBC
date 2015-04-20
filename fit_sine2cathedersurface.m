function [ cost ] = fit_sine2cathedersurface( x,y,p )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

  dif=((y - (p(1)*sin(x/max(x)*2*pi+p(2)))+p(3)).^2);
  
  %Check which of the values are the worst and use only xx% for final
  %evaluation
  [tmp,idx_bestcases]=sort(dif);
  
  remove=tmp(round(length(dif)-0.3*length(dif)):end);
  idx_keep=idx_bestcases(1:round(length(dif)-0.3*length(dif)));
  
  cost=sum((y(idx_keep) - (p(1)*sin(x(idx_keep)/max(x(idx_keep))*2*pi+p(2)))+p(3)).^2);
  
end

