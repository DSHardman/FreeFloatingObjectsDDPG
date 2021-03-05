starting_r = -1; %between -1 & 1
starting_theta = 0;

figure();
saved_agents = saved_agent; n = 1;
%for n = 1:19
    %fprintf('%d\n',n);
    %subplot(5,4,n);
    mcritic = saved_agents(n).getCritic();
    for i = 0:100
        state = [starting_r;starting_theta;i*0.02-1];
        action = getAction(saved_agents(n),state);
        scatter(state(3),mcritic.getValue(state,action),'k.'); hold on;
    end
    xlabel('Target theta')
    ylabel('Predicted Reward')
    ylim([-1 3]);
    xlim([-1 1]);
%end