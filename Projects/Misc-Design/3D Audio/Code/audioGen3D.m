close all; 

[sig, fs_sound] = audioread('geese.wav');

HRTFToUse = uigetfile(pwd, 'Please select the HRTF you would like to use');
load(deblank(sprintf('%s', HRTFToUse))); 

wav_left = [];
wav_right = [];
soundToPlay = [];

%25 locations
azimuths = [-80 -65 -55 -45:5:45 55 65 80];

%50 locations
elevations = -45 + 5.625*(0:49); 

aIndex = 1;
eIndex = 9;

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


wav_left = [wav_left conv(lft, sig')];
wav_right = [wav_right conv(rgt, sig')];

soundToPlay(:, 1) = wav_left;
soundToPlay(:, 2) = wav_right;

%soundsc(soundToPlay, fs_sound);

audiowrite('geese_left.wav', soundToPlay, fs_sound);
