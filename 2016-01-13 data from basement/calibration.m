%% 30571 - Smart city sensor
% Data calibration from logfiles of Mac_logger.py
%
%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

display('Import data')
% import data
[time,mac,siglevel] = import_log('20m/2016-01-13-13-log_whitelist.txt');



time_start = datetime(2016,01,13,13,08,00);
time_end = datetime(2016,01,13,13,59,00);
macA = '40:a5:ef:06:19:a0';

% get data in time interval
[time_dt,mac_dt,siglevel_dt] = timeinterval(time,mac,siglevel,time_start,time_end);
% take only one device and find all samples
[ time_filtered,mac_filtered,siglevel_filtered ] = one_mac_filter(time_dt,mac_dt,siglevel_dt, macA );

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
PK = -47.74;
a = 0.3796;

% 0m
time_start = datetime(2016,01,13,13,19,00);
time_end = datetime(2016,01,13,13,20,59);
[time_filtered_0m,mac_filtered_0m,siglevel_filtered_0m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_0m(1:length(siglevel_filtered_0m)) = 0.01;

% 5m
time_start = datetime(2016,01,13,13,21,00);
time_end = datetime(2016,01,13,13,22,59);
[time_filtered_5m,mac_filtered_5m,siglevel_filtered_5m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_5m(1:length(siglevel_filtered_5m)) = 5;

% 10m
time_start = datetime(2016,01,13,13,23,00);
time_end = datetime(2016,01,13,13,24,59);
[time_filtered_10m,mac_filtered_10m,siglevel_filtered_10m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_10m(1:length(siglevel_filtered_10m)) = 10;

% 15m
time_start = datetime(2016,01,13,13,25,00);
time_end = datetime(2016,01,13,13,26,59);
[time_filtered_15m,mac_filtered_15m,siglevel_filtered_15m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_15m(1:length(siglevel_filtered_15m)) = 15;

% 20m
time_start = datetime(2016,01,13,13,27,00);
time_end = datetime(2016,01,13,13,28,59);
[time_filtered_20m,mac_filtered_20m,siglevel_filtered_20m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_20m(1:length(siglevel_filtered_20m)) = 20;

% 25m
time_start = datetime(2016,01,13,13,29,00);
time_end = datetime(2016,01,13,13,30,59);
[time_filtered_25m,mac_filtered_25m,siglevel_filtered_25m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_25m(1:length(siglevel_filtered_25m)) = 25;

%30m
time_start = datetime(2016,01,13,13,31,00);
time_end = datetime(2016,01,13,13,35,59);
[time_filtered_30m,mac_filtered_30m,siglevel_filtered_30m] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA);
d_30m(1:length(siglevel_filtered_30m)) = 30;
%theory
d = 0:50;
rssi = PK-10*log10(d);

figure;
hold on;
plot(d,rssi)
plot(d_0m,siglevel_filtered_0m,'.')
plot(d_5m,siglevel_filtered_5m,'.')
plot(d_10m,siglevel_filtered_10m,'.')
plot(d_15m,siglevel_filtered_15m,'.')
plot(d_20m,siglevel_filtered_20m,'.')
plot(d_25m,siglevel_filtered_25m,'.')
plot(d_30m,siglevel_filtered_30m,'.')
grid on;
xlabel('distance [m]')
ylabel('RSSI [db]')
legend('Theory')
hold off;

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
grid on;
xlabel('distance [m]')
ylabel('Standard diviation')
hold off;

%% Fit new model
d = [d_0m,d_5m,d_10m,d_15m,d_20m,d_25m,d_30m];
%d = [0,5,10,15,20,25,30];
siglevel_filtered = [siglevel_filtered_0m,siglevel_filtered_5m,siglevel_filtered_10m,siglevel_filtered_15m,siglevel_filtered_20m,siglevel_filtered_25m,siglevel_filtered_30m];
%siglevel_filtered = [mean(siglevel_filtered_0m),mean(siglevel_filtered_5m),mean(siglevel_filtered_10m),mean(siglevel_filtered_15m),mean(siglevel_filtered_20m),mean(siglevel_filtered_25m),mean(siglevel_filtered_30m)];

myownfittype = fittype('dist_to_rssi(d, PK, a)','independent', {'d'})
myownfit = fit(d', siglevel_filtered', myownfittype)

hold on;
hist3([d',siglevel_filtered'],[20,50])
xlabel('Distance'); 
ylabel('RSSI');
zlabel('#MAC');
grid on;
set(get(gca,'child'),'FaceColor','interp','CDataMode','auto');
hold off;