#include "RawUartMsg.h"

module QuantoLogPortWriterP {
    uses {
        interface SingleContextTrack[uint8_t global_res_id];
        interface MultiContextTrack[uint8_t global_res_id];
        interface PowerStateTrack[uint8_t global_res_id];

        interface Counter<T32khz,uint32_t> as Counter;
        interface EnergyMeter;

        interface PortWriter;
        interface Boot;

        interface TaskQuanto as PrepareWriteTask;
    }
}
implementation {
    enum {
        BUFFERSIZE = 128,
    };

#ifdef COUNT_LOG
    uint32_t count;
#endif
    static act_t m_act_idle;
    static act_t act_quanto_log;
    
    nx_entry_t xe;
    entry_t* m_w_entry;

    entry_t buf[BUFFERSIZE];
    uint8_t m_head; //remove from head
    uint8_t m_tail; //insert at tail
    uint8_t m_size;    
      
    event void Boot.booted() {
        atomic {
            m_size = 0;
            m_head = 0;
            m_tail = 0;
            m_act_idle = mk_act_local(ACT_TYPE_IDLE);
            act_quanto_log = mk_act_local(ACT_TYPE_QUANTO_WRITER);
#ifdef COUNT_LOG
            count = 0;
#endif
        }
    } 
    
    inline void 
    recordChange(uint8_t id, uint16_t value, uint8_t type) {
        entry_t *e = NULL;
        uint8_t to_write = FALSE;
        atomic {
#ifdef COUNT_LOG
            count++;
#endif
            if (m_size < BUFFERSIZE) {
                e = &buf[m_tail];
            }
        }
        if (e != NULL) {

            e->time  = call Counter.get();
#ifndef COUNT_LOG
            e->ic    = call EnergyMeter.read();
#else
            e->ic = count;
#endif
            e->type = type;
            e->res_id = id;
            e->act  = value; //also works for powerstate

            atomic {
                m_tail = (m_tail + 1) % BUFFERSIZE;
                m_size++;
                if ((to_write = (m_size == 1))) {
                    m_w_entry = e;
                }
            }
        } 
        if (to_write) 
            call PrepareWriteTask.postTask(act_quanto_log);
            //call PortWriter.write((uint8_t*)e, sizeof(*e));
    }

    event void PrepareWriteTask.runTask() {
       entry_t* e;
       atomic e = m_w_entry;

       xe.type   = e->type;
       xe.res_id = e->res_id;
       xe.time   = e->time;
       xe.ic     = e->ic;
       xe.arg    = e->act;
        
       call PortWriter.write((uint8_t*)&xe, sizeof(xe));
 
    }

    event void PortWriter.writeDone(uint8_t* buffer, error_t result) {
       uint8_t to_write = FALSE;

       if (buffer == (uint8_t*)&xe) {
       //if (buffer == (uint8_t*)&buf[m_head]) {
            atomic {
                m_head = (m_head + 1) % BUFFERSIZE;
                m_size--;
                if ((to_write = (m_size > 0))) {
                   m_w_entry = &buf[m_head];
                }
            } 
            if (to_write)
                call PrepareWriteTask.postTask(act_quanto_log);
                //call PortWriter.write((uint8_t*)e, sizeof(*e));
       }
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

    async event void Counter.overflow() {}
}

