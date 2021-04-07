% Class with properties and methods suitable for agent tests where the
% starting position has been misreported.
% Only used for Agent 2481 testing.

classdef MisreportingResults < handle
    properties
        n
        Actions
        States
        Rewards
        Predictions
        Paths
        Errors % r theta magnitude
    end
    methods
        function obj = MisreportingResults(Actions,States,Rewards,Predictions, pathfolder)
            %Constructor
            obj.Paths = TrackedPath.empty;
            assert(isequal(size(Actions,1), size(States,1), size(Rewards,1), size(Predictions,1)));
            obj.n = size(Actions,1);
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
                obj.Paths(i-2,1) = trackedpath;
            end
            
            obj.Errors = zeros(obj.n, 3);
            for i = 1:obj.n
                r_actual = obj.Paths(i).radiusvec(1);
                theta_actual = obj.Paths(i).thetavec(1);
                r_reported = 65*(obj.States(i,1)+1) + 40;
                theta_reported =  pi/2*(obj.States(i,2)+1) + pi/4;
                obj.Errors(i,1) = r_reported - r_actual;
                obj.Errors(i,2) = theta_reported - theta_actual;
                [x_rep, y_rep] = pol2cart(theta_reported, r_reported);
                obj.Errors(i,3) = norm([x_rep-obj.Paths(i).xvec(1);...
                    y_rep-obj.Paths(i).yvec(1)]);
            end
            
        end
        
        function plotRewards(obj)
            plot(obj.Predictions, 'Color','r');
            hold on
            plot(obj.Rewards, 'Color', 'k');
            xlabel('Attempt')
            ylabel('Reward')
            legend({'Predicted';'Actual'});
            ylim([-2 3]);
        end
        
        function plotThetaRewards(obj)
            figure();
            subplot(1,3,1);
            scatter((pi/2)*abs(obj.States(:,3)-obj.States(:,2)),obj.Predictions, 'rx');
            title('Predicted');
            xlabel('|\theta_{start} - \theta_{target}|')
            ylabel('Reward');
            ylim([-2 3]);
            subplot(1,3,2);
            scatter((pi/2)*abs(obj.States(:,3)-obj.States(:,2)),obj.Rewards, 'kx');
            title('Actual');
            xlabel('|\theta_{start} - \theta_{target}|')
            ylabel('Reward');
            ylim([-2 3]);
            subplot(1,3,3);
            line([0 max((pi/2)*abs(obj.States(:,3)-obj.States(:,2)))],[0 0], 'Color', 'k'); hold on
            scatter((pi/2)*abs(obj.States(:,3)-obj.States(:,2)),obj.Predictions-obj.Rewards, 'kx');
            title('Error');
            xlabel('|\theta_{start} - \theta_{target}|')
            ylabel('Predicted Reward - Actual Reward');
        end
        
        function plotErrorDist(obj)
            histogram(obj.Predictions - obj.Rewards);
            xlabel('Predicted Reward - Actual Reward')
            ylabel('Quantity')
        end
        
        function plotActionSpace(obj)
            ur5variables = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
                "zfreq" "depth" "anglex" "angley"];
            figure();
            for i = 1:11
                subplot(3,4,i)
                plot(obj.Actions(:,i));
                ylim([-1 1])
                title(ur5variables(i));
            end
        end
        
        function plotStateSpace(obj)
            statevariables = ["r_{start}" "\theta_{start}" "\theta_{target}"];
            figure();
            for i = 1:3
                subplot(1,3,i)
                plot(obj.States(:,i));
                ylim([-1 1])
                title(statevariables(i));
            end
        end
        
        function pathLengths(obj)
            lengths = zeros(obj.n,1);
            for i = 1:obj.n
                lengths(i) = obj.Paths(i).getLength();
            end
            histogram(lengths)
            xlabel('Path Length');
            ylabel('Quantity');
        end
        
        function plotMisreporting(obj)
            figure();
            subplot(2,3,1);
            scatter(obj.Errors(:,3),obj.Rewards,'kx');
            xlabel('Misreported Magnitude');
            ylabel('Reward');
            subplot(2,3,2);
            scatter(obj.Errors(:,1),obj.Rewards,'kx');
            xlabel('Misreported Radius');
            ylabel('Reward');
            subplot(2,3,3);
            scatter(obj.Errors(:,2),obj.Rewards,'kx');
            xlabel('Misreported Angle');
            ylabel('Reward');
            
            subplot(2,3,4);
            scatter(obj.Errors(:,3),obj.Predictions - obj.Rewards,'kx');
            xlabel('Misreported Magnitude');
            ylabel('Prediction - Reward');
            subplot(2,3,5);
            scatter(obj.Errors(:,1),obj.Predictions - obj.Rewards,'kx');
            xlabel('Misreported Radius');
            ylabel('Prediction - Reward');
            subplot(2,3,6);
            scatter(obj.Errors(:,2),obj.Predictions - obj.Rewards,'kx');
            xlabel('Misreported Angle');
            ylabel('Prediction - Reward');
        end
        
        function plotPath(obj, num)
            obj.Paths(num).plotPath;
            [x, y] = pol2cart(pi/2*(obj.States(num,3)+1) + pi/4, 165);
            viscircles([x y], 5, 'Color', 'b')
            [x, y] = pol2cart(pi/2*(obj.States(num,2)+1) + pi/4, 65*(obj.States(num,1)+1) + 40);
            viscircles([x y], 5, 'Color', 'k')
            title(strcat("Test ", string(num)));
        end
        
        function allPaths(obj)
            for i = 1:obj.n
                obj.plotPath(i);
                pause()
            end
        end
        
        function [rew_mu, rew_sigma, pred_mu, pred_sigma,...
                err_mu, err_sigma, len_mu, len_sigma] = stats(obj)
            rew_mu = mean(obj.Rewards);
            rew_sigma = std(obj.Rewards);
            pred_mu = mean(obj.Predictions);
            pred_sigma = std(obj.Predictions);
            err_mu = mean(obj.Predictions - obj.Rewards);
            err_sigma = std(obj.Predictions - obj.Rewards);
            lengths = zeros(obj.n,1);
            for i = 1:obj.n
                lengths(i) = obj.Paths(i).getLength();
            end
            len_mu = mean(lengths);
            len_sigma = std(lengths);
            
        end
        
        function removeEntry(obj,inds)
            for i = 1:length(inds)
                obj.Actions(inds(i),:) = [];
                obj.States(inds(i),:) = [];
                obj.Rewards(inds(i),:) = [];
                obj.Predictions(inds(i),:) = [];
                obj.Paths(inds(i),:) = [];
                obj.Errors(inds(i),:) = [];
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

