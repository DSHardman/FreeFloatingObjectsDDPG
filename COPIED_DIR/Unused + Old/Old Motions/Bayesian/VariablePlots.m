load('RadialInOpt100.mat');
inres = BayesoptResults;
[sortedscorein, ind] = sort(inres.ObjectiveTrace,'ascend');
sortedxin = inres.XTrace(ind,:);

load('RadialOutOpt100.mat');
outres = BayesoptResults;
[sortedscoreout, ind] = sort(outres.ObjectiveTrace,'ascend');
sortedxout = outres.XTrace(ind,:);
clear ind

numbest = 10;
titles = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp" "zfreq"...
    "depth" "anglex" "angley"];
for i = 1:11
   subplot(4,3,i);
   scatter(table2array(sortedxin(1:numbest,i)), 2*ones(numbest,1), 10, 'r');
   hold on
   scatter(table2array(sortedxout(1:numbest,i)), ones(numbest,1), 10, 'b');
   scatter(table2array(sortedxin(1:100,i)), zeros(100,1), 10, 'r');
   scatter(table2array(sortedxout(1:100,i)), -1*ones(100,1), 10, 'b');
   title(titles(i));
end