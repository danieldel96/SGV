clear;

net = narxnet(1:2,1:2,[5]);

num_channels = 4;
use_velocity = 0;
use_wrist = 0;
window_size = 1;
stride = 1;
motion_smoothing = 1;
emg_smoothing = 1;

% Load Data
myDir = "train_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, use_velocity, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
    if(k==1)
       all_emg = emg_data;
       all_mot = avg_mot_data;
    else
       all_emg = [all_emg; emg_data];
       all_mot = [all_mot; avg_mot_data];
    end   
    assignin('base','all_emg',all_emg)
    assignin('base','all_mot',all_mot)
end

X = tonndata(all_emg,false,false);
T = tonndata(all_mot,false,false);
[Xs,Xi,Ai,Ts] = preparets(net,X,{},T);
net = train(net,Xs,Ts,Xi,Ai);

% Load Data
myDir = "test_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, use_velocity, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);

    if(k==1)
       all_emg = emg_data;
       all_mot = avg_mot_data;
    else
       all_emg = [all_emg; emg_data];
       all_mot = [all_mot; avg_mot_data];
    end   
    assignin('base','all_emg',all_emg)
    assignin('base','all_mot',all_mot)
end

[Y,Xf,Af] = net(Xs,Xi,Ai);
perf = perform(net,Ts,Y)


X_test = tonndata(all_emg,false,false);
T_test = tonndata(all_mot,false,false);

netc = closeloop(net);
Y = netc(X_test);

plot(cell2mat(Y))
hold on
plot(all_mot)