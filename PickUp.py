"""
    Called from Matlab: 4 arguments are r_current, theta_current
                                        r_desired, theta_desired
    
    Turns on electromagnet and moves near current area, then slowly
    to desired location.
"""

import time
import serial
from math import pi
import numpy
import socket
import sys

sys.path.append("C:/Users/David/Documents/PhD/ur5control")
import waypoints as wp
import kg_robot as kgr

urnie = kgr.kg_robot(port=30010,db_host="169.254.161.50")
urnie.set_tcp(wp.plunger_tcp)

#assume alignment of theta=0 and positive x axis
#convert to x, y in m
x = 0.001*float(sys.argv[1])*numpy.cos(float(sys.argv[2]))
y = 0.001*float(sys.argv[1])*numpy.sin(float(sys.argv[2]))

#convert to x_des, y_des in m
x_des = 0.001*float(sys.argv[3])*numpy.cos(float(sys.argv[4]))
y_des = 0.001*float(sys.argv[3])*numpy.sin(float(sys.argv[4]))

urnie.set_tool_digital_out(0,1) #turn electromagnet on
centre = numpy.add(wp.above_tubl, [x, y, 0, 0, 0, 0])

# if object couldn't be found, trace edge of tub
if (float(sys.argv[1]) > 190):
    urnie.movel(numpy.add(wp.above_tubl, [0.16, 0, 0.05, 0, 0, 0]),0.1, 0.1)
    for i in range(50):
        x_r = 0.17*numpy.cos(i*pi/25)
        y_r = 0.17*numpy.sin(i*pi/25)
        urnie.movel(numpy.add(wp.above_tubl, [x_r, y_r, 0, 0, 0, 0]),0.05, 0.05)

#if object near middle of tub, trace locally
elif (float(sys.argv[1]) < 130):
    urnie.movel(numpy.add(wp.above_tubl,
                          [0.001*float(sys.argv[1])*numpy.cos(float(sys.argv[2]) - pi/4),
                           0.001*float(sys.argv[1])*numpy.sin(float(sys.argv[2]) - pi/4),
                           0.05, 0, 0, 0]),0.1, 0.1)
    for i in range(10):
        x_r = 0.001*float(sys.argv[1])*numpy.cos(float(sys.argv[2]) - pi/4 + i*pi/20)
        y_r = 0.001*float(sys.argv[1])*numpy.sin(float(sys.argv[2]) - pi/4 + i*pi/20)
        urnie.movel(numpy.add(wp.above_tubl, [x_r, y_r, 0, 0, 0, 0]),0.05, 0.05)
    for i in range(2):
        for j in range(5):
            urnie.movel(numpy.add(centre, [i*0.025*numpy.sin(j*0.4*pi),
                                           i*0.025*numpy.cos(j*0.4*pi),
                                            0, 0, 0, 0]), 0.05, 0.05)
    
#if object near edge of tub, trace local area of edge
else:
    urnie.movel(numpy.add(wp.above_tubl,
                          [0.16*numpy.cos(float(sys.argv[2]) - pi/5),
                           0.16*numpy.sin(float(sys.argv[2]) - pi/5),
                           0.05, 0, 0, 0]),acc=0.1, vel=0.1)
    for i in range(10):
        x_r = 0.17*numpy.cos(float(sys.argv[2]) - pi/10 + i*pi/50)
        y_r = 0.17*numpy.sin(float(sys.argv[2]) - pi/10 + i*pi/50)
        urnie.movel(numpy.add(wp.above_tubl, [x_r, y_r, 0, 0, 0, 0]),acc=0.01, vel=0.01)

#move to desired position
urnie.movel(numpy.add(wp.above_tubl, [x_des, y_des, 0, 0, 0, 0]),
            acc=0.01, vel=0.01)

time.sleep(5) #let settle
    
urnie.set_tool_digital_out(0,0) #turn electromagnet off
urnie.translatel_rel([0, 0, 0.01, 0, 0, 0], 0.05, 0.05) #lift

"""
#vibrate to remove stuck object
upperpose = numpy.add(urnie.getl(), [0, 0, 0.005, 0, 0, 0])
lowerpose = urnie.getl()
period = 1/5
t = time.time()
while ((time.time() - t) < 1.5):
    urnie.movel(upperpose, 500, 50, min_time=period/2);
    urnie.movel(lowerpose, 500, 50, min_time=period/2);
"""

urnie.movel(wp.above_tubl, 0.05, 0.05) #return to starting position

urnie.close() #disconnect