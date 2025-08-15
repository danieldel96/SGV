idsensor = 1;
fs = 2000;

figure 
grid on
box on
hold on
get_psd(fs,raw.(['ch' num2str(idsensor)])*1000)
get_psd(fs,flt.(['ch' num2str(idsensor)])*1000)
get_psd(fs,pos.(['ch' num2str(idsensor)])*1000)
get_psd(fs,mov.(['ch' num2str(idsensor)])*1000)
get_psd(fs,rsp.(['ch' num2str(idsensor)])*1000)
get_psd(fs,nrm.(['ch' num2str(idsensor)])*1000)

set(gca,'fontsize', 20)
xlabel('Frequency (Hz)');
ylabel('Power/frequency (dB/Hz)');
title('PSD in decibels');
legend('raw','flt','pos','mov','rsp','nrm')

function get_psd(Fs,x)

% code 1:
[Pxx,F] = periodogram(x,[],length(x),Fs);
plot(F,10*log10(Pxx))
   
% code 2:
% dt = 1/Fs;                     % seconds per sample
% StopTime = size(x,1)/Fs;                  % seconds
% t = (0:dt:StopTime-dt)';
% N = size(t,1);
% 
% %%Fourier Transform:
% X = fftshift(fft(x));
%    
% %%Frequency specifications:
% dF = Fs/N;                      % hertz
% f = -Fs/2:dF:Fs/2-dF;           % hertz
%    
% plot(f,abs(X)/N);

% % code 3:
% y=x;
% nfft = 2^nextpow2(length(y));
% psd1 = abs(fft(y,nfft)).^2/length(y)/Fs;%compute the PSD and normalize
% plot([0:50/(length(psd1)/2):50],psd1(1:length(psd1)/2+1))

end





