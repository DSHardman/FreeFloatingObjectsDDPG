function [r, theta] = pixels2polar(x, y, calibration)

    [xn, yn] = pixels2cartesian(x, y, calibration);
    
    % Convert to polar coordinates
    [theta, r] = cart2pol(xn, yn);
    
end