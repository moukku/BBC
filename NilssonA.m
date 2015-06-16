% function LowestCostPath = Djikstra(Graph, Image)
function [LowestCostPath, LightestPathImage, Image] = NilssonA()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


%Booting up So I dont need to do it manuallu
cd('C:\Users\wksadmin\Documents\GitHub\BBC');
test = imread('test.tif');
test = imresize(test, 0.5);
disp(size(test));
Image = FilterImage(test);
Graph = createGraph(Image);
  
  
%This is the start of the algorithm
%Find start and end node
imshow(Image) 
[x, y] = ginput(2);
startX = round(x(1));
startY = round(y(1));
goalX = round(x(2));
goalY = round(y(2));

[width,height] = size(Image);
temp = zeros(width, height);
temp = im2bw(temp);
temp(goalY, goalX) = 1;

%calculate distance to the goal node for each pixel
CalculateHValue(temp, Graph);
close all;

LightestPathImage = zeros(width, height);

%Set up values according to A* algorithm
Current = Graph((startY -1) * size(Image,2) + startX);
GoalNode = Graph((goalY -1) * size(Image,2) + goalX);
Current.GCost = 0;
Current.FCost = Current.GCost + Current.HCost;
Current.parent = Current;

%Use heap as a datastructure for the openList
%Time connstraint using heap is =(1)
% H = MinHeap(size(Image, 1) * size(Image, 2), Current);
H = cell(0);
H{size(H,2)+1} = Current;
%Some jokester added an easter egg to their datastructure
%Close it
close all;
min = Current.HCost;

  %While true
  while(1 == 1)
            Index = ExtractMin(H);
            Current = H{Index};
            H(Index) = [];
            Current.closed = 1;
            
            if(Current.HCost < min)
                min = Current.HCost;
                disp(min);
            end
            
            %NOTE!:
            %If goalnode is found OList contains the goalnode
            [H, bool] = CalculateCost(Current,H, GoalNode);
            %If goal node is reached the path was found
            if(bool == 1)
                [LowestCostPath, LightestPathImage]...
                    = ReturnPath(H, LightestPathImage);
                return;
            end
   end
end

function min = ExtractMin(H)
    min = 1;    
    if(size(H,2) == 1)
        return;
    else
        minFCost = H{1}.FCost;
        for(i = 2:size(H,2))
            if(H{i}.FCost < minFCost)
                minFCost = H{i}.FCost;
                min = i;
            end
            if(H{i}.FCost == minFCost && H{i}.HCost < H{min}.HCost)
                min = i;
            end
        end
    end
end

% function [OList, bool] = CalculateCost(node, CList, OList, GoalNode)
function [H, bool] = CalculateCost(node, H, GoalNode)
    bool = 0;
    for(i = 1:size(node.neigbors, 2))
        if(node.neigbors{1,i}{1,1}.closed == 1)
            continue;
        end
            
            %If neighbor node is the goal node then the search can end
            if(node.neigbors{1,i}{1,1} == GoalNode)
                GoalNode.parent = node;
                bool = 1;
                H = GoalNode;
                return;
            else
                 if(node.neigbors{1,i}{1,1}.GCost...
                         > CalculateGCost(node, node.neigbors{1,i}{1,1}))
                    node.neigbors{1,i}{1,1}.GCost = ...
                        CalculateGCost(node, node.neigbors{1,i}{1,1});

                                %Calculate F value
                    node.neigbors{1,i}{1,1}.FCost...
                        = node.neigbors{1,i}{1,1}.HCost...
                        + node.neigbors{1,i}{1,1}.GCost;

                    node.neigbors{1,i}{1,1}.parent = node;
                     H{size(H,2)+1} = (node.neigbors{1,i}{1,1});
                    
                 end
            end
        end
end

function CalculateHValue(Image, Graph)
    Image = bwdist(Image);
    [height, width] = size(Image);
    for(i = 1: height)
        for(j = 1:width)
            Graph((i -1) * width + j).HCost = Image(i,j);
        end
    end
end

function GCost = CalculateGCost(parent, node)
    if((node.location(2) > parent.location(2) || node.location(2) <...
            parent.location(2)) && (node.location(1) > parent.location(1)...
            || node.location(1) < parent.location(1)))
            GCost = 1.4 + node.weight + parent.GCost;
    else
        GCost = 1.0 + node.weight + parent.GCost;
    end
end

function [path, LightestPathImage] = ReturnPath(node, LightestPathImage)
path = cell(0);
    while(node.parent ~= node)
        path{size(path,2)+1} = node.location;
        LightestPathImage(node.location(1), node.location(2)) = 255;
        node = node.parent;
    end
end

