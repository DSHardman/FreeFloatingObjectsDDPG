% after running long preliminary tests, this converted x y to polar
% coordinates in 31-151s period

j = 20;

filename = strcat('Motions/Noise/Tracking', string(j), '.mat');
load(filename);

results2 = [];

for i = 1:size(results,1)
    if ((results(i,1) > 31.5) && (results(i,1) < 151.5))
        [x, y] = pol2cart(results(i,3),results(i,2));
        results2 = [results2; results(i,1)-31.5 x y];
    end
end

results = results2;
save(strcat('Motions/Noise/Tracked',string(j),'.mat'),'results');