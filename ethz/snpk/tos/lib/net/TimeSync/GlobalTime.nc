/*
 * Modified from the TinyOS 1.x GlobalTime interface introduced by Vanderbilt University
 */

interface GlobalTime
{
    /**
     * Returns the current local time of this mote. 
     */

    async command uint32_t getLocalTime();

    /**
     * Reads the current global time. 
     * @return SUCCESS if this mote is synchronized, FAIL otherwise.
     */

    async command error_t getGlobalTime(uint32_t *time);

    /**
     * Converts the global time to the correspoding local time 
     *
     * @return SUCCESS if this mote is synchronized, FAIL otherwise.
     */

    async command error_t global2Local(uint32_t *time);

    /**
     * This event is triggered when the mote is synchronized
     *
     */

    event void synced();

}
