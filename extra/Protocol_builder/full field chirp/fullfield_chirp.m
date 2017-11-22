TT = 8; % Time of modulation
sample = 1/60;
t = [0:sample:TT-sample];
f0 = 1; % Starting Frequency
f1 = 8; % Finish Frequency
k = f1/TT; % Acceleration (Hz / s)
Max_amp = 0.5;
yfreq = Max_amp * sin(2*pi*f0 + pi*k*t.*t)+Max_amp;
figure()
plot(t,yfreq)
hold on
plot(t,Max_amp*sin(2*pi*8*t)+Max_amp)
%%
TT = 8;
sample = 1/60;
t = [0:sample:TT-sample];
f1 = 2;
Max_amp = 0.5;
Amp_step = Max_amp/(length(t)-1);
amplitude = [0:Amp_step:Max_amp];
yamp = amplitude.*sin(2*pi*f1*t)+Max_amp;

figure()
plot(t,yamp)

%%
sample = 1/60;
tprev = 2/sample;
tpost = 2/sample;
MAx_amp = 0.5;
tON = 3/sample;
tOFF = 3/sample;
stimulus = [zeros(1,tprev) 2*Max_amp*ones(1,tON) zeros(1,tOFF) Max_amp*ones(1,tprev) yfreq Max_amp*ones(1,tpost) yamp Max_amp*ones(1,tpost) zeros(1,tprev)];
t_stimulus = [0:sample:length(stimulus)*sample-sample];
figure()
plot(t_stimulus,stimulus)
xlim([-1 t_stimulus(end)*1.1])
ylim([-0.2 1.1])
xlabel('time [s]')
ylabel('amplitude')
grid()
%%
sizeimg = 420;
img = ones(sizeimg,sizeimg,3);
img(:,:,1) = 0;
for k=1:length(stimulus)
    imwrite(img*stimulus(k),['classificationRGC/img' num2str(k) '.png'])
end