frequency = 20; %of control and of tracking
period = 120; %running time

global cam cameraParams worldcentre imagecentre

for i = 29:100

    %starting theta between 50 & 120mm
    r_des = 50 + 70*rand();

    ResetPosition(r_des, pi/2);
    delete('Motions/Noise/Images/*') %delete previous tracking

    motions = zeros(period*frequency+1, 6); %preallocate motion matrix
    motions(:,1) = (0:1/frequency:period).'; %times

    motions(:,2) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %x m
    motions(:,3) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %y m
    motions(:,4) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %z m
    motions(:,5) = CreateStochasticNoise(0,2,motions(:,1),0.03); %xangle rad
    motions(:,6) = CreateStochasticNoise(0,2,motions(:,1),0.03); %yangle rad

    savename = strcat('Motions/Noise/RandomMotions', string(i),'.mat');
    save(savename,'motions'); %to be read by python controller
    filename = 'Tracking'; %for results later

    %%
    system(('start python FollowFile.py ' + string(i)));
    pause(15); %start recording 15s after calling

    %%
    tic

    for j = 1:period*frequency
        %take and save pictures
        while toc < j/frequency % wait until correct time
            continue
        end
        photo = TakePhoto(cam, cameraParams);
        imwrite(photo, strcat('Motions/Noise/Images/Image',string(j),'.jpg'));
    end

    %%
    results = zeros(period*frequency, 3);
    g = figure(); 

    for j = 1:period*frequency   

        set(0, 'currentfigure', g);
        photo = imread(strcat('Motions/Noise/Images/Image',string(j),'.jpg'));
        [m_x, m_y] = SinglePosition(photo, imagecentre); %locate & draw circle

        if ~isempty(m_x) %if circle found
            n = 0; %reset 'not-found' counter to zero

            %transform to world coordinates
            w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [m_x m_y]);

            %relative to centre
            w_x = w_p(1) - worldcentre(1);
            w_y = w_p(2) - worldcentre(2);

            [theta, r] = cart2pol(w_x, w_y); %polar coordinates
            if r >= 155 %outer edge
                m = m+1;
                if m>=frequency*5 %run for 5 seconds at edge before break
                    load(savename); %remove saved actions not included
                    motions = motions(1:j,:);
                    save(savename,'motions');
                    break
                end
            else
                m = 0;
            end

            results(j,:) = [toc w_x w_y];

        else %if not found, use last result
            results(j,:) = results(j-1,:);
            n = n+1;
            if n>= frequency*2 %run for 2 seconds unknown before break
                load(savename); %remove saved actions not performed
                motions = motions(1:j,:);
                save(savename,'motions');
                break
            end
        end

    end
    close(g)

    %remove any zeros remaining at end of results array
    results = results(find(results(:,1),1,'first'):find(results(:,1),1,'last'), :);

    matname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\Noise\',...
        filename,string(i),'.mat');
    save(matname, 'results');

end
