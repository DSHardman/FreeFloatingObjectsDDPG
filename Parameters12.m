classdef Parameters12
    properties
        xamp %mm
        xfreq %Hz
        xphase %degrees
        yamp %mm
        yfreq %Hz
        yphase %degrees
        zamp %mm
        zfreq %Hz
        depth %mm
        anglex %degrees
        angley %degrees
        decayinverse %absolute
    end
    
    methods
        
        function obj = Parameters12(xamp, xfreq, xphase, yamp, yfreq,...
                yphase, zamp, zfreq, depth, anglex, angley, decayinverse)
            %CONSTRUCTOR
            if nargin == 1
                obj.xamp = xamp(1);
                obj.xfreq = xamp(2);
                obj.xphase = xamp(3);
                obj.yamp = xamp(4);
                obj.yfreq = xamp(5);
                obj.yphase = xamp(6);
                obj.zamp = xamp(7);
                obj.zfreq = xamp(8);
                obj.depth = xamp(9);
                obj.anglex = xamp(10);
                obj.angley = xamp(11);
                obj.decayinverse = xamp(12);
            else
                obj.xamp = xamp;
                obj.xfreq = xfreq;
                obj.xphase = xphase;
                obj.yamp = yamp;
                obj.yfreq = yfreq;
                obj.yphase = yphase;
                obj.zamp = zamp;
                obj.zfreq = zfreq;
                obj.depth = depth;
                obj.anglex = anglex;
                obj.angley = angley;
                obj.decayinverse = decayinverse;
            end
        end
        
        function performnormalised(self,duration)
            %lowerlimits = [0; 0; 0; 0; 0; 0; 0; 0; 5; -10; -10; 2];
            %upperlimits = [4; 5; 360; 4; 5; 360; 4; 5; 50; 10; 10; 502];
            mxamp = 2*(self.xamp+1);
            mxfreq = 2.5*(self.xfreq+1);
            mxphase = 180*(self.xphase+1);
            myamp = 2*(self.yamp+1);
            myfreq = 2.5*(self.yfreq+1);
            myphase = 180*(self.yphase+1);
            mzamp = 2*(self.zamp+1);
            mzfreq = 2.5*(self.zfreq+1);
            mdepth = 20*(self.depth+1) + 5;
            manglex = 10*self.anglex;
            mangley = 10*self.angley;
            mdecayinverse = 250*(self.decayinverse+1) + 2;
            command = 'start python Call12D.py ' + string(mxamp)...
                    + ' ' + string(mxfreq) + ' ' + string(mxphase)...
                    + ' ' + string(myamp) + ' ' + string(myfreq)...
                    + ' ' + string(myphase) + ' ' + string(mzamp)...
                    + ' ' + string(mzfreq) + ' ' + string(mdepth)...
                    + ' ' + string(manglex) + ' ' + string(mangley)...
                    + ' ' + string(mdecayinverse) + ' ' + string(duration);
            system(command);
        end

        function perform(self, duration)
            command = 'start python Call12D.py ' + string(self.xamp)...
                    + ' ' + string(self.xfreq) + ' ' + string(self.xphase)...
                    + ' ' + string(self.yamp) + ' ' + string(self.yfreq)...
                    + ' ' + string(self.yphase) + ' ' + string(self.zamp)...
                    + ' ' + string(self.zfreq) + ' ' + string(self.depth)...
                    + ' ' + string(self.anglex) + ' ' + string(self.angley)...
                    + ' ' + string(self.decayinverse) + ' ' + string(duration);
            system(command);
        end
    end
end

