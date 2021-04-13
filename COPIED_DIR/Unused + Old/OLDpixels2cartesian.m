function [xn, yn] = pixels2cartesian(x, y, calibration)

    % Rotate about centre
    R = [cos(calibration.rotation) sin(calibration.rotation);...
        -sin(calibration.rotation) cos(calibration.rotation)];
    point = [calibration.centrex; calibration.centrey] + ...
        R*([x;y] - [calibration.centrex; calibration.centrey]);
    
    % Stretch in y
    point = [point(1); calibration.ystretch*point(2)];
    
    % Subtract centre
    point = point - [calibration.centrex; calibration.centrey];
    
    % Convert to mm
    point = point*(calibration.realdiameter/calibration.diameter);
    xn = point(1); yn = point(2);
    
end