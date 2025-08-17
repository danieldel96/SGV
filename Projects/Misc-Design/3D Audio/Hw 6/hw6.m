fileName='claps8.wav';
[y, fs]=audioread(fileName);

time=(1:length(y))/fs;

plot(time,y);
xlabel('Time');

left = y(:,1);
right = y(:,2);

left(2)
right(2)

ipt = findchangepts(left,'MaxNumChanges',4)
left_ipt = left(ipt)
ipt = findchangepts(right,'MaxNumChanges',4)
right_ipt = right(ipt)

itd = (left_ipt - right_ipt);
itd_abs = abs(itd);
itd_mean = mean(itd_abs) % :)


%% 

%power(250,left,right,fs)

n = [250,1000,5000,10000];
n_power = [0,0,0,0];
for i=1:4
    n_power(i) = power(n(i),left,right,fs);
end

n_power
plot(time,y)

function y = power(n,left,right,fs)
    freq = n ;
    pspectrum(left,fs);
    [p,f] = pspectrum(left,fs);


    value = interp1(f,p,freq);
    p_l = 10*log(value);

%pspectrum(right,fs);
    [p,f] = pspectrum(right,fs);

    value = interp1(f,p,freq);
    p_r = 10*log(value);
    y = abs(p_r)-abs(p_l);
end

