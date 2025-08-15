% Load Data
use_velocity=0;
use_wrist=1;
window_size=200;
stride=10;
motion_smoothing=100;
emg_smoothing=1;
num_channels=4;

myDir = "train_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, use_velocity, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
    if(~use_wrist && contains(filename,'wrist'))
        avg_mot_data(:,:) = avg_mot_data(:,:)*0;
    elseif(use_wrist && contains(filename,'hand'))
        avg_mot_data(:,:) = avg_mot_data(:,:)*0;
    end
    if(k==1)
       all_emg = emg_data;
       all_mot = avg_mot_data;
    else
       all_emg = [all_emg; emg_data];
       all_mot = [all_mot; avg_mot_data];
    end   
end


X=tonndata(all_emg,false,false);
Y=tonndata(all_mot,false,false);

inputDelays=0:5;
feedbackDelays=1:5;
hiddenLayerSize=[2];
net=narxnet(inputDelays,feedbackDelays,hiddenLayerSize,'closed');
net.performParam.normalization ='percent'
[inputs,inputStates,layerStates,targets] = preparets(net,X,{},Y);
[net,tr] = train(net,inputs,targets,inputStates,layerStates);
% net=closeloop(net);
% [inputs,inputStates,layerStates,targets] = preparets(net,X,{},Y);
% [net,tr] = train(net,inputs,targets,inputStates,layerStates);
% pred=net(inputs,inputStates,layerStates);

% Test Network
myDir = "test_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, use_velocity, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
    if(~use_wrist && contains(filename,'wrist'))
        avg_mot_data(:,:) = avg_mot_data(:,:)*0;
    elseif(use_wrist && contains(filename,'hand'))
        avg_mot_data(:,:) = avg_mot_data(:,:)*0;
    end
    if(k==1)
       all_emg = emg_data;
       all_mot = avg_mot_data;
    else
       all_emg = [all_emg; emg_data];
       all_mot = [all_mot; avg_mot_data];
    end   
end
X=tonndata(all_emg(900:1900,:),false,false);
Y=tonndata(all_mot(900:1900,:),false,false);
[inputs,inputStates,layerStates,targets] = preparets(net,X,{},Y);
pred=net(inputs,inputStates,layerStates);
pred=cell2mat(pred);
plot(pred);
hold on
plot(all_mot(900:1900,:))
pred=net(all_emg');
