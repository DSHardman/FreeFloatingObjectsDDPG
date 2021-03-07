rm = zeros(7,1);
rs = zeros(7,1);
pm = zeros(7,1);
ps = zeros(7,1);
em = zeros(7,1);
es = zeros(7,1);
lm = zeros(7,1);
ls = zeros(7,1);

shapes = [Circle8; Circle20; Circle46; Circle72; Square22; Square35; Quatrefoil];

for i = 1:7 
    [rm(i), rs(i), pm(i), ps(i), em(i), es(i), lm(i), ls(i)] = shapes(i).stats();
end


X = categorical({'8mm Circle','20mm Circle','46mm Circle','72mm Circle','22mm Square','35mm Square','25mm Quatrefoil'});
X = reordercats(X,{'8mm Circle','20mm Circle','46mm Circle','72mm Circle','22mm Square','35mm Square','25mm Quatrefoil'});

figure();

subplot(2,4,1);
b = bar(X,rm, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\mu_{Reward}')
title('Rewards');

subplot(2,4,2);
b = bar(X,pm, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\mu_{Prediction}')
title('Predictions')

subplot(2,4,3);
b = bar(X,em, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\mu_{Error}')
title('Prediction - Reward')

subplot(2,4,4);
b = bar(X,lm, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\mu_{Path Length}')
title('Path Length');

subplot(2,4,5);
b = bar(X,rs, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\sigma_{Reward}')

subplot(2,4,6);
b = bar(X,ps, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\sigma_{Prediction}')

subplot(2,4,7);
b = bar(X,es, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\sigma_{Error}')

subplot(2,4,8);
b = bar(X,ls, 'FaceColor', 'flat');
b.CData(2,:) = [1 0 0];
ylabel('\sigma_{Path Length}')

sgtitle('\mu & \sigma Statistics');

%%
figure();
plot5best(Circle8,1,1);
plot5best(Circle20,2,1);
plot5best(Circle46,3,1);
plot5best(Circle72,4,1);
plot5best(Square22,5,1);
plot5best(Square35,6,1);
plot5best(Quatrefoil,7,1);
sgtitle('5 Highest Rewards');

figure();
plot5best(Circle8,1,0);
plot5best(Circle20,2,0);
plot5best(Circle46,3,0);
plot5best(Circle72,4,0);
plot5best(Square22,5,0);
plot5best(Square35,6,0);
plot5best(Quatrefoil,7,0);
sgtitle('5 Lowest Rewards');

function plot5best(shaperesults,column,descend)
    if descend
        [~, best] = sort(shaperesults.Rewards,'descend');
    else
        [~, best] = sort(shaperesults.Rewards,'ascend');
    end
    best = best(1:5);
    subplot(5,7,column); title(shaperesults.Title); hold on
    for i = 1:5
        subplot(5,7,(i-1)*7+column);
        shaperesults.plotPath(best(i))
    end
end