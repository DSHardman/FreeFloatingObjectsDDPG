function [r_out, theta_out] = misreportStartingPosition(r, theta)
    [x, y] = pol2cart(theta, r);
    direction = rand(2,1)-0.5*ones(2,1); %direction
    direction = direction/norm(direction); %unit vector
    magnitude = 150*rand(); %magnitude
    error = magnitude*direction
    x = x + error(1);
    y = y + error(2);
    [theta_out, r_out] = cart2pol(x, y);
    theta_out = mod(theta_out, 2*pi); %between 0 & 2pi rather than -pi pi
end