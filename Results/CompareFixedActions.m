% Compares and plots statistics between proposed, fixed, and random actions.
% Only used for agent 2481 Testing

rm = zeros(3,1);
rs = zeros(3,1);
pm = zeros(3,1);
ps = zeros(3,1);
em = zeros(3,1);
es = zeros(3,1);
lm = zeros(3,1);
ls = zeros(3,1);

shapes = [Circle20; FixedAction; RandomAction];

for i = 1:3
    [rm(i), rs(i), pm(i), ps(i), em(i), es(i), lm(i), ls(i)] = shapes(i).stats();
end


X = categorical({'Trained Agent','Inspired Action', 'Random Action'});
X = reordercats(X,{'Trained Agent','Inspired Action', 'Random Action'});

figure();

subplot(2,4,1);
b = bar(X,rm, 'FaceColor', 'flat');
ylabel('\mu_{Reward}')
title('Rewards');

subplot(2,4,2);
b = bar(X,pm, 'FaceColor', 'flat');
ylabel('\mu_{Prediction}')
title('Predictions')

subplot(2,4,3);
b = bar(X,em, 'FaceColor', 'flat');
ylabel('\mu_{Error}')
title('Prediction - Reward')

subplot(2,4,4);
b = bar(X,lm, 'FaceColor', 'flat');
ylabel('\mu_{Path Length}')
title('Path Length');

subplot(2,4,5);
b = bar(X,rs, 'FaceColor', 'flat');
ylabel('\sigma_{Reward}')

subplot(2,4,6);
b = bar(X,ps, 'FaceColor', 'flat');
ylabel('\sigma_{Prediction}')

subplot(2,4,7);
b = bar(X,es, 'FaceColor', 'flat');
ylabel('\sigma_{Error}')

subplot(2,4,8);
b = bar(X,ls, 'FaceColor', 'flat');
ylabel('\sigma_{Path Length}')

sgtitle('\mu & \sigma Statistics');