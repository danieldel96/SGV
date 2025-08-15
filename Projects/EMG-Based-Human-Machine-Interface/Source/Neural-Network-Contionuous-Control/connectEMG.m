disp('Connecting to Trigno...')

global DATA_PUB interfaceObjectEMG rateAdjustedEmgBytesToRead t_client commObject Fs window publish isCollectData
isCollectData = false;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% CHANGE THIS TO THE IP OF THE COMPUTER RUNNING THE TRIGNO CONTROL UTILITY
HOST_IP = 'localhost';

% CHANGE THIS TO THE PARTICIPANT ID # (FROM OFFSET_MVC.XLSX)
PAR_ID = 811;

% CHANGE THIS ('ON'/'OFF') TO OPEN OR CLOSE THE DATA PUBLISHER
DATA_PUB = 'ON'; % 'ON'/'OFF'

% FILENAME TO SAVE DATA OUT
FILENAME_EMG = 'pro1';

%% Create the required objects
% Define number of sensors
NUM_SENSORS = 4;

% Read MVC & offset values
filename_cal = 'mvc_offset.xlsx';
mvc = readtable(filename_cal);
mvc = mvc(mvc.participant==PAR_ID,:);% read MVC & offset values

%TCPIP Connection to stream EMG Data
interfaceObjectEMG = tcpip(HOST_IP,50043);
interfaceObjectEMG.InputBufferSize = 6400;

%TCPIP Connection to communicate with SDK, send/receive commands
commObject = tcpip(HOST_IP,50040);

%%Open the COM interface, determine RATE
fopen(commObject);

rateAdjustedEmgBytesToRead=NUM_SENSORS*16*24;

% TCPIP Connection to publish processed EMG data
if strcmp(DATA_PUB,'ON')
    t_client = tcpip('127.0.0.1', 8080, "NetworkRole","client");
    try
     fopen(t_client);
     disp('Connected!');


    catch message
        disp('Connect to Python Server')
        error(message.message)
        return
    end

end

 % signal properties
Fs = 1000; % sampling frequency (Fs)
window = 100; % number of data points of sliding window
nSamples = 16; % chunk of data points to process at a time
updateRate = 16; % how often to read data chunks from DAQ

%% Setup interface object to read chunks of data
% Define a callback function to be executed when desired number of bytes
% are available in the input buffer
 bytesToReadEMG = rateAdjustedEmgBytesToRead;
 interfaceObjectEMG.BytesAvailableFcn = @getDataCC;
 interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
 interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;             
pause(1);
%% 
% Open the interface object
try
    fopen(interfaceObjectEMG);
    disp('interfaceObjectEMG connected!')
%     fopen(interfaceObjectACC);
catch
    error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
end

fprintf(commObject, sprintf(['START\r\n\r']));
disp("starting commObject")
pause(3);
pause(1);
%% fread(commObject,commObject.BytesAvailable);
fprintf(commObject, sprintf(['RATE 2000\r\n\r']));
pause(1);
%% fread(commObject,commObject.BytesAvailable);
fprintf(commObject, sprintf(['RATE?\r\n\r']));
pause(1);


