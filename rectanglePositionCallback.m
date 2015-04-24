function position2=rectanglePositionCallback( position,width )
%rectanglePositionCallback - this is called always when position of the rectangle changes
%   Detailed explanation goes here

%Check if width of rectangle is changed. If yes, ask user not to change it
%and set its width to default.


if position(3)~=width
    warndlg('Please do not change width of the rectangle');
    
    position2=position;
    position2(3)=width;
    
else
    position2=position;
end

  %check also that the rectangle height is not too big
if position(4)>width*4

    h = warndlg('Height of the rectangle is too big');
  
    position2(4)=width*4;
    
end

wait(1)

end

