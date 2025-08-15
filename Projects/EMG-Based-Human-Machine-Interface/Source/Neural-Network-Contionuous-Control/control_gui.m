function varargout = graph_gui(varargin)
% GRAPH_GUI MATLAB code for graph_gui.fig
%      GRAPH_GUI, by itself, creates a new GRAPH_GUI or raises the existing
%      singleton*.
%
%      H = GRAPH_GUI returns the handle to a new GRAPH_GUI or the handle to
%      the existing singleton*.
%
%      GRAPH_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAPH_GUI.M with the given input arguments.
%
%      GRAPH_GUI('Property','Value',...) creates a new GRAPH_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before graph_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to graph_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help graph_gui

% Last Modified by GUIDE v2.5 19-May-2020 16:42:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @graph_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @graph_gui_OutputFcn, ...
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


% --- Executes just before graph_gui is made visible.
function graph_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to graph_gui (see VARARGIN)

% Choose default command line output for graph_gui
handles.output = hObject;

window_size = evalin('base','window_size');
d = evalin('base','all_data');
sz = size(d);
count = sz(1)/1000;
num_channels = evalin('base','num_channels');

buff_size = 5000;
win_size = 50;
if(count*1000>buff_size)
    emgs = d(count*1000-buff_size+1:count*1000,1:num_channels);
    processed_data = envelope(abs(normalize(emgs)),1000,'rms'));
%     for i=1:10
%         processed_data = [smooth(processed_data(:,1),10), smooth(processed_data(:,2),10)];
%     end

    mean_f = mean(processed_data(length(processed_data)-win_size:length(processed_data),:));
    assignin('base','mean_f',mean_f);
    feat = mean_f;
    net = evalin('base','net');
    predicted_movement = net(feat')
%     if(abs(predicted_movement)<0.2)
%         predicted_movement=0;
%     end
    predictions = evalin('base','predictions');
    predictions = [predictions; predicted_movement];
%     smooth(predictions,50);
%     predicted_movement = predictions(length(predictions));
    assignin('base','predictions',predictions)
%     if(predicted_movement>0)
%         calllib('cbw64','cbVOut',1,3,100,0,0);
%         calllib('cbw64','cbVOut',1,2,100,predicted_movement,0);
%     else
%         calllib('cbw64','cbVOut',1,2,100,0,0);
%         calllib('cbw64','cbVOut',1,3,100,-predicted_movement,0);
%     end
%     if(count>=19.9)
%         calllib('cbw64','cbVOut',1,2,100,0,0);
%         calllib('cbw64','cbVOut',1,3,100,0,0);
%     end
else
    mean_f = [0 0];
    assignin('base','mean_f',mean_f);
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes graph_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = graph_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 
