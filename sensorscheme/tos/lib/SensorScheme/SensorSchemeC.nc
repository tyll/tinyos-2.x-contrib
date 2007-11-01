/**
 * SensorSchemeC implements a program interpreter for WSNs
 *
 * @author Leon Evers
 * @version $Revision$ $Date$
 */

#include <setjmp.h>
#include <Message.h>
#include "SensorScheme.h"

module SensorSchemeC {
  uses {
    interface Boot;

    interface Pool<message_t>;
    interface Leds;
    interface Read<uint16_t> as ReadSensor;
    interface Timer<TMilli>;

    interface SSPrimitive as Primitive[uint8_t prim];
    interface SSPrimitive as Eval[uint8_t prim];
    interface SSPrimitive as Apply[uint8_t prim];
    interface SSSender as Sender[uint8_t prim];
    interface SSReceiver as Receiver[uint8_t prim];

  }
  provides interface SSRuntime;
}
implementation {
  message_t* receivePacket;

  uint8_t rcvRoutine;
  uint8_t* rcvData;
  uint8_t* rcvEnd;
  am_addr_t rcvAddr;

  message_t* sendPacket;
  uint8_t sndRoutine;
  uint8_t* sndData;
  uint8_t* sndEnd;
  am_addr_t sndAddr;

  uint8_t byteBuf[8];
  uint8_t byteBufIdx;
  uint8_t msgSeq;

  uint8_t bits;
  uint8_t bitCount;


  ss_val_t cons(ss_val_t a, ss_val_t b);
  void sensorSchemeEval(enum entrypoint_t entry);

  // sensorscheme global variables
  jmp_buf jmpEnv;
  // root set
  ss_val_t sendQueue;
  ss_val_t recvQueue;
  ss_val_t timerQueue;

  // execution registers
  ss_val_t envir;
  ss_val_t globalEnv;

#ifdef __MSP430__
  register ss_val_t args asm ("r4");
#else 
  ss_val_t args;
#endif 
#ifdef __MSP430__
  register ss_val_t value asm ("r5");
#else 
  ss_val_t value;
#endif 
#ifdef __MSP430__
  register ss_val_t stack asm ("r6");
#else 
  ss_val_t stack;
#endif 
#ifdef __MSP430__
  register ss_val_t freeCell asm ("r7");
#else 
  ss_val_t freeCell;
#endif 


  command ss_val_t SSRuntime.getArgs() {return args;}
  command void SSRuntime.setArgs(ss_val_t val) {args = val;}

  command ss_val_t SSRuntime.getValue() {return value;}
  command void SSRuntime.setValue(ss_val_t val) {value = val;}

  command ss_val_t SSRuntime.getStack() {return stack;}
  command void SSRuntime.setStack(ss_val_t val) {stack = val;}

  command ss_val_t SSRuntime.getEnvir() {return envir;}
  command void SSRuntime.setEnvir(ss_val_t val) {envir = val;}

  command ss_val_t SSRuntime.getTimerQueue() {return timerQueue;}
  command void SSRuntime.setTimerQueue(ss_val_t val) {timerQueue = val;}

  command void SSRuntime.error(int16_t v) {
    longjmp(jmpEnv, v);
  }


  event void Boot.booted() {
    SEND_PRIM_LIST(SENDER_BOOT)
    RECEIVER_LIST(RECEIVER_BOOT)

    // reset root set
    timerQueue = SYM_NIL;
    sendQueue = SYM_NIL;
    recvQueue = SYM_NIL;
    //  prepare for garbage collection
    freeCell.idx = CELLS_END;
    globalEnv = SYM_NIL;
    // read and execute init message
    rcvData = (uint8_t *)initMessage;
    rcvEnd = rcvData+initSize;
    sensorSchemeEval(SS_INIT);
  }

  event void ReadSensor.readDone(error_t error, uint16_t val) { }

  event void Sender.sendDone[uint8_t prim](message_t *msg, error_t error) {
    dbg("SensorSchemeC", "Send %u completed.\n", prim);
    sendPacket = msg;
    sndRoutine = prim;

    {
      // continue execution after message sent
      // confirmation of previous message
      ss_val_t oldQueue = SYM_NIL;
      ss_val_t tQueue = sendQueue;
      uint8_t *data = call Sender.getPayload[sndRoutine](sendPacket);
      sndData = data;
      sndEnd = call Sender.getPayloadEnd[sndRoutine](sendPacket);
      sndAddr = call Sender.getDestination[sndRoutine](sendPacket);
      while (!isNull(tQueue)) {
        ss_val_t qItem = car(tQueue); // get actual list item.
        dbg("SensorSchemeC", "checking sendQueue: %i, %u.\n", tQueue.idx, sendQItemRoutine(qItem));
        if (eqSeqNo(sendQItemSeq(qItem), data[0]) &&
            sendQItemRoutine(qItem) == sndRoutine) {
        if (isNull(oldQueue)) sendQueue = cdr(tQueue);
                     else cdr(oldQueue) = cdr(tQueue);
        dbg("SensorSchemeC", "Found sendQItem! 0x%hhx.\n", data[0]);
        if (error != SUCCESS) {
          stack = contStack(sendQItemCont(qItem));
          envir = contEnv(sendQItemCont(qItem));
          value = SYM_FALSE;
          sensorSchemeEval(SS_CONTINUE);
          return;
        }
          if (data[0] & MSGSEQ_END) {
            // last message done, return
            call Pool.put(sendPacket);
            dbg("SensorSchemeC", "put Pool item: 0x%x. new size: %hhu\n", sendPacket, call Pool.size());
          stack = contStack(sendQItemCont(qItem));
          envir = contEnv(sendQItemCont(qItem));
          value = SYM_TRUE;
          sensorSchemeEval(SS_CONTINUE);
          return;
          }

          //reset globals to start new message formation
          byteBufIdx = 0;
          bits = 0;
          bitCount = 4;
          sndData[0] = msgSeq = nextSeqNo(sendQItemSeq(qItem));
          sndData++;
          {
          ss_val_t b = sendQItemBytes(qItem);
          while (!isNull(b)) {
              *sndData = smallnumVal(car(b));
              sndData++;
              b = cdr(b);
          }}
          if (data[0] & MSGSEQ_END) {
            // just sending last bit of last message
            dbg("SensorSchemeC", "Last message: %hhu, %hhu.\n", msgSeq, data[0]);
          sensorSchemeEval(SS_SENDLAST);
          return;
          }
          dbg("SensorSchemeC", "Continuing with message %hhu.\n", msgSeq);
          args = (sendQItemArgs(qItem));
          stack = sendQItemStack(qItem);
          value = sendQItemCont(qItem);
          sensorSchemeEval(SS_SENDDONE);
          return;
        } else {
        // TODO: also check for correct message dest
          oldQueue = tQueue;
          tQueue = cdr(tQueue);
        }
      }
      // no continuation record found for this message
      return;
    }
  }

  task void receiveTask() {
    // handle received message
    dbg("SensorSchemeC", "Received %hhx of length %u from node %hu.\n", rcvData[0], rcvEnd-rcvData, rcvAddr);
    if (rcvData[0] & MSGSEQ_START) {
      //received start of chain
      sensorSchemeEval(SS_STARTREAD);
      return;
    } else {
      /* else next one in chain */
      ss_val_t oldQueue = SYM_NIL;
      ss_val_t tQueue = recvQueue;
      while (!isNull(tQueue)) {
        ss_val_t qItem = car(tQueue); // get actual list item.
        dbg("SensorSchemeC", "checking recvQueue %i: %hhu, %hu, %hu.\n",
            tQueue.idx, rcvQItemSeqNo(qItem), rcvQItemSrc(qItem), rcvQItemRoutine(qItem));
        if (eqSeqNo(rcvQItemSeqNo(qItem), rcvData[0]) &&
            rcvQItemSrc(qItem) == rcvAddr &&
            rcvQItemRoutine(qItem)  == rcvRoutine) {
          if (isNull(oldQueue)) recvQueue = cdr(tQueue);
                       else cdr(oldQueue) = cdr(tQueue);
          dbg("SensorSchemeC", "Found rcvQItem! 0x%hhx from %hu. packet:", rcvData[0], rcvAddr);
          {uint8_t *data = call Receiver.getPayload[rcvRoutine](receivePacket);
            for (; data < rcvEnd; data++) dbg_clear("SensorSchemeC", " %hhx", *data);}
          dbg_clear("SensorSchemeC", ".\n");
          bits = rcvQItemBits(qItem);
          bitCount = rcvQItemBitCount(qItem);
          stack = rcvQItemStack(qItem);
          rcvData++;
          sensorSchemeEval(SS_RECEIVE);
          return;
        } else {
          oldQueue = tQueue;
          tQueue = cdr(tQueue);
        }
      }
    }
    // no continuation found, ignore message
    return;
  }

  event message_t* Receiver.receive[uint8_t routine](message_t* msg, am_addr_t addr,
      uint8_t *data, uint8_t *end) {
    message_t* newMsg = call Pool.get();
    dbg("SensorSchemeC", "get Pool item: 0x%x. size left: %hhu\n", newMsg, call Pool.size());
    dbg("SensorSchemeC", "Received packet of length %hu.\n", end-data);
    if (newMsg == NULL) {
      return msg;
    }
    receivePacket = msg;
    rcvRoutine = routine;
    rcvData = data;
    rcvEnd = end;
    rcvAddr = addr;
    post receiveTask();
    return newMsg;
  }

  event void Timer.fired() {
    ss_val_t qItem;
    dbg("SensorSchemeC", "Timer.fired() at %i.\n", call Timer.getNow());
    // execute scheduled timer
    if (!isPair(timerQueue)) return;
    qItem = car(timerQueue);
    timerQueue = cdr(timerQueue);
    if (!isNull(timerQueue)) {
      call SSRuntime.startTimer(timerQItemTime(first(timerQueue)));
    }
    value = timerQItemThunk(qItem);
    envir = timerQItemEnvir(qItem);

    sensorSchemeEval(SS_TIMER);
  }

  command uint32_t SSRuntime.now() {
    return call Timer.getNow() / (1024 / SS_TICKS_PER_SECOND);
  }

  command void SSRuntime.startTimer(uint32_t t) {
    call Timer.startOneShotAt(t * (1024 / SS_TICKS_PER_SECOND), 0);
  }

  command ss_val_t SSRuntime.cons(ss_val_t a, ss_val_t b) {return cons(a, b);}

  command ss_val_t SSRuntime.makeNum(int32_t n) {
    if ((n >= 1<<12) || (n < (int16_t)-(1<<12))) {
      return makeBignum(n);
      } else {
      return makeSmallnum(n);
    }
  }

  command int32_t SSRuntime.numVal(ss_val_t c) {
    return (ss_type(c) == T_BIGNUM ?
        (int32_t)(cells(bignumIdx(c)).l.lval) :
        smallnumVal(c));
  }

  default command ss_val_t Primitive.eval[uint8_t pr](uint8_t prim) {
    dbg("SensorSchemeC", "default Primitive.eval.\n");
    do_error(ERROR_UNKNOWN_PRIMTIIVE);
    return SYM_FALSE;
  }

  default command ss_val_t Eval.eval[uint8_t pr](uint8_t prim) {
    dbg("SensorSchemeC", "default Eval.eval.\n");
    do_error(ERROR_UNKNOWN_PRIMTIIVE);
    return SYM_FALSE;
  }

  default command ss_val_t Apply.eval[uint8_t pr](uint8_t prim) {
    dbg("SensorSchemeC", "default Apply.eval.\n");
    do_error(ERROR_UNKNOWN_PRIMTIIVE);
    return SYM_FALSE;
  }

  default command error_t Sender.start[uint8_t prim]() {
    dbg("SensorSchemeC", "default Sender.start.\n");
    return FAIL;
  }

  default command ss_val_t Sender.eval[uint8_t prim](am_addr_t *addr) {
    dbg("SensorSchemeC", "default Sender.eval.\n");
    do_error(ERROR_UNKNOWN_PRIMTIIVE);
    return SYM_FALSE;
  }

  default command uint8_t *Sender.getPayload[uint8_t prim](message_t* pkt) {
    dbg("SensorSchemeC", "default Sender.getPayload %u.\n", prim);
    return 0;
  }

  default command uint8_t *Sender.getPayloadEnd[uint8_t prim](message_t* pkt) {
    dbg("SensorSchemeC", "default Sender.getPayloadEnd %u.\n", prim);
    return 0;
  }

  default command am_addr_t Sender.getDestination[uint8_t prim](message_t* pkt) {
    dbg("SensorSchemeC", "default Sender.getDestination.\n");
    return 0;
  }

  default command error_t Sender.send[uint8_t prim](am_addr_t addr, message_t* pkt, uint8_t *dataEnd) {
    dbg("SensorSchemeC", "default Sender.send.\n");
    return FAIL;
  }

  default command error_t Receiver.start[uint8_t prim]() {
    dbg("SensorSchemeC", "default Receiver.start.\n");
    return FAIL;
  }

  default command uint8_t *Receiver.getPayload[uint8_t prim](message_t* pkt) {
    dbg("SensorSchemeC", "default Sender.getPayload %u.\n", prim);
    return 0;
  }

/*
 * -------------- The sensorscheme core functions follow from here ---------------
 */


  ss_val_t reverse_m(ss_val_t list, ss_val_t res) {
    while (!isNull(list)) {
      ss_val_t temp = cdr(list);
      cdr(list) = res;
      res = list;
      list = temp;
    }
    return res;
  }

  void mark(ss_val_t a) {
    ss_val_t p;
    ss_val_t q = SYM_NIL;

MARK_UP:
    if (isPair(a))
      if (isFree(a) && !isPrimitive(a)) {
        p = car(a);
        car(a) = q;
        setUsed(a);
        q = a;
        a = p;
        goto MARK_UP;
      } else goto MARK_DOWN;
    else {
      if (ss_type(a) == T_BIGNUM) {
          setUsed(bignumIdx(a));
      }
      goto MARK_DOWN;
    }

MARK_DOWN:
    if (eq(q, SYM_NIL)) {
#ifdef TOSSIM
      uint16_t res = 0;
      for (freeCell.idx = CELLS_START; freeCell.idx < CELLS_END; incFree) {
        if (!isFree(freeCell)) {
          res = res+1;
        }
      }
      dbg_clear("SensorSchemeGC", "%hu, ", res);
#endif
      return;
    } else if isGC(q) {
      p = cdr(q);
      cdr(q) = a;
      clrGC(q);
      a = q;
      q = p;
      goto MARK_DOWN;
    } else {
      p = cdr(q);
      cdr(q) = car(q);
      car(q) = a;
      setGC(q);
      a = p;
      goto MARK_UP;
    }

  };

  inline ss_val_t fillAndIncCell(ss_val_t c, ss_val_t a, ss_val_t b) {   
    ss_val_t r = c;                
    car(c) = a;                    
    cdr(c) = b;                    
    incFree;    
    return r;                               
  }

  ss_val_t gc(ss_val_t a, ss_val_t b) {
    /* indicate garbage collection in progress */
    ss_val_t res;
    dbg("SensorSchemeGC", "<");
    call Leds.led2On();
    /* first free all cells */
    for (freeCell.idx = CELLS_START; freeCell.idx < CELLS_END; incFree) {
        setFree(freeCell);
    }

    /* then trace cells and mark used ones */
    mark(globalEnv);
    mark(timerQueue);
    mark(sendQueue);
    mark(recvQueue);
    mark(ss_args);
    mark(ss_value);
    mark(ss_stack);
    mark(ss_envir);
    mark(a);
    mark(b);
    dbg_clear("SensorSchemeGC", ">\n");

    /* finally return a new cell or panic when all is full */
    for (freeCell.idx = CELLS_START; freeCell.idx < CELLS_END; incFree) {
      if (isFree(freeCell)) {
        res = freeCell;
        car(freeCell) = a;                    
        cdr(freeCell) = b;                    
        incFree;    
        call Leds.led2Off();
        return res;
      }
    }
    // if reached here, all memory is full.
    // free up receive queue as last resort
    if (!isNull(recvQueue)) {
      res = recvQueue;
      recvQueue = SYM_NIL;
      call Leds.led2Off();
      return res;
    }
    // nothing more to do. time to panic !!
    longjmp(jmpEnv, ERROR_OUT_OF_MEMORY);
  }

/* cons: get new cell */
   inline ss_val_t cons(ss_val_t a, ss_val_t b) {
    ss_val_t res;
    do {
      if (isFree(freeCell)) {
        res = freeCell;
        car(freeCell) = a;                    
        cdr(freeCell) = b;                    
        incFree;    
        return res;
      }
      incFree;
    } while (freeCell.idx < CELLS_END);
    res = gc(a, b);
    return res;
  }

  inline void write_byte(uint8_t val) {
    dbg_clear("SensorSchemeWR", "[%hhu]", val);
    byteBuf[byteBufIdx++] = val;
  }

  inline void write_word(uint16_t val) {
    write_byte((uint8_t)val);
    write_byte(((uint16_t)val)>>8);
  }

  inline void write_dword(uint32_t val) {
    write_word((uint16_t)val);
    write_word((uint16_t)(val>>16));
  }


  void sensorSchemeEval(enum entrypoint_t entry) {
    int16_t ret = setjmp(jmpEnv);
    if (ret) {
      // longjmp called
      dbg("SensorSchemeC", "sensorScheme exits with code %hhu.\n", ret);
      return;
    }
    dbg("SensorSchemeC", "sensorScheme called on entrypoint %hhu.\n", entry);
    switch (entry) {
      case SS_INIT:
        do_call(OP_READMSG, SYM_NIL, OP_EXIT, SYM_NIL); break;
      case SS_RECEIVE:
        goto RD_BYTE; break;
      case SS_STARTREAD:
        do_call(OP_READMSG, ss_makeNum(rcvAddr), OP_EXIT, SYM_NIL);
      case SS_SENDDONE:
        goto WR_BITS; break;
      case SS_SENDLAST:
        goto WR_SEND_LAST; break;
      case SS_CONTINUE:
        goto OP_RETURN; break;
      case SS_TIMER:
        do_call(OP_APPLY, SYM_NIL, OP_EXIT, SYM_NIL); break;
    }
OP_RETURN: {
      // pop one item off the stack and return
      // stack is a list of pairs (return_label, args)
      ss_val_t x = car(stack);
      stack = cdr(stack);
      args = (cdr(x));

      switch ((enum jumptarget_t) (primVal(car(x)))) {
        LABEL_LIST(JUMP_SWITCH);
      }
    }
OP_READMSG:
    rcvData += 1;
    bitCount = 0;
    envir = SYM_NIL;
    dbg("SensorSchemeRD", "Reading message: ");
    do_call(RD_SEXPR, ss_args, OP_HANDLEMSG, ss_args);

OP_HANDLEMSG: {
    // handles message just parsed.
    // expects: message in ss_value,
    //          sender in ss_args
    dbg_clear("SensorSchemeRD", "\n");
    if (entry != SS_INIT) {
      call Pool.put(receivePacket);
      dbg("SensorSchemeC", "put Pool item: 0x%x. new size: %hhu\n", receivePacket, call Pool.size());
  }
//  C_symVal(C_car(ss_value)); /* Message needs to start with handler symbol. */
  do_call(OP_EVAL, car(ss_value), OP_APPLY, cons(ss_args, cdr(ss_value)));
}

OP_EVAL:
    if (isSymbol(ss_args)) {
      dbg("SensorSchemeC", "OP_EVAL symbol %hu.\n", symVal(ss_args));
      if (lteq(ss_args, SYM(LAST_PRIM))) {
        if (lt(ss_args, SYM(ID))) {
          do_return(ss_args);
        } else if (eq(ss_args, SYM(ID))) {
          do_return(ss_makeNum(TOS_NODE_ID));
        } else { // make primitive from symbol
          dbg("SensorSchemeC", "OP_EVAL primitive %hu.\n", symVal(ss_args));
          do_return(makePrimitive(symVal(ss_args)));
        }
      }
      else if (lteq(ss_args, SYM(LAST_LOCAL))) {
        /* defined symbol */
        ss_val_t x = globalEnv;
        dbg("SensorSchemeC", "OP_EVAL defined sym.\n");
        while (!isNull(x)) {
          if (eq(car(car(x)), ss_args)) {
            do_return(cdr(car(x)));
          }
          x = cdr(x);
        }
        do_error(ERROR_SYMBOL_NOT_FOUND); /* not found symbol. */
      } else {
        /* local var*/
        uint16_t n = symVal(ss_args);
        ss_val_t x = ss_envir;
        ss_val_t y = ss_envir;
        dbg("SensorSchemeC", "OP_EVAL local %%l%hhu.\n", 255-n);
        while (n < 256) {
          dbg("SensorSchemeC", "OP_EVAL local prepare x = 0x%hx.\n", x.idx);
          x = cdr(x);
          n++;
        }
        while (!isNull(x)) {
          dbg("SensorSchemeC", "OP_EVAL local return x = 0x%hx.\n", x.idx);
          x = cdr(x);
          y = cdr(y);
        }
        do_return(car(y));
      }
      do_error(ERROR_SYMBOL_NOT_FOUND); /* not found symbol. */

    } else if (isPair(ss_args)) {
      // function application or special form
      if (isSymbol(car(ss_args)) && lteq(car(ss_args), SYM(SET))) {
        // is internal function
        if (eq(car(ss_args), SYM(LAMBDA))) { /* called 1554 times */
          dbg("SensorSchemeC", "OP_EVAL lambda.\n");
          do_return(makeClosure(cdr(ss_args), ss_envir));
        } else if (eq(car(ss_args), SYM(IF))) { /* called 611 times */
          dbg("SensorSchemeC", "OP_EVAL if.\n");
          do_call(OP_EVAL, car(cdr(ss_args)), OP_IF_CONT, cons(cdr(cdr(ss_args)), ss_envir));
        } else if (eq(car(ss_args), SYM(SET))) { /* called 558 times */
          dbg("SensorSchemeC", "OP_EVAL set!.\n");
          do_call(OP_EVAL, car(cdr(cdr(ss_args))), OP_SET_CONT, cons(car(cdr(ss_args)), ss_envir));
        } else if (eq(car(ss_args), SYM(QUOTE))) { /* called 102 times */
          dbg("SensorSchemeC", "OP_EVAL quote.\n");
          do_return(car(cdr(ss_args)));
        } else if (eq(car(ss_args), SYM(DEFINE))) { /* called 1 time */
          dbg("SensorSchemeC", "OP_EVAL define.\n");
          do_call(OP_EVAL, car(cdr(cdr(ss_args))), OP_DEF_CONT, cons(cdr(ss_args), ss_envir));
        }
      }
      // first do eval head of list (function) then eval arguments
      dbg("SensorSchemeC", "OP_EVAL application %hi.\n", ss_args.idx);
      do_call(OP_EVAL, car(ss_args), OP_ARGEVAL_CONT, cons(cdr(ss_args), cons(SYM_NIL, ss_envir)));
    } else {
      do_return(ss_args);
    }

OP_APPLY:
{
    //FN_APPLY procedure to arguments
    // expects:
    //   procedure to apply in ss_value
    //   parameters in ss_args
    //   ss_stack, ss_envir as usual
    ss_val_t code;
    if (isPrimitive(ss_value)) {
      uint8_t prim = primVal(ss_value);
        dbg("SensorSchemeC", "OP_APPLY primitive %hi.\n", prim);
      if (prim < NUM_SIMPLEPRIMS) {
        do_return(call Primitive.eval[prim](prim));
      } else if (prim < NUM_EVALPRIMS) {
        args = call Eval.eval[prim](prim); 
        goto OP_EVAL;
      } else if (prim < NUM_APPLYPRIMS) {
        args = call Apply.eval[prim](prim);
        goto OP_APPLY;
      } else {
        sndRoutine = prim;
        args = call Sender.eval[prim](&sndAddr);
        goto WR_START;
      }
    } else if (isClosure(ss_value)) {
      ss_val_t cArgs = closureArgs(ss_value);
      dbg("SensorSchemeC", "OP_APPLY closure.\n");
      code = closureCode(ss_value);
      envir = closureEnv(ss_value);
      while (isPair(cArgs)) {
        ss_val_t t;
        do_assert(!isNull(ss_args), ERROR_TOO_FEW_ARGS); /* too few arguments */
        t = cdr(ss_args);
        cdr(ss_args) = ss_envir;
        envir = ss_args;
        cArgs = cdr(cArgs);
        args = (t);
      }
      do_assert(isNull(cArgs), ERROR_ILLEGAL_CLOSURE); /* syntax error in closure */
      do_assert(isNull(ss_args), ERROR_TOO_MANY_ARGS); /* too many arguments */

      if (isNull(code)) {
        //empty body. exit directly
        do_return(SYM_FALSE);
      }
      // start executing body of procedure
      if (!isNull(cdr(code))) {
        do_call(OP_EVAL, car(code), OP_APPLY_CONT, cons(cdr(code), ss_envir));
      } else {
        args = (car(code));
        goto OP_EVAL;
      }
    } else if (isContinuation(ss_value)) {
      dbg("SensorSchemeC", "OP_APPLY continuation.\n");
      callContinuation(ss_value, car(ss_args));
    } else {
      do_error(ERROR_NOT_CALLABLE); /* Cannot call this kind of function. */
    }

OP_APPLY_CONT:
    // reuse cell in ss_args
    envir = cdr(ss_args);
    code = car(ss_args);
    if (!isNull(cdr(code))) {
        car(ss_args) = cdr(code);
        cdr(ss_args) = ss_envir;
        do_call(OP_EVAL, car(code), OP_APPLY_CONT, ss_args);
    } else {
        args = (car(code));
        goto OP_EVAL;
    }
}
OP_SET_CONT:
{
    ss_val_t sym = car(ss_args);
    envir = cdr(ss_args);
    dbg("SensorSchemeC", "OP_SET continuation.\n");
    // assign local or global var.
    if (lteq(sym, SYM(LAST_LOCAL))) {
        /* else newly defined symbol */
        ss_val_t x = globalEnv;
        while (!isNull(x)) {
            if (eq(car(car(x)), sym)) {
                cdr(car(x)) = ss_value;
                do_return(SYM_FALSE);
            }
            x = cdr(x);
        }
    } else {
        /* else local variable */
        uint16_t n = symVal(sym);
        ss_val_t x = ss_envir;
        ss_val_t y = ss_envir;
        while (n < 256) {
            x = cdr(x);
            n++;
        }
        while (!isNull(x)) {
            x = cdr(x);
            y = cdr(y);
        }
        car(y) = ss_value;
        do_return(SYM_FALSE);
    }
    do_error(ERROR_SYMBOL_NOT_BOUND); /* Unbounded variable in set! */
}
OP_IF_CONT:
    // branch. ss_value is #F or something else. tail call into next expression
    {
    ss_val_t code = car(ss_args);
    envir = cdr(ss_args);

    if (!eq(ss_value, SYM_FALSE)) {
        args = (car(code));
    } else if (eq(cdr(code), SYM_NIL)) {
        args = (SYM_FALSE);
    } else {
        args = (car(cdr(code)));
    }
    goto OP_EVAL;
    }

OP_DEF_CONT: {
    // put ss_value inside global var in environment ss_envir, var symbol is in ss_args
    ss_val_t sym = car(car(ss_args));
    ss_val_t tail = cdr(cdr(car(ss_args)));
    ss_val_t t = globalEnv;
    envir = cdr(ss_args);
    C_symVal(sym); // check whether symbol is given
    dbg("SensorSchemeC", "OP_DEF_CONT %hu.\n", symVal(sym));
    while (!isNull(t)) {
        if (eq(sym, car(car(t)))) {
            cdr(car(t)) = ss_value;
            goto OP_DEF_CONT_POST;
        }
        t = cdr(t);
    }
    globalEnv = cons(cons(sym, ss_value), globalEnv);
OP_DEF_CONT_POST:
    if (isPair(tail) && isPair(cdr(tail))) {
      do_call(OP_EVAL, car(cdr(tail)), OP_DEF_CONT, cons(tail, ss_envir));
    } else {
      do_return(SYM_FALSE);
    }
}
OP_ARGEVAL_CONT:
    // evaluate arguments. builds list with procedure at end, then evaluated ss_args
    // expects:
    //    argument just evaluated in ss_value
    //    arguments still to evaluate in car(ss_args)
    //    arguments already evaluated in cdr(ss_args)
    //    ss_stack as usual
    // reuse the ss_args and cdr(ss_args) cells
{
    ss_val_t t = cdr(ss_args);
    ss_val_t code = car(ss_args);
    car(ss_args) = ss_value;
    envir = cdr(cdr(ss_args));
    cdr(ss_args) = car(cdr(ss_args));
    if (isPair(code)) {
        // do next arg, ss_args in code
        car(t) = cdr(code);
        cdr(t) = cons(ss_args, ss_envir);
        do_call(OP_EVAL, car(code), OP_ARGEVAL_CONT, t);
    } else {
        //done eval'ing ss_args, apply to procedure
        code = reverse_m(ss_args, SYM_NIL);
        value = car(code);
        args = (cdr(code));
        goto OP_APPLY;
    }
}

OP_EXIT:
    longjmp(jmpEnv, ERROR_NONE);

/* ---------------- reading part ---------------------------------- */

RD_BYTE:
    if (rcvEnd > rcvData) {
      ss_val_t res = makePrimitive(*rcvData);
      dbg_clear("SensorSchemeRD", "[%hhx]", *rcvData);
      rcvData++;
      do_return(res);
    } else {
      /* save the ss_stack, reuse when next message arrives */
      uint8_t *data = call Receiver.getPayload[rcvRoutine](receivePacket);
      ss_val_t itm = makeRcvQItem(rcvAddr, data[0], bits, bitCount, rcvRoutine);
      dbg_clear("SensorSchemeRD", "\n");dbg("SensorSchemeRD","End of packet read from %hu, seq: 0x%hhx, [%hx].\n", rcvAddr, data[0], ss_stack.idx);
      if (isNull(recvQueue)) {
        recvQueue = cons(itm, SYM_NIL);
        dbg("SensorSchemeRD", "set recvQueue to: %hu\n", recvQueue.idx);
      } else {
        ss_val_t tQueue = recvQueue;
        while (!isNull(cdr(tQueue))) {
          tQueue = cdr(tQueue);
        }
        cdr(tQueue) = cons(itm, SYM_NIL);
        dbg("SensorSchemeRD", "append recvQueue: %hu\n", cdr(tQueue).idx);
      }
      call Pool.put(receivePacket);
      dbg("SensorSchemeC", "put Pool item: 0x%x. new size: %hhu\n", receivePacket, call Pool.size());
      goto OP_EXIT;
    }

RD_BITS:
    if (bitCount == 0) {
      do_call(RD_BYTE, ss_args, RD_BITS_CONT, SYM_NIL);
    } else
RD_BITS_CONT2:
    {
      ss_val_t res = makeSymbol(bits & 0x03);
      bits >>= 2;
      bitCount--;
      do_return(res);
    }
RD_BITS_CONT:
    bits = primVal(ss_value);
    bitCount = 4;
    goto RD_BITS_CONT2;

RD_WORD:
    do_call(RD_BYTE, ss_args, RD_WORD_CONT1, SYM_NIL);

RD_WORD_CONT1:
    do_call(RD_BYTE, ss_args, RD_WORD_CONT2, makeSmallnum(primVal(ss_value)));

RD_WORD_CONT2: {
    int16_t num = (primVal(ss_value) << 8 | ss_numVal(ss_args));
    dbg_clear("SensorSchemeRD", "%hi", num);
    do_return(ss_makeNum(num));
  }

RD_DWORD:
    do_call(RD_WORD, ss_args, RD_DWORD_CONT1, SYM_NIL);

RD_DWORD_CONT1:
    do_call(RD_WORD, ss_args, RD_DWORD_CONT2, ss_value);

RD_DWORD_CONT2: {
    int32_t num = ss_numVal(ss_value) << 16 | (ss_numVal(ss_args) & 0xffff);
    dbg_clear("SensorSchemeRD", "%i", num);
    do_return(ss_makeNum(num));
  }

RD_SEXPR:
    // processes message string to form sexpr
    // expects message in rcvData,
    //         current index in idx
    //         length of message
    do_call(RD_BITS, ss_args, RD_SEXPR_CONT1, SYM_NIL);
RD_SEXPR_CONT1:
    if (eq(ss_value, TOK_BROPEN)) {
        dbg_clear("SensorSchemeRD", "(");
        do_call(RD_SEXPR, ss_args, RD_LIST, SYM_NIL);
        do_return(ss_value);
    } else if (eq(ss_value, TOK_BRCLOSE)) {
        do_return(SYM(BRCLOSE));
    } else if (eq(ss_value, TOK_SYM)) {
        do_call(RD_BYTE, ss_args, RD_SEXPR_SYM, SYM_NIL);
    } else /*if (eq(ss_value, TOK_NUM))*/ {
        do_call(RD_BITS, ss_args, RD_SEXPR_NUM, SYM_NIL);
    }

RD_SEXPR_SYM:
    dbg_clear("SensorSchemeRD", "s%hi", primVal(ss_value));
    do_return(makeSymbol(primVal(ss_value)));

RD_SEXPR_NUM:
    if (eq(ss_value, TOK_NIBBLE)) {
        do_call(RD_BITS, ss_args, RD_SEXPR_NIBBLE1, SYM_NIL);
    } else if (eq(ss_value, TOK_BYTE)) {
        do_call(RD_BYTE, ss_args, RD_SEXPR_BYTE, SYM_NIL);
    } else if (eq(ss_value, TOK_WORD)) {
        goto RD_WORD;
    } else /*if (eq(ss_value, TOK_DWORD))*/ {
        goto RD_DWORD;
    }

RD_SEXPR_NIBBLE1:
    dbg_clear("SensorSchemeRD", "!<%hhu:", symVal(ss_value));
    do_call(RD_BITS, ss_args, RD_SEXPR_NIBBLE2, ss_value);
RD_SEXPR_NIBBLE2: {
    int8_t num = symVal(ss_args) << 2 | symVal(ss_value);
    dbg_clear("SensorSchemeRD", "%hhu>! ", symVal(ss_value));
    dbg_clear("SensorSchemeRD", "%hhi", num);
    do_return(makeSmallnum(num));
  }

RD_SEXPR_BYTE:
    dbg_clear("SensorSchemeRD", "%hhi", primVal(ss_value));
    do_return(makeSmallnum(primVal(ss_value)));


RD_LIST:
    // parses list items
    // expects: list item just read in ss_value
    //          previously read items in ss_args
    //          message in rcvData
    if (eq(ss_value, SYM(BRCLOSE))) {
        dbg_clear("SensorSchemeRD", ")");
        do_return(reverse_m(ss_args, SYM_NIL));
    } else if (eq(ss_value, SYM(DOT))) {
        dbg_clear("SensorSchemeRD", " . ");
        do_call(RD_SEXPR, ss_args, RD_DOT, ss_args);
    } else {
        dbg_clear("SensorSchemeRD", " ");
        do_call(RD_SEXPR, ss_args, RD_LIST, cons(ss_value, ss_args));
    }

RD_DOT:
    // parses dotted pair, last item of list
    // expects: cdr of pair just read in ss_value
    //          previously read items in ss_args
    //          message in rcvData
    do_return(reverse_m(ss_args, ss_value));


/* ---------------- writing part ---------------------------------- */

/*
 * WR_START sends messages. it expects :
 * sndRdoutine: send routine id#
 * sndAddr: destination address
 * ss_args: message
 * ss_stack, ss_envir as usual
 * returns #t or #f in ss_value
 */
WR_START: {
    sendPacket = call Pool.get();
    dbg("SensorSchemeC", "get Pool item: 0x%x. size left: %hhu\n", sendPacket, call Pool.size());
    if (!sendPacket) {
      dbg("SensorSchemeC", "WR_START: no packet in pool.\n");
      do_return(SYM_FALSE); // sending didn't succeed, just fail returning FALSE. TODO: make robust!!
    }
    sndData = call Sender.getPayload[sndRoutine](sendPacket);
    sndEnd = call Sender.getPayloadEnd[sndRoutine](sendPacket);
    sndData[0] = msgSeq = newSeqNo(msgSeq);
    sndData++;
    byteBufIdx = 0;
    bits = 0;
    bitCount = 4;
    value = makeContinuation(ss_stack, ss_envir);
    stack = SYM_NIL;
    do_call(WR_SEXPR, ss_args, WR_FINISH, SYM_NIL);
  }

WR_SEXPR:
    if (isSymbol(ss_args)) {
      if (isNull(ss_args)) {
        dbg_clear("SensorSchemeWR", "()");
        do_call(WR_BITS, TOK_BROPEN, WR_SEXPR_NIL, ss_args);
WR_SEXPR_NIL:
        args = (TOK_BRCLOSE);
        goto WR_BITS;
      } else {
        do_call(WR_BITS, TOK_SYM, WR_SEXPR_SYM, ss_args);
WR_SEXPR_SYM:
        dbg_clear("SensorSchemeWR", "s%hu", symVal(ss_args));
        write_byte(symVal(ss_args));
      }
      do_return(ss_value);
    } else if (isNumber(ss_args)) {
      do_call(WR_BITS, TOK_NUM, WR_NUMBER, ss_args);
    } else if (isPair(ss_args)) {
      do_assert(!(isPrimitive(ss_args) || isClosure(ss_args) || isContinuation(ss_args)),
              ERROR_ILLEGAL_WRITE); /* Should not send or print this type of object */
      dbg_clear("SensorSchemeWR", "(");
      do_call(WR_BITS, TOK_BROPEN, WR_SEXPR_LIST, ss_args);
WR_SEXPR_LIST:
        do_call(WR_SEXPR, car(ss_args), WR_LIST, cdr(ss_args));
    }

WR_NUMBER: {
    int32_t nval = ss_numVal(ss_args);
    dbg_clear("SensorSchemeWR", "%i", nval);
    if ((nval >= 0) && (nval < 16)) {
      do_call(WR_BITS, TOK_NIBBLE, WR_NUMBER_NIBBLE1, ss_args);
    } else if ((nval >= -(1<<7)) && (nval < (1<<7))) {
      do_call(WR_BITS, TOK_BYTE, WR_NUMBER_BYTE, ss_args);
    } else if ((nval >= -(1L<<15)) && (nval < (1L<<15))) {
      do_call(WR_BITS, TOK_WORD, WR_NUMBER_WORD, ss_args);
    } else {
      do_call(WR_BITS, TOK_DWORD, WR_NUMBER_DWORD, ss_args);
    }
WR_NUMBER_NIBBLE1:
      do_call(WR_BITS, makeSymbol(ss_numVal(ss_args)>>2), WR_NUMBER_NIBBLE2, ss_args);
WR_NUMBER_NIBBLE2:
      args = (makeSymbol(ss_numVal(ss_args) & 3));
      goto WR_BITS;
WR_NUMBER_BYTE:
      write_byte((uint8_t) smallnumVal(ss_args));
      goto WR_NUMBER_END;
WR_NUMBER_WORD:
      write_word((uint16_t) ss_numVal(ss_args));
      goto WR_NUMBER_END;
WR_NUMBER_DWORD:
      write_dword(ss_numVal(ss_args));
      goto WR_NUMBER_END;
WR_NUMBER_END:
    do_return(ss_value);
  }

WR_LIST:
    if (isNull(ss_args)) {
        dbg_clear("SensorSchemeWR", ")");
        args = (TOK_BRCLOSE);
        goto WR_BITS;
    } else {
        if (isPair(ss_args)) {
            dbg_clear("SensorSchemeWR", " ");
            do_call(WR_SEXPR, car(ss_args), WR_LIST, cdr(ss_args));
        } else {
            do_call(WR_BITS, TOK_SYM, WR_LIST_DOT, ss_args);
        }
    }
WR_LIST_DOT:
    dbg_clear("SensorSchemeWR", " . ");
    write_byte(symVal(SYM(DOT)));
    goto WR_SEXPR;

WR_FINISH: {
    // last packet of message.
    // send it, and continue
    dbg_clear("SensorSchemeWR", "\nEnd of message.");
    msgSeq |= MSGSEQ_END; // this will make WR_SEND detect it is the last packet
    if (bitCount > 0) {
      while (bitCount > 0) {
        bits >>= 2;
        bitCount--;
      }
    }
    goto WR_SEND;
  }

WR_BITS: {
    dbg_clear("SensorSchemeWR", "<%hu>", symVal(ss_args));
    if (bitCount == 0) {
      if (sndData+byteBufIdx+1 >= sndEnd) {
WR_SEND: {
        /* write away current buffer */
        ss_val_t b = SYM_NIL;
        uint8_t rest = 0;
        if (sndData >= sndEnd) {
          b = cons(makeSmallnum(bits), b);
        } else {
          *sndData = bits;
          sndData++;
          rest = min(sndEnd - sndData, byteBufIdx);
          {uint8_t i; for (i = 0; i < rest; i++) sndData[i] = byteBuf[i];}
          //memmove(sndData, byteBuf, rest);
          sndData += rest;
        }
        dbg_clear("SensorSchemeWR", "\nPacket full. left over: {");
        while (byteBufIdx > rest) {
          byteBufIdx--;
          dbg_clear("SensorSchemeWR", "%hhx ",byteBuf[byteBufIdx]);
          b = cons(makeSmallnum(byteBuf[byteBufIdx]), b);
        }
        if (msgSeq & MSGSEQ_END && eq(b,SYM_NIL)) // really last packet
            (call Sender.getPayload[sndRoutine](sendPacket))[0] = msgSeq;
        dbg_clear("SensorSchemeWR", "}\n");
WR_SEND_LAST:
        dbg_clear("SensorSchemeWR", "Packet :");
        {uint8_t *data = call Sender.getPayload[sndRoutine](sendPacket);
          for (; data < sndData; data++) dbg_clear("SensorSchemeWR", " %hhx",*data);
          dbg_clear("SensorSchemeWR", "\n");}
        switch (call Sender.send[sndRoutine](sndAddr, sendPacket, sndData)) {
          case SUCCESS: {
          /* store current continuation in queue */
            sendQueue = cons(makeSendQItem(msgSeq, b, sndRoutine), sendQueue);
            //dbg("SensorSchemeWR", "send SUCCESS\n");
            goto OP_EXIT;
          }
          case EBUSY: {
            /* TODO: change it to retry transmission
               for now just fall-through to FAIL */
            dbg("SensorSchemeWR", "send EBUSY\n");
          }
          case FAIL: {
            /* Continuation already in 'ss_value' */
            dbg("SensorSchemeWR", "send FAIL\n");
            callContinuation(ss_value, SYM_FALSE);
          }
        }
      }}
      *sndData = bits;
      sndData++;
      {uint8_t i; for (i = 0; i < byteBufIdx; i++) sndData[i] = byteBuf[i];}
      //memmove(sndData, byteBuf, byteBufIdx);
      sndData+=byteBufIdx;
      byteBufIdx = 0;
      bits = 0;
      bitCount = 4;
    }
    bits >>= 2;
    bits |= (symVal(ss_args) << 6);
    bitCount--;
    do_return(ss_value);
  } //WR_BITS

  } // end of sensorSchemeEval
} // end of module
