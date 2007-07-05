README for RadioCountToLeds

Description:
A modification of the RadioCountToLeds Application. This application perdically
sets of a timer which posts a long executing low priority task. This
task must be preempted by the AM stack tasks, of communication wont work.

RadioCountToLeds maintains a 4Hz counter, broadcasting its value in 
an AM packet every time it gets updated. A RadioCountToLeds node that 
hears a counter displays the bottom (2 bits only!) bits on its LEDs. This 
application is a useful test to show that basic AM communication and 
timers work in conjunction with preemptive priority scheduling. 


