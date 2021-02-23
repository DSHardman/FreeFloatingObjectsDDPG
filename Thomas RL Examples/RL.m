

ObservationInfo = rlNumericSpec([3 1]); % Number of states
ObservationInfo.Name = 'Robot States';
ObservationInfo.Description = 'velx, posy, dens';


ActionInfo = rlNumericSpec([2 1],'LowerLimit',[pi/10 0 ]','UpperLimit',[pi/1.2 2 ]');% Number of actions and range
%ActionInfo = rlNumericSpec([2 1],'LowerLimit',[pi/3 0 ]','UpperLimit',[pi/1.5 2 ]');
ActionInfo.Name = ' Action';

%type myResetFunction.m %% reset function resets the environment to a new
%state
%type myStepFunction.m %%step function takes in state and action and gives
%out reward, next state and if the episode is finished

env = rlFunctionEnv(ObservationInfo,ActionInfo,'myStepFunction','myResetFunction');


%TO TEST ENVIRONMENT 
env.step([1 1])
%%%%%


obsInfo = getObservationInfo(env);
numObservations = obsInfo.Dimension(1);
numObs=obsInfo.Dimension(1);
actInfo = getActionInfo(env);
numActions = actInfo.Dimension(1);
numAct=actInfo.Dimension(1);


statePath = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(50,'Name','CriticStateFC1')
    reluLayer('Name', 'CriticRelu1')
    fullyConnectedLayer(50,'Name','CriticStateFC2')];
actionPath = [
    imageInputLayer([numAct 1 1],'Normalization','none','Name','action')
    fullyConnectedLayer(50,'Name','CriticActionFC1','BiasLearnRateFactor',0)];
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
criticOpts = rlRepresentationOptions('LearnRate',1e-03*10,'GradientThreshold',10);
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
critic = rlQValueRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'action'},criticOpts);


actorNetwork = [
    imageInputLayer([numObs 1 1],'Normalization','none','Name','observation')
    fullyConnectedLayer(50,'Name','ActorFC1')
    reluLayer('Name','ActorRelu1')
    fullyConnectedLayer(50,'Name','ActorFC2')
    reluLayer('Name','ActorRelu2')
    fullyConnectedLayer(numAct,'Name','ActorFC3')
    tanhLayer('Name','ActorTanh')
    scalingLayer('Name','ActorScaling','Scale',max(actInfo.UpperLimit))];

actorOpts = rlRepresentationOptions('LearnRate',1e-04*10,'GradientThreshold',10);

actor = rlDeterministicActorRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'observation'},'Action',{'ActorScaling'},actorOpts);

agentOpts = rlDDPGAgentOptions(...
    'SampleTime',1,...
    'TargetSmoothFactor',1e-3,...
    'ExperienceBufferLength',1e6,...
    'DiscountFactor',0.6,...
    'NumStepsToLookAhead',1,...
    'ResetExperienceBufferBeforeTraining',0,...
    'SaveExperienceBufferWithAgent',1,...
    'MiniBatchSize',32);
agentOpts.NoiseOptions.Variance = 0.6*1;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5*100;

agent = rlDDPGAgent(actor,critic,agentOpts);

maxepisodes = 3000;

maxsteps =1;%Number of times new action is selected
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes,...
    'MaxStepsPerEpisode',maxsteps,...
    'ScoreAveragingWindowLength',1,...
    'Verbose',false,...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',4440,...
    'SaveAgentCriteria','EpisodeReward',...
    'UseParallel',true,...
    'SaveAgentValue',440);


agent.AgentOptions.NoiseOptions.Variance = 0.6*0.001;
agent.AgentOptions.NoiseOptions.VarianceDecayRate = 1e-5*100;

trainingStats = train(agent,env,trainOpts);

simOptions = rlSimulationOptions('MaxSteps',1);

experience = sim(env,agent,simOptions);

