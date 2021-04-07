% Run n physical agent tests m times each and save results

n = 1; %number of tests

m = 5; %number of iterations in each

mcritic = saved_agent.getCritic();

States = zeros(n,3*m);
Actions = zeros(n,11);
Rewards = zeros(n,m);
Predictions = zeros(n,1);

for i = 1:n
    %[~, LoggedSignal] = reset_IROS(cam, cameraParams, worldcentre,
    %imagecentre); % Random task
    
    %LoggedSignal = [-11/13; 0.4; -0.4];  % Task i
    %LoggedSignal = [-9/13; 0; 0];  % Task ii
    LoggedSignal = [-5/13; 0.5; 0.8];  % Task iii
    %LoggedSignal = [-(3/13); -1; 0]; % Task iv
    %LoggedSignal = [-(3/13); -1; 1]; % Task v
    
    Action = double(cell2mat(saved_agent.getAction(LoggedSignal)));
    Actions(i,:) = Action.'; 
    prediction = mcritic.getValue(LoggedSignal,Action);
    Predictions(i) = prediction;
    for j = 1:m
        fprintf('//////Test %d///////\n',i);
        fprintf('//////Iteration %d///////\n',j);
        %ResetPosition_IROS(65*(LoggedSignal(1,1)+1)+1, (pi/2)*(LoggedSignal(2,1)+1)+(pi/4), cam, cameraParams, worldcentre, imagecentre);
        ResetQuick(65*(LoggedSignal(1,1)+1)+40, (pi/2)*(LoggedSignal(2,1)+1)+(pi/4));
        
        %Store actual position
        I = TakePhoto(cam, cameraParams);
        pause(1);
        [im_x, im_y] = SinglePosition(I, imagecentre);
        close();

        if ~isempty(im_x)
            w_p  = pointsToWorld(cameraParams,...
            cameraParams.RotationMatrices(:,:,1),...
            cameraParams.TranslationVectors(1,:), [im_x im_y]);
            w_x = w_p(1) - worldcentre(1);
            w_y = w_p(2) - worldcentre(2);
            [theta, r] = cart2pol(w_x, w_y);
        else
            theta = (pi/2)*(LoggedSignal(2,1)+1)+(pi/4);
            r = 65*(LoggedSignal(1,1)+1)+40;
        end
        
        theta = mod(theta, 2*pi);
        States(i,(j-1)*3+1:j*3) = [((r-40)/65-1) ((theta-pi/4)/(pi/2)-1) LoggedSignal(3)];
    
        [~,Reward,~,~] = step_IROS(Action,LoggedSignal,cam,cameraParams,worldcentre,imagecentre);
        matname = 'C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\TESTRECENT.mat';
        save(matname, 'States','Actions','Rewards','Predictions');
        Rewards(i,j) = Reward;
    
    end
end