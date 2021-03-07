classdef RepeatingResults < handle
    properties
        n
        m
        Actions
        States
        Rewards
        Predictions
        Paths
    end
    methods
        function obj = RepeatingResults(Actions,States,Rewards,Predictions, pathfolder)
            %Constructor
            obj.Paths = TrackedPath.empty;
            assert(isequal(size(Actions,1), size(States,1), size(Rewards,1), size(Predictions,1)));
            obj.n = size(Actions,1);
            obj.m = size(Rewards,2);
            obj.Actions = Actions;
            obj.States = States;
            obj.Rewards = Rewards;
            obj.Predictions = Predictions;
            
            current = pwd;
            cd(pathfolder);
            contents = dir;
            cd(current);
            for i = 3:size(contents,1)
                trackedpath = TrackedPath(strcat(pathfolder,'\',contents(i).name));
                obj.Paths(floor((i-3)/obj.m)+1,mod((i-3),obj.m)+1) = trackedpath;
            end
            
        end
        
        function plotRewards(obj)
            plot(obj.Predictions, 'Color','r');
            hold on
            for i = 1:obj.m
                plot(obj.Rewards(:,i), 'Color', 'k');
            end
            xlabel('Attempt')
            ylabel('Reward')
            legend({'Predicted';'Actual'});
            ylim([-2 3]);
        end
        
        function plotPath(obj, num1, num2)
            obj.Paths(num1,num2).plotPath;
            [x, y] = pol2cart(pi/2*(obj.States(num1,(num2)*3)+1) + pi/4, 165);
            viscircles([x y], 5, 'Color', 'b')
            [x, y] = pol2cart(pi/2*(obj.States(num1,(num2-1)*3+2)+1) + pi/4, 65*(obj.States(num1,(num2-1)*3+1)+1) + 40);
            viscircles([x y], 5, 'Color', 'k')
            title(strcat("Test ", string(num1), " Repetition ", string(num2)));
        end
        
        function allPaths(obj)
            for i = 1:obj.n
                for j = 1:obj.m
                    obj.plotPath(i,j);
                    pause()
                end
            end
        end
        
        function plotRepetitions(obj, num)
            for i = 1:10
                subplot(2,5,i);
                obj.plotPath(num,i);
            end
        end
       
        
        function removeEntry(obj,inds)
            for i = 1:length(inds)
                obj.Actions(inds(i),:) = [];
                obj.States(inds(i),:) = [];
                obj.Rewards(inds(i),:) = [];
                obj.Predictions(inds(i),:) = [];
                obj.Paths(inds(i),:) = [];
                obj.n = obj.n - 1;
                if i < length(inds)
                    for j = i+1:length(inds)
                        inds(j) = inds(j) - 1;
                    end
                end
            end
        end
    end
end

