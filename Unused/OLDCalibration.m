classdef Calibration
   properties
      centrex {mustBeNumeric}
      centrey {mustBeNumeric}
      diameter {mustBeNumeric}
      rotation {mustBeNumeric}
      ystretch {mustBeNumeric}
      realdiameter {mustBeNumeric}
   end
   methods
      function obj = Calibration(I, realdiameter) %CONSTRUCTOR
        obj.realdiameter = realdiameter;  
        imshow(I);
        quarters = ginput(4); %x_left, x_right, y_up, y_down
        close();
    
        %calculate equations of lines across diameter
        m1 = (quarters(2,2)-quarters(1,2))/(quarters(2,1)-quarters(1,1));
        c1 = quarters(1,2) - m1*quarters(1,1);
        m2 = (quarters(4,2)-quarters(3,2))/(quarters(4,1)-quarters(3,1));
        c2 = quarters(3,2) - m2*quarters(3,1);
    
        %take their intersection to be the circle centre
        obj.centrex = (c2 - c1)/(m1 - m2);
        obj.centrey = (m1*obj.centrex + c1);
    
        %Rotation angle required, in radians
        obj.rotation = atan(m1);
    
        %Diameter, in pixels
        obj.diameter = norm([quarters(1,1)-quarters(2,1); quarters(1,2) - quarters(2,2)]);
    
        %Stretch required in y direction
        obj.ystretch = obj.diameter/norm([quarters(3,1)-quarters(4,1); quarters(3,2) - quarters(4,2)]);
      end
      
   end
end