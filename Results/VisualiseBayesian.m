save = 0;
savename = 'test';

bayes_state = [0;-0.8;1];

for i = 1:4
    theta = (i-1)*pi/4;
    viscircles([0 0], i*165/4, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
    line([-165*cos(theta) 165*cos(theta)], [165*sin(theta) -165*sin(theta)], 'Color', [0.5 0.5 0.5]);
    hold on
end

%viscircles([0 0], 165, 'Color', 'k');

[x, y] = pol2cart(-(pi/2*(bayes_state(3)+1)), 165);
h = viscircles([x y], 7, 'Color', 'k');
fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');

for i  = 1:10
    try
        %load('C:\Users\dshar\Downloads\atest' + string(i) + '.mat');
        load('C:\Users\dshar\Downloads\Bayes180_1_test' + string(i) + '.mat');
        %load(stringbase + string(i) + '.mat');
        [x, y] = pol2cart(-(results(:,3)-pi/4), min(results(:,2),165));
        p = plot(smooth(x,10), smooth(y,10), 'LineWidth', 1.5, 'Color', [0 0.2 0.6]);
        p.Color(4) = 0.2; 
        c = get(p,'Color');
        scatter(x(end), y(end), 50, c, '*', 'LineWidth', 1, 'MarkerEdgeAlpha', 0.5)
        
        %h = viscircles([0 0], 20, 'Color', 'k');
        %fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
        hold on
    catch
    end    
end

%[x, y] = pol2cart(-(pi/2*(bayes_state(2)+1)), 65*(bayes_state(1)+1) + 40);
%scatter(x, y, 150, 'k', 'x', 'LineWidth', 3)

axis square
set(gca,'XColor', 'none','YColor','none')

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        savename+string(num)+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end