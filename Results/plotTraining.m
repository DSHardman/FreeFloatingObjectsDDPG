breakpoints = [300 2000];
ylims = [-2 5];
xlims = [0 4500];
save = 1;
savename = 'training'

figure('Position', [300 200 1200 600])

plot(nan,'Color',[0.5 0.1 0],'LineWidth',2);
hold on
plot(nan,'Color','k','LineWidth',2);

plot(rewards, 'color', [0.7 0.7 0.7]);
plot(qs, 'color', [0.7 0.4 0]);

plot(smooth(qs,100),'Color',[0.5 0.1 0],'LineWidth',2);
plot(smooth(rewards,100),'Color','k','LineWidth',2);


breakpoints = [xlims(1) breakpoints xlims(2)];
if length(breakpoints) > 2
    for i = 2:length(breakpoints)
        line([breakpoints(i) breakpoints(i)], [-2 -1.5], 'color', 'k', 'LineWidth', 2);
        text((breakpoints(i)+breakpoints(i-1))/2, ylims(1)+0.4, char(63+i), 'FontSize', 15);
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