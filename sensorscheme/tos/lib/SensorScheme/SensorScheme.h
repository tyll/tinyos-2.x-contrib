#ifndef SENSORSCHEME_H
#define SENSORSCHEME_H

#include "Types.h"
#include "Macros.h"
#include "SensorSchemeMsg.h"

enum {
  AM_SSCOLLECT_MSG = 8,
  CL_SSCOLLECT_MSG = 9,
  CL_SSINTERCEPT_MSG = 10,
  COLLECTION_ROOTNODE = 0,
};

enum {
  POOL_SIZE = 8,
  ROOT_QUEUE_SIZE = 8,
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
  ERROR_MSG_ENDMARKER,
  ERROR_MSG_TERMINATION,
  ERROR_MSG_CONTENT_END,
} errorcode_t;

char const* error_str[] = {
	[ERROR_NULL] = "NULL error, should not occur",
	[ERROR_NONE] = "Terminated normally",
	[ERROR_OUT_OF_MEMORY] = "Out of memory!",
	[ERROR_ILLEGAL_WRITE] = "Illegal write",
	[ERROR_SYMBOL_NOT_FOUND] = "Symbol not found",
	[ERROR_TOO_FEW_ARGS] = "Too few arguments to closure",
	[ERROR_TOO_MANY_ARGS] = "Too many arguments to closure",
	[ERROR_ILLEGAL_CLOSURE] = "Illegal closure format",
	[ERROR_NOT_CALLABLE] = "calling an object that is not callable",
	[ERROR_UNKNOWN_PRIMTIIVE] = "Unknwn primitive",
	[ERROR_SYMBOL_NOT_BOUND] = "Symbol not bound",
	[ERROR_PRIMITIVE_ARGUMENT_COUNT] = "Wrong number of arguments to primitive",
	[ERROR_MESSAGE_FORMAT] = "Message format",
	[ERROR_ARG_NOT_PAIR] = "Argument is not a pair",
	[ERROR_ARG_NOT_SYMBOL] = "Argument is not a symbol",
	[ERROR_ARG_NOT_NUMBER] = "Argument is not a number",
	[ERROR_MSG_ENDMARKER] = "Message has no end marker",
	[ERROR_MSG_TERMINATION] = "Message not terminated properly",
	[ERROR_MSG_CONTENT_END] = "Message content not finished yet",
};

#define LABEL_LIST(_)  \
  _(OP_EXIT)           \
  _(OP_HANDLEMSG)      \
  _(OP_HANDLEINIT)     \
  _(OP_IF_CONT)        \
  _(OP_SET_CONT)       \
  _(OP_DEF_CONT)       \
  _(OP_ARGEVAL_CONT)   \
  _(OP_APPLY)          \
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
  _(RD_SYM_NIBBLE1)    \
  _(RD_SYM_NIBBLE2)    \
  _(RD_SYM_STRING)     \
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
    _(STRING, 0)          \
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

  enum receivers {
	  _dummy_receiver,
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

#define LAST_LOCAL          (256-8)


#endif
