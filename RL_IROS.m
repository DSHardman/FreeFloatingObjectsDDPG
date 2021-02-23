numObs = 3;
numAct = 11;

maxepisodes = 3000;
maxsteps = 1;

ObservationInfo = rlNumericSpec([numObs 1]); % Number of states
ObservationInfo.Name = 'Starting State';
ObservationInfo.Description = 'disc_r, disc_theta, desired_theta';

ur5variables = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
    "zfreq" "depth" "anglex" "angley"];
%lowerlimits = [0; 0; 0; 0; 0; 0; 0; 0; 5; -20; -20];
%upperlimits = [5; 6; 360; 5; 6; 360; 5; 6; 50; 20; 20];
lowerlimits = -1*ones(11,1);
upperlimits = 1*ones(11,1);

ActionInfo = rlNumericSpec([numAct 1],'LowerLimit',lowerlimits,'UpperLimit',upperlimits); % Number of actions and range
ActionInfo.Name = 'Action';
ActionInfo.Description = ur5variables;

%avoid issues with global variables by creating local copies
cam2 = cam;
cameraParams2 = cameraParams;
worldcentre2 = worldcentre;
imagecentre2 = imagecentre;

%use handles to pass additional arguments
resethandle = @()reset_IROS(cam2,cameraParams2, worldcentre2, imagecentre2);
stephandle = @(Action,LoggedSignals) ...
    step_IROS(Action,LoggedSignals,cam2,cameraParams2, worldcentre2, imagecentre2);

env = rlFunctionEnv(ObservationInfo,ActionInfo,stephandle,resethandle);

%TO TEST ENVIRONMENT 
%env.step([1 1])
%%%%%

%FC Layer numbers can be adjusted
statePath = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(50,'Name','CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(50,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(50,'Name','CriticActionFC1','BiasLearnRateFactor',0)]; %VARIABLE LR
commonPath = [
    additionLayer(2,'Name','add')
    reluLayer('Name','CriticCommonRelu')
    fullyConnectedLayer(1,'Name','CriticOutput')];

criticNetwork = layerGraph();
criticNetwork = addLayers(criticNetwork,statePath);
criticNetwork = addLayers(criticNetwork,actionPath);
criticNetwork = addLayers(criticNetwork,commonPath);
    
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1');
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
criticOpts = rlRepresentationOptions('LearnRate',1e-03*10,'GradientThreshold',10); %VARIABLE LR DEFAULT 0.1
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'action'},criticOpts);

%FC Layer numbers can be adjusted
actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(50,'Name','ActorFC1')
    reluLayer('Name','ActorRelu1')
    fullyConnectedLayer(50,'Name','ActorFC2')
    reluLayer('Name','ActorRelu2')
    fullyConnectedLayer(numAct,'Name','ActorFC3')
    tanhLayer('Name','ActorTanh')
    scalingLayer('Name','ActorScaling','Scale',max(actInfo.UpperLimit))];

actorOpts = rlRepresentationOptions('LearnRate',1e-04*10);%,'GradientThreshold',10); %VARIABLE LR must be smaller than critic
%actorOpts = rlRepresentationOptions();

actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'ActorScaling'},actorOpts);

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',1,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.99,...
    'NumStepsToLookAhead',1,...
    'ResetExperienceBufferBeforeTraining',0,...
    'SaveExperienceBufferWithAgent',1,...
    'MiniBatchSize',32); %VARIABLES %discount factor default 0.99 %was 0.6
%agentOpts.NoiseOptions.Variance = 0.6; %VARIABLE %default 0.3 %different for action
%agentOpts.NoiseOptions.VarianceDecayRate = 1e-5*100; %VARIABLE default 0 %different for each action

agent = rlDDPGAgent(actor,critic,agentOpts);

trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',1,...
    'Verbose',true,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',4440,...
    'SaveAgentCriteria','EpisodeReward',...
    'UseParallel',false,...
    'SaveAgentValue',-2); %VARIABLES

trainingStats = train(agent,env,trainOpts);

simOptions = rlSimulationOptions('MaxSteps',1);

experience = sim(env,agent,simOptions);

