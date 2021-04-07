function ResetPosition_IROS(r_des, theta_des, cam, cameraParams, worldcentre, imagecentre)
    %assuming alignment of axes
    % Called by reset_IROS
    
    %% locate object
    for i = 1:3
        %I = TakePhoto(cam, cameraParams);
        %preview(cam);
        %pause(1);
        I = TakePhoto(cam, cameraParams);
        pause(4);
        [im_x, im_y] = SinglePosition(I, imagecentre);
        %close();
        if ~isempty(im_x)
            break
        end
        if i == 1
        	system('python LiftArm.py');
            % workaround
            %fprintf('workaround')
            %im_x = 1000;
        	%im_y = 1000;
            %break
        end
        %have 3 attempts at locating: else pass large enough
        %values that the plunger traces the tub edge
        %fprintf('end')
        im_x = 1000;
        im_y = 1000;
    end
    
    
    %transform to world coordinates
    w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [im_x im_y]);
    %relative to centre
    w_x = w_p(1) - worldcentre(1);
    w_y = w_p(2) - worldcentre(2);
    [theta, r] = cart2pol(w_x, w_y);
    
    %{
    if theta < 0 && theta > -pi/4
        r = 1000; %workaround
    end
    %}


    %% send location to UR5 controller
    command = 'python PickUp.py ' + string(r) + ' ' + string(pi/2-theta)...
        + ' ' + string(r_des) + ' ' + string(pi/2-theta_des);
    system(command);
    
    close()
   
end