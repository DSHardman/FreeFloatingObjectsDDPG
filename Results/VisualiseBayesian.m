save = 0;
savename = 'test';

bayes_state = [0;-0.8;1];

for i  = 1:10
    try
        %load('atest' + string(i) + '.mat');
        load('C:\Users\dshar\Downloads\Bayes180_1_test' + string(i) + '.mat');
        [x, y] = pol2cart(-(results(:,3)-pi/4), results(:,2));
        plot(smooth(x,10), smooth(y,10), 'LineWidth', 2);     
        h = viscircles([0 0], 20, 'Color', 'k');
        fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
        viscircles([0 0], 165, 'Color', 'k');
        hold on
    catch
    end    
end

[x, y] = pol2cart(-(pi/2*(bayes_state(3)+1)), 165);
h = viscircles([x y], 7, 'Color', 'k');
fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');

%[x, y] = pol2cart(-(pi/2*(bayes_state(2)+1)), 65*(bayes_state(1)+1) + 40);
%scatter(x, y, 150, 'k', 'x', 'LineWidth', 3)

axis square
set(gca,'XColor', 'none','YColor','none')

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        savename+string(num)+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end