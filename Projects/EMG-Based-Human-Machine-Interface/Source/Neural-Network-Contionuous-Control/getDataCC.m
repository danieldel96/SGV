function getDataCC(interfaceObjectEMG,event)

% Gets data from daq for PR control
    %disp('getDataCC')
    warning('off');
    global dataAll;
    global rateAdjustedEmgBytesToRead;
    global interfaceObjectEMG
    global gain;
    global isCollectData
    global emg_timestamps
            
    try
        bytesReady = interfaceObjectEMG.BytesAvailable;
        bytesReady = bytesReady - mod(bytesReady, rateAdjustedEmgBytesToRead);%%1664
        if (mod(bytesReady, 2) || mod(bytesReady, rateAdjustedEmgBytesToRead) > 0)
            disp("WTF");
        elseif (bytesReady < rateAdjustedEmgBytesToRead)
            %disp(bytesReady);
            %disp('No Bytes Ready');
        else
            data = cast(fread(interfaceObjectEMG,bytesReady), 'uint8');
            data = typecast(data, 'single');
            %data = data * gain;
            % NEED TO GET INTO 1x4 array
            tmpGain = 10000;
            for i = 1:4
                temp(:,i) = data(i:16:end);
            end
            temp = temp * tmpGain;
            % disp(size(temp));
            if isCollectData
                time = toc;
                dataAll = [dataAll;temp];
                [rows, columns] = size(temp);
                stamps = time .* ones(rows,1);
                emg_timestamps = [emg_timestamps; stamps];

%                 disp(size(stamps))
            end
        end
            
    catch Exception
        disp(Exception);
    end

end