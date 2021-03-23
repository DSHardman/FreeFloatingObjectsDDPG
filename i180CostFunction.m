function cost = i180CostFunction(x)%, filename, cam,cameraParams,worldcentre,imagecentre)
    global cam cameraParams worldcentre imagecentre
    preview(cam)
    params = Parameters(x.xamp, x.xfreq, x.xphase,...
        x.yamp, x.yfreq, x.yphase, x.zamp, x.zfreq,...
        x.depth, x.anglex, x.angley);

    TrackingPeriod = 120; %maximum time if target radius not reached
    r_target = 45;
    r_outer = 160;
    lambda = 5; % in cost function

    %saving
    sv = 0; %save
    filename = 'CHANGETHIS';
   

    %%
    % tracking view
    g = figure();

    %assume up to 5Hz tracking rate
    results = zeros(TrackingPeriod/0.2, 3);

    tic
    params.performnormalised(TrackingPeriod); %start plunger moving
    while toc < 5
        continue
    end

    n = 1;
    tic

    while toc < TrackingPeriod
        %radial position from image
        photo = TakePhoto(cam, cameraParams);
        set(0, 'currentfigure', g);
        
        outflag = 0;
        
        [m_x, m_y] = SinglePosition(photo, imagecentre); %locate & draw circle
        text(50,50, string(toc),'color', 'r'); %display timer

        if ~isempty(m_x) %only update results if object could be found 
           
            %transform to world coordinates
            w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [m_x m_y]);

            %relative to centre
            w_x = w_p(1) - worldcentre(1);
            w_y = w_p(2) - worldcentre(2);

            [theta, r] = cart2pol(w_x, w_y);

            results(n,:) = [toc r theta];
            
             %exit when outer radius reached
            if r >= r_outer
                outflag = 1;
                system('taskkill /F /IM "python3.9.exe" /T');
                break
            end
            
            
            n = n + 1;
            
        end
        drawnow('update');

    end
    close(g)
    
    pause(5)

    %remove any zeros remaining at end of results array
    results = results(find(results(:,1),1,'first'):find(results(:,1),1,'last'), :);
    
    %calculate cost function

    mindist = NaN;
    %[xdes, ydes] = pol2cart(5*pi/4,165);
    %[xdes, ydes] = pol2cart(pi/4,165);
    [xdes, ydes] = pol2cart(3*pi/4,165);
    for i = 1:size(results,1)
        [xcurrent, ycurrent] = pol2cart(results(i,3),results(i,2));
        dist = sqrt((xdes-xcurrent)^2+(ydes-ycurrent)^2);
        mindist = min([mindist dist 3000]);
    end
    
    
    if (size(results, 1) < 3)
        cost = 500;
    else
        if ~outflag
            results(end,1) = 120;
        end
        mindist = min([mindist 3000]);
        cost = results(end,1) + mindist;
    end
    
    if cost < 0.4
        cost = 500;
    end
    
    %pause();
    pause(2);
    drawnow('update')
    
    %ResetPosition(90,pi/4,cam,cameraParams,worldcentre,imagecentre) %reset floating object
    
    %optionally save results
    if sv
        matname = strcat('Motions\Bayesian\',filename,'.mat');
        save(matname, 'results');
    end
end