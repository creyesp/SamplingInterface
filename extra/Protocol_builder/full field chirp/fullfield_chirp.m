%% General parameters
sample = 1/60; % time of frame [s]
sizeimg = 420; % size of protocols in [pixels]
rgb = [0,1,1]; % Color of protocol

% Frequency modilation
T_freqmod = 15; % time of frequency modulation
Phase0_fm = 2*pi; % Starting phase
F_end_fm = 15; % Finish Frequency
Max_amp_fm = 0.5; % light intensity for frecuency modulation
Base_amp_fm = 0.5; % light intensity for frecuency modulation

% Amplitude modulation
T_am = 8; % time of frequency modulation
F0_am = 1; % Starting Frequency
Max_amp_am = 0.5; % light intensity for amplitude modulation
Base_amp_am = 0.5; % light intensity for amplitude modulation

% other
t_prev = 2; % previos time of protocol [s]
t_post = 2; % posterior time of protocol [s]
t_adap = 2; % adaptation time for modulation [s]
amp_prev = 0; % light intensity previos to protocol
amp_post = 0; % light intensity posterior to protocol
amp_adap = 0.5; % light intensity adaptation for protocol
t_ON = 3; % ON time [s]
amp_ON = 1; % light intensity to ON flash
t_OFF = 3; % OFF time [s]
amp_OFF = 0; % light intensity to OFF flash


%% Compute temporal profile of protocol
k = F_end_fm/T_freqmod; % Acceleration (Hz / s)
t_freqmod = [0:sample:T_freqmod-sample];
P_freq = Base_amp_fm + Max_amp_fm * sin(Phase0_fm +  pi*k*t_freqmod.*t_freqmod);

t_ampmod = [0:sample:T_am-sample];
amplitude = [0:Max_amp_am/(length(t_ampmod)-1):Max_amp_am];
P_amp = Base_amp_am + amplitude.*sin(2*pi*F0_am*t_ampmod);

P_prev = ones(1,t_prev/sample)*amp_prev;
P_post = ones(1,t_post/sample)*amp_post;
P_ON = amp_ON + zeros(1,t_ON/sample);
P_OFF = amp_OFF + zeros(1,t_OFF/sample);
P_adap = amp_adap*ones(1,t_adap/sample);

% stimulus = [ P_prev P_ON P_OFF P_adap P_freq P_adap P_amp P_adap P_post];
stimulus = [ P_ON P_OFF P_adap P_freq P_adap P_amp P_adap];
t_stimulus = [0:sample:length(stimulus)*sample-sample];

img = ones(sizeimg,sizeimg,3);
img(:,:,1) = rgb(1); % Red Channel intensity
img(:,:,2) = rgb(2); % Green Channel intensity
img(:,:,3) = rgb(3); % Blue Channel intensity
%% Ploting 

% Frequency modulation
figure()
plot(t_freqmod,P_freq)
title('Frequency modulation')
xlabel('Time [s]')
ylabel('Amplitude')
% Amplitude modulation
figure()
plot(t_ampmod,P_amp)
title('Amplitude modulation')
xlabel('Time [s]')
ylabel('Amplitude')
% Protocol Full field chirp
figure()
plot(t_stimulus,stimulus)
xlim([-1 t_stimulus(end)*1.1])
ylim([-0.2 1.1])
xlabel('time [s]')
ylabel('amplitude')
grid()


%% Generation of protocol images

mkdir('fullfiledchirp')
for k=1:length(stimulus)
    imwrite(img*stimulus(k),['fullfiledchirp/img' num2str(k,'%05d') '.png'])
end