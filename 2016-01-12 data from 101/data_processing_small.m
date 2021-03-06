% fff
%
% 30571 - Smart city sensor
% 
% Data processing from logfiles of Mac_logger.py
%
clear all;
close all;

dt = 1

display('Import data')
% import data
[time11,mac11,siglevel11] = import_log('1 - NE/2016-1-12-10-log_whitelist.txt')
[time12,mac12,siglevel12] = import_log('1 - NE/2016-1-12-11-log_whitelist.txt')
[time13,mac13,siglevel13] = import_log('1 - NE/2016-1-12-13-log_whitelist.txt')

[time21,mac21,siglevel21] = import_log('2 - SE/2016-1-12-10-log_whitelist.txt')
[time22,mac22,siglevel22] = import_log('2 - SE/2016-1-12-11-log_whitelist.txt')
[time23,mac23,siglevel23] = import_log('2 - SE/2016-1-12-13-log_whitelist.txt')

%[time31,mac31,siglevel31] = import_log('3 -
%SW/2016-1-12-10-log_whitelist.txt') % removed, problem with time
[time32,mac32,siglevel32] = import_log('3 - SW/2016-1-12-11-log_whitelist.txt')
[time33,mac33,siglevel33] = import_log('3 - SW/2016-1-12-12-log_whitelist.txt')
[time34,mac34,siglevel34] = import_log('3 - SW/2016-1-12-13-log_whitelist.txt')

[time41,mac41,siglevel41] = import_log('4 - NW/2016-1-12-10-log_whitelist.txt')
[time42,mac42,siglevel42] = import_log('4 - NW/2016-1-12-11-log_whitelist.txt')
[time43,mac43,siglevel43] = import_log('4 - NW/2016-1-12-13-log_whitelist.txt')

time1 = [time11; time12; time13;];
mac1 = [mac11;mac12;mac13];
siglevel1 = [siglevel11;siglevel12;siglevel13];

time2 = [time21; time22; time23;];
mac2 = [mac21;mac22;mac23];
siglevel2 = [siglevel21;siglevel22;siglevel23];

time3 = [ time32; time33; time43];
mac3 = [mac32;mac33; mac34];
siglevel3 = [siglevel32;siglevel33; siglevel34];

time4 = [time41; time42; time43;];
mac4 = [mac41;mac42;mac43];
siglevel4 = [siglevel41;siglevel42;siglevel43];

display('Count of observations:')
n_data = [length(mac1), length(mac2), length(mac3), length(mac4)]

display('Calculate number of mac addr integrated over dt')
display('Logger 1')
[count_list_dt1, time_list_dt1] = n_mac_integrated(time1,mac1,siglevel1,dt);
display('Logger 2')
[count_list_dt2, time_list_dt2] = n_mac_integrated(time2,mac2,siglevel2,dt);
display('Logger 3')
[count_list_dt3, time_list_dt3] = n_mac_integrated(time3,mac3,siglevel3,dt);
display('Logger 4')
[count_list_dt4, time_list_dt4] = n_mac_integrated(time4,mac4,siglevel4,dt);

display('Plotting...')
hold on;
plot(time_list_dt1,count_list_dt1)
plot(time_list_dt2,count_list_dt2)
plot(time_list_dt3,count_list_dt3)
plot(time_list_dt4,count_list_dt4)
legend('1 NE','2 SE', '3 SW', '4 NW')
grid on;
hold off;


