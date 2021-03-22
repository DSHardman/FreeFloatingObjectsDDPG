global plottingcolor plottingstyle

circle(0, 0, 165);
hold on

plottingcolor = 'm';
plottingstyle = '-';
ivdevelopment.plotOverlay(1,1);

plottingcolor = 'y';
plottingstyle = '-';
ivdevelopment.plotOverlay(3,1);


plottingcolor = 'w';
plottingstyle = '-';
Circle20.plotOverlay(4, 1);


[x, y] = pol2cart(-0.15, 100);
scatter(x, y, 300, 'w', '.', 'LineWidth', 1);


set(gca, 'Color', 'k');
set(gcf, 'Color', 'k');

function circle(x,y,r)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
end