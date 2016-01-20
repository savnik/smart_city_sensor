function [ rssi ] = dist_to_rssi( d, PK, a )
%DIST_TO_RSSI Calculate distance to signal strength
%   Detailed explanation goes here
    rssi = PK-10*a*log10(d);
end

