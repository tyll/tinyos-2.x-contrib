#ifndef TYPES_H
#define TYPES_H


typedef union ss_val_t {
  uint16_t idx;
  struct s {
    uint16_t tp  :2;
    int16_t  sval :13;
    uint16_t gc  :1;
  } s;
  struct sn {
    uint16_t tp  :2;
    int16_t  sval :14;
  } sn;
} ss_val_t;

typedef union cell {
  struct p {
    ss_val_t car;
    ss_val_t cdr;
  } p;
  struct l {
    int32_t lval :31;
    uint16_t gc  :1;
  } l;
  struct ln {
    int32_t lval;
  } ln;
} ss_cell_t;

/* ss_types of cells */
#define T_PAIR          0x00
#define T_SMALLNUM      0x01
#define T_SYMBOL        0x02
#define T_BIGNUM        0x03

/* gc operations */
#define isGC(c)         (car(c).idx >= 1<<15)
#define clrGC(c)        (car(c).idx &= ~(1<<15))
#define setGC(c)        (car(c).idx |= 1<<15)
#define isFree(c)       (cdr(c).idx >= 1<<15)
#define setUsed(c)      (cdr(c).idx &= ~(1<<15))
#define setFree(c)      (cdr(c).idx |= 1<<15)

/* operations on cells */
#define ss_type(c)              ((c).s.tp)

/* numbers */
#define isNumber(c)             ((ss_type(c) & (T_SMALLNUM & T_BIGNUM)) != 0)
#define makeSmallnum(n)         ((ss_val_t){.s.gc=0, .s.sval=n, .s.tp=T_SMALLNUM})
#define smallnumVal(c)          (int32_t)((c).s.sval)
#define bignumIdx(c)            ((ss_val_t){.idx=((c).idx - T_BIGNUM)})

#define makeBignum(n)           ({ss_val_t t = ss_cons(SYM_NIL, SYM_NIL);      \
                                  cells(t).ln.lval = n & ~(1L<<31);            \
                                  t.s.tp = T_BIGNUM;                           \
                                  t;})
/* pairs */
#define isPair(c)               (ss_type(c) == T_PAIR)
#define car(c)                  (cells(c).p.car)
#define cdr(c)                  (cells(c).p.cdr)
#define eq(a, b)                ((a).idx == (b).idx)
#define lteq(a, b)              ((a).idx <= (b).idx)
#define lt(a, b)                ((a).idx < (b).idx)

/* symbols */
#define isSymbol(c)             (ss_type(c) == T_SYMBOL)
#define makeSymbol(c)          ((ss_val_t){.s.gc=0, .s.sval=c, .s.tp=T_SYMBOL})
#define symVal(c)             ((c).sn.sval)

/* Closures */
#define isClosure(c)           (ss_type(c) == T_PAIR && eq(car(c), SYM(CLOSURE)))
#define makeClosure(l, e)      ss_cons(SYM(CLOSURE), ss_cons(l, e))
#define closureLambda(c)       car(cdr(c))
#define closureArgs(c)         car(closureLambda(c))
#define closureCode(c)         cdr(closureLambda(c))
#define closureEnv(c)          cdr(cdr(c))

/* Continuations */
#define isContinuation(c)       (isPair(c) && eq(car(c), SYM(CONTINUATION)))
#define makeContinuation(s, e)  ss_cons(SYM(CONTINUATION), ss_cons(s, e))
#define contStack(c)            car(cdr(c))
#define contEnv(c)              cdr(cdr(c))
#define callContinuation(c, v)  ({  stack = contStack(c);      \
                                    envir = contEnv(c);        \
                                    do_return(v);              \
                                })


/* Primitives */
#define isPrimitive(c)          (isPair(c) && c.idx < CELLS_START)
#define makePrimitive(v)        ((ss_val_t){.s.gc=0, .s.sval=v, .s.tp=T_PAIR})
#define primVal(c)              (c.sn.sval)

#define isNull(c)               eq(c, SYM_NIL)
#define isBool(c)               (eq(c, SYM_TRUE) || eq(c, SYM_FALSE))
#define isSingleton(c)          (isnull(c) || isbool(c))



#define SYM(s)              makeSymbol(s)
#define SYM_NIL             SYM(_NIL)
#define SYM_TRUE            SYM(_TRUE)
#define SYM_FALSE           SYM(_FALSE)

#if defined(__MSP430__) || defined(__AVR__)
#define STACKSIZE       256

extern uint16_t _end;
extern uint16_t __stack;
#define STACKTOP        &__stack
#define CELLS_START     (((uint16_t)&_end + 2) & 0xfffc)
#define CELLS_END       ((uint16_t)STACKTOP - STACKSIZE)
#define cells(i)        (*(ss_cell_t*)((uint8_t *) (i).idx))
#endif


#ifdef TOSSIM
#define CELLS_START     0x1000
#define NUM_CELLS       0x2000
#define CELLS_END       NUM_CELLS + CELLS_START

ss_cell_t  cellArray[1000][NUM_CELLS];
#define cells(i)        cellArray[sim_node()][((i).idx - CELLS_START) >> 2]
#endif

#endif
