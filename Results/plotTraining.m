breakpoints = [1448 1946 2481];
%breakpoints = [];
ylims = [-2 3];
finalpoint = length(rewards);
xlims = [0 finalpoint];
save = 0;
savename = 'training';

%rewards = 1.15*rewards; %only to scale reward function 2

meanroll = 500;
stdroll = 500;
splinelength = 30;

colors = 1/255*[[217 95 2];... %actual std
    [217 95 2];... %actual mean
    [117 112 179];... %predicted std
    [117 112 179]]; %predicted mean

figure('Position', [300 200 1200 600])

plot(nan,'Color',colors(4,:),'LineWidth',2);
hold on
plot(nan,'Color',colors(2,:),'LineWidth',2);

sr = smooth(rewards,meanroll);
sr = interp1(1:length(sr), sr(1:end), 1:splinelength:finalpoint, 'spline');

rew_std = movstd(rewards, stdroll);
rew_std = interp1(1:length(rew_std), rew_std(1:end), 1:splinelength:finalpoint, 'spline');

inBetween = [sr+rew_std, fliplr(sr-rew_std)];

fill([1:splinelength:finalpoint, fliplr(1:splinelength:finalpoint)], inBetween,...
    colors(1,:), 'EdgeColor', 'None', 'FaceAlpha', 0.2);


sq = smooth(qs,meanroll);
sq = interp1(1:length(sq), sq(1:end), 1:splinelength:finalpoint, 'spline');

q_std = movstd(qs, stdroll);
q_std = interp1(1:length(q_std), q_std(1:end), 1:splinelength:finalpoint, 'spline');

inBetween = [sq+q_std, fliplr(sq-q_std)];
fill([1:splinelength:finalpoint, fliplr(1:splinelength:finalpoint)], inBetween,...
    colors(3,:), 'EdgeColor', 'None', 'FaceAlpha', 0.2);

    
%plot(rewards, 'color', [0.7 0.7 0.7]);
%plot(qs, 'color', [0.7 0.4 0]);

%plot(sq(1:end-1),'Color',colors(4,:),'LineWidth',4);
plot(1:splinelength:finalpoint, sq,...
    'Color',colors(4,:),'LineWidth',4);

%plot(sq(1:end-1),'Color',colors(4,:),'LineWidth',4);
plot(1:splinelength:finalpoint, sr,...
    'Color',colors(2,:),'LineWidth',4);


breakpoints = [xlims(1) breakpoints];
if length(breakpoints) > 1
    for i = 1:length(breakpoints)
        line([breakpoints(i) breakpoints(i)], [-2 -1.5], 'color', 'k', 'LineWidth', 2);
        text(breakpoints(i)+30, ylims(1)+0.4, char(64+i), 'FontSize', 25);
    end
end

box off
ylim(ylims);
xlim(xlims);
set(gca, 'FontSize', 27, 'LineWidth',2);
xlabel('Iterations');
ylabel('Reward');
legend(["Predicted" "Actual"], 'Orientation', 'Horizontal', 'Location', 'nw');
legend boxoff

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        savename+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end