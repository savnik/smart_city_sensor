%% 30571 - Smart city sensor
% Data processing from logfiles of Mac_logger.py
%
%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

dt = 1

display('Import data')
% import data
[time11,mac11,siglevel11] = import_log('1 - NE/2016-1-12-10-log_anonymous.txt');
[time12,mac12,siglevel12] = import_log('1 - NE/2016-1-12-11-log_anonymous.txt');
[time13,mac13,siglevel13] = import_log('1 - NE/2016-1-12-13-log_anonymous.txt');

[time21,mac21,siglevel21] = import_log('2 - SE/2016-1-12-10-log_anonymous.txt');
[time22,mac22,siglevel22] = import_log('2 - SE/2016-1-12-11-log_anonymous.txt');
[time23,mac23,siglevel23] = import_log('2 - SE/2016-1-12-13-log_anonymous.txt');

[time31,mac31,siglevel31] = import_log('3 - SW/2016-1-12-10-log_anonymous.txt');
[time32,mac32,siglevel32] = import_log('3 - SW/2016-1-12-11-log_anonymous.txt');
[time33,mac33,siglevel33] = import_log('3 - SW/2016-1-12-12-log_anonymous.txt');
[time34,mac34,siglevel34] = import_log('3 - SW/2016-1-12-13-log_anonymous.txt');

[time41,mac41,siglevel41] = import_log('4 - NW/2016-1-12-10-log_anonymous.txt');
[time42,mac42,siglevel42] = import_log('4 - NW/2016-1-12-11-log_anonymous.txt');
[time43,mac43,siglevel43] = import_log('4 - NW/2016-1-12-13-log_anonymous.txt');

time1 = [time11; time12; time13;];
mac1 = [mac11;mac12;mac13];
siglevel1 = [siglevel11;siglevel12;siglevel13];
clearvars time11 time12 time13 mac11 mac12 mac13 siglevel11 siglevel12 siglevel13

time2 = [time21; time22; time23;];
mac2 = [mac21;mac22;mac23];
siglevel2 = [siglevel21;siglevel22;siglevel23];
clearvars time21 time22 time23 mac21 mac22 mac23 siglevel21 siglevel22 siglevel23

time3 = [time31; time32; time33; time34];
mac3 = [mac31;mac32;mac33; mac34];
siglevel3 = [siglevel31;siglevel32;siglevel33; siglevel34];
clearvars time31 time32 time33 time34 mac31 mac32 mac33 mac34 siglevel31 siglevel32 siglevel33 siglevel34

time4 = [time41; time42; time43;];
mac4 = [mac41;mac42;mac43];
siglevel4 = [siglevel41;siglevel42;siglevel43];
clearvars time41 time42 time43 mac41 mac42 mac43 siglevel41 siglevel42 siglevel43

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
legend('NE','SE','SW','NW')
xlabel('Time')
ylabel('#MAC')
title('101 Cantine 12/1 2016')
grid on;
hold off;

%%

mac = mac1;
time = time1;
siglevel = siglevel1;
dt = 1;

    n_data = length(mac);

    t_now = time(1); % time start
    t_end = time(n_data); % time end
    t_vec = t_now:duration(0,dt,0):t_end; % time vector

    mac_list_dt = [mac(1)]; % macs in dt
    time_list_dt = [time(1)];
    siglevel_list_dt = [siglevel(1)];
    count_list_dt = [];

    % input data
    for i = 1:length(t_vec)
        % update mac_list_dt (remove old)
        t_now = t_vec(i);
        for j = length(mac_list_dt):-1:1    % reversed order
            if time_list_dt(j) < t_now - minutes(dt)
                mac_list_dt = mac_list_dt(j:length(mac_list_dt));
                time_list_dt = time_list_dt(j:length(time_list_dt));
                siglevel_list_dt = siglevel_list_dt(j:length(siglevel_list_dt));
                break
            end
        end

        % add new data at t_now
        for j = 2:length(mac) % run from 2 because dataset 1 has been added!
            if t_now >= time(j) && time(j) > t_now-duration(0,dt,0) % time leq to now AND > t_now-dt
                mac_list_dt = [mac_list_dt, mac(j)];
                %mac = mac(j+1:length(mac)); % removes data from orgininal list
                time_list_dt = [time_list_dt, time(j)];
                %time = time(j+1:length(time)); % removes data from orgininal list
                siglevel_list_dt = [siglevel_list_dt, siglevel(j)];
                %siglevel = siglevel(j+1:length(siglevel)); % removes data from orgininal list
                
            elseif time(j) > t_now % if time in furture break out
                break
            end
        end

        % find unique
        [unique_time, unique_mac, unique_siglevel] = find_unique_mac(time_list_dt, mac_list_dt, siglevel_list_dt);

        % count unique data samples in window
        count_list_dt(i) = length(unique_mac);

        
        % time update
    end

%%
plot(t_vec,count_list_dt)