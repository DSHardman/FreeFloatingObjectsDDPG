import time
import serial
from math import pi
import numpy
import socket
import sys

sys.path.append(r"C:\Users\44772\Documents\dsh46WaterControl\ur5control")
import waypoints as wp
import kg_robot as kgr

urnie = kgr.kg_robot(port=30010,db_host="169.254.129.254")
urnie.set_tcp(wp.plunger_tcp)

#assume alignment of theta=0 and positive x axis

#convert to x_des, y_des in m
x_des = 0.001*float(sys.argv[1])*numpy.cos(float(sys.argv[2]))
y_des = 0.001*float(sys.argv[1])*numpy.sin(float(sys.argv[2]))


#move to desired position
urnie.movel(numpy.add(wp.reset_above_tubl, [x_des, y_des, 0.01, 0, 0, 0]),
            acc=0.03, vel=0.03)

time.sleep(5) #let settle
    
urnie.translatel_rel([0, 0, 0.01, 0, 0, 0], 0.05, 0.05) #lift

urnie.movel(wp.reset_above_tubl, 0.05, 0.05) #return to starting position

urnie.close() #disconnect