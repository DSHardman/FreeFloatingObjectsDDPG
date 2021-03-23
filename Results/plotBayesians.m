subplot = @(m,n,p)subtightplot(m,n,p,[0.02 0.02], [0.15 0.05], [0.1 0.1]);

global plottingcolor
plottingcolor = 1/255*[217 95 2];

stdroll = 200;
meanroll = 100;
splinelength = 10;

figure('Position', [244.2000  397.0000  996.8000  462.0000]);
%[117 112 179]
colors = 1/255*[[100 100 100]; [0 0 0]; [10 110 251]];%[117 112 179]];%[252 141 98]];%[217 95 2]];

%% path plots
subplot(2,3,1);
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Motions\Bayesian\0\Bayes0_3_';
bayes_state = [-3/13;-1;-1];
VisualiseBayesian
title('0^o');

subplot(2,3,2);
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Motions\Bayesian\90\Bayes90_3_';
bayes_state = [-3/13;-1;0];
VisualiseBayesian
title('90^o');

subplot(2,3,3);
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Motions\Bayesian\180\Bayes180_3_';
bayes_state = [-3/13;-0.85;1];
VisualiseBayesian
title('180^o');

%% 0 deg progress
subplot(2,3,4);

plotprogress(bayes0, stdroll, meanroll, splinelength, colors);
ylabel('Cost Function');
set(gca, 'LineWidth', 2, 'Fontsize', 12);

%% 90 deg progress
subplot(2,3,5);
plot(nan, 'Color', colors(3,:), 'LineWidth', 2);
hold on
plot(nan, 'Color', colors(2,:), 'LineWidth', 2);

plotprogress(bayes90, stdroll, meanroll, splinelength, colors);

set(gca,'YTickLabels', []);

xlabel('Iterations');
set(gca,'LineWidth', 2, 'Fontsize', 12);
legend('Minimum', 'Average', 'Orientation', 'horizontal', 'Location', 'n');
legend boxoff

%% 180 deg progress
subplot(2,3,6);

plotprogress(bayes180, stdroll, meanroll, splinelength, colors);

set(gca,'YTickLabel', []);
set(gca, 'LineWidth', 2, 'Fontsize', 12);

%sgtitle('Bayesian Optimisations');
set(gcf, 'Color', 'w');

function plotprogress(bayesin, stdroll, meanroll, splinelength, colors)
    finalpoint = bayesin.NumObjectiveEvaluations;
    
    sb = smooth(bayesin.ObjectiveTrace,meanroll);
    sb = interp1(1:length(sb), sb(1:end), 1:splinelength:finalpoint, 'spline');
    
    ob_std = movstd(bayesin.ObjectiveTrace, stdroll);
    ob_std = interp1(1:length(ob_std), ob_std(1:end), 1:splinelength:finalpoint, 'spline');
    
    inBetween = [sb+ob_std, fliplr(sb-ob_std)];
    fill([1:splinelength:finalpoint, fliplr(1:splinelength:finalpoint)], inBetween,...
        colors(1,:), 'EdgeColor', 'None', 'FaceAlpha', 0.4); hold on

    plot(1:splinelength:finalpoint, sb, 'Color',colors(2,:), 'LineWidth', 2);
    
    plot(bayesin.ObjectiveMinimumTrace, 'Color', colors(3,:), 'LineWidth', 2);
    xlim([0 700]); ylim([0 500]);
    box off
end