close all;
clear all;

%[FileReader, fs_sound] = audioread('RiverStreamAdjusted.wav');
FileReader = dsp.AudioFileReader('mono_forest_footsteps.wav', 'SamplesPerFrame', 11050, ...
    'PlayCount', 1);

audio = FileReader();

HRTFToUse = uigetfile(pwd, 'Select HRTF');
load(deblank(sprintf('%s', HRTFToUse)));



%set location to play
azimuths = [-80 -65 -55 -45:5:45 55 65 80];
elevations = -45 * 5.625*(0:49);

%right_aIndex = 11;
%left_aIndex = 15;
aIndex = 11;
eIndex = 1;

switchBool = 0;

while(~isDone(FileReader)) 
    
    
    wav_left = [];
    wav_right = [];
    soundToPlay = []; 
    
    lft = squeeze(hrir_l(aIndex, eIndex, :));
    rgt = squeeze(hrir_r(aIndex, eIndex, :));
    
    delay = ITD(aIndex, eIndex);
    
    if(aIndex < 13)
        lft = [lft' zeros(size(1:abs(delay)))];
        rgt = [zeros(size(1:abs(delay))) rgt'];
    else
        lft = [zeros(size(1:abs(delay))) lft'];
        rgt = [rgt' zeros(size(1:abs(delay)))];
    end
    
    wav_left = [wav_left conv(lft, audio')];
    wav_right = [wav_right conv(rgt, audio')];
    
    soundToPlay(:, 1) = wav_left;
    soundToPlay(:, 2) = wav_right;
    
    soundsc(soundToPlay);
    pause(0.5);
    audio = step(FileReader);
    
    if(switchBool == 0)
        aIndex = 15;
        switchBool = 1;
    end
    if(switchBool == 1)
        aIndex = 11;
        switchbool = 0;
    end
    
    
end





