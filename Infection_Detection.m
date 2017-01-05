function varargout = Infection_Detection(varargin)
% INFECTION_DETECTION M-file for Infection_Detection.fig
%      INFECTION_DETECTION, by itself, creates a new INFECTION_DETECTION or raises the existing
%      singleton*.
%
%      H = INFECTION_DETECTION returns the handle to a new INFECTION_DETECTION or the handle to
%      the existing singleton*.
%
%      INFECTION_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFECTION_DETECTION.M with the given input arguments.
%
%      INFECTION_DETECTION('Property','Value',...) creates a new INFECTION_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Infection_Detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Infection_Detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Infection_Detection

% Last Modified by GUIDE v2.5 20-Apr-2015 19:06:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Infection_Detection_OpeningFcn, ...
                   'gui_OutputFcn',  @Infection_Detection_OutputFcn, ...
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


% --- Executes just before Infection_Detection is made visible.
function Infection_Detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Infection_Detection (see VARARGIN)

% Choose default command line output for Infection_Detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Infection_Detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Infection_Detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selimg.
function selimg_Callback(hObject, eventdata, handles)
% hObject    handle to selimg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = uigetfile('*.jpg','Select the image of the fruit/leaf');
axes(handles.selimg1);
imshow(image);
title('Original Image');

handles.image = image;
guidata(hObject,handles);


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.resimg); cla(handles.resimg); title('');
axes(handles.selimg1); cla(handles.selimg1); title('');
axes(handles.noiserem1); cla(handles.noiserem1); title('');
axes(handles.shadowrem1); cla(handles.shadowrem1); title('');
% axes(handles.clus1); cla(handles.clus1); title('');
% axes(handles.clus2); cla(handles.clus2); title('');
% axes(handles.clus3); cla(handles.clus3); title('');

% --- Executes on button press in kmeans1.
function kmeans1_Callback(hObject, eventdata, handles)
% hObject    handle to kmeans1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    orig_ar = handles.orig_ar;
    segmented_image = handles.segmentedimg;
catch err
    msgbox('Perform the K-means clustering before selecting Cluster 1');
end

segm_image = segmented_image{1};
dis_gray = rgb2gray(segm_image);
[M,number] = bwlabel(dis_gray);

if number <= 2
    msgbox('No disease is present')
    Reset_Callback(hObject, eventdata, handles)
else
    disease(segm_image, orig_ar, handles.image)
end


% --- Executes on button press in imres.
function imres_Callback(hObject, eventdata, handles)
% hObject    handle to imres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Image Resize
try
    image = handles.image;
catch err
    msgbox('Select the Image');
end

img = imread(image);
[row col channel] = size(img);
img_resized = imresize(img,[480 640]); % Need to change the size of the resize

% Displaying the image
axes(handles.resimg);
imshow(img_resized);
title('Resized Image(640*480)');

handles.ResizedImage = img_resized;
guidata(hObject,handles);


% --- Executes on button press in noiserem.
function noiserem_Callback(hObject, eventdata, handles)
% hObject    handle to noiserem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    image_resized = handles.ResizedImage;
catch err
    msgbox('Please resize the image');
end

[cleanimg] = NoiseRemoval(image_resized);

axes(handles.noiserem1);
imshow(cleanimg);
title('Noise removed Image');

handles.cleanimg = cleanimg;
guidata(hObject,handles);

% --- Executes on button press in shadowrem.
function shadowrem_Callback(hObject, eventdata, handles)
% hObject    handle to shadowrem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    imag_for_shadow_rem = handles.cleanimg;
catch err
    msgbox('Please perform Noise Removal');
end

shadowless_img = ShadowRemoval(imag_for_shadow_rem);

axes(handles.shadowrem1);
imshow(shadowless_img);
title('Image after Shadow Removal');

handles.shadowremimg = shadowless_img;
guidata(hObject,handles);


% --- Executes on button press in kmeans2.
function kmeans2_Callback(hObject, eventdata, handles)
% hObject    handle to kmeans2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    orig_ar = handles.orig_ar;
    segmented_image = handles.segmentedimg;
catch err
    msgbox('Perform the K-means clustering before selecting Cluster 1');
end

segm_image = segmented_image{2};
dis_gray = rgb2gray(segm_image);
[M,number] = bwlabel(dis_gray);

if number <= 2
    msgbox('No disease is present')
    Reset_Callback(hObject, eventdata, handles)
else
    disease(segm_image, orig_ar, handles.image)
end

% --- Executes on button press in kmeans3.
function kmeans3_Callback(hObject, eventdata, handles)
% hObject    handle to kmeans3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    orig_ar = handles.orig_ar;
    segmented_image = handles.segmentedimg;
catch err
    msgbox('Perform the K-means clustering before selecting Cluster 1');
end

segm_image = segmented_image{3};
dis_gray = rgb2gray(segm_image);
[M,number] = bwlabel(dis_gray);

if number <= 2
    msgbox('No disease is present')
    Reset_Callback(hObject, eventdata, handles)
else
    disease(segm_image, orig_ar, handles.image)
end

% --- Executes on button press in kmeans_main.
function kmeans_main_Callback(hObject, eventdata, handles)
% hObject    handle to kmeans_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    img_for_seg = handles.shadowremimg;
catch err
    msgbox('Complete the pre-processing steps before moving to K Means clustering');
end

[segmented_image,orig_ar] = DetectDisease(img_for_seg);

handles.orig_ar = orig_ar;
handles.segmentedimg = segmented_image;
guidata(hObject,handles);

msgbox('K-Means Clustering Complete');

% Not required atm
% segm_image = segmented_image{3};
% dis_gray = rgb2gray(segm_image);
% [M,number] = bwlabel(dis_gray);
% if number <= 2
%     msgbox('No disease is present')
%     Reset_Callback(hObject, eventdata, handles)
% else
%     disease(segm_image, orig_ar, handles.image)
% end
