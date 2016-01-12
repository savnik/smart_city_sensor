function [ count_list_dt, time_list_dt ] = n_mac_integrated(time,mac,siglevel,dt)
%N_MAC_INTEGRATED Summary of this function goes here
%   Detailed explanation goes here

    t_now = time(1); % time start
    n_data = length(mac)

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

end

