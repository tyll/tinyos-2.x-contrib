#include "activity.h"
#include "MultiContext.h"

/* Proxy implementation. This module does not keep internal state
 * about the actual membership. All it does is relay the added and
 * removed states to the tracker module. */

module MultiContextImplP {
    provides {
        interface MultiContext[uint8_t res_id];
        interface MultiContextTrack[uint8_t res_id];
        interface Init;
    }
}
implementation {
    enum { NUM_RES = uniqueCount(MULTI_CONTEXT_UNIQUE) };

    command error_t Init.init() {
        int i;
        for ( i = 0; i < NUM_RES; i++) {
            signal MultiContextTrack.idle[i]();
        }       
        return SUCCESS;
    } 
   

    async command error_t
    MultiContext.add[uint8_t res_id](act_t activity)
    {
        signal MultiContextTrack.added[res_id](activity);
        return SUCCESS;
    }

    async command error_t
    MultiContext.remove[uint8_t res_id](act_t activity)
    {
        signal MultiContextTrack.removed[res_id](activity);
        return SUCCESS;
    }
    
    async command error_t
    MultiContext.setIdle[uint8_t res_id]()
    {
        signal MultiContextTrack.idle[res_id]();
        return SUCCESS;
    }

    default async event void
    MultiContextTrack.added[uint8_t res_id](act_t activity) {
    }

    default async event void
    MultiContextTrack.removed[uint8_t res_id](act_t activity) {
    }

    default async event void
    MultiContextTrack.idle[uint8_t res_id]() {
    }

}
