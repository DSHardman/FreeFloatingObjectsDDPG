%initialise variables for optimization
v1 = optimizableVariable('xamp',[0 5],'Type', 'real');
v2 = optimizableVariable('xfreq',[0 6],'Type', 'real');
v3 = optimizableVariable('xphase',[0 360],'Type', 'real');
v4 = optimizableVariable('yamp',[0 5],'Type', 'real');
v5 = optimizableVariable('yfreq',[0 6],'Type', 'real');
v6 = optimizableVariable('yphase',[0 360],'Type', 'real');
v7 = optimizableVariable('zamp',[0 5],'Type', 'real');
v8 = optimizableVariable('zfreq',[0 6],'Type', 'real');
v9 = optimizableVariable('depth',[5 50],'Type', 'real');
v10 = optimizableVariable('anglex',[-20 20],'Type', 'real');
v11 = optimizableVariable('angley',[-20 20],'Type', 'real');

savename = 'Motions\Bayesian\RadialInOpt100.mat';

%run optimization
ResetPosition()
results = bayesopt(@rinCostFunction,...
    [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11],...
    'Verbose',1,...
    'MaxObjectiveEvaluations',200,...
    'MaxTime',5*3600,...
	'OutputFcn',@saveToFile,...
    'SaveFileName',savename);

% BayesianOptimization object is returned
% default acquisition function is 'expected-improvement-per-second-plus'
