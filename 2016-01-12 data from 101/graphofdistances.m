%% 30571 - Smart city sensor
% Data calibration from logfiles of Mac_logger.py
%
%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

display('Import data')
% import data
[time19,mac19,siglevel19] = import_log('1 - NE/2016-1-12-8-log_whitelist.txt');
[time10,mac10,siglevel10] = import_log('1 - NE/2016-1-12-9-log_whitelist.txt');
[time11,mac11,siglevel11] = import_log('1 - NE/2016-1-12-10-log_whitelist.txt');
[time12,mac12,siglevel12] = import_log('1 - NE/2016-1-12-11-log_whitelist.txt');
[time13,mac13,siglevel13] = import_log('1 - NE/2016-1-12-13-log_whitelist.txt');

time = [time19; time10; time11; time12; time13];
mac = [mac19; mac10; mac11;mac12;mac13];
siglevel = [siglevel19; siglevel10; siglevel11;siglevel12;siglevel13];


time_start = datetime(2016,01,13,13,08,00);
time_end = datetime(2016,01,13,13,59,00);
macA = '40:a5:ef:06:1f:2f';

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