%initialise variables for optimization
v1 = optimizableVariable('xamp',[-1 1],'Type', 'real');
v2 = optimizableVariable('xfreq',[-1 1],'Type', 'real');
v3 = optimizableVariable('xphase',[-1 1],'Type', 'real');
v4 = optimizableVariable('yamp',[-1 1],'Type', 'real');
v5 = optimizableVariable('yfreq',[-1 1],'Type', 'real');
v6 = optimizableVariable('yphase',[-1 1],'Type', 'real');
v7 = optimizableVariable('zamp',[-1 1],'Type', 'real');
v8 = optimizableVariable('zfreq',[-1 1],'Type', 'real');
v9 = optimizableVariable('depth',[-1 1],'Type', 'real');
v10 = optimizableVariable('anglex',[-1 1],'Type', 'real');
v11 = optimizableVariable('angley',[-1 1],'Type', 'real');

savename = 'Motions\Bayesian\i180Opt100.mat';

%run optimization
ResetPosition(90,pi/4,cam,cameraParams,worldcentre,imagecentre)

bayesianhandle = @(x)i180CostFunction(x, cam,cameraParams, worldcentre, imagecentre);

results = bayesopt(bayesianhandle,...
    [v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11],...
    'Verbose',1,...
    'MaxObjectiveEvaluations',200,...
    'MaxTime',10*3600,...
	'OutputFcn',@saveToFile,...
    'SaveFileName',savename);

% BayesianOptimization object is returned
% default acquisition function is 'expected-improvement-per-second-plus'
