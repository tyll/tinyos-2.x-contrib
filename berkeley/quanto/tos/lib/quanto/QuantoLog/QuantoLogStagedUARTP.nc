/** Simple module that logs activity changes.
 *  It logs in response to Context.changed events into a 
 *  memory array and dumps them to the UART using the
 *  Debug interface. 
 */
/* TODO: only turn on the serial port when logging! */
#include "RawUartMsg.h"
module QuantoLogStagedUARTP {
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
    uint16_t count;
    uint16_t report_index;

    enum {LOGSIZE = 20};

    entry_t log[LOGSIZE];

    message_t uart_msg;
    quanto_log_msg_t* log_data_msg;
    uint8_t len;

    norace static act_t m_act_idle;

    enum {S_IDLE = 0, S_REC, S_FLUSH};
    uint8_t m_state;
    uint16_t m_missed_flush;
    uint32_t m_t_flush;
    uint32_t m_i_flush;

    event void
    Boot.booted() {
        m_act_idle = mk_act_local(ACT_TYPE_IDLE);
        call SerialControl.start();
        len = sizeof(quanto_log_msg_t);
        log_data_msg = call UARTSend.getPayload(&uart_msg, len);
        atomic {
            m_state = S_IDLE; 
        }
    }

	event void SerialControl.startDone(error_t error) {
		if (error != SUCCESS) {
			call SerialControl.start();
		}
	}

	event void SerialControl.stopDone(error_t error) {
	}

    task void flush();

    void enterFlush(uint32_t _time, uint32_t _ic) {
        uint8_t c;
        atomic {
            m_state = S_FLUSH;
            m_missed_flush = 0;
            report_index = 0;
            m_t_flush = _time;
            m_i_flush = _ic;
            c = count; 
        }
        if (c)
            post flush();
    }

    void enterRec() {
        atomic {
            count = 0;
            m_state = S_REC;     
        }
    }
 
    inline void 
    recordChange(uint8_t id, uint16_t value, uint8_t type) 
    {
        entry_t *e = NULL;
        uint8_t to_flush = 0;
        uint8_t state;
        atomic {
            state = m_state;
            if (state == S_FLUSH)
                m_missed_flush++;
        }
        if (state != S_REC)
            return;
        atomic {
            if (count < LOGSIZE) 
                e = &log[count]; 
            count++; 
            if (count == LOGSIZE) 
                to_flush = 1;
        }
        if (e) {
            e->time  = call Counter.get();
            e->ic    = call EnergyMeter.read();
            e->type = type;
            e->res_id = id;
            e->act  = value; //also works for powerstate
        }
        if (to_flush)
            enterFlush(e->time, e->ic);
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
        uint8_t ok;
        atomic {
            ok = (m_state == S_IDLE);
        }
        if (!ok)
            return EBUSY;
        call EnergyMeter.reset();
        call EnergyMeter.start();
        enterRec();
        return SUCCESS;
    }

    //stop logging and start reporting
    command error_t QuantoLog.flush()
    {
        if (m_state == S_REC) {
            enterFlush(call Counter.get(), call EnergyMeter.read());
            return SUCCESS;
        }
        return EBUSY;
    }

    error_t logNextEntry() {
        entry_t *e;
        nx_entry_t *xe;
        memset(log_data_msg, 0, sizeof(quanto_log_msg_t));

        atomic {
            e = &log[report_index++];
        }
        xe = &log_data_msg->entry;

        xe->type   = e->type;
        xe->res_id = e->res_id;
        xe->time   = e->time;
        xe->ic     = e->ic;
        xe->act    = e->act;

        return call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len);
    }

    task void flush() {
        logNextEntry();
    }

    void logFlushInfo() {
        uint32_t dt = call Counter.get();
        uint32_t di = call EnergyMeter.read();
        uint16_t m;
        nx_entry_t *xe;
        
        atomic {
            dt -= m_t_flush;
            di -= m_i_flush;
            m   = m_missed_flush;
            report_index++; //important so that enterRec gets called
        } 

        memset(log_data_msg, 0, sizeof(quanto_log_msg_t));
    
        xe = &log_data_msg->entry;
        xe->type = TYPE_FLUSH_REPORT;
        xe->res_id = 0;
        xe->time = dt;
        xe->ic   = di;
        xe->event_count = m;
        
        //TODO: treat the case when send doesn't return SUCCESS
        call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len);
    }


    event void UARTSend.sendDone(message_t *msg, error_t error) {
        uint8_t c;
        if (msg != &uart_msg)
            return;
        atomic {
            if (report_index < count)
                c = 0;
            else if (report_index == count)
                c = 1;
            else 
                c = 2;
        }
        if (c == 0)
           post flush();
        else if (c == 1)
           logFlushInfo();
        else 
           enterRec();
    }

   
   async event void Counter.overflow() 
   {
   }

   default event void QuantoLog.full()
   {
   }
}
