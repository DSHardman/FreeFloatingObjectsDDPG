for i = 1:4
    subplot(5,5,(i-1)*5+1);
    idevelopment.plotOverlay(i, 1);
    subplot(5,5,(i-1)*5+2);
    iidevelopment.plotOverlay(i, 1);
    subplot(5,5,(i-1)*5+3);
    iiidevelopment.plotOverlay(i, 1);
    subplot(5,5,(i-1)*5+4);
    ivdevelopment.plotOverlay(i, 1);
    subplot(5,5,(i-1)*5+5);
    vdevelopment.plotOverlay(i, 1);    
end

titles = ["Task i" "Task ii" "Task iii" "Task iv" "Task v"];
agents = ["Agent 1000" "Agent 2000" "Agent 3000" "Agent 4000" "Agent 5000"];
for i = 1:5
    subplot(5,5,20+i);
    Circle20.plotOverlay(i, 1);
    subplot(5,5,i); title(titles(i));
    subplot(5,5,(i-1)*5+1); ylabel(agents(i));
    subplot(5,5,20+i); box on; set(gca, 'LineWidth', 2);
end

sgtitle("Solution Development")
