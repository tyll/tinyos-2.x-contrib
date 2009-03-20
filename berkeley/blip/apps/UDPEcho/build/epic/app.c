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
# 235 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source);




static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value);





static __inline uint8_t __nesc_ntoh_leuint8(const void *source);




static __inline uint8_t __nesc_hton_leuint8(void *target, uint8_t value);





static __inline int8_t __nesc_ntoh_int8(const void *source);
#line 257
static __inline int8_t __nesc_hton_int8(void *target, int8_t value);






static __inline uint16_t __nesc_ntoh_uint16(const void *source);




static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value);






static __inline uint16_t __nesc_ntoh_leuint16(const void *source);




static __inline uint16_t __nesc_hton_leuint16(void *target, uint16_t value);
#line 294
static __inline uint32_t __nesc_ntoh_uint32(const void *source);






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
# 39 "/opt/msp430/msp430/include/string.h"
extern int memcmp(const void *, const void *, size_t );


extern void *memset(void *, int , size_t );



extern char *strcpy(char *, const char *);

extern size_t strlen(const char *);



extern char *strncpy(char *, const char *, size_t );










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
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/lib/safe/include/annots_stage1.h"
struct __nesc_attr_safe {
};
#line 41
struct __nesc_attr_unsafe {
};
# 23 "/home/sdawson/cvs/tinyos-2.x/tos/system/tos.h"
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
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/types/TinyError.h"
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
# 85 "/opt/msp430/msp430/include/msp430/usart.h"
volatile unsigned char U0CTL __asm ("0x0070");

volatile unsigned char U0TCTL __asm ("0x0071");



volatile unsigned char U0MCTL __asm ("0x0073");

volatile unsigned char U0BR0 __asm ("0x0074");

volatile unsigned char U0BR1 __asm ("0x0075");

volatile unsigned char U0RXBUF __asm ("0x0076");
#line 256
volatile unsigned char U1TCTL __asm ("0x0079");
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
# 158 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
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
typedef struct { char data[4]; } __attribute__((packed)) nx_float;typedef float __nesc_nxbase_nx_float  ;
# 52 "/opt/msp430/msp430/include/stdint.h" 3
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
#line 88
__extension__ 
#line 88
typedef long long int intmax_t;
__extension__ 
#line 89
typedef unsigned long long int uintmax_t;
# 38 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/6lowpan.h"
typedef uint8_t ip6_addr_t[16];
typedef uint16_t cmpr_ip6_addr_t;
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/IEEE802154.h"
typedef uint16_t ieee154_panid_t;
typedef uint16_t ieee154_saddr_t;

enum __nesc_unnamed4258 {
  IEEE154_BROADCAST_ADDR = 0xffff
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
# 54 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/6lowpan.h"
extern uint8_t globalPrefix;
extern uint8_t multicast_prefix[8];
extern uint8_t linklocal_prefix[8];

uint8_t cmpPfx(ip6_addr_t a, uint8_t *pfx);

void ip_memclr(uint8_t *buf, uint16_t len);
void *ip_memcpy(void *dst0, const void *src0, uint16_t len);
#line 78
#line 71
typedef struct packed_lowmsg {
  uint8_t headers;
  uint8_t len;

  ieee154_saddr_t src;
  ieee154_saddr_t dst;
  uint8_t *data;
} packed_lowmsg_t;





enum __nesc_unnamed4259 {
  LOWMSG_MESH_HDR = 1 << 0, 
  LOWMSG_BCAST_HDR = 1 << 1, 
  LOWMSG_FRAG1_HDR = 1 << 2, 
  LOWMSG_FRAGN_HDR = 1 << 3, 
  LOWMSG_NALP = 1 << 4, 
  LOWMSG_IPNH_HDR = 1 << 5
};




enum __nesc_unnamed4260 {
  LOWMSG_MESH_LEN = 5, 
  LOWMSG_BCAST_LEN = 2, 
  LOWMSG_FRAG1_LEN = 4, 
  LOWMSG_FRAGN_LEN = 5
};

enum __nesc_unnamed4261 {
  LOWPAN_LINK_MTU = 110, 
  INET_MTU = 1280, 
  LIB6LOWPAN_MAX_LEN = LOWPAN_LINK_MTU
};




enum __nesc_unnamed4262 {
  LOWPAN_NALP_PATTERN = 0x0, 
  LOWPAN_MESH_PATTERN = 0x2, 
  LOWPAN_FRAG1_PATTERN = 0x18, 
  LOWPAN_FRAGN_PATTERN = 0x1c, 
  LOWPAN_BCAST_PATTERN = 0x50, 
  LOWPAN_HC1_PATTERN = 0x42, 
  LOWPAN_HC_LOCAL_PATTERN = 0x3, 
  LOWPAN_HC_CRP_PATTERN = 0x4
};

enum __nesc_unnamed4263 {
  LOWPAN_MESH_V_MASK = 0x20, 
  LOWPAN_MESH_F_MASK = 0x10, 
  LOWPAN_MESH_HOPS_MASK = 0x0f
};




enum __nesc_unnamed4264 {
  IANA_ICMP = 58, 
  IANA_UDP = 17, 
  IANA_TCP = 6, 

  NXTHDR_SOURCE = 0, 
  NXTHDR_INSTALL = 253, 
  NXTHDR_TOPO = 252, 
  NXTHDR_UNKNOWN = 0xff
};






enum __nesc_unnamed4265 {
  LOWPAN_IPHC_VTF_MASK = 0x80, 
  LOWPAN_IPHC_VTF_INLINE = 0, 
  LOWPAN_IPHC_NH_MASK = 0x40, 
  LOWPAN_IPHC_NH_INLINE = 0, 
  LOWPAN_IPHC_HLIM_MASK = 0x20, 
  LOWPAN_IPHC_HLIM_INLINE = 0, 

  LOWPAN_IPHC_SC_OFFSET = 3, 
  LOWPAN_IPHC_DST_OFFSET = 1, 
  LOWPAN_IPHC_ADDRFLAGS_MASK = 0x3, 

  LOWPAN_IPHC_ADDR_128 = 0x0, 
  LOWPAN_IPHC_ADDR_64 = 0x1, 
  LOWPAN_IPHC_ADDR_16 = 0x2, 
  LOWPAN_IPHC_ADDR_0 = 0x3, 

  LOWPAN_IPHC_SHORT_MASK = 0x80, 
  LOWPAN_IPHC_SHORT_LONG_MASK = 0xe0, 

  LOWPAN_IPHC_HC1_MCAST = 0x80, 
  LOWPAN_IPHC_HC_MCAST = 0xa0, 

  LOWPAN_HC_MCAST_SCOPE_MASK = 0x1e, 
  LOWPAN_HC_MCAST_SCOPE_OFFSET = 1, 

  LOWPAN_UDP_PORT_BASE_MASK = 0xfff0, 
  LOWPAN_UDP_PORT_BASE = 0xf0b0, 
  LOWPAN_UDP_DISPATCH = 0x80, 

  LOWPAN_UDP_S_MASK = 0x40, 
  LOWPAN_UDP_D_MASK = 0x20, 
  LOWPAN_UDP_C_MASK = 0x10
};





enum __nesc_unnamed4266 {
  IP_EXT_SOURCE_DISPATCH = 0x40, 
  IP_EXT_SOURCE_MASK = 0xc0, 


  IP_EXT_SOURCE_RECORD = 0x01, 
  IP_EXT_SOURCE_RECORD_MASK = 0x01, 
  IP_EXT_SOURCE_INVAL = 0x02, 
  IP_EXT_SOURCE_INVAL_MASK = 0x02, 
  IP_EXT_SOURCE_CONTROLLER = 0x04, 




  IP_EXT_SOURCE_INSTALL = 0x10, 
  IP_EXT_SOURCE_INSTALL_MASK = 0x10, 





  IP_EXT_SOURCE_INST_SRC = 0x20, 
  IP_EXT_SOURCE_INST_DST = 0x40
};



struct source_header {
  uint8_t nxt_hdr;
  uint8_t len;

  uint8_t dispatch;
  uint8_t current;
  uint16_t hops[0];
};



struct topology_entry {
  uint8_t etx;
  uint8_t conf;
  ieee154_saddr_t hwaddr;
};
struct topology_header {
  uint8_t nxt_hdr;
  uint8_t len;
  struct topology_entry topo[0];
};

enum __nesc_unnamed4267 {
  IP_NUMBER_FRAGMENTS = 12
};
# 4 "TestDriver.h"
enum __nesc_unnamed4268 {
  AM_TESTDRIVER_MSG = 1
};

enum __nesc_unnamed4269 {
  TEST_PING = 1, 
  TEST_CLEAR = 2, 
  TEST_OFF = 3, 
  TEST_ON = 4
};

nx_struct testdriver_msg {
  nx_uint8_t cmd;
  nx_uint8_t addr[16];
  nx_uint16_t n;
  nx_uint16_t dt;
} __attribute__((packed));
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.h"
enum __nesc_unnamed4270 {
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
typedef struct __nesc_unnamed4271 {

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
typedef struct __nesc_unnamed4272 {

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
typedef struct __nesc_unnamed4273 {

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
# 32 "/home/sdawson/cvs/tinyos-2.x/tos/types/Leds.h"
enum __nesc_unnamed4274 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
# 39 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420.h"
typedef uint8_t cc2420_status_t;
#line 98
#line 84
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








#line 100
typedef struct __nesc_unnamed4275 {


  nxle_uint8_t network;


  nxle_uint8_t type;
} am_header_t;






#line 113
typedef nx_struct cc2420_footer_t {
} __attribute__((packed)) cc2420_footer_t;
#line 139
#line 123
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





#line 142
typedef nx_struct cc2420_packet_t {
  cc2420_header_t packet;
  nx_uint8_t data[];
} __attribute__((packed)) cc2420_packet_t;
#line 176
enum __nesc_unnamed4276 {

  MAC_HEADER_SIZE = sizeof(cc2420_header_t ) - 1, 

  MAC_FOOTER_SIZE = sizeof(uint16_t ), 

  MAC_PACKET_SIZE = MAC_HEADER_SIZE + 102 + MAC_FOOTER_SIZE, 

  CC2420_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE, 

  IEEE802154_SIZ = CC2420_SIZE - sizeof(am_header_t )
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

enum __nesc_unnamed4277 {

  CC2420_INVALID_TIMESTAMP = 0x80000000L
};
# 6 "/home/sdawson/cvs/tinyos-2.x/tos/types/AM.h"
typedef nx_uint8_t nx_am_id_t;
typedef nx_uint8_t nx_am_group_t;
typedef nx_uint16_t nx_am_addr_t;

typedef uint8_t am_id_t;
typedef uint8_t am_group_t;
typedef uint16_t am_addr_t;

enum __nesc_unnamed4278 {
  AM_BROADCAST_ADDR = 0xffff
};









enum __nesc_unnamed4279 {
  TOS_AM_GROUP = 0x22, 
  TOS_AM_ADDRESS = 1
};
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/serial/Serial.h"
typedef uint8_t uart_id_t;



enum __nesc_unnamed4280 {
  HDLC_FLAG_BYTE = 0x7e, 
  HDLC_CTLESC_BYTE = 0x7d
};



enum __nesc_unnamed4281 {
  TOS_SERIAL_ACTIVE_MESSAGE_ID = 0, 
  TOS_SERIAL_CC1000_ID = 1, 
  TOS_SERIAL_802_15_4_ID = 2, 
  TOS_SERIAL_UNKNOWN_ID = 255
};


enum __nesc_unnamed4282 {
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
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/platforms/epic/platform_message.h"
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
# 19 "/home/sdawson/cvs/tinyos-2.x/tos/types/message.h"
#line 14
typedef nx_struct message_t {
  nx_uint8_t header[sizeof(message_header_t )];
  nx_uint8_t data[102];
  nx_uint8_t footer[sizeof(message_footer_t )];
  nx_uint8_t metadata[sizeof(message_metadata_t )];
} __attribute__((packed)) message_t;
# 37 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/ip.h"
enum __nesc_unnamed4283 {




  FRAG_EXPIRE_TIME = 4096
};





struct in6_addr {

  union __nesc_unnamed4284 {

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
  uint8_t vlfc[4];
  uint16_t plen;
  uint8_t nxt_hdr;
  uint8_t hlim;
  struct in6_addr ip6_src;
  struct in6_addr ip6_dst;
} __attribute((packed)) ;









struct ip6_ext {
  uint8_t nxt_hdr;
  uint8_t len;
  uint8_t data[0];
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




struct ip_metadata {
  ieee154_saddr_t sender;
  uint8_t lqi;
  uint8_t padding[1];
};

struct flow_match {
  cmpr_ip6_addr_t src;
  cmpr_ip6_addr_t dest;
  cmpr_ip6_addr_t prev_hop;
};

struct rinstall_header {
  struct ip6_ext ext;
  uint16_t flags;
  struct flow_match match;
  uint8_t path_len;
  uint8_t current;
  cmpr_ip6_addr_t path[0];
};

enum __nesc_unnamed4287 {
  R_SRC_FULL_PATH_INSTALL_MASK = 0x01, 
  R_DEST_FULL_PATH_INSTALL_MASK = 0x02, 
  R_HOP_BY_HOP_PATH_INSTALL_MASK = 0x04, 
  R_REVERSE_PATH_INSTALL_MASK = 0x08, 
  R_SRC_FULL_PATH_UNINSTALL_MASK = 0x10, 
  R_DEST_FULL_PATH_UNINSTALL_MASK = 0x20, 
  R_HOP_BY_HOP_PATH_UNINSTALL_MASK = 0x40, 
  R_REVERSE_PATH_UNINSTALL_MASK = 0x80
};










enum __nesc_unnamed4288 {
  T_INVAL_NEIGH = 0xef, 
  T_SET_NEIGH = 0xee
};

struct flow_id {
  uint16_t src;
  uint16_t dst;
  uint16_t id;
  uint16_t seq;
  uint16_t nxt_hdr;
};
#line 230
struct generic_header {



  uint8_t len;
  union __nesc_unnamed4289 {

    struct ip6_ext *ext;
    struct source_header *sh;
    struct udp_hdr *udp;
    struct tcp_hdr *tcp;
    struct rinstall_header *rih;
    struct topology_header *th;
    uint8_t *data;
  } hdr;
  struct generic_header *next;
};

struct split_ip_msg {
  struct generic_header *headers;
  uint16_t data_len;
  uint8_t *data;








  struct ip6_hdr hdr;
  uint8_t next[0];
};





void inet_pton6(char *addr, struct in6_addr *dest);
int inet_ntop6(struct in6_addr *addr, char *buf, int cnt);
# 92 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/lib6lowpan.h"
uint16_t getHeaderBitmap(packed_lowmsg_t *lowmsg);





uint8_t *getLowpanPayload(packed_lowmsg_t *lowmsg);
#line 113
__inline uint8_t hasFrag1Header(packed_lowmsg_t *msg);
__inline uint8_t hasFragNHeader(packed_lowmsg_t *msg);
#line 139
__inline uint8_t getFragDgramSize(packed_lowmsg_t *msg, uint16_t *size);
__inline uint8_t getFragDgramTag(packed_lowmsg_t *msg, uint16_t *tag);
__inline uint8_t getFragDgramOffset(packed_lowmsg_t *msg, uint8_t *size);


__inline uint8_t setFragDgramTag(packed_lowmsg_t *msg, uint16_t tag);
#line 190
#line 172
typedef struct __nesc_unnamed4290 {

  uint8_t nxt_hdr;

  uint8_t *payload_start;

  uint8_t *header_end;

  uint8_t payload_offset;

  uint8_t *hlim;



  uint8_t *transport_ptr;

  struct source_header *sh;
  struct rinstall_header *rih;
} unpack_info_t;

uint8_t *unpackHeaders(packed_lowmsg_t *pkt, unpack_info_t *u_info, 
uint8_t *dest, uint16_t len);





extern uint16_t lib6lowpan_frag_tag;
#line 211
#line 201
typedef struct __nesc_unnamed4291 {
  uint16_t tag;
  uint16_t size;
  void *buf;
  uint16_t bytes_rcvd;

  uint8_t timeout;
  uint8_t nxt_hdr;
  uint8_t *transport_hdr;
  struct ip_metadata metadata;
} reconstruct_t;




#line 213
typedef struct __nesc_unnamed4292 {
  uint16_t tag;
  uint16_t offset;
} fragment_t;
#line 229
uint8_t getNextFrag(struct split_ip_msg *msg, fragment_t *progress, 
uint8_t *buf, uint16_t len);


enum __nesc_unnamed4293 {
  T_FAILED1 = 0, 
  T_FAILED2 = 1, 
  T_UNUSED = 2, 
  T_ACTIVE = 3, 
  T_ZOMBIE = 4
};
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatch.h"
enum __nesc_unnamed4294 {
  N_PARENTS = 3, 
  N_EPOCHS = 2, 
  N_EPOCHS_COUNTED = 1, 
  N_RECONSTRUCTIONS = 2, 
  N_FORWARD_ENT = IP_NUMBER_FRAGMENTS
};

enum __nesc_unnamed4295 {
  CONF_EVICT_THRESHOLD = 5, 
  CONF_PROM_THRESHOLD = 5, 
  MAX_CONSEC_FAILURES = 40, 
  PATH_COST_DIFF_THRESH = 10, 
  LQI_DIFF_THRESH = 10, 
  LINK_EVICT_THRESH = 50, 
  LQI_ADMIT_THRESH = 0x200, 
  RSSI_ADMIT_THRESH = 0, 
  RANDOM_ROUTE = 20
};

enum __nesc_unnamed4296 {
  WITHIN_THRESH = 1, 
  ABOVE_THRESH = 2, 
  BELOW_THRESH = 3
};

enum __nesc_unnamed4297 {
  TGEN_BASE_TIME = 512, 
  TGEN_MAX_INTERVAL = 60L * 1024L * 5L
};

struct epoch_stats {
  uint16_t success;
  uint16_t total;
  uint16_t receptions;
};

struct report_stats {
  uint8_t messages;
  uint8_t transmissions;
  uint8_t successes;
};

enum __nesc_unnamed4298 {
  T_PIN_OFFSET = 0, 
  T_PIN_MASK = 1 << T_PIN_OFFSET, 
  T_VALID_OFFSET = 2, 
  T_VALID_MASK = 1 << T_VALID_OFFSET, 
  T_MARKED_OFFSET = 3, 
  T_MARKED_MASK = 1 << T_MARKED_OFFSET, 
  T_MATURE_OFFSET = 4, 
  T_MATURE_MASK = 1 << T_MATURE_OFFSET, 
  T_EVICT_OFFSET = 5, 
  T_EVICT_MASK = 1 << T_EVICT_OFFSET
};

enum __nesc_unnamed4299 {



  N_NEIGH = 8, 
  N_LOW_NEIGH = 2, 
  N_FREE_NEIGH = N_NEIGH - N_LOW_NEIGH, 
  N_FLOW_ENT = 6, 
  N_FLOW_CHOICES = 2, 
  N_PARENT_CHOICES = 3, 
  T_DEF_PARENT = 0xfffd, 
  T_DEF_PARENT_SLOT = 0
};










#line 98
typedef struct __nesc_unnamed4300 {


  ieee154_saddr_t dest[N_FLOW_CHOICES + N_PARENT_CHOICES + 2];
  uint8_t current : 4;
  uint8_t nchoices : 4;
  uint8_t retries;
  uint8_t actRetries;
  uint8_t delay;
} send_policy_t;






#line 109
typedef struct __nesc_unnamed4301 {
  send_policy_t policy;
  uint8_t frags_sent;
  bool failed;
  uint8_t refcount;
} send_info_t;




#line 116
typedef struct __nesc_unnamed4302 {
  send_info_t *info;
  message_t *msg;
} send_entry_t;







#line 121
typedef struct __nesc_unnamed4303 {
  uint8_t timeout;
  ieee154_saddr_t l2_src;
  uint16_t old_tag;
  uint16_t new_tag;
  send_info_t *s_info;
} forward_entry_t;
#line 145
enum __nesc_unnamed4304 {
  F_VALID_MASK = 0x01, 

  F_FULL_PATH_OFFSET = 1, 
  F_FULL_PATH_MASK = 0x02, 

  MAX_PATH_LENGTH = 10, 
  N_FULL_PATH_ENTRIES = N_FLOW_CHOICES * N_FLOW_ENT
};

struct flow_path {
  uint8_t path_len;
  cmpr_ip6_addr_t path[MAX_PATH_LENGTH];
};

struct f_entry {
  uint8_t flags;
  union  {
    struct flow_path *pathE;
    cmpr_ip6_addr_t nextHop;
  } ;
};




struct flow_entry {
  uint8_t flags;
  uint8_t count;
  struct flow_match match;
  struct f_entry entries[N_FLOW_CHOICES];
};
#line 193
struct neigh_entry {
  uint8_t flags;
  uint8_t hops;
  ieee154_saddr_t neighbor;
  uint16_t costEstimate;
  uint16_t linkEstimate;
  struct epoch_stats stats[N_EPOCHS];
};
#line 227
#line 224
typedef enum __nesc_unnamed4305 {
  S_FORWARD, 
  S_REQ
} send_type_t;
#line 246
#line 230
typedef nx_struct __nesc_unnamed4306 {
  nx_uint16_t sent;
  nx_uint16_t forwarded;
  nx_uint8_t rx_drop;
  nx_uint8_t tx_drop;
  nx_uint8_t fw_drop;
  nx_uint8_t rx_total;
  nx_uint8_t real_drop;
  nx_uint8_t hlim_drop;
  nx_uint8_t senddone_el;
  nx_uint8_t fragpool;
  nx_uint8_t sendinfo;
  nx_uint8_t sendentry;
  nx_uint8_t sndqueue;
  nx_uint8_t encfail;
  nx_uint16_t heapfree;
} __attribute__((packed)) ip_statistics_t;







#line 249
typedef nx_struct __nesc_unnamed4307 {
  nx_uint8_t hop_limit;
  nx_uint16_t parent;
  nx_uint16_t parent_metric;
  nx_uint16_t parent_etx;
} __attribute__((packed)) route_statistics_t;








#line 256
typedef nx_struct __nesc_unnamed4308 {





  nx_uint16_t rx;
} __attribute__((packed)) icmp_statistics_t;






#line 265
typedef nx_struct __nesc_unnamed4309 {
  nx_uint16_t total;
  nx_uint16_t failed;
  nx_uint16_t seqno;
  nx_uint16_t sender;
} __attribute__((packed)) udp_statistics_t;
# 27 "UDPReport.h"
nx_struct udp_report {

  udp_statistics_t udp;
  icmp_statistics_t icmp;
  route_statistics_t route;
} __attribute__((packed));
# 43 "/opt/msp430/lib/gcc-lib/msp430/3.2.3/include/stdarg.h"
typedef __builtin_va_list __gnuc_va_list;
# 110 "/opt/msp430/lib/gcc-lib/msp430/3.2.3/include/stdarg.h" 3
typedef __gnuc_va_list va_list;
# 50 "/opt/msp430/msp430/include/stdio.h"
int __attribute((format(printf, 3, 4))) snprintf(char *buf, size_t size, const char *fmt, ...);
# 118 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/PrintfUART.h"
static inline void printfUART_init(void);
# 29 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4310 {
#line 29
  int notUsed;
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4311 {
#line 30
  int notUsed;
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4312 {
#line 31
  int notUsed;
} 
#line 31
TMicro;
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/CC2420TimeSyncMessage.h"
typedef nx_uint32_t timesync_radio_t;
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/msp430usart.h"
#line 48
typedef enum __nesc_unnamed4313 {

  USART_NONE = 0, 
  USART_UART = 1, 
  USART_UART_TX = 2, 
  USART_UART_RX = 3, 
  USART_SPI = 4, 
  USART_I2C = 5
} msp430_usartmode_t;










#line 58
typedef struct __nesc_unnamed4314 {
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
typedef struct __nesc_unnamed4315 {
  unsigned int txept : 1;
  unsigned int stc : 1;
  unsigned int txwake : 1;
  unsigned int urxse : 1;
  unsigned int ssel : 2;
  unsigned int ckpl : 1;
  unsigned int ckph : 1;
} __attribute((packed))  msp430_utctl_t;










#line 79
typedef struct __nesc_unnamed4316 {
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
typedef struct __nesc_unnamed4317 {
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
typedef struct __nesc_unnamed4318 {
  uint16_t ubr;
  uint8_t uctl;
  uint8_t utctl;
} msp430_spi_registers_t;




#line 124
typedef union __nesc_unnamed4319 {
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
typedef enum __nesc_unnamed4320 {

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
typedef struct __nesc_unnamed4321 {
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
typedef struct __nesc_unnamed4322 {
  uint16_t ubr;
  uint8_t umctl;
  uint8_t uctl;
  uint8_t utctl;
  uint8_t urctl;
  uint8_t ume;
} msp430_uart_registers_t;




#line 211
typedef union __nesc_unnamed4323 {
  msp430_uart_config_t uartConfig;
  msp430_uart_registers_t uartRegisters;
} msp430_uart_union_config_t;
#line 248
#line 240
typedef struct __nesc_unnamed4324 {
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
typedef struct __nesc_unnamed4325 {
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
typedef struct __nesc_unnamed4326 {
  uint8_t uctl;
  uint8_t i2ctctl;
  uint8_t i2cpsc;
  uint8_t i2csclh;
  uint8_t i2cscll;
  uint16_t i2coa;
} msp430_i2c_registers_t;




#line 287
typedef union __nesc_unnamed4327 {
  msp430_i2c_config_t i2cConfig;
  msp430_i2c_registers_t i2cRegisters;
} msp430_i2c_union_config_t;
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/types/Resource.h"
typedef uint8_t resource_client_id_t;
# 37 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/in_cksum.h"
#line 34
typedef struct __nesc_unnamed4328 {
  const uint8_t *ptr;
  int len;
} vec_t;

extern int in_cksum(const vec_t *vec, int veclen);



extern uint16_t msg_cksum(struct split_ip_msg *msg, uint8_t nxt_hdr);
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/support/sdk/c/blip/include/ip_malloc.h"
typedef uint16_t bndrt_t;

void ip_malloc_init(void);
void *ip_malloc(uint16_t sz);
void ip_free(void *ptr);
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/table.h"
#line 6
typedef struct __nesc_unnamed4329 {
  void *data;
  uint16_t elt_len;
  uint16_t n_elts;
} table_t;
# 26 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
extern struct in6_addr __my_address;
extern uint8_t globalPrefix;
# 25 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMP.h"
enum __nesc_unnamed4330 {
  ICMP_EXT_TYPE_PREFIX = 3, 
  ICMP_EXT_TYPE_BEACON = 17
};

enum __nesc_unnamed4331 {

  TRICKLE_JITTER = 10240, 

  TRICKLE_PERIOD = 4096, 


  TRICKLE_MAX = TRICKLE_PERIOD << 5
};








#line 41
typedef nx_struct icmp6_echo_hdr {
  nx_uint8_t type;
  nx_uint8_t code;
  nx_uint16_t cksum;
  nx_uint16_t ident;
  nx_uint16_t seqno;
} __attribute__((packed)) icmp_echo_hdr_t;
#line 59
#line 49
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






#line 61
typedef nx_struct rsol {
  nx_uint8_t type;
  nx_uint8_t code;
  nx_uint16_t cksum;
  nx_uint32_t reserved;
} __attribute__((packed)) rsol_t;










#line 68
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






#line 79
typedef nx_struct __nesc_unnamed4332 {
  nx_uint8_t type;
  nx_uint8_t length;
  nx_uint16_t metric;
  nx_uint8_t pad[4];
} __attribute__((packed)) rqual_t;

struct icmp_stats {
  uint16_t seq;
  uint8_t ttl;
  uint32_t rtt;
};
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
extern uint8_t multicast_prefix[8];
# 4 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/Shell.h"
enum __nesc_unnamed4333 {
  MAX_REPLY_LEN = 128
};
typedef TMilli UDPEchoP$StatusTimer$precision_tag;
typedef ip_statistics_t UDPEchoP$IPStats$stat_str;
typedef route_statistics_t UDPEchoP$RouteStats$stat_str;
typedef icmp_statistics_t UDPEchoP$ICMPStats$stat_str;
enum /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Timer*/Msp430Timer32khzC$0$__nesc_unnamed4334 {
  Msp430Timer32khzC$0$ALARM_ID = 0U
};
typedef T32khz /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$frequency_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$frequency_tag /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$precision_tag;
typedef uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$size_type;
typedef T32khz /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag;
typedef /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$frequency_tag /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$precision_tag;
typedef uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$size_type;
typedef TMilli /*CounterMilli32C.Transform*/TransformCounterC$0$to_precision_tag;
typedef uint32_t /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type;
typedef T32khz /*CounterMilli32C.Transform*/TransformCounterC$0$from_precision_tag;
typedef uint16_t /*CounterMilli32C.Transform*/TransformCounterC$0$from_size_type;
typedef uint32_t /*CounterMilli32C.Transform*/TransformCounterC$0$upper_count_type;
typedef /*CounterMilli32C.Transform*/TransformCounterC$0$from_precision_tag /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$precision_tag;
typedef /*CounterMilli32C.Transform*/TransformCounterC$0$from_size_type /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$size_type;
typedef /*CounterMilli32C.Transform*/TransformCounterC$0$to_precision_tag /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$precision_tag;
typedef /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$size_type;
typedef TMilli /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_precision_tag;
typedef uint32_t /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type;
typedef T32khz /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_precision_tag;
typedef uint16_t /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$size_type;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_precision_tag /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$precision_tag;
typedef /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$size_type;
typedef TMilli /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$precision_tag;
typedef /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$precision_tag /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$precision_tag;
typedef uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type;
typedef /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$precision_tag /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$precision_tag;
typedef TMilli /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$precision_tag;
typedef /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$precision_tag /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$precision_tag;
typedef /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$precision_tag /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$precision_tag;
typedef TMilli /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$precision_tag;
typedef /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$precision_tag /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$LocalTime$precision_tag;
typedef /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$precision_tag /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$precision_tag;
typedef uint32_t /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$size_type;
typedef T32khz CC2420PacketP$PacketTimeStamp32khz$precision_tag;
typedef uint32_t CC2420PacketP$PacketTimeStamp32khz$size_type;
typedef T32khz CC2420PacketP$LocalTime32khz$precision_tag;
typedef TMilli CC2420PacketP$LocalTimeMilli$precision_tag;
typedef TMilli CC2420PacketP$PacketTimeStampMilli$precision_tag;
typedef uint32_t CC2420PacketP$PacketTimeStampMilli$size_type;
typedef T32khz /*Counter32khz32C.Transform*/TransformCounterC$1$to_precision_tag;
typedef uint32_t /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type;
typedef T32khz /*Counter32khz32C.Transform*/TransformCounterC$1$from_precision_tag;
typedef uint16_t /*Counter32khz32C.Transform*/TransformCounterC$1$from_size_type;
typedef uint16_t /*Counter32khz32C.Transform*/TransformCounterC$1$upper_count_type;
typedef /*Counter32khz32C.Transform*/TransformCounterC$1$from_precision_tag /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$precision_tag;
typedef /*Counter32khz32C.Transform*/TransformCounterC$1$from_size_type /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$size_type;
typedef /*Counter32khz32C.Transform*/TransformCounterC$1$to_precision_tag /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$precision_tag;
typedef /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$size_type;
typedef T32khz /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$precision_tag;
typedef /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$precision_tag /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$LocalTime$precision_tag;
typedef /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$precision_tag /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$precision_tag;
typedef uint32_t /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$size_type;
typedef T32khz CC2420ControlP$StartupTimer$precision_tag;
typedef uint32_t CC2420ControlP$StartupTimer$size_type;
typedef uint16_t CC2420ControlP$ReadRssi$val_t;
enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Timer*/Msp430Timer32khzC$1$__nesc_unnamed4335 {
  Msp430Timer32khzC$1$ALARM_ID = 1U
};
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$frequency_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$frequency_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$precision_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$size_type;
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_precision_tag;
typedef uint32_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type;
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_precision_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$size_type;
enum /*CC2420ControlC.Spi*/CC2420SpiC$0$__nesc_unnamed4336 {
  CC2420SpiC$0$CLIENT_ID = 0U
};
enum /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$__nesc_unnamed4337 {
  Msp430Spi0C$0$CLIENT_ID = 0U
};
enum /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$__nesc_unnamed4338 {
  Msp430Usart0C$0$CLIENT_ID = 0U
};
enum /*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$__nesc_unnamed4339 {
  CC2420SpiC$1$CLIENT_ID = 1U
};
enum /*CC2420ControlC.RssiResource*/CC2420SpiC$2$__nesc_unnamed4340 {
  CC2420SpiC$2$CLIENT_ID = 2U
};
typedef uint16_t RandomMlcgC$SeedInit$parameter;
typedef TMilli PacketLinkP$DelayTimer$precision_tag;
typedef T32khz CC2420TransmitP$PacketTimeStamp$precision_tag;
typedef uint32_t CC2420TransmitP$PacketTimeStamp$size_type;
typedef T32khz CC2420TransmitP$BackoffTimer$precision_tag;
typedef uint32_t CC2420TransmitP$BackoffTimer$size_type;
enum /*CC2420TransmitC.Spi*/CC2420SpiC$3$__nesc_unnamed4341 {
  CC2420SpiC$3$CLIENT_ID = 3U
};
typedef T32khz CC2420ReceiveP$PacketTimeStamp$precision_tag;
typedef uint32_t CC2420ReceiveP$PacketTimeStamp$size_type;
enum /*CC2420ReceiveC.Spi*/CC2420SpiC$4$__nesc_unnamed4342 {
  CC2420SpiC$4$CLIENT_ID = 4U
};
typedef send_info_t IPDispatchP$SendInfoPool$t;
typedef send_entry_t *IPDispatchP$SendQueue$t;
typedef TMilli IPDispatchP$ExpireTimer$precision_tag;
typedef message_t IPDispatchP$FragPool$t;
typedef ip_statistics_t IPDispatchP$Statistics$stat_str;
typedef send_entry_t IPDispatchP$SendEntryPool$t;
typedef TMilli IPRoutingP$SortTimer$precision_tag;
typedef route_statistics_t IPRoutingP$Statistics$stat_str;
typedef TMilli IPRoutingP$TrafficGenTimer$precision_tag;
typedef message_t /*IPDispatchC.FragPool*/PoolC$0$pool_t;
typedef /*IPDispatchC.FragPool*/PoolC$0$pool_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t;
typedef /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$t;
typedef send_entry_t /*IPDispatchC.SendEntryPool*/PoolC$1$pool_t;
typedef /*IPDispatchC.SendEntryPool*/PoolC$1$pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t;
typedef /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$t;
typedef send_entry_t */*IPDispatchC.QueueC*/QueueC$0$queue_t;
typedef /*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$Queue$t;
typedef send_info_t /*IPDispatchC.SendInfoPool*/PoolC$2$pool_t;
typedef /*IPDispatchC.SendInfoPool*/PoolC$2$pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t;
typedef /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$t;
typedef TMilli ICMPResponderP$PingTimer$precision_tag;
typedef TMilli ICMPResponderP$LocalTime$precision_tag;
typedef TMilli ICMPResponderP$Advertisement$precision_tag;
typedef icmp_statistics_t ICMPResponderP$Statistics$stat_str;
typedef TMilli ICMPResponderP$Solicitation$precision_tag;
typedef TMilli UDPShellP$Uptime$precision_tag;
typedef uint32_t UDPShellP$Uptime$size_type;
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$Init$init(void);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
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
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t Msp430ClockP$Init$init(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x2ab4c4302b20);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);
#line 28
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x2ab4c4302b20);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get(void);
static   bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$isOverflowPending(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void);
#line 46
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$enableEvents(void);
#line 36
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$setControlAsCompare(void);










static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$disableEvents(void);
#line 33
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$clearPendingInterrupt(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void);
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEvent(uint16_t arg_0x2ab4c42b7c70);

static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void);
#line 57
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$clearOverflow(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$setControlAsCapture(uint8_t arg_0x2ab4c42a8600);
#line 31
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void);
#line 46
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$enableEvents(void);
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$disableEvents(void);
#line 33
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$clearPendingInterrupt(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void);
#line 46
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$enableEvents(void);
#line 36
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$setControlAsCompare(void);










static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$disableEvents(void);
#line 33
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$clearPendingInterrupt(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void);
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEvent(uint16_t arg_0x2ab4c42b7c70);

static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void);
#line 75
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t arg_0x2ab4c42c3690);
# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t MotePlatformC$Init$init(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x2ab4c41a08c0);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$default$runTask(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x2ab4c41a08c0);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void SchedulerBasicP$Scheduler$init(void);
#line 61
static  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 54
static  bool SchedulerBasicP$Scheduler$runNextTask(void);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void McuSleepC$McuSleep$sleep(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t LedsP$Init$init(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$get(void);
#line 52
static   uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$getRaw(void);






static   bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$get(void);
#line 52
static   uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$getRaw(void);
#line 64
static   void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$makeInput(void);
#line 59
static   bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$get(void);
#line 52
static   uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$getRaw(void);
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
#line 71
static   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$set(void);
#line 64
static   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$makeInput(void);
#line 59
static   bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$get(void);
#line 85
static   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectIOFunc(void);
#line 52
static   uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$getRaw(void);
#line 78
static   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectModuleFunc(void);
#line 71
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$set(void);




static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$clr(void);
#line 71
static   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$set(void);
#line 71
static   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$set(void);




static   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$clr(void);
#line 71
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$set(void);




static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$clr(void);
#line 71
static   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$makeOutput(void);
#line 34
static   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$set(void);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
#line 29
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void UDPEchoP$StatusTimer$fired(void);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static  void UDPEchoP$Boot$booted(void);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  void UDPEchoP$Status$recvfrom(struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, 
uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void UDPEchoP$RadioControl$startDone(error_t arg_0x2ab4c47363a0);
#line 117
static  void UDPEchoP$RadioControl$stopDone(error_t arg_0x2ab4c47355c0);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  void UDPEchoP$Echo$recvfrom(struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, 
uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$overflow(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$startAt(/*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$size_type arg_0x2ab4c47bd0c8);
#line 62
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$stop(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Init$init(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$size_type /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$get(void);






static   bool /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$isOverflowPending(void);










static   void /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$overflow(void);
#line 53
static   /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$size_type /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get(void);
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getNow(void);
#line 92
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$size_type arg_0x2ab4c47bd0c8);
#line 105
static   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getAlarm(void);
#line 62
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$stop(void);




static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$fired(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$overflow(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired(void);
# 125 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow(void);
#line 118
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t arg_0x2ab4c4747020, uint32_t arg_0x2ab4c47472e0);
#line 67
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void);
#line 72
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38);
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38, 
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t arg_0x2ab4c474c770);








static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38, 
# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t arg_0x2ab4c474b108);




static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/LocalTime.nc"
static   uint32_t /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$LocalTime$get(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void);
# 72 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Packet.nc"
static   uint8_t CC2420PacketP$CC2420Packet$getLqi(message_t *arg_0x2ab4c49ce838);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static   void CC2420PacketP$PacketTimeStamp32khz$clear(message_t *arg_0x2ab4c4a14b30);







static   void CC2420PacketP$PacketTimeStamp32khz$set(message_t *arg_0x2ab4c4a12468, CC2420PacketP$PacketTimeStamp32khz$size_type arg_0x2ab4c4a12728);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420PacketP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);




static   cc2420_metadata_t *CC2420PacketP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
static   uint8_t CC2420PacketP$PacketTimeSyncOffset$get(message_t *arg_0x2ab4c4a3e938);
#line 39
static   bool CC2420PacketP$PacketTimeSyncOffset$isSet(message_t *arg_0x2ab4c4a3e020);
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static   error_t CC2420PacketP$Acks$requestAck(message_t *arg_0x2ab4c49c6020);
#line 74
static   bool CC2420PacketP$Acks$wasAcked(message_t *arg_0x2ab4c49c5640);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$overflow(void);
#line 53
static   /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$size_type /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$get(void);
#line 71
static   void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$overflow(void);
# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static   bool CC2420ControlP$CC2420Config$isAddressRecognitionEnabled(void);
#line 110
static   bool CC2420ControlP$CC2420Config$isAutoAckEnabled(void);
#line 105
static   bool CC2420ControlP$CC2420Config$isHwAutoAckDefault(void);
#line 64
static   uint16_t CC2420ControlP$CC2420Config$getShortAddr(void);
#line 52
static  error_t CC2420ControlP$CC2420Config$sync(void);
#line 70
static   uint16_t CC2420ControlP$CC2420Config$getPanAddr(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420ControlP$StartupTimer$fired(void);
# 63 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Read.nc"
static  void CC2420ControlP$ReadRssi$default$readDone(error_t arg_0x2ab4c4acc1d0, CC2420ControlP$ReadRssi$val_t arg_0x2ab4c4acc488);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420ControlP$syncDone$runTask(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420ControlP$Init$init(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$SpiResource$granted(void);
#line 92
static  void CC2420ControlP$SyncResource$granted(void);
# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
static   error_t CC2420ControlP$CC2420Power$startOscillator(void);
#line 90
static   error_t CC2420ControlP$CC2420Power$rxOn(void);
#line 51
static   error_t CC2420ControlP$CC2420Power$startVReg(void);
#line 63
static   error_t CC2420ControlP$CC2420Power$stopVReg(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420ControlP$sync$runTask(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$Resource$release(void);
#line 78
static   error_t CC2420ControlP$Resource$request(void);
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void CC2420ControlP$InterruptCCA$fired(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$RssiResource$granted(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$fired(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$overflow(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$size_type arg_0x2ab4c47bedc8, /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$size_type arg_0x2ab4c47bd0c8);
#line 62
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$stop(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Init$init(void);
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$getNow(void);
#line 92
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$size_type arg_0x2ab4c47bedc8, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$size_type arg_0x2ab4c47bd0c8);
#line 55
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$size_type arg_0x2ab4c47c0148);






static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$stop(void);




static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$fired(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$overflow(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$makeInput(void);
#line 32
static   bool /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$get(void);


static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$makeOutput(void);
#line 29
static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set(void);
static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr(void);

static   bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$GeneralIO$get(void);
#line 32
static   bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$GeneralIO$get(void);


static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$makeOutput(void);
#line 29
static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$set(void);
static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$clr(void);


static   void /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$makeInput(void);
#line 32
static   bool /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$get(void);


static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$makeOutput(void);
#line 29
static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$set(void);
static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$clr(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureFallingEdge(void);
#line 55
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$disable(void);
#line 42
static   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureRisingEdge(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void HplMsp430InterruptP$Port14$clear(void);
#line 36
static   void HplMsp430InterruptP$Port14$disable(void);
#line 56
static   void HplMsp430InterruptP$Port14$edge(bool arg_0x2ab4c4c44860);
#line 31
static   void HplMsp430InterruptP$Port14$enable(void);









static   void HplMsp430InterruptP$Port26$clear(void);
#line 61
static   void HplMsp430InterruptP$Port26$default$fired(void);
#line 41
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
#line 36
static   void HplMsp430InterruptP$Port10$disable(void);
#line 56
static   void HplMsp430InterruptP$Port10$edge(bool arg_0x2ab4c4c44860);
#line 31
static   void HplMsp430InterruptP$Port10$enable(void);









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
static   void HplMsp430InterruptP$Port23$default$fired(void);
#line 61
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$fired(void);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$disable(void);
#line 42
static   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$enableRisingEdge(void);
# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$fired(void);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$disable(void);
#line 43
static   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$enableFallingEdge(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void CC2420SpiP$SpiPacket$sendDone(uint8_t *arg_0x2ab4c4d7b938, uint8_t *arg_0x2ab4c4d7bc28, uint16_t arg_0x2ab4c4d7a020, 
error_t arg_0x2ab4c4d7a2f8);
# 62 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   error_t CC2420SpiP$Fifo$continueRead(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 62 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d667c0, uint8_t arg_0x2ab4c4d66a78);
#line 91
static   void CC2420SpiP$Fifo$default$writeDone(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d62100, uint8_t arg_0x2ab4c4d623b8, error_t arg_0x2ab4c4d62670);
#line 82
static   cc2420_status_t CC2420SpiP$Fifo$write(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 82 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d64418, uint8_t arg_0x2ab4c4d646d0);
#line 51
static   cc2420_status_t CC2420SpiP$Fifo$beginRead(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 51 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d68a98, uint8_t arg_0x2ab4c4d68d50);
#line 71
static   void CC2420SpiP$Fifo$default$readDone(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d654a8, uint8_t arg_0x2ab4c4d65760, error_t arg_0x2ab4c4d65a18);
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static   void CC2420SpiP$ChipSpiResource$abortRelease(void);







static   error_t CC2420SpiP$ChipSpiResource$attemptRelease(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420SpiP$SpiResource$granted(void);
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static   cc2420_status_t CC2420SpiP$Ram$write(
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint16_t arg_0x2ab4c4d8e210, 
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
uint8_t arg_0x2ab4c4ad63e0, uint8_t *arg_0x2ab4c4ad66d0, uint8_t arg_0x2ab4c4ad6988);
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420SpiP$Reg$read(
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8ee28, 
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
uint16_t *arg_0x2ab4c4b0aa70);







static   cc2420_status_t CC2420SpiP$Reg$write(
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8ee28, 
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
uint16_t arg_0x2ab4c4b083e8);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiP$Resource$release(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiP$Resource$immediateRequest(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiP$Resource$request(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420SpiP$Resource$default$granted(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool CC2420SpiP$Resource$isOwner(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420SpiP$grant$runTask(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420SpiP$Strobe$strobe(
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8da90);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t StateImplP$Init$init(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t StateImplP$State$getState(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   void StateImplP$State$toIdle(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020);
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   bool StateImplP$State$isState(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020, 
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x2ab4c4db75f8);
#line 61
static   bool StateImplP$State$isIdle(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020);
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   error_t StateImplP$State$requestState(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020, 
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x2ab4c4d746f0);





static   void StateImplP$State$forceState(
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x2ab4c4e1b020, 
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x2ab4c4db8060);
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4eac8c8);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4eac8c8);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4eaab90, 
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x2ab4c4d7c7d0, uint8_t *arg_0x2ab4c4d7cac0, uint16_t arg_0x2ab4c4d7cd80);
#line 71
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4eaab90, 
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x2ab4c4d7b938, uint8_t *arg_0x2ab4c4d7bc28, uint16_t arg_0x2ab4c4d7a020, 
error_t arg_0x2ab4c4d7a2f8);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea8a50);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(uint8_t arg_0x2ab4c4d843d8);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t arg_0x2ab4c4eb4e58);
#line 49
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void);
# 180 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430Usart0P$Usart$enableRxIntr(void);
#line 197
static   void HplMsp430Usart0P$Usart$clrRxIntr(void);
#line 97
static   void HplMsp430Usart0P$Usart$resetUsart(bool arg_0x2ab4c4ee4e80);
#line 179
static   void HplMsp430Usart0P$Usart$disableIntr(void);
#line 90
static   void HplMsp430Usart0P$Usart$setUmctl(uint8_t arg_0x2ab4c4ee4020);
#line 177
static   void HplMsp430Usart0P$Usart$disableRxIntr(void);
#line 207
static   void HplMsp430Usart0P$Usart$clrIntr(void);
#line 80
static   void HplMsp430Usart0P$Usart$setUbr(uint16_t arg_0x2ab4c4ee6020);
#line 224
static   void HplMsp430Usart0P$Usart$tx(uint8_t arg_0x2ab4c4ed4020);
#line 128
static   void HplMsp430Usart0P$Usart$disableUart(void);
#line 153
static   void HplMsp430Usart0P$Usart$enableSpi(void);
#line 168
static   void HplMsp430Usart0P$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x2ab4c4edc648);
#line 231
static   uint8_t HplMsp430Usart0P$Usart$rx(void);
#line 192
static   bool HplMsp430Usart0P$Usart$isRxIntrPending(void);
#line 158
static   void HplMsp430Usart0P$Usart$disableSpi(void);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503fb70, 
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x2ab4c4eb4e58);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503fb70);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawI2CInterrupts$fired(void);
#line 39
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$default$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503e810);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t arg_0x2ab4c4eb4e58);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);
# 69 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t arg_0x2ab4c5057930);
#line 43
static   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);








static   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t arg_0x2ab4c5058870);







static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$requested(
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508d378);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508d378);
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508b378);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508b378);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void);
#line 73
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$requested(void);
#line 46
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$granted(void);
#line 81
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$immediateRequested(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$request(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$isOwner(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 80 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
# 7 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static   void HplMsp430I2C0P$HplI2C$clearModeI2C(void);
#line 6
static   bool HplMsp430I2C0P$HplI2C$isI2C(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static   am_addr_t ActiveMessageAddressC$amAddress(void);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t ActiveMessageAddressC$ActiveMessageAddress$amAddress(void);




static   am_group_t ActiveMessageAddressC$ActiveMessageAddress$amGroup(void);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420TinyosNetworkP$SubSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420TinyosNetworkP$SubReceive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420TinyosNetworkP$Send$default$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420TinyosNetworkP$Receive$default$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420TinyosNetworkP$NonTinyosSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
#line 89
static  void UniqueSendP$SubSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
#line 64
static  error_t UniqueSendP$Send$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t UniqueSendP$Init$init(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t RandomMlcgC$Random$rand16(void);
#line 35
static   uint32_t RandomMlcgC$Random$rand32(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RandomMlcgC$Init$init(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$SubReceive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t UniqueReceiveP$Init$init(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void PacketLinkP$SubSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void PacketLinkP$send$runTask(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void PacketLinkP$DelayTimer$fired(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t PacketLinkP$Send$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
# 65 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
static  uint16_t PacketLinkP$PacketLink$getRetryDelay(message_t *arg_0x2ab4c4a01020);
#line 46
static  void PacketLinkP$PacketLink$setRetries(message_t *arg_0x2ab4c4a05cf8, uint16_t arg_0x2ab4c4a04020);
#line 59
static  uint16_t PacketLinkP$PacketLink$getRetries(message_t *arg_0x2ab4c4a03610);
#line 53
static  void PacketLinkP$PacketLink$setRetryDelay(message_t *arg_0x2ab4c4a049a0, uint16_t arg_0x2ab4c4a04c68);
#line 71
static  bool PacketLinkP$PacketLink$wasDelivered(message_t *arg_0x2ab4c4a018f8);
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t CC2420CsmaP$SplitControl$start(void);
#line 109
static  error_t CC2420CsmaP$SplitControl$stop(void);
# 95 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static   void CC2420CsmaP$RadioBackoff$default$requestCca(message_t *arg_0x2ab4c49f6818);
#line 81
static   void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8);






static   void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40);
#line 81
static   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8);






static   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40);
# 73 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *arg_0x2ab4c53660c8, error_t arg_0x2ab4c5366380);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420CsmaP$Send$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
# 76 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
static   void CC2420CsmaP$CC2420Power$startOscillatorDone(void);
#line 56
static   void CC2420CsmaP$CC2420Power$startVRegDone(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420CsmaP$Resource$granted(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420CsmaP$sendDone_task$runTask(void);
#line 64
static  void CC2420CsmaP$stopDone_task$runTask(void);
#line 64
static  void CC2420CsmaP$startDone_task$runTask(void);
# 66 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t arg_0x2ab4c49f91e0);
#line 60
static   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t arg_0x2ab4c49fa840);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   void CC2420TransmitP$CaptureSFD$captured(uint16_t arg_0x2ab4c4bf0db0);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420TransmitP$BackoffTimer$fired(void);
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static   void CC2420TransmitP$CC2420Receive$receive(uint8_t arg_0x2ab4c53f6398, message_t *arg_0x2ab4c53f6690);
# 51 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static   error_t CC2420TransmitP$Send$send(message_t *arg_0x2ab4c53684d0, bool arg_0x2ab4c5368788);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static   void CC2420TransmitP$ChipSpiResource$releasing(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420TransmitP$Init$init(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420TransmitP$SpiResource$granted(void);
# 74 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420TransmitP$StdControl$start(void);









static  error_t CC2420TransmitP$StdControl$stop(void);
# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *arg_0x2ab4c4d62100, uint8_t arg_0x2ab4c4d623b8, error_t arg_0x2ab4c4d62670);
#line 71
static   void CC2420TransmitP$TXFIFO$readDone(uint8_t *arg_0x2ab4c4d654a8, uint8_t arg_0x2ab4c4d65760, error_t arg_0x2ab4c4d65a18);
# 53 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static  void CC2420ReceiveP$CC2420Config$syncDone(error_t arg_0x2ab4c49dea68);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420ReceiveP$receiveDone_task$runTask(void);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void);
#line 49
static   void CC2420ReceiveP$CC2420Receive$sfd(uint32_t arg_0x2ab4c53f7410);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420ReceiveP$Init$init(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ReceiveP$SpiResource$granted(void);
# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *arg_0x2ab4c4d62100, uint8_t arg_0x2ab4c4d623b8, error_t arg_0x2ab4c4d62670);
#line 71
static   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *arg_0x2ab4c4d654a8, uint8_t arg_0x2ab4c4d65760, error_t arg_0x2ab4c4d65a18);
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void CC2420ReceiveP$InterruptFIFOP$fired(void);
# 74 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420ReceiveP$StdControl$start(void);









static  error_t CC2420ReceiveP$StdControl$stop(void);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420MessageP$SubSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420MessageP$SubReceive$receive(
# 70 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
uint8_t arg_0x2ab4c554a020, 
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 53 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static  void CC2420MessageP$CC2420Config$syncDone(error_t arg_0x2ab4c49dea68);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t CC2420MessageP$Packet$payloadLength(message_t *arg_0x2ab4c49b2a68);
#line 115
static  void *CC2420MessageP$Packet$getPayload(message_t *arg_0x2ab4c49afb18, uint8_t arg_0x2ab4c49afdd0);
#line 95
static  uint8_t CC2420MessageP$Packet$maxPayloadLength(void);
#line 83
static  void CC2420MessageP$Packet$setPayloadLength(message_t *arg_0x2ab4c49b0608, uint8_t arg_0x2ab4c49b08c0);
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Packet.nc"
static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$source(message_t *arg_0x2ab4c4988100);
#line 26
static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$address(void);

static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$destination(message_t *arg_0x2ab4c498a850);



static  void CC2420MessageP$Ieee154Packet$setDestination(message_t *arg_0x2ab4c4988968, ieee154_saddr_t arg_0x2ab4c4988c28);



static  bool CC2420MessageP$Ieee154Packet$isForMe(message_t *arg_0x2ab4c4985180);
# 56 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
static  error_t CC2420MessageP$Ieee154Send$send(ieee154_saddr_t arg_0x2ab4c499d020, message_t *arg_0x2ab4c499d318, uint8_t arg_0x2ab4c499d5d0);
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t IPDispatchP$SplitControl$start(void);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static  void IPDispatchP$Boot$booted(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void IPDispatchP$RadioControl$startDone(error_t arg_0x2ab4c47363a0);
#line 117
static  void IPDispatchP$RadioControl$stopDone(error_t arg_0x2ab4c47355c0);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void IPDispatchP$sendTask$runTask(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void IPDispatchP$ExpireTimer$fired(void);
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void IPDispatchP$ICMP$solicitationDone(void);
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
static  void IPDispatchP$Statistics$clear(void);
# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
static  void IPDispatchP$Ieee154Send$sendDone(message_t *arg_0x2ab4c499cdc8, error_t arg_0x2ab4c499b0c8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *IPDispatchP$Ieee154Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  error_t IPDispatchP$IP$send(
# 93 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
uint8_t arg_0x2ab4c55b3888, 
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
struct split_ip_msg *arg_0x2ab4c497f270);





static  void IPDispatchP$IP$default$recv(
# 93 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
uint8_t arg_0x2ab4c55b3888, 
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0);
# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
static  void IPAddressP$IPAddress$getLLAddr(struct in6_addr *arg_0x2ab4c4951020);
#line 25
static  ieee154_saddr_t IPAddressP$IPAddress$getShortAddr(void);




static  void IPAddressP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8);

static  void IPAddressP$IPAddress$setPrefix(uint8_t *arg_0x2ab4c4950180);
#line 28
static  struct in6_addr *IPAddressP$IPAddress$getPublicAddr(void);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static  void IPRoutingP$Boot$booted(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void IPRoutingP$SortTimer$fired(void);
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void IPRoutingP$ICMP$solicitationDone(void);
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  void IPRoutingP$TGenSend$recv(struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0);
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
static  void IPRoutingP$Statistics$clear(void);
#line 29
static  void IPRoutingP$Statistics$get(IPRoutingP$Statistics$stat_str *arg_0x2ab4c473a410);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void IPRoutingP$TrafficGenTimer$fired(void);
# 84 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
static  bool IPRoutingP$IPRouting$hasRoute(void);
#line 48
static  error_t IPRoutingP$IPRouting$getNextHop(struct ip6_hdr *arg_0x2ab4c55e42a0, 
struct source_header *arg_0x2ab4c55e4618, 
ieee154_saddr_t arg_0x2ab4c55e4900, 
send_policy_t *arg_0x2ab4c55e4c18);
#line 79
static  void IPRoutingP$IPRouting$reportTransmission(send_policy_t *arg_0x2ab4c55e0d48);
#line 60
static  uint16_t IPRoutingP$IPRouting$getQuality(void);
#line 58
static  uint8_t IPRoutingP$IPRouting$getHopLimit(void);







static  void IPRoutingP$IPRouting$reportAdvertisement(ieee154_saddr_t arg_0x2ab4c55e1108, uint8_t arg_0x2ab4c55e13c0, 
uint8_t arg_0x2ab4c55e1698, uint16_t arg_0x2ab4c55e1958);
#line 40
static  bool IPRoutingP$IPRouting$isForMe(struct ip6_hdr *arg_0x2ab4c55e59a0);
#line 74
static  void IPRoutingP$IPRouting$reportReception(ieee154_saddr_t arg_0x2ab4c55e0210, uint8_t arg_0x2ab4c55e04c8);
#line 86
static  void IPRoutingP$IPRouting$insertRoutingHeaders(struct split_ip_msg *arg_0x2ab4c55debd0);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
static   void NoLedsC$Leds$led1Toggle(void);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$t */*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$get(void);
#line 89
static  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$put(/*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$t *arg_0x2ab4c55a1060);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Init$init(void);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$t */*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$get(void);
#line 89
static  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$put(/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$t *arg_0x2ab4c55a1060);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Init$init(void);
# 73 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
static  /*IPDispatchC.QueueC*/QueueC$0$Queue$t /*IPDispatchC.QueueC*/QueueC$0$Queue$head(void);
#line 90
static  error_t /*IPDispatchC.QueueC*/QueueC$0$Queue$enqueue(/*IPDispatchC.QueueC*/QueueC$0$Queue$t arg_0x2ab4c558f698);
#line 65
static  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$maxSize(void);
#line 81
static  /*IPDispatchC.QueueC*/QueueC$0$Queue$t /*IPDispatchC.QueueC*/QueueC$0$Queue$dequeue(void);
#line 50
static  bool /*IPDispatchC.QueueC*/QueueC$0$Queue$empty(void);







static  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$size(void);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$t */*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$get(void);
#line 89
static  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$put(/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$t *arg_0x2ab4c55a1060);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Init$init(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void ICMPResponderP$PingTimer$fired(void);
#line 72
static  void ICMPResponderP$Advertisement$fired(void);
# 33 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void ICMPResponderP$ICMP$sendAdvertisements(void);
#line 28
static  void ICMPResponderP$ICMP$sendSolicitations(void);






static  void ICMPResponderP$ICMP$sendTimeExceeded(struct ip6_hdr *arg_0x2ab4c55d46f8, unpack_info_t *arg_0x2ab4c55d49f0, uint16_t arg_0x2ab4c55d4cb8);
#line 25
static  uint16_t ICMPResponderP$ICMP$cksum(struct split_ip_msg *arg_0x2ab4c55d7a80, uint8_t arg_0x2ab4c55d7d38);
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
static  void ICMPResponderP$Statistics$clear(void);
#line 29
static  void ICMPResponderP$Statistics$get(ICMPResponderP$Statistics$stat_str *arg_0x2ab4c473a410);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void ICMPResponderP$Solicitation$fired(void);
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
static  void ICMPResponderP$ICMPPing$default$pingDone(
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
uint16_t arg_0x2ab4c589d740, 
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
uint16_t arg_0x2ab4c583b5d0, uint16_t arg_0x2ab4c583b890);
#line 8
static  void ICMPResponderP$ICMPPing$default$pingReply(
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
uint16_t arg_0x2ab4c589d740, 
# 8 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
struct in6_addr *arg_0x2ab4c583d948, struct icmp_stats *arg_0x2ab4c583dca0);
#line 6
static  error_t ICMPResponderP$ICMPPing$ping(
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
uint16_t arg_0x2ab4c589d740, 
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
struct in6_addr *arg_0x2ab4c583ea98, uint16_t arg_0x2ab4c583ed58, uint16_t arg_0x2ab4c583d060);
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  void ICMPResponderP$IP$recv(struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t UdpP$Init$init(void);
# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  error_t UdpP$UDP$sendto(
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x2ab4c5989060, 
# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, 
uint16_t arg_0x2ab4c472dc28);
#line 10
static  error_t UdpP$UDP$bind(
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x2ab4c5989060, 
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
uint16_t arg_0x2ab4c472fcc8);
#line 24
static  void UdpP$UDP$default$recvfrom(
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x2ab4c5989060, 
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, 
uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020);
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  void UdpP$IP$recv(struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static  void UDPShellP$Boot$booted(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void UDPShellP$Uptime$overflow(void);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  void UDPShellP$UDP$recvfrom(struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, 
uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020);
# 11 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/ShellCommand.nc"
static  char *UDPShellP$ShellCommand$default$eval(
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x2ab4c5999b38, 
# 11 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/ShellCommand.nc"
int arg_0x2ab4c599bb30, char **arg_0x2ab4c599be50);
# 3 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/RegisterShellCommand.nc"
static  char *UDPShellP$RegisterShellCommand$default$getCommandName(
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x2ab4c59982c0);
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
static  void UDPShellP$ICMPPing$pingDone(uint16_t arg_0x2ab4c583b5d0, uint16_t arg_0x2ab4c583b890);
#line 8
static  void UDPShellP$ICMPPing$pingReply(struct in6_addr *arg_0x2ab4c583d948, struct icmp_stats *arg_0x2ab4c583dca0);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$MoteInit$init(void);
#line 51
static  error_t PlatformP$MoteClockInit$init(void);
#line 51
static  error_t PlatformP$LedsInit$init(void);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/platforms/epic/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void);
# 32 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
static  void Msp430ClockP$Msp430ClockInit$initTimerB(void);
#line 31
static  void Msp430ClockP$Msp430ClockInit$initTimerA(void);
#line 29
static  void Msp430ClockP$Msp430ClockInit$setupDcoCalibrate(void);
static  void Msp430ClockP$Msp430ClockInit$initClocks(void);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
 static volatile uint8_t Msp430ClockP$IE1 __asm ("0x0000");
 static volatile uint16_t Msp430ClockP$TA0CTL __asm ("0x0160");
 static volatile uint16_t Msp430ClockP$TA0IV __asm ("0x012E");
 static volatile uint16_t Msp430ClockP$TBCTL __asm ("0x0180");
 static volatile uint16_t Msp430ClockP$TBIV __asm ("0x011E");

enum Msp430ClockP$__nesc_unnamed4343 {

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
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x2ab4c4302b20);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow(void);
# 115 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void);








static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
uint8_t arg_0x2ab4c4302b20);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get(void);
#line 70
static inline   bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$isOverflowPending(void);
#line 115
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void);




static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void);





static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void);








static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t;


static inline /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t;


static inline /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t;


static inline /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void);
#line 169
static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$get(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$CC2int(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(uint16_t x)  ;

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$compareControl(void);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$getControl(void);









static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$clearPendingInterrupt(void);









static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$setControlAsCompare(void);
#line 119
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$enableEvents(void);




static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$disableEvents(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void);




static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEvent(uint16_t x);









static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEventFromNow(uint16_t x);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t n);







static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$CC2int(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(uint16_t x)  ;
#line 61
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$captureControl(uint8_t l_cm);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$getControl(void);









static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$clearPendingInterrupt(void);
#line 99
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$setControlAsCapture(uint8_t cm);
#line 119
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$enableEvents(void);




static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$disableEvents(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void);
#line 164
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$clearOverflow(void);




static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Event$fired(void);
#line 181
static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$get(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t;

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$CC2int(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t x)  ;
static inline /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(uint16_t x)  ;

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$compareControl(void);
#line 74
static inline   /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$getControl(void);









static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$clearPendingInterrupt(void);









static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$setControlAsCompare(void);
#line 119
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$enableEvents(void);




static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$disableEvents(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void);




static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEvent(uint16_t x);









static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEventFromNow(uint16_t x);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t n);







static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t;


static inline /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t;


static inline /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t;


static inline /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Timer$overflow(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x2ab4c42c3690);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
typedef msp430_compare_control_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t;


static inline /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(uint16_t x)  ;
#line 74
static inline   /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Control$getControl(void);
#line 139
static inline   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void);
#line 169
static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Event$fired(void);







static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t n);



static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired(void);



static inline   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Timer$overflow(void);
# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void Msp430TimerCommonP$VectorTimerB1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA0$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerA1$fired(void);
#line 28
static   void Msp430TimerCommonP$VectorTimerB0$fired(void);
# 11 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
void sig_TIMERA0_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(12)))  ;
void sig_TIMERA1_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(10)))  ;
void sig_TIMERB0_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(26)))  ;
void sig_TIMERB1_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(24)))  ;
# 6 "/home/sdawson/cvs/tinyos-2.x/tos/platforms/epic/MotePlatformC.nc"
static inline  error_t MotePlatformC$Init$init(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$SoftwareInit$init(void);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
static  void RealMainP$Boot$booted(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$PlatformInit$init(void);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void RealMainP$Scheduler$init(void);
#line 61
static  void RealMainP$Scheduler$taskLoop(void);
#line 54
static  bool RealMainP$Scheduler$runNextTask(void);
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/system/RealMainP.nc"
int main(void)   ;
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x2ab4c41a08c0);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void SchedulerBasicP$McuSleep$sleep(void);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP$__nesc_unnamed4344 {

  SchedulerBasicP$NUM_TASKS = 13U, 
  SchedulerBasicP$NO_TASK = 255
};

uint8_t SchedulerBasicP$m_head;
uint8_t SchedulerBasicP$m_tail;
uint8_t SchedulerBasicP$m_next[SchedulerBasicP$NUM_TASKS];








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
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
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
#line 126
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void LedsP$Led0$makeOutput(void);
#line 29
static   void LedsP$Led0$set(void);





static   void LedsP$Led1$makeOutput(void);
#line 29
static   void LedsP$Led1$set(void);





static   void LedsP$Led2$makeOutput(void);
#line 29
static   void LedsP$Led2$set(void);
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void);
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$getRaw(void);
static inline   bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$get(void);
#line 48
static inline   uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$getRaw(void);
static inline   bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$get(void);
#line 48
static inline   uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$getRaw(void);
static inline   bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$get(void);
static inline   void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$makeInput(void);



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
#line 45
static inline   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$makeOutput(void);
#line 48
static inline   uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$getRaw(void);
static inline   bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$get(void);
static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$makeInput(void);



static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectModuleFunc(void);

static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectIOFunc(void);
#line 45
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$set(void);
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$clr(void);





static inline   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$makeOutput(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$makeOutput(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$set(void);
static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$clr(void);





static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$makeOutput(void);
#line 45
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$set(void);
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$clr(void);





static inline   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$makeOutput(void);
#line 45
static inline   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$set(void);






static inline   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$makeOutput(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void);
#line 34
static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void);





static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void UDPEchoP$StatusTimer$startPeriodic(uint32_t arg_0x2ab4c474c770);
# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  error_t UDPEchoP$Status$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, 
uint16_t arg_0x2ab4c472dc28);
#line 10
static  error_t UDPEchoP$Status$bind(uint16_t arg_0x2ab4c472fcc8);
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t UDPEchoP$RadioControl$start(void);
# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  error_t UDPEchoP$Echo$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, 
uint16_t arg_0x2ab4c472dc28);
#line 10
static  error_t UDPEchoP$Echo$bind(uint16_t arg_0x2ab4c472fcc8);
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
static  void UDPEchoP$IPStats$clear(void);
#line 34
static  void UDPEchoP$RouteStats$clear(void);
#line 29
static  void UDPEchoP$RouteStats$get(UDPEchoP$RouteStats$stat_str *arg_0x2ab4c473a410);




static  void UDPEchoP$ICMPStats$clear(void);
#line 29
static  void UDPEchoP$ICMPStats$get(UDPEchoP$ICMPStats$stat_str *arg_0x2ab4c473a410);
# 55 "UDPEchoP.nc"
bool UDPEchoP$timerStarted;
udp_statistics_t UDPEchoP$stats;
struct sockaddr_in6 UDPEchoP$route_dest;







static inline  void UDPEchoP$Boot$booted(void);
#line 89
static inline  void UDPEchoP$RadioControl$startDone(error_t e);



static inline  void UDPEchoP$RadioControl$stopDone(error_t e);



static inline  void UDPEchoP$Status$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta);



static inline  void UDPEchoP$Echo$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta);




enum UDPEchoP$__nesc_unnamed4345 {
  UDPEchoP$STATUS_SIZE = 
  sizeof(route_statistics_t ) + 
  sizeof(icmp_statistics_t ) + sizeof(udp_statistics_t )
};


static inline  void UDPEchoP$StatusTimer$fired(void);
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEvent(uint16_t arg_0x2ab4c42b7c70);

static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$get(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$fired(void);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$enableEvents(void);
#line 36
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$setControlAsCompare(void);










static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$disableEvents(void);
#line 33
static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$clearPendingInterrupt(void);
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline  error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Init$init(void);
#line 54
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$stop(void);




static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$fired(void);










static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$startAt(uint16_t t0, uint16_t dt);
#line 103
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$overflow(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$get(void);
static   bool /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$isOverflowPending(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void);
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$get(void);




static inline   bool /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$isOverflowPending(void);









static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$size_type /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$get(void);






static   bool /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$isOverflowPending(void);










static   void /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$overflow(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*CounterMilli32C.Transform*/TransformCounterC$0$upper_count_type /*CounterMilli32C.Transform*/TransformCounterC$0$m_upper;

enum /*CounterMilli32C.Transform*/TransformCounterC$0$__nesc_unnamed4346 {

  TransformCounterC$0$LOW_SHIFT_RIGHT = 5, 
  TransformCounterC$0$HIGH_SHIFT_LEFT = 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC$0$from_size_type ) - /*CounterMilli32C.Transform*/TransformCounterC$0$LOW_SHIFT_RIGHT, 
  TransformCounterC$0$NUM_UPPER_BITS = 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type ) - 8 * sizeof(/*CounterMilli32C.Transform*/TransformCounterC$0$from_size_type ) + 5, 



  TransformCounterC$0$OVERFLOW_MASK = /*CounterMilli32C.Transform*/TransformCounterC$0$NUM_UPPER_BITS ? ((/*CounterMilli32C.Transform*/TransformCounterC$0$upper_count_type )2 << (/*CounterMilli32C.Transform*/TransformCounterC$0$NUM_UPPER_BITS - 1)) - 1 : 0
};

static   /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get(void);
#line 122
static inline   void /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$overflow(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$fired(void);
#line 92
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$size_type arg_0x2ab4c47bd0c8);
#line 62
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$stop(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$get(void);
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0;
/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt;

enum /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$__nesc_unnamed4347 {

  TransformAlarmC$0$MAX_DELAY_LOG2 = 8 * sizeof(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_size_type ) - 1 - 5, 
  TransformAlarmC$0$MAX_DELAY = (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type )1 << /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$MAX_DELAY_LOG2
};

static inline   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getNow(void);




static inline   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getAlarm(void);










static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$stop(void);




static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$set_alarm(void);
#line 136
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type dt);
#line 151
static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$fired(void);
#line 166
static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$overflow(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$postTask(void);
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow(void);
#line 92
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x2ab4c47bd0c8);
#line 105
static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(void);
#line 62
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop(void);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired(void);
# 63 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
enum /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$__nesc_unnamed4348 {
#line 63
  AlarmToTimerC$0$fired = 0U
};
#line 63
typedef int /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$__nesc_sillytask_fired[/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired];
#line 44
uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_dt;
bool /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_oneshot;

static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$start(uint32_t t0, uint32_t dt, bool oneshot);
#line 60
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop(void);


static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask(void);






static inline   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired(void);
#line 82
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t t0, uint32_t dt);


static inline  uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask(void);
# 125 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(void);
#line 118
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x2ab4c4747020, uint32_t arg_0x2ab4c47472e0);
#line 67
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$stop(void);




static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$fired(
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x2ab4c48f8d38);
#line 60
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4349 {
#line 60
  VirtualizeTimerC$0$updateFromTimer = 1U
};
#line 60
typedef int /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_sillytask_updateFromTimer[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer];
#line 42
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4350 {

  VirtualizeTimerC$0$NUM_TIMERS = 9U, 
  VirtualizeTimerC$0$END_OF_LIST = 255
};








#line 48
typedef struct /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4351 {

  uint32_t t0;
  uint32_t dt;
  bool isoneshot : 1;
  bool isrunning : 1;
  bool _reserved : 6;
} /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t;

/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$NUM_TIMERS];




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(uint32_t now);
#line 89
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
#line 128
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void);




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot);









static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt);




static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(uint8_t num, uint32_t dt);




static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(uint8_t num);




static inline  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(uint8_t num);
#line 193
static inline   void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$size_type /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$get(void);
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   uint32_t /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$LocalTime$get(void);




static inline   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void);
# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static   error_t CC2420PacketP$Acks$requestAck(message_t *p_msg);









static inline   bool CC2420PacketP$Acks$wasAcked(message_t *p_msg);
#line 93
static inline   uint8_t CC2420PacketP$CC2420Packet$getLqi(message_t *p_msg);




static inline   cc2420_header_t *CC2420PacketP$CC2420PacketBody$getHeader(message_t *msg);



static inline   cc2420_metadata_t *CC2420PacketP$CC2420PacketBody$getMetadata(message_t *msg);
#line 121
static   void CC2420PacketP$PacketTimeStamp32khz$clear(message_t *msg);





static inline   void CC2420PacketP$PacketTimeStamp32khz$set(message_t *msg, uint32_t value);
#line 160
static inline   bool CC2420PacketP$PacketTimeSyncOffset$isSet(message_t *msg);








static inline   uint8_t CC2420PacketP$PacketTimeSyncOffset$get(message_t *msg);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$size_type /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$get(void);






static   bool /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$isOverflowPending(void);










static   void /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$overflow(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*Counter32khz32C.Transform*/TransformCounterC$1$upper_count_type /*Counter32khz32C.Transform*/TransformCounterC$1$m_upper;

enum /*Counter32khz32C.Transform*/TransformCounterC$1$__nesc_unnamed4352 {

  TransformCounterC$1$LOW_SHIFT_RIGHT = 0, 
  TransformCounterC$1$HIGH_SHIFT_LEFT = 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC$1$from_size_type ) - /*Counter32khz32C.Transform*/TransformCounterC$1$LOW_SHIFT_RIGHT, 
  TransformCounterC$1$NUM_UPPER_BITS = 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type ) - 8 * sizeof(/*Counter32khz32C.Transform*/TransformCounterC$1$from_size_type ) + 0, 



  TransformCounterC$1$OVERFLOW_MASK = /*Counter32khz32C.Transform*/TransformCounterC$1$NUM_UPPER_BITS ? ((/*Counter32khz32C.Transform*/TransformCounterC$1$upper_count_type )2 << (/*Counter32khz32C.Transform*/TransformCounterC$1$NUM_UPPER_BITS - 1)) - 1 : 0
};

static   /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$get(void);
#line 122
static inline   void /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$overflow(void);
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$overflow(void);
# 53 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static  void CC2420ControlP$CC2420Config$syncDone(error_t arg_0x2ab4c49dea68);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$RXCTRL1$write(uint16_t arg_0x2ab4c4b083e8);
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420ControlP$StartupTimer$start(CC2420ControlP$StartupTimer$size_type arg_0x2ab4c47c0148);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$MDMCTRL0$write(uint16_t arg_0x2ab4c4b083e8);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ControlP$RSTN$makeOutput(void);
#line 29
static   void CC2420ControlP$RSTN$set(void);
static   void CC2420ControlP$RSTN$clr(void);
# 63 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Read.nc"
static  void CC2420ControlP$ReadRssi$readDone(error_t arg_0x2ab4c4acc1d0, CC2420ControlP$ReadRssi$val_t arg_0x2ab4c4acc488);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420ControlP$syncDone$postTask(void);
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$RSSI$read(uint16_t *arg_0x2ab4c4b0aa70);







static   cc2420_status_t CC2420ControlP$IOCFG0$write(uint16_t arg_0x2ab4c4b083e8);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
static   am_addr_t CC2420ControlP$ActiveMessageAddress$amAddress(void);




static   am_group_t CC2420ControlP$ActiveMessageAddress$amGroup(void);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ControlP$CSN$makeOutput(void);
#line 29
static   void CC2420ControlP$CSN$set(void);
static   void CC2420ControlP$CSN$clr(void);




static   void CC2420ControlP$VREN$makeOutput(void);
#line 29
static   void CC2420ControlP$VREN$set(void);
static   void CC2420ControlP$VREN$clr(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SXOSCON$strobe(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$SpiResource$release(void);
#line 78
static   error_t CC2420ControlP$SpiResource$request(void);
#line 110
static   error_t CC2420ControlP$SyncResource$release(void);
#line 78
static   error_t CC2420ControlP$SyncResource$request(void);
# 76 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
static   void CC2420ControlP$CC2420Power$startOscillatorDone(void);
#line 56
static   void CC2420ControlP$CC2420Power$startVRegDone(void);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$IOCFG1$write(uint16_t arg_0x2ab4c4b083e8);
#line 55
static   cc2420_status_t CC2420ControlP$FSCTRL$write(uint16_t arg_0x2ab4c4b083e8);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SRXON$strobe(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$Resource$granted(void);
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static   cc2420_status_t CC2420ControlP$PANID$write(uint8_t arg_0x2ab4c4ad63e0, uint8_t *arg_0x2ab4c4ad66d0, uint8_t arg_0x2ab4c4ad6988);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t CC2420ControlP$InterruptCCA$disable(void);
#line 42
static   error_t CC2420ControlP$InterruptCCA$enableRisingEdge(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$RssiResource$release(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SRFOFF$strobe(void);
# 117 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
enum CC2420ControlP$__nesc_unnamed4353 {
#line 117
  CC2420ControlP$sync = 2U
};
#line 117
typedef int CC2420ControlP$__nesc_sillytask_sync[CC2420ControlP$sync];
enum CC2420ControlP$__nesc_unnamed4354 {
#line 118
  CC2420ControlP$syncDone = 3U
};
#line 118
typedef int CC2420ControlP$__nesc_sillytask_syncDone[CC2420ControlP$syncDone];
#line 85
#line 79
typedef enum CC2420ControlP$__nesc_unnamed4355 {
  CC2420ControlP$S_VREG_STOPPED, 
  CC2420ControlP$S_VREG_STARTING, 
  CC2420ControlP$S_VREG_STARTED, 
  CC2420ControlP$S_XOSC_STARTING, 
  CC2420ControlP$S_XOSC_STARTED
} CC2420ControlP$cc2420_control_state_t;

uint8_t CC2420ControlP$m_channel;

uint8_t CC2420ControlP$m_tx_power;

uint16_t CC2420ControlP$m_pan;

uint16_t CC2420ControlP$m_short_addr;

bool CC2420ControlP$m_sync_busy;


bool CC2420ControlP$autoAckEnabled;


bool CC2420ControlP$hwAutoAckDefault;


bool CC2420ControlP$addressRecognition;


bool CC2420ControlP$hwAddressRecognition;

 CC2420ControlP$cc2420_control_state_t CC2420ControlP$m_state = CC2420ControlP$S_VREG_STOPPED;



static void CC2420ControlP$writeFsctrl(void);
static void CC2420ControlP$writeMdmctrl0(void);
static void CC2420ControlP$writeId(void);





static inline  error_t CC2420ControlP$Init$init(void);
#line 171
static inline   error_t CC2420ControlP$Resource$request(void);







static inline   error_t CC2420ControlP$Resource$release(void);







static inline   error_t CC2420ControlP$CC2420Power$startVReg(void);
#line 199
static   error_t CC2420ControlP$CC2420Power$stopVReg(void);







static inline   error_t CC2420ControlP$CC2420Power$startOscillator(void);
#line 249
static inline   error_t CC2420ControlP$CC2420Power$rxOn(void);
#line 279
static   uint16_t CC2420ControlP$CC2420Config$getShortAddr(void);







static inline   uint16_t CC2420ControlP$CC2420Config$getPanAddr(void);
#line 300
static inline  error_t CC2420ControlP$CC2420Config$sync(void);
#line 332
static inline   bool CC2420ControlP$CC2420Config$isAddressRecognitionEnabled(void);
#line 359
static inline   bool CC2420ControlP$CC2420Config$isHwAutoAckDefault(void);






static inline   bool CC2420ControlP$CC2420Config$isAutoAckEnabled(void);









static inline  void CC2420ControlP$SyncResource$granted(void);
#line 390
static inline  void CC2420ControlP$SpiResource$granted(void);




static inline  void CC2420ControlP$RssiResource$granted(void);
#line 408
static inline   void CC2420ControlP$StartupTimer$fired(void);









static inline   void CC2420ControlP$InterruptCCA$fired(void);
#line 442
static inline  void CC2420ControlP$sync$runTask(void);



static inline  void CC2420ControlP$syncDone$runTask(void);









static void CC2420ControlP$writeFsctrl(void);
#line 473
static void CC2420ControlP$writeMdmctrl0(void);
#line 492
static void CC2420ControlP$writeId(void);
#line 509
static inline   void CC2420ControlP$ReadRssi$default$readDone(error_t error, uint16_t data);
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEvent(uint16_t arg_0x2ab4c42b7c70);

static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
static   uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$get(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$fired(void);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$enableEvents(void);
#line 36
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$setControlAsCompare(void);










static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$disableEvents(void);
#line 33
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$clearPendingInterrupt(void);
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline  error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Init$init(void);
#line 54
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$stop(void);




static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$fired(void);










static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$startAt(uint16_t t0, uint16_t dt);
#line 103
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$overflow(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$fired(void);
#line 92
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$size_type arg_0x2ab4c47bedc8, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$size_type arg_0x2ab4c47bd0c8);
#line 62
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$stop(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$get(void);
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0;
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt;

enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$__nesc_unnamed4356 {

  TransformAlarmC$1$MAX_DELAY_LOG2 = 8 * sizeof(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_size_type ) - 1 - 0, 
  TransformAlarmC$1$MAX_DELAY = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type )1 << /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$MAX_DELAY_LOG2
};

static inline   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$getNow(void);
#line 91
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$stop(void);




static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$set_alarm(void);
#line 136
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type dt);









static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type dt);




static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$fired(void);
#line 166
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$overflow(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$makeInput(void);
#line 59
static   bool /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$get(void);
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$get(void);
static inline   void /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$makeInput(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$makeOutput(void);
#line 34
static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$set(void);




static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$clr(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set(void);
static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr(void);




static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$makeOutput(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$HplGeneralIO$get(void);
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$GeneralIO$get(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$HplGeneralIO$get(void);
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$GeneralIO$get(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$makeOutput(void);
#line 34
static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$set(void);




static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$clr(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$set(void);
static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$clr(void);




static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$makeOutput(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$makeInput(void);
#line 59
static   bool /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$get(void);
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$get(void);
static inline   void /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$makeInput(void);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$makeOutput(void);
#line 34
static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$set(void);




static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$clr(void);
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$set(void);
static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$clr(void);




static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$makeOutput(void);
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$clearOverflow(void);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captured(uint16_t arg_0x2ab4c4bf0db0);
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$setControlAsCapture(uint8_t arg_0x2ab4c42a8600);

static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$enableEvents(void);
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$disableEvents(void);
#line 33
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$clearPendingInterrupt(void);
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectIOFunc(void);
#line 78
static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectModuleFunc(void);
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$enableCapture(uint8_t mode);
#line 50
static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureRisingEdge(void);



static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureFallingEdge(void);



static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$disable(void);






static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$captured(uint16_t time);
# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
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
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
void sig_PORT1_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(8)))  ;
#line 68
static inline    void HplMsp430InterruptP$Port11$default$fired(void);
static inline    void HplMsp430InterruptP$Port12$default$fired(void);
static inline    void HplMsp430InterruptP$Port13$default$fired(void);

static inline    void HplMsp430InterruptP$Port15$default$fired(void);
static inline    void HplMsp430InterruptP$Port16$default$fired(void);
static inline    void HplMsp430InterruptP$Port17$default$fired(void);
static inline   void HplMsp430InterruptP$Port10$enable(void);



static inline   void HplMsp430InterruptP$Port14$enable(void);



static inline   void HplMsp430InterruptP$Port10$disable(void);



static inline   void HplMsp430InterruptP$Port14$disable(void);



static inline   void HplMsp430InterruptP$Port10$clear(void);
static inline   void HplMsp430InterruptP$Port11$clear(void);
static inline   void HplMsp430InterruptP$Port12$clear(void);
static inline   void HplMsp430InterruptP$Port13$clear(void);
static inline   void HplMsp430InterruptP$Port14$clear(void);
static inline   void HplMsp430InterruptP$Port15$clear(void);
static inline   void HplMsp430InterruptP$Port16$clear(void);
static inline   void HplMsp430InterruptP$Port17$clear(void);








static inline   void HplMsp430InterruptP$Port10$edge(bool l2h);
#line 131
static inline   void HplMsp430InterruptP$Port14$edge(bool l2h);
#line 158
void sig_PORT2_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(2)))  ;
#line 171
static inline    void HplMsp430InterruptP$Port20$default$fired(void);
static inline    void HplMsp430InterruptP$Port21$default$fired(void);
static inline    void HplMsp430InterruptP$Port22$default$fired(void);
static inline    void HplMsp430InterruptP$Port23$default$fired(void);
static inline    void HplMsp430InterruptP$Port24$default$fired(void);
static inline    void HplMsp430InterruptP$Port25$default$fired(void);
static inline    void HplMsp430InterruptP$Port26$default$fired(void);
static inline    void HplMsp430InterruptP$Port27$default$fired(void);
#line 195
static inline   void HplMsp430InterruptP$Port20$clear(void);
static inline   void HplMsp430InterruptP$Port21$clear(void);
static inline   void HplMsp430InterruptP$Port22$clear(void);
static inline   void HplMsp430InterruptP$Port23$clear(void);
static inline   void HplMsp430InterruptP$Port24$clear(void);
static inline   void HplMsp430InterruptP$Port25$clear(void);
static inline   void HplMsp430InterruptP$Port26$clear(void);
static inline   void HplMsp430InterruptP$Port27$clear(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$clear(void);
#line 36
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$disable(void);
#line 56
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$edge(bool arg_0x2ab4c4c44860);
#line 31
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$enable(void);
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$fired(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$enable(bool rising);








static inline   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$enableRisingEdge(void);







static inline   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$disable(void);







static inline   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$fired(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$clear(void);
#line 36
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$disable(void);
#line 56
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$edge(bool arg_0x2ab4c4c44860);
#line 31
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$enable(void);
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$fired(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$enable(bool rising);
#line 54
static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$enableFallingEdge(void);



static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$disable(void);







static inline   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$fired(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t CC2420SpiP$SpiPacket$send(uint8_t *arg_0x2ab4c4d7c7d0, uint8_t *arg_0x2ab4c4d7cac0, uint16_t arg_0x2ab4c4d7cd80);
# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   void CC2420SpiP$Fifo$writeDone(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d62100, uint8_t arg_0x2ab4c4d623b8, error_t arg_0x2ab4c4d62670);
#line 71
static   void CC2420SpiP$Fifo$readDone(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d8f108, 
# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
uint8_t *arg_0x2ab4c4d654a8, uint8_t arg_0x2ab4c4d65760, error_t arg_0x2ab4c4d65a18);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static   void CC2420SpiP$ChipSpiResource$releasing(void);
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t CC2420SpiP$SpiByte$write(uint8_t arg_0x2ab4c4d843d8);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   void CC2420SpiP$WorkingState$toIdle(void);




static   bool CC2420SpiP$WorkingState$isIdle(void);
#line 45
static   error_t CC2420SpiP$WorkingState$requestState(uint8_t arg_0x2ab4c4d746f0);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiP$SpiResource$release(void);
#line 87
static   error_t CC2420SpiP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420SpiP$SpiResource$request(void);
#line 118
static   bool CC2420SpiP$SpiResource$isOwner(void);
#line 92
static  void CC2420SpiP$Resource$granted(
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
uint8_t arg_0x2ab4c4d91020);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420SpiP$grant$postTask(void);
# 88 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
enum CC2420SpiP$__nesc_unnamed4357 {
#line 88
  CC2420SpiP$grant = 4U
};
#line 88
typedef int CC2420SpiP$__nesc_sillytask_grant[CC2420SpiP$grant];
#line 63
enum CC2420SpiP$__nesc_unnamed4358 {
  CC2420SpiP$RESOURCE_COUNT = 5U, 
  CC2420SpiP$NO_HOLDER = 0xFF
};


enum CC2420SpiP$__nesc_unnamed4359 {
  CC2420SpiP$S_IDLE, 
  CC2420SpiP$S_BUSY
};


 uint16_t CC2420SpiP$m_addr;


uint8_t CC2420SpiP$m_requests = 0;


uint8_t CC2420SpiP$m_holder = CC2420SpiP$NO_HOLDER;


bool CC2420SpiP$release;


static error_t CC2420SpiP$attemptRelease(void);







static inline   void CC2420SpiP$ChipSpiResource$abortRelease(void);






static inline   error_t CC2420SpiP$ChipSpiResource$attemptRelease(void);




static   error_t CC2420SpiP$Resource$request(uint8_t id);
#line 126
static   error_t CC2420SpiP$Resource$immediateRequest(uint8_t id);
#line 149
static   error_t CC2420SpiP$Resource$release(uint8_t id);
#line 178
static inline   uint8_t CC2420SpiP$Resource$isOwner(uint8_t id);





static inline  void CC2420SpiP$SpiResource$granted(void);




static   cc2420_status_t CC2420SpiP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 209
static inline   error_t CC2420SpiP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len);



static inline   cc2420_status_t CC2420SpiP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 260
static   cc2420_status_t CC2420SpiP$Ram$write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len);
#line 287
static inline   cc2420_status_t CC2420SpiP$Reg$read(uint8_t addr, uint16_t *data);
#line 305
static   cc2420_status_t CC2420SpiP$Reg$write(uint8_t addr, uint16_t data);
#line 318
static   cc2420_status_t CC2420SpiP$Strobe$strobe(uint8_t addr);










static   void CC2420SpiP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error);








static error_t CC2420SpiP$attemptRelease(void);
#line 358
static inline  void CC2420SpiP$grant$runTask(void);








static inline   void CC2420SpiP$Resource$default$granted(uint8_t id);


static inline    void CC2420SpiP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error);


static inline    void CC2420SpiP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error);
# 74 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t StateImplP$state[5U];

enum StateImplP$__nesc_unnamed4360 {
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
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(
# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4eaab90, 
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
uint8_t *arg_0x2ab4c4d7b938, uint8_t *arg_0x2ab4c4d7bc28, uint16_t arg_0x2ab4c4d7a020, 
error_t arg_0x2ab4c4d7a2f8);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea8a50);
# 180 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$enableRxIntr(void);
#line 197
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr(void);
#line 97
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(bool arg_0x2ab4c4ee4e80);
#line 177
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr(void);
#line 224
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(uint8_t arg_0x2ab4c4ed4020);
#line 168
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x2ab4c4edc648);
#line 231
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx(void);
#line 192
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending(void);
#line 158
static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ea9840);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
uint8_t arg_0x2ab4c4ead6d8);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$postTask(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
enum /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_unnamed4361 {
#line 67
  Msp430SpiNoDmaP$0$signalDone_task = 5U
};
#line 67
typedef int /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_sillytask_signalDone_task[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task];
#line 56
enum /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$__nesc_unnamed4362 {
  Msp430SpiNoDmaP$0$SPI_ATOMIC_SIZE = 2
};

 uint16_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len;
 uint8_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf;
 uint8_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf;
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
#line 111
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(uint8_t id);
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(uint8_t id);
static inline    msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(uint8_t id);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(uint8_t id);

static void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp(void);
#line 144
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len);
#line 166
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void);



static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t data);
#line 183
static inline void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone(void);




static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void);

static inline    void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error);
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$UCLK$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$UCLK$selectModuleFunc(void);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void HplMsp430Usart0P$Interrupts$rxDone(uint8_t arg_0x2ab4c4eb4e58);
#line 49
static   void HplMsp430Usart0P$Interrupts$txDone(void);
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$URXD$selectIOFunc(void);
#line 85
static   void HplMsp430Usart0P$UTXD$selectIOFunc(void);
# 7 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
static   void HplMsp430Usart0P$HplI2C$clearModeI2C(void);
#line 6
static   bool HplMsp430Usart0P$HplI2C$isI2C(void);
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$SOMI$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$SOMI$selectModuleFunc(void);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void HplMsp430Usart0P$I2CInterrupts$fired(void);
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
static   void HplMsp430Usart0P$SIMO$selectIOFunc(void);
#line 78
static   void HplMsp430Usart0P$SIMO$selectModuleFunc(void);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
 static volatile uint8_t HplMsp430Usart0P$IE1 __asm ("0x0000");
 static volatile uint8_t HplMsp430Usart0P$ME1 __asm ("0x0004");
 static volatile uint8_t HplMsp430Usart0P$IFG1 __asm ("0x0002");
 static volatile uint8_t HplMsp430Usart0P$U0TCTL __asm ("0x0071");

 static volatile uint8_t HplMsp430Usart0P$U0TXBUF __asm ("0x0077");

void sig_UART0RX_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(18)))  ;




void sig_UART0TX_VECTOR(void) __attribute((wakeup)) __attribute((interrupt(16)))  ;
#line 132
static inline   void HplMsp430Usart0P$Usart$setUbr(uint16_t control);










static inline   void HplMsp430Usart0P$Usart$setUmctl(uint8_t control);







static inline   void HplMsp430Usart0P$Usart$resetUsart(bool reset);
#line 207
static inline   void HplMsp430Usart0P$Usart$disableUart(void);
#line 238
static inline   void HplMsp430Usart0P$Usart$enableSpi(void);








static   void HplMsp430Usart0P$Usart$disableSpi(void);








static inline void HplMsp430Usart0P$configSpi(msp430_spi_union_config_t *config);








static   void HplMsp430Usart0P$Usart$setModeSpi(msp430_spi_union_config_t *config);
#line 330
static inline   bool HplMsp430Usart0P$Usart$isRxIntrPending(void);










static inline   void HplMsp430Usart0P$Usart$clrRxIntr(void);



static inline   void HplMsp430Usart0P$Usart$clrIntr(void);



static inline   void HplMsp430Usart0P$Usart$disableRxIntr(void);







static inline   void HplMsp430Usart0P$Usart$disableIntr(void);



static inline   void HplMsp430Usart0P$Usart$enableRxIntr(void);
#line 382
static inline   void HplMsp430Usart0P$Usart$tx(uint8_t data);



static   uint8_t HplMsp430Usart0P$Usart$rx(void);
# 80 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse(void);







static   uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(void);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503fb70, 
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
uint8_t arg_0x2ab4c4eb4e58);
#line 49
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503fb70);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$fired(
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
uint8_t arg_0x2ab4c503e810);








static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void);




static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data);




static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawI2CInterrupts$fired(void);




static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id);
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data);
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$default$fired(uint8_t id);
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$__nesc_unnamed4363 {
#line 39
  FcfsResourceQueueC$0$NO_ENTRY = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[1U];
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
uint8_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

static inline  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void);




static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);



static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t id);



static inline   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
#line 72
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t id);
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$requested(
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508d378);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508d378);
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508b378);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508b378);
# 69 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$enqueue(resource_client_id_t arg_0x2ab4c5057930);
#line 43
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty(void);
#line 60
static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue(void);
# 73 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$requested(void);
#line 46
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted(void);
#line 81
static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested(void);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
uint8_t arg_0x2ab4c508e2a0);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask(void);
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4364 {
#line 75
  ArbiterP$0$grantedTask = 6U
};
#line 75
typedef int /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_sillytask_grantedTask[/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask];
#line 67
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4365 {
#line 67
  ArbiterP$0$RES_CONTROLLED, ArbiterP$0$RES_GRANTING, ArbiterP$0$RES_IMM_GRANTING, ArbiterP$0$RES_BUSY
};
#line 68
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4366 {
#line 68
  ArbiterP$0$default_owner_id = 1U
};
#line 69
enum /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$__nesc_unnamed4367 {
#line 69
  ArbiterP$0$NO_RES = 0xFF
};
uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
 uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id;
 uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;



static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$request(uint8_t id);
#line 90
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id);
#line 108
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id);
#line 130
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void);
#line 150
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void);
#line 163
static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void);










static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$isOwner(uint8_t id);
#line 187
static inline  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void);
#line 199
static inline   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$requested(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$granted(void);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$requested(void);


static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$immediateRequested(void);


static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id);

static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
static   void HplMsp430I2C0P$HplUsart$resetUsart(bool arg_0x2ab4c4ee4e80);
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
 static volatile uint8_t HplMsp430I2C0P$U0CTL __asm ("0x0070");





static inline   bool HplMsp430I2C0P$HplI2C$isI2C(void);



static inline   void HplMsp430I2C0P$HplI2C$clearModeI2C(void);
# 51 "/home/sdawson/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
am_addr_t ActiveMessageAddressC$addr = TOS_AM_ADDRESS;


am_group_t ActiveMessageAddressC$group = TOS_AM_GROUP;






static inline   am_addr_t ActiveMessageAddressC$ActiveMessageAddress$amAddress(void);
#line 82
static inline   am_group_t ActiveMessageAddressC$ActiveMessageAddress$amGroup(void);
#line 95
static inline   am_addr_t ActiveMessageAddressC$amAddress(void);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420TinyosNetworkP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
#line 89
static  void CC2420TinyosNetworkP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420TinyosNetworkP$NonTinyosReceive$receive(
# 49 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
uint8_t arg_0x2ab4c5228b68, 
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420TinyosNetworkP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420TinyosNetworkP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420TinyosNetworkP$NonTinyosSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 80 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline  error_t CC2420TinyosNetworkP$NonTinyosSend$send(message_t *msg, uint8_t len);
#line 101
static inline  void CC2420TinyosNetworkP$SubSend$sendDone(message_t *msg, error_t error);








static inline  message_t *CC2420TinyosNetworkP$SubReceive$receive(message_t *msg, void *payload, uint8_t len);
#line 124
static inline   message_t *CC2420TinyosNetworkP$Receive$default$receive(message_t *msg, void *payload, uint8_t len);






static inline   void CC2420TinyosNetworkP$Send$default$sendDone(message_t *msg, error_t error);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t UniqueSendP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
#line 89
static  void UniqueSendP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t UniqueSendP$Random$rand16(void);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *UniqueSendP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   void UniqueSendP$State$toIdle(void);
#line 45
static   error_t UniqueSendP$State$requestState(uint8_t arg_0x2ab4c4d746f0);
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
uint8_t UniqueSendP$localSendId;

enum UniqueSendP$__nesc_unnamed4368 {
  UniqueSendP$S_IDLE, 
  UniqueSendP$S_SENDING
};


static inline  error_t UniqueSendP$Init$init(void);
#line 75
static inline  error_t UniqueSendP$Send$send(message_t *msg, uint8_t len);
#line 104
static inline  void UniqueSendP$SubSend$sendDone(message_t *msg, error_t error);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
uint32_t RandomMlcgC$seed;


static inline  error_t RandomMlcgC$Init$init(void);
#line 58
static   uint32_t RandomMlcgC$Random$rand32(void);
#line 78
static inline   uint16_t RandomMlcgC$Random$rand16(void);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *UniqueReceiveP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$DuplicateReceive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueReceiveP.nc"
#line 56
struct UniqueReceiveP$__nesc_unnamed4369 {
  am_addr_t source;
  uint8_t dsn;
} UniqueReceiveP$receivedMessages[4];

uint8_t UniqueReceiveP$writeIndex = 0;


uint8_t UniqueReceiveP$recycleSourceElement;

enum UniqueReceiveP$__nesc_unnamed4370 {
  UniqueReceiveP$INVALID_ELEMENT = 0xFF
};


static inline  error_t UniqueReceiveP$Init$init(void);









static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn);
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn);


static inline  message_t *UniqueReceiveP$SubReceive$receive(message_t *msg, void *payload, 
uint8_t len);
#line 111
static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn);
#line 137
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn);
#line 158
static inline   message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *msg, void *payload, uint8_t len);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t PacketLinkP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t PacketLinkP$send$postTask(void);
# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void PacketLinkP$DelayTimer$startOneShot(uint32_t arg_0x2ab4c474b108);




static  void PacketLinkP$DelayTimer$stop(void);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void PacketLinkP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   uint8_t PacketLinkP$SendState$getState(void);
#line 56
static   void PacketLinkP$SendState$toIdle(void);
#line 45
static   error_t PacketLinkP$SendState$requestState(uint8_t arg_0x2ab4c4d746f0);
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_metadata_t *PacketLinkP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static   error_t PacketLinkP$PacketAcknowledgements$requestAck(message_t *arg_0x2ab4c49c6020);
#line 74
static   bool PacketLinkP$PacketAcknowledgements$wasAcked(message_t *arg_0x2ab4c49c5640);
# 77 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
enum PacketLinkP$__nesc_unnamed4371 {
#line 77
  PacketLinkP$send = 7U
};
#line 77
typedef int PacketLinkP$__nesc_sillytask_send[PacketLinkP$send];
#line 58
message_t *PacketLinkP$currentSendMsg;


uint8_t PacketLinkP$currentSendLen;


uint16_t PacketLinkP$totalRetries;





enum PacketLinkP$__nesc_unnamed4372 {
  PacketLinkP$S_IDLE, 
  PacketLinkP$S_SENDING
};




static void PacketLinkP$signalDone(error_t error);









static inline  void PacketLinkP$PacketLink$setRetries(message_t *msg, uint16_t maxRetries);








static inline  void PacketLinkP$PacketLink$setRetryDelay(message_t *msg, uint16_t retryDelay);






static inline  uint16_t PacketLinkP$PacketLink$getRetries(message_t *msg);






static inline  uint16_t PacketLinkP$PacketLink$getRetryDelay(message_t *msg);






static inline  bool PacketLinkP$PacketLink$wasDelivered(message_t *msg);
#line 130
static inline  error_t PacketLinkP$Send$send(message_t *msg, uint8_t len);
#line 171
static inline  void PacketLinkP$SubSend$sendDone(message_t *msg, error_t error);
#line 202
static inline  void PacketLinkP$DelayTimer$fired(void);






static inline  void PacketLinkP$send$runTask(void);










static void PacketLinkP$signalDone(error_t error);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void CC2420CsmaP$SplitControl$startDone(error_t arg_0x2ab4c47363a0);
#line 117
static  void CC2420CsmaP$SplitControl$stopDone(error_t arg_0x2ab4c47355c0);
# 95 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static   void CC2420CsmaP$RadioBackoff$requestCca(message_t *arg_0x2ab4c49f6818);
#line 81
static   void CC2420CsmaP$RadioBackoff$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8);






static   void CC2420CsmaP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40);
#line 66
static   void CC2420CsmaP$SubBackoff$setCongestionBackoff(uint16_t arg_0x2ab4c49f91e0);
#line 60
static   void CC2420CsmaP$SubBackoff$setInitialBackoff(uint16_t arg_0x2ab4c49fa840);
# 51 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static   error_t CC2420CsmaP$CC2420Transmit$send(message_t *arg_0x2ab4c53684d0, bool arg_0x2ab4c5368788);
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420CsmaP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t CC2420CsmaP$Random$rand16(void);
# 74 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420CsmaP$SubControl$start(void);









static  error_t CC2420CsmaP$SubControl$stop(void);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420CsmaP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);




static   cc2420_metadata_t *CC2420CsmaP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
static   error_t CC2420CsmaP$CC2420Power$startOscillator(void);
#line 90
static   error_t CC2420CsmaP$CC2420Power$rxOn(void);
#line 51
static   error_t CC2420CsmaP$CC2420Power$startVReg(void);
#line 63
static   error_t CC2420CsmaP$CC2420Power$stopVReg(void);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420CsmaP$Resource$release(void);
#line 78
static   error_t CC2420CsmaP$Resource$request(void);
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   bool CC2420CsmaP$SplitControlState$isState(uint8_t arg_0x2ab4c4db75f8);
#line 45
static   error_t CC2420CsmaP$SplitControlState$requestState(uint8_t arg_0x2ab4c4d746f0);





static   void CC2420CsmaP$SplitControlState$forceState(uint8_t arg_0x2ab4c4db8060);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420CsmaP$sendDone_task$postTask(void);
#line 56
static   error_t CC2420CsmaP$stopDone_task$postTask(void);
#line 56
static   error_t CC2420CsmaP$startDone_task$postTask(void);
# 74 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
enum CC2420CsmaP$__nesc_unnamed4373 {
#line 74
  CC2420CsmaP$startDone_task = 8U
};
#line 74
typedef int CC2420CsmaP$__nesc_sillytask_startDone_task[CC2420CsmaP$startDone_task];
enum CC2420CsmaP$__nesc_unnamed4374 {
#line 75
  CC2420CsmaP$stopDone_task = 9U
};
#line 75
typedef int CC2420CsmaP$__nesc_sillytask_stopDone_task[CC2420CsmaP$stopDone_task];
enum CC2420CsmaP$__nesc_unnamed4375 {
#line 76
  CC2420CsmaP$sendDone_task = 10U
};
#line 76
typedef int CC2420CsmaP$__nesc_sillytask_sendDone_task[CC2420CsmaP$sendDone_task];
#line 58
enum CC2420CsmaP$__nesc_unnamed4376 {
  CC2420CsmaP$S_STOPPED, 
  CC2420CsmaP$S_STARTING, 
  CC2420CsmaP$S_STARTED, 
  CC2420CsmaP$S_STOPPING, 
  CC2420CsmaP$S_TRANSMITTING
};

message_t *CC2420CsmaP$m_msg;

error_t CC2420CsmaP$sendErr = SUCCESS;


 bool CC2420CsmaP$ccaOn;






static inline void CC2420CsmaP$shutdown(void);


static  error_t CC2420CsmaP$SplitControl$start(void);
#line 96
static inline  error_t CC2420CsmaP$SplitControl$stop(void);
#line 122
static  error_t CC2420CsmaP$Send$send(message_t *p_msg, uint8_t len);
#line 198
static inline   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *p_msg, error_t err);




static inline   void CC2420CsmaP$CC2420Power$startVRegDone(void);



static inline  void CC2420CsmaP$Resource$granted(void);



static inline   void CC2420CsmaP$CC2420Power$startOscillatorDone(void);




static inline   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *msg);






static inline   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *msg);
#line 237
static inline  void CC2420CsmaP$sendDone_task$runTask(void);
#line 250
static inline  void CC2420CsmaP$startDone_task$runTask(void);







static inline  void CC2420CsmaP$stopDone_task$runTask(void);









static inline void CC2420CsmaP$shutdown(void);
#line 281
static inline    void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(message_t *msg);


static inline    void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(message_t *msg);


static inline    void CC2420CsmaP$RadioBackoff$default$requestCca(message_t *msg);
# 81 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
static   void CC2420TransmitP$RadioBackoff$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8);






static   void CC2420TransmitP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static   void CC2420TransmitP$PacketTimeStamp$clear(message_t *arg_0x2ab4c4a14b30);







static   void CC2420TransmitP$PacketTimeStamp$set(message_t *arg_0x2ab4c4a12468, CC2420TransmitP$PacketTimeStamp$size_type arg_0x2ab4c4a12728);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$STXONCCA$strobe(void);
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   error_t CC2420TransmitP$CaptureSFD$captureFallingEdge(void);
#line 55
static   void CC2420TransmitP$CaptureSFD$disable(void);
#line 42
static   error_t CC2420TransmitP$CaptureSFD$captureRisingEdge(void);
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   CC2420TransmitP$BackoffTimer$size_type CC2420TransmitP$BackoffTimer$getNow(void);
#line 55
static   void CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$BackoffTimer$size_type arg_0x2ab4c47c0148);






static   void CC2420TransmitP$BackoffTimer$stop(void);
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
static   cc2420_status_t CC2420TransmitP$TXFIFO_RAM$write(uint8_t arg_0x2ab4c4ad63e0, uint8_t *arg_0x2ab4c4ad66d0, uint8_t arg_0x2ab4c4ad6988);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
static   cc2420_status_t CC2420TransmitP$TXCTRL$write(uint16_t arg_0x2ab4c4b083e8);
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static   void CC2420TransmitP$CC2420Receive$sfd_dropped(void);
#line 49
static   void CC2420TransmitP$CC2420Receive$sfd(uint32_t arg_0x2ab4c53f7410);
# 73 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
static   void CC2420TransmitP$Send$sendDone(message_t *arg_0x2ab4c53660c8, error_t arg_0x2ab4c5366380);
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
static   void CC2420TransmitP$ChipSpiResource$abortRelease(void);







static   error_t CC2420TransmitP$ChipSpiResource$attemptRelease(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$SFLUSHTX$strobe(void);
# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$CSN$makeOutput(void);
#line 29
static   void CC2420TransmitP$CSN$set(void);
static   void CC2420TransmitP$CSN$clr(void);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420TransmitP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);




static   cc2420_metadata_t *CC2420TransmitP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
static   uint8_t CC2420TransmitP$PacketTimeSyncOffset$get(message_t *arg_0x2ab4c4a3e938);
#line 39
static   bool CC2420TransmitP$PacketTimeSyncOffset$isSet(message_t *arg_0x2ab4c4a3e020);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420TransmitP$SpiResource$release(void);
#line 87
static   error_t CC2420TransmitP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420TransmitP$SpiResource$request(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$CCA$makeInput(void);
#line 32
static   bool CC2420TransmitP$CCA$get(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$SNOP$strobe(void);
# 33 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$SFD$makeInput(void);
#line 32
static   bool CC2420TransmitP$SFD$get(void);
# 82 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   cc2420_status_t CC2420TransmitP$TXFIFO$write(uint8_t *arg_0x2ab4c4d64418, uint8_t arg_0x2ab4c4d646d0);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$STXON$strobe(void);
# 90 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
#line 80
typedef enum CC2420TransmitP$__nesc_unnamed4377 {
  CC2420TransmitP$S_STOPPED, 
  CC2420TransmitP$S_STARTED, 
  CC2420TransmitP$S_LOAD, 
  CC2420TransmitP$S_SAMPLE_CCA, 
  CC2420TransmitP$S_BEGIN_TRANSMIT, 
  CC2420TransmitP$S_SFD, 
  CC2420TransmitP$S_EFD, 
  CC2420TransmitP$S_ACK_WAIT, 
  CC2420TransmitP$S_CANCEL
} CC2420TransmitP$cc2420_transmit_state_t;





enum CC2420TransmitP$__nesc_unnamed4378 {
  CC2420TransmitP$CC2420_ABORT_PERIOD = 320
};

 message_t *CC2420TransmitP$m_msg;

 bool CC2420TransmitP$m_cca;

 uint8_t CC2420TransmitP$m_tx_power;

CC2420TransmitP$cc2420_transmit_state_t CC2420TransmitP$m_state = CC2420TransmitP$S_STOPPED;

bool CC2420TransmitP$m_receiving = FALSE;

uint16_t CC2420TransmitP$m_prev_time;


bool CC2420TransmitP$sfdHigh;


bool CC2420TransmitP$abortSpiRelease;


 int8_t CC2420TransmitP$totalCcaChecks;


 uint16_t CC2420TransmitP$myInitialBackoff;


 uint16_t CC2420TransmitP$myCongestionBackoff;



static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca);

static void CC2420TransmitP$loadTXFIFO(void);
static void CC2420TransmitP$attemptSend(void);
static void CC2420TransmitP$congestionBackoff(void);
static error_t CC2420TransmitP$acquireSpiResource(void);
static inline error_t CC2420TransmitP$releaseSpiResource(void);
static void CC2420TransmitP$signalDone(error_t err);



static inline  error_t CC2420TransmitP$Init$init(void);







static inline  error_t CC2420TransmitP$StdControl$start(void);










static  error_t CC2420TransmitP$StdControl$stop(void);
#line 172
static inline   error_t CC2420TransmitP$Send$send(message_t *p_msg, bool useCca);
#line 223
static inline   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t backoffTime);







static inline   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t backoffTime);







static __inline uint32_t CC2420TransmitP$getTime32(uint16_t time);
#line 258
static inline   void CC2420TransmitP$CaptureSFD$captured(uint16_t time);
#line 353
static inline   void CC2420TransmitP$ChipSpiResource$releasing(void);
#line 365
static inline   void CC2420TransmitP$CC2420Receive$receive(uint8_t type, message_t *ack_msg);
#line 393
static inline  void CC2420TransmitP$SpiResource$granted(void);
#line 431
static inline   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);
#line 463
static inline   void CC2420TransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);










static inline   void CC2420TransmitP$BackoffTimer$fired(void);
#line 524
static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca);
#line 592
static void CC2420TransmitP$attemptSend(void);
#line 634
static void CC2420TransmitP$congestionBackoff(void);






static error_t CC2420TransmitP$acquireSpiResource(void);







static inline error_t CC2420TransmitP$releaseSpiResource(void);
#line 671
static void CC2420TransmitP$loadTXFIFO(void);
#line 696
static void CC2420TransmitP$signalDone(error_t err);
# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool CC2420ReceiveP$FIFO$get(void);
# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static   bool CC2420ReceiveP$CC2420Config$isAddressRecognitionEnabled(void);
#line 110
static   bool CC2420ReceiveP$CC2420Config$isAutoAckEnabled(void);
#line 105
static   bool CC2420ReceiveP$CC2420Config$isHwAutoAckDefault(void);
#line 64
static   uint16_t CC2420ReceiveP$CC2420Config$getShortAddr(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420ReceiveP$receiveDone_task$postTask(void);
# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool CC2420ReceiveP$FIFOP$get(void);
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
static   void CC2420ReceiveP$PacketTimeStamp$clear(message_t *arg_0x2ab4c4a14b30);







static   void CC2420ReceiveP$PacketTimeStamp$set(message_t *arg_0x2ab4c4a12468, CC2420ReceiveP$PacketTimeStamp$size_type arg_0x2ab4c4a12728);
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
static   void CC2420ReceiveP$CC2420Receive$receive(uint8_t arg_0x2ab4c53f6398, message_t *arg_0x2ab4c53f6690);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420ReceiveP$SACK$strobe(void);
# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ReceiveP$CSN$set(void);
static   void CC2420ReceiveP$CSN$clr(void);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420ReceiveP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);




static   cc2420_metadata_t *CC2420ReceiveP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ReceiveP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ReceiveP$SpiResource$release(void);
#line 87
static   error_t CC2420ReceiveP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420ReceiveP$SpiResource$request(void);
#line 118
static   bool CC2420ReceiveP$SpiResource$isOwner(void);
# 62 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
static   error_t CC2420ReceiveP$RXFIFO$continueRead(uint8_t *arg_0x2ab4c4d667c0, uint8_t arg_0x2ab4c4d66a78);
#line 51
static   cc2420_status_t CC2420ReceiveP$RXFIFO$beginRead(uint8_t *arg_0x2ab4c4d68a98, uint8_t arg_0x2ab4c4d68d50);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t CC2420ReceiveP$InterruptFIFOP$disable(void);
#line 43
static   error_t CC2420ReceiveP$InterruptFIFOP$enableFallingEdge(void);
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
static   cc2420_status_t CC2420ReceiveP$SFLUSHRX$strobe(void);
# 115 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
enum CC2420ReceiveP$__nesc_unnamed4379 {
#line 115
  CC2420ReceiveP$receiveDone_task = 11U
};
#line 115
typedef int CC2420ReceiveP$__nesc_sillytask_receiveDone_task[CC2420ReceiveP$receiveDone_task];
#line 76
#line 70
typedef enum CC2420ReceiveP$__nesc_unnamed4380 {
  CC2420ReceiveP$S_STOPPED, 
  CC2420ReceiveP$S_STARTED, 
  CC2420ReceiveP$S_RX_LENGTH, 
  CC2420ReceiveP$S_RX_FCF, 
  CC2420ReceiveP$S_RX_PAYLOAD
} CC2420ReceiveP$cc2420_receive_state_t;

enum CC2420ReceiveP$__nesc_unnamed4381 {
  CC2420ReceiveP$RXFIFO_SIZE = 128, 
  CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE = 8, 
  CC2420ReceiveP$SACK_HEADER_LENGTH = 7
};

uint32_t CC2420ReceiveP$m_timestamp_queue[CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE];

uint8_t CC2420ReceiveP$m_timestamp_head;

uint8_t CC2420ReceiveP$m_timestamp_size;


uint8_t CC2420ReceiveP$m_missed_packets;


bool CC2420ReceiveP$receivingPacket;


 uint8_t CC2420ReceiveP$rxFrameLength;

 uint8_t CC2420ReceiveP$m_bytes_left;

 message_t *CC2420ReceiveP$m_p_rx_buf;

message_t CC2420ReceiveP$m_rx_buf;

CC2420ReceiveP$cc2420_receive_state_t CC2420ReceiveP$m_state;


static void CC2420ReceiveP$reset_state(void);
static void CC2420ReceiveP$beginReceive(void);
static void CC2420ReceiveP$receive(void);
static void CC2420ReceiveP$waitForNextPacket(void);
static void CC2420ReceiveP$flush(void);
static inline bool CC2420ReceiveP$passesAddressCheck(message_t *msg);




static inline  error_t CC2420ReceiveP$Init$init(void);





static inline  error_t CC2420ReceiveP$StdControl$start(void);
#line 138
static  error_t CC2420ReceiveP$StdControl$stop(void);
#line 153
static inline   void CC2420ReceiveP$CC2420Receive$sfd(uint32_t time);








static inline   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void);
#line 179
static inline   void CC2420ReceiveP$InterruptFIFOP$fired(void);










static inline  void CC2420ReceiveP$SpiResource$granted(void);








static inline   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error);
#line 331
static inline   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error);







static inline  void CC2420ReceiveP$receiveDone_task$runTask(void);
#line 360
static inline  void CC2420ReceiveP$CC2420Config$syncDone(error_t error);






static void CC2420ReceiveP$beginReceive(void);
#line 385
static void CC2420ReceiveP$flush(void);
#line 402
static void CC2420ReceiveP$receive(void);









static void CC2420ReceiveP$waitForNextPacket(void);
#line 450
static void CC2420ReceiveP$reset_state(void);










static inline bool CC2420ReceiveP$passesAddressCheck(message_t *msg);
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420MessageP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60);
# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
static   uint16_t CC2420MessageP$CC2420Config$getShortAddr(void);





static   uint16_t CC2420MessageP$CC2420Config$getPanAddr(void);
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
static   cc2420_header_t *CC2420MessageP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8);




static   cc2420_metadata_t *CC2420MessageP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778);
# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
static  void CC2420MessageP$Ieee154Send$sendDone(message_t *arg_0x2ab4c499cdc8, error_t arg_0x2ab4c499b0c8);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420MessageP$Ieee154Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8);
# 82 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  error_t CC2420MessageP$Ieee154Send$send(ieee154_saddr_t addr, 
message_t *msg, 
uint8_t len);
#line 106
static inline  ieee154_saddr_t CC2420MessageP$Ieee154Packet$address(void);



static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$destination(message_t *msg);




static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$source(message_t *msg);




static inline  void CC2420MessageP$Ieee154Packet$setDestination(message_t *msg, ieee154_saddr_t addr);









static inline  bool CC2420MessageP$Ieee154Packet$isForMe(message_t *msg);
#line 155
static inline  uint8_t CC2420MessageP$Packet$payloadLength(message_t *msg);



static inline  void CC2420MessageP$Packet$setPayloadLength(message_t *msg, uint8_t len);



static inline  uint8_t CC2420MessageP$Packet$maxPayloadLength(void);



static inline  void *CC2420MessageP$Packet$getPayload(message_t *msg, uint8_t len);






static inline  void CC2420MessageP$SubSend$sendDone(message_t *msg, error_t result);





static inline  message_t *CC2420MessageP$SubReceive$receive(uint8_t nw, message_t *msg, void *payload, uint8_t len);
#line 202
static inline  void CC2420MessageP$CC2420Config$syncDone(error_t error);
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void IPDispatchP$SplitControl$startDone(error_t arg_0x2ab4c47363a0);
#line 117
static  void IPDispatchP$SplitControl$stopDone(error_t arg_0x2ab4c47355c0);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  IPDispatchP$SendInfoPool$t *IPDispatchP$SendInfoPool$get(void);
#line 89
static  error_t IPDispatchP$SendInfoPool$put(IPDispatchP$SendInfoPool$t *arg_0x2ab4c55a1060);
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t IPDispatchP$Packet$payloadLength(message_t *arg_0x2ab4c49b2a68);
#line 115
static  void *IPDispatchP$Packet$getPayload(message_t *arg_0x2ab4c49afb18, uint8_t arg_0x2ab4c49afdd0);
#line 95
static  uint8_t IPDispatchP$Packet$maxPayloadLength(void);
#line 83
static  void IPDispatchP$Packet$setPayloadLength(message_t *arg_0x2ab4c49b0608, uint8_t arg_0x2ab4c49b08c0);
# 72 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Packet.nc"
static   uint8_t IPDispatchP$CC2420Packet$getLqi(message_t *arg_0x2ab4c49ce838);
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Packet.nc"
static  ieee154_saddr_t IPDispatchP$Ieee154Packet$source(message_t *arg_0x2ab4c4988100);
#line 28
static  ieee154_saddr_t IPDispatchP$Ieee154Packet$destination(message_t *arg_0x2ab4c498a850);



static  void IPDispatchP$Ieee154Packet$setDestination(message_t *arg_0x2ab4c4988968, ieee154_saddr_t arg_0x2ab4c4988c28);
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t IPDispatchP$RadioControl$start(void);
#line 109
static  error_t IPDispatchP$RadioControl$stop(void);
# 73 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
static  IPDispatchP$SendQueue$t IPDispatchP$SendQueue$head(void);
#line 90
static  error_t IPDispatchP$SendQueue$enqueue(IPDispatchP$SendQueue$t arg_0x2ab4c558f698);
#line 81
static  IPDispatchP$SendQueue$t IPDispatchP$SendQueue$dequeue(void);
#line 50
static  bool IPDispatchP$SendQueue$empty(void);
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t IPDispatchP$sendTask$postTask(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void IPDispatchP$ExpireTimer$startPeriodic(uint32_t arg_0x2ab4c474c770);
# 25 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
static  ieee154_saddr_t IPDispatchP$IPAddress$getShortAddr(void);
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void IPDispatchP$ICMP$sendSolicitations(void);






static  void IPDispatchP$ICMP$sendTimeExceeded(struct ip6_hdr *arg_0x2ab4c55d46f8, unpack_info_t *arg_0x2ab4c55d49f0, uint16_t arg_0x2ab4c55d4cb8);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  IPDispatchP$FragPool$t *IPDispatchP$FragPool$get(void);
#line 89
static  error_t IPDispatchP$FragPool$put(IPDispatchP$FragPool$t *arg_0x2ab4c55a1060);
# 72 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
static   void IPDispatchP$Leds$led1Toggle(void);
# 56 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
static  error_t IPDispatchP$Ieee154Send$send(ieee154_saddr_t arg_0x2ab4c499d020, message_t *arg_0x2ab4c499d318, uint8_t arg_0x2ab4c499d5d0);
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
static  void IPDispatchP$PacketLink$setRetries(message_t *arg_0x2ab4c4a05cf8, uint16_t arg_0x2ab4c4a04020);
#line 59
static  uint16_t IPDispatchP$PacketLink$getRetries(message_t *arg_0x2ab4c4a03610);
#line 53
static  void IPDispatchP$PacketLink$setRetryDelay(message_t *arg_0x2ab4c4a049a0, uint16_t arg_0x2ab4c4a04c68);
#line 71
static  bool IPDispatchP$PacketLink$wasDelivered(message_t *arg_0x2ab4c4a018f8);
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
static  IPDispatchP$SendEntryPool$t *IPDispatchP$SendEntryPool$get(void);
#line 89
static  error_t IPDispatchP$SendEntryPool$put(IPDispatchP$SendEntryPool$t *arg_0x2ab4c55a1060);
# 48 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
static  error_t IPDispatchP$IPRouting$getNextHop(struct ip6_hdr *arg_0x2ab4c55e42a0, 
struct source_header *arg_0x2ab4c55e4618, 
ieee154_saddr_t arg_0x2ab4c55e4900, 
send_policy_t *arg_0x2ab4c55e4c18);
#line 79
static  void IPDispatchP$IPRouting$reportTransmission(send_policy_t *arg_0x2ab4c55e0d48);
#line 58
static  uint8_t IPDispatchP$IPRouting$getHopLimit(void);
#line 40
static  bool IPDispatchP$IPRouting$isForMe(struct ip6_hdr *arg_0x2ab4c55e59a0);
#line 74
static  void IPDispatchP$IPRouting$reportReception(ieee154_saddr_t arg_0x2ab4c55e0210, uint8_t arg_0x2ab4c55e04c8);
#line 86
static  void IPDispatchP$IPRouting$insertRoutingHeaders(struct split_ip_msg *arg_0x2ab4c55debd0);
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  void IPDispatchP$IP$recv(
# 93 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
uint8_t arg_0x2ab4c55b3888, 
# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0);
# 185 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
enum IPDispatchP$__nesc_unnamed4382 {
#line 185
  IPDispatchP$sendTask = 12U
};
#line 185
typedef int IPDispatchP$__nesc_sillytask_sendTask[IPDispatchP$sendTask];
# 5 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/table.c"
static inline void IPDispatchP$table_init(table_t *table, void *data, 
uint16_t elt_len, uint16_t n_elts);





static void *IPDispatchP$table_search(table_t *table, int (*pred)(void *));
#line 26
static void IPDispatchP$table_map(table_t *table, void (*fn)(void *));
# 140 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
enum IPDispatchP$__nesc_unnamed4383 {
  IPDispatchP$S_RUNNING, 
  IPDispatchP$S_STOPPED, 
  IPDispatchP$S_STOPPING
};
uint8_t IPDispatchP$state = IPDispatchP$S_STOPPED;
bool IPDispatchP$radioBusy;
ip_statistics_t IPDispatchP$stats;
#line 160
table_t IPDispatchP$recon_cache;
#line 160
table_t IPDispatchP$forward_cache;




reconstruct_t IPDispatchP$recon_data[N_RECONSTRUCTIONS];



forward_entry_t IPDispatchP$forward_data[N_FORWARD_ENT];
#line 187
static inline void IPDispatchP$reconstruct_clear(void *ent);






static inline void IPDispatchP$forward_clear(void *ent);




static inline int IPDispatchP$forward_unused(void *ent);






uint16_t IPDispatchP$forward_lookup_tag;
uint16_t IPDispatchP$forward_lookup_src;
static inline int IPDispatchP$forward_lookup(void *ent);
#line 220
static send_info_t *IPDispatchP$getSendInfo(void);










static inline  error_t IPDispatchP$SplitControl$start(void);
#line 248
static inline  void IPDispatchP$RadioControl$startDone(error_t error);










static inline  void IPDispatchP$RadioControl$stopDone(error_t error);



static inline  void IPDispatchP$Boot$booted(void);
#line 292
static inline void IPDispatchP$signalDone(reconstruct_t *recon);
#line 322
static inline void IPDispatchP$reconstruct_age(void *elt);
#line 341
static inline void IPDispatchP$forward_age(void *elt);
#line 357
static inline void IPDispatchP$ip_print_heap(void);










static inline  void IPDispatchP$ExpireTimer$fired(void);
#line 386
static reconstruct_t *IPDispatchP$get_reconstruct(ieee154_saddr_t src, uint16_t tag);
#line 423
static inline void IPDispatchP$updateSourceRoute(ieee154_saddr_t prev_hop, struct source_header *sh);
#line 562
static inline message_t *IPDispatchP$handle1stFrag(message_t *msg, packed_lowmsg_t *lowmsg);
#line 762
static inline  message_t *IPDispatchP$Ieee154Receive$receive(message_t *msg, void *msg_payload, uint8_t len);
#line 887
static inline  void IPDispatchP$sendTask$runTask(void);
#line 951
static  error_t IPDispatchP$IP$send(uint8_t prot, struct split_ip_msg *msg);
#line 1063
static inline  void IPDispatchP$Ieee154Send$sendDone(message_t *msg, error_t error);
#line 1119
static inline  void IPDispatchP$ICMP$solicitationDone(void);
#line 1135
static inline  void IPDispatchP$Statistics$clear(void);



static inline   void IPDispatchP$IP$default$recv(uint8_t nxt_hdr, struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta);
# 40 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
static inline  ieee154_saddr_t IPAddressP$IPAddress$getShortAddr(void);
#line 53
static  void IPAddressP$IPAddress$getLLAddr(struct in6_addr *addr);





static  void IPAddressP$IPAddress$getIPAddr(struct in6_addr *addr);




static  struct in6_addr *IPAddressP$IPAddress$getPublicAddr(void);




static inline  void IPAddressP$IPAddress$setPrefix(uint8_t *pfx);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t IPRoutingP$Random$rand16(void);
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
static  void IPRoutingP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8);
#line 28
static  struct in6_addr *IPRoutingP$IPAddress$getPublicAddr(void);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void IPRoutingP$SortTimer$startPeriodic(uint32_t arg_0x2ab4c474c770);
# 33 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void IPRoutingP$ICMP$sendAdvertisements(void);
#line 28
static  void IPRoutingP$ICMP$sendSolicitations(void);
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  error_t IPRoutingP$TGenSend$send(struct split_ip_msg *arg_0x2ab4c497f270);
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool IPRoutingP$TrafficGenTimer$isRunning(void);
#line 62
static  void IPRoutingP$TrafficGenTimer$startOneShot(uint32_t arg_0x2ab4c474b108);




static  void IPRoutingP$TrafficGenTimer$stop(void);
# 43 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
enum IPRoutingP$__nesc_unnamed4384 {
  IPRoutingP$SHORT_EPOCH = 0, 
  IPRoutingP$LONG_EPOCH = 1
};



uint16_t IPRoutingP$last_qual;
uint8_t IPRoutingP$last_hops;

uint8_t IPRoutingP$num_low_neigh;

bool IPRoutingP$soliciting;



struct neigh_entry *IPRoutingP$default_route;
uint16_t IPRoutingP$default_route_failures;

uint32_t IPRoutingP$traffic_interval;
bool IPRoutingP$traffic_sent;






struct neigh_entry IPRoutingP$neigh_table[N_NEIGH];

static inline void IPRoutingP$printTable(void);


static inline void IPRoutingP$updateRankings(void);
static void IPRoutingP$swapNodes(struct neigh_entry *highNode, struct neigh_entry *lowNode);
static uint8_t IPRoutingP$checkThresh(uint32_t firstVal, uint32_t secondVal, uint16_t thresh);
static void IPRoutingP$evictNeighbor(struct neigh_entry *neigh);
static uint16_t IPRoutingP$getMetric(struct neigh_entry *neigh);

static uint16_t IPRoutingP$adjustLQI(uint8_t val);






static inline void IPRoutingP$clearStats(struct neigh_entry *r);
#line 109
static void IPRoutingP$restartTrafficGen(void);









static inline  void IPRoutingP$TrafficGenTimer$fired(void);
#line 147
static inline  void IPRoutingP$TGenSend$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta);



static inline  void IPRoutingP$Boot$booted(void);
#line 185
static inline  bool IPRoutingP$IPRouting$isForMe(struct ip6_hdr *hdr);
#line 260
static struct neigh_entry *IPRoutingP$getNeighEntry(cmpr_ip6_addr_t a);
#line 561
static uint16_t IPRoutingP$getConfidence(struct neigh_entry *neigh);
#line 585
static inline uint16_t IPRoutingP$getSuccess(struct neigh_entry *neigh);
#line 597
static uint16_t IPRoutingP$getLinkCost(struct neigh_entry *neigh);









static inline void IPRoutingP$printTable(void);
#line 655
static uint16_t IPRoutingP$getMetric(struct neigh_entry *r);





static void IPRoutingP$chooseNewRandomDefault(bool force);
#line 737
static  error_t IPRoutingP$IPRouting$getNextHop(struct ip6_hdr *hdr, 
struct source_header *sh, 
ieee154_saddr_t prev_hop, 
send_policy_t *ret);
#line 829
static  uint8_t IPRoutingP$IPRouting$getHopLimit(void);






static  uint16_t IPRoutingP$IPRouting$getQuality(void);
#line 862
static inline  void IPRoutingP$IPRouting$reportAdvertisement(ieee154_saddr_t neigh, uint8_t hops, 
uint8_t lqi, uint16_t cost);
#line 953
static inline  void IPRoutingP$IPRouting$reportReception(ieee154_saddr_t neigh, uint8_t lqi);
#line 971
static inline  void IPRoutingP$IPRouting$reportTransmission(send_policy_t *policy);
#line 1047
static inline  bool IPRoutingP$IPRouting$hasRoute(void);
#line 1111
static inline  void IPRoutingP$IPRouting$insertRoutingHeaders(struct split_ip_msg *msg);
#line 1179
static inline  void IPRoutingP$SortTimer$fired(void);
#line 1214
static inline  void IPRoutingP$ICMP$solicitationDone(void);
#line 1227
static inline  void IPRoutingP$Statistics$get(route_statistics_t *statistics);
#line 1241
static inline  void IPRoutingP$Statistics$clear(void);



static void IPRoutingP$evictNeighbor(struct neigh_entry *neigh);
#line 1276
static inline void IPRoutingP$updateRankings(void);
#line 1336
static void IPRoutingP$swapNodes(struct neigh_entry *highNode, struct neigh_entry *lowNode);










static uint8_t IPRoutingP$checkThresh(uint32_t firstVal, uint32_t secondVal, uint16_t thresh);
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/system/NoLedsC.nc"
static inline   void NoLedsC$Leds$led1Toggle(void);
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$free;
uint8_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$index;
/*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t */*IPDispatchC.FragPool.PoolP*/PoolP$0$queue[12];
/*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool[12];

static inline  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Init$init(void);
#line 88
static  /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t */*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$get(void);
#line 103
static  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$put(/*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t *newVal);
#line 60
uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free;
uint8_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index;
/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t */*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$queue[12];
/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool[12];

static inline  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Init$init(void);
#line 88
static  /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t */*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$get(void);
#line 103
static  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$put(/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t *newVal);
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
/*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$queue[12];
uint8_t /*IPDispatchC.QueueC*/QueueC$0$head = 0;
uint8_t /*IPDispatchC.QueueC*/QueueC$0$tail = 0;
uint8_t /*IPDispatchC.QueueC*/QueueC$0$size = 0;

static inline  bool /*IPDispatchC.QueueC*/QueueC$0$Queue$empty(void);



static inline  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$size(void);



static inline  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$maxSize(void);



static inline  /*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$Queue$head(void);



static inline void /*IPDispatchC.QueueC*/QueueC$0$printQueue(void);
#line 85
static  /*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$Queue$dequeue(void);
#line 97
static  error_t /*IPDispatchC.QueueC*/QueueC$0$Queue$enqueue(/*IPDispatchC.QueueC*/QueueC$0$queue_t newVal);
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free;
uint8_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index;
/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t */*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$queue[12];
/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool[12];

static inline  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Init$init(void);
#line 88
static inline  /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t */*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$get(void);
#line 103
static  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$put(/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t *newVal);
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool ICMPResponderP$PingTimer$isRunning(void);
#line 53
static  void ICMPResponderP$PingTimer$startPeriodic(uint32_t arg_0x2ab4c474c770);
#line 67
static  void ICMPResponderP$PingTimer$stop(void);
# 84 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
static  bool ICMPResponderP$IPRouting$hasRoute(void);
#line 60
static  uint16_t ICMPResponderP$IPRouting$getQuality(void);
#line 58
static  uint8_t ICMPResponderP$IPRouting$getHopLimit(void);







static  void ICMPResponderP$IPRouting$reportAdvertisement(ieee154_saddr_t arg_0x2ab4c55e1108, uint8_t arg_0x2ab4c55e13c0, 
uint8_t arg_0x2ab4c55e1698, uint16_t arg_0x2ab4c55e1958);
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/LocalTime.nc"
static   uint32_t ICMPResponderP$LocalTime$get(void);
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t ICMPResponderP$Random$rand16(void);
# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
static  void ICMPResponderP$IPAddress$getLLAddr(struct in6_addr *arg_0x2ab4c4951020);
static  void ICMPResponderP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8);

static  void ICMPResponderP$IPAddress$setPrefix(uint8_t *arg_0x2ab4c4950180);
#line 28
static  struct in6_addr *ICMPResponderP$IPAddress$getPublicAddr(void);
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool ICMPResponderP$Advertisement$isRunning(void);
#line 62
static  void ICMPResponderP$Advertisement$startOneShot(uint32_t arg_0x2ab4c474b108);
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
static  void ICMPResponderP$ICMP$solicitationDone(void);
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool ICMPResponderP$Solicitation$isRunning(void);
#line 62
static  void ICMPResponderP$Solicitation$startOneShot(uint32_t arg_0x2ab4c474b108);
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
static  void ICMPResponderP$ICMPPing$pingDone(
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
uint16_t arg_0x2ab4c589d740, 
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
uint16_t arg_0x2ab4c583b5d0, uint16_t arg_0x2ab4c583b890);
#line 8
static  void ICMPResponderP$ICMPPing$pingReply(
# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
uint16_t arg_0x2ab4c589d740, 
# 8 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
struct in6_addr *arg_0x2ab4c583d948, struct icmp_stats *arg_0x2ab4c583dca0);
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  error_t ICMPResponderP$IP$send(struct split_ip_msg *arg_0x2ab4c497f270);
# 52 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
icmp_statistics_t ICMPResponderP$stats;
uint32_t ICMPResponderP$solicitation_period;
uint32_t ICMPResponderP$advertisement_period;

uint16_t ICMPResponderP$ping_seq;
#line 56
uint16_t ICMPResponderP$ping_n;
#line 56
uint16_t ICMPResponderP$ping_rcv;
#line 56
uint16_t ICMPResponderP$ping_ident;
struct in6_addr ICMPResponderP$ping_dest;







static inline  uint16_t ICMPResponderP$ICMP$cksum(struct split_ip_msg *msg, uint8_t nxt_hdr);




static  void ICMPResponderP$ICMP$sendSolicitations(void);







static  void ICMPResponderP$ICMP$sendAdvertisements(void);







static inline  void ICMPResponderP$ICMP$sendTimeExceeded(struct ip6_hdr *hdr, unpack_info_t *u_info, uint16_t amount_here);
#line 149
static inline void ICMPResponderP$sendSolicitation(void);
#line 183
static inline void ICMPResponderP$sendPing(struct in6_addr *dest, uint16_t seqno);
#line 214
static inline void ICMPResponderP$handleRouterAdv(void *payload, uint16_t len, struct ip_metadata *meta);
#line 238
static inline void ICMPResponderP$sendAdvertisement(void);
#line 303
static  void ICMPResponderP$IP$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta);
#line 359
static inline  void ICMPResponderP$Solicitation$fired(void);










static inline  void ICMPResponderP$Advertisement$fired(void);










static inline  error_t ICMPResponderP$ICMPPing$ping(uint16_t client, struct in6_addr *target, uint16_t period, uint16_t n);
#line 393
static inline  void ICMPResponderP$PingTimer$fired(void);
#line 406
static inline  void ICMPResponderP$Statistics$get(icmp_statistics_t *statistics);



static inline  void ICMPResponderP$Statistics$clear(void);



static inline   void ICMPResponderP$ICMPPing$default$pingReply(uint16_t client, struct in6_addr *source, 
struct icmp_stats *ping_stats);


static inline   void ICMPResponderP$ICMPPing$default$pingDone(uint16_t client, uint16_t n, uint16_t m);
# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
static  void UdpP$IPAddress$getLLAddr(struct in6_addr *arg_0x2ab4c4951020);
static  void UdpP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8);
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  void UdpP$UDP$recvfrom(
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
uint8_t arg_0x2ab4c5989060, 
# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, 
uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020);
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
static  error_t UdpP$IP$send(struct split_ip_msg *arg_0x2ab4c497f270);
# 12 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
enum UdpP$__nesc_unnamed4385 {
  UdpP$N_CLIENTS = 3U
};

uint16_t UdpP$local_ports[UdpP$N_CLIENTS];

enum UdpP$__nesc_unnamed4386 {
  UdpP$LOCAL_PORT_START = 51024U, 
  UdpP$LOCAL_PORT_STOP = 54999U
};
uint16_t UdpP$last_localport = UdpP$LOCAL_PORT_START;

static inline uint16_t UdpP$alloc_lport(uint8_t clnt);
#line 42
static inline  error_t UdpP$Init$init(void);




static inline void UdpP$setSrcAddr(struct split_ip_msg *msg);









static  error_t UdpP$UDP$bind(uint8_t clnt, uint16_t port);










static  void UdpP$IP$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta);
#line 126
static  error_t UdpP$UDP$sendto(uint8_t clnt, struct sockaddr_in6 *dest, void *payload, 
uint16_t len);
#line 179
static inline   void UdpP$UDP$default$recvfrom(uint8_t clnt, struct sockaddr_in6 *from, void *payload, 
uint16_t len, struct ip_metadata *meta);
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
static   UDPShellP$Uptime$size_type UDPShellP$Uptime$get(void);
# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
static  error_t UDPShellP$UDP$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, 
uint16_t arg_0x2ab4c472dc28);
#line 10
static  error_t UDPShellP$UDP$bind(uint16_t arg_0x2ab4c472fcc8);
# 11 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/ShellCommand.nc"
static  char *UDPShellP$ShellCommand$eval(
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x2ab4c5999b38, 
# 11 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/ShellCommand.nc"
int arg_0x2ab4c599bb30, char **arg_0x2ab4c599be50);
# 3 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/RegisterShellCommand.nc"
static  char *UDPShellP$RegisterShellCommand$getCommandName(
# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
uint8_t arg_0x2ab4c59982c0);
# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
static  error_t UDPShellP$ICMPPing$ping(struct in6_addr *arg_0x2ab4c583ea98, uint16_t arg_0x2ab4c583ed58, uint16_t arg_0x2ab4c583d060);
# 48 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
struct sockaddr_in6 UDPShellP$session_endpoint;
uint32_t UDPShellP$boot_time;
uint64_t UDPShellP$uptime;

enum UDPShellP$__nesc_unnamed4387 {
  UDPShellP$N_EXTERNAL = 0U
};


enum UDPShellP$__nesc_unnamed4388 {
  UDPShellP$N_BUILTINS = 5, 

  UDPShellP$N_ARGS = 10, 
  UDPShellP$CMD_HELP = 0, 
  UDPShellP$CMD_ECHO = 1, 
  UDPShellP$CMD_PING6 = 2, 
  UDPShellP$CMD_TRACERT6 = 3, 

  UDPShellP$CMD_NO_CMD = 0xfe, 
  UDPShellP$CMDNAMSIZ = 10
};

struct UDPShellP$cmd_name {
  uint8_t c_len;
  char c_name[UDPShellP$CMDNAMSIZ];
};
struct UDPShellP$cmd_builtin {
  void (*action)(int , char **);
};

struct UDPShellP$cmd_name UDPShellP$externals[UDPShellP$N_EXTERNAL];


static inline  void UDPShellP$Boot$booted(void);
#line 100
char UDPShellP$reply_buf[MAX_REPLY_LEN];
char *UDPShellP$help_str = "sdsh-0.9\tbuiltins: [help, echo, ping6, uptime, ident]\n";
const char *UDPShellP$ping_fmt = " icmp_seq=%i ttl=%i time=%i ms\n";
const char *UDPShellP$ping_summary = "%i packets transmitted, %i received\n";
char *UDPShellP$ident_string = "\t[app: "
"UDPEchoC""]\n\t[user: ""sdawson""]\n\t[host: ""jackalope"
"]\n\t[time: ""0x49c2f1f8L""]\n";


static inline void UDPShellP$action_help(int argc, char **argv);
#line 149
static void UDPShellP$action_echo(int argc, char **argv);
#line 167
static void UDPShellP$action_ping6(int argc, char **argv);








static void UDPShellP$action_uptime(int argc, char **argv);
#line 188
static inline void UDPShellP$action_ident(int argc, char **argv);




struct UDPShellP$cmd_name UDPShellP$builtins[UDPShellP$N_BUILTINS] = { { 4, "help" }, 
{ 4, "echo" }, 
{ 5, "ping6" }, 
{ 6, "uptime" }, 
{ 5, "ident" } };
struct UDPShellP$cmd_builtin UDPShellP$builtin_actions[UDPShellP$N_BUILTINS] = { { UDPShellP$action_help }, 
{ UDPShellP$action_echo }, 
{ UDPShellP$action_ping6 }, 
{ UDPShellP$action_uptime }, 
{ UDPShellP$action_ident } };




static inline void UDPShellP$init_argv(char *cmd, uint16_t len, char **argv, int *argc);
#line 226
static int UDPShellP$lookup_cmd(char *cmd, int dbsize, struct UDPShellP$cmd_name *db);









static inline  void UDPShellP$UDP$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta);
#line 262
static inline  void UDPShellP$ICMPPing$pingReply(struct in6_addr *source, struct icmp_stats *stats);









static inline  void UDPShellP$ICMPPing$pingDone(uint16_t ping_rcv, uint16_t ping_n);






static inline   void UDPShellP$Uptime$overflow(void);





static inline   char *UDPShellP$ShellCommand$default$eval(uint8_t cmd_id, int argc, char **argv);


static inline   char *UDPShellP$RegisterShellCommand$default$getCommandName(uint8_t cmd_id);
# 212 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  void __nesc_enable_interrupt(void )
{
   __asm volatile ("eint");}

# 185 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
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
# 126 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Timer$overflow();
}





static inline    void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(uint8_t n)
{
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(uint8_t arg_0x2ab4c4302b20){
#line 28
  switch (arg_0x2ab4c4302b20) {
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
      /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$default$fired(arg_0x2ab4c4302b20);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 115 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(0);
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX0$fired();
#line 28
}
#line 28
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$cc_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$__nesc_unnamed4389 {
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

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Capture$getEvent(void)
{
  return * (volatile uint16_t *)370U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired(void)
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA0*/Msp430TimerCapComP$0$Compare$default$fired();
#line 34
}
#line 34
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$cc_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$__nesc_unnamed4390 {
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

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Capture$getEvent(void)
{
  return * (volatile uint16_t *)372U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired(void)
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA1*/Msp430TimerCapComP$1$Compare$default$fired();
#line 34
}
#line 34
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$cc_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$__nesc_unnamed4391 {
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

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Capture$getEvent(void)
{
  return * (volatile uint16_t *)374U;
}

#line 181
static inline    void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired(void)
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerA2*/Msp430TimerCapComP$2$Compare$default$fired();
#line 34
}
#line 34
# 120 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)302U;

#line 123
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$Event$fired(n >> 1);
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerA1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerA*/Msp430TimerP$0$VectorTimerX1$fired();
#line 28
}
#line 28
# 115 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(0);
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB0$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX0$fired();
#line 28
}
#line 28
# 185 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 103 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$overflow(void)
{
}

#line 103
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$overflow(void)
{
}

# 47 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void)
{
}

# 166 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$overflow(void)
{
}

# 279 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline   void UDPShellP$Uptime$overflow(void)
#line 279
{
  /* atomic removed: atomic calls only */
  UDPShellP$uptime += 0xffffffff;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$overflow(void){
#line 71
  UDPShellP$Uptime$overflow();
#line 71
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$overflow();
#line 71
  /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow();
#line 71
}
#line 71
# 122 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline   void /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$overflow(void)
{
  /* atomic removed: atomic calls only */
  {
    /*CounterMilli32C.Transform*/TransformCounterC$0$m_upper++;
    if ((/*CounterMilli32C.Transform*/TransformCounterC$0$m_upper & /*CounterMilli32C.Transform*/TransformCounterC$0$OVERFLOW_MASK) == 0) {
      /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$overflow();
      }
  }
}

# 47 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   void /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$overflow(void)
{
}

# 166 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$overflow(void)
{
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$overflow(void){
#line 71
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$overflow();
#line 71
  /*CC2420PacketC.CounterToLocalTimeC*/CounterToLocalTimeC$1$Counter$overflow();
#line 71
}
#line 71
# 122 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline   void /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$overflow(void)
{
  /* atomic removed: atomic calls only */
  {
    /*Counter32khz32C.Transform*/TransformCounterC$1$m_upper++;
    if ((/*Counter32khz32C.Transform*/TransformCounterC$1$m_upper & /*Counter32khz32C.Transform*/TransformCounterC$1$OVERFLOW_MASK) == 0) {
      /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$overflow();
      }
  }
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow(void){
#line 71
  /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$overflow();
#line 71
  /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$overflow();
#line 71
}
#line 71
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   void /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow(void)
{
  /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$overflow();
}

# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow(void){
#line 37
  /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$overflow();
#line 37
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$overflow();
#line 37
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$overflow();
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
# 126 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Overflow$fired(void)
{
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$overflow();
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 70 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired(void)
{
#line 71
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$postTask();
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$fired(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired();
#line 67
}
#line 67
# 151 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$fired(void)
{
  /* atomic removed: atomic calls only */
  {
    if (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt == 0) 
      {
        /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$fired();
      }
    else 
      {
        /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$set_alarm();
      }
  }
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$fired(void){
#line 67
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$fired();
#line 67
}
#line 67
# 124 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$disableEvents(void)
{
  * (volatile uint16_t *)386U &= ~0x0010;
}

# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$disableEvents(void){
#line 47
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$disableEvents();
#line 47
}
#line 47
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$fired(void)
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$disableEvents();
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$fired();
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$fired(void){
#line 34
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$getEvent(void)
{
  return * (volatile uint16_t *)402U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$__nesc_unnamed4392 {
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

# 86 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$get(void){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   uint16_t /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$get(void)
{
  return /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$get();
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$size_type /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$get(void){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 70 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   bool /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$isOverflowPending(void)
{
  return * (volatile uint16_t *)384U & 1U;
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   bool /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$isOverflowPending(void){
#line 35
  unsigned char result;
#line 35

#line 35
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$isOverflowPending();
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430CounterC.nc"
static inline   bool /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$isOverflowPending(void)
{
  return /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Msp430Timer$isOverflowPending();
}

# 60 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   bool /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$isOverflowPending(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$isOverflowPending();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 119 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$enableEvents(void)
{
  * (volatile uint16_t *)386U |= 0x0010;
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$enableEvents(void){
#line 46
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$enableEvents();
#line 46
}
#line 46
# 84 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$clearPendingInterrupt(void)
{
  * (volatile uint16_t *)386U &= ~0x0001;
}

# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$clearPendingInterrupt(void){
#line 33
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$clearPendingInterrupt();
#line 33
}
#line 33
# 144 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEvent(uint16_t x)
{
  * (volatile uint16_t *)402U = x;
}

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEvent(uint16_t arg_0x2ab4c42b7c70){
#line 30
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEvent(arg_0x2ab4c42b7c70);
#line 30
}
#line 30
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$get(void){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 154 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEventFromNow(uint16_t x)
{
  * (volatile uint16_t *)402U = /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Timer$get() + x;
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70){
#line 32
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Compare$setEventFromNow(arg_0x2ab4c42b5e70);
#line 32
}
#line 32
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   uint16_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$get(void){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 70 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$startAt(uint16_t t0, uint16_t dt)
{
  /* atomic removed: atomic calls only */
  {
    uint16_t now = /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Timer$get();
    uint16_t elapsed = now - t0;

#line 76
    if (elapsed >= dt) 
      {
        /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEventFromNow(2);
      }
    else 
      {
        uint16_t remaining = dt - elapsed;

#line 83
        if (remaining <= 2) {
          /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEventFromNow(2);
          }
        else {
#line 86
          /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430Compare$setEvent(now + remaining);
          }
      }
#line 88
    /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$clearPendingInterrupt();
    /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$enableEvents();
  }
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$size_type arg_0x2ab4c47bd0c8){
#line 92
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$startAt(arg_0x2ab4c47bedc8, arg_0x2ab4c47bd0c8);
#line 92
}
#line 92
# 181 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline    void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired(void)
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Compare$default$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$getEvent(void)
{
  return * (volatile uint16_t *)404U;
}

# 276 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_ntoh_leuint16(const void *source)
#line 276
{
  const uint8_t *base = source;

#line 278
  return ((uint16_t )base[1] << 8) | base[0];
}

#line 301
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

#line 294
static __inline uint32_t __nesc_ntoh_uint32(const void *source)
#line 294
{
  const uint8_t *base = source;

#line 296
  return ((((uint32_t )base[0] << 24) | (
  (uint32_t )base[1] << 16)) | (
  (uint32_t )base[2] << 8)) | base[3];
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static   void CC2420TransmitP$PacketTimeStamp$clear(message_t *arg_0x2ab4c4a14b30){
#line 59
  CC2420PacketP$PacketTimeStamp32khz$clear(arg_0x2ab4c4a14b30);
#line 59
}
#line 59
# 162 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void)
#line 162
{
  if (CC2420ReceiveP$m_timestamp_size) {
      CC2420ReceiveP$m_timestamp_size--;
    }
}

# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static   void CC2420TransmitP$CC2420Receive$sfd_dropped(void){
#line 55
  CC2420ReceiveP$CC2420Receive$sfd_dropped();
#line 55
}
#line 55
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureRisingEdge(void)
#line 50
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$enableCapture(MSP430TIMER_CM_RISING);
}

# 42 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   error_t CC2420TransmitP$CaptureSFD$captureRisingEdge(void){
#line 42
  unsigned char result;
#line 42

#line 42
  result = /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$getRaw(void)
#line 48
{
#line 48
  return * (volatile uint8_t *)28U & (0x01 << 1);
}

#line 49
static inline   bool /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$get(void)
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$getRaw() != 0;
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   bool /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$get(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$get(void)
#line 40
{
#line 40
  return /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$get();
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420TransmitP$SFD$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 153 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$CC2420Receive$sfd(uint32_t time)
#line 153
{
  if (CC2420ReceiveP$m_timestamp_size < CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE) {
      uint8_t tail = (CC2420ReceiveP$m_timestamp_head + CC2420ReceiveP$m_timestamp_size) % 
      CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE;

#line 157
      CC2420ReceiveP$m_timestamp_queue[tail] = time;
      CC2420ReceiveP$m_timestamp_size++;
    }
}

# 49 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static   void CC2420TransmitP$CC2420Receive$sfd(uint32_t arg_0x2ab4c53f7410){
#line 49
  CC2420ReceiveP$CC2420Receive$sfd(arg_0x2ab4c53f7410);
#line 49
}
#line 49
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureFallingEdge(void)
#line 54
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$enableCapture(MSP430TIMER_CM_FALLING);
}

# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   error_t CC2420TransmitP$CaptureSFD$captureFallingEdge(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captureFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$get(void){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$getNow(void)
{
  return /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$get();
}

#line 146
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type dt)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$getNow(), dt);
}

# 55 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$BackoffTimer$size_type arg_0x2ab4c47c0148){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$start(arg_0x2ab4c47c0148);
#line 55
}
#line 55
# 98 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   cc2420_header_t *CC2420PacketP$CC2420PacketBody$getHeader(message_t *msg)
#line 98
{
  return (cc2420_header_t *)((uint8_t *)msg + (size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
}

# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *CC2420TransmitP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 124 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$disableEvents(void)
{
  * (volatile uint16_t *)390U &= ~0x0010;
}

# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$disableEvents(void){
#line 47
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$disableEvents();
#line 47
}
#line 47
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$stop(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$disableEvents();
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$stop(void){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$stop();
#line 62
}
#line 62
# 91 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$stop(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$stop();
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420TransmitP$BackoffTimer$stop(void){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$stop();
#line 62
}
#line 62
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP$Resource$release(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 649 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP$releaseSpiResource(void)
#line 649
{
  CC2420TransmitP$SpiResource$release();
  return SUCCESS;
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set(void)
#line 37
{
#line 37
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CSN$set(void){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set();
#line 29
}
#line 29
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
inline static   cc2420_status_t CC2420TransmitP$TXFIFO_RAM$write(uint8_t arg_0x2ab4c4ad63e0, uint8_t *arg_0x2ab4c4ad66d0, uint8_t arg_0x2ab4c4ad6988){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420SpiP$Ram$write(CC2420_RAM_TXFIFO, arg_0x2ab4c4ad63e0, arg_0x2ab4c4ad66d0, arg_0x2ab4c4ad6988);
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$clr();
#line 39
}
#line 39
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$clr();
}

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CSN$clr(void){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr();
#line 30
}
#line 30
# 246 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_leuint8(const void *source)
#line 246
{
  const uint8_t *base = source;

#line 248
  return base[0];
}

# 169 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   uint8_t CC2420PacketP$PacketTimeSyncOffset$get(message_t *msg)
{
  return __nesc_ntoh_leuint8((unsigned char *)&CC2420PacketP$CC2420PacketBody$getHeader(msg)->length)
   + (sizeof(cc2420_header_t ) - MAC_HEADER_SIZE)
   - MAC_FOOTER_SIZE
   - sizeof(timesync_radio_t );
}

# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
inline static   uint8_t CC2420TransmitP$PacketTimeSyncOffset$get(message_t *arg_0x2ab4c4a3e938){
#line 47
  unsigned char result;
#line 47

#line 47
  result = CC2420PacketP$PacketTimeSyncOffset$get(arg_0x2ab4c4a3e938);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 235 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_uint8(const void *source)
#line 235
{
  const uint8_t *base = source;

#line 237
  return base[0];
}

#line 257
static __inline int8_t __nesc_ntoh_int8(const void *source)
#line 257
{
#line 257
  return __nesc_ntoh_uint8(source);
}

# 102 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   cc2420_metadata_t *CC2420PacketP$CC2420PacketBody$getMetadata(message_t *msg)
#line 102
{
  return (cc2420_metadata_t *)msg->metadata;
}

#line 160
static inline   bool CC2420PacketP$PacketTimeSyncOffset$isSet(message_t *msg)
{
  return __nesc_ntoh_int8((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(msg)->timesync);
}

# 39 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/PacketTimeSyncOffset.nc"
inline static   bool CC2420TransmitP$PacketTimeSyncOffset$isSet(message_t *arg_0x2ab4c4a3e020){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420PacketP$PacketTimeSyncOffset$isSet(arg_0x2ab4c4a3e020);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 127 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   void CC2420PacketP$PacketTimeStamp32khz$set(message_t *msg, uint32_t value)
{
  __nesc_hton_uint32((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(msg)->timestamp, value);
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static   void CC2420TransmitP$PacketTimeStamp$set(message_t *arg_0x2ab4c4a12468, CC2420TransmitP$PacketTimeStamp$size_type arg_0x2ab4c4a12728){
#line 67
  CC2420PacketP$PacketTimeStamp32khz$set(arg_0x2ab4c4a12468, arg_0x2ab4c4a12728);
#line 67
}
#line 67
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   CC2420TransmitP$BackoffTimer$size_type CC2420TransmitP$BackoffTimer$getNow(void){
#line 98
  unsigned long result;
#line 98

#line 98
  result = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 239 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static __inline uint32_t CC2420TransmitP$getTime32(uint16_t time)
{
  uint32_t recent_time = CC2420TransmitP$BackoffTimer$getNow();

#line 242
  return recent_time + (int16_t )(time - recent_time);
}

#line 258
static inline   void CC2420TransmitP$CaptureSFD$captured(uint16_t time)
#line 258
{
  unsigned char *__nesc_temp50;
#line 259
  uint32_t time32;
  uint8_t sfd_state = 0;

  /* atomic removed: atomic calls only */
#line 261
  {
    time32 = CC2420TransmitP$getTime32(time);
    switch (CC2420TransmitP$m_state) {

        case CC2420TransmitP$S_SFD: 
          CC2420TransmitP$m_state = CC2420TransmitP$S_EFD;
        CC2420TransmitP$sfdHigh = TRUE;


        CC2420TransmitP$m_receiving = FALSE;
        CC2420TransmitP$CaptureSFD$captureFallingEdge();
        CC2420TransmitP$PacketTimeStamp$set(CC2420TransmitP$m_msg, time32);
        if (CC2420TransmitP$PacketTimeSyncOffset$isSet(CC2420TransmitP$m_msg)) {
            uint8_t absOffset = sizeof(message_header_t ) - sizeof(cc2420_header_t ) + CC2420TransmitP$PacketTimeSyncOffset$get(CC2420TransmitP$m_msg);
            timesync_radio_t *timesync = (timesync_radio_t *)((nx_uint8_t *)CC2420TransmitP$m_msg + absOffset);

            (__nesc_temp50 = (unsigned char *)&*timesync, __nesc_hton_uint32(__nesc_temp50, __nesc_ntoh_uint32(__nesc_temp50) - time32));
            CC2420TransmitP$CSN$clr();
            CC2420TransmitP$TXFIFO_RAM$write(absOffset, (uint8_t *)timesync, sizeof(timesync_radio_t ));
            CC2420TransmitP$CSN$set();
          }

        if (__nesc_ntoh_leuint16((unsigned char *)&CC2420TransmitP$CC2420PacketBody$getHeader(CC2420TransmitP$m_msg)->fcf) & (1 << IEEE154_FCF_ACK_REQ)) {

            CC2420TransmitP$abortSpiRelease = TRUE;
          }
        CC2420TransmitP$releaseSpiResource();
        CC2420TransmitP$BackoffTimer$stop();

        if (CC2420TransmitP$SFD$get()) {
            break;
          }


        case CC2420TransmitP$S_EFD: 
          CC2420TransmitP$sfdHigh = FALSE;
        CC2420TransmitP$CaptureSFD$captureRisingEdge();

        if (__nesc_ntoh_leuint16((unsigned char *)&CC2420TransmitP$CC2420PacketBody$getHeader(CC2420TransmitP$m_msg)->fcf) & (1 << IEEE154_FCF_ACK_REQ)) {
            CC2420TransmitP$m_state = CC2420TransmitP$S_ACK_WAIT;
            CC2420TransmitP$BackoffTimer$start(CC2420_ACK_WAIT_DELAY);
          }
        else 
#line 302
          {
            CC2420TransmitP$signalDone(SUCCESS);
          }

        if (!CC2420TransmitP$SFD$get()) {
            break;
          }


        default: 

          if (!CC2420TransmitP$m_receiving && CC2420TransmitP$sfdHigh == FALSE) {
              CC2420TransmitP$sfdHigh = TRUE;
              CC2420TransmitP$CaptureSFD$captureFallingEdge();

              sfd_state = CC2420TransmitP$SFD$get();
              CC2420TransmitP$CC2420Receive$sfd(time32);
              CC2420TransmitP$m_receiving = TRUE;
              CC2420TransmitP$m_prev_time = time;
              if (CC2420TransmitP$SFD$get()) {

                  return;
                }
            }



        if (CC2420TransmitP$sfdHigh == TRUE) {
            CC2420TransmitP$sfdHigh = FALSE;
            CC2420TransmitP$CaptureSFD$captureRisingEdge();
            CC2420TransmitP$m_receiving = FALSE;








            if (sfd_state == 0 && time - CC2420TransmitP$m_prev_time < 10) {
                CC2420TransmitP$CC2420Receive$sfd_dropped();
                if (CC2420TransmitP$m_msg) {
                  CC2420TransmitP$PacketTimeStamp$clear(CC2420TransmitP$m_msg);
                  }
              }
#line 346
            break;
          }
      }
  }
}

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captured(uint16_t arg_0x2ab4c4bf0db0){
#line 50
  CC2420TransmitP$CaptureSFD$captured(arg_0x2ab4c4bf0db0);
#line 50
}
#line 50
# 164 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$clearOverflow(void)
{
  * (volatile uint16_t *)388U &= ~0x0002;
}

# 57 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$clearOverflow(void){
#line 57
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$clearOverflow();
#line 57
}
#line 57
# 84 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$clearPendingInterrupt(void)
{
  * (volatile uint16_t *)388U &= ~0x0001;
}

# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$clearPendingInterrupt(void){
#line 33
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$clearPendingInterrupt();
#line 33
}
#line 33
# 65 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$captured(uint16_t time)
#line 65
{
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$clearPendingInterrupt();
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$clearOverflow();
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$captured(time);
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$__nesc_unnamed4393 {
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

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$size_type /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$get(void){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53







inline static   bool /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$isOverflowPending(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430Counter32khzC.Counter*/Msp430CounterC$0$Counter$isOverflowPending();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)31U |= 0x01 << 1;
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectModuleFunc();
#line 78
}
#line 78
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$CC2int(/*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$__nesc_unnamed4394 {
#line 46
    /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

#line 61
static inline uint16_t /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$captureControl(uint8_t l_cm)
{
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$cc_t x = { 
  .cm = l_cm & 0x03, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 1, 
  .scs = 1, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$CC2int(x);
}

#line 99
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$setControlAsCapture(uint8_t cm)
{
  * (volatile uint16_t *)388U = /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$captureControl(cm);
}

# 44 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$setControlAsCapture(uint8_t arg_0x2ab4c42a8600){
#line 44
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$setControlAsCapture(arg_0x2ab4c42a8600);
#line 44
}
#line 44
# 119 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$enableEvents(void)
{
  * (volatile uint16_t *)388U |= 0x0010;
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$enableEvents(void){
#line 46
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$enableEvents();
#line 46
}
#line 46
# 382 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$tx(uint8_t data)
#line 382
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 383
    HplMsp430Usart0P$U0TXBUF = data;
#line 383
    __nesc_atomic_end(__nesc_atomic); }
}

# 224 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(uint8_t arg_0x2ab4c4ed4020){
#line 224
  HplMsp430Usart0P$Usart$tx(arg_0x2ab4c4ed4020);
#line 224
}
#line 224
# 330 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   bool HplMsp430Usart0P$Usart$isRxIntrPending(void)
#line 330
{
  if (HplMsp430Usart0P$IFG1 & (1 << 6)) {
      return TRUE;
    }
  return FALSE;
}

# 192 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
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
# 341 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$clrRxIntr(void)
#line 341
{
  HplMsp430Usart0P$IFG1 &= ~(1 << 6);
}

# 197 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
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
# 118 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline   void StateImplP$State$toIdle(uint8_t id)
#line 118
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 119
    StateImplP$state[id] = StateImplP$S_IDLE;
#line 119
    __nesc_atomic_end(__nesc_atomic); }
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   void CC2420SpiP$WorkingState$toIdle(void){
#line 56
  StateImplP$State$toIdle(0U);
#line 56
}
#line 56
# 95 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   void CC2420SpiP$ChipSpiResource$abortRelease(void)
#line 95
{
  /* atomic removed: atomic calls only */
#line 96
  CC2420SpiP$release = FALSE;
}

# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static   void CC2420TransmitP$ChipSpiResource$abortRelease(void){
#line 31
  CC2420SpiP$ChipSpiResource$abortRelease();
#line 31
}
#line 31
# 353 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$ChipSpiResource$releasing(void)
#line 353
{
  if (CC2420TransmitP$abortSpiRelease) {
      CC2420TransmitP$ChipSpiResource$abortRelease();
    }
}

# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static   void CC2420SpiP$ChipSpiResource$releasing(void){
#line 24
  CC2420TransmitP$ChipSpiResource$releasing();
#line 24
}
#line 24
# 205 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$granted(void)
#line 205
{
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted(void){
#line 46
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$granted();
#line 46
}
#line 46
# 151 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 97 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(bool arg_0x2ab4c4ee4e80){
#line 97
  HplMsp430Usart0P$Usart$resetUsart(arg_0x2ab4c4ee4e80);
#line 97
}
#line 97
#line 158
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi(void){
#line 158
  HplMsp430Usart0P$Usart$disableSpi();
#line 158
}
#line 158
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(uint8_t id)
#line 89
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(TRUE);
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableSpi();
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$resetUsart(FALSE);
}

# 215 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id)
#line 215
{
}

# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(uint8_t arg_0x2ab4c508b378){
#line 55
  switch (arg_0x2ab4c508b378) {
#line 55
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 55
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$unconfigure(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 55
      break;
#line 55
    default:
#line 55
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$unconfigure(arg_0x2ab4c508b378);
#line 55
      break;
#line 55
    }
#line 55
}
#line 55
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 58 "/home/sdawson/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
        uint8_t id = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead;

#line 62
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead];
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
          }
#line 65
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[id] = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
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
      /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

#line 68
      return __nesc_temp;
    }
  }
}

# 60 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   resource_client_id_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void)
#line 50
{
  return /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
}

# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 108 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(uint8_t id)
#line 108
{
  /* atomic removed: atomic calls only */
#line 109
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
        if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$isEmpty() == FALSE) {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$dequeue();
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$NO_RES;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(id);
          }
        else {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$unconfigure(id);
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$granted();
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

# 114 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(uint8_t id)
#line 114
{
#line 114
  return FAIL;
}

# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(uint8_t arg_0x2ab4c4ea9840){
#line 110
  unsigned char result;
#line 110

#line 110
  switch (arg_0x2ab4c4ea9840) {
#line 110
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 110
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$release(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 110
      break;
#line 110
    default:
#line 110
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$release(arg_0x2ab4c4ea9840);
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
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(uint8_t id)
#line 81
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$release(id);
}

# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420SpiP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$release(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 1);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SIMO$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 2);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SOMI$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 3);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UCLK$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectIOFunc();
#line 85
}
#line 85
# 119 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$enableEvents(void)
{
  * (volatile uint16_t *)390U |= 0x0010;
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$enableEvents(void){
#line 46
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$enableEvents();
#line 46
}
#line 46
# 84 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$clearPendingInterrupt(void)
{
  * (volatile uint16_t *)390U &= ~0x0001;
}

# 33 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$clearPendingInterrupt(void){
#line 33
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$clearPendingInterrupt();
#line 33
}
#line 33
# 144 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEvent(uint16_t x)
{
  * (volatile uint16_t *)406U = x;
}

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEvent(uint16_t arg_0x2ab4c42b7c70){
#line 30
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEvent(arg_0x2ab4c42b7c70);
#line 30
}
#line 30
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$get(void){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 154 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEventFromNow(uint16_t x)
{
  * (volatile uint16_t *)406U = /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Timer$get() + x;
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEventFromNow(uint16_t arg_0x2ab4c42b5e70){
#line 32
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$setEventFromNow(arg_0x2ab4c42b5e70);
#line 32
}
#line 32
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Timer.nc"
inline static   uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$get(void){
#line 34
  unsigned int result;
#line 34

#line 34
  result = /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get();
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 70 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$startAt(uint16_t t0, uint16_t dt)
{
  /* atomic removed: atomic calls only */
  {
    uint16_t now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Timer$get();
    uint16_t elapsed = now - t0;

#line 76
    if (elapsed >= dt) 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEventFromNow(2);
      }
    else 
      {
        uint16_t remaining = dt - elapsed;

#line 83
        if (remaining <= 2) {
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEventFromNow(2);
          }
        else {
#line 86
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$setEvent(now + remaining);
          }
      }
#line 88
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$clearPendingInterrupt();
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$enableEvents();
  }
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$size_type arg_0x2ab4c47bedc8, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$size_type arg_0x2ab4c47bd0c8){
#line 92
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$startAt(arg_0x2ab4c47bedc8, arg_0x2ab4c47bd0c8);
#line 92
}
#line 92
# 102 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   error_t CC2420SpiP$ChipSpiResource$attemptRelease(void)
#line 102
{
  return CC2420SpiP$attemptRelease();
}

# 39 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/ChipSpiResource.nc"
inline static   error_t CC2420TransmitP$ChipSpiResource$attemptRelease(void){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420SpiP$ChipSpiResource$attemptRelease();
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP$Resource$request(/*CC2420ControlC.Spi*/CC2420SpiC$0$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 171 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$Resource$request(void)
#line 171
{
  return CC2420ControlP$SpiResource$request();
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420CsmaP$Resource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420ControlP$Resource$request();
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 203 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Power$startVRegDone(void)
#line 203
{
  CC2420CsmaP$Resource$request();
}

# 56 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   void CC2420ControlP$CC2420Power$startVRegDone(void){
#line 56
  CC2420CsmaP$CC2420Power$startVRegDone();
#line 56
}
#line 56
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$set(void)
#line 37
{
#line 37
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$set(void){
#line 29
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$set();
#line 29
}
#line 29
# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$clr();
#line 39
}
#line 39
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$clr();
}

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$clr(void){
#line 30
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$clr();
#line 30
}
#line 30
# 408 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   void CC2420ControlP$StartupTimer$fired(void)
#line 408
{
  if (CC2420ControlP$m_state == CC2420ControlP$S_VREG_STARTING) {
      CC2420ControlP$m_state = CC2420ControlP$S_VREG_STARTED;
      CC2420ControlP$RSTN$clr();
      CC2420ControlP$RSTN$set();
      CC2420ControlP$CC2420Power$startVRegDone();
    }
}

# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420TransmitP$SFLUSHTX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SFLUSHTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$getRaw(void)
#line 48
{
#line 48
  return * (volatile uint8_t *)32U & (0x01 << 4);
}

#line 49
static inline   bool /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$get(void)
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$getRaw() != 0;
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   bool /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$get(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$get(void)
#line 40
{
#line 40
  return /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$get();
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420TransmitP$CCA$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 475 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$BackoffTimer$fired(void)
#line 475
{
  /* atomic removed: atomic calls only */
#line 476
  {
    switch (CC2420TransmitP$m_state) {

        case CC2420TransmitP$S_SAMPLE_CCA: 


          if (CC2420TransmitP$CCA$get()) {
              CC2420TransmitP$m_state = CC2420TransmitP$S_BEGIN_TRANSMIT;
              CC2420TransmitP$BackoffTimer$start(CC2420_TIME_ACK_TURNAROUND);
            }
          else {
              CC2420TransmitP$congestionBackoff();
            }
        break;

        case CC2420TransmitP$S_BEGIN_TRANSMIT: 
          case CC2420TransmitP$S_CANCEL: 
            if (CC2420TransmitP$acquireSpiResource() == SUCCESS) {
                CC2420TransmitP$attemptSend();
              }
        break;

        case CC2420TransmitP$S_ACK_WAIT: 
          CC2420TransmitP$signalDone(SUCCESS);
        break;

        case CC2420TransmitP$S_SFD: 


          CC2420TransmitP$SFLUSHTX$strobe();
        CC2420TransmitP$CaptureSFD$captureRisingEdge();
        CC2420TransmitP$releaseSpiResource();
        CC2420TransmitP$signalDone(ERETRY);
        break;

        default: 
          break;
      }
  }
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$fired(void){
#line 67
  CC2420TransmitP$BackoffTimer$fired();
#line 67
  CC2420ControlP$StartupTimer$fired();
#line 67
}
#line 67
# 151 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$fired(void)
{
  /* atomic removed: atomic calls only */
  {
    if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt == 0) 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$fired();
      }
    else 
      {
        /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$set_alarm();
      }
  }
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$fired(void){
#line 67
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$fired();
#line 67
}
#line 67
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$fired(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$disableEvents();
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Alarm$fired();
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Compare$fired(void){
#line 34
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430Compare$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$getEvent(void)
{
  return * (volatile uint16_t *)406U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$__nesc_unnamed4395 {
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

# 284 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(message_t *msg)
#line 284
{
}

# 88 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40){
#line 88
  CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(arg_0x2ab4c49f7e40);
#line 88
}
#line 88
# 78 "/home/sdawson/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static inline   uint16_t RandomMlcgC$Random$rand16(void)
#line 78
{
  return (uint16_t )RandomMlcgC$Random$rand32();
}

# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t CC2420CsmaP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 231 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t backoffTime)
#line 231
{
  CC2420TransmitP$myCongestionBackoff = backoffTime + 1;
}

# 66 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420CsmaP$SubBackoff$setCongestionBackoff(uint16_t arg_0x2ab4c49f91e0){
#line 66
  CC2420TransmitP$RadioBackoff$setCongestionBackoff(arg_0x2ab4c49f91e0);
#line 66
}
#line 66
# 223 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *msg)
#line 223
{
  CC2420CsmaP$SubBackoff$setCongestionBackoff(CC2420CsmaP$Random$rand16()
   % (0x7 * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP$RadioBackoff$requestCongestionBackoff(msg);
}

# 88 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420TransmitP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x2ab4c49f7e40){
#line 88
  CC2420CsmaP$SubBackoff$requestCongestionBackoff(arg_0x2ab4c49f7e40);
#line 88
}
#line 88
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiP$Resource$immediateRequest(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t CC2420SpiP$WorkingState$requestState(uint8_t arg_0x2ab4c4d746f0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(0U, arg_0x2ab4c4d746f0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 111 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(uint8_t id)
#line 111
{
#line 111
  return FAIL;
}

# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(uint8_t arg_0x2ab4c4ea9840){
#line 118
  unsigned char result;
#line 118

#line 118
  switch (arg_0x2ab4c4ea9840) {
#line 118
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 118
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$isOwner(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 118
      break;
#line 118
    default:
#line 118
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$isOwner(arg_0x2ab4c4ea9840);
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
# 77 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(uint8_t id)
#line 77
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$isOwner(id);
}

# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool CC2420SpiP$SpiResource$isOwner(void){
#line 118
  unsigned char result;
#line 118

#line 118
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$isOwner(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
# 115 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(uint8_t id)
#line 115
{
  return &msp430_spi_default_config;
}

# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiConfigure.nc"
inline static   msp430_spi_union_config_t */*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(uint8_t arg_0x2ab4c4ea8a50){
#line 39
  union __nesc_unnamed4319 *result;
#line 39

#line 39
    result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$default$getConfig(arg_0x2ab4c4ea8a50);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 168 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(msp430_spi_union_config_t *arg_0x2ab4c4edc648){
#line 168
  HplMsp430Usart0P$Usart$setModeSpi(arg_0x2ab4c4edc648);
#line 168
}
#line 168
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(uint8_t id)
#line 85
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$setModeSpi(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Msp430SpiConfigure$getConfig(id));
}

# 213 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(uint8_t id)
#line 213
{
}

# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(uint8_t arg_0x2ab4c508b378){
#line 49
  switch (arg_0x2ab4c508b378) {
#line 49
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 49
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$ResourceConfigure$configure(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$default$configure(arg_0x2ab4c508b378);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 210 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$immediateRequested(void)
#line 210
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release();
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested(void){
#line 81
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$immediateRequested();
#line 81
}
#line 81
# 203 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id)
#line 203
{
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(uint8_t arg_0x2ab4c508d378){
#line 51
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$immediateRequested(arg_0x2ab4c508d378);
#line 51
}
#line 51
# 90 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(uint8_t id)
#line 90
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$immediateRequested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  /* atomic removed: atomic calls only */
#line 92
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = id;
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
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$immediateRequested();
  if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId == id) {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId);
      return SUCCESS;
    }
  /* atomic removed: atomic calls only */
#line 104
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED;
  return FAIL;
}

# 113 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(uint8_t id)
#line 113
{
#line 113
  return FAIL;
}

# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(uint8_t arg_0x2ab4c4ea9840){
#line 87
  unsigned char result;
#line 87

#line 87
  switch (arg_0x2ab4c4ea9840) {
#line 87
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 87
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$immediateRequest(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 87
      break;
#line 87
    default:
#line 87
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$immediateRequest(arg_0x2ab4c4ea9840);
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
# 69 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(uint8_t id)
#line 69
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$immediateRequest(id);
}

# 87 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420SpiP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$immediateRequest(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void HplMsp430I2C0P$HplUsart$resetUsart(bool arg_0x2ab4c4ee4e80){
#line 97
  HplMsp430Usart0P$Usart$resetUsart(arg_0x2ab4c4ee4e80);
#line 97
}
#line 97
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
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

# 7 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
inline static   void HplMsp430Usart0P$HplI2C$clearModeI2C(void){
#line 7
  HplMsp430I2C0P$HplI2C$clearModeI2C();
#line 7
}
#line 7
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 5);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$URXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P35*/HplMsp430GeneralIOP$21$IO$selectIOFunc();
#line 85
}
#line 85
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)27U &= ~(0x01 << 4);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UTXD$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P34*/HplMsp430GeneralIOP$20$IO$selectIOFunc();
#line 85
}
#line 85
# 207 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 3;
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$UCLK$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P33*/HplMsp430GeneralIOP$19$IO$selectModuleFunc();
#line 78
}
#line 78
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 2;
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SOMI$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P32*/HplMsp430GeneralIOP$18$IO$selectModuleFunc();
#line 78
}
#line 78
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc(void)
#line 54
{
  /* atomic removed: atomic calls only */
#line 54
  * (volatile uint8_t *)27U |= 0x01 << 1;
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void HplMsp430Usart0P$SIMO$selectModuleFunc(void){
#line 78
  /*HplMsp430GeneralIOC.P31*/HplMsp430GeneralIOP$17$IO$selectModuleFunc();
#line 78
}
#line 78
# 238 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP$Resource$request(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 207 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$requested(void)
#line 207
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release();
}

# 73 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceDefaultOwner.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$requested(void){
#line 73
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$default$requested();
#line 73
}
#line 73
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t id)
#line 54
{
  return /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[id] != /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY || /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail == id;
}

#line 72
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t id)
#line 72
{
  /* atomic removed: atomic calls only */
#line 73
  {
    if (!/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(id)) {
        if (/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead == /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qHead = id;
          }
        else {
#line 78
          /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ[/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail] = id;
          }
#line 79
        /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$qTail = id;
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

# 69 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$enqueue(resource_client_id_t arg_0x2ab4c5057930){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(arg_0x2ab4c5057930);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 201 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline    void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$requested(uint8_t id)
#line 201
{
}

# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$requested(uint8_t arg_0x2ab4c508d378){
#line 43
    /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$default$requested(arg_0x2ab4c508d378);
#line 43
}
#line 43
# 77 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$request(uint8_t id)
#line 77
{
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceRequested$requested(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  /* atomic removed: atomic calls only */
#line 79
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) {
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING;
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId = id;
      }
    else {
        unsigned char __nesc_temp = 
#line 84
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Queue$enqueue(id);

#line 84
        return __nesc_temp;
      }
  }
#line 86
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$requested();
  return SUCCESS;
}

# 112 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(uint8_t id)
#line 112
{
#line 112
  return FAIL;
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(uint8_t arg_0x2ab4c4ea9840){
#line 78
  unsigned char result;
#line 78

#line 78
  switch (arg_0x2ab4c4ea9840) {
#line 78
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 78
      result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$request(/*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID);
#line 78
      break;
#line 78
    default:
#line 78
      result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$default$request(arg_0x2ab4c4ea9840);
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
# 73 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(uint8_t id)
#line 73
{
  return /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$request(id);
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420SpiP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$request(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420TransmitP$STXONCCA$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_STXONCCA);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   cc2420_status_t CC2420TransmitP$STXON$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_STXON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   cc2420_status_t CC2420TransmitP$SNOP$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SNOP);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 181 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired(void)
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Compare$default$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$getEvent(void)
{
  return * (volatile uint16_t *)408U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$cc_t /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB3*/Msp430TimerCapComP$6$__nesc_unnamed4396 {
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

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Compare$default$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$getEvent(void)
{
  return * (volatile uint16_t *)410U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$cc_t /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB4*/Msp430TimerCapComP$7$__nesc_unnamed4397 {
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

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Compare$default$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$getEvent(void)
{
  return * (volatile uint16_t *)412U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$cc_t /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB5*/Msp430TimerCapComP$8$__nesc_unnamed4398 {
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

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Compare.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$fired(void){
#line 34
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Compare$default$fired();
#line 34
}
#line 34
# 139 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   uint16_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$getEvent(void)
{
  return * (volatile uint16_t *)414U;
}

#line 177
static inline    void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(uint16_t n)
{
}

# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430Capture.nc"
inline static   void /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$captured(uint16_t arg_0x2ab4c42c3690){
#line 75
  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$Capture$default$captured(arg_0x2ab4c42c3690);
#line 75
}
#line 75
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$cc_t /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$int2CC(uint16_t x)
#line 47
{
#line 47
  union /*Msp430TimerC.Msp430TimerB6*/Msp430TimerCapComP$9$__nesc_unnamed4399 {
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

# 120 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired(void)
{
  uint8_t n = * (volatile uint16_t *)286U;

#line 123
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(n >> 1);
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
inline static   void Msp430TimerCommonP$VectorTimerB1$fired(void){
#line 28
  /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$VectorTimerX1$fired();
#line 28
}
#line 28
# 113 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline  void SchedulerBasicP$Scheduler$init(void)
{
  /* atomic removed: atomic calls only */
  {
    memset((void *)SchedulerBasicP$m_next, SchedulerBasicP$NO_TASK, sizeof SchedulerBasicP$m_next);
    SchedulerBasicP$m_head = SchedulerBasicP$NO_TASK;
    SchedulerBasicP$m_tail = SchedulerBasicP$NO_TASK;
  }
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$init(void){
#line 46
  SchedulerBasicP$Scheduler$init();
#line 46
}
#line 46
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)29U |= 0x01 << 7;
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$set(void){
#line 29
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$set();
#line 29
}
#line 29
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)29U |= 0x01 << 3;
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$set(void){
#line 29
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$set();
#line 29
}
#line 29
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$set(void)
#line 45
{
  /* atomic removed: atomic calls only */
#line 45
  * (volatile uint8_t *)29U |= 0x01 << 0;
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set(void)
#line 37
{
#line 37
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$set(void){
#line 29
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$set();
#line 29
}
#line 29
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 7;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P47*/HplMsp430GeneralIOP$31$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$makeOutput(void){
#line 35
  /*PlatformLedsC.Led2Impl*/Msp430GpioC$2$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 3;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P43*/HplMsp430GeneralIOP$27$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$makeOutput(void){
#line 35
  /*PlatformLedsC.Led1Impl*/Msp430GpioC$1$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 0;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P40*/HplMsp430GeneralIOP$24$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$makeOutput(void){
#line 35
  /*PlatformLedsC.Led0Impl*/Msp430GpioC$0$GeneralIO$makeOutput();
#line 35
}
#line 35
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/LedsP.nc"
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

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
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
# 6 "/home/sdawson/cvs/tinyos-2.x/tos/platforms/epic/MotePlatformC.nc"
static inline  error_t MotePlatformC$Init$init(void)
#line 6
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





  return SUCCESS;
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
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
# 148 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
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

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerB(void){
#line 32
  Msp430ClockP$Msp430ClockInit$default$initTimerB();
#line 32
}
#line 32
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
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

# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initTimerA(void){
#line 31
  Msp430ClockP$Msp430ClockInit$default$initTimerA();
#line 31
}
#line 31
# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
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

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$initClocks(void){
#line 30
  Msp430ClockP$Msp430ClockInit$default$initClocks();
#line 30
}
#line 30
# 166 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
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

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockInit.nc"
inline static  void Msp430ClockP$Msp430ClockInit$setupDcoCalibrate(void){
#line 29
  Msp430ClockP$Msp430ClockInit$default$setupDcoCalibrate();
#line 29
}
#line 29
# 214 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
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

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
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
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/platforms/epic/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void)
#line 46
{
  PlatformP$MoteClockInit$init();
  PlatformP$MoteInit$init();
  PlatformP$LedsInit$init();
  return SUCCESS;
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
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
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
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
# 240 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_hton_uint8(void *target, uint8_t value)
#line 240
{
  uint8_t *base = target;

#line 242
  base[0] = value;
  return value;
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  IPDispatchP$SendQueue$t IPDispatchP$SendQueue$dequeue(void){
#line 81
  struct __nesc_unnamed4302 *result;
#line 81

#line 81
  result = /*IPDispatchC.QueueC*/QueueC$0$Queue$dequeue();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  error_t IPDispatchP$SendEntryPool$put(IPDispatchP$SendEntryPool$t *arg_0x2ab4c55a1060){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$put(arg_0x2ab4c55a1060);
#line 89

#line 89
  return result;
#line 89
}
#line 89
inline static  error_t IPDispatchP$FragPool$put(IPDispatchP$FragPool$t *arg_0x2ab4c55a1060){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$put(arg_0x2ab4c55a1060);
#line 89

#line 89
  return result;
#line 89
}
#line 89
inline static  error_t IPDispatchP$SendInfoPool$put(IPDispatchP$SendInfoPool$t *arg_0x2ab4c55a1060){
#line 89
  unsigned char result;
#line 89

#line 89
  result = /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$put(arg_0x2ab4c55a1060);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t IPDispatchP$sendTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(IPDispatchP$sendTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 65 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline  /*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$Queue$head(void)
#line 65
{
  return /*IPDispatchC.QueueC*/QueueC$0$queue[/*IPDispatchC.QueueC*/QueueC$0$head];
}

# 73 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  IPDispatchP$SendQueue$t IPDispatchP$SendQueue$head(void){
#line 73
  struct __nesc_unnamed4302 *result;
#line 73

#line 73
  result = /*IPDispatchC.QueueC*/QueueC$0$Queue$head();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline  bool /*IPDispatchC.QueueC*/QueueC$0$Queue$empty(void)
#line 53
{
  return /*IPDispatchC.QueueC*/QueueC$0$size == 0;
}

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  bool IPDispatchP$SendQueue$empty(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*IPDispatchC.QueueC*/QueueC$0$Queue$empty();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *CC2420MessageP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 155 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  uint8_t CC2420MessageP$Packet$payloadLength(message_t *msg)
#line 155
{
  return __nesc_ntoh_leuint8((unsigned char *)&CC2420MessageP$CC2420PacketBody$getHeader(msg)->length) - IEEE802154_SIZ;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t IPDispatchP$Packet$payloadLength(message_t *arg_0x2ab4c49b2a68){
#line 67
  unsigned char result;
#line 67

#line 67
  result = CC2420MessageP$Packet$payloadLength(arg_0x2ab4c49b2a68);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Packet.nc"
inline static  ieee154_saddr_t IPDispatchP$Ieee154Packet$destination(message_t *arg_0x2ab4c498a850){
#line 28
  unsigned int result;
#line 28

#line 28
  result = CC2420MessageP$Ieee154Packet$destination(arg_0x2ab4c498a850);
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 281 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_hton_leuint16(void *target, uint16_t value)
#line 281
{
  uint8_t *base = target;

#line 283
  base[0] = value;
  base[1] = value >> 8;
  return value;
}

#line 251
static __inline uint8_t __nesc_hton_leuint8(void *target, uint8_t value)
#line 251
{
  uint8_t *base = target;

#line 253
  base[0] = value;
  return value;
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t PacketLinkP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420CsmaP$Send$send(arg_0x2ab4c49a67a8, arg_0x2ab4c49a6a60);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static   error_t PacketLinkP$PacketAcknowledgements$requestAck(message_t *arg_0x2ab4c49c6020){
#line 48
  unsigned char result;
#line 48

#line 48
  result = CC2420PacketP$Acks$requestAck(arg_0x2ab4c49c6020);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 264 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_ntoh_uint16(const void *source)
#line 264
{
  const uint8_t *base = source;

#line 266
  return ((uint16_t )base[0] << 8) | base[1];
}

# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_metadata_t *PacketLinkP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778){
#line 47
  nx_struct cc2420_metadata_t *result;
#line 47

#line 47
  result = CC2420PacketP$CC2420PacketBody$getMetadata(arg_0x2ab4c4a1c778);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 104 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  uint16_t PacketLinkP$PacketLink$getRetries(message_t *msg)
#line 104
{
  return __nesc_ntoh_uint16((unsigned char *)&PacketLinkP$CC2420PacketBody$getMetadata(msg)->maxRetries);
}

# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t PacketLinkP$SendState$requestState(uint8_t arg_0x2ab4c4d746f0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(3U, arg_0x2ab4c4d746f0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 130 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  error_t PacketLinkP$Send$send(message_t *msg, uint8_t len)
#line 130
{
  error_t error;

#line 132
  if (PacketLinkP$SendState$requestState(PacketLinkP$S_SENDING) == SUCCESS) {

      PacketLinkP$currentSendMsg = msg;
      PacketLinkP$currentSendLen = len;
      PacketLinkP$totalRetries = 0;

      if (PacketLinkP$PacketLink$getRetries(msg) > 0) {
          PacketLinkP$PacketAcknowledgements$requestAck(msg);
        }

      if ((error = PacketLinkP$SubSend$send(msg, len)) != SUCCESS) {
          PacketLinkP$SendState$toIdle();
        }

      return error;
    }
  return EBUSY;
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t UniqueSendP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60){
#line 64
  unsigned char result;
#line 64

#line 64
  result = PacketLinkP$Send$send(arg_0x2ab4c49a67a8, arg_0x2ab4c49a6a60);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *UniqueSendP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t UniqueSendP$State$requestState(uint8_t arg_0x2ab4c4d746f0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(1U, arg_0x2ab4c4d746f0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline  error_t UniqueSendP$Send$send(message_t *msg, uint8_t len)
#line 75
{
  error_t error;

#line 77
  if (UniqueSendP$State$requestState(UniqueSendP$S_SENDING) == SUCCESS) {
      __nesc_hton_leuint8((unsigned char *)&UniqueSendP$CC2420PacketBody$getHeader(msg)->dsn, UniqueSendP$localSendId++);

      if ((error = UniqueSendP$SubSend$send(msg, len)) != SUCCESS) {
          UniqueSendP$State$toIdle();
        }

      return error;
    }

  return EBUSY;
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t CC2420TinyosNetworkP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60){
#line 64
  unsigned char result;
#line 64

#line 64
  result = UniqueSendP$Send$send(arg_0x2ab4c49a67a8, arg_0x2ab4c49a6a60);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *CC2420TinyosNetworkP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 80 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline  error_t CC2420TinyosNetworkP$NonTinyosSend$send(message_t *msg, uint8_t len)
#line 80
{


  if (__nesc_ntoh_leuint8((unsigned char *)&CC2420TinyosNetworkP$CC2420PacketBody$getHeader(msg)->network) == 0x3f) {
    return FAIL;
    }
#line 85
  return CC2420TinyosNetworkP$SubSend$send(msg, len);
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t CC2420MessageP$SubSend$send(message_t *arg_0x2ab4c49a67a8, uint8_t arg_0x2ab4c49a6a60){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420TinyosNetworkP$NonTinyosSend$send(arg_0x2ab4c49a67a8, arg_0x2ab4c49a6a60);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   uint16_t CC2420MessageP$CC2420Config$getShortAddr(void){
#line 64
  unsigned int result;
#line 64

#line 64
  result = CC2420ControlP$CC2420Config$getShortAddr();
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 287 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   uint16_t CC2420ControlP$CC2420Config$getPanAddr(void)
#line 287
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 288
    {
      unsigned int __nesc_temp = 
#line 288
      CC2420ControlP$m_pan;

      {
#line 288
        __nesc_atomic_end(__nesc_atomic); 
#line 288
        return __nesc_temp;
      }
    }
#line 290
    __nesc_atomic_end(__nesc_atomic); }
}

# 70 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   uint16_t CC2420MessageP$CC2420Config$getPanAddr(void){
#line 70
  unsigned int result;
#line 70

#line 70
  result = CC2420ControlP$CC2420Config$getPanAddr();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 82 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  error_t CC2420MessageP$Ieee154Send$send(ieee154_saddr_t addr, 
message_t *msg, 
uint8_t len)
#line 84
{
  cc2420_header_t *header = CC2420MessageP$CC2420PacketBody$getHeader(msg);

#line 86
  __nesc_hton_leuint16((unsigned char *)&header->dest, addr);
  __nesc_hton_leuint16((unsigned char *)&header->destpan, CC2420MessageP$CC2420Config$getPanAddr());
  __nesc_hton_leuint16((unsigned char *)&header->src, CC2420MessageP$CC2420Config$getShortAddr());

  return CC2420MessageP$SubSend$send(msg, len - sizeof(am_header_t ));
}

# 56 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
inline static  error_t IPDispatchP$Ieee154Send$send(ieee154_saddr_t arg_0x2ab4c499d020, message_t *arg_0x2ab4c499d318, uint8_t arg_0x2ab4c499d5d0){
#line 56
  unsigned char result;
#line 56

#line 56
  result = CC2420MessageP$Ieee154Send$send(arg_0x2ab4c499d020, arg_0x2ab4c499d318, arg_0x2ab4c499d5d0);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 269 "/usr/local/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value)
#line 269
{
  uint8_t *base = target;

#line 271
  base[1] = value;
  base[0] = value >> 8;
  return value;
}

# 97 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  void PacketLinkP$PacketLink$setRetryDelay(message_t *msg, uint16_t retryDelay)
#line 97
{
  __nesc_hton_uint16((unsigned char *)&PacketLinkP$CC2420PacketBody$getMetadata(msg)->retryDelay, retryDelay);
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static  void IPDispatchP$PacketLink$setRetryDelay(message_t *arg_0x2ab4c4a049a0, uint16_t arg_0x2ab4c4a04c68){
#line 53
  PacketLinkP$PacketLink$setRetryDelay(arg_0x2ab4c4a049a0, arg_0x2ab4c4a04c68);
#line 53
}
#line 53
# 88 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  void PacketLinkP$PacketLink$setRetries(message_t *msg, uint16_t maxRetries)
#line 88
{
  __nesc_hton_uint16((unsigned char *)&PacketLinkP$CC2420PacketBody$getMetadata(msg)->maxRetries, maxRetries);
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static  void IPDispatchP$PacketLink$setRetries(message_t *arg_0x2ab4c4a05cf8, uint16_t arg_0x2ab4c4a04020){
#line 46
  PacketLinkP$PacketLink$setRetries(arg_0x2ab4c4a05cf8, arg_0x2ab4c4a04020);
#line 46
}
#line 46
# 120 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  void CC2420MessageP$Ieee154Packet$setDestination(message_t *msg, ieee154_saddr_t addr)
#line 120
{
  cc2420_header_t *header = CC2420MessageP$CC2420PacketBody$getHeader(msg);

#line 122
  __nesc_hton_leuint16((unsigned char *)&header->dest, addr);
}

# 32 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Packet.nc"
inline static  void IPDispatchP$Ieee154Packet$setDestination(message_t *arg_0x2ab4c4988968, ieee154_saddr_t arg_0x2ab4c4988c28){
#line 32
  CC2420MessageP$Ieee154Packet$setDestination(arg_0x2ab4c4988968, arg_0x2ab4c4988c28);
#line 32
}
#line 32
# 887 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$sendTask$runTask(void)
#line 887
{
  unsigned char __nesc_temp62;
  unsigned char *__nesc_temp61;
#line 888
  send_entry_t *s_entry;

#line 889
  if (IPDispatchP$radioBusy || IPDispatchP$state != IPDispatchP$S_RUNNING) {
#line 889
    return;
    }
#line 890
  if (IPDispatchP$SendQueue$empty()) {
#line 890
    return;
    }
  s_entry = IPDispatchP$SendQueue$head();


  IPDispatchP$Ieee154Packet$setDestination(s_entry->msg, 
  s_entry->info->policy.dest[s_entry->info->policy.current]);
  IPDispatchP$PacketLink$setRetries(s_entry->msg, s_entry->info->policy.retries);
  IPDispatchP$PacketLink$setRetryDelay(s_entry->msg, s_entry->info->policy.delay);




  ;


  if (s_entry->info->failed) {
      ;
      goto fail;
    }



  if (
#line 911
  IPDispatchP$Ieee154Send$send(IPDispatchP$Ieee154Packet$destination(s_entry->msg), 
  s_entry->msg, 
  IPDispatchP$Packet$payloadLength(s_entry->msg)) != SUCCESS) {
      ;
      goto fail;
    }
  IPDispatchP$radioBusy = TRUE;
  if (IPDispatchP$SendQueue$empty()) {
#line 918
    return;
    }
  s_entry = IPDispatchP$SendQueue$head();

  return;
  fail: 
    IPDispatchP$sendTask$postTask();
  (__nesc_temp61 = (unsigned char *)&IPDispatchP$stats.tx_drop, __nesc_hton_uint8(__nesc_temp61, (__nesc_temp62 = __nesc_ntoh_uint8(__nesc_temp61)) + 1), __nesc_temp62);



  s_entry->info->failed = TRUE;
  if (-- s_entry->info->refcount == 0) {
#line 930
    IPDispatchP$SendInfoPool$put(s_entry->info);
    }
#line 931
  IPDispatchP$FragPool$put(s_entry->msg);
  IPDispatchP$SendEntryPool$put(s_entry);
  IPDispatchP$SendQueue$dequeue();
}

# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *CC2420CsmaP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42





inline static   cc2420_metadata_t *CC2420CsmaP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778){
#line 47
  nx_struct cc2420_metadata_t *result;
#line 47

#line 47
  result = CC2420PacketP$CC2420PacketBody$getMetadata(arg_0x2ab4c4a1c778);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 287 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestCca(message_t *msg)
#line 287
{
}

# 95 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestCca(message_t *arg_0x2ab4c49f6818){
#line 95
  CC2420CsmaP$RadioBackoff$default$requestCca(arg_0x2ab4c49f6818);
#line 95
}
#line 95
# 524 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca)
#line 524
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 525
    {
      if (CC2420TransmitP$m_state == CC2420TransmitP$S_CANCEL) {
          {
            unsigned char __nesc_temp = 
#line 527
            ECANCEL;

            {
#line 527
              __nesc_atomic_end(__nesc_atomic); 
#line 527
              return __nesc_temp;
            }
          }
        }
#line 530
      if (CC2420TransmitP$m_state != CC2420TransmitP$S_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 531
            FAIL;

            {
#line 531
              __nesc_atomic_end(__nesc_atomic); 
#line 531
              return __nesc_temp;
            }
          }
        }
#line 534
      CC2420TransmitP$m_state = CC2420TransmitP$S_LOAD;
      CC2420TransmitP$m_cca = cca;
      CC2420TransmitP$m_msg = p_msg;
      CC2420TransmitP$totalCcaChecks = 0;
    }
#line 538
    __nesc_atomic_end(__nesc_atomic); }

  if (CC2420TransmitP$acquireSpiResource() == SUCCESS) {
      CC2420TransmitP$loadTXFIFO();
    }

  return SUCCESS;
}

#line 172
static inline   error_t CC2420TransmitP$Send$send(message_t *p_msg, bool useCca)
#line 172
{
  return CC2420TransmitP$send(p_msg, useCca);
}

# 51 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
inline static   error_t CC2420CsmaP$CC2420Transmit$send(message_t *arg_0x2ab4c53684d0, bool arg_0x2ab4c5368788){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420TransmitP$Send$send(arg_0x2ab4c53684d0, arg_0x2ab4c5368788);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static   cc2420_status_t CC2420TransmitP$TXCTRL$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_TXCTRL, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   error_t CC2420SpiP$SpiPacket$send(uint8_t *arg_0x2ab4c4d7c7d0, uint8_t *arg_0x2ab4c4d7cac0, uint16_t arg_0x2ab4c4d7cd80){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID, arg_0x2ab4c4d7c7d0, arg_0x2ab4c4d7cac0, arg_0x2ab4c4d7cd80);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 34 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiByte.nc"
inline static   uint8_t CC2420SpiP$SpiByte$write(uint8_t arg_0x2ab4c4d843d8){
#line 34
  unsigned char result;
#line 34

#line 34
  result = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(arg_0x2ab4c4d843d8);
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 126 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline   bool StateImplP$State$isIdle(uint8_t id)
#line 126
{
  return StateImplP$State$isState(id, StateImplP$S_IDLE);
}

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool CC2420SpiP$WorkingState$isIdle(void){
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
# 214 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   cc2420_status_t CC2420SpiP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 215
{

  uint8_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 219
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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
  CC2420SpiP$m_addr = addr;

  status = CC2420SpiP$SpiByte$write(CC2420SpiP$m_addr);
  CC2420SpiP$SpiPacket$send(data, (void *)0, len);

  return status;
}

# 82 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static   cc2420_status_t CC2420TransmitP$TXFIFO$write(uint8_t *arg_0x2ab4c4d64418, uint8_t arg_0x2ab4c4d646d0){
#line 82
  unsigned char result;
#line 82

#line 82
  result = CC2420SpiP$Fifo$write(CC2420_TXFIFO, arg_0x2ab4c4d64418, arg_0x2ab4c4d646d0);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 361 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 180 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$enableRxIntr(void){
#line 180
  HplMsp430Usart0P$Usart$enableRxIntr();
#line 180
}
#line 180
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 69 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline void /*IPDispatchC.QueueC*/QueueC$0$printQueue(void)
#line 69
{
}

# 257 "/usr/local/lib/ncc/nesc_nx.h"
static __inline int8_t __nesc_hton_int8(void *target, int8_t value)
#line 257
{
#line 257
  __nesc_hton_uint8(target, value);
#line 257
  return value;
}

# 90 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  error_t IPDispatchP$SendQueue$enqueue(IPDispatchP$SendQueue$t arg_0x2ab4c558f698){
#line 90
  unsigned char result;
#line 90

#line 90
  result = /*IPDispatchC.QueueC*/QueueC$0$Queue$enqueue(arg_0x2ab4c558f698);
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  IPDispatchP$SendEntryPool$t *IPDispatchP$SendEntryPool$get(void){
#line 97
  struct __nesc_unnamed4302 *result;
#line 97

#line 97
  result = /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
inline static  IPDispatchP$FragPool$t *IPDispatchP$FragPool$get(void){
#line 97
  nx_struct message_t *result;
#line 97

#line 97
  result = /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 147 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$TGenSend$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta)
#line 149
{
}

# 1139 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline   void IPDispatchP$IP$default$recv(uint8_t nxt_hdr, struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta)
#line 1141
{
}

# 21 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
inline static  void IPDispatchP$IP$recv(uint8_t arg_0x2ab4c55b3888, struct ip6_hdr *arg_0x2ab4c497fb28, void *arg_0x2ab4c497fe10, struct ip_metadata *arg_0x2ab4c497d1a0){
#line 21
  switch (arg_0x2ab4c55b3888) {
#line 21
    case IANA_UDP:
#line 21
      UdpP$IP$recv(arg_0x2ab4c497fb28, arg_0x2ab4c497fe10, arg_0x2ab4c497d1a0);
#line 21
      break;
#line 21
    case IANA_ICMP:
#line 21
      ICMPResponderP$IP$recv(arg_0x2ab4c497fb28, arg_0x2ab4c497fe10, arg_0x2ab4c497d1a0);
#line 21
      break;
#line 21
    case NXTHDR_UNKNOWN:
#line 21
      IPRoutingP$TGenSend$recv(arg_0x2ab4c497fb28, arg_0x2ab4c497fe10, arg_0x2ab4c497d1a0);
#line 21
      break;
#line 21
    default:
#line 21
      IPDispatchP$IP$default$recv(arg_0x2ab4c55b3888, arg_0x2ab4c497fb28, arg_0x2ab4c497fe10, arg_0x2ab4c497d1a0);
#line 21
      break;
#line 21
    }
#line 21
}
#line 21
# 292 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP$signalDone(reconstruct_t *recon)
#line 292
{
  struct ip6_hdr *iph = (struct ip6_hdr *)recon->buf;

#line 294
  IPDispatchP$IP$recv(recon->nxt_hdr, iph, recon->transport_hdr, & recon->metadata);
  ip_free(recon->buf);
  recon->timeout = T_UNUSED;
  recon->buf = (void *)0;
}

#line 208
static inline int IPDispatchP$forward_lookup(void *ent)
#line 208
{
  forward_entry_t *fwd = (forward_entry_t *)ent;

  if (
#line 210
  fwd->timeout > T_UNUSED && 
  fwd->l2_src == IPDispatchP$forward_lookup_src && 
  fwd->old_tag == IPDispatchP$forward_lookup_tag) {
      fwd->timeout = T_ACTIVE;
      return 1;
    }
  return 0;
}

# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Packet.nc"
inline static  ieee154_saddr_t IPDispatchP$Ieee154Packet$source(message_t *arg_0x2ab4c4988100){
#line 30
  unsigned int result;
#line 30

#line 30
  result = CC2420MessageP$Ieee154Packet$source(arg_0x2ab4c4988100);
#line 30

#line 30
  return result;
#line 30
}
#line 30
# 199 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline int IPDispatchP$forward_unused(void *ent)
#line 199
{
  forward_entry_t *fwd = (forward_entry_t *)ent;

#line 201
  if (fwd->timeout == T_UNUSED) {
    return 1;
    }
#line 203
  return 0;
}

# 48 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  error_t IPDispatchP$IPRouting$getNextHop(struct ip6_hdr *arg_0x2ab4c55e42a0, struct source_header *arg_0x2ab4c55e4618, ieee154_saddr_t arg_0x2ab4c55e4900, send_policy_t *arg_0x2ab4c55e4c18){
#line 48
  unsigned char result;
#line 48

#line 48
  result = IPRoutingP$IPRouting$getNextHop(arg_0x2ab4c55e42a0, arg_0x2ab4c55e4618, arg_0x2ab4c55e4900, arg_0x2ab4c55e4c18);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 40 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
static inline  ieee154_saddr_t IPAddressP$IPAddress$getShortAddr(void)
#line 40
{
  return TOS_NODE_ID;
}

# 25 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  ieee154_saddr_t IPDispatchP$IPAddress$getShortAddr(void){
#line 25
  unsigned int result;
#line 25

#line 25
  result = IPAddressP$IPAddress$getShortAddr();
#line 25

#line 25
  return result;
#line 25
}
#line 25
# 423 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP$updateSourceRoute(ieee154_saddr_t prev_hop, struct source_header *sh)
#line 423
{
  uint16_t my_address = IPDispatchP$IPAddress$getShortAddr();

#line 425
  if ((sh->dispatch & IP_EXT_SOURCE_INVAL) == IP_EXT_SOURCE_INVAL) {
#line 425
    return;
    }
#line 426
  if ((sh->dispatch & IP_EXT_SOURCE_RECORD) != IP_EXT_SOURCE_RECORD && (((
  (uint16_t )sh->hops[sh->current] >> 8) | ((uint16_t )sh->hops[sh->current] << 8)) & 0xffff) != my_address) {
      sh->dispatch |= IP_EXT_SOURCE_INVAL;
      ;
      return;
    }
  if (sh->current == (sh->len - sizeof(struct source_header )) / sizeof(uint16_t )) {
#line 432
    return;
    }
#line 433
  sh->hops[sh->current] = (((uint16_t )prev_hop << 8) | ((uint16_t )prev_hop >> 8)) & 0xffff;
  sh->current++;
}

# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
inline static  error_t ICMPResponderP$IP$send(struct split_ip_msg *arg_0x2ab4c497f270){
#line 15
  unsigned char result;
#line 15

#line 15
  result = IPDispatchP$IP$send(IANA_ICMP, arg_0x2ab4c497f270);
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 65 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  uint16_t ICMPResponderP$ICMP$cksum(struct split_ip_msg *msg, uint8_t nxt_hdr)
#line 65
{
  return msg_cksum(msg, nxt_hdr);
}

# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  void ICMPResponderP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8){
#line 30
  IPAddressP$IPAddress$getIPAddr(arg_0x2ab4c49518e8);
#line 30
}
#line 30
# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  void ICMPResponderP$ICMP$sendTimeExceeded(struct ip6_hdr *hdr, unpack_info_t *u_info, uint16_t amount_here)
#line 86
{
  uint8_t i_hdr_buf[sizeof(struct icmp6_hdr ) + 4];
  struct split_ip_msg *msg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ));
  struct generic_header g_hdr[3];
  struct icmp6_hdr *i_hdr = (struct icmp6_hdr *)i_hdr_buf;

  if (msg == (void *)0) {
#line 92
    return;
    }
  ;

  msg->headers = (void *)0;
  msg->data = u_info->payload_start;
  msg->data_len = amount_here;


  if (u_info->nxt_hdr == IANA_UDP) {
      g_hdr[2].hdr.udp = (struct udp_hdr *)u_info->transport_ptr;
      g_hdr[2].len = sizeof(struct udp_hdr );
      g_hdr[2].next = (void *)0;




      hdr->plen = (((uint16_t )(((((uint16_t )hdr->plen >> 8) | ((uint16_t )hdr->plen << 8)) & 0xffff) + sizeof(struct udp_hdr )) << 8) | ((uint16_t )(((((uint16_t )hdr->plen >> 8) | ((uint16_t )hdr->plen << 8)) & 0xffff) + sizeof(struct udp_hdr )) >> 8)) & 0xffff;
      msg->headers = &g_hdr[2];
    }



  hdr->nxt_hdr = u_info->nxt_hdr;
  hdr->plen = (((uint16_t )(((((uint16_t )hdr->plen >> 8) | ((uint16_t )hdr->plen << 8)) & 0xffff) - u_info->payload_offset) << 8) | ((uint16_t )(((((uint16_t )hdr->plen >> 8) | ((uint16_t )hdr->plen << 8)) & 0xffff) - u_info->payload_offset) >> 8)) & 0xffff;


  g_hdr[1].hdr.data = (void *)hdr;
  g_hdr[1].len = sizeof(struct ip6_hdr );
  g_hdr[1].next = msg->headers;
  msg->headers = &g_hdr[1];


  g_hdr[0].hdr.data = (void *)i_hdr;
  g_hdr[0].len = sizeof(struct icmp6_hdr ) + 4;
  g_hdr[0].next = msg->headers;
  msg->headers = &g_hdr[0];

  ip_memcpy(& msg->hdr.ip6_dst, & hdr->ip6_src, 16);
  ICMPResponderP$IPAddress$getIPAddr(& msg->hdr.ip6_src);

  i_hdr->type = ICMP_TYPE_ECHO_TIME_EXCEEDED;
  i_hdr->code = ICMP_CODE_HOPLIMIT_EXCEEDED;
  i_hdr->cksum = 0;
  ip_memclr((void *)(i_hdr + 1), 4);

  msg->hdr.nxt_hdr = IANA_ICMP;

  i_hdr->cksum = (((uint16_t )ICMPResponderP$ICMP$cksum(msg, IANA_ICMP) << 8) | ((uint16_t )ICMPResponderP$ICMP$cksum(msg, IANA_ICMP) >> 8)) & 0xffff;

  ICMPResponderP$IP$send(msg);

  ip_free(msg);
}

# 35 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
inline static  void IPDispatchP$ICMP$sendTimeExceeded(struct ip6_hdr *arg_0x2ab4c55d46f8, unpack_info_t *arg_0x2ab4c55d49f0, uint16_t arg_0x2ab4c55d4cb8){
#line 35
  ICMPResponderP$ICMP$sendTimeExceeded(arg_0x2ab4c55d46f8, arg_0x2ab4c55d49f0, arg_0x2ab4c55d4cb8);
#line 35
}
#line 35
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/system/NoLedsC.nc"
static inline   void NoLedsC$Leds$led1Toggle(void)
#line 48
{
}

# 72 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void IPDispatchP$Leds$led1Toggle(void){
#line 72
  NoLedsC$Leds$led1Toggle();
#line 72
}
#line 72
# 93 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   uint8_t CC2420PacketP$CC2420Packet$getLqi(message_t *p_msg)
#line 93
{
  return __nesc_ntoh_uint8((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(p_msg)->lqi);
}

# 72 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Packet.nc"
inline static   uint8_t IPDispatchP$CC2420Packet$getLqi(message_t *arg_0x2ab4c49ce838){
#line 72
  unsigned char result;
#line 72

#line 72
  result = CC2420PacketP$CC2420Packet$getLqi(arg_0x2ab4c49ce838);
#line 72

#line 72
  return result;
#line 72
}
#line 72
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  struct in6_addr *IPRoutingP$IPAddress$getPublicAddr(void){
#line 28
  struct in6_addr *result;
#line 28

#line 28
  result = IPAddressP$IPAddress$getPublicAddr();
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 185 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  bool IPRoutingP$IPRouting$isForMe(struct ip6_hdr *hdr)
#line 185
{



  struct in6_addr *my_address = IPRoutingP$IPAddress$getPublicAddr();

#line 190
  return ((cmpPfx(my_address->in6_u.u6_addr8, hdr->ip6_dst.in6_u.u6_addr8) || 
  cmpPfx(linklocal_prefix, hdr->ip6_dst.in6_u.u6_addr8))
   && cmpPfx(&my_address->in6_u.u6_addr8[8], &hdr->ip6_dst.in6_u.u6_addr8[8]))
   || cmpPfx(multicast_prefix, hdr->ip6_dst.in6_u.u6_addr8);
}

# 40 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  bool IPDispatchP$IPRouting$isForMe(struct ip6_hdr *arg_0x2ab4c55e59a0){
#line 40
  unsigned char result;
#line 40

#line 40
  result = IPRoutingP$IPRouting$isForMe(arg_0x2ab4c55e59a0);
#line 40

#line 40
  return result;
#line 40
}
#line 40
# 562 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline message_t *IPDispatchP$handle1stFrag(message_t *msg, packed_lowmsg_t *lowmsg)
#line 562
{
  unsigned char __nesc_temp52;
  unsigned char *__nesc_temp51;
#line 563
  uint8_t *unpack_buf;
  struct ip6_hdr *ip;

  uint16_t real_payload_length;

  unpack_info_t u_info;

  unpack_buf = ip_malloc(LIB6LOWPAN_MAX_LEN + LOWPAN_LINK_MTU);
  if (unpack_buf == (void *)0) {
#line 571
    return msg;
    }



  ip_memclr(unpack_buf, LIB6LOWPAN_MAX_LEN + LOWPAN_LINK_MTU);

  if (
#line 577
  unpackHeaders(lowmsg, &u_info, 
  unpack_buf, LIB6LOWPAN_MAX_LEN) == (void *)0) {
      ip_free(unpack_buf);
      return msg;
    }

  ip = (struct ip6_hdr *)unpack_buf;








  if (IPDispatchP$IPRouting$isForMe(ip)) {
      struct ip_metadata metadata;

#line 594
      ;





      metadata.sender = IPDispatchP$Ieee154Packet$source(msg);
      metadata.lqi = IPDispatchP$CC2420Packet$getLqi(msg);

      real_payload_length = (((uint16_t )ip->plen >> 8) | ((uint16_t )ip->plen << 8)) & 0xffff;
      ip->plen = (((uint16_t )(((((uint16_t )ip->plen >> 8) | ((uint16_t )ip->plen << 8)) & 0xffff) - u_info.payload_offset) << 8) | ((uint16_t )(((((uint16_t )ip->plen >> 8) | ((uint16_t )ip->plen << 8)) & 0xffff) - u_info.payload_offset) >> 8)) & 0xffff;
      switch (u_info.nxt_hdr) {
          case IANA_UDP: 
            ip->plen = (((uint16_t )(((((uint16_t )ip->plen >> 8) | ((uint16_t )ip->plen << 8)) & 0xffff) + sizeof(struct udp_hdr )) << 8) | ((uint16_t )(((((uint16_t )ip->plen >> 8) | ((uint16_t )ip->plen << 8)) & 0xffff) + sizeof(struct udp_hdr )) >> 8)) & 0xffff;
        }

      if (!hasFrag1Header(lowmsg)) {
          uint16_t amount_here = lowmsg->len - (u_info.payload_start - lowmsg->data);







          ip_memcpy(u_info.header_end, u_info.payload_start, amount_here);
          IPDispatchP$IP$recv(u_info.nxt_hdr, ip, u_info.transport_ptr, &metadata);
        }
      else 
#line 621
        {



          reconstruct_t *recon;
          uint16_t tag;
#line 626
          uint16_t amount_here = lowmsg->len - (u_info.payload_start - lowmsg->data);
          void *rcv_buf;

          if (getFragDgramTag(lowmsg, &tag)) {
#line 629
            goto fail;
            }
          ;
          recon = IPDispatchP$get_reconstruct(lowmsg->src, tag);


          if (recon == (void *)0) {
              goto fail;
            }


          rcv_buf = ip_malloc(real_payload_length + sizeof(struct ip6_hdr ));

          recon->metadata.sender = lowmsg->src;
          recon->tag = tag;
          recon->size = real_payload_length + sizeof(struct ip6_hdr );
          recon->buf = rcv_buf;
          recon->nxt_hdr = u_info.nxt_hdr;
          recon->transport_hdr = (uint8_t *)rcv_buf + (u_info.transport_ptr - unpack_buf);
          recon->bytes_rcvd = u_info.payload_offset + amount_here + sizeof(struct ip6_hdr );
          recon->timeout = T_ACTIVE;

          if (rcv_buf == (void *)0) {

              recon->timeout = T_FAILED1;
              recon->size = 0;
              goto fail;
            }
          if (amount_here > recon->size - sizeof(struct ip6_hdr )) {
              IPDispatchP$Leds$led1Toggle();
              recon->timeout = T_FAILED1;
              recon->size = 0;
              ip_free(rcv_buf);
              recon->buf = (void *)0;
              goto fail;
            }

          ip_memcpy(rcv_buf, unpack_buf, u_info.payload_offset + sizeof(struct ip6_hdr ));
          ip_memcpy(rcv_buf + u_info.payload_offset + sizeof(struct ip6_hdr ), 
          u_info.payload_start, amount_here);
          ip_memcpy(& recon->metadata, &metadata, sizeof(struct ip_metadata ));

          goto done;
        }
    }
  else {


      send_info_t *s_info;
      send_entry_t *s_entry;
      forward_entry_t *fwd;
      message_t *msg_replacement;

      * u_info.hlim = * u_info.hlim - 1;
      if (* u_info.hlim == 0) {
          uint16_t amount_here = lowmsg->len - (u_info.payload_start - lowmsg->data);

#line 685
          IPDispatchP$ICMP$sendTimeExceeded(ip, &u_info, amount_here);




          ip_free(unpack_buf);
          return msg;
        }
      s_info = IPDispatchP$getSendInfo();
      s_entry = IPDispatchP$SendEntryPool$get();
      msg_replacement = IPDispatchP$FragPool$get();
      if ((s_info == (void *)0 || s_entry == (void *)0) || msg_replacement == (void *)0) {
          if (s_info != (void *)0) {
            if (-- s_info->refcount == 0) {
#line 698
              IPDispatchP$SendInfoPool$put(s_info);
              }
            }
#line 699
          if (s_entry != (void *)0) {
            IPDispatchP$SendEntryPool$put(s_entry);
            }
#line 701
          if (msg_replacement != (void *)0) {
            IPDispatchP$FragPool$put(msg_replacement);
            }
#line 703
          goto fail;
        }

      if (ip->nxt_hdr == NXTHDR_SOURCE) {


          IPDispatchP$updateSourceRoute(IPDispatchP$Ieee154Packet$source(msg), 
          u_info.sh);
        }

      if (IPDispatchP$IPRouting$getNextHop(ip, u_info.sh, lowmsg->src, & s_info->policy) != SUCCESS) {
        goto fwd_fail;
        }
      ;

      if (hasFrag1Header(lowmsg)) {
          fwd = IPDispatchP$table_search(&IPDispatchP$forward_cache, IPDispatchP$forward_unused);
          if (fwd == (void *)0) {
              goto fwd_fail;
            }

          fwd->timeout = T_ACTIVE;
          fwd->l2_src = IPDispatchP$Ieee154Packet$source(msg);
          getFragDgramTag(lowmsg, & fwd->old_tag);
          fwd->new_tag = ++lib6lowpan_frag_tag;

          s_info->refcount++;
          fwd->s_info = s_info;
          setFragDgramTag(lowmsg, lib6lowpan_frag_tag);
        }


      s_info->refcount++;
      s_entry->msg = msg;
      s_entry->info = s_info;

      if (IPDispatchP$SendQueue$enqueue(s_entry) != SUCCESS) {
        (__nesc_temp51 = (unsigned char *)&IPDispatchP$stats.encfail, __nesc_hton_uint8(__nesc_temp51, (__nesc_temp52 = __nesc_ntoh_uint8(__nesc_temp51)) + 1), __nesc_temp52);
        }
#line 741
      IPDispatchP$sendTask$postTask();


      if (-- s_info->refcount == 0) {
#line 744
        IPDispatchP$SendInfoPool$put(s_info);
        }
#line 745
      ip_free(unpack_buf);
      return msg_replacement;

      fwd_fail: 
        IPDispatchP$FragPool$put(msg_replacement);
      IPDispatchP$SendInfoPool$put(s_info);
      IPDispatchP$SendEntryPool$put(s_entry);
    }



  fail: 
    done: 
      ip_free(unpack_buf);
  return msg;
}

# 953 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$IPRouting$reportReception(ieee154_saddr_t neigh, uint8_t lqi)
#line 953
{
  struct neigh_entry *e = IPRoutingP$getNeighEntry(neigh);

#line 955
  ;

  if (e != (void *)0) {
      e->linkEstimate = IPRoutingP$adjustLQI(lqi);
    }
}

# 74 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  void IPDispatchP$IPRouting$reportReception(ieee154_saddr_t arg_0x2ab4c55e0210, uint8_t arg_0x2ab4c55e04c8){
#line 74
  IPRoutingP$IPRouting$reportReception(arg_0x2ab4c55e0210, arg_0x2ab4c55e04c8);
#line 74
}
#line 74
# 762 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  message_t *IPDispatchP$Ieee154Receive$receive(message_t *msg, void *msg_payload, uint8_t len)
#line 762
{
  unsigned char __nesc_temp60;
  unsigned char *__nesc_temp59;
  unsigned char __nesc_temp58;
  unsigned char *__nesc_temp57;
  unsigned char __nesc_temp56;
  unsigned char *__nesc_temp55;
  unsigned char __nesc_temp54;
  unsigned char *__nesc_temp53;
#line 763
  packed_lowmsg_t lowmsg;

#line 764
  if (0) {
#line 764
    return msg;
    }

  lowmsg.data = msg_payload;
  lowmsg.len = len;
  lowmsg.src = IPDispatchP$Ieee154Packet$source(msg);
  lowmsg.dst = IPDispatchP$Ieee154Packet$destination(msg);

  (__nesc_temp53 = (unsigned char *)&IPDispatchP$stats.rx_total, __nesc_hton_uint8(__nesc_temp53, (__nesc_temp54 = __nesc_ntoh_uint8(__nesc_temp53)) + 1), __nesc_temp54);

  IPDispatchP$IPRouting$reportReception(IPDispatchP$Ieee154Packet$source(msg), 
  IPDispatchP$CC2420Packet$getLqi(msg));

  lowmsg.headers = getHeaderBitmap(&lowmsg);
  if (lowmsg.headers == LOWPAN_NALP_PATTERN) {
      goto fail;
    }


  if (!hasFragNHeader(&lowmsg)) {


      msg = IPDispatchP$handle1stFrag(msg, &lowmsg);
      goto done;
    }
  else 
#line 788
    {


      forward_entry_t *fwd;
      reconstruct_t *recon;
      uint8_t offset_cmpr;
      uint16_t offset;
#line 794
      uint16_t amount_here;
#line 794
      uint16_t tag;
      uint8_t *payload;

      if (getFragDgramTag(&lowmsg, &tag)) {
#line 797
        goto fail;
        }
#line 798
      if (getFragDgramOffset(&lowmsg, &offset_cmpr)) {
#line 798
        goto fail;
        }
      IPDispatchP$forward_lookup_tag = tag;
      IPDispatchP$forward_lookup_src = IPDispatchP$Ieee154Packet$source(msg);

      fwd = IPDispatchP$table_search(&IPDispatchP$forward_cache, IPDispatchP$forward_lookup);
      payload = getLowpanPayload(&lowmsg);

      recon = IPDispatchP$get_reconstruct(lowmsg.src, tag);
      if (recon != (void *)0 && recon->timeout > T_UNUSED && recon->buf != (void *)0) {


          offset = offset_cmpr * 8;
          amount_here = lowmsg.len - (payload - lowmsg.data);

          if (offset + amount_here > recon->size) {
#line 813
            goto fail;
            }
#line 814
          ip_memcpy(recon->buf + offset, payload, amount_here);

          recon->bytes_rcvd += amount_here;

          if (recon->size == recon->bytes_rcvd) {

              IPDispatchP$signalDone(recon);
            }
        }
      else {
#line 822
        if (fwd != (void *)0 && fwd->timeout > T_UNUSED) {


            message_t *replacement = IPDispatchP$FragPool$get();
            send_entry_t *s_entry = IPDispatchP$SendEntryPool$get();
            uint16_t lowpan_size;
            uint8_t lowpan_offset;

            if (replacement == (void *)0 || s_entry == (void *)0) {


                if (replacement != (void *)0) {
                  IPDispatchP$FragPool$put(replacement);
                  }
#line 835
                if (s_entry != (void *)0) {
                  IPDispatchP$SendEntryPool$put(s_entry);
                  }
                (__nesc_temp55 = (unsigned char *)&IPDispatchP$stats.fw_drop, __nesc_hton_uint8(__nesc_temp55, (__nesc_temp56 = __nesc_ntoh_uint8(__nesc_temp55)) + 1), __nesc_temp56);
                fwd->timeout = T_FAILED1;
                goto fail;
              }


            fwd->s_info->refcount++;

            getFragDgramOffset(&lowmsg, &lowpan_offset);
            getFragDgramSize(&lowmsg, &lowpan_size);
            if (lowpan_offset * 8 + (lowmsg.len - (payload - lowmsg.data)) == lowpan_size) {



                if (-- fwd->s_info->refcount == 0) {
#line 852
                  IPDispatchP$SendInfoPool$put(fwd->s_info);
                  }
#line 853
                fwd->timeout = T_UNUSED;
              }

            setFragDgramTag(&lowmsg, fwd->new_tag);

            s_entry->msg = msg;
            s_entry->info = fwd->s_info;

            ;


            if (IPDispatchP$SendQueue$enqueue(s_entry) != SUCCESS) {
                (__nesc_temp57 = (unsigned char *)&IPDispatchP$stats.encfail, __nesc_hton_uint8(__nesc_temp57, (__nesc_temp58 = __nesc_ntoh_uint8(__nesc_temp57)) + 1), __nesc_temp58);
                ;
              }
            IPDispatchP$sendTask$postTask();
            return replacement;
          }
        else {
#line 871
          goto fail;
          }
        }
#line 872
      goto done;
    }

  fail: 
    ;
#line 876
  ;
  (__nesc_temp59 = (unsigned char *)&IPDispatchP$stats.rx_drop, __nesc_hton_uint8(__nesc_temp59, (__nesc_temp60 = __nesc_ntoh_uint8(__nesc_temp59)) + 1), __nesc_temp60);
  done: 
    return msg;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420MessageP$Ieee154Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = IPDispatchP$Ieee154Receive$receive(arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 106 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  ieee154_saddr_t CC2420MessageP$Ieee154Packet$address(void)
#line 106
{
  return CC2420MessageP$CC2420Config$getShortAddr();
}

#line 130
static inline  bool CC2420MessageP$Ieee154Packet$isForMe(message_t *msg)
#line 130
{
  return CC2420MessageP$Ieee154Packet$destination(msg) == CC2420MessageP$Ieee154Packet$address() || 
  CC2420MessageP$Ieee154Packet$destination(msg) == IEEE154_BROADCAST_ADDR;
}

# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_metadata_t *CC2420MessageP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778){
#line 47
  nx_struct cc2420_metadata_t *result;
#line 47

#line 47
  result = CC2420PacketP$CC2420PacketBody$getMetadata(arg_0x2ab4c4a1c778);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 180 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  message_t *CC2420MessageP$SubReceive$receive(uint8_t nw, message_t *msg, void *payload, uint8_t len)
#line 180
{
  cc2420_header_t *hdr = CC2420MessageP$CC2420PacketBody$getHeader(msg);

  if (! __nesc_ntoh_int8((unsigned char *)&CC2420MessageP$CC2420PacketBody$getMetadata(msg)->crc)) {
      return msg;
    }






  if (CC2420MessageP$Ieee154Packet$isForMe(msg)) {

      return CC2420MessageP$Ieee154Receive$receive(msg, (void *)& hdr->network, 
      len + sizeof(am_header_t ));
    }
  return msg;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420TinyosNetworkP$NonTinyosReceive$receive(uint8_t arg_0x2ab4c5228b68, message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420MessageP$SubReceive$receive(arg_0x2ab4c5228b68, arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 124 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline   message_t *CC2420TinyosNetworkP$Receive$default$receive(message_t *msg, void *payload, uint8_t len)
#line 124
{
  return msg;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420TinyosNetworkP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420TinyosNetworkP$Receive$default$receive(arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 110 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline  message_t *CC2420TinyosNetworkP$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 110
{
  if (__nesc_ntoh_leuint8((unsigned char *)&CC2420TinyosNetworkP$CC2420PacketBody$getHeader(msg)->network) == 0x3f) {
      return CC2420TinyosNetworkP$Receive$receive(msg, payload, len);
    }
  else {
      return CC2420TinyosNetworkP$NonTinyosReceive$receive(__nesc_ntoh_leuint8((unsigned char *)&CC2420TinyosNetworkP$CC2420PacketBody$getHeader(msg)->network), msg, payload, len);
    }
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *UniqueReceiveP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420TinyosNetworkP$SubReceive$receive(arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 137 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn)
#line 137
{
  uint8_t element = UniqueReceiveP$recycleSourceElement;
  bool increment = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 141
    {
      if (element == UniqueReceiveP$INVALID_ELEMENT || UniqueReceiveP$writeIndex == element) {

          element = UniqueReceiveP$writeIndex;
          increment = TRUE;
        }

      UniqueReceiveP$receivedMessages[element].source = msgSource;
      UniqueReceiveP$receivedMessages[element].dsn = msgDsn;
      if (increment) {
          UniqueReceiveP$writeIndex++;
          UniqueReceiveP$writeIndex %= 4;
        }
    }
#line 154
    __nesc_atomic_end(__nesc_atomic); }
}


static inline   message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *msg, void *payload, uint8_t len)
#line 158
{
  return msg;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *UniqueReceiveP$DuplicateReceive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP$DuplicateReceive$default$receive(arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 111 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn)
#line 111
{
  int i;

#line 113
  UniqueReceiveP$recycleSourceElement = UniqueReceiveP$INVALID_ELEMENT;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 115
    {
      for (i = 0; i < 4; i++) {
          if (UniqueReceiveP$receivedMessages[i].source == msgSource) {
              if (UniqueReceiveP$receivedMessages[i].dsn == msgDsn) {

                  {
                    unsigned char __nesc_temp = 
#line 120
                    TRUE;

                    {
#line 120
                      __nesc_atomic_end(__nesc_atomic); 
#line 120
                      return __nesc_temp;
                    }
                  }
                }
#line 123
              UniqueReceiveP$recycleSourceElement = i;
            }
        }
    }
#line 126
    __nesc_atomic_end(__nesc_atomic); }

  return FALSE;
}

# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *UniqueReceiveP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline  message_t *UniqueReceiveP$SubReceive$receive(message_t *msg, void *payload, 
uint8_t len)
#line 86
{
  uint16_t msgSource = __nesc_ntoh_leuint16((unsigned char *)&UniqueReceiveP$CC2420PacketBody$getHeader(msg)->src);
  uint8_t msgDsn = __nesc_ntoh_leuint8((unsigned char *)&UniqueReceiveP$CC2420PacketBody$getHeader(msg)->dsn);

  if (UniqueReceiveP$hasSeen(msgSource, msgDsn)) {
      return UniqueReceiveP$DuplicateReceive$receive(msg, payload, len);
    }
  else {
      UniqueReceiveP$insert(msgSource, msgDsn);
      return UniqueReceiveP$Receive$receive(msg, payload, len);
    }
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420ReceiveP$Receive$receive(message_t *arg_0x2ab4c4992c78, void *arg_0x2ab4c4991020, uint8_t arg_0x2ab4c49912d8){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP$SubReceive$receive(arg_0x2ab4c4992c78, arg_0x2ab4c4991020, arg_0x2ab4c49912d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   uint16_t CC2420ReceiveP$CC2420Config$getShortAddr(void){
#line 64
  unsigned int result;
#line 64

#line 64
  result = CC2420ControlP$CC2420Config$getShortAddr();
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 332 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   bool CC2420ControlP$CC2420Config$isAddressRecognitionEnabled(void)
#line 332
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 333
    {
      unsigned char __nesc_temp = 
#line 333
      CC2420ControlP$addressRecognition;

      {
#line 333
        __nesc_atomic_end(__nesc_atomic); 
#line 333
        return __nesc_temp;
      }
    }
#line 335
    __nesc_atomic_end(__nesc_atomic); }
}

# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   bool CC2420ReceiveP$CC2420Config$isAddressRecognitionEnabled(void){
#line 86
  unsigned char result;
#line 86

#line 86
  result = CC2420ControlP$CC2420Config$isAddressRecognitionEnabled();
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_header_t *CC2420ReceiveP$CC2420PacketBody$getHeader(message_t *arg_0x2ab4c4a1edf8){
#line 42
  nx_struct cc2420_header_t *result;
#line 42

#line 42
  result = CC2420PacketP$CC2420PacketBody$getHeader(arg_0x2ab4c4a1edf8);
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 461 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline bool CC2420ReceiveP$passesAddressCheck(message_t *msg)
#line 461
{
  cc2420_header_t *header = CC2420ReceiveP$CC2420PacketBody$getHeader(msg);

  if (!CC2420ReceiveP$CC2420Config$isAddressRecognitionEnabled()) {
      return TRUE;
    }

  return __nesc_ntoh_leuint16((unsigned char *)&header->dest) == CC2420ReceiveP$CC2420Config$getShortAddr()
   || __nesc_ntoh_leuint16((unsigned char *)&header->dest) == AM_BROADCAST_ADDR;
}

# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_metadata_t *CC2420ReceiveP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778){
#line 47
  nx_struct cc2420_metadata_t *result;
#line 47

#line 47
  result = CC2420PacketP$CC2420PacketBody$getMetadata(arg_0x2ab4c4a1c778);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 339 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline  void CC2420ReceiveP$receiveDone_task$runTask(void)
#line 339
{
  cc2420_metadata_t *metadata = CC2420ReceiveP$CC2420PacketBody$getMetadata(CC2420ReceiveP$m_p_rx_buf);
  cc2420_header_t *header = CC2420ReceiveP$CC2420PacketBody$getHeader(CC2420ReceiveP$m_p_rx_buf);
  uint8_t length = __nesc_ntoh_leuint8((unsigned char *)&header->length);
  uint8_t tmpLen __attribute((unused))  = sizeof(message_t ) - ((size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
  uint8_t *buf = (uint8_t *)header;

  __nesc_hton_int8((unsigned char *)&metadata->crc, buf[length] >> 7);
  __nesc_hton_uint8((unsigned char *)&metadata->lqi, buf[length] & 0x7f);
  __nesc_hton_uint8((unsigned char *)&metadata->rssi, buf[length - 1]);

  if (CC2420ReceiveP$passesAddressCheck(CC2420ReceiveP$m_p_rx_buf) && length >= CC2420_SIZE) {
      CC2420ReceiveP$m_p_rx_buf = CC2420ReceiveP$Receive$receive(CC2420ReceiveP$m_p_rx_buf, CC2420ReceiveP$m_p_rx_buf->data, 
      length - CC2420_SIZE);
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 355
    CC2420ReceiveP$receivingPacket = FALSE;
#line 355
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ReceiveP$waitForNextPacket();
}

# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  error_t UDPEchoP$Echo$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, uint16_t arg_0x2ab4c472dc28){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP$UDP$sendto(0U, arg_0x2ab4c472d660, arg_0x2ab4c472d948, arg_0x2ab4c472dc28);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 102 "UDPEchoP.nc"
static inline  void UDPEchoP$Echo$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta)
#line 103
{
  ;
  UDPEchoP$Echo$sendto(from, data, len);
}

#line 97
static inline  void UDPEchoP$Status$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta)
#line 98
{
}

# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  error_t UDPShellP$UDP$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, uint16_t arg_0x2ab4c472dc28){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP$UDP$sendto(2U, arg_0x2ab4c472d660, arg_0x2ab4c472d948, arg_0x2ab4c472dc28);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 285 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline   char *UDPShellP$ShellCommand$default$eval(uint8_t cmd_id, int argc, char **argv)
#line 285
{
  return (void *)0;
}

# 11 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/ShellCommand.nc"
inline static  char *UDPShellP$ShellCommand$eval(uint8_t arg_0x2ab4c5999b38, int arg_0x2ab4c599bb30, char **arg_0x2ab4c599be50){
#line 11
  char *result;
#line 11

#line 11
    result = UDPShellP$ShellCommand$default$eval(arg_0x2ab4c5999b38, arg_0x2ab4c599bb30, arg_0x2ab4c599be50);
#line 11

#line 11
  return result;
#line 11
}
#line 11
# 207 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP$init_argv(char *cmd, uint16_t len, char **argv, int *argc)
#line 207
{
  int inArg = 0;

#line 209
  *argc = 0;
  while (len > 0 && *argc < UDPShellP$N_ARGS) {
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











static inline  void UDPShellP$UDP$recvfrom(struct sockaddr_in6 *from, void *data, 
uint16_t len, struct ip_metadata *meta)
#line 237
{
  char *argv[UDPShellP$N_ARGS];
  int argc;
#line 239
  int cmd;

  ip_memcpy(&UDPShellP$session_endpoint, from, sizeof(struct sockaddr_in6 ));
  UDPShellP$init_argv((char *)data, len, argv, &argc);

  if (argc > 0) {
      cmd = UDPShellP$lookup_cmd(argv[0], UDPShellP$N_BUILTINS, UDPShellP$builtins);
      if (cmd != UDPShellP$CMD_NO_CMD) {
          UDPShellP$builtin_actions[cmd].action(argc, argv);
          return;
        }
      cmd = UDPShellP$lookup_cmd(argv[0], UDPShellP$N_EXTERNAL, UDPShellP$externals);
      if (cmd != UDPShellP$CMD_NO_CMD) {
          char *reply = UDPShellP$ShellCommand$eval(cmd, argc, argv);

#line 253
          if (reply != (void *)0) {
            UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, reply, strlen(reply));
            }
#line 255
          return;
        }
      cmd = snprintf(UDPShellP$reply_buf, MAX_REPLY_LEN, "sdsh: %s: command not found\n", argv[0]);
      UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, cmd);
    }
}

# 179 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static inline   void UdpP$UDP$default$recvfrom(uint8_t clnt, struct sockaddr_in6 *from, void *payload, 
uint16_t len, struct ip_metadata *meta)
#line 180
{
}

# 24 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  void UdpP$UDP$recvfrom(uint8_t arg_0x2ab4c5989060, struct sockaddr_in6 *arg_0x2ab4c472c660, void *arg_0x2ab4c472c948, uint16_t arg_0x2ab4c472cc28, struct ip_metadata *arg_0x2ab4c472b020){
#line 24
  switch (arg_0x2ab4c5989060) {
#line 24
    case 0U:
#line 24
      UDPEchoP$Echo$recvfrom(arg_0x2ab4c472c660, arg_0x2ab4c472c948, arg_0x2ab4c472cc28, arg_0x2ab4c472b020);
#line 24
      break;
#line 24
    case 1U:
#line 24
      UDPEchoP$Status$recvfrom(arg_0x2ab4c472c660, arg_0x2ab4c472c948, arg_0x2ab4c472cc28, arg_0x2ab4c472b020);
#line 24
      break;
#line 24
    case 2U:
#line 24
      UDPShellP$UDP$recvfrom(arg_0x2ab4c472c660, arg_0x2ab4c472c948, arg_0x2ab4c472cc28, arg_0x2ab4c472b020);
#line 24
      break;
#line 24
    default:
#line 24
      UdpP$UDP$default$recvfrom(arg_0x2ab4c5989060, arg_0x2ab4c472c660, arg_0x2ab4c472c948, arg_0x2ab4c472cc28, arg_0x2ab4c472b020);
#line 24
      break;
#line 24
    }
#line 24
}
#line 24
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  void UdpP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8){
#line 30
  IPAddressP$IPAddress$getIPAddr(arg_0x2ab4c49518e8);
#line 30
}
#line 30
#line 29
inline static  void UdpP$IPAddress$getLLAddr(struct in6_addr *arg_0x2ab4c4951020){
#line 29
  IPAddressP$IPAddress$getLLAddr(arg_0x2ab4c4951020);
#line 29
}
#line 29
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static inline void UdpP$setSrcAddr(struct split_ip_msg *msg)
#line 47
{
  if (msg->hdr.ip6_dst.in6_u.u6_addr16[7] == ((((uint16_t )0xff02 << 8) | ((uint16_t )0xff02 >> 8)) & 0xffff) || 
  msg->hdr.ip6_dst.in6_u.u6_addr16[7] == ((((uint16_t )0xfe80 << 8) | ((uint16_t )0xfe80 >> 8)) & 0xffff)) {
      UdpP$IPAddress$getLLAddr(& msg->hdr.ip6_src);
    }
  else 
#line 51
    {
      UdpP$IPAddress$getIPAddr(& msg->hdr.ip6_src);
    }
}

#line 24
static inline uint16_t UdpP$alloc_lport(uint8_t clnt)
#line 24
{
  int i;
#line 25
  int done = 0;
  uint16_t compare = (((uint16_t )UdpP$last_localport << 8) | ((uint16_t )UdpP$last_localport >> 8)) & 0xffff;

#line 27
  UdpP$last_localport = UdpP$last_localport < UdpP$LOCAL_PORT_START ? UdpP$last_localport + 1 : UdpP$LOCAL_PORT_START;
  while (!done) {
      done = 1;
      for (i = 0; i < UdpP$N_CLIENTS; i++) {
          if (UdpP$local_ports[i] == compare) {
              UdpP$last_localport = UdpP$last_localport < UdpP$LOCAL_PORT_START ? UdpP$last_localport + 1 : UdpP$LOCAL_PORT_START;
              compare = (((uint16_t )UdpP$last_localport << 8) | ((uint16_t )UdpP$last_localport >> 8)) & 0xffff;
              done = 0;
              break;
            }
        }
    }
  return UdpP$last_localport;
}

# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
inline static  error_t UdpP$IP$send(struct split_ip_msg *arg_0x2ab4c497f270){
#line 15
  unsigned char result;
#line 15

#line 15
  result = IPDispatchP$IP$send(IANA_UDP, arg_0x2ab4c497f270);
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 58 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  uint8_t IPDispatchP$IPRouting$getHopLimit(void){
#line 58
  unsigned char result;
#line 58

#line 58
  result = IPRoutingP$IPRouting$getHopLimit();
#line 58

#line 58
  return result;
#line 58
}
#line 58
# 1111 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$IPRouting$insertRoutingHeaders(struct split_ip_msg *msg)
#line 1111
{

  static uint8_t sh_buf[sizeof(struct topology_header ) + 
  sizeof(struct topology_entry ) * N_NEIGH];
  static struct generic_header record_route;
  struct topology_header *th = (struct topology_header *)sh_buf;
  int i;
#line 1117
  int j = 0;








  if (msg->hdr.nxt_hdr == IANA_UDP || msg->hdr.nxt_hdr == NXTHDR_UNKNOWN) {
      IPRoutingP$traffic_sent = TRUE;

      th->len = sizeof(struct topology_header );




      th->nxt_hdr = msg->hdr.nxt_hdr;


      for (i = 0; i < N_NEIGH; i++) {
          if (((&IPRoutingP$neigh_table[i])->flags & T_VALID_MASK) == T_VALID_MASK && j < 4 && ((
          (&IPRoutingP$neigh_table[i])->flags & T_MATURE_MASK) == T_MATURE_MASK || IPRoutingP$default_route == &IPRoutingP$neigh_table[i])) {
              th->topo[j].etx = IPRoutingP$getLinkCost(&IPRoutingP$neigh_table[i]) > 0xff ? 0xff : IPRoutingP$getLinkCost(&IPRoutingP$neigh_table[i]);
              th->topo[j].conf = IPRoutingP$getConfidence(&IPRoutingP$neigh_table[i]) > 0xff ? 0xff : IPRoutingP$getConfidence(&IPRoutingP$neigh_table[i]);
              th->topo[j].hwaddr = (((uint16_t )IPRoutingP$neigh_table[i].neighbor << 8) | ((uint16_t )IPRoutingP$neigh_table[i].neighbor >> 8)) & 0xffff;
              j++;
              th->len += sizeof(struct topology_entry );
              ;
            }
        }


      record_route.hdr.ext = (struct ip6_ext *)th;
      record_route.len = th->len;
      record_route.next = msg->headers;
      if (j > 0) {
          msg->hdr.nxt_hdr = NXTHDR_TOPO;
          msg->headers = &record_route;
        }
    }
}

# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  void IPDispatchP$IPRouting$insertRoutingHeaders(struct split_ip_msg *arg_0x2ab4c55debd0){
#line 86
  IPRoutingP$IPRouting$insertRoutingHeaders(arg_0x2ab4c55debd0);
#line 86
}
#line 86
# 585 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline uint16_t IPRoutingP$getSuccess(struct neigh_entry *neigh)
#line 585
{

  uint16_t succ = 0;

#line 588
  if (neigh != (void *)0 && (neigh->flags & T_VALID_MASK) == T_VALID_MASK) {



      succ += neigh->stats[IPRoutingP$LONG_EPOCH].success;
    }
  return succ;
}

# 88 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline  /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t */*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$get(void)
#line 88
{
  if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free) {
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t *rval = /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$queue[/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index];

#line 91
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$queue[/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index] = (void *)0;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free--;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index++;
      if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index == 12) {
          /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

# 97 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  IPDispatchP$SendInfoPool$t *IPDispatchP$SendInfoPool$get(void){
#line 97
  struct __nesc_unnamed4301 *result;
#line 97

#line 97
  result = /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$get();
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 167 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  void *CC2420MessageP$Packet$getPayload(message_t *msg, uint8_t len)
#line 167
{
  cc2420_header_t *hdr = CC2420MessageP$CC2420PacketBody$getHeader(msg);

#line 169
  return (void *)& hdr->network;
}

# 115 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void *IPDispatchP$Packet$getPayload(message_t *arg_0x2ab4c49afb18, uint8_t arg_0x2ab4c49afdd0){
#line 115
  void *result;
#line 115

#line 115
  result = CC2420MessageP$Packet$getPayload(arg_0x2ab4c49afb18, arg_0x2ab4c49afdd0);
#line 115

#line 115
  return result;
#line 115
}
#line 115
# 163 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  uint8_t CC2420MessageP$Packet$maxPayloadLength(void)
#line 163
{
  return 102 + sizeof(am_header_t );
}

# 95 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t IPDispatchP$Packet$maxPayloadLength(void){
#line 95
  unsigned char result;
#line 95

#line 95
  result = CC2420MessageP$Packet$maxPayloadLength();
#line 95

#line 95
  return result;
#line 95
}
#line 95
# 159 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  void CC2420MessageP$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 159
{
  __nesc_hton_leuint8((unsigned char *)&CC2420MessageP$CC2420PacketBody$getHeader(msg)->length, len + IEEE802154_SIZ);
}

# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void IPDispatchP$Packet$setPayloadLength(message_t *arg_0x2ab4c49b0608, uint8_t arg_0x2ab4c49b08c0){
#line 83
  CC2420MessageP$Packet$setPayloadLength(arg_0x2ab4c49b0608, arg_0x2ab4c49b08c0);
#line 83
}
#line 83
# 57 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static inline  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$size(void)
#line 57
{
  return /*IPDispatchC.QueueC*/QueueC$0$size;
}

static inline  uint8_t /*IPDispatchC.QueueC*/QueueC$0$Queue$maxSize(void)
#line 61
{
  return 12;
}

# 69 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
static inline  void IPAddressP$IPAddress$setPrefix(uint8_t *pfx)
#line 69
{
  ip_memclr(__my_address.in6_u.u6_addr8, sizeof(struct in6_addr ));
  ip_memcpy(__my_address.in6_u.u6_addr8, pfx, 8);
  globalPrefix = 1;
}

# 32 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  void ICMPResponderP$IPAddress$setPrefix(uint8_t *arg_0x2ab4c4950180){
#line 32
  IPAddressP$IPAddress$setPrefix(arg_0x2ab4c4950180);
#line 32
}
#line 32
# 607 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline void IPRoutingP$printTable(void)
#line 607
{
}

#line 862
static inline  void IPRoutingP$IPRouting$reportAdvertisement(ieee154_saddr_t neigh, uint8_t hops, 
uint8_t lqi, uint16_t cost)
#line 863
{




  struct neigh_entry *neigh_slot = (void *)0;

#line 869
  ;
  ;



  if ((neigh_slot = IPRoutingP$getNeighEntry(neigh)) == (void *)0) {
      ;
      if (IPRoutingP$adjustLQI(lqi) > LQI_ADMIT_THRESH || cost == 0xffff) {
          ;
          return;
        }

      if (!(((&IPRoutingP$neigh_table[N_NEIGH - 1])->flags & T_VALID_MASK) == T_VALID_MASK)) {

          ;
          for (neigh_slot = &IPRoutingP$neigh_table[N_NEIGH - 1]; 
          neigh_slot > &IPRoutingP$neigh_table[0]; neigh_slot--) {



              if (((
#line 888
              neigh_slot - 1)->flags & T_VALID_MASK) == T_VALID_MASK && 
              IPRoutingP$getConfidence(neigh_slot - 1) == 0 && (
              (struct neigh_entry *)(neigh_slot - 1))->costEstimate > cost) {
                  IPRoutingP$swapNodes(neigh_slot - 1, neigh_slot);
                }
              else {
#line 892
                if (((neigh_slot - 1)->flags & T_VALID_MASK) == T_VALID_MASK) {




                    break;
                  }
                }
            }
#line 900
          ip_memclr((void *)neigh_slot, sizeof(struct neigh_entry ));
        }
      else 
#line 901
        {

          ;

          if (((&IPRoutingP$neigh_table[N_NEIGH - 1])->flags & T_MATURE_MASK) == T_MATURE_MASK || 
          hops <= IPRoutingP$neigh_table[N_NEIGH - 1].hops) {
              ;


              if (
#line 909
              IPRoutingP$checkThresh(IPRoutingP$neigh_table[N_NEIGH - 1].costEstimate, cost, 
              PATH_COST_DIFF_THRESH) == BELOW_THRESH || (

              IPRoutingP$checkThresh(IPRoutingP$neigh_table[N_NEIGH - 1].costEstimate, cost, 
              PATH_COST_DIFF_THRESH) == WITHIN_THRESH && 
              IPRoutingP$checkThresh(IPRoutingP$neigh_table[N_NEIGH - 1].linkEstimate, IPRoutingP$adjustLQI(lqi), 
              LQI_DIFF_THRESH) == BELOW_THRESH)) {
                  ;



                  IPRoutingP$evictNeighbor(&IPRoutingP$neigh_table[N_NEIGH - 1]);
                  neigh_slot = &IPRoutingP$neigh_table[N_NEIGH - 1];
                }
            }
        }
    }
  else 
#line 925
    {
      if (cost == 0xffff) {
          ;
          IPRoutingP$evictNeighbor(neigh_slot);
          return;
        }

      neigh_slot->stats[IPRoutingP$SHORT_EPOCH].receptions--;
    }

  if (neigh_slot != (void *)0) {
      neigh_slot->flags |= T_VALID_MASK;
      neigh_slot->neighbor = neigh;
      neigh_slot->hops = hops;
      neigh_slot->costEstimate = cost;
      neigh_slot->linkEstimate = IPRoutingP$adjustLQI(lqi);
      neigh_slot->stats[IPRoutingP$SHORT_EPOCH].receptions++;
      ;
    }

  IPRoutingP$printTable();
}

# 66 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  void ICMPResponderP$IPRouting$reportAdvertisement(ieee154_saddr_t arg_0x2ab4c55e1108, uint8_t arg_0x2ab4c55e13c0, uint8_t arg_0x2ab4c55e1698, uint16_t arg_0x2ab4c55e1958){
#line 66
  IPRoutingP$IPRouting$reportAdvertisement(arg_0x2ab4c55e1108, arg_0x2ab4c55e13c0, arg_0x2ab4c55e1698, arg_0x2ab4c55e1958);
#line 66
}
#line 66
# 214 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline void ICMPResponderP$handleRouterAdv(void *payload, uint16_t len, struct ip_metadata *meta)
#line 214
{

  radv_t *r = (radv_t *)payload;
  pfx_t *pfx = (pfx_t *)r->options;
  uint16_t cost = 0;
  rqual_t *beacon = (rqual_t *)(pfx + 1);

  if (len > sizeof(radv_t ) + sizeof(pfx_t ) && __nesc_ntoh_uint8((unsigned char *)&
  beacon->type) == ICMP_EXT_TYPE_BEACON) {
      cost = __nesc_ntoh_uint16((unsigned char *)&beacon->metric);
      ;
    }
  else {
#line 226
    ;
    }
  ICMPResponderP$IPRouting$reportAdvertisement(meta->sender, __nesc_ntoh_uint8((unsigned char *)&r->hlim), 
  meta->lqi, cost);

  if (__nesc_ntoh_uint8((unsigned char *)&pfx->type) != ICMP_EXT_TYPE_PREFIX) {
#line 231
    return;
    }
  ICMPResponderP$IPAddress$setPrefix((uint8_t *)pfx->prefix);
}

# 158 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(uint8_t num)
{
  return /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].isrunning;
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  bool IPRoutingP$TrafficGenTimer$isRunning(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(7U);
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 153 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(uint8_t num)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].isrunning = FALSE;
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void IPRoutingP$TrafficGenTimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(7U);
#line 67
}
#line 67
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t ICMPResponderP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  bool ICMPResponderP$Advertisement$isRunning(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(5U);
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 262 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline  void UDPShellP$ICMPPing$pingReply(struct in6_addr *source, struct icmp_stats *stats)
#line 262
{
  int len;

#line 264
  len = inet_ntop6(source, UDPShellP$reply_buf, MAX_REPLY_LEN);
  if (len > 0) {
      len += snprintf(UDPShellP$reply_buf + len - 1, MAX_REPLY_LEN - len + 1, UDPShellP$ping_fmt, 
      stats->seq, stats->ttl, stats->rtt);
      UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, len);
    }
}

# 414 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline   void ICMPResponderP$ICMPPing$default$pingReply(uint16_t client, struct in6_addr *source, 
struct icmp_stats *ping_stats)
#line 415
{
}

# 8 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
inline static  void ICMPResponderP$ICMPPing$pingReply(uint16_t arg_0x2ab4c589d740, struct in6_addr *arg_0x2ab4c583d948, struct icmp_stats *arg_0x2ab4c583dca0){
#line 8
  switch (arg_0x2ab4c589d740) {
#line 8
    case 0U:
#line 8
      UDPShellP$ICMPPing$pingReply(arg_0x2ab4c583d948, arg_0x2ab4c583dca0);
#line 8
      break;
#line 8
    default:
#line 8
      ICMPResponderP$ICMPPing$default$pingReply(arg_0x2ab4c589d740, arg_0x2ab4c583d948, arg_0x2ab4c583dca0);
#line 8
      break;
#line 8
    }
#line 8
}
#line 8
# 178 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   uint8_t CC2420SpiP$Resource$isOwner(uint8_t id)
#line 178
{
  /* atomic removed: atomic calls only */
#line 179
  {
    unsigned char __nesc_temp = 
#line 179
    CC2420SpiP$m_holder == id;

#line 179
    return __nesc_temp;
  }
}

# 118 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   bool CC2420ReceiveP$SpiResource$isOwner(void){
#line 118
  unsigned char result;
#line 118

#line 118
  result = CC2420SpiP$Resource$isOwner(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 118

#line 118
  return result;
#line 118
}
#line 118
#line 87
inline static   error_t CC2420ReceiveP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiP$Resource$immediateRequest(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
#line 78
inline static   error_t CC2420ReceiveP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP$Resource$request(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t PacketLinkP$send$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(PacketLinkP$send);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 111 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  uint16_t PacketLinkP$PacketLink$getRetryDelay(message_t *msg)
#line 111
{
  return __nesc_ntoh_uint16((unsigned char *)&PacketLinkP$CC2420PacketBody$getMetadata(msg)->retryDelay);
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$get(void){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getNow(void)
{
  return /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$get();
}

# 98 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow(void){
#line 98
  unsigned long result;
#line 98

#line 98
  result = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 85 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow(void)
{
#line 86
  return /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow();
}

# 125 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(void){
#line 125
  unsigned long result;
#line 125

#line 125
  result = /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow();
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 148 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(), dt, TRUE);
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void PacketLinkP$DelayTimer$startOneShot(uint32_t arg_0x2ab4c474b108){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(2U, arg_0x2ab4c474b108);
#line 62
}
#line 62
# 74 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static inline   bool CC2420PacketP$Acks$wasAcked(message_t *p_msg)
#line 74
{
  return __nesc_ntoh_int8((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(p_msg)->ack);
}

# 74 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static   bool PacketLinkP$PacketAcknowledgements$wasAcked(message_t *arg_0x2ab4c49c5640){
#line 74
  unsigned char result;
#line 74

#line 74
  result = CC2420PacketP$Acks$wasAcked(arg_0x2ab4c49c5640);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   uint8_t PacketLinkP$SendState$getState(void){
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
# 171 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  void PacketLinkP$SubSend$sendDone(message_t *msg, error_t error)
#line 171
{
  if (PacketLinkP$SendState$getState() == PacketLinkP$S_SENDING) {
      PacketLinkP$totalRetries++;
      if (PacketLinkP$PacketAcknowledgements$wasAcked(msg)) {
          PacketLinkP$signalDone(SUCCESS);
          return;
        }
      else {
#line 178
        if (PacketLinkP$totalRetries < PacketLinkP$PacketLink$getRetries(PacketLinkP$currentSendMsg)) {

            if (PacketLinkP$PacketLink$getRetryDelay(PacketLinkP$currentSendMsg) > 0) {

                PacketLinkP$DelayTimer$startOneShot(PacketLinkP$PacketLink$getRetryDelay(PacketLinkP$currentSendMsg));
              }
            else {

                PacketLinkP$send$postTask();
              }

            return;
          }
        }
    }
  PacketLinkP$signalDone(error);
}

# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void CC2420CsmaP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8){
#line 89
  PacketLinkP$SubSend$sendDone(arg_0x2ab4c49a4600, arg_0x2ab4c49a48b8);
#line 89
}
#line 89
# 111 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
static inline   void StateImplP$State$forceState(uint8_t id, uint8_t reqState)
#line 111
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    StateImplP$state[id] = reqState;
#line 112
    __nesc_atomic_end(__nesc_atomic); }
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   void CC2420CsmaP$SplitControlState$forceState(uint8_t arg_0x2ab4c4db8060){
#line 51
  StateImplP$State$forceState(4U, arg_0x2ab4c4db8060);
#line 51
}
#line 51
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420CsmaP$stopDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420CsmaP$stopDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   error_t CC2420CsmaP$CC2420Power$stopVReg(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420ControlP$CC2420Power$stopVReg();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 58 "/home/sdawson/cvs/tinyos-2.x/tos/types/TinyError.h"
static inline  error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 84 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t CC2420CsmaP$SubControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = CC2420TransmitP$StdControl$stop();
#line 84
  result = ecombine(result, CC2420ReceiveP$StdControl$stop());
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 268 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline void CC2420CsmaP$shutdown(void)
#line 268
{
  CC2420CsmaP$SubControl$stop();
  CC2420CsmaP$CC2420Power$stopVReg();
  CC2420CsmaP$stopDone_task$postTask();
}

# 66 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   bool CC2420CsmaP$SplitControlState$isState(uint8_t arg_0x2ab4c4db75f8){
#line 66
  unsigned char result;
#line 66

#line 66
  result = StateImplP$State$isState(4U, arg_0x2ab4c4db75f8);
#line 66

#line 66
  return result;
#line 66
}
#line 66
# 237 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$sendDone_task$runTask(void)
#line 237
{
  error_t packetErr;

#line 239
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 239
    packetErr = CC2420CsmaP$sendErr;
#line 239
    __nesc_atomic_end(__nesc_atomic); }
  if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STOPPING)) {
      CC2420CsmaP$shutdown();
    }
  else {
      CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_STARTED);
    }

  CC2420CsmaP$Send$sendDone(CC2420CsmaP$m_msg, packetErr);
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectIOFunc(void)
#line 56
{
  /* atomic removed: atomic calls only */
#line 56
  * (volatile uint8_t *)31U &= ~(0x01 << 1);
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectIOFunc(void){
#line 85
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$selectIOFunc();
#line 85
}
#line 85
# 124 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline   void /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$disableEvents(void)
{
  * (volatile uint16_t *)388U &= ~0x0010;
}

# 47 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$disableEvents(void){
#line 47
  /*Msp430TimerC.Msp430TimerB1*/Msp430TimerCapComP$4$Control$disableEvents();
#line 47
}
#line 47
# 58 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$disable(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$disableEvents();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectIOFunc();
  }
}

# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   void CC2420TransmitP$CaptureSFD$disable(void){
#line 55
  /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Capture$disable();
#line 55
}
#line 55
# 91 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port10$clear(void)
#line 91
{
#line 91
  P1IFG &= ~(1 << 0);
}

# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$clear(void){
#line 41
  HplMsp430InterruptP$Port10$clear();
#line 41
}
#line 41
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port10$disable(void)
#line 83
{
#line 83
  P1IE &= ~(1 << 0);
}

# 36 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$disable(void){
#line 36
  HplMsp430InterruptP$Port10$disable();
#line 36
}
#line 36
# 58 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$disable(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$disable();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$clear();
  }
  return SUCCESS;
}

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ReceiveP$InterruptFIFOP$disable(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$disable();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)29U &= ~(0x01 << 5);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$clr(void){
#line 39
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$clr();
#line 39
}
#line 39
# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$clr(void)
#line 38
{
#line 38
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$clr();
}

# 30 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$VREN$clr(void){
#line 30
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$clr();
#line 30
}
#line 30
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void PacketLinkP$DelayTimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(2U);
#line 67
}
#line 67
# 971 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$IPRouting$reportTransmission(send_policy_t *policy)
#line 971
{
  int i;
  struct neigh_entry *e = (void *)0;









  if (policy->dest[0] != IEEE154_BROADCAST_ADDR) {

      ;



      for (i = 0; i < policy->current; i++) {
          e = IPRoutingP$getNeighEntry(policy->dest[i]);
          if (e != (void *)0) {

              e->stats[IPRoutingP$SHORT_EPOCH].total += policy->retries;

              if (e == IPRoutingP$default_route) {
                  IPRoutingP$default_route_failures++;
                }

              ;
            }
        }



      if (IPRoutingP$default_route_failures > MAX_CONSEC_FAILURES) {
          ;
          IPRoutingP$chooseNewRandomDefault(TRUE);
        }


      e = IPRoutingP$getNeighEntry(policy->dest[policy->current]);
      if (policy->current < policy->nchoices && e != (void *)0) {
          e->stats[IPRoutingP$SHORT_EPOCH].success += 1;
          e->stats[IPRoutingP$SHORT_EPOCH].total += policy->actRetries;

          ;

          ;

          if (e == IPRoutingP$default_route) {
            IPRoutingP$default_route_failures++;
            }

          if (e != &IPRoutingP$neigh_table[0] && ((

          IPRoutingP$getConfidence(e) > CONF_PROM_THRESHOLD && 
          IPRoutingP$checkThresh(IPRoutingP$getMetric(e), IPRoutingP$getMetric(e - 1), PATH_COST_DIFF_THRESH) == BELOW_THRESH) || (

          IPRoutingP$checkThresh(IPRoutingP$getMetric(e), IPRoutingP$getMetric(e - 1), PATH_COST_DIFF_THRESH) == WITHIN_THRESH && 
          IPRoutingP$getConfidence(e) > CONF_PROM_THRESHOLD))) {

              ;
              IPRoutingP$swapNodes(e - 1, e);
            }
        }
      else 

        {
          ;
        }
    }
}

# 79 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  void IPDispatchP$IPRouting$reportTransmission(send_policy_t *arg_0x2ab4c55e0d48){
#line 79
  IPRoutingP$IPRouting$reportTransmission(arg_0x2ab4c55e0d48);
#line 79
}
#line 79
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static  uint16_t IPDispatchP$PacketLink$getRetries(message_t *arg_0x2ab4c4a03610){
#line 59
  unsigned int result;
#line 59

#line 59
  result = PacketLinkP$PacketLink$getRetries(arg_0x2ab4c4a03610);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 118 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  bool PacketLinkP$PacketLink$wasDelivered(message_t *msg)
#line 118
{
  return PacketLinkP$PacketAcknowledgements$wasAcked(msg);
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketLink.nc"
inline static  bool IPDispatchP$PacketLink$wasDelivered(message_t *arg_0x2ab4c4a018f8){
#line 71
  unsigned char result;
#line 71

#line 71
  result = PacketLinkP$PacketLink$wasDelivered(arg_0x2ab4c4a018f8);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 96 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline  error_t CC2420CsmaP$SplitControl$stop(void)
#line 96
{
  if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STARTED)) {
      CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_STOPPING);
      CC2420CsmaP$shutdown();
      return SUCCESS;
    }
  else {
#line 102
    if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STOPPED)) {
        return EALREADY;
      }
    else {
#line 105
      if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_TRANSMITTING)) {
          CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_STOPPING);

          return SUCCESS;
        }
      else {
#line 110
        if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STOPPING)) {
            return SUCCESS;
          }
        }
      }
    }
#line 114
  return EBUSY;
}

# 109 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t IPDispatchP$RadioControl$stop(void){
#line 109
  unsigned char result;
#line 109

#line 109
  result = CC2420CsmaP$SplitControl$stop();
#line 109

#line 109
  return result;
#line 109
}
#line 109
# 1063 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$Ieee154Send$sendDone(message_t *msg, error_t error)
#line 1063
{
  send_entry_t *s_entry = IPDispatchP$SendQueue$head();

#line 1065
  if (0) {
#line 1065
    return;
    }
  IPDispatchP$radioBusy = FALSE;

  if (IPDispatchP$state == IPDispatchP$S_STOPPING) {
      IPDispatchP$RadioControl$stop();
      IPDispatchP$state = IPDispatchP$S_STOPPED;
      goto fail;
    }


  if (!IPDispatchP$PacketLink$wasDelivered(msg)) {


      if (s_entry->info->frags_sent == 0) {


          s_entry->info->policy.current++;
          if (s_entry->info->policy.current < s_entry->info->policy.nchoices) {

              IPDispatchP$sendTask$postTask();
              return;
            }
        }



      goto fail;
    }
  else 
#line 1093
    {

      s_entry->info->frags_sent++;
      goto done;
    }
  goto done;

  fail: 
    s_entry->info->failed = TRUE;
  if (s_entry->info->policy.dest[0] != 0xffff) {
    ;
    }
  done: 
    s_entry->info->policy.actRetries = IPDispatchP$PacketLink$getRetries(msg);
  IPDispatchP$IPRouting$reportTransmission(& s_entry->info->policy);

  if (-- s_entry->info->refcount == 0) {
#line 1109
    IPDispatchP$SendInfoPool$put(s_entry->info);
    }
#line 1110
  IPDispatchP$FragPool$put(s_entry->msg);
  IPDispatchP$SendEntryPool$put(s_entry);
  IPDispatchP$SendQueue$dequeue();

  IPDispatchP$sendTask$postTask();
}

# 86 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/Ieee154Send.nc"
inline static  void CC2420MessageP$Ieee154Send$sendDone(message_t *arg_0x2ab4c499cdc8, error_t arg_0x2ab4c499b0c8){
#line 86
  IPDispatchP$Ieee154Send$sendDone(arg_0x2ab4c499cdc8, arg_0x2ab4c499b0c8);
#line 86
}
#line 86
# 174 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  void CC2420MessageP$SubSend$sendDone(message_t *msg, error_t result)
#line 174
{
  CC2420MessageP$Ieee154Send$sendDone(msg, result);
}

# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void CC2420TinyosNetworkP$NonTinyosSend$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8){
#line 89
  CC2420MessageP$SubSend$sendDone(arg_0x2ab4c49a4600, arg_0x2ab4c49a48b8);
#line 89
}
#line 89
# 131 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline   void CC2420TinyosNetworkP$Send$default$sendDone(message_t *msg, error_t error)
#line 131
{
}

# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void CC2420TinyosNetworkP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8){
#line 89
  CC2420TinyosNetworkP$Send$default$sendDone(arg_0x2ab4c49a4600, arg_0x2ab4c49a48b8);
#line 89
}
#line 89
# 101 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/lowpan/CC2420TinyosNetworkP.nc"
static inline  void CC2420TinyosNetworkP$SubSend$sendDone(message_t *msg, error_t error)
#line 101
{
  if (__nesc_ntoh_leuint8((unsigned char *)&CC2420TinyosNetworkP$CC2420PacketBody$getHeader(msg)->network) == 0x3f) {
      CC2420TinyosNetworkP$Send$sendDone(msg, error);
    }
  else 
#line 104
    {
      CC2420TinyosNetworkP$NonTinyosSend$sendDone(msg, error);
    }
}

# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void UniqueSendP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8){
#line 89
  CC2420TinyosNetworkP$SubSend$sendDone(arg_0x2ab4c49a4600, arg_0x2ab4c49a48b8);
#line 89
}
#line 89
# 104 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline  void UniqueSendP$SubSend$sendDone(message_t *msg, error_t error)
#line 104
{
  UniqueSendP$State$toIdle();
  UniqueSendP$Send$sendDone(msg, error);
}

# 89 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void PacketLinkP$Send$sendDone(message_t *arg_0x2ab4c49a4600, error_t arg_0x2ab4c49a48b8){
#line 89
  UniqueSendP$SubSend$sendDone(arg_0x2ab4c49a4600, arg_0x2ab4c49a48b8);
#line 89
}
#line 89
# 93 "UDPEchoP.nc"
static inline  void UDPEchoP$RadioControl$stopDone(error_t e)
#line 93
{
}

# 117 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void IPDispatchP$SplitControl$stopDone(error_t arg_0x2ab4c47355c0){
#line 117
  UDPEchoP$RadioControl$stopDone(arg_0x2ab4c47355c0);
#line 117
}
#line 117
# 259 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$RadioControl$stopDone(error_t error)
#line 259
{
  IPDispatchP$SplitControl$stopDone(error);
}

# 117 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void CC2420CsmaP$SplitControl$stopDone(error_t arg_0x2ab4c47355c0){
#line 117
  IPDispatchP$RadioControl$stopDone(arg_0x2ab4c47355c0);
#line 117
}
#line 117
# 258 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$stopDone_task$runTask(void)
#line 258
{
  CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_STOPPED);
  CC2420CsmaP$SplitControl$stopDone(SUCCESS);
}

# 89 "UDPEchoP.nc"
static inline  void UDPEchoP$RadioControl$startDone(error_t e)
#line 89
{
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void IPDispatchP$SplitControl$startDone(error_t arg_0x2ab4c47363a0){
#line 92
  UDPEchoP$RadioControl$startDone(arg_0x2ab4c47363a0);
#line 92
}
#line 92
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
inline static  void IPDispatchP$ICMP$sendSolicitations(void){
#line 28
  ICMPResponderP$ICMP$sendSolicitations();
#line 28
}
#line 28
# 248 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$RadioControl$startDone(error_t error)
#line 248
{



  if (error == SUCCESS) {
      IPDispatchP$ICMP$sendSolicitations();
      IPDispatchP$state = IPDispatchP$S_RUNNING;
    }
  IPDispatchP$SplitControl$startDone(error);
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void CC2420CsmaP$SplitControl$startDone(error_t arg_0x2ab4c47363a0){
#line 92
  IPDispatchP$RadioControl$startDone(arg_0x2ab4c47363a0);
#line 92
}
#line 92
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP$Resource$release(/*CC2420ControlC.Spi*/CC2420SpiC$0$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$CSN$set(void){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set();
#line 29
}
#line 29
# 179 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$Resource$release(void)
#line 179
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 180
    {
      CC2420ControlP$CSN$set();
      {
        unsigned char __nesc_temp = 
#line 182
        CC2420ControlP$SpiResource$release();

        {
#line 182
          __nesc_atomic_end(__nesc_atomic); 
#line 182
          return __nesc_temp;
        }
      }
    }
#line 185
    __nesc_atomic_end(__nesc_atomic); }
}

# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420CsmaP$Resource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420ControlP$Resource$release();
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SRXON$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SRXON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 249 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$rxOn(void)
#line 249
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 250
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_XOSC_STARTED) {
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
#line 254
      CC2420ControlP$SRXON$strobe();
    }
#line 255
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 90 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   error_t CC2420CsmaP$CC2420Power$rxOn(void){
#line 90
  unsigned char result;
#line 90

#line 90
  result = CC2420ControlP$CC2420Power$rxOn();
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 75 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port10$enable(void)
#line 75
{
#line 75
  P1IE |= 1 << 0;
}

# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$enable(void){
#line 31
  HplMsp430InterruptP$Port10$enable();
#line 31
}
#line 31
# 107 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port10$edge(bool l2h)
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

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$edge(bool arg_0x2ab4c4c44860){
#line 56
  HplMsp430InterruptP$Port10$edge(arg_0x2ab4c4c44860);
#line 56
}
#line 56
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$enable(bool rising)
#line 41
{
  /* atomic removed: atomic calls only */
#line 42
  {
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$disable();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$edge(rising);
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$enable();
  }
  return SUCCESS;
}





static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$enableFallingEdge(void)
#line 54
{
  return /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$enable(FALSE);
}

# 43 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ReceiveP$InterruptFIFOP$enableFallingEdge(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$enableFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 124 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline  error_t CC2420ReceiveP$StdControl$start(void)
#line 124
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 125
    {
      CC2420ReceiveP$reset_state();
      CC2420ReceiveP$m_state = CC2420ReceiveP$S_STARTED;
      CC2420ReceiveP$receivingPacket = FALSE;




      CC2420ReceiveP$InterruptFIFOP$enableFallingEdge();
    }
#line 134
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 148 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline  error_t CC2420TransmitP$StdControl$start(void)
#line 148
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 149
    {
      CC2420TransmitP$CaptureSFD$captureRisingEdge();
      CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
      CC2420TransmitP$m_receiving = FALSE;
      CC2420TransmitP$abortSpiRelease = FALSE;
      CC2420TransmitP$m_tx_power = 0;
    }
#line 155
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 74 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t CC2420CsmaP$SubControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = CC2420TransmitP$StdControl$start();
#line 74
  result = ecombine(result, CC2420ReceiveP$StdControl$start());
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 250 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$startDone_task$runTask(void)
#line 250
{
  CC2420CsmaP$SubControl$start();
  CC2420CsmaP$CC2420Power$rxOn();
  CC2420CsmaP$Resource$release();
  CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_STARTED);
  CC2420CsmaP$SplitControl$startDone(SUCCESS);
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  bool ICMPResponderP$Solicitation$isRunning(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(4U);
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 209 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  void PacketLinkP$send$runTask(void)
#line 209
{
  if (PacketLinkP$PacketLink$getRetries(PacketLinkP$currentSendMsg) > 0) {
      PacketLinkP$PacketAcknowledgements$requestAck(PacketLinkP$currentSendMsg);
    }

  if (PacketLinkP$SubSend$send(PacketLinkP$currentSendMsg, PacketLinkP$currentSendLen) != SUCCESS) {
      PacketLinkP$send$postTask();
    }
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420SpiP$grant$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420SpiP$grant);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 184 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline  void CC2420SpiP$SpiResource$granted(void)
#line 184
{
  CC2420SpiP$grant$postTask();
}

# 119 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(uint8_t id)
#line 119
{
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(uint8_t arg_0x2ab4c4ead6d8){
#line 92
  switch (arg_0x2ab4c4ead6d8) {
#line 92
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 92
      CC2420SpiP$SpiResource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$default$granted(arg_0x2ab4c4ead6d8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 95 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(uint8_t id)
#line 95
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Resource$granted(id);
}

# 199 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline   void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(uint8_t id)
#line 199
{
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(uint8_t arg_0x2ab4c508e2a0){
#line 92
  switch (arg_0x2ab4c508e2a0) {
#line 92
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 92
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartResource$granted(/*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID);
#line 92
      break;
#line 92
    default:
#line 92
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$default$granted(arg_0x2ab4c508e2a0);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 187 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static inline  void /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask(void)
#line 187
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 188
    {
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
    }
#line 191
    __nesc_atomic_end(__nesc_atomic); }
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceConfigure$configure(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId);
  /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$granted(/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId);
}

# 190 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline    void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(uint8_t id, uint8_t *tx_buf, uint8_t *rx_buf, uint16_t len, error_t error)
#line 190
{
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(uint8_t arg_0x2ab4c4eaab90, uint8_t *arg_0x2ab4c4d7b938, uint8_t *arg_0x2ab4c4d7bc28, uint16_t arg_0x2ab4c4d7a020, error_t arg_0x2ab4c4d7a2f8){
#line 71
  switch (arg_0x2ab4c4eaab90) {
#line 71
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC*/Msp430Spi0C$0$CLIENT_ID:
#line 71
      CC2420SpiP$SpiPacket$sendDone(arg_0x2ab4c4d7b938, arg_0x2ab4c4d7bc28, arg_0x2ab4c4d7a020, arg_0x2ab4c4d7a2f8);
#line 71
      break;
#line 71
    default:
#line 71
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$default$sendDone(arg_0x2ab4c4eaab90, arg_0x2ab4c4d7b938, arg_0x2ab4c4d7bc28, arg_0x2ab4c4d7a020, arg_0x2ab4c4d7a2f8);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 183 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone(void)
#line 183
{
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$sendDone(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_client, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf, /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len, 
  SUCCESS);
}

#line 166
static inline  void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask(void)
#line 166
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 167
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone();
#line 167
    __nesc_atomic_end(__nesc_atomic); }
}

# 463 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 464
{
}

# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ReceiveP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP$Resource$release(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ReceiveP$CSN$set(void){
#line 29
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$set();
#line 29
}
#line 29
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420ReceiveP$receiveDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420ReceiveP$receiveDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420PacketBody.nc"
inline static   cc2420_metadata_t *CC2420TransmitP$CC2420PacketBody$getMetadata(message_t *arg_0x2ab4c4a1c778){
#line 47
  nx_struct cc2420_metadata_t *result;
#line 47

#line 47
  result = CC2420PacketP$CC2420PacketBody$getMetadata(arg_0x2ab4c4a1c778);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 365 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$CC2420Receive$receive(uint8_t type, message_t *ack_msg)
#line 365
{
  cc2420_header_t *ack_header;
  cc2420_header_t *msg_header;
  cc2420_metadata_t *msg_metadata;
  uint8_t *ack_buf;
  uint8_t length;

  if (type == IEEE154_TYPE_ACK && CC2420TransmitP$m_msg) {
      ack_header = CC2420TransmitP$CC2420PacketBody$getHeader(ack_msg);
      msg_header = CC2420TransmitP$CC2420PacketBody$getHeader(CC2420TransmitP$m_msg);


      if (CC2420TransmitP$m_state == CC2420TransmitP$S_ACK_WAIT && __nesc_ntoh_leuint8((unsigned char *)&msg_header->dsn) == __nesc_ntoh_leuint8((unsigned char *)&ack_header->dsn)) {
          CC2420TransmitP$BackoffTimer$stop();

          msg_metadata = CC2420TransmitP$CC2420PacketBody$getMetadata(CC2420TransmitP$m_msg);
          ack_buf = (uint8_t *)ack_header;
          length = __nesc_ntoh_leuint8((unsigned char *)&ack_header->length);

          __nesc_hton_int8((unsigned char *)&msg_metadata->ack, TRUE);
          __nesc_hton_uint8((unsigned char *)&msg_metadata->rssi, ack_buf[length - 1]);
          __nesc_hton_uint8((unsigned char *)&msg_metadata->lqi, ack_buf[length] & 0x7f);
          CC2420TransmitP$signalDone(SUCCESS);
        }
    }
}

# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Receive.nc"
inline static   void CC2420ReceiveP$CC2420Receive$receive(uint8_t arg_0x2ab4c53f6398, message_t *arg_0x2ab4c53f6690){
#line 63
  CC2420TransmitP$CC2420Receive$receive(arg_0x2ab4c53f6398, arg_0x2ab4c53f6690);
#line 63
}
#line 63
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/PacketTimeStamp.nc"
inline static   void CC2420ReceiveP$PacketTimeStamp$clear(message_t *arg_0x2ab4c4a14b30){
#line 59
  CC2420PacketP$PacketTimeStamp32khz$clear(arg_0x2ab4c4a14b30);
#line 59
}
#line 59








inline static   void CC2420ReceiveP$PacketTimeStamp$set(message_t *arg_0x2ab4c4a12468, CC2420ReceiveP$PacketTimeStamp$size_type arg_0x2ab4c4a12728){
#line 67
  CC2420PacketP$PacketTimeStamp32khz$set(arg_0x2ab4c4a12468, arg_0x2ab4c4a12728);
#line 67
}
#line 67
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$getRaw(void)
#line 48
{
#line 48
  return * (volatile uint8_t *)32U & (0x01 << 0);
}

#line 49
static inline   bool /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$get(void)
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$getRaw() != 0;
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$HplGeneralIO$get(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P10*/HplMsp430GeneralIOP$0$IO$get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$GeneralIO$get(void)
#line 40
{
#line 40
  return /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$HplGeneralIO$get();
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420ReceiveP$FIFOP$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.FIFOPM*/Msp430GpioC$6$GeneralIO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 48 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   uint8_t /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$getRaw(void)
#line 48
{
#line 48
  return * (volatile uint8_t *)32U & (0x01 << 3);
}

#line 49
static inline   bool /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$get(void)
#line 49
{
#line 49
  return /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$getRaw() != 0;
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$HplGeneralIO$get(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = /*HplMsp430GeneralIOC.P13*/HplMsp430GeneralIOP$3$IO$get();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 40 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   bool /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$GeneralIO$get(void)
#line 40
{
#line 40
  return /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$HplGeneralIO$get();
}

# 32 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420ReceiveP$FIFO$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplCC2420PinsC.FIFOM*/Msp430GpioC$5$GeneralIO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 209 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   error_t CC2420SpiP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 210
{
  return CC2420SpiP$SpiPacket$send((void *)0, data, len);
}

# 62 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static   error_t CC2420ReceiveP$RXFIFO$continueRead(uint8_t *arg_0x2ab4c4d667c0, uint8_t arg_0x2ab4c4d66a78){
#line 62
  unsigned char result;
#line 62

#line 62
  result = CC2420SpiP$Fifo$continueRead(CC2420_RXFIFO, arg_0x2ab4c4d667c0, arg_0x2ab4c4d66a78);
#line 62

#line 62
  return result;
#line 62
}
#line 62
#line 51
inline static   cc2420_status_t CC2420ReceiveP$RXFIFO$beginRead(uint8_t *arg_0x2ab4c4d68a98, uint8_t arg_0x2ab4c4d68d50){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420SpiP$Fifo$beginRead(CC2420_RXFIFO, arg_0x2ab4c4d68a98, arg_0x2ab4c4d68d50);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ReceiveP$CSN$clr(void){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr();
#line 30
}
#line 30
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ReceiveP$SACK$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SACK);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 359 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   bool CC2420ControlP$CC2420Config$isHwAutoAckDefault(void)
#line 359
{
  /* atomic removed: atomic calls only */
#line 360
  {
    unsigned char __nesc_temp = 
#line 360
    CC2420ControlP$hwAutoAckDefault;

#line 360
    return __nesc_temp;
  }
}

# 105 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   bool CC2420ReceiveP$CC2420Config$isHwAutoAckDefault(void){
#line 105
  unsigned char result;
#line 105

#line 105
  result = CC2420ControlP$CC2420Config$isHwAutoAckDefault();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 366 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   bool CC2420ControlP$CC2420Config$isAutoAckEnabled(void)
#line 366
{
  /* atomic removed: atomic calls only */
#line 367
  {
    unsigned char __nesc_temp = 
#line 367
    CC2420ControlP$autoAckEnabled;

#line 367
    return __nesc_temp;
  }
}

# 110 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static   bool CC2420ReceiveP$CC2420Config$isAutoAckEnabled(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420ControlP$CC2420Config$isAutoAckEnabled();
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 199 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error)
#line 200
{
  cc2420_header_t *header = CC2420ReceiveP$CC2420PacketBody$getHeader(CC2420ReceiveP$m_p_rx_buf);
  uint8_t tmpLen __attribute((unused))  = sizeof(message_t ) - ((size_t )& ((message_t *)0)->data - sizeof(cc2420_header_t ));
  uint8_t *buf = (uint8_t *)header;

#line 204
  CC2420ReceiveP$rxFrameLength = buf[0];

  switch (CC2420ReceiveP$m_state) {

      case CC2420ReceiveP$S_RX_LENGTH: 
        CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_FCF;
      if (CC2420ReceiveP$rxFrameLength + 1 > CC2420ReceiveP$m_bytes_left) {

          CC2420ReceiveP$flush();
        }
      else {
          if (!CC2420ReceiveP$FIFO$get() && !CC2420ReceiveP$FIFOP$get()) {
              CC2420ReceiveP$m_bytes_left -= CC2420ReceiveP$rxFrameLength + 1;
            }

          if (CC2420ReceiveP$rxFrameLength <= MAC_PACKET_SIZE) {
              if (CC2420ReceiveP$rxFrameLength > 0) {
                  if (CC2420ReceiveP$rxFrameLength > CC2420ReceiveP$SACK_HEADER_LENGTH) {

                      CC2420ReceiveP$RXFIFO$continueRead(buf + 1, CC2420ReceiveP$SACK_HEADER_LENGTH);
                    }
                  else {

                      CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_PAYLOAD;
                      CC2420ReceiveP$RXFIFO$continueRead(buf + 1, CC2420ReceiveP$rxFrameLength);
                    }
                }
              else {
                  /* atomic removed: atomic calls only */
                  CC2420ReceiveP$receivingPacket = FALSE;
                  CC2420ReceiveP$CSN$set();
                  CC2420ReceiveP$SpiResource$release();
                  CC2420ReceiveP$waitForNextPacket();
                }
            }
          else {

              CC2420ReceiveP$flush();
            }
        }
      break;

      case CC2420ReceiveP$S_RX_FCF: 
        CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_PAYLOAD;










      if (CC2420ReceiveP$CC2420Config$isAutoAckEnabled() && !CC2420ReceiveP$CC2420Config$isHwAutoAckDefault()) {



          if (((__nesc_ntoh_leuint16((unsigned char *)&
#line 259
          header->fcf) >> IEEE154_FCF_ACK_REQ) & 0x01) == 1
           && (__nesc_ntoh_leuint16((unsigned char *)&header->dest) == CC2420ReceiveP$CC2420Config$getShortAddr()
           || __nesc_ntoh_leuint16((unsigned char *)&header->dest) == AM_BROADCAST_ADDR)
           && ((__nesc_ntoh_leuint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_DATA) {

              CC2420ReceiveP$CSN$set();
              CC2420ReceiveP$CSN$clr();
              CC2420ReceiveP$SACK$strobe();
              CC2420ReceiveP$CSN$set();
              CC2420ReceiveP$CSN$clr();
              CC2420ReceiveP$RXFIFO$beginRead(buf + 1 + CC2420ReceiveP$SACK_HEADER_LENGTH, 
              CC2420ReceiveP$rxFrameLength - CC2420ReceiveP$SACK_HEADER_LENGTH);
              return;
            }
        }


      CC2420ReceiveP$RXFIFO$continueRead(buf + 1 + CC2420ReceiveP$SACK_HEADER_LENGTH, 
      CC2420ReceiveP$rxFrameLength - CC2420ReceiveP$SACK_HEADER_LENGTH);
      break;

      case CC2420ReceiveP$S_RX_PAYLOAD: 
        CC2420ReceiveP$CSN$set();

      if (!CC2420ReceiveP$m_missed_packets) {

          CC2420ReceiveP$SpiResource$release();
        }




      if ((((
#line 289
      CC2420ReceiveP$m_missed_packets && CC2420ReceiveP$FIFO$get()) || !CC2420ReceiveP$FIFOP$get())
       || !CC2420ReceiveP$m_timestamp_size)
       || CC2420ReceiveP$rxFrameLength <= 10) {
          CC2420ReceiveP$PacketTimeStamp$clear(CC2420ReceiveP$m_p_rx_buf);
        }
      else {
          if (CC2420ReceiveP$m_timestamp_size == 1) {
            CC2420ReceiveP$PacketTimeStamp$set(CC2420ReceiveP$m_p_rx_buf, CC2420ReceiveP$m_timestamp_queue[CC2420ReceiveP$m_timestamp_head]);
            }
#line 297
          CC2420ReceiveP$m_timestamp_head = (CC2420ReceiveP$m_timestamp_head + 1) % CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE;
          CC2420ReceiveP$m_timestamp_size--;

          if (CC2420ReceiveP$m_timestamp_size > 0) {
              CC2420ReceiveP$PacketTimeStamp$clear(CC2420ReceiveP$m_p_rx_buf);
              CC2420ReceiveP$m_timestamp_head = 0;
              CC2420ReceiveP$m_timestamp_size = 0;
            }
        }



      if (buf[CC2420ReceiveP$rxFrameLength] >> 7 && rx_buf) {
          uint8_t type = (__nesc_ntoh_leuint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7;

#line 311
          CC2420ReceiveP$CC2420Receive$receive(type, CC2420ReceiveP$m_p_rx_buf);
          if (type == IEEE154_TYPE_DATA) {
              CC2420ReceiveP$receiveDone_task$postTask();
              return;
            }
        }

      CC2420ReceiveP$waitForNextPacket();
      break;

      default: /* atomic removed: atomic calls only */
        CC2420ReceiveP$receivingPacket = FALSE;
      CC2420ReceiveP$CSN$set();
      CC2420ReceiveP$SpiResource$release();
      break;
    }
}

# 370 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline    void CC2420SpiP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error)
#line 370
{
}

# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static   void CC2420SpiP$Fifo$readDone(uint8_t arg_0x2ab4c4d8f108, uint8_t *arg_0x2ab4c4d654a8, uint8_t arg_0x2ab4c4d65760, error_t arg_0x2ab4c4d65a18){
#line 71
  switch (arg_0x2ab4c4d8f108) {
#line 71
    case CC2420_TXFIFO:
#line 71
      CC2420TransmitP$TXFIFO$readDone(arg_0x2ab4c4d654a8, arg_0x2ab4c4d65760, arg_0x2ab4c4d65a18);
#line 71
      break;
#line 71
    case CC2420_RXFIFO:
#line 71
      CC2420ReceiveP$RXFIFO$readDone(arg_0x2ab4c4d654a8, arg_0x2ab4c4d65760, arg_0x2ab4c4d65a18);
#line 71
      break;
#line 71
    default:
#line 71
      CC2420SpiP$Fifo$default$readDone(arg_0x2ab4c4d8f108, arg_0x2ab4c4d654a8, arg_0x2ab4c4d65760, arg_0x2ab4c4d65a18);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ReceiveP$SFLUSHRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SFLUSHRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 281 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(message_t *msg)
#line 281
{
}

# 81 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8){
#line 81
  CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(arg_0x2ab4c49f74b8);
#line 81
}
#line 81
# 223 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t backoffTime)
#line 223
{
  CC2420TransmitP$myInitialBackoff = backoffTime + 1;
}

# 60 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420CsmaP$SubBackoff$setInitialBackoff(uint16_t arg_0x2ab4c49fa840){
#line 60
  CC2420TransmitP$RadioBackoff$setInitialBackoff(arg_0x2ab4c49fa840);
#line 60
}
#line 60
# 216 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *msg)
#line 216
{
  CC2420CsmaP$SubBackoff$setInitialBackoff(CC2420CsmaP$Random$rand16()
   % (0x1F * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP$RadioBackoff$requestInitialBackoff(msg);
}

# 81 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/RadioBackoff.nc"
inline static   void CC2420TransmitP$RadioBackoff$requestInitialBackoff(message_t *arg_0x2ab4c49f74b8){
#line 81
  CC2420CsmaP$SubBackoff$requestInitialBackoff(arg_0x2ab4c49f74b8);
#line 81
}
#line 81
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420CsmaP$sendDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420CsmaP$sendDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 198 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *p_msg, error_t err)
#line 198
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 199
    CC2420CsmaP$sendErr = err;
#line 199
    __nesc_atomic_end(__nesc_atomic); }
  CC2420CsmaP$sendDone_task$postTask();
}

# 73 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Transmit.nc"
inline static   void CC2420TransmitP$Send$sendDone(message_t *arg_0x2ab4c53660c8, error_t arg_0x2ab4c5366380){
#line 73
  CC2420CsmaP$CC2420Transmit$sendDone(arg_0x2ab4c53660c8, arg_0x2ab4c5366380);
#line 73
}
#line 73
# 431 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 432
{

  CC2420TransmitP$CSN$set();
  if (CC2420TransmitP$m_state == CC2420TransmitP$S_CANCEL) {
      /* atomic removed: atomic calls only */
#line 436
      {
        CC2420TransmitP$CSN$clr();
        CC2420TransmitP$SFLUSHTX$strobe();
        CC2420TransmitP$CSN$set();
      }
      CC2420TransmitP$releaseSpiResource();
      CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
      CC2420TransmitP$Send$sendDone(CC2420TransmitP$m_msg, ECANCEL);
    }
  else {
#line 445
    if (!CC2420TransmitP$m_cca) {
        /* atomic removed: atomic calls only */
#line 446
        {
          CC2420TransmitP$m_state = CC2420TransmitP$S_BEGIN_TRANSMIT;
        }
        CC2420TransmitP$attemptSend();
      }
    else {
        CC2420TransmitP$releaseSpiResource();
        /* atomic removed: atomic calls only */
#line 453
        {
          CC2420TransmitP$m_state = CC2420TransmitP$S_SAMPLE_CCA;
        }

        CC2420TransmitP$RadioBackoff$requestInitialBackoff(CC2420TransmitP$m_msg);
        CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myInitialBackoff);
      }
    }
}

# 331 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 331
{
}

# 373 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline    void CC2420SpiP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 373
{
}

# 91 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Fifo.nc"
inline static   void CC2420SpiP$Fifo$writeDone(uint8_t arg_0x2ab4c4d8f108, uint8_t *arg_0x2ab4c4d62100, uint8_t arg_0x2ab4c4d623b8, error_t arg_0x2ab4c4d62670){
#line 91
  switch (arg_0x2ab4c4d8f108) {
#line 91
    case CC2420_TXFIFO:
#line 91
      CC2420TransmitP$TXFIFO$writeDone(arg_0x2ab4c4d62100, arg_0x2ab4c4d623b8, arg_0x2ab4c4d62670);
#line 91
      break;
#line 91
    case CC2420_RXFIFO:
#line 91
      CC2420ReceiveP$RXFIFO$writeDone(arg_0x2ab4c4d62100, arg_0x2ab4c4d623b8, arg_0x2ab4c4d62670);
#line 91
      break;
#line 91
    default:
#line 91
      CC2420SpiP$Fifo$default$writeDone(arg_0x2ab4c4d8f108, arg_0x2ab4c4d62100, arg_0x2ab4c4d623b8, arg_0x2ab4c4d62670);
#line 91
      break;
#line 91
    }
#line 91
}
#line 91
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$RXCTRL1$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_RXCTRL1, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static   cc2420_status_t CC2420ControlP$IOCFG0$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_IOCFG0, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SXOSCON$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SXOSCON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 79 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port14$enable(void)
#line 79
{
#line 79
  P1IE |= 1 << 4;
}

# 31 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$enable(void){
#line 31
  HplMsp430InterruptP$Port14$enable();
#line 31
}
#line 31
# 131 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port14$edge(bool l2h)
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

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$edge(bool arg_0x2ab4c4c44860){
#line 56
  HplMsp430InterruptP$Port14$edge(arg_0x2ab4c4c44860);
#line 56
}
#line 56
# 95 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port14$clear(void)
#line 95
{
#line 95
  P1IFG &= ~(1 << 4);
}

# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$clear(void){
#line 41
  HplMsp430InterruptP$Port14$clear();
#line 41
}
#line 41
# 87 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port14$disable(void)
#line 87
{
#line 87
  P1IE &= ~(1 << 4);
}

# 36 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$disable(void){
#line 36
  HplMsp430InterruptP$Port14$disable();
#line 36
}
#line 36
# 58 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$disable(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$disable();
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$clear();
  }
  return SUCCESS;
}

#line 41
static inline error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$enable(bool rising)
#line 41
{
  /* atomic removed: atomic calls only */
#line 42
  {
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$disable();
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$edge(rising);
    /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$enable();
  }
  return SUCCESS;
}

static inline   error_t /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$enableRisingEdge(void)
#line 50
{
  return /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$enable(TRUE);
}

# 42 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ControlP$InterruptCCA$enableRisingEdge(void){
#line 42
  unsigned char result;
#line 42

#line 42
  result = /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$enableRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$IOCFG1$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_IOCFG1, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 207 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$startOscillator(void)
#line 207
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 208
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_VREG_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 210
            FAIL;

            {
#line 210
              __nesc_atomic_end(__nesc_atomic); 
#line 210
              return __nesc_temp;
            }
          }
        }
#line 213
      CC2420ControlP$m_state = CC2420ControlP$S_XOSC_STARTING;
      CC2420ControlP$IOCFG1$write(CC2420_SFDMUX_XOSC16M_STABLE << 
      CC2420_IOCFG1_CCAMUX);

      CC2420ControlP$InterruptCCA$enableRisingEdge();
      CC2420ControlP$SXOSCON$strobe();

      CC2420ControlP$IOCFG0$write((1 << CC2420_IOCFG0_FIFOP_POLARITY) | (
      127 << CC2420_IOCFG0_FIFOP_THR));

      CC2420ControlP$writeFsctrl();
      CC2420ControlP$writeMdmctrl0();

      CC2420ControlP$RXCTRL1$write(((((((1 << CC2420_RXCTRL1_RXBPF_LOCUR) | (
      1 << CC2420_RXCTRL1_LOW_LOWGAIN)) | (
      1 << CC2420_RXCTRL1_HIGH_HGM)) | (
      1 << CC2420_RXCTRL1_LNA_CAP_ARRAY)) | (
      1 << CC2420_RXCTRL1_RXMIX_TAIL)) | (
      1 << CC2420_RXCTRL1_RXMIX_VCM)) | (
      2 << CC2420_RXCTRL1_RXMIX_CURRENT));
    }
#line 233
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 71 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   error_t CC2420CsmaP$CC2420Power$startOscillator(void){
#line 71
  unsigned char result;
#line 71

#line 71
  result = CC2420ControlP$CC2420Power$startOscillator();
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 207 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$Resource$granted(void)
#line 207
{
  CC2420CsmaP$CC2420Power$startOscillator();
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void CC2420ControlP$Resource$granted(void){
#line 92
  CC2420CsmaP$Resource$granted();
#line 92
}
#line 92
# 30 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$CSN$clr(void){
#line 30
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$clr();
#line 30
}
#line 30
# 390 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  void CC2420ControlP$SpiResource$granted(void)
#line 390
{
  CC2420ControlP$CSN$clr();
  CC2420ControlP$Resource$granted();
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420ControlP$syncDone$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420ControlP$syncDone);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SyncResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP$Resource$release(/*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 45 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SRFOFF$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiP$Strobe$strobe(CC2420_SRFOFF);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 376 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  void CC2420ControlP$SyncResource$granted(void)
#line 376
{
  CC2420ControlP$CSN$clr();
  CC2420ControlP$SRFOFF$strobe();
  CC2420ControlP$writeFsctrl();
  CC2420ControlP$writeMdmctrl0();
  CC2420ControlP$writeId();
  CC2420ControlP$CSN$set();
  CC2420ControlP$CSN$clr();
  CC2420ControlP$SRXON$strobe();
  CC2420ControlP$CSN$set();
  CC2420ControlP$SyncResource$release();
  CC2420ControlP$syncDone$postTask();
}

#line 509
static inline   void CC2420ControlP$ReadRssi$default$readDone(error_t error, uint16_t data)
#line 509
{
}

# 63 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Read.nc"
inline static  void CC2420ControlP$ReadRssi$readDone(error_t arg_0x2ab4c4acc1d0, CC2420ControlP$ReadRssi$val_t arg_0x2ab4c4acc488){
#line 63
  CC2420ControlP$ReadRssi$default$readDone(arg_0x2ab4c4acc1d0, arg_0x2ab4c4acc488);
#line 63
}
#line 63
# 110 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$RssiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiP$Resource$release(/*CC2420ControlC.RssiResource*/CC2420SpiC$2$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 287 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   cc2420_status_t CC2420SpiP$Reg$read(uint8_t addr, uint16_t *data)
#line 287
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 291
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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
  status = CC2420SpiP$SpiByte$write(addr | 0x40);
  *data = (uint16_t )CC2420SpiP$SpiByte$write(0) << 8;
  *data |= CC2420SpiP$SpiByte$write(0);

  return status;
}

# 47 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$RSSI$read(uint16_t *arg_0x2ab4c4b0aa70){
#line 47
  unsigned char result;
#line 47

#line 47
  result = CC2420SpiP$Reg$read(CC2420_RSSI, arg_0x2ab4c4b0aa70);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 395 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  void CC2420ControlP$RssiResource$granted(void)
#line 395
{
  uint16_t data;

#line 397
  CC2420ControlP$CSN$clr();
  CC2420ControlP$RSSI$read(&data);
  CC2420ControlP$CSN$set();

  CC2420ControlP$RssiResource$release();
  data += 0x7f;
  data &= 0x00ff;
  CC2420ControlP$ReadRssi$readDone(SUCCESS, data);
}

# 393 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline  void CC2420TransmitP$SpiResource$granted(void)
#line 393
{
  uint8_t cur_state;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 396
    {
      cur_state = CC2420TransmitP$m_state;
    }
#line 398
    __nesc_atomic_end(__nesc_atomic); }

  switch (cur_state) {
      case CC2420TransmitP$S_LOAD: 
        CC2420TransmitP$loadTXFIFO();
      break;

      case CC2420TransmitP$S_BEGIN_TRANSMIT: 
        CC2420TransmitP$attemptSend();
      break;

      case CC2420TransmitP$S_CANCEL: 
        CC2420TransmitP$CSN$clr();
      CC2420TransmitP$SFLUSHTX$strobe();
      CC2420TransmitP$CSN$set();
      CC2420TransmitP$releaseSpiResource();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 414
        {
          CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
        }
#line 416
        __nesc_atomic_end(__nesc_atomic); }
      CC2420TransmitP$Send$sendDone(CC2420TransmitP$m_msg, ECANCEL);
      break;

      default: 
        CC2420TransmitP$releaseSpiResource();
      break;
    }
}

# 190 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline  void CC2420ReceiveP$SpiResource$granted(void)
#line 190
{
  CC2420ReceiveP$receive();
}

# 367 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline   void CC2420SpiP$Resource$default$granted(uint8_t id)
#line 367
{
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void CC2420SpiP$Resource$granted(uint8_t arg_0x2ab4c4d91020){
#line 92
  switch (arg_0x2ab4c4d91020) {
#line 92
    case /*CC2420ControlC.Spi*/CC2420SpiC$0$CLIENT_ID:
#line 92
      CC2420ControlP$SpiResource$granted();
#line 92
      break;
#line 92
    case /*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$CLIENT_ID:
#line 92
      CC2420ControlP$SyncResource$granted();
#line 92
      break;
#line 92
    case /*CC2420ControlC.RssiResource*/CC2420SpiC$2$CLIENT_ID:
#line 92
      CC2420ControlP$RssiResource$granted();
#line 92
      break;
#line 92
    case /*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID:
#line 92
      CC2420TransmitP$SpiResource$granted();
#line 92
      break;
#line 92
    case /*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID:
#line 92
      CC2420ReceiveP$SpiResource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      CC2420SpiP$Resource$default$granted(arg_0x2ab4c4d91020);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 358 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static inline  void CC2420SpiP$grant$runTask(void)
#line 358
{
  uint8_t holder;

#line 360
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 360
    {
      holder = CC2420SpiP$m_holder;
    }
#line 362
    __nesc_atomic_end(__nesc_atomic); }
  CC2420SpiP$Resource$granted(holder);
}

# 55 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$FSCTRL$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_FSCTRL, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static   cc2420_status_t CC2420ControlP$MDMCTRL0$write(uint16_t arg_0x2ab4c4b083e8){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiP$Reg$write(CC2420_MDMCTRL0, arg_0x2ab4c4b083e8);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 63 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Ram.nc"
inline static   cc2420_status_t CC2420ControlP$PANID$write(uint8_t arg_0x2ab4c4ad63e0, uint8_t *arg_0x2ab4c4ad66d0, uint8_t arg_0x2ab4c4ad6988){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420SpiP$Ram$write(CC2420_RAM_PANID, arg_0x2ab4c4ad63e0, arg_0x2ab4c4ad66d0, arg_0x2ab4c4ad6988);
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 202 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static inline  void CC2420MessageP$CC2420Config$syncDone(error_t error)
#line 202
{
}

# 360 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline  void CC2420ReceiveP$CC2420Config$syncDone(error_t error)
#line 360
{
}

# 53 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Config.nc"
inline static  void CC2420ControlP$CC2420Config$syncDone(error_t arg_0x2ab4c49dea68){
#line 53
  CC2420ReceiveP$CC2420Config$syncDone(arg_0x2ab4c49dea68);
#line 53
  CC2420MessageP$CC2420Config$syncDone(arg_0x2ab4c49dea68);
#line 53
}
#line 53
# 446 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  void CC2420ControlP$syncDone$runTask(void)
#line 446
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 447
    CC2420ControlP$m_sync_busy = FALSE;
#line 447
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP$CC2420Config$syncDone(SUCCESS);
}

# 78 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SyncResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiP$Resource$request(/*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 300 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  error_t CC2420ControlP$CC2420Config$sync(void)
#line 300
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 301
    {
      if (CC2420ControlP$m_sync_busy) {
          {
            unsigned char __nesc_temp = 
#line 303
            FAIL;

            {
#line 303
              __nesc_atomic_end(__nesc_atomic); 
#line 303
              return __nesc_temp;
            }
          }
        }
#line 306
      CC2420ControlP$m_sync_busy = TRUE;
      if (CC2420ControlP$m_state == CC2420ControlP$S_XOSC_STARTED) {
          CC2420ControlP$SyncResource$request();
        }
      else 
#line 309
        {
          CC2420ControlP$syncDone$postTask();
        }
    }
#line 312
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 442
static inline  void CC2420ControlP$sync$runTask(void)
#line 442
{
  CC2420ControlP$CC2420Config$sync();
}

# 92 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x2ab4c47bedc8, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x2ab4c47bd0c8){
#line 92
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$startAt(arg_0x2ab4c47bedc8, arg_0x2ab4c47bd0c8);
#line 92
}
#line 92
# 47 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$start(uint32_t t0, uint32_t dt, bool oneshot)
{
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_dt = dt;
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_oneshot = oneshot;
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$startAt(t0, dt);
}

#line 82
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t t0, uint32_t dt)
{
#line 83
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$start(t0, dt, TRUE);
}

# 118 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x2ab4c4747020, uint32_t arg_0x2ab4c47472e0){
#line 118
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(arg_0x2ab4c4747020, arg_0x2ab4c47472e0);
#line 118
}
#line 118
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$stop(void)
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$disableEvents();
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$stop(void){
#line 62
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Alarm$stop();
#line 62
}
#line 62
# 91 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$stop(void)
{
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$stop();
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop(void){
#line 62
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$stop();
#line 62
}
#line 62
# 60 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop(void)
{
#line 61
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop();
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$stop(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop();
#line 67
}
#line 67
# 89 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask(void)
{




  uint32_t now = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow();
  int32_t min_remaining = (1UL << 31) - 1;
  bool min_remaining_isset = FALSE;
  uint8_t num;

  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$stop();

  for (num = 0; num < /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num];

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
        /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(now);
        }
      else {
#line 124
        /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(now, min_remaining);
        }
    }
}

# 16 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  error_t UDPEchoP$Status$sendto(struct sockaddr_in6 *arg_0x2ab4c472d660, void *arg_0x2ab4c472d948, uint16_t arg_0x2ab4c472dc28){
#line 16
  unsigned char result;
#line 16

#line 16
  result = UdpP$UDP$sendto(1U, arg_0x2ab4c472d660, arg_0x2ab4c472d948, arg_0x2ab4c472dc28);
#line 16

#line 16
  return result;
#line 16
}
#line 16
# 406 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  void ICMPResponderP$Statistics$get(icmp_statistics_t *statistics)
#line 406
{
  statistics = &ICMPResponderP$stats;
}

# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
inline static  void UDPEchoP$ICMPStats$get(UDPEchoP$ICMPStats$stat_str *arg_0x2ab4c473a410){
#line 29
  ICMPResponderP$Statistics$get(arg_0x2ab4c473a410);
#line 29
}
#line 29
# 1227 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$Statistics$get(route_statistics_t *statistics)
#line 1227
{







  __nesc_hton_uint8((unsigned char *)&statistics->hop_limit, IPRoutingP$IPRouting$getHopLimit());
  __nesc_hton_uint16((unsigned char *)&statistics->parent, (uint16_t )IPRoutingP$default_route->neighbor);
  __nesc_hton_uint16((unsigned char *)&statistics->parent_metric, IPRoutingP$IPRouting$getQuality());
  __nesc_hton_uint16((unsigned char *)&statistics->parent_etx, IPRoutingP$getMetric(IPRoutingP$default_route));
}

# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
inline static  void UDPEchoP$RouteStats$get(UDPEchoP$RouteStats$stat_str *arg_0x2ab4c473a410){
#line 29
  IPRoutingP$Statistics$get(arg_0x2ab4c473a410);
#line 29
}
#line 29
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void UDPEchoP$StatusTimer$startPeriodic(uint32_t arg_0x2ab4c474c770){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(0U, arg_0x2ab4c474c770);
#line 53
}
#line 53
# 115 "UDPEchoP.nc"
static inline  void UDPEchoP$StatusTimer$fired(void)
#line 115
{
  unsigned int __nesc_temp45;
  unsigned char *__nesc_temp44;
  unsigned int __nesc_temp43;
  unsigned char *__nesc_temp42;
#line 116
  uint8_t status[UDPEchoP$STATUS_SIZE];
  nx_struct udp_report *payload;

#line 118
  ;

  (__nesc_temp42 = (unsigned char *)&UDPEchoP$stats.total, __nesc_hton_uint16(__nesc_temp42, (__nesc_temp43 = __nesc_ntoh_uint16(__nesc_temp42)) + 1), __nesc_temp43);

  if (!UDPEchoP$timerStarted) {
      UDPEchoP$StatusTimer$startPeriodic(1024 * 45L);
      UDPEchoP$timerStarted = TRUE;
    }

  payload = (nx_struct udp_report *)status;

  (__nesc_temp44 = (unsigned char *)&UDPEchoP$stats.seqno, __nesc_hton_uint16(__nesc_temp44, (__nesc_temp45 = __nesc_ntoh_uint16(__nesc_temp44)) + 1), __nesc_temp45);
  __nesc_hton_uint16((unsigned char *)&UDPEchoP$stats.sender, TOS_NODE_ID);


  UDPEchoP$RouteStats$get(& payload->route);
  UDPEchoP$ICMPStats$get(& payload->icmp);
  ip_memcpy(& payload->udp, &UDPEchoP$stats, sizeof(udp_statistics_t ));

  UDPEchoP$Status$sendto(&UDPEchoP$route_dest, status, UDPEchoP$STATUS_SIZE);
}

# 202 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static inline  void PacketLinkP$DelayTimer$fired(void)
#line 202
{
  if (PacketLinkP$SendState$getState() == PacketLinkP$S_SENDING) {
      PacketLinkP$send$postTask();
    }
}

# 357 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP$ip_print_heap(void)
#line 357
{
}

#line 341
static inline void IPDispatchP$forward_age(void *elt)
#line 341
{
  forward_entry_t *fwd = (forward_entry_t *)elt;

#line 343
  switch (fwd->timeout) {
      case T_ACTIVE: 
        fwd->timeout = T_ZOMBIE;
#line 345
      break;
      case T_FAILED1: 
        fwd->timeout = T_FAILED2;
#line 347
      break;
      case T_ZOMBIE: 
        case T_FAILED2: 
          fwd->s_info->failed = TRUE;
      if (-- fwd->s_info->refcount == 0) {
#line 351
        IPDispatchP$SendInfoPool$put(fwd->s_info);
        }
#line 352
      fwd->timeout = T_UNUSED;
      break;
    }
}

#line 322
static inline void IPDispatchP$reconstruct_age(void *elt)
#line 322
{
  reconstruct_t *recon = (reconstruct_t *)elt;

#line 324
  switch (recon->timeout) {
      case T_ACTIVE: 
        recon->timeout = T_ZOMBIE;
#line 326
      break;
      case T_FAILED1: 
        recon->timeout = T_FAILED2;
#line 328
      break;
      case T_ZOMBIE: 
        case T_FAILED2: 

          if (recon->buf != (void *)0) {
              ip_free(recon->buf);
            }
      recon->timeout = T_UNUSED;
      recon->buf = (void *)0;
      break;
    }
}

#line 368
static inline  void IPDispatchP$ExpireTimer$fired(void)
#line 368
{
  if (0) {
#line 369
    return;
    }
#line 370
  IPDispatchP$table_map(&IPDispatchP$recon_cache, IPDispatchP$reconstruct_age);
  IPDispatchP$table_map(&IPDispatchP$forward_cache, IPDispatchP$forward_age);







  IPDispatchP$ip_print_heap();
}

# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
inline static  void IPRoutingP$ICMP$sendSolicitations(void){
#line 28
  ICMPResponderP$ICMP$sendSolicitations();
#line 28
}
#line 28
# 1047 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  bool IPRoutingP$IPRouting$hasRoute(void)
#line 1047
{
  return ((&IPRoutingP$neigh_table[0])->flags & T_VALID_MASK) == T_VALID_MASK;
}

#line 1214
static inline  void IPRoutingP$ICMP$solicitationDone(void)
#line 1214
{


  ;

  IPRoutingP$soliciting = FALSE;

  if (!IPRoutingP$IPRouting$hasRoute()) {
      IPRoutingP$ICMP$sendSolicitations();
      IPRoutingP$soliciting = TRUE;
    }
}

# 1119 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$ICMP$solicitationDone(void)
#line 1119
{
}

# 31 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
inline static  void ICMPResponderP$ICMP$solicitationDone(void){
#line 31
  IPDispatchP$ICMP$solicitationDone();
#line 31
  IPRoutingP$ICMP$solicitationDone();
#line 31
}
#line 31
# 29 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  void ICMPResponderP$IPAddress$getLLAddr(struct in6_addr *arg_0x2ab4c4951020){
#line 29
  IPAddressP$IPAddress$getLLAddr(arg_0x2ab4c4951020);
#line 29
}
#line 29
# 149 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline void ICMPResponderP$sendSolicitation(void)
#line 149
{
  struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ) + sizeof(rsol_t ));
  rsol_t *msg = (rsol_t *)(ipmsg + 1);

  if (ipmsg == (void *)0) {
#line 153
    return;
    }
  ;


  __nesc_hton_uint8((unsigned char *)&msg->type, ICMP_TYPE_ROUTER_SOL);
  __nesc_hton_uint8((unsigned char *)&msg->code, 0);
  __nesc_hton_uint16((unsigned char *)&msg->cksum, 0);
  __nesc_hton_uint32((unsigned char *)&msg->reserved, 0);

  ipmsg->headers = (void *)0;
  ipmsg->data = (void *)msg;
  ipmsg->data_len = sizeof(rsol_t );


  ipmsg->hdr.hlim = 0xff;


  ICMPResponderP$IPAddress$getLLAddr(& ipmsg->hdr.ip6_src);
  ip_memclr((uint8_t *)& ipmsg->hdr.ip6_dst, 16);
  ipmsg->hdr.ip6_dst.in6_u.u6_addr16[0] = (((uint16_t )0xff02 << 8) | ((uint16_t )0xff02 >> 8)) & 0xffff;
  ipmsg->hdr.ip6_dst.in6_u.u6_addr16[7] = (((uint16_t )2 << 8) | ((uint16_t )2 >> 8)) & 0xffff;

  __nesc_hton_uint16((unsigned char *)&msg->cksum, ICMPResponderP$ICMP$cksum(ipmsg, IANA_ICMP));

  ICMPResponderP$IP$send(ipmsg);

  ip_free(ipmsg);
}

#line 359
static inline  void ICMPResponderP$Solicitation$fired(void)
#line 359
{
  ICMPResponderP$sendSolicitation();
  ;
  ICMPResponderP$solicitation_period <<= 1;
  if (ICMPResponderP$solicitation_period < TRICKLE_MAX) {
      ICMPResponderP$Solicitation$startOneShot(ICMPResponderP$solicitation_period);
    }
  else 
#line 365
    {
      ICMPResponderP$ICMP$solicitationDone();
    }
}

# 60 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  uint16_t ICMPResponderP$IPRouting$getQuality(void){
#line 60
  unsigned int result;
#line 60

#line 60
  result = IPRoutingP$IPRouting$getQuality();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 28 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  struct in6_addr *ICMPResponderP$IPAddress$getPublicAddr(void){
#line 28
  struct in6_addr *result;
#line 28

#line 28
  result = IPAddressP$IPAddress$getPublicAddr();
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 58 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPRouting.nc"
inline static  uint8_t ICMPResponderP$IPRouting$getHopLimit(void){
#line 58
  unsigned char result;
#line 58

#line 58
  result = IPRoutingP$IPRouting$getHopLimit();
#line 58

#line 58
  return result;
#line 58
}
#line 58
#line 84
inline static  bool ICMPResponderP$IPRouting$hasRoute(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = IPRoutingP$IPRouting$hasRoute();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 238 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline void ICMPResponderP$sendAdvertisement(void)
#line 238
{
  struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ) + 
  sizeof(radv_t ) + 
  sizeof(pfx_t ) + 
  sizeof(rqual_t ));
  uint16_t len = sizeof(radv_t );
  radv_t *r = (radv_t *)(ipmsg + 1);
  pfx_t *p = (pfx_t *)r->options;
  rqual_t *q = (rqual_t *)(p + 1);

  if (ipmsg == (void *)0) {
#line 248
    return;
    }
  if (!ICMPResponderP$IPRouting$hasRoute()) {
      ip_free(ipmsg);
      return;
    }

  __nesc_hton_uint8((unsigned char *)&r->type, ICMP_TYPE_ROUTER_ADV);
  __nesc_hton_uint8((unsigned char *)&r->code, 0);
  __nesc_hton_uint8((unsigned char *)&r->hlim, ICMPResponderP$IPRouting$getHopLimit());
  __nesc_hton_uint8((unsigned char *)&r->flags, 0);
  __nesc_hton_uint16((unsigned char *)&r->lifetime, 1);
  __nesc_hton_uint32((unsigned char *)&r->reachable_time, 0);
  __nesc_hton_uint32((unsigned char *)&r->retrans_time, 0);

  ipmsg->hdr.hlim = 0xff;

  if (globalPrefix) {
      len += sizeof(pfx_t );
      __nesc_hton_uint8((unsigned char *)&p->type, ICMP_EXT_TYPE_PREFIX);
      __nesc_hton_uint8((unsigned char *)&p->length, sizeof(pfx_t ) >> 3);
      __nesc_hton_uint8((unsigned char *)&p->pfx_len, 64);
      ip_memcpy(p->prefix, ICMPResponderP$IPAddress$getPublicAddr(), 8);
    }

  len += sizeof(rqual_t );
  __nesc_hton_uint8((unsigned char *)&q->type, ICMP_EXT_TYPE_BEACON);
  __nesc_hton_uint8((unsigned char *)&q->length, sizeof(rqual_t ) >> 3);
#line 275
  ;
  __nesc_hton_uint16((unsigned char *)&q->metric, ICMPResponderP$IPRouting$getQuality());

  ICMPResponderP$IPAddress$getLLAddr(& ipmsg->hdr.ip6_src);
  ip_memclr((uint8_t *)& ipmsg->hdr.ip6_dst, 16);
  ipmsg->hdr.ip6_dst.in6_u.u6_addr16[0] = (((uint16_t )0xff02 << 8) | ((uint16_t )0xff02 >> 8)) & 0xffff;
  ipmsg->hdr.ip6_dst.in6_u.u6_addr16[7] = (((uint16_t )1 << 8) | ((uint16_t )1 >> 8)) & 0xffff;


  ;

  if (__nesc_ntoh_uint8((unsigned char *)&r->hlim) >= 0xf0) {
      ip_free(ipmsg);
      return;
    }

  ipmsg->data = (void *)r;
  ipmsg->data_len = len;
  ipmsg->headers = (void *)0;

  __nesc_hton_uint16((unsigned char *)&r->cksum, 0);
  __nesc_hton_uint16((unsigned char *)&r->cksum, ICMPResponderP$ICMP$cksum(ipmsg, IANA_ICMP));

  ICMPResponderP$IP$send(ipmsg);
  ip_free(ipmsg);
}

#line 370
static inline  void ICMPResponderP$Advertisement$fired(void)
#line 370
{
  ;
  ICMPResponderP$sendAdvertisement();
  ICMPResponderP$advertisement_period <<= 1;
  if (ICMPResponderP$advertisement_period < TRICKLE_MAX) {
      ICMPResponderP$Advertisement$startOneShot(ICMPResponderP$advertisement_period);
    }
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$size_type /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$get(void){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   uint32_t /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$LocalTime$get(void)
{
  return /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$get();
}

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/LocalTime.nc"
inline static   uint32_t ICMPResponderP$LocalTime$get(void){
#line 50
  unsigned long result;
#line 50

#line 50
  result = /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$LocalTime$get();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 183 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline void ICMPResponderP$sendPing(struct in6_addr *dest, uint16_t seqno)
#line 183
{
  struct split_ip_msg *ipmsg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ) + 
  sizeof(icmp_echo_hdr_t ) + 
  sizeof(nx_uint32_t ));
  icmp_echo_hdr_t *e_hdr = (icmp_echo_hdr_t *)ipmsg->next;
  nx_uint32_t *sendTime = (nx_uint32_t *)(e_hdr + 1);

  if (ipmsg == (void *)0) {
#line 190
    return;
    }
#line 191
  ipmsg->headers = (void *)0;
  ipmsg->data = (void *)e_hdr;
  ipmsg->data_len = sizeof(icmp_echo_hdr_t ) + sizeof(nx_uint32_t );

  __nesc_hton_uint8((unsigned char *)&e_hdr->type, ICMP_TYPE_ECHO_REQUEST);
  __nesc_hton_uint8((unsigned char *)&e_hdr->code, 0);
  __nesc_hton_uint16((unsigned char *)&e_hdr->cksum, 0);
  __nesc_hton_uint16((unsigned char *)&e_hdr->ident, ICMPResponderP$ping_ident);
  __nesc_hton_uint16((unsigned char *)&e_hdr->seqno, seqno);
  __nesc_hton_uint32((unsigned char *)&*sendTime, ICMPResponderP$LocalTime$get());

  ip_memcpy(& ipmsg->hdr.ip6_dst, dest->in6_u.u6_addr8, 16);
  ICMPResponderP$IPAddress$getIPAddr(& ipmsg->hdr.ip6_src);

  __nesc_hton_uint16((unsigned char *)&e_hdr->cksum, ICMPResponderP$ICMP$cksum(ipmsg, IANA_ICMP));

  ICMPResponderP$IP$send(ipmsg);
  ip_free(ipmsg);
}

# 67 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void ICMPResponderP$PingTimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(6U);
#line 67
}
#line 67
# 272 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline  void UDPShellP$ICMPPing$pingDone(uint16_t ping_rcv, uint16_t ping_n)
#line 272
{
  int len;

#line 274
  len = snprintf(UDPShellP$reply_buf, MAX_REPLY_LEN, UDPShellP$ping_summary, ping_n, ping_rcv);
  UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, len);
}

# 418 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline   void ICMPResponderP$ICMPPing$default$pingDone(uint16_t client, uint16_t n, uint16_t m)
#line 418
{
}

# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
inline static  void ICMPResponderP$ICMPPing$pingDone(uint16_t arg_0x2ab4c589d740, uint16_t arg_0x2ab4c583b5d0, uint16_t arg_0x2ab4c583b890){
#line 10
  switch (arg_0x2ab4c589d740) {
#line 10
    case 0U:
#line 10
      UDPShellP$ICMPPing$pingDone(arg_0x2ab4c583b5d0, arg_0x2ab4c583b890);
#line 10
      break;
#line 10
    default:
#line 10
      ICMPResponderP$ICMPPing$default$pingDone(arg_0x2ab4c589d740, arg_0x2ab4c583b5d0, arg_0x2ab4c583b890);
#line 10
      break;
#line 10
    }
#line 10
}
#line 10
# 393 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  void ICMPResponderP$PingTimer$fired(void)
#line 393
{

  if (ICMPResponderP$ping_seq == ICMPResponderP$ping_n) {
      ICMPResponderP$ICMPPing$pingDone(ICMPResponderP$ping_ident, ICMPResponderP$ping_rcv, ICMPResponderP$ping_n);
      ICMPResponderP$PingTimer$stop();
      return;
    }
  ICMPResponderP$sendPing(&ICMPResponderP$ping_dest, ICMPResponderP$ping_seq);
  ICMPResponderP$ping_seq++;
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void IPRoutingP$TrafficGenTimer$startOneShot(uint32_t arg_0x2ab4c474b108){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(7U, arg_0x2ab4c474b108);
#line 62
}
#line 62
# 15 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IP.nc"
inline static  error_t IPRoutingP$TGenSend$send(struct split_ip_msg *arg_0x2ab4c497f270){
#line 15
  unsigned char result;
#line 15

#line 15
  result = IPDispatchP$IP$send(NXTHDR_UNKNOWN, arg_0x2ab4c497f270);
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 30 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/IPAddress.nc"
inline static  void IPRoutingP$IPAddress$getIPAddr(struct in6_addr *arg_0x2ab4c49518e8){
#line 30
  IPAddressP$IPAddress$getIPAddr(arg_0x2ab4c49518e8);
#line 30
}
#line 30
# 119 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$TrafficGenTimer$fired(void)
#line 119
{
  struct split_ip_msg *msg;

#line 121
  if (IPRoutingP$traffic_sent) {
#line 121
    goto done;
    }
#line 122
  msg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ));
  if (msg == (void *)0) {
#line 123
    goto done;
    }
  ip_memclr((uint8_t *)& msg->hdr, sizeof(struct ip6_hdr ));
  ip_memclr((uint8_t *)& msg->hdr.ip6_dst, 16);
  msg->hdr.ip6_dst.in6_u.u6_addr16[0] = (((uint16_t )0xff05 << 8) | ((uint16_t )0xff05 >> 8)) & 0xffff;
  msg->hdr.ip6_dst.in6_u.u6_addr16[7] = (((uint16_t )1 << 8) | ((uint16_t )1 >> 8)) & 0xffff;
  IPRoutingP$IPAddress$getIPAddr(& msg->hdr.ip6_src);
  msg->data = (void *)0;
  msg->data_len = 0;
  msg->headers = (void *)0;

  ;
  IPRoutingP$TGenSend$send(msg);
  ip_free(msg);
  done: 

    ;
  IPRoutingP$traffic_sent = FALSE;
  IPRoutingP$traffic_interval *= 2;
  if (IPRoutingP$traffic_interval > TGEN_MAX_INTERVAL) {
    IPRoutingP$traffic_interval = TGEN_MAX_INTERVAL;
    }
#line 144
  IPRoutingP$TrafficGenTimer$startOneShot(IPRoutingP$traffic_interval);
}

# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t IPRoutingP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 1276 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline void IPRoutingP$updateRankings(void)
#line 1276
{
  uint8_t i;
  bool evicted = FALSE;

  for (i = 0; i < N_NEIGH; i++) {
      IPRoutingP$neigh_table[i].flags &= ~T_EVICT_MASK;
      if (!(((&IPRoutingP$neigh_table[i])->flags & T_VALID_MASK) == T_VALID_MASK)) {
#line 1282
        continue;
        }
#line 1283
      IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].total += IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].total;
      IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].receptions += IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].receptions;
      IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].success += IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].success;

      if (IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].total & 0xf000) {


          IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].total >>= 1;
          IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].success >>= 1;
        }

      if (IPRoutingP$neigh_table[i].stats[IPRoutingP$LONG_EPOCH].total > CONF_EVICT_THRESHOLD) {
        (&IPRoutingP$neigh_table[i])->flags |= T_MATURE_MASK;
        }
      if (((&IPRoutingP$neigh_table[i])->flags & T_MATURE_MASK) == T_MATURE_MASK) {
          uint16_t cost;

          if (IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].total == 0) {
#line 1300
            goto done_iter;
            }
#line 1301
          if (IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].success == 0) {
              cost = 0xff;
            }
          else 
#line 1303
            {
              cost = 10 * IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].total / 
              IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].success;
            }
          if (cost > LINK_EVICT_THRESH) {
              ;
              IPRoutingP$neigh_table[i].flags |= T_EVICT_MASK;
            }
        }
      done_iter: 
        IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].total = 0;
      IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].receptions = 0;
      IPRoutingP$neigh_table[i].stats[IPRoutingP$SHORT_EPOCH].success = 0;
    }
  for (i = 0; i < N_NEIGH; i++) {
      if (((&IPRoutingP$neigh_table[i])->flags & T_VALID_MASK) == T_VALID_MASK && 
      IPRoutingP$neigh_table[i].flags & T_EVICT_MASK) {









          evicted = TRUE;
        }
    }
  if (evicted) {
    IPRoutingP$ICMP$sendSolicitations();
    }
}

# 33 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMP.nc"
inline static  void IPRoutingP$ICMP$sendAdvertisements(void){
#line 33
  ICMPResponderP$ICMP$sendAdvertisements();
#line 33
}
#line 33
# 1179 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$SortTimer$fired(void)
#line 1179
{
  ;
  IPRoutingP$printTable();

  if (!IPRoutingP$IPRouting$hasRoute() && !IPRoutingP$soliciting) {
      IPRoutingP$ICMP$sendSolicitations();
      IPRoutingP$soliciting = TRUE;
    }

  if (IPRoutingP$checkThresh(IPRoutingP$IPRouting$getQuality(), IPRoutingP$last_qual, 5) != WITHIN_THRESH || 
  IPRoutingP$last_hops != IPRoutingP$IPRouting$getHopLimit()) {
      IPRoutingP$ICMP$sendAdvertisements();
      IPRoutingP$last_qual = IPRoutingP$IPRouting$getQuality();
      IPRoutingP$last_hops = IPRoutingP$IPRouting$getHopLimit();
    }

  IPRoutingP$updateRankings();

  if (IPRoutingP$Random$rand16() % 32 < 8) {
      ;
      IPRoutingP$chooseNewRandomDefault(FALSE);
    }
  else 
#line 1200
    {

      IPRoutingP$default_route_failures = 0;
    }
}

# 193 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline   void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num)
{
}

# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$fired(uint8_t arg_0x2ab4c48f8d38){
#line 72
  switch (arg_0x2ab4c48f8d38) {
#line 72
    case 0U:
#line 72
      UDPEchoP$StatusTimer$fired();
#line 72
      break;
#line 72
    case 2U:
#line 72
      PacketLinkP$DelayTimer$fired();
#line 72
      break;
#line 72
    case 3U:
#line 72
      IPDispatchP$ExpireTimer$fired();
#line 72
      break;
#line 72
    case 4U:
#line 72
      ICMPResponderP$Solicitation$fired();
#line 72
      break;
#line 72
    case 5U:
#line 72
      ICMPResponderP$Advertisement$fired();
#line 72
      break;
#line 72
    case 6U:
#line 72
      ICMPResponderP$PingTimer$fired();
#line 72
      break;
#line 72
    case 7U:
#line 72
      IPRoutingP$TrafficGenTimer$fired();
#line 72
      break;
#line 72
    case 8U:
#line 72
      IPRoutingP$SortTimer$fired();
#line 72
      break;
#line 72
    default:
#line 72
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(arg_0x2ab4c48f8d38);
#line 72
      break;
#line 72
    }
#line 72
}
#line 72
# 128 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow());
}

# 72 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired(void){
#line 72
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired();
#line 72
}
#line 72
# 80 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getAlarm(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 82
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type __nesc_temp = 
#line 82
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt;

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

# 105 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(void){
#line 105
  unsigned long result;
#line 105

#line 105
  result = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$getAlarm();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 63 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask(void)
{
  if (/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_oneshot == FALSE) {
    /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$start(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(), /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_dt, FALSE);
    }
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired();
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$CC2int(/*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$__nesc_unnamed4400 {
#line 46
    /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

static inline uint16_t /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$compareControl(void)
{
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$cc_t x = { 
  .cm = 1, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 0, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$CC2int(x);
}

#line 94
static inline   void /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$setControlAsCompare(void)
{
  * (volatile uint16_t *)386U = /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$compareControl();
}

# 36 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$setControlAsCompare(void){
#line 36
  /*Msp430TimerC.Msp430TimerB0*/Msp430TimerCapComP$3$Control$setControlAsCompare();
#line 36
}
#line 36
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline  error_t /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Init$init(void)
{
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$disableEvents();
  /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Msp430TimerControl$setControlAsCompare();
  return SUCCESS;
}

# 82 "/home/sdawson/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static inline   am_group_t ActiveMessageAddressC$ActiveMessageAddress$amGroup(void)
#line 82
{
  am_group_t myGroup;

  /* atomic removed: atomic calls only */
#line 84
  myGroup = ActiveMessageAddressC$group;
  return myGroup;
}

# 55 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static   am_group_t CC2420ControlP$ActiveMessageAddress$amGroup(void){
#line 55
  unsigned char result;
#line 55

#line 55
  result = ActiveMessageAddressC$ActiveMessageAddress$amGroup();
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 95 "/home/sdawson/cvs/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
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

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ActiveMessageAddress.nc"
inline static   am_addr_t CC2420ControlP$ActiveMessageAddress$amAddress(void){
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
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 5;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$VREN$makeOutput(void){
#line 35
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 6;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$makeOutput(void){
#line 35
  /*HplCC2420PinsC.RSTNM*/Msp430GpioC$7$GeneralIO$makeOutput();
#line 35
}
#line 35
# 52 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$makeOutput(void)
#line 52
{
  /* atomic removed: atomic calls only */
#line 52
  * (volatile uint8_t *)30U |= 0x01 << 2;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$makeOutput(void){
#line 71
  /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$makeOutput();
#line 71
}
#line 71
# 43 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$makeOutput(void)
#line 43
{
#line 43
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$HplGeneralIO$makeOutput();
}

# 35 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$CSN$makeOutput(void){
#line 35
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$makeOutput();
#line 35
}
#line 35
# 121 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline  error_t CC2420ControlP$Init$init(void)
#line 121
{
  CC2420ControlP$CSN$makeOutput();
  CC2420ControlP$RSTN$makeOutput();
  CC2420ControlP$VREN$makeOutput();

  CC2420ControlP$m_short_addr = CC2420ControlP$ActiveMessageAddress$amAddress();
  CC2420ControlP$m_pan = CC2420ControlP$ActiveMessageAddress$amGroup();
  CC2420ControlP$m_tx_power = 31;
  CC2420ControlP$m_channel = 17;





  CC2420ControlP$addressRecognition = TRUE;





  CC2420ControlP$hwAddressRecognition = FALSE;






  CC2420ControlP$autoAckEnabled = TRUE;



  CC2420ControlP$hwAutoAckDefault = TRUE;
  CC2420ControlP$hwAddressRecognition = TRUE;





  return SUCCESS;
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
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

# 45 "/home/sdawson/cvs/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline  error_t /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init(void)
#line 45
{
  memset(/*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$NO_ENTRY, sizeof /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$resQ);
  return SUCCESS;
}

# 41 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t UniqueSendP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgC$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 62 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueSendP.nc"
static inline  error_t UniqueSendP$Init$init(void)
#line 62
{
  UniqueSendP$localSendId = UniqueSendP$Random$rand16();
  return SUCCESS;
}

# 44 "/home/sdawson/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static inline  error_t RandomMlcgC$Init$init(void)
#line 44
{
  /* atomic removed: atomic calls only */
#line 45
  RandomMlcgC$seed = (uint32_t )(TOS_NODE_ID + 1);

  return SUCCESS;
}

# 71 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/unique/UniqueReceiveP.nc"
static inline  error_t UniqueReceiveP$Init$init(void)
#line 71
{
  int i;

#line 73
  for (i = 0; i < 4; i++) {
      UniqueReceiveP$receivedMessages[i].source = (am_addr_t )0xFFFF;
      UniqueReceiveP$receivedMessages[i].dsn = 0;
    }
  return SUCCESS;
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
static inline  uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$CC2int(/*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t x)
#line 46
{
#line 46
  union /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$__nesc_unnamed4401 {
#line 46
    /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t f;
#line 46
    uint16_t t;
  } 
#line 46
  c = { .f = x };

#line 46
  return c.t;
}

static inline uint16_t /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$compareControl(void)
{
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$cc_t x = { 
  .cm = 1, 
  .ccis = 0, 
  .clld = 0, 
  .cap = 0, 
  .ccie = 0 };

  return /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$CC2int(x);
}

#line 94
static inline   void /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$setControlAsCompare(void)
{
  * (volatile uint16_t *)390U = /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$compareControl();
}

# 36 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerControl.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$setControlAsCompare(void){
#line 36
  /*Msp430TimerC.Msp430TimerB2*/Msp430TimerCapComP$5$Control$setControlAsCompare();
#line 36
}
#line 36
# 42 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430AlarmC.nc"
static inline  error_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Init$init(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$disableEvents();
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Msp430TimerControl$setControlAsCompare();
  return SUCCESS;
}

# 50 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$makeInput(void)
#line 50
{
  /* atomic removed: atomic calls only */
#line 50
  * (volatile uint8_t *)30U &= ~(0x01 << 1);
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$makeInput(void){
#line 64
  /*HplMsp430GeneralIOC.P41*/HplMsp430GeneralIOP$25$IO$makeInput();
#line 64
}
#line 64
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$makeInput(void)
#line 41
{
#line 41
  /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$HplGeneralIO$makeInput();
}

# 33 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$SFD$makeInput(void){
#line 33
  /*HplCC2420PinsC.SFDM*/Msp430GpioC$8$GeneralIO$makeInput();
#line 33
}
#line 33


inline static   void CC2420TransmitP$CSN$makeOutput(void){
#line 35
  /*HplCC2420PinsC.CSNM*/Msp430GpioC$4$GeneralIO$makeOutput();
#line 35
}
#line 35
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$makeInput(void)
#line 50
{
  /* atomic removed: atomic calls only */
#line 50
  * (volatile uint8_t *)34U &= ~(0x01 << 4);
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$makeInput(void){
#line 64
  /*HplMsp430GeneralIOC.P14*/HplMsp430GeneralIOP$4$IO$makeInput();
#line 64
}
#line 64
# 41 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$makeInput(void)
#line 41
{
#line 41
  /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$HplGeneralIO$makeInput();
}

# 33 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CCA$makeInput(void){
#line 33
  /*HplCC2420PinsC.CCAM*/Msp430GpioC$3$GeneralIO$makeInput();
#line 33
}
#line 33
# 140 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static inline  error_t CC2420TransmitP$Init$init(void)
#line 140
{
  CC2420TransmitP$CCA$makeInput();
  CC2420TransmitP$CSN$makeOutput();
  CC2420TransmitP$SFD$makeInput();
  return SUCCESS;
}

# 118 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline  error_t CC2420ReceiveP$Init$init(void)
#line 118
{
  CC2420ReceiveP$m_p_rx_buf = &CC2420ReceiveP$m_rx_buf;
  return SUCCESS;
}

# 65 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
static inline  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Init$init(void)
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$queue[i] = &/*IPDispatchC.FragPool.PoolP*/PoolP$0$pool[i];
    }
  /*IPDispatchC.FragPool.PoolP*/PoolP$0$free = 12;
  /*IPDispatchC.FragPool.PoolP*/PoolP$0$index = 0;
  return SUCCESS;
}

#line 65
static inline  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Init$init(void)
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$queue[i] = &/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool[i];
    }
  /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free = 12;
  /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index = 0;
  return SUCCESS;
}

#line 65
static inline  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Init$init(void)
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$queue[i] = &/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool[i];
    }
  /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free = 12;
  /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index = 0;
  return SUCCESS;
}

# 42 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static inline  error_t UdpP$Init$init(void)
#line 42
{
  ip_memclr((uint8_t *)UdpP$local_ports, sizeof(uint16_t ) * UdpP$N_CLIENTS);
  return SUCCESS;
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t RealMainP$SoftwareInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = UdpP$Init$init();
#line 51
  result = ecombine(result, /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Init$init());
#line 51
  result = ecombine(result, /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Init$init());
#line 51
  result = ecombine(result, /*IPDispatchC.FragPool.PoolP*/PoolP$0$Init$init());
#line 51
  result = ecombine(result, CC2420ReceiveP$Init$init());
#line 51
  result = ecombine(result, CC2420TransmitP$Init$init());
#line 51
  result = ecombine(result, /*AlarmMultiplexC.Alarm.Alarm32khz32C.AlarmC.Msp430Alarm*/Msp430AlarmC$1$Init$init());
#line 51
  result = ecombine(result, UniqueReceiveP$Init$init());
#line 51
  result = ecombine(result, RandomMlcgC$Init$init());
#line 51
  result = ecombine(result, UniqueSendP$Init$init());
#line 51
  result = ecombine(result, /*Msp430UsartShare0P.ArbiterC.Queue*/FcfsResourceQueueC$0$Init$init());
#line 51
  result = ecombine(result, StateImplP$Init$init());
#line 51
  result = ecombine(result, CC2420ControlP$Init$init());
#line 51
  result = ecombine(result, /*HilTimerMilliC.AlarmMilli32C.AlarmFrom.Msp430Alarm*/Msp430AlarmC$0$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  error_t UDPEchoP$Status$bind(uint16_t arg_0x2ab4c472fcc8){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP$UDP$bind(1U, arg_0x2ab4c472fcc8);
#line 10

#line 10
  return result;
#line 10
}
#line 10
inline static  error_t UDPEchoP$Echo$bind(uint16_t arg_0x2ab4c472fcc8){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP$UDP$bind(0U, arg_0x2ab4c472fcc8);
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 118 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/PrintfUART.h"
static inline void printfUART_init(void)
#line 118
{
}

# 410 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  void ICMPResponderP$Statistics$clear(void)
#line 410
{
  ip_memclr((uint8_t *)&ICMPResponderP$stats, sizeof(icmp_statistics_t ));
}

# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
inline static  void UDPEchoP$ICMPStats$clear(void){
#line 34
  ICMPResponderP$Statistics$clear();
#line 34
}
#line 34
# 1241 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline  void IPRoutingP$Statistics$clear(void)
#line 1241
{
}

# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
inline static  void UDPEchoP$RouteStats$clear(void){
#line 34
  IPRoutingP$Statistics$clear();
#line 34
}
#line 34
# 1135 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$Statistics$clear(void)
#line 1135
{
  ip_memclr((uint8_t *)&IPDispatchP$stats, sizeof(ip_statistics_t ));
}

# 34 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/Statistics.nc"
inline static  void UDPEchoP$IPStats$clear(void){
#line 34
  IPDispatchP$Statistics$clear();
#line 34
}
#line 34
# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t IPDispatchP$RadioControl$start(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = CC2420CsmaP$SplitControl$start();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 231 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  error_t IPDispatchP$SplitControl$start(void)
#line 231
{
  if (0) {
#line 232
    return FAIL;
    }
#line 233
  return IPDispatchP$RadioControl$start();
}

# 83 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t UDPEchoP$RadioControl$start(void){
#line 83
  unsigned char result;
#line 83

#line 83
  result = IPDispatchP$SplitControl$start();
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 65 "UDPEchoP.nc"
static inline  void UDPEchoP$Boot$booted(void)
#line 65
{
  ;
  UDPEchoP$RadioControl$start();
  UDPEchoP$timerStarted = FALSE;

  UDPEchoP$IPStats$clear();
  UDPEchoP$RouteStats$clear();
  UDPEchoP$ICMPStats$clear();
  printfUART_init();

  __nesc_hton_uint16((unsigned char *)&UDPEchoP$stats.total, 0);
  __nesc_hton_uint16((unsigned char *)&UDPEchoP$stats.failed, 0);







  ;
  UDPEchoP$Echo$bind(7);
  UDPEchoP$Status$bind(7001);
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void IPRoutingP$SortTimer$startPeriodic(uint32_t arg_0x2ab4c474c770){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(8U, arg_0x2ab4c474c770);
#line 53
}
#line 53
# 88 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static inline void IPRoutingP$clearStats(struct neigh_entry *r)
#line 88
{
  ip_memclr((uint8_t *)r->stats, sizeof(struct epoch_stats ) * N_EPOCHS);
}

#line 153
static inline  void IPRoutingP$Boot$booted(void)
#line 153
{
  int i;

  for (i = 0; i < N_NEIGH; i++) {
      IPRoutingP$neigh_table[i].flags = 0;
      IPRoutingP$clearStats(&IPRoutingP$neigh_table[i]);
    }









  IPRoutingP$soliciting = FALSE;

  IPRoutingP$default_route_failures = 0;
  IPRoutingP$default_route = &IPRoutingP$neigh_table[0];


  IPRoutingP$last_qual = 0xffff;
  IPRoutingP$last_hops = 0xff;
  IPRoutingP$num_low_neigh = 0;
  IPRoutingP$Statistics$clear();
  IPRoutingP$SortTimer$startPeriodic(1024L * 60);

  IPRoutingP$traffic_sent = FALSE;
  IPRoutingP$restartTrafficGen();
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void IPDispatchP$ExpireTimer$startPeriodic(uint32_t arg_0x2ab4c474c770){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(3U, arg_0x2ab4c474c770);
#line 53
}
#line 53
# 194 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline void IPDispatchP$forward_clear(void *ent)
#line 194
{
  forward_entry_t *fwd = (forward_entry_t *)ent;

#line 196
  fwd->timeout = T_UNUSED;
}

#line 187
static inline void IPDispatchP$reconstruct_clear(void *ent)
#line 187
{
  reconstruct_t *recon = (reconstruct_t *)ent;

#line 189
  ip_memclr((uint8_t *)& recon->metadata, sizeof(struct ip_metadata ));
  recon->timeout = T_UNUSED;
  recon->buf = (void *)0;
}

# 5 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/table.c"
static inline void IPDispatchP$table_init(table_t *table, void *data, 
uint16_t elt_len, uint16_t n_elts)
#line 6
{
  table->data = data;
  table->elt_len = elt_len;
  table->n_elts = n_elts;
}

# 263 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static inline  void IPDispatchP$Boot$booted(void)
#line 263
{
  if (0) {
#line 264
    return;
    }
#line 265
  IPDispatchP$Statistics$clear();

  ip_malloc_init();

  IPDispatchP$table_init(&IPDispatchP$recon_cache, IPDispatchP$recon_data, sizeof(reconstruct_t ), N_RECONSTRUCTIONS);
  IPDispatchP$table_init(&IPDispatchP$forward_cache, IPDispatchP$forward_data, sizeof(forward_entry_t ), N_FORWARD_ENT);

  IPDispatchP$table_map(&IPDispatchP$recon_cache, IPDispatchP$reconstruct_clear);
  IPDispatchP$table_map(&IPDispatchP$forward_cache, IPDispatchP$forward_clear);

  IPDispatchP$radioBusy = FALSE;

  IPDispatchP$ExpireTimer$startPeriodic(FRAG_EXPIRE_TIME);

  IPDispatchP$SplitControl$start();
  return;
}

# 10 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/UDP.nc"
inline static  error_t UDPShellP$UDP$bind(uint16_t arg_0x2ab4c472fcc8){
#line 10
  unsigned char result;
#line 10

#line 10
  result = UdpP$UDP$bind(2U, arg_0x2ab4c472fcc8);
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 288 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline   char *UDPShellP$RegisterShellCommand$default$getCommandName(uint8_t cmd_id)
#line 288
{
  return (void *)0;
}

# 3 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/RegisterShellCommand.nc"
inline static  char *UDPShellP$RegisterShellCommand$getCommandName(uint8_t arg_0x2ab4c59982c0){
#line 3
  char *result;
#line 3

#line 3
    result = UDPShellP$RegisterShellCommand$default$getCommandName(arg_0x2ab4c59982c0);
#line 3

#line 3
  return result;
#line 3
}
#line 3
# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   UDPShellP$Uptime$size_type UDPShellP$Uptime$get(void){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 81 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline  void UDPShellP$Boot$booted(void)
#line 81
{
  int i;

#line 83
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      UDPShellP$uptime = 0;

      UDPShellP$boot_time = UDPShellP$Uptime$get();
    }
#line 87
    __nesc_atomic_end(__nesc_atomic); }

  for (i = 0; i < UDPShellP$N_EXTERNAL; i++) {
      UDPShellP$externals[i].c_name[UDPShellP$CMDNAMSIZ - 1] = '\0';
      strncpy(UDPShellP$externals[i].c_name, UDPShellP$RegisterShellCommand$getCommandName(i), UDPShellP$CMDNAMSIZ);
      UDPShellP$externals[i].c_len = strlen(UDPShellP$externals[i].c_name);
    }
  UDPShellP$UDP$bind(2000);
}

# 49 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Boot.nc"
inline static  void RealMainP$Boot$booted(void){
#line 49
  UDPShellP$Boot$booted();
#line 49
  IPDispatchP$Boot$booted();
#line 49
  IPRoutingP$Boot$booted();
#line 49
  UDPEchoP$Boot$booted();
#line 49
}
#line 49
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t CC2420CsmaP$SplitControlState$requestState(uint8_t arg_0x2ab4c4d746f0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(4U, arg_0x2ab4c4d746f0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420ControlP$StartupTimer$start(CC2420ControlP$StartupTimer$size_type arg_0x2ab4c47c0148){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$start(arg_0x2ab4c47c0148);
#line 55
}
#line 55
# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static inline   void /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$set(void)
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t *)29U |= 0x01 << 5;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 34 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIO.nc"
inline static   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$set(void){
#line 34
  /*HplMsp430GeneralIOC.P45*/HplMsp430GeneralIOP$29$IO$set();
#line 34
}
#line 34
# 37 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430GpioC.nc"
static inline   void /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$set(void)
#line 37
{
#line 37
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$HplGeneralIO$set();
}

# 29 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$VREN$set(void){
#line 29
  /*HplCC2420PinsC.VRENM*/Msp430GpioC$9$GeneralIO$set();
#line 29
}
#line 29
# 187 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$startVReg(void)
#line 187
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 188
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_VREG_STOPPED) {
          {
            unsigned char __nesc_temp = 
#line 190
            FAIL;

            {
#line 190
              __nesc_atomic_end(__nesc_atomic); 
#line 190
              return __nesc_temp;
            }
          }
        }
#line 192
      CC2420ControlP$m_state = CC2420ControlP$S_VREG_STARTING;
    }
#line 193
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP$VREN$set();
  CC2420ControlP$StartupTimer$start(CC2420_TIME_VREN);
  return SUCCESS;
}

# 51 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   error_t CC2420CsmaP$CC2420Power$startVReg(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420ControlP$CC2420Power$startVReg();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 206 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  void __nesc_disable_interrupt(void )
{
   __asm volatile ("dint");
   __asm volatile ("nop");}

# 126 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
static inline    mcu_power_t McuSleepC$McuPowerOverride$default$lowestState(void)
#line 126
{
  return MSP430_POWER_LPM4;
}

# 54 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
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
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
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

# 194 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
static inline  mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)
#line 194
{
  return m1 < m2 ? m1 : m2;
}

# 104 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/McuSleepC.nc"
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

   __asm volatile ("" :  :  : "memory");
  __nesc_disable_interrupt();
}

# 59 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/McuSleep.nc"
inline static   void SchedulerBasicP$McuSleep$sleep(void){
#line 59
  McuSleepC$McuSleep$sleep();
#line 59
}
#line 59
# 67 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$taskLoop(void){
#line 61
  SchedulerBasicP$Scheduler$taskLoop();
#line 61
}
#line 61
# 179 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$InterruptFIFOP$fired(void)
#line 179
{
  if (CC2420ReceiveP$m_state == CC2420ReceiveP$S_STARTED) {
      CC2420ReceiveP$beginReceive();
    }
  else {
      CC2420ReceiveP$m_missed_packets++;
    }
}

# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$fired(void){
#line 57
  CC2420ReceiveP$InterruptFIFOP$fired();
#line 57
}
#line 57
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$fired(void)
#line 66
{
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$clear();
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$Interrupt$fired();
}

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port10$fired(void){
#line 61
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Msp430InterruptC$1$HplInterrupt$fired();
#line 61
}
#line 61
# 92 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port11$fired(void){
#line 61
  HplMsp430InterruptP$Port11$default$fired();
#line 61
}
#line 61
# 93 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port12$fired(void){
#line 61
  HplMsp430InterruptP$Port12$default$fired();
#line 61
}
#line 61
# 94 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port13$fired(void){
#line 61
  HplMsp430InterruptP$Port13$default$fired();
#line 61
}
#line 61
# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420CsmaP$startDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420CsmaP$startDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 211 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Power$startOscillatorDone(void)
#line 211
{
  CC2420CsmaP$startDone_task$postTask();
}

# 76 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/interfaces/CC2420Power.nc"
inline static   void CC2420ControlP$CC2420Power$startOscillatorDone(void){
#line 76
  CC2420CsmaP$CC2420Power$startOscillatorDone();
#line 76
}
#line 76
# 50 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ControlP$InterruptCCA$disable(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$disable();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 418 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static inline   void CC2420ControlP$InterruptCCA$fired(void)
#line 418
{
  CC2420ControlP$m_state = CC2420ControlP$S_XOSC_STARTED;
  CC2420ControlP$InterruptCCA$disable();
  CC2420ControlP$IOCFG1$write(0);
  CC2420ControlP$writeId();
  CC2420ControlP$CSN$set();
  CC2420ControlP$CSN$clr();
  CC2420ControlP$CC2420Power$startOscillatorDone();
}

# 57 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$fired(void){
#line 57
  CC2420ControlP$InterruptCCA$fired();
#line 57
}
#line 57
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/Msp430InterruptC.nc"
static inline   void /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$fired(void)
#line 66
{
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$clear();
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$Interrupt$fired();
}

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port14$fired(void){
#line 61
  /*HplCC2420InterruptsC.InterruptCCAC*/Msp430InterruptC$0$HplInterrupt$fired();
#line 61
}
#line 61
# 96 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port15$fired(void){
#line 61
  HplMsp430InterruptP$Port15$default$fired();
#line 61
}
#line 61
# 97 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port16$fired(void){
#line 61
  HplMsp430InterruptP$Port16$default$fired();
#line 61
}
#line 61
# 98 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port17$fired(void){
#line 61
  HplMsp430InterruptP$Port17$default$fired();
#line 61
}
#line 61
# 195 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port20$fired(void){
#line 61
  HplMsp430InterruptP$Port20$default$fired();
#line 61
}
#line 61
# 196 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port21$fired(void){
#line 61
  HplMsp430InterruptP$Port21$default$fired();
#line 61
}
#line 61
# 197 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port22$fired(void){
#line 61
  HplMsp430InterruptP$Port22$default$fired();
#line 61
}
#line 61
# 198 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port23$clear(void)
#line 198
{
#line 198
  P2IFG &= ~(1 << 3);
}

#line 174
static inline    void HplMsp430InterruptP$Port23$default$fired(void)
#line 174
{
#line 174
  HplMsp430InterruptP$Port23$clear();
}

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port23$fired(void){
#line 61
  HplMsp430InterruptP$Port23$default$fired();
#line 61
}
#line 61
# 199 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port24$fired(void){
#line 61
  HplMsp430InterruptP$Port24$default$fired();
#line 61
}
#line 61
# 200 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port25$fired(void){
#line 61
  HplMsp430InterruptP$Port25$default$fired();
#line 61
}
#line 61
# 201 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
static inline   void HplMsp430InterruptP$Port26$clear(void)
#line 201
{
#line 201
  P2IFG &= ~(1 << 6);
}

#line 177
static inline    void HplMsp430InterruptP$Port26$default$fired(void)
#line 177
{
#line 177
  HplMsp430InterruptP$Port26$clear();
}

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port26$fired(void){
#line 61
  HplMsp430InterruptP$Port26$default$fired();
#line 61
}
#line 61
# 202 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
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

# 61 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430Interrupt.nc"
inline static   void HplMsp430InterruptP$Port27$fired(void){
#line 61
  HplMsp430InterruptP$Port27$default$fired();
#line 61
}
#line 61
# 88 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   uint8_t /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(void){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId();
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 349 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static inline   void HplMsp430Usart0P$Usart$disableRxIntr(void)
#line 349
{
  HplMsp430Usart0P$IE1 &= ~(1 << 6);
}

# 177 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart.nc"
inline static   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr(void){
#line 177
  HplMsp430Usart0P$Usart$disableRxIntr();
#line 177
}
#line 177
# 170 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(uint8_t data)
#line 170
{

  if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf) {
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos - 1] = data;
    }
  if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos < /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len) {
    /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp();
    }
  else 
#line 177
    {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$disableRxIntr();
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone();
    }
}

# 65 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(uint8_t id, uint8_t data)
#line 65
{
}

# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(uint8_t arg_0x2ab4c503fb70, uint8_t arg_0x2ab4c4eb4e58){
#line 54
  switch (arg_0x2ab4c503fb70) {
#line 54
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 54
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$rxDone(arg_0x2ab4c4eb4e58);
#line 54
      break;
#line 54
    default:
#line 54
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$rxDone(arg_0x2ab4c503fb70, arg_0x2ab4c4eb4e58);
#line 54
      break;
#line 54
    }
#line 54
}
#line 54
# 80 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   bool /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(uint8_t data)
#line 54
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$rxDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId(), data);
    }
}

# 54 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart0P$Interrupts$rxDone(uint8_t arg_0x2ab4c4eb4e58){
#line 54
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$rxDone(arg_0x2ab4c4eb4e58);
#line 54
}
#line 54
# 55 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C0P.nc"
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

# 6 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2C.nc"
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
# 66 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$default$fired(uint8_t id)
#line 66
{
}

# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$fired(uint8_t arg_0x2ab4c503e810){
#line 39
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$default$fired(arg_0x2ab4c503e810);
#line 39
}
#line 39
# 59 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawI2CInterrupts$fired(void)
#line 59
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$I2CInterrupts$fired(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId());
    }
}

# 39 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430I2CInterrupts.nc"
inline static   void HplMsp430Usart0P$I2CInterrupts$fired(void){
#line 39
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawI2CInterrupts$fired();
#line 39
}
#line 39
# 188 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static inline   void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone(void)
#line 188
{
}

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline    void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(uint8_t id)
#line 64
{
}

# 49 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(uint8_t arg_0x2ab4c503fb70){
#line 49
  switch (arg_0x2ab4c503fb70) {
#line 49
    case /*CC2420SpiWireC.HplCC2420SpiC.SpiC.UsartC*/Msp430Usart0C$0$CLIENT_ID:
#line 49
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$UsartInterrupts$txDone();
#line 49
      break;
#line 49
    default:
#line 49
      /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$default$txDone(arg_0x2ab4c503fb70);
#line 49
      break;
#line 49
    }
#line 49
}
#line 49
# 49 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430UsartShareP.nc"
static inline   void /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone(void)
#line 49
{
  if (/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$inUse()) {
    /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$Interrupts$txDone(/*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$ArbiterInfo$userId());
    }
}

# 49 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430UsartInterrupts.nc"
inline static   void HplMsp430Usart0P$Interrupts$txDone(void){
#line 49
  /*Msp430UsartShare0P.UsartShareP*/Msp430UsartShareP$0$RawInterrupts$txDone();
#line 49
}
#line 49
# 109 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP$action_help(int argc, char **argv)
#line 109
{
  int i = 0;
  char *pos = UDPShellP$reply_buf;

#line 112
  UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$help_str, strlen(UDPShellP$help_str));
  if (UDPShellP$N_EXTERNAL > 0) {
      strcpy(pos, "\t\t[");
      pos += 3;
      for (i = 0; i < UDPShellP$N_EXTERNAL; i++) {
          if (UDPShellP$externals[i].c_len + 4 < MAX_REPLY_LEN - (pos - UDPShellP$reply_buf)) {
              ip_memcpy(pos, UDPShellP$externals[i].c_name, UDPShellP$externals[i].c_len);
              pos += UDPShellP$externals[i].c_len;
              if (i < UDPShellP$N_EXTERNAL - 1) {
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
      UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, pos - UDPShellP$reply_buf);
    }
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void ICMPResponderP$PingTimer$startPeriodic(uint32_t arg_0x2ab4c474c770){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(6U, arg_0x2ab4c474c770);
#line 53
}
#line 53
#line 81
inline static  bool ICMPResponderP$PingTimer$isRunning(void){
#line 81
  unsigned char result;
#line 81

#line 81
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(6U);
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 381 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static inline  error_t ICMPResponderP$ICMPPing$ping(uint16_t client, struct in6_addr *target, uint16_t period, uint16_t n)
#line 381
{
  if (ICMPResponderP$PingTimer$isRunning()) {
#line 382
    return ERETRY;
    }
#line 383
  ICMPResponderP$PingTimer$startPeriodic(period);

  ip_memcpy(&ICMPResponderP$ping_dest, target, 16);
  ICMPResponderP$ping_n = n;
  ICMPResponderP$ping_seq = 0;
  ICMPResponderP$ping_rcv = 0;
  ICMPResponderP$ping_ident = client;
  return SUCCESS;
}

# 6 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/interfaces/ICMPPing.nc"
inline static  error_t UDPShellP$ICMPPing$ping(struct in6_addr *arg_0x2ab4c583ea98, uint16_t arg_0x2ab4c583ed58, uint16_t arg_0x2ab4c583d060){
#line 6
  unsigned char result;
#line 6

#line 6
  result = ICMPResponderP$ICMPPing$ping(0U, arg_0x2ab4c583ea98, arg_0x2ab4c583ed58, arg_0x2ab4c583d060);
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 188 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static inline void UDPShellP$action_ident(int argc, char **argv)
#line 188
{
  UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$ident_string, strlen(UDPShellP$ident_string));
}

# 226 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/msp430hardware.h"
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

# 11 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(12)))  void sig_TIMERA0_VECTOR(void)
#line 11
{
#line 11
  Msp430TimerCommonP$VectorTimerA0$fired();
}

# 169 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCapComP.nc"
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

# 12 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(10)))  void sig_TIMERA1_VECTOR(void)
#line 12
{
#line 12
  Msp430TimerCommonP$VectorTimerA1$fired();
}

#line 13
__attribute((wakeup)) __attribute((interrupt(26)))  void sig_TIMERB0_VECTOR(void)
#line 13
{
#line 13
  Msp430TimerCommonP$VectorTimerB0$fired();
}

# 135 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static    void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(uint8_t n)
{
}

# 28 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerEvent.nc"
static   void /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$fired(uint8_t arg_0x2ab4c4302b20){
#line 28
  switch (arg_0x2ab4c4302b20) {
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
      /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Event$default$fired(arg_0x2ab4c4302b20);
#line 28
      break;
#line 28
    }
#line 28
}
#line 28
# 159 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 96 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$set_alarm(void)
{
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type now = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Counter$get();
#line 98
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type expires;
#line 98
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type remaining;




  expires = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt;


  remaining = (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type )(expires - now);


  if (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 <= now) 
    {
      if (expires >= /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 && 
      expires <= now) {
        remaining = 0;
        }
    }
  else {
      if (expires >= /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 || 
      expires <= now) {
        remaining = 0;
        }
    }
#line 121
  if (remaining > /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$MAX_DELAY) 
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 = now + /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$MAX_DELAY;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt = remaining - /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$MAX_DELAY;
      remaining = /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$MAX_DELAY;
    }
  else 
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 += /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt = 0;
    }
  /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$AlarmFrom$startAt((/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_size_type )now << 5, 
  (/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$from_size_type )remaining << 5);
}

# 69 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static   /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type /*CounterMilli32C.Transform*/TransformCounterC$0$Counter$get(void)
{
  /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type rv = 0;

#line 72
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*CounterMilli32C.Transform*/TransformCounterC$0$upper_count_type high = /*CounterMilli32C.Transform*/TransformCounterC$0$m_upper;
      /*CounterMilli32C.Transform*/TransformCounterC$0$from_size_type low = /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$get();

#line 76
      if (/*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$isOverflowPending()) 
        {






          high++;
          low = /*CounterMilli32C.Transform*/TransformCounterC$0$CounterFrom$get();
        }
      {
        /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type high_to = high;
        /*CounterMilli32C.Transform*/TransformCounterC$0$to_size_type low_to = low >> /*CounterMilli32C.Transform*/TransformCounterC$0$LOW_SHIFT_RIGHT;

#line 90
        rv = (high_to << /*CounterMilli32C.Transform*/TransformCounterC$0$HIGH_SHIFT_LEFT) | low_to;
      }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return rv;
}

# 51 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerP.nc"
static   uint16_t /*Msp430TimerC.Msp430TimerB*/Msp430TimerP$1$Timer$get(void)
{




  if (1) {
      /* atomic removed: atomic calls only */
#line 58
      {
        uint16_t t0;
        uint16_t t1 = * (volatile uint16_t *)400U;

#line 61
        do {
#line 61
            t0 = t1;
#line 61
            t1 = * (volatile uint16_t *)400U;
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
      return * (volatile uint16_t *)400U;
    }
}

# 69 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static   /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform*/TransformCounterC$1$Counter$get(void)
{
  /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type rv = 0;

#line 72
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*Counter32khz32C.Transform*/TransformCounterC$1$upper_count_type high = /*Counter32khz32C.Transform*/TransformCounterC$1$m_upper;
      /*Counter32khz32C.Transform*/TransformCounterC$1$from_size_type low = /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$get();

#line 76
      if (/*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$isOverflowPending()) 
        {






          high++;
          low = /*Counter32khz32C.Transform*/TransformCounterC$1$CounterFrom$get();
        }
      {
        /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type high_to = high;
        /*Counter32khz32C.Transform*/TransformCounterC$1$to_size_type low_to = low >> /*Counter32khz32C.Transform*/TransformCounterC$1$LOW_SHIFT_RIGHT;

#line 90
        rv = (high_to << /*Counter32khz32C.Transform*/TransformCounterC$1$HIGH_SHIFT_LEFT) | low_to;
      }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return rv;
}

# 38 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$enableCapture(uint8_t mode)
#line 38
{
  /* atomic removed: atomic calls only */
#line 39
  {
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$disableEvents();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$GeneralIO$selectModuleFunc();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$clearPendingInterrupt();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430Capture$clearOverflow();
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$setControlAsCapture(mode);
    /*HplCC2420InterruptsC.CaptureSFDC*/GpioCaptureC$0$Msp430TimerControl$enableEvents();
  }
  return SUCCESS;
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)29U &= ~(0x01 << 2);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

# 260 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   cc2420_status_t CC2420SpiP$Ram$write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len)
#line 262
{

  cc2420_status_t status = 0;
  uint8_t tmpLen = len;
  uint8_t *tmpData = (uint8_t *)data;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 268
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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

  status = CC2420SpiP$SpiByte$write(addr | 0x80);
  CC2420SpiP$SpiByte$write((addr >> 1) & 0xc0);
  for (; len; len--) {
      CC2420SpiP$SpiByte$write(tmpData[tmpLen - len]);
    }

  return status;
}

# 133 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
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

# 99 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static   uint8_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiByte$write(uint8_t tx)
#line 99
{
  uint8_t byte;


  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(tx);
  while (!/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending()) ;
  /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$clrRxIntr();
  byte = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx();

  return byte;
}

# 386 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 45 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P42*/HplMsp430GeneralIOP$26$IO$set(void)
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t *)29U |= 0x01 << 2;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 149 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   error_t CC2420SpiP$Resource$release(uint8_t id)
#line 149
{
  uint8_t i;

#line 151
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 151
    {
      if (CC2420SpiP$m_holder != id) {
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
      CC2420SpiP$m_holder = CC2420SpiP$NO_HOLDER;
      if (!CC2420SpiP$m_requests) {
          CC2420SpiP$WorkingState$toIdle();
          CC2420SpiP$attemptRelease();
        }
      else {
          for (i = CC2420SpiP$m_holder + 1; ; i++) {
              i %= CC2420SpiP$RESOURCE_COUNT;

              if (CC2420SpiP$m_requests & (1 << i)) {
                  CC2420SpiP$m_holder = i;
                  CC2420SpiP$m_requests &= ~(1 << i);
                  CC2420SpiP$grant$postTask();
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
static error_t CC2420SpiP$attemptRelease(void)
#line 339
{


  if ((
#line 340
  CC2420SpiP$m_requests > 0
   || CC2420SpiP$m_holder != CC2420SpiP$NO_HOLDER)
   || !CC2420SpiP$WorkingState$isIdle()) {
      return FAIL;
    }
  /* atomic removed: atomic calls only */
  CC2420SpiP$release = TRUE;
  CC2420SpiP$ChipSpiResource$releasing();
  /* atomic removed: atomic calls only */
#line 348
  {
    if (CC2420SpiP$release) {
        CC2420SpiP$SpiResource$release();
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

# 247 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
static   void HplMsp430Usart0P$Usart$disableSpi(void)
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

# 136 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type dt)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 = t0;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt = dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$set_alarm();
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

#line 96
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$set_alarm(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$Counter$get();
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type expires;
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type remaining;




  expires = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt;


  remaining = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$to_size_type )(expires - now);


  if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 <= now) 
    {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 && 
      expires <= now) {
        remaining = 0;
        }
    }
  else {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 || 
      expires <= now) {
        remaining = 0;
        }
    }
#line 121
  if (remaining > /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$MAX_DELAY) 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 = now + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$MAX_DELAY;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt = remaining - /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$MAX_DELAY;
      remaining = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$MAX_DELAY;
    }
  else 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_t0 += /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$m_dt = 0;
    }
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$AlarmFrom$startAt((/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_size_type )now << 0, 
  (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform*/TransformAlarmC$1$from_size_type )remaining << 0);
}

# 696 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP$signalDone(error_t err)
#line 696
{
  /* atomic removed: atomic calls only */
#line 697
  CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
  CC2420TransmitP$abortSpiRelease = FALSE;
  CC2420TransmitP$ChipSpiResource$attemptRelease();
  CC2420TransmitP$Send$sendDone(CC2420TransmitP$m_msg, err);
}

# 121 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static   void CC2420PacketP$PacketTimeStamp32khz$clear(message_t *msg)
{
  __nesc_hton_int8((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(msg)->timesync, FALSE);
  __nesc_hton_uint32((unsigned char *)&CC2420PacketP$CC2420PacketBody$getMetadata(msg)->timestamp, CC2420_INVALID_TIMESTAMP);
}

# 634 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP$congestionBackoff(void)
#line 634
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 635
    {
      CC2420TransmitP$RadioBackoff$requestCongestionBackoff(CC2420TransmitP$m_msg);
      CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myCongestionBackoff);
    }
#line 638
    __nesc_atomic_end(__nesc_atomic); }
}

# 58 "/home/sdawson/cvs/tinyos-2.x/tos/system/RandomMlcgC.nc"
static   uint32_t RandomMlcgC$Random$rand32(void)
#line 58
{
  uint32_t mlcg;
#line 59
  uint32_t p;
#line 59
  uint32_t q;
  uint64_t tmpseed;

#line 61
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      tmpseed = (uint64_t )33614U * (uint64_t )RandomMlcgC$seed;
      q = tmpseed;
      q = q >> 1;
      p = tmpseed >> 32;
      mlcg = p + q;
      if (mlcg & 0x80000000) {
          mlcg = mlcg & 0x7FFFFFFF;
          mlcg++;
        }
      RandomMlcgC$seed = mlcg;
    }
#line 73
    __nesc_atomic_end(__nesc_atomic); }
  return mlcg;
}

# 641 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static error_t CC2420TransmitP$acquireSpiResource(void)
#line 641
{
  error_t error = CC2420TransmitP$SpiResource$immediateRequest();

#line 643
  if (error != SUCCESS) {
      CC2420TransmitP$SpiResource$request();
    }
  return error;
}

# 126 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   error_t CC2420SpiP$Resource$immediateRequest(uint8_t id)
#line 126
{
  error_t error;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 129
    {
      if (CC2420SpiP$WorkingState$requestState(CC2420SpiP$S_BUSY) != SUCCESS) {
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
      if (CC2420SpiP$SpiResource$isOwner()) {
          CC2420SpiP$m_holder = id;
          error = SUCCESS;
        }
      else {
#line 139
        if ((error = CC2420SpiP$SpiResource$immediateRequest()) == SUCCESS) {
            CC2420SpiP$m_holder = id;
          }
        else {
            CC2420SpiP$WorkingState$toIdle();
          }
        }
    }
#line 146
    __nesc_atomic_end(__nesc_atomic); }
#line 146
  return error;
}

# 96 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
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

# 174 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$Resource$isOwner(uint8_t id)
#line 174
{
  /* atomic removed: atomic calls only */
#line 175
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId == id && /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY) {
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
static   error_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ResourceDefaultOwner$release(void)
#line 130
{
  /* atomic removed: atomic calls only */
#line 131
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$default_owner_id) {
        if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_GRANTING) {
            /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$postTask();
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
          if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_IMM_GRANTING) {
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$reqResId;
              /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state = /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY;
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

# 265 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
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

# 107 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   error_t CC2420SpiP$Resource$request(uint8_t id)
#line 107
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      if (CC2420SpiP$WorkingState$requestState(CC2420SpiP$S_BUSY) == SUCCESS) {
          CC2420SpiP$m_holder = id;
          if (CC2420SpiP$SpiResource$isOwner()) {
              CC2420SpiP$grant$postTask();
            }
          else {
              CC2420SpiP$SpiResource$request();
            }
        }
      else {
          CC2420SpiP$m_requests |= 1 << id;
        }
    }
#line 122
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 592 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP$attemptSend(void)
#line 592
{
  uint8_t status;
  bool congestion = TRUE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 596
    {
      if (CC2420TransmitP$m_state == CC2420TransmitP$S_CANCEL) {
          CC2420TransmitP$SFLUSHTX$strobe();
          CC2420TransmitP$releaseSpiResource();
          CC2420TransmitP$CSN$set();
          CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
          CC2420TransmitP$Send$sendDone(CC2420TransmitP$m_msg, ECANCEL);
          {
#line 603
            __nesc_atomic_end(__nesc_atomic); 
#line 603
            return;
          }
        }

      CC2420TransmitP$CSN$clr();

      status = CC2420TransmitP$m_cca ? CC2420TransmitP$STXONCCA$strobe() : CC2420TransmitP$STXON$strobe();
      if (!(status & CC2420_STATUS_TX_ACTIVE)) {
          status = CC2420TransmitP$SNOP$strobe();
          if (status & CC2420_STATUS_TX_ACTIVE) {
              congestion = FALSE;
            }
        }

      CC2420TransmitP$m_state = congestion ? CC2420TransmitP$S_SAMPLE_CCA : CC2420TransmitP$S_SFD;
      CC2420TransmitP$CSN$set();
    }
#line 619
    __nesc_atomic_end(__nesc_atomic); }

  if (congestion) {
      CC2420TransmitP$totalCcaChecks = 0;
      CC2420TransmitP$releaseSpiResource();
      CC2420TransmitP$congestionBackoff();
    }
  else 
#line 625
    {
      CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$CC2420_ABORT_PERIOD);
    }
}

# 318 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   cc2420_status_t CC2420SpiP$Strobe$strobe(uint8_t addr)
#line 318
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 319
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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
  return CC2420SpiP$SpiByte$write(addr);
}

# 46 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430GeneralIOP.nc"
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$clr(void)
#line 46
{
#line 46
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 46
    * (volatile uint8_t *)29U &= ~(0x01 << 6);
#line 46
    __nesc_atomic_end(__nesc_atomic); }
}

#line 45
static   void /*HplMsp430GeneralIOC.P46*/HplMsp430GeneralIOP$30$IO$set(void)
#line 45
{
#line 45
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    * (volatile uint8_t *)29U |= 0x01 << 6;
#line 45
    __nesc_atomic_end(__nesc_atomic); }
}

# 14 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430TimerCommonP.nc"
__attribute((wakeup)) __attribute((interrupt(24)))  void sig_TIMERB1_VECTOR(void)
#line 14
{
#line 14
  Msp430TimerCommonP$VectorTimerB1$fired();
}

# 52 "/home/sdawson/cvs/tinyos-2.x/tos/system/RealMainP.nc"
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

# 160 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/timer/Msp430ClockP.nc"
static void Msp430ClockP$set_dco_calib(int calib)
{
  BCSCTL1 = (BCSCTL1 & ~0x07) | ((calib >> 8) & 0x07);
  DCOCTL = calib & 0xff;
}

# 123 "/home/sdawson/cvs/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 64 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x2ab4c41a08c0){
#line 64
  switch (arg_0x2ab4c41a08c0) {
#line 64
    case /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired:
#line 64
      /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask();
#line 64
      break;
#line 64
    case /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer:
#line 64
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask();
#line 64
      break;
#line 64
    case CC2420ControlP$sync:
#line 64
      CC2420ControlP$sync$runTask();
#line 64
      break;
#line 64
    case CC2420ControlP$syncDone:
#line 64
      CC2420ControlP$syncDone$runTask();
#line 64
      break;
#line 64
    case CC2420SpiP$grant:
#line 64
      CC2420SpiP$grant$runTask();
#line 64
      break;
#line 64
    case /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task:
#line 64
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$signalDone_task$runTask();
#line 64
      break;
#line 64
    case /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask:
#line 64
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$grantedTask$runTask();
#line 64
      break;
#line 64
    case PacketLinkP$send:
#line 64
      PacketLinkP$send$runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP$startDone_task:
#line 64
      CC2420CsmaP$startDone_task$runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP$stopDone_task:
#line 64
      CC2420CsmaP$stopDone_task$runTask();
#line 64
      break;
#line 64
    case CC2420CsmaP$sendDone_task:
#line 64
      CC2420CsmaP$sendDone_task$runTask();
#line 64
      break;
#line 64
    case CC2420ReceiveP$receiveDone_task:
#line 64
      CC2420ReceiveP$receiveDone_task$runTask();
#line 64
      break;
#line 64
    case IPDispatchP$sendTask:
#line 64
      IPDispatchP$sendTask$runTask();
#line 64
      break;
#line 64
    default:
#line 64
      SchedulerBasicP$TaskBasic$default$runTask(arg_0x2ab4c41a08c0);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 279 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static   uint16_t CC2420ControlP$CC2420Config$getShortAddr(void)
#line 279
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 280
    {
      unsigned int __nesc_temp = 
#line 280
      CC2420ControlP$m_short_addr;

      {
#line 280
        __nesc_atomic_end(__nesc_atomic); 
#line 280
        return __nesc_temp;
      }
    }
#line 282
    __nesc_atomic_end(__nesc_atomic); }
}

# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/packet/CC2420PacketP.nc"
static   error_t CC2420PacketP$Acks$requestAck(message_t *p_msg)
#line 64
{
  unsigned char *__nesc_temp46;

#line 65
  (__nesc_temp46 = (unsigned char *)&CC2420PacketP$CC2420PacketBody$getHeader(p_msg)->fcf, __nesc_hton_leuint16(__nesc_temp46, __nesc_ntoh_leuint16(__nesc_temp46) | (1 << IEEE154_FCF_ACK_REQ)));
  return SUCCESS;
}

# 122 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static  error_t CC2420CsmaP$Send$send(message_t *p_msg, uint8_t len)
#line 122
{
  unsigned char *__nesc_temp49;
  unsigned char *__nesc_temp48;
#line 124
  cc2420_header_t *header = CC2420CsmaP$CC2420PacketBody$getHeader(p_msg);
  cc2420_metadata_t *metadata = CC2420CsmaP$CC2420PacketBody$getMetadata(p_msg);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 127
    {
      if (!CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STARTED)) {
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
      CC2420CsmaP$SplitControlState$forceState(CC2420CsmaP$S_TRANSMITTING);
      CC2420CsmaP$m_msg = p_msg;
    }
#line 134
    __nesc_atomic_end(__nesc_atomic); }

  __nesc_hton_leuint8((unsigned char *)&header->length, len + CC2420_SIZE);
  (__nesc_temp48 = (unsigned char *)&header->fcf, __nesc_hton_leuint16(__nesc_temp48, __nesc_ntoh_leuint16(__nesc_temp48) & (1 << IEEE154_FCF_ACK_REQ)));
  (__nesc_temp49 = (unsigned char *)&header->fcf, __nesc_hton_leuint16(__nesc_temp49, __nesc_ntoh_leuint16(__nesc_temp49) | ((((IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (
  1 << IEEE154_FCF_INTRAPAN)) | (
  IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE)) | (
  IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE))));

  __nesc_hton_int8((unsigned char *)&metadata->ack, FALSE);
  __nesc_hton_uint8((unsigned char *)&metadata->rssi, 0);
  __nesc_hton_uint8((unsigned char *)&metadata->lqi, 0);
  __nesc_hton_int8((unsigned char *)&metadata->timesync, FALSE);
  __nesc_hton_uint32((unsigned char *)&metadata->timestamp, CC2420_INVALID_TIMESTAMP);

  CC2420CsmaP$ccaOn = TRUE;
  CC2420CsmaP$RadioBackoff$requestCca(CC2420CsmaP$m_msg);

  CC2420CsmaP$CC2420Transmit$send(CC2420CsmaP$m_msg, CC2420CsmaP$ccaOn);
  return SUCCESS;
}

# 671 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static void CC2420TransmitP$loadTXFIFO(void)
#line 671
{
  cc2420_header_t *header = CC2420TransmitP$CC2420PacketBody$getHeader(CC2420TransmitP$m_msg);
  uint8_t tx_power = __nesc_ntoh_uint8((unsigned char *)&CC2420TransmitP$CC2420PacketBody$getMetadata(CC2420TransmitP$m_msg)->tx_power);

  if (!tx_power) {
      tx_power = 31;
    }

  CC2420TransmitP$CSN$clr();

  if (CC2420TransmitP$m_tx_power != tx_power) {
      CC2420TransmitP$TXCTRL$write((((2 << CC2420_TXCTRL_TXMIXBUF_CUR) | (
      3 << CC2420_TXCTRL_PA_CURRENT)) | (
      1 << CC2420_TXCTRL_RESERVED)) | ((
      tx_power & 0x1F) << CC2420_TXCTRL_PA_LEVEL));
    }

  CC2420TransmitP$m_tx_power = tx_power;

  {
    uint8_t tmpLen __attribute((unused))  = __nesc_ntoh_leuint8((unsigned char *)&header->length) - 1;

#line 692
    CC2420TransmitP$TXFIFO$write((uint8_t *)header, __nesc_ntoh_leuint8((unsigned char *)&header->length) - 1);
  }
}

# 305 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   cc2420_status_t CC2420SpiP$Reg$write(uint8_t addr, uint16_t data)
#line 305
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 306
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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
  CC2420SpiP$SpiByte$write(addr);
  CC2420SpiP$SpiByte$write(data >> 8);
  return CC2420SpiP$SpiByte$write(data & 0xff);
}

# 144 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/Msp430SpiNoDmaP.nc"
static   error_t /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SpiPacket$send(uint8_t id, uint8_t *tx_buf, 
uint8_t *rx_buf, 
uint16_t len)
#line 146
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

#line 121
static void /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$continueOp(void)
#line 121
{

  uint8_t end;
  uint8_t tmp;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 126
    {
      /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf ? /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos] : 0);

      end = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos + /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$SPI_ATOMIC_SIZE;
      if (end > /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len) {
        end = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_len;
        }
      while (++/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos < end) {
          while (!/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$isRxIntrPending()) ;
          tmp = /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$rx();
          if (/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf) {
            /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_rx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos - 1] = tmp;
            }
#line 138
          /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$Usart$tx(/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf ? /*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_tx_buf[/*Msp430SpiNoDma0P.SpiP*/Msp430SpiNoDmaP$0$m_pos] : 0);
        }
    }
#line 140
    __nesc_atomic_end(__nesc_atomic); }
}

# 56 "/home/sdawson/cvs/tinyos-2.x/tos/interfaces/State.nc"
static   void PacketLinkP$SendState$toIdle(void){
#line 56
  StateImplP$State$toIdle(3U);
#line 56
}
#line 56
static   void UniqueSendP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(1U);
#line 56
}
#line 56
# 110 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$destination(message_t *msg)
#line 110
{
  cc2420_header_t *header = CC2420MessageP$CC2420PacketBody$getHeader(msg);

#line 112
  return __nesc_ntoh_leuint16((unsigned char *)&header->dest);
}

# 103 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
static  error_t /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$Pool$put(/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free >= 12) {
      return FAIL;
    }
  else {
      uint8_t emptyIndex = /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$index + /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free;

#line 109
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$queue[emptyIndex] = newVal;
      /*IPDispatchC.SendInfoPool.PoolP*/PoolP$2$free++;
      ;
      return SUCCESS;
    }
}

#line 103
static  error_t /*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$put(/*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.FragPool.PoolP*/PoolP$0$free >= 12) {
      return FAIL;
    }
  else {
      uint8_t emptyIndex = /*IPDispatchC.FragPool.PoolP*/PoolP$0$index + /*IPDispatchC.FragPool.PoolP*/PoolP$0$free;

#line 109
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$queue[emptyIndex] = newVal;
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$free++;
      ;
      return SUCCESS;
    }
}

#line 103
static  error_t /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$put(/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t *newVal)
#line 103
{
  if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free >= 12) {
      return FAIL;
    }
  else {
      uint8_t emptyIndex = /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index + /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free;

#line 109
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$queue[emptyIndex] = newVal;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free++;
      ;
      return SUCCESS;
    }
}

# 85 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static  /*IPDispatchC.QueueC*/QueueC$0$queue_t /*IPDispatchC.QueueC*/QueueC$0$Queue$dequeue(void)
#line 85
{
  /*IPDispatchC.QueueC*/QueueC$0$queue_t t = /*IPDispatchC.QueueC*/QueueC$0$Queue$head();

#line 87
  ;
  if (!/*IPDispatchC.QueueC*/QueueC$0$Queue$empty()) {
      /*IPDispatchC.QueueC*/QueueC$0$head++;
      if (/*IPDispatchC.QueueC*/QueueC$0$head == 12) {
#line 90
        /*IPDispatchC.QueueC*/QueueC$0$head = 0;
        }
#line 91
      /*IPDispatchC.QueueC*/QueueC$0$size--;
      /*IPDispatchC.QueueC*/QueueC$0$printQueue();
    }
  return t;
}

# 115 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/CC2420MessageP.nc"
static  ieee154_saddr_t CC2420MessageP$Ieee154Packet$source(message_t *msg)
#line 115
{
  cc2420_header_t *header = CC2420MessageP$CC2420PacketBody$getHeader(msg);

#line 117
  return __nesc_ntoh_leuint16((unsigned char *)&header->src);
}

# 260 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static struct neigh_entry *IPRoutingP$getNeighEntry(cmpr_ip6_addr_t a)
#line 260
{
  int i;

#line 262
  for (i = 0; i < N_NEIGH; i++) {
      if (IPRoutingP$neigh_table[i].neighbor == a) {
        return &IPRoutingP$neigh_table[i];
        }
    }
#line 266
  return (void *)0;
}

#line 81
static uint16_t IPRoutingP$adjustLQI(uint8_t val)
#line 81
{
  uint16_t result = 80 - (val - 50);

#line 83
  result = (result * result >> 3) * result >> 3;
  ;
  return result;
}

# 64 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
static  struct in6_addr *IPAddressP$IPAddress$getPublicAddr(void)
#line 64
{
  __my_address.in6_u.u6_addr16[7] = (((uint16_t )TOS_NODE_ID << 8) | ((uint16_t )TOS_NODE_ID >> 8)) & 0xffff;
  return &__my_address;
}

# 68 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static  void UdpP$IP$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta)
#line 70
{
  int i;
  struct sockaddr_in6 addr;
  struct udp_hdr *udph = (struct udp_hdr *)payload;

  ;


  for (i = 0; i < UdpP$N_CLIENTS; i++) 
    if (UdpP$local_ports[i] == udph->dstport) {
      break;
      }
  if (i == UdpP$N_CLIENTS) {

      return;
    }
  ip_memcpy(& addr.sin6_addr, & iph->ip6_src, 16);
  addr.sin6_port = udph->srcport;


  {
    uint16_t rx_cksum = (((uint16_t )udph->chksum >> 8) | ((uint16_t )udph->chksum << 8)) & 0xffff;
#line 91
    uint16_t my_cksum;
    vec_t cksum_vec[4];
    uint32_t hdr[2];

    udph->chksum = 0;

    cksum_vec[0].ptr = (uint8_t *)iph->ip6_src.in6_u.u6_addr8;
    cksum_vec[0].len = 16;
    cksum_vec[1].ptr = (uint8_t *)iph->ip6_dst.in6_u.u6_addr8;
    cksum_vec[1].len = 16;
    cksum_vec[2].ptr = (uint8_t *)hdr;
    cksum_vec[2].len = 8;
    hdr[0] = iph->plen;
    hdr[1] = (((((uint32_t )IANA_UDP << 24) & 0xff000000) | (((uint32_t )IANA_UDP << 8) & 0x00ff0000)) | (((uint32_t )IANA_UDP >> 8) & 0x0000ff00)) | (((uint32_t )IANA_UDP >> 24) & 0x000000ff);
    cksum_vec[3].ptr = payload;
    cksum_vec[3].len = (((uint16_t )iph->plen >> 8) | ((uint16_t )iph->plen << 8)) & 0xffff;

    my_cksum = in_cksum(cksum_vec, 4);
    ;
    if (rx_cksum != my_cksum) {
      return;
      }
  }

  UdpP$UDP$recvfrom(i, &addr, (void *)(udph + 1), ((((uint16_t )iph->plen >> 8) | ((uint16_t )iph->plen << 8)) & 0xffff) - sizeof(struct udp_hdr ), meta);
}

# 226 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static int UDPShellP$lookup_cmd(char *cmd, int dbsize, struct UDPShellP$cmd_name *db)
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
  return UDPShellP$CMD_NO_CMD;
}

# 126 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static  error_t UdpP$UDP$sendto(uint8_t clnt, struct sockaddr_in6 *dest, void *payload, 
uint16_t len)
#line 127
{
  struct split_ip_msg *msg;
  struct udp_hdr *udp;
  struct generic_header *g_udp;
  error_t rc;



  msg = (struct split_ip_msg *)ip_malloc(sizeof(struct split_ip_msg ) + 
  sizeof(struct udp_hdr ) + 
  sizeof(struct generic_header ));

  if (msg == (void *)0) {
      ;
      return ERETRY;
    }
  udp = (struct udp_hdr *)(msg + 1);
  g_udp = (struct generic_header *)(udp + 1);


  ip_memclr((uint8_t *)& msg->hdr, sizeof(struct ip6_hdr ));
  ip_memclr((uint8_t *)udp, sizeof(struct udp_hdr ));

  UdpP$setSrcAddr(msg);
  ip_memcpy(& msg->hdr.ip6_dst, dest->sin6_addr.in6_u.u6_addr8, 16);

  if (UdpP$local_ports[clnt] == 0 && UdpP$alloc_lport(clnt) == 0) {
      ip_free(msg);
      return FAIL;
    }
  udp->srcport = UdpP$local_ports[clnt];
  udp->dstport = dest->sin6_port;
  udp->len = (((uint16_t )(len + sizeof(struct udp_hdr )) << 8) | ((uint16_t )(len + sizeof(struct udp_hdr )) >> 8)) & 0xffff;
  udp->chksum = 0;


  g_udp->len = sizeof(struct udp_hdr );
  g_udp->hdr.udp = udp;
  g_udp->next = (void *)0;
  msg->headers = g_udp;
  msg->data_len = len;
  msg->data = payload;

  udp->chksum = (((uint16_t )msg_cksum(msg, IANA_UDP) << 8) | ((uint16_t )msg_cksum(msg, IANA_UDP) >> 8)) & 0xffff;

  rc = UdpP$IP$send(msg);

  ip_free(msg);
  return rc;
}

# 53 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPAddressP.nc"
static  void IPAddressP$IPAddress$getLLAddr(struct in6_addr *addr)
#line 53
{
  __my_address.in6_u.u6_addr16[7] = (((uint16_t )TOS_NODE_ID << 8) | ((uint16_t )TOS_NODE_ID >> 8)) & 0xffff;
  ip_memcpy(addr->in6_u.u6_addr8, linklocal_prefix, 8);
  ip_memcpy(&addr->in6_u.u6_addr8[8], &__my_address.in6_u.u6_addr8[8], 8);
}

static  void IPAddressP$IPAddress$getIPAddr(struct in6_addr *addr)
#line 59
{
  __my_address.in6_u.u6_addr16[7] = (((uint16_t )TOS_NODE_ID << 8) | ((uint16_t )TOS_NODE_ID >> 8)) & 0xffff;
  ip_memcpy(addr, &__my_address, 16);
}

# 951 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static  error_t IPDispatchP$IP$send(uint8_t prot, struct split_ip_msg *msg)
#line 951
{
  unsigned char __nesc_temp64;
  unsigned char *__nesc_temp63;
#line 952
  uint16_t payload_length;

  if (IPDispatchP$state != IPDispatchP$S_RUNNING) {
      return EOFF;
    }

  if (msg->hdr.hlim != 0xff) {
    msg->hdr.hlim = IPDispatchP$IPRouting$getHopLimit();
    }
  msg->hdr.nxt_hdr = prot;
  ip_memclr(msg->hdr.vlfc, 4);
  msg->hdr.vlfc[0] = 0x6 << 4;

  IPDispatchP$IPRouting$insertRoutingHeaders(msg);

  payload_length = msg->data_len;

  {
    struct generic_header *cur = msg->headers;

#line 971
    while (cur != (void *)0) {
        payload_length += cur->len;
        cur = cur->next;
      }
  }

  msg->hdr.plen = (((uint16_t )payload_length << 8) | ((uint16_t )payload_length >> 8)) & 0xffff;





  {
    send_info_t *s_info;
    send_entry_t *s_entry;
    uint8_t frag_len = 1;
    message_t *outgoing;
    fragment_t progress;
    struct source_header *sh;

#line 990
    progress.offset = 0;

    s_info = IPDispatchP$getSendInfo();
    if (s_info == (void *)0) {
#line 993
      return ERETRY;
      }

    sh = msg->headers != (void *)0 ? (struct source_header *)msg->headers->hdr.ext : (void *)0;

    if (
#line 997
    IPDispatchP$IPRouting$getNextHop(& msg->hdr, sh, 0x0, 
    & s_info->policy) != SUCCESS) {
        ;
        goto done;
      }






    while (frag_len > 0) {
        s_entry = IPDispatchP$SendEntryPool$get();
        outgoing = IPDispatchP$FragPool$get();

        if (s_entry == (void *)0 || outgoing == (void *)0) {
            if (s_entry != (void *)0) {
              IPDispatchP$SendEntryPool$put(s_entry);
              }
#line 1015
            if (outgoing != (void *)0) {
              IPDispatchP$FragPool$put(outgoing);
              }

            s_info->failed = TRUE;
            ;
            goto done;
          }









        frag_len = getNextFrag(msg, &progress, 
        IPDispatchP$Packet$getPayload(outgoing, IPDispatchP$Packet$maxPayloadLength()), 
        IPDispatchP$Packet$maxPayloadLength());
        if (frag_len == 0) {
            IPDispatchP$FragPool$put(outgoing);
            IPDispatchP$SendEntryPool$put(s_entry);
            goto done;
          }
        IPDispatchP$Packet$setPayloadLength(outgoing, frag_len);

        s_entry->msg = outgoing;
        s_entry->info = s_info;

        if (IPDispatchP$SendQueue$enqueue(s_entry) != SUCCESS) {
            (__nesc_temp63 = (unsigned char *)&IPDispatchP$stats.encfail, __nesc_hton_uint8(__nesc_temp63, (__nesc_temp64 = __nesc_ntoh_uint8(__nesc_temp63)) + 1), __nesc_temp64);
            ;
            goto done;
          }

        s_info->refcount++;
        ;
      }

    done: 
      if (-- s_info->refcount == 0) {
#line 1056
        IPDispatchP$SendInfoPool$put(s_info);
        }
#line 1057
    IPDispatchP$sendTask$postTask();
    return SUCCESS;
  }
}

# 829 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static  uint8_t IPRoutingP$IPRouting$getHopLimit(void)
#line 829
{

  if (((&IPRoutingP$neigh_table[0])->flags & T_VALID_MASK) == T_VALID_MASK) {
    return IPRoutingP$neigh_table[0].hops + 1;
    }
  else {
#line 833
    return 0xf0;
    }
}

#line 597
static uint16_t IPRoutingP$getLinkCost(struct neigh_entry *neigh)
#line 597
{
  uint16_t conf;
#line 598
  uint16_t succ;

#line 599
  conf = IPRoutingP$getConfidence(neigh);
  succ = IPRoutingP$getSuccess(neigh);

  if (succ == 0 || conf == 0) {
#line 602
    return 0xff;
    }
#line 603
  return conf * 10 / succ;
}

#line 561
static uint16_t IPRoutingP$getConfidence(struct neigh_entry *neigh)
#line 561
{

  uint16_t conf = 0;

#line 564
  if (neigh != (void *)0 && (neigh->flags & T_VALID_MASK) == T_VALID_MASK) {



      conf = neigh->stats[IPRoutingP$LONG_EPOCH].total;
    }
  return conf;
}

# 220 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static send_info_t *IPDispatchP$getSendInfo(void)
#line 220
{
  send_info_t *ret = IPDispatchP$SendInfoPool$get();

#line 222
  if (ret == (void *)0) {
#line 222
    return ret;
    }
#line 223
  ret->refcount = 1;
  ret->failed = FALSE;
  ret->frags_sent = 0;
  return ret;
}

# 737 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static  error_t IPRoutingP$IPRouting$getNextHop(struct ip6_hdr *hdr, 
struct source_header *sh, 
ieee154_saddr_t prev_hop, 
send_policy_t *ret)
#line 740
{

  int i;



  prev_hop = 0;
  ret->retries = 10;
  ret->delay = 30;
  ret->current = 0;
  ret->nchoices = 0;





  if (
#line 755
  hdr->nxt_hdr == NXTHDR_SOURCE && (
  sh->dispatch & IP_EXT_SOURCE_RECORD_MASK) != IP_EXT_SOURCE_RECORD && (
  sh->dispatch & IP_EXT_SOURCE_INVAL) != IP_EXT_SOURCE_INVAL) {




      ret->dest[0] = (((uint16_t )sh->hops[sh->current] >> 8) | ((uint16_t )sh->hops[sh->current] << 8)) & 0xffff;
      ret->nchoices = 1;

      ;
    }
  else {
    if (hdr->ip6_dst.in6_u.u6_addr16[0] == ((((uint16_t )0xff02 << 8) | ((uint16_t )0xff02 >> 8)) & 0xffff)) {


        ret->dest[0] = 0xffff;
        ret->nchoices = 1;
        ret->retries = 0;
        ret->delay = 0;
        return SUCCESS;
      }
    else {
#line 776
      if (cmpPfx(hdr->ip6_dst.in6_u.u6_addr8, linklocal_prefix)) {
          ret->dest[0] = (((uint16_t )hdr->ip6_dst.in6_u.u6_addr16[7] >> 8) | ((uint16_t )hdr->ip6_dst.in6_u.u6_addr16[7] << 8)) & 0xffff;
          ret->nchoices = 1;
          return SUCCESS;
        }
      }
    }
#line 805
  if ((IPRoutingP$default_route->flags & T_VALID_MASK) == T_VALID_MASK && prev_hop != IPRoutingP$default_route->neighbor) {
      ret->dest[ret->nchoices++] = IPRoutingP$default_route->neighbor;
    }
  else 
#line 807
    {
      ;
      return FAIL;
    }
  i = 0;
  while (ret->nchoices < N_PARENT_CHOICES && i < N_NEIGH) {

      if ((
#line 813
      (&IPRoutingP$neigh_table[i])->flags & T_VALID_MASK) == T_VALID_MASK && 
      &IPRoutingP$neigh_table[i] != IPRoutingP$default_route && 
      IPRoutingP$neigh_table[i].neighbor != prev_hop) {
          ret->dest[ret->nchoices++] = IPRoutingP$neigh_table[i].neighbor;
        }
      i++;
    }

  if (ret->nchoices == 0) {
    return FAIL;
    }
  ;

  return SUCCESS;
}

# 88 "/home/sdawson/cvs/tinyos-2.x/tos/system/PoolP.nc"
static  /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t */*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$Pool$get(void)
#line 88
{
  if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free) {
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$pool_t *rval = /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$queue[/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index];

#line 91
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$queue[/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index] = (void *)0;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$free--;
      /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index++;
      if (/*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index == 12) {
          /*IPDispatchC.SendEntryPool.PoolP*/PoolP$1$index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

#line 88
static  /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t */*IPDispatchC.FragPool.PoolP*/PoolP$0$Pool$get(void)
#line 88
{
  if (/*IPDispatchC.FragPool.PoolP*/PoolP$0$free) {
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$pool_t *rval = /*IPDispatchC.FragPool.PoolP*/PoolP$0$queue[/*IPDispatchC.FragPool.PoolP*/PoolP$0$index];

#line 91
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$queue[/*IPDispatchC.FragPool.PoolP*/PoolP$0$index] = (void *)0;
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$free--;
      /*IPDispatchC.FragPool.PoolP*/PoolP$0$index++;
      if (/*IPDispatchC.FragPool.PoolP*/PoolP$0$index == 12) {
          /*IPDispatchC.FragPool.PoolP*/PoolP$0$index = 0;
        }
      ;
      return rval;
    }
  return (void *)0;
}

# 97 "/home/sdawson/cvs/tinyos-2.x/tos/system/QueueC.nc"
static  error_t /*IPDispatchC.QueueC*/QueueC$0$Queue$enqueue(/*IPDispatchC.QueueC*/QueueC$0$queue_t newVal)
#line 97
{
  if (/*IPDispatchC.QueueC*/QueueC$0$Queue$size() < /*IPDispatchC.QueueC*/QueueC$0$Queue$maxSize()) {
      ;
      /*IPDispatchC.QueueC*/QueueC$0$queue[/*IPDispatchC.QueueC*/QueueC$0$tail] = newVal;
      /*IPDispatchC.QueueC*/QueueC$0$tail++;
      if (/*IPDispatchC.QueueC*/QueueC$0$tail == 12) {
#line 102
        /*IPDispatchC.QueueC*/QueueC$0$tail = 0;
        }
#line 103
      /*IPDispatchC.QueueC*/QueueC$0$size++;
      /*IPDispatchC.QueueC*/QueueC$0$printQueue();
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 303 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static  void ICMPResponderP$IP$recv(struct ip6_hdr *iph, 
void *payload, 
struct ip_metadata *meta)
#line 305
{
  unsigned int __nesc_temp66;
  unsigned char *__nesc_temp65;
#line 306
  icmp_echo_hdr_t *req = (icmp_echo_hdr_t *)payload;
  uint16_t len = (((uint16_t )iph->plen >> 8) | ((uint16_t )iph->plen << 8)) & 0xffff;

#line 308
  (__nesc_temp65 = (unsigned char *)&ICMPResponderP$stats.rx, __nesc_hton_uint16(__nesc_temp65, (__nesc_temp66 = __nesc_ntoh_uint16(__nesc_temp65)) + 1), __nesc_temp66);


  ;


  switch (__nesc_ntoh_uint8((unsigned char *)&req->type)) {
      case ICMP_TYPE_ROUTER_ADV: 
        ICMPResponderP$handleRouterAdv(payload, len, meta);

      break;
      case ICMP_TYPE_ROUTER_SOL: 

        if (ICMPResponderP$IPRouting$hasRoute()) {
            ICMPResponderP$ICMP$sendAdvertisements();
          }
      break;
      case ICMP_TYPE_ECHO_REPLY: 
        {
          nx_uint32_t *sendTime = (nx_uint32_t *)(req + 1);
          struct icmp_stats p_stat;

#line 329
          p_stat.seq = __nesc_ntoh_uint16((unsigned char *)&req->seqno);
          p_stat.ttl = iph->hlim;
          p_stat.rtt = ICMPResponderP$LocalTime$get() - __nesc_ntoh_uint32((unsigned char *)&*sendTime);
          ICMPResponderP$ICMPPing$pingReply(__nesc_ntoh_uint16((unsigned char *)&req->ident), & iph->ip6_src, &p_stat);
          ICMPResponderP$ping_rcv++;
        }
      break;
      case ICMP_TYPE_ECHO_REQUEST: 
        {

          struct split_ip_msg msg;

#line 340
          msg.headers = (void *)0;
          msg.data = payload;
          msg.data_len = len;
          ICMPResponderP$IPAddress$getIPAddr(& msg.hdr.ip6_src);
          ip_memcpy(& msg.hdr.ip6_dst, & iph->ip6_src, 16);

          __nesc_hton_uint8((unsigned char *)&req->type, ICMP_TYPE_ECHO_REPLY);
          __nesc_hton_uint8((unsigned char *)&req->code, 0);
          __nesc_hton_uint16((unsigned char *)&req->cksum, 0);
          __nesc_hton_uint16((unsigned char *)&req->cksum, ICMPResponderP$ICMP$cksum(&msg, IANA_ICMP));


          ICMPResponderP$IP$send(&msg);
          break;
        }
    }
}

# 1336 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static void IPRoutingP$swapNodes(struct neigh_entry *highNode, struct neigh_entry *lowNode)
#line 1336
{
  struct neigh_entry tempNode;

#line 1338
  if (highNode == (void *)0 || lowNode == (void *)0) {
#line 1338
    return;
    }
#line 1339
  ip_memcpy(&tempNode, highNode, sizeof(struct neigh_entry ));
  ip_memcpy(highNode, lowNode, sizeof(struct neigh_entry ));
  ip_memcpy(lowNode, &tempNode, sizeof(struct neigh_entry ));

  if (highNode == IPRoutingP$default_route) {
#line 1343
    IPRoutingP$default_route = lowNode;
    }
  else {
#line 1344
    if (lowNode == IPRoutingP$default_route) {
#line 1344
      IPRoutingP$default_route = highNode;
      }
    }
}

#line 1347
static uint8_t IPRoutingP$checkThresh(uint32_t firstVal, uint32_t secondVal, uint16_t thresh)
#line 1347
{
  if ((firstVal > secondVal && firstVal - secondVal <= thresh) || (
  secondVal >= firstVal && secondVal - firstVal <= thresh)) {
#line 1349
    return WITHIN_THRESH;
    }
#line 1350
  if (firstVal > secondVal && firstVal - secondVal > thresh) {
#line 1350
    return ABOVE_THRESH;
    }
#line 1351
  return BELOW_THRESH;
}

#line 1245
static void IPRoutingP$evictNeighbor(struct neigh_entry *neigh)
#line 1245
{
  struct neigh_entry *iterator;
  bool reset_default = FALSE;

  ;
  ;

  neigh->flags &= ~T_VALID_MASK;

  if (neigh == IPRoutingP$default_route) {
      reset_default = TRUE;
    }

  ip_memclr((uint8_t *)neigh, sizeof(struct neigh_entry ));
  for (iterator = neigh; iterator < &IPRoutingP$neigh_table[N_NEIGH - 1]; iterator++) {
      if (!(((iterator + 1)->flags & T_VALID_MASK) == T_VALID_MASK)) {
#line 1260
        break;
        }
#line 1261
      IPRoutingP$swapNodes(iterator, iterator + 1);
    }

  if (reset_default) {


      IPRoutingP$restartTrafficGen();
      IPRoutingP$default_route = &IPRoutingP$neigh_table[0];
      IPRoutingP$default_route_failures = 0;
    }

  IPRoutingP$printTable();
}

#line 109
static void IPRoutingP$restartTrafficGen(void)
#line 109
{
  IPRoutingP$traffic_interval = TGEN_BASE_TIME;

  IPRoutingP$traffic_interval += IPRoutingP$Random$rand16() % TGEN_BASE_TIME;
  if (IPRoutingP$TrafficGenTimer$isRunning()) {
    IPRoutingP$TrafficGenTimer$stop();
    }
  IPRoutingP$TrafficGenTimer$startOneShot(IPRoutingP$traffic_interval);
}

# 133 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num];

#line 136
  timer->t0 = t0;
  timer->dt = dt;
  timer->isoneshot = isoneshot;
  timer->isrunning = TRUE;
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

# 78 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static  void ICMPResponderP$ICMP$sendAdvertisements(void)
#line 78
{
  uint16_t jitter = ICMPResponderP$Random$rand16() % TRICKLE_JITTER;

#line 80
  ;
  if (ICMPResponderP$Advertisement$isRunning()) {
#line 81
    return;
    }
#line 82
  ICMPResponderP$advertisement_period = TRICKLE_PERIOD;
  ICMPResponderP$Advertisement$startOneShot(jitter);
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void ICMPResponderP$Advertisement$startOneShot(uint32_t arg_0x2ab4c474b108){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(5U, arg_0x2ab4c474b108);
#line 62
}
#line 62
# 386 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPDispatchP.nc"
static reconstruct_t *IPDispatchP$get_reconstruct(ieee154_saddr_t src, uint16_t tag)
#line 386
{
  reconstruct_t *ret = (void *)0;
  int i;

#line 389
  for (i = 0; i < N_RECONSTRUCTIONS; i++) {
      reconstruct_t *recon = (reconstruct_t *)&IPDispatchP$recon_data[i];

#line 391
      ;

      if (recon->tag == tag && 
      recon->metadata.sender == src) {

          if (recon->timeout > T_UNUSED) {

              recon->timeout = T_ACTIVE;
              return recon;
            }
          else {
#line 401
            if (recon->timeout < T_UNUSED) {


                return (void *)0;
              }
            }
        }
#line 407
      if (recon->timeout == T_UNUSED) {
        ret = recon;
        }
    }
#line 410
  return ret;
}

# 12 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/table.c"
static void *IPDispatchP$table_search(table_t *table, int (*pred)(void *))
#line 12
{
  int i;
  void *cur;

#line 15
  for (i = 0; i < table->n_elts; i++) {
      cur = table->data + i * table->elt_len;
      switch (pred(cur)) {
          case 1: return cur;
          case -1: return (void *)0;
          default: continue;
        }
    }
  return (void *)0;
}

# 412 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static void CC2420ReceiveP$waitForNextPacket(void)
#line 412
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 413
    {
      if (CC2420ReceiveP$m_state == CC2420ReceiveP$S_STOPPED) {
          CC2420ReceiveP$SpiResource$release();
          {
#line 416
            __nesc_atomic_end(__nesc_atomic); 
#line 416
            return;
          }
        }
      CC2420ReceiveP$receivingPacket = FALSE;










      if ((CC2420ReceiveP$m_missed_packets && CC2420ReceiveP$FIFO$get()) || !CC2420ReceiveP$FIFOP$get()) {

          if (CC2420ReceiveP$m_missed_packets) {
              CC2420ReceiveP$m_missed_packets--;
            }

          CC2420ReceiveP$beginReceive();
        }
      else {

          CC2420ReceiveP$m_state = CC2420ReceiveP$S_STARTED;
          CC2420ReceiveP$m_missed_packets = 0;
          CC2420ReceiveP$SpiResource$release();
        }
    }
#line 444
    __nesc_atomic_end(__nesc_atomic); }
}

#line 367
static void CC2420ReceiveP$beginReceive(void)
#line 367
{
  CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_LENGTH;
  /* atomic removed: atomic calls only */
  CC2420ReceiveP$receivingPacket = TRUE;
  if (CC2420ReceiveP$SpiResource$isOwner()) {
      CC2420ReceiveP$receive();
    }
  else {
#line 374
    if (CC2420ReceiveP$SpiResource$immediateRequest() == SUCCESS) {
        CC2420ReceiveP$receive();
      }
    else {
        CC2420ReceiveP$SpiResource$request();
      }
    }
}

#line 402
static void CC2420ReceiveP$receive(void)
#line 402
{
  CC2420ReceiveP$CSN$clr();
  CC2420ReceiveP$RXFIFO$beginRead((uint8_t *)CC2420ReceiveP$CC2420PacketBody$getHeader(CC2420ReceiveP$m_p_rx_buf), 1);
}

# 189 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   cc2420_status_t CC2420SpiP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 190
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 194
    {
      if (CC2420SpiP$WorkingState$isIdle()) {
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
  CC2420SpiP$m_addr = addr | 0x40;

  status = CC2420SpiP$SpiByte$write(CC2420SpiP$m_addr);
  CC2420SpiP$Fifo$continueRead(addr, data, len);

  return status;
}

# 159 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/transmit/CC2420TransmitP.nc"
static  error_t CC2420TransmitP$StdControl$stop(void)
#line 159
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 160
    {
      CC2420TransmitP$m_state = CC2420TransmitP$S_STOPPED;
      CC2420TransmitP$BackoffTimer$stop();
      CC2420TransmitP$CaptureSFD$disable();
      CC2420TransmitP$SpiResource$release();
      CC2420TransmitP$CSN$set();
    }
#line 166
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 138 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static  error_t CC2420ReceiveP$StdControl$stop(void)
#line 138
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 139
    {
      CC2420ReceiveP$m_state = CC2420ReceiveP$S_STOPPED;
      CC2420ReceiveP$reset_state();
      CC2420ReceiveP$CSN$set();
      CC2420ReceiveP$InterruptFIFOP$disable();
    }
#line 144
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 450
static void CC2420ReceiveP$reset_state(void)
#line 450
{
  CC2420ReceiveP$m_bytes_left = CC2420ReceiveP$RXFIFO_SIZE;
  /* atomic removed: atomic calls only */
#line 452
  CC2420ReceiveP$receivingPacket = FALSE;
  CC2420ReceiveP$m_timestamp_head = 0;
  CC2420ReceiveP$m_timestamp_size = 0;
  CC2420ReceiveP$m_missed_packets = 0;
}

# 199 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static   error_t CC2420ControlP$CC2420Power$stopVReg(void)
#line 199
{
  CC2420ControlP$m_state = CC2420ControlP$S_VREG_STOPPED;
  CC2420ControlP$RSTN$clr();
  CC2420ControlP$VREN$clr();
  CC2420ControlP$RSTN$set();
  return SUCCESS;
}

# 143 "/home/sdawson/cvs/tinyos-2.x/tos/system/StateImplP.nc"
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

# 220 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/chips/cc2420/link/PacketLinkP.nc"
static void PacketLinkP$signalDone(error_t error)
#line 220
{
  PacketLinkP$DelayTimer$stop();
  PacketLinkP$SendState$toIdle();
  __nesc_hton_uint16((unsigned char *)&PacketLinkP$CC2420PacketBody$getMetadata(PacketLinkP$currentSendMsg)->maxRetries, PacketLinkP$totalRetries);
  PacketLinkP$Send$sendDone(PacketLinkP$currentSendMsg, error);
}

# 661 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static void IPRoutingP$chooseNewRandomDefault(bool force)
#line 661
{
  uint8_t i;
  uint8_t numNeigh = 0;
  uint8_t chosenNeigh;
  bool useHops = TRUE;

  ;
  retry: 
    for (i = 1; i < N_NEIGH; i++) {
        if (!(((&IPRoutingP$neigh_table[i])->flags & T_VALID_MASK) == T_VALID_MASK)) {
#line 670
          break;
          }
#line 671
        if (&IPRoutingP$neigh_table[i] == IPRoutingP$default_route) {
#line 671
          continue;
          }
#line 672
        if ((useHops && IPRoutingP$neigh_table[i].hops < IPRoutingP$neigh_table[0].hops) || (
        !useHops && IPRoutingP$neigh_table[i].costEstimate < IPRoutingP$neigh_table[0].costEstimate)) {
            numNeigh++;
          }
      }


  if (numNeigh) {
      chosenNeigh = IPRoutingP$Random$rand16() % numNeigh;
      for (i = 1; i < N_NEIGH; i++) {
          if (&IPRoutingP$neigh_table[i] == IPRoutingP$default_route) {
#line 682
            continue;
            }
          if ((
#line 683
          useHops && IPRoutingP$neigh_table[i].hops < IPRoutingP$neigh_table[0].hops)
           || (!useHops && IPRoutingP$neigh_table[i].costEstimate < IPRoutingP$neigh_table[0].costEstimate)) {
              if (chosenNeigh) {
                  chosenNeigh--;
                }
              else 
#line 687
                {
                  IPRoutingP$default_route = &IPRoutingP$neigh_table[i];
                  IPRoutingP$default_route_failures = 0;
                  return;
                }
            }
        }
    }

  if (!force || !useHops) {
#line 696
    goto done;
    }
#line 697
  numNeigh = 0;
  useHops = FALSE;
  goto retry;
#line 725
  done: 
    ;
  IPRoutingP$default_route = &IPRoutingP$neigh_table[0];
  IPRoutingP$default_route_failures = 0;
}

#line 655
static uint16_t IPRoutingP$getMetric(struct neigh_entry *r)
#line 655
{
  return r == (void *)0 || !((r->flags & T_VALID_MASK) == T_VALID_MASK) ? 
  0xffff : r->costEstimate + IPRoutingP$getLinkCost(r);
}

# 70 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/ICMPResponderP.nc"
static  void ICMPResponderP$ICMP$sendSolicitations(void)
#line 70
{
  uint16_t jitter = ICMPResponderP$Random$rand16() % TRICKLE_JITTER;

#line 72
  ;
  if (ICMPResponderP$Solicitation$isRunning()) {
#line 73
    return;
    }
#line 74
  ICMPResponderP$solicitation_period = TRICKLE_PERIOD;
  ICMPResponderP$Solicitation$startOneShot(jitter);
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void ICMPResponderP$Solicitation$startOneShot(uint32_t arg_0x2ab4c474b108){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(4U, arg_0x2ab4c474b108);
#line 62
}
#line 62
# 329 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/spi/CC2420SpiP.nc"
static   void CC2420SpiP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error)
#line 330
{
  if (CC2420SpiP$m_addr & 0x40) {
      CC2420SpiP$Fifo$readDone(CC2420SpiP$m_addr & ~0x40, rx_buf, len, error);
    }
  else 
#line 333
    {
      CC2420SpiP$Fifo$writeDone(CC2420SpiP$m_addr, tx_buf, len, error);
    }
}

# 385 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/receive/CC2420ReceiveP.nc"
static void CC2420ReceiveP$flush(void)
#line 385
{
  CC2420ReceiveP$reset_state();
  CC2420ReceiveP$CSN$set();
  CC2420ReceiveP$CSN$clr();
  CC2420ReceiveP$SFLUSHRX$strobe();
  CC2420ReceiveP$SFLUSHRX$strobe();
  CC2420ReceiveP$CSN$set();
  CC2420ReceiveP$SpiResource$release();
  CC2420ReceiveP$waitForNextPacket();
}

# 456 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/control/CC2420ControlP.nc"
static void CC2420ControlP$writeFsctrl(void)
#line 456
{
  uint8_t channel;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 459
    {
      channel = CC2420ControlP$m_channel;
    }
#line 461
    __nesc_atomic_end(__nesc_atomic); }

  CC2420ControlP$FSCTRL$write((1 << CC2420_FSCTRL_LOCK_THR) | (((
  channel - 11) * 5 + 357) << CC2420_FSCTRL_FREQ));
}







static void CC2420ControlP$writeMdmctrl0(void)
#line 473
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 474
    {
      CC2420ControlP$MDMCTRL0$write((((((((1 << CC2420_MDMCTRL0_RESERVED_FRAME_MODE) | ((
      CC2420ControlP$addressRecognition && CC2420ControlP$hwAddressRecognition) << CC2420_MDMCTRL0_ADR_DECODE)) | (
      2 << CC2420_MDMCTRL0_CCA_HYST)) | (
      3 << CC2420_MDMCTRL0_CCA_MOD)) | (
      1 << CC2420_MDMCTRL0_AUTOCRC)) | ((
      CC2420ControlP$autoAckEnabled && CC2420ControlP$hwAutoAckDefault) << CC2420_MDMCTRL0_AUTOACK)) | (
      0 << CC2420_MDMCTRL0_AUTOACK)) | (
      2 << CC2420_MDMCTRL0_PREAMBLE_LENGTH));
    }
#line 483
    __nesc_atomic_end(__nesc_atomic); }
}







static void CC2420ControlP$writeId(void)
#line 492
{
  nxle_uint16_t id[2];

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 495
    {
      __nesc_hton_leuint16((unsigned char *)&id[0], CC2420ControlP$m_pan);
      __nesc_hton_leuint16((unsigned char *)&id[1], CC2420ControlP$m_short_addr);
    }
#line 498
    __nesc_atomic_end(__nesc_atomic); }

  CC2420ControlP$PANID$write(0, (uint8_t *)&id, sizeof id);
}

# 62 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(uint32_t now)
{
  uint8_t num;

  for (num = 0; num < /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num];

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
              /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$fired(num);
              break;
            }
        }
    }
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

# 836 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/IPRoutingP.nc"
static  uint16_t IPRoutingP$IPRouting$getQuality(void)
#line 836
{
  if (((&IPRoutingP$neigh_table[0])->flags & T_VALID_MASK) == T_VALID_MASK) {
    return IPRoutingP$getMetric(&IPRoutingP$neigh_table[0]);
    }
  else {
#line 839
    return 0xffff;
    }
}

# 26 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/table.c"
static void IPDispatchP$table_map(table_t *table, void (*fn)(void *))
#line 26
{
  int i;

#line 28
  for (i = 0; i < table->n_elts; i++) 
    fn(table->data + i * table->elt_len);
}

# 143 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(), dt, FALSE);
}

# 136 "/home/sdawson/cvs/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static   void /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$Alarm$startAt(/*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type t0, /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$to_size_type dt)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_t0 = t0;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$m_dt = dt;
      /*HilTimerMilliC.AlarmMilli32C.Transform*/TransformAlarmC$0$set_alarm();
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

# 57 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/UdpP.nc"
static  error_t UdpP$UDP$bind(uint8_t clnt, uint16_t port)
#line 57
{
  int i;

#line 59
  port = (((uint16_t )port << 8) | ((uint16_t )port >> 8)) & 0xffff;
  for (i = 0; i < UdpP$N_CLIENTS; i++) 
    if (i != clnt && UdpP$local_ports[i] == port) {
      return FAIL;
      }
#line 63
  UdpP$local_ports[clnt] = port;
  return SUCCESS;
}

# 81 "/home/sdawson/cvs/tinyos-2.x/tos/chips/cc2420/csma/CC2420CsmaP.nc"
static  error_t CC2420CsmaP$SplitControl$start(void)
#line 81
{
  if (CC2420CsmaP$SplitControlState$requestState(CC2420CsmaP$S_STARTING) == SUCCESS) {
      CC2420CsmaP$CC2420Power$startVReg();
      return SUCCESS;
    }
  else {
#line 86
    if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STARTED)) {
        return EALREADY;
      }
    else {
#line 89
      if (CC2420CsmaP$SplitControlState$isState(CC2420CsmaP$S_STARTING)) {
          return SUCCESS;
        }
      }
    }
#line 93
  return EBUSY;
}

# 53 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/pins/HplMsp430InterruptP.nc"
__attribute((wakeup)) __attribute((interrupt(8)))  void sig_PORT1_VECTOR(void)
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
__attribute((wakeup)) __attribute((interrupt(2)))  void sig_PORT2_VECTOR(void)
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

# 96 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
__attribute((wakeup)) __attribute((interrupt(18)))  void sig_UART0RX_VECTOR(void)
#line 96
{
  uint8_t temp = U0RXBUF;

#line 98
  HplMsp430Usart0P$Interrupts$rxDone(temp);
}

# 150 "/home/sdawson/cvs/tinyos-2.x/tos/system/ArbiterP.nc"
static   bool /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$inUse(void)
#line 150
{
  /* atomic removed: atomic calls only */
#line 151
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state == /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_CONTROLLED) 
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






static   uint8_t /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$ArbiterInfo$userId(void)
#line 163
{
  /* atomic removed: atomic calls only */
#line 164
  {
    if (/*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$state != /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$RES_BUSY) 
      {
        unsigned char __nesc_temp = 
#line 166
        /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$NO_RES;

#line 166
        return __nesc_temp;
      }
#line 167
    {
      unsigned char __nesc_temp = 
#line 167
      /*Msp430UsartShare0P.ArbiterC.Arbiter*/ArbiterP$0$resId;

#line 167
      return __nesc_temp;
    }
  }
}

# 101 "/home/sdawson/cvs/tinyos-2.x/tos/chips/msp430/usart/HplMsp430Usart0P.nc"
__attribute((wakeup)) __attribute((interrupt(16)))  void sig_UART0TX_VECTOR(void)
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

# 149 "/home/sdawson/cvs/tinyos-2.x-contrib/berkeley/blip/tos/lib/net/blip/shell/UDPShellP.nc"
static void UDPShellP$action_echo(int argc, char **argv)
#line 149
{
  int i;
#line 150
  int arg_len;
  char *payload = UDPShellP$reply_buf;

  if (argc < 2) {
#line 153
    return;
    }
#line 154
  for (i = 1; i < argc; i++) {
      arg_len = strlen(argv[i]);
      if (payload - UDPShellP$reply_buf + arg_len + 1 > MAX_REPLY_LEN) {
#line 156
        break;
        }
#line 157
      ip_memcpy(payload, argv[i], arg_len);
      payload += arg_len;
      *payload = ' ';
      payload++;
    }
  *(payload - 1) = '\n';

  UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, payload - UDPShellP$reply_buf);
}

static void UDPShellP$action_ping6(int argc, char **argv)
#line 167
{
  struct in6_addr dest;

  if (argc < 2) {
#line 170
    return;
    }
#line 171
  inet_pton6(argv[1], &dest);
  UDPShellP$ICMPPing$ping(&dest, 1024, 10);
}


static void UDPShellP$action_uptime(int argc, char **argv)
#line 176
{

  int len;
  uint64_t tval = UDPShellP$Uptime$get();

#line 180
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    tval = (UDPShellP$uptime + tval - UDPShellP$boot_time) / 1024;
#line 181
    __nesc_atomic_end(__nesc_atomic); }
  len = snprintf(UDPShellP$reply_buf, MAX_REPLY_LEN, "up %li seconds\n", 
  (uint32_t )tval);
  UDPShellP$UDP$sendto(&UDPShellP$session_endpoint, UDPShellP$reply_buf, len);
}

