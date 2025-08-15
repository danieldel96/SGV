sample_rate = 1000;
num_secs = 20;
t = [0:1/sample_rate:num_secs];
grasp_position = all_data(:,num_channels+1);
wrist_position = all_data(:,num_channels+6);
time_points = all_data(:,num_channels+7);
sample_points_grasp = grasp_position(1);
sample_points_wrist = wrist_position(1);
sample_times = time_points(1);
for i = 1:length(grasp_position)
    if(grasp_position(i)~=sample_points_grasp(length(sample_points_grasp)))
        sample_points_grasp = [sample_points_grasp; grasp_position(i)];
        sample_points_wrist = [sample_points_wrist; wrist_position(i)];
        sample_times = [sample_times; time_points(i)];
    end
end

interpolated_grasp = interp1(sample_times,sample_points_grasp,t,'linear');
interpolated_wrist = interp1(sample_times,sample_points_wrist,t,'linear');
grasp_velocity = diff(interpolated_grasp)/0.001;
grasp_velocity = [grasp_velocity grasp_velocity(length(grasp_velocity))];
grasp_velocity(isnan(grasp_velocity))=0;
wrist_velocity = diff(interpolated_wrist)/0.001;
wrist_velocity = [wrist_velocity wrist_velocity(length(wrist_velocity))];
wrist_velocity(isnan(wrist_velocity))=0;

figure(1)
yyaxis left
plot(t,interpolated_grasp)
yyaxis right
plot(t,grasp_velocity)
title('Hand Motion')

figure(2)
yyaxis left
plot(t,interpolated_wrist)
yyaxis right
plot(t,wrist_velocity)
title('Wrist Motion')