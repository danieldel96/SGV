use_rectify = 1;
use_envelope = 1;
use_smoothing = 1;
use_velocity = 1;
use_wrist = 0;

load("train_data/4_test_1.mat");
[mot_data,emg_data] = get_data(all_data, use_rectify, use_envelope, use_smoothing, use_velocity, use_wrist);

input_point = [0 0];
buffer_size = 5000;
fifo_array = zeros(buffer_size,2);
processed_data = zeros(buffer_size,2);
actual = zeros(buffer_size,1);

all_pred = 0;
all_features = [0 0 0 0];

new_net = feedforwardnet(5);

myDir = "train_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    [mot_data,emg_data] = get_data(all_data, use_rectify, use_envelope, use_smoothing, use_velocity, smoothing, num_smoothing);
    for data_idx = 1:20000
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
               last_mean_f = input_point;
               input_point = mean(processed_data(1:window_size,:));
               diff_f = input_point-last_mean_f;
               feat = [input_point,diff_f];
               actual_movement = mot_data(data_idx,:);
               actual(2:buffer_size,:) = actual(1:buffer_size-1,:);
               actual(1,:) = actual_movement;
           else
               processed_data(2:buffer_size,:) = processed_data(1:buffer_size-1,:);
               processed_data(1,:) = new_data(1,:);
               pred(2:buffer_size,:) = pred(1:buffer_size-1,:);
               pred(1,:) = temp(1,:);
               actual(2:buffer_size,:) = actual(1:buffer_size-1,:);
               actual(1,:) = actual_movement;
           end
        end

        all_features = [all_features; feat];
        all_pred = [all_pred; temp(1,:)];
    end

    all_pred = all_pred(2:length(all_pred));
    all_features = all_features(2:length(all_features),:);

    new_net = train(new_net, all_features(5001:20000,:)',mot_data(5001:20000)')
end