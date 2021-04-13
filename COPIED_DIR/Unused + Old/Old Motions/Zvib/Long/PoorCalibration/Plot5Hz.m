figure()
%subplot(1,2,1);
load('2D5Hz_n1.mat'); plot(results(:,1), results(:,2));
ylabel('Distance from centre (mm)');
xlabel('Time (s)');
ylim([40 220]);
hold on
line([15 15], [40 220], 'color', 'k');
line([45 45], [40 220], 'color', 'k');
line([0 70], [160 160], 'color', 'r', 'LineStyle', '--');
pause()
load('2D5Hz_n2.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n3.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n5.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n7.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n8.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n9.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n4.mat'); plot(results(:,1), results(:,2));
pause()
load('2D5Hz_n6.mat'); plot(results(:,1), results(:,2));
pause()
%title('r');


% subplot(1,2,2);
% load('2D5Hz_n1.mat'); plot(results(:,1), results(:,3));
% hold on
% load('2D5Hz_n2.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n3.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n4.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n5.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n6.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n7.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n8.mat'); plot(results(:,1), results(:,3));
% load('2D5Hz_n9.mat'); plot(results(:,1), results(:,3));
% title('Theta');