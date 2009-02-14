/* mapping between global and local id spaces */
/* @see SingleContextC for wiring */

module SingleContextG {
    provides interface SingleContext[uint8_t id];
    provides interface SingleContextTrack[uint8_t id];
    uses interface SingleContext as SingleContextLocal[uint8_t id];
    uses interface SingleContextTrack as SingleContextTrackLocal[uint8_t id];
}
implementation {
    inline async command act_t 
    SingleContext.get[uint8_t id]() 
    {
        return call SingleContextLocal.get[id]();
    }

    inline async command void  
    SingleContext.set[uint8_t id](act_t newActivity) 
    {
        call SingleContextLocal.set[id](newActivity);
    }

    inline async command void  
    SingleContext.setLocal[uint8_t id](act_type_t newAct) 
    {
        call SingleContextLocal.setLocal[id](newAct);
    }

    inline async command void  
    SingleContext.setUnknown[uint8_t id]() 
    {
        call SingleContextLocal.setUnknown[id]();
    }

    inline async command void  
    SingleContext.setInvalid[uint8_t id]() 
    {
        call SingleContextLocal.setInvalid[id]();
    }

    inline async command void  
    SingleContext.setIdle[uint8_t id]() 
    {
        call SingleContextLocal.setIdle[id]();
    }

    inline async command bool 
    SingleContext.isValid[uint8_t id]() 
    {
        return call SingleContextLocal.isValid[id]();
    }

    inline async command void SingleContext.bind[uint8_t id](act_t newActivity)
    {
        return call SingleContextLocal.bind[id](newActivity);
    }

    inline async command act_t SingleContext.enterInterrupt[uint8_t id](act_t newActivity)
    {
        return call SingleContextLocal.enterInterrupt[id](newActivity);
    }

    inline async command void SingleContext.exitInterrupt[uint8_t id](act_t restoreContext)  
    {
        call SingleContextLocal.exitInterrupt[id](restoreContext);
    }

    inline async command void SingleContext.exitInterruptIdle[uint8_t id]()  
    {
        call SingleContextLocal.exitInterruptIdle[id]();
    }



    /* SingleContextTrack */

    inline async event void 
    SingleContextTrackLocal.changed[uint8_t id](act_t newActivity) 
    {
        signal SingleContextTrack.changed[id](newActivity);
    }

    inline async event void 
    SingleContextTrackLocal.bound[uint8_t id](act_t newActivity) 
    {
        signal SingleContextTrack.bound[id](newActivity);
    }

    inline async event void
    SingleContextTrackLocal.enteredInterrupt[uint8_t id](act_t newActivity)
    {
        signal SingleContextTrack.enteredInterrupt[id](newActivity);
    }

    inline async event void
    SingleContextTrackLocal.exitedInterrupt[uint8_t id](act_t newActivity)
    {
        signal SingleContextTrack.exitedInterrupt[id](newActivity);
    }

    //default implementations for unconnected parameters

    default async command act_t SingleContextLocal.get[uint8_t id]() {
        return ACT_INVALID;
    }

    default async command void SingleContextLocal.set[uint8_t id](act_t context) {
    }

    default async command void SingleContextLocal.setLocal[uint8_t id](act_type_t newAct) {
    }

    default async command void SingleContextLocal.setUnknown[uint8_t id]() {
    }

    default async command void SingleContextLocal.setInvalid[uint8_t id]() {
    }

    default async command void SingleContextLocal.setIdle[uint8_t id]() {
    }

    default async command bool 
    SingleContextLocal.isValid[uint8_t id]() {
        return FALSE;
    }

    default async command void
    SingleContextLocal.bind[uint8_t id](act_t n) 
    {
    }

    default async command act_t 
    SingleContextLocal.enterInterrupt[uint8_t id](act_t newActivity) {
        return ACT_INVALID;
    }

    default async command void
    SingleContextLocal.exitInterrupt[uint8_t id](act_t restoreContext) {
    }

    default async command void
    SingleContextLocal.exitInterruptIdle[uint8_t id]() {
    }

    /* SingleContextTrack */
    default async event void 
    SingleContextTrack.changed[uint8_t id](act_t newActivity) {
    }

    default async event void 
    SingleContextTrack.bound[uint8_t id](act_t newActivity) {
    }

    default async event void 
    SingleContextTrack.enteredInterrupt[uint8_t id](act_t newActivity) {
    }

    default async event void 
    SingleContextTrack.exitedInterrupt[uint8_t id](act_t newActivity) {
    }

}

