#include "activity.h"

/* Interface for manipulating activity_t variables */

interface ActivityType {
    /* Returns the node part of c, or ACT_NODE_INVALID if c is NULL */
    async command uint16_t getNode(act_t *c);

    /* Sets the node part of c to node. */
    async command void setNode(act_t *c, uint16_t node);

    /* Returns the activity_type part of c, or ACT_TYPE_UNKNOWN if c is NULL */
    async command uint8_t getActType(act_t *c);

    /* Sets the activity_type part of c to act */
    async command void setActType(act_t *c, uint8_t act);

    /* Initializes the activity_t. 
     * Sets node to TOS_NODE_ID and activity to ACT_TYPE_UNKNOWN 
     */
    async command void init(act_t *c);

    /* Initializes the activity to the local node and given activity.
     */
    async command void initLocal(act_t *c, act_type_t a);

    /* Sets the c to invalid. 
     * Sets node to ACT_NODE_INVALID and activity to ACT_TYPE_UNKNOWN.
     * A call to isValid after clear MUST return FALSE 
     */
    async command void setInvalid(act_t *c);

    /* Sets the context activity to unknown, and the node to
     * the current node 
     */
    async command void setUnknown(act_t *c);
    
    /* Sets the context activity to idle, and the node to the
     * current node 
     */
    async command void setIdle(act_t *c);

    /* Checks whether the context is valid. 
     * A context is invalid if the node part is set to ACT_NODE_INVALID
     * and should not be interpreted.
     */
    async command bool isValid(act_t *c);

    /* Checks whether the context's activity is unknown. This is different
     * from invalid and means that the activity hasn't been specified.
     * The context is meaningful, however, across nodes.
     * Returns true is the context is invalid.
     */
    async command bool isUnknown(act_t *c);
}
