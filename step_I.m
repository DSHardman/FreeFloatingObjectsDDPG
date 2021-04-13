function [NextObs,Reward,IsDone,LoggedSignals, results] = step_I(Action,LoggedSignals,cam,cameraParams,worldcentre,imagecentre)
    %global cam cameraParams worldcentre imagecentre
    preview(cam)
    Action
    State = LoggedSignals
    tic;
    params = Parameters(Action);
    
    TrackingPeriod = 120; %maximum time
    r_outer = 160; %THIS WILL CHANGE WITH MORPHOLOGY
    
    % Saving: search folder for files using current stub, and add 1 to name
    sv = 0; %save
    %{
    filestub = 'RL';
    cd 'C:\Users\44772\Documents\dsh46WaterControl\Motions\RL'
    contents = dir;
    cd 'C:\Users\44772\Documents\dsh46WaterControl'
    M = NaN;
    for i = size(contents,1)
        if ~isempty(strfind(contents(i).name,filestub))
            m = str2double(contents(i).name(length(filestub)+1:end-4));
            M = max(m,M);
        end
    end
    if isnan(M)
        filename = filestub;
    else
        filename = strcat(filestub,string(M+1));
    end
    %}
    
    %%
    % tracking view
    g = figure();

    %assume up to 5Hz tracking rate
    results = zeros(TrackingPeriod/0.2, 3);

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
        drawtarget_I(State, cam, cameraParams, worldcentre, imagecentre); % draw target location
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
            if r >= r_outer && n > 1
                outflag = 1;
                system('taskkill /F /IM "python3.9.exe" /T');
                fprintf('Reached Edge: n = %d\n', n);
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
    
    %calculate reward
    Reward = reward_I(State, results, outflag)
    %Reward = reward2_I(State, Action, results, outflag)
    %pause(5);
    drawnow('update')
    
    
    %optionally save results
    if sv
        matname = strcat('C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\RL',datestr(now,'mm-dd-yyyy HH-MM-SS'),'.mat');
        save(matname, 'results');
    end
    
    
    LoggedSignals = State;
    NextObs = LoggedSignals;
    
    IsDone = 1;

end