function URVibrate(UR_amp, UR_freq, UR_T)
    command = 'start python CallVibrate.py ' + string(UR_amp)...
                    + ' ' + string(UR_freq) + ' ' + string(UR_T);
    system(command);
end 