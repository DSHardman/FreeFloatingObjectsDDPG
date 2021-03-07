n = 10;

mcritic = saved_agent.getCritic();

States = zeros(n,3);
Actions = zeros(n,12);
Rewards = zeros(n,1);
Predictions = zeros(n,1);

for i = 1:n
    fprintf('//////Test %d///////\n',i);
    [~, LoggedSignal] = reset_IROS(cam, cameraParams, worldcentre, imagecentre);
    Action = double(cell2mat(saved_agent.getAction(LoggedSignal)));
    %Action = [1;1;1;1;1;1;1;-1;1;-1;-1];
    %Action = 2*rand(11,1) - ones(11,1);
    [~,Reward,~,~] = step_IROS(Action,LoggedSignal,cam,cameraParams,worldcentre,imagecentre);
    prediction = mcritic.getValue(LoggedSignal,Action);
    matname = 'C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\TESTRECENT.mat';
    save(matname, 'States','Actions','Rewards','Predictions');
    States(i,:) = LoggedSignal.';
    Actions(i,:) = Action.';
    Rewards(i) = Reward;
    Predictions(i) = prediction;
end