use_rectify = 0;
use_envelope = 0;
use_smoothing = 1;
use_velocity = 1;
use_threshold = 1;
threshold = 0.075;
smooth_output = 1;
smoothing_out = 2;
gain = 2;
smoothing = 100;
num_smoothing = 20;

load("test_data/6_test_15.mat");
[mot_data,emg_data] = get_data(all_data, use_rectify, use_envelope, use_smoothing, use_velocity, smoothing, num_smoothing);
load("test_data/4_test_35.mat");
[mot_data_2,emg_data_2] = get_data(all_data, use_rectify, use_envelope, use_smoothing, use_velocity, smoothing, num_smoothing);

mot_data = [mot_data; mot_data_2];
emg_data = [emg_data; emg_data_2];

mean_f = [0 0];
diff_f = [0 0];
feat = [mean_f,diff_f*2];

buffer_size = 10000;
window_size = 50;
fifo_array = zeros(buffer_size,2);
processed_data = zeros(buffer_size,2);
pred = zeros(buffer_size,1);
actual = zeros(buffer_size,1);
temp = zeros(buffer_size,1);

all_pred = 0;
all_features = [0 0 0 0];

% [mot_data,emg_data] = get_data(all_data, use_rectify, use_envelope, use_smoothing, use_velocity, smoothing, num_smoothing);
for data_idx = 1:length(mot_data)
    fifo_array(2:buffer_size,:) = fifo_array(1:buffer_size-1,:);
    fifo_array(1,:) = emg_data(data_idx,:);
    if(data_idx >= buffer_size)
       if(mod(data_idx,25)==0)
           new_data = normalize(envelope(abs(fifo_array),1000,'rms'));
           processed_data(2:buffer_size,:) = processed_data(1:buffer_size-1,:);
           processed_data(1,:) = new_data(1,:);
           for i = 1:10
               processed_data(:,1) = smooth(processed_data(:,1),10);
               processed_data(:,2) = smooth(processed_data(:,2),10);
           end
           last_mean_f = mean_f;
           mean_f = mean(processed_data(1:window_size,:));
           diff_f = mean_f-last_mean_f;
           feat = [mean_f,diff_f*2];
           predicted_movement = net(feat');
           if(use_threshold & abs(predicted_movement)<threshold)
               predicted_movement = 0;
           end
           if(smooth_output)
               predicted_movement = (predicted_movement+sum(pred(1:smoothing_out-1)))/smoothing_out;
           end
           actual_movement = mot_data(data_idx,:);
           pred(2:buffer_size,:) = pred(1:buffer_size-1,:);
           pred(1,:) = predicted_movement;
           temp = pred;
           for i = 1:10
               temp = smooth(temp,10);
           end
           pred(1,:) = temp(1,:);
           actual(2:buffer_size,:) = actual(1:buffer_size-1,:);
           actual(1,:) = actual_movement;
           figure(1)
           plot(processed_data)
           figure(2)
           plot(pred*gain)
           hold on
           plot(actual)
           ylim([-0.5 0.5])
           hold off
           pause(0.00001);
       else
           processed_data(2:buffer_size,:) = processed_data(1:buffer_size-1,:);
           processed_data(1,:) = new_data(1,:);
           pred(2:buffer_size,:) = pred(1:buffer_size-1,:);
           pred(1,:) = temp(1,:);
           actual(2:buffer_size,:) = actual(1:buffer_size-1,:);
           actual(1,:) = actual_movement;
       end
    elseif(mod(data_idx,25)==0)
        plot(fifo_array)
        pause(0.00001);
    end

    all_features = [all_features; feat];
    all_pred = [all_pred; temp(1,:)];
end

all_pred = all_pred(2:length(all_pred));
all_features = all_features(2:length(all_features),:);
