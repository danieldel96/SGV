function [features,mot_data,t_downsampled] = feature_extraction(emg_data,mot_data,t,overlap,window_size)

    sz = size(emg_data);
    sz = sz(1);

    mean_f = zeros(sz/window_size/overlap,2);
    new_mot_data = zeros(sz/window_size/overlap,1);
    f_idx = 1;
    for d_idx = 1:window_size*overlap:sz-window_size+1
        mean_f(f_idx,:) = mean(emg_data(d_idx:d_idx+window_size-1,:));
        new_mot_data(f_idx,:) = mean(mot_data(d_idx:d_idx+window_size-1,:));
        f_idx = f_idx+1;
    end
    mot_data = new_mot_data;
    
    sz = size(mean_f);
    sz = sz(1);
    diff_f = diff(mean_f);
    diff_f = [diff_f;diff_f(sz-1,:)];

    features = horzcat(mean_f,diff_f);
    features = mean_f;

    t_downsampled = linspace(0,ceil(max(t)),sz/window_size/overlap);

end