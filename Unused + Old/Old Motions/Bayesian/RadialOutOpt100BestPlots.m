f = figure('Position', [100 300 1200 300]);
for i = 1:5
    subplot(1,3,2)
    load(strcat('RadOutOpt100Best', string(i), '.mat'));
    polarplot(results(:,3), results(:,2), 'LineWidth', 2);
    hold on;
    
    subplot(1,3,1)
    plot(results(:,1), results(:, 2), 'LineWidth', 2);
    hold on;
    
    subplot(1,3,3)
    plot(results(:,1), results(:,3), 'LineWidth', 2);
    hold on;
    ylim([0 1.6]);
end

subplot(1,3,2); set(gca, 'rTickLabel', [], 'thetaTickLabel', [], 'LineWidth', 2);
subplot(1,3,1); set(gca, 'FontSize', 15, 'LineWidth', 2); grid on; box off;
xlabel('Time (s)'); ylabel('r (mm)');
subplot(1,3,3); set(gca, 'FontSize', 15, 'LineWidth', 2); grid on; box off;
xlabel('Time (s)'); ylabel('Theta (rad)');