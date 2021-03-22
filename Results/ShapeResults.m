classdef ShapeResults < handle
    properties
        Title
        n
        Actions
        States
        Rewards
        Predictions
        Paths
    end
    methods
        function obj = ShapeResults(Title,Actions,States,Rewards,Predictions, pathfolder)
            %Constructor
            obj.Paths = TrackedPath.empty;
            assert(isequal(size(Actions,1), size(States,1), size(Rewards,1), size(Predictions,1)));
            obj.n = size(Actions,1);
            obj.Actions = Actions;
            obj.States = States;
            obj.Rewards = Rewards;
            obj.Predictions = Predictions;
            obj.Title = Title;
            
            current = pwd;
            cd(pathfolder);
            contents = dir;
            cd(current);
            for i = 3:size(contents,1)
                trackedpath = TrackedPath(strcat(pathfolder,'\',contents(i).name));
                obj.Paths(i-2,1) = trackedpath;
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
            title(obj.Title);
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
            sgtitle(obj.Title)
        end
        
        function plotErrorDist(obj)
            histogram(obj.Predictions - obj.Rewards);
            xlabel('Predicted Reward - Actual Reward')
            ylabel('Quantity')
        end
        
        function plotActionSpace(obj)
            ur5variables = ["xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
                "zfreq" "depth" "anglex" "angley" "decay"];
            figure();
            for i = 1:12
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
        
        function plotHeatMaps(obj)
            rbins = 6;
            thetabins = 5;
            rewarddata = NaN(thetabins,thetabins,rbins);
            predictiondata = NaN(thetabins,thetabins,rbins);
            errordata = NaN(thetabins,thetabins,rbins);
            for i = 1:obj.n
                rplot = max(1,ceil(((min(obj.States(i,1),1)+1)/2)*rbins));
                ts = max(1,ceil(((min(obj.States(i,2),1)+1)/2)*thetabins));
                tf = max(1,ceil(((min(obj.States(i,3),1)+1)/2)*thetabins));
                if isnan(rewarddata(ts,tf,rplot))
                    rewarddata(ts,tf,rplot) = obj.Rewards(i);
                    predictiondata(ts,tf,rplot) = obj.Predictions(i);
                    errordata(ts,tf,rplot) = obj.Predictions(i) - obj.Rewards(i);
                else
                    rewarddata(ts,tf,rplot) = mean([obj.Rewards(i) rewarddata(ts,tf,rplot)]);
                    predictiondata(ts,tf,rplot) = mean([obj.Predictions(i) predictiondata(ts,tf,rplot)]);
                    errordata(ts,tf,rplot) = mean([(obj.Predictions(i)-obj.Rewards(i)) errordata(ts,tf,rplot)]);
                end
            end
            
            figure();
            for i = 1:5
                subplot(2,3,i);
                heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins), 1-(1/thetabins):-(2/thetabins):-1+(1/thetabins), flipud(rewarddata(:,:,i)));
                xlabel('\theta_{start}');
                ylabel('\theta_{target}');
                title(strcat("r = ", string((2*i/rbins)-(7/6))))
                colormap parula
                caxis([-1.25, 2.25]);
            end
            sgtitle('Rewards')
            figure();
            for i = 1:5
                subplot(2,3,i);
                heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins), 1-(1/thetabins):-(2/thetabins):-1+(1/thetabins), flipud(predictiondata(:,:,i)));
                xlabel('\theta_{start}');
                ylabel('\theta_{target}');
                title(strcat("r = ", string((2*i/rbins)-(7/6))))
                colormap parula
                caxis([-1.25, 2.25]);
            end
            sgtitle('Predictions')
            figure();
            for i = 1:5
                subplot(2,3,i);
                heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins), 1-(1/thetabins):-(2/thetabins):-1+(1/thetabins), flipud(errordata(:,:,i)));
                xlabel('\theta_{start}');
                ylabel('\theta_{target}');
                title(strcat("r = ", string((2*i/rbins)-(7/6))))
                colormap parula
                caxis([-1.25, 2.25]);
            end
            sgtitle('Errors')
        end
        
        function compareHeatMaps(obj, agent, save, savename)
        % NOTE THAT THIS FUNCTION SHIFTS THE RADIUS VALUES.    
            limits = [-1.25 2.25];
            
            %Predictions
            rbins = 4;
            thetabins = 15;
            predictiondata = NaN(thetabins,thetabins,rbins,1);
            mcritic = agent.getCritic();
            for rplot = 1:rbins
                for tf = 1:thetabins
                    for ts = 1:thetabins
                        state = [(12/13)*((rplot-1)/(rbins-1))-1;...
                            (2*(ts-1)/(thetabins-1))-1;...
                            (2*(tf-1)/(thetabins-1))-1];
                        action = cell2mat(getAction(agent,state));
                        predictiondata(ts,tf,rplot,1) = mcritic.getValue(state, action);
                    end
                end
            end
            figure('Position', [200 200 1300 600]);
            for i = 1:rbins
                subplot(2,rbins,i);
                heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins),...
                    1-(1/thetabins):-(2/thetabins):-1+(1/thetabins),...
                    flipud(predictiondata(:,:,i,1)),...
                    'ColorbarVisible','off', 'GridVisible','off',...
                    'CellLabelColor','none');
                %xlabel('\theta_{start}');
                %ylabel('\theta_{target}');
                title(strcat(string(2*(i-1)/rbins - 1), " < r < ", string(2*i/rbins - 1)))
                colormap parula
                caxis(limits);
                Ax = gca;
                Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
                Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
            end
            subplot(2,rbins, 1); ylabel('Predicted');
            
            %Actual
            thetabins = 6;
            rewarddata = NaN(thetabins,thetabins,rbins);
            number_so_far = zeros(thetabins,thetabins,rbins);
            for i = 1:obj.n
                rplot = max(1,ceil(((min((13/6)*(obj.States(i,1)+1)-1,1)+1)/2)*rbins));
                ts = max(1,ceil(((min(obj.States(i,2),1)+1)/2)*thetabins));
                tf = max(1,ceil(((min(obj.States(i,3),1)+1)/2)*thetabins));
                if isnan(rewarddata(ts,tf,rplot))
                    rewarddata(ts,tf,rplot) = obj.Rewards(i);
                    number_so_far(ts,tf,rplot) = 1;
                else
                    rewarddata(ts,tf,rplot) = obj.Rewards(i) + rewarddata(ts,tf,rplot);
                    number_so_far(ts,tf,rplot) = number_so_far(ts,tf,rplot) + 1;
                end
            end
            rewarddata = rewarddata./number_so_far;
            
            for i = 1:rbins
                subplot(2,rbins,i+rbins);
                heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins),...
                    1-(1/thetabins):-(2/thetabins):-1+(1/thetabins),...
                    flipud(rewarddata(:,:,i)), 'ColorbarVisible','off',...
                    'GridVisible','off', 'CellLabelColor','none');
                colormap parula
                caxis(limits);
                Ax = gca;
                Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
                Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
            end
            subplot(2,rbins, rbins+1); ylabel('Measured');
            
            %ylabel('\theta_{target}');
            %xlabel('\theta_{start}');
            
            if nargin == 4
                if save
                    exportgraphics(gcf, "AutosavedFigures/"+...
                        savename+".eps", 'ContentType',...
                        'vector', 'BackgroundColor', 'none');
                end
            end
            
        end
       
        function pathLengths(obj)
            lengths = zeros(obj.n,1);
            for i = 1:obj.n
                lengths(i) = obj.Paths(i).getLength();
            end
            histogram(lengths)
            title(obj.Title);
            xlabel('Path Length')
            ylabel('Quantity');
        end
        
        function plotPath(obj, num)
            obj.Paths(num).plotPath;
            [x, y] = pol2cart(pi/2*(obj.States(num,3)+1) + pi/4, 165);
            viscircles([x y], 5, 'Color', 'b')
            [x, y] = pol2cart(pi/2*(obj.States(num,2)+1) + pi/4, 65*(obj.States(num,1)+1) + 40);
            viscircles([x y], 5, 'Color', 'k')
            title(strcat(obj.Title, ", Test ", string(num)));
        end
        
        function allPaths(obj)
            for i = 858:obj.n
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

