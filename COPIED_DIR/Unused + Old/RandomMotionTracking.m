frequency = 20;
period = 120;

global cam cameraParams worldcentre imagecentre

motions = zeros(period*frequency+1, 6); %preallocate motion matrix
motions(:,1) = (0:1/frequency:period).'; %times

motions(:,2) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %x m
motions(:,3) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %y m
motions(:,4) = CreateStochasticNoise(0,5,motions(:,1),0.005/3); %z m
motions(:,5) = CreateStochasticNoise(0,2,motions(:,1),0.03); %xangle rad
motions(:,6) = CreateStochasticNoise(0,2,motions(:,1),0.03); %yangle rad

i = 20;
savename = strcat('Motions/Noise/RandomMotions', string(i),'.mat');
save(savename,'motions'); %to be read by python controller
filename = 'Tracking'; %for results later

%%
system('start python FollowFile.py');
pause(15);

%%
% tracking view
g = figure();

%assume up to 5Hz tracking rate
results = zeros(period/0.2, 3);

n = 1;
tic

while toc < period + 60 %track 30 seconds either side of plunger motion
    %radial position from image
    photo = TakePhoto(cam, cameraParams);
    set(0, 'currentfigure', g);
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

        [theta, r] = cart2pol(w_x, w_y); %polar coordinates

        results(n,:) = [toc r theta];
        n = n + 1;
    end

end
close(g)

matname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\Noise\',filename,string(i),'.mat');
save(matname, 'results');
