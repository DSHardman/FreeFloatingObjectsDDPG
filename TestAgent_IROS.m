%% Real Testing

n = 10;

mcritic = saved_agent.getCritic();

simOptions = rlSimulationOptions('MaxSteps',1,'NumSimulations',n);

experience = sim(env,saved_agent,simOptions);

simrewards = zeros(n,1);
simstates = zeros(n,3);
simactions = zeros(n,11);
predrewards = zeros(n,1);
for i = 1:n
    simrewards(i) = experience(i).Reward.Data;
    for j = 1:3
        simstates(i,j) = experience(i).Observation.StartingState.Data(j);
    end
    simactions(i,:) = experience(i).Action.Action.Data.';
    predrewards(i) = mcritic.getValue(simstates(i,:),simactions(i,:));
end

ur5variables = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
    "zfreq" "depth" "anglex" "angley"];
figure();
for i = 1:11
    subplot(4,3,i);
    plot(simactions(:,i));
    ylim([-1 1]);
    title(ur5variables(i));
end
subplot(4,3,12);
plot(simrewards);
hold on;
plot(predrewards);
ylim([-2 3]);
title("Reward");
legend({'Actual';'Predicted'});

%% Simulated Testing

n = 50;

mcritic = saved_agent.getCritic();

states = 2*rand(n,3) - ones(n,3);
actions = zeros(n,12);
rewards = zeros(n,1);
for i = 1:n
    actions(i,:) = saved_agent.getAction(states(i,:)).';
    rewards(i) = mcritic.getValue(states(i,:),actions(i,:));
end

ur5variables = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
    "zfreq" "depth" "anglex" "angley" "decay"];
figure();
for i = 1:12
    subplot(4,3,i);
    plot(actions(:,i));
    ylim([-1 1]);
    title(ur5variables(i));
end
%{
subplot(4,3,12);
plot(rewards);
ylim([-2 3]);
hold on;
%}
%title("Reward");