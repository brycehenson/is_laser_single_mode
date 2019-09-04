
%% Single Mode Test

pzt_noise_amp=1e-3;%1e-1;
time_vec=linspace(0,50e-3,1e5)';
pzt_freq=70;
samp_freq=numel(time_vec)/diff(time_vec([1,end]));
%TODO pzt distortions/nonlin
pzt_voltage=30+10*sawtooth(time_vec*pzt_freq*2*pi);
pzt_voltage=pzt_voltage+pzt_noise_amp*randn(numel(pzt_voltage),1);
pzt_voltage=lopass_butterworth(pzt_voltage,pzt_freq*100,samp_freq,1);

fp_in.time=time_vec;
fp_in.finesse=200;
fp_in.wav_vec=826e-9+[1e-12,0]';
fp_in.power_vec=[1,0]';
fp_in.pzt_vec=pzt_voltage;
fp_in.pd_bw=pzt_freq*100;
fp_in.pd_gain=10;
fp_in.pd_noise=1;
fp_in.cav_len_cen=50e-3;
fp_in.pzt_gain=8e-8; %meters per volt

pd_vec=fp_trans_power(fp_in);



check_in=[];
check_in.pzt_dist_sm=3;
check_in.pd_voltage=pd_vec;
check_in.times=time_vec;
check_in.pzt_voltage=pzt_voltage;
check_in.scan_type='sawtooth';
check_in.num_checks=inf;
check_in.peak_thresh=0.3;
check_in.pzt_dist_pd_cmp=nan;
check_in.scan_time=1/50;
check_in.pd_filt_factor=1e-3;
check_in.ptz_filt_factor_pks=1e-3;
check_in.pzt_filt_factor_deriv=1/100;
check_in.pd_amp_min=-inf;
check_in.plot.all=true;
check_in.plot.failed=true;
check_in.verbose=5;

sm_check_logic=is_laser_single_mode(check_in)
if ~sm_check_logic
    error('test failed')
end


%%
figure(1)
clf
plot(time_vec,pd_vec,'r')
hold on
plot(time_vec,(pzt_voltage-20)/5,'b')
xlim([0.001,0.02])

%% multimode test
fp_in.power_vec=[1,0.3]';
fp_in.pzt_vec=pzt_voltage;
fp_in.pd_bw=pzt_freq*100;
fp_in.pd_gain=10;
fp_in.pd_noise=1;
fp_in.cav_len_cen=50e-3;
fp_in.pzt_gain=8e-8; %meters per volt

pd_vec=fp_trans_power(fp_in);


check_in=[];
check_in.pzt_dist_sm=3;
check_in.pd_voltage=pd_vec;
check_in.times=time_vec;
check_in.pzt_voltage=pzt_voltage;
check_in.scan_type='sawtooth';
check_in.num_checks=inf;
check_in.peak_thresh=0.3;

check_in.pzt_dist_pd_cmp=nan;
check_in.scan_time=1/50;
check_in.pd_filt_factor=1e-3;
check_in.ptz_filt_factor_pks=1e-3;
check_in.pzt_filt_factor_deriv=1/100;
check_in.pd_amp_min=-inf;
check_in.plot.all=true;
check_in.plot.failed=true;
check_in.verbose=5;

sm_check_logic=is_laser_single_mode(check_in)

if sm_check_logic
    error('test failed')
end
%%
figure(1)
clf
plot(time_vec,pd_vec,'r')
hold on
plot(time_vec,(pzt_voltage-20)/5,'b')
xlim([0.001,0.016])

%% cmp pd test
fp_in.power_vec=[1,0.01]';
fp_in.pzt_vec=pzt_voltage;
fp_in.pd_bw=pzt_freq*100;
fp_in.pd_gain=10;
fp_in.pd_noise=0.001;
fp_in.cav_len_cen=50e-3;
fp_in.pzt_gain=8e-8; %meters per volt

pd_vec=fp_trans_power(fp_in);

max_val=0.8;
clip_fun=@(x) (max_val*2./(1+exp(-2*x)))-max_val;
%investigate this function
% x_in=[-1,1]*1e-3;
% y_out=clip_fun(x_in);
% diff(y_out)/diff(x_in)
% 
% xvals=linspace(-3,3,1e5)';
% plot(xvals,clip_fun(xvals))
% xlim([-1,1])
% ylim([-1,1])

pd_clip_vec=clip_fun(pd_vec);

pd_clip_vec=pd_clip_vec+0.001*randn(numel(pd_clip_vec),1);
pd_vec=pd_vec+0.1*randn(numel(pd_clip_vec),1);

check_in=[];
check_in.pzt_dist_sm=3;
check_in.pd_voltage=cat(2,pd_vec,pd_clip_vec);
check_in.times=time_vec;
check_in.pzt_voltage=pzt_voltage;
check_in.scan_type='sawtooth';
check_in.num_checks=inf;
check_in.peak_thresh=[0.3,0.004];
check_in.pzt_dist_pd_cmp=0.2;
check_in.scan_time=1/50;
check_in.pd_filt_factor=1e-3;
check_in.ptz_filt_factor_pks=1e-3;
check_in.pzt_filt_factor_deriv=1/100;
check_in.pd_amp_min=0.5;
check_in.plot.all=true;
check_in.plot.failed=true;
check_in.verbose=0;

sm_check_logic=is_laser_single_mode(check_in)

if sm_check_logic
    error('test failed')
end





%% hidden multimode test
% develop a method to identify multimode that is too small to see in a single scan
% idealy in a way that does not rely on the wavelength staying the same across scans
% ideas
% - stacking multiple scans xcorr and numerical opt
% - 
% This will be left for future work

fp_in.power_vec=[1,0.01]';
fp_in.pzt_vec=pzt_voltage;
fp_in.pd_bw=pzt_freq*100;
fp_in.pd_gain=10;
fp_in.pd_noise=1;
fp_in.cav_len_cen=50e-3;
fp_in.pzt_gain=8e-8; %meters per volt

pd_vec=fp_trans_power(fp_in);


check_in=[];
check_in.pzt_dist_sm=3;
check_in.pd_voltage=pd_vec;
check_in.times=time_vec;
check_in.pzt_voltage=pzt_voltage;
check_in.scan_type='sawtooth';
check_in.num_checks=inf;
check_in.peak_thresh=0.3;

check_in.pzt_dist_pd_cmp=nan;
check_in.scan_time=1/50;
check_in.pd_filt_factor=1e-3;
check_in.ptz_filt_factor_pks=1e-3;
check_in.pzt_filt_factor_deriv=1/100;
check_in.pd_amp_min=-inf;
check_in.plot.all=true;
check_in.plot.failed=true;
check_in.verbose=5;

sm_check_logic=is_laser_single_mode(check_in)

if sm_check_logic
    error('test failed')
end
