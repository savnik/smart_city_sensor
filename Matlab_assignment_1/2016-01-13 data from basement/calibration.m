%% 30571 - Smart city sensor
% Data calibration from logfiles of Mac_logger.py
% Peter Savnik
%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

display('Import data')
% import data
[time,mac,siglevel] = import_log('20m/2016-01-13-13-log_whitelist.txt');
%[time4,mac4,siglevel4] = import_log('50m/2016-1-13-13-log_anonymous.txt');


time_start = datetime(2016,01,13,13,08,00);
time_end = datetime(2016,01,13,13,59,00);
macA = '40:a5:ef:06:19:a0';
macB = '40:a5:ef:06:19:a0';

% get data in time interval
%[time_dt,mac_dt,siglevel_dt] = timeinterval(time,mac,siglevel,time_start,time_end);
[ time_filtered,mac_filtered,siglevel_filtered ] = timeinterval(time,mac,siglevel,time_start,time_end);
% take only one device and find all samples
%[ time_filtered,mac_filtered,siglevel_filtered ] = one_mac_filter(time_dt,mac_dt,siglevel_dt, macA );

figure;
hold on;
plot(time_filtered,siglevel_filtered)
grid on;
hold off;

%% Calibrating PK and a
%syms a PK
%d = 20; % dist in meters
d(1:length(siglevel_filtered)) = 20;
myownfittype = fittype('dist_to_rssi(d, PK, a)','independent', {'d'})
myownfit = fit(d', siglevel_filtered', myownfittype)

%%
PK = -9.431;
a = 3.717;

%% Calculating dist vs rssi
d = 10.^((-PK+siglevel_filtered)/(-10*a));
d_mean = mean(d)

figure;
hold on;
plot(d,siglevel_filtered,'.')
xlabel('dist [m]')
ylabel('RSSI [db]')
grid on;
hold  off;

%% time vs distance

[ d ] = rssi_to_dist(siglevel_filtered, PK, a);
figure;
hold on;
plot(time_filtered,d,'.')
xlabel('time ')
ylabel('dist [m]')
grid on;
hold  off;

%% std husk sample!

%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

display('Import data')
% import data
[time,mac,siglevel] = import_log('20m/2016-01-13-13-log_whitelist.txt');


macA = '40:a5:ef:06:19:a0';
PK = -25;
a = 2.5;

d = [];
time_filtered = [];
mac_filtered = [];
siglevel_filtered = [];

% 0m
% Forward
time_start = datetime(2016,01,13,13,19,00);
time_end = datetime(2016,01,13,13,20,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,48,00);
time_end = datetime(2016,01,13,13,49,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 0.01;
d = d_tmp;
mean0 = mean([siglevel_filtered_f siglevel_filtered_b])

% 5m
% forward
time_start = datetime(2016,01,13,13,21,00);
time_end = datetime(2016,01,13,13,22,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,46,00);
time_end = datetime(2016,01,13,13,47,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 5;
d = [d d_tmp];

% 10m
% forward
time_start = datetime(2016,01,13,13,23,00);
time_end = datetime(2016,01,13,13,24,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,44,00);
time_end = datetime(2016,01,13,13,45,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 10;
d = [d d_tmp];

% 15m
%forward
time_start = datetime(2016,01,13,13,25,00);
time_end = datetime(2016,01,13,13,26,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,42,00);
time_end = datetime(2016,01,13,13,43,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 15;
d = [d d_tmp];

% 20m
% Forward
time_start = datetime(2016,01,13,13,27,00);
time_end = datetime(2016,01,13,13,28,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,40,00);
time_end = datetime(2016,01,13,13,41,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 20;
d = [d d_tmp];



% 25m
% forward
time_start = datetime(2016,01,13,13,29,00);
time_end = datetime(2016,01,13,13,30,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% backward
time_start = datetime(2016,01,13,13,38,00);
time_end = datetime(2016,01,13,13,39,59);
[time_filtered_b,mac_filtered_b,siglevel_filtered_b] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f time_filtered_b]; 
mac_filtered = [mac_filtered mac_filtered_f mac_filtered_b];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f siglevel_filtered_b];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)+length(siglevel_filtered_b)) = 25;
d = [d d_tmp];

%30m
% Forward
time_start = datetime(2016,01,13,13,31,00);
time_end = datetime(2016,01,13,13,35,59);
[time_filtered_f,mac_filtered_f,siglevel_filtered_f] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
% Combine
time_filtered = [time_filtered time_filtered_f]; 
mac_filtered = [mac_filtered mac_filtered_f];
siglevel_filtered = [siglevel_filtered siglevel_filtered_f];
d_tmp = [];
d_tmp(1:length(siglevel_filtered_f)) = 30;
d = [d d_tmp];
mean30 = mean(siglevel_filtered_f)

%theory
d_t = 0:0.1:50;
rssi = PK-10*log10(d_t);

figure;
hold on;
%plot(d,PK+a*d)
plot(d, siglevel_filtered, '.')
PK = -46.97;
a = 0.3131;
plot(d_t,PK-10*a*log10(d_t))

PK = -25;
a = 2.5;
plot(d_t,PK-10*a*log10(d_t))
plot(d_t,-0.5716*d_t-40.4976)
%plot(d_0m,siglevel_filtered_0m,'.')
%plot(d_5m,siglevel_filtered_5m,'.')
%plot(d_10m,siglevel_filtered_10m,'.')
%plot(d_15m,siglevel_filtered_15m,'.')
%plot(d_20m,siglevel_filtered_20m,'.')
%plot(d_25m,siglevel_filtered_25m,'.')
%plot(d_30m,siglevel_filtered_30m,'.')
grid on;
xlabel('Distance [m]')
ylabel('RSS [dB]')
legend('Observations','Logarithm Matlab fit','Logarithm Manual fit','Poly fit')
hold off;
%%
figure;
hold on;
plot(d,rssi)
plot(d_0m,std(siglevel_filtered_0m),'-')
plot(d_5m,std(siglevel_filtered_5m),'-')
plot(d_10m,std(siglevel_filtered_10m),'-')
plot(d_15m,std(siglevel_filtered_15m),'-')
plot(d_20m,std(siglevel_filtered_20m),'-')
plot(d_25m,std(siglevel_filtered_25m),'-')
plot(d_30m,std(siglevel_filtered_30m),'-')
plot(d_0m,siglevel_filtered_0m,'.')
plot(d_5m,siglevel_filtered_5m,'.')
plot(d_10m,siglevel_filtered_10m,'.')
plot(d_15m,siglevel_filtered_15m,'.')
plot(d_20m,siglevel_filtered_20m,'.')
plot(d_25m,siglevel_filtered_25m,'.')
plot(d_30m,siglevel_filtered_30m,'.')
grid on;
xlabel('distance [m]')
ylabel('Standard diviation')
hold off;

%% Fit new linear model [10;25] meters
d = [d_10m,d_15m,d_20m,d_25m];
%d = [10,15,20,25];
siglevel_filtered = [siglevel_filtered_10m,siglevel_filtered_15m,siglevel_filtered_20m,siglevel_filtered_25m];
%siglevel_filtered = [mean(siglevel_filtered_0m),mean(siglevel_filtered_5m),mean(siglevel_filtered_10m),mean(siglevel_filtered_15m),mean(siglevel_filtered_20m),mean(siglevel_filtered_25m),mean(siglevel_filtered_30m)];
%stdx = [std(siglevel_filtered_0m),std(siglevel_filtered_5m),std(siglevel_filtered_10m),std(siglevel_filtered_15m),std(siglevel_filtered_20m),std(siglevel_filtered_25m),std(siglevel_filtered_30m)];

%hold on;
%plot(d,siglevel_filtered)
%plot(d,stdx)
%hold off;
%% Fitting

myownfittype = fittype('dist_to_rssi(d, PK, a)','independent', {'d'})
myownfit = fit(d', siglevel_filtered', myownfittype)
% PK =      -46.97  (-47.51, -46.42)
% a =      0.3131  (0.2729, 0.3533)


polyfit(d,siglevel_filtered,1)
% -0.5716  -40.4976

%%
hold on;
hist3([d',siglevel_filtered'],[6,20])
xlabel('Distance'); 
ylabel('RSSI');
zlabel('#MAC');
grid on;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
hold off;