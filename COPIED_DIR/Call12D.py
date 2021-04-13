"""
    Called from Matlab: 12 arguments are xamp, xfreq, xphase, yamp, yfreq, 
                                        yphase, zamp, zfreq, depth, anglex, 
                                        angley, decayrate, duration
    
    Motions for optimization tasks: 12D paramaterised space
"""

import time
import serial
import math
from math import pi
import numpy
import socket
import sys
import sched

sys.path.append(r"C:\Users\44772\Documents\dsh46WaterControl\ur5control")
import waypoints as wp
import kg_robot as kgr

tstart = time.time()

urnie = kgr.kg_robot(port=30010,db_host="169.254.129.254")
urnie.set_tcp(wp.plunger_tcp)

#scheduler used to regularly pass desired positions to servoj 
scheduler = sched.scheduler(time.time, time.sleep)
def schedule_it(dt, duration, callable, *args):
    for i in range(int(duration/dt)):
        scheduler.enter(i*dt, 1, callable, args)

#calculate starting position of motion
def starting_pos(centrepose, xamp, xphase, yamp, yphase, depth, anglex, angley):
    npose = numpy.add(centrepose, [0, 0, 0.001*(30-depth), 0, 0, 0])
    npose = numpy.add(npose, [0, 0, 0, anglex, angley, 0])
    npose = numpy.add(npose, [xamp*math.sin(xphase), 0, 0, 0, 0, 0])
    npose = numpy.add(npose, [0, yamp*math.sin(yphase), 0, 0, 0, 0])
    urnie.movel(npose)
    
# main function: moves to desired position at any moment in time
def parameter_move(t0, centrepose, xamp, xfreq, xphase, yamp, yfreq, yphase, zamp, zfreq, depth, anglex, angley, decayrate):
    #start with z height
    npose = numpy.add(centrepose, [0, 0, 0.001*(30-depth), 0, 0, 0])
    #add angles
    npose = numpy.add(npose, [0, 0, 0, anglex, angley, 0])
    t = time.time() - t0
    #xamp = xamp*math.exp(-decayrate*t)
    #yamp = yamp*math.exp(-decayrate*t)
    #zamp = zamp*math.exp(-decayrate*t)
    xamp = max(0,(1-decayrate*t)*xamp) 
    yamp = max(0,(1-decayrate*t)*yamp)
    zamp = max(0,(1-decayrate*t)*zamp)
    #x vibrations
    npose = numpy.add(npose, [xamp*math.sin(xfreq*t+xphase), 0, 0, 0, 0, 0])
    #y vibrations
    npose = numpy.add(npose, [0, yamp*math.sin(yfreq*t+yphase), 0, 0, 0, 0])
    #zvibrations
    npose = numpy.add(npose, [0, 0, zamp*math.sin(zfreq*t), 0, 0, 0])
    #pass to UR5
    urnie.servoj(npose, vel=50, control_time=0.05)

urnie.movel(wp.above_tubl, 0.5, 0.02) #move above tub
centrepose=numpy.add(wp.above_tubl, [0, 0, -0.03, 0, 0, 0])

#move to starting position
starting_pos(centrepose, 0.001*float(sys.argv[1]), (pi/180)*float(sys.argv[3]),
             0.001*float(sys.argv[4]), (pi/180)*float(sys.argv[6]),
             float(sys.argv[9]), (pi/180)*float(sys.argv[10]),
             (pi/180)*float(sys.argv[11]))

time.sleep(0.5)

while (time.time() - tstart) < 5: #time with matlab script
    continue

t0 = time.time()
#initialise scheduler
schedule_it(0.05, float(sys.argv[13]), parameter_move, t0, centrepose,
            0.001*float(sys.argv[1]), 2*pi*float(sys.argv[2]),
            (pi/180)*float(sys.argv[3]), 0.001*float(sys.argv[4]), 2*pi*float(sys.argv[5]), 
            (pi/180)*float(sys.argv[6]), 0.001*float(sys.argv[7]), 2*pi*float(sys.argv[8]),
            float(sys.argv[9]), (pi/180)*float(sys.argv[10]), (pi/180)*float(sys.argv[11]),
            1/float(sys.argv[12]))

#run scheduler calling servoj
scheduler.run()

urnie.close()

