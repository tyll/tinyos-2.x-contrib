#include "nprintf2.h"
/** Simple module that logs context changes.
 *  It logs in response to Context.changed events into a 
 *  memory array and dumps them to the UART using the
 *  Debug interface. 
 */
module QuantoLogP {
    uses {
        interface SingleContextTrack[uint8_t global_res_id];
        interface MultiContextTrack[uint8_t global_res_id];
        interface Debug;
        interface Leds;
        interface Timer<TMilli> as ReportTimer;
        //interface LocalTime<TMilli> as LocalTime;
        interface Counter<T32khz,uint32_t> as Counter;
    }
    provides {
        interface QuantoLog;
    }
}
implementation {
    uint32_t count;
    uint16_t report_index, total_reports;

    typedef nx_struct {
        nx_uint32_t time;
        nx_uint8_t res_id;
        nx_uint8_t type;
        nx_uint16_t old_c;
        nx_uint16_t new_c;
    } entry_t;

    enum {LOGSIZE = 800};
    enum {
        TYPE_NORMAL = 1,
        TYPE_ENTER_INT = 2,
        TYPE_EXIT_INT = 3,
        TYPE_BIND = 4,
        TYPE_M_ADD = 5,
        TYPE_M_REM = 6,
        TYPE_M_IDL = 7,
    };

    entry_t log[LOGSIZE];

    char dbgmessage[50];
    
    enum {S_IDLE = 0, S_REC, S_REP_LOG};
    uint8_t state = S_IDLE;

    void initState() {
        count = 0;
        report_index = 0;
        total_reports = 0;
        state = S_IDLE;
    }

    inline void 
    recordChange(uint8_t id, act_t old_context, act_t new_context, uint8_t type) 
    {
        entry_t *e = NULL;
        if (state != S_REC)
            return;
        //call Leds.led1Toggle();
        atomic {
            if (count < LOGSIZE) {
                e = &log[count]; 
            }
            count++;
        }
        if (e) {
            e->time  = call Counter.get();
            e->res_id = id;
            e->old_c = old_context;
            e->new_c = new_context;
            e->type = type;
        }
    }

    async event void 
    SingleContextTrack.changed[uint8_t id](act_t old_context, act_t new_context) 
    {
        recordChange(id, old_context, new_context, TYPE_NORMAL);
    }

    async event void 
    SingleContextTrack.bound[uint8_t id](act_t old_context, act_t new_context) 
    {
        recordChange(id, old_context, new_context, TYPE_BIND);
    }

    async event void 
    SingleContextTrack.enteredInterrupt[uint8_t id](act_t old_context, act_t new_context) 
    {
        recordChange(id, old_context, new_context, TYPE_ENTER_INT);
    }

    async event void 
    SingleContextTrack.exitedInterrupt[uint8_t id](act_t old_context, act_t new_context) 
    {
        recordChange(id, old_context, new_context, TYPE_EXIT_INT);
    }
   
    async event void
    MultiContextTrack.added[uint8_t id](act_t context)
    {
        recordChange(id, 0, context, TYPE_M_ADD);
    }

    async event void
    MultiContextTrack.removed[uint8_t id](act_t context)
    {
        recordChange(id, 0, context, TYPE_M_REM);
    }

    async event void
    MultiContextTrack.idle[uint8_t id]()
    {
        recordChange(id, 0, 0, TYPE_M_IDL);
    }


    command error_t QuantoLog.record() {
        if (state != S_IDLE)
            return EBUSY;
        state = S_REC;
        return SUCCESS;
    }

    //stop logging and start reporting
    command error_t QuantoLog.flush() {
        uint32_t c;

        if (state != S_REC) 
            return EBUSY;
        atomic {
            c = count;
            count = 0;
        }
        total_reports = (c > LOGSIZE)?LOGSIZE:c;
        report_index = 0;
        state = S_REP_LOG;
#ifdef TOSSIM
        dbg("QuantoLogger", "%d ctx changes", c);
#else
        call Debug.sendDbg("");
        call Debug.sendDbg(nprintf2(dbgmessage, "%u ctx changes", c));
        call ReportTimer.startPeriodic(1500);
#endif
        return SUCCESS;
    }

    event void ReportTimer.fired() {
       call Leds.led1Toggle();
       if (state == S_REP_LOG) {
            if (report_index < total_reports) {
#ifdef TOSSIM
                 dbg("QuantoLogger", "[%d] %d %d %d -> %d\n", 
                      report_index, 
                      log[report_index].time,
                      log[report_index].res_id,
                      log[report_index].old_c, 
                      log[report_index].new_c);
#else 
                 call Debug.sendDbg(nprintf2(dbgmessage, "%u:%u %lu>%lu %u %lu ", 
                      report_index, 
                      log[report_index].res_id,
                      log[report_index].old_c, 
                      log[report_index].new_c,
                      log[report_index].type,
                      log[report_index].time));
#endif
                 report_index = report_index + 1;
            } else {
                 call ReportTimer.stop();
                 initState();
            }
       }
   } 

   async event void Counter.overflow() 
   {
   }
}
