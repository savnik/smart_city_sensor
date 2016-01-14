function [ d ] = rssi_to_dist(rssi, PK, a)
%RSSI_TO_DIST Summary of this function goes here
%   Detailed explanation goes here
    d = 10.^((-PK+rssi)/(-10*a));

end

