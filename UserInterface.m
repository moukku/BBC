function varargout = UserInterface(varargin)
% USERINTERFACE MATLAB code for UserInterface.fig
%      USERINTERFACE, by itself, creates a new USERINTERFACE or raises the existing
%      singleton*.
%
%      H = USERINTERFACE returns the handle to a new USERINTERFACE or the handle to
%      the existing singleton*.
%
%      USERINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USERINTERFACE.M with the given input arguments.
%
%      USERINTERFACE('Property','Value',...) creates a new USERINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UserInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UserInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UserInterface

% Last Modified by GUIDE v2.5 28-Jan-2015 15:17:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UserInterface_OpeningFcn, ...
                   'gui_OutputFcn',  @UserInterface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before UserInterface is made visible.
function UserInterface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UserInterface (see VARARGIN)

%Make directory if it does not exist
if(exist('Data', 'file') == 0)
    mkdir('Data');
end

%Amount of chosen images
handles.ImagesLeft = 0;
handles.listing = 0;
handles.path = 0;

% Choose default command line output for UserInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UserInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UserInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in UsePosition.
function UsePosition_Callback(hObject, eventdata, handles)
% hObject    handle to UsePosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of UsePosition


% --- Executes on button press in BrowseImagesBtn.
function BrowseImagesBtn_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseImagesBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.listing handles.path] = uigetfile('*.*', 'Pick files',...
    'MultiSelect', 'on'); %dir('kuvat');
[~, handles.ImagesLeft] = size(handles.listing);
guidata(hObject, handles);



% --- Executes on button press in AnalyseBtn.
function AnalyseBtn_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

listing = handles.listing;
limit = handles.ImagesLeft;
lpath = handles.path;
    if(get(handles.UsePosition, 'Value') == 0)
        PositionCoordinates = zeros(1,4,limit);
    else
        load('C:\Users\wksadmin\Desktop\ICRS.2\configs.mat',...
                'PositionCoordinates');
    end
if(limit > 0)
     try
        cell2mat(listing)
    catch
        limit = 1;
     end

     
    %
    %Control loop
    %
    for (ii = 1:limit)
        imagesLeft = limit - ii;
        
        %????? FIX PLZ
        try
            loadpath=strcat(lpath, cell2mat(listing(ii:ii)));
        catch
            loadpath=strcat(lpath, cell2mat(listing(ii:ii)));
        end
        
        try
            Image = imread(loadpath);
            filename = cell2mat(listing(ii));
        catch
            loadpath=strcat(lpath, listing);
            Image = imread(loadpath);
            filename = listing;
        end

        Image = im2double(Image);

        %Create class intance
        oMain = ImageProcessing(Image, ii);
        
        %Enhance image (Remove small blops etc)
        Image = oMain.enhanceImage(Image);
        
        %Align image
        [Image, BWinitialcartilage] = oMain.alignCartilageHorizontally(Image);

        %Find the cartilage surface
        BWcartsurf = oMain.SegmentImage(Image);
        
        %Calculate surface roughness
        oMain.calculateOri(BWcartsurf);
        
        
        %If the analysis was failed. The user is asked to place the ROI again. This
        %is done 5 times before the execution continues normally
%         k=1;
%         answer = {'x'};
%         while ~isempty(answer)
        %Get area of interest from the rotated image
        
        
        if(get(handles.UsePosition, 'Value') == 0)
            AreaOfInterest = oMain.getAreaOfInterest(Image...
                ,BWinitialcartilage);
        else
            Position = PositionCoordinates(1:end,1:end,limit);
            AreaOfInterest = imcrop(BWinitialcartilage, Position);
        end
         
         [x, ~] = size(AreaOfInterest);
         AreaOfInterest(1:end, 1:round(x * 0.05)) = 0;
         AreaOfInterest(1:end, end-round(x * 0.05):end) = 0;

        %Get measurement data
        %Set iteration number
        oMain.setii(1);

        


        %Get position
        if(get(handles.UsePosition, 'Value') == 0)
            Position = oMain.getPosition();
        end
        [BWcartsurf, BWmiddlecart] = imcrop(BWcartsurf, Position);
        figure, imshow(BWmiddlecart)
        oMain.getUpperEdge(AreaOfInterest, BWcartsurf);
        PositionCoordinates(1:end, 1:end, ii) = Position;


        %Save image
        oMain.SaveImage(filename, Position, AreaOfInterest);

        [x, ~] = size(AreaOfInterest);
        Position = [0,0,Position(3)/2,x];

        surface = imcrop(BWcartsurf, Position);

        while Position(1) < Position(3)
%             try
            %Set iteration number
            oMain.setii(oMain.getii()+1);

            %Calculate the results of the SharpenedImage
            %oMain.getUpperEdge(ManipulatableImage);

            %Get Diagnosis for the image
            oMain.Diagnose(surface);

            %Crop the sharpened Image
            Position(1) = Position(1) + 1;
            ManipulatableImage = imcrop(AreaOfInterest, Position);

%              catch
%              Position(1) = Position(1) + 1;
%                  if(Position(1) >= Position(3))
%                      break;
%                  else
%                      if(oMain.getii() > 2)
%                          oMain.setii(oMain.getii()-1);
%                      end
%                  end
%              end
        end
        %Get the data
        data = oMain.stringParser(filename);

        %Parse data so it makes more sense.
        try
            parsedData = oMain.toString(data);
        catch
                 set(handles.NotfConsole, 'String'...
                , strcat(get(handles.NotfConsole, 'String')...
                , 'Diagnosis could not be made'));
            return;
        end




%         if isempty(parsedData{2,6})  %eli jos tyhjä niin jatkaa looppia
%              answer ={'x'};
%         else
%             answer ={};
%         end



%         if k==5 %kokeillaan maksimissaan viisi kertaa
%             answer ={}
%         end
%         k=k+1;
%         end 
        %-----------------------------------------------------------
        % ASD
        %------------------------------------------------------------

        %check if file exists
        toPrint = cell(2,8);
        toPrint(1:end,2:end) = parsedData
        toPrint{1,1} = 'Kuvia jäljellä';
        toPrint{2,1} = num2str(imagesLeft);
        disp(toPrint);
        if(exist('Data/Measurements.xlsx', 'file') == 0)
            xlswrite('Data/Measurements.xlsx', parsedData);
        else
            xlsappend('Data/Measurements.xlsx', parsedData);
        end    
             set(handles.NotfConsole, 'String'...
            ,toPrint);
    end
    
    %Save Position coordinates for later use
     if(get(handles.UsePosition, 'Value') == 0)
        if(exist('C:\Users\wksadmin\Desktop\ICRS.2\configs.mat', 'file')...
                ==2)
            save('C:\Users\wksadmin\Desktop\ICRS.2\configs.mat',...
                'PositionCoordinates', '-append');
        else
            save('C:\Users\wksadmin\Desktop\ICRS.2\configs.mat',...
                'PositionCoordinates');
        end
     end
end

