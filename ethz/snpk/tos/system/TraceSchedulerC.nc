/**
 * TraceScheduler adds the ability to trace mcu usage time.
 * The actual load can be fetched through the Read interface.
 * 
 * @author Roman Lim
 * @date   March 30 2007
 */
 configuration TraceSchedulerC {
  provides interface Scheduler;
  provides interface TaskBasic[uint8_t id];
  uses interface McuSleep;

  provides interface Read<uint16_t>;
}
implementation {
  components SchedulerBasicP as Sched;
  components TraceSchedulerP as TraceSched;
  Scheduler = Sched;

  TaskBasic = TraceSched;
  TraceSched.SubSleep = McuSleep;

  TraceSched.SubTaskBasic->Sched;
  Sched.McuSleep->TraceSched;
  
  components Counter32khz16C;
  TraceSched.Counter->Counter32khz16C;

  Read = TraceSched;
}

