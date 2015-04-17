%##########################################################################
%#-----------------------------ImageProcessing----------------------------#
%# AUTHOR: MIKKO PITKÄNEN                                                 #
%# VERSION: 0.78                                                          #
%# UNIVERSITY OF EASTERN FINLAND                                          #
%# MODIFIED: 09.10.2013                                                   #
%#                                                                        #
%#                                                                        #
%#---------------------------------PURPOSE--------------------------------#
%#                                                                        #
%# This class handels all the imageprocessing necessary in order to make  #
%# a reliable diagnosis of the selected cartilage tissue.                 #
%#                                                                        #
%#                                                                        #
%#--------------------------------VARIABLES-------------------------------#
%#    ImageProcessing Properties:                                         #
%#    Image                    -Houses the image.                         #
%#    cDepth                   -Mean cartilage depth.                     #
%#    cDepthY                  -Mean cartilage depths y coordinate        #
%#    cAllDepths               -All measured cartilage depths             #
%#    cAngle                   -Cartilage angle.                          #
%#    cLength                  -Cartilage lenght.                         #
%#    oLenght                  -Optimum length.                           #
%#    Scale                    -Image scale(catheter radius).             #
%#    x                        -Image width.                              #
%#    y                        -Image height.                             #
%#    UriValue                 -ultrasound rougnhes index.                #
%#    Diagnosis                -Cartilage rating                          #
%#    OriginalImage            -Original image                            #
%#    filename                 -Image name which is used when a new       #
%#                              folder is created.(All data is stored     #
%#                              there                                     #
%#    ii                       -Iteration number                          #
%#    limit                    -largest y coordinate of the smallest      #
%#                              decim of the upper cartilage edge         #
%#    croppedImage             -Original image cropped                    #
%#    position                 -User selected area of interest coordinates#
%#                                                                        #
%##########################################################################


classdef testImageProcessingTytti < handle

    properties(GetAccess = 'private', SetAccess = 'private')
    Image;
    OriginalImage;
    cAllDepths;
    cDepth;
    cDepthY;
    cDepthX;
    cAngle;
    cLength;
    oLenght;
    Scale;
    x;
    y;
    UriValue;
    Diagnosis;
    VisualisizedDepth;
    ii;
    filename;
    limit;
    croppedImage;
    position;
    end%Properties
    
    methods
       
        
%#---------------------------------------------------------ImageProcessing#        
        

                
        function f = testImageProcessingTytti(cImage)
   
            %Check if the variables actually exist.
            if(exist('cImage','var'))

                %Remove catheter from image
                findCatheder;
                
                %Scale represents the catheter diameter
                %Catheter is 0.9mm wide so i'm scaling it to 1mm
                %Set the class variables
                
            else
                error('The chosen Image is not supported');
            end
       
        
%#------------------------------------------------------------findCatheder#  
        
       function findCatheder()
        %findCatheder Finds catheder in OCT image and calculates its mask
        %and radius
        %
        %  findCatheder(OCTImage,threshold)
        %  Set thresholding value for finding catheder.
        %  Default value is 0.21 but it may work in all images
        %
        % Made By Sami Vaananen
        % 2015-02-09

          OCTImage = cImage;
          [Nrows,Ncols]=size(OCTImage);
          middle_row=round(Nrows/2);
          middle_col=round(Ncols/2);

          threshold=0.21;

          %Threshold OCT image. 
          BW=OCTImage>threshold;%imshow(BW)

          %Do initial image closing
          se=strel('arbitrary',true(5,5));
          BW=imclose(BW,se); %imshow(BW)

          %Fill holes
          BW2 = imfill(BW,'holes');%imshow(BW2)

          %Pick object which covers the center pixel
          BW2=bwselect(BW2, middle_col, middle_row);

          %Do image closing and hole filling for the center object with a 
          %bigger mask
          se = strel('disk',3,0);
          BW2=imclose(BW2,se); %imshow(BW)

          BW2 = imfill(BW2,'holes');%imshow(BW2)


          catheder_BWmask = BW2;
          %imshow(BWcatheder)


          %Calculate catheder's major and minor axes, equivalen
          %diameter and centroid
          Stats = regionprops(catheder_BWmask,'Area','EquivDiameter'...
              ,'MajorAxisLength','MinorAxisLength','Centroid');


          %If EquivDiameter is over 5% smaller than MajorAxisLength there
          %is most likely something wrong in the segmentation of the
          %catheder.Try to correct this by eroding image until the
          %criterion is satisfied and dilate image back. This corrects
          %image in most cases. If it does not work, give up before size
          %of the object gets very small. Check what EquivDiameter
          %means from Matlab's documentation.
          circleratio=Stats.EquivDiameter/Stats.MajorAxisLength;
          if circleratio<0.95

            %Do eroding until image has two separate objects
            se=strel('arbitrary',true(3,3));

            tmp=catheder_BWmask;
            jj=0;
            while circleratio<0.95
              jj=jj+1;

              tmp=imerode(tmp,se);

              tmp = bwselect(tmp, middle_col, middle_row);

              Stats2 = regionprops(tmp,'Area','EquivDiameter',...
                  'MajorAxisLength','MinorAxisLength','Centroid');

              if Stats2.Area<5000
                warning('Area gets too small. Stop now')
                break
              end
              circleratio=Stats2.EquivDiameter/Stats2.MajorAxisLength;

            end

            %Grow mask back to initial size before shrinking
            for kk=1:jj
              tmp=imdilate(tmp,se);
            end

            catheder_BWmask=tmp;

            Stats = regionprops(catheder_BWmask,'Area','EquivDiameter',...
                'MajorAxisLength','MinorAxisLength','Centroid');


            %Try to separate catheder from overlapping object
            %[centers, radii, metric] = imfindcircles(,...
            %round(size(OCTImage,1)*0.0469*0.9));


            %error('EquivDiameter/MajorAxisLength<0.95,...
            %There is something wrong in the segmentation of catheder')
          end


          catheder_radius=Stats.EquivDiameter/2;
          catheder_centroid=Stats.Centroid;
         

          %Dilate catheder mask to make sure that it covers whole catheder
          se=strel('arbitrary',true(5,5));
          catheder_BWmask=imdilate(catheder_BWmask,se);
          cImage(catheder_BWmask) = .0;
          setOriginalImage(f, cImage);
          f.setScale(catheder_radius);

       end
  end%/ImageProcessing
        
        
%-------------------------------------------------------------EnhanceImage#

        
        function [BWcartbone, BWcartsurf, BWcartsurf_smooth, BWmiddlecart]...
                = EnhanceImage(obj, OCTImagerotated)
        %Arguments:         -Instance
        %Returns:           -Enhanced Image
        %Summary:
        %This function enhances the edge between the cartilage and the bone
%                 cImage = obj.getOriginalImage();
%                 lighter = cImage>0.2;
%                 darker = cImage< 0.2;
%                 
%                 for(ji = 0.5:1:0.02)
%                     for(jj = 0.4:ji:0.1)
%                     lighter= lighter + cImage> jj;
%                     lighter = lighter .*2;
%                     end
%                 end
%                 
%                 for(ji = 0.4:0:-0.02)
%                     for(jj = 0.4:ji:-0.1)
%                     darker = darker + cImage < jj;
%                     darker = darker .*2;
%                     end
%                 end
% 
%                 cImage = cImage - ~(~darker + lighter);
%                 cImage = cImage .*2;
%                 cImage(cImage < 0.3) = .0;
%                 [x y] = size(cImage);
%                 
%                 %Remove objects that are smaller than 5% of the image size
%                 %from the image
%                 
%                 level = graythresh(cImage);
%                 cImage = im2bw(cImage,level);
%                 
%                 cImage = bwareaopen(cImage, round(x*y*0.01));
%                 cImage = imfill(cImage, 'holes');
%                 
%                 Image = cImage;
%                 

        %SAMIS SEGMENTATION CODE
          %Images for plotting 
  %Size of second half of the image
  
  catheder_radius = obj.getScale();
  [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed]=...
    obj.segmentCartilageSurfaces(OCTImagerotated,catheder_radius);
  
  [Nrows,Ncols]=size(OCTImagerotated);
  IIrot=OCTImagerotated(Nrows/2+1:end,:);

  
   BWcartbone=false([Nrows/2,Ncols]);
   BWcartbone(sub2ind([Nrows/2,Ncols],sub_cartbone(:,1),sub_cartbone(:,2)))=true;

   BWcartsurf=false([Nrows/2,Ncols]);
   BWcartsurf(sub2ind([Nrows/2,Ncols],sub_cartsurf(:,1),sub_cartsurf(:,2)))=true;

   BWcartsurf_smooth=false([Nrows/2,Ncols]);
   BWcartsurf_smooth(sub2ind([Nrows/2,Ncols],sub_cartsurf_smoothed(:,1),sub_cartsurf_smoothed(:,2)))=true;

   BWmiddlecart=false([Nrows/2,Ncols]);
   BWmiddlecart(sub2ind([Nrows/2,Ncols],sub_middlecart(:,1),sub_middlecart(:,2)))=true;
        

        end%/EnhanceImage
        
   function [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed] = segmentCartilageSurfaces(obj, OCTImagerotated, catheder_radius)
        %segmentCartilageSurfaces - Segments the cartilage surface, meanlayer and cartilage-bone interface
        %  [sub_cartsurf,sub_middlecart,sub_cartbone,sub_cartsurf_smoothed,meancartthick]=...
        %    segmentCartilageSurfaces(OCTImagerotated,catheder_radius);
        %  Function gets as input OCT image of cartilage, where cartilage is
        %  aligned horizontally before hand. Second input is the radius of the OCT
        %  catheder, which diameter is known.
        %
        %  As output, the function returns substricts of the cartilage surfaces. In
        %  substricts there is one row value for each column where cartilage
        %  exists.
        %    sub_cartsurf - defines the surface of the cartilage
        %    sub_middlecart - defines layer at the middle of the cartilage
        %    sub_cartbone - defines the cartilage-bone interface in the OCT image
        %    sub_cartsurf_smoothed - defines cartilage surface where the line has
        %    been smoothed. This can be used to define where the intact cartilage
        %    surface had been
        %    meancartthick - defines the average thickness of the cartilage
        %

        [Nrows,Ncols]=size(OCTImagerotated);
        middle_row=round(Nrows/2);


        %Cartilage is in the lower half of the image. Therefore it is enough to
        %work only with the lower half.
        IIrot=OCTImagerotated(middle_row+1:end,:);


        %Filter image with a strong horizontal filter
        %The filter sizes has been found with trial and error.
        immasksz=[4,round(catheder_radius*0.7)];
        sefilt=fspecial('average', [round(catheder_radius/10),round(catheder_radius)]);
        %sefilt=fspecial('gaussian', [round(catheder_radius/8),round(catheder_radius/5)],2);
        sestrel=strel('arbitrary',true(immasksz));
        %sestrel = strel('ball',round(catheder_radius/2),round(catheder_radius/10));


        IIrotHorizSmth=imclose(IIrot,sestrel);
        IIrotHorizSmth2=imfilter(IIrotHorizSmth,sefilt);
        %imshow(IIrotHorizSmth2,[])

        %The threshold value has been found with trial and error
        BWcartrot=im2bw(IIrotHorizSmth2,0.2);%0.17

        %This shows the region of cartilage which is used to calculate the
        %meanlayer of the cartilage
        BWcartedge=edge(BWcartrot,'prewitt');


        %Calculate cumulative sum of the cartilage intensities in vertical direction
        IIsmcart=IIrotHorizSmth2;
        IIsmcart(~BWcartrot)=0;

        cumsumIIsmcart=cumsum(IIsmcart.^2,1);

        %Find layer, where the cumulative sum is half of the tolal value, i.e.,
        %middle of the cartilage
        idxmeancart=cumsumIIsmcart > repmat(cumsumIIsmcart(end,:)/2,size(cumsumIIsmcart,1),1);

        %Find the row and column coordinate of the layer pixels
        [row_meancart,col_meancart]=find(idxmeancart);

        %Only one value on each column, i.e., calculate subscripts of the layer
        [C,ia,ic] = unique(col_meancart) ;

        sub_middlecart=[row_meancart(ia),col_meancart(ia)];



        %Smooth the middle layer of the cartilagea bit
        [B,A] = butter(5,2*0.005);
        sub_middlecart(:,1)=round(filtfilt(B,A,sub_middlecart(:,1)));


        %Find smoothed surface of cartilage:

        se=strel('arbitrary',[10,10]);
        BWIIrot=im2bw(IIrot,0.2);
        BWIIrot=imclose(BWIIrot,se);
        BWIIrot=imfill(BWIIrot,'holes');

        cc=bwconncomp(BWIIrot);
        stats = regionprops(cc, 'Area');
        maxarea=[stats.Area]==max([stats.Area]);
        BWIIrot2=false(size(BWIIrot));
        BWIIrot2(cc.PixelIdxList{maxarea})=true;

        %Calculate subscripts of the cartilage surface
        [row_cartsurf,col_cartsurf]=find(BWIIrot2);
        [C,ia,ic] = unique(col_cartsurf) ;
        sub_cartsurf_smoothed=[row_cartsurf(ia),col_cartsurf(ia)];


        %Calculate half thickness of the cartilage, i.e., distance from the
        %cartilage surface to the middle layer.


        %Find cartilage surface without smoothing. Image closing with 3x3 mask
        %is needed to remove some artificial nonsmoothness

        %IIrot
        BWIIrot=im2bw(IIrot,0.15);
        BWIIrot=imclose(BWIIrot,strel('arbitrary',true(3,3)));
        CC = bwconncomp(BWIIrot);
        areas=regionprops(CC,'Area');
        areas=[areas.Area];
        idxmaxarea=find(areas==max(areas),1);
        BWIIrot=false(size(IIrot));
        BWIIrot(CC.PixelIdxList{idxmaxarea})=true;

        %Find the row and column coordinate of the layer pixels
        [row_cartsurf,col_cartsurf]=find(BWIIrot);

        %Only one value on each column, i.e., calculate subscripts of the layer
        [C,ia,ic] = unique(col_cartsurf) ;

        sub_cartsurf=[row_cartsurf(ia),col_cartsurf(ia)];


        %Get surface of the cartilage

        if 0
          %For debugging, plot the image
          red=IIrot;
          green=IIrot;
          blue=IIrot;

          green(BWIIrot)=green(BWIIrot)+0.2;
          green(green>1)=1;

          imshow(cat(3,red,green,blue))
        end

        %Find common left and righ margin for the cartilage surface and the
        %middle layer
        leftcart=round(max([min(sub_cartsurf_smoothed(:,2));min(sub_middlecart(:,2));min(sub_cartsurf(:,2))]+catheder_radius*0.5));
        rightcart=round(min([max(sub_cartsurf_smoothed(:,2));max(sub_middlecart(:,2));max(sub_cartsurf(:,2))]-catheder_radius*0.5));

        %Crop cartilage borders to common limits
        idxleft=sub_middlecart(:,2)<leftcart;
        idxright=sub_middlecart(:,2)>rightcart;
        sub_middlecart(idxleft|idxright,:)=[];

        idxleft=sub_cartsurf_smoothed(:,2)<leftcart;
        idxright=sub_cartsurf_smoothed(:,2)>rightcart;
        sub_cartsurf_smoothed(idxleft|idxright,:)=[];

        idxleft=sub_cartsurf(:,2)<leftcart;
        idxright=sub_cartsurf(:,2)>rightcart;
        sub_cartsurf(idxleft|idxright,:)=[];


        %Find Cartilage-Bone interface

        meanhalfcartthick=mean(sub_middlecart(:,1)-sub_cartsurf_smoothed(:,1));

        %Define cartilage-bone interface by moving the middle layer down the
        %distance of meancartthick
        sub_cartbone=sub_middlecart;
        sub_cartbone(:,1)=sub_middlecart(:,1)+round(meanhalfcartthick);

        %Return full average cartilage thickness, since it is clearer to understand
        meancartthick=meanhalfcartthick*2;
        end
        
        
        
%--------------------------------------------------------------RotateImage#
                
       

    function Image = RotateImage(obj, cImage)
            %Arguments:     -Intance
            %Returns:       -Rotated image
            %Summary:
            %This functions Rotates the cImage so that it's horisontal
            %The closest surface to the catheter is chosen automatically
            %and then the image is rotated so that the surface is
            %horisontal
                
                %Get image dimensions
                [width depth] = size(cImage);
                obj.setXnY(width, depth);
                
                %Enhance the cartilage
                se = strel('line',11,90);
                cImage = imdilate(cImage, se);
                
                %Automatic cartilage detection
                %Requires a lot of time which i dont currently have =(
               
%                NumOfElements = bwconncomp(cImage);
%                
%                %If there is only 1 element to be found the selection
%                %process is quite simple
%                if(NumOfElements.NumObjects == 1)
%                    [x y] = find(cImage, 1, 'first');
%                    test = bwselect(cImage, y, x);
%                %If there are more than one cartilage surface then the
%                %nearest to the center is chosen
%                else
%                   %Calculate the distance of closest cartilage
%                   Distance = bwdist(cImage, 'Euclidean');
%                    Distance = ceil(Distance);
%                    Distance = Distance(round(width/2), round(depth/2));
%                    [x y] = find(cImage(...
%                       round(width/2)- Distance:...
%                        round(width/2)+ Distance,...
%                        round(depth/2)- Distance: ...
%                       round(depth/2)+ Distance), 1, 'first');
%                    
%                    test = bwselect(cImage, y+ceil(depth/2),...
%                        x+ceil(width/2));
%               end
%                
%                NumOfElements = bwconncomp(test);
%               if(NumOfElements.NumObjects < 1)
%                    i= 5;
%                   while(NumOfElements.NumObjects < 1)
%                        try
%                            if(y > round(depth/2))
%                                test = bwselect(cImage,...
%                                    y+round(depth/2)-i,x+round(width/2));
%                            else
%                               test = bwselect(cImage,...
%                                    y+round(depth/2)+i,x+round(width/2));
%                            end
%                        NumOfElements = bwconncomp(test);
%                         i = i +5;
%                        catch err
%                            disp(err);
%                            return;
 %                       end
 %                   end
 %               end
 %
 
                %Show the cartilage to the user
                EnhancedCartilage = obj.getOriginalImage() + edge(cImage...
                    ,'canny');
                imshow(EnhancedCartilage);
                [x y] = ginput(1);
                
                %Select the cartilage
                test = bwselect(cImage, x, y);
                %Display the waitbar to the user
                h = waitbar(0, 'Rotating image...');
                
                %Cartilage angle can be optained by using regionprops
                try
                    stats = regionprops(test, 'orientation');
                    angle = stats.Orientation;
                    
                    %Update waitbar
                    j = waitbar(0.5, 'Rotating image...');
                    delete(h);
                catch err
                    error('Image did not meet requirements');
                end
                
                            
                %Sets the class variable
                setAngle(obj,angle);
                
                %Instruct the user and increase the waitbar size
                h = waitbar(0.9, 'Checking for errors');
                delete(j);
                
                %Rotate the test image to check if the image is upside down
                test = imrotate(test, -angle);
                oImage = obj.getOriginalImage();
                oImage = imrotate(oImage, -angle);
                obj.setOriginalImage(oImage);

 
                %This checks if the upper half contains more cartilage than
                %the bottom half. If it does then that means that the image
                %is upsidedown.
                
                %Get image dimensions
                [width depth] = size(test);
                
                upperHalf = find(test(1:round(depth/2), 1:end)==1);
                lowerHalf = find(test(round(depth/2):end, 1:end)==1);
                
                if(numel(upperHalf) > numel(lowerHalf))
                   test = imrotate(test, -180);
                   obj.setOriginalImage(imrotate(obj.getOriginalImage()...
                       ,-180));
                end
                
                delete(h);
                
                %Return rotated Image
                Image = test;
        end%/RotateImage
        
        
%--------------------------------------------------------getAreaOfInterest#
        
        
        
        function Image = getAreaOfInterest(obj, test)
            %Arguments:         -Intance
            %                   -Image
            %Returns:           -Cropped image
            %Summary
            %This function gets the area of interest from the rotated image
            %Resizable rectangle is used in order to get the are of
            %interest.
            
                
            
                %Draw a nonresizable rectangle on the image
                cImage2 = obj.getOriginalImage();
                [width depth] = size(cImage2);
                obj.setXnY(width, depth);
                
                [~, y] = find(edge(test, 'canny'));
                [~, Iy] = size(cImage2);

                cImage2(:,1:round(Iy*0.3)) =0;
                cImage2(:,end - round(Iy*0.3):end) = 0;

                imshow(cImage2);
                sade = round(obj.getScale()/2);
                width = sade * 4;
                height = sade * 3.5;
                xStart = round(obj.getX()/2);
                yStart = round(obj.getY()/2);
                
                h = imrect(gca,...
                    [xStart, yStart, width, height]);
                fcn = makeConstrainToRectFcn('imrect',get(gca,'XLim'),...
                    get(gca,'YLim'));
                setPositionConstraintFcn(h,fcn); 
                
                %Get rectangle coordinates
                position = wait(h);
                position(1) = round(position(1) * 0.95);
                position(3) = width * 1.1;
                
                %Crop the image
                cImage = imcrop(obj.getOriginalImage(), position);
                
                %Set class variable
                obj.setPosition(position);
                
                %Set class variable
                obj.setcroppedImage(cImage);
                
                %Enhance the image for processing
                obj.setImage(cImage);
                
                Image = cImage;
                
        end%/getAreaOfInterest
        
        

%#------------------------------------------------------------SharpenImage#

        
        function SharpenedImage = SharpenImage(obj, Image)
        %Arguments:         -Intance
        %                   -Image
        %Returns:           -Sharpened image
        %Summary:
        %Filters image with a gaussian filter
        %Removes small blops from the image that might have
        %been left from the preliminary image processing.
        

            %Image is filtered
            %TODO:
            %
            %This needs to be documented better
            
            %Set class variables
            [x y] = size(Image);
            obj.setXnY(x, y);
            
            
            %Use gaussian filter to the image
            h = fspecial('gaussian',15, 2);
            gaus_filt = nlfilter(Image, [3 3], 'std2');
            
            %Filter the image for further processing
            Image = imfilter(Image, h);
            %Image = imfilter(Image - gaus_filt,h);
            
            
            
            Ibw  = im2bw(Image,graythresh(Image));
            se = strel('line',3,90);
            Image = imdilate(~Ibw,se);
            
            %Removes small blops from image
            Image = bwmorph(Image,'clean', inf);
            
            %Removes isolated areas smaller than 25% of image size
            p = round(obj.getX()*obj.getY()*0.25);
            Image = bwareaopen(~Image, p);
            
            %Fill removes isolated holes from the image
            %Since the holes are represented in black the image is used as
            %its complement
            Image=  bwmorph(~Image,'fill', inf);
            
            %Stores the image to a temporary variable after which all holes
            %are filled in the image  
            Image = imfill(~Image, 'holes');
            
            obj.setImage(Image);
            
            %Return sharpened Image
            SharpenedImage = Image;

        end%SharpenImage


%#------------------------------------------------------------getUpperEdge#
        
function RUpperEdge = getUpperEdge(obj, Image)
        %Summary:
        %Uses edge detection to remove everything but the edge from the
        %picture. At this point the picture should only include the
        %cartilage
        %
        %Functions:
        %MeasureDepth
        %Measures the cartilage depth
        %
        %URI:
        %Measures the ultrasound rougnhes index
        %
        %For more information about URI
        %SEE
        %http://www.sciencedirect.com/science/article/pii/S030156290400
        %0754 page 786
        
            %Get the class variable
            

            eImage = Image;
            %get class variables
            [x y] = size(eImage);
           
            %remove all but the edges
            eImage = edge(eImage,'Roberts');
            
            eImage(: , 1:round(x*0.1)) = .0;
            eImage(:,end-round(x*0.15):end) = .0;
            
            %If the image contains more than the upper and lower edge then
            %the image is altered so that the separate elements combine
            eImage = bwmorph(eImage, 'bridge');

            
            %TODO
            %SLIT TO 2 BY FORCE!
            
            [frow fcol] = find(eImage, 1 ,'first');
            [lrow lcol] = find(eImage, 1 ,'last');
            
            NumOfElements = bwconncomp(eImage);
            
            %Erase the smallest element from the list untill there's only 2
            %connected elements left
            if(NumOfElements.NumObjects > 2)
                Toomuch = true;
                while(Toomuch == true)
                    numPixels = cellfun(@numel,NumOfElements.PixelIdxList);
                    [~,idx] = min(numPixels);
                    eImage(NumOfElements.PixelIdxList{idx}) = 0;
                    NumOfElements = bwconncomp(eImage);
                        if(NumOfElements.NumObjects == 2)
                            Toomuch = false;
                        end
                end
            end
            
            %Image with only the upper border is isolated. Picture with
            %bottom and top border is required in order to get the
            %cartilage depth
            
            %Find first pixel of the upper edge
            [row col] = find(eImage, 1 ,'first');
            
            %Get the upper edge from the image
            upper = bwselect(eImage, col, row);
 
            %Get the lowerEdge
            lower = (eImage - upper);
   
            %Find last pixel of the upper edge
            [row2 col2] = find(upper, 1 ,'last');
            
            %Basic triconometrics are used to find out the cartliage angle.
            %The picture is adjusted so that the cartliage is aligned
            %horizontally
            
            deltaY = col2- col;
            deltaX = row - row2;
            angle = atan2(deltaY, deltaX) * 180 / pi;
            
            %The variable upperEdge is used later.
            upperEdge = upper;
            
            %RETURN UPPEREDGE!
            RUpperEdge = upper;
            
            
            %Set the optimum line to the image.
            imshow(upper);       
            try
                myLine = imline(gca, [col col2], [row row2]);
            catch err
                return;
            end
            
            %Optimum cartliage lengh is "burned" to the image
            binaryImage2 = myLine.createMask();
            upper(binaryImage2) = 255;
            
            %Upper cartilage length is determined by counting the white
            %pixels from the image. Note that the variable upperEdge
            %contains only the upper edge and variable upper constains the
            %upper edge and the optimum cartilage.
            length2 = nnz(upperEdge);
            
            %Sets the class variable
            obj.setLength(length2);
            
            %Optimum cartliage length2 is counted.
            dist = nnz(upper) - length2;
 
            %Upper contains the optimum carliage and the upper cartialge.
            setOptimumLength(obj, dist);
            
            
            %FUNCTION CALL
            MeasureDepth;
            

%#------------------------------------------------------------MeasureDepth#
            
 

            function MeasureDepth
            %Summary:
            %Nested function that measures the cartilage depth
            %
            %Functions:
            %URI: Measures the ultrasound roughnes index
            %
            %Display average depth
               

               %Rotate the image
               modifyImage = Image;
               
               %modifyImage = imrotate(modifyImage, 270 +abs(angle));
               
               lower = imrotate(lower, 270 +abs(angle));
               upperEdge = imrotate(upperEdge, 270 +abs(angle));
              
               [frow fcol] = find(lower, 1 ,'first');
               [frow2 fcol2] = find(upperEdge, 1 ,'first');
               [lrow lcol] = find(upperEdge, 1 ,'last');
               [frow2 lcol2] = find(lower, 1 ,'last');
               
               
               modifyImage(: , 1:min([fcol fcol2])) = .0;
               modifyImage(:,max([lcol lcol2]):end) = .0;
              
               %Set class variable
               obj.setImage(modifyImage);
               
               
               %The following alghorithm finds the cartilage depth, mid
               %depth and upper edge.
               area = nnz(modifyImage);
               found = false;
               sum2 = 0;
               limit = 2;
               firsFound = false;
               firsFound2 = false;
               upperLimit = 0;
               mid = 0;

               while(found == false)
                    sum2 = nnz(modifyImage(1:limit,:));
                    if(sum2 >= round(area*0.9))
                        break;
                    elseif(sum2 >= round(area*0.1) && firsFound == false)
                        firsFound = true;
                        upperLimit = limit;
                        limit = limit +1;
                        
                    elseif(sum2 >= round(area*0.45) && firsFound2 == false)
                        firsFound2 = true;
                        mid = limit;
                        limit = limit +1;
                    else
                        limit = limit +1;
                    end
               end

               %Set class variable
               obj.setLimit(limit);
              
               %Find white pixels
               [topX topY] = find(modifyImage == 1);
               
               %Find last white pixel in column
               [lTopx lTopY] = unique(topY);
               LastOccurance = (topX(lTopY));
               
               %Find first white pixel in column
               [lTopx lTopY] = unique(topY, 'first');
               FirstOccurance = (topX(lTopY));
               
               %set class variable
               obj.setcDepthY(FirstOccurance);
               
               %cartilage depth is calculated
               Depth = LastOccurance - FirstOccurance;
               
               %Set class variable
               obj.setAllDepths(Depth);
               
               %Average
               obj.setDepth(limit - upperLimit);

               %Set class variable
               obj.setcDepthX(upperLimit);
               
               %if(obj.getii() == 1)
               %    VisualisizedDepth = modifyImage;

               %    %Turn to RBG image
               %    VisualisizedDepth =double(cat(3, VisualisizedDepth,...
               %        VisualisizedDepth, VisualisizedDepth));
               %
                   %Draw thickness in red
               %    VisualisizedDepth(limit:limit+4, 1:end, 1) = .255;
               %    VisualisizedDepth(limit:limit+4, 1:end, 2) = .100;
               %    VisualisizedDepth(limit:limit+4, 1:end, 3) = .100;
               %    
               %    %Draw mid thickness
               %    VisualisizedDepth(mid:mid+4, 1:end, 1) = .100;
               %    VisualisizedDepth(mid:mid+4, 1:end, 2) = .255;
               %    VisualisizedDepth(mid:mid+4, 1:end, 3) = .100;
               %    
               %    %Draw limit
               %    VisualisizedDepth(upperLimit:upperLimit+4,...
               %        1:end, 1) = .100;
               %    VisualisizedDepth(upperLimit:upperLimit+4,...
               %        1:end, 2) = .100;
               %    VisualisizedDepth(upperLimit:upperLimit+4,...
               %        1:end, 3) = .255;
               %
               %    obj.setVisualisizedDepth(VisualisizedDepth);
               %    
               %end
               
               %FUNCTION CALL
               URI;

%#---------------------------------------------------------------------URI#

             function URI
                %calculateORI - Calculates optical roughness index
                %  ORI=calculateORI(OCTImagerotated,sub_cartsurf,pixelspermm);
                %
                %  function takes as input
                %
                %  OCTImagerotated: OCT image of cartilage, where cartilage has been 
                %  aligned horizontally, 
                %  sub_cartsurf: subscribes of the cartilage surface,
                %  pixelspermm: how many pixels are in one millimeter

                %Sami Vaananen
                %2015-2-16

                  pixelspermm = obj.getScale();
                  [yy,xx] = find(RUpperEdge);
                 
                    minxx=min(xx);
                    xx=xx-minxx;
  
                  %pixelspermm=(catheder_radius*2/catheder_diameter_mm);

                  %imshow(IIrot)
                  %hold on
                  %plot(sub_cartsurf(:,2),sub_cartsurf(:,1),'-r')

                   %yy=sub_cartsurf(:,1);
                   %xx=sub_cartsurf(:,2);

                  %Scale xx and yy to millimeter
                    xx=xx/pixelspermm;
  
                    yy=yy/pixelspermm;

                  %Highpass with 3rd order butter with cut-off frequency 0.05/1mm
                  [B,A] = butter(3,0.05/(max(size((xx)))/pixelspermm),'high');

                  yyhighfreq=filtfilt(B,A,yy);
                  meanyyhighfreq=max(yyhighfreq);
                  
                   obj.setUri(sqrt(sum((yyhighfreq-meanyyhighfreq).^2)...
                       /length(yyhighfreq)));
                  

                end
            end%MeasureDepth     
        end%getUpperEdge
        
        
%------------------------------------------------alignCartilageHorizontally

        function OCTImagerotated = alignCartilageHorizontally(obj)
        %Summary:
        %alignCartilageHorizontally - Find cartilage and align it
        %horizontally Function finds the largest object with high intensity
        %in the OCT image. It is assumed that this is cartilage. Then it
        %calculates the major axis of this object and rotates image such
        %that the major axis is horizontal.

          OCTImage = obj.getOriginalImage();
          [Nrows,Ncols]=size(OCTImage);
          middle_row=round(Nrows/2);
          middle_col=round(Ncols/2);
          
          disp(middle_row)
          disp(middle_col)

            %Now it is assumed that catheder has been removed earlier
            centerintensity=sum(sum(...
                abs(OCTImage(middle_row-3:middle_row+3,...
                middle_col-3:middle_col+3))));
            if centerintensity
              error(['Catheder mask was not given but center of'...
                  'image has nonzero values. Check input.']);
            end

            IInocath=OCTImage;




          %I found this threshold level with trial and error. It worked
          %with 100 images I tested but it is not guaranteed that it
          %works with all possible cartilage OCT images.

          trlevel= 0.14;%graythresh(IInocath);


          BWinitialcartilage=im2bw(IInocath,trlevel);
          CC = bwconncomp(BWinitialcartilage);
          stats=regionprops(CC,'Area','Orientation');

          areas=[stats.Area];
          idx_maxarea=find(areas==max(areas));

          BWinitialcartilage=false(size(IInocath));
          BWinitialcartilage(CC.PixelIdxList{idx_maxarea})=true;

          se=strel('arbitrary',true(5,5));
          BWinitialcartilage=imclose(BWinitialcartilage,se);

          BWinitialcartilage=imfill(BWinitialcartilage,'holes');
          %   imshow(BWinitcart)


          % Rotate cartilage horizontally

          CC = bwconncomp(BWinitialcartilage);
          stats=regionprops(CC,'Area','Orientation');

          cartilage_angle=stats.Orientation;


          OCTImagerotated=imrotate(IInocath,-cartilage_angle,...
              'bilinear','crop');

          if nargin>1
          catheder_BWmask_rot=imrotate(catheder_BWmask,-cartilage_angle,...
              'bilinear','crop');
          end
        end%/alignCartilageHorizontally


        

%#----------------------------------------------------------------Diagnose#
        


        
        function Diagnose(obj, image)
        %Summary:
        %This function does the final diagnosis to the selected area.
        %The cartilage is rated from 0 to 4.
        %
        %0 = completely healthy cartilage
        %1 = surface roughnes is present to a set degree (To what degree?)
        %2 = Damage extends down to < 50% of cartilage depth
        %3 = Damage extends down to > 50% of cartilage depth
        %4 = Damage extends to the bottom
            
           %remove all but the edges
           eImage = edge(image,'roberts',0);
           eImage = bwmorph(eImage, 'bridge');
           
           
           %Find first pixel of the upper edge
           [row col] = find(eImage, 1,'first');
           [row2 col2] = find(eImage, 1 ,'last');
           
           %breaks the image to top and bottom borders
           eImage(1:end ,col:col+5) = .0;
           eImage(1:end ,col2-5:col2) = .0;
           
           %Get the upper edge from the image
           [row col] = find(eImage, 1,'first');
           upperEdge = bwselect(eImage, col, row);
       
           %Find the smalles element from the list of depths
           %Matrice is sorted ofcourse
           
           [v, ~] = find(upperEdge);
           v = sort(v);
           
           depth = obj.getLimit();
           cMin = v(end);
           cartilageDepth = obj.getDepth();
           
            if(depth - cMin < round(cartilageDepth * 0.5))
                obj.setDiagnosis(3);
            elseif(depth - cMin < round(cartilageDepth * 0.9))
                obj.setDiagnosis(2);
            else
                obj.setDiagnosis(0);
            end
        end%/Diagnosis  
        
        
%#----------------------------------------------------------------toString#        
    
        function rString = toString(obj, cArray)
        %Summary:
        %Return a string where all the class variables are
        %listed in a string format.
           
        
            %Put all the class variables to a single string
            %and then return it

            %Avoid the first element since theres the measurements made to
            %the whole cartilage. Measurements of whole cartilage are wrong
            %if the cartilage is curved but it's necessary to make
            %measurements to the whole cartilage in order to get data which
            %is true to the whole area
            
            %Divide the values by scale
            rString = cArray(1, :);
            thickness = mat2cell(cell2mat(cArray(2,1))/obj.getScale());
            lenght = mat2cell(cell2mat(cArray(2,2))/obj.getScale());
            optimumLenght = mat2cell(cell2mat(cArray(2,3))/obj.getScale());
            normalizedlength = mat2cell(...
                cell2mat(cArray(2,2))/cell2mat(cArray(2,3)));
            DiagnosisValues = mat2cell(max(cell2mat(cArray(2:end, 6))));
            
            %Set values
            rString(2,1) = thickness;
            rString(2,2) = lenght;
            rString(2,3) = optimumLenght;
            rString(2,4) = normalizedlength;
            rString(2,5) = cArray(2, 5);
            rString(2,6) = DiagnosisValues;

        end%toString
        
        
%-------------------------------------------------------------stringParser#      
        

        
        function parsedString = stringParser(obj, filename)
        %This functions creates a matrice with all necesary information
        %about the measured cartilage.
        %Information is then saved to an exfel file
        
            depths = obj.getDepth();
            Angles = obj.getAngle();
            Lengths = obj.getLength();
            oLenths = obj.getOptimumLength();
            Uri = obj.getUri();
            Diagnosis = obj.getDiagnosis(); 
            
            String(1, :) = {'Cartilage thickness','Length of surface',...
                'Optimum length','Normalized length',...
                'URI value', 'Diagnosis',filename};

            String{2, 1} = depths;
            String{2, 2} = Lengths;
            String{2, 3}= oLenths;
            String{2, 4}= Lengths...
                /oLenths;
            String{2, 5}= Uri;
            String{2, 6}= max(Diagnosis(1:end));

            parsedString = String;
       
        end%stringParser
        
        
        
%----------------------------------------------------------------saveImage#

        

        function SaveImage(obj, filename, Position, SharpenedImage)
            %Summary:
            %Saves the image..
            VisualizedImage = 1;
            OriginalImage = 2;
            OriginalImage = obj.getOriginalImage();

            %Highlight the are of interest
            Position2 = Position;
            imshow(OriginalImage);
            Position(1) = Position(1) -5;
            Position(3) = Position(3) -5;
            Position(2) = Position(2) -5;
            Position(4) = Position(4) -5;

            h = imrect(gca, Position);
            h = createMask(h);

            temp = OriginalImage;
            %temp(h) = .0;

            OriginalImage(~h) =.0;

            OriginalImage = OriginalImage + temp;
            OriginalImage = OriginalImage -obj.getOriginalImage();
            imshow(obj.getOriginalImage());
            Position2(1) = Position2(1) +5;
            Position2(3) = Position2(3) +5;
            Position2(2) = Position2(2) +5;
            Position2(4) = Position2(4) +5;
            
            y = imrect(gca, Position2);
            y = createMask(y);
            temp = obj.getOriginalImage();
            temp(y) = .0;
            
            OriginalImage = temp + OriginalImage;
            
            imwrite(OriginalImage,...
                strcat('Data/',filename));
            imwrite(SharpenedImage,...
                strcat('Data/',filename,'BinaryImages.tif'));
            
            
            %images = figure;
            %subplot(221);subimage(OriginalImage);
            %subplot(222);subimage(obj.getVisualisizedDepth());
            %subplot(223);subimage(obj.getcroppedImage());
            %print(images, '-djpeg ', strcat('Data/',filename,'Images.jpeg'));
            %close all;
        end
        
        
        
        
%---------------------------------------------------------------AlterBorder  



        function Image = alterBorder(obj, cImage)
            %Summary:
            %Since it's extremely hard to make sense of the bone cartilage
            %border it is necessary to do some post processing to it. This
            %funciton draws a new border by taking a mean value from the
            %bone cartilage edge and draws it. The outcome looks a lot
            %better.
                %Mean value from the cartilage bone border
                lower = edge(cImage,'roberts',0);
                lower = bwmorph(lower, 'bridge');
     
                %Find the first and last white pixel from the image and set
                %the as 0
                
                [fx fy] = find(lower, 1 ,'first');
                [lx ly] = find(lower, 1, 'last');
                
                %Remoce an area the size of 32 pixels from the beginning
                %and from the end. This ensures that the image is divided
                %into a bottom and top half
                lower(fx:fx+32, fy:fy+32)= .0;
                lower(lx-32:lx, ly-32:ly)= .0;
                
                
                %Since the image might contain more than 2 connected
                %elements it is required to delete the extra elements from
                %the image. This function ensures that only 2 connected
                %elements remain
                NumOfElements = bwconncomp(lower);
                if(NumOfElements.NumObjects > 2)
                Toomuch = true;
                    while(Toomuch == true)
                        numPixels = cellfun(@numel,...
                            NumOfElements.PixelIdxList);
                        [~,idx] = min(numPixels);
                        lower(NumOfElements.PixelIdxList{idx}) = 0;
                        NumOfElements = bwconncomp(lower);
                            if(NumOfElements.NumObjects == 2)
                                Toomuch = false;
                            end
                    end
                end
                
                %Detects which half is on top and which is on the bottom
                [fx fy] = find(lower, 1 ,'first');
                either = bwselect(lower, fy, fx);
                 
                upper = 0;
                temp = 0;
                if(nnz(either(1:round(end/2), 1:end))...
                        > nnz(either(round(end/2):end, 1:end)))
                    upper = either;
                    lower = lower - upper;
                else
                    temp = either;
                    upper = lower - either;
                    lower = temp;
                end
 
                lower(1:end, 1:20) = 0;
                lower(1:end, end-20:end) = 0;
                
                %Divide the coordinates into 100 segments from which the
                %mean cartilage depth is calculated. The bottom border is
                %the drawn to this area


                %for(ii = 1:5)
                    
                    %Find coordinates of the lower edge
                    [cx, cy] = find(lower);
                    
                    %Find first white pixel in column
                    [lTopX, lTopY] = unique(cy, 'first');
                    FirstOccurance = (cx(lTopY));
                    
                    begin = lTopX(1);
                    temp = lower;
                    pointer = 1;
                    cEnd = round(numel(FirstOccurance)/2);
                    while(cEnd ~= numel(FirstOccurance))
                       meanValue = round(mean...
                           (FirstOccurance(pointer:cEnd)));
                       temp(meanValue, begin) = 1;
                       pointer = pointer + 1;
                       begin = begin + 1;
                       cEnd = cEnd + 1;
                    end
                    while(pointer < cEnd)
                       cEnd = numel(FirstOccurance);
                       meanValue = round(mean...
                           (FirstOccurance(pointer:cEnd)));
                       temp(meanValue, begin) = 1;
                       begin = begin +1;
                       pointer = pointer +1;
                    end
                    lower = temp - lower;
                %end
                
                temp = lower;
                [x y] = find(temp);

                
                %Now the new bottom border has been drawned onto the image.
                %It is completely possible that the new border is not
                %connected and in order to make this happen the next
                %segment increases the size of white pixels untill one
                %connected element remains.
                i = 1;
                Size = 1;
                NumOfElements = bwconncomp(temp);

                while(NumOfElements.NumObjects ~= 1)
                    while(i < numel(x))
                        try
                        temp(x(i): x(i) +Size, y(i):y(i)+Size) = 1;
                        i = i +1;
                        catch
                        temp(x(i): x(i) -Size, y(i): y(i)-Size) = 1;
                        i = i +1;
                        end
                    end
                    i = 1;
                    Size = Size + 1;
                    NumOfElements = bwconncomp(temp);
                end

                [sizex sizey] = size(temp);
                [osizex osizey] = size(upper);
                
                %The image might have grown during the process so is is
                %necessary to increase the size of the smaller image to
                %match the larger image
                try
                    both = (upper + temp);
                catch
                    try
                        upper(1:end, osizey:sizey) = zeros;
                        both = (upper + temp);
                    catch
                        temp(1:osizex, sizey:osizey) = zeros;
                        upper(1:sizex, osizey:sizey) = zeros;
                        both = (upper + temp);
                    end
                end
                
                %Filling the image is done by filling the sides of the
                %image untill imfill function kicks in.
                spurt = false;
                i = 1;
                error = both;
                try
                    while(spurt == false)
                        both(1:end, 1:i) = 1;
                        both(1:end, end-i:end) = 1;
                        current = nnz(both);
                        both = imfill(both, 'holes');
                        filled = nnz(both);
                        i = i +1;
                        if(filled > round(current*1.2))
                            spurt = true;
                        end
                    end
                catch
                        i = 1;
                        both = error;
                        while(spurt == false)
                            both(1:end, 1:i) = 1;
                            both(1:end, end-i:end) = 1;
                            current = nnz(both);
                            both = imfill(both, 'holes');
                            filled = nnz(both);
                            i = i +1;
                            if(filled > round(current*1.1))
                                spurt = true;
                            end
                        end
                end
                
                both(1:end, 1:i) = 0;
                both(1:end, end-i:end) = 0;
                %Returns the image
                
                Image = both;
           
        end
        
%------------------------------------------------PublicAccessorsAndMutators
%
        
        function setii(obj, ii)
            obj.ii = ii;
        end
        
        function position = getPosition(obj)
            position = obj.position; 
        end%/GetPosition
              
        function ii = getii(obj)
            ii = obj.ii;
        end
        
        function rUri = getUri(obj)
            rUri = obj.UriValue;
        end
        
        
   end%Methods  
            
        

%#----------------------------------------------------------------Mutators#
   
    methods(Access = public)
       
        function setImage(obj, sImage)
            obj.Image = sImage;
        end
        
        function setOriginalImage(obj, sOImage)
            obj.OriginalImage = sOImage;
        end
        
        function setAllDepths(obj, sDepths)
            obj.cAllDepths = sDepths;
        end
        
        function setDepth (obj, sDepth)
            obj.cDepth = sDepth;
        end
        
        function setAngle (obj, sAngle)
            obj.cAngle = sAngle;
        end
        
        function setLength (obj, sLength)
            obj.cLength = sLength; 
        end
        
        function setOptimumLength (obj, sOLength)
            obj.oLenght = sOLength;    
        end
        
        function setScale (obj, sScale)
            obj.Scale = sScale; 
        end
        
        function setXnY(obj, sX, sY)
            obj.x = sX;
            obj.y = sY;
        end
        
        function setUri(obj, sUri)
            obj.UriValue = sUri;   
        end
        
        function setDiagnosis(obj, sDiagnosis)
            obj.Diagnosis(obj.getii()) = sDiagnosis;
        end
        
        function setVisualisizedDepth(obj, Image)
            obj.VisualisizedDepth = Image;
        end
        
        function setcDepthY (obj, Image)
            obj.cDepthY = Image;
        end
        
        function setcDepthX (obj, Image)
            obj.cDepthX = Image;
        end
        
        function setFilename(obj, filename)
            obj.filename = filename;
        end
        
        function setLimit(obj, limit)
           obj.limit = limit; 
        end
        
        function setcroppedImage(obj, image)
           obj.croppedImage = image; 
        end
        
       function setPosition(obj, position)
           obj.position = position; 
        end
        

%#---------------------------------------------------------------Accessors#
    
        
        %The following functions are get functions and return class
        %variables.
        function rImage = getImage(obj)
            rImage = obj.Image;
        end
        
        function oImage = getOriginalImage(obj)
            oImage = obj.OriginalImage;
        end
        
        function depths = getAllDepths(obj)
            depths = obj.cAllDepths;
        end
        
        function depth = getDepth(obj)
            depth = obj.cDepth;
        end
        
        function angle = getAngle(obj)
            angle = obj.cAngle;
        end
        
        function olength = getOptimumLength(obj)
            olength = obj.oLenght;
        end
        
        function clength = getLength(obj)
            clength = obj.cLength;
        end
        
        function rScale = getScale(obj)
            rScale = obj.Scale;
        end
        
        function rX = getX(obj)
            rX = obj.x;
        end
        
        function rY = getY(obj)
            rY = obj.y;
        end
        
        function rDiagnosis = getDiagnosis(obj)
            rDiagnosis = obj.Diagnosis;
        end
        
        function rVisualisizedDepth = getVisualisizedDepth(obj)
             rVisualisizedDepth = obj.VisualisizedDepth;
        end
        
        function image = getcDepthY (obj)
            image = obj.cDepthY;
        end
        
        function image = getcDepthX (obj)
            image = obj.cDepthX;
        end
        
        function filename = getFilename(obj)
            filename = obj.filename;
        end
        
        function limit = getLimit(obj)
            limit = obj.limit; 
        end
        
        function image = getcroppedImage(obj)
           image = obj.croppedImage; 
        end
        
    end%Methods
   
end%Orientation

