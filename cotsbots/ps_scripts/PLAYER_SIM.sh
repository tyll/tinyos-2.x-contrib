#!/bin/bash

echo "running make clean"
make clean;
rm -f SIMULATOR.py*

echo "#####################"
echo "running make micaz sim"
echo "#####################"
make micaz sim;
echo "#####################"
echo "make micaz sim done"
echo "#####################"

echo "#####################"
echo "running TOSSIM Simulation"
echo "sourcing from script:" $CTBTSIM
echo "#####################"
#python $CTBTSIM/SIM_script.py | sed s/DEBUG\ \([0-9]*\)\:\ /\#\&\\n/ > SIMULATOR.py


touch SIMULATOR.py_debug
python $CTBTSIM/SIM_script.py $1 $2 $3 $4 $5

##################################################################
#READ THE ABOVE FILE IF YOU WANT FULL DEBUG OUTPUT FROM TINYOS   #
##################################################################

echo "#####################"
echo "TOSSIM simulation complete"
echo "#####################"

#echo "fixing SIMULATOR.py for timing"
#python $CTBTSIM/TimeFix.py
#cp -f /tmp/SIMULATOR.py_fixing  SIMULATOR.py
#sed s/[0-9]*\:[0-9]*\:[0-9]*\.[0-9]*/"matched"/
#echo "done fixing SIMULATOR.py for timing"

#echo "running SIMULATOR.py"
#/usr/bin/python ./SIMULATOR.py
#echo "done running SIMULATOR.py"


echo "#####################"
echo "simulation is over, please check SIMULATOR.py for details"
echo "#####################"
