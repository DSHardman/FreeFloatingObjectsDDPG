"""
    Called from Matlab: lifts arm before reset so camera has a clear view

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

urnie.movel(numpy.add(wp.above_tubl, [0, 0, 0.25, 0, 0, 0]), 1, 0.1)
