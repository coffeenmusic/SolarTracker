function [hour_diff] = time_diff_calc(time_vector, UTC_vector)

day_diff = abs(time_vector(1,3) - UTC_vector(1,3));

hour = 0;
if(day_diff>0) %If the time difference results in there being a different date
    temporary = [time_vector(1,3) UTC_vector(1,3)];
    [C I] = max(temporary);
    if (I==1)
        hour = time_vector(1,4);
        hour = hour + (24 - UTC_vector(1,4));
    elseif (I==2)
        hour = UTC_vector(1,4);
        hour = hour + (24 - time_vector(1,4));
    end    
else % Same day
    hour = abs(time_vector(1,4)-UTC_vector(1,4));
end

hour_diff = hour;