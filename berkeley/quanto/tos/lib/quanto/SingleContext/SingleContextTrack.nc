
#include "activity.h"

/** Authors: Rodrigo Fonseca and Jay Taneja */

interface SingleContextTrack {
    /** Event signaled when the context changes */
    async event void changed(act_t newActivity);


    /* CPU Only */

    /** Event signaled when the context changes by binding an
     *  old activity to a new activity */
    async event void bound(act_t newActivity);

    async event void enteredInterrupt(act_t newActivity);

    async event void exitedInterrupt(act_t newActivity);


}

