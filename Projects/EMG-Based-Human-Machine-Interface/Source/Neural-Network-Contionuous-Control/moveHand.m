% create global variables for data storage
global dataAll;
global timeAll;
global dataCount;
global tocTime;
global counter;
global chonkCounter;
global an1;
global an2;
global TrialTime;
% global an3;
% global an4;
global canch1
global messageout_hand
global messageout_flex
global messageout_rot
global WristEncOffset
global Desired_speed
global DOFDesired
global RotEncOut
global RotEncOutChunktmp
global RotEncOutChunk
global PWOut
global Fs
global dataChonkSize
global stop
global dq_out

dList = daq.getDevices;
deviceID = dList.ID;
measType = "Voltage";

dq_in = daq.createSession('ni');
dq_out = daq.createSession('ni');

% desired device ID
daqId = 'Dev1';

measurementType = "Voltage";

% add analog EMG channels
addAnalogInputChannel(dq_in,daqId,'ai0',measurementType);
addAnalogInputChannel(dq_in,daqId,'ai1',measurementType);
addAnalogInputChannel(dq_in,daqId,'ai2',measurementType);
addAnalogInputChannel(dq_in,daqId,'ai3',measurementType);

% add inputs and outputs
addAnalogOutputChannel(dq_out,deviceID,"ao0",measurementType); % wristP
addAnalogOutputChannel(dq_out,deviceID,"ao1",measurementType); % wristS
addAnalogOutputChannel(dq_out,deviceID,"ao2",measurementType); % graspC
addAnalogOutputChannel(dq_out,deviceID,"ao3",measurementType); % graspO

% Rotary Encoder PWM Out
addDigitalChannel(dq_in,daqId,'port0/line2', 'InputOnly');
% Rotary Encoder PWM Status
addDigitalChannel(dq_in,daqId,'port0/line3', 'InputOnly');

% set sampling rate, and set update calls to every 20 ms
Fs = 1000;
updateRate = 50;
dq_in.Rate = Fs;
dq_in.NotifyWhenDataAvailableExceeds = (1/updateRate)*Fs;

% add listener to call desired function
lh = addlistener(dq_in,'DataAvailable',@storeData);

% reset data
TrialTime = 5;
tocTime = zeros(dq_in.DurationInSeconds*updateRate + 5,1);
dataAll = zeros((dq_in.DurationInSeconds+5)*Fs,6);
timeAll = zeros((dq_in.DurationInSeconds+5)*Fs,1);
dataCount = zeros((dq_in.DurationInSeconds+5)*updateRate,1);

counter = 1;
chonkCounter = 1;
PWOut = [];
% start collection in background
dq_in.DurationInSeconds = TrialTime;

stop = 0;
pause(0.5);
startBackground(dq_in);

tic;
 outputSingleScan(dq_out,[1.5,0,0,0]);
while toc < TrialTime
    disp('Running')
    disp(toc);
    pause(.001);
end
outputSingleScan(dq_out,[0,0,0,0]);
plot(RotEncOut)
disp('Trial Complete');

%% PWM Calculation
PWOutOffline = dataAll(:,5);

W = pulsewidth(PWOutOffline,Fs);
D = dutycycle(PWOutOffline,Fs);

% go through chunks of 60 see if we can match calculation based on time on
% sensor type A in sensor docs
f_PWM = 122.07;
PW_min = 0.125;
t_PWM = 8192;

% in real-time, take average D from the data chunk as the reference angle

% duty cycle proportional to measured position from 0-360 deg
RotPosition = D*360;
Dchunk = dutycycle(PWOutOffline(1:60),Fs);



%%

function storeData(~,event)
    global TrialTime;
    global dataAll;
    global timeAll;
    global tocTime;
    global dataCount;
    global counter;
    global chonkCounter;
    global RotEncOut
    global Fs
    global RotEncOutChunktmp
    global PWOut
    global dataChonkSize
    global stop
    global dq_out
    
    dataChonkSize = length(event.TimeStamps);
    dataAll(counter:counter+(dataChonkSize-1),:) = event.Data;
    timeAll(counter:counter+(dataChonkSize-1)) = event.TimeStamps;
    dataCount(chonkCounter) = length(event.TimeStamps);
    tocTime(chonkCounter) = toc;
    
    % get rotary encoder output
    PWOut = [PWOut dataAll(counter:counter+(dataChonkSize-1),2)]; 

    RotEncOutChunktmp = dutycycle(dataAll(counter:counter+(dataChonkSize-1),5),Fs);
    RotEncOut(chonkCounter) = mean(RotEncOutChunktmp)*360;
    disp(RotEncOut(chonkCounter))
    counter = counter + dataChonkSize;
    chonkCounter = chonkCounter + 1;
    
%     err = 335-RotEncOut(chonkCounter)
%     if(abs(err)<=20||stop)
%         stop=1;
%         outputSingleScan(dq_out,[0,0,0,0]);
%     end
%     elseif(err>0)
%         outputSingleScan(dq_out,[err/20,0,0,0]);
%     elseif(err<0)
%         outputSingleScan(dq_out,[0,-err/20,0,0]);
%     end
end