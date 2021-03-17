function ResetQuick(r_des, theta_des)
    %assuming alignment of axes
    %% send location to UR5 controller
    command = 'python QuickReset.py ' + string(r_des) + ' ' + string(pi/2-theta_des);
    system(command);
    
    close()
   
    pause();
end