n = 50;

mcritic = saved_agent.getCritic();

States = zeros(50,3);
Actions = zeros(50,11);
Rewards = zeros(50,1);
Predictions = zeros(50,1);

for i = 1:n
    fprintf('//////Test %d///////\n',i);
    [~, LoggedSignal] = reset_IROS(cam, cameraParams, worldcentre, imagecentre);
    Action = saved_agent.getAction(LoggedSignal);
    [~,Reward,~,~] = step_IROS(Action,LoggedSignal,cam,cameraParams,worldcentre,imagecentre);
    prediction = mcritic.getValue(LoggedSignal,Action);
    matname = 'C:\Users\44772\Documents\dsh46WaterControl\Motions\RL\TESTRECENT.mat';
    save(matname, 'States','Actions','Rewards','Predictions');
end