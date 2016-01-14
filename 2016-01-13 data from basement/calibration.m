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