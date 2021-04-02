act = cell2mat(saved_agent.getAction([-(-3/13); -1; 1]));
fx = 2.5*(act(2)+1);
fy = 2.5*(act(5)+1);
fz = 2.5*(act(8)+1);

xy = 1/(0.5*(abs(fx-fy)))
yz = 1/(0.5*(abs(fz-fy)))
xz = 1/(0.5*(abs(fx-fz)))