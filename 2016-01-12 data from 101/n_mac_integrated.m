function [ count_list_dt, t_vec ] = n_mac_integrated(time,mac,siglevel,dt)
%N_MAC_INTEGRATED Number of mac addr pressent in time interval dt
%   time, time vektor datetime
%   mac, mac address vector
%   siglevel, signal level vector
%   dt, time interval in minutes

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

end

