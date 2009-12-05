#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 38 "/usr/msp430/include/sys/inttypes.h"
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
# 385 "/usr/lib/ncc/nesc_nx.h"
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
# 151 "/usr/lib/gcc-lib/msp430/3.2.3/include/stddef.h" 3
typedef int ptrdiff_t;
#line 213
typedef unsigned int size_t;
#line 325
typedef int wchar_t;
# 41 "/usr/msp430/include/sys/types.h"
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
# 43 "/usr/msp430/include/string.h"
extern char *strcat(char *, const char *);




extern size_t strlen(const char *);
#line 64
extern void bzero(void *, size_t );
# 59 "/usr/msp430/include/stdlib.h"
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
# 122 "/usr/msp430/include/sys/config.h" 3
typedef long int __int32_t;
typedef unsigned long int __uint32_t;
# 12 "/usr/msp430/include/sys/_types.h"
typedef long _off_t;
typedef long _ssize_t;
# 28 "/usr/msp430/include/sys/reent.h" 3
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
# 18 "/usr/msp430/include/math.h"
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
# 91 "/opt/tinyos-1.x/tos/system/tos.h"
typedef unsigned char bool;






enum __nesc_unnamed4247 {
  FALSE = 0, 
  TRUE = 1
};

uint16_t TOS_LOCAL_ADDRESS = 1;

enum __nesc_unnamed4248 {
  FAIL = 0, 
  SUCCESS = 1
};


static inline uint8_t rcombine(uint8_t r1, uint8_t r2);
typedef uint8_t result_t  ;







static inline result_t rcombine(result_t r1, result_t r2);
#line 140
enum __nesc_unnamed4249 {
  NULL = 0x0
};
# 39 "/usr/msp430/include/msp430/iostructures.h"
#line 27
typedef union port {
  volatile unsigned char reg_p;
  volatile struct __nesc_unnamed4250 {
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
# 108 "/usr/msp430/include/msp430/iostructures.h" 3
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
# 116 "/usr/msp430/include/msp430/gpio.h" 3
volatile unsigned char P1OUT __asm ("0x0021");

volatile unsigned char P1DIR __asm ("0x0022");



volatile unsigned char P1IES __asm ("0x0024");

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
# 92 "/usr/msp430/include/msp430/usart.h"
volatile unsigned char U0CTL __asm ("0x0070");

volatile unsigned char U0TCTL __asm ("0x0071");



volatile unsigned char U0MCTL __asm ("0x0073");

volatile unsigned char U0BR0 __asm ("0x0074");

volatile unsigned char U0BR1 __asm ("0x0075");

volatile unsigned char U0RXBUF __asm ("0x0076");
#line 275
volatile unsigned char U1CTL __asm ("0x0078");

volatile unsigned char U1TCTL __asm ("0x0079");

volatile unsigned char U1RCTL __asm ("0x007A");

volatile unsigned char U1MCTL __asm ("0x007B");

volatile unsigned char U1BR0 __asm ("0x007C");

volatile unsigned char U1BR1 __asm ("0x007D");

volatile unsigned char U1RXBUF __asm ("0x007E");
# 24 "/usr/msp430/include/msp430/flash.h"
volatile unsigned int FCTL3 __asm ("0x012C");
# 25 "/usr/msp430/include/msp430/timera.h"
volatile unsigned int TA0IV __asm ("0x012E");

volatile unsigned int TA0CTL __asm ("0x0160");

volatile unsigned int TA0R __asm ("0x0170");
# 127 "/usr/msp430/include/msp430/timera.h" 3
#line 118
typedef struct __nesc_unnamed4251 {
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
typedef struct __nesc_unnamed4252 {
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
# 22 "/usr/msp430/include/msp430/timerb.h"
volatile unsigned int TBIV __asm ("0x011E");

volatile unsigned int TBCTL __asm ("0x0180");

volatile unsigned int TBR __asm ("0x0190");


volatile unsigned int TBCCTL0 __asm ("0x0182");





volatile unsigned int TBCCR0 __asm ("0x0192");
#line 76
#line 64
typedef struct __nesc_unnamed4253 {
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
typedef struct __nesc_unnamed4254 {
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
# 20 "/usr/msp430/include/msp430/basic_clock.h"
volatile unsigned char DCOCTL __asm ("0x0056");

volatile unsigned char BCSCTL1 __asm ("0x0057");

volatile unsigned char BCSCTL2 __asm ("0x0058");
# 18 "/usr/msp430/include/msp430/adc12.h"
volatile unsigned int ADC12CTL0 __asm ("0x01A0");

volatile unsigned int ADC12CTL1 __asm ("0x01A2");
#line 42
#line 30
typedef struct __nesc_unnamed4255 {
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
typedef struct __nesc_unnamed4256 {
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
typedef struct __nesc_unnamed4257 {
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
# 65 "/usr/msp430/include/msp430x16x.h"
volatile unsigned char IFG1 __asm ("0x0002");







volatile unsigned char IE2 __asm ("0x0001");









volatile unsigned char ME1 __asm ("0x0004");





volatile unsigned char ME2 __asm ("0x0005");
# 161 "/opt/tinyos-1.x/tos/platform/msp430/msp430hardware.h"
static __inline void TOSH_wait(void );
#line 174
static __inline void TOSH_uwait(uint16_t u);
#line 196
static inline void __nesc_disable_interrupt(void);





static inline void __nesc_enable_interrupt(void);




static inline bool are_interrupts_enabled(void);




typedef bool __nesc_atomic_t;

static inline __nesc_atomic_t __nesc_atomic_start(void );
static inline void __nesc_atomic_end(__nesc_atomic_t oldSreg);



static inline __nesc_atomic_t __nesc_atomic_start(void );






static inline void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts);








 bool LPMode_disabled = FALSE;









static __inline void __nesc_atomic_sleep(void);
# 116 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12.h"
#line 105
typedef struct __nesc_unnamed4258 {

  unsigned int refVolt2_5 : 1;
  unsigned int clockSourceSHT : 2;
  unsigned int clockSourceSAMPCON : 2;
  unsigned int clockDivSAMPCON : 2;
  unsigned int referenceVoltage : 3;
  unsigned int clockDivSHT : 3;
  unsigned int inputChannel : 4;
  unsigned int sampleHoldTime : 4;
  unsigned int  : 0;
} MSP430ADC12Settings_t;






#line 118
typedef enum __nesc_unnamed4259 {

  MSP430ADC12_FAIL = 0, 
  MSP430ADC12_SUCCESS = 1, 
  MSP430ADC12_DELAYED = 2
} msp430ADCresult_t;

enum refVolt2_5_enum {

  REFVOLT_LEVEL_1_5 = 0, 
  REFVOLT_LEVEL_2_5 = 1
};

enum clockDivSHT_enum {

  SHT_CLOCK_DIV_1 = 0, 
  SHT_CLOCK_DIV_2 = 1, 
  SHT_CLOCK_DIV_3 = 2, 
  SHT_CLOCK_DIV_4 = 3, 
  SHT_CLOCK_DIV_5 = 4, 
  SHT_CLOCK_DIV_6 = 5, 
  SHT_CLOCK_DIV_7 = 6, 
  SHT_CLOCK_DIV_8 = 7
};

enum clockDivSAMPCON_enum {

  SAMPCON_CLOCK_DIV_1 = 0, 
  SAMPCON_CLOCK_DIV_2 = 1, 
  SAMPCON_CLOCK_DIV_3 = 2, 
  SAMPCON_CLOCK_DIV_4 = 3
};

enum clockSourceSAMPCON_enum {

  SAMPCON_SOURCE_TACLK = 0, 
  SAMPCON_SOURCE_ACLK = 1, 
  SAMPCON_SOURCE_SMCLK = 2, 
  SAMPCON_SOURCE_INCLK = 3
};

enum inputChannel_enum {


  INPUT_CHANNEL_A0 = 0, 
  INPUT_CHANNEL_A1 = 1, 
  INPUT_CHANNEL_A2 = 2, 
  INPUT_CHANNEL_A3 = 3, 
  INPUT_CHANNEL_A4 = 4, 
  INPUT_CHANNEL_A5 = 5, 
  INPUT_CHANNEL_A6 = 6, 
  INPUT_CHANNEL_A7 = 7, 
  EXTERNAL_REFERENCE_VOLTAGE = 8, 
  REFERENCE_VOLTAGE_NEGATIVE_TERMINAL = 9, 
  INTERNAL_TEMPERATURE = 10, 
  INTERNAL_VOLTAGE = 11
};

enum referenceVoltage_enum {

  REFERENCE_AVcc_AVss = 0, 
  REFERENCE_VREFplus_AVss = 1, 
  REFERENCE_VeREFplus_AVss = 2, 
  REFERENCE_AVcc_VREFnegterm = 4, 
  REFERENCE_VREFplus_VREFnegterm = 5, 
  REFERENCE_VeREFplus_VREFnegterm = 6
};

enum clockSourceSHT_enum {

  SHT_SOURCE_ADC12OSC = 0, 
  SHT_SOURCE_ACLK = 1, 
  SHT_SOURCE_MCLK = 2, 
  SHT_SOURCE_SMCLK = 3
};

enum sampleHold_enum {

  SAMPLE_HOLD_4_CYCLES = 0, 
  SAMPLE_HOLD_8_CYCLES = 1, 
  SAMPLE_HOLD_16_CYCLES = 2, 
  SAMPLE_HOLD_32_CYCLES = 3, 
  SAMPLE_HOLD_64_CYCLES = 4, 
  SAMPLE_HOLD_96_CYCLES = 5, 
  SAMPLE_HOLD_123_CYCLES = 6, 
  SAMPLE_HOLD_192_CYCLES = 7, 
  SAMPLE_HOLD_256_CYCLES = 8, 
  SAMPLE_HOLD_384_CYCLES = 9, 
  SAMPLE_HOLD_512_CYCLES = 10, 
  SAMPLE_HOLD_768_CYCLES = 11, 
  SAMPLE_HOLD_1024_CYCLES = 12
};









#line 216
typedef union __nesc_unnamed4260 {
  uint32_t i;
  MSP430ADC12Settings_t s;
} MSP430ADC12Settings_ut;








enum __nesc_unnamed4261 {

  ADC_IDLE = 0, 
  SINGLE_CHANNEL = 1, 
  REPEAT_SINGLE_CHANNEL = 2, 
  SEQUENCE_OF_CHANNELS = 4, 
  REPEAT_SEQUENCE_OF_CHANNELS = 8, 
  TIMER_USED = 16, 
  RESERVED = 32, 
  VREF_WAIT = 64
};
#line 261
#line 255
typedef struct __nesc_unnamed4262 {

  volatile unsigned 
  inch : 4, 
  sref : 3, 
  eos : 1;
} __attribute((packed))  adc12memctl_t;
#line 274
#line 263
typedef struct __nesc_unnamed4263 {

  unsigned int refVolt2_5 : 1;
  unsigned int gotRefVolt : 1;
  unsigned int result_16bit : 1;
  unsigned int clockSourceSHT : 2;
  unsigned int clockSourceSAMPCON : 2;
  unsigned int clockDivSAMPCON : 2;
  unsigned int clockDivSHT : 3;
  unsigned int sampleHoldTime : 4;
  adc12memctl_t memctl;
} __attribute((packed))  adc12settings_t;
# 58 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Const.h"
enum __nesc_unnamed4264 {
  CC2420_TIME_BIT = 4, 
  CC2420_TIME_BYTE = CC2420_TIME_BIT << 3, 
  CC2420_TIME_SYMBOL = 16
};










uint8_t CC2420_CHANNEL = 20;
uint8_t CC2420_RFPOWER = 2;

enum __nesc_unnamed4265 {
  CC2420_MIN_CHANNEL = 11, 
  CC2420_MAX_CHANNEL = 26
};
#line 261
enum __nesc_unnamed4266 {
  CP_MAIN = 0, 
  CP_MDMCTRL0, 
  CP_MDMCTRL1, 
  CP_RSSI, 
  CP_SYNCWORD, 
  CP_TXCTRL, 
  CP_RXCTRL0, 
  CP_RXCTRL1, 
  CP_FSCTRL, 
  CP_SECCTRL0, 
  CP_SECCTRL1, 
  CP_BATTMON, 
  CP_IOCFG0, 
  CP_IOCFG1
};
# 46 "/opt/tinyos-1.x/tos/platform/telos/AM.h"
enum __nesc_unnamed4267 {
  TOS_BCAST_ADDR = 0xffff, 
  TOS_UART_ADDR = 0x007e
};





enum __nesc_unnamed4268 {
  TOS_DEFAULT_AM_GROUP = 0x7D
};

uint8_t TOS_AM_GROUP = TOS_DEFAULT_AM_GROUP;
#line 95
#line 71
typedef struct TOS_Msg {


  uint8_t length;
  uint8_t fcfhi;
  uint8_t fcflo;
  uint8_t dsn;
  uint16_t destpan;
  uint16_t addr;
  uint8_t type;
  uint8_t group;
  int8_t data[74];







  uint8_t strength;
  uint8_t lqi;
  bool crc;
  bool ack;
  uint16_t time;
} __attribute((packed))  TOS_Msg;

enum __nesc_unnamed4269 {

  MSG_HEADER_SIZE = (size_t )& ((struct TOS_Msg *)0)->data - 1, 

  MSG_FOOTER_SIZE = 2, 

  MSG_DATA_SIZE = (size_t )& ((struct TOS_Msg *)0)->strength + sizeof(uint16_t ), 

  DATA_LENGTH = 74, 

  LENGTH_BYTE_NUMBER = (size_t )& ((struct TOS_Msg *)0)->length + 1
};

typedef TOS_Msg *TOS_MsgPtr;
# 12 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_RED_LED_PIN(void);
#line 12
static inline void TOSH_CLR_RED_LED_PIN(void);
static inline void TOSH_SET_GREEN_LED_PIN(void);
#line 13
static inline void TOSH_CLR_GREEN_LED_PIN(void);
static inline void TOSH_SET_YELLOW_LED_PIN(void);
#line 14
static inline void TOSH_CLR_YELLOW_LED_PIN(void);


static inline void TOSH_SET_RADIO_CSN_PIN(void);
#line 17
static inline void TOSH_CLR_RADIO_CSN_PIN(void);
#line 17
static inline void TOSH_MAKE_RADIO_CSN_OUTPUT(void);







static inline uint8_t TOSH_READ_RADIO_CCA_PIN(void);

static inline uint8_t TOSH_READ_CC_FIFOP_PIN(void);
static inline uint8_t TOSH_READ_CC_FIFO_PIN(void);
static inline uint8_t TOSH_READ_CC_SFD_PIN(void);
#line 29
static inline void TOSH_SEL_CC_SFD_MODFUNC(void);
#line 29
static inline void TOSH_SEL_CC_SFD_IOFUNC(void);
static inline void TOSH_SET_CC_VREN_PIN(void);
static inline void TOSH_SET_CC_RSTN_PIN(void);
#line 31
static inline void TOSH_CLR_CC_RSTN_PIN(void);


static inline void TOSH_SEL_SOMI0_MODFUNC(void);
static inline void TOSH_SET_SIMO0_PIN(void);
#line 35
static inline void TOSH_CLR_SIMO0_PIN(void);
#line 35
static inline void TOSH_MAKE_SIMO0_OUTPUT(void);
#line 35
static inline void TOSH_MAKE_SIMO0_INPUT(void);
#line 35
static inline void TOSH_SEL_SIMO0_MODFUNC(void);
static inline void TOSH_SET_UCLK0_PIN(void);
#line 36
static inline void TOSH_CLR_UCLK0_PIN(void);
#line 36
static inline void TOSH_MAKE_UCLK0_OUTPUT(void);
#line 36
static inline void TOSH_MAKE_UCLK0_INPUT(void);
#line 36
static inline void TOSH_SEL_UCLK0_MODFUNC(void);
static inline void TOSH_SEL_UTXD0_IOFUNC(void);
#line 37
static inline bool TOSH_IS_UTXD0_MODFUNC(void);
#line 37
static inline bool TOSH_IS_UTXD0_IOFUNC(void);
static inline void TOSH_SEL_URXD0_IOFUNC(void);
#line 38
static inline bool TOSH_IS_URXD0_MODFUNC(void);
#line 38
static inline bool TOSH_IS_URXD0_IOFUNC(void);
static inline void TOSH_SEL_UTXD1_MODFUNC(void);
#line 39
static inline void TOSH_SEL_UTXD1_IOFUNC(void);
#line 39
static inline bool TOSH_IS_UTXD1_MODFUNC(void);
#line 39
static inline bool TOSH_IS_UTXD1_IOFUNC(void);
static inline void TOSH_SEL_URXD1_MODFUNC(void);
#line 40
static inline void TOSH_SEL_URXD1_IOFUNC(void);
#line 40
static inline bool TOSH_IS_URXD1_MODFUNC(void);
#line 40
static inline bool TOSH_IS_URXD1_IOFUNC(void);
static inline void TOSH_SEL_UCLK1_IOFUNC(void);
static inline void TOSH_SEL_SOMI1_IOFUNC(void);
static inline void TOSH_SEL_SIMO1_IOFUNC(void);
#line 71
static inline void TOSH_SET_FLASH_CS_PIN(void);
#line 71
static inline void TOSH_CLR_FLASH_CS_PIN(void);
#line 71
static inline void TOSH_MAKE_FLASH_CS_OUTPUT(void);
static inline void TOSH_SET_FLASH_HOLD_PIN(void);
#line 72
static inline void TOSH_CLR_FLASH_HOLD_PIN(void);
#line 72
static inline void TOSH_MAKE_FLASH_HOLD_OUTPUT(void);










static void TOSH_FLASH_M25P_DP_bit(bool set);










static inline void TOSH_FLASH_M25P_DP(void);
#line 129
static inline void TOSH_SET_PIN_DIRECTIONS(void );
# 75 "/home/xu/oasis/system/dbg_modes.h"
typedef long long TOS_dbg_mode;



enum __nesc_unnamed4270 {
  DBG_ALL = ~0ULL, 


  DBG_BOOT = 1ULL << 0, 
  DBG_CLOCK = 1ULL << 1, 
  DBG_TASK = 1ULL << 2, 
  DBG_SCHED = 1ULL << 3, 
  DBG_SENSOR = 1ULL << 4, 
  DBG_LED = 1ULL << 5, 
  DBG_CRYPTO = 1ULL << 6, 


  DBG_ROUTE = 1ULL << 7, 
  DBG_AM = 1ULL << 8, 
  DBG_CRC = 1ULL << 9, 
  DBG_PACKET = 1ULL << 10, 
  DBG_ENCODE = 1ULL << 11, 
  DBG_RADIO = 1ULL << 12, 


  DBG_LOG = 1ULL << 13, 
  DBG_ADC = 1ULL << 14, 
  DBG_I2C = 1ULL << 15, 
  DBG_UART = 1ULL << 16, 
  DBG_PROG = 1ULL << 17, 
  DBG_SOUNDER = 1ULL << 18, 
  DBG_TIME = 1ULL << 19, 
  DBG_POWER = 1ULL << 20, 



  DBG_SIM = 1ULL << 21, 
  DBG_QUEUE = 1ULL << 22, 
  DBG_SIMRADIO = 1ULL << 23, 
  DBG_HARD = 1ULL << 24, 
  DBG_MEM = 1ULL << 25, 



  DBG_USR1 = 1ULL << 27, 
  DBG_USR2 = 1ULL << 28, 
  DBG_USR3 = 1ULL << 29, 
  DBG_TEMP = 1ULL << 30, 

  DBG_ERROR = 1ULL << 31, 
  DBG_NONE = 0, 

  DBG_DEFAULT = DBG_ALL, 


  DBG_ERR = 1ULL << 63, 
  DBG_UTIL = 1ULL << 62, 
  DBG_NETWORKCOMM = 1ULL << 61, 

  DBG_GENERICCOMMPRO = 1ULL << 61, 


  DBG_ROUTEMANAGE = 1ULL << 60, 
  DBG_SINKCAST = 1ULL << 59, 
  DBG_BROADCAST = 1ULL << 58, 

  DBG_TRANSPORTRDT = 1ULL << 57, 

  DBG_CAS = 1ULL << 56, 

  DBG_TMAC = 1ULL << 55, 
  DBG_TOPO = 1ULL << 54, 

  DBG_SNMS = 1ULL << 53, 

  DBG_SENSING = 1ULL << 52, 
  DBG_MULTIHOPENGINE = 1ULL << 51, 
  DBG_RDT = 1ULL << 50, 
  DBG_NEIGHBORMGMT = 1ULL << 49, 
  DBG_WF = 1ULL << 48, 
  DBG_DV = 1ULL << 47, 
  DBG_TSYNC = 1ULL << 46, 
  DBG_APP = 1ULL << 32, 

  DBG_MIDWARE = 1ULL << 36
};
# 61 "/opt/tinyos-1.x/tos/system/sched.c"
#line 59
typedef struct __nesc_unnamed4271 {
  void (*tp)(void);
} TOSH_sched_entry_T;

enum __nesc_unnamed4272 {




  TOSH_MAX_TASKS = 1 << 8, 



  TOSH_TASK_BITMASK = TOSH_MAX_TASKS - 1
};

volatile TOSH_sched_entry_T TOSH_queue[TOSH_MAX_TASKS];
uint8_t TOSH_sched_full;
volatile uint8_t TOSH_sched_free;

static inline void TOSH_sched_init(void );








bool TOS_post(void (*tp)(void));
#line 102
bool TOS_post(void (*tp)(void))  ;
#line 136
static inline bool TOSH_run_next_task(void);
#line 159
static inline void TOSH_run_task(void);
# 149 "/opt/tinyos-1.x/tos/system/tos.h"
static void *nmemcpy(void *to, const void *from, size_t n);









static inline void *nmemset(void *to, int val, size_t n);
# 28 "/opt/tinyos-1.x/tos/system/Ident.h"
enum __nesc_unnamed4273 {

  IDENT_MAX_PROGRAM_NAME_LENGTH = 16
};






#line 33
typedef struct __nesc_unnamed4274 {

  uint32_t unix_time;
  uint32_t user_hash;
  char program_name[IDENT_MAX_PROGRAM_NAME_LENGTH];
} Ident_t;
#line 52
static const Ident_t G_Ident = { 
.unix_time = 0x49ecaa47L, 
.user_hash = 0x4c6e9f74L, 
.program_name = "OasisApp" };
# 48 "/home/xu/oasis/system/OasisType.h"
typedef uint16_t address_t;
#line 83
enum TosType {
  AM_NETWORKMSG = 129, 
  AM_ROUTEBEACONMSG = 130, 
  AM_NEIGHBORBEACONMSG = 131, 
  AM_CASCTRLMSG = 132, 
  AM_CASCADESMSG = 133
};
#line 107
#line 94
typedef struct NetworkMsg {
  address_t linksource;
  uint8_t type;
  uint8_t ttl : 5, qos : 3;
  union  {
    struct  {
      address_t dest;
      address_t source;
    } __attribute((packed))  ;
    uint32_t crc;
  } __attribute((packed))  ;
  uint16_t seqno;
  uint8_t data[0];
} __attribute((packed))  NetworkMsg;



enum NetType {
  NW_DATA = 1, 
  NW_SNMS = 2, 
  NW_RPCR = 3, 
  NW_RPCC = 4, 
  NW_RDTACK = 5
};







#line 121
typedef enum __nesc_unnamed4275 {
  ADDR_SINK = 0xfd, 
  ADDR_MCAST = 0xfe, 
  ADDR_BCAST = 0xff
} OasisAddr_t;
#line 158
#line 153
typedef struct ApplicationMsg {
  uint8_t type;
  uint8_t length;
  uint16_t seqno;
  uint8_t data[0];
} __attribute((packed))  ApplicationMsg;


enum AppType {

  TYPE_DATA_SEISMIC = 0, 
  TYPE_DATA_INFRASONIC = 1, 
  TYPE_DATA_LIGHTNING = 2, 
  TYPE_DATA_RSAM1 = 3, 
  TYPE_DATA_RVOL = 4, 
  TYPE_DATA_TEMP = 5, 
  TYPE_DATA_ACCELX = 6, 
  TYPE_DATA_ACCELY = 7, 
  TYPE_DATA_MAGX = 8, 
  TYPE_DATA_MAGY = 9, 
  TYPE_DATA_MIC = 10, 
  TYPE_DATA_RSAM2 = 17, 
  TYPE_DATA_COMPRESS = 18, 
  TYPE_DATA_TREMOR = 19, 




  TYPE_DATA_GPS = 28, 
  TYPE_SNMS_EVENT = 11, 
  TYPE_SNMS_RPCCOMMAND = 12, 
  TYPE_SNMS_RPCRESPONSE = 13, 
  TYPE_SNMS_CODE = 14
};









enum EventType {
  EVENT_TYPE_ALL = 0, 
  EVENT_TYPE_SNMS = 1, 
  EVENT_TYPE_SENSING = 2, 
  EVENT_TYPE_MIDDLEWARE = 3, 
  EVENT_TYPE_ROUTING = 4, 
  EVENT_TYPE_MAC = 5
};


enum TypeRange {
  EVENT_TYPE_VALUE_MIN = 0, 
  EVENT_TYPE_VALUE_MAX = 5
};


enum EventLevel {
  EVENT_LEVEL_URGENT = 0, 
  EVENT_LEVEL_HIGH = 1, 
  EVENT_LEVEL_MEDIUM = 2, 
  EVENT_LEVEL_LOW = 3
};


enum LevelRange {
  EVENT_LEVEL_VALUE_MIN = 0, 
  EVENT_LEVEL_VALUE_MAX = 3
};

enum EventSendFailType {
  BUFFER_FAIL = 2, 
  FILTER_FAIL = 3
};
# 65 "/home/xu/oasis/lib/MultiHopOasis/MultiHop.h"
enum __nesc_unnamed4276 {
  AM_BEACONMSG = 250
};






#line 69
typedef struct BeaconMsg {
  uint16_t parent;
  uint16_t parent_dup;
  uint16_t cost;
  uint16_t hopcount;
} __attribute((packed))  BeaconMsg;
# 28 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.h"
enum __nesc_unnamed4277 {
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
typedef struct __nesc_unnamed4278 {

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
} MSP430CompareControl_t;
#line 76
#line 66
typedef struct __nesc_unnamed4279 {

  int taifg : 1;
  int taie : 1;
  int taclr : 1;
  int _unused0 : 1;
  int mc : 2;
  int id : 2;
  int tassel : 2;
  int _unused1 : 6;
} MSP430TimerAControl_t;
#line 91
#line 78
typedef struct __nesc_unnamed4280 {

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
} MSP430TimerBControl_t;
# 43 "/usr/lib/gcc-lib/msp430/3.2.3/include/stdarg.h"
typedef __builtin_va_list __gnuc_va_list;
# 110 "/usr/lib/gcc-lib/msp430/3.2.3/include/stdarg.h" 3
typedef __gnuc_va_list va_list;
# 59 "/home/xu/oasis/lib/SNMS/Event.h"
#line 54
typedef struct EventMsg {
  uint8_t type;
  uint8_t level;
  uint8_t length;
  uint8_t data[0];
} __attribute((packed))  EventMsg;



uint8_t gTempEventBuf[80];
uint8_t gTempScratch[16];

static inline uint8_t *eventprintf(const uint8_t *format, ...);
# 39 "/home/xu/oasis/lib/Rpc/Rpc.h"
struct __nesc_attr_rpc {
};


enum rpcMsgs {
  AM_RPCCOMMANDMSG = 211, 
  AM_RPCRESPONSEMSG = 212
};



enum rpcErrorCodes {
  RPC_SUCCESS = 0, 
  RPC_GARBAGE_ARGS = 1, 
  RPC_RESPONSE_TOO_LARGE = 2, 
  RPC_PROCEDURE_UNAVAIL = 3, 
  RPC_SYSTEM_ERR = 4, 
  RPC_WRONG_XML_FILE = 5
};
#line 72
#line 59
typedef struct RpcCommandMsg {
  uint8_t transactionID;

  uint8_t commandID;
  uint8_t responseDesired;
  uint8_t dataLength;

  uint16_t address;
  uint16_t returnAddress;

  uint32_t unix_time;
  uint32_t user_hash;
  uint8_t data[0];
} __attribute((packed))  RpcCommandMsg;









#line 74
typedef struct RpcResponseMsg {
  uint8_t transactionID;

  uint8_t commandID;
  uint16_t sourceAddress;
  uint8_t errorCode;
  uint8_t dataLength;
  uint8_t data[0];
} __attribute((packed))  RpcResponseMsg;
# 31 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
enum __nesc_unnamed4281 {

  MAX_BUFFER_SIZE = 56, 







  MEM_QUEUE_SIZE = 20, 




  NUM_STATUS = 6
};







#line 48
typedef enum __nesc_unnamed4282 {
  FREEMEM = 0, 
  FILLING = 1, 
  FILLED = 2, 
  MEMPROCESSING = 3, 
  MEMPENDING = 4, 
  MEMCOMPRESSING = 5
} MemStatus_t;
#line 70
#line 58
typedef struct SensorBlkMgmt_t {
  uint32_t time;
  uint16_t taskCode;
  uint16_t interval;
  uint8_t compressnum;
  int16_t next;
  int16_t prev;
  uint8_t size;
  uint8_t priority;
  uint8_t status;
  uint8_t type;
  uint8_t buffer[MAX_BUFFER_SIZE];
} SensorBlkMgmt_t;

typedef SensorBlkMgmt_t *SenBlkPtr;







#line 74
typedef struct MemQueue_t {
  int16_t size;
  int16_t total;
  int16_t head[NUM_STATUS];
  int16_t tail[NUM_STATUS];
  SensorBlkMgmt_t element[MEM_QUEUE_SIZE];
} MemQueue_t;

static result_t _private_changeMemStatusByIndex(MemQueue_t *queue, int16_t ind, MemStatus_t status1, MemStatus_t status2);







static inline result_t initSenorMem(MemQueue_t *queue, uint16_t size);
#line 125
static SenBlkPtr headMemElement(MemQueue_t *queue, MemStatus_t status);
#line 147
static SenBlkPtr getMemElementByIndex(MemQueue_t *queue, int16_t ind);
#line 161
static inline SenBlkPtr allocSensorMem(MemQueue_t *bufQueue);
#line 194
static inline result_t freeSensorMem(MemQueue_t *queue, SenBlkPtr obj);
#line 247
static result_t changeMemStatus(MemQueue_t *queue, SenBlkPtr obj, MemStatus_t status1, MemStatus_t status2);
#line 263
static result_t _private_changeMemStatusByIndex(MemQueue_t *queue, int16_t ind, MemStatus_t status1, MemStatus_t status2);
# 33 "/home/xu/oasis/lib/SmartSensing/Sensing.h"
enum SamplingRate {
  SEISMIC_RATE = 50, 
  INFRASONIC_RATE = 50, 
  LIGHTNING_RATE = 1, 
  RVOL_RATE = 1
};

enum SamplingPriority {
  SEISMIC_DATA_PRIORITY = 0x2, 
  INFRASONIC_DATA_PRIORITY = 0x1, 
  LIGHTNING_DATA_PRIORITY = 0x6, 
  RVOL_DATA_PRIORITY = 0x1, 
  GPS_DATA_PRIORITY = 0x3, 
  RSAM1_DATA_PRIORITY = 0x7, 
  RSAM2_DATA_PRIORITY = 0x6
};

enum SensorConfig {
  MAX_SENSOR_NUM = 16, 
  MAX_SAMPLING_RATE = 1000UL, 
  MAX_DATA_WIDTH = 2, 



  MAX_SENSING_QUEUE_SIZE = 4, 


  MAX_RSAM_WIN_SIZE = 60, 




  MAX_STA_PERIOD = 2, 




  MAX_LTA_PERIOD = 30, 



  TASK_MASK = 0x000f, 
  TASK_CODE_SIZE = 4, 
  TSTAMPOFFSET = 4, 
  ONE_MS = 1000UL, 
  BATCH_TIMER_INTERVAL = 500UL, 
  VOL_TIMER_INTERVAL = 60000UL
};

enum Special_Sensor {
  GPS_CLIENT_ID = 0, 
  RSAM1_CLIENT_ID = 1, 
  RSAM2_CLIENT_ID = 2, 
  COMPRESS_CLIENT_ID = 7, 



  GPS_BLK_NUM = 0, 




  RSAM_BLK_NUM = 2
};


enum sensing_flash {
  BLANK = 0x2fff, 
  WRITTEN = 0x4fff, 
  IDLE = 0xffff, 
  BASE_ADDR = 0x220000
};
#line 116
#line 106
typedef struct SensorClient {
  SenBlkPtr curBlkPtr;
  uint16_t samplingRate;
  uint16_t timerCount;
  uint8_t channel;
  uint8_t type;
  uint8_t dataPriority;
  uint8_t nodePriority;
  uint8_t maxBlkNum;
  uint8_t curBlkNum;
} SensorClient_t;






#line 118
typedef struct TimeStamp {
  uint32_t minute : 6, 
  second : 6, 
  millisec : 10, 
  interval : 10;
} __attribute((packed))  TimeStamp_t;


 SensorClient_t sensor[MAX_SENSOR_NUM];
 uint8_t sensor_num = 0;
# 31 "/home/xu/oasis/system/platform/telosb/ADC/Hamamatsu.h"
enum __nesc_unnamed4283 {

  TOS_ADC_PAR_PORT = 0U, 

  TOSH_ACTUAL_ADC_PAR_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A4
};
#line 48
enum __nesc_unnamed4284 {

  TOS_ADC_TSR_PORT = 1U, 

  TOSH_ACTUAL_ADC_TSR_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A5
};
# 42 "/home/xu/oasis/system/platform/telosb/ADC/InternalTemp.h"
enum __nesc_unnamed4285 {

  TOS_ADC_INTERNAL_TEMP_PORT = 2U, 
  TOSH_ACTUAL_ADC_INTERNAL_TEMPERATURE_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INTERNAL_TEMPERATURE
};
# 42 "/home/xu/oasis/system/platform/telosb/ADC/InternalVoltage.h"
enum __nesc_unnamed4286 {

  TOS_ADC_INTERNAL_VOLTAGE_PORT = 3U, 
  TOSH_ACTUAL_ADC_INTERNAL_VOLTAGE_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INTERNAL_VOLTAGE
};
# 42 "/home/xu/oasis/system/platform/telosb/ADC/adcChannel.h"
enum __nesc_unnamed4287 {

  TOS_ADC_CHANNEL_A0_PORT = 4U, 
  TOSH_ACTUAL_ADC_CHANNEL_A0_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A0
};










enum __nesc_unnamed4288 {

  TOS_ADC_CHANNEL_A1_PORT = 5U, 
  TOSH_ACTUAL_ADC_CHANNEL_A1_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A1
};









enum __nesc_unnamed4289 {

  TOS_ADC_CHANNEL_A4_PORT = 6U, 
  TOSH_ACTUAL_ADC_CHANNEL_A4_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A4
};










enum __nesc_unnamed4290 {

  TOS_ADC_CHANNEL_A6_PORT = 7U, 
  TOSH_ACTUAL_ADC_CHANNEL_A6_PORT = (((REFVOLT_LEVEL_1_5 << 3) + REFERENCE_VREFplus_AVss) << 4) + INPUT_CHANNEL_A6
};
# 35 "/opt/tinyos-1.x/tos/interfaces/ADC.h"
enum __nesc_unnamed4291 {
  TOS_ADCSample3750ns = 0, 
  TOS_ADCSample7500ns = 1, 
  TOS_ADCSample15us = 2, 
  TOS_ADCSample30us = 3, 
  TOS_ADCSample60us = 4, 
  TOS_ADCSample120us = 5, 
  TOS_ADCSample240us = 6, 
  TOS_ADCSample480us = 7
};
# 39 "/opt/tinyos-1.x/tos/interfaces/Timer.h"
enum __nesc_unnamed4292 {
  TIMER_REPEAT = 0, 
  TIMER_ONE_SHOT = 1, 
  NUM_TIMERS = 12U
};
# 35 "/home/xu/oasis/system/RTClock.h"
#line 28
typedef struct RTClock {

  uint16_t millisecond;
  uint8_t hour;
  uint8_t minute;
  uint8_t second;
  uint8_t packed;
} RTClock_t;







#line 37
typedef struct SyncUser {

  uint32_t fireCount;
  uint32_t syncInterval;
  uint8_t type;
  uint8_t id;
} SyncUser_t;










enum __nesc_unnamed4293 {
  MAX_NUM_CLIENT = 12, 
  GPS_SYNC = 0, 
  FTSP_SYNC = 1, 
  UC_FIRE_INTERVAL = 1000UL, 
  DAY_END = 86400000UL, 
  HOUR_END = 3600000UL, 

  DEFAULT_SYNC_MODE = 1
};
# 61 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncMsg.h"
#line 25
typedef struct TimeSyncMsg {

  uint16_t nodeID;
  uint16_t rootID;
  uint16_t seqNum;
#line 47
  uint8_t hasGPS;
  uint8_t wroteStamp;
  uint32_t sendingTime;










  uint32_t arrivalTime;
} __attribute((packed))  TimeSyncMsg;

enum __nesc_unnamed4294 {
  AM_TIMESYNCMSG = 0xAA, 
  TIMESYNCMSG_LEN = sizeof(TimeSyncMsg ) - sizeof(uint32_t ), 
  TS_TIMER_MODE = 0, 
  TS_USER_MODE = 1, 





  TIMESYNC_LENGTH_SENDFIELDS = 5
};
# 31 "/home/xu/oasis/system/queue.h"
enum __nesc_unnamed4295 {










  MAX_QUEUE_SIZE = 5, 



  NUM_OBJSTATUS = 3
};

typedef TOS_Msg object_type;





#line 51
typedef enum __nesc_unnamed4296 {
  FREE = 0, 
  PENDING = 1, 
  PROCESSING = 2
} ObjStatus_t;
#line 68
#line 57
typedef struct Element_t {
  int16_t next;
  int16_t prev;
  uint8_t status;
  uint8_t retry;
  uint8_t priority;
  uint8_t dummy;
  object_type *obj;
} 


Element_t;








#line 70
typedef struct Queue_t {
  int16_t size;
  int16_t total;
  int16_t head[NUM_OBJSTATUS];
  int16_t tail[NUM_OBJSTATUS];
  Element_t element[MAX_QUEUE_SIZE];
} 
Queue_t;


static void _private_changeElementStatusByIndex(Queue_t *queue, int16_t ind, ObjStatus_t status1, ObjStatus_t staus2);

static inline void _private_reorderElementByPriority(Queue_t *queue, int16_t ind);







static result_t initQueue(Queue_t *queue, uint16_t size);
#line 146
static result_t insertElement(Queue_t *queue, object_type *obj);
#line 202
static inline result_t insertElementPri(Queue_t *queue, object_type *obj, uint8_t priority);
#line 257
static inline void _private_reorderElementByPriority(Queue_t *queue, int16_t ind);
#line 307
static result_t removeElement(Queue_t *queue, object_type *obj);
#line 368
static object_type *headElement(Queue_t *queue, ObjStatus_t status);









static inline object_type *tailElement(Queue_t *queue, ObjStatus_t status);








static inline uint8_t getRetryCount(object_type **object);









static inline bool incRetryCount(object_type **object);
#line 468
static object_type **findObject(Queue_t *queue, object_type *obj);
#line 496
static result_t changeElementStatus(Queue_t *queue, object_type *obj, ObjStatus_t status1, ObjStatus_t status2);
#line 559
static void _private_changeElementStatusByIndex(Queue_t *queue, int16_t ind, ObjStatus_t status1, ObjStatus_t status2);
# 31 "/home/xu/oasis/system/buffer.h"
enum __nesc_unnamed4297 {
  FREEBUF = PENDING, 
  BUSYBUF = PROCESSING
};









static result_t initBufferPool(Queue_t *bufQueue, uint16_t size, TOS_Msg *bufPool);
#line 66
static TOS_MsgPtr allocBuffer(Queue_t *bufQueue);
#line 86
static result_t freeBuffer(Queue_t *bufQueue, TOS_MsgPtr buf);
# 4 "/home/xu/oasis/lib/GenericCommPro/QosRexmit.h"
enum __nesc_unnamed4298 {
  QOS_LEVEL = 7
};

static inline uint8_t qosRexmit(uint8_t qos);
# 50 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
enum __nesc_unnamed4299 {

  COMM_SEND_QUEUE_SIZE = 5, 


  COMM_RECV_QUEUE_SIZE = 5
};


enum __nesc_unnamed4300 {
  RADIO = 1, 
  UART = 2, 
  COMM_WDT_UPDATE_PERIOD = 10, 
  COMM_WDT_UPDATE_UNIT = 1024 * 60
};
# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
static __inline int is_host_lsb(void);





static __inline uint16_t toLSB16(uint16_t a);




static __inline uint16_t fromLSB16(uint16_t a);
# 39 "/opt/tinyos-1.x/tos/platform/msp430/msp430usart.h"
#line 31
typedef enum __nesc_unnamed4301 {

  USART_NONE = 0, 
  USART_UART = 1, 
  USART_UART_TX = 2, 
  USART_UART_RX = 3, 
  USART_SPI = 4, 
  USART_I2C = 5
} msp430_usartmode_t;
# 31 "/opt/tinyos-1.x/tos/platform/msp430/crc.h"
uint16_t const ccitt_crc16_table[256] = { 
0x0000, 0x1021, 0x2042, 0x3063, 0x4084, 0x50a5, 0x60c6, 0x70e7, 
0x8108, 0x9129, 0xa14a, 0xb16b, 0xc18c, 0xd1ad, 0xe1ce, 0xf1ef, 
0x1231, 0x0210, 0x3273, 0x2252, 0x52b5, 0x4294, 0x72f7, 0x62d6, 
0x9339, 0x8318, 0xb37b, 0xa35a, 0xd3bd, 0xc39c, 0xf3ff, 0xe3de, 
0x2462, 0x3443, 0x0420, 0x1401, 0x64e6, 0x74c7, 0x44a4, 0x5485, 
0xa56a, 0xb54b, 0x8528, 0x9509, 0xe5ee, 0xf5cf, 0xc5ac, 0xd58d, 
0x3653, 0x2672, 0x1611, 0x0630, 0x76d7, 0x66f6, 0x5695, 0x46b4, 
0xb75b, 0xa77a, 0x9719, 0x8738, 0xf7df, 0xe7fe, 0xd79d, 0xc7bc, 
0x48c4, 0x58e5, 0x6886, 0x78a7, 0x0840, 0x1861, 0x2802, 0x3823, 
0xc9cc, 0xd9ed, 0xe98e, 0xf9af, 0x8948, 0x9969, 0xa90a, 0xb92b, 
0x5af5, 0x4ad4, 0x7ab7, 0x6a96, 0x1a71, 0x0a50, 0x3a33, 0x2a12, 
0xdbfd, 0xcbdc, 0xfbbf, 0xeb9e, 0x9b79, 0x8b58, 0xbb3b, 0xab1a, 
0x6ca6, 0x7c87, 0x4ce4, 0x5cc5, 0x2c22, 0x3c03, 0x0c60, 0x1c41, 
0xedae, 0xfd8f, 0xcdec, 0xddcd, 0xad2a, 0xbd0b, 0x8d68, 0x9d49, 
0x7e97, 0x6eb6, 0x5ed5, 0x4ef4, 0x3e13, 0x2e32, 0x1e51, 0x0e70, 
0xff9f, 0xefbe, 0xdfdd, 0xcffc, 0xbf1b, 0xaf3a, 0x9f59, 0x8f78, 
0x9188, 0x81a9, 0xb1ca, 0xa1eb, 0xd10c, 0xc12d, 0xf14e, 0xe16f, 
0x1080, 0x00a1, 0x30c2, 0x20e3, 0x5004, 0x4025, 0x7046, 0x6067, 
0x83b9, 0x9398, 0xa3fb, 0xb3da, 0xc33d, 0xd31c, 0xe37f, 0xf35e, 
0x02b1, 0x1290, 0x22f3, 0x32d2, 0x4235, 0x5214, 0x6277, 0x7256, 
0xb5ea, 0xa5cb, 0x95a8, 0x8589, 0xf56e, 0xe54f, 0xd52c, 0xc50d, 
0x34e2, 0x24c3, 0x14a0, 0x0481, 0x7466, 0x6447, 0x5424, 0x4405, 
0xa7db, 0xb7fa, 0x8799, 0x97b8, 0xe75f, 0xf77e, 0xc71d, 0xd73c, 
0x26d3, 0x36f2, 0x0691, 0x16b0, 0x6657, 0x7676, 0x4615, 0x5634, 
0xd94c, 0xc96d, 0xf90e, 0xe92f, 0x99c8, 0x89e9, 0xb98a, 0xa9ab, 
0x5844, 0x4865, 0x7806, 0x6827, 0x18c0, 0x08e1, 0x3882, 0x28a3, 
0xcb7d, 0xdb5c, 0xeb3f, 0xfb1e, 0x8bf9, 0x9bd8, 0xabbb, 0xbb9a, 
0x4a75, 0x5a54, 0x6a37, 0x7a16, 0x0af1, 0x1ad0, 0x2ab3, 0x3a92, 
0xfd2e, 0xed0f, 0xdd6c, 0xcd4d, 0xbdaa, 0xad8b, 0x9de8, 0x8dc9, 
0x7c26, 0x6c07, 0x5c64, 0x4c45, 0x3ca2, 0x2c83, 0x1ce0, 0x0cc1, 
0xef1f, 0xff3e, 0xcf5d, 0xdf7c, 0xaf9b, 0xbfba, 0x8fd9, 0x9ff8, 
0x6e17, 0x7e36, 0x4e55, 0x5e74, 0x2e93, 0x3eb2, 0x0ed1, 0x1ef0 };


static uint16_t crcByte(uint16_t fcs, uint8_t c);
# 19 "/opt/tinyos-1.x/tos/platform/msp430/msp430baudrates.h"
enum __nesc_unnamed4302 {

  UBR_ACLK_1200 = 0x001B, UMCTL_ACLK_1200 = 0x94, 
  UBR_ACLK_1800 = 0x0012, UMCTL_ACLK_1800 = 0x84, 
  UBR_ACLK_2400 = 0x000D, UMCTL_ACLK_2400 = 0x6D, 
  UBR_ACLK_4800 = 0x0006, UMCTL_ACLK_4800 = 0x77, 
  UBR_ACLK_9600 = 0x0003, UMCTL_ACLK_9600 = 0x29, 


  UBR_SMCLK_1200 = 0x0369, UMCTL_SMCLK_1200 = 0x7B, 
  UBR_SMCLK_1800 = 0x0246, UMCTL_SMCLK_1800 = 0x55, 
  UBR_SMCLK_2400 = 0x01B4, UMCTL_SMCLK_2400 = 0xDF, 
  UBR_SMCLK_4800 = 0x00DA, UMCTL_SMCLK_4800 = 0xAA, 
  UBR_SMCLK_9600 = 0x006D, UMCTL_SMCLK_9600 = 0x44, 
  UBR_SMCLK_19200 = 0x0036, UMCTL_SMCLK_19200 = 0xB5, 
  UBR_SMCLK_38400 = 0x001B, UMCTL_SMCLK_38400 = 0x94, 
  UBR_SMCLK_57600 = 0x0012, UMCTL_SMCLK_57600 = 0x84, 
  UBR_SMCLK_76800 = 0x000D, UMCTL_SMCLK_76800 = 0x6D, 
  UBR_SMCLK_115200 = 0x0009, UMCTL_SMCLK_115200 = 0x10, 
  UBR_SMCLK_230400 = 0x0004, UMCTL_SMCLK_230400 = 0x55, 
  UBR_SMCLK_262144 = 4, UMCTL_SMCLK_262144 = 0
};
# 33 "/home/xu/oasis/lib/RamSymbols/RamSymbols.h"
enum __nesc_unnamed4303 {

  MAX_RAM_SYMBOL_SIZE = 74 - (size_t )& ((NetworkMsg *)0)->data - 
  (size_t )& ((ApplicationMsg *)0)->data - (size_t )& ((RpcCommandMsg *)0)->data - sizeof(uint32_t ) - sizeof(uint8_t ) - sizeof(bool ), 
  AM_RAMSYMBOL_T = 134
};
#line 53
#line 42
typedef struct ramSymbol_t {


  uint16_t memAddress;




  uint8_t length;
  bool dereference;
  uint8_t data[MAX_RAM_SYMBOL_SIZE];
} __attribute((packed))  ramSymbol_t;
# 11 "/opt/tinyos-1.x/tos/platform/msp430/ADCHIL.h"
#line 6
typedef enum __nesc_unnamed4304 {

  ADC_SUCCESS = 0, 
  ADC_FAIL = 1
} 
adcresult_t;
# 23 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.h"
#line 18
typedef enum __nesc_unnamed4305 {

  REFERENCE_1_5V, 
  REFERENCE_2_5V, 
  REFERENCE_UNSTABLE
} RefVolt_t;
# 33 "/home/xu/oasis/lib/Cascades/Cascades.h"
enum CascadesEnum {
  MAX_CAS_BUF = 1, 

  DEFAULT_DTCOUNT = 4, 




  MAX_CAS_RETRY_COUNT = 6, 



  MAX_CAS_PACKETS = 64, 
  CAS_SEND_QUEUE_SIZE = 3, 
  INVALID_INDEX = 100, 
  MIN_INTERVAL = 50, 
  MAX_NUM_CHILDREN = 16
};








#line 52
typedef struct CasCtrlMsg {
  address_t linkSource;
  address_t parent;
  uint16_t dataSeq;
  uint8_t type;
  uint8_t dummy;
  uint8_t data[0];
} __attribute((packed))  CasCtrlMsg;






#line 61
typedef struct childrenList {

  address_t childID;
  uint8_t status;
  uint8_t dummy;
} __attribute((packed))  childrenList_t;









#line 69
typedef struct CascadesBuffer {
  TOS_Msg tmsg;
  childrenList_t childrenList[MAX_NUM_CHILDREN];
  uint8_t countDT;
  uint8_t retry;
  uint8_t signalDone;
  uint8_t dummy;
} __attribute((packed))  CascadesBuffer;

enum CascadesType {
  TYPE_CASCADES_NODATA = 17, 
  TYPE_CASCADES_ACK = 18, 
  TYPE_CASCADES_REQ = 19, 
  TYPE_CASCADES_CMAU = 20
};
# 20 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmt.h"
#line 5
typedef struct NBRTableEntry {
  uint16_t id;
  uint16_t parentCost;
  uint16_t linkEst;
  uint16_t linkEstCandidate;
  uint8_t flags;
  uint8_t relation;
  uint8_t liveliness;
  uint8_t childLiveliness;
  uint16_t priorHop;
  uint8_t lqi_raw;
  uint8_t rssi_raw;
} 


NBRTableEntry;









enum __nesc_unnamed4306 {
  NBRFLAG_VALID = 0x01, 
  NBRFLAG_NEW = 0x02, 
  NBRFLAG_JUST_UPDATED = 0x04
};

enum relation {
  NBR_DIRECT_CHILD = 0x01, 
  NBR_CHILD = 0x02, 
  NBR_PARENT = 0x04, 
  NBR_NEIGHBOR = 0x08
};

enum __nesc_unnamed4307 {
  LIVELINESS = 8, 
  CHILD_LIVELINESS = 8, 
  ROUTE_INVALID = 0xff, 
  ADDRESS_INVALID = 0xffff
};
# 30 "/opt/tinyos-1.x/tos/platform/msp430/HPLInitM.nc"
static  result_t HPLInitM$init(void);
# 29 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockInit.nc"
static  void MSP430ClockM$MSP430ClockInit$default$initTimerB(void);


static  void MSP430ClockM$MSP430ClockInit$defaultInitTimerA(void);
#line 28
static  void MSP430ClockM$MSP430ClockInit$default$initTimerA(void);




static  void MSP430ClockM$MSP430ClockInit$defaultInitTimerB(void);
#line 27
static  void MSP430ClockM$MSP430ClockInit$default$initClocks(void);



static  void MSP430ClockM$MSP430ClockInit$defaultInitClocks(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MSP430ClockM$StdControl$init(void);






static  result_t MSP430ClockM$StdControl$start(void);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430DCOCalibM$Timer32khz$overflow(void);
#line 33
static   void MSP430DCOCalibM$TimerMicro$overflow(void);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlA2$getControl(void);
#line 30
static   MSP430CompareControl_t MSP430TimerM$ControlB0$getControl(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureA1$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureA1$default$captured(uint16_t arg_0x408cb858);
#line 32
static   uint16_t MSP430TimerM$CaptureB3$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB3$default$captured(uint16_t arg_0x408cb858);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA1$setEvent(uint16_t arg_0x408d6eb0);

static   void MSP430TimerM$CompareB3$setEventFromNow(uint16_t arg_0x408d5830);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureB6$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB6$default$captured(uint16_t arg_0x408cb858);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlB4$getControl(void);







static   void MSP430TimerM$ControlB4$enableEvents(void);
#line 35
static   void MSP430TimerM$ControlB4$setControlAsCompare(void);



static   void MSP430TimerM$ControlB4$disableEvents(void);
#line 32
static   void MSP430TimerM$ControlB4$clearPendingInterrupt(void);
#line 30
static   MSP430CompareControl_t MSP430TimerM$ControlA0$getControl(void);



static   void MSP430TimerM$ControlA0$setControl(MSP430CompareControl_t arg_0x408c29a8);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureB1$getEvent(void);
#line 56
static   void MSP430TimerM$CaptureB1$clearOverflow(void);
#line 51
static   bool MSP430TimerM$CaptureB1$isOverflowPending(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB1$default$fired(void);
# 36 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void MSP430TimerM$ControlB1$setControlAsCapture(bool arg_0x408c0190);
#line 30
static   MSP430CompareControl_t MSP430TimerM$ControlB1$getControl(void);







static   void MSP430TimerM$ControlB1$enableEvents(void);
static   void MSP430TimerM$ControlB1$disableEvents(void);
#line 32
static   void MSP430TimerM$ControlB1$clearPendingInterrupt(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureA2$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureA2$default$captured(uint16_t arg_0x408cb858);
#line 32
static   uint16_t MSP430TimerM$CaptureB4$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB4$default$captured(uint16_t arg_0x408cb858);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlB2$getControl(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA2$default$fired(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430TimerM$TimerA$clear(void);

static   void MSP430TimerM$TimerA$setClockSource(uint16_t arg_0x408b88a8);
#line 38
static   void MSP430TimerM$TimerA$disableEvents(void);
#line 35
static   void MSP430TimerM$TimerA$setMode(int arg_0x408b9aa0);




static   void MSP430TimerM$TimerA$setInputDivider(uint16_t arg_0x408b8d60);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB4$setEventFromNow(uint16_t arg_0x408d5830);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlA1$getControl(void);



static   void MSP430TimerM$ControlA1$setControl(MSP430CompareControl_t arg_0x408c29a8);
#line 30
static   MSP430CompareControl_t MSP430TimerM$ControlB5$getControl(void);







static   void MSP430TimerM$ControlB5$enableEvents(void);
#line 35
static   void MSP430TimerM$ControlB5$setControlAsCompare(void);



static   void MSP430TimerM$ControlB5$disableEvents(void);
#line 32
static   void MSP430TimerM$ControlB5$clearPendingInterrupt(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureA0$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureA0$default$captured(uint16_t arg_0x408cb858);
#line 32
static   uint16_t MSP430TimerM$CaptureB2$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB2$default$captured(uint16_t arg_0x408cb858);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA0$setEvent(uint16_t arg_0x408d6eb0);



static   void MSP430TimerM$CompareB2$default$fired(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureB5$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB5$default$captured(uint16_t arg_0x408cb858);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlB3$getControl(void);







static   void MSP430TimerM$ControlB3$enableEvents(void);
#line 35
static   void MSP430TimerM$ControlB3$setControlAsCompare(void);



static   void MSP430TimerM$ControlB3$disableEvents(void);
#line 32
static   void MSP430TimerM$ControlB3$clearPendingInterrupt(void);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   uint16_t MSP430TimerM$TimerB$read(void);
static   bool MSP430TimerM$TimerB$isOverflowPending(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB5$setEventFromNow(uint16_t arg_0x408d5830);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   uint16_t MSP430TimerM$CaptureB0$getEvent(void);
#line 74
static   void MSP430TimerM$CaptureB0$default$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB6$default$fired(void);
#line 34
static   void MSP430TimerM$CompareB0$default$fired(void);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   MSP430CompareControl_t MSP430TimerM$ControlB6$getControl(void);
# 35 "/home/xu/oasis/interfaces/SensingConfig.nc"
static  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t arg_0x40a044a8, uint8_t arg_0x40a04638);

static  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t arg_0x40a04ad0);
#line 31
static  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t arg_0x40a06948, uint8_t arg_0x40a06ad0);
#line 27
static  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t arg_0x40a07e08, uint16_t arg_0x40a06010);





static  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t arg_0x40a04010);
#line 29
static  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t arg_0x40a064b0);
#line 43
static  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t arg_0x40a037b0, uint16_t arg_0x40a03940);
#line 39
static  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t arg_0x40a03010);





static  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t arg_0x40a03de8);
#line 41
static  uint8_t SmartSensingM$SensingConfig$getNodePriority(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$SensingTimer$fired(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr arg_0x40a2b4e0, result_t arg_0x40a2b670);
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t SmartSensingM$ADC$dataReady(
# 63 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
uint8_t arg_0x40a7cd80, 
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0x40a7c788);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SmartSensingM$StdControl$init(void);






static  result_t SmartSensingM$StdControl$start(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t NoLeds$Leds$greenToggle(void);
#line 131
static   result_t NoLeds$Leds$yellowToggle(void);
#line 81
static   result_t NoLeds$Leds$redToggle(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t RandomLFSR$Random$rand(void);
#line 57
static   result_t RandomLFSR$Random$init(void);
# 42 "/home/xu/oasis/interfaces/RealTime.nc"
static  bool RealTimeM$RealTime$isSync(void);
#line 40
static  result_t RealTimeM$RealTime$setTimeCount(uint32_t arg_0x40ab48c8, uint8_t arg_0x40ab4a50);



static  uint8_t RealTimeM$RealTime$getMode(void);
#line 39
static  uint32_t RealTimeM$RealTime$getTimeCount(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t RealTimeM$LocalTime$read(void);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void RealTimeM$MSP430Timer$overflow(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void RealTimeM$MSP430Compare$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RealTimeM$StdControl$init(void);






static  result_t RealTimeM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$default$fired(
# 30 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
uint8_t arg_0x40b35650);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$start(
# 30 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
uint8_t arg_0x40b35650, 
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t RealTimeM$Timer$stop(
# 30 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
uint8_t arg_0x40b35650);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280);
# 36 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
static   uint32_t TimeSyncM$GlobalTime$getLocalTime(void);






static   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b50150);
#line 60
static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *arg_0x40b50718);
# 20 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
static  void TimeSyncM$TimeSyncNotify$default$msg_received(void);





static  void TimeSyncM$TimeSyncNotify$default$msg_sent(void);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t TimeSyncM$SendMsg$sendDone(TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimeSyncM$StdControl$init(void);






static  result_t TimeSyncM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimeSyncM$Timer$fired(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t TimerM$TimerMilli$default$fired(
# 32 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c468b0);
# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t TimerM$TimerMilli$setOneShot(
# 32 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c468b0, 
# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
int32_t arg_0x40c2c340);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t TimerM$LocalTime$read(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void TimerM$AlarmCompare$fired(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerJiffy.nc"
static  result_t TimerM$TimerJiffy$default$fired(
# 33 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c444e0);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void TimerM$AlarmTimer$overflow(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimerM$StdControl$init(void);






static  result_t TimerM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$default$fired(
# 31 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c46118);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$start(
# 31 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c46118, 
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t TimerM$Timer$stop(
# 31 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c46118);
# 78 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$setRFPower(uint8_t arg_0x40d0a8a0)  ;
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$ReceiveMsg$default$receive(
# 71 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40cdd5b8, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40bd2280);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$ActivityTimer$fired(void);
# 79 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  uint8_t GenericCommProM$getRFPower(void)  ;
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$UARTSend$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010);
# 76 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$setRFChannel(uint8_t arg_0x40cddeb8)  ;
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$RadioReceive$receive(TOS_MsgPtr arg_0x40bd2280);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$Control$init(void);






static  result_t GenericCommProM$Control$start(void);
# 77 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  uint8_t GenericCommProM$getRFChannel(void)  ;
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$RadioSend$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t GenericCommProM$SendMsg$send(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40cdef00, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
static  result_t GenericCommProM$SendMsg$default$sendDone(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40cdef00, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$UARTReceive$receive(TOS_MsgPtr arg_0x40bd2280);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$SplitControl$default$initDone(void);
#line 64
static  result_t CC2420RadioM$SplitControl$init(void);
#line 85
static  result_t CC2420RadioM$SplitControl$default$startDone(void);
#line 77
static  result_t CC2420RadioM$SplitControl$start(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420RadioM$FIFOP$fired(void);
# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t CC2420RadioM$BackoffTimerJiffy$fired(void);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t CC2420RadioM$Send$send(TOS_MsgPtr arg_0x40d018a0);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacControl.nc"
static   void CC2420RadioM$MacControl$enableAck(void);
# 53 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t CC2420RadioM$SFD$captured(uint16_t arg_0x40dbedc8);
# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t arg_0x40dcddb0, uint8_t *arg_0x40dcc010);
#line 39
static   result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t arg_0x40dcd640, uint8_t *arg_0x40dcd7e8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420RadioM$StdControl$init(void);






static  result_t CC2420RadioM$StdControl$start(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
static   int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr arg_0x40d999b8);
static   int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr arg_0x40d99e78);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$CC2420SplitControl$initDone(void);
#line 85
static  result_t CC2420RadioM$CC2420SplitControl$startDone(void);
#line 64
static  result_t CC2420ControlM$SplitControl$init(void);
#line 77
static  result_t CC2420ControlM$SplitControl$start(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420ControlM$CCA$fired(void);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t arg_0x40e225a0, uint8_t arg_0x40e22728, uint8_t *arg_0x40e228d0);
# 120 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static   result_t CC2420ControlM$CC2420Control$VREFOn(void);
#line 185
static  uint8_t CC2420ControlM$CC2420Control$GetRFPower(void);
#line 206
static   result_t CC2420ControlM$CC2420Control$enableAddrDecode(void);
#line 178
static  result_t CC2420ControlM$CC2420Control$SetRFPower(uint8_t arg_0x40d15950);
#line 192
static   result_t CC2420ControlM$CC2420Control$enableAutoAck(void);
#line 84
static  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t arg_0x40d19a30);
#line 163
static   result_t CC2420ControlM$CC2420Control$RxMode(void);
#line 94
static  result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t arg_0x40d18030);
#line 220
static  result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t arg_0x40d12348);
#line 106
static  uint8_t CC2420ControlM$CC2420Control$GetPreset(void);
#line 134
static   result_t CC2420ControlM$CC2420Control$OscillatorOn(void);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t arg_0x40da30b0);
#line 54
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t arg_0x40da59c0, uint16_t arg_0x40da5b50);
#line 47
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t arg_0x40da54b0);
# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t arg_0x40d9cec0, uint8_t *arg_0x40dcd088);
#line 19
static   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t arg_0x40d9c6a8, uint8_t *arg_0x40d9c850);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t arg_0x40e23d00, uint8_t arg_0x40e23e88, uint8_t *arg_0x40e22068);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HPLCC2420M$StdControl$init(void);






static  result_t HPLCC2420M$StdControl$start(void);
# 39 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static  result_t HPLCC2420M$BusArbitration$busFree(void);
# 43 "/opt/tinyos-1.x/tos/platform/msp430/HPLI2CInterrupt.nc"
static   void HPLUSART0M$HPLI2CInterrupt$default$fired(void);
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
static   result_t HPLUSART0M$USARTData$default$rxDone(uint8_t arg_0x40ee6c40);
#line 46
static   result_t HPLUSART0M$USARTData$default$txDone(void);
# 191 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
static   result_t HPLUSART0M$USARTControl$isTxEmpty(void);
#line 130
static   bool HPLUSART0M$USARTControl$isSPI(void);
#line 85
static   void HPLUSART0M$USARTControl$disableUART(void);
#line 75
static   bool HPLUSART0M$USARTControl$isUART(void);
#line 159
static   bool HPLUSART0M$USARTControl$isI2C(void);
#line 172
static   result_t HPLUSART0M$USARTControl$disableRxIntr(void);
static   result_t HPLUSART0M$USARTControl$disableTxIntr(void);
#line 65
static   bool HPLUSART0M$USARTControl$isUARTtx(void);
#line 125
static   void HPLUSART0M$USARTControl$disableI2C(void);









static   void HPLUSART0M$USARTControl$setModeSPI(void);
#line 52
static   msp430_usartmode_t HPLUSART0M$USARTControl$getMode(void);
#line 180
static   result_t HPLUSART0M$USARTControl$isTxIntrPending(void);
#line 202
static   result_t HPLUSART0M$USARTControl$tx(uint8_t arg_0x40e95850);






static   uint8_t HPLUSART0M$USARTControl$rx(void);
#line 185
static   result_t HPLUSART0M$USARTControl$isRxIntrPending(void);
#line 70
static   bool HPLUSART0M$USARTControl$isUARTrx(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420InterruptM$FIFO$default$fired(void);







static   result_t HPLCC2420InterruptM$FIFOP$disable(void);
#line 43
static   result_t HPLCC2420InterruptM$FIFOP$startWait(bool arg_0x40dc68a0);
# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void HPLCC2420InterruptM$CCAInterrupt$fired(void);
#line 59
static   void HPLCC2420InterruptM$FIFOInterrupt$fired(void);
# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420InterruptM$CCA$startWait(bool arg_0x40dc68a0);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void HPLCC2420InterruptM$SFDCapture$captured(uint16_t arg_0x408cb858);
# 60 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t HPLCC2420InterruptM$SFD$disable(void);
#line 43
static   result_t HPLCC2420InterruptM$SFD$enableCapture(bool arg_0x40dbe808);
# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void HPLCC2420InterruptM$FIFOPInterrupt$fired(void);
#line 40
static   void MSP430InterruptM$Port14$clear(void);
#line 35
static   void MSP430InterruptM$Port14$disable(void);
#line 54
static   void MSP430InterruptM$Port14$edge(bool arg_0x40f36350);
#line 30
static   void MSP430InterruptM$Port14$enable(void);









static   void MSP430InterruptM$Port26$clear(void);
#line 59
static   void MSP430InterruptM$Port26$default$fired(void);
#line 40
static   void MSP430InterruptM$Port17$clear(void);
#line 59
static   void MSP430InterruptM$Port17$default$fired(void);
#line 40
static   void MSP430InterruptM$Port21$clear(void);
#line 59
static   void MSP430InterruptM$Port21$default$fired(void);
#line 40
static   void MSP430InterruptM$Port12$clear(void);
#line 59
static   void MSP430InterruptM$Port12$default$fired(void);
#line 40
static   void MSP430InterruptM$Port24$clear(void);
#line 59
static   void MSP430InterruptM$Port24$default$fired(void);
#line 40
static   void MSP430InterruptM$ACCV$clear(void);
#line 59
static   void MSP430InterruptM$ACCV$default$fired(void);
#line 40
static   void MSP430InterruptM$Port15$clear(void);
#line 59
static   void MSP430InterruptM$Port15$default$fired(void);
#line 40
static   void MSP430InterruptM$Port27$clear(void);
#line 59
static   void MSP430InterruptM$Port27$default$fired(void);
#line 40
static   void MSP430InterruptM$Port10$clear(void);
#line 35
static   void MSP430InterruptM$Port10$disable(void);
#line 54
static   void MSP430InterruptM$Port10$edge(bool arg_0x40f36350);
#line 30
static   void MSP430InterruptM$Port10$enable(void);









static   void MSP430InterruptM$Port22$clear(void);
#line 59
static   void MSP430InterruptM$Port22$default$fired(void);
#line 40
static   void MSP430InterruptM$OF$clear(void);
#line 59
static   void MSP430InterruptM$OF$default$fired(void);
#line 40
static   void MSP430InterruptM$Port13$clear(void);
#line 35
static   void MSP430InterruptM$Port13$disable(void);




static   void MSP430InterruptM$Port25$clear(void);
#line 59
static   void MSP430InterruptM$Port25$default$fired(void);
#line 40
static   void MSP430InterruptM$Port16$clear(void);
#line 59
static   void MSP430InterruptM$Port16$default$fired(void);
#line 40
static   void MSP430InterruptM$NMI$clear(void);
#line 59
static   void MSP430InterruptM$NMI$default$fired(void);
#line 40
static   void MSP430InterruptM$Port20$clear(void);
#line 59
static   void MSP430InterruptM$Port20$default$fired(void);
#line 40
static   void MSP430InterruptM$Port11$clear(void);
#line 59
static   void MSP430InterruptM$Port11$default$fired(void);
#line 40
static   void MSP430InterruptM$Port23$clear(void);
#line 59
static   void MSP430InterruptM$Port23$default$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t BusArbitrationM$StdControl$init(void);






static  result_t BusArbitrationM$StdControl$start(void);
# 39 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static  result_t BusArbitrationM$BusArbitration$default$busFree(
# 31 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
uint8_t arg_0x40ffcf08);
# 38 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static   result_t BusArbitrationM$BusArbitration$releaseBus(
# 31 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
uint8_t arg_0x40ffcf08);
# 37 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static   result_t BusArbitrationM$BusArbitration$getBus(
# 31 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
uint8_t arg_0x40ffcf08);
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t arg_0x40db7d10);



static   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);
#line 8
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void TimerJiffyAsyncM$AlarmCompare$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimerJiffyAsyncM$StdControl$init(void);






static  result_t TimerJiffyAsyncM$StdControl$start(void);
# 122 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t LedsC$Leds$yellowOff(void);
#line 114
static   result_t LedsC$Leds$yellowOn(void);
#line 97
static   result_t LedsC$Leds$greenOff(void);
#line 72
static   result_t LedsC$Leds$redOff(void);
#line 106
static   result_t LedsC$Leds$greenToggle(void);
#line 131
static   result_t LedsC$Leds$yellowToggle(void);
#line 81
static   result_t LedsC$Leds$redToggle(void);
#line 64
static   result_t LedsC$Leds$redOn(void);
#line 89
static   result_t LedsC$Leds$greenOn(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t FramerM$ByteComm$txDone(void);
#line 75
static   result_t FramerM$ByteComm$txByteReady(bool arg_0x4106d4d8);
#line 66
static   result_t FramerM$ByteComm$rxByteReady(uint8_t arg_0x4106eb30, bool arg_0x4106ecb8, uint16_t arg_0x4106ee50);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t FramerM$BareSendMsg$send(TOS_MsgPtr arg_0x40d018a0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FramerM$StdControl$init(void);






static  result_t FramerM$StdControl$start(void);
# 88 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x41076710);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280);
# 75 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x41077eb0, uint8_t arg_0x41076068);
# 88 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
static   result_t UARTM$HPLUART$get(uint8_t arg_0x410c4c58);







static   result_t UARTM$HPLUART$putDone(void);
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t UARTM$ByteComm$txByte(uint8_t arg_0x4106e5e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t UARTM$Control$init(void);






static  result_t UARTM$Control$start(void);
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
static   result_t HPLUARTM$USARTData$rxDone(uint8_t arg_0x40ee6c40);
#line 46
static   result_t HPLUARTM$USARTData$txDone(void);
# 62 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
static   result_t HPLUARTM$UART$init(void);
#line 80
static   result_t HPLUARTM$UART$put(uint8_t arg_0x410c46c0);
# 130 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
static   bool HPLUSART1M$USARTControl$isSPI(void);
#line 115
static   void HPLUSART1M$USARTControl$disableSPI(void);
#line 169
static   void HPLUSART1M$USARTControl$setClockRate(uint16_t arg_0x40e98918, uint8_t arg_0x40e98aa0);
#line 85
static   void HPLUSART1M$USARTControl$disableUART(void);
#line 167
static   void HPLUSART1M$USARTControl$setClockSource(uint8_t arg_0x40e98460);
#line 75
static   bool HPLUSART1M$USARTControl$isUART(void);
#line 174
static   result_t HPLUSART1M$USARTControl$enableRxIntr(void);
#line 159
static   bool HPLUSART1M$USARTControl$isI2C(void);
#line 175
static   result_t HPLUSART1M$USARTControl$enableTxIntr(void);
#line 65
static   bool HPLUSART1M$USARTControl$isUARTtx(void);
#line 52
static   msp430_usartmode_t HPLUSART1M$USARTControl$getMode(void);
#line 202
static   result_t HPLUSART1M$USARTControl$tx(uint8_t arg_0x40e95850);
#line 153
static   void HPLUSART1M$USARTControl$setModeUART(void);
#line 70
static   bool HPLUSART1M$USARTControl$isUARTrx(void);
# 51 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static  result_t SNMSM$ledsOn(uint8_t arg_0x4113aa38)  ;
static  void SNMSM$restart(void)  ;
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SNMSM$StdControl$init(void);






static  result_t SNMSM$StdControl$start(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t EventReportM$EventReport$default$eventSendDone(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x41169e18, 
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
TOS_MsgPtr arg_0x40a2b4e0, result_t arg_0x40a2b670);
#line 37
static  uint8_t EventReportM$EventReport$eventSend(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x41169e18, 
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
uint8_t arg_0x40a2ca80, 
uint8_t arg_0x40a2cc18, 
uint8_t *arg_0x40a2cdd0);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t EventReportM$EventSend$sendDone(TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 47 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
static  uint8_t EventReportM$EventConfig$getReportLevel(uint8_t arg_0x41143ec0);
#line 38
static  result_t EventReportM$EventConfig$setReportLevel(uint8_t arg_0x41143778, uint8_t arg_0x41143900);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t EventReportM$StdControl$init(void);






static  result_t EventReportM$StdControl$start(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr arg_0x40a0f130, void *arg_0x40a0f2d0, uint16_t arg_0x40a0f468);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RpcM$StdControl$init(void);






static  result_t RpcM$StdControl$start(void);
# 71 "/home/xu/oasis/lib/MultiHopOasis/RouteSelect.nc"
static  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr arg_0x411f8238, uint8_t arg_0x411f83c0, uint8_t arg_0x411f8548);
#line 86
static  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr arg_0x411f8b58, uint8_t arg_0x411f8ce0);
# 2 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
static  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool arg_0x41197068);

static  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void);
#line 3
static  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t arg_0x41197510);


static  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void);
#line 5
static  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x41197cc0);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopLQI$Timer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280);
# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t arg_0x41231718, uint16_t arg_0x412318b0, bool arg_0x41231a40);
#line 2
static  result_t MultiHopLQI$MultihopCtrl$switchParent(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr arg_0x40a2b4e0, result_t arg_0x40a2b670);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopLQI$StdControl$init(void);






static  result_t MultiHopLQI$StdControl$start(void);
# 116 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
static  bool MultiHopLQI$RouteControl$isSink(void);
#line 109
static  result_t MultiHopLQI$RouteControl$releaseParent(void);
#line 84
static  uint16_t MultiHopLQI$RouteControl$getQuality(void);
#line 107
static  result_t MultiHopLQI$RouteControl$setParent(uint16_t arg_0x40ac6178);
#line 49
static  uint16_t MultiHopLQI$RouteControl$getParent(void);
#line 94
static  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t arg_0x40ac87d8);
# 33 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
static  ramSymbol_t RamSymbolsM$peek(unsigned int arg_0x41298828, uint8_t arg_0x412989b0, bool arg_0x41298b40)  ;
#line 32
static  unsigned int RamSymbolsM$poke(ramSymbol_t *arg_0x41298240)  ;
# 41 "/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
static   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658);
#line 33
static   void ClockTimeStampingM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t ClockTimeStampingM$HPLCC2420RAM$writeDone(uint16_t arg_0x40e225a0, uint8_t arg_0x40e22728, uint8_t *arg_0x40e228d0);
# 39 "/home/xu/oasis/interfaces/TimeStamping.nc"
static  result_t ClockTimeStampingM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40bcab20, uint32_t *arg_0x40bcacd8);
# 29 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
static  result_t DataMgmtM$DataMgmt$freeBlk(void *arg_0x40ad2c28);
#line 28
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t arg_0x40ad2760);



static  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t arg_0x40ad0bf0);
#line 30
static  result_t DataMgmtM$DataMgmt$saveBlk(void *arg_0x40ad0110, uint8_t arg_0x40ad02a0);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t DataMgmtM$BatchTimer$fired(void);
#line 73
static  result_t DataMgmtM$SysCheckTimer$fired(void);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t DataMgmtM$StdControl$init(void);






static  result_t DataMgmtM$StdControl$start(void);
# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
static  result_t ADCM$ADCControl$bindPort(uint8_t arg_0x40a94cf8, uint8_t arg_0x40a94e80);
#line 50
static  result_t ADCM$ADCControl$init(void);
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   result_t ADCM$MSP430ADC12Single$dataReady(uint16_t arg_0x4133cdc8);
# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t ADCM$ADC$getData(
# 47 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
uint8_t arg_0x41345b10);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t ADCM$StdControl$init(void);






static  result_t ADCM$StdControl$start(void);
# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
static   result_t HamamatsuM$TSRSingle$default$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8);
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   result_t HamamatsuM$MSP430ADC12SingleTSR$dataReady(uint16_t arg_0x4133cdc8);
#line 131
static   result_t HamamatsuM$MSP430ADC12SinglePAR$dataReady(uint16_t arg_0x4133cdc8);
# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   uint16_t *HamamatsuM$MSP430ADC12MultipleTSR$dataReady(uint16_t *arg_0x413b0010, uint16_t arg_0x413b01a0);
# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
static   uint16_t *HamamatsuM$TSRMultiple$default$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0);
# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   uint16_t *HamamatsuM$MSP430ADC12MultiplePAR$dataReady(uint16_t *arg_0x413b0010, uint16_t arg_0x413b01a0);
# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
static   uint16_t *HamamatsuM$PARMultiple$default$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0);
# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
static   result_t HamamatsuM$PARSingle$default$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430ADC12M$CompareA1$fired(void);
# 127 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
static  void MSP430ADC12M$RefVolt$isStable(RefVolt_t arg_0x413e8578);
# 65 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   msp430ADCresult_t MSP430ADC12M$ADCSingle$getData(
# 41 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bcd90);
# 50 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static  result_t MSP430ADC12M$ADCSingle$bind(
# 41 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bcd90, 
# 50 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
MSP430ADC12Settings_t arg_0x4133e958);
#line 117
static   result_t MSP430ADC12M$ADCSingle$unreserve(
# 41 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bcd90);
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   result_t MSP430ADC12M$ADCSingle$default$dataReady(
# 41 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bcd90, 
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
uint16_t arg_0x4133cdc8);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430ADC12M$TimerA$overflow(void);
# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   msp430ADCresult_t MSP430ADC12M$ADCMultiple$getData(
# 42 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bb8d8, 
# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
uint16_t *arg_0x413b57e8, uint16_t arg_0x413b5978, uint16_t arg_0x413b5b08);
#line 167
static   uint16_t *MSP430ADC12M$ADCMultiple$default$dataReady(
# 42 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bb8d8, 
# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
uint16_t *arg_0x413b0010, uint16_t arg_0x413b01a0);
# 61 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void MSP430ADC12M$HPLADC12$memOverflow(void);

static   void MSP430ADC12M$HPLADC12$converted(uint8_t arg_0x413f8a00);
#line 62
static   void MSP430ADC12M$HPLADC12$timeOverflow(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430ADC12M$CompareA0$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MSP430ADC12M$StdControl$init(void);






static  result_t MSP430ADC12M$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void HPLADC12M$HPLADC12$setRefOff(void);
#line 58
static   void HPLADC12M$HPLADC12$resetIFGs(void);






static   bool HPLADC12M$HPLADC12$isBusy(void);
#line 43
static   void HPLADC12M$HPLADC12$setControl1(adc12ctl1_t arg_0x413fc4e8);
#line 76
static   void HPLADC12M$HPLADC12$setRef2_5V(void);



static   void HPLADC12M$HPLADC12$disableConversion(void);
#line 48
static   void HPLADC12M$HPLADC12$setControl0_IgnoreRef(adc12ctl0_t arg_0x413fa010);
#line 72
static   void HPLADC12M$HPLADC12$setRefOn(void);
#line 51
static   adc12memctl_t HPLADC12M$HPLADC12$getMemControl(uint8_t arg_0x413fab10);
#line 75
static   void HPLADC12M$HPLADC12$setRef1_5V(void);





static   void HPLADC12M$HPLADC12$startConversion(void);
#line 52
static   uint16_t HPLADC12M$HPLADC12$getMem(uint8_t arg_0x413f9010);


static   void HPLADC12M$HPLADC12$setIEFlags(uint16_t arg_0x413f94c0);
#line 69
static   void HPLADC12M$HPLADC12$setSHT(uint8_t arg_0x413f6688);
#line 50
static   void HPLADC12M$HPLADC12$setMemControl(uint8_t arg_0x413fa4b8, adc12memctl_t arg_0x413fa650);
#line 82
static   void HPLADC12M$HPLADC12$stopConversion(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t RefVoltM$SwitchOffTimer$fired(void);
# 118 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
static   RefVolt_t RefVoltM$RefVolt$getState(void);
#line 109
static   result_t RefVoltM$RefVolt$release(void);
#line 93
static   result_t RefVoltM$RefVolt$get(RefVolt_t arg_0x413e2cf8);
# 61 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void RefVoltM$HPLADC12$memOverflow(void);

static   void RefVoltM$HPLADC12$converted(uint8_t arg_0x413f8a00);
#line 62
static   void RefVoltM$HPLADC12$timeOverflow(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t RefVoltM$SwitchOnTimer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Intercept$default$intercept(
# 19 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e1e20, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
#line 86
static  result_t MultiHopEngineM$Snoop$default$intercept(
# 20 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e0420, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t MultiHopEngineM$Send$send(
# 17 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e10f8, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
#line 106
static  void *MultiHopEngineM$Send$getBuffer(
# 17 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e10f8, 
# 106 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0);
#line 119
static  result_t MultiHopEngineM$Send$default$sendDone(
# 17 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e10f8, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 6 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopEngineM$StdControl$init(void);






static  result_t MultiHopEngineM$StdControl$start(void);
# 84 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
static  uint16_t MultiHopEngineM$RouteControl$getQuality(void);
#line 49
static  uint16_t MultiHopEngineM$RouteControl$getParent(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopEngineM$RouteStatusTimer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr CascadesRouterM$ReceiveMsg$receive(
# 39 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x415508a0, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40bd2280);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesRouterM$SubSend$sendDone(
# 40 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x41550e50, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$DTTimer$fired(void);
#line 73
static  result_t CascadesRouterM$RTTimer$fired(void);
#line 73
static  result_t CascadesRouterM$DelayTimer$fired(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr CascadesRouterM$Receive$default$receive(
# 36 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x415502d0, 
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
TOS_MsgPtr arg_0x40a0f130, void *arg_0x40a0f2d0, uint16_t arg_0x40a0f468);
# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  result_t CascadesRouterM$CascadeControl$addDirectChild(address_t arg_0x41544d38);
static  result_t CascadesRouterM$CascadeControl$deleteDirectChild(address_t arg_0x415431f0);
static  result_t CascadesRouterM$CascadeControl$parentChanged(address_t arg_0x41543698);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$ResetTimer$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CascadesRouterM$StdControl$init(void);






static  result_t CascadesRouterM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$ACKTimer$fired(void);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t CascadesEngineM$SendMsg$default$send(
# 39 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x415fc7b8, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
static  result_t CascadesEngineM$SendMsg$sendDone(
# 39 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x415fc7b8, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesEngineM$MySend$send(
# 36 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x415fc030, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CascadesEngineM$StdControl$init(void);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t arg_0x412209c8, uint16_t arg_0x41220b60, bool arg_0x41220cf0);
#line 6
static  bool NeighborMgmtM$NeighborCtrl$clearParent(bool arg_0x41220528);








static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t arg_0x4121d7d8, uint16_t arg_0x4121d968);
#line 5
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t arg_0x41220098);
# 2 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t NeighborMgmtM$StdControl$init(void);






static  result_t NeighborMgmtM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t NeighborMgmtM$Timer$fired(void);
# 47 "/opt/tinyos-1.x/tos/platform/msp430/MainM.nc"
static  result_t MainM$hardwareInit(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MainM$StdControl$init(void);






static  result_t MainM$StdControl$start(void);
# 52 "/opt/tinyos-1.x/tos/platform/msp430/MainM.nc"
int main(void)   ;
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HPLInitM$MSP430ClockControl$init(void);






static  result_t HPLInitM$MSP430ClockControl$start(void);
# 35 "/opt/tinyos-1.x/tos/platform/msp430/HPLInitM.nc"
static inline  result_t HPLInitM$init(void);
# 29 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockInit.nc"
static  void MSP430ClockM$MSP430ClockInit$initTimerB(void);
#line 28
static  void MSP430ClockM$MSP430ClockInit$initTimerA(void);
#line 27
static  void MSP430ClockM$MSP430ClockInit$initClocks(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
 static volatile uint8_t MSP430ClockM$IE1 __asm ("0x0000");
 static volatile uint16_t MSP430ClockM$TA0CTL __asm ("0x0160");
 static volatile uint16_t MSP430ClockM$TA0IV __asm ("0x012E");
 static volatile uint16_t MSP430ClockM$TBCTL __asm ("0x0180");
 static volatile uint16_t MSP430ClockM$TBIV __asm ("0x011E");

enum MSP430ClockM$__nesc_unnamed4308 {

  MSP430ClockM$ACLK_CALIB_PERIOD = 8, 
  MSP430ClockM$ACLK_KHZ = 32, 
  MSP430ClockM$TARGET_DCO_KHZ = 4096, 
  MSP430ClockM$TARGET_DCO_DELTA = MSP430ClockM$TARGET_DCO_KHZ / MSP430ClockM$ACLK_KHZ * MSP430ClockM$ACLK_CALIB_PERIOD
};

static inline  void MSP430ClockM$MSP430ClockInit$defaultInitClocks(void);
#line 69
static inline  void MSP430ClockM$MSP430ClockInit$defaultInitTimerA(void);
#line 84
static inline  void MSP430ClockM$MSP430ClockInit$defaultInitTimerB(void);
#line 99
static inline   void MSP430ClockM$MSP430ClockInit$default$initClocks(void);




static inline   void MSP430ClockM$MSP430ClockInit$default$initTimerA(void);




static inline   void MSP430ClockM$MSP430ClockInit$default$initTimerB(void);





static inline void MSP430ClockM$startTimerA(void);
#line 127
static inline void MSP430ClockM$startTimerB(void);
#line 139
static void MSP430ClockM$set_dco_calib(int calib);





static inline uint16_t MSP430ClockM$test_calib_busywait_delta(int calib);
#line 168
static inline void MSP430ClockM$busyCalibrateDCO(void);
#line 201
static inline  result_t MSP430ClockM$StdControl$init(void);
#line 220
static inline  result_t MSP430ClockM$StdControl$start(void);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   uint16_t MSP430DCOCalibM$Timer32khz$read(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430DCOCalibM.nc"
uint16_t MSP430DCOCalibM$m_prev;

enum MSP430DCOCalibM$__nesc_unnamed4309 {

  MSP430DCOCalibM$TARGET_DELTA = 2048, 
  MSP430DCOCalibM$MAX_DEVIATION = 7
};


static inline   void MSP430DCOCalibM$TimerMicro$overflow(void);
#line 75
static inline   void MSP430DCOCalibM$Timer32khz$overflow(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureA1$captured(uint16_t arg_0x408cb858);
#line 74
static   void MSP430TimerM$CaptureB3$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA1$fired(void);
#line 34
static   void MSP430TimerM$CompareB3$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureB6$captured(uint16_t arg_0x408cb858);
#line 74
static   void MSP430TimerM$CaptureB1$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB1$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureA2$captured(uint16_t arg_0x408cb858);
#line 74
static   void MSP430TimerM$CaptureB4$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA2$fired(void);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430TimerM$TimerA$overflow(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB4$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureA0$captured(uint16_t arg_0x408cb858);
#line 74
static   void MSP430TimerM$CaptureB2$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareA0$fired(void);
#line 34
static   void MSP430TimerM$CompareB2$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureB5$captured(uint16_t arg_0x408cb858);
# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430TimerM$TimerB$overflow(void);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB5$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void MSP430TimerM$CaptureB0$captured(uint16_t arg_0x408cb858);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430TimerM$CompareB6$fired(void);
#line 34
static   void MSP430TimerM$CompareB0$fired(void);
# 67 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
 static volatile uint16_t MSP430TimerM$TA0CTL __asm ("0x0160");

 static volatile uint16_t MSP430TimerM$TA0CCTL0 __asm ("0x0162");
 static volatile uint16_t MSP430TimerM$TA0CCTL1 __asm ("0x0164");
 static volatile uint16_t MSP430TimerM$TA0CCTL2 __asm ("0x0166");

 static volatile uint16_t MSP430TimerM$TA0CCR0 __asm ("0x0172");
 static volatile uint16_t MSP430TimerM$TA0CCR1 __asm ("0x0174");
 static volatile uint16_t MSP430TimerM$TA0CCR2 __asm ("0x0176");

 static volatile uint16_t MSP430TimerM$TBCCTL0 __asm ("0x0182");
 static volatile uint16_t MSP430TimerM$TBCCTL1 __asm ("0x0184");
 static volatile uint16_t MSP430TimerM$TBCCTL2 __asm ("0x0186");
 static volatile uint16_t MSP430TimerM$TBCCTL3 __asm ("0x0188");
 static volatile uint16_t MSP430TimerM$TBCCTL4 __asm ("0x018A");
 static volatile uint16_t MSP430TimerM$TBCCTL5 __asm ("0x018C");
 static volatile uint16_t MSP430TimerM$TBCCTL6 __asm ("0x018E");

 static volatile uint16_t MSP430TimerM$TBCCR0 __asm ("0x0192");
 static volatile uint16_t MSP430TimerM$TBCCR1 __asm ("0x0194");
 static volatile uint16_t MSP430TimerM$TBCCR2 __asm ("0x0196");
 static volatile uint16_t MSP430TimerM$TBCCR3 __asm ("0x0198");
 static volatile uint16_t MSP430TimerM$TBCCR4 __asm ("0x019A");
 static volatile uint16_t MSP430TimerM$TBCCR5 __asm ("0x019C");
 static volatile uint16_t MSP430TimerM$TBCCR6 __asm ("0x019E");

typedef MSP430CompareControl_t MSP430TimerM$CC_t;

static inline uint16_t MSP430TimerM$CC2int(MSP430TimerM$CC_t x);
static inline MSP430TimerM$CC_t MSP430TimerM$int2CC(uint16_t x);

static uint16_t MSP430TimerM$compareControl(void);
#line 110
static inline uint16_t MSP430TimerM$captureControl(uint8_t l_cm);
#line 123
void sig_TIMERA0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(12))) ;







void sig_TIMERA1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(10))) ;
#line 159
static inline    void MSP430TimerM$CompareA2$default$fired(void);
static inline    void MSP430TimerM$CaptureA0$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureA1$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureA2$default$captured(uint16_t time);



static inline   uint16_t MSP430TimerM$TimerB$read(void);


static inline   bool MSP430TimerM$TimerB$isOverflowPending(void);




static inline   void MSP430TimerM$TimerA$setMode(int mode);




static inline   void MSP430TimerM$TimerA$clear(void);


static inline   void MSP430TimerM$TimerA$disableEvents(void);


static inline   void MSP430TimerM$TimerA$setClockSource(uint16_t clockSource);









static inline   void MSP430TimerM$TimerA$setInputDivider(uint16_t inputDivider);









static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA0$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA1$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA2$getControl(void);









static inline   void MSP430TimerM$ControlA0$setControl(MSP430TimerM$CC_t x);
static inline   void MSP430TimerM$ControlA1$setControl(MSP430TimerM$CC_t x);
#line 253
static inline   uint16_t MSP430TimerM$CaptureA0$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureA1$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureA2$getEvent(void);

static inline   void MSP430TimerM$CompareA0$setEvent(uint16_t x);
static inline   void MSP430TimerM$CompareA1$setEvent(uint16_t x);
#line 277
void sig_TIMERB0_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(26))) ;







void sig_TIMERB1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(24))) ;
#line 331
static inline    void MSP430TimerM$CompareB0$default$fired(void);
static inline    void MSP430TimerM$CompareB1$default$fired(void);
static inline    void MSP430TimerM$CompareB2$default$fired(void);



static inline    void MSP430TimerM$CompareB6$default$fired(void);
static inline    void MSP430TimerM$CaptureB0$default$captured(uint16_t time);

static inline    void MSP430TimerM$CaptureB2$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureB3$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureB4$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureB5$default$captured(uint16_t time);
static inline    void MSP430TimerM$CaptureB6$default$captured(uint16_t time);


static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB0$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB1$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB2$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB3$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB4$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB5$getControl(void);
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB6$getControl(void);










static inline   void MSP430TimerM$ControlB1$clearPendingInterrupt(void);

static inline   void MSP430TimerM$ControlB3$clearPendingInterrupt(void);
static inline   void MSP430TimerM$ControlB4$clearPendingInterrupt(void);
static inline   void MSP430TimerM$ControlB5$clearPendingInterrupt(void);
#line 382
static inline   void MSP430TimerM$ControlB3$setControlAsCompare(void);
static inline   void MSP430TimerM$ControlB4$setControlAsCompare(void);
static inline   void MSP430TimerM$ControlB5$setControlAsCompare(void);



static inline   void MSP430TimerM$ControlB1$setControlAsCapture(uint8_t cm);
#line 412
static inline   void MSP430TimerM$ControlB1$enableEvents(void);

static inline   void MSP430TimerM$ControlB3$enableEvents(void);
static inline   void MSP430TimerM$ControlB4$enableEvents(void);
static inline   void MSP430TimerM$ControlB5$enableEvents(void);



static inline   void MSP430TimerM$ControlB1$disableEvents(void);

static inline   void MSP430TimerM$ControlB3$disableEvents(void);
static inline   void MSP430TimerM$ControlB4$disableEvents(void);
static inline   void MSP430TimerM$ControlB5$disableEvents(void);
#line 443
static inline   uint16_t MSP430TimerM$CaptureB0$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB1$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB2$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB3$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB4$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB5$getEvent(void);
static inline   uint16_t MSP430TimerM$CaptureB6$getEvent(void);
#line 470
static inline   void MSP430TimerM$CompareB3$setEventFromNow(uint16_t x);
static inline   void MSP430TimerM$CompareB4$setEventFromNow(uint16_t x);
static inline   void MSP430TimerM$CompareB5$setEventFromNow(uint16_t x);



static inline   bool MSP430TimerM$CaptureB1$isOverflowPending(void);







static inline   void MSP430TimerM$CaptureB1$clearOverflow(void);
# 28 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
static  void *SmartSensingM$DataMgmt$allocBlk(uint8_t arg_0x40ad2760);

static  result_t SmartSensingM$DataMgmt$saveBlk(void *arg_0x40ad0110, uint8_t arg_0x40ad02a0);
# 39 "/home/xu/oasis/interfaces/RealTime.nc"
static  uint32_t SmartSensingM$RealTime$getTimeCount(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t SmartSensingM$Random$rand(void);
# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
static  result_t SmartSensingM$ADCControl$bindPort(uint8_t arg_0x40a94cf8, uint8_t arg_0x40a94e80);
#line 50
static  result_t SmartSensingM$ADCControl$init(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$SensingTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SmartSensingM$SubControl$init(void);






static  result_t SmartSensingM$SubControl$start(void);
#line 63
static  result_t SmartSensingM$TimerControl$init(void);






static  result_t SmartSensingM$TimerControl$start(void);
# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t SmartSensingM$ADC$getData(
# 63 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
uint8_t arg_0x40a7cd80);
# 84 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
static  uint16_t SmartSensingM$RouteControl$getQuality(void);
# 90 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
 uint16_t SmartSensingM$timerInterval;

 uint16_t SmartSensingM$defaultCode;

 bool SmartSensingM$initedClock;



SenBlkPtr SmartSensingM$sensingCurBlk;







static inline void SmartSensingM$initDefault(void);
static inline void SmartSensingM$trySample(void);
static void SmartSensingM$saveData(uint8_t type, uint16_t data);
static uint16_t SmartSensingM$calFireInterval(void);
static void SmartSensingM$updateMaxBlkNum(void);
static inline void SmartSensingM$setrate(void);






static inline void SmartSensingM$initDefault(void);
#line 312
static inline  result_t SmartSensingM$StdControl$init(void);
#line 332
static inline  result_t SmartSensingM$StdControl$start(void);
#line 360
static inline  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t type);
#line 382
static inline  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t type, uint16_t rate);
#line 416
static inline  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t type);
#line 436
static inline  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t type, uint8_t channel);
#line 480
static inline  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t type);
#line 498
static inline  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t type, uint8_t priority);
#line 525
static inline  uint8_t SmartSensingM$SensingConfig$getNodePriority(void);
#line 544
static inline  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t priority);
#line 570
static inline  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t type);
#line 582
static inline  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t type, uint16_t code);
#line 608
static inline  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);
#line 620
static inline  result_t SmartSensingM$SensingTimer$fired(void);
#line 645
static inline   result_t SmartSensingM$ADC$dataReady(uint8_t client, uint16_t data);
#line 734
static void SmartSensingM$saveData(uint8_t client, uint16_t data);
#line 770
static inline void SmartSensingM$setrate(void);
#line 788
static void SmartSensingM$updateMaxBlkNum(void);
#line 814
static __inline uint16_t SmartSensingM$GCD(uint16_t a, uint16_t b);
#line 832
static uint16_t SmartSensingM$calFireInterval(void);
#line 861
static inline bool SmartSensingM$needSample(uint8_t client);
#line 909
static inline void SmartSensingM$trySample(void);
# 63 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$redToggle(void);
#line 75
static inline   result_t NoLeds$Leds$greenToggle(void);
#line 87
static inline   result_t NoLeds$Leds$yellowToggle(void);
# 54 "/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
uint16_t RandomLFSR$shiftReg;
uint16_t RandomLFSR$initSeed;
uint16_t RandomLFSR$mask;


static inline   result_t RandomLFSR$Random$init(void);










static   uint16_t RandomLFSR$Random$rand(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void RealTimeM$MSP430Compare$setEventFromNow(uint16_t arg_0x408d5830);
# 43 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
static   result_t RealTimeM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b50150);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t RealTimeM$Leds$greenToggle(void);
#line 131
static   result_t RealTimeM$Leds$yellowToggle(void);
# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void RealTimeM$MSP430TimerControl$enableEvents(void);
#line 35
static   void RealTimeM$MSP430TimerControl$setControlAsCompare(void);



static   void RealTimeM$MSP430TimerControl$disableEvents(void);
#line 32
static   void RealTimeM$MSP430TimerControl$clearPendingInterrupt(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$fired(
# 30 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
uint8_t arg_0x40b35650);
#line 46
 SyncUser_t RealTimeM$clientList[MAX_NUM_CLIENT];

 uint32_t RealTimeM$mState;

 uint32_t RealTimeM$localTime;

 uint32_t RealTimeM$uc_fire_point;

 uint32_t RealTimeM$uc_fire_interval;





 uint8_t RealTimeM$numClients;



 int8_t RealTimeM$queue_head;

 int8_t RealTimeM$queue_tail;

 uint8_t RealTimeM$queue_size;

 uint8_t RealTimeM$queue[NUM_TIMERS];

 uint8_t RealTimeM$syncMode;

 bool RealTimeM$taskBusy;

 bool RealTimeM$is_synced;
 bool RealTimeM$timerBusy;
 uint32_t RealTimeM$timerCount;
 uint32_t RealTimeM$globaltime_t;


static  void RealTimeM$signalOneTimer(void);
static inline void RealTimeM$enqueue(uint8_t value);
static inline uint8_t RealTimeM$dequeue(void);

static inline  result_t RealTimeM$StdControl$init(void);
#line 108
static inline  result_t RealTimeM$StdControl$start(void);
#line 169
static  uint32_t RealTimeM$RealTime$getTimeCount(void);
#line 209
static inline  bool RealTimeM$RealTime$isSync(void);









static inline  uint8_t RealTimeM$RealTime$getMode(void);







static  result_t RealTimeM$RealTime$setTimeCount(uint32_t newCount, uint8_t userMode);
#line 282
static  result_t RealTimeM$Timer$start(uint8_t id, char type, uint32_t interval);
#line 323
static inline  result_t RealTimeM$Timer$stop(uint8_t id);
#line 342
static inline void RealTimeM$enqueue(uint8_t value);
#line 354
static inline uint8_t RealTimeM$dequeue(void);
#line 373
static  void RealTimeM$signalOneTimer(void);
#line 387
static inline  void RealTimeM$updateTimer(void);
#line 436
static inline   void RealTimeM$MSP430Compare$fired(void);
#line 459
static   uint32_t RealTimeM$LocalTime$read(void);
#line 508
static inline   result_t RealTimeM$Timer$default$fired(uint8_t id);



static inline   void RealTimeM$MSP430Timer$overflow(void);
# 39 "/home/xu/oasis/interfaces/TimeStamping.nc"
static  result_t TimeSyncM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40bcab20, uint32_t *arg_0x40bcacd8);
# 42 "/home/xu/oasis/interfaces/RealTime.nc"
static  bool TimeSyncM$RealTime$isSync(void);
#line 40
static  result_t TimeSyncM$RealTime$setTimeCount(uint32_t arg_0x40ab48c8, uint8_t arg_0x40ab4a50);



static  uint8_t TimeSyncM$RealTime$getMode(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t TimeSyncM$LocalTime$read(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t TimeSyncM$Leds$greenToggle(void);
#line 131
static   result_t TimeSyncM$Leds$yellowToggle(void);
#line 81
static   result_t TimeSyncM$Leds$redToggle(void);
# 20 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
static  void TimeSyncM$TimeSyncNotify$msg_received(void);





static  void TimeSyncM$TimeSyncNotify$msg_sent(void);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t TimeSyncM$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimeSyncM$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 75 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
enum TimeSyncM$__nesc_unnamed4310 {






  TimeSyncM$MAX_ENTRIES = 8, 





  TimeSyncM$BEACON_RATE = 5, 









  TimeSyncM$ROOT_TIMEOUT = 6, 








  TimeSyncM$IGNORE_ROOT_MSG = 4, 







  TimeSyncM$ENTRY_VALID_LIMIT = 4, 







  TimeSyncM$ENTRY_SEND_LIMIT = 4, 





  TimeSyncM$ENTRY_THROWOUT_LIMIT = 100
};
#line 149
#line 144
typedef struct TimeSyncM$TableItem {

  uint16_t state;
  uint32_t localTime;
  int32_t timeOffset;
} TimeSyncM$TableItem;

enum TimeSyncM$__nesc_unnamed4311 {
  TimeSyncM$ENTRY_EMPTY = 0, 
  TimeSyncM$ENTRY_FULL = 1
};
enum TimeSyncM$__nesc_unnamed4312 {
  TimeSyncM$ERROR_TIMES = 3, 
  TimeSyncM$GPS_VALID = 3
};

TimeSyncM$TableItem TimeSyncM$table[TimeSyncM$MAX_ENTRIES];
uint16_t TimeSyncM$tableEntries;

enum TimeSyncM$__nesc_unnamed4313 {
  TimeSyncM$STATE_IDLE = 0x00, 
  TimeSyncM$STATE_PROCESSING = 0x01, 
  TimeSyncM$STATE_SENDING = 0x02, 
  TimeSyncM$STATE_INIT = 0x04
};

uint16_t TimeSyncM$state;
#line 170
uint16_t TimeSyncM$mode;
uint16_t TimeSyncM$alreadySetTime;
uint16_t TimeSyncM$errTimes;
uint16_t TimeSyncM$hasGPSValid;
#line 185
float TimeSyncM$skew;
uint32_t TimeSyncM$localAverage;
int32_t TimeSyncM$offsetAverage;
uint16_t TimeSyncM$numEntries;

uint16_t TimeSyncM$missedSendStamps;
#line 190
uint16_t TimeSyncM$missedReceiveStamps;

TOS_Msg TimeSyncM$processedMsgBuffer;
TOS_MsgPtr TimeSyncM$processedMsg;

TOS_Msg TimeSyncM$outgoingMsgBuffer;


uint16_t TimeSyncM$heartBeats;

uint16_t TimeSyncM$rootid;

static inline   uint32_t TimeSyncM$GlobalTime$getLocalTime(void);








static inline result_t TimeSyncM$is_synced(void);




static   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *time);
#line 229
static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *time);
#line 248
static inline void TimeSyncM$calculateConversion(void);
#line 309
static void TimeSyncM$clearTable(void);








static inline void TimeSyncM$addNewEntry(TimeSyncMsg *msg);
#line 417
static inline void  TimeSyncM$processMsg(void);
#line 509
static inline  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr p);
#line 571
static void TimeSyncM$adjustRootID(void);
#line 624
static  void TimeSyncM$sendMsg(void);
#line 693
static inline  result_t TimeSyncM$SendMsg$sendDone(TOS_MsgPtr ptr, result_t success);
#line 718
static inline void TimeSyncM$timeSyncMsgSend(void);
#line 753
static inline  result_t TimeSyncM$Timer$fired(void);
#line 806
static inline  result_t TimeSyncM$StdControl$init(void);
#line 839
static inline  result_t TimeSyncM$StdControl$start(void);
#line 873
static inline   void TimeSyncM$TimeSyncNotify$default$msg_received(void);
static inline   void TimeSyncM$TimeSyncNotify$default$msg_sent(void);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t TimerM$TimerMilli$fired(
# 32 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c468b0);
# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void TimerM$AlarmControl$enableEvents(void);
#line 35
static   void TimerM$AlarmControl$setControlAsCompare(void);



static   void TimerM$AlarmControl$disableEvents(void);
#line 32
static   void TimerM$AlarmControl$clearPendingInterrupt(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void TimerM$AlarmCompare$setEventFromNow(uint16_t arg_0x408d5830);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerJiffy.nc"
static  result_t TimerM$TimerJiffy$fired(
# 33 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c444e0);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   uint16_t TimerM$AlarmTimer$read(void);
static   bool TimerM$AlarmTimer$isOverflowPending(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$fired(
# 31 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
uint8_t arg_0x40c46118);








enum TimerM$__nesc_unnamed4314 {

  TimerM$COUNT_TIMER_OLD = 12U, 
  TimerM$COUNT_TIMER_MILLI = 2U, 
  TimerM$COUNT_TIMER_JIFFY = 0U, 

  TimerM$OFFSET_TIMER_OLD = 0, 
  TimerM$OFFSET_TIMER_MILLI = TimerM$OFFSET_TIMER_OLD + TimerM$COUNT_TIMER_OLD, 
  TimerM$OFFSET_TIMER_JIFFY = TimerM$OFFSET_TIMER_MILLI + TimerM$COUNT_TIMER_MILLI, 
  TimerM$NUM_TIMERS = TimerM$OFFSET_TIMER_JIFFY + TimerM$COUNT_TIMER_JIFFY, 

  TimerM$EMPTY_LIST = 255
};










#line 54
typedef struct TimerM$Timer_s {

  uint32_t alarm;
  uint8_t next;
  bool isperiodic : 1;
  bool isset : 1;
  bool isqueued : 1;
  int _reserved_flags : 5;
  uint8_t _reserved_byte;
} TimerM$Timer_t;

TimerM$Timer_t TimerM$m_timers[TimerM$NUM_TIMERS];
int32_t TimerM$m_period[TimerM$NUM_TIMERS];
uint16_t TimerM$m_hinow;
uint8_t TimerM$m_head_short;
uint8_t TimerM$m_head_long;
bool TimerM$m_posted_checkShortTimers;

static  result_t TimerM$StdControl$init(void);
#line 84
static inline  result_t TimerM$StdControl$start(void);









static void TimerM$insertTimer(uint8_t num, bool isshort);
#line 113
static inline void TimerM$removeTimer(uint8_t num);




static inline void TimerM$signal_timer_fired(uint8_t num);
#line 141
static void TimerM$executeTimers(uint8_t head);
#line 184
static inline  void TimerM$checkShortTimers(void);

static void TimerM$post_checkShortTimers(void);
#line 198
static void TimerM$setNextShortEvent(void);
#line 257
static inline  void TimerM$checkShortTimers(void);








static inline  void TimerM$checkLongTimers(void);








static uint16_t TimerM$readTime(void);
#line 288
static   uint32_t TimerM$LocalTime$read(void);
#line 308
static inline   void TimerM$AlarmCompare$fired(void);




static inline   void TimerM$AlarmTimer$overflow(void);





static result_t TimerM$setTimer(uint8_t num, int32_t jiffy, bool isperiodic);
#line 386
static inline   result_t TimerM$TimerJiffy$default$fired(uint8_t num);







static inline uint8_t TimerM$fromNumMilli(uint8_t num);




static inline  result_t TimerM$TimerMilli$setOneShot(uint8_t num, int32_t milli);
#line 435
static inline   result_t TimerM$TimerMilli$default$fired(uint8_t num);







static  result_t TimerM$Timer$start(uint8_t num, char type, uint32_t milli);
#line 457
static  result_t TimerM$Timer$stop(uint8_t num);





static inline   result_t TimerM$Timer$default$fired(uint8_t num);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$ReceiveMsg$receive(
# 71 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40cdd5b8, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40bd2280);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$ActivityTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t GenericCommProM$Intercept$intercept(TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$UARTSend$send(TOS_MsgPtr arg_0x40d018a0);
# 41 "/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
static   uint8_t GenericCommProM$PowerManagement$adjustPower(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$RadioControl$init(void);






static  result_t GenericCommProM$RadioControl$start(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacControl.nc"
static   void GenericCommProM$MacControl$enableAck(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$TimerControl$init(void);






static  result_t GenericCommProM$TimerControl$start(void);
#line 63
static  result_t GenericCommProM$UARTControl$init(void);






static  result_t GenericCommProM$UARTControl$start(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t GenericCommProM$Leds$greenToggle(void);
#line 131
static   result_t GenericCommProM$Leds$yellowToggle(void);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$RadioSend$send(TOS_MsgPtr arg_0x40d018a0);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t GenericCommProM$SendMsg$sendDone(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40cdef00, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68);
# 185 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static  uint8_t GenericCommProM$CC2420Control$GetRFPower(void);
#line 178
static  result_t GenericCommProM$CC2420Control$SetRFPower(uint8_t arg_0x40d15950);
#line 84
static  result_t GenericCommProM$CC2420Control$TunePreset(uint8_t arg_0x40d19a30);
#line 106
static  uint8_t GenericCommProM$CC2420Control$GetPreset(void);
# 119 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
bool GenericCommProM$sendTaskBusy;
bool GenericCommProM$recvTaskBusy;








#line 122
typedef struct GenericCommProM$backupHeader {
  uint8_t valid;
  uint8_t length;
  uint8_t type;
  uint8_t group;
  TOS_MsgPtr msgPtr;
  address_t addr;
} GenericCommProM$backupHeader;

Queue_t GenericCommProM$sendQueue;




GenericCommProM$backupHeader GenericCommProM$bkHeader[COMM_SEND_QUEUE_SIZE];



TOS_Msg GenericCommProM$swapBuf;
TOS_MsgPtr GenericCommProM$swapMsgPtr;




bool GenericCommProM$state;
bool GenericCommProM$radioRecvActive;
bool GenericCommProM$radioSendActive;
uint8_t GenericCommProM$wdtTimerCnt;

uint16_t GenericCommProM$lastCount;
uint16_t GenericCommProM$counter;
uint8_t GenericCommProM$UARTOrRadio;
bool GenericCommProM$toSend;

static inline  void GenericCommProM$sendTask(void);




static result_t GenericCommProM$tryNextSend(void);
static inline result_t GenericCommProM$insertAndStartSend(TOS_MsgPtr msg);
static inline result_t GenericCommProM$updateProtocolField(TOS_MsgPtr msg, uint8_t id, address_t addr, uint8_t len);


static result_t GenericCommProM$reportSendDone(TOS_MsgPtr msg, result_t success);
static TOS_MsgPtr GenericCommProM$received(TOS_MsgPtr msg);

static inline uint8_t GenericCommProM$allocateBkHeaderEntry(void);
static uint8_t GenericCommProM$findBkHeaderEntry(TOS_MsgPtr pMsg);
static result_t GenericCommProM$freeBkHeader(uint8_t ind);



static inline  bool GenericCommProM$Control$init(void);
#line 250
static inline  bool GenericCommProM$Control$start(void);
#line 295
static  result_t GenericCommProM$SendMsg$send(uint8_t id, uint16_t addr, uint8_t len, TOS_MsgPtr msg);
#line 332
static inline  result_t GenericCommProM$ActivityTimer$fired(void);
#line 365
static inline   result_t GenericCommProM$SendMsg$default$sendDone(uint8_t id, TOS_MsgPtr msg, result_t success);




static inline  result_t GenericCommProM$UARTSend$sendDone(TOS_MsgPtr msg, result_t success);





static inline   TOS_MsgPtr GenericCommProM$ReceiveMsg$default$receive(uint8_t id, TOS_MsgPtr msg);




static inline  TOS_MsgPtr GenericCommProM$UARTReceive$receive(TOS_MsgPtr packet);










static inline  result_t GenericCommProM$RadioSend$sendDone(TOS_MsgPtr msg, result_t status);





static inline  TOS_MsgPtr GenericCommProM$RadioReceive$receive(TOS_MsgPtr msg);






static inline void GenericCommProM$sendFunc(void);
#line 463
static inline  void GenericCommProM$sendTask(void);
#line 504
static inline result_t GenericCommProM$insertAndStartSend(TOS_MsgPtr msg);








static result_t GenericCommProM$tryNextSend(void);
#line 536
static inline result_t GenericCommProM$updateProtocolField(TOS_MsgPtr msg, uint8_t id, address_t addr, uint8_t len);
#line 576
static result_t GenericCommProM$reportSendDone(TOS_MsgPtr msg, result_t success);
#line 650
static TOS_MsgPtr GenericCommProM$received(TOS_MsgPtr msg);
#line 698
static inline uint8_t GenericCommProM$allocateBkHeaderEntry(void);










static uint8_t GenericCommProM$findBkHeaderEntry(TOS_MsgPtr pMsg);
#line 722
static result_t GenericCommProM$freeBkHeader(uint8_t ind);
#line 737
static inline  result_t GenericCommProM$setRFChannel(uint8_t channel);






static inline  result_t GenericCommProM$setRFPower(uint8_t level);






static inline  uint8_t GenericCommProM$getRFChannel(void);



static inline  uint8_t GenericCommProM$getRFPower(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$SplitControl$initDone(void);
#line 85
static  result_t CC2420RadioM$SplitControl$startDone(void);
# 59 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420RadioM$FIFOP$disable(void);
#line 43
static   result_t CC2420RadioM$FIFOP$startWait(bool arg_0x40dc68a0);
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0x40db7d10);



static   bool CC2420RadioM$BackoffTimerJiffy$isSet(void);
#line 8
static   result_t CC2420RadioM$BackoffTimerJiffy$stop(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t CC2420RadioM$Random$rand(void);
#line 57
static   result_t CC2420RadioM$Random$init(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420RadioM$TimerControl$init(void);






static  result_t CC2420RadioM$TimerControl$start(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0x40bd2280);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0x40da30b0);
#line 47
static   uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0x40da54b0);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658);
# 60 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t CC2420RadioM$SFD$disable(void);
#line 43
static   result_t CC2420RadioM$SFD$enableCapture(bool arg_0x40dbe808);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658);
# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0x40d9cec0, uint8_t *arg_0x40dcd088);
#line 19
static   result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0x40d9c6a8, uint8_t *arg_0x40d9c850);
# 206 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static   result_t CC2420RadioM$CC2420Control$enableAddrDecode(void);
#line 192
static   result_t CC2420RadioM$CC2420Control$enableAutoAck(void);
#line 163
static   result_t CC2420RadioM$CC2420Control$RxMode(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
static   int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0x40d999b8);
static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0x40d99e78);
# 64 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$CC2420SplitControl$init(void);
#line 77
static  result_t CC2420RadioM$CC2420SplitControl$start(void);
# 76 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
enum CC2420RadioM$__nesc_unnamed4315 {
  CC2420RadioM$DISABLED_STATE = 0, 
  CC2420RadioM$DISABLED_STATE_STARTTASK, 
  CC2420RadioM$IDLE_STATE, 
  CC2420RadioM$TX_STATE, 
  CC2420RadioM$TX_WAIT, 
  CC2420RadioM$PRE_TX_STATE, 
  CC2420RadioM$POST_TX_STATE, 
  CC2420RadioM$POST_TX_ACK_STATE, 
  CC2420RadioM$RX_STATE, 
  CC2420RadioM$POWER_DOWN_STATE, 
  CC2420RadioM$WARMUP_STATE, 

  CC2420RadioM$TIMER_INITIAL = 0, 
  CC2420RadioM$TIMER_BACKOFF, 
  CC2420RadioM$TIMER_ACK
};



 uint8_t CC2420RadioM$countRetry;
uint8_t CC2420RadioM$stateRadio;
 uint8_t CC2420RadioM$stateTimer;
 uint8_t CC2420RadioM$currentDSN;
 bool CC2420RadioM$bAckEnable;
bool CC2420RadioM$bPacketReceiving;
uint8_t CC2420RadioM$txlength;
 TOS_MsgPtr CC2420RadioM$txbufptr;
 TOS_MsgPtr CC2420RadioM$rxbufptr;
TOS_Msg CC2420RadioM$RxBuf;

volatile uint16_t CC2420RadioM$LocalAddr;





static void CC2420RadioM$sendFailed(void);





static void CC2420RadioM$flushRXFIFO(void);








static __inline result_t CC2420RadioM$setInitialTimer(uint16_t jiffy);







static __inline result_t CC2420RadioM$setBackoffTimer(uint16_t jiffy);







static __inline result_t CC2420RadioM$setAckTimer(uint16_t jiffy);








static inline  void CC2420RadioM$PacketRcvd(void);
#line 168
static  void CC2420RadioM$PacketSent(void);
#line 186
static inline  result_t CC2420RadioM$StdControl$init(void);




static inline  result_t CC2420RadioM$SplitControl$init(void);
#line 208
static inline  result_t CC2420RadioM$CC2420SplitControl$initDone(void);



static inline   result_t CC2420RadioM$SplitControl$default$initDone(void);
#line 239
static inline  void CC2420RadioM$startRadio(void);
#line 253
static inline  result_t CC2420RadioM$StdControl$start(void);
#line 277
static inline  result_t CC2420RadioM$SplitControl$start(void);
#line 294
static inline  result_t CC2420RadioM$CC2420SplitControl$startDone(void);
#line 312
static inline   result_t CC2420RadioM$SplitControl$default$startDone(void);








static inline void CC2420RadioM$sendPacket(void);
#line 344
static inline   result_t CC2420RadioM$SFD$captured(uint16_t time);
#line 393
static  void CC2420RadioM$startSend(void);
#line 410
static void CC2420RadioM$tryToSend(void);
#line 449
static inline   result_t CC2420RadioM$BackoffTimerJiffy$fired(void);
#line 491
static inline  result_t CC2420RadioM$Send$send(TOS_MsgPtr pMsg);
#line 534
static void CC2420RadioM$delayedRXFIFO(void);

static inline  void CC2420RadioM$delayedRXFIFOtask(void);



static void CC2420RadioM$delayedRXFIFO(void);
#line 591
static inline   result_t CC2420RadioM$FIFOP$fired(void);
#line 628
static inline   result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t length, uint8_t *data);
#line 721
static inline   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t length, uint8_t *data);





static inline   void CC2420RadioM$MacControl$enableAck(void);
#line 744
static inline    int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr m);






static inline    int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr m);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420ControlM$SplitControl$initDone(void);
#line 85
static  result_t CC2420ControlM$SplitControl$startDone(void);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0x40da30b0);
#line 54
static   uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0x40da59c0, uint16_t arg_0x40da5b50);
#line 47
static   uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0x40da54b0);
# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420ControlM$CCA$startWait(bool arg_0x40dc68a0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420ControlM$HPLChipconControl$init(void);






static  result_t CC2420ControlM$HPLChipconControl$start(void);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0x40e23d00, uint8_t arg_0x40e23e88, uint8_t *arg_0x40e22068);
# 63 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
enum CC2420ControlM$__nesc_unnamed4316 {
  CC2420ControlM$IDLE_STATE = 0, 
  CC2420ControlM$INIT_STATE, 
  CC2420ControlM$INIT_STATE_DONE, 
  CC2420ControlM$START_STATE, 
  CC2420ControlM$START_STATE_DONE, 
  CC2420ControlM$STOP_STATE
};

uint8_t CC2420ControlM$state = 0;
 uint16_t CC2420ControlM$gCurrentParameters[14];






static inline bool CC2420ControlM$SetRegs(void);
#line 108
static inline  void CC2420ControlM$taskInitDone(void);







static inline  void CC2420ControlM$PostOscillatorOn(void);
#line 129
static inline  result_t CC2420ControlM$SplitControl$init(void);
#line 227
static inline  result_t CC2420ControlM$SplitControl$start(void);
#line 264
static inline  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t chnl);
#line 286
static inline  result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t DesiredFreq);
#line 310
static inline  uint8_t CC2420ControlM$CC2420Control$GetPreset(void);
#line 343
static inline   result_t CC2420ControlM$CC2420Control$RxMode(void);










static inline  result_t CC2420ControlM$CC2420Control$SetRFPower(uint8_t power);









static inline  uint8_t CC2420ControlM$CC2420Control$GetRFPower(void);



static inline   result_t CC2420ControlM$CC2420Control$OscillatorOn(void);
#line 400
static inline   result_t CC2420ControlM$CC2420Control$VREFOn(void);
#line 412
static inline   result_t CC2420ControlM$CC2420Control$enableAutoAck(void);









static inline   result_t CC2420ControlM$CC2420Control$enableAddrDecode(void);









static inline  result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t addr);








static inline   result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t addr, uint8_t length, uint8_t *buffer);



static inline   result_t CC2420ControlM$CCA$fired(void);
# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t HPLCC2420M$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0x40dcddb0, uint8_t *arg_0x40dcc010);
#line 39
static   result_t HPLCC2420M$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0x40dcd640, uint8_t *arg_0x40dcd7e8);
# 191 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
static   result_t HPLCC2420M$USARTControl$isTxEmpty(void);
#line 172
static   result_t HPLCC2420M$USARTControl$disableRxIntr(void);
static   result_t HPLCC2420M$USARTControl$disableTxIntr(void);
#line 135
static   void HPLCC2420M$USARTControl$setModeSPI(void);
#line 180
static   result_t HPLCC2420M$USARTControl$isTxIntrPending(void);
#line 202
static   result_t HPLCC2420M$USARTControl$tx(uint8_t arg_0x40e95850);






static   uint8_t HPLCC2420M$USARTControl$rx(void);
#line 185
static   result_t HPLCC2420M$USARTControl$isRxIntrPending(void);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0x40e225a0, uint8_t arg_0x40e22728, uint8_t *arg_0x40e228d0);
# 38 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static   result_t HPLCC2420M$BusArbitration$releaseBus(void);
#line 37
static   result_t HPLCC2420M$BusArbitration$getBus(void);
# 57 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
 uint8_t *HPLCC2420M$txbuf;
 uint8_t *HPLCC2420M$rxbuf;
 uint8_t *HPLCC2420M$rambuf;

 uint8_t HPLCC2420M$txlen;
 uint8_t HPLCC2420M$rxlen;
 uint8_t HPLCC2420M$ramlen;
 uint16_t HPLCC2420M$ramaddr;








 
#line 68
struct HPLCC2420M$__nesc_unnamed4317 {
  bool enabled : 1;
  bool busy : 1;
  bool rxbufBusy : 1;
  bool txbufBusy : 1;
} HPLCC2420M$f;





static inline uint8_t HPLCC2420M$adjustStatusByte(uint8_t status);



static inline  result_t HPLCC2420M$StdControl$init(void);
#line 96
static inline  result_t HPLCC2420M$StdControl$start(void);
#line 127
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr);
#line 162
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data);
#line 205
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr);
#line 288
static inline  void HPLCC2420M$signalRAMWr(void);



static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t _length, uint8_t *buffer);
#line 322
static inline  void HPLCC2420M$signalRXFIFO(void);
#line 335
static inline   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t length, uint8_t *data);
#line 394
static inline  void HPLCC2420M$signalTXFIFO(void);
#line 415
static inline   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t length, uint8_t *data);
#line 461
static inline  result_t HPLCC2420M$BusArbitration$busFree(void);
# 43 "/opt/tinyos-1.x/tos/platform/msp430/HPLI2CInterrupt.nc"
static   void HPLUSART0M$HPLI2CInterrupt$fired(void);
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
static   result_t HPLUSART0M$USARTData$rxDone(uint8_t arg_0x40ee6c40);
#line 46
static   result_t HPLUSART0M$USARTData$txDone(void);
# 47 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
 static volatile uint8_t HPLUSART0M$IE1 __asm ("0x0000");
 static volatile uint8_t HPLUSART0M$ME1 __asm ("0x0004");
 static volatile uint8_t HPLUSART0M$IFG1 __asm ("0x0002");
 static volatile uint8_t HPLUSART0M$U0TCTL __asm ("0x0071");
 static volatile uint8_t HPLUSART0M$U0TXBUF __asm ("0x0077");


uint16_t HPLUSART0M$l_br;

uint8_t HPLUSART0M$l_ssel;

void sig_UART0RX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(18))) ;




void sig_UART0TX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(16))) ;






static inline    void HPLUSART0M$HPLI2CInterrupt$default$fired(void);

static inline   bool HPLUSART0M$USARTControl$isSPI(void);








static inline   bool HPLUSART0M$USARTControl$isUART(void);










static inline   bool HPLUSART0M$USARTControl$isUARTtx(void);










static inline   bool HPLUSART0M$USARTControl$isUARTrx(void);










static inline   bool HPLUSART0M$USARTControl$isI2C(void);










static inline   msp430_usartmode_t HPLUSART0M$USARTControl$getMode(void);
#line 172
static inline   void HPLUSART0M$USARTControl$disableUART(void);
#line 218
static inline   void HPLUSART0M$USARTControl$disableI2C(void);






static   void HPLUSART0M$USARTControl$setModeSPI(void);
#line 424
static   result_t HPLUSART0M$USARTControl$isTxIntrPending(void);







static inline   result_t HPLUSART0M$USARTControl$isTxEmpty(void);






static   result_t HPLUSART0M$USARTControl$isRxIntrPending(void);







static inline   result_t HPLUSART0M$USARTControl$disableRxIntr(void);




static inline   result_t HPLUSART0M$USARTControl$disableTxIntr(void);
#line 473
static inline   result_t HPLUSART0M$USARTControl$tx(uint8_t data);




static   uint8_t HPLUSART0M$USARTControl$rx(void);







static inline    result_t HPLUSART0M$USARTData$default$txDone(void);

static inline    result_t HPLUSART0M$USARTData$default$rxDone(uint8_t data);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420InterruptM$FIFO$fired(void);
#line 51
static   result_t HPLCC2420InterruptM$FIFOP$fired(void);
# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void HPLCC2420InterruptM$CCAInterrupt$clear(void);
#line 35
static   void HPLCC2420InterruptM$CCAInterrupt$disable(void);
#line 54
static   void HPLCC2420InterruptM$CCAInterrupt$edge(bool arg_0x40f36350);
#line 30
static   void HPLCC2420InterruptM$CCAInterrupt$enable(void);
# 36 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void HPLCC2420InterruptM$SFDControl$setControlAsCapture(bool arg_0x408c0190);

static   void HPLCC2420InterruptM$SFDControl$enableEvents(void);
static   void HPLCC2420InterruptM$SFDControl$disableEvents(void);
#line 32
static   void HPLCC2420InterruptM$SFDControl$clearPendingInterrupt(void);
# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void HPLCC2420InterruptM$FIFOInterrupt$clear(void);
#line 35
static   void HPLCC2420InterruptM$FIFOInterrupt$disable(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420InterruptM$CCA$fired(void);
# 56 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
static   void HPLCC2420InterruptM$SFDCapture$clearOverflow(void);
#line 51
static   bool HPLCC2420InterruptM$SFDCapture$isOverflowPending(void);
# 53 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t HPLCC2420InterruptM$SFD$captured(uint16_t arg_0x40dbedc8);
# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void HPLCC2420InterruptM$FIFOPInterrupt$clear(void);
#line 35
static   void HPLCC2420InterruptM$FIFOPInterrupt$disable(void);
#line 54
static   void HPLCC2420InterruptM$FIFOPInterrupt$edge(bool arg_0x40f36350);
#line 30
static   void HPLCC2420InterruptM$FIFOPInterrupt$enable(void);
# 65 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static   result_t HPLCC2420InterruptM$FIFOP$startWait(bool low_to_high);
#line 78
static   result_t HPLCC2420InterruptM$FIFOP$disable(void);










static inline   void HPLCC2420InterruptM$FIFOPInterrupt$fired(void);
#line 130
static inline   void HPLCC2420InterruptM$FIFOInterrupt$fired(void);









static inline    result_t HPLCC2420InterruptM$FIFO$default$fired(void);






static inline   result_t HPLCC2420InterruptM$CCA$startWait(bool low_to_high);
#line 171
static inline   void HPLCC2420InterruptM$CCAInterrupt$fired(void);
#line 185
static   result_t HPLCC2420InterruptM$SFD$enableCapture(bool low_to_high);
#line 200
static   result_t HPLCC2420InterruptM$SFD$disable(void);








static inline   void HPLCC2420InterruptM$SFDCapture$captured(uint16_t time);
# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
static   void MSP430InterruptM$Port14$fired(void);
#line 59
static   void MSP430InterruptM$Port26$fired(void);
#line 59
static   void MSP430InterruptM$Port17$fired(void);
#line 59
static   void MSP430InterruptM$Port21$fired(void);
#line 59
static   void MSP430InterruptM$Port12$fired(void);
#line 59
static   void MSP430InterruptM$Port24$fired(void);
#line 59
static   void MSP430InterruptM$ACCV$fired(void);
#line 59
static   void MSP430InterruptM$Port15$fired(void);
#line 59
static   void MSP430InterruptM$Port27$fired(void);
#line 59
static   void MSP430InterruptM$Port10$fired(void);
#line 59
static   void MSP430InterruptM$Port22$fired(void);
#line 59
static   void MSP430InterruptM$OF$fired(void);
#line 59
static   void MSP430InterruptM$Port13$fired(void);
#line 59
static   void MSP430InterruptM$Port25$fired(void);
#line 59
static   void MSP430InterruptM$Port16$fired(void);
#line 59
static   void MSP430InterruptM$NMI$fired(void);
#line 59
static   void MSP430InterruptM$Port20$fired(void);
#line 59
static   void MSP430InterruptM$Port11$fired(void);
#line 59
static   void MSP430InterruptM$Port23$fired(void);
# 51 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
 static volatile uint8_t MSP430InterruptM$P1IE __asm ("0x0025");
 static volatile uint8_t MSP430InterruptM$P2IE __asm ("0x002D");
 static volatile uint8_t MSP430InterruptM$P1IFG __asm ("0x0023");
 static volatile uint8_t MSP430InterruptM$P2IFG __asm ("0x002B");

void sig_PORT1_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(8))) ;
#line 71
void sig_PORT2_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(2))) ;
#line 85
void sig_NMI_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(28))) ;








static inline    void MSP430InterruptM$Port11$default$fired(void);
static inline    void MSP430InterruptM$Port12$default$fired(void);


static inline    void MSP430InterruptM$Port15$default$fired(void);
static inline    void MSP430InterruptM$Port16$default$fired(void);
static inline    void MSP430InterruptM$Port17$default$fired(void);

static inline    void MSP430InterruptM$Port20$default$fired(void);
static inline    void MSP430InterruptM$Port21$default$fired(void);
static inline    void MSP430InterruptM$Port22$default$fired(void);
static inline    void MSP430InterruptM$Port23$default$fired(void);
static inline    void MSP430InterruptM$Port24$default$fired(void);
static inline    void MSP430InterruptM$Port25$default$fired(void);
static inline    void MSP430InterruptM$Port26$default$fired(void);
static inline    void MSP430InterruptM$Port27$default$fired(void);

static inline    void MSP430InterruptM$NMI$default$fired(void);
static inline    void MSP430InterruptM$OF$default$fired(void);
static inline    void MSP430InterruptM$ACCV$default$fired(void);

static inline   void MSP430InterruptM$Port10$enable(void);



static inline   void MSP430InterruptM$Port14$enable(void);
#line 146
static inline   void MSP430InterruptM$Port10$disable(void);


static inline   void MSP430InterruptM$Port13$disable(void);
static inline   void MSP430InterruptM$Port14$disable(void);
#line 177
static inline   void MSP430InterruptM$Port10$clear(void);
static inline   void MSP430InterruptM$Port11$clear(void);
static inline   void MSP430InterruptM$Port12$clear(void);
static inline   void MSP430InterruptM$Port13$clear(void);
static inline   void MSP430InterruptM$Port14$clear(void);
static inline   void MSP430InterruptM$Port15$clear(void);
static inline   void MSP430InterruptM$Port16$clear(void);
static inline   void MSP430InterruptM$Port17$clear(void);

static inline   void MSP430InterruptM$Port20$clear(void);
static inline   void MSP430InterruptM$Port21$clear(void);
static inline   void MSP430InterruptM$Port22$clear(void);
static inline   void MSP430InterruptM$Port23$clear(void);
static inline   void MSP430InterruptM$Port24$clear(void);
static inline   void MSP430InterruptM$Port25$clear(void);
static inline   void MSP430InterruptM$Port26$clear(void);
static inline   void MSP430InterruptM$Port27$clear(void);

static inline   void MSP430InterruptM$NMI$clear(void);
static inline   void MSP430InterruptM$OF$clear(void);
static inline   void MSP430InterruptM$ACCV$clear(void);
#line 222
static inline   void MSP430InterruptM$Port10$edge(bool l2h);
#line 246
static inline   void MSP430InterruptM$Port14$edge(bool l2h);
# 39 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
static  result_t BusArbitrationM$BusArbitration$busFree(
# 31 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
uint8_t arg_0x40ffcf08);





uint8_t BusArbitrationM$state;
uint8_t BusArbitrationM$busid;
bool BusArbitrationM$isBusReleasedPending;
enum BusArbitrationM$__nesc_unnamed4318 {
#line 40
  BusArbitrationM$BUS_IDLE, BusArbitrationM$BUS_BUSY, BusArbitrationM$BUS_OFF
};
static inline  void BusArbitrationM$busReleased(void);
#line 54
static inline  result_t BusArbitrationM$StdControl$init(void);







static inline  result_t BusArbitrationM$StdControl$start(void);
#line 94
static   result_t BusArbitrationM$BusArbitration$getBus(uint8_t id);
#line 108
static   result_t BusArbitrationM$BusArbitration$releaseBus(uint8_t id);
#line 125
static inline   result_t BusArbitrationM$BusArbitration$default$busFree(uint8_t id);
# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void TimerJiffyAsyncM$AlarmControl$enableEvents(void);
#line 35
static   void TimerJiffyAsyncM$AlarmControl$setControlAsCompare(void);



static   void TimerJiffyAsyncM$AlarmControl$disableEvents(void);
#line 32
static   void TimerJiffyAsyncM$AlarmControl$clearPendingInterrupt(void);
# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$fired(void);
# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void TimerJiffyAsyncM$AlarmCompare$setEventFromNow(uint16_t arg_0x408d5830);
# 13 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
uint32_t TimerJiffyAsyncM$jiffy;
bool TimerJiffyAsyncM$bSet;

static inline  result_t TimerJiffyAsyncM$StdControl$init(void);






static inline  result_t TimerJiffyAsyncM$StdControl$start(void);
#line 41
static inline   void TimerJiffyAsyncM$AlarmCompare$fired(void);
#line 70
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy);
#line 97
static inline   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);






static inline   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
# 50 "/opt/tinyos-1.x/tos/system/LedsC.nc"
uint8_t LedsC$ledsOn;

enum LedsC$__nesc_unnamed4319 {
  LedsC$RED_BIT = 1, 
  LedsC$GREEN_BIT = 2, 
  LedsC$YELLOW_BIT = 4
};
#line 72
static   result_t LedsC$Leds$redOn(void);








static   result_t LedsC$Leds$redOff(void);








static   result_t LedsC$Leds$redToggle(void);










static inline   result_t LedsC$Leds$greenOn(void);








static inline   result_t LedsC$Leds$greenOff(void);








static   result_t LedsC$Leds$greenToggle(void);










static inline   result_t LedsC$Leds$yellowOn(void);








static inline   result_t LedsC$Leds$yellowOff(void);








static   result_t LedsC$Leds$yellowToggle(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280);
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t FramerM$ByteComm$txByte(uint8_t arg_0x4106e5e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FramerM$ByteControl$init(void);






static  result_t FramerM$ByteControl$start(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010);
# 75 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x41077eb0, uint8_t arg_0x41076068);
# 82 "/opt/tinyos-1.x/tos/system/FramerM.nc"
enum FramerM$__nesc_unnamed4320 {
  FramerM$HDLC_QUEUESIZE = 2, 
  FramerM$HDLC_MTU = sizeof(TOS_Msg ), 
  FramerM$HDLC_FLAG_BYTE = 0x7e, 
  FramerM$HDLC_CTLESC_BYTE = 0x7d, 
  FramerM$PROTO_ACK = 64, 
  FramerM$PROTO_PACKET_ACK = 65, 
  FramerM$PROTO_PACKET_NOACK = 66, 
  FramerM$PROTO_UNKNOWN = 255
};

enum FramerM$__nesc_unnamed4321 {
  FramerM$RXSTATE_NOSYNC, 
  FramerM$RXSTATE_PROTO, 
  FramerM$RXSTATE_TOKEN, 
  FramerM$RXSTATE_INFO, 
  FramerM$RXSTATE_ESC
};

enum FramerM$__nesc_unnamed4322 {
  FramerM$TXSTATE_IDLE, 
  FramerM$TXSTATE_PROTO, 
  FramerM$TXSTATE_INFO, 
  FramerM$TXSTATE_ESC, 
  FramerM$TXSTATE_FCS1, 
  FramerM$TXSTATE_FCS2, 
  FramerM$TXSTATE_ENDFLAG, 
  FramerM$TXSTATE_FINISH, 
  FramerM$TXSTATE_ERROR
};

enum FramerM$__nesc_unnamed4323 {
  FramerM$FLAGS_TOKENPEND = 0x2, 
  FramerM$FLAGS_DATAPEND = 0x4, 
  FramerM$FLAGS_UNKNOWN = 0x8
};

TOS_Msg FramerM$gMsgRcvBuf[FramerM$HDLC_QUEUESIZE];






#line 121
typedef struct FramerM$_MsgRcvEntry {
  uint8_t Proto;
  uint8_t Token;
  uint16_t Length;
  TOS_MsgPtr pMsg;
} FramerM$MsgRcvEntry_t;

FramerM$MsgRcvEntry_t FramerM$gMsgRcvTbl[FramerM$HDLC_QUEUESIZE];

uint8_t *FramerM$gpRxBuf;
uint8_t *FramerM$gpTxBuf;

uint8_t FramerM$gFlags;


 uint8_t FramerM$gTxState;
 uint8_t FramerM$gPrevTxState;
 uint16_t FramerM$gTxProto;
 uint16_t FramerM$gTxByteCnt;
 uint16_t FramerM$gTxLength;
 uint16_t FramerM$gTxRunningCRC;


uint8_t FramerM$gRxState;
uint8_t FramerM$gRxHeadIndex;
uint8_t FramerM$gRxTailIndex;
uint16_t FramerM$gRxByteCnt;

uint16_t FramerM$gRxRunningCRC;

TOS_MsgPtr FramerM$gpTxMsg;
uint8_t FramerM$gTxTokenBuf;
uint8_t FramerM$gTxUnknownBuf;
 uint8_t FramerM$gTxEscByte;

static  void FramerM$PacketSent(void);

static result_t FramerM$StartTx(void);
#line 202
static inline  void FramerM$PacketUnknown(void);







static inline  void FramerM$PacketRcvd(void);
#line 246
static  void FramerM$PacketSent(void);
#line 268
static void FramerM$HDLCInitialize(void);
#line 292
static inline  result_t FramerM$StdControl$init(void);




static inline  result_t FramerM$StdControl$start(void);









static inline  result_t FramerM$BareSendMsg$send(TOS_MsgPtr pMsg);
#line 329
static inline  result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t Token);
#line 349
static inline   result_t FramerM$ByteComm$rxByteReady(uint8_t data, bool error, uint16_t strength);
#line 470
static result_t FramerM$TxArbitraryByte(uint8_t inByte);
#line 483
static inline   result_t FramerM$ByteComm$txByteReady(bool LastByteSuccess);
#line 553
static inline   result_t FramerM$ByteComm$txDone(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0x40bd2280);
# 88 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x41076710);
# 72 "/opt/tinyos-1.x/tos/system/FramerAckM.nc"
uint8_t FramerAckM$gTokenBuf;

static inline  void FramerAckM$SendAckTask(void);




static inline  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr Msg, uint8_t token);
#line 91
static inline  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr Msg);
# 62 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
static   result_t UARTM$HPLUART$init(void);
#line 80
static   result_t UARTM$HPLUART$put(uint8_t arg_0x410c46c0);
# 83 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t UARTM$ByteComm$txDone(void);
#line 75
static   result_t UARTM$ByteComm$txByteReady(bool arg_0x4106d4d8);
#line 66
static   result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0x4106eb30, bool arg_0x4106ecb8, uint16_t arg_0x4106ee50);
# 58 "/opt/tinyos-1.x/tos/system/UARTM.nc"
bool UARTM$state;

static inline  result_t UARTM$Control$init(void);







static inline  result_t UARTM$Control$start(void);








static inline   result_t UARTM$HPLUART$get(uint8_t data);









static inline   result_t UARTM$HPLUART$putDone(void);
#line 110
static   result_t UARTM$ByteComm$txByte(uint8_t data);
# 88 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
static   result_t HPLUARTM$UART$get(uint8_t arg_0x410c4c58);







static   result_t HPLUARTM$UART$putDone(void);
# 169 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
static   void HPLUARTM$USARTControl$setClockRate(uint16_t arg_0x40e98918, uint8_t arg_0x40e98aa0);
#line 167
static   void HPLUARTM$USARTControl$setClockSource(uint8_t arg_0x40e98460);






static   result_t HPLUARTM$USARTControl$enableRxIntr(void);
static   result_t HPLUARTM$USARTControl$enableTxIntr(void);
#line 202
static   result_t HPLUARTM$USARTControl$tx(uint8_t arg_0x40e95850);
#line 153
static   void HPLUARTM$USARTControl$setModeUART(void);
# 50 "/opt/tinyos-1.x/tos/platform/msp430/HPLUARTM.nc"
static inline   result_t HPLUARTM$UART$init(void);
#line 90
static inline   result_t HPLUARTM$USARTData$rxDone(uint8_t b);



static inline   result_t HPLUARTM$USARTData$txDone(void);



static inline   result_t HPLUARTM$UART$put(uint8_t data);
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
static   result_t HPLUSART1M$USARTData$rxDone(uint8_t arg_0x40ee6c40);
#line 46
static   result_t HPLUSART1M$USARTData$txDone(void);
# 46 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
 static volatile uint8_t HPLUSART1M$ME2 __asm ("0x0005");
 static volatile uint8_t HPLUSART1M$IFG2 __asm ("0x0003");
 static volatile uint8_t HPLUSART1M$U1TCTL __asm ("0x0079");
 static volatile uint8_t HPLUSART1M$U1TXBUF __asm ("0x007F");

uint16_t HPLUSART1M$l_br;
uint8_t HPLUSART1M$l_mctl;
uint8_t HPLUSART1M$l_ssel;

void sig_UART1RX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(6))) ;




void sig_UART1TX_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(4))) ;



static inline   bool HPLUSART1M$USARTControl$isSPI(void);








static inline   bool HPLUSART1M$USARTControl$isUART(void);










static inline   bool HPLUSART1M$USARTControl$isUARTtx(void);










static inline   bool HPLUSART1M$USARTControl$isUARTrx(void);
#line 107
static inline   bool HPLUSART1M$USARTControl$isI2C(void);



static inline   msp430_usartmode_t HPLUSART1M$USARTControl$getMode(void);
#line 158
static inline   void HPLUSART1M$USARTControl$disableUART(void);
#line 191
static inline   void HPLUSART1M$USARTControl$disableSPI(void);
#line 252
static inline void HPLUSART1M$setUARTModeCommon(void);
#line 325
static inline   void HPLUSART1M$USARTControl$setModeUART(void);
#line 341
static inline   void HPLUSART1M$USARTControl$setClockSource(uint8_t source);







static inline   void HPLUSART1M$USARTControl$setClockRate(uint16_t baudrate, uint8_t mctl);
#line 392
static inline   result_t HPLUSART1M$USARTControl$enableRxIntr(void);







static inline   result_t HPLUSART1M$USARTControl$enableTxIntr(void);







static inline   result_t HPLUSART1M$USARTControl$tx(uint8_t data);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SNMSM$EReportControl$init(void);






static  result_t SNMSM$EReportControl$start(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t SNMSM$Leds$greenToggle(void);
#line 131
static   result_t SNMSM$Leds$yellowToggle(void);
#line 81
static   result_t SNMSM$Leds$redToggle(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SNMSM$RPCControl$init(void);






static  result_t SNMSM$RPCControl$start(void);
# 96 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
uint16_t SNMSM$rstdelayCount;
bool SNMSM$toBeRestart;

static inline  result_t SNMSM$StdControl$init(void);
#line 122
static inline  result_t SNMSM$StdControl$start(void);
#line 169
static inline  result_t SNMSM$ledsOn(uint8_t ledColorParam);
#line 280
static inline  void SNMSM$restart(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t EventReportM$EventReport$eventSendDone(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x41169e18, 
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
TOS_MsgPtr arg_0x40a2b4e0, result_t arg_0x40a2b670);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t EventReportM$EventSend$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
#line 106
static  void *EventReportM$EventSend$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0);
# 86 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
bool EventReportM$gfSendBusy;
bool EventReportM$taskBusy;





uint8_t EventReportM$gLevelMode[6];

uint8_t EventReportM$seqno;

Queue_t EventReportM$sendQueue;
Queue_t EventReportM$buffQueue;
TOS_Msg EventReportM$eventBuffer[3];







static inline void EventReportM$initialize(void);
static void EventReportM$tryNextSend(void);
static inline void EventReportM$assignPriority(TOS_MsgPtr msg, uint8_t level);

static inline  void EventReportM$sendEvent(void);


static inline void EventReportM$initialize(void);
#line 145
static inline  result_t EventReportM$StdControl$init(void);





static inline  result_t EventReportM$StdControl$start(void);









static inline  result_t EventReportM$EventConfig$setReportLevel(uint8_t type, uint8_t level);
#line 175
static inline  uint8_t EventReportM$EventConfig$getReportLevel(uint8_t type);
#line 187
static inline  uint8_t EventReportM$EventReport$eventSend(uint8_t eventType, uint8_t type, 
uint8_t level, 
uint8_t *content);
#line 244
static inline   result_t EventReportM$EventReport$default$eventSendDone(uint8_t eventType, TOS_MsgPtr pMsg, result_t success);
#line 263
static  result_t EventReportM$EventSend$sendDone(TOS_MsgPtr pMsg, result_t success);
#line 298
static void EventReportM$tryNextSend(void);
#line 312
static inline void EventReportM$assignPriority(TOS_MsgPtr msg, uint8_t level);




static inline  void EventReportM$sendEvent(void);
# 42 "build/telosb/RpcM.nc"
static  void RpcM$SNMSM_restart(void);
#line 39
static  ramSymbol_t RpcM$RamSymbolsM_peek(unsigned int arg_0x41196bb8, uint8_t arg_0x41196d40, bool arg_0x41196ed0);
# 2 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setSink(bool arg_0x41197068);

static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$releaseParent(void);
#line 3
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setParent(uint16_t arg_0x41197510);


static  uint16_t RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval(void);
#line 5
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x41197cc0);
# 35 "/home/xu/oasis/interfaces/SensingConfig.nc"
static  result_t RpcM$SmartSensingM_SensingConfig$setDataPriority(uint8_t arg_0x40a044a8, uint8_t arg_0x40a04638);

static  uint8_t RpcM$SmartSensingM_SensingConfig$getDataPriority(uint8_t arg_0x40a04ad0);
#line 31
static  result_t RpcM$SmartSensingM_SensingConfig$setADCChannel(uint8_t arg_0x40a06948, uint8_t arg_0x40a06ad0);
#line 27
static  result_t RpcM$SmartSensingM_SensingConfig$setSamplingRate(uint8_t arg_0x40a07e08, uint16_t arg_0x40a06010);





static  uint8_t RpcM$SmartSensingM_SensingConfig$getADCChannel(uint8_t arg_0x40a04010);
#line 29
static  uint16_t RpcM$SmartSensingM_SensingConfig$getSamplingRate(uint8_t arg_0x40a064b0);
#line 43
static  result_t RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(uint8_t arg_0x40a037b0, uint16_t arg_0x40a03940);
#line 39
static  result_t RpcM$SmartSensingM_SensingConfig$setNodePriority(uint8_t arg_0x40a03010);





static  uint16_t RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(uint8_t arg_0x40a03de8);
#line 41
static  uint8_t RpcM$SmartSensingM_SensingConfig$getNodePriority(void);
# 40 "build/telosb/RpcM.nc"
static  unsigned int RpcM$RamSymbolsM_poke(ramSymbol_t *arg_0x4119e3e8);
#line 34
static  uint8_t RpcM$GenericCommProM_getRFChannel(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t RpcM$ResponseSend$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
#line 106
static  void *RpcM$ResponseSend$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0);
# 36 "build/telosb/RpcM.nc"
static  result_t RpcM$GenericCommProM_setRFChannel(uint8_t arg_0x411aaa90);




static  result_t RpcM$SNMSM_ledsOn(uint8_t arg_0x4119e888);
#line 35
static  uint8_t RpcM$GenericCommProM_getRFPower(void);
# 47 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
static  uint8_t RpcM$EventReportM_EventConfig$getReportLevel(uint8_t arg_0x41143ec0);
#line 38
static  result_t RpcM$EventReportM_EventConfig$setReportLevel(uint8_t arg_0x41143778, uint8_t arg_0x41143900);
# 37 "build/telosb/RpcM.nc"
static  result_t RpcM$GenericCommProM_setRFPower(uint8_t arg_0x4119f010);
#line 49
TOS_Msg RpcM$cmdStore;
TOS_Msg RpcM$sendMsgBuf;
TOS_MsgPtr RpcM$sendMsgPtr;

uint16_t RpcM$cmdStoreLength;


bool RpcM$processingCommand;



bool RpcM$taskBusy;

uint8_t RpcM$seqno;

uint16_t RpcM$debugSequenceNo;

static const uint8_t RpcM$args_sizes[25] = { 
sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
0, 
0, 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
0, 
0, 
sizeof(uint16_t ), 
sizeof(uint16_t ), 
sizeof(bool ), 
sizeof(unsigned int ) + sizeof(uint8_t ) + sizeof(bool ), 
sizeof(ramSymbol_t ), 
sizeof(uint8_t ), 
0, 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
0, 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint16_t ), 
sizeof(uint8_t ) + sizeof(uint16_t ) };


static const uint8_t RpcM$return_sizes[25] = { 
sizeof(uint8_t ), 
sizeof(result_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(uint16_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(ramSymbol_t ), 
sizeof(unsigned int ), 
sizeof(result_t ), 
sizeof(void ), 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint16_t ), 
sizeof(uint16_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ) };


static inline  result_t RpcM$StdControl$init(void);
#line 135
static inline  result_t RpcM$StdControl$start(void);






static void RpcM$tryNextSend(void);
static inline  void RpcM$sendResponse(void);

static inline  void RpcM$processCommand(void);
#line 601
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr pMsg, void *payload, uint16_t payloadLength);
#line 697
static void RpcM$tryNextSend(void);






static inline  void RpcM$sendResponse(void);
#line 749
static inline  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr pMsg, result_t success);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopLQI$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t MultiHopLQI$Random$rand(void);
# 6 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopLQI$MultihopCtrl$readyToSend(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t MultiHopLQI$EventReport$eventSend(uint8_t arg_0x40a2ca80, 
uint8_t arg_0x40a2cc18, 
uint8_t *arg_0x40a2cdd0);
# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
static  bool MultiHopLQI$NeighborCtrl$addChild(uint16_t arg_0x412209c8, uint16_t arg_0x41220b60, bool arg_0x41220cf0);







static  bool MultiHopLQI$NeighborCtrl$setCost(uint16_t arg_0x4121d7d8, uint16_t arg_0x4121d968);
#line 5
static  bool MultiHopLQI$NeighborCtrl$setParent(uint16_t arg_0x41220098);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopLQI$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
# 92 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
enum MultiHopLQI$__nesc_unnamed4324 {




  MultiHopLQI$TOS_BASE_ADDRESS = 0, 



  MultiHopLQI$BASE_STATION_ADDRESS = 10, 




  MultiHopLQI$BEACON_PERIOD = 10, 





  MultiHopLQI$BEACON_TIMEOUT = 6
};


enum MultiHopLQI$__nesc_unnamed4325 {
  MultiHopLQI$ROUTE_INVALID = 0xff
};

TOS_Msg MultiHopLQI$msgBuf;
bool MultiHopLQI$msgBufBusy;

bool MultiHopLQI$fixedParent = FALSE;
bool MultiHopLQI$receivedBeacon = FALSE;
uint16_t MultiHopLQI$gbCurrentParent;
uint16_t MultiHopLQI$gbCurrentParentCost;
uint16_t MultiHopLQI$gbCurrentLinkEst;
uint8_t MultiHopLQI$gbCurrentHopCount;
uint16_t MultiHopLQI$gbCurrentCost;

uint8_t MultiHopLQI$gLastHeard;
int16_t MultiHopLQI$gCurrentSeqNo;
uint16_t MultiHopLQI$gUpdateInterval;

uint8_t MultiHopLQI$gRecentIndex;
uint16_t MultiHopLQI$gRecentPacketSender[10];
int16_t MultiHopLQI$gRecentPacketSeqNo[10];

uint8_t MultiHopLQI$gRecentOriginIndex;
uint16_t MultiHopLQI$gRecentOriginPacketSender[10];
int16_t MultiHopLQI$gRecentOriginPacketSeqNo[10];
uint8_t MultiHopLQI$gRecentOriginPacketTTL[10];

bool MultiHopLQI$localBeSink;
uint16_t MultiHopLQI$gbLinkQuality;

static uint16_t MultiHopLQI$adjustLQI(uint8_t val);





static  void MultiHopLQI$SendRouteTask(void);
#line 187
static inline  void MultiHopLQI$TimerTask(void);
#line 219
static inline  result_t MultiHopLQI$StdControl$init(void);
#line 264
static inline  result_t MultiHopLQI$StdControl$start(void);
#line 280
static inline  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr Msg, uint8_t id, 
uint8_t resend);
#line 339
static inline  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr Msg, uint8_t id);
#line 352
static inline  uint16_t MultiHopLQI$RouteControl$getParent(void);



static inline  uint16_t MultiHopLQI$RouteControl$getQuality(void);
#line 374
static inline  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t Interval);









static inline  result_t MultiHopLQI$RouteControl$setParent(uint16_t parentAddr);










static inline  result_t MultiHopLQI$RouteControl$releaseParent(void);
#line 418
static inline  bool MultiHopLQI$RouteControl$isSink(void);


static inline  result_t MultiHopLQI$Timer$fired(void);








static inline  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr Msg);
#line 523
static inline  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr pMsg, result_t success);





static inline  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);





static inline  result_t MultiHopLQI$MultihopCtrl$switchParent(void);
#line 558
static inline  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect);









static inline  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool enable);
#line 602
static inline  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t parentAddr);





static inline  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void);





static inline  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t seconds);





static inline  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void);
# 39 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
ramSymbol_t RamSymbolsM$symbol;

static inline  unsigned int RamSymbolsM$poke(ramSymbol_t *p_symbol);
#line 53
static inline  ramSymbol_t RamSymbolsM$peek(unsigned int memAddress, uint8_t length, bool dereference);
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLPowerManagementM.nc"
static inline   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t ClockTimeStampingM$LocalTime$read(void);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t ClockTimeStampingM$HPLCC2420RAM$write(uint16_t arg_0x40e23d00, uint8_t arg_0x40e23e88, uint8_t *arg_0x40e22068);
# 26 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
uint32_t ClockTimeStampingM$rcv_time;
TOS_MsgPtr ClockTimeStampingM$rcv_message;
enum ClockTimeStampingM$__nesc_unnamed4326 {
  ClockTimeStampingM$TX_FIFO_MSG_START = 10, 



  ClockTimeStampingM$SEND_TIME_CORRECTION = 0
};
#line 58
static inline   void ClockTimeStampingM$RadioSendCoordinator$startSymbol(uint8_t bitsPerBlock, 
uint8_t offset, 
TOS_MsgPtr msgBuff);
#line 123
static inline   void ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(uint8_t bitsPerBlock, 
uint8_t offset, 
TOS_MsgPtr msgBuff);
#line 138
static inline  result_t ClockTimeStampingM$TimeStamping$getStamp(TOS_MsgPtr ourMessage, 
uint32_t *timeStamp);
#line 165
static inline   result_t ClockTimeStampingM$HPLCC2420RAM$writeDone(uint16_t addr, 
uint8_t length, 
uint8_t *buffer);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t DataMgmtM$BatchTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
#line 59
static  result_t DataMgmtM$SysCheckTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t DataMgmtM$SysCheckTimer$stop(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t DataMgmtM$Send$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
#line 106
static  void *DataMgmtM$Send$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t DataMgmtM$SubControl$init(void);






static  result_t DataMgmtM$SubControl$start(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t DataMgmtM$Leds$greenToggle(void);
#line 131
static   result_t DataMgmtM$Leds$yellowToggle(void);
# 68 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
 uint16_t DataMgmtM$seqno;

 bool DataMgmtM$sendTaskBusy;

 bool DataMgmtM$presendTaskBusy;

 bool DataMgmtM$processTaskBusy;

 uint8_t DataMgmtM$sysCheckCount;

 uint8_t DataMgmtM$sendDoneFailCheckCount;

 uint16_t DataMgmtM$sendQueueLen;

 uint16_t DataMgmtM$sendDoneR_num;

 uint16_t DataMgmtM$send_num;

 uint16_t DataMgmtM$Msg_length;

uint16_t DataMgmtM$sendCalled;
uint16_t DataMgmtM$presendTaskCount;
uint16_t DataMgmtM$trynextSendCount;
uint16_t DataMgmtM$processTaskCount;
uint16_t DataMgmtM$batchTimerCount;
uint16_t DataMgmtM$allocbuffercount;
uint16_t DataMgmtM$f_allocbuffercount;
uint16_t DataMgmtM$freebuffercount;
uint16_t DataMgmtM$nothingtosend;


TOS_MsgPtr DataMgmtM$headSendQueue;

TOS_Msg DataMgmtM$buffMsg[MAX_SENSING_QUEUE_SIZE];

Queue_t DataMgmtM$buffQueue;

Queue_t DataMgmtM$sendQueue;

MemQueue_t DataMgmtM$sensorMem;

uint16_t DataMgmtM$processloopCount;
uint16_t DataMgmtM$GlobaltaskCode;


static result_t DataMgmtM$tryNextSend(void);
static inline result_t DataMgmtM$insertAndStartSend(TOS_MsgPtr );
static  void DataMgmtM$presendTask(void);
static  void DataMgmtM$processTask(void);
static inline  void DataMgmtM$sendTask(void);





static inline void DataMgmtM$initialize(void);
#line 158
static inline  result_t DataMgmtM$StdControl$init(void);
#line 170
static inline  result_t DataMgmtM$StdControl$start(void);
#line 191
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t client);
#line 228
static  result_t DataMgmtM$DataMgmt$freeBlk(void *obj);
#line 263
static inline  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t type);
#line 306
static inline  result_t DataMgmtM$DataMgmt$saveBlk(void *obj, uint8_t mediumType);
#line 330
static inline  result_t DataMgmtM$BatchTimer$fired(void);
#line 353
static inline  result_t DataMgmtM$SysCheckTimer$fired(void);
#line 399
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr pMsg, result_t success);
#line 426
static inline  void DataMgmtM$sendTask(void);
#line 473
static inline result_t DataMgmtM$insertAndStartSend(TOS_MsgPtr msg);
#line 489
static result_t DataMgmtM$tryNextSend(void);
#line 509
static  void DataMgmtM$presendTask(void);
#line 602
static  void DataMgmtM$processTask(void);
# 65 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   msp430ADCresult_t ADCM$MSP430ADC12Single$getData(void);
#line 50
static  result_t ADCM$MSP430ADC12Single$bind(MSP430ADC12Settings_t arg_0x4133e958);
#line 117
static   result_t ADCM$MSP430ADC12Single$unreserve(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t ADCM$Leds$greenToggle(void);
#line 131
static   result_t ADCM$Leds$yellowToggle(void);
#line 81
static   result_t ADCM$Leds$redToggle(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t ADCM$ADC$dataReady(
# 47 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
uint8_t arg_0x41345b10, 
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0x40a7c788);
# 61 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
enum ADCM$__nesc_unnamed4327 {


  ADCM$TOSH_ADC_PORTMAPSIZE = 12
};





 uint8_t ADCM$TOSH_adc_portmap[ADCM$TOSH_ADC_PORTMAPSIZE];
uint16_t ADCM$adc_count[ADCM$TOSH_ADC_PORTMAPSIZE];
 uint8_t ADCM$samplingRate;
 bool ADCM$continuousData;
 uint8_t ADCM$owner;
uint8_t ADCM$g_port;
bool ADCM$initialized;
 volatile bool ADCM$busy;
 volatile bool ADCM$readdone;

static inline  result_t ADCM$StdControl$init(void);





static inline  result_t ADCM$StdControl$start(void);
#line 100
static  result_t ADCM$ADCControl$init(void);
#line 127
static  result_t ADCM$ADCControl$bindPort(uint8_t port, uint8_t adcPort);









static result_t ADCM$triggerConversion(uint8_t port);
#line 160
static  void ADCM$readADCTask(void);










static  void ADCM$readLightTask(void);










static inline   result_t ADCM$ADC$getData(uint8_t port);
#line 246
static   result_t ADCM$MSP430ADC12Single$dataReady(uint16_t d);
# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
static   result_t HamamatsuM$TSRSingle$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8);
# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   msp430ADCresult_t HamamatsuM$MSP430ADC12MultipleTSR$getData(uint16_t *arg_0x413b57e8, uint16_t arg_0x413b5978, uint16_t arg_0x413b5b08);
# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
static   uint16_t *HamamatsuM$TSRMultiple$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0);
# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   msp430ADCresult_t HamamatsuM$MSP430ADC12MultiplePAR$getData(uint16_t *arg_0x413b57e8, uint16_t arg_0x413b5978, uint16_t arg_0x413b5b08);
# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
static   uint16_t *HamamatsuM$PARMultiple$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0);
# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
static   result_t HamamatsuM$PARSingle$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8);
# 46 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
 bool HamamatsuM$contMode;
#line 105
static inline   result_t HamamatsuM$MSP430ADC12SinglePAR$dataReady(uint16_t data);





static inline    result_t HamamatsuM$PARSingle$default$dataReady(adcresult_t result, uint16_t data);
#line 159
static   uint16_t *HamamatsuM$MSP430ADC12MultiplePAR$dataReady(uint16_t *buf, uint16_t length);
#line 172
static inline    uint16_t *HamamatsuM$PARMultiple$default$dataReady(adcresult_t result, uint16_t *buf, uint16_t length);
#line 212
static inline   result_t HamamatsuM$MSP430ADC12SingleTSR$dataReady(uint16_t data);





static inline    result_t HamamatsuM$TSRSingle$default$dataReady(adcresult_t result, uint16_t data);
#line 266
static   uint16_t *HamamatsuM$MSP430ADC12MultipleTSR$dataReady(uint16_t *buf, uint16_t length);
#line 279
static inline    uint16_t *HamamatsuM$TSRMultiple$default$dataReady(adcresult_t result, uint16_t *buf, uint16_t length);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430ADC12M$CompareA1$setEvent(uint16_t arg_0x408d6eb0);
# 118 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
static   RefVolt_t MSP430ADC12M$RefVolt$getState(void);
#line 109
static   result_t MSP430ADC12M$RefVolt$release(void);
#line 93
static   result_t MSP430ADC12M$RefVolt$get(RefVolt_t arg_0x413e2cf8);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void MSP430ADC12M$ControlA0$setControl(MSP430CompareControl_t arg_0x408c29a8);
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
static   result_t MSP430ADC12M$ADCSingle$dataReady(
# 41 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bcd90, 
# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
uint16_t arg_0x4133cdc8);
# 37 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
static   void MSP430ADC12M$TimerA$clear(void);

static   void MSP430ADC12M$TimerA$setClockSource(uint16_t arg_0x408b88a8);
#line 38
static   void MSP430ADC12M$TimerA$disableEvents(void);
#line 35
static   void MSP430ADC12M$TimerA$setMode(int arg_0x408b9aa0);




static   void MSP430ADC12M$TimerA$setInputDivider(uint16_t arg_0x408b8d60);
# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
static   uint16_t *MSP430ADC12M$ADCMultiple$dataReady(
# 42 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
uint8_t arg_0x413bb8d8, 
# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
uint16_t *arg_0x413b0010, uint16_t arg_0x413b01a0);
# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
static   void MSP430ADC12M$ControlA1$setControl(MSP430CompareControl_t arg_0x408c29a8);
# 58 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void MSP430ADC12M$HPLADC12$resetIFGs(void);
#line 43
static   void MSP430ADC12M$HPLADC12$setControl1(adc12ctl1_t arg_0x413fc4e8);
#line 80
static   void MSP430ADC12M$HPLADC12$disableConversion(void);
#line 48
static   void MSP430ADC12M$HPLADC12$setControl0_IgnoreRef(adc12ctl0_t arg_0x413fa010);


static   adc12memctl_t MSP430ADC12M$HPLADC12$getMemControl(uint8_t arg_0x413fab10);
#line 81
static   void MSP430ADC12M$HPLADC12$startConversion(void);
#line 52
static   uint16_t MSP430ADC12M$HPLADC12$getMem(uint8_t arg_0x413f9010);


static   void MSP430ADC12M$HPLADC12$setIEFlags(uint16_t arg_0x413f94c0);
#line 69
static   void MSP430ADC12M$HPLADC12$setSHT(uint8_t arg_0x413f6688);
#line 50
static   void MSP430ADC12M$HPLADC12$setMemControl(uint8_t arg_0x413fa4b8, adc12memctl_t arg_0x413fa650);
#line 82
static   void MSP430ADC12M$HPLADC12$stopConversion(void);
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
static   void MSP430ADC12M$CompareA0$setEvent(uint16_t arg_0x408d6eb0);
# 58 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
 uint8_t MSP430ADC12M$cmode;
 uint16_t *MSP430ADC12M$bufPtr;
 uint16_t MSP430ADC12M$bufLength;
 uint16_t MSP430ADC12M$bufOffset;
 uint8_t MSP430ADC12M$owner;
 uint8_t MSP430ADC12M$reserved;
 uint8_t MSP430ADC12M$vrefWait;
 adc12settings_t MSP430ADC12M$adc12settings[5U];

static inline  result_t MSP430ADC12M$StdControl$init(void);









static inline  result_t MSP430ADC12M$StdControl$start(void);
#line 89
static inline void MSP430ADC12M$configureAdcPin(uint8_t inputChannel);







static inline  result_t MSP430ADC12M$ADCSingle$bind(uint8_t num, MSP430ADC12Settings_t settings);
#line 130
static inline msp430ADCresult_t MSP430ADC12M$getRefVolt(uint8_t num);
#line 158
static inline result_t MSP430ADC12M$releaseRefVolt(uint8_t num);









static void MSP430ADC12M$prepareTimerA(uint16_t interval, uint16_t csSAMPCON, uint16_t cdSAMPCON);
#line 184
static void MSP430ADC12M$startTimerA(void);
#line 203
static msp430ADCresult_t MSP430ADC12M$newRequest(uint8_t req, uint8_t num, void *dataDest, uint16_t length, uint16_t jiffies);
#line 331
static inline result_t MSP430ADC12M$unreserve(uint8_t num);








static inline   msp430ADCresult_t MSP430ADC12M$ADCSingle$getData(uint8_t num);
#line 365
static inline   result_t MSP430ADC12M$ADCSingle$unreserve(uint8_t num);




static inline   msp430ADCresult_t MSP430ADC12M$ADCMultiple$getData(uint8_t num, uint16_t *buf, 
uint16_t length, uint16_t jiffies);
#line 405
static inline   void MSP430ADC12M$TimerA$overflow(void);
static inline   void MSP430ADC12M$CompareA0$fired(void);
static inline   void MSP430ADC12M$CompareA1$fired(void);

static inline    result_t MSP430ADC12M$ADCSingle$default$dataReady(uint8_t num, uint16_t data);



static inline    uint16_t *MSP430ADC12M$ADCMultiple$default$dataReady(uint8_t num, uint16_t *buf, 
uint16_t length);




static  void MSP430ADC12M$RefVolt$isStable(RefVolt_t vref);










static void MSP430ADC12M$stopConversion(void);










static inline   void MSP430ADC12M$HPLADC12$converted(uint8_t number);
#line 496
static inline   void MSP430ADC12M$HPLADC12$memOverflow(void);
static inline   void MSP430ADC12M$HPLADC12$timeOverflow(void);
# 61 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void HPLADC12M$HPLADC12$memOverflow(void);

static   void HPLADC12M$HPLADC12$converted(uint8_t arg_0x413f8a00);
#line 62
static   void HPLADC12M$HPLADC12$timeOverflow(void);
# 44 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
 static volatile uint16_t HPLADC12M$ADC12CTL0 __asm ("0x01A0");
 static volatile uint16_t HPLADC12M$ADC12CTL1 __asm ("0x01A2");
 static volatile uint16_t HPLADC12M$ADC12IFG __asm ("0x01A4");
 static volatile uint16_t HPLADC12M$ADC12IE __asm ("0x01A6");
 static volatile uint16_t HPLADC12M$ADC12IV __asm ("0x01A8");





static inline   void HPLADC12M$HPLADC12$setControl1(adc12ctl1_t control1);



static inline   void HPLADC12M$HPLADC12$setControl0_IgnoreRef(adc12ctl0_t control0);
#line 73
static   void HPLADC12M$HPLADC12$setMemControl(uint8_t i, adc12memctl_t memControl);







static inline   adc12memctl_t HPLADC12M$HPLADC12$getMemControl(uint8_t i);









static inline   uint16_t HPLADC12M$HPLADC12$getMem(uint8_t i);



static inline   void HPLADC12M$HPLADC12$setIEFlags(uint16_t mask);


static   void HPLADC12M$HPLADC12$resetIFGs(void);
#line 112
static inline   bool HPLADC12M$HPLADC12$isBusy(void);


static inline   void HPLADC12M$HPLADC12$disableConversion(void);
static inline   void HPLADC12M$HPLADC12$startConversion(void);
static inline   void HPLADC12M$HPLADC12$stopConversion(void);
#line 137
static inline   void HPLADC12M$HPLADC12$setRefOn(void);
static inline   void HPLADC12M$HPLADC12$setRefOff(void);

static inline   void HPLADC12M$HPLADC12$setRef1_5V(void);
static inline   void HPLADC12M$HPLADC12$setRef2_5V(void);


static inline   void HPLADC12M$HPLADC12$setSHT(uint8_t sht);
#line 163
void sig_ADC_VECTOR(void)  __attribute((wakeup)) __attribute((interrupt(14))) ;
# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t RefVoltM$SwitchOffTimer$setOneShot(int32_t arg_0x40c2c340);
# 127 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
static  void RefVoltM$RefVolt$isStable(RefVolt_t arg_0x413e8578);
# 73 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
static   void RefVoltM$HPLADC12$setRefOff(void);
#line 65
static   bool RefVoltM$HPLADC12$isBusy(void);










static   void RefVoltM$HPLADC12$setRef2_5V(void);



static   void RefVoltM$HPLADC12$disableConversion(void);
#line 72
static   void RefVoltM$HPLADC12$setRefOn(void);


static   void RefVoltM$HPLADC12$setRef1_5V(void);
# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
static  result_t RefVoltM$SwitchOnTimer$setOneShot(int32_t arg_0x40c2c340);
# 84 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
enum RefVoltM$__nesc_unnamed4328 {

  RefVoltM$REFERENCE_OFF, 
  RefVoltM$REFERENCE_1_5V_PENDING, 
  RefVoltM$REFERENCE_2_5V_PENDING, 
  RefVoltM$REFERENCE_1_5V_STABLE, 
  RefVoltM$REFERENCE_2_5V_STABLE
};

 uint8_t RefVoltM$semaCount;
 uint8_t RefVoltM$state;
 bool RefVoltM$switchOff;

static __inline void RefVoltM$switchRefOn(uint8_t vref);
static __inline void RefVoltM$switchRefOff(void);
static __inline void RefVoltM$switchToRefStable(uint8_t vref);
static __inline void RefVoltM$switchToRefPending(uint8_t vref);

static inline  void RefVoltM$switchOnDelay(void);
static inline  void RefVoltM$switchOffDelay(void);
static inline  void RefVoltM$switchOffRetry(void);

static   result_t RefVoltM$RefVolt$get(RefVolt_t vref);
#line 140
static __inline void RefVoltM$switchRefOn(uint8_t vref);
#line 154
static __inline void RefVoltM$switchToRefPending(uint8_t vref);



static __inline void RefVoltM$switchToRefStable(uint8_t vref);



static inline  void RefVoltM$switchOnDelay(void);



static inline  result_t RefVoltM$SwitchOnTimer$fired(void);
#line 180
static inline   result_t RefVoltM$RefVolt$release(void);
#line 205
static __inline void RefVoltM$switchRefOff(void);
#line 225
static inline  void RefVoltM$switchOffDelay(void);




static inline  void RefVoltM$switchOffRetry(void);




static inline  result_t RefVoltM$SwitchOffTimer$fired(void);




static inline   RefVolt_t RefVoltM$RefVolt$getState(void);







static inline   void RefVoltM$HPLADC12$memOverflow(void);
static inline   void RefVoltM$HPLADC12$timeOverflow(void);
static inline   void RefVoltM$HPLADC12$converted(uint8_t number);
# 71 "/home/xu/oasis/lib/MultiHopOasis/RouteSelect.nc"
static  result_t MultiHopEngineM$RouteSelect$selectRoute(TOS_MsgPtr arg_0x411f8238, uint8_t arg_0x411f83c0, uint8_t arg_0x411f8548);
#line 86
static  result_t MultiHopEngineM$RouteSelect$initializeFields(TOS_MsgPtr arg_0x411f8b58, uint8_t arg_0x411f8ce0);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Intercept$intercept(
# 19 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e1e20, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
# 116 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
static  bool MultiHopEngineM$RouteSelectCntl$isSink(void);
#line 84
static  uint16_t MultiHopEngineM$RouteSelectCntl$getQuality(void);
#line 49
static  uint16_t MultiHopEngineM$RouteSelectCntl$getParent(void);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Snoop$intercept(
# 20 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e0420, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t MultiHopEngineM$Send$sendDone(
# 17 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
uint8_t arg_0x414e10f8, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopEngineM$MultihopCtrl$addChild(uint16_t arg_0x41231718, uint16_t arg_0x412318b0, bool arg_0x41231a40);
#line 2
static  result_t MultiHopEngineM$MultihopCtrl$switchParent(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopEngineM$SubControl$init(void);






static  result_t MultiHopEngineM$SubControl$start(void);
# 72 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t MultiHopEngineM$Leds$redOff(void);
#line 64
static   result_t MultiHopEngineM$Leds$redOn(void);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopEngineM$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopEngineM$RouteStatusTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 54 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
#line 47
typedef struct MultiHopEngineM$SendQueueEntryInfo {
  uint8_t valid;
  uint8_t AMID;
  uint8_t resend;
  uint16_t length;
  TOS_MsgPtr msgPtr;
  TOS_MsgPtr originalTOSPtr;
} MultiHopEngineM$SendQueueEntryInfo;

enum MultiHopEngineM$__nesc_unnamed4329 {
  MultiHopEngineM$NETWORKMSG_HEADER_LENGTH = 10, 
  MultiHopEngineM$SUCCESSIVE_TRANSMITE_FAILURE_THRESHOLD = 15, 
  MultiHopEngineM$ROUTE_STATUS_CHECK_PERIOD = 6 * 1024, 

  MultiHopEngineM$WDT_UPDATE_PERIOD = 10, 
  MultiHopEngineM$WDT_UPDATE_UNIT = 1024 * 60
};
bool MultiHopEngineM$sendTaskBusy;
Queue_t MultiHopEngineM$sendQueue;
Queue_t MultiHopEngineM$buffQueue;
TOS_Msg MultiHopEngineM$poolBuffer[5];
MultiHopEngineM$SendQueueEntryInfo MultiHopEngineM$queueEntryInfo[5];
bool MultiHopEngineM$messageIsRetransmission;
uint16_t MultiHopEngineM$numberOfSendFailures;
uint16_t MultiHopEngineM$numberOfSendSuccesses;
bool MultiHopEngineM$useMhopPriority;
uint8_t MultiHopEngineM$numOfPktProcessing;
uint16_t MultiHopEngineM$numOfSuccessiveFailures;
bool MultiHopEngineM$beRadioActive;
uint8_t MultiHopEngineM$wdtTimerCnt;
bool MultiHopEngineM$beParentActive;
uint16_t MultiHopEngineM$localSendFail;
uint16_t MultiHopEngineM$numLocalPendingPkt;
uint16_t MultiHopEngineM$falseType;

static inline void MultiHopEngineM$initialize(void);
#line 107
static inline uint8_t MultiHopEngineM$allocateInfoEntry(void);
static result_t MultiHopEngineM$freeInfoEntry(uint8_t ind);
static uint8_t MultiHopEngineM$findInfoEntry(TOS_MsgPtr pMsg);
static result_t MultiHopEngineM$insertAndStartSend(TOS_MsgPtr msg, 
uint16_t AMID, 
uint16_t length, 
TOS_MsgPtr originalTOSPtr);
static result_t MultiHopEngineM$tryNextSend(void);
static inline result_t MultiHopEngineM$checkForDuplicates(TOS_MsgPtr msg, bool disable);

static inline  result_t MultiHopEngineM$StdControl$init(void);






static inline  result_t MultiHopEngineM$StdControl$start(void);
#line 147
static  result_t MultiHopEngineM$Send$send(uint8_t AMID, TOS_MsgPtr msg, uint16_t length);
#line 174
static  void *MultiHopEngineM$Send$getBuffer(uint8_t AMID, TOS_MsgPtr msg, uint16_t *length);
#line 186
static inline  void MultiHopEngineM$sendTask(void);
#line 254
static inline  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr msg, result_t success);
#line 327
static result_t MultiHopEngineM$insertAndStartSend(TOS_MsgPtr msg, 
uint16_t AMID, 
uint16_t length, 
TOS_MsgPtr originalTOSPtr);
#line 392
static result_t MultiHopEngineM$tryNextSend(void);
#line 409
static inline  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr msg);
#line 478
static inline  result_t MultiHopEngineM$RouteStatusTimer$fired(void);
#line 498
static inline  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void);










static inline result_t MultiHopEngineM$checkForDuplicates(TOS_MsgPtr msg, bool disable);
#line 531
static inline  uint16_t MultiHopEngineM$RouteControl$getParent(void);



static inline  uint16_t MultiHopEngineM$RouteControl$getQuality(void);
#line 582
static inline uint8_t MultiHopEngineM$allocateInfoEntry(void);










static uint8_t MultiHopEngineM$findInfoEntry(TOS_MsgPtr pMsg);
#line 606
static result_t MultiHopEngineM$freeInfoEntry(uint8_t ind);
#line 621
static inline   result_t MultiHopEngineM$Send$default$sendDone(uint8_t AMID, TOS_MsgPtr pMsg, 
result_t success);




static inline   result_t MultiHopEngineM$Intercept$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen);



static inline   result_t MultiHopEngineM$Snoop$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesRouterM$SubSend$send(
# 40 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x41550e50, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$DTTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
#line 59
static  result_t CascadesRouterM$RTTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t CascadesRouterM$RTTimer$stop(void);
#line 59
static  result_t CascadesRouterM$DelayTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t CascadesRouterM$DelayTimer$stop(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t CascadesRouterM$Random$rand(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CascadesRouterM$SubControl$init(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr CascadesRouterM$Receive$receive(
# 36 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x415502d0, 
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
TOS_MsgPtr arg_0x40a0f130, void *arg_0x40a0f2d0, uint16_t arg_0x40a0f468);
# 2 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  uint16_t CascadesRouterM$CascadeControl$getParent(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$ResetTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);








static  result_t CascadesRouterM$ResetTimer$stop(void);
#line 59
static  result_t CascadesRouterM$ACKTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 57 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint16_t CascadesRouterM$RTwait;

uint16_t CascadesRouterM$highestSeq;

uint16_t CascadesRouterM$expectingSeq;

uint8_t CascadesRouterM$headIndex;

uint8_t CascadesRouterM$resetCount;

uint16_t CascadesRouterM$nextSignalSeq;

bool CascadesRouterM$inData[MAX_CAS_PACKETS];

bool CascadesRouterM$activeRT;

bool CascadesRouterM$DataTimerOn;

bool CascadesRouterM$DataProcessBusy;

bool CascadesRouterM$RequestProcessBusy;

bool CascadesRouterM$CMAuProcessBusy;

bool CascadesRouterM$sigRcvTaskBusy;

bool CascadesRouterM$delayTimerBusy;

bool CascadesRouterM$ctrlMsgBusy;

bool CascadesRouterM$inited;

TOS_Msg CascadesRouterM$RecvDataMsg;

TOS_Msg CascadesRouterM$RecvRequestMsg;

TOS_Msg CascadesRouterM$RecvCMAuMsg;

TOS_Msg CascadesRouterM$SendCtrlMsg;

CascadesBuffer CascadesRouterM$myBuffer[MAX_CAS_BUF];

static inline  void CascadesRouterM$processData(void);
static inline  void CascadesRouterM$processRequest(void);
static inline  void CascadesRouterM$processCMAu(void);
static  void CascadesRouterM$sigRcvTask(void);

static uint8_t CascadesRouterM$findMsgIndex(uint16_t msgSeq);
static void CascadesRouterM$addChildACK(address_t nodeID, uint8_t myIndex);
static inline result_t CascadesRouterM$addIntoBuffer(TOS_MsgPtr tmPtr);
static inline void CascadesRouterM$processNoData(TOS_MsgPtr tmPtr);
static inline void CascadesRouterM$processACK(TOS_MsgPtr tmPtr);
static inline void CascadesRouterM$produceDataMsg(TOS_MsgPtr tmPtr);
static void CascadesRouterM$produceCtrlMsg(TOS_MsgPtr tmPtr, uint16_t seq, uint8_t type);
static void CascadesRouterM$initialize(void);







static inline NetworkMsg *CascadesRouterM$getCasData(TOS_MsgPtr tmPtr);










static uint8_t CascadesRouterM$findMsgIndex(uint16_t msgSeq);
#line 148
static void CascadesRouterM$addChildACK(address_t nodeID, uint8_t myIndex);
#line 167
static void CascadesRouterM$delFromChildrenList(address_t nodeID);
#line 188
static void CascadesRouterM$addToChildrenList(address_t nodeID);
#line 228
static void CascadesRouterM$clearChildrenListStatus(uint8_t myindex);
#line 241
static inline void CascadesRouterM$updateInData(void);
#line 254
static bool CascadesRouterM$getCMAu(uint8_t myindex);
#line 278
static inline result_t CascadesRouterM$addIntoBuffer(TOS_MsgPtr tmPtr);
#line 305
static inline void CascadesRouterM$produceDataMsg(TOS_MsgPtr tmPtr);
#line 323
static void CascadesRouterM$produceCtrlMsg(TOS_MsgPtr tmPtr, uint16_t seq, uint8_t type);
#line 347
static void CascadesRouterM$initialize(void);
#line 374
static inline  result_t CascadesRouterM$StdControl$init(void);






static inline  result_t CascadesRouterM$StdControl$start(void);







static inline  result_t CascadesRouterM$CascadeControl$addDirectChild(address_t childID);




static inline  result_t CascadesRouterM$CascadeControl$deleteDirectChild(address_t childID);
#line 407
static inline  result_t CascadesRouterM$CascadeControl$parentChanged(address_t newParent);
#line 437
static inline  result_t CascadesRouterM$DTTimer$fired(void);
#line 501
static inline  result_t CascadesRouterM$RTTimer$fired(void);
#line 536
static inline  result_t CascadesRouterM$ResetTimer$fired(void);
#line 556
static inline  result_t CascadesRouterM$DelayTimer$fired(void);







static inline  result_t CascadesRouterM$ACKTimer$fired(void);










static  void CascadesRouterM$sigRcvTask(void);
#line 614
static inline uint32_t CascadesRouterM$crcByte(uint32_t crc, uint8_t b);
#line 627
static inline uint32_t CascadesRouterM$calculateCRC(uint8_t *start, uint8_t length);
#line 640
static inline  void CascadesRouterM$processData(void);
#line 818
static inline  void CascadesRouterM$processCMAu(void);
#line 859
static inline  void CascadesRouterM$processRequest(void);
#line 900
static inline void CascadesRouterM$processACK(TOS_MsgPtr tmPtr);
#line 932
static inline void CascadesRouterM$processNoData(TOS_MsgPtr tmPtr);
#line 960
static  TOS_MsgPtr CascadesRouterM$ReceiveMsg$receive(uint8_t type, TOS_MsgPtr tmsg);
#line 1009
static inline  result_t CascadesRouterM$SubSend$sendDone(uint8_t type, TOS_MsgPtr msg, result_t status);










static inline   TOS_MsgPtr CascadesRouterM$Receive$default$receive(uint8_t type, TOS_MsgPtr pMsg, 
void *payload, uint16_t payloadLen);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t CascadesEngineM$SendMsg$send(
# 39 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x415fc7b8, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesEngineM$MySend$sendDone(
# 36 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x415fc030, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30);
# 45 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
bool CascadesEngineM$sendTaskBusy;

Queue_t CascadesEngineM$sendQueue;

static inline void CascadesEngineM$updateProtocolField(TOS_MsgPtr msg, uint8_t id, uint8_t len);
static result_t CascadesEngineM$tryNextSend(void);
static inline result_t CascadesEngineM$insertAndStartSend(TOS_MsgPtr msg);
static inline  void CascadesEngineM$sendTask(void);

static inline  result_t CascadesEngineM$StdControl$init(void);
#line 68
static  result_t CascadesEngineM$MySend$send(uint8_t type, TOS_MsgPtr msg, uint16_t len);
#line 82
static  result_t CascadesEngineM$SendMsg$sendDone(uint8_t type, TOS_MsgPtr msg, result_t success);
#line 94
static inline   result_t CascadesEngineM$SendMsg$default$send(uint8_t type, uint16_t dest, uint8_t length, TOS_MsgPtr pMsg);




static inline  void CascadesEngineM$sendTask(void);
#line 122
static inline result_t CascadesEngineM$insertAndStartSend(TOS_MsgPtr msg);









static result_t CascadesEngineM$tryNextSend(void);
#line 146
static inline void CascadesEngineM$updateProtocolField(TOS_MsgPtr msg, uint8_t type, uint8_t len);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t NeighborMgmtM$Random$rand(void);
# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  result_t NeighborMgmtM$CascadeControl$addDirectChild(address_t arg_0x41544d38);
static  result_t NeighborMgmtM$CascadeControl$deleteDirectChild(address_t arg_0x415431f0);
static  result_t NeighborMgmtM$CascadeControl$parentChanged(address_t arg_0x41543698);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t NeighborMgmtM$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0);
# 25 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
NBRTableEntry NeighborMgmtM$NeighborTbl[16];
bool NeighborMgmtM$initTime;
bool NeighborMgmtM$processTaskBusy;
uint8_t NeighborMgmtM$lqiBuf;
uint8_t NeighborMgmtM$rssiBuf;
uint16_t NeighborMgmtM$linkaddrBuf;
NetworkMsg *NeighborMgmtM$nwMsg;
uint8_t NeighborMgmtM$ticks;


static void NeighborMgmtM$initialize(void);
static uint8_t NeighborMgmtM$findPreparedIndex(uint16_t id);
static inline uint8_t NeighborMgmtM$findEntryToBeReplaced(void);
static inline uint8_t NeighborMgmtM$findEntry(uint16_t id);
static inline void NeighborMgmtM$newEntry(uint8_t indes, uint16_t id);

static inline  void NeighborMgmtM$timerTask(void);

static inline void NeighborMgmtM$updateTable(void);
static inline  void NeighborMgmtM$processSnoopMsg(void);


static inline  result_t NeighborMgmtM$StdControl$init(void);




static inline  result_t NeighborMgmtM$StdControl$start(void);









static void NeighborMgmtM$initialize(void);









static inline  result_t NeighborMgmtM$Timer$fired(void);









static inline  void NeighborMgmtM$processSnoopMsg(void);
#line 107
static inline  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr msg, void *payload, uint16_t payloadLen);
#line 123
static inline uint8_t NeighborMgmtM$findEntry(uint16_t id);









static inline void NeighborMgmtM$newEntry(uint8_t indes, uint16_t id);
#line 154
static uint8_t NeighborMgmtM$findPreparedIndex(uint16_t id);
#line 170
static inline uint8_t NeighborMgmtM$findEntryToBeReplaced(void);
#line 188
static inline  void NeighborMgmtM$timerTask(void);






static inline void NeighborMgmtM$updateTable(void);
#line 325
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t parent);
#line 341
static inline  bool NeighborMgmtM$NeighborCtrl$clearParent(bool reset);
#line 357
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect);
#line 439
static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t addr, uint16_t parentCost);
#line 465
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void);
# 127 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static inline void MSP430ClockM$startTimerB(void)
{

  MSP430ClockM$TBCTL = 0x0020 | (MSP430ClockM$TBCTL & ~(0x0020 | 0x0010));
}

#line 115
static inline void MSP430ClockM$startTimerA(void)
{

  MSP430ClockM$TA0CTL = 0x0020 | (MSP430ClockM$TA0CTL & ~(0x0020 | 0x0010));
}

#line 220
static inline  result_t MSP430ClockM$StdControl$start(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      MSP430ClockM$startTimerA();
      MSP430ClockM$startTimerB();
    }
#line 226
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HPLInitM$MSP430ClockControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = MSP430ClockM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 84 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static inline  void MSP430ClockM$MSP430ClockInit$defaultInitTimerB(void)
{
  TBR = 0;









  MSP430ClockM$TBCTL = 0x0100 | 0x0002;
}











static inline   void MSP430ClockM$MSP430ClockInit$default$initTimerB(void)
{
  MSP430ClockM$MSP430ClockInit$defaultInitTimerB();
}

# 29 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockInit.nc"
inline static  void MSP430ClockM$MSP430ClockInit$initTimerB(void){
#line 29
  MSP430ClockM$MSP430ClockInit$default$initTimerB();
#line 29
}
#line 29
# 69 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static inline  void MSP430ClockM$MSP430ClockInit$defaultInitTimerA(void)
{
  TA0R = 0;









  MSP430ClockM$TA0CTL = 0x0200 | 0x0002;
}

#line 104
static inline   void MSP430ClockM$MSP430ClockInit$default$initTimerA(void)
{
  MSP430ClockM$MSP430ClockInit$defaultInitTimerA();
}

# 28 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockInit.nc"
inline static  void MSP430ClockM$MSP430ClockInit$initTimerA(void){
#line 28
  MSP430ClockM$MSP430ClockInit$default$initTimerA();
#line 28
}
#line 28
# 48 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static inline  void MSP430ClockM$MSP430ClockInit$defaultInitClocks(void)
{





  BCSCTL1 = 0x80 | (BCSCTL1 & ((0x04 | 0x02) | 0x01));







  BCSCTL2 = 0x04;


  MSP430ClockM$IE1 &= ~(1 << 1);
}

#line 99
static inline   void MSP430ClockM$MSP430ClockInit$default$initClocks(void)
{
  MSP430ClockM$MSP430ClockInit$defaultInitClocks();
}

# 27 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockInit.nc"
inline static  void MSP430ClockM$MSP430ClockInit$initClocks(void){
#line 27
  MSP430ClockM$MSP430ClockInit$default$initClocks();
#line 27
}
#line 27
# 145 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static inline uint16_t MSP430ClockM$test_calib_busywait_delta(int calib)
{
  int8_t aclk_count = 2;
  uint16_t dco_prev = 0;
  uint16_t dco_curr = 0;

  MSP430ClockM$set_dco_calib(calib);

  while (aclk_count-- > 0) 
    {
      TBCCR0 = TBR + MSP430ClockM$ACLK_CALIB_PERIOD;
      TBCCTL0 &= ~0x0001;
      while ((TBCCTL0 & 0x0001) == 0) ;
      dco_prev = dco_curr;
      dco_curr = TA0R;
    }

  return dco_curr - dco_prev;
}




static inline void MSP430ClockM$busyCalibrateDCO(void)
{

  int calib;
  int step;



  MSP430ClockM$TA0CTL = 0x0200 | 0x0020;
  MSP430ClockM$TBCTL = 0x0100 | 0x0020;
  BCSCTL1 = 0x80 | 0x04;
  BCSCTL2 = 0;
  TBCCTL0 = 0x4000;






  for (calib = 0, step = 0x800; step != 0; step >>= 1) 
    {

      if (MSP430ClockM$test_calib_busywait_delta(calib | step) <= MSP430ClockM$TARGET_DCO_DELTA) {
        calib |= step;
        }
    }

  if ((calib & 0x0e0) == 0x0e0) {
    calib &= ~0x01f;
    }
  MSP430ClockM$set_dco_calib(calib);
}

static inline  result_t MSP430ClockM$StdControl$init(void)
{

  MSP430ClockM$TA0CTL = 0x0004;
  MSP430ClockM$TA0IV = 0;
  MSP430ClockM$TBCTL = 0x0004;
  MSP430ClockM$TBIV = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      MSP430ClockM$busyCalibrateDCO();
      MSP430ClockM$MSP430ClockInit$initClocks();
      MSP430ClockM$MSP430ClockInit$initTimerA();
      MSP430ClockM$MSP430ClockInit$initTimerB();
    }
#line 215
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HPLInitM$MSP430ClockControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = MSP430ClockM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 72 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_FLASH_HOLD_PIN(void)
#line 72
{
#line 72
   static volatile uint8_t r __asm ("0x001D");

#line 72
  r &= ~(1 << 7);
}

#line 36
static inline void TOSH_MAKE_UCLK0_INPUT(void)
#line 36
{
#line 36
   static volatile uint8_t r __asm ("0x001A");

#line 36
  r &= ~(1 << 3);
}

#line 35
static inline void TOSH_MAKE_SIMO0_INPUT(void)
#line 35
{
#line 35
   static volatile uint8_t r __asm ("0x001A");

#line 35
  r &= ~(1 << 1);
}

#line 35
static inline void TOSH_SET_SIMO0_PIN(void)
#line 35
{
#line 35
   static volatile uint8_t r __asm ("0x0019");

#line 35
  r |= 1 << 1;
}

#line 71
static inline void TOSH_SET_FLASH_CS_PIN(void)
#line 71
{
#line 71
   static volatile uint8_t r __asm ("0x001D");

#line 71
  r |= 1 << 4;
}

#line 36
static inline void TOSH_CLR_UCLK0_PIN(void)
#line 36
{
#line 36
   static volatile uint8_t r __asm ("0x0019");

#line 36
  r &= ~(1 << 3);
}

#line 71
static inline void TOSH_CLR_FLASH_CS_PIN(void)
#line 71
{
#line 71
   static volatile uint8_t r __asm ("0x001D");

#line 71
  r &= ~(1 << 4);
}

# 161 "/opt/tinyos-1.x/tos/platform/msp430/msp430hardware.h"
static __inline void TOSH_wait(void )
{
   __asm volatile ("nop"); __asm volatile ("nop");}

# 72 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_FLASH_HOLD_PIN(void)
#line 72
{
#line 72
   static volatile uint8_t r __asm ("0x001D");

#line 72
  r |= 1 << 7;
}

#line 71
static inline void TOSH_MAKE_FLASH_CS_OUTPUT(void)
#line 71
{
#line 71
   static volatile uint8_t r __asm ("0x001E");

#line 71
  r |= 1 << 4;
}

#line 72
static inline void TOSH_MAKE_FLASH_HOLD_OUTPUT(void)
#line 72
{
#line 72
   static volatile uint8_t r __asm ("0x001E");

#line 72
  r |= 1 << 7;
}

#line 36
static inline void TOSH_MAKE_UCLK0_OUTPUT(void)
#line 36
{
#line 36
   static volatile uint8_t r __asm ("0x001A");

#line 36
  r |= 1 << 3;
}

#line 35
static inline void TOSH_MAKE_SIMO0_OUTPUT(void)
#line 35
{
#line 35
   static volatile uint8_t r __asm ("0x001A");

#line 35
  r |= 1 << 1;
}

#line 94
static inline void TOSH_FLASH_M25P_DP(void)
#line 94
{

  TOSH_MAKE_SIMO0_OUTPUT();
  TOSH_MAKE_UCLK0_OUTPUT();
  TOSH_MAKE_FLASH_HOLD_OUTPUT();
  TOSH_MAKE_FLASH_CS_OUTPUT();
  TOSH_SET_FLASH_HOLD_PIN();
  TOSH_SET_FLASH_CS_PIN();

  TOSH_wait();


  TOSH_CLR_FLASH_CS_PIN();
  TOSH_CLR_UCLK0_PIN();

  TOSH_FLASH_M25P_DP_bit(TRUE);
  TOSH_FLASH_M25P_DP_bit(FALSE);
  TOSH_FLASH_M25P_DP_bit(TRUE);
  TOSH_FLASH_M25P_DP_bit(TRUE);
  TOSH_FLASH_M25P_DP_bit(TRUE);
  TOSH_FLASH_M25P_DP_bit(FALSE);
  TOSH_FLASH_M25P_DP_bit(FALSE);
  TOSH_FLASH_M25P_DP_bit(TRUE);

  TOSH_SET_FLASH_CS_PIN();

  TOSH_SET_SIMO0_PIN();
  TOSH_MAKE_SIMO0_INPUT();
  TOSH_MAKE_UCLK0_INPUT();
  TOSH_CLR_FLASH_HOLD_PIN();
}

# 174 "/opt/tinyos-1.x/tos/platform/msp430/msp430hardware.h"
static __inline void TOSH_uwait(uint16_t u)
{
  uint16_t i;

#line 177
  if (u < 500) {
    for (i = 2; i < u; i++) {
         __asm volatile ("nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t");}
    }
  else {

    for (i = 0; i < u; i++) {
         __asm volatile ("nop\n\t"
        "nop\n\t"
        "nop\n\t"
        "nop\n\t");}
    }
}

# 129 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_PIN_DIRECTIONS(void )
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
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






      TOSH_uwait(1024 * 10);

      TOSH_FLASH_M25P_DP();
    }
#line 170
    __nesc_atomic_end(__nesc_atomic); }
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/HPLInitM.nc"
static inline  result_t HPLInitM$init(void)
{
  TOSH_SET_PIN_DIRECTIONS();
  HPLInitM$MSP430ClockControl$init();
  HPLInitM$MSP430ClockControl$start();
  return SUCCESS;
}

# 47 "/opt/tinyos-1.x/tos/platform/msp430/MainM.nc"
inline static  result_t MainM$hardwareInit(void){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLInitM$init();
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 35 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_SIMO0_PIN(void)
#line 35
{
#line 35
   static volatile uint8_t r __asm ("0x0019");

#line 35
  r &= ~(1 << 1);
}

#line 36
static inline void TOSH_SET_UCLK0_PIN(void)
#line 36
{
#line 36
   static volatile uint8_t r __asm ("0x0019");

#line 36
  r |= 1 << 3;
}

# 79 "/opt/tinyos-1.x/tos/system/sched.c"
static inline void TOSH_sched_init(void )
{
  int i;

#line 82
  TOSH_sched_free = 0;
  TOSH_sched_full = 0;
  for (i = 0; i < TOSH_MAX_TASKS; i++) 
    TOSH_queue[i].tp = NULL;
}

# 120 "/opt/tinyos-1.x/tos/system/tos.h"
static inline result_t rcombine(result_t r1, result_t r2)



{
  return r1 == FAIL ? FAIL : r2;
}

# 47 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  result_t NeighborMgmtM$StdControl$init(void)
#line 47
{
  NeighborMgmtM$initialize();
  return SUCCESS;
}

# 54 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static inline  result_t CascadesEngineM$StdControl$init(void)
#line 54
{
  initQueue(&CascadesEngineM$sendQueue, CAS_SEND_QUEUE_SIZE);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 56
    CascadesEngineM$sendTaskBusy = FALSE;
#line 56
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CascadesRouterM$SubControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CascadesEngineM$StdControl$init();
#line 63
  result = rcombine(result, NeighborMgmtM$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 374 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$StdControl$init(void)
#line 374
{
  CascadesRouterM$initialize();
  CascadesRouterM$SubControl$init();
  ;
  return SUCCESS;
}

# 114 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline void EventReportM$initialize(void)
#line 114
{
  int l;

#line 116
  EventReportM$seqno = 0;
  EventReportM$gfSendBusy = FALSE;
  EventReportM$taskBusy = FALSE;





  for (l = 0; l < 6; l++) 
    EventReportM$gLevelMode[l] = EVENT_LEVEL_URGENT;

  initQueue(&EventReportM$sendQueue, 3);
  initBufferPool(&EventReportM$buffQueue, 3, &EventReportM$eventBuffer[0]);
}

#line 145
static inline  result_t EventReportM$StdControl$init(void)
#line 145
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 146
    EventReportM$initialize();
#line 146
    __nesc_atomic_end(__nesc_atomic); }
  ;
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$EReportControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = EventReportM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 122 "build/telosb/RpcM.nc"
static inline  result_t RpcM$StdControl$init(void)
#line 122
{
  RpcM$sendMsgPtr = &RpcM$sendMsgBuf;
  RpcM$processingCommand = FALSE;


  RpcM$seqno = 0;

  RpcM$taskBusy = FALSE;

  ;
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$RPCControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = RpcM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 99 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  result_t SNMSM$StdControl$init(void)
#line 99
{

  SNMSM$RPCControl$init();
#line 116
  SNMSM$EReportControl$init();
  SNMSM$rstdelayCount = 0;
  SNMSM$toBeRestart = FALSE;
  return SUCCESS;
}

# 806 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$StdControl$init(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 808
    {
      TimeSyncM$skew = 0.0;
      TimeSyncM$localAverage = 0;
      TimeSyncM$offsetAverage = 0;
    }
#line 812
    __nesc_atomic_end(__nesc_atomic); }
#line 812
  ;

  TimeSyncM$clearTable();
  (
  (TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = 0xFFFF;
  TimeSyncM$rootid = 0xFFFF;
  ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = FALSE;










  TimeSyncM$processedMsg = &TimeSyncM$processedMsgBuffer;
  TimeSyncM$state = TimeSyncM$STATE_INIT;
  TimeSyncM$alreadySetTime = 0;
  TimeSyncM$errTimes = 0;
  TimeSyncM$hasGPSValid = 0;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 834
    TimeSyncM$missedSendStamps = TimeSyncM$missedReceiveStamps = 0;
#line 834
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 212 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$SplitControl$default$initDone(void)
#line 212
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$SplitControl$initDone(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = CC2420RadioM$SplitControl$default$initDone();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 208 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  result_t CC2420RadioM$CC2420SplitControl$initDone(void)
#line 208
{
  return CC2420RadioM$SplitControl$initDone();
}

# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420ControlM$SplitControl$initDone(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = CC2420RadioM$CC2420SplitControl$initDone();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 108 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  void CC2420ControlM$taskInitDone(void)
#line 108
{
  CC2420ControlM$SplitControl$initDone();
}

# 452 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   result_t HPLUSART0M$USARTControl$disableTxIntr(void)
#line 452
{
  HPLUSART0M$IE1 &= ~(1 << 7);
  return SUCCESS;
}

# 173 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLCC2420M$USARTControl$disableTxIntr(void){
#line 173
  unsigned char result;
#line 173

#line 173
  result = HPLUSART0M$USARTControl$disableTxIntr();
#line 173

#line 173
  return result;
#line 173
}
#line 173
# 447 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   result_t HPLUSART0M$USARTControl$disableRxIntr(void)
#line 447
{
  HPLUSART0M$IE1 &= ~(1 << 6);
  return SUCCESS;
}

# 172 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLCC2420M$USARTControl$disableRxIntr(void){
#line 172
  unsigned char result;
#line 172

#line 172
  result = HPLUSART0M$USARTControl$disableRxIntr();
#line 172

#line 172
  return result;
#line 172
}
#line 172
#line 135
inline static   void HPLCC2420M$USARTControl$setModeSPI(void){
#line 135
  HPLUSART0M$USARTControl$setModeSPI();
#line 135
}
#line 135
# 17 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_MAKE_RADIO_CSN_OUTPUT(void)
#line 17
{
#line 17
   static volatile uint8_t r __asm ("0x001E");

#line 17
  r |= 1 << 2;
}

#line 17
static inline void TOSH_SET_RADIO_CSN_PIN(void)
#line 17
{
#line 17
   static volatile uint8_t r __asm ("0x001D");

#line 17
  r |= 1 << 2;
}

# 83 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline  result_t HPLCC2420M$StdControl$init(void)
#line 83
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 84
    {
      HPLCC2420M$f.busy = HPLCC2420M$f.enabled = HPLCC2420M$f.rxbufBusy = HPLCC2420M$f.txbufBusy = FALSE;
    }
#line 86
    __nesc_atomic_end(__nesc_atomic); }

  TOSH_SET_RADIO_CSN_PIN();
  TOSH_MAKE_RADIO_CSN_OUTPUT();
  HPLCC2420M$USARTControl$setModeSPI();
  HPLCC2420M$USARTControl$disableRxIntr();
  HPLCC2420M$USARTControl$disableTxIntr();
  return SUCCESS;
}

# 54 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static inline  result_t BusArbitrationM$StdControl$init(void)
#line 54
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 55
    {
      BusArbitrationM$state = BusArbitrationM$BUS_OFF;
      BusArbitrationM$isBusReleasedPending = FALSE;
    }
#line 58
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = BusArbitrationM$StdControl$init();
#line 63
  result = rcombine(result, HPLCC2420M$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 129 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$SplitControl$init(void)
#line 129
{

  uint8_t _state = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 133
    {
      if (CC2420ControlM$state == CC2420ControlM$IDLE_STATE) {
          CC2420ControlM$state = CC2420ControlM$INIT_STATE;
          _state = TRUE;
        }
    }
#line 138
    __nesc_atomic_end(__nesc_atomic); }
  if (!_state) {
    return FAIL;
    }
  CC2420ControlM$HPLChipconControl$init();


  CC2420ControlM$gCurrentParameters[CP_MAIN] = 0xf800;
  CC2420ControlM$gCurrentParameters[CP_MDMCTRL0] = ((((0 << 11) | (
  2 << 8)) | (3 << 6)) | (
  1 << 5)) | (2 << 0);

  CC2420ControlM$gCurrentParameters[CP_MDMCTRL1] = 20 << 6;

  CC2420ControlM$gCurrentParameters[CP_RSSI] = 0xE080;
  CC2420ControlM$gCurrentParameters[CP_SYNCWORD] = 0xA70F;
  CC2420ControlM$gCurrentParameters[CP_TXCTRL] = ((((1 << 14) | (
  1 << 13)) | (3 << 6)) | (
  1 << 5)) | (CC2420_RFPOWER << 0);

  CC2420ControlM$gCurrentParameters[CP_RXCTRL0] = (((((1 << 12) | (
  2 << 8)) | (3 << 6)) | (
  2 << 4)) | (1 << 2)) | (
  1 << 0);

  CC2420ControlM$gCurrentParameters[CP_RXCTRL1] = (((((1 << 11) | (
  1 << 9)) | (1 << 6)) | (
  1 << 4)) | (1 << 2)) | (
  2 << 0);

  CC2420ControlM$gCurrentParameters[CP_FSCTRL] = (1 << 14) | ((
  357 + 5 * (CC2420_CHANNEL - 11)) << 0);

  CC2420ControlM$gCurrentParameters[CP_SECCTRL0] = (((1 << 8) | (
  1 << 7)) | (1 << 6)) | (
  1 << 2);

  CC2420ControlM$gCurrentParameters[CP_SECCTRL1] = 0;
  CC2420ControlM$gCurrentParameters[CP_BATTMON] = 0;



  CC2420ControlM$gCurrentParameters[CP_IOCFG0] = (127 << 0) | (
  1 << 9);

  CC2420ControlM$gCurrentParameters[CP_IOCFG1] = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 185
    CC2420ControlM$state = CC2420ControlM$INIT_STATE_DONE;
#line 185
    __nesc_atomic_end(__nesc_atomic); }
  TOS_post(CC2420ControlM$taskInitDone);
  return SUCCESS;
}

# 64 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$CC2420SplitControl$init(void){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420ControlM$SplitControl$init();
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 59 "/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
static inline   result_t RandomLFSR$Random$init(void)
#line 59
{
  {
  }
#line 60
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 61
    {
      RandomLFSR$shiftReg = 119 * 119 * (TOS_LOCAL_ADDRESS + 1);
      RandomLFSR$initSeed = RandomLFSR$shiftReg;
      RandomLFSR$mask = 137 * 29 * (TOS_LOCAL_ADDRESS + 1);
    }
#line 65
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 57 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   result_t CC2420RadioM$Random$init(void){
#line 57
  unsigned char result;
#line 57

#line 57
  result = RandomLFSR$Random$init();
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 423 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB4$disableEvents(void)
#line 423
{
#line 423
  MSP430TimerM$TBCCTL4 &= ~0x0010;
}

# 39 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerJiffyAsyncM$AlarmControl$disableEvents(void){
#line 39
  MSP430TimerM$ControlB4$disableEvents();
#line 39
}
#line 39
# 383 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB4$setControlAsCompare(void)
#line 383
{
#line 383
  MSP430TimerM$TBCCTL4 = MSP430TimerM$compareControl();
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerJiffyAsyncM$AlarmControl$setControlAsCompare(void){
#line 35
  MSP430TimerM$ControlB4$setControlAsCompare();
#line 35
}
#line 35
# 16 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static inline  result_t TimerJiffyAsyncM$StdControl$init(void)
{
  TimerJiffyAsyncM$AlarmControl$setControlAsCompare();
  TimerJiffyAsyncM$AlarmControl$disableEvents();
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420RadioM$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerJiffyAsyncM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 191 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  result_t CC2420RadioM$SplitControl$init(void)
#line 191
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 193
    {
      CC2420RadioM$stateRadio = CC2420RadioM$DISABLED_STATE;
      CC2420RadioM$currentDSN = 0;
      CC2420RadioM$bAckEnable = FALSE;
      CC2420RadioM$bPacketReceiving = FALSE;
      CC2420RadioM$rxbufptr = &CC2420RadioM$RxBuf;
      CC2420RadioM$rxbufptr->length = 0;
    }
#line 200
    __nesc_atomic_end(__nesc_atomic); }

  CC2420RadioM$TimerControl$init();
  CC2420RadioM$Random$init();
  CC2420RadioM$LocalAddr = TOS_LOCAL_ADDRESS;
  return CC2420RadioM$CC2420SplitControl$init();
}

#line 186
static inline  result_t CC2420RadioM$StdControl$init(void)
#line 186
{
  return CC2420RadioM$SplitControl$init();
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GenericCommProM$RadioControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420RadioM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 60 "/opt/tinyos-1.x/tos/system/UARTM.nc"
static inline  result_t UARTM$Control$init(void)
#line 60
{
  {
  }
#line 61
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 62
    {
      UARTM$state = FALSE;
    }
#line 64
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t FramerM$ByteControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = UARTM$Control$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 292 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  result_t FramerM$StdControl$init(void)
#line 292
{
  FramerM$HDLCInitialize();
  return FramerM$ByteControl$init();
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GenericCommProM$UARTControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = FramerM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
inline static  result_t GenericCommProM$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 175 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  bool GenericCommProM$Control$init(void)
#line 175
{
  bool ok = SUCCESS;
  bool status = SUCCESS;
  uint8_t ind;

  ;

  ok = GenericCommProM$TimerControl$init();
  status = status && ok;
  if (ok != SUCCESS) {
      ;
    }

  ok = GenericCommProM$UARTControl$init();
  status = status && ok;
  if (ok != SUCCESS) {
      ;
    }

  ok = GenericCommProM$RadioControl$init();
  status = status && ok;
  if (ok != SUCCESS) {
      ;
    }

  ok = initQueue(&GenericCommProM$sendQueue, COMM_SEND_QUEUE_SIZE);
  status = status && ok;
  if (ok != SUCCESS) {
      ;
    }
#line 218
  GenericCommProM$state = FALSE;
  GenericCommProM$sendTaskBusy = FALSE;
  GenericCommProM$recvTaskBusy = FALSE;
  GenericCommProM$swapMsgPtr = &GenericCommProM$swapBuf;

  GenericCommProM$lastCount = 0;
  GenericCommProM$counter = 0;
  GenericCommProM$radioRecvActive = FALSE;
  GenericCommProM$radioSendActive = FALSE;
  GenericCommProM$wdtTimerCnt = 0;

  GenericCommProM$toSend = TRUE;
  for (ind = 0; ind < COMM_SEND_QUEUE_SIZE; ind++) {
      GenericCommProM$bkHeader[ind].valid = FALSE;
      GenericCommProM$bkHeader[ind].length = 0;
      GenericCommProM$bkHeader[ind].type = 0;
      GenericCommProM$bkHeader[ind].group = 0;
      GenericCommProM$bkHeader[ind].msgPtr = 0;
      GenericCommProM$bkHeader[ind].addr = 0;
    }

  if (status == SUCCESS) {
      ;
    }
  else {
      ;
    }

  return status;
}

# 219 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$StdControl$init(void)
#line 219
{
  int n;

  MultiHopLQI$gRecentIndex = 0;
  for (n = 0; n < 10; n++) {
      MultiHopLQI$gRecentPacketSender[n] = TOS_BCAST_ADDR;
      MultiHopLQI$gRecentPacketSeqNo[n] = 0;
    }

  MultiHopLQI$gRecentOriginIndex = 0;
  for (n = 0; n < 10; n++) {
      MultiHopLQI$gRecentOriginPacketSender[n] = TOS_BCAST_ADDR;
      MultiHopLQI$gRecentOriginPacketSeqNo[n] = 0;
      MultiHopLQI$gRecentOriginPacketTTL[n] = 31;
    }

  MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
  MultiHopLQI$gbCurrentParentCost = 0x7fff;
  MultiHopLQI$gbCurrentLinkEst = 0x7fff;
  MultiHopLQI$gbLinkQuality = 0;
  MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
  MultiHopLQI$gbCurrentCost = 0xfffe;

  MultiHopLQI$gCurrentSeqNo = 0;
  MultiHopLQI$gUpdateInterval = MultiHopLQI$BEACON_PERIOD;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 244
    MultiHopLQI$msgBufBusy = FALSE;
#line 244
    __nesc_atomic_end(__nesc_atomic); }

  MultiHopLQI$localBeSink = FALSE;
  if (TOS_LOCAL_ADDRESS == MultiHopLQI$BASE_STATION_ADDRESS) {



      MultiHopLQI$gbCurrentParent = TOS_UART_ADDR;


      MultiHopLQI$gbCurrentParentCost = 0;
      MultiHopLQI$gbCurrentLinkEst = 0;
      MultiHopLQI$gbLinkQuality = 110;
      MultiHopLQI$gbCurrentHopCount = 0;
      MultiHopLQI$gbCurrentCost = 0;
      MultiHopLQI$localBeSink = TRUE;
    }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t MultiHopEngineM$SubControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = MultiHopLQI$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 82 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline void MultiHopEngineM$initialize(void)
#line 82
{
  uint8_t ind;

#line 84
  MultiHopEngineM$sendTaskBusy = FALSE;
  MultiHopEngineM$numberOfSendSuccesses = 0;
  MultiHopEngineM$numberOfSendFailures = 0;
  MultiHopEngineM$numOfSuccessiveFailures = 0;
  MultiHopEngineM$messageIsRetransmission = FALSE;
  MultiHopEngineM$useMhopPriority = 1;
  MultiHopEngineM$numOfPktProcessing = 0;
  MultiHopEngineM$beRadioActive = FALSE;
  MultiHopEngineM$beParentActive = FALSE;
  MultiHopEngineM$wdtTimerCnt = 0;
  MultiHopEngineM$localSendFail = 0;
  MultiHopEngineM$numLocalPendingPkt = 0;
  MultiHopEngineM$falseType = 0;
  for (ind = 0; ind < 5; ind++) {
      MultiHopEngineM$queueEntryInfo[ind].valid = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].AMID = 0;
      MultiHopEngineM$queueEntryInfo[ind].resend = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].length = 0;
      MultiHopEngineM$queueEntryInfo[ind].originalTOSPtr = NULL;
      MultiHopEngineM$queueEntryInfo[ind].msgPtr = NULL;
    }
}











static inline  result_t MultiHopEngineM$StdControl$init(void)
#line 117
{
  initQueue(&MultiHopEngineM$sendQueue, 5);
  initBufferPool(&MultiHopEngineM$buffQueue, 5, &MultiHopEngineM$poolBuffer[0]);
  MultiHopEngineM$initialize();
  return MultiHopEngineM$SubControl$init();
}

# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
inline static  result_t SmartSensingM$ADCControl$bindPort(uint8_t arg_0x40a94cf8, uint8_t arg_0x40a94e80){
#line 89
  unsigned char result;
#line 89

#line 89
  result = ADCM$ADCControl$bindPort(arg_0x40a94cf8, arg_0x40a94e80);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 28 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
inline static  void *SmartSensingM$DataMgmt$allocBlk(uint8_t arg_0x40ad2760){
#line 28
  void *result;
#line 28

#line 28
  result = DataMgmtM$DataMgmt$allocBlk(arg_0x40ad2760);
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 118 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline void SmartSensingM$initDefault(void)
#line 118
{
  SmartSensingM$initedClock = FALSE;








  SmartSensingM$defaultCode = 0;


  sensor_num = 0;
  SmartSensingM$sensingCurBlk = NULL;
#line 164
  if (NULL != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / SEISMIC_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_SEISMIC;
      sensor[sensor_num].channel = TOSH_ACTUAL_ADC_CHANNEL_A0_PORT;
      sensor[sensor_num].dataPriority = SEISMIC_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_ADC_CHANNEL_A0_PORT);
      ++sensor_num;
    }


  if (NULL != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / INFRASONIC_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_INFRASONIC;
      sensor[sensor_num].channel = TOSH_ACTUAL_ADC_CHANNEL_A4_PORT;
      sensor[sensor_num].dataPriority = INFRASONIC_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_ADC_CHANNEL_A4_PORT);
      ++sensor_num;
    }
#line 216
  SmartSensingM$updateMaxBlkNum();
  SmartSensingM$timerInterval = SmartSensingM$calFireInterval();
}

# 424 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB5$disableEvents(void)
#line 424
{
#line 424
  MSP430TimerM$TBCCTL5 &= ~0x0010;
}

# 39 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void RealTimeM$MSP430TimerControl$disableEvents(void){
#line 39
  MSP430TimerM$ControlB5$disableEvents();
#line 39
}
#line 39
# 384 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB5$setControlAsCompare(void)
#line 384
{
#line 384
  MSP430TimerM$TBCCTL5 = MSP430TimerM$compareControl();
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void RealTimeM$MSP430TimerControl$setControlAsCompare(void){
#line 35
  MSP430TimerM$ControlB5$setControlAsCompare();
#line 35
}
#line 35
# 86 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$StdControl$init(void)
#line 86
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 87
    {
      RealTimeM$localTime = 0;
      RealTimeM$mState = 0;
      RealTimeM$queue_head = RealTimeM$queue_tail = -1;
      RealTimeM$queue_size = 0;
      RealTimeM$numClients = 0;
      RealTimeM$uc_fire_interval = UC_FIRE_INTERVAL;
      RealTimeM$uc_fire_point = RealTimeM$uc_fire_interval;
      RealTimeM$taskBusy = FALSE;
      RealTimeM$syncMode = DEFAULT_SYNC_MODE;
      RealTimeM$is_synced = FALSE;
      RealTimeM$timerBusy = FALSE;
      RealTimeM$timerCount = 0;
      RealTimeM$globaltime_t = 0;
    }
#line 101
    __nesc_atomic_end(__nesc_atomic); }
  RealTimeM$MSP430TimerControl$setControlAsCompare();
  RealTimeM$MSP430TimerControl$disableEvents();

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SmartSensingM$TimerControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = RealTimeM$StdControl$init();
#line 63
  result = rcombine(result, TimerM$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 95 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setIEFlags(uint16_t mask)
#line 95
{
#line 95
  HPLADC12M$ADC12IE = mask;
}

# 55 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$setIEFlags(uint16_t arg_0x413f94c0){
#line 55
  HPLADC12M$HPLADC12$setIEFlags(arg_0x413f94c0);
#line 55
}
#line 55
# 115 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$disableConversion(void)
#line 115
{
#line 115
  HPLADC12M$ADC12CTL0 &= ~0x0002;
}

# 80 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$disableConversion(void){
#line 80
  HPLADC12M$HPLADC12$disableConversion();
#line 80
}
#line 80
# 67 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline  result_t MSP430ADC12M$StdControl$init(void)
{
  MSP430ADC12M$cmode = ADC_IDLE;
  MSP430ADC12M$reserved = ADC_IDLE;
  MSP430ADC12M$vrefWait = FALSE;
  MSP430ADC12M$HPLADC12$disableConversion();
  MSP430ADC12M$HPLADC12$setIEFlags(0x0000);
  return SUCCESS;
}

# 81 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static inline  result_t ADCM$StdControl$init(void)
{
  ADCM$ADCControl$init();
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t DataMgmtM$SubControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 123 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline void DataMgmtM$initialize(void)
#line 123
{
  DataMgmtM$sendTaskBusy = FALSE;
  DataMgmtM$processTaskBusy = FALSE;
  DataMgmtM$presendTaskBusy = FALSE;
  DataMgmtM$sysCheckCount = 0;
  DataMgmtM$seqno = 0;
  DataMgmtM$sendDoneFailCheckCount = 0;
  DataMgmtM$sendQueueLen = 0;
  DataMgmtM$Msg_length = 0;
  DataMgmtM$sendDoneR_num = 0;
  DataMgmtM$send_num = 0;
  DataMgmtM$processloopCount = 0;
  DataMgmtM$GlobaltaskCode = 0;
  DataMgmtM$headSendQueue = NULL;
  DataMgmtM$presendTaskCount = 0;
  DataMgmtM$processTaskCount = 0;
  DataMgmtM$trynextSendCount = 0;
  DataMgmtM$allocbuffercount = 0;
  DataMgmtM$f_allocbuffercount = 0;
  DataMgmtM$freebuffercount = 0;
  DataMgmtM$nothingtosend = 0;
  DataMgmtM$batchTimerCount = 0;
}

# 90 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
static inline result_t initSenorMem(MemQueue_t *queue, uint16_t size)
#line 90
{
  int16_t i;

#line 92
  if (size > MEM_QUEUE_SIZE || size <= 0) {
      ;
      return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 96
    {
      queue->size = size;
      queue->total = 0;
      queue->head[FREEMEM] = 0;
      queue->tail[FREEMEM] = size - 1;
      for (i = 1; i < NUM_STATUS; i++) {
          queue->head[i] = queue->tail[i] = -1;
        }

      for (i = 0; i < size; i++) {
          queue->element[i].time = 0;
          queue->element[i].interval = 0;
          queue->element[i].next = i + 1;
          queue->element[i].prev = i - 1;
          queue->element[i].size = 0;
          queue->element[i].priority = 0;
          queue->element[i].status = FREEMEM;
        }
      queue->element[i].next = -1;
    }
#line 115
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 158 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$StdControl$init(void)
#line 158
{
  initBufferPool(&DataMgmtM$buffQueue, MAX_SENSING_QUEUE_SIZE, DataMgmtM$buffMsg);
  initQueue(&DataMgmtM$sendQueue, MAX_SENSING_QUEUE_SIZE);
  initSenorMem(&DataMgmtM$sensorMem, MEM_QUEUE_SIZE);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 162
    DataMgmtM$initialize();
#line 162
    __nesc_atomic_end(__nesc_atomic); }
  DataMgmtM$SubControl$init();
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SmartSensingM$SubControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = DataMgmtM$StdControl$init();
#line 63
  result = rcombine(result, ADCM$StdControl$init());
#line 63
  result = rcombine(result, MSP430ADC12M$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 50 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
inline static  result_t SmartSensingM$ADCControl$init(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = ADCM$ADCControl$init();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 312 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$StdControl$init(void)
#line 312
{
  SmartSensingM$ADCControl$init();
  SmartSensingM$SubControl$init();
  SmartSensingM$TimerControl$init();




  SmartSensingM$initDefault();

  ;
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t MainM$StdControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = TimerM$StdControl$init();
#line 63
  result = rcombine(result, SmartSensingM$StdControl$init());
#line 63
  result = rcombine(result, MultiHopEngineM$StdControl$init());
#line 63
  result = rcombine(result, GenericCommProM$Control$init());
#line 63
  result = rcombine(result, TimeSyncM$StdControl$init());
#line 63
  result = rcombine(result, SNMSM$StdControl$init());
#line 63
  result = rcombine(result, CascadesRouterM$StdControl$init());
#line 63
  result = rcombine(result, NeighborMgmtM$StdControl$init());
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 382 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB3$setControlAsCompare(void)
#line 382
{
#line 382
  MSP430TimerM$TBCCTL3 = MSP430TimerM$compareControl();
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerM$AlarmControl$setControlAsCompare(void){
#line 35
  MSP430TimerM$ControlB3$setControlAsCompare();
#line 35
}
#line 35
# 422 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB3$disableEvents(void)
#line 422
{
#line 422
  MSP430TimerM$TBCCTL3 &= ~0x0010;
}

# 39 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerM$AlarmControl$disableEvents(void){
#line 39
  MSP430TimerM$ControlB3$disableEvents();
#line 39
}
#line 39
# 263 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t type)
#line 263
{
  result_t result = FAIL;
  SenBlkPtr p = headMemElement(&DataMgmtM$sensorMem, MEMPENDING);
  int16_t nextInd = -1;

#line 267
  while (p != NULL) {
      if (p->type == type) {
          result = DataMgmtM$DataMgmt$freeBlk((void *)p);

          break;
        }
      else {
          nextInd = p->next;
          p = getMemElementByIndex(&DataMgmtM$sensorMem, nextInd);
        }
    }



  if (result != TRUE) {
      p = headMemElement(&DataMgmtM$sensorMem, MEMPROCESSING);
      while (p != NULL) {
          if (p->type == type) {
              result = DataMgmtM$DataMgmt$freeBlk((void *)p);

              break;
            }
          else {
              nextInd = p->next;
              p = getMemElementByIndex(&DataMgmtM$sensorMem, nextInd);
            }
        }
    }
  return result;
}

# 194 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
static inline result_t freeSensorMem(MemQueue_t *queue, SenBlkPtr obj)
#line 194
{
  int16_t ind;

#line 196
  if (queue->size <= 0) {
      ;
      return FAIL;
    }

  if (queue->total <= 0) {
      ;
      return FAIL;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 206
    ind = queue->head[obj->status];
#line 206
    __nesc_atomic_end(__nesc_atomic); }
  while (ind != -1) {
      if (queue->element[ind].status != FREEMEM && &queue->element[ind] == obj) {
          _private_changeMemStatusByIndex(queue, ind, queue->element[ind].status, FREEMEM);
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 210
            {
              queue->element[ind].time = 0;
              queue->element[ind].interval = 0;
              queue->element[ind].size = 0;
              queue->element[ind].priority = 0;
              queue->total = queue->total - 1;
            }
#line 216
            __nesc_atomic_end(__nesc_atomic); }
          return SUCCESS;
        }
      else {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 220
            ind = queue->element[ind].next;
#line 220
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return FAIL;
}

#line 161
static inline SenBlkPtr allocSensorMem(MemQueue_t *bufQueue)
#line 161
{
  int16_t head;

#line 163
  if (bufQueue->size <= 0) {
      ;
      return NULL;
    }
  if (bufQueue->total >= bufQueue->size) {
      ;
      return NULL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 171
    head = bufQueue->head[FREEMEM];
#line 171
    __nesc_atomic_end(__nesc_atomic); }
  if (-1 != head) {
      if (FAIL == _private_changeMemStatusByIndex(bufQueue, head, FREEMEM, FILLING)) {
          ;
          return NULL;
        }
      else {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 178
            bufQueue->total++;
#line 178
            __nesc_atomic_end(__nesc_atomic); }
          return &bufQueue->element[head];
        }
    }
  else 
#line 181
    {
      ;
      return NULL;
    }
}

# 87 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$yellowToggle(void)
#line 87
{
  return SUCCESS;
}

# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t DataMgmtM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = NoLeds$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
# 814 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static __inline uint16_t SmartSensingM$GCD(uint16_t a, uint16_t b)
#line 814
{
  while (1) {
      a = a % b;
      if (a == 0) {
          return b;
        }
      b = b % a;
      if (b == 0) {
          return a;
        }
    }
}

# 114 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   bool HPLUSART0M$USARTControl$isI2C(void)
#line 114
{
  bool _ret = FALSE;






  return _ret;
}

#line 72
static inline   bool HPLUSART0M$USARTControl$isSPI(void)
#line 72
{
  bool _ret = FALSE;

#line 74
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 74
    {
      if (HPLUSART0M$ME1 & (1 << 6)) {
        _ret = TRUE;
        }
    }
#line 78
    __nesc_atomic_end(__nesc_atomic); }
#line 78
  return _ret;
}

# 38 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline bool TOSH_IS_URXD0_IOFUNC(void)
#line 38
{
#line 38
   static volatile uint8_t r __asm ("0x001B");

#line 38
  return r | ~(1 << 5);
}

#line 37
static inline bool TOSH_IS_UTXD0_MODFUNC(void)
#line 37
{
#line 37
   static volatile uint8_t r __asm ("0x001B");

#line 37
  return r & (1 << 4);
}

# 92 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   bool HPLUSART0M$USARTControl$isUARTtx(void)
#line 92
{
  bool _ret = FALSE;

#line 94
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 94
    {

      if (
#line 95
      HPLUSART0M$ME1 & (1 << 7) && 
      TOSH_IS_UTXD0_MODFUNC() && 
      TOSH_IS_URXD0_IOFUNC()) {
        _ret = TRUE;
        }
    }
#line 100
    __nesc_atomic_end(__nesc_atomic); }
#line 100
  return _ret;
}

# 37 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline bool TOSH_IS_UTXD0_IOFUNC(void)
#line 37
{
#line 37
   static volatile uint8_t r __asm ("0x001B");

#line 37
  return r | ~(1 << 4);
}

#line 38
static inline bool TOSH_IS_URXD0_MODFUNC(void)
#line 38
{
#line 38
   static volatile uint8_t r __asm ("0x001B");

#line 38
  return r & (1 << 5);
}

# 103 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   bool HPLUSART0M$USARTControl$isUARTrx(void)
#line 103
{
  bool _ret = FALSE;

#line 105
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 105
    {

      if (
#line 106
      HPLUSART0M$ME1 & (1 << 6) && 
      TOSH_IS_URXD0_MODFUNC() && 
      TOSH_IS_UTXD0_IOFUNC()) {
        _ret = TRUE;
        }
    }
#line 111
    __nesc_atomic_end(__nesc_atomic); }
#line 111
  return _ret;
}

#line 81
static inline   bool HPLUSART0M$USARTControl$isUART(void)
#line 81
{
  bool _ret = FALSE;

#line 83
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {

      if (
#line 84
      HPLUSART0M$ME1 & (1 << 7) && HPLUSART0M$ME1 & (1 << 6) && 
      TOSH_IS_URXD0_MODFUNC() && 
      TOSH_IS_UTXD0_MODFUNC()) {
        _ret = TRUE;
        }
    }
#line 89
    __nesc_atomic_end(__nesc_atomic); }
#line 89
  return _ret;
}

#line 125
static inline   msp430_usartmode_t HPLUSART0M$USARTControl$getMode(void)
#line 125
{
  if (HPLUSART0M$USARTControl$isUART()) {
    return USART_UART;
    }
  else {
#line 128
    if (HPLUSART0M$USARTControl$isUARTrx()) {
      return USART_UART_RX;
      }
    else {
#line 130
      if (HPLUSART0M$USARTControl$isUARTtx()) {
        return USART_UART_TX;
        }
      else {
#line 132
        if (HPLUSART0M$USARTControl$isSPI()) {
          return USART_SPI;
          }
        else {
#line 134
          if (HPLUSART0M$USARTControl$isI2C()) {
            return USART_I2C;
            }
          else {
#line 137
            return USART_NONE;
            }
          }
        }
      }
    }
}

# 38 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_URXD0_IOFUNC(void)
#line 38
{
#line 38
   static volatile uint8_t r __asm ("0x001B");

#line 38
  r &= ~(1 << 5);
}

#line 37
static inline void TOSH_SEL_UTXD0_IOFUNC(void)
#line 37
{
#line 37
   static volatile uint8_t r __asm ("0x001B");

#line 37
  r &= ~(1 << 4);
}

# 172 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   void HPLUSART0M$USARTControl$disableUART(void)
#line 172
{
  HPLUSART0M$ME1 &= ~((1 << 7) | (1 << 6));
  TOSH_SEL_UTXD0_IOFUNC();
  TOSH_SEL_URXD0_IOFUNC();
}

#line 218
static inline   void HPLUSART0M$USARTControl$disableI2C(void)
#line 218
{
}

# 35 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_SIMO0_MODFUNC(void)
#line 35
{
#line 35
   static volatile uint8_t r __asm ("0x001B");

#line 35
  r |= 1 << 1;
}

#line 34
static inline void TOSH_SEL_SOMI0_MODFUNC(void)
#line 34
{
#line 34
   static volatile uint8_t r __asm ("0x001B");

#line 34
  r |= 1 << 2;
}

#line 36
static inline void TOSH_SEL_UCLK0_MODFUNC(void)
#line 36
{
#line 36
   static volatile uint8_t r __asm ("0x001B");

#line 36
  r |= 1 << 3;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t NeighborMgmtM$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(11U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t NeighborMgmtM$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 52 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  result_t NeighborMgmtM$StdControl$start(void)
#line 52
{
  uint16_t randomTime = NeighborMgmtM$Random$rand();

  return NeighborMgmtM$Timer$start(TIMER_ONE_SHOT, (randomTime & 0xfff) + 1024);
}

# 381 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$StdControl$start(void)
#line 381
{
  return SUCCESS;
}

# 151 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline  result_t EventReportM$StdControl$start(void)
#line 151
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$EReportControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = EventReportM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 135 "build/telosb/RpcM.nc"
static inline  result_t RpcM$StdControl$start(void)
#line 135
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$RPCControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = RpcM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 122 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  result_t SNMSM$StdControl$start(void)
#line 122
{

  SNMSM$RPCControl$start();
#line 141
  SNMSM$EReportControl$start();

  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t TimeSyncM$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(0U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 839 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$StdControl$start(void)
#line 839
{
  TimeSyncM$mode = TS_TIMER_MODE;
  TimeSyncM$heartBeats = 0;
  ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->nodeID = TOS_LOCAL_ADDRESS;
  TimeSyncM$Timer$start(TIMER_REPEAT, (uint32_t )1000 * TimeSyncM$BEACON_RATE);

  return SUCCESS;
}

# 54 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0x40da59c0, uint16_t arg_0x40da5b50){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HPLCC2420M$HPLCC2420$write(arg_0x40da59c0, arg_0x40da5b50);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 412 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$enableAutoAck(void)
#line 412
{
  CC2420ControlM$gCurrentParameters[CP_MDMCTRL0] |= 1 << 4;
  return CC2420ControlM$HPLChipcon$write(0x11, CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]);
}

# 192 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static   result_t CC2420RadioM$CC2420Control$enableAutoAck(void){
#line 192
  unsigned char result;
#line 192

#line 192
  result = CC2420ControlM$CC2420Control$enableAutoAck();
#line 192

#line 192
  return result;
#line 192
}
#line 192
# 422 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$enableAddrDecode(void)
#line 422
{
  CC2420ControlM$gCurrentParameters[CP_MDMCTRL0] |= 1 << 11;
  return CC2420ControlM$HPLChipcon$write(0x11, CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]);
}

# 206 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static   result_t CC2420RadioM$CC2420Control$enableAddrDecode(void){
#line 206
  unsigned char result;
#line 206

#line 206
  result = CC2420ControlM$CC2420Control$enableAddrDecode();
#line 206

#line 206
  return result;
#line 206
}
#line 206
# 727 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   void CC2420RadioM$MacControl$enableAck(void)
#line 727
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 728
    CC2420RadioM$bAckEnable = TRUE;
#line 728
    __nesc_atomic_end(__nesc_atomic); }
  CC2420RadioM$CC2420Control$enableAddrDecode();
  CC2420RadioM$CC2420Control$enableAutoAck();
}

# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacControl.nc"
inline static   void GenericCommProM$MacControl$enableAck(void){
#line 74
  CC2420RadioM$MacControl$enableAck();
#line 74
}
#line 74
# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLPowerManagementM.nc"
static inline   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void)
#line 53
{
  return SUCCESS;
}

# 41 "/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
inline static   uint8_t GenericCommProM$PowerManagement$adjustPower(void){
#line 41
  unsigned char result;
#line 41

#line 41
  result = HPLPowerManagementM$PowerManagement$adjustPower();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t GenericCommProM$ActivityTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(1U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0x40da54b0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0x40da54b0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 119 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port14$enable(void)
#line 119
{
#line 119
  MSP430InterruptM$P1IE |= 1 << 4;
}

# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$CCAInterrupt$enable(void){
#line 30
  MSP430InterruptM$Port14$enable();
#line 30
}
#line 30
# 246 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port14$edge(bool l2h)
#line 246
{
  /* atomic removed: atomic calls only */
#line 247
  {
    if (l2h) {
#line 248
      P1IES &= ~(1 << 4);
      }
    else {
#line 249
      P1IES |= 1 << 4;
      }
  }
}

# 54 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$CCAInterrupt$edge(bool arg_0x40f36350){
#line 54
  MSP430InterruptM$Port14$edge(arg_0x40f36350);
#line 54
}
#line 54
# 181 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port14$clear(void)
#line 181
{
#line 181
  MSP430InterruptM$P1IFG &= ~(1 << 4);
}

# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$CCAInterrupt$clear(void){
#line 40
  MSP430InterruptM$Port14$clear();
#line 40
}
#line 40
# 150 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port14$disable(void)
#line 150
{
#line 150
  MSP430InterruptM$P1IE &= ~(1 << 4);
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$CCAInterrupt$disable(void){
#line 35
  MSP430InterruptM$Port14$disable();
#line 35
}
#line 35
# 147 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline   result_t HPLCC2420InterruptM$CCA$startWait(bool low_to_high)
#line 147
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 148
    {
      HPLCC2420InterruptM$CCAInterrupt$disable();
      HPLCC2420InterruptM$CCAInterrupt$clear();
      HPLCC2420InterruptM$CCAInterrupt$edge(low_to_high);
      HPLCC2420InterruptM$CCAInterrupt$enable();
    }
#line 153
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420ControlM$CCA$startWait(bool arg_0x40dc68a0){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$CCA$startWait(arg_0x40dc68a0);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 368 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$OscillatorOn(void)
#line 368
{
  uint16_t i;
  uint8_t status;

  i = 0;
#line 384
  CC2420ControlM$HPLChipcon$write(0x1D, 24);


  CC2420ControlM$CCA$startWait(TRUE);


  status = CC2420ControlM$HPLChipcon$cmd(0x01);

  return SUCCESS;
}

# 31 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_CC_RSTN_PIN(void)
#line 31
{
#line 31
   static volatile uint8_t r __asm ("0x001D");

#line 31
  r |= 1 << 6;
}

#line 31
static inline void TOSH_CLR_CC_RSTN_PIN(void)
#line 31
{
#line 31
   static volatile uint8_t r __asm ("0x001D");

#line 31
  r &= ~(1 << 6);
}

#line 30
static inline void TOSH_SET_CC_VREN_PIN(void)
#line 30
{
#line 30
   static volatile uint8_t r __asm ("0x001D");

#line 30
  r |= 1 << 5;
}

# 400 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$VREFOn(void)
#line 400
{
  TOSH_SET_CC_VREN_PIN();

  TOSH_uwait(600);
  return SUCCESS;
}

# 96 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline  result_t HPLCC2420M$StdControl$start(void)
#line 96
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 97
    {
      if (! HPLCC2420M$f.busy) {
          TOSH_SET_RADIO_CSN_PIN();
          TOSH_MAKE_RADIO_CSN_OUTPUT();
          HPLCC2420M$USARTControl$setModeSPI();
          HPLCC2420M$USARTControl$disableRxIntr();
          HPLCC2420M$USARTControl$disableTxIntr();
          HPLCC2420M$f.busy = HPLCC2420M$f.rxbufBusy = HPLCC2420M$f.txbufBusy = FALSE;
          HPLCC2420M$f.enabled = TRUE;
        }
    }
#line 107
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 62 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static inline  result_t BusArbitrationM$StdControl$start(void)
#line 62
{
  uint8_t _state;

#line 64
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 64
    {
      if (BusArbitrationM$state == BusArbitrationM$BUS_OFF) {
          BusArbitrationM$state = BusArbitrationM$BUS_IDLE;
          BusArbitrationM$isBusReleasedPending = FALSE;
        }
      _state = BusArbitrationM$state;
    }
#line 70
    __nesc_atomic_end(__nesc_atomic); }

  if (_state == BusArbitrationM$BUS_IDLE) {
    return SUCCESS;
    }
  return FAIL;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = BusArbitrationM$StdControl$start();
#line 70
  result = rcombine(result, HPLCC2420M$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 227 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$SplitControl$start(void)
#line 227
{
  result_t status;
  uint8_t _state = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 231
    {
      if (CC2420ControlM$state == CC2420ControlM$INIT_STATE_DONE) {
          CC2420ControlM$state = CC2420ControlM$START_STATE;
          _state = TRUE;
        }
    }
#line 236
    __nesc_atomic_end(__nesc_atomic); }
  if (!_state) {
    return FAIL;
    }
  CC2420ControlM$HPLChipconControl$start();

  CC2420ControlM$CC2420Control$VREFOn();

  TOSH_CLR_CC_RSTN_PIN();
  TOSH_wait();
  TOSH_SET_CC_RSTN_PIN();
  TOSH_wait();


  status = CC2420ControlM$CC2420Control$OscillatorOn();

  return status;
}

# 77 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$CC2420SplitControl$start(void){
#line 77
  unsigned char result;
#line 77

#line 77
  result = CC2420ControlM$SplitControl$start();
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 23 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static inline  result_t TimerJiffyAsyncM$StdControl$start(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 25
    {
      TimerJiffyAsyncM$bSet = FALSE;
      TimerJiffyAsyncM$AlarmControl$disableEvents();
    }
#line 28
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420RadioM$TimerControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerJiffyAsyncM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 277 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  result_t CC2420RadioM$SplitControl$start(void)
#line 277
{
  uint8_t chkstateRadio;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 280
    chkstateRadio = CC2420RadioM$stateRadio;
#line 280
    __nesc_atomic_end(__nesc_atomic); }

  if (chkstateRadio == CC2420RadioM$DISABLED_STATE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 283
        {
          CC2420RadioM$stateRadio = CC2420RadioM$WARMUP_STATE;
          CC2420RadioM$countRetry = 0;
          CC2420RadioM$rxbufptr->length = 0;
        }
#line 287
        __nesc_atomic_end(__nesc_atomic); }
      CC2420RadioM$TimerControl$start();
      return CC2420RadioM$CC2420SplitControl$start();
    }
  return FAIL;
}

#line 239
static inline  void CC2420RadioM$startRadio(void)
#line 239
{
  result_t success = FAIL;

#line 241
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 241
    {
      if (CC2420RadioM$stateRadio == CC2420RadioM$DISABLED_STATE_STARTTASK) {
          CC2420RadioM$stateRadio = CC2420RadioM$DISABLED_STATE;
          success = SUCCESS;
        }
    }
#line 246
    __nesc_atomic_end(__nesc_atomic); }

  if (success == SUCCESS) {
    CC2420RadioM$SplitControl$start();
    }
}

static inline  result_t CC2420RadioM$StdControl$start(void)
#line 253
{







  result_t success = FAIL;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 263
    {
      if (CC2420RadioM$stateRadio == CC2420RadioM$DISABLED_STATE) {

          if (TOS_post(CC2420RadioM$startRadio)) {
              success = SUCCESS;
              CC2420RadioM$stateRadio = CC2420RadioM$DISABLED_STATE_STARTTASK;
            }
        }
    }
#line 271
    __nesc_atomic_end(__nesc_atomic); }

  return success;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GenericCommProM$RadioControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = CC2420RadioM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 400 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   result_t HPLUSART1M$USARTControl$enableTxIntr(void)
#line 400
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 401
    {
      HPLUSART1M$IFG2 &= ~(1 << 5);
      IE2 |= 1 << 5;
    }
#line 404
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 175 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLUARTM$USARTControl$enableTxIntr(void){
#line 175
  unsigned char result;
#line 175

#line 175
  result = HPLUSART1M$USARTControl$enableTxIntr();
#line 175

#line 175
  return result;
#line 175
}
#line 175
# 392 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   result_t HPLUSART1M$USARTControl$enableRxIntr(void)
#line 392
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 393
    {
      HPLUSART1M$IFG2 &= ~(1 << 4);
      IE2 |= 1 << 4;
    }
#line 396
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 174 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLUARTM$USARTControl$enableRxIntr(void){
#line 174
  unsigned char result;
#line 174

#line 174
  result = HPLUSART1M$USARTControl$enableRxIntr();
#line 174

#line 174
  return result;
#line 174
}
#line 174
# 349 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   void HPLUSART1M$USARTControl$setClockRate(uint16_t baudrate, uint8_t mctl)
#line 349
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 350
    {
      HPLUSART1M$l_br = baudrate;
      HPLUSART1M$l_mctl = mctl;
      U1BR0 = baudrate & 0x0FF;
      U1BR1 = (baudrate >> 8) & 0x0FF;
      U1MCTL = mctl;
    }
#line 356
    __nesc_atomic_end(__nesc_atomic); }
}

# 169 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   void HPLUARTM$USARTControl$setClockRate(uint16_t arg_0x40e98918, uint8_t arg_0x40e98aa0){
#line 169
  HPLUSART1M$USARTControl$setClockRate(arg_0x40e98918, arg_0x40e98aa0);
#line 169
}
#line 169
# 341 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   void HPLUSART1M$USARTControl$setClockSource(uint8_t source)
#line 341
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 342
    {
      HPLUSART1M$l_ssel = source | 0x80;
      HPLUSART1M$U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
      HPLUSART1M$U1TCTL |= HPLUSART1M$l_ssel & 0x7F;
    }
#line 346
    __nesc_atomic_end(__nesc_atomic); }
}

# 167 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   void HPLUARTM$USARTControl$setClockSource(uint8_t arg_0x40e98460){
#line 167
  HPLUSART1M$USARTControl$setClockSource(arg_0x40e98460);
#line 167
}
#line 167
# 252 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline void HPLUSART1M$setUARTModeCommon(void)
#line 252
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 253
    {
      U1CTL = 0x01;
      U1CTL |= 0x10;

      U1RCTL &= ~0x08;

      U1CTL = 0x01;
      U1CTL |= 0x10;

      if (HPLUSART1M$l_ssel & 0x80) {
          HPLUSART1M$U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
          HPLUSART1M$U1TCTL |= HPLUSART1M$l_ssel & 0x7F;
        }
      else {
          HPLUSART1M$U1TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
          HPLUSART1M$U1TCTL |= 0x10;
        }

      if (HPLUSART1M$l_mctl != 0 || HPLUSART1M$l_br != 0) {
          U1BR0 = HPLUSART1M$l_br & 0x0FF;
          U1BR1 = (HPLUSART1M$l_br >> 8) & 0x0FF;
          U1MCTL = HPLUSART1M$l_mctl;
        }
      else {
          U1BR0 = 0x03;
          U1BR1 = 0x00;
          U1MCTL = 0x4A;
        }

      HPLUSART1M$ME2 &= ~(1 << 4);
      HPLUSART1M$ME2 |= (1 << 5) | (1 << 4);

      U1CTL &= ~0x01;

      HPLUSART1M$IFG2 &= ~((1 << 5) | (1 << 4));
      IE2 &= ~((1 << 5) | (1 << 4));
    }
#line 289
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 40 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_URXD1_MODFUNC(void)
#line 40
{
#line 40
   static volatile uint8_t r __asm ("0x001B");

#line 40
  r |= 1 << 7;
}

#line 39
static inline void TOSH_SEL_UTXD1_MODFUNC(void)
#line 39
{
#line 39
   static volatile uint8_t r __asm ("0x001B");

#line 39
  r |= 1 << 6;
}

#line 40
static inline void TOSH_SEL_URXD1_IOFUNC(void)
#line 40
{
#line 40
   static volatile uint8_t r __asm ("0x001B");

#line 40
  r &= ~(1 << 7);
}

#line 39
static inline void TOSH_SEL_UTXD1_IOFUNC(void)
#line 39
{
#line 39
   static volatile uint8_t r __asm ("0x001B");

#line 39
  r &= ~(1 << 6);
}

# 158 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   void HPLUSART1M$USARTControl$disableUART(void)
#line 158
{
  HPLUSART1M$ME2 &= ~((1 << 5) | (1 << 4));
  TOSH_SEL_UTXD1_IOFUNC();
  TOSH_SEL_URXD1_IOFUNC();
}

# 41 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_UCLK1_IOFUNC(void)
#line 41
{
#line 41
   static volatile uint8_t r __asm ("0x0033");

#line 41
  r &= ~(1 << 3);
}

#line 42
static inline void TOSH_SEL_SOMI1_IOFUNC(void)
#line 42
{
#line 42
   static volatile uint8_t r __asm ("0x0033");

#line 42
  r &= ~(1 << 2);
}

#line 43
static inline void TOSH_SEL_SIMO1_IOFUNC(void)
#line 43
{
#line 43
   static volatile uint8_t r __asm ("0x0033");

#line 43
  r &= ~(1 << 1);
}

# 191 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   void HPLUSART1M$USARTControl$disableSPI(void)
#line 191
{
  HPLUSART1M$ME2 &= ~(1 << 4);
  TOSH_SEL_SIMO1_IOFUNC();
  TOSH_SEL_SOMI1_IOFUNC();
  TOSH_SEL_UCLK1_IOFUNC();
}

#line 107
static inline   bool HPLUSART1M$USARTControl$isI2C(void)
#line 107
{
  return FALSE;
}

#line 64
static inline   bool HPLUSART1M$USARTControl$isSPI(void)
#line 64
{
  bool _ret = FALSE;

#line 66
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 66
    {
      if (HPLUSART1M$ME2 & (1 << 4)) {
        _ret = TRUE;
        }
    }
#line 70
    __nesc_atomic_end(__nesc_atomic); }
#line 70
  return _ret;
}

# 40 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline bool TOSH_IS_URXD1_IOFUNC(void)
#line 40
{
#line 40
   static volatile uint8_t r __asm ("0x001B");

#line 40
  return r | ~(1 << 7);
}

#line 39
static inline bool TOSH_IS_UTXD1_MODFUNC(void)
#line 39
{
#line 39
   static volatile uint8_t r __asm ("0x001B");

#line 39
  return r & (1 << 6);
}

# 84 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   bool HPLUSART1M$USARTControl$isUARTtx(void)
#line 84
{
  bool _ret = FALSE;

#line 86
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 86
    {

      if (
#line 87
      HPLUSART1M$ME2 & (1 << 5) && 
      TOSH_IS_UTXD1_MODFUNC() && 
      TOSH_IS_URXD1_IOFUNC()) {
        _ret = TRUE;
        }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
#line 92
  return _ret;
}

# 39 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline bool TOSH_IS_UTXD1_IOFUNC(void)
#line 39
{
#line 39
   static volatile uint8_t r __asm ("0x001B");

#line 39
  return r | ~(1 << 6);
}

#line 40
static inline bool TOSH_IS_URXD1_MODFUNC(void)
#line 40
{
#line 40
   static volatile uint8_t r __asm ("0x001B");

#line 40
  return r & (1 << 7);
}

# 95 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   bool HPLUSART1M$USARTControl$isUARTrx(void)
#line 95
{
  bool _ret = FALSE;

#line 97
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 97
    {

      if (
#line 98
      HPLUSART1M$ME2 & (1 << 4) && 
      TOSH_IS_URXD1_MODFUNC() && 
      TOSH_IS_UTXD1_IOFUNC()) {
        _ret = TRUE;
        }
    }
#line 103
    __nesc_atomic_end(__nesc_atomic); }
#line 103
  return _ret;
}

#line 73
static inline   bool HPLUSART1M$USARTControl$isUART(void)
#line 73
{
  bool _ret = FALSE;

#line 75
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 75
    {

      if (
#line 76
      HPLUSART1M$ME2 & (1 << 5) && HPLUSART1M$ME2 & (1 << 4) && 
      TOSH_IS_URXD1_MODFUNC() && 
      TOSH_IS_UTXD1_MODFUNC()) {
        _ret = TRUE;
        }
    }
#line 81
    __nesc_atomic_end(__nesc_atomic); }
#line 81
  return _ret;
}

#line 111
static inline   msp430_usartmode_t HPLUSART1M$USARTControl$getMode(void)
#line 111
{
  if (HPLUSART1M$USARTControl$isUART()) {
    return USART_UART;
    }
  else {
#line 114
    if (HPLUSART1M$USARTControl$isUARTrx()) {
      return USART_UART_RX;
      }
    else {
#line 116
      if (HPLUSART1M$USARTControl$isUARTtx()) {
        return USART_UART_TX;
        }
      else {
#line 118
        if (HPLUSART1M$USARTControl$isSPI()) {
          return USART_SPI;
          }
        else {
#line 120
          if (HPLUSART1M$USARTControl$isI2C()) {
            return USART_I2C;
            }
          else {
#line 123
            return USART_NONE;
            }
          }
        }
      }
    }
}

#line 325
static inline   void HPLUSART1M$USARTControl$setModeUART(void)
#line 325
{

  if (HPLUSART1M$USARTControl$getMode() == USART_UART) {
    return;
    }
  HPLUSART1M$USARTControl$disableSPI();
  HPLUSART1M$USARTControl$disableUART();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 333
    {
      TOSH_SEL_UTXD1_MODFUNC();
      TOSH_SEL_URXD1_MODFUNC();
    }
#line 336
    __nesc_atomic_end(__nesc_atomic); }
  HPLUSART1M$setUARTModeCommon();
  return;
}

# 153 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   void HPLUARTM$USARTControl$setModeUART(void){
#line 153
  HPLUSART1M$USARTControl$setModeUART();
#line 153
}
#line 153
# 50 "/opt/tinyos-1.x/tos/platform/msp430/HPLUARTM.nc"
static inline   result_t HPLUARTM$UART$init(void)
#line 50
{

  HPLUARTM$USARTControl$setModeUART();
#line 64
  HPLUARTM$USARTControl$setClockSource(0x20);
  HPLUARTM$USARTControl$setClockRate(UBR_SMCLK_57600, UMCTL_SMCLK_57600);
#line 77
  HPLUARTM$USARTControl$enableRxIntr();
  HPLUARTM$USARTControl$enableTxIntr();
  return SUCCESS;
}

# 62 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t UARTM$HPLUART$init(void){
#line 62
  unsigned char result;
#line 62

#line 62
  result = HPLUARTM$UART$init();
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 68 "/opt/tinyos-1.x/tos/system/UARTM.nc"
static inline  result_t UARTM$Control$start(void)
#line 68
{
  return UARTM$HPLUART$init();
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t FramerM$ByteControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = UARTM$Control$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 297 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  result_t FramerM$StdControl$start(void)
#line 297
{
  FramerM$HDLCInitialize();
  return FramerM$ByteControl$start();
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GenericCommProM$UARTControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = FramerM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 84 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline  result_t TimerM$StdControl$start(void)
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GenericCommProM$TimerControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 250 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  bool GenericCommProM$Control$start(void)
#line 250
{
  bool ok = SUCCESS;

  ok = GenericCommProM$TimerControl$start() && ok;

  ok = GenericCommProM$UARTControl$start() && ok;

  ok = GenericCommProM$RadioControl$start() && ok;
  ok = GenericCommProM$ActivityTimer$start(TIMER_REPEAT, 1000) && ok;





  if (SUCCESS != GenericCommProM$PowerManagement$adjustPower()) {
      ;
    }





  GenericCommProM$MacControl$enableAck();

  return ok;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t MultiHopLQI$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t MultiHopLQI$Timer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(5U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 264 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$StdControl$start(void)
#line 264
{
  MultiHopLQI$gLastHeard = 0;
  MultiHopLQI$Timer$start(TIMER_ONE_SHOT, 
  MultiHopLQI$Random$rand() % 1024 * 3 + 3);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t MultiHopEngineM$SubControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = MultiHopLQI$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t MultiHopEngineM$RouteStatusTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(4U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 124 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$StdControl$start(void)
#line 124
{



  MultiHopEngineM$RouteStatusTimer$start(TIMER_REPEAT, MultiHopEngineM$ROUTE_STATUS_CHECK_PERIOD);
  return MultiHopEngineM$SubControl$start();
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$SensingTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = RealTimeM$Timer$start(0U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 472 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$CompareB5$setEventFromNow(uint16_t x)
#line 472
{
#line 472
  MSP430TimerM$TBCCR5 = TBR + x;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void RealTimeM$MSP430Compare$setEventFromNow(uint16_t arg_0x408d5830){
#line 32
  MSP430TimerM$CompareB5$setEventFromNow(arg_0x408d5830);
#line 32
}
#line 32
# 416 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB5$enableEvents(void)
#line 416
{
#line 416
  MSP430TimerM$TBCCTL5 |= 0x0010;
}

# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void RealTimeM$MSP430TimerControl$enableEvents(void){
#line 38
  MSP430TimerM$ControlB5$enableEvents();
#line 38
}
#line 38
# 368 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB5$clearPendingInterrupt(void)
#line 368
{
#line 368
  MSP430TimerM$TBCCTL5 &= ~0x0001;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void RealTimeM$MSP430TimerControl$clearPendingInterrupt(void){
#line 32
  MSP430TimerM$ControlB5$clearPendingInterrupt();
#line 32
}
#line 32
# 108 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$StdControl$start(void)
#line 108
{
  RealTimeM$MSP430TimerControl$clearPendingInterrupt();
  RealTimeM$MSP430TimerControl$enableEvents();
  RealTimeM$MSP430Compare$setEventFromNow(66);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SmartSensingM$TimerControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = RealTimeM$StdControl$start();
#line 70
  result = rcombine(result, TimerM$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 77 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline  result_t MSP430ADC12M$StdControl$start(void)
{
  return SUCCESS;
}

# 87 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static inline  result_t ADCM$StdControl$start(void)
{
  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t DataMgmtM$BatchTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(2U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t DataMgmtM$SubControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 170 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$StdControl$start(void)
#line 170
{
  DataMgmtM$SubControl$start();
  DataMgmtM$BatchTimer$start(TIMER_ONE_SHOT, BATCH_TIMER_INTERVAL);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SmartSensingM$SubControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = DataMgmtM$StdControl$start();
#line 70
  result = rcombine(result, ADCM$StdControl$start());
#line 70
  result = rcombine(result, MSP430ADC12M$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t SmartSensingM$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 332 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$StdControl$start(void)
#line 332
{
  uint16_t randomtimer;

#line 334
  randomtimer = (SmartSensingM$Random$rand() & 0xff) + 0xf;
  SmartSensingM$SubControl$start();
  SmartSensingM$TimerControl$start();
  SmartSensingM$SensingTimer$start(TIMER_ONE_SHOT, randomtimer);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t MainM$StdControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = TimerM$StdControl$start();
#line 70
  result = rcombine(result, SmartSensingM$StdControl$start());
#line 70
  result = rcombine(result, MultiHopEngineM$StdControl$start());
#line 70
  result = rcombine(result, GenericCommProM$Control$start());
#line 70
  result = rcombine(result, TimeSyncM$StdControl$start());
#line 70
  result = rcombine(result, SNMSM$StdControl$start());
#line 70
  result = rcombine(result, CascadesRouterM$StdControl$start());
#line 70
  result = rcombine(result, NeighborMgmtM$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 113 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline void TimerM$removeTimer(uint8_t num)
{
  TimerM$m_timers[num].isset = FALSE;
}

# 166 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$TimerB$read(void)
#line 166
{
#line 166
  return TBR;
}

# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   uint16_t TimerM$AlarmTimer$read(void){
#line 30
  unsigned int result;
#line 30

#line 30
  result = MSP430TimerM$TimerB$read();
#line 30

#line 30
  return result;
#line 30
}
#line 30
# 169 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   bool MSP430TimerM$TimerB$isOverflowPending(void)
#line 169
{
#line 169
  return TBCTL & 0x0001;
}

# 31 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   bool TimerM$AlarmTimer$isOverflowPending(void){
#line 31
  unsigned char result;
#line 31

#line 31
  result = MSP430TimerM$TimerB$isOverflowPending();
#line 31

#line 31
  return result;
#line 31
}
#line 31
# 257 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline  void TimerM$checkShortTimers(void)
{
  uint8_t head = TimerM$m_head_short;

#line 260
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 260
    TimerM$m_posted_checkShortTimers = FALSE;
#line 260
    __nesc_atomic_end(__nesc_atomic); }
  TimerM$m_head_short = TimerM$EMPTY_LIST;
  TimerM$executeTimers(head);
  TimerM$setNextShortEvent();
}

# 718 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline void TimeSyncM$timeSyncMsgSend(void)
#line 718
{




  if (TimeSyncM$mode != TS_USER_MODE) {










      TimeSyncM$adjustRootID();

      if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID != 0xFFFF && (TimeSyncM$state & TimeSyncM$STATE_SENDING) == 0) {
          TimeSyncM$state |= TimeSyncM$STATE_SENDING;
          TOS_post(TimeSyncM$sendMsg);
        }
    }
  else 
    {
      if ((TimeSyncM$state & TimeSyncM$STATE_SENDING) == 0) {


          TimeSyncM$state |= TimeSyncM$STATE_SENDING;
          TOS_post(TimeSyncM$sendMsg);
        }
    }
}

# 209 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  bool RealTimeM$RealTime$isSync(void)
#line 209
{
  return RealTimeM$is_synced;
}

# 42 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  bool TimeSyncM$RealTime$isSync(void){
#line 42
  unsigned char result;
#line 42

#line 42
  result = RealTimeM$RealTime$isSync();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 219 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  uint8_t RealTimeM$RealTime$getMode(void)
#line 219
{
  return RealTimeM$syncMode;
}

# 44 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  uint8_t TimeSyncM$RealTime$getMode(void){
#line 44
  unsigned char result;
#line 44

#line 44
  result = RealTimeM$RealTime$getMode();
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 753 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$Timer$fired(void)
#line 753
{








  if (TimeSyncM$RealTime$getMode() == GPS_SYNC) {
      if (TimeSyncM$RealTime$isSync()) {
          TimeSyncM$mode = TS_USER_MODE;
        }
    }
  else {
#line 767
    TimeSyncM$mode = TS_TIMER_MODE;
    }
  TimeSyncM$timeSyncMsgSend();
  return SUCCESS;
}

# 332 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$ActivityTimer$fired(void)
#line 332
{
  GenericCommProM$lastCount = GenericCommProM$counter;
  GenericCommProM$counter = 0;
  GenericCommProM$tryNextSend();
  return SUCCESS;
}

# 353 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$SysCheckTimer$fired(void)
#line 353
{
#line 368
  return SUCCESS;
}

#line 330
static inline  result_t DataMgmtM$BatchTimer$fired(void)
#line 330
{
  DataMgmtM$batchTimerCount++;

  DataMgmtM$BatchTimer$start(TIMER_ONE_SHOT, BATCH_TIMER_INTERVAL);
  if (DataMgmtM$processTaskBusy != TRUE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 335
        DataMgmtM$processTaskBusy = TRUE;
#line 335
        __nesc_atomic_end(__nesc_atomic); }

      if (NULL != headMemElement(&DataMgmtM$sensorMem, FILLED) || NULL != headMemElement(&DataMgmtM$sensorMem, MEMPROCESSING)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 338
            DataMgmtM$processTaskBusy = TOS_post(DataMgmtM$processTask);
#line 338
            __nesc_atomic_end(__nesc_atomic); }
        }
      else 
        {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 342
            DataMgmtM$processTaskBusy = FALSE;
#line 342
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return SUCCESS;
}

# 498 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void)
#line 498
{
  MultiHopEngineM$tryNextSend();
  return SUCCESS;
}

# 6 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
inline static  result_t MultiHopLQI$MultihopCtrl$readyToSend(void){
#line 6
  unsigned char result;
#line 6

#line 6
  result = MultiHopEngineM$MultihopCtrl$readyToSend();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 5 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$setParent(uint16_t arg_0x41220098){
#line 5
  unsigned char result;
#line 5

#line 5
  result = NeighborMgmtM$NeighborCtrl$setParent(arg_0x41220098);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 187 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  void MultiHopLQI$TimerTask(void)
#line 187
{
  uint8_t val;

#line 189
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 189
    val = ++MultiHopLQI$gLastHeard;
#line 189
    __nesc_atomic_end(__nesc_atomic); }







  if (!MultiHopLQI$localBeSink && val > MultiHopLQI$BEACON_TIMEOUT) {
      MultiHopLQI$receivedBeacon = FALSE;
      MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
      MultiHopLQI$gbCurrentParentCost = 0x7fff;
      MultiHopLQI$gbCurrentLinkEst = 0x7fff;
      MultiHopLQI$gbLinkQuality = 0;
      MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
      MultiHopLQI$gbCurrentCost = 0xfffe;
      MultiHopLQI$fixedParent = FALSE;

      if (!MultiHopLQI$localBeSink) {
          MultiHopLQI$NeighborCtrl$setParent(TOS_BCAST_ADDR);
        }
    }


  if (MultiHopLQI$localBeSink) {
    MultiHopLQI$NeighborCtrl$setParent(TOS_UART_ADDR);
    }
  TOS_post(MultiHopLQI$SendRouteTask);
}

#line 421
static inline  result_t MultiHopLQI$Timer$fired(void)
#line 421
{
  TOS_post(MultiHopLQI$TimerTask);

  MultiHopLQI$MultihopCtrl$readyToSend();

  MultiHopLQI$Timer$start(TIMER_ONE_SHOT, 1024 * MultiHopLQI$gUpdateInterval + 1);
  return SUCCESS;
}

#line 535
static inline  result_t MultiHopLQI$MultihopCtrl$switchParent(void)
#line 535
{
#line 552
  return FAIL;
}

# 2 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
inline static  result_t MultiHopEngineM$MultihopCtrl$switchParent(void){
#line 2
  unsigned char result;
#line 2

#line 2
  result = MultiHopLQI$MultihopCtrl$switchParent();
#line 2

#line 2
  return result;
#line 2
}
#line 2
# 352 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteControl$getParent(void)
#line 352
{
  return MultiHopLQI$gbCurrentParent;
}

# 49 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
inline static  uint16_t MultiHopEngineM$RouteSelectCntl$getParent(void){
#line 49
  unsigned int result;
#line 49

#line 49
  result = MultiHopLQI$RouteControl$getParent();
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 531 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  uint16_t MultiHopEngineM$RouteControl$getParent(void)
#line 531
{
  return MultiHopEngineM$RouteSelectCntl$getParent();
}

#line 478
static inline  result_t MultiHopEngineM$RouteStatusTimer$fired(void)
#line 478
{
  if (!MultiHopEngineM$beParentActive) {


      ;
      if (MultiHopEngineM$RouteControl$getParent() != TOS_BCAST_ADDR) {
          MultiHopEngineM$MultihopCtrl$switchParent();
          MultiHopEngineM$numOfSuccessiveFailures = 0;
        }
    }

  MultiHopEngineM$beParentActive = FALSE;
  return SUCCESS;
}

# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t CascadesRouterM$SubSend$send(uint8_t arg_0x41550e50, TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850){
#line 83
  unsigned char result;
#line 83

#line 83
  result = CascadesEngineM$MySend$send(arg_0x41550e50, arg_0x40a166c0, arg_0x40a16850);
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 564 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$ACKTimer$fired(void)
#line 564
{
  if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCTRLMSG, &CascadesRouterM$SendCtrlMsg, CascadesRouterM$SendCtrlMsg.length)) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 566
        CascadesRouterM$ctrlMsgBusy = FALSE;
#line 566
        __nesc_atomic_end(__nesc_atomic); }
    }
  return SUCCESS;
}

#line 556
static inline  result_t CascadesRouterM$DelayTimer$fired(void)
#line 556
{
  if (CascadesRouterM$sigRcvTaskBusy != TRUE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 558
        CascadesRouterM$sigRcvTaskBusy = TOS_post(CascadesRouterM$sigRcvTask);
#line 558
        __nesc_atomic_end(__nesc_atomic); }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 560
    CascadesRouterM$delayTimerBusy = FALSE;
#line 560
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$ResetTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(8U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 536 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$ResetTimer$fired(void)
#line 536
{
  ++CascadesRouterM$resetCount;
  if (CascadesRouterM$resetCount == 10) {
      CascadesRouterM$initialize();
    }
  else {
      CascadesRouterM$ResetTimer$start(TIMER_ONE_SHOT, 60000UL);
    }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t CascadesRouterM$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$DTTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(7U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 119 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline NetworkMsg *CascadesRouterM$getCasData(TOS_MsgPtr tmPtr)
#line 119
{
  return (NetworkMsg *)tmPtr->data;
}

#line 305
static inline void CascadesRouterM$produceDataMsg(TOS_MsgPtr tmPtr)
#line 305
{
  NetworkMsg *nwMsg = (NetworkMsg *)tmPtr->data;

#line 307
  nwMsg->linksource = TOS_LOCAL_ADDRESS;
}

#line 437
static inline  result_t CascadesRouterM$DTTimer$fired(void)
#line 437
{
  TOS_MsgPtr tempPtr = NULL;
  int8_t i = 0;
  uint8_t stopCount = 0;

  for (i = MAX_CAS_BUF - 1; i >= 0; i--) {
      if (CascadesRouterM$myBuffer[i].countDT != 0) {
          if (CascadesRouterM$getCMAu(i) == TRUE) {
              CascadesRouterM$clearChildrenListStatus(i);
              stopCount++;
            }
          else {
              CascadesRouterM$myBuffer[i].countDT--;
              if (CascadesRouterM$myBuffer[i].countDT == 0) {
                  CascadesRouterM$myBuffer[i].countDT = DEFAULT_DTCOUNT;
                  ++ CascadesRouterM$myBuffer[i].retry;
                  tempPtr = & CascadesRouterM$myBuffer[i].tmsg;
                  CascadesRouterM$produceDataMsg(tempPtr);
                  if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCADESMSG, tempPtr, tempPtr->length)) {
                    }

                  if (CascadesRouterM$myBuffer[i].retry >= MAX_CAS_RETRY_COUNT) {
                      CascadesRouterM$clearChildrenListStatus(i);
                      stopCount = MAX_CAS_BUF;
                      break;
                    }
                  else {
                      if (CascadesRouterM$myBuffer[i].retry > 2) {
                          if (TRUE != CascadesRouterM$ctrlMsgBusy) {
                              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 466
                                CascadesRouterM$ctrlMsgBusy = TRUE;
#line 466
                                __nesc_atomic_end(__nesc_atomic); }
                              CascadesRouterM$produceCtrlMsg(&CascadesRouterM$SendCtrlMsg, CascadesRouterM$getCasData(tempPtr)->seqno, TYPE_CASCADES_CMAU);
                              tempPtr = &CascadesRouterM$SendCtrlMsg;
                              tempPtr->addr = TOS_BCAST_ADDR;
                              if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCTRLMSG, tempPtr, tempPtr->length)) {
                                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 471
                                    CascadesRouterM$ctrlMsgBusy = FALSE;
#line 471
                                    __nesc_atomic_end(__nesc_atomic); }
                                }
                            }
                        }
                    }
                }
            }
        }
      else 
        {
          stopCount++;
        }
    }
  if (stopCount != MAX_CAS_BUF) {
      CascadesRouterM$DTTimer$start(TIMER_ONE_SHOT, MIN_INTERVAL + (CascadesRouterM$Random$rand() & 0xf));
    }
  else {
      CascadesRouterM$DataTimerOn = FALSE;
    }
  return SUCCESS;
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$RTTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(6U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 501 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$RTTimer$fired(void)
#line 501
{
  TOS_MsgPtr tempPtr = NULL;

#line 503
  if (CascadesRouterM$expectingSeq >= CascadesRouterM$highestSeq) {
      CascadesRouterM$RTTimer$stop();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 505
        CascadesRouterM$activeRT = FALSE;
#line 505
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  else {
      if (CascadesRouterM$expectingSeq - CascadesRouterM$highestSeq < 10) {
          CascadesRouterM$RTTimer$stop();
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 511
            CascadesRouterM$activeRT = FALSE;
#line 511
            __nesc_atomic_end(__nesc_atomic); }
          return SUCCESS;
        }
    }
  if (TRUE != CascadesRouterM$ctrlMsgBusy) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 516
        CascadesRouterM$ctrlMsgBusy = TRUE;
#line 516
        __nesc_atomic_end(__nesc_atomic); }
      tempPtr = &CascadesRouterM$SendCtrlMsg;
      CascadesRouterM$produceCtrlMsg(tempPtr, CascadesRouterM$expectingSeq, TYPE_CASCADES_REQ);

      tempPtr->addr = TOS_BCAST_ADDR;
      if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCTRLMSG, tempPtr, tempPtr->length)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 522
            CascadesRouterM$ctrlMsgBusy = FALSE;
#line 522
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return SUCCESS;
}

#line 394
static inline  result_t CascadesRouterM$CascadeControl$deleteDirectChild(address_t childID)
#line 394
{
  CascadesRouterM$delFromChildrenList(childID);
  return SUCCESS;
}

# 4 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$deleteDirectChild(address_t arg_0x415431f0){
#line 4
  unsigned char result;
#line 4

#line 4
  result = CascadesRouterM$CascadeControl$deleteDirectChild(arg_0x415431f0);
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 195 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline void NeighborMgmtM$updateTable(void)
#line 195
{
  NBRTableEntry *pNbr;
  uint8_t childLiveOrigin = 0;
  uint8_t i = 0;

#line 199
  for (i = 0; i < 16; i++) {
      pNbr = &NeighborMgmtM$NeighborTbl[i];
      if (pNbr->flags & NBRFLAG_VALID) {
          NeighborMgmtM$ticks++;
          if (NeighborMgmtM$ticks >= 10) {
              NeighborMgmtM$ticks = 0;
              pNbr->linkEst = pNbr->linkEstCandidate;
              pNbr->linkEstCandidate = 0;
              pNbr->flags |= NBRFLAG_JUST_UPDATED;
            }
          if (pNbr->liveliness > 0) {
            pNbr->liveliness--;
            }

          childLiveOrigin = pNbr->childLiveliness;
          if (pNbr->childLiveliness > 0) {
              pNbr->childLiveliness--;
            }
          if (pNbr->childLiveliness == 0 && childLiveOrigin - pNbr->childLiveliness == 1) {
              if (pNbr->relation & NBR_DIRECT_CHILD) {
                  NeighborMgmtM$CascadeControl$deleteDirectChild(pNbr->id);
                }
              pNbr->relation &= ~(NBR_CHILD | NBR_DIRECT_CHILD);
            }
        }
    }
}

#line 188
static inline  void NeighborMgmtM$timerTask(void)
#line 188
{


  NeighborMgmtM$updateTable();
}

#line 72
static inline  result_t NeighborMgmtM$Timer$fired(void)
#line 72
{
  if (NeighborMgmtM$initTime) {
      NeighborMgmtM$initTime = FALSE;
      return NeighborMgmtM$Timer$start(TIMER_REPEAT, 1024);
    }
  else {
      return TOS_post(NeighborMgmtM$timerTask);
    }
}

# 463 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline   result_t TimerM$Timer$default$fired(uint8_t num)
{
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t TimerM$Timer$fired(uint8_t arg_0x40c46118){
#line 73
  unsigned char result;
#line 73

#line 73
  switch (arg_0x40c46118) {
#line 73
    case 0U:
#line 73
      result = TimeSyncM$Timer$fired();
#line 73
      break;
#line 73
    case 1U:
#line 73
      result = GenericCommProM$ActivityTimer$fired();
#line 73
      break;
#line 73
    case 2U:
#line 73
      result = DataMgmtM$BatchTimer$fired();
#line 73
      break;
#line 73
    case 3U:
#line 73
      result = DataMgmtM$SysCheckTimer$fired();
#line 73
      break;
#line 73
    case 4U:
#line 73
      result = MultiHopEngineM$RouteStatusTimer$fired();
#line 73
      break;
#line 73
    case 5U:
#line 73
      result = MultiHopLQI$Timer$fired();
#line 73
      break;
#line 73
    case 6U:
#line 73
      result = CascadesRouterM$RTTimer$fired();
#line 73
      break;
#line 73
    case 7U:
#line 73
      result = CascadesRouterM$DTTimer$fired();
#line 73
      break;
#line 73
    case 8U:
#line 73
      result = CascadesRouterM$ResetTimer$fired();
#line 73
      break;
#line 73
    case 9U:
#line 73
      result = CascadesRouterM$DelayTimer$fired();
#line 73
      break;
#line 73
    case 10U:
#line 73
      result = CascadesRouterM$ACKTimer$fired();
#line 73
      break;
#line 73
    case 11U:
#line 73
      result = NeighborMgmtM$Timer$fired();
#line 73
      break;
#line 73
    default:
#line 73
      result = TimerM$Timer$default$fired(arg_0x40c46118);
#line 73
      break;
#line 73
    }
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 394 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline uint8_t TimerM$fromNumMilli(uint8_t num)
{
  return num + TimerM$OFFSET_TIMER_MILLI;
}

static inline  result_t TimerM$TimerMilli$setOneShot(uint8_t num, int32_t milli)
{
  return TimerM$setTimer(TimerM$fromNumMilli(num), milli * 32, FALSE);
}

# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
inline static  result_t RefVoltM$SwitchOffTimer$setOneShot(int32_t arg_0x40c2c340){
#line 28
  unsigned char result;
#line 28

#line 28
  result = TimerM$TimerMilli$setOneShot(1U, arg_0x40c2c340);
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 230 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline  void RefVoltM$switchOffRetry(void)
#line 230
{
  if (RefVoltM$switchOff == TRUE) {
    RefVoltM$SwitchOffTimer$setOneShot(5);
    }
}

# 138 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setRefOff(void)
#line 138
{
#line 138
  HPLADC12M$ADC12CTL0 &= ~0x0020;
}

# 73 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void RefVoltM$HPLADC12$setRefOff(void){
#line 73
  HPLADC12M$HPLADC12$setRefOff();
#line 73
}
#line 73







inline static   void RefVoltM$HPLADC12$disableConversion(void){
#line 80
  HPLADC12M$HPLADC12$disableConversion();
#line 80
}
#line 80
# 112 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   bool HPLADC12M$HPLADC12$isBusy(void)
#line 112
{
#line 112
  return HPLADC12M$ADC12CTL1 & 0x0001;
}

# 65 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   bool RefVoltM$HPLADC12$isBusy(void){
#line 65
  unsigned char result;
#line 65

#line 65
  result = HPLADC12M$HPLADC12$isBusy();
#line 65

#line 65
  return result;
#line 65
}
#line 65
# 205 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static __inline void RefVoltM$switchRefOff(void)
#line 205
{
  result_t result;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 208
    {
      if (RefVoltM$switchOff == FALSE) {
        result = FAIL;
        }
      else {
#line 211
        if (RefVoltM$HPLADC12$isBusy()) {
            result = FAIL;
          }
        else {
            RefVoltM$HPLADC12$disableConversion();
            RefVoltM$HPLADC12$setRefOff();
            RefVoltM$state = RefVoltM$REFERENCE_OFF;
            result = SUCCESS;
          }
        }
    }
#line 221
    __nesc_atomic_end(__nesc_atomic); }
#line 221
  if (RefVoltM$switchOff == TRUE && result == FAIL) {
    TOS_post(RefVoltM$switchOffRetry);
    }
}










static inline  result_t RefVoltM$SwitchOffTimer$fired(void)
#line 235
{
  RefVoltM$switchRefOff();
  return SUCCESS;
}

# 127 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
inline static  void RefVoltM$RefVolt$isStable(RefVolt_t arg_0x413e8578){
#line 127
  MSP430ADC12M$RefVolt$isStable(arg_0x413e8578);
#line 127
}
#line 127
# 166 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline  result_t RefVoltM$SwitchOnTimer$fired(void)
#line 166
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 167
    {
      if (RefVoltM$state == RefVoltM$REFERENCE_1_5V_PENDING) {
        RefVoltM$state = RefVoltM$REFERENCE_1_5V_STABLE;
        }
#line 170
      if (RefVoltM$state == RefVoltM$REFERENCE_2_5V_PENDING) {
        RefVoltM$state = RefVoltM$REFERENCE_2_5V_STABLE;
        }
    }
#line 173
    __nesc_atomic_end(__nesc_atomic); }
#line 173
  if (RefVoltM$state == RefVoltM$REFERENCE_1_5V_STABLE) {
    RefVoltM$RefVolt$isStable(REFERENCE_1_5V);
    }
#line 175
  if (RefVoltM$state == RefVoltM$REFERENCE_2_5V_STABLE) {
    RefVoltM$RefVolt$isStable(REFERENCE_2_5V);
    }
#line 177
  return SUCCESS;
}

# 435 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline   result_t TimerM$TimerMilli$default$fired(uint8_t num)
{
  return SUCCESS;
}

# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
inline static  result_t TimerM$TimerMilli$fired(uint8_t arg_0x40c468b0){
#line 37
  unsigned char result;
#line 37

#line 37
  switch (arg_0x40c468b0) {
#line 37
    case 0U:
#line 37
      result = RefVoltM$SwitchOnTimer$fired();
#line 37
      break;
#line 37
    case 1U:
#line 37
      result = RefVoltM$SwitchOffTimer$fired();
#line 37
      break;
#line 37
    default:
#line 37
      result = TimerM$TimerMilli$default$fired(arg_0x40c468b0);
#line 37
      break;
#line 37
    }
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 386 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline   result_t TimerM$TimerJiffy$default$fired(uint8_t num)
{
  return SUCCESS;
}

# 37 "/opt/tinyos-1.x/tos/platform/msp430/TimerJiffy.nc"
inline static  result_t TimerM$TimerJiffy$fired(uint8_t arg_0x40c444e0){
#line 37
  unsigned char result;
#line 37

#line 37
    result = TimerM$TimerJiffy$default$fired(arg_0x40c444e0);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 118 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline void TimerM$signal_timer_fired(uint8_t num)
{



  const int16_t num16 = num;

  if (TimerM$COUNT_TIMER_JIFFY > 0 && num16 >= TimerM$OFFSET_TIMER_JIFFY) 
    {
      TimerM$TimerJiffy$fired(num - TimerM$OFFSET_TIMER_JIFFY);
    }
  else {
#line 129
    if (TimerM$COUNT_TIMER_MILLI > 0 && num16 >= TimerM$OFFSET_TIMER_MILLI) 
      {
        TimerM$TimerMilli$fired(num - TimerM$OFFSET_TIMER_MILLI);
      }
    else 
      {
        TimerM$Timer$fired(num);
      }
    }
}

# 116 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$startConversion(void)
#line 116
{
#line 116
  HPLADC12M$ADC12CTL0 |= 0x0001 + 0x0002;
}

# 81 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$startConversion(void){
#line 81
  HPLADC12M$HPLADC12$startConversion();
#line 81
}
#line 81
# 95 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline uint16_t MSP430TimerM$CC2int(MSP430TimerM$CC_t x)
#line 95
{
#line 95
  union __nesc_unnamed4330 {
#line 95
    MSP430TimerM$CC_t f;
#line 95
    uint16_t t;
  } 
#line 95
  c = { .f = x };

#line 95
  return c.t;
}

#line 218
static inline   void MSP430TimerM$ControlA1$setControl(MSP430TimerM$CC_t x)
#line 218
{
#line 218
  MSP430TimerM$TA0CCTL1 = MSP430TimerM$CC2int(x);
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void MSP430ADC12M$ControlA1$setControl(MSP430CompareControl_t arg_0x408c29a8){
#line 34
  MSP430TimerM$ControlA1$setControl(arg_0x408c29a8);
#line 34
}
#line 34
# 174 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$TimerA$setMode(int mode)
#line 174
{
#line 174
  MSP430TimerM$TA0CTL = (MSP430TimerM$TA0CTL & ~(0x0020 | 0x0010)) | ((mode << 4) & (0x0020 | 0x0010));
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430ADC12M$TimerA$setMode(int arg_0x408b9aa0){
#line 35
  MSP430TimerM$TimerA$setMode(arg_0x408b9aa0);
#line 35
}
#line 35
# 122 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static inline result_t CascadesEngineM$insertAndStartSend(TOS_MsgPtr msg)
#line 122
{
  result_t result;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 125
    {
      result = insertElement(&CascadesEngineM$sendQueue, msg);
      CascadesEngineM$tryNextSend();
    }
#line 128
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}

#line 94
static inline   result_t CascadesEngineM$SendMsg$default$send(uint8_t type, uint16_t dest, uint8_t length, TOS_MsgPtr pMsg)
#line 94
{
  return FAIL;
}

# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t CascadesEngineM$SendMsg$send(uint8_t arg_0x415fc7b8, uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728){
#line 48
  unsigned char result;
#line 48

#line 48
  switch (arg_0x415fc7b8) {
#line 48
    case AM_CASCTRLMSG:
#line 48
      result = GenericCommProM$SendMsg$send(AM_CASCTRLMSG, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48
      break;
#line 48
    case AM_CASCADESMSG:
#line 48
      result = GenericCommProM$SendMsg$send(AM_CASCADESMSG, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48
      break;
#line 48
    default:
#line 48
      result = CascadesEngineM$SendMsg$default$send(arg_0x415fc7b8, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48
      break;
#line 48
    }
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 99 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static inline  void CascadesEngineM$sendTask(void)
#line 99
{
  TOS_MsgPtr msg;

#line 101
  msg = headElement(&CascadesEngineM$sendQueue, PENDING);
  if (msg == NULL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 103
        CascadesEngineM$sendTaskBusy = FALSE;
#line 103
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }

  if (SUCCESS == CascadesEngineM$SendMsg$send(msg->type, msg->addr, msg->length, msg)) {
      if (SUCCESS != changeElementStatus(&CascadesEngineM$sendQueue, msg, PENDING, PROCESSING)) {
          ;
        }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 111
        {
          CascadesEngineM$sendTaskBusy = FALSE;
          CascadesEngineM$tryNextSend();
        }
#line 114
        __nesc_atomic_end(__nesc_atomic); }
    }
  else 
#line 115
    {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 116
        CascadesEngineM$sendTaskBusy = FALSE;
#line 116
        __nesc_atomic_end(__nesc_atomic); }
      CascadesEngineM$SendMsg$sendDone(msg->type, msg, FAIL);
    }
  return;
}

# 536 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline result_t GenericCommProM$updateProtocolField(TOS_MsgPtr msg, uint8_t id, address_t addr, uint8_t len)
#line 536
{
  if (len > 74) {
      ;
      return FAIL;
    }
  msg->type = id;
  msg->addr = addr;
  msg->group = TOS_AM_GROUP;
  msg->length = len;
  return SUCCESS;
}

#line 504
static inline result_t GenericCommProM$insertAndStartSend(TOS_MsgPtr msg)
#line 504
{
  result_t result;

#line 506
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 506
    {
      result = insertElement(&GenericCommProM$sendQueue, msg);
      GenericCommProM$tryNextSend();
    }
#line 509
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t CC2420RadioM$Random$rand(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 744 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline    int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr m)
#line 744
{
  return (CC2420RadioM$Random$rand() & 0xF) + 1;
}

# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
inline static   int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0x40d999b8){
#line 74
  int result;
#line 74

#line 74
  result = CC2420RadioM$MacBackoff$default$initialBackoff(arg_0x40d999b8);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0x40db7d10){
#line 6
  unsigned char result;
#line 6

#line 6
  result = TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(arg_0x40db7d10);
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 128 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static __inline result_t CC2420RadioM$setInitialTimer(uint16_t jiffy)
#line 128
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_INITIAL;
  if (jiffy == 0) {

    return CC2420RadioM$BackoffTimerJiffy$setOneShot(2);
    }
#line 133
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
static __inline int is_host_lsb(void)
{
  const uint8_t n[2] = { 1, 0 };

#line 15
  return * (uint16_t *)n == 1;
}

static __inline uint16_t toLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}

# 491 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  result_t CC2420RadioM$Send$send(TOS_MsgPtr pMsg)
#line 491
{
  uint8_t currentstate;

#line 493
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 493
    currentstate = CC2420RadioM$stateRadio;
#line 493
    __nesc_atomic_end(__nesc_atomic); }

  if (currentstate == CC2420RadioM$IDLE_STATE) {

      pMsg->fcflo = 0x08;
      if (CC2420RadioM$bAckEnable) {
        pMsg->fcfhi = 0x21;
        }
      else {
#line 501
        pMsg->fcfhi = 0x01;
        }
      pMsg->destpan = TOS_BCAST_ADDR;

      pMsg->addr = toLSB16(pMsg->addr);

      pMsg->length = pMsg->length + MSG_HEADER_SIZE + MSG_FOOTER_SIZE;

      pMsg->dsn = ++CC2420RadioM$currentDSN;

      pMsg->time = 0;

      CC2420RadioM$txlength = pMsg->length - MSG_FOOTER_SIZE;
      CC2420RadioM$txbufptr = pMsg;
      CC2420RadioM$countRetry = 8;

      if (CC2420RadioM$setInitialTimer(CC2420RadioM$MacBackoff$initialBackoff(CC2420RadioM$txbufptr) * 10)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 518
            CC2420RadioM$stateRadio = CC2420RadioM$PRE_TX_STATE;
#line 518
            __nesc_atomic_end(__nesc_atomic); }
          return SUCCESS;
        }
    }
  return FAIL;
}

# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t GenericCommProM$RadioSend$send(TOS_MsgPtr arg_0x40d018a0){
#line 58
  unsigned char result;
#line 58

#line 58
  result = CC2420RadioM$Send$send(arg_0x40d018a0);
#line 58

#line 58
  return result;
#line 58
}
#line 58
# 307 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  result_t FramerM$BareSendMsg$send(TOS_MsgPtr pMsg)
#line 307
{
  result_t Result = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 310
    {
      if (!(FramerM$gFlags & FramerM$FLAGS_DATAPEND)) {
          FramerM$gFlags |= FramerM$FLAGS_DATAPEND;
          FramerM$gpTxMsg = pMsg;
        }
      else 

        {
          Result = FAIL;
        }
    }
#line 320
    __nesc_atomic_end(__nesc_atomic); }

  if (Result == SUCCESS) {
      Result = FramerM$StartTx();
    }

  return Result;
}

# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t GenericCommProM$UARTSend$send(TOS_MsgPtr arg_0x40d018a0){
#line 58
  unsigned char result;
#line 58

#line 58
  result = FramerM$BareSendMsg$send(arg_0x40d018a0);
#line 58

#line 58
  return result;
#line 58
}
#line 58
# 405 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline void GenericCommProM$sendFunc(void)
#line 405
{
  result_t ok;
  TOS_MsgPtr m;
#line 407
  TOS_MsgPtr m2;
  uint8_t ind;

  m = headElement(&GenericCommProM$sendQueue, PENDING);
  if (m == NULL) {
      GenericCommProM$sendTaskBusy = FALSE;
      return;
    }
  m2 = m;


  if (m2->addr == TOS_UART_ADDR) {
      if (GenericCommProM$state) {
          GenericCommProM$sendTaskBusy = FALSE;
          return;
        }
      GenericCommProM$state = TRUE;
      GenericCommProM$UARTOrRadio = UART;
      ok = GenericCommProM$UARTSend$send(m2);
    }
  else 

    {
      GenericCommProM$UARTOrRadio = RADIO;
      ok = GenericCommProM$RadioSend$send(m2);
    }
  GenericCommProM$sendTaskBusy = FALSE;
  if (ok == SUCCESS) {
      changeElementStatus(&GenericCommProM$sendQueue, m, PENDING, PROCESSING);
      ;

      if (GenericCommProM$UARTOrRadio == RADIO) {
          GenericCommProM$tryNextSend();
        }
    }
  else {
      ind = GenericCommProM$findBkHeaderEntry(m);
      if (ind < COMM_SEND_QUEUE_SIZE) {
          m->addr = GenericCommProM$bkHeader[ind].addr;
          m->group = GenericCommProM$bkHeader[ind].group;
          m->type = GenericCommProM$bkHeader[ind].type;
          m->length = GenericCommProM$bkHeader[ind].length;
        }
      else 
#line 449
        {
          ;
        }
      if (GenericCommProM$UARTOrRadio == UART) {
          GenericCommProM$state = FALSE;
        }

      if (headElement(&GenericCommProM$sendQueue, PROCESSING) == NULL) {
          GenericCommProM$tryNextSend();
        }
    }
  return;
}

static inline  void GenericCommProM$sendTask(void)
#line 463
{
  GenericCommProM$sendFunc();
}

# 408 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
static inline   result_t HPLUSART1M$USARTControl$tx(uint8_t data)
#line 408
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 409
    {
      HPLUSART1M$U1TXBUF = data;
    }
#line 411
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 202 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLUARTM$USARTControl$tx(uint8_t arg_0x40e95850){
#line 202
  unsigned char result;
#line 202

#line 202
  result = HPLUSART1M$USARTControl$tx(arg_0x40e95850);
#line 202

#line 202
  return result;
#line 202
}
#line 202
# 98 "/opt/tinyos-1.x/tos/platform/msp430/HPLUARTM.nc"
static inline   result_t HPLUARTM$UART$put(uint8_t data)
#line 98
{
  return HPLUARTM$USARTControl$tx(data);
}

# 80 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t UARTM$HPLUART$put(uint8_t arg_0x410c46c0){
#line 80
  unsigned char result;
#line 80

#line 80
  result = HPLUARTM$UART$put(arg_0x410c46c0);
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 370 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$UARTSend$sendDone(TOS_MsgPtr msg, result_t success)
#line 370
{
  GenericCommProM$state = FALSE;
  return GenericCommProM$reportSendDone(msg, success);
}

# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010){
#line 67
  unsigned char result;
#line 67

#line 67
  result = GenericCommProM$UARTSend$sendDone(arg_0x40d01e48, arg_0x40d00010);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 397 "/home/xu/oasis/system/queue.h"
static inline bool incRetryCount(object_type **object)
#line 397
{
  Element_t *el;

#line 399
  if (object == NULL) {
    return FAIL;
    }
  else 
#line 401
    {
      el = (Element_t *)((char *)object - (unsigned long )& ((Element_t *)0)->obj);
      el->retry++;
      return SUCCESS;
    }
}

#line 387
static inline uint8_t getRetryCount(object_type **object)
#line 387
{
  Element_t *el;

#line 389
  if (object == NULL) {
    return 0xff;
    }
  else 
#line 391
    {
      el = (Element_t *)((char *)object - (unsigned long )& ((Element_t *)0)->obj);
      return el->retry;
    }
}

# 8 "/home/xu/oasis/lib/GenericCommPro/QosRexmit.h"
static inline uint8_t qosRexmit(uint8_t qos)
#line 8
{
  switch (qos) {
      case 1: return 2;
      case 2: return 2;
      case 3: return 3;
      case 4: return 4;
      case 5: return 4;
      case 6: return 5;
      case 7: return 6;
      default: return 2;
    }
}

# 523 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 523
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 524
    MultiHopLQI$msgBufBusy = FALSE;
#line 524
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 749 "build/telosb/RpcM.nc"
static inline  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 749
{


  ;



  return SUCCESS;
}

# 621 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Send$default$sendDone(uint8_t AMID, TOS_MsgPtr pMsg, 
result_t success)
#line 622
{
  MultiHopEngineM$falseType++;
  return SUCCESS;
}

# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t MultiHopEngineM$Send$sendDone(uint8_t arg_0x414e10f8, TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30){
#line 119
  unsigned char result;
#line 119

#line 119
  switch (arg_0x414e10f8) {
#line 119
    case NW_DATA:
#line 119
      result = DataMgmtM$Send$sendDone(arg_0x409fb9a0, arg_0x409fbb30);
#line 119
      break;
#line 119
    case NW_SNMS:
#line 119
      result = EventReportM$EventSend$sendDone(arg_0x409fb9a0, arg_0x409fbb30);
#line 119
      break;
#line 119
    case NW_RPCR:
#line 119
      result = RpcM$ResponseSend$sendDone(arg_0x409fb9a0, arg_0x409fbb30);
#line 119
      break;
#line 119
    default:
#line 119
      result = MultiHopEngineM$Send$default$sendDone(arg_0x414e10f8, arg_0x409fb9a0, arg_0x409fbb30);
#line 119
      break;
#line 119
    }
#line 119

#line 119
  return result;
#line 119
}
#line 119
# 418 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  bool MultiHopLQI$RouteControl$isSink(void)
#line 418
{
  return MultiHopLQI$localBeSink;
}

# 116 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
inline static  bool MultiHopEngineM$RouteSelectCntl$isSink(void){
#line 116
  unsigned char result;
#line 116

#line 116
  result = MultiHopLQI$RouteControl$isSink();
#line 116

#line 116
  return result;
#line 116
}
#line 116
# 254 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr msg, result_t success)
#line 254
{
  uint8_t infoIn = 0;
  TOS_MsgPtr *mPPtr = NULL;

#line 257
  ;
  mPPtr = findObject(&MultiHopEngineM$sendQueue, msg);
  if (mPPtr == NULL) {
      ;
      return SUCCESS;
    }
  if ((infoIn = MultiHopEngineM$findInfoEntry(msg)) == 5) {
      ;
    }
  if (MultiHopEngineM$RouteSelectCntl$isSink() || msg->addr != TOS_UART_ADDR) {
    MultiHopEngineM$beRadioActive = TRUE;
    }
  if (
#line 268
  success != SUCCESS && 
  msg->addr != TOS_BCAST_ADDR && 
  msg->addr != TOS_UART_ADDR) {
      ;
      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != NULL) {
        MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, FAIL);
        }
#line 274
      MultiHopEngineM$numLocalPendingPkt--;
      MultiHopEngineM$numberOfSendFailures++;
      MultiHopEngineM$numOfSuccessiveFailures++;
    }
  else 
#line 277
    {
      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != NULL) {
          MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, SUCCESS);
          MultiHopEngineM$numLocalPendingPkt--;
        }

      MultiHopEngineM$numberOfSendSuccesses++;
      if (msg->addr != TOS_BCAST_ADDR) {
          MultiHopEngineM$numOfSuccessiveFailures = 0;
          MultiHopEngineM$beParentActive = TRUE;
        }
    }

  if (SUCCESS != removeElement(&MultiHopEngineM$sendQueue, msg)) {
      ;
    }
  else 
    {
      ;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 297
    MultiHopEngineM$numOfPktProcessing--;
#line 297
    __nesc_atomic_end(__nesc_atomic); }
  freeBuffer(&MultiHopEngineM$buffQueue, msg);
  MultiHopEngineM$freeInfoEntry(infoIn);
  MultiHopEngineM$tryNextSend();
  return SUCCESS;
}

# 874 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   void TimeSyncM$TimeSyncNotify$default$msg_sent(void)
#line 874
{
}

# 26 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
inline static  void TimeSyncM$TimeSyncNotify$msg_sent(void){
#line 26
  TimeSyncM$TimeSyncNotify$default$msg_sent();
#line 26
}
#line 26
# 63 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$redToggle(void)
#line 63
{
  return SUCCESS;
}

# 81 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t TimeSyncM$Leds$redToggle(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = NoLeds$Leds$redToggle();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 693 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$SendMsg$sendDone(TOS_MsgPtr ptr, result_t success)
{

  if (ptr != &TimeSyncM$outgoingMsgBuffer) {
    return SUCCESS;
    }
  if (success) {
      ++TimeSyncM$heartBeats;
      TimeSyncM$Leds$redToggle();

      if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS) {
        ++ ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum;
        }
    }





  TimeSyncM$state &= ~TimeSyncM$STATE_SENDING;
  TimeSyncM$TimeSyncNotify$msg_sent();

  return SUCCESS;
}

# 365 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline   result_t GenericCommProM$SendMsg$default$sendDone(uint8_t id, TOS_MsgPtr msg, result_t success)
#line 365
{
  return SUCCESS;
}

# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t GenericCommProM$SendMsg$sendDone(uint8_t arg_0x40cdef00, TOS_MsgPtr arg_0x40bafbd8, result_t arg_0x40bafd68){
#line 49
  unsigned char result;
#line 49

#line 49
  switch (arg_0x40cdef00) {
#line 49
    case AM_NETWORKMSG:
#line 49
      result = MultiHopEngineM$SendMsg$sendDone(arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    case AM_CASCTRLMSG:
#line 49
      result = CascadesEngineM$SendMsg$sendDone(AM_CASCTRLMSG, arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    case AM_CASCADESMSG:
#line 49
      result = CascadesEngineM$SendMsg$sendDone(AM_CASCADESMSG, arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    case AM_TIMESYNCMSG:
#line 49
      result = TimeSyncM$SendMsg$sendDone(arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    case AM_BEACONMSG:
#line 49
      result = MultiHopLQI$SendMsg$sendDone(arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    default:
#line 49
      result = GenericCommProM$SendMsg$default$sendDone(arg_0x40cdef00, arg_0x40bafbd8, arg_0x40bafd68);
#line 49
      break;
#line 49
    }
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t DataMgmtM$SysCheckTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(3U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
#line 59
inline static  result_t DataMgmtM$SysCheckTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(3U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 75 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$greenToggle(void)
#line 75
{
  return SUCCESS;
}

# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t DataMgmtM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = NoLeds$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t DataMgmtM$Send$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_DATA, arg_0x40a166c0, arg_0x40a16850);
#line 83

#line 83
  return result;
#line 83
}
#line 83
#line 106
inline static  void *DataMgmtM$Send$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_DATA, arg_0x40a16f18, arg_0x409fb0e0);
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 426 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  void DataMgmtM$sendTask(void)
#line 426
{
  TOS_MsgPtr msg = NULL;
  ApplicationMsg *pApp = NULL;
  uint16_t length = 0;

  if (NULL == (msg = headElement(&DataMgmtM$sendQueue, PENDING))) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 432
        DataMgmtM$sendTaskBusy = FALSE;
#line 432
        __nesc_atomic_end(__nesc_atomic); }
      ;
      return;
    }

  DataMgmtM$headSendQueue = headElement(&DataMgmtM$sendQueue, PENDING);
  pApp = (ApplicationMsg *)DataMgmtM$Send$getBuffer(msg, &length);
  length = (size_t )& ((ApplicationMsg *)0)->data + pApp->length;
  DataMgmtM$Msg_length = length;
  DataMgmtM$sendCalled++;
  DataMgmtM$sendQueueLen = (&DataMgmtM$sendQueue)->total;

  if (SUCCESS == DataMgmtM$Send$send(msg, length)) {
      DataMgmtM$send_num++;
      if (SUCCESS != changeElementStatus(&DataMgmtM$sendQueue, msg, PENDING, PROCESSING)) {
          ;
        }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 449
        {

          ;
          DataMgmtM$sendTaskBusy = FALSE;
          DataMgmtM$tryNextSend();
        }
#line 454
        __nesc_atomic_end(__nesc_atomic); }

      return;
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 459
        {
          DataMgmtM$sendTaskBusy = FALSE;
          DataMgmtM$sendQueueLen = (&DataMgmtM$sendQueue)->total;
        }
#line 462
        __nesc_atomic_end(__nesc_atomic); }

      ;
      return;
    }
}

# 339 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr Msg, uint8_t id)
#line 339
{
  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];

#line 341
  pNWMsg->type = id;
  pNWMsg->linksource = pNWMsg->source = TOS_LOCAL_ADDRESS;
  pNWMsg->seqno = MultiHopLQI$gCurrentSeqNo++;
  pNWMsg->ttl = 31;
  return SUCCESS;
}

# 86 "/home/xu/oasis/lib/MultiHopOasis/RouteSelect.nc"
inline static  result_t MultiHopEngineM$RouteSelect$initializeFields(TOS_MsgPtr arg_0x411f8b58, uint8_t arg_0x411f8ce0){
#line 86
  unsigned char result;
#line 86

#line 86
  result = MultiHopLQI$RouteSelect$initializeFields(arg_0x411f8b58, arg_0x411f8ce0);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 582 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline uint8_t MultiHopEngineM$allocateInfoEntry(void)
#line 582
{
  uint8_t i = 0;

#line 584
  for (i = 0; i < 5; i++) {
      if (MultiHopEngineM$queueEntryInfo[i].valid == FALSE) {
        return i;
        }
    }
#line 588
  if (i == 5) {
    ;
    }
#line 590
  return i;
}

# 257 "/home/xu/oasis/system/queue.h"
static inline void _private_reorderElementByPriority(Queue_t *queue, int16_t ind)
#line 257
{
  int16_t _prev;
#line 258
  int16_t _last;
#line 258
  int16_t indprev;
#line 258
  int16_t indnext;

#line 259
  _last = ind;
  while ((_prev = queue->element[_last].prev) != -1) {
      if (queue->element[_prev].priority >= queue->element[ind].priority) {
#line 261
        break;
        }
#line 262
      _last = _prev;
    }

  if (_last == ind) {
      return;
    }
  indprev = queue->element[ind].prev;
  indnext = queue->element[ind].next;


  if (indprev != -1) {
    queue->element[indprev].next = indnext;
    }
#line 274
  if (indnext != -1) {
      queue->element[indnext].prev = indprev;
    }
  else 
#line 276
    {

      queue->tail[queue->element[ind].status] = indprev;
    }


  if (_prev == -1) {
      queue->element[ind].prev = -1;
      queue->element[ind].next = _last;
      queue->element[_last].prev = ind;


      queue->head[queue->element[ind].status] = ind;
    }
  else 
#line 289
    {

      queue->element[_prev].next = ind;
      queue->element[ind].prev = _prev;
      queue->element[ind].next = _last;
      queue->element[_last].prev = ind;
    }

  return;
}

#line 202
static inline result_t insertElementPri(Queue_t *queue, object_type *obj, uint8_t priority)
#line 202
{

  int16_t ind;



  if (queue->size <= 0) {
      ;
      return FAIL;
    }



  if (queue->total >= queue->size) {

      return FAIL;
    }



  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].status != FREE && queue->element[ind].obj == obj) {
          ;
          return FAIL;
        }
    }


  ind = queue->head[FREE];
  queue->element[ind].obj = obj;

  queue->element[ind].retry = 0;









  _private_changeElementStatusByIndex(queue, ind, FREE, PENDING);


  queue->element[ind].priority = priority;
  _private_reorderElementByPriority(queue, ind);


  queue->total++;
  ;

  return SUCCESS;
}

#line 378
static inline object_type *tailElement(Queue_t *queue, ObjStatus_t status)
#line 378
{

  if (queue->tail[status] == -1) {
    return NULL;
    }
  else {
#line 383
    return queue->element[queue->tail[status]].obj;
    }
}

# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t MultiHopEngineM$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_NETWORKMSG, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 72 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t MultiHopEngineM$Leds$redOff(void){
#line 72
  unsigned char result;
#line 72

#line 72
  result = LedsC$Leds$redOff();
#line 72

#line 72
  return result;
#line 72
}
#line 72
#line 64
inline static   result_t MultiHopEngineM$Leds$redOn(void){
#line 64
  unsigned char result;
#line 64

#line 64
  result = LedsC$Leds$redOn();
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 280 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr Msg, uint8_t id, 
uint8_t resend)
#line 281
{
  int i;
  int8_t ttlDiff = 0;
  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];

  if (pNWMsg->source != TOS_LOCAL_ADDRESS && resend == 0) {

      for (i = 0; i < 10; i++) {

          if (
#line 289
          MultiHopLQI$gRecentOriginPacketSender[i] == pNWMsg->source && 
          MultiHopLQI$gRecentOriginPacketSeqNo[i] == pNWMsg->seqno && 
          !MultiHopLQI$localBeSink) {

              ttlDiff = MultiHopLQI$gRecentOriginPacketTTL[i] >= pNWMsg->ttl ? MultiHopLQI$gRecentOriginPacketTTL[i] - pNWMsg->ttl : pNWMsg->ttl - MultiHopLQI$gRecentOriginPacketTTL[i];
              if (ttlDiff >= 2) {
                  MultiHopLQI$gbCurrentParentCost = 0x7fff;
                  MultiHopLQI$gbCurrentLinkEst = 0x7fff;
                  MultiHopLQI$gbLinkQuality = 0;
                  MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;

                  MultiHopLQI$NeighborCtrl$setParent(TOS_BCAST_ADDR);

                  MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;

                  MultiHopLQI$fixedParent = FALSE;
                }

              ;
              return FAIL;
            }
        }

      MultiHopLQI$gRecentOriginPacketSender[MultiHopLQI$gRecentOriginIndex] = pNWMsg->source;
      MultiHopLQI$gRecentOriginPacketSeqNo[MultiHopLQI$gRecentOriginIndex] = pNWMsg->seqno;
      MultiHopLQI$gRecentOriginPacketTTL[MultiHopLQI$gRecentOriginIndex] = pNWMsg->ttl;
      MultiHopLQI$gRecentOriginIndex = (MultiHopLQI$gRecentOriginIndex + 1) % 10;
    }

  pNWMsg->linksource = TOS_LOCAL_ADDRESS;
  Msg->addr = MultiHopLQI$gbCurrentParent;
  if (pNWMsg->source == TOS_LOCAL_ADDRESS) {
      pNWMsg->dest = MultiHopLQI$gbCurrentParent;
    }



  if (pNWMsg->source != TOS_LOCAL_ADDRESS && resend == 0) {

      pNWMsg->ttl -= 1;
      ;
    }
  if (pNWMsg->ttl <= 0) {
      ;
      return FALSE;
    }
  pNWMsg->linksource = TOS_LOCAL_ADDRESS;
  return SUCCESS;
}

# 71 "/home/xu/oasis/lib/MultiHopOasis/RouteSelect.nc"
inline static  result_t MultiHopEngineM$RouteSelect$selectRoute(TOS_MsgPtr arg_0x411f8238, uint8_t arg_0x411f83c0, uint8_t arg_0x411f8548){
#line 71
  unsigned char result;
#line 71

#line 71
  result = MultiHopLQI$RouteSelect$selectRoute(arg_0x411f8238, arg_0x411f83c0, arg_0x411f8548);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 186 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  void MultiHopEngineM$sendTask(void)
#line 186
{
  TOS_MsgPtr msgPtr = headElement(&MultiHopEngineM$sendQueue, PENDING);
  uint8_t infoIn = 0;

#line 189
  MultiHopEngineM$sendTaskBusy = FALSE;
  if (msgPtr == NULL) {
      return;
    }

  infoIn = MultiHopEngineM$findInfoEntry(msgPtr);
  MultiHopEngineM$messageIsRetransmission = MultiHopEngineM$queueEntryInfo[infoIn].resend;

  if (infoIn == 5) {
      ;
    }

  if (MultiHopEngineM$queueEntryInfo[infoIn].valid == FALSE) 
    {
      goto out;
    }



  if (
#line 205
  MultiHopEngineM$RouteSelect$selectRoute(
  msgPtr, 
  MultiHopEngineM$queueEntryInfo[infoIn].AMID, 
  MultiHopEngineM$messageIsRetransmission) != SUCCESS) {

      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != NULL) {
          MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, FAIL);
          MultiHopEngineM$numLocalPendingPkt--;
          ;
        }
      out: 
        removeElement(&MultiHopEngineM$sendQueue, msgPtr);
      freeBuffer(&MultiHopEngineM$buffQueue, msgPtr);
      MultiHopEngineM$freeInfoEntry(infoIn);
      MultiHopEngineM$numberOfSendFailures++;
      MultiHopEngineM$numOfSuccessiveFailures++;
      MultiHopEngineM$tryNextSend();
      return;
    }
  else 
#line 223
    {

      if (msgPtr->addr == TOS_BCAST_ADDR) {
          MultiHopEngineM$Leds$redOn();

          return;
        }
      MultiHopEngineM$Leds$redOff();



      if (
#line 231
      MultiHopEngineM$SendMsg$send(
      msgPtr->addr, 
      MultiHopEngineM$queueEntryInfo[infoIn].length, 
      msgPtr) == SUCCESS) {
          if (SUCCESS != changeElementStatus(&MultiHopEngineM$sendQueue, msgPtr, PENDING, PROCESSING)) {
              ;
            }
          MultiHopEngineM$numOfPktProcessing++;
          ;
          MultiHopEngineM$tryNextSend();
          return;
        }
      else 
#line 242
        {


          MultiHopEngineM$queueEntryInfo[infoIn].resend = TRUE;
          if (headElement(&MultiHopEngineM$sendQueue, PROCESSING) == NULL) {
              MultiHopEngineM$tryNextSend();
            }
        }
    }
}

# 123 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline uint8_t NeighborMgmtM$findEntry(uint16_t id)
#line 123
{
  uint8_t i = 0;

#line 125
  for (i = 0; i < 16; i++) {
      if (NeighborMgmtM$NeighborTbl[i].flags & NBRFLAG_VALID && NeighborMgmtM$NeighborTbl[i].id == id) {
          return i;
        }
    }
  return ROUTE_INVALID;
}

#line 170
static inline uint8_t NeighborMgmtM$findEntryToBeReplaced(void)
#line 170
{
  uint8_t i = 0;
  uint8_t minLinkEst = -1;
  uint8_t minLinkEstIndex = ROUTE_INVALID;

#line 174
  for (i = 0; i < 16; i++) {
      if ((NeighborMgmtM$NeighborTbl[i].flags & NBRFLAG_VALID) == 0) {
          return i;
        }
      if (NeighborMgmtM$NeighborTbl[i].relation & NBR_PARENT) {
        continue;
        }
#line 180
      if (minLinkEst > NeighborMgmtM$NeighborTbl[i].linkEst) {
          minLinkEst = NeighborMgmtM$NeighborTbl[i].linkEst;
          minLinkEstIndex = i;
        }
    }
  return minLinkEstIndex;
}

#line 133
static inline void NeighborMgmtM$newEntry(uint8_t indes, uint16_t id)
#line 133
{
  NeighborMgmtM$NeighborTbl[indes].id = id;
  NeighborMgmtM$NeighborTbl[indes].flags = NBRFLAG_VALID | NBRFLAG_NEW;
  NeighborMgmtM$NeighborTbl[indes].liveliness = 0;
  NeighborMgmtM$NeighborTbl[indes].childLiveliness = 0;
  NeighborMgmtM$NeighborTbl[indes].linkEst = 0;
  NeighborMgmtM$NeighborTbl[indes].linkEstCandidate = 0;
  NeighborMgmtM$NeighborTbl[indes].parentCost = 0x7fff;
  NeighborMgmtM$NeighborTbl[indes].relation = 0;
}

#line 341
static inline  bool NeighborMgmtM$NeighborCtrl$clearParent(bool reset)
#line 341
{
  uint8_t ind = 0;

#line 343
  for (ind = 0; ind < 16; ind++) {
      if (NeighborMgmtM$NeighborTbl[ind].flags & NBRFLAG_VALID) {
          if (NeighborMgmtM$NeighborTbl[ind].relation & NBR_PARENT) {
              NeighborMgmtM$NeighborTbl[ind].relation ^= NBR_PARENT;
              if (reset) {
                  NeighborMgmtM$NeighborTbl[ind].flags = 0;
                }
              return TRUE;
            }
        }
    }
  return FALSE;
}

# 407 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$CascadeControl$parentChanged(address_t newParent)
#line 407
{
  TOS_MsgPtr tempPtr = NULL;

  if (newParent == TOS_BCAST_ADDR || CascadesRouterM$inited != TRUE) {
      return SUCCESS;
    }
  if (TRUE != CascadesRouterM$activeRT) {
      if (TRUE != CascadesRouterM$ctrlMsgBusy) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 415
            CascadesRouterM$ctrlMsgBusy = TRUE;
#line 415
            __nesc_atomic_end(__nesc_atomic); }
          tempPtr = &CascadesRouterM$SendCtrlMsg;
          CascadesRouterM$produceCtrlMsg(tempPtr, CascadesRouterM$expectingSeq, TYPE_CASCADES_REQ);

          tempPtr->addr = TOS_BCAST_ADDR;
          if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCTRLMSG, tempPtr, tempPtr->length)) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 421
                CascadesRouterM$ctrlMsgBusy = FALSE;
#line 421
                __nesc_atomic_end(__nesc_atomic); }
            }
        }
    }
  return SUCCESS;
}

# 5 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$parentChanged(address_t arg_0x41543698){
#line 5
  unsigned char result;
#line 5

#line 5
  result = CascadesRouterM$CascadeControl$parentChanged(arg_0x41543698);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 12 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_RED_LED_PIN(void)
#line 12
{
#line 12
   static volatile uint8_t r __asm ("0x0031");

#line 12
  r &= ~(1 << 4);
}

#line 12
static inline void TOSH_SET_RED_LED_PIN(void)
#line 12
{
#line 12
   static volatile uint8_t r __asm ("0x0031");

#line 12
  r |= 1 << 4;
}

# 608 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 608
{
  return SUCCESS;
}

# 529 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 529
{
  return SUCCESS;
}

# 244 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline   result_t EventReportM$EventReport$default$eventSendDone(uint8_t eventType, TOS_MsgPtr pMsg, result_t success)
#line 244
{
  return SUCCESS;
}

# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  result_t EventReportM$EventReport$eventSendDone(uint8_t arg_0x41169e18, TOS_MsgPtr arg_0x40a2b4e0, result_t arg_0x40a2b670){
#line 47
  unsigned char result;
#line 47

#line 47
  switch (arg_0x41169e18) {
#line 47
    case EVENT_TYPE_SNMS:
#line 47
      result = MultiHopLQI$EventReport$eventSendDone(arg_0x40a2b4e0, arg_0x40a2b670);
#line 47
      break;
#line 47
    case EVENT_TYPE_SENSING:
#line 47
      result = SmartSensingM$EventReport$eventSendDone(arg_0x40a2b4e0, arg_0x40a2b670);
#line 47
      break;
#line 47
    default:
#line 47
      result = EventReportM$EventReport$default$eventSendDone(arg_0x41169e18, arg_0x40a2b4e0, arg_0x40a2b670);
#line 47
      break;
#line 47
    }
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t EventReportM$EventSend$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_SNMS, arg_0x40a166c0, arg_0x40a16850);
#line 83

#line 83
  return result;
#line 83
}
#line 83
#line 106
inline static  void *EventReportM$EventSend$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_SNMS, arg_0x40a16f18, arg_0x409fb0e0);
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 317 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline  void EventReportM$sendEvent(void)
#line 317
{
  TOS_MsgPtr msgPtr;
  ApplicationMsg *pApp;
  uint16_t maxLen;
  uint8_t length;
  EventMsg *pEvent;

  msgPtr = headElement(&EventReportM$sendQueue, PENDING);
  if (msgPtr == NULL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 326
        {
          EventReportM$taskBusy = FALSE;
        }
#line 328
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 332
    EventReportM$gfSendBusy = TRUE;
#line 332
    __nesc_atomic_end(__nesc_atomic); }

  pApp = (ApplicationMsg *)EventReportM$EventSend$getBuffer(msgPtr, &maxLen);
  length = pApp->length + (size_t )& ((ApplicationMsg *)0)->data;
  pEvent = (EventMsg *)pApp->data;






  if (SUCCESS != EventReportM$EventSend$send(msgPtr, length)) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 345
        EventReportM$gfSendBusy = FALSE;
#line 345
        __nesc_atomic_end(__nesc_atomic); }
      if (headElement(&EventReportM$sendQueue, PROCESSING) == NULL) {

          EventReportM$tryNextSend();
        }
    }
  else 





    {
      ;

      if (SUCCESS != changeElementStatus(&EventReportM$sendQueue, msgPtr, PENDING, PROCESSING)) {
        ;
        }
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 364
        {
          EventReportM$taskBusy = FALSE;
          EventReportM$tryNextSend();
        }
#line 367
        __nesc_atomic_end(__nesc_atomic); }
    }





  return;
}

# 1009 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$SubSend$sendDone(uint8_t type, TOS_MsgPtr msg, result_t status)
#line 1009
{
  if (type == AM_CASCTRLMSG) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1011
        CascadesRouterM$ctrlMsgBusy = FALSE;
#line 1011
        __nesc_atomic_end(__nesc_atomic); }
    }
  return SUCCESS;
}

# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t CascadesEngineM$MySend$sendDone(uint8_t arg_0x415fc030, TOS_MsgPtr arg_0x409fb9a0, result_t arg_0x409fbb30){
#line 119
  unsigned char result;
#line 119

#line 119
  result = CascadesRouterM$SubSend$sendDone(arg_0x415fc030, arg_0x409fb9a0, arg_0x409fbb30);
#line 119

#line 119
  return result;
#line 119
}
#line 119
# 698 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline uint8_t GenericCommProM$allocateBkHeaderEntry(void)
#line 698
{
  uint8_t i = 0;

#line 700
  for (i = 0; i < COMM_SEND_QUEUE_SIZE; i++) {
      if (GenericCommProM$bkHeader[i].valid == FALSE) {
        return i;
        }
    }
#line 704
  if (i == COMM_SEND_QUEUE_SIZE) {
    ;
    }
#line 706
  return i;
}

# 146 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static inline void CascadesEngineM$updateProtocolField(TOS_MsgPtr msg, uint8_t type, uint8_t len)
#line 146
{
  msg->type = type;
  msg->length = len;
}

# 582 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t type, uint16_t code)
#line 582
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 583
    SmartSensingM$defaultCode = code;
#line 583
    __nesc_atomic_end(__nesc_atomic); }



  return SUCCESS;
}

# 43 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(uint8_t arg_0x40a037b0, uint16_t arg_0x40a03940){
#line 43
  unsigned char result;
#line 43

#line 43
  result = SmartSensingM$SensingConfig$setTaskSchedulingCode(arg_0x40a037b0, arg_0x40a03940);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 770 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline void SmartSensingM$setrate(void)
#line 770
{
  uint16_t oldInterval = SmartSensingM$timerInterval;

#line 772
  SmartSensingM$timerInterval = SmartSensingM$calFireInterval();
  if (oldInterval != SmartSensingM$timerInterval) {
      SmartSensingM$SensingTimer$start(TIMER_REPEAT, SmartSensingM$timerInterval);
    }
}

#line 382
static inline  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t type, uint16_t rate)
#line 382
{
  int8_t client;
  uint16_t oldrate;



  if (rate > MAX_SAMPLING_RATE) {
      return FAIL;
    }
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          oldrate = sensor[client].samplingRate;
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 394
            sensor[client].samplingRate = rate == 0 ? 0 : 1000UL / rate;
#line 394
            __nesc_atomic_end(__nesc_atomic); }
          if (oldrate != sensor[client].samplingRate) {
              SmartSensingM$updateMaxBlkNum();
              SmartSensingM$setrate();
            }




          return SUCCESS;
        }
    }
  return FAIL;
}

# 27 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setSamplingRate(uint8_t arg_0x40a07e08, uint16_t arg_0x40a06010){
#line 27
  unsigned char result;
#line 27

#line 27
  result = SmartSensingM$SensingConfig$setSamplingRate(arg_0x40a07e08, arg_0x40a06010);
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 544 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t priority)
#line 544
{
  int8_t client;



  if (priority < 8) {
      for (client = sensor_num - 1; client >= 0; client--) {

          sensor[client].nodePriority = priority;
        }






      return SUCCESS;
    }
  return FAIL;
}

# 39 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setNodePriority(uint8_t arg_0x40a03010){
#line 39
  unsigned char result;
#line 39

#line 39
  result = SmartSensingM$SensingConfig$setNodePriority(arg_0x40a03010);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 498 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t type, uint8_t priority)
#line 498
{
  int8_t client;



  if (priority < 8) {
      for (client = sensor_num - 1; client >= 0; client--) {
          if (sensor[client].type == type) {
              sensor[client].dataPriority = priority;




              return SUCCESS;
            }
        }
    }
  return FAIL;
}

# 35 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setDataPriority(uint8_t arg_0x40a044a8, uint8_t arg_0x40a04638){
#line 35
  unsigned char result;
#line 35

#line 35
  result = SmartSensingM$SensingConfig$setDataPriority(arg_0x40a044a8, arg_0x40a04638);
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 436 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t type, uint8_t channel)
#line 436
{
  int8_t client;



  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          sensor[client].channel = channel;
          SmartSensingM$ADCControl$bindPort(client, channel);




          return SUCCESS;
        }
    }

  if (sensor_num < MAX_SENSOR_NUM) {
      sensor[sensor_num].type = type;
      sensor[sensor_num].channel = channel;
      SmartSensingM$ADCControl$bindPort(sensor_num, channel);







      ++sensor_num;

      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 31 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setADCChannel(uint8_t arg_0x40a06948, uint8_t arg_0x40a06ad0){
#line 31
  unsigned char result;
#line 31

#line 31
  result = SmartSensingM$SensingConfig$setADCChannel(arg_0x40a06948, arg_0x40a06ad0);
#line 31

#line 31
  return result;
#line 31
}
#line 31
# 570 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t type)
#line 570
{
  return SmartSensingM$defaultCode;
}

# 45 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint16_t RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(uint8_t arg_0x40a03de8){
#line 45
  unsigned int result;
#line 45

#line 45
  result = SmartSensingM$SensingConfig$getTaskSchedulingCode(arg_0x40a03de8);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 360 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t type)
#line 360
{
  int8_t client;

#line 362
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          if (sensor[client].samplingRate != 0) {
              return 1000UL / sensor[client].samplingRate;
            }
          else {
              return 0;
            }
        }
    }
  return 0;
}

# 29 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint16_t RpcM$SmartSensingM_SensingConfig$getSamplingRate(uint8_t arg_0x40a064b0){
#line 29
  unsigned int result;
#line 29

#line 29
  result = SmartSensingM$SensingConfig$getSamplingRate(arg_0x40a064b0);
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 525 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getNodePriority(void)
#line 525
{






  return sensor[0].nodePriority;
}

# 41 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getNodePriority(void){
#line 41
  unsigned char result;
#line 41

#line 41
  result = SmartSensingM$SensingConfig$getNodePriority();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 480 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t type)
#line 480
{
  int8_t client;

#line 482
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          return sensor[client].dataPriority;
        }
    }
  return -1;
}

# 37 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getDataPriority(uint8_t arg_0x40a04ad0){
#line 37
  unsigned char result;
#line 37

#line 37
  result = SmartSensingM$SensingConfig$getDataPriority(arg_0x40a04ad0);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 416 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t type)
#line 416
{
  int8_t client;

#line 418
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          return sensor[client].channel;
        }
    }
  return -1;
}

# 33 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getADCChannel(uint8_t arg_0x40a04010){
#line 33
  unsigned char result;
#line 33

#line 33
  result = SmartSensingM$SensingConfig$getADCChannel(arg_0x40a04010);
#line 33

#line 33
  return result;
#line 33
}
#line 33
# 280 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  void SNMSM$restart(void)
#line 280
{
}

# 42 "build/telosb/RpcM.nc"
inline static  void RpcM$SNMSM_restart(void){
#line 42
  SNMSM$restart();
#line 42
}
#line 42
# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SNMSM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = LedsC$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
#line 106
inline static   result_t SNMSM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = LedsC$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
#line 81
inline static   result_t SNMSM$Leds$redToggle(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = LedsC$Leds$redToggle();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 169 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  result_t SNMSM$ledsOn(uint8_t ledColorParam)
#line 169
{
  switch (ledColorParam) 
    {
      case 0: 
        SNMSM$Leds$redToggle();
      break;
      case 1: 
        SNMSM$Leds$greenToggle();
      break;
      case 2: 
        SNMSM$Leds$yellowToggle();
      break;
    }
  return SUCCESS;
}

# 41 "build/telosb/RpcM.nc"
inline static  result_t RpcM$SNMSM_ledsOn(uint8_t arg_0x4119e888){
#line 41
  unsigned char result;
#line 41

#line 41
  result = SNMSM$ledsOn(arg_0x4119e888);
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 41 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
static inline  unsigned int RamSymbolsM$poke(ramSymbol_t *p_symbol)
#line 41
{
  if (p_symbol->length <= MAX_RAM_SYMBOL_SIZE) {
      if (p_symbol->dereference == TRUE) {
          nmemcpy(* (void **)p_symbol->memAddress, (void *)p_symbol->data, p_symbol->length);
        }
      else {
          nmemcpy((void *)p_symbol->memAddress, (void *)p_symbol->data, p_symbol->length);
        }
    }
  return p_symbol->memAddress;
}

# 40 "build/telosb/RpcM.nc"
inline static  unsigned int RpcM$RamSymbolsM_poke(ramSymbol_t *arg_0x4119e3e8){
#line 40
  unsigned int result;
#line 40

#line 40
  result = RamSymbolsM$poke(arg_0x4119e3e8);
#line 40

#line 40
  return result;
#line 40
}
#line 40
# 53 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
static inline  ramSymbol_t RamSymbolsM$peek(unsigned int memAddress, uint8_t length, bool dereference)
#line 53
{
  RamSymbolsM$symbol.memAddress = memAddress;
  RamSymbolsM$symbol.length = length;
  RamSymbolsM$symbol.dereference = dereference;
  if (RamSymbolsM$symbol.length <= MAX_RAM_SYMBOL_SIZE) {
      if (RamSymbolsM$symbol.dereference == TRUE) {
          nmemcpy((void *)RamSymbolsM$symbol.data, * (void **)RamSymbolsM$symbol.memAddress, RamSymbolsM$symbol.length);
        }
      else {
          nmemcpy((void *)RamSymbolsM$symbol.data, (void *)RamSymbolsM$symbol.memAddress, RamSymbolsM$symbol.length);
        }
    }
  return RamSymbolsM$symbol;
}

# 39 "build/telosb/RpcM.nc"
inline static  ramSymbol_t RpcM$RamSymbolsM_peek(unsigned int arg_0x41196bb8, uint8_t arg_0x41196d40, bool arg_0x41196ed0){
#line 39
  struct ramSymbol_t result;
#line 39

#line 39
  result = RamSymbolsM$peek(arg_0x41196bb8, arg_0x41196d40, arg_0x41196ed0);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 568 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool enable)
#line 568
{
  if (enable) {
      if (MultiHopLQI$localBeSink) {
#line 570
        return SUCCESS;
        }
#line 571
      MultiHopLQI$localBeSink = TRUE;

      MultiHopLQI$gbCurrentParent = TOS_UART_ADDR;
      MultiHopLQI$gbCurrentParentCost = 0;
      MultiHopLQI$gbCurrentLinkEst = 0;
      MultiHopLQI$gbLinkQuality = 110;
      MultiHopLQI$gbCurrentHopCount = 0;
      MultiHopLQI$gbCurrentCost = 0;
      MultiHopLQI$fixedParent = FALSE;

      MultiHopLQI$NeighborCtrl$setParent(TOS_UART_ADDR);
    }
  else 
    {
      if (!MultiHopLQI$localBeSink) {
#line 585
        return SUCCESS;
        }
#line 586
      MultiHopLQI$localBeSink = FALSE;
      MultiHopLQI$gbCurrentParentCost = 0x7fff;
      MultiHopLQI$gbCurrentLinkEst = 0x7fff;
      MultiHopLQI$gbLinkQuality = 0;
      MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
      MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
      MultiHopLQI$gbCurrentCost = 0xfffe;
      MultiHopLQI$fixedParent = FALSE;

      MultiHopLQI$NeighborCtrl$setParent(TOS_BCAST_ADDR);
    }

  TOS_post(MultiHopLQI$SendRouteTask);
  return SUCCESS;
}

# 2 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setSink(bool arg_0x41197068){
#line 2
  unsigned char result;
#line 2

#line 2
  result = MultiHopLQI$RouteRpcCtrl$setSink(arg_0x41197068);
#line 2

#line 2
  return result;
#line 2
}
#line 2
# 384 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$setParent(uint16_t parentAddr)
#line 384
{
  MultiHopLQI$fixedParent = TRUE;
  MultiHopLQI$gbCurrentParent = parentAddr;

  MultiHopLQI$NeighborCtrl$setParent(MultiHopLQI$gbCurrentParent);



  return SUCCESS;
}

#line 602
static inline  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t parentAddr)
#line 602
{
  if (parentAddr == TOS_LOCAL_ADDRESS || MultiHopLQI$localBeSink) {
    return FAIL;
    }
#line 605
  return MultiHopLQI$RouteControl$setParent(parentAddr);
}

# 3 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setParent(uint16_t arg_0x41197510){
#line 3
  unsigned char result;
#line 3

#line 3
  result = MultiHopLQI$RouteRpcCtrl$setParent(arg_0x41197510);
#line 3

#line 3
  return result;
#line 3
}
#line 3
# 374 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t Interval)
#line 374
{
  MultiHopLQI$gUpdateInterval = Interval;
  return SUCCESS;
}

#line 614
static inline  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t seconds)
#line 614
{
  if (seconds <= 0 || seconds >= 60) {
    return FAIL;
    }
#line 617
  return MultiHopLQI$RouteControl$setUpdateInterval(seconds);
}

# 5 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x41197cc0){
#line 5
  unsigned char result;
#line 5

#line 5
  result = MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(arg_0x41197cc0);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 395 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$releaseParent(void)
#line 395
{
  if (!MultiHopLQI$fixedParent) {
#line 396
    return FAIL;
    }
#line 397
  MultiHopLQI$fixedParent = FALSE;


  MultiHopLQI$gbCurrentParentCost = 0x7fff;
  MultiHopLQI$gbCurrentLinkEst = 0x7fff;
  MultiHopLQI$gbLinkQuality = 0;
  MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
  MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
  return SUCCESS;
}

#line 608
static inline  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void)
#line 608
{
  if (MultiHopLQI$localBeSink) {
    return FAIL;
    }
#line 611
  return MultiHopLQI$RouteControl$releaseParent();
}

# 4 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$releaseParent(void){
#line 4
  unsigned char result;
#line 4

#line 4
  result = MultiHopLQI$RouteRpcCtrl$releaseParent();
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 620 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void)
#line 620
{
  return MultiHopLQI$gUpdateInterval;
}

# 6 "/home/xu/oasis/lib/MultiHopOasis/RouteRpcCtrl.nc"
inline static  uint16_t RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval(void){
#line 6
  unsigned int result;
#line 6

#line 6
  result = MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 354 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$CC2420Control$SetRFPower(uint8_t power)
#line 354
{
  CC2420ControlM$gCurrentParameters[CP_TXCTRL] = (CC2420ControlM$gCurrentParameters[CP_TXCTRL] & ~(0x1F << 0)) | (power << 0);
  CC2420ControlM$HPLChipcon$write(0x15, CC2420ControlM$gCurrentParameters[CP_TXCTRL]);
  return SUCCESS;
}

# 178 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static  result_t GenericCommProM$CC2420Control$SetRFPower(uint8_t arg_0x40d15950){
#line 178
  unsigned char result;
#line 178

#line 178
  result = CC2420ControlM$CC2420Control$SetRFPower(arg_0x40d15950);
#line 178

#line 178
  return result;
#line 178
}
#line 178
# 744 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$setRFPower(uint8_t level)
#line 744
{
  if (level >= 1 && level <= 31) {
    return GenericCommProM$CC2420Control$SetRFPower(level);
    }
  else {
#line 748
    return FAIL;
    }
}

# 37 "build/telosb/RpcM.nc"
inline static  result_t RpcM$GenericCommProM_setRFPower(uint8_t arg_0x4119f010){
#line 37
  unsigned char result;
#line 37

#line 37
  result = GenericCommProM$setRFPower(arg_0x4119f010);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 264 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t chnl)
#line 264
{
  int fsctrl;
  uint8_t status;

  fsctrl = 357 + 5 * (chnl - 11);
  CC2420ControlM$gCurrentParameters[CP_FSCTRL] = (CC2420ControlM$gCurrentParameters[CP_FSCTRL] & 0xfc00) | (fsctrl << 0);
  status = CC2420ControlM$HPLChipcon$write(0x18, CC2420ControlM$gCurrentParameters[CP_FSCTRL]);


  if (status & (1 << 6)) {
    CC2420ControlM$HPLChipcon$cmd(0x03);
    }
#line 275
  return SUCCESS;
}

# 84 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static  result_t GenericCommProM$CC2420Control$TunePreset(uint8_t arg_0x40d19a30){
#line 84
  unsigned char result;
#line 84

#line 84
  result = CC2420ControlM$CC2420Control$TunePreset(arg_0x40d19a30);
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 737 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$setRFChannel(uint8_t channel)
#line 737
{
  if (channel >= 11 && channel <= 26) {
    return GenericCommProM$CC2420Control$TunePreset(channel);
    }
  else {
#line 741
    return FAIL;
    }
}

# 36 "build/telosb/RpcM.nc"
inline static  result_t RpcM$GenericCommProM_setRFChannel(uint8_t arg_0x411aaa90){
#line 36
  unsigned char result;
#line 36

#line 36
  result = GenericCommProM$setRFChannel(arg_0x411aaa90);
#line 36

#line 36
  return result;
#line 36
}
#line 36
# 364 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  uint8_t CC2420ControlM$CC2420Control$GetRFPower(void)
#line 364
{
  return CC2420ControlM$gCurrentParameters[CP_TXCTRL] & (0x1F << 0);
}

# 185 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static  uint8_t GenericCommProM$CC2420Control$GetRFPower(void){
#line 185
  unsigned char result;
#line 185

#line 185
  result = CC2420ControlM$CC2420Control$GetRFPower();
#line 185

#line 185
  return result;
#line 185
}
#line 185
# 755 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  uint8_t GenericCommProM$getRFPower(void)
#line 755
{
  return GenericCommProM$CC2420Control$GetRFPower();
}

# 35 "build/telosb/RpcM.nc"
inline static  uint8_t RpcM$GenericCommProM_getRFPower(void){
#line 35
  unsigned char result;
#line 35

#line 35
  result = GenericCommProM$getRFPower();
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 310 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  uint8_t CC2420ControlM$CC2420Control$GetPreset(void)
#line 310
{
  uint16_t _freq = CC2420ControlM$gCurrentParameters[CP_FSCTRL] & (0x1FF << 0);

#line 312
  _freq = (_freq - 357) / 5;
  _freq = _freq + 11;
  return _freq;
}

# 106 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static  uint8_t GenericCommProM$CC2420Control$GetPreset(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = CC2420ControlM$CC2420Control$GetPreset();
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 751 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  uint8_t GenericCommProM$getRFChannel(void)
#line 751
{
  return GenericCommProM$CC2420Control$GetPreset();
}

# 34 "build/telosb/RpcM.nc"
inline static  uint8_t RpcM$GenericCommProM_getRFChannel(void){
#line 34
  unsigned char result;
#line 34

#line 34
  result = GenericCommProM$getRFChannel();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 161 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline  result_t EventReportM$EventConfig$setReportLevel(uint8_t type, uint8_t level)
#line 161
{
  int s;

#line 163
  if (EVENT_TYPE_VALUE_MAX < type || EVENT_LEVEL_VALUE_MAX < level) {
    return FALSE;
    }
#line 165
  if (type != EVENT_TYPE_ALL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 166
        EventReportM$gLevelMode[type] = level;
#line 166
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      for (s = 0; s < 6; s++) 
        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 170
          EventReportM$gLevelMode[s] = level;
#line 170
          __nesc_atomic_end(__nesc_atomic); }
    }
  return SUCCESS;
}

# 38 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
inline static  result_t RpcM$EventReportM_EventConfig$setReportLevel(uint8_t arg_0x41143778, uint8_t arg_0x41143900){
#line 38
  unsigned char result;
#line 38

#line 38
  result = EventReportM$EventConfig$setReportLevel(arg_0x41143778, arg_0x41143900);
#line 38

#line 38
  return result;
#line 38
}
#line 38
# 175 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline  uint8_t EventReportM$EventConfig$getReportLevel(uint8_t type)
#line 175
{
  uint8_t level;

#line 177
  if (EVENT_TYPE_VALUE_MAX < type) {
    return FALSE;
    }
#line 179
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 179
    level = EventReportM$gLevelMode[type];
#line 179
    __nesc_atomic_end(__nesc_atomic); }
  return level;
}

# 47 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
inline static  uint8_t RpcM$EventReportM_EventConfig$getReportLevel(uint8_t arg_0x41143ec0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = EventReportM$EventConfig$getReportLevel(arg_0x41143ec0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 106 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  void *RpcM$ResponseSend$getBuffer(TOS_MsgPtr arg_0x40a16f18, uint16_t *arg_0x409fb0e0){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_RPCR, arg_0x40a16f18, arg_0x409fb0e0);
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 145 "build/telosb/RpcM.nc"
static inline  void RpcM$processCommand(void)
#line 145
{

  ApplicationMsg *RecvMsg = (ApplicationMsg *)RpcM$cmdStore.data;
  RpcCommandMsg *msg = (RpcCommandMsg *)RecvMsg->data;

  uint8_t *byteSrc = msg->data;
  uint16_t maxLength;
  uint16_t id = msg->commandID;

  NetworkMsg *NMsg = (NetworkMsg *)RpcM$sendMsgPtr->data;

  ApplicationMsg *AppMsg = (ApplicationMsg *)RpcM$ResponseSend$getBuffer(RpcM$sendMsgPtr, &maxLength);
  RpcResponseMsg *responseMsg = (RpcResponseMsg *)AppMsg->data;

#line 158
  NMsg->qos = 7;
  {
  }
#line 159
  ;





  responseMsg->transactionID = msg->transactionID;
  responseMsg->commandID = msg->commandID;
  responseMsg->sourceAddress = TOS_LOCAL_ADDRESS;
  responseMsg->errorCode = RPC_SUCCESS;
  responseMsg->dataLength = 0;



  if (msg->unix_time != G_Ident.unix_time || msg->user_hash != G_Ident.user_hash) {
      responseMsg->errorCode = RPC_WRONG_XML_FILE;
    }
  else {
#line 175
    if (id < 25 && msg->dataLength != RpcM$args_sizes[id]) {
        responseMsg->errorCode = RPC_GARBAGE_ARGS;
        {
        }
#line 177
        ;
      }
    else {
#line 178
      if (id < 25 && RpcM$return_sizes[id] + sizeof(RpcResponseMsg ) > maxLength) {
          responseMsg->errorCode = RPC_RESPONSE_TOO_LARGE;
          {
          }
#line 180
          ;
        }
      else 
#line 181
        {


          switch (id) {


              case 0: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 190
                  {
                  }
#line 190
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$EventReportM_EventConfig$getReportLevel(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 194
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 196
                  ;
                  {
                  }
#line 197
                  ;
                }
#line 198
              break;


              case 1: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_level;

#line 205
                  {
                  }
#line 205
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_level, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$EventReportM_EventConfig$setReportLevel(RPC_type, RPC_level);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 211
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 213
                  ;
                  {
                  }
#line 214
                  ;
                }
#line 215
              break;


              case 2: {
                  uint8_t RPC_returnVal;

#line 220
                  {
                  }
#line 220
                  ;
                  RPC_returnVal = RpcM$GenericCommProM_getRFChannel();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 223
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 225
                  ;
                  {
                  }
#line 226
                  ;
                }
#line 227
              break;


              case 3: {
                  uint8_t RPC_returnVal;

#line 232
                  {
                  }
#line 232
                  ;
                  RPC_returnVal = RpcM$GenericCommProM_getRFPower();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 235
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 237
                  ;
                  {
                  }
#line 238
                  ;
                }
#line 239
              break;


              case 4: {
                  result_t RPC_returnVal;
                  uint8_t RPC_channel;

#line 245
                  {
                  }
#line 245
                  ;
                  nmemcpy(&RPC_channel, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$GenericCommProM_setRFChannel(RPC_channel);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 249
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 251
                  ;
                  {
                  }
#line 252
                  ;
                }
#line 253
              break;


              case 5: {
                  result_t RPC_returnVal;
                  uint8_t RPC_level;

#line 259
                  {
                  }
#line 259
                  ;
                  nmemcpy(&RPC_level, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$GenericCommProM_setRFPower(RPC_level);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 263
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 265
                  ;
                  {
                  }
#line 266
                  ;
                }
#line 267
              break;


              case 6: {
                  uint16_t RPC_returnVal;

#line 272
                  {
                  }
#line 272
                  ;
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 275
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 277
                  ;
                  {
                  }
#line 278
                  ;
                }
#line 279
              break;


              case 7: {
                  result_t RPC_returnVal;

#line 284
                  {
                  }
#line 284
                  ;
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$releaseParent();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 287
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 289
                  ;
                  {
                  }
#line 290
                  ;
                }
#line 291
              break;


              case 8: {
                  result_t RPC_returnVal;
                  uint16_t RPC_seconds;

#line 297
                  {
                  }
#line 297
                  ;
                  nmemcpy(&RPC_seconds, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(RPC_seconds);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 301
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 303
                  ;
                  {
                  }
#line 304
                  ;
                }
#line 305
              break;


              case 9: {
                  result_t RPC_returnVal;
                  uint16_t RPC_parentAddr;

#line 311
                  {
                  }
#line 311
                  ;
                  nmemcpy(&RPC_parentAddr, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setParent(RPC_parentAddr);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 315
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 317
                  ;
                  {
                  }
#line 318
                  ;
                }
#line 319
              break;


              case 10: {
                  result_t RPC_returnVal;
                  bool RPC_enable;

#line 325
                  {
                  }
#line 325
                  ;
                  nmemcpy(&RPC_enable, byteSrc, sizeof(bool ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setSink(RPC_enable);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 329
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 331
                  ;
                  {
                  }
#line 332
                  ;
                }
#line 333
              break;


              case 11: {
                  ramSymbol_t RPC_returnVal;
                  unsigned int RPC_memAddress;
                  uint8_t RPC_length;
                  bool RPC_dereference;

#line 341
                  {
                  }
#line 341
                  ;
                  nmemcpy(&RPC_memAddress, byteSrc, sizeof(unsigned int ));
                  byteSrc += sizeof(unsigned int );
                  nmemcpy(&RPC_length, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_dereference, byteSrc, sizeof(bool ));
                  RPC_returnVal = RpcM$RamSymbolsM_peek(RPC_memAddress, RPC_length, RPC_dereference);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(ramSymbol_t ));
                  {
                  }
#line 349
                  ;
                  responseMsg->dataLength = sizeof(ramSymbol_t );
                  {
                  }
#line 351
                  ;
                  {
                  }
#line 352
                  ;
                }
#line 353
              break;


              case 12: {
                  unsigned int RPC_returnVal;
                  ramSymbol_t RPC_symbol;

#line 359
                  {
                  }
#line 359
                  ;
                  nmemcpy(&RPC_symbol, byteSrc, sizeof(ramSymbol_t ));
                  RPC_returnVal = RpcM$RamSymbolsM_poke(&RPC_symbol);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(unsigned int ));
                  {
                  }
#line 363
                  ;
                  responseMsg->dataLength = sizeof(unsigned int );
                  {
                  }
#line 365
                  ;
                  {
                  }
#line 366
                  ;
                }
#line 367
              break;


              case 13: {
                  result_t RPC_returnVal;
                  uint8_t RPC_ledColorParam;

#line 373
                  {
                  }
#line 373
                  ;
                  nmemcpy(&RPC_ledColorParam, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SNMSM_ledsOn(RPC_ledColorParam);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 377
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 379
                  ;
                  {
                  }
#line 380
                  ;
                }
#line 381
              break;


              case 14: {
                  {
                  }
#line 385
                  ;
                  RpcM$SNMSM_restart();
                  {
                  }
#line 387
                  ;
                  {
                  }
#line 388
                  ;
                }
#line 389
              break;


              case 15: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 395
                  {
                  }
#line 395
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getADCChannel(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 399
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 401
                  ;
                  {
                  }
#line 402
                  ;
                }
#line 403
              break;


              case 16: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 409
                  {
                  }
#line 409
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getDataPriority(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 413
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 415
                  ;
                  {
                  }
#line 416
                  ;
                }
#line 417
              break;


              case 17: {
                  uint8_t RPC_returnVal;

#line 422
                  {
                  }
#line 422
                  ;
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getNodePriority();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 425
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 427
                  ;
                  {
                  }
#line 428
                  ;
                }
#line 429
              break;


              case 18: {
                  uint16_t RPC_returnVal;
                  uint8_t RPC_type;

#line 435
                  {
                  }
#line 435
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getSamplingRate(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 439
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 441
                  ;
                  {
                  }
#line 442
                  ;
                }
#line 443
              break;


              case 19: {
                  uint16_t RPC_returnVal;
                  uint8_t RPC_type;

#line 449
                  {
                  }
#line 449
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 453
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 455
                  ;
                  {
                  }
#line 456
                  ;
                }
#line 457
              break;


              case 20: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_channel;

#line 464
                  {
                  }
#line 464
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_channel, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setADCChannel(RPC_type, RPC_channel);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 470
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 472
                  ;
                  {
                  }
#line 473
                  ;
                }
#line 474
              break;


              case 21: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_priority;

#line 481
                  {
                  }
#line 481
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_priority, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setDataPriority(RPC_type, RPC_priority);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 487
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 489
                  ;
                  {
                  }
#line 490
                  ;
                }
#line 491
              break;


              case 22: {
                  result_t RPC_returnVal;
                  uint8_t RPC_priority;

#line 497
                  {
                  }
#line 497
                  ;
                  nmemcpy(&RPC_priority, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setNodePriority(RPC_priority);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 501
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 503
                  ;
                  {
                  }
#line 504
                  ;
                }
#line 505
              break;


              case 23: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint16_t RPC_samplingRate;

#line 512
                  {
                  }
#line 512
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_samplingRate, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setSamplingRate(RPC_type, RPC_samplingRate);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 518
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 520
                  ;
                  {
                  }
#line 521
                  ;
                }
#line 522
              break;


              case 24: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint16_t RPC_code;

#line 529
                  {
                  }
#line 529
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_code, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(RPC_type, RPC_code);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 535
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 537
                  ;
                  {
                  }
#line 538
                  ;
                }
#line 539
              break;

              default: 
                {
                }
#line 542
              ;
              responseMsg->errorCode = RPC_PROCEDURE_UNAVAIL;
            }
        }
      }
    }
#line 547
  {
  }
#line 547
  ;
  {
  }
#line 548
  ;


  AppMsg->type = TYPE_SNMS_RPCRESPONSE;
  AppMsg->length = responseMsg->dataLength + (size_t )& ((RpcResponseMsg *)0)->data;
  AppMsg->seqno = RpcM$seqno++;


  ;


  if (msg->responseDesired == 0) {
      {
      }
#line 560
      ;
      RpcM$processingCommand = FALSE;
    }
  else {

      RpcM$processingCommand = FALSE;
      RpcM$tryNextSend();
    }
}

# 79 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline uint8_t HPLCC2420M$adjustStatusByte(uint8_t status)
#line 79
{
  return status & 0x7E;
}

#line 461
static inline  result_t HPLCC2420M$BusArbitration$busFree(void)
#line 461
{
  return SUCCESS;
}

# 125 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static inline   result_t BusArbitrationM$BusArbitration$default$busFree(uint8_t id)
#line 125
{
  return SUCCESS;
}

# 39 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
inline static  result_t BusArbitrationM$BusArbitration$busFree(uint8_t arg_0x40ffcf08){
#line 39
  unsigned char result;
#line 39

#line 39
  switch (arg_0x40ffcf08) {
#line 39
    case 0U:
#line 39
      result = HPLCC2420M$BusArbitration$busFree();
#line 39
      break;
#line 39
    default:
#line 39
      result = BusArbitrationM$BusArbitration$default$busFree(arg_0x40ffcf08);
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
# 42 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static inline  void BusArbitrationM$busReleased(void)
#line 42
{
  uint8_t i;
  uint8_t currentstate;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    BusArbitrationM$isBusReleasedPending = FALSE;
#line 46
    __nesc_atomic_end(__nesc_atomic); }
  for (i = 0; i < 1U; i++) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 48
        currentstate = BusArbitrationM$state;
#line 48
        __nesc_atomic_end(__nesc_atomic); }
      if (currentstate == BusArbitrationM$BUS_IDLE) {
        BusArbitrationM$BusArbitration$busFree(i);
        }
    }
}

# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t MultiHopLQI$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_BEACONMSG, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 13 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_GREEN_LED_PIN(void)
#line 13
{
#line 13
   static volatile uint8_t r __asm ("0x0031");

#line 13
  r |= 1 << 5;
}

# 110 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static inline   result_t LedsC$Leds$greenOff(void)
#line 110
{
  {
  }
#line 111
  ;
  /* atomic removed: atomic calls only */
#line 112
  {
    TOSH_SET_GREEN_LED_PIN();
    LedsC$ledsOn &= ~LedsC$GREEN_BIT;
  }
  return SUCCESS;
}

# 13 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_GREEN_LED_PIN(void)
#line 13
{
#line 13
   static volatile uint8_t r __asm ("0x0031");

#line 13
  r &= ~(1 << 5);
}

# 101 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static inline   result_t LedsC$Leds$greenOn(void)
#line 101
{
  {
  }
#line 102
  ;
  /* atomic removed: atomic calls only */
#line 103
  {
    TOSH_CLR_GREEN_LED_PIN();
    LedsC$ledsOn |= LedsC$GREEN_BIT;
  }
  return SUCCESS;
}

# 14 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SET_YELLOW_LED_PIN(void)
#line 14
{
#line 14
   static volatile uint8_t r __asm ("0x0031");

#line 14
  r |= 1 << 6;
}

# 139 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static inline   result_t LedsC$Leds$yellowOff(void)
#line 139
{
  {
  }
#line 140
  ;
  /* atomic removed: atomic calls only */
#line 141
  {
    TOSH_SET_YELLOW_LED_PIN();
    LedsC$ledsOn &= ~LedsC$YELLOW_BIT;
  }
  return SUCCESS;
}

# 14 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_YELLOW_LED_PIN(void)
#line 14
{
#line 14
   static volatile uint8_t r __asm ("0x0031");

#line 14
  r &= ~(1 << 6);
}

# 130 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static inline   result_t LedsC$Leds$yellowOn(void)
#line 130
{
  {
  }
#line 131
  ;
  /* atomic removed: atomic calls only */
#line 132
  {
    TOSH_CLR_YELLOW_LED_PIN();
    LedsC$ledsOn |= LedsC$YELLOW_BIT;
  }
  return SUCCESS;
}

# 323 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$Timer$stop(uint8_t id)
#line 323
{
  if (id >= NUM_TIMERS) {
      return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 327
    {
      if (RealTimeM$mState & (0x1L << id)) {
          RealTimeM$mState &= ~(0x1L << id);
          {
            unsigned char __nesc_temp = 
#line 330
            SUCCESS;

            {
#line 330
              __nesc_atomic_end(__nesc_atomic); 
#line 330
              return __nesc_temp;
            }
          }
        }
      else 
#line 332
        {
          {
            unsigned char __nesc_temp = 
#line 333
            FAIL;

            {
#line 333
              __nesc_atomic_end(__nesc_atomic); 
#line 333
              return __nesc_temp;
            }
          }
        }
    }
#line 337
    __nesc_atomic_end(__nesc_atomic); }
}

# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t RpcM$ResponseSend$send(TOS_MsgPtr arg_0x40a166c0, uint16_t arg_0x40a16850){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_RPCR, arg_0x40a166c0, arg_0x40a16850);
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 704 "build/telosb/RpcM.nc"
static inline  void RpcM$sendResponse(void)
#line 704
{
  uint16_t maxLength;
  ApplicationMsg *AppMsg = (ApplicationMsg *)RpcM$ResponseSend$getBuffer(RpcM$sendMsgPtr, &maxLength);
  RpcResponseMsg *responseMsg = (RpcResponseMsg *)AppMsg->data;








  if (RpcM$ResponseSend$send(RpcM$sendMsgPtr, 
  responseMsg->dataLength + (size_t )& ((RpcResponseMsg *)0)->data + (size_t )& ((ApplicationMsg *)0)->data)) {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 719
        RpcM$taskBusy = FALSE;
#line 719
        __nesc_atomic_end(__nesc_atomic); }
    }
  else 
    {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 723
        RpcM$taskBusy = FALSE;
#line 723
        __nesc_atomic_end(__nesc_atomic); }
      ;
      RpcM$tryNextSend();
    }
}

# 473 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline result_t DataMgmtM$insertAndStartSend(TOS_MsgPtr msg)
#line 473
{
  result_t result = FALSE;

#line 475
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 475
    {
      result = insertElement(&DataMgmtM$sendQueue, msg);
      DataMgmtM$tryNextSend();
    }
#line 478
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}

# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t TimeSyncM$LocalTime$read(void){
#line 27
  unsigned long result;
#line 27

#line 27
  result = RealTimeM$LocalTime$read();
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 202 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   uint32_t TimeSyncM$GlobalTime$getLocalTime(void)
{



  return TimeSyncM$LocalTime$read();
}


static inline result_t TimeSyncM$is_synced(void)
{
  return TimeSyncM$numEntries >= TimeSyncM$ENTRY_VALID_LIMIT || ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS;
}

# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t TimeSyncM$SendMsg$send(uint16_t arg_0x40baf410, uint8_t arg_0x40baf598, TOS_MsgPtr arg_0x40baf728){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_TIMESYNCMSG, arg_0x40baf410, arg_0x40baf598, arg_0x40baf728);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 470 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$CompareB3$setEventFromNow(uint16_t x)
#line 470
{
#line 470
  MSP430TimerM$TBCCR3 = TBR + x;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void TimerM$AlarmCompare$setEventFromNow(uint16_t arg_0x408d5830){
#line 32
  MSP430TimerM$CompareB3$setEventFromNow(arg_0x408d5830);
#line 32
}
#line 32
# 366 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB3$clearPendingInterrupt(void)
#line 366
{
#line 366
  MSP430TimerM$TBCCTL3 &= ~0x0001;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerM$AlarmControl$clearPendingInterrupt(void){
#line 32
  MSP430TimerM$ControlB3$clearPendingInterrupt();
#line 32
}
#line 32
# 414 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB3$enableEvents(void)
#line 414
{
#line 414
  MSP430TimerM$TBCCTL3 |= 0x0010;
}

# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerM$AlarmControl$enableEvents(void){
#line 38
  MSP430TimerM$ControlB3$enableEvents();
#line 38
}
#line 38
# 202 "/opt/tinyos-1.x/tos/platform/msp430/msp430hardware.h"
static inline void __nesc_enable_interrupt(void)
{
   __asm volatile ("eint");}

#line 226
static inline void __nesc_atomic_end(__nesc_atomic_t reenable_interrupts)
{
  if (reenable_interrupts) {
    __nesc_enable_interrupt();
    }
}

#line 245
static __inline void __nesc_atomic_sleep(void)
#line 245
{








  uint16_t LPMode_bits = 0;

  if (LPMode_disabled) {
      __nesc_enable_interrupt();
      return;
    }
  else 
#line 259
    {
      LPMode_bits = 0x0080 + 0x0040 + 0x0010;



      if ((((
#line 262
      TA0CTL & (3 << 4)) != 0 << 4 && (TA0CTL & (3 << 8)) == 2 << 8)
       || (ME1 & ((1 << 7) | (1 << 6)) && U0TCTL & 0x20))
       || (ME2 & ((1 << 5) | (1 << 4)) && U1TCTL & 0x20)) {






        LPMode_bits = 0x0040 + 0x0010;
        }

      if (ADC12CTL1 & 0x0001) {
          if (!(ADC12CTL0 & 0x0080) && (TA0CTL & (3 << 8)) == 2 << 8) {
            LPMode_bits = 0x0040 + 0x0010;
            }
          else {
#line 278
            switch (ADC12CTL1 & (3 << 3)) {
                case 2 << 3: LPMode_bits = 0;
#line 279
                break;
                case 3 << 3: LPMode_bits = 0x0040 + 0x0010;
#line 280
                break;
              }
            }
        }
      LPMode_bits |= 0x0008;
       __asm volatile ("bis  %0, r2" :  : "m"((uint16_t )LPMode_bits));}
}

#line 196
static inline void __nesc_disable_interrupt(void)
{
   __asm volatile ("dint");
   __asm volatile ("nop");}







static inline bool are_interrupts_enabled(void)
{
  return (({
#line 209
    uint16_t __x;

#line 209
     __asm volatile ("mov	r2, %0" : "=r"((uint16_t )__x));__x;
  }
  )
#line 209
   & 0x0008) != 0;
}








static inline __nesc_atomic_t __nesc_atomic_start(void )
{
  __nesc_atomic_t result = are_interrupts_enabled();

#line 222
  __nesc_disable_interrupt();
  return result;
}

# 136 "/opt/tinyos-1.x/tos/system/sched.c"
static inline bool TOSH_run_next_task(void)
{
  __nesc_atomic_t fInterruptFlags;
  uint8_t old_full;
  void (*func)(void );

  fInterruptFlags = __nesc_atomic_start();
  old_full = TOSH_sched_full;
  func = TOSH_queue[old_full].tp;
  if (func == NULL) 
    {
      __nesc_atomic_sleep();
      return 0;
    }

  TOSH_queue[old_full].tp = NULL;
  TOSH_sched_full = (old_full + 1) & TOSH_TASK_BITMASK;
  __nesc_atomic_end(fInterruptFlags);
  func();

  return 1;
}

static inline void TOSH_run_task(void)
#line 159
{
  for (; ; ) 
    TOSH_run_next_task();
}

# 96 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline MSP430TimerM$CC_t MSP430TimerM$int2CC(uint16_t x)
#line 96
{
#line 96
  union __nesc_unnamed4331 {
#line 96
    uint16_t f;
#line 96
    MSP430TimerM$CC_t t;
  } 
#line 96
  c = { .f = x };

#line 96
  return c.t;
}

#line 205
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA0$getControl(void)
#line 205
{
#line 205
  return MSP430TimerM$int2CC(MSP430TimerM$TA0CCTL0);
}

#line 160
static inline    void MSP430TimerM$CaptureA0$default$captured(uint16_t time)
#line 160
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureA0$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureA0$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 253 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureA0$getEvent(void)
#line 253
{
#line 253
  return MSP430TimerM$TA0CCR0;
}

# 406 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$CompareA0$fired(void)
#line 406
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareA0$fired(void){
#line 34
  MSP430ADC12M$CompareA0$fired();
#line 34
}
#line 34
# 206 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA1$getControl(void)
#line 206
{
#line 206
  return MSP430TimerM$int2CC(MSP430TimerM$TA0CCTL1);
}

#line 161
static inline    void MSP430TimerM$CaptureA1$default$captured(uint16_t time)
#line 161
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureA1$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureA1$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 254 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureA1$getEvent(void)
#line 254
{
#line 254
  return MSP430TimerM$TA0CCR1;
}

# 407 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$CompareA1$fired(void)
#line 407
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareA1$fired(void){
#line 34
  MSP430ADC12M$CompareA1$fired();
#line 34
}
#line 34
# 207 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlA2$getControl(void)
#line 207
{
#line 207
  return MSP430TimerM$int2CC(MSP430TimerM$TA0CCTL2);
}

#line 162
static inline    void MSP430TimerM$CaptureA2$default$captured(uint16_t time)
#line 162
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureA2$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureA2$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 255 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureA2$getEvent(void)
#line 255
{
#line 255
  return MSP430TimerM$TA0CCR2;
}

#line 159
static inline    void MSP430TimerM$CompareA2$default$fired(void)
#line 159
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareA2$fired(void){
#line 34
  MSP430TimerM$CompareA2$default$fired();
#line 34
}
#line 34
# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   uint16_t MSP430DCOCalibM$Timer32khz$read(void){
#line 30
  unsigned int result;
#line 30

#line 30
  result = MSP430TimerM$TimerB$read();
#line 30

#line 30
  return result;
#line 30
}
#line 30
# 41 "/opt/tinyos-1.x/tos/platform/msp430/MSP430DCOCalibM.nc"
static inline   void MSP430DCOCalibM$TimerMicro$overflow(void)
{
  uint16_t now = MSP430DCOCalibM$Timer32khz$read();
  uint16_t delta = now - MSP430DCOCalibM$m_prev;

#line 45
  MSP430DCOCalibM$m_prev = now;

  if (delta > MSP430DCOCalibM$TARGET_DELTA + MSP430DCOCalibM$MAX_DEVIATION) 
    {

      if (DCOCTL < 0xe0) 
        {
          DCOCTL++;
        }
      else {
#line 54
        if ((BCSCTL1 & 7) < 7) 
          {
            BCSCTL1++;
            DCOCTL = 96;
          }
        }
    }
  else {
#line 60
    if (delta < MSP430DCOCalibM$TARGET_DELTA - MSP430DCOCalibM$MAX_DEVIATION) 
      {

        if (DCOCTL > 0) 
          {
            DCOCTL--;
          }
        else {
#line 67
          if ((BCSCTL1 & 7) > 0) 
            {
              BCSCTL1--;
              DCOCTL = 128;
            }
          }
      }
    }
}

# 405 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$TimerA$overflow(void)
#line 405
{
}

# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430TimerM$TimerA$overflow(void){
#line 33
  MSP430ADC12M$TimerA$overflow();
#line 33
  MSP430DCOCalibM$TimerMicro$overflow();
#line 33
}
#line 33
# 347 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB0$getControl(void)
#line 347
{
#line 347
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL0);
}

#line 338
static inline    void MSP430TimerM$CaptureB0$default$captured(uint16_t time)
#line 338
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB0$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB0$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 443 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB0$getEvent(void)
#line 443
{
#line 443
  return MSP430TimerM$TBCCR0;
}

#line 331
static inline    void MSP430TimerM$CompareB0$default$fired(void)
#line 331
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB0$fired(void){
#line 34
  MSP430TimerM$CompareB0$default$fired();
#line 34
}
#line 34
# 348 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB1$getControl(void)
#line 348
{
#line 348
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL1);
}

#line 484
static inline   void MSP430TimerM$CaptureB1$clearOverflow(void)
#line 484
{
#line 484
  MSP430TimerM$TBCCTL1 &= ~0x0002;
}

# 56 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void HPLCC2420InterruptM$SFDCapture$clearOverflow(void){
#line 56
  MSP430TimerM$CaptureB1$clearOverflow();
#line 56
}
#line 56
# 476 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   bool MSP430TimerM$CaptureB1$isOverflowPending(void)
#line 476
{
#line 476
  return MSP430TimerM$TBCCTL1 & 0x0002;
}

# 51 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   bool HPLCC2420InterruptM$SFDCapture$isOverflowPending(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = MSP430TimerM$CaptureB1$isOverflowPending();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 364 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB1$clearPendingInterrupt(void)
#line 364
{
#line 364
  MSP430TimerM$TBCCTL1 &= ~0x0001;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void HPLCC2420InterruptM$SFDControl$clearPendingInterrupt(void){
#line 32
  MSP430TimerM$ControlB1$clearPendingInterrupt();
#line 32
}
#line 32
# 420 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB1$disableEvents(void)
#line 420
{
#line 420
  MSP430TimerM$TBCCTL1 &= ~0x0010;
}

# 39 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void HPLCC2420InterruptM$SFDControl$disableEvents(void){
#line 39
  MSP430TimerM$ControlB1$disableEvents();
#line 39
}
#line 39
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t ClockTimeStampingM$LocalTime$read(void){
#line 27
  unsigned long result;
#line 27

#line 27
  result = RealTimeM$LocalTime$read();
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 123 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
static inline   void ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(uint8_t bitsPerBlock, 
uint8_t offset, 
TOS_MsgPtr msgBuff)
#line 125
{
  /* atomic removed: atomic calls only */
#line 126
  {
    ClockTimeStampingM$rcv_time = ClockTimeStampingM$LocalTime$read();
    ClockTimeStampingM$rcv_message = msgBuff;
  }
  return;
}

# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
inline static   void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658){
#line 33
  ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(arg_0x40d91340, arg_0x40d914c8, arg_0x40d91658);
#line 33
}
#line 33
# 144 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static __inline result_t CC2420RadioM$setAckTimer(uint16_t jiffy)
#line 144
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_ACK;
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t CC2420RadioM$SFD$enableCapture(bool arg_0x40dbe808){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$SFD$enableCapture(arg_0x40dbe808);
#line 43

#line 43
  return result;
#line 43
}
#line 43
#line 60
inline static   result_t CC2420RadioM$SFD$disable(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HPLCC2420InterruptM$SFD$disable();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t ClockTimeStampingM$HPLCC2420RAM$write(uint16_t arg_0x40e23d00, uint8_t arg_0x40e23e88, uint8_t *arg_0x40e22068){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420RAM$write(arg_0x40e23d00, arg_0x40e23e88, arg_0x40e22068);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 58 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
static inline   void ClockTimeStampingM$RadioSendCoordinator$startSymbol(uint8_t bitsPerBlock, 
uint8_t offset, 
TOS_MsgPtr msgBuff)
#line 60
{
  uint32_t send_time;


  TimeSyncMsg *newMessage = (TimeSyncMsg *)msgBuff->data;




  if (msgBuff->type != AM_TIMESYNCMSG) {
      return;
    }






  if (newMessage->wroteStamp == SUCCESS) {

      return;
    }
  /* atomic removed: atomic calls only */
  send_time = ClockTimeStampingM$LocalTime$read() - ClockTimeStampingM$SEND_TIME_CORRECTION;




  newMessage->sendingTime += send_time;
  newMessage->wroteStamp = SUCCESS;








  ClockTimeStampingM$HPLCC2420RAM$write(ClockTimeStampingM$TX_FIFO_MSG_START + 
  (size_t )& ((TimeSyncMsg *)0)->wroteStamp, 
  TIMESYNC_LENGTH_SENDFIELDS, 
  (void *)(msgBuff->data + 
  (size_t )& ((TimeSyncMsg *)0)->wroteStamp));
  return;
}

# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
inline static   void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40d91340, uint8_t arg_0x40d914c8, TOS_MsgPtr arg_0x40d91658){
#line 33
  ClockTimeStampingM$RadioSendCoordinator$startSymbol(arg_0x40d91340, arg_0x40d914c8, arg_0x40d91658);
#line 33
}
#line 33
# 29 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline uint8_t TOSH_READ_CC_SFD_PIN(void)
#line 29
{
#line 29
   static volatile uint8_t r __asm ("0x001C");

#line 29
  return r & (1 << 1);
}

# 344 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$SFD$captured(uint16_t time)
#line 344
{
  switch (CC2420RadioM$stateRadio) {
      case CC2420RadioM$TX_STATE: 

        CC2420RadioM$SFD$enableCapture(FALSE);


      if (!TOSH_READ_CC_SFD_PIN()) {
          CC2420RadioM$SFD$disable();
        }
      else {
          CC2420RadioM$stateRadio = CC2420RadioM$TX_WAIT;
        }

      CC2420RadioM$txbufptr->time = time;
      CC2420RadioM$RadioSendCoordinator$startSymbol(8, 0, CC2420RadioM$txbufptr);


      if (CC2420RadioM$stateRadio == CC2420RadioM$TX_WAIT) {
          break;
        }
      case CC2420RadioM$TX_WAIT: 

        CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_STATE;
      CC2420RadioM$SFD$disable();

      CC2420RadioM$SFD$enableCapture(TRUE);

      if (CC2420RadioM$bAckEnable && CC2420RadioM$txbufptr->addr != TOS_BCAST_ADDR) {
          if (!CC2420RadioM$setAckTimer(75)) {
            CC2420RadioM$sendFailed();
            }
        }
      else {
          if (!TOS_post(CC2420RadioM$PacketSent)) {
            CC2420RadioM$sendFailed();
            }
        }
#line 381
      break;
      default: 

        CC2420RadioM$rxbufptr->time = time;
      CC2420RadioM$RadioReceiveCoordinator$startSymbol(8, 0, CC2420RadioM$rxbufptr);
    }
  return SUCCESS;
}

# 53 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t HPLCC2420InterruptM$SFD$captured(uint16_t arg_0x40dbedc8){
#line 53
  unsigned char result;
#line 53

#line 53
  result = CC2420RadioM$SFD$captured(arg_0x40dbedc8);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 209 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline   void HPLCC2420InterruptM$SFDCapture$captured(uint16_t time)
#line 209
{
  result_t val = SUCCESS;

#line 211
  HPLCC2420InterruptM$SFDControl$clearPendingInterrupt();
  val = HPLCC2420InterruptM$SFD$captured(time);
  if (val == FAIL) {
      HPLCC2420InterruptM$SFDControl$disableEvents();
      HPLCC2420InterruptM$SFDControl$clearPendingInterrupt();
    }
  else {
      if (HPLCC2420InterruptM$SFDCapture$isOverflowPending()) {
        HPLCC2420InterruptM$SFDCapture$clearOverflow();
        }
    }
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB1$captured(uint16_t arg_0x408cb858){
#line 74
  HPLCC2420InterruptM$SFDCapture$captured(arg_0x408cb858);
#line 74
}
#line 74
# 29 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_CC_SFD_MODFUNC(void)
#line 29
{
#line 29
   static volatile uint8_t r __asm ("0x001F");

#line 29
  r |= 1 << 1;
}

# 110 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline uint16_t MSP430TimerM$captureControl(uint8_t l_cm)
{
  MSP430TimerM$CC_t x = { 
  .cm = l_cm & 0x03, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 1, 
  .scs = 1, 
  .ccie = 0 };

  return MSP430TimerM$CC2int(x);
}

#line 388
static inline   void MSP430TimerM$ControlB1$setControlAsCapture(uint8_t cm)
#line 388
{
#line 388
  MSP430TimerM$TBCCTL1 = MSP430TimerM$captureControl(cm);
}

# 36 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void HPLCC2420InterruptM$SFDControl$setControlAsCapture(bool arg_0x408c0190){
#line 36
  MSP430TimerM$ControlB1$setControlAsCapture(arg_0x408c0190);
#line 36
}
#line 36
# 412 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB1$enableEvents(void)
#line 412
{
#line 412
  MSP430TimerM$TBCCTL1 |= 0x0010;
}

# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void HPLCC2420InterruptM$SFDControl$enableEvents(void){
#line 38
  MSP430TimerM$ControlB1$enableEvents();
#line 38
}
#line 38
# 29 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_SEL_CC_SFD_IOFUNC(void)
#line 29
{
#line 29
   static volatile uint8_t r __asm ("0x001F");

#line 29
  r &= ~(1 << 1);
}

# 441 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t addr, uint8_t length, uint8_t *buffer)
#line 441
{
  return SUCCESS;
}

# 165 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
static inline   result_t ClockTimeStampingM$HPLCC2420RAM$writeDone(uint16_t addr, 
uint8_t length, 
uint8_t *buffer)
#line 167
{
  return SUCCESS;
}

# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0x40e225a0, uint8_t arg_0x40e22728, uint8_t *arg_0x40e228d0){
#line 49
  unsigned char result;
#line 49

#line 49
  result = ClockTimeStampingM$HPLCC2420RAM$writeDone(arg_0x40e225a0, arg_0x40e22728, arg_0x40e228d0);
#line 49
  result = rcombine(result, CC2420ControlM$HPLChipconRAM$writeDone(arg_0x40e225a0, arg_0x40e22728, arg_0x40e228d0));
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 288 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline  void HPLCC2420M$signalRAMWr(void)
#line 288
{
  HPLCC2420M$HPLCC2420RAM$writeDone(HPLCC2420M$ramaddr, HPLCC2420M$ramlen, HPLCC2420M$rambuf);
}

# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t GenericCommProM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = LedsC$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 392 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$RadioSend$sendDone(TOS_MsgPtr msg, result_t status)
#line 392
{
  GenericCommProM$radioSendActive = TRUE;
  GenericCommProM$Leds$greenToggle();
  return GenericCommProM$reportSendDone(msg, status);
}

# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0x40d01e48, result_t arg_0x40d00010){
#line 67
  unsigned char result;
#line 67

#line 67
  result = GenericCommProM$RadioSend$sendDone(arg_0x40d01e48, arg_0x40d00010);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 444 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB1$getEvent(void)
#line 444
{
#line 444
  return MSP430TimerM$TBCCR1;
}

#line 332
static inline    void MSP430TimerM$CompareB1$default$fired(void)
#line 332
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB1$fired(void){
#line 34
  MSP430TimerM$CompareB1$default$fired();
#line 34
}
#line 34
# 349 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB2$getControl(void)
#line 349
{
#line 349
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL2);
}

#line 340
static inline    void MSP430TimerM$CaptureB2$default$captured(uint16_t time)
#line 340
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB2$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB2$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 445 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB2$getEvent(void)
#line 445
{
#line 445
  return MSP430TimerM$TBCCR2;
}

#line 333
static inline    void MSP430TimerM$CompareB2$default$fired(void)
#line 333
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB2$fired(void){
#line 34
  MSP430TimerM$CompareB2$default$fired();
#line 34
}
#line 34
# 350 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB3$getControl(void)
#line 350
{
#line 350
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL3);
}

#line 341
static inline    void MSP430TimerM$CaptureB3$default$captured(uint16_t time)
#line 341
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB3$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB3$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 446 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB3$getEvent(void)
#line 446
{
#line 446
  return MSP430TimerM$TBCCR3;
}

# 308 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline   void TimerM$AlarmCompare$fired(void)
{
  TimerM$post_checkShortTimers();
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB3$fired(void){
#line 34
  TimerM$AlarmCompare$fired();
#line 34
}
#line 34
# 351 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB4$getControl(void)
#line 351
{
#line 351
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL4);
}

#line 342
static inline    void MSP430TimerM$CaptureB4$default$captured(uint16_t time)
#line 342
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB4$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB4$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 447 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB4$getEvent(void)
#line 447
{
#line 447
  return MSP430TimerM$TBCCR4;
}

#line 415
static inline   void MSP430TimerM$ControlB4$enableEvents(void)
#line 415
{
#line 415
  MSP430TimerM$TBCCTL4 |= 0x0010;
}

# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerJiffyAsyncM$AlarmControl$enableEvents(void){
#line 38
  MSP430TimerM$ControlB4$enableEvents();
#line 38
}
#line 38
# 367 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlB4$clearPendingInterrupt(void)
#line 367
{
#line 367
  MSP430TimerM$TBCCTL4 &= ~0x0001;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void TimerJiffyAsyncM$AlarmControl$clearPendingInterrupt(void){
#line 32
  MSP430TimerM$ControlB4$clearPendingInterrupt();
#line 32
}
#line 32
# 471 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$CompareB4$setEventFromNow(uint16_t x)
#line 471
{
#line 471
  MSP430TimerM$TBCCR4 = TBR + x;
}

# 32 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void TimerJiffyAsyncM$AlarmCompare$setEventFromNow(uint16_t arg_0x408d5830){
#line 32
  MSP430TimerM$CompareB4$setEventFromNow(arg_0x408d5830);
#line 32
}
#line 32
# 449 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$BackoffTimerJiffy$fired(void)
#line 449
{
  uint8_t currentstate;

  /* atomic removed: atomic calls only */
#line 451
  currentstate = CC2420RadioM$stateRadio;

  switch (CC2420RadioM$stateTimer) {
      case CC2420RadioM$TIMER_INITIAL: 
        if (!TOS_post(CC2420RadioM$startSend)) {
            CC2420RadioM$sendFailed();
          }
      break;
      case CC2420RadioM$TIMER_BACKOFF: 
        CC2420RadioM$tryToSend();
      break;
      case CC2420RadioM$TIMER_ACK: 
        if (currentstate == CC2420RadioM$POST_TX_STATE) {
            /* atomic removed: atomic calls only */




            {
              CC2420RadioM$txbufptr->ack = 0;
              CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_ACK_STATE;
            }
            if (!TOS_post(CC2420RadioM$PacketSent)) {
              CC2420RadioM$sendFailed();
              }
          }
#line 476
      break;
    }
  return SUCCESS;
}

# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t TimerJiffyAsyncM$TimerJiffyAsync$fired(void){
#line 12
  unsigned char result;
#line 12

#line 12
  result = CC2420RadioM$BackoffTimerJiffy$fired();
#line 12

#line 12
  return result;
#line 12
}
#line 12
# 41 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static inline   void TimerJiffyAsyncM$AlarmCompare$fired(void)
{
  if (TimerJiffyAsyncM$jiffy < 0xFFFF) {
      TimerJiffyAsyncM$AlarmControl$disableEvents();
      TimerJiffyAsyncM$bSet = FALSE;
      TimerJiffyAsyncM$TimerJiffyAsync$fired();
    }
  else {
      TimerJiffyAsyncM$jiffy = TimerJiffyAsyncM$jiffy - 0xFFFF;
      if (TimerJiffyAsyncM$jiffy > 0xFFFF) {
        TimerJiffyAsyncM$AlarmCompare$setEventFromNow(0xFFFF);
        }
      else 
#line 52
        {
          /* atomic removed: atomic calls only */
#line 53
          {




            if (TimerJiffyAsyncM$jiffy > 2) {
              TimerJiffyAsyncM$AlarmCompare$setEventFromNow(TimerJiffyAsyncM$jiffy);
              }
            else {
#line 61
              TimerJiffyAsyncM$AlarmCompare$setEventFromNow(2);
              }
          }
        }
      TimerJiffyAsyncM$AlarmControl$clearPendingInterrupt();
      TimerJiffyAsyncM$AlarmControl$enableEvents();
    }
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB4$fired(void){
#line 34
  TimerJiffyAsyncM$AlarmCompare$fired();
#line 34
}
#line 34
# 721 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t length, uint8_t *data)
#line 721
{
  CC2420RadioM$tryToSend();
  return SUCCESS;
}

# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t HPLCC2420M$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0x40dcddb0, uint8_t *arg_0x40dcc010){
#line 50
  unsigned char result;
#line 50

#line 50
  result = CC2420RadioM$HPLChipconFIFO$TXFIFODone(arg_0x40dcddb0, arg_0x40dcc010);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 394 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline  void HPLCC2420M$signalTXFIFO(void)
#line 394
{
  uint8_t _txlen;
  uint8_t *_txbuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 398
    {
      _txlen = HPLCC2420M$txlen;
      _txbuf = HPLCC2420M$txbuf;
      HPLCC2420M$f.txbufBusy = FALSE;
    }
#line 402
    __nesc_atomic_end(__nesc_atomic); }

  HPLCC2420M$HPLCC2420FIFO$TXFIFODone(_txlen, _txbuf);
}

# 38 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
inline static   result_t HPLCC2420M$BusArbitration$releaseBus(void){
#line 38
  unsigned char result;
#line 38

#line 38
  result = BusArbitrationM$BusArbitration$releaseBus(0U);
#line 38

#line 38
  return result;
#line 38
}
#line 38
# 432 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   result_t HPLUSART0M$USARTControl$isTxEmpty(void)
#line 432
{
  if (HPLUSART0M$U0TCTL & 0x01) {
      return SUCCESS;
    }
  return FAIL;
}

# 191 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLCC2420M$USARTControl$isTxEmpty(void){
#line 191
  unsigned char result;
#line 191

#line 191
  result = HPLUSART0M$USARTControl$isTxEmpty();
#line 191

#line 191
  return result;
#line 191
}
#line 191
#line 180
inline static   result_t HPLCC2420M$USARTControl$isTxIntrPending(void){
#line 180
  unsigned char result;
#line 180

#line 180
  result = HPLUSART0M$USARTControl$isTxIntrPending();
#line 180

#line 180
  return result;
#line 180
}
#line 180
# 473 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline   result_t HPLUSART0M$USARTControl$tx(uint8_t data)
#line 473
{
  HPLUSART0M$U0TXBUF = data;
  return SUCCESS;
}

# 202 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLCC2420M$USARTControl$tx(uint8_t arg_0x40e95850){
#line 202
  unsigned char result;
#line 202

#line 202
  result = HPLUSART0M$USARTControl$tx(arg_0x40e95850);
#line 202

#line 202
  return result;
#line 202
}
#line 202







inline static   uint8_t HPLCC2420M$USARTControl$rx(void){
#line 209
  unsigned char result;
#line 209

#line 209
  result = HPLUSART0M$USARTControl$rx();
#line 209

#line 209
  return result;
#line 209
}
#line 209
# 17 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline void TOSH_CLR_RADIO_CSN_PIN(void)
#line 17
{
#line 17
   static volatile uint8_t r __asm ("0x001D");

#line 17
  r &= ~(1 << 2);
}

# 37 "/opt/tinyos-1.x/tos/platform/telos/BusArbitration.nc"
inline static   result_t HPLCC2420M$BusArbitration$getBus(void){
#line 37
  unsigned char result;
#line 37

#line 37
  result = BusArbitrationM$BusArbitration$getBus(0U);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 415 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t length, uint8_t *data)
#line 415
{
  uint8_t i = 0;
  bool returnFail = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 419
    {
      if (HPLCC2420M$f.txbufBusy) {
        returnFail = TRUE;
        }
      else {
#line 423
        HPLCC2420M$f.txbufBusy = TRUE;
        }
    }
#line 425
    __nesc_atomic_end(__nesc_atomic); }
  if (returnFail) {
    return FAIL;
    }
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 430
        {
          HPLCC2420M$f.busy = TRUE;
          HPLCC2420M$txlen = length;
          HPLCC2420M$txbuf = data;
        }
#line 434
        __nesc_atomic_end(__nesc_atomic); }
      TOSH_CLR_RADIO_CSN_PIN();

      HPLCC2420M$USARTControl$isTxIntrPending();
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx(0x3E);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
      for (i = 0; i < HPLCC2420M$txlen; i++) {
          HPLCC2420M$USARTControl$tx(HPLCC2420M$txbuf[i]);
          while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
        }
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxEmpty()) ;
      TOSH_SET_RADIO_CSN_PIN();
      HPLCC2420M$BusArbitration$releaseBus();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 448
        HPLCC2420M$f.busy = FALSE;
#line 448
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 451
        HPLCC2420M$f.txbufBusy = FALSE;
#line 451
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  if (TOS_post(HPLCC2420M$signalTXFIFO) == FAIL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 455
        HPLCC2420M$f.txbufBusy = FALSE;
#line 455
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  return SUCCESS;
}

# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0x40d9cec0, uint8_t *arg_0x40dcd088){
#line 29
  unsigned char result;
#line 29

#line 29
  result = HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(arg_0x40d9cec0, arg_0x40dcd088);
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0x40da30b0){
#line 61
  unsigned int result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0x40da30b0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 222 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port10$edge(bool l2h)
#line 222
{
  /* atomic removed: atomic calls only */
#line 223
  {
    if (l2h) {
#line 224
      P1IES &= ~(1 << 0);
      }
    else {
#line 225
      P1IES |= 1 << 0;
      }
  }
}

# 54 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOPInterrupt$edge(bool arg_0x40f36350){
#line 54
  MSP430InterruptM$Port10$edge(arg_0x40f36350);
#line 54
}
#line 54
# 115 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port10$enable(void)
#line 115
{
#line 115
  MSP430InterruptM$P1IE |= 1 << 0;
}

# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOPInterrupt$enable(void){
#line 30
  MSP430InterruptM$Port10$enable();
#line 30
}
#line 30
# 25 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline uint8_t TOSH_READ_RADIO_CCA_PIN(void)
#line 25
{
#line 25
   static volatile uint8_t r __asm ("0x0020");

#line 25
  return r & (1 << 4);
}

# 751 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline    int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr m)
#line 751
{
  return (CC2420RadioM$Random$rand() & 0x3F) + 1;
}

# 75 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
inline static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0x40d99e78){
#line 75
  int result;
#line 75

#line 75
  result = CC2420RadioM$MacBackoff$default$congestionBackoff(arg_0x40d99e78);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 136 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static __inline result_t CC2420RadioM$setBackoffTimer(uint16_t jiffy)
#line 136
{
  CC2420RadioM$stateTimer = CC2420RadioM$TIMER_BACKOFF;
  if (jiffy == 0) {

    return CC2420RadioM$BackoffTimerJiffy$setOneShot(2);
    }
#line 141
  return CC2420RadioM$BackoffTimerJiffy$setOneShot(jiffy);
}

# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0x40da54b0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0x40da54b0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 321 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline void CC2420RadioM$sendPacket(void)
#line 321
{
  uint8_t status;

  CC2420RadioM$HPLChipcon$cmd(0x05);
  status = CC2420RadioM$HPLChipcon$cmd(0x00);
  if ((status >> 3) & 0x01) {

      CC2420RadioM$SFD$enableCapture(TRUE);
    }
  else {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 332
        CC2420RadioM$stateRadio = CC2420RadioM$PRE_TX_STATE;
#line 332
        __nesc_atomic_end(__nesc_atomic); }
      if (!CC2420RadioM$setBackoffTimer(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10)) {
          CC2420RadioM$sendFailed();
        }
    }
}

# 352 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB5$getControl(void)
#line 352
{
#line 352
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL5);
}

#line 343
static inline    void MSP430TimerM$CaptureB5$default$captured(uint16_t time)
#line 343
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB5$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB5$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 448 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB5$getEvent(void)
#line 448
{
#line 448
  return MSP430TimerM$TBCCR5;
}

# 342 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline void RealTimeM$enqueue(uint8_t value)
#line 342
{
  if (RealTimeM$queue_tail == NUM_TIMERS - 1) {
      RealTimeM$queue_tail = -1;
    }
  RealTimeM$queue_tail++;
  RealTimeM$queue_size++;
  RealTimeM$queue[(uint8_t )RealTimeM$queue_tail] = value;
}

# 43 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
inline static   result_t RealTimeM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b50150){
#line 43
  unsigned char result;
#line 43

#line 43
  result = TimeSyncM$GlobalTime$getGlobalTime(arg_0x40b50150);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 387 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline  void RealTimeM$updateTimer(void)
#line 387
{
  int32_t i = 0;





  if (RealTimeM$syncMode == FTSP_SYNC) {
      RealTimeM$GlobalTime$getGlobalTime(&RealTimeM$globaltime_t);
      RealTimeM$globaltime_t = RealTimeM$globaltime_t % HOUR_END;
    }





  if (RealTimeM$mState) {
      for (i = 0; i < RealTimeM$numClients; i++) {
          if (RealTimeM$mState & (0x1L << RealTimeM$clientList[i].id)) {
              if (RealTimeM$clientList[i].fireCount <= RealTimeM$globaltime_t && RealTimeM$globaltime_t - RealTimeM$clientList[i].fireCount < HOUR_END >> 1) {
                  if (TRUE != RealTimeM$taskBusy) {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 408
                        RealTimeM$taskBusy = TOS_post(RealTimeM$signalOneTimer);
#line 408
                        __nesc_atomic_end(__nesc_atomic); }
                    }
                  if (RealTimeM$clientList[i].type == TIMER_REPEAT) {
                      do {
                          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 412
                            RealTimeM$clientList[i].fireCount += RealTimeM$clientList[i].syncInterval;
#line 412
                            __nesc_atomic_end(__nesc_atomic); }
                        }
                      while (
#line 413
                      RealTimeM$clientList[i].fireCount <= RealTimeM$globaltime_t);

                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 415
                        RealTimeM$clientList[i].fireCount %= HOUR_END;
#line 415
                        __nesc_atomic_end(__nesc_atomic); }
                    }
                  else 
#line 416
                    {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 417
                        RealTimeM$mState &= ~(0x1L << RealTimeM$clientList[i].id);
#line 417
                        __nesc_atomic_end(__nesc_atomic); }
                    }
                  RealTimeM$enqueue(RealTimeM$clientList[i].id);
                }
            }
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 424
    RealTimeM$timerBusy = FALSE;
#line 424
    __nesc_atomic_end(__nesc_atomic); }
}










static inline   void RealTimeM$MSP430Compare$fired(void)
#line 436
{

  /* atomic removed: atomic calls only */
  {
    RealTimeM$MSP430Compare$setEventFromNow(66);
    RealTimeM$MSP430TimerControl$clearPendingInterrupt();
    RealTimeM$MSP430TimerControl$enableEvents();
    ++RealTimeM$localTime;
  }

  if (RealTimeM$localTime >= DAY_END) {
      RealTimeM$localTime -= DAY_END;
    }

  if (RealTimeM$timerBusy == FALSE) {

      if (TOS_post(RealTimeM$updateTimer) == SUCCESS) {
        RealTimeM$timerBusy = TRUE;
        }
    }
  return;
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB5$fired(void){
#line 34
  RealTimeM$MSP430Compare$fired();
#line 34
}
#line 34
# 354 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline uint8_t RealTimeM$dequeue(void)
#line 354
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 355
    {
      if (RealTimeM$queue_size == 0) {
          {
            unsigned char __nesc_temp = 
#line 357
            NUM_TIMERS;

            {
#line 357
              __nesc_atomic_end(__nesc_atomic); 
#line 357
              return __nesc_temp;
            }
          }
        }
      else 
#line 359
        {
          if (RealTimeM$queue_head == NUM_TIMERS - 1) {
              RealTimeM$queue_head = -1;
            }
          RealTimeM$queue_head++;
          RealTimeM$queue_size--;
          {
            unsigned char __nesc_temp = 
#line 365
            RealTimeM$queue[(uint8_t )RealTimeM$queue_head];

            {
#line 365
              __nesc_atomic_end(__nesc_atomic); 
#line 365
              return __nesc_temp;
            }
          }
        }
    }
#line 369
    __nesc_atomic_end(__nesc_atomic); }
}

# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t ADCM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = LedsC$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
# 182 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static inline   result_t ADCM$ADC$getData(uint8_t port)
{

  bool oldBusy;

#line 186
  if (port >= ADCM$TOSH_ADC_PORTMAPSIZE) {
    return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 189
    {
      oldBusy = ADCM$busy;
      ADCM$busy = TRUE;
    }
#line 192
    __nesc_atomic_end(__nesc_atomic); }

  ADCM$adc_count[port] += 1;

  if (port == 0) {
      if (TOS_post(ADCM$readADCTask) == FAIL) {
        ADCM$Leds$yellowToggle();
        }
    }
  else {
#line 199
    if (port == 1) {
        if (TOS_post(ADCM$readLightTask) == FAIL) {
          ADCM$Leds$yellowToggle();
          }
      }
    }
#line 204
  return SUCCESS;
}

# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t SmartSensingM$ADC$getData(uint8_t arg_0x40a7cd80){
#line 52
  unsigned char result;
#line 52

#line 52
  result = ADCM$ADC$getData(arg_0x40a7cd80);
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 39 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  uint32_t SmartSensingM$RealTime$getTimeCount(void){
#line 39
  unsigned long result;
#line 39

#line 39
  result = RealTimeM$RealTime$getTimeCount();
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 861 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline bool SmartSensingM$needSample(uint8_t client)
#line 861
{
  SenBlkPtr p = NULL;

#line 863
  if (0 != sensor[client].samplingRate) {
      sensor[client].timerCount += SmartSensingM$timerInterval;
      if (sensor[client].timerCount >= sensor[client].samplingRate) {
          sensor[client].timerCount = 0;
        }
      else {
          return FALSE;
        }
    }
  else {
      return FALSE;
    }

  if (NULL != (p = sensor[client].curBlkPtr)) {

      if (0 == p->time) {
          p->time = SmartSensingM$RealTime$getTimeCount();
          p->interval = sensor[client].samplingRate;
          p->type = sensor[client].type;
        }

      return TRUE;
    }
  else {
      if (NULL != (sensor[client].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(client))) {
          p = sensor[client].curBlkPtr;

          p->time = SmartSensingM$RealTime$getTimeCount();
          p->interval = sensor[client].samplingRate;
          p->type = sensor[client].type;

          return TRUE;
        }
      else {
          ;

          return FALSE;
        }
    }
}






static inline void SmartSensingM$trySample(void)
#line 909
{
  uint8_t client;

#line 911
  for (client = 0; client < sensor_num; client++) {
      if (FALSE != SmartSensingM$needSample(client)) {
          SmartSensingM$ADC$getData((uint8_t )client);
        }
    }
  return;
}

#line 620
static inline  result_t SmartSensingM$SensingTimer$fired(void)
#line 620
{

  if (TRUE != SmartSensingM$initedClock) {
      SmartSensingM$initedClock = TRUE;

      SmartSensingM$SensingTimer$start(TIMER_REPEAT, SmartSensingM$timerInterval);
    }
  else {

      SmartSensingM$trySample();
    }
  return SUCCESS;
}

# 508 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline   result_t RealTimeM$Timer$default$fired(uint8_t id)
#line 508
{
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t RealTimeM$Timer$fired(uint8_t arg_0x40b35650){
#line 73
  unsigned char result;
#line 73

#line 73
  switch (arg_0x40b35650) {
#line 73
    case 0U:
#line 73
      result = SmartSensingM$SensingTimer$fired();
#line 73
      break;
#line 73
    default:
#line 73
      result = RealTimeM$Timer$default$fired(arg_0x40b35650);
#line 73
      break;
#line 73
    }
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 89 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline void MSP430ADC12M$configureAdcPin(uint8_t inputChannel)
{
  if (inputChannel <= 7) {
      P6SEL |= 1 << inputChannel;
      P6DIR &= ~(1 << inputChannel);
    }
}

static inline  result_t MSP430ADC12M$ADCSingle$bind(uint8_t num, MSP430ADC12Settings_t settings)
{
  result_t res = FAIL;
  adc12memctl_t memctl = { .inch = settings.inputChannel, 
  .sref = settings.referenceVoltage, 
  .eos = 0 };

  if (num >= 5U) {
    return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      if (MSP430ADC12M$cmode == ADC_IDLE || MSP430ADC12M$owner != num) {
          MSP430ADC12M$configureAdcPin(settings.inputChannel);
          MSP430ADC12M$adc12settings[num].refVolt2_5 = settings.refVolt2_5;
          MSP430ADC12M$adc12settings[num].gotRefVolt = 0;
          MSP430ADC12M$adc12settings[num].clockSourceSHT = settings.clockSourceSHT;
          MSP430ADC12M$adc12settings[num].clockSourceSAMPCON = settings.clockSourceSAMPCON;
          MSP430ADC12M$adc12settings[num].clockDivSAMPCON = settings.clockDivSAMPCON;
          MSP430ADC12M$adc12settings[num].clockDivSHT = settings.clockDivSHT;
          MSP430ADC12M$adc12settings[num].sampleHoldTime = settings.sampleHoldTime;
          MSP430ADC12M$adc12settings[num].memctl = memctl;
          res = SUCCESS;
        }
    }
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  return res;
}

# 50 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
inline static  result_t ADCM$MSP430ADC12Single$bind(MSP430ADC12Settings_t arg_0x4133e958){
#line 50
  unsigned char result;
#line 50

#line 50
  result = MSP430ADC12M$ADCSingle$bind(0U, arg_0x4133e958);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 340 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   msp430ADCresult_t MSP430ADC12M$ADCSingle$getData(uint8_t num)
{
  return MSP430ADC12M$newRequest(SINGLE_CHANNEL, num, 0, 1, 0);
}

# 65 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
inline static   msp430ADCresult_t ADCM$MSP430ADC12Single$getData(void){
#line 65
  enum __nesc_unnamed4259 result;
#line 65

#line 65
  result = MSP430ADC12M$ADCSingle$getData(0U);
#line 65

#line 65
  return result;
#line 65
}
#line 65
# 240 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline   RefVolt_t RefVoltM$RefVolt$getState(void)
#line 240
{
  if (RefVoltM$state == RefVoltM$REFERENCE_2_5V_STABLE) {
    return REFERENCE_2_5V;
    }
#line 243
  if (RefVoltM$state == RefVoltM$REFERENCE_1_5V_STABLE) {
    return REFERENCE_1_5V;
    }
#line 245
  return REFERENCE_UNSTABLE;
}

# 118 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
inline static   RefVolt_t MSP430ADC12M$RefVolt$getState(void){
#line 118
  enum __nesc_unnamed4305 result;
#line 118

#line 118
  result = RefVoltM$RefVolt$getState();
#line 118

#line 118
  return result;
#line 118
}
#line 118
#line 93
inline static   result_t MSP430ADC12M$RefVolt$get(RefVolt_t arg_0x413e2cf8){
#line 93
  unsigned char result;
#line 93

#line 93
  result = RefVoltM$RefVolt$get(arg_0x413e2cf8);
#line 93

#line 93
  return result;
#line 93
}
#line 93
# 130 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline msp430ADCresult_t MSP430ADC12M$getRefVolt(uint8_t num)
{
  msp430ADCresult_t adcResult = MSP430ADC12_SUCCESS;
  result_t vrefResult;
  adc12memctl_t memctl = MSP430ADC12M$adc12settings[num].memctl;

  if (memctl.sref == REFERENCE_VREFplus_AVss || 
  memctl.sref == REFERENCE_VREFplus_VREFnegterm) 
    {
      if (MSP430ADC12M$adc12settings[num].gotRefVolt == 0) {
          if (MSP430ADC12M$adc12settings[num].refVolt2_5) {
            vrefResult = MSP430ADC12M$RefVolt$get(REFERENCE_2_5V);
            }
          else {
#line 143
            vrefResult = MSP430ADC12M$RefVolt$get(REFERENCE_1_5V);
            }
        }
      else {
#line 145
        vrefResult = SUCCESS;
        }
#line 146
      if (vrefResult != SUCCESS) 
        {
          adcResult = MSP430ADC12_FAIL;
        }
      else 
#line 149
        {
          MSP430ADC12M$adc12settings[num].gotRefVolt = 1;
          if (MSP430ADC12M$RefVolt$getState() == REFERENCE_UNSTABLE) {
            adcResult = MSP430ADC12_DELAYED;
            }
        }
    }
#line 155
  return adcResult;
}

# 28 "/opt/tinyos-1.x/tos/platform/msp430/TimerMilli.nc"
inline static  result_t RefVoltM$SwitchOnTimer$setOneShot(int32_t arg_0x40c2c340){
#line 28
  unsigned char result;
#line 28

#line 28
  result = TimerM$TimerMilli$setOneShot(0U, arg_0x40c2c340);
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 162 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline  void RefVoltM$switchOnDelay(void)
#line 162
{
  RefVoltM$SwitchOnTimer$setOneShot(17);
}

# 141 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setRef2_5V(void)
#line 141
{
#line 141
  HPLADC12M$ADC12CTL0 |= 0x0040;
}

# 76 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void RefVoltM$HPLADC12$setRef2_5V(void){
#line 76
  HPLADC12M$HPLADC12$setRef2_5V();
#line 76
}
#line 76
# 140 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setRef1_5V(void)
#line 140
{
#line 140
  HPLADC12M$ADC12CTL0 &= ~0x0040;
}

# 75 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void RefVoltM$HPLADC12$setRef1_5V(void){
#line 75
  HPLADC12M$HPLADC12$setRef1_5V();
#line 75
}
#line 75
# 137 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setRefOn(void)
#line 137
{
#line 137
  HPLADC12M$ADC12CTL0 |= 0x0020;
}

# 72 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void RefVoltM$HPLADC12$setRefOn(void){
#line 72
  HPLADC12M$HPLADC12$setRefOn();
#line 72
}
#line 72
# 140 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static __inline void RefVoltM$switchRefOn(uint8_t vref)
#line 140
{
  RefVoltM$HPLADC12$disableConversion();
  RefVoltM$HPLADC12$setRefOn();
  if (vref == REFERENCE_1_5V) {
      RefVoltM$HPLADC12$setRef1_5V();
      /* atomic removed: atomic calls only */
#line 145
      RefVoltM$state = RefVoltM$REFERENCE_1_5V_PENDING;
    }
  else {
      RefVoltM$HPLADC12$setRef2_5V();
      /* atomic removed: atomic calls only */
#line 149
      RefVoltM$state = RefVoltM$REFERENCE_2_5V_PENDING;
    }
  TOS_post(RefVoltM$switchOnDelay);
}

static __inline void RefVoltM$switchToRefPending(uint8_t vref)
#line 154
{
  RefVoltM$switchRefOn(vref);
}

static __inline void RefVoltM$switchToRefStable(uint8_t vref)
#line 158
{
  RefVoltM$switchRefOn(vref);
}

# 58 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setControl0_IgnoreRef(adc12ctl0_t control0)
#line 58
{
  adc12ctl0_t oldControl0 = * (adc12ctl0_t *)&HPLADC12M$ADC12CTL0;

#line 60
  control0.refon = oldControl0.refon;
  control0.r2_5v = oldControl0.r2_5v;
  HPLADC12M$ADC12CTL0 = * (uint16_t *)&control0;
}

# 48 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$setControl0_IgnoreRef(adc12ctl0_t arg_0x413fa010){
#line 48
  HPLADC12M$HPLADC12$setControl0_IgnoreRef(arg_0x413fa010);
#line 48
}
#line 48
# 144 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setSHT(uint8_t sht)
#line 144
{
  uint16_t ctl0 = HPLADC12M$ADC12CTL0;
  uint16_t shttemp = sht & 0x0F;

#line 147
  ctl0 &= 0x00FF;
  ctl0 |= shttemp << 8;
  ctl0 |= shttemp << 12;
  HPLADC12M$ADC12CTL0 = ctl0;
}

# 69 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$setSHT(uint8_t arg_0x413f6688){
#line 69
  HPLADC12M$HPLADC12$setSHT(arg_0x413f6688);
#line 69
}
#line 69
# 54 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$setControl1(adc12ctl1_t control1)
#line 54
{
  HPLADC12M$ADC12CTL1 = * (uint16_t *)&control1;
}

# 43 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$setControl1(adc12ctl1_t arg_0x413fc4e8){
#line 43
  HPLADC12M$HPLADC12$setControl1(arg_0x413fc4e8);
#line 43
}
#line 43
# 179 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$TimerA$clear(void)
#line 179
{
#line 179
  MSP430TimerM$TA0CTL |= 0x0004;
}

# 37 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430ADC12M$TimerA$clear(void){
#line 37
  MSP430TimerM$TimerA$clear();
#line 37
}
#line 37
# 182 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$TimerA$disableEvents(void)
#line 182
{
#line 182
  MSP430TimerM$TA0CTL &= ~0x0002;
}

# 38 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430ADC12M$TimerA$disableEvents(void){
#line 38
  MSP430TimerM$TimerA$disableEvents();
#line 38
}
#line 38
# 185 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$TimerA$setClockSource(uint16_t clockSource)
{
  MSP430TimerM$TA0CTL = (MSP430TimerM$TA0CTL & ~(0x0100 | 0x0200)) | ((clockSource << 8) & (0x0100 | 0x0200));
}

# 39 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430ADC12M$TimerA$setClockSource(uint16_t arg_0x408b88a8){
#line 39
  MSP430TimerM$TimerA$setClockSource(arg_0x408b88a8);
#line 39
}
#line 39
# 195 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$TimerA$setInputDivider(uint16_t inputDivider)
{
  MSP430TimerM$TA0CTL = (MSP430TimerM$TA0CTL & ~((1 << 6) | (3 << 6))) | ((inputDivider << 8) & ((1 << 6) | (3 << 6)));
}

# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430ADC12M$TimerA$setInputDivider(uint16_t arg_0x408b8d60){
#line 40
  MSP430TimerM$TimerA$setInputDivider(arg_0x408b8d60);
#line 40
}
#line 40
# 217 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$ControlA0$setControl(MSP430TimerM$CC_t x)
#line 217
{
#line 217
  MSP430TimerM$TA0CCTL0 = MSP430TimerM$CC2int(x);
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerControl.nc"
inline static   void MSP430ADC12M$ControlA0$setControl(MSP430CompareControl_t arg_0x408c29a8){
#line 34
  MSP430TimerM$ControlA0$setControl(arg_0x408c29a8);
#line 34
}
#line 34
# 257 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$CompareA0$setEvent(uint16_t x)
#line 257
{
#line 257
  MSP430TimerM$TA0CCR0 = x;
}

# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430ADC12M$CompareA0$setEvent(uint16_t arg_0x408d6eb0){
#line 30
  MSP430TimerM$CompareA0$setEvent(arg_0x408d6eb0);
#line 30
}
#line 30
# 258 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   void MSP430TimerM$CompareA1$setEvent(uint16_t x)
#line 258
{
#line 258
  MSP430TimerM$TA0CCR1 = x;
}

# 30 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430ADC12M$CompareA1$setEvent(uint16_t arg_0x408d6eb0){
#line 30
  MSP430TimerM$CompareA1$setEvent(arg_0x408d6eb0);
#line 30
}
#line 30
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t ADCM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = LedsC$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
#line 81
inline static   result_t ADCM$Leds$redToggle(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = LedsC$Leds$redToggle();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 353 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   MSP430TimerM$CC_t MSP430TimerM$ControlB6$getControl(void)
#line 353
{
#line 353
  return MSP430TimerM$int2CC(MSP430TimerM$TBCCTL6);
}

#line 344
static inline    void MSP430TimerM$CaptureB6$default$captured(uint16_t time)
#line 344
{
}

# 74 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Capture.nc"
inline static   void MSP430TimerM$CaptureB6$captured(uint16_t arg_0x408cb858){
#line 74
  MSP430TimerM$CaptureB6$default$captured(arg_0x408cb858);
#line 74
}
#line 74
# 449 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static inline   uint16_t MSP430TimerM$CaptureB6$getEvent(void)
#line 449
{
#line 449
  return MSP430TimerM$TBCCR6;
}

#line 337
static inline    void MSP430TimerM$CompareB6$default$fired(void)
#line 337
{
}

# 34 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Compare.nc"
inline static   void MSP430TimerM$CompareB6$fired(void){
#line 34
  MSP430TimerM$CompareB6$default$fired();
#line 34
}
#line 34
# 75 "/opt/tinyos-1.x/tos/platform/msp430/MSP430DCOCalibM.nc"
static inline   void MSP430DCOCalibM$Timer32khz$overflow(void)
{
}

# 512 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static inline   void RealTimeM$MSP430Timer$overflow(void)
#line 512
{
  return;
}

# 266 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static inline  void TimerM$checkLongTimers(void)
{
  uint8_t head = TimerM$m_head_long;

#line 269
  TimerM$m_head_long = TimerM$EMPTY_LIST;
  TimerM$executeTimers(head);
  TimerM$setNextShortEvent();
}

#line 313
static inline   void TimerM$AlarmTimer$overflow(void)
{
  /* atomic removed: atomic calls only */
#line 315
  TimerM$m_hinow++;
  TOS_post(TimerM$checkLongTimers);
}

# 33 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Timer.nc"
inline static   void MSP430TimerM$TimerB$overflow(void){
#line 33
  TimerM$AlarmTimer$overflow();
#line 33
  RealTimeM$MSP430Timer$overflow();
#line 33
  MSP430DCOCalibM$Timer32khz$overflow();
#line 33
}
#line 33
# 488 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline    result_t HPLUSART0M$USARTData$default$rxDone(uint8_t data)
#line 488
{
#line 488
  return SUCCESS;
}

# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
inline static   result_t HPLUSART0M$USARTData$rxDone(uint8_t arg_0x40ee6c40){
#line 53
  unsigned char result;
#line 53

#line 53
  result = HPLUSART0M$USARTData$default$rxDone(arg_0x40ee6c40);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 70 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline    void HPLUSART0M$HPLI2CInterrupt$default$fired(void)
#line 70
{
}

# 43 "/opt/tinyos-1.x/tos/platform/msp430/HPLI2CInterrupt.nc"
inline static   void HPLUSART0M$HPLI2CInterrupt$fired(void){
#line 43
  HPLUSART0M$HPLI2CInterrupt$default$fired();
#line 43
}
#line 43
# 486 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static inline    result_t HPLUSART0M$USARTData$default$txDone(void)
#line 486
{
#line 486
  return SUCCESS;
}

# 46 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
inline static   result_t HPLUSART0M$USARTData$txDone(void){
#line 46
  unsigned char result;
#line 46

#line 46
  result = HPLUSART0M$USARTData$default$txDone();
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 177 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port10$clear(void)
#line 177
{
#line 177
  MSP430InterruptM$P1IFG &= ~(1 << 0);
}

# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOPInterrupt$clear(void){
#line 40
  MSP430InterruptM$Port10$clear();
#line 40
}
#line 40
# 146 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port10$disable(void)
#line 146
{
#line 146
  MSP430InterruptM$P1IE &= ~(1 << 0);
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOPInterrupt$disable(void){
#line 35
  MSP430InterruptM$Port10$disable();
#line 35
}
#line 35
# 59 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420RadioM$FIFOP$disable(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = HPLCC2420InterruptM$FIFOP$disable();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 536 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  void CC2420RadioM$delayedRXFIFOtask(void)
#line 536
{
  CC2420RadioM$delayedRXFIFO();
}

# 28 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline uint8_t TOSH_READ_CC_FIFO_PIN(void)
#line 28
{
#line 28
   static volatile uint8_t r __asm ("0x0020");

#line 28
  return r & (1 << 3);
}

# 104 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static inline   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void)
{
  /* atomic removed: atomic calls only */
#line 106
  {
    TimerJiffyAsyncM$bSet = FALSE;
    TimerJiffyAsyncM$AlarmControl$disableEvents();
  }
  return SUCCESS;
}

# 8 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t CC2420RadioM$BackoffTimerJiffy$stop(void){
#line 8
  unsigned char result;
#line 8

#line 8
  result = TimerJiffyAsyncM$TimerJiffyAsync$stop();
#line 8

#line 8
  return result;
#line 8
}
#line 8
# 97 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static inline   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void)
{
  bool _isSet;

  /* atomic removed: atomic calls only */
#line 100
  _isSet = TimerJiffyAsyncM$bSet;
  return _isSet;
}

# 10 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   bool CC2420RadioM$BackoffTimerJiffy$isSet(void){
#line 10
  unsigned char result;
#line 10

#line 10
  result = TimerJiffyAsyncM$TimerJiffyAsync$isSet();
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 591 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$FIFOP$fired(void)
#line 591
{






  if (CC2420RadioM$bAckEnable && CC2420RadioM$stateRadio == CC2420RadioM$PRE_TX_STATE) {
      if (CC2420RadioM$BackoffTimerJiffy$isSet()) {
          CC2420RadioM$BackoffTimerJiffy$stop();
          CC2420RadioM$BackoffTimerJiffy$setOneShot(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10 + 75);
        }
    }


  if (!TOSH_READ_CC_FIFO_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return SUCCESS;
    }
  /* atomic removed: atomic calls only */
  {
    if (TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
        CC2420RadioM$FIFOP$disable();
      }
    else {
        CC2420RadioM$flushRXFIFO();
      }
  }


  return SUCCESS;
}

# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$FIFOP$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420RadioM$FIFOP$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 89 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline   void HPLCC2420InterruptM$FIFOPInterrupt$fired(void)
#line 89
{
  result_t val = SUCCESS;

#line 91
  HPLCC2420InterruptM$FIFOPInterrupt$clear();
  val = HPLCC2420InterruptM$FIFOP$fired();
  if (val == FAIL) {
      HPLCC2420InterruptM$FIFOPInterrupt$disable();
      HPLCC2420InterruptM$FIFOPInterrupt$clear();
    }
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port10$fired(void){
#line 59
  HPLCC2420InterruptM$FIFOPInterrupt$fired();
#line 59
}
#line 59
# 27 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static inline uint8_t TOSH_READ_CC_FIFOP_PIN(void)
#line 27
{
#line 27
   static volatile uint8_t r __asm ("0x0020");

#line 27
  return r & (1 << 0);
}

# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t GenericCommProM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = LedsC$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
# 398 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  TOS_MsgPtr GenericCommProM$RadioReceive$receive(TOS_MsgPtr msg)
#line 398
{
  GenericCommProM$radioRecvActive = TRUE;
  GenericCommProM$Leds$yellowToggle();
  return GenericCommProM$received(msg);
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0x40bd2280){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = GenericCommProM$RadioReceive$receive(arg_0x40bd2280);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 153 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  void CC2420RadioM$PacketRcvd(void)
#line 153
{
  TOS_MsgPtr pBuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 156
    {
      pBuf = CC2420RadioM$rxbufptr;
    }
#line 158
    __nesc_atomic_end(__nesc_atomic); }
  pBuf = CC2420RadioM$Receive$receive((TOS_MsgPtr )pBuf);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 160
    {
      if (pBuf) {
#line 161
        CC2420RadioM$rxbufptr = pBuf;
        }
#line 162
      CC2420RadioM$rxbufptr->length = 0;
      CC2420RadioM$bPacketReceiving = FALSE;
    }
#line 164
    __nesc_atomic_end(__nesc_atomic); }
}

# 23 "/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
static __inline uint16_t fromLSB16(uint16_t a)
{
  return is_host_lsb() ? a : (a << 8) | (a >> 8);
}

# 628 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t length, uint8_t *data)
#line 628
{





  uint8_t currentstate;

#line 635
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 635
    {
      currentstate = CC2420RadioM$stateRadio;
    }
#line 637
    __nesc_atomic_end(__nesc_atomic); }




  if (((
#line 641
  !TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN())
   || length == 0) || length > MSG_DATA_SIZE) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 644
        CC2420RadioM$bPacketReceiving = FALSE;
#line 644
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }

  CC2420RadioM$rxbufptr = (TOS_MsgPtr )data;




  if (
#line 651
  CC2420RadioM$bAckEnable && currentstate == CC2420RadioM$POST_TX_STATE && (
  CC2420RadioM$rxbufptr->fcfhi & 0x07) == 0x02 && 
  CC2420RadioM$rxbufptr->dsn == CC2420RadioM$currentDSN && 
  data[length - 1] >> 7 == 1) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 655
        {
          CC2420RadioM$txbufptr->ack = 1;
          CC2420RadioM$txbufptr->strength = data[length - 2];
          CC2420RadioM$txbufptr->lqi = data[length - 1] & 0x7F;

          CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_ACK_STATE;
          CC2420RadioM$bPacketReceiving = FALSE;
        }
#line 662
        __nesc_atomic_end(__nesc_atomic); }
      if (!TOS_post(CC2420RadioM$PacketSent)) {
        CC2420RadioM$sendFailed();
        }
#line 665
      return SUCCESS;
    }




  if ((CC2420RadioM$rxbufptr->fcfhi & 0x07) != 0x01 || 
  CC2420RadioM$rxbufptr->fcflo != 0x08) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 674
        CC2420RadioM$bPacketReceiving = FALSE;
#line 674
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }

  CC2420RadioM$rxbufptr->length = CC2420RadioM$rxbufptr->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;

  if (CC2420RadioM$rxbufptr->length > 74) {
      CC2420RadioM$flushRXFIFO();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 682
        CC2420RadioM$bPacketReceiving = FALSE;
#line 682
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }


  CC2420RadioM$rxbufptr->addr = fromLSB16(CC2420RadioM$rxbufptr->addr);


  CC2420RadioM$rxbufptr->crc = data[length - 1] >> 7;

  CC2420RadioM$rxbufptr->strength = data[length - 2];

  CC2420RadioM$rxbufptr->lqi = data[length - 1] & 0x7F;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 696
    {
      if (!TOS_post(CC2420RadioM$PacketRcvd)) {
          CC2420RadioM$bPacketReceiving = FALSE;
        }
    }
#line 700
    __nesc_atomic_end(__nesc_atomic); }

  if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return SUCCESS;
    }

  if (!TOSH_READ_CC_FIFOP_PIN()) {
      if (TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
        return SUCCESS;
        }
    }
#line 711
  CC2420RadioM$flushRXFIFO();


  return SUCCESS;
}

# 39 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t HPLCC2420M$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0x40dcd640, uint8_t *arg_0x40dcd7e8){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420RadioM$HPLChipconFIFO$RXFIFODone(arg_0x40dcd640, arg_0x40dcd7e8);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 322 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline  void HPLCC2420M$signalRXFIFO(void)
#line 322
{
  uint8_t _rxlen;
  uint8_t *_rxbuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 326
    {
      _rxlen = HPLCC2420M$rxlen;
      _rxbuf = HPLCC2420M$rxbuf;
      HPLCC2420M$f.rxbufBusy = FALSE;
    }
#line 330
    __nesc_atomic_end(__nesc_atomic); }

  HPLCC2420M$HPLCC2420FIFO$RXFIFODone(_rxlen, _rxbuf);
}

# 185 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTControl.nc"
inline static   result_t HPLCC2420M$USARTControl$isRxIntrPending(void){
#line 185
  unsigned char result;
#line 185

#line 185
  result = HPLUSART0M$USARTControl$isRxIntrPending();
#line 185

#line 185
  return result;
#line 185
}
#line 185
# 335 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t length, uint8_t *data)
#line 335
{
  uint8_t i;
  bool returnFail = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 339
    {
      if (HPLCC2420M$f.rxbufBusy) {
        returnFail = TRUE;
        }
      else {
#line 343
        HPLCC2420M$f.rxbufBusy = TRUE;
        }
    }
#line 345
    __nesc_atomic_end(__nesc_atomic); }
  if (returnFail) {
    return FAIL;
    }
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 350
        {
          HPLCC2420M$f.busy = TRUE;
          HPLCC2420M$rxbuf = data;
          TOSH_CLR_RADIO_CSN_PIN();

          HPLCC2420M$USARTControl$isTxIntrPending();
          HPLCC2420M$USARTControl$rx();
          HPLCC2420M$USARTControl$tx(0x3F | 0x40);
          while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
          HPLCC2420M$rxlen = HPLCC2420M$USARTControl$rx();
          HPLCC2420M$USARTControl$tx(0);
          while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;

          HPLCC2420M$rxlen = HPLCC2420M$USARTControl$rx();
        }
#line 364
        __nesc_atomic_end(__nesc_atomic); }
      if (HPLCC2420M$rxlen > 0) {
          HPLCC2420M$rxbuf[0] = HPLCC2420M$rxlen;

          HPLCC2420M$rxlen++;

          if (HPLCC2420M$rxlen > length) {
#line 370
            HPLCC2420M$rxlen = length;
            }
#line 371
          for (i = 1; i < HPLCC2420M$rxlen; i++) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 372
                {
                  HPLCC2420M$USARTControl$tx(0);
                  while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
                  HPLCC2420M$rxbuf[i] = HPLCC2420M$USARTControl$rx();
                }
#line 376
                __nesc_atomic_end(__nesc_atomic); }
            }
        }
      TOSH_SET_RADIO_CSN_PIN();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 380
        HPLCC2420M$f.busy = FALSE;
#line 380
        __nesc_atomic_end(__nesc_atomic); }
      HPLCC2420M$BusArbitration$releaseBus();
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 384
        HPLCC2420M$f.rxbufBusy = FALSE;
#line 384
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  if (TOS_post(HPLCC2420M$signalRXFIFO) == FAIL) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 388
        HPLCC2420M$f.rxbufBusy = FALSE;
#line 388
        __nesc_atomic_end(__nesc_atomic); }
      return FAIL;
    }
  return SUCCESS;
}

# 19 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0x40d9c6a8, uint8_t *arg_0x40d9c850){
#line 19
  unsigned char result;
#line 19

#line 19
  result = HPLCC2420M$HPLCC2420FIFO$readRXFIFO(arg_0x40d9c6a8, arg_0x40d9c850);
#line 19

#line 19
  return result;
#line 19
}
#line 19
# 82 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  void NeighborMgmtM$processSnoopMsg(void)
#line 82
{
  uint8_t iNbr;

#line 84
  iNbr = NeighborMgmtM$findPreparedIndex(NeighborMgmtM$linkaddrBuf);
  if (NeighborMgmtM$NeighborTbl[iNbr].flags & NBRFLAG_NEW) {
      NeighborMgmtM$NeighborTbl[iNbr].linkEst = NeighborMgmtM$lqiBuf;
      NeighborMgmtM$NeighborTbl[iNbr].linkEstCandidate = NeighborMgmtM$lqiBuf;
      NeighborMgmtM$NeighborTbl[iNbr].flags ^= NBRFLAG_NEW;
    }
  else {
      if (NeighborMgmtM$NeighborTbl[iNbr].flags & NBRFLAG_JUST_UPDATED) {
          NeighborMgmtM$NeighborTbl[iNbr].linkEstCandidate = NeighborMgmtM$lqiBuf;
          NeighborMgmtM$NeighborTbl[iNbr].flags ^= NBRFLAG_JUST_UPDATED;
        }
      else {

          NeighborMgmtM$NeighborTbl[iNbr].linkEstCandidate = NeighborMgmtM$NeighborTbl[iNbr].linkEstCandidate * 0.75 + NeighborMgmtM$lqiBuf * 0.25;
        }
    }


  NeighborMgmtM$NeighborTbl[iNbr].lqi_raw = NeighborMgmtM$lqiBuf;
  NeighborMgmtM$NeighborTbl[iNbr].rssi_raw = NeighborMgmtM$rssiBuf;
  NeighborMgmtM$NeighborTbl[iNbr].liveliness = LIVELINESS;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 105
    NeighborMgmtM$processTaskBusy = FALSE;
#line 105
    __nesc_atomic_end(__nesc_atomic); }
}

#line 107
static inline  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr msg, void *payload, uint16_t payloadLen)
#line 107
{

  if (!NeighborMgmtM$processTaskBusy) {


      NeighborMgmtM$lqiBuf = msg->lqi;
      NeighborMgmtM$rssiBuf = msg->strength;
      NeighborMgmtM$nwMsg = (NetworkMsg *)msg->data;
      NeighborMgmtM$linkaddrBuf = NeighborMgmtM$nwMsg->linksource;
      if (TOS_post(NeighborMgmtM$processSnoopMsg) == SUCCESS) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 117
            NeighborMgmtM$processTaskBusy = TRUE;
#line 117
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t GenericCommProM$Intercept$intercept(TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0){
#line 86
  unsigned char result;
#line 86

#line 86
  result = NeighborMgmtM$Snoop$intercept(arg_0x40ca3b88, arg_0x40ca3d28, arg_0x40ca3ec0);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 159 "/opt/tinyos-1.x/tos/system/tos.h"
static inline void *nmemset(void *to, int val, size_t n)
{
  char *cto = to;

  while (n--) * cto++ = val;

  return to;
}

# 66 "/home/xu/oasis/lib/SNMS/Event.h"
static inline uint8_t *eventprintf(const uint8_t *format, ...)
#line 66
{
  uint8_t *buf = gTempEventBuf;

  uint8_t format_flag;
  uint16_t u_val = 0;
#line 70
  uint16_t base;
  uint8_t *ptr;
  va_list ap;


  nmemset(gTempEventBuf, 0, sizeof gTempEventBuf);
  buf[0] = '\0';
  __builtin_stdarg_start(ap, format);
  for (; ; ) {
      while ((format_flag = * format++) != '%') {
          if (!format_flag) {
              __builtin_va_end(ap);

              return gTempEventBuf;
            }


          *buf = format_flag;
#line 87
          buf++;
#line 87
          *buf = 0;
        }

      switch ((format_flag = * format++)) {
          case 'c': 
            format_flag = (__builtin_va_arg(ap, int ));
          default: 
            *buf = format_flag;
#line 94
          buf++;
#line 94
          *buf = 0;
          continue;
          case 'S': 
            case 's': 
              ptr = (__builtin_va_arg(ap, char *));
          strcat(buf, ptr);
          continue;
          case 'o': 
            base = 8;
          *buf = '0';
#line 103
          buf++;
#line 103
          *buf = 0;
          goto CONVERSION_LOOP;
          case 'i': 
            if ((int16_t )u_val < 0) {
                u_val = -u_val;
                *buf = '-';
#line 108
                buf++;
#line 108
                *buf = 0;
              }

          case 'u': 
            base = 10;
          goto CONVERSION_LOOP;
          case 'x': 
            base = 16;

          CONVERSION_LOOP: 
            u_val = (__builtin_va_arg(ap, int ));
          ptr = gTempScratch + 16;
          * --ptr = 0;
          do {
              char ch = u_val % base + '0';

#line 123
              if (ch > '9') {
                ch += 'a' - '9' - 1;
                }
#line 125
              * --ptr = ch;
              u_val /= base;
            }
          while (
#line 127
          u_val);
          strcat(buf, ptr);
          buf += strlen(ptr);
        }
    }
}

# 312 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static inline void EventReportM$assignPriority(TOS_MsgPtr msg, uint8_t level)
#line 312
{
  NetworkMsg *NMsg = (NetworkMsg *)msg->data;

#line 314
  NMsg->qos = 7;
}

#line 187
static inline  uint8_t EventReportM$EventReport$eventSend(uint8_t eventType, uint8_t type, 
uint8_t level, 
uint8_t *content)
{
  uint16_t len;
  uint16_t maxLen;
  result_t result = SUCCESS;
  ApplicationMsg *pApp;
  EventMsg *pEvent;
  TOS_MsgPtr msgPtr;

  ;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 200
    {
      if (EventReportM$gLevelMode[type] >= level) {

          if (NULL != (msgPtr = allocBuffer(&EventReportM$buffQueue))) {


              EventReportM$assignPriority(msgPtr, level);
              pApp = (ApplicationMsg *)EventReportM$EventSend$getBuffer(msgPtr, &maxLen);
              maxLen = maxLen - (size_t )& ((ApplicationMsg *)0)->data - (size_t )& ((EventMsg *)0)->data;


              pEvent = (EventMsg *)pApp->data;
              len = strlen(content);
              if (len > maxLen) {
                  len = maxLen;
                }
              pEvent->length = len;
              pEvent->type = type;
              pEvent->level = level;
              nmemcpy(pEvent->data, content, pEvent->length);

              pApp->type = TYPE_SNMS_EVENT;
              pApp->length = (size_t )& ((EventMsg *)0)->data + len;
              pApp->seqno = EventReportM$seqno++;



              result = insertElement(&EventReportM$sendQueue, msgPtr);
              EventReportM$tryNextSend();

              {
                unsigned char __nesc_temp = 
#line 230
                result;

                {
#line 230
                  __nesc_atomic_end(__nesc_atomic); 
#line 230
                  return __nesc_temp;
                }
              }
            }
          else 
#line 232
            {

              {
                unsigned char __nesc_temp = 
#line 234
                BUFFER_FAIL;

                {
#line 234
                  __nesc_atomic_end(__nesc_atomic); 
#line 234
                  return __nesc_temp;
                }
              }
            }
        }
      else 
#line 237
        {
          ;
          {
            unsigned char __nesc_temp = 
#line 239
            FILTER_FAIL;

            {
#line 239
              __nesc_atomic_end(__nesc_atomic); 
#line 239
              return __nesc_temp;
            }
          }
        }
    }
#line 243
    __nesc_atomic_end(__nesc_atomic); }
}

# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t MultiHopLQI$EventReport$eventSend(uint8_t arg_0x40a2ca80, uint8_t arg_0x40a2cc18, uint8_t *arg_0x40a2cdd0){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x40a2ca80, arg_0x40a2cc18, arg_0x40a2cdd0);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 15 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$setCost(uint16_t arg_0x4121d7d8, uint16_t arg_0x4121d968){
#line 15
  unsigned char result;
#line 15

#line 15
  result = NeighborMgmtM$NeighborCtrl$setCost(arg_0x4121d7d8, arg_0x4121d968);
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 430 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr Msg)
#line 430
{

  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];
  BeaconMsg *pRP = (BeaconMsg *)&pNWMsg->data[0];
  uint16_t oldParent = 0;

#line 435
  MultiHopLQI$receivedBeacon = TRUE;

  if (pNWMsg->linksource != pNWMsg->source || 
  pRP->parent != pRP->parent_dup) {
      return Msg;
    }

  if (MultiHopLQI$localBeSink) {
#line 442
    return Msg;
    }

  if (pNWMsg->linksource == MultiHopLQI$gbCurrentParent) {

      if (pRP->parent != TOS_LOCAL_ADDRESS) {

          MultiHopLQI$gLastHeard = 0;
          MultiHopLQI$gbCurrentParentCost = pRP->cost;
          MultiHopLQI$gbCurrentLinkEst = MultiHopLQI$adjustLQI(Msg->lqi);
          MultiHopLQI$gbLinkQuality = Msg->lqi;
          MultiHopLQI$gbCurrentHopCount = pRP->hopcount + 1;


          if (pRP->parent == TOS_BCAST_ADDR) {
            goto invalidate;
            }
          else {
#line 459
            MultiHopLQI$NeighborCtrl$setCost(pNWMsg->source, pRP->cost);
            }
        }
      else 
#line 461
        {


          if (!MultiHopLQI$localBeSink) {
              invalidate: 
                ;
              MultiHopLQI$gLastHeard = 0;
              MultiHopLQI$gbCurrentParentCost = 0x7fff;
              MultiHopLQI$gbCurrentLinkEst = 0x7fff;
              MultiHopLQI$gbLinkQuality = 0;
              MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
              MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
              MultiHopLQI$fixedParent = FALSE;

              MultiHopLQI$NeighborCtrl$setParent(TOS_BCAST_ADDR);

              TOS_post(MultiHopLQI$SendRouteTask);
            }
        }
    }
  else 
#line 480
    {


      MultiHopLQI$NeighborCtrl$setCost(pNWMsg->source, pRP->cost);






      if (MultiHopLQI$fixedParent) {
#line 490
        return Msg;
        }





      if (
#line 493
      (uint32_t )pRP->cost + (uint32_t )MultiHopLQI$adjustLQI(Msg->lqi)
       < 
      (uint32_t )MultiHopLQI$gbCurrentParentCost + (uint32_t )MultiHopLQI$gbCurrentLinkEst - ((
      (uint32_t )MultiHopLQI$gbCurrentParentCost + (uint32_t )MultiHopLQI$gbCurrentLinkEst) >> 2)
       && 
      pRP->parent != TOS_LOCAL_ADDRESS) {
          oldParent = MultiHopLQI$gbCurrentParent;
          MultiHopLQI$gLastHeard = 0;
          MultiHopLQI$gbCurrentParent = pNWMsg->linksource;
          MultiHopLQI$gbCurrentParentCost = pRP->cost;
          MultiHopLQI$gbCurrentLinkEst = MultiHopLQI$adjustLQI(Msg->lqi);
          MultiHopLQI$gbLinkQuality = Msg->lqi;
          MultiHopLQI$gbCurrentHopCount = pRP->hopcount + 1;

          MultiHopLQI$NeighborCtrl$setParent(MultiHopLQI$gbCurrentParent);

          if (oldParent == TOS_BCAST_ADDR) {
              MultiHopLQI$MultihopCtrl$readyToSend();
              TOS_post(MultiHopLQI$SendRouteTask);
            }

          MultiHopLQI$EventReport$eventSend(EVENT_TYPE_SNMS, 
          EVENT_LEVEL_MEDIUM, 
          eventprintf("parent:%i", MultiHopLQI$gbCurrentParent));
        }
    }

  return Msg;
}

# 627 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Intercept$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen)
#line 629
{
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t MultiHopEngineM$Intercept$intercept(uint8_t arg_0x414e1e20, TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0){
#line 86
  unsigned char result;
#line 86

#line 86
    result = MultiHopEngineM$Intercept$default$intercept(arg_0x414e1e20, arg_0x40ca3b88, arg_0x40ca3d28, arg_0x40ca3ec0);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 509 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline result_t MultiHopEngineM$checkForDuplicates(TOS_MsgPtr msg, bool disable)
#line 509
{
  TOS_MsgPtr oldMsg;
  NetworkMsg *checkingMsg;
  NetworkMsg *passedMsg = (NetworkMsg *)msg->data;
  uint16_t ind;
  Queue_t *queue = &MultiHopEngineM$sendQueue;

#line 515
  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].obj != NULL) {
          oldMsg = queue->element[ind].obj;
          checkingMsg = (NetworkMsg *)oldMsg->data;
          if (checkingMsg->source == passedMsg->source && 
          checkingMsg->seqno == passedMsg->seqno) {
              if (disable == TRUE) {
                }

              return FAIL;
            }
        }
    }
  return SUCCESS;
}

# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$addChild(uint16_t arg_0x412209c8, uint16_t arg_0x41220b60, bool arg_0x41220cf0){
#line 7
  unsigned char result;
#line 7

#line 7
  result = NeighborMgmtM$NeighborCtrl$addChild(arg_0x412209c8, arg_0x41220b60, arg_0x41220cf0);
#line 7

#line 7
  return result;
#line 7
}
#line 7
# 558 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect)
#line 558
{
  return MultiHopLQI$NeighborCtrl$addChild(childAddr, priorHop, isDirect);
}

# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
inline static  result_t MultiHopEngineM$MultihopCtrl$addChild(uint16_t arg_0x41231718, uint16_t arg_0x412318b0, bool arg_0x41231a40){
#line 4
  unsigned char result;
#line 4

#line 4
  result = MultiHopLQI$MultihopCtrl$addChild(arg_0x41231718, arg_0x412318b0, arg_0x41231a40);
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 633 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Snoop$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen)
#line 635
{
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t MultiHopEngineM$Snoop$intercept(uint8_t arg_0x414e0420, TOS_MsgPtr arg_0x40ca3b88, void *arg_0x40ca3d28, uint16_t arg_0x40ca3ec0){
#line 86
  unsigned char result;
#line 86

#line 86
    result = MultiHopEngineM$Snoop$default$intercept(arg_0x414e0420, arg_0x40ca3b88, arg_0x40ca3d28, arg_0x40ca3ec0);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 409 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr msg)
#line 409
{
  NetworkMsg *multiHopMsg = (NetworkMsg *)msg->data;
  uint16_t correctedLength = msg->length - (size_t )& ((NetworkMsg *)0)->data;
  uint8_t AMID = msg->type;

#line 413
  ;
  if (msg->length < MultiHopEngineM$NETWORKMSG_HEADER_LENGTH || 
  msg->length > 74) {
    return msg;
    }
#line 417
  if (msg->addr != TOS_LOCAL_ADDRESS) {
      MultiHopEngineM$Snoop$intercept(AMID, msg, 
      &multiHopMsg->data[0], 
      correctedLength);
    }
  else {


      if (multiHopMsg->source == multiHopMsg->linksource) {
        MultiHopEngineM$MultihopCtrl$addChild(multiHopMsg->source, multiHopMsg->linksource, TRUE);
        }
      else {
#line 428
        MultiHopEngineM$MultihopCtrl$addChild(multiHopMsg->source, multiHopMsg->linksource, FALSE);
        }
      if (MultiHopEngineM$checkForDuplicates(msg, FALSE) == SUCCESS) {
          if (MultiHopEngineM$Intercept$intercept(AMID, msg, &multiHopMsg->data[0], correctedLength) == SUCCESS) {
              if (MultiHopEngineM$insertAndStartSend(msg, AMID, msg->length, NULL) != SUCCESS) {
                  MultiHopEngineM$numberOfSendFailures++;
                  ;
                }
              else {

                  ;
                }
            }
          else 
#line 440
            {
              ;
            }
        }
      else 
#line 443
        {
          ;
        }
    }
  return msg;
}

# 873 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   void TimeSyncM$TimeSyncNotify$default$msg_received(void)
#line 873
{
}

# 20 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
inline static  void TimeSyncM$TimeSyncNotify$msg_received(void){
#line 20
  TimeSyncM$TimeSyncNotify$default$msg_received();
#line 20
}
#line 20
# 40 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  result_t TimeSyncM$RealTime$setTimeCount(uint32_t arg_0x40ab48c8, uint8_t arg_0x40ab4a50){
#line 40
  unsigned char result;
#line 40

#line 40
  result = RealTimeM$RealTime$setTimeCount(arg_0x40ab48c8, arg_0x40ab4a50);
#line 40

#line 40
  return result;
#line 40
}
#line 40
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t TimeSyncM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = NoLeds$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 248 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline void TimeSyncM$calculateConversion(void)
{
  float newSkew = TimeSyncM$skew;
  uint32_t newLocalAverage;
  int32_t newOffsetAverage;

  int64_t localSum;
  int64_t offsetSum;

  int8_t i;

  for (i = 0; i < TimeSyncM$MAX_ENTRIES && TimeSyncM$table[i].state != TimeSyncM$ENTRY_FULL; ++i) 
    ;

  if (i >= TimeSyncM$MAX_ENTRIES) {
    return;
    }



  newLocalAverage = TimeSyncM$table[i].localTime;
  newOffsetAverage = TimeSyncM$table[i].timeOffset;

  localSum = 0;
  offsetSum = 0;

  while (++i < TimeSyncM$MAX_ENTRIES) {
      if (TimeSyncM$table[i].state == TimeSyncM$ENTRY_FULL) {
          localSum += (int32_t )(TimeSyncM$table[i].localTime - newLocalAverage) / TimeSyncM$tableEntries;
          offsetSum += (int32_t )(TimeSyncM$table[i].timeOffset - newOffsetAverage) / TimeSyncM$tableEntries;
        }
    }
  newLocalAverage += localSum;
  newOffsetAverage += offsetSum;

  localSum = offsetSum = 0;
  for (i = 0; i < TimeSyncM$MAX_ENTRIES; ++i) {
      if (TimeSyncM$table[i].state == TimeSyncM$ENTRY_FULL) {
          int32_t a = TimeSyncM$table[i].localTime - newLocalAverage;
          int32_t b = TimeSyncM$table[i].timeOffset - newOffsetAverage;

          localSum += (int64_t )a * a;
          offsetSum += (int64_t )a * b;
        }
    }
  if (localSum != 0) {
    newSkew = (float )offsetSum / (float )localSum;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      TimeSyncM$skew = newSkew;
      TimeSyncM$offsetAverage = newOffsetAverage;
      TimeSyncM$localAverage = newLocalAverage;
      TimeSyncM$numEntries = TimeSyncM$tableEntries;
    }
#line 302
    __nesc_atomic_end(__nesc_atomic); }
  TimeSyncM$Leds$greenToggle();
}

# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t TimeSyncM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = NoLeds$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
# 318 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline void TimeSyncM$addNewEntry(TimeSyncMsg *msg)
{
  int8_t i;
#line 320
  int8_t freeItem = -1;
#line 320
  int8_t oldestItem = 0;
  uint32_t age;
#line 321
  uint32_t oldestTime = 0;
  int32_t timeError;

  TimeSyncM$tableEntries = 0;


  timeError = msg->arrivalTime;
  TimeSyncM$GlobalTime$local2Global(&timeError);
  timeError -= msg->sendingTime;

  if (timeError > TimeSyncM$ENTRY_THROWOUT_LIMIT || timeError < -TimeSyncM$ENTRY_THROWOUT_LIMIT) {
      TimeSyncM$errTimes += 1;
      if (TimeSyncM$errTimes >= TimeSyncM$ERROR_TIMES) {
          TimeSyncM$clearTable();
          TimeSyncM$alreadySetTime = 0;
        }
      else {
#line 337
        return;
        }
    }







  TimeSyncM$errTimes = 0;

  for (i = 0; i < TimeSyncM$MAX_ENTRIES; ++i) {
      ++TimeSyncM$tableEntries;
      age = msg->arrivalTime - TimeSyncM$table[i].localTime;


      if (age >= 0x7FFFFFFFL) {
        TimeSyncM$table[i].state = TimeSyncM$ENTRY_EMPTY;
        }
      if (TimeSyncM$table[i].state == TimeSyncM$ENTRY_EMPTY) {
          --TimeSyncM$tableEntries;
          freeItem = i;
        }

      if (age >= oldestTime) {
          oldestTime = age;
          oldestItem = i;
        }
    }

  if (freeItem < 0) {
      freeItem = oldestItem;
    }
  else {
      ++TimeSyncM$tableEntries;
    }

  TimeSyncM$table[freeItem].state = TimeSyncM$ENTRY_FULL;

  TimeSyncM$table[freeItem].localTime = msg->arrivalTime;
  TimeSyncM$table[freeItem].timeOffset = msg->sendingTime - msg->arrivalTime;
  TimeSyncM$Leds$yellowToggle();
}

#line 417
static inline void  TimeSyncM$processMsg(void)
{
  TimeSyncMsg *msg = (TimeSyncMsg *)TimeSyncM$processedMsg->data;

#line 434
  if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS == msg->hasGPS) {
      if (msg->rootID < ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID && ~(TimeSyncM$heartBeats < TimeSyncM$IGNORE_ROOT_MSG && ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS)) {
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = msg->rootID;
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = msg->seqNum;
          TimeSyncM$rootid = msg->rootID;
        }
      else {
#line 440
        if (msg->rootID == ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID && (int8_t )(msg->seqNum - ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum) > 0 && ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID != 0xffff) {
            ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = msg->seqNum;
          }
        else {

          if (msg->rootID == ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID && (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == 0xffff || ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS)) {
              if (TimeSyncM$alreadySetTime == 0) {

                  if (TimeSyncM$RealTime$setTimeCount(1, FTSP_SYNC) == SUCCESS) {
                      TimeSyncM$alreadySetTime = 1;
                    }
                }
              goto exit;
            }
          else {
              goto exit;
            }
          }
        }
    }
  else {
#line 459
    if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS != TRUE && msg->hasGPS == TRUE) {
        if (msg->rootID == TOS_LOCAL_ADDRESS) {
            goto exit;
          }

        TimeSyncM$hasGPSValid++;
        if (TimeSyncM$hasGPSValid >= TimeSyncM$GPS_VALID) {
            TimeSyncM$hasGPSValid = 0;
            ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = msg->rootID;
            ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = msg->seqNum;
            ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = TRUE;
            TimeSyncM$rootid = msg->rootID;
          }
        else {
          goto exit;
          }
      }
    else {
#line 476
      if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS == TRUE && msg->hasGPS != TRUE) {
          if (msg->nodeID == ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID) {
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = FALSE;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = TOS_LOCAL_ADDRESS;
            }
          goto exit;
        }
      }
    }
  TimeSyncM$addNewEntry(msg);
  TimeSyncM$calculateConversion();
  if (TimeSyncM$numEntries > 0) {
      if (TimeSyncM$alreadySetTime == 0) {

          if (TimeSyncM$RealTime$setTimeCount(0, FTSP_SYNC) == SUCCESS) {
              TimeSyncM$alreadySetTime = 1;
              TimeSyncM$clearTable();
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 493
                {
                  TimeSyncM$skew = 0.0;
                  TimeSyncM$offsetAverage = 0;
                  TimeSyncM$localAverage = 0;
                }
#line 497
                __nesc_atomic_end(__nesc_atomic); }
            }
        }
    }
  TimeSyncM$TimeSyncNotify$msg_received();

  exit: 
    TimeSyncM$state &= ~TimeSyncM$STATE_PROCESSING;
}

# 138 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
static inline  result_t ClockTimeStampingM$TimeStamping$getStamp(TOS_MsgPtr ourMessage, 
uint32_t *timeStamp)
#line 139
{

  TimeSyncMsg *newMessage = (TimeSyncMsg *)ourMessage->data;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 144
    {
      if (ourMessage == ClockTimeStampingM$rcv_message) {

          newMessage->arrivalTime = ClockTimeStampingM$rcv_time;


          {
            unsigned char __nesc_temp = 
#line 150
            SUCCESS;

            {
#line 150
              __nesc_atomic_end(__nesc_atomic); 
#line 150
              return __nesc_temp;
            }
          }
        }
      else 
#line 151
        {
          {
            unsigned char __nesc_temp = 
#line 152
            FAIL;

            {
#line 152
              __nesc_atomic_end(__nesc_atomic); 
#line 152
              return __nesc_temp;
            }
          }
        }
    }
#line 156
    __nesc_atomic_end(__nesc_atomic); }
}

# 39 "/home/xu/oasis/interfaces/TimeStamping.nc"
inline static  result_t TimeSyncM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40bcab20, uint32_t *arg_0x40bcacd8){
#line 39
  unsigned char result;
#line 39

#line 39
  result = ClockTimeStampingM$TimeStamping$getStamp(arg_0x40bcab20, arg_0x40bcacd8);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 509 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr p)
#line 509
{

  TOS_MsgPtr old;
  TimeSyncMsg *newMessage = (TimeSyncMsg *)p->data;

#line 526
  if (TimeSyncM$mode == TS_USER_MODE) {
      return p;
    }







  if (
#line 535
  TimeSyncM$TimeStamping$getStamp(p, 
  & newMessage->arrivalTime) != SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 537
        TimeSyncM$missedReceiveStamps++;
#line 537
        __nesc_atomic_end(__nesc_atomic); }



      return p;
    }





  if (newMessage->wroteStamp != SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 549
        TimeSyncM$missedSendStamps++;
#line 549
        __nesc_atomic_end(__nesc_atomic); }

      return p;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 554
    {
      if (TimeSyncM$state & TimeSyncM$STATE_PROCESSING) {
          {
            struct TOS_Msg *__nesc_temp = 
#line 556
            p;

            {
#line 556
              __nesc_atomic_end(__nesc_atomic); 
#line 556
              return __nesc_temp;
            }
          }
        }
      else 
#line 557
        {
          TimeSyncM$state |= TimeSyncM$STATE_PROCESSING;
        }
    }
#line 560
    __nesc_atomic_end(__nesc_atomic); }



  old = TimeSyncM$processedMsg;
  TimeSyncM$processedMsg = p;

  TOS_post(TimeSyncM$processMsg);
  return old;
}

# 376 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline   TOS_MsgPtr GenericCommProM$ReceiveMsg$default$receive(uint8_t id, TOS_MsgPtr msg)
#line 376
{
  return msg;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr GenericCommProM$ReceiveMsg$receive(uint8_t arg_0x40cdd5b8, TOS_MsgPtr arg_0x40bd2280){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  switch (arg_0x40cdd5b8) {
#line 75
    case AM_NETWORKMSG:
#line 75
      result = MultiHopEngineM$ReceiveMsg$receive(arg_0x40bd2280);
#line 75
      break;
#line 75
    case AM_CASCTRLMSG:
#line 75
      result = CascadesRouterM$ReceiveMsg$receive(AM_CASCTRLMSG, arg_0x40bd2280);
#line 75
      break;
#line 75
    case AM_CASCADESMSG:
#line 75
      result = CascadesRouterM$ReceiveMsg$receive(AM_CASCADESMSG, arg_0x40bd2280);
#line 75
      break;
#line 75
    case AM_TIMESYNCMSG:
#line 75
      result = TimeSyncM$ReceiveMsg$receive(arg_0x40bd2280);
#line 75
      break;
#line 75
    case AM_BEACONMSG:
#line 75
      result = MultiHopLQI$ReceiveMsg$receive(arg_0x40bd2280);
#line 75
      break;
#line 75
    default:
#line 75
      result = GenericCommProM$ReceiveMsg$default$receive(arg_0x40cdd5b8, arg_0x40bd2280);
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
# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t RealTimeM$Leds$yellowToggle(void){
#line 131
  unsigned char result;
#line 131

#line 131
  result = NoLeds$Leds$yellowToggle();
#line 131

#line 131
  return result;
#line 131
}
#line 131
#line 106
inline static   result_t RealTimeM$Leds$greenToggle(void){
#line 106
  unsigned char result;
#line 106

#line 106
  result = NoLeds$Leds$greenToggle();
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 389 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$CascadeControl$addDirectChild(address_t childID)
#line 389
{
  CascadesRouterM$addToChildrenList(childID);
  return SUCCESS;
}

# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$addDirectChild(address_t arg_0x41544d38){
#line 3
  unsigned char result;
#line 3

#line 3
  result = CascadesRouterM$CascadeControl$addDirectChild(arg_0x41544d38);
#line 3

#line 3
  return result;
#line 3
}
#line 3
#line 2
inline static  uint16_t CascadesRouterM$CascadeControl$getParent(void){
#line 2
  unsigned int result;
#line 2

#line 2
  result = NeighborMgmtM$CascadeControl$getParent();
#line 2

#line 2
  return result;
#line 2
}
#line 2
# 932 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline void CascadesRouterM$processNoData(TOS_MsgPtr tmPtr)
#line 932
{
  CasCtrlMsg *CCMsg = (CasCtrlMsg *)tmPtr->data;
  uint16_t seq = CCMsg->dataSeq;

  if (CCMsg->linkSource != CascadesRouterM$CascadeControl$getParent()) {
      return;
    }

  if (seq > CascadesRouterM$expectingSeq) {
      CascadesRouterM$expectingSeq = seq;
    }
  else {


      if (seq < 10 && CascadesRouterM$expectingSeq > 65530UL) {
          CascadesRouterM$expectingSeq = seq;
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 950
    CascadesRouterM$activeRT = FALSE;
#line 950
    __nesc_atomic_end(__nesc_atomic); }
  CascadesRouterM$RTTimer$stop();
  return;
}

#line 900
static inline void CascadesRouterM$processACK(TOS_MsgPtr tmPtr)
#line 900
{
  CasCtrlMsg *CCMsg = (CasCtrlMsg *)tmPtr->data;
  address_t linkSource = CCMsg->linkSource;
  uint8_t localIndex = 0;

#line 904
  if (CCMsg->parent != TOS_LOCAL_ADDRESS) {
      CascadesRouterM$delFromChildrenList(linkSource);
    }
  else {
      CascadesRouterM$addToChildrenList(linkSource);
      localIndex = CascadesRouterM$findMsgIndex(CCMsg->dataSeq);
      if (localIndex != INVALID_INDEX) {
          CascadesRouterM$addChildACK(linkSource, localIndex);
          if (CascadesRouterM$getCMAu(localIndex) == TRUE) {
              if (CascadesRouterM$myBuffer[localIndex].countDT != 0) {
                  CascadesRouterM$clearChildrenListStatus(localIndex);
                }
            }
          else {
            }
        }
      else 
        {
        }
    }

  return;
}

#line 859
static inline  void CascadesRouterM$processRequest(void)
#line 859
{
  TOS_MsgPtr tempPtr = NULL;
  CasCtrlMsg *CCMsg = (CasCtrlMsg *)CascadesRouterM$RecvRequestMsg.data;
  address_t linkSource = CCMsg->linkSource;
  uint8_t localIndex = 0;

  if (CCMsg->parent != TOS_LOCAL_ADDRESS) {
      CascadesRouterM$delFromChildrenList(linkSource);
    }
  else {
      CascadesRouterM$addToChildrenList(linkSource);
      localIndex = CascadesRouterM$findMsgIndex(CCMsg->dataSeq);

      if (INVALID_INDEX == localIndex) {
          if (TRUE != CascadesRouterM$ctrlMsgBusy) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 874
                CascadesRouterM$ctrlMsgBusy = TRUE;
#line 874
                __nesc_atomic_end(__nesc_atomic); }
              tempPtr = &CascadesRouterM$SendCtrlMsg;
              CascadesRouterM$produceCtrlMsg(tempPtr, CascadesRouterM$expectingSeq, TYPE_CASCADES_NODATA);
              tempPtr->addr = TOS_BCAST_ADDR;
              if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCTRLMSG, tempPtr, tempPtr->length)) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 879
                    CascadesRouterM$ctrlMsgBusy = FALSE;
#line 879
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
        }
      if (CascadesRouterM$inited == TRUE) {
          tempPtr = & CascadesRouterM$myBuffer[0].tmsg;
          CascadesRouterM$produceDataMsg(tempPtr);
          if (SUCCESS != CascadesRouterM$SubSend$send(AM_CASCADESMSG, tempPtr, tempPtr->length)) {
            }
        }
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 891
    CascadesRouterM$RequestProcessBusy = FALSE;
#line 891
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$ACKTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(10U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 818 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  void CascadesRouterM$processCMAu(void)
#line 818
{
  TOS_MsgPtr tempPtr = NULL;
  CasCtrlMsg *CCMsg = (CasCtrlMsg *)CascadesRouterM$RecvCMAuMsg.data;
  uint8_t i = 0;
  uint8_t localIndex = 0;
  uint16_t *dst;

#line 824
  if (INVALID_INDEX != (localIndex = CascadesRouterM$findMsgIndex(CCMsg->dataSeq))) {
      if (CascadesRouterM$getCMAu(localIndex) == TRUE) {
          if (CascadesRouterM$myBuffer[localIndex].countDT != 0) {
              CascadesRouterM$clearChildrenListStatus(localIndex);
            }
          dst = (uint16_t *)CCMsg->data;
          for (i = 0; i < MAX_NUM_CHILDREN; i++) {
              if (TOS_LOCAL_ADDRESS == *dst) {
                  if (TRUE != CascadesRouterM$ctrlMsgBusy) {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 833
                        CascadesRouterM$ctrlMsgBusy = TRUE;
#line 833
                        __nesc_atomic_end(__nesc_atomic); }
                      tempPtr = &CascadesRouterM$SendCtrlMsg;
                      CascadesRouterM$produceCtrlMsg(tempPtr, CCMsg->dataSeq, TYPE_CASCADES_ACK);
                      tempPtr->addr = CCMsg->linkSource;
                      if (!CascadesRouterM$ACKTimer$start(TIMER_ONE_SHOT, 0xa + (CascadesRouterM$Random$rand() & 0xf))) {
                          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 838
                            CascadesRouterM$ctrlMsgBusy = FALSE;
#line 838
                            __nesc_atomic_end(__nesc_atomic); }
                        }
                    }
                  break;
                }
              ++dst;
            }
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 847
    CascadesRouterM$CMAuProcessBusy = FALSE;
#line 847
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$ResetTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(8U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
#line 59
inline static  result_t CascadesRouterM$DelayTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(9U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 1020 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline   TOS_MsgPtr CascadesRouterM$Receive$default$receive(uint8_t type, TOS_MsgPtr pMsg, 
void *payload, uint16_t payloadLen)
#line 1021
{
  return pMsg;
}

# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
inline static  TOS_MsgPtr CascadesRouterM$Receive$receive(uint8_t arg_0x415502d0, TOS_MsgPtr arg_0x40a0f130, void *arg_0x40a0f2d0, uint16_t arg_0x40a0f468){
#line 81
  struct TOS_Msg *result;
#line 81

#line 81
  switch (arg_0x415502d0) {
#line 81
    case NW_RPCC:
#line 81
      result = RpcM$CommandReceive$receive(arg_0x40a0f130, arg_0x40a0f2d0, arg_0x40a0f468);
#line 81
      break;
#line 81
    default:
#line 81
      result = CascadesRouterM$Receive$default$receive(arg_0x415502d0, arg_0x40a0f130, arg_0x40a0f2d0, arg_0x40a0f468);
#line 81
      break;
#line 81
    }
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 241 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline void CascadesRouterM$updateInData(void)
#line 241
{
  CascadesRouterM$inData[(CascadesRouterM$highestSeq + (MAX_CAS_PACKETS >> 2)) % MAX_CAS_PACKETS] = FALSE;
  CascadesRouterM$inData[(CascadesRouterM$highestSeq + 1 + (MAX_CAS_PACKETS >> 2)) % MAX_CAS_PACKETS] = FALSE;
  CascadesRouterM$inData[(CascadesRouterM$highestSeq + 2 + (MAX_CAS_PACKETS >> 2)) % MAX_CAS_PACKETS] = FALSE;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t CascadesRouterM$RTTimer$start(char arg_0x40abfb28, uint32_t arg_0x40abfcc0){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(6U, arg_0x40abfb28, arg_0x40abfcc0);
#line 59

#line 59
  return result;
#line 59
}
#line 59









inline static  result_t CascadesRouterM$DelayTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(9U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 278 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline result_t CascadesRouterM$addIntoBuffer(TOS_MsgPtr tmPtr)
#line 278
{
  uint8_t i;
  uint8_t j;

#line 281
  for (i = 0; i < MAX_CAS_BUF; i++) {
      if (CascadesRouterM$myBuffer[i].countDT == 0 && CascadesRouterM$myBuffer[i].signalDone == 1) {
          nmemcpy((void *)& CascadesRouterM$myBuffer[i].tmsg, (void *)tmPtr, sizeof(TOS_Msg ));
          CascadesRouterM$myBuffer[i].countDT = 1;
          CascadesRouterM$myBuffer[i].retry = 0;
          CascadesRouterM$myBuffer[i].signalDone = 0;

          CascadesRouterM$inData[CascadesRouterM$getCasData(& CascadesRouterM$myBuffer[i].tmsg)->seqno % MAX_CAS_PACKETS] = TRUE;
          CascadesRouterM$headIndex = i;
          for (j = 0; j < MAX_NUM_CHILDREN; j++) {
              CascadesRouterM$myBuffer[i].childrenList[j].status = 0;
            }
          return SUCCESS;
        }
    }
  return FAIL;
}

#line 614
static inline uint32_t CascadesRouterM$crcByte(uint32_t crc, uint8_t b)
#line 614
{
  uint8_t i = 8;

#line 616
  crc ^= (uint32_t )b << 24UL;
  do {
      if ((crc & 0x80000000) != 0) {
        crc = (crc << 1UL) ^ 0x04C11DB7;
        }
      else {
#line 621
        crc = crc << 1UL;
        }
    }
  while (
#line 623
  --i != 0);
  return crc;
}

static inline uint32_t CascadesRouterM$calculateCRC(uint8_t *start, uint8_t length)
#line 627
{
  uint8_t i = 0;
  uint32_t crc = 0xffffffff;

#line 630
  for (i = 0; i < length; i++) {
      crc = CascadesRouterM$crcByte(crc, *(start + i));
    }
  return crc;
}





static inline  void CascadesRouterM$processData(void)
#line 640
{
  TOS_MsgPtr tempPtr = NULL;
  NetworkMsg *nwMsg = (NetworkMsg *)(&CascadesRouterM$RecvDataMsg)->data;
  ApplicationMsg *appMsg = (ApplicationMsg *)nwMsg->data;
  uint16_t seq = nwMsg->seqno;
  uint8_t localIndex = 0;

  if (CascadesRouterM$inData[seq % MAX_CAS_PACKETS] != TRUE) {
      if (nwMsg->crc != CascadesRouterM$calculateCRC((uint8_t *)& nwMsg->seqno, appMsg->length + 6)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 649
            CascadesRouterM$DataProcessBusy = FALSE;
#line 649
            __nesc_atomic_end(__nesc_atomic); }
          return;
        }

      if (TRUE != CascadesRouterM$addIntoBuffer(&CascadesRouterM$RecvDataMsg)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 654
            CascadesRouterM$DataProcessBusy = FALSE;
#line 654
            __nesc_atomic_end(__nesc_atomic); }
          return;
        }
      else {

          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 659
            localIndex = CascadesRouterM$headIndex;
#line 659
            __nesc_atomic_end(__nesc_atomic); }
        }

      if (CascadesRouterM$delayTimerBusy == TRUE) {
          if (CascadesRouterM$DelayTimer$stop()) {
              CascadesRouterM$delayTimerBusy = FALSE;
            }
        }



      if (seq > CascadesRouterM$highestSeq) {

          if (CascadesRouterM$highestSeq < 10 && seq > 65530UL && CascadesRouterM$inited == TRUE) {
            }
          else 
            {
              CascadesRouterM$highestSeq = seq;
            }
        }
      else 


        {

          if (seq < 10 && CascadesRouterM$highestSeq > 65530UL && CascadesRouterM$inited == TRUE) {
              CascadesRouterM$highestSeq = seq;
            }
          else {
            }
        }


      while (CascadesRouterM$inData[CascadesRouterM$expectingSeq % MAX_CAS_PACKETS]) {
          ++CascadesRouterM$expectingSeq;
        }

      if ((uint16_t )(CascadesRouterM$expectingSeq - CascadesRouterM$highestSeq) != 1) {

          if (CascadesRouterM$inited != TRUE) {
              CascadesRouterM$expectingSeq = seq + 1;
              CascadesRouterM$nextSignalSeq = seq;
            }
          else 
            {
              if (TRUE != CascadesRouterM$activeRT) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 705
                    CascadesRouterM$activeRT = TRUE;
#line 705
                    __nesc_atomic_end(__nesc_atomic); }
                  if (SUCCESS != CascadesRouterM$RTTimer$start(TIMER_REPEAT, CascadesRouterM$RTwait)) {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 707
                        CascadesRouterM$activeRT = FALSE;
#line 707
                        __nesc_atomic_end(__nesc_atomic); }
                    }
                }
            }
        }


      CascadesRouterM$updateInData();


      if (CascadesRouterM$getCMAu(localIndex) != TRUE) {
          if (TRUE != CascadesRouterM$DataTimerOn) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 719
                CascadesRouterM$DataTimerOn = TRUE;
#line 719
                __nesc_atomic_end(__nesc_atomic); }
              if (SUCCESS != CascadesRouterM$DTTimer$start(TIMER_ONE_SHOT, MIN_INTERVAL + (CascadesRouterM$Random$rand() & 0xf))) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 721
                    CascadesRouterM$DataTimerOn = FALSE;
#line 721
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
          if (nwMsg->linksource == TOS_UART_ADDR && TRUE != CascadesRouterM$ctrlMsgBusy) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 725
                CascadesRouterM$ctrlMsgBusy = TRUE;
#line 725
                __nesc_atomic_end(__nesc_atomic); }
              tempPtr = &CascadesRouterM$SendCtrlMsg;
              CascadesRouterM$produceCtrlMsg(tempPtr, seq, TYPE_CASCADES_ACK);
              tempPtr->addr = TOS_UART_ADDR;
              if (!CascadesRouterM$ACKTimer$start(TIMER_ONE_SHOT, 0xa + (CascadesRouterM$Random$rand() & 0xf))) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 730
                    CascadesRouterM$ctrlMsgBusy = FALSE;
#line 730
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
        }
      else 
        {
          if (CascadesRouterM$myBuffer[localIndex].countDT != 0) {
              CascadesRouterM$clearChildrenListStatus(localIndex);
            }
          if (TRUE != CascadesRouterM$ctrlMsgBusy) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 740
                CascadesRouterM$ctrlMsgBusy = TRUE;
#line 740
                __nesc_atomic_end(__nesc_atomic); }
              tempPtr = &CascadesRouterM$SendCtrlMsg;
              CascadesRouterM$produceCtrlMsg(tempPtr, seq, TYPE_CASCADES_ACK);
              tempPtr->addr = CascadesRouterM$CascadeControl$getParent();
              if (!CascadesRouterM$ACKTimer$start(TIMER_ONE_SHOT, 0xa + (CascadesRouterM$Random$rand() & 0xf))) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 745
                    CascadesRouterM$ctrlMsgBusy = FALSE;
#line 745
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
        }
      if (seq == CascadesRouterM$nextSignalSeq) {
          if (CascadesRouterM$Receive$receive(nwMsg->type, &CascadesRouterM$RecvDataMsg, nwMsg->data, 
          CascadesRouterM$RecvDataMsg.length - (size_t )& ((NetworkMsg *)0)->data)) {
              CascadesRouterM$nextSignalSeq++;
              CascadesRouterM$myBuffer[localIndex].signalDone = 1;



              if (CascadesRouterM$nextSignalSeq != CascadesRouterM$expectingSeq) {
                  if (CascadesRouterM$sigRcvTaskBusy != TRUE) {
                      CascadesRouterM$sigRcvTaskBusy = TOS_post(CascadesRouterM$sigRcvTask);
                    }
                }
            }
          else {
              if (CascadesRouterM$delayTimerBusy != TRUE) {
                  CascadesRouterM$delayTimerBusy = CascadesRouterM$DelayTimer$start(TIMER_ONE_SHOT, 100UL);
                }
            }
        }
      else 
        {
          if (CascadesRouterM$delayTimerBusy != TRUE) {
              CascadesRouterM$delayTimerBusy = CascadesRouterM$DelayTimer$start(TIMER_ONE_SHOT, 200UL);
            }
        }

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 776
        CascadesRouterM$resetCount = 0;
#line 776
        __nesc_atomic_end(__nesc_atomic); }
      CascadesRouterM$ResetTimer$stop();
      CascadesRouterM$ResetTimer$start(TIMER_ONE_SHOT, 60000UL);
      CascadesRouterM$inited = TRUE;
    }
  else 
    {
      localIndex = CascadesRouterM$findMsgIndex(seq);
      if (localIndex != INVALID_INDEX) {
          CascadesRouterM$addChildACK(nwMsg->linksource, localIndex);

          if (CascadesRouterM$getCMAu(localIndex) == TRUE) {
              if (CascadesRouterM$myBuffer[localIndex].countDT != 0) {
                  CascadesRouterM$clearChildrenListStatus(localIndex);
                }
              if (nwMsg->linksource == TOS_UART_ADDR) {
                  if (TRUE != CascadesRouterM$ctrlMsgBusy) {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 793
                        CascadesRouterM$ctrlMsgBusy = TRUE;
#line 793
                        __nesc_atomic_end(__nesc_atomic); }
                      tempPtr = &CascadesRouterM$SendCtrlMsg;
                      CascadesRouterM$produceCtrlMsg(tempPtr, seq, TYPE_CASCADES_ACK);
                      tempPtr->addr = TOS_UART_ADDR;
                      if (!CascadesRouterM$ACKTimer$start(TIMER_ONE_SHOT, 0xa + (CascadesRouterM$Random$rand() & 0xf))) {
                          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 798
                            CascadesRouterM$ctrlMsgBusy = FALSE;
#line 798
                            __nesc_atomic_end(__nesc_atomic); }
                        }
                    }
                }
            }
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 805
    CascadesRouterM$DataProcessBusy = FALSE;
#line 805
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 178 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port11$clear(void)
#line 178
{
#line 178
  MSP430InterruptM$P1IFG &= ~(1 << 1);
}

#line 94
static inline    void MSP430InterruptM$Port11$default$fired(void)
#line 94
{
#line 94
  MSP430InterruptM$Port11$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port11$fired(void){
#line 59
  MSP430InterruptM$Port11$default$fired();
#line 59
}
#line 59
# 179 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port12$clear(void)
#line 179
{
#line 179
  MSP430InterruptM$P1IFG &= ~(1 << 2);
}

#line 95
static inline    void MSP430InterruptM$Port12$default$fired(void)
#line 95
{
#line 95
  MSP430InterruptM$Port12$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port12$fired(void){
#line 59
  MSP430InterruptM$Port12$default$fired();
#line 59
}
#line 59
# 180 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port13$clear(void)
#line 180
{
#line 180
  MSP430InterruptM$P1IFG &= ~(1 << 3);
}

# 40 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOInterrupt$clear(void){
#line 40
  MSP430InterruptM$Port13$clear();
#line 40
}
#line 40
# 149 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port13$disable(void)
#line 149
{
#line 149
  MSP430InterruptM$P1IE &= ~(1 << 3);
}

# 35 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void HPLCC2420InterruptM$FIFOInterrupt$disable(void){
#line 35
  MSP430InterruptM$Port13$disable();
#line 35
}
#line 35
# 140 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline    result_t HPLCC2420InterruptM$FIFO$default$fired(void)
#line 140
{
#line 140
  return FAIL;
}

# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$FIFO$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = HPLCC2420InterruptM$FIFO$default$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 130 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline   void HPLCC2420InterruptM$FIFOInterrupt$fired(void)
#line 130
{
  result_t val = SUCCESS;

#line 132
  HPLCC2420InterruptM$FIFOInterrupt$clear();
  val = HPLCC2420InterruptM$FIFO$fired();
  if (val == FAIL) {
      HPLCC2420InterruptM$FIFOInterrupt$disable();
      HPLCC2420InterruptM$FIFOInterrupt$clear();
    }
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port13$fired(void){
#line 59
  HPLCC2420InterruptM$FIFOInterrupt$fired();
#line 59
}
#line 59
# 312 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$SplitControl$default$startDone(void)
#line 312
{
  return SUCCESS;
}

# 85 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420RadioM$SplitControl$startDone(void){
#line 85
  unsigned char result;
#line 85

#line 85
  result = CC2420RadioM$SplitControl$default$startDone();
#line 85

#line 85
  return result;
#line 85
}
#line 85
# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420RadioM$FIFOP$startWait(bool arg_0x40dc68a0){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420InterruptM$FIFOP$startWait(arg_0x40dc68a0);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 343 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$RxMode(void)
#line 343
{
  CC2420ControlM$HPLChipcon$cmd(0x03);
  return SUCCESS;
}

# 163 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static   result_t CC2420RadioM$CC2420Control$RxMode(void){
#line 163
  unsigned char result;
#line 163

#line 163
  result = CC2420ControlM$CC2420Control$RxMode();
#line 163

#line 163
  return result;
#line 163
}
#line 163
# 294 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline  result_t CC2420RadioM$CC2420SplitControl$startDone(void)
#line 294
{
  uint8_t chkstateRadio;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 297
    chkstateRadio = CC2420RadioM$stateRadio;
#line 297
    __nesc_atomic_end(__nesc_atomic); }

  if (chkstateRadio == CC2420RadioM$WARMUP_STATE) {
      CC2420RadioM$CC2420Control$RxMode();

      CC2420RadioM$FIFOP$startWait(FALSE);

      CC2420RadioM$SFD$enableCapture(TRUE);

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 306
        CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
#line 306
        __nesc_atomic_end(__nesc_atomic); }
    }
  CC2420RadioM$SplitControl$startDone();
  return SUCCESS;
}

# 85 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
inline static  result_t CC2420ControlM$SplitControl$startDone(void){
#line 85
  unsigned char result;
#line 85

#line 85
  result = CC2420RadioM$CC2420SplitControl$startDone();
#line 85

#line 85
  return result;
#line 85
}
#line 85
# 286 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t DesiredFreq)
#line 286
{
  int fsctrl;
  uint8_t status;

  fsctrl = DesiredFreq - 2048;
  CC2420ControlM$gCurrentParameters[CP_FSCTRL] = (CC2420ControlM$gCurrentParameters[CP_FSCTRL] & 0xfc00) | (fsctrl << 0);
  status = CC2420ControlM$HPLChipcon$write(0x18, CC2420ControlM$gCurrentParameters[CP_FSCTRL]);


  if (status & (1 << 6)) {
    CC2420ControlM$HPLChipcon$cmd(0x03);
    }
#line 297
  return SUCCESS;
}

# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0x40e23d00, uint8_t arg_0x40e23e88, uint8_t *arg_0x40e22068){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420RAM$write(arg_0x40e23d00, arg_0x40e23e88, arg_0x40e22068);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 432 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline  result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t addr)
#line 432
{
  addr = toLSB16(addr);
  return CC2420ControlM$HPLChipconRAM$write(0x16A, 2, (uint8_t *)&addr);
}

# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0x40da30b0){
#line 61
  unsigned int result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0x40da30b0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 80 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline bool CC2420ControlM$SetRegs(void)
#line 80
{
  uint16_t data;

  CC2420ControlM$HPLChipcon$write(0x10, CC2420ControlM$gCurrentParameters[CP_MAIN]);
  CC2420ControlM$HPLChipcon$write(0x11, CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]);
  data = CC2420ControlM$HPLChipcon$read(0x11);
  if (data != CC2420ControlM$gCurrentParameters[CP_MDMCTRL0]) {
#line 86
    return FALSE;
    }
  CC2420ControlM$HPLChipcon$write(0x12, CC2420ControlM$gCurrentParameters[CP_MDMCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x13, CC2420ControlM$gCurrentParameters[CP_RSSI]);
  CC2420ControlM$HPLChipcon$write(0x14, CC2420ControlM$gCurrentParameters[CP_SYNCWORD]);
  CC2420ControlM$HPLChipcon$write(0x15, CC2420ControlM$gCurrentParameters[CP_TXCTRL]);
  CC2420ControlM$HPLChipcon$write(0x16, CC2420ControlM$gCurrentParameters[CP_RXCTRL0]);
  CC2420ControlM$HPLChipcon$write(0x17, CC2420ControlM$gCurrentParameters[CP_RXCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x18, CC2420ControlM$gCurrentParameters[CP_FSCTRL]);

  CC2420ControlM$HPLChipcon$write(0x19, CC2420ControlM$gCurrentParameters[CP_SECCTRL0]);
  CC2420ControlM$HPLChipcon$write(0x1A, CC2420ControlM$gCurrentParameters[CP_SECCTRL1]);
  CC2420ControlM$HPLChipcon$write(0x1C, CC2420ControlM$gCurrentParameters[CP_IOCFG0]);
  CC2420ControlM$HPLChipcon$write(0x1D, CC2420ControlM$gCurrentParameters[CP_IOCFG1]);

  CC2420ControlM$HPLChipcon$cmd(0x09);
  CC2420ControlM$HPLChipcon$cmd(0x08);

  return TRUE;
}










static inline  void CC2420ControlM$PostOscillatorOn(void)
#line 116
{

  CC2420ControlM$SetRegs();
  CC2420ControlM$CC2420Control$setShortAddress(TOS_LOCAL_ADDRESS);
  CC2420ControlM$CC2420Control$TuneManual(((CC2420ControlM$gCurrentParameters[CP_FSCTRL] << 0) & 0x1FF) + 2048);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 121
    CC2420ControlM$state = CC2420ControlM$START_STATE_DONE;
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlM$SplitControl$startDone();
}

#line 445
static inline   result_t CC2420ControlM$CCA$fired(void)
#line 445
{

  CC2420ControlM$HPLChipcon$write(0x1D, 0);
  TOS_post(CC2420ControlM$PostOscillatorOn);
  return FAIL;
}

# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420InterruptM$CCA$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420ControlM$CCA$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 171 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static inline   void HPLCC2420InterruptM$CCAInterrupt$fired(void)
#line 171
{
  result_t val = SUCCESS;

#line 173
  HPLCC2420InterruptM$CCAInterrupt$clear();
  val = HPLCC2420InterruptM$CCA$fired();
  if (val == FAIL) {
      HPLCC2420InterruptM$CCAInterrupt$disable();
      HPLCC2420InterruptM$CCAInterrupt$clear();
    }
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port14$fired(void){
#line 59
  HPLCC2420InterruptM$CCAInterrupt$fired();
#line 59
}
#line 59
# 182 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port15$clear(void)
#line 182
{
#line 182
  MSP430InterruptM$P1IFG &= ~(1 << 5);
}

#line 98
static inline    void MSP430InterruptM$Port15$default$fired(void)
#line 98
{
#line 98
  MSP430InterruptM$Port15$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port15$fired(void){
#line 59
  MSP430InterruptM$Port15$default$fired();
#line 59
}
#line 59
# 183 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port16$clear(void)
#line 183
{
#line 183
  MSP430InterruptM$P1IFG &= ~(1 << 6);
}

#line 99
static inline    void MSP430InterruptM$Port16$default$fired(void)
#line 99
{
#line 99
  MSP430InterruptM$Port16$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port16$fired(void){
#line 59
  MSP430InterruptM$Port16$default$fired();
#line 59
}
#line 59
# 184 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port17$clear(void)
#line 184
{
#line 184
  MSP430InterruptM$P1IFG &= ~(1 << 7);
}

#line 100
static inline    void MSP430InterruptM$Port17$default$fired(void)
#line 100
{
#line 100
  MSP430InterruptM$Port17$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port17$fired(void){
#line 59
  MSP430InterruptM$Port17$default$fired();
#line 59
}
#line 59
# 186 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port20$clear(void)
#line 186
{
#line 186
  MSP430InterruptM$P2IFG &= ~(1 << 0);
}

#line 102
static inline    void MSP430InterruptM$Port20$default$fired(void)
#line 102
{
#line 102
  MSP430InterruptM$Port20$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port20$fired(void){
#line 59
  MSP430InterruptM$Port20$default$fired();
#line 59
}
#line 59
# 187 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port21$clear(void)
#line 187
{
#line 187
  MSP430InterruptM$P2IFG &= ~(1 << 1);
}

#line 103
static inline    void MSP430InterruptM$Port21$default$fired(void)
#line 103
{
#line 103
  MSP430InterruptM$Port21$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port21$fired(void){
#line 59
  MSP430InterruptM$Port21$default$fired();
#line 59
}
#line 59
# 188 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port22$clear(void)
#line 188
{
#line 188
  MSP430InterruptM$P2IFG &= ~(1 << 2);
}

#line 104
static inline    void MSP430InterruptM$Port22$default$fired(void)
#line 104
{
#line 104
  MSP430InterruptM$Port22$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port22$fired(void){
#line 59
  MSP430InterruptM$Port22$default$fired();
#line 59
}
#line 59
# 189 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port23$clear(void)
#line 189
{
#line 189
  MSP430InterruptM$P2IFG &= ~(1 << 3);
}

#line 105
static inline    void MSP430InterruptM$Port23$default$fired(void)
#line 105
{
#line 105
  MSP430InterruptM$Port23$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port23$fired(void){
#line 59
  MSP430InterruptM$Port23$default$fired();
#line 59
}
#line 59
# 190 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port24$clear(void)
#line 190
{
#line 190
  MSP430InterruptM$P2IFG &= ~(1 << 4);
}

#line 106
static inline    void MSP430InterruptM$Port24$default$fired(void)
#line 106
{
#line 106
  MSP430InterruptM$Port24$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port24$fired(void){
#line 59
  MSP430InterruptM$Port24$default$fired();
#line 59
}
#line 59
# 191 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port25$clear(void)
#line 191
{
#line 191
  MSP430InterruptM$P2IFG &= ~(1 << 5);
}

#line 107
static inline    void MSP430InterruptM$Port25$default$fired(void)
#line 107
{
#line 107
  MSP430InterruptM$Port25$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port25$fired(void){
#line 59
  MSP430InterruptM$Port25$default$fired();
#line 59
}
#line 59
# 192 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port26$clear(void)
#line 192
{
#line 192
  MSP430InterruptM$P2IFG &= ~(1 << 6);
}

#line 108
static inline    void MSP430InterruptM$Port26$default$fired(void)
#line 108
{
#line 108
  MSP430InterruptM$Port26$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port26$fired(void){
#line 59
  MSP430InterruptM$Port26$default$fired();
#line 59
}
#line 59
# 193 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$Port27$clear(void)
#line 193
{
#line 193
  MSP430InterruptM$P2IFG &= ~(1 << 7);
}

#line 109
static inline    void MSP430InterruptM$Port27$default$fired(void)
#line 109
{
#line 109
  MSP430InterruptM$Port27$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$Port27$fired(void){
#line 59
  MSP430InterruptM$Port27$default$fired();
#line 59
}
#line 59
# 195 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$NMI$clear(void)
#line 195
{
#line 195
  IFG1 &= ~(1 << 4);
}

#line 111
static inline    void MSP430InterruptM$NMI$default$fired(void)
#line 111
{
#line 111
  MSP430InterruptM$NMI$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$NMI$fired(void){
#line 59
  MSP430InterruptM$NMI$default$fired();
#line 59
}
#line 59
# 196 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$OF$clear(void)
#line 196
{
#line 196
  IFG1 &= ~(1 << 1);
}

#line 112
static inline    void MSP430InterruptM$OF$default$fired(void)
#line 112
{
#line 112
  MSP430InterruptM$OF$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$OF$fired(void){
#line 59
  MSP430InterruptM$OF$default$fired();
#line 59
}
#line 59
# 197 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
static inline   void MSP430InterruptM$ACCV$clear(void)
#line 197
{
#line 197
  FCTL3 &= ~0x0004;
}

#line 113
static inline    void MSP430InterruptM$ACCV$default$fired(void)
#line 113
{
#line 113
  MSP430InterruptM$ACCV$clear();
}

# 59 "/opt/tinyos-1.x/tos/platform/msp430/MSP430Interrupt.nc"
inline static   void MSP430InterruptM$ACCV$fired(void){
#line 59
  MSP430InterruptM$ACCV$default$fired();
#line 59
}
#line 59
# 202 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  void FramerM$PacketUnknown(void)
#line 202
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 203
    {
      FramerM$gFlags |= FramerM$FLAGS_UNKNOWN;
    }
#line 205
    __nesc_atomic_end(__nesc_atomic); }

  FramerM$StartTx();
}

# 381 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  TOS_MsgPtr GenericCommProM$UARTReceive$receive(TOS_MsgPtr packet)
#line 381
{

  packet->group = TOS_AM_GROUP;
  return GenericCommProM$received(packet);
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0x40bd2280){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = GenericCommProM$UARTReceive$receive(arg_0x40bd2280);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 91 "/opt/tinyos-1.x/tos/system/FramerAckM.nc"
static inline  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr Msg)
#line 91
{
  TOS_MsgPtr pBuf;

  pBuf = FramerAckM$ReceiveCombined$receive(Msg);

  return pBuf;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40bd2280){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$ReceiveMsg$receive(arg_0x40bd2280);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 329 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t Token)
#line 329
{
  result_t Result = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 332
    {
      if (!(FramerM$gFlags & FramerM$FLAGS_TOKENPEND)) {
          FramerM$gFlags |= FramerM$FLAGS_TOKENPEND;
          FramerM$gTxTokenBuf = Token;
        }
      else {
          Result = FAIL;
        }
    }
#line 340
    __nesc_atomic_end(__nesc_atomic); }

  if (Result == SUCCESS) {
      Result = FramerM$StartTx();
    }

  return Result;
}

# 88 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
inline static  result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x41076710){
#line 88
  unsigned char result;
#line 88

#line 88
  result = FramerM$TokenReceiveMsg$ReflectToken(arg_0x41076710);
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 74 "/opt/tinyos-1.x/tos/system/FramerAckM.nc"
static inline  void FramerAckM$SendAckTask(void)
#line 74
{

  FramerAckM$TokenReceiveMsg$ReflectToken(FramerAckM$gTokenBuf);
}

static inline  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr Msg, uint8_t token)
#line 79
{
  TOS_MsgPtr pBuf;

  FramerAckM$gTokenBuf = token;

  TOS_post(FramerAckM$SendAckTask);

  pBuf = FramerAckM$ReceiveCombined$receive(Msg);

  return pBuf;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
inline static  TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x41077eb0, uint8_t arg_0x41076068){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$TokenReceiveMsg$receive(arg_0x41077eb0, arg_0x41076068);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 210 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline  void FramerM$PacketRcvd(void)
#line 210
{
  FramerM$MsgRcvEntry_t *pRcv = &FramerM$gMsgRcvTbl[FramerM$gRxTailIndex];
  TOS_MsgPtr pBuf = pRcv->pMsg;


  if (pRcv->Length >= (size_t )& ((TOS_Msg *)0)->data) {

      switch (pRcv->Proto) {
          case FramerM$PROTO_ACK: 
            break;
          case FramerM$PROTO_PACKET_ACK: 
            pBuf->crc = 1;
          pBuf = FramerM$TokenReceiveMsg$receive(pBuf, pRcv->Token);
          break;
          case FramerM$PROTO_PACKET_NOACK: 
            pBuf->crc = 1;
          pBuf = FramerM$ReceiveMsg$receive(pBuf);
          break;
          default: 
            FramerM$gTxUnknownBuf = pRcv->Proto;
          TOS_post(FramerM$PacketUnknown);
          break;
        }
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 235
    {
      if (pBuf) {
          pRcv->pMsg = pBuf;
        }
      pRcv->Length = 0;
      pRcv->Token = 0;
      FramerM$gRxTailIndex++;
      FramerM$gRxTailIndex %= FramerM$HDLC_QUEUESIZE;
    }
#line 243
    __nesc_atomic_end(__nesc_atomic); }
}

#line 349
static inline   result_t FramerM$ByteComm$rxByteReady(uint8_t data, bool error, uint16_t strength)
#line 349
{

  switch (FramerM$gRxState) {

      case FramerM$RXSTATE_NOSYNC: 
        if (data == FramerM$HDLC_FLAG_BYTE && FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length == 0) {
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
            FramerM$gRxState = FramerM$RXSTATE_PROTO;
          }
      break;

      case FramerM$RXSTATE_PROTO: 
        if (data == FramerM$HDLC_FLAG_BYTE) {
            break;
          }
      FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Proto = data;
      FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, data);
      switch (data) {
          case FramerM$PROTO_PACKET_ACK: 
            FramerM$gRxState = FramerM$RXSTATE_TOKEN;
          break;
          case FramerM$PROTO_PACKET_NOACK: 
            FramerM$gRxState = FramerM$RXSTATE_INFO;
          break;
          default: 
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          break;
        }
      break;

      case FramerM$RXSTATE_TOKEN: 
        if (data == FramerM$HDLC_FLAG_BYTE) {
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
#line 385
          if (data == FramerM$HDLC_CTLESC_BYTE) {
              FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0x20;
            }
          else {
              FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token ^= data;
              FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token);
              FramerM$gRxState = FramerM$RXSTATE_INFO;
            }
          }
#line 393
      break;


      case FramerM$RXSTATE_INFO: 
        if (FramerM$gRxByteCnt > FramerM$HDLC_MTU) {
            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
#line 403
          if (data == FramerM$HDLC_CTLESC_BYTE) {
              FramerM$gRxState = FramerM$RXSTATE_ESC;
            }
          else {
#line 406
            if (data == FramerM$HDLC_FLAG_BYTE) {
                if (FramerM$gRxByteCnt >= 2) {
                    uint16_t usRcvdCRC = FramerM$gpRxBuf[FramerM$gRxByteCnt - 1] & 0xff;

#line 409
                    usRcvdCRC = (usRcvdCRC << 8) | (FramerM$gpRxBuf[FramerM$gRxByteCnt - 2] & 0xff);
                    if (usRcvdCRC == FramerM$gRxRunningCRC) {
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = FramerM$gRxByteCnt - 2;
                        TOS_post(FramerM$PacketRcvd);
                        FramerM$gRxHeadIndex++;
#line 413
                        FramerM$gRxHeadIndex %= FramerM$HDLC_QUEUESIZE;
                      }
                    else {
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
                        FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
                      }
                    if (FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length == 0) {
                        FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
                        FramerM$gRxState = FramerM$RXSTATE_PROTO;
                      }
                    else {
                        FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
                      }
                  }
                else {
                    FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
                    FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
                    FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
                  }
                FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
              }
            else {
                FramerM$gpRxBuf[FramerM$gRxByteCnt] = data;
                if (FramerM$gRxByteCnt >= 2) {
                    FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gpRxBuf[FramerM$gRxByteCnt - 2]);
                  }
                FramerM$gRxByteCnt++;
              }
            }
          }
#line 441
      break;

      case FramerM$RXSTATE_ESC: 
        if (data == FramerM$HDLC_FLAG_BYTE) {

            FramerM$gRxByteCnt = FramerM$gRxRunningCRC = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Length = 0;
            FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].Token = 0;
            FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
          }
        else {
            data = data ^ 0x20;
            FramerM$gpRxBuf[FramerM$gRxByteCnt] = data;
            if (FramerM$gRxByteCnt >= 2) {
                FramerM$gRxRunningCRC = crcByte(FramerM$gRxRunningCRC, FramerM$gpRxBuf[FramerM$gRxByteCnt - 2]);
              }
            FramerM$gRxByteCnt++;
            FramerM$gRxState = FramerM$RXSTATE_INFO;
          }
      break;

      default: 
        FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
      break;
    }

  return SUCCESS;
}

# 66 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0x4106eb30, bool arg_0x4106ecb8, uint16_t arg_0x4106ee50){
#line 66
  unsigned char result;
#line 66

#line 66
  result = FramerM$ByteComm$rxByteReady(arg_0x4106eb30, arg_0x4106ecb8, arg_0x4106ee50);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 77 "/opt/tinyos-1.x/tos/system/UARTM.nc"
static inline   result_t UARTM$HPLUART$get(uint8_t data)
#line 77
{




  UARTM$ByteComm$rxByteReady(data, FALSE, 0);
  {
  }
#line 83
  ;
  return SUCCESS;
}

# 88 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t HPLUARTM$UART$get(uint8_t arg_0x410c4c58){
#line 88
  unsigned char result;
#line 88

#line 88
  result = UARTM$HPLUART$get(arg_0x410c4c58);
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 90 "/opt/tinyos-1.x/tos/platform/msp430/HPLUARTM.nc"
static inline   result_t HPLUARTM$USARTData$rxDone(uint8_t b)
#line 90
{
  return HPLUARTM$UART$get(b);
}

# 53 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
inline static   result_t HPLUSART1M$USARTData$rxDone(uint8_t arg_0x40ee6c40){
#line 53
  unsigned char result;
#line 53

#line 53
  result = HPLUARTM$USARTData$rxDone(arg_0x40ee6c40);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t FramerM$ByteComm$txByte(uint8_t arg_0x4106e5e0){
#line 55
  unsigned char result;
#line 55

#line 55
  result = UARTM$ByteComm$txByte(arg_0x4106e5e0);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 483 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline   result_t FramerM$ByteComm$txByteReady(bool LastByteSuccess)
#line 483
{
  result_t TxResult = SUCCESS;
  uint8_t nextByte;

  if (LastByteSuccess != TRUE) {
      /* atomic removed: atomic calls only */
#line 488
      FramerM$gTxState = FramerM$TXSTATE_ERROR;
      TOS_post(FramerM$PacketSent);
      return SUCCESS;
    }

  switch (FramerM$gTxState) {

      case FramerM$TXSTATE_PROTO: 
        FramerM$gTxState = FramerM$TXSTATE_INFO;
      FramerM$gTxRunningCRC = crcByte(FramerM$gTxRunningCRC, (uint8_t )(FramerM$gTxProto & 0x0FF));
      TxResult = FramerM$ByteComm$txByte((uint8_t )(FramerM$gTxProto & 0x0FF));
      break;

      case FramerM$TXSTATE_INFO: 
        nextByte = FramerM$gpTxBuf[FramerM$gTxByteCnt];

      FramerM$gTxRunningCRC = crcByte(FramerM$gTxRunningCRC, nextByte);
      FramerM$gTxByteCnt++;
      if (FramerM$gTxByteCnt >= FramerM$gTxLength) {
          FramerM$gTxState = FramerM$TXSTATE_FCS1;
        }

      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_ESC: 

        TxResult = FramerM$ByteComm$txByte(FramerM$gTxEscByte ^ 0x20);
      FramerM$gTxState = FramerM$gPrevTxState;
      break;

      case FramerM$TXSTATE_FCS1: 
        nextByte = (uint8_t )(FramerM$gTxRunningCRC & 0xff);
      FramerM$gTxState = FramerM$TXSTATE_FCS2;
      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_FCS2: 
        nextByte = (uint8_t )((FramerM$gTxRunningCRC >> 8) & 0xff);
      FramerM$gTxState = FramerM$TXSTATE_ENDFLAG;
      TxResult = FramerM$TxArbitraryByte(nextByte);
      break;

      case FramerM$TXSTATE_ENDFLAG: 
        FramerM$gTxState = FramerM$TXSTATE_FINISH;
      TxResult = FramerM$ByteComm$txByte(FramerM$HDLC_FLAG_BYTE);

      break;

      case FramerM$TXSTATE_FINISH: 
        case FramerM$TXSTATE_ERROR: 

          default: 
            break;
    }


  if (TxResult != SUCCESS) {
      FramerM$gTxState = FramerM$TXSTATE_ERROR;
      TOS_post(FramerM$PacketSent);
    }

  return SUCCESS;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$txByteReady(bool arg_0x4106d4d8){
#line 75
  unsigned char result;
#line 75

#line 75
  result = FramerM$ByteComm$txByteReady(arg_0x4106d4d8);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 553 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static inline   result_t FramerM$ByteComm$txDone(void)
#line 553
{

  if (FramerM$gTxState == FramerM$TXSTATE_FINISH) {
      FramerM$gTxState = FramerM$TXSTATE_IDLE;
      TOS_post(FramerM$PacketSent);
    }

  return SUCCESS;
}

# 83 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t UARTM$ByteComm$txDone(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = FramerM$ByteComm$txDone();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 87 "/opt/tinyos-1.x/tos/system/UARTM.nc"
static inline   result_t UARTM$HPLUART$putDone(void)
#line 87
{
  bool oldState;

  /* atomic removed: atomic calls only */
#line 90
  {
    {
    }
#line 91
    ;
    oldState = UARTM$state;
    UARTM$state = FALSE;
  }








  if (oldState) {
      UARTM$ByteComm$txDone();
      UARTM$ByteComm$txByteReady(TRUE);
    }
  return SUCCESS;
}

# 96 "/opt/tinyos-1.x/tos/interfaces/HPLUART.nc"
inline static   result_t HPLUARTM$UART$putDone(void){
#line 96
  unsigned char result;
#line 96

#line 96
  result = UARTM$HPLUART$putDone();
#line 96

#line 96
  return result;
#line 96
}
#line 96
# 94 "/opt/tinyos-1.x/tos/platform/msp430/HPLUARTM.nc"
static inline   result_t HPLUARTM$USARTData$txDone(void)
#line 94
{
  return HPLUARTM$UART$putDone();
}

# 46 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSARTFeedback.nc"
inline static   result_t HPLUSART1M$USARTData$txDone(void){
#line 46
  unsigned char result;
#line 46

#line 46
  result = HPLUARTM$USARTData$txDone();
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 496 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$HPLADC12$memOverflow(void)
#line 496
{
}

# 248 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline   void RefVoltM$HPLADC12$memOverflow(void)
#line 248
{
}

# 61 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void HPLADC12M$HPLADC12$memOverflow(void){
#line 61
  RefVoltM$HPLADC12$memOverflow();
#line 61
  MSP430ADC12M$HPLADC12$memOverflow();
#line 61
}
#line 61
# 497 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$HPLADC12$timeOverflow(void)
#line 497
{
}

# 249 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline   void RefVoltM$HPLADC12$timeOverflow(void)
#line 249
{
}

# 62 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void HPLADC12M$HPLADC12$timeOverflow(void){
#line 62
  RefVoltM$HPLADC12$timeOverflow();
#line 62
  MSP430ADC12M$HPLADC12$timeOverflow();
#line 62
}
#line 62
#line 58
inline static   void MSP430ADC12M$HPLADC12$resetIFGs(void){
#line 58
  HPLADC12M$HPLADC12$resetIFGs();
#line 58
}
#line 58
# 413 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline    uint16_t *MSP430ADC12M$ADCMultiple$default$dataReady(uint8_t num, uint16_t *buf, 
uint16_t length)
{
  return (uint16_t *)0;
}

# 167 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
inline static   uint16_t *MSP430ADC12M$ADCMultiple$dataReady(uint8_t arg_0x413bb8d8, uint16_t *arg_0x413b0010, uint16_t arg_0x413b01a0){
#line 167
  unsigned int *result;
#line 167

#line 167
  switch (arg_0x413bb8d8) {
#line 167
    case 3U:
#line 167
      result = HamamatsuM$MSP430ADC12MultiplePAR$dataReady(arg_0x413b0010, arg_0x413b01a0);
#line 167
      break;
#line 167
    case 4U:
#line 167
      result = HamamatsuM$MSP430ADC12MultipleTSR$dataReady(arg_0x413b0010, arg_0x413b01a0);
#line 167
      break;
#line 167
    default:
#line 167
      result = MSP430ADC12M$ADCMultiple$default$dataReady(arg_0x413bb8d8, arg_0x413b0010, arg_0x413b01a0);
#line 167
      break;
#line 167
    }
#line 167

#line 167
  return result;
#line 167
}
#line 167
# 91 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   uint16_t HPLADC12M$HPLADC12$getMem(uint8_t i)
#line 91
{
  return *((uint16_t *)(int *)0x0140 + i);
}

# 52 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   uint16_t MSP430ADC12M$HPLADC12$getMem(uint8_t arg_0x413f9010){
#line 52
  unsigned int result;
#line 52

#line 52
  result = HPLADC12M$HPLADC12$getMem(arg_0x413f9010);
#line 52

#line 52
  return result;
#line 52
}
#line 52
#line 50
inline static   void MSP430ADC12M$HPLADC12$setMemControl(uint8_t arg_0x413fa4b8, adc12memctl_t arg_0x413fa650){
#line 50
  HPLADC12M$HPLADC12$setMemControl(arg_0x413fa4b8, arg_0x413fa650);
#line 50
}
#line 50
# 81 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   adc12memctl_t HPLADC12M$HPLADC12$getMemControl(uint8_t i)
#line 81
{
  adc12memctl_t x = { .inch = 0, .sref = 0, .eos = 0 };
  uint8_t *memCtlPtr = (uint8_t *)(char *)0x0080;

#line 84
  if (i < 16) {
      memCtlPtr += i;
      x = * (adc12memctl_t *)memCtlPtr;
    }
  return x;
}

# 51 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   adc12memctl_t MSP430ADC12M$HPLADC12$getMemControl(uint8_t arg_0x413fab10){
#line 51
  struct __nesc_unnamed4262 result;
#line 51

#line 51
  result = HPLADC12M$HPLADC12$getMemControl(arg_0x413fab10);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 218 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static inline    result_t HamamatsuM$TSRSingle$default$dataReady(adcresult_t result, uint16_t data)
{
  return FAIL;
}

# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
inline static   result_t HamamatsuM$TSRSingle$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8){
#line 105
  unsigned char result;
#line 105

#line 105
  result = HamamatsuM$TSRSingle$default$dataReady(arg_0x4135a928, arg_0x4135aab8);
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 212 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static inline   result_t HamamatsuM$MSP430ADC12SingleTSR$dataReady(uint16_t data)
{
  return HamamatsuM$TSRSingle$dataReady(ADC_SUCCESS, data);
}

#line 111
static inline    result_t HamamatsuM$PARSingle$default$dataReady(adcresult_t result, uint16_t data)
{
  return FAIL;
}

# 105 "/opt/tinyos-1.x/tos/platform/msp430/ADCSingle.nc"
inline static   result_t HamamatsuM$PARSingle$dataReady(adcresult_t arg_0x4135a928, uint16_t arg_0x4135aab8){
#line 105
  unsigned char result;
#line 105

#line 105
  result = HamamatsuM$PARSingle$default$dataReady(arg_0x4135a928, arg_0x4135aab8);
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 105 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static inline   result_t HamamatsuM$MSP430ADC12SinglePAR$dataReady(uint16_t data)
{
  return HamamatsuM$PARSingle$dataReady(ADC_SUCCESS, data);
}

# 409 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline    result_t MSP430ADC12M$ADCSingle$default$dataReady(uint8_t num, uint16_t data)
{
  return FAIL;
}

# 131 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
inline static   result_t MSP430ADC12M$ADCSingle$dataReady(uint8_t arg_0x413bcd90, uint16_t arg_0x4133cdc8){
#line 131
  unsigned char result;
#line 131

#line 131
  switch (arg_0x413bcd90) {
#line 131
    case 0U:
#line 131
      result = ADCM$MSP430ADC12Single$dataReady(arg_0x4133cdc8);
#line 131
      break;
#line 131
    case 1U:
#line 131
      result = HamamatsuM$MSP430ADC12SinglePAR$dataReady(arg_0x4133cdc8);
#line 131
      break;
#line 131
    case 2U:
#line 131
      result = HamamatsuM$MSP430ADC12SingleTSR$dataReady(arg_0x4133cdc8);
#line 131
      break;
#line 131
    default:
#line 131
      result = MSP430ADC12M$ADCSingle$default$dataReady(arg_0x413bcd90, arg_0x4133cdc8);
#line 131
      break;
#line 131
    }
#line 131

#line 131
  return result;
#line 131
}
#line 131
# 441 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   void MSP430ADC12M$HPLADC12$converted(uint8_t number)
#line 441
{
  switch (MSP430ADC12M$cmode) 
    {
      case SINGLE_CHANNEL: 
        {
          volatile uint8_t ownerTmp = MSP430ADC12M$owner;

#line 447
          MSP430ADC12M$stopConversion();
          MSP430ADC12M$ADCSingle$dataReady(ownerTmp, MSP430ADC12M$HPLADC12$getMem(0));
        }
      break;
      case REPEAT_SINGLE_CHANNEL: 
        if (MSP430ADC12M$ADCSingle$dataReady(MSP430ADC12M$owner, MSP430ADC12M$HPLADC12$getMem(0)) == FAIL) {
          MSP430ADC12M$stopConversion();
          }
#line 454
      break;
      case SEQUENCE_OF_CHANNELS: 
        {
          uint16_t i = 0;
#line 457
          uint16_t length = MSP430ADC12M$bufLength - MSP430ADC12M$bufOffset > 16 ? 16 : MSP430ADC12M$bufLength - MSP430ADC12M$bufOffset;

#line 458
          do {
              * MSP430ADC12M$bufPtr++ = MSP430ADC12M$HPLADC12$getMem(i);
            }
          while (
#line 460
          ++i < length);

          MSP430ADC12M$bufOffset += length;

          if (MSP430ADC12M$bufLength - MSP430ADC12M$bufOffset > 15) {
            return;
            }
          else {
#line 466
            if (MSP430ADC12M$bufLength - MSP430ADC12M$bufOffset > 0) {
                adc12memctl_t memctl = MSP430ADC12M$HPLADC12$getMemControl(0);

#line 468
                memctl.eos = 1;
                MSP430ADC12M$HPLADC12$setMemControl(MSP430ADC12M$bufLength - MSP430ADC12M$bufOffset, memctl);
              }
            else 
#line 470
              {
                MSP430ADC12M$stopConversion();
                MSP430ADC12M$ADCMultiple$dataReady(MSP430ADC12M$owner, MSP430ADC12M$bufPtr - MSP430ADC12M$bufLength, MSP430ADC12M$bufLength);
              }
            }
        }
#line 475
      break;
      case REPEAT_SEQUENCE_OF_CHANNELS: 
        {
          uint8_t i = 0;

#line 479
          do {
              * MSP430ADC12M$bufPtr++ = MSP430ADC12M$HPLADC12$getMem(i);
            }
          while (
#line 481
          ++i < MSP430ADC12M$bufLength);

          if ((
#line 482
          MSP430ADC12M$bufPtr = MSP430ADC12M$ADCMultiple$dataReady(MSP430ADC12M$owner, MSP430ADC12M$bufPtr - MSP430ADC12M$bufLength, 
          MSP430ADC12M$bufLength)) == 0) {
            MSP430ADC12M$stopConversion();
            }
#line 485
          break;
        }
      default: 
        {

          MSP430ADC12M$HPLADC12$resetIFGs();
        }
      break;
    }
}

# 250 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline   void RefVoltM$HPLADC12$converted(uint8_t number)
#line 250
{
}

# 63 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void HPLADC12M$HPLADC12$converted(uint8_t arg_0x413f8a00){
#line 63
  RefVoltM$HPLADC12$converted(arg_0x413f8a00);
#line 63
  MSP430ADC12M$HPLADC12$converted(arg_0x413f8a00);
#line 63
}
#line 63
# 117 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static inline   void HPLADC12M$HPLADC12$stopConversion(void)
#line 117
{
  HPLADC12M$ADC12CTL1 &= ~((1 << 1) | (3 << 1));
  HPLADC12M$ADC12CTL0 &= ~0x0002;
}

# 82 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12.nc"
inline static   void MSP430ADC12M$HPLADC12$stopConversion(void){
#line 82
  HPLADC12M$HPLADC12$stopConversion();
#line 82
}
#line 82
# 225 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static inline  void RefVoltM$switchOffDelay(void)
#line 225
{
  if (RefVoltM$switchOff == TRUE) {
    RefVoltM$SwitchOffTimer$setOneShot(100);
    }
}

#line 180
static inline   result_t RefVoltM$RefVolt$release(void)
#line 180
{
  result_t result = FAIL;

  /* atomic removed: atomic calls only */
#line 183
  {
    if (RefVoltM$semaCount <= 0) {
      result = FAIL;
      }
    else 
#line 186
      {
        RefVoltM$semaCount--;
        if (RefVoltM$semaCount == 0) {
            if (RefVoltM$state == RefVoltM$REFERENCE_1_5V_PENDING || 
            RefVoltM$state == RefVoltM$REFERENCE_2_5V_PENDING) {
                RefVoltM$switchOff = TRUE;
                RefVoltM$switchRefOff();
              }
            else {
                RefVoltM$switchOff = TRUE;
                TOS_post(RefVoltM$switchOffDelay);
              }
            result = SUCCESS;
          }
      }
  }
  return result;
}

# 109 "/opt/tinyos-1.x/tos/platform/msp430/RefVolt.nc"
inline static   result_t MSP430ADC12M$RefVolt$release(void){
#line 109
  unsigned char result;
#line 109

#line 109
  result = RefVoltM$RefVolt$release();
#line 109

#line 109
  return result;
#line 109
}
#line 109
# 158 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline result_t MSP430ADC12M$releaseRefVolt(uint8_t num)
{
  if (MSP430ADC12M$adc12settings[num].gotRefVolt == 1) {
      MSP430ADC12M$RefVolt$release();
      MSP430ADC12M$adc12settings[num].gotRefVolt = 0;
      return SUCCESS;
    }
  return FAIL;
}

#line 331
static inline result_t MSP430ADC12M$unreserve(uint8_t num)
{
  if (MSP430ADC12M$reserved & RESERVED && MSP430ADC12M$owner == num) {
      MSP430ADC12M$cmode = MSP430ADC12M$reserved = ADC_IDLE;
      return SUCCESS;
    }
  return FAIL;
}

#line 365
static inline   result_t MSP430ADC12M$ADCSingle$unreserve(uint8_t num)
{
  return MSP430ADC12M$unreserve(num);
}

# 117 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Single.nc"
inline static   result_t ADCM$MSP430ADC12Single$unreserve(void){
#line 117
  unsigned char result;
#line 117

#line 117
  result = MSP430ADC12M$ADCSingle$unreserve(0U);
#line 117

#line 117
  return result;
#line 117
}
#line 117
# 645 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline   result_t SmartSensingM$ADC$dataReady(uint8_t client, uint16_t data)
#line 645
{
  /* atomic removed: atomic calls only */




  SmartSensingM$saveData(client, data);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t ADCM$ADC$dataReady(uint8_t arg_0x41345b10, uint16_t arg_0x40a7c788){
#line 70
  unsigned char result;
#line 70

#line 70
  result = SmartSensingM$ADC$dataReady(arg_0x41345b10, arg_0x40a7c788);
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 356 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteControl$getQuality(void)
#line 356
{
  return MultiHopLQI$gbLinkQuality;
}

# 84 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
inline static  uint16_t MultiHopEngineM$RouteSelectCntl$getQuality(void){
#line 84
  unsigned int result;
#line 84

#line 84
  result = MultiHopLQI$RouteControl$getQuality();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 535 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static inline  uint16_t MultiHopEngineM$RouteControl$getQuality(void)
#line 535
{
  return MultiHopEngineM$RouteSelectCntl$getQuality();
}

# 84 "/home/xu/oasis/lib/MultiHopOasis/RouteControl.nc"
inline static  uint16_t SmartSensingM$RouteControl$getQuality(void){
#line 84
  unsigned int result;
#line 84

#line 84
  result = MultiHopEngineM$RouteControl$getQuality();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 306 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$DataMgmt$saveBlk(void *obj, uint8_t mediumType)
#line 306
{
  result_t result = FAIL;

#line 308
  if (obj != 0) {
      result = changeMemStatus(&DataMgmtM$sensorMem, (SenBlkPtr )obj, ((SenBlkPtr )obj)->status, FILLED);
    }

  return result;
}

# 30 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
inline static  result_t SmartSensingM$DataMgmt$saveBlk(void *arg_0x40ad0110, uint8_t arg_0x40ad02a0){
#line 30
  unsigned char result;
#line 30

#line 30
  result = DataMgmtM$DataMgmt$saveBlk(arg_0x40ad0110, arg_0x40ad02a0);
#line 30

#line 30
  return result;
#line 30
}
#line 30
# 172 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static inline    uint16_t *HamamatsuM$PARMultiple$default$dataReady(adcresult_t result, uint16_t *buf, uint16_t length)
{
  return 0;
}

# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
inline static   uint16_t *HamamatsuM$PARMultiple$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0){
#line 129
  unsigned int *result;
#line 129

#line 129
  result = HamamatsuM$PARMultiple$default$dataReady(arg_0x41380170, arg_0x41380320, arg_0x413804b0);
#line 129

#line 129
  return result;
#line 129
}
#line 129
# 370 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static inline   msp430ADCresult_t MSP430ADC12M$ADCMultiple$getData(uint8_t num, uint16_t *buf, 
uint16_t length, uint16_t jiffies)
{
  return MSP430ADC12M$newRequest(SEQUENCE_OF_CHANNELS, num, buf, length, jiffies);
}

# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
inline static   msp430ADCresult_t HamamatsuM$MSP430ADC12MultiplePAR$getData(uint16_t *arg_0x413b57e8, uint16_t arg_0x413b5978, uint16_t arg_0x413b5b08){
#line 82
  enum __nesc_unnamed4259 result;
#line 82

#line 82
  result = MSP430ADC12M$ADCMultiple$getData(3U, arg_0x413b57e8, arg_0x413b5978, arg_0x413b5b08);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 279 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static inline    uint16_t *HamamatsuM$TSRMultiple$default$dataReady(adcresult_t result, uint16_t *buf, uint16_t length)
{
  return 0;
}

# 129 "/opt/tinyos-1.x/tos/platform/msp430/ADCMultiple.nc"
inline static   uint16_t *HamamatsuM$TSRMultiple$dataReady(adcresult_t arg_0x41380170, uint16_t *arg_0x41380320, uint16_t arg_0x413804b0){
#line 129
  unsigned int *result;
#line 129

#line 129
  result = HamamatsuM$TSRMultiple$default$dataReady(arg_0x41380170, arg_0x41380320, arg_0x413804b0);
#line 129

#line 129
  return result;
#line 129
}
#line 129
# 82 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ADC12Multiple.nc"
inline static   msp430ADCresult_t HamamatsuM$MSP430ADC12MultipleTSR$getData(uint16_t *arg_0x413b57e8, uint16_t arg_0x413b5978, uint16_t arg_0x413b5b08){
#line 82
  enum __nesc_unnamed4259 result;
#line 82

#line 82
  result = MSP430ADC12M$ADCMultiple$getData(4U, arg_0x413b57e8, arg_0x413b5978, arg_0x413b5b08);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 102 "/opt/tinyos-1.x/tos/system/sched.c"
 bool TOS_post(void (*tp)(void))
#line 102
{
  __nesc_atomic_t fInterruptFlags;
  uint8_t tmp;



  fInterruptFlags = __nesc_atomic_start();

  tmp = TOSH_sched_free;

  if (TOSH_queue[tmp].tp == NULL) {
      TOSH_sched_free = (tmp + 1) & TOSH_TASK_BITMASK;
      TOSH_queue[tmp].tp = tp;
      __nesc_atomic_end(fInterruptFlags);

      return TRUE;
    }
  else {
      __nesc_atomic_end(fInterruptFlags);

      return FALSE;
    }
}

# 52 "/opt/tinyos-1.x/tos/platform/msp430/MainM.nc"
  int main(void)
{
  MainM$hardwareInit();
  TOSH_sched_init();

  MainM$StdControl$init();
  MainM$StdControl$start();
  __nesc_enable_interrupt();

  for (; ; ) {
#line 61
      TOSH_run_task();
    }
}

# 83 "/opt/tinyos-1.x/tos/platform/telosb/hardware.h"
static void TOSH_FLASH_M25P_DP_bit(bool set)
#line 83
{
  if (set) {
    TOSH_SET_SIMO0_PIN();
    }
  else {
#line 87
    TOSH_CLR_SIMO0_PIN();
    }
#line 88
  TOSH_SET_UCLK0_PIN();
  TOSH_CLR_UCLK0_PIN();
}

# 139 "/opt/tinyos-1.x/tos/platform/msp430/MSP430ClockM.nc"
static void MSP430ClockM$set_dco_calib(int calib)
{
  BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
  DCOCTL = calib & 0xff;
}

# 72 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static  result_t TimerM$StdControl$init(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 74
    TimerM$m_hinow = 0;
#line 74
    __nesc_atomic_end(__nesc_atomic); }
  TimerM$m_head_short = TimerM$EMPTY_LIST;
  TimerM$m_head_long = TimerM$EMPTY_LIST;
  bzero(TimerM$m_timers, sizeof TimerM$m_timers);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 78
    TimerM$m_posted_checkShortTimers = FALSE;
#line 78
    __nesc_atomic_end(__nesc_atomic); }
  TimerM$AlarmControl$setControlAsCompare();
  TimerM$AlarmControl$disableEvents();
  return SUCCESS;
}

# 98 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
static uint16_t MSP430TimerM$compareControl(void)
{
  MSP430TimerM$CC_t x = { 
  .cm = 1, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 0, 
  .ccie = 0 };

  return MSP430TimerM$CC2int(x);
}

# 100 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static  result_t ADCM$ADCControl$init(void)
{
  if (!ADCM$initialized) {
      ADCM$samplingRate = 0xFF;
      ADCM$g_port = 0;
      ADCM$initialized = 1;
    }

  return SUCCESS;
}

# 44 "/home/xu/oasis/system/buffer.h"
static result_t initBufferPool(Queue_t *bufQueue, uint16_t size, TOS_Msg *bufPool)
#line 44
{
  result_t result;
  int16_t ind;

  if (SUCCESS != (result = initQueue(bufQueue, size))) {
    return FAIL;
    }
  for (ind = 0; ind < size; ind++) 
    {
      if (SUCCESS != insertElement(bufQueue, &bufPool[ind])) {
#line 53
        return FAIL;
        }
    }
#line 55
  ;
  return SUCCESS;
}

# 90 "/home/xu/oasis/system/queue.h"
static result_t initQueue(Queue_t *queue, uint16_t size)
#line 90
{

  int16_t i;

  if (size > MAX_QUEUE_SIZE || size <= 0) {
      ;
      return FAIL;
    }

  queue->size = size;
  queue->total = 0;
  queue->head[FREE] = 0;
  queue->tail[FREE] = size - 1;
  queue->head[PENDING] = queue->tail[PENDING] = -1;
  queue->head[PROCESSING] = queue->tail[PROCESSING] = -1;








  for (i = 0; i < size; i++) {
      queue->element[i].status = FREE;
      queue->element[i].obj = NULL;
      queue->element[i].prev = i - 1;
      queue->element[i].retry = 0;

      queue->element[i].priority = 0;










      if (i < size - 1) {
        queue->element[i].next = i + 1;
        }
      else {
#line 133
        queue->element[i].next = -1;
        }
    }
  return SUCCESS;
}








static result_t insertElement(Queue_t *queue, object_type *obj)
#line 146
{

  int16_t ind;



  if (queue->size <= 0) {
      ;
      return FAIL;
    }



  if (queue->total >= queue->size) {

      return FAIL;
    }



  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].status != FREE && queue->element[ind].obj == obj) {
          ;
          return FAIL;
        }
    }


  ind = queue->head[FREE];
  queue->element[ind].obj = obj;
  queue->element[ind].retry = 0;









  _private_changeElementStatusByIndex(queue, ind, FREE, PENDING);

  queue->total++;
  ;

  return SUCCESS;
}

#line 559
static void _private_changeElementStatusByIndex(Queue_t *queue, int16_t ind, ObjStatus_t status1, ObjStatus_t status2)
#line 559
{

  int16_t _prev;
#line 561
  int16_t _next;
#line 561
  int16_t tail2;

  if (queue->element[ind].status != status1) 
    {
      ;
      return;
    }

  if (queue->element[ind].status == status2) {
      ;
      return;
    }


  _prev = queue->element[ind].prev;
  _next = queue->element[ind].next;
  if (_prev != -1) {
    queue->element[_prev].next = _next;
    }
  else {
#line 580
    queue->head[status1] = _next;
    }
  if (_next != -1) {
    queue->element[_next].prev = _prev;
    }
  else {
#line 585
    queue->tail[status1] = _prev;
    }

  tail2 = queue->tail[status2];
  if (tail2 != -1) {
      queue->element[tail2].next = ind;
    }
  else {
      queue->head[status2] = ind;
    }

  queue->element[ind].status = status2;
  queue->element[ind].prev = tail2;
  queue->element[ind].next = -1;
  queue->tail[status2] = ind;

  return;
}

# 191 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t client)
#line 191
{
  SenBlkPtr p = NULL;
  result_t result = SUCCESS;

  if (sensor[client].maxBlkNum != 0) {
      if (sensor[client].curBlkNum >= sensor[client].maxBlkNum) {
          result = DataMgmtM$DataMgmt$freeBlkByType(sensor[client].type);
        }
    }

  if (FAIL != result) {
      p = allocSensorMem(&DataMgmtM$sensorMem);
      if (p != NULL) {
          sensor[client].curBlkNum++;

          DataMgmtM$Leds$yellowToggle();
        }
      else 
#line 207
        {
        }
    }







  return p;
}

# 125 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
static SenBlkPtr headMemElement(MemQueue_t *queue, MemStatus_t status)
#line 125
{
  int16_t ind;

#line 127
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 127
    ind = queue->head[status];
#line 127
    __nesc_atomic_end(__nesc_atomic); }
  if (ind == -1) {
      return NULL;
    }
  else {
      return &queue->element[ind];
    }
}

# 228 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  result_t DataMgmtM$DataMgmt$freeBlk(void *obj)
#line 228
{
  uint8_t i = 0;
  result_t result = FAIL;
  SenBlkPtr p = 0;
  uint8_t type = 0;


  if (obj == 0) {

      return result;
    }
  p = (SenBlkPtr )obj;
  type = p->type;
  result = freeSensorMem(&DataMgmtM$sensorMem, p);
  if (result != FAIL) {
      for (i = 0; i <= sensor_num; i++) {
          if (sensor[i].type == type) {
              if (sensor[i].curBlkNum > 0) {
                  sensor[i].curBlkNum--;
                }
            }
        }
    }
  else 
#line 250
    {
    }


  return result;
}

# 263 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
static result_t _private_changeMemStatusByIndex(MemQueue_t *queue, int16_t ind, MemStatus_t status1, MemStatus_t status2)
#line 263
{

  int16_t _prev;
#line 265
  int16_t _next;
#line 265
  int16_t tail2;

  if (queue->element[ind].status != status1) {
      ;


      return FAIL;
    }

  if (queue->element[ind].status == status2) {
      ;


      return FAIL;
    }


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 282
    {
      _prev = queue->element[ind].prev;
      _next = queue->element[ind].next;
    }
#line 285
    __nesc_atomic_end(__nesc_atomic); }
  if (_prev != -1) {
    queue->element[_prev].next = _next;
    }
  else {
#line 289
    queue->head[status1] = _next;
    }
  if (_next != -1) {
    queue->element[_next].prev = _prev;
    }
  else {
#line 294
    queue->tail[status1] = _prev;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 297
    tail2 = queue->tail[status2];
#line 297
    __nesc_atomic_end(__nesc_atomic); }
  if (tail2 != -1) {
      queue->element[tail2].next = ind;
    }
  else {
      queue->head[status2] = ind;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 305
    {
      queue->element[ind].status = status2;
      queue->element[ind].prev = tail2;
      queue->element[ind].next = -1;
      queue->tail[status2] = ind;
    }
#line 310
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 147
static SenBlkPtr getMemElementByIndex(MemQueue_t *queue, int16_t ind)
#line 147
{
  if (ind >= queue->size || ind < 0) {
      return NULL;
    }
  else {
      return &queue->element[ind];
    }
}

# 127 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static  result_t ADCM$ADCControl$bindPort(uint8_t port, uint8_t adcPort)
{
  if (port < ADCM$TOSH_ADC_PORTMAPSIZE) {
      ADCM$TOSH_adc_portmap[port] = adcPort;
      ADCM$adc_count[port] = 0;
      return SUCCESS;
    }
  else {
#line 134
    return FAIL;
    }
}

# 788 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static void SmartSensingM$updateMaxBlkNum(void)
#line 788
{
  uint8_t i;
  uint16_t totalRate = 0;
  uint16_t usedBlkNum = 0;

#line 792
  for (i = 0; i < sensor_num; i++) {
      if (sensor[i].samplingRate != 0) {
          totalRate += 1000UL / sensor[i].samplingRate;
        }
      else {
          usedBlkNum += sensor[i].maxBlkNum;
        }
    }
  if (totalRate != 0) {
      for (i = 0; i <= sensor_num; i++) {
          if (sensor[i].samplingRate != 0) {
              sensor[i].maxBlkNum = 1000UL / sensor[i].samplingRate * (MEM_QUEUE_SIZE - usedBlkNum) / totalRate + 2;
            }
        }
    }
  return;
}

#line 832
static uint16_t SmartSensingM$calFireInterval(void)
#line 832
{
  uint8_t client = 0;
  uint16_t gcd = 0;
  uint16_t value1 = 0;

#line 836
  while (client < sensor_num) {
      value1 = sensor[client].samplingRate;
      if (value1 != 0) {
          if (gcd == 0) {
              gcd = value1;
            }
          else {
              gcd = SmartSensingM$GCD(gcd, value1);
            }
        }
      client++;
    }
  return gcd;
}

# 268 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static void FramerM$HDLCInitialize(void)
#line 268
{
  int i;

#line 270
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 270
    {
      for (i = 0; i < FramerM$HDLC_QUEUESIZE; i++) {
          FramerM$gMsgRcvTbl[i].pMsg = &FramerM$gMsgRcvBuf[i];
          FramerM$gMsgRcvTbl[i].Length = 0;
          FramerM$gMsgRcvTbl[i].Token = 0;
        }
      FramerM$gTxState = FramerM$TXSTATE_IDLE;
      FramerM$gTxByteCnt = 0;
      FramerM$gTxLength = 0;
      FramerM$gTxRunningCRC = 0;
      FramerM$gpTxMsg = NULL;

      FramerM$gRxState = FramerM$RXSTATE_NOSYNC;
      FramerM$gRxHeadIndex = 0;
      FramerM$gRxTailIndex = 0;
      FramerM$gRxByteCnt = 0;
      FramerM$gRxRunningCRC = 0;
      FramerM$gpRxBuf = (uint8_t *)FramerM$gMsgRcvTbl[FramerM$gRxHeadIndex].pMsg;
      FramerM$gFlags = 0;
    }
#line 289
    __nesc_atomic_end(__nesc_atomic); }
}

# 225 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static   void HPLUSART0M$USARTControl$setModeSPI(void)
#line 225
{

  if (HPLUSART0M$USARTControl$getMode() == USART_SPI) {
    return;
    }
  HPLUSART0M$USARTControl$disableUART();
  HPLUSART0M$USARTControl$disableI2C();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 233
    {
      TOSH_SEL_SIMO0_MODFUNC();
      TOSH_SEL_SOMI0_MODFUNC();
      TOSH_SEL_UCLK0_MODFUNC();

      HPLUSART0M$IE1 &= ~((1 << 7) | (1 << 6));

      U0CTL = 0x01;
      U0CTL |= (0x10 | 0x04) | 0x02;
      U0CTL &= ~0x20;

      HPLUSART0M$U0TCTL = 0x02;
      HPLUSART0M$U0TCTL |= 0x80;

      if (HPLUSART0M$l_ssel & 0x80) {
          HPLUSART0M$U0TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
          HPLUSART0M$U0TCTL |= HPLUSART0M$l_ssel & 0x7F;
        }
      else {
          HPLUSART0M$U0TCTL &= ~(((0x00 | 0x10) | 0x20) | 0x30);
          HPLUSART0M$U0TCTL |= 0x20;
        }

      if (HPLUSART0M$l_br != 0) {
          U0BR0 = HPLUSART0M$l_br & 0x0FF;
          U0BR1 = (HPLUSART0M$l_br >> 8) & 0x0FF;
        }
      else {
          U0BR0 = 0x02;
          U0BR1 = 0x00;
        }
      U0MCTL = 0;

      HPLUSART0M$ME1 &= ~((1 << 7) | (1 << 6));
      HPLUSART0M$ME1 |= 1 << 6;
      U0CTL &= ~0x01;

      HPLUSART0M$IFG1 &= ~((1 << 7) | (1 << 6));
      HPLUSART0M$IE1 &= ~((1 << 7) | (1 << 6));
    }
#line 272
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 309 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static void TimeSyncM$clearTable(void)
{
  int8_t i;

#line 312
  for (i = 0; i < TimeSyncM$MAX_ENTRIES; ++i) {
      TimeSyncM$table[i].state = TimeSyncM$ENTRY_EMPTY;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 315
    TimeSyncM$numEntries = 0;
#line 315
    __nesc_atomic_end(__nesc_atomic); }
}

# 347 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static void CascadesRouterM$initialize(void)
#line 347
{
  int8_t i;

#line 349
  CascadesRouterM$highestSeq = 0;
  CascadesRouterM$expectingSeq = 0;
  CascadesRouterM$headIndex = 0;
  CascadesRouterM$RTwait = (CascadesRouterM$Random$rand() & 0x64) + 0xcf;
  CascadesRouterM$resetCount = 0;
  CascadesRouterM$nextSignalSeq = CascadesRouterM$expectingSeq;

  CascadesRouterM$activeRT = FALSE;
  CascadesRouterM$DataTimerOn = FALSE;
  CascadesRouterM$DataProcessBusy = FALSE;
  CascadesRouterM$RequestProcessBusy = FALSE;
  CascadesRouterM$ctrlMsgBusy = FALSE;
  CascadesRouterM$CMAuProcessBusy = FALSE;
  CascadesRouterM$sigRcvTaskBusy = FALSE;
  CascadesRouterM$delayTimerBusy = FALSE;
  CascadesRouterM$inited = FALSE;
  for (i = MAX_CAS_BUF - 1; i >= 0; i--) {
      CascadesRouterM$myBuffer[i].signalDone = 1;
      CascadesRouterM$clearChildrenListStatus(i);
    }
  for (i = MAX_CAS_PACKETS - 1; i >= 0; i--) {
      CascadesRouterM$inData[i] = FALSE;
    }
}

# 70 "/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
static   uint16_t RandomLFSR$Random$rand(void)
#line 70
{
  bool endbit;
  uint16_t tmpShiftReg;

#line 73
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 73
    {
      tmpShiftReg = RandomLFSR$shiftReg;
      endbit = (tmpShiftReg & 0x8000) != 0;
      tmpShiftReg <<= 1;
      if (endbit) {
        tmpShiftReg ^= 0x100b;
        }
#line 79
      tmpShiftReg++;
      RandomLFSR$shiftReg = tmpShiftReg;
      tmpShiftReg = tmpShiftReg ^ RandomLFSR$mask;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return tmpShiftReg;
}

# 228 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static void CascadesRouterM$clearChildrenListStatus(uint8_t myindex)
#line 228
{
  int8_t i;

#line 230
  for (i = MAX_NUM_CHILDREN - 1; i >= 0; i--) {
      CascadesRouterM$myBuffer[myindex].childrenList[i].status = 0;
    }
  CascadesRouterM$myBuffer[myindex].countDT = 0;
  CascadesRouterM$myBuffer[myindex].retry = 0;
}

# 62 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static void NeighborMgmtM$initialize(void)
#line 62
{
  nmemset(NeighborMgmtM$NeighborTbl, 0, sizeof(NBRTableEntry ) * 16);
  NeighborMgmtM$initTime = TRUE;
  NeighborMgmtM$processTaskBusy = FALSE;
  NeighborMgmtM$lqiBuf = 0;
  NeighborMgmtM$rssiBuf = 0;
  NeighborMgmtM$linkaddrBuf = 0;
  NeighborMgmtM$ticks = 0;
}

# 443 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static  result_t TimerM$Timer$start(uint8_t num, char type, uint32_t milli)
{
  switch (type) 
    {
      case TIMER_REPEAT: 
        return TimerM$setTimer(num, milli * 32, TRUE);

      case TIMER_ONE_SHOT: 
        return TimerM$setTimer(num, milli * 32, FALSE);
    }

  return FAIL;
}

#line 319
static result_t TimerM$setTimer(uint8_t num, int32_t jiffy, bool isperiodic)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      TimerM$Timer_t *timer = &TimerM$m_timers[num];
      int32_t now;

#line 325
      if (timer->isset) {
        TimerM$removeTimer(num);
        }
#line 327
      TimerM$m_period[num] = jiffy;
      timer->isperiodic = isperiodic;
      now = TimerM$LocalTime$read();
      timer->alarm = now + jiffy;
      TimerM$insertTimer(num, jiffy <= 0xffffL);
      TimerM$setNextShortEvent();
    }
#line 333
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 288
static   uint32_t TimerM$LocalTime$read(void)
{
  uint32_t now;

#line 291
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {



      uint16_t hinow = TimerM$m_hinow;
      uint16_t lonow = TimerM$readTime();

#line 298
      if (TimerM$AlarmTimer$isOverflowPending()) 
        {
          hinow++;
          lonow = TimerM$readTime();
        }
      now = ((uint32_t )hinow << 16) | lonow;
    }
#line 304
    __nesc_atomic_end(__nesc_atomic); }
  return now;
}

#line 275
static uint16_t TimerM$readTime(void)
{





  uint16_t t0;
  uint16_t t1 = TimerM$AlarmTimer$read();

#line 284
  do {
#line 284
      t0 = t1;
#line 284
      t1 = TimerM$AlarmTimer$read();
    }
  while (
#line 284
  t0 != t1);
  return t1;
}

#line 94
static void TimerM$insertTimer(uint8_t num, bool isshort)
{
  if (TimerM$m_timers[num].isqueued == FALSE) 
    {
      if (isshort) 
        {
          TimerM$m_timers[num].next = TimerM$m_head_short;
          TimerM$m_head_short = num;
        }
      else 
        {
          TimerM$m_timers[num].next = TimerM$m_head_long;
          TimerM$m_head_long = num;
        }
      TimerM$m_timers[num].isqueued = TRUE;
    }
  TimerM$m_timers[num].isset = TRUE;
}

#line 198
static void TimerM$setNextShortEvent(void)
{
  uint32_t now = TimerM$LocalTime$read();

#line 201
  if (TimerM$m_head_short != TimerM$EMPTY_LIST) 
    {
      uint8_t head = TimerM$m_head_short;
      uint8_t soon = head;
      int32_t remaining = TimerM$m_timers[head].alarm - now;

#line 206
      head = TimerM$m_timers[head].next;
      while (head != TimerM$EMPTY_LIST) 
        {
          int32_t dt = TimerM$m_timers[head].alarm - now;

#line 210
          if (dt < remaining) 
            {
              remaining = dt;
              soon = head;
            }
          head = TimerM$m_timers[head].next;
        }

      now = TimerM$LocalTime$read();
      remaining = TimerM$m_timers[soon].alarm - now;

      if (remaining <= 0) 
        {

          TimerM$AlarmControl$disableEvents();
          TimerM$post_checkShortTimers();
        }
      else 
        {


          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
            {




              if (remaining > 2) {
                TimerM$AlarmCompare$setEventFromNow(remaining);
                }
              else {
#line 240
                TimerM$AlarmCompare$setEventFromNow(2);
                }
#line 241
              TimerM$AlarmControl$clearPendingInterrupt();
              TimerM$AlarmControl$enableEvents();
            }
#line 243
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  else 
    {

      TimerM$AlarmControl$disableEvents();
    }
}

#line 186
static void TimerM$post_checkShortTimers(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      if (!TimerM$m_posted_checkShortTimers) 
        {
          if (TOS_post(TimerM$checkShortTimers)) {
            TimerM$m_posted_checkShortTimers = TRUE;
            }
        }
    }
#line 196
    __nesc_atomic_end(__nesc_atomic); }
}

#line 141
static void TimerM$executeTimers(uint8_t head)
{
  uint32_t now = TimerM$LocalTime$read();

#line 144
  while (head != TimerM$EMPTY_LIST) 
    {
      uint8_t num = head;
      bool signal_timer = FALSE;

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
        {
          TimerM$Timer_t *timer = &TimerM$m_timers[num];

#line 152
          head = timer->next;

          timer->isqueued = FALSE;

          if (timer->isset) 
            {
              int32_t remaining = timer->alarm - now;

#line 159
              timer->isset = FALSE;
              if (remaining <= 0) 
                {


                  if (timer->isperiodic) 
                    {
                      timer->alarm += TimerM$m_period[num];
                      TimerM$insertTimer(num, (int32_t )(timer->alarm - now) <= 0xffffL);
                    }
                  signal_timer = TRUE;
                }
              else 
                {

                  TimerM$insertTimer(num, remaining <= 0xffffL);
                }
            }
        }
#line 177
        __nesc_atomic_end(__nesc_atomic); }

      if (signal_timer) {
        TimerM$signal_timer_fired(num);
        }
    }
}

# 419 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static  void MSP430ADC12M$RefVolt$isStable(RefVolt_t vref)
{
  if (MSP430ADC12M$vrefWait) {
      MSP430ADC12M$HPLADC12$startConversion();
      if (MSP430ADC12M$reserved & TIMER_USED) {
        MSP430ADC12M$startTimerA();
        }
#line 425
      MSP430ADC12M$reserved = ADC_IDLE;
      MSP430ADC12M$vrefWait = FALSE;
    }
}

#line 184
static void MSP430ADC12M$startTimerA(void)
{
  MSP430CompareControl_t ccSetSHI = { 
  .ccifg = 0, .cov = 0, .out = 1, .cci = 0, .ccie = 0, 
  .outmod = 0, .cap = 0, .clld = 0, .scs = 0, .ccis = 0, .cm = 0 };
  MSP430CompareControl_t ccResetSHI = { 
  .ccifg = 0, .cov = 0, .out = 0, .cci = 0, .ccie = 0, 
  .outmod = 0, .cap = 0, .clld = 0, .scs = 0, .ccis = 0, .cm = 0 };
  MSP430CompareControl_t ccRSOutmod = { 
  .ccifg = 0, .cov = 0, .out = 0, .cci = 0, .ccie = 0, 
  .outmod = 7, .cap = 0, .clld = 0, .scs = 0, .ccis = 0, .cm = 0 };

  MSP430ADC12M$ControlA1$setControl(ccResetSHI);
  MSP430ADC12M$ControlA1$setControl(ccSetSHI);

  MSP430ADC12M$ControlA1$setControl(ccRSOutmod);
  MSP430ADC12M$TimerA$setMode(MSP430TIMER_UP_MODE);
}

# 167 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static void CascadesRouterM$delFromChildrenList(address_t nodeID)
#line 167
{
  int8_t i;
  int8_t myIndex;

#line 170
  for (myIndex = MAX_CAS_BUF - 1; myIndex >= 0; myIndex--) {
      for (i = MAX_NUM_CHILDREN - 1; i >= 0; i--) {
          if (CascadesRouterM$myBuffer[myIndex].childrenList[i].childID == nodeID) {
              CascadesRouterM$myBuffer[myIndex].childrenList[i].childID = 0;
              CascadesRouterM$myBuffer[myIndex].childrenList[i].status = 0;
            }
        }
    }
}

# 457 "/opt/tinyos-1.x/tos/platform/msp430/TimerM.nc"
static  result_t TimerM$Timer$stop(uint8_t num)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 459
    TimerM$removeTimer(num);
#line 459
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 323 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static void CascadesRouterM$produceCtrlMsg(TOS_MsgPtr tmPtr, uint16_t seq, uint8_t type)
#line 323
{
  uint8_t localIndex = 0;
  int8_t i = 0;
  CasCtrlMsg *CCMsg = (CasCtrlMsg *)tmPtr->data;
  uint16_t *dst = (uint16_t *)CCMsg->data;

#line 328
  CCMsg->dataSeq = seq;
  CCMsg->linkSource = TOS_LOCAL_ADDRESS;
  CCMsg->type = type;
  CCMsg->parent = CascadesRouterM$CascadeControl$getParent();
  if (type == TYPE_CASCADES_CMAU) {
      if (INVALID_INDEX != (localIndex = CascadesRouterM$findMsgIndex(seq))) {
          for (i = 0; i < MAX_NUM_CHILDREN; i++) {
              if (CascadesRouterM$myBuffer[localIndex].childrenList[i].childID != 0 && CascadesRouterM$myBuffer[localIndex].childrenList[i].status != 1) {
                  * dst++ = CascadesRouterM$myBuffer[localIndex].childrenList[i].childID;
                }
            }
        }
      tmPtr->length = sizeof(CasCtrlMsg ) + (MAX_NUM_CHILDREN << 1);
      return;
    }
  tmPtr->length = sizeof(CasCtrlMsg );
  return;
}

# 465 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void)
#line 465
{
  uint8_t ind = 0;

#line 467
  for (ind = 0; ind < 16; ind++) {
      if (NeighborMgmtM$NeighborTbl[ind].flags & NBRFLAG_VALID) {
          if (NeighborMgmtM$NeighborTbl[ind].relation & NBR_PARENT) {
            return NeighborMgmtM$NeighborTbl[ind].id;
            }
        }
    }
#line 473
  return ADDRESS_INVALID;
}

# 130 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static uint8_t CascadesRouterM$findMsgIndex(uint16_t msgSeq)
#line 130
{
  int8_t i;

#line 132
  for (i = MAX_CAS_BUF - 1; i >= 0; i--) {
      if (CascadesRouterM$getCasData(& CascadesRouterM$myBuffer[i].tmsg)->seqno == msgSeq) {
          return i;
        }
    }
  return INVALID_INDEX;
}

# 68 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static  result_t CascadesEngineM$MySend$send(uint8_t type, TOS_MsgPtr msg, uint16_t len)
#line 68
{
  if (SUCCESS == CascadesEngineM$insertAndStartSend(msg)) {
      CascadesEngineM$updateProtocolField(msg, type, len);
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

#line 132
static result_t CascadesEngineM$tryNextSend(void)
#line 132
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 133
    {
      if (!CascadesEngineM$sendTaskBusy && headElement(&CascadesEngineM$sendQueue, PENDING) != NULL) {
          if (SUCCESS != TOS_post(CascadesEngineM$sendTask)) {
              CascadesEngineM$sendTaskBusy = FALSE;
            }
          else {
              CascadesEngineM$sendTaskBusy = TRUE;
            }
        }
    }
#line 142
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 368 "/home/xu/oasis/system/queue.h"
static object_type *headElement(Queue_t *queue, ObjStatus_t status)
#line 368
{

  if (queue->head[status] == -1) {
    return NULL;
    }
  else {
#line 373
    return queue->element[queue->head[status]].obj;
    }
}

# 295 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$SendMsg$send(uint8_t id, uint16_t addr, uint8_t len, TOS_MsgPtr msg)
#line 295
{


  uint8_t ind = 0;

#line 299
  if (len > DATA_LENGTH) {
      ;
      return FAIL;
    }

  GenericCommProM$updateProtocolField(msg, id, addr, len);
  if (GenericCommProM$insertAndStartSend(msg) == SUCCESS) {
      ;

      ind = GenericCommProM$allocateBkHeaderEntry();
      if (ind < COMM_SEND_QUEUE_SIZE) {
          GenericCommProM$bkHeader[ind].valid = TRUE;
          GenericCommProM$bkHeader[ind].length = len;
          GenericCommProM$bkHeader[ind].type = id;
          GenericCommProM$bkHeader[ind].group = msg->group;
          GenericCommProM$bkHeader[ind].msgPtr = msg;
          GenericCommProM$bkHeader[ind].addr = addr;
        }
      else {
          ;
        }
      return SUCCESS;
    }
  else {

      ;
      return FAIL;
    }
}

#line 513
static result_t GenericCommProM$tryNextSend(void)
#line 513
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 514
    {



      if (!GenericCommProM$sendTaskBusy && headElement(&GenericCommProM$sendQueue, PENDING) != NULL) {

          if (TOS_post(GenericCommProM$sendTask) != SUCCESS) {
              GenericCommProM$sendTaskBusy = FALSE;
              ;
              {
                unsigned char __nesc_temp = 
#line 523
                FAIL;

                {
#line 523
                  __nesc_atomic_end(__nesc_atomic); 
#line 523
                  return __nesc_temp;
                }
              }
            }
          else 
#line 525
            {
              GenericCommProM$sendTaskBusy = TRUE;
            }
        }
      else {
          ;
        }
    }
#line 532
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 158 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static result_t FramerM$StartTx(void)
#line 158
{
  result_t Result = SUCCESS;
  bool fInitiate = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 162
    {
      if (FramerM$gTxState == FramerM$TXSTATE_IDLE) {
          if (FramerM$gFlags & FramerM$FLAGS_TOKENPEND) {
              FramerM$gpTxBuf = (uint8_t *)&FramerM$gTxTokenBuf;
              FramerM$gTxProto = FramerM$PROTO_ACK;
              FramerM$gTxLength = sizeof FramerM$gTxTokenBuf;
              fInitiate = TRUE;
              FramerM$gTxState = FramerM$TXSTATE_PROTO;
            }
          else {
#line 171
            if (FramerM$gFlags & FramerM$FLAGS_DATAPEND) {
                FramerM$gpTxBuf = (uint8_t *)FramerM$gpTxMsg;
                FramerM$gTxProto = FramerM$PROTO_PACKET_NOACK;
                FramerM$gTxLength = FramerM$gpTxMsg->length + (MSG_DATA_SIZE - DATA_LENGTH - 2);
                fInitiate = TRUE;
                FramerM$gTxState = FramerM$TXSTATE_PROTO;
              }
            else {
#line 178
              if (FramerM$gFlags & FramerM$FLAGS_UNKNOWN) {
                  FramerM$gpTxBuf = (uint8_t *)&FramerM$gTxUnknownBuf;
                  FramerM$gTxProto = FramerM$PROTO_UNKNOWN;
                  FramerM$gTxLength = sizeof FramerM$gTxUnknownBuf;
                  fInitiate = TRUE;
                  FramerM$gTxState = FramerM$TXSTATE_PROTO;
                }
              }
            }
        }
    }
#line 188
    __nesc_atomic_end(__nesc_atomic); }
#line 188
  if (fInitiate) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 189
        {
          FramerM$gTxRunningCRC = 0;
#line 190
          FramerM$gTxByteCnt = 0;
        }
#line 191
        __nesc_atomic_end(__nesc_atomic); }
      Result = FramerM$ByteComm$txByte(FramerM$HDLC_FLAG_BYTE);
      if (Result != SUCCESS) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 194
            FramerM$gTxState = FramerM$TXSTATE_ERROR;
#line 194
            __nesc_atomic_end(__nesc_atomic); }
          TOS_post(FramerM$PacketSent);
        }
    }

  return Result;
}

# 110 "/opt/tinyos-1.x/tos/system/UARTM.nc"
static   result_t UARTM$ByteComm$txByte(uint8_t data)
#line 110
{
  bool oldState;

  {
  }
#line 113
  ;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 115
    {
      oldState = UARTM$state;
      UARTM$state = TRUE;
    }
#line 118
    __nesc_atomic_end(__nesc_atomic); }
  if (oldState) {
    return FAIL;
    }
  UARTM$HPLUART$put(data);

  return SUCCESS;
}

# 246 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static  void FramerM$PacketSent(void)
#line 246
{
  result_t TxResult = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 249
    {
      if (FramerM$gTxState == FramerM$TXSTATE_ERROR) {
          TxResult = FAIL;
          FramerM$gTxState = FramerM$TXSTATE_IDLE;
        }
    }
#line 254
    __nesc_atomic_end(__nesc_atomic); }
  if (FramerM$gTxProto == FramerM$PROTO_ACK) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 256
        FramerM$gFlags ^= FramerM$FLAGS_TOKENPEND;
#line 256
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 259
        FramerM$gFlags ^= FramerM$FLAGS_DATAPEND;
#line 259
        __nesc_atomic_end(__nesc_atomic); }
      FramerM$BareSendMsg$sendDone((TOS_MsgPtr )FramerM$gpTxMsg, TxResult);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 261
        FramerM$gpTxMsg = NULL;
#line 261
        __nesc_atomic_end(__nesc_atomic); }
    }


  FramerM$StartTx();
}

# 576 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static result_t GenericCommProM$reportSendDone(TOS_MsgPtr msg, result_t success)
#line 576
{
  result_t result;
  TOS_MsgPtr *mPPtr = NULL;
  uint8_t ind = 0;
  uint8_t retry;

  NetworkMsg *NMsg;

  GenericCommProM$state = FALSE;
  mPPtr = findObject(&GenericCommProM$sendQueue, msg);
  if (mPPtr == NULL) {
      ;

      return FAIL;
    }




  ind = GenericCommProM$findBkHeaderEntry(msg);
  if (ind < COMM_SEND_QUEUE_SIZE) {
      msg->addr = GenericCommProM$bkHeader[ind].addr;
      msg->group = GenericCommProM$bkHeader[ind].group;
      msg->type = GenericCommProM$bkHeader[ind].type;
      msg->length = GenericCommProM$bkHeader[ind].length;
    }
  else 
#line 601
    {
      ;
    }




  result = SUCCESS;
  if (success != SUCCESS || (
  msg->ack != 1 && msg->addr != TOS_BCAST_ADDR
   && msg->addr != TOS_UART_ADDR)) {
      incRetryCount(mPPtr);
      retry = getRetryCount(mPPtr);

      if (msg->type == AM_NETWORKMSG ? (NMsg = (NetworkMsg *)msg->data, retry >= qosRexmit(NMsg->qos)) : 
      retry >= 2) {



          ;
          if (removeElement(&GenericCommProM$sendQueue, msg) != SUCCESS) {
              ;
            }
          if (GenericCommProM$freeBkHeader(ind) != SUCCESS) {
              ;
            }
          result = FAIL;
        }
      else {
          changeElementStatus(&GenericCommProM$sendQueue, msg, PROCESSING, PENDING);
          GenericCommProM$tryNextSend();
          return SUCCESS;
        }
    }
  else {
      ;
      if (removeElement(&GenericCommProM$sendQueue, msg) != SUCCESS) {
          ;
        }

      if (GenericCommProM$freeBkHeader(ind) != SUCCESS) {
          ;
        }
    }
  GenericCommProM$SendMsg$sendDone(msg->type, msg, result);
  GenericCommProM$tryNextSend();
  return SUCCESS;
}

# 468 "/home/xu/oasis/system/queue.h"
static object_type **findObject(Queue_t *queue, object_type *obj)
#line 468
{
  int16_t ind;

#line 470
  if (queue->size <= 0) {
      ;
      return NULL;
    }

  if (queue->total <= 0) {
      ;
      return NULL;
    }

  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].status != FREE && queue->element[ind].obj == obj) {
          ;
          return & (&queue->element[ind])->obj;
        }
    }
  ;
  return NULL;
}

# 709 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static uint8_t GenericCommProM$findBkHeaderEntry(TOS_MsgPtr pMsg)
#line 709
{
  uint8_t i = 0;

#line 711
  for (i = 0; i < COMM_SEND_QUEUE_SIZE; i++) {
      if (GenericCommProM$bkHeader[i].valid == TRUE && GenericCommProM$bkHeader[i].msgPtr == pMsg) {
          break;
        }
    }
  if (i == COMM_SEND_QUEUE_SIZE) {
      ;
    }
  return i;
}

# 307 "/home/xu/oasis/system/queue.h"
static result_t removeElement(Queue_t *queue, object_type *obj)
#line 307
{

  int16_t ind;




  if (queue->size <= 0) {
      ;
      return FAIL;
    }

  if (queue->total <= 0) {
      ;
      return FAIL;
    }

  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].status != FREE && queue->element[ind].obj == obj) {
          _private_changeElementStatusByIndex(queue, ind, queue->element[ind].status, FREE);


          queue->element[ind].obj = NULL;

          queue->element[ind].retry = 0;









          queue->total = queue->total - 1;
          ;
          break;
        }
    }

  if (ind == queue->size) {
      ;
      return FAIL;
    }

  ;

  return SUCCESS;
}

# 722 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static result_t GenericCommProM$freeBkHeader(uint8_t ind)
#line 722
{
  if (ind < COMM_SEND_QUEUE_SIZE) {
      GenericCommProM$bkHeader[ind].valid = FALSE;
      GenericCommProM$bkHeader[ind].length = 0;
      GenericCommProM$bkHeader[ind].type = 0;
      GenericCommProM$bkHeader[ind].group = 0;
      GenericCommProM$bkHeader[ind].msgPtr = 0;
      GenericCommProM$bkHeader[ind].addr = 0;
      return SUCCESS;
    }
  ;
  return FALSE;
}

# 496 "/home/xu/oasis/system/queue.h"
static result_t changeElementStatus(Queue_t *queue, object_type *obj, ObjStatus_t status1, ObjStatus_t status2)
#line 496
{

  int16_t ind;


  ind = queue->head[status1];
  while (ind != -1) {
      if (queue->element[ind].obj == obj) {
          _private_changeElementStatusByIndex(queue, ind, status1, status2);
          break;
        }
      else 
#line 506
        {
          ind = queue->element[ind].next;
        }
    }

  if (ind == -1) {
      ;
      return FAIL;
    }
  else {
      ;
      return SUCCESS;
    }
}

# 593 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static uint8_t MultiHopEngineM$findInfoEntry(TOS_MsgPtr pMsg)
#line 593
{
  uint8_t i = 0;

#line 595
  for (i = 0; i < 5; i++) {
      if (MultiHopEngineM$queueEntryInfo[i].valid == TRUE && MultiHopEngineM$queueEntryInfo[i].msgPtr == pMsg) {
          break;
        }
    }
  if (i == 5) {
      ;
    }
  return i;
}

# 399 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 399
{
  DataMgmtM$sendDoneR_num++;
  if (success == SUCCESS) {
      DataMgmtM$SysCheckTimer$stop();
      DataMgmtM$sysCheckCount = 0;
      DataMgmtM$SysCheckTimer$start(TIMER_ONE_SHOT, 60000UL);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 405
        DataMgmtM$sendDoneFailCheckCount = 0;
#line 405
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {

    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 409
      DataMgmtM$sendDoneFailCheckCount++;
#line 409
      __nesc_atomic_end(__nesc_atomic); }
    }

  removeElement(&DataMgmtM$sendQueue, pMsg);

  freeBuffer(&DataMgmtM$buffQueue, pMsg);
  DataMgmtM$freebuffercount++;

  DataMgmtM$tryNextSend();
  return SUCCESS;
}

# 86 "/home/xu/oasis/system/buffer.h"
static result_t freeBuffer(Queue_t *bufQueue, TOS_MsgPtr buf)
#line 86
{
  if (FAIL == changeElementStatus(bufQueue, buf, BUSYBUF, FREEBUF)) {
      ;
      return FAIL;
    }
  ;

  return SUCCESS;
}

# 489 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static result_t DataMgmtM$tryNextSend(void)
#line 489
{

  if (!DataMgmtM$sendTaskBusy && headElement(&DataMgmtM$sendQueue, PENDING) != NULL) {
      DataMgmtM$Leds$greenToggle();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 493
        DataMgmtM$sendTaskBusy = TOS_post(DataMgmtM$sendTask);
#line 493
        __nesc_atomic_end(__nesc_atomic); }
      DataMgmtM$trynextSendCount++;
    }
  return SUCCESS;
}

# 174 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static  void *MultiHopEngineM$Send$getBuffer(uint8_t AMID, TOS_MsgPtr msg, uint16_t *length)
#line 174
{
  NetworkMsg *NMsg = (NetworkMsg *)msg->data;

#line 176
  *length = 74 - (size_t )& ((NetworkMsg *)0)->data;
  return &NMsg->data[0];
}

#line 147
static  result_t MultiHopEngineM$Send$send(uint8_t AMID, TOS_MsgPtr msg, uint16_t length)
#line 147
{
  uint16_t correctedLength = (size_t )& ((NetworkMsg *)0)->data + length;

#line 149
  if (correctedLength > 74) {
      ;
      MultiHopEngineM$localSendFail++;
      return FAIL;
    }
  ;
  MultiHopEngineM$RouteSelect$initializeFields(msg, AMID);
  if (SUCCESS == MultiHopEngineM$insertAndStartSend(msg, AMID, correctedLength, msg)) {
      MultiHopEngineM$numLocalPendingPkt++;
      return SUCCESS;
    }
  else {
    return FAIL;
    }
}

#line 327
static result_t MultiHopEngineM$insertAndStartSend(TOS_MsgPtr msg, 
uint16_t AMID, 
uint16_t length, 
TOS_MsgPtr originalTOSPtr)
#line 330
{
  result_t result = FALSE;
  TOS_MsgPtr msgPtr;
  uint8_t infoInd;
  NetworkMsg *NMsg;
  NetworkMsg *NMsgCome = (NetworkMsg *)msg->data;

#line 336
  TryInsert: 
    if (NULL != (msgPtr = allocBuffer(&MultiHopEngineM$buffQueue))) {
        if ((infoInd = MultiHopEngineM$allocateInfoEntry()) == 5) {
            ;
          }
        MultiHopEngineM$queueEntryInfo[infoInd].valid = TRUE;
        MultiHopEngineM$queueEntryInfo[infoInd].AMID = AMID;
        MultiHopEngineM$queueEntryInfo[infoInd].resend = FALSE;
        MultiHopEngineM$queueEntryInfo[infoInd].length = length;
        MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr = originalTOSPtr;
        MultiHopEngineM$queueEntryInfo[infoInd].msgPtr = msgPtr;
        nmemcpy(msgPtr, msg, sizeof(TOS_Msg ));

        if (!MultiHopEngineM$useMhopPriority) {
          result = insertElement(&MultiHopEngineM$sendQueue, msgPtr);
          }
        else {
#line 352
          result = insertElementPri(&MultiHopEngineM$sendQueue, msgPtr, NMsgCome->qos);
          }
      }
    else 
#line 353
      {

        if (!MultiHopEngineM$useMhopPriority) {
          result = FAIL;
          }
        else 
#line 357
          {
            msgPtr = tailElement(&MultiHopEngineM$sendQueue, PENDING);
            if (msgPtr == NULL) {
                ;
                result = FAIL;
                goto outInsert;
              }
            NMsg = (NetworkMsg *)msgPtr->data;
            if (NMsg->qos < NMsgCome->qos) {

                infoInd = MultiHopEngineM$findInfoEntry(msgPtr);
                if (infoInd == 5) {
                    ;
                  }
                if (MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr != NULL) {
                    MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoInd].AMID, MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr, FAIL);
                  }
                if (SUCCESS != removeElement(&MultiHopEngineM$sendQueue, msgPtr)) {
                    ;
                  }
                freeBuffer(&MultiHopEngineM$buffQueue, msgPtr);
                MultiHopEngineM$freeInfoEntry(infoInd);
                MultiHopEngineM$numberOfSendFailures++;
                goto TryInsert;
              }
            else {
                result = FAIL;
              }
          }
      }
  outInsert: 
    MultiHopEngineM$tryNextSend();
  return result;
}

# 66 "/home/xu/oasis/system/buffer.h"
static TOS_MsgPtr allocBuffer(Queue_t *bufQueue)
#line 66
{
  TOS_MsgPtr head;

#line 68
  if (NULL != (head = headElement(bufQueue, FREEBUF))) {
      if (FAIL == changeElementStatus(bufQueue, head, FREEBUF, BUSYBUF)) {
        ;
        }
#line 71
      ;
      return head;
    }
  else 
#line 73
    {

      return NULL;
    }
}

# 149 "/opt/tinyos-1.x/tos/system/tos.h"
static void *nmemcpy(void *to, const void *from, size_t n)
{
  char *cto = to;
  const char *cfrom = from;

  while (n--) * cto++ = * cfrom++;

  return to;
}

# 606 "/home/xu/oasis/lib/MultiHopOasis/MultiHopEngineM.nc"
static result_t MultiHopEngineM$freeInfoEntry(uint8_t ind)
#line 606
{
  if (ind < 5) {
      MultiHopEngineM$queueEntryInfo[ind].valid = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].AMID = 0;
      MultiHopEngineM$queueEntryInfo[ind].length = 0;
      MultiHopEngineM$queueEntryInfo[ind].originalTOSPtr = NULL;
      MultiHopEngineM$queueEntryInfo[ind].msgPtr = NULL;
      return SUCCESS;
    }
  else 
#line 614
    {
      ;
      return FALSE;
    }
}

#line 392
static result_t MultiHopEngineM$tryNextSend(void)
#line 392
{

  if (!MultiHopEngineM$sendTaskBusy && headElement(&MultiHopEngineM$sendQueue, PENDING) != NULL && MultiHopEngineM$numOfPktProcessing < 4) {
      if (SUCCESS != TOS_post(MultiHopEngineM$sendTask)) {
        MultiHopEngineM$sendTaskBusy = FALSE;
        }
      else {
#line 398
        MultiHopEngineM$sendTaskBusy = TRUE;
        }
    }
#line 400
  return SUCCESS;
}

# 325 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t parent)
#line 325
{
  uint8_t ind = 0;

#line 327
  ind = NeighborMgmtM$findPreparedIndex(parent);
  if (ind == ROUTE_INVALID) {
    return FALSE;
    }
  else 
#line 330
    {
      if (!(NeighborMgmtM$NeighborTbl[ind].relation & NBR_PARENT)) {
          NeighborMgmtM$NeighborCtrl$clearParent(FALSE);
          NeighborMgmtM$NeighborTbl[ind].relation = NBR_PARENT;
          NeighborMgmtM$CascadeControl$parentChanged(parent);
          ;
        }
      return TRUE;
    }
}

#line 154
static uint8_t NeighborMgmtM$findPreparedIndex(uint16_t id)
#line 154
{
  uint8_t indes = NeighborMgmtM$findEntry(id);

#line 156
  if (indes == (uint8_t )ROUTE_INVALID) {
      indes = NeighborMgmtM$findEntryToBeReplaced();
      NeighborMgmtM$newEntry(indes, id);
    }
  return indes;
}

# 72 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static   result_t LedsC$Leds$redOn(void)
#line 72
{
  {
  }
#line 73
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 74
    {
      TOSH_CLR_RED_LED_PIN();
      LedsC$ledsOn |= LedsC$RED_BIT;
    }
#line 77
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static   result_t LedsC$Leds$redOff(void)
#line 81
{
  {
  }
#line 82
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      TOSH_SET_RED_LED_PIN();
      LedsC$ledsOn &= ~LedsC$RED_BIT;
    }
#line 86
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 263 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static  result_t EventReportM$EventSend$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 263
{

  uint16_t maxLen;
  ApplicationMsg *pApp;
  EventMsg *pEvent;

#line 268
  pApp = (ApplicationMsg *)EventReportM$EventSend$getBuffer(pMsg, &maxLen);
  pEvent = (EventMsg *)pApp->data;

  ;
  if (SUCCESS != removeElement(&EventReportM$sendQueue, pMsg)) {
      ;
    }
  EventReportM$EventReport$eventSendDone(pEvent->type, pMsg, success);
  freeBuffer(&EventReportM$buffQueue, pMsg);

  EventReportM$tryNextSend();
  return SUCCESS;
}

#line 298
static void EventReportM$tryNextSend(void)
#line 298
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 299
    {
      if (!EventReportM$taskBusy && headElement(&EventReportM$sendQueue, PENDING) != NULL) {
          if (TOS_post(EventReportM$sendEvent) != SUCCESS) {
              EventReportM$taskBusy = FALSE;
            }
          else {
              EventReportM$taskBusy = TRUE;
            }
        }
    }
#line 308
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 82 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static  result_t CascadesEngineM$SendMsg$sendDone(uint8_t type, TOS_MsgPtr msg, result_t success)
#line 82
{
  if (SUCCESS != removeElement(&CascadesEngineM$sendQueue, msg)) {
    }

  CascadesEngineM$MySend$sendDone(type, msg, success);
  CascadesEngineM$tryNextSend();
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/platform/telos/TimerJiffyAsyncM.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy)
{
  TimerJiffyAsyncM$AlarmControl$disableEvents();
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 73
    {
      TimerJiffyAsyncM$jiffy = _jiffy;
      TimerJiffyAsyncM$bSet = TRUE;
    }
#line 76
    __nesc_atomic_end(__nesc_atomic); }
  if (_jiffy > 0xFFFF) {
      TimerJiffyAsyncM$AlarmCompare$setEventFromNow(0xFFFF);
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 81
        {




          if (_jiffy > 2) {
            TimerJiffyAsyncM$AlarmCompare$setEventFromNow(_jiffy);
            }
          else {
#line 89
            TimerJiffyAsyncM$AlarmCompare$setEventFromNow(2);
            }
        }
#line 91
        __nesc_atomic_end(__nesc_atomic); }
    }
#line 92
  TimerJiffyAsyncM$AlarmControl$clearPendingInterrupt();
  TimerJiffyAsyncM$AlarmControl$enableEvents();
  return SUCCESS;
}

# 254 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static bool CascadesRouterM$getCMAu(uint8_t myindex)
#line 254
{
  int8_t i = 0;

#line 256
  if (CascadesRouterM$myBuffer[myindex].countDT == 0) {
      return TRUE;
    }
  else {
      for (i = MAX_NUM_CHILDREN - 1; i >= 0; i--) {
          if (CascadesRouterM$myBuffer[myindex].childrenList[i].childID != 0) {
              if (CascadesRouterM$myBuffer[myindex].childrenList[i].status != 1) {
                  return FALSE;
                }
            }
        }
    }
  return TRUE;
}

#line 575
static  void CascadesRouterM$sigRcvTask(void)
#line 575
{
  TOS_MsgPtr tempPtr = NULL;
  NetworkMsg *nwMsg = NULL;
  int8_t i;

  for (i = MAX_CAS_BUF - 1; i >= 0; i--) {
      tempPtr = & CascadesRouterM$myBuffer[i].tmsg;
      if (tempPtr != NULL) {
          nwMsg = (NetworkMsg *)tempPtr->data;
          if (nwMsg->seqno == CascadesRouterM$nextSignalSeq) {
              if (CascadesRouterM$Receive$receive(nwMsg->type, tempPtr, nwMsg->data, 
              tempPtr->length - (size_t )& ((NetworkMsg *)0)->data)) {
                  CascadesRouterM$myBuffer[i].signalDone = 1;

                  break;
                }
              else {

                  CascadesRouterM$sigRcvTaskBusy = TOS_post(CascadesRouterM$sigRcvTask);
                  return;
                }
            }
        }
    }

  if (CascadesRouterM$nextSignalSeq != CascadesRouterM$highestSeq + 1) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 601
        {
          CascadesRouterM$inData[CascadesRouterM$nextSignalSeq % MAX_CAS_PACKETS] = TRUE;
          ++CascadesRouterM$nextSignalSeq;
          CascadesRouterM$expectingSeq = CascadesRouterM$highestSeq + 1;
          CascadesRouterM$sigRcvTaskBusy = TOS_post(CascadesRouterM$sigRcvTask);
        }
#line 606
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 609
        CascadesRouterM$sigRcvTaskBusy = FALSE;
#line 609
        __nesc_atomic_end(__nesc_atomic); }
    }
}

# 601 "build/telosb/RpcM.nc"
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr pMsg, void *payload, uint16_t payloadLength)
#line 601
{


  NetworkMsg *nwMsg = (NetworkMsg *)pMsg->data;
  ApplicationMsg *AMsg = (ApplicationMsg *)payload;
  RpcCommandMsg *msg = (RpcCommandMsg *)AMsg->data;


  RpcM$debugSequenceNo = nwMsg->seqno;



  if (RpcM$processingCommand == FALSE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 614
        RpcM$processingCommand = TRUE;
#line 614
        __nesc_atomic_end(__nesc_atomic); }
      if (msg->address == TOS_LOCAL_ADDRESS || msg->address == TOS_BCAST_ADDR) {
          nmemcpy(RpcM$cmdStore.data, payload, payloadLength);
          RpcM$cmdStoreLength = payloadLength;

          RpcM$debugSequenceNo = nwMsg->seqno;

          if (SUCCESS != TOS_post(RpcM$processCommand)) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 622
                RpcM$processingCommand = FALSE;
#line 622
                __nesc_atomic_end(__nesc_atomic); }
              ;
              return NULL;
            }
          else {

              ;
            }
        }
      else {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 632
            RpcM$processingCommand = FALSE;
#line 632
            __nesc_atomic_end(__nesc_atomic); }
          ;
        }
    }
  else {
      ;
      return NULL;
    }

  return pMsg;
}

# 162 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data)
#line 162
{
  uint8_t status = 0;

#line 164
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 166
        HPLCC2420M$f.busy = TRUE;
#line 166
        __nesc_atomic_end(__nesc_atomic); }
      TOSH_CLR_RADIO_CSN_PIN();

      HPLCC2420M$USARTControl$isTxIntrPending();
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx(addr);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
      status = HPLCC2420M$adjustStatusByte(HPLCC2420M$USARTControl$rx());
      HPLCC2420M$USARTControl$tx((data >> 8) & 0x0FF);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
      HPLCC2420M$USARTControl$tx(data & 0x0FF);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxEmpty()) ;
      TOSH_SET_RADIO_CSN_PIN();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 179
        HPLCC2420M$f.busy = FALSE;
#line 179
        __nesc_atomic_end(__nesc_atomic); }
#line 195
      HPLCC2420M$BusArbitration$releaseBus();
    }
  return status;
}

# 94 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static   result_t BusArbitrationM$BusArbitration$getBus(uint8_t id)
#line 94
{
  bool gotbus = FALSE;

#line 96
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 96
    {
      if (BusArbitrationM$state == BusArbitrationM$BUS_IDLE) {
          BusArbitrationM$state = BusArbitrationM$BUS_BUSY;
          gotbus = TRUE;
          BusArbitrationM$busid = id;
        }
    }
#line 102
    __nesc_atomic_end(__nesc_atomic); }
  if (gotbus) {
    return SUCCESS;
    }
#line 105
  return FAIL;
}

# 424 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
static   result_t HPLUSART0M$USARTControl$isTxIntrPending(void)
#line 424
{
  if (HPLUSART0M$IFG1 & (1 << 7)) {
      HPLUSART0M$IFG1 &= ~(1 << 7);
      return SUCCESS;
    }
  return FAIL;
}

#line 478
static   uint8_t HPLUSART0M$USARTControl$rx(void)
#line 478
{
  uint8_t value;

#line 480
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 480
    {
      value = U0RXBUF;
    }
#line 482
    __nesc_atomic_end(__nesc_atomic); }
  return value;
}

#line 439
static   result_t HPLUSART0M$USARTControl$isRxIntrPending(void)
#line 439
{
  if (HPLUSART0M$IFG1 & (1 << 6)) {
      HPLUSART0M$IFG1 &= ~(1 << 6);
      return SUCCESS;
    }
  return FAIL;
}

# 108 "/opt/tinyos-1.x/tos/platform/telos/BusArbitrationM.nc"
static   result_t BusArbitrationM$BusArbitration$releaseBus(uint8_t id)
#line 108
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (BusArbitrationM$state == BusArbitrationM$BUS_BUSY && BusArbitrationM$busid == id) {
          BusArbitrationM$state = BusArbitrationM$BUS_IDLE;





          if (BusArbitrationM$isBusReleasedPending == FALSE && TOS_post(BusArbitrationM$busReleased) == TRUE) {
            BusArbitrationM$isBusReleasedPending = TRUE;
            }
        }
    }
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 127 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr)
#line 127
{
  uint8_t status = 0;

#line 129
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 131
        HPLCC2420M$f.busy = TRUE;
#line 131
        __nesc_atomic_end(__nesc_atomic); }
      TOSH_CLR_RADIO_CSN_PIN();

      HPLCC2420M$USARTControl$isTxIntrPending();
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx(addr);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
      status = HPLCC2420M$adjustStatusByte(HPLCC2420M$USARTControl$rx());
      TOSH_SET_RADIO_CSN_PIN();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 140
        HPLCC2420M$f.busy = FALSE;
#line 140
        __nesc_atomic_end(__nesc_atomic); }
#line 152
      HPLCC2420M$BusArbitration$releaseBus();
    }
  return status;
}

# 153 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static  void MultiHopLQI$SendRouteTask(void)
#line 153
{
  NetworkMsg *pNWMsg = (NetworkMsg *)&MultiHopLQI$msgBuf.data[0];
  BeaconMsg *pRP = (BeaconMsg *)&pNWMsg->data[0];
  uint8_t length = (size_t )& ((NetworkMsg *)0)->data + sizeof(BeaconMsg );

  {
  }
#line 158
  ;

  if (MultiHopLQI$gbCurrentParent != TOS_BCAST_ADDR) {
      {
      }
#line 161
      ;
    }

  if (MultiHopLQI$msgBufBusy) {

      TOS_post(MultiHopLQI$SendRouteTask);

      ;
      return;
    }

  {
  }
#line 172
  ;


  pRP->parent = MultiHopLQI$gbCurrentParent;
  pRP->parent_dup = MultiHopLQI$gbCurrentParent;
  pRP->cost = MultiHopLQI$gbCurrentParentCost + MultiHopLQI$gbCurrentLinkEst;
  pNWMsg->linksource = pNWMsg->source = TOS_LOCAL_ADDRESS;
  pRP->hopcount = MultiHopLQI$gbCurrentHopCount;
  pNWMsg->seqno = MultiHopLQI$gCurrentSeqNo++;

  if (MultiHopLQI$SendMsg$send(TOS_BCAST_ADDR, length, &MultiHopLQI$msgBuf) == SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 183
        MultiHopLQI$msgBufBusy = TRUE;
#line 183
        __nesc_atomic_end(__nesc_atomic); }
    }
}

# 90 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static   result_t LedsC$Leds$redToggle(void)
#line 90
{
  result_t rval;

#line 92
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 92
    {
      if (LedsC$ledsOn & LedsC$RED_BIT) {
        rval = LedsC$Leds$redOff();
        }
      else {
#line 96
        rval = LedsC$Leds$redOn();
        }
    }
#line 98
    __nesc_atomic_end(__nesc_atomic); }
#line 98
  return rval;
}

#line 119
static   result_t LedsC$Leds$greenToggle(void)
#line 119
{
  result_t rval;

#line 121
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 121
    {
      if (LedsC$ledsOn & LedsC$GREEN_BIT) {
        rval = LedsC$Leds$greenOff();
        }
      else {
#line 125
        rval = LedsC$Leds$greenOn();
        }
    }
#line 127
    __nesc_atomic_end(__nesc_atomic); }
#line 127
  return rval;
}

#line 148
static   result_t LedsC$Leds$yellowToggle(void)
#line 148
{
  result_t rval;

#line 150
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 150
    {
      if (LedsC$ledsOn & LedsC$YELLOW_BIT) {
        rval = LedsC$Leds$yellowOff();
        }
      else {
#line 154
        rval = LedsC$Leds$yellowOn();
        }
    }
#line 156
    __nesc_atomic_end(__nesc_atomic); }
#line 156
  return rval;
}

# 282 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static  result_t RealTimeM$Timer$start(uint8_t id, char type, uint32_t interval)
#line 282
{
  uint8_t i;

#line 284
  if (id >= NUM_TIMERS || RealTimeM$numClients >= MAX_NUM_CLIENT) {


      return FAIL;
    }
  if (type > TIMER_ONE_SHOT) {
      return FAIL;
    }
  if (interval > 0) {
      for (i = 0; i < RealTimeM$numClients; i++) {
          if (RealTimeM$clientList[i].id == id) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 295
                {
                  RealTimeM$clientList[i].type = type;
                  RealTimeM$clientList[i].syncInterval = interval;
                  RealTimeM$clientList[i].fireCount = (RealTimeM$localTime / interval + 1) * interval;
                  RealTimeM$mState |= 0x1L << id;
                }
#line 300
                __nesc_atomic_end(__nesc_atomic); }
              return SUCCESS;
            }
        }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 304
        {
          RealTimeM$clientList[RealTimeM$numClients].id = id;
          RealTimeM$clientList[RealTimeM$numClients].type = type;
          RealTimeM$clientList[RealTimeM$numClients].syncInterval = interval;
          RealTimeM$clientList[RealTimeM$numClients].fireCount = (RealTimeM$localTime / interval + 1) * interval;
          RealTimeM$mState |= 0x1L << id;
          ++RealTimeM$numClients;
        }
#line 311
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  else {
      RealTimeM$Timer$stop(id);
      return FAIL;
    }
}

# 697 "build/telosb/RpcM.nc"
static void RpcM$tryNextSend(void)
#line 697
{
  if (TRUE != RpcM$taskBusy) {
      RpcM$taskBusy = TOS_post(RpcM$sendResponse);
    }
  return;
}

# 602 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void DataMgmtM$processTask(void)
#line 602
{
  SenBlkPtr inPtr = NULL;
  uint16_t taskCode = 0;




  DataMgmtM$processTaskCount++;
  DataMgmtM$processloopCount = 0;
  DataMgmtM$GlobaltaskCode = 0;
  if (NULL != (inPtr = headMemElement(&DataMgmtM$sensorMem, FILLED))) {
      taskCode = inPtr->taskCode;
#line 747
      DataMgmtM$processloopCount = 0;
      if (taskCode == 0) {
          changeMemStatus(&DataMgmtM$sensorMem, inPtr, inPtr->status, MEMPENDING);
        }
    }


  if (NULL != (inPtr = headMemElement(&DataMgmtM$sensorMem, MEMPROCESSING))) {

      taskCode = inPtr->taskCode;
#line 775
      if (taskCode == 0) {
          changeMemStatus(&DataMgmtM$sensorMem, inPtr, inPtr->status, MEMPENDING);
        }
    }

  if (TRUE != DataMgmtM$presendTaskBusy) {
      if (NULL != headMemElement(&DataMgmtM$sensorMem, MEMPENDING)) {
          ;
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 783
            DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 783
            __nesc_atomic_end(__nesc_atomic); }
        }
    }


  if (NULL != headMemElement(&DataMgmtM$sensorMem, FILLED)) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 789
        DataMgmtM$processTaskBusy = TOS_post(DataMgmtM$processTask);
#line 789
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 793
        DataMgmtM$processTaskBusy = FALSE;
#line 793
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
}

# 247 "/home/xu/oasis/lib/SmartSensing/SensorMem.h"
static result_t changeMemStatus(MemQueue_t *queue, SenBlkPtr obj, MemStatus_t status1, MemStatus_t status2)
#line 247
{
  int16_t ind;

#line 249
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 249
    ind = queue->head[status1];
#line 249
    __nesc_atomic_end(__nesc_atomic); }
  while (ind != -1) {
      if (&queue->element[ind] == obj) {
          _private_changeMemStatusByIndex(queue, ind, status1, status2);
          return SUCCESS;
        }
      else 
#line 254
        {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 255
            ind = queue->element[ind].next;
#line 255
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return FAIL;
}

# 509 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void DataMgmtM$presendTask(void)
#line 509
{


  NetworkMsg *nwMsg = NULL;
  ApplicationMsg *appMsg = NULL;
  TOS_MsgPtr msg = NULL;
  SenBlkPtr p = NULL;
  TimeStamp_t *ts = NULL;

#line 517
  DataMgmtM$presendTaskCount++;

  if (NULL != (p = headMemElement(&DataMgmtM$sensorMem, MEMPENDING))) {

      if (NULL != (msg = allocBuffer(&DataMgmtM$buffQueue))) {
          DataMgmtM$allocbuffercount++;
          nwMsg = (NetworkMsg *)msg->data;
          nwMsg->qos = p->priority;
          appMsg = (ApplicationMsg *)nwMsg->data;
          appMsg->length = TSTAMPOFFSET + p->size;
          appMsg->type = p->type;
          appMsg->seqno = DataMgmtM$seqno;





          if (nwMsg->qos == 0) {
              DataMgmtM$DataMgmt$freeBlk((void *)p);
              ;
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 537
                DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 537
                __nesc_atomic_end(__nesc_atomic); }
              return;
            }

          ts = (TimeStamp_t *)appMsg->data;
          ts->millisec = p->time % 1000UL;
          ts->second = p->time / 1000UL % 60;
          ts->minute = p->time / 60000UL % 60;
          ts->interval = p->interval;

          nmemcpy((void *)(appMsg->data + TSTAMPOFFSET), (void *)p->buffer, p->size);
          if (SUCCESS != DataMgmtM$insertAndStartSend(msg)) {
              ;
              DataMgmtM$freebuffercount++;
              freeBuffer(&DataMgmtM$buffQueue, msg);
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 552
                DataMgmtM$presendTaskBusy = FALSE;
#line 552
                __nesc_atomic_end(__nesc_atomic); }
              return;
            }
          else {
              if (p->type == TYPE_DATA_COMPRESS && p->compressnum > 0) {
                  DataMgmtM$seqno += p->compressnum - 1;
                  ;
                }
              DataMgmtM$DataMgmt$freeBlk((void *)p);
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 561
                DataMgmtM$seqno++;
#line 561
                __nesc_atomic_end(__nesc_atomic); }
              ;
            }
        }
      else {
          DataMgmtM$f_allocbuffercount++;
          DataMgmtM$tryNextSend();

          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 569
            DataMgmtM$presendTaskBusy = FALSE;
#line 569
            __nesc_atomic_end(__nesc_atomic); }
          return;
        }
    }
  else {

      DataMgmtM$nothingtosend++;
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 577
        DataMgmtM$presendTaskBusy = FALSE;
#line 577
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  if (headMemElement(&DataMgmtM$sensorMem, MEMPENDING) != NULL) {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 582
        DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 582
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  else {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 587
        DataMgmtM$presendTaskBusy = FALSE;
#line 587
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
}

# 571 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static void TimeSyncM$adjustRootID(void)
#line 571
{
  if (TimeSyncM$RealTime$getMode() == GPS_SYNC) {
      if (TimeSyncM$RealTime$isSync()) {

          if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == 0xffff) {
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = TOS_LOCAL_ADDRESS;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = 0;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = TRUE;
              TimeSyncM$rootid = ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID;
            }
          else {


              TimeSyncM$heartBeats = 0;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = TOS_LOCAL_ADDRESS;
              ++ ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = TRUE;
              TimeSyncM$rootid = ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID;
            }
        }
      else 



        {
        }
    }
  else 
    {

      if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == 0xffff && ++TimeSyncM$heartBeats > TimeSyncM$ROOT_TIMEOUT) {
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = TOS_LOCAL_ADDRESS;
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = 0;
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = FALSE;
          TimeSyncM$rootid = ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID;
          TimeSyncM$heartBeats = 0;
        }
      else {

          if (TimeSyncM$heartBeats > TimeSyncM$ROOT_TIMEOUT) {
              TimeSyncM$heartBeats = 0;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = TOS_LOCAL_ADDRESS;
              ++ ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum;
              ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS = FALSE;
              TimeSyncM$rootid = ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID;
            }
          else {
            }
        }
    }
}


static  void TimeSyncM$sendMsg(void)
#line 624
{
  uint32_t localTime;
#line 625
  uint32_t globalTime_t;

  localTime = TimeSyncM$GlobalTime$getLocalTime();

  if (TimeSyncM$mode != TS_USER_MODE) {
      TimeSyncM$GlobalTime$getGlobalTime(&globalTime_t);
    }
  else 
#line 631
    {
    }






  if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS) {
      if ((int32_t )(localTime - TimeSyncM$localAverage) >= 0x20000000) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 641
            {
              TimeSyncM$localAverage = localTime;
              TimeSyncM$offsetAverage = globalTime_t - localTime;
            }
#line 644
            __nesc_atomic_end(__nesc_atomic); }
        }
    }







  TimeSyncM$adjustRootID();







  if (TimeSyncM$mode != TS_USER_MODE) {

      if (TimeSyncM$numEntries < TimeSyncM$ENTRY_SEND_LIMIT && ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID != TOS_LOCAL_ADDRESS) {
          ++TimeSyncM$heartBeats;



          TimeSyncM$state &= ~TimeSyncM$STATE_SENDING;
        }
      else {
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->sendingTime = globalTime_t - localTime;
          (
          (TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->wroteStamp = FAIL;

          if (TimeSyncM$SendMsg$send(TOS_BCAST_ADDR, TIMESYNCMSG_LEN, &TimeSyncM$outgoingMsgBuffer) != SUCCESS) {
              TimeSyncM$state &= ~TimeSyncM$STATE_SENDING;
              TimeSyncM$TimeSyncNotify$msg_sent();
            }
        }
    }
  else {
      ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->sendingTime = globalTime_t - localTime;
      ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->wroteStamp = FAIL;

      if (TimeSyncM$SendMsg$send(TOS_BCAST_ADDR, TIMESYNCMSG_LEN, &TimeSyncM$outgoingMsgBuffer) != SUCCESS) {
          TimeSyncM$state &= ~TimeSyncM$STATE_SENDING;
          TimeSyncM$TimeSyncNotify$msg_sent();
        }
    }
}

# 459 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static   uint32_t RealTimeM$LocalTime$read(void)
#line 459
{
  uint32_t time;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 462
    time = RealTimeM$localTime;
#line 462
    __nesc_atomic_end(__nesc_atomic); }
  return time;
}

# 216 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *time)
{
  *time = TimeSyncM$GlobalTime$getLocalTime();






  return TimeSyncM$GlobalTime$local2Global(time);
}


static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *time)
{



  *time += TimeSyncM$offsetAverage + (int32_t )(TimeSyncM$skew * (int32_t )(*time - TimeSyncM$localAverage));
  return TimeSyncM$is_synced();
}

# 123 "/opt/tinyos-1.x/tos/platform/msp430/MSP430TimerM.nc"
 __attribute((wakeup)) __attribute((interrupt(12))) void sig_TIMERA0_VECTOR(void)
{
  if (MSP430TimerM$ControlA0$getControl().cap) {
    MSP430TimerM$CaptureA0$captured(MSP430TimerM$CaptureA0$getEvent());
    }
  else {
#line 128
    MSP430TimerM$CompareA0$fired();
    }
}

#line 131
 __attribute((wakeup)) __attribute((interrupt(10))) void sig_TIMERA1_VECTOR(void)
{
  int n = TA0IV;

#line 134
  switch (n) 
    {
      case 0: break;
      case 2: 
        if (MSP430TimerM$ControlA1$getControl().cap) {
          MSP430TimerM$CaptureA1$captured(MSP430TimerM$CaptureA1$getEvent());
          }
        else {
#line 141
          MSP430TimerM$CompareA1$fired();
          }
#line 142
      break;
      case 4: 
        if (MSP430TimerM$ControlA2$getControl().cap) {
          MSP430TimerM$CaptureA2$captured(MSP430TimerM$CaptureA2$getEvent());
          }
        else {
#line 147
          MSP430TimerM$CompareA2$fired();
          }
#line 148
      break;
      case 6: break;
      case 8: break;
      case 10: MSP430TimerM$TimerA$overflow();
#line 151
      break;
      case 12: break;
      case 14: break;
    }
}

#line 277
 __attribute((wakeup)) __attribute((interrupt(26))) void sig_TIMERB0_VECTOR(void)
{
  if (MSP430TimerM$ControlB0$getControl().cap) {
    MSP430TimerM$CaptureB0$captured(MSP430TimerM$CaptureB0$getEvent());
    }
  else {
#line 282
    MSP430TimerM$CompareB0$fired();
    }
}

#line 285
 __attribute((wakeup)) __attribute((interrupt(24))) void sig_TIMERB1_VECTOR(void)
{
  int n = TBIV;

#line 288
  switch (n) 
    {
      case 0: break;
      case 2: 
        if (MSP430TimerM$ControlB1$getControl().cap) {
          MSP430TimerM$CaptureB1$captured(MSP430TimerM$CaptureB1$getEvent());
          }
        else {
#line 295
          MSP430TimerM$CompareB1$fired();
          }
#line 296
      break;
      case 4: 
        if (MSP430TimerM$ControlB2$getControl().cap) {
          MSP430TimerM$CaptureB2$captured(MSP430TimerM$CaptureB2$getEvent());
          }
        else {
#line 301
          MSP430TimerM$CompareB2$fired();
          }
#line 302
      break;
      case 6: 
        if (MSP430TimerM$ControlB3$getControl().cap) {
          MSP430TimerM$CaptureB3$captured(MSP430TimerM$CaptureB3$getEvent());
          }
        else {
#line 307
          MSP430TimerM$CompareB3$fired();
          }
#line 308
      break;
      case 8: 
        if (MSP430TimerM$ControlB4$getControl().cap) {
          MSP430TimerM$CaptureB4$captured(MSP430TimerM$CaptureB4$getEvent());
          }
        else {
#line 313
          MSP430TimerM$CompareB4$fired();
          }
#line 314
      break;
      case 10: 
        if (MSP430TimerM$ControlB5$getControl().cap) {
          MSP430TimerM$CaptureB5$captured(MSP430TimerM$CaptureB5$getEvent());
          }
        else {
#line 319
          MSP430TimerM$CompareB5$fired();
          }
#line 320
      break;
      case 12: 
        if (MSP430TimerM$ControlB6$getControl().cap) {
          MSP430TimerM$CaptureB6$captured(MSP430TimerM$CaptureB6$getEvent());
          }
        else {
#line 325
          MSP430TimerM$CompareB6$fired();
          }
#line 326
      break;
      case 14: MSP430TimerM$TimerB$overflow();
#line 327
      break;
    }
}

# 185 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static   result_t HPLCC2420InterruptM$SFD$enableCapture(bool low_to_high)
#line 185
{
  uint8_t _direction;

#line 187
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 187
    {
      TOSH_SEL_CC_SFD_MODFUNC();
      HPLCC2420InterruptM$SFDControl$disableEvents();
      if (low_to_high) {
#line 190
        _direction = MSP430TIMER_CM_RISING;
        }
      else {
#line 191
        _direction = MSP430TIMER_CM_FALLING;
        }
#line 192
      HPLCC2420InterruptM$SFDControl$setControlAsCapture(_direction);
      HPLCC2420InterruptM$SFDCapture$clearOverflow();
      HPLCC2420InterruptM$SFDControl$clearPendingInterrupt();
      HPLCC2420InterruptM$SFDControl$enableEvents();
    }
#line 196
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static   result_t HPLCC2420InterruptM$SFD$disable(void)
#line 200
{
  /* atomic removed: atomic calls only */
#line 201
  {
    HPLCC2420InterruptM$SFDControl$disableEvents();
    HPLCC2420InterruptM$SFDControl$clearPendingInterrupt();
    TOSH_SEL_CC_SFD_IOFUNC();
  }
  return SUCCESS;
}

# 292 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t _length, uint8_t *buffer)
#line 292
{
  uint8_t i = 0;

#line 294
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 295
        {
          HPLCC2420M$f.busy = TRUE;
          HPLCC2420M$ramaddr = addr;
          HPLCC2420M$ramlen = _length;
          HPLCC2420M$rambuf = buffer;
        }
#line 300
        __nesc_atomic_end(__nesc_atomic); }
      TOSH_CLR_RADIO_CSN_PIN();

      HPLCC2420M$USARTControl$isTxIntrPending();
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx((HPLCC2420M$ramaddr & 0x7F) | 0x80);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
      HPLCC2420M$USARTControl$tx((HPLCC2420M$ramaddr >> 1) & 0xC0);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
      for (i = 0; i < HPLCC2420M$ramlen; i++) {
          HPLCC2420M$USARTControl$tx(HPLCC2420M$rambuf[i]);
          while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxIntrPending()) ;
        }
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isTxEmpty()) ;
      TOSH_SET_RADIO_CSN_PIN();
      HPLCC2420M$BusArbitration$releaseBus();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 316
        HPLCC2420M$f.busy = FALSE;
#line 316
        __nesc_atomic_end(__nesc_atomic); }
      return TOS_post(HPLCC2420M$signalRAMWr);
    }
  return FAIL;
}

# 113 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static void CC2420RadioM$sendFailed(void)
#line 113
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 114
    CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
#line 114
    __nesc_atomic_end(__nesc_atomic); }
  CC2420RadioM$txbufptr->length = CC2420RadioM$txbufptr->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;
  CC2420RadioM$Send$sendDone(CC2420RadioM$txbufptr, FAIL);
}

#line 168
static  void CC2420RadioM$PacketSent(void)
#line 168
{
  TOS_MsgPtr pBuf;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 171
    {
      CC2420RadioM$stateRadio = CC2420RadioM$IDLE_STATE;
      pBuf = CC2420RadioM$txbufptr;
      pBuf->length = pBuf->length - MSG_HEADER_SIZE - MSG_FOOTER_SIZE;
    }
#line 175
    __nesc_atomic_end(__nesc_atomic); }

  CC2420RadioM$Send$sendDone(pBuf, SUCCESS);
}

#line 393
static  void CC2420RadioM$startSend(void)
#line 393
{

  if (!CC2420RadioM$HPLChipcon$cmd(0x09)) {
      CC2420RadioM$sendFailed();
      return;
    }

  if (!CC2420RadioM$HPLChipconFIFO$writeTXFIFO(CC2420RadioM$txlength + 1, (uint8_t *)CC2420RadioM$txbufptr)) {
      CC2420RadioM$sendFailed();
      return;
    }
}





static void CC2420RadioM$tryToSend(void)
#line 410
{
  uint8_t currentstate;

#line 412
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 412
    currentstate = CC2420RadioM$stateRadio;
#line 412
    __nesc_atomic_end(__nesc_atomic); }


  if (currentstate == CC2420RadioM$PRE_TX_STATE) {



      if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
          CC2420RadioM$flushRXFIFO();
        }

      if (TOSH_READ_RADIO_CCA_PIN()) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 424
            CC2420RadioM$stateRadio = CC2420RadioM$TX_STATE;
#line 424
            __nesc_atomic_end(__nesc_atomic); }
          CC2420RadioM$sendPacket();
        }
      else {



          if (CC2420RadioM$countRetry-- <= 0) {
              CC2420RadioM$flushRXFIFO();
              CC2420RadioM$countRetry = 8;
              if (!TOS_post(CC2420RadioM$startSend)) {
                CC2420RadioM$sendFailed();
                }
#line 436
              return;
            }
          if (!CC2420RadioM$setBackoffTimer(CC2420RadioM$MacBackoff$congestionBackoff(CC2420RadioM$txbufptr) * 10)) {
              CC2420RadioM$sendFailed();
            }
        }
    }
}

#line 119
static void CC2420RadioM$flushRXFIFO(void)
#line 119
{
  CC2420RadioM$FIFOP$disable();
  CC2420RadioM$HPLChipcon$read(0x3F);
  CC2420RadioM$HPLChipcon$cmd(0x08);
  CC2420RadioM$HPLChipcon$cmd(0x08);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 124
    CC2420RadioM$bPacketReceiving = FALSE;
#line 124
    __nesc_atomic_end(__nesc_atomic); }
  CC2420RadioM$FIFOP$startWait(FALSE);
}

# 78 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static   result_t HPLCC2420InterruptM$FIFOP$disable(void)
#line 78
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 79
    {
      HPLCC2420InterruptM$FIFOPInterrupt$disable();
      HPLCC2420InterruptM$FIFOPInterrupt$clear();
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 205 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420M.nc"
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr)
#line 205
{
  uint16_t data = 0;

#line 207
  if (HPLCC2420M$BusArbitration$getBus() == SUCCESS) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 209
        HPLCC2420M$f.busy = TRUE;
#line 209
        __nesc_atomic_end(__nesc_atomic); }
      TOSH_CLR_RADIO_CSN_PIN();

      HPLCC2420M$USARTControl$isTxIntrPending();
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx(addr | 0x40);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
      HPLCC2420M$USARTControl$rx();
      HPLCC2420M$USARTControl$tx(0);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
      data = (HPLCC2420M$USARTControl$rx() << 8) & 0xFF00;
      HPLCC2420M$USARTControl$tx(0);
      while (HPLCC2420M$f.enabled && !HPLCC2420M$USARTControl$isRxIntrPending()) ;
      data = data | (HPLCC2420M$USARTControl$rx() & 0x0FF);
      TOSH_SET_RADIO_CSN_PIN();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 224
        HPLCC2420M$f.busy = FALSE;
#line 224
        __nesc_atomic_end(__nesc_atomic); }
#line 242
      HPLCC2420M$BusArbitration$releaseBus();
    }
  return data;
}

# 65 "/opt/tinyos-1.x/tos/platform/telos/HPLCC2420InterruptM.nc"
static   result_t HPLCC2420InterruptM$FIFOP$startWait(bool low_to_high)
#line 65
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 66
    {
      HPLCC2420InterruptM$FIFOPInterrupt$disable();
      HPLCC2420InterruptM$FIFOPInterrupt$clear();
      HPLCC2420InterruptM$FIFOPInterrupt$edge(low_to_high);
      HPLCC2420InterruptM$FIFOPInterrupt$enable();
    }
#line 71
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 373 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static  void RealTimeM$signalOneTimer(void)
#line 373
{
  uint8_t itimer;

#line 375
  if ((itimer = RealTimeM$dequeue()) < NUM_TIMERS) {
      RealTimeM$Timer$fired(itimer);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 377
        RealTimeM$taskBusy = TOS_post(RealTimeM$signalOneTimer);
#line 377
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 380
        RealTimeM$taskBusy = FALSE;
#line 380
        __nesc_atomic_end(__nesc_atomic); }
    }
}

#line 169
static  uint32_t RealTimeM$RealTime$getTimeCount(void)
#line 169
{







  if (RealTimeM$syncMode == FTSP_SYNC) {
    return RealTimeM$globaltime_t;
    }
  else {
#line 180
    return RealTimeM$localTime % HOUR_END;
    }
}

# 160 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static  void ADCM$readADCTask(void)
#line 160
{
  if (ADCM$adc_count[0] == 0) {
    return;
    }
  if (ADCM$triggerConversion(0) == SUCCESS) {
      ADCM$Leds$greenToggle();
      ADCM$adc_count[0] -= 1;
    }
  else {
#line 168
    TOS_post(ADCM$readADCTask);
    }
}

#line 137
static result_t ADCM$triggerConversion(uint8_t port)
#line 137
{

  MSP430ADC12Settings_t settings;

#line 140
  settings.refVolt2_5 = (ADCM$TOSH_adc_portmap[port] & 0x80) >> 7;
  settings.clockSourceSHT = SHT_SOURCE_SMCLK;
  settings.clockSourceSAMPCON = SAMPCON_SOURCE_SMCLK;
  settings.referenceVoltage = (ADCM$TOSH_adc_portmap[port] & 0x70) >> 4;
  settings.clockDivSAMPCON = SAMPCON_CLOCK_DIV_1;
  settings.clockDivSHT = SHT_CLOCK_DIV_1;
  settings.inputChannel = ADCM$TOSH_adc_portmap[port] & 0x0F;
  settings.sampleHoldTime = ADCM$samplingRate;


  if (ADCM$MSP430ADC12Single$bind(settings) == SUCCESS) {
      if (!ADCM$continuousData && ADCM$MSP430ADC12Single$getData() != MSP430ADC12_FAIL) {
          ADCM$owner = port;
          return SUCCESS;
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 156
    ADCM$busy = FALSE;
#line 156
    __nesc_atomic_end(__nesc_atomic); }
  return FAIL;
}

# 203 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static msp430ADCresult_t MSP430ADC12M$newRequest(uint8_t req, uint8_t num, void *dataDest, uint16_t length, uint16_t jiffies)
{
  bool access = FALSE;
  msp430ADCresult_t res = MSP430ADC12_FAIL;




  const int16_t num16 = num;


  if (num16 >= 5U || (!MSP430ADC12M$reserved && (
  !length || (req == REPEAT_SEQUENCE_OF_CHANNELS && length > 16)))) {
    return MSP430ADC12_FAIL;
    }






  if (jiffies == 1 || jiffies == 2) {
    return MSP430ADC12_FAIL;
    }

  if (MSP430ADC12M$reserved & RESERVED) {
    if (!(MSP430ADC12M$reserved & VREF_WAIT) && MSP430ADC12M$owner == num16 && MSP430ADC12M$cmode == req) {
        MSP430ADC12M$HPLADC12$startConversion();
        if (MSP430ADC12M$reserved & TIMER_USED) {
          MSP430ADC12M$startTimerA();
          }
#line 233
        MSP430ADC12M$reserved = ADC_IDLE;
        return MSP430ADC12_SUCCESS;
      }
    else {
#line 236
      return MSP430ADC12_FAIL;
      }
    }
#line 238
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 238
    {
      if (MSP430ADC12M$cmode == ADC_IDLE) {
          MSP430ADC12M$owner = num16;
          MSP430ADC12M$cmode = SEQUENCE_OF_CHANNELS;
          access = TRUE;
        }
    }
#line 244
    __nesc_atomic_end(__nesc_atomic); }

  if (access) {
      res = MSP430ADC12_SUCCESS;
      switch (MSP430ADC12M$getRefVolt(num16)) 
        {
          case MSP430ADC12_FAIL: 
            MSP430ADC12M$cmode = ADC_IDLE;
          res = MSP430ADC12_FAIL;
          break;
          case MSP430ADC12_DELAYED: 


            req |= RESERVED | VREF_WAIT;
          res = MSP430ADC12_DELAYED;
          MSP430ADC12M$vrefWait = TRUE;

          case MSP430ADC12_SUCCESS: 
            {
              int8_t i;
#line 263
              int8_t memctlsUsed = length;
              uint16_t mask = 1;
              adc12memctl_t lastMemctl = MSP430ADC12M$adc12settings[num16].memctl;
              uint16_t ctl0 = (0x0000 | 0x0010) & ~0x0080;
              adc12ctl1_t ctl1 = { .adc12busy = 0, .conseq = 1, 
              .adc12ssel = MSP430ADC12M$adc12settings[num16].clockSourceSHT, 
              .adc12div = MSP430ADC12M$adc12settings[num16].clockDivSHT, .issh = 0, .shp = 1, 
              .shs = 1, .cstartadd = 0 };

#line 271
              if (length > 16) {
                  ctl1.conseq = 3;
                  memctlsUsed = 16;
                }
              MSP430ADC12M$bufPtr = dataDest;
              MSP430ADC12M$bufLength = length;
              MSP430ADC12M$bufOffset = 0;


              MSP430ADC12M$HPLADC12$disableConversion();
              if (jiffies == 0) {
                  ctl0 = (0x0000 | 0x0010) | 0x0080;
                  ctl1.shs = 0;
                }
              for (i = 0; i < memctlsUsed - 1; i++) 
                MSP430ADC12M$HPLADC12$setMemControl(i, MSP430ADC12M$adc12settings[num16].memctl);
              lastMemctl.eos = 1;
              MSP430ADC12M$HPLADC12$setMemControl(i, lastMemctl);
              MSP430ADC12M$HPLADC12$setIEFlags(mask << i);
              MSP430ADC12M$HPLADC12$setControl0_IgnoreRef(* (adc12ctl0_t *)&ctl0);
              MSP430ADC12M$HPLADC12$setSHT(MSP430ADC12M$adc12settings[num16].sampleHoldTime);

              if (req & SINGLE_CHANNEL) {
                  ctl1.conseq = 0;
                  MSP430ADC12M$cmode = SINGLE_CHANNEL;
                }
              else {
#line 296
                if (req & REPEAT_SINGLE_CHANNEL) {
                    ctl1.conseq = 2;
                    MSP430ADC12M$cmode = REPEAT_SINGLE_CHANNEL;
                  }
                else {
#line 299
                  if (req & REPEAT_SEQUENCE_OF_CHANNELS) {
                      ctl1.conseq = 3;
                      MSP430ADC12M$cmode = REPEAT_SEQUENCE_OF_CHANNELS;
                    }
                  }
                }
#line 303
              MSP430ADC12M$HPLADC12$setControl1(ctl1);

              if (req & RESERVED) {

                  MSP430ADC12M$reserved = req;
                  if (jiffies != 0) {
                      MSP430ADC12M$prepareTimerA(jiffies, MSP430ADC12M$adc12settings[num16].clockSourceSAMPCON, 
                      MSP430ADC12M$adc12settings[num16].clockDivSAMPCON);
                      MSP430ADC12M$reserved |= TIMER_USED;
                    }
                }
              else 
#line 313
                {

                  MSP430ADC12M$HPLADC12$startConversion();
                  if (jiffies != 0) {
                      MSP430ADC12M$prepareTimerA(jiffies, MSP430ADC12M$adc12settings[num16].clockSourceSAMPCON, 
                      MSP430ADC12M$adc12settings[num16].clockDivSAMPCON);
                      MSP430ADC12M$startTimerA();
                    }
                }
              res = MSP430ADC12_SUCCESS;
              break;
            }
        }
    }
  return res;
}

# 106 "/opt/tinyos-1.x/tos/platform/msp430/RefVoltM.nc"
static   result_t RefVoltM$RefVolt$get(RefVolt_t vref)
#line 106
{
  result_t result = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (RefVoltM$semaCount == 0) {
          if (RefVoltM$HPLADC12$isBusy()) {
            result = FAIL;
            }
          else 
#line 113
            {
              if (RefVoltM$state == RefVoltM$REFERENCE_OFF) {
                RefVoltM$switchRefOn(vref);
                }
              else {
#line 116
                if ((RefVoltM$state == RefVoltM$REFERENCE_1_5V_PENDING && vref == REFERENCE_2_5V) || (
                RefVoltM$state == RefVoltM$REFERENCE_2_5V_PENDING && vref == REFERENCE_1_5V)) {
                  RefVoltM$switchToRefPending(vref);
                  }
                else {
#line 119
                  if ((RefVoltM$state == RefVoltM$REFERENCE_1_5V_STABLE && vref == REFERENCE_2_5V) || (
                  RefVoltM$state == RefVoltM$REFERENCE_2_5V_STABLE && vref == REFERENCE_1_5V)) {
                    RefVoltM$switchToRefStable(vref);
                    }
                  }
                }
#line 122
              RefVoltM$semaCount++;
              RefVoltM$switchOff = FALSE;
              result = SUCCESS;
            }
        }
      else {

        if ((((
#line 127
        RefVoltM$state == RefVoltM$REFERENCE_1_5V_PENDING && vref == REFERENCE_1_5V) || (
        RefVoltM$state == RefVoltM$REFERENCE_2_5V_PENDING && vref == REFERENCE_2_5V)) || (
        RefVoltM$state == RefVoltM$REFERENCE_1_5V_STABLE && vref == REFERENCE_1_5V)) || (
        RefVoltM$state == RefVoltM$REFERENCE_2_5V_STABLE && vref == REFERENCE_2_5V)) {
            RefVoltM$semaCount++;
            RefVoltM$switchOff = FALSE;
            result = SUCCESS;
          }
        else {
#line 135
          result = FAIL;
          }
        }
    }
#line 138
    __nesc_atomic_end(__nesc_atomic); }
#line 137
  return result;
}

# 73 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static   void HPLADC12M$HPLADC12$setMemControl(uint8_t i, adc12memctl_t memControl)
#line 73
{
  uint8_t *memCtlPtr = (uint8_t *)(char *)0x0080;

#line 75
  if (i < 16) {
      memCtlPtr += i;
      *memCtlPtr = * (uint8_t *)&memControl;
    }
}

# 168 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static void MSP430ADC12M$prepareTimerA(uint16_t interval, uint16_t csSAMPCON, uint16_t cdSAMPCON)
{
  MSP430CompareControl_t ccResetSHI = { 
  .ccifg = 0, .cov = 0, .out = 0, .cci = 0, .ccie = 0, 
  .outmod = 0, .cap = 0, .clld = 0, .scs = 0, .ccis = 0, .cm = 0 };

  MSP430ADC12M$TimerA$setMode(MSP430TIMER_STOP_MODE);
  MSP430ADC12M$TimerA$clear();
  MSP430ADC12M$TimerA$disableEvents();
  MSP430ADC12M$TimerA$setClockSource(csSAMPCON);
  MSP430ADC12M$TimerA$setInputDivider(cdSAMPCON);
  MSP430ADC12M$ControlA0$setControl(ccResetSHI);
  MSP430ADC12M$CompareA0$setEvent(interval - 1);
  MSP430ADC12M$CompareA1$setEvent((interval - 1) / 2);
}

# 171 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static  void ADCM$readLightTask(void)
#line 171
{
  if (ADCM$adc_count[1] == 0) {
    return;
    }
  if (ADCM$triggerConversion(1) == SUCCESS) {
      ADCM$Leds$redToggle();
      ADCM$adc_count[1] -= 1;
    }
  else {
#line 179
    TOS_post(ADCM$readLightTask);
    }
}

# 58 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART0M.nc"
 __attribute((wakeup)) __attribute((interrupt(18))) void sig_UART0RX_VECTOR(void)
#line 58
{
  uint8_t temp = U0RXBUF;

#line 60
  HPLUSART0M$USARTData$rxDone(temp);
}

 __attribute((wakeup)) __attribute((interrupt(16))) void sig_UART0TX_VECTOR(void)
#line 63
{
  if (HPLUSART0M$USARTControl$isI2C()) {
    HPLUSART0M$HPLI2CInterrupt$fired();
    }
  else {
#line 67
    HPLUSART0M$USARTData$txDone();
    }
}

# 56 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
 __attribute((wakeup)) __attribute((interrupt(8))) void sig_PORT1_VECTOR(void)
{
  volatile int n = MSP430InterruptM$P1IFG & MSP430InterruptM$P1IE;

  if (n & (1 << 0)) {
#line 60
      MSP430InterruptM$Port10$fired();
#line 60
      return;
    }
#line 61
  if (n & (1 << 1)) {
#line 61
      MSP430InterruptM$Port11$fired();
#line 61
      return;
    }
#line 62
  if (n & (1 << 2)) {
#line 62
      MSP430InterruptM$Port12$fired();
#line 62
      return;
    }
#line 63
  if (n & (1 << 3)) {
#line 63
      MSP430InterruptM$Port13$fired();
#line 63
      return;
    }
#line 64
  if (n & (1 << 4)) {
#line 64
      MSP430InterruptM$Port14$fired();
#line 64
      return;
    }
#line 65
  if (n & (1 << 5)) {
#line 65
      MSP430InterruptM$Port15$fired();
#line 65
      return;
    }
#line 66
  if (n & (1 << 6)) {
#line 66
      MSP430InterruptM$Port16$fired();
#line 66
      return;
    }
#line 67
  if (n & (1 << 7)) {
#line 67
      MSP430InterruptM$Port17$fired();
#line 67
      return;
    }
}

# 540 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static void CC2420RadioM$delayedRXFIFO(void)
#line 540
{
  uint8_t len = MSG_DATA_SIZE;
  uint8_t _bPacketReceiving;

  if (!TOSH_READ_CC_FIFO_PIN() && !TOSH_READ_CC_FIFOP_PIN()) {
      CC2420RadioM$flushRXFIFO();
      return;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 549
    {
      _bPacketReceiving = CC2420RadioM$bPacketReceiving;

      if (_bPacketReceiving) {
          if (!TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
            CC2420RadioM$flushRXFIFO();
            }
        }
      else 
#line 555
        {
          CC2420RadioM$bPacketReceiving = TRUE;
        }
    }
#line 558
    __nesc_atomic_end(__nesc_atomic); }





  if (!_bPacketReceiving) {
      if (!CC2420RadioM$HPLChipconFIFO$readRXFIFO(len, (uint8_t *)CC2420RadioM$rxbufptr)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 566
            CC2420RadioM$bPacketReceiving = FALSE;
#line 566
            __nesc_atomic_end(__nesc_atomic); }
          if (!TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
              CC2420RadioM$flushRXFIFO();
            }
          return;
        }
    }
  CC2420RadioM$flushRXFIFO();
}

# 650 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static TOS_MsgPtr GenericCommProM$received(TOS_MsgPtr msg)
#line 650
{

  uint16_t addr = TOS_LOCAL_ADDRESS;

#line 653
  if (msg->crc == 1 && msg->group == TOS_AM_GROUP) {
    GenericCommProM$Intercept$intercept(msg, msg->data, msg->length);
    }

  if (
#line 656
  msg->crc == 1 && 
  msg->group == TOS_AM_GROUP && (
  msg->addr == TOS_BCAST_ADDR || 
  msg->addr == addr)) {
      uint8_t type = msg->type;
      TOS_MsgPtr tmp;

#line 662
      tmp = GenericCommProM$ReceiveMsg$receive(type, msg);
      if (tmp) {
        msg = tmp;
        }
    }
#line 666
  return msg;
}

# 227 "/home/xu/oasis/system/platform/telosb/RTC/RealTimeM.nc"
static  result_t RealTimeM$RealTime$setTimeCount(uint32_t newCount, uint8_t userMode)
#line 227
{
  uint8_t i = 0;
  uint32_t interval = 0;
  uint32_t localcount = 0;
  result_t result = FAIL;








  if (RealTimeM$syncMode == FTSP_SYNC && userMode == FTSP_SYNC) {
      RealTimeM$GlobalTime$getGlobalTime(&localcount);
      if (localcount) {
          if (RealTimeM$is_synced != TRUE) {
              if (newCount == 0) {
                  RealTimeM$localTime = localcount;
                }
              RealTimeM$is_synced = TRUE;
              RealTimeM$Leds$yellowToggle();
              result = SUCCESS;
            }
          else 
#line 250
            {
              return result;
            }
        }
    }


  if (RealTimeM$mState) {
      for (i = 0; i < RealTimeM$numClients; i++) {
          if (RealTimeM$mState & (0x1L << RealTimeM$clientList[i].id)) {
              interval = RealTimeM$clientList[i].syncInterval;

              if (interval != 0) {
                  RealTimeM$clientList[i].fireCount = (RealTimeM$localTime / interval + 1) * interval;
                  RealTimeM$Leds$greenToggle();
                }
            }
        }
    }

  return result;
}

# 357 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect)
#line 357
{
  uint8_t ind = 0;

#line 359
  ind = NeighborMgmtM$findPreparedIndex(childAddr);
  if (ind == ROUTE_INVALID) {
    return FALSE;
    }
  else 
#line 362
    {
      if (isDirect) {
          if (!(NeighborMgmtM$NeighborTbl[ind].relation & NBR_DIRECT_CHILD)) {
              NeighborMgmtM$NeighborTbl[ind].relation = NBR_DIRECT_CHILD | NBR_CHILD;
              NeighborMgmtM$CascadeControl$addDirectChild(childAddr);
            }
        }
      else {
          if (NeighborMgmtM$NeighborTbl[ind].relation & NBR_DIRECT_CHILD) {

              NeighborMgmtM$CascadeControl$deleteDirectChild(childAddr);
            }


          NeighborMgmtM$NeighborTbl[ind].relation = NBR_CHILD;
        }

      NeighborMgmtM$NeighborTbl[ind].priorHop = priorHop;
      NeighborMgmtM$NeighborTbl[ind].childLiveliness = CHILD_LIVELINESS;
      return TRUE;
    }
}

# 188 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static void CascadesRouterM$addToChildrenList(address_t nodeID)
#line 188
{
  int8_t i;
  int8_t myIndex;
  bool found;
  int8_t first = 0;

#line 193
  for (myIndex = MAX_CAS_BUF - 1; myIndex >= 0; myIndex--) {
      found = FALSE;
      for (i = 0; i < MAX_NUM_CHILDREN; i++) {
          if (CascadesRouterM$myBuffer[myIndex].childrenList[i].childID == nodeID) {
              if (found != TRUE) {
                  found = TRUE;
                }
              else {
                  CascadesRouterM$myBuffer[myIndex].childrenList[i].childID = 0;
                  CascadesRouterM$myBuffer[myIndex].childrenList[i].status = 0;
                }
            }
          else {
              if (CascadesRouterM$myBuffer[myIndex].childrenList[i].childID == 0) {
                  if (first == 0) {
                      first = i;
                    }
                }
            }
        }
      if (found != TRUE) {
          CascadesRouterM$myBuffer[myIndex].childrenList[first].childID = nodeID;
          CascadesRouterM$myBuffer[myIndex].childrenList[first].status = 0;
        }
    }
}

# 147 "/home/xu/oasis/lib/MultiHopOasis/MultiHopLQI.nc"
static uint16_t MultiHopLQI$adjustLQI(uint8_t val)
#line 147
{
  uint16_t result = 80 - (val - 50);

#line 149
  result = (result * result >> 3) * result >> 3;
  return result;
}

# 439 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t addr, uint16_t parentCost)
#line 439
{
  uint8_t ind = 0;

#line 441
  ind = NeighborMgmtM$findPreparedIndex(addr);
  if (ind == ROUTE_INVALID) {
      ;
      return FALSE;
    }
  else {
      NeighborMgmtM$NeighborTbl[ind].parentCost = parentCost;
      return TRUE;
    }
}

# 960 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static  TOS_MsgPtr CascadesRouterM$ReceiveMsg$receive(uint8_t type, TOS_MsgPtr tmsg)
#line 960
{
  CasCtrlMsg *CCMsg;

#line 962
  if (type == AM_CASCTRLMSG) {
      CCMsg = (CasCtrlMsg *)tmsg->data;
      switch (CCMsg->type) {
          case TYPE_CASCADES_NODATA: {
              CascadesRouterM$processNoData(tmsg);
            }
          break;
          case TYPE_CASCADES_ACK: {
              CascadesRouterM$processACK(tmsg);
            }
          break;
          case TYPE_CASCADES_REQ: {
              if (CascadesRouterM$RequestProcessBusy != TRUE) {
                  nmemcpy((void *)&CascadesRouterM$RecvRequestMsg, (void *)tmsg, sizeof(TOS_Msg ));
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 976
                    CascadesRouterM$RequestProcessBusy = TOS_post(CascadesRouterM$processRequest);
#line 976
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
          break;
          case TYPE_CASCADES_CMAU: {
              if (CascadesRouterM$CMAuProcessBusy != TRUE) {
                  nmemcpy((void *)&CascadesRouterM$RecvCMAuMsg, (void *)tmsg, sizeof(TOS_Msg ));
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 983
                    CascadesRouterM$CMAuProcessBusy = TOS_post(CascadesRouterM$processCMAu);
#line 983
                    __nesc_atomic_end(__nesc_atomic); }
                }
            }
          break;
          default: {
              ;
            }
#line 989
          break;
        }
    }
  else {
#line 992
    if (type == AM_CASCADESMSG) {
        if (CascadesRouterM$DataProcessBusy != TRUE) {
            nmemcpy((void *)&CascadesRouterM$RecvDataMsg, (void *)tmsg, sizeof(TOS_Msg ));
            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 995
              CascadesRouterM$DataProcessBusy = TOS_post(CascadesRouterM$processData);
#line 995
              __nesc_atomic_end(__nesc_atomic); }
          }
      }
    else {
        ;
      }
    }
#line 1001
  return tmsg;
}

#line 148
static void CascadesRouterM$addChildACK(address_t nodeID, uint8_t myIndex)
#line 148
{
  int8_t i;

#line 150
  if (myIndex < MAX_CAS_BUF) {
      for (i = MAX_NUM_CHILDREN - 1; i >= 0; i--) {
          if (CascadesRouterM$myBuffer[myIndex].childrenList[i].childID == nodeID) {
              CascadesRouterM$myBuffer[myIndex].childrenList[i].status = 1;
            }
        }
    }
}

# 71 "/opt/tinyos-1.x/tos/platform/msp430/MSP430InterruptM.nc"
 __attribute((wakeup)) __attribute((interrupt(2))) void sig_PORT2_VECTOR(void)
{
  volatile int n = MSP430InterruptM$P2IFG & MSP430InterruptM$P2IE;

  if (n & (1 << 0)) {
#line 75
      MSP430InterruptM$Port20$fired();
#line 75
      return;
    }
#line 76
  if (n & (1 << 1)) {
#line 76
      MSP430InterruptM$Port21$fired();
#line 76
      return;
    }
#line 77
  if (n & (1 << 2)) {
#line 77
      MSP430InterruptM$Port22$fired();
#line 77
      return;
    }
#line 78
  if (n & (1 << 3)) {
#line 78
      MSP430InterruptM$Port23$fired();
#line 78
      return;
    }
#line 79
  if (n & (1 << 4)) {
#line 79
      MSP430InterruptM$Port24$fired();
#line 79
      return;
    }
#line 80
  if (n & (1 << 5)) {
#line 80
      MSP430InterruptM$Port25$fired();
#line 80
      return;
    }
#line 81
  if (n & (1 << 6)) {
#line 81
      MSP430InterruptM$Port26$fired();
#line 81
      return;
    }
#line 82
  if (n & (1 << 7)) {
#line 82
      MSP430InterruptM$Port27$fired();
#line 82
      return;
    }
}

#line 85
 __attribute((wakeup)) __attribute((interrupt(28))) void sig_NMI_VECTOR(void)
{
  volatile int n = IFG1;

#line 88
  if (n & (1 << 4)) {
#line 88
      MSP430InterruptM$NMI$fired();
#line 88
      return;
    }
#line 89
  if (n & (1 << 1)) {
#line 89
      MSP430InterruptM$OF$fired();
#line 89
      return;
    }
#line 90
  if (FCTL3 & 0x0004) {
#line 90
      MSP430InterruptM$ACCV$fired();
#line 90
      return;
    }
}

# 55 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
 __attribute((wakeup)) __attribute((interrupt(6))) void sig_UART1RX_VECTOR(void)
#line 55
{
  uint8_t temp = U1RXBUF;

#line 57
  HPLUSART1M$USARTData$rxDone(temp);
}

# 66 "/opt/tinyos-1.x/tos/platform/msp430/crc.h"
static uint16_t crcByte(uint16_t fcs, uint8_t c)
{
  fcs = ccitt_crc16_table[((fcs >> 8) ^ c) & 0xffU] ^ (fcs << 8);
  return fcs;
}

# 60 "/opt/tinyos-1.x/tos/platform/msp430/HPLUSART1M.nc"
 __attribute((wakeup)) __attribute((interrupt(4))) void sig_UART1TX_VECTOR(void)
#line 60
{
  HPLUSART1M$USARTData$txDone();
}

# 470 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static result_t FramerM$TxArbitraryByte(uint8_t inByte)
#line 470
{
  if (inByte == FramerM$HDLC_FLAG_BYTE || inByte == FramerM$HDLC_CTLESC_BYTE) {
      /* atomic removed: atomic calls only */
#line 472
      {
        FramerM$gPrevTxState = FramerM$gTxState;
        FramerM$gTxState = FramerM$TXSTATE_ESC;
        FramerM$gTxEscByte = inByte;
      }
      inByte = FramerM$HDLC_CTLESC_BYTE;
    }

  return FramerM$ByteComm$txByte(inByte);
}

# 163 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
 __attribute((wakeup)) __attribute((interrupt(14))) void sig_ADC_VECTOR(void)
#line 163
{
  uint16_t iv = HPLADC12M$ADC12IV;

#line 165
  switch (iv) 
    {
      case 2: HPLADC12M$HPLADC12$memOverflow();
#line 167
      return;
      case 4: HPLADC12M$HPLADC12$timeOverflow();
#line 168
      return;
    }
  iv >>= 1;
  if (iv && iv < 19) {
    HPLADC12M$HPLADC12$converted(iv - 3);
    }
}

# 430 "/home/xu/oasis/system/platform/telosb/ADC/MSP430ADC12M.nc"
static void MSP430ADC12M$stopConversion(void)
{
  MSP430ADC12M$TimerA$setMode(MSP430TIMER_STOP_MODE);
  MSP430ADC12M$HPLADC12$stopConversion();
  MSP430ADC12M$HPLADC12$setIEFlags(0);
  MSP430ADC12M$HPLADC12$resetIFGs();
  if (MSP430ADC12M$adc12settings[MSP430ADC12M$owner].gotRefVolt) {
    MSP430ADC12M$releaseRefVolt(MSP430ADC12M$owner);
    }
#line 438
  MSP430ADC12M$cmode = ADC_IDLE;
}

# 98 "/opt/tinyos-1.x/tos/platform/msp430/HPLADC12M.nc"
static   void HPLADC12M$HPLADC12$resetIFGs(void)
#line 98
{

  if (!HPLADC12M$ADC12IFG) {
    return;
    }
  else 
#line 102
    {
      uint8_t i;
      volatile uint16_t mud;

#line 105
      for (i = 0; i < 16; i++) 
        mud = HPLADC12M$HPLADC12$getMem(i);
    }
}

# 246 "/home/xu/oasis/system/platform/telosb/ADC/ADCM.nc"
static   result_t ADCM$MSP430ADC12Single$dataReady(uint16_t d)
{
  ADCM$readdone = TRUE;
  ADCM$MSP430ADC12Single$unreserve();
  if (!ADCM$continuousData) {
      /* atomic removed: atomic calls only */
      ADCM$busy = FALSE;
      if (ADCM$owner == 1) {
        }

      if (ADCM$ADC$dataReady(ADCM$owner, d) == FAIL) 
        {
        }

      return SUCCESS;
    }
  else {
#line 261
    if (ADCM$ADC$dataReady(ADCM$owner, d) == FAIL) {
        /* atomic removed: atomic calls only */
        ADCM$busy = FALSE;
        return FAIL;
      }
    }
#line 266
  return SUCCESS;
}

# 734 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static void SmartSensingM$saveData(uint8_t client, uint16_t data)
#line 734
{
  SenBlkPtr p = sensor[client].curBlkPtr;

  if (NULL != p) {
      if (p->size < MAX_BUFFER_SIZE) {
          * (uint16_t *)(p->buffer + p->size) = data;
          p->size += MAX_DATA_WIDTH;
          if (p->type == TYPE_DATA_RVOL) {
              * (uint16_t *)(p->buffer + p->size) = SmartSensingM$RouteControl$getQuality();
              p->size += MAX_DATA_WIDTH;
            }
        }

      if (p->size >= MAX_BUFFER_SIZE) {
          p->size = MAX_BUFFER_SIZE;
          p->taskCode = SmartSensingM$defaultCode;
          p->priority = sensor[client].dataPriority + sensor[client].nodePriority;

          SmartSensingM$DataMgmt$saveBlk((void *)p, 0);
          sensor[client].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(client);
        }
    }
  else 
    {
      ;
      return;
    }
}

# 159 "/home/xu/oasis/system/platform/telosb/ADC/HamamatsuM.nc"
static   uint16_t *HamamatsuM$MSP430ADC12MultiplePAR$dataReady(uint16_t *buf, uint16_t length)
{
  uint16_t *nextbuf;

#line 162
  if (!HamamatsuM$contMode) {
    nextbuf = HamamatsuM$PARMultiple$dataReady(SUCCESS, buf, length);
    }
  else {
#line 165
    if ((nextbuf = HamamatsuM$PARMultiple$dataReady(SUCCESS, buf, length))) {
      HamamatsuM$MSP430ADC12MultiplePAR$getData(nextbuf, length, 0);
      }
    else {
#line 168
      HamamatsuM$contMode = FALSE;
      }
    }
#line 169
  return nextbuf;
}

#line 266
static   uint16_t *HamamatsuM$MSP430ADC12MultipleTSR$dataReady(uint16_t *buf, uint16_t length)
{
  uint16_t *nextbuf;

#line 269
  if (!HamamatsuM$contMode) {
    nextbuf = HamamatsuM$TSRMultiple$dataReady(SUCCESS, buf, length);
    }
  else {
#line 272
    if ((nextbuf = HamamatsuM$TSRMultiple$dataReady(SUCCESS, buf, length))) {
      HamamatsuM$MSP430ADC12MultipleTSR$getData(nextbuf, length, 0);
      }
    else {
#line 275
      HamamatsuM$contMode = FALSE;
      }
    }
#line 276
  return nextbuf;
}

