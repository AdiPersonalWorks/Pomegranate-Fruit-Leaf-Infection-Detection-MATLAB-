function varargout = disease(varargin)
% DISEASE MATLAB code for disease.fig
%      DISEASE, by itself, creates a new DISEASE or raises the existing
%      singleton*.
%
%      H = DISEASE returns the handle to a new DISEASE or the handle to
%      the existing singleton*.
%
%      DISEASE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISEASE.M with the given input arguments.
%
%      DISEASE('Property','Value',...) creates a new DISEASE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before disease_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to disease_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help disease

% Last Modified by GUIDE v2.5 20-Apr-2015 21:04:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @disease_OpeningFcn, ...
                   'gui_OutputFcn',  @disease_OutputFcn, ...
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


% --- Executes just before disease is made visible.
function disease_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to disease (see VARARGIN)

% Choose default command line output for disease
handles.output = hObject;
fin_img = varargin{1};
area_im = varargin{2};
img_name = varargin{3};
set(handles.axes1,'Visible','on')
axes(handles.axes1)
imshow(fin_img)
% Update handles structure
handles.ar = area_im;
handles.im = fin_img;
handles.name = img_name;
guidata(hObject, handles);

% UIWAIT makes disease wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = disease_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    im = handles.im;
    orig_ar = handles.ar;
catch err
    msgbox('Please make sure all the previous steps have been done');
end

Out = rgb2gray(im);
[L10 num10]=bwlabel(Out);
st = regionprops(L10,'Area');

area_dis = 0;
for i = 1:num10
    area_dis = area_dis + st(i).Area;
end

% Calculating the percentage Diseased Area
per_diseased = (area_dis/orig_ar)*100;
name_image = handles.name;
img = imread(handles.name);
% write the data to excel
% info = {'Image Name','Disease Name','Infection percentage','Grade of disease'};
% xlswrite('dis_info.xls',info)

if per_diseased < 5
    grade = 0;
    han_img = handles.im;
    name = strtok(name_image,'.');
    name = strcat(cd,'\Graded_Images\No_Disease\',name);
    imwrite(img,[name,'.jpg']);
elseif per_diseased >= 5 && per_diseased < 20
    grade = 1;
    han_img = handles.im;
    name = strtok(name_image,'.');
    name = strcat(cd,'\Graded_Images\Grade_1\',name);
    imwrite(img,[name,'.jpg']);
elseif per_diseased >= 20 && per_diseased < 35
    grade = 2;
    han_img = handles.im;
    name = strtok(name_image,'.');
    name = strcat(cd,'\Graded_Images\Grade_2\',name);
    imwrite(img,[name,'.jpg']);
elseif per_diseased >= 35 && per_diseased < 50
    grade = 3;
    han_img = handles.im;
    name = strtok(name_image,'.');
    name = strcat(cd,'\Graded_Images\Grade_3\',name);
    imwrite(img,[name,'.jpg']);
else
    grade = 4;
    han_img = handles.im;
    name = strtok(name_image,'.');
    name = strcat(cd,'\Graded_Images\Grade_4\',name);
    imwrite(han_img,[name,'.jpg']);
end

msg1 = strcat('The percentage of infection is : ',num2str(per_diseased),'%');
msg2 = strcat('Infection grade is : ','Grade ',num2str(grade));
msg3 = strcat('Disease Name is : ','Bacterial Blight');
msgbox(sprintf('%s\n%s\n%s',msg1,msg2,msg3));

% Writing into Excel
[num,text,info] = xlsread('dis_info.xls','Sheet1');
[r,c] = size(info);
info(r+1,:) = {name_image,'Bacterial Blight',per_diseased,grade};
xlswrite('dis_info.xls',info)

msgbox('New record added to the excel database');
