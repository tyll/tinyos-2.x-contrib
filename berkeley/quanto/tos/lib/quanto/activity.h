#ifndef _ACTIVITY_H
#define _ACTIVITY_H

/* act_t has two parts: a node and an  activity type. To save space,
 * we are using a single, 16-bit value to store both.  We'll use the
 * 10 msb to store the host and the 6 lsb to store the activity.
 * This will break if the node id is greater than 1024, or if the
 * activity is greater than 64. 
 */


typedef uint16_t act_t;
typedef uint8_t act_type_t;


enum {
    ACT_INVALID = 0xFFFF,

    ACT_NODE_MASK = 0x01FF,
    ACT_NODE_OFF  = 7,
    ACT_NODE_INVALID = 0x1FF,

    ACT_TYPE_MASK  = 0x007F,
    ACT_TYPE_OFF   = 0,
    ACT_TYPE_IDLE  = 0,
    ACT_TYPE_UNKNOWN = 0x7F,
    ACT_TYPE_QUANTO  = 0x7E,

    ACT_TYPE_QUANTO_WRITER = 0x77,
};

#if 0
#define mk_act_local(a) ( (act_t)(TOS_NODE_ID & ACT_NODE_MASK) << ACT_NODE_OFF |\
                                 ((a) & ACT_TYPE_MASK) << ACT_TYPE_OFF )

#endif
#ifndef MIG
inline act_t mk_act_local(act_type_t a) {
    return (act_t) ((TOS_NODE_ID & ACT_NODE_MASK) << ACT_NODE_OFF | 
                    (a & ACT_TYPE_MASK));
}
inline uint8_t is_idle(act_type_t a) {
    return (!(a & ACT_TYPE_MASK));
}
#endif
#endif

