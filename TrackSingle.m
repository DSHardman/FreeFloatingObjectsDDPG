%% First connect and calibrate camera

%% 
%UR5 control
vibrate = 0;
UR_amp = 0.005; %in m
UR_freq = 6; %in Hz
UR_T = 300; %in seconds
n=5;

TrackingPeriod = 20; %in seconds

%saving
sv = 0; %save
filename = strcat('zvib_a', string(UR_amp), '_f', string(UR_freq), '_n', string(n), '.mat');

%%
% tracking view
g = figure(1);

%assume up to 5Hz tracking rate
results = zeros(TrackingPeriod/0.2, 3);

if vibrate
    URVibrate(UR_amp, UR_freq, UR_T)
end

n = 1;
tic

while toc < TrackingPeriod
    %radial position from image
    I = TakePhoto(cam, cameraParams);
    set(0, 'currentfigure', g);
    [im_x, im_y] = SinglePosition(I, imagecentre);
    text(50,50, string(toc),'color', 'r');
    
    if ~isempty(im_x) %only update results if object could be found  
        
        %transform to world coordinates
        w_p  = pointsToWorld(cameraParams,...
            cameraParams.RotationMatrices(:,:,1),...
            cameraParams.TranslationVectors(1,:), [im_x im_y]);
        
        %relative to centre
        w_x = w_p(1) - worldcentre(1);
        w_y = w_p(2) - worldcentre(2);
        
        [theta, r] = cart2pol(w_x, w_y);
        
        results(n,:) = [toc r theta];
        n = n + 1;
    end
   
end
close

%remove any zeros remaining at end of results array
results = results(find(results(:,1),1,'first'):find(results(:,1),1,'last'), :);

%optionally save results
if sv
    matname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\2D\',filename,'.mat');
    save(matname, 'results');
end