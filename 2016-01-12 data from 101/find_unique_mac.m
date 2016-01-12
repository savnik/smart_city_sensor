function [unique_time, unique_mac, unique_siglevel] = find_unique_mac(time, mac, siglevel)
%FIND_UNIQUE_MAC Find unique mac addr in list
%   Detailed explanation goes here
    n_data = length(mac);

    unique_time = [];
    unique_mac = [];
    unique_siglevel = [];

    for i = 1:n_data 
        % check if unique
        if length(unique_mac) == 0
           unique_time = [time(i)];
           unique_mac = [mac(i)];
           unique_siglevel = [siglevel(i)];
        else
            is_unique = 1;
            for j = 1:length(unique_mac)
               if strcmp(unique_mac(j),mac(i))
                   is_unique = 0;
                   break
               end
            end
            if is_unique
                unique_time = [unique_time, time(i)];
                unique_mac = [unique_mac, mac(i)];
                unique_siglevel = [unique_siglevel, siglevel(i)];
            end
        end

    end;
end

