function Reward = reward_IROS(State, results, outflag)
    sigma_1 = pi/6;
    sigma_2 = 33;
    
    theta_des = pi/2*(State(3,1)+1) + pi/4;
    
    if outflag
        ang = results(end,3) - theta_des;
        Reward = normpdf(ang,0,sigma_1)/normpdf(0,0,sigma_1);
    else
        Reward = -1;
    end
    
    mindist = NaN;
    for i = 1:size(results,1)
        dist = abs(pol2cart(results(i,3),results(i,2)) - pol2cart(theta_des,165));
        mindist = min(mindist, dist);
    end
    
    Reward = Reward + normpdf(mindist, 0, sigma_2)/normpdf(0,0,sigma_2);
end