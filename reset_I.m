function [InitialObservation, LoggedSignal] = reset_I(cam, cameraParams, worldcentre, imagecentre)
% Reset function into a random initial state
% This calls ResetPosition_I
    
    %global cam cameraParams worldcentre imagecentre
    
    % Choose position and move
    r_d = 60*rand() + 40
    %r_d = 40*rand() + 100
    theta_d = pi*rand() + pi/4
   
    ResetPosition_I(r_d, theta_d, cam, cameraParams, worldcentre, imagecentre)
    
    % Use webcam to determine actual value
    
    I = TakePhoto(cam, cameraParams);
    pause(1);
    [im_x, im_y] = SinglePosition(I, imagecentre);
    close();
    
    if ~isempty(im_x)
        %transform to world coordinates
        w_p  = pointsToWorld(cameraParams,...
        cameraParams.RotationMatrices(:,:,1),...
        cameraParams.TranslationVectors(1,:), [im_x im_y]);
        %relative to centre
        w_x = w_p(1) - worldcentre(1);
        w_y = w_p(2) - worldcentre(2);
        [theta, r] = cart2pol(w_x, w_y);
    else
        %if not located, pass values where it should be
        theta = theta_d;
        r = r_d;
    end
    
    theta = mod(theta, 2*pi); %between 0 & 2pi rather than -pi pi
    
    % Any deliberate errors in position should be introduced here
    %[r, theta] = misreportStartingPosition(r, theta);
    
    % Update normalised observation & logged signal
    State(1,1) = (r-40)/65 - 1; %values between 40 & 170 map between -1 & 1
    %State(1,1) = (r-40)/30 - 1;
    State(2,1) = (theta-pi/4)/(pi/2) - 1;
    State(3,1) = 2*rand() - 1;

    LoggedSignal = State;
    InitialObservation = State;

end