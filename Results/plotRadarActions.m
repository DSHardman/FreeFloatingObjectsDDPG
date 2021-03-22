figure();
subplot(2,3,1);
spider_plot(table2array(bayes0.XAtMinObjective), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Bayesian Task ii');
text(-0.25,0,'DRAFT');
subplot(2,3,2);
spider_plot(table2array(bayes90.XAtMinObjective), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Bayesian Task iv');
text(-0.25,0,'DRAFT');
subplot(2,3,3);
spider_plot(table2array(bayes180.XAtMinObjective), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Bayesian Task v');

subplot(2,3,4);
spider_plot(Circle20.Actions(2,:), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Trained Task ii');
subplot(2,3,5);
spider_plot(Circle20.Actions(4,:), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Trained Task iv');
subplot(2,3,6);
spider_plot(Circle20.Actions(5,:), 'FillOption', 'on', 'AxesLabels', 'none', 'AxesDisplay', 'none');
title('Trained Task v');

sgtitle('Proposed Actions');