myDir = "emg_data"; %gets directory
myFiles = dir(fullfile(myDir,'*.mat'));
for k = 1:length(myFiles)
    filename = myDir + "/" + myFiles(k).name
    load(filename);
    if(k==1)
        emg_total = all_data;
    else
        emg_total = [emg_total; all_data];
    end
end

for ii = 1:length(emg_total)
    if(emg_total(ii,1:4)==[-5 -5 -5 -5])
        emg_total(ii,:) = [0 0 0 0 0];
    end
end

% emg_total(emg_total==[-5 -5 -5 -5])=0;
save('emg_data.mat','emg_total')
figure(2)
plot(emg_total)