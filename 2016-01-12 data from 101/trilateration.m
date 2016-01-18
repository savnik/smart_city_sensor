%% 30571 - Smart city sensor
% Data calibration from logfiles of Mac_logger.py
% Peter Savnik
%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;

load('test.mat')

% Observation points position
A = [0,0];
B = [0,15.606];
C = [24.325+22.311,15.101];
D = [19.641+23.601,0];
observation_positions = [A;B;C;D];

% Parameters for converting RSS to distance
PK = -25;
a = 2.5;

%final_signal = [sqrt(15^2+5^2), sqrt(15^2+5^2)
%                sqrt((15^2)+(5-15)^2), sqrt((15^2)+(5-15)^2)
%                sqrt((46-15)^2+(15-5)^2), sqrt((46-15)^2+(15-5)^2)
%                sqrt((43-15)^2+(5)^2), sqrt((43-15)^2+(5)^2)];

x = [];
y = [];
data_log = {};

% for each sample
[n,m] = size(final_signal)
for i = 1:m
    
    % guessing a starting point at center of cantine
    x_star = 25;
    y_star = 7.5;

    x_log = [];
    y_log = [];
 
    % iterate until delta x or delta y < 5m
    not_done = true;
    while not_done
        a_i = []; % clear
        r = [];
        A = [];
        B = [];
        C = [];
        %for each observation points (4 points)
        k = 0; % dummy var
        for j = 1:4
            %if != -100 dB  (-100dB == No data)
            if final_signal(j,i) ~= -100
                k = k+1;
                % calculate distance
                r(j) = rss2dist(final_signal(j,i), PK, a);
                %r(j) = final_signal(j,i);
                % r_n calculate trilateration

                x_i = observation_positions(j,1);
                y_i = observation_positions(j,2);

                a_i(j) = sqrt((x_i-x_star)^2+(y_i-y_star)^2);
                A(k,1) = -(x_i-x_star)/a_i(j);
                A(k,2) = -(y_i-y_star)/a_i(j);
                B(k) = r(j)-a_i(j); 
            end
            %A
            %B
            %k
        end % for each obervation point
        if k >= 3
            delta_position= A\(B');
            x_star = x_star+delta_position(1);
            y_star = y_star+delta_position(2);
            x_log = [x_log, x_star];
            y_log = [y_log, y_star];
       
            % check if done
            if (sqrt(delta_position(1)^2+delta_position(2)^2) <= 1)
                not_done = false;
                x = [x x_star];
                y = [y y_star];
               
                % data log = [time,mac,siglevel(1x4),x,y,interations,index i]
                [n m] = size(data_log);
                n = n+1;
                data_log{n,1} = final_time(i);
                data_log{n,2} = final_mac(i);
                data_log{n,3} = final_signal(:,i);
                data_log{n,4} = x_star;
                data_log{n,5} = y_star;
                data_log{n,6} = length(x_log);
                data_log{n,7} = i;
            end
            
            if length(x_log) > 500
                not_done = false;
                display('bad position')
            end
        else
            not_done = false;
       end
    end % while not_done
end

% plot
hold on;
grid on;
plot(observation_positions(:,1),observation_positions(:,2),'b*')
plot(x,y,'r*')

legend('Observation units','Esitmation process')
%xlim([-10,80])
hold off;



