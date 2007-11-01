#ifndef SENSORSCHEME_H
#define SENSORSCHEME_H

#include "Types.h"
#include "Macros.h"


typedef nx_struct SensorSchemeMsg {
  nx_uint8_t data[1];
} SensorSchemeMsg;

enum {
  AM_SENSORSCHEME_MSG = 7,
  CL_SENSORSCHEME_MSG = 8,
  COLLECTION_ROOTNODE = 0,
};

enum {
  QUEUE_SIZE = 2,
  POOL_SIZE = 2,
  SS_TICKS_PER_SECOND = 16,
};


enum entrypoint_t {
  SS_INIT,
  SS_RECEIVE,
  SS_STARTREAD,
  SS_SENDDONE,  
  SS_SENDLAST,
  SS_CONTINUE,
  SS_TIMER
} entrypoint_t;

/* the possible error values */
enum errorcode_t {
  ERROR_NULL,
  ERROR_NONE,
  ERROR_OUT_OF_MEMORY,
  ERROR_ILLEGAL_WRITE,
  ERROR_SYMBOL_NOT_FOUND,
  ERROR_TOO_FEW_ARGS,
  ERROR_TOO_MANY_ARGS,
  ERROR_ILLEGAL_CLOSURE,
  ERROR_NOT_CALLABLE,
  ERROR_UNKNOWN_PRIMTIIVE,
  ERROR_SYMBOL_NOT_BOUND,
  ERROR_PRIMITIVE_ARGUMENT_COUNT,
  ERROR_MESSAGE_FORMAT, 
  ERROR_ARG_NOT_PAIR,
  ERROR_ARG_NOT_SYMBOL,
  ERROR_ARG_NOT_NUMBER,
} errorcode_t;

typedef struct sub_send_t {
    uint8_t *(* const getPayload)(message_t *pkt);
    uint8_t *(* const getPayloadEnd)(message_t *pkt);
    am_addr_t(* const getDestination)(message_t *pkt);
    error_t  (* const send)(am_addr_t addr, message_t* pkt, uint8_t *dataEnd);
  } sub_send_t;

typedef struct sub_receive_t {
    uint8_t *(* const getPayload)(message_t *pkt);
  } sub_receive_t;

#define LABEL_LIST(_)  \
  _(OP_APPLY)          \
  _(OP_EXIT)           \
  _(OP_HANDLEMSG)      \
  _(OP_IF_CONT)        \
  _(OP_SET_CONT)       \
  _(OP_DEF_CONT)       \
  _(OP_ARGEVAL_CONT)   \
  _(OP_APPLY_CONT)     \
  _(RD_BITS_CONT)      \
  _(RD_WORD_CONT1)     \
  _(RD_WORD_CONT2)     \
  _(RD_DWORD_CONT1)    \
  _(RD_DWORD_CONT2)    \
  _(RD_SEXPR_CONT1)    \
  _(RD_LIST)           \
  _(RD_DOT)            \
  _(RD_SEXPR_SYM)      \
  _(RD_SEXPR_NUM)      \
  _(RD_SEXPR_NIBBLE1)  \
  _(RD_SEXPR_NIBBLE2)  \
  _(RD_SEXPR_BYTE)     \
  _(WR_NUMBER_NIBBLE1) \
  _(WR_NUMBER_NIBBLE2) \
  _(WR_NUMBER_BYTE)    \
  _(WR_NUMBER_WORD)    \
  _(WR_NUMBER_DWORD)   \
  _(WR_SEXPR_NIL)      \
  _(WR_SEXPR_SYM)      \
  _(WR_NUMBER)         \
  _(WR_SEXPR_LIST)     \
  _(WR_LIST)           \
  _(WR_LIST_DOT)       \
  _(WR_FINISH)         \

/* Symbol definitions */
#define SYM_LIST(_) \
    _(_NIL, 0)             \
    _(_TRUE, 0)            \
    _(_FALSE, 0)           \
/* read symbols */         \
    _(BRCLOSE, 0)          \
    _(DOT, 0)              \
/* the special forms */    \
    _(LAMBDA, 0)           \
    _(IF, 0)               \
    _(QUOTE, 0)            \
    _(DEFINE, 0)           \
    _(SET, 0)              \
    _(CLOSURE, 0)          \
    _(CONTINUATION, 0)     \
    _(PRIMITIVE, 0)        \
/* special case ID */      \
    _(ID, 0)               \


#define JUMP_SWITCH(name) case name: goto name;

#define SENDER_BOOT(name, pr)     call Sender.start[name]();
#define RECEIVER_BOOT(name, pr)   call Receiver.start[name]();

#define LABEL_ENUM(name)     name,
#define PRIM_ENUM(name, fn)     name,

  enum jumptarget_t {
    LABEL_LIST(LABEL_ENUM)
  } jumptarget_t;

  enum symbols {
    SYM_LIST(PRIM_ENUM)
    SIMPLE_PRIM_LIST(PRIM_ENUM)
    EVAL_PRIM_LIST(PRIM_ENUM)
    APPLY_PRIM_LIST(PRIM_ENUM)
    SEND_PRIM_LIST(PRIM_ENUM)
  } symbols_t;

  enum receivers{
    RECEIVER_LIST(PRIM_ENUM)
  } receivers_t;

#define COUNT_ITEMS(name, fn)   +1

#define NUM_SYMS            (0 SYM_LIST(COUNT_ITEMS)) 
#define NUM_SIMPLEPRIMS     (NUM_SYMS SIMPLE_PRIM_LIST(COUNT_ITEMS))
#define NUM_EVALPRIMS       (NUM_SIMPLEPRIMS EVAL_PRIM_LIST(COUNT_ITEMS))
#define NUM_APPLYPRIMS      (NUM_EVALPRIMS APPLY_PRIM_LIST(COUNT_ITEMS))
#define NUM_PRIMS           (NUM_APPLYPRIMS SEND_PRIM_LIST(COUNT_ITEMS))
#define FIRST_SEND_PRIM     (NUM_APPLYPRIMS)
#define LAST_PRIM           (NUM_PRIMS - 1)

#define LAST_LOCAL          (256-16)


#endif
