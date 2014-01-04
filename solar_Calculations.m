function [Azimuth Elevation] = solar_Calculations(now,local_City)

% Go here to get your lat/long < http://itouchmap.com/latlong.html >
Latitude = 36.559528; % input your latitude
Longitude_deg = -82.625077; % input your longitude

time_vector = datevec(now);                         % Your current time for your timeZone
time_hour = time_vector(1,4);

t = timeZones();
UTC = t.dst2utc(now,local_City);     % Universal Time Constant (a.k.a GMT)
UTC_vector = datevec(UTC);
UTC_hour = UTC_vector(1,4);

jd = juliandate(now); % Interval of time in days and fractions of a day since January 1, 4713 BC Greenwich noon

% Calculate time difference between your time zone and UTC time
time_Diff = time_diff_calc(time_vector,UTC_vector);

% This calculates how many degrees you are away from the UTC standard
% meridian (Prime Meridian), because the earth rotates 15 degrees every hour.
% Meridian is the key word in local standard time meridian.
% This gives your Meridian's longitude because the Prime Meridian is 0 deg
LSTM_deg = (15*time_Diff); % Local Standard Time Meridian (Degrees)

day = floor(jd2doy(jd)); % Day count since start of the year

x = ((360*(day-1))/365.242)*(pi/180); %In Radians
B = ((360/365)*(day-81))*(pi/180);
% Equation of time is the difference between mean solar time and solar time
% Solar time is based off of Noon being orthogonal to your location
% Solar mean time is the average noon over a 365.25 day period
EOT = (0.258*cos(x)) - (7.416*sin(x)) - (3.648*cos(2*x)) - (9.228*sin(2*x)); 
EOT2 = (9.87*sin(2*B))-(7.53*cos(B))-(1.5*sin(B)); % Different way to calculate the same thing (not being used)

% The earth rotates 4mins every degree, so this calculates the number of
% minutes to correct the time beacause of the difference auihfuhfdj
TC = (4*(Longitude_deg + LSTM_deg)) + EOT2; % Time Correction (Minutes)
TC_secs = round((TC - floor(TC))*60); % Fraction leftover from TC

LST = addtodate(now,floor(TC),'minute');       % Local Solar Time (One of the most important things to know)
LST = addtodate(LST,TC_secs,'second');
LST_vector = datevec(LST);              % The sun is at its highest point in the sky at noon
hours_LST = LST_vector(1,4)+(LST_vector(1,5)/60)+(LST_vector(1,6)/(60*60)); % This is so I can hold LST as an integer in units of hours

hour_Angle = 15*(hours_LST-12);     % This just converts the local solar time into an angle, 
                                    % where 0 degrees is at noon, earlier is negative, later is positive

% This is the angle between the equatorial plane and the path of solar rays
declination = (180/pi)*asin(sin(23.45*(pi/180))*sin((360/365)*(day-81)*(pi/180)));  % Declination Angle [Degrees]

Elevation = (asin((sin(declination*(pi/180))*sin(Latitude*(pi/180)))+(cos(declination*(pi/180))*cos(Latitude*(pi/180))*cos(hour_Angle*(pi/180)))))*(180/pi);
%Azimuth is defined differently in different contexts, for our purpose it
%is the angle from due north heading eastward. (Some define from S to E)
Azimuth = (acos(((sin(declination*(pi/180))*cos(Latitude*(pi/180)))-(cos(declination*(pi/180))*sin(Latitude*(pi/180))*cos(hour_Angle*(pi/180))))/cos(Elevation*(pi/180))))*(180/pi);
if(hours_LST>12)
   Azimuth = 360 - Azimuth; 
end

