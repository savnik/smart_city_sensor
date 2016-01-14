function [ time_dt,mac_dt,siglevel_dt ] = timeinterval( time, mac, siglevel, time_start, time_end )
%TIMEINTERVAL Get time interval
%   Detailed explanation goes here
    time_dt = [];
    mac_dt = [];
    siglevel_dt = [];

    for i = 1:length(time)
       if isbetween(time(i),time_start,time_end) == 1
             time_dt = [time_dt, time(i)];
             mac_dt = [mac_dt, mac(i)];
             siglevel_dt = [siglevel_dt, siglevel(i)];
       end
    end


end

