function [t,orig_mot_data,avg_mot_data,emg_data] = get_data(save_data, use_velocity, use_wrist, window_size, stride, motion_smoothing, emg_smoothing)
    %Process EMG data
    save_data = save_data(2:length(save_data),:);
    num_channels = evalin('base','num_channels');
    emg_data = save_data(:,2:num_channels+1);
    if(use_velocity)
        if(use_wrist)
            mot_data = save_data(:,num_channels+5);
        else
            mot_data = save_data(:,num_channels+3);
        end
    else
        if(use_wrist)
            mot_data = save_data(:,num_channels+4)+pi/2;
        else
            mot_data = save_data(:,num_channels+2)/2;
        end
    end
    
    mot_data = smooth(mot_data,motion_smoothing);
    
    for i = 1:num_channels
        emg_data(:,i) = smooth(emg_data(:,i),emg_smoothing);
    end
    
    e = abs(emg_data(1:window_size,:));
    m = mot_data(1:window_size);
    if(window_size>1)
        e = mean(e);
        m = mean(m);
    end
    orig_mot_data = mot_data(window_size);
    time = save_data(:,1);
    t = time(window_size);
    for i = 1+stride:stride:length(emg_data)-window_size+1
        temp_e = abs(emg_data(i:i+window_size-1,:));
        temp_m = mot_data(i:i+window_size-1,:);
        if(window_size>1)
            temp_e = mean(temp_e);
            temp_m = mean(temp_m);
        end
        e = [e; temp_e];
        m = [m; temp_m];
        orig_mot_data = [orig_mot_data; mot_data(i+window_size-1)];
        t = [t,time(i+window_size-1)];
    end
    avg_mot_data=m;
    emg_data=[e];
end
