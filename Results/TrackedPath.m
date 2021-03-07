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
        
        function plotPath(obj)
            plot(obj.xvec, obj.yvec, 'Color', 'r');
            viscircles([0 0], 20, 'Color', 'k');
            viscircles([0 0], 165, 'Color', 'k','LineStyle', '--');
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

