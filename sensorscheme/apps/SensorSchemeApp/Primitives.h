/* builtin primitive functions defined here. */
#define SIMPLE_PRIM_LIST(_) \
  _(DEFINEDP, DefinedPrim) \
  \
  _(CAR, CarPrim) \
  _(CDR, CdrPrim) \
  _(SET_CAR, SetCarPrim) \
  _(SET_CDR, SetCdrPrim) \
  _(CONS, ConsPrim) \
  \
  _(ADD, ArithPrim) \
  _(SUB, ArithPrim) \
  _(MULT, ArithPrim) \
  _(DIV, ArithPrim) \
  _(MOD, ArithPrim) \
  _(BITWISE_IOR, ArithPrim) \
  _(BITWISE_AND, ArithPrim) \
  _(BITWISE_XOR, ArithPrim) \
  \
  _(GT, LogicPrim) \
  _(GTE, LogicPrim) \
  _(LT, LogicPrim) \
  _(LTE, LogicPrim) \
  _(EQ, EqPrim) \
  \
  _(NULLP, TypePrim) \
  _(PAIRP, TypePrim) \
  _(SYMBOLP, TypePrim) \
  _(NUMBERP, TypePrim) \
  _(BOOLEANP, TypePrim) \
  \
  _(BITWISE_NOT, BitwiseNotPrim) \
  _(NOT, NotPrim) \
  _(RAND, RandPrim) \
  _(NOW, NowPrim) \
  \
  _(CALL_AT_TIME, CallAtTimePrim) \
  _(SENSOR, SensorPrim) \
  _(BLINK, BlinkPrim) \
  \
  _(APPEND, AppendPrim) \
  _(LIST, ListPrim) \

#define EVAL_PRIM_LIST(_) \
  _(EVAL, EvalPrim) \
  _(EVAL_HANDLER, EvalHandlerPrim) \

#define APPLY_PRIM_LIST(_) \
  _(APPLY, ApplyPrim) \
  _(CALL_CC, CallCCPrim) \
  _(BCAST, BcastPrim) \

#define SEND_PRIM_LIST(_) \
  _(SEND_LOCAL, AMSender) \
  _(SEND_SERIAL, SerialSender) \

#define RECEIVER_LIST(_) \
  _(RECV_LOCAL, AMReceiver) \
  _(RECV_SERIAL, SerialReceiver) \

