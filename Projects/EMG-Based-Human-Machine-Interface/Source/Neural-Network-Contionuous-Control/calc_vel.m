sample_point = 0;
velocity = 0;
cur_vel = 0;
sample_time = 0.001;
delta_t = sample_time;
grasp_position = all_data(:,num_channels+1);
last = grasp_position(1);
for i = 1:length(all_data)
    if(grasp_position(i)==last)
        delta_t = delta_t + sample_time;
    else
        cur_vel = (grasp_position(i) - last) / delta_t;
        delta_t = sample_time;
        last = grasp_position(i);
    end
    velocity = [velocity; cur_vel];
end

velocity = velocity(2:length(velocity));
yyaxis left
plot(grasp_position)
yyaxis right
plot(velocity)