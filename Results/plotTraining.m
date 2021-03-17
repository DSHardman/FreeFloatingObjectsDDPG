breakpoints = [1448 1946 2481];
ylims = [-2 4];
xlims = [0 5000];
save = 0;
savename = 'training';

figure('Position', [300 200 1200 600])

plot(nan,'Color',[0.5 0.1 0],'LineWidth',2);
hold on
plot(nan,'Color','k','LineWidth',2);

rew_std = movstd(rewards, 500);
inBetween = [[smooth(rewards,100)+rew_std].',...
    [flipud(smooth(rewards,100)-rew_std)].'];
fill([1:length(rew_std), fliplr(1:length(rew_std))], inBetween,...
    [0.7 0.7 0.7], 'EdgeColor', 'None', 'FaceAlpha', 0.4);

q_std = movstd(qs, 500);
inBetween = [[smooth(qs,100)+q_std].', [flipud(smooth(qs,100)-q_std)].'];
fill([1:length(q_std), fliplr(1:length(q_std))], inBetween,...
    [0.7 0.4 0.7], 'EdgeColor', 'None', 'FaceAlpha', 0.4);

%plot(rewards, 'color', [0.7 0.7 0.7]);
%plot(qs, 'color', [0.7 0.4 0]);

plot(smooth(qs,100),'Color',[0.5 0.1 0],'LineWidth',2);
plot(smooth(rewards,100),'Color','k','LineWidth',2);


breakpoints = [xlims(1) breakpoints];
if length(breakpoints) > 1
    for i = 1:length(breakpoints)
        line([breakpoints(i) breakpoints(i)], [-2 -1.5], 'color', 'k', 'LineWidth', 2);
        text(breakpoints(i)+30, ylims(1)+0.4, char(64+i), 'FontSize', 15);
    end
end

box off
ylim(ylims);
xlim(xlims);
set(gca, 'FontSize', 15, 'LineWidth',2);
xlabel('Iterations');
ylabel('Reward');
legend(["Predicted" "Actual"], 'Orientation', 'Horizontal', 'Location', 'nw');
legend boxoff

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        savename+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end