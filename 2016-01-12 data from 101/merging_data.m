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
[time19,mac19,siglevel19] = import_log('1 - NE/2016-1-12-8-log_whitelist.txt');
[time10,mac10,siglevel10] = import_log('1 - NE/2016-1-12-9-log_whitelist.txt');
[time11,mac11,siglevel11] = import_log('1 - NE/2016-1-12-10-log_whitelist.txt');
[time12,mac12,siglevel12] = import_log('1 - NE/2016-1-12-11-log_whitelist.txt');
[time13,mac13,siglevel13] = import_log('1 - NE/2016-1-12-13-log_whitelist.txt');

[time29,mac29,siglevel29] = import_log('2 - SE/2016-1-12-8-log_whitelist.txt');
[time20,mac20,siglevel20] = import_log('2 - SE/2016-1-12-9-log_whitelist.txt');
[time21,mac21,siglevel21] = import_log('2 - SE/2016-1-12-10-log_whitelist.txt');
[time22,mac22,siglevel22] = import_log('2 - SE/2016-1-12-11-log_whitelist.txt');
[time23,mac23,siglevel23] = import_log('2 - SE/2016-1-12-13-log_whitelist.txt');

[time39,mac39,siglevel39] = import_log('3 - SW/2016-1-12-8-log_whitelist.txt');
[time30,mac30,siglevel30] = import_log('3 - SW/2016-1-12-9-log_whitelist.txt');
[time31,mac31,siglevel31] = import_log('3 - SW/2016-1-12-10-log_whitelist.txt');
[time32,mac32,siglevel32] = import_log('3 - SW/2016-1-12-11-log_whitelist.txt');
[time33,mac33,siglevel33] = import_log('3 - SW/2016-1-12-12-log_whitelist.txt');
[time34,mac34,siglevel34] = import_log('3 - SW/2016-1-12-13-log_whitelist.txt');

[time49,mac49,siglevel49] = import_log('4 - NW/2016-1-12-8-log_whitelist.txt');
[time40,mac40,siglevel40] = import_log('4 - NW/2016-1-12-9-log_whitelist.txt');
[time41,mac41,siglevel41] = import_log('4 - NW/2016-1-12-10-log_whitelist.txt');
[time42,mac42,siglevel42] = import_log('4 - NW/2016-1-12-11-log_whitelist.txt');
[time43,mac43,siglevel43] = import_log('4 - NW/2016-1-12-13-log_whitelist.txt');

time1 = [time19; time10; time11; time12; time13];
mac1 = [mac19; mac10; mac11;mac12;mac13];
siglevel1 = [siglevel19; siglevel10; siglevel11;siglevel12;siglevel13];

time2 = [time29; time20; time21; time22; time23];
mac2 = [mac29; mac20; mac21;mac22;mac23];
siglevel2 = [siglevel29; siglevel20; siglevel21;siglevel22;siglevel23];

time3 = [time39; time30; time31; time32; time33; time34];
mac3 = [mac39; mac30; mac31; mac32;mac33; mac34];
siglevel3 = [siglevel39; siglevel30; siglevel31; siglevel32;siglevel33; siglevel34];

time4 = [time49; time40; time41; time42; time43];
mac4 = [mac49; mac40; mac41;mac42;mac43];
siglevel4 = [siglevel49; siglevel40; siglevel41;siglevel42;siglevel43];

[final_time, final_mac, final_signal] = get_merged_to_file(time1, time2, time3, time4, mac1, mac2, mac3, mac4, siglevel1, siglevel2, siglevel3, siglevel4);

% Plot of overall (to check that working)
% [count_list_dt1, time_list_dt1] = n_mac_integrated(final_time,final_mac,final_signal,(60/60));
% display('Plotting...')
% hold on;
% plot(time_list_dt1,count_list_dt1)
% grid on;
% hold off;

% Plot strength of each individual
firstname = '40:a5:ef:06:1f:2f';
secondname = '40:a5:ef:06:1c:ba';
thirdname = '40:a5:ef:06:19:a0';
fourthname = '40:a5:ef:06:13:e3';

display('Plotting...')
hold on;

% test
    temp_sig1 = [];
    temp_sig2 = [];
    temp_sig3 = [];
    temp_sig4 = [];
    temp_time1 = [];
    temp_time2 = [];
    temp_time3 = [];
    temp_time4 = [];
    
    for j = 1:length(final_mac)
        if strcmp(final_mac(j), firstname)
            for k = 1:4
                if final_signal(k,j) ~= -100                    
                    if k == 1
                        temp_sig1 = [ temp_sig1, final_signal(k,j)];
                        temp_time1 = [ temp_time1, final_time(j)];
                    elseif k == 2
                        temp_sig2 = [ temp_sig2, final_signal(k,j)];
                        temp_time2 = [ temp_time2, final_time(j)];
                    elseif k == 3
                        temp_sig3 = [ temp_sig3, final_signal(k,j)];
                        temp_time3 = [ temp_time3, final_time(j)];
                    else
                        temp_sig4 = [ temp_sig4, final_signal(k,j)];
                        temp_time4 = [ temp_time4, final_time(j)];
                    end
                         
                end
            end
        end
    end
    subplot(2,2,1)       % add first plot in 2 x 1 grid
    plot(temp_time1,temp_sig1,temp_time2,temp_sig2,temp_time3,temp_sig3,temp_time4,temp_sig4);
    
    %test2
    temp_sig1 = [];
    temp_sig2 = [];
    temp_sig3 = [];
    temp_sig4 = [];
    temp_time1 = [];
    temp_time2 = [];
    temp_time3 = [];
    temp_time4 = [];
    
    for j = 1:length(final_mac)
        if strcmp(final_mac(j), secondname)
            for k = 1:4
                if final_signal(k,j) ~= -100   % remove all -100 as noise                 
                    if k == 1
                        temp_sig1 = [ temp_sig1, final_signal(k,j)];
                        temp_time1 = [ temp_time1, final_time(j)];
                    elseif k == 2
                        temp_sig2 = [ temp_sig2, final_signal(k,j)];
                        temp_time2 = [ temp_time2, final_time(j)];
                    elseif k == 3
                        temp_sig3 = [ temp_sig3, final_signal(k,j)];
                        temp_time3 = [ temp_time3, final_time(j)];
                    else
                        temp_sig4 = [ temp_sig4, final_signal(k,j)];
                        temp_time4 = [ temp_time4, final_time(j)];
                    end
                         
                end
            end
        end
    end
    subplot(2,2,2)       % add first plot in 2 x 1 grid
    plot(temp_time1,temp_sig1,temp_time2,temp_sig2,temp_time3,temp_sig3,temp_time4,temp_sig4);
    
    %test3
    temp_sig1 = [];
    temp_sig2 = [];
    temp_sig3 = [];
    temp_sig4 = [];
    temp_time1 = [];
    temp_time2 = [];
    temp_time3 = [];
    temp_time4 = [];
    
    for j = 1:length(final_mac)
        if strcmp(final_mac(j), thirdname)
            for k = 1:4
                if final_signal(k,j) ~= -100                    
                    if k == 1
                        temp_sig1 = [ temp_sig1, final_signal(k,j)];
                        temp_time1 = [ temp_time1, final_time(j)];
                    elseif k == 2
                        temp_sig2 = [ temp_sig2, final_signal(k,j)];
                        temp_time2 = [ temp_time2, final_time(j)];
                    elseif k == 3
                        temp_sig3 = [ temp_sig3, final_signal(k,j)];
                        temp_time3 = [ temp_time3, final_time(j)];
                    else
                        temp_sig4 = [ temp_sig4, final_signal(k,j)];
                        temp_time4 = [ temp_time4, final_time(j)];
                    end
                         
                end
            end
        end
    end
    subplot(2,2,3)       % add first plot in 2 x 1 grid
    plot(temp_time1,temp_sig1,temp_time2,temp_sig2,temp_time3,temp_sig3,temp_time4,temp_sig4);
    
    %test4
    temp_sig1 = [];
    temp_sig2 = [];
    temp_sig3 = [];
    temp_sig4 = [];
    temp_time1 = [];
    temp_time2 = [];
    temp_time3 = [];
    temp_time4 = [];
    
    for j = 1:length(final_mac)
        if strcmp(final_mac(j), fourthname)
            for k = 1:4
                if final_signal(k,j) ~= -100                    
                    if k == 1
                        temp_sig1 = [ temp_sig1, final_signal(k,j)];
                        temp_time1 = [ temp_time1, final_time(j)];
                    elseif k == 2
                        temp_sig2 = [ temp_sig2, final_signal(k,j)];
                        temp_time2 = [ temp_time2, final_time(j)];
                    elseif k == 3
                        temp_sig3 = [ temp_sig3, final_signal(k,j)];
                        temp_time3 = [ temp_time3, final_time(j)];
                    else
                        temp_sig4 = [ temp_sig4, final_signal(k,j)];
                        temp_time4 = [ temp_time4, final_time(j)];
                    end
                         
                end
            end
        end
    end
    subplot(2,2,4)       % add first plot in 2 x 1 grid
    plot(temp_time1,temp_sig1,temp_time2,temp_sig2,temp_time3,temp_sig3,temp_time4,temp_sig4);

grid on;
hold off;
