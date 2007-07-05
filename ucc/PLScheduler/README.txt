The Preemptive Priority Level Scheduler

OVERVIEW:
ThePreemptingPriorityBasedScheduler, is a preemptive scheduler for TInyOS-2.x. Applications canachieve greater 
performance control by designating each task to a specific priority. Based on the original TinyOS-2.x scheduler, this 
scheduler uses up to five basic FIFO task queues:
• TaskPriority<TASKVERYHIGH> 
• TaskPriority<TASKHIGH> 
• TaskPriority<TASKBASIC> 
• TaskPriority<TASKLOW> 
• TaskPriority<TASKVERYLOW> 

For more information read the PL_DESIGN.pdf or visit my website: http://www.cs.ucc.ie/~cd5

USAGE
define priority tasks using by wiring up interfaces, an example can be seen in the apps directory,
compile with:

make telosb priority

RELEASE INFORMATION
THE PL Scheduler is currently in an EXPERIMENTAL state
Testing has not been carried out for any AVR platforms, msp430 only (have no avr to test on yet)


INSTALL
MakeSetup will copy all the files to your tinyos directory if you have the TOSROOT variable defined,
and you must also have write permission.

To use type make -f MakeSetup install


AUTHOR COMMENTS
I would appreciate any help anyone might provide. If you find any bugs with the scheduler let me know.
Hope u find it useful
best regards
Cormac
