figure('Position', [393.0000   77.8000  718.4000  792.8000]);

global plottingcolor plottingstyle
plottingstyle = '-';

subplot = @(m,n,p)subtightplot(m,n,p,[0.001 0.005], [0.005 0.05], [0.01 0.01]);

%{
locations = [1 2 3 8 9 10];
for i = 1:5
    subplot(7,8,locations(i));
    circle(0, 0, 165); hold on
    Circle20.plotOverlay(i, 1);
end
%}

locations = [1 2 3 8 9 10;...
            5 6 7 12 13 14;...
            22 23 24 29 30 31;...
            26 27 28 33 34 35;...
            43 44 45 50 51 52];

        
        
        
for i = 1:5
    plottingcolor = (1/255)*[255 127 0];
    subplot(8,7,locations(i,1));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Circle8.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
    
    plottingcolor = (1/255)*[127 255 0];
    subplot(8,7,locations(i,2));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Circle46.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
    
    plottingcolor = (1/255)*[0 255 127];
    subplot(8,7,locations(i,3));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Circle72.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
    
    plottingcolor = (1/255)*[69 162 255];
    subplot(8,7,locations(i,4));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Square22.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
    
    plottingcolor = (1/255)*[156 58 255];
    subplot(8,7,locations(i,5));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Square35.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
    
    plottingcolor = (1/255)*[255 0 127];
    subplot(8,7,locations(i,6));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Quatrefoil.plotOverlay(i, 1);
    %set(gca, 'Color', 'k');
end
subplot(8,7,2); title('i', 'Color', 'k');
subplot(8,7,6); title('ii', 'Color', 'k');
subplot(8,7,23); title('iii', 'Color', 'k');
subplot(8,7,27); title('iv', 'Color', 'k');
subplot(8,7,44); title('v', 'Color', 'k');

%{
subplot(8,7,[47,48,49,54,55,56]);
im = imread('ColourKey.png');
imshow(im);
%}
set(gcf, 'Color', 'w');

%{
exportgraphics(gcf, "AutosavedFigures/"+...
    "Transferability"+".eps", 'ContentType',...
    'vector', 'BackgroundColor', 'none');
%}

function circle(x,y,r)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
end