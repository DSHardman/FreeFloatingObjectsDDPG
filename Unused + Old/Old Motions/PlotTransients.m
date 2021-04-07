filename = strcat('t_swirl.mat'); load(filename);

diffr = zeros(length(results(:,1)),1);
for i = 2:length(results(:,1))
    diffr(i-1) = results(i,3) - results(i-1,3);
    if abs(diffr(i-1)) > 3
        diffr(i-1) = diffr(i-1) + 2*pi;
    end
    diffr(i-1) = diffr(i-1)/(results(i,1)-results(i-1,1));
end

subplot(2,1,1);
plot(results(:,1),results(:,2)); hold on;
plot(results(:,1), smooth(results(:,2), 500), 'linewidth', 2);
line([300 300], [0 200], 'linestyle', '--', 'color', 'k');
ylim([0 200]);
ylabel('Distance from Centre (mm)');
text(310, 50, '5 Minutes');
legend({'Data','Smoothed'}, 'location', 'se');

subplot(2,1,2);
plot(results(50:end,1), diffr(50:end)); hold on;
plot(results(50:end,1), smooth(diffr(50:end), 500), 'linewidth', 3);
line([300 300], [0 3], 'linestyle', '--', 'color', 'k');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');
text(310, 0.8, '5 Minutes');
legend({'Data','Smoothed'}, 'location', 'se');