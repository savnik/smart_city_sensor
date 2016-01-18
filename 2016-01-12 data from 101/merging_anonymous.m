% fff
%
% 30571 - Smart city sensor
% 
% Get the merged data from all the whitelists
%
clear all;
close all;

dt = 1;

display('Import data')
% import data
[time19,mac19,siglevel19] = import_log('1 - NE/2016-1-12-8-log_anonymous.txt');

[time29,mac29,siglevel29] = import_log('2 - SE/2016-1-12-8-log_anonymous.txt');

[time39,mac39,siglevel39] = import_log('3 - SW/2016-1-12-8-log_anonymous.txt');

[time49,mac49,siglevel49] = import_log('4 - NW/2016-1-12-8-log_anonymous.txt');

time1 = [time19];
mac1 = [mac19];
siglevel1 = [siglevel19];

time2 = [time29];
mac2 = [mac29];
siglevel2 = [siglevel29];

time3 = [time39];
mac3 = [mac39];
siglevel3 = [siglevel39];

time4 = [time49];
mac4 = [mac49];
siglevel4 = [siglevel49];

[final_time, final_mac, final_signal] = get_merged_to_file(time1, time2, time3, time4, mac1, mac2, mac3, mac4, siglevel1, siglevel2, siglevel3, siglevel4);

% Plot of overall (to check that working)
[count_list_dt1, time_list_dt1] = n_mac_integrated(final_time,final_mac,final_signal,(1/60));
display('Plotting...')
hold on;
plot(time_list_dt1,count_list_dt1)
grid on;
hold off;

