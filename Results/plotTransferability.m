figure();

titles = ["Task i" "Task ii" "Task iii" "Task iv" "Task v"];

for i = 1:5
    subplot(7,5,i);
    Circle20.plotOverlay(i, 1);
    title(titles(i));
    box on
    set(gca, 'LineWidth', 2);
end
subplot(7,5,1);
ylabel('20mm Circle');

for i = 1:5
    subplot(7,5,i+5);
    Circle8.plotOverlay(i, 1);
end
subplot(7,5,6);
ylabel('8mm Circle');

for i = 1:5
    subplot(7,5,i+10);
    Circle46.plotOverlay(i, 1);
end
subplot(7,5,11);
ylabel('46mm Circle');

for i = 1:5
    subplot(7,5,i+15);
    Circle72.plotOverlay(i, 1);
end
subplot(7,5,16);
ylabel('72mm Circle');

for i = 1:5
    subplot(7,5,i+20);
    Square22.plotOverlay(i, 1);
end
subplot(7,5,21);
ylabel('22mm Square');

for i = 1:5
    subplot(7,5,i+25);
    Square35.plotOverlay(i, 1);
end
subplot(7,5,26);
ylabel('22mm Square');

for i = 1:5
    subplot(7,5,i+30);
    Quatrefoil.plotOverlay(i, 1);
end
subplot(7,5,31);
ylabel('Quatrefoil');