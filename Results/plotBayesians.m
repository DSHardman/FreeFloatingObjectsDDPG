subplot(2,3,1);
plot(bayes0.ObjectiveMinimumTrace)
xlim([0 700]); ylim([0 200]);
text(400,100,'DRAFT');
title('0^o: Task ii');

subplot(2,3,2);
plot(bayes90.ObjectiveMinimumTrace)
xlim([0 700]); ylim([0 200]);
text(400,100,'DRAFT');
title('90^o: Task iv');

subplot(2,3,3);
plot(bayes180.ObjectiveMinimumTrace)
xlim([0 700]); ylim([0 200]);
text(400,100,'DRAFT');
title('180^o: Task v');


subplot(2,3,4);
text(0.4,0.5,'DRAFT');
%stringbase = 'C:\Users\dshar\Downloads\atest';
%VisualiseBayesian

subplot(2,3,5);
stringbase = 'C:\Users\dshar\Downloads\atest';
VisualiseBayesian
text(-0.2,0,'DRAFT');

subplot(2,3,6);
stringbase = 'C:\Users\dshar\Downloads\Bayes180_3_test';
VisualiseBayesian
text(-0.2,0,'DRAFT');

sgtitle('Bayesian Optimisations');