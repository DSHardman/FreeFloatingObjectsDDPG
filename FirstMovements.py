# First run Connect.py to initialise kg_robot called urnie

def main(urnie):
    home()
    #for i in range(40,50):
        #vibratefreq(0.002, i/10, 5)
        #home()
        
    vibratefreq(0.002, 3, 10)

def home():
    #urnie.movel([0.339942, 0.00912757, -0.0527063, 2.17729, -2.26317, -0.000819501], 0.5, 0.02) #1D Setup
    urnie.movel([0.3401, 0.00912627, -0.0592083, 2.17722, -2.26316, -0.000583779], 0.5, 0.02) #1D Low Setup
    #urnie.movel([0.339599, 0.00861482, -0.00907965, 2.17544, -2.26282, -0.000540843], 0.5, 0.02) #2D Setup
    

def step(size=0.05, t=1, acc=5.0, vel=5.0):
    urnie.translatel_rel([-size, size, 0, 0, 0, 0], acc, vel, min_time=t)


def zigzag(length=0.1, n=10, height=0.01, t=10, acc=5, vel=5):
    for i in range(0,int(n/2)):
        urnie.translatel_rel([-(length/n), (length/n), height, 0, 0, 0], acc, vel, min_time=t/(2*n))
        urnie.translatel_rel([-(length/n), (length/n), -height, 0, 0, 0], acc, vel, min_time=t/(2*n))
    for i in range(0,int(n/2)):
        urnie.translatel_rel([(length/n), -(length/n), height, 0, 0, 0], acc, vel, min_time=t/(2*n))
        urnie.translatel_rel([(length/n), -(length/n), -height, 0, 0, 0], acc, vel, min_time=t/(2*n))
        
def vibrate(length=0.005, n=10, t=10, acc=5, vel=5):
    for i in range(0,n):
        urnie.translatel_rel([-length, length, 0, 0, 0, 0], acc, vel, min_time=t/(2*n))
        urnie.translatel_rel([length, -length, 0, 0, 0, 0], acc, vel, min_time=t/(2*n))
        
def vibratefreq(amplitude, frequency, duration):
    length = amplitude*(numpy.sqrt(2))
    period = 1/frequency
    for i in range(0,int(duration*frequency)):
        urnie.translatel_rel([length, -length, 0, 0, 0, 0], 500, 500, min_time=period/2)
        urnie.translatel_rel([-length, length, 0, 0, 0, 0], 500, 500, min_time=period/2)
        
def tilted_step(size=0.05, angle = 15, t=1, acc=5.0, vel=5.0):
    pose = urnie.getl()
    pose[5] = - (angle/180)*pi
    urnie.movel(pose)
    
    time.sleep(3)
    urnie.translatel_rel([-size, size, 0, 0, 0, 0], acc, vel, min_time=t)
    
    time.sleep(3)
    home()
    
    

def tilted_vibrate(length=0.005, n=10, angle=15, t=10, acc=5, vel=5):
    pose = urnie.getl()
    pose[5] = - (angle/180)*pi
    urnie.movel(pose)
    
    time.sleep(3)
    vibrate(length, n, t, acc, vel)
    
    time.sleep(3)
    home()
    
def rake(length=0.02, n=3, height=0.03, t=5, acc=5.0, vel=5.0):
    for i in range(0,n):
        urnie.translatel_rel([-length, length, 0, 0, 0, 0], acc, vel, min_time=t/(4*n))
        urnie.translatel_rel([0, 0, height, 0, 0, 0], min_time=t/(4*n))
        urnie.translatel_rel([length, -length, 0, 0, 0, 0], acc, vel, min_time=t/(4*n))
        urnie.translatel_rel([0, 0, -height, 0, 0, 0], min_time=t/(4*n))
        
def rotate(angle=30, n=5, t=1, acc=10.0, vel=10.0):
    urnie.movej_rel([0, 0, 0, 0, 0, -(angle/360)*pi], acc, vel)
    for i in range(0,n):
        urnie.movej_rel([0, 0, 0, 0, 0, (angle/180)*pi], acc, vel, min_time=t/(2*n))
        urnie.movej_rel([0, 0, 0, 0, 0, -(angle/180)*pi], acc, vel, min_time=t/(2*n))
    urnie.movej_rel([0, 0, 0, 0, 0, (angle/360)*pi], acc, vel)
        

if __name__ == '__main__': main(urnie)