SingleContext is the interface to be used for resources that can only be
set to a single activity at any given time. The foremost example of this is
one (single-core) CPU. Contrast with MultiContext interface.

Each single-owner resource in the system should be represented by a SingleContext.

The set of components and modules here implement a KeyMap between globally known,
user-defined RESOURCE_CTX_IDs and a local keyspace for efficiency.

SingleContext is the interface.
SingleContextC is a generic configuration that is used once to define a resource (such as 
CPUContextC).
It maps one SingleContextG entry (parameterized by global id) to one SingleContextP
(parameterized by local id). The local id is defined to be unique from the 
string SINGLE_CONTEXT_UNIQUE defined in SingleContext.h

Scheduler
---------
The scheduler for quanto is SingleContextSchedulerQuantoTasksP, as wired in TinySchedulerC.nc 
in this directory.

This scheduler correctly propagates activity labels as tasks get scheduled.

This scheduler adds the a lowest-priority TaskQuanto queue, that runs Quanto logging tasks
at the lowest priority. They also allow scheduling tasks to run under an activity that is not
the current activity when they get scheduled, without causing extra activity-switches to do
that. 

TaskQuanto tasks are used by the Low-priority serial stack for streaming quanto logging.


