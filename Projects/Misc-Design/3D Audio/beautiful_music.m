%Some great music
%play song
fig = uifigure('Name', 'Piano Song');
pnl = uipanel(fig, 'Position', [180,40,250,350]);
btn1 = uibutton(pnl,'Text', 'Play', 'Position', [30, 270, 50, 50], 'ButtonPushedFcn', @(btn1,event) btn1Pushed(btn1,event));
btn2 = uibutton(pnl,'Text', 'Spec', 'Position', [100, 270, 50, 50],'ButtonPushedFcn', @(btn2,event) btn2Pushed(btn2,event));

function btn1Pushed(btn1, event)
n = [ 130.81 138.59 146.83 155.56 164.81 174.61 185.00 196.00  207.65 220.00 233.08 261.63 277.18 293.67 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 493.88 523.25 554.37 597.33 622.25 659.26 698.46 739.99 783.99 830.61 880.00 932.33 987.77 1046.5 ];

max = 36;
m = zeros(1,max);

for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = n(i);
    else
    m(i) = n((max+1)-i);
    end
end
m

amplitude = 1; 
frequency = n(1); %hertz
length = 0.1; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

big_sound = amplitude * sin (2 * pi * frequency * time);
for c=1:max
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

for c=1:max
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

m=[ n(1) n(4) n(7) n(4) n(7) n(10) n(7) n(10) n(13) n(10) n(13) n(16) n(13) n(16) n(19) n(16) n(19) n(22) n(19) n(22) n(25) n(22) n(25) n(28) n(25) n(28) n(31) n(28) n(31) n(34) n(31) n(34) n(36) n(35) n(33) n(31) n(29) n(28) n(26) n(24) n(23) n(21) n(19) n(17) n(16) n(14) n(13) n(11) n(9) n(11) n(9) n(13) n(9) n(14) n(9) n(16) ];

for c=1:56
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

for c=1:56
    frequency = m(57-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
max = 56
for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = m(i);
    else
    m(i) = m((max+1)-i);
    end
end

for c=1:56
    frequency = m(57-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
max = 56
for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = m(i);
    else
    m(i) = m((max+1)-i);
    end
end

%shuffle chaos
idx = randperm(36);
xperm = n(idx);

for c=1:36
    frequency = xperm(37-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
idx = randperm(36);
xperm = n(idx);

for c=1:36
    frequency = xperm(37-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
new = zeros(1,36)
for i=1:36
    frequency = xperm(37-i); %hertz
    if( mod(i,2) == 0 )
        y = amplitude * sin (2 * pi * frequency * time);
    else
        frequency = n(i);
        y = amplitude * sin (2 * pi * frequency * time);
    end
    big_sound = [big_sound y];
end

for i=1:3
for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(19);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
for i=1:4
    frequency = n(22);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(28);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(36);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
end

for i=1:3
for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(19);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
for i=1:4
    frequency = n(22);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(28);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(36);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
end
soundsc(big_sound ,sampleRate);
audiowrite('beautiful-music.wav', big_sound, sampleRate);
end

function btn2Pushed(btn2, event)
n = [ 130.81 138.59 146.83 155.56 164.81 174.61 185.00 196.00  207.65 220.00 233.08 261.63 277.18 293.67 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 493.88 523.25 554.37 597.33 622.25 659.26 698.46 739.99 783.99 830.61 880.00 932.33 987.77 1046.5 ];

max = 36;
m = zeros(1,max);

for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = n(i);
    else
    m(i) = n((max+1)-i);
    end
end
m

amplitude = 1; 
frequency = n(1); %hertz
length = 0.1; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

big_sound = amplitude * sin (2 * pi * frequency * time);
for c=1:max
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

for c=1:max
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

m=[ n(1) n(4) n(7) n(4) n(7) n(10) n(7) n(10) n(13) n(10) n(13) n(16) n(13) n(16) n(19) n(16) n(19) n(22) n(19) n(22) n(25) n(22) n(25) n(28) n(25) n(28) n(31) n(28) n(31) n(34) n(31) n(34) n(36) n(35) n(33) n(31) n(29) n(28) n(26) n(24) n(23) n(21) n(19) n(17) n(16) n(14) n(13) n(11) n(9) n(11) n(9) n(13) n(9) n(14) n(9) n(16) ];

for c=1:56
    frequency = m(c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end

for c=1:56
    frequency = m(57-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
max = 56
for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = m(i);
    else
    m(i) = m((max+1)-i);
    end
end

for c=1:56
    frequency = m(57-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
max = 56
for i=1:max
    
    if( mod(i,2) == 0 )
        m(i) = m(i);
    else
    m(i) = m((max+1)-i);
    end
end

%shuffle chaos
idx = randperm(36);
xperm = n(idx);

for c=1:36
    frequency = xperm(37-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
idx = randperm(36);
xperm = n(idx);

for c=1:36
    frequency = xperm(37-c); %hertz
    y = amplitude * sin (2 * pi * frequency * time);
    
    big_sound = [big_sound y];

end
new = zeros(1,36)
for i=1:36
    frequency = xperm(37-i); %hertz
    if( mod(i,2) == 0 )
        y = amplitude * sin (2 * pi * frequency * time);
    else
        frequency = n(i);
        y = amplitude * sin (2 * pi * frequency * time);
    end
    big_sound = [big_sound y];
end

for i=1:3
for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(19);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
for i=1:4
    frequency = n(22);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(28);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(16);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(36);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
end

for i=1:3
for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(19);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
for i=1:4
    frequency = n(22);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(28);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(4);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end

for i=1:4
    frequency = n(36);
    y = amplitude * sin (2 * pi * frequency * time);
    big_sound = [big_sound y];
end
end
N = size(big_sound,2);
pxx = psd(spectrum.periodogram, big_sound, 'Fs', 44100, 'NFFT', N);
plot(pxx);

end