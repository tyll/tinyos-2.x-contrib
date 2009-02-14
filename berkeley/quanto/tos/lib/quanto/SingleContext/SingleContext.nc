#include "activity.h"

/** Authors: Rodrigo Fonseca and Jay Taneja */

interface SingleContext {
    /** Returns the current context */
    async command act_t get();

    /** Sets the current context */
    async command void  set(act_t newActivity);

    /** Sets the current context with local node
     *  and activity type 'newAct' 
     */
    async command void  setLocal(act_type_t newAct);

    /** Sets the current context to unknown */
    async command void setUnknown();
    /** Sets the current context to invalid */
    async command void setInvalid();
    /** sets the current context to idle */
    async command void setIdle();

    /** Whether the current context is valid */
    async command bool  isValid();

    /****** These only really apply to the CPU  ***********/

    /** Indicates a change in context AND that the old context is
     *  to be bound to the new one. This means that the 
     *  accounting of the previous context is to be attributed to
     *  the new contex.
     *  
     */
    async command void bind(act_t newActivity);

    /** Called at the start of an interrupt handler.
     *  This works in a pair with exitInterrupt. Both functions
     *  assume that the handler will restore the old context
     *  before returning.
     *  This command MUST override the node part of newActivity with
     *  TOS_NODE_ID
     *
     *  @param newActivity the (proxy) context entered at the interrupt
     *                    handler. 
     *  @return the previous context to be restored later.
     */
    async command act_t enterInterrupt(act_t newActivity);

    /** Called before the end of an interrupt handler. If the
     *  restore activity is _idle_, this function doesn't register
     *  change. This is because the task loop will do so
     *  appropriately.
     *  @param restoreContext the old context to be restored after the
     *                        handler returns. This is kept as a stack
     *                        variable by the handler.
     */
    async command void   exitInterrupt(act_t restoreActivity);
    /** Forces an exitInterrupt returning the context to idle. 
     *  This should be called by the scheduler, on the first time
     *  after waking up from an interrupt.
     */
    async command void   exitInterruptIdle();

}

