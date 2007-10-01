#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 38 "/opt/msp430/msp430/include/sys/inttypes.h"
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
# 235 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source);




static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value);
#line 257
static __inline int8_t __nesc_hton_int8(void *target, int8_t value);






static __inline uint16_t __nesc_ntoh_uint16(const void *source);




static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value);
#line 301
static __inline uint32_t __nesc_hton_uint32(void *target, uint32_t value);
#line 385
typedef struct { char data[1]; } __attribute__((packed)) nx_int8_t;typedef int8_t __nesc_nxbase_nx_int8_t  ;
typedef struct { char data[2]; } __attribute__((packed)) nx_int16_t;typedef int16_t __nesc_nxbase_nx_int16_t  ;
typedef struct { char data[4]; } __attribute__((packed)) nx_int32_t;typedef int32_t __nesc_nxbase_nx_int32_t  ;
typedef struct { char data[8]; } __attribute__((packed)) nx_int64_t;typedef int64_t __nesc_nxbase_nx_int64_t  ;
typedef struct { char data[1]; } __attribute__((packed)) nx_uint8_t;typedef uint8_t __nesc_nxbase_nx_uint8_t  ;
typedef struct { char data[2]; } __attribute__((packed)) nx_uint16_t;typedef uint16_t __nesc_nxbase_nx_uint16_t  ;
typedef struct { char data[4]; } __attribute__((packed)) nx_uint32_t;typedef uint32_t __nesc_nxbase_nx_uint32_t  ;
typedef struct { char data[8]; } __attribute__((packed)) nx_uint64_t;typedef uint64_t __nesc_nxbase_nx_uint64_t  ;


typedef struct { char data[1]; } __attribute__((packed)) nxle_int8_t;typedef int8_t __nesc_nxbase_nxle_int8_t  ;
typedef struct { char data[2]; } __attribute__((packed)) nxle_int16_t;typedef int16_t __nesc_nxbase_nxle_int16_t  ;
typedef struct { char data[4]; } __attribute__((packed)) nxle_int32_t;typedef int32_t __nesc_nxbase_nxle_int32_t  ;
typedef struct { char data[8]; } __attribute__((packed)) nxle_int64_t;typedef int64_t __nesc_nxbase_nxle_int64_t  ;
typedef struct { char data[1]; } __attribute__((packed)) nxle_uint8_t;typedef uint8_t __nesc_nxbase_nxle_uint8_t  ;
typedef struct { char data[2]; } __attribute__((packed)) nxle_uint16_t;typedef uint16_t __nesc_nxbase_nxle_uint16_t  ;
typedef struct { char data[4]; } __attribute__((packed)) nxle_uint32_t;typedef uint32_t __nesc_nxbase_nxle_uint32_t  ;
typedef struct { char data[8]; } __attribute__((packed)) nxle_uint64_t;typedef uint64_t __nesc_nxbase_nxle_uint64_t  ;
# 151 "/opt/msp430/lib/gcc-lib/msp430/3.2.3/include/stddef.h" 3
typedef int ptrdiff_t;
#line 213
typedef unsigned int size_t;
#line 325
typedef int wchar_t;
# 41 "/opt/msp430/msp430/include/sys/types.h"
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
# 42 "/opt/msp430/msp430/include/string.h"
extern void *memset(void *, int , size_t );
#line 63
extern void *memset(void *, int , size_t );
# 59 "/opt/msp430/msp430/include/stdlib.h"
#line 56
typedef struct __nesc_unnamed4242 {
  int quot;
  int rem;
} div_t;







#line 64
typedef struct __nesc_unnamed4243 {
  long quot;
  long rem;
} ldiv_t;
# 122 "/opt/msp430/msp430/include/sys/config.h" 3
typedef long int __int32_t;
typedef unsigned long int __uint32_t;
# 12 "/opt/msp430/msp430/include/sys/_types.h"
typedef long _off_t;
typedef long _ssize_t;
# 28 "/opt/msp430/msp430/include/sys/reent.h" 3
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

  void (*__cleanup)(struct _reent *);


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


  void (**_sig_func)(int );




  struct _glue __sglue;
  struct __sFILE __sf[3];
};
#line 273
struct _reent;
# 18 "/opt/msp430/msp430/include/math.h"
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
# 20 "/svn/tinyos-2.x/tos/system/tos.h"
typedef uint8_t bool;
enum __nesc_unnamed4247 {
#line 21
  FALSE = 0, TRUE = 1
};
typedef nx_int8_t nx_bool;






struct __nesc_attr_atmostonce {
};
#line 31
struct __nesc_attr_atleastonce {
};
#line 32
struct __nesc_attr_exactlyonce {
};
# 34 "/svn/tinyos-2.x/tos/types/TinyError.h"
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
  EALREADY = 9
};

typedef uint8_t error_t  ;

static inline error_t ecombine(error_t r1, error_t r2);
# 39 "/opt/msp430/msp430/include/msp430/iostructures.h"
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
# 106 "/opt/msp430/msp430/include/msp430/iostructures.h" 3
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
# 103 "/opt/msp430/msp430/include/msp430/gpio.h" 3
volatile unsigned char P1OUT __asm ("0x0021");

volatile unsigned char P1DIR __asm ("0x0022");

volatile unsigned char P1IFG __asm ("0x0023");



volatile unsigned char P1IE __asm ("0x0025");

volatile unsigned char P1SEL __asm ("0x0026");






volatile unsigned char P2OUT __asm ("0x0029");

volatile unsigned char P2DIR __asm ("0x002A");

volatile unsigned char P2IFG __asm ("0x002B");

volatile unsigned char P2IES __asm ("0x002C");

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
# 85 "/opt/msp430/msp430/include/msp430/usart.h"
volatile unsigned char U0CTL __asm ("0x0070");

volatile unsigned char U0TCTL __asm ("0x0071");



volatile unsigned char U0MCTL __asm ("0x0073");

volatile unsigned char U0BR0 __asm ("0x0074");

volatile unsigned char U0BR1 __asm ("0x0075");

volatile unsigned char U0RXBUF __asm ("0x0076");
#line 254
volatile unsigned char U1CTL __asm ("0x0078");

volatile unsigned char U1TCTL __asm ("0x0079");



volatile unsigned char U1MCTL __asm ("0x007B");

volatile unsigned char U1BR0 __asm ("0x007C");

volatile unsigned char U1BR1 __asm ("0x007D");

volatile unsigned char U1RXBUF __asm ("0x007E");
# 24 "/opt/msp430/msp430/include/msp430/timera.h"
volatile unsigned int TA0CTL __asm ("0x0160");

volatile unsigned int TA0CCTL0 __asm ("0x0162");

volatile unsigned int TA0CCTL1 __asm ("0x0164");

volatile unsigned int TA0CCTL2 __asm ("0x0166");

volatile unsigned int TA0R __asm ("0x0170");
# 114 "/opt/msp430/msp430/include/msp430/timera.h" 3
#line 105
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
#line 130
#line 116
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
# 26 "/opt/msp430/msp430/include/msp430/timerb.h"
volatile unsigned int TBCCTL0 __asm ("0x0182");





volatile unsigned int TBR __asm ("0x0190");

volatile unsigned int TBCCR0 __asm ("0x0192");
#line 75
#line 63
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
#line 90
#line 77
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
# 18 "/opt/msp430/msp430/include/msp430/basic_clock.h"
volatile unsigned char DCOCTL __asm ("0x0056");

volatile unsigned char BCSCTL1 __asm ("0x0057");

volatile unsigned char BCSCTL2 __asm ("0x0058");
# 18 "/opt/msp430/msp430/include/msp430/adc12.h"
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
# 71 "/opt/msp430/msp430/include/msp430x16x.h"
volatile unsigned char ME1 __asm ("0x0004");





volatile unsigned char ME2 __asm ("0x0005");
# 142 "/svn/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
 static volatile uint8_t U0CTLnr __asm ("0x0070");
 static volatile uint8_t I2CTCTLnr __asm ("0x0071");
 static volatile uint8_t I2CDCTLnr __asm ("0x0072");
#line 177
typedef uint8_t mcu_power_t  ;
static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2);


enum __nesc_unnamed4257 {
  MSP430_POWER_ACTIVE = 0, 
  MSP430_POWER_LPM0 = 1, 
  MSP430_POWER_LPM1 = 2, 
  MSP430_POWER_LPM2 = 3, 
  MSP430_POWER_LPM3 = 4, 
  MSP430_POWER_LPM4 = 5
};

static inline void __nesc_disable_interrupt(void );





static inline void __nesc_enable_interrupt(void );




typedef bool __nesc_atomic_t;
__nesc_atomic_t __nesc_atomic_start(void );
void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts);






__nesc_atomic_t __nesc_atomic_start(void )  ;







void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts)  ;
# 33 "../../../../../../../../../../blaze/tos/platforms/tmote1100/hardware.h"
static inline void TOSH_SET_SIMO0_PIN(void);
#line 33
static inline void TOSH_CLR_SIMO0_PIN(void);
#line 33
static inline void TOSH_MAKE_SIMO0_OUTPUT(void);
static inline void TOSH_SET_UCLK0_PIN(void);
#line 34
static inline void TOSH_CLR_UCLK0_PIN(void);
#line 34
static inline void TOSH_MAKE_UCLK0_OUTPUT(void);
#line 76
enum __nesc_unnamed4258 {

  TOSH_HUMIDITY_ADDR = 5, 
  TOSH_HUMIDTEMP_ADDR = 3, 
  TOSH_HUMIDITY_RESET = 0x1E
};



static inline void TOSH_SET_FLASH_CS_PIN(void);
#line 85
static inline void TOSH_CLR_FLASH_CS_PIN(void);
#line 85
static inline void TOSH_MAKE_FLASH_CS_OUTPUT(void);
static inline void TOSH_SET_FLASH_HOLD_PIN(void);
#line 86
static inline void TOSH_MAKE_FLASH_HOLD_OUTPUT(void);
# 43 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestCase.h"
static void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual);
static void assertNotEqualsFailed(char *failMsg, uint32_t actual);
static void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual);
static void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual);




static void assertSuccess(void);




static void assertFail(char *failMsg);
# 6 "/svn/tinyos-2.x/tos/types/AM.h"
typedef nx_uint8_t nx_am_id_t;
typedef nx_uint8_t nx_am_group_t;
typedef nx_uint16_t nx_am_addr_t;

typedef uint8_t am_id_t;
typedef uint8_t am_group_t;
typedef uint16_t am_addr_t;

enum __nesc_unnamed4259 {
  AM_BROADCAST_ADDR = 0xffff
};









enum __nesc_unnamed4260 {
  TOS_AM_GROUP = 0x22, 
  TOS_AM_ADDRESS = 1
};
# 30 "/svn/tinyos-2.x/tos/types/Leds.h"
enum __nesc_unnamed4261 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.h"
enum __nesc_unnamed4262 {
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
typedef struct __nesc_unnamed4263 {

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
typedef struct __nesc_unnamed4264 {

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
typedef struct __nesc_unnamed4265 {

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
# 5 "../../../../../../../../../../blaze/tos/chips/blazeradio/Blaze.h"
typedef uint8_t blaze_status_t;
typedef uint8_t radio_id_t;
#line 20
#line 12
typedef nx_struct blaze_header_t {
  nx_uint8_t length;
  nx_uint16_t dest;
  nx_uint16_t fcf;
  nx_uint8_t dsn;
  nx_uint16_t src;
  nx_uint16_t destpan;
  nx_uint8_t type;
} __attribute__((packed)) blaze_header_t;










#line 30
typedef nx_struct blaze_footer_t {
} __attribute__((packed)) blaze_footer_t;
#line 43
#line 33
typedef nx_struct blaze_metadata_t {
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_bool ack;
  nx_uint8_t radio;
  nx_uint8_t txPower;
  nx_uint32_t time;
  nx_uint16_t rxInterval;
  nx_uint16_t maxRetries;
  nx_uint16_t retryDelay;
} __attribute__((packed)) blaze_metadata_t;
#line 58
#line 50
typedef nx_struct blaze_ack_t {
  nx_uint8_t length;
  nx_uint16_t dest;
  nx_uint16_t fcf;
  nx_uint8_t dsn;
  nx_uint16_t src;

  nx_uint16_t crc;
} __attribute__((packed)) blaze_ack_t;

enum __nesc_unnamed4266 {

  MAC_HEADER_SIZE = sizeof(blaze_header_t ) - 1, 


  MAC_FOOTER_SIZE = sizeof(uint16_t ), 


  ACK_FRAME_LENGTH = sizeof(blaze_ack_t ) - 1
};


enum blaze_cmd_strobe_enums {

  BLAZE_SRES = 0x30, 
  BLAZE_SFSTXON = 0x31, 
  BLAZE_SXOFF = 0x32, 
  BLAZE_SCAL = 0x33, 
  BLAZE_SRX = 0x34, 
  BLAZE_STX = 0x35, 
  BLAZE_SIDLE = 0x36, 
  BLAZE_SWOR = 0x38, 
  BLAZE_SPWD = 0x39, 
  BLAZE_SFRX = 0x3A, 
  BLAZE_SFTX = 0x3B, 
  BLAZE_SWORRST = 0x3C, 
  BLAZE_SNOP = 0x3D
};


enum blaze_addr_enums {

  BLAZE_PATABLE = 0x3E, 
  BLAZE_TXFIFO = 0x3F, 
  BLAZE_RXFIFO = 0xBF
};


enum blaze_state_enums {

  BLAZE_S_IDLE = 0x00, 
  BLAZE_S_RX = 0x01, 
  BLAZE_S_TX = 0x02, 
  BLAZE_S_FSTXON = 0x03, 
  BLAZE_S_CALIBRATE = 0x04, 
  BLAZE_S_SETTLING = 0x05, 
  BLAZE_S_RXFIFO_OVERFLOW = 0x06, 
  BLAZE_S_TXFIFO_UNDERFLOW = 0x07
};


enum blaze_mask_enums {

  BLAZE_WRITE = 0x00, 
  BLAZE_READ = 0x80, 
  BLAZE_SINGLE = 0x00, 
  BLAZE_BURST = 0x40
};

enum blaze_config_reg_addr_enums {

  BLAZE_IOCFG2 = 0x00, 
  BLAZE_IOCFG1 = 0x01, 
  BLAZE_IOCFG0 = 0x02, 
  BLAZE_FIFOTHR = 0x03, 
  BLAZE_SYNC1 = 0x04, 
  BLAZE_SYNC0 = 0x05, 
  BLAZE_PKTLEN = 0x06, 
  BLAZE_PKTCTRL1 = 0x07, 
  BLAZE_PKTCTRL0 = 0x08, 
  BLAZE_ADDR = 0x09, 
  BLAZE_CHANNR = 0x0A, 
  BLAZE_FSCTRL1 = 0x0B, 
  BLAZE_FSCTRL0 = 0x0C, 
  BLAZE_FREQ2 = 0x0D, 
  BLAZE_FREQ1 = 0x0E, 
  BLAZE_FREQ0 = 0x0F, 
  BLAZE_MDMCFG4 = 0x10, 
  BLAZE_MDMCFG3 = 0x11, 
  BLAZE_MDMCFG2 = 0x12, 
  BLAZE_MDMCFG1 = 0x13, 
  BLAZE_MDMCFG0 = 0x14, 
  BLAZE_DEVIATN = 0x15, 
  BLAZE_MCSM2 = 0x16, 
  BLAZE_MCSM1 = 0x17, 
  BLAZE_MCSM0 = 0x18, 
  BLAZE_FOCCFG = 0x19, 
  BLAZE_BSCFG = 0x1A, 
  BLAZE_AGCTRL2 = 0x1B, 
  BLAZE_AGCTRL1 = 0x1C, 
  BLAZE_AGCTRL0 = 0x1D, 
  BLAZE_WOREVT1 = 0x1E, 
  BLAZE_WOREVT0 = 0x1F, 
  BLAZE_WORCTRL = 0x20, 
  BLAZE_FREND1 = 0x21, 
  BLAZE_FREND0 = 0x22, 
  BLAZE_FSCAL3 = 0x23, 
  BLAZE_FSCAL2 = 0x24, 
  BLAZE_FSCAL1 = 0x25, 
  BLAZE_FSCAL0 = 0x26, 
  BLAZE_RCCTRL1 = 0x27, 
  BLAZE_RCCTRL0 = 0x28, 
  BLAZE_FSTEST = 0x29, 
  BLAZE_PTEST = 0x2A, 
  BLAZE_AGCTEST = 0x2B, 
  BLAZE_TEST2 = 0x2C, 
  BLAZE_TEST1 = 0x2D, 
  BLAZE_TEST0 = 0x2E, 
  BLAZE_PARTNUM = 0x30 | BLAZE_BURST, 
  BLAZE_VERSION = 0x31 | BLAZE_BURST, 
  BLAZE_FREQEST = 0x32 | BLAZE_BURST, 
  BLAZE_LQI = 0x33 | BLAZE_BURST, 
  BLAZE_RSSI = 0x34 | BLAZE_BURST, 
  BLAZE_MARCSTATE = 0x35 | BLAZE_BURST, 
  BLAZE_WORTIME1 = 0x36 | BLAZE_BURST, 
  BLAZE_WORTIME0 = 0x37 | BLAZE_BURST, 
  BLAZE_PKSTATUS = 0x38 | BLAZE_BURST, 
  BLAZE_VCO_VC_DAC = 0x39 | BLAZE_BURST, 
  BLAZE_TXBYTES = 0x3A | BLAZE_BURST, 
  BLAZE_RXBYTES = 0x3B | BLAZE_BURST
};
# 72 "/svn/tinyos-2.x/tos/lib/serial/Serial.h"
typedef uint8_t uart_id_t;



enum __nesc_unnamed4267 {
  HDLC_FLAG_BYTE = 0x7e, 
  HDLC_CTLESC_BYTE = 0x7d
};



enum __nesc_unnamed4268 {
  TOS_SERIAL_ACTIVE_MESSAGE_ID = 0, 
  TOS_SERIAL_CC1000_ID = 1, 
  TOS_SERIAL_802_15_4_ID = 2, 
  TOS_SERIAL_UNKNOWN_ID = 255
};


enum __nesc_unnamed4269 {
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
# 11 "../../../../../../../../../../blaze/tos/platforms/tmote1100/platform_message.h"
#line 8
typedef union message_header {
  blaze_header_t blazeHeader;
  serial_header_t serial;
} message_header_t;



#line 13
typedef union TOSRadioFooter {
  blaze_footer_t blazeFooter;
} message_footer_t;



#line 17
typedef union TOSRadioMetadata {
  blaze_metadata_t blazeMetadata;
} message_metadata_t;
# 19 "/svn/tinyos-2.x/tos/types/message.h"
#line 14
typedef nx_struct message_t {
  nx_uint8_t header[sizeof(message_header_t )];
  nx_uint8_t data[28];
  nx_uint8_t footer[sizeof(message_footer_t )];
  nx_uint8_t metadata[sizeof(message_metadata_t )];
} __attribute__((packed)) message_t;
# 58 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessing.h"
#line 50
typedef nx_struct TUnitProcessingMsg {
  nx_uint8_t cmd;
  nx_uint8_t id;
  nx_uint32_t expected;
  nx_uint32_t actual;
  nx_bool lastMsg;
  nx_uint8_t failMsgLength;
  nx_uint8_t failMsg[28 - 12];
} __attribute__((packed)) TUnitProcessingMsg;


enum __nesc_unnamed4270 {
  TUNITPROCESSING_CMD_PING = 0, 
  TUNITPROCESSING_REPLY_PING = 1, 
  TUNITPROCESSING_CMD_RUN = 2, 
  TUNITPROCESSING_REPLY_RUN = 3, 
  TUNITPROCESSING_EVENT_PONG = 4, 
  TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS = 5, 
  TUNITPROCESSING_EVENT_TESTRESULT_FAILED = 6, 
  TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED = 7, 
  TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED = 8, 
  TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED = 9, 
  TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED = 10, 
  TUNITPROCESSING_EVENT_ALLDONE = 11, 
  TUNITPROCESSING_CMD_TEARDOWNONETIME = 12
};

enum __nesc_unnamed4271 {
  AM_TUNITPROCESSINGMSG = 0xFF
};
# 80 "/svn/tinyos-2.x/tos/system/crc.h"
static uint16_t crcByte(uint16_t crc, uint8_t b);
# 56 "/svn/tinyos-2.x/tos/chips/msp430/usart/msp430usart.h"
#line 48
typedef enum __nesc_unnamed4272 {

  USART_NONE = 0, 
  USART_UART = 1, 
  USART_UART_TX = 2, 
  USART_UART_RX = 3, 
  USART_SPI = 4, 
  USART_I2C = 5
} msp430_usartmode_t;










#line 58
typedef struct __nesc_unnamed4273 {
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
typedef struct __nesc_unnamed4274 {
  unsigned int txept : 1;
  unsigned int stc : 1;
  unsigned int txwake : 1;
  unsigned int urxse : 1;
  unsigned int ssel : 2;
  unsigned int ckpl : 1;
  unsigned int ckph : 1;
} __attribute((packed))  msp430_utctl_t;










#line 79
typedef struct __nesc_unnamed4275 {
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
typedef struct __nesc_unnamed4276 {
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
typedef struct __nesc_unnamed4277 {
  uint16_t ubr;
  uint8_t uctl;
  uint8_t utctl;
} msp430_spi_registers_t;




#line 124
typedef union __nesc_unnamed4278 {
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
typedef enum __nesc_unnamed4279 {

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
typedef struct __nesc_unnamed4280 {
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
typedef struct __nesc_unnamed4281 {
  uint16_t ubr;
  uint8_t umctl;
  uint8_t uctl;
  uint8_t utctl;
  uint8_t urctl;
  uint8_t ume;
} msp430_uart_registers_t;




#line 211
typedef union __nesc_unnamed4282 {
  msp430_uart_config_t uartConfig;
  msp430_uart_registers_t uartRegisters;
} msp430_uart_union_config_t;

msp430_uart_union_config_t msp430_uart_default_config = { 
{ 
.utxe = 1, 
.urxe = 1, 
.ubr = UBR_1MHZ_57600, 
.umctl = UMCTL_1MHZ_57600, 
.ssel = 0x02, 
.pena = 0, 
.pev = 0, 
.spb = 0, 
.clen = 1, 
.listen = 0, 
.mm = 0, 
.ckpl = 0, 
.urxse = 0, 
.urxeie = 1, 
.urxwie = 0, 
.utxe = 1, 
.urxe = 1 } };
#line 248
#line 240
typedef struct __nesc_unnamed4283 {
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
typedef struct __nesc_unnamed4284 {
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
typedef struct __nesc_unnamed4285 {
  uint8_t uctl;
  uint8_t i2ctctl;
  uint8_t i2cpsc;
  uint8_t i2csclh;
  uint8_t i2cscll;
  uint16_t i2coa;
} msp430_i2c_registers_t;




#line 287
typedef union __nesc_unnamed4286 {
  msp430_i2c_config_t i2cConfig;
  msp430_i2c_registers_t i2cRegisters;
} msp430_i2c_union_config_t;
# 29 "/svn/tinyos-2.x/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4287 {
#line 29
  int notUsed;
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4288 {
#line 30
  int notUsed;
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4289 {
#line 31
  int notUsed;
} 
#line 31
TMicro;
# 33 "/svn/tinyos-2.x/tos/types/Resource.h"
typedef uint8_t resource_client_id_t;
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100.h"
enum __nesc_unnamed4290 {
  CC1100_RADIO_ID = 0U
};


enum CC1100_config_reg_state_enums {

  CC1100_CONFIG_IOCFG2 = 0x06, 


  CC1100_CONFIG_IOCFG1 = 0x2E, 


  CC1100_CONFIG_IOCFG0 = 0x09, 

  CC1100_CONFIG_FIFOTHR = 0x07, 
  CC1100_CONFIG_SYNC1 = 0xD3, 
  CC1100_CONFIG_SYNC0 = 0x91, 


  CC1100_CONFIG_PKTLEN = 0x3D, 


  CC1100_CONFIG_PKTCTRL1 = 0x07, 


  CC1100_CONFIG_PKTCTRL0 = 0x41, 

  CC1100_CONFIG_ADDR = 0x00, 
  CC1100_CONFIG_CHANNR = 0x00, 
  CC1100_CONFIG_FSCTRL1 = 0x10, 
  CC1100_CONFIG_FSCTRL0 = 0x00, 
  CC1100_CONFIG_FREQ2 = 0x0C, 
  CC1100_CONFIG_FREQ1 = 0x1D, 
  CC1100_CONFIG_FREQ0 = 0x89, 
  CC1100_CONFIG_MDMCFG4 = 0x2D, 
  CC1100_CONFIG_MDMCFG3 = 0x3B, 
  CC1100_CONFIG_MDMCFG2 = 0xF3, 
  CC1100_CONFIG_MDMCFG1 = 0x22, 
  CC1100_CONFIG_MDMCFG0 = 0xF8, 
  CC1100_CONFIG_DEVIATN = 0x00, 
  CC1100_CONFIG_MCSM2 = 0x07, 


  CC1100_CONFIG_MCSM1 = 0x3F, 
  CC1100_CONFIG_MCSM0 = 0x18, 
  CC1100_CONFIG_FOCCFG = 0x1D, 
  CC1100_CONFIG_BSCFG = 0x1C, 
  CC1100_CONFIG_AGCTRL2 = 0xC7, 
  CC1100_CONFIG_AGCTRL1 = 0x00, 
  CC1100_CONFIG_AGCTRL0 = 0xB2, 
  CC1100_CONFIG_WOREVT1 = 0x87, 
  CC1100_CONFIG_WOREVT0 = 0x6B, 
  CC1100_CONFIG_WORCTRL = 0xF8, 
  CC1100_CONFIG_FREND1 = 0xB6, 
  CC1100_CONFIG_FREND0 = 0x10, 
  CC1100_CONFIG_FSCAL3 = 0xEA, 
  CC1100_CONFIG_FSCAL2 = 0x2A, 
  CC1100_CONFIG_FSCAL1 = 0x00, 
  CC1100_CONFIG_FSCAL0 = 0x11
};
# 38 "../../../../../../../../../../blaze/tos/chips/blazeradio/IEEE802154.h"
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
# 18 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/InterruptState.h"
enum __nesc_unnamed4291 {
  S_INTERRUPT_RX, 
  S_INTERRUPT_TX
};
enum SerialAMQueueP$__nesc_unnamed4292 {
  SerialAMQueueP$NUM_CLIENTS = 1U
};
enum /*PlatformSerialC.UartC*/Msp430Uart1C$0$__nesc_unnamed4293 {
  Msp430Uart1C$0$CLIENT_ID = 0U
};
typedef T32khz /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$precision_tag;
typedef uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$size_type;
typedef T32khz /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag;
typedef /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$precision_tag;
typedef uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$size_type;
enum /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$__nesc_unnamed4294 {
  Msp430Usart1C$0$CLIENT_ID = 0U
};
enum /*TestC.TestCC1100ControlC*/TestCaseC$0$__nesc_unnamed4295 {
  TestCaseC$0$TUNIT_TEST_ID = 0U
};
enum /*TestC.BlazeSpiResourceC*/BlazeSpiResourceC$0$__nesc_unnamed4296 {
  BlazeSpiResourceC$0$CLIENT_ID = 0U
};
enum /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$__nesc_unnamed4297 {
  Msp430Spi0C$0$CLIENT_ID = 0U
};
enum /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$__nesc_unnamed4298 {
  Msp430Usart0C$0$CLIENT_ID = 0U
};
enum /*BlazeInitC.ResetResourceC*/BlazeSpiResourceC$1$__nesc_unnamed4299 {
  BlazeSpiResourceC$1$CLIENT_ID = 1U
};
enum /*BlazeInitC.DeepSleepResourceC*/BlazeSpiResourceC$2$__nesc_unnamed4300 {
  BlazeSpiResourceC$2$CLIENT_ID = 2U
};
enum /*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$__nesc_unnamed4301 {
  BlazeSpiResourceC$3$CLIENT_ID = 3U
};
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void TUnitP$waitForSendDone$runTask(void);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDownOneTime$default$run(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void TUnitP$begin$runTask(void);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDown$default$run(void);
# 39 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
static  void TUnitP$TestCase$default$run(
# 75 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1a9c4d98);
# 41 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
static   void TUnitP$TestCase$done(
# 75 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1a9c4d98);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t TUnitP$Init$init(void);
# 61 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
static  void TUnitP$TUnitProcessing$tearDownOneTime(void);
#line 57
static  void TUnitP$TUnitProcessing$run(void);

static  void TUnitP$TUnitProcessing$ping(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void TUnitP$runDone$runTask(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void TUnitP$SerialSplitControl$startDone(error_t arg_0x1a9f18d8);
#line 117
static  void TUnitP$SerialSplitControl$stopDone(error_t arg_0x1a9f0640);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$SetUp$default$run(void);
#line 38
static  void TUnitP$SetUpOneTime$default$run(void);
# 46 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/StatsQuery.nc"
static  bool TUnitP$StatsQuery$default$isIdle(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$Init$init(void);
#line 51
static  error_t MotePlatformC$Init$init(void);
# 35 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
static  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void);
#line 32
static  void Msp430ClockP$Msp430ClockInit$default$initTimerB(void);



static  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void);
#line 31
static  void Msp430ClockP$Msp430ClockInit$default$initTimerA(void);





static  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void);
#line 34
static  void Msp430ClockP$Msp430ClockInit$defaultSetupDcoCalibrate(void);
#line 29
static  void Msp430ClockP$Msp430ClockInit$default$setupDcoCalibrate(void);
static  void Msp430ClockP$Msp430ClockInit$default$initClocks(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t Msp430ClockP$Init$init(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1ab600f8);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1ab600f8);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void);
# 33 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t arg_0x1ab44d58);
# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(
# 45 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a924b28);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$default$runTask(
# 45 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a924b28);
# 46 "/svn/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void SchedulerBasicP$Scheduler$init(void);
#line 61
static  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 54
static  bool SchedulerBasicP$Scheduler$runNextTask(void);
# 54 "/svn/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 59 "/svn/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void McuSleepC$McuSleep$sleep(void);
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void Link_TUnitProcessingP$SerialEventSend$sendDone(message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8);
# 49 "/svn/tinyos-2.x/tos/interfaces/Boot.nc"
static  void Link_TUnitProcessingP$Boot$booted(void);
# 47 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
static   void Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1a9d3010, char *arg_0x1a9d31b0, uint32_t arg_0x1a9d3348, uint32_t arg_0x1a9d34d8);
#line 41
static   void Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1a9d54c0, char *arg_0x1a9d5660, uint32_t arg_0x1a9d57f8, uint32_t arg_0x1a9d5988);



static   void Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1a9d4660, char *arg_0x1a9d4800, uint32_t arg_0x1a9d4998, uint32_t arg_0x1a9d4b28);



static   void Link_TUnitProcessingP$TUnitProcessing$testFailed(uint8_t arg_0x1a9d3998, char *arg_0x1a9d3b38);
#line 43
static   void Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1a9d5e50, char *arg_0x1a9d4010, uint32_t arg_0x1a9d41a0);
#line 39
static   void Link_TUnitProcessingP$TUnitProcessing$testSuccess(uint8_t arg_0x1a9d5010);
#line 52
static  void Link_TUnitProcessingP$TUnitProcessing$allDone(void);

static  void Link_TUnitProcessingP$TUnitProcessing$pong(void);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *Link_TUnitProcessingP$SerialReceive$receive(message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void Link_TUnitProcessingP$SerialSplitControl$startDone(error_t arg_0x1a9f18d8);
#line 117
static  void Link_TUnitProcessingP$SerialSplitControl$stopDone(error_t arg_0x1a9f0640);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void Link_TUnitProcessingP$sendEventMsg$runTask(void);
#line 64
static  void Link_TUnitProcessingP$allDone$runTask(void);
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010);
#line 124
static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0);
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(
# 40 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad39bd8, 
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8);
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(
# 38 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad39278, 
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48);
#line 114
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(
# 38 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad39278, 
# 114 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad16ad0, uint8_t arg_0x1ad16c58);
#line 89
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(
# 38 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad39278, 
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);
#line 64
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask(void);
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(
# 36 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad78118, 
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010);
#line 124
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(
# 36 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad78118, 
# 124 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0);
# 67 "/svn/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *arg_0x1ace1468);
#line 106
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *arg_0x1ace0840, uint8_t arg_0x1ace09c8);
#line 95
static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$maxPayloadLength(void);
#line 83
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *arg_0x1ace1ad8, uint8_t arg_0x1ace1c60);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(
# 37 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad78a48, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 67 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *arg_0x1acf68f0);
#line 92
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *arg_0x1acf54c8, am_addr_t arg_0x1acf5658);
#line 136
static  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *arg_0x1acf4dd8);
#line 151
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *arg_0x1acf2398, am_id_t arg_0x1acf2520);
# 83 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t SerialP$SplitControl$start(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$stopDoneTask$runTask(void);
#line 64
static  void SerialP$RunTx$runTask(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t SerialP$Init$init(void);
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
static  void SerialP$SerialFlush$flushDone(void);
#line 38
static  void SerialP$SerialFlush$default$flush(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$startDoneTask$runTask(void);
# 83 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   void SerialP$SerialFrameComm$dataReceived(uint8_t arg_0x1add28d0);





static   void SerialP$SerialFrameComm$putDone(void);
#line 74
static   void SerialP$SerialFrameComm$delimiterReceived(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$defaultSerialFlushTask$runTask(void);
# 60 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   error_t SerialP$SendBytePacket$completeSend(void);
#line 51
static   error_t SerialP$SendBytePacket$startSend(uint8_t arg_0x1adc1170);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(
# 40 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5b960, 
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48);
#line 89
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(
# 40 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5b960, 
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(
# 39 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5b3a8, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380, 
# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1adb4d58, uint8_t arg_0x1adb4ee8);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380);
# 23 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380, 
# 23 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1adb4560, uint8_t arg_0x1adb46f0);
# 70 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);









static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t arg_0x1adc0188);
# 51 "/svn/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);






static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t arg_0x1add99f0);










static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t arg_0x1add8010);
# 79 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
static   void HdlcTranslateC$UartStream$receivedByte(uint8_t arg_0x1ae94d60);
#line 99
static   void HdlcTranslateC$UartStream$receiveDone(uint8_t *arg_0x1ae93b08, uint16_t arg_0x1ae93c98, error_t arg_0x1ae93e20);
#line 57
static   void HdlcTranslateC$UartStream$sendDone(uint8_t *arg_0x1ae95c60, uint16_t arg_0x1ae95df0, error_t arg_0x1ae94010);
# 45 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void);
#line 68
static   void HdlcTranslateC$SerialFrameComm$resetReceive(void);
#line 54
static   error_t HdlcTranslateC$SerialFrameComm$putData(uint8_t arg_0x1add3688);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(
# 43 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af06328);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(
# 43 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af06328);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_union_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(
# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af040f8);
# 48 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *arg_0x1ae954c8, uint16_t arg_0x1ae95658);
# 71 "/svn/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(
# 48 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af05778);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(
# 48 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af05778);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(
# 48 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af05778);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(
# 42 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af07910);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(
# 42 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af07910);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(
# 42 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af07910);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void);
# 143 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430Usart1P$Usart$enableUartRx(void);
#line 123
static   void HplMsp430Usart1P$Usart$enableUart(void);
#line 97
static   void HplMsp430Usart1P$Usart$resetUsart(bool arg_0x1af1b990);
#line 179
static   void HplMsp430Usart1P$Usart$disableIntr(void);
#line 90
static   void HplMsp430Usart1P$Usart$setUmctl(uint8_t arg_0x1af1b168);
#line 133
static   void HplMsp430Usart1P$Usart$enableUartTx(void);
#line 148
static   void HplMsp430Usart1P$Usart$disableUartRx(void);
#line 182
static   void HplMsp430Usart1P$Usart$enableIntr(void);
#line 207
static   void HplMsp430Usart1P$Usart$clrIntr(void);
#line 80
static   void HplMsp430Usart1P$Usart$setUbr(uint16_t arg_0x1af1c8e0);
#line 224
static   void HplMsp430Usart1P$Usart$tx(uint8_t arg_0x1af13c68);
#line 128
static   void HplMsp430Usart1P$Usart$disableUart(void);
#line 174
static   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_union_config_t *arg_0x1af150a8);
#line 158
static   void HplMsp430Usart1P$Usart$disableSpi(void);
#line 138
static   void HplMsp430Usart1P$Usart$disableUartTx(void);
# 74 "/svn/tinyos-2.x/tos/interfaces/AsyncStdControl.nc"
static   error_t HplMsp430Usart1P$AsyncStdControl$start(void);









static   error_t HplMsp430Usart1P$AsyncStdControl$stop(void);
# 64 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeInput(void);






static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeOutput(void);
#line 39
static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$clr(void);
#line 64
static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeInput(void);






static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeOutput(void);
#line 39
static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$clr(void);
#line 85
static   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc(void);
#line 78
static   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc(void);






static   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc(void);
#line 78
static   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc(void);






static   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc(void);
#line 78
static   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc(void);






static   void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc(void);
#line 85
static   void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc(void);
#line 85
static   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc(void);
#line 78
static   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc(void);






static   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc(void);
#line 78
static   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc(void);






static   void /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc(void);
#line 85
static   void /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc(void);
#line 85
static   void /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc(void);
#line 71
static   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set(void);
#line 71
static   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set(void);
#line 71
static   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set(void);
#line 71
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$makeOutput(void);
#line 59
static   bool /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$get(void);
#line 52
static   uint8_t /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$getRaw(void);
#line 34
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$set(void);




static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$clr(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t LedsP$Init$init(void);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410, 
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);
# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 56 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
# 52 "/svn/tinyos-2.x/tos/lib/power/PowerDownCleanup.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void);
# 46 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$granted(void);
#line 81
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$immediateRequested(void);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_union_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void TelosSerialP$Resource$granted(void);
# 74 "/svn/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t TelosSerialP$StdControl$start(void);









static  error_t TelosSerialP$StdControl$stop(void);
# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *arg_0x1adb4d58, uint8_t arg_0x1adb4ee8);
#line 15
static   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);







static   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *arg_0x1adb4560, uint8_t arg_0x1adb46f0);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t StateImplP$Init$init(void);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t StateImplP$State$getState(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8);
# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   void StateImplP$State$toIdle(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8);
# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   bool StateImplP$State$isState(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8, 
# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x1a9e0d10);
#line 61
static   bool StateImplP$State$isIdle(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8);
# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   error_t StateImplP$State$requestState(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8, 
# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x1a9e1ba0);





static   void StateImplP$State$forceState(
# 67 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x1b3905a8, 
# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x1a9e0170);
# 44 "/svn/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static   am_addr_t ActiveMessageAddressC$amAddress(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t ActiveMessageAddressC$ActiveMessageAddress$amAddress(void);
# 39 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
static  void TestP$TestCC1100Control$run(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void TestP$SplitControl$startDone(error_t arg_0x1a9f18d8);
#line 117
static  void TestP$SplitControl$stopDone(error_t arg_0x1a9f0640);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void TestP$Resource$granted(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
static  error_t BlazeSpiP$RadioInit$init(uint8_t arg_0x1b413718, uint8_t *arg_0x1b4138c8, uint8_t arg_0x1b413a50);
# 71 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void BlazeSpiP$SpiPacket$sendDone(uint8_t *arg_0x1b431030, uint8_t *arg_0x1b4311d8, uint16_t arg_0x1b431368, 
error_t arg_0x1b431500);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void BlazeSpiP$radioInitDone$runTask(void);
# 64 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   error_t BlazeSpiP$Fifo$continueRead(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 64 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3ee4d8, uint8_t arg_0x1b3ee660);
#line 93
static   void BlazeSpiP$Fifo$default$writeDone(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3ecd60, uint8_t arg_0x1b3ecee8, error_t arg_0x1b3eb088);
#line 84
static   blaze_status_t BlazeSpiP$Fifo$write(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 84 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3ec5d8, uint8_t arg_0x1b3ec760);
#line 53
static   blaze_status_t BlazeSpiP$Fifo$beginRead(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 53 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3efd28, uint8_t arg_0x1b3efeb0);
#line 73
static   void BlazeSpiP$Fifo$default$readDone(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 73 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3eec90, uint8_t arg_0x1b3eee18, error_t arg_0x1b3ec010);
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/ChipSpiResource.nc"
static   void BlazeSpiP$ChipSpiResource$default$releasing(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
static   blaze_status_t BlazeSpiP$RadioStatus$getRadioStatus(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeSpiP$SpiResource$granted(void);
#line 110
static   error_t BlazeSpiP$Resource$release(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeSpiP$Resource$immediateRequest(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeSpiP$Resource$request(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeSpiP$Resource$default$granted(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool BlazeSpiP$Resource$isOwner(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void BlazeSpiP$grant$runTask(void);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeSpiP$Strobe$strobe(
# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4076f0);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(
# 41 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4830b8);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(
# 41 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4830b8);
# 59 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(
# 43 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b483ab0, 
# 59 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x1b432598, uint8_t *arg_0x1b432740, uint16_t arg_0x1b4328d0);
#line 71
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(
# 43 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b483ab0, 
# 71 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x1b431030, uint8_t *arg_0x1b4311d8, uint16_t arg_0x1b431368, 
error_t arg_0x1b431500);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(
# 46 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b482b10);
# 34 "/svn/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(uint8_t arg_0x1b4003e0);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void);
# 180 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430Usart0P$Usart$enableRxIntr(void);
#line 197
static   void HplMsp430Usart0P$Usart$clrRxIntr(void);
#line 97
static   void HplMsp430Usart0P$Usart$resetUsart(bool arg_0x1af1b990);
#line 179
static   void HplMsp430Usart0P$Usart$disableIntr(void);
#line 90
static   void HplMsp430Usart0P$Usart$setUmctl(uint8_t arg_0x1af1b168);
#line 177
static   void HplMsp430Usart0P$Usart$disableRxIntr(void);









static   bool HplMsp430Usart0P$Usart$isTxIntrPending(void);
#line 207
static   void HplMsp430Usart0P$Usart$clrIntr(void);
#line 80
static   void HplMsp430Usart0P$Usart$setUbr(uint16_t arg_0x1af1c8e0);
#line 224
static   void HplMsp430Usart0P$Usart$tx(uint8_t arg_0x1af13c68);
#line 128
static   void HplMsp430Usart0P$Usart$disableUart(void);
#line 153
static   void HplMsp430Usart0P$Usart$enableSpi(void);
#line 168
static   void HplMsp430Usart0P$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x1af17a88);
#line 231
static   uint8_t HplMsp430Usart0P$Usart$rx(void);
#line 192
static   bool HplMsp430Usart0P$Usart$isRxIntrPending(void);









static   void HplMsp430Usart0P$Usart$clrTxIntr(void);
#line 158
static   void HplMsp430Usart0P$Usart$disableSpi(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$rxDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410, 
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$txDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawI2CInterrupts$fired(void);
#line 39
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$default$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b265368);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$txDone(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$Init$init(void);
# 69 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$enqueue(resource_client_id_t arg_0x1b2a8a98);
#line 43
static   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEmpty(void);








static   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEnqueued(resource_client_id_t arg_0x1b2a80b0);







static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$dequeue(void);
# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$requested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$immediateRequested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$unconfigure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$configure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 56 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$release(void);
#line 73
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$requested(void);
#line 46
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$granted(void);
#line 81
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$immediateRequested(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$release(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$immediateRequest(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$request(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$default$granted(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$isOwner(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$userId(void);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$runTask(void);
# 7 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static   void HplMsp430I2C0P$HplI2C$clearModeI2C(void);
#line 6
static   bool HplMsp430I2C0P$HplI2C$isI2C(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeRegSettings.nc"
static  uint8_t *CC1100ControlP$BlazeRegSettings$getDefaultRegisters(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC1100ControlP$SoftwareInit$init(void);
# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeCommit.nc"
static  void CC1100ControlP$BlazeCommit$commitDone(void);
# 75 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
static   bool CC1100ControlP$BlazeConfig$isAutoAckEnabled(void);
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void HplMsp430InterruptP$Port14$clear(void);
#line 61
static   void HplMsp430InterruptP$Port14$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port26$clear(void);
#line 36
static   void HplMsp430InterruptP$Port26$disable(void);
#line 56
static   void HplMsp430InterruptP$Port26$edge(bool arg_0x1b682010);
#line 31
static   void HplMsp430InterruptP$Port26$enable(void);









static   void HplMsp430InterruptP$Port17$clear(void);
#line 61
static   void HplMsp430InterruptP$Port17$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port21$clear(void);
#line 61
static   void HplMsp430InterruptP$Port21$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port12$clear(void);
#line 61
static   void HplMsp430InterruptP$Port12$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port24$clear(void);
#line 61
static   void HplMsp430InterruptP$Port24$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port15$clear(void);
#line 61
static   void HplMsp430InterruptP$Port15$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port27$clear(void);
#line 61
static   void HplMsp430InterruptP$Port27$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port10$clear(void);
#line 61
static   void HplMsp430InterruptP$Port10$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port22$clear(void);
#line 61
static   void HplMsp430InterruptP$Port22$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port13$clear(void);
#line 61
static   void HplMsp430InterruptP$Port13$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port25$clear(void);
#line 61
static   void HplMsp430InterruptP$Port25$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port16$clear(void);
#line 61
static   void HplMsp430InterruptP$Port16$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port20$clear(void);
#line 61
static   void HplMsp430InterruptP$Port20$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port11$clear(void);
#line 61
static   void HplMsp430InterruptP$Port11$default$fired(void);
#line 41
static   void HplMsp430InterruptP$Port23$clear(void);
#line 61
static   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$fired(void);
#line 61
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$fired(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$disable(void);
#line 42
static   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$enableRisingEdge(void);
# 32 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$get(void);


static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$makeOutput(void);
#line 29
static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set(void);
static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr(void);


static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeInput(void);

static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeOutput(void);
#line 30
static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$clr(void);


static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeInput(void);

static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeOutput(void);
#line 30
static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$clr(void);




static   void DummyIoP$GeneralIO$makeOutput(void);
#line 29
static   void DummyIoP$GeneralIO$set(void);
static   void DummyIoP$GeneralIO$clr(void);
# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void HplCC1100PinsP$Gdo2_int$fired(void);
#line 57
static   void HplCC1100PinsP$Gdo0_int$fired(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void BlazeInitP$SplitControl$default$startDone(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010, 
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
error_t arg_0x1a9f18d8);
#line 117
static  void BlazeInitP$SplitControl$default$stopDone(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010, 
# 117 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
error_t arg_0x1a9f0640);
#line 83
static  error_t BlazeInitP$SplitControl$start(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010);
# 109 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t BlazeInitP$SplitControl$stop(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeRegSettings.nc"
static  uint8_t *BlazeInitP$BlazeRegSettings$default$getDefaultRegisters(
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767a80);
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
static  void BlazeInitP$RadioInit$initDone(void);
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static   error_t BlazeInitP$BlazePower$deepSleep(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static  void BlazeInitP$BlazePower$default$resetComplete(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static   error_t BlazeInitP$BlazePower$reset(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static   void BlazeInitP$BlazePower$shutdown(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 47 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static  void BlazeInitP$BlazePower$default$deepSleepComplete(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeInitP$ResetResource$granted(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t BlazeInitP$Init$init(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo0_int$default$disable(
# 42 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b768958);
# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeCommit.nc"
static  void BlazeInitP$BlazeCommit$default$commitDone(
# 31 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76d308);
# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$default$makeInput(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$default$makeOutput(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$default$clr(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$default$makeInput(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$default$makeOutput(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$default$clr(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo2_int$default$disable(
# 43 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767218);
# 43 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo2_int$default$enableFallingEdge(
# 43 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767218);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Power$default$set(
# 38 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76c888);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Power$default$clr(
# 38 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76c888);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Csn$default$set(
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76b4f0);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Csn$default$clr(
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76b4f0);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeInitP$DeepSleepResource$granted(void);
# 8 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   error_t BlazeTransmitP$AckSend$send(
# 21 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831ce0);
# 6 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   error_t BlazeTransmitP$AckSend$load(
# 21 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831ce0, 
# 6 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83ba28);
# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void BlazeTransmitP$TxInterrupt$fired(
# 26 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b82e238);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeTransmitP$TxInterrupt$default$disable(
# 26 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b82e238);
# 42 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeTransmitP$TxInterrupt$default$enableRisingEdge(
# 26 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b82e238);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   void BlazeTransmitP$AsyncSend$default$loadDone(
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831458, 
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83a218, error_t arg_0x1b83a3a0);

static   void BlazeTransmitP$AsyncSend$default$sendDone(
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831458);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeTransmitP$Csn$default$set(
# 25 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b830610);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeTransmitP$Csn$default$clr(
# 25 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b830610);
# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   void BlazeTransmitP$TXFIFO$writeDone(uint8_t *arg_0x1b3ecd60, uint8_t arg_0x1b3ecee8, error_t arg_0x1b3eb088);
#line 73
static   void BlazeTransmitP$TXFIFO$readDone(uint8_t *arg_0x1b3eec90, uint8_t arg_0x1b3eee18, error_t arg_0x1b3ec010);
# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/PacketCrc.nc"
static   void PacketCrcP$PacketCrc$appendCrc(uint8_t *arg_0x1b821e48);
#line 40
static   bool PacketCrcP$PacketCrc$verifyCrc(uint8_t *arg_0x1b820550);
# 41 "/svn/tinyos-2.x/tos/interfaces/Crc.nc"
static  uint16_t CrcC$Crc$crc16(void *arg_0x1b89b6d0, uint8_t arg_0x1b89b858);
# 44 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
static   blaze_header_t *BlazePacketP$BlazePacketBody$getHeader(message_t *arg_0x1b8285a0);




static   blaze_metadata_t *BlazePacketP$BlazePacketBody$getMetadata(message_t *arg_0x1b828af0);
# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void BlazeReceiveP$RxInterrupt$fired(
# 25 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d0010);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   void BlazeReceiveP$AckSend$loadDone(
# 23 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d3a68, 
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83a218, error_t arg_0x1b83a3a0);

static   void BlazeReceiveP$AckSend$sendDone(
# 23 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d3a68);
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/ReceiveController.nc"
static   error_t BlazeReceiveP$ReceiveController$beginReceive(
# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d4de8);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AckReceive.nc"
static   void BlazeReceiveP$AckReceive$default$receive(am_addr_t arg_0x1b8a0838, am_addr_t arg_0x1b8a09d0, uint8_t arg_0x1b8a0b58);
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void BlazeReceiveP$receiveDone$runTask(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t BlazeReceiveP$Init$init(void);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *BlazeReceiveP$Receive$default$receive(
# 15 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d4820, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   void BlazeReceiveP$RXFIFO$writeDone(uint8_t *arg_0x1b3ecd60, uint8_t arg_0x1b3ecee8, error_t arg_0x1b3eb088);
#line 73
static   void BlazeReceiveP$RXFIFO$readDone(uint8_t *arg_0x1b3eec90, uint8_t arg_0x1b3eee18, error_t arg_0x1b3ec010);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeReceiveP$Resource$granted(void);
# 75 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
static   bool BlazeReceiveP$BlazeConfig$default$isAutoAckEnabled(
# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8cf4c8);
# 19 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
static  void BlazeReceiveP$BlazeConfig$commitDone(
# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8cf4c8);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeReceiveP$Csn$default$set(
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d2330);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeReceiveP$Csn$default$clr(
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d2330);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t TUnitP$waitForSendDone$postTask(void);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDownOneTime$run(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t TUnitP$begin$postTask(void);
# 61 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   bool TUnitP$SendState$isIdle(void);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDown$run(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t TUnitP$ActiveMessageAddress$amAddress(void);
# 39 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
static  void TUnitP$TestCase$run(
# 75 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1a9c4d98);
# 47 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
static   void TUnitP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1a9d3010, char *arg_0x1a9d31b0, uint32_t arg_0x1a9d3348, uint32_t arg_0x1a9d34d8);
#line 41
static   void TUnitP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1a9d54c0, char *arg_0x1a9d5660, uint32_t arg_0x1a9d57f8, uint32_t arg_0x1a9d5988);



static   void TUnitP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1a9d4660, char *arg_0x1a9d4800, uint32_t arg_0x1a9d4998, uint32_t arg_0x1a9d4b28);



static   void TUnitP$TUnitProcessing$testFailed(uint8_t arg_0x1a9d3998, char *arg_0x1a9d3b38);
#line 43
static   void TUnitP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1a9d5e50, char *arg_0x1a9d4010, uint32_t arg_0x1a9d41a0);
#line 39
static   void TUnitP$TUnitProcessing$testSuccess(uint8_t arg_0x1a9d5010);
#line 52
static  void TUnitP$TUnitProcessing$allDone(void);

static  void TUnitP$TUnitProcessing$pong(void);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t TUnitP$TestState$getState(void);
#line 56
static   void TUnitP$TestState$toIdle(void);
#line 45
static   error_t TUnitP$TestState$requestState(uint8_t arg_0x1a9e1ba0);





static   void TUnitP$TestState$forceState(uint8_t arg_0x1a9e0170);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t TUnitP$runDone$postTask(void);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t TUnitP$TUnitState$getState(void);
#line 61
static   bool TUnitP$TUnitState$isIdle(void);
#line 51
static   void TUnitP$TUnitState$forceState(uint8_t arg_0x1a9e0170);
# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$SetUp$run(void);
#line 38
static  void TUnitP$SetUpOneTime$run(void);
# 46 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/StatsQuery.nc"
static  bool TUnitP$StatsQuery$isIdle(void);
# 131 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
enum TUnitP$__nesc_unnamed4302 {
#line 131
  TUnitP$begin = 0U
};
#line 131
typedef int TUnitP$__nesc_sillytask_begin[TUnitP$begin];
enum TUnitP$__nesc_unnamed4303 {
#line 132
  TUnitP$waitForSendDone = 1U
};
#line 132
typedef int TUnitP$__nesc_sillytask_waitForSendDone[TUnitP$waitForSendDone];
enum TUnitP$__nesc_unnamed4304 {
#line 133
  TUnitP$runDone = 2U
};
#line 133
typedef int TUnitP$__nesc_sillytask_runDone[TUnitP$runDone];
#line 98
 uint8_t TUnitP$currentTest;





bool TUnitP$driver;




enum TUnitP$__nesc_unnamed4305 {
  TUnitP$S_NOT_BOOTED, 
  TUnitP$S_READY, 
  TUnitP$S_RUNNING
};




enum TUnitP$__nesc_unnamed4306 {
  TUnitP$S_IDLE, 
  TUnitP$S_SETUP_ONETIME, 

  TUnitP$S_SETUP, 
  TUnitP$S_RUN, 
  TUnitP$S_TEARDOWN, 

  TUnitP$S_TEARDOWN_ONETIME
};







static void TUnitP$setUpOneTimeDone(void);
static inline void TUnitP$setUpDone(void);
static inline void TUnitP$tearDownDone(void);
static inline void TUnitP$tearDownOneTimeDone(void);
static void TUnitP$attemptTest(void);


static inline  error_t TUnitP$Init$init(void);









static inline  void TUnitP$SerialSplitControl$startDone(error_t error);
#line 168
static inline  void TUnitP$SerialSplitControl$stopDone(error_t error);



static inline  void TUnitP$TUnitProcessing$run(void);





static inline  void TUnitP$TUnitProcessing$ping(void);



static inline  void TUnitP$TUnitProcessing$tearDownOneTime(void);







static inline   void TUnitP$TestCase$done(uint8_t testId);




void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual) __attribute((noinline))   ;





void assertNotEqualsFailed(char *failMsg, uint32_t actual) __attribute((noinline))   ;





void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual) __attribute((noinline))   ;





void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual) __attribute((noinline))   ;





void assertSuccess(void) __attribute((noinline))   ;






void assertFail(char *failMsg) __attribute((noinline))   ;
#line 260
static void TUnitP$setUpOneTimeDone(void);
#line 272
static inline void TUnitP$setUpDone(void);







static inline void TUnitP$tearDownDone(void);







static inline void TUnitP$tearDownOneTimeDone(void);





static void TUnitP$attemptTest(void);
#line 313
static inline  void TUnitP$begin$runTask(void);









static inline  void TUnitP$waitForSendDone$runTask(void);
#line 335
static inline  void TUnitP$runDone$runTask(void);








static inline   void TUnitP$SetUpOneTime$default$run(void);



static inline   void TUnitP$SetUp$default$run(void);



static inline   void TUnitP$TestCase$default$run(uint8_t testId);



static inline   void TUnitP$TearDown$default$run(void);



static inline   void TUnitP$TearDownOneTime$default$run(void);







static inline   bool TUnitP$StatsQuery$default$isIdle(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$MoteInit$init(void);
#line 51
static  error_t PlatformP$MoteClockInit$init(void);
#line 51
static  error_t PlatformP$LedsInit$init(void);
# 10 "/svn/tinyos-2.x/tos/platforms/telosa/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void);
# 6 "../../../../../../../../../../blaze/tos/platforms/tmote1100/MotePlatformC.nc"
static __inline void MotePlatformC$uwait(uint16_t u);




static __inline void MotePlatformC$TOSH_wait(void);




static void MotePlatformC$TOSH_FLASH_M25P_DP_bit(bool set);










static inline void MotePlatformC$TOSH_FLASH_M25P_DP(void);
#line 56
static inline  error_t MotePlatformC$Init$init(void);
# 32 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
static  void Msp430ClockP$Msp430ClockInit$initTimerB(void);
#line 31
static  void Msp430ClockP$Msp430ClockInit$initTimerA(void);
#line 29
static  void Msp430ClockP$Msp430ClockInit$setupDcoCalibrate(void);
static  void Msp430ClockP$Msp430ClockInit$initClocks(void);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
 static volatile uint8_t Msp430ClockP$IE1 __asm ("0x0000");
 static volatile uint16_t Msp430ClockP$TA0CTL __asm ("0x0160");
 static volatile uint16_t Msp430ClockP$TA0IV __asm ("0x012E");
 static volatile uint16_t Msp430ClockP$TBCTL __asm ("0x0180");
 static volatile uint16_t Msp430ClockP$TBIV __asm ("0x011E");

enum Msp430ClockP$__nesc_unnamed4307 {

  Msp430ClockP$ACLK_CALIB_PERIOD = 8, 
  Msp430ClockP$TARGET_DCO_DELTA = 4096 / 32 * Msp430ClockP$ACLK_CALIB_PERIOD
};


static inline  void Msp430ClockP$Msp430ClockInit$defaultSetupDcoCalibrate(void);
#line 64
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void);
#line 85
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void);
#line 100
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void);
#line 115
static inline   void Msp430ClockP$Msp430ClockInit$default$setupDcoCalibrate(void);




static inline   void Msp430ClockP$Msp430ClockInit$default$initClocks(void);




static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerA(void);




static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerB(void);





static inline void Msp430ClockP$startTimerA(void);
#line 148
static inline void Msp430ClockP$startTimerB(void);
#line 160
static void Msp430ClockP$set_dco_calib(int calib);





static inline uint16_t Msp430ClockP$test_calib_busywait_delta(int calib);
#line 189
static inline void Msp430ClockP$busyCalibrateDco(void);
#line 214
static inline  error_t Msp430ClockP$Init$init(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1ab600f8);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow(void);
# 115 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);








static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1ab600f8);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow(void);
# 115 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);








static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t;


static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t;


static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t;


static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t;


static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t;


static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t;


static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t;


static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t;


static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t;


static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void);
# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x1ab44d58);
# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void);
# 44 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t;


static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(uint16_t x);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void);
# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void Msp430TimerCommonP$VectorTimerB1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA0$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerB0$fired(void);
# 11 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
void sig_TIMERA0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(12))) ;
void sig_TIMERA1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(10))) ;
void sig_TIMERB0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(26))) ;
void sig_TIMERB1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(24))) ;
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$SoftwareInit$init(void);
# 49 "/svn/tinyos-2.x/tos/interfaces/Boot.nc"
static  void RealMainP$Boot$booted(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$PlatformInit$init(void);
# 46 "/svn/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void RealMainP$Scheduler$init(void);
#line 61
static  void RealMainP$Scheduler$taskLoop(void);
#line 54
static  bool RealMainP$Scheduler$runNextTask(void);
# 52 "/svn/tinyos-2.x/tos/system/RealMainP.nc"
int main(void)   ;
# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(
# 45 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a924b28);
# 59 "/svn/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void SchedulerBasicP$McuSleep$sleep(void);
# 50 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP$__nesc_unnamed4308 {

  SchedulerBasicP$NUM_TASKS = 19U, 
  SchedulerBasicP$NO_TASK = 255
};

volatile uint8_t SchedulerBasicP$m_head;
volatile uint8_t SchedulerBasicP$m_tail;
volatile uint8_t SchedulerBasicP$m_next[SchedulerBasicP$NUM_TASKS];








static __inline uint8_t SchedulerBasicP$popTask(void);
#line 86
static inline bool SchedulerBasicP$isWaiting(uint8_t id);




static inline bool SchedulerBasicP$pushTask(uint8_t id);
#line 113
static inline  void SchedulerBasicP$Scheduler$init(void);









static  bool SchedulerBasicP$Scheduler$runNextTask(void);
#line 138
static inline  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 159
static   error_t SchedulerBasicP$TaskBasic$postTask(uint8_t id);




static   void SchedulerBasicP$TaskBasic$default$runTask(uint8_t id);
# 54 "/svn/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void);
# 51 "/svn/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
bool McuSleepC$dirty = TRUE;
mcu_power_t McuSleepC$powerState = MSP430_POWER_ACTIVE;




const uint16_t McuSleepC$msp430PowerBits[MSP430_POWER_LPM4 + 1] = { 
0, 
0x0010, 
0x0040 + 0x0010, 
0x0080 + 0x0010, 
0x0080 + 0x0040 + 0x0010, 
0x0080 + 0x0040 + 0x0020 + 0x0010 };


static inline mcu_power_t McuSleepC$getPowerState(void);
#line 104
static inline void McuSleepC$computePowerState(void);




static inline   void McuSleepC$McuSleep$sleep(void);
#line 124
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t Link_TUnitProcessingP$SerialEventSend$send(am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010);
#line 124
static  void *Link_TUnitProcessingP$SerialEventSend$getPayload(message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t Link_TUnitProcessingP$SerialState$getState(void);
#line 51
static   void Link_TUnitProcessingP$SerialState$forceState(uint8_t arg_0x1a9e0170);




static   void Link_TUnitProcessingP$SendState$toIdle(void);




static   bool Link_TUnitProcessingP$SendState$isIdle(void);
#line 51
static   void Link_TUnitProcessingP$SendState$forceState(uint8_t arg_0x1a9e0170);
# 61 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
static  void Link_TUnitProcessingP$TUnitProcessing$tearDownOneTime(void);
#line 57
static  void Link_TUnitProcessingP$TUnitProcessing$run(void);

static  void Link_TUnitProcessingP$TUnitProcessing$ping(void);
# 83 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t Link_TUnitProcessingP$SerialSplitControl$start(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t Link_TUnitProcessingP$sendEventMsg$postTask(void);
#line 56
static   error_t Link_TUnitProcessingP$allDone$postTask(void);
# 85 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
enum Link_TUnitProcessingP$__nesc_unnamed4309 {
#line 85
  Link_TUnitProcessingP$sendEventMsg = 3U
};
#line 85
typedef int Link_TUnitProcessingP$__nesc_sillytask_sendEventMsg[Link_TUnitProcessingP$sendEventMsg];
enum Link_TUnitProcessingP$__nesc_unnamed4310 {
#line 86
  Link_TUnitProcessingP$allDone = 4U
};
#line 86
typedef int Link_TUnitProcessingP$__nesc_sillytask_allDone[Link_TUnitProcessingP$allDone];
#line 55
message_t Link_TUnitProcessingP$eventMsg[5];


uint8_t Link_TUnitProcessingP$writingEventMsg;


uint8_t Link_TUnitProcessingP$sendingEventMsg;




enum Link_TUnitProcessingP$__nesc_unnamed4311 {
  Link_TUnitProcessingP$S_OFF, 
  Link_TUnitProcessingP$S_ON
};




enum Link_TUnitProcessingP$__nesc_unnamed4312 {
  Link_TUnitProcessingP$S_IDLE, 
  Link_TUnitProcessingP$S_BUSY
};

enum Link_TUnitProcessingP$__nesc_unnamed4313 {
  Link_TUnitProcessingP$EMPTY = 0xFF
};


static inline void Link_TUnitProcessingP$execute(TUnitProcessingMsg *inMsg);



static error_t Link_TUnitProcessingP$insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual);
static void Link_TUnitProcessingP$attemptEventSend(void);


static inline  void Link_TUnitProcessingP$Boot$booted(void);










static inline  void Link_TUnitProcessingP$SerialSplitControl$startDone(error_t error);



static inline  void Link_TUnitProcessingP$SerialSplitControl$stopDone(error_t error);




static inline  message_t *Link_TUnitProcessingP$SerialReceive$receive(message_t *msg, void *payload, uint8_t len);





static  void Link_TUnitProcessingP$SerialEventSend$sendDone(message_t *msg, error_t error);










static inline   void Link_TUnitProcessingP$TUnitProcessing$testSuccess(uint8_t testId);



static inline   void Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual);



static inline   void Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(uint8_t testId, char *failMsg, uint32_t actual);



static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(uint8_t testId, char *failMsg, uint32_t upperbound, uint32_t actual);



static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(uint8_t testId, char *failMsg, uint32_t lowerbound, uint32_t actual);



static inline   void Link_TUnitProcessingP$TUnitProcessing$testFailed(uint8_t testId, char *failMsg);




static inline  void Link_TUnitProcessingP$TUnitProcessing$allDone(void);



static inline  void Link_TUnitProcessingP$TUnitProcessing$pong(void);





static inline  void Link_TUnitProcessingP$sendEventMsg$runTask(void);








static inline  void Link_TUnitProcessingP$allDone$runTask(void);






static inline void Link_TUnitProcessingP$execute(TUnitProcessingMsg *inMsg);
#line 203
static error_t Link_TUnitProcessingP$insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual);
#line 265
static void Link_TUnitProcessingP$attemptEventSend(void);
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8);
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48);
#line 114
static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x1ad16ad0, uint8_t arg_0x1ad16c58);
# 92 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x1acf54c8, am_addr_t arg_0x1acf5658);
#line 151
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x1acf2398, am_id_t arg_0x1acf2520);
# 45 "/svn/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err);







static inline  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m, uint8_t len);
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(
# 40 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad39bd8, 
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010);
#line 124
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(
# 40 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad39bd8, 
# 124 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0);
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(
# 38 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad39278, 
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 67 "/svn/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x1ace1468);
#line 83
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x1ace1ad8, uint8_t arg_0x1ace1c60);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask(void);
# 67 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x1acf68f0);
#line 136
static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x1acf4dd8);
# 118 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4314 {
#line 118
  AMQueueImplP$0$CancelTask = 5U
};
#line 118
typedef int /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_sillytask_CancelTask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask];
#line 161
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4315 {
#line 161
  AMQueueImplP$0$errorTask = 6U
};
#line 161
typedef int /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_sillytask_errorTask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask];
#line 49
#line 47
typedef struct /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4316 {
  message_t *msg;
} /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t;

uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = 1;
/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[1];
uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[1 / 8 + 1];

static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);

static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket(void);
#line 82
static inline  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len);
#line 118
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask(void);
#line 155
static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(uint8_t last, message_t *msg, error_t err);





static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);




static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);
#line 181
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(am_id_t id, message_t *msg, error_t err);
#line 203
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m, uint8_t len);



static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err);
# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48);
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(
# 36 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad78118, 
# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(
# 37 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad78a48, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 49 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline serial_header_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(message_t *msg);



static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(am_id_t id, am_addr_t dest, 
message_t *msg, 
uint8_t len);
#line 77
static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(am_id_t id, message_t *m, uint8_t len);



static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *msg, error_t result);







static inline   message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(uint8_t id, message_t *msg, void *payload, uint8_t len);



static inline  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len);







static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len);



static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$maxPayloadLength(void);



static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t len);
#line 127
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg);









static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr);
#line 151
static inline  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void SerialP$SplitControl$startDone(error_t arg_0x1a9f18d8);
#line 117
static  void SerialP$SplitControl$stopDone(error_t arg_0x1a9f0640);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$stopDoneTask$postTask(void);
# 74 "/svn/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t SerialP$SerialControl$start(void);









static  error_t SerialP$SerialControl$stop(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$RunTx$postTask(void);
# 38 "/svn/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
static  void SerialP$SerialFlush$flush(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$startDoneTask$postTask(void);
# 45 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   error_t SerialP$SerialFrameComm$putDelimiter(void);
#line 68
static   void SerialP$SerialFrameComm$resetReceive(void);
#line 54
static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x1add3688);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$defaultSerialFlushTask$postTask(void);
# 70 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   uint8_t SerialP$SendBytePacket$nextByte(void);









static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x1adc0188);
# 51 "/svn/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t SerialP$ReceiveBytePacket$startPacket(void);






static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x1add99f0);










static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x1add8010);
# 189 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
enum SerialP$__nesc_unnamed4317 {
#line 189
  SerialP$RunTx = 7U
};
#line 189
typedef int SerialP$__nesc_sillytask_RunTx[SerialP$RunTx];
#line 320
enum SerialP$__nesc_unnamed4318 {
#line 320
  SerialP$startDoneTask = 8U
};
#line 320
typedef int SerialP$__nesc_sillytask_startDoneTask[SerialP$startDoneTask];





enum SerialP$__nesc_unnamed4319 {
#line 326
  SerialP$stopDoneTask = 9U
};
#line 326
typedef int SerialP$__nesc_sillytask_stopDoneTask[SerialP$stopDoneTask];








enum SerialP$__nesc_unnamed4320 {
#line 335
  SerialP$defaultSerialFlushTask = 10U
};
#line 335
typedef int SerialP$__nesc_sillytask_defaultSerialFlushTask[SerialP$defaultSerialFlushTask];
#line 79
enum SerialP$__nesc_unnamed4321 {
  SerialP$RX_DATA_BUFFER_SIZE = 2, 
  SerialP$TX_DATA_BUFFER_SIZE = 4, 
  SerialP$SERIAL_MTU = 255, 
  SerialP$SERIAL_VERSION = 1, 
  SerialP$ACK_QUEUE_SIZE = 5
};

enum SerialP$__nesc_unnamed4322 {
  SerialP$RXSTATE_NOSYNC, 
  SerialP$RXSTATE_PROTO, 
  SerialP$RXSTATE_TOKEN, 
  SerialP$RXSTATE_INFO, 
  SerialP$RXSTATE_INACTIVE
};

enum SerialP$__nesc_unnamed4323 {
  SerialP$TXSTATE_IDLE, 
  SerialP$TXSTATE_PROTO, 
  SerialP$TXSTATE_SEQNO, 
  SerialP$TXSTATE_INFO, 
  SerialP$TXSTATE_FCS1, 
  SerialP$TXSTATE_FCS2, 
  SerialP$TXSTATE_ENDFLAG, 
  SerialP$TXSTATE_ENDWAIT, 
  SerialP$TXSTATE_FINISH, 
  SerialP$TXSTATE_ERROR, 
  SerialP$TXSTATE_INACTIVE
};





#line 109
typedef enum SerialP$__nesc_unnamed4324 {
  SerialP$BUFFER_AVAILABLE, 
  SerialP$BUFFER_FILLING, 
  SerialP$BUFFER_COMPLETE
} SerialP$tx_data_buffer_states_t;

enum SerialP$__nesc_unnamed4325 {
  SerialP$TX_ACK_INDEX = 0, 
  SerialP$TX_DATA_INDEX = 1, 
  SerialP$TX_BUFFER_COUNT = 2
};






#line 122
typedef struct SerialP$__nesc_unnamed4326 {
  uint8_t writePtr;
  uint8_t readPtr;
  uint8_t buf[SerialP$RX_DATA_BUFFER_SIZE + 1];
} SerialP$rx_buf_t;




#line 128
typedef struct SerialP$__nesc_unnamed4327 {
  uint8_t state;
  uint8_t buf;
} SerialP$tx_buf_t;





#line 133
typedef struct SerialP$__nesc_unnamed4328 {
  uint8_t writePtr;
  uint8_t readPtr;
  uint8_t buf[SerialP$ACK_QUEUE_SIZE + 1];
} SerialP$ack_queue_t;



SerialP$rx_buf_t SerialP$rxBuf;
SerialP$tx_buf_t SerialP$txBuf[SerialP$TX_BUFFER_COUNT];



uint8_t SerialP$rxState;
uint8_t SerialP$rxByteCnt;
uint8_t SerialP$rxProto;
uint8_t SerialP$rxSeqno;
uint16_t SerialP$rxCRC;



 uint8_t SerialP$txState;
 uint8_t SerialP$txByteCnt;
 uint8_t SerialP$txProto;
 uint8_t SerialP$txSeqno;
 uint16_t SerialP$txCRC;
uint8_t SerialP$txPending;
 uint8_t SerialP$txIndex;


SerialP$ack_queue_t SerialP$ackQ;

bool SerialP$offPending = FALSE;



static __inline void SerialP$txInit(void);
static __inline void SerialP$rxInit(void);
static __inline void SerialP$ackInit(void);

static __inline bool SerialP$ack_queue_is_full(void);
static __inline bool SerialP$ack_queue_is_empty(void);
static __inline void SerialP$ack_queue_push(uint8_t token);
static __inline uint8_t SerialP$ack_queue_top(void);
static inline uint8_t SerialP$ack_queue_pop(void);




static __inline void SerialP$rx_buffer_push(uint8_t data);
static __inline uint8_t SerialP$rx_buffer_top(void);
static __inline uint8_t SerialP$rx_buffer_pop(void);
static __inline uint16_t SerialP$rx_current_crc(void);

static void SerialP$rx_state_machine(bool isDelimeter, uint8_t data);
static void SerialP$MaybeScheduleTx(void);




static __inline void SerialP$txInit(void);
#line 205
static __inline void SerialP$rxInit(void);








static __inline void SerialP$ackInit(void);



static inline  error_t SerialP$Init$init(void);
#line 232
static __inline bool SerialP$ack_queue_is_full(void);









static __inline bool SerialP$ack_queue_is_empty(void);





static __inline void SerialP$ack_queue_push(uint8_t token);









static __inline uint8_t SerialP$ack_queue_top(void);









static inline uint8_t SerialP$ack_queue_pop(void);
#line 295
static __inline void SerialP$rx_buffer_push(uint8_t data);



static __inline uint8_t SerialP$rx_buffer_top(void);



static __inline uint8_t SerialP$rx_buffer_pop(void);





static __inline uint16_t SerialP$rx_current_crc(void);










static inline  void SerialP$startDoneTask$runTask(void);





static inline  void SerialP$stopDoneTask$runTask(void);



static inline  void SerialP$SerialFlush$flushDone(void);




static inline  void SerialP$defaultSerialFlushTask$runTask(void);


static inline   void SerialP$SerialFlush$default$flush(void);



static inline  error_t SerialP$SplitControl$start(void);




static void SerialP$testOff(void);
#line 384
static inline   void SerialP$SerialFrameComm$delimiterReceived(void);


static inline   void SerialP$SerialFrameComm$dataReceived(uint8_t data);



static inline bool SerialP$valid_rx_proto(uint8_t proto);










static void SerialP$rx_state_machine(bool isDelimeter, uint8_t data);
#line 502
static void SerialP$MaybeScheduleTx(void);










static inline   error_t SerialP$SendBytePacket$completeSend(void);








static inline   error_t SerialP$SendBytePacket$startSend(uint8_t b);
#line 539
static inline  void SerialP$RunTx$runTask(void);
#line 642
static inline   void SerialP$SerialFrameComm$putDone(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$postTask(void);
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(
# 40 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5b960, 
# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x1ad17df0, error_t arg_0x1ad16010);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask(void);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(
# 39 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5b3a8, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380, 
# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1adb4d58, uint8_t arg_0x1adb4ee8);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380);
# 23 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae5a380, 
# 23 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1adb4560, uint8_t arg_0x1adb46f0);
# 60 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$completeSend(void);
#line 51
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x1adc1170);
# 147 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4329 {
#line 147
  SerialDispatcherP$0$signalSendDone = 11U
};
#line 147
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_signalSendDone[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone];
#line 264
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4330 {
#line 264
  SerialDispatcherP$0$receiveTask = 12U
};
#line 264
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_receiveTask[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask];
#line 55
#line 51
typedef enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4331 {
  SerialDispatcherP$0$SEND_STATE_IDLE = 0, 
  SerialDispatcherP$0$SEND_STATE_BEGIN = 1, 
  SerialDispatcherP$0$SEND_STATE_DATA = 2
} /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$send_state_t;

enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4332 {
  SerialDispatcherP$0$RECV_STATE_IDLE = 0, 
  SerialDispatcherP$0$RECV_STATE_BEGIN = 1, 
  SerialDispatcherP$0$RECV_STATE_DATA = 2
};






#line 63
typedef struct /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4333 {
  uint8_t which : 1;
  uint8_t bufZeroLocked : 1;
  uint8_t bufOneLocked : 1;
  uint8_t state : 2;
} /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recv_state_t;



/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recv_state_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState = { 0, 0, 0, /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_IDLE };
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvType = TOS_SERIAL_UNKNOWN_ID;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex = 0;


message_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messages[2];
message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[2] = { &/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messages[0], &/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messages[1] };




uint8_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer = (uint8_t *)&/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messages[0];

uint8_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer = (void *)0;
/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$send_state_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendLen = 0;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex = 0;
 error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = SUCCESS;
bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled = FALSE;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId = 0;


uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending = FALSE;
uart_id_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskType = 0;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskWhich;
message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskBuf = (void *)0;
uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskSize = 0;

static inline  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(uint8_t id, message_t *msg, uint8_t len);
#line 147
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
#line 167
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);
#line 183
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error);




static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void);



static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void);




static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);
#line 233
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b);
#line 264
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
#line 285
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result);
#line 344
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen);




static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len);


static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error);
# 48 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x1ae954c8, uint16_t arg_0x1ae95658);
# 83 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x1add28d0);





static   void HdlcTranslateC$SerialFrameComm$putDone(void);
#line 74
static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void);
# 47 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
#line 44
typedef struct HdlcTranslateC$__nesc_unnamed4334 {
  uint8_t sendEscape : 1;
  uint8_t receiveEscape : 1;
} HdlcTranslateC$HdlcState;


 HdlcTranslateC$HdlcState HdlcTranslateC$state = { 0, 0 };
 uint8_t HdlcTranslateC$txTemp;
 uint8_t HdlcTranslateC$m_data;


static inline   void HdlcTranslateC$SerialFrameComm$resetReceive(void);





static inline   void HdlcTranslateC$UartStream$receivedByte(uint8_t data);
#line 86
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void);





static   error_t HdlcTranslateC$SerialFrameComm$putData(uint8_t data);
#line 104
static inline   void HdlcTranslateC$UartStream$sendDone(uint8_t *buf, uint16_t len, 
error_t error);










static inline   void HdlcTranslateC$UartStream$receiveDone(uint8_t *buf, uint16_t len, error_t error);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_union_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(
# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af040f8);
# 97 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$resetUsart(bool arg_0x1af1b990);
#line 179
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr(void);


static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr(void);
#line 224
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(uint8_t arg_0x1af13c68);
#line 128
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart(void);
#line 174
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(msp430_uart_union_config_t *arg_0x1af150a8);
# 79 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(uint8_t arg_0x1ae94d60);
#line 99
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(uint8_t *arg_0x1ae93b08, uint16_t arg_0x1ae93c98, error_t arg_0x1ae93e20);
#line 57
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(uint8_t *arg_0x1ae95c60, uint16_t arg_0x1ae95df0, error_t arg_0x1ae94010);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(
# 48 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af05778);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(
# 48 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af05778);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(
# 42 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1af07910);
#line 59
 uint8_t */*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf;
#line 59
 uint8_t */*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf;
 uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len;
#line 60
 uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_len;
 uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos;
#line 61
 uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_pos;
 uint8_t /*Msp430Uart1P.UartP*/Msp430UartP$0$m_byte_time;

static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(uint8_t id);
#line 76
static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(uint8_t id);





static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(uint8_t id);






static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(uint8_t id);






static inline  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(uint8_t id);
#line 123
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t data);
#line 137
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *buf, uint16_t len);
#line 149
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void);
#line 186
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void);



static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(uint8_t id);
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(uint8_t id);
static inline    msp430_uart_union_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(uint8_t id);



static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(uint8_t id);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart1P$UCLK$selectIOFunc(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void HplMsp430Usart1P$Interrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void HplMsp430Usart1P$Interrupts$txDone(void);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart1P$URXD$selectIOFunc(void);
#line 78
static   void HplMsp430Usart1P$URXD$selectModuleFunc(void);






static   void HplMsp430Usart1P$UTXD$selectIOFunc(void);
#line 78
static   void HplMsp430Usart1P$UTXD$selectModuleFunc(void);






static   void HplMsp430Usart1P$SOMI$selectIOFunc(void);
#line 85
static   void HplMsp430Usart1P$SIMO$selectIOFunc(void);
# 87 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
 static volatile uint8_t HplMsp430Usart1P$IE2 __asm ("0x0001");
 static volatile uint8_t HplMsp430Usart1P$ME2 __asm ("0x0005");
 static volatile uint8_t HplMsp430Usart1P$IFG2 __asm ("0x0003");
 static volatile uint8_t HplMsp430Usart1P$U1TCTL __asm ("0x0079");
 static volatile uint8_t HplMsp430Usart1P$U1RCTL __asm ("0x007A");
 static volatile uint8_t HplMsp430Usart1P$U1TXBUF __asm ("0x007F");



void sig_UART1RX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(6))) ;




void sig_UART1TX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(4))) ;



static inline   error_t HplMsp430Usart1P$AsyncStdControl$start(void);



static inline   error_t HplMsp430Usart1P$AsyncStdControl$stop(void);
#line 140
static inline   void HplMsp430Usart1P$Usart$setUbr(uint16_t control);










static inline   void HplMsp430Usart1P$Usart$setUmctl(uint8_t control);







static inline   void HplMsp430Usart1P$Usart$resetUsart(bool reset);
#line 203
static inline   void HplMsp430Usart1P$Usart$enableUart(void);







static   void HplMsp430Usart1P$Usart$disableUart(void);








static inline   void HplMsp430Usart1P$Usart$enableUartTx(void);




static inline   void HplMsp430Usart1P$Usart$disableUartTx(void);





static inline   void HplMsp430Usart1P$Usart$enableUartRx(void);




static inline   void HplMsp430Usart1P$Usart$disableUartRx(void);
#line 251
static   void HplMsp430Usart1P$Usart$disableSpi(void);
#line 283
static inline void HplMsp430Usart1P$configUart(msp430_uart_union_config_t *config);









static inline   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_union_config_t *config);
#line 347
static inline   void HplMsp430Usart1P$Usart$clrIntr(void);
#line 359
static inline   void HplMsp430Usart1P$Usart$disableIntr(void);
#line 377
static inline   void HplMsp430Usart1P$Usart$enableIntr(void);






static inline   void HplMsp430Usart1P$Usart$tx(uint8_t data);
# 46 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$clr(void);



static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeInput(void);

static inline   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeOutput(void);
#line 46
static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$clr(void);



static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeInput(void);

static inline   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeOutput(void);

static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc(void);
#line 54
static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc(void);
#line 54
static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc(void);
#line 56
static inline   void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc(void);
#line 56
static inline   void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc(void);
#line 54
static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc(void);
#line 54
static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc(void);
#line 56
static inline   void /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc(void);
#line 56
static inline   void /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc(void);
#line 56
static inline   void /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput(void);
#line 45
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$set(void);
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$clr(void);

static inline   uint8_t /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$getRaw(void);
static inline   bool /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$get(void);


static inline   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$makeOutput(void);
# 71 "/svn/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void);
# 53 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void LedsP$Led0$makeOutput(void);
#line 29
static   void LedsP$Led0$set(void);





static   void LedsP$Led1$makeOutput(void);
#line 29
static   void LedsP$Led1$set(void);





static   void LedsP$Led2$makeOutput(void);
#line 29
static   void LedsP$Led2$set(void);
# 45 "/svn/tinyos-2.x/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void);
# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410, 
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410);









static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);




static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data);









static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id);
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data);
# 39 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$__nesc_unnamed4335 {
#line 39
  FcfsResourceQueueC$0$NO_ENTRY = 0xFF
};
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[1U];
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

static inline  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);




static inline   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);







static inline   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue(void);
# 46 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted(void);
#line 81
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask(void);
# 75 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4336 {
#line 75
  ArbiterP$0$grantedTask = 13U
};
#line 75
typedef int /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_sillytask_grantedTask[/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask];
#line 67
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4337 {
#line 67
  ArbiterP$0$RES_CONTROLLED, ArbiterP$0$RES_GRANTING, ArbiterP$0$RES_IMM_GRANTING, ArbiterP$0$RES_BUSY
};
#line 68
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4338 {
#line 68
  ArbiterP$0$default_owner_id = 1U
};
#line 69
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4339 {
#line 69
  ArbiterP$0$NO_RES = 0xFF
};
uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
 uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id;
 uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
#line 90
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id);
#line 108
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id);
#line 127
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void);
#line 147
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);
#line 160
static   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);
#line 182
static inline  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
#line 194
static inline   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id);



static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id);









static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id);

static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id);
# 52 "/svn/tinyos-2.x/tos/lib/power/PowerDownCleanup.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$release(void);
# 74 "/svn/tinyos-2.x/tos/interfaces/AsyncStdControl.nc"
static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start(void);









static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop(void);
# 64 "/svn/tinyos-2.x/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$immediateRequested(void);




static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$granted(void);




static inline    void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t TelosSerialP$Resource$release(void);
#line 87
static   error_t TelosSerialP$Resource$immediateRequest(void);
# 8 "/svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
msp430_uart_union_config_t TelosSerialP$msp430_uart_telos_config = { { .ubr = UBR_1MHZ_115200, .umctl = UMCTL_1MHZ_115200, .ssel = 0x02, .pena = 0, .pev = 0, .spb = 0, .clen = 1, .listen = 0, .mm = 0, .ckpl = 0, .urxse = 0, .urxeie = 1, .urxwie = 0, .utxe = 1, .urxe = 1 } };

static inline  error_t TelosSerialP$StdControl$start(void);


static inline  error_t TelosSerialP$StdControl$stop(void);



static inline  void TelosSerialP$Resource$granted(void);

static inline   msp430_uart_union_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void);
# 40 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen);
# 74 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t StateImplP$state[9U];

enum StateImplP$__nesc_unnamed4340 {
  StateImplP$S_IDLE = 0
};


static inline  error_t StateImplP$Init$init(void);
#line 96
static   error_t StateImplP$State$requestState(uint8_t id, uint8_t reqState);
#line 111
static inline   void StateImplP$State$forceState(uint8_t id, uint8_t reqState);






static inline   void StateImplP$State$toIdle(uint8_t id);







static inline   bool StateImplP$State$isIdle(uint8_t id);






static   bool StateImplP$State$isState(uint8_t id, uint8_t myState);









static   uint8_t StateImplP$State$getState(uint8_t id);
# 51 "/svn/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
am_addr_t ActiveMessageAddressC$addr = TOS_AM_ADDRESS;









static inline   am_addr_t ActiveMessageAddressC$ActiveMessageAddress$amAddress(void);
#line 95
static inline   am_addr_t ActiveMessageAddressC$amAddress(void);
# 41 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
static   void TestP$TestCC1100Control$done(void);
# 83 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t TestP$SplitControl$start(void);
#line 109
static  error_t TestP$SplitControl$stop(void);
# 32 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool TestP$Csn$get(void);
# 19 "TestP.nc"
static inline  void TestP$TestCC1100Control$run(void);










static inline  void TestP$SplitControl$startDone(error_t error);
#line 43
static inline  void TestP$SplitControl$stopDone(error_t error);





static inline  void TestP$Resource$granted(void);
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
static  void BlazeSpiP$RadioInit$initDone(void);
# 59 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t BlazeSpiP$SpiPacket$send(uint8_t *arg_0x1b432598, uint8_t *arg_0x1b432740, uint16_t arg_0x1b4328d0);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t BlazeSpiP$radioInitDone$postTask(void);
# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   void BlazeSpiP$Fifo$writeDone(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3ecd60, uint8_t arg_0x1b3ecee8, error_t arg_0x1b3eb088);
#line 73
static   void BlazeSpiP$Fifo$readDone(
# 14 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b4096a8, 
# 73 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
uint8_t *arg_0x1b3eec90, uint8_t arg_0x1b3eee18, error_t arg_0x1b3ec010);
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/ChipSpiResource.nc"
static   void BlazeSpiP$ChipSpiResource$releasing(void);
# 34 "/svn/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t BlazeSpiP$SpiByte$write(uint8_t arg_0x1b4003e0);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeSpiP$SpiResource$release(void);
#line 87
static   error_t BlazeSpiP$SpiResource$immediateRequest(void);
#line 78
static   error_t BlazeSpiP$SpiResource$request(void);
#line 118
static   bool BlazeSpiP$SpiResource$isOwner(void);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t BlazeSpiP$State$getState(void);
#line 56
static   void BlazeSpiP$State$toIdle(void);
#line 45
static   error_t BlazeSpiP$State$requestState(uint8_t arg_0x1a9e1ba0);





static   void BlazeSpiP$State$forceState(uint8_t arg_0x1a9e0170);




static   void BlazeSpiP$SpiResourceState$toIdle(void);




static   bool BlazeSpiP$SpiResourceState$isIdle(void);
#line 45
static   error_t BlazeSpiP$SpiResourceState$requestState(uint8_t arg_0x1a9e1ba0);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void BlazeSpiP$Resource$granted(
# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
uint8_t arg_0x1b40ad00);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t BlazeSpiP$grant$postTask(void);
# 63 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
enum BlazeSpiP$__nesc_unnamed4341 {
#line 63
  BlazeSpiP$grant = 14U
};
#line 63
typedef int BlazeSpiP$__nesc_sillytask_grant[BlazeSpiP$grant];
enum BlazeSpiP$__nesc_unnamed4342 {
#line 64
  BlazeSpiP$radioInitDone = 15U
};
#line 64
typedef int BlazeSpiP$__nesc_sillytask_radioInitDone[BlazeSpiP$radioInitDone];
#line 34
enum BlazeSpiP$__nesc_unnamed4343 {
  BlazeSpiP$RESOURCE_COUNT = 4U, 
  BlazeSpiP$NO_HOLDER = 0xFF
};

enum BlazeSpiP$__nesc_unnamed4344 {
  BlazeSpiP$S_IDLE, 
  BlazeSpiP$S_BUSY, 

  BlazeSpiP$S_READ_FIFO, 
  BlazeSpiP$S_INIT, 
  BlazeSpiP$S_WRITE_FIFO
};


uint16_t BlazeSpiP$m_addr;


uint32_t BlazeSpiP$m_requests = 0;


uint8_t BlazeSpiP$m_holder = BlazeSpiP$NO_HOLDER;


bool BlazeSpiP$release;


static inline uint8_t BlazeSpiP$getRadioStatus(void);
static inline error_t BlazeSpiP$attemptRelease(void);




static inline  error_t BlazeSpiP$RadioInit$init(uint8_t startAddr, uint8_t *regs, 
uint8_t len);
#line 102
static   error_t BlazeSpiP$Resource$request(uint8_t id);
#line 121
static inline   error_t BlazeSpiP$Resource$immediateRequest(uint8_t id);
#line 144
static   error_t BlazeSpiP$Resource$release(uint8_t id);
#line 174
static inline   uint8_t BlazeSpiP$Resource$isOwner(uint8_t id);




static inline  void BlazeSpiP$SpiResource$granted(void);




static   blaze_status_t BlazeSpiP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len);









static inline   error_t BlazeSpiP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len);






static inline   blaze_status_t BlazeSpiP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 217
static   void BlazeSpiP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error);
#line 249
static inline   blaze_status_t BlazeSpiP$Strobe$strobe(uint8_t addr);




static   uint8_t BlazeSpiP$RadioStatus$getRadioStatus(void);
#line 268
static inline  void BlazeSpiP$radioInitDone$runTask(void);



static inline  void BlazeSpiP$grant$runTask(void);









static inline uint8_t BlazeSpiP$getRadioStatus(void);



static inline error_t BlazeSpiP$attemptRelease(void);
#line 315
static inline   void BlazeSpiP$Resource$default$granted(uint8_t id);



static inline    void BlazeSpiP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error);
static inline    void BlazeSpiP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error);




static inline    void BlazeSpiP$ChipSpiResource$default$releasing(void);
# 71 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(
# 43 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b483ab0, 
# 71 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x1b431030, uint8_t *arg_0x1b4311d8, uint16_t arg_0x1b431368, 
error_t arg_0x1b431500);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(
# 46 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b482b10);
# 180 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$enableRxIntr(void);
#line 197
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr(void);
#line 97
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(bool arg_0x1af1b990);
#line 177
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr(void);









static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isTxIntrPending(void);
#line 224
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(uint8_t arg_0x1af13c68);
#line 168
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x1af17a88);
#line 231
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx(void);
#line 192
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending(void);









static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrTxIntr(void);
#line 158
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(
# 45 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b4821b0);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x1b484740);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$postTask(void);
# 66 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
enum /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_unnamed4345 {
#line 66
  Msp430SpiNoDmaP$0$signalDone_task = 16U
};
#line 66
typedef int /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_sillytask_signalDone_task[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task];
#line 55
enum /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_unnamed4346 {
  Msp430SpiNoDmaP$0$SPI_ATOMIC_SIZE = 2
};

 uint8_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf;
 uint8_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf;
 uint16_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len;
 uint16_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos;
 uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_client;

static inline void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone(void);


static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(uint8_t id);



static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(uint8_t id);



static inline   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(uint8_t id);



static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(uint8_t id);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(uint8_t id);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(uint8_t id);





static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(uint8_t id);



static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(uint8_t tx);
#line 110
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(uint8_t id);
static inline    msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(uint8_t id);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(uint8_t id);

static void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp(void);
#line 146
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len);
#line 168
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t data);
#line 185
static inline void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone(void);




static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void);

static inline    void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$UCLK$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$UCLK$selectModuleFunc(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void HplMsp430Usart0P$Interrupts$rxDone(uint8_t arg_0x1af0d8d8);
#line 49
static   void HplMsp430Usart0P$Interrupts$txDone(void);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$URXD$selectIOFunc(void);
#line 85
static   void HplMsp430Usart0P$UTXD$selectIOFunc(void);
# 7 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static   void HplMsp430Usart0P$HplI2C$clearModeI2C(void);
#line 6
static   bool HplMsp430Usart0P$HplI2C$isI2C(void);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$SOMI$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$SOMI$selectModuleFunc(void);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void HplMsp430Usart0P$I2CInterrupts$fired(void);
# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$SIMO$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$SIMO$selectModuleFunc(void);
# 89 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
 static volatile uint8_t HplMsp430Usart0P$IE1 __asm ("0x0000");
 static volatile uint8_t HplMsp430Usart0P$ME1 __asm ("0x0004");
 static volatile uint8_t HplMsp430Usart0P$IFG1 __asm ("0x0002");
 static volatile uint8_t HplMsp430Usart0P$U0TCTL __asm ("0x0071");

 static volatile uint8_t HplMsp430Usart0P$U0TXBUF __asm ("0x0077");

void sig_UART0RX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(18))) ;




void sig_UART0TX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(16))) ;
#line 132
static inline   void HplMsp430Usart0P$Usart$setUbr(uint16_t control);










static inline   void HplMsp430Usart0P$Usart$setUmctl(uint8_t control);







static inline   void HplMsp430Usart0P$Usart$resetUsart(bool reset);
#line 207
static inline   void HplMsp430Usart0P$Usart$disableUart(void);
#line 238
static inline   void HplMsp430Usart0P$Usart$enableSpi(void);








static inline   void HplMsp430Usart0P$Usart$disableSpi(void);








static inline void HplMsp430Usart0P$configSpi(msp430_spi_union_config_t *config);








static   void HplMsp430Usart0P$Usart$setModeSpi(msp430_spi_union_config_t *config);
#line 316
static inline   bool HplMsp430Usart0P$Usart$isTxIntrPending(void);
#line 330
static inline   bool HplMsp430Usart0P$Usart$isRxIntrPending(void);






static inline   void HplMsp430Usart0P$Usart$clrTxIntr(void);



static inline   void HplMsp430Usart0P$Usart$clrRxIntr(void);



static inline   void HplMsp430Usart0P$Usart$clrIntr(void);



static inline   void HplMsp430Usart0P$Usart$disableRxIntr(void);







static inline   void HplMsp430Usart0P$Usart$disableIntr(void);



static inline   void HplMsp430Usart0P$Usart$enableRxIntr(void);
#line 382
static inline   void HplMsp430Usart0P$Usart$tx(uint8_t data);



static   uint8_t HplMsp430Usart0P$Usart$rx(void);
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$userId(void);
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$rxDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410, 
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1af0d8d8);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$txDone(
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b26b410);
# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$fired(
# 40 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b265368);








static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$txDone(void);




static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$rxDone(uint8_t data);




static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawI2CInterrupts$fired(void);




static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$txDone(uint8_t id);
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$rxDone(uint8_t id, uint8_t data);
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$default$fired(uint8_t id);
# 39 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$__nesc_unnamed4347 {
#line 39
  FcfsResourceQueueC$1$NO_ENTRY = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ[1U];
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;

static inline  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$Init$init(void);




static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEmpty(void);



static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEnqueued(resource_client_id_t id);



static inline   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$dequeue(void);
#line 72
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$enqueue(resource_client_id_t id);
# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$requested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$immediateRequested(
# 55 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2ce738);
# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$unconfigure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$configure(
# 60 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cd910);
# 69 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$enqueue(resource_client_id_t arg_0x1b2a8a98);
#line 43
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$dequeue(void);
# 73 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$requested(void);
#line 46
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$granted(void);
#line 81
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$immediateRequested(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$granted(
# 54 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x1b2cfdd8);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$postTask(void);
# 75 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$__nesc_unnamed4348 {
#line 75
  ArbiterP$1$grantedTask = 17U
};
#line 75
typedef int /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$__nesc_sillytask_grantedTask[/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask];
#line 67
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$__nesc_unnamed4349 {
#line 67
  ArbiterP$1$RES_CONTROLLED, ArbiterP$1$RES_GRANTING, ArbiterP$1$RES_IMM_GRANTING, ArbiterP$1$RES_BUSY
};
#line 68
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$__nesc_unnamed4350 {
#line 68
  ArbiterP$1$default_owner_id = 1U
};
#line 69
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$__nesc_unnamed4351 {
#line 69
  ArbiterP$1$NO_RES = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED;
 uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$default_owner_id;
 uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId;



static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$request(uint8_t id);
#line 90
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$immediateRequest(uint8_t id);
#line 108
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$release(uint8_t id);
#line 127
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$release(void);
#line 147
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$inUse(void);
#line 160
static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$userId(void);










static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$isOwner(uint8_t id);










static inline  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$runTask(void);
#line 194
static inline   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$default$granted(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$requested(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$immediateRequested(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$granted(void);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$requested(void);


static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$immediateRequested(void);


static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$configure(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$unconfigure(uint8_t id);
# 97 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430I2C0P$HplUsart$resetUsart(bool arg_0x1af1b990);
# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
 static volatile uint8_t HplMsp430I2C0P$U0CTL __asm ("0x0070");





static inline   bool HplMsp430I2C0P$HplI2C$isI2C(void);



static inline   void HplMsp430I2C0P$HplI2C$clearModeI2C(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t CC1100ControlP$ActiveMessageAddress$amAddress(void);
# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC1100ControlP$Gdo0_io$makeInput(void);
#line 30
static   void CC1100ControlP$Gdo0_io$clr(void);


static   void CC1100ControlP$Gdo2_io$makeInput(void);
#line 30
static   void CC1100ControlP$Gdo2_io$clr(void);




static   void CC1100ControlP$Power$makeOutput(void);
# 19 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
static  void CC1100ControlP$BlazeConfig$commitDone(void);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC1100ControlP$Csn$makeOutput(void);
# 34 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100ControlP.nc"
uint16_t CC1100ControlP$panAddress;


bool CC1100ControlP$addressRecognition;


bool CC1100ControlP$panRecognition;


bool CC1100ControlP$autoAck;


uint8_t CC1100ControlP$regValues[39] = { 
CC1100_CONFIG_IOCFG2, 
CC1100_CONFIG_IOCFG1, 
CC1100_CONFIG_IOCFG0, 
CC1100_CONFIG_FIFOTHR, 
CC1100_CONFIG_SYNC1, 
CC1100_CONFIG_SYNC0, 
CC1100_CONFIG_PKTLEN, 
CC1100_CONFIG_PKTCTRL1, 
CC1100_CONFIG_PKTCTRL0, 
CC1100_CONFIG_ADDR, 
CC1100_CONFIG_CHANNR, 
CC1100_CONFIG_FSCTRL1, 
CC1100_CONFIG_FSCTRL0, 
CC1100_CONFIG_FREQ2, 
CC1100_CONFIG_FREQ1, 
CC1100_CONFIG_FREQ0, 
CC1100_CONFIG_MDMCFG4, 
CC1100_CONFIG_MDMCFG3, 
CC1100_CONFIG_MDMCFG2, 
CC1100_CONFIG_MDMCFG1, 
CC1100_CONFIG_MDMCFG0, 
CC1100_CONFIG_DEVIATN, 
CC1100_CONFIG_MCSM2, 
CC1100_CONFIG_MCSM1, 
CC1100_CONFIG_MCSM0, 
CC1100_CONFIG_FOCCFG, 
CC1100_CONFIG_BSCFG, 
CC1100_CONFIG_AGCTRL2, 
CC1100_CONFIG_AGCTRL1, 
CC1100_CONFIG_AGCTRL0, 
CC1100_CONFIG_WOREVT1, 
CC1100_CONFIG_WOREVT0, 
CC1100_CONFIG_WORCTRL, 
CC1100_CONFIG_FREND1, 
CC1100_CONFIG_FREND0, 
CC1100_CONFIG_FSCAL3, 
CC1100_CONFIG_FSCAL2, 
CC1100_CONFIG_FSCAL1, 
CC1100_CONFIG_FSCAL0 };



static inline  error_t CC1100ControlP$SoftwareInit$init(void);
#line 127
static inline  uint8_t *CC1100ControlP$BlazeRegSettings$getDefaultRegisters(void);
#line 218
static inline   bool CC1100ControlP$BlazeConfig$isAutoAckEnabled(void);
#line 230
static inline  void CC1100ControlP$BlazeCommit$commitDone(void);
# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void HplMsp430InterruptP$Port14$fired(void);
#line 61
static   void HplMsp430InterruptP$Port26$fired(void);
#line 61
static   void HplMsp430InterruptP$Port17$fired(void);
#line 61
static   void HplMsp430InterruptP$Port21$fired(void);
#line 61
static   void HplMsp430InterruptP$Port12$fired(void);
#line 61
static   void HplMsp430InterruptP$Port24$fired(void);
#line 61
static   void HplMsp430InterruptP$Port15$fired(void);
#line 61
static   void HplMsp430InterruptP$Port27$fired(void);
#line 61
static   void HplMsp430InterruptP$Port10$fired(void);
#line 61
static   void HplMsp430InterruptP$Port22$fired(void);
#line 61
static   void HplMsp430InterruptP$Port13$fired(void);
#line 61
static   void HplMsp430InterruptP$Port25$fired(void);
#line 61
static   void HplMsp430InterruptP$Port16$fired(void);
#line 61
static   void HplMsp430InterruptP$Port20$fired(void);
#line 61
static   void HplMsp430InterruptP$Port11$fired(void);
#line 61
static   void HplMsp430InterruptP$Port23$fired(void);
# 53 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
void sig_PORT1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(8))) ;
#line 67
static inline    void HplMsp430InterruptP$Port10$default$fired(void);
static inline    void HplMsp430InterruptP$Port11$default$fired(void);
static inline    void HplMsp430InterruptP$Port12$default$fired(void);
static inline    void HplMsp430InterruptP$Port13$default$fired(void);
static inline    void HplMsp430InterruptP$Port14$default$fired(void);
static inline    void HplMsp430InterruptP$Port15$default$fired(void);
static inline    void HplMsp430InterruptP$Port16$default$fired(void);
static inline    void HplMsp430InterruptP$Port17$default$fired(void);
#line 91
static inline   void HplMsp430InterruptP$Port10$clear(void);
static inline   void HplMsp430InterruptP$Port11$clear(void);
static inline   void HplMsp430InterruptP$Port12$clear(void);
static inline   void HplMsp430InterruptP$Port13$clear(void);
static inline   void HplMsp430InterruptP$Port14$clear(void);
static inline   void HplMsp430InterruptP$Port15$clear(void);
static inline   void HplMsp430InterruptP$Port16$clear(void);
static inline   void HplMsp430InterruptP$Port17$clear(void);
#line 158
void sig_PORT2_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(2))) ;
#line 171
static inline    void HplMsp430InterruptP$Port20$default$fired(void);
static inline    void HplMsp430InterruptP$Port21$default$fired(void);
static inline    void HplMsp430InterruptP$Port22$default$fired(void);

static inline    void HplMsp430InterruptP$Port24$default$fired(void);
static inline    void HplMsp430InterruptP$Port25$default$fired(void);

static inline    void HplMsp430InterruptP$Port27$default$fired(void);






static inline   void HplMsp430InterruptP$Port26$enable(void);







static inline   void HplMsp430InterruptP$Port26$disable(void);

static inline   void HplMsp430InterruptP$Port20$clear(void);
static inline   void HplMsp430InterruptP$Port21$clear(void);
static inline   void HplMsp430InterruptP$Port22$clear(void);
static inline   void HplMsp430InterruptP$Port23$clear(void);
static inline   void HplMsp430InterruptP$Port24$clear(void);
static inline   void HplMsp430InterruptP$Port25$clear(void);
static inline   void HplMsp430InterruptP$Port26$clear(void);
static inline   void HplMsp430InterruptP$Port27$clear(void);
#line 247
static inline   void HplMsp430InterruptP$Port26$edge(bool l2h);
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$clear(void);
# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$Interrupt$fired(void);
# 66 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$fired(void);
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$clear(void);
#line 36
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$disable(void);
#line 56
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$edge(bool arg_0x1b682010);
#line 31
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$enable(void);
# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$fired(void);
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$enable(bool rising);








static inline   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$enableRisingEdge(void);







static inline   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$disable(void);







static inline   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$fired(void);
# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$makeOutput(void);
#line 59
static   bool /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$get(void);
#line 34
static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$set(void);




static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$clr(void);
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set(void);
static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr(void);

static inline   bool /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$get(void);


static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$makeOutput(void);
# 64 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeInput(void);






static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeOutput(void);
#line 39
static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$clr(void);
# 38 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$clr(void);


static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeInput(void);

static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeOutput(void);
# 64 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeInput(void);






static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeOutput(void);
#line 39
static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$clr(void);
# 38 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$clr(void);


static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeInput(void);

static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeOutput(void);
# 16 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/DummyIoP.nc"
static inline   void DummyIoP$GeneralIO$set(void);


static inline   void DummyIoP$GeneralIO$clr(void);
#line 36
static inline   void DummyIoP$GeneralIO$makeOutput(void);
# 17 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/HplCC1100PinsP.nc"
static inline   void HplCC1100PinsP$Gdo2_int$fired(void);


static inline   void HplCC1100PinsP$Gdo0_int$fired(void);
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void BlazeInitP$SplitControl$startDone(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010, 
# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
error_t arg_0x1a9f18d8);
#line 117
static  void BlazeInitP$SplitControl$stopDone(
# 29 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e010, 
# 117 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
error_t arg_0x1a9f0640);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeRegSettings.nc"
static  uint8_t *BlazeInitP$BlazeRegSettings$getDefaultRegisters(
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767a80);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeInitP$SXOFF$strobe(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
static  error_t BlazeInitP$RadioInit$init(uint8_t arg_0x1b413718, uint8_t *arg_0x1b4138c8, uint8_t arg_0x1b413a50);
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static  void BlazeInitP$BlazePower$resetComplete(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 47 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
static  void BlazeInitP$BlazePower$deepSleepComplete(
# 30 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76e870);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeInitP$SRX$strobe(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeInitP$ResetResource$release(void);
#line 78
static   error_t BlazeInitP$ResetResource$request(void);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeInitP$SFRX$strobe(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
static   blaze_status_t BlazeInitP$RadioStatus$getRadioStatus(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo0_int$disable(
# 42 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b768958);
# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeCommit.nc"
static  void BlazeInitP$BlazeCommit$commitDone(
# 31 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76d308);
# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$makeInput(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$makeOutput(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo0_io$clr(
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769120);
# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$makeInput(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$makeOutput(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Gdo2_io$clr(
# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b769d28);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo2_int$disable(
# 43 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767218);
# 43 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeInitP$Gdo2_int$enableFallingEdge(
# 43 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b767218);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Power$set(
# 38 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76c888);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Power$clr(
# 38 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76c888);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Csn$set(
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76b4f0);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeInitP$Csn$clr(
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
radio_id_t arg_0x1b76b4f0);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeInitP$SFTX$strobe(void);
#line 45
static   blaze_status_t BlazeInitP$SRES$strobe(void);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeInitP$DeepSleepResource$release(void);
#line 78
static   error_t BlazeInitP$DeepSleepResource$request(void);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeInitP$Idle$strobe(void);
# 62 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
enum BlazeInitP$__nesc_unnamed4352 {
  BlazeInitP$NO_RADIO = 0xFF
};

 uint8_t BlazeInitP$m_id;

uint8_t BlazeInitP$state[1U];

enum BlazeInitP$__nesc_unnamed4353 {
  BlazeInitP$S_OFF, 
  BlazeInitP$S_STARTING, 
  BlazeInitP$S_ON, 
  BlazeInitP$S_COMMITTING, 
  BlazeInitP$S_STOPPING
};




static inline  error_t BlazeInitP$Init$init(void);
#line 101
static inline  error_t BlazeInitP$SplitControl$start(radio_id_t id);
#line 128
static inline  error_t BlazeInitP$SplitControl$stop(radio_id_t id);
#line 188
static inline   error_t BlazeInitP$BlazePower$reset(radio_id_t id);








static inline   error_t BlazeInitP$BlazePower$deepSleep(radio_id_t id);







static   void BlazeInitP$BlazePower$shutdown(radio_id_t id);
#line 220
static inline  void BlazeInitP$RadioInit$initDone(void);
#line 252
static inline  void BlazeInitP$ResetResource$granted(void);
#line 291
static inline  void BlazeInitP$DeepSleepResource$granted(void);
#line 317
static inline    void BlazeInitP$Csn$default$set(radio_id_t id);
static inline    void BlazeInitP$Csn$default$clr(radio_id_t id);







static inline    void BlazeInitP$Power$default$set(radio_id_t id);
static inline    void BlazeInitP$Power$default$clr(radio_id_t id);








static inline    void BlazeInitP$Gdo0_io$default$clr(radio_id_t id);


static inline    void BlazeInitP$Gdo0_io$default$makeInput(radio_id_t id);

static inline    void BlazeInitP$Gdo0_io$default$makeOutput(radio_id_t id);



static inline    void BlazeInitP$Gdo2_io$default$clr(radio_id_t id);


static inline    void BlazeInitP$Gdo2_io$default$makeInput(radio_id_t id);

static inline    void BlazeInitP$Gdo2_io$default$makeOutput(radio_id_t id);




static inline    error_t BlazeInitP$Gdo0_int$default$disable(radio_id_t id);


static inline    error_t BlazeInitP$Gdo2_int$default$enableFallingEdge(radio_id_t id);
static inline    error_t BlazeInitP$Gdo2_int$default$disable(radio_id_t id);

static inline   void BlazeInitP$BlazePower$default$resetComplete(radio_id_t id);
static inline   void BlazeInitP$BlazePower$default$deepSleepComplete(radio_id_t id);

static inline   void BlazeInitP$SplitControl$default$startDone(radio_id_t id, error_t error);
static inline   void BlazeInitP$SplitControl$default$stopDone(radio_id_t id, error_t error);

static inline   uint8_t *BlazeInitP$BlazeRegSettings$default$getDefaultRegisters(radio_id_t id);

static inline   void BlazeInitP$BlazeCommit$default$commitDone(radio_id_t id);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeTransmitP$SRX$strobe(void);
# 44 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
static   blaze_header_t *BlazeTransmitP$BlazePacketBody$getHeader(message_t *arg_0x1b8285a0);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   void BlazeTransmitP$AckSend$loadDone(
# 21 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831ce0, 
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83a218, error_t arg_0x1b83a3a0);

static   void BlazeTransmitP$AckSend$sendDone(
# 21 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831ce0);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeTransmitP$SFRX$strobe(void);
# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeTransmitP$TxInterrupt$disable(
# 26 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b82e238);
# 42 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t BlazeTransmitP$TxInterrupt$enableRisingEdge(
# 26 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b82e238);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeTransmitP$STX$strobe(void);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
static   blaze_status_t BlazeTransmitP$RadioStatus$getRadioStatus(void);
# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   bool BlazeTransmitP$InterruptState$isState(uint8_t arg_0x1a9e0d10);
#line 51
static   void BlazeTransmitP$InterruptState$forceState(uint8_t arg_0x1a9e0170);
#line 71
static   uint8_t BlazeTransmitP$State$getState(void);
#line 56
static   void BlazeTransmitP$State$toIdle(void);
#line 45
static   error_t BlazeTransmitP$State$requestState(uint8_t arg_0x1a9e1ba0);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   void BlazeTransmitP$AsyncSend$loadDone(
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831458, 
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83a218, error_t arg_0x1b83a3a0);

static   void BlazeTransmitP$AsyncSend$sendDone(
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b831458);
# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/PacketCrc.nc"
static   void BlazeTransmitP$PacketCrc$appendCrc(uint8_t *arg_0x1b821e48);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeTransmitP$Csn$set(
# 25 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b830610);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeTransmitP$Csn$clr(
# 25 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
radio_id_t arg_0x1b830610);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeTransmitP$SFTX$strobe(void);
# 84 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   blaze_status_t BlazeTransmitP$TXFIFO$write(uint8_t *arg_0x1b3ec5d8, uint8_t arg_0x1b3ec760);
# 53 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
enum BlazeTransmitP$__nesc_unnamed4354 {
  BlazeTransmitP$S_IDLE, 

  BlazeTransmitP$S_LOAD_PACKET, 
  BlazeTransmitP$S_LOAD_ACK, 

  BlazeTransmitP$S_TX_PACKET, 
  BlazeTransmitP$S_TX_ACK
};


uint8_t BlazeTransmitP$m_id;


static inline error_t BlazeTransmitP$load(uint8_t id, void *msg);
static inline error_t BlazeTransmitP$transmit(uint8_t id, bool force);
#line 108
static inline   error_t BlazeTransmitP$AckSend$load(radio_id_t id, void *msg);
#line 120
static inline   error_t BlazeTransmitP$AckSend$send(radio_id_t id);
#line 132
static inline   void BlazeTransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);
#line 152
static inline   void BlazeTransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);









static inline   void BlazeTransmitP$TxInterrupt$fired(radio_id_t id);









static inline error_t BlazeTransmitP$load(uint8_t id, void *msg);
#line 213
static inline error_t BlazeTransmitP$transmit(uint8_t id, bool force);
#line 287
static inline    void BlazeTransmitP$Csn$default$set(radio_id_t id);
static inline    void BlazeTransmitP$Csn$default$clr(radio_id_t id);




static inline    void BlazeTransmitP$AsyncSend$default$sendDone(radio_id_t id);
static inline    void BlazeTransmitP$AsyncSend$default$loadDone(radio_id_t id, void *msg, error_t error);





static inline    error_t BlazeTransmitP$TxInterrupt$default$enableRisingEdge(radio_id_t id);







static inline    error_t BlazeTransmitP$TxInterrupt$default$disable(radio_id_t id);
# 41 "/svn/tinyos-2.x/tos/interfaces/Crc.nc"
static  uint16_t PacketCrcP$Crc$crc16(void *arg_0x1b89b6d0, uint8_t arg_0x1b89b858);
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/crc/PacketCrcP.nc"
static inline   void PacketCrcP$PacketCrc$appendCrc(uint8_t *msg);
#line 66
static inline   bool PacketCrcP$PacketCrc$verifyCrc(uint8_t *msg);
# 40 "/svn/tinyos-2.x/tos/system/CrcC.nc"
static  uint16_t CrcC$Crc$crc16(void *buf, uint8_t len);
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/packet/BlazePacketP.nc"
static inline blaze_header_t *BlazePacketP$getHeader(message_t *msg);



static inline blaze_metadata_t *BlazePacketP$getMetadata(message_t *msg);
#line 56
static inline   blaze_header_t *BlazePacketP$BlazePacketBody$getHeader(message_t *msg);



static inline   blaze_metadata_t *BlazePacketP$BlazePacketBody$getMetadata(message_t *msg);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeReceiveP$SRX$strobe(void);
#line 45
static   blaze_status_t BlazeReceiveP$SIDLE$strobe(void);
# 44 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
static   blaze_header_t *BlazeReceiveP$BlazePacketBody$getHeader(message_t *arg_0x1b8285a0);




static   blaze_metadata_t *BlazeReceiveP$BlazePacketBody$getMetadata(message_t *arg_0x1b828af0);
# 8 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   error_t BlazeReceiveP$AckSend$send(
# 23 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d3a68);
# 6 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
static   error_t BlazeReceiveP$AckSend$load(
# 23 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d3a68, 
# 6 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
void *arg_0x1b83ba28);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AckReceive.nc"
static   void BlazeReceiveP$AckReceive$receive(am_addr_t arg_0x1b8a0838, am_addr_t arg_0x1b8a09d0, uint8_t arg_0x1b8a0b58);
# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t BlazeReceiveP$ActiveMessageAddress$amAddress(void);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeReceiveP$SFRX$strobe(void);
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t BlazeReceiveP$receiveDone$postTask(void);
# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   bool BlazeReceiveP$InterruptState$isState(uint8_t arg_0x1a9e0d10);
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *BlazeReceiveP$Receive$receive(
# 15 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d4820, 
# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8);
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
static   blaze_status_t BlazeReceiveP$RadioStatus$getRadioStatus(void);
# 53 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
static   blaze_status_t BlazeReceiveP$RXFIFO$beginRead(uint8_t *arg_0x1b3efd28, uint8_t arg_0x1b3efeb0);
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t BlazeReceiveP$State$getState(void);
#line 56
static   void BlazeReceiveP$State$toIdle(void);
#line 45
static   error_t BlazeReceiveP$State$requestState(uint8_t arg_0x1a9e1ba0);





static   void BlazeReceiveP$State$forceState(uint8_t arg_0x1a9e0170);
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t BlazeReceiveP$Resource$release(void);
#line 87
static   error_t BlazeReceiveP$Resource$immediateRequest(void);
#line 78
static   error_t BlazeReceiveP$Resource$request(void);
#line 118
static   bool BlazeReceiveP$Resource$isOwner(void);
# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/PacketCrc.nc"
static   bool BlazeReceiveP$PacketCrc$verifyCrc(uint8_t *arg_0x1b820550);
# 75 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
static   bool BlazeReceiveP$BlazeConfig$isAutoAckEnabled(
# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8cf4c8);
# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeReceiveP$Csn$set(
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d2330);
# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void BlazeReceiveP$Csn$clr(
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
radio_id_t arg_0x1b8d2330);
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
static   blaze_status_t BlazeReceiveP$SFTX$strobe(void);
# 92 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
enum BlazeReceiveP$__nesc_unnamed4355 {
#line 92
  BlazeReceiveP$receiveDone = 18U
};
#line 92
typedef int BlazeReceiveP$__nesc_sillytask_receiveDone[BlazeReceiveP$receiveDone];
#line 59
uint8_t BlazeReceiveP$m_id;


message_t *BlazeReceiveP$m_msg;


blaze_ack_t BlazeReceiveP$acknowledgement;


message_t BlazeReceiveP$myMsg;


uint8_t BlazeReceiveP$missedPackets;


enum BlazeReceiveP$receive_states {
  BlazeReceiveP$S_IDLE, 
  BlazeReceiveP$S_RX_LENGTH, 
  BlazeReceiveP$S_RX_FCF, 
  BlazeReceiveP$S_RX_PAYLOAD
};

enum BlazeReceiveP$__nesc_unnamed4356 {
  BlazeReceiveP$BLAZE_RXFIFO_LENGTH = 64, 


  BlazeReceiveP$MAC_PACKET_SIZE = MAC_HEADER_SIZE + 28 + MAC_FOOTER_SIZE + 2, 

  BlazeReceiveP$SACK_HEADER_LENGTH = 5
};





static void BlazeReceiveP$receive(void);

static void BlazeReceiveP$failReceive(void);
static void BlazeReceiveP$cleanUp(void);


static inline  error_t BlazeReceiveP$Init$init(void);
#line 112
static inline   void BlazeReceiveP$RxInterrupt$fired(radio_id_t id);









static inline   error_t BlazeReceiveP$ReceiveController$beginReceive(radio_id_t id);
#line 144
static inline  void BlazeReceiveP$Resource$granted(void);





static inline   void BlazeReceiveP$AckSend$loadDone(radio_id_t id, void *msg, error_t error);



static inline   void BlazeReceiveP$AckSend$sendDone(radio_id_t id);
#line 167
static inline   void BlazeReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error);
#line 303
static inline   void BlazeReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error);








static inline  void BlazeReceiveP$BlazeConfig$commitDone(radio_id_t id);



static inline  void BlazeReceiveP$receiveDone$runTask(void);
#line 346
static void BlazeReceiveP$receive(void);
#line 358
static void BlazeReceiveP$failReceive(void);
#line 377
static void BlazeReceiveP$cleanUp(void);
#line 396
static inline   message_t *BlazeReceiveP$Receive$default$receive(radio_id_t id, message_t *msg, void *payload, uint8_t len);



static inline    void BlazeReceiveP$AckReceive$default$receive(am_addr_t source, am_addr_t destination, uint8_t dsn);
#line 412
static inline    void BlazeReceiveP$Csn$default$set(radio_id_t id);
static inline    void BlazeReceiveP$Csn$default$clr(radio_id_t id);
#line 468
static inline    bool BlazeReceiveP$BlazeConfig$default$isAutoAckEnabled(radio_id_t id);
# 196 "/svn/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline void __nesc_enable_interrupt(void )
{
   __asm volatile ("eint");}

# 126 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static inline   bool StateImplP$State$isIdle(uint8_t id)
#line 126
{
  return StateImplP$State$isState(id, StateImplP$S_IDLE);
}

# 61 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool TUnitP$TUnitState$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(2U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 133 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual)
#line 133
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED, testId, failMsg, expected, actual);
}

# 41 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1a9d54c0, char *arg_0x1a9d5660, uint32_t arg_0x1a9d57f8, uint32_t arg_0x1a9d5988){
#line 41
  Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(arg_0x1a9d54c0, arg_0x1a9d5660, arg_0x1a9d57f8, arg_0x1a9d5988);
#line 41
}
#line 41
# 61 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool Link_TUnitProcessingP$SendState$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(1U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 111 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static inline   void StateImplP$State$forceState(uint8_t id, uint8_t reqState)
#line 111
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    StateImplP$state[id] = reqState;
#line 112
    __nesc_atomic_end(__nesc_atomic); }
}

# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void Link_TUnitProcessingP$SendState$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(1U, arg_0x1a9e0170);
#line 51
}
#line 51
# 86 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline bool SchedulerBasicP$isWaiting(uint8_t id)
{
  return SchedulerBasicP$m_next[id] != SchedulerBasicP$NO_TASK || SchedulerBasicP$m_tail == id;
}

static inline bool SchedulerBasicP$pushTask(uint8_t id)
{
  if (!SchedulerBasicP$isWaiting(id)) 
    {
      if (SchedulerBasicP$m_head == SchedulerBasicP$NO_TASK) 
        {
          SchedulerBasicP$m_head = id;
          SchedulerBasicP$m_tail = id;
        }
      else 
        {
          SchedulerBasicP$m_next[SchedulerBasicP$m_tail] = id;
          SchedulerBasicP$m_tail = id;
        }
      return TRUE;
    }
  else 
    {
      return FALSE;
    }
}

# 301 "/usr/lib/ncc/nesc_nx.h"
static __inline uint32_t __nesc_hton_uint32(void *target, uint32_t value)
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

#line 240
static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value)
#line 240
{
  uint8_t *base = target;

#line 242
  base[0] = value;
  return value;
}

#line 257
static __inline int8_t __nesc_hton_int8(void *target, int8_t value)
#line 257
{
#line 257
  __nesc_hton_uint8(target, value);
#line 257
  return value;
}

# 137 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(uint8_t testId, char *failMsg, uint32_t actual)
#line 137
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED, testId, failMsg, actual, actual);
}

# 43 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1a9d5e50, char *arg_0x1a9d4010, uint32_t arg_0x1a9d41a0){
#line 43
  Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(arg_0x1a9d5e50, arg_0x1a9d4010, arg_0x1a9d41a0);
#line 43
}
#line 43
# 141 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(uint8_t testId, char *failMsg, uint32_t upperbound, uint32_t actual)
#line 141
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED, testId, failMsg, upperbound, actual);
}

# 45 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1a9d4660, char *arg_0x1a9d4800, uint32_t arg_0x1a9d4998, uint32_t arg_0x1a9d4b28){
#line 45
  Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(arg_0x1a9d4660, arg_0x1a9d4800, arg_0x1a9d4998, arg_0x1a9d4b28);
#line 45
}
#line 45
# 145 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(uint8_t testId, char *failMsg, uint32_t lowerbound, uint32_t actual)
#line 145
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED, testId, failMsg, lowerbound, actual);
}

# 47 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1a9d3010, char *arg_0x1a9d31b0, uint32_t arg_0x1a9d3348, uint32_t arg_0x1a9d34d8){
#line 47
  Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(arg_0x1a9d3010, arg_0x1a9d31b0, arg_0x1a9d3348, arg_0x1a9d34d8);
#line 47
}
#line 47
# 129 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testSuccess(uint8_t testId)
#line 129
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS, testId, (void *)0, 0, 0);
}

# 39 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testSuccess(uint8_t arg_0x1a9d5010){
#line 39
  Link_TUnitProcessingP$TUnitProcessing$testSuccess(arg_0x1a9d5010);
#line 39
}
#line 39
# 149 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testFailed(uint8_t testId, char *failMsg)
#line 149
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_FAILED, testId, failMsg, 0, 0);
}

# 49 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testFailed(uint8_t arg_0x1a9d3998, char *arg_0x1a9d3b38){
#line 49
  Link_TUnitProcessingP$TUnitProcessing$testFailed(arg_0x1a9d3998, arg_0x1a9d3b38);
#line 49
}
#line 49
# 185 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void)
{
}

# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow(void){
#line 37
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow();
#line 37
}
#line 37
# 126 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow();
}





static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n)
{
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(uint8_t arg_0x1ab600f8){
#line 28
  switch (arg_0x1ab600f8) {
#line 28
    case 0:
#line 28
      /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired();
#line 28
      break;
#line 28
    case 1:
#line 28
      /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired();
#line 28
      break;
#line 28
    case 2:
#line 28
      /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired();
#line 28
      break;
#line 28
    case 5:
#line 28
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired();
#line 28
      break;
#line 28
    default:
#line 28
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(arg_0x1ab600f8);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 115 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(0);
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired();
#line 28
}
#line 28
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$__nesc_unnamed4357 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(* (volatile uint16_t *)354U);
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void)
{
  return * (volatile uint16_t *)370U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired();
#line 34
}
#line 34
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$__nesc_unnamed4358 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(* (volatile uint16_t *)356U);
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void)
{
  return * (volatile uint16_t *)372U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired();
#line 34
}
#line 34
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$__nesc_unnamed4359 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(* (volatile uint16_t *)358U);
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void)
{
  return * (volatile uint16_t *)374U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired();
#line 34
}
#line 34
# 120 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)302U;

#line 123
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(n >> 1);
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired();
#line 28
}
#line 28
# 115 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(0);
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired();
#line 28
}
#line 28
# 185 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void)
{
}

#line 185
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void)
{
}

# 186 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void)
#line 186
{
}

# 71 "/svn/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void){
#line 71
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow();
#line 71
}
#line 71
# 53 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void)
{
  /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow();
}

# 37 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow(void){
#line 37
  /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow();
#line 37
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow();
#line 37
}
#line 37
# 126 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow();
}

# 181 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void)
{
  return * (volatile uint16_t *)402U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$__nesc_unnamed4360 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(* (volatile uint16_t *)386U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void)
{
  return * (volatile uint16_t *)404U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$__nesc_unnamed4361 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(* (volatile uint16_t *)388U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void)
{
  return * (volatile uint16_t *)406U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$__nesc_unnamed4362 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(* (volatile uint16_t *)390U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void)
{
  return * (volatile uint16_t *)408U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$__nesc_unnamed4363 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(* (volatile uint16_t *)392U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(/*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void)
{
  return * (volatile uint16_t *)410U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$__nesc_unnamed4364 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(* (volatile uint16_t *)394U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(/*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void)
{
  return * (volatile uint16_t *)412U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$__nesc_unnamed4365 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(* (volatile uint16_t *)396U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(/*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired();
    }
}




static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void)
{
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired();
#line 34
}
#line 34
# 139 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void)
{
  return * (volatile uint16_t *)414U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t n)
{
}

# 75 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x1ab44d58){
#line 75
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(arg_0x1ab44d58);
#line 75
}
#line 75
# 47 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$__nesc_unnamed4366 {
#line 47
    uint16_t f;
#line 47
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t t;
  } 
#line 47
  c = { .f = x };

#line 47
  return c.t;
}

#line 74
static inline   /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void)
{
  return /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(* (volatile uint16_t *)398U);
}

#line 169
static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(/*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired();
    }
}

# 120 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)286U;

#line 123
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(n >> 1);
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired();
#line 28
}
#line 28
# 113 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline  void SchedulerBasicP$Scheduler$init(void)
{
  /* atomic removed: atomic calls only */
  {
    memset((void *)SchedulerBasicP$m_next, SchedulerBasicP$NO_TASK, sizeof SchedulerBasicP$m_next);
    SchedulerBasicP$m_head = SchedulerBasicP$NO_TASK;
    SchedulerBasicP$m_tail = SchedulerBasicP$NO_TASK;
  }
}

# 46 "/svn/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$init(void){
#line 46
  SchedulerBasicP$Scheduler$init();
#line 46
}
#line 46
# 45 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 6;
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set();
#line 34
}
#line 34
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set();
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$set(void){
#line 29
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set();
#line 29
}
#line 29
# 45 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 5;
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set();
#line 34
}
#line 34
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set();
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$set(void){
#line 29
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set();
#line 29
}
#line 29
# 45 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 4;
}

# 34 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set();
#line 34
}
#line 34
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set();
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$set(void){
#line 29
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set();
#line 29
}
#line 29
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 6;
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput();
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$makeOutput(void){
#line 35
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 5;
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput();
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$makeOutput(void){
#line 35
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 4;
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput();
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$makeOutput(void){
#line 35
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput();
#line 35
}
#line 35
# 45 "/svn/tinyos-2.x/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 46
  {
    ;
    LedsP$Led0$makeOutput();
    LedsP$Led1$makeOutput();
    LedsP$Led2$makeOutput();
    LedsP$Led0$set();
    LedsP$Led1$set();
    LedsP$Led2$set();
  }
  return SUCCESS;
}

# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$LedsInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = LedsP$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 33 "../../../../../../../../../../blaze/tos/platforms/tmote1100/hardware.h"
static inline void TOSH_SET_SIMO0_PIN(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x0019");

#line 33
  r |= 1 << 1;
}

#line 34
static inline void TOSH_SET_UCLK0_PIN(void)
#line 34
{
#line 34
   static volatile uint8_t r __asm ("0x0019");

#line 34
  r |= 1 << 3;
}

#line 85
static inline void TOSH_SET_FLASH_CS_PIN(void)
#line 85
{
#line 85
   static volatile uint8_t r __asm ("0x001D");

#line 85
  r |= 1 << 4;
}

#line 34
static inline void TOSH_CLR_UCLK0_PIN(void)
#line 34
{
#line 34
   static volatile uint8_t r __asm ("0x0019");

#line 34
  r &= ~(1 << 3);
}

#line 85
static inline void TOSH_CLR_FLASH_CS_PIN(void)
#line 85
{
#line 85
   static volatile uint8_t r __asm ("0x001D");

#line 85
  r &= ~(1 << 4);
}

# 11 "../../../../../../../../../../blaze/tos/platforms/tmote1100/MotePlatformC.nc"
static __inline void MotePlatformC$TOSH_wait(void)
#line 11
{
   __asm volatile ("nop"); __asm volatile ("nop");}

# 86 "../../../../../../../../../../blaze/tos/platforms/tmote1100/hardware.h"
static inline void TOSH_SET_FLASH_HOLD_PIN(void)
#line 86
{
#line 86
   static volatile uint8_t r __asm ("0x001D");

#line 86
  r |= 1 << 7;
}

#line 85
static inline void TOSH_MAKE_FLASH_CS_OUTPUT(void)
#line 85
{
#line 85
   static volatile uint8_t r __asm ("0x001E");

#line 85
  r |= 1 << 4;
}

#line 86
static inline void TOSH_MAKE_FLASH_HOLD_OUTPUT(void)
#line 86
{
#line 86
   static volatile uint8_t r __asm ("0x001E");

#line 86
  r |= 1 << 7;
}

#line 34
static inline void TOSH_MAKE_UCLK0_OUTPUT(void)
#line 34
{
#line 34
   static volatile uint8_t r __asm ("0x001A");

#line 34
  r |= 1 << 3;
}

#line 33
static inline void TOSH_MAKE_SIMO0_OUTPUT(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x001A");

#line 33
  r |= 1 << 1;
}

# 27 "../../../../../../../../../../blaze/tos/platforms/tmote1100/MotePlatformC.nc"
static inline void MotePlatformC$TOSH_FLASH_M25P_DP(void)
#line 27
{

  TOSH_MAKE_SIMO0_OUTPUT();
  TOSH_MAKE_UCLK0_OUTPUT();
  TOSH_MAKE_FLASH_HOLD_OUTPUT();
  TOSH_MAKE_FLASH_CS_OUTPUT();
  TOSH_SET_FLASH_HOLD_PIN();
  TOSH_SET_FLASH_CS_PIN();

  MotePlatformC$TOSH_wait();


  TOSH_CLR_FLASH_CS_PIN();
  TOSH_CLR_UCLK0_PIN();

  MotePlatformC$TOSH_FLASH_M25P_DP_bit(TRUE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(FALSE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(TRUE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(TRUE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(TRUE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(FALSE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(FALSE);
  MotePlatformC$TOSH_FLASH_M25P_DP_bit(TRUE);

  TOSH_SET_FLASH_CS_PIN();
  TOSH_SET_UCLK0_PIN();
  TOSH_SET_SIMO0_PIN();
}

#line 6
static __inline void MotePlatformC$uwait(uint16_t u)
#line 6
{
  uint16_t t0 = TA0R;

#line 8
  while (TA0R - t0 <= u) ;
}

#line 56
static inline  error_t MotePlatformC$Init$init(void)
#line 56
{
  /* atomic removed: atomic calls only */

  {
    P1SEL = 0;
    P2SEL = 0;
    P3SEL = 0;
    P4SEL = 0;
    P5SEL = 0;
    P6SEL = 0;

    P1DIR = 0xe0;
    P1OUT = 0x00;

    P2DIR = 0x7b;
    P2OUT = 0x30;

    P3DIR = 0xf1;
    P3OUT = 0x00;

    P4DIR = 0xfd;
    P4OUT = 0xdd;

    P5DIR = 0xff;
    P5OUT = 0xff;

    P6DIR = 0xff;
    P6OUT = 0x00;

    P1IE = 0;
    P2IE = 0;






    MotePlatformC$uwait(1024 * 10);

    MotePlatformC$TOSH_FLASH_M25P_DP();
  }

  return SUCCESS;
}

# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$MoteInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = MotePlatformC$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 148 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline void Msp430ClockP$startTimerB(void)
{

  Msp430ClockP$TBCTL = 0x0020 | (Msp430ClockP$TBCTL & ~(0x0020 | 0x0010));
}

#line 136
static inline void Msp430ClockP$startTimerA(void)
{

  Msp430ClockP$TA0CTL = 0x0020 | (Msp430ClockP$TA0CTL & ~(0x0020 | 0x0010));
}

#line 100
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void)
{
  TBR = 0;









  Msp430ClockP$TBCTL = 0x0100 | 0x0002;
}

#line 130
static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerB(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitTimerB();
}

# 32 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerB(void){
#line 32
  Msp430ClockP$Msp430ClockInit$default$initTimerB();
#line 32
}
#line 32
# 85 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void)
{
  TA0R = 0;









  Msp430ClockP$TA0CTL = 0x0200 | 0x0002;
}

#line 125
static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerA(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitTimerA();
}

# 31 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerA(void){
#line 31
  Msp430ClockP$Msp430ClockInit$default$initTimerA();
#line 31
}
#line 31
# 64 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void)
{





  BCSCTL1 = 0x80 | (BCSCTL1 & ((0x04 | 0x02) | 0x01));







  BCSCTL2 = 0x04;


  Msp430ClockP$IE1 &= ~(1 << 1);
}

#line 120
static inline   void Msp430ClockP$Msp430ClockInit$default$initClocks(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitClocks();
}

# 30 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initClocks(void){
#line 30
  Msp430ClockP$Msp430ClockInit$default$initClocks();
#line 30
}
#line 30
# 166 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline uint16_t Msp430ClockP$test_calib_busywait_delta(int calib)
{
  int8_t aclk_count = 2;
  uint16_t dco_prev = 0;
  uint16_t dco_curr = 0;

  Msp430ClockP$set_dco_calib(calib);

  while (aclk_count-- > 0) 
    {
      TBCCR0 = TBR + Msp430ClockP$ACLK_CALIB_PERIOD;
      TBCCTL0 &= ~0x0001;
      while ((TBCCTL0 & 0x0001) == 0) ;
      dco_prev = dco_curr;
      dco_curr = TA0R;
    }

  return dco_curr - dco_prev;
}




static inline void Msp430ClockP$busyCalibrateDco(void)
{

  int calib;
  int step;






  for (calib = 0, step = 0x800; step != 0; step >>= 1) 
    {

      if (Msp430ClockP$test_calib_busywait_delta(calib | step) <= Msp430ClockP$TARGET_DCO_DELTA) {
        calib |= step;
        }
    }

  if ((calib & 0x0e0) == 0x0e0) {
    calib &= ~0x01f;
    }
  Msp430ClockP$set_dco_calib(calib);
}

#line 52
static inline  void Msp430ClockP$Msp430ClockInit$defaultSetupDcoCalibrate(void)
{



  Msp430ClockP$TA0CTL = 0x0200 | 0x0020;
  Msp430ClockP$TBCTL = 0x0100 | 0x0020;
  BCSCTL1 = 0x80 | 0x04;
  BCSCTL2 = 0;
  TBCCTL0 = 0x4000;
}

#line 115
static inline   void Msp430ClockP$Msp430ClockInit$default$setupDcoCalibrate(void)
{
  Msp430ClockP$Msp430ClockInit$defaultSetupDcoCalibrate();
}

# 29 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$setupDcoCalibrate(void){
#line 29
  Msp430ClockP$Msp430ClockInit$default$setupDcoCalibrate();
#line 29
}
#line 29
# 214 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline  error_t Msp430ClockP$Init$init(void)
{

  Msp430ClockP$TA0CTL = 0x0004;
  Msp430ClockP$TA0IV = 0;
  Msp430ClockP$TBCTL = 0x0004;
  Msp430ClockP$TBIV = 0;
  /* atomic removed: atomic calls only */

  {
    Msp430ClockP$Msp430ClockInit$setupDcoCalibrate();
    Msp430ClockP$busyCalibrateDco();
    Msp430ClockP$Msp430ClockInit$initClocks();
    Msp430ClockP$Msp430ClockInit$initTimerA();
    Msp430ClockP$Msp430ClockInit$initTimerB();
    Msp430ClockP$startTimerA();
    Msp430ClockP$startTimerB();
  }

  return SUCCESS;
}

# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$MoteClockInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = Msp430ClockP$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 10 "/svn/tinyos-2.x/tos/platforms/telosa/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void)
#line 10
{
  PlatformP$MoteClockInit$init();
  PlatformP$MoteInit$init();
  PlatformP$LedsInit$init();
  return SUCCESS;
}

# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t RealMainP$PlatformInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = PlatformP$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 33 "../../../../../../../../../../blaze/tos/platforms/tmote1100/hardware.h"
static inline void TOSH_CLR_SIMO0_PIN(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x0019");

#line 33
  r &= ~(1 << 1);
}

# 54 "/svn/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  bool RealMainP$Scheduler$runNextTask(void){
#line 54
  unsigned char result;
#line 54

#line 54
  result = SchedulerBasicP$Scheduler$runNextTask();
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 396 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   message_t *BlazeReceiveP$Receive$default$receive(radio_id_t id, message_t *msg, void *payload, uint8_t len)
#line 396
{
  return msg;
}

# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *BlazeReceiveP$Receive$receive(radio_id_t arg_0x1b8d4820, message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
    result = BlazeReceiveP$Receive$default$receive(arg_0x1b8d4820, arg_0x1aca47c0, arg_0x1aca4960, arg_0x1aca4ae8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 20 "../../../../../../../../../../blaze/tos/chips/blazeradio/packet/BlazePacketP.nc"
static inline blaze_header_t *BlazePacketP$getHeader(message_t *msg)
#line 20
{
  return (blaze_header_t *)(msg->data - sizeof(blaze_header_t ));
}

#line 56
static inline   blaze_header_t *BlazePacketP$BlazePacketBody$getHeader(message_t *msg)
#line 56
{
  return BlazePacketP$getHeader(msg);
}

# 44 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
inline static   blaze_header_t *BlazeReceiveP$BlazePacketBody$getHeader(message_t *arg_0x1b8285a0){
#line 44
  nx_struct blaze_header_t *result;
#line 44

#line 44
  result = BlazePacketP$BlazePacketBody$getHeader(arg_0x1b8285a0);
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/packet/BlazePacketP.nc"
static inline blaze_metadata_t *BlazePacketP$getMetadata(message_t *msg)
#line 24
{
  return (blaze_metadata_t *)msg->metadata;
}

#line 60
static inline   blaze_metadata_t *BlazePacketP$BlazePacketBody$getMetadata(message_t *msg)
#line 60
{
  return BlazePacketP$getMetadata(msg);
}

# 49 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
inline static   blaze_metadata_t *BlazeReceiveP$BlazePacketBody$getMetadata(message_t *arg_0x1b828af0){
#line 49
  nx_struct blaze_metadata_t *result;
#line 49

#line 49
  result = BlazePacketP$BlazePacketBody$getMetadata(arg_0x1b828af0);
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 316 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline  void BlazeReceiveP$receiveDone$runTask(void)
#line 316
{
  blaze_metadata_t *metadata = BlazeReceiveP$BlazePacketBody$getMetadata(BlazeReceiveP$m_msg);
  uint8_t *buf = (uint8_t *)BlazeReceiveP$BlazePacketBody$getHeader(BlazeReceiveP$m_msg);
  uint8_t rxFrameLength = buf[0];
  message_t *atomicMsg;
  uint8_t atomicId;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 323
    atomicId = BlazeReceiveP$m_id;
#line 323
    __nesc_atomic_end(__nesc_atomic); }


  __nesc_hton_uint8((unsigned char *)&metadata->rssi, buf[rxFrameLength]);
  __nesc_hton_uint8((unsigned char *)&metadata->lqi, buf[rxFrameLength + 1] & 0x7f);



  atomicMsg = BlazeReceiveP$Receive$receive(atomicId, BlazeReceiveP$m_msg, BlazeReceiveP$m_msg->data, rxFrameLength);

  if (atomicMsg != (void *)0) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 334
        BlazeReceiveP$m_msg = atomicMsg;
#line 334
        __nesc_atomic_end(__nesc_atomic); }
    }
  else 
#line 335
    {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 336
        BlazeReceiveP$m_msg = &BlazeReceiveP$myMsg;
#line 336
        __nesc_atomic_end(__nesc_atomic); }
    }

  BlazeReceiveP$cleanUp();
}

# 118 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static inline   void StateImplP$State$toIdle(uint8_t id)
#line 118
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 119
    StateImplP$state[id] = StateImplP$S_IDLE;
#line 119
    __nesc_atomic_end(__nesc_atomic); }
}

# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void BlazeReceiveP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(8U);
#line 56
}
#line 56
# 382 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$tx(uint8_t data)
#line 382
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 383
    HplMsp430Usart0P$U0TXBUF = data;
#line 383
    __nesc_atomic_end(__nesc_atomic); }
}

# 224 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(uint8_t arg_0x1af13c68){
#line 224
  HplMsp430Usart0P$Usart$tx(arg_0x1af13c68);
#line 224
}
#line 224
# 330 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   bool HplMsp430Usart0P$Usart$isRxIntrPending(void)
#line 330
{
  if (HplMsp430Usart0P$IFG1 & (1 << 6)) {
      return TRUE;
    }
  return FALSE;
}

# 192 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending(void){
#line 192
  unsigned char result;
#line 192

#line 192
  result = HplMsp430Usart0P$Usart$isRxIntrPending();
#line 192

#line 192
  return result;
#line 192
}
#line 192
# 341 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$clrRxIntr(void)
#line 341
{
  HplMsp430Usart0P$IFG1 &= ~(1 << 6);
}

# 197 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr(void){
#line 197
  HplMsp430Usart0P$Usart$clrRxIntr();
#line 197
}
#line 197
#line 231
inline static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx(void){
#line 231
  unsigned char result;
#line 231

#line 231
  result = HplMsp430Usart0P$Usart$rx();
#line 231

#line 231
  return result;
#line 231
}
#line 231
# 59 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   error_t BlazeSpiP$SpiPacket$send(uint8_t *arg_0x1b432598, uint8_t *arg_0x1b432740, uint16_t arg_0x1b4328d0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID, arg_0x1b432598, arg_0x1b432740, arg_0x1b4328d0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 195 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   error_t BlazeSpiP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 196
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 198
    BlazeSpiP$m_addr = addr;
#line 198
    __nesc_atomic_end(__nesc_atomic); }
  BlazeSpiP$SpiPacket$send((void *)0, data, len);
  return SUCCESS;
}

# 361 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$enableRxIntr(void)
#line 361
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 362
    {
      HplMsp430Usart0P$IFG1 &= ~(1 << 6);
      HplMsp430Usart0P$IE1 |= 1 << 6;
    }
#line 365
    __nesc_atomic_end(__nesc_atomic); }
}

# 180 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$enableRxIntr(void){
#line 180
  HplMsp430Usart0P$Usart$enableRxIntr();
#line 180
}
#line 180
# 316 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   bool HplMsp430Usart0P$Usart$isTxIntrPending(void)
#line 316
{
  if (HplMsp430Usart0P$IFG1 & (1 << 7)) {
      return TRUE;
    }
  return FALSE;
}

# 187 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isTxIntrPending(void){
#line 187
  unsigned char result;
#line 187

#line 187
  result = HplMsp430Usart0P$Usart$isTxIntrPending();
#line 187

#line 187
  return result;
#line 187
}
#line 187
# 337 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$clrTxIntr(void)
#line 337
{
  HplMsp430Usart0P$IFG1 &= ~(1 << 7);
}

# 202 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrTxIntr(void){
#line 202
  HplMsp430Usart0P$Usart$clrTxIntr();
#line 202
}
#line 202
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeReceiveP$Resource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = BlazeSpiP$Resource$release(/*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 113 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(uint8_t id)
#line 113
{
#line 113
  return FAIL;
}

# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(uint8_t arg_0x1b4821b0){
#line 110
  unsigned char result;
#line 110

#line 110
  switch (arg_0x1b4821b0) {
#line 110
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 110
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$release(/*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 110
      break;
#line 110
    default:
#line 110
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(arg_0x1b4821b0);
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
# 80 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(uint8_t id)
#line 80
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(id);
}

# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeSpiP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 325 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline    void BlazeSpiP$ChipSpiResource$default$releasing(void)
#line 325
{
}

# 24 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/ChipSpiResource.nc"
inline static   void BlazeSpiP$ChipSpiResource$releasing(void){
#line 24
  BlazeSpiP$ChipSpiResource$default$releasing();
#line 24
}
#line 24
# 61 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool BlazeSpiP$SpiResourceState$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(5U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 286 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline error_t BlazeSpiP$attemptRelease(void)
#line 286
{
  uint8_t atomicRequests;
  uint8_t atomicHolder;

  /* atomic removed: atomic calls only */
#line 290
  {
    atomicRequests = BlazeSpiP$m_requests;
    atomicHolder = BlazeSpiP$m_holder;
  }



  if ((
#line 295
  atomicRequests > 0
   || atomicHolder != BlazeSpiP$NO_HOLDER)
   || !BlazeSpiP$SpiResourceState$isIdle()) {
      return FAIL;
    }
  /* atomic removed: atomic calls only */
  BlazeSpiP$release = TRUE;

  BlazeSpiP$ChipSpiResource$releasing();
  /* atomic removed: atomic calls only */
#line 304
  {
    if (BlazeSpiP$release) {
        BlazeSpiP$SpiResource$release();
        {
          unsigned char __nesc_temp = 
#line 307
          SUCCESS;

#line 307
          return __nesc_temp;
        }
      }
  }
  return EBUSY;
}

# 50 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEmpty(void)
#line 50
{
  return /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;
}

# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$isEmpty(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 58 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$dequeue(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY) {
        uint8_t id = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead;

#line 62
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead];
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;
          }
#line 65
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ[id] = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;
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
      /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY;

#line 68
      return __nesc_temp;
    }
  }
}

# 60 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$dequeue(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 200 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$granted(void)
#line 200
{
}

# 46 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$granted(void){
#line 46
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$granted();
#line 46
}
#line 46
# 151 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$resetUsart(bool reset)
#line 151
{
  if (reset) {
      U0CTL = 0x01;
    }
  else {
      U0CTL &= ~0x01;
    }
}

# 97 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(bool arg_0x1af1b990){
#line 97
  HplMsp430Usart0P$Usart$resetUsart(arg_0x1af1b990);
#line 97
}
#line 97
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 3);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UCLK$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 2);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SOMI$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 1);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SIMO$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc();
#line 85
}
#line 85
# 247 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$disableSpi(void)
#line 247
{
  /* atomic removed: atomic calls only */
#line 248
  {
    HplMsp430Usart0P$ME1 &= ~(1 << 6);
    HplMsp430Usart0P$SIMO$selectIOFunc();
    HplMsp430Usart0P$SOMI$selectIOFunc();
    HplMsp430Usart0P$UCLK$selectIOFunc();
  }
}

# 158 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi(void){
#line 158
  HplMsp430Usart0P$Usart$disableSpi();
#line 158
}
#line 158
# 88 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(uint8_t id)
#line 88
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(TRUE);
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi();
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(FALSE);
}

# 210 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$unconfigure(uint8_t id)
#line 210
{
}

# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$unconfigure(uint8_t arg_0x1b2cd910){
#line 55
  switch (arg_0x1b2cd910) {
#line 55
    case /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 55
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 55
      break;
#line 55
    default:
#line 55
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$unconfigure(arg_0x1b2cd910);
#line 55
      break;
#line 55
    }
#line 55
}
#line 55
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t BlazeSpiP$grant$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(BlazeSpiP$grant);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 179 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline  void BlazeSpiP$SpiResource$granted(void)
#line 179
{
  BlazeSpiP$grant$postTask();
}

# 118 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(uint8_t id)
#line 118
{
}

# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(uint8_t arg_0x1b484740){
#line 92
  switch (arg_0x1b484740) {
#line 92
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 92
      BlazeSpiP$SpiResource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(arg_0x1b484740);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 94 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(uint8_t id)
#line 94
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(id);
}

# 194 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$default$granted(uint8_t id)
#line 194
{
}

# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$granted(uint8_t arg_0x1b2cfdd8){
#line 92
  switch (arg_0x1b2cfdd8) {
#line 92
    case /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 92
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$default$granted(arg_0x1b2cfdd8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 114 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(uint8_t id)
#line 114
{
  return &msp430_spi_default_config;
}

# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
inline static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(uint8_t arg_0x1b482b10){
#line 39
  union __nesc_unnamed4278 *result;
#line 39

#line 39
    result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(arg_0x1b482b10);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 168 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x1af17a88){
#line 168
  HplMsp430Usart0P$Usart$setModeSpi(arg_0x1af17a88);
#line 168
}
#line 168
# 84 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(uint8_t id)
#line 84
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(id));
}

# 208 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$configure(uint8_t id)
#line 208
{
}

# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$configure(uint8_t arg_0x1b2cd910){
#line 49
  switch (arg_0x1b2cd910) {
#line 49
    case /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 49
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$default$configure(arg_0x1b2cd910);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 182 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$runTask(void)
#line 182
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 183
    {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId;
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_BUSY;
    }
#line 186
    __nesc_atomic_end(__nesc_atomic); }
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId);
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$granted(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId);
}

# 97 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void HplMsp430I2C0P$HplUsart$resetUsart(bool arg_0x1af1b990){
#line 97
  HplMsp430Usart0P$Usart$resetUsart(arg_0x1af1b990);
#line 97
}
#line 97
# 59 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
static inline   void HplMsp430I2C0P$HplI2C$clearModeI2C(void)
#line 59
{
  /* atomic removed: atomic calls only */
#line 60
  {
    HplMsp430I2C0P$U0CTL &= ~((0x20 | 0x04) | 0x01);
    HplMsp430I2C0P$HplUsart$resetUsart(TRUE);
  }
}

# 7 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
inline static   void HplMsp430Usart0P$HplI2C$clearModeI2C(void){
#line 7
  HplMsp430I2C0P$HplI2C$clearModeI2C();
#line 7
}
#line 7
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 5);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$URXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 4);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UTXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc();
#line 85
}
#line 85
# 207 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$disableUart(void)
#line 207
{
  /* atomic removed: atomic calls only */
#line 208
  {
    HplMsp430Usart0P$ME1 &= ~((1 << 7) | (1 << 6));
    HplMsp430Usart0P$UTXD$selectIOFunc();
    HplMsp430Usart0P$URXD$selectIOFunc();
  }
}

#line 143
static inline   void HplMsp430Usart0P$Usart$setUmctl(uint8_t control)
#line 143
{
  U0MCTL = control;
}

#line 132
static inline   void HplMsp430Usart0P$Usart$setUbr(uint16_t control)
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
static inline void HplMsp430Usart0P$configSpi(msp430_spi_union_config_t *config)
#line 256
{

  U0CTL = (config->spiRegisters.uctl | 0x04) | 0x01;
  HplMsp430Usart0P$U0TCTL = config->spiRegisters.utctl;

  HplMsp430Usart0P$Usart$setUbr(config->spiRegisters.ubr);
  HplMsp430Usart0P$Usart$setUmctl(0x00);
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 3;
}

# 78 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UCLK$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc();
#line 78
}
#line 78
# 54 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 2;
}

# 78 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SOMI$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc();
#line 78
}
#line 78
# 54 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 1;
}

# 78 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SIMO$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc();
#line 78
}
#line 78
# 238 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$enableSpi(void)
#line 238
{
  /* atomic removed: atomic calls only */
#line 239
  {
    HplMsp430Usart0P$SIMO$selectModuleFunc();
    HplMsp430Usart0P$SOMI$selectModuleFunc();
    HplMsp430Usart0P$UCLK$selectModuleFunc();
  }
  HplMsp430Usart0P$ME1 |= 1 << 6;
}

#line 345
static inline   void HplMsp430Usart0P$Usart$clrIntr(void)
#line 345
{
  HplMsp430Usart0P$IFG1 &= ~((1 << 7) | (1 << 6));
}









static inline   void HplMsp430Usart0P$Usart$disableIntr(void)
#line 357
{
  HplMsp430Usart0P$IE1 &= ~((1 << 7) | (1 << 6));
}

# 192 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error)
#line 192
{
}

# 71 "/svn/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(uint8_t arg_0x1b483ab0, uint8_t *arg_0x1b431030, uint8_t *arg_0x1b4311d8, uint16_t arg_0x1b431368, error_t arg_0x1b431500){
#line 71
  switch (arg_0x1b483ab0) {
#line 71
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 71
      BlazeSpiP$SpiPacket$sendDone(arg_0x1b431030, arg_0x1b4311d8, arg_0x1b431368, arg_0x1b431500);
#line 71
      break;
#line 71
    default:
#line 71
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(arg_0x1b483ab0, arg_0x1b431030, arg_0x1b4311d8, arg_0x1b431368, arg_0x1b431500);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 185 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone(void)
#line 185
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_client, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len, 
  SUCCESS);
}

#line 168
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void)
#line 168
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 169
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone();
#line 169
    __nesc_atomic_end(__nesc_atomic); }
}

# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   uint8_t BlazeSpiP$State$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(4U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
#line 56
inline static   void BlazeSpiP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(4U);
#line 56
}
#line 56
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t BlazeSpiP$radioInitDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(BlazeSpiP$radioInitDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 152 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline   void BlazeTransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 153
{
}

# 235 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source)
#line 235
{
  const uint8_t *base = source;

#line 237
  return base[0];
}

#line 264
static __inline uint16_t __nesc_ntoh_uint16(const void *source)
#line 264
{
  const uint8_t *base = source;

#line 266
  return ((uint16_t )base[0] << 8) | base[1];
}

static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value)
#line 269
{
  uint8_t *base = target;

#line 271
  base[1] = value;
  base[0] = value >> 8;
  return value;
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t BlazeReceiveP$receiveDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(BlazeReceiveP$receiveDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 400 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline    void BlazeReceiveP$AckReceive$default$receive(am_addr_t source, am_addr_t destination, uint8_t dsn)
#line 400
{
}

# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AckReceive.nc"
inline static   void BlazeReceiveP$AckReceive$receive(am_addr_t arg_0x1b8a0838, am_addr_t arg_0x1b8a09d0, uint8_t arg_0x1b8a0b58){
#line 11
  BlazeReceiveP$AckReceive$default$receive(arg_0x1b8a0838, arg_0x1b8a09d0, arg_0x1b8a0b58);
#line 11
}
#line 11
# 41 "/svn/tinyos-2.x/tos/interfaces/Crc.nc"
inline static  uint16_t PacketCrcP$Crc$crc16(void *arg_0x1b89b6d0, uint8_t arg_0x1b89b858){
#line 41
  unsigned int result;
#line 41

#line 41
  result = CrcC$Crc$crc16(arg_0x1b89b6d0, arg_0x1b89b858);
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 66 "../../../../../../../../../../blaze/tos/chips/blazeradio/crc/PacketCrcP.nc"
static inline   bool PacketCrcP$PacketCrc$verifyCrc(uint8_t *msg)
#line 66
{
  uint8_t originalLength;
  uint16_t packetCrc;
  bool passed;



  originalLength = *msg - 1;

  packetCrc = *(msg + originalLength) << 8;
  packetCrc |= *(msg + originalLength + 1);

  passed = packetCrc == PacketCrcP$Crc$crc16((uint8_t *)msg, originalLength);


  msg[0] -= 2;
  return passed;
}

# 40 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/PacketCrc.nc"
inline static   bool BlazeReceiveP$PacketCrc$verifyCrc(uint8_t *arg_0x1b820550){
#line 40
  unsigned char result;
#line 40

#line 40
  result = PacketCrcP$PacketCrc$verifyCrc(arg_0x1b820550);
#line 40

#line 40
  return result;
#line 40
}
#line 40
# 95 "/svn/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static inline   am_addr_t ActiveMessageAddressC$amAddress(void)
#line 95
{
  am_addr_t myAddr;

  /* atomic removed: atomic calls only */
#line 97
  myAddr = ActiveMessageAddressC$addr;
  return myAddr;
}

#line 61
static inline   am_addr_t ActiveMessageAddressC$ActiveMessageAddress$amAddress(void)
#line 61
{
  return ActiveMessageAddressC$amAddress();
}

# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static   am_addr_t BlazeReceiveP$ActiveMessageAddress$amAddress(void){
#line 50
  unsigned int result;
#line 50

#line 50
  result = ActiveMessageAddressC$ActiveMessageAddress$amAddress();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 34 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$set();
#line 34
}
#line 34
# 37 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set(void)
#line 37
{
#line 37
  /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$set();
}

# 412 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline    void BlazeReceiveP$Csn$default$set(radio_id_t id)
#line 412
{
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeReceiveP$Csn$set(radio_id_t arg_0x1b8d2330){
#line 29
  switch (arg_0x1b8d2330) {
#line 29
    case CC1100_RADIO_ID:
#line 29
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set();
#line 29
      break;
#line 29
    default:
#line 29
      BlazeReceiveP$Csn$default$set(arg_0x1b8d2330);
#line 29
      break;
#line 29
    }
#line 29
}
#line 29
# 53 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
inline static   blaze_status_t BlazeReceiveP$RXFIFO$beginRead(uint8_t *arg_0x1b3efd28, uint8_t arg_0x1b3efeb0){
#line 53
  unsigned char result;
#line 53

#line 53
  result = BlazeSpiP$Fifo$beginRead(BLAZE_RXFIFO, arg_0x1b3efd28, arg_0x1b3efeb0);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 44 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePacketBody.nc"
inline static   blaze_header_t *BlazeTransmitP$BlazePacketBody$getHeader(message_t *arg_0x1b8285a0){
#line 44
  nx_struct blaze_header_t *result;
#line 44

#line 44
  result = BlazePacketP$BlazePacketBody$getHeader(arg_0x1b8285a0);
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 34 "/svn/tinyos-2.x/tos/interfaces/SpiByte.nc"
inline static   uint8_t BlazeSpiP$SpiByte$write(uint8_t arg_0x1b4003e0){
#line 34
  unsigned char result;
#line 34

#line 34
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(arg_0x1b4003e0);
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void BlazeSpiP$State$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(4U, arg_0x1a9e0170);
#line 51
}
#line 51
# 203 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   blaze_status_t BlazeSpiP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 204
{

  uint8_t status;

  BlazeSpiP$State$forceState(BlazeSpiP$S_WRITE_FIFO);
  /* atomic removed: atomic calls only */
#line 209
  BlazeSpiP$m_addr = addr;
  status = BlazeSpiP$SpiByte$write((BlazeSpiP$m_addr | BLAZE_BURST) | BLAZE_WRITE);
  BlazeSpiP$SpiPacket$send(data, (void *)0, len);

  return status;
}

# 84 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
inline static   blaze_status_t BlazeTransmitP$TXFIFO$write(uint8_t *arg_0x1b3ec5d8, uint8_t arg_0x1b3ec760){
#line 84
  unsigned char result;
#line 84

#line 84
  result = BlazeSpiP$Fifo$write(BLAZE_TXFIFO, arg_0x1b3ec5d8, arg_0x1b3ec760);
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 39 "../../../../../../../../../../blaze/tos/chips/blazeradio/crc/PacketCrcP.nc"
static inline   void PacketCrcP$PacketCrc$appendCrc(uint8_t *msg)
#line 39
{

  uint8_t originalLength = *msg + 1;
  uint16_t crc;


  msg[0] += 2;




  crc = PacketCrcP$Crc$crc16((uint8_t *)msg, originalLength);
  msg[originalLength] = crc >> 8;
  msg[originalLength + 1] = crc;
}

# 27 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/PacketCrc.nc"
inline static   void BlazeTransmitP$PacketCrc$appendCrc(uint8_t *arg_0x1b821e48){
#line 27
  PacketCrcP$PacketCrc$appendCrc(arg_0x1b821e48);
#line 27
}
#line 27
# 249 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   blaze_status_t BlazeSpiP$Strobe$strobe(uint8_t addr)
#line 249
{
  return BlazeSpiP$SpiByte$write(addr);
}

# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeTransmitP$SRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeTransmitP$SFTX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeTransmitP$SFRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
inline static   blaze_status_t BlazeTransmitP$RadioStatus$getRadioStatus(void){
#line 11
  unsigned char result;
#line 11

#line 11
  result = BlazeSpiP$RadioStatus$getRadioStatus();
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 39 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$clr();
#line 39
}
#line 39
# 38 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$clr();
}

# 288 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    void BlazeTransmitP$Csn$default$clr(radio_id_t id)
#line 288
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeTransmitP$Csn$clr(radio_id_t arg_0x1b830610){
#line 30
  switch (arg_0x1b830610) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeTransmitP$Csn$default$clr(arg_0x1b830610);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 173 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline error_t BlazeTransmitP$load(uint8_t id, void *msg)
#line 173
{
  uint8_t status;

  /* atomic removed: atomic calls only */
#line 175
  BlazeTransmitP$m_id = id;

  BlazeTransmitP$Csn$clr(BlazeTransmitP$m_id);


  status = BlazeTransmitP$RadioStatus$getRadioStatus();
  if (status == BLAZE_S_RXFIFO_OVERFLOW) {
      BlazeTransmitP$SFRX$strobe();
    }
  else {
#line 183
    if (status == BLAZE_S_TXFIFO_UNDERFLOW) {
        BlazeTransmitP$SFTX$strobe();
      }
    }
  BlazeTransmitP$SRX$strobe();
#line 201
  BlazeTransmitP$PacketCrc$appendCrc(msg);

  BlazeTransmitP$TXFIFO$write(msg, __nesc_ntoh_uint8((unsigned char *)&BlazeTransmitP$BlazePacketBody$getHeader(msg)->length) + 1);
  return SUCCESS;
}

# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t BlazeTransmitP$State$requestState(uint8_t arg_0x1a9e1ba0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(7U, arg_0x1a9e1ba0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 108 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline   error_t BlazeTransmitP$AckSend$load(radio_id_t id, void *msg)
#line 108
{
  if (BlazeTransmitP$State$requestState(BlazeTransmitP$S_LOAD_ACK) != SUCCESS) {
      return FAIL;
    }

  return BlazeTransmitP$load(id, msg);
}

# 6 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   error_t BlazeReceiveP$AckSend$load(radio_id_t arg_0x1b8d3a68, void *arg_0x1b83ba28){
#line 6
  unsigned char result;
#line 6

#line 6
  result = BlazeTransmitP$AckSend$load(arg_0x1b8d3a68, arg_0x1b83ba28);
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 218 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100ControlP.nc"
static inline   bool CC1100ControlP$BlazeConfig$isAutoAckEnabled(void)
#line 218
{
  bool atomicAckEnabled;

  /* atomic removed: atomic calls only */
#line 220
  atomicAckEnabled = CC1100ControlP$autoAck;
  return atomicAckEnabled;
}

# 468 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline    bool BlazeReceiveP$BlazeConfig$default$isAutoAckEnabled(radio_id_t id)
#line 468
{
  return TRUE;
}

# 75 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
inline static   bool BlazeReceiveP$BlazeConfig$isAutoAckEnabled(radio_id_t arg_0x1b8cf4c8){
#line 75
  unsigned char result;
#line 75

#line 75
  switch (arg_0x1b8cf4c8) {
#line 75
    case CC1100_RADIO_ID:
#line 75
      result = CC1100ControlP$BlazeConfig$isAutoAckEnabled();
#line 75
      break;
#line 75
    default:
#line 75
      result = BlazeReceiveP$BlazeConfig$default$isAutoAckEnabled(arg_0x1b8cf4c8);
#line 75
      break;
#line 75
    }
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void BlazeReceiveP$State$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(8U, arg_0x1a9e0170);
#line 51
}
#line 51
#line 71
inline static   uint8_t BlazeReceiveP$State$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(8U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 413 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline    void BlazeReceiveP$Csn$default$clr(radio_id_t id)
#line 413
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeReceiveP$Csn$clr(radio_id_t arg_0x1b8d2330){
#line 30
  switch (arg_0x1b8d2330) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeReceiveP$Csn$default$clr(arg_0x1b8d2330);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 167 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   void BlazeReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error)
#line 168
{

  uint8_t *msg;
  uint8_t id;
  blaze_header_t *header;
  uint8_t rxFrameLength;
  uint8_t *buf;

  /* atomic removed: atomic calls only */
#line 176
  {
    id = BlazeReceiveP$m_id;
    msg = (uint8_t *)BlazeReceiveP$m_msg;
  }

  header = BlazeReceiveP$BlazePacketBody$getHeader((message_t *)msg);
  rxFrameLength = __nesc_ntoh_uint8((unsigned char *)&header->length);
  buf = (uint8_t *)header;


  BlazeReceiveP$Csn$set(id);
  BlazeReceiveP$Csn$clr(id);

  switch (BlazeReceiveP$State$getState()) {
      case BlazeReceiveP$S_RX_LENGTH: 
        BlazeReceiveP$State$forceState(BlazeReceiveP$S_RX_FCF);

      if (rxFrameLength + 1 > BlazeReceiveP$BLAZE_RXFIFO_LENGTH) {


          BlazeReceiveP$failReceive();
          return;
        }
      else {
          if (rxFrameLength <= BlazeReceiveP$MAC_PACKET_SIZE) {
              if (rxFrameLength > 0) {
                  if (rxFrameLength > BlazeReceiveP$SACK_HEADER_LENGTH) {


                      BlazeReceiveP$RXFIFO$beginRead(buf + 1, BlazeReceiveP$SACK_HEADER_LENGTH);
                    }
                  else {





                      BlazeReceiveP$State$forceState(BlazeReceiveP$S_RX_PAYLOAD);
                      BlazeReceiveP$RXFIFO$beginRead(buf + 1, rxFrameLength + 2);
                    }
                }
              else {


                  BlazeReceiveP$failReceive();
                }
            }
          else {


              BlazeReceiveP$failReceive();
            }
        }
      break;

      case BlazeReceiveP$S_RX_FCF: 

        BlazeReceiveP$State$forceState(BlazeReceiveP$S_RX_PAYLOAD);
#line 245
      if (BlazeReceiveP$BlazeConfig$isAutoAckEnabled(BlazeReceiveP$m_id)) {




          if (((__nesc_ntoh_uint16((unsigned char *)&
#line 247
          header->fcf) >> IEEE154_FCF_ACK_REQ) & 0x01) == 1
           && (__nesc_ntoh_uint16((unsigned char *)&header->dest) == BlazeReceiveP$ActiveMessageAddress$amAddress()
           || __nesc_ntoh_uint16((unsigned char *)&header->dest) == AM_BROADCAST_ADDR)
           && ((__nesc_ntoh_uint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_DATA) {


              __nesc_hton_uint16((unsigned char *)&BlazeReceiveP$acknowledgement.dest, __nesc_ntoh_uint16((unsigned char *)&header->src));
              __nesc_hton_uint8((unsigned char *)&BlazeReceiveP$acknowledgement.dsn, __nesc_ntoh_uint8((unsigned char *)&header->dsn));
              __nesc_hton_uint16((unsigned char *)&BlazeReceiveP$acknowledgement.src, BlazeReceiveP$ActiveMessageAddress$amAddress());

              BlazeReceiveP$AckSend$load(BlazeReceiveP$m_id, &BlazeReceiveP$acknowledgement);

              return;
            }
        }



      BlazeReceiveP$RXFIFO$beginRead(buf + 1 + BlazeReceiveP$SACK_HEADER_LENGTH, 
      rxFrameLength - BlazeReceiveP$SACK_HEADER_LENGTH + 2);
      break;

      case BlazeReceiveP$S_RX_PAYLOAD: 


        BlazeReceiveP$Csn$set(id);


      if (__nesc_ntoh_uint16((unsigned char *)&
#line 274
      header->dest) != BlazeReceiveP$ActiveMessageAddress$amAddress()
       && __nesc_ntoh_uint16((unsigned char *)&header->dest) != AM_BROADCAST_ADDR) {
          BlazeReceiveP$cleanUp();
          return;
        }

      if (!BlazeReceiveP$PacketCrc$verifyCrc(msg)) {
          BlazeReceiveP$cleanUp();
          return;
        }



      if (((__nesc_ntoh_uint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_ACK) {
          BlazeReceiveP$AckReceive$receive(__nesc_ntoh_uint16((unsigned char *)&header->src), __nesc_ntoh_uint16((unsigned char *)&header->dest), __nesc_ntoh_uint8((unsigned char *)&header->dsn));
          BlazeReceiveP$cleanUp();
        }
      else {

          BlazeReceiveP$receiveDone$postTask();
        }
      break;


      default: 
        break;
    }
}

# 319 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline    void BlazeSpiP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error)
#line 319
{
}

# 73 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
inline static   void BlazeSpiP$Fifo$readDone(uint8_t arg_0x1b4096a8, uint8_t *arg_0x1b3eec90, uint8_t arg_0x1b3eee18, error_t arg_0x1b3ec010){
#line 73
  switch (arg_0x1b4096a8) {
#line 73
    case BLAZE_TXFIFO:
#line 73
      BlazeTransmitP$TXFIFO$readDone(arg_0x1b3eec90, arg_0x1b3eee18, arg_0x1b3ec010);
#line 73
      break;
#line 73
    case BLAZE_RXFIFO:
#line 73
      BlazeReceiveP$RXFIFO$readDone(arg_0x1b3eec90, arg_0x1b3eee18, arg_0x1b3ec010);
#line 73
      break;
#line 73
    default:
#line 73
      BlazeSpiP$Fifo$default$readDone(arg_0x1b4096a8, arg_0x1b3eec90, arg_0x1b3eee18, arg_0x1b3ec010);
#line 73
      break;
#line 73
    }
#line 73
}
#line 73
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeReceiveP$SIDLE$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SIDLE);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeReceiveP$SFRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
inline static   blaze_status_t BlazeReceiveP$RadioStatus$getRadioStatus(void){
#line 11
  unsigned char result;
#line 11

#line 11
  result = BlazeSpiP$RadioStatus$getRadioStatus();
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 282 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline uint8_t BlazeSpiP$getRadioStatus(void)
#line 282
{
  return (BlazeSpiP$SpiByte$write(BLAZE_SNOP) >> 4) & 0x07;
}

# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeReceiveP$SFTX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeReceiveP$SRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 154 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   void BlazeReceiveP$AckSend$sendDone(radio_id_t id)
#line 154
{
  blaze_header_t *header = BlazeReceiveP$BlazePacketBody$getHeader(BlazeReceiveP$m_msg);
  uint8_t rxFrameLength = __nesc_ntoh_uint8((unsigned char *)&header->length);
  uint8_t *buf = (uint8_t *)header;

  BlazeReceiveP$Csn$clr(id);


  BlazeReceiveP$RXFIFO$beginRead(buf + 1 + BlazeReceiveP$SACK_HEADER_LENGTH, 
  rxFrameLength - BlazeReceiveP$SACK_HEADER_LENGTH + 2);
}

# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   void BlazeTransmitP$AckSend$sendDone(radio_id_t arg_0x1b831ce0){
#line 13
  BlazeReceiveP$AckSend$sendDone(arg_0x1b831ce0);
#line 13
}
#line 13
# 293 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    void BlazeTransmitP$AsyncSend$default$sendDone(radio_id_t id)
#line 293
{
}

# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   void BlazeTransmitP$AsyncSend$sendDone(radio_id_t arg_0x1b831458){
#line 13
    BlazeTransmitP$AsyncSend$default$sendDone(arg_0x1b831458);
#line 13
}
#line 13
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   uint8_t BlazeTransmitP$State$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(7U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 287 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    void BlazeTransmitP$Csn$default$set(radio_id_t id)
#line 287
{
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeTransmitP$Csn$set(radio_id_t arg_0x1b830610){
#line 29
  switch (arg_0x1b830610) {
#line 29
    case CC1100_RADIO_ID:
#line 29
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set();
#line 29
      break;
#line 29
    default:
#line 29
      BlazeTransmitP$Csn$default$set(arg_0x1b830610);
#line 29
      break;
#line 29
    }
#line 29
}
#line 29
# 50 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$enableRisingEdge(void)
#line 50
{
  return /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$enable(TRUE);
}

# 300 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    error_t BlazeTransmitP$TxInterrupt$default$enableRisingEdge(radio_id_t id)
#line 300
{
  return FAIL;
}

# 42 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t BlazeTransmitP$TxInterrupt$enableRisingEdge(radio_id_t arg_0x1b82e238){
#line 42
  unsigned char result;
#line 42

#line 42
  switch (arg_0x1b82e238) {
#line 42
    case CC1100_RADIO_ID:
#line 42
      result = /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$enableRisingEdge();
#line 42
      break;
#line 42
    default:
#line 42
      result = BlazeTransmitP$TxInterrupt$default$enableRisingEdge(arg_0x1b82e238);
#line 42
      break;
#line 42
    }
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void BlazeTransmitP$InterruptState$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(6U, arg_0x1a9e0170);
#line 51
}
#line 51
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeTransmitP$STX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_STX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 201 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port26$clear(void)
#line 201
{
#line 201
  P2IFG &= ~(1 << 6);
}

# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$clear(void){
#line 41
  HplMsp430InterruptP$Port26$clear();
#line 41
}
#line 41
# 193 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port26$disable(void)
#line 193
{
#line 193
  P2IE &= ~(1 << 6);
}

# 36 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$disable(void){
#line 36
  HplMsp430InterruptP$Port26$disable();
#line 36
}
#line 36
# 58 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$disable(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$disable();
    /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$clear();
  }
  return SUCCESS;
}

# 308 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    error_t BlazeTransmitP$TxInterrupt$default$disable(radio_id_t id)
#line 308
{
  return FAIL;
}

# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t BlazeTransmitP$TxInterrupt$disable(radio_id_t arg_0x1b82e238){
#line 50
  unsigned char result;
#line 50

#line 50
  switch (arg_0x1b82e238) {
#line 50
    case CC1100_RADIO_ID:
#line 50
      result = /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$disable();
#line 50
      break;
#line 50
    default:
#line 50
      result = BlazeTransmitP$TxInterrupt$default$disable(arg_0x1b82e238);
#line 50
      break;
#line 50
    }
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 213 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline error_t BlazeTransmitP$transmit(uint8_t id, bool force)
#line 213
{
  uint8_t state;

  /* atomic removed: atomic calls only */
#line 215
  BlazeTransmitP$m_id = id;

  BlazeTransmitP$Csn$clr(id);





  while (BlazeTransmitP$RadioStatus$getRadioStatus() != BLAZE_S_RX) {
      BlazeTransmitP$SFRX$strobe();
      BlazeTransmitP$SRX$strobe();
    }






  BlazeTransmitP$TxInterrupt$disable(id);
  BlazeTransmitP$InterruptState$forceState(S_INTERRUPT_TX);
  BlazeTransmitP$STX$strobe();

  if (force) {
      while (BlazeTransmitP$RadioStatus$getRadioStatus() != BLAZE_S_TX) {

          BlazeTransmitP$STX$strobe();
        }
    }
  else {
      if (BlazeTransmitP$RadioStatus$getRadioStatus() != BLAZE_S_TX) {

          BlazeTransmitP$InterruptState$forceState(S_INTERRUPT_RX);
          BlazeTransmitP$TxInterrupt$enableRisingEdge(id);
          BlazeTransmitP$State$toIdle();
          BlazeTransmitP$Csn$set(id);
          return EBUSY;
        }
    }

  while ((state = BlazeTransmitP$RadioStatus$getRadioStatus()) != BLAZE_S_RX) {
      if (state == BLAZE_S_RXFIFO_OVERFLOW) {
          BlazeTransmitP$SFRX$strobe();
          BlazeTransmitP$SRX$strobe();
        }

      if (state == BLAZE_S_TXFIFO_UNDERFLOW) {
          BlazeTransmitP$SFTX$strobe();
          BlazeTransmitP$SRX$strobe();
        }
    }

  BlazeTransmitP$InterruptState$forceState(S_INTERRUPT_RX);
  BlazeTransmitP$TxInterrupt$enableRisingEdge(id);
  BlazeTransmitP$Csn$set(id);

  state = BlazeTransmitP$State$getState();
  BlazeTransmitP$State$toIdle();

  if (state == BlazeTransmitP$S_TX_PACKET) {
      BlazeTransmitP$AsyncSend$sendDone(id);
    }
  else {
#line 276
    if (state == BlazeTransmitP$S_TX_ACK) {
        BlazeTransmitP$AckSend$sendDone(id);
      }
    }


  return SUCCESS;
}

#line 120
static inline   error_t BlazeTransmitP$AckSend$send(radio_id_t id)
#line 120
{
  if (BlazeTransmitP$State$requestState(BlazeTransmitP$S_TX_ACK) != SUCCESS) {
      return FAIL;
    }

  return BlazeTransmitP$transmit(id, TRUE);
}

# 8 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   error_t BlazeReceiveP$AckSend$send(radio_id_t arg_0x1b8d3a68){
#line 8
  unsigned char result;
#line 8

#line 8
  result = BlazeTransmitP$AckSend$send(arg_0x1b8d3a68);
#line 8

#line 8
  return result;
#line 8
}
#line 8
# 150 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   void BlazeReceiveP$AckSend$loadDone(radio_id_t id, void *msg, error_t error)
#line 150
{
  BlazeReceiveP$AckSend$send(id);
}

# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   void BlazeTransmitP$AckSend$loadDone(radio_id_t arg_0x1b831ce0, void *arg_0x1b83a218, error_t arg_0x1b83a3a0){
#line 11
  BlazeReceiveP$AckSend$loadDone(arg_0x1b831ce0, arg_0x1b83a218, arg_0x1b83a3a0);
#line 11
}
#line 11
# 294 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline    void BlazeTransmitP$AsyncSend$default$loadDone(radio_id_t id, void *msg, error_t error)
#line 294
{
}

# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/AsyncSend.nc"
inline static   void BlazeTransmitP$AsyncSend$loadDone(radio_id_t arg_0x1b831458, void *arg_0x1b83a218, error_t arg_0x1b83a3a0){
#line 11
    BlazeTransmitP$AsyncSend$default$loadDone(arg_0x1b831458, arg_0x1b83a218, arg_0x1b83a3a0);
#line 11
}
#line 11
# 132 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline   void BlazeTransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 133
{

  uint8_t id;
  uint8_t state;

  /* atomic removed: atomic calls only */
#line 138
  id = BlazeTransmitP$m_id;

  BlazeTransmitP$Csn$set(id);

  state = BlazeTransmitP$State$getState();
  BlazeTransmitP$State$toIdle();

  if (state == BlazeTransmitP$S_LOAD_PACKET) {
      BlazeTransmitP$AsyncSend$loadDone(id, tx_buf, error);
    }
  else 
#line 147
    {
      BlazeTransmitP$AckSend$loadDone(id, tx_buf, error);
    }
}

# 303 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   void BlazeReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 303
{
}

# 320 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline    void BlazeSpiP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 320
{
}

# 93 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeFifo.nc"
inline static   void BlazeSpiP$Fifo$writeDone(uint8_t arg_0x1b4096a8, uint8_t *arg_0x1b3ecd60, uint8_t arg_0x1b3ecee8, error_t arg_0x1b3eb088){
#line 93
  switch (arg_0x1b4096a8) {
#line 93
    case BLAZE_TXFIFO:
#line 93
      BlazeTransmitP$TXFIFO$writeDone(arg_0x1b3ecd60, arg_0x1b3ecee8, arg_0x1b3eb088);
#line 93
      break;
#line 93
    case BLAZE_RXFIFO:
#line 93
      BlazeReceiveP$RXFIFO$writeDone(arg_0x1b3ecd60, arg_0x1b3ecee8, arg_0x1b3eb088);
#line 93
      break;
#line 93
    default:
#line 93
      BlazeSpiP$Fifo$default$writeDone(arg_0x1b4096a8, arg_0x1b3ecd60, arg_0x1b3ecee8, arg_0x1b3eb088);
#line 93
      break;
#line 93
    }
#line 93
}
#line 93
# 247 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port26$edge(bool l2h)
#line 247
{
  /* atomic removed: atomic calls only */
#line 248
  {
    if (l2h) {
#line 249
      P2IES &= ~(1 << 6);
      }
    else {
#line 250
      P2IES |= 1 << 6;
      }
  }
}

# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$edge(bool arg_0x1b682010){
#line 56
  HplMsp430InterruptP$Port26$edge(arg_0x1b682010);
#line 56
}
#line 56
# 185 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port26$enable(void)
#line 185
{
#line 185
  P2IE |= 1 << 6;
}

# 31 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$enable(void){
#line 31
  HplMsp430InterruptP$Port26$enable();
#line 31
}
#line 31
# 312 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline  void BlazeReceiveP$BlazeConfig$commitDone(radio_id_t id)
#line 312
{
}

# 19 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeConfig.nc"
inline static  void CC1100ControlP$BlazeConfig$commitDone(void){
#line 19
  BlazeReceiveP$BlazeConfig$commitDone(CC1100_RADIO_ID);
#line 19
}
#line 19
# 230 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100ControlP.nc"
static inline  void CC1100ControlP$BlazeCommit$commitDone(void)
#line 230
{
  CC1100ControlP$BlazeConfig$commitDone();
}

# 369 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   void BlazeInitP$BlazeCommit$default$commitDone(radio_id_t id)
#line 369
{
}

# 16 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeCommit.nc"
inline static  void BlazeInitP$BlazeCommit$commitDone(radio_id_t arg_0x1b76d308){
#line 16
  switch (arg_0x1b76d308) {
#line 16
    case CC1100_RADIO_ID:
#line 16
      CC1100ControlP$BlazeCommit$commitDone();
#line 16
      break;
#line 16
    default:
#line 16
      BlazeInitP$BlazeCommit$default$commitDone(arg_0x1b76d308);
#line 16
      break;
#line 16
    }
#line 16
}
#line 16
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t TUnitP$runDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(TUnitP$runDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 190 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline   void TUnitP$TestCase$done(uint8_t testId)
#line 190
{
  TUnitP$runDone$postTask();
}

# 41 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
inline static   void TestP$TestCC1100Control$done(void){
#line 41
  TUnitP$TestCase$done(/*TestC.TestCC1100ControlC*/TestCaseC$0$TUNIT_TEST_ID);
#line 41
}
#line 41
# 48 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$getRaw(void)
#line 48
{
#line 48
  return * (volatile uint8_t *)52U & (0x01 << 0);
}

#line 49
static inline   bool /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$get(void)
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$getRaw() != 0;
}

# 59 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   bool /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$get(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$get(void)
#line 40
{
#line 40
  return /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$get();
}

# 32 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool TestP$Csn$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 43 "TestP.nc"
static inline  void TestP$SplitControl$stopDone(error_t error)
#line 43
{
  if (!TestP$Csn$get()) {
#line 44
      assertFail("Wrong: Csn is low after stopDone");
    }
  else 
#line 44
    {
#line 44
      assertSuccess();
    }
#line 44
  ;
  if (SUCCESS != error) {
#line 45
      assertEqualsFailed("stopDone failed", (uint32_t )SUCCESS, (uint32_t )error);
    }
  else 
#line 45
    {
#line 45
      assertSuccess();
    }
#line 45
  ;
  TestP$TestCC1100Control$done();
}

# 365 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   void BlazeInitP$SplitControl$default$stopDone(radio_id_t id, error_t error)
#line 365
{
}

# 117 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void BlazeInitP$SplitControl$stopDone(radio_id_t arg_0x1b76e010, error_t arg_0x1a9f0640){
#line 117
  switch (arg_0x1b76e010) {
#line 117
    case CC1100_RADIO_ID:
#line 117
      TestP$SplitControl$stopDone(arg_0x1a9f0640);
#line 117
      break;
#line 117
    default:
#line 117
      BlazeInitP$SplitControl$default$stopDone(arg_0x1b76e010, arg_0x1a9f0640);
#line 117
      break;
#line 117
    }
#line 117
}
#line 117
# 359 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    error_t BlazeInitP$Gdo2_int$default$disable(radio_id_t id)
#line 359
{
#line 359
  return FAIL;
}

# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t BlazeInitP$Gdo2_int$disable(radio_id_t arg_0x1b767218){
#line 50
  unsigned char result;
#line 50

#line 50
    result = BlazeInitP$Gdo2_int$default$disable(arg_0x1b767218);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 355 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    error_t BlazeInitP$Gdo0_int$default$disable(radio_id_t id)
#line 355
{
#line 355
  return FAIL;
}

# 50 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t BlazeInitP$Gdo0_int$disable(radio_id_t arg_0x1b768958){
#line 50
  unsigned char result;
#line 50

#line 50
    result = BlazeInitP$Gdo0_int$default$disable(arg_0x1b768958);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeInitP$DeepSleepResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = BlazeSpiP$Resource$request(/*BlazeInitC.DeepSleepResourceC*/BlazeSpiResourceC$2$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 197 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   error_t BlazeInitP$BlazePower$deepSleep(radio_id_t id)
#line 197
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 198
    BlazeInitP$m_id = id;
#line 198
    __nesc_atomic_end(__nesc_atomic); }
  return BlazeInitP$DeepSleepResource$request();
}

#line 128
static inline  error_t BlazeInitP$SplitControl$stop(radio_id_t id)
#line 128
{
  if (BlazeInitP$state[id] == BlazeInitP$S_OFF) {
      return EALREADY;
    }
  else {
#line 132
    if (BlazeInitP$state[id] == BlazeInitP$S_STOPPING) {
        return SUCCESS;
      }
    else {
#line 135
      if (BlazeInitP$state[id] != BlazeInitP$S_ON) {
          return EBUSY;
        }
      }
    }
  BlazeInitP$BlazePower$deepSleep(id);
  BlazeInitP$BlazePower$shutdown(id);

  BlazeInitP$Gdo0_int$disable(id);
  BlazeInitP$Gdo2_int$disable(id);

  BlazeInitP$state[id] = BlazeInitP$S_OFF;
  BlazeInitP$SplitControl$stopDone(id, SUCCESS);

  return SUCCESS;
}

# 109 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t TestP$SplitControl$stop(void){
#line 109
  unsigned char result;
#line 109

#line 109
  result = BlazeInitP$SplitControl$stop(CC1100_RADIO_ID);
#line 109

#line 109
  return result;
#line 109
}
#line 109
# 30 "TestP.nc"
static inline  void TestP$SplitControl$startDone(error_t error)
#line 30
{
  error_t stopError;

  if (!TestP$Csn$get()) {
#line 33
      assertFail("Wrong: Csn is low after startDone");
    }
  else 
#line 33
    {
#line 33
      assertSuccess();
    }
#line 33
  ;

  stopError = TestP$SplitControl$stop();
  if (stopError) {
      if (SUCCESS != error) {
#line 37
          assertEqualsFailed("stop didn't work", (uint32_t )SUCCESS, (uint32_t )error);
        }
      else 
#line 37
        {
#line 37
          assertSuccess();
        }
#line 37
      ;
      TestP$TestCC1100Control$done();
      return;
    }
}

# 364 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   void BlazeInitP$SplitControl$default$startDone(radio_id_t id, error_t error)
#line 364
{
}

# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void BlazeInitP$SplitControl$startDone(radio_id_t arg_0x1b76e010, error_t arg_0x1a9f18d8){
#line 92
  switch (arg_0x1b76e010) {
#line 92
    case CC1100_RADIO_ID:
#line 92
      TestP$SplitControl$startDone(arg_0x1a9f18d8);
#line 92
      break;
#line 92
    default:
#line 92
      BlazeInitP$SplitControl$default$startDone(arg_0x1b76e010, arg_0x1a9f18d8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 358 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    error_t BlazeInitP$Gdo2_int$default$enableFallingEdge(radio_id_t id)
#line 358
{
#line 358
  return FAIL;
}

# 43 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t BlazeInitP$Gdo2_int$enableFallingEdge(radio_id_t arg_0x1b767218){
#line 43
  unsigned char result;
#line 43

#line 43
    result = BlazeInitP$Gdo2_int$default$enableFallingEdge(arg_0x1b767218);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeInitP$ResetResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = BlazeSpiP$Resource$release(/*BlazeInitC.ResetResourceC*/BlazeSpiResourceC$1$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 317 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Csn$default$set(radio_id_t id)
#line 317
{
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Csn$set(radio_id_t arg_0x1b76b4f0){
#line 29
  switch (arg_0x1b76b4f0) {
#line 29
    case CC1100_RADIO_ID:
#line 29
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$set();
#line 29
      break;
#line 29
    default:
#line 29
      BlazeInitP$Csn$default$set(arg_0x1b76b4f0);
#line 29
      break;
#line 29
    }
#line 29
}
#line 29
# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioStatus.nc"
inline static   blaze_status_t BlazeInitP$RadioStatus$getRadioStatus(void){
#line 11
  unsigned char result;
#line 11

#line 11
  result = BlazeSpiP$RadioStatus$getRadioStatus();
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeInitP$SRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeInitP$SFTX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeInitP$SFRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SFRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   blaze_status_t BlazeInitP$Idle$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SIDLE);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 318 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Csn$default$clr(radio_id_t id)
#line 318
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Csn$clr(radio_id_t arg_0x1b76b4f0){
#line 30
  switch (arg_0x1b76b4f0) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeInitP$Csn$default$clr(arg_0x1b76b4f0);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 64 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeInput(void){
#line 64
  /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeInput();
#line 64
}
#line 64
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeInput(void)
#line 41
{
#line 41
  /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeInput();
}

# 348 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo2_io$default$makeInput(radio_id_t id)
#line 348
{
}

# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo2_io$makeInput(radio_id_t arg_0x1b769d28){
#line 33
  switch (arg_0x1b769d28) {
#line 33
    case CC1100_RADIO_ID:
#line 33
      /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeInput();
#line 33
      break;
#line 33
    default:
#line 33
      BlazeInitP$Gdo2_io$default$makeInput(arg_0x1b769d28);
#line 33
      break;
#line 33
    }
#line 33
}
#line 33
# 64 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeInput(void){
#line 64
  /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeInput();
#line 64
}
#line 64
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeInput(void)
#line 41
{
#line 41
  /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeInput();
}

# 339 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo0_io$default$makeInput(radio_id_t id)
#line 339
{
}

# 33 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo0_io$makeInput(radio_id_t arg_0x1b769120){
#line 33
  switch (arg_0x1b769120) {
#line 33
    case CC1100_RADIO_ID:
#line 33
      /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeInput();
#line 33
      break;
#line 33
    default:
#line 33
      BlazeInitP$Gdo0_io$default$makeInput(arg_0x1b769120);
#line 33
      break;
#line 33
    }
#line 33
}
#line 33
# 220 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline  void BlazeInitP$RadioInit$initDone(void)
#line 220
{

  BlazeInitP$Gdo0_io$makeInput(BlazeInitP$m_id);
  BlazeInitP$Gdo2_io$makeInput(BlazeInitP$m_id);

  BlazeInitP$Csn$set(BlazeInitP$m_id);
  BlazeInitP$Csn$clr(BlazeInitP$m_id);


  BlazeInitP$Idle$strobe();
  BlazeInitP$SFRX$strobe();
  BlazeInitP$SFTX$strobe();
  BlazeInitP$SRX$strobe();
  while (BlazeInitP$RadioStatus$getRadioStatus() != BLAZE_S_RX) ;

  BlazeInitP$Csn$set(BlazeInitP$m_id);

  BlazeInitP$ResetResource$release();

  BlazeInitP$Gdo2_int$enableFallingEdge(BlazeInitP$m_id);

  if (BlazeInitP$state[BlazeInitP$m_id] == BlazeInitP$S_STARTING) {
      BlazeInitP$state[BlazeInitP$m_id] = BlazeInitP$S_ON;
      BlazeInitP$SplitControl$startDone(BlazeInitP$m_id, SUCCESS);
    }
  else {
      BlazeInitP$state[BlazeInitP$m_id] = BlazeInitP$S_ON;
      BlazeInitP$BlazeCommit$commitDone(BlazeInitP$m_id);
    }
}

# 13 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
inline static  void BlazeSpiP$RadioInit$initDone(void){
#line 13
  BlazeInitP$RadioInit$initDone();
#line 13
}
#line 13
# 268 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline  void BlazeSpiP$radioInitDone$runTask(void)
#line 268
{
  BlazeSpiP$RadioInit$initDone();
}

# 202 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$requested(void)
#line 202
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$release();
}

# 73 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$requested(void){
#line 73
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$requested();
#line 73
}
#line 73
# 54 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEnqueued(resource_client_id_t id)
#line 54
{
  return /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ[id] != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY || /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qTail == id;
}

#line 72
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$enqueue(resource_client_id_t id)
#line 72
{
  /* atomic removed: atomic calls only */
#line 73
  {
    if (!/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$isEnqueued(id)) {
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qHead = id;
          }
        else {
#line 78
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qTail] = id;
          }
#line 79
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$qTail = id;
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

# 69 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$enqueue(resource_client_id_t arg_0x1b2a8a98){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$FcfsQueue$enqueue(arg_0x1b2a8a98);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 196 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$requested(uint8_t id)
#line 196
{
}

# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$requested(uint8_t arg_0x1b2ce738){
#line 43
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$requested(arg_0x1b2ce738);
#line 43
}
#line 43
# 77 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$request(uint8_t id)
#line 77
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$requested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId);
  /* atomic removed: atomic calls only */
#line 79
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId = id;
      }
    else {
        unsigned char __nesc_temp = 
#line 84
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$enqueue(id);

#line 84
        return __nesc_temp;
      }
  }
#line 86
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$requested();
  return SUCCESS;
}

# 111 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(uint8_t id)
#line 111
{
#line 111
  return FAIL;
}

# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(uint8_t arg_0x1b4821b0){
#line 78
  unsigned char result;
#line 78

#line 78
  switch (arg_0x1b4821b0) {
#line 78
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 78
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$request(/*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 78
      break;
#line 78
    default:
#line 78
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(arg_0x1b4821b0);
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
# 72 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(uint8_t id)
#line 72
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(id);
}

# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeSpiP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeOutput(void)
#line 52
{
#line 52
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 52
    * (volatile uint8_t *)42U |= 0x01 << 3;
#line 52
    __nesc_atomic_end(__nesc_atomic); }
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$makeOutput();
}

# 341 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo0_io$default$makeOutput(radio_id_t id)
#line 341
{
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo0_io$makeOutput(radio_id_t arg_0x1b769120){
#line 35
  switch (arg_0x1b769120) {
#line 35
    case CC1100_RADIO_ID:
#line 35
      /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeOutput();
#line 35
      break;
#line 35
    default:
#line 35
      BlazeInitP$Gdo0_io$default$makeOutput(arg_0x1b769120);
#line 35
      break;
#line 35
    }
#line 35
}
#line 35
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeOutput(void)
#line 52
{
#line 52
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 52
    * (volatile uint8_t *)42U |= 0x01 << 6;
#line 52
    __nesc_atomic_end(__nesc_atomic); }
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$makeOutput();
}

# 350 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo2_io$default$makeOutput(radio_id_t id)
#line 350
{
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo2_io$makeOutput(radio_id_t arg_0x1b769d28){
#line 35
  switch (arg_0x1b769d28) {
#line 35
    case CC1100_RADIO_ID:
#line 35
      /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeOutput();
#line 35
      break;
#line 35
    default:
#line 35
      BlazeInitP$Gdo2_io$default$makeOutput(arg_0x1b769d28);
#line 35
      break;
#line 35
    }
#line 35
}
#line 35
# 39 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$clr();
#line 39
}
#line 39
# 38 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$HplGeneralIO$clr();
}

# 336 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo0_io$default$clr(radio_id_t id)
#line 336
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo0_io$clr(radio_id_t arg_0x1b769120){
#line 30
  switch (arg_0x1b769120) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeInitP$Gdo0_io$default$clr(arg_0x1b769120);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 39 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$clr();
#line 39
}
#line 39
# 38 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$HplGeneralIO$clr();
}

# 345 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Gdo2_io$default$clr(radio_id_t id)
#line 345
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Gdo2_io$clr(radio_id_t arg_0x1b769d28){
#line 30
  switch (arg_0x1b769d28) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeInitP$Gdo2_io$default$clr(arg_0x1b769d28);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 19 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/DummyIoP.nc"
static inline   void DummyIoP$GeneralIO$clr(void)
#line 19
{
}

# 327 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Power$default$clr(radio_id_t id)
#line 327
{
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Power$clr(radio_id_t arg_0x1b76c888){
#line 30
  switch (arg_0x1b76c888) {
#line 30
    case CC1100_RADIO_ID:
#line 30
      DummyIoP$GeneralIO$clr();
#line 30
      break;
#line 30
    default:
#line 30
      BlazeInitP$Power$default$clr(arg_0x1b76c888);
#line 30
      break;
#line 30
    }
#line 30
}
#line 30
# 49 "TestP.nc"
static inline  void TestP$Resource$granted(void)
#line 49
{
}

# 361 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   void BlazeInitP$BlazePower$default$resetComplete(radio_id_t id)
#line 361
{
}

# 41 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
inline static  void BlazeInitP$BlazePower$resetComplete(radio_id_t arg_0x1b76e870){
#line 41
    BlazeInitP$BlazePower$default$resetComplete(arg_0x1b76e870);
#line 41
}
#line 41
# 127 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100ControlP.nc"
static inline  uint8_t *CC1100ControlP$BlazeRegSettings$getDefaultRegisters(void)
#line 127
{
  return CC1100ControlP$regValues;
}

# 367 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   uint8_t *BlazeInitP$BlazeRegSettings$default$getDefaultRegisters(radio_id_t id)
#line 367
{
#line 367
  return (void *)0;
}

# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeRegSettings.nc"
inline static  uint8_t *BlazeInitP$BlazeRegSettings$getDefaultRegisters(radio_id_t arg_0x1b767a80){
#line 11
  unsigned char *result;
#line 11

#line 11
  switch (arg_0x1b767a80) {
#line 11
    case CC1100_RADIO_ID:
#line 11
      result = CC1100ControlP$BlazeRegSettings$getDefaultRegisters();
#line 11
      break;
#line 11
    default:
#line 11
      result = BlazeInitP$BlazeRegSettings$default$getDefaultRegisters(arg_0x1b767a80);
#line 11
      break;
#line 11
    }
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t BlazeSpiP$State$requestState(uint8_t arg_0x1a9e1ba0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(4U, arg_0x1a9e1ba0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 110 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(uint8_t id)
#line 110
{
#line 110
  return FAIL;
}

# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(uint8_t arg_0x1b4821b0){
#line 118
  unsigned char result;
#line 118

#line 118
  switch (arg_0x1b4821b0) {
#line 118
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 118
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$isOwner(/*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 118
      break;
#line 118
    default:
#line 118
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(arg_0x1b4821b0);
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
# 76 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(uint8_t id)
#line 76
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(id);
}

# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool BlazeSpiP$SpiResource$isOwner(void){
#line 118
  unsigned char result;
#line 118

#line 118
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 67 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline  error_t BlazeSpiP$RadioInit$init(uint8_t startAddr, uint8_t *regs, 
uint8_t len)
#line 68
{

  if (!BlazeSpiP$SpiResource$isOwner()) {
      return ERESERVE;
    }

  if (BlazeSpiP$State$requestState(BlazeSpiP$S_INIT) != SUCCESS) {
      return FAIL;
    }

  BlazeSpiP$SpiByte$write((startAddr | BLAZE_BURST) | BLAZE_WRITE);
  BlazeSpiP$SpiPacket$send(regs, (void *)0, len);

  return SUCCESS;
}

# 11 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/RadioInit.nc"
inline static  error_t BlazeInitP$RadioInit$init(uint8_t arg_0x1b413718, uint8_t *arg_0x1b4138c8, uint8_t arg_0x1b413a50){
#line 11
  unsigned char result;
#line 11

#line 11
  result = BlazeSpiP$RadioInit$init(arg_0x1b413718, arg_0x1b4138c8, arg_0x1b413a50);
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeInitP$SRES$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SRES);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 252 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline  void BlazeInitP$ResetResource$granted(void)
#line 252
{
  uint8_t id;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 255
    id = BlazeInitP$m_id;
#line 255
    __nesc_atomic_end(__nesc_atomic); }

  BlazeInitP$Csn$set(id);
  BlazeInitP$Csn$clr(id);







  BlazeInitP$SRES$strobe();
  BlazeInitP$Csn$set(id);

  BlazeInitP$Csn$clr(id);
  while ((BlazeInitP$Idle$strobe() & 0x80) != 0) ;
  BlazeInitP$Csn$set(id);

  if (BlazeInitP$state[id] == BlazeInitP$S_STARTING || BlazeInitP$state[id] == BlazeInitP$S_COMMITTING) {

      BlazeInitP$Csn$clr(id);
      BlazeInitP$Idle$strobe();


      BlazeInitP$RadioInit$init(BLAZE_IOCFG2, 
      BlazeInitP$BlazeRegSettings$getDefaultRegisters(id), 
      39);
    }
  else 

    {
      BlazeInitP$ResetResource$release();
      BlazeInitP$BlazePower$resetComplete(id);
    }
}

#line 362
static inline   void BlazeInitP$BlazePower$default$deepSleepComplete(radio_id_t id)
#line 362
{
}

# 47 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazePower.nc"
inline static  void BlazeInitP$BlazePower$deepSleepComplete(radio_id_t arg_0x1b76e870){
#line 47
    BlazeInitP$BlazePower$default$deepSleepComplete(arg_0x1b76e870);
#line 47
}
#line 47
# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeInitP$DeepSleepResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = BlazeSpiP$Resource$release(/*BlazeInitC.DeepSleepResourceC*/BlazeSpiResourceC$2$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 45 "../../../../../../../../../../blaze/tos/chips/blazeradio/interfaces/BlazeStrobe.nc"
inline static   blaze_status_t BlazeInitP$SXOFF$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = BlazeSpiP$Strobe$strobe(BLAZE_SXOFF);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 291 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline  void BlazeInitP$DeepSleepResource$granted(void)
#line 291
{
  uint8_t id;

#line 293
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 293
    id = BlazeInitP$m_id;
#line 293
    __nesc_atomic_end(__nesc_atomic); }
  BlazeInitP$Csn$set(id);
  BlazeInitP$Csn$clr(id);
  BlazeInitP$Idle$strobe();
  BlazeInitP$SXOFF$strobe();
  BlazeInitP$Csn$set(id);
  BlazeInitP$DeepSleepResource$release();
  BlazeInitP$BlazePower$deepSleepComplete(id);
}

# 144 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline  void BlazeReceiveP$Resource$granted(void)
#line 144
{
  BlazeReceiveP$receive();
}

# 315 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   void BlazeSpiP$Resource$default$granted(uint8_t id)
#line 315
{
  BlazeSpiP$SpiResource$release();
}

# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void BlazeSpiP$Resource$granted(uint8_t arg_0x1b40ad00){
#line 92
  switch (arg_0x1b40ad00) {
#line 92
    case /*TestC.BlazeSpiResourceC*/BlazeSpiResourceC$0$CLIENT_ID:
#line 92
      TestP$Resource$granted();
#line 92
      break;
#line 92
    case /*BlazeInitC.ResetResourceC*/BlazeSpiResourceC$1$CLIENT_ID:
#line 92
      BlazeInitP$ResetResource$granted();
#line 92
      break;
#line 92
    case /*BlazeInitC.DeepSleepResourceC*/BlazeSpiResourceC$2$CLIENT_ID:
#line 92
      BlazeInitP$DeepSleepResource$granted();
#line 92
      break;
#line 92
    case /*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$CLIENT_ID:
#line 92
      BlazeReceiveP$Resource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      BlazeSpiP$Resource$default$granted(arg_0x1b40ad00);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 272 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline  void BlazeSpiP$grant$runTask(void)
#line 272
{
  uint8_t holder;

#line 274
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 274
    {
      holder = BlazeSpiP$m_holder;
    }
#line 276
    __nesc_atomic_end(__nesc_atomic); }
  BlazeSpiP$Resource$granted(holder);
}

# 17 "/svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
static inline  void TelosSerialP$Resource$granted(void)
#line 17
{
}

# 196 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(uint8_t id)
#line 196
{
}

# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(uint8_t arg_0x1af07910){
#line 92
  switch (arg_0x1af07910) {
#line 92
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 92
      TelosSerialP$Resource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(arg_0x1af07910);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 96 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(uint8_t id)
#line 96
{
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(id);
}

# 194 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id)
#line 194
{
}

# 92 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(uint8_t arg_0x1b2cfdd8){
#line 92
  switch (arg_0x1b2cfdd8) {
#line 92
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 92
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(arg_0x1b2cfdd8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 208 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id)
#line 208
{
}

# 49 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(uint8_t arg_0x1b2cd910){
#line 49
  switch (arg_0x1b2cd910) {
#line 49
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 49
      /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(arg_0x1b2cd910);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 182 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void)
#line 182
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 183
    {
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
    }
#line 186
    __nesc_atomic_end(__nesc_atomic); }
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
}

# 19 "/svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
static inline   msp430_uart_union_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void)
#line 19
{
  return &TelosSerialP$msp430_uart_telos_config;
}

# 192 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    msp430_uart_union_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(uint8_t id)
#line 192
{
  return &msp430_uart_default_config;
}

# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartConfigure.nc"
inline static   msp430_uart_union_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(uint8_t arg_0x1af040f8){
#line 39
  union __nesc_unnamed4282 *result;
#line 39

#line 39
  switch (arg_0x1af040f8) {
#line 39
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 39
      result = TelosSerialP$Msp430UartConfigure$getConfig();
#line 39
      break;
#line 39
    default:
#line 39
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(arg_0x1af040f8);
#line 39
      break;
#line 39
    }
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 359 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$disableIntr(void)
#line 359
{
  HplMsp430Usart1P$IE2 &= ~((1 << 5) | (1 << 4));
}

#line 347
static inline   void HplMsp430Usart1P$Usart$clrIntr(void)
#line 347
{
  HplMsp430Usart1P$IFG2 &= ~((1 << 5) | (1 << 4));
}

#line 159
static inline   void HplMsp430Usart1P$Usart$resetUsart(bool reset)
#line 159
{
  if (reset) {
    U1CTL = 0x01;
    }
  else {
#line 163
    U1CTL &= ~0x01;
    }
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 6;
}

# 78 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UTXD$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc();
#line 78
}
#line 78
# 220 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$enableUartTx(void)
#line 220
{
  HplMsp430Usart1P$UTXD$selectModuleFunc();
  HplMsp430Usart1P$ME2 |= 1 << 5;
}

# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 7);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$URXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc();
#line 85
}
#line 85
# 236 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$disableUartRx(void)
#line 236
{
  HplMsp430Usart1P$ME2 &= ~(1 << 4);
  HplMsp430Usart1P$URXD$selectIOFunc();
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 7;
}

# 78 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$URXD$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc();
#line 78
}
#line 78
# 231 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$enableUartRx(void)
#line 231
{
  HplMsp430Usart1P$URXD$selectModuleFunc();
  HplMsp430Usart1P$ME2 |= 1 << 4;
}

# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 6);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UTXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc();
#line 85
}
#line 85
# 225 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$disableUartTx(void)
#line 225
{
  HplMsp430Usart1P$ME2 &= ~(1 << 5);
  HplMsp430Usart1P$UTXD$selectIOFunc();
}

#line 203
static inline   void HplMsp430Usart1P$Usart$enableUart(void)
#line 203
{
  /* atomic removed: atomic calls only */
#line 204
  {
    HplMsp430Usart1P$UTXD$selectModuleFunc();
    HplMsp430Usart1P$URXD$selectModuleFunc();
  }
  HplMsp430Usart1P$ME2 |= (1 << 5) | (1 << 4);
}

#line 151
static inline   void HplMsp430Usart1P$Usart$setUmctl(uint8_t control)
#line 151
{
  U1MCTL = control;
}

#line 140
static inline   void HplMsp430Usart1P$Usart$setUbr(uint16_t control)
#line 140
{
  /* atomic removed: atomic calls only */
#line 141
  {
    U1BR0 = control & 0x00FF;
    U1BR1 = (control >> 8) & 0x00FF;
  }
}

#line 283
static inline void HplMsp430Usart1P$configUart(msp430_uart_union_config_t *config)
#line 283
{

  U1CTL = (config->uartRegisters.uctl & ~0x04) | 0x01;
  HplMsp430Usart1P$U1TCTL = config->uartRegisters.utctl;
  HplMsp430Usart1P$U1RCTL = config->uartRegisters.urctl;

  HplMsp430Usart1P$Usart$setUbr(config->uartRegisters.ubr);
  HplMsp430Usart1P$Usart$setUmctl(config->uartRegisters.umctl);
}

static inline   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_union_config_t *config)
#line 293
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 295
    {
      HplMsp430Usart1P$Usart$resetUsart(TRUE);
      HplMsp430Usart1P$Usart$disableSpi();
      HplMsp430Usart1P$configUart(config);
      if (config->uartConfig.utxe == 1 && config->uartConfig.urxe == 1) {
          HplMsp430Usart1P$Usart$enableUart();
        }
      else {
#line 301
        if (config->uartConfig.utxe == 0 && config->uartConfig.urxe == 1) {
            HplMsp430Usart1P$Usart$disableUartTx();
            HplMsp430Usart1P$Usart$enableUartRx();
          }
        else {
#line 304
          if (config->uartConfig.utxe == 1 && config->uartConfig.urxe == 0) {
              HplMsp430Usart1P$Usart$disableUartRx();
              HplMsp430Usart1P$Usart$enableUartTx();
            }
          else 
#line 307
            {
              HplMsp430Usart1P$Usart$disableUart();
            }
          }
        }
#line 310
      HplMsp430Usart1P$Usart$resetUsart(FALSE);
      HplMsp430Usart1P$Usart$clrIntr();
      HplMsp430Usart1P$Usart$disableIntr();
    }
#line 313
    __nesc_atomic_end(__nesc_atomic); }

  return;
}

# 174 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(msp430_uart_union_config_t *arg_0x1af150a8){
#line 174
  HplMsp430Usart1P$Usart$setModeUart(arg_0x1af150a8);
#line 174
}
#line 174
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 1);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$SIMO$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 2);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$SOMI$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 3);
}

# 85 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UCLK$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc();
#line 85
}
#line 85
# 377 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$enableIntr(void)
#line 377
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 378
    {
      HplMsp430Usart1P$IFG2 &= ~((1 << 5) | (1 << 4));
      HplMsp430Usart1P$IE2 |= (1 << 5) | (1 << 4);
    }
#line 381
    __nesc_atomic_end(__nesc_atomic); }
}

# 182 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr(void){
#line 182
  HplMsp430Usart1P$Usart$enableIntr();
#line 182
}
#line 182
# 49 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline serial_header_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(message_t *msg)
#line 49
{
  return (serial_header_t *)(msg->data - sizeof(serial_header_t ));
}

#line 151
static inline  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg)
#line 151
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 153
  return __nesc_ntoh_uint8((unsigned char *)&header->type);
}

# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8){
#line 99
  Link_TUnitProcessingP$SerialEventSend$sendDone(arg_0x1acaa030, arg_0x1acaa1b8);
#line 99
}
#line 99
# 57 "/svn/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(m, err);
}

# 207 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err)
#line 207
{
}

# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(uint8_t arg_0x1ad39278, message_t *arg_0x1ad17df0, error_t arg_0x1ad16010){
#line 89
  switch (arg_0x1ad39278) {
#line 89
    case 0U:
#line 89
      /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(arg_0x1ad17df0, arg_0x1ad16010);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(arg_0x1ad39278, arg_0x1ad17df0, arg_0x1ad16010);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 155 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(uint8_t last, message_t *msg, error_t err)
#line 155
{
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[last].msg = (void *)0;
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend();
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(last, msg, err);
}

#line 181
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(am_id_t id, message_t *msg, error_t err)
#line 181
{





  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current >= 1) {
      return;
    }
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg == msg) {
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current, msg, err);
    }
  else {
      ;
    }
}

# 99 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(am_id_t arg_0x1ad78118, message_t *arg_0x1acaa030, error_t arg_0x1acaa1b8){
#line 99
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(arg_0x1ad78118, arg_0x1acaa030, arg_0x1acaa1b8);
#line 99
}
#line 99
# 81 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *msg, error_t result)
#line 81
{
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, result);
}

# 362 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error)
#line 362
{
  return;
}

# 89 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(uart_id_t arg_0x1ae5b960, message_t *arg_0x1ad17df0, error_t arg_0x1ad16010){
#line 89
  switch (arg_0x1ae5b960) {
#line 89
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 89
      /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(arg_0x1ad17df0, arg_0x1ad16010);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(arg_0x1ae5b960, arg_0x1ad17df0, arg_0x1ad16010);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 147 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void)
#line 147
{
  error_t error;

  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 151
    error = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError;
#line 151
    __nesc_atomic_end(__nesc_atomic); }

  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled) {
#line 153
    error = ECANCEL;
    }
#line 154
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId, (message_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer, error);
}

# 57 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket(void)
#line 57
{
  uint8_t i;

#line 59
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current + 1) % 1;
  for (i = 0; i < 1; i++) {
      if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg == (void *)0 || 
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current / 8] & (1 << /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current % 8)) 
        {
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current + 1) % 1;
        }
      else {
          break;
        }
    }
  if (i >= 1) {
#line 70
    /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = 1;
    }
}

# 101 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg)
#line 101
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg);

#line 103
  return __nesc_ntoh_uint8((unsigned char *)&header->length);
}

# 67 "/svn/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x1ace1468){
#line 67
  unsigned char result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(arg_0x1ace1468);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 522 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   error_t SerialP$SendBytePacket$startSend(uint8_t b)
#line 522
{
  bool not_busy = FALSE;

#line 524
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 524
    {
      if (SerialP$txBuf[SerialP$TX_DATA_INDEX].state == SerialP$BUFFER_AVAILABLE) {
          SerialP$txBuf[SerialP$TX_DATA_INDEX].state = SerialP$BUFFER_FILLING;
          SerialP$txBuf[SerialP$TX_DATA_INDEX].buf = b;
          not_busy = TRUE;
        }
    }
#line 530
    __nesc_atomic_end(__nesc_atomic); }
  if (not_busy) {
      SerialP$MaybeScheduleTx();
      return SUCCESS;
    }
  return EBUSY;
}

# 51 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x1adc1170){
#line 51
  unsigned char result;
#line 51

#line 51
  result = SerialP$SendBytePacket$startSend(arg_0x1adc1170);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 43 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen)
#line 43
{
  return upperLen + sizeof(serial_header_t );
}

# 347 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen)
#line 348
{
  return 0;
}

# 23 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(uart_id_t arg_0x1ae5a380, message_t *arg_0x1adb4560, uint8_t arg_0x1adb46f0){
#line 23
  unsigned char result;
#line 23

#line 23
  switch (arg_0x1ae5a380) {
#line 23
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 23
      result = SerialPacketInfoActiveMessageP$Info$dataLinkLength(arg_0x1adb4560, arg_0x1adb46f0);
#line 23
      break;
#line 23
    default:
#line 23
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(arg_0x1ae5a380, arg_0x1adb4560, arg_0x1adb46f0);
#line 23
      break;
#line 23
    }
#line 23

#line 23
  return result;
#line 23
}
#line 23
# 40 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void)
#line 40
{
  return (uint8_t )(sizeof(message_header_t ) - sizeof(serial_header_t ));
}

# 344 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id)
#line 344
{
  return 0;
}

# 15 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(uart_id_t arg_0x1ae5a380){
#line 15
  unsigned char result;
#line 15

#line 15
  switch (arg_0x1ae5a380) {
#line 15
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 15
      result = SerialPacketInfoActiveMessageP$Info$offset();
#line 15
      break;
#line 15
    default:
#line 15
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(arg_0x1ae5a380);
#line 15
      break;
#line 15
    }
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 100 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(uint8_t id, message_t *msg, uint8_t len)
#line 100
{
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState != /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE) {
      return EBUSY;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 105
    {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(id);
      if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex > sizeof(message_header_t )) {
          {
            unsigned char __nesc_temp = 
#line 108
            ESIZE;

            {
#line 108
              __nesc_atomic_end(__nesc_atomic); 
#line 108
              return __nesc_temp;
            }
          }
        }
#line 111
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = SUCCESS;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer = (uint8_t *)msg;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_DATA;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId = id;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled = FALSE;






      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendLen = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(id, msg, len) + /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex;
    }
#line 123
    __nesc_atomic_end(__nesc_atomic); }
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(id) == SUCCESS) {
      return SUCCESS;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
      return FAIL;
    }
}

# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(TOS_SERIAL_ACTIVE_MESSAGE_ID, arg_0x1ad18bc0, arg_0x1ad18d48);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t SerialP$RunTx$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(SerialP$RunTx);
#line 56

#line 56
  return result;
#line 56
}
#line 56
inline static   error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void Link_TUnitProcessingP$SendState$toIdle(void){
#line 56
  StateImplP$State$toIdle(1U);
#line 56
}
#line 56
# 201 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which)
#line 201
{
  if (which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 0;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 0;
    }
}

# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void TUnitP$TUnitState$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(2U, arg_0x1a9e0170);
#line 51
}
#line 51
# 288 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$tearDownOneTimeDone(void)
#line 288
{
  TUnitP$TUnitState$forceState(TUnitP$S_READY);
  TUnitP$TestState$toIdle();
}

#line 360
static inline   void TUnitP$TearDownOneTime$default$run(void)
#line 360
{
  TUnitP$tearDownOneTimeDone();
}

# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$TearDownOneTime$run(void){
#line 38
  TUnitP$TearDownOneTime$default$run();
#line 38
}
#line 38
# 182 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TUnitProcessing$tearDownOneTime(void)
#line 182
{
  TUnitP$TUnitState$forceState(TUnitP$S_TEARDOWN_ONETIME);
  TUnitP$TearDownOneTime$run();
}

# 61 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void Link_TUnitProcessingP$TUnitProcessing$tearDownOneTime(void){
#line 61
  TUnitP$TUnitProcessing$tearDownOneTime();
#line 61
}
#line 61
# 158 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$TUnitProcessing$pong(void)
#line 158
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_PONG, 0xFF, (void *)0, 0, 0);
}

# 54 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void TUnitP$TUnitProcessing$pong(void){
#line 54
  Link_TUnitProcessingP$TUnitProcessing$pong();
#line 54
}
#line 54
# 178 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TUnitProcessing$ping(void)
#line 178
{
  TUnitP$TUnitProcessing$pong();
}

# 59 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void Link_TUnitProcessingP$TUnitProcessing$ping(void){
#line 59
  TUnitP$TUnitProcessing$ping();
#line 59
}
#line 59
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t TUnitP$begin$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(TUnitP$begin);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 172 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TUnitProcessing$run(void)
#line 172
{


  TUnitP$begin$postTask();
}

# 57 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void Link_TUnitProcessingP$TUnitProcessing$run(void){
#line 57
  TUnitP$TUnitProcessing$run();
#line 57
}
#line 57
# 180 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline void Link_TUnitProcessingP$execute(TUnitProcessingMsg *inMsg)
#line 180
{
  switch (__nesc_ntoh_uint8((unsigned char *)&inMsg->cmd)) {
      case TUNITPROCESSING_CMD_RUN: 
        Link_TUnitProcessingP$TUnitProcessing$run();
      break;

      case TUNITPROCESSING_CMD_PING: 
        Link_TUnitProcessingP$TUnitProcessing$ping();
      break;

      case TUNITPROCESSING_CMD_TEARDOWNONETIME: 
        Link_TUnitProcessingP$TUnitProcessing$tearDownOneTime();
      break;

      default: ;
    }
}

#line 112
static inline  message_t *Link_TUnitProcessingP$SerialReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 112
{
  Link_TUnitProcessingP$execute(payload);
  return msg;
}

# 89 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline   message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(uint8_t id, message_t *msg, void *payload, uint8_t len)
#line 89
{
  return msg;
}

# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(am_id_t arg_0x1ad78a48, message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x1ad78a48) {
#line 67
    case 255:
#line 67
      result = Link_TUnitProcessingP$SerialReceive$receive(arg_0x1aca47c0, arg_0x1aca4960, arg_0x1aca4ae8);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(arg_0x1ad78a48, arg_0x1aca47c0, arg_0x1aca4960, arg_0x1aca4ae8);
#line 67
      break;
#line 67
    }
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 93 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 93
{
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, msg->data, len);
}

# 357 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len)
#line 359
{
  return msg;
}

# 67 "/svn/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(uart_id_t arg_0x1ae5b3a8, message_t *arg_0x1aca47c0, void *arg_0x1aca4960, uint8_t arg_0x1aca4ae8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x1ae5b3a8) {
#line 67
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(arg_0x1aca47c0, arg_0x1aca4960, arg_0x1aca4ae8);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(arg_0x1ae5b3a8, arg_0x1aca47c0, arg_0x1aca4960, arg_0x1aca4ae8);
#line 67
      break;
#line 67
    }
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 46 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen)
#line 46
{
  return dataLinkLen - sizeof(serial_header_t );
}

# 351 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen)
#line 352
{
  return 0;
}

# 31 "/svn/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(uart_id_t arg_0x1ae5a380, message_t *arg_0x1adb4d58, uint8_t arg_0x1adb4ee8){
#line 31
  unsigned char result;
#line 31

#line 31
  switch (arg_0x1ae5a380) {
#line 31
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 31
      result = SerialPacketInfoActiveMessageP$Info$upperLength(arg_0x1adb4d58, arg_0x1adb4ee8);
#line 31
      break;
#line 31
    default:
#line 31
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(arg_0x1ae5a380, arg_0x1adb4d58, arg_0x1adb4ee8);
#line 31
      break;
#line 31
    }
#line 31

#line 31
  return result;
#line 31
}
#line 31
# 264 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void)
#line 264
{
  uart_id_t myType;
  message_t *myBuf;
  uint8_t mySize;
  uint8_t myWhich;

#line 269
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 269
    {
      myType = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskType;
      myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskBuf;
      mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskSize;
      myWhich = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskWhich;
    }
#line 274
    __nesc_atomic_end(__nesc_atomic); }
  mySize -= /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(myType);
  mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(myType, myBuf, mySize);
  myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(myType, myBuf, myBuf, mySize);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 278
    {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[myWhich] = myBuf;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(myWhich);
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending = FALSE;
    }
#line 282
    __nesc_atomic_end(__nesc_atomic); }
}

# 168 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$SerialSplitControl$stopDone(error_t error)
#line 168
{
}

# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void Link_TUnitProcessingP$SerialState$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(0U, arg_0x1a9e0170);
#line 51
}
#line 51
# 107 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$SerialSplitControl$stopDone(error_t error)
#line 107
{
  Link_TUnitProcessingP$SerialState$forceState(Link_TUnitProcessingP$S_OFF);
}

# 117 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$stopDone(error_t arg_0x1a9f0640){
#line 117
  Link_TUnitProcessingP$SerialSplitControl$stopDone(arg_0x1a9f0640);
#line 117
  TUnitP$SerialSplitControl$stopDone(arg_0x1a9f0640);
#line 117
}
#line 117
# 97 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$resetUsart(bool arg_0x1af1b990){
#line 97
  HplMsp430Usart1P$Usart$resetUsart(arg_0x1af1b990);
#line 97
}
#line 97
#line 128
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart(void){
#line 128
  HplMsp430Usart1P$Usart$disableUart();
#line 128
}
#line 128
#line 179
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr(void){
#line 179
  HplMsp430Usart1P$Usart$disableIntr();
#line 179
}
#line 179
# 89 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(uint8_t id)
#line 89
{
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$resetUsart(TRUE);
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr();
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart();
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$resetUsart(FALSE);
}

# 210 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id)
#line 210
{
}

# 55 "/svn/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(uint8_t arg_0x1b2cd910){
#line 55
  switch (arg_0x1b2cd910) {
#line 55
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 55
      /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 55
      break;
#line 55
    default:
#line 55
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(arg_0x1b2cd910);
#line 55
      break;
#line 55
    }
#line 55
}
#line 55
# 109 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   error_t HplMsp430Usart1P$AsyncStdControl$stop(void)
#line 109
{
  HplMsp430Usart1P$Usart$disableSpi();
  HplMsp430Usart1P$Usart$disableUart();
  return SUCCESS;
}

# 84 "/svn/tinyos-2.x/tos/interfaces/AsyncStdControl.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = HplMsp430Usart1P$AsyncStdControl$stop();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 74 "/svn/tinyos-2.x/tos/lib/power/AsyncPowerManagerP.nc"
static inline    void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void)
#line 74
{
}

# 52 "/svn/tinyos-2.x/tos/lib/power/PowerDownCleanup.nc"
inline static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup(void){
#line 52
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup();
#line 52
}
#line 52
# 69 "/svn/tinyos-2.x/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$granted(void)
#line 69
{
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup();
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop();
}

# 46 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted(void){
#line 46
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$granted();
#line 46
}
#line 46
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 58 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    if (/*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead != /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
        uint8_t id = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead;

#line 62
        /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[/*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead];
        if (/*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
          /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
          }
#line 65
        /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[id] = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
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
      /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

#line 68
      return __nesc_temp;
    }
  }
}

# 60 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 50 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void)
#line 50
{
  return /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
}

# 43 "/svn/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 108 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id)
#line 108
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY && /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
          if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty() == FALSE) {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue();
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
            }
          else {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted();
            }
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(id);
        }
    }
#line 123
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 191 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(uint8_t id)
#line 191
{
#line 191
  return FAIL;
}

# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(uint8_t arg_0x1af05778){
#line 110
  unsigned char result;
#line 110

#line 110
  switch (arg_0x1af05778) {
#line 110
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 110
      result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(/*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID);
#line 110
      break;
#line 110
    default:
#line 110
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(arg_0x1af05778);
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
# 76 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(uint8_t id)
#line 76
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf || /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf) {
    return EBUSY;
    }
#line 79
  return /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(id);
}

# 110 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t TelosSerialP$Resource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 13 "/svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
static inline  error_t TelosSerialP$StdControl$stop(void)
#line 13
{
  TelosSerialP$Resource$release();
  return SUCCESS;
}

# 84 "/svn/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = TelosSerialP$StdControl$stop();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 330 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  void SerialP$SerialFlush$flushDone(void)
#line 330
{
  SerialP$SerialControl$stop();
  SerialP$SplitControl$stopDone(SUCCESS);
}

static inline  void SerialP$defaultSerialFlushTask$runTask(void)
#line 335
{
  SerialP$SerialFlush$flushDone();
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t SerialP$defaultSerialFlushTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(SerialP$defaultSerialFlushTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 338 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFlush$default$flush(void)
#line 338
{
  SerialP$defaultSerialFlushTask$postTask();
}

# 38 "/svn/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
inline static  void SerialP$SerialFlush$flush(void){
#line 38
  SerialP$SerialFlush$default$flush();
#line 38
}
#line 38
# 326 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  void SerialP$stopDoneTask$runTask(void)
#line 326
{
  SerialP$SerialFlush$flush();
}

# 344 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline   void TUnitP$SetUpOneTime$default$run(void)
#line 344
{
  TUnitP$setUpOneTimeDone();
}

# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$SetUpOneTime$run(void){
#line 38
  TUnitP$SetUpOneTime$default$run();
#line 38
}
#line 38
# 51 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   void TUnitP$TestState$forceState(uint8_t arg_0x1a9e0170){
#line 51
  StateImplP$State$forceState(3U, arg_0x1a9e0170);
#line 51
}
#line 51
#line 71
inline static   uint8_t TUnitP$TUnitState$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(2U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 152 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$SerialSplitControl$startDone(error_t error)
#line 152
{
  if (TUnitP$TUnitState$getState() == TUnitP$S_NOT_BOOTED) {
      TUnitP$TUnitState$forceState(TUnitP$S_READY);

      if (!TUnitP$driver) {




          TUnitP$TUnitState$forceState(TUnitP$S_RUNNING);
          TUnitP$TestState$forceState(TUnitP$S_SETUP_ONETIME);
          TUnitP$SetUpOneTime$run();
        }
    }
}

# 103 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$SerialSplitControl$startDone(error_t error)
#line 103
{
  Link_TUnitProcessingP$SerialState$forceState(Link_TUnitProcessingP$S_ON);
}

# 92 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$startDone(error_t arg_0x1a9f18d8){
#line 92
  Link_TUnitProcessingP$SerialSplitControl$startDone(arg_0x1a9f18d8);
#line 92
  TUnitP$SerialSplitControl$startDone(arg_0x1a9f18d8);
#line 92
}
#line 92
# 127 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void)
#line 127
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 128
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id) {
          if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING) {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
              {
                unsigned char __nesc_temp = 
#line 132
                SUCCESS;

                {
#line 132
                  __nesc_atomic_end(__nesc_atomic); 
#line 132
                  return __nesc_temp;
                }
              }
            }
          else {
#line 134
            if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING) {
                /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
                /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
                {
                  unsigned char __nesc_temp = 
#line 137
                  SUCCESS;

                  {
#line 137
                    __nesc_atomic_end(__nesc_atomic); 
#line 137
                    return __nesc_temp;
                  }
                }
              }
            }
        }
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
#line 141
  return FAIL;
}

# 56 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$release(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release();
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 105 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   error_t HplMsp430Usart1P$AsyncStdControl$start(void)
#line 105
{
  return SUCCESS;
}

# 74 "/svn/tinyos-2.x/tos/interfaces/AsyncStdControl.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = HplMsp430Usart1P$AsyncStdControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 64 "/svn/tinyos-2.x/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$immediateRequested(void)
#line 64
{
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start();
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$release();
}

# 81 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested(void){
#line 81
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceDefaultOwner$immediateRequested();
#line 81
}
#line 81
# 198 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id)
#line 198
{
}

# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(uint8_t arg_0x1b2ce738){
#line 51
    /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(arg_0x1b2ce738);
#line 51
}
#line 51
# 90 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id)
#line 90
{
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 92
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) {
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING;
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = id;
        }
      else {
          unsigned char __nesc_temp = 
#line 97
          FAIL;

          {
#line 97
            __nesc_atomic_end(__nesc_atomic); 
#line 97
            return __nesc_temp;
          }
        }
    }
#line 100
    __nesc_atomic_end(__nesc_atomic); }
#line 99
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested();
  if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
      return SUCCESS;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 104
    /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
#line 104
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 190 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(uint8_t id)
#line 190
{
#line 190
  return FAIL;
}

# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(uint8_t arg_0x1af05778){
#line 87
  unsigned char result;
#line 87

#line 87
  switch (arg_0x1af05778) {
#line 87
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 87
      result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(/*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID);
#line 87
      break;
#line 87
    default:
#line 87
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(arg_0x1af05778);
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
# 64 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(uint8_t id)
#line 64
{
  return /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(id);
}

# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t TelosSerialP$Resource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 10 "/svn/tinyos-2.x/tos/platforms/telosa/TelosSerialP.nc"
static inline  error_t TelosSerialP$StdControl$start(void)
#line 10
{
  return TelosSerialP$Resource$immediateRequest();
}

# 74 "/svn/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = TelosSerialP$StdControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 320 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  void SerialP$startDoneTask$runTask(void)
#line 320
{
  SerialP$SerialControl$start();
  SerialP$SplitControl$startDone(SUCCESS);
}

# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t TUnitP$TestState$requestState(uint8_t arg_0x1a9e1ba0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(3U, arg_0x1a9e1ba0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeInitP$ResetResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = BlazeSpiP$Resource$request(/*BlazeInitC.ResetResourceC*/BlazeSpiResourceC$1$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 188 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline   error_t BlazeInitP$BlazePower$reset(radio_id_t id)
#line 188
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 189
    BlazeInitP$m_id = id;
#line 189
    __nesc_atomic_end(__nesc_atomic); }
  return BlazeInitP$ResetResource$request();
}

# 16 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/DummyIoP.nc"
static inline   void DummyIoP$GeneralIO$set(void)
#line 16
{
}

# 326 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline    void BlazeInitP$Power$default$set(radio_id_t id)
#line 326
{
}

# 29 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void BlazeInitP$Power$set(radio_id_t arg_0x1b76c888){
#line 29
  switch (arg_0x1b76c888) {
#line 29
    case CC1100_RADIO_ID:
#line 29
      DummyIoP$GeneralIO$set();
#line 29
      break;
#line 29
    default:
#line 29
      BlazeInitP$Power$default$set(arg_0x1b76c888);
#line 29
      break;
#line 29
    }
#line 29
}
#line 29
# 101 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline  error_t BlazeInitP$SplitControl$start(radio_id_t id)
#line 101
{
  if (id >= 1U) {
      return EINVAL;
    }

  if (BlazeInitP$state[id] == BlazeInitP$S_ON) {
      return EALREADY;
    }
  else {
#line 109
    if (BlazeInitP$state[id] == BlazeInitP$S_STARTING) {
        return SUCCESS;
      }
    else {
#line 112
      if (BlazeInitP$state[id] != BlazeInitP$S_OFF) {
          return EBUSY;
        }
      }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 117
    BlazeInitP$m_id = id;
#line 117
    __nesc_atomic_end(__nesc_atomic); }

  BlazeInitP$Power$set(BlazeInitP$m_id);

  BlazeInitP$state[BlazeInitP$m_id] = BlazeInitP$S_STARTING;



  return BlazeInitP$BlazePower$reset(BlazeInitP$m_id);
}

# 83 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t TestP$SplitControl$start(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = BlazeInitP$SplitControl$start(CC1100_RADIO_ID);
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 19 "TestP.nc"
static inline  void TestP$TestCC1100Control$run(void)
#line 19
{
  error_t error;

#line 21
  error = TestP$SplitControl$start();

  if (error) {
      if (SUCCESS != error) {
#line 24
          assertEqualsFailed("start didn't work", (uint32_t )SUCCESS, (uint32_t )error);
        }
      else 
#line 24
        {
#line 24
          assertSuccess();
        }
#line 24
      ;
      TestP$TestCC1100Control$done();
      return;
    }
}

# 352 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline   void TUnitP$TestCase$default$run(uint8_t testId)
#line 352
{
  TUnitP$runDone$postTask();
}

# 39 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/interfaces/TestCase.nc"
inline static  void TUnitP$TestCase$run(uint8_t arg_0x1a9c4d98){
#line 39
  switch (arg_0x1a9c4d98) {
#line 39
    case /*TestC.TestCC1100ControlC*/TestCaseC$0$TUNIT_TEST_ID:
#line 39
      TestP$TestCC1100Control$run();
#line 39
      break;
#line 39
    default:
#line 39
      TUnitP$TestCase$default$run(arg_0x1a9c4d98);
#line 39
      break;
#line 39
    }
#line 39
}
#line 39
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   uint8_t TUnitP$TestState$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(3U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 272 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$setUpDone(void)
#line 272
{
  if (TUnitP$TestState$getState() == TUnitP$S_SETUP) {
      TUnitP$TestState$forceState(TUnitP$S_RUN);
      TUnitP$TestCase$run(TUnitP$currentTest);
    }
}

#line 348
static inline   void TUnitP$SetUp$default$run(void)
#line 348
{
  TUnitP$setUpDone();
}

# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$SetUp$run(void){
#line 38
  TUnitP$SetUp$default$run();
#line 38
}
#line 38
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t Link_TUnitProcessingP$allDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(Link_TUnitProcessingP$allDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 154 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$TUnitProcessing$allDone(void)
#line 154
{
  Link_TUnitProcessingP$allDone$postTask();
}

# 52 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void TUnitP$TUnitProcessing$allDone(void){
#line 52
  Link_TUnitProcessingP$TUnitProcessing$allDone();
#line 52
}
#line 52
# 45 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   error_t SerialP$SerialFrameComm$putDelimiter(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = HdlcTranslateC$SerialFrameComm$putDelimiter();
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 183 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error)
#line 183
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 184
    /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = error;
#line 184
    __nesc_atomic_end(__nesc_atomic); }
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask();
}

# 80 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x1adc0188){
#line 80
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(arg_0x1adc0188);
#line 80
}
#line 80
# 242 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static __inline bool SerialP$ack_queue_is_empty(void)
#line 242
{
  bool ret;

#line 244
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 244
    ret = SerialP$ackQ.writePtr == SerialP$ackQ.readPtr;
#line 244
    __nesc_atomic_end(__nesc_atomic); }
  return ret;
}











static __inline uint8_t SerialP$ack_queue_top(void)
#line 258
{
  uint8_t tmp = 0;

  /* atomic removed: atomic calls only */
#line 260
  {
    if (!SerialP$ack_queue_is_empty()) {
        tmp = SerialP$ackQ.buf[SerialP$ackQ.readPtr];
      }
  }
  return tmp;
}

static inline uint8_t SerialP$ack_queue_pop(void)
#line 268
{
  uint8_t retval = 0;

#line 270
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 270
    {
      if (SerialP$ackQ.writePtr != SerialP$ackQ.readPtr) {
          retval = SerialP$ackQ.buf[SerialP$ackQ.readPtr];
          if (++ SerialP$ackQ.readPtr > SerialP$ACK_QUEUE_SIZE) {
#line 273
            SerialP$ackQ.readPtr = 0;
            }
        }
    }
#line 276
    __nesc_atomic_end(__nesc_atomic); }
#line 276
  return retval;
}

#line 539
static inline  void SerialP$RunTx$runTask(void)
#line 539
{
  uint8_t idle;
  uint8_t done;
  uint8_t fail;









  error_t result = SUCCESS;
  bool send_completed = FALSE;
  bool start_it = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 556
    {
      SerialP$txPending = 0;
      idle = SerialP$txState == SerialP$TXSTATE_IDLE;
      done = SerialP$txState == SerialP$TXSTATE_FINISH;
      fail = SerialP$txState == SerialP$TXSTATE_ERROR;
      if (done || fail) {
          SerialP$txState = SerialP$TXSTATE_IDLE;
          SerialP$txBuf[SerialP$txIndex].state = SerialP$BUFFER_AVAILABLE;
        }
    }
#line 565
    __nesc_atomic_end(__nesc_atomic); }


  if (done || fail) {
      SerialP$txSeqno++;
      if (SerialP$txProto == SERIAL_PROTO_ACK) {
          SerialP$ack_queue_pop();
        }
      else {
          result = done ? SUCCESS : FAIL;
          send_completed = TRUE;
        }
      idle = TRUE;
    }


  if (idle) {
      bool goInactive;

#line 583
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 583
        goInactive = SerialP$offPending;
#line 583
        __nesc_atomic_end(__nesc_atomic); }
      if (goInactive) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 585
            SerialP$txState = SerialP$TXSTATE_INACTIVE;
#line 585
            __nesc_atomic_end(__nesc_atomic); }
        }
      else {

          uint8_t myAckState;
          uint8_t myDataState;

#line 591
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 591
            {
              myAckState = SerialP$txBuf[SerialP$TX_ACK_INDEX].state;
              myDataState = SerialP$txBuf[SerialP$TX_DATA_INDEX].state;
            }
#line 594
            __nesc_atomic_end(__nesc_atomic); }
          if (!SerialP$ack_queue_is_empty() && myAckState == SerialP$BUFFER_AVAILABLE) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 596
                {
                  SerialP$txBuf[SerialP$TX_ACK_INDEX].state = SerialP$BUFFER_COMPLETE;
                  SerialP$txBuf[SerialP$TX_ACK_INDEX].buf = SerialP$ack_queue_top();
                }
#line 599
                __nesc_atomic_end(__nesc_atomic); }
              SerialP$txProto = SERIAL_PROTO_ACK;
              SerialP$txIndex = SerialP$TX_ACK_INDEX;
              start_it = TRUE;
            }
          else {
#line 604
            if (myDataState == SerialP$BUFFER_FILLING || myDataState == SerialP$BUFFER_COMPLETE) {
                SerialP$txProto = SERIAL_PROTO_PACKET_NOACK;
                SerialP$txIndex = SerialP$TX_DATA_INDEX;
                start_it = TRUE;
              }
            else {
              }
            }
        }
    }
  else {
    }


  if (send_completed) {
      SerialP$SendBytePacket$sendCompleted(result);
    }

  if (SerialP$txState == SerialP$TXSTATE_INACTIVE) {
      SerialP$testOff();
      return;
    }

  if (start_it) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 629
        {
          SerialP$txCRC = 0;
          SerialP$txByteCnt = 0;
          SerialP$txState = SerialP$TXSTATE_PROTO;
        }
#line 633
        __nesc_atomic_end(__nesc_atomic); }
      if (SerialP$SerialFrameComm$putDelimiter() != SUCCESS) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 635
            SerialP$txState = SerialP$TXSTATE_ERROR;
#line 635
            __nesc_atomic_end(__nesc_atomic); }
          SerialP$MaybeScheduleTx();
        }
    }
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t SerialP$stopDoneTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(SerialP$stopDoneTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 118 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask(void)
#line 118
{
  uint8_t i;
#line 119
  uint8_t j;
#line 119
  uint8_t mask;
#line 119
  uint8_t last;
  message_t *msg;

#line 121
  for (i = 0; i < 1 / 8 + 1; i++) {
      if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[i]) {
          for (mask = 1, j = 0; j < 8; j++) {
              if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[i] & mask) {
                  last = i * 8 + j;
                  msg = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[last].msg;
                  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[last].msg = (void *)0;
                  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[i] &= ~mask;
                  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(last, msg, ECANCEL);
                }
              mask <<= 1;
            }
        }
    }
}

#line 161
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void)
#line 161
{
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current, /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg, FAIL);
}

# 173 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$allDone$runTask(void)
#line 173
{
  if (Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_ALLDONE, 0xFF, (void *)0, 0, 0) != SUCCESS) {
      Link_TUnitProcessingP$allDone$postTask();
    }
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t Link_TUnitProcessingP$sendEventMsg$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(Link_TUnitProcessingP$sendEventMsg);
#line 56

#line 56
  return result;
#line 56
}
#line 56
inline static   error_t SerialP$startDoneTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(SerialP$startDoneTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 342 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  error_t SerialP$SplitControl$start(void)
#line 342
{
  SerialP$startDoneTask$postTask();
  return SUCCESS;
}

# 83 "/svn/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t Link_TUnitProcessingP$SerialSplitControl$start(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = SerialP$SplitControl$start();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 71 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   uint8_t Link_TUnitProcessingP$SerialState$getState(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = StateImplP$State$getState(0U);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(am_id_t arg_0x1ad39bd8, am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(arg_0x1ad39bd8, arg_0x1ac91c88, arg_0x1ac91e38, arg_0x1ac90010);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 67 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x1acf68f0){
#line 67
  unsigned int result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(arg_0x1acf68f0);
#line 67

#line 67
  return result;
#line 67
}
#line 67
#line 136
inline static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x1acf4dd8){
#line 136
  unsigned char result;
#line 136

#line 136
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(arg_0x1acf4dd8);
#line 136

#line 136
  return result;
#line 136
}
#line 136
# 106 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 106
{
  __nesc_hton_uint8((unsigned char *)&/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg)->length, len);
}

# 83 "/svn/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x1ace1ad8, uint8_t arg_0x1ace1c60){
#line 83
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(arg_0x1ace1ad8, arg_0x1ace1c60);
#line 83
}
#line 83
# 82 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len)
#line 83
{
  if (clientId >= 1) {
      return FAIL;
    }
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg != (void *)0) {
      return EBUSY;
    }
  ;

  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg = msg;
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(msg, len);

  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current >= 1) {
      error_t err;
      am_id_t amId = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(msg);
      am_addr_t dest = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(msg);

      ;
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = clientId;

      err = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(amId, dest, msg, len);
      if (err != SUCCESS) {
          ;
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = 1;
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg = (void *)0;
        }

      return err;
    }
  else {
      ;
    }
  return SUCCESS;
}

# 64 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x1ad18bc0, uint8_t arg_0x1ad18d48){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(0U, arg_0x1ad18bc0, arg_0x1ad18d48);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 156 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type)
#line 156
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 158
  __nesc_hton_uint8((unsigned char *)&header->type, type);
}

# 151 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x1acf2398, am_id_t arg_0x1acf2520){
#line 151
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(arg_0x1acf2398, arg_0x1acf2520);
#line 151
}
#line 151
# 137 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr)
#line 137
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 139
  __nesc_hton_uint16((unsigned char *)&header->dest, addr);
}

# 92 "/svn/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x1acf54c8, am_addr_t arg_0x1acf5658){
#line 92
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(arg_0x1acf54c8, arg_0x1acf5658);
#line 92
}
#line 92
# 45 "/svn/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(msg, dest);
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(msg, 255);
  return /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(msg, len);
}

# 69 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t Link_TUnitProcessingP$SerialEventSend$send(am_addr_t arg_0x1ac91c88, message_t *arg_0x1ac91e38, uint8_t arg_0x1ac90010){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(arg_0x1ac91c88, arg_0x1ac91e38, arg_0x1ac90010);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 164 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$sendEventMsg$runTask(void)
#line 164
{
  if (Link_TUnitProcessingP$SerialEventSend$send(0, &Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg], sizeof(TUnitProcessingMsg )) != SUCCESS) {
      if (Link_TUnitProcessingP$SerialState$getState() == Link_TUnitProcessingP$S_OFF) {
          Link_TUnitProcessingP$SerialSplitControl$start();
        }
      Link_TUnitProcessingP$sendEventMsg$postTask();
    }
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t TUnitP$waitForSendDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(TUnitP$waitForSendDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 280 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$tearDownDone(void)
#line 280
{
  if (TUnitP$TestState$getState() == TUnitP$S_TEARDOWN) {
      TUnitP$TestState$toIdle();
      TUnitP$waitForSendDone$postTask();
    }
}

#line 356
static inline   void TUnitP$TearDown$default$run(void)
#line 356
{
  TUnitP$tearDownDone();
}

# 38 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$TearDown$run(void){
#line 38
  TUnitP$TearDown$default$run();
#line 38
}
#line 38
# 335 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$runDone$runTask(void)
#line 335
{
  if (TUnitP$TestState$getState() == TUnitP$S_RUN) {
      TUnitP$TestState$forceState(TUnitP$S_TEARDOWN);
      TUnitP$TearDown$run();
    }
}

#line 368
static inline   bool TUnitP$StatsQuery$default$isIdle(void)
#line 368
{
  return TRUE;
}

# 46 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/StatsQuery.nc"
inline static  bool TUnitP$StatsQuery$isIdle(void){
#line 46
  unsigned char result;
#line 46

#line 46
  result = TUnitP$StatsQuery$default$isIdle();
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 61 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool TUnitP$SendState$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(1U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 323 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$waitForSendDone$runTask(void)
#line 323
{
  if (TUnitP$SendState$isIdle() && TUnitP$StatsQuery$isIdle()) {

      TUnitP$currentTest++;
      TUnitP$attemptTest();
    }
  else {

      TUnitP$waitForSendDone$postTask();
    }
}

#line 313
static inline  void TUnitP$begin$runTask(void)
#line 313
{
  if (TUnitP$TUnitState$getState() == TUnitP$S_READY) {
      TUnitP$TUnitState$forceState(TUnitP$S_RUNNING);
      TUnitP$TestState$forceState(TUnitP$S_SETUP_ONETIME);
      TUnitP$currentTest = 0;
      TUnitP$SetUpOneTime$run();
    }
}

# 49 "/svn/tinyos-2.x/tos/types/TinyError.h"
static inline error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static   am_addr_t TUnitP$ActiveMessageAddress$amAddress(void){
#line 50
  unsigned int result;
#line 50

#line 50
  result = ActiveMessageAddressC$ActiveMessageAddress$amAddress();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 142 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static inline  error_t TUnitP$Init$init(void)
#line 142
{
  TUnitP$driver = TUnitP$ActiveMessageAddress$amAddress() == 0;
  return SUCCESS;
}

# 214 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static __inline void SerialP$ackInit(void)
#line 214
{
  SerialP$ackQ.writePtr = SerialP$ackQ.readPtr = 0;
}

#line 205
static __inline void SerialP$rxInit(void)
#line 205
{
  SerialP$rxBuf.writePtr = SerialP$rxBuf.readPtr = 0;
  SerialP$rxState = SerialP$RXSTATE_NOSYNC;
  SerialP$rxByteCnt = 0;
  SerialP$rxProto = 0;
  SerialP$rxSeqno = 0;
  SerialP$rxCRC = 0;
}

#line 193
static __inline void SerialP$txInit(void)
#line 193
{
  uint8_t i;

  /* atomic removed: atomic calls only */
#line 195
  for (i = 0; i < SerialP$TX_BUFFER_COUNT; i++) SerialP$txBuf[i].state = SerialP$BUFFER_AVAILABLE;
  SerialP$txState = SerialP$TXSTATE_IDLE;
  SerialP$txByteCnt = 0;
  SerialP$txProto = 0;
  SerialP$txSeqno = 0;
  SerialP$txCRC = 0;
  SerialP$txPending = FALSE;
  SerialP$txIndex = 0;
}

#line 218
static inline  error_t SerialP$Init$init(void)
#line 218
{

  SerialP$txInit();
  SerialP$rxInit();
  SerialP$ackInit();

  return SUCCESS;
}

# 45 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void)
#line 45
{
  memset(/*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ, /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY, sizeof /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ);
  return SUCCESS;
}

# 81 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static inline  error_t StateImplP$Init$init(void)
#line 81
{
  int i;

#line 83
  for (i = 0; i < 9U; i++) {
      StateImplP$state[i] = StateImplP$S_IDLE;
    }
  return SUCCESS;
}

# 45 "/svn/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$Init$init(void)
#line 45
{
  memset(/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$NO_ENTRY, sizeof /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$resQ);
  return SUCCESS;
}

# 30 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC1100ControlP$Gdo2_io$clr(void){
#line 30
  /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$clr();
#line 30
}
#line 30
inline static   void CC1100ControlP$Gdo0_io$clr(void){
#line 30
  /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$clr();
#line 30
}
#line 30



inline static   void CC1100ControlP$Gdo2_io$makeInput(void){
#line 33
  /*HplCC1100PinsC.CC1100GDO2_IO*/Msp430GpioC$5$GeneralIO$makeInput();
#line 33
}
#line 33
inline static   void CC1100ControlP$Gdo0_io$makeInput(void){
#line 33
  /*HplCC1100PinsC.CC1100GDO0_IO*/Msp430GpioC$4$GeneralIO$makeInput();
#line 33
}
#line 33
# 36 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/DummyIoP.nc"
static inline   void DummyIoP$GeneralIO$makeOutput(void)
#line 36
{
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC1100ControlP$Power$makeOutput(void){
#line 35
  DummyIoP$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)54U |= 0x01 << 0;
}

# 71 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$makeOutput();
#line 71
}
#line 71
# 43 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$HplGeneralIO$makeOutput();
}

# 35 "/svn/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC1100ControlP$Csn$makeOutput(void){
#line 35
  /*HplCC1100PinsC.CSNM*/Msp430GpioC$3$GeneralIO$makeOutput();
#line 35
}
#line 35
# 50 "/svn/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static   am_addr_t CC1100ControlP$ActiveMessageAddress$amAddress(void){
#line 50
  unsigned int result;
#line 50

#line 50
  result = ActiveMessageAddressC$ActiveMessageAddress$amAddress();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 89 "../../../../../../../../../../blaze/tos/chips/blazeradio/cc1100/CC1100ControlP.nc"
static inline  error_t CC1100ControlP$SoftwareInit$init(void)
#line 89
{

  CC1100ControlP$regValues[BLAZE_ADDR] = CC1100ControlP$ActiveMessageAddress$amAddress() >> 8;
  CC1100ControlP$panAddress = TOS_AM_GROUP;




  CC1100ControlP$autoAck = TRUE;





  CC1100ControlP$addressRecognition = TRUE;





  CC1100ControlP$panRecognition = TRUE;



  CC1100ControlP$Csn$makeOutput();
  CC1100ControlP$Power$makeOutput();



  CC1100ControlP$Gdo0_io$makeInput();
  CC1100ControlP$Gdo2_io$makeInput();
  CC1100ControlP$Gdo0_io$clr();
  CC1100ControlP$Gdo2_io$clr();

  return SUCCESS;
}

# 81 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static inline  error_t BlazeInitP$Init$init(void)
#line 81
{
  uint8_t i;

#line 83
  for (i = 0; i < 1U; i++) {
      BlazeInitP$BlazePower$shutdown(i);
      BlazeInitP$state[i] = BlazeInitP$S_OFF;
    }
  BlazeInitP$m_id = BlazeInitP$NO_RADIO;
  return SUCCESS;
}

# 100 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline  error_t BlazeReceiveP$Init$init(void)
#line 100
{
  /* atomic removed: atomic calls only */
#line 101
  {
    BlazeReceiveP$m_msg = &BlazeReceiveP$myMsg;
    __nesc_hton_uint8((unsigned char *)&BlazeReceiveP$acknowledgement.length, ACK_FRAME_LENGTH);
    __nesc_hton_uint16((unsigned char *)&BlazeReceiveP$acknowledgement.fcf, IEEE154_TYPE_ACK);
    BlazeReceiveP$missedPackets = 0;
  }
  return SUCCESS;
}

# 51 "/svn/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t RealMainP$SoftwareInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = BlazeReceiveP$Init$init();
#line 51
  result = ecombine(result, BlazeInitP$Init$init());
#line 51
  result = ecombine(result, CC1100ControlP$SoftwareInit$init());
#line 51
  result = ecombine(result, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$1$Init$init());
#line 51
  result = ecombine(result, StateImplP$Init$init());
#line 51
  result = ecombine(result, /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init());
#line 51
  result = ecombine(result, SerialP$Init$init());
#line 51
  result = ecombine(result, TUnitP$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 110 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$maxPayloadLength(void)
#line 110
{
  return 28;
}

static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t len)
#line 114
{
  if (len > /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$maxPayloadLength()) {
      return (void *)0;
    }
  else {
      return msg->data;
    }
}

#line 77
static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(am_id_t id, message_t *m, uint8_t len)
#line 77
{
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(m, len);
}

# 124 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(am_id_t arg_0x1ad39bd8, message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0){
#line 124
  void *result;
#line 124

#line 124
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(arg_0x1ad39bd8, arg_0x1acaac68, arg_0x1acaadf0);
#line 124

#line 124
  return result;
#line 124
}
#line 124
# 203 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m, uint8_t len)
#line 203
{
  return /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(0, m, len);
}

# 114 "/svn/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x1ad16ad0, uint8_t arg_0x1ad16c58){
#line 114
  void *result;
#line 114

#line 114
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(0U, arg_0x1ad16ad0, arg_0x1ad16c58);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 65 "/svn/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m, uint8_t len)
#line 65
{
  return /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(m, len);
}

# 124 "/svn/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void *Link_TUnitProcessingP$SerialEventSend$getPayload(message_t *arg_0x1acaac68, uint8_t arg_0x1acaadf0){
#line 124
  void *result;
#line 124

#line 124
  result = /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(arg_0x1acaac68, arg_0x1acaadf0);
#line 124

#line 124
  return result;
#line 124
}
#line 124
# 92 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$Boot$booted(void)
#line 92
{
  int i;

#line 94
  for (i = 0; i < 5; i++) {
      __nesc_hton_uint8((unsigned char *)&((TUnitProcessingMsg *)Link_TUnitProcessingP$SerialEventSend$getPayload(&Link_TUnitProcessingP$eventMsg[i], 28))->cmd, 0xFF);
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 97
    Link_TUnitProcessingP$writingEventMsg = 0;
#line 97
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 98
    Link_TUnitProcessingP$sendingEventMsg = 0;
#line 98
    __nesc_atomic_end(__nesc_atomic); }
  Link_TUnitProcessingP$SerialSplitControl$start();
}

# 49 "/svn/tinyos-2.x/tos/interfaces/Boot.nc"
inline static  void RealMainP$Boot$booted(void){
#line 49
  Link_TUnitProcessingP$Boot$booted();
#line 49
}
#line 49
# 190 "/svn/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline void __nesc_disable_interrupt(void )
{
   __asm volatile ("dint");
   __asm volatile ("nop");}

# 124 "/svn/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void)
#line 124
{
  return MSP430_POWER_LPM4;
}

# 54 "/svn/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
inline static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void){
#line 54
  unsigned char result;
#line 54

#line 54
  result = McuSleepC$McuPowerOverride$default$lowestState();
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 66 "/svn/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline mcu_power_t McuSleepC$getPowerState(void)
#line 66
{
  mcu_power_t pState = MSP430_POWER_LPM3;









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

# 178 "/svn/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)
#line 178
{
  return m1 < m2 ? m1 : m2;
}

# 104 "/svn/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline void McuSleepC$computePowerState(void)
#line 104
{
  McuSleepC$powerState = mcombine(McuSleepC$getPowerState(), 
  McuSleepC$McuPowerOverride$lowestState());
}

static inline   void McuSleepC$McuSleep$sleep(void)
#line 109
{
  uint16_t temp;

#line 111
  if (McuSleepC$dirty) {
      McuSleepC$computePowerState();
    }

  temp = McuSleepC$msp430PowerBits[McuSleepC$powerState] | 0x0008;
   __asm volatile ("bis  %0, r2" :  : "m"(temp));
  __nesc_disable_interrupt();
}

# 59 "/svn/tinyos-2.x/tos/interfaces/McuSleep.nc"
inline static   void SchedulerBasicP$McuSleep$sleep(void){
#line 59
  McuSleepC$McuSleep$sleep();
#line 59
}
#line 59
# 67 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static __inline uint8_t SchedulerBasicP$popTask(void)
{
  if (SchedulerBasicP$m_head != SchedulerBasicP$NO_TASK) 
    {
      uint8_t id = SchedulerBasicP$m_head;

#line 72
      SchedulerBasicP$m_head = SchedulerBasicP$m_next[SchedulerBasicP$m_head];
      if (SchedulerBasicP$m_head == SchedulerBasicP$NO_TASK) 
        {
          SchedulerBasicP$m_tail = SchedulerBasicP$NO_TASK;
        }
      SchedulerBasicP$m_next[id] = SchedulerBasicP$NO_TASK;
      return id;
    }
  else 
    {
      return SchedulerBasicP$NO_TASK;
    }
}

#line 138
static inline  void SchedulerBasicP$Scheduler$taskLoop(void)
{
  for (; ; ) 
    {
      uint8_t nextTask;

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
        {
          while ((nextTask = SchedulerBasicP$popTask()) == SchedulerBasicP$NO_TASK) 
            {
              SchedulerBasicP$McuSleep$sleep();
            }
        }
#line 150
        __nesc_atomic_end(__nesc_atomic); }
      SchedulerBasicP$TaskBasic$runTask(nextTask);
    }
}

# 61 "/svn/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$taskLoop(void){
#line 61
  SchedulerBasicP$Scheduler$taskLoop();
#line 61
}
#line 61
# 88 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   uint8_t /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(void){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId();
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 387 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$dataReceived(uint8_t data)
#line 387
{
  SerialP$rx_state_machine(FALSE, data);
}

# 83 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x1add28d0){
#line 83
  SerialP$SerialFrameComm$dataReceived(arg_0x1add28d0);
#line 83
}
#line 83
# 384 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$delimiterReceived(void)
#line 384
{
  SerialP$rx_state_machine(TRUE, 0);
}

# 74 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void){
#line 74
  SerialP$SerialFrameComm$delimiterReceived();
#line 74
}
#line 74
# 61 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$UartStream$receivedByte(uint8_t data)
#line 61
{






  if (data == HDLC_FLAG_BYTE) {

      HdlcTranslateC$SerialFrameComm$delimiterReceived();
      return;
    }
  else {
#line 73
    if (data == HDLC_CTLESC_BYTE) {

        HdlcTranslateC$state.receiveEscape = 1;
        return;
      }
    else {
#line 78
      if (HdlcTranslateC$state.receiveEscape) {

          HdlcTranslateC$state.receiveEscape = 0;
          data = data ^ 0x20;
        }
      }
    }
#line 83
  HdlcTranslateC$SerialFrameComm$dataReceived(data);
}

# 79 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(uint8_t arg_0x1ae94d60){
#line 79
  HdlcTranslateC$UartStream$receivedByte(arg_0x1ae94d60);
#line 79
}
#line 79
# 116 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$UartStream$receiveDone(uint8_t *buf, uint16_t len, error_t error)
#line 116
{
}

# 99 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(uint8_t *arg_0x1ae93b08, uint16_t arg_0x1ae93c98, error_t arg_0x1ae93e20){
#line 99
  HdlcTranslateC$UartStream$receiveDone(arg_0x1ae93b08, arg_0x1ae93c98, arg_0x1ae93e20);
#line 99
}
#line 99
# 123 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t data)
#line 123
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf) {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_pos++] = data;
      if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_pos >= /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_len) {
          uint8_t *buf = /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf;

#line 128
          /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf = (void *)0;
          /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(buf, /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_len, SUCCESS);
        }
    }
  else {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(data);
    }
}

# 65 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data)
#line 65
{
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(uint8_t arg_0x1b26b410, uint8_t arg_0x1af0d8d8){
#line 54
  switch (arg_0x1b26b410) {
#line 54
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 54
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(arg_0x1af0d8d8);
#line 54
      break;
#line 54
    default:
#line 54
      /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(arg_0x1b26b410, arg_0x1af0d8d8);
#line 54
      break;
#line 54
    }
#line 54
}
#line 54
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   bool /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data)
#line 54
{
  if (/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(), data);
    }
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart1P$Interrupts$rxDone(uint8_t arg_0x1af0d8d8){
#line 54
  /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(arg_0x1af0d8d8);
#line 54
}
#line 54
# 391 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline bool SerialP$valid_rx_proto(uint8_t proto)
#line 391
{
  switch (proto) {
      case SERIAL_PROTO_PACKET_ACK: 
        return TRUE;
      case SERIAL_PROTO_ACK: 
        case SERIAL_PROTO_PACKET_NOACK: 
          default: 
            return FALSE;
    }
}

# 192 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void)
#line 192
{
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 1;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 1;
    }
}

#line 188
static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void)
#line 188
{
  return /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked : /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked;
}

#line 215
static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void)
#line 215
{
  error_t result = SUCCESS;

  /* atomic removed: atomic calls only */
#line 217
  {
    if (!/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked()) {


        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer();
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.state = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_BEGIN;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex = 0;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvType = TOS_SERIAL_UNKNOWN_ID;
      }
    else {
        result = EBUSY;
      }
  }
  return result;
}

# 51 "/svn/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
inline static   error_t SerialP$ReceiveBytePacket$startPacket(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 309 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static __inline uint16_t SerialP$rx_current_crc(void)
#line 309
{
  uint16_t crc;
  uint8_t tmp = SerialP$rxBuf.writePtr;

#line 312
  tmp = tmp == 0 ? SerialP$RX_DATA_BUFFER_SIZE : tmp - 1;
  crc = SerialP$rxBuf.buf[tmp] & 0x00ff;
  crc = (crc << 8) & 0xFF00;
  tmp = tmp == 0 ? SerialP$RX_DATA_BUFFER_SIZE : tmp - 1;
  crc |= SerialP$rxBuf.buf[tmp] & 0x00FF;
  return crc;
}

# 69 "/svn/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x1add8010){
#line 69
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(arg_0x1add8010);
#line 69
}
#line 69
# 210 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void)
#line 210
{
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? 0 : 1;
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer = (uint8_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which];
}

# 56 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 232 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static __inline bool SerialP$ack_queue_is_full(void)
#line 232
{
  uint8_t tmp;
#line 233
  uint8_t tmp2;

  /* atomic removed: atomic calls only */
#line 234
  {
    tmp = SerialP$ackQ.writePtr;
    tmp2 = SerialP$ackQ.readPtr;
  }
  if (++tmp > SerialP$ACK_QUEUE_SIZE) {
#line 238
    tmp = 0;
    }
#line 239
  return tmp == tmp2;
}







static __inline void SerialP$ack_queue_push(uint8_t token)
#line 248
{
  if (!SerialP$ack_queue_is_full()) {
      /* atomic removed: atomic calls only */
#line 250
      {
        SerialP$ackQ.buf[SerialP$ackQ.writePtr] = token;
        if (++ SerialP$ackQ.writePtr > SerialP$ACK_QUEUE_SIZE) {
#line 252
          SerialP$ackQ.writePtr = 0;
          }
      }
#line 254
      SerialP$MaybeScheduleTx();
    }
}

# 233 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b)
#line 233
{
  /* atomic removed: atomic calls only */
#line 234
  {
    switch (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.state) {
        case /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_BEGIN: 
          /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.state = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_DATA;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(b);
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvType = b;
        break;

        case /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_DATA: 
          if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex < sizeof(message_t )) {
              /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex] = b;
              /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex++;
            }
          else {
            }




        break;

        case /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_IDLE: 
          default: 
#line 255
            ;
      }
  }
}

# 58 "/svn/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x1add99f0){
#line 58
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(arg_0x1add99f0);
#line 58
}
#line 58
# 299 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static __inline uint8_t SerialP$rx_buffer_top(void)
#line 299
{
  uint8_t tmp = SerialP$rxBuf.buf[SerialP$rxBuf.readPtr];

#line 301
  return tmp;
}

#line 303
static __inline uint8_t SerialP$rx_buffer_pop(void)
#line 303
{
  uint8_t tmp = SerialP$rxBuf.buf[SerialP$rxBuf.readPtr];

#line 305
  if (++ SerialP$rxBuf.readPtr > SerialP$RX_DATA_BUFFER_SIZE) {
#line 305
    SerialP$rxBuf.readPtr = 0;
    }
#line 306
  return tmp;
}

#line 295
static __inline void SerialP$rx_buffer_push(uint8_t data)
#line 295
{
  SerialP$rxBuf.buf[SerialP$rxBuf.writePtr] = data;
  if (++ SerialP$rxBuf.writePtr > SerialP$RX_DATA_BUFFER_SIZE) {
#line 297
    SerialP$rxBuf.writePtr = 0;
    }
}

# 55 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$SerialFrameComm$resetReceive(void)
#line 55
{
  HdlcTranslateC$state.receiveEscape = 0;
}

# 68 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void SerialP$SerialFrameComm$resetReceive(void){
#line 68
  HdlcTranslateC$SerialFrameComm$resetReceive();
#line 68
}
#line 68
#line 54
inline static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x1add3688){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HdlcTranslateC$SerialFrameComm$putData(arg_0x1add3688);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 513 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   error_t SerialP$SendBytePacket$completeSend(void)
#line 513
{
  bool ret = FAIL;

  /* atomic removed: atomic calls only */
#line 515
  {
    SerialP$txBuf[SerialP$TX_DATA_INDEX].state = SerialP$BUFFER_COMPLETE;
    ret = SUCCESS;
  }
  return ret;
}

# 60 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$completeSend(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = SerialP$SendBytePacket$completeSend();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 167 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void)
#line 167
{
  uint8_t b;
  uint8_t indx;

  /* atomic removed: atomic calls only */
#line 170
  {
    b = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex];
    /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex++;
    indx = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex;
  }
  if (indx > /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendLen) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$completeSend();
      return 0;
    }
  else {
      return b;
    }
}

# 70 "/svn/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   uint8_t SerialP$SendBytePacket$nextByte(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 642 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$putDone(void)
#line 642
{
  {
    error_t txResult = SUCCESS;

    switch (SerialP$txState) {

        case SerialP$TXSTATE_PROTO: 

          txResult = SerialP$SerialFrameComm$putData(SerialP$txProto);

        SerialP$txState = SerialP$TXSTATE_INFO;



        SerialP$txCRC = crcByte(SerialP$txCRC, SerialP$txProto);
        break;

        case SerialP$TXSTATE_SEQNO: 
          txResult = SerialP$SerialFrameComm$putData(SerialP$txSeqno);
        SerialP$txState = SerialP$TXSTATE_INFO;
        SerialP$txCRC = crcByte(SerialP$txCRC, SerialP$txSeqno);
        break;

        case SerialP$TXSTATE_INFO: /* atomic removed: atomic calls only */
          {
            txResult = SerialP$SerialFrameComm$putData(SerialP$txBuf[SerialP$txIndex].buf);
            SerialP$txCRC = crcByte(SerialP$txCRC, SerialP$txBuf[SerialP$txIndex].buf);
            ++SerialP$txByteCnt;

            if (SerialP$txIndex == SerialP$TX_DATA_INDEX) {
                uint8_t nextByte;

#line 673
                nextByte = SerialP$SendBytePacket$nextByte();
                if (SerialP$txBuf[SerialP$txIndex].state == SerialP$BUFFER_COMPLETE || SerialP$txByteCnt >= SerialP$SERIAL_MTU) {
                    SerialP$txState = SerialP$TXSTATE_FCS1;
                  }
                else {
                    SerialP$txBuf[SerialP$txIndex].buf = nextByte;
                  }
              }
            else {
                SerialP$txState = SerialP$TXSTATE_FCS1;
              }
          }
        break;

        case SerialP$TXSTATE_FCS1: 
          txResult = SerialP$SerialFrameComm$putData(SerialP$txCRC & 0xff);
        SerialP$txState = SerialP$TXSTATE_FCS2;
        break;

        case SerialP$TXSTATE_FCS2: 
          txResult = SerialP$SerialFrameComm$putData((SerialP$txCRC >> 8) & 0xff);
        SerialP$txState = SerialP$TXSTATE_ENDFLAG;
        break;

        case SerialP$TXSTATE_ENDFLAG: 
          txResult = SerialP$SerialFrameComm$putDelimiter();
        SerialP$txState = SerialP$TXSTATE_ENDWAIT;
        break;

        case SerialP$TXSTATE_ENDWAIT: 
          SerialP$txState = SerialP$TXSTATE_FINISH;
        case SerialP$TXSTATE_FINISH: 
          SerialP$MaybeScheduleTx();
        break;
        case SerialP$TXSTATE_ERROR: 
          default: 
            txResult = FAIL;
        break;
      }

    if (txResult != SUCCESS) {
        SerialP$txState = SerialP$TXSTATE_ERROR;
        SerialP$MaybeScheduleTx();
      }
  }
}

# 89 "/svn/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$putDone(void){
#line 89
  SerialP$SerialFrameComm$putDone();
#line 89
}
#line 89
# 48 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x1ae954c8, uint16_t arg_0x1ae95658){
#line 48
  unsigned char result;
#line 48

#line 48
  result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(arg_0x1ae954c8, arg_0x1ae95658);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 104 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$UartStream$sendDone(uint8_t *buf, uint16_t len, 
error_t error)
#line 105
{
  if (HdlcTranslateC$state.sendEscape) {
      HdlcTranslateC$state.sendEscape = 0;
      HdlcTranslateC$m_data = HdlcTranslateC$txTemp;
      HdlcTranslateC$UartStream$send(&HdlcTranslateC$m_data, 1);
    }
  else {
      HdlcTranslateC$SerialFrameComm$putDone();
    }
}

# 57 "/svn/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(uint8_t *arg_0x1ae95c60, uint16_t arg_0x1ae95df0, error_t arg_0x1ae94010){
#line 57
  HdlcTranslateC$UartStream$sendDone(arg_0x1ae95c60, arg_0x1ae95df0, arg_0x1ae94010);
#line 57
}
#line 57
# 384 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$tx(uint8_t data)
#line 384
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 385
    HplMsp430Usart1P$U1TXBUF = data;
#line 385
    __nesc_atomic_end(__nesc_atomic); }
}

# 224 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(uint8_t arg_0x1af13c68){
#line 224
  HplMsp430Usart1P$Usart$tx(arg_0x1af13c68);
#line 224
}
#line 224
# 149 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void)
#line 149
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos < /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len) {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos++]);
    }
  else {
      uint8_t *buf = /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf;

#line 155
      /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf = (void *)0;
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(buf, /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len, SUCCESS);
    }
}

# 64 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id)
#line 64
{
}

# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(uint8_t arg_0x1b26b410){
#line 49
  switch (arg_0x1b26b410) {
#line 49
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 49
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone();
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(arg_0x1b26b410);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void)
#line 49
{
  if (/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId());
    }
}

# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart1P$Interrupts$txDone(void){
#line 49
  /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone();
#line 49
}
#line 49
# 88 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$userId(void){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$userId();
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 349 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$disableRxIntr(void)
#line 349
{
  HplMsp430Usart0P$IE1 &= ~(1 << 6);
}

# 177 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr(void){
#line 177
  HplMsp430Usart0P$Usart$disableRxIntr();
#line 177
}
#line 177
# 172 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t data)
#line 172
{

  if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf) {
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos - 1] = data;
    }
  if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos < /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len) {
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp();
    }
  else 
#line 179
    {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr();
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone();
    }
}

# 65 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$rxDone(uint8_t id, uint8_t data)
#line 65
{
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$rxDone(uint8_t arg_0x1b26b410, uint8_t arg_0x1af0d8d8){
#line 54
  switch (arg_0x1b26b410) {
#line 54
    case /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 54
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(arg_0x1af0d8d8);
#line 54
      break;
#line 54
    default:
#line 54
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$rxDone(arg_0x1b26b410, arg_0x1af0d8d8);
#line 54
      break;
#line 54
    }
#line 54
}
#line 54
# 80 "/svn/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$inUse(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$inUse();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$rxDone(uint8_t data)
#line 54
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$rxDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$userId(), data);
    }
}

# 54 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart0P$Interrupts$rxDone(uint8_t arg_0x1af0d8d8){
#line 54
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$rxDone(arg_0x1af0d8d8);
#line 54
}
#line 54
# 55 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
static inline   bool HplMsp430I2C0P$HplI2C$isI2C(void)
#line 55
{
  /* atomic removed: atomic calls only */
#line 56
  {
    unsigned char __nesc_temp = 
#line 56
    HplMsp430I2C0P$U0CTL & 0x20 && HplMsp430I2C0P$U0CTL & 0x04 && HplMsp430I2C0P$U0CTL & 0x01;

#line 56
    return __nesc_temp;
  }
}

# 6 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
inline static   bool HplMsp430Usart0P$HplI2C$isI2C(void){
#line 6
  unsigned char result;
#line 6

#line 6
  result = HplMsp430I2C0P$HplI2C$isI2C();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 66 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$default$fired(uint8_t id)
#line 66
{
}

# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$fired(uint8_t arg_0x1b265368){
#line 39
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$default$fired(arg_0x1b265368);
#line 39
}
#line 39
# 59 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawI2CInterrupts$fired(void)
#line 59
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$I2CInterrupts$fired(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$userId());
    }
}

# 39 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static   void HplMsp430Usart0P$I2CInterrupts$fired(void){
#line 39
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawI2CInterrupts$fired();
#line 39
}
#line 39
# 190 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void)
#line 190
{
}

# 64 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$txDone(uint8_t id)
#line 64
{
}

# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$txDone(uint8_t arg_0x1b26b410){
#line 49
  switch (arg_0x1b26b410) {
#line 49
    case /*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 49
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone();
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$default$txDone(arg_0x1b26b410);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$txDone(void)
#line 49
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$Interrupts$txDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$ArbiterInfo$userId());
    }
}

# 49 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart0P$Interrupts$txDone(void){
#line 49
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$1$RawInterrupts$txDone();
#line 49
}
#line 49
# 91 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port10$clear(void)
#line 91
{
#line 91
  P1IFG &= ~(1 << 0);
}

#line 67
static inline    void HplMsp430InterruptP$Port10$default$fired(void)
#line 67
{
#line 67
  HplMsp430InterruptP$Port10$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port10$fired(void){
#line 61
  HplMsp430InterruptP$Port10$default$fired();
#line 61
}
#line 61
# 92 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port11$clear(void)
#line 92
{
#line 92
  P1IFG &= ~(1 << 1);
}

#line 68
static inline    void HplMsp430InterruptP$Port11$default$fired(void)
#line 68
{
#line 68
  HplMsp430InterruptP$Port11$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port11$fired(void){
#line 61
  HplMsp430InterruptP$Port11$default$fired();
#line 61
}
#line 61
# 93 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port12$clear(void)
#line 93
{
#line 93
  P1IFG &= ~(1 << 2);
}

#line 69
static inline    void HplMsp430InterruptP$Port12$default$fired(void)
#line 69
{
#line 69
  HplMsp430InterruptP$Port12$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port12$fired(void){
#line 61
  HplMsp430InterruptP$Port12$default$fired();
#line 61
}
#line 61
# 94 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port13$clear(void)
#line 94
{
#line 94
  P1IFG &= ~(1 << 3);
}

#line 70
static inline    void HplMsp430InterruptP$Port13$default$fired(void)
#line 70
{
#line 70
  HplMsp430InterruptP$Port13$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port13$fired(void){
#line 61
  HplMsp430InterruptP$Port13$default$fired();
#line 61
}
#line 61
# 95 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port14$clear(void)
#line 95
{
#line 95
  P1IFG &= ~(1 << 4);
}

#line 71
static inline    void HplMsp430InterruptP$Port14$default$fired(void)
#line 71
{
#line 71
  HplMsp430InterruptP$Port14$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port14$fired(void){
#line 61
  HplMsp430InterruptP$Port14$default$fired();
#line 61
}
#line 61
# 96 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port15$clear(void)
#line 96
{
#line 96
  P1IFG &= ~(1 << 5);
}

#line 72
static inline    void HplMsp430InterruptP$Port15$default$fired(void)
#line 72
{
#line 72
  HplMsp430InterruptP$Port15$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port15$fired(void){
#line 61
  HplMsp430InterruptP$Port15$default$fired();
#line 61
}
#line 61
# 97 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port16$clear(void)
#line 97
{
#line 97
  P1IFG &= ~(1 << 6);
}

#line 73
static inline    void HplMsp430InterruptP$Port16$default$fired(void)
#line 73
{
#line 73
  HplMsp430InterruptP$Port16$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port16$fired(void){
#line 61
  HplMsp430InterruptP$Port16$default$fired();
#line 61
}
#line 61
# 98 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port17$clear(void)
#line 98
{
#line 98
  P1IFG &= ~(1 << 7);
}

#line 74
static inline    void HplMsp430InterruptP$Port17$default$fired(void)
#line 74
{
#line 74
  HplMsp430InterruptP$Port17$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port17$fired(void){
#line 61
  HplMsp430InterruptP$Port17$default$fired();
#line 61
}
#line 61
# 195 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port20$clear(void)
#line 195
{
#line 195
  P2IFG &= ~(1 << 0);
}

#line 171
static inline    void HplMsp430InterruptP$Port20$default$fired(void)
#line 171
{
#line 171
  HplMsp430InterruptP$Port20$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port20$fired(void){
#line 61
  HplMsp430InterruptP$Port20$default$fired();
#line 61
}
#line 61
# 196 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port21$clear(void)
#line 196
{
#line 196
  P2IFG &= ~(1 << 1);
}

#line 172
static inline    void HplMsp430InterruptP$Port21$default$fired(void)
#line 172
{
#line 172
  HplMsp430InterruptP$Port21$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port21$fired(void){
#line 61
  HplMsp430InterruptP$Port21$default$fired();
#line 61
}
#line 61
# 197 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port22$clear(void)
#line 197
{
#line 197
  P2IFG &= ~(1 << 2);
}

#line 173
static inline    void HplMsp430InterruptP$Port22$default$fired(void)
#line 173
{
#line 173
  HplMsp430InterruptP$Port22$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port22$fired(void){
#line 61
  HplMsp430InterruptP$Port22$default$fired();
#line 61
}
#line 61
# 20 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/HplCC1100PinsP.nc"
static inline   void HplCC1100PinsP$Gdo0_int$fired(void)
#line 20
{
}

# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$Interrupt$fired(void){
#line 57
  HplCC1100PinsP$Gdo0_int$fired();
#line 57
}
#line 57
# 198 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port23$clear(void)
#line 198
{
#line 198
  P2IFG &= ~(1 << 3);
}

# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$clear(void){
#line 41
  HplMsp430InterruptP$Port23$clear();
#line 41
}
#line 41
# 66 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$fired(void)
#line 66
{
  /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$clear();
  /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$Interrupt$fired();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port23$fired(void){
#line 61
  /*HplCC1100PinsC.CC1100GDO0*/Msp430InterruptC$0$HplInterrupt$fired();
#line 61
}
#line 61
# 199 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port24$clear(void)
#line 199
{
#line 199
  P2IFG &= ~(1 << 4);
}

#line 175
static inline    void HplMsp430InterruptP$Port24$default$fired(void)
#line 175
{
#line 175
  HplMsp430InterruptP$Port24$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port24$fired(void){
#line 61
  HplMsp430InterruptP$Port24$default$fired();
#line 61
}
#line 61
# 200 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port25$clear(void)
#line 200
{
#line 200
  P2IFG &= ~(1 << 5);
}

#line 176
static inline    void HplMsp430InterruptP$Port25$default$fired(void)
#line 176
{
#line 176
  HplMsp430InterruptP$Port25$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port25$fired(void){
#line 61
  HplMsp430InterruptP$Port25$default$fired();
#line 61
}
#line 61
# 17 "../../../../../../../../../../blaze/tos/platforms/tmote1100/chips/ccxx00/HplCC1100PinsP.nc"
static inline   void HplCC1100PinsP$Gdo2_int$fired(void)
#line 17
{
}

# 78 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeReceiveP$Resource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = BlazeSpiP$Resource$request(/*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 205 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$immediateRequested(void)
#line 205
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$release();
}

# 81 "/svn/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$immediateRequested(void){
#line 81
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$default$immediateRequested();
#line 81
}
#line 81
# 198 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$immediateRequested(uint8_t id)
#line 198
{
}

# 51 "/svn/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$immediateRequested(uint8_t arg_0x1b2ce738){
#line 51
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$default$immediateRequested(arg_0x1b2ce738);
#line 51
}
#line 51
# 90 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$immediateRequest(uint8_t id)
#line 90
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceRequested$immediateRequested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId);
  /* atomic removed: atomic calls only */
#line 92
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_IMM_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId = id;
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
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$immediateRequested();
  if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId == id) {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId);
      return SUCCESS;
    }
  /* atomic removed: atomic calls only */
#line 104
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED;
  return FAIL;
}

# 112 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(uint8_t id)
#line 112
{
#line 112
  return FAIL;
}

# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(uint8_t arg_0x1b4821b0){
#line 87
  unsigned char result;
#line 87

#line 87
  switch (arg_0x1b4821b0) {
#line 87
    case /*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 87
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$immediateRequest(/*HplRadioSpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 87
      break;
#line 87
    default:
#line 87
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(arg_0x1b4821b0);
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
# 68 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(uint8_t id)
#line 68
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(id);
}

# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeSpiP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(/*HplRadioSpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t BlazeSpiP$SpiResourceState$requestState(uint8_t arg_0x1a9e1ba0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(5U, arg_0x1a9e1ba0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 121 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   error_t BlazeSpiP$Resource$immediateRequest(uint8_t id)
#line 121
{
  error_t error;

  /* atomic removed: atomic calls only */
#line 124
  {
    if (BlazeSpiP$SpiResourceState$requestState(BlazeSpiP$S_BUSY) != SUCCESS) {
        {
          unsigned char __nesc_temp = 
#line 126
          EBUSY;

#line 126
          return __nesc_temp;
        }
      }
    if (BlazeSpiP$SpiResource$isOwner()) {
        BlazeSpiP$m_holder = id;
        error = SUCCESS;
      }
    else {
#line 133
      if ((error = BlazeSpiP$SpiResource$immediateRequest()) == SUCCESS) {
          BlazeSpiP$m_holder = id;
        }
      else {
          BlazeSpiP$SpiResourceState$toIdle();
        }
      }
  }
  return error;
}

# 87 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t BlazeReceiveP$Resource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = BlazeSpiP$Resource$immediateRequest(/*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 174 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static inline   uint8_t BlazeSpiP$Resource$isOwner(uint8_t id)
#line 174
{
  /* atomic removed: atomic calls only */
#line 175
  {
    unsigned char __nesc_temp = 
#line 175
    BlazeSpiP$m_holder == id;

#line 175
    return __nesc_temp;
  }
}

# 118 "/svn/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool BlazeReceiveP$Resource$isOwner(void){
#line 118
  unsigned char result;
#line 118

#line 118
  result = BlazeSpiP$Resource$isOwner(/*BlazeReceiveC.BlazeSpiResourceC*/BlazeSpiResourceC$3$CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 45 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t BlazeReceiveP$State$requestState(uint8_t arg_0x1a9e1ba0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(8U, arg_0x1a9e1ba0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 122 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   error_t BlazeReceiveP$ReceiveController$beginReceive(radio_id_t id)
#line 122
{

  if (BlazeReceiveP$State$requestState(BlazeReceiveP$S_RX_LENGTH) != SUCCESS) {
      return EBUSY;
    }
  /* atomic removed: atomic calls only */
  BlazeReceiveP$m_id = id;

  if (BlazeReceiveP$Resource$isOwner()) {
      BlazeReceiveP$receive();
    }
  else {
#line 133
    if (BlazeReceiveP$Resource$immediateRequest() == SUCCESS) {
        BlazeReceiveP$receive();
      }
    else {
        BlazeReceiveP$Resource$request();
      }
    }
  return SUCCESS;
}

# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool BlazeReceiveP$InterruptState$isState(uint8_t arg_0x1a9e0d10){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$isState(6U, arg_0x1a9e0d10);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 112 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static inline   void BlazeReceiveP$RxInterrupt$fired(radio_id_t id)
#line 112
{
  if (BlazeReceiveP$InterruptState$isState(S_INTERRUPT_RX)) {
      if (BlazeReceiveP$ReceiveController$beginReceive(id) != SUCCESS) {

          BlazeReceiveP$missedPackets++;
        }
    }
}

# 66 "/svn/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool BlazeTransmitP$InterruptState$isState(uint8_t arg_0x1a9e0d10){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$isState(6U, arg_0x1a9e0d10);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 163 "../../../../../../../../../../blaze/tos/chips/blazeradio/transmit/BlazeTransmitP.nc"
static inline   void BlazeTransmitP$TxInterrupt$fired(radio_id_t id)
#line 163
{
  if (BlazeTransmitP$InterruptState$isState(S_INTERRUPT_RX)) {
      return;
    }
}

# 57 "/svn/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$fired(void){
#line 57
  BlazeTransmitP$TxInterrupt$fired(CC1100_RADIO_ID);
#line 57
  BlazeReceiveP$RxInterrupt$fired(CC1100_RADIO_ID);
#line 57
  HplCC1100PinsP$Gdo2_int$fired();
#line 57
}
#line 57
# 66 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   void /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$fired(void)
#line 66
{
  /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$clear();
  /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$fired();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port26$fired(void){
#line 61
  /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$fired();
#line 61
}
#line 61
# 202 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port27$clear(void)
#line 202
{
#line 202
  P2IFG &= ~(1 << 7);
}

#line 178
static inline    void HplMsp430InterruptP$Port27$default$fired(void)
#line 178
{
#line 178
  HplMsp430InterruptP$Port27$clear();
}

# 61 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port27$fired(void){
#line 61
  HplMsp430InterruptP$Port27$default$fired();
#line 61
}
#line 61
# 210 "/svn/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
 __nesc_atomic_t __nesc_atomic_start(void )
{
  __nesc_atomic_t result = (({
#line 212
    uint16_t __x;

#line 212
     __asm volatile ("mov	r2, %0" : "=r"((uint16_t )__x));__x;
  }
  )
#line 212
   & 0x0008) != 0;

#line 213
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

# 195 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
__attribute((noinline))   void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual)
#line 195
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testEqualsFailed(TUnitP$currentTest, failMsg, expected, actual);
    }
}

# 133 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static   bool StateImplP$State$isState(uint8_t id, uint8_t myState)
#line 133
{
  bool isState;

#line 135
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 135
    isState = StateImplP$state[id] == myState;
#line 135
    __nesc_atomic_end(__nesc_atomic); }
  return isState;
}

# 203 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static error_t Link_TUnitProcessingP$insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual)
#line 203
{
  unsigned char __nesc_temp43;
  unsigned char *__nesc_temp42;
#line 204
  TUnitProcessingMsg *tunitMsg;
  bool failed = (((cmd == TUNITPROCESSING_EVENT_TESTRESULT_FAILED
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 211
    {
      while (TRUE) {
          if (__nesc_ntoh_uint8((unsigned char *)&(tunitMsg = (TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$writingEventMsg])->data)->cmd) == Link_TUnitProcessingP$EMPTY) {

              __nesc_hton_uint8((unsigned char *)&tunitMsg->cmd, cmd);
              __nesc_hton_uint8((unsigned char *)&tunitMsg->id, testId);
              __nesc_hton_uint8((unsigned char *)&tunitMsg->failMsgLength, 0);
              __nesc_hton_uint32((unsigned char *)&tunitMsg->expected, expected);
              __nesc_hton_uint32((unsigned char *)&tunitMsg->actual, actual);

              if (failed && failMsg != (void *)0) {
                  while (*failMsg && __nesc_ntoh_uint8((unsigned char *)&tunitMsg->failMsgLength) < 28 - 12) {
                      __nesc_hton_uint8((unsigned char *)&tunitMsg->failMsg[__nesc_ntoh_uint8((unsigned char *)&tunitMsg->failMsgLength)], * failMsg++);
                      (__nesc_temp42 = (unsigned char *)&tunitMsg->failMsgLength, __nesc_hton_uint8(__nesc_temp42, (__nesc_temp43 = __nesc_ntoh_uint8(__nesc_temp42)) + 1), __nesc_temp43);
                    }
                }

              Link_TUnitProcessingP$writingEventMsg++;
              Link_TUnitProcessingP$writingEventMsg %= 5;

              if (failed && failMsg != (void *)0 && *failMsg) {

                  if (__nesc_ntoh_uint8((unsigned char *)&((TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$writingEventMsg])->data)->cmd) != Link_TUnitProcessingP$EMPTY) {

                      __nesc_hton_int8((unsigned char *)&tunitMsg->lastMsg, TRUE);
                      break;
                    }
                  else {

                      __nesc_hton_int8((unsigned char *)&tunitMsg->lastMsg, FALSE);
                    }
                }
              else {

                  __nesc_hton_int8((unsigned char *)&tunitMsg->lastMsg, TRUE);
                  break;
                }
            }
          else {

              Link_TUnitProcessingP$attemptEventSend();
              {
                unsigned char __nesc_temp = 
#line 252
                FAIL;

                {
#line 252
                  __nesc_atomic_end(__nesc_atomic); 
#line 252
                  return __nesc_temp;
                }
              }
            }
        }
    }
#line 257
    __nesc_atomic_end(__nesc_atomic); }
#line 257
  Link_TUnitProcessingP$attemptEventSend();
  return SUCCESS;
}





static void Link_TUnitProcessingP$attemptEventSend(void)
#line 265
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 266
    {
      if (Link_TUnitProcessingP$SendState$isIdle()) {

          if (__nesc_ntoh_uint8((unsigned char *)&((TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg])->data)->cmd) != Link_TUnitProcessingP$EMPTY) {

              Link_TUnitProcessingP$SendState$forceState(Link_TUnitProcessingP$S_BUSY);
              Link_TUnitProcessingP$sendEventMsg$postTask();
            }
        }
    }
#line 275
    __nesc_atomic_end(__nesc_atomic); }
}

# 159 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(uint8_t id)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 161
    {
#line 161
      {
        unsigned char __nesc_temp = 
#line 161
        SchedulerBasicP$pushTask(id) ? SUCCESS : EBUSY;

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

# 201 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
__attribute((noinline))   void assertNotEqualsFailed(char *failMsg, uint32_t actual)
#line 201
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testNotEqualsFailed(TUnitP$currentTest, failMsg, actual);
    }
}

__attribute((noinline))   void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual)
#line 207
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testResultIsBelowFailed(TUnitP$currentTest, failMsg, upperbound, actual);
    }
}

__attribute((noinline))   void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual)
#line 213
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testResultIsAboveFailed(TUnitP$currentTest, failMsg, lowerbound, actual);
    }
}

__attribute((noinline))   void assertSuccess(void)
#line 219
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testSuccess(TUnitP$currentTest);
    }
}


__attribute((noinline))   void assertFail(char *failMsg)
#line 226
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testFailed(TUnitP$currentTest, failMsg);
    }
}

# 11 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
 __attribute((wakeup)) __attribute((interrupt(12))) void sig_TIMERA0_VECTOR(void)
#line 11
{
#line 11
  Msp430TimerCommonP$VectorTimerA0$fired();
}

# 169 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(/*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired();
    }
}

#line 169
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(/*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired();
    }
}

#line 169
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void)
{
  if (/*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl().cap) {
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(/*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent());
    }
  else {
#line 174
    /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired();
    }
}

# 12 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
 __attribute((wakeup)) __attribute((interrupt(10))) void sig_TIMERA1_VECTOR(void)
#line 12
{
#line 12
  Msp430TimerCommonP$VectorTimerA1$fired();
}

#line 13
 __attribute((wakeup)) __attribute((interrupt(26))) void sig_TIMERB0_VECTOR(void)
#line 13
{
#line 13
  Msp430TimerCommonP$VectorTimerB0$fired();
}

# 135 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n)
{
}

# 28 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(uint8_t arg_0x1ab600f8){
#line 28
  switch (arg_0x1ab600f8) {
#line 28
    case 0:
#line 28
      /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired();
#line 28
      break;
#line 28
    case 1:
#line 28
      /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired();
#line 28
      break;
#line 28
    case 2:
#line 28
      /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired();
#line 28
      break;
#line 28
    case 3:
#line 28
      /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired();
#line 28
      break;
#line 28
    case 4:
#line 28
      /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired();
#line 28
      break;
#line 28
    case 5:
#line 28
      /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired();
#line 28
      break;
#line 28
    case 6:
#line 28
      /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired();
#line 28
      break;
#line 28
    case 7:
#line 28
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired();
#line 28
      break;
#line 28
    default:
#line 28
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(arg_0x1ab600f8);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 14 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
 __attribute((wakeup)) __attribute((interrupt(24))) void sig_TIMERB1_VECTOR(void)
#line 14
{
#line 14
  Msp430TimerCommonP$VectorTimerB1$fired();
}

# 52 "/svn/tinyos-2.x/tos/system/RealMainP.nc"
  int main(void)
#line 52
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {





      {
      }
#line 60
      ;

      RealMainP$Scheduler$init();





      RealMainP$PlatformInit$init();
      while (RealMainP$Scheduler$runNextTask()) ;





      RealMainP$SoftwareInit$init();
      while (RealMainP$Scheduler$runNextTask()) ;
    }
#line 77
    __nesc_atomic_end(__nesc_atomic); }


  __nesc_enable_interrupt();

  RealMainP$Boot$booted();


  RealMainP$Scheduler$taskLoop();




  return -1;
}

# 160 "/svn/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static void Msp430ClockP$set_dco_calib(int calib)
{
  BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
  DCOCTL = calib & 0xff;
}

# 16 "../../../../../../../../../../blaze/tos/platforms/tmote1100/MotePlatformC.nc"
static void MotePlatformC$TOSH_FLASH_M25P_DP_bit(bool set)
#line 16
{
  if (set) {
    TOSH_SET_SIMO0_PIN();
    }
  else {
#line 20
    TOSH_CLR_SIMO0_PIN();
    }
#line 21
  TOSH_SET_UCLK0_PIN();
  TOSH_CLR_UCLK0_PIN();
}

# 123 "/svn/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static  bool SchedulerBasicP$Scheduler$runNextTask(void)
{
  uint8_t nextTask;

  /* atomic removed: atomic calls only */
#line 127
  {
    nextTask = SchedulerBasicP$popTask();
    if (nextTask == SchedulerBasicP$NO_TASK) 
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
  SchedulerBasicP$TaskBasic$runTask(nextTask);
  return TRUE;
}

#line 164
static   void SchedulerBasicP$TaskBasic$default$runTask(uint8_t id)
{
}

# 64 "/svn/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x1a924b28){
#line 64
  switch (arg_0x1a924b28) {
#line 64
    case TUnitP$begin:
#line 64
      TUnitP$begin$runTask();
#line 64
      break;
#line 64
    case TUnitP$waitForSendDone:
#line 64
      TUnitP$waitForSendDone$runTask();
#line 64
      break;
#line 64
    case TUnitP$runDone:
#line 64
      TUnitP$runDone$runTask();
#line 64
      break;
#line 64
    case Link_TUnitProcessingP$sendEventMsg:
#line 64
      Link_TUnitProcessingP$sendEventMsg$runTask();
#line 64
      break;
#line 64
    case Link_TUnitProcessingP$allDone:
#line 64
      Link_TUnitProcessingP$allDone$runTask();
#line 64
      break;
#line 64
    case /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask:
#line 64
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask();
#line 64
      break;
#line 64
    case /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask:
#line 64
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask();
#line 64
      break;
#line 64
    case SerialP$RunTx:
#line 64
      SerialP$RunTx$runTask();
#line 64
      break;
#line 64
    case SerialP$startDoneTask:
#line 64
      SerialP$startDoneTask$runTask();
#line 64
      break;
#line 64
    case SerialP$stopDoneTask:
#line 64
      SerialP$stopDoneTask$runTask();
#line 64
      break;
#line 64
    case SerialP$defaultSerialFlushTask:
#line 64
      SerialP$defaultSerialFlushTask$runTask();
#line 64
      break;
#line 64
    case /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone:
#line 64
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask();
#line 64
      break;
#line 64
    case /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask:
#line 64
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask();
#line 64
      break;
#line 64
    case /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask:
#line 64
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask();
#line 64
      break;
#line 64
    case BlazeSpiP$grant:
#line 64
      BlazeSpiP$grant$runTask();
#line 64
      break;
#line 64
    case BlazeSpiP$radioInitDone:
#line 64
      BlazeSpiP$radioInitDone$runTask();
#line 64
      break;
#line 64
    case /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task:
#line 64
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask();
#line 64
      break;
#line 64
    case /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask:
#line 64
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$runTask();
#line 64
      break;
#line 64
    case BlazeReceiveP$receiveDone:
#line 64
      BlazeReceiveP$receiveDone$runTask();
#line 64
      break;
#line 64
    default:
#line 64
      SchedulerBasicP$TaskBasic$default$runTask(arg_0x1a924b28);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 377 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static void BlazeReceiveP$cleanUp(void)
#line 377
{
  uint8_t id;
  uint8_t missed;

#line 380
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 380
    id = BlazeReceiveP$m_id;
#line 380
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 381
    missed = BlazeReceiveP$missedPackets;
#line 381
    __nesc_atomic_end(__nesc_atomic); }

  BlazeReceiveP$Csn$set(id);
  BlazeReceiveP$State$toIdle();

  if (missed > 0) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 387
        BlazeReceiveP$missedPackets--;
#line 387
        __nesc_atomic_end(__nesc_atomic); }
      BlazeReceiveP$receive();
    }
  else {
      BlazeReceiveP$Resource$release();
    }
}

# 45 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$set(void)
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t *)53U |= 0x01 << 0;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 346 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static void BlazeReceiveP$receive(void)
#line 346
{
  uint8_t *msg;
  uint8_t id;

#line 349
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 349
    msg = (uint8_t *)BlazeReceiveP$m_msg;
#line 349
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 350
    id = BlazeReceiveP$m_id;
#line 350
    __nesc_atomic_end(__nesc_atomic); }

  BlazeReceiveP$Csn$clr(id);


  BlazeReceiveP$RXFIFO$beginRead(msg, 1);
}

# 46 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P60*/HplMsp430GeneralIOP$40$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)53U &= ~(0x01 << 0);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 184 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static   blaze_status_t BlazeSpiP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 185
{

  blaze_status_t status;

#line 188
  BlazeSpiP$State$forceState(BlazeSpiP$S_READ_FIFO);
  status = BlazeSpiP$SpiByte$write((addr | BLAZE_BURST) | BLAZE_READ);
  BlazeSpiP$Fifo$continueRead(addr, data, len);

  return status;
}

# 98 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(uint8_t tx)
#line 98
{
  uint8_t byte;


  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(tx);
  while (!/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending()) ;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr();
  byte = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx();

  return byte;
}

# 386 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static   uint8_t HplMsp430Usart0P$Usart$rx(void)
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

# 146 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len)
#line 148
{

  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_client = id;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf = tx_buf;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf = rx_buf;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len = len;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos = 0;

  if (len) {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$enableRxIntr();
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp();
    }
  else {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$postTask();
    }

  return SUCCESS;
}

#line 120
static void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp(void)
#line 120
{

  uint8_t end;
  uint8_t tmp;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 125
    {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf ? /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos] : 0);

      end = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos + /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SPI_ATOMIC_SIZE;
      if (end > /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len) {
        end = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len;
        }
      while (++/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos < end) {
          while (!/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isTxIntrPending()) ;
          /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrTxIntr();
          /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf ? /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos] : 0);
          while (!/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending()) ;
          /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr();
          tmp = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx();
          if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf) {
            /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos - 1] = tmp;
            }
        }
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

# 144 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static   error_t BlazeSpiP$Resource$release(uint8_t id)
#line 144
{
  uint8_t i;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 147
    {
      if (BlazeSpiP$m_holder != id) {
          {
            unsigned char __nesc_temp = 
#line 149
            FAIL;

            {
#line 149
              __nesc_atomic_end(__nesc_atomic); 
#line 149
              return __nesc_temp;
            }
          }
        }
#line 152
      BlazeSpiP$m_holder = BlazeSpiP$NO_HOLDER;
      if (!BlazeSpiP$m_requests) {
          BlazeSpiP$SpiResourceState$toIdle();
          BlazeSpiP$attemptRelease();
        }
      else {
          for (i = BlazeSpiP$m_holder + 1; ; i++) {
              i %= BlazeSpiP$RESOURCE_COUNT;

              if (BlazeSpiP$m_requests & (1 << i)) {
                  BlazeSpiP$m_holder = i;
                  BlazeSpiP$m_requests &= ~(1 << i);
                  BlazeSpiP$grant$postTask();
                  {
                    unsigned char __nesc_temp = 
#line 165
                    SUCCESS;

                    {
#line 165
                      __nesc_atomic_end(__nesc_atomic); 
#line 165
                      return __nesc_temp;
                    }
                  }
                }
            }
        }
    }
#line 171
    __nesc_atomic_end(__nesc_atomic); }
#line 171
  return SUCCESS;
}

# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   void BlazeSpiP$SpiResourceState$toIdle(void){
#line 56
  StateImplP$State$toIdle(5U);
#line 56
}
#line 56
# 108 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$release(uint8_t id)
#line 108
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_BUSY && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId == id) {
          if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$isEmpty() == FALSE) {
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Queue$dequeue();
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_GRANTING;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$postTask();
            }
          else {
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$default_owner_id;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$granted();
            }
          /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceConfigure$unconfigure(id);
        }
    }
#line 123
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 265 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static   void HplMsp430Usart0P$Usart$setModeSpi(msp430_spi_union_config_t *config)
#line 265
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 267
    {
      HplMsp430Usart0P$Usart$resetUsart(TRUE);
      HplMsp430Usart0P$HplI2C$clearModeI2C();
      HplMsp430Usart0P$Usart$disableUart();
      HplMsp430Usart0P$configSpi(config);
      HplMsp430Usart0P$Usart$enableSpi();
      HplMsp430Usart0P$Usart$resetUsart(FALSE);
      HplMsp430Usart0P$Usart$clrIntr();
      HplMsp430Usart0P$Usart$disableIntr();
    }
#line 276
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 217 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static   void BlazeSpiP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error)
#line 218
{

  uint8_t status = BlazeSpiP$State$getState();

#line 221
  BlazeSpiP$State$toIdle();

  if (status == BlazeSpiP$S_INIT) {

      BlazeSpiP$radioInitDone$postTask();
    }
  else {
#line 227
    if (status == BlazeSpiP$S_READ_FIFO) {
        BlazeSpiP$Fifo$readDone(BlazeSpiP$m_addr, rx_buf, len, error);
      }
    else {
#line 230
      if (status == BlazeSpiP$S_WRITE_FIFO) {
          BlazeSpiP$Fifo$writeDone(BlazeSpiP$m_addr, tx_buf, len, error);
        }
      }
    }
}

# 143 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static   uint8_t StateImplP$State$getState(uint8_t id)
#line 143
{
  uint8_t theState;

#line 145
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 145
    theState = StateImplP$state[id];
#line 145
    __nesc_atomic_end(__nesc_atomic); }
  return theState;
}

# 358 "../../../../../../../../../../blaze/tos/chips/blazeradio/receive/BlazeReceiveP.nc"
static void BlazeReceiveP$failReceive(void)
#line 358
{
  uint8_t state;

#line 360
  BlazeReceiveP$SIDLE$strobe();
  BlazeReceiveP$SFRX$strobe();

  state = BlazeReceiveP$RadioStatus$getRadioStatus();
  if (state == BLAZE_S_TXFIFO_UNDERFLOW) {
      BlazeReceiveP$SIDLE$strobe();
      BlazeReceiveP$SFTX$strobe();
    }

  BlazeReceiveP$SRX$strobe();

  BlazeReceiveP$cleanUp();
}

# 254 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static   uint8_t BlazeSpiP$RadioStatus$getRadioStatus(void)
#line 254
{
  uint8_t ret;
  uint8_t chk;

#line 257
  ret = BlazeSpiP$getRadioStatus();

  while ((chk = BlazeSpiP$getRadioStatus()) != ret) {
      ret = chk;
    }

  return ret;
}

# 96 "/svn/tinyos-2.x/tos/system/StateImplP.nc"
static   error_t StateImplP$State$requestState(uint8_t id, uint8_t reqState)
#line 96
{
  error_t returnVal = FAIL;

#line 98
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 98
    {
      if (reqState == StateImplP$S_IDLE || StateImplP$state[id] == StateImplP$S_IDLE) {
          StateImplP$state[id] = reqState;
          returnVal = SUCCESS;
        }
    }
#line 103
    __nesc_atomic_end(__nesc_atomic); }
  return returnVal;
}

# 40 "/svn/tinyos-2.x/tos/system/CrcC.nc"
static  uint16_t CrcC$Crc$crc16(void *buf, uint8_t len)
#line 40
{
  uint8_t *tmp = (uint8_t *)buf;
  uint16_t crc;

#line 43
  for (crc = 0; len > 0; len--) {
      crc = crcByte(crc, * tmp++);
    }
  return crc;
}

# 80 "/svn/tinyos-2.x/tos/system/crc.h"
static uint16_t crcByte(uint16_t crc, uint8_t b)
#line 80
{
  crc = (uint8_t )(crc >> 8) | (crc << 8);
  crc ^= b;
  crc ^= (uint8_t )(crc & 0xff) >> 4;
  crc ^= crc << 12;
  crc ^= (crc & 0xff) << 5;
  return crc;
}

# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   void BlazeTransmitP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(7U);
#line 56
}
#line 56
# 41 "/svn/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static error_t /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$enable(bool rising)
#line 41
{
  /* atomic removed: atomic calls only */
#line 42
  {
    /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$Interrupt$disable();
    /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$edge(rising);
    /*HplCC1100PinsC.CC1100GDO2*/Msp430InterruptC$1$HplInterrupt$enable();
  }
  return SUCCESS;
}

# 50 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$makeInput(void)
#line 50
{
#line 50
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 50
    * (volatile uint8_t *)42U &= ~(0x01 << 3);
#line 50
    __nesc_atomic_end(__nesc_atomic); }
}

#line 50
static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$makeInput(void)
#line 50
{
#line 50
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 50
    * (volatile uint8_t *)42U &= ~(0x01 << 6);
#line 50
    __nesc_atomic_end(__nesc_atomic); }
}

# 102 "../../../../../../../../../../blaze/tos/chips/blazeradio/spi/BlazeSpiP.nc"
static   error_t BlazeSpiP$Resource$request(uint8_t id)
#line 102
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 104
    {
      if (BlazeSpiP$SpiResourceState$requestState(BlazeSpiP$S_BUSY) == SUCCESS) {
          BlazeSpiP$m_holder = id;
          if (BlazeSpiP$SpiResource$isOwner()) {
              BlazeSpiP$grant$postTask();
            }
          else {
              BlazeSpiP$SpiResource$request();
            }
        }
      else {
          BlazeSpiP$m_requests |= 1 << id;
        }
    }
#line 117
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 171 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$Resource$isOwner(uint8_t id)
#line 171
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 172
    {
      if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId == id && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_BUSY) {
          unsigned char __nesc_temp = 
#line 173
          TRUE;

          {
#line 173
            __nesc_atomic_end(__nesc_atomic); 
#line 173
            return __nesc_temp;
          }
        }
      else 
#line 174
        {
          unsigned char __nesc_temp = 
#line 174
          FALSE;

          {
#line 174
            __nesc_atomic_end(__nesc_atomic); 
#line 174
            return __nesc_temp;
          }
        }
    }
#line 177
    __nesc_atomic_end(__nesc_atomic); }
}

#line 127
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ResourceDefaultOwner$release(void)
#line 127
{
  /* atomic removed: atomic calls only */
#line 128
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$default_owner_id) {
        if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_GRANTING) {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$grantedTask$postTask();
            {
              unsigned char __nesc_temp = 
#line 132
              SUCCESS;

#line 132
              return __nesc_temp;
            }
          }
        else {
#line 134
          if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_IMM_GRANTING) {
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$reqResId;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_BUSY;
              {
                unsigned char __nesc_temp = 
#line 137
                SUCCESS;

#line 137
                return __nesc_temp;
              }
            }
          }
      }
  }
#line 141
  return FAIL;
}

# 205 "../../../../../../../../../../blaze/tos/chips/blazeradio/init/BlazeInitP.nc"
static   void BlazeInitP$BlazePower$shutdown(radio_id_t id)
#line 205
{
  BlazeInitP$Gdo0_io$makeOutput(id);
  BlazeInitP$Gdo2_io$makeOutput(id);

  BlazeInitP$Gdo0_io$clr(id);
  BlazeInitP$Gdo2_io$clr(id);

  BlazeInitP$Power$clr(id);
}

# 46 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P23*/HplMsp430GeneralIOP$11$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)41U &= ~(0x01 << 3);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

#line 46
static   void /*HplMsp430GeneralIOC.P26*/HplMsp430GeneralIOP$14$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)41U &= ~(0x01 << 6);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 82 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(uint8_t id)
#line 82
{
  msp430_uart_union_config_t *config = /*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(id);

#line 84
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_byte_time = config->uartConfig.ubr / 2;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(config);
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr();
}

# 251 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static   void HplMsp430Usart1P$Usart$disableSpi(void)
#line 251
{
  /* atomic removed: atomic calls only */
#line 252
  {
    HplMsp430Usart1P$ME2 &= ~(1 << 4);
    HplMsp430Usart1P$SIMO$selectIOFunc();
    HplMsp430Usart1P$SOMI$selectIOFunc();
    HplMsp430Usart1P$UCLK$selectIOFunc();
  }
}

#line 211
static   void HplMsp430Usart1P$Usart$disableUart(void)
#line 211
{
  /* atomic removed: atomic calls only */
#line 212
  {
    HplMsp430Usart1P$ME2 &= ~((1 << 5) | (1 << 4));
    HplMsp430Usart1P$UTXD$selectIOFunc();
    HplMsp430Usart1P$URXD$selectIOFunc();
  }
}

# 166 "/svn/tinyos-2.x/tos/system/AMQueueImplP.nc"
static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void)
#line 166
{
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket();
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current < 1) {
      error_t nextErr;
      message_t *nextMsg = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg;
      am_id_t nextId = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(nextMsg);
      am_addr_t nextDest = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(nextMsg);
      uint8_t len = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(nextMsg);

#line 174
      nextErr = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(nextId, nextDest, nextMsg, len);
      if (nextErr != SUCCESS) {
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask();
        }
    }
}

# 127 "/svn/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg)
#line 127
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 129
  return __nesc_ntoh_uint16((unsigned char *)&header->dest);
}

#line 53
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(am_id_t id, am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 55
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg);

#line 57
  __nesc_hton_uint16((unsigned char *)&header->dest, dest);





  __nesc_hton_uint8((unsigned char *)&header->type, id);
  __nesc_hton_uint8((unsigned char *)&header->length, len);

  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(msg, len);
}

# 502 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static void SerialP$MaybeScheduleTx(void)
#line 502
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 503
    {
      if (SerialP$txPending == 0) {
          if (SerialP$RunTx$postTask() == SUCCESS) {
              SerialP$txPending = 1;
            }
        }
    }
#line 509
    __nesc_atomic_end(__nesc_atomic); }
}

# 118 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static  void Link_TUnitProcessingP$SerialEventSend$sendDone(message_t *msg, error_t error)
#line 118
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 119
    {
      __nesc_hton_uint8((unsigned char *)&((TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg])->data)->cmd, Link_TUnitProcessingP$EMPTY);
      Link_TUnitProcessingP$sendingEventMsg++;
      Link_TUnitProcessingP$sendingEventMsg %= 5;
    }
#line 123
    __nesc_atomic_end(__nesc_atomic); }
  Link_TUnitProcessingP$SendState$toIdle();
  Link_TUnitProcessingP$attemptEventSend();
}

# 56 "/svn/tinyos-2.x/tos/interfaces/State.nc"
static   void TUnitP$TestState$toIdle(void){
#line 56
  StateImplP$State$toIdle(3U);
#line 56
}
#line 56
# 260 "c:/TinyOS/cygwin/svn/tinyos-2.x-contrib/tunit/tos/lib/tunit/TUnitP.nc"
static void TUnitP$setUpOneTimeDone(void)
#line 260
{
  if (TUnitP$TestState$getState() == TUnitP$S_SETUP_ONETIME) {
      TUnitP$TestState$toIdle();
      if (!TUnitP$driver) {
          TUnitP$TestState$forceState(TUnitP$S_RUN);
        }
      else {
          TUnitP$attemptTest();
        }
    }
}

#line 294
static void TUnitP$attemptTest(void)
#line 294
{
  if (TUnitP$currentTest < 1U) {
      if (TUnitP$TestState$requestState(TUnitP$S_SETUP) == SUCCESS) {

          TUnitP$SetUp$run();
        }
    }
  else 
    {
      TUnitP$TUnitProcessing$allDone();
    }
}

# 347 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static void SerialP$testOff(void)
#line 347
{
  bool turnOff = FALSE;

#line 349
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 349
    {
      if (SerialP$txState == SerialP$TXSTATE_INACTIVE && 
      SerialP$rxState == SerialP$RXSTATE_INACTIVE) {
          turnOff = TRUE;
        }
    }
#line 354
    __nesc_atomic_end(__nesc_atomic); }
  if (turnOff) {
      SerialP$stopDoneTask$postTask();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 357
        SerialP$offPending = FALSE;
#line 357
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 360
        SerialP$offPending = TRUE;
#line 360
        __nesc_atomic_end(__nesc_atomic); }
    }
}

# 86 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void)
#line 86
{
  HdlcTranslateC$state.sendEscape = 0;
  HdlcTranslateC$m_data = HDLC_FLAG_BYTE;
  return HdlcTranslateC$UartStream$send(&HdlcTranslateC$m_data, 1);
}

# 137 "/svn/tinyos-2.x/tos/chips/msp430/usart/Msp430UartP.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *buf, uint16_t len)
#line 137
{
  if (len == 0) {
    return FAIL;
    }
  else {
#line 140
    if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf) {
      return EBUSY;
      }
    }
#line 142
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf = buf;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len = len;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos = 0;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos++]);
  return SUCCESS;
}

# 96 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
 __attribute((wakeup)) __attribute((interrupt(6))) void sig_UART1RX_VECTOR(void)
#line 96
{
  uint8_t temp = U1RXBUF;

#line 98
  HplMsp430Usart1P$Interrupts$rxDone(temp);
}

# 147 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void)
#line 147
{
  /* atomic removed: atomic calls only */
#line 148
  {
    if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) 
      {
        unsigned char __nesc_temp = 
#line 150
        FALSE;

#line 150
        return __nesc_temp;
      }
  }
#line 152
  return TRUE;
}

# 402 "/svn/tinyos-2.x/tos/lib/serial/SerialP.nc"
static void SerialP$rx_state_machine(bool isDelimeter, uint8_t data)
#line 402
{

  switch (SerialP$rxState) {

      case SerialP$RXSTATE_NOSYNC: 
        if (isDelimeter) {
            SerialP$rxInit();
            SerialP$rxState = SerialP$RXSTATE_PROTO;
          }
      break;

      case SerialP$RXSTATE_PROTO: 
        if (!isDelimeter) {
            SerialP$rxCRC = crcByte(SerialP$rxCRC, data);
            SerialP$rxState = SerialP$RXSTATE_TOKEN;
            SerialP$rxProto = data;
            if (!SerialP$valid_rx_proto(SerialP$rxProto)) {
              goto nosync;
              }
            if (SerialP$rxProto != SERIAL_PROTO_PACKET_ACK) {
                goto nosync;
              }
            if (SerialP$ReceiveBytePacket$startPacket() != SUCCESS) {
                goto nosync;
              }
          }
      break;

      case SerialP$RXSTATE_TOKEN: 
        if (isDelimeter) {
            goto nosync;
          }
        else {
            SerialP$rxSeqno = data;
            SerialP$rxCRC = crcByte(SerialP$rxCRC, SerialP$rxSeqno);
            SerialP$rxState = SerialP$RXSTATE_INFO;
          }
      break;

      case SerialP$RXSTATE_INFO: 
        if (SerialP$rxByteCnt < SerialP$SERIAL_MTU) {
            if (isDelimeter) {
                if (SerialP$rxByteCnt >= 2) {
                    if (SerialP$rx_current_crc() == SerialP$rxCRC) {
                        SerialP$ReceiveBytePacket$endPacket(SUCCESS);
                        SerialP$ack_queue_push(SerialP$rxSeqno);
                        goto nosync;
                      }
                    else {
                        goto nosync;
                      }
                  }
                else {
                    goto nosync;
                  }
              }
            else {
                if (SerialP$rxByteCnt >= 2) {
                    SerialP$ReceiveBytePacket$byteReceived(SerialP$rx_buffer_top());
                    SerialP$rxCRC = crcByte(SerialP$rxCRC, SerialP$rx_buffer_pop());
                  }
                SerialP$rx_buffer_push(data);
                SerialP$rxByteCnt++;
              }
          }
        else 

          {
            goto nosync;
          }
      break;

      default: 
        goto nosync;
    }
  goto done;

  nosync: 

    SerialP$rxInit();
  SerialP$SerialFrameComm$resetReceive();
  SerialP$ReceiveBytePacket$endPacket(FAIL);
  if (SerialP$offPending) {
      SerialP$rxState = SerialP$RXSTATE_INACTIVE;
      SerialP$testOff();
    }
  else {
    if (isDelimeter) {
        SerialP$rxState = SerialP$RXSTATE_PROTO;
      }
    }
  done: ;
}

# 285 "/svn/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result)
#line 285
{
  uint8_t postsignalreceive = FALSE;

  /* atomic removed: atomic calls only */
#line 287
  {
    if (!/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending && result == SUCCESS) {
        postsignalreceive = TRUE;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending = TRUE;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskType = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvType;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskWhich = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskBuf = (message_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskSize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$recvIndex;
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap();
        /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.state = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$RECV_STATE_IDLE;
      }
  }
  if (postsignalreceive) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$postTask();
    }
}

# 160 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void)
#line 160
{
  /* atomic removed: atomic calls only */
#line 161
  {
    if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state != /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY) 
      {
        unsigned char __nesc_temp = 
#line 163
        /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$NO_RES;

#line 163
        return __nesc_temp;
      }
#line 164
    {
      unsigned char __nesc_temp = 
#line 164
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId;

#line 164
      return __nesc_temp;
    }
  }
}

# 101 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
 __attribute((wakeup)) __attribute((interrupt(4))) void sig_UART1TX_VECTOR(void)
#line 101
{
  HplMsp430Usart1P$Interrupts$txDone();
}

# 92 "/svn/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putData(uint8_t data)
#line 92
{
  if (data == HDLC_CTLESC_BYTE || data == HDLC_FLAG_BYTE) {
      HdlcTranslateC$state.sendEscape = 1;
      HdlcTranslateC$txTemp = data ^ 0x20;
      HdlcTranslateC$m_data = HDLC_CTLESC_BYTE;
    }
  else {
      HdlcTranslateC$m_data = data;
    }
  return HdlcTranslateC$UartStream$send(&HdlcTranslateC$m_data, 1);
}

# 96 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
 __attribute((wakeup)) __attribute((interrupt(18))) void sig_UART0RX_VECTOR(void)
#line 96
{
  uint8_t temp = U0RXBUF;

#line 98
  HplMsp430Usart0P$Interrupts$rxDone(temp);
}

# 147 "/svn/tinyos-2.x/tos/system/ArbiterP.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$inUse(void)
#line 147
{
  /* atomic removed: atomic calls only */
#line 148
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_CONTROLLED) 
      {
        unsigned char __nesc_temp = 
#line 150
        FALSE;

#line 150
        return __nesc_temp;
      }
  }
#line 152
  return TRUE;
}






static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$ArbiterInfo$userId(void)
#line 160
{
  /* atomic removed: atomic calls only */
#line 161
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$state != /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$RES_BUSY) 
      {
        unsigned char __nesc_temp = 
#line 163
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$NO_RES;

#line 163
        return __nesc_temp;
      }
#line 164
    {
      unsigned char __nesc_temp = 
#line 164
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$1$resId;

#line 164
      return __nesc_temp;
    }
  }
}

# 101 "/svn/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
 __attribute((wakeup)) __attribute((interrupt(16))) void sig_UART0TX_VECTOR(void)
#line 101
{
  if (HplMsp430Usart0P$HplI2C$isI2C()) {
    HplMsp430Usart0P$I2CInterrupts$fired();
    }
  else {
#line 105
    HplMsp430Usart0P$Interrupts$txDone();
    }
}

# 53 "/svn/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
 __attribute((wakeup)) __attribute((interrupt(8))) void sig_PORT1_VECTOR(void)
{
  volatile int n = P1IFG & P1IE;

  if (n & (1 << 0)) {
#line 57
      HplMsp430InterruptP$Port10$fired();
#line 57
      return;
    }
#line 58
  if (n & (1 << 1)) {
#line 58
      HplMsp430InterruptP$Port11$fired();
#line 58
      return;
    }
#line 59
  if (n & (1 << 2)) {
#line 59
      HplMsp430InterruptP$Port12$fired();
#line 59
      return;
    }
#line 60
  if (n & (1 << 3)) {
#line 60
      HplMsp430InterruptP$Port13$fired();
#line 60
      return;
    }
#line 61
  if (n & (1 << 4)) {
#line 61
      HplMsp430InterruptP$Port14$fired();
#line 61
      return;
    }
#line 62
  if (n & (1 << 5)) {
#line 62
      HplMsp430InterruptP$Port15$fired();
#line 62
      return;
    }
#line 63
  if (n & (1 << 6)) {
#line 63
      HplMsp430InterruptP$Port16$fired();
#line 63
      return;
    }
#line 64
  if (n & (1 << 7)) {
#line 64
      HplMsp430InterruptP$Port17$fired();
#line 64
      return;
    }
}

#line 158
 __attribute((wakeup)) __attribute((interrupt(2))) void sig_PORT2_VECTOR(void)
{
  volatile int n = P2IFG & P2IE;

  if (n & (1 << 0)) {
#line 162
      HplMsp430InterruptP$Port20$fired();
#line 162
      return;
    }
#line 163
  if (n & (1 << 1)) {
#line 163
      HplMsp430InterruptP$Port21$fired();
#line 163
      return;
    }
#line 164
  if (n & (1 << 2)) {
#line 164
      HplMsp430InterruptP$Port22$fired();
#line 164
      return;
    }
#line 165
  if (n & (1 << 3)) {
#line 165
      HplMsp430InterruptP$Port23$fired();
#line 165
      return;
    }
#line 166
  if (n & (1 << 4)) {
#line 166
      HplMsp430InterruptP$Port24$fired();
#line 166
      return;
    }
#line 167
  if (n & (1 << 5)) {
#line 167
      HplMsp430InterruptP$Port25$fired();
#line 167
      return;
    }
#line 168
  if (n & (1 << 6)) {
#line 168
      HplMsp430InterruptP$Port26$fired();
#line 168
      return;
    }
#line 169
  if (n & (1 << 7)) {
#line 169
      HplMsp430InterruptP$Port27$fired();
#line 169
      return;
    }
}

