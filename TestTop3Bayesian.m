% Given a set of bayesian results, run the best 3 solutions 10 times each
% Assumes that i180CostFunction is saving the results when run

[~,ind] = sort(BayesoptResults.ObjectiveTrace,'ascend');

ResetPosition(90,pi/4,cam,cameraParams,worldcentre,imagecentre);
x = BayesoptResults.XTrace(ind(1),:);
for i = 1:10
    fprintf('Test 1 repetition %d \n', i);
    fname = 'Bayes180_1_test' + string(i);
    i180CostFunction(x, fname);
end
x = BayesoptResults.XTrace(ind(2),:);
for i = 1:10
    fprintf('Test 2 repetition %d \n', i);
    fname = 'Bayes180_2_test' + string(i);
    i180CostFunction(x, fname);
end
x = BayesoptResults.XTrace(ind(3),:);
for i = 1:10
    fprintf('Test 3 repetition %d \n', i);
    fname = 'Bayes180_3_test' + string(i);
    i180CostFunction(x, fname);
end