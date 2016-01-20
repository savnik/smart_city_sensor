function [ time_filtered,mac_filtered,siglevel_filtered ] = one_mac_filter(time,mac,siglevel, macA )
%ONE_MAC_FILTER Remove all samples except macA
%   Detailed explanation goes here

    time_filtered = [];
    mac_filtered = [];
    siglevel_filtered = [];

    for i = 1:length(mac)
       if strcmp(mac(i),macA)
            time_filtered = [time_filtered, time(i)];
            mac_filtered = [mac_filtered, mac(i)];
            siglevel_filtered = [siglevel_filtered, siglevel(i)];
       end
    end

end

