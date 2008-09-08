
/* Interface for a Resource that can have 0 or more activities
 * associated with it at any given time. Contrast this with
 * SingleContext, which is for resources that can only have
 * 0 or 1 activities associated at any time. */

interface MultiContext {
    async command error_t add(act_t activity);
    async command error_t remove(act_t activity);
    async command error_t setIdle();


    /** Total number of contexts added */
    //command uint8_t count();
    /** Is context added ? */
    //command bool isAdded(act_t context);
}


