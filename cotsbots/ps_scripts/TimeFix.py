#!/usr/bin/python

#Below is the Input(To Fix) filename/location
InputFileName = "SIMULATOR.py"

#Below is the Output(Fixed) filename/location
OutputFileName = "/tmp/SIMULATOR.py_fixing"

import re
t = "time.sleep\([\d]*:[\d]*:[\d]*\.[\d]*\)"
p = re.compile(t)

f = open(InputFileName,"r")
new_file = open(OutputFileName,"w")

line = f.readline()

current_time = 0
while(line != ''):
  m = p.match(line)
  #if the line f didn't match m, then if(m) should not run 
  if(m):
#    print line
#    print current_time
    hours = line.split("(")[1].split(":")[0]
    minutes = line.split("(")[1].split(":")[1]
    seconds = line.split("(")[1].split(":")[2].split(")")[0]
    line = "time.sleep(" + hours + "* 3600 +" + minutes + "* 60 +" + seconds + "-" + str(current_time) + ")\n"
    current_time = float(hours) * 3600 + float(minutes) * 60 + float(seconds)
#    print current_time
#    print line
    

  new_file.write(line)
  new_file.flush()
  line = f.readline()
#END OF LOOP#

new_file.close()
f.close()
