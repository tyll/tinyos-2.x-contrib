/**
 * TraceScheduler adds the ability to trace mcu usage time.
 * The actual load can be fetched through the Read interface.
 * 
 * @author Roman Lim
 * @date   March 30 2007
 */
module TraceSchedulerP {
  provides interface TaskBasic[uint8_t id];
  provides interface McuSleep;
  uses interface McuSleep as SubSleep;
  uses interface TaskBasic as SubTaskBasic[uint8_t id];

  uses interface Counter<T32khz,uint16_t>;

  provides interface Read<uint16_t>;
}
implementation {

  enum {
	S_RUNNING,
	S_SLEEPING,
  };

  uint8_t m_state=S_RUNNING;
  uint16_t timestamp=0;
  uint16_t uptime=0;
  uint16_t stats;

  async command error_t TaskBasic.postTask[uint8_t id]() {
	error_t error=call SubTaskBasic.postTask[id]();
	atomic {
		if ((m_state==S_SLEEPING) & (error==SUCCESS)) {
			// remember
			m_state=S_RUNNING;
			timestamp=call Counter.get();
		}
	}
	return error;
 }

  event void SubTaskBasic.runTask[uint8_t id]() {
	signal TaskBasic.runTask[id]();
  }

  async command void McuSleep.sleep() {
	atomic {
		if (m_state!=S_SLEEPING) {
			// remember time
			uptime+=call Counter.get()-timestamp;
			m_state=S_SLEEPING;
		}
	}
	call SubSleep.sleep();
  }

  async event void Counter.overflow() {
	uint16_t time;
	// create stats
	atomic {
		time=0; // after the overflow, time should be 0
		if (m_state==S_RUNNING) {
			uptime+=time-timestamp;
			if (uptime==0)
				uptime=0xffff;
		}
		stats=uptime;
		uptime=0;
		timestamp=time;
	}
  }

  default event void TaskBasic.runTask[uint8_t id]()
  {  }

  command error_t Read.read() {
	uint16_t tmpstats;
	atomic {
		tmpstats=stats;
	}
	// posting a task seems not to work
	signal Read.readDone( SUCCESS, tmpstats);
	return SUCCESS;
  }
}
