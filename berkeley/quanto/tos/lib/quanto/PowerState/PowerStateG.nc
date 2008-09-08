#include "PowerState.h"
/* mapping between global and local id spaces */
/* @see PowerStateC for wiring */

module PowerStateG {
    provides interface PowerState[uint8_t id];
    provides interface PowerStateTrack[uint8_t id];
    uses interface PowerState as PowerStateLocal[uint8_t id];
    uses interface PowerStateTrack as PowerStateTrackLocal[uint8_t id];
}
implementation {

    inline async command void
    PowerState.set[uint8_t id](powerstate_t value)
    {
        call PowerStateLocal.set[id](value);
    }

    inline async command void
    PowerState.setBits[uint8_t id](powerstate_t mask, uint8_t offset, powerstate_t value)
    {
        call PowerStateLocal.setBits[id](mask, offset, value);
    }

    inline async command void
    PowerState.unsetBits[uint8_t id](powerstate_t value)
    {
        call PowerStateLocal.unsetBits[id](value);
    }

    inline async command void
    PowerState.setBit[uint8_t id](uint8_t bit)
    {
        call PowerStateLocal.setBit[id](bit);
    }

    inline async command void
    PowerState.unsetBit[uint8_t id](uint8_t bit)
    {
        call PowerStateLocal.unsetBit[id](bit);
    }

    inline async event void
    PowerStateTrackLocal.changed[uint8_t id](powerstate_t value) 
    {
        signal PowerStateTrack.changed[id](value);
    }

    default async command void
    PowerStateLocal.set[uint8_t id](powerstate_t value) {}

    default async command void
    PowerStateLocal.setBits[uint8_t id](powerstate_t mask, uint8_t offset, powerstate_t value) {}
    
    default async command void
    PowerStateLocal.unsetBits[uint8_t id](powerstate_t value) {}

    default async command void
    PowerStateLocal.setBit[uint8_t id](uint8_t bit) {}

    default async command void
    PowerStateLocal.unsetBit[uint8_t id](uint8_t bit) {}

    default async event void
    PowerStateTrack.changed[uint8_t id](powerstate_t value) {}
}

