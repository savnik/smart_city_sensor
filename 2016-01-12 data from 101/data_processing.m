% fff
%
% 30571 - Smart city sensor
% 
% Data processing from logfiles of Mac_logger.py
%
clear all;
close all;

% import data
[time11,mac11,siglevel11] = import_log('1 - NE/2016-1-12-10-log_anonymous.txt')
[time12,mac12,siglevel12] = import_log('1 - NE/2016-1-12-11-log_anonymous.txt')
[time13,mac13,siglevel13] = import_log('1 - NE/2016-1-12-13-log_anonymous.txt')

time = [time11; time12; time13;];
mac = [mac11;mac12;mac13];
siglevel = [siglevel11;siglevel12;siglevel13];

%log_w = import_log('1 - NE/2016-1-12-11-log_whitelist.txt')

display('Count of observations:')
n_data = length(mac)


% count numbers of units in interval dt
dt = 1; % [minutes]

unique_time = [];
unique_mac = [];
unique_siglevel = [];

for i = 1:n_data 
    % check if unique
    if length(unique_mac) == 0
       unique_time = [time(i)];
       unique_mac = [mac(i)];
       unique_siglevel = [siglevel(i)];
    else
        is_unique = 1;
        for j = 1:length(unique_mac)
           if strcmp(unique_mac(j),mac(i))
               is_unique = 0;
               break
           end
        end
        if is_unique
            unique_time = [unique_time, time(i)];
            unique_mac = [unique_mac, mac(i)];
            unique_siglevel = [unique_siglevel, siglevel(i)];
        end
    end

end;

display('Unique count of mac addr in total:')
length(unique_mac)

%% Time interval

t_now = time(1); % time start


mac_list_dt = [mac(1)]; % macs in dt
time_list_dt = [time(1)];
siglevel_list_dt = [siglevel(1)]
count_list_dt = []

% input data
for i = 2:n_data
    % update mac_list_dt (remove old)
    t_now = time(i);
    for j = length(mac_list_dt):-1:1    % reversed order
        if time_list_dt(j) < t_now - minutes(dt)
            mac_list_dt = mac_list_dt(j:length(mac_list_dt));
            time_list_dt = time_list_dt(j:length(time_list_dt));
            siglevel_list_dt = siglevel_list_dt(j:length(siglevel_list_dt));
            break
        end
    end
    
    % add new data
    mac_list_dt = [mac_list_dt, mac(i)];
    time_list_dt = [time_list_dt, time(i)];
    siglevel_list_dt = [siglevel_list_dt, siglevel(i)];
    
    % count
    count_list_dt(i) = length(mac_list_dt);
    
    % time update
end
%%
[count_list_dt, time_list_dt] = n_mac_integrated(time,mac,siglevel,dt)



plot(time,count_list_dt)




