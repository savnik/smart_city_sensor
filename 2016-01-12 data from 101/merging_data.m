% fff
%
% 30571 - Smart city sensor
% 
% Get the merged data from all the whitelists
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

display('Number of elements');
length(time1), length(time2), length(time3), length(time4)

% Find out the earliest time and final time
t_first = min([time1(1) time2(1) time3(1) time4(1)]);
t_last = max([time1(length(time1)) time2(length(time2)) time3(length(time3)) time4(length(time4))]);
t_now = t_first;

final_time = [];
final_mac = [];
final_signal = [[]];

%Iterate through time
while t_now <= t_last
    %iterate through list 1
    for i = length(time1):-1:1
        %if time in list 1
        if time1(i) == t_now
            %empty variables containing other signals
            temp2 = -100;
            temp3 = -100;
            temp4 = -100;
            %find similar in the other lists. First list 2
            for j = length(time2):-1:1                
                % same time
                if time2(j) == time1(i)
                    % same mac
                    if strcmp(mac2(j), mac1(i))
                        % temporarily save them
                        temp2 = siglevel2(j);
                        % delete elements
                        time2(j) = [];
                        mac2(j) = [];
                        siglevel2(j) = [];
                    end
                end
            end
            % Now list 3
            for j = length(time3):-1:1                
                % same time
                if time3(j) == time1(i)
                    % same mac
                    if strcmp(mac3(j), mac1(i))
                        % temporarily save them
                        temp3 = siglevel3(j);
                        % delete elements
                        time3(j) = [];
                        mac3(j) = [];
                        siglevel3(j) = [];
                    end
                end
            end
            %finally list 4
            for j = length(time4):-1:1                
                % same time
                if time4(j) == time1(i)
                    % same mac
                    if strcmp(mac4(j), mac1(i))
                        % temporarily save them
                        temp4 = siglevel4(j);
                        % delete elements
                        time4(j) = [];
                        mac4(j) = [];
                        siglevel4(j) = [];
                    end
                end
            end
            %make entry
            final_time = [final_time, time1(i)];
            final_mac = [final_mac, mac1(i)];
            temp_signal = [siglevel1(i); temp2; temp3; temp4];
            final_signal = [final_signal, temp_signal ];
            
            % remove 
            time1(i) = [];
            mac1(i) = [];
            siglevel1(i) = [];
        end
    end
    
    %iterate through list 2
    for i = length(time2):-1:1
        %if time in list 1
        if time2(i) == t_now
            %empty variables containing other signals
            temp1 = -100;
            temp3 = -100;
            temp4 = -100;
            %find similar in the other lists. First list 2
            for j = length(time1):-1:1                
                % same time
                if time1(j) == time2(i)
                    % same mac
                    if strcmp(mac1(j), mac2(i))
                        % temporarily save them
                        temp1 = siglevel1(j);
                        % delete elements
                        time1(j) = [];
                        mac1(j) = [];
                        siglevel1(j) = [];
                    end
                end
            end
            % Now list 3
            for j = length(time3):-1:1                
                % same time
                if time3(j) == time2(i)
                    % same mac
                    if strcmp(mac3(j), mac2(i))
                        % temporarily save them
                        temp3 = siglevel3(j);
                        % delete elements
                        time3(j) = [];
                        mac3(j) = [];
                        siglevel3(j) = [];
                    end
                end
            end
            %finally list 4
            for j = length(time4):-1:1                
                % same time
                if time4(j) == time2(i)
                    % same mac
                    if strcmp(mac4(j), mac2(i))
                        % temporarily save them
                        temp4 = siglevel4(j);
                        % delete elements
                        time4(j) = [];
                        mac4(j) = [];
                        siglevel4(j) = [];
                    end
                end
            end
            %make entry
            final_time = [final_time, time2(i)];
            final_mac = [final_mac, mac2(i)];
            temp_signal = [ temp1;siglevel2(i); temp3; temp4];
            final_signal = [final_signal, temp_signal ];
            
            % remove 
            time2(i) = [];
            mac2(i) = [];
            siglevel2(i) = [];
        end
    end
    
    %iterate through list 3
    for i = length(time3):-1:1
        %if time in list 1
        if time3(i) == t_now
            %empty variables containing other signals
            temp2 = -100;
            temp1 = -100;
            temp4 = -100;
            %find similar in the other lists. First list 2
            for j = length(time2):-1:1                
                % same time
                if time2(j) == time3(i)
                    % same mac
                    if strcmp(mac2(j), mac3(i))
                        % temporarily save them
                        temp2 = siglevel2(j);
                        % delete elements
                        time2(j) = [];
                        mac2(j) = [];
                        siglevel2(j) = [];
                    end
                end
            end
            % Now list 3
            for j = length(time1):-1:1                
                % same time
                if time1(j) == time3(i)
                    % same mac
                    if strcmp(mac1(j), mac3(i))
                        % temporarily save them
                        temp1 = siglevel1(j);
                        % delete elements
                        time1(j) = [];
                        mac1(j) = [];
                        siglevel1(j) = [];
                    end
                end
            end
            %finally list 4
            for j = length(time4):-1:1                
                % same time
                if time4(j) == time3(i)
                    % same mac
                    if strcmp(mac4(j), mac3(i))
                        % temporarily save them
                        temp4 = siglevel4(j);
                        % delete elements
                        time4(j) = [];
                        mac4(j) = [];
                        siglevel4(j) = [];
                    end
                end
            end
            %make entry
            final_time = [final_time, time3(i)];
            final_mac = [final_mac, mac3(i)];
            temp_signal = [ temp1; temp2;siglevel3(i); temp4];
            final_signal = [final_signal, temp_signal ];
            
            % remove 
            time3(i) = [];
            mac3(i) = [];
            siglevel3(i) = [];
        end
    end
    
    %iterate through list 4
    for i = length(time4):-1:1
        %if time in list 1
        if time4(i) == t_now
            %empty variables containing other signals
            temp2 = -100;
            temp3 = -100;
            temp1 = -100;
            %find similar in the other lists. First list 2
            for j = length(time2):-1:1                
                % same time
                if time2(j) == time4(i)
                    % same mac
                    if strcmp(mac2(j), mac4(i))
                        % temporarily save them
                        temp2 = siglevel2(j);
                        % delete elements
                        time2(j) = [];
                        mac2(j) = [];
                        siglevel2(j) = [];
                    end
                end
            end
            % Now list 3
            for j = length(time3):-1:1                
                % same time
                if time3(j) == time4(i)
                    % same mac
                    if strcmp(mac3(j), mac4(i))
                        % temporarily save them
                        temp3 = siglevel3(j);
                        % delete elements
                        time3(j) = [];
                        mac3(j) = [];
                        siglevel3(j) = [];
                    end
                end
            end
            %finally list 4
            for j = length(time1):-1:1                
                % same time
                if time1(j) == time4(i)
                    % same mac
                    if strcmp(mac1(j), mac4(i))
                        % temporarily save them
                        temp1 = siglevel1(j);
                        % delete elements
                        time1(j) = [];
                        mac1(j) = [];
                        siglevel1(j) = [];
                    end
                end
            end
            %make entry
            final_time = [final_time, time4(i)];
            final_mac = [final_mac, mac4(i)];
            temp_signal = [temp1; temp2; temp3; siglevel4(i);];
            final_signal = [final_signal, temp_signal ];
            
            % remove 
            time4(i) = [];
            mac4(i) = [];
            siglevel4(i) = [];
        end
    end
    
    %increase time
    t_now = t_now + seconds(1);
end

% Plot of overall (to check that working
[count_list_dt1, time_list_dt1] = n_mac_integrated(final_time,final_mac,final_signal,1);
display('Plotting...')
hold on;
plot(final_time,count_list_dt1)
grid on;
hold off;

