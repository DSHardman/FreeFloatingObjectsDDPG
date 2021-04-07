# First run Connect.py to initialise kg_robot called urnie

def main(urnie):
    home()
    time.sleep(1)
    submerge()
    #vibratefreq(amplitude=0.005, frequency=5, duration=600)
    #swirlfreq()

def home():
    urnie.movel([0.369951, -0.2663, 0.0560386, -2.18189, 2.25592, 0.00358054], 0.5, 0.02) # above tub centre
    
def submerge():
    urnie.movel([0.370055, -0.266417, 0.0210293, -2.1824, 2.25568, 0.0032754], 0.5, 0.02) #centre of tub

def step(size=0.05, t=1, acc=5.0, vel=5.0):
    urnie.translatel_rel([-size, size, 0, 0, 0, 0], acc, vel, min_time=t)
        
     
def vibratefreq(amplitude=0.005, frequency=1, duration=5):
    upperpose = numpy.add(urnie.getl(), [0, 0, amplitude, 0, 0, 0])
    lowerpose = numpy.add(urnie.getl(), [0, 0, -amplitude, 0, 0, 0])
    period = 1/frequency
    t = time.time()
    while ((time.time() - t) < duration):
        urnie.movel(upperpose, 500, 50, min_time=period/2);
        urnie.movel(lowerpose, 500, 50, min_time=period/2);
        
def swirlfreq(diameter=0.05, frequency=0.1, duration=10):
    period = 1/frequency
    t = time.time()
    centre = urnie.getl()
    urnie.translatel_rel([diameter/2, 0, 0, 0, 0, 0], 500, 500, min_time=1)
    while ((time.time() - t) < duration):
        x1 = (diameter/2)*numpy.cos(2*numpy.pi*frequency*(time.time() - t))
        x2 = (diameter/2)*numpy.sin(2*numpy.pi*frequency*(time.time() - t))
        urnie.translatel(numpy.add(centre, [x1, x2, 0, 0, 0, 0]), 500, 500, min_time=0.01)
        
    
def rake(length=0.02, n=3, height=0.03, t=5, acc=5.0, vel=5.0):
    check0 = urnie.getl()
    check1 = numpy.add(check0, [-length, length, 0, 0, 0, 0])
    check2 = numpy.add(check1, [0, 0, height, 0, 0, 0])
    check3 = numpy.add(check2, [length, -length, 0, 0, 0, 0])
    for i in range(0,n):
        urnie.translatel_rel(check1, acc, vel, min_time=t/(4*n))
        urnie.translatel_rel(check2, min_time=t/(4*n))
        urnie.translatel_rel(check3, acc, vel, min_time=t/(4*n))
        urnie.translatel_rel(check0, min_time=t/(4*n))
        
def rotate(angle=30, n=5, t=1, acc=10.0, vel=10.0):
    startj = urnie.getj()
    end1 = numpy.add(startj, [0, 0, 0, 0, 0, -(angle/360)*pi])
    urnie.movej(end1, acc, vel)
    end2 = numpy.add(end1, [0, 0, 0, 0, 0, (angle/180)*pi])
    for i in range(0,n):
        urnie.movej_rel(end2, acc, vel, min_time=t/(2*n))
        urnie.movej_rel(end1, acc, vel, min_time=t/(2*n))
    urnie.movej_rel(startj, acc, vel)
        

if __name__ == '__main__': main(urnie)