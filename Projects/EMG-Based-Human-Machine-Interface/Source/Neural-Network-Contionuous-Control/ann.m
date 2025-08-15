function saved_net = ann(use_wrist, use_velocity, test_network, use_threshold, lower_thresh_grasp, upper_thresh_grasp, lower_thresh_wrist, upper_thresh_wrist, net_size, window_size, stride, emg_smoothing, motion_smoothing)
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
        %TODO: norm here
        assignin('base','all_emg',all_emg)
        assignin('base','all_mot',all_mot)
    end
    
    % Train Network
    saved_net = feedforwardnet(net_size);
    saved_net = init(saved_net);
    saved_net = train(saved_net,all_emg',all_mot');
    
    % Test Network
%     stride=10;
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
    end

    pred = saved_net(all_emg')';

    if(use_threshold)
        if(use_wrist)
            upper_thresh = upper_thresh_wrist;
            lower_thresh = lower_thresh_wrist;
        else
            upper_thresh = upper_thresh_grasp;
            lower_thresh = lower_thresh_grasp;
        end
        for i = 1:length(pred)
           if(pred(i) > lower_thresh && pred(i) < upper_thresh)
              pred(i) = 0; 
           end
        end
    end

    delta_t = stride/1000;
    t = [delta_t:delta_t:length(all_emg)*delta_t];
    
    figure(3)
    plot(pred,'--')
    hold on
    plot(all_mot)

    if(use_wrist)
        if(use_velocity)
            title('Wrist Velocity Estimations')
            ylabel('Velocity (rad/sec)')
        else
            title('Wrist Angle Estimations')
            ylabel('Position (rad)')
        end
    else
        if(use_velocity)
            title('Grasp Velocity Estimations')
            ylabel('Velocity (rad/sec)')
        else
            title('Grasp Angle Estimations')
            ylabel('Position (rad)')
        end
    end
    xlabel('time (sec)')
    legend('Estimated Motion', 'Measured Motion')
    grid on;
    assignin('base','pred',pred)
    assignin('base','mot_data',all_mot)
    [r,NRMSE] = calculate_metrics(pred,all_mot)
end