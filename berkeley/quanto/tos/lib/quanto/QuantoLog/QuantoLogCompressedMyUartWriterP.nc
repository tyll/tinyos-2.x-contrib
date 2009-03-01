#include "RawUartMsg.h"
#include "msp430quantoconsts.h"
#include "QuantoLogCompressedMyUartWriter.h"

/* Define COUNT_LOG to log the sequential number of the event
 * to the log instead of the icount value */

/* This module receives each log event and stores msgs synchronously in
 * the buffer buf. When CBLOCKSIZE msgs are received, these are sent
 * as a block to the compress function, which will encode the msgs
 * in a compressed form into the BitBuffer comp_buf.
 * When the comp_buf is full, the block is sent to the UART writer,
 * which will write the bytes to the serial port.
 * When the UART writer is done, it will signal completion, and this
 * will clear the BitBuffer and the corresponding entries in the
 * main buffer, opening up space for new messages to be logged.
 */

module QuantoLogCompressedMyUartWriterP {
    uses {
        interface SingleContextTrack[uint8_t global_res_id];
        interface MultiContextTrack[uint8_t global_res_id];
        interface PowerStateTrack[uint8_t global_res_id];

        interface Counter<T32khz,uint32_t> as Counter;
        interface EnergyMeter;

        interface PortWriter;
        interface Boot;

        interface TaskQuanto as CompressTask;

        interface Init as WriterInit;
        interface SplitControl as WriterControl;
      
        interface BitBuffer;
        interface MoveToFront;
        interface EliasGamma;
    }
}
implementation {
    enum {S_STOPPED, S_STARTED};
#ifdef COUNT_LOG
    uint32_t count;
#endif
    static act_t m_act_idle;
    static act_t act_quanto_log;
   
    bitBuf* m_bitbuf;
    uint8_t* m_bitbuf_bytes;

    entry_t buf[BUFFERSIZE];
    uint8_t m_head; //remove from head
    uint8_t m_tail; //insert at tail
    uint8_t m_size;    

    uint8_t m_state = S_STOPPED;

    uint8_t s_masking_int = 0;
     
    inline uint8_t ignoreInterrupt(act_t act) {
        act_t a = act & ACT_TYPE_MASK;
        return (a == ACT_PXY_UART1TX);
    } 

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

        call MoveToFront.init();
        call BitBuffer.clear();
        m_bitbuf = call BitBuffer.getBuffer();
        m_bitbuf_bytes = call BitBuffer.getBytes();

        call WriterInit.init();
        call WriterControl.start();
    } 
    
    event void WriterControl.startDone(error_t result) {
        if (result != SUCCESS) {
            call WriterControl.start();
            return;
        }
        atomic m_state = S_STARTED;   
    }

    event void WriterControl.stopDone(error_t result) {
        atomic m_state = S_STOPPED;
    }
    
    inline void 
    recordChange(uint8_t id, uint16_t value, uint8_t type) {
        entry_t *e = NULL;
        uint8_t to_write = FALSE;
        if (m_state != S_STARTED) {
            return;
        }
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
                m_size++;
                m_tail = (m_tail + 1) % BUFFERSIZE;
                to_write = (m_size == CBLOCKSIZE);
            }
        } 
        if (to_write) 
            call CompressTask.postTask(act_quanto_log);
    }

    event void CompressTask.runTask() {
        //assumes BitBuffer is clear
        uint8_t i;
        uint8_t m;
        static uint32_t last_time = 0;
        static uint32_t last_ic = 0;
        entry_t* e;

        atomic {
            e = &buf[m_head];
        }
        
        call BitBuffer.clear();

        /* Place integer with size of block */
        call BitBuffer.putByte((uint8_t)CBLOCKSIZE);

        /* Encode type         (EG(MTF+1))*/
        call MoveToFront.init();
        for (i = 0; i < CBLOCKSIZE; i++) {
            call EliasGamma.encode16 (
                m_bitbuf,
                ((uint16_t)(call MoveToFront.encode(e[i].type))) + 1
            );
        } 
        /* Encode resource     (EG(MTF+1))*/
        call MoveToFront.init();
        for (i = 0; i < CBLOCKSIZE; i++) {
            call EliasGamma.encode16 (
                m_bitbuf,
                ((uint16_t)(call MoveToFront.encode(e[i].res_id))) + 1
            );
        } 
        /* Encode delta   time (EG(delta))*/
        for (i = 0; i < CBLOCKSIZE; i++) {
            call EliasGamma.encode32(m_bitbuf, e[i].time - last_time);
            last_time = e[i].time;
        }
        /* Encode delta icount (EG(delta + 1))*/
        for (i = 0; i < CBLOCKSIZE; i++) {
            call EliasGamma.encode32(m_bitbuf, e[i].ic - last_ic + 1);
            last_ic = e[i].ic;
        }
        /* Encode msb activity (EG(MTF+1))*/
        call MoveToFront.init();
        for (i = 0; i < CBLOCKSIZE; i++) {
            m = (uint8_t)((e[i].act >> 8) & 0xff);
            call EliasGamma.encode16 (
                m_bitbuf,
                ((uint16_t)(call MoveToFront.encode(m))) + 1
            );
        }
        /* Encode lsb activity (EG(MTF+1))*/
        call MoveToFront.init();
        for (i = 0; i < CBLOCKSIZE; i++) {
            m = (uint8_t)(e[i].act & 0xff);
            call EliasGamma.encode16 (
                m_bitbuf,
                ((uint16_t)(call MoveToFront.encode(m))) + 1
            );
        }
        call PortWriter.write(m_bitbuf_bytes, call BitBuffer.getNBytes());
    }

    event void PortWriter.writeDone(uint8_t* buffer, error_t result) {
       uint8_t to_write = FALSE;

       if (buffer == m_bitbuf_bytes) {
            atomic {
                m_head = (m_head + CBLOCKSIZE) % BUFFERSIZE;
                m_size -= CBLOCKSIZE;
                to_write = (m_size >= CBLOCKSIZE);
            } 
            if (to_write)
                call CompressTask.postTask(act_quanto_log);
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
        if (ignoreInterrupt(new_activity)) {
            atomic s_masking_int = 1;
        } else {
            recordChange(id, new_activity, TYPE_SINGLE_CHG_ENTER_INT);
        }
    }

    async event void 
    SingleContextTrack.exitedInterrupt[uint8_t id](act_t new_activity) 
    {
        atomic {
            if (s_masking_int) {
                s_masking_int = 0;
                return;
            }
        }
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

