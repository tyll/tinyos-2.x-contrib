#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 151 "/stow/lib/gcc-lib/msp430/3.2.3/include/stddef.h" 3
typedef int ptrdiff_t;
#line 213
typedef unsigned int size_t;
#line 325
typedef int wchar_t;
# 8 "/stow/repository/nesc-1.3.0/lib/ncc/deputy_nodeputy.h"
struct __nesc_attr_nonnull {
}  ;
#line 9
struct __nesc_attr_bnd {
#line 9
  void *lo, *hi;
}  ;
#line 10
struct __nesc_attr_bnd_nok {
#line 10
  void *lo, *hi;
}  ;
#line 11
struct __nesc_attr_count {
#line 11
  int n;
}  ;
#line 12
struct __nesc_attr_count_nok {
#line 12
  int n;
}  ;
#line 13
struct __nesc_attr_one {
}  ;
#line 14
struct __nesc_attr_one_nok {
}  ;
#line 15
struct __nesc_attr_dmemset {
#line 15
  int a1, a2, a3;
}  ;
#line 16
struct __nesc_attr_dmemcpy {
#line 16
  int a1, a2, a3;
}  ;
#line 17
struct __nesc_attr_nts {
}  ;
# 38 "/stow/lib/gcc-lib/../../msp430/include/sys/inttypes.h" 3
typedef signed char int8_t;
typedef unsigned char uint8_t;

typedef int int16_t;
typedef unsigned int uint16_t;

typedef long int32_t;
typedef unsigned long uint32_t;

typedef long long int64_t;
typedef unsigned long long uint64_t;




typedef int16_t intptr_t;
typedef uint16_t uintptr_t;
# 235 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void * source)  ;




static __inline uint8_t __nesc_hton_uint8(void * target, uint8_t value)  ;





static __inline uint8_t __nesc_ntoh_leuint8(const void * source)  ;




static __inline uint8_t __nesc_hton_leuint8(void * target, uint8_t value)  ;





static __inline int8_t __nesc_ntoh_int8(const void * source)  ;
#line 257
static __inline int8_t __nesc_hton_int8(void * target, int8_t value)  ;






static __inline uint16_t __nesc_ntoh_uint16(const void * source)  ;




static __inline uint16_t __nesc_hton_uint16(void * target, uint16_t value)  ;






static __inline uint16_t __nesc_ntoh_leuint16(const void * source)  ;




static __inline uint16_t __nesc_hton_leuint16(void * target, uint16_t value)  ;
#line 294
static __inline uint32_t __nesc_ntoh_uint32(const void * source)  ;






static __inline uint32_t __nesc_hton_uint32(void * target, uint32_t value)  ;
#line 385
typedef struct { unsigned char data[1]; } __attribute__((packed)) nx_int8_t;typedef int8_t __nesc_nxbase_nx_int8_t  ;
typedef struct { unsigned char data[2]; } __attribute__((packed)) nx_int16_t;typedef int16_t __nesc_nxbase_nx_int16_t  ;
typedef struct { unsigned char data[4]; } __attribute__((packed)) nx_int32_t;typedef int32_t __nesc_nxbase_nx_int32_t  ;
typedef struct { unsigned char data[8]; } __attribute__((packed)) nx_int64_t;typedef int64_t __nesc_nxbase_nx_int64_t  ;
typedef struct { unsigned char data[1]; } __attribute__((packed)) nx_uint8_t;typedef uint8_t __nesc_nxbase_nx_uint8_t  ;
typedef struct { unsigned char data[2]; } __attribute__((packed)) nx_uint16_t;typedef uint16_t __nesc_nxbase_nx_uint16_t  ;
typedef struct { unsigned char data[4]; } __attribute__((packed)) nx_uint32_t;typedef uint32_t __nesc_nxbase_nx_uint32_t  ;
typedef struct { unsigned char data[8]; } __attribute__((packed)) nx_uint64_t;typedef uint64_t __nesc_nxbase_nx_uint64_t  ;


typedef struct { unsigned char data[1]; } __attribute__((packed)) nxle_int8_t;typedef int8_t __nesc_nxbase_nxle_int8_t  ;
typedef struct { unsigned char data[2]; } __attribute__((packed)) nxle_int16_t;typedef int16_t __nesc_nxbase_nxle_int16_t  ;
typedef struct { unsigned char data[4]; } __attribute__((packed)) nxle_int32_t;typedef int32_t __nesc_nxbase_nxle_int32_t  ;
typedef struct { unsigned char data[8]; } __attribute__((packed)) nxle_int64_t;typedef int64_t __nesc_nxbase_nxle_int64_t  ;
typedef struct { unsigned char data[1]; } __attribute__((packed)) nxle_uint8_t;typedef uint8_t __nesc_nxbase_nxle_uint8_t  ;
typedef struct { unsigned char data[2]; } __attribute__((packed)) nxle_uint16_t;typedef uint16_t __nesc_nxbase_nxle_uint16_t  ;
typedef struct { unsigned char data[4]; } __attribute__((packed)) nxle_uint32_t;typedef uint32_t __nesc_nxbase_nxle_uint32_t  ;
typedef struct { unsigned char data[8]; } __attribute__((packed)) nxle_uint64_t;typedef uint64_t __nesc_nxbase_nxle_uint64_t  ;
# 41 "/stow/lib/gcc-lib/../../msp430/include/sys/types.h" 3
typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;
typedef unsigned short ushort;
typedef unsigned int uint;

typedef uint8_t u_int8_t;
typedef uint16_t u_int16_t;
typedef uint32_t u_int32_t;
typedef uint64_t u_int64_t;

typedef u_int64_t u_quad_t;
typedef int64_t quad_t;
typedef quad_t *qaddr_t;

typedef char *caddr_t;
typedef const char *c_caddr_t;
typedef volatile char *v_caddr_t;
typedef u_int32_t fixpt_t;
typedef u_int32_t gid_t;
typedef u_int32_t in_addr_t;
typedef u_int16_t in_port_t;
typedef u_int32_t ino_t;
typedef long key_t;
typedef u_int16_t mode_t;
typedef u_int16_t nlink_t;
typedef quad_t rlim_t;
typedef int32_t segsz_t;
typedef int32_t swblk_t;
typedef int32_t ufs_daddr_t;
typedef int32_t ufs_time_t;
typedef u_int32_t uid_t;
# 37 "/stow/lib/gcc-lib/../../msp430/include/string.h" 3
extern int memcmp(const void *arg_0x7a8e70, const void *arg_0x7a6030, size_t arg_0x7a61c8);


extern void *memset(void *arg_0x7aa690, int arg_0x7aa7e8, size_t arg_0x7aa980);



extern char *strcpy(char *arg_0x7b1178, const char *arg_0x7b1310);

extern size_t strlen(const char *arg_0x7b1eb0);



extern char *strncpy(char *arg_0x7b3848, const char *arg_0x7b39e0, size_t arg_0x7b3b78);










extern void *memset(void *arg_0x7c0650, int arg_0x7c07a8, size_t arg_0x7c0940);
# 59 "/stow/lib/gcc-lib/../../msp430/include/stdlib.h" 3
#line 55
typedef struct __nesc_unnamed4242 {

  int quot;
  int rem;
} div_t;







#line 63
typedef struct __nesc_unnamed4243 {

  long quot;
  long rem;
} ldiv_t;
# 122 "/stow/lib/gcc-lib/../../msp430/include/sys/config.h" 3
typedef long int __int32_t;
typedef unsigned long int __uint32_t;
# 12 "/stow/lib/gcc-lib/../../msp430/include/sys/_types.h" 3
typedef long _off_t;
typedef long _ssize_t;
# 28 "/stow/lib/gcc-lib/../../msp430/include/sys/reent.h" 3
typedef __uint32_t __ULong;


struct _glue {

  struct _glue *_next;
  int _niobs;
  struct __sFILE *_iobs;
};

struct _Bigint {

  struct _Bigint *_next;
  int _k, _maxwds, _sign, _wds;
  __ULong _x[1];
};


struct __tm {

  int __tm_sec;
  int __tm_min;
  int __tm_hour;
  int __tm_mday;
  int __tm_mon;
  int __tm_year;
  int __tm_wday;
  int __tm_yday;
  int __tm_isdst;
};







struct _atexit {
  struct _atexit *_next;
  int _ind;
  void (*_fns[32])(void );
};








struct __sbuf {
  unsigned char *_base;
  int _size;
};






typedef long _fpos_t;
#line 116
struct __sFILE {
  unsigned char *_p;
  int _r;
  int _w;
  short _flags;
  short _file;
  struct __sbuf _bf;
  int _lbfsize;


  void *_cookie;

  int (*_read)(void *_cookie, char *_buf, int _n);
  int (*_write)(void *_cookie, const char *_buf, int _n);

  _fpos_t (*_seek)(void *_cookie, _fpos_t _offset, int _whence);
  int (*_close)(void *_cookie);


  struct __sbuf _ub;
  unsigned char *_up;
  int _ur;


  unsigned char _ubuf[3];
  unsigned char _nbuf[1];


  struct __sbuf _lb;


  int _blksize;
  int _offset;

  struct _reent *_data;
};
#line 174
struct _rand48 {
  unsigned short _seed[3];
  unsigned short _mult[3];
  unsigned short _add;
};









struct _reent {


  int _errno;




  struct __sFILE *_stdin, *_stdout, *_stderr;

  int _inc;
  char _emergency[25];

  int _current_category;
  const char *_current_locale;

  int __sdidinit;

  void (*__cleanup)(struct _reent *arg_0x7f0ab8);


  struct _Bigint *_result;
  int _result_k;
  struct _Bigint *_p5s;
  struct _Bigint **_freelist;


  int _cvtlen;
  char *_cvtbuf;

  union __nesc_unnamed4244 {

    struct __nesc_unnamed4245 {

      unsigned int _unused_rand;
      char *_strtok_last;
      char _asctime_buf[26];
      struct __tm _localtime_buf;
      int _gamma_signgam;
      __extension__ unsigned long long _rand_next;
      struct _rand48 _r48;
    } _reent;



    struct __nesc_unnamed4246 {


      unsigned char *_nextf[30];
      unsigned int _nmalloc[30];
    } _unused;
  } _new;


  struct _atexit *_atexit;
  struct _atexit _atexit0;


  void (**_sig_func)(int arg_0x7f4c98);




  struct _glue __sglue;
  struct __sFILE __sf[3];
};
#line 273
struct _reent;
# 18 "/stow/lib/gcc-lib/../../msp430/include/math.h" 3
union __dmath {

  __uint32_t i[2];
  double d;
};




union __dmath;
#line 208
struct exception {


  int type;
  char *name;
  double arg1;
  double arg2;
  double retval;
  int err;
};
#line 261
enum __fdlibm_version {

  __fdlibm_ieee = -1, 
  __fdlibm_svid, 
  __fdlibm_xopen, 
  __fdlibm_posix
};




enum __fdlibm_version;
# 23 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/tos.h"
typedef uint8_t bool;
enum __nesc_unnamed4247 {
#line 24
  FALSE = 0, TRUE = 1
};
typedef nx_int8_t nx_bool;
uint16_t TOS_NODE_ID = 1;






struct __nesc_attr_atmostonce {
};
#line 35
struct __nesc_attr_atleastonce {
};
#line 36
struct __nesc_attr_exactlyonce {
};
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/TinyError.h"
enum __nesc_unnamed4248 {
  SUCCESS = 0, 
  FAIL = 1, 
  ESIZE = 2, 
  ECANCEL = 3, 
  EOFF = 4, 
  EBUSY = 5, 
  EINVAL = 6, 
  ERETRY = 7, 
  ERESERVE = 8, 
  EALREADY = 9, 
  ENOMEM = 10, 
  ENOACK = 11, 
  ELAST = 11
};

typedef uint8_t error_t  ;

static inline error_t ecombine(error_t r1, error_t r2)  ;
# 39 "/stow/lib/gcc-lib/../../msp430/include/msp430/iostructures.h" 3
#line 27
typedef union port {
  volatile unsigned char reg_p;
  volatile struct __nesc_unnamed4249 {
    unsigned char __p0 : 1, 
    __p1 : 1, 
    __p2 : 1, 
    __p3 : 1, 
    __p4 : 1, 
    __p5 : 1, 
    __p6 : 1, 
    __p7 : 1;
  } __pin;
} __attribute((packed))  ioregister_t;
#line 108
struct port_full_t {
  ioregister_t in;
  ioregister_t out;
  ioregister_t dir;
  ioregister_t ifg;
  ioregister_t ies;
  ioregister_t ie;
  ioregister_t sel;
};









struct port_simple_t {
  ioregister_t in;
  ioregister_t out;
  ioregister_t dir;
  ioregister_t sel;
};




struct port_full_t;



struct port_full_t;



struct port_simple_t;



struct port_simple_t;



struct port_simple_t;



struct port_simple_t;
# 116 "/stow/lib/gcc-lib/../../msp430/include/msp430/gpio.h" 3
volatile unsigned char P1OUT __asm ("0x0021");

volatile unsigned char P1DIR __asm ("0x0022");

volatile unsigned char P1IFG __asm ("0x0023");

volatile unsigned char P1IES __asm ("0x0024");

volatile unsigned char P1IE __asm ("0x0025");

volatile unsigned char P1SEL __asm ("0x0026");










volatile unsigned char P2OUT __asm ("0x0029");

volatile unsigned char P2DIR __asm ("0x002A");

volatile unsigned char P2IFG __asm ("0x002B");



volatile unsigned char P2IE __asm ("0x002D");

volatile unsigned char P2SEL __asm ("0x002E");










volatile unsigned char P3OUT __asm ("0x0019");

volatile unsigned char P3DIR __asm ("0x001A");

volatile unsigned char P3SEL __asm ("0x001B");










volatile unsigned char P4OUT __asm ("0x001D");

volatile unsigned char P4DIR __asm ("0x001E");

volatile unsigned char P4SEL __asm ("0x001F");










volatile unsigned char P5OUT __asm ("0x0031");

volatile unsigned char P5DIR __asm ("0x0032");

volatile unsigned char P5SEL __asm ("0x0033");










volatile unsigned char P6OUT __asm ("0x0035");

volatile unsigned char P6DIR __asm ("0x0036");

volatile unsigned char P6SEL __asm ("0x0037");
# 97 "/stow/lib/gcc-lib/../../msp430/include/msp430/usart.h" 3
volatile unsigned char U0CTL __asm ("0x0070");

volatile unsigned char U0TCTL __asm ("0x0071");



volatile unsigned char U0MCTL __asm ("0x0073");

volatile unsigned char U0BR0 __asm ("0x0074");

volatile unsigned char U0BR1 __asm ("0x0075");

volatile unsigned char U0RXBUF __asm ("0x0076");
#line 281
volatile unsigned char U1CTL __asm ("0x0078");

volatile unsigned char U1TCTL __asm ("0x0079");

volatile unsigned char U1RCTL __asm ("0x007A");

volatile unsigned char U1MCTL __asm ("0x007B");

volatile unsigned char U1BR0 __asm ("0x007C");

volatile unsigned char U1BR1 __asm ("0x007D");



volatile unsigned char U1TXBUF __asm ("0x007F");


volatile unsigned char UCTL1 __asm ("0x0078");
# 27 "/stow/lib/gcc-lib/../../msp430/include/msp430/timera.h" 3
volatile unsigned int TA0CTL __asm ("0x0160");

volatile unsigned int TA0R __asm ("0x0170");


volatile unsigned int TA0CCTL0 __asm ("0x0162");

volatile unsigned int TA0CCTL1 __asm ("0x0164");
#line 70
volatile unsigned int TA0CCTL2 __asm ("0x0166");
#line 127
#line 118
typedef struct __nesc_unnamed4250 {
  volatile unsigned 
  taifg : 1, 
  taie : 1, 
  taclr : 1, 
  dummy : 1, 
  tamc : 2, 
  taid : 2, 
  tassel : 2;
} __attribute((packed))  tactl_t;
#line 143
#line 129
typedef struct __nesc_unnamed4251 {
  volatile unsigned 
  ccifg : 1, 
  cov : 1, 
  out : 1, 
  cci : 1, 
  ccie : 1, 
  outmod : 3, 
  cap : 1, 
  dummy : 1, 
  scci : 1, 
  scs : 1, 
  ccis : 2, 
  cm : 2;
} __attribute((packed))  tacctl_t;


struct timera_t {
  tactl_t ctl;
  tacctl_t cctl0;
  tacctl_t cctl1;
  tacctl_t cctl2;
  volatile unsigned dummy[4];
  volatile unsigned tar;
  volatile unsigned taccr0;
  volatile unsigned taccr1;
  volatile unsigned taccr2;
};



struct timera_t;
# 26 "/stow/lib/gcc-lib/../../msp430/include/msp430/timerb.h" 3
volatile unsigned int TBR __asm ("0x0190");


volatile unsigned int TBCCTL0 __asm ("0x0182");





volatile unsigned int TBCCR0 __asm ("0x0192");
#line 76
#line 64
typedef struct __nesc_unnamed4252 {
  volatile unsigned 
  tbifg : 1, 
  tbie : 1, 
  tbclr : 1, 
  dummy1 : 1, 
  tbmc : 2, 
  tbid : 2, 
  tbssel : 2, 
  dummy2 : 1, 
  tbcntl : 2, 
  tbclgrp : 2;
} __attribute((packed))  tbctl_t;
#line 91
#line 78
typedef struct __nesc_unnamed4253 {
  volatile unsigned 
  ccifg : 1, 
  cov : 1, 
  out : 1, 
  cci : 1, 
  ccie : 1, 
  outmod : 3, 
  cap : 1, 
  clld : 2, 
  scs : 1, 
  ccis : 2, 
  cm : 2;
} __attribute((packed))  tbcctl_t;


struct timerb_t {
  tbctl_t ctl;
  tbcctl_t cctl0;
  tbcctl_t cctl1;
  tbcctl_t cctl2;

  tbcctl_t cctl3;
  tbcctl_t cctl4;
  tbcctl_t cctl5;
  tbcctl_t cctl6;



  volatile unsigned tbr;
  volatile unsigned tbccr0;
  volatile unsigned tbccr1;
  volatile unsigned tbccr2;

  volatile unsigned tbccr3;
  volatile unsigned tbccr4;
  volatile unsigned tbccr5;
  volatile unsigned tbccr6;
};





struct timerb_t;
# 20 "/stow/lib/gcc-lib/../../msp430/include/msp430/basic_clock.h" 3
volatile unsigned char DCOCTL __asm ("0x0056");

volatile unsigned char BCSCTL1 __asm ("0x0057");

volatile unsigned char BCSCTL2 __asm ("0x0058");
# 18 "/stow/lib/gcc-lib/../../msp430/include/msp430/adc12.h" 3
volatile unsigned int ADC12CTL0 __asm ("0x01A0");

volatile unsigned int ADC12CTL1 __asm ("0x01A2");
#line 42
#line 30
typedef struct __nesc_unnamed4254 {
  volatile unsigned 
  adc12sc : 1, 
  enc : 1, 
  adc12tovie : 1, 
  adc12ovie : 1, 
  adc12on : 1, 
  refon : 1, 
  r2_5v : 1, 
  msc : 1, 
  sht0 : 4, 
  sht1 : 4;
} __attribute((packed))  adc12ctl0_t;
#line 54
#line 44
typedef struct __nesc_unnamed4255 {
  volatile unsigned 
  adc12busy : 1, 
  conseq : 2, 
  adc12ssel : 2, 
  adc12div : 3, 
  issh : 1, 
  shp : 1, 
  shs : 2, 
  cstartadd : 4;
} __attribute((packed))  adc12ctl1_t;
#line 74
#line 56
typedef struct __nesc_unnamed4256 {
  volatile unsigned 
  bit0 : 1, 
  bit1 : 1, 
  bit2 : 1, 
  bit3 : 1, 
  bit4 : 1, 
  bit5 : 1, 
  bit6 : 1, 
  bit7 : 1, 
  bit8 : 1, 
  bit9 : 1, 
  bit10 : 1, 
  bit11 : 1, 
  bit12 : 1, 
  bit13 : 1, 
  bit14 : 1, 
  bit15 : 1;
} __attribute((packed))  adc12xflg_t;


struct adc12_t {
  adc12ctl0_t ctl0;
  adc12ctl1_t ctl1;
  adc12xflg_t ifg;
  adc12xflg_t ie;
  adc12xflg_t iv;
};




struct adc12_t;
# 73 "/stow/lib/gcc-lib/../../msp430/include/msp430x16x.h" 3
volatile unsigned char IE2 __asm ("0x0001");




volatile unsigned char IFG2 __asm ("0x0003");




volatile unsigned char ME1 __asm ("0x0004");





volatile unsigned char ME2 __asm ("0x0005");
# 158 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static volatile uint8_t U0CTLnr __asm ("0x0070");
static volatile uint8_t I2CTCTLnr __asm ("0x0071");
static volatile uint8_t I2CDCTLnr __asm ("0x0072");
#line 193
typedef uint8_t mcu_power_t  ;
static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)  ;


enum __nesc_unnamed4257 {
  MSP430_POWER_ACTIVE = 0, 
  MSP430_POWER_LPM0 = 1, 
  MSP430_POWER_LPM1 = 2, 
  MSP430_POWER_LPM2 = 3, 
  MSP430_POWER_LPM3 = 4, 
  MSP430_POWER_LPM4 = 5
};

static inline void __nesc_disable_interrupt(void )  ;





static inline void __nesc_enable_interrupt(void )  ;




typedef bool __nesc_atomic_t;
__nesc_atomic_t __nesc_atomic_start(void );
void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts);






__nesc_atomic_t __nesc_atomic_start(void )   ;







void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts)   ;
#line 248
typedef struct { unsigned char data[4]; } __attribute__((packed)) nx_float;typedef float __nesc_nxbase_nx_float  ;
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/hardware.h"
enum __nesc_unnamed4258 {
  TOS_SLEEP_NONE = MSP430_POWER_ACTIVE
};
#line 86
static inline void TOSH_SEL_UTXD1_MODFUNC()  ;
static inline void TOSH_SEL_URXD1_MODFUNC()  ;
# 35 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/6lowpan.h"
enum __nesc_unnamed4259 {
  LOWMSG_MESH_LEN = 5, 
  LOWMSG_BCAST_LEN = 2, 
  LOWMSG_FRAG1_LEN = 4, 
  LOWMSG_FRAGN_LEN = 5
};

enum __nesc_unnamed4260 {
  INET_MTU = 1280, 
  LIB6LOWPAN_MAX_LEN = 100, 
  LOWPAN_LINK_MTU = 109, 




  FRAG_EXPIRE_TIME = 4096
};




enum __nesc_unnamed4261 {
  LOWPAN_NALP_PATTERN = 0x0, 
  LOWPAN_MESH_PATTERN = 0x2, 
  LOWPAN_FRAG1_PATTERN = 0x18, 
  LOWPAN_FRAGN_PATTERN = 0x1c, 
  LOWPAN_BCAST_PATTERN = 0x50
};

enum __nesc_unnamed4262 {
  LOWPAN_MESH_V_MASK = 0x20, 
  LOWPAN_MESH_F_MASK = 0x10, 
  LOWPAN_MESH_HOPS_MASK = 0x0f
};




enum __nesc_unnamed4263 {
  LOWPAN_DISPATCH_BYTE_MASK = 0xe0, 
  LOWPAN_DISPATCH_BYTE_VAL = 0x60, 

  LOWPAN_IPHC_TF_MASK = 0x18, 
  LOWPAN_IPHC_TF_NONE = 0x18, 
  LOWPAN_IPHC_TF_ECN_DSCP = 0x10, 
  LOWPAN_IPHC_TF_ECN_FL = 0x08, 
  LOWPAN_IPHC_TF_ECN_DSCP_FL = 0x00, 

  LOWPAN_IPHC_NH_MASK = 0x04, 
  LOWPAN_IPHC_NH_INLINE = 0, 

  LOWPAN_IPHC_HLIM_MASK = 0x03, 
  LOWPAN_IPHC_HLIM_NONE = 0x00, 
  LOWPAN_IPHC_HLIM_1 = 0x01, 
  LOWPAN_IPHC_HLIM_64 = 0x02, 
  LOWPAN_IPHC_HLIM_255 = 0x03, 

  LOWPAN_IPHC_CID_MASK = 0x80, 
  LOWPAN_IPHC_CID_PRESENT = 0x80, 

  LOWPAN_IPHC_SAM_SHIFT = 4, 
  LOWPAN_IPHC_M = 0x08, 
  LOWPAN_IPHC_DAM_SHIFT = 0, 

  LOWPAN_IPHC_AC_CONTEXT = 0x04, 
  LOWPAN_IPHC_AM_MASK = 0x3, 
  LOWPAN_IPHC_AM_128 = 0x0, 
  LOWPAN_IPHC_AM_64 = 0x1, 
  LOWPAN_IPHC_AM_16 = 0x2, 
  LOWPAN_IPHC_AM_0 = 0x3, 

  LOWPAN_IPHC_AM_M = 0x08, 
  LOWPAN_IPHC_AM_M_128 = 0x0, 
  LOWPAN_IPHC_AM_M_48 = 0x1, 
  LOWPAN_IPHC_AM_M_32 = 0x2, 
  LOWPAN_IPHC_AM_M_8 = 0x3
};




enum __nesc_unnamed4264 {
  LOWPAN_NHC_IPV6_MASK = 0xf0, 
  LOWPAN_NHC_IPV6_PATTERN = 0xe0, 

  LOWPAN_NHC_EID_SHIFT = 0x1, 
  LOWPAN_NHC_EID_MASK = 0xe, 
  LOWPAN_NHC_EID_HOP = 0x0 << LOWPAN_NHC_EID_SHIFT, 
  LOWPAN_NHC_EID_ROUTING = 0x1 << LOWPAN_NHC_EID_SHIFT, 
  LOWPAN_NHC_EID_FRAG = 0x2 << LOWPAN_NHC_EID_SHIFT, 
  LOWPAN_NHC_EID_DEST = 0x3 << LOWPAN_NHC_EID_SHIFT, 
  LOWPAN_NHC_EID_MOBILE = 0x4 << LOWPAN_NHC_EID_SHIFT, 
  LOWPAN_NHC_EID_IPV6 = 0x7 << LOWPAN_NHC_EID_SHIFT, 

  LOWPAN_NHC_NH = 0x1, 

  LOWPAN_NHC_UDP_MASK = 0xf8, 
  LOWPAN_NHC_UDP_PATTERN = 0xf0, 

  LOWPAN_NHC_UDP_CKSUM = 0x4, 

  LOWPAN_NHC_UDP_PORT_MASK = 0x3, 
  LOWPAN_NHC_UDP_PORT_FULL = 0x0, 
  LOWPAN_NHC_UDP_PORT_SRC_FULL = 0x1, 
  LOWPAN_NHC_UDP_PORT_DST_FULL = 0x2, 
  LOWPAN_NHC_UDP_PORT_SHORT = 0x3
};
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.h"
enum __nesc_unnamed4265 {
  MSP430TIMER_CM_NONE = 0, 
  MSP430TIMER_CM_RISING = 1, 
  MSP430TIMER_CM_FALLING = 2, 
  MSP430TIMER_CM_BOTH = 3, 

  MSP430TIMER_STOP_MODE = 0, 
  MSP430TIMER_UP_MODE = 1, 
  MSP430TIMER_CONTINUOUS_MODE = 2, 
  MSP430TIMER_UPDOWN_MODE = 3, 

  MSP430TIMER_TACLK = 0, 
  MSP430TIMER_TBCLK = 0, 
  MSP430TIMER_ACLK = 1, 
  MSP430TIMER_SMCLK = 2, 
  MSP430TIMER_INCLK = 3, 

  MSP430TIMER_CLOCKDIV_1 = 0, 
  MSP430TIMER_CLOCKDIV_2 = 1, 
  MSP430TIMER_CLOCKDIV_4 = 2, 
  MSP430TIMER_CLOCKDIV_8 = 3
};
#line 64
#line 51
typedef struct __nesc_unnamed4266 {

  int ccifg : 1;
  int cov : 1;
  int out : 1;
  int cci : 1;
  int ccie : 1;
  int outmod : 3;
  int cap : 1;
  int clld : 2;
  int scs : 1;
  int ccis : 2;
  int cm : 2;
} msp430_compare_control_t;
#line 76
#line 66
typedef struct __nesc_unnamed4267 {

  int taifg : 1;
  int taie : 1;
  int taclr : 1;
  int _unused0 : 1;
  int mc : 2;
  int id : 2;
  int tassel : 2;
  int _unused1 : 6;
} msp430_timer_a_control_t;
#line 91
#line 78
typedef struct __nesc_unnamed4268 {

  int tbifg : 1;
  int tbie : 1;
  int tbclr : 1;
  int _unused0 : 1;
  int mc : 2;
  int id : 2;
  int tbssel : 2;
  int _unused1 : 1;
  int cntl : 2;
  int tbclgrp : 2;
  int _unused2 : 1;
} msp430_timer_b_control_t;
# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/Leds.h"
enum __nesc_unnamed4269 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
# 39 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/CC2420.h"
typedef uint8_t cc2420_status_t;
#line 93
#line 87
typedef nx_struct security_header_t {
  unsigned char __nesc_filler0[1];


  nx_uint32_t frameCounter;
  nx_uint8_t keyID[1];
} __attribute__((packed)) security_header_t;
#line 115
#line 95
typedef nx_struct cc2420_header_t {
  nxle_uint8_t length;
  nxle_uint16_t fcf;
  nxle_uint8_t dsn;
  nxle_uint16_t destpan;
  nxle_uint16_t dest;
  nxle_uint16_t src;







  nxle_uint8_t network;




  nxle_uint8_t type;
} __attribute__((packed)) cc2420_header_t;





#line 120
typedef nx_struct cc2420_footer_t {
} __attribute__((packed)) cc2420_footer_t;
#line 145
#line 130
typedef nx_struct cc2420_metadata_t {
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_uint8_t tx_power;
  nx_bool crc;
  nx_bool ack;
  nx_bool timesync;
  nx_uint32_t timestamp;
  nx_uint16_t rxInterval;



  nx_uint16_t maxRetries;
  nx_uint16_t retryDelay;
} __attribute__((packed)) 
cc2420_metadata_t;





#line 148
typedef nx_struct cc2420_packet_t {
  cc2420_header_t packet;
  nx_uint8_t data[];
} __attribute__((packed)) cc2420_packet_t;
#line 181
enum __nesc_unnamed4270 {

  MAC_HEADER_SIZE = sizeof(cc2420_header_t ) - 1, 

  MAC_FOOTER_SIZE = sizeof(uint16_t ), 

  MAC_PACKET_SIZE = MAC_HEADER_SIZE + 114 + MAC_FOOTER_SIZE, 

  CC2420_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE
};

enum cc2420_enums {
  CC2420_TIME_ACK_TURNAROUND = 7, 
  CC2420_TIME_VREN = 20, 
  CC2420_TIME_SYMBOL = 2, 
  CC2420_BACKOFF_PERIOD = 20 / CC2420_TIME_SYMBOL, 
  CC2420_MIN_BACKOFF = 20 / CC2420_TIME_SYMBOL, 
  CC2420_ACK_WAIT_DELAY = 256
};

enum cc2420_status_enums {
  CC2420_STATUS_RSSI_VALID = 1 << 1, 
  CC2420_STATUS_LOCK = 1 << 2, 
  CC2420_STATUS_TX_ACTIVE = 1 << 3, 
  CC2420_STATUS_ENC_BUSY = 1 << 4, 
  CC2420_STATUS_TX_UNDERFLOW = 1 << 5, 
  CC2420_STATUS_XOSC16M_STABLE = 1 << 6
};

enum cc2420_config_reg_enums {
  CC2420_SNOP = 0x00, 
  CC2420_SXOSCON = 0x01, 
  CC2420_STXCAL = 0x02, 
  CC2420_SRXON = 0x03, 
  CC2420_STXON = 0x04, 
  CC2420_STXONCCA = 0x05, 
  CC2420_SRFOFF = 0x06, 
  CC2420_SXOSCOFF = 0x07, 
  CC2420_SFLUSHRX = 0x08, 
  CC2420_SFLUSHTX = 0x09, 
  CC2420_SACK = 0x0a, 
  CC2420_SACKPEND = 0x0b, 
  CC2420_SRXDEC = 0x0c, 
  CC2420_STXENC = 0x0d, 
  CC2420_SAES = 0x0e, 
  CC2420_MAIN = 0x10, 
  CC2420_MDMCTRL0 = 0x11, 
  CC2420_MDMCTRL1 = 0x12, 
  CC2420_RSSI = 0x13, 
  CC2420_SYNCWORD = 0x14, 
  CC2420_TXCTRL = 0x15, 
  CC2420_RXCTRL0 = 0x16, 
  CC2420_RXCTRL1 = 0x17, 
  CC2420_FSCTRL = 0x18, 
  CC2420_SECCTRL0 = 0x19, 
  CC2420_SECCTRL1 = 0x1a, 
  CC2420_BATTMON = 0x1b, 
  CC2420_IOCFG0 = 0x1c, 
  CC2420_IOCFG1 = 0x1d, 
  CC2420_MANFIDL = 0x1e, 
  CC2420_MANFIDH = 0x1f, 
  CC2420_FSMTC = 0x20, 
  CC2420_MANAND = 0x21, 
  CC2420_MANOR = 0x22, 
  CC2420_AGCCTRL = 0x23, 
  CC2420_AGCTST0 = 0x24, 
  CC2420_AGCTST1 = 0x25, 
  CC2420_AGCTST2 = 0x26, 
  CC2420_FSTST0 = 0x27, 
  CC2420_FSTST1 = 0x28, 
  CC2420_FSTST2 = 0x29, 
  CC2420_FSTST3 = 0x2a, 
  CC2420_RXBPFTST = 0x2b, 
  CC2420_FMSTATE = 0x2c, 
  CC2420_ADCTST = 0x2d, 
  CC2420_DACTST = 0x2e, 
  CC2420_TOPTST = 0x2f, 
  CC2420_TXFIFO = 0x3e, 
  CC2420_RXFIFO = 0x3f
};

enum cc2420_ram_addr_enums {
  CC2420_RAM_TXFIFO = 0x000, 
  CC2420_RAM_RXFIFO = 0x080, 
  CC2420_RAM_KEY0 = 0x100, 
  CC2420_RAM_RXNONCE = 0x110, 
  CC2420_RAM_SABUF = 0x120, 
  CC2420_RAM_KEY1 = 0x130, 
  CC2420_RAM_TXNONCE = 0x140, 
  CC2420_RAM_CBCSTATE = 0x150, 
  CC2420_RAM_IEEEADR = 0x160, 
  CC2420_RAM_PANID = 0x168, 
  CC2420_RAM_SHORTADR = 0x16a
};

enum cc2420_nonce_enums {
  CC2420_NONCE_BLOCK_COUNTER = 0, 
  CC2420_NONCE_KEY_SEQ_COUNTER = 2, 
  CC2420_NONCE_FRAME_COUNTER = 3, 
  CC2420_NONCE_SOURCE_ADDRESS = 7, 
  CC2420_NONCE_FLAGS = 15
};

enum cc2420_main_enums {
  CC2420_MAIN_RESETn = 15, 
  CC2420_MAIN_ENC_RESETn = 14, 
  CC2420_MAIN_DEMOD_RESETn = 13, 
  CC2420_MAIN_MOD_RESETn = 12, 
  CC2420_MAIN_FS_RESETn = 11, 
  CC2420_MAIN_XOSC16M_BYPASS = 0
};

enum cc2420_mdmctrl0_enums {
  CC2420_MDMCTRL0_RESERVED_FRAME_MODE = 13, 
  CC2420_MDMCTRL0_PAN_COORDINATOR = 12, 
  CC2420_MDMCTRL0_ADR_DECODE = 11, 
  CC2420_MDMCTRL0_CCA_HYST = 8, 
  CC2420_MDMCTRL0_CCA_MOD = 6, 
  CC2420_MDMCTRL0_AUTOCRC = 5, 
  CC2420_MDMCTRL0_AUTOACK = 4, 
  CC2420_MDMCTRL0_PREAMBLE_LENGTH = 0
};

enum cc2420_mdmctrl1_enums {
  CC2420_MDMCTRL1_CORR_THR = 6, 
  CC2420_MDMCTRL1_DEMOD_AVG_MODE = 5, 
  CC2420_MDMCTRL1_MODULATION_MODE = 4, 
  CC2420_MDMCTRL1_TX_MODE = 2, 
  CC2420_MDMCTRL1_RX_MODE = 0
};

enum cc2420_rssi_enums {
  CC2420_RSSI_CCA_THR = 8, 
  CC2420_RSSI_RSSI_VAL = 0
};

enum cc2420_syncword_enums {
  CC2420_SYNCWORD_SYNCWORD = 0
};

enum cc2420_txctrl_enums {
  CC2420_TXCTRL_TXMIXBUF_CUR = 14, 
  CC2420_TXCTRL_TX_TURNAROUND = 13, 
  CC2420_TXCTRL_TXMIX_CAP_ARRAY = 11, 
  CC2420_TXCTRL_TXMIX_CURRENT = 9, 
  CC2420_TXCTRL_PA_CURRENT = 6, 
  CC2420_TXCTRL_RESERVED = 5, 
  CC2420_TXCTRL_PA_LEVEL = 0
};

enum cc2420_rxctrl0_enums {
  CC2420_RXCTRL0_RXMIXBUF_CUR = 12, 
  CC2420_RXCTRL0_HIGH_LNA_GAIN = 10, 
  CC2420_RXCTRL0_MED_LNA_GAIN = 8, 
  CC2420_RXCTRL0_LOW_LNA_GAIN = 6, 
  CC2420_RXCTRL0_HIGH_LNA_CURRENT = 4, 
  CC2420_RXCTRL0_MED_LNA_CURRENT = 2, 
  CC2420_RXCTRL0_LOW_LNA_CURRENT = 0
};

enum cc2420_rxctrl1_enums {
  CC2420_RXCTRL1_RXBPF_LOCUR = 13, 
  CC2420_RXCTRL1_RXBPF_MIDCUR = 12, 
  CC2420_RXCTRL1_LOW_LOWGAIN = 11, 
  CC2420_RXCTRL1_MED_LOWGAIN = 10, 
  CC2420_RXCTRL1_HIGH_HGM = 9, 
  CC2420_RXCTRL1_MED_HGM = 8, 
  CC2420_RXCTRL1_LNA_CAP_ARRAY = 6, 
  CC2420_RXCTRL1_RXMIX_TAIL = 4, 
  CC2420_RXCTRL1_RXMIX_VCM = 2, 
  CC2420_RXCTRL1_RXMIX_CURRENT = 0
};

enum cc2420_rsctrl_enums {
  CC2420_FSCTRL_LOCK_THR = 14, 
  CC2420_FSCTRL_CAL_DONE = 13, 
  CC2420_FSCTRL_CAL_RUNNING = 12, 
  CC2420_FSCTRL_LOCK_LENGTH = 11, 
  CC2420_FSCTRL_LOCK_STATUS = 10, 
  CC2420_FSCTRL_FREQ = 0
};

enum cc2420_secctrl0_enums {
  CC2420_SECCTRL0_RXFIFO_PROTECTION = 9, 
  CC2420_SECCTRL0_SEC_CBC_HEAD = 8, 
  CC2420_SECCTRL0_SEC_SAKEYSEL = 7, 
  CC2420_SECCTRL0_SEC_TXKEYSEL = 6, 
  CC2420_SECCTRL0_SEC_RXKEYSEL = 5, 
  CC2420_SECCTRL0_SEC_M = 2, 
  CC2420_SECCTRL0_SEC_MODE = 0
};

enum cc2420_secctrl1_enums {
  CC2420_SECCTRL1_SEC_TXL = 8, 
  CC2420_SECCTRL1_SEC_RXL = 0
};

enum cc2420_battmon_enums {
  CC2420_BATTMON_BATT_OK = 6, 
  CC2420_BATTMON_BATTMON_EN = 5, 
  CC2420_BATTMON_BATTMON_VOLTAGE = 0
};

enum cc2420_iocfg0_enums {
  CC2420_IOCFG0_BCN_ACCEPT = 11, 
  CC2420_IOCFG0_FIFO_POLARITY = 10, 
  CC2420_IOCFG0_FIFOP_POLARITY = 9, 
  CC2420_IOCFG0_SFD_POLARITY = 8, 
  CC2420_IOCFG0_CCA_POLARITY = 7, 
  CC2420_IOCFG0_FIFOP_THR = 0
};

enum cc2420_iocfg1_enums {
  CC2420_IOCFG1_HSSD_SRC = 10, 
  CC2420_IOCFG1_SFDMUX = 5, 
  CC2420_IOCFG1_CCAMUX = 0
};

enum cc2420_manfidl_enums {
  CC2420_MANFIDL_PARTNUM = 12, 
  CC2420_MANFIDL_MANFID = 0
};

enum cc2420_manfidh_enums {
  CC2420_MANFIDH_VERSION = 12, 
  CC2420_MANFIDH_PARTNUM = 0
};

enum cc2420_fsmtc_enums {
  CC2420_FSMTC_TC_RXCHAIN2RX = 13, 
  CC2420_FSMTC_TC_SWITCH2TX = 10, 
  CC2420_FSMTC_TC_PAON2TX = 6, 
  CC2420_FSMTC_TC_TXEND2SWITCH = 3, 
  CC2420_FSMTC_TC_TXEND2PAOFF = 0
};

enum cc2420_sfdmux_enums {
  CC2420_SFDMUX_SFD = 0, 
  CC2420_SFDMUX_XOSC16M_STABLE = 24
};

enum cc2420_security_enums {
  CC2420_NO_SEC = 0, 
  CC2420_CBC_MAC = 1, 
  CC2420_CTR = 2, 
  CC2420_CCM = 3, 
  NO_SEC = 0, 
  CBC_MAC_4 = 1, 
  CBC_MAC_8 = 2, 
  CBC_MAC_16 = 3, 
  CTR = 4, 
  CCM_4 = 5, 
  CCM_8 = 6, 
  CCM_16 = 7
};


enum __nesc_unnamed4271 {

  CC2420_INVALID_TIMESTAMP = 0x80000000L
};
# 6 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/AM.h"
typedef nx_uint8_t nx_am_id_t;
typedef nx_uint8_t nx_am_group_t;
typedef nx_uint16_t nx_am_addr_t;

typedef uint8_t am_id_t;
typedef uint8_t am_group_t;
typedef uint16_t am_addr_t;

enum __nesc_unnamed4272 {
  AM_BROADCAST_ADDR = 0xffff
};









enum __nesc_unnamed4273 {
  TOS_AM_GROUP = 0x22, 
  TOS_AM_ADDRESS = 1
};
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/serial/Serial.h"
typedef uint8_t uart_id_t;



enum __nesc_unnamed4274 {
  HDLC_FLAG_BYTE = 0x7e, 
  HDLC_CTLESC_BYTE = 0x7d
};



enum __nesc_unnamed4275 {
  TOS_SERIAL_ACTIVE_MESSAGE_ID = 0, 
  TOS_SERIAL_CC1000_ID = 1, 
  TOS_SERIAL_802_15_4_ID = 2, 
  TOS_SERIAL_UNKNOWN_ID = 255
};


enum __nesc_unnamed4276 {
  SERIAL_PROTO_ACK = 67, 
  SERIAL_PROTO_PACKET_ACK = 68, 
  SERIAL_PROTO_PACKET_NOACK = 69, 
  SERIAL_PROTO_PACKET_UNKNOWN = 255
};
#line 110
#line 98
typedef struct radio_stats {
  uint8_t version;
  uint8_t flags;
  uint8_t reserved;
  uint8_t platform;
  uint16_t MTU;
  uint16_t radio_crc_fail;
  uint16_t radio_queue_drops;
  uint16_t serial_crc_fail;
  uint16_t serial_tx_fail;
  uint16_t serial_short_packets;
  uint16_t serial_proto_drops;
} radio_stats_t;







#line 112
typedef nx_struct serial_header {
  nx_am_addr_t dest;
  nx_am_addr_t src;
  nx_uint8_t length;
  nx_am_group_t group;
  nx_am_id_t type;
} __attribute__((packed)) serial_header_t;




#line 120
typedef nx_struct serial_packet {
  serial_header_t header;
  nx_uint8_t data[];
} __attribute__((packed)) serial_packet_t;



#line 125
typedef nx_struct serial_metadata {
  nx_uint8_t ack;
} __attribute__((packed)) serial_metadata_t;
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/platform_message.h"
#line 45
typedef union message_header {
  cc2420_header_t cc2420;
  serial_header_t serial;
} message_header_t;



#line 50
typedef union TOSRadioFooter {
  cc2420_footer_t cc2420;
} message_footer_t;



#line 54
typedef union TOSRadioMetadata {
  cc2420_metadata_t cc2420;
} message_metadata_t;
# 19 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/message.h"
#line 14
typedef nx_struct message_t {
  nx_uint8_t header[sizeof(message_header_t )];
  nx_uint8_t data[114];
  nx_uint8_t footer[sizeof(message_footer_t )];
  nx_uint8_t metadata[sizeof(message_metadata_t )];
} __attribute__((packed)) message_t;
# 52 "/stow/lib/gcc-lib/../../msp430/include/stdint.h" 3
typedef signed char int_least8_t;
typedef int int_least16_t;
typedef long int int_least32_t;
__extension__ 
#line 55
typedef long long int int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;
__extension__ 
#line 61
typedef unsigned long long int uint_least64_t;





typedef signed char int_fast8_t;
typedef int int_fast16_t;
typedef long int int_fast32_t;
__extension__ 
#line 70
typedef long long int int_fast64_t;


typedef unsigned char uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
__extension__ 
#line 76
typedef unsigned long long int uint_fast64_t;
#line 93
__extension__ 
#line 93
typedef long long int intmax_t;
__extension__ 
#line 94
typedef unsigned long long int uintmax_t;
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/IeeeEui64.h"
enum __nesc_unnamed4277 {
#line 29
  IEEE_EUI64_LENGTH = 8
};


#line 31
typedef struct ieee_eui64 {
  uint8_t data[IEEE_EUI64_LENGTH];
} ieee_eui64_t;
# 35 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/types/Ieee154.h"
typedef uint16_t ieee154_panid_t;
typedef uint16_t ieee154_saddr_t;
typedef ieee_eui64_t ieee154_laddr_t;







#line 39
typedef struct __nesc_unnamed4278 {
  uint8_t ieee_mode : 2;
  union __nesc_unnamed4279 {
    ieee154_saddr_t saddr;
    ieee154_laddr_t laddr;
  } ieee_addr;
} ieee154_addr_t;



enum __nesc_unnamed4280 {
  IEEE154_BROADCAST_ADDR = 0xffff, 
  IEEE154_LINK_MTU = 127
};

struct ieee154_frame_addr {
  ieee154_addr_t ieee_src;
  ieee154_addr_t ieee_dst;
  ieee154_panid_t ieee_dstpan;
};

enum __nesc_unnamed4281 {
  IEEE154_MIN_HDR_SZ = 6
};
#line 74
enum ieee154_fcf_enums {
  IEEE154_FCF_FRAME_TYPE = 0, 
  IEEE154_FCF_SECURITY_ENABLED = 3, 
  IEEE154_FCF_FRAME_PENDING = 4, 
  IEEE154_FCF_ACK_REQ = 5, 
  IEEE154_FCF_INTRAPAN = 6, 
  IEEE154_FCF_DEST_ADDR_MODE = 10, 
  IEEE154_FCF_SRC_ADDR_MODE = 14
};

enum ieee154_fcf_type_enums {
  IEEE154_TYPE_BEACON = 0, 
  IEEE154_TYPE_DATA = 1, 
  IEEE154_TYPE_ACK = 2, 
  IEEE154_TYPE_MAC_CMD = 3
};

enum iee154_fcf_addr_mode_enums {
  IEEE154_ADDR_NONE = 0, 
  IEEE154_ADDR_SHORT = 2, 
  IEEE154_ADDR_EXT = 3
};
# 7 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/iovec.h"
struct ip_iovec {
  uint8_t *iov_base;
  size_t iov_len;
  struct ip_iovec *iov_next;
};


int iov_len(struct ip_iovec *iov);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/ip.h"
struct in6_addr {

  union __nesc_unnamed4282 {

    uint8_t u6_addr8[16];
    uint16_t u6_addr16[8];
    uint32_t u6_addr32[4];
  } in6_u;
};




struct sockaddr_in6 {
  uint16_t sin6_port;
  struct in6_addr sin6_addr;
};







struct ip6_hdr {
  union __nesc_unnamed4283 {
    struct ip6_hdrctl {
      uint32_t ip6_un1_flow;
      uint16_t ip6_un1_plen;
      uint8_t ip6_un1_nxt;
      uint8_t ip6_un1_hlim;
    } ip6_un1;
    uint8_t ip6_un2_vfc;
  } ip6_ctlun;
  struct in6_addr ip6_src;
  struct in6_addr ip6_dst;
} __attribute((packed)) ;
#line 103
struct ip6_ext {
  uint8_t ip6e_nxt;
  uint8_t ip6e_len;
};

struct tlv_hdr {
  uint8_t type;
  uint8_t len;
};



enum __nesc_unnamed4284 {
  IANA_ICMP = 58, 
  IANA_UDP = 17, 
  IANA_TCP = 6, 



  IPV6_HOP = 0, 
  IPV6_IPV6 = 41, 
  IPV6_ROUTING = 43, 
  IPV6_FRAG = 44, 
  IPV6_AUTH = 51, 
  IPV6_SEC = 50, 
  IPV6_NONEXT = 59, 
  IPV6_DEST = 60, 
  IPV6_MOBILITY = 135
};






struct icmp6_hdr {
  uint8_t type;
  uint8_t code;
  uint16_t cksum;
};

enum __nesc_unnamed4285 {
  ICMP_TYPE_ECHO_DEST_UNREACH = 1, 
  ICMP_TYPE_ECHO_PKT_TOO_BIG = 2, 
  ICMP_TYPE_ECHO_TIME_EXCEEDED = 3, 
  ICMP_TYPE_ECHO_PARAM_PROBLEM = 4, 
  ICMP_TYPE_ECHO_REQUEST = 128, 
  ICMP_TYPE_ECHO_REPLY = 129, 
  ICMP_TYPE_ROUTER_SOL = 133, 
  ICMP_TYPE_ROUTER_ADV = 134, 
  ICMP_TYPE_NEIGHBOR_SOL = 135, 
  ICMP_TYPE_NEIGHBOR_ADV = 136, 
  ICMP_NEIGHBOR_HOPLIMIT = 255, 

  ICMP_CODE_HOPLIMIT_EXCEEDED = 0, 
  ICMP_CODE_ASSEMBLY_EXCEEDED = 1
};




struct udp_hdr {
  uint16_t srcport;
  uint16_t dstport;
  uint16_t len;
  uint16_t chksum;
};




enum __nesc_unnamed4286 {
  TCP_FLAG_FIN = 0x1, 
  TCP_FLAG_SYN = 0x2, 
  TCP_FLAG_RST = 0x4, 
  TCP_FLAG_PSH = 0x8, 
  TCP_FLAG_ACK = 0x10, 
  TCP_FLAG_URG = 0x20, 
  TCP_FLAG_ECE = 0x40, 
  TCP_FLAG_CWR = 0x80
};

struct tcp_hdr {
  uint16_t srcport;
  uint16_t dstport;
  uint32_t seqno;
  uint32_t ackno;
  uint8_t offset;
  uint8_t flags;
  uint16_t window;
  uint16_t chksum;
  uint16_t urgent;
};




struct ip6_metadata {
  ieee154_addr_t sender;
  uint8_t lqi;
};
#line 222
struct ip6_packet {
  struct ip_iovec *ip6_data;
  struct ip6_hdr ip6_hdr;
};

struct ip6_packet_headers {

  struct ip6_hdr *hdr_ip6;
  struct ip6_ext *hdr_hop;
  struct ip6_route *hdr_route;
  struct ip6_ext *hdr_dest;

  uint8_t u_hdr;
  uint8_t *u_data;
};





void inet_pton6(char *addr, struct in6_addr *dest);
# 40 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/lib6lowpan.h"
uint8_t *ip_memcpy(uint8_t *dst0, const uint8_t *src0, uint16_t len);


uint16_t ieee154_hashaddr(ieee154_addr_t *addr);





struct packed_lowmsg {
  uint8_t headers;
  uint8_t len;
  uint8_t *data;
};

struct lowpan_reconstruct {
  uint16_t r_tag;
  uint16_t r_source_key;
  uint16_t r_size;
  uint8_t *r_buf;
  uint16_t r_bytes_rcvd;

  uint8_t r_timeout;
  struct ip6_metadata r_meta;
};

struct lowpan_ctx {
  uint16_t tag;
  uint16_t offset;
};


enum __nesc_unnamed4287 {
  LOWMSG_MESH_HDR = 1 << 0, 
  LOWMSG_BCAST_HDR = 1 << 1, 
  LOWMSG_FRAG1_HDR = 1 << 2, 
  LOWMSG_FRAGN_HDR = 1 << 3, 
  LOWMSG_NALP = 1 << 4, 
  LOWMSG_IPNH_HDR = 1 << 5
};

uint16_t getHeaderBitmap(struct packed_lowmsg *lowmsg);





uint8_t *getLowpanPayload(struct packed_lowmsg *lowmsg);








__inline uint8_t hasFrag1Header(struct packed_lowmsg *msg);
__inline uint8_t hasFragNHeader(struct packed_lowmsg *msg);
#line 123
__inline uint8_t getFragDgramTag(struct packed_lowmsg *msg, uint16_t *tag);
#line 139
uint8_t *unpack_ieee154_hdr(uint8_t *buf, struct ieee154_frame_addr *frame);
#line 174
int lowpan_frag_get(uint8_t *frag, size_t len, 
struct ip6_packet *packet, 
struct ieee154_frame_addr *frame, 
struct lowpan_ctx *ctx);

int lowpan_recon_start(struct ieee154_frame_addr *frame_addr, 
struct lowpan_reconstruct *recon, 
uint8_t *pkt, size_t len);
int lowpan_recon_add(struct lowpan_reconstruct *recon, 
uint8_t *pkt, size_t len);

enum __nesc_unnamed4288 {
  T_FAILED1 = 0, 
  T_FAILED2 = 1, 
  T_UNUSED = 2, 
  T_ACTIVE = 3, 
  T_ZOMBIE = 4
};
# 59 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/Statistics.h"
#line 40
typedef nx_struct __nesc_unnamed4289 {
  nx_uint16_t sent;
  nx_uint16_t forwarded;
  nx_uint8_t rx_drop;
  nx_uint8_t tx_drop;
  nx_uint8_t fw_drop;
  nx_uint8_t rx_total;
  nx_uint8_t encfail;
} __attribute__((packed)) 
#line 59
ip_statistics_t;







#line 62
typedef nx_struct __nesc_unnamed4290 {
  nx_uint8_t hop_limit;
  nx_uint16_t parent;
  nx_uint16_t parent_metric;
  nx_uint16_t parent_etx;
} __attribute__((packed)) route_statistics_t;










#line 69
typedef nx_struct __nesc_unnamed4291 {
  nx_uint8_t sol_rx;
  nx_uint8_t sol_tx;
  nx_uint8_t adv_rx;
  nx_uint8_t adv_tx;
  nx_uint8_t echo_rx;
  nx_uint8_t echo_tx;
  nx_uint8_t unk_rx;
  nx_uint16_t rx;
} __attribute__((packed)) icmp_statistics_t;






#line 81
typedef nx_struct __nesc_unnamed4292 {
  nx_uint16_t sent;
  nx_uint16_t rcvd;
  nx_uint16_t cksum;
} __attribute__((packed)) udp_statistics_t;



#line 87
typedef nx_struct __nesc_unnamed4293 {
  nx_uint16_t lsn;
} __attribute__((packed)) mcast_statistics_t;
# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatch.h"
enum __nesc_unnamed4294 {
  N_NEXT_HOPS = 2, 
  N_RECONSTRUCTIONS = 3, 
  N_CONCURRENT_SENDS = 3, 
  N_FRAGMENTS = 12
};
#line 46
#line 37
typedef struct __nesc_unnamed4295 {


  ieee154_addr_t dest[N_NEXT_HOPS];
  uint8_t current : 4;
  uint8_t nchoices : 4;
  uint8_t retries;
  uint8_t actRetries;
  uint16_t delay;
} send_policy_t;






#line 48
typedef struct __nesc_unnamed4296 {
  uint8_t link_fragments;
  uint8_t link_transmissions;
  uint8_t refcount;
  bool failed;
} send_info_t;




#line 55
typedef struct __nesc_unnamed4297 {
  send_info_t *info;
  message_t *msg;
} send_entry_t;







#line 60
typedef struct __nesc_unnamed4298 {
  uint8_t timeout;
  ieee154_saddr_t l2_src;
  uint16_t old_tag;
  uint16_t new_tag;
  send_info_t *s_info;
} forward_entry_t;




#line 68
typedef enum __nesc_unnamed4299 {
  S_FORWARD, 
  S_REQ
} send_type_t;
# 27 "UDPReport.h"
nx_struct udp_report {
  nx_uint16_t seqno;
  nx_uint16_t sender;
  ip_statistics_t ip;
  udp_statistics_t udp;
  icmp_statistics_t icmp;
  route_statistics_t route;
} __attribute__((packed));
# 43 "/stow/lib/gcc-lib/msp430/3.2.3/include/stdarg.h" 3
typedef __builtin_va_list __gnuc_va_list;
#line 110
typedef __gnuc_va_list va_list;
# 50 "/stow/lib/gcc-lib/../../msp430/include/stdio.h" 3
int __attribute((format(printf, 3, 4))) snprintf(char *buf, size_t size, const char *fmt, ...);
int __attribute((format(printf, 2, 3))) sprintf(char *buf, const char *fmt, ...);
# 99 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/PrintfUART.h"
char debugbuf[256];
#line 131
static inline void printfUART_init_private();
#line 300
static inline bool isTxIntrPending();
#line 313
static void UARTPutChar(char c);
#line 338
static void writedebug();
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4300 {
#line 29
  int notUsed;
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4301 {
#line 30
  int notUsed;
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4302 {
#line 31
  int notUsed;
} 
#line 31
TMicro;
# 36 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/in_cksum.h"
uint16_t msg_cksum(const struct ip6_hdr *iph, 
struct ip_iovec *data, 
uint8_t nxt_hdr);
# 35 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/support/sdk/c/blip/lib6lowpan/ip_malloc.h"
extern uint8_t heap[1500];
typedef uint16_t bndrt_t;

void ip_malloc_init();

void ip_free(void *ptr);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/table.h"
#line 27
typedef struct __nesc_unnamed4303 {
  void *data;
  uint16_t elt_len;
  uint16_t n_elts;
} table_t;

void table_init(table_t *table, void *data, uint16_t elt_len, uint16_t n_elts);

void table_map(table_t *table, void (*fn)(void *arg_0x18134d8));
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/msp430usart.h"
#line 48
typedef enum __nesc_unnamed4304 {

  USART_NONE = 0, 
  USART_UART = 1, 
  USART_UART_TX = 2, 
  USART_UART_RX = 3, 
  USART_SPI = 4, 
  USART_I2C = 5
} msp430_usartmode_t;










#line 58
typedef struct __nesc_unnamed4305 {
  unsigned int swrst : 1;
  unsigned int mm : 1;
  unsigned int sync : 1;
  unsigned int listen : 1;
  unsigned int clen : 1;
  unsigned int spb : 1;
  unsigned int pev : 1;
  unsigned int pena : 1;
} __attribute((packed))  msp430_uctl_t;









#line 69
typedef struct __nesc_unnamed4306 {
  unsigned int txept : 1;
  unsigned int stc : 1;
  unsigned int txwake : 1;
  unsigned int urxse : 1;
  unsigned int ssel : 2;
  unsigned int ckpl : 1;
  unsigned int ckph : 1;
} __attribute((packed))  msp430_utctl_t;










#line 79
typedef struct __nesc_unnamed4307 {
  unsigned int rxerr : 1;
  unsigned int rxwake : 1;
  unsigned int urxwie : 1;
  unsigned int urxeie : 1;
  unsigned int brk : 1;
  unsigned int oe : 1;
  unsigned int pe : 1;
  unsigned int fe : 1;
} __attribute((packed))  msp430_urctl_t;
#line 116
#line 99
typedef struct __nesc_unnamed4308 {
  unsigned int ubr : 16;

  unsigned int  : 1;
  unsigned int mm : 1;
  unsigned int  : 1;
  unsigned int listen : 1;
  unsigned int clen : 1;
  unsigned int  : 3;

  unsigned int  : 1;
  unsigned int stc : 1;
  unsigned int  : 2;
  unsigned int ssel : 2;
  unsigned int ckpl : 1;
  unsigned int ckph : 1;
  unsigned int  : 0;
} msp430_spi_config_t;





#line 118
typedef struct __nesc_unnamed4309 {
  uint16_t ubr;
  uint8_t uctl;
  uint8_t utctl;
} msp430_spi_registers_t;




#line 124
typedef union __nesc_unnamed4310 {
  msp430_spi_config_t spiConfig;
  msp430_spi_registers_t spiRegisters;
} msp430_spi_union_config_t;

msp430_spi_union_config_t msp430_spi_default_config = { 
{ 
.ubr = 0x0002, 
.ssel = 0x02, 
.clen = 1, 
.listen = 0, 
.mm = 1, 
.ckph = 1, 
.ckpl = 0, 
.stc = 1 } };
#line 169
#line 150
typedef enum __nesc_unnamed4311 {

  UBR_32KHZ_1200 = 0x001B, UMCTL_32KHZ_1200 = 0x94, 
  UBR_32KHZ_1800 = 0x0012, UMCTL_32KHZ_1800 = 0x84, 
  UBR_32KHZ_2400 = 0x000D, UMCTL_32KHZ_2400 = 0x6D, 
  UBR_32KHZ_4800 = 0x0006, UMCTL_32KHZ_4800 = 0x77, 
  UBR_32KHZ_9600 = 0x0003, UMCTL_32KHZ_9600 = 0x29, 

  UBR_1MHZ_1200 = 0x0369, UMCTL_1MHZ_1200 = 0x7B, 
  UBR_1MHZ_1800 = 0x0246, UMCTL_1MHZ_1800 = 0x55, 
  UBR_1MHZ_2400 = 0x01B4, UMCTL_1MHZ_2400 = 0xDF, 
  UBR_1MHZ_4800 = 0x00DA, UMCTL_1MHZ_4800 = 0xAA, 
  UBR_1MHZ_9600 = 0x006D, UMCTL_1MHZ_9600 = 0x44, 
  UBR_1MHZ_19200 = 0x0036, UMCTL_1MHZ_19200 = 0xB5, 
  UBR_1MHZ_38400 = 0x001B, UMCTL_1MHZ_38400 = 0x94, 
  UBR_1MHZ_57600 = 0x0012, UMCTL_1MHZ_57600 = 0x84, 
  UBR_1MHZ_76800 = 0x000D, UMCTL_1MHZ_76800 = 0x6D, 
  UBR_1MHZ_115200 = 0x0009, UMCTL_1MHZ_115200 = 0x10, 
  UBR_1MHZ_230400 = 0x0004, UMCTL_1MHZ_230400 = 0x55
} msp430_uart_rate_t;
#line 200
#line 171
typedef struct __nesc_unnamed4312 {
  unsigned int ubr : 16;

  unsigned int umctl : 8;

  unsigned int  : 1;
  unsigned int mm : 1;
  unsigned int  : 1;
  unsigned int listen : 1;
  unsigned int clen : 1;
  unsigned int spb : 1;
  unsigned int pev : 1;
  unsigned int pena : 1;
  unsigned int  : 0;

  unsigned int  : 3;
  unsigned int urxse : 1;
  unsigned int ssel : 2;
  unsigned int ckpl : 1;
  unsigned int  : 1;

  unsigned int  : 2;
  unsigned int urxwie : 1;
  unsigned int urxeie : 1;
  unsigned int  : 4;
  unsigned int  : 0;

  unsigned int utxe : 1;
  unsigned int urxe : 1;
} msp430_uart_config_t;








#line 202
typedef struct __nesc_unnamed4313 {
  uint16_t ubr;
  uint8_t umctl;
  uint8_t uctl;
  uint8_t utctl;
  uint8_t urctl;
  uint8_t ume;
} msp430_uart_registers_t;




#line 211
typedef union __nesc_unnamed4314 {
  msp430_uart_config_t uartConfig;
  msp430_uart_registers_t uartRegisters;
} msp430_uart_union_config_t;
#line 248
#line 240
typedef struct __nesc_unnamed4315 {
  unsigned int i2cstt : 1;
  unsigned int i2cstp : 1;
  unsigned int i2cstb : 1;
  unsigned int i2cctrx : 1;
  unsigned int i2cssel : 2;
  unsigned int i2ccrm : 1;
  unsigned int i2cword : 1;
} __attribute((packed))  msp430_i2ctctl_t;
#line 276
#line 253
typedef struct __nesc_unnamed4316 {
  unsigned int  : 1;
  unsigned int mst : 1;
  unsigned int  : 1;
  unsigned int listen : 1;
  unsigned int xa : 1;
  unsigned int  : 1;
  unsigned int txdmaen : 1;
  unsigned int rxdmaen : 1;

  unsigned int  : 4;
  unsigned int i2cssel : 2;
  unsigned int i2crm : 1;
  unsigned int i2cword : 1;

  unsigned int i2cpsc : 8;

  unsigned int i2csclh : 8;

  unsigned int i2cscll : 8;

  unsigned int i2coa : 10;
  unsigned int  : 6;
} msp430_i2c_config_t;








#line 278
typedef struct __nesc_unnamed4317 {
  uint8_t uctl;
  uint8_t i2ctctl;
  uint8_t i2cpsc;
  uint8_t i2csclh;
  uint8_t i2cscll;
  uint16_t i2coa;
} msp430_i2c_registers_t;




#line 287
typedef union __nesc_unnamed4318 {
  msp430_i2c_config_t i2cConfig;
  msp430_i2c_registers_t i2cRegisters;
} msp430_i2c_union_config_t;
#line 309
typedef uint8_t uart_speed_t;
typedef uint8_t uart_parity_t;
typedef uint8_t uart_duplex_t;

enum __nesc_unnamed4319 {
  TOS_UART_1200 = 0, 
  TOS_UART_1800 = 1, 
  TOS_UART_2400 = 2, 
  TOS_UART_4800 = 3, 
  TOS_UART_9600 = 4, 
  TOS_UART_19200 = 5, 
  TOS_UART_38400 = 6, 
  TOS_UART_57600 = 7, 
  TOS_UART_76800 = 8, 
  TOS_UART_115200 = 9, 
  TOS_UART_230400 = 10
};

enum __nesc_unnamed4320 {
  TOS_UART_OFF, 
  TOS_UART_RONLY, 
  TOS_UART_TONLY, 
  TOS_UART_DUPLEX
};

enum __nesc_unnamed4321 {
  TOS_UART_PARITY_NONE, 
  TOS_UART_PARITY_EVEN, 
  TOS_UART_PARITY_ODD
};
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430Dma.h"
enum __nesc_unnamed4322 {
  DMA_CHANNELS = 3
};

enum __nesc_unnamed4323 {
  DMA_CHANNEL0 = 0, 
  DMA_CHANNEL1 = 1, 
  DMA_CHANNEL2 = 2, 
  DMA_CHANNEL_UNKNOWN = 3
};

enum __nesc_unnamed4324 {
  DMA_CHANNEL_AVAILABLE = 0, 
  DMA_CHANNEL_IN_USE = 1
};



enum __nesc_unnamed4325 {
  DMA0TSEL_SHIFT = 0, 
  DMA1TSEL_SHIFT = 4, 
  DMA2TSEL_SHIFT = 8, 
  DMATSEL_MASK = (uint16_t )0xf, 
  DMA0TSEL_MASK = 0xf, 
  DMA1TSEL_MASK = 0xf0, 
  DMA2TSEL_MASK = 0xf00
};
#line 110
#line 93
typedef enum __nesc_unnamed4326 {
  DMA_TRIGGER_DMAREQ = 0x0, 
  DMA_TRIGGER_TACCR2 = 0x1, 
  DMA_TRIGGER_TBCCR2 = 0x2, 
  DMA_TRIGGER_URXIFG0 = 0x3, 
  DMA_TRIGGER_UTXIFG0 = 0x4, 
  DMA_TRIGGER_DAC12IFG = 0x5, 
  DMA_TRIGGER_ADC12IFGx = 0x6, 
  DMA_TRIGGER_TACCR0 = 0x7, 
  DMA_TRIGGER_TBCCR0 = 0x8, 
  DMA_TRIGGER_URXIFG1 = 0x9, 
  DMA_TRIGGER_UTXIFG1 = 0xa, 
  DMA_TRIGGER_MULT = 0xb, 
  DMA_TRIGGER_DMAxIFG = 0xe, 


  DMA_TRIGGER_DMAE0 = 0xf
} dma_trigger_t;




#line 112
typedef struct dma_channel_trigger_s {
  unsigned int trigger : 4;
  unsigned int reserved : 12;
} __attribute((packed))  dma_channel_trigger_t;



enum __nesc_unnamed4327 {
  DISABLE_NMI = 0, 
  ENABLE_NMI = 1
};

enum __nesc_unnamed4328 {
  NOT_ROUND_ROBIN = 0, 
  ROUND_ROBIN = 1
};

enum __nesc_unnamed4329 {
  NOT_ON_FETCH = 0, 
  ON_FETCH = 1
};






#line 134
typedef struct dma_state_s {
  unsigned int enableNMI : 1;
  unsigned int roundRobin : 1;
  unsigned int onFetch : 1;
  unsigned int reserved : 13;
} __attribute((packed))  dma_state_t;





enum __nesc_unnamed4330 {
  DMADT_SHIFT = 12, 
  DMADT_MASK = 0x7
};








#line 150
typedef enum __nesc_unnamed4331 {
  DMA_SINGLE_TRANSFER = 0x0, 
  DMA_BLOCK_TRANSFER = 0x1, 
  DMA_BURST_BLOCK_TRANSFER = 0x2, 
  DMA_REPEATED_SINGLE_TRANSFER = 0x4, 
  DMA_REPEATED_BLOCK_TRANSFER = 0x5, 
  DMA_REPEATED_BURST_BLOCK_TRANSFER = 0x7
} dma_transfer_mode_t;


enum __nesc_unnamed4332 {
  DMASRCINCR_SHIFT = 8, 
  DMADSTINCR_SHIFT = 10, 
  DMAINCR_MASK = 0x3
};





#line 166
typedef enum __nesc_unnamed4333 {
  DMA_ADDRESS_UNCHANGED = 0x0, 
  DMA_ADDRESS_DECREMENTED = 0x2, 
  DMA_ADDRESS_INCREMENTED = 0x3
} dma_incr_t;




#line 172
typedef enum __nesc_unnamed4334 {
  DMA_WORD = 0x0, 
  DMA_BYTE = 0x1
} dma_byte_t;





#line 178
typedef enum __nesc_unnamed4335 {
  DMA_EDGE_SENSITIVE = 0x0, 
  DMA_LEVEL_SENSITIVE = 0x1
} dma_level_t;
#line 196
#line 183
typedef struct dma_channel_state_s {
  unsigned int request : 1;
  unsigned int abort : 1;
  unsigned int interruptEnable : 1;
  unsigned int interruptFlag : 1;
  unsigned int enable : 1;
  unsigned int level : 1;
  unsigned int srcByte : 1;
  unsigned int dstByte : 1;
  unsigned int srcIncrement : 2;
  unsigned int dstIncrement : 2;
  unsigned int transferMode : 3;
  unsigned int reserved2 : 1;
} __attribute((packed))  dma_channel_state_t;
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/Resource.h"
typedef uint8_t resource_client_id_t;
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/Ds2401.h"
enum __nesc_unnamed4336 {
  DS2401_SERIAL_LENGTH = 6, 
  DS2401_DATA_LENGTH = 8
};








#line 33
typedef union ds2401_serial_t {
  uint8_t data[DS2401_DATA_LENGTH];
  struct  {
    uint8_t family_code;
    uint8_t serial[DS2401_SERIAL_LENGTH];
    uint8_t crc;
  } ;
} ds2401_serial_t;
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/chips/ds2411/PlatformIeeeEui64.h"
enum __nesc_unnamed4337 {
  IEEE_EUI64_COMPANY_ID_0 = 'U', 
  IEEE_EUI64_COMPANY_ID_1 = 'C', 
  IEEE_EUI64_COMPANY_ID_2 = 'B', 
  IEEE_EUI64_SERIAL_ID_0 = 'E', 
  IEEE_EUI64_SERIAL_ID_1 = 'P'
};
# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/CC2420TimeSyncMessage.h"
typedef nx_uint32_t timesync_radio_t;





#line 34
typedef struct timesync_footer_t {

  nx_am_id_t type;
  timesync_radio_t timestamp;
} timesync_footer_t;
# 26 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
struct in6_addr;
# 25 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMP.h"
enum __nesc_unnamed4338 {
  ICMP_EXT_TYPE_PREFIX = 3, 
  ICMP_EXT_TYPE_BEACON = 17
};


enum __nesc_unnamed4339 {

  TRICKLE_JITTER = 10240, 

  TRICKLE_PERIOD = 4096, 


  TRICKLE_MAX = TRICKLE_PERIOD << 5
};
#line 60
#line 54
typedef nx_struct icmp6_echo_hdr {
  nx_uint8_t type;
  nx_uint8_t code;
  nx_uint16_t cksum;
  nx_uint16_t ident;
  nx_uint16_t seqno;
} __attribute__((packed)) icmp_echo_hdr_t;
#line 72
#line 62
typedef nx_struct radv {
  nx_uint8_t type;
  nx_uint8_t code;
  nx_uint16_t cksum;
  nx_uint8_t hlim;
  nx_uint8_t flags;
  nx_uint16_t lifetime;
  nx_uint32_t reachable_time;
  nx_uint32_t retrans_time;
  nx_uint8_t options[0];
} __attribute__((packed)) radv_t;






#line 74
typedef nx_struct rsol {
  nx_uint8_t type;
  nx_uint8_t code;
  nx_uint16_t cksum;
  nx_uint32_t reserved;
} __attribute__((packed)) rsol_t;










#line 81
typedef nx_struct rpfx {
  nx_uint8_t type;
  nx_uint8_t length;
  nx_uint8_t pfx_len;
  nx_uint8_t flags;
  nx_uint32_t valid_lifetime;
  nx_uint32_t preferred_lifetime;
  nx_uint32_t reserved;
  nx_uint8_t prefix[16];
} __attribute__((packed)) pfx_t;







#line 92
typedef nx_struct __nesc_unnamed4340 {
  nx_uint8_t type;
  nx_uint8_t length;
  nx_uint16_t metric;
  nx_uint16_t seqno;
  nx_uint8_t pad[2];
} __attribute__((packed)) rqual_t;

struct icmp_stats {
  uint16_t seq;
  uint8_t ttl;
  uint32_t rtt;
};
# 25 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/Shell.h"
enum __nesc_unnamed4341 {
  MAX_REPLY_LEN = 128
};
typedef TMilli UDPEchoP__StatusTimer__precision_tag;
typedef ip_statistics_t UDPEchoP__IPStats__stat_str;
typedef udp_statistics_t UDPEchoP__UDPStats__stat_str;
enum /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Timer*/Msp430Timer32khzC__0____nesc_unnamed4342 {
  Msp430Timer32khzC__0__ALARM_ID = 0U
};
typedef T32khz /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__frequency_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__frequency_tag /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__precision_tag;
typedef uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__size_type;
typedef T32khz /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__frequency_tag;
typedef /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__frequency_tag /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__precision_tag;
typedef uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__size_type;
typedef TMilli /*CounterMilli32C.Transform*/TransformCounterC__0__to_precision_tag;
typedef uint32_t /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type;
typedef T32khz /*CounterMilli32C.Transform*/TransformCounterC__0__from_precision_tag;
typedef uint16_t /*CounterMilli32C.Transform*/TransformCounterC__0__from_size_type;
typedef uint32_t /*CounterMilli32C.Transform*/TransformCounterC__0__upper_count_type;
typedef /*CounterMilli32C.Transform*/TransformCounterC__0__from_precision_tag /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__precision_tag;
typedef /*CounterMilli32C.Transform*/TransformCounterC__0__from_size_type /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__size_type;
typedef /*CounterMilli32C.Transform*/TransformCounterC__0__to_precision_tag /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__precision_tag;
typedef /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__size_type;
typedef TMilli /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_precision_tag;
typedef uint32_t /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type;
typedef T32khz /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_precision_tag;
typedef uint16_t /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__size_type;
typedef TMilli /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__precision_tag;
typedef /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__precision_tag /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__precision_tag;
typedef uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type;
typedef /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__precision_tag /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__precision_tag;
typedef TMilli /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__precision_tag;
typedef /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__precision_tag /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__precision_tag;
typedef /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__precision_tag /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__precision_tag;
typedef TMilli /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__precision_tag;
typedef /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__precision_tag /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__LocalTime__precision_tag;
typedef /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__precision_tag /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__precision_tag;
typedef uint32_t /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__size_type;
typedef send_info_t IPDispatchP__SendInfoPool__t;
typedef send_entry_t *IPDispatchP__SendQueue__t;
typedef TMilli IPDispatchP__ExpireTimer__precision_tag;
typedef message_t IPDispatchP__FragPool__t;
typedef ip_statistics_t IPDispatchP__Statistics__stat_str;
typedef send_entry_t IPDispatchP__SendEntryPool__t;
typedef T32khz CC2420ControlP__StartupTimer__precision_tag;
typedef uint32_t CC2420ControlP__StartupTimer__size_type;
typedef uint16_t CC2420ControlP__ReadRssi__val_t;
enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Timer*/Msp430Timer32khzC__1____nesc_unnamed4343 {
  Msp430Timer32khzC__1__ALARM_ID = 1U
};
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__frequency_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__frequency_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__precision_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__size_type;
typedef T32khz /*Counter32khz32C.Transform*/TransformCounterC__1__to_precision_tag;
typedef uint32_t /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type;
typedef T32khz /*Counter32khz32C.Transform*/TransformCounterC__1__from_precision_tag;
typedef uint16_t /*Counter32khz32C.Transform*/TransformCounterC__1__from_size_type;
typedef uint16_t /*Counter32khz32C.Transform*/TransformCounterC__1__upper_count_type;
typedef /*Counter32khz32C.Transform*/TransformCounterC__1__from_precision_tag /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__precision_tag;
typedef /*Counter32khz32C.Transform*/TransformCounterC__1__from_size_type /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__size_type;
typedef /*Counter32khz32C.Transform*/TransformCounterC__1__to_precision_tag /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__precision_tag;
typedef /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__size_type;
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_precision_tag;
typedef uint32_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type;
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_precision_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__size_type;
enum /*CC2420ControlC.Spi*/CC2420SpiC__0____nesc_unnamed4344 {
  CC2420SpiC__0__CLIENT_ID = 0U
};
enum /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0____nesc_unnamed4345 {
  Msp430Spi0C__0__CLIENT_ID = 0U
};
enum Msp430SpiDma0P____nesc_unnamed4346 {
  Msp430SpiDma0P__DMA_CHANNELS = 3
};
enum Msp430SpiDma0P____nesc_unnamed4347 {
  Msp430SpiDma0P__DMA_CHANNEL0 = 0, Msp430SpiDma0P__DMA_CHANNEL1 = 1, Msp430SpiDma0P__DMA_CHANNEL2 = 2, Msp430SpiDma0P__DMA_CHANNEL_UNKNOWN = 3
};
enum Msp430SpiDma0P____nesc_unnamed4348 {
  Msp430SpiDma0P__DMA_CHANNEL_AVAILABLE = 0, Msp430SpiDma0P__DMA_CHANNEL_IN_USE = 1
};
enum Msp430SpiDma0P____nesc_unnamed4349 {
  Msp430SpiDma0P__DMA0TSEL_SHIFT = 0, Msp430SpiDma0P__DMA1TSEL_SHIFT = 4, Msp430SpiDma0P__DMA2TSEL_SHIFT = 8, Msp430SpiDma0P__DMATSEL_MASK = (uint16_t )0xf, Msp430SpiDma0P__DMA0TSEL_MASK = 0xf, Msp430SpiDma0P__DMA1TSEL_MASK = 0xf0, Msp430SpiDma0P__DMA2TSEL_MASK = 0xf00
};
typedef enum Msp430SpiDma0P____nesc_unnamed4350 {
  Msp430SpiDma0P__DMA_TRIGGER_DMAREQ = 0x0, Msp430SpiDma0P__DMA_TRIGGER_TACCR2 = 0x1, Msp430SpiDma0P__DMA_TRIGGER_TBCCR2 = 0x2, Msp430SpiDma0P__DMA_TRIGGER_URXIFG0 = 0x3, Msp430SpiDma0P__DMA_TRIGGER_UTXIFG0 = 0x4, Msp430SpiDma0P__DMA_TRIGGER_DAC12IFG = 0x5, Msp430SpiDma0P__DMA_TRIGGER_ADC12IFGx = 0x6, Msp430SpiDma0P__DMA_TRIGGER_TACCR0 = 0x7, Msp430SpiDma0P__DMA_TRIGGER_TBCCR0 = 0x8, Msp430SpiDma0P__DMA_TRIGGER_URXIFG1 = 0x9, Msp430SpiDma0P__DMA_TRIGGER_UTXIFG1 = 0xa, Msp430SpiDma0P__DMA_TRIGGER_MULT = 0xb, Msp430SpiDma0P__DMA_TRIGGER_DMAxIFG = 0xe, Msp430SpiDma0P__DMA_TRIGGER_DMAE0 = 0xf
} Msp430SpiDma0P__dma_trigger_t;
typedef struct Msp430SpiDma0P__dma_channel_trigger_s {
  unsigned int trigger : 4;
  unsigned int reserved : 12;
} __attribute((packed))  Msp430SpiDma0P__dma_channel_trigger_t;
enum Msp430SpiDma0P____nesc_unnamed4351 {
  Msp430SpiDma0P__DISABLE_NMI = 0, Msp430SpiDma0P__ENABLE_NMI = 1
};
enum Msp430SpiDma0P____nesc_unnamed4352 {
  Msp430SpiDma0P__NOT_ROUND_ROBIN = 0, Msp430SpiDma0P__ROUND_ROBIN = 1
};
enum Msp430SpiDma0P____nesc_unnamed4353 {
  Msp430SpiDma0P__NOT_ON_FETCH = 0, Msp430SpiDma0P__ON_FETCH = 1
};
typedef struct Msp430SpiDma0P__dma_state_s {
  unsigned int enableNMI : 1;
  unsigned int roundRobin : 1;
  unsigned int onFetch : 1;
  unsigned int reserved : 13;
} __attribute((packed))  Msp430SpiDma0P__dma_state_t;
enum Msp430SpiDma0P____nesc_unnamed4354 {
  Msp430SpiDma0P__DMADT_SHIFT = 12, Msp430SpiDma0P__DMADT_MASK = 0x7
};
typedef enum Msp430SpiDma0P____nesc_unnamed4355 {
  Msp430SpiDma0P__DMA_SINGLE_TRANSFER = 0x0, Msp430SpiDma0P__DMA_BLOCK_TRANSFER = 0x1, Msp430SpiDma0P__DMA_BURST_BLOCK_TRANSFER = 0x2, Msp430SpiDma0P__DMA_REPEATED_SINGLE_TRANSFER = 0x4, Msp430SpiDma0P__DMA_REPEATED_BLOCK_TRANSFER = 0x5, Msp430SpiDma0P__DMA_REPEATED_BURST_BLOCK_TRANSFER = 0x7
} Msp430SpiDma0P__dma_transfer_mode_t;
enum Msp430SpiDma0P____nesc_unnamed4356 {
  Msp430SpiDma0P__DMASRCINCR_SHIFT = 8, Msp430SpiDma0P__DMADSTINCR_SHIFT = 10, Msp430SpiDma0P__DMAINCR_MASK = 0x3
};
typedef enum Msp430SpiDma0P____nesc_unnamed4357 {
  Msp430SpiDma0P__DMA_ADDRESS_UNCHANGED = 0x0, Msp430SpiDma0P__DMA_ADDRESS_DECREMENTED = 0x2, Msp430SpiDma0P__DMA_ADDRESS_INCREMENTED = 0x3
} Msp430SpiDma0P__dma_incr_t;
typedef enum Msp430SpiDma0P____nesc_unnamed4358 {
  Msp430SpiDma0P__DMA_WORD = 0x0, Msp430SpiDma0P__DMA_BYTE = 0x1
} Msp430SpiDma0P__dma_byte_t;
typedef enum Msp430SpiDma0P____nesc_unnamed4359 {
  Msp430SpiDma0P__DMA_EDGE_SENSITIVE = 0x0, Msp430SpiDma0P__DMA_LEVEL_SENSITIVE = 0x1
} Msp430SpiDma0P__dma_level_t;
typedef struct Msp430SpiDma0P__dma_channel_state_s {
  unsigned int request : 1;
  unsigned int abort : 1;
  unsigned int interruptEnable : 1;
  unsigned int interruptFlag : 1;
  unsigned int enable : 1;
  unsigned int level : 1;
  unsigned int srcByte : 1;
  unsigned int dstByte : 1;
  unsigned int srcIncrement : 2;
  unsigned int dstIncrement : 2;
  unsigned int transferMode : 3;
  unsigned int reserved2 : 1;
} __attribute((packed))  Msp430SpiDma0P__dma_channel_state_t;
enum /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0____nesc_unnamed4360 {
  Msp430Usart0C__0__CLIENT_ID = 0U
};
enum /*CC2420ControlC.SyncSpiC*/CC2420SpiC__1____nesc_unnamed4361 {
  CC2420SpiC__1__CLIENT_ID = 1U
};
enum /*CC2420ControlC.RssiResource*/CC2420SpiC__2____nesc_unnamed4362 {
  CC2420SpiC__2__CLIENT_ID = 2U
};
typedef TMicro OneWireMasterC__BusyWaitMicro__precision_tag;
typedef uint16_t OneWireMasterC__BusyWaitMicro__size_type;
typedef TMicro /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__precision_tag;
typedef uint16_t /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type;
typedef /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__precision_tag /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__precision_tag;
typedef /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__size_type;
typedef /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__precision_tag /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__precision_tag;
typedef /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__size_type;
typedef TMicro /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__frequency_tag;
typedef /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__frequency_tag /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__precision_tag;
typedef uint16_t /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__size_type;
typedef T32khz CC2420TransmitP__PacketTimeStamp__precision_tag;
typedef uint32_t CC2420TransmitP__PacketTimeStamp__size_type;
typedef T32khz CC2420TransmitP__BackoffTimer__precision_tag;
typedef uint32_t CC2420TransmitP__BackoffTimer__size_type;
enum /*CC2420TransmitC.Spi*/CC2420SpiC__3____nesc_unnamed4363 {
  CC2420SpiC__3__CLIENT_ID = 3U
};
typedef T32khz CC2420ReceiveP__PacketTimeStamp__precision_tag;
typedef uint32_t CC2420ReceiveP__PacketTimeStamp__size_type;
typedef T32khz CC2420PacketP__PacketTimeStamp32khz__precision_tag;
typedef uint32_t CC2420PacketP__PacketTimeStamp32khz__size_type;
typedef T32khz CC2420PacketP__LocalTime32khz__precision_tag;
typedef TMilli CC2420PacketP__LocalTimeMilli__precision_tag;
typedef TMilli CC2420PacketP__PacketTimeStampMilli__precision_tag;
typedef uint32_t CC2420PacketP__PacketTimeStampMilli__size_type;
typedef T32khz /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__precision_tag;
typedef /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__precision_tag /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__LocalTime__precision_tag;
typedef /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__precision_tag /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__precision_tag;
typedef uint32_t /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__size_type;
enum /*CC2420ReceiveC.Spi*/CC2420SpiC__4____nesc_unnamed4364 {
  CC2420SpiC__4__CLIENT_ID = 4U
};
typedef uint16_t RandomMlcgC__SeedInit__parameter;
enum CC2420TinyosNetworkC____nesc_unnamed4365 {
  CC2420TinyosNetworkC__TINYOS_N_NETWORKS = 0U
};
typedef TMilli PacketLinkP__DelayTimer__precision_tag;
typedef message_t /*IPDispatchC.FragPool*/PoolC__0__pool_t;
typedef /*IPDispatchC.FragPool*/PoolC__0__pool_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t;
typedef /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__t;
typedef send_entry_t /*IPDispatchC.SendEntryPool*/PoolC__1__pool_t;
typedef /*IPDispatchC.SendEntryPool*/PoolC__1__pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t;
typedef /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__t;
typedef send_entry_t */*IPDispatchC.QueueC*/QueueC__0__queue_t;
typedef /*IPDispatchC.QueueC*/QueueC__0__queue_t /*IPDispatchC.QueueC*/QueueC__0__Queue__t;
typedef send_info_t /*IPDispatchC.SendInfoPool*/PoolC__2__pool_t;
typedef /*IPDispatchC.SendInfoPool*/PoolC__2__pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t;
typedef /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__t;
typedef udp_statistics_t UdpP__Statistics__stat_str;
typedef TMilli UDPShellP__Uptime__precision_tag;
typedef uint32_t UDPShellP__Uptime__size_type;
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t PlatformP__Init__init(void );
# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
static void Msp430ClockP__Msp430ClockInit__defaultInitClocks(void );
#line 32
static void Msp430ClockP__Msp430ClockInit__default__initTimerB(void );



static void Msp430ClockP__Msp430ClockInit__defaultInitTimerA(void );
#line 31
static void Msp430ClockP__Msp430ClockInit__default__initTimerA(void );





static void Msp430ClockP__Msp430ClockInit__defaultInitTimerB(void );
#line 34
static void Msp430ClockP__Msp430ClockInit__defaultSetupDcoCalibrate(void );
#line 29
static void Msp430ClockP__Msp430ClockInit__default__setupDcoCalibrate(void );
static void Msp430ClockP__Msp430ClockInit__default__initClocks(void );
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static mcu_power_t Msp430ClockP__McuPowerOverride__lowestState(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t Msp430ClockP__Init__init(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX0__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Overflow__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX1__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__default__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x138b9c0);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__get(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX0__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Overflow__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX1__fired(void );
#line 28
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__default__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x138b9c0);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get(void );
static bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__isOverflowPending(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__getControl(void );
#line 46
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__enableEvents(void );
#line 36
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__setControlAsCompare(void );










static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__disableEvents(void );
#line 33
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__clearPendingInterrupt(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Event__fired(void );
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEvent(uint16_t time);

static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEventFromNow(uint16_t delta);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__getEvent(void );
#line 57
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__clearOverflow(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__setControlAsCapture(uint8_t cm);
#line 31
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__getControl(void );
#line 46
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__enableEvents(void );
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__disableEvents(void );
#line 33
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__clearPendingInterrupt(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__getControl(void );
#line 46
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__enableEvents(void );
#line 36
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__setControlAsCompare(void );










static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__disableEvents(void );
#line 33
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__clearPendingInterrupt(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Event__fired(void );
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEvent(uint16_t time);

static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEventFromNow(uint16_t delta);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Timer__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__getEvent(void );
#line 75
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__default__captured(uint16_t time);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Control__getControl(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Event__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__default__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Timer__overflow(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
static void McuSleepC__McuSleep__sleep(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t MotePlatformC__Init__init(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t SchedulerBasicP__TaskBasic__postTask(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x12e0d30);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void SchedulerBasicP__TaskBasic__default__runTask(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x12e0d30);
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
static void SchedulerBasicP__Scheduler__init(void );
#line 61
static void SchedulerBasicP__Scheduler__taskLoop(void );
#line 54
static bool SchedulerBasicP__Scheduler__runNextTask(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t LedsP__Init__init(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
static void LedsP__Leds__led0Toggle(void );
#line 89
static void LedsP__Leds__led2Toggle(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__get(void );
#line 52
static uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__getRaw(void );






static bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__get(void );
#line 52
static uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__getRaw(void );
#line 64
static void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__makeInput(void );
#line 59
static bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__get(void );
#line 52
static uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__getRaw(void );
#line 64
static void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeInput(void );






static void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeOutput(void );
#line 59
static bool /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__get(void );
#line 52
static uint8_t /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__getRaw(void );
#line 34
static void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__set(void );




static void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__clr(void );
#line 85
static void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectIOFunc(void );
#line 78
static void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectModuleFunc(void );






static void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectIOFunc(void );
#line 78
static void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectModuleFunc(void );






static void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectIOFunc(void );
#line 78
static void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectModuleFunc(void );






static void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP__20__IO__selectIOFunc(void );
#line 85
static void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP__21__IO__selectIOFunc(void );
#line 44
static void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__toggle(void );
#line 71
static void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__set(void );
#line 64
static void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__makeInput(void );
#line 59
static bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__get(void );
#line 85
static void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectIOFunc(void );
#line 52
static uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__getRaw(void );
#line 78
static void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectModuleFunc(void );
#line 71
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__set(void );




static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__clr(void );
#line 71
static void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__set(void );
#line 71
static void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__set(void );




static void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__clr(void );
#line 71
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__set(void );




static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__clr(void );




static void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__toggle(void );
#line 71
static void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__makeOutput(void );
#line 34
static void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__set(void );
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__toggle(void );



static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__makeOutput(void );
#line 29
static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__set(void );





static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__makeOutput(void );
#line 29
static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__set(void );

static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__toggle(void );



static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__makeOutput(void );
#line 29
static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__set(void );
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void UDPEchoP__StatusTimer__fired(void );
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static void UDPEchoP__Boot__booted(void );
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static void UDPEchoP__Status__recvfrom(struct sockaddr_in6 *src, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static void UDPEchoP__RadioControl__startDone(error_t error);
#line 117
static void UDPEchoP__RadioControl__stopDone(error_t error);
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static void UDPEchoP__Echo__recvfrom(struct sockaddr_in6 *src, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__overflow(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__startAt(/*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__size_type t0, /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__size_type dt);
#line 62
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__stop(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Init__init(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__overflow(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__size_type /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__get(void );






static bool /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__isOverflowPending(void );










static void /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__overflow(void );
#line 53
static /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__size_type /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__get(void );
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getNow(void );
#line 92
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__size_type dt);
#line 105
static /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getAlarm(void );
#line 62
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__stop(void );




static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__fired(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__overflow(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__runTask(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__fired(void );
# 125 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__getNow(void );
#line 118
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__startOneShotAt(uint32_t t0, uint32_t dt);
#line 67
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__stop(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__runTask(void );
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__fired(void );
#line 72
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__default__fired(
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x17ae3c8);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startPeriodic(
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x17ae3c8, 
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t dt);








static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startOneShot(
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x17ae3c8, 
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t dt);




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__stop(
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x17ae3c8);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__overflow(void );
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static error_t IPDispatchP__SplitControl__start(void );
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static void IPDispatchP__Boot__booted(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static void IPDispatchP__RadioControl__startDone(error_t error);
#line 117
static void IPDispatchP__RadioControl__stopDone(error_t error);
# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static error_t IPDispatchP__IPLower__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg);
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void IPDispatchP__ExpireTimer__fired(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void IPDispatchP__sendTask__runTask(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
static void IPDispatchP__Statistics__clear(void );
#line 29
static void IPDispatchP__Statistics__get(IPDispatchP__Statistics__stat_str *stats);
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void IPDispatchP__Ieee154Send__sendDone(
#line 85
message_t * msg, 



error_t error);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



IPDispatchP__Ieee154Receive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static error_t CC2420CsmaP__SplitControl__start(void );
#line 109
static error_t CC2420CsmaP__SplitControl__stop(void );
# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static void CC2420CsmaP__RadioBackoff__default__requestCca(message_t * msg);
#line 81
static void CC2420CsmaP__RadioBackoff__default__requestInitialBackoff(message_t * msg);






static void CC2420CsmaP__RadioBackoff__default__requestCongestionBackoff(message_t * msg);
#line 81
static void CC2420CsmaP__SubBackoff__requestInitialBackoff(message_t * msg);






static void CC2420CsmaP__SubBackoff__requestCongestionBackoff(message_t * msg);
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static void CC2420CsmaP__CC2420Transmit__sendDone(message_t * p_msg, error_t error);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t CC2420CsmaP__Send__send(
#line 56
message_t * msg, 







uint8_t len);
# 76 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
static void CC2420CsmaP__CC2420Power__startOscillatorDone(void );
#line 56
static void CC2420CsmaP__CC2420Power__startVRegDone(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420CsmaP__Resource__granted(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420CsmaP__sendDone_task__runTask(void );
#line 64
static void CC2420CsmaP__stopDone_task__runTask(void );
#line 64
static void CC2420CsmaP__startDone_task__runTask(void );
# 91 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static bool CC2420ControlP__CC2420Config__isAddressRecognitionEnabled(void );
#line 115
static bool CC2420ControlP__CC2420Config__isAutoAckEnabled(void );
#line 110
static bool CC2420ControlP__CC2420Config__isHwAutoAckDefault(void );
#line 64
static ieee_eui64_t CC2420ControlP__CC2420Config__getExtAddr(void );




static uint16_t CC2420ControlP__CC2420Config__getShortAddr(void );
#line 52
static error_t CC2420ControlP__CC2420Config__sync(void );
#line 75
static uint16_t CC2420ControlP__CC2420Config__getPanAddr(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void CC2420ControlP__StartupTimer__fired(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Read.nc"
static void CC2420ControlP__ReadRssi__default__readDone(error_t result, CC2420ControlP__ReadRssi__val_t val);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420ControlP__syncDone__runTask(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t CC2420ControlP__Init__init(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420ControlP__SpiResource__granted(void );
#line 92
static void CC2420ControlP__SyncResource__granted(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
static error_t CC2420ControlP__CC2420Power__startOscillator(void );
#line 90
static error_t CC2420ControlP__CC2420Power__rxOn(void );
#line 51
static error_t CC2420ControlP__CC2420Power__startVReg(void );
#line 63
static error_t CC2420ControlP__CC2420Power__stopVReg(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420ControlP__sync__runTask(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420ControlP__Resource__release(void );
#line 78
static error_t CC2420ControlP__Resource__request(void );
# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static void CC2420ControlP__InterruptCCA__fired(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420ControlP__RssiResource__granted(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__fired(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__overflow(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__size_type dt);
#line 62
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__stop(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Init__init(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__overflow(void );
#line 53
static /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__size_type /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__get(void );
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__getNow(void );
#line 92
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__size_type dt);
#line 55
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__size_type dt);






static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__stop(void );




static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__fired(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__overflow(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__makeInput(void );
#line 32
static bool /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__get(void );


static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__makeOutput(void );
#line 29
static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set(void );
static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr(void );

static bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__GeneralIO__get(void );
#line 32
static bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__GeneralIO__get(void );


static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__makeOutput(void );
#line 29
static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__set(void );
static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__clr(void );


static void /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__makeInput(void );
#line 32
static bool /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__get(void );


static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__makeOutput(void );
#line 29
static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__set(void );
static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__clr(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__captured(uint16_t time);
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureFallingEdge(void );
#line 55
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__disable(void );
#line 42
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureRisingEdge(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static void HplMsp430InterruptP__Port14__clear(void );
#line 36
static void HplMsp430InterruptP__Port14__disable(void );
#line 56
static void HplMsp430InterruptP__Port14__edge(bool low_to_high);
#line 31
static void HplMsp430InterruptP__Port14__enable(void );









static void HplMsp430InterruptP__Port26__clear(void );
#line 61
static void HplMsp430InterruptP__Port26__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port17__clear(void );
#line 61
static void HplMsp430InterruptP__Port17__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port21__clear(void );
#line 61
static void HplMsp430InterruptP__Port21__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port12__clear(void );
#line 61
static void HplMsp430InterruptP__Port12__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port24__clear(void );
#line 61
static void HplMsp430InterruptP__Port24__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port15__clear(void );
#line 61
static void HplMsp430InterruptP__Port15__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port27__clear(void );
#line 61
static void HplMsp430InterruptP__Port27__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port10__clear(void );
#line 36
static void HplMsp430InterruptP__Port10__disable(void );
#line 56
static void HplMsp430InterruptP__Port10__edge(bool low_to_high);
#line 31
static void HplMsp430InterruptP__Port10__enable(void );









static void HplMsp430InterruptP__Port22__clear(void );
#line 61
static void HplMsp430InterruptP__Port22__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port13__clear(void );
#line 61
static void HplMsp430InterruptP__Port13__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port25__clear(void );
#line 61
static void HplMsp430InterruptP__Port25__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port16__clear(void );
#line 61
static void HplMsp430InterruptP__Port16__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port20__clear(void );
#line 61
static void HplMsp430InterruptP__Port20__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port11__clear(void );
#line 61
static void HplMsp430InterruptP__Port11__default__fired(void );
#line 41
static void HplMsp430InterruptP__Port23__clear(void );
#line 61
static void HplMsp430InterruptP__Port23__default__fired(void );
#line 61
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__fired(void );
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__disable(void );
#line 42
static error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__enableRisingEdge(void );
# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__fired(void );
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__disable(void );
#line 43
static error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__enableFallingEdge(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static void CC2420SpiP__SpiPacket__sendDone(
#line 64
uint8_t * txBuf, 
uint8_t * rxBuf, 





uint16_t len, 
error_t error);
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static error_t CC2420SpiP__Fifo__continueRead(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length);
#line 91
static void CC2420SpiP__Fifo__default__writeDone(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length, error_t error);
#line 82
static cc2420_status_t CC2420SpiP__Fifo__write(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length);
#line 51
static cc2420_status_t CC2420SpiP__Fifo__beginRead(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length);
#line 71
static void CC2420SpiP__Fifo__default__readDone(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length, error_t error);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static void CC2420SpiP__ChipSpiResource__abortRelease(void );







static error_t CC2420SpiP__ChipSpiResource__attemptRelease(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420SpiP__SpiResource__granted(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static cc2420_status_t CC2420SpiP__Ram__write(
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint16_t arg_0x1b31820, 
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
uint8_t offset, uint8_t * data, uint8_t length);
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420SpiP__Reg__read(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b2f010, 
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
uint16_t *data);







static cc2420_status_t CC2420SpiP__Reg__write(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b2f010, 
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
uint16_t data);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420SpiP__Resource__release(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420SpiP__Resource__immediateRequest(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420SpiP__Resource__request(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420SpiP__Resource__default__granted(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static bool CC2420SpiP__Resource__isOwner(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420SpiP__grant__runTask(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420SpiP__Strobe__strobe(
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b2f7c8);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t StateImplP__Init__init(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static uint8_t StateImplP__State__getState(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static void StateImplP__State__toIdle(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48);
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static bool StateImplP__State__isState(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48, 
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t myState);
#line 61
static bool StateImplP__State__isIdle(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48);
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static error_t StateImplP__State__requestState(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48, 
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t reqState);





static void StateImplP__State__forceState(
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1baaa48, 
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t reqState);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__unconfigure(
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07db0);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__configure(
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07db0);
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__send(
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c068d0, 
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t * txBuf, 

uint8_t * rxBuf, 








uint16_t len);
#line 71
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__default__sendDone(
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c068d0, 
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t * txBuf, 
uint8_t * rxBuf, 





uint16_t len, 
error_t error);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static msp430_spi_union_config_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__default__getConfig(
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3b970);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
static uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiByte__write(uint8_t tx);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__transferDone(error_t success);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__release(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__immediateRequest(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__request(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__granted(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__isOwner(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__release(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__immediateRequest(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__request(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__default__granted(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__isOwner(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__transferDone(error_t success);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__rxDone(uint8_t data);
#line 49
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__txDone(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__runTask(void );
# 197 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static void HplMsp430Usart0P__Usart__clrRxIntr(void );
#line 97
static void HplMsp430Usart0P__Usart__resetUsart(bool reset);
#line 179
static void HplMsp430Usart0P__Usart__disableIntr(void );
#line 90
static void HplMsp430Usart0P__Usart__setUmctl(uint8_t umctl);
#line 207
static void HplMsp430Usart0P__Usart__clrIntr(void );
#line 80
static void HplMsp430Usart0P__Usart__setUbr(uint16_t ubr);
#line 224
static void HplMsp430Usart0P__Usart__tx(uint8_t data);
#line 128
static void HplMsp430Usart0P__Usart__disableUart(void );
#line 153
static void HplMsp430Usart0P__Usart__enableSpi(void );
#line 168
static void HplMsp430Usart0P__Usart__setModeSpi(msp430_spi_union_config_t *config);
#line 231
static uint8_t HplMsp430Usart0P__Usart__rx(void );
#line 192
static bool HplMsp430Usart0P__Usart__isRxIntrPending(void );
#line 158
static void HplMsp430Usart0P__Usart__disableSpi(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaInterrupt.nc"
static void /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__Interrupt__fired(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static error_t /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setTrigger(dma_trigger_t trigger);
#line 65
static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setStateRaw(uint16_t state, uint16_t trigger, void *src, void *dest, uint16_t size);
#line 49
static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__enableDMA(void );
#line 64
static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size);
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaInterrupt.nc"
static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__Interrupt__fired(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static error_t /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setTrigger(dma_trigger_t trigger);
#line 65
static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setStateRaw(uint16_t state, uint16_t trigger, void *src, void *dest, uint16_t size);
#line 49
static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__enableDMA(void );
#line 64
static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size);
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaInterrupt.nc"
static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__Interrupt__fired(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__HplChannel__transferDone(error_t success);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__default__transferDone(error_t success);
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__transferDone(error_t success);
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 73
static error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__startTransfer(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__transferDone(error_t success);
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 73
static error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__startTransfer(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void Msp430DmaControlP__HplChannel1__transferDone(error_t success);
#line 74
static void Msp430DmaControlP__HplChannel2__transferDone(error_t success);
#line 74
static void Msp430DmaControlP__HplChannel0__transferDone(error_t success);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__rxDone(
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60288, 
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t data);
#line 49
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__txDone(
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60288);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawI2CInterrupts__fired(void );
#line 39
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__default__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60b08);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__rxDone(uint8_t data);
#line 49
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__txDone(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__Init__init(void );
# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__enqueue(resource_client_id_t id);
#line 43
static bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEmpty(void );








static bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEnqueued(resource_client_id_t id);







static resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__dequeue(void );
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__requested(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e70690);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__immediateRequested(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e70690);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__unconfigure(
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e6ea58);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__configure(
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e6ea58);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__release(void );
#line 73
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__requested(void );
#line 46
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__granted(void );
#line 81
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__immediateRequested(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__release(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__immediateRequest(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__request(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__default__granted(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__isOwner(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__inUse(void );







static uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__userId(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__runTask(void );
# 7 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static void HplMsp430I2C0P__HplI2C__clearModeI2C(void );
#line 6
static bool HplMsp430I2C0P__HplI2C__isI2C(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static am_addr_t ActiveMessageAddressC__amAddress(void );
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static am_addr_t ActiveMessageAddressC__ActiveMessageAddress__amAddress(void );




static am_group_t ActiveMessageAddressC__ActiveMessageAddress__amGroup(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
static bool OneWireMasterC__OneWire__readBit(void );
#line 41
static void OneWireMasterC__OneWire__release(void );
#line 54
static void OneWireMasterC__OneWire__writeZero(void );
#line 37
static void OneWireMasterC__OneWire__init(void );
#line 59
static void OneWireMasterC__OneWire__writeByte(uint8_t b);
#line 46
static error_t OneWireMasterC__OneWire__reset(void );
#line 33
static void OneWireMasterC__OneWire__idle(void );
#line 68
static uint8_t OneWireMasterC__OneWire__readByte(void );
#line 50
static void OneWireMasterC__OneWire__writeOne(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/HplDs2401.nc"
static error_t HplDs2401C__Hpl__read(ds2401_serial_t *rom);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWait.nc"
static void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__wait(/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__size_type dt);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__overflow(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__overflow(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__size_type /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__get(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeInput(void );
#line 32
static bool /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__get(void );


static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeOutput(void );
#line 29
static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__set(void );
static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__clr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
static ieee_eui64_t Ds2401ToIeeeEui64C__LocalIeeeEui64__getId(void );
#line 37
static ieee_eui64_t CachedIeeeEui64P__LocalIeeeEui64__getId(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t CachedIeeeEui64P__Init__init(void );
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static void CC2420TransmitP__RadioBackoff__setCongestionBackoff(uint16_t backoffTime);
#line 60
static void CC2420TransmitP__RadioBackoff__setInitialBackoff(uint16_t backoffTime);
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static void CC2420TransmitP__CaptureSFD__captured(uint16_t time);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void CC2420TransmitP__BackoffTimer__fired(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static void CC2420TransmitP__CC2420Receive__receive(uint8_t type, message_t * message);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static error_t CC2420TransmitP__Send__send(message_t * p_msg, bool useCca);
# 24 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static void CC2420TransmitP__ChipSpiResource__releasing(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t CC2420TransmitP__Init__init(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420TransmitP__SpiResource__granted(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static error_t CC2420TransmitP__StdControl__start(void );









static error_t CC2420TransmitP__StdControl__stop(void );
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static void CC2420TransmitP__TXFIFO__writeDone(uint8_t * data, uint8_t length, error_t error);
#line 71
static void CC2420TransmitP__TXFIFO__readDone(uint8_t * data, uint8_t length, error_t error);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static void CC2420ReceiveP__CC2420Config__syncDone(error_t error);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420ReceiveP__receiveDone_task__runTask(void );
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static void CC2420ReceiveP__CC2420Receive__sfd_dropped(void );
#line 49
static void CC2420ReceiveP__CC2420Receive__sfd(uint32_t time);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t CC2420ReceiveP__Init__init(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420ReceiveP__SpiResource__granted(void );
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static void CC2420ReceiveP__RXFIFO__writeDone(uint8_t * data, uint8_t length, error_t error);
#line 71
static void CC2420ReceiveP__RXFIFO__readDone(uint8_t * data, uint8_t length, error_t error);
# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static void CC2420ReceiveP__InterruptFIFOP__fired(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static error_t CC2420ReceiveP__StdControl__start(void );









static error_t CC2420ReceiveP__StdControl__stop(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Packet.nc"
static uint8_t CC2420PacketP__CC2420Packet__getNetwork(message_t *p_msg);
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static void CC2420PacketP__PacketTimeStamp32khz__clear(
#line 55
message_t * msg);
#line 67
static void CC2420PacketP__PacketTimeStamp32khz__set(
#line 62
message_t * msg, 




CC2420PacketP__PacketTimeStamp32khz__size_type value);
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * CC2420PacketP__CC2420PacketBody__getHeader(message_t * msg);










static cc2420_metadata_t * CC2420PacketP__CC2420PacketBody__getMetadata(message_t * msg);
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
static uint8_t CC2420PacketP__PacketTimeSyncOffset__get(
#line 42
message_t * msg);
#line 39
static bool CC2420PacketP__PacketTimeSyncOffset__isSet(
#line 35
message_t * msg);
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static error_t CC2420PacketP__Acks__requestAck(
#line 42
message_t * msg);
#line 74
static bool CC2420PacketP__Acks__wasAcked(
#line 69
message_t * msg);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__overflow(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static uint16_t RandomMlcgC__Random__rand16(void );
#line 35
static uint32_t RandomMlcgC__Random__rand32(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t RandomMlcgC__Init__init(void );
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void UniqueSendP__SubSend__sendDone(
#line 85
message_t * msg, 



error_t error);
#line 64
static error_t UniqueSendP__Send__send(
#line 56
message_t * msg, 







uint8_t len);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t UniqueSendP__Init__init(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



UniqueReceiveP__SubReceive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t UniqueReceiveP__Init__init(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



UniqueReceiveP__DuplicateReceive__default__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void CC2420TinyosNetworkP__SubSend__sendDone(
#line 85
message_t * msg, 



error_t error);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



CC2420TinyosNetworkP__SubReceive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void CC2420TinyosNetworkP__grantTask__runTask(void );
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void CC2420TinyosNetworkP__ActiveSend__default__sendDone(
#line 85
message_t * msg, 



error_t error);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420TinyosNetworkP__Resource__release(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
uint8_t arg_0x222b8a0);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420TinyosNetworkP__Resource__default__granted(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
uint8_t arg_0x222b8a0);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t CC2420TinyosNetworkP__BareSend__send(
#line 56
message_t * msg, 







uint8_t len);
#line 114
static 
#line 112
void * 

CC2420TinyosNetworkP__BareSend__getPayload(
#line 111
message_t * msg, 


uint8_t len);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



CC2420TinyosNetworkP__ActiveReceive__default__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
static void CC2420TinyosNetworkP__BarePacket__clear(
#line 51
message_t * msg);
#line 67
static uint8_t CC2420TinyosNetworkP__BarePacket__payloadLength(
#line 63
message_t * msg);
#line 95
static uint8_t CC2420TinyosNetworkP__BarePacket__maxPayloadLength(void );
#line 83
static void CC2420TinyosNetworkP__BarePacket__setPayloadLength(
#line 79
message_t * msg, 



uint8_t len);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__Init__init(void );
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static bool /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__isEmpty(void );
#line 60
static resource_client_id_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__dequeue(void );
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void PacketLinkP__SubSend__sendDone(
#line 85
message_t * msg, 



error_t error);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void PacketLinkP__send__runTask(void );
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void PacketLinkP__DelayTimer__fired(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t PacketLinkP__Send__send(
#line 56
message_t * msg, 







uint8_t len);
# 65 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
static uint16_t PacketLinkP__PacketLink__getRetryDelay(
#line 62
message_t * msg);
#line 46
static void PacketLinkP__PacketLink__setRetries(
#line 42
message_t * msg, 



uint16_t maxRetries);
#line 59
static uint16_t PacketLinkP__PacketLink__getRetries(
#line 56
message_t * msg);
#line 53
static void PacketLinkP__PacketLink__setRetryDelay(message_t *msg, uint16_t retryDelay);
#line 71
static bool PacketLinkP__PacketLink__wasDelivered(
#line 68
message_t * msg);
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
/*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__t * 


/*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__get(void );
#line 89
static error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__put(
#line 85
/*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__t * newVal);
#line 72
static uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__size(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Init__init(void );
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__t * 


/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__get(void );
#line 89
static error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__put(
#line 85
/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__t * newVal);
#line 72
static uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__size(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Init__init(void );
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
static 
#line 71
/*IPDispatchC.QueueC*/QueueC__0__Queue__t  

/*IPDispatchC.QueueC*/QueueC__0__Queue__head(void );
#line 90
static error_t /*IPDispatchC.QueueC*/QueueC__0__Queue__enqueue(
#line 86
/*IPDispatchC.QueueC*/QueueC__0__Queue__t  newVal);
#line 65
static uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__maxSize(void );
#line 81
static 
#line 79
/*IPDispatchC.QueueC*/QueueC__0__Queue__t  

/*IPDispatchC.QueueC*/QueueC__0__Queue__dequeue(void );
#line 50
static bool /*IPDispatchC.QueueC*/QueueC__0__Queue__empty(void );







static uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__size(void );
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__t * 


/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__get(void );
#line 89
static error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__put(
#line 85
/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__t * newVal);
#line 72
static uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__size(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Init__init(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static void IPAddressP__CC2420Config__syncDone(error_t error);
# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
static bool IPAddressP__IPAddress__getLLAddr(struct in6_addr *addr);
#line 51
static bool IPAddressP__IPAddress__isLocalAddress(struct in6_addr *addr);
#line 39
static bool IPAddressP__IPAddress__setSource(struct ip6_hdr *hdr);






static error_t IPAddressP__IPAddress__resolveAddress(struct in6_addr *addr, ieee154_addr_t *link_addr);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static void IPAddressFilterP__ForwardIP__default__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
#line 17
static error_t IPAddressFilterP__LocalIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg);





static void IPAddressFilterP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
#line 23
static void IPProtocolsP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
static error_t IPProtocolsP__IP__send(
# 4 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
uint8_t arg_0x23274a0, 
# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
struct ip6_packet *msg);





static void IPProtocolsP__IP__default__recv(
# 4 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
uint8_t arg_0x23274a0, 
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
void *headers, void *payload, size_t len, struct ip6_metadata *meta);
#line 23
static void ICMPCoreP__ICMP_IP__default__recv(
# 13 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMPCoreP.nc"
uint8_t arg_0x2337ef8, 
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
void *headers, void *payload, size_t len, struct ip6_metadata *meta);
#line 23
static void ICMPCoreP__IP__recv(void *headers, void *payload, size_t len, struct ip6_metadata *meta);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t UdpP__Init__init(void );
# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static error_t UdpP__UDP__sendto(
# 7 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x23a6e58, 
# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 10
static error_t UdpP__UDP__bind(
# 7 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x23a6e58, 
# 10 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
uint16_t port);
#line 24
static void UdpP__UDP__default__recvfrom(
# 7 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x23a6e58, 
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *src, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
static void UdpP__Statistics__clear(void );
#line 29
static void UdpP__Statistics__get(UdpP__Statistics__stat_str *stats);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
static void UdpP__IP__recv(void *headers, void *payload, size_t len, struct ip6_metadata *meta);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static void UDPShellP__Boot__booted(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void UDPShellP__Uptime__overflow(void );
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static void UDPShellP__UDP__recvfrom(struct sockaddr_in6 *src, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 11 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/ShellCommand.nc"
static char *UDPShellP__ShellCommand__default__eval(
# 30 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x23fb130, 
# 11 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/ShellCommand.nc"
int argc, char **argv);
# 3 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/RegisterShellCommand.nc"
static char *UDPShellP__RegisterShellCommand__default__getCommandName(
# 31 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x23fa130);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t PlatformP__MoteInit__init(void );
#line 51
static error_t PlatformP__MoteClockInit__init(void );
#line 51
static error_t PlatformP__LedsInit__init(void );
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/PlatformP.nc"
static inline error_t PlatformP__Init__init(void );
# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
static void Msp430ClockP__Msp430ClockInit__initTimerB(void );
#line 31
static void Msp430ClockP__Msp430ClockInit__initTimerA(void );
#line 29
static void Msp430ClockP__Msp430ClockInit__setupDcoCalibrate(void );
static void Msp430ClockP__Msp430ClockInit__initClocks(void );
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static volatile uint8_t Msp430ClockP__IE1 __asm ("0x0000");
static volatile uint16_t Msp430ClockP__TA0CTL __asm ("0x0160");
static volatile uint16_t Msp430ClockP__TA0IV __asm ("0x012E");
static volatile uint16_t Msp430ClockP__TBCTL __asm ("0x0180");
static volatile uint16_t Msp430ClockP__TBIV __asm ("0x011E");

enum Msp430ClockP____nesc_unnamed4366 {

  Msp430ClockP__ACLK_CALIB_PERIOD = 8, 
  Msp430ClockP__TARGET_DCO_DELTA = 4096 / 32 * Msp430ClockP__ACLK_CALIB_PERIOD
};

static inline mcu_power_t Msp430ClockP__McuPowerOverride__lowestState(void );



static inline void Msp430ClockP__Msp430ClockInit__defaultSetupDcoCalibrate(void );
#line 68
static inline void Msp430ClockP__Msp430ClockInit__defaultInitClocks(void );
#line 89
static inline void Msp430ClockP__Msp430ClockInit__defaultInitTimerA(void );
#line 104
static inline void Msp430ClockP__Msp430ClockInit__defaultInitTimerB(void );
#line 119
static inline void Msp430ClockP__Msp430ClockInit__default__setupDcoCalibrate(void );




static inline void Msp430ClockP__Msp430ClockInit__default__initClocks(void );




static inline void Msp430ClockP__Msp430ClockInit__default__initTimerA(void );




static inline void Msp430ClockP__Msp430ClockInit__default__initTimerB(void );





static inline void Msp430ClockP__startTimerA(void );
#line 152
static inline void Msp430ClockP__startTimerB(void );
#line 164
static void Msp430ClockP__set_dco_calib(int calib);





static inline uint16_t Msp430ClockP__test_calib_busywait_delta(int calib);
#line 193
static inline void Msp430ClockP__busyCalibrateDco(void );
#line 218
static inline error_t Msp430ClockP__Init__init(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x138b9c0);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__overflow(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__get(void );
#line 115
static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX0__fired(void );




static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX1__fired(void );





static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Overflow__fired(void );








static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__default__fired(uint8_t n);
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x138b9c0);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__overflow(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get(void );
#line 70
static inline bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__isOverflowPending(void );
#line 115
static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX0__fired(void );




static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX1__fired(void );





static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Overflow__fired(void );








static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__default__fired(uint8_t n);
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t;


static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__getEvent(void );
#line 169
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t;


static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__getEvent(void );
#line 169
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t;


static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__getEvent(void );
#line 169
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__get(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__CC2int(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__int2CC(uint16_t x)  ;

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__compareControl(void );
#line 74
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__getControl(void );









static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__clearPendingInterrupt(void );









static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__setControlAsCompare(void );
#line 119
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__enableEvents(void );




static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__disableEvents(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__getEvent(void );




static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEvent(uint16_t x);









static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEventFromNow(uint16_t x);
#line 169
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__default__captured(uint16_t n);







static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__CC2int(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__int2CC(uint16_t x)  ;
#line 61
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__captureControl(uint8_t l_cm);
#line 74
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__getControl(void );









static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__clearPendingInterrupt(void );
#line 99
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__setControlAsCapture(uint8_t cm);
#line 119
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__enableEvents(void );




static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__disableEvents(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__getEvent(void );
#line 164
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__clearOverflow(void );




static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Event__fired(void );
#line 181
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__fired(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__get(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__CC2int(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__int2CC(uint16_t x)  ;

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__compareControl(void );
#line 74
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__getControl(void );









static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__clearPendingInterrupt(void );









static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__setControlAsCompare(void );
#line 119
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__enableEvents(void );




static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__disableEvents(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__getEvent(void );




static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEvent(uint16_t x);









static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEventFromNow(uint16_t x);
#line 169
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__default__captured(uint16_t n);







static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t;


static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__getEvent(void );
#line 169
static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t;


static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__getEvent(void );
#line 169
static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t;


static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__getEvent(void );
#line 169
static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Timer__overflow(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__captured(uint16_t time);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__fired(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t;


static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__int2CC(uint16_t x)  ;
#line 74
static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Control__getControl(void );
#line 139
static inline uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__getEvent(void );
#line 169
static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Event__fired(void );







static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__default__captured(uint16_t n);



static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__default__fired(void );



static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Timer__overflow(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void Msp430TimerCommonP__VectorTimerB1__fired(void );
#line 28
static void Msp430TimerCommonP__VectorTimerA0__fired(void );
#line 28
static void Msp430TimerCommonP__VectorTimerA1__fired(void );
#line 28
static void Msp430TimerCommonP__VectorTimerB0__fired(void );
# 11 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
void sig_TIMERA0_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(12)))  ;
void sig_TIMERA1_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(10)))  ;
void sig_TIMERB0_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(26)))  ;
void sig_TIMERB1_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(24)))  ;
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static mcu_power_t McuSleepC__McuPowerOverride__lowestState(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
bool McuSleepC__dirty = TRUE;
mcu_power_t McuSleepC__powerState = MSP430_POWER_ACTIVE;




const uint16_t McuSleepC__msp430PowerBits[MSP430_POWER_LPM4 + 1] = { 
0, 
0x0010, 
0x0040 + 0x0010, 
0x0080 + 0x0010, 
0x0080 + 0x0040 + 0x0010, 
0x0080 + 0x0040 + 0x0020 + 0x0010 };


static inline mcu_power_t McuSleepC__getPowerState(void );
#line 104
static inline void McuSleepC__computePowerState(void );




static inline void McuSleepC__McuSleep__sleep(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t MotePlatformC__SubInit__init(void );
# 7 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/MotePlatformC.nc"
static inline error_t MotePlatformC__Init__init(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t RealMainP__SoftwareInit__init(void );
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static void RealMainP__Boot__booted(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static error_t RealMainP__PlatformInit__init(void );
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
static void RealMainP__Scheduler__init(void );
#line 61
static void RealMainP__Scheduler__taskLoop(void );
#line 54
static bool RealMainP__Scheduler__runNextTask(void );
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RealMainP.nc"
int main(void )   ;
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void SchedulerBasicP__TaskBasic__runTask(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x12e0d30);
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
static void SchedulerBasicP__McuSleep__sleep(void );
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP____nesc_unnamed4367 {

  SchedulerBasicP__NUM_TASKS = 14U, 
  SchedulerBasicP__NO_TASK = 255
};

uint8_t SchedulerBasicP__m_head;
uint8_t SchedulerBasicP__m_tail;
uint8_t SchedulerBasicP__m_next[SchedulerBasicP__NUM_TASKS];








static __inline uint8_t SchedulerBasicP__popTask(void );
#line 86
static inline bool SchedulerBasicP__isWaiting(uint8_t id);




static inline bool SchedulerBasicP__pushTask(uint8_t id);
#line 113
static inline void SchedulerBasicP__Scheduler__init(void );









static bool SchedulerBasicP__Scheduler__runNextTask(void );
#line 138
static inline void SchedulerBasicP__Scheduler__taskLoop(void );
#line 159
static error_t SchedulerBasicP__TaskBasic__postTask(uint8_t id);




static void SchedulerBasicP__TaskBasic__default__runTask(uint8_t id);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void LedsP__Led0__toggle(void );



static void LedsP__Led0__makeOutput(void );
#line 29
static void LedsP__Led0__set(void );





static void LedsP__Led1__makeOutput(void );
#line 29
static void LedsP__Led1__set(void );

static void LedsP__Led2__toggle(void );



static void LedsP__Led2__makeOutput(void );
#line 29
static void LedsP__Led2__set(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/LedsP.nc"
static inline error_t LedsP__Init__init(void );
#line 73
static inline void LedsP__Leds__led0Toggle(void );
#line 103
static inline void LedsP__Leds__led2Toggle(void );
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__getRaw(void );
static inline bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__get(void );
#line 48
static inline uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__getRaw(void );
static inline bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__get(void );
#line 48
static inline uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__getRaw(void );
static inline bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__get(void );
static inline void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__makeInput(void );
#line 45
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__set(void );
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__clr(void );

static inline uint8_t /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__getRaw(void );
static inline bool /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__get(void );
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeInput(void );

static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeOutput(void );

static inline void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectModuleFunc(void );

static inline void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectIOFunc(void );
#line 54
static inline void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectModuleFunc(void );

static inline void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectIOFunc(void );
#line 54
static inline void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectModuleFunc(void );

static inline void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectIOFunc(void );
#line 56
static inline void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP__20__IO__selectIOFunc(void );
#line 56
static inline void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP__21__IO__selectIOFunc(void );
#line 45
static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__set(void );

static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__toggle(void );




static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__makeOutput(void );
#line 48
static inline uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__getRaw(void );
static inline bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__get(void );
static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__makeInput(void );



static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectModuleFunc(void );

static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectIOFunc(void );
#line 45
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__set(void );
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__clr(void );





static inline void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__makeOutput(void );
#line 45
static inline void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__set(void );






static inline void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__makeOutput(void );
#line 45
static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__set(void );
static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__clr(void );





static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__makeOutput(void );
#line 45
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__set(void );
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__clr(void );





static inline void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__makeOutput(void );
#line 45
static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__set(void );

static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__toggle(void );




static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__makeOutput(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__toggle(void );
#line 71
static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__makeOutput(void );
#line 34
static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__set(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__set(void );

static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__toggle(void );



static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__makeOutput(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__makeOutput(void );
#line 34
static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__set(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__set(void );





static inline void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__makeOutput(void );
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__toggle(void );
#line 71
static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__makeOutput(void );
#line 34
static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__set(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__set(void );

static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__toggle(void );



static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__makeOutput(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void UDPEchoP__StatusTimer__startPeriodic(uint32_t dt);
# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static error_t UDPEchoP__Status__sendto(struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 10
static error_t UDPEchoP__Status__bind(uint16_t port);
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static error_t UDPEchoP__RadioControl__start(void );
# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static error_t UDPEchoP__Echo__sendto(struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 10
static error_t UDPEchoP__Echo__bind(uint16_t port);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
static void UDPEchoP__IPStats__clear(void );
#line 29
static void UDPEchoP__IPStats__get(UDPEchoP__IPStats__stat_str *stats);
#line 29
static void UDPEchoP__UDPStats__get(UDPEchoP__UDPStats__stat_str *stats);
# 56 "UDPEchoP.nc"
bool UDPEchoP__timerStarted;
nx_struct udp_report UDPEchoP__stats;
struct sockaddr_in6 UDPEchoP__route_dest;

static inline void UDPEchoP__Boot__booted(void );
#line 80
static inline void UDPEchoP__RadioControl__startDone(error_t e);



static inline void UDPEchoP__RadioControl__stopDone(error_t e);



static inline void UDPEchoP__Status__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta);



static inline void UDPEchoP__Echo__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta);










static inline void UDPEchoP__StatusTimer__fired(void );
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEvent(uint16_t time);

static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEventFromNow(uint16_t delta);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__get(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__fired(void );
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__enableEvents(void );
#line 36
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__setControlAsCompare(void );










static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__disableEvents(void );
#line 33
static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__clearPendingInterrupt(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Init__init(void );
#line 54
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__stop(void );




static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__fired(void );










static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__startAt(uint16_t t0, uint16_t dt);
#line 103
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__overflow(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__get(void );
static bool /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__isOverflowPending(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__overflow(void );
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__get(void );




static inline bool /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__isOverflowPending(void );









static inline void /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__overflow(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__size_type /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__get(void );






static bool /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__isOverflowPending(void );










static void /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__overflow(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*CounterMilli32C.Transform*/TransformCounterC__0__upper_count_type /*CounterMilli32C.Transform*/TransformCounterC__0__m_upper;

enum /*CounterMilli32C.Transform*/TransformCounterC__0____nesc_unnamed4368 {

  TransformCounterC__0__LOW_SHIFT_RIGHT = 5, 
  TransformCounterC__0__HIGH_SHIFT_LEFT = 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC__0__from_size_type ) - /*CounterMilli32C.Transform*/TransformCounterC__0__LOW_SHIFT_RIGHT, 
  TransformCounterC__0__NUM_UPPER_BITS = 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type ) - 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC__0__from_size_type ) + 5, 



  TransformCounterC__0__OVERFLOW_MASK = /*CounterMilli32C.Transform*/TransformCounterC__0__NUM_UPPER_BITS ? ((/*CounterMilli32C.Transform*/TransformCounterC__0__upper_count_type )2 << (/*CounterMilli32C.Transform*/TransformCounterC__0__NUM_UPPER_BITS - 1)) - 1 : 0
};

static /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__get(void );
#line 122
static inline void /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__overflow(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__fired(void );
#line 92
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__size_type dt);
#line 62
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__stop(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__get(void );
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0;
/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt;

enum /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0____nesc_unnamed4369 {

  TransformAlarmC__0__MAX_DELAY_LOG2 = 8 * sizeof(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_size_type ) - 1 - 5, 
  TransformAlarmC__0__MAX_DELAY = (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type )1 << /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__MAX_DELAY_LOG2
};

static inline /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getNow(void );




static inline /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getAlarm(void );










static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__stop(void );




static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__set_alarm(void );
#line 136
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type dt);
#line 151
static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__fired(void );
#line 166
static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__overflow(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__postTask(void );
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getNow(void );
#line 92
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type t0, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type dt);
#line 105
static /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getAlarm(void );
#line 62
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__stop(void );
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__fired(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
enum /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0____nesc_unnamed4370 {
#line 63
  AlarmToTimerC__0__fired = 0U
};
#line 63
typedef int /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0____nesc_sillytask_fired[/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired];
#line 44
uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_dt;
bool /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_oneshot;

static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__start(uint32_t t0, uint32_t dt, bool oneshot);
#line 60
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__stop(void );


static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__runTask(void );






static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__fired(void );
#line 82
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__startOneShotAt(uint32_t t0, uint32_t dt);


static inline uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__getNow(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__postTask(void );
# 125 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow(void );
#line 118
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__startOneShotAt(uint32_t t0, uint32_t dt);
#line 67
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__stop(void );




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__fired(
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x17ae3c8);
#line 60
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0____nesc_unnamed4371 {
#line 60
  VirtualizeTimerC__0__updateFromTimer = 1U
};
#line 60
typedef int /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0____nesc_sillytask_updateFromTimer[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer];
#line 42
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0____nesc_unnamed4372 {

  VirtualizeTimerC__0__NUM_TIMERS = 4U, 
  VirtualizeTimerC__0__END_OF_LIST = 255
};








#line 48
typedef struct /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0____nesc_unnamed4373 {

  uint32_t t0;
  uint32_t dt;
  bool isoneshot : 1;
  bool isrunning : 1;
  bool _reserved : 6;
} /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer_t;

/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__m_timers[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__NUM_TIMERS];




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__fireTimers(uint32_t now);
#line 89
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__runTask(void );
#line 128
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__fired(void );




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot);









static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startPeriodic(uint8_t num, uint32_t dt);




static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startOneShot(uint8_t num, uint32_t dt);




static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__stop(uint8_t num);
#line 193
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__default__fired(uint8_t num);
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__overflow(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static void IPDispatchP__SplitControl__startDone(error_t error);
#line 117
static void IPDispatchP__SplitControl__stopDone(error_t error);
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
IPDispatchP__SendInfoPool__t * 


IPDispatchP__SendInfoPool__get(void );
#line 89
static error_t IPDispatchP__SendInfoPool__put(
#line 85
IPDispatchP__SendInfoPool__t * newVal);
#line 72
static uint8_t IPDispatchP__SendInfoPool__size(void );
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static error_t IPDispatchP__RadioControl__start(void );
#line 109
static error_t IPDispatchP__RadioControl__stop(void );
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static void IPDispatchP__IPLower__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
static 
#line 71
IPDispatchP__SendQueue__t  

IPDispatchP__SendQueue__head(void );
#line 90
static error_t IPDispatchP__SendQueue__enqueue(
#line 86
IPDispatchP__SendQueue__t  newVal);
#line 81
static 
#line 79
IPDispatchP__SendQueue__t  

IPDispatchP__SendQueue__dequeue(void );
#line 50
static bool IPDispatchP__SendQueue__empty(void );







static uint8_t IPDispatchP__SendQueue__size(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void IPDispatchP__ExpireTimer__startPeriodic(uint32_t dt);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t IPDispatchP__sendTask__postTask(void );
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
IPDispatchP__FragPool__t * 


IPDispatchP__FragPool__get(void );
#line 89
static error_t IPDispatchP__FragPool__put(
#line 85
IPDispatchP__FragPool__t * newVal);
#line 72
static uint8_t IPDispatchP__FragPool__size(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
static void IPDispatchP__Leds__led0Toggle(void );
#line 89
static void IPDispatchP__Leds__led2Toggle(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t IPDispatchP__Ieee154Send__send(
#line 56
message_t * msg, 







uint8_t len);
#line 114
static 
#line 112
void * 

IPDispatchP__Ieee154Send__getPayload(
#line 111
message_t * msg, 


uint8_t len);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
static void IPDispatchP__BarePacket__clear(
#line 51
message_t * msg);
#line 67
static uint8_t IPDispatchP__BarePacket__payloadLength(
#line 63
message_t * msg);
#line 95
static uint8_t IPDispatchP__BarePacket__maxPayloadLength(void );
#line 83
static void IPDispatchP__BarePacket__setPayloadLength(
#line 79
message_t * msg, 



uint8_t len);
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
static void IPDispatchP__PacketLink__setRetries(
#line 42
message_t * msg, 



uint16_t maxRetries);
#line 59
static uint16_t IPDispatchP__PacketLink__getRetries(
#line 56
message_t * msg);
#line 53
static void IPDispatchP__PacketLink__setRetryDelay(message_t *msg, uint16_t retryDelay);
#line 71
static bool IPDispatchP__PacketLink__wasDelivered(
#line 68
message_t * msg);
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static 
#line 94
IPDispatchP__SendEntryPool__t * 


IPDispatchP__SendEntryPool__get(void );
#line 89
static error_t IPDispatchP__SendEntryPool__put(
#line 85
IPDispatchP__SendEntryPool__t * newVal);
#line 72
static uint8_t IPDispatchP__SendEntryPool__size(void );
# 439 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
enum IPDispatchP____nesc_unnamed4374 {
#line 439
  IPDispatchP__sendTask = 2U
};
#line 439
typedef int IPDispatchP____nesc_sillytask_sendTask[IPDispatchP__sendTask];
#line 127
enum IPDispatchP____nesc_unnamed4375 {
  IPDispatchP__S_RUNNING, 
  IPDispatchP__S_STOPPED, 
  IPDispatchP__S_STOPPING
};
uint8_t IPDispatchP__state = IPDispatchP__S_STOPPED;
bool IPDispatchP__radioBusy;
uint8_t IPDispatchP__current_local_label = 0;
ip_statistics_t IPDispatchP__stats;
#line 148
table_t IPDispatchP__recon_cache;



struct lowpan_reconstruct IPDispatchP__recon_data[N_RECONSTRUCTIONS];







static inline void IPDispatchP__reconstruct_clear(void *ent);






static inline send_info_t *IPDispatchP__getSendInfo(void );
#line 179
static inline error_t IPDispatchP__SplitControl__start(void );
#line 195
static inline void IPDispatchP__RadioControl__startDone(error_t error);
#line 210
static inline void IPDispatchP__RadioControl__stopDone(error_t error);



static inline void IPDispatchP__Boot__booted(void );
#line 229
static void IPDispatchP__deliver(struct lowpan_reconstruct *recon);
#line 271
static inline void IPDispatchP__reconstruct_age(void *elt);
#line 296
static inline void IPDispatchP__ip_print_heap(void );










static inline void IPDispatchP__ExpireTimer__fired(void );
#line 322
static inline struct lowpan_reconstruct *IPDispatchP__get_reconstruct(uint16_t key, uint16_t tag);
#line 354
static inline message_t *IPDispatchP__Ieee154Receive__receive(message_t *msg, void *msg_payload, uint8_t len);
#line 439
static inline void IPDispatchP__sendTask__runTask(void );
#line 498
static inline error_t IPDispatchP__IPLower__send(struct ieee154_frame_addr *frame_addr, 
struct ip6_packet *msg);
#line 589
static inline void IPDispatchP__Ieee154Send__sendDone(message_t *msg, error_t error);
#line 643
static inline void IPDispatchP__Statistics__get(ip_statistics_t *statistics);
#line 661
static inline void IPDispatchP__Statistics__clear(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static void CC2420CsmaP__SplitControl__startDone(error_t error);
#line 117
static void CC2420CsmaP__SplitControl__stopDone(error_t error);
# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static void CC2420CsmaP__RadioBackoff__requestCca(message_t * msg);
#line 81
static void CC2420CsmaP__RadioBackoff__requestInitialBackoff(message_t * msg);






static void CC2420CsmaP__RadioBackoff__requestCongestionBackoff(message_t * msg);
#line 66
static void CC2420CsmaP__SubBackoff__setCongestionBackoff(uint16_t backoffTime);
#line 60
static void CC2420CsmaP__SubBackoff__setInitialBackoff(uint16_t backoffTime);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static error_t CC2420CsmaP__CC2420Transmit__send(message_t * p_msg, bool useCca);
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void CC2420CsmaP__Send__sendDone(
#line 85
message_t * msg, 



error_t error);
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static uint16_t CC2420CsmaP__Random__rand16(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static error_t CC2420CsmaP__SubControl__start(void );









static error_t CC2420CsmaP__SubControl__stop(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * CC2420CsmaP__CC2420PacketBody__getHeader(message_t * msg);










static cc2420_metadata_t * CC2420CsmaP__CC2420PacketBody__getMetadata(message_t * msg);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
static error_t CC2420CsmaP__CC2420Power__startOscillator(void );
#line 90
static error_t CC2420CsmaP__CC2420Power__rxOn(void );
#line 51
static error_t CC2420CsmaP__CC2420Power__startVReg(void );
#line 63
static error_t CC2420CsmaP__CC2420Power__stopVReg(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420CsmaP__Resource__release(void );
#line 78
static error_t CC2420CsmaP__Resource__request(void );
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static bool CC2420CsmaP__SplitControlState__isState(uint8_t myState);
#line 45
static error_t CC2420CsmaP__SplitControlState__requestState(uint8_t reqState);





static void CC2420CsmaP__SplitControlState__forceState(uint8_t reqState);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t CC2420CsmaP__sendDone_task__postTask(void );
#line 56
static error_t CC2420CsmaP__stopDone_task__postTask(void );
#line 56
static error_t CC2420CsmaP__startDone_task__postTask(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
enum CC2420CsmaP____nesc_unnamed4376 {
#line 74
  CC2420CsmaP__startDone_task = 3U
};
#line 74
typedef int CC2420CsmaP____nesc_sillytask_startDone_task[CC2420CsmaP__startDone_task];
enum CC2420CsmaP____nesc_unnamed4377 {
#line 75
  CC2420CsmaP__stopDone_task = 4U
};
#line 75
typedef int CC2420CsmaP____nesc_sillytask_stopDone_task[CC2420CsmaP__stopDone_task];
enum CC2420CsmaP____nesc_unnamed4378 {
#line 76
  CC2420CsmaP__sendDone_task = 5U
};
#line 76
typedef int CC2420CsmaP____nesc_sillytask_sendDone_task[CC2420CsmaP__sendDone_task];
#line 58
enum CC2420CsmaP____nesc_unnamed4379 {
  CC2420CsmaP__S_STOPPED, 
  CC2420CsmaP__S_STARTING, 
  CC2420CsmaP__S_STARTED, 
  CC2420CsmaP__S_STOPPING, 
  CC2420CsmaP__S_TRANSMITTING
};

message_t * CC2420CsmaP__m_msg;

error_t CC2420CsmaP__sendErr = SUCCESS;


bool CC2420CsmaP__ccaOn;






static inline void CC2420CsmaP__shutdown(void );


static error_t CC2420CsmaP__SplitControl__start(void );
#line 96
static inline error_t CC2420CsmaP__SplitControl__stop(void );
#line 122
static error_t CC2420CsmaP__Send__send(message_t *p_msg, uint8_t len);
#line 205
static inline void CC2420CsmaP__CC2420Transmit__sendDone(message_t *p_msg, error_t err);




static inline void CC2420CsmaP__CC2420Power__startVRegDone(void );



static inline void CC2420CsmaP__Resource__granted(void );



static inline void CC2420CsmaP__CC2420Power__startOscillatorDone(void );




static inline void CC2420CsmaP__SubBackoff__requestInitialBackoff(message_t *msg);






static inline void CC2420CsmaP__SubBackoff__requestCongestionBackoff(message_t *msg);
#line 244
static inline void CC2420CsmaP__sendDone_task__runTask(void );
#line 257
static inline void CC2420CsmaP__startDone_task__runTask(void );







static inline void CC2420CsmaP__stopDone_task__runTask(void );









static inline void CC2420CsmaP__shutdown(void );
#line 288
static inline void CC2420CsmaP__RadioBackoff__default__requestInitialBackoff(message_t *msg);


static inline void CC2420CsmaP__RadioBackoff__default__requestCongestionBackoff(message_t *msg);


static inline void CC2420CsmaP__RadioBackoff__default__requestCca(message_t *msg);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static void CC2420ControlP__CC2420Config__syncDone(error_t error);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420ControlP__RXCTRL1__write(uint16_t data);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
static ieee_eui64_t CC2420ControlP__LocalIeeeEui64__getId(void );
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void CC2420ControlP__StartupTimer__start(CC2420ControlP__StartupTimer__size_type dt);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420ControlP__MDMCTRL0__write(uint16_t data);
# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420ControlP__RSTN__makeOutput(void );
#line 29
static void CC2420ControlP__RSTN__set(void );
static void CC2420ControlP__RSTN__clr(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Read.nc"
static void CC2420ControlP__ReadRssi__readDone(error_t result, CC2420ControlP__ReadRssi__val_t val);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t CC2420ControlP__syncDone__postTask(void );
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420ControlP__RSSI__read(uint16_t *data);







static cc2420_status_t CC2420ControlP__IOCFG0__write(uint16_t data);
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static am_addr_t CC2420ControlP__ActiveMessageAddress__amAddress(void );




static am_group_t CC2420ControlP__ActiveMessageAddress__amGroup(void );
# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420ControlP__CSN__makeOutput(void );
#line 29
static void CC2420ControlP__CSN__set(void );
static void CC2420ControlP__CSN__clr(void );




static void CC2420ControlP__VREN__makeOutput(void );
#line 29
static void CC2420ControlP__VREN__set(void );
static void CC2420ControlP__VREN__clr(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420ControlP__SXOSCON__strobe(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420ControlP__SpiResource__release(void );
#line 78
static error_t CC2420ControlP__SpiResource__request(void );
#line 110
static error_t CC2420ControlP__SyncResource__release(void );
#line 78
static error_t CC2420ControlP__SyncResource__request(void );
# 76 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
static void CC2420ControlP__CC2420Power__startOscillatorDone(void );
#line 56
static void CC2420ControlP__CC2420Power__startVRegDone(void );
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420ControlP__IOCFG1__write(uint16_t data);
#line 55
static cc2420_status_t CC2420ControlP__FSCTRL__write(uint16_t data);
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420ControlP__SRXON__strobe(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420ControlP__Resource__granted(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static cc2420_status_t CC2420ControlP__IEEEADR__write(uint8_t offset, uint8_t * data, uint8_t length);
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static error_t CC2420ControlP__InterruptCCA__disable(void );
#line 42
static error_t CC2420ControlP__InterruptCCA__enableRisingEdge(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420ControlP__RssiResource__release(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420ControlP__SRFOFF__strobe(void );
# 123 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
enum CC2420ControlP____nesc_unnamed4380 {
#line 123
  CC2420ControlP__sync = 6U
};
#line 123
typedef int CC2420ControlP____nesc_sillytask_sync[CC2420ControlP__sync];
enum CC2420ControlP____nesc_unnamed4381 {
#line 124
  CC2420ControlP__syncDone = 7U
};
#line 124
typedef int CC2420ControlP____nesc_sillytask_syncDone[CC2420ControlP__syncDone];
#line 89
#line 83
typedef enum CC2420ControlP____nesc_unnamed4382 {
  CC2420ControlP__S_VREG_STOPPED, 
  CC2420ControlP__S_VREG_STARTING, 
  CC2420ControlP__S_VREG_STARTED, 
  CC2420ControlP__S_XOSC_STARTING, 
  CC2420ControlP__S_XOSC_STARTED
} CC2420ControlP__cc2420_control_state_t;

uint8_t CC2420ControlP__m_channel;

uint8_t CC2420ControlP__m_tx_power;

uint16_t CC2420ControlP__m_pan;

uint16_t CC2420ControlP__m_short_addr;

ieee_eui64_t CC2420ControlP__m_ext_addr;

bool CC2420ControlP__m_sync_busy;


bool CC2420ControlP__autoAckEnabled;


bool CC2420ControlP__hwAutoAckDefault;


bool CC2420ControlP__addressRecognition;


bool CC2420ControlP__hwAddressRecognition;

CC2420ControlP__cc2420_control_state_t CC2420ControlP__m_state = CC2420ControlP__S_VREG_STOPPED;



static void CC2420ControlP__writeFsctrl(void );
static void CC2420ControlP__writeMdmctrl0(void );
static void CC2420ControlP__writeId(void );





static inline error_t CC2420ControlP__Init__init(void );
#line 178
static inline error_t CC2420ControlP__Resource__request(void );







static inline error_t CC2420ControlP__Resource__release(void );







static inline error_t CC2420ControlP__CC2420Power__startVReg(void );
#line 206
static error_t CC2420ControlP__CC2420Power__stopVReg(void );







static inline error_t CC2420ControlP__CC2420Power__startOscillator(void );
#line 256
static inline error_t CC2420ControlP__CC2420Power__rxOn(void );
#line 286
static inline ieee_eui64_t CC2420ControlP__CC2420Config__getExtAddr(void );



static uint16_t CC2420ControlP__CC2420Config__getShortAddr(void );







static uint16_t CC2420ControlP__CC2420Config__getPanAddr(void );
#line 311
static inline error_t CC2420ControlP__CC2420Config__sync(void );
#line 343
static inline bool CC2420ControlP__CC2420Config__isAddressRecognitionEnabled(void );
#line 370
static inline bool CC2420ControlP__CC2420Config__isHwAutoAckDefault(void );






static inline bool CC2420ControlP__CC2420Config__isAutoAckEnabled(void );









static inline void CC2420ControlP__SyncResource__granted(void );
#line 401
static inline void CC2420ControlP__SpiResource__granted(void );




static inline void CC2420ControlP__RssiResource__granted(void );
#line 419
static inline void CC2420ControlP__StartupTimer__fired(void );









static inline void CC2420ControlP__InterruptCCA__fired(void );
#line 453
static inline void CC2420ControlP__sync__runTask(void );



static inline void CC2420ControlP__syncDone__runTask(void );









static void CC2420ControlP__writeFsctrl(void );
#line 484
static void CC2420ControlP__writeMdmctrl0(void );
#line 503
static void CC2420ControlP__writeId(void );
#line 521
static inline void CC2420ControlP__ReadRssi__default__readDone(error_t error, uint16_t data);
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEvent(uint16_t time);

static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEventFromNow(uint16_t delta);
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__get(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__fired(void );
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__enableEvents(void );
#line 36
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__setControlAsCompare(void );










static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__disableEvents(void );
#line 33
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__clearPendingInterrupt(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Init__init(void );
#line 54
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__stop(void );




static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__fired(void );










static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__startAt(uint16_t t0, uint16_t dt);
#line 103
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__overflow(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__size_type /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__get(void );






static bool /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__isOverflowPending(void );










static void /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__overflow(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*Counter32khz32C.Transform*/TransformCounterC__1__upper_count_type /*Counter32khz32C.Transform*/TransformCounterC__1__m_upper;

enum /*Counter32khz32C.Transform*/TransformCounterC__1____nesc_unnamed4383 {

  TransformCounterC__1__LOW_SHIFT_RIGHT = 0, 
  TransformCounterC__1__HIGH_SHIFT_LEFT = 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC__1__from_size_type ) - /*Counter32khz32C.Transform*/TransformCounterC__1__LOW_SHIFT_RIGHT, 
  TransformCounterC__1__NUM_UPPER_BITS = 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type ) - 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC__1__from_size_type ) + 0, 



  TransformCounterC__1__OVERFLOW_MASK = /*Counter32khz32C.Transform*/TransformCounterC__1__NUM_UPPER_BITS ? ((/*Counter32khz32C.Transform*/TransformCounterC__1__upper_count_type )2 << (/*Counter32khz32C.Transform*/TransformCounterC__1__NUM_UPPER_BITS - 1)) - 1 : 0
};

static /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__get(void );
#line 122
static inline void /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__overflow(void );
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__fired(void );
#line 92
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__size_type dt);
#line 62
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__stop(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__get(void );
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0;
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt;

enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1____nesc_unnamed4384 {

  TransformAlarmC__1__MAX_DELAY_LOG2 = 8 * sizeof(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_size_type ) - 1 - 0, 
  TransformAlarmC__1__MAX_DELAY = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type )1 << /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__MAX_DELAY_LOG2
};

static inline /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__getNow(void );
#line 91
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__stop(void );




static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__set_alarm(void );
#line 136
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type dt);









static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type dt);




static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__fired(void );
#line 166
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__overflow(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__makeInput(void );
#line 59
static bool /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__get(void );
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__get(void );
static inline void /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__makeInput(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__makeOutput(void );
#line 34
static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__set(void );




static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__clr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set(void );
static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr(void );




static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__makeOutput(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__HplGeneralIO__get(void );
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__GeneralIO__get(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__HplGeneralIO__get(void );
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__GeneralIO__get(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__makeOutput(void );
#line 34
static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__set(void );




static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__clr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__set(void );
static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__clr(void );




static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__makeOutput(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__makeInput(void );
#line 59
static bool /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__get(void );
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__get(void );
static inline void /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__makeInput(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__makeOutput(void );
#line 34
static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__set(void );




static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__clr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__set(void );
static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__clr(void );




static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__makeOutput(void );
# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__clearOverflow(void );
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captured(uint16_t time);
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__setControlAsCapture(uint8_t cm);

static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__enableEvents(void );
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__disableEvents(void );
#line 33
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__clearPendingInterrupt(void );
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectIOFunc(void );
#line 78
static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectModuleFunc(void );
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__enableCapture(uint8_t mode);
#line 50
static inline error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureRisingEdge(void );



static inline error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureFallingEdge(void );



static inline void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__disable(void );






static inline void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__captured(uint16_t time);
# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static void HplMsp430InterruptP__Port14__fired(void );
#line 61
static void HplMsp430InterruptP__Port26__fired(void );
#line 61
static void HplMsp430InterruptP__Port17__fired(void );
#line 61
static void HplMsp430InterruptP__Port21__fired(void );
#line 61
static void HplMsp430InterruptP__Port12__fired(void );
#line 61
static void HplMsp430InterruptP__Port24__fired(void );
#line 61
static void HplMsp430InterruptP__Port15__fired(void );
#line 61
static void HplMsp430InterruptP__Port27__fired(void );
#line 61
static void HplMsp430InterruptP__Port10__fired(void );
#line 61
static void HplMsp430InterruptP__Port22__fired(void );
#line 61
static void HplMsp430InterruptP__Port13__fired(void );
#line 61
static void HplMsp430InterruptP__Port25__fired(void );
#line 61
static void HplMsp430InterruptP__Port16__fired(void );
#line 61
static void HplMsp430InterruptP__Port20__fired(void );
#line 61
static void HplMsp430InterruptP__Port11__fired(void );
#line 61
static void HplMsp430InterruptP__Port23__fired(void );
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
void sig_PORT1_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(8)))  ;
#line 68
static inline void HplMsp430InterruptP__Port11__default__fired(void );
static inline void HplMsp430InterruptP__Port12__default__fired(void );
static inline void HplMsp430InterruptP__Port13__default__fired(void );

static inline void HplMsp430InterruptP__Port15__default__fired(void );
static inline void HplMsp430InterruptP__Port16__default__fired(void );
static inline void HplMsp430InterruptP__Port17__default__fired(void );
static inline void HplMsp430InterruptP__Port10__enable(void );



static inline void HplMsp430InterruptP__Port14__enable(void );



static inline void HplMsp430InterruptP__Port10__disable(void );



static inline void HplMsp430InterruptP__Port14__disable(void );



static inline void HplMsp430InterruptP__Port10__clear(void );
static inline void HplMsp430InterruptP__Port11__clear(void );
static inline void HplMsp430InterruptP__Port12__clear(void );
static inline void HplMsp430InterruptP__Port13__clear(void );
static inline void HplMsp430InterruptP__Port14__clear(void );
static inline void HplMsp430InterruptP__Port15__clear(void );
static inline void HplMsp430InterruptP__Port16__clear(void );
static inline void HplMsp430InterruptP__Port17__clear(void );








static inline void HplMsp430InterruptP__Port10__edge(bool l2h);
#line 131
static inline void HplMsp430InterruptP__Port14__edge(bool l2h);
#line 158
void sig_PORT2_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(2)))  ;
#line 171
static inline void HplMsp430InterruptP__Port20__default__fired(void );
static inline void HplMsp430InterruptP__Port21__default__fired(void );
static inline void HplMsp430InterruptP__Port22__default__fired(void );
static inline void HplMsp430InterruptP__Port23__default__fired(void );
static inline void HplMsp430InterruptP__Port24__default__fired(void );
static inline void HplMsp430InterruptP__Port25__default__fired(void );
static inline void HplMsp430InterruptP__Port26__default__fired(void );
static inline void HplMsp430InterruptP__Port27__default__fired(void );
#line 195
static inline void HplMsp430InterruptP__Port20__clear(void );
static inline void HplMsp430InterruptP__Port21__clear(void );
static inline void HplMsp430InterruptP__Port22__clear(void );
static inline void HplMsp430InterruptP__Port23__clear(void );
static inline void HplMsp430InterruptP__Port24__clear(void );
static inline void HplMsp430InterruptP__Port25__clear(void );
static inline void HplMsp430InterruptP__Port26__clear(void );
static inline void HplMsp430InterruptP__Port27__clear(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__clear(void );
#line 36
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__disable(void );
#line 56
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__edge(bool low_to_high);
#line 31
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__enable(void );
# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__fired(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__enable(bool rising);








static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__enableRisingEdge(void );







static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__disable(void );







static inline void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__fired(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__clear(void );
#line 36
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__disable(void );
#line 56
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__edge(bool low_to_high);
#line 31
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__enable(void );
# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__fired(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__enable(bool rising);
#line 54
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__enableFallingEdge(void );



static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__disable(void );







static inline void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__fired(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static error_t CC2420SpiP__SpiPacket__send(
#line 48
uint8_t * txBuf, 

uint8_t * rxBuf, 








uint16_t len);
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static void CC2420SpiP__Fifo__writeDone(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length, error_t error);
#line 71
static void CC2420SpiP__Fifo__readDone(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33dc8, 
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t * data, uint8_t length, error_t error);
# 24 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static void CC2420SpiP__ChipSpiResource__releasing(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
static uint8_t CC2420SpiP__SpiByte__write(uint8_t tx);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static void CC2420SpiP__WorkingState__toIdle(void );




static bool CC2420SpiP__WorkingState__isIdle(void );
#line 45
static error_t CC2420SpiP__WorkingState__requestState(uint8_t reqState);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420SpiP__SpiResource__release(void );
#line 87
static error_t CC2420SpiP__SpiResource__immediateRequest(void );
#line 78
static error_t CC2420SpiP__SpiResource__request(void );
#line 118
static bool CC2420SpiP__SpiResource__isOwner(void );
#line 92
static void CC2420SpiP__Resource__granted(
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x1b33398);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t CC2420SpiP__grant__postTask(void );
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
enum CC2420SpiP____nesc_unnamed4385 {
#line 88
  CC2420SpiP__grant = 8U
};
#line 88
typedef int CC2420SpiP____nesc_sillytask_grant[CC2420SpiP__grant];
#line 63
enum CC2420SpiP____nesc_unnamed4386 {
  CC2420SpiP__RESOURCE_COUNT = 5U, 
  CC2420SpiP__NO_HOLDER = 0xFF
};


enum CC2420SpiP____nesc_unnamed4387 {
  CC2420SpiP__S_IDLE, 
  CC2420SpiP__S_BUSY
};


uint16_t CC2420SpiP__m_addr;


uint8_t CC2420SpiP__m_requests = 0;


uint8_t CC2420SpiP__m_holder = CC2420SpiP__NO_HOLDER;


bool CC2420SpiP__release;


static error_t CC2420SpiP__attemptRelease(void );







static inline void CC2420SpiP__ChipSpiResource__abortRelease(void );






static inline error_t CC2420SpiP__ChipSpiResource__attemptRelease(void );




static error_t CC2420SpiP__Resource__request(uint8_t id);
#line 126
static error_t CC2420SpiP__Resource__immediateRequest(uint8_t id);
#line 149
static error_t CC2420SpiP__Resource__release(uint8_t id);
#line 178
static inline uint8_t CC2420SpiP__Resource__isOwner(uint8_t id);





static inline void CC2420SpiP__SpiResource__granted(void );




static cc2420_status_t CC2420SpiP__Fifo__beginRead(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 209
static inline error_t CC2420SpiP__Fifo__continueRead(uint8_t addr, uint8_t *data, 
uint8_t len);



static inline cc2420_status_t CC2420SpiP__Fifo__write(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 260
static cc2420_status_t CC2420SpiP__Ram__write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len);
#line 287
static inline cc2420_status_t CC2420SpiP__Reg__read(uint8_t addr, uint16_t *data);
#line 305
static cc2420_status_t CC2420SpiP__Reg__write(uint8_t addr, uint16_t data);
#line 318
static cc2420_status_t CC2420SpiP__Strobe__strobe(uint8_t addr);










static void CC2420SpiP__SpiPacket__sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error);








static error_t CC2420SpiP__attemptRelease(void );
#line 358
static inline void CC2420SpiP__grant__runTask(void );








static inline void CC2420SpiP__Resource__default__granted(uint8_t id);


static inline void CC2420SpiP__Fifo__default__readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error);


static inline void CC2420SpiP__Fifo__default__writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error);
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t StateImplP__state[5U];

enum StateImplP____nesc_unnamed4388 {
  StateImplP__S_IDLE = 0
};


static inline error_t StateImplP__Init__init(void );
#line 96
static error_t StateImplP__State__requestState(uint8_t id, uint8_t reqState);
#line 111
static inline void StateImplP__State__forceState(uint8_t id, uint8_t reqState);






static inline void StateImplP__State__toIdle(uint8_t id);







static inline bool StateImplP__State__isIdle(uint8_t id);






static bool StateImplP__State__isState(uint8_t id, uint8_t myState);









static uint8_t StateImplP__State__getState(uint8_t id);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__sendDone(
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c068d0, 
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t * txBuf, 
uint8_t * rxBuf, 





uint16_t len, 
error_t error);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static msp430_spi_union_config_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__getConfig(
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3b970);
# 197 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__clrRxIntr(void );
#line 97
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__resetUsart(bool reset);
#line 224
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__tx(uint8_t data);
#line 168
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__setModeSpi(msp430_spi_union_config_t *config);
#line 231
static uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__rx(void );
#line 192
static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__isRxIntrPending(void );
#line 158
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__disableSpi(void );
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 73
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__startTransfer(void );
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__release(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__immediateRequest(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__request(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__isOwner(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c3cef0);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__granted(
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
uint8_t arg_0x1c07368);
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 73
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__startTransfer(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__postTask(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
enum /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0____nesc_unnamed4389 {
#line 74
  Msp430SpiDmaP__0__signalDone_task = 9U
};
#line 74
typedef int /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0____nesc_sillytask_signalDone_task[/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task];
#line 67
uint8_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_tx_buf;
uint8_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_rx_buf;
uint16_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_len;
uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_client;
uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_dump;

static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone(error_t error);


static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__immediateRequest(uint8_t id);



static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__request(uint8_t id);



static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__release(uint8_t id);



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__configure(uint8_t id);



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__unconfigure(uint8_t id);





static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__granted(uint8_t id);



static inline uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__isOwner(uint8_t id);



static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__isOwner(uint8_t id);
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__request(uint8_t id);
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__immediateRequest(uint8_t id);
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__release(uint8_t id);
static inline msp430_spi_union_config_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__default__getConfig(uint8_t id);



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__default__granted(uint8_t id);

static uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiByte__write(uint8_t tx);








static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len);
#line 180
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__runTask(void );



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__transferDone(error_t error);



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__transferDone(error_t error);

static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone(error_t error);



static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__txDone(void );
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__rxDone(uint8_t data);

static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__default__sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error);
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void HplMsp430Usart0P__UCLK__selectIOFunc(void );
#line 78
static void HplMsp430Usart0P__UCLK__selectModuleFunc(void );
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static void HplMsp430Usart0P__Interrupts__rxDone(uint8_t data);
#line 49
static void HplMsp430Usart0P__Interrupts__txDone(void );
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void HplMsp430Usart0P__URXD__selectIOFunc(void );
#line 85
static void HplMsp430Usart0P__UTXD__selectIOFunc(void );
# 7 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static void HplMsp430Usart0P__HplI2C__clearModeI2C(void );
#line 6
static bool HplMsp430Usart0P__HplI2C__isI2C(void );
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void HplMsp430Usart0P__SOMI__selectIOFunc(void );
#line 78
static void HplMsp430Usart0P__SOMI__selectModuleFunc(void );
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static void HplMsp430Usart0P__I2CInterrupts__fired(void );
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void HplMsp430Usart0P__SIMO__selectIOFunc(void );
#line 78
static void HplMsp430Usart0P__SIMO__selectModuleFunc(void );
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static volatile uint8_t HplMsp430Usart0P__IE1 __asm ("0x0000");
static volatile uint8_t HplMsp430Usart0P__ME1 __asm ("0x0004");
static volatile uint8_t HplMsp430Usart0P__IFG1 __asm ("0x0002");
static volatile uint8_t HplMsp430Usart0P__U0TCTL __asm ("0x0071");

static volatile uint8_t HplMsp430Usart0P__U0TXBUF __asm ("0x0077");

void sig_UART0RX_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(18)))  ;




void sig_UART0TX_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(16)))  ;
#line 132
static inline void HplMsp430Usart0P__Usart__setUbr(uint16_t control);










static inline void HplMsp430Usart0P__Usart__setUmctl(uint8_t control);







static inline void HplMsp430Usart0P__Usart__resetUsart(bool reset);
#line 207
static inline void HplMsp430Usart0P__Usart__disableUart(void );
#line 238
static inline void HplMsp430Usart0P__Usart__enableSpi(void );








static void HplMsp430Usart0P__Usart__disableSpi(void );








static inline void HplMsp430Usart0P__configSpi(msp430_spi_union_config_t *config);








static void HplMsp430Usart0P__Usart__setModeSpi(msp430_spi_union_config_t *config);
#line 330
static inline bool HplMsp430Usart0P__Usart__isRxIntrPending(void );










static inline void HplMsp430Usart0P__Usart__clrRxIntr(void );



static inline void HplMsp430Usart0P__Usart__clrIntr(void );
#line 357
static inline void HplMsp430Usart0P__Usart__disableIntr(void );
#line 382
static inline void HplMsp430Usart0P__Usart__tx(uint8_t data);



static inline uint8_t HplMsp430Usart0P__Usart__rx(void );
# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaInterrupt.nc"
static void HplMsp430DmaP__Interrupt__fired(void );
# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaP.nc"
void sig_DACDMA_VECTOR(void ) __attribute((wakeup)) __attribute((interrupt(0)))  ;
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__DMA__transferDone(error_t success);
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__Interrupt__fired(void );
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__transferDone(error_t success);
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static volatile uint16_t /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMACTL0 __asm ("0x0122");






static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__Interrupt__fired(void );








static inline error_t /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setTrigger(dma_trigger_t trigger);
#line 195
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__enableDMA(void );
#line 235
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setState(dma_channel_state_t s, 
dma_channel_trigger_t t, 
void *src, void *dest, 
uint16_t size);




static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setStateRaw(uint16_t s, uint16_t t, 
void *src, void *dest, 
uint16_t size);
# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__transferDone(error_t success);
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static volatile uint16_t /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMACTL0 __asm ("0x0122");






static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__Interrupt__fired(void );








static inline error_t /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setTrigger(dma_trigger_t trigger);
#line 195
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__enableDMA(void );
#line 235
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setState(dma_channel_state_t s, 
dma_channel_trigger_t t, 
void *src, void *dest, 
uint16_t size);




static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setStateRaw(uint16_t s, uint16_t t, 
void *src, void *dest, 
uint16_t size);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__transferDone(error_t success);
# 143 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__HplChannel__transferDone(error_t error);



static inline void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__default__transferDone(error_t error);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__enableDMA(void );
#line 64
static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__transferDone(error_t success);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
dma_channel_state_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState;
dma_channel_trigger_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelTrigger;







static inline error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 112
static inline error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__startTransfer(void );
#line 143
static inline void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__transferDone(error_t error);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__enableDMA(void );
#line 64
static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__transferDone(error_t success);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
dma_channel_state_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState;
dma_channel_trigger_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelTrigger;







static inline error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr);
#line 112
static inline error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__startTransfer(void );
#line 143
static inline void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__transferDone(error_t error);
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaControlP.nc"
static inline void Msp430DmaControlP__HplChannel0__transferDone(error_t error);
static inline void Msp430DmaControlP__HplChannel1__transferDone(error_t error);
static inline void Msp430DmaControlP__HplChannel2__transferDone(error_t error);
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__inUse(void );







static uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__userId(void );
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__rxDone(
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60288, 
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t data);
#line 49
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__txDone(
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60288);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__fired(
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1e60b08);








static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__txDone(void );




static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__rxDone(uint8_t data);




static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawI2CInterrupts__fired(void );




static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__txDone(uint8_t id);
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__rxDone(uint8_t id, uint8_t data);
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__default__fired(uint8_t id);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1____nesc_unnamed4390 {
#line 39
  FcfsResourceQueueC__1__NO_ENTRY = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ[1U];
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;

static inline error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__Init__init(void );




static inline bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEmpty(void );



static inline bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEnqueued(resource_client_id_t id);



static inline resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__dequeue(void );
#line 72
static inline error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__enqueue(resource_client_id_t id);
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__requested(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e70690);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__immediateRequested(
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e70690);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__unconfigure(
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e6ea58);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__configure(
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e6ea58);
# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__enqueue(resource_client_id_t id);
#line 43
static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__isEmpty(void );
#line 60
static resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__dequeue(void );
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__requested(void );
#line 46
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__granted(void );
#line 81
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__immediateRequested(void );
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__granted(
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1e71c20);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__postTask(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0____nesc_unnamed4391 {
#line 75
  ArbiterP__0__grantedTask = 10U
};
#line 75
typedef int /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0____nesc_sillytask_grantedTask[/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask];
#line 67
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0____nesc_unnamed4392 {
#line 67
  ArbiterP__0__RES_CONTROLLED, ArbiterP__0__RES_GRANTING, ArbiterP__0__RES_IMM_GRANTING, ArbiterP__0__RES_BUSY
};
#line 68
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0____nesc_unnamed4393 {
#line 68
  ArbiterP__0__default_owner_id = 1U
};
#line 69
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0____nesc_unnamed4394 {
#line 69
  ArbiterP__0__NO_RES = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED;
uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__default_owner_id;
uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId;



static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__request(uint8_t id);
#line 90
static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__immediateRequest(uint8_t id);
#line 108
static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__release(uint8_t id);
#line 130
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__release(void );
#line 150
static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__inUse(void );
#line 163
static uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__userId(void );










static uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__isOwner(uint8_t id);
#line 187
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__runTask(void );
#line 199
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__default__granted(uint8_t id);

static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__requested(uint8_t id);

static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__immediateRequested(uint8_t id);

static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__granted(void );

static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__requested(void );


static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__immediateRequested(void );


static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__configure(uint8_t id);

static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__unconfigure(uint8_t id);
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static void HplMsp430I2C0P__HplUsart__resetUsart(bool reset);
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
static volatile uint8_t HplMsp430I2C0P__U0CTL __asm ("0x0070");





static inline bool HplMsp430I2C0P__HplI2C__isI2C(void );



static inline void HplMsp430I2C0P__HplI2C__clearModeI2C(void );
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
am_addr_t ActiveMessageAddressC__addr = TOS_AM_ADDRESS;


am_group_t ActiveMessageAddressC__group = TOS_AM_GROUP;






static inline am_addr_t ActiveMessageAddressC__ActiveMessageAddress__amAddress(void );
#line 82
static inline am_group_t ActiveMessageAddressC__ActiveMessageAddress__amGroup(void );
#line 95
static inline am_addr_t ActiveMessageAddressC__amAddress(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void OneWireMasterC__Pin__makeInput(void );
#line 32
static bool OneWireMasterC__Pin__get(void );


static void OneWireMasterC__Pin__makeOutput(void );
#line 29
static void OneWireMasterC__Pin__set(void );
static void OneWireMasterC__Pin__clr(void );
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWait.nc"
static void OneWireMasterC__BusyWaitMicro__wait(OneWireMasterC__BusyWaitMicro__size_type dt);
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline void OneWireMasterC__OneWire__idle(void );




static inline void OneWireMasterC__OneWire__init(void );




static void OneWireMasterC__OneWire__release(void );




static inline error_t OneWireMasterC__OneWire__reset(void );
#line 75
static inline void OneWireMasterC__OneWire__writeOne(void );







static inline void OneWireMasterC__OneWire__writeZero(void );







static inline void OneWireMasterC__OneWire__writeByte(uint8_t b);
#line 105
static inline bool OneWireMasterC__OneWire__readBit(void );
#line 117
static inline uint8_t OneWireMasterC__OneWire__readByte(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
static void HplDs2401C__OneWire__release(void );
#line 37
static void HplDs2401C__OneWire__init(void );
#line 59
static void HplDs2401C__OneWire__writeByte(uint8_t b);
#line 46
static error_t HplDs2401C__OneWire__reset(void );
#line 68
static uint8_t HplDs2401C__OneWire__readByte(void );
# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/HplDs2401C.nc"
bool HplDs2401C__busy = FALSE;

static inline error_t HplDs2401C__Hpl__read(ds2401_serial_t *rom);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__size_type /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__get(void );
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWaitCounterC.nc"
enum /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0____nesc_unnamed4395 {

  BusyWaitCounterC__0__HALF_MAX_SIZE_TYPE = (/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type )1 << (8 * sizeof(/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type ) - 1)
};

static void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__wait(/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type dt);
#line 72
static inline void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__overflow(void );
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static uint16_t /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__get(void );
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static void /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__overflow(void );
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline uint16_t /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__get(void );
#line 53
static inline void /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__overflow(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeInput(void );






static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeOutput(void );
#line 59
static bool /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__get(void );
#line 34
static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__set(void );




static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__clr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__set(void );
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__clr(void );

static inline bool /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__get(void );
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeInput(void );

static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeOutput(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/HplDs2401.nc"
static error_t Ds2401ToIeeeEui64C__Hpl__read(ds2401_serial_t *rom);
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/Ds2401ToIeeeEui64C.nc"
static inline ieee_eui64_t Ds2401ToIeeeEui64C__LocalIeeeEui64__getId(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
static ieee_eui64_t CachedIeeeEui64P__SubIeeeEui64__getId(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/CachedIeeeEui64P.nc"
ieee_eui64_t CachedIeeeEui64P__eui;

static inline error_t CachedIeeeEui64P__Init__init(void );




static inline ieee_eui64_t CachedIeeeEui64P__LocalIeeeEui64__getId(void );
# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static void CC2420TransmitP__RadioBackoff__requestInitialBackoff(message_t * msg);






static void CC2420TransmitP__RadioBackoff__requestCongestionBackoff(message_t * msg);
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static void CC2420TransmitP__PacketTimeStamp__clear(
#line 55
message_t * msg);
#line 67
static void CC2420TransmitP__PacketTimeStamp__set(
#line 62
message_t * msg, 




CC2420TransmitP__PacketTimeStamp__size_type value);
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420TransmitP__STXONCCA__strobe(void );
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static error_t CC2420TransmitP__CaptureSFD__captureFallingEdge(void );
#line 55
static void CC2420TransmitP__CaptureSFD__disable(void );
#line 42
static error_t CC2420TransmitP__CaptureSFD__captureRisingEdge(void );
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static CC2420TransmitP__BackoffTimer__size_type CC2420TransmitP__BackoffTimer__getNow(void );
#line 55
static void CC2420TransmitP__BackoffTimer__start(CC2420TransmitP__BackoffTimer__size_type dt);






static void CC2420TransmitP__BackoffTimer__stop(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static cc2420_status_t CC2420TransmitP__TXFIFO_RAM__write(uint8_t offset, uint8_t * data, uint8_t length);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
static cc2420_status_t CC2420TransmitP__TXCTRL__write(uint16_t data);
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static void CC2420TransmitP__CC2420Receive__sfd_dropped(void );
#line 49
static void CC2420TransmitP__CC2420Receive__sfd(uint32_t time);
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static void CC2420TransmitP__Send__sendDone(message_t * p_msg, error_t error);
# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static void CC2420TransmitP__ChipSpiResource__abortRelease(void );







static error_t CC2420TransmitP__ChipSpiResource__attemptRelease(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420TransmitP__SFLUSHTX__strobe(void );
# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420TransmitP__CSN__makeOutput(void );
#line 29
static void CC2420TransmitP__CSN__set(void );
static void CC2420TransmitP__CSN__clr(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * CC2420TransmitP__CC2420PacketBody__getHeader(message_t * msg);










static cc2420_metadata_t * CC2420TransmitP__CC2420PacketBody__getMetadata(message_t * msg);
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
static uint8_t CC2420TransmitP__PacketTimeSyncOffset__get(
#line 42
message_t * msg);
#line 39
static bool CC2420TransmitP__PacketTimeSyncOffset__isSet(
#line 35
message_t * msg);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420TransmitP__SpiResource__release(void );
#line 87
static error_t CC2420TransmitP__SpiResource__immediateRequest(void );
#line 78
static error_t CC2420TransmitP__SpiResource__request(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420TransmitP__CCA__makeInput(void );
#line 32
static bool CC2420TransmitP__CCA__get(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420TransmitP__SNOP__strobe(void );
# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420TransmitP__SFD__makeInput(void );
#line 32
static bool CC2420TransmitP__SFD__get(void );
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static cc2420_status_t CC2420TransmitP__TXFIFO__write(uint8_t * data, uint8_t length);
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420TransmitP__STXON__strobe(void );
# 99 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
#line 89
typedef enum CC2420TransmitP____nesc_unnamed4396 {
  CC2420TransmitP__S_STOPPED, 
  CC2420TransmitP__S_STARTED, 
  CC2420TransmitP__S_LOAD, 
  CC2420TransmitP__S_SAMPLE_CCA, 
  CC2420TransmitP__S_BEGIN_TRANSMIT, 
  CC2420TransmitP__S_SFD, 
  CC2420TransmitP__S_EFD, 
  CC2420TransmitP__S_ACK_WAIT, 
  CC2420TransmitP__S_CANCEL
} CC2420TransmitP__cc2420_transmit_state_t;





enum CC2420TransmitP____nesc_unnamed4397 {
  CC2420TransmitP__CC2420_ABORT_PERIOD = 320
};
#line 120
message_t * CC2420TransmitP__m_msg;

bool CC2420TransmitP__m_cca;

uint8_t CC2420TransmitP__m_tx_power;

CC2420TransmitP__cc2420_transmit_state_t CC2420TransmitP__m_state = CC2420TransmitP__S_STOPPED;

bool CC2420TransmitP__m_receiving = FALSE;

uint16_t CC2420TransmitP__m_prev_time;


bool CC2420TransmitP__sfdHigh;


bool CC2420TransmitP__abortSpiRelease;


int8_t CC2420TransmitP__totalCcaChecks;


uint16_t CC2420TransmitP__myInitialBackoff;


uint16_t CC2420TransmitP__myCongestionBackoff;



static inline error_t CC2420TransmitP__send(message_t * p_msg, bool cca);

static void CC2420TransmitP__loadTXFIFO(void );
static void CC2420TransmitP__attemptSend(void );
static void CC2420TransmitP__congestionBackoff(void );
static error_t CC2420TransmitP__acquireSpiResource(void );
static inline error_t CC2420TransmitP__releaseSpiResource(void );
static void CC2420TransmitP__signalDone(error_t err);



static inline error_t CC2420TransmitP__Init__init(void );







static inline error_t CC2420TransmitP__StdControl__start(void );










static error_t CC2420TransmitP__StdControl__stop(void );
#line 192
static inline error_t CC2420TransmitP__Send__send(message_t * p_msg, bool useCca);
#line 243
static inline void CC2420TransmitP__RadioBackoff__setInitialBackoff(uint16_t backoffTime);







static inline void CC2420TransmitP__RadioBackoff__setCongestionBackoff(uint16_t backoffTime);







static __inline uint32_t CC2420TransmitP__getTime32(uint16_t captured_time);
#line 280
static inline void CC2420TransmitP__CaptureSFD__captured(uint16_t time);
#line 377
static inline void CC2420TransmitP__ChipSpiResource__releasing(void );
#line 389
static inline void CC2420TransmitP__CC2420Receive__receive(uint8_t type, message_t *ack_msg);
#line 416
static inline void CC2420TransmitP__SpiResource__granted(void );
#line 454
static inline void CC2420TransmitP__TXFIFO__writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);
#line 486
static inline void CC2420TransmitP__TXFIFO__readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);










static inline void CC2420TransmitP__BackoffTimer__fired(void );
#line 547
static inline error_t CC2420TransmitP__send(message_t * p_msg, bool cca);
#line 737
static void CC2420TransmitP__attemptSend(void );
#line 782
static void CC2420TransmitP__congestionBackoff(void );






static error_t CC2420TransmitP__acquireSpiResource(void );







static inline error_t CC2420TransmitP__releaseSpiResource(void );
#line 819
static void CC2420TransmitP__loadTXFIFO(void );
#line 844
static void CC2420TransmitP__signalDone(error_t err);
# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static bool CC2420ReceiveP__FIFO__get(void );
# 91 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static bool CC2420ReceiveP__CC2420Config__isAddressRecognitionEnabled(void );
#line 115
static bool CC2420ReceiveP__CC2420Config__isAutoAckEnabled(void );
#line 110
static bool CC2420ReceiveP__CC2420Config__isHwAutoAckDefault(void );
#line 64
static ieee_eui64_t CC2420ReceiveP__CC2420Config__getExtAddr(void );




static uint16_t CC2420ReceiveP__CC2420Config__getShortAddr(void );
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t CC2420ReceiveP__receiveDone_task__postTask(void );
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static void CC2420ReceiveP__PacketTimeStamp__clear(
#line 55
message_t * msg);
#line 67
static void CC2420ReceiveP__PacketTimeStamp__set(
#line 62
message_t * msg, 




CC2420ReceiveP__PacketTimeStamp__size_type value);
# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static bool CC2420ReceiveP__FIFOP__get(void );
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static void CC2420ReceiveP__CC2420Receive__receive(uint8_t type, message_t * message);
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420ReceiveP__SACK__strobe(void );
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static void CC2420ReceiveP__CSN__set(void );
static void CC2420ReceiveP__CSN__clr(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * CC2420ReceiveP__CC2420PacketBody__getHeader(message_t * msg);










static cc2420_metadata_t * CC2420ReceiveP__CC2420PacketBody__getMetadata(message_t * msg);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



CC2420ReceiveP__Receive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static error_t CC2420ReceiveP__SpiResource__release(void );
#line 87
static error_t CC2420ReceiveP__SpiResource__immediateRequest(void );
#line 78
static error_t CC2420ReceiveP__SpiResource__request(void );
#line 118
static bool CC2420ReceiveP__SpiResource__isOwner(void );
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static error_t CC2420ReceiveP__RXFIFO__continueRead(uint8_t * data, uint8_t length);
#line 51
static cc2420_status_t CC2420ReceiveP__RXFIFO__beginRead(uint8_t * data, uint8_t length);
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static error_t CC2420ReceiveP__InterruptFIFOP__disable(void );
#line 43
static error_t CC2420ReceiveP__InterruptFIFOP__enableFallingEdge(void );
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static cc2420_status_t CC2420ReceiveP__SFLUSHRX__strobe(void );
# 148 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
enum CC2420ReceiveP____nesc_unnamed4398 {
#line 148
  CC2420ReceiveP__receiveDone_task = 11U
};
#line 148
typedef int CC2420ReceiveP____nesc_sillytask_receiveDone_task[CC2420ReceiveP__receiveDone_task];
#line 89
#line 81
typedef enum CC2420ReceiveP____nesc_unnamed4399 {
  CC2420ReceiveP__S_STOPPED, 
  CC2420ReceiveP__S_STARTED, 
  CC2420ReceiveP__S_RX_LENGTH, 
  CC2420ReceiveP__S_RX_DEC, 
  CC2420ReceiveP__S_RX_DEC_WAIT, 
  CC2420ReceiveP__S_RX_FCF, 
  CC2420ReceiveP__S_RX_PAYLOAD
} CC2420ReceiveP__cc2420_receive_state_t;

enum CC2420ReceiveP____nesc_unnamed4400 {
  CC2420ReceiveP__RXFIFO_SIZE = 128, 
  CC2420ReceiveP__TIMESTAMP_QUEUE_SIZE = 8, 
  CC2420ReceiveP__SACK_HEADER_LENGTH = 7
};

uint32_t CC2420ReceiveP__m_timestamp_queue[CC2420ReceiveP__TIMESTAMP_QUEUE_SIZE];

uint8_t CC2420ReceiveP__m_timestamp_head;

uint8_t CC2420ReceiveP__m_timestamp_size;





uint8_t CC2420ReceiveP__m_missed_packets;



bool CC2420ReceiveP__receivingPacket;


uint8_t CC2420ReceiveP__rxFrameLength;

uint8_t CC2420ReceiveP__m_bytes_left;

message_t * CC2420ReceiveP__m_p_rx_buf;

message_t CC2420ReceiveP__m_rx_buf;
#line 137
CC2420ReceiveP__cc2420_receive_state_t CC2420ReceiveP__m_state;



static void CC2420ReceiveP__reset_state(void );
static void CC2420ReceiveP__beginReceive(void );
static void CC2420ReceiveP__receive(void );
static void CC2420ReceiveP__waitForNextPacket(void );
static void CC2420ReceiveP__flush(void );
static inline bool CC2420ReceiveP__passesAddressCheck(message_t * msg);




static inline error_t CC2420ReceiveP__Init__init(void );





static inline error_t CC2420ReceiveP__StdControl__start(void );
#line 171
static error_t CC2420ReceiveP__StdControl__stop(void );
#line 186
static inline void CC2420ReceiveP__CC2420Receive__sfd(uint32_t time);








static inline void CC2420ReceiveP__CC2420Receive__sfd_dropped(void );
#line 212
static inline void CC2420ReceiveP__InterruptFIFOP__fired(void );
#line 508
static inline void CC2420ReceiveP__SpiResource__granted(void );
#line 525
static inline void CC2420ReceiveP__RXFIFO__readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error);
#line 663
static inline void CC2420ReceiveP__RXFIFO__writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error);







static inline void CC2420ReceiveP__receiveDone_task__runTask(void );
#line 704
static inline void CC2420ReceiveP__CC2420Config__syncDone(error_t error);






static void CC2420ReceiveP__beginReceive(void );
#line 728
static void CC2420ReceiveP__flush(void );
#line 754
static void CC2420ReceiveP__receive(void );









static void CC2420ReceiveP__waitForNextPacket(void );
#line 808
static void CC2420ReceiveP__reset_state(void );










static inline bool CC2420ReceiveP__passesAddressCheck(message_t *msg);
# 66 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static error_t CC2420PacketP__Acks__requestAck(message_t *p_msg);









static inline bool CC2420PacketP__Acks__wasAcked(message_t *p_msg);





static inline int CC2420PacketP__getAddressLength(int type);








static inline uint8_t *CC2420PacketP__getNetwork(message_t *msg);
#line 120
static uint8_t CC2420PacketP__CC2420Packet__getNetwork(message_t *p_msg);
#line 138
static inline cc2420_header_t * CC2420PacketP__CC2420PacketBody__getHeader(message_t * msg);
#line 153
static inline cc2420_metadata_t *CC2420PacketP__CC2420PacketBody__getMetadata(message_t *msg);
#line 172
static void CC2420PacketP__PacketTimeStamp32khz__clear(message_t *msg);





static inline void CC2420PacketP__PacketTimeStamp32khz__set(message_t *msg, uint32_t value);
#line 211
static inline bool CC2420PacketP__PacketTimeSyncOffset__isSet(message_t *msg);








static inline uint8_t CC2420PacketP__PacketTimeSyncOffset__get(message_t *msg);
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__overflow(void );
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
uint32_t RandomMlcgC__seed;


static inline error_t RandomMlcgC__Init__init(void );
#line 58
static uint32_t RandomMlcgC__Random__rand32(void );
#line 78
static inline uint16_t RandomMlcgC__Random__rand16(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t UniqueSendP__SubSend__send(
#line 56
message_t * msg, 







uint8_t len);
#line 89
static void UniqueSendP__Send__sendDone(
#line 85
message_t * msg, 



error_t error);
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static uint16_t UniqueSendP__Random__rand16(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * UniqueSendP__CC2420PacketBody__getHeader(message_t * msg);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static void UniqueSendP__State__toIdle(void );
#line 45
static error_t UniqueSendP__State__requestState(uint8_t reqState);
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
uint8_t UniqueSendP__localSendId;

enum UniqueSendP____nesc_unnamed4401 {
  UniqueSendP__S_IDLE, 
  UniqueSendP__S_SENDING
};


static inline error_t UniqueSendP__Init__init(void );
#line 75
static inline error_t UniqueSendP__Send__send(message_t *msg, uint8_t len);
#line 104
static inline void UniqueSendP__SubSend__sendDone(message_t *msg, error_t error);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



UniqueReceiveP__Receive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * UniqueReceiveP__CC2420PacketBody__getHeader(message_t * msg);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



UniqueReceiveP__DuplicateReceive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 59 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/unique/UniqueReceiveP.nc"
#line 56
struct UniqueReceiveP____nesc_unnamed4402 {
  uint16_t source;
  uint8_t dsn;
} UniqueReceiveP__receivedMessages[4];

uint8_t UniqueReceiveP__writeIndex = 0;


uint8_t UniqueReceiveP__recycleSourceElement;

enum UniqueReceiveP____nesc_unnamed4403 {
  UniqueReceiveP__INVALID_ELEMENT = 0xFF
};


static inline error_t UniqueReceiveP__Init__init(void );









static inline bool UniqueReceiveP__hasSeen(uint16_t msgSource, uint8_t msgDsn);
static inline void UniqueReceiveP__insert(uint16_t msgSource, uint8_t msgDsn);
static inline uint16_t UniqueReceiveP__getSourceKey(message_t *msg);


static inline message_t *UniqueReceiveP__SubReceive__receive(message_t *msg, void *payload, 
uint8_t len);
#line 112
static inline bool UniqueReceiveP__hasSeen(uint16_t msgSource, uint8_t msgDsn);
#line 138
static inline void UniqueReceiveP__insert(uint16_t msgSource, uint8_t msgDsn);
#line 165
static inline uint16_t UniqueReceiveP__getSourceKey(message_t *msg);
#line 192
static inline message_t *UniqueReceiveP__DuplicateReceive__default__receive(message_t *msg, void *payload, uint8_t len);
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t CC2420TinyosNetworkP__SubSend__send(
#line 56
message_t * msg, 







uint8_t len);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t CC2420TinyosNetworkP__grantTask__postTask(void );
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Packet.nc"
static uint8_t CC2420TinyosNetworkP__CC2420Packet__getNetwork(message_t *p_msg);
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void CC2420TinyosNetworkP__ActiveSend__sendDone(
#line 85
message_t * msg, 



error_t error);
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static bool CC2420TinyosNetworkP__Queue__isEmpty(void );
#line 60
static resource_client_id_t CC2420TinyosNetworkP__Queue__dequeue(void );
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_header_t * CC2420TinyosNetworkP__CC2420PacketBody__getHeader(message_t * msg);










static cc2420_metadata_t * CC2420TinyosNetworkP__CC2420PacketBody__getMetadata(message_t * msg);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



CC2420TinyosNetworkP__BareReceive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static void CC2420TinyosNetworkP__Resource__granted(
# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
uint8_t arg_0x222b8a0);
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void CC2420TinyosNetworkP__BareSend__sendDone(
#line 85
message_t * msg, 



error_t error);
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static 
#line 63
message_t * 



CC2420TinyosNetworkP__ActiveReceive__receive(
#line 60
message_t * msg, 
void * payload, 





uint8_t len);
# 184 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
enum CC2420TinyosNetworkP____nesc_unnamed4404 {
#line 184
  CC2420TinyosNetworkP__grantTask = 12U
};
#line 184
typedef int CC2420TinyosNetworkP____nesc_sillytask_grantTask[CC2420TinyosNetworkP__grantTask];
#line 68
enum CC2420TinyosNetworkP____nesc_unnamed4405 {
  CC2420TinyosNetworkP__OWNER_NONE = 0xff, 
  CC2420TinyosNetworkP__TINYOS_N_NETWORKS = 0U
};

uint8_t CC2420TinyosNetworkP__resource_owner = CC2420TinyosNetworkP__OWNER_NONE;
#line 73
uint8_t CC2420TinyosNetworkP__next_owner;
#line 96
static inline void CC2420TinyosNetworkP__BarePacket__clear(message_t *msg);



static inline uint8_t CC2420TinyosNetworkP__BarePacket__payloadLength(message_t *msg);




static void CC2420TinyosNetworkP__BarePacket__setPayloadLength(message_t *msg, uint8_t len);




static inline uint8_t CC2420TinyosNetworkP__BarePacket__maxPayloadLength(void );







static inline error_t CC2420TinyosNetworkP__BareSend__send(message_t *msg, uint8_t len);
#line 142
static inline void *CC2420TinyosNetworkP__BareSend__getPayload(message_t *msg, uint8_t len);









static inline void CC2420TinyosNetworkP__SubSend__sendDone(message_t *msg, error_t error);








static inline message_t *CC2420TinyosNetworkP__SubReceive__receive(message_t *msg, void *payload, uint8_t len);
#line 184
static inline void CC2420TinyosNetworkP__grantTask__runTask(void );
#line 233
static inline error_t CC2420TinyosNetworkP__Resource__release(uint8_t id);
#line 251
static inline message_t *CC2420TinyosNetworkP__ActiveReceive__default__receive(message_t *msg, void *payload, uint8_t len);


static inline void CC2420TinyosNetworkP__ActiveSend__default__sendDone(message_t *msg, error_t error);


static inline void CC2420TinyosNetworkP__Resource__default__granted(uint8_t client);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0____nesc_unnamed4406 {
#line 39
  FcfsResourceQueueC__0__NO_ENTRY = 0xFF
};
uint8_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__resQ[0];
uint8_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;
uint8_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qTail = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;

static inline error_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__Init__init(void );




static inline bool /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__isEmpty(void );







static inline resource_client_id_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__dequeue(void );
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static error_t PacketLinkP__SubSend__send(
#line 56
message_t * msg, 







uint8_t len);
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static error_t PacketLinkP__send__postTask(void );
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static void PacketLinkP__DelayTimer__startOneShot(uint32_t dt);




static void PacketLinkP__DelayTimer__stop(void );
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static void PacketLinkP__Send__sendDone(
#line 85
message_t * msg, 



error_t error);
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static uint8_t PacketLinkP__SendState__getState(void );
#line 56
static void PacketLinkP__SendState__toIdle(void );
#line 45
static error_t PacketLinkP__SendState__requestState(uint8_t reqState);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static cc2420_metadata_t * PacketLinkP__CC2420PacketBody__getMetadata(message_t * msg);
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static error_t PacketLinkP__PacketAcknowledgements__requestAck(
#line 42
message_t * msg);
#line 74
static bool PacketLinkP__PacketAcknowledgements__wasAcked(
#line 69
message_t * msg);
# 77 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
enum PacketLinkP____nesc_unnamed4407 {
#line 77
  PacketLinkP__send = 13U
};
#line 77
typedef int PacketLinkP____nesc_sillytask_send[PacketLinkP__send];
#line 58
message_t *PacketLinkP__currentSendMsg;


uint8_t PacketLinkP__currentSendLen;


uint16_t PacketLinkP__totalRetries;





enum PacketLinkP____nesc_unnamed4408 {
  PacketLinkP__S_IDLE, 
  PacketLinkP__S_SENDING
};




static void PacketLinkP__signalDone(error_t error);









static inline void PacketLinkP__PacketLink__setRetries(message_t *msg, uint16_t maxRetries);








static inline void PacketLinkP__PacketLink__setRetryDelay(message_t *msg, uint16_t retryDelay);






static inline uint16_t PacketLinkP__PacketLink__getRetries(message_t *msg);






static inline uint16_t PacketLinkP__PacketLink__getRetryDelay(message_t *msg);






static inline bool PacketLinkP__PacketLink__wasDelivered(message_t *msg);
#line 130
static inline error_t PacketLinkP__Send__send(message_t *msg, uint8_t len);
#line 171
static inline void PacketLinkP__SubSend__sendDone(message_t *msg, error_t error);
#line 202
static inline void PacketLinkP__DelayTimer__fired(void );






static inline void PacketLinkP__send__runTask(void );










static void PacketLinkP__signalDone(error_t error);
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__free;
uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__index;
/*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t * /*IPDispatchC.FragPool.PoolP*/PoolP__0__queue[12];
/*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool[12];

static inline error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Init__init(void );
#line 79
static inline uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__size(void );








static inline /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t */*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__get(void );
#line 103
static error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__put(/*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t *newVal);
#line 60
uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free;
uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index;
/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t * /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__queue[12];
/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool[12];

static inline error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Init__init(void );
#line 79
static inline uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__size(void );








static inline /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t */*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__get(void );
#line 103
static error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__put(/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t *newVal);
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/QueueC.nc"
/*IPDispatchC.QueueC*/QueueC__0__queue_t  /*IPDispatchC.QueueC*/QueueC__0__queue[12];
uint8_t /*IPDispatchC.QueueC*/QueueC__0__head = 0;
uint8_t /*IPDispatchC.QueueC*/QueueC__0__tail = 0;
uint8_t /*IPDispatchC.QueueC*/QueueC__0__size = 0;

static inline bool /*IPDispatchC.QueueC*/QueueC__0__Queue__empty(void );



static inline uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__size(void );



static inline uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__maxSize(void );



static inline /*IPDispatchC.QueueC*/QueueC__0__queue_t /*IPDispatchC.QueueC*/QueueC__0__Queue__head(void );



static inline void /*IPDispatchC.QueueC*/QueueC__0__printQueue(void );
#line 85
static /*IPDispatchC.QueueC*/QueueC__0__queue_t /*IPDispatchC.QueueC*/QueueC__0__Queue__dequeue(void );
#line 97
static inline error_t /*IPDispatchC.QueueC*/QueueC__0__Queue__enqueue(/*IPDispatchC.QueueC*/QueueC__0__queue_t newVal);
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free;
uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index;
/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t * /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__queue[3];
/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool[3];

static inline error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Init__init(void );
#line 79
static inline uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__size(void );








static inline /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t */*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__get(void );
#line 103
static error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__put(/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t *newVal);
# 69 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
static uint16_t IPAddressP__CC2420Config__getShortAddr(void );





static uint16_t IPAddressP__CC2420Config__getPanAddr(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
static ieee_eui64_t IPAddressP__LocalIeeeEui64__getId(void );
# 37 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
static inline bool IPAddressP__IPAddress__getLLAddr(struct in6_addr *addr);
#line 57
static inline bool IPAddressP__IPAddress__setSource(struct ip6_hdr *hdr);
#line 75
static error_t IPAddressP__IPAddress__resolveAddress(struct in6_addr *addr, ieee154_addr_t *link_addr);
#line 105
static inline bool IPAddressP__IPAddress__isLocalAddress(struct in6_addr *addr);
#line 135
static inline void IPAddressP__CC2420Config__syncDone(error_t err);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static void IPAddressFilterP__ForwardIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
# 51 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
static bool IPAddressFilterP__IPAddress__isLocalAddress(struct in6_addr *addr);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static void IPAddressFilterP__LocalIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
#line 17
static error_t IPAddressFilterP__SubIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg);
# 13 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressFilterP.nc"
static inline void IPAddressFilterP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);







static inline error_t IPAddressFilterP__LocalIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg);







static inline void IPAddressFilterP__ForwardIP__default__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
static error_t IPProtocolsP__IPAddress__resolveAddress(struct in6_addr *addr, ieee154_addr_t *link_addr);
# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
static error_t IPProtocolsP__SubIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
static void IPProtocolsP__IP__recv(
# 4 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
uint8_t arg_0x23274a0, 
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
void *headers, void *payload, size_t len, struct ip6_metadata *meta);
# 12 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
static inline void IPProtocolsP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta);
#line 29
static error_t IPProtocolsP__IP__send(uint8_t nxt_hdr, struct ip6_packet *msg);
#line 46
static inline void IPProtocolsP__IP__default__recv(uint8_t nxt_hdr, void *iph, void *payload, size_t len, struct ip6_metadata *meta);
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
static void ICMPCoreP__ICMP_IP__recv(
# 13 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMPCoreP.nc"
uint8_t arg_0x2337ef8, 
# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
void *headers, void *payload, size_t len, struct ip6_metadata *meta);
#line 17
static error_t ICMPCoreP__IP__send(struct ip6_packet *msg);
# 30 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMPCoreP.nc"
static inline void ICMPCoreP__IP__recv(void *iph, void *payload, size_t len, struct ip6_metadata *meta);
#line 70
static inline void ICMPCoreP__ICMP_IP__default__recv(uint8_t nxt_hdr, void *iph, void *payload, size_t len, struct ip6_metadata *meta);
# 39 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
static bool UdpP__IPAddress__setSource(struct ip6_hdr *hdr);
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static void UdpP__UDP__recvfrom(
# 7 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x23a6e58, 
# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *src, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
static error_t UdpP__IP__send(struct ip6_packet *msg);
# 19 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
enum UdpP____nesc_unnamed4409 {
  UdpP__N_CLIENTS = 3U
};


uint16_t UdpP__local_ports[UdpP__N_CLIENTS];

enum UdpP____nesc_unnamed4410 {
  UdpP__LOCAL_PORT_START = 51024U, 
  UdpP__LOCAL_PORT_STOP = 54999U
};
uint16_t UdpP__last_localport = UdpP__LOCAL_PORT_START;

static inline uint16_t UdpP__alloc_lport(uint8_t clnt);
#line 50
static inline error_t UdpP__Init__init(void );





static error_t UdpP__UDP__bind(uint8_t clnt, uint16_t port);
#line 68
static inline void UdpP__IP__recv(void *headers, 
void *payload, 
size_t len, 
struct ip6_metadata *meta);
#line 125
static error_t UdpP__UDP__sendto(uint8_t clnt, struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 171
static inline void UdpP__Statistics__clear(void );





static inline void UdpP__Statistics__get(udp_statistics_t *buf);





static inline void UdpP__UDP__default__recvfrom(uint8_t clnt, struct sockaddr_in6 *from, void *payload, 
uint16_t len, struct ip6_metadata *meta);
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static UDPShellP__Uptime__size_type UDPShellP__Uptime__get(void );
# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
static error_t UDPShellP__UDP__sendto(struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 10
static error_t UDPShellP__UDP__bind(uint16_t port);
# 11 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/ShellCommand.nc"
static char *UDPShellP__ShellCommand__eval(
# 30 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x23fb130, 
# 11 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/ShellCommand.nc"
int argc, char **argv);
# 3 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/RegisterShellCommand.nc"
static char *UDPShellP__RegisterShellCommand__getCommandName(
# 31 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x23fa130);
#line 48
struct sockaddr_in6 UDPShellP__session_endpoint;
uint32_t UDPShellP__boot_time;
uint64_t UDPShellP__uptime;

enum UDPShellP____nesc_unnamed4411 {
  UDPShellP__N_EXTERNAL = 0U
};


enum UDPShellP____nesc_unnamed4412 {
  UDPShellP__N_BUILTINS = 5, 

  UDPShellP__N_ARGS = 10, 
  UDPShellP__CMD_HELP = 0, 
  UDPShellP__CMD_ECHO = 1, 
  UDPShellP__CMD_PING6 = 2, 
  UDPShellP__CMD_TRACERT6 = 3, 

  UDPShellP__CMD_NO_CMD = 0xfe, 
  UDPShellP__CMDNAMSIZ = 10
};

struct UDPShellP__cmd_name {
  uint8_t c_len;
  char c_name[UDPShellP__CMDNAMSIZ];
};
struct UDPShellP__cmd_builtin {
  void (*action)(int arg_0x23ef3a8, char **arg_0x23ef540);
};

struct UDPShellP__cmd_name UDPShellP__externals[UDPShellP__N_EXTERNAL];


static inline void UDPShellP__Boot__booted(void );
#line 100
char UDPShellP__reply_buf[MAX_REPLY_LEN];
char *UDPShellP__help_str = "sdsh-0.9\tbuiltins: [help, echo, ping6, uptime, ident]\n";


char *UDPShellP__ident_string = "\t[app: "
"UDPEchoC""]\n\t[user: ""stevedh""]\n\t[host: ""oxtail"
"]\n\t[time: ""0x4be1e4d2L""]\n";


static inline void UDPShellP__action_help(int argc, char **argv);
#line 149
static void UDPShellP__action_echo(int argc, char **argv);
#line 167
static void UDPShellP__action_ping6(int argc, char **argv);








static void UDPShellP__action_uptime(int argc, char **argv);
#line 188
static inline void UDPShellP__action_ident(int argc, char **argv);




struct UDPShellP__cmd_name UDPShellP__builtins[UDPShellP__N_BUILTINS] = { { 4, "help" }, 
{ 4, "echo" }, 
{ 5, "ping6" }, 
{ 6, "uptime" }, 
{ 5, "ident" } };
struct UDPShellP__cmd_builtin UDPShellP__builtin_actions[UDPShellP__N_BUILTINS] = { { UDPShellP__action_help }, 
{ UDPShellP__action_echo }, 
{ UDPShellP__action_ping6 }, 
{ UDPShellP__action_uptime }, 
{ UDPShellP__action_ident } };




static inline void UDPShellP__init_argv(char *cmd, uint16_t len, char **argv, int *argc);
#line 226
static int UDPShellP__lookup_cmd(char *cmd, int dbsize, struct UDPShellP__cmd_name *db);









static inline void UDPShellP__UDP__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta);
#line 279
static inline void UDPShellP__Uptime__overflow(void );





static inline char *UDPShellP__ShellCommand__default__eval(uint8_t cmd_id, int argc, char **argv);


static inline char *UDPShellP__RegisterShellCommand__default__getCommandName(uint8_t cmd_id);
# 212 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  void __nesc_enable_interrupt(void )
{
   __asm volatile ("eint");}

# 185 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Timer__overflow(void )
{
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWaitCounterC.nc"
static inline void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__overflow(void )
{
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static void /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__overflow(void ){
#line 71
  /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__overflow();
#line 71
}
#line 71
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline void /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__overflow(void )
{
  /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__overflow();
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__overflow(void ){
#line 37
  /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Timer__overflow();
#line 37
}
#line 37
# 126 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Overflow__fired(void )
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__overflow();
}





static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__default__fired(uint8_t n)
{
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__fired(uint8_t arg_0x138b9c0){
#line 28
  switch (arg_0x138b9c0) {
#line 28
    case 0:
#line 28
      /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Event__fired();
#line 28
      break;
#line 28
    case 1:
#line 28
      /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Event__fired();
#line 28
      break;
#line 28
    case 2:
#line 28
      /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Event__fired();
#line 28
      break;
#line 28
    case 5:
#line 28
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Overflow__fired();
#line 28
      break;
#line 28
    default:
#line 28
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__default__fired(arg_0x138b9c0);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 115 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX0__fired(void )
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__fired(0);
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static void Msp430TimerCommonP__VectorTimerA0__fired(void ){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX0__fired();
#line 28
}
#line 28
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0____nesc_unnamed4413 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__int2CC(* (volatile uint16_t * )354U);
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__default__captured(time);
#line 75
}
#line 75
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__getEvent(void )
{
  return * (volatile uint16_t * )370U;
}

#line 181
static inline void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__default__fired();
#line 34
}
#line 34
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1____nesc_unnamed4414 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__int2CC(* (volatile uint16_t * )356U);
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__default__captured(time);
#line 75
}
#line 75
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__getEvent(void )
{
  return * (volatile uint16_t * )372U;
}

#line 181
static inline void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__default__fired();
#line 34
}
#line 34
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2____nesc_unnamed4415 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__int2CC(* (volatile uint16_t * )358U);
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__default__captured(time);
#line 75
}
#line 75
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__getEvent(void )
{
  return * (volatile uint16_t * )374U;
}

#line 181
static inline void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__default__fired();
#line 34
}
#line 34
# 120 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX1__fired(void )
{
  uint8_t n = * (volatile uint16_t * )302U;

#line 123
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Event__fired(n >> 1);
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static void Msp430TimerCommonP__VectorTimerA1__fired(void ){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__VectorTimerX1__fired();
#line 28
}
#line 28
# 115 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX0__fired(void )
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__fired(0);
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static void Msp430TimerCommonP__VectorTimerB0__fired(void ){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX0__fired();
#line 28
}
#line 28
# 185 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Timer__overflow(void )
{
}

#line 185
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__overflow(void )
{
}

# 103 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__overflow(void )
{
}

#line 103
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__overflow(void )
{
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__overflow(void )
{
}

# 166 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__overflow(void )
{
}

# 279 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP__Uptime__overflow(void )
#line 279
{
  /* atomic removed: atomic calls only */
  UDPShellP__uptime += 0xffffffff;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static void /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__overflow(void ){
#line 71
  UDPShellP__Uptime__overflow();
#line 71
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__overflow();
#line 71
  /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC__0__Counter__overflow();
#line 71
}
#line 71
# 122 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline void /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__overflow(void )
{
  /* atomic removed: atomic calls only */
  {
    /*CounterMilli32C.Transform*/TransformCounterC__0__m_upper++;
    if ((/*CounterMilli32C.Transform*/TransformCounterC__0__m_upper & /*CounterMilli32C.Transform*/TransformCounterC__0__OVERFLOW_MASK) == 0) {
      /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__overflow();
      }
  }
}

# 166 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__overflow(void )
{
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__overflow(void )
{
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static void /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__overflow(void ){
#line 71
  /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC__1__Counter__overflow();
#line 71
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__overflow();
#line 71
}
#line 71
# 122 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline void /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__overflow(void )
{
  /* atomic removed: atomic calls only */
  {
    /*Counter32khz32C.Transform*/TransformCounterC__1__m_upper++;
    if ((/*Counter32khz32C.Transform*/TransformCounterC__1__m_upper & /*Counter32khz32C.Transform*/TransformCounterC__1__OVERFLOW_MASK) == 0) {
      /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__overflow();
      }
  }
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static void /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__overflow(void ){
#line 71
  /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__overflow();
#line 71
  /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__overflow();
#line 71
}
#line 71
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline void /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__overflow(void )
{
  /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__overflow();
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__overflow(void ){
#line 37
  /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__overflow();
#line 37
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__overflow();
#line 37
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Timer__overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Timer__overflow();
#line 37
}
#line 37
# 126 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Overflow__fired(void )
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__overflow();
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 70 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__fired(void )
{
#line 71
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__postTask();
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__fired(void ){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__fired();
#line 67
}
#line 67
# 151 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__fired(void )
{
  /* atomic removed: atomic calls only */
  {
    if (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt == 0) 
      {
        /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__fired();
      }
    else 
      {
        /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__set_alarm();
      }
  }
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__fired(void ){
#line 67
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__fired();
#line 67
}
#line 67
# 124 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__disableEvents(void )
{
  * (volatile uint16_t * )386U &= ~0x0010;
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__disableEvents(void ){
#line 47
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__disableEvents();
#line 47
}
#line 47
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__fired(void )
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__disableEvents();
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__fired();
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__fired(void ){
#line 34
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__getEvent(void )
{
  return * (volatile uint16_t * )402U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3____nesc_unnamed4416 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__int2CC(* (volatile uint16_t * )386U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__captured(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__fired();
    }
}

# 86 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline bool SchedulerBasicP__isWaiting(uint8_t id)
{
  return SchedulerBasicP__m_next[id] != SchedulerBasicP__NO_TASK || SchedulerBasicP__m_tail == id;
}

static inline bool SchedulerBasicP__pushTask(uint8_t id)
{
  if (!SchedulerBasicP__isWaiting(id)) 
    {
      if (SchedulerBasicP__m_head == SchedulerBasicP__NO_TASK) 
        {
          SchedulerBasicP__m_head = id;
          SchedulerBasicP__m_tail = id;
        }
      else 
        {
          SchedulerBasicP__m_next[SchedulerBasicP__m_tail] = id;
          SchedulerBasicP__m_tail = id;
        }
      return TRUE;
    }
  else 
    {
      return FALSE;
    }
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__get(void )
{
  return /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__get();
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__size_type /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__get(void ){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 70 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__isOverflowPending(void )
{
  return * (volatile uint16_t * )384U & 1U;
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static bool /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__isOverflowPending(void ){
#line 35
  unsigned char result;
#line 35

#line 35
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__isOverflowPending();
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline bool /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__isOverflowPending(void )
{
  return /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Msp430Timer__isOverflowPending();
}

# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static bool /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__isOverflowPending(void ){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__isOverflowPending();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 119 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__enableEvents(void )
{
  * (volatile uint16_t * )386U |= 0x0010;
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__enableEvents(void ){
#line 46
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__enableEvents();
#line 46
}
#line 46
# 84 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__clearPendingInterrupt(void )
{
  * (volatile uint16_t * )386U &= ~0x0001;
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__clearPendingInterrupt(void ){
#line 33
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__clearPendingInterrupt();
#line 33
}
#line 33
# 144 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEvent(uint16_t x)
{
  * (volatile uint16_t * )402U = x;
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEvent(uint16_t time){
#line 30
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEvent(time);
#line 30
}
#line 30
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 154 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEventFromNow(uint16_t x)
{
  * (volatile uint16_t * )402U = /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Timer__get() + x;
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEventFromNow(uint16_t delta){
#line 32
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Compare__setEventFromNow(delta);
#line 32
}
#line 32
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 70 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__startAt(uint16_t t0, uint16_t dt)
{
  /* atomic removed: atomic calls only */
  {
    uint16_t now = /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Timer__get();
    uint16_t elapsed = now - t0;

#line 76
    if (elapsed >= dt) 
      {
        /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEventFromNow(2);
      }
    else 
      {
        uint16_t remaining = dt - elapsed;

#line 83
        if (remaining <= 2) {
          /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEventFromNow(2);
          }
        else {
#line 86
          /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430Compare__setEvent(now + remaining);
          }
      }
#line 88
    /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__clearPendingInterrupt();
    /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__enableEvents();
  }
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__size_type dt){
#line 92
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__startAt(t0, dt);
#line 92
}
#line 92
# 181 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__default__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__getEvent(void )
{
  return * (volatile uint16_t * )404U;
}

# 276 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint16_t __nesc_ntoh_leuint16(const void * source)
#line 276
{
  const uint8_t *base = source;

#line 278
  return ((uint16_t )base[1] << 8) | base[0];
}

#line 301
static __inline  uint32_t __nesc_hton_uint32(void * target, uint32_t value)
#line 301
{
  uint8_t *base = target;

#line 303
  base[3] = value;
  base[2] = value >> 8;
  base[1] = value >> 16;
  base[0] = value >> 24;
  return value;
}

#line 294
static __inline  uint32_t __nesc_ntoh_uint32(const void * source)
#line 294
{
  const uint8_t *base = source;

#line 296
  return ((((uint32_t )base[0] << 24) | (
  (uint32_t )base[1] << 16)) | (
  (uint32_t )base[2] << 8)) | base[3];
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static void CC2420TransmitP__PacketTimeStamp__clear(message_t * msg){
#line 59
  CC2420PacketP__PacketTimeStamp32khz__clear(msg);
#line 59
}
#line 59
# 195 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__CC2420Receive__sfd_dropped(void )
#line 195
{
  if (CC2420ReceiveP__m_timestamp_size) {
      CC2420ReceiveP__m_timestamp_size--;
    }
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static void CC2420TransmitP__CC2420Receive__sfd_dropped(void ){
#line 55
  CC2420ReceiveP__CC2420Receive__sfd_dropped();
#line 55
}
#line 55
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureRisingEdge(void )
#line 50
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__enableCapture(MSP430TIMER_CM_RISING);
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static error_t CC2420TransmitP__CaptureSFD__captureRisingEdge(void ){
#line 42
  unsigned char result;
#line 42

#line 42
  result = /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__getRaw(void )
#line 48
{
#line 48
  return * (volatile uint8_t * )28U & (0x01 << 1);
}

#line 49
static inline bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__get(void )
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__getRaw() != 0;
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static bool /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__get(void ){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__get(void )
#line 40
{
#line 40
  return /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__get();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static bool CC2420TransmitP__SFD__get(void ){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 186 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__CC2420Receive__sfd(uint32_t time)
#line 186
{
  if (CC2420ReceiveP__m_timestamp_size < CC2420ReceiveP__TIMESTAMP_QUEUE_SIZE) {
      uint8_t tail = (CC2420ReceiveP__m_timestamp_head + CC2420ReceiveP__m_timestamp_size) % 
      CC2420ReceiveP__TIMESTAMP_QUEUE_SIZE;

#line 190
      CC2420ReceiveP__m_timestamp_queue[tail] = time;
      CC2420ReceiveP__m_timestamp_size++;
    }
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static void CC2420TransmitP__CC2420Receive__sfd(uint32_t time){
#line 49
  CC2420ReceiveP__CC2420Receive__sfd(time);
#line 49
}
#line 49
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureFallingEdge(void )
#line 54
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__enableCapture(MSP430TIMER_CM_FALLING);
}

# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static error_t CC2420TransmitP__CaptureSFD__captureFallingEdge(void ){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captureFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__get(void ){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__getNow(void )
{
  return /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__get();
}

#line 146
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type dt)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__getNow(), dt);
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void CC2420TransmitP__BackoffTimer__start(CC2420TransmitP__BackoffTimer__size_type dt){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__start(dt);
#line 55
}
#line 55
# 138 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline cc2420_header_t * CC2420PacketP__CC2420PacketBody__getHeader(message_t * msg)
#line 138
{
  return (cc2420_header_t * )((uint8_t *)msg + (size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * CC2420TransmitP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 124 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__disableEvents(void )
{
  * (volatile uint16_t * )390U &= ~0x0010;
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__disableEvents(void ){
#line 47
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__disableEvents();
#line 47
}
#line 47
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__stop(void )
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__disableEvents();
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__stop(void ){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__stop();
#line 62
}
#line 62
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__stop(void )
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__stop();
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void CC2420TransmitP__BackoffTimer__stop(void ){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__stop();
#line 62
}
#line 62
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420TransmitP__SpiResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP__Resource__release(/*CC2420TransmitC.Spi*/CC2420SpiC__3__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 797 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP__releaseSpiResource(void )
#line 797
{
  CC2420TransmitP__SpiResource__release();
  return SUCCESS;
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set(void )
#line 37
{
#line 37
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420TransmitP__CSN__set(void ){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set();
#line 29
}
#line 29
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
inline static cc2420_status_t CC2420TransmitP__TXFIFO_RAM__write(uint8_t offset, uint8_t * data, uint8_t length){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420SpiP__Ram__write(CC2420_RAM_TXFIFO, offset, data, length);
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__clr(void ){
#line 39
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__clr();
#line 39
}
#line 39
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr(void )
#line 38
{
#line 38
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__clr();
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420TransmitP__CSN__clr(void ){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr();
#line 30
}
#line 30
# 246 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint8_t __nesc_ntoh_leuint8(const void * source)
#line 246
{
  const uint8_t *base = source;

#line 248
  return base[0];
}

# 220 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline uint8_t CC2420PacketP__PacketTimeSyncOffset__get(message_t *msg)
{
  return __nesc_ntoh_leuint8(CC2420PacketP__CC2420PacketBody__getHeader(msg)->length.data)
   + (sizeof(cc2420_header_t ) - MAC_HEADER_SIZE)
   - MAC_FOOTER_SIZE
   - sizeof(timesync_radio_t );
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
inline static uint8_t CC2420TransmitP__PacketTimeSyncOffset__get(message_t * msg){
#line 47
  unsigned char result;
#line 47

#line 47
  result = CC2420PacketP__PacketTimeSyncOffset__get(msg);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 235 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint8_t __nesc_ntoh_uint8(const void * source)
#line 235
{
  const uint8_t *base = source;

#line 237
  return base[0];
}

#line 257
static __inline  int8_t __nesc_ntoh_int8(const void * source)
#line 257
{
#line 257
  return __nesc_ntoh_uint8(source);
}

# 153 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline cc2420_metadata_t *CC2420PacketP__CC2420PacketBody__getMetadata(message_t *msg)
#line 153
{
  return (cc2420_metadata_t *)msg->metadata;
}

#line 211
static inline bool CC2420PacketP__PacketTimeSyncOffset__isSet(message_t *msg)
{
  return __nesc_ntoh_int8(CC2420PacketP__CC2420PacketBody__getMetadata(msg)->timesync.data);
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
inline static bool CC2420TransmitP__PacketTimeSyncOffset__isSet(message_t * msg){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420PacketP__PacketTimeSyncOffset__isSet(msg);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 178 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline void CC2420PacketP__PacketTimeStamp32khz__set(message_t *msg, uint32_t value)
{
  __nesc_hton_uint32(CC2420PacketP__CC2420PacketBody__getMetadata(msg)->timestamp.data, value);
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static void CC2420TransmitP__PacketTimeStamp__set(message_t * msg, CC2420TransmitP__PacketTimeStamp__size_type value){
#line 67
  CC2420PacketP__PacketTimeStamp32khz__set(msg, value);
#line 67
}
#line 67
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static CC2420TransmitP__BackoffTimer__size_type CC2420TransmitP__BackoffTimer__getNow(void ){
#line 98
  unsigned long result;
#line 98

#line 98
  result = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 259 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static __inline uint32_t CC2420TransmitP__getTime32(uint16_t captured_time)
{
  uint32_t now = CC2420TransmitP__BackoffTimer__getNow();


  return now - (uint16_t )(now - captured_time);
}

#line 280
static inline void CC2420TransmitP__CaptureSFD__captured(uint16_t time)
#line 280
{
  unsigned char *__nesc_temp47;
  unsigned char *__nesc_temp46;
#line 281
  uint32_t time32;
  uint8_t sfd_state = 0;

  /* atomic removed: atomic calls only */
#line 283
  {
    time32 = CC2420TransmitP__getTime32(time);
    switch (CC2420TransmitP__m_state) {

        case CC2420TransmitP__S_SFD: 
          CC2420TransmitP__m_state = CC2420TransmitP__S_EFD;
        CC2420TransmitP__sfdHigh = TRUE;


        CC2420TransmitP__m_receiving = FALSE;
        CC2420TransmitP__CaptureSFD__captureFallingEdge();
        CC2420TransmitP__PacketTimeStamp__set(CC2420TransmitP__m_msg, time32);
        if (CC2420TransmitP__PacketTimeSyncOffset__isSet(CC2420TransmitP__m_msg)) {
            uint8_t absOffset = sizeof(message_header_t ) - sizeof(cc2420_header_t ) + CC2420TransmitP__PacketTimeSyncOffset__get(CC2420TransmitP__m_msg);
            timesync_radio_t *timesync = (timesync_radio_t *)((nx_uint8_t *)CC2420TransmitP__m_msg + absOffset);

            (__nesc_temp46 = (*timesync).data, __nesc_hton_uint32(__nesc_temp46, __nesc_ntoh_uint32(__nesc_temp46) - time32));
            CC2420TransmitP__CSN__clr();
            CC2420TransmitP__TXFIFO_RAM__write(absOffset, (uint8_t *)timesync, sizeof(timesync_radio_t ));
            CC2420TransmitP__CSN__set();

            (__nesc_temp47 = (*timesync).data, __nesc_hton_uint32(__nesc_temp47, __nesc_ntoh_uint32(__nesc_temp47) + time32));
          }

        if (__nesc_ntoh_leuint16(CC2420TransmitP__CC2420PacketBody__getHeader(CC2420TransmitP__m_msg)->fcf.data) & (1 << IEEE154_FCF_ACK_REQ)) {

            CC2420TransmitP__abortSpiRelease = TRUE;
          }
        CC2420TransmitP__releaseSpiResource();
        CC2420TransmitP__BackoffTimer__stop();

        if (CC2420TransmitP__SFD__get()) {
            break;
          }


        case CC2420TransmitP__S_EFD: 
          CC2420TransmitP__sfdHigh = FALSE;
        CC2420TransmitP__CaptureSFD__captureRisingEdge();

        if (__nesc_ntoh_leuint16(CC2420TransmitP__CC2420PacketBody__getHeader(CC2420TransmitP__m_msg)->fcf.data) & (1 << IEEE154_FCF_ACK_REQ)) {
            CC2420TransmitP__m_state = CC2420TransmitP__S_ACK_WAIT;
            CC2420TransmitP__BackoffTimer__start(CC2420_ACK_WAIT_DELAY);
          }
        else 
#line 326
          {
            CC2420TransmitP__signalDone(SUCCESS);
          }

        if (!CC2420TransmitP__SFD__get()) {
            break;
          }


        default: 

          if (!CC2420TransmitP__m_receiving && CC2420TransmitP__sfdHigh == FALSE) {
              CC2420TransmitP__sfdHigh = TRUE;
              CC2420TransmitP__CaptureSFD__captureFallingEdge();

              sfd_state = CC2420TransmitP__SFD__get();
              CC2420TransmitP__CC2420Receive__sfd(time32);
              CC2420TransmitP__m_receiving = TRUE;
              CC2420TransmitP__m_prev_time = time;
              if (CC2420TransmitP__SFD__get()) {

                  return;
                }
            }



        if (CC2420TransmitP__sfdHigh == TRUE) {
            CC2420TransmitP__sfdHigh = FALSE;
            CC2420TransmitP__CaptureSFD__captureRisingEdge();
            CC2420TransmitP__m_receiving = FALSE;








            if (sfd_state == 0 && time - CC2420TransmitP__m_prev_time < 10) {
                CC2420TransmitP__CC2420Receive__sfd_dropped();
                if (CC2420TransmitP__m_msg) {
                  CC2420TransmitP__PacketTimeStamp__clear(CC2420TransmitP__m_msg);
                  }
              }
#line 370
            break;
          }
      }
  }
}

# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captured(uint16_t time){
#line 50
  CC2420TransmitP__CaptureSFD__captured(time);
#line 50
}
#line 50
# 164 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__clearOverflow(void )
{
  * (volatile uint16_t * )388U &= ~0x0002;
}

# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__clearOverflow(void ){
#line 57
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__clearOverflow();
#line 57
}
#line 57
# 84 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__clearPendingInterrupt(void )
{
  * (volatile uint16_t * )388U &= ~0x0001;
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__clearPendingInterrupt(void ){
#line 33
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__clearPendingInterrupt();
#line 33
}
#line 33
# 65 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__captured(uint16_t time)
#line 65
{
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__clearPendingInterrupt();
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__clearOverflow();
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__captured(time);
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__captured(uint16_t time){
#line 75
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4____nesc_unnamed4417 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__int2CC(* (volatile uint16_t * )388U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__captured(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Compare__fired();
    }
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__size_type /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__get(void ){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53







inline static bool /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__isOverflowPending(void ){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC__0__Counter__isOverflowPending();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectModuleFunc(void )
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t * )31U |= 0x01 << 1;
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectModuleFunc(void ){
#line 78
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectModuleFunc();
#line 78
}
#line 78
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__CC2int(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4____nesc_unnamed4418 {
#line 46
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

#line 61
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__captureControl(uint8_t l_cm)
{
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__cc_t x = { 
  .cm = l_cm & 0x03, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 1, 
  .scs = 0, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__CC2int(x);
}

#line 99
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__setControlAsCapture(uint8_t cm)
{
  * (volatile uint16_t * )388U = /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__captureControl(cm);
}

# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__setControlAsCapture(uint8_t cm){
#line 44
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__setControlAsCapture(cm);
#line 44
}
#line 44
# 119 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__enableEvents(void )
{
  * (volatile uint16_t * )388U |= 0x0010;
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__enableEvents(void ){
#line 46
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__enableEvents();
#line 46
}
#line 46
# 382 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline void HplMsp430Usart0P__Usart__tx(uint8_t data)
#line 382
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 383
    HplMsp430Usart0P__U0TXBUF = data;
#line 383
    __nesc_atomic_end(__nesc_atomic); }
}

# 224 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__tx(uint8_t data){
#line 224
  HplMsp430Usart0P__Usart__tx(data);
#line 224
}
#line 224
# 330 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline bool HplMsp430Usart0P__Usart__isRxIntrPending(void )
#line 330
{
  if (HplMsp430Usart0P__IFG1 & (1 << 6)) {
      return TRUE;
    }
  return FALSE;
}

# 192 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__isRxIntrPending(void ){
#line 192
  unsigned char result;
#line 192

#line 192
  result = HplMsp430Usart0P__Usart__isRxIntrPending();
#line 192

#line 192
  return result;
#line 192
}
#line 192
# 341 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline void HplMsp430Usart0P__Usart__clrRxIntr(void )
#line 341
{
  HplMsp430Usart0P__IFG1 &= ~(1 << 6);
}

# 197 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__clrRxIntr(void ){
#line 197
  HplMsp430Usart0P__Usart__clrRxIntr();
#line 197
}
#line 197
# 386 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline uint8_t HplMsp430Usart0P__Usart__rx(void )
#line 386
{
  uint8_t value;

#line 388
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 388
    value = U0RXBUF;
#line 388
    __nesc_atomic_end(__nesc_atomic); }
  return value;
}

# 231 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__rx(void ){
#line 231
  unsigned char result;
#line 231

#line 231
  result = HplMsp430Usart0P__Usart__rx();
#line 231

#line 231
  return result;
#line 231
}
#line 231
# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline void StateImplP__State__toIdle(uint8_t id)
#line 118
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 119
    StateImplP__state[id] = StateImplP__S_IDLE;
#line 119
    __nesc_atomic_end(__nesc_atomic); }
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static void CC2420SpiP__WorkingState__toIdle(void ){
#line 56
  StateImplP__State__toIdle(0U);
#line 56
}
#line 56
# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__ChipSpiResource__abortRelease(void )
#line 95
{
  /* atomic removed: atomic calls only */
#line 96
  CC2420SpiP__release = FALSE;
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static void CC2420TransmitP__ChipSpiResource__abortRelease(void ){
#line 31
  CC2420SpiP__ChipSpiResource__abortRelease();
#line 31
}
#line 31
# 377 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__ChipSpiResource__releasing(void )
#line 377
{
  if (CC2420TransmitP__abortSpiRelease) {
      CC2420TransmitP__ChipSpiResource__abortRelease();
    }
}

# 24 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static void CC2420SpiP__ChipSpiResource__releasing(void ){
#line 24
  CC2420TransmitP__ChipSpiResource__releasing();
#line 24
}
#line 24
# 205 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__granted(void )
#line 205
{
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__granted(void ){
#line 46
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__granted();
#line 46
}
#line 46
# 151 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline void HplMsp430Usart0P__Usart__resetUsart(bool reset)
#line 151
{
  if (reset) {
      U0CTL = 0x01;
    }
  else {
      U0CTL &= ~0x01;
    }
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__resetUsart(bool reset){
#line 97
  HplMsp430Usart0P__Usart__resetUsart(reset);
#line 97
}
#line 97
#line 158
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__disableSpi(void ){
#line 158
  HplMsp430Usart0P__Usart__disableSpi();
#line 158
}
#line 158
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__unconfigure(uint8_t id)
#line 92
{
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__resetUsart(TRUE);
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__disableSpi();
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__resetUsart(FALSE);
}

# 215 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__unconfigure(uint8_t id)
#line 215
{
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__unconfigure(uint8_t arg_0x1e6ea58){
#line 55
  switch (arg_0x1e6ea58) {
#line 55
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID:
#line 55
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__unconfigure(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 55
      break;
#line 55
    default:
#line 55
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__unconfigure(arg_0x1e6ea58);
#line 55
      break;
#line 55
    }
#line 55
}
#line 55
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__dequeue(void )
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY) {
        uint8_t id = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead;

#line 62
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead];
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;
          }
#line 65
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ[id] = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;
        {
          unsigned char __nesc_temp = 
#line 66
          id;

#line 66
          return __nesc_temp;
        }
      }
#line 68
    {
      unsigned char __nesc_temp = 
#line 68
      /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;

#line 68
      return __nesc_temp;
    }
  }
}

# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__dequeue(void ){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEmpty(void )
#line 50
{
  /* atomic removed: atomic calls only */
#line 51
  {
    unsigned char __nesc_temp = 
#line 51
    /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY;

#line 51
    return __nesc_temp;
  }
}

# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__isEmpty(void ){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 108 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__release(uint8_t id)
#line 108
{
  /* atomic removed: atomic calls only */
#line 109
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_BUSY && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId == id) {
        if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__isEmpty() == FALSE) {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__dequeue();
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__NO_RES;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_GRANTING;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__postTask();
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__unconfigure(id);
          }
        else {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__default_owner_id;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__unconfigure(id);
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__granted();
          }
        {
          unsigned char __nesc_temp = 
#line 124
          SUCCESS;

#line 124
          return __nesc_temp;
        }
      }
  }
#line 127
  return FAIL;
}

# 109 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__release(uint8_t id)
#line 109
{
#line 109
  return FAIL;
}

# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__release(uint8_t arg_0x1c3cef0){
#line 110
  unsigned char result;
#line 110

#line 110
  switch (arg_0x1c3cef0) {
#line 110
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 110
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__release(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID);
#line 110
      break;
#line 110
    default:
#line 110
      result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__release(arg_0x1c3cef0);
#line 110
      break;
#line 110
    }
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 84 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__release(uint8_t id)
#line 84
{
  return /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__release(id);
}

# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420SpiP__SpiResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__release(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )27U &= ~(0x01 << 1);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__SIMO__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectIOFunc();
#line 85
}
#line 85
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )27U &= ~(0x01 << 2);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__SOMI__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectIOFunc();
#line 85
}
#line 85
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )27U &= ~(0x01 << 3);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__UCLK__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectIOFunc();
#line 85
}
#line 85
# 119 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__enableEvents(void )
{
  * (volatile uint16_t * )390U |= 0x0010;
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__enableEvents(void ){
#line 46
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__enableEvents();
#line 46
}
#line 46
# 84 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__clearPendingInterrupt(void )
{
  * (volatile uint16_t * )390U &= ~0x0001;
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__clearPendingInterrupt(void ){
#line 33
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__clearPendingInterrupt();
#line 33
}
#line 33
# 144 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEvent(uint16_t x)
{
  * (volatile uint16_t * )406U = x;
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEvent(uint16_t time){
#line 30
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEvent(time);
#line 30
}
#line 30
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 154 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEventFromNow(uint16_t x)
{
  * (volatile uint16_t * )406U = /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Timer__get() + x;
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEventFromNow(uint16_t delta){
#line 32
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__setEventFromNow(delta);
#line 32
}
#line 32
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 70 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__startAt(uint16_t t0, uint16_t dt)
{
  /* atomic removed: atomic calls only */
  {
    uint16_t now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Timer__get();
    uint16_t elapsed = now - t0;

#line 76
    if (elapsed >= dt) 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEventFromNow(2);
      }
    else 
      {
        uint16_t remaining = dt - elapsed;

#line 83
        if (remaining <= 2) {
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEventFromNow(2);
          }
        else {
#line 86
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__setEvent(now + remaining);
          }
      }
#line 88
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__clearPendingInterrupt();
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__enableEvents();
  }
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__size_type dt){
#line 92
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__startAt(t0, dt);
#line 92
}
#line 92
# 102 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline error_t CC2420SpiP__ChipSpiResource__attemptRelease(void )
#line 102
{
  return CC2420SpiP__attemptRelease();
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static error_t CC2420TransmitP__ChipSpiResource__attemptRelease(void ){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420SpiP__ChipSpiResource__attemptRelease();
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ControlP__SpiResource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP__Resource__request(/*CC2420ControlC.Spi*/CC2420SpiC__0__CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 178 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__Resource__request(void )
#line 178
{
  return CC2420ControlP__SpiResource__request();
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420CsmaP__Resource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420ControlP__Resource__request();
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 210 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__CC2420Power__startVRegDone(void )
#line 210
{
  CC2420CsmaP__Resource__request();
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static void CC2420ControlP__CC2420Power__startVRegDone(void ){
#line 56
  CC2420CsmaP__CC2420Power__startVRegDone();
#line 56
}
#line 56
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__set(void )
#line 37
{
#line 37
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__RSTN__set(void ){
#line 29
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__set();
#line 29
}
#line 29
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__clr(void ){
#line 39
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__clr();
#line 39
}
#line 39
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__clr(void )
#line 38
{
#line 38
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__clr();
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__RSTN__clr(void ){
#line 30
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__clr();
#line 30
}
#line 30
# 419 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__StartupTimer__fired(void )
#line 419
{
  if (CC2420ControlP__m_state == CC2420ControlP__S_VREG_STARTING) {
      CC2420ControlP__m_state = CC2420ControlP__S_VREG_STARTED;
      CC2420ControlP__RSTN__clr();
      CC2420ControlP__RSTN__set();
      CC2420ControlP__CC2420Power__startVRegDone();
    }
}

# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420TransmitP__SFLUSHTX__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SFLUSHTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__getRaw(void )
#line 48
{
#line 48
  return * (volatile uint8_t * )32U & (0x01 << 4);
}

#line 49
static inline bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__get(void )
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__getRaw() != 0;
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static bool /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__get(void ){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__get(void )
#line 40
{
#line 40
  return /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__get();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static bool CC2420TransmitP__CCA__get(void ){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 498 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__BackoffTimer__fired(void )
#line 498
{
  /* atomic removed: atomic calls only */
#line 499
  {
    switch (CC2420TransmitP__m_state) {

        case CC2420TransmitP__S_SAMPLE_CCA: 


          if (CC2420TransmitP__CCA__get()) {
              CC2420TransmitP__m_state = CC2420TransmitP__S_BEGIN_TRANSMIT;
              CC2420TransmitP__BackoffTimer__start(CC2420_TIME_ACK_TURNAROUND);
            }
          else {
              CC2420TransmitP__congestionBackoff();
            }
        break;

        case CC2420TransmitP__S_BEGIN_TRANSMIT: 
          case CC2420TransmitP__S_CANCEL: 
            if (CC2420TransmitP__acquireSpiResource() == SUCCESS) {
                CC2420TransmitP__attemptSend();
              }
        break;

        case CC2420TransmitP__S_ACK_WAIT: 
          CC2420TransmitP__signalDone(SUCCESS);
        break;

        case CC2420TransmitP__S_SFD: 


          CC2420TransmitP__SFLUSHTX__strobe();
        CC2420TransmitP__CaptureSFD__captureRisingEdge();
        CC2420TransmitP__releaseSpiResource();
        CC2420TransmitP__signalDone(ERETRY);
        break;

        default: 
          break;
      }
  }
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__fired(void ){
#line 67
  CC2420TransmitP__BackoffTimer__fired();
#line 67
  CC2420ControlP__StartupTimer__fired();
#line 67
}
#line 67
# 151 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__fired(void )
{
  /* atomic removed: atomic calls only */
  {
    if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt == 0) 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__fired();
      }
    else 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__set_alarm();
      }
  }
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__fired(void ){
#line 67
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__fired();
#line 67
}
#line 67
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__fired(void )
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__disableEvents();
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Alarm__fired();
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__fired(void ){
#line 34
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430Compare__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__getEvent(void )
{
  return * (volatile uint16_t * )406U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5____nesc_unnamed4419 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__int2CC(* (volatile uint16_t * )390U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__captured(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Compare__fired();
    }
}

# 291 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__RadioBackoff__default__requestCongestionBackoff(message_t *msg)
#line 291
{
}

# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420CsmaP__RadioBackoff__requestCongestionBackoff(message_t * msg){
#line 88
  CC2420CsmaP__RadioBackoff__default__requestCongestionBackoff(msg);
#line 88
}
#line 88
# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static inline uint16_t RandomMlcgC__Random__rand16(void )
#line 78
{
  return (uint16_t )RandomMlcgC__Random__rand32();
}

# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static uint16_t CC2420CsmaP__Random__rand16(void ){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC__Random__rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 251 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__RadioBackoff__setCongestionBackoff(uint16_t backoffTime)
#line 251
{
  CC2420TransmitP__myCongestionBackoff = backoffTime + 1;
}

# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420CsmaP__SubBackoff__setCongestionBackoff(uint16_t backoffTime){
#line 66
  CC2420TransmitP__RadioBackoff__setCongestionBackoff(backoffTime);
#line 66
}
#line 66
# 230 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__SubBackoff__requestCongestionBackoff(message_t *msg)
#line 230
{
  CC2420CsmaP__SubBackoff__setCongestionBackoff(CC2420CsmaP__Random__rand16()
   % (0x7 * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP__RadioBackoff__requestCongestionBackoff(msg);
}

# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420TransmitP__RadioBackoff__requestCongestionBackoff(message_t * msg){
#line 88
  CC2420CsmaP__SubBackoff__requestCongestionBackoff(msg);
#line 88
}
#line 88
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420TransmitP__SpiResource__immediateRequest(void ){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiP__Resource__immediateRequest(/*CC2420TransmitC.Spi*/CC2420SpiC__3__CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static error_t CC2420SpiP__WorkingState__requestState(uint8_t reqState){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP__State__requestState(0U, reqState);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 106 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__isOwner(uint8_t id)
#line 106
{
#line 106
  return FAIL;
}

# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static bool /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__isOwner(uint8_t arg_0x1c3cef0){
#line 118
  unsigned char result;
#line 118

#line 118
  switch (arg_0x1c3cef0) {
#line 118
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 118
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__isOwner(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID);
#line 118
      break;
#line 118
    default:
#line 118
      result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__isOwner(arg_0x1c3cef0);
#line 118
      break;
#line 118
    }
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 102 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__isOwner(uint8_t id)
#line 102
{
  return /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__isOwner(id);
}

# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static bool CC2420SpiP__SpiResource__isOwner(void ){
#line 118
  unsigned char result;
#line 118

#line 118
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__isOwner(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline msp430_spi_union_config_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__default__getConfig(uint8_t id)
#line 110
{
  return &msp430_spi_default_config;
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
inline static msp430_spi_union_config_t */*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__getConfig(uint8_t arg_0x1c3b970){
#line 39
  union __nesc_unnamed4310 *result;
#line 39

#line 39
    result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__default__getConfig(arg_0x1c3b970);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 168 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__setModeSpi(msp430_spi_union_config_t *config){
#line 168
  HplMsp430Usart0P__Usart__setModeSpi(config);
#line 168
}
#line 168
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__configure(uint8_t id)
#line 88
{
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__setModeSpi(/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Msp430SpiConfigure__getConfig(id));
}

# 213 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__configure(uint8_t id)
#line 213
{
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__configure(uint8_t arg_0x1e6ea58){
#line 49
  switch (arg_0x1e6ea58) {
#line 49
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID:
#line 49
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__ResourceConfigure__configure(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__default__configure(arg_0x1e6ea58);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 210 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__immediateRequested(void )
#line 210
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__release();
}

# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__immediateRequested(void ){
#line 81
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__immediateRequested();
#line 81
}
#line 81
# 203 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__immediateRequested(uint8_t id)
#line 203
{
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__immediateRequested(uint8_t arg_0x1e70690){
#line 51
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__immediateRequested(arg_0x1e70690);
#line 51
}
#line 51
# 90 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__immediateRequest(uint8_t id)
#line 90
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__immediateRequested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId);
  /* atomic removed: atomic calls only */
#line 92
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_IMM_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId = id;
      }
    else {
        unsigned char __nesc_temp = 
#line 97
        FAIL;

#line 97
        return __nesc_temp;
      }
  }
#line 99
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__immediateRequested();
  if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId == id) {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId);
      return SUCCESS;
    }
  /* atomic removed: atomic calls only */
#line 104
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED;
  return FAIL;
}

# 108 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__immediateRequest(uint8_t id)
#line 108
{
#line 108
  return FAIL;
}

# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__immediateRequest(uint8_t arg_0x1c3cef0){
#line 87
  unsigned char result;
#line 87

#line 87
  switch (arg_0x1c3cef0) {
#line 87
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 87
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__immediateRequest(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID);
#line 87
      break;
#line 87
    default:
#line 87
      result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__immediateRequest(arg_0x1c3cef0);
#line 87
      break;
#line 87
    }
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 76 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__immediateRequest(uint8_t id)
#line 76
{
  return /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__immediateRequest(id);
}

# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420SpiP__SpiResource__immediateRequest(void ){
#line 87
  unsigned char result;
#line 87

#line 87
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__immediateRequest(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static void HplMsp430I2C0P__HplUsart__resetUsart(bool reset){
#line 97
  HplMsp430Usart0P__Usart__resetUsart(reset);
#line 97
}
#line 97
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
static inline void HplMsp430I2C0P__HplI2C__clearModeI2C(void )
#line 59
{
  /* atomic removed: atomic calls only */
#line 60
  {
    HplMsp430I2C0P__U0CTL &= ~((0x20 | 0x04) | 0x01);
    HplMsp430I2C0P__HplUsart__resetUsart(TRUE);
  }
}

# 7 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
inline static void HplMsp430Usart0P__HplI2C__clearModeI2C(void ){
#line 7
  HplMsp430I2C0P__HplI2C__clearModeI2C();
#line 7
}
#line 7
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP__21__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )27U &= ~(0x01 << 5);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__URXD__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP__21__IO__selectIOFunc();
#line 85
}
#line 85
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP__20__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )27U &= ~(0x01 << 4);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__UTXD__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP__20__IO__selectIOFunc();
#line 85
}
#line 85
# 207 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline void HplMsp430Usart0P__Usart__disableUart(void )
#line 207
{
  /* atomic removed: atomic calls only */
#line 208
  {
    HplMsp430Usart0P__ME1 &= ~((1 << 7) | (1 << 6));
    HplMsp430Usart0P__UTXD__selectIOFunc();
    HplMsp430Usart0P__URXD__selectIOFunc();
  }
}

#line 143
static inline void HplMsp430Usart0P__Usart__setUmctl(uint8_t control)
#line 143
{
  U0MCTL = control;
}

#line 132
static inline void HplMsp430Usart0P__Usart__setUbr(uint16_t control)
#line 132
{
  /* atomic removed: atomic calls only */
#line 133
  {
    U0BR0 = control & 0x00FF;
    U0BR1 = (control >> 8) & 0x00FF;
  }
}

#line 256
static inline void HplMsp430Usart0P__configSpi(msp430_spi_union_config_t *config)
#line 256
{

  U0CTL = (config->spiRegisters.uctl | 0x04) | 0x01;
  HplMsp430Usart0P__U0TCTL = config->spiRegisters.utctl;

  HplMsp430Usart0P__Usart__setUbr(config->spiRegisters.ubr);
  HplMsp430Usart0P__Usart__setUmctl(0x00);
}

# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectModuleFunc(void )
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t * )27U |= 0x01 << 3;
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__UCLK__selectModuleFunc(void ){
#line 78
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP__19__IO__selectModuleFunc();
#line 78
}
#line 78
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectModuleFunc(void )
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t * )27U |= 0x01 << 2;
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__SOMI__selectModuleFunc(void ){
#line 78
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP__18__IO__selectModuleFunc();
#line 78
}
#line 78
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectModuleFunc(void )
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t * )27U |= 0x01 << 1;
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void HplMsp430Usart0P__SIMO__selectModuleFunc(void ){
#line 78
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP__17__IO__selectModuleFunc();
#line 78
}
#line 78
# 238 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline void HplMsp430Usart0P__Usart__enableSpi(void )
#line 238
{
  /* atomic removed: atomic calls only */
#line 239
  {
    HplMsp430Usart0P__SIMO__selectModuleFunc();
    HplMsp430Usart0P__SOMI__selectModuleFunc();
    HplMsp430Usart0P__UCLK__selectModuleFunc();
  }
  HplMsp430Usart0P__ME1 |= 1 << 6;
}

#line 345
static inline void HplMsp430Usart0P__Usart__clrIntr(void )
#line 345
{
  HplMsp430Usart0P__IFG1 &= ~((1 << 7) | (1 << 6));
}









static inline void HplMsp430Usart0P__Usart__disableIntr(void )
#line 357
{
  HplMsp430Usart0P__IE1 &= ~((1 << 7) | (1 << 6));
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420TransmitP__SpiResource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP__Resource__request(/*CC2420TransmitC.Spi*/CC2420SpiC__3__CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 207 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__requested(void )
#line 207
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__release();
}

# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__requested(void ){
#line 73
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__default__requested();
#line 73
}
#line 73
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEnqueued(resource_client_id_t id)
#line 54
{
  /* atomic removed: atomic calls only */
#line 55
  {
    unsigned char __nesc_temp = 
#line 55
    /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ[id] != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY || /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qTail == id;

#line 55
    return __nesc_temp;
  }
}

#line 72
static inline error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__enqueue(resource_client_id_t id)
#line 72
{
  /* atomic removed: atomic calls only */
#line 73
  {
    if (!/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__isEnqueued(id)) {
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qHead = id;
          }
        else {
#line 78
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qTail] = id;
          }
#line 79
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__qTail = id;
        {
          unsigned char __nesc_temp = 
#line 80
          SUCCESS;

#line 80
          return __nesc_temp;
        }
      }
#line 82
    {
      unsigned char __nesc_temp = 
#line 82
      EBUSY;

#line 82
      return __nesc_temp;
    }
  }
}

# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__enqueue(resource_client_id_t id){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__FcfsQueue__enqueue(id);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 201 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__requested(uint8_t id)
#line 201
{
}

# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__requested(uint8_t arg_0x1e70690){
#line 43
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__default__requested(arg_0x1e70690);
#line 43
}
#line 43
# 77 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__request(uint8_t id)
#line 77
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceRequested__requested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId);
  /* atomic removed: atomic calls only */
#line 79
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId = id;
      }
    else {
        unsigned char __nesc_temp = 
#line 84
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Queue__enqueue(id);

#line 84
        return __nesc_temp;
      }
  }
#line 86
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__requested();
  return SUCCESS;
}

# 107 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__request(uint8_t id)
#line 107
{
#line 107
  return FAIL;
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__request(uint8_t arg_0x1c3cef0){
#line 78
  unsigned char result;
#line 78

#line 78
  switch (arg_0x1c3cef0) {
#line 78
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 78
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__request(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID);
#line 78
      break;
#line 78
    default:
#line 78
      result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__default__request(arg_0x1c3cef0);
#line 78
      break;
#line 78
    }
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__request(uint8_t id)
#line 80
{
  return /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__request(id);
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420SpiP__SpiResource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__request(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420TransmitP__STXONCCA__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_STXONCCA);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static cc2420_status_t CC2420TransmitP__STXON__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_STXON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static cc2420_status_t CC2420TransmitP__SNOP__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SNOP);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 181 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__default__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__getEvent(void )
{
  return * (volatile uint16_t * )408U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6____nesc_unnamed4420 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__int2CC(* (volatile uint16_t * )392U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__captured(/*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Compare__fired();
    }
}




static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__default__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__getEvent(void )
{
  return * (volatile uint16_t * )410U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7____nesc_unnamed4421 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__int2CC(* (volatile uint16_t * )394U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__captured(/*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Compare__fired();
    }
}




static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__default__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__getEvent(void )
{
  return * (volatile uint16_t * )412U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8____nesc_unnamed4422 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__int2CC(* (volatile uint16_t * )396U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__captured(/*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Compare__fired();
    }
}




static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__default__fired(void )
{
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__fired(void ){
#line 34
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__default__fired();
#line 34
}
#line 34
# 139 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__getEvent(void )
{
  return * (volatile uint16_t * )414U;
}

#line 177
static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__default__captured(uint16_t n)
{
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__captured(uint16_t time){
#line 75
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__default__captured(time);
#line 75
}
#line 75
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9____nesc_unnamed4423 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Control__getControl(void )
{
  return /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__int2CC(* (volatile uint16_t * )398U);
}

#line 169
static inline void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__captured(/*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Compare__fired();
    }
}

# 120 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX1__fired(void )
{
  uint8_t n = * (volatile uint16_t * )286U;

#line 123
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__fired(n >> 1);
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static void Msp430TimerCommonP__VectorTimerB1__fired(void ){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__VectorTimerX1__fired();
#line 28
}
#line 28
# 113 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline void SchedulerBasicP__Scheduler__init(void )
{
  /* atomic removed: atomic calls only */
  {
    memset((void *)SchedulerBasicP__m_next, SchedulerBasicP__NO_TASK, sizeof SchedulerBasicP__m_next);
    SchedulerBasicP__m_head = SchedulerBasicP__NO_TASK;
    SchedulerBasicP__m_tail = SchedulerBasicP__NO_TASK;
  }
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static void RealMainP__Scheduler__init(void ){
#line 46
  SchedulerBasicP__Scheduler__init();
#line 46
}
#line 46
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__set(void )
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t * )29U |= 0x01 << 7;
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__set(void )
#line 37
{
#line 37
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led2__set(void ){
#line 29
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__set();
#line 29
}
#line 29
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__set(void )
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t * )29U |= 0x01 << 3;
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__set(void )
#line 37
{
#line 37
  /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led1__set(void ){
#line 29
  /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__set();
#line 29
}
#line 29
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__set(void )
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t * )29U |= 0x01 << 0;
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__set(void )
#line 37
{
#line 37
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led0__set(void ){
#line 29
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__set();
#line 29
}
#line 29
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 7;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led2__makeOutput(void ){
#line 35
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__makeOutput();
#line 35
}
#line 35
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 3;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP__27__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led1__makeOutput(void ){
#line 35
  /*PlatformLedsC.Led1Impl*/Msp430GpioC__1__GeneralIO__makeOutput();
#line 35
}
#line 35
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 0;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led0__makeOutput(void ){
#line 35
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__makeOutput();
#line 35
}
#line 35
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/LedsP.nc"
static inline error_t LedsP__Init__init(void )
#line 45
{
  /* atomic removed: atomic calls only */
#line 46
  {
    ;
    LedsP__Led0__makeOutput();
    LedsP__Led1__makeOutput();
    LedsP__Led2__makeOutput();
    LedsP__Led0__set();
    LedsP__Led1__set();
    LedsP__Led2__set();
  }
  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t PlatformP__LedsInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = LedsP__Init__init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
inline static void HplDs2401C__OneWire__release(void ){
#line 41
  OneWireMasterC__OneWire__release();
#line 41
}
#line 41
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWait.nc"
inline static void OneWireMasterC__BusyWaitMicro__wait(OneWireMasterC__BusyWaitMicro__size_type dt){
#line 55
  /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__wait(dt);
#line 55
}
#line 55
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__getRaw(void )
#line 48
{
#line 48
  return * (volatile uint8_t * )40U & (0x01 << 4);
}

#line 49
static inline bool /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__get(void )
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__getRaw() != 0;
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static bool /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__get(void ){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__get(void )
#line 40
{
#line 40
  return /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__get();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static bool OneWireMasterC__Pin__get(void ){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__set(void )
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t * )41U |= 0x01 << 4;
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__set(void )
#line 37
{
#line 37
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void OneWireMasterC__Pin__set(void ){
#line 29
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__set();
#line 29
}
#line 29
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeInput(void )
#line 50
{
  /* atomic removed: atomic calls only */
#line 50
  * (volatile uint8_t * )42U &= ~(0x01 << 4);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeInput(void ){
#line 64
  /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeInput();
#line 64
}
#line 64
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeInput(void )
#line 41
{
#line 41
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeInput();
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void OneWireMasterC__Pin__makeInput(void ){
#line 33
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeInput();
#line 33
}
#line 33
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline void OneWireMasterC__OneWire__idle(void )
#line 37
{
  OneWireMasterC__Pin__makeInput();
  OneWireMasterC__Pin__set();
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__clr(void )
#line 46
{
  /* atomic removed: atomic calls only */
#line 46
  * (volatile uint8_t * )41U &= ~(0x01 << 4);
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__clr(void ){
#line 39
  /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__clr();
#line 39
}
#line 39
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__clr(void )
#line 38
{
#line 38
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__clr();
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void OneWireMasterC__Pin__clr(void ){
#line 30
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__clr();
#line 30
}
#line 30
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )42U |= 0x01 << 4;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P24*/HplMsp430GeneralIOP__12__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void OneWireMasterC__Pin__makeOutput(void ){
#line 35
  /*LocalIeeeEui64C.Msp430GpioC*/Msp430GpioC__10__GeneralIO__makeOutput();
#line 35
}
#line 35
# 105 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline bool OneWireMasterC__OneWire__readBit(void )
#line 105
{
  bool b;

#line 107
  OneWireMasterC__Pin__makeOutput();
  OneWireMasterC__Pin__clr();
  OneWireMasterC__BusyWaitMicro__wait(1);
  OneWireMasterC__OneWire__idle();
  OneWireMasterC__BusyWaitMicro__wait(8);
  b = OneWireMasterC__Pin__get();
  OneWireMasterC__BusyWaitMicro__wait(71);
  return b;
}

static inline uint8_t OneWireMasterC__OneWire__readByte(void )
#line 117
{
  uint8_t i;
#line 118
  uint8_t b = 0;


  for (i = 0; i < 8; i++) {
      b >>= 1;
      b |= OneWireMasterC__OneWire__readBit() << 7;
    }
  return b;
}

# 68 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
inline static uint8_t HplDs2401C__OneWire__readByte(void ){
#line 68
  unsigned char result;
#line 68

#line 68
  result = OneWireMasterC__OneWire__readByte();
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline void OneWireMasterC__OneWire__writeZero(void )
#line 83
{
  OneWireMasterC__Pin__makeOutput();
  OneWireMasterC__Pin__clr();
  OneWireMasterC__BusyWaitMicro__wait(72);
  OneWireMasterC__OneWire__idle();
  OneWireMasterC__BusyWaitMicro__wait(8);
}

#line 75
static inline void OneWireMasterC__OneWire__writeOne(void )
#line 75
{
  OneWireMasterC__Pin__makeOutput();
  OneWireMasterC__Pin__clr();
  OneWireMasterC__BusyWaitMicro__wait(8);
  OneWireMasterC__OneWire__idle();
  OneWireMasterC__BusyWaitMicro__wait(72);
}









static inline void OneWireMasterC__OneWire__writeByte(uint8_t b)
#line 91
{
  uint8_t i;


  for (i = 0; i < 8; i++) {
      if (b & 0x01) {
          OneWireMasterC__OneWire__writeOne();
        }
      else 
#line 98
        {
          OneWireMasterC__OneWire__writeZero();
        }
      b >>= 1;
    }
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
inline static void HplDs2401C__OneWire__writeByte(uint8_t b){
#line 59
  OneWireMasterC__OneWire__writeByte(b);
#line 59
}
#line 59
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline error_t OneWireMasterC__OneWire__reset(void )
#line 52
{
  bool clientPresent;




  OneWireMasterC__Pin__makeOutput();
  OneWireMasterC__Pin__clr();
  OneWireMasterC__BusyWaitMicro__wait(500);
  OneWireMasterC__OneWire__idle();


  OneWireMasterC__BusyWaitMicro__wait(80);
  clientPresent = OneWireMasterC__Pin__get();
  OneWireMasterC__BusyWaitMicro__wait(400);

  if (clientPresent == 0) {
      return SUCCESS;
    }
  else 
#line 70
    {
      return EOFF;
    }
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
inline static error_t HplDs2401C__OneWire__reset(void ){
#line 46
  unsigned char result;
#line 46

#line 46
  result = OneWireMasterC__OneWire__reset();
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static inline void OneWireMasterC__OneWire__init(void )
#line 42
{
  OneWireMasterC__OneWire__idle();
  OneWireMasterC__BusyWaitMicro__wait(500);
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMaster.nc"
inline static void HplDs2401C__OneWire__init(void ){
#line 37
  OneWireMasterC__OneWire__init();
#line 37
}
#line 37
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/HplDs2401C.nc"
static inline error_t HplDs2401C__Hpl__read(ds2401_serial_t *rom)
#line 37
{
  uint8_t i;

  if (HplDs2401C__busy) {
      return EBUSY;
    }

  HplDs2401C__busy = TRUE;

  HplDs2401C__OneWire__init();

  if (HplDs2401C__OneWire__reset() != SUCCESS) {
      HplDs2401C__OneWire__release();
      HplDs2401C__busy = FALSE;
      return EOFF;
    }

  HplDs2401C__OneWire__writeByte(0x33);

  for (i = 0; i < DS2401_DATA_LENGTH; i++) {
      rom->data[i] = HplDs2401C__OneWire__readByte();
    }



  HplDs2401C__OneWire__release();
  HplDs2401C__busy = FALSE;
  return SUCCESS;
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/HplDs2401.nc"
inline static error_t Ds2401ToIeeeEui64C__Hpl__read(ds2401_serial_t *rom){
#line 37
  unsigned char result;
#line 37

#line 37
  result = HplDs2401C__Hpl__read(rom);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/Ds2401ToIeeeEui64C.nc"
static inline ieee_eui64_t Ds2401ToIeeeEui64C__LocalIeeeEui64__getId(void )
#line 38
{
  ds2401_serial_t rom;
  ieee_eui64_t eui;

  /* atomic removed: atomic calls only */
#line 42
  {
    Ds2401ToIeeeEui64C__Hpl__read(&rom);
  }


  eui.data[0] = IEEE_EUI64_COMPANY_ID_0;
  eui.data[1] = IEEE_EUI64_COMPANY_ID_1;
  eui.data[2] = IEEE_EUI64_COMPANY_ID_2;



  eui.data[3] = IEEE_EUI64_SERIAL_ID_0;
  eui.data[4] = IEEE_EUI64_SERIAL_ID_1;


  eui.data[5] = rom.data[3];
  eui.data[6] = rom.data[2];
  eui.data[7] = rom.data[1];

  return eui;
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
inline static ieee_eui64_t CachedIeeeEui64P__SubIeeeEui64__getId(void ){
#line 37
  struct ieee_eui64 result;
#line 37

#line 37
  result = Ds2401ToIeeeEui64C__LocalIeeeEui64__getId();
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/CachedIeeeEui64P.nc"
static inline error_t CachedIeeeEui64P__Init__init(void )
#line 39
{
  /* atomic removed: atomic calls only */
#line 40
  CachedIeeeEui64P__eui = CachedIeeeEui64P__SubIeeeEui64__getId();
  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t MotePlatformC__SubInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CachedIeeeEui64P__Init__init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 7 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/MotePlatformC.nc"
static inline error_t MotePlatformC__Init__init(void )
#line 7
{
  /* atomic removed: atomic calls only */

  {
    P1SEL = 0;
    P2SEL = 0;
    P3SEL = 0;
    P4SEL = 0;
    P5SEL = 0;
    P6SEL = 0;

    P1OUT = 0x00;
    P1DIR = 0xe0;

    P2OUT = 0x30;
    P2DIR = 0x7b;

    P3OUT = 0x00;
    P3DIR = 0xf1;

    P4OUT = 0xdd;
    P4DIR = 0xfd;

    P5OUT = 0xff;
    P5DIR = 0xff;

    P6OUT = 0x00;
    P6DIR = 0xff;

    P1IE = 0;
    P2IE = 0;
  }





  return MotePlatformC__SubInit__init();
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t PlatformP__MoteInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = MotePlatformC__Init__init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 152 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline void Msp430ClockP__startTimerB(void )
{

  Msp430ClockP__TBCTL = 0x0020 | (Msp430ClockP__TBCTL & ~(0x0020 | 0x0010));
}

#line 140
static inline void Msp430ClockP__startTimerA(void )
{

  Msp430ClockP__TA0CTL = 0x0020 | (Msp430ClockP__TA0CTL & ~(0x0020 | 0x0010));
}

#line 104
static inline void Msp430ClockP__Msp430ClockInit__defaultInitTimerB(void )
{
  TBR = 0;









  Msp430ClockP__TBCTL = 0x0100 | 0x0002;
}

#line 134
static inline void Msp430ClockP__Msp430ClockInit__default__initTimerB(void )
{
  Msp430ClockP__Msp430ClockInit__defaultInitTimerB();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static void Msp430ClockP__Msp430ClockInit__initTimerB(void ){
#line 32
  Msp430ClockP__Msp430ClockInit__default__initTimerB();
#line 32
}
#line 32
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline void Msp430ClockP__Msp430ClockInit__defaultInitTimerA(void )
{
  TA0R = 0;









  Msp430ClockP__TA0CTL = 0x0200 | 0x0002;
}

#line 129
static inline void Msp430ClockP__Msp430ClockInit__default__initTimerA(void )
{
  Msp430ClockP__Msp430ClockInit__defaultInitTimerA();
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static void Msp430ClockP__Msp430ClockInit__initTimerA(void ){
#line 31
  Msp430ClockP__Msp430ClockInit__default__initTimerA();
#line 31
}
#line 31
# 68 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline void Msp430ClockP__Msp430ClockInit__defaultInitClocks(void )
{





  BCSCTL1 = 0x80 | (BCSCTL1 & ((0x04 | 0x02) | 0x01));







  BCSCTL2 = 0x04;


  Msp430ClockP__IE1 &= ~(1 << 1);
}

#line 124
static inline void Msp430ClockP__Msp430ClockInit__default__initClocks(void )
{
  Msp430ClockP__Msp430ClockInit__defaultInitClocks();
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static void Msp430ClockP__Msp430ClockInit__initClocks(void ){
#line 30
  Msp430ClockP__Msp430ClockInit__default__initClocks();
#line 30
}
#line 30
# 170 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline uint16_t Msp430ClockP__test_calib_busywait_delta(int calib)
{
  int8_t aclk_count = 2;
  uint16_t dco_prev = 0;
  uint16_t dco_curr = 0;

  Msp430ClockP__set_dco_calib(calib);

  while (aclk_count-- > 0) 
    {
      TBCCR0 = TBR + Msp430ClockP__ACLK_CALIB_PERIOD;
      TBCCTL0 &= ~0x0001;
      while ((TBCCTL0 & 0x0001) == 0) ;
      dco_prev = dco_curr;
      dco_curr = TA0R;
    }

  return dco_curr - dco_prev;
}




static inline void Msp430ClockP__busyCalibrateDco(void )
{

  int calib;
  int step;






  for (calib = 0, step = 0x800; step != 0; step >>= 1) 
    {

      if (Msp430ClockP__test_calib_busywait_delta(calib | step) <= Msp430ClockP__TARGET_DCO_DELTA) {
        calib |= step;
        }
    }

  if ((calib & 0x0e0) == 0x0e0) {
    calib &= ~0x01f;
    }
  Msp430ClockP__set_dco_calib(calib);
}

#line 56
static inline void Msp430ClockP__Msp430ClockInit__defaultSetupDcoCalibrate(void )
{



  Msp430ClockP__TA0CTL = 0x0200 | 0x0020;
  Msp430ClockP__TBCTL = 0x0100 | 0x0020;
  BCSCTL1 = 0x80 | 0x04;
  BCSCTL2 = 0;
  TBCCTL0 = 0x4000;
}

#line 119
static inline void Msp430ClockP__Msp430ClockInit__default__setupDcoCalibrate(void )
{
  Msp430ClockP__Msp430ClockInit__defaultSetupDcoCalibrate();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static void Msp430ClockP__Msp430ClockInit__setupDcoCalibrate(void ){
#line 29
  Msp430ClockP__Msp430ClockInit__default__setupDcoCalibrate();
#line 29
}
#line 29
# 218 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline error_t Msp430ClockP__Init__init(void )
{

  Msp430ClockP__TA0CTL = 0x0004;
  Msp430ClockP__TA0IV = 0;
  Msp430ClockP__TBCTL = 0x0004;
  Msp430ClockP__TBIV = 0;
  /* atomic removed: atomic calls only */

  {
    Msp430ClockP__Msp430ClockInit__setupDcoCalibrate();
    Msp430ClockP__busyCalibrateDco();
    Msp430ClockP__Msp430ClockInit__initClocks();
    Msp430ClockP__Msp430ClockInit__initTimerA();
    Msp430ClockP__Msp430ClockInit__initTimerB();
    Msp430ClockP__startTimerA();
    Msp430ClockP__startTimerB();
  }

  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t PlatformP__MoteClockInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = Msp430ClockP__Init__init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/PlatformP.nc"
static inline error_t PlatformP__Init__init(void )
#line 46
{
  PlatformP__MoteClockInit__init();
  PlatformP__MoteInit__init();
  PlatformP__LedsInit__init();
  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t RealMainP__PlatformInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = PlatformP__Init__init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline uint16_t /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__get(void )
{




  if (0) {
      /* atomic removed: atomic calls only */
#line 58
      {
        uint16_t t0;
        uint16_t t1 = * (volatile uint16_t * )368U;

#line 61
        do {
#line 61
            t0 = t1;
#line 61
            t1 = * (volatile uint16_t * )368U;
          }
        while (
#line 61
        t0 != t1);
        {
          unsigned int __nesc_temp = 
#line 62
          t1;

#line 62
          return __nesc_temp;
        }
      }
    }
  else 
#line 65
    {
      return * (volatile uint16_t * )368U;
    }
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static uint16_t /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__get(void ){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerA*/Msp430TimerP__0__Timer__get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline uint16_t /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__get(void )
{
  return /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Msp430Timer__get();
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__size_type /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__get(void ){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*Msp430CounterMicroC.Counter*/Msp430CounterC__1__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static bool RealMainP__Scheduler__runNextTask(void ){
#line 54
  unsigned char result;
#line 54

#line 54
  result = SchedulerBasicP__Scheduler__runNextTask();
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t PacketLinkP__send__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(PacketLinkP__send);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static error_t PacketLinkP__SubSend__send(message_t * msg, uint8_t len){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420CsmaP__Send__send(msg, len);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static error_t PacketLinkP__PacketAcknowledgements__requestAck(message_t * msg){
#line 48
  unsigned char result;
#line 48

#line 48
  result = CC2420PacketP__Acks__requestAck(msg);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 264 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint16_t __nesc_ntoh_uint16(const void * source)
#line 264
{
  const uint8_t *base = source;

#line 266
  return ((uint16_t )base[0] << 8) | base[1];
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_metadata_t * PacketLinkP__CC2420PacketBody__getMetadata(message_t * msg){
#line 53
  nx_struct cc2420_metadata_t *result;
#line 53

#line 53
  result = CC2420PacketP__CC2420PacketBody__getMetadata(msg);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 104 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline uint16_t PacketLinkP__PacketLink__getRetries(message_t *msg)
#line 104
{
  return __nesc_ntoh_uint16(PacketLinkP__CC2420PacketBody__getMetadata(msg)->maxRetries.data);
}

#line 209
static inline void PacketLinkP__send__runTask(void )
#line 209
{
  if (PacketLinkP__PacketLink__getRetries(PacketLinkP__currentSendMsg) > 0) {
      PacketLinkP__PacketAcknowledgements__requestAck(PacketLinkP__currentSendMsg);
    }

  if (PacketLinkP__SubSend__send(PacketLinkP__currentSendMsg, PacketLinkP__currentSendLen) != SUCCESS) {
      PacketLinkP__send__postTask();
    }
}

# 281 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint16_t __nesc_hton_leuint16(void * target, uint16_t value)
#line 281
{
  uint8_t *base = target;

#line 283
  base[0] = value;
  base[1] = value >> 8;
  return value;
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * CC2420CsmaP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
#line 53
inline static cc2420_metadata_t * CC2420CsmaP__CC2420PacketBody__getMetadata(message_t * msg){
#line 53
  nx_struct cc2420_metadata_t *result;
#line 53

#line 53
  result = CC2420PacketP__CC2420PacketBody__getMetadata(msg);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 294 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__RadioBackoff__default__requestCca(message_t *msg)
#line 294
{
}

# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420CsmaP__RadioBackoff__requestCca(message_t * msg){
#line 95
  CC2420CsmaP__RadioBackoff__default__requestCca(msg);
#line 95
}
#line 95
# 547 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP__send(message_t * p_msg, bool cca)
#line 547
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 548
    {
      if (CC2420TransmitP__m_state == CC2420TransmitP__S_CANCEL) {
          {
            unsigned char __nesc_temp = 
#line 550
            ECANCEL;

            {
#line 550
              __nesc_atomic_end(__nesc_atomic); 
#line 550
              return __nesc_temp;
            }
          }
        }
#line 553
      if (CC2420TransmitP__m_state != CC2420TransmitP__S_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 554
            FAIL;

            {
#line 554
              __nesc_atomic_end(__nesc_atomic); 
#line 554
              return __nesc_temp;
            }
          }
        }


      CC2420TransmitP__m_state = CC2420TransmitP__S_LOAD;
      CC2420TransmitP__m_cca = cca;
      CC2420TransmitP__m_msg = p_msg;
      CC2420TransmitP__totalCcaChecks = 0;
    }
#line 564
    __nesc_atomic_end(__nesc_atomic); }

  if (CC2420TransmitP__acquireSpiResource() == SUCCESS) {
      CC2420TransmitP__loadTXFIFO();
    }

  return SUCCESS;
}

#line 192
static inline error_t CC2420TransmitP__Send__send(message_t * p_msg, bool useCca)
#line 192
{
  return CC2420TransmitP__send(p_msg, useCca);
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
inline static error_t CC2420CsmaP__CC2420Transmit__send(message_t * p_msg, bool useCca){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420TransmitP__Send__send(p_msg, useCca);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static cc2420_status_t CC2420TransmitP__TXCTRL__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_TXCTRL, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static error_t CC2420SpiP__SpiPacket__send(uint8_t * txBuf, uint8_t * rxBuf, uint16_t len){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__send(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID, txBuf, rxBuf, len);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
inline static uint8_t CC2420SpiP__SpiByte__write(uint8_t tx){
#line 34
  unsigned char result;
#line 34

#line 34
  result = /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiByte__write(tx);
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 126 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline bool StateImplP__State__isIdle(uint8_t id)
#line 126
{
  return StateImplP__State__isState(id, StateImplP__S_IDLE);
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static bool CC2420SpiP__WorkingState__isIdle(void ){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP__State__isIdle(0U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 214 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline cc2420_status_t CC2420SpiP__Fifo__write(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 215
{

  uint8_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 219
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 221
            status;

            {
#line 221
              __nesc_atomic_end(__nesc_atomic); 
#line 221
              return __nesc_temp;
            }
          }
        }
    }
#line 225
    __nesc_atomic_end(__nesc_atomic); }
#line 225
  CC2420SpiP__m_addr = addr;

  status = CC2420SpiP__SpiByte__write(CC2420SpiP__m_addr);
  CC2420SpiP__SpiPacket__send(data, (void *)0, len);

  return status;
}

# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static cc2420_status_t CC2420TransmitP__TXFIFO__write(uint8_t * data, uint8_t length){
#line 82
  unsigned char result;
#line 82

#line 82
  result = CC2420SpiP__Fifo__write(CC2420_TXFIFO, data, length);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline error_t /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setTrigger(dma_trigger_t trigger)
#line 91
{

  if (* (volatile uint16_t *)488U & 0x0010) {
    return FAIL;
    }
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMACTL0 = (/*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMACTL0 & ~240) | ((
  trigger << 4) & 240);

  return SUCCESS;
}

#line 243
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setStateRaw(uint16_t s, uint16_t t, 
void *src, void *dest, 
uint16_t size)
#line 245
{
  * (volatile uint16_t *)490U = (uint16_t )src;
  * (volatile uint16_t *)492U = (uint16_t )dest;
  * (volatile uint16_t *)494U = size;
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setTrigger((dma_trigger_t )t);
  * (volatile uint16_t *)488U = s;
}

#line 235
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setState(dma_channel_state_t s, 
dma_channel_trigger_t t, 
void *src, void *dest, 
uint16_t size)
#line 238
{
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setStateRaw(* (uint16_t *)&s, * (uint16_t *)&t, 
  src, dest, size);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size){
#line 64
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__setState(s, t, src, dest, size);
#line 64
}
#line 64
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr)
#line 89
{

  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.request = 0;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.abort = 0;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.interruptEnable = 1;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.interruptFlag = 0;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.enable = 0;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.level = level;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.srcByte = src_byte;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.dstByte = dst_byte;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.srcIncrement = src_incr;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.dstIncrement = dst_incr;
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState.transferMode = transfer_mode;

  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelTrigger.trigger = trigger;

  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__setState(/*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelState, /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__gChannelTrigger, 
  src_addr, dst_addr, size);

  return SUCCESS;
}

# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__setupTransfer(dma_transfer_mode_t transfer_mode, dma_trigger_t trigger, dma_level_t level, void *src_addr, void *dst_addr, uint16_t size, dma_byte_t src_byte, dma_byte_t dst_byte, dma_incr_t src_incr, dma_incr_t dst_incr){
#line 38
  unsigned char result;
#line 38

#line 38
  result = /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__setupTransfer(transfer_mode, trigger, level, src_addr, dst_addr, size, src_byte, dst_byte, src_incr, dst_incr);
#line 38

#line 38
  return result;
#line 38
}
#line 38
# 195 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__enableDMA(void )
#line 195
{
  * (volatile uint16_t *)488U |= 0x0010;
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__enableDMA(void ){
#line 49
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__enableDMA();
#line 49
}
#line 49
# 112 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline error_t /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__startTransfer(void )
#line 112
{
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__enableDMA();
  return SUCCESS;
}

# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__startTransfer(void ){
#line 73
  unsigned char result;
#line 73

#line 73
  result = /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__startTransfer();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline error_t /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setTrigger(dma_trigger_t trigger)
#line 91
{

  if (* (volatile uint16_t *)496U & 0x0010) {
    return FAIL;
    }
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMACTL0 = (/*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMACTL0 & ~3840) | ((
  trigger << 8) & 3840);

  return SUCCESS;
}

#line 243
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setStateRaw(uint16_t s, uint16_t t, 
void *src, void *dest, 
uint16_t size)
#line 245
{
  * (volatile uint16_t *)498U = (uint16_t )src;
  * (volatile uint16_t *)500U = (uint16_t )dest;
  * (volatile uint16_t *)502U = size;
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setTrigger((dma_trigger_t )t);
  * (volatile uint16_t *)496U = s;
}

#line 235
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setState(dma_channel_state_t s, 
dma_channel_trigger_t t, 
void *src, void *dest, 
uint16_t size)
#line 238
{
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setStateRaw(* (uint16_t *)&s, * (uint16_t *)&t, 
  src, dest, size);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__setState(dma_channel_state_t s, dma_channel_trigger_t t, void *src, void *dest, uint16_t size){
#line 64
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__setState(s, t, src, dest, size);
#line 64
}
#line 64
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__setupTransfer(dma_transfer_mode_t transfer_mode, 
dma_trigger_t trigger, 
dma_level_t level, 
void *src_addr, 
void *dst_addr, 
uint16_t size, 
dma_byte_t src_byte, 
dma_byte_t dst_byte, 
dma_incr_t src_incr, 
dma_incr_t dst_incr)
#line 89
{

  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.request = 0;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.abort = 0;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.interruptEnable = 1;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.interruptFlag = 0;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.enable = 0;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.level = level;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.srcByte = src_byte;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.dstByte = dst_byte;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.srcIncrement = src_incr;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.dstIncrement = dst_incr;
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState.transferMode = transfer_mode;

  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelTrigger.trigger = trigger;

  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__setState(/*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelState, /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__gChannelTrigger, 
  src_addr, dst_addr, size);

  return SUCCESS;
}

# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__setupTransfer(dma_transfer_mode_t transfer_mode, dma_trigger_t trigger, dma_level_t level, void *src_addr, void *dst_addr, uint16_t size, dma_byte_t src_byte, dma_byte_t dst_byte, dma_incr_t src_incr, dma_incr_t dst_incr){
#line 38
  unsigned char result;
#line 38

#line 38
  result = /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__setupTransfer(transfer_mode, trigger, level, src_addr, dst_addr, size, src_byte, dst_byte, src_incr, dst_incr);
#line 38

#line 38
  return result;
#line 38
}
#line 38
# 195 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__enableDMA(void )
#line 195
{
  * (volatile uint16_t *)496U |= 0x0010;
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__enableDMA(void ){
#line 49
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__enableDMA();
#line 49
}
#line 49
# 112 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline error_t /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__startTransfer(void )
#line 112
{
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__enableDMA();
  return SUCCESS;
}

# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__startTransfer(void ){
#line 73
  unsigned char result;
#line 73

#line 73
  result = /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__startTransfer();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
inline static error_t CC2420TinyosNetworkP__grantTask__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420TinyosNetworkP__grantTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 233 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline error_t CC2420TinyosNetworkP__Resource__release(uint8_t id)
#line 233
{
  if (CC2420TinyosNetworkP__TINYOS_N_NETWORKS > 1) {
      CC2420TinyosNetworkP__grantTask__postTask();
    }
  CC2420TinyosNetworkP__resource_owner = CC2420TinyosNetworkP__OWNER_NONE;
  return SUCCESS;
}

#line 257
static inline void CC2420TinyosNetworkP__Resource__default__granted(uint8_t client)
#line 257
{
  CC2420TinyosNetworkP__Resource__release(client);
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static void CC2420TinyosNetworkP__Resource__granted(uint8_t arg_0x222b8a0){
#line 92
    CC2420TinyosNetworkP__Resource__default__granted(arg_0x222b8a0);
#line 92
}
#line 92
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline resource_client_id_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__dequeue(void )
#line 58
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 59
    {
      if (/*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead != /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY) {
          uint8_t id = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead;

#line 62
          /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__resQ[/*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead];
          if (/*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead == /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY) {
            /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qTail = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;
            }
#line 65
          /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__resQ[id] = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;
          {
            unsigned char __nesc_temp = 
#line 66
            id;

            {
#line 66
              __nesc_atomic_end(__nesc_atomic); 
#line 66
              return __nesc_temp;
            }
          }
        }
#line 68
      {
        unsigned char __nesc_temp = 
#line 68
        /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;

        {
#line 68
          __nesc_atomic_end(__nesc_atomic); 
#line 68
          return __nesc_temp;
        }
      }
    }
#line 71
    __nesc_atomic_end(__nesc_atomic); }
}

# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static resource_client_id_t CC2420TinyosNetworkP__Queue__dequeue(void ){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline bool /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__isEmpty(void )
#line 50
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 51
    {
      unsigned char __nesc_temp = 
#line 51
      /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__qHead == /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY;

      {
#line 51
        __nesc_atomic_end(__nesc_atomic); 
#line 51
        return __nesc_temp;
      }
    }
#line 53
    __nesc_atomic_end(__nesc_atomic); }
}

# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static bool CC2420TinyosNetworkP__Queue__isEmpty(void ){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__FcfsQueue__isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 184 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline void CC2420TinyosNetworkP__grantTask__runTask(void )
#line 184
{


  if (CC2420TinyosNetworkP__TINYOS_N_NETWORKS > 1) {
      if (CC2420TinyosNetworkP__resource_owner == CC2420TinyosNetworkP__OWNER_NONE && !CC2420TinyosNetworkP__Queue__isEmpty()) {
          CC2420TinyosNetworkP__resource_owner = CC2420TinyosNetworkP__Queue__dequeue();

          if (CC2420TinyosNetworkP__resource_owner != CC2420TinyosNetworkP__OWNER_NONE) {
              CC2420TinyosNetworkP__Resource__granted(CC2420TinyosNetworkP__resource_owner);
            }
        }
    }
  else 
#line 195
    {
      if (CC2420TinyosNetworkP__next_owner != CC2420TinyosNetworkP__resource_owner) {
          CC2420TinyosNetworkP__resource_owner = CC2420TinyosNetworkP__next_owner;
          CC2420TinyosNetworkP__Resource__granted(CC2420TinyosNetworkP__resource_owner);
        }
    }
}

# 240 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint8_t __nesc_hton_uint8(void * target, uint8_t value)
#line 240
{
  uint8_t *base = target;

#line 242
  base[0] = value;
  return value;
}

#line 257
static __inline  int8_t __nesc_hton_int8(void * target, int8_t value)
#line 257
{
#line 257
  __nesc_hton_uint8(target, value);
#line 257
  return value;
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * CC2420TinyosNetworkP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 142 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline void *CC2420TinyosNetworkP__BareSend__getPayload(message_t *msg, uint8_t len)
#line 142
{

  cc2420_header_t *hdr = CC2420TinyosNetworkP__CC2420PacketBody__getHeader(msg);

#line 145
  return hdr;
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__toggle(void )
#line 47
{
#line 47
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 47
    * (volatile uint8_t * )29U ^= 0x01 << 0;
#line 47
    __nesc_atomic_end(__nesc_atomic); }
}

# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__toggle(void ){
#line 44
  /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP__24__IO__toggle();
#line 44
}
#line 44
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__toggle(void )
#line 39
{
#line 39
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__HplGeneralIO__toggle();
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led0__toggle(void ){
#line 31
  /*PlatformLedsC.Led0Impl*/Msp430GpioC__0__GeneralIO__toggle();
#line 31
}
#line 31
# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/LedsP.nc"
static inline void LedsP__Leds__led0Toggle(void )
#line 73
{
  LedsP__Led0__toggle();
  ;
#line 75
  ;
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
inline static void IPDispatchP__Leds__led0Toggle(void ){
#line 56
  LedsP__Leds__led0Toggle();
#line 56
}
#line 56
# 322 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline struct lowpan_reconstruct *IPDispatchP__get_reconstruct(uint16_t key, uint16_t tag)
#line 322
{
  struct lowpan_reconstruct *ret = (void *)0;
  int i;



  for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      struct lowpan_reconstruct *recon = (struct lowpan_reconstruct *)&IPDispatchP__recon_data[i];

      if (recon->r_tag == tag && 
      recon->r_source_key == key) {

          if (recon->r_timeout > T_UNUSED) {
              recon->r_timeout = T_ACTIVE;
              ret = recon;
              goto done;
            }
          else {
#line 339
            if (recon->r_timeout < T_UNUSED) {


                ret = (void *)0;
                goto done;
              }
            }
        }
#line 346
      if (recon->r_timeout == T_UNUSED) {
        ret = recon;
        }
    }
#line 349
  done: 

    return ret;
}

static inline message_t *IPDispatchP__Ieee154Receive__receive(message_t *msg, void *msg_payload, uint8_t len)
#line 354
{
  struct packed_lowmsg lowmsg;
  struct ieee154_frame_addr frame_address;
  uint8_t *buf = msg_payload;

  {
#line 359
    sprintf(debugbuf, " -- RECEIVE -- len : %i\n", len);
#line 359
    writedebug();
  }
#line 359
  ;

  ;


  buf = unpack_ieee154_hdr(msg_payload, &frame_address);
  len -= buf - (uint8_t *)msg_payload;


  lowmsg.data = buf;
  lowmsg.len = len;
  lowmsg.headers = getHeaderBitmap(&lowmsg);
  if (lowmsg.headers == LOWMSG_NALP) {
      goto fail;
    }

  if (hasFrag1Header(&lowmsg) || hasFragNHeader(&lowmsg)) {

      int rv;
      struct lowpan_reconstruct *recon;
      uint16_t tag;
#line 379
      uint16_t source_key;

      source_key = ieee154_hashaddr(& frame_address.ieee_src);
      getFragDgramTag(&lowmsg, &tag);
      recon = IPDispatchP__get_reconstruct(source_key, tag);
      if (!recon) {
          goto fail;
        }

      if (hasFrag1Header(&lowmsg)) {
          if (recon->r_buf != (void *)0) {
#line 389
            goto fail;
            }
#line 390
          rv = lowpan_recon_start(&frame_address, recon, buf, len);
        }
      else 
#line 391
        {
          rv = lowpan_recon_add(recon, buf, len);
        }

      if (rv < 0) {
          recon->r_timeout = T_FAILED1;
          goto fail;
        }
      else 
#line 398
        {

          recon->r_timeout = T_ACTIVE;
          recon->r_source_key = source_key;
          recon->r_tag = tag;
        }

      if (recon->r_size == recon->r_bytes_rcvd) {
          IPDispatchP__deliver(recon);
        }
    }
  else {

      int rv;
      struct lowpan_reconstruct recon;

      buf = getLowpanPayload(&lowmsg);

      IPDispatchP__Leds__led0Toggle();
      if ((rv = lowpan_recon_start(&frame_address, &recon, buf, len)) < 0) {
          goto fail;
        }

      if (recon.r_size == recon.r_bytes_rcvd) {
          IPDispatchP__deliver(&recon);
        }
      else 
#line 423
        {

          ip_free(recon.r_buf);
        }
    }
  goto done;
  fail: 
    ;
  done: 
    return msg;
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static message_t * CC2420TinyosNetworkP__BareReceive__receive(message_t * msg, void * payload, uint8_t len){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = IPDispatchP__Ieee154Receive__receive(msg, payload, len);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 251 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline message_t *CC2420TinyosNetworkP__ActiveReceive__default__receive(message_t *msg, void *payload, uint8_t len)
#line 251
{
  return msg;
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static message_t * CC2420TinyosNetworkP__ActiveReceive__receive(message_t * msg, void * payload, uint8_t len){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420TinyosNetworkP__ActiveReceive__default__receive(msg, payload, len);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_metadata_t * CC2420TinyosNetworkP__CC2420PacketBody__getMetadata(message_t * msg){
#line 53
  nx_struct cc2420_metadata_t *result;
#line 53

#line 53
  result = CC2420PacketP__CC2420PacketBody__getMetadata(msg);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Packet.nc"
inline static uint8_t CC2420TinyosNetworkP__CC2420Packet__getNetwork(message_t *p_msg){
#line 75
  unsigned char result;
#line 75

#line 75
  result = CC2420PacketP__CC2420Packet__getNetwork(p_msg);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 161 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline message_t *CC2420TinyosNetworkP__SubReceive__receive(message_t *msg, void *payload, uint8_t len)
#line 161
{
  uint8_t network = CC2420TinyosNetworkP__CC2420Packet__getNetwork(msg);

  if (! __nesc_ntoh_int8(CC2420TinyosNetworkP__CC2420PacketBody__getMetadata(msg)->crc.data)) {
      return msg;
    }

  if (network == 0x3f) {
      return CC2420TinyosNetworkP__ActiveReceive__receive(msg, payload, len);
    }
  else 
#line 170
    {
      return CC2420TinyosNetworkP__BareReceive__receive(msg, 
      CC2420TinyosNetworkP__BareSend__getPayload(msg, len), 
      len + sizeof(cc2420_header_t ));
    }
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static message_t * UniqueReceiveP__Receive__receive(message_t * msg, void * payload, uint8_t len){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420TinyosNetworkP__SubReceive__receive(msg, payload, len);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 138 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline void UniqueReceiveP__insert(uint16_t msgSource, uint8_t msgDsn)
#line 138
{
  uint8_t element = UniqueReceiveP__recycleSourceElement;
  bool increment = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 142
    {
      if (element == UniqueReceiveP__INVALID_ELEMENT || UniqueReceiveP__writeIndex == element) {

          element = UniqueReceiveP__writeIndex;
          increment = TRUE;
        }

      UniqueReceiveP__receivedMessages[element].source = msgSource;
      UniqueReceiveP__receivedMessages[element].dsn = msgDsn;
      if (increment) {
          UniqueReceiveP__writeIndex++;
          UniqueReceiveP__writeIndex %= 4;
        }
    }
#line 155
    __nesc_atomic_end(__nesc_atomic); }
}

#line 192
static inline message_t *UniqueReceiveP__DuplicateReceive__default__receive(message_t *msg, void *payload, uint8_t len)
#line 192
{
  return msg;
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static message_t * UniqueReceiveP__DuplicateReceive__receive(message_t * msg, void * payload, uint8_t len){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP__DuplicateReceive__default__receive(msg, payload, len);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 112 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline bool UniqueReceiveP__hasSeen(uint16_t msgSource, uint8_t msgDsn)
#line 112
{
  int i;

#line 114
  UniqueReceiveP__recycleSourceElement = UniqueReceiveP__INVALID_ELEMENT;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 116
    {
      for (i = 0; i < 4; i++) {
          if (UniqueReceiveP__receivedMessages[i].source == msgSource) {
              if (UniqueReceiveP__receivedMessages[i].dsn == msgDsn) {

                  {
                    unsigned char __nesc_temp = 
#line 121
                    TRUE;

                    {
#line 121
                      __nesc_atomic_end(__nesc_atomic); 
#line 121
                      return __nesc_temp;
                    }
                  }
                }
#line 124
              UniqueReceiveP__recycleSourceElement = i;
            }
        }
    }
#line 127
    __nesc_atomic_end(__nesc_atomic); }

  return FALSE;
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * UniqueReceiveP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 165 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline uint16_t UniqueReceiveP__getSourceKey(message_t *msg)
#line 165
{
  cc2420_header_t *hdr = UniqueReceiveP__CC2420PacketBody__getHeader(msg);
  int s_mode = (__nesc_ntoh_leuint16(hdr->fcf.data) >> IEEE154_FCF_SRC_ADDR_MODE) & 0x3;
  int d_mode = (__nesc_ntoh_leuint16(hdr->fcf.data) >> IEEE154_FCF_DEST_ADDR_MODE) & 0x3;
  int s_offset = 2;
#line 169
  int s_len = 2;
  uint16_t key = 0;
  uint8_t *current = (uint8_t *)& hdr->dest;
  int i;

  if (s_mode == IEEE154_ADDR_EXT) {
      s_len = 8;
    }
  if (d_mode == IEEE154_ADDR_EXT) {
      s_offset = 8;
    }

  current += s_offset;

  for (i = 0; i < s_len; i++) {
      key += current[i];
    }
  return key;
}

#line 86
static inline message_t *UniqueReceiveP__SubReceive__receive(message_t *msg, void *payload, 
uint8_t len)
#line 87
{

  uint16_t msgSource = UniqueReceiveP__getSourceKey(msg);
  uint8_t msgDsn = __nesc_ntoh_leuint8(UniqueReceiveP__CC2420PacketBody__getHeader(msg)->dsn.data);

  if (UniqueReceiveP__hasSeen(msgSource, msgDsn)) {
      return UniqueReceiveP__DuplicateReceive__receive(msg, payload, len);
    }
  else 
#line 94
    {
      UniqueReceiveP__insert(msgSource, msgDsn);
      return UniqueReceiveP__Receive__receive(msg, payload, len);
    }
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static message_t * CC2420ReceiveP__Receive__receive(message_t * msg, void * payload, uint8_t len){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP__SubReceive__receive(msg, payload, len);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/CachedIeeeEui64P.nc"
static inline ieee_eui64_t CachedIeeeEui64P__LocalIeeeEui64__getId(void )
#line 44
{
  return CachedIeeeEui64P__eui;
}

# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
inline static ieee_eui64_t CC2420ControlP__LocalIeeeEui64__getId(void ){
#line 37
  struct ieee_eui64 result;
#line 37

#line 37
  result = CachedIeeeEui64P__LocalIeeeEui64__getId();
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 286 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline ieee_eui64_t CC2420ControlP__CC2420Config__getExtAddr(void )
#line 286
{
  return CC2420ControlP__LocalIeeeEui64__getId();
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static ieee_eui64_t CC2420ReceiveP__CC2420Config__getExtAddr(void ){
#line 64
  struct ieee_eui64 result;
#line 64

#line 64
  result = CC2420ControlP__CC2420Config__getExtAddr();
#line 64

#line 64
  return result;
#line 64
}
#line 64





inline static uint16_t CC2420ReceiveP__CC2420Config__getShortAddr(void ){
#line 69
  unsigned int result;
#line 69

#line 69
  result = CC2420ControlP__CC2420Config__getShortAddr();
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 343 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline bool CC2420ControlP__CC2420Config__isAddressRecognitionEnabled(void )
#line 343
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 344
    {
      unsigned char __nesc_temp = 
#line 344
      CC2420ControlP__addressRecognition;

      {
#line 344
        __nesc_atomic_end(__nesc_atomic); 
#line 344
        return __nesc_temp;
      }
    }
#line 346
    __nesc_atomic_end(__nesc_atomic); }
}

# 91 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static bool CC2420ReceiveP__CC2420Config__isAddressRecognitionEnabled(void ){
#line 91
  unsigned char result;
#line 91

#line 91
  result = CC2420ControlP__CC2420Config__isAddressRecognitionEnabled();
#line 91

#line 91
  return result;
#line 91
}
#line 91
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * CC2420ReceiveP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 819 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline bool CC2420ReceiveP__passesAddressCheck(message_t *msg)
#line 819
{
  cc2420_header_t *header = CC2420ReceiveP__CC2420PacketBody__getHeader(msg);
  int mode = (__nesc_ntoh_leuint16(header->fcf.data) >> IEEE154_FCF_DEST_ADDR_MODE) & 3;
  ieee_eui64_t *ext_addr;

  if (!CC2420ReceiveP__CC2420Config__isAddressRecognitionEnabled()) {
      return TRUE;
    }

  if (mode == IEEE154_ADDR_SHORT) {
      return __nesc_ntoh_leuint16(header->dest.data) == CC2420ReceiveP__CC2420Config__getShortAddr()
       || __nesc_ntoh_leuint16(header->dest.data) == IEEE154_BROADCAST_ADDR;
    }
  else {
#line 831
    if (mode == IEEE154_ADDR_EXT) {
        ieee_eui64_t local_addr = CC2420ReceiveP__CC2420Config__getExtAddr();

#line 833
        ext_addr = (ieee_eui64_t *)& header->dest;
        return memcmp(ext_addr->data, local_addr.data, IEEE_EUI64_LENGTH) == 0;
      }
    else 
#line 835
      {

        return FALSE;
      }
    }
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_metadata_t * CC2420ReceiveP__CC2420PacketBody__getMetadata(message_t * msg){
#line 53
  nx_struct cc2420_metadata_t *result;
#line 53

#line 53
  result = CC2420PacketP__CC2420PacketBody__getMetadata(msg);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 671 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__receiveDone_task__runTask(void )
#line 671
{
  cc2420_metadata_t *metadata = CC2420ReceiveP__CC2420PacketBody__getMetadata(CC2420ReceiveP__m_p_rx_buf);
  cc2420_header_t *header = CC2420ReceiveP__CC2420PacketBody__getHeader(CC2420ReceiveP__m_p_rx_buf);
  uint8_t length = __nesc_ntoh_leuint8(header->length.data);
  uint8_t tmpLen __attribute((unused))  = sizeof(message_t ) - ((size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
  uint8_t * buf = (uint8_t * )header;

  __nesc_hton_int8(metadata->crc.data, buf[length] >> 7);
  __nesc_hton_uint8(metadata->lqi.data, buf[length] & 0x7f);
  __nesc_hton_uint8(metadata->rssi.data, buf[length - 1]);

  if (CC2420ReceiveP__passesAddressCheck(CC2420ReceiveP__m_p_rx_buf) && length >= CC2420_SIZE) {
#line 696
      CC2420ReceiveP__m_p_rx_buf = CC2420ReceiveP__Receive__receive(CC2420ReceiveP__m_p_rx_buf, CC2420ReceiveP__m_p_rx_buf->data, 
      length - CC2420_SIZE);
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 699
    CC2420ReceiveP__receivingPacket = FALSE;
#line 699
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ReceiveP__waitForNextPacket();
}

# 82 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline int CC2420PacketP__getAddressLength(int type)
#line 82
{
  switch (type) {
      case IEEE154_ADDR_SHORT: return 2;
      case IEEE154_ADDR_EXT: return 8;
      case IEEE154_ADDR_NONE: return 0;
      default: return -100;
    }
}

static inline uint8_t *CC2420PacketP__getNetwork(message_t *msg)
#line 91
{
  cc2420_header_t *hdr = CC2420PacketP__CC2420PacketBody__getHeader(msg);
  int offset;

  offset = CC2420PacketP__getAddressLength((__nesc_ntoh_leuint16(hdr->fcf.data) >> IEEE154_FCF_DEST_ADDR_MODE) & 0x3) + 
  CC2420PacketP__getAddressLength((__nesc_ntoh_leuint16(hdr->fcf.data) >> IEEE154_FCF_SRC_ADDR_MODE) & 0x3) + 
  (size_t )& ((cc2420_header_t *)0)->dest;

  return (uint8_t *)hdr + offset;
}

# 300 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/PrintfUART.h"
static inline bool isTxIntrPending()
{
  if (U1TCTL & 0x01) {
      return TRUE;
    }
  return FALSE;
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressFilterP.nc"
static inline void IPAddressFilterP__ForwardIP__default__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta)
#line 29
{
}

# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
inline static void IPAddressFilterP__ForwardIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta){
#line 23
  IPAddressFilterP__ForwardIP__default__recv(iph, payload, meta);
#line 23
}
#line 23
# 70 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMPCoreP.nc"
static inline void ICMPCoreP__ICMP_IP__default__recv(uint8_t nxt_hdr, void *iph, void *payload, size_t len, struct ip6_metadata *meta)
#line 70
{
}

# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
inline static void ICMPCoreP__ICMP_IP__recv(uint8_t arg_0x2337ef8, void *headers, void *payload, size_t len, struct ip6_metadata *meta){
#line 23
    ICMPCoreP__ICMP_IP__default__recv(arg_0x2337ef8, headers, payload, len, meta);
#line 23
}
#line 23
#line 17
inline static error_t ICMPCoreP__IP__send(struct ip6_packet *msg){
#line 17
  unsigned char result;
#line 17

#line 17
  result = IPProtocolsP__IP__send(IANA_ICMP, msg);
#line 17

#line 17
  return result;
#line 17
}
#line 17
# 30 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/ICMPCoreP.nc"
static inline void ICMPCoreP__IP__recv(void *iph, void *payload, size_t len, struct ip6_metadata *meta)
#line 30
{
  struct ip6_hdr *hdr = iph;
  struct ip6_packet reply;
  struct ip_iovec v;
  struct icmp6_hdr *req = (struct icmp6_hdr *)payload;

  switch (req->type) {
      case ICMP_TYPE_ECHO_REQUEST: 
        req->type = ICMP_TYPE_ECHO_REPLY;
      req->cksum = 0;

      memset(&reply, 0, sizeof reply);
      ip_memcpy((uint8_t *)reply.ip6_hdr.ip6_src.in6_u.u6_addr8, (uint8_t *)hdr->ip6_dst.in6_u.u6_addr8, 16);
      ip_memcpy((uint8_t *)reply.ip6_hdr.ip6_dst.in6_u.u6_addr8, (uint8_t *)hdr->ip6_src.in6_u.u6_addr8, 16);

      reply.ip6_hdr.ip6_ctlun.ip6_un2_vfc = 0x60;
      reply.ip6_hdr.ip6_ctlun.ip6_un1.ip6_un1_nxt = IANA_ICMP;
      reply.ip6_data = &v;

      v.iov_next = (void *)0;
      v.iov_base = payload;
      v.iov_len = len;

      reply.ip6_hdr.ip6_ctlun.ip6_un1.ip6_un1_plen = (((uint16_t )iov_len(&v) >> 8) | ((uint16_t )iov_len(&v) << 8)) & 0xffff;

      req->cksum = (((uint16_t )msg_cksum(& reply.ip6_hdr, reply.ip6_data, IANA_ICMP) << 8) | ((uint16_t )msg_cksum(& reply.ip6_hdr, reply.ip6_data, IANA_ICMP) >> 8)) & 0xffff;


      ICMPCoreP__IP__send(&reply);
      break;

      default: 
        ICMPCoreP__ICMP_IP__recv(req->type, iph, payload, len, meta);
    }
}

# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static error_t UDPEchoP__Echo__sendto(struct sockaddr_in6 *dest, void *payload, uint16_t len){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP__UDP__sendto(0U, dest, payload, len);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 93 "UDPEchoP.nc"
static inline void UDPEchoP__Echo__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta)
#line 94
{
  int i;
  uint8_t *cur = data;

#line 97
  {
#line 97
    sprintf(debugbuf, "Echo recv [%i]: ", len);
#line 97
    writedebug();
  }
#line 97
  ;
  for (i = 0; i < len; i++) {
      {
#line 99
        sprintf(debugbuf, "%02x ", cur[i]);
#line 99
        writedebug();
      }
#line 99
      ;
    }
  {
#line 101
    sprintf(debugbuf, "\n");
#line 101
    writedebug();
  }
#line 101
  ;
  UDPEchoP__Echo__sendto(from, data, len);
}

#line 88
static inline void UDPEchoP__Status__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta)
#line 89
{
}

# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static error_t UDPShellP__UDP__sendto(struct sockaddr_in6 *dest, void *payload, uint16_t len){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP__UDP__sendto(2U, dest, payload, len);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 285 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline char *UDPShellP__ShellCommand__default__eval(uint8_t cmd_id, int argc, char **argv)
#line 285
{
  return (void *)0;
}

# 11 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/ShellCommand.nc"
inline static char *UDPShellP__ShellCommand__eval(uint8_t arg_0x23fb130, int argc, char **argv){
#line 11
  char *result;
#line 11

#line 11
    result = UDPShellP__ShellCommand__default__eval(arg_0x23fb130, argc, argv);
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 207 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP__init_argv(char *cmd, uint16_t len, char **argv, int *argc)
#line 207
{
  int inArg = 0;

#line 209
  *argc = 0;
  while (len > 0 && *argc < UDPShellP__N_ARGS) {
      if ((((*cmd == ' ' || *cmd == '\n') || *cmd == '\t') || *cmd == '\0') || len == 1) {
          if (inArg) {
              *argc = *argc + 1;
              inArg = 0;
              *cmd = '\0';
            }
        }
      else {
#line 217
        if (!inArg) {
            argv[*argc] = cmd;
            inArg = 1;
          }
        }
#line 221
      cmd++;
      len--;
    }
}











static inline void UDPShellP__UDP__recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip6_metadata *meta)
#line 237
{
  char *argv[UDPShellP__N_ARGS];
  int argc;
#line 239
  int cmd;

  ip_memcpy((uint8_t *)&UDPShellP__session_endpoint, (uint8_t *)from, sizeof(struct sockaddr_in6 ));
  UDPShellP__init_argv((char *)data, len, argv, &argc);

  if (argc > 0) {
      cmd = UDPShellP__lookup_cmd(argv[0], UDPShellP__N_BUILTINS, UDPShellP__builtins);
      if (cmd != UDPShellP__CMD_NO_CMD) {
          UDPShellP__builtin_actions[cmd].action(argc, argv);
          return;
        }
      cmd = UDPShellP__lookup_cmd(argv[0], UDPShellP__N_EXTERNAL, UDPShellP__externals);
      if (cmd != UDPShellP__CMD_NO_CMD) {
          char *reply = UDPShellP__ShellCommand__eval(cmd, argc, argv);

#line 253
          if (reply != (void *)0) {
            UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, reply, strlen(reply));
            }
#line 255
          return;
        }
      cmd = snprintf(UDPShellP__reply_buf, MAX_REPLY_LEN, "sdsh: %s: command not found\n", argv[0]);
      UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__reply_buf, cmd);
    }
}

# 183 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static inline void UdpP__UDP__default__recvfrom(uint8_t clnt, struct sockaddr_in6 *from, void *payload, 
uint16_t len, struct ip6_metadata *meta)
#line 184
{
}

# 24 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static void UdpP__UDP__recvfrom(uint8_t arg_0x23a6e58, struct sockaddr_in6 *src, void *payload, uint16_t len, struct ip6_metadata *meta){
#line 24
  switch (arg_0x23a6e58) {
#line 24
    case 0U:
#line 24
      UDPEchoP__Echo__recvfrom(src, payload, len, meta);
#line 24
      break;
#line 24
    case 1U:
#line 24
      UDPEchoP__Status__recvfrom(src, payload, len, meta);
#line 24
      break;
#line 24
    case 2U:
#line 24
      UDPShellP__UDP__recvfrom(src, payload, len, meta);
#line 24
      break;
#line 24
    default:
#line 24
      UdpP__UDP__default__recvfrom(arg_0x23a6e58, src, payload, len, meta);
#line 24
      break;
#line 24
    }
#line 24
}
#line 24
# 68 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static inline void UdpP__IP__recv(void *headers, 
void *payload, 
size_t len, 
struct ip6_metadata *meta)
#line 71
{
  int i;
  struct sockaddr_in6 addr;
  struct ip6_hdr *iph = (struct ip6_hdr *)headers;
  struct udp_hdr *udph = (struct udp_hdr *)payload;

  {
#line 77
    sprintf(debugbuf, "UDP - IP.recv: len: %i srcport: %i dstport: %i\n", (((uint16_t )iph->ip6_ctlun.ip6_un1.ip6_un1_plen >> 8) | ((uint16_t )iph->ip6_ctlun.ip6_un1.ip6_un1_plen << 8)) & 0xffff, (((uint16_t )udph->srcport >> 8) | ((uint16_t )udph->srcport << 8)) & 0xffff, (((uint16_t )udph->dstport >> 8) | ((uint16_t )udph->dstport << 8)) & 0xffff);
#line 77
    writedebug();
  }
#line 77
  ;


  for (i = 0; i < UdpP__N_CLIENTS; i++) 
    if (UdpP__local_ports[i] == udph->dstport) {
      break;
      }
  if (i == UdpP__N_CLIENTS) {

      return;
    }
  ip_memcpy((uint8_t *)& addr.sin6_addr, (uint8_t *)& iph->ip6_src, 16);
  addr.sin6_port = udph->srcport;



  udph->len = (((uint16_t )len << 8) | ((uint16_t )len >> 8)) & 0xffff;

  {
    uint16_t my_cksum;
#line 96
    uint16_t rx_cksum = (((uint16_t )udph->chksum >> 8) | ((uint16_t )udph->chksum << 8)) & 0xffff;
    struct ip_iovec v;

    udph->chksum = 0;
    v.iov_base = payload;
    v.iov_len = len;
    v.iov_next = (void *)0;

    my_cksum = msg_cksum(iph, &v, IANA_UDP);
    if (rx_cksum != my_cksum) {
        ;
        {
#line 107
          sprintf(debugbuf, "udp ckecksum computation failed: mine: 0x%x theirs: 0x%x\n", my_cksum, rx_cksum);
#line 107
          writedebug();
        }
#line 107
        ;
      }
  }



  ;
  UdpP__UDP__recvfrom(i, &addr, (void *)(udph + 1), len - sizeof(struct udp_hdr ), meta);
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
static inline void IPProtocolsP__IP__default__recv(uint8_t nxt_hdr, void *iph, void *payload, size_t len, struct ip6_metadata *meta)
#line 46
{
}

# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
inline static void IPProtocolsP__IP__recv(uint8_t arg_0x23274a0, void *headers, void *payload, size_t len, struct ip6_metadata *meta){
#line 23
  switch (arg_0x23274a0) {
#line 23
    case IANA_UDP:
#line 23
      UdpP__IP__recv(headers, payload, len, meta);
#line 23
      break;
#line 23
    case IANA_ICMP:
#line 23
      ICMPCoreP__IP__recv(headers, payload, len, meta);
#line 23
      break;
#line 23
    default:
#line 23
      IPProtocolsP__IP__default__recv(arg_0x23274a0, headers, payload, len, meta);
#line 23
      break;
#line 23
    }
#line 23
}
#line 23
# 12 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
static inline void IPProtocolsP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta)
#line 12
{
  struct ip6_ext *cur = (struct ip6_ext *)payload;
  uint8_t nxt = iph->ip6_ctlun.ip6_un1.ip6_un1_nxt;

  while (((((nxt == IPV6_HOP || nxt == IPV6_ROUTING) || nxt == IPV6_FRAG) || 
  nxt == IPV6_DEST) || nxt == IPV6_MOBILITY) || nxt == IPV6_IPV6) {
      nxt = cur->ip6e_nxt;
      cur = cur + cur->ip6e_len;
    }

  IPProtocolsP__IP__recv(nxt, iph, 
  cur, (((
  (uint16_t )iph->ip6_ctlun.ip6_un1.ip6_un1_plen >> 8) | ((uint16_t )iph->ip6_ctlun.ip6_un1.ip6_un1_plen << 8)) & 0xffff) - ((void *)cur - payload), 
  meta);
}

# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
inline static void IPAddressFilterP__LocalIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta){
#line 23
  IPProtocolsP__SubIP__recv(iph, payload, meta);
#line 23
}
#line 23
# 69 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static uint16_t IPAddressP__CC2420Config__getShortAddr(void ){
#line 69
  unsigned int result;
#line 69

#line 69
  result = CC2420ControlP__CC2420Config__getShortAddr();
#line 69

#line 69
  return result;
#line 69
}
#line 69






inline static uint16_t IPAddressP__CC2420Config__getPanAddr(void ){
#line 75
  unsigned int result;
#line 75

#line 75
  result = CC2420ControlP__CC2420Config__getPanAddr();
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/LocalIeeeEui64.nc"
inline static ieee_eui64_t IPAddressP__LocalIeeeEui64__getId(void ){
#line 37
  struct ieee_eui64 result;
#line 37

#line 37
  result = CachedIeeeEui64P__LocalIeeeEui64__getId();
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 105 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
static inline bool IPAddressP__IPAddress__isLocalAddress(struct in6_addr *addr)
#line 105
{
  ieee_eui64_t eui = IPAddressP__LocalIeeeEui64__getId();
  ieee154_panid_t panid = IPAddressP__CC2420Config__getPanAddr();
  ieee154_saddr_t saddr = IPAddressP__CC2420Config__getShortAddr();

  if (addr->in6_u.u6_addr16[0] == ((((uint16_t )0xfe80 << 8) | ((uint16_t )0xfe80 >> 8)) & 0xffff)) {

      if (addr->in6_u.u6_addr16[5] == ((((uint16_t )0x00FF >> 8) | ((uint16_t )0x00FF << 8)) & 0xffff) && 
      addr->in6_u.u6_addr16[6] == ((((uint16_t )0xFE00 >> 8) | ((uint16_t )0xFE00 << 8)) & 0xffff)) {
          if (((((uint16_t )addr->in6_u.u6_addr16[4] >> 8) | ((uint16_t )addr->in6_u.u6_addr16[4] << 8)) & 0xffff) == panid && (((
          (uint16_t )addr->in6_u.u6_addr16[7] >> 8) | ((uint16_t )addr->in6_u.u6_addr16[7] << 8)) & 0xffff) == saddr) {
              return TRUE;
            }
          else 
#line 117
            {
              return FALSE;
            }
        }
      else 
#line 120
        {
          if (memcmp(&addr->in6_u.u6_addr8[8], eui.data, 8) == 0) {
              return TRUE;
            }
        }
    }
  else {
#line 125
    if (addr->in6_u.u6_addr8[0] == 0xff) {

        if ((addr->in6_u.u6_addr8[1] & 0x0f) <= 2) {

            return TRUE;
          }
      }
    }
#line 132
  return FALSE;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static bool IPAddressFilterP__IPAddress__isLocalAddress(struct in6_addr *addr){
#line 51
  unsigned char result;
#line 51

#line 51
  result = IPAddressP__IPAddress__isLocalAddress(addr);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 13 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressFilterP.nc"
static inline void IPAddressFilterP__SubIP__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta)
#line 13
{
  if (IPAddressFilterP__IPAddress__isLocalAddress(& iph->ip6_dst)) {
      IPAddressFilterP__LocalIP__recv(iph, payload, meta);
    }
  else 
#line 16
    {
      IPAddressFilterP__ForwardIP__recv(iph, payload, meta);
    }
}

# 23 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
inline static void IPDispatchP__IPLower__recv(struct ip6_hdr *iph, void *payload, struct ip6_metadata *meta){
#line 23
  IPAddressFilterP__SubIP__recv(iph, payload, meta);
#line 23
}
#line 23
# 37 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
static inline bool IPAddressP__IPAddress__getLLAddr(struct in6_addr *addr)
#line 37
{


  ieee154_panid_t panid = IPAddressP__CC2420Config__getPanAddr();
  ieee154_saddr_t saddr = IPAddressP__CC2420Config__getShortAddr();

  memset(addr->in6_u.u6_addr8, 0, 16);
  addr->in6_u.u6_addr16[0] = (((uint16_t )0xfe80 << 8) | ((uint16_t )0xfe80 >> 8)) & 0xffff;
  addr->in6_u.u6_addr16[4] = (((uint16_t )panid << 8) | ((uint16_t )panid >> 8)) & 0xffff;
  addr->in6_u.u6_addr16[5] = (((uint16_t )0x00FF >> 8) | ((uint16_t )0x00FF << 8)) & 0xffff;
  addr->in6_u.u6_addr16[6] = (((uint16_t )0xFE00 >> 8) | ((uint16_t )0xFE00 << 8)) & 0xffff;
  addr->in6_u.u6_addr16[7] = (((uint16_t )saddr << 8) | ((uint16_t )saddr >> 8)) & 0xffff;

  return TRUE;
}





static inline bool IPAddressP__IPAddress__setSource(struct ip6_hdr *hdr)
#line 57
{
  enum __nesc_unnamed4424 {
#line 58
    LOCAL, GLOBAL
  } 
#line 58
  type = GLOBAL;

  if (hdr->ip6_dst.in6_u.u6_addr8[0] == 0xff) {

      if ((hdr->ip6_dst.in6_u.u6_addr8[1] & 0x0f) <= 0x2) {
          type = LOCAL;
        }
    }
  else {
#line 65
    if (hdr->ip6_dst.in6_u.u6_addr8[0] == 0xfe) {

        if ((hdr->ip6_dst.in6_u.u6_addr8[1] & 0xf0) <= 0x80) {
            type = LOCAL;
          }
      }
    }
  return IPAddressP__IPAddress__getLLAddr(& hdr->ip6_src);
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static bool UdpP__IPAddress__setSource(struct ip6_hdr *hdr){
#line 39
  unsigned char result;
#line 39

#line 39
  result = IPAddressP__IPAddress__setSource(hdr);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 32 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static inline uint16_t UdpP__alloc_lport(uint8_t clnt)
#line 32
{
  int i;
#line 33
  int done = 0;
  uint16_t compare = (((uint16_t )UdpP__last_localport << 8) | ((uint16_t )UdpP__last_localport >> 8)) & 0xffff;

#line 35
  UdpP__last_localport = UdpP__last_localport < UdpP__LOCAL_PORT_START ? UdpP__last_localport + 1 : UdpP__LOCAL_PORT_START;
  while (!done) {
      done = 1;
      for (i = 0; i < UdpP__N_CLIENTS; i++) {
          if (UdpP__local_ports[i] == compare) {
              UdpP__last_localport = UdpP__last_localport < UdpP__LOCAL_PORT_START ? UdpP__last_localport + 1 : UdpP__LOCAL_PORT_START;
              compare = (((uint16_t )UdpP__last_localport << 8) | ((uint16_t )UdpP__last_localport >> 8)) & 0xffff;
              done = 0;
              break;
            }
        }
    }
  return UdpP__last_localport;
}

# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IP.nc"
inline static error_t UdpP__IP__send(struct ip6_packet *msg){
#line 17
  unsigned char result;
#line 17

#line 17
  result = IPProtocolsP__IP__send(IANA_UDP, msg);
#line 17

#line 17
  return result;
#line 17
}
#line 17
# 46 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static error_t IPProtocolsP__IPAddress__resolveAddress(struct in6_addr *addr, ieee154_addr_t *link_addr){
#line 46
  unsigned char result;
#line 46

#line 46
  result = IPAddressP__IPAddress__resolveAddress(addr, link_addr);
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t IPDispatchP__sendTask__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(IPDispatchP__sendTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static error_t IPDispatchP__SendInfoPool__put(IPDispatchP__SendInfoPool__t * newVal){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__put(newVal);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline void /*IPDispatchC.QueueC*/QueueC__0__printQueue(void )
#line 69
{
}

#line 61
static inline uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__maxSize(void )
#line 61
{
  return 12;
}

#line 57
static inline uint8_t /*IPDispatchC.QueueC*/QueueC__0__Queue__size(void )
#line 57
{
  return /*IPDispatchC.QueueC*/QueueC__0__size;
}

#line 97
static inline error_t /*IPDispatchC.QueueC*/QueueC__0__Queue__enqueue(/*IPDispatchC.QueueC*/QueueC__0__queue_t newVal)
#line 97
{
  if (/*IPDispatchC.QueueC*/QueueC__0__Queue__size() < /*IPDispatchC.QueueC*/QueueC__0__Queue__maxSize()) {
      ;
      /*IPDispatchC.QueueC*/QueueC__0__queue[/*IPDispatchC.QueueC*/QueueC__0__tail] = newVal;
      /*IPDispatchC.QueueC*/QueueC__0__tail++;
      if (/*IPDispatchC.QueueC*/QueueC__0__tail == 12) {
#line 102
        /*IPDispatchC.QueueC*/QueueC__0__tail = 0;
        }
#line 103
      /*IPDispatchC.QueueC*/QueueC__0__size++;
      /*IPDispatchC.QueueC*/QueueC__0__printQueue();
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 90 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static error_t IPDispatchP__SendQueue__enqueue(IPDispatchP__SendQueue__t  newVal){
#line 90
  unsigned char result;
#line 90

#line 90
  result = /*IPDispatchC.QueueC*/QueueC__0__Queue__enqueue(newVal);
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static error_t IPDispatchP__SendEntryPool__put(IPDispatchP__SendEntryPool__t * newVal){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__put(newVal);
#line 89

#line 89
  return result;
#line 89
}
#line 89
inline static error_t IPDispatchP__FragPool__put(IPDispatchP__FragPool__t * newVal){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__put(newVal);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static void IPDispatchP__BarePacket__setPayloadLength(message_t * msg, uint8_t len){
#line 83
  CC2420TinyosNetworkP__BarePacket__setPayloadLength(msg, len);
#line 83
}
#line 83
# 110 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline uint8_t CC2420TinyosNetworkP__BarePacket__maxPayloadLength(void )
#line 110
{
  return 114 + sizeof(cc2420_header_t );
}

# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static uint8_t IPDispatchP__BarePacket__maxPayloadLength(void ){
#line 95
  unsigned char result;
#line 95

#line 95
  result = CC2420TinyosNetworkP__BarePacket__maxPayloadLength();
#line 95

#line 95
  return result;
#line 95
}
#line 95
# 114 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void * IPDispatchP__Ieee154Send__getPayload(message_t * msg, uint8_t len){
#line 114
  void *result;
#line 114

#line 114
  result = CC2420TinyosNetworkP__BareSend__getPayload(msg, len);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 96 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline void CC2420TinyosNetworkP__BarePacket__clear(message_t *msg)
#line 96
{
  memset(msg, 0, sizeof(message_t ));
}

# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static void IPDispatchP__BarePacket__clear(message_t * msg){
#line 54
  CC2420TinyosNetworkP__BarePacket__clear(msg);
#line 54
}
#line 54
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t */*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__get(void )
#line 88
{
  if (/*IPDispatchC.FragPool.PoolP*/PoolP__0__free) {
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t *rval = /*IPDispatchC.FragPool.PoolP*/PoolP__0__queue[/*IPDispatchC.FragPool.PoolP*/PoolP__0__index];

#line 91
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__queue[/*IPDispatchC.FragPool.PoolP*/PoolP__0__index] = (void *)0;
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__free--;
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__index++;
      if (/*IPDispatchC.FragPool.PoolP*/PoolP__0__index == 12) {
          /*IPDispatchC.FragPool.PoolP*/PoolP__0__index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static IPDispatchP__FragPool__t * IPDispatchP__FragPool__get(void ){
#line 97
  nx_struct message_t *result;
#line 97

#line 97
  result = /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t */*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__get(void )
#line 88
{
  if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free) {
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t *rval = /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__queue[/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index];

#line 91
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__queue[/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index] = (void *)0;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free--;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index++;
      if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index == 12) {
          /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static IPDispatchP__SendEntryPool__t * IPDispatchP__SendEntryPool__get(void ){
#line 97
  struct __nesc_unnamed4297 *result;
#line 97

#line 97
  result = /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t */*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__get(void )
#line 88
{
  if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free) {
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t *rval = /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__queue[/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index];

#line 91
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__queue[/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index] = (void *)0;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free--;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index++;
      if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index == 3) {
          /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static IPDispatchP__SendInfoPool__t * IPDispatchP__SendInfoPool__get(void ){
#line 97
  struct __nesc_unnamed4296 *result;
#line 97

#line 97
  result = /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 167 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline send_info_t *IPDispatchP__getSendInfo(void )
#line 167
{
  send_info_t *ret = IPDispatchP__SendInfoPool__get();

#line 169
  if (ret == (void *)0) {
#line 169
    return ret;
    }
#line 170
  ret->refcount = 1;
  ret->failed = FALSE;
  ret->link_transmissions = 0;
  ret->link_fragments = 0;
  return ret;
}

#line 498
static inline error_t IPDispatchP__IPLower__send(struct ieee154_frame_addr *frame_addr, 
struct ip6_packet *msg)
#line 499
{
  struct lowpan_ctx ctx;
  send_info_t *s_info;
  send_entry_t *s_entry;
  message_t *outgoing;

  int frag_len = 1;
  error_t rc = SUCCESS;

  if (IPDispatchP__state != IPDispatchP__S_RUNNING) {
      return EOFF;
    }

  ctx.tag = IPDispatchP__current_local_label++;
  ctx.offset = 0;

  s_info = IPDispatchP__getSendInfo();
  if (s_info == (void *)0) {
      rc = ERETRY;
      goto cleanup_outer;
    }

  while (frag_len > 0) {
      s_entry = IPDispatchP__SendEntryPool__get();
      outgoing = IPDispatchP__FragPool__get();

      if (s_entry == (void *)0 || outgoing == (void *)0) {
          if (s_entry != (void *)0) {
            IPDispatchP__SendEntryPool__put(s_entry);
            }
#line 528
          if (outgoing != (void *)0) {
            IPDispatchP__FragPool__put(outgoing);
            }

          s_info->failed = TRUE;
          {
#line 533
            sprintf(debugbuf, "drops: IP send: no fragments\n");
#line 533
            writedebug();
          }
#line 533
          ;
          rc = ERETRY;
          goto done;
        }

      IPDispatchP__BarePacket__clear(outgoing);
      frag_len = lowpan_frag_get(IPDispatchP__Ieee154Send__getPayload(outgoing, 0), 
      IPDispatchP__BarePacket__maxPayloadLength(), 
      msg, 
      frame_addr, 
      &ctx);
      if (frag_len < 0) {
          {
#line 545
            sprintf(debugbuf, " get frag error: %i\n", frag_len);
#line 545
            writedebug();
          }
#line 545
          ;
        }

      {
#line 548
        sprintf(debugbuf, "fragment length: %i offset: %i\n", frag_len, ctx.offset);
#line 548
        writedebug();
      }
#line 548
      ;
      IPDispatchP__BarePacket__setPayloadLength(outgoing, frag_len);
#line 562
      s_info->link_fragments++;
      s_entry->msg = outgoing;
      s_entry->info = s_info;

      if (frag_len <= 0) {
          IPDispatchP__FragPool__put(outgoing);
          IPDispatchP__SendEntryPool__put(s_entry);
          goto done;
        }

      if (IPDispatchP__SendQueue__enqueue(s_entry) != SUCCESS) {
          ;
          {
#line 574
            sprintf(debugbuf, "drops: IP send: enqueue failed\n");
#line 574
            writedebug();
          }
#line 574
          ;
          goto done;
        }

      s_info->refcount++;
    }

  done: 
    ;
  if (-- s_info->refcount == 0) {
#line 583
    IPDispatchP__SendInfoPool__put(s_info);
    }
#line 584
  IPDispatchP__sendTask__postTask();
  cleanup_outer: 
    return rc;
}

# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
inline static error_t IPAddressFilterP__SubIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg){
#line 17
  unsigned char result;
#line 17

#line 17
  result = IPDispatchP__IPLower__send(next_hop, msg);
#line 17

#line 17
  return result;
#line 17
}
#line 17
# 21 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressFilterP.nc"
static inline error_t IPAddressFilterP__LocalIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg)
#line 21
{
  return IPAddressFilterP__SubIP__send(next_hop, msg);
}

# 17 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/IPLower.nc"
inline static error_t IPProtocolsP__SubIP__send(struct ieee154_frame_addr *next_hop, struct ip6_packet *msg){
#line 17
  unsigned char result;
#line 17

#line 17
  result = IPAddressFilterP__LocalIP__send(next_hop, msg);
#line 17

#line 17
  return result;
#line 17
}
#line 17
# 178 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline uint8_t CC2420SpiP__Resource__isOwner(uint8_t id)
#line 178
{
  /* atomic removed: atomic calls only */
#line 179
  {
    unsigned char __nesc_temp = 
#line 179
    CC2420SpiP__m_holder == id;

#line 179
    return __nesc_temp;
  }
}

# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static bool CC2420ReceiveP__SpiResource__isOwner(void ){
#line 118
  unsigned char result;
#line 118

#line 118
  result = CC2420SpiP__Resource__isOwner(/*CC2420ReceiveC.Spi*/CC2420SpiC__4__CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
#line 87
inline static error_t CC2420ReceiveP__SpiResource__immediateRequest(void ){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiP__Resource__immediateRequest(/*CC2420ReceiveC.Spi*/CC2420SpiC__4__CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
#line 78
inline static error_t CC2420ReceiveP__SpiResource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP__Resource__request(/*CC2420ReceiveC.Spi*/CC2420SpiC__4__CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420SpiP__grant__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420SpiP__grant);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 184 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__SpiResource__granted(void )
#line 184
{
  CC2420SpiP__grant__postTask();
}

# 114 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__default__granted(uint8_t id)
#line 114
{
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__granted(uint8_t arg_0x1c07368){
#line 92
  switch (arg_0x1c07368) {
#line 92
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 92
      CC2420SpiP__SpiResource__granted();
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__default__granted(arg_0x1c07368);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__granted(uint8_t id)
#line 98
{
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Resource__granted(id);
}

# 199 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__default__granted(uint8_t id)
#line 199
{
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__granted(uint8_t arg_0x1e71c20){
#line 92
  switch (arg_0x1e71c20) {
#line 92
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID:
#line 92
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartResource__granted(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID);
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__default__granted(arg_0x1e71c20);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 187 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__runTask(void )
#line 187
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 188
    {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId;
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_BUSY;
    }
#line 191
    __nesc_atomic_end(__nesc_atomic); }
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceConfigure__configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId);
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__granted(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId);
}

# 197 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__default__sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error)
#line 197
{
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__sendDone(uint8_t arg_0x1c068d0, uint8_t * txBuf, uint8_t * rxBuf, uint16_t len, error_t error){
#line 71
  switch (arg_0x1c068d0) {
#line 71
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C__0__CLIENT_ID:
#line 71
      CC2420SpiP__SpiPacket__sendDone(txBuf, rxBuf, len, error);
#line 71
      break;
#line 71
    default:
#line 71
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__default__sendDone(arg_0x1c068d0, txBuf, rxBuf, len, error);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 190 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone(error_t error)
#line 190
{
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__sendDone(/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_client, /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_tx_buf, /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_rx_buf, /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_len, error);
}

#line 180
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__runTask(void )
#line 180
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 181
    /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone(SUCCESS);
#line 181
    __nesc_atomic_end(__nesc_atomic); }
}

# 486 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__TXFIFO__readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 487
{
}

# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ReceiveP__SpiResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP__Resource__release(/*CC2420ReceiveC.Spi*/CC2420SpiC__4__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ReceiveP__CSN__set(void ){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set();
#line 29
}
#line 29
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420ReceiveP__receiveDone_task__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420ReceiveP__receiveDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_metadata_t * CC2420TransmitP__CC2420PacketBody__getMetadata(message_t * msg){
#line 53
  nx_struct cc2420_metadata_t *result;
#line 53

#line 53
  result = CC2420PacketP__CC2420PacketBody__getMetadata(msg);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 389 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__CC2420Receive__receive(uint8_t type, message_t *ack_msg)
#line 389
{
  cc2420_header_t *ack_header;
  cc2420_header_t *msg_header;
  cc2420_metadata_t *msg_metadata;
  uint8_t *ack_buf;
  uint8_t length;

  if (type == IEEE154_TYPE_ACK && CC2420TransmitP__m_msg) {
      ack_header = CC2420TransmitP__CC2420PacketBody__getHeader(ack_msg);
      msg_header = CC2420TransmitP__CC2420PacketBody__getHeader(CC2420TransmitP__m_msg);

      if (CC2420TransmitP__m_state == CC2420TransmitP__S_ACK_WAIT && __nesc_ntoh_leuint8(msg_header->dsn.data) == __nesc_ntoh_leuint8(ack_header->dsn.data)) {
          CC2420TransmitP__BackoffTimer__stop();

          msg_metadata = CC2420TransmitP__CC2420PacketBody__getMetadata(CC2420TransmitP__m_msg);
          ack_buf = (uint8_t *)ack_header;
          length = __nesc_ntoh_leuint8(ack_header->length.data);

          __nesc_hton_int8(msg_metadata->ack.data, TRUE);
          __nesc_hton_uint8(msg_metadata->rssi.data, ack_buf[length - 1]);
          __nesc_hton_uint8(msg_metadata->lqi.data, ack_buf[length] & 0x7f);
          CC2420TransmitP__signalDone(SUCCESS);
        }
    }
}

# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static void CC2420ReceiveP__CC2420Receive__receive(uint8_t type, message_t * message){
#line 63
  CC2420TransmitP__CC2420Receive__receive(type, message);
#line 63
}
#line 63
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static void CC2420ReceiveP__PacketTimeStamp__clear(message_t * msg){
#line 59
  CC2420PacketP__PacketTimeStamp32khz__clear(msg);
#line 59
}
#line 59








inline static void CC2420ReceiveP__PacketTimeStamp__set(message_t * msg, CC2420ReceiveP__PacketTimeStamp__size_type value){
#line 67
  CC2420PacketP__PacketTimeStamp32khz__set(msg, value);
#line 67
}
#line 67
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__getRaw(void )
#line 48
{
#line 48
  return * (volatile uint8_t * )32U & (0x01 << 0);
}

#line 49
static inline bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__get(void )
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__getRaw() != 0;
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__HplGeneralIO__get(void ){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP__0__IO__get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__GeneralIO__get(void )
#line 40
{
#line 40
  return /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__HplGeneralIO__get();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static bool CC2420ReceiveP__FIFOP__get(void ){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.FIFOPM*/Msp430GpioC__6__GeneralIO__get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 48 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__getRaw(void )
#line 48
{
#line 48
  return * (volatile uint8_t * )32U & (0x01 << 3);
}

#line 49
static inline bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__get(void )
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__getRaw() != 0;
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__HplGeneralIO__get(void ){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP__3__IO__get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__GeneralIO__get(void )
#line 40
{
#line 40
  return /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__HplGeneralIO__get();
}

# 32 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static bool CC2420ReceiveP__FIFO__get(void ){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.FIFOM*/Msp430GpioC__5__GeneralIO__get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 209 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline error_t CC2420SpiP__Fifo__continueRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 210
{
  return CC2420SpiP__SpiPacket__send((void *)0, data, len);
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static error_t CC2420ReceiveP__RXFIFO__continueRead(uint8_t * data, uint8_t length){
#line 62
  unsigned char result;
#line 62

#line 62
  result = CC2420SpiP__Fifo__continueRead(CC2420_RXFIFO, data, length);
#line 62

#line 62
  return result;
#line 62
}
#line 62
#line 51
inline static cc2420_status_t CC2420ReceiveP__RXFIFO__beginRead(uint8_t * data, uint8_t length){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420SpiP__Fifo__beginRead(CC2420_RXFIFO, data, length);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ReceiveP__CSN__clr(void ){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr();
#line 30
}
#line 30
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420ReceiveP__SACK__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SACK);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 370 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline bool CC2420ControlP__CC2420Config__isHwAutoAckDefault(void )
#line 370
{
  /* atomic removed: atomic calls only */
#line 371
  {
    unsigned char __nesc_temp = 
#line 371
    CC2420ControlP__hwAutoAckDefault;

#line 371
    return __nesc_temp;
  }
}

# 110 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static bool CC2420ReceiveP__CC2420Config__isHwAutoAckDefault(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420ControlP__CC2420Config__isHwAutoAckDefault();
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 377 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline bool CC2420ControlP__CC2420Config__isAutoAckEnabled(void )
#line 377
{
  /* atomic removed: atomic calls only */
#line 378
  {
    unsigned char __nesc_temp = 
#line 378
    CC2420ControlP__autoAckEnabled;

#line 378
    return __nesc_temp;
  }
}

# 115 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static bool CC2420ReceiveP__CC2420Config__isAutoAckEnabled(void ){
#line 115
  unsigned char result;
#line 115

#line 115
  result = CC2420ControlP__CC2420Config__isAutoAckEnabled();
#line 115

#line 115
  return result;
#line 115
}
#line 115
# 525 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__RXFIFO__readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error)
#line 526
{
  cc2420_header_t *header = CC2420ReceiveP__CC2420PacketBody__getHeader(CC2420ReceiveP__m_p_rx_buf);
  uint8_t tmpLen __attribute((unused))  = sizeof(message_t ) - ((size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
  uint8_t * buf = (uint8_t * )header;

#line 530
  CC2420ReceiveP__rxFrameLength = buf[0];

  switch (CC2420ReceiveP__m_state) {

      case CC2420ReceiveP__S_RX_LENGTH: 
        CC2420ReceiveP__m_state = CC2420ReceiveP__S_RX_FCF;



      if (CC2420ReceiveP__rxFrameLength + 1 > CC2420ReceiveP__m_bytes_left) 



        {

          CC2420ReceiveP__flush();
        }
      else {
          if (!CC2420ReceiveP__FIFO__get() && !CC2420ReceiveP__FIFOP__get()) {
              CC2420ReceiveP__m_bytes_left -= CC2420ReceiveP__rxFrameLength + 1;
            }

          if (CC2420ReceiveP__rxFrameLength <= MAC_PACKET_SIZE) {
              if (CC2420ReceiveP__rxFrameLength > 0) {
                  if (CC2420ReceiveP__rxFrameLength > CC2420ReceiveP__SACK_HEADER_LENGTH) {

                      CC2420ReceiveP__RXFIFO__continueRead(buf + 1, CC2420ReceiveP__SACK_HEADER_LENGTH);
                    }
                  else {

                      CC2420ReceiveP__m_state = CC2420ReceiveP__S_RX_PAYLOAD;
                      CC2420ReceiveP__RXFIFO__continueRead(buf + 1, CC2420ReceiveP__rxFrameLength);
                    }
                }
              else {
                  /* atomic removed: atomic calls only */
                  CC2420ReceiveP__receivingPacket = FALSE;
                  CC2420ReceiveP__CSN__set();
                  CC2420ReceiveP__SpiResource__release();
                  CC2420ReceiveP__waitForNextPacket();
                }
            }
          else {

              CC2420ReceiveP__flush();
            }
        }
      break;

      case CC2420ReceiveP__S_RX_FCF: 
        CC2420ReceiveP__m_state = CC2420ReceiveP__S_RX_PAYLOAD;










      if (CC2420ReceiveP__CC2420Config__isAutoAckEnabled() && !CC2420ReceiveP__CC2420Config__isHwAutoAckDefault()) {



          if (((__nesc_ntoh_leuint16(
#line 592
          header->fcf.data) >> IEEE154_FCF_ACK_REQ) & 0x01) == 1
           && (__nesc_ntoh_leuint16(header->dest.data) == CC2420ReceiveP__CC2420Config__getShortAddr()
           || __nesc_ntoh_leuint16(header->dest.data) == AM_BROADCAST_ADDR)
           && ((__nesc_ntoh_leuint16(header->fcf.data) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_DATA) {

              CC2420ReceiveP__CSN__set();
              CC2420ReceiveP__CSN__clr();
              CC2420ReceiveP__SACK__strobe();
              CC2420ReceiveP__CSN__set();
              CC2420ReceiveP__CSN__clr();
              CC2420ReceiveP__RXFIFO__beginRead(buf + 1 + CC2420ReceiveP__SACK_HEADER_LENGTH, 
              CC2420ReceiveP__rxFrameLength - CC2420ReceiveP__SACK_HEADER_LENGTH);
              return;
            }
        }

      CC2420ReceiveP__RXFIFO__continueRead(buf + 1 + CC2420ReceiveP__SACK_HEADER_LENGTH, 
      CC2420ReceiveP__rxFrameLength - CC2420ReceiveP__SACK_HEADER_LENGTH);
      break;

      case CC2420ReceiveP__S_RX_PAYLOAD: 

        CC2420ReceiveP__CSN__set();
      if (!CC2420ReceiveP__m_missed_packets) {

          CC2420ReceiveP__SpiResource__release();
        }




      if ((((
#line 621
      CC2420ReceiveP__m_missed_packets && CC2420ReceiveP__FIFO__get()) || !CC2420ReceiveP__FIFOP__get())
       || !CC2420ReceiveP__m_timestamp_size)
       || CC2420ReceiveP__rxFrameLength <= 10) {
          CC2420ReceiveP__PacketTimeStamp__clear(CC2420ReceiveP__m_p_rx_buf);
        }
      else {
          if (CC2420ReceiveP__m_timestamp_size == 1) {
            CC2420ReceiveP__PacketTimeStamp__set(CC2420ReceiveP__m_p_rx_buf, CC2420ReceiveP__m_timestamp_queue[CC2420ReceiveP__m_timestamp_head]);
            }
#line 629
          CC2420ReceiveP__m_timestamp_head = (CC2420ReceiveP__m_timestamp_head + 1) % CC2420ReceiveP__TIMESTAMP_QUEUE_SIZE;
          CC2420ReceiveP__m_timestamp_size--;

          if (CC2420ReceiveP__m_timestamp_size > 0) {
              CC2420ReceiveP__PacketTimeStamp__clear(CC2420ReceiveP__m_p_rx_buf);
              CC2420ReceiveP__m_timestamp_head = 0;
              CC2420ReceiveP__m_timestamp_size = 0;
            }
        }



      if (buf[CC2420ReceiveP__rxFrameLength] >> 7 && rx_buf) {
          uint8_t type = (__nesc_ntoh_leuint16(header->fcf.data) >> IEEE154_FCF_FRAME_TYPE) & 7;

#line 643
          CC2420ReceiveP__CC2420Receive__receive(type, CC2420ReceiveP__m_p_rx_buf);
          if (type == IEEE154_TYPE_DATA) {
              CC2420ReceiveP__receiveDone_task__postTask();
              return;
            }
        }

      CC2420ReceiveP__waitForNextPacket();
      break;

      default: /* atomic removed: atomic calls only */
        CC2420ReceiveP__receivingPacket = FALSE;
      CC2420ReceiveP__CSN__set();
      CC2420ReceiveP__SpiResource__release();
      break;
    }
}

# 370 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__Fifo__default__readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error)
#line 370
{
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static void CC2420SpiP__Fifo__readDone(uint8_t arg_0x1b33dc8, uint8_t * data, uint8_t length, error_t error){
#line 71
  switch (arg_0x1b33dc8) {
#line 71
    case CC2420_TXFIFO:
#line 71
      CC2420TransmitP__TXFIFO__readDone(data, length, error);
#line 71
      break;
#line 71
    case CC2420_RXFIFO:
#line 71
      CC2420ReceiveP__RXFIFO__readDone(data, length, error);
#line 71
      break;
#line 71
    default:
#line 71
      CC2420SpiP__Fifo__default__readDone(arg_0x1b33dc8, data, length, error);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420ReceiveP__SFLUSHRX__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SFLUSHRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 288 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__RadioBackoff__default__requestInitialBackoff(message_t *msg)
#line 288
{
}

# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420CsmaP__RadioBackoff__requestInitialBackoff(message_t * msg){
#line 81
  CC2420CsmaP__RadioBackoff__default__requestInitialBackoff(msg);
#line 81
}
#line 81
# 243 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__RadioBackoff__setInitialBackoff(uint16_t backoffTime)
#line 243
{
  CC2420TransmitP__myInitialBackoff = backoffTime + 1;
}

# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420CsmaP__SubBackoff__setInitialBackoff(uint16_t backoffTime){
#line 60
  CC2420TransmitP__RadioBackoff__setInitialBackoff(backoffTime);
#line 60
}
#line 60
# 223 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__SubBackoff__requestInitialBackoff(message_t *msg)
#line 223
{
  CC2420CsmaP__SubBackoff__setInitialBackoff(CC2420CsmaP__Random__rand16()
   % (0x1F * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP__RadioBackoff__requestInitialBackoff(msg);
}

# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static void CC2420TransmitP__RadioBackoff__requestInitialBackoff(message_t * msg){
#line 81
  CC2420CsmaP__SubBackoff__requestInitialBackoff(msg);
#line 81
}
#line 81
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420CsmaP__sendDone_task__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420CsmaP__sendDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 205 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__CC2420Transmit__sendDone(message_t *p_msg, error_t err)
#line 205
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 206
    CC2420CsmaP__sendErr = err;
#line 206
    __nesc_atomic_end(__nesc_atomic); }
  CC2420CsmaP__sendDone_task__postTask();
}

# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
inline static void CC2420TransmitP__Send__sendDone(message_t * p_msg, error_t error){
#line 73
  CC2420CsmaP__CC2420Transmit__sendDone(p_msg, error);
#line 73
}
#line 73
# 454 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__TXFIFO__writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 455
{

  CC2420TransmitP__CSN__set();
  if (CC2420TransmitP__m_state == CC2420TransmitP__S_CANCEL) {
      /* atomic removed: atomic calls only */
#line 459
      {
        CC2420TransmitP__CSN__clr();
        CC2420TransmitP__SFLUSHTX__strobe();
        CC2420TransmitP__CSN__set();
      }
      CC2420TransmitP__releaseSpiResource();
      CC2420TransmitP__m_state = CC2420TransmitP__S_STARTED;
      CC2420TransmitP__Send__sendDone(CC2420TransmitP__m_msg, ECANCEL);
    }
  else {
#line 468
    if (!CC2420TransmitP__m_cca) {
        /* atomic removed: atomic calls only */
#line 469
        {
          CC2420TransmitP__m_state = CC2420TransmitP__S_BEGIN_TRANSMIT;
        }
        CC2420TransmitP__attemptSend();
      }
    else {
        CC2420TransmitP__releaseSpiResource();
        /* atomic removed: atomic calls only */
#line 476
        {
          CC2420TransmitP__m_state = CC2420TransmitP__S_SAMPLE_CCA;
        }

        CC2420TransmitP__RadioBackoff__requestInitialBackoff(CC2420TransmitP__m_msg);
        CC2420TransmitP__BackoffTimer__start(CC2420TransmitP__myInitialBackoff);
      }
    }
}

# 663 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__RXFIFO__writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 663
{
}

# 373 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__Fifo__default__writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 373
{
}

# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static void CC2420SpiP__Fifo__writeDone(uint8_t arg_0x1b33dc8, uint8_t * data, uint8_t length, error_t error){
#line 91
  switch (arg_0x1b33dc8) {
#line 91
    case CC2420_TXFIFO:
#line 91
      CC2420TransmitP__TXFIFO__writeDone(data, length, error);
#line 91
      break;
#line 91
    case CC2420_RXFIFO:
#line 91
      CC2420ReceiveP__RXFIFO__writeDone(data, length, error);
#line 91
      break;
#line 91
    default:
#line 91
      CC2420SpiP__Fifo__default__writeDone(arg_0x1b33dc8, data, length, error);
#line 91
      break;
#line 91
    }
#line 91
}
#line 91
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static cc2420_status_t CC2420ControlP__RXCTRL1__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_RXCTRL1, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static cc2420_status_t CC2420ControlP__IOCFG0__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_IOCFG0, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420ControlP__SXOSCON__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SXOSCON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 79 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port14__enable(void )
#line 79
{
#line 79
  P1IE |= 1 << 4;
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__enable(void ){
#line 31
  HplMsp430InterruptP__Port14__enable();
#line 31
}
#line 31
# 131 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port14__edge(bool l2h)
#line 131
{
  /* atomic removed: atomic calls only */
#line 132
  {
    if (l2h) {
#line 133
      P1IES &= ~(1 << 4);
      }
    else {
#line 134
      P1IES |= 1 << 4;
      }
  }
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__edge(bool low_to_high){
#line 56
  HplMsp430InterruptP__Port14__edge(low_to_high);
#line 56
}
#line 56
# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port14__clear(void )
#line 95
{
#line 95
  P1IFG &= ~(1 << 4);
}

# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__clear(void ){
#line 41
  HplMsp430InterruptP__Port14__clear();
#line 41
}
#line 41
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port14__disable(void )
#line 87
{
#line 87
  P1IE &= ~(1 << 4);
}

# 36 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__disable(void ){
#line 36
  HplMsp430InterruptP__Port14__disable();
#line 36
}
#line 36
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__disable(void )
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__disable();
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__clear();
  }
  return SUCCESS;
}

#line 41
static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__enable(bool rising)
#line 41
{
  /* atomic removed: atomic calls only */
#line 42
  {
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__disable();
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__edge(rising);
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__enable();
  }
  return SUCCESS;
}

static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__enableRisingEdge(void )
#line 50
{
  return /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__enable(TRUE);
}

# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static error_t CC2420ControlP__InterruptCCA__enableRisingEdge(void ){
#line 42
  unsigned char result;
#line 42

#line 42
  result = /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__enableRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static cc2420_status_t CC2420ControlP__IOCFG1__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_IOCFG1, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 214 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__CC2420Power__startOscillator(void )
#line 214
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 215
    {
      if (CC2420ControlP__m_state != CC2420ControlP__S_VREG_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 217
            FAIL;

            {
#line 217
              __nesc_atomic_end(__nesc_atomic); 
#line 217
              return __nesc_temp;
            }
          }
        }
#line 220
      CC2420ControlP__m_state = CC2420ControlP__S_XOSC_STARTING;
      CC2420ControlP__IOCFG1__write(CC2420_SFDMUX_XOSC16M_STABLE << 
      CC2420_IOCFG1_CCAMUX);

      CC2420ControlP__InterruptCCA__enableRisingEdge();
      CC2420ControlP__SXOSCON__strobe();

      CC2420ControlP__IOCFG0__write((1 << CC2420_IOCFG0_FIFOP_POLARITY) | (
      127 << CC2420_IOCFG0_FIFOP_THR));

      CC2420ControlP__writeFsctrl();
      CC2420ControlP__writeMdmctrl0();

      CC2420ControlP__RXCTRL1__write(((((((1 << CC2420_RXCTRL1_RXBPF_LOCUR) | (
      1 << CC2420_RXCTRL1_LOW_LOWGAIN)) | (
      1 << CC2420_RXCTRL1_HIGH_HGM)) | (
      1 << CC2420_RXCTRL1_LNA_CAP_ARRAY)) | (
      1 << CC2420_RXCTRL1_RXMIX_TAIL)) | (
      1 << CC2420_RXCTRL1_RXMIX_VCM)) | (
      2 << CC2420_RXCTRL1_RXMIX_CURRENT));
    }
#line 240
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static error_t CC2420CsmaP__CC2420Power__startOscillator(void ){
#line 71
  unsigned char result;
#line 71

#line 71
  result = CC2420ControlP__CC2420Power__startOscillator();
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 214 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__Resource__granted(void )
#line 214
{
  CC2420CsmaP__CC2420Power__startOscillator();
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static void CC2420ControlP__Resource__granted(void ){
#line 92
  CC2420CsmaP__Resource__granted();
#line 92
}
#line 92
# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__CSN__clr(void ){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__clr();
#line 30
}
#line 30
# 401 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__SpiResource__granted(void )
#line 401
{
  CC2420ControlP__CSN__clr();
  CC2420ControlP__Resource__granted();
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420ControlP__syncDone__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420ControlP__syncDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ControlP__SyncResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP__Resource__release(/*CC2420ControlC.SyncSpiC*/CC2420SpiC__1__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__CSN__set(void ){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__set();
#line 29
}
#line 29
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static cc2420_status_t CC2420ControlP__SRXON__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SRXON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static cc2420_status_t CC2420ControlP__SRFOFF__strobe(void ){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP__Strobe__strobe(CC2420_SRFOFF);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 387 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__SyncResource__granted(void )
#line 387
{
  CC2420ControlP__CSN__clr();
  CC2420ControlP__SRFOFF__strobe();
  CC2420ControlP__writeFsctrl();
  CC2420ControlP__writeMdmctrl0();
  CC2420ControlP__writeId();
  CC2420ControlP__CSN__set();
  CC2420ControlP__CSN__clr();
  CC2420ControlP__SRXON__strobe();
  CC2420ControlP__CSN__set();
  CC2420ControlP__SyncResource__release();
  CC2420ControlP__syncDone__postTask();
}

#line 521
static inline void CC2420ControlP__ReadRssi__default__readDone(error_t error, uint16_t data)
#line 521
{
}

# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Read.nc"
inline static void CC2420ControlP__ReadRssi__readDone(error_t result, CC2420ControlP__ReadRssi__val_t val){
#line 63
  CC2420ControlP__ReadRssi__default__readDone(result, val);
#line 63
}
#line 63
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ControlP__RssiResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP__Resource__release(/*CC2420ControlC.RssiResource*/CC2420SpiC__2__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 287 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline cc2420_status_t CC2420SpiP__Reg__read(uint8_t addr, uint16_t *data)
#line 287
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 291
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 293
            status;

            {
#line 293
              __nesc_atomic_end(__nesc_atomic); 
#line 293
              return __nesc_temp;
            }
          }
        }
    }
#line 297
    __nesc_atomic_end(__nesc_atomic); }
#line 297
  status = CC2420SpiP__SpiByte__write(addr | 0x40);
  *data = (uint16_t )CC2420SpiP__SpiByte__write(0) << 8;
  *data |= CC2420SpiP__SpiByte__write(0);

  return status;
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static cc2420_status_t CC2420ControlP__RSSI__read(uint16_t *data){
#line 47
  unsigned char result;
#line 47

#line 47
  result = CC2420SpiP__Reg__read(CC2420_RSSI, data);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 406 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__RssiResource__granted(void )
#line 406
{
  uint16_t data;

#line 408
  CC2420ControlP__CSN__clr();
  CC2420ControlP__RSSI__read(&data);
  CC2420ControlP__CSN__set();

  CC2420ControlP__RssiResource__release();
  data += 0x7f;
  data &= 0x00ff;
  CC2420ControlP__ReadRssi__readDone(SUCCESS, data);
}

# 416 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline void CC2420TransmitP__SpiResource__granted(void )
#line 416
{
  uint8_t cur_state;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 419
    {
      cur_state = CC2420TransmitP__m_state;
    }
#line 421
    __nesc_atomic_end(__nesc_atomic); }

  switch (cur_state) {
      case CC2420TransmitP__S_LOAD: 
        CC2420TransmitP__loadTXFIFO();
      break;

      case CC2420TransmitP__S_BEGIN_TRANSMIT: 
        CC2420TransmitP__attemptSend();
      break;

      case CC2420TransmitP__S_CANCEL: 
        CC2420TransmitP__CSN__clr();
      CC2420TransmitP__SFLUSHTX__strobe();
      CC2420TransmitP__CSN__set();
      CC2420TransmitP__releaseSpiResource();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 437
        {
          CC2420TransmitP__m_state = CC2420TransmitP__S_STARTED;
        }
#line 439
        __nesc_atomic_end(__nesc_atomic); }
      CC2420TransmitP__Send__sendDone(CC2420TransmitP__m_msg, ECANCEL);
      break;

      default: 
        CC2420TransmitP__releaseSpiResource();
      break;
    }
}

# 508 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__SpiResource__granted(void )
#line 508
{







  CC2420ReceiveP__receive();
}

# 367 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__Resource__default__granted(uint8_t id)
#line 367
{
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static void CC2420SpiP__Resource__granted(uint8_t arg_0x1b33398){
#line 92
  switch (arg_0x1b33398) {
#line 92
    case /*CC2420ControlC.Spi*/CC2420SpiC__0__CLIENT_ID:
#line 92
      CC2420ControlP__SpiResource__granted();
#line 92
      break;
#line 92
    case /*CC2420ControlC.SyncSpiC*/CC2420SpiC__1__CLIENT_ID:
#line 92
      CC2420ControlP__SyncResource__granted();
#line 92
      break;
#line 92
    case /*CC2420ControlC.RssiResource*/CC2420SpiC__2__CLIENT_ID:
#line 92
      CC2420ControlP__RssiResource__granted();
#line 92
      break;
#line 92
    case /*CC2420TransmitC.Spi*/CC2420SpiC__3__CLIENT_ID:
#line 92
      CC2420TransmitP__SpiResource__granted();
#line 92
      break;
#line 92
    case /*CC2420ReceiveC.Spi*/CC2420SpiC__4__CLIENT_ID:
#line 92
      CC2420ReceiveP__SpiResource__granted();
#line 92
      break;
#line 92
    default:
#line 92
      CC2420SpiP__Resource__default__granted(arg_0x1b33398);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 358 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline void CC2420SpiP__grant__runTask(void )
#line 358
{
  uint8_t holder;

#line 360
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 360
    {
      holder = CC2420SpiP__m_holder;
    }
#line 362
    __nesc_atomic_end(__nesc_atomic); }
  CC2420SpiP__Resource__granted(holder);
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static cc2420_status_t CC2420ControlP__FSCTRL__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_FSCTRL, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static cc2420_status_t CC2420ControlP__MDMCTRL0__write(uint16_t data){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP__Reg__write(CC2420_MDMCTRL0, data);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Ram.nc"
inline static cc2420_status_t CC2420ControlP__IEEEADR__write(uint8_t offset, uint8_t * data, uint8_t length){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420SpiP__Ram__write(CC2420_RAM_IEEEADR, offset, data, length);
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 704 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__CC2420Config__syncDone(error_t error)
#line 704
{
}

# 135 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
static inline void IPAddressP__CC2420Config__syncDone(error_t err)
#line 135
{
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static void CC2420ControlP__CC2420Config__syncDone(error_t error){
#line 53
  IPAddressP__CC2420Config__syncDone(error);
#line 53
  CC2420ReceiveP__CC2420Config__syncDone(error);
#line 53
}
#line 53
# 457 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__syncDone__runTask(void )
#line 457
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 458
    CC2420ControlP__m_sync_busy = FALSE;
#line 458
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP__CC2420Config__syncDone(SUCCESS);
}

# 78 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ControlP__SyncResource__request(void ){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP__Resource__request(/*CC2420ControlC.SyncSpiC*/CC2420SpiC__1__CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 311 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__CC2420Config__sync(void )
#line 311
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 312
    {
      if (CC2420ControlP__m_sync_busy) {
          {
            unsigned char __nesc_temp = 
#line 314
            FAIL;

            {
#line 314
              __nesc_atomic_end(__nesc_atomic); 
#line 314
              return __nesc_temp;
            }
          }
        }
#line 317
      CC2420ControlP__m_sync_busy = TRUE;
      if (CC2420ControlP__m_state == CC2420ControlP__S_XOSC_STARTED) {
          CC2420ControlP__SyncResource__request();
        }
      else 
#line 320
        {
          CC2420ControlP__syncDone__postTask();
        }
    }
#line 323
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 453
static inline void CC2420ControlP__sync__runTask(void )
#line 453
{
  CC2420ControlP__CC2420Config__sync();
}

# 111 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline uint16_t PacketLinkP__PacketLink__getRetryDelay(message_t *msg)
#line 111
{
  return __nesc_ntoh_uint16(PacketLinkP__CC2420PacketBody__getMetadata(msg)->retryDelay.data);
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__get(void ){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getNow(void )
{
  return /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__get();
}

# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getNow(void ){
#line 98
  unsigned long result;
#line 98

#line 98
  result = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__getNow(void )
{
#line 86
  return /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getNow();
}

# 125 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow(void ){
#line 125
  unsigned long result;
#line 125

#line 125
  result = /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__getNow();
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 148 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startOneShot(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow(), dt, TRUE);
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void PacketLinkP__DelayTimer__startOneShot(uint32_t dt){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startOneShot(2U, dt);
#line 62
}
#line 62
# 76 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline bool CC2420PacketP__Acks__wasAcked(message_t *p_msg)
#line 76
{
  return __nesc_ntoh_int8(CC2420PacketP__CC2420PacketBody__getMetadata(p_msg)->ack.data);
}

# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static bool PacketLinkP__PacketAcknowledgements__wasAcked(message_t * msg){
#line 74
  unsigned char result;
#line 74

#line 74
  result = CC2420PacketP__Acks__wasAcked(msg);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static uint8_t PacketLinkP__SendState__getState(void ){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP__State__getState(4U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 171 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline void PacketLinkP__SubSend__sendDone(message_t *msg, error_t error)
#line 171
{
  if (PacketLinkP__SendState__getState() == PacketLinkP__S_SENDING) {
      PacketLinkP__totalRetries++;
      if (PacketLinkP__PacketAcknowledgements__wasAcked(msg)) {
          PacketLinkP__signalDone(SUCCESS);
          return;
        }
      else {
#line 178
        if (PacketLinkP__totalRetries < PacketLinkP__PacketLink__getRetries(PacketLinkP__currentSendMsg)) {

            if (PacketLinkP__PacketLink__getRetryDelay(PacketLinkP__currentSendMsg) > 0) {

                PacketLinkP__DelayTimer__startOneShot(PacketLinkP__PacketLink__getRetryDelay(PacketLinkP__currentSendMsg));
              }
            else {

                PacketLinkP__send__postTask();
              }

            return;
          }
        }
    }
  PacketLinkP__signalDone(error);
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void CC2420CsmaP__Send__sendDone(message_t * msg, error_t error){
#line 89
  PacketLinkP__SubSend__sendDone(msg, error);
#line 89
}
#line 89
# 111 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline void StateImplP__State__forceState(uint8_t id, uint8_t reqState)
#line 111
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    StateImplP__state[id] = reqState;
#line 112
    __nesc_atomic_end(__nesc_atomic); }
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static void CC2420CsmaP__SplitControlState__forceState(uint8_t reqState){
#line 51
  StateImplP__State__forceState(1U, reqState);
#line 51
}
#line 51
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420CsmaP__stopDone_task__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420CsmaP__stopDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static error_t CC2420CsmaP__CC2420Power__stopVReg(void ){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420ControlP__CC2420Power__stopVReg();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/types/TinyError.h"
static inline  error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 84 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static error_t CC2420CsmaP__SubControl__stop(void ){
#line 84
  unsigned char result;
#line 84

#line 84
  result = CC2420TransmitP__StdControl__stop();
#line 84
  result = ecombine(result, CC2420ReceiveP__StdControl__stop());
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 275 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__shutdown(void )
#line 275
{
  CC2420CsmaP__SubControl__stop();
  CC2420CsmaP__CC2420Power__stopVReg();
  CC2420CsmaP__stopDone_task__postTask();
}

# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static bool CC2420CsmaP__SplitControlState__isState(uint8_t myState){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP__State__isState(1U, myState);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 244 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__sendDone_task__runTask(void )
#line 244
{
  error_t packetErr;

#line 246
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 246
    packetErr = CC2420CsmaP__sendErr;
#line 246
    __nesc_atomic_end(__nesc_atomic); }
  if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STOPPING)) {
      CC2420CsmaP__shutdown();
    }
  else {
      CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_STARTED);
    }

  CC2420CsmaP__Send__sendDone(CC2420CsmaP__m_msg, packetErr);
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectIOFunc(void )
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t * )31U &= ~(0x01 << 1);
}

# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectIOFunc(void ){
#line 85
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__selectIOFunc();
#line 85
}
#line 85
# 124 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__disableEvents(void )
{
  * (volatile uint16_t * )388U &= ~0x0010;
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__disableEvents(void ){
#line 47
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Control__disableEvents();
#line 47
}
#line 47
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__disable(void )
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__disableEvents();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectIOFunc();
  }
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static void CC2420TransmitP__CaptureSFD__disable(void ){
#line 55
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Capture__disable();
#line 55
}
#line 55
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port10__clear(void )
#line 91
{
#line 91
  P1IFG &= ~(1 << 0);
}

# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__clear(void ){
#line 41
  HplMsp430InterruptP__Port10__clear();
#line 41
}
#line 41
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port10__disable(void )
#line 83
{
#line 83
  P1IE &= ~(1 << 0);
}

# 36 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__disable(void ){
#line 36
  HplMsp430InterruptP__Port10__disable();
#line 36
}
#line 36
# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__disable(void )
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__disable();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__clear();
  }
  return SUCCESS;
}

# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static error_t CC2420ReceiveP__InterruptFIFOP__disable(void ){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__disable();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__clr(void )
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t * )29U &= ~(0x01 << 5);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__clr(void ){
#line 39
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__clr();
#line 39
}
#line 39
# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__clr(void )
#line 38
{
#line 38
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__clr();
}

# 30 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__VREN__clr(void ){
#line 30
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__clr();
#line 30
}
#line 30
# 153 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__stop(uint8_t num)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__m_timers[num].isrunning = FALSE;
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void PacketLinkP__DelayTimer__stop(void ){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__stop(2U);
#line 67
}
#line 67
# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static IPDispatchP__SendQueue__t  IPDispatchP__SendQueue__dequeue(void ){
#line 81
  struct __nesc_unnamed4297 *result;
#line 81

#line 81
  result = /*IPDispatchC.QueueC*/QueueC__0__Queue__dequeue();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static uint16_t IPDispatchP__PacketLink__getRetries(message_t * msg){
#line 59
  unsigned int result;
#line 59

#line 59
  result = PacketLinkP__PacketLink__getRetries(msg);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 118 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline bool PacketLinkP__PacketLink__wasDelivered(message_t *msg)
#line 118
{
  return PacketLinkP__PacketAcknowledgements__wasAcked(msg);
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static bool IPDispatchP__PacketLink__wasDelivered(message_t * msg){
#line 71
  unsigned char result;
#line 71

#line 71
  result = PacketLinkP__PacketLink__wasDelivered(msg);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 96 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline error_t CC2420CsmaP__SplitControl__stop(void )
#line 96
{
  if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STARTED)) {
      CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_STOPPING);
      CC2420CsmaP__shutdown();
      return SUCCESS;
    }
  else {
#line 102
    if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STOPPED)) {
        return EALREADY;
      }
    else {
#line 105
      if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_TRANSMITTING)) {
          CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_STOPPING);

          return SUCCESS;
        }
      else {
#line 110
        if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STOPPING)) {
            return SUCCESS;
          }
        }
      }
    }
#line 114
  return EBUSY;
}

# 109 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static error_t IPDispatchP__RadioControl__stop(void ){
#line 109
  unsigned char result;
#line 109

#line 109
  result = CC2420CsmaP__SplitControl__stop();
#line 109

#line 109
  return result;
#line 109
}
#line 109
# 65 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline /*IPDispatchC.QueueC*/QueueC__0__queue_t /*IPDispatchC.QueueC*/QueueC__0__Queue__head(void )
#line 65
{
  return /*IPDispatchC.QueueC*/QueueC__0__queue[/*IPDispatchC.QueueC*/QueueC__0__head];
}

# 73 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static IPDispatchP__SendQueue__t  IPDispatchP__SendQueue__head(void ){
#line 73
  struct __nesc_unnamed4297 *result;
#line 73

#line 73
  result = /*IPDispatchC.QueueC*/QueueC__0__Queue__head();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 589 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__Ieee154Send__sendDone(message_t *msg, error_t error)
#line 589
{
  send_entry_t *s_entry = IPDispatchP__SendQueue__head();

  IPDispatchP__radioBusy = FALSE;



  if (IPDispatchP__state == IPDispatchP__S_STOPPING) {
      IPDispatchP__RadioControl__stop();
      IPDispatchP__state = IPDispatchP__S_STOPPED;
      goto done;
    }

  s_entry->info->link_transmissions += IPDispatchP__PacketLink__getRetries(msg);


  if (!IPDispatchP__PacketLink__wasDelivered(msg)) {
      {
#line 606
        sprintf(debugbuf, "sendDone: was not delivered! (%i tries)\n", IPDispatchP__PacketLink__getRetries(msg));
#line 606
        writedebug();
      }
#line 606
      ;

      s_entry->info->failed = TRUE;
    }





  done: 

    if (-- s_entry->info->refcount == 0) {
#line 617
      IPDispatchP__SendInfoPool__put(s_entry->info);
      }
#line 618
  IPDispatchP__FragPool__put(s_entry->msg);
  IPDispatchP__SendEntryPool__put(s_entry);
  IPDispatchP__SendQueue__dequeue();

  IPDispatchP__sendTask__postTask();
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void CC2420TinyosNetworkP__BareSend__sendDone(message_t * msg, error_t error){
#line 89
  IPDispatchP__Ieee154Send__sendDone(msg, error);
#line 89
}
#line 89
# 254 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline void CC2420TinyosNetworkP__ActiveSend__default__sendDone(message_t *msg, error_t error)
#line 254
{
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void CC2420TinyosNetworkP__ActiveSend__sendDone(message_t * msg, error_t error){
#line 89
  CC2420TinyosNetworkP__ActiveSend__default__sendDone(msg, error);
#line 89
}
#line 89
# 152 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline void CC2420TinyosNetworkP__SubSend__sendDone(message_t *msg, error_t error)
#line 152
{
  if (CC2420TinyosNetworkP__CC2420Packet__getNetwork(msg) == 0x3f) {
      CC2420TinyosNetworkP__ActiveSend__sendDone(msg, error);
    }
  else 
#line 155
    {
      CC2420TinyosNetworkP__BareSend__sendDone(msg, error);
    }
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void UniqueSendP__Send__sendDone(message_t * msg, error_t error){
#line 89
  CC2420TinyosNetworkP__SubSend__sendDone(msg, error);
#line 89
}
#line 89
# 104 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline void UniqueSendP__SubSend__sendDone(message_t *msg, error_t error)
#line 104
{
  UniqueSendP__State__toIdle();
  UniqueSendP__Send__sendDone(msg, error);
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static void PacketLinkP__Send__sendDone(message_t * msg, error_t error){
#line 89
  UniqueSendP__SubSend__sendDone(msg, error);
#line 89
}
#line 89
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 84 "UDPEchoP.nc"
static inline void UDPEchoP__RadioControl__stopDone(error_t e)
#line 84
{
}

# 117 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static void IPDispatchP__SplitControl__stopDone(error_t error){
#line 117
  UDPEchoP__RadioControl__stopDone(error);
#line 117
}
#line 117
# 210 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__RadioControl__stopDone(error_t error)
#line 210
{
  IPDispatchP__SplitControl__stopDone(error);
}

# 117 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static void CC2420CsmaP__SplitControl__stopDone(error_t error){
#line 117
  IPDispatchP__RadioControl__stopDone(error);
#line 117
}
#line 117
# 265 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__stopDone_task__runTask(void )
#line 265
{
  CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_STOPPED);
  CC2420CsmaP__SplitControl__stopDone(SUCCESS);
}

# 80 "UDPEchoP.nc"
static inline void UDPEchoP__RadioControl__startDone(error_t e)
#line 80
{
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static void IPDispatchP__SplitControl__startDone(error_t error){
#line 92
  UDPEchoP__RadioControl__startDone(error);
#line 92
}
#line 92
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void IPDispatchP__ExpireTimer__startPeriodic(uint32_t dt){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startPeriodic(3U, dt);
#line 53
}
#line 53
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__toggle(void )
#line 47
{
#line 47
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 47
    * (volatile uint8_t * )29U ^= 0x01 << 7;
#line 47
    __nesc_atomic_end(__nesc_atomic); }
}

# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__toggle(void ){
#line 44
  /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP__31__IO__toggle();
#line 44
}
#line 44
# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__toggle(void )
#line 39
{
#line 39
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__HplGeneralIO__toggle();
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void LedsP__Led2__toggle(void ){
#line 31
  /*PlatformLedsC.Led2Impl*/Msp430GpioC__2__GeneralIO__toggle();
#line 31
}
#line 31
# 103 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/LedsP.nc"
static inline void LedsP__Leds__led2Toggle(void )
#line 103
{
  LedsP__Led2__toggle();
  ;
#line 105
  ;
}

# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
inline static void IPDispatchP__Leds__led2Toggle(void ){
#line 89
  LedsP__Leds__led2Toggle();
#line 89
}
#line 89
# 195 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__RadioControl__startDone(error_t error)
#line 195
{




  if (error == SUCCESS) {
      IPDispatchP__Leds__led2Toggle();
      IPDispatchP__ExpireTimer__startPeriodic(FRAG_EXPIRE_TIME);
      IPDispatchP__state = IPDispatchP__S_RUNNING;
      IPDispatchP__radioBusy = FALSE;
    }

  IPDispatchP__SplitControl__startDone(error);
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static void CC2420CsmaP__SplitControl__startDone(error_t error){
#line 92
  IPDispatchP__RadioControl__startDone(error);
#line 92
}
#line 92
# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420ControlP__SpiResource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP__Resource__release(/*CC2420ControlC.Spi*/CC2420SpiC__0__CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 186 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__Resource__release(void )
#line 186
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 187
    {
      CC2420ControlP__CSN__set();
      {
        unsigned char __nesc_temp = 
#line 189
        CC2420ControlP__SpiResource__release();

        {
#line 189
          __nesc_atomic_end(__nesc_atomic); 
#line 189
          return __nesc_temp;
        }
      }
    }
#line 192
    __nesc_atomic_end(__nesc_atomic); }
}

# 110 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static error_t CC2420CsmaP__Resource__release(void ){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420ControlP__Resource__release();
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 256 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__CC2420Power__rxOn(void )
#line 256
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 257
    {
      if (CC2420ControlP__m_state != CC2420ControlP__S_XOSC_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 259
            FAIL;

            {
#line 259
              __nesc_atomic_end(__nesc_atomic); 
#line 259
              return __nesc_temp;
            }
          }
        }
#line 261
      CC2420ControlP__SRXON__strobe();
    }
#line 262
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 90 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static error_t CC2420CsmaP__CC2420Power__rxOn(void ){
#line 90
  unsigned char result;
#line 90

#line 90
  result = CC2420ControlP__CC2420Power__rxOn();
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port10__enable(void )
#line 75
{
#line 75
  P1IE |= 1 << 0;
}

# 31 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__enable(void ){
#line 31
  HplMsp430InterruptP__Port10__enable();
#line 31
}
#line 31
# 107 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port10__edge(bool l2h)
#line 107
{
  /* atomic removed: atomic calls only */
#line 108
  {
    if (l2h) {
#line 109
      P1IES &= ~(1 << 0);
      }
    else {
#line 110
      P1IES |= 1 << 0;
      }
  }
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__edge(bool low_to_high){
#line 56
  HplMsp430InterruptP__Port10__edge(low_to_high);
#line 56
}
#line 56
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__enable(bool rising)
#line 41
{
  /* atomic removed: atomic calls only */
#line 42
  {
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__disable();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__edge(rising);
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__enable();
  }
  return SUCCESS;
}





static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__enableFallingEdge(void )
#line 54
{
  return /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__enable(FALSE);
}

# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static error_t CC2420ReceiveP__InterruptFIFOP__enableFallingEdge(void ){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__enableFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 157 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline error_t CC2420ReceiveP__StdControl__start(void )
#line 157
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 158
    {
      CC2420ReceiveP__reset_state();
      CC2420ReceiveP__m_state = CC2420ReceiveP__S_STARTED;
      CC2420ReceiveP__receivingPacket = FALSE;




      CC2420ReceiveP__InterruptFIFOP__enableFallingEdge();
    }
#line 167
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 168 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP__StdControl__start(void )
#line 168
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 169
    {
      CC2420TransmitP__CaptureSFD__captureRisingEdge();
      CC2420TransmitP__m_state = CC2420TransmitP__S_STARTED;
      CC2420TransmitP__m_receiving = FALSE;
      CC2420TransmitP__abortSpiRelease = FALSE;
      CC2420TransmitP__m_tx_power = 0;
    }
#line 175
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static error_t CC2420CsmaP__SubControl__start(void ){
#line 74
  unsigned char result;
#line 74

#line 74
  result = CC2420TransmitP__StdControl__start();
#line 74
  result = ecombine(result, CC2420ReceiveP__StdControl__start());
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 257 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__startDone_task__runTask(void )
#line 257
{
  CC2420CsmaP__SubControl__start();
  CC2420CsmaP__CC2420Power__rxOn();
  CC2420CsmaP__Resource__release();
  CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_STARTED);
  CC2420CsmaP__SplitControl__startDone(SUCCESS);
}

# 100 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline uint8_t CC2420TinyosNetworkP__BarePacket__payloadLength(message_t *msg)
#line 100
{
  cc2420_header_t *hdr = CC2420TinyosNetworkP__CC2420PacketBody__getHeader(msg);

#line 102
  return __nesc_ntoh_leuint8(hdr->length.data) + 1 - MAC_FOOTER_SIZE;
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static uint8_t IPDispatchP__BarePacket__payloadLength(message_t * msg){
#line 67
  unsigned char result;
#line 67

#line 67
  result = CC2420TinyosNetworkP__BarePacket__payloadLength(msg);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 251 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint8_t __nesc_hton_leuint8(void * target, uint8_t value)
#line 251
{
  uint8_t *base = target;

#line 253
  base[0] = value;
  return value;
}

# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static error_t PacketLinkP__SendState__requestState(uint8_t reqState){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP__State__requestState(4U, reqState);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 130 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline error_t PacketLinkP__Send__send(message_t *msg, uint8_t len)
#line 130
{
  error_t error;

#line 132
  if (PacketLinkP__SendState__requestState(PacketLinkP__S_SENDING) == SUCCESS) {

      PacketLinkP__currentSendMsg = msg;
      PacketLinkP__currentSendLen = len;
      PacketLinkP__totalRetries = 0;

      if (PacketLinkP__PacketLink__getRetries(msg) > 0) {
          PacketLinkP__PacketAcknowledgements__requestAck(msg);
        }

      if ((error = PacketLinkP__SubSend__send(msg, len)) != SUCCESS) {
          PacketLinkP__SendState__toIdle();
        }

      return error;
    }
  return EBUSY;
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static error_t UniqueSendP__SubSend__send(message_t * msg, uint8_t len){
#line 64
  unsigned char result;
#line 64

#line 64
  result = PacketLinkP__Send__send(msg, len);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 42 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static cc2420_header_t * UniqueSendP__CC2420PacketBody__getHeader(message_t * msg){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP__CC2420PacketBody__getHeader(msg);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static error_t UniqueSendP__State__requestState(uint8_t reqState){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP__State__requestState(2U, reqState);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 75 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline error_t UniqueSendP__Send__send(message_t *msg, uint8_t len)
#line 75
{
  error_t error;

#line 77
  if (UniqueSendP__State__requestState(UniqueSendP__S_SENDING) == SUCCESS) {
      __nesc_hton_leuint8(UniqueSendP__CC2420PacketBody__getHeader(msg)->dsn.data, UniqueSendP__localSendId++);

      if ((error = UniqueSendP__SubSend__send(msg, len)) != SUCCESS) {
          UniqueSendP__State__toIdle();
        }

      return error;
    }

  return EBUSY;
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static error_t CC2420TinyosNetworkP__SubSend__send(message_t * msg, uint8_t len){
#line 64
  unsigned char result;
#line 64

#line 64
  result = UniqueSendP__Send__send(msg, len);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 118 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline error_t CC2420TinyosNetworkP__BareSend__send(message_t *msg, uint8_t len)
#line 118
{










  CC2420TinyosNetworkP__BarePacket__setPayloadLength(msg, len);

  return CC2420TinyosNetworkP__SubSend__send(msg, 0);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static error_t IPDispatchP__Ieee154Send__send(message_t * msg, uint8_t len){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420TinyosNetworkP__BareSend__send(msg, len);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 269 "/stow/repository/nesc-1.3.0/lib/ncc/nesc_nx.h"
static __inline  uint16_t __nesc_hton_uint16(void * target, uint16_t value)
#line 269
{
  uint8_t *base = target;

#line 271
  base[1] = value;
  base[0] = value >> 8;
  return value;
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline void PacketLinkP__PacketLink__setRetryDelay(message_t *msg, uint16_t retryDelay)
#line 97
{
  __nesc_hton_uint16(PacketLinkP__CC2420PacketBody__getMetadata(msg)->retryDelay.data, retryDelay);
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static void IPDispatchP__PacketLink__setRetryDelay(message_t *msg, uint16_t retryDelay){
#line 53
  PacketLinkP__PacketLink__setRetryDelay(msg, retryDelay);
#line 53
}
#line 53
# 88 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline void PacketLinkP__PacketLink__setRetries(message_t *msg, uint16_t maxRetries)
#line 88
{
  __nesc_hton_uint16(PacketLinkP__CC2420PacketBody__getMetadata(msg)->maxRetries.data, maxRetries);
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static void IPDispatchP__PacketLink__setRetries(message_t * msg, uint16_t maxRetries){
#line 46
  PacketLinkP__PacketLink__setRetries(msg, maxRetries);
#line 46
}
#line 46
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline bool /*IPDispatchC.QueueC*/QueueC__0__Queue__empty(void )
#line 53
{
  return /*IPDispatchC.QueueC*/QueueC__0__size == 0;
}

# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static bool IPDispatchP__SendQueue__empty(void ){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*IPDispatchC.QueueC*/QueueC__0__Queue__empty();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 439 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__sendTask__runTask(void )
#line 439
{
  error_t rv = SUCCESS;
  send_entry_t *s_entry;



  if (IPDispatchP__radioBusy || IPDispatchP__state != IPDispatchP__S_RUNNING) {
#line 445
    return;
    }
#line 446
  if (IPDispatchP__SendQueue__empty()) {
#line 446
    return;
    }
  s_entry = IPDispatchP__SendQueue__head();

  IPDispatchP__PacketLink__setRetries(s_entry->msg, 3);
  IPDispatchP__PacketLink__setRetryDelay(s_entry->msg, 103);





  if (s_entry->info->failed) {
      ;
      goto fail;
    }



  if (
#line 463
  IPDispatchP__Ieee154Send__send(s_entry->msg, 
  IPDispatchP__BarePacket__payloadLength(s_entry->msg)) != SUCCESS) {
      ;
      goto fail;
    }
  else 
#line 467
    {
      IPDispatchP__radioBusy = TRUE;
    }

  return;
  fail: 
    {
#line 473
      sprintf(debugbuf, "SEND FAIL (%i)\n", rv);
#line 473
      writedebug();
    }
#line 473
  ;
  IPDispatchP__sendTask__postTask();
  ;



  s_entry->info->failed = TRUE;
  if (-- s_entry->info->refcount == 0) {
#line 480
    IPDispatchP__SendInfoPool__put(s_entry->info);
    }
#line 481
  IPDispatchP__FragPool__put(s_entry->msg);
  IPDispatchP__SendEntryPool__put(s_entry);
  IPDispatchP__SendQueue__dequeue();
}

# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type t0, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type dt){
#line 92
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__startAt(t0, dt);
#line 92
}
#line 92
# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__start(uint32_t t0, uint32_t dt, bool oneshot)
{
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_dt = dt;
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_oneshot = oneshot;
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__startAt(t0, dt);
}

#line 82
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__startOneShotAt(uint32_t t0, uint32_t dt)
{
#line 83
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__start(t0, dt, TRUE);
}

# 118 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__startOneShotAt(uint32_t t0, uint32_t dt){
#line 118
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__startOneShotAt(t0, dt);
#line 118
}
#line 118
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__stop(void )
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__disableEvents();
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__stop(void ){
#line 62
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Alarm__stop();
#line 62
}
#line 62
# 91 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__stop(void )
{
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__stop();
}

# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__stop(void ){
#line 62
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__stop();
#line 62
}
#line 62
# 60 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__stop(void )
{
#line 61
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__stop();
}

# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__stop(void ){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__stop();
#line 67
}
#line 67
# 89 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__runTask(void )
{




  uint32_t now = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow();
  int32_t min_remaining = (1UL << 31) - 1;
  bool min_remaining_isset = FALSE;
  uint8_t num;

  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__stop();

  for (num = 0; num < /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__m_timers[num];

      if (timer->isrunning) 
        {
          uint32_t elapsed = now - timer->t0;
          int32_t remaining = timer->dt - elapsed;

          if (remaining < min_remaining) 
            {
              min_remaining = remaining;
              min_remaining_isset = TRUE;
            }
        }
    }

  if (min_remaining_isset) 
    {
      if (min_remaining <= 0) {
        /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__fireTimers(now);
        }
      else {
#line 124
        /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__startOneShotAt(now, min_remaining);
        }
    }
}

# 16 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static error_t UDPEchoP__Status__sendto(struct sockaddr_in6 *dest, void *payload, uint16_t len){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP__UDP__sendto(1U, dest, payload, len);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 177 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static inline void UdpP__Statistics__get(udp_statistics_t *buf)
#line 177
{
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
inline static void UDPEchoP__UDPStats__get(UDPEchoP__UDPStats__stat_str *stats){
#line 29
  UdpP__Statistics__get(stats);
#line 29
}
#line 29
# 643 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__Statistics__get(ip_statistics_t *statistics)
#line 643
{
#line 657
  ip_memcpy((uint8_t *)statistics, (uint8_t *)&IPDispatchP__stats, sizeof(ip_statistics_t ));
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
inline static void UDPEchoP__IPStats__get(UDPEchoP__IPStats__stat_str *stats){
#line 29
  IPDispatchP__Statistics__get(stats);
#line 29
}
#line 29
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void UDPEchoP__StatusTimer__startPeriodic(uint32_t dt){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startPeriodic(0U, dt);
#line 53
}
#line 53
# 105 "UDPEchoP.nc"
static inline void UDPEchoP__StatusTimer__fired(void )
#line 105
{
  unsigned int __nesc_temp43;
  unsigned char *__nesc_temp42;

#line 107
  if (!UDPEchoP__timerStarted) {
      UDPEchoP__StatusTimer__startPeriodic(1024 * 75L);
      UDPEchoP__timerStarted = TRUE;
    }

  (__nesc_temp42 = UDPEchoP__stats.seqno.data, __nesc_hton_uint16(__nesc_temp42, (__nesc_temp43 = __nesc_ntoh_uint16(__nesc_temp42)) + 1), __nesc_temp43);
  __nesc_hton_uint16(UDPEchoP__stats.sender.data, TOS_NODE_ID);

  UDPEchoP__IPStats__get(& UDPEchoP__stats.ip);
  UDPEchoP__UDPStats__get(& UDPEchoP__stats.udp);



  UDPEchoP__Status__sendto(&UDPEchoP__route_dest, &UDPEchoP__stats, sizeof UDPEchoP__stats);
}

# 202 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static inline void PacketLinkP__DelayTimer__fired(void )
#line 202
{
  if (PacketLinkP__SendState__getState() == PacketLinkP__S_SENDING) {
      PacketLinkP__send__postTask();
    }
}

# 296 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__ip_print_heap(void )
#line 296
{

  bndrt_t *cur = (bndrt_t *)heap;

#line 299
  while ((uint8_t *)cur - heap < 1500) {
      {
#line 300
        sprintf(debugbuf, "heap region start: 0x%x length: %i used: %i\n", cur, *cur & 0x0fff, (*cur & 0x8000) >> 15);
#line 300
        writedebug();
      }
#line 300
      ;

      cur = (bndrt_t *)((uint8_t *)cur + (*cur & 0x0fff));
    }
}

# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static uint8_t IPDispatchP__SendQueue__size(void ){
#line 58
  unsigned char result;
#line 58

#line 58
  result = /*IPDispatchC.QueueC*/QueueC__0__Queue__size();
#line 58

#line 58
  return result;
#line 58
}
#line 58
# 79 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__size(void )
#line 79
{
  ;
  return /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free;
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static uint8_t IPDispatchP__SendEntryPool__size(void ){
#line 72
  unsigned char result;
#line 72

#line 72
  result = /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__size();
#line 72

#line 72
  return result;
#line 72
}
#line 72
# 79 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__size(void )
#line 79
{
  ;
  return /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free;
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static uint8_t IPDispatchP__SendInfoPool__size(void ){
#line 72
  unsigned char result;
#line 72

#line 72
  result = /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__size();
#line 72

#line 72
  return result;
#line 72
}
#line 72
# 79 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__size(void )
#line 79
{
  ;
  return /*IPDispatchC.FragPool.PoolP*/PoolP__0__free;
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static uint8_t IPDispatchP__FragPool__size(void ){
#line 72
  unsigned char result;
#line 72

#line 72
  result = /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__size();
#line 72

#line 72
  return result;
#line 72
}
#line 72
# 271 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__reconstruct_age(void *elt)
#line 271
{
  struct lowpan_reconstruct *recon = (struct lowpan_reconstruct *)elt;

#line 273
  if (recon->r_timeout != T_UNUSED) 
    {
#line 274
      sprintf(debugbuf, "recon src: 0x%x tag: 0x%x buf: %p recvd: %i/%i\n", recon->r_source_key, recon->r_tag, recon->r_buf, recon->r_bytes_rcvd, recon->r_size);
#line 274
      writedebug();
    }
#line 274
  ;


  switch (recon->r_timeout) {
      case T_ACTIVE: 
        recon->r_timeout = T_ZOMBIE;
#line 279
      break;
      case T_FAILED1: 
        recon->r_timeout = T_FAILED2;
#line 281
      break;
      case T_ZOMBIE: 
        case T_FAILED2: 

          {
#line 285
            sprintf(debugbuf, "timing out buffer: src: %i tag: %i\n", recon->r_source_key, recon->r_tag);
#line 285
            writedebug();
          }
#line 285
      ;
      if (recon->r_buf != (void *)0) {
          {
#line 287
            sprintf(debugbuf, "free(%p)\n", recon->r_buf);
#line 287
            writedebug();
          }
#line 287
          ;
          ip_free(recon->r_buf);
        }
      recon->r_timeout = T_UNUSED;
      recon->r_buf = (void *)0;
      break;
    }
}

#line 307
static inline void IPDispatchP__ExpireTimer__fired(void )
#line 307
{
  table_map(&IPDispatchP__recon_cache, IPDispatchP__reconstruct_age);


  {
#line 311
    sprintf(debugbuf, "Frag pool size: %i\n", IPDispatchP__FragPool__size());
#line 311
    writedebug();
  }
#line 311
  ;
  {
#line 312
    sprintf(debugbuf, "SendInfo pool size: %i\n", IPDispatchP__SendInfoPool__size());
#line 312
    writedebug();
  }
#line 312
  ;
  {
#line 313
    sprintf(debugbuf, "SendEntry pool size: %i\n", IPDispatchP__SendEntryPool__size());
#line 313
    writedebug();
  }
#line 313
  ;
  {
#line 314
    sprintf(debugbuf, "Forward queue length: %i\n", IPDispatchP__SendQueue__size());
#line 314
    writedebug();
  }
#line 314
  ;
  IPDispatchP__ip_print_heap();
}

# 193 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__default__fired(uint8_t num)
{
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__fired(uint8_t arg_0x17ae3c8){
#line 72
  switch (arg_0x17ae3c8) {
#line 72
    case 0U:
#line 72
      UDPEchoP__StatusTimer__fired();
#line 72
      break;
#line 72
    case 2U:
#line 72
      PacketLinkP__DelayTimer__fired();
#line 72
      break;
#line 72
    case 3U:
#line 72
      IPDispatchP__ExpireTimer__fired();
#line 72
      break;
#line 72
    default:
#line 72
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__default__fired(arg_0x17ae3c8);
#line 72
      break;
#line 72
    }
#line 72
}
#line 72
# 128 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__fired(void )
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__fireTimers(/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow());
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__fired(void ){
#line 72
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__fired();
#line 72
}
#line 72
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getAlarm(void )
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 82
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type __nesc_temp = 
#line 82
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt;

      {
#line 82
        __nesc_atomic_end(__nesc_atomic); 
#line 82
        return __nesc_temp;
      }
    }
#line 84
    __nesc_atomic_end(__nesc_atomic); }
}

# 105 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getAlarm(void ){
#line 105
  unsigned long result;
#line 105

#line 105
  result = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__getAlarm();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 63 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__runTask(void )
{
  if (/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_oneshot == FALSE) {
    /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__start(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Alarm__getAlarm(), /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__m_dt, FALSE);
    }
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__Timer__fired();
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__CC2int(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3____nesc_unnamed4425 {
#line 46
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__compareControl(void )
{
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__cc_t x = { 
  .cm = 1, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 0, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__CC2int(x);
}

#line 94
static inline void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__setControlAsCompare(void )
{
  * (volatile uint16_t * )386U = /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__compareControl();
}

# 36 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__setControlAsCompare(void ){
#line 36
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Control__setControlAsCompare();
#line 36
}
#line 36
# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Init__init(void )
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__disableEvents();
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Msp430TimerControl__setControlAsCompare();
  return SUCCESS;
}

# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static inline am_group_t ActiveMessageAddressC__ActiveMessageAddress__amGroup(void )
#line 82
{
  am_group_t myGroup;

  /* atomic removed: atomic calls only */
#line 84
  myGroup = ActiveMessageAddressC__group;
  return myGroup;
}

# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static am_group_t CC2420ControlP__ActiveMessageAddress__amGroup(void ){
#line 55
  unsigned char result;
#line 55

#line 55
  result = ActiveMessageAddressC__ActiveMessageAddress__amGroup();
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 95 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static inline am_addr_t ActiveMessageAddressC__amAddress(void )
#line 95
{
  am_addr_t myAddr;

  /* atomic removed: atomic calls only */
#line 97
  myAddr = ActiveMessageAddressC__addr;
  return myAddr;
}

#line 61
static inline am_addr_t ActiveMessageAddressC__ActiveMessageAddress__amAddress(void )
#line 61
{
  return ActiveMessageAddressC__amAddress();
}

# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static am_addr_t CC2420ControlP__ActiveMessageAddress__amAddress(void ){
#line 50
  unsigned int result;
#line 50

#line 50
  result = ActiveMessageAddressC__ActiveMessageAddress__amAddress();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 5;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__VREN__makeOutput(void ){
#line 35
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__makeOutput();
#line 35
}
#line 35
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 6;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__RSTN__makeOutput(void ){
#line 35
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC__7__GeneralIO__makeOutput();
#line 35
}
#line 35
# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__makeOutput(void )
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t * )30U |= 0x01 << 2;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__makeOutput(void ){
#line 71
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__makeOutput();
#line 71
}
#line 71
# 43 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__makeOutput(void )
#line 43
{
#line 43
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__HplGeneralIO__makeOutput();
}

# 35 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__CSN__makeOutput(void ){
#line 35
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__makeOutput();
#line 35
}
#line 35
# 127 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__Init__init(void )
#line 127
{
  CC2420ControlP__CSN__makeOutput();
  CC2420ControlP__RSTN__makeOutput();
  CC2420ControlP__VREN__makeOutput();

  CC2420ControlP__m_short_addr = CC2420ControlP__ActiveMessageAddress__amAddress();
  CC2420ControlP__m_ext_addr = CC2420ControlP__LocalIeeeEui64__getId();
  CC2420ControlP__m_pan = CC2420ControlP__ActiveMessageAddress__amGroup();
  CC2420ControlP__m_tx_power = 31;
  CC2420ControlP__m_channel = 15;





  CC2420ControlP__addressRecognition = TRUE;





  CC2420ControlP__hwAddressRecognition = FALSE;






  CC2420ControlP__autoAckEnabled = TRUE;



  CC2420ControlP__hwAutoAckDefault = TRUE;
  CC2420ControlP__hwAddressRecognition = TRUE;





  return SUCCESS;
}

# 81 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline error_t StateImplP__Init__init(void )
#line 81
{
  int i;

#line 83
  for (i = 0; i < 5U; i++) {
      StateImplP__state[i] = StateImplP__S_IDLE;
    }
  return SUCCESS;
}

# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__Init__init(void )
#line 45
{
  memset(/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__NO_ENTRY, sizeof /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__resQ);
  return SUCCESS;
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__CC2int(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5____nesc_unnamed4426 {
#line 46
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__compareControl(void )
{
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__cc_t x = { 
  .cm = 1, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 0, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__CC2int(x);
}

#line 94
static inline void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__setControlAsCompare(void )
{
  * (volatile uint16_t * )390U = /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__compareControl();
}

# 36 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__setControlAsCompare(void ){
#line 36
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Control__setControlAsCompare();
#line 36
}
#line 36
# 42 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Init__init(void )
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__disableEvents();
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Msp430TimerControl__setControlAsCompare();
  return SUCCESS;
}

# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__makeInput(void )
#line 50
{
  /* atomic removed: atomic calls only */
#line 50
  * (volatile uint8_t * )30U &= ~(0x01 << 1);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__makeInput(void ){
#line 64
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP__25__IO__makeInput();
#line 64
}
#line 64
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__makeInput(void )
#line 41
{
#line 41
  /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__HplGeneralIO__makeInput();
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420TransmitP__SFD__makeInput(void ){
#line 33
  /*HplCC2420PinsC.SFDM*/Msp430GpioC__8__GeneralIO__makeInput();
#line 33
}
#line 33


inline static void CC2420TransmitP__CSN__makeOutput(void ){
#line 35
  /*HplCC2420PinsC.CSNM*/Msp430GpioC__4__GeneralIO__makeOutput();
#line 35
}
#line 35
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__makeInput(void )
#line 50
{
  /* atomic removed: atomic calls only */
#line 50
  * (volatile uint8_t * )34U &= ~(0x01 << 4);
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__makeInput(void ){
#line 64
  /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP__4__IO__makeInput();
#line 64
}
#line 64
# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__makeInput(void )
#line 41
{
#line 41
  /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__HplGeneralIO__makeInput();
}

# 33 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420TransmitP__CCA__makeInput(void ){
#line 33
  /*HplCC2420PinsC.CCAM*/Msp430GpioC__3__GeneralIO__makeInput();
#line 33
}
#line 33
# 160 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP__Init__init(void )
#line 160
{
  CC2420TransmitP__CCA__makeInput();
  CC2420TransmitP__CSN__makeOutput();
  CC2420TransmitP__SFD__makeInput();
  return SUCCESS;
}

# 151 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline error_t CC2420ReceiveP__Init__init(void )
#line 151
{
  CC2420ReceiveP__m_p_rx_buf = &CC2420ReceiveP__m_rx_buf;
  return SUCCESS;
}

# 44 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static inline error_t RandomMlcgC__Init__init(void )
#line 44
{
  /* atomic removed: atomic calls only */
#line 45
  RandomMlcgC__seed = (uint32_t )(TOS_NODE_ID + 1);

  return SUCCESS;
}

# 41 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static uint16_t UniqueSendP__Random__rand16(void ){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC__Random__rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 62 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline error_t UniqueSendP__Init__init(void )
#line 62
{
  UniqueSendP__localSendId = UniqueSendP__Random__rand16();
  return SUCCESS;
}

# 71 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline error_t UniqueReceiveP__Init__init(void )
#line 71
{
  int i;

#line 73
  for (i = 0; i < 4; i++) {
      UniqueReceiveP__receivedMessages[i].source = (am_addr_t )0xFFFF;
      UniqueReceiveP__receivedMessages[i].dsn = 0;
    }
  return SUCCESS;
}

# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline error_t /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__Init__init(void )
#line 45
{
  memset(/*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__resQ, /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__NO_ENTRY, sizeof /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__resQ);
  return SUCCESS;
}

# 65 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Init__init(void )
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__queue[i] = &/*IPDispatchC.FragPool.PoolP*/PoolP__0__pool[i];
    }
  /*IPDispatchC.FragPool.PoolP*/PoolP__0__free = 12;
  /*IPDispatchC.FragPool.PoolP*/PoolP__0__index = 0;
  return SUCCESS;
}

#line 65
static inline error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Init__init(void )
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__queue[i] = &/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool[i];
    }
  /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free = 12;
  /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index = 0;
  return SUCCESS;
}

#line 65
static inline error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Init__init(void )
#line 65
{
  int i;

#line 67
  for (i = 0; i < 3; i++) {
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__queue[i] = &/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool[i];
    }
  /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free = 3;
  /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index = 0;
  return SUCCESS;
}

# 171 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static inline void UdpP__Statistics__clear(void )
#line 171
{
}

#line 50
static inline error_t UdpP__Init__init(void )
#line 50
{
  UdpP__Statistics__clear();
  memset((uint8_t *)UdpP__local_ports, 0, sizeof(uint16_t ) * UdpP__N_CLIENTS);
  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static error_t RealMainP__SoftwareInit__init(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = UdpP__Init__init();
#line 51
  result = ecombine(result, /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Init__init());
#line 51
  result = ecombine(result, /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Init__init());
#line 51
  result = ecombine(result, /*IPDispatchC.FragPool.PoolP*/PoolP__0__Init__init());
#line 51
  result = ecombine(result, /*CC2420TinyosNetworkC.FcfsResourceQueueC*/FcfsResourceQueueC__0__Init__init());
#line 51
  result = ecombine(result, UniqueReceiveP__Init__init());
#line 51
  result = ecombine(result, UniqueSendP__Init__init());
#line 51
  result = ecombine(result, RandomMlcgC__Init__init());
#line 51
  result = ecombine(result, CC2420ReceiveP__Init__init());
#line 51
  result = ecombine(result, CC2420TransmitP__Init__init());
#line 51
  result = ecombine(result, /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC__1__Init__init());
#line 51
  result = ecombine(result, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC__1__Init__init());
#line 51
  result = ecombine(result, StateImplP__Init__init());
#line 51
  result = ecombine(result, CC2420ControlP__Init__init());
#line 51
  result = ecombine(result, /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC__0__Init__init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 10 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static error_t UDPEchoP__Status__bind(uint16_t port){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP__UDP__bind(1U, port);
#line 10

#line 10
  return result;
#line 10
}
#line 10
inline static error_t UDPEchoP__Echo__bind(uint16_t port){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP__UDP__bind(0U, port);
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 87 "/Users/stevedh/src/cvs/tinyos-2.x/tos/platforms/epic/hardware.h"
static inline  void TOSH_SEL_URXD1_MODFUNC()
#line 87
{
#line 87
  static volatile uint8_t r __asm ("0x001B");

#line 87
  r |= 1 << 7;
}

#line 86
static inline  void TOSH_SEL_UTXD1_MODFUNC()
#line 86
{
#line 86
  static volatile uint8_t r __asm ("0x001B");

#line 86
  r |= 1 << 6;
}

# 131 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/PrintfUART.h"
static inline void printfUART_init_private()
{
#line 205
  uint8_t source = 0x20;
  uint16_t baudrate = 0x0012;
  uint8_t mctl = 0x84;




  uint16_t l_br = 0;
  uint8_t l_mctl = 0;
  uint8_t l_ssel = 0;

  TOSH_SEL_UTXD1_MODFUNC();
  TOSH_SEL_URXD1_MODFUNC();


  UCTL1 = 0x01;
  UCTL1 |= 0x10;

  U1RCTL &= ~0x08;

  UCTL1 = 0x01;
  UCTL1 |= 0x10;

  if (l_ssel & 0x80) {
      U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
      U1TCTL |= l_ssel & 0x7F;
    }
  else {
      U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
      U1TCTL |= 0x10;
    }

  if (l_mctl != 0 || l_br != 0) {
      U1BR0 = l_br & 0x0FF;
      U1BR1 = (l_br >> 8) & 0x0FF;
      U1MCTL = l_mctl;
    }
  else {
      U1BR0 = 0x03;
      U1BR1 = 0x00;
      U1MCTL = 0x4A;
    }

  ME2 &= ~(1 << 4);
  ME2 |= (1 << 5) | (1 << 4);

  U1CTL &= ~0x01;

  IFG2 &= ~((1 << 5) | (1 << 4));
  IE2 &= ~((1 << 5) | (1 << 4));





  l_ssel = source | 0x80;
  U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
  U1TCTL |= l_ssel & 0x7F;




  l_br = baudrate;
  l_mctl = mctl;
  U1BR0 = baudrate & 0x0FF;
  U1BR1 = (baudrate >> 8) & 0x0FF;
  U1MCTL = mctl;





  IFG2 &= ~(1 << 4);
  IE2 |= 1 << 4;






  IFG2 &= ~(1 << 5);
  IE2 |= 1 << 5;
}

# 661 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__Statistics__clear(void )
#line 661
{
  memset((uint8_t *)&IPDispatchP__stats, 0, sizeof(ip_statistics_t ));
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/Statistics.nc"
inline static void UDPEchoP__IPStats__clear(void ){
#line 34
  IPDispatchP__Statistics__clear();
#line 34
}
#line 34
# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static error_t IPDispatchP__RadioControl__start(void ){
#line 83
  unsigned char result;
#line 83

#line 83
  result = CC2420CsmaP__SplitControl__start();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 179 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline error_t IPDispatchP__SplitControl__start(void )
#line 179
{
  return IPDispatchP__RadioControl__start();
}

# 83 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static error_t UDPEchoP__RadioControl__start(void ){
#line 83
  unsigned char result;
#line 83

#line 83
  result = IPDispatchP__SplitControl__start();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 60 "UDPEchoP.nc"
static inline void UDPEchoP__Boot__booted(void )
#line 60
{
  UDPEchoP__RadioControl__start();
  UDPEchoP__timerStarted = FALSE;

  UDPEchoP__IPStats__clear();


  {
#line 67
    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 67
      printfUART_init_private();
#line 67
      __nesc_atomic_end(__nesc_atomic); }
  }
#line 67
  ;







  ;
  UDPEchoP__Echo__bind(7);
  UDPEchoP__Status__bind(7001);
}

# 160 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP__reconstruct_clear(void *ent)
#line 160
{
  struct lowpan_reconstruct *recon = (struct lowpan_reconstruct *)ent;

#line 162
  memset((uint8_t *)& recon->r_meta, 0, sizeof(struct ip6_metadata ));
  recon->r_timeout = T_UNUSED;
  recon->r_buf = (void *)0;
}

#line 214
static inline void IPDispatchP__Boot__booted(void )
#line 214
{
  IPDispatchP__Statistics__clear();

  ip_malloc_init();


  table_init(&IPDispatchP__recon_cache, IPDispatchP__recon_data, sizeof(struct lowpan_reconstruct ), N_RECONSTRUCTIONS);
  table_map(&IPDispatchP__recon_cache, IPDispatchP__reconstruct_clear);

  IPDispatchP__SplitControl__start();
}

# 10 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/interfaces/UDP.nc"
inline static error_t UDPShellP__UDP__bind(uint16_t port){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP__UDP__bind(2U, port);
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 288 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline char *UDPShellP__RegisterShellCommand__default__getCommandName(uint8_t cmd_id)
#line 288
{
  return (void *)0;
}

# 3 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/RegisterShellCommand.nc"
inline static char *UDPShellP__RegisterShellCommand__getCommandName(uint8_t arg_0x23fa130){
#line 3
  char *result;
#line 3

#line 3
    result = UDPShellP__RegisterShellCommand__default__getCommandName(arg_0x23fa130);
#line 3

#line 3
  return result;
#line 3
}
#line 3
# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static UDPShellP__Uptime__size_type UDPShellP__Uptime__get(void ){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 81 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP__Boot__booted(void )
#line 81
{
  int i;

#line 83
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      UDPShellP__uptime = 0;

      UDPShellP__boot_time = UDPShellP__Uptime__get();
    }
#line 87
    __nesc_atomic_end(__nesc_atomic); }

  for (i = 0; i < UDPShellP__N_EXTERNAL; i++) {
      UDPShellP__externals[i].c_name[UDPShellP__CMDNAMSIZ - 1] = '\0';
      strncpy(UDPShellP__externals[i].c_name, UDPShellP__RegisterShellCommand__getCommandName(i), UDPShellP__CMDNAMSIZ);
      UDPShellP__externals[i].c_len = strlen(UDPShellP__externals[i].c_name);
    }
  UDPShellP__UDP__bind(2000);
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
inline static void RealMainP__Boot__booted(void ){
#line 49
  UDPShellP__Boot__booted();
#line 49
  IPDispatchP__Boot__booted();
#line 49
  UDPEchoP__Boot__booted();
#line 49
}
#line 49
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static error_t CC2420CsmaP__SplitControlState__requestState(uint8_t reqState){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP__State__requestState(1U, reqState);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static void CC2420ControlP__StartupTimer__start(CC2420ControlP__StartupTimer__size_type dt){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__start(dt);
#line 55
}
#line 55
# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__set(void )
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t * )29U |= 0x01 << 5;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 34 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__set(void ){
#line 34
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP__29__IO__set();
#line 34
}
#line 34
# 37 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline void /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__set(void )
#line 37
{
#line 37
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__HplGeneralIO__set();
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static void CC2420ControlP__VREN__set(void ){
#line 29
  /*HplCC2420PinsC.VRENM*/Msp430GpioC__9__GeneralIO__set();
#line 29
}
#line 29
# 194 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline error_t CC2420ControlP__CC2420Power__startVReg(void )
#line 194
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 195
    {
      if (CC2420ControlP__m_state != CC2420ControlP__S_VREG_STOPPED) {
          {
            unsigned char __nesc_temp = 
#line 197
            FAIL;

            {
#line 197
              __nesc_atomic_end(__nesc_atomic); 
#line 197
              return __nesc_temp;
            }
          }
        }
#line 199
      CC2420ControlP__m_state = CC2420ControlP__S_VREG_STARTING;
    }
#line 200
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP__VREN__set();
  CC2420ControlP__StartupTimer__start(CC2420_TIME_VREN);
  return SUCCESS;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static error_t CC2420CsmaP__CC2420Power__startVReg(void ){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420ControlP__CC2420Power__startVReg();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 206 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  void __nesc_disable_interrupt(void )
{
   __asm volatile ("dint");
   __asm volatile ("nop");}

# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline mcu_power_t Msp430ClockP__McuPowerOverride__lowestState(void )
#line 52
{
  return MSP430_POWER_LPM3;
}

# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
inline static mcu_power_t McuSleepC__McuPowerOverride__lowestState(void ){
#line 54
  unsigned char result;
#line 54

#line 54
  result = Msp430ClockP__McuPowerOverride__lowestState();
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline mcu_power_t McuSleepC__getPowerState(void )
#line 66
{
  mcu_power_t pState = MSP430_POWER_LPM4;









  if ((((((
#line 69
  TA0CCTL0 & 0x0010 || 
  TA0CCTL1 & 0x0010) || 
  TA0CCTL2 & 0x0010) && (
  TA0CTL & (3 << 8)) == 2 << 8) || (
  ME1 & ((1 << 7) | (1 << 6)) && U0TCTL & 0x20)) || (
  ME2 & ((1 << 5) | (1 << 4)) && U1TCTL & 0x20))


   || (U0CTLnr & 0x01 && I2CTCTLnr & 0x20 && 
  I2CDCTLnr & 0x20 && U0CTLnr & 0x04 && U0CTLnr & 0x20)) {


    pState = MSP430_POWER_LPM1;
    }


  if (ADC12CTL0 & 0x0010) {
      if (ADC12CTL1 & (2 << 3)) {

          if (ADC12CTL1 & (1 << 3)) {
            pState = MSP430_POWER_LPM1;
            }
          else {
#line 91
            pState = MSP430_POWER_ACTIVE;
            }
        }
      else {
#line 92
        if (ADC12CTL1 & 0x0400 && (TA0CTL & (3 << 8)) == 2 << 8) {



            pState = MSP430_POWER_LPM1;
          }
        }
    }

  return pState;
}

# 194 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)
#line 194
{
  return m1 < m2 ? m1 : m2;
}

# 104 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline void McuSleepC__computePowerState(void )
#line 104
{
  McuSleepC__powerState = mcombine(McuSleepC__getPowerState(), 
  McuSleepC__McuPowerOverride__lowestState());
}

static inline void McuSleepC__McuSleep__sleep(void )
#line 109
{
  uint16_t temp;

#line 111
  if (McuSleepC__dirty) {
      McuSleepC__computePowerState();
    }

  temp = McuSleepC__msp430PowerBits[McuSleepC__powerState] | 0x0008;
   __asm volatile ("bis  %0, r2" :  : "m"(temp));

   __asm volatile ("" :  :  : "memory");
  __nesc_disable_interrupt();
}

# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
inline static void SchedulerBasicP__McuSleep__sleep(void ){
#line 59
  McuSleepC__McuSleep__sleep();
#line 59
}
#line 59
# 67 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static __inline uint8_t SchedulerBasicP__popTask(void )
{
  if (SchedulerBasicP__m_head != SchedulerBasicP__NO_TASK) 
    {
      uint8_t id = SchedulerBasicP__m_head;

#line 72
      SchedulerBasicP__m_head = SchedulerBasicP__m_next[SchedulerBasicP__m_head];
      if (SchedulerBasicP__m_head == SchedulerBasicP__NO_TASK) 
        {
          SchedulerBasicP__m_tail = SchedulerBasicP__NO_TASK;
        }
      SchedulerBasicP__m_next[id] = SchedulerBasicP__NO_TASK;
      return id;
    }
  else 
    {
      return SchedulerBasicP__NO_TASK;
    }
}

#line 138
static inline void SchedulerBasicP__Scheduler__taskLoop(void )
{
  for (; ; ) 
    {
      uint8_t nextTask;

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
        {
          while ((nextTask = SchedulerBasicP__popTask()) == SchedulerBasicP__NO_TASK) 
            {
              SchedulerBasicP__McuSleep__sleep();
            }
        }
#line 150
        __nesc_atomic_end(__nesc_atomic); }
      SchedulerBasicP__TaskBasic__runTask(nextTask);
    }
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static void RealMainP__Scheduler__taskLoop(void ){
#line 61
  SchedulerBasicP__Scheduler__taskLoop();
#line 61
}
#line 61
# 212 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline void CC2420ReceiveP__InterruptFIFOP__fired(void )
#line 212
{
  if (CC2420ReceiveP__m_state == CC2420ReceiveP__S_STARTED) {

      CC2420ReceiveP__m_state = CC2420ReceiveP__S_RX_LENGTH;
      CC2420ReceiveP__beginReceive();
    }
  else 



    {
      CC2420ReceiveP__m_missed_packets++;
    }
}

# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__fired(void ){
#line 57
  CC2420ReceiveP__InterruptFIFOP__fired();
#line 57
}
#line 57
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__fired(void )
#line 66
{
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__clear();
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__Interrupt__fired();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port10__fired(void ){
#line 61
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC__1__HplInterrupt__fired();
#line 61
}
#line 61
# 92 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port11__clear(void )
#line 92
{
#line 92
  P1IFG &= ~(1 << 1);
}

#line 68
static inline void HplMsp430InterruptP__Port11__default__fired(void )
#line 68
{
#line 68
  HplMsp430InterruptP__Port11__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port11__fired(void ){
#line 61
  HplMsp430InterruptP__Port11__default__fired();
#line 61
}
#line 61
# 93 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port12__clear(void )
#line 93
{
#line 93
  P1IFG &= ~(1 << 2);
}

#line 69
static inline void HplMsp430InterruptP__Port12__default__fired(void )
#line 69
{
#line 69
  HplMsp430InterruptP__Port12__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port12__fired(void ){
#line 61
  HplMsp430InterruptP__Port12__default__fired();
#line 61
}
#line 61
# 94 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port13__clear(void )
#line 94
{
#line 94
  P1IFG &= ~(1 << 3);
}

#line 70
static inline void HplMsp430InterruptP__Port13__default__fired(void )
#line 70
{
#line 70
  HplMsp430InterruptP__Port13__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port13__fired(void ){
#line 61
  HplMsp430InterruptP__Port13__default__fired();
#line 61
}
#line 61
# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static error_t CC2420CsmaP__startDone_task__postTask(void ){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP__TaskBasic__postTask(CC2420CsmaP__startDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 218 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP__CC2420Power__startOscillatorDone(void )
#line 218
{
  CC2420CsmaP__startDone_task__postTask();
}

# 76 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static void CC2420ControlP__CC2420Power__startOscillatorDone(void ){
#line 76
  CC2420CsmaP__CC2420Power__startOscillatorDone();
#line 76
}
#line 76
# 50 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static error_t CC2420ControlP__InterruptCCA__disable(void ){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__disable();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 429 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline void CC2420ControlP__InterruptCCA__fired(void )
#line 429
{
  CC2420ControlP__m_state = CC2420ControlP__S_XOSC_STARTED;
  CC2420ControlP__InterruptCCA__disable();
  CC2420ControlP__IOCFG1__write(0);
  CC2420ControlP__writeId();
  CC2420ControlP__CSN__set();
  CC2420ControlP__CSN__clr();
  CC2420ControlP__CC2420Power__startOscillatorDone();
}

# 57 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__fired(void ){
#line 57
  CC2420ControlP__InterruptCCA__fired();
#line 57
}
#line 57
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__fired(void )
#line 66
{
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__clear();
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__Interrupt__fired();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port14__fired(void ){
#line 61
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC__0__HplInterrupt__fired();
#line 61
}
#line 61
# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port15__clear(void )
#line 96
{
#line 96
  P1IFG &= ~(1 << 5);
}

#line 72
static inline void HplMsp430InterruptP__Port15__default__fired(void )
#line 72
{
#line 72
  HplMsp430InterruptP__Port15__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port15__fired(void ){
#line 61
  HplMsp430InterruptP__Port15__default__fired();
#line 61
}
#line 61
# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port16__clear(void )
#line 97
{
#line 97
  P1IFG &= ~(1 << 6);
}

#line 73
static inline void HplMsp430InterruptP__Port16__default__fired(void )
#line 73
{
#line 73
  HplMsp430InterruptP__Port16__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port16__fired(void ){
#line 61
  HplMsp430InterruptP__Port16__default__fired();
#line 61
}
#line 61
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port17__clear(void )
#line 98
{
#line 98
  P1IFG &= ~(1 << 7);
}

#line 74
static inline void HplMsp430InterruptP__Port17__default__fired(void )
#line 74
{
#line 74
  HplMsp430InterruptP__Port17__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port17__fired(void ){
#line 61
  HplMsp430InterruptP__Port17__default__fired();
#line 61
}
#line 61
# 195 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port20__clear(void )
#line 195
{
#line 195
  P2IFG &= ~(1 << 0);
}

#line 171
static inline void HplMsp430InterruptP__Port20__default__fired(void )
#line 171
{
#line 171
  HplMsp430InterruptP__Port20__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port20__fired(void ){
#line 61
  HplMsp430InterruptP__Port20__default__fired();
#line 61
}
#line 61
# 196 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port21__clear(void )
#line 196
{
#line 196
  P2IFG &= ~(1 << 1);
}

#line 172
static inline void HplMsp430InterruptP__Port21__default__fired(void )
#line 172
{
#line 172
  HplMsp430InterruptP__Port21__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port21__fired(void ){
#line 61
  HplMsp430InterruptP__Port21__default__fired();
#line 61
}
#line 61
# 197 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port22__clear(void )
#line 197
{
#line 197
  P2IFG &= ~(1 << 2);
}

#line 173
static inline void HplMsp430InterruptP__Port22__default__fired(void )
#line 173
{
#line 173
  HplMsp430InterruptP__Port22__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port22__fired(void ){
#line 61
  HplMsp430InterruptP__Port22__default__fired();
#line 61
}
#line 61
# 198 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port23__clear(void )
#line 198
{
#line 198
  P2IFG &= ~(1 << 3);
}

#line 174
static inline void HplMsp430InterruptP__Port23__default__fired(void )
#line 174
{
#line 174
  HplMsp430InterruptP__Port23__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port23__fired(void ){
#line 61
  HplMsp430InterruptP__Port23__default__fired();
#line 61
}
#line 61
# 199 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port24__clear(void )
#line 199
{
#line 199
  P2IFG &= ~(1 << 4);
}

#line 175
static inline void HplMsp430InterruptP__Port24__default__fired(void )
#line 175
{
#line 175
  HplMsp430InterruptP__Port24__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port24__fired(void ){
#line 61
  HplMsp430InterruptP__Port24__default__fired();
#line 61
}
#line 61
# 200 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port25__clear(void )
#line 200
{
#line 200
  P2IFG &= ~(1 << 5);
}

#line 176
static inline void HplMsp430InterruptP__Port25__default__fired(void )
#line 176
{
#line 176
  HplMsp430InterruptP__Port25__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port25__fired(void ){
#line 61
  HplMsp430InterruptP__Port25__default__fired();
#line 61
}
#line 61
# 201 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port26__clear(void )
#line 201
{
#line 201
  P2IFG &= ~(1 << 6);
}

#line 177
static inline void HplMsp430InterruptP__Port26__default__fired(void )
#line 177
{
#line 177
  HplMsp430InterruptP__Port26__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port26__fired(void ){
#line 61
  HplMsp430InterruptP__Port26__default__fired();
#line 61
}
#line 61
# 202 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline void HplMsp430InterruptP__Port27__clear(void )
#line 202
{
#line 202
  P2IFG &= ~(1 << 7);
}

#line 178
static inline void HplMsp430InterruptP__Port27__default__fired(void )
#line 178
{
#line 178
  HplMsp430InterruptP__Port27__clear();
}

# 61 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static void HplMsp430InterruptP__Port27__fired(void ){
#line 61
  HplMsp430InterruptP__Port27__default__fired();
#line 61
}
#line 61
# 88 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__userId(void ){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__userId();
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 195 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__rxDone(uint8_t data)
#line 195
{
}

# 65 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__rxDone(uint8_t id, uint8_t data)
#line 65
{
}

# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__rxDone(uint8_t arg_0x1e60288, uint8_t data){
#line 54
  switch (arg_0x1e60288) {
#line 54
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID:
#line 54
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__rxDone(data);
#line 54
      break;
#line 54
    default:
#line 54
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__rxDone(arg_0x1e60288, data);
#line 54
      break;
#line 54
    }
#line 54
}
#line 54
# 80 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__inUse(void ){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__inUse();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__rxDone(uint8_t data)
#line 54
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__rxDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__userId(), data);
    }
}

# 54 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static void HplMsp430Usart0P__Interrupts__rxDone(uint8_t data){
#line 54
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__rxDone(data);
#line 54
}
#line 54
# 55 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
static inline bool HplMsp430I2C0P__HplI2C__isI2C(void )
#line 55
{
  /* atomic removed: atomic calls only */
#line 56
  {
    unsigned char __nesc_temp = 
#line 56
    HplMsp430I2C0P__U0CTL & 0x20 && HplMsp430I2C0P__U0CTL & 0x04 && HplMsp430I2C0P__U0CTL & 0x01;

#line 56
    return __nesc_temp;
  }
}

# 6 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
inline static bool HplMsp430Usart0P__HplI2C__isI2C(void ){
#line 6
  unsigned char result;
#line 6

#line 6
  result = HplMsp430I2C0P__HplI2C__isI2C();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 66 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__default__fired(uint8_t id)
#line 66
{
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__fired(uint8_t arg_0x1e60b08){
#line 39
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__default__fired(arg_0x1e60b08);
#line 39
}
#line 39
# 59 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawI2CInterrupts__fired(void )
#line 59
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__I2CInterrupts__fired(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__userId());
    }
}

# 39 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static void HplMsp430Usart0P__I2CInterrupts__fired(void ){
#line 39
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawI2CInterrupts__fired();
#line 39
}
#line 39
# 194 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__txDone(void )
#line 194
{
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__txDone(uint8_t id)
#line 64
{
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__txDone(uint8_t arg_0x1e60288){
#line 49
  switch (arg_0x1e60288) {
#line 49
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C__0__CLIENT_ID:
#line 49
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__UsartInterrupts__txDone();
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__default__txDone(arg_0x1e60288);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__txDone(void )
#line 49
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__Interrupts__txDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__ArbiterInfo__userId());
    }
}

# 49 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static void HplMsp430Usart0P__Interrupts__txDone(void ){
#line 49
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP__0__RawInterrupts__txDone();
#line 49
}
#line 49
# 98 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaControlP.nc"
static inline void Msp430DmaControlP__HplChannel2__transferDone(error_t error)
#line 98
{
}

# 188 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__transferDone(error_t error)
#line 188
{
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__transferDone(error_t success){
#line 96
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__transferDone(success);
#line 96
}
#line 96
# 143 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline void /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__transferDone(error_t error)
#line 143
{
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__Channel__transferDone(error);
}

# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__transferDone(error_t success){
#line 74
  /*Msp430DmaC.Channel2P*/Msp430DmaChannelP__2__HplChannel__transferDone(success);
#line 74
  Msp430DmaControlP__HplChannel2__transferDone(success);
#line 74
}
#line 74
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__Interrupt__fired(void )
#line 82
{
  error_t error = * (volatile uint16_t *)496U & 0x0002 ? FAIL : SUCCESS;

#line 84
  if (* (volatile uint16_t *)496U & 0x0008) {
      * (volatile uint16_t *)496U &= ~0x0008;
      * (volatile uint16_t *)496U &= ~0x0002;
      /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__DMA__transferDone(error);
    }
}

# 97 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaControlP.nc"
static inline void Msp430DmaControlP__HplChannel1__transferDone(error_t error)
#line 97
{
}

# 184 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static inline void /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__transferDone(error_t error)
#line 184
{
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone(error);
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__transferDone(error_t success){
#line 96
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__transferDone(success);
#line 96
}
#line 96
# 143 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline void /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__transferDone(error_t error)
#line 143
{
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__Channel__transferDone(error);
}

# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__transferDone(error_t success){
#line 74
  /*Msp430DmaC.Channel1P*/Msp430DmaChannelP__1__HplChannel__transferDone(success);
#line 74
  Msp430DmaControlP__HplChannel1__transferDone(success);
#line 74
}
#line 74
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__Interrupt__fired(void )
#line 82
{
  error_t error = * (volatile uint16_t *)488U & 0x0002 ? FAIL : SUCCESS;

#line 84
  if (* (volatile uint16_t *)488U & 0x0008) {
      * (volatile uint16_t *)488U &= ~0x0008;
      * (volatile uint16_t *)488U &= ~0x0002;
      /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__DMA__transferDone(error);
    }
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaControlP.nc"
static inline void Msp430DmaControlP__HplChannel0__transferDone(error_t error)
#line 96
{
}

# 147 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__default__transferDone(error_t error)
#line 147
{
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannel.nc"
inline static void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__transferDone(error_t success){
#line 96
  /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__default__transferDone(success);
#line 96
}
#line 96
# 143 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/Msp430DmaChannelP.nc"
static inline void /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__HplChannel__transferDone(error_t error)
#line 143
{
  /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__Channel__transferDone(error);
}

# 74 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaChannel.nc"
inline static void /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__DMA__transferDone(error_t success){
#line 74
  /*Msp430DmaC.Channel0P*/Msp430DmaChannelP__0__HplChannel__transferDone(success);
#line 74
  Msp430DmaControlP__HplChannel0__transferDone(success);
#line 74
}
#line 74
# 82 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaXP.nc"
static inline void /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__Interrupt__fired(void )
#line 82
{
  error_t error = * (volatile uint16_t *)480U & 0x0002 ? FAIL : SUCCESS;

#line 84
  if (* (volatile uint16_t *)480U & 0x0008) {
      * (volatile uint16_t *)480U &= ~0x0008;
      * (volatile uint16_t *)480U &= ~0x0002;
      /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__DMA__transferDone(error);
    }
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaInterrupt.nc"
inline static void HplMsp430DmaP__Interrupt__fired(void ){
#line 28
  /*HplMsp430DmaC.Dma0*/HplMsp430DmaXP__0__Interrupt__fired();
#line 28
  /*HplMsp430DmaC.Dma1*/HplMsp430DmaXP__1__Interrupt__fired();
#line 28
  /*HplMsp430DmaC.Dma2*/HplMsp430DmaXP__2__Interrupt__fired();
#line 28
}
#line 28
# 109 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP__action_help(int argc, char **argv)
#line 109
{
  int i = 0;
  char *pos = UDPShellP__reply_buf;

#line 112
  UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__help_str, strlen(UDPShellP__help_str));
  if (UDPShellP__N_EXTERNAL > 0) {
      strcpy(pos, "\t\t[");
      pos += 3;
      for (i = 0; i < UDPShellP__N_EXTERNAL; i++) {
          if (UDPShellP__externals[i].c_len + 4 < MAX_REPLY_LEN - (pos - UDPShellP__reply_buf)) {
              ip_memcpy((uint8_t *)pos, (uint8_t *)UDPShellP__externals[i].c_name, UDPShellP__externals[i].c_len);
              pos += UDPShellP__externals[i].c_len;
              if (i < UDPShellP__N_EXTERNAL - 1) {
                  pos[0] = ',';
                  pos[1] = ' ';
                  pos += 2;
                }
            }
          else 
#line 125
            {
              pos[0] = '.';
              pos[1] = '.';
              pos[2] = '.';
              pos += 3;
              break;
            }
        }
      * pos++ = ']';
      * pos++ = '\n';
      UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__reply_buf, pos - UDPShellP__reply_buf);
    }
}

#line 188
static inline void UDPShellP__action_ident(int argc, char **argv)
#line 188
{
  UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__ident_string, strlen(UDPShellP__ident_string));
}

# 226 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
  __nesc_atomic_t __nesc_atomic_start(void )
{
  __nesc_atomic_t result = (({
#line 228
    uint16_t __x;

#line 228
     __asm volatile ("mov	r2, %0" : "=r"((uint16_t )__x));__x;
  }
  )
#line 228
   & 0x0008) != 0;

#line 229
  __nesc_disable_interrupt();
   __asm volatile ("" :  :  : "memory");
  return result;
}

  void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts)
{
   __asm volatile ("" :  :  : "memory");
  if (reenable_interrupts) {
    __nesc_enable_interrupt();
    }
}

# 11 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(12)))  void sig_TIMERA0_VECTOR(void )
#line 11
{
#line 11
  Msp430TimerCommonP__VectorTimerA0__fired();
}

# 169 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__captured(/*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP__0__Compare__fired();
    }
}

#line 169
static void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__captured(/*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP__1__Compare__fired();
    }
}

#line 169
static void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Event__fired(void )
{
  if (/*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Control__getControl().cap) {
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__captured(/*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Capture__getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP__2__Compare__fired();
    }
}

# 12 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(10)))  void sig_TIMERA1_VECTOR(void )
#line 12
{
#line 12
  Msp430TimerCommonP__VectorTimerA1__fired();
}

#line 13
__attribute((wakeup)) __attribute((interrupt(26)))  void sig_TIMERB0_VECTOR(void )
#line 13
{
#line 13
  Msp430TimerCommonP__VectorTimerB0__fired();
}

# 135 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__default__fired(uint8_t n)
{
}

# 28 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__fired(uint8_t arg_0x138b9c0){
#line 28
  switch (arg_0x138b9c0) {
#line 28
    case 0:
#line 28
      /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP__3__Event__fired();
#line 28
      break;
#line 28
    case 1:
#line 28
      /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP__4__Event__fired();
#line 28
      break;
#line 28
    case 2:
#line 28
      /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP__5__Event__fired();
#line 28
      break;
#line 28
    case 3:
#line 28
      /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP__6__Event__fired();
#line 28
      break;
#line 28
    case 4:
#line 28
      /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP__7__Event__fired();
#line 28
      break;
#line 28
    case 5:
#line 28
      /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP__8__Event__fired();
#line 28
      break;
#line 28
    case 6:
#line 28
      /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP__9__Event__fired();
#line 28
      break;
#line 28
    case 7:
#line 28
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Overflow__fired();
#line 28
      break;
#line 28
    default:
#line 28
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Event__default__fired(arg_0x138b9c0);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 159 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static error_t SchedulerBasicP__TaskBasic__postTask(uint8_t id)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 161
    {
#line 161
      {
        unsigned char __nesc_temp = 
#line 161
        SchedulerBasicP__pushTask(id) ? SUCCESS : EBUSY;

        {
#line 161
          __nesc_atomic_end(__nesc_atomic); 
#line 161
          return __nesc_temp;
        }
      }
    }
#line 164
    __nesc_atomic_end(__nesc_atomic); }
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__set_alarm(void )
{
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type now = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Counter__get();
#line 98
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type expires;
#line 98
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type remaining;




  expires = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt;


  remaining = (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type )(expires - now);


  if (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 <= now) 
    {
      if (expires >= /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 && 
      expires <= now) {
        remaining = 0;
        }
    }
  else {
      if (expires >= /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 || 
      expires <= now) {
        remaining = 0;
        }
    }
#line 121
  if (remaining > /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__MAX_DELAY) 
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 = now + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__MAX_DELAY;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt = remaining - /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__MAX_DELAY;
      remaining = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__MAX_DELAY;
    }
  else 
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 += /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt = 0;
    }
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__AlarmFrom__startAt((/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_size_type )now << 5, 
  (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__from_size_type )remaining << 5);
}

# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type /*CounterMilli32C.Transform*/TransformCounterC__0__Counter__get(void )
{
  /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type rv = 0;

#line 72
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*CounterMilli32C.Transform*/TransformCounterC__0__upper_count_type high = /*CounterMilli32C.Transform*/TransformCounterC__0__m_upper;
      /*CounterMilli32C.Transform*/TransformCounterC__0__from_size_type low = /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__get();

#line 76
      if (/*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__isOverflowPending()) 
        {






          high++;
          low = /*CounterMilli32C.Transform*/TransformCounterC__0__CounterFrom__get();
        }
      {
        /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type high_to = high;
        /*CounterMilli32C.Transform*/TransformCounterC__0__to_size_type low_to = low >> /*CounterMilli32C.Transform*/TransformCounterC__0__LOW_SHIFT_RIGHT;

#line 90
        rv = (high_to << /*CounterMilli32C.Transform*/TransformCounterC__0__HIGH_SHIFT_LEFT) | low_to;
      }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return rv;
}

# 51 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP__1__Timer__get(void )
{




  if (1) {
      /* atomic removed: atomic calls only */
#line 58
      {
        uint16_t t0;
        uint16_t t1 = * (volatile uint16_t * )400U;

#line 61
        do {
#line 61
            t0 = t1;
#line 61
            t1 = * (volatile uint16_t * )400U;
          }
        while (
#line 61
        t0 != t1);
        {
          unsigned int __nesc_temp = 
#line 62
          t1;

#line 62
          return __nesc_temp;
        }
      }
    }
  else 
#line 65
    {
      return * (volatile uint16_t * )400U;
    }
}

# 69 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type /*Counter32khz32C.Transform*/TransformCounterC__1__Counter__get(void )
{
  /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type rv = 0;

#line 72
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*Counter32khz32C.Transform*/TransformCounterC__1__upper_count_type high = /*Counter32khz32C.Transform*/TransformCounterC__1__m_upper;
      /*Counter32khz32C.Transform*/TransformCounterC__1__from_size_type low = /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__get();

#line 76
      if (/*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__isOverflowPending()) 
        {






          high++;
          low = /*Counter32khz32C.Transform*/TransformCounterC__1__CounterFrom__get();
        }
      {
        /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type high_to = high;
        /*Counter32khz32C.Transform*/TransformCounterC__1__to_size_type low_to = low >> /*Counter32khz32C.Transform*/TransformCounterC__1__LOW_SHIFT_RIGHT;

#line 90
        rv = (high_to << /*Counter32khz32C.Transform*/TransformCounterC__1__HIGH_SHIFT_LEFT) | low_to;
      }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return rv;
}

# 38 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__enableCapture(uint8_t mode)
#line 38
{
  /* atomic removed: atomic calls only */
#line 39
  {
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__disableEvents();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__GeneralIO__selectModuleFunc();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__clearPendingInterrupt();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430Capture__clearOverflow();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__setControlAsCapture(mode);
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC__0__Msp430TimerControl__enableEvents();
  }
  return SUCCESS;
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__clr(void )
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t * )29U &= ~(0x01 << 2);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 260 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static cc2420_status_t CC2420SpiP__Ram__write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len)
#line 262
{

  cc2420_status_t status = 0;
  uint8_t tmpLen = len;
  uint8_t * tmpData = (uint8_t * )data;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 268
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 270
            status;

            {
#line 270
              __nesc_atomic_end(__nesc_atomic); 
#line 270
              return __nesc_temp;
            }
          }
        }
    }
#line 274
    __nesc_atomic_end(__nesc_atomic); }
#line 274
  addr += offset;

  status = CC2420SpiP__SpiByte__write(addr | 0x80);
  CC2420SpiP__SpiByte__write((addr >> 1) & 0xc0);
  for (; len; len--) {
      CC2420SpiP__SpiByte__write(tmpData[tmpLen - len]);
    }

  return status;
}

# 133 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static bool StateImplP__State__isState(uint8_t id, uint8_t myState)
#line 133
{
  bool isState;

#line 135
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 135
    isState = StateImplP__state[id] == myState;
#line 135
    __nesc_atomic_end(__nesc_atomic); }
  return isState;
}

# 116 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static uint8_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiByte__write(uint8_t tx)
#line 116
{

  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__tx(tx);
  while (!/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__isRxIntrPending()) ;
  /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__clrRxIntr();
  return /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__Usart__rx();
}

# 45 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP__26__IO__set(void )
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t * )29U |= 0x01 << 2;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 149 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static error_t CC2420SpiP__Resource__release(uint8_t id)
#line 149
{
  uint8_t i;

#line 151
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 151
    {
      if (CC2420SpiP__m_holder != id) {
          {
            unsigned char __nesc_temp = 
#line 153
            FAIL;

            {
#line 153
              __nesc_atomic_end(__nesc_atomic); 
#line 153
              return __nesc_temp;
            }
          }
        }
#line 156
      CC2420SpiP__m_holder = CC2420SpiP__NO_HOLDER;
      if (!CC2420SpiP__m_requests) {
          CC2420SpiP__WorkingState__toIdle();
          CC2420SpiP__attemptRelease();
        }
      else {
          for (i = CC2420SpiP__m_holder + 1; ; i++) {
              i %= CC2420SpiP__RESOURCE_COUNT;

              if (CC2420SpiP__m_requests & (1 << i)) {
                  CC2420SpiP__m_holder = i;
                  CC2420SpiP__m_requests &= ~(1 << i);
                  CC2420SpiP__grant__postTask();
                  {
                    unsigned char __nesc_temp = 
#line 169
                    SUCCESS;

                    {
#line 169
                      __nesc_atomic_end(__nesc_atomic); 
#line 169
                      return __nesc_temp;
                    }
                  }
                }
            }
        }
    }
#line 175
    __nesc_atomic_end(__nesc_atomic); }
#line 175
  return SUCCESS;
}

#line 339
static error_t CC2420SpiP__attemptRelease(void )
#line 339
{


  if ((
#line 340
  CC2420SpiP__m_requests > 0
   || CC2420SpiP__m_holder != CC2420SpiP__NO_HOLDER)
   || !CC2420SpiP__WorkingState__isIdle()) {
      return FAIL;
    }
  /* atomic removed: atomic calls only */
  CC2420SpiP__release = TRUE;
  CC2420SpiP__ChipSpiResource__releasing();
  /* atomic removed: atomic calls only */
#line 348
  {
    if (CC2420SpiP__release) {
        CC2420SpiP__SpiResource__release();
        {
          unsigned char __nesc_temp = 
#line 351
          SUCCESS;

#line 351
          return __nesc_temp;
        }
      }
  }
  return EBUSY;
}

# 247 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static void HplMsp430Usart0P__Usart__disableSpi(void )
#line 247
{
  /* atomic removed: atomic calls only */
#line 248
  {
    HplMsp430Usart0P__ME1 &= ~(1 << 6);
    HplMsp430Usart0P__SIMO__selectIOFunc();
    HplMsp430Usart0P__SOMI__selectIOFunc();
    HplMsp430Usart0P__UCLK__selectIOFunc();
  }
}

# 136 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Alarm__startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type dt)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 = t0;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt = dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__set_alarm();
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

#line 96
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__set_alarm(void )
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__Counter__get();
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type expires;
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type remaining;




  expires = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt;


  remaining = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__to_size_type )(expires - now);


  if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 <= now) 
    {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 && 
      expires <= now) {
        remaining = 0;
        }
    }
  else {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 || 
      expires <= now) {
        remaining = 0;
        }
    }
#line 121
  if (remaining > /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__MAX_DELAY) 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 = now + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__MAX_DELAY;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt = remaining - /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__MAX_DELAY;
      remaining = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__MAX_DELAY;
    }
  else 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_t0 += /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__m_dt = 0;
    }
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__AlarmFrom__startAt((/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_size_type )now << 0, 
  (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC__1__from_size_type )remaining << 0);
}

# 844 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP__signalDone(error_t err)
#line 844
{
  /* atomic removed: atomic calls only */
#line 845
  CC2420TransmitP__m_state = CC2420TransmitP__S_STARTED;
  CC2420TransmitP__abortSpiRelease = FALSE;
  CC2420TransmitP__ChipSpiResource__attemptRelease();
  CC2420TransmitP__Send__sendDone(CC2420TransmitP__m_msg, err);
}

# 172 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static void CC2420PacketP__PacketTimeStamp32khz__clear(message_t *msg)
{
  __nesc_hton_int8(CC2420PacketP__CC2420PacketBody__getMetadata(msg)->timesync.data, FALSE);
  __nesc_hton_uint32(CC2420PacketP__CC2420PacketBody__getMetadata(msg)->timestamp.data, CC2420_INVALID_TIMESTAMP);
}

# 782 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP__congestionBackoff(void )
#line 782
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 783
    {
      CC2420TransmitP__RadioBackoff__requestCongestionBackoff(CC2420TransmitP__m_msg);
      CC2420TransmitP__BackoffTimer__start(CC2420TransmitP__myCongestionBackoff);
    }
#line 786
    __nesc_atomic_end(__nesc_atomic); }
}

# 58 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static uint32_t RandomMlcgC__Random__rand32(void )
#line 58
{
  uint32_t mlcg;
#line 59
  uint32_t p;
#line 59
  uint32_t q;
  uint64_t tmpseed;

  /* atomic removed: atomic calls only */
#line 62
  {
    tmpseed = (uint64_t )33614U * (uint64_t )RandomMlcgC__seed;
    q = tmpseed;
    q = q >> 1;
    p = tmpseed >> 32;
    mlcg = p + q;
    if (mlcg & 0x80000000) {
        mlcg = mlcg & 0x7FFFFFFF;
        mlcg++;
      }
    RandomMlcgC__seed = mlcg;
  }
  return mlcg;
}

# 789 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static error_t CC2420TransmitP__acquireSpiResource(void )
#line 789
{
  error_t error = CC2420TransmitP__SpiResource__immediateRequest();

#line 791
  if (error != SUCCESS) {
      CC2420TransmitP__SpiResource__request();
    }
  return error;
}

# 126 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static error_t CC2420SpiP__Resource__immediateRequest(uint8_t id)
#line 126
{
  error_t error;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 129
    {
      if (CC2420SpiP__WorkingState__requestState(CC2420SpiP__S_BUSY) != SUCCESS) {
          {
            unsigned char __nesc_temp = 
#line 131
            EBUSY;

            {
#line 131
              __nesc_atomic_end(__nesc_atomic); 
#line 131
              return __nesc_temp;
            }
          }
        }
      if (CC2420SpiP__SpiResource__isOwner()) {
          CC2420SpiP__m_holder = id;
          error = SUCCESS;
        }
      else {
#line 139
        if ((error = CC2420SpiP__SpiResource__immediateRequest()) == SUCCESS) {
            CC2420SpiP__m_holder = id;
          }
        else {
            CC2420SpiP__WorkingState__toIdle();
          }
        }
    }
#line 146
    __nesc_atomic_end(__nesc_atomic); }
#line 146
  return error;
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static error_t StateImplP__State__requestState(uint8_t id, uint8_t reqState)
#line 96
{
  error_t returnVal = FAIL;

#line 98
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 98
    {
      if (reqState == StateImplP__S_IDLE || StateImplP__state[id] == StateImplP__S_IDLE) {
          StateImplP__state[id] = reqState;
          returnVal = SUCCESS;
        }
    }
#line 103
    __nesc_atomic_end(__nesc_atomic); }
  return returnVal;
}

# 174 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__Resource__isOwner(uint8_t id)
#line 174
{
  /* atomic removed: atomic calls only */
#line 175
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId == id && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_BUSY) {
        unsigned char __nesc_temp = 
#line 176
        TRUE;

#line 176
        return __nesc_temp;
      }
    else 
#line 177
      {
        unsigned char __nesc_temp = 
#line 177
        FALSE;

#line 177
        return __nesc_temp;
      }
  }
}

#line 130
static error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ResourceDefaultOwner__release(void )
#line 130
{
  /* atomic removed: atomic calls only */
#line 131
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__default_owner_id) {
        if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_GRANTING) {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__postTask();
            {
              unsigned char __nesc_temp = 
#line 135
              SUCCESS;

#line 135
              return __nesc_temp;
            }
          }
        else {
#line 137
          if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_IMM_GRANTING) {
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__reqResId;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_BUSY;
              {
                unsigned char __nesc_temp = 
#line 140
                SUCCESS;

#line 140
                return __nesc_temp;
              }
            }
          }
      }
  }
#line 144
  return FAIL;
}

# 265 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static void HplMsp430Usart0P__Usart__setModeSpi(msp430_spi_union_config_t *config)
#line 265
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 267
    {
      HplMsp430Usart0P__Usart__resetUsart(TRUE);
      HplMsp430Usart0P__HplI2C__clearModeI2C();
      HplMsp430Usart0P__Usart__disableUart();
      HplMsp430Usart0P__configSpi(config);
      HplMsp430Usart0P__Usart__enableSpi();
      HplMsp430Usart0P__Usart__resetUsart(FALSE);
      HplMsp430Usart0P__Usart__clrIntr();
      HplMsp430Usart0P__Usart__disableIntr();
    }
#line 276
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 107 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static error_t CC2420SpiP__Resource__request(uint8_t id)
#line 107
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (CC2420SpiP__WorkingState__requestState(CC2420SpiP__S_BUSY) == SUCCESS) {
          CC2420SpiP__m_holder = id;
          if (CC2420SpiP__SpiResource__isOwner()) {
              CC2420SpiP__grant__postTask();
            }
          else {
              CC2420SpiP__SpiResource__request();
            }
        }
      else {
          CC2420SpiP__m_requests |= 1 << id;
        }
    }
#line 122
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 737 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP__attemptSend(void )
#line 737
{
  uint8_t status;
  bool congestion = TRUE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 741
    {
      if (CC2420TransmitP__m_state == CC2420TransmitP__S_CANCEL) {
          CC2420TransmitP__SFLUSHTX__strobe();
          CC2420TransmitP__releaseSpiResource();
          CC2420TransmitP__CSN__set();
          CC2420TransmitP__m_state = CC2420TransmitP__S_STARTED;
          CC2420TransmitP__Send__sendDone(CC2420TransmitP__m_msg, ECANCEL);
          {
#line 748
            __nesc_atomic_end(__nesc_atomic); 
#line 748
            return;
          }
        }





      CC2420TransmitP__CSN__clr();
      status = CC2420TransmitP__m_cca ? CC2420TransmitP__STXONCCA__strobe() : CC2420TransmitP__STXON__strobe();
      if (!(status & CC2420_STATUS_TX_ACTIVE)) {
          status = CC2420TransmitP__SNOP__strobe();
          if (status & CC2420_STATUS_TX_ACTIVE) {
              congestion = FALSE;
            }
        }

      CC2420TransmitP__m_state = congestion ? CC2420TransmitP__S_SAMPLE_CCA : CC2420TransmitP__S_SFD;
      CC2420TransmitP__CSN__set();
    }
#line 767
    __nesc_atomic_end(__nesc_atomic); }

  if (congestion) {
      CC2420TransmitP__totalCcaChecks = 0;
      CC2420TransmitP__releaseSpiResource();
      CC2420TransmitP__congestionBackoff();
    }
  else 
#line 773
    {
      CC2420TransmitP__BackoffTimer__start(CC2420TransmitP__CC2420_ABORT_PERIOD);
    }
}

# 318 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static cc2420_status_t CC2420SpiP__Strobe__strobe(uint8_t addr)
#line 318
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 319
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 321
            0;

            {
#line 321
              __nesc_atomic_end(__nesc_atomic); 
#line 321
              return __nesc_temp;
            }
          }
        }
    }
#line 325
    __nesc_atomic_end(__nesc_atomic); }
#line 325
  return CC2420SpiP__SpiByte__write(addr);
}

# 46 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__clr(void )
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t * )29U &= ~(0x01 << 6);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

#line 45
static void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP__30__IO__set(void )
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t * )29U |= 0x01 << 6;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 14 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(24)))  void sig_TIMERB1_VECTOR(void )
#line 14
{
#line 14
  Msp430TimerCommonP__VectorTimerB1__fired();
}

# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/RealMainP.nc"
  int main(void )
#line 52
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {





      {
      }
#line 60
      ;

      RealMainP__Scheduler__init();





      RealMainP__PlatformInit__init();
      while (RealMainP__Scheduler__runNextTask()) ;





      RealMainP__SoftwareInit__init();
      while (RealMainP__Scheduler__runNextTask()) ;
    }
#line 77
    __nesc_atomic_end(__nesc_atomic); }


  __nesc_enable_interrupt();

  RealMainP__Boot__booted();


  RealMainP__Scheduler__taskLoop();




  return -1;
}

# 164 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static void Msp430ClockP__set_dco_calib(int calib)
{
  BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
  DCOCTL = calib & 0xff;
}

# 52 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/BusyWaitCounterC.nc"
static void /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__BusyWait__wait(/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type dt)
{
  /* atomic removed: atomic calls only */
  {


    /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__size_type t0 = /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__get();

    if (dt > /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__HALF_MAX_SIZE_TYPE) 
      {
        dt -= /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__HALF_MAX_SIZE_TYPE;
        while (/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__get() - t0 <= dt) ;
        t0 += dt;
        dt = /*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__HALF_MAX_SIZE_TYPE;
      }

    while (/*BusyWaitMicroC.BusyWaitCounterC*/BusyWaitCounterC__0__Counter__get() - t0 <= dt) ;
  }
}

# 47 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/ds2401/OneWireMasterC.nc"
static void OneWireMasterC__OneWire__release(void )
#line 47
{
  OneWireMasterC__Pin__makeInput();
  OneWireMasterC__Pin__clr();
}

# 123 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static bool SchedulerBasicP__Scheduler__runNextTask(void )
{
  uint8_t nextTask;

  /* atomic removed: atomic calls only */
#line 127
  {
    nextTask = SchedulerBasicP__popTask();
    if (nextTask == SchedulerBasicP__NO_TASK) 
      {
        {
          unsigned char __nesc_temp = 
#line 131
          FALSE;

#line 131
          return __nesc_temp;
        }
      }
  }
#line 134
  SchedulerBasicP__TaskBasic__runTask(nextTask);
  return TRUE;
}

#line 164
static void SchedulerBasicP__TaskBasic__default__runTask(uint8_t id)
{
}

# 64 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static void SchedulerBasicP__TaskBasic__runTask(uint8_t arg_0x12e0d30){
#line 64
  switch (arg_0x12e0d30) {
#line 64
    case /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired:
#line 64
      /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC__0__fired__runTask();
#line 64
      break;
#line 64
    case /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer:
#line 64
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__runTask();
#line 64
      break;
#line 64
    case IPDispatchP__sendTask:
#line 64
      IPDispatchP__sendTask__runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP__startDone_task:
#line 64
      CC2420CsmaP__startDone_task__runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP__stopDone_task:
#line 64
      CC2420CsmaP__stopDone_task__runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP__sendDone_task:
#line 64
      CC2420CsmaP__sendDone_task__runTask();
#line 64
      break;
#line 64
    case CC2420ControlP__sync:
#line 64
      CC2420ControlP__sync__runTask();
#line 64
      break;
#line 64
    case CC2420ControlP__syncDone:
#line 64
      CC2420ControlP__syncDone__runTask();
#line 64
      break;
#line 64
    case CC2420SpiP__grant:
#line 64
      CC2420SpiP__grant__runTask();
#line 64
      break;
#line 64
    case /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task:
#line 64
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__runTask();
#line 64
      break;
#line 64
    case /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask:
#line 64
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__grantedTask__runTask();
#line 64
      break;
#line 64
    case CC2420ReceiveP__receiveDone_task:
#line 64
      CC2420ReceiveP__receiveDone_task__runTask();
#line 64
      break;
#line 64
    case CC2420TinyosNetworkP__grantTask:
#line 64
      CC2420TinyosNetworkP__grantTask__runTask();
#line 64
      break;
#line 64
    case PacketLinkP__send:
#line 64
      PacketLinkP__send__runTask();
#line 64
      break;
#line 64
    default:
#line 64
      SchedulerBasicP__TaskBasic__default__runTask(arg_0x12e0d30);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 66 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static error_t CC2420PacketP__Acks__requestAck(message_t *p_msg)
#line 66
{
  unsigned char *__nesc_temp48;

#line 67
  (__nesc_temp48 = CC2420PacketP__CC2420PacketBody__getHeader(p_msg)->fcf.data, __nesc_hton_leuint16(__nesc_temp48, __nesc_ntoh_leuint16(__nesc_temp48) | (1 << IEEE154_FCF_ACK_REQ)));
  return SUCCESS;
}

# 122 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static error_t CC2420CsmaP__Send__send(message_t *p_msg, uint8_t len)
#line 122
{
  unsigned char *__nesc_temp45;
  unsigned char *__nesc_temp44;
#line 124
  cc2420_header_t *header = CC2420CsmaP__CC2420PacketBody__getHeader(p_msg);
  cc2420_metadata_t *metadata = CC2420CsmaP__CC2420PacketBody__getMetadata(p_msg);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 127
    {
      if (!CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STARTED)) {
          {
            unsigned char __nesc_temp = 
#line 129
            FAIL;

            {
#line 129
              __nesc_atomic_end(__nesc_atomic); 
#line 129
              return __nesc_temp;
            }
          }
        }
#line 132
      CC2420CsmaP__SplitControlState__forceState(CC2420CsmaP__S_TRANSMITTING);
      CC2420CsmaP__m_msg = p_msg;
    }
#line 134
    __nesc_atomic_end(__nesc_atomic); }








  (__nesc_temp44 = header->fcf.data, __nesc_hton_leuint16(__nesc_temp44, __nesc_ntoh_leuint16(__nesc_temp44) & (((1 << IEEE154_FCF_ACK_REQ) | (
  0x3 << IEEE154_FCF_SRC_ADDR_MODE)) | (
  0x3 << IEEE154_FCF_DEST_ADDR_MODE))));

  (__nesc_temp45 = header->fcf.data, __nesc_hton_leuint16(__nesc_temp45, __nesc_ntoh_leuint16(__nesc_temp45) | ((IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (
  1 << IEEE154_FCF_INTRAPAN))));

  __nesc_hton_int8(metadata->ack.data, FALSE);
  __nesc_hton_uint8(metadata->rssi.data, 0);
  __nesc_hton_uint8(metadata->lqi.data, 0);

  __nesc_hton_uint32(metadata->timestamp.data, CC2420_INVALID_TIMESTAMP);

  CC2420CsmaP__ccaOn = TRUE;
  CC2420CsmaP__RadioBackoff__requestCca(CC2420CsmaP__m_msg);

  CC2420CsmaP__CC2420Transmit__send(CC2420CsmaP__m_msg, CC2420CsmaP__ccaOn);
  return SUCCESS;
}

# 819 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP__loadTXFIFO(void )
#line 819
{
  cc2420_header_t *header = CC2420TransmitP__CC2420PacketBody__getHeader(CC2420TransmitP__m_msg);
  uint8_t tx_power = __nesc_ntoh_uint8(CC2420TransmitP__CC2420PacketBody__getMetadata(CC2420TransmitP__m_msg)->tx_power.data);

  if (!tx_power) {
      tx_power = 31;
    }

  CC2420TransmitP__CSN__clr();

  if (CC2420TransmitP__m_tx_power != tx_power) {
      CC2420TransmitP__TXCTRL__write((((2 << CC2420_TXCTRL_TXMIXBUF_CUR) | (
      3 << CC2420_TXCTRL_PA_CURRENT)) | (
      1 << CC2420_TXCTRL_RESERVED)) | ((
      tx_power & 0x1F) << CC2420_TXCTRL_PA_LEVEL));
    }

  CC2420TransmitP__m_tx_power = tx_power;

  {
    uint8_t tmpLen __attribute((unused))  = __nesc_ntoh_leuint8(header->length.data) - 1;

#line 840
    CC2420TransmitP__TXFIFO__write((uint8_t * )header, __nesc_ntoh_leuint8(header->length.data) - 1);
  }
}

# 305 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static cc2420_status_t CC2420SpiP__Reg__write(uint8_t addr, uint16_t data)
#line 305
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 306
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 308
            0;

            {
#line 308
              __nesc_atomic_end(__nesc_atomic); 
#line 308
              return __nesc_temp;
            }
          }
        }
    }
#line 312
    __nesc_atomic_end(__nesc_atomic); }
#line 311
  CC2420SpiP__SpiByte__write(addr);
  CC2420SpiP__SpiByte__write(data >> 8);
  return CC2420SpiP__SpiByte__write(data & 0xff);
}

# 125 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiDmaP.nc"
static error_t /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__SpiPacket__send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len)
#line 127
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 129
    {
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_client = id;
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_tx_buf = tx_buf;
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_rx_buf = rx_buf;
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_len = len;
    }
#line 134
    __nesc_atomic_end(__nesc_atomic); }

  if (len) {

      * (volatile uint8_t *)2U &= ~(128 | 64);


      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__setupTransfer(DMA_SINGLE_TRANSFER, 
      3U, 
      DMA_EDGE_SENSITIVE, 
      (void *)118U, 
      rx_buf ? rx_buf : &/*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__m_dump, 
      len, 
      DMA_BYTE, 
      DMA_BYTE, 
      DMA_ADDRESS_UNCHANGED, 
      rx_buf ? 
      DMA_ADDRESS_INCREMENTED : 
      DMA_ADDRESS_UNCHANGED);

      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel1__startTransfer();


      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__setupTransfer(DMA_SINGLE_TRANSFER, 
      4U, 
      DMA_EDGE_SENSITIVE, 
      tx_buf, 
      (void *)119U, 
      len, 
      DMA_BYTE, 
      DMA_BYTE, 
      DMA_ADDRESS_INCREMENTED, 
      DMA_ADDRESS_UNCHANGED);

      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__DmaChannel2__startTransfer();


      * (volatile uint8_t *)2U |= 128;
    }
  else 
#line 172
    {
      /*Msp430SpiDma0P.SpiP*/Msp430SpiDmaP__0__signalDone_task__postTask();
    }

  return SUCCESS;
}

# 290 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static uint16_t CC2420ControlP__CC2420Config__getShortAddr(void )
#line 290
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 291
    {
      unsigned int __nesc_temp = 
#line 291
      CC2420ControlP__m_short_addr;

      {
#line 291
        __nesc_atomic_end(__nesc_atomic); 
#line 291
        return __nesc_temp;
      }
    }
#line 293
    __nesc_atomic_end(__nesc_atomic); }
}

# 120 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/packet/CC2420PacketP.nc"
static uint8_t CC2420PacketP__CC2420Packet__getNetwork(message_t *p_msg)
#line 120
{



  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      unsigned char __nesc_temp = 
#line 125
      *CC2420PacketP__getNetwork(p_msg);

      {
#line 125
        __nesc_atomic_end(__nesc_atomic); 
#line 125
        return __nesc_temp;
      }
    }
#line 127
    __nesc_atomic_end(__nesc_atomic); }
}

# 338 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/PrintfUART.h"
static void writedebug()
{
  uint16_t i = 0;

  while (debugbuf[i] != '\0' && i < 256) 
    UARTPutChar(debugbuf[i++]);
}

#line 313
static void UARTPutChar(char c)
{
  if (c == '\n') {
    UARTPutChar('\r');
    }










  U1TXBUF = c;
  while (!isTxIntrPending()) 
    continue;
}

# 229 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPDispatchP.nc"
static void IPDispatchP__deliver(struct lowpan_reconstruct *recon)
#line 229
{
  struct ip6_hdr *iph = (struct ip6_hdr *)recon->r_buf;
  int i;

  {
#line 233
    sprintf(debugbuf, "deliver [%i]: ", recon->r_bytes_rcvd);
#line 233
    writedebug();
  }
#line 233
  ;
  for (i = 0; i < recon->r_bytes_rcvd; i++) {
      {
#line 235
        sprintf(debugbuf, "%x ", recon->r_buf[i]);
#line 235
        writedebug();
      }
#line 235
      ;
    }
  {
#line 237
    sprintf(debugbuf, "\n");
#line 237
    writedebug();
  }
#line 237
  ;


  iph->ip6_ctlun.ip6_un1.ip6_un1_plen = (((uint16_t )(recon->r_bytes_rcvd - sizeof(struct ip6_hdr )) << 8) | ((uint16_t )(recon->r_bytes_rcvd - sizeof(struct ip6_hdr )) >> 8)) & 0xffff;
  IPDispatchP__IPLower__recv(iph, (void *)(iph + 1), (void *)0);


  ip_free(recon->r_buf);
  recon->r_timeout = T_UNUSED;
  recon->r_buf = (void *)0;
}

# 298 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static uint16_t CC2420ControlP__CC2420Config__getPanAddr(void )
#line 298
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 299
    {
      unsigned int __nesc_temp = 
#line 299
      CC2420ControlP__m_pan;

      {
#line 299
        __nesc_atomic_end(__nesc_atomic); 
#line 299
        return __nesc_temp;
      }
    }
#line 301
    __nesc_atomic_end(__nesc_atomic); }
}

# 226 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static int UDPShellP__lookup_cmd(char *cmd, int dbsize, struct UDPShellP__cmd_name *db)
#line 226
{
  int i;

#line 228
  for (i = 0; i < dbsize; i++) {

      if (
#line 229
      memcmp(cmd, db[i].c_name, db[i].c_len) == 0
       && cmd[db[i].c_len] == '\0') {
        return i;
        }
    }
#line 233
  return UDPShellP__CMD_NO_CMD;
}

# 125 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static error_t UdpP__UDP__sendto(uint8_t clnt, struct sockaddr_in6 *dest, void *payload, 
uint16_t len)
#line 126
{
  error_t rc;
  struct ip6_packet pkt;
  struct udp_hdr udp;
  struct ip_iovec v[2];


  memset((uint8_t *)& pkt.ip6_hdr, 0, sizeof pkt);
  memset((uint8_t *)&udp, 0, sizeof udp);


  ip_memcpy((uint8_t *)& pkt.ip6_hdr.ip6_dst, (uint8_t *)dest->sin6_addr.in6_u.u6_addr8, 16);
  UdpP__IPAddress__setSource(& pkt.ip6_hdr);

  if (UdpP__local_ports[clnt] == 0 && (UdpP__local_ports[clnt] = UdpP__alloc_lport(clnt)) == 0) {
      return FAIL;
    }

  udp.srcport = UdpP__local_ports[clnt];
  udp.dstport = dest->sin6_port;
  udp.len = (((uint16_t )(len + sizeof(struct udp_hdr )) << 8) | ((uint16_t )(len + sizeof(struct udp_hdr )) >> 8)) & 0xffff;
  udp.chksum = 0;


  pkt.ip6_hdr.ip6_ctlun.ip6_un2_vfc = 0x60;
  pkt.ip6_hdr.ip6_ctlun.ip6_un1.ip6_un1_nxt = IANA_UDP;
  pkt.ip6_hdr.ip6_ctlun.ip6_un1.ip6_un1_plen = udp.len;


  v[0].iov_base = (uint8_t *)&udp;
  v[0].iov_len = sizeof(struct udp_hdr );
  v[0].iov_next = &v[1];
  v[1].iov_base = payload;
  v[1].iov_len = len;
  v[1].iov_next = (void *)0;
  pkt.ip6_data = &v[0];

  udp.chksum = (((uint16_t )msg_cksum(& pkt.ip6_hdr, v, IANA_UDP) << 8) | ((uint16_t )msg_cksum(& pkt.ip6_hdr, v, IANA_UDP) >> 8)) & 0xffff;


  rc = UdpP__IP__send(&pkt);
  ;
  return rc;
}

# 29 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPProtocolsP.nc"
static error_t IPProtocolsP__IP__send(uint8_t nxt_hdr, struct ip6_packet *msg)
#line 29
{
  struct ieee154_frame_addr fr_addr;
  struct ip_iovec *cur;

  msg->ip6_hdr.ip6_ctlun.ip6_un1.ip6_un1_hlim = 100;

  if (IPProtocolsP__IPAddress__resolveAddress(& msg->ip6_hdr.ip6_src, & fr_addr.ieee_src) != SUCCESS) {
      {
#line 36
        sprintf(debugbuf, "resolve failed: src\n");
#line 36
        writedebug();
      }
#line 36
      ;
    }
  if (IPProtocolsP__IPAddress__resolveAddress(& msg->ip6_hdr.ip6_dst, & fr_addr.ieee_dst) != SUCCESS) {
      {
#line 39
        sprintf(debugbuf, "resolve failed: src\n");
#line 39
        writedebug();
      }
#line 39
      ;
    }
  fr_addr.ieee_dstpan = TOS_AM_GROUP;

  return IPProtocolsP__SubIP__send(&fr_addr, msg);
}

# 75 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/IPAddressP.nc"
static error_t IPAddressP__IPAddress__resolveAddress(struct in6_addr *addr, ieee154_addr_t *link_addr)
#line 75
{
  ieee154_panid_t panid = IPAddressP__CC2420Config__getPanAddr();

  if (addr->in6_u.u6_addr16[0] == ((((uint16_t )0xfe80 << 8) | ((uint16_t )0xfe80 >> 8)) & 0xffff)) {
      if (addr->in6_u.u6_addr16[5] == ((((uint16_t )0x00FF << 8) | ((uint16_t )0x00FF >> 8)) & 0xffff) && 
      addr->in6_u.u6_addr16[6] == ((((uint16_t )0xFE00 << 8) | ((uint16_t )0xFE00 >> 8)) & 0xffff)) {
          if (((((uint16_t )addr->in6_u.u6_addr16[4] >> 8) | ((uint16_t )addr->in6_u.u6_addr16[4] << 8)) & 0xffff) == panid) {
              link_addr->ieee_mode = IEEE154_ADDR_SHORT;
              link_addr->ieee_addr.saddr = (((uint16_t )addr->in6_u.u6_addr16[7] >> 8) | ((uint16_t )addr->in6_u.u6_addr16[7] << 8)) & 0xffff;
            }
          else 
#line 84
            {
              return FAIL;
            }
        }
      else 
#line 87
        {
          link_addr->ieee_mode = IEEE154_ADDR_EXT;
          ip_memcpy((uint8_t *)link_addr->ieee_addr.laddr.data, (uint8_t *)&addr->in6_u.u6_addr8[8], 8);
        }
      return SUCCESS;
    }
  else {
#line 92
    if (addr->in6_u.u6_addr8[0] == 0xff) {

        if ((addr->in6_u.u6_addr8[1] & 0x0f) == 0x02) {
            link_addr->ieee_mode = IEEE154_ADDR_SHORT;
            link_addr->ieee_addr.saddr = IEEE154_BROADCAST_ADDR;
            return TRUE;
          }
      }
    else 
#line 99
      {

        return FAIL;
      }
    }
}

# 103 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__Pool__put(/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free >= 12) {
      return FAIL;
    }
  else {
      uint16_t emptyIndex = /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__index + /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free;

#line 109
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__queue[emptyIndex] = newVal;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP__1__free++;
      ;
      return SUCCESS;
    }
}

#line 103
static error_t /*IPDispatchC.FragPool.PoolP*/PoolP__0__Pool__put(/*IPDispatchC.FragPool.PoolP*/PoolP__0__pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.FragPool.PoolP*/PoolP__0__free >= 12) {
      return FAIL;
    }
  else {
      uint16_t emptyIndex = /*IPDispatchC.FragPool.PoolP*/PoolP__0__index + /*IPDispatchC.FragPool.PoolP*/PoolP__0__free;

#line 109
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__queue[emptyIndex] = newVal;
      /*IPDispatchC.FragPool.PoolP*/PoolP__0__free++;
      ;
      return SUCCESS;
    }
}

# 105 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static void CC2420TinyosNetworkP__BarePacket__setPayloadLength(message_t *msg, uint8_t len)
#line 105
{
  cc2420_header_t *hdr = CC2420TinyosNetworkP__CC2420PacketBody__getHeader(msg);

#line 107
  __nesc_hton_leuint8(hdr->length.data, len - 1 + MAC_FOOTER_SIZE);
}

# 103 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/PoolP.nc"
static error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__Pool__put(/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free >= 3) {
      return FAIL;
    }
  else {
      uint16_t emptyIndex = /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__index + /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free;

#line 109
      if (emptyIndex >= 3) {
          emptyIndex -= 3;
        }
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__queue[emptyIndex] = newVal;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP__2__free++;
      ;
      return SUCCESS;
    }
}

# 764 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static void CC2420ReceiveP__waitForNextPacket(void )
#line 764
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 765
    {
      if (CC2420ReceiveP__m_state == CC2420ReceiveP__S_STOPPED) {
          CC2420ReceiveP__SpiResource__release();
          {
#line 768
            __nesc_atomic_end(__nesc_atomic); 
#line 768
            return;
          }
        }
      CC2420ReceiveP__receivingPacket = FALSE;
#line 783
      if ((CC2420ReceiveP__m_missed_packets && CC2420ReceiveP__FIFO__get()) || !CC2420ReceiveP__FIFOP__get()) {

          if (CC2420ReceiveP__m_missed_packets) {
              CC2420ReceiveP__m_missed_packets--;
            }





          CC2420ReceiveP__beginReceive();
        }
      else 
        {

          CC2420ReceiveP__m_state = CC2420ReceiveP__S_STARTED;
          CC2420ReceiveP__m_missed_packets = 0;
          CC2420ReceiveP__SpiResource__release();
        }
    }
#line 802
    __nesc_atomic_end(__nesc_atomic); }
}

#line 711
static void CC2420ReceiveP__beginReceive(void )
#line 711
{
  CC2420ReceiveP__m_state = CC2420ReceiveP__S_RX_LENGTH;
  /* atomic removed: atomic calls only */
#line 713
  CC2420ReceiveP__receivingPacket = TRUE;
  if (CC2420ReceiveP__SpiResource__isOwner()) {
      CC2420ReceiveP__receive();
    }
  else {
#line 717
    if (CC2420ReceiveP__SpiResource__immediateRequest() == SUCCESS) {
        CC2420ReceiveP__receive();
      }
    else {
        CC2420ReceiveP__SpiResource__request();
      }
    }
}

#line 754
static void CC2420ReceiveP__receive(void )
#line 754
{
  CC2420ReceiveP__CSN__clr();
  CC2420ReceiveP__RXFIFO__beginRead((uint8_t *)CC2420ReceiveP__CC2420PacketBody__getHeader(CC2420ReceiveP__m_p_rx_buf), 1);
}

# 189 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static cc2420_status_t CC2420SpiP__Fifo__beginRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 190
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 194
    {
      if (CC2420SpiP__WorkingState__isIdle()) {
          {
            unsigned char __nesc_temp = 
#line 196
            status;

            {
#line 196
              __nesc_atomic_end(__nesc_atomic); 
#line 196
              return __nesc_temp;
            }
          }
        }
    }
#line 200
    __nesc_atomic_end(__nesc_atomic); }
#line 200
  CC2420SpiP__m_addr = addr | 0x40;

  status = CC2420SpiP__SpiByte__write(CC2420SpiP__m_addr);
  CC2420SpiP__Fifo__continueRead(addr, data, len);

  return status;
}

#line 329
static void CC2420SpiP__SpiPacket__sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error)
#line 330
{
  if (CC2420SpiP__m_addr & 0x40) {
      CC2420SpiP__Fifo__readDone(CC2420SpiP__m_addr & ~0x40, rx_buf, len, error);
    }
  else 
#line 333
    {
      CC2420SpiP__Fifo__writeDone(CC2420SpiP__m_addr, tx_buf, len, error);
    }
}

# 728 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static void CC2420ReceiveP__flush(void )
#line 728
{








  CC2420ReceiveP__reset_state();

  CC2420ReceiveP__CSN__set();
  CC2420ReceiveP__CSN__clr();
  CC2420ReceiveP__SFLUSHRX__strobe();
  CC2420ReceiveP__SFLUSHRX__strobe();
  CC2420ReceiveP__CSN__set();
  CC2420ReceiveP__SpiResource__release();
  CC2420ReceiveP__waitForNextPacket();
}

#line 808
static void CC2420ReceiveP__reset_state(void )
#line 808
{
  CC2420ReceiveP__m_bytes_left = CC2420ReceiveP__RXFIFO_SIZE;
  /* atomic removed: atomic calls only */
#line 810
  CC2420ReceiveP__receivingPacket = FALSE;
  CC2420ReceiveP__m_timestamp_head = 0;
  CC2420ReceiveP__m_timestamp_size = 0;
  CC2420ReceiveP__m_missed_packets = 0;
}

# 467 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static void CC2420ControlP__writeFsctrl(void )
#line 467
{
  uint8_t channel;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 470
    {
      channel = CC2420ControlP__m_channel;
    }
#line 472
    __nesc_atomic_end(__nesc_atomic); }

  CC2420ControlP__FSCTRL__write((1 << CC2420_FSCTRL_LOCK_THR) | (((
  channel - 11) * 5 + 357) << CC2420_FSCTRL_FREQ));
}







static void CC2420ControlP__writeMdmctrl0(void )
#line 484
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 485
    {
      CC2420ControlP__MDMCTRL0__write((((((((1 << CC2420_MDMCTRL0_RESERVED_FRAME_MODE) | (
      0 << CC2420_MDMCTRL0_ADR_DECODE)) | (
      2 << CC2420_MDMCTRL0_CCA_HYST)) | (
      3 << CC2420_MDMCTRL0_CCA_MOD)) | (
      1 << CC2420_MDMCTRL0_AUTOCRC)) | ((
      CC2420ControlP__autoAckEnabled && CC2420ControlP__hwAutoAckDefault) << CC2420_MDMCTRL0_AUTOACK)) | (
      0 << CC2420_MDMCTRL0_AUTOACK)) | (
      2 << CC2420_MDMCTRL0_PREAMBLE_LENGTH));
    }
#line 494
    __nesc_atomic_end(__nesc_atomic); }
}







static void CC2420ControlP__writeId(void )
#line 503
{
  nxle_uint16_t id[6];

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 506
    {
      * (ieee_eui64_t *)&id[0] = CC2420ControlP__m_ext_addr;
      __nesc_hton_leuint16(id[4].data, CC2420ControlP__m_pan);
      __nesc_hton_leuint16(id[5].data, CC2420ControlP__m_short_addr);
    }
#line 510
    __nesc_atomic_end(__nesc_atomic); }

  CC2420ControlP__IEEEADR__write(0, (uint8_t *)&id, 12);
}

# 179 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static error_t CC2420TransmitP__StdControl__stop(void )
#line 179
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 180
    {
      CC2420TransmitP__m_state = CC2420TransmitP__S_STOPPED;
      CC2420TransmitP__BackoffTimer__stop();
      CC2420TransmitP__CaptureSFD__disable();
      CC2420TransmitP__SpiResource__release();
      CC2420TransmitP__CSN__set();
    }
#line 186
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 171 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static error_t CC2420ReceiveP__StdControl__stop(void )
#line 171
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 172
    {
      CC2420ReceiveP__m_state = CC2420ReceiveP__S_STOPPED;
      CC2420ReceiveP__reset_state();
      CC2420ReceiveP__CSN__set();
      CC2420ReceiveP__InterruptFIFOP__disable();
    }
#line 177
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 206 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/control/CC2420ControlP.nc"
static error_t CC2420ControlP__CC2420Power__stopVReg(void )
#line 206
{
  CC2420ControlP__m_state = CC2420ControlP__S_VREG_STOPPED;
  CC2420ControlP__RSTN__clr();
  CC2420ControlP__VREN__clr();
  CC2420ControlP__RSTN__set();
  return SUCCESS;
}

# 143 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static uint8_t StateImplP__State__getState(uint8_t id)
#line 143
{
  uint8_t theState;

#line 145
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 145
    theState = StateImplP__state[id];
#line 145
    __nesc_atomic_end(__nesc_atomic); }
  return theState;
}

# 220 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/link/PacketLinkP.nc"
static void PacketLinkP__signalDone(error_t error)
#line 220
{
  PacketLinkP__DelayTimer__stop();
  PacketLinkP__SendState__toIdle();
  __nesc_hton_uint16(PacketLinkP__CC2420PacketBody__getMetadata(PacketLinkP__currentSendMsg)->maxRetries.data, PacketLinkP__totalRetries);
  PacketLinkP__Send__sendDone(PacketLinkP__currentSendMsg, error);
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x/tos/interfaces/State.nc"
static void PacketLinkP__SendState__toIdle(void ){
#line 56
  StateImplP__State__toIdle(4U);
#line 56
}
#line 56
static void UniqueSendP__State__toIdle(void ){
#line 56
  StateImplP__State__toIdle(2U);
#line 56
}
#line 56
# 85 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/QueueC.nc"
static /*IPDispatchC.QueueC*/QueueC__0__queue_t /*IPDispatchC.QueueC*/QueueC__0__Queue__dequeue(void )
#line 85
{
  /*IPDispatchC.QueueC*/QueueC__0__queue_t t = /*IPDispatchC.QueueC*/QueueC__0__Queue__head();

#line 87
  ;
  if (!/*IPDispatchC.QueueC*/QueueC__0__Queue__empty()) {
      /*IPDispatchC.QueueC*/QueueC__0__head++;
      if (/*IPDispatchC.QueueC*/QueueC__0__head == 12) {
#line 90
        /*IPDispatchC.QueueC*/QueueC__0__head = 0;
        }
#line 91
      /*IPDispatchC.QueueC*/QueueC__0__size--;
      /*IPDispatchC.QueueC*/QueueC__0__printQueue();
    }
  return t;
}

# 133 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__m_timers[num];

#line 136
  timer->t0 = t0;
  timer->dt = dt;
  timer->isoneshot = isoneshot;
  timer->isrunning = TRUE;
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__postTask();
}

static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__startPeriodic(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__TimerFrom__getNow(), dt, FALSE);
}

#line 62
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__fireTimers(uint32_t now)
{
  uint8_t num;

  for (num = 0; num < /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__m_timers[num];

      if (timer->isrunning) 
        {
          uint32_t elapsed = now - timer->t0;

          if (elapsed >= timer->dt) 
            {
              if (timer->isoneshot) {
                timer->isrunning = FALSE;
                }
              else {
#line 79
                timer->t0 += timer->dt;
                }
              /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__Timer__fired(num);
              break;
            }
        }
    }
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC__0__updateFromTimer__postTask();
}

# 136 "/Users/stevedh/src/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__Alarm__startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__to_size_type dt)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_t0 = t0;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__m_dt = dt;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC__0__set_alarm();
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

# 56 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/UdpP.nc"
static error_t UdpP__UDP__bind(uint8_t clnt, uint16_t port)
#line 56
{
  int i;

#line 58
  port = (((uint16_t )port << 8) | ((uint16_t )port >> 8)) & 0xffff;
  if (port > 0) {
      for (i = 0; i < UdpP__N_CLIENTS; i++) 
        if (i != clnt && UdpP__local_ports[i] == port) {
          return FAIL;
          }
    }
#line 64
  UdpP__local_ports[clnt] = port;
  return SUCCESS;
}

# 81 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static error_t CC2420CsmaP__SplitControl__start(void )
#line 81
{
  if (CC2420CsmaP__SplitControlState__requestState(CC2420CsmaP__S_STARTING) == SUCCESS) {
      CC2420CsmaP__CC2420Power__startVReg();
      return SUCCESS;
    }
  else {
#line 86
    if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STARTED)) {
        return EALREADY;
      }
    else {
#line 89
      if (CC2420CsmaP__SplitControlState__isState(CC2420CsmaP__S_STARTING)) {
          return SUCCESS;
        }
      }
    }
#line 93
  return EBUSY;
}

# 53 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
__attribute((wakeup)) __attribute((interrupt(8)))  void sig_PORT1_VECTOR(void )
{
  volatile int n = P1IFG & P1IE;

  if (n & (1 << 0)) {
#line 57
      HplMsp430InterruptP__Port10__fired();
#line 57
      return;
    }
#line 58
  if (n & (1 << 1)) {
#line 58
      HplMsp430InterruptP__Port11__fired();
#line 58
      return;
    }
#line 59
  if (n & (1 << 2)) {
#line 59
      HplMsp430InterruptP__Port12__fired();
#line 59
      return;
    }
#line 60
  if (n & (1 << 3)) {
#line 60
      HplMsp430InterruptP__Port13__fired();
#line 60
      return;
    }
#line 61
  if (n & (1 << 4)) {
#line 61
      HplMsp430InterruptP__Port14__fired();
#line 61
      return;
    }
#line 62
  if (n & (1 << 5)) {
#line 62
      HplMsp430InterruptP__Port15__fired();
#line 62
      return;
    }
#line 63
  if (n & (1 << 6)) {
#line 63
      HplMsp430InterruptP__Port16__fired();
#line 63
      return;
    }
#line 64
  if (n & (1 << 7)) {
#line 64
      HplMsp430InterruptP__Port17__fired();
#line 64
      return;
    }
}

#line 158
__attribute((wakeup)) __attribute((interrupt(2)))  void sig_PORT2_VECTOR(void )
{
  volatile int n = P2IFG & P2IE;

  if (n & (1 << 0)) {
#line 162
      HplMsp430InterruptP__Port20__fired();
#line 162
      return;
    }
#line 163
  if (n & (1 << 1)) {
#line 163
      HplMsp430InterruptP__Port21__fired();
#line 163
      return;
    }
#line 164
  if (n & (1 << 2)) {
#line 164
      HplMsp430InterruptP__Port22__fired();
#line 164
      return;
    }
#line 165
  if (n & (1 << 3)) {
#line 165
      HplMsp430InterruptP__Port23__fired();
#line 165
      return;
    }
#line 166
  if (n & (1 << 4)) {
#line 166
      HplMsp430InterruptP__Port24__fired();
#line 166
      return;
    }
#line 167
  if (n & (1 << 5)) {
#line 167
      HplMsp430InterruptP__Port25__fired();
#line 167
      return;
    }
#line 168
  if (n & (1 << 6)) {
#line 168
      HplMsp430InterruptP__Port26__fired();
#line 168
      return;
    }
#line 169
  if (n & (1 << 7)) {
#line 169
      HplMsp430InterruptP__Port27__fired();
#line 169
      return;
    }
}

# 96 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
__attribute((wakeup)) __attribute((interrupt(18)))  void sig_UART0RX_VECTOR(void )
#line 96
{
  uint8_t temp = U0RXBUF;

#line 98
  HplMsp430Usart0P__Interrupts__rxDone(temp);
}

# 150 "/Users/stevedh/src/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__inUse(void )
#line 150
{
  /* atomic removed: atomic calls only */
#line 151
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_CONTROLLED) 
      {
        unsigned char __nesc_temp = 
#line 153
        FALSE;

#line 153
        return __nesc_temp;
      }
  }
#line 155
  return TRUE;
}






static uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__ArbiterInfo__userId(void )
#line 163
{
  /* atomic removed: atomic calls only */
#line 164
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__state != /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__RES_BUSY) 
      {
        unsigned char __nesc_temp = 
#line 166
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__NO_RES;

#line 166
        return __nesc_temp;
      }
#line 167
    {
      unsigned char __nesc_temp = 
#line 167
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP__0__resId;

#line 167
      return __nesc_temp;
    }
  }
}

# 101 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
__attribute((wakeup)) __attribute((interrupt(16)))  void sig_UART0TX_VECTOR(void )
#line 101
{
  if (HplMsp430Usart0P__HplI2C__isI2C()) {
    HplMsp430Usart0P__I2CInterrupts__fired();
    }
  else {
#line 105
    HplMsp430Usart0P__Interrupts__txDone();
    }
}

# 72 "/Users/stevedh/src/cvs/tinyos-2.x/tos/chips/msp430/dma/HplMsp430DmaP.nc"
__attribute((wakeup)) __attribute((interrupt(0)))  void sig_DACDMA_VECTOR(void )
#line 72
{
  HplMsp430DmaP__Interrupt__fired();
}

# 149 "/Users/stevedh/src/cvs/tinyos-2.x-contrib/berkeley/blip-2.0/tos/lib/net/blip/shell/UDPShellP.nc"
static void UDPShellP__action_echo(int argc, char **argv)
#line 149
{
  int i;
#line 150
  int arg_len;
  char *payload = UDPShellP__reply_buf;

  if (argc < 2) {
#line 153
    return;
    }
#line 154
  for (i = 1; i < argc; i++) {
      arg_len = strlen(argv[i]);
      if (payload - UDPShellP__reply_buf + arg_len + 1 > MAX_REPLY_LEN) {
#line 156
        break;
        }
#line 157
      ip_memcpy((uint8_t *)payload, (uint8_t *)argv[i], arg_len);
      payload += arg_len;
      *payload = ' ';
      payload++;
    }
  *(payload - 1) = '\n';

  UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__reply_buf, payload - UDPShellP__reply_buf);
}

static void UDPShellP__action_ping6(int argc, char **argv)
#line 167
{
  struct in6_addr dest;

  if (argc < 2) {
#line 170
    return;
    }
#line 171
  inet_pton6(argv[1], &dest);
}



static void UDPShellP__action_uptime(int argc, char **argv)
#line 176
{

  int len;
  uint64_t tval = UDPShellP__Uptime__get();

#line 180
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    tval = (UDPShellP__uptime + tval - UDPShellP__boot_time) / 1024;
#line 181
    __nesc_atomic_end(__nesc_atomic); }
  len = snprintf(UDPShellP__reply_buf, MAX_REPLY_LEN, "up %li seconds\n", 
  (uint32_t )tval);
  UDPShellP__UDP__sendto(&UDPShellP__session_endpoint, UDPShellP__reply_buf, len);
}

