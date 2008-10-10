#ifndef MACROS_H
#define MACROS_H

/**
 * Macros.h: defines macros that are used as functions inside the SSeval function, but cannot be 
 * defined as functions because they jump to labels.
 */

/*-- auxillary functions that need to be implemented as macro --*/

#define incFree (freeCell.idx += sizeof(ss_cell_t))

#define min(a, b)   ((a) < (b) ? (a) : (b))

#define first(c)    car(c)
#define second(c)   first (cdr(c))
#define third(c)    second(cdr(c))
#define fourth(c)   third (cdr(c))
#define rest(c)     cdr(c)
              
/*-- auxillary functions to handle evaluation functions --*/

#define do_call(a, b, c, d) ({                    \
  stack = cons(cons(makePrimitive(c), d), stack); \
  args = b;                                       \
  goto a;                                         \
  })


#define do_return(v) ({                           \
  value = v;                                      \
  goto OP_RETURN;                                 \
  })

//#define do_retbool(b) do_return(b ? SYM_TRUE : SYM_FALSE)


/* error detection and handling macros */

#define do_assert(p, v)                           \
    if (!(p)) do_error(v)

#define do_error(v) ({                          \
    dbgerror("SensorSchemeC", "error %hu in %s line %u\n", v, __FILE__, __LINE__); \
    call SSRuntime.error(v);})


// checked versions of standard cell operations
#define assertPair(c)   do_assert(isPair(c), ERROR_ARG_NOT_PAIR) 
#define assertSymbol(c) do_assert(isSymbol(c), ERROR_ARG_NOT_SYMBOL) 
#define assertNumber(c) do_assert(isNumber(c), ERROR_ARG_NOT_NUMBER)

#define C_car(c)  ({assertPair(c); car(c);})
#define C_cdr(c)  ({assertPair(c); cdr(c);})

#define C_symVal(c)  ({assertSymbol(c); symVal(c);})
//#define C_numVal(c)  ({assertNumber(c); ss_numVal(c);})

#define C_first(c)    C_car(c)
#define C_second(c)   C_first(C_cdr(c))
#define C_third(c)    C_second(C_cdr(c))
#define C_fourth(c)   C_third(C_cdr(c))
#define C_rest(c)     C_cdr(c)

/* -------- some shortcuts for common SSRuntime operations ------------ */

#define arg_1              (call SSRuntime.ckArg1())
#define arg_2              (call SSRuntime.ckArg2())

#define ss_args           (call SSRuntime.getArgs())
#define ss_value          (call SSRuntime.getValue())
#define ss_envir          (call SSRuntime.getEnvir())
#define ss_stack          (call SSRuntime.getStack())

#define ss_set_args(n)    (call SSRuntime.setArgs(n))
#define ss_set_value(n)   (call SSRuntime.setValue(n))
#define ss_set_envir(n)   (call SSRuntime.setEnvir(n))
#define ss_set_stack(n)   (call SSRuntime.setStack(n))

#define ss_timerQueue     (call SSRuntime.getTimerQueue())
#define ss_set_timerQueue(n) (call SSRuntime.setTimerQueue(n))

#define ss_cons(a, b)     (call SSRuntime.cons(a, b))

#define ss_makeNum(n)     (call SSRuntime.makeNum(n))
#define ss_numVal(c)      (call SSRuntime.numVal(c))
#define C_numVal(c)       (call SSRuntime.ckNumVal(c))

/* ---------------- reading and writing tokens ----------------------- */

#define TOK_SYM                 makeSymbol(0x00)
#define TOK_NUM                 makeSymbol(0x01)
#define TOK_BROPEN              makeSymbol(0x02)
#define TOK_BRCLOSE             makeSymbol(0x03)
                                
#define TOK_NIBBLE              TOK_SYM
#define TOK_BYTE                TOK_NUM
#define TOK_WORD                TOK_BROPEN
#define TOK_DWORD               TOK_BRCLOSE
                                
/* ---------------- various 'structure' constructors and accessors ----------------------- */

#define MSGSEQ_START        (1<<7)
#define MSGSEQ_END          (MSGSEQ_START >> 1)
#define MSGSEQ_NUMMASK      (~(MSGSEQ_START | MSGSEQ_END))


#define nextSeqNo(n)            (((n + 1) & MSGSEQ_NUMMASK) | ((n) & MSGSEQ_END))
#define newSeqNo(n)             ((nextSeqNo(n) & (~MSGSEQ_END))| MSGSEQ_START)
#define eqSeqNo(a, b)           ((a & MSGSEQ_NUMMASK) == (b & MSGSEQ_NUMMASK))


#define makeRcvQItem(tm, src, seq, b, bc, rt)  cons(ss_makeNum(call SSRuntime.now() + tm), \
                                cons(ss_makeNum(src), \
                                cons(makeSmallnum(nextSeqNo(seq)), \
                                cons(makeSmallnum(rt << 10 | b << 2 | bc), ss_stack))))
#define rcvQItemTime(q)         ss_numVal(first(q))
#define rcvQItemSrc(q)          (am_addr_t)ss_numVal(second(q))
#define rcvQItemSeqNo(q)        (ss_numVal(third(q)) & 0xff)
#define rcvQItemBits(q)         (uint8_t)(smallnumVal(fourth(q)) >> 2)
#define rcvQItemBitCount(q)     (smallnumVal(fourth(q)) & 3)
#define rcvQItemRoutine(q)      (smallnumVal(fourth(q)) >> 10)
#define rcvQItemStack(q)        cdr(cdr(cdr(cdr(q))))

#define makeSendQItem(seq, b, rt) ss_cons(makeSmallnum(seq | (rt - FIRST_SEND_PRIM) << 8), \
                                ss_cons(b, ss_cons(ss_args, ss_cons(ss_stack, ss_value))))
#define sendQItemSeq(q)         (uint8_t)smallnumVal(first(q))
#define sendQItemRoutine(q)     ((smallnumVal(first(q)) >> 8) + FIRST_SEND_PRIM)
#define sendQItemBytes(q)       second(q)
#define sendQItemArgs(q)        third(q)
#define sendQItemStack(q)       fourth(q)
#define sendQItemCont(q)        cdr(cdr(cdr(cdr(q))))

#define makeTimerQItem(tm, fn)  ss_cons(ss_makeNum(tm), fn)
#define timerQItemTime(q)       car(q)
#define timerQItemFunc(q)       cdr(q)
#define timerQItemEnvir(q)      cdr(cdr(cdr(q)))

#endif
