%%RealTime Data Streaming with Delsys SDK

% Copyright (C) 2011 Delsys, Inc.
% 
% Permission is hereby granted, free of charge, to any person obtaining a 
% copy of this software and associated documentation files (the "Software"), 
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, and distribute the 
% Software, and to permit persons to whom the Software is furnished to do so, 
% subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in 
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
% DEALINGS IN THE SOFTWARE.

% Change Log:
% 1. Yue Luo (12-30-2020): deleted ACC portion, only focus on EMG portion
% 2. Yue Luo (02-22-2021): read MVC and offset values from excel "mvc_offset.xlsx"
% 3. Yue Luo (03-18-2021): writed the data publisher as a client
% 4. Yue Luo (05-04-2021): added a switch ("on/off") triger for data publisher
% 5. Yue Luo (05-04-2021): modified the output format into 1*4 array
% 6. Yue Luo (07-01-2021): change to 1111Hz and tested the time delay for signal processing
% 7. Yue Luo (11-16-2021): save raw and processed EMG data out v1 (raw & processed uneven length)
% 8. Yue Luo (11-29-2021): save raw and processed EMG data out v2 (raw & processed same length)

function EMG_SigProcess()
%% MAIN FUNCTION TO START THE EMG DATA COLLECTION
global DATA_PUB plotHandlesEMG rateAdjustedEmgBytesToRead t_client mvc tStart tOut tIn FILENAME_EMG

%% 1. GENERAL SETTINGS
tStart = tic;
tOut = []; tIn = [];

% 1.1 CHANGE THIS TO THE PARTICIPANT ID # (FROM OFFSET_MVC.XLSX)
PAR_ID = 810;

% 1.2 CHANGE THIS ('ON'/'OFF') TO OPEN OR CLOSE THE DATA PUBLISHER
DATA_PUB = 'OFF'; % 'ON'/'OFF'

% 1.2 CHANGE THIS TO THE IP OF THE COMPUTER RUNNING THE TRIGNO CONTROL UTILITY
HOST_IP = 'localhost';

% 1.4 CHANGE THIS FROM 1 TO 16 TO DEFINE THE NUMBER OF SENSORS INCLUDED
NUM_SENSORS = 4; 

% 1.5 FILENAME TO SAVE DATA OUT
FILENAME_EMG = 'test';

%% 2. LOAD MVC DATA FROM OFFSET_MVC.XLSX

% 2.1 Read MVC & offset values
filename_cal = 'mvc_offset.xlsx';
mvc = readtable(filename_cal);
mvc = mvc(mvc.participant==PAR_ID,:);% read MVC & offset values

%% 3. COMMUNICATE W/ TRIGNO CONTROL UTILITY TO STREAM EMG DATA

% 3.1 Create the required objects

% handles to all plots
plotHandlesEMG = zeros(NUM_SENSORS,1);

% TCPIP Connection to stream EMG Data
interfaceObjectEMG = tcpip(HOST_IP,50043); %needed?
interfaceObjectEMG.InputBufferSize = 6400;

% TCPIP Connection to communicate with SDK, send/receive commands
commObject = tcpip(HOST_IP,50040);

% TCPIP Connection to publish processed EMG data
if strcmp(DATA_PUB,'ON')%needed?
    t_client = tcpclient('127.0.0.1', 8080);
end

% timer object to update EMG data and draw plots
t = timer('Period', .01, 'ExecutionMode', 'fixedSpacing', 'TimerFcn', {@updatePlots, plotHandlesEMG});

% variables to store EMG data
global data_rawEMG data_prcEMG data_prcEMG_noabs
% raw EMG data (N*1 array, 16 channels)
data_rawEMG = []; 
% raw EMG data (N*4 array, 4 target channels, raw data before any data processing)
% (for classifier training)
data_prcEMG_noabs = []; 
% processed EMG data (N*5 array, 4 target channels + 1 timestamp, throughout the trial)
data_prcEMG = []; %zeros(1,5); 

% 3.2 Set up the plots

axesHandlesEMG = zeros(NUM_SENSORS,1);

%initiate the EMG figure
figureHandleEMG = figure('Name', 'EMG Data','Numbertitle', 'off',  ...
    'CloseRequestFcn', {@localCloseFigure, interfaceObjectEMG, commObject, t});
%set plot ratios
set(figureHandleEMG, 'position', [50 200 1000 200])

%set plot axis
for i = 1:NUM_SENSORS
    axesHandlesEMG(i) = subplot(1,4,i);

    plotHandlesEMG(i) = plot(axesHandlesEMG(i),0,'-y','LineWidth',1);

    set(axesHandlesEMG(i),'YGrid','on');
    set(axesHandlesEMG(i),'YColor',[0.9725 0.9725 0.9725]);
    set(axesHandlesEMG(i),'XGrid','on');
    set(axesHandlesEMG(i),'XColor',[0.9725 0.9725 0.9725]);
    set(axesHandlesEMG(i),'Color',[.15 .15 .15]);
    set(axesHandlesEMG(i),'YLim', [0 110]); 
    set(axesHandlesEMG(i),'YLimMode', 'manual');
    set(axesHandlesEMG(i),'XLim', [0 250]);
    set(axesHandlesEMG(i),'XLimMode', 'manual');
    xlabel('Samples');
    ylabel('Percentage %')
    title(sprintf('EMG %i', i))
   
end

% 3.3 Open the COM interface, determine SAMPLING RATE

fopen(commObject);

% pause(1);
% fread(commObject,commObject.BytesAvailable);
% fprintf(commObject, sprintf(['RATE 2000\r\n\r']));
% pause(1);
% fread(commObject,commObject.BytesAvailable);
% fprintf(commObject, sprintf(['RATE?\r\n\r']));
% pause(1);
% data = fread(commObject,commObject.BytesAvailable);
% emgRate = strtrim(char(data'));

% set rateAdjustedEmgBytesToRead (Port-50041)
% if(strcmp(emgRate, '1925.926'))
%     rateAdjustedEmgBytesToRead=1664; %UPSAMPLE OFF - fs: 1925.926 Hz 
% else 
%     rateAdjustedEmgBytesToRead=1728; %UPSAMPLE ON - fs: 2000 Hz
% end

% set rateAdjustedEmgBytesToRead (Port-50043)
rateAdjustedEmgBytesToRead=960; %UPSAMPLE OFF - fs: 1111 Hz

% 3.4 Setup interface object to read chunks of data
% Define a callback function to be executed when desired number of bytes
% are available in the input buffer
 bytesToReadEMG = rateAdjustedEmgBytesToRead;
 interfaceObjectEMG.BytesAvailableFcn = {@localReadAndPlotMultiplexedEMG,plotHandlesEMG,bytesToReadEMG};
 interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
 interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
 
 drawnow
 start(t);

% 3.5 Open the interface object
try
    fopen(interfaceObjectEMG);
catch
    localCloseFigure(figureHandleEMG,1, interfaceObjectEMG, commObject, t);
    delete(figureHandleEMG);
    error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
end

% 3.6 Send the commands to start data streaming
fprintf(commObject, sprintf(['START\r\n\r']));

end

%% FUNCTIONS CALLED IN THE MIAN FUNCTION (EMG_SigProcess())

%% Function 1: Implement the bytes available callback
function localReadAndPlotMultiplexedEMG(interfaceObjectEMG, ~, ~, ~, ~)
%The localReadandPlotMultiplexed functions check the input buffers for the
%amount of available data, mod this amount to be a suitable multiple. 
%The EMG buffer is read in numbers of bytes that are divisible by 1728 by the
%formula (27 samples)*(4 bytes/sample)*(16 channels)
%Reading data in these amounts ensures that full packets are read. The size 
%limits on the dataArray buffers is to ensure that there is always 100 ms of
%data for all 4 sensors (EMG) in the dataArray buffers

global rateAdjustedEmgBytesToRead data_rawEMG
bytesReady = interfaceObjectEMG.BytesAvailable;
bytesReady = bytesReady - mod(bytesReady, rateAdjustedEmgBytesToRead);

if (bytesReady == 0)
    return
end
data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');
data = typecast(data, 'single');
% store EMG data with fixed size
if(size(data_rawEMG, 1) < rateAdjustedEmgBytesToRead*3) %40.5 ms - 3
    data_rawEMG = [data_rawEMG; data];
else
    data_rawEMG = [data_rawEMG(size(data,1) + 1:size(data_rawEMG, 1));data];
end

%     tIn = [tIn;toc(tStart)];
    
end

%% Function 2: Update the plots
function updatePlots(obj, Event, tmp)
%This timer callback function is called on every tick of the timer t.  It
%demuxes the dataArray buffers and assigns that channel to its respective
%plot.

global plotHandlesEMG data_rawEMG data_prcEMG data_prcEMG_noabs t_client mvc DATA_PUB tStart tOut tIn
   
if size(data_rawEMG, 1) > 0
  
    tIn = [tIn;toc(tStart)];
    
    % for loop to load and process data for each EMG channels
    for i = 1:size(plotHandlesEMG, 1)

        % empty the buffer for each sample frame (1*4 array)
        if i==1
            temp_1by4 = zeros(1,4);     % ??? why is this never used
        end       
        temp_mvc = mvc.(['mvc_ch' num2str(i)]);
        
        % process the EMG data (40ms)
        temp_40ms = double(data_rawEMG(i:16:end));  
        temp_40ms = filter_bandpass(1111,[10 500],temp_40ms) ; 
   
        %disp(temp_40ms)
        
        % data with pos/neg values % ??? NEEDED
        temp_40ms_pn = temp_40ms / temp_mvc * 100; 
        
        % data only with pos values % ??? NOT NEEDED
        temp_40ms_p = abs(temp_40ms) / temp_mvc * 100; 

        % get the average value from the 40ms EMG data
        temp_1by4_pn(:,i) = mean(temp_40ms_pn);
        temp_1by4_p(:,i) = mean(temp_40ms_p);
        
%         temp_nby4_pn(:,i) = temp_40ms_pn;
%         temp_nby4_p(:,i) = temp_40ms_p;
%         
        % update the plot
        if isempty(data_prcEMG)
            
        elseif size(data_prcEMG,1)<250
            set(plotHandlesEMG(i), 'Ydata', data_prcEMG(:,i));
        else
            set(plotHandlesEMG(i), 'Ydata', data_prcEMG(end-249:end,i));
        end
         
        % store (data_prcEMG) and publish data (t_client)
        if i==4
        
        % publish data
        %%%%currently sending pos and neg values (pn)%%%%
        temp_publish = single(temp_1by4_pn); 
                                            
        disp(temp_publish);
        if strcmp(DATA_PUB,'ON')
            write(t_client,temp_publish); %if not collecting data, comment this out
        end
        
%         % store timestamp
% %         timestamp = posixtime(datetime(datestr(clock,'YYYY-mm-dd HH:MM:SS.FFF'),...
% %         'TimeZone','America/New_York','InputFormat','yyyy-MM-dd HH:mm:ss.SSS'));      
% %         data_prcEMG = [data_prcEMG;[temp_1by4_p,timestamp]];

        data_prcEMG = [data_prcEMG;temp_1by4_p];
        data_prcEMG_noabs = [data_prcEMG_noabs;temp_1by4_pn];
        
%         data_prcEMG = [data_prcEMG;temp_nby4_p];
%         data_prcEMG_noabs = [data_prcEMG_noabs;temp_nby4_pn];    
        
        end
    end
   
    tOut = [tOut;toc(tStart)];
end

drawnow
end

%% Function 3: Implement the close figure callback
function localCloseFigure(figureHandle,~,interfaceObject1, commObject, t)
%This function is called whenever either figure is closed in order to close
%off all open connections.  It will close the EMG interface, ACC interface,
%commands interface, and timer object

global data_prcEMG data_prcEMG_noabs t_client DATA_PUB tOut tIn data_rawEMG FILENAME_EMG

% store data
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if size(data_prcEMG, 1) > 0
    %if not collecting data, comment this out vvvvvvv
    save([FILENAME_EMG '_' datestr(now,'yyyymmdd_HHMM') '.mat'],'data_rawEMG','data_prcEMG','data_prcEMG_noabs','tOut','tIn')
%     writematrix(data_prcEMG(:,1:4),[FILENAME_EMG '.xlsx'])
%     writematrix(data_prcEMG_noabs(:,1:4),[FILENAME_EMG '_noabs.xlsx'])
    %if not collecting data, comment this out vvvvvvv
    writematrix([data_prcEMG,data_prcEMG_noabs],[FILENAME_EMG '.xlsx'])
end

% clean up the data publisher client
if strcmp(DATA_PUB,'ON')
    fclose(t_client);
    delete(t_client);
    clear t_client;
end

% clean up the network objects
if isvalid(interfaceObject1)
    fclose(interfaceObject1);
    delete(interfaceObject1);
    clear interfaceObject1;
end

if isvalid(t)
   stop(t);
   delete(t);
end

if isvalid(commObject)
    fclose(commObject);
    delete(commObject);
    clear commObject;
end

% close the figure window
delete(figureHandle);

end

%% Function 4: Implement the bandpass filter
function filtered = filter_bandpass(fs,fc,data)
%This function is called during the EMG data process phase. 
%fs - sampling frequency; e.g., fs = 2000;
%fc - cutoff frequency; e.g., fc = [20 450];
%data - EMG raw data.

n = 2;
c = (((2^(1/n))-1)^(0.25)); % David A. Winter butterworth correction factor
Wc = 2*pi*fc; 				% angular cutoff frequency
Uc = tan(Wc/(2*fs)); 		% adjusted angular cutoff frequency
Un = Uc / c; 				% David A. Winter correction
f_corrected = atan(Un)*fs/pi;	% corrected cutoff frequency

[b,a]    = butter(n,f_corrected/(fs/2), 'bandpass');

filtered = filtfilt(b,a, data);

end


