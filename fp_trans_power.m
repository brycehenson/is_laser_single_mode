function pd_power=fp_trans_power(fp_in)
%fp_in.finesse
%fp_in.wav_vec
%fp_in.power_vec
%fp_in.pzt_vec
%fp_in.pd_bw
%fp_in.pd_noise
%fp_in.pd_gain
%fp_in.cav_len_cen
%fp_in.pzt_gain %meters per volt


pzt_m_per_volt=fp_in.pzt_gain;
comp_wav=fp_in.wav_vec(:);
comp_power=fp_in.power_vec(:);
pzt_voltage=fp_in.pzt_vec(:);
cav_len_cen=fp_in.cav_len_cen;

time_vec=fp_in.time(:);
samp_freq=numel(time_vec)/diff(time_vec([1,end]));

len_vec=pzt_voltage*pzt_m_per_volt;

finesse=fp_in.finesse;
coef_finesse=(2*finesse/pi)^2;


refractive_idx=1;
trans_fun=@(len,wav,power) power./(1+coef_finesse*(sin((2*pi/wav)*len*refractive_idx).^2));
trans_fun_component=@(params) trans_fun(cav_len_cen+len_vec,params(1),params(2));
component_powers=col_row_fun_mat(trans_fun_component,cat(2,comp_wav,comp_power),2)';
pd_vec=sum(component_powers,2);
pd_vec=pd_vec*fp_in.pd_gain;
pd_vec=pd_vec+fp_in.pd_noise*randn(numel(pd_vec),1);
pd_vec=lopass_butterworth(pd_vec,fp_in.pd_bw ,samp_freq,1);

pd_power=pd_vec;

end