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

function Delsys_EMG_Collection

global plotHandlesEMG DATA_PUB t_client rateAdjustedEmgBytesToRead FILENAME_EMG mvc
% CHANGE THIS TO THE IP OF THE COMPUTER RUNNING THE TRIGNO CONTROL UTILITY
HOST_IP = 'localhost';
%%


% CHANGE THIS TO THE PARTICIPANT ID # (FROM OFFSET_MVC.XLSX)
PAR_ID = 814;

% CHANGE THIS ('ON'/'OFF') TO OPEN OR CLOSE THE DATA PUBLISHER
DATA_PUB = 'ON'; % 'ON'/'OFF'

% FILENAME TO SAVE DATA OUT
FILENAME_EMG = 'test';


%% Create the required objects

% Define number of sensors
NUM_SENSORS = 4;

% Read MVC & offset values
filename_cal = 'mvc_offset.xlsx';
mvc = readtable(filename_cal);
mvc = mvc(mvc.participant==PAR_ID,:);% read MVC & offset values

%handles to all plots

plotHandlesEMG = zeros(NUM_SENSORS,1);
% global plotHandlesACC;
% plotHandlesACC = zeros(NUM_SENSORS*3, 1);

%TCPIP Connection to stream EMG Data
interfaceObjectEMG = tcpip(HOST_IP,50043);
interfaceObjectEMG.InputBufferSize = 6400;

%TCPIP Connection to stream ACC Data
% interfaceObjectACC = tcpip(HOST_IP,50042);
% interfaceObjectACC.InputBufferSize = 6400;

%TCPIP Connection to communicate with SDK, send/receive commands
commObject = tcpip(HOST_IP,50040);

% TCPIP Connection to publish processed EMG data
if strcmp(DATA_PUB,'ON')
    t_client = tcpclient('127.0.0.1', 8080);
end

%Timer object for drawing plots.
t = timer('Period', .01, 'ExecutionMode', 'fixedSpacing', 'TimerFcn', {@updatePlots, plotHandlesEMG});
global data_arrayEMG data_toFile
data_arrayEMG = [];
data_toFile = [];
% global data_arrayACC
% data_arrayACC = [];

%% Set up the plots


axesHandlesEMG = zeros(NUM_SENSORS,1);
% axesHandlesACC = zeros(NUM_SENSORS,1);

%initiate the EMG figure
figureHandleEMG = figure('Name', 'EMG Data','Numbertitle', 'off',  'CloseRequestFcn', {@localCloseFigure, interfaceObjectEMG, commObject, t});
set(figureHandleEMG, 'position', [50 200 750 750])

for i = 1:NUM_SENSORS
    axesHandlesEMG(i) = subplot(4,4,i);

    plotHandlesEMG(i) = plot(axesHandlesEMG(i),0,'-y','LineWidth',1);

    set(axesHandlesEMG(i),'YGrid','on');
    %set(axesHandlesEMG(i),'YColor',[0.9725 0.9725 0.9725]);
    set(axesHandlesEMG(i),'XGrid','on');
    %set(axesHandlesEMG(i),'XColor',[0.9725 0.9725 0.9725]);
    set(axesHandlesEMG(i),'Color',[.15 .15 .15]);
    set(axesHandlesEMG(i),'YLim', [-.005 .005]);
    set(axesHandlesEMG(i),'YLimMode', 'manual');
    set(axesHandlesEMG(i),'XLim', [0 2000]);
    set(axesHandlesEMG(i),'XLimMode', 'manual');
    
    if(mod(i, 4) == 1)
        ylabel(axesHandlesEMG(i),'V');
    else
        set(axesHandlesEMG(i), 'YTickLabel', '')
    end
    
    if(i >12)
        xlabel(axesHandlesEMG(i),'Samples');
    else
        set(axesHandlesEMG(i), 'XTickLabel', '')
    end
    
    title(sprintf('EMG %i', i)) 
end


%%Open the COM interface, determine RATE
fopen(commObject);

pause(1);
%% fread(commObject,commObject.BytesAvailable);
fprintf(commObject, sprintf(['RATE 2000\r\n\r']));
pause(1);
%% fread(commObject,commObject.BytesAvailable);
fprintf(commObject, sprintf(['RATE?\r\n\r']));
pause(1);
%% data = fread(commObject,commObject.BytesAvailable);

% emgRate = strtrim(char(data'));
% if(strcmp(emgRate, '1925.926'))
%     rateAdjustedEmgBytesToRead=1664;
% else 
     rateAdjustedEmgBytesToRead=NUM_SENSORS*16*4;
% end


%% Setup interface object to read chunks of data
% Define a callback function to be executed when desired number of bytes
% are available in the input buffer
 bytesToReadEMG = rateAdjustedEmgBytesToRead;
 interfaceObjectEMG.BytesAvailableFcn = {@localReadAndPlotMultiplexedEMG,plotHandlesEMG,bytesToReadEMG};
 interfaceObjectEMG.BytesAvailableFcnMode = 'byte';
 interfaceObjectEMG.BytesAvailableFcnCount = bytesToReadEMG;
 
%  bytesToReadACC = 384;
% interfaceObjectACC.BytesAvailableFcn = {@localReadAnPlotMultiplexedACC, plotHandlesACC, bytesToReadACC};
% interfaceObjectACC.BytesAvailableFcnMode = 'byte';
% interfaceObjectACC.BytesAvailableFcnCount = bytesToReadACC;

drawnow
start(t);

%pause(1);
%% 
% Open the interface object
try
    fopen(interfaceObjectEMG);
%     fopen(interfaceObjectACC);
catch
    localCloseFigure(figureHandleACC,1 ,interfaceObjectACC, interfaceObjectEMG, commObject, t);
    delete(figureHandleEMG);
    error('CONNECTION ERROR: Please start the Delsys Trigno Control Application and try again');
end



%%
% Send the commands to start data streaming
fprintf(commObject, sprintf(['START\r\n\r']));


%%
% Display the plot

%snapnow;


%% Implement the bytes available callback
%The localReadandPlotMultiplexed functions check the input buffers for the
%amount of available data, mod this amount to be a suitable multiple.

%Because of differences in sampling frequency between EMG and ACC data, the
%ratio of EMG samples to ACC samples is 13.5:1

%We use a ratio of 27:2 in order to keep a whole number of samples.  
%The EMG buffer is read in numbers of bytes that are divisible by 1728 by the
%formula (27 samples)*(4 bytes/sample)*(16 channels)
%The ACC buffer is read in numbers of bytes that are divisible by 384 by
%the formula (2 samples)*(4 bytes/sample)*(48 channels)
%Reading data in these amounts ensures that full packets are read.  The 
%size limits on the dataArray buffers is to ensure that there is always one second of
%data for all 16 sensors (EMG and ACC) in the dataArray buffers
function localReadAndPlotMultiplexedEMG(interfaceObjectEMG, ~,~,~, ~)
global rateAdjustedEmgBytesToRead DATA_PUB t_client mvc
% tic()
bytesReady = interfaceObjectEMG.BytesAvailable;
bytesReady = bytesReady - mod(bytesReady, rateAdjustedEmgBytesToRead);%%1664

if (bytesReady == 0)
    return
end
global data_arrayEMG data_toFile
data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');
data = typecast(data, 'single');

if(any(data))
    %coefficient 7 ~ 100ms window: 0.0135 * 7
    %coefficient 15 ~ 200ms window: 0.0135 * 15
    if(size(data_arrayEMG, 1) < 100) %window size 
        data_arrayEMG = [data_arrayEMG; data];

    else
        %data_arrayEMG = [data_arrayEMG(size(data,1) + 1:size(data_arrayEMG, 1));data];
        data_arrayEMG = [data_arrayEMG;data];
        data_arrayEMG(1:length(data),:) = []; 

    end

end


%SEND OUT OR WRITE TO FILE EACH data_arrayEMG is new packet received.
if size(data_arrayEMG, 1) > 0     
    
    for i = 1:4
        % Convert data_arrayEMG to doubles for filter_bandpass()
        temp(:,i) = double(data_arrayEMG(i:16:end));
    end
%     disp(size(temp));

    temp_filtered = filter_bandpass(1111,[20 450],temp);
    
    temp_avg = mean(temp_filtered);
    
    data_toFile = [data_toFile;temp_avg]; %data to file
    
    data_to_publish = single(temp_avg);
    disp(size(data_to_publish));
    
    if strcmp(DATA_PUB,'ON')
        write(t_client,data_to_publish);
    else
        disp(data_to_publish);
    end



    % timeAll = [timeAll;event.TimeStamps];
    % dataRecent = [dataRecent;temp];


%     graspO = dataRecent(:,1); % recent data from input channel 1
%     graspC = dataRecent(:,2); % recent data from input channel 2



    % 
    %     % NORMALIZE BEFORE FILTER?
    %     % temp_normalized = temp / temp_mvc * 100; 
    %     
    %     
    %     % Pass data through filter
    %     temp_filtered = filter_bandpass(1111,[20 450],temp);
    %     % NORMALIZE AFTER FILTER?

    % 
    %     %Yue takes abs before normalizing in OG code. Should we take abs before or after
    %     %normalizing?
    %     %temp_filtered = abs(temp_filtered);
    % 
    %     % multiplied by 1e6 arbitrarily
    %     temp_norm = (temp_filtered / temp_mvc ) * 100;

    %     
    %     %temp_avg 1by4, same as to publish
    %      temp_avg(:,i) = mean(temp_norm);

    %     % data is the same before being published and saved
    %     data_to_publish = single(temp_avg);
    % 


    % %     if i ==4
    %         
    %      %temp_avg 1by4, same as to publish
    % %      temp_avg(:,i) = mean(temp_norm);

    % 

    % %       data_to_publish = single(temp_avg);

    %       
    % %     
    %     
    % %         toc()
    % %         for j=1:size(temp_norm,1)
    % % 
    % %             data_to_publish = single(temp_norm(j,:));          
    % % 
    % %             data_toFile = [data_toFile; temp_norm(j,:)];
    %             data_toFile = [data_toFile; temp_avg];
    % %           
    %             if strcmp(DATA_PUB,'ON')
    %                 write(t_client,data_to_publish);
    %             else
    %                 disp(data_to_publish);
    % 
    %             end
    % %         end
    % %     end
    %     
    %     



        
end
%disp('END')
%temp = double(data_arrayEMG);
%data_arrayEMG_filtered = filter_bandpass(1111,[10 500],data_arrayEMG) ;
% 
% function localReadAnPlotMultiplexedACC(interfaceObjectACC, ~, ~, ~, ~)
% 
% bytesReady = interfaceObjectACC.BytesAvailable;
% bytesReady = bytesReady - mod(bytesReady, 384);
% 
% if(bytesReady == 0)
%     return
% end
% global data_arrayACC
% data = cast(fread(interfaceObjectACC, bytesReady), 'uint8');
% data = typecast(data, 'single');
% 
% 
% 
% 
% 
% if(size(data_arrayACC, 1) < 7296)
%     data_arrayACC = [data_arrayACC; data];
% else
%     data_arrayACC = [data_arrayACC(size(data, 1) + 1:size(data_arrayACC, 1)); data];
% end


%% Update the plots
%This timer callback function is called on every tick of the timer t.  It
%demuxes the dataArray buffers and assigns that channel to its respective
%plot.
function updatePlots(obj, Event,  tmp)
global data_arrayEMG
global plotHandlesEMG
for i = 1:size(plotHandlesEMG, 1) 
    data_ch = data_arrayEMG(i:16:end);      
    set(plotHandlesEMG(i), 'Ydata', data_ch)
end
% global data_arrayACC
% global plotHandlesACC
% for i = 1:size(plotHandlesACC, 1)
%     data_ch = data_arrayACC(i:48:end);
%     set(plotHandlesACC(i), 'Ydata', data_ch)
% end
drawnow
    


%% Implement the close figure callback
%This function is called whenever either figure is closed in order to close
%off all open connections.  It will close the EMG interface, ACC interface,
%commands interface, and timer object
function localCloseFigure(figureHandle,~,interfaceObject1, commObject, t)
global DATA_PUB data_toFile FILENAME_EMG t_client
%% 
if strcmp(DATA_PUB,'OFF')
    if size(data_toFile, 1) > 0
        save([FILENAME_EMG '_' datestr(now,'yyyymmdd_HHMM') '.mat'],'data_toFile')
        writematrix([data_toFile],[FILENAME_EMG '.xlsx'])
    end
end

% Clean up the network objects
if isvalid(interfaceObject1)
    fclose(interfaceObject1);
    delete(interfaceObject1);
    clear interfaceObject1;
end
% if isvalid(interfaceObject2)
%     fclose(interfaceObject2);
%     delete(interfaceObject2);
%     clear interfaceObject2;
% end

% clean up the data publisher client
if strcmp(DATA_PUB,'ON')
    %fclose(t_client);
    %flush(t_client);
    delete(t_client);
    clear t_client;
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

%% 
% Close the figure window
delete(figureHandle);

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