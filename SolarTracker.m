% Azimuth and Elevation Tracker
% Last Update 05/27/2012 Rev. 2

clc; clear all; close all;

local_City = 'Roanoke'; % Sets Time Zone

polar(0,1,''); % First thing plotted sets the range, so set to a radius of 1
hold on;

% If you would like to insert your own time and date just uncomment 'now'
% below and put in [Year Month Day Hour Min Sec Etc]
% now = datenum([2012 5 27 18 0 0]); 
 
% Calculate current Azimuth and Elevation using current time (now)
[Azimuth Elevation] = solar_Calculations(now,local_City);
sun_trajectory = polar((pi/180)*(-Azimuth),cos(Elevation*(pi/180)),'*');


% Sun Trajectory Plotter..........................................
start_hour = 6; % Arbitrary start and end hour. Somewhere near horizon.
end_hour = 23;
time_vector = datevec(now);     % Convert to human editable date/time
time_vector(1,4) = start_hour;  % Insert start hour into time
time_vector(1,5) = 0;           % Start at 0 minutes
time_vector(1,6) = 0;           % Start at 0 seconds
hour = start_hour;
% Go from start to finish hour and plot Azimuth and Elevation
i = 1;
while(hour<end_hour)
    time = datenum(time_vector);   % Convert to machine readable time
    [Az El] = solar_Calculations(time,local_City);
    if (El>0) % Don't plot once sun is set
        sun_trajectory = polar((pi/180)*(-Az),cos(El*(pi/180)));
    end
    time = addtodate(time,4,'minute'); 
    time_vector = datevec(time);
    hour = time_vector(1,4);
    i = i+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot labels and modifications ..........................
view(-90,90); % Rotate Graph
text(1.03,.09,'North');
text(-1.03,.09,'South');
text(0,1.4,'West');
text(0,-1.2,'East');
ylabel('View while laying on your back with your head pointing North');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%