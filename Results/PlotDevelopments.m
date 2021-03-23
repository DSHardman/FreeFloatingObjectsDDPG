global plottingcolor plottingstyle
plottingstyle = '-';

figure('Position', [300 300 900 500]);

subplot = @(m,n,p)subtightplot(m,n,p,[0.05 0.001], [0.005 0.05], [0.01 0.01]);

thesecolors = (1/255)*[[127 255 0]; [69 162 255]; [255 0 127]];
for i = [1 3]
    plottingcolor = thesecolors((i+1)/2, :);
    subplot(3,7,((i+1)/2));
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    %circle(0, 0, 165); hold on
    idevelopment.plotOverlay(i, 1);
    
    subplot(3,7,4+((i+1)/2));
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    %circle(0, 0, 165); hold on
    iidevelopment.plotOverlay(i, 1);
    
    subplot(3,7,7+((i+1)/2));
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    %circle(0, 0, 165); hold on
    iiidevelopment.plotOverlay(i, 1);
    
    subplot(3,7,11+((i+1)/2));
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    %circle(0, 0, 165); hold on
    ivdevelopment.plotOverlay(i, 1);

    subplot(3,7,14+((i+1)/2));
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    %circle(0, 0, 165); hold on
    vdevelopment.plotOverlay(i, 1);
end

plottingcolor = thesecolors(3, :);
locations = [3 7 10 14 17];
for i = 1:5
    subplot(3,7,locations(i));
    %circle(0, 0, 165); hold on
    h = viscircles([0 0], 165, 'Color', 'None'); hold on
    fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
    Circle20.plotOverlay(i, 1);
end

subplot(3,7,2); title('i', 'Color', 'k');
subplot(3,7,6); title('ii', 'Color', 'k');
subplot(3,7,9); title('iii', 'Color', 'k');
subplot(3,7,13); title('iv', 'Color', 'k');
subplot(3,7,16); title('v', 'Color', 'k');

subplot(3,7,[19, 20, 21]);
im = imread('DevelopKey.png');
imshow(im);

set(gcf, 'Color', 'w');

function circle(x,y,r)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'Color', [0.5 0.5 0.5], 'LineWidth', 1);
end
