close all;
clear all;

%[FileReader, fs_sound] = audioread('RiverStreamAdjusted.wav');
FileReader = dsp.AudioFileReader('RiverStreamAdjusted.wav', 'SamplesPerFrame', 11050, ...
    'PlayCount', 1);

audio = FileReader();

HRTFToUse = uigetfile(pwd, 'Select HRTF');
load(deblank(sprintf('%s', HRTFToUse)));



%set location to play
azimuths = [-80 -65 -55 -45:5:45 55 65 80];
elevations = -45 * 5.625*(0:49);

aIndex = 1;
eIndex = 9;

frontHalf = 1;

i = 0;

while(~isDone(FileReader))
    
    wav_left = [];
    wav_right = [];
    soundToPlay = [];
    
    if(frontHalf == 1)
        aIndex = aIndex + 1;
    end
    
    if(frontHalf == 0)
        aIndex = aIndex - 1;
    end
    
    if(aIndex == 26 && frontHalf == 1)
        aIndex = 24;
        frontHalf = 0;
        eIndex = 41;
    end
    
    if(aIndex == 0 && frontHalf == 0)
        aIndex = 1;
        eIndex = 9;
        frontHalf = 1;
    end

    lft = squeeze(hrir_l(aIndex, eIndex, :));
    rgt = squeeze(hrir_r(aIndex, eIndex, :));

    delay = ITD(aIndex, eIndex);

    %if sound is on left, delay right ear
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
    pause(1);
    audio = step(FileReader);
    
    filename = sprintf('%s%d.wav', 'hw4_test_', i);
    audiowrite(filename, soundToPlay, 44100);
    
    i = i + 1;
end







