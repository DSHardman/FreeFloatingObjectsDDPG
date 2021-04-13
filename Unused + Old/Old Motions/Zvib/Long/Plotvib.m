frequencies = [2; 3; 4; 5; 6];
amplitudes = [0.001; 0.005];

sz = 5;
colours = ['r'; 'b'; 'g'; 'm'; 'c'];

f = figure(1);
g = figure(2);
h = figure(3);
G = figure(4);

for i = 1:length(frequencies)
   for j = 1:length(amplitudes)
       for n = 1:5
            filename = strcat('zvib_a', string(amplitudes(j)),...
                '_f', string(frequencies(i)), '_n', string(n), '.mat.mat');
            load(filename);
            
            results(:,3) = results(:,3) - results(1,3);
            results(:,3) = mod(results(:,3)+pi, 2*pi) - pi;
            for m = 2:length(results(:,3))
                if abs(results(m,3) - results(m-1,3)) > 3
                    for q = m:length(results)
                        results(q,3) = results(q,3) + 2*pi;
                    end
                end
            end
            
            set(0, 'currentfigure', f); subplot(2,5,i+(j-1)*5);
            [x, y] = pol2cart(results(:,3), results(:,2));
            plot(x, y, colours(n), 'linewidth', 2); hold on
            viscircles([0 0], 180, 'color', 'k', 'LineStyle', '--');
            viscircles([0 0], 20, 'color', 'k', 'LineStyle', '--');
            xlim([-200 200])
            ylim([-200 200])
            line([0 200], [0 0], 'color', 'k', 'LineStyle', '--');
            
            set(0, 'currentfigure', g); subplot(2,5,i+(j-1)*5);
            plot(results(:,1), results(:,2), colours(n), 'linewidth', 2); hold on
            line([0 330], [180 180], 'color', 'k', 'LineStyle', '--');
            line([0 330], [20 20], 'color', 'k', 'LineStyle', '--');
            xlim([0 330])
            ylim([0 200])
            
            set(0, 'currentfigure', h); subplot(2,5,i+(j-1)*5);
            plot(results(:,1), results(:,3), colours(n), 'linewidth', 2); hold on
            line([0 330], [-pi -pi], 'color', 'k', 'LineStyle', '--');
            line([0 330], [pi pi], 'color', 'k', 'LineStyle', '--');
            xlim([0 330])
            ylim([-5 5])
            
            set(0, 'currentfigure', G); subplot(2,5,i+(j-1)*5);
            plot(results(:,1), results(:,2)-results(1,2), colours(n), 'linewidth', 2); hold on
            xlim([0 330])
            ylim([-200 200])
             
       end
   end
end

set(0, 'currentfigure', f); subplot(2,5,1); title('2 Hz'); ylabel('A = 1mm');
subplot(2,5,2); title('3 Hz');
subplot(2,5,3); title('4 Hz');
subplot(2,5,4); title('5 Hz');
subplot(2,5,5); title('6 Hz');
subplot(2,5,6); ylabel('A = 5mm'); sgtitle('Path Followed');
set(0, 'currentfigure', g); subplot(2,5,1); title('2 Hz'); ylabel('A = 1mm');
subplot(2,5,2); title('3 Hz');
subplot(2,5,3); title('4 Hz');
subplot(2,5,4); title('5 Hz');
subplot(2,5,5); title('6 Hz');
subplot(2,5,6); ylabel('A = 5mm');
subplot(2,5,8); xlabel('Time (s)'); sgtitle('Distance from Centre');
set(0, 'currentfigure', h); subplot(2,5,1); title('2 Hz'); ylabel('A = 1mm');
subplot(2,5,2); title('3 Hz');
subplot(2,5,3); title('4 Hz');
subplot(2,5,4); title('5 Hz');
subplot(2,5,5); title('6 Hz');
subplot(2,5,6); ylabel('A = 5mm');
subplot(2,5,8); xlabel('Time (s)'); sgtitle('Angle from Centre');
set(0, 'currentfigure', G); subplot(2,5,1); title('2 Hz'); ylabel('A = 1mm');
subplot(2,5,2); title('3 Hz');
subplot(2,5,3); title('4 Hz');
subplot(2,5,4); title('5 Hz');
subplot(2,5,5); title('6 Hz');
subplot(2,5,6); ylabel('A = 5mm');
subplot(2,5,8); xlabel('Time (s)'); sgtitle('Delta r');