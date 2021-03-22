classdef TrackedPath
    properties
        n
        timevec
        radiusvec
        thetavec
        xvec
        yvec
        originalindex
    end
    
    methods
        function obj = TrackedPath(filename)
            %Constructor
            if nargin > 0
                load(filename, 'results');
                obj.n = size(results,1);
                if obj.n >= 1
                    obj.timevec = results(:,1);
                    obj.radiusvec = results(:,2);
                    obj.thetavec = results(:,3);

                    obj.xvec = zeros(obj.n, 1);
                    obj.yvec = zeros(obj.n, 1);
                    for i = 1:obj.n
                        [x, y] = pol2cart(obj.thetavec(i), obj.radiusvec(i));
                        obj.xvec(i) = x;
                        obj.yvec(i) = y;
                    end
                else
                    obj.timevec = NaN;
                    obj.radiusvec = NaN;
                    obj.thetavec = NaN;
                    obj.xvec = NaN;
                    obj.yvec = NaN;
                end
            end
        end
        
        function plotPath(obj, lineonly)
            global plottingcolor
            global plottingstyle
            [theta, r] = cart2pol(obj.xvec, obj.yvec);
            [x, y] = pol2cart(-(theta-pi/4), min(r, 165));
            %[x, y] = pol2cart(theta, min(r, 165));
            p = plot(smooth(x,10), smooth(y,10), 'LineWidth', 1, 'Color', plottingcolor, 'LineStyle', plottingstyle);
            p.Color(4) = 0.7;
            c = get(p,'Color');
            %hold on
            scatter(x(end), y(end), 20, c, '*', 'LineWidth', 1, 'MarkerEdgeAlpha', 0.5)
            %h = viscircles([0 0], 20, 'Color', 'k');
            %fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');
            if nargin == 1 || ~lineonly
                viscircles([0 0], 165, 'Color', 'k');%,'LineStyle', '--');
            end
        end
        
        function length = getLength(obj)
            length = 0;
            for i = 1:obj.n - 1
                length = length + (sqrt((obj.xvec(i+1)-obj.xvec(i))^2+(obj.yvec(i+1)-obj.yvec(i))^2));
            end
        end
        
        function gap = containsGap(obj, threshold)
            if nargin == 1
                threshold = 5;
            end
            gap = 0;
            for i = 1:obj.n - 1
                if obj.timevec(i+1) - obj.timevec(i) > threshold
                    gap = 1;
                    return
                end
            end
        end
        
    end
end

