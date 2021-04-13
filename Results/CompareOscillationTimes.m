% Predict periodicity of flows from the proposed actions

act = cell2mat(saved_agent.getAction([(-11/13); 0.4; -0.4])); % Task i
%act = cell2mat(saved_agent.getAction([(-9/13); 0; 0])); % Task ii
%act = cell2mat(saved_agent.getAction([(-5/13); 0.5; 0.8])); % Task iii
%act = cell2mat(saved_agent.getAction([(-3/13); -1; 0])); % Task iv
%act = cell2mat(saved_agent.getAction([(-3/13); -1; 1])); % Task v

fx = 2.5*(act(2)+1);
fy = 2.5*(act(5)+1);
fz = 2.5*(act(8)+1);

% assume motion is dominated by x and y vibrations
% expected time period is then
double(1/(abs(fx-fy)))

% visualise this (no amplitude dependence)
%plot(1:0.01:1000,sin(2*pi*fx*[1:0.01:1000])+sin(2*pi*fy*[1:0.01:1000])+...
%    sin(2*pi*fz*[1:0.01:1000]))