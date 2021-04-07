%%% From Thomas, 10/12/20

for i=1:20
   %asd =resample(squeeze([data(:,2:end-1,i) data(:,4:end,i)]),squeeze(tim2(2:end,i)),25,'pchip');%CTPE. Broken 3rd column removed
    currentFile = sprintf('RandomMotions%d.mat',i);
   load(currentFile)
    currentFile = sprintf('Tracked%d.mat',i);
   load(currentFile)
   asd =resample(motions(:,2:end),motions(:,1),10,'pchip');


   asd2=resample(results(:,2:3),results(:,1),10,'pchip');%ground truth
   asd(:,6) =asd2(1,1);
   asd(:,7) =asd2(1,2);
     asd(1:50,6:7)=asd2(1:50,:);
    inp{i}=asd(10:1000,:)';
    out{i}=asd2(10:1000,:)';
end

tr=[1:10,12:20];


x=inp(tr)';

y=(out(tr))';


XTest=inp';
YTest=out';
%YTest=cell2mat(vel')';

 mu = mean([x{:}],2);
 sig = std([x{:}],0,2);
 
  mu2 = mean([y{:}],2);
 sig2 = std([y{:}],0,2);

for i = 1:numel(x)
     x{i} = (x{i} - mu) ./ sig;
  %  x{i} = (x{i}) ./ sig;
    XTest{i} = (XTest{i}-mu) ./ sig;
end
for i = 1:numel(y)
     y{i} = (y{i} - mu2) ./ sig2;
  %  x{i} = (x{i}) ./ sig;
    YTest{i} = (YTest{i}-mu2) ./ sig2;
end

numResponses = size(y{1},1);
%numResponses = size(y,1);
featureDimension = size(x{1},1);
numHiddenUnits =30;

layers = [ ...
    sequenceInputLayer(featureDimension)
    % lstmLayer(numHiddenUnits,'OutputMode','sequence')
    dropoutLayer(0.05)
     lstmLayer(numHiddenUnits,'OutputMode','sequence')
   %dropoutLayer(0.05)
   % lstmLayer(numHiddenUnits)
    fullyConnectedLayer(numResponses)
    % tanhLayer
    regressionLayer];

maxEpochs = 6000;
miniBatchSize =20;

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.005*1, ...
    'ValidationData',{XTest(11),YTest(11)}, ...%
    'LearnRateDropFactor',0.1, ...
    'LearnRateDropPeriod',100, ...
    'GradientThreshold',0.01*1000, ...
    'Shuffle','every-epoch', ...
    'Plots','training-progress',...
    'L2Regularization',0.00001,...
     'ExecutionEnvironment', 'GPU',...
    'Verbose',1);
%
[net,info] = trainNetwork(x,y,layers,options);

%XTest=inp_all;
%YTest=out;



[net,YPred_o]= predictAndUpdateState(net,XTest,'MiniBatchSize',20);

YPred = predict(net,XTest,'MiniBatchSize',20);

asd=(YTest{11});

asd2=(YPred{11});


asd3=(YPred_o{11});

% plot(asd(1,:))
% hold on
% plot(asd2(1,:))

plot(YTest{11, 1}(2,:))
hold on
plot(YPred_o{11, 1}(2,:))

%
% for i=1:421
%     pos=pos_all{i, 1}(:,1:end);
%     if pos(1,500)==NaN
%         i
%     end
%    % scatter3(pos(1,:),pos(2,:),pos(3,:))
%     hold on
%
% end
