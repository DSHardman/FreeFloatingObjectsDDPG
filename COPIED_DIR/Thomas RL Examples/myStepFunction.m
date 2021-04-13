function [NextObs,Reward,IsDone,LoggedSignals] = myStepFunction(Action,LoggedSignals)
State = LoggedSignals.State;

% 
% global vel
% global err
% global  ydim_all yevdim_all xtdim_all init
% 
% State(1)=State(1)+vel;



asd=3;

[a,ydim,junk,tedim,xtdim,yevdim]=evalu(Action,State(1),State(2),State(3),asd);

[a,b]=findpeaks(ydim(1:end,3));



% 
% if init >0
%          
%         ydim(:,1)=ydim(:,1)+ydim_all(end,1);
%         yevdim(:,1)=yevdim(:,1)+ydim_all(end,1);
%         xtdim(:,1)=xtdim(:,1)+ydim_all(end,1);     
% end
% 
% ydim_all=[ydim_all ; ydim(1:b(1),:)];
% yevdim_all=[yevdim_all ; yevdim(1:2,:)];
% xtdim_all=[xtdim_all ; xtdim(1,:)];
% init=1;
% 
% vel=err+0.01*(1-ydim(b(1),2));
% err=vel;
% ydim(b(1),2)=ydim(b(1),2)-vel;
% % 




if length(b)>0
    State(1)=ydim(b(1),2);
    State(2)=ydim(b(1),3);
    LoggedSignals.State = State ;
    NextObs = LoggedSignals.State;
    rew=abs(ydim(b(1),2));
    IsDone=0;
    %Reward=log10(1+1/rew);
    
    rew= abs(ydim(b(1),2)-1);
    Reward=log10(1+1/rew);
    %Reward=1/(rew*10);
    
    if ydim(b(1),3)<1
        IsDone=1;
    end
    
    %Reward=ydim(b(1),2);
else
    
    State(1)=0;
    State(2)=0;
    LoggedSignals.State = State ;
    NextObs = LoggedSignals.State;
    IsDone=1;
    
    Reward=0;
    
end





end