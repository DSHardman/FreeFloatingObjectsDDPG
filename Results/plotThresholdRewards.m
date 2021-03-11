function plotThresholdRewards(rewards, threshold)
    bools = rewards > threshold;
    rollingvalues = zeros(size(rewards));
    for i = 1:50
        rollingvalues(i) = nnz(bools(1:i+50))/(i+50);
    end
    for i = 51:length(rewards)-50
        rollingvalues(i) = nnz(bools(i-50:i+50))/101;
    end
    for i = length(rewards)-49:length(rewards)
        rollingvalues(i) = nnz(bools(i-50:end))/(51+length(rewards)-i);
    end
    
    %plot(rewards);
    %hold on
    plot(rollingvalues,'LineWidth',2,'Color','k');
end