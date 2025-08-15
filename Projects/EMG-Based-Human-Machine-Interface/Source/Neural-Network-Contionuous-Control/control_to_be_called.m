function control_to_be_called()
    cur_data = evalin('base','emg_data');
    %TODO: replace cur_data with or emg_data
%     cur_data = (cur_data/65535)*10-5;
     
    cnt = evalin('base','cnt');
    
    started = evalin('base','started');
    if started == 0
         assignin('base','all_data',cur_data);
         assignin('base','started',1);
    else
        output_period = evalin('base','output_period');
        if(mod(cnt,output_period)==0)
            control_fnc
        end
    end
        
         
      all_data = evalin('base','all_data');
      if(length(all_data)==1000)
          all_data(1:999,:) = all_data(2:1000,:);
          all_data(1000,:) = cur_data;
      else
          all_data = [all_data;cur_data];
      end
      if(mod(cnt,1000)==0 && cnt>=1000)
%           save(['emg_data/' num2str(cnt/1000) '.mat'], 'all_data')
      end
      assignin('base','all_data',all_data);
      assignin('base','cnt',cnt+1);
end