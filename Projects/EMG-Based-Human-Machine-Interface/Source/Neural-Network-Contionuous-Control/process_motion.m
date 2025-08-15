function process_motion(num_channels,sample_rate,num_secs,interp_method)

%EMG data
emg_data = evalin('base','emg_data');

%TODO: interpolation with different sized emg data/leap motion

all_data = evalin('base','all_data');
%t = all_data(:,num_channels+7); %emg data timestamps
t = evalin('base', 'emg_time');
% t = size(emg_data);
grasp_position = all_data(:,num_channels+1);
wrist_position = all_data(:,num_channels+6);
time_points = all_data(:,num_channels+8)%/1000; %why divide by 1000
sample_points_grasp = grasp_position(1);
sample_points_wrist = wrist_position(1);
sample_times = time_points(1);
%sample_times = 100;
%sample_times = size(emg_data);

for i = 1:length(grasp_position)
    if(grasp_position(i)~=sample_points_grasp(length(sample_points_grasp)))
        sample_points_grasp = [sample_points_grasp; grasp_position(i)];
        sample_points_wrist = [sample_points_wrist; wrist_position(i)];
        sample_times = [sample_times; time_points(i)];
    end
end
sample_points_grasp = [sample_points_grasp; grasp_position(i)];
sample_points_wrist = [sample_points_wrist; wrist_position(i)];
sample_times = [sample_times; time_points(i)];
assignin('base','sample_points_grasp',sample_points_grasp)
assignin('base','sample_points_wrist',sample_points_wrist)
assignin('base','sample_times',sample_times)

[sample_times,idx] = unique(sample_times);


disp('before interpolation')
disp('sample_times')
disp(size(sample_times))
disp(sample_times(10))
disp('sample_points_grasp')
disp(size(sample_points_grasp))
disp('emg_data')
disp(size(emg_data))
disp('emg_time')
disp(size(t))
disp(t(10))
disp('time_points')
disp(size(time_points))
disp(time_points(10))

%TODO: align timestamps for interpolation

interpolated_grasp = interp1(sample_times,sample_points_grasp(idx),t,interp_method);
interpolated_wrist = interp1(sample_times,sample_points_wrist(idx),t,interp_method);
grasp_velocity = diff(smooth(interpolated_grasp,200))/0.001;
grasp_velocity = [grasp_velocity; grasp_velocity(length(grasp_velocity))];
grasp_velocity(isnan(grasp_velocity))=0;
wrist_velocity = diff(interpolated_wrist)/0.001;
wrist_velocity = [wrist_velocity; wrist_velocity(length(wrist_velocity))];
wrist_velocity(isnan(wrist_velocity))=0;

%%%%%%%%
% interpolated_wrist = all_data(:,num_channels+6);
% interpolated_grasp = all_data(:,num_channels+1); % leap motion data
%%%%%%%%

disp('after interpolation')
disp(size(t))
disp(size(emg_data))
disp(size(interpolated_grasp))
disp(size(grasp_velocity))
disp(size(interpolated_wrist))
disp(size(wrist_velocity))

% = [t all_data(:,1:num_channels) interpolated_grasp grasp_velocity interpolated_wrist wrist_velocity]; %org 
 save_data = [t emg_data interpolated_grasp grasp_velocity interpolated_wrist wrist_velocity];


assignin('base','interpolated_grasp',interpolated_grasp)
assignin('base','grasp_velocity',grasp_velocity)
assignin('base','interpolated_wrist',interpolated_wrist)
assignin('base','wrist_velocity',wrist_velocity)
% assignin('base','emg_data',all_data(:,1:num_channels)) %this happens before, somewhere else
assignin('base','emg_data',emg_data) %this happens before, somewhere else
assignin('base','t',t)

assignin('base','save_data',save_data)

%TODO: solve 
figure(3)
yyaxis left
 plot(t,interpolated_grasp)
ylabel('Grasp Angle (rad)')
yyaxis right
plot(t,grasp_velocity)
ylabel('Grasp Velocity (rad/sec)')
title('Hand Motion')
xlabel('Time (sec)')

figure(4)
yyaxis left
plot(t,interpolated_wrist)
ylabel('Wrist Angle (rad)')
yyaxis right
plot(t,wrist_velocity)
ylabel('Wrist Velocity (rad/sec)')
title('Wrist Motion')
xlabel('Time (sec)')

figure(5)
%plot(t,all_data(:,1:num_channels))
plot(t,emg_data)
ylabel('EMG Signals (V)')
title('EMG Data')
xlabel('Time (sec)')