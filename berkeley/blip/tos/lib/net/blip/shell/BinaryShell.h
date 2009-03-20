#ifndef BINARYSHELL_H_
#define BINARYSHELL_H_

#define BINARY_SHELL

/* Struct definitions for builtin shell commands */

/* type ids for the builtin commands  */
enum  {
  BSHELL_ERROR = 0,
  BSHELL_ENUMERATE = 1,
  BSHELL_ECHO = 2,
  BSHELL_PING6 = 3,
  BSHELL_PING6_REPLY = 4,
  BSHELL_PING6_DONE = 5,
  BSHELL_UPTIME = 6,
  BSHELL_IDENT = 7,
  BSHELL_NWPROG = 8,
};
  

nx_struct cmd_payload {
  nx_uint16_t id;
  nx_uint8_t  data[0];
};

enum {
  BSHELL_ERROR_NOTFOUND = 0,
};
nx_struct bshell_error {
  nx_uint16_t code;
};

nx_struct bshell_enumerate {
  nx_uint16_t cmdlist[0];
};

nx_struct bshell_echo {
  nx_uint8_t data[0];
};

nx_struct bshell_ping6 {
  nx_uint16_t cnt;
  nx_uint16_t dt;
  nx_uint8_t  addr[16];
};

nx_struct bshell_ping6_reply {
  nx_uint8_t addr[16];
  nx_uint16_t seqno;
  nx_uint16_t dt;
  nx_uint8_t ttl;
};

nx_struct bshell_ping6_done {
  nx_uint16_t sent;
  nx_uint16_t received;
};

nx_struct bshell_uptime {
  nx_uint32_t uptime_hi;
  nx_uint32_t uptime_lo;
};

nx_struct bshell_ident {
  nx_uint8_t appname[16];
  nx_uint8_t username[16];
  nx_uint8_t hostname[16];
  nx_uint32_t timestamp;
};


#endif
