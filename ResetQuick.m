function ResetQuick(r_des, theta_des)
    % moves above reset position without turning electromagnet on.
    % object then manually moved to the position indicated.

    %assuming alignment of axes
    %% send location to UR5 controller
    command = 'python QuickReset.py ' + string(r_des) + ' ' + string(pi/2-theta_des);
    system(command);
    
    close()
   
    pause();
end