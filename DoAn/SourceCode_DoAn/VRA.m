function varargout = VRA(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VRA_OpeningFcn, ...
                   'gui_OutputFcn',  @VRA_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function VRA_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);
userDraw(handles);
global allLine;
allLine={};
set(gca, 'Color', 'Black');
% createCategories();  
global categories;
categories={'0','1'};





function varargout = VRA_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%Khoi tao paint
function userDraw(handles)
A=handles.axDraw; 
set(A,'ButtonDownFcn',@start_paint);


function start_paint(src,eventdata)
global allLine;
coords=get(src,'currentpoint'); 
x=coords(1,1,1);
y=coords(1,2,1);
r=line(x, y, 'color','white', 'LineWidth', 15);
allLine=[allLine,r];
set(gcf,'windowbuttonmotionfcn',{@continue_paint,r})
set(gcf,'windowbuttonupfcn',@done_paint)

function continue_paint(src,eventdata,r)
global allLine;
coords=get(gca,'currentpoint'); 
x=coords(1,1,1);
y=coords(1,2,1);
lastx=get(r,'xdata');  
lasty=get(r,'ydata');
newx=[lastx x];
newy=[lasty y];
set(r,'xdata',newx,'ydata',newy);
allLine=[allLine,r];

function done_paint(src,evendata)
set(gcf,'windowbuttonmotionfcn','')
set(gcf,'windowbuttonupfcn','')



function btnRecognize_Callback(hObject, eventdata, handles)
global categories;
fprintf('\nloading...');
%Format hinh anh input
F = getframe(handles.axDraw);
Image = frame2im(F);
Image = rgb2gray(Image);
Image = imresize(Image,[28 28]);
%Chua hieu tai sao cot dau tien bi gia tri khac 0, chuyen ve gia tri 0
Image(:,1)=0;
%Luu lai hinh anh input
imwrite(Image, 'DataInput\input\Datatest.png');
%Lay gia tri thuat toan duoc chon
typeML=get(handles.slML,'Value');
typeF=get(handles.slFeature,'Value');
cellsize=getCellSize(get(handles.slCellSize,'Value'));
if typeF==1 || typeF==2 %HOG & LBP
    %Load tap du lieu huan luyen
    [imgTrain,lblTrain]=loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
    %Lay dac trung anh train
    [featuresDataTrain]=getFeatures_HOG_LBP(typeF,imgTrain,cellsize);
    %Lay dac trung anh input
    featuresDataInput=getFeatures_HOG_LBP(typeF,Image(:),cellsize);
    %Ap dung thuat toan
    mdl=getMachineLearning_KNN_SVM(typeML,featuresDataTrain,lblTrain);
    %Ket qua du doan 
    lblPredict=predict(mdl,featuresDataInput');
end
if typeF==3 %BOW
    createCategories();
    [imds]=getIMDS('DataTrain',categories);
    [bag,imds]=getBag(imds);
    mdl=getMachineLearning_BOW(imds,bag);
    lblPredict = predict(mdl, imgTest');
end
if typeF==4 %DL
    createCategories();
    [featuresDataTrain,lblDataTrain]=getFeatures_DL_ByBOW('DataTrain',categories);
    [featuresDataInput]=getFeatures_DL('DataInput',{'input'});
    mdl=getMachineLearning_DL(typeML,featuresDataTrain,lblDataTrain);
    lblPredict=predict(mdl,featuresDataInput');
end



set(handles.lblPredict,'String',lblPredict);
fprintf('\ndone!');







function btnClear_Callback(hObject, eventdata, handles)
global allLine;
try
    set(handles.lblPredict,'String','_');
    delete(allLine);    
catch
end

% cla(handles.axDraw,'reset');
% userDraw(handles);


% --- Executes on selection change in slML.
function slML_Callback(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function btnEval_Callback(hObject, eventdata, handles)
global categories;
fprintf('\nloading...');
typeML=get(handles.slML,'Value');
typeF=get(handles.slFeature,'Value');
cellsize=getCellSize(get(handles.slCellSize,'Value'));
%Load tap du lieu huanluyen va taptest
[imgTrain,lblTrain]=loadData('train-images.idx3-ubyte','train-labels.idx1-ubyte');
[imgTest,lblTest]=loadData('t10k-images.idx3-ubyte','t10k-labels.idx1-ubyte');

if typeF==1 || typeF==2 %HOG & LBP
    %Lay dac trung anh train
    featuresDataTrain=getFeatures_HOG_LBP(typeF,imgTrain,cellsize);
    %Lay dac trung anh test
    featuresDataTest=getFeatures_HOG_LBP(typeF,imgTest,cellsize);
    %Ap dung thuat toan
    mdl=getMachineLearning_KNN_SVM(typeML,featuresDataTrain,lblTrain);
    %Ket qua du doan 
    lblPredict=predict(mdl,featuresDataTest');
end
if typeF==3 %BOW
    createCategories();  
    [imdsTrain]=getIMDS('DataTrain',categories);
    [imdsTest]=getIMDS('DataTest',categories);
    [bag,imdsTrain]=getBag(imdsTrain);
    mdl=getMachineLearning_BOW(imdsTrain,bag);
    lblPredict = predict(mdl,imdsTest);
end
if typeF==4 %DL
    createCategories();
    [featuresDataTrain,lblDataTrain]=getFeatures_DL_ByBOW('DataTrain',categories);
    [featuresDataTest]=getFeatures_DL_ByBOW('DataTest',categories);
    mdl=getMachineLearning_DL(featuresDataTrain,lblDataTrain);
    lblPredict=predict(mdl,featuresDataTest');
end

%Neu khop label
nResult=(lblPredict==lblTest);
%Dem tong so label du doan dung
nCount=sum(nResult);
nCorrectRate=nCount/size(imgTest,2)*100;
set(handles.lblCorrect,'String',nCount);
set(handles.lblCorrectRate,'String',nCorrectRate);
fprintf('\ndone!');



function slFeature_Callback(hObject, eventdata, handles)
index = get(hObject,'Value');
if index<=2 
    set(handles.slML, 'Enable', 'on');
    set(handles.slCellSize, 'Enable', 'on');
else
    set(handles.slML, 'Enable', 'off');
    set(handles.slCellSize, 'Enable', 'off');
end
