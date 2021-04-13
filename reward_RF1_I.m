% Reward Function 1 from paper (Linear Decay Exp)
% Scaled by 1.15 to cover similar range when included in paper

function Reward = reward_RF1_I(State, results, outflag)

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

      
    mindist = NaN;
    [xdes, ydes] = pol2cart(theta_des,165);
    for i = 1:size(results,1)
        [xcurrent, ycurrent] = pol2cart(results(i,3),results(i,2));
        dist = sqrt((xdes-xcurrent)^2+(ydes-ycurrent)^2);
        mindist = min([mindist dist 3000]);
    end
    
    mindist = min([mindist 3000]);
    
    Reward = 3*exp(-3*mindist/165) - 1;
    
    if isnan(Reward)
        Reward = -1.25;
    end

end