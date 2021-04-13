% called by plotBayesians in creating paper's Bayesian figure

save = 0;
savename = 'test';

global plottingcolor

%{
for i = 1:4
    theta = (i-1)*pi/4;
    viscircles([0 0], i*165/4, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
    line([-165*cos(theta) 165*cos(theta)], [165*sin(theta) -165*sin(theta)], 'Color', [0.5 0.5 0.5]);
    hold on
end
%}

%h = viscircles([0 0], 165, 'Color', 'None'); hold on
%fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    
%viscircles([0 0], 165, 'Color', 'k');
partcircle(0,0,165, [-(pi/2*(bayes_state(3)+1))+0.08 -(pi/2*(bayes_state(3)+1))-0.08]); hold on

[x, y] = pol2cart(-(pi/2*(bayes_state(3)+1)), 165);
%scatter(x, y, 30, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'w');
partcircle(x, y, 12, [-(pi/2*(bayes_state(3)+1))+pi/2 -(pi/2*(bayes_state(3)+1))-pi/2]);
%h = viscircles([x y], 7, 'Color', 'k');
%fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');

for i  = 1:5
    load(stringbase + string(i) + '.mat');
    [x, y] = pol2cart(-(results(:,3)-pi/4), min(results(:,2),165));
    p = plot(smooth(x,10), smooth(y,10), 'LineWidth', 1.5, 'Color', plottingcolor);
    p.Color(4) = 0.5; 
    c = get(p,'Color');
    scatter(x(end), y(end), 20, c, '*', 'LineWidth', 1, 'MarkerEdgeAlpha', 0.5)
    %h = viscircles([0 0], 20, 'Color', 'k');
    %fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    hold on
end

[x, y] = pol2cart(-(pi/2*(bayes_state(2)+1)), 65*(bayes_state(1)+1) + 40);
scatter(x, y, 30, 'MarkerEdgeColor', 'k', 'MarkerFaceColor', plottingcolor);


axis square
set(gca,'XColor', 'none','YColor','none')

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        savename+string(num)+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end

function circle(x,y,r)
ang=0:0.01:2*pi;
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
end

function partcircle(x,y,r, angles)
if mod(angles(2),2*pi) < mod(angles(1),2*pi)
    ang=mod(angles(1),2*pi):0.01:mod(angles(2),2*pi)+2*pi;
else
    ang=mod(angles(1),2*pi):0.01:mod(angles(2),2*pi);
end
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
end