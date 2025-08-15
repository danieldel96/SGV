function control_fnc()
global publish t_client
    d = evalin('base','all_data');
    set_zero = [];
    intens = sum(mean(abs(d)));
    disp('intens')
    disp(intens);
    emg_array_size = size(d);
    %     num_secs = evalin('base','num_secs');
    count = evalin('base','cnt');
    num_channels = evalin('base','num_channels');
 
    buff_size_w = 200; %window size
    buff_size_mcp = 200;
    emg_array_len = size(d,1);
%     disp(emg_array_len)
%     disp(d)
%     disp(emg_array_len>buff_size_w)
    count = emg_array_len; %NOTE: instead of changing every instance of count, replace with necessary variable (emg array length)
%     disp(count)
%     disp(count-buff_size_w+1)
    if(emg_array_len>buff_size_w && emg_array_len>buff_size_mcp)
        assignin('base','all_data',set_zero);
        assignin('base','cnt',0);

        if(count>=1000)
             emgs_w = d(1000-buff_size_w+1:1000,:);
             emgs_mcp = d(1000-buff_size_mcp+1:1000,:);
        else
            emgs_w = d(count-buff_size_w+1:count,:);
            emgs_mcp = d(count-buff_size_mcp+1:count,:);
        end
        
        input_point_w = mean(abs(emgs_w(:,1:4)));
        input_point_mcp = mean(abs(emgs_mcp(:,1:4)));
        control_grasp = evalin('base','control_grasp');
        control_wrist = evalin('base','control_wrist');
        output_period = evalin('base','output_period')/1000;
        if(control_grasp)
            net = evalin('base','grasp_net');
            new_pos_f = net(input_point_mcp');%TODO: Joseph please, what does this do
            if(new_pos_f>pi/2)
                new_pos_f=pi/2;
            elseif(new_pos_f<0)
                new_pos_f=0;
            end
%             last_pos = evalin('base','last_grasp_pos');
%             predicted_movement = (new_pos_f-last_pos)/output_period;
%             assignin('base','last_grasp_pos',new_pos_f)
%             grasp_velocities = evalin('base','grasp_velocities');
%             grasp_velocities(2:20) = grasp_velocities(1:19);
%             grasp_velocities(1) = predicted_movement;
%             assignin('base','grasp_velocities',grasp_velocities)
%             predicted_movement = mean(grasp_velocities(1:5));
%             v_f = predicted_movement;
            grasp_velocities = evalin('base','grasp_velocities');
            grasp_velocities(2:20) = grasp_velocities(1:19);
            grasp_velocities(1) = new_pos_f;
            assignin('base','grasp_velocities',grasp_velocities)
            v_f = (mean(grasp_velocities(1:5)) - mean(grasp_velocities(2:6)))/output_period;
            predicted_movement = v_f;
            use_threshold = 0; %evalin('base','use_threshold');
            move=1;
            
            %no threshold used in this mode
%             if(use_threshold)
%                 lower_thresh_grasp = evalin('base','lower_thresh_grasp');
%                 upper_thresh_grasp = evalin('base','upper_thresh_grasp');
%                 if(predicted_movement>lower_thresh_grasp && predicted_movement<upper_thresh_grasp)
%                     predicted_movement=0;
%                     move=0;
%                 end
%             end
            disp('predicted_movement')
            disp(predicted_movement)
            p_f=predicted_movement*0.05;
            if(abs(v_f)>1)
                if(predicted_movement>0) %hand close
                    disp('close')
                    publish = 1;

                else
                    disp('open') %hand open
                    publish = 0;

                end

            end
        end
                
        magnitude = 0;%new_pos_w;
        data = [publish;magnitude];
        data = single(data);
        fwrite(t_client, data, "single");
        
        if(control_wrist)
            net = evalin('base','wrist_net');
            new_pos_w = net(input_point_w');
            if(new_pos_w>pi/2)
                new_pos_w=pi/2;
            elseif(new_pos_w<-pi/2)
                new_pos_w=-pi/2;
            end
%             last_pos = evalin('base','last_wrist_pos');
%             predicted_movement = (new_pos_w-last_pos)/output_period;
%             assignin('base','last_wrist_pos',new_pos_w);
%             wrist_velocities = evalin('base','wrist_velocities');
%             wrist_velocities(2:20) = wrist_velocities(1:19);
%             wrist_velocities(1) = predicted_movement;
%             assignin('base','wrist_velocities',wrist_velocities);
%             predicted_movement = mean(wrist_velocities(1:5));
%             v_w = predicted_movement;
            wrist_velocities = evalin('base','wrist_velocities');
            wrist_velocities(2:20) = wrist_velocities(1:19);
            wrist_velocities(1) = new_pos_w;
            assignin('base','wrist_velocities',wrist_velocities)
            v_w = (mean(wrist_velocities(1:3)) - mean(wrist_velocities(2:4)))/output_period;
            predicted_movement = v_w;
            use_threshold = 0; %evalin('base','use_threshold');
            move=1;
            if(use_threshold)
                lower_thresh_wrist = evalin('base','lower_thresh_wrist');
                upper_thresh_wrist = evalin('base','upper_thresh_wrist');
                if(predicted_movement>lower_thresh_wrist && predicted_movement<upper_thresh_wrist)
                    predicted_movement=0;
                    move=0;
                end
            end
%             if(abs(v_w)>0)
%             p_w=predicted_movement*0.1;
                if(predicted_movement>0) %pronate
                    disp('pronate')
%                     publish = 3;
                else
                    disp('supinate') %supinate
%                     publish = 2;

                end

%                 magnitude = 0;
%                 data = [publish;magnitude];
%                 data = single(data);
%                 fwrite(t_client, data, "single");
%             end
        end
        
        magnitude = new_pos_w;% + 0.2
        data = [publish;magnitude];
        data = single(data);
        fwrite(t_client, data, "single");
        
        if(control_wrist && control_grasp)
            sprintf("Grasp: %.3f %.3f Wrist: %.3f %.3f", new_pos_f, v_f, new_pos_w, v_w)
            %AHA! finally understand the logic behind this
        end

    end
end