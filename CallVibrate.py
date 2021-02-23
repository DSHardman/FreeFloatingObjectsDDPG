"""
    Called from Matlab: 3 arguments are amplitude, frequency, duration
    
    Vibration at centre of tub in z direction
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

        
def vibratefreq(amplitude=0.005, frequency=1, duration=5):
    #get start and end positions first to prevent drift from relative motions
    upperpose = numpy.add(urnie.getl(), [0, 0, amplitude, 0, 0, 0])
    lowerpose = numpy.add(urnie.getl(), [0, 0, -amplitude, 0, 0, 0])
    period = 1/frequency
    t = time.time()
    while ((time.time() - t) < duration):
        urnie.movel(upperpose, 500, 50, min_time=period/2);
        urnie.movel(lowerpose, 500, 50, min_time=period/2);

urnie.movel(wp.above_tubl, 0.5, 0.02) #move above tub
urnie.movel(numpy.add(wp.above_tubl, [0, 0, -0.03, 0, 0, 0]), 0.5, 0.02) #submerge
vibratefreq(float(sys.argv[1]), float(sys.argv[2]), float(sys.argv[3]))
urnie.close()
