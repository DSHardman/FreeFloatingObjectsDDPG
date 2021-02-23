"""
    Called from Matlab: gets into starting position and waits until tracking
    has been running for 30s, then uses servoj to perform input from file
"""

import time
import serial
import math
from math import pi
import numpy
import socket
import sys
import sched
import scipy.io as sio

sys.path.append("C:/Users/David/Documents/PhD/ur5control")
import waypoints as wp
import kg_robot as kgr

controlfreq = 20
i = int(sys.argv[1]) #which file to read 
t = time.time() #start timer

mat_contents = sio.loadmat("Motions/Noise/RandomMotions"+str(i)+".mat")
motions = mat_contents["motions"]

urnie = kgr.kg_robot(port=30010,db_host="169.254.161.50")
urnie.set_tcp(wp.plunger_tcp)

centrepose=numpy.add(wp.above_tubl, [0, 0, -0.03, 0, 0, 0])

urnie.movel(numpy.add(centrepose, motions[0]), 0.5, 0.02) #move to starting position

#scheduler used to regularly pass desired positions to servoj 
scheduler = sched.scheduler(time.time, time.sleep)
def schedule_it(dt, duration, callable, *args):
    for i in range(int(duration/dt)):
        scheduler.enter(i*dt, 1, callable, args+(i,))
    
# main function: moves to desired position at any moment in time
def random_move(motionmatrix, centrepose, n):
    pose = numpy.add(centrepose, numpy.concatenate([motionmatrix[n][1:], numpy.zeros(1)]))
    urnie.servoj(pose, vel=50, control_time=1/controlfreq)

#do not start motions until 30 seconds have passed from beginning of function
while (time.time() - t < 15):
    continue

#initialise scheduler
schedule_it(1/controlfreq, motions[-1][0], random_move, motions, centrepose)

#run scheduler calling servoj
scheduler.run()

urnie.close()

