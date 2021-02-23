save = 0;
filename = '2_0Hz';
TrackingPeriod = 20; %in seconds

%live plotting of mean positions, and tracking view
g = figure(1);
f = figure(2);

results = [];

tic
I = cam.snapshot();
[~, datum] = MeanPosition(I); %find starting position of floating objects

while toc < TrackingPeriod
    %calculate mean position from image
    I = cam.snapshot();
    I = imcrop(I, [0 0 500 480]);
    set(0, 'currentfigure', g);
    [x, y] = MeanPosition(I);
    
    %update results
    results = [results; toc y-datum];
    
    %plot
    %set(0, 'currentfigure', f);
    %plot(results(:,1),results(:,2));
    

end

%optionally save results
if save
    figname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\',filename,'PLOT.fig');
    saveas(f,figname);

    matname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\',filename,'.mat');
    save(matname, 'results');
end