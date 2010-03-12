/*
  Messages understood by TReact.

  Since these messages are ONLY transfered between the Python TReact
  driver and an external application the message size is restricted
  only by the size that the serial-forward protocol can handle. As
  such, assuming a fixed 10 bytes for AM overhead, 245 bytes are
  available for payload.
 */

#include "AM.h"

enum {
  AM_REACT = 239,
  AM_REACT_BASE = AM_REACT,
  /* These are AM_* to make MIG happy and have a standard accessor in
     the generated classes. However, since (if) they are encoded into
     React messages, they will never be used as real AM-types. */
  AM_REACT_CMD_BASE = 200,
  AM_REACT_WATCH,
  AM_REACT_BIND_WATCH_BASE,
  AM_REACT_NODE_INFO,
  AM_REACT_REPLY,
  AM_REACT_LINK,
  AM_REACT_PROBE,
  AM_TIME_EVENT
};

/*
  Other react messages are packed int react_base. This has some
  advantages 1) using only one AM id which reduces potential conflicts
  2) being able to easily split other messages up over several packets
  3) having a unified tracking system.
*/
enum {
  MAX_REACT_PAYLOAD = 240,
};
nx_struct react_base {
  /* Tracking ID. This can be specified during encoding and retrieved
     during decoding. The use is application-specific. */
  nx_uint16_t track_id;
  /* AM-type of encoded messages. 0 signifies that this message
     contains more data belonging to an earlier message. */
  nx_am_id_t type;
  /* Total length of remaining data. This may exceed MAX_REACT_PAYLOAD
     which means that data is encoded into futures react messages as
     well. */
  nx_uint16_t remaining;
  nx_uint8_t payload_start_byte;
};

typedef nx_uint16_t nx_var_id_t;

/*
  Used to transfer commands from React to Act environment.
*/
nx_struct react_cmd_base {
  nx_uint8_t type;
  nx_int8_t ve_start_byte;
};

/*
  Text-based replies.
*/
enum {
  /* outcome of command/request */
  RESULT_SUCCESS = 0, /* request completely accepted */
  RESULT_FAILURE,     /* request rejected */
  RESULT_PARTIAL,     /* request partially accepted */
  RESULT_UNSOLICITED, /* reply not in response to particular request */
  /* refinements */
  REFINE_NORMAL = 1,
  REFINE_INFO,
  REFINE_WARN,
  REFINE_ERROR,
  REFINE_FATAL,
  REFINE_DEBUG
};

nx_struct react_reply {
  nx_uint8_t status;
  /* \0 separated entries. The first byte of each entry represents the
     refinemnet type. Thus, it is possible to send multiple RELATED
     replies at the same time. The contents of each entry itself is
     not defined. */
  nx_int8_t ve_start_byte;
};

/*
  Reply: new or existing watched variable binding.
*/
nx_struct react_bind_watch_base {
  nx_am_addr_t node;
  nx_var_id_t var_id;
  nx_uint8_t var_type;
  /* encoded varname \0 watchexpr */
  nx_int8_t ve_start_byte;
};

/*
  Reply: watched value.
*/
nx_struct react_watch {
  /*
    ID associated with value; this is established when the monitor is
    first setup.
  */
  nx_var_id_t var_id;
  nx_int8_t ve_start_byte;
};

/*
  Message sent when a change in data is detected. The payload is the
  literal data of the data. It is up the reciever to correctly decode
  it.
 */
nx_struct react_probe {
  nx_var_id_t binding;
  nx_am_addr_t mote;
  nx_int8_t ve_start_byte;
};

/*
  Information pertaining to topology. This is a crummy named.
*/
enum { // for status below
  /* is node on? */
  NODE_ON = 0x01,      // bit-mask, 1st bit
  /* node not configured or in an invalid configuration */
  NODE_INVALID = 0x02, // bit-mask, 2nd bit
  /* node position or power changed but topology is not updated */
  NODE_STALE = 0x04    // bit-mask, 3rd bit
};
nx_struct react_node_info {
  nx_am_addr_t id;
  nx_uint8_t status; // see enum above
  nx_int32_t x;      // position, x,y in in cm
  nx_int32_t y;
  nx_int8_t txpower; // gain @ 0
  nx_int8_t pld0;    // gain @ pld0
};

enum {
  INVALID_LINK = 127, // Link is invalid and should be removed
  IGNORE_LINK = 126   // Ignore this link-gain value (e.g. set only one way)
};
nx_struct react_link {
  nx_am_addr_t node1;
  nx_am_addr_t node2;
  // Link-gain in dBm or INVALID_LINK/IGNORE_LINK
  nx_int8_t gain1to2;
  nx_int8_t gain2to1;
};

enum {
  EVT_RUNNING = 0,
  EVT_STOPPED,
  EVT_RESUMED
};

nx_struct time_event {
  nx_uint16_t event_type;
  /* sim-time (64-bits) */
  nx_uint32_t timeH;
  nx_uint32_t timeL;
};
