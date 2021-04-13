import time
import serial
from math import pi
import numpy
import socket

import waypoints as wp
import kg_robot as kgr


print("------------Configuring Urnie-------------\r\n")
urnie = kgr.kg_robot(port=30010,db_host="169.254.161.50")
urnie.set_tcp(wp.plunger_tcp)
#urnie = kgr.kg_robot(port=30010,ee_port="COM32",db_host="192.168.1.51")
print("----------------Hi Urnie!-----------------\r\n\r\n")

