function [Position, BWimage] = pickCartilage(oImage)
                Original = oImage;

                %Treshold found by trial and error
                oImage(oImage < 0.1) = .0;
                level = graythresh(oImage);
                Image = im2bw(oImage,level);
                
                %Get image Dimensions
                [width, ~] = size(Image);
                
                %Remove small objects from image
                Image = bwareaopen(Image, round(width * 0.5));
                
                %Fill holes from image
                Image = imfill(Image, 'holes');
                
                
                NumOfElements = bwconncomp(Image);
                %Erase the smallest element from the list untill there's only
                %num connected elements left
                if(NumOfElements.NumObjects > 2)
                    Toomuch = true;
                    while(Toomuch == true)
                        numPixels = cellfun(@numel,NumOfElements.PixelIdxList);
                        [~,idx] = min(numPixels);
                        Image(NumOfElements.PixelIdxList{idx}) = 0;
                        NumOfElements = bwconncomp(Image);
                            if(NumOfElements.NumObjects == 2)
                                Toomuch = false;
                            end
                    end
                end
                
                imshow(Original + Image);
                [x y] = ginput(1);
                %Select the cartilage
                BWimage = bwselect(Image, x, y);
                Position = [x,y];
end