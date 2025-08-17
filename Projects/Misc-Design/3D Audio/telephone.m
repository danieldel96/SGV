fig = uifigure('Name', 'Telephone');
pnl = uipanel(fig, 'Position', [180,40,250,350]);
btn1 = uibutton(pnl,'Text', '1', 'Position', [30, 270, 50, 50], 'ButtonPushedFcn', @(btn1,event) btn1Pushed(btn1,event));
btn2 = uibutton(pnl,'Text', '2', 'Position', [100, 270, 50, 50],'ButtonPushedFcn', @(btn2,event) btn2Pushed(btn2,event));
btn3 = uibutton(pnl,'Text', '3', 'Position', [170, 270, 50, 50],'ButtonPushedFcn', @(btn3,event) btn3Pushed(btn3,event));
btn4 = uibutton(pnl,'Text', '4', 'Position', [30, 200, 50, 50],'ButtonPushedFcn', @(btn4,event) btn4Pushed(btn4,event));
btn5 = uibutton(pnl,'Text', '5', 'Position', [100, 200, 50, 50],'ButtonPushedFcn', @(btn5,event) btn5Pushed(btn5,event));
btn6 = uibutton(pnl,'Text', '6', 'Position', [170, 200, 50, 50],'ButtonPushedFcn', @(btn6,event) btn6Pushed(btn6,event));
btn7 = uibutton(pnl,'Text', '7', 'Position', [30, 130, 50, 50],'ButtonPushedFcn', @(btn7,event) btn7Pushed(btn7,event));
btn8 = uibutton(pnl,'Text', '8', 'Position', [100, 130, 50, 50],'ButtonPushedFcn', @(btn8,event) btn8Pushed(btn8,event));
btn9 = uibutton(pnl,'Text', '9', 'Position', [170, 130, 50, 50],'ButtonPushedFcn', @(btn9,event) btn9Pushed(btn9,event));
btnStar = uibutton(pnl,'Text', '*', 'Position', [30, 60, 50, 50],'ButtonPushedFcn', @(btnStar,event) btnStarPushed(btnStar,event));
btn0 = uibutton(pnl,'Text', '0', 'Position', [100, 60, 50, 50],'ButtonPushedFcn', @(btn0,event) btn0Pushed(btn0,event));
btnPound = uibutton(pnl,'Text', '#', 'Position', [170, 60, 50, 50],'ButtonPushedFcn', @(btnPound,event) btnPoundPushed(btnPound,event));


function btn1Pushed(btn1,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 1 is pressed
frequency = 697; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1209;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn2Pushed(btn2,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 2 is pressed
frequency = 697; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1366;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn3Pushed(btn3,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 3 is pressed
frequency = 697; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1477;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn4Pushed(btn4,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 4 is pressed
frequency = 770; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1209;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn5Pushed(btn5,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 5 is pressed
frequency = 770; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1336;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn6Pushed(btn6,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 6 is pressed
frequency = 770; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1477;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn7Pushed(btn7,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 7 is pressed
frequency = 852; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1209;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn8Pushed(btn8,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 8 is pressed
frequency = 852; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1336;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end
 
function btn9Pushed(btn9,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 9 is pressed
frequency = 852; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1477;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btnStarPushed(btnStar,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when * is pressed
frequency = 941; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1209;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btn0Pushed(btn0,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when 0 is pressed
frequency = 941; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1336;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end

function btnPoundPushed(btnPound,event)
amplitude = 1;
length = 0.5; %seconds
sampleRate = 44100; %samples per second
time = 0:1/sampleRate:length;

%when # is pressed 
frequency = 941; %hertz
y1 = amplitude * sin (2 * pi * frequency * time);
frequency = 1477;
y2 = amplitude * sin (2 * pi * frequency * time);
y=(y1+y2)/2;
soundsc(y, sampleRate);
end
