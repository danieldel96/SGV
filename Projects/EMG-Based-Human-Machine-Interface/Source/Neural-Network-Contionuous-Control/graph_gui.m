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

axes(handles.axes1);
plot(d(:,num_channels+7),d(:,num_channels+1))
title('Finger Angle')
if(count <= window_size)
    xlim([0 window_size])
else
    xlim([count-window_size count])
end
ylim([0 3.5])

axes(handles.axes2);
plot(d(:,num_channels+7),d(:,num_channels+6))
title('Wrist Rotation')
if(count <= window_size)
    xlim([0 window_size])
else
    xlim([count-window_size count])
end
ylim([-4 2])

axes(handles.axes3);
plot(d(:,num_channels+3),d(:,1))
title('EMG Channels')
if(count <= window_size)
    xlim([0 window_size])
else
    xlim([count-window_size count])
end
ylim([-5.5 5.5])

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

 
