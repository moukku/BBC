function [Position, BWimage] = pickCartilage(Image)
                 
                level = graythresh(Image);
                Image = im2bw(Image,level);
                
                %Get image Dimensions
                [width, ~] = size(Image);
                
                %Remove small objects from image
                Image = bwareaopen(Image, round(width * 0.2));
                
                %Fill holes from image
                Image = imfill(Image, 'holes');
                
                [x y] = ginput(1);
                
                %Select the cartilage
                BWimage = bwselect(Image, x, y);
                Position = [x,y];
end