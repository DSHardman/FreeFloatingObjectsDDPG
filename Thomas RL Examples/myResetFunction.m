function [InitialObservation, LoggedSignal] = myResetFunction()
% Reset function to place custom cart-pole environment into a random
% initial state.
%velx=randn*3;
%posy=1+abs(randn*3);
%rng(3)

%State(1,1)=randn*3;
%State(2,1)=1.001+abs(randn*3);

State(1,1)=-1;
State(2,1)=2;

State(3,1)=0;%+abs(randn/10);
%State(3,1)=1;%-abs(randn/10);
%State(3,1)=2-randi(2);

%State(1,1)=randn*3;
%State(2,1)=1+abs(randn*3);
%State(3,1)=1;
LoggedSignal.State = State;
InitialObservation = LoggedSignal.State;






end