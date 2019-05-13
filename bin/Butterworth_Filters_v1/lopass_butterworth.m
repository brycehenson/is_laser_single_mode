function [filtered_signal,filtb,filta]=lopass_butterworth(inputsignal,cutoff_freq,Fs,order)
% Low-pass Butterworth filter
% [filtered_signal,filtb,filta] = lopass_butterworth(inputsignal,cutoff_freq,Fs,order)
% 
% This is simply a set of built-in Matlab functions, repackaged for ease of
% use by Chad Greene, October 2012. 
%
% INPUTS: 
% inputsignal = input time series
% cutoff_freq = filter corner frequency
% Fs = data sampling frequency
% order = order of Butterworth filter
%  
% OUTPUTS: 
% filtered_signal = the filtered time series
% filtb, filta = filter numerator and denominator (optional)
% 
% EXAMPLE 1: 
% load train
% t = (1:length(y))/Fs;
% y_filt = lopass_butterworth(y,900,Fs,4); % cut off at 900 Hz
% figure
% plot(t,y,'b',t,y_filt,'r')
% xlabel('time in seconds')
% box off
% legend('unfiltered','filtered')
% sound(y,Fs)      % play original time series
% pause(2)         % pause two seconds
% sound(y_filt,Fs) % play filtered time series
% 
% 
% EXAMPLE 2: 
% load train
% t = (1:length(y))/Fs;
% [y_filt,filtb,filta] = lopass_butterworth(y,900,Fs,4); % cut off at 900 Hz
% [h1,f1] = freqz(filtb,filta,256,Fs);
% 
% figure
% subplot(3,1,1)
% plot(t,y,'b',t,y_filt,'r')
% xlabel('time in seconds')
% box off
% text(0,.1,' time series','units','normalized')
% 
% subplot(3,1,2)
% AX = plotyy(f1,10*log10(abs(h1)),f1,angle(h1),'semilogx');
% set(get(AX(1),'ylabel'),'string','gain (dB)')
% set(get(AX(2),'ylabel'),'string','phase (rad)')
% xlim(AX(1),[min(f1) max(f1)])
% xlim(AX(2),[min(f1) max(f1)])
% text(0,.1,' filter response','units','normalized')
% box off
% 
% [Pxx,f] = pwelch(y,512,256,[],Fs,'onesided');
% [Pxxf,f_f]= pwelch(y_filt,512,256,[],Fs,'onesided');
% subplot(3,1,3)
% semilogx(f,10*log10(Pxx))
% hold on
% semilogx(f_f,10*log10(Pxxf),'r')
% xlabel('frequency (Hz)')
% ylabel('PSD (dB)')
% xlim([min(f1) max(f1)])
% box off
% legend('unfiltered','filtered','location','northwest')
% legend boxoff

inputsignal=inputsignal(:);
nyquist_freq = Fs/2;  % Nyquist frequency
Wn=cutoff_freq/nyquist_freq;    % non-dimensional frequency
[filtb,filta]=butter(order,Wn,'low'); % construct the filter
%bmh:change: filtfilt to filter
padd_input_size=round(5/Wn);
%BMH:change: remove the start transient from the filter output by padding the start
padded_in=cat(1,repmat(inputsignal(1),padd_input_size,1),inputsignal);
filtered_signal=filter(filtb,filta,padded_in); % filter the data with zero phase 
filtered_signal=filtered_signal(padd_input_size+1:end);

