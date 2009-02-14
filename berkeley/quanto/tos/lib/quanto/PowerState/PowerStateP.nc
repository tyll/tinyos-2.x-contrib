#include "PowerState.h"

module PowerStateP {
    provides {
        interface PowerState[uint8_t local_res_id];
        interface PowerStateTrack[uint8_t local_res_id];
        interface Init;
    } 
}
implementation {
    enum { NUM_RES = uniqueCount(POWER_STATE_UNIQUE) };

    powerstate_t m_state[NUM_RES];

    command error_t Init.init() {
        int i;
        for (i = 0; i < NUM_RES; i++) {
            m_state[i] = 0;
        }
        return SUCCESS;
    } 

    inline async command void 
    PowerState.set[uint8_t id](powerstate_t value) 
    {
        int chg;
        atomic {
            chg = (value != m_state[id]);
            m_state[id] = value;
        }
        if (chg)
            signal PowerStateTrack.changed[id](value);
    }

    inline async command void
    PowerState.setBits[uint8_t id](powerstate_t mask, uint8_t offset, powerstate_t value)
    {
       powerstate_t new_value;
       atomic {
        new_value = (m_state[id] & ~mask) | ((value << offset) & mask);  
       }
       call PowerState.set[id](new_value);
    }

    inline async command void
    PowerState.unsetBits[uint8_t id](powerstate_t mask)
    {
        powerstate_t new_value;
        atomic {
          new_value = (m_state[id] & ~mask);
        }
        call PowerState.set[id](new_value);
    }        

    inline async command void
    PowerState.setBit[uint8_t id](uint8_t bit)
    {
        powerstate_t new_value;
        atomic {
          new_value = (m_state[id] | (1 << bit));
        }
        call PowerState.set[id](new_value);
    }        

    inline async command void
    PowerState.unsetBit[uint8_t id](uint8_t bit)
    {
        powerstate_t new_value;
        atomic {
            new_value = (m_state[id] & ~(1 << bit));
        }
        call PowerState.set[id](new_value);
    }        

    default async event void
    PowerStateTrack.changed[uint8_t id](powerstate_t s) { }
}
