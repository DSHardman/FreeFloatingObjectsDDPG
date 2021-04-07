%% TURN SAVING FUNCTIONALITY ON BEFORE RUNNING

% run n tests on agent from random starting position, and save results

n = 1000;

mcritic = saved_agent.getCritic();

States = zeros(n,3);
Actions = zeros(n,11);
Rewards = zeros(n,1);
Predictions = zeros(n,1);

for i = 1:n
    fprintf('//////Test %d///////\n',i);
    [~, LoggedSignal] = reset_IROS(cam, cameraParams, worldcentre, imagecentre);
    Action = double(cell2mat(saved_agent.getAction(LoggedSignal))); % use proposed action
    %Action = [1;1;1;1;1;1;1;-1;1;-1;-1]; % use user-defined action
    %Action = 2*rand(11,1) - ones(11,1); % use random action
    [~,Reward,~,~] = step_IROS(Action,LoggedSignal,cam,cameraParams,worldcentre,imagecentre);
    prediction = mcritic.getValue(LoggedSignal,Action);
    matname = 'C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\TESTRECENT.mat';
    save(matname, 'States','Actions','Rewards','Predictions');
    States(i,:) = LoggedSignal.';
    Actions(i,:) = Action.';
    Rewards(i) = Reward;
    Predictions(i) = prediction;
end