function mat_to_be_called = mat_to_be_called()

    num_channels = evalin('base','num_channels');
%     cur_data = dataAll;
    cur_data = evalin('base','emg_data'); %not actually emg_data
%     disp('In mat_to_be_called')
%     disp(size(cur_data))
    
    cur_data(:,1:num_channels) = (cur_data(:,1:num_channels) / 65535)*10 - 5; %binary value from emg system (daq)
     
    cnt = cur_data(1,num_channels+7); %time steps
     
    cur_data(:,num_channels+7) = cur_data(:,num_channels+7) / 1000; %divide by 1000 to get to seconds
     
    q = quaternion(cur_data(num_channels+2), cur_data(num_channels+3), cur_data(num_channels+4), cur_data(num_channels+5)); %wrist data
    eul = quat2eul(q);
    wrist_angle = eul(3);
    if(wrist_angle>2.5)
        wrist_angle = wrist_angle - 2*pi;
    end
    cur_data(num_channels+6) = wrist_angle;

    if cur_data(1,num_channels+7) == 0
         assignin('base','all_data',cur_data);
    else
        collecting = evalin('base','collecting');
        if(collecting)
              %sprintf('Time: \t %.3f \t Grasp Angle: \t %.3f \t Wrist Angle: \t %.3f \t EMG1: \t %.3f', cur_data(1,num_channels+7), cur_data(1,num_channels+1), cur_data(1,num_channels+6), cur_data(1,1))
        else
            if(mod(cnt,20)==0)
                control_fnc
            end
%             if(mod(cnt,200)==0)
%                 predictions = evalin('base','predictions');
%                 figure(2)
%                 plot(predictions)
%             end
        end
        
         
          all_data = evalin('base','all_data');
          new_data = vertcat(all_data,cur_data);
          assignin('base','all_data',new_data);
    end
end