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
# 140 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source);




static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value);
#line 162
static __inline int8_t __nesc_hton_int8(void *target, int8_t value);






static __inline uint16_t __nesc_ntoh_uint16(const void *source);




static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value);
#line 206
static __inline uint32_t __nesc_hton_uint32(void *target, uint32_t value);
#line 290
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
# 19 "/opt/tinyos-2.0/tos/system/tos.h"
typedef uint8_t bool;
enum __nesc_unnamed4247 {
#line 20
  FALSE = 0, TRUE = 1
};
typedef struct { char data[1]; } __attribute__((packed)) nx_bool;typedef int8_t __nesc_nxbase_nx_bool  ;






struct __nesc_attr_atmostonce {
};
#line 30
struct __nesc_attr_atleastonce {
};
#line 31
struct __nesc_attr_exactlyonce {
};
# 34 "/opt/tinyos-2.0/tos/types/TinyError.h"
enum __nesc_unnamed4248 {
  SUCCESS = 0, 
  FAIL = 1, 
  ESIZE = 2, 
  ECANCEL = 3, 
  EOFF = 4, 
  EBUSY = 5, 
  EINVAL = 6, 
  ERETRY = 7, 
  ERESERVE = 8
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
# 108 "/opt/msp430/msp430/include/msp430/iostructures.h" 3
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
# 116 "/opt/msp430/msp430/include/msp430/gpio.h" 3
volatile unsigned char P1OUT __asm ("0x0021");

volatile unsigned char P1DIR __asm ("0x0022");





volatile unsigned char P1IE __asm ("0x0025");

volatile unsigned char P1SEL __asm ("0x0026");










volatile unsigned char P2OUT __asm ("0x0029");

volatile unsigned char P2DIR __asm ("0x002A");





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
# 92 "/opt/msp430/msp430/include/msp430/usart.h"
volatile unsigned char U0CTL __asm ("0x0070");

volatile unsigned char U0TCTL __asm ("0x0071");
#line 275
volatile unsigned char U1CTL __asm ("0x0078");

volatile unsigned char U1TCTL __asm ("0x0079");



volatile unsigned char U1MCTL __asm ("0x007B");

volatile unsigned char U1BR0 __asm ("0x007C");

volatile unsigned char U1BR1 __asm ("0x007D");

volatile unsigned char U1RXBUF __asm ("0x007E");
# 27 "/opt/msp430/msp430/include/msp430/timera.h"
volatile unsigned int TA0CTL __asm ("0x0160");

volatile unsigned int TA0R __asm ("0x0170");


volatile unsigned int TA0CCTL0 __asm ("0x0162");

volatile unsigned int TA0CCTL1 __asm ("0x0164");
#line 70
volatile unsigned int TA0CCTL2 __asm ("0x0166");
# 127 "/opt/msp430/msp430/include/msp430/timera.h" 3
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
# 26 "/opt/msp430/msp430/include/msp430/timerb.h"
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
# 20 "/opt/msp430/msp430/include/msp430/basic_clock.h"
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
# 83 "/opt/msp430/msp430/include/msp430x16x.h"
volatile unsigned char ME1 __asm ("0x0004");





volatile unsigned char ME2 __asm ("0x0005");
# 166 "/opt/tinyos-2.0/tos/chips/msp430/msp430hardware.h"
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
# 33 "/opt/tinyos-2.0/tos/platforms/telosb/hardware.h"
static inline void TOSH_SET_SIMO0_PIN(void);
#line 33
static inline void TOSH_CLR_SIMO0_PIN(void);
#line 33
static inline void TOSH_MAKE_SIMO0_OUTPUT(void);
#line 33
static inline void TOSH_MAKE_SIMO0_INPUT(void);
static inline void TOSH_SET_UCLK0_PIN(void);
#line 34
static inline void TOSH_CLR_UCLK0_PIN(void);
#line 34
static inline void TOSH_MAKE_UCLK0_OUTPUT(void);
#line 34
static inline void TOSH_MAKE_UCLK0_INPUT(void);
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
static inline void TOSH_CLR_FLASH_HOLD_PIN(void);
#line 86
static inline void TOSH_MAKE_FLASH_HOLD_OUTPUT(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.h"
enum __nesc_unnamed4259 {
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
typedef struct __nesc_unnamed4260 {

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
typedef struct __nesc_unnamed4261 {

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
typedef struct __nesc_unnamed4262 {

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
# 13 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestCase.h"
static void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual);
static void assertNotEqualsFailed(char *failMsg, uint32_t actual);
static void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual);
static void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual);
static void assertSuccess(void);
static void assertFail(char *failMsg);
# 6 "/opt/tinyos-2.0/tos/types/AM.h"
typedef nx_uint8_t nx_am_id_t;
typedef nx_uint8_t nx_am_group_t;
typedef nx_uint16_t nx_am_addr_t;

typedef uint8_t am_id_t;
typedef uint8_t am_group_t;
typedef uint16_t am_addr_t;

enum __nesc_unnamed4263 {
  AM_BROADCAST_ADDR = 0xffff
};









enum __nesc_unnamed4264 {
  TOS_AM_GROUP = 0x22, 
  TOS_AM_ADDRESS = 1
};
# 39 "/opt/tinyos-2.0/tos/chips/cc2420/CC2420.h"
typedef uint8_t cc2420_status_t;
#line 59
#line 45
typedef nx_struct cc2420_header_t {
  nxle_uint8_t length;
  nxle_uint16_t fcf;
  nxle_uint8_t dsn;
  nxle_uint16_t destpan;
  nxle_uint16_t dest;
  nxle_uint16_t src;






  nxle_uint8_t type;
} __attribute__((packed)) cc2420_header_t;





#line 64
typedef nx_struct cc2420_footer_t {
} __attribute__((packed)) cc2420_footer_t;
#line 86
#line 71
typedef nx_struct cc2420_metadata_t {
  nx_uint8_t tx_power;
  nx_uint8_t rssi;
  nx_uint8_t lqi;
  nx_bool crc;
  nx_bool ack;
  nx_uint16_t time;
  nx_uint16_t rxInterval;
} __attribute__((packed)) 






cc2420_metadata_t;





#line 89
typedef nx_struct cc2420_packet_t {
  cc2420_header_t packet;
  nx_uint8_t data[];
} __attribute__((packed)) cc2420_packet_t;
#line 123
enum __nesc_unnamed4265 {

  MAC_HEADER_SIZE = sizeof(cc2420_header_t ) - 1, 

  MAC_FOOTER_SIZE = sizeof(uint16_t ), 

  MAC_PACKET_SIZE = MAC_HEADER_SIZE + 28 + MAC_FOOTER_SIZE
};

enum cc2420_enums {
  CC2420_TIME_ACK_TURNAROUND = 7, 
  CC2420_TIME_VREN = 20, 
  CC2420_TIME_SYMBOL = 2, 
  CC2420_BACKOFF_PERIOD = 20 / CC2420_TIME_SYMBOL, 
  CC2420_MIN_BACKOFF = 20 / CC2420_TIME_SYMBOL, 
  CC2420_ACK_WAIT_DELAY = 128
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
# 72 "/opt/tinyos-2.0/tos/lib/serial/Serial.h"
typedef uint8_t uart_id_t;



enum __nesc_unnamed4266 {
  HDLC_FLAG_BYTE = 0x7e, 
  HDLC_CTLESC_BYTE = 0x7d
};



enum __nesc_unnamed4267 {
  TOS_SERIAL_ACTIVE_MESSAGE_ID = 0, 
  TOS_SERIAL_CC1000_ID = 1, 
  TOS_SERIAL_802_15_4_ID = 2, 
  TOS_SERIAL_UNKNOWN_ID = 255
};


enum __nesc_unnamed4268 {
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
# 48 "/opt/tinyos-2.0/tos/platforms/telosa/platform_message.h"
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
# 19 "/opt/tinyos-2.0/tos/types/message.h"
#line 14
typedef nx_struct message_t {
  nx_uint8_t header[sizeof(message_header_t )];
  nx_uint8_t data[28];
  nx_uint8_t footer[sizeof(message_footer_t )];
  nx_uint8_t metadata[sizeof(message_metadata_t )];
} __attribute__((packed)) message_t;
# 28 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessing.h"
#line 20
typedef nx_struct TUnitProcessingMsg {
  nx_uint8_t cmd;
  nx_uint8_t id;
  nx_uint32_t expected;
  nx_uint32_t actual;
  nx_bool lastMsg;
  nx_uint8_t failMsgLength;
  nx_uint8_t failMsg[28 - 12];
} __attribute__((packed)) TUnitProcessingMsg;


enum __nesc_unnamed4269 {
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
  TUNITPROCESSING_EVENT_ALLDONE = 11
};

enum __nesc_unnamed4270 {
  AM_TUNITPROCESSINGMSG = 0xFF
};
# 30 "/opt/tinyos-2.0/tos/types/Leds.h"
enum __nesc_unnamed4271 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
# 52 "/opt/tinyos-2.0/tos/system/crc.h"
static uint16_t crcByte(uint16_t crc, uint8_t b);
# 56 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
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

static inline uint8_t uctl2int(msp430_uctl_t x);
static inline msp430_uctl_t int2uctl(uint8_t x);

static inline uint8_t utctl2int(msp430_utctl_t x);
static inline msp430_utctl_t int2utctl(uint8_t x);

static inline uint8_t urctl2int(msp430_urctl_t x);
static inline msp430_urctl_t int2urctl(uint8_t x);
#line 109
#line 99
typedef struct __nesc_unnamed4276 {
  unsigned int ubr : 16;
  unsigned int ssel : 2;
  unsigned int clen : 1;
  unsigned int listen : 1;
  unsigned int mm : 1;
  unsigned int ckph : 1;
  unsigned int ckpl : 1;
  unsigned int stc : 1;
  unsigned int  : 0;
} msp430_spi_config_t;
#line 128
#line 113
typedef struct __nesc_unnamed4277 {
  unsigned int ubr : 16;
  unsigned int umctl : 8;
  unsigned int ssel : 2;
  unsigned int pena : 1;
  unsigned int pev : 1;
  unsigned int spb : 1;
  unsigned int clen : 1;
  unsigned int listen : 1;
  unsigned int mm : 1;
  unsigned int  : 0;
  unsigned int ckpl : 1;
  unsigned int urxse : 1;
  unsigned int urxeie : 1;
  unsigned int urxwie : 1;
} msp430_uart_config_t;
#line 156
#line 130
typedef enum __nesc_unnamed4278 {








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

msp430_uart_config_t msp430_uart_default_config = { .ubr = UBR_1MHZ_57600, .umctl = UMCTL_1MHZ_57600, .ssel = 0x02, .pena = 0, .pev = 0, .spb = 0, .clen = 1, .listen = 0, .mm = 0, .ckpl = 0, .urxse = 0, .urxeie = 1, .urxwie = 0 };
#line 172
#line 160
typedef struct __nesc_unnamed4279 {
  unsigned int rxdmaen : 1;
  unsigned int txdmaen : 1;
  unsigned int xa : 1;
  unsigned int listen : 1;
  unsigned int i2cword : 1;
  unsigned int i2crm : 1;
  unsigned int i2cssel : 2;
  unsigned int i2cpsc : 8;
  unsigned int i2csclh : 8;
  unsigned int i2cscll : 8;
  unsigned int i2coa : 10;
} msp430_i2c_config_t;
# 29 "/opt/tinyos-2.0/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4280 {
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4281 {
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4282 {
} 
#line 31
TMicro;
# 33 "/opt/tinyos-2.0/tos/types/Resource.h"
typedef uint8_t resource_client_id_t;
enum SerialAMQueueP$__nesc_unnamed4283 {
  SerialAMQueueP$NUM_CLIENTS = 1U
};
enum /*PlatformSerialC.UartC*/Msp430Uart1C$0$__nesc_unnamed4284 {
  Msp430Uart1C$0$CLIENT_ID = 0U
};
typedef T32khz /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$precision_tag;
typedef uint16_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$size_type;
typedef T32khz /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag;
typedef /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$precision_tag;
typedef uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$size_type;
enum /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$__nesc_unnamed4285 {
  Msp430Usart1C$0$CLIENT_ID = 0U
};
enum /*TestStateC.TestForceC*/TestCaseC$0$__nesc_unnamed4286 {
  TestCaseC$0$TUNIT_TEST_ID = 0U
};
enum /*TestStateC.TestToIdleC*/TestCaseC$1$__nesc_unnamed4287 {
  TestCaseC$1$TUNIT_TEST_ID = 1U
};
enum /*TestStateC.TestRequestC*/TestCaseC$2$__nesc_unnamed4288 {
  TestCaseC$2$TUNIT_TEST_ID = 2U
};
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t PlatformP$Init$init(void);
#line 51
static  error_t MotePlatformC$Init$init(void);
# 30 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockInit.nc"
static  void Msp430ClockP$Msp430ClockInit$default$initTimerB(void);


static  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void);
#line 29
static  void Msp430ClockP$Msp430ClockInit$default$initTimerA(void);




static  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void);
#line 28
static  void Msp430ClockP$Msp430ClockInit$default$initClocks(void);



static  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t Msp430ClockP$Init$init(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(
# 40 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1aa55710);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(
# 40 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1aa55710);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void);
# 33 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t arg_0x1aa269e0);
# 31 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(
# 45 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a890dd8);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$default$runTask(
# 45 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a890dd8);
# 46 "/opt/tinyos-2.0/tos/interfaces/Scheduler.nc"
static  void SchedulerBasicP$Scheduler$init(void);
#line 61
static  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 54
static  bool SchedulerBasicP$Scheduler$runNextTask(void);
# 54 "/opt/tinyos-2.0/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 59 "/opt/tinyos-2.0/tos/interfaces/McuSleep.nc"
static   void McuSleepC$McuSleep$sleep(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t StateImplP$Init$init(void);
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   uint8_t StateImplP$State$getState(
# 67 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
uint8_t arg_0x1ab568c0);
# 56 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   void StateImplP$State$toIdle(
# 67 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
uint8_t arg_0x1ab568c0);
# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   bool StateImplP$State$isIdle(
# 67 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
uint8_t arg_0x1ab568c0);
# 45 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   error_t StateImplP$State$requestState(
# 67 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
uint8_t arg_0x1ab568c0, 
# 45 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
uint8_t arg_0x1a926708);





static   void StateImplP$State$forceState(
# 67 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
uint8_t arg_0x1ab568c0, 
# 51 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
uint8_t arg_0x1a926c80);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TestStateP$TearDownOneTime$run(void);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
static  void TestStateP$TestForce$run(void);
#line 10
static  void TestStateP$TestRequest$run(void);
#line 10
static  void TestStateP$TestToIdle$run(void);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TestStateP$SetUpOneTime$run(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void TUnitP$waitForSendDone$runTask(void);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDownOneTime$done(void);
#line 8
static  void TUnitP$TearDown$default$run(void);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
static  void TUnitP$TestCase$default$run(
# 42 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1aba6be0);
# 12 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
static  void TUnitP$TestCase$done(
# 42 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1aba6be0);
# 27 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
static  void TUnitP$TUnitProcessing$run(void);

static  void TUnitP$TUnitProcessing$ping(void);
# 88 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
static  void TUnitP$SerialSplitControl$startDone(error_t arg_0x1abc4b40);
#line 110
static  void TUnitP$SerialSplitControl$stopDone(error_t arg_0x1abc3688);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$SetUp$default$run(void);

static  void TUnitP$SetUpOneTime$done(void);
# 16 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/StatsQuery.nc"
static  bool TUnitP$StatsQuery$default$isIdle(void);
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  void Link_TUnitProcessingP$SerialEventSend$sendDone(message_t *arg_0x1ac521d8, error_t arg_0x1ac52358);
# 49 "/opt/tinyos-2.0/tos/interfaces/Boot.nc"
static  void Link_TUnitProcessingP$Boot$booted(void);
# 17 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
static   void Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1abb6b50, char *arg_0x1abb6ce8, uint32_t arg_0x1abb6e78, uint32_t arg_0x1abb5030);
#line 11
static   void Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1abb8088, char *arg_0x1abb8220, uint32_t arg_0x1abb83b0, uint32_t arg_0x1abb8538);



static   void Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1abb61e8, char *arg_0x1abb6380, uint32_t arg_0x1abb6510, uint32_t arg_0x1abb6698);



static   void Link_TUnitProcessingP$TUnitProcessing$testFailed(uint8_t arg_0x1abb54e0, char *arg_0x1abb5678);
#line 13
static   void Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1abb89f0, char *arg_0x1abb8b88, uint32_t arg_0x1abb8d10);
#line 9
static   void Link_TUnitProcessingP$TUnitProcessing$testSuccess(uint8_t arg_0x1abb9bd8);
#line 22
static  void Link_TUnitProcessingP$TUnitProcessing$allDone(void);

static  void Link_TUnitProcessingP$TUnitProcessing$pong(void);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t *Link_TUnitProcessingP$SerialReceive$receive(message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 88 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
static  void Link_TUnitProcessingP$SerialSplitControl$startDone(error_t arg_0x1abc4b40);
#line 110
static  void Link_TUnitProcessingP$SerialSplitControl$stopDone(error_t arg_0x1abc3688);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void Link_TUnitProcessingP$sendEventMsg$runTask(void);
#line 64
static  void Link_TUnitProcessingP$allDone$runTask(void);
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8);
#line 125
static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *arg_0x1ac52df0);
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(
# 40 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad0bbf0, 
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
message_t *arg_0x1ac521d8, error_t arg_0x1ac52358);
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(
# 38 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad0b2c8, 
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8);
#line 114
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(
# 38 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad0b2c8, 
# 114 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1ace7ab8);
#line 89
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(
# 38 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad0b2c8, 
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(
# 36 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad34ae0, 
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8);
#line 125
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(
# 36 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad34ae0, 
# 125 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
message_t *arg_0x1ac52df0);
# 67 "/opt/tinyos-2.0/tos/interfaces/Packet.nc"
static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *arg_0x1acb2e88);
#line 108
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *arg_0x1acb0278, uint8_t *arg_0x1acb0418);
#line 83
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *arg_0x1acb1530, uint8_t arg_0x1acb16b0);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(
# 37 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad334a0, 
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 67 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *arg_0x1acc5460);
#line 110
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setSource(message_t *arg_0x1acc4888, am_addr_t arg_0x1acc4a10);
#line 92
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *arg_0x1acc4010, am_addr_t arg_0x1acc4198);
#line 136
static  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *arg_0x1acc38e0);
#line 151
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *arg_0x1acc3e58, am_id_t arg_0x1acc1010);
# 79 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
static  error_t SerialP$SplitControl$start(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SerialP$stopDoneTask$runTask(void);
#line 64
static  void SerialP$RunTx$runTask(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t SerialP$Init$init(void);
# 43 "/opt/tinyos-2.0/tos/interfaces/SerialFlush.nc"
static  void SerialP$SerialFlush$flushDone(void);
#line 38
static  void SerialP$SerialFlush$default$flush(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SerialP$startDoneTask$runTask(void);
# 83 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
static   void SerialP$SerialFrameComm$dataReceived(uint8_t arg_0x1ada8010);





static   void SerialP$SerialFrameComm$putDone(void);
#line 74
static   void SerialP$SerialFrameComm$delimiterReceived(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SerialP$defaultSerialFlushTask$runTask(void);
# 60 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
static   error_t SerialP$SendBytePacket$completeSend(void);
#line 51
static   error_t SerialP$SendBytePacket$startSend(uint8_t arg_0x1ad98ae0);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(
# 40 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2d4e8, 
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8);
#line 89
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(
# 40 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2d4e8, 
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(
# 39 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae10d88, 
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68, 
# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1ad8acc8, uint8_t arg_0x1ad8ae50);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68);
# 23 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68, 
# 23 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1ad8a4e8, uint8_t arg_0x1ad8a670);
# 70 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);









static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t arg_0x1ad97ae0);
# 51 "/opt/tinyos-2.0/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);






static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t arg_0x1ad92188);










static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t arg_0x1ad92748);
# 79 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
static   void HdlcTranslateC$UartStream$receivedByte(uint8_t arg_0x1ae620b8);
#line 99
static   void HdlcTranslateC$UartStream$receiveDone(uint8_t *arg_0x1ae62d60, uint16_t arg_0x1ae62ee8, error_t arg_0x1ae61088);
#line 57
static   void HdlcTranslateC$UartStream$sendDone(uint8_t *arg_0x1ae63068, uint16_t arg_0x1ae631f0, error_t arg_0x1ae63370);
# 45 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void);
#line 68
static   void HdlcTranslateC$SerialFrameComm$resetReceive(void);
#line 54
static   error_t HdlcTranslateC$SerialFrameComm$putData(uint8_t arg_0x1adabd50);
# 55 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(
# 43 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aeda320);
# 49 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(
# 43 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aeda320);
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(
# 49 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed7778);
# 48 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *arg_0x1ae648c0, uint16_t arg_0x1ae64a48);
# 71 "/opt/tinyos-2.0/tos/lib/timer/Counter.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void);
# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(
# 48 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed8e38);
# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(
# 48 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed8e38);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(
# 48 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed8e38);
# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(
# 42 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aedb968);
# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(
# 42 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aedb968);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(
# 42 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aedb968);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t arg_0x1aec1d70);
#line 49
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void);
# 50 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartControl.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartControl$setModeDuplex(
# 44 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aeda9f0);
# 50 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430Usart1P$Usart$setUctl(msp430_uctl_t arg_0x1aed1570);
#line 123
static   void HplMsp430Usart1P$Usart$enableUart(void);
#line 70
static   void HplMsp430Usart1P$Usart$setUrctl(msp430_urctl_t arg_0x1aed05c8);
#line 65
static   msp430_utctl_t HplMsp430Usart1P$Usart$getUtctl(void);









static   msp430_urctl_t HplMsp430Usart1P$Usart$getUrctl(void);
#line 97
static   void HplMsp430Usart1P$Usart$resetUsart(bool arg_0x1aeedeb0);
#line 191
static   void HplMsp430Usart1P$Usart$disableIntr(void);
#line 60
static   void HplMsp430Usart1P$Usart$setUtctl(msp430_utctl_t arg_0x1aed1d78);
#line 90
static   void HplMsp430Usart1P$Usart$setUmctl(uint8_t arg_0x1aeed6a0);
#line 194
static   void HplMsp430Usart1P$Usart$enableIntr(void);
#line 219
static   void HplMsp430Usart1P$Usart$clrIntr(void);
#line 80
static   void HplMsp430Usart1P$Usart$setUbr(uint16_t arg_0x1aed0de0);
#line 236
static   void HplMsp430Usart1P$Usart$tx(uint8_t arg_0x1aee3b70);
#line 55
static   msp430_uctl_t HplMsp430Usart1P$Usart$getUctl(void);
#line 128
static   void HplMsp430Usart1P$Usart$disableUart(void);
#line 186
static   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_config_t *arg_0x1aee6010);
#line 158
static   void HplMsp430Usart1P$Usart$disableSpi(void);
# 73 "/opt/tinyos-2.0/tos/interfaces/AsyncStdControl.nc"
static   error_t HplMsp430Usart1P$AsyncStdControl$start(void);








static   error_t HplMsp430Usart1P$AsyncStdControl$stop(void);
# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
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
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t LedsP$Init$init(void);
# 35 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b20bab8, 
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1aec1d70);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b20bab8);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t arg_0x1aec1d70);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);
# 43 "/opt/tinyos-2.0/tos/interfaces/ResourceQueue.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(
# 54 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26cdb0);
# 55 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(
# 59 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26bef8);
# 49 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(
# 59 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26bef8);
# 56 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$release(void);
# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(
# 53 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26c4a8);
# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(
# 53 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26c4a8);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(
# 53 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26c4a8);
# 80 "/opt/tinyos-2.0/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
# 52 "/opt/tinyos-2.0/tos/lib/power/PowerDownCleanup.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void);
# 46 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$granted(void);
#line 81
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$immediateRequested(void);
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void TelosSerialP$Resource$granted(void);
# 73 "/opt/tinyos-2.0/tos/interfaces/StdControl.nc"
static  error_t TelosSerialP$StdControl$start(void);








static  error_t TelosSerialP$StdControl$stop(void);
# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *arg_0x1ad8acc8, uint8_t arg_0x1ad8ae50);
#line 15
static   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);







static   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *arg_0x1ad8a4e8, uint8_t arg_0x1ad8a670);
# 42 "/opt/tinyos-2.0/tos/system/ActiveMessageAddressC.nc"
static   am_addr_t ActiveMessageAddressC$amAddress(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t PlatformP$Msp430ClockInit$init(void);
#line 51
static  error_t PlatformP$MoteInit$init(void);
#line 51
static  error_t PlatformP$LedsInit$init(void);
# 10 "/opt/tinyos-2.0/tos/platforms/telosa/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void);
# 6 "/opt/tinyos-2.0/tos/platforms/telosb/MotePlatformC.nc"
static __inline void MotePlatformC$uwait(uint16_t u);




static __inline void MotePlatformC$TOSH_wait(void);




static void MotePlatformC$TOSH_FLASH_M25P_DP_bit(bool set);










static inline void MotePlatformC$TOSH_FLASH_M25P_DP(void);
#line 59
static inline  error_t MotePlatformC$Init$init(void);
# 30 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockInit.nc"
static  void Msp430ClockP$Msp430ClockInit$initTimerB(void);
#line 29
static  void Msp430ClockP$Msp430ClockInit$initTimerA(void);
#line 28
static  void Msp430ClockP$Msp430ClockInit$initClocks(void);
# 36 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
 static volatile uint8_t Msp430ClockP$IE1 __asm ("0x0000");
 static volatile uint16_t Msp430ClockP$TA0CTL __asm ("0x0160");
 static volatile uint16_t Msp430ClockP$TA0IV __asm ("0x012E");
 static volatile uint16_t Msp430ClockP$TBCTL __asm ("0x0180");
 static volatile uint16_t Msp430ClockP$TBIV __asm ("0x011E");

enum Msp430ClockP$__nesc_unnamed4289 {

  Msp430ClockP$ACLK_CALIB_PERIOD = 8, 
  Msp430ClockP$ACLK_KHZ = 32, 
  Msp430ClockP$TARGET_DCO_KHZ = 4096, 
  Msp430ClockP$TARGET_DCO_DELTA = Msp430ClockP$TARGET_DCO_KHZ / Msp430ClockP$ACLK_KHZ * Msp430ClockP$ACLK_CALIB_PERIOD
};

static inline  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void);
#line 71
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void);
#line 86
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void);
#line 101
static inline   void Msp430ClockP$Msp430ClockInit$default$initClocks(void);




static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerA(void);




static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerB(void);





static inline void Msp430ClockP$startTimerA(void);
#line 129
static inline void Msp430ClockP$startTimerB(void);
#line 141
static void Msp430ClockP$set_dco_calib(int calib);





static inline uint16_t Msp430ClockP$test_calib_busywait_delta(int calib);
#line 170
static inline void Msp430ClockP$busyCalibrateDco(void);
#line 203
static inline  error_t Msp430ClockP$Init$init(void);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(
# 40 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1aa55710);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow(void);
# 115 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);








static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n);
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(
# 40 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x1aa55710);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow(void);
# 115 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);








static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n);
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x1aa269e0);
# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void);
# 44 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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
# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void Msp430TimerCommonP$VectorTimerB1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA0$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerB0$fired(void);
# 11 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
void sig_TIMERA0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(12))) ;
void sig_TIMERA1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(10))) ;
void sig_TIMERB0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(26))) ;
void sig_TIMERB1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(24))) ;
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t RealMainP$SoftwareInit$init(void);
# 49 "/opt/tinyos-2.0/tos/interfaces/Boot.nc"
static  void RealMainP$Boot$booted(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
static  error_t RealMainP$PlatformInit$init(void);
# 46 "/opt/tinyos-2.0/tos/interfaces/Scheduler.nc"
static  void RealMainP$Scheduler$init(void);
#line 61
static  void RealMainP$Scheduler$taskLoop(void);
#line 54
static  bool RealMainP$Scheduler$runNextTask(void);
# 52 "/opt/tinyos-2.0/tos/system/RealMainP.nc"
int main(void)   ;
# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(
# 45 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x1a890dd8);
# 59 "/opt/tinyos-2.0/tos/interfaces/McuSleep.nc"
static   void SchedulerBasicP$McuSleep$sleep(void);
# 50 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP$__nesc_unnamed4290 {

  SchedulerBasicP$NUM_TASKS = 11U, 
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
# 54 "/opt/tinyos-2.0/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void);
# 51 "/opt/tinyos-2.0/tos/chips/msp430/McuSleepC.nc"
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
#line 101
static inline void McuSleepC$computePowerState(void);




static inline   void McuSleepC$McuSleep$sleep(void);
#line 121
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 74 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
 uint8_t StateImplP$state[5U];

enum StateImplP$__nesc_unnamed4291 {
  StateImplP$S_IDLE = 0
};


static inline  error_t StateImplP$Init$init(void);
#line 96
static   error_t StateImplP$State$requestState(uint8_t id, uint8_t reqState);
#line 111
static inline   void StateImplP$State$forceState(uint8_t id, uint8_t reqState);






static inline   void StateImplP$State$toIdle(uint8_t id);







static inline   bool StateImplP$State$isIdle(uint8_t id);






static inline   uint8_t StateImplP$State$getState(uint8_t id);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TestStateP$TearDownOneTime$done(void);
# 12 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
static  void TestStateP$TestForce$done(void);
#line 12
static  void TestStateP$TestRequest$done(void);
#line 12
static  void TestStateP$TestToIdle$done(void);
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   uint8_t TestStateP$State$getState(void);
#line 56
static   void TestStateP$State$toIdle(void);




static   bool TestStateP$State$isIdle(void);
#line 45
static   error_t TestStateP$State$requestState(uint8_t arg_0x1a926708);





static   void TestStateP$State$forceState(uint8_t arg_0x1a926c80);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TestStateP$SetUpOneTime$done(void);
# 26 "TestStateP.nc"
enum TestStateP$__nesc_unnamed4292 {
  TestStateP$S_IDLE, 
  TestStateP$S_STATE1, 
  TestStateP$S_STATE2, 
  TestStateP$S_STATE3
};


static inline  void TestStateP$SetUpOneTime$run(void);





static inline  void TestStateP$TearDownOneTime$run(void);





static inline  void TestStateP$TestForce$run(void);










static inline  void TestStateP$TestRequest$run(void);
#line 70
static inline  void TestStateP$TestToIdle$run(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t TUnitP$waitForSendDone$postTask(void);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDownOneTime$run(void);
# 58 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static   am_addr_t TUnitP$amAddress(void);
# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   bool TUnitP$SendState$isIdle(void);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$TearDown$run(void);
# 10 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
static  void TUnitP$TestCase$run(
# 42 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
uint8_t arg_0x1aba6be0);
# 17 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
static   void TUnitP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1abb6b50, char *arg_0x1abb6ce8, uint32_t arg_0x1abb6e78, uint32_t arg_0x1abb5030);
#line 11
static   void TUnitP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1abb8088, char *arg_0x1abb8220, uint32_t arg_0x1abb83b0, uint32_t arg_0x1abb8538);



static   void TUnitP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1abb61e8, char *arg_0x1abb6380, uint32_t arg_0x1abb6510, uint32_t arg_0x1abb6698);



static   void TUnitP$TUnitProcessing$testFailed(uint8_t arg_0x1abb54e0, char *arg_0x1abb5678);
#line 13
static   void TUnitP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1abb89f0, char *arg_0x1abb8b88, uint32_t arg_0x1abb8d10);
#line 9
static   void TUnitP$TUnitProcessing$testSuccess(uint8_t arg_0x1abb9bd8);
#line 22
static  void TUnitP$TUnitProcessing$allDone(void);

static  void TUnitP$TUnitProcessing$pong(void);
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   uint8_t TUnitP$TestState$getState(void);
#line 56
static   void TUnitP$TestState$toIdle(void);
#line 45
static   error_t TUnitP$TestState$requestState(uint8_t arg_0x1a926708);





static   void TUnitP$TestState$forceState(uint8_t arg_0x1a926c80);
#line 66
static   uint8_t TUnitP$TUnitState$getState(void);
#line 61
static   bool TUnitP$TUnitState$isIdle(void);
#line 51
static   void TUnitP$TUnitState$forceState(uint8_t arg_0x1a926c80);
# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
static  void TUnitP$SetUp$run(void);
#line 8
static  void TUnitP$SetUpOneTime$run(void);
# 16 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/StatsQuery.nc"
static  bool TUnitP$StatsQuery$isIdle(void);
# 92 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
enum TUnitP$__nesc_unnamed4293 {
#line 92
  TUnitP$waitForSendDone = 0U
};
#line 92
typedef int TUnitP$__nesc_sillytask_waitForSendDone[TUnitP$waitForSendDone];
#line 65
uint8_t TUnitP$currentTest;




enum TUnitP$__nesc_unnamed4294 {
  TUnitP$S_NOT_BOOTED, 
  TUnitP$S_READY, 
  TUnitP$S_RUNNING
};




enum TUnitP$__nesc_unnamed4295 {
  TUnitP$S_IDLE, 
  TUnitP$S_SETUP_ONETIME, 

  TUnitP$S_SETUP, 
  TUnitP$S_RUN, 
  TUnitP$S_TEARDOWN, 

  TUnitP$S_TEARDOWN_ONETIME
};





static void TUnitP$setUpOneTimeDone(void);
static inline void TUnitP$setUpDone(void);
static void TUnitP$runDone(void);
static inline void TUnitP$tearDownDone(void);
static inline void TUnitP$tearDownOneTimeDone(void);
static void TUnitP$attemptTest(void);





static inline  void TUnitP$SerialSplitControl$startDone(error_t error);
#line 121
static inline  void TUnitP$SerialSplitControl$stopDone(error_t error);



static inline  void TUnitP$TUnitProcessing$run(void);









static inline  void TUnitP$TUnitProcessing$ping(void);




static inline  void TUnitP$TestCase$done(uint8_t testId);




void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual) __attribute((noinline))   ;





void assertNotEqualsFailed(char *failMsg, uint32_t actual) __attribute((noinline))   ;





void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual) __attribute((noinline))   ;





void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual) __attribute((noinline))   ;





void assertSuccess(void) __attribute((noinline))   ;






void assertFail(char *failMsg) __attribute((noinline))   ;






static inline  void TUnitP$SetUpOneTime$done(void);
#line 195
static inline  void TUnitP$TearDownOneTime$done(void);
#line 210
static void TUnitP$setUpOneTimeDone(void);
#line 222
static inline void TUnitP$setUpDone(void);







static void TUnitP$runDone(void);







static inline void TUnitP$tearDownDone(void);







static inline void TUnitP$tearDownOneTimeDone(void);






static void TUnitP$attemptTest(void);
#line 269
static inline  void TUnitP$waitForSendDone$runTask(void);
#line 286
static inline   void TUnitP$SetUp$default$run(void);



static inline   void TUnitP$TestCase$default$run(uint8_t testId);



static inline   void TUnitP$TearDown$default$run(void);
#line 306
static inline   bool TUnitP$StatsQuery$default$isIdle(void);
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  error_t Link_TUnitProcessingP$SerialEventSend$send(am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8);
#line 125
static  void *Link_TUnitProcessingP$SerialEventSend$getPayload(message_t *arg_0x1ac52df0);
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
static   uint8_t Link_TUnitProcessingP$SerialState$getState(void);
#line 51
static   void Link_TUnitProcessingP$SerialState$forceState(uint8_t arg_0x1a926c80);




static   void Link_TUnitProcessingP$SendState$toIdle(void);




static   bool Link_TUnitProcessingP$SendState$isIdle(void);
#line 51
static   void Link_TUnitProcessingP$SendState$forceState(uint8_t arg_0x1a926c80);
# 27 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
static  void Link_TUnitProcessingP$TUnitProcessing$run(void);

static  void Link_TUnitProcessingP$TUnitProcessing$ping(void);
# 79 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
static  error_t Link_TUnitProcessingP$SerialSplitControl$start(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t Link_TUnitProcessingP$sendEventMsg$postTask(void);
#line 56
static   error_t Link_TUnitProcessingP$allDone$postTask(void);
# 56 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
enum Link_TUnitProcessingP$__nesc_unnamed4296 {
#line 56
  Link_TUnitProcessingP$sendEventMsg = 1U
};
#line 56
typedef int Link_TUnitProcessingP$__nesc_sillytask_sendEventMsg[Link_TUnitProcessingP$sendEventMsg];
enum Link_TUnitProcessingP$__nesc_unnamed4297 {
#line 57
  Link_TUnitProcessingP$allDone = 2U
};
#line 57
typedef int Link_TUnitProcessingP$__nesc_sillytask_allDone[Link_TUnitProcessingP$allDone];
#line 26
message_t Link_TUnitProcessingP$eventMsg[5];


uint8_t Link_TUnitProcessingP$writingEventMsg;


uint8_t Link_TUnitProcessingP$sendingEventMsg;




enum Link_TUnitProcessingP$__nesc_unnamed4298 {
  Link_TUnitProcessingP$S_OFF, 
  Link_TUnitProcessingP$S_ON
};




enum Link_TUnitProcessingP$__nesc_unnamed4299 {
  Link_TUnitProcessingP$S_IDLE, 
  Link_TUnitProcessingP$S_BUSY
};

enum Link_TUnitProcessingP$__nesc_unnamed4300 {
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
#line 170
static error_t Link_TUnitProcessingP$insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual);
#line 232
static void Link_TUnitProcessingP$attemptEventSend(void);
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x1ac521d8, error_t arg_0x1ac52358);
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8);
#line 114
static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x1ace7ab8);
# 92 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x1acc4010, am_addr_t arg_0x1acc4198);
#line 151
static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x1acc3e58, am_id_t arg_0x1acc1010);
# 45 "/opt/tinyos-2.0/tos/system/AMQueueEntryP.nc"
static inline  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err);







static inline  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m);
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(
# 40 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad0bbf0, 
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8);
#line 125
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(
# 40 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
am_id_t arg_0x1ad0bbf0, 
# 125 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
message_t *arg_0x1ac52df0);
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(
# 38 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
uint8_t arg_0x1ad0b2c8, 
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 67 "/opt/tinyos-2.0/tos/interfaces/Packet.nc"
static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x1acb2e88);
#line 83
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x1acb1530, uint8_t arg_0x1acb16b0);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask(void);
# 67 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x1acc5460);
#line 136
static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x1acc38e0);
# 143 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4301 {
#line 143
  AMQueueImplP$0$errorTask = 3U
};
#line 143
typedef int /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_sillytask_errorTask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask];
#line 49
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4302 {
  AMQueueImplP$0$QUEUE_EMPTY = 255
};



#line 53
typedef struct /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4303 {
  message_t *msg;
} /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t;

uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY;
/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[1];


static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);

static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket(void);
#line 91
static inline  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len);
#line 143
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);







static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);
#line 166
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(am_id_t id, message_t *msg, error_t err);
#line 180
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m);



static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err);
# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8);
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(
# 36 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad34ae0, 
# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
message_t *arg_0x1ac521d8, error_t arg_0x1ac52358);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(
# 37 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x1ad334a0, 
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 49 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline serial_header_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(message_t *msg);



static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(am_id_t id, am_addr_t dest, 
message_t *msg, 
uint8_t len);
#line 77
static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(am_id_t id, message_t *m);



static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *msg, error_t result);







static inline   message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(uint8_t id, message_t *msg, void *payload, uint8_t len);
#line 102
static inline  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len);








static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len);







static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t *len);










static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg);









static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setSource(message_t *amsg, am_addr_t addr);








static inline  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type);
# 88 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
static  void SerialP$SplitControl$startDone(error_t arg_0x1abc4b40);
#line 110
static  void SerialP$SplitControl$stopDone(error_t arg_0x1abc3688);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$stopDoneTask$postTask(void);
# 73 "/opt/tinyos-2.0/tos/interfaces/StdControl.nc"
static  error_t SerialP$SerialControl$start(void);








static  error_t SerialP$SerialControl$stop(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$RunTx$postTask(void);
# 38 "/opt/tinyos-2.0/tos/interfaces/SerialFlush.nc"
static  void SerialP$SerialFlush$flush(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$startDoneTask$postTask(void);
# 45 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
static   error_t SerialP$SerialFrameComm$putDelimiter(void);
#line 68
static   void SerialP$SerialFrameComm$resetReceive(void);
#line 54
static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x1adabd50);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$defaultSerialFlushTask$postTask(void);
# 70 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
static   uint8_t SerialP$SendBytePacket$nextByte(void);









static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x1ad97ae0);
# 51 "/opt/tinyos-2.0/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t SerialP$ReceiveBytePacket$startPacket(void);






static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x1ad92188);










static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x1ad92748);
# 189 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
enum SerialP$__nesc_unnamed4304 {
#line 189
  SerialP$RunTx = 4U
};
#line 189
typedef int SerialP$__nesc_sillytask_RunTx[SerialP$RunTx];
#line 320
enum SerialP$__nesc_unnamed4305 {
#line 320
  SerialP$startDoneTask = 5U
};
#line 320
typedef int SerialP$__nesc_sillytask_startDoneTask[SerialP$startDoneTask];





enum SerialP$__nesc_unnamed4306 {
#line 326
  SerialP$stopDoneTask = 6U
};
#line 326
typedef int SerialP$__nesc_sillytask_stopDoneTask[SerialP$stopDoneTask];








enum SerialP$__nesc_unnamed4307 {
#line 335
  SerialP$defaultSerialFlushTask = 7U
};
#line 335
typedef int SerialP$__nesc_sillytask_defaultSerialFlushTask[SerialP$defaultSerialFlushTask];
#line 79
enum SerialP$__nesc_unnamed4308 {
  SerialP$RX_DATA_BUFFER_SIZE = 2, 
  SerialP$TX_DATA_BUFFER_SIZE = 4, 
  SerialP$SERIAL_MTU = 255, 
  SerialP$SERIAL_VERSION = 1, 
  SerialP$ACK_QUEUE_SIZE = 5
};

enum SerialP$__nesc_unnamed4309 {
  SerialP$RXSTATE_NOSYNC, 
  SerialP$RXSTATE_PROTO, 
  SerialP$RXSTATE_TOKEN, 
  SerialP$RXSTATE_INFO, 
  SerialP$RXSTATE_INACTIVE
};

enum SerialP$__nesc_unnamed4310 {
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
typedef enum SerialP$__nesc_unnamed4311 {
  SerialP$BUFFER_AVAILABLE, 
  SerialP$BUFFER_FILLING, 
  SerialP$BUFFER_COMPLETE
} SerialP$tx_data_buffer_states_t;

enum SerialP$__nesc_unnamed4312 {
  SerialP$TX_ACK_INDEX = 0, 
  SerialP$TX_DATA_INDEX = 1, 
  SerialP$TX_BUFFER_COUNT = 2
};






#line 122
typedef struct SerialP$__nesc_unnamed4313 {
  uint8_t writePtr;
  uint8_t readPtr;
  uint8_t buf[SerialP$RX_DATA_BUFFER_SIZE + 1];
} SerialP$rx_buf_t;




#line 128
typedef struct SerialP$__nesc_unnamed4314 {
  uint8_t state;
  uint8_t buf;
} SerialP$tx_buf_t;





#line 133
typedef struct SerialP$__nesc_unnamed4315 {
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
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$postTask(void);
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(
# 40 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2d4e8, 
# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask(void);
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(
# 39 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae10d88, 
# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0);
# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68, 
# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1ad8acc8, uint8_t arg_0x1ad8ae50);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68);
# 23 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x1ae2de68, 
# 23 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x1ad8a4e8, uint8_t arg_0x1ad8a670);
# 60 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$completeSend(void);
#line 51
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x1ad98ae0);
# 144 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4316 {
#line 144
  SerialDispatcherP$0$signalSendDone = 8U
};
#line 144
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_signalSendDone[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone];
#line 261
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4317 {
#line 261
  SerialDispatcherP$0$receiveTask = 9U
};
#line 261
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_receiveTask[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask];
#line 55
#line 51
typedef enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4318 {
  SerialDispatcherP$0$SEND_STATE_IDLE = 0, 
  SerialDispatcherP$0$SEND_STATE_BEGIN = 1, 
  SerialDispatcherP$0$SEND_STATE_DATA = 2
} /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$send_state_t;

enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4319 {
  SerialDispatcherP$0$RECV_STATE_IDLE = 0, 
  SerialDispatcherP$0$RECV_STATE_BEGIN = 1, 
  SerialDispatcherP$0$RECV_STATE_DATA = 2
};






#line 63
typedef struct /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4320 {
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
#line 144
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
#line 164
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);
#line 180
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error);




static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void);



static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void);




static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);
#line 230
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b);
#line 261
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
#line 282
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result);
#line 341
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen);




static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len);


static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error);
# 48 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x1ae648c0, uint16_t arg_0x1ae64a48);
# 83 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x1ada8010);





static   void HdlcTranslateC$SerialFrameComm$putDone(void);
#line 74
static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void);
# 47 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
#line 44
typedef struct HdlcTranslateC$__nesc_unnamed4321 {
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
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartConfigure.nc"
static   msp430_uart_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(
# 49 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed7778);
# 191 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr(void);


static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr(void);
#line 219
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$clrIntr(void);
#line 236
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(uint8_t arg_0x1aee3b70);
#line 128
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart(void);
#line 186
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(msp430_uart_config_t *arg_0x1aee6010);
# 79 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(uint8_t arg_0x1ae620b8);
#line 99
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(uint8_t *arg_0x1ae62d60, uint16_t arg_0x1ae62ee8, error_t arg_0x1ae61088);
#line 57
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(uint8_t *arg_0x1ae63068, uint16_t arg_0x1ae631f0, error_t arg_0x1ae63370);
# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(
# 48 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed8e38);
# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(
# 48 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aed8e38);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(
# 42 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
uint8_t arg_0x1aedb968);
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





static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(uint8_t id);



static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(uint8_t id);




static inline  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(uint8_t id);
#line 109
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartControl$setModeDuplex(uint8_t id);
#line 140
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t data);
#line 154
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *buf, uint16_t len);
#line 166
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void);
#line 199
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void);



static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(uint8_t id);
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(uint8_t id);
static inline    msp430_uart_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(uint8_t id);



static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(uint8_t id);
# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart1P$UCLK$selectIOFunc(void);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void HplMsp430Usart1P$Interrupts$rxDone(uint8_t arg_0x1aec1d70);
#line 49
static   void HplMsp430Usart1P$Interrupts$txDone(void);
# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart1P$URXD$selectIOFunc(void);
#line 78
static   void HplMsp430Usart1P$URXD$selectModuleFunc(void);






static   void HplMsp430Usart1P$UTXD$selectIOFunc(void);
#line 78
static   void HplMsp430Usart1P$UTXD$selectModuleFunc(void);






static   void HplMsp430Usart1P$SOMI$selectIOFunc(void);
#line 85
static   void HplMsp430Usart1P$SIMO$selectIOFunc(void);
# 87 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
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






static inline   void HplMsp430Usart1P$Usart$setUctl(msp430_uctl_t control);



static inline   msp430_uctl_t HplMsp430Usart1P$Usart$getUctl(void);



static inline   void HplMsp430Usart1P$Usart$setUtctl(msp430_utctl_t control);



static inline   msp430_utctl_t HplMsp430Usart1P$Usart$getUtctl(void);



static inline   void HplMsp430Usart1P$Usart$setUrctl(msp430_urctl_t control);



static inline   msp430_urctl_t HplMsp430Usart1P$Usart$getUrctl(void);



static inline   void HplMsp430Usart1P$Usart$setUbr(uint16_t control);










static inline   void HplMsp430Usart1P$Usart$setUmctl(uint8_t control);







static inline   void HplMsp430Usart1P$Usart$resetUsart(bool reset);
#line 203
static inline   void HplMsp430Usart1P$Usart$enableUart(void);







static   void HplMsp430Usart1P$Usart$disableUart(void);
#line 251
static   void HplMsp430Usart1P$Usart$disableSpi(void);
#line 295
static inline void HplMsp430Usart1P$configUart(msp430_uart_config_t *config);
#line 358
static inline   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_config_t *config);
#line 406
static inline   void HplMsp430Usart1P$Usart$clrIntr(void);
#line 418
static inline   void HplMsp430Usart1P$Usart$disableIntr(void);
#line 436
static inline   void HplMsp430Usart1P$Usart$enableIntr(void);






static inline   void HplMsp430Usart1P$Usart$tx(uint8_t data);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
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
# 71 "/opt/tinyos-2.0/tos/lib/timer/Counter.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void);
# 53 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 35 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
static   void LedsP$Led0$makeOutput(void);
#line 29
static   void LedsP$Led0$set(void);





static   void LedsP$Led1$makeOutput(void);
#line 29
static   void LedsP$Led1$set(void);





static   void LedsP$Led2$makeOutput(void);
#line 29
static   void LedsP$Led2$set(void);
# 45 "/opt/tinyos-2.0/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void);
# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void);
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
# 80 "/opt/tinyos-2.0/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(void);
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b20bab8, 
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x1aec1d70);
#line 49
static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(
# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x1b20bab8);









static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);




static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data);









static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id);
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data);
# 39 "/opt/tinyos-2.0/tos/system/FcfsResourceQueueC.nc"
enum /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$__nesc_unnamed4322 {
#line 39
  FcfsResourceQueueC$0$NO_ENTRY = 0xFF
};
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[1U];
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
uint8_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

static inline  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);




static inline   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);







static inline   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 51 "/opt/tinyos-2.0/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(
# 54 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26cdb0);
# 55 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(
# 59 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26bef8);
# 49 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(
# 59 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26bef8);
# 43 "/opt/tinyos-2.0/tos/interfaces/ResourceQueue.nc"
static   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue(void);
# 46 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$granted(void);
#line 81
static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$immediateRequested(void);
# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(
# 53 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
uint8_t arg_0x1b26c4a8);
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask(void);
# 73 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4323 {
#line 73
  ArbiterP$0$grantedTask = 10U
};
#line 73
typedef int /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_sillytask_grantedTask[/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask];
#line 66
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4324 {
#line 66
  ArbiterP$0$RES_CONTROLLED, ArbiterP$0$RES_GRANTING, ArbiterP$0$RES_IMM_GRANTING, ArbiterP$0$RES_BUSY
};
#line 67
enum /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4325 {
#line 67
  ArbiterP$0$CONTROLLER_ID = 1U
};
uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
 uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$CONTROLLER_ID;
 uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
#line 88
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id);
#line 106
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id);
#line 125
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$release(void);
#line 145
static inline   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);








static inline   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);
#line 172
static inline  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
#line 184
static inline   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id);



static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id);









static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id);

static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id);
# 52 "/opt/tinyos-2.0/tos/lib/power/PowerDownCleanup.nc"
static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup(void);
# 56 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$release(void);
# 73 "/opt/tinyos-2.0/tos/interfaces/AsyncStdControl.nc"
static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start(void);








static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop(void);
# 64 "/opt/tinyos-2.0/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$immediateRequested(void);




static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$granted(void);




static inline    void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void);
# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
static   error_t TelosSerialP$Resource$release(void);
#line 87
static   error_t TelosSerialP$Resource$immediateRequest(void);
# 8 "/opt/tinyos-2.0/tos/platforms/telosa/TelosSerialP.nc"
msp430_uart_config_t TelosSerialP$msp430_uart_telos_config = { .ubr = UBR_1MHZ_115200, .umctl = UMCTL_1MHZ_115200, .ssel = 0x02, .pena = 0, .pev = 0, .spb = 0, .clen = 1, .listen = 0, .mm = 0, .ckpl = 0, .urxse = 0, .urxeie = 1, .urxwie = 0 };

static inline  error_t TelosSerialP$StdControl$start(void);


static inline  error_t TelosSerialP$StdControl$stop(void);



static inline  void TelosSerialP$Resource$granted(void);

static inline   msp430_uart_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void);
# 40 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen);
# 46 "/opt/tinyos-2.0/tos/system/ActiveMessageAddressC.nc"
am_addr_t ActiveMessageAddressC$addr = TOS_AM_ADDRESS;





static inline   am_addr_t ActiveMessageAddressC$amAddress(void);
# 185 "/opt/tinyos-2.0/tos/chips/msp430/msp430hardware.h"
static inline void __nesc_enable_interrupt(void )
{
   __asm volatile ("eint");}

# 185 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
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
# 126 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow();
}





static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n)
{
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(uint8_t arg_0x1aa55710){
#line 28
  switch (arg_0x1aa55710) {
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
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(arg_0x1aa55710);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 115 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(0);
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired();
#line 28
}
#line 28
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void)
{
  return * (volatile uint16_t *)370U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void)
{
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired();
#line 34
}
#line 34
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void)
{
  return * (volatile uint16_t *)372U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void)
{
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired();
#line 34
}
#line 34
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void)
{
  return * (volatile uint16_t *)374U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void)
{
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired();
#line 34
}
#line 34
# 120 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)302U;

#line 123
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(n >> 1);
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired();
#line 28
}
#line 28
# 115 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(0);
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired();
#line 28
}
#line 28
# 185 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 199 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow(void)
#line 199
{
}

# 71 "/opt/tinyos-2.0/tos/lib/timer/Counter.nc"
inline static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void){
#line 71
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Counter$overflow();
#line 71
}
#line 71
# 53 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void)
{
  /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow();
}

# 37 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Timer.nc"
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
# 126 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow();
}

# 181 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired(void)
{
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void)
{
  return * (volatile uint16_t *)402U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void)
{
  return * (volatile uint16_t *)404U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void)
{
  return * (volatile uint16_t *)406U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void)
{
  return * (volatile uint16_t *)408U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void)
{
  return * (volatile uint16_t *)410U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void)
{
  return * (volatile uint16_t *)412U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(uint16_t x)
#line 47
{
#line 47
  union  {
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

# 34 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired();
#line 34
}
#line 34
# 139 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void)
{
  return * (volatile uint16_t *)414U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t n)
{
}

# 75 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x1aa269e0){
#line 75
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(arg_0x1aa269e0);
#line 75
}
#line 75
# 47 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(uint16_t x)
#line 47
{
#line 47
  union __nesc_unnamed4326 {
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

# 120 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)286U;

#line 123
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(n >> 1);
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired();
#line 28
}
#line 28
# 113 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
static inline  void SchedulerBasicP$Scheduler$init(void)
{
  /* atomic removed: atomic calls only */
  {
    memset((void *)SchedulerBasicP$m_next, SchedulerBasicP$NO_TASK, sizeof SchedulerBasicP$m_next);
    SchedulerBasicP$m_head = SchedulerBasicP$NO_TASK;
    SchedulerBasicP$m_tail = SchedulerBasicP$NO_TASK;
  }
}

# 46 "/opt/tinyos-2.0/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$init(void){
#line 46
  SchedulerBasicP$Scheduler$init();
#line 46
}
#line 46
# 45 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 6;
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$set();
#line 34
}
#line 34
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set();
}

# 29 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$set(void){
#line 29
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set();
#line 29
}
#line 29
# 45 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 5;
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$set();
#line 34
}
#line 34
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set();
}

# 29 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$set(void){
#line 29
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set();
#line 29
}
#line 29
# 45 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)49U |= 0x01 << 4;
}

# 34 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$set();
#line 34
}
#line 34
# 37 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set();
}

# 29 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$set(void){
#line 29
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set();
#line 29
}
#line 29
# 52 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 6;
}

# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P56*/HplMsp430GeneralIOP$38$IO$makeOutput();
#line 71
}
#line 71
# 43 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput();
}

# 35 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$makeOutput(void){
#line 35
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 5;
}

# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P55*/HplMsp430GeneralIOP$37$IO$makeOutput();
#line 71
}
#line 71
# 43 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput();
}

# 35 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$makeOutput(void){
#line 35
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)50U |= 0x01 << 4;
}

# 71 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P54*/HplMsp430GeneralIOP$36$IO$makeOutput();
#line 71
}
#line 71
# 43 "/opt/tinyos-2.0/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput();
}

# 35 "/opt/tinyos-2.0/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$makeOutput(void){
#line 35
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput();
#line 35
}
#line 35
# 45 "/opt/tinyos-2.0/tos/system/LedsP.nc"
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

# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
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
# 86 "/opt/tinyos-2.0/tos/platforms/telosb/hardware.h"
static inline void TOSH_CLR_FLASH_HOLD_PIN(void)
#line 86
{
#line 86
   static volatile uint8_t r __asm ("0x001D");

#line 86
  r &= ~(1 << 7);
}

#line 34
static inline void TOSH_MAKE_UCLK0_INPUT(void)
#line 34
{
#line 34
   static volatile uint8_t r __asm ("0x001A");

#line 34
  r &= ~(1 << 3);
}

#line 33
static inline void TOSH_MAKE_SIMO0_INPUT(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x001A");

#line 33
  r &= ~(1 << 1);
}

#line 33
static inline void TOSH_SET_SIMO0_PIN(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x0019");

#line 33
  r |= 1 << 1;
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

# 11 "/opt/tinyos-2.0/tos/platforms/telosb/MotePlatformC.nc"
static __inline void MotePlatformC$TOSH_wait(void)
#line 11
{
   __asm volatile ("nop"); __asm volatile ("nop");}

# 86 "/opt/tinyos-2.0/tos/platforms/telosb/hardware.h"
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

# 27 "/opt/tinyos-2.0/tos/platforms/telosb/MotePlatformC.nc"
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

  TOSH_SET_SIMO0_PIN();
  TOSH_MAKE_SIMO0_INPUT();
  TOSH_MAKE_UCLK0_INPUT();
  TOSH_CLR_FLASH_HOLD_PIN();
}

#line 6
static __inline void MotePlatformC$uwait(uint16_t u)
#line 6
{
  uint16_t t0 = TA0R;

#line 8
  while (TA0R - t0 <= u) ;
}

#line 59
static inline  error_t MotePlatformC$Init$init(void)
#line 59
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

# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
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
# 129 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline void Msp430ClockP$startTimerB(void)
{

  Msp430ClockP$TBCTL = 0x0020 | (Msp430ClockP$TBCTL & ~(0x0020 | 0x0010));
}

#line 117
static inline void Msp430ClockP$startTimerA(void)
{

  Msp430ClockP$TA0CTL = 0x0020 | (Msp430ClockP$TA0CTL & ~(0x0020 | 0x0010));
}

#line 86
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerB(void)
{
  TBR = 0;









  Msp430ClockP$TBCTL = 0x0100 | 0x0002;
}











static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerB(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitTimerB();
}

# 30 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerB(void){
#line 30
  Msp430ClockP$Msp430ClockInit$default$initTimerB();
#line 30
}
#line 30
# 71 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitTimerA(void)
{
  TA0R = 0;









  Msp430ClockP$TA0CTL = 0x0200 | 0x0002;
}

#line 106
static inline   void Msp430ClockP$Msp430ClockInit$default$initTimerA(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitTimerA();
}

# 29 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerA(void){
#line 29
  Msp430ClockP$Msp430ClockInit$default$initTimerA();
#line 29
}
#line 29
# 50 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
static inline  void Msp430ClockP$Msp430ClockInit$defaultInitClocks(void)
{





  BCSCTL1 = 0x80 | (BCSCTL1 & ((0x04 | 0x02) | 0x01));







  BCSCTL2 = 0x04;


  Msp430ClockP$IE1 &= ~(1 << 1);
}

#line 101
static inline   void Msp430ClockP$Msp430ClockInit$default$initClocks(void)
{
  Msp430ClockP$Msp430ClockInit$defaultInitClocks();
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initClocks(void){
#line 28
  Msp430ClockP$Msp430ClockInit$default$initClocks();
#line 28
}
#line 28
# 147 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
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



  Msp430ClockP$TA0CTL = 0x0200 | 0x0020;
  Msp430ClockP$TBCTL = 0x0100 | 0x0020;
  BCSCTL1 = 0x80 | 0x04;
  BCSCTL2 = 0;
  TBCCTL0 = 0x4000;






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

static inline  error_t Msp430ClockP$Init$init(void)
{

  Msp430ClockP$TA0CTL = 0x0004;
  Msp430ClockP$TA0IV = 0;
  Msp430ClockP$TBCTL = 0x0004;
  Msp430ClockP$TBIV = 0;
  /* atomic removed: atomic calls only */

  {
    Msp430ClockP$busyCalibrateDco();
    Msp430ClockP$Msp430ClockInit$initClocks();
    Msp430ClockP$Msp430ClockInit$initTimerA();
    Msp430ClockP$Msp430ClockInit$initTimerB();
    Msp430ClockP$startTimerA();
    Msp430ClockP$startTimerB();
  }

  return SUCCESS;
}

# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
inline static  error_t PlatformP$Msp430ClockInit$init(void){
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
# 10 "/opt/tinyos-2.0/tos/platforms/telosa/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void)
#line 10
{
  PlatformP$Msp430ClockInit$init();
  PlatformP$MoteInit$init();
  PlatformP$LedsInit$init();
  return SUCCESS;
}

# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
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
# 33 "/opt/tinyos-2.0/tos/platforms/telosb/hardware.h"
static inline void TOSH_CLR_SIMO0_PIN(void)
#line 33
{
#line 33
   static volatile uint8_t r __asm ("0x0019");

#line 33
  r &= ~(1 << 1);
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

# 54 "/opt/tinyos-2.0/tos/interfaces/Scheduler.nc"
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
# 17 "/opt/tinyos-2.0/tos/platforms/telosa/TelosSerialP.nc"
static inline  void TelosSerialP$Resource$granted(void)
#line 17
{
}

# 209 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(uint8_t id)
#line 209
{
}

# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
inline static  void /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(uint8_t arg_0x1aedb968){
#line 92
  switch (arg_0x1aedb968) {
#line 92
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 92
      TelosSerialP$Resource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$default$granted(arg_0x1aedb968);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 91 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline  void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(uint8_t id)
#line 91
{
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$granted(id);
}

# 184 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id)
#line 184
{
}

# 92 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
inline static  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(uint8_t arg_0x1b26c4a8){
#line 92
  switch (arg_0x1b26c4a8) {
#line 92
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 92
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$granted(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(arg_0x1b26c4a8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 82 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(uint8_t id)
#line 82
{
  /*Msp430Uart1P.UartP*/Msp430UartP$0$UartControl$setModeDuplex(id);
}

# 198 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id)
#line 198
{
}

# 49 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(uint8_t arg_0x1b26bef8){
#line 49
  switch (arg_0x1b26bef8) {
#line 49
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 49
      /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$configure(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(arg_0x1b26bef8);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 172 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline  void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void)
#line 172
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 173
    {
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
    }
#line 176
    __nesc_atomic_end(__nesc_atomic); }
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
}

# 19 "/opt/tinyos-2.0/tos/platforms/telosa/TelosSerialP.nc"
static inline   msp430_uart_config_t *TelosSerialP$Msp430UartConfigure$getConfig(void)
#line 19
{
  return &TelosSerialP$msp430_uart_telos_config;
}

# 205 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    msp430_uart_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(uint8_t id)
#line 205
{
  return &msp430_uart_default_config;
}

# 39 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartConfigure.nc"
inline static   msp430_uart_config_t */*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(uint8_t arg_0x1aed7778){
#line 39
  struct __nesc_unnamed4277 *result;
#line 39

#line 39
  switch (arg_0x1aed7778) {
#line 39
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 39
      result = TelosSerialP$Msp430UartConfigure$getConfig();
#line 39
      break;
#line 39
    default:
#line 39
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$default$getConfig(arg_0x1aed7778);
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
# 418 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$disableIntr(void)
#line 418
{
  HplMsp430Usart1P$IE2 &= ~((1 << 5) | (1 << 4));
}

#line 406
static inline   void HplMsp430Usart1P$Usart$clrIntr(void)
#line 406
{
  HplMsp430Usart1P$IFG2 &= ~((1 << 5) | (1 << 4));
}

#line 159
static inline   void HplMsp430Usart1P$Usart$resetUsart(bool reset)
#line 159
{
  if (reset) {
    U1CTL |= 0x01;
    }
  else {
#line 163
    U1CTL &= ~0x01;
    }
}

# 54 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 7;
}

# 78 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$URXD$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectModuleFunc();
#line 78
}
#line 78
# 54 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 6;
}

# 78 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UTXD$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectModuleFunc();
#line 78
}
#line 78
# 203 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
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

# 96 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline uint8_t urctl2int(msp430_urctl_t x)
#line 96
{
#line 96
  union __nesc_unnamed4327 {
#line 96
    msp430_urctl_t f;
#line 96
    uint8_t t;
  } 
#line 96
  c = { .f = x };

#line 96
  return c.t;
}

# 132 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$setUrctl(msp430_urctl_t control)
#line 132
{
  HplMsp430Usart1P$U1RCTL = urctl2int(control);
}

# 93 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline uint8_t utctl2int(msp430_utctl_t x)
#line 93
{
#line 93
  union __nesc_unnamed4328 {
#line 93
    msp430_utctl_t f;
#line 93
    uint8_t t;
  } 
#line 93
  c = { .f = x };

#line 93
  return c.t;
}

# 124 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$setUtctl(msp430_utctl_t control)
#line 124
{
  HplMsp430Usart1P$U1TCTL = utctl2int(control);
}

# 90 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline uint8_t uctl2int(msp430_uctl_t x)
#line 90
{
#line 90
  union __nesc_unnamed4329 {
#line 90
    msp430_uctl_t f;
#line 90
    uint8_t t;
  } 
#line 90
  c = { .f = x };

#line 90
  return c.t;
}

# 116 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$setUctl(msp430_uctl_t control)
#line 116
{
  U1CTL = uctl2int(control);
}

# 97 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline msp430_urctl_t int2urctl(uint8_t x)
#line 97
{
#line 97
  union __nesc_unnamed4330 {
#line 97
    uint8_t f;
#line 97
    msp430_urctl_t t;
  } 
#line 97
  c = { .f = x };

#line 97
  return c.t;
}

# 136 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   msp430_urctl_t HplMsp430Usart1P$Usart$getUrctl(void)
#line 136
{
  return int2urctl(HplMsp430Usart1P$U1RCTL);
}

# 94 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline msp430_utctl_t int2utctl(uint8_t x)
#line 94
{
#line 94
  union __nesc_unnamed4331 {
#line 94
    uint8_t f;
#line 94
    msp430_utctl_t t;
  } 
#line 94
  c = { .f = x };

#line 94
  return c.t;
}

# 128 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   msp430_utctl_t HplMsp430Usart1P$Usart$getUtctl(void)
#line 128
{
  return int2utctl(HplMsp430Usart1P$U1TCTL);
}

# 91 "/opt/tinyos-2.0/tos/chips/msp430/usart/msp430usart.h"
static inline msp430_uctl_t int2uctl(uint8_t x)
#line 91
{
#line 91
  union __nesc_unnamed4332 {
#line 91
    uint8_t f;
#line 91
    msp430_uctl_t t;
  } 
#line 91
  c = { .f = x };

#line 91
  return c.t;
}

# 120 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   msp430_uctl_t HplMsp430Usart1P$Usart$getUctl(void)
#line 120
{
  return int2uctl(U0CTL);
}

#line 295
static inline void HplMsp430Usart1P$configUart(msp430_uart_config_t *config)
#line 295
{
  msp430_uctl_t uctl = HplMsp430Usart1P$Usart$getUctl();
  msp430_utctl_t utctl = HplMsp430Usart1P$Usart$getUtctl();
  msp430_urctl_t urctl = HplMsp430Usart1P$Usart$getUrctl();

  uctl.pena = config->pena;
  uctl.pev = config->pev;
  uctl.spb = config->spb;
  uctl.clen = config->clen;
  uctl.listen = config->listen;
  uctl.sync = 0;
  uctl.mm = config->mm;

  utctl.ckpl = config->ckpl;
  utctl.ssel = config->ssel;
  utctl.urxse = config->urxse;

  urctl.urxeie = config->urxeie;
  urctl.urxwie = config->urxwie;

  HplMsp430Usart1P$Usart$setUctl(uctl);
  HplMsp430Usart1P$Usart$setUtctl(utctl);
  HplMsp430Usart1P$Usart$setUrctl(urctl);
  HplMsp430Usart1P$Usart$setUbr(config->ubr);
  HplMsp430Usart1P$Usart$setUmctl(config->umctl);
}

#line 358
static inline   void HplMsp430Usart1P$Usart$setModeUart(msp430_uart_config_t *config)
#line 358
{

  HplMsp430Usart1P$Usart$disableSpi();
  HplMsp430Usart1P$Usart$disableUart();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 363
    {
      HplMsp430Usart1P$UTXD$selectModuleFunc();
      HplMsp430Usart1P$URXD$selectModuleFunc();
      HplMsp430Usart1P$Usart$resetUsart(TRUE);
      HplMsp430Usart1P$configUart(config);
      HplMsp430Usart1P$Usart$enableUart();
      HplMsp430Usart1P$Usart$resetUsart(FALSE);
      HplMsp430Usart1P$Usart$clrIntr();
      HplMsp430Usart1P$Usart$disableIntr();
    }
#line 372
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 186 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(msp430_uart_config_t *arg_0x1aee6010){
#line 186
  HplMsp430Usart1P$Usart$setModeUart(arg_0x1aee6010);
#line 186
}
#line 186
# 56 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 1);
}

# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$SIMO$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P51*/HplMsp430GeneralIOP$33$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 2);
}

# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$SOMI$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P52*/HplMsp430GeneralIOP$34$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)51U &= ~(0x01 << 3);
}

# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UCLK$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P53*/HplMsp430GeneralIOP$35$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 6);
}

# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$UTXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P36*/HplMsp430GeneralIOP$22$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 7);
}

# 85 "/opt/tinyos-2.0/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart1P$URXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P37*/HplMsp430GeneralIOP$23$IO$selectIOFunc();
#line 85
}
#line 85
# 219 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$clrIntr(void){
#line 219
  HplMsp430Usart1P$Usart$clrIntr();
#line 219
}
#line 219
# 436 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$enableIntr(void)
#line 436
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 437
    {
      HplMsp430Usart1P$IFG2 &= ~((1 << 5) | (1 << 4));
      HplMsp430Usart1P$IE2 |= (1 << 5) | (1 << 4);
    }
#line 440
    __nesc_atomic_end(__nesc_atomic); }
}

# 194 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr(void){
#line 194
  HplMsp430Usart1P$Usart$enableIntr();
#line 194
}
#line 194
# 140 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source)
#line 140
{
  const uint8_t *base = source;

#line 142
  return base[0];
}

# 49 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline serial_header_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(message_t *msg)
#line 49
{
  return (serial_header_t *)(msg->data - sizeof(serial_header_t ));
}

#line 159
static inline  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg)
#line 159
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 161
  return __nesc_ntoh_uint8((unsigned char *)&header->type);
}

# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x1ac521d8, error_t arg_0x1ac52358){
#line 99
  Link_TUnitProcessingP$SerialEventSend$sendDone(arg_0x1ac521d8, arg_0x1ac52358);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.0/tos/system/AMQueueEntryP.nc"
static inline  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(m, err);
}

# 184 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err)
#line 184
{
}

# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(uint8_t arg_0x1ad0b2c8, message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010){
#line 89
  switch (arg_0x1ad0b2c8) {
#line 89
    case 0U:
#line 89
      /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(arg_0x1ace9dd8, arg_0x1ace7010);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(arg_0x1ad0b2c8, arg_0x1ace9dd8, arg_0x1ace7010);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 166 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(am_id_t id, message_t *msg, error_t err)
#line 166
{
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg == msg) {
      uint8_t last = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current;

#line 169
      ;
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[last].msg = (void *)0;
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend();
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(last, msg, err);
    }
}

# 99 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(am_id_t arg_0x1ad34ae0, message_t *arg_0x1ac521d8, error_t arg_0x1ac52358){
#line 99
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(arg_0x1ad34ae0, arg_0x1ac521d8, arg_0x1ac52358);
#line 99
}
#line 99
# 81 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *msg, error_t result)
#line 81
{
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, result);
}

# 359 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error)
#line 359
{
  return;
}

# 89 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
inline static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(uart_id_t arg_0x1ae2d4e8, message_t *arg_0x1ace9dd8, error_t arg_0x1ace7010){
#line 89
  switch (arg_0x1ae2d4e8) {
#line 89
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 89
      /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(arg_0x1ace9dd8, arg_0x1ace7010);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(arg_0x1ae2d4e8, arg_0x1ace9dd8, arg_0x1ace7010);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 144 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void)
#line 144
{
  error_t error;

  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 148
    error = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError;
#line 148
    __nesc_atomic_end(__nesc_atomic); }

  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled) {
#line 150
    error = ECANCEL;
    }
#line 151
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId, (message_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer, error);
}

# 63 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket(void)
#line 63
{
  uint16_t i;
  uint8_t initial = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current;

#line 66
  if (initial == /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY) {
      initial = 0;
    }
  i = initial;
  for (; i < initial + 1; i++) {
      uint8_t client = (uint8_t )i % 1;

#line 72
      if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[client].msg != (void *)0) {
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = client;
          return;
        }
    }
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY;
}

# 169 "/usr/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_ntoh_uint16(const void *source)
#line 169
{
  const uint8_t *base = source;

#line 171
  return ((uint16_t )base[0] << 8) | base[1];
}

# 67 "/opt/tinyos-2.0/tos/interfaces/Packet.nc"
inline static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x1acb2e88){
#line 67
  unsigned char result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(arg_0x1acb2e88);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 522 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 51 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x1ad98ae0){
#line 51
  unsigned char result;
#line 51

#line 51
  result = SerialP$SendBytePacket$startSend(arg_0x1ad98ae0);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 43 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen)
#line 43
{
  return upperLen + sizeof(serial_header_t );
}

# 344 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen)
#line 345
{
  return 0;
}

# 23 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(uart_id_t arg_0x1ae2de68, message_t *arg_0x1ad8a4e8, uint8_t arg_0x1ad8a670){
#line 23
  unsigned char result;
#line 23

#line 23
  switch (arg_0x1ae2de68) {
#line 23
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 23
      result = SerialPacketInfoActiveMessageP$Info$dataLinkLength(arg_0x1ad8a4e8, arg_0x1ad8a670);
#line 23
      break;
#line 23
    default:
#line 23
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(arg_0x1ae2de68, arg_0x1ad8a4e8, arg_0x1ad8a670);
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
# 40 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void)
#line 40
{
  return (uint8_t )(sizeof(message_header_t ) - sizeof(serial_header_t ));
}

# 341 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id)
#line 341
{
  return 0;
}

# 15 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(uart_id_t arg_0x1ae2de68){
#line 15
  unsigned char result;
#line 15

#line 15
  switch (arg_0x1ae2de68) {
#line 15
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 15
      result = SerialPacketInfoActiveMessageP$Info$offset();
#line 15
      break;
#line 15
    default:
#line 15
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(arg_0x1ae2de68);
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
# 100 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(uint8_t id, message_t *msg, uint8_t len)
#line 100
{
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState != /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE) {
      return EBUSY;
    }

  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_DATA;
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId = id;
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled = FALSE;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 108
    {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = SUCCESS;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer = (uint8_t *)msg;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(id);


      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendLen = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(id, msg, len) + /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendIndex;
    }
#line 115
    __nesc_atomic_end(__nesc_atomic); }
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(id) == SUCCESS) {
      return SUCCESS;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
      return FAIL;
    }
}

# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
inline static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(TOS_SERIAL_ACTIVE_MESSAGE_ID, arg_0x1aceaa28, arg_0x1aceaba8);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 86 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
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

# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 118 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
static inline   void StateImplP$State$toIdle(uint8_t id)
#line 118
{
  StateImplP$state[id] = StateImplP$S_IDLE;
}

# 56 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void Link_TUnitProcessingP$SendState$toIdle(void){
#line 56
  StateImplP$State$toIdle(2U);
#line 56
}
#line 56
# 126 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
static inline   bool StateImplP$State$isIdle(uint8_t id)
#line 126
{
  return StateImplP$state[id] == StateImplP$S_IDLE;
}

# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   bool Link_TUnitProcessingP$SendState$isIdle(void){
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
# 111 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
static inline   void StateImplP$State$forceState(uint8_t id, uint8_t reqState)
#line 111
{
  StateImplP$state[id] = reqState;
}

# 51 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void Link_TUnitProcessingP$SendState$forceState(uint8_t arg_0x1a926c80){
#line 51
  StateImplP$State$forceState(2U, arg_0x1a926c80);
#line 51
}
#line 51
# 198 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which)
#line 198
{
  if (which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 0;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 0;
    }
}

# 129 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$TUnitProcessing$pong(void)
#line 129
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_PONG, 0xFF, (void *)0, 0, 0);
}

# 24 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void TUnitP$TUnitProcessing$pong(void){
#line 24
  Link_TUnitProcessingP$TUnitProcessing$pong();
#line 24
}
#line 24
# 135 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TUnitProcessing$ping(void)
#line 135
{
  TUnitP$TUnitProcessing$pong();
}

# 29 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void Link_TUnitProcessingP$TUnitProcessing$ping(void){
#line 29
  TUnitP$TUnitProcessing$ping();
#line 29
}
#line 29
# 183 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$SetUpOneTime$done(void)
#line 183
{
  TUnitP$setUpOneTimeDone();
}

# 10 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TestStateP$SetUpOneTime$done(void){
#line 10
  TUnitP$SetUpOneTime$done();
#line 10
}
#line 10
# 56 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void TestStateP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(0U);
#line 56
}
#line 56
# 34 "TestStateP.nc"
static inline  void TestStateP$SetUpOneTime$run(void)
#line 34
{
  TestStateP$State$toIdle();
  TestStateP$SetUpOneTime$done();
}

# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$SetUpOneTime$run(void){
#line 8
  TestStateP$SetUpOneTime$run();
#line 8
}
#line 8
# 51 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void TUnitP$TestState$forceState(uint8_t arg_0x1a926c80){
#line 51
  StateImplP$State$forceState(4U, arg_0x1a926c80);
#line 51
}
#line 51
inline static   void TUnitP$TUnitState$forceState(uint8_t arg_0x1a926c80){
#line 51
  StateImplP$State$forceState(3U, arg_0x1a926c80);
#line 51
}
#line 51
# 133 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
static inline   uint8_t StateImplP$State$getState(uint8_t id)
#line 133
{
  return StateImplP$state[id];
}

# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   uint8_t TUnitP$TUnitState$getState(void){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$getState(3U);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 125 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TUnitProcessing$run(void)
#line 125
{
  if (TUnitP$TUnitState$getState() == TUnitP$S_READY) {
      TUnitP$TUnitState$forceState(TUnitP$S_RUNNING);
      TUnitP$TestState$forceState(TUnitP$S_SETUP_ONETIME);
      TUnitP$currentTest = 0;
      TUnitP$SetUpOneTime$run();
    }
}

# 27 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void Link_TUnitProcessingP$TUnitProcessing$run(void){
#line 27
  TUnitP$TUnitProcessing$run();
#line 27
}
#line 27
# 151 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline void Link_TUnitProcessingP$execute(TUnitProcessingMsg *inMsg)
#line 151
{
  switch (__nesc_ntoh_uint8((unsigned char *)&inMsg->cmd)) {
      case TUNITPROCESSING_CMD_RUN: 
        Link_TUnitProcessingP$TUnitProcessing$run();
      break;

      case TUNITPROCESSING_CMD_PING: 
        Link_TUnitProcessingP$TUnitProcessing$ping();
      break;

      default: ;
    }
}

#line 83
static inline  message_t *Link_TUnitProcessingP$SerialReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 83
{
  Link_TUnitProcessingP$execute(payload);
  return msg;
}

# 89 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline   message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(uint8_t id, message_t *msg, void *payload, uint8_t len)
#line 89
{
  return msg;
}

# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
inline static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(am_id_t arg_0x1ad334a0, message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x1ad334a0) {
#line 67
    case 255:
#line 67
      result = Link_TUnitProcessingP$SerialReceive$receive(arg_0x1ac68698, arg_0x1ac68830, arg_0x1ac689b0);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(arg_0x1ad334a0, arg_0x1ac68698, arg_0x1ac68830, arg_0x1ac689b0);
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
# 174 "/usr/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value)
#line 174
{
  uint8_t *base = target;

#line 176
  base[1] = value;
  base[0] = value >> 8;
  return value;
}

# 150 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setSource(message_t *amsg, am_addr_t addr)
#line 150
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 152
  __nesc_hton_uint16((unsigned char *)&header->src, addr);
}

#line 102
static inline  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 102
{
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setSource(msg, 0xFFFB);
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, msg->data, len);
}

# 354 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len)
#line 356
{
  return msg;
}

# 67 "/opt/tinyos-2.0/tos/interfaces/Receive.nc"
inline static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(uart_id_t arg_0x1ae10d88, message_t *arg_0x1ac68698, void *arg_0x1ac68830, uint8_t arg_0x1ac689b0){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x1ae10d88) {
#line 67
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(arg_0x1ac68698, arg_0x1ac68830, arg_0x1ac689b0);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(arg_0x1ae10d88, arg_0x1ac68698, arg_0x1ac68830, arg_0x1ac689b0);
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
# 46 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen)
#line 46
{
  return dataLinkLen - sizeof(serial_header_t );
}

# 348 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen)
#line 349
{
  return 0;
}

# 31 "/opt/tinyos-2.0/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(uart_id_t arg_0x1ae2de68, message_t *arg_0x1ad8acc8, uint8_t arg_0x1ad8ae50){
#line 31
  unsigned char result;
#line 31

#line 31
  switch (arg_0x1ae2de68) {
#line 31
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 31
      result = SerialPacketInfoActiveMessageP$Info$upperLength(arg_0x1ad8acc8, arg_0x1ad8ae50);
#line 31
      break;
#line 31
    default:
#line 31
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(arg_0x1ae2de68, arg_0x1ad8acc8, arg_0x1ad8ae50);
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
# 261 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void)
#line 261
{
  uart_id_t myType;
  message_t *myBuf;
  uint8_t mySize;
  uint8_t myWhich;

#line 266
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 266
    {
      myType = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskType;
      myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskBuf;
      mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskSize;
      myWhich = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskWhich;
    }
#line 271
    __nesc_atomic_end(__nesc_atomic); }
  mySize -= /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(myType);
  mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(myType, myBuf, mySize);
  myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(myType, myBuf, myBuf, mySize);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 275
    {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[myWhich] = myBuf;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(myWhich);
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending = FALSE;
    }
#line 279
    __nesc_atomic_end(__nesc_atomic); }
}

# 45 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   error_t TUnitP$TestState$requestState(uint8_t arg_0x1a926708){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(4U, arg_0x1a926708);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 140 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$TestCase$done(uint8_t testId)
#line 140
{
  TUnitP$runDone();
}

# 12 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
inline static  void TestStateP$TestForce$done(void){
#line 12
  TUnitP$TestCase$done(/*TestStateC.TestForceC*/TestCaseC$0$TUNIT_TEST_ID);
#line 12
}
#line 12
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   uint8_t TestStateP$State$getState(void){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$getState(0U);
#line 66

#line 66
  return result;
#line 66
}
#line 66
#line 51
inline static   void TestStateP$State$forceState(uint8_t arg_0x1a926c80){
#line 51
  StateImplP$State$forceState(0U, arg_0x1a926c80);
#line 51
}
#line 51
# 46 "TestStateP.nc"
static inline  void TestStateP$TestForce$run(void)
#line 46
{
  TestStateP$State$forceState(TestStateP$S_STATE1);
  if (!TestStateP$State$getState() == TestStateP$S_STATE1) {
#line 48
      assertFail("TestForce: S_STATE1 not forced correctly");
    }
  else 
#line 48
    {
#line 48
      assertSuccess();
    }
#line 48
  ;
  TestStateP$State$forceState(TestStateP$S_STATE2);
  if (TestStateP$State$getState() != TestStateP$S_STATE2) {
#line 50
      assertEqualsFailed("TestForce: S_STATE2 not forced correctly", (uint32_t )TestStateP$State$getState(), (uint32_t )TestStateP$S_STATE2);
    }
  else 
#line 50
    {
#line 50
      assertSuccess();
    }
#line 50
  ;
  TestStateP$State$forceState(TestStateP$S_IDLE);
  if (TestStateP$State$getState() == TestStateP$S_STATE3) {
#line 52
      assertFail("TestForce: State was supposed to be idle");
    }
  else 
#line 52
    {
#line 52
      assertSuccess();
    }
#line 52
  ;

  TestStateP$TestForce$done();
}

# 12 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
inline static  void TestStateP$TestToIdle$done(void){
#line 12
  TUnitP$TestCase$done(/*TestStateC.TestToIdleC*/TestCaseC$1$TUNIT_TEST_ID);
#line 12
}
#line 12
# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   bool TestStateP$State$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(0U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 70 "TestStateP.nc"
static inline  void TestStateP$TestToIdle$run(void)
#line 70
{
  TestStateP$State$forceState(TestStateP$S_STATE3);
  if (!TestStateP$State$getState() == TestStateP$S_STATE3) {
#line 72
      assertFail("TestToIdle: S_STATE3 not forced correctly");
    }
  else 
#line 72
    {
#line 72
      assertSuccess();
    }
#line 72
  ;
  TestStateP$State$toIdle();
  if (!TestStateP$State$getState() == TestStateP$S_IDLE) {
#line 74
      assertFail("TestToIdle: toIdle() didn't work");
    }
  else 
#line 74
    {
#line 74
      assertSuccess();
    }
#line 74
  ;
  if (!TestStateP$State$isIdle()) {
#line 75
      assertFail("TestToIdle: toIdle()/isIdle() didn't work");
    }
  else 
#line 75
    {
#line 75
      assertSuccess();
    }
#line 75
  ;

  TestStateP$TestToIdle$done();
}

# 12 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
inline static  void TestStateP$TestRequest$done(void){
#line 12
  TUnitP$TestCase$done(/*TestStateC.TestRequestC*/TestCaseC$2$TUNIT_TEST_ID);
#line 12
}
#line 12
# 45 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   error_t TestStateP$State$requestState(uint8_t arg_0x1a926708){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(0U, arg_0x1a926708);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 57 "TestStateP.nc"
static inline  void TestStateP$TestRequest$run(void)
#line 57
{
  TestStateP$State$toIdle();
  TestStateP$State$requestState(TestStateP$S_STATE1);
  if (!TestStateP$State$getState() == TestStateP$S_STATE1) {
#line 60
      assertFail("TestReq: S_STATE1 not requested correctly");
    }
  else 
#line 60
    {
#line 60
      assertSuccess();
    }
#line 60
  ;
  TestStateP$State$requestState(TestStateP$S_STATE2);
  if (TestStateP$State$getState() == TestStateP$S_STATE2) {
#line 62
      assertFail("TestReq: S_STATE2 requested incorrectly");
    }
  else 
#line 62
    {
#line 62
      assertSuccess();
    }
#line 62
  ;
  TestStateP$State$requestState(TestStateP$S_IDLE);
  if (!TestStateP$State$isIdle()) {
#line 64
      assertFail("TestReq: S_IDLE not requested correctly");
    }
  else 
#line 64
    {
#line 64
      assertSuccess();
    }
#line 64
  ;

  TestStateP$TestRequest$done();
}

# 290 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline   void TUnitP$TestCase$default$run(uint8_t testId)
#line 290
{
  TUnitP$runDone();
}

# 10 "/opt/tinyos-2.0/programs/tunit/tos/interfaces/TestCase.nc"
inline static  void TUnitP$TestCase$run(uint8_t arg_0x1aba6be0){
#line 10
  switch (arg_0x1aba6be0) {
#line 10
    case /*TestStateC.TestForceC*/TestCaseC$0$TUNIT_TEST_ID:
#line 10
      TestStateP$TestForce$run();
#line 10
      break;
#line 10
    case /*TestStateC.TestToIdleC*/TestCaseC$1$TUNIT_TEST_ID:
#line 10
      TestStateP$TestToIdle$run();
#line 10
      break;
#line 10
    case /*TestStateC.TestRequestC*/TestCaseC$2$TUNIT_TEST_ID:
#line 10
      TestStateP$TestRequest$run();
#line 10
      break;
#line 10
    default:
#line 10
      TUnitP$TestCase$default$run(arg_0x1aba6be0);
#line 10
      break;
#line 10
    }
#line 10
}
#line 10
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   uint8_t TUnitP$TestState$getState(void){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$getState(4U);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 222 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$setUpDone(void)
#line 222
{
  if (TUnitP$TestState$getState() == TUnitP$S_SETUP) {
      TUnitP$TestState$forceState(TUnitP$S_RUN);
      TUnitP$TestCase$run(TUnitP$currentTest);
    }
}

#line 286
static inline   void TUnitP$SetUp$default$run(void)
#line 286
{
  TUnitP$setUpDone();
}

# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$SetUp$run(void){
#line 8
  TUnitP$SetUp$default$run();
#line 8
}
#line 8
# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   bool TUnitP$TUnitState$isIdle(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = StateImplP$State$isIdle(3U);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 120 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testFailed(uint8_t testId, char *failMsg)
#line 120
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_FAILED, testId, failMsg, 0, 0);
}

# 19 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testFailed(uint8_t arg_0x1abb54e0, char *arg_0x1abb5678){
#line 19
  Link_TUnitProcessingP$TUnitProcessing$testFailed(arg_0x1abb54e0, arg_0x1abb5678);
#line 19
}
#line 19
# 206 "/usr/lib/ncc/nesc_nx.h"
static __inline uint32_t __nesc_hton_uint32(void *target, uint32_t value)
#line 206
{
  uint8_t *base = target;

#line 208
  base[3] = value;
  base[2] = value >> 8;
  base[1] = value >> 16;
  base[0] = value >> 24;
  return value;
}

#line 145
static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value)
#line 145
{
  uint8_t *base = target;

#line 147
  base[0] = value;
  return value;
}

#line 162
static __inline int8_t __nesc_hton_int8(void *target, int8_t value)
#line 162
{
#line 162
  __nesc_hton_uint8(target, value);
#line 162
  return value;
}

# 100 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testSuccess(uint8_t testId)
#line 100
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_SUCCESS, testId, (void *)0, 0, 0);
}

# 9 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testSuccess(uint8_t arg_0x1abb9bd8){
#line 9
  Link_TUnitProcessingP$TUnitProcessing$testSuccess(arg_0x1abb9bd8);
#line 9
}
#line 9
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 56 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void TUnitP$TestState$toIdle(void){
#line 56
  StateImplP$State$toIdle(4U);
#line 56
}
#line 56
# 238 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$tearDownDone(void)
#line 238
{
  if (TUnitP$TestState$getState() == TUnitP$S_TEARDOWN) {
      TUnitP$TestState$toIdle();
      TUnitP$waitForSendDone$postTask();
    }
}

#line 294
static inline   void TUnitP$TearDown$default$run(void)
#line 294
{
  TUnitP$tearDownDone();
}

# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$TearDown$run(void){
#line 8
  TUnitP$TearDown$default$run();
#line 8
}
#line 8
# 104 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual)
#line 104
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED, testId, failMsg, expected, actual);
}

# 11 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testEqualsFailed(uint8_t arg_0x1abb8088, char *arg_0x1abb8220, uint32_t arg_0x1abb83b0, uint32_t arg_0x1abb8538){
#line 11
  Link_TUnitProcessingP$TUnitProcessing$testEqualsFailed(arg_0x1abb8088, arg_0x1abb8220, arg_0x1abb83b0, arg_0x1abb8538);
#line 11
}
#line 11
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 125 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$TUnitProcessing$allDone(void)
#line 125
{
  Link_TUnitProcessingP$allDone$postTask();
}

# 22 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static  void TUnitP$TUnitProcessing$allDone(void){
#line 22
  Link_TUnitProcessingP$TUnitProcessing$allDone();
#line 22
}
#line 22
# 246 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline void TUnitP$tearDownOneTimeDone(void)
#line 246
{
  TUnitP$TUnitState$forceState(TUnitP$S_READY);
  TUnitP$TestState$toIdle();
  TUnitP$TUnitProcessing$allDone();
}

#line 195
static inline  void TUnitP$TearDownOneTime$done(void)
#line 195
{
  TUnitP$tearDownOneTimeDone();
}

# 10 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TestStateP$TearDownOneTime$done(void){
#line 10
  TUnitP$TearDownOneTime$done();
#line 10
}
#line 10
# 40 "TestStateP.nc"
static inline  void TestStateP$TearDownOneTime$run(void)
#line 40
{
  TestStateP$State$toIdle();
  TestStateP$TearDownOneTime$done();
}

# 8 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TestControl.nc"
inline static  void TUnitP$TearDownOneTime$run(void){
#line 8
  TestStateP$TearDownOneTime$run();
#line 8
}
#line 8
# 121 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$SerialSplitControl$stopDone(error_t error)
#line 121
{
}

# 51 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   void Link_TUnitProcessingP$SerialState$forceState(uint8_t arg_0x1a926c80){
#line 51
  StateImplP$State$forceState(1U, arg_0x1a926c80);
#line 51
}
#line 51
# 78 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$SerialSplitControl$stopDone(error_t error)
#line 78
{
  Link_TUnitProcessingP$SerialState$forceState(Link_TUnitProcessingP$S_OFF);
}

# 110 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$stopDone(error_t arg_0x1abc3688){
#line 110
  Link_TUnitProcessingP$SerialSplitControl$stopDone(arg_0x1abc3688);
#line 110
  TUnitP$SerialSplitControl$stopDone(arg_0x1abc3688);
#line 110
}
#line 110
# 128 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart(void){
#line 128
  HplMsp430Usart1P$Usart$disableUart();
#line 128
}
#line 128
#line 191
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr(void){
#line 191
  HplMsp430Usart1P$Usart$disableIntr();
#line 191
}
#line 191
# 86 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(uint8_t id)
#line 86
{
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableIntr();
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$disableUart();
}

# 200 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id)
#line 200
{
}

# 55 "/opt/tinyos-2.0/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(uint8_t arg_0x1b26bef8){
#line 55
  switch (arg_0x1b26bef8) {
#line 55
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 55
      /*Msp430Uart1P.UartP*/Msp430UartP$0$ResourceConfigure$unconfigure(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 55
      break;
#line 55
    default:
#line 55
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(arg_0x1b26bef8);
#line 55
      break;
#line 55
    }
#line 55
}
#line 55
# 109 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   error_t HplMsp430Usart1P$AsyncStdControl$stop(void)
#line 109
{
  HplMsp430Usart1P$Usart$disableSpi();
  HplMsp430Usart1P$Usart$disableUart();
  return SUCCESS;
}

# 82 "/opt/tinyos-2.0/tos/interfaces/AsyncStdControl.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop(void){
#line 82
  unsigned char result;
#line 82

#line 82
  result = HplMsp430Usart1P$AsyncStdControl$stop();
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 74 "/opt/tinyos-2.0/tos/lib/power/AsyncPowerManagerP.nc"
static inline    void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup(void)
#line 74
{
}

# 52 "/opt/tinyos-2.0/tos/lib/power/PowerDownCleanup.nc"
inline static   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup(void){
#line 52
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$default$cleanup();
#line 52
}
#line 52
# 69 "/opt/tinyos-2.0/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$granted(void)
#line 69
{
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$PowerDownCleanup$cleanup();
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$stop();
}

# 46 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$granted(void){
#line 46
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$granted();
#line 46
}
#line 46
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 58 "/opt/tinyos-2.0/tos/system/FcfsResourceQueueC.nc"
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

# 60 "/opt/tinyos-2.0/tos/interfaces/ResourceQueue.nc"
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
# 50 "/opt/tinyos-2.0/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void)
#line 50
{
  return /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
}

# 43 "/opt/tinyos-2.0/tos/interfaces/ResourceQueue.nc"
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
# 106 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id)
#line 106
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 107
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY && /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
          if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty() == FALSE) {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue();
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
            }
          else {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$CONTROLLER_ID;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$granted();
            }
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(id);
        }
    }
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 204 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(uint8_t id)
#line 204
{
#line 204
  return FAIL;
}

# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(uint8_t arg_0x1aed8e38){
#line 101
  unsigned char result;
#line 101

#line 101
  switch (arg_0x1aed8e38) {
#line 101
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 101
      result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(/*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID);
#line 101
      break;
#line 101
    default:
#line 101
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$release(arg_0x1aed8e38);
#line 101
      break;
#line 101
    }
#line 101

#line 101
  return result;
#line 101
}
#line 101
# 76 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(uint8_t id)
#line 76
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf || /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf) {
    return EBUSY;
    }
#line 79
  return /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$release(id);
}

# 101 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
inline static   error_t TelosSerialP$Resource$release(void){
#line 101
  unsigned char result;
#line 101

#line 101
  result = /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$release(/*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID);
#line 101

#line 101
  return result;
#line 101
}
#line 101
# 13 "/opt/tinyos-2.0/tos/platforms/telosa/TelosSerialP.nc"
static inline  error_t TelosSerialP$StdControl$stop(void)
#line 13
{
  TelosSerialP$Resource$release();
  return SUCCESS;
}

# 82 "/opt/tinyos-2.0/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$stop(void){
#line 82
  unsigned char result;
#line 82

#line 82
  result = TelosSerialP$StdControl$stop();
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 330 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 338 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFlush$default$flush(void)
#line 338
{
  SerialP$defaultSerialFlushTask$postTask();
}

# 38 "/opt/tinyos-2.0/tos/interfaces/SerialFlush.nc"
inline static  void SerialP$SerialFlush$flush(void){
#line 38
  SerialP$SerialFlush$default$flush();
#line 38
}
#line 38
# 326 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline  void SerialP$stopDoneTask$runTask(void)
#line 326
{
  SerialP$SerialFlush$flush();
}

# 52 "/opt/tinyos-2.0/tos/system/ActiveMessageAddressC.nc"
static inline   am_addr_t ActiveMessageAddressC$amAddress(void)
#line 52
{
  return ActiveMessageAddressC$addr;
}

# 58 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
inline static   am_addr_t TUnitP$amAddress(void){
#line 58
  unsigned int result;
#line 58

#line 58
  result = ActiveMessageAddressC$amAddress();
#line 58

#line 58
  return result;
#line 58
}
#line 58
#line 105
static inline  void TUnitP$SerialSplitControl$startDone(error_t error)
#line 105
{
  if (TUnitP$TUnitState$getState() == TUnitP$S_NOT_BOOTED) {
      TUnitP$TUnitState$forceState(TUnitP$S_READY);

      if (TUnitP$amAddress() != 0) {




          TUnitP$TUnitState$forceState(TUnitP$S_RUNNING);
          TUnitP$TestState$forceState(TUnitP$S_SETUP_ONETIME);
          TUnitP$SetUpOneTime$run();
        }
    }
}

# 74 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$SerialSplitControl$startDone(error_t error)
#line 74
{
  Link_TUnitProcessingP$SerialState$forceState(Link_TUnitProcessingP$S_ON);
}

# 88 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$startDone(error_t arg_0x1abc4b40){
#line 88
  Link_TUnitProcessingP$SerialSplitControl$startDone(arg_0x1abc4b40);
#line 88
  TUnitP$SerialSplitControl$startDone(arg_0x1abc4b40);
#line 88
}
#line 88
# 125 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$release(void)
#line 125
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 126
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$CONTROLLER_ID) {
          if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING) {
              /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
              {
                unsigned char __nesc_temp = 
#line 130
                SUCCESS;

                {
#line 130
                  __nesc_atomic_end(__nesc_atomic); 
#line 130
                  return __nesc_temp;
                }
              }
            }
          else {
#line 132
            if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING) {
                /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
                /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
                {
                  unsigned char __nesc_temp = 
#line 135
                  SUCCESS;

                  {
#line 135
                    __nesc_atomic_end(__nesc_atomic); 
#line 135
                    return __nesc_temp;
                  }
                }
              }
            }
        }
    }
#line 141
    __nesc_atomic_end(__nesc_atomic); }
#line 139
  return FAIL;
}

# 56 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$release(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$release();
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 105 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   error_t HplMsp430Usart1P$AsyncStdControl$start(void)
#line 105
{
  return SUCCESS;
}

# 73 "/opt/tinyos-2.0/tos/interfaces/AsyncStdControl.nc"
inline static   error_t /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start(void){
#line 73
  unsigned char result;
#line 73

#line 73
  result = HplMsp430Usart1P$AsyncStdControl$start();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 64 "/opt/tinyos-2.0/tos/lib/power/AsyncPowerManagerP.nc"
static inline   void /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$immediateRequested(void)
#line 64
{
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$AsyncStdControl$start();
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$release();
}

# 81 "/opt/tinyos-2.0/tos/interfaces/ResourceController.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$immediateRequested(void){
#line 81
  /*Msp430UsartShare1P.PowerManagerC.PowerManager*/AsyncPowerManagerP$0$ResourceController$immediateRequested();
#line 81
}
#line 81
# 188 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id)
#line 188
{
}

# 51 "/opt/tinyos-2.0/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(uint8_t arg_0x1b26cdb0){
#line 51
    /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(arg_0x1b26cdb0);
#line 51
}
#line 51
# 88 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id)
#line 88
{
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 90
    {
      if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) {
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING;
          /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = id;
        }
      else {
          unsigned char __nesc_temp = 
#line 95
          FAIL;

          {
#line 95
            __nesc_atomic_end(__nesc_atomic); 
#line 95
            return __nesc_temp;
          }
        }
    }
#line 98
    __nesc_atomic_end(__nesc_atomic); }
#line 97
  /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceController$immediateRequested();
  if (/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
      /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId);
      return SUCCESS;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 102
    /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
#line 102
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 203 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline    error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(uint8_t id)
#line 203
{
#line 203
  return FAIL;
}

# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(uint8_t arg_0x1aed8e38){
#line 87
  unsigned char result;
#line 87

#line 87
  switch (arg_0x1aed8e38) {
#line 87
    case /*PlatformSerialC.UartC*/Msp430Uart1C$0$CLIENT_ID:
#line 87
      result = /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(/*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID);
#line 87
      break;
#line 87
    default:
#line 87
      result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$default$immediateRequest(arg_0x1aed8e38);
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
# 64 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$Resource$immediateRequest(uint8_t id)
#line 64
{
  return /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartResource$immediateRequest(id);
}

# 87 "/opt/tinyos-2.0/tos/interfaces/Resource.nc"
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
# 10 "/opt/tinyos-2.0/tos/platforms/telosa/TelosSerialP.nc"
static inline  error_t TelosSerialP$StdControl$start(void)
#line 10
{
  return TelosSerialP$Resource$immediateRequest();
}

# 73 "/opt/tinyos-2.0/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$start(void){
#line 73
  unsigned char result;
#line 73

#line 73
  result = TelosSerialP$StdControl$start();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 320 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline  void SerialP$startDoneTask$runTask(void)
#line 320
{
  SerialP$SerialControl$start();
  SerialP$SplitControl$startDone(SUCCESS);
}

# 45 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
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
# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 180 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error)
#line 180
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 181
    /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = error;
#line 181
    __nesc_atomic_end(__nesc_atomic); }
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask();
}

# 80 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
inline static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x1ad97ae0){
#line 80
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(arg_0x1ad97ae0);
#line 80
}
#line 80
# 242 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 143 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void)
#line 143
{
  message_t *msg = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg;

#line 145
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg = (void *)0;
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current, msg, FAIL);
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend();
}

# 144 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$allDone$runTask(void)
#line 144
{
  if (Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_ALLDONE, 0xFF, (void *)0, 0, 0) != SUCCESS) {
      Link_TUnitProcessingP$allDone$postTask();
    }
}

# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 342 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline  error_t SerialP$SplitControl$start(void)
#line 342
{
  SerialP$startDoneTask$postTask();
  return SUCCESS;
}

# 79 "/opt/tinyos-2.0/tos/interfaces/SplitControl.nc"
inline static  error_t Link_TUnitProcessingP$SerialSplitControl$start(void){
#line 79
  unsigned char result;
#line 79

#line 79
  result = SerialP$SplitControl$start();
#line 79

#line 79
  return result;
#line 79
}
#line 79
# 66 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   uint8_t Link_TUnitProcessingP$SerialState$getState(void){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$getState(1U);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(am_id_t arg_0x1ad0bbf0, am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(arg_0x1ad0bbf0, arg_0x1ac54e88, arg_0x1ac53068, arg_0x1ac531e8);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 67 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x1acc5460){
#line 67
  unsigned int result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(arg_0x1acc5460);
#line 67

#line 67
  return result;
#line 67
}
#line 67
#line 136
inline static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x1acc38e0){
#line 136
  unsigned char result;
#line 136

#line 136
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(arg_0x1acc38e0);
#line 136

#line 136
  return result;
#line 136
}
#line 136
# 116 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 116
{
  __nesc_hton_uint8((unsigned char *)&/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg)->length, len);
}

# 83 "/opt/tinyos-2.0/tos/interfaces/Packet.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x1acb1530, uint8_t arg_0x1acb16b0){
#line 83
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(arg_0x1acb1530, arg_0x1acb16b0);
#line 83
}
#line 83
# 91 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len)
#line 92
{
  if (clientId > 1) {
#line 93
      return FAIL;
    }
#line 94
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg != (void *)0) {
#line 94
      return EBUSY;
    }
#line 95
  ;

  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg = msg;
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(msg, len);

  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current == /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY) {
      error_t err;
      am_id_t amId = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(msg);
      am_addr_t dest = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(msg);

      ;
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = clientId;

      err = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(amId, dest, msg, len);
      if (err != SUCCESS) {
          ;
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY;
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[clientId].msg = (void *)0;
        }
      return err;
    }
  else {
      ;
    }
  return SUCCESS;
}

# 64 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
inline static  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x1aceaa28, uint8_t arg_0x1aceaba8){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(0U, arg_0x1aceaa28, arg_0x1aceaba8);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 164 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type)
#line 164
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 166
  __nesc_hton_uint8((unsigned char *)&header->type, type);
}

# 151 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x1acc3e58, am_id_t arg_0x1acc1010){
#line 151
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(arg_0x1acc3e58, arg_0x1acc1010);
#line 151
}
#line 151
# 145 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr)
#line 145
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 147
  __nesc_hton_uint16((unsigned char *)&header->dest, addr);
}

# 92 "/opt/tinyos-2.0/tos/interfaces/AMPacket.nc"
inline static  void /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x1acc4010, am_addr_t arg_0x1acc4198){
#line 92
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(arg_0x1acc4010, arg_0x1acc4198);
#line 92
}
#line 92
# 45 "/opt/tinyos-2.0/tos/system/AMQueueEntryP.nc"
static inline  error_t /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(msg, dest);
  /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(msg, 255);
  return /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$send(msg, len);
}

# 69 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  error_t Link_TUnitProcessingP$SerialEventSend$send(am_addr_t arg_0x1ac54e88, message_t *arg_0x1ac53068, uint8_t arg_0x1ac531e8){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(arg_0x1ac54e88, arg_0x1ac53068, arg_0x1ac531e8);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 135 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$sendEventMsg$runTask(void)
#line 135
{
  if (Link_TUnitProcessingP$SerialEventSend$send(0, &Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg], sizeof(TUnitProcessingMsg )) != SUCCESS) {
      if (Link_TUnitProcessingP$SerialState$getState() == Link_TUnitProcessingP$S_OFF) {
          Link_TUnitProcessingP$SerialSplitControl$start();
        }
      Link_TUnitProcessingP$sendEventMsg$postTask();
    }
}

# 306 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline   bool TUnitP$StatsQuery$default$isIdle(void)
#line 306
{
  return TRUE;
}

# 16 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/StatsQuery.nc"
inline static  bool TUnitP$StatsQuery$isIdle(void){
#line 16
  unsigned char result;
#line 16

#line 16
  result = TUnitP$StatsQuery$default$isIdle();
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 61 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/State.nc"
inline static   bool TUnitP$SendState$isIdle(void){
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
# 269 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static inline  void TUnitP$waitForSendDone$runTask(void)
#line 269
{
  if (TUnitP$SendState$isIdle() && TUnitP$StatsQuery$isIdle()) {

      TUnitP$currentTest++;
      TUnitP$attemptTest();
    }
  else {

      TUnitP$waitForSendDone$postTask();
    }
}

# 48 "/opt/tinyos-2.0/tos/types/TinyError.h"
static inline error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 81 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
static inline  error_t StateImplP$Init$init(void)
#line 81
{
  int i;

#line 83
  for (i = 0; i < 5U; i++) {
      StateImplP$state[i] = StateImplP$S_IDLE;
    }
  return SUCCESS;
}

# 214 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 45 "/opt/tinyos-2.0/tos/system/FcfsResourceQueueC.nc"
static inline  error_t /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void)
#line 45
{
  memset(/*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ, /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY, sizeof /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ);
  return SUCCESS;
}

# 51 "/opt/tinyos-2.0/tos/interfaces/Init.nc"
inline static  error_t RealMainP$SoftwareInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*Msp430UsartShare1P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init();
#line 51
  result = ecombine(result, SerialP$Init$init());
#line 51
  result = ecombine(result, StateImplP$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 77 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(am_id_t id, message_t *m)
#line 77
{
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(m, (void *)0);
}

# 125 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(am_id_t arg_0x1ad0bbf0, message_t *arg_0x1ac52df0){
#line 125
  void *result;
#line 125

#line 125
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(arg_0x1ad0bbf0, arg_0x1ac52df0);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 180 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m)
#line 180
{
  return /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(0, m);
}

# 114 "/opt/tinyos-2.0/tos/interfaces/Send.nc"
inline static  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x1ace7ab8){
#line 114
  void *result;
#line 114

#line 114
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(0U, arg_0x1ace7ab8);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 65 "/opt/tinyos-2.0/tos/system/AMQueueEntryP.nc"
static inline  void */*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m)
#line 65
{
  return /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(m);
}

# 125 "/opt/tinyos-2.0/tos/interfaces/AMSend.nc"
inline static  void *Link_TUnitProcessingP$SerialEventSend$getPayload(message_t *arg_0x1ac52df0){
#line 125
  void *result;
#line 125

#line 125
  result = /*Link_TUnitProcessingC.SerialEventSendC.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(arg_0x1ac52df0);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 63 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline  void Link_TUnitProcessingP$Boot$booted(void)
#line 63
{
  int i;

#line 65
  for (i = 0; i < 5; i++) {
      __nesc_hton_uint8((unsigned char *)&((TUnitProcessingMsg *)Link_TUnitProcessingP$SerialEventSend$getPayload(&Link_TUnitProcessingP$eventMsg[i]))->cmd, 0xFF);
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 68
    Link_TUnitProcessingP$writingEventMsg = 0;
#line 68
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 69
    Link_TUnitProcessingP$sendingEventMsg = 0;
#line 69
    __nesc_atomic_end(__nesc_atomic); }
  Link_TUnitProcessingP$SerialSplitControl$start();
}

# 49 "/opt/tinyos-2.0/tos/interfaces/Boot.nc"
inline static  void RealMainP$Boot$booted(void){
#line 49
  Link_TUnitProcessingP$Boot$booted();
#line 49
}
#line 49
# 179 "/opt/tinyos-2.0/tos/chips/msp430/msp430hardware.h"
static inline void __nesc_disable_interrupt(void )
{
   __asm volatile ("dint");
   __asm volatile ("nop");}

# 121 "/opt/tinyos-2.0/tos/chips/msp430/McuSleepC.nc"
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void)
#line 121
{
  return MSP430_POWER_LPM4;
}

# 54 "/opt/tinyos-2.0/tos/interfaces/McuPowerOverride.nc"
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
# 68 "/opt/tinyos-2.0/tos/chips/msp430/McuSleepC.nc"
static inline mcu_power_t McuSleepC$getPowerState(void)
#line 68
{
  mcu_power_t pState = MSP430_POWER_LPM3;





  if (((((
#line 71
  TA0CCTL0 & 0x0010 || 
  TA0CCTL1 & 0x0010) || 
  TA0CCTL2 & 0x0010) && (
  TA0CTL & (3 << 8)) == 2 << 8) || (
  ME1 & ((1 << 7) | (1 << 6)) && U0TCTL & 0x20)) || (
  ME2 & ((1 << 5) | (1 << 4)) && U1TCTL & 0x20)) {






    pState = MSP430_POWER_LPM1;
    }
  if (ADC12CTL1 & 0x0001) {
      if (!(ADC12CTL0 & 0x0080) && (TA0CTL & (3 << 8)) == 2 << 8) {
        pState = MSP430_POWER_LPM1;
        }
      else {
#line 89
        switch (ADC12CTL1 & (3 << 3)) {
            case 2 << 3: 
              pState = MSP430_POWER_ACTIVE;
            break;
            case 3 << 3: 
              pState = MSP430_POWER_LPM1;
            break;
          }
        }
    }
#line 98
  return pState;
}

# 167 "/opt/tinyos-2.0/tos/chips/msp430/msp430hardware.h"
static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)
#line 167
{
  return m1 < m2 ? m1 : m2;
}

# 101 "/opt/tinyos-2.0/tos/chips/msp430/McuSleepC.nc"
static inline void McuSleepC$computePowerState(void)
#line 101
{
  McuSleepC$powerState = mcombine(McuSleepC$getPowerState(), 
  McuSleepC$McuPowerOverride$lowestState());
}

static inline   void McuSleepC$McuSleep$sleep(void)
#line 106
{
  uint16_t temp;

#line 108
  if (McuSleepC$dirty) {
      McuSleepC$computePowerState();
    }

  temp = McuSleepC$msp430PowerBits[McuSleepC$powerState] | 0x0008;
   __asm volatile ("bis  %0, r2" :  : "m"(temp));
  __nesc_disable_interrupt();
}

# 59 "/opt/tinyos-2.0/tos/interfaces/McuSleep.nc"
inline static   void SchedulerBasicP$McuSleep$sleep(void){
#line 59
  McuSleepC$McuSleep$sleep();
#line 59
}
#line 59
# 67 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
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

# 61 "/opt/tinyos-2.0/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$taskLoop(void){
#line 61
  SchedulerBasicP$Scheduler$taskLoop();
#line 61
}
#line 61
# 108 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(uint8_t testId, char *failMsg, uint32_t actual)
#line 108
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED, testId, failMsg, actual, actual);
}

# 13 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testNotEqualsFailed(uint8_t arg_0x1abb89f0, char *arg_0x1abb8b88, uint32_t arg_0x1abb8d10){
#line 13
  Link_TUnitProcessingP$TUnitProcessing$testNotEqualsFailed(arg_0x1abb89f0, arg_0x1abb8b88, arg_0x1abb8d10);
#line 13
}
#line 13
# 112 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(uint8_t testId, char *failMsg, uint32_t upperbound, uint32_t actual)
#line 112
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED, testId, failMsg, upperbound, actual);
}

# 15 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testResultIsBelowFailed(uint8_t arg_0x1abb61e8, char *arg_0x1abb6380, uint32_t arg_0x1abb6510, uint32_t arg_0x1abb6698){
#line 15
  Link_TUnitProcessingP$TUnitProcessing$testResultIsBelowFailed(arg_0x1abb61e8, arg_0x1abb6380, arg_0x1abb6510, arg_0x1abb6698);
#line 15
}
#line 15
# 116 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static inline   void Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(uint8_t testId, char *failMsg, uint32_t lowerbound, uint32_t actual)
#line 116
{
  Link_TUnitProcessingP$insert(TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED, testId, failMsg, lowerbound, actual);
}

# 17 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitProcessing.nc"
inline static   void TUnitP$TUnitProcessing$testResultIsAboveFailed(uint8_t arg_0x1abb6b50, char *arg_0x1abb6ce8, uint32_t arg_0x1abb6e78, uint32_t arg_0x1abb5030){
#line 17
  Link_TUnitProcessingP$TUnitProcessing$testResultIsAboveFailed(arg_0x1abb6b50, arg_0x1abb6ce8, arg_0x1abb6e78, arg_0x1abb5030);
#line 17
}
#line 17
# 154 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   uint8_t /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void)
#line 154
{
  /* atomic removed: atomic calls only */
#line 155
  {
    unsigned char __nesc_temp = 
#line 155
    /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$resId;

#line 155
    return __nesc_temp;
  }
}

# 88 "/opt/tinyos-2.0/tos/interfaces/ArbiterInfo.nc"
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
# 387 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$dataReceived(uint8_t data)
#line 387
{
  SerialP$rx_state_machine(FALSE, data);
}

# 83 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x1ada8010){
#line 83
  SerialP$SerialFrameComm$dataReceived(arg_0x1ada8010);
#line 83
}
#line 83
# 384 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$delimiterReceived(void)
#line 384
{
  SerialP$rx_state_machine(TRUE, 0);
}

# 74 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void){
#line 74
  SerialP$SerialFrameComm$delimiterReceived();
#line 74
}
#line 74
# 61 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
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

# 79 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(uint8_t arg_0x1ae620b8){
#line 79
  HdlcTranslateC$UartStream$receivedByte(arg_0x1ae620b8);
#line 79
}
#line 79
# 116 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$UartStream$receiveDone(uint8_t *buf, uint16_t len, error_t error)
#line 116
{
}

# 99 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(uint8_t *arg_0x1ae62d60, uint16_t arg_0x1ae62ee8, error_t arg_0x1ae61088){
#line 99
  HdlcTranslateC$UartStream$receiveDone(arg_0x1ae62d60, arg_0x1ae62ee8, arg_0x1ae61088);
#line 99
}
#line 99
# 140 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(uint8_t data)
#line 140
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf) {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_pos++] = data;
      if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_pos >= /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_len) {
          uint8_t *buf = /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf;

#line 145
          /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_buf = (void *)0;
          /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receiveDone(buf, /*Msp430Uart1P.UartP*/Msp430UartP$0$m_rx_len, SUCCESS);
        }
    }
  else {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$receivedByte(data);
    }
}

# 65 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data)
#line 65
{
}

# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(uint8_t arg_0x1b20bab8, uint8_t arg_0x1aec1d70){
#line 54
  switch (arg_0x1b20bab8) {
#line 54
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 54
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$rxDone(arg_0x1aec1d70);
#line 54
      break;
#line 54
    default:
#line 54
      /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(arg_0x1b20bab8, arg_0x1aec1d70);
#line 54
      break;
#line 54
    }
#line 54
}
#line 54
# 145 "/opt/tinyos-2.0/tos/system/ArbiterP.nc"
static inline   bool /*Msp430UsartShare1P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void)
#line 145
{
  return TRUE;
}

# 80 "/opt/tinyos-2.0/tos/interfaces/ArbiterInfo.nc"
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
# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data)
#line 54
{
  if (/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(), data);
    }
}

# 54 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart1P$Interrupts$rxDone(uint8_t arg_0x1aec1d70){
#line 54
  /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(arg_0x1aec1d70);
#line 54
}
#line 54
# 391 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 189 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void)
#line 189
{
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 1;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 1;
    }
}

#line 185
static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void)
#line 185
{
  return /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked : /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked;
}

#line 212
static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void)
#line 212
{
  error_t result = SUCCESS;

  /* atomic removed: atomic calls only */
#line 214
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

# 51 "/opt/tinyos-2.0/tos/lib/serial/ReceiveBytePacket.nc"
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
# 309 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 69 "/opt/tinyos-2.0/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x1ad92748){
#line 69
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(arg_0x1ad92748);
#line 69
}
#line 69
# 207 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void)
#line 207
{
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? 0 : 1;
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer = (uint8_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which];
}

# 56 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
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
# 232 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 230 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b)
#line 230
{
  /* atomic removed: atomic calls only */
#line 231
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
#line 252
            ;
      }
  }
}

# 58 "/opt/tinyos-2.0/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x1ad92188){
#line 58
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(arg_0x1ad92188);
#line 58
}
#line 58
# 299 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 55 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$SerialFrameComm$resetReceive(void)
#line 55
{
  HdlcTranslateC$state.receiveEscape = 0;
}

# 68 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
inline static   void SerialP$SerialFrameComm$resetReceive(void){
#line 68
  HdlcTranslateC$SerialFrameComm$resetReceive();
#line 68
}
#line 68
#line 54
inline static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x1adabd50){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HdlcTranslateC$SerialFrameComm$putData(arg_0x1adabd50);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 513 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 60 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
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
# 164 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void)
#line 164
{
  uint8_t b;
  uint8_t indx;

  /* atomic removed: atomic calls only */
#line 167
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

# 70 "/opt/tinyos-2.0/tos/lib/serial/SendBytePacket.nc"
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
# 642 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 89 "/opt/tinyos-2.0/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$putDone(void){
#line 89
  SerialP$SerialFrameComm$putDone();
#line 89
}
#line 89
# 48 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
inline static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x1ae648c0, uint16_t arg_0x1ae64a48){
#line 48
  unsigned char result;
#line 48

#line 48
  result = /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(arg_0x1ae648c0, arg_0x1ae64a48);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 104 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
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

# 57 "/opt/tinyos-2.0/tos/interfaces/UartStream.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(uint8_t *arg_0x1ae63068, uint16_t arg_0x1ae631f0, error_t arg_0x1ae63370){
#line 57
  HdlcTranslateC$UartStream$sendDone(arg_0x1ae63068, arg_0x1ae631f0, arg_0x1ae63370);
#line 57
}
#line 57
# 443 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static inline   void HplMsp430Usart1P$Usart$tx(uint8_t data)
#line 443
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 444
    HplMsp430Usart1P$U1TXBUF = data;
#line 444
    __nesc_atomic_end(__nesc_atomic); }
}

# 236 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(uint8_t arg_0x1aee3b70){
#line 236
  HplMsp430Usart1P$Usart$tx(arg_0x1aee3b70);
#line 236
}
#line 236
# 166 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static inline   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone(void)
#line 166
{
  if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos < /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len) {
      /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos++]);
    }
  else {
      uint8_t *buf = /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf;

#line 172
      /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf = (void *)0;
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$sendDone(buf, /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len, SUCCESS);
    }
}

# 64 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id)
#line 64
{
}

# 49 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(uint8_t arg_0x1b20bab8){
#line 49
  switch (arg_0x1b20bab8) {
#line 49
    case /*PlatformSerialC.UartC.UsartC*/Msp430Usart1C$0$CLIENT_ID:
#line 49
      /*Msp430Uart1P.UartP*/Msp430UartP$0$UsartInterrupts$txDone();
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(arg_0x1b20bab8);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 49 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void)
#line 49
{
  if (/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(/*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId());
    }
}

# 49 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart1P$Interrupts$txDone(void){
#line 49
  /*Msp430UsartShare1P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone();
#line 49
}
#line 49
# 199 "/opt/tinyos-2.0/tos/chips/msp430/msp430hardware.h"
 __nesc_atomic_t __nesc_atomic_start(void )
{
  __nesc_atomic_t result = (({
#line 201
    uint16_t __x;

#line 201
     __asm volatile ("mov	r2, %0" : "=r"((uint16_t )__x));__x;
  }
  )
#line 201
   & 0x0008) != 0;

#line 202
  __nesc_disable_interrupt();
  return result;
}

 void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts)
{
  if (reenable_interrupts) {
    __nesc_enable_interrupt();
    }
}

# 11 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
 __attribute((wakeup)) __attribute((interrupt(12))) void sig_TIMERA0_VECTOR(void)
#line 11
{
#line 11
  Msp430TimerCommonP$VectorTimerA0$fired();
}

# 169 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 12 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
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

# 135 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerP.nc"
static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n)
{
}

# 28 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(uint8_t arg_0x1aa55710){
#line 28
  switch (arg_0x1aa55710) {
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
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(arg_0x1aa55710);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 14 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
 __attribute((wakeup)) __attribute((interrupt(24))) void sig_TIMERB1_VECTOR(void)
#line 14
{
#line 14
  Msp430TimerCommonP$VectorTimerB1$fired();
}

# 52 "/opt/tinyos-2.0/tos/system/RealMainP.nc"
  int main(void)
#line 52
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {






      RealMainP$Scheduler$init();





      RealMainP$PlatformInit$init();
      while (RealMainP$Scheduler$runNextTask()) ;





      RealMainP$SoftwareInit$init();
      while (RealMainP$Scheduler$runNextTask()) ;
    }
#line 76
    __nesc_atomic_end(__nesc_atomic); }


  __nesc_enable_interrupt();

  RealMainP$Boot$booted();


  RealMainP$Scheduler$taskLoop();




  return -1;
}

# 141 "/opt/tinyos-2.0/tos/chips/msp430/timer/Msp430ClockP.nc"
static void Msp430ClockP$set_dco_calib(int calib)
{
  BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
  DCOCTL = calib & 0xff;
}

# 16 "/opt/tinyos-2.0/tos/platforms/telosb/MotePlatformC.nc"
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

# 123 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
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

# 64 "/opt/tinyos-2.0/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x1a890dd8){
#line 64
  switch (arg_0x1a890dd8) {
#line 64
    case TUnitP$waitForSendDone:
#line 64
      TUnitP$waitForSendDone$runTask();
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
    default:
#line 64
      SchedulerBasicP$TaskBasic$default$runTask(arg_0x1a890dd8);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 109 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static   void /*Msp430Uart1P.UartP*/Msp430UartP$0$UartControl$setModeDuplex(uint8_t id)
#line 109
{
  msp430_uart_config_t *config = /*Msp430Uart1P.UartP*/Msp430UartP$0$Msp430UartConfigure$getConfig(id);

#line 111
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_byte_time = config->ubr / 2;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$setModeUart(config);
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$clrIntr();
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$enableIntr();
}

# 251 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
static   void HplMsp430Usart1P$Usart$disableSpi(void)
#line 251
{
  HplMsp430Usart1P$ME2 &= ~(1 << 4);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 253
    {
      HplMsp430Usart1P$SIMO$selectIOFunc();
      HplMsp430Usart1P$SOMI$selectIOFunc();
      HplMsp430Usart1P$UCLK$selectIOFunc();
    }
#line 257
    __nesc_atomic_end(__nesc_atomic); }
}

#line 211
static   void HplMsp430Usart1P$Usart$disableUart(void)
#line 211
{
  HplMsp430Usart1P$ME2 &= ~((1 << 5) | (1 << 4));
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 213
    {
      HplMsp430Usart1P$UTXD$selectIOFunc();
      HplMsp430Usart1P$URXD$selectIOFunc();
    }
#line 216
    __nesc_atomic_end(__nesc_atomic); }
}

# 151 "/opt/tinyos-2.0/tos/system/AMQueueImplP.nc"
static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void)
#line 151
{
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket();
  if (/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current != /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$QUEUE_EMPTY) {
      error_t nextErr;
      message_t *nextMsg = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current].msg;
      am_id_t nextId = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(nextMsg);
      am_addr_t nextDest = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(nextMsg);
      uint8_t len = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(nextMsg);

#line 159
      nextErr = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(nextId, nextDest, nextMsg, len);
      if (nextErr != SUCCESS) {
          /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask();
        }
    }
}

# 135 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg)
#line 135
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 137
  return __nesc_ntoh_uint16((unsigned char *)&header->dest);
}

#line 111
static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg)
#line 111
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg);

#line 113
  return __nesc_ntoh_uint8((unsigned char *)&header->length);
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

# 502 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 159 "/opt/tinyos-2.0/tos/system/SchedulerBasicP.nc"
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

# 89 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static  void Link_TUnitProcessingP$SerialEventSend$sendDone(message_t *msg, error_t error)
#line 89
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 90
    {
      __nesc_hton_uint8((unsigned char *)&((TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg])->data)->cmd, Link_TUnitProcessingP$EMPTY);
      Link_TUnitProcessingP$sendingEventMsg++;
      Link_TUnitProcessingP$sendingEventMsg %= 5;
    }
#line 94
    __nesc_atomic_end(__nesc_atomic); }
  Link_TUnitProcessingP$SendState$toIdle();
  Link_TUnitProcessingP$attemptEventSend();
}

#line 232
static void Link_TUnitProcessingP$attemptEventSend(void)
#line 232
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 233
    {
      if (Link_TUnitProcessingP$SendState$isIdle()) {

          if (__nesc_ntoh_uint8((unsigned char *)&((TUnitProcessingMsg *)(&Link_TUnitProcessingP$eventMsg[Link_TUnitProcessingP$sendingEventMsg])->data)->cmd) != Link_TUnitProcessingP$EMPTY) {

              Link_TUnitProcessingP$SendState$forceState(Link_TUnitProcessingP$S_BUSY);
              Link_TUnitProcessingP$sendEventMsg$postTask();
            }
        }
    }
#line 242
    __nesc_atomic_end(__nesc_atomic); }
}

# 210 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
static void TUnitP$setUpOneTimeDone(void)
#line 210
{
  if (TUnitP$TestState$getState() == TUnitP$S_SETUP_ONETIME) {
      TUnitP$TestState$toIdle();
      if (TUnitP$amAddress() != 0) {
          TUnitP$TestState$forceState(TUnitP$S_RUN);
        }
      else {
          TUnitP$attemptTest();
        }
    }
}

#line 253
static void TUnitP$attemptTest(void)
#line 253
{
  if (TUnitP$currentTest < 3U) {
      if (TUnitP$TestState$requestState(TUnitP$S_SETUP) == SUCCESS) {

          TUnitP$SetUp$run();
        }
    }
  else 
    {
      TUnitP$TUnitState$forceState(TUnitP$S_TEARDOWN_ONETIME);
      TUnitP$TearDownOneTime$run();
    }
}

# 96 "/opt/tinyos-2.0/programs/rincon/tos/lib/state/StateImplP.nc"
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

# 176 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
__attribute((noinline))   void assertFail(char *failMsg)
#line 176
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testFailed(TUnitP$currentTest, failMsg);
    }
}

# 170 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/Link_TUnitProcessingP.nc"
static error_t Link_TUnitProcessingP$insert(uint8_t cmd, uint8_t testId, char *failMsg, uint32_t expected, uint32_t actual)
#line 170
{
  unsigned char __nesc_temp43;
  unsigned char *__nesc_temp42;
#line 171
  TUnitProcessingMsg *tunitMsg;
  bool failed = (((cmd == TUNITPROCESSING_EVENT_TESTRESULT_FAILED
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_EQUALS_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_NOTEQUALS_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_BELOW_FAILED)
   || cmd == TUNITPROCESSING_EVENT_TESTRESULT_ABOVE_FAILED;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 178
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
#line 219
                FAIL;

                {
#line 219
                  __nesc_atomic_end(__nesc_atomic); 
#line 219
                  return __nesc_temp;
                }
              }
            }
        }
    }
#line 224
    __nesc_atomic_end(__nesc_atomic); }
#line 224
  Link_TUnitProcessingP$attemptEventSend();
  return SUCCESS;
}

# 169 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
__attribute((noinline))   void assertSuccess(void)
#line 169
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testSuccess(TUnitP$currentTest);
    }
}

#line 230
static void TUnitP$runDone(void)
#line 230
{
  if (TUnitP$TestState$getState() == TUnitP$S_RUN) {
      TUnitP$TestState$forceState(TUnitP$S_TEARDOWN);
      TUnitP$TearDown$run();
    }
}

#line 145
__attribute((noinline))   void assertEqualsFailed(char *failMsg, uint32_t expected, uint32_t actual)
#line 145
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testEqualsFailed(TUnitP$currentTest, failMsg, expected, actual);
    }
}

# 347 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 86 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void)
#line 86
{
  HdlcTranslateC$state.sendEscape = 0;
  HdlcTranslateC$m_data = HDLC_FLAG_BYTE;
  return HdlcTranslateC$UartStream$send(&HdlcTranslateC$m_data, 1);
}

# 154 "/opt/tinyos-2.0/tos/chips/msp430/usart/Msp430UartP.nc"
static   error_t /*Msp430Uart1P.UartP*/Msp430UartP$0$UartStream$send(uint8_t *buf, uint16_t len)
#line 154
{
  if (len == 0) {
    return FAIL;
    }
  else {
#line 157
    if (/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf) {
      return EBUSY;
      }
    }
#line 159
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_buf = buf;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_len = len;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos = 0;
  /*Msp430Uart1P.UartP*/Msp430UartP$0$Usart$tx(buf[/*Msp430Uart1P.UartP*/Msp430UartP$0$m_tx_pos++]);
  return SUCCESS;
}

# 124 "/opt/tinyos-2.0/tos/lib/serial/SerialActiveMessageP.nc"
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t *len)
#line 124
{
  if (len != (void *)0) {
      *len = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(msg);
    }
  return msg->data;
}

# 151 "/opt/tinyos-2.0/programs/tunit/tos/lib/tunit/TUnitP.nc"
__attribute((noinline))   void assertNotEqualsFailed(char *failMsg, uint32_t actual)
#line 151
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testNotEqualsFailed(TUnitP$currentTest, failMsg, actual);
    }
}

__attribute((noinline))   void assertResultIsBelowFailed(char *failMsg, uint32_t upperbound, uint32_t actual)
#line 157
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testResultIsBelowFailed(TUnitP$currentTest, failMsg, upperbound, actual);
    }
}

__attribute((noinline))   void assertResultIsAboveFailed(char *failMsg, uint32_t lowerbound, uint32_t actual)
#line 163
{
  if (!TUnitP$TUnitState$isIdle()) {
      TUnitP$TUnitProcessing$testResultIsAboveFailed(TUnitP$currentTest, failMsg, lowerbound, actual);
    }
}

# 96 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
 __attribute((wakeup)) __attribute((interrupt(6))) void sig_UART1RX_VECTOR(void)
#line 96
{
  uint8_t temp = U1RXBUF;

#line 98
  HplMsp430Usart1P$Interrupts$rxDone(temp);
}

# 402 "/opt/tinyos-2.0/tos/lib/serial/SerialP.nc"
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

# 52 "/opt/tinyos-2.0/tos/system/crc.h"
static uint16_t crcByte(uint16_t crc, uint8_t b)
{
  uint8_t i;

  crc = crc ^ (b << 8);
  i = 8;
  do 
    if (crc & 0x8000) {
      crc = (crc << 1) ^ 0x1021;
      }
    else {
#line 62
      crc = crc << 1;
      }
  while (
#line 63
  --i);

  return crc;
}

# 282 "/opt/tinyos-2.0/tos/lib/serial/SerialDispatcherP.nc"
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result)
#line 282
{
  uint8_t postsignalreceive = FALSE;

  /* atomic removed: atomic calls only */
#line 284
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

# 101 "/opt/tinyos-2.0/tos/chips/msp430/usart/HplMsp430Usart1P.nc"
 __attribute((wakeup)) __attribute((interrupt(4))) void sig_UART1TX_VECTOR(void)
#line 101
{
  HplMsp430Usart1P$Interrupts$txDone();
}

# 92 "/opt/tinyos-2.0/tos/lib/serial/HdlcTranslateC.nc"
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

