# FreeFloatingObjectsDDPG

This code accompanies the paper _Manipulation of Free-Floating Objects using Faraday Flows and Deep Reinforcement Learning_. 

Written using MATLAB 2020b (Statistics and Machine Learning Toolbox & Reinforcement Learning Toolbox) & Python 3 (Generic UR5 Controller: [kg398/Generic_ur5_controller: new version of ur5 python controller (github.com)](https://github.com/kg398/Generic_ur5_controller)).



## Camera Calibration

Camera calibration must be carried out before BO/DRL methods can be run. This consists of 3 parts:

* Connecting to the webcam: _CameraConnect.m_
* Taking calibration photos of a chequerboard with 30mmx30mm squares, floating on the surface of the water: _TakeCalibrationPhotos.m_. In the first photo, the chequerboard is aligned with the coordinate axes of the UR5.
* Generating the calibration parameters using the photos in the _CalibrationImages_ subdirectory: _CalibrateCamera.m_.



## Bayesian Optimisation

Is run from _BayesianOptimisation.m_, which calls the cost function using a handle to _i180CostFunction.m_, which runs a single iteration, returns a cost, and resets the floating object to its starting position. The reset & run steps are largely identical to those of the DDPG script, described below.



## Reinforcement Learning

Run from _RL_I.m_, which sets up the DDPG agent and calls step/reset functions _step_I.m_ & _reset_I.m_. 

The process for a single iteration is illustrated below:

![Single Iteration](FlowChart.png)

after which the process is repeated for up to 5000 iterations.




## Result Structures

### Bayesian

Bayesian results are stored as MATLAB's _BayesianOptimization_ objects. The tracked paths are stored as nx3 arrays, with columns using a polar coordinate system: time|r|theta.

### DDPG

Agents at various stages of training are stored as _rlDDPGAgent_ objects. Training progress data is stored in separate Nx1 arrays for results & Q0 values at each iteration, where N is the total number of iterations.

Data file _AllRepetitions.mat_ stores repeated results on the trained agent for different shapes (as _RepeatingResults_ objects, defined in the _Results_ folder) and during development of each of the 5 tasks (as _DevelopingResults_ objects, defined in the _Results_ folder).  

Data file _MainTests.mat_ stores the 1000 tests of randomised states on the trained agent, as a _ShapeResults_ object, defined in the _Results_ folder.





_David Hardman, 14/04/21_