/** Simple module that logs activity changes.
 *  It logs in response to Context.changed events into a 
 *  memory array and dumps them to the UART using the
 *  Debug interface. 
 */

/* Implements a producer-consumer buffer. 
 * Care has to be taken to not log context changes
 * created by recording a context change. Normally,
 * writing to the UART alone will generate two changes
 * per byte. */

#include "RawUartMsg.h"
module QuantoLogContinuousUARTP {
    provides {
        interface QuantoLog;
    }
    uses {
        interface SingleContextTrack[uint8_t global_res_id];
        interface MultiContextTrack[uint8_t global_res_id];
        interface PowerStateTrack[uint8_t global_res_id];
        interface Leds;
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
    enum {BUFFERSIZE = 20};

    enum {STARTING, LOGGING, STOPPING, STOPPED};

    entry_t buffer[BUFFERSIZE];

    message_t uart_msg;
    quanto_log_msg_t* log_data_msg; //Initially one entry per uart msg

    uint8_t m_head;  //position of next write
    uint8_t m_tail;  //position of  dump 
    uint8_t m_count; //number of elements

    uint16_t statFull;
    uint16_t statSendFailed;
    uint16_t statSendDoneFailed;

    uint16_t m_q_icnt;  //icounts spent logging
    uint16_t m_q_time;//time spent logging

    norace static act_t m_act_idle;
    
    uint8_t len;

    uint8_t m_sending;
    uint8_t m_dump_posted;
    uint8_t m_state;

    void initState() {
        atomic {
            m_head = m_tail = m_count = 0;
            m_sending = 0;
            m_dump_posted = 0;
            m_q_icnt = 0;
            m_q_time = 0; 

            statFull = 0;
            statSendFailed = 0;
            statSendDoneFailed = 0;
        }
    }

   task void dump();

   inline void
   recordChange(uint8_t id, uint16_t value, uint8_t type) 
   {
       entry_t *e = NULL;
       uint8_t to_post = 0;
       atomic {
          if (m_count == BUFFERSIZE) {
            statFull++;
            call Leds.led0Toggle();
          } else {
            e = &buffer[m_head];
            e->time  = call Counter.get();
            e->ic    = call EnergyMeter.read();
            e->type = type;
            e->res_id = id;
            e->act  = value; //also works for powerstate
            m_head = (m_head + 1) % BUFFERSIZE;
            m_count++;
            if (! m_dump_posted) {
                to_post = 1;
                m_dump_posted = 1;
            }
          }
       }
       if (to_post) 
         post dump();
   }

    /* schedule the write of one entry to the UART */
    task void dump() {
        entry_t *e;
        nx_entry_t *xe;
        if (m_state == STOPPING || m_state == STOPPED)
            return;
        memset(log_data_msg, 0, sizeof(quanto_log_msg_t));
        atomic {
            m_dump_posted = 0;
            e = &buffer[m_tail];
            xe = &log_data_msg->entry;

            xe->type   = e->type;
            xe->res_id = e->res_id;
            xe->time   = e->time;
            xe->ic     = e->ic;
            xe->arg    = e->act;

            if (call UARTSend.send(AM_BROADCAST_ADDR, &uart_msg, len) == SUCCESS) {
               m_sending = 1;
            } else { 
                statSendFailed++;
                m_dump_posted = 1;
                post dump();
            }
        }
    }
   
    event void UARTSend.sendDone(message_t *msg, error_t status) {
       atomic {
            m_sending = 0;
            if (status == SUCCESS) {
                m_tail++;
                m_count--;
            } else {
                statSendDoneFailed++;
            }
            if (m_count > 0 && !m_dump_posted) {
                m_dump_posted = 1;
                post dump();
            }
       } 
    } 



    event void
    Boot.booted() {
        m_act_idle = mk_act_local(ACT_TYPE_IDLE);
        call SerialControl.start();
        len = sizeof(quanto_log_msg_t);
        log_data_msg = call UARTSend.getPayload(&uart_msg, len);
        m_state = STOPPED;
        //initState();   
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
        if (m_state == STARTING || m_state == LOGGING)
            return SUCCESS;
        if (m_state == STOPPING)
            return EBUSY;
        m_state = STARTING;
        call SerialControl.start();
        call EnergyMeter.reset();
        call EnergyMeter.start();
        return SUCCESS;
    }
 
	event void SerialControl.startDone(error_t error) {
		if (error != SUCCESS) {
			call SerialControl.start();
		} else {    
            m_state = LOGGING;
            initState();
        }
	}

    command error_t QuantoLog.flush() {
        if (m_state == STARTING)
            return EBUSY;
        if (m_state == STOPPING || m_state == STOPPED)
            return SUCCESS;
        call SerialControl.stop();
        call EnergyMeter.pause();
        m_state = STOPPING;
        return SUCCESS;
    } 

	event void SerialControl.stopDone(error_t error) {
        m_state = STOPPED;
	}
   


   async event void Counter.overflow() {}

   default event void QuantoLog.full() {}
}
