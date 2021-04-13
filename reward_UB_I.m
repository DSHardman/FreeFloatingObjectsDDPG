% Reward Function for Unused Case B, incorcoratiing energy dependent term

function Reward = reward_UB_I(State, Action, results, outflag)

    if isempty(results)
        Reward = -1;
        return
    end

    theta_des = pi/2*(State(3,1)+1) + pi/4;
    
    if outflag
        fprintf('Edge hit\n');
    else
        fprintf('No edge hit\n');
    end
    
    nAction = (Action + ones(11,1))/2;
    Reward = (1/6)*((nAction(1)*nAction(2))^2 +...
        (nAction(4)*nAction(5))^2 + (nAction(7)*nAction(8))^2); %Energy term
    
    
    
    mindist = NaN;
    [xdes, ydes] = pol2cart(theta_des,165);
    for i = 1:size(results,1)
        [xcurrent, ycurrent] = pol2cart(results(i,3),results(i,2));
        dist = sqrt((xdes-xcurrent)^2+(ydes-ycurrent)^2);
        mindist = min([mindist dist 3000]);
    end
    
    mindist = min([mindist 3000]);
    fprintf('Energy: %f, Distance: %f\n', Reward, 3*exp(-3*mindist/165))
    
    Reward = Reward + 3*exp(-3*mindist/165) - 0.75;
 
    if isnan(Reward)
        Reward = -1.25;
    end
end