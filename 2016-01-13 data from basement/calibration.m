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
time_end = datetime(2016,01,13,13,13,00);
macA = '40:a5:ef:06:19:a0';

% get data in time interval
[time_dt,mac_dt,siglevel_dt] = timeinterval(time,mac,siglevel,time_start,time_end);
% take only one device and find all samples
[ time_filtered,mac_filtered,siglevel_filtered ] = one_mac_filter(time_dt,mac_dt,siglevel_dt, macA );

hold on;
plot(time_filtered,siglevel_filtered)
grid on;
hold off;