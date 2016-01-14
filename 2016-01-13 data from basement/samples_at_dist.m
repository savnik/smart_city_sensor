function [ time_filtered,mac_filtered,siglevel_filtered ] = samples_at_dist(time,mac,siglevel,time_start,time_end,macA)
%SAMPLES_AT_DIST Summary of this function goes here
%   Detailed explanation goes here
    % get data in time interval
    [time_dt,mac_dt,siglevel_dt] = timeinterval(time,mac,siglevel,time_start,time_end);
    % take only one device and find all samples
    [ time_filtered,mac_filtered,siglevel_filtered ] = one_mac_filter(time_dt,mac_dt,siglevel_dt, macA );

end

