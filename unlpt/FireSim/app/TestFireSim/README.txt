
README for TestFireSim
Author/Contact: ricardo_tiago@hotmail.com/telefctunl@gmail.com

Description:

TestFireSim is a simple Application to test the Fire Simulator.
It setups a 13x13 grid topology with 99 nodes and ignition Times 
for a fire with wind speed of 20mph. Nodes detect a yellow alarm 
when the fire is 2 cells away and a red alarm when is 1 cell away. 
If the fire reaches the cell with a node, then that node dies ( Turn Off ).

Tools:

FireLib ( www.fire.org/index.php?option=content&task=category&sectionid=2&id=11&Itemid=29 )
FireLib generates the fire matrix with the ignition Times.

Known bugs/limitations:
The size of the grid topology must be equal to the size of the ignitionTimes
matrix. The test app only accepts a 13x13 grid topology. If you want a bigger 
grid you need to change the file sim_fire.c and fire.py.

This is actually a limitation of fireLib, but the minimum ignitionTime is 1
minute.
