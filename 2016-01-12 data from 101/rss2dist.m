function [ d ] = rss2dist(rss, PK, a)
%RSSI_TO_DIST Summary of this function goes here
%   Detailed explanation goes here
    d = 10^((-PK+rss)/(-10*a));

end