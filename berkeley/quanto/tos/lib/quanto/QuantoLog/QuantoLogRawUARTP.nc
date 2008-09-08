/** Simple module that logs activity changes.
 *  It logs in response to Context.changed events into a 
 *  memory array and dumps them to the UART using the
 *  Debug interface. 
 */
/* TODO: only turn on the serial port when logging! */
#include "RawUartMsg.h"
module QuantoLogRawUARTP {
    provides {
        interface QuantoLog;
    }
    uses {
        interface SingleContextTrack[uint8_t global_res_id];
        interface MultiContextTrack[uint8_t global_res_id];
        interface PowerStateTrack[uint8_t global_res_id];
        //interface Leds;
        //interface Timer<TMilli> as ReportTimer;
        //interface LocalTime<TMilli> as LocalTime;
        interface Counter<T32khz,uint32_t> as Counter;
        interface AMSend as UARTSend;
	    interface SplitControl as SerialControl;
        interface Boot; 
        
        interface EnergyMeter;
    }
}
implementation {
    uint32_t count;
    uint16_t report_index, total_reports;

    enum {LOGSIZE = 700};

    entry_t log[LOGSIZE];

    message_t uart_msg;
    quanto_log_msg_t* log_data_msg;
    uint8_t len;

    static act_t m_act_idle;

    enum {S_IDLE = 0, S_REC, S_REP_LOG, S_FULL};
    uint8_t m_state;

    void initState() {
        count = 0;
        report_index = 0;
        total_reports = 0;
        atomic {
            m_state = S_IDLE;
        }
    }

    event void
    Boot.booted() {
        m_act_idle = mk_act_local(ACT_TYPE_IDLE);
        call SerialControl.start();
        len = sizeof(quanto_log_msg_t);
        log_data_msg = call UARTSend.getPayload(&uart_msg, len);
        initState();   
    }

	event void SerialControl.startDone(error_t error) {
		if (error != SUCCESS) {
			call SerialControl.start();
		}
	}

	event void SerialControl.stopDone(error_t error) {
	}

    task void full() {
        signal QuantoLog.full();
    }

    inline void 
    recordChange(uint8_t id, uint16_t value, uint8_t type) 
    {
        entry_t *e = NULL;
        if (m_state != S_REC)
            return;
        //call Leds.led1Toggle();
        atomic {
            if (count < LOGSIZE) {
                e = &log[count]; 
            } else 
                m_state = S_FULL;
            count++;
        }
        if (e) {
            e->time  = call Counter.get();
            e->ic    = call EnergyMeter.read();
            e->type = type;
            e->res_id = id;
            e->act  = value; //also works for powerstate
        }
        if (m_state == S_FULL)
            post full();
    }


    async event void 
    SingleContextTrack.changed[uint8_t id](act_t new_activity) 
    {
        recordChange(id, new_activity, TYPE_SINGLE_CHG_NORMAL);
    }

    async event void 
    SingleContextTrack.bound[uint8_t id](act_t new_activity) 
    {
        recordChange(id, new_activity, TYPE_SINGLE_CHG_BIND);
    }

    async event void 
    SingleContextTrack.enteredInterrupt[uint8_t id](act_t new_activity) 
    {
        recordChange(id, new_activity, TYPE_SINGLE_CHG_ENTER_INT);
    }

    async event void 
    SingleContextTrack.exitedInterrupt[uint8_t id](act_t new_activity) 
    {
        recordChange(id, new_activity, TYPE_SINGLE_CHG_EXIT_INT);
    }
   
    async event void
    MultiContextTrack.added[uint8_t id](act_t activity)
    {
        recordChange(id, activity, TYPE_MULTI_CHG_ADD);
    }

    async event void
    MultiContextTrack.removed[uint8_t id](act_t activity)
    {
        recordChange(id, activity, TYPE_MULTI_CHG_REM);
    }

    async event void
    MultiContextTrack.idle[uint8_t id]()
    {
        recordChange(id, m_act_idle, TYPE_MULTI_CHG_IDL);
    }

    async event void
    PowerStateTrack.changed[uint8_t id](powerstate_t state)
    {
        recordChange(id, state, TYPE_POWER_CHG);
    }   

    command error_t QuantoLog.record() {
        if (m_state != S_IDLE)
            return EBUSY;
        m_state = S_REC;
        call EnergyMeter.reset();
        call EnergyMeter.start();
        return SUCCESS;
    }

    //stop logging and start reporting
    command error_t QuantoLog.flush() {
        bool to_flush = 0;
        atomic {
            if (m_state == S_REC || m_state == S_FULL) {
                m_state = S_REP_LOG;       
                to_flush = 1;
            }
        }
        if (! to_flush)
            return EBUSY;
        call EnergyMeter.pause();
        total_reports = (count > LOGSIZE)?LOGSIZE:count;
        report_index = 0;

        memset(log_data_msg, 0, sizeof(quanto_log_msg_t));
        log_data_msg->entry.type = TYPE_COUNT_EV;
        log_data_msg->entry.event_count = count;

        return call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len);
    }

    error_t logNextEntry() {
        entry_t *e;
        nx_entry_t *xe;
        memset(log_data_msg, 0, sizeof(quanto_log_msg_t));

        e = &log[report_index];
        xe = &log_data_msg->entry;

        xe->type   = e->type;
        xe->res_id = e->res_id;
        xe->time   = e->time;
        xe->ic     = e->ic;
        xe->act    = e->act;

        report_index++;
        return call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len);
    }

    event void UARTSend.sendDone(message_t *msg, error_t error) {
        if (msg != &uart_msg)
            return;
        if (m_state == S_REP_LOG && (report_index < total_reports) )
           logNextEntry();
        else
            initState();
    }

   async event void Counter.overflow() 
   {
   }

   default event void QuantoLog.full()
   {
   }
}
