#include "activity.h"
module ActivityTypeP {
    provides interface ActivityType;
}
implementation {
    inline async command uint16_t ActivityType.getNode(act_t *c) 
    {
        if (!c) return ACT_NODE_INVALID;
        return (*c >> ACT_NODE_OFF) & ACT_NODE_MASK;        
    }

    inline async command void ActivityType.setNode(act_t *c, uint16_t node) 
    {
        if (!c) return; 
        *c |= (node & ACT_NODE_MASK) << ACT_NODE_OFF;
    }

    inline async command uint8_t ActivityType.getActType(act_t *c) 
    {
        if (!c) return ACT_TYPE_UNKNOWN;
        return (*c >> ACT_TYPE_OFF) & ACT_TYPE_MASK;
    }

    inline async command void ActivityType.setActType(act_t *c, uint8_t act) 
    {
        if (!c) return;
        *c |= (act & ACT_TYPE_MASK) << ACT_TYPE_OFF;
    }

    inline async command void ActivityType.init(act_t *c) 
    {
        if (!c) return;
        call ActivityType.setNode(c, TOS_NODE_ID);
        call ActivityType.setActType(c, ACT_TYPE_UNKNOWN);
    }

    inline async command void ActivityType.initLocal(act_t *c, act_type_t a)
    {
        if (!c) return;
        call ActivityType.setNode(c, TOS_NODE_ID);
        call ActivityType.setActType(c, a);
    }

    inline async command void ActivityType.setInvalid(act_t *c)
    {
        if (!c) return;
        call ActivityType.setNode(c, ACT_NODE_INVALID);
        call ActivityType.setActType (c, ACT_TYPE_UNKNOWN);
    }

    inline async command void ActivityType.setUnknown(act_t *c)
    {
        if (!c) return;
        call ActivityType.init(c);
    }
    
    inline async command void ActivityType.setIdle(act_t *c)
    {
        if (!c) return;
        call ActivityType.setNode(c, TOS_NODE_ID);
        call ActivityType.setActType (c, ACT_TYPE_IDLE);   
    }

    inline async command bool ActivityType.isValid(act_t *c)
    {
        if (!c) return FALSE;
        return (call ActivityType.getNode(c) == 
                     ACT_NODE_INVALID)?
                     TRUE:FALSE;
    }
    
    inline async command bool ActivityType.isUnknown(act_t *c) 
    {
        if (!c) return TRUE;
        if (! call ActivityType.isValid(c)) return TRUE;
        return (call ActivityType.getActType(c) == 
                     ACT_TYPE_UNKNOWN)?
                     TRUE:FALSE;
    }

}
