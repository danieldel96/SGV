% clear;clc;
% Load Data
use_velocity=1;
use_wrist=0;
window_size=200;
stride=1;
motion_smoothing=100;
emg_smoothing=1;
num_channels=4;
net_size=[4];
finger_stiff=0.2;
finger_damp=0.3;
finger_inetia=0.019;
wrist_stiff=0.2;
wrist_damp=0.3;
wrist_inertia=0.0022;

myDir = "train_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    if(contains(filename,'rest'))
        [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        avg_vel_data(:,:) = avg_mot_data(:,:)*0;
        [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        avg_pos_data(:,:) = avg_mot_data(:,:)*0;
    end
    if(~use_wrist)
        if(contains(filename,'wrist'))
            if(contains(filename,'closed'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*pi/2;
            elseif(contains(filename,'open'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            else
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            end
        else
            [t,orig_mot_data,avg_vel_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
            [t,orig_mot_data,avg_pos_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        end
    end
    if(use_wrist)
        if(contains(filename,'hand'))
            if(contains(filename,'pro'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*pi/2;
            elseif(contains(filename,'sup'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*-pi/2;
            else
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            end
        else
            [t,orig_mot_data,avg_vel_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
            [t,orig_mot_data,avg_pos_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        end
    end
    if(k==1)
       all_emg = emg_data;
       all_pos = avg_pos_data;
       all_vel = avg_vel_data;
    else
       all_emg = [all_emg; emg_data];
       all_pos = [all_pos; avg_pos_data];
       all_vel = [all_vel; avg_vel_data];
    end   
end

accel=diff(all_vel)/stride*1000;
accel=[accel; accel(length(accel))];
vel=all_vel;
pos=all_pos;


if(use_wrist)
    I=wrist_inertia;
    stiffness=wrist_stiff;
    damping = wrist_damp;
else
    I=finger_inetia;
    stiffness=finger_stiff;
    damping=finger_damp;
end

torque=accel.*I+vel.*damping+pos.*stiffness;

if(use_wrist)
    wrist_net = feedforwardnet(net_size,'trainlm');
    wrist_net = train(wrist_net,all_emg',torque');
else
    grasp_net = feedforwardnet(net_size,'trainlm');
    grasp_net = train(grasp_net,all_emg',torque');  
end


myDir = "test_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    if(contains(filename,'rest'))
        [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        avg_vel_data(:,:) = avg_mot_data(:,:)*0;
        [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        avg_pos_data(:,:) = avg_mot_data(:,:)*0;
    end
    if(~use_wrist)
        if(contains(filename,'wrist'))
            if(contains(filename,'closed'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*pi/2;
            elseif(contains(filename,'open'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            else
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            end
        else
            [t,orig_mot_data,avg_vel_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
            [t,orig_mot_data,avg_pos_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        end
    end
    if(use_wrist)
        if(contains(filename,'hand'))
            if(contains(filename,'pro'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*pi/2;
            elseif(contains(filename,'sup'))
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = ones(size(avg_mot_data(:,:)))*-pi/2;
            else
                [t,orig_mot_data,avg_vel_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_vel_data(:,:) = avg_mot_data(:,:)*0;
                [t,orig_mot_data,avg_pos_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
                avg_pos_data(:,:) = avg_mot_data(:,:)*0;
            end
        else
            [t,orig_mot_data,avg_vel_data,emg_data] = get_data(save_data, 1, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
            [t,orig_mot_data,avg_pos_data,emg_data] = get_data(save_data, 0, use_wrist, window_size, stride, motion_smoothing, emg_smoothing);
        end
    end
    if(k==1)
       all_emg = emg_data;
       all_pos = avg_pos_data;
       all_vel = avg_vel_data;
    else
       all_emg = [all_emg; emg_data];
       all_pos = [all_pos; avg_pos_data];
       all_vel = [all_vel; avg_vel_data];
    end   
end

accel=diff(all_vel)/stride*1000;
accel=[accel; accel(length(accel))];
vel=all_vel;
pos=all_pos;


if(use_wrist)
    I=wrist_inertia;
    stiffness=wrist_stiff;
    damping = wrist_damp;
else
    I=finger_inetia;
    stiffness=finger_stiff;
    damping=finger_damp;
end

torque=accel.*I+vel.*damping+pos.*stiffness;
if(use_wrist)
    pred_torque = wrist_net(all_emg');
else
    pred_torque = grasp_net(all_emg');
end

figure(1)
plot(pred_torque,'--')
hold on
plot(torque)
legend('Estimated Torque', 'Measured Torque')

if(use_wrist)
   t=wrist_net(all_emg(1,:)');
else
    t=grasp_net(all_emg(1,:)');
end
a=(pred_torque(1))/I;
v = a*stride/1000;
p = v*stride/1000;

all_vel=v;
all_pos=p;
all_acc=a;
all_t=t;

if(use_wrist)
    t=wrist_net(all_emg(:,:)');
else
    t=grasp_net(all_emg(:,:)');
end

% t=torque;

for i = 2:length(pred_torque)
    if(use_wrist)
        if(p>=pi)
            p=pi;
            if(v>0)
                v=0;
            end
        elseif(p<=-pi)
            p=-pi;
            if(v<0)
                v=0;
            end
        end
    else
        if(p>=pi/2)
            p=pi/2;
            if(v>0)
                v=0;
            end
        elseif(p<=0)
            p=0;
            if(v<0)
                v=0;
            end
        end
    end
    a=(t(i)-damping*v-stiffness*p)/I;
    v=v+a*stride/1000;
    p=p+v*stride/1000;
    all_acc=[all_acc;a];
    all_vel=[all_vel;v];
    all_pos=[all_pos;p];
end

figure(3)
plot(all_pos,'--')
hold on
plot(pos)
legend('Estimated Position', 'Measured Position')

figure(4)
plot(all_vel,'--')
hold on
plot(vel)
legend('Estimated Velocity', 'Measured Velocity')
