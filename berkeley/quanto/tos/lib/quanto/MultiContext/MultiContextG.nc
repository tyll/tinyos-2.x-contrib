/* mapping between global and local id spaces */
/* see MultiContextC for wiring */

module MultiContextG {
    provides interface MultiContext[uint8_t id];
    provides interface MultiContextTrack[uint8_t id];
    uses interface MultiContext as MultiContextLocal[uint8_t id];
    uses interface MultiContextTrack as MultiContextTrackLocal[uint8_t id];
}
implementation {
    async command error_t
    MultiContext.add[uint8_t id](act_t activity)
    {
        return call MultiContextLocal.add[id](activity);
    }

    async command error_t
    MultiContext.remove[uint8_t id](act_t activity)
    {
        return call MultiContextLocal.remove[id](activity);
    }

    async command error_t
    MultiContext.setIdle[uint8_t id]()
    {
        return call MultiContextLocal.setIdle[id]();
    }
    
    async event void
    MultiContextTrackLocal.added[uint8_t id](act_t activity)
    {
        signal MultiContextTrack.added[id](activity);
    }
    
    async event void
    MultiContextTrackLocal.removed[uint8_t id](act_t activity)
    {
        signal MultiContextTrack.removed[id](activity);
    }

    async event void
    MultiContextTrackLocal.idle[uint8_t id]()
    {
        signal MultiContextTrack.idle[id]();
    }
    
    /* Default impl for unconnected parameters */
    default async command error_t  
    MultiContextLocal.add[uint8_t id](act_t activity) {
       return FAIL; 
    }

    default async command error_t
    MultiContextLocal.remove[uint8_t id](act_t activity) {
        return FAIL;
    }

    default async command error_t
    MultiContextLocal.setIdle[uint8_t id]() {
        return FAIL;
    }

    default async event void
    MultiContextTrack.added[uint8_t id](act_t activity) {
    }
        
    default async event void
    MultiContextTrack.removed[uint8_t id](act_t activity) {
    }
        
    default async event void
    MultiContextTrack.idle[uint8_t id]() {
    }
}
