function ResetPosition(r_d, theta_d)
    global cam cameraParams worldcentre imagecentre
    %assuming alignment of axes
    if nargin == 2
        r_des = r_d;
        theta_des = theta_d;
    else
        r_des = 120; %mm
        theta_des = pi/2; %radians
    end
    
    
    %% locate object
    for i = 1:3
        %I = TakePhoto(cam, cameraParams);
        I = TakePhoto(cam, cameraParams);
        [im_x, im_y] = SinglePosition(I, imagecentre);
        close();
        if ~isempty(im_x)
            break
        end
        pause(1);
        system('python LiftArm.py');
        %have 3 attempts at locating: else pass large enough
        %values that the plunger traces the tub edge
        im_x = 500;
        im_y = 500;
    end
    
    %transform to world coordinates
    w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [im_x im_y]);
    %relative to centre
    w_x = w_p(1) - worldcentre(1);
    w_y = w_p(2) - worldcentre(2);
    [theta, r] = cart2pol(w_x, w_y);

    %% send location to UR5 controller
    command = 'python PickUp.py ' + string(r) + ' ' + string(pi/2-theta)...
        + ' ' + string(r_des) + ' ' + string(pi/2-theta_des);
    system(command);
    
    close()
   
end