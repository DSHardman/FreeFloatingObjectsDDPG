function heatData(agent, agent2)
    rbins = 5;
    thetabins = 25;
    predictiondata = NaN(thetabins,thetabins,rbins,12);
    
    mcritic = agent.getCritic();
    if nargin == 2
        mcritic2 = agent2.getCritic();
    end
    
    heatvariables = ["Prediction" "xamp" "xfreq" "xphase" "yamp" "yfreq" "yphase" "zamp"...
    "zfreq" "depth" "anglex" "angley"];

    for rplot = 1:rbins
        for tf = 1:thetabins
            for ts = 1:thetabins
                state = [(2*(rplot-1)/(rbins-1))-1;...
                    (2*(ts-1)/(thetabins-1))-1;...
                    (2*(tf-1)/(thetabins-1))-1];
                action = cell2mat(getAction(agent,state));
                if nargin == 2
                    action2 = getAction(agent2,state);
                    predictiondata(ts,tf,rplot,1) = ...
                        mcritic2.getValue(state, action2) - ...
                        mcritic.getValue(state, action);
                    for i = 1:11
                        predictiondata(ts,tf,rplot,i+1) = ...
                            action2(i) - action(i);
                    end
                else
                    predictiondata(ts,tf,rplot,1) = mcritic.getValue(state, action);
                    for i = 1:11
                        predictiondata(ts,tf,rplot,i+1) = action(i);
                    end
                end
            end
        end
    end


    figure();
    for a = 1:12
        for i = 1:5
            subplot(5,12,(i-1)*12+a);
            heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins),...
                1-(1/thetabins):-(2/thetabins):-1+(1/thetabins),...
                flipud(predictiondata(:,:,i,a)),...
                'ColorbarVisible','off');
            %xlabel('\theta_{start}');
            %ylabel('\theta_{target}');
            if a == 1
                ylabel(strcat("r = ", string((2*i/rbins)-(7/6))))
            end
            if i == 1
                title(heatvariables(a))
            end
            colormap parula
            if a ~= 1
                if nargin == 2
                    caxis([-2, 2]);
                else
                    caxis([-1, 1]);
                end
            else
                if nargin == 2
                    limits = 2*[min(predictiondata(:,:,:,1),[],'all'),...
                        max(predictiondata(:,:,:,1),[],'all')];
                    caxis(limits);
                else
                    limits = [min(predictiondata(:,:,:,1),[],'all'),...
                        max(predictiondata(:,:,:,1),[],'all')];
                    caxis(limits);
                end
            end
            Ax = gca;
            Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
            Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
        end
    end
end