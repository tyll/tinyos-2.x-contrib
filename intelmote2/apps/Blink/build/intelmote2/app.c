#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 4 "/opt/tinyos-2.x/tos/chips/pxa27x/inttypes.h"
typedef signed char int8_t;
typedef unsigned char uint8_t;

typedef short int16_t;
typedef unsigned short uint16_t;

typedef int int32_t;
typedef unsigned int uint32_t;

typedef long long int64_t;
typedef unsigned long long uint64_t;

typedef int32_t intptr_t;
typedef uint32_t uintptr_t;
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
# 12 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/sys/_types.h"
typedef long _off_t;
__extension__ 
#line 13
typedef long long _off64_t;


typedef int _ssize_t;
# 354 "/usr/lib/gcc/xscale-elf/3.4.3/include/stddef.h" 3
typedef unsigned int wint_t;
# 33 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/sys/_types.h"
#line 25
typedef struct __nesc_unnamed4242 {

  int __count;
  union __nesc_unnamed4243 {

    wint_t __wch;
    unsigned char __wchb[4];
  } __value;
} _mbstate_t;

typedef int _flock_t;
# 19 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/sys/reent.h"
typedef unsigned long __ULong;
# 40 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/sys/reent.h" 3
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
  void *_fnargs[32];
  __ULong _fntypes;
};
#line 91
struct __sbuf {
  unsigned char *_base;
  int _size;
};






typedef long _fpos_t;
#line 156
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



  _flock_t _lock;
};
#line 249
typedef struct __sFILE __FILE;


struct _glue {

  struct _glue *_next;
  int _niobs;
  __FILE *_iobs;
};
#line 280
struct _rand48 {
  unsigned short _seed[3];
  unsigned short _mult[3];
  unsigned short _add;
};
#line 532
struct _reent {

  int _errno;




  __FILE *_stdin, *_stdout, *_stderr;

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
      _mbstate_t _mblen_state;
      _mbstate_t _mbtowc_state;
      _mbstate_t _wctomb_state;
      char _l64a_buf[8];
      char _signal_buf[24];
      int _getdate_err;
      _mbstate_t _mbrlen_state;
      _mbstate_t _mbrtowc_state;
      _mbstate_t _mbsrtowcs_state;
      _mbstate_t _wcrtomb_state;
      _mbstate_t _wcsrtombs_state;
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
  __FILE __sf[3];
};
#line 728
struct _reent;
# 213 "/usr/lib/gcc/xscale-elf/3.4.3/include/stddef.h" 3
typedef long unsigned int size_t;
# 24 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/string.h"
void *memcpy(void *, const void *, size_t );

void *memset(void *, int , size_t );
# 325 "/usr/lib/gcc/xscale-elf/3.4.3/include/stddef.h" 3
typedef int wchar_t;
# 28 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/stdlib.h"
#line 24
typedef struct __nesc_unnamed4247 {

  int quot;
  int rem;
} div_t;





#line 30
typedef struct __nesc_unnamed4248 {

  long quot;
  long rem;
} ldiv_t;
# 17 "/usr/lib/gcc/xscale-elf/3.4.3/../../../../xscale-elf/include/math.h"
union __dmath {

  __ULong i[2];
  double d;
};




union __dmath;
#line 72
typedef float float_t;
typedef double double_t;
#line 290
struct exception {


  int type;
  char *name;
  double arg1;
  double arg2;
  double retval;
  int err;
};
#line 345
enum __fdlibm_version {

  __fdlibm_ieee = -1, 
  __fdlibm_svid, 
  __fdlibm_xopen, 
  __fdlibm_posix
};




enum __fdlibm_version;
# 151 "/usr/lib/gcc/xscale-elf/3.4.3/include/stddef.h" 3
typedef long int ptrdiff_t;
# 23 "/opt/tinyos-2.x/tos/system/tos.h"
typedef uint8_t bool;
enum __nesc_unnamed4249 {
#line 24
  FALSE = 0, TRUE = 1
};
typedef nx_int8_t nx_bool;







struct __nesc_attr_atmostonce {
};
#line 35
struct __nesc_attr_atleastonce {
};
#line 36
struct __nesc_attr_exactlyonce {
};
# 40 "/opt/tinyos-2.x/tos/types/TinyError.h"
enum __nesc_unnamed4250 {
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
# 83 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/pxa27x/pxa27xhardware.h"
extern void enableICache(void);
extern void enableDCache(void);


static __inline uint32_t _pxa27x_clzui(uint32_t i);





typedef uint32_t __nesc_atomic_t;


__inline __nesc_atomic_t __nesc_atomic_start(void )  ;
#line 112
__inline void __nesc_atomic_end(__nesc_atomic_t oldState)  ;
#line 130
static __inline void __nesc_enable_interrupt(void);
#line 144
static __inline void __nesc_disable_interrupt(void);
#line 170
typedef uint8_t mcu_power_t  ;
# 107 "/opt/tinyos-2.x/tos/platforms/intelmote2/hardware.h"
enum __nesc_unnamed4251 {
  TOSH_period16 = 0x00, 
  TOSH_period32 = 0x01, 
  TOSH_period64 = 0x02, 
  TOSH_period128 = 0x03, 
  TOSH_period256 = 0x04, 
  TOSH_period512 = 0x05, 
  TOSH_period1024 = 0x06, 
  TOSH_period2048 = 0x07
};





const uint8_t TOSH_IRP_TABLE[40] = { 0x05, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0x04, 
0x01, 
0x03, 
0x02, 
0x08, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0x07, 
0xFF, 
0x06, 
0xFF, 
0x0A, 
0x00, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0x09, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF };
#line 243
static inline void TOSH_SET_PIN_DIRECTIONS(void );
# 3 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/pxa27x/memsetup-pxa.h"
extern void memsetup(void);
# 29 "/opt/tinyos-2.x/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4252 {
#line 29
  int notUsed;
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4253 {
#line 30
  int notUsed;
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4254 {
#line 31
  int notUsed;
} 
#line 31
TMicro;
# 32 "/opt/tinyos-2.x/tos/types/Leds.h"
enum __nesc_unnamed4255 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
typedef TMilli PMICM$chargeMonitorTimer$precision_tag;
typedef TMilli /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$precision_tag;
typedef /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$precision_tag /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$precision_tag;
typedef /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$precision_tag /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$precision_tag;
typedef TMilli /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$precision_tag;
typedef /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$precision_tag /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$precision_tag;
typedef uint32_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type;
typedef /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$precision_tag /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$precision_tag;
typedef TMilli /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$frequency_tag;
typedef /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$frequency_tag /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$precision_tag;
typedef uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$size_type;
enum HilTimerMilliC$__nesc_unnamed4256 {
  HilTimerMilliC$OST_CLIENT_ID = 0U
};
typedef TMilli BlinkC$Timer0$precision_tag;
typedef TMilli BlinkC$Timer1$precision_tag;
typedef TMilli BlinkC$Timer2$precision_tag;
# 32 "/opt/tinyos-2.x/tos/platforms/intelmote2/PlatformReset.nc"
static   void PlatformP$PlatformReset$reset(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$Init$init(void);
#line 51
static  error_t PlatformP$InitL0$default$init(void);
# 139 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void PlatformP$OST0M3$fired(void);
# 54 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
static   void PMICM$PI2C$interruptI2C(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PMICM$Init$init(void);
# 56 "/opt/tinyos-2.x/tos/platforms/intelmote2/chips/da9030/PMIC.nc"
static  error_t PMICM$PMIC$enableManualCharging(bool arg_0x7ede1398);
#line 51
static  error_t PMICM$PMIC$setCoreVoltage(uint8_t arg_0x7ede3280);


static  error_t PMICM$PMIC$getBatteryVoltage(uint8_t *arg_0x7ede3a38);
# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void PMICM$PMICGPIO$interruptGPIOPin(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void PMICM$chargeMonitorTimer$fired(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$fired(void);
#line 72
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$default$fired(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7eca0298);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7eca0298, 
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t arg_0x7edc0170);
#line 67
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$stop(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7eca0298);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$runTask(void);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$fired(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$getNow(void);
#line 118
static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t arg_0x7edb35f0, uint32_t arg_0x7edb3780);
#line 67
static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$stop(void);
# 139 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$fired(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$runTask(void);
# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$size_type /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getNow(void);
#line 92
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$startAt(/*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$size_type arg_0x7ec03220, /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$size_type arg_0x7ec033b0);
#line 105
static   /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$size_type /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getAlarm(void);
#line 62
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$stop(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Init$init(void);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xOSTimerM$OST4_11Irq$fired(void);
#line 75
static   void HplPXA27xOSTimerM$OST0Irq$fired(void);
#line 75
static   void HplPXA27xOSTimerM$OST1Irq$fired(void);
#line 75
static   void HplPXA27xOSTimerM$OST2Irq$fired(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t HplPXA27xOSTimerM$Init$init(void);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xOSTimerM$OST3Irq$fired(void);
# 71 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$setOSMR(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0, 
# 71 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
uint32_t arg_0x7ee43030);
#line 64
static   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSCR(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
# 139 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$default$fired(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
# 78 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSMR(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
# 85 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$setOMCR(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0, 
# 85 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
uint32_t arg_0x7ee43d20);
#line 112
static   bool HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
# 103 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   bool HplPXA27xOSTimerM$PXA27xOST$getOSSRbit(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
# 57 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$setOSCR(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0, 
# 57 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
uint32_t arg_0x7ee502e8);
#line 119
static   void HplPXA27xOSTimerM$PXA27xOST$setOIERbit(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0, 
# 119 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
bool arg_0x7ee40798);
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerWatchdog.nc"
static   void HplPXA27xOSTimerM$PXA27xWD$enableWatchdog(void);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xInterruptM$PXA27xIrq$default$fired(
# 51 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
uint8_t arg_0x7ead1010);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xInterruptM$PXA27xIrq$enable(
# 51 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
uint8_t arg_0x7ead1010);
# 60 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   error_t HplPXA27xInterruptM$PXA27xIrq$allocate(
# 51 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
uint8_t arg_0x7ead1010);
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getICR(void);
#line 45
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setICR(uint32_t arg_0x7ed81dd0);



static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getISR(void);

static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setISAR(uint32_t arg_0x7ed80e38);
#line 43
static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getIDBR(void);
#line 42
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setIDBR(uint32_t arg_0x7ed81608);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$fired(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$Init$init(void);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xGPIOM$GPIOIrq0$fired(void);
#line 75
static   void HplPXA27xGPIOM$GPIOIrq$fired(void);
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$getGPLRbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698);
# 134 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGAFRpin(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698, 
# 134 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
uint8_t arg_0x7ed910f8);
#line 101
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGFERbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698, 
# 101 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
bool arg_0x7ed93718);
#line 52
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPDRbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698, 
# 52 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
bool arg_0x7eda11d0);
#line 72
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPCRbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698);
# 124 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$clearGEDRbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698);
# 66 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPSRbit(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t HplPXA27xGPIOM$Init$init(void);
# 132 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIO.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIO$default$fired(void);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xGPIOM$GPIOIrq1$fired(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(
# 45 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x7ef337e0);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$default$runTask(
# 45 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x7ef337e0);
# 46 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void SchedulerBasicP$Scheduler$init(void);
#line 61
static  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 54
static  bool SchedulerBasicP$Scheduler$runNextTask(void);
# 59 "/opt/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void McuSleepC$McuSleep$sleep(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void BlinkC$Timer0$fired(void);
# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
static  void BlinkC$Boot$booted(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void BlinkC$Timer1$fired(void);
#line 72
static  void BlinkC$Timer2$fired(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t LedsP$Init$init(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
static   void LedsP$Leds$led0Toggle(void);
#line 72
static   void LedsP$Leds$led1Toggle(void);
#line 89
static   void LedsP$Leds$led2Toggle(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGpioInterrupt.nc"
static   void HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$default$fired(
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e827228);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void HalPXA27xGeneralIOM$GpioInterrupt$default$fired(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e827b60);
# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$interruptGPIOPin(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428);
# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void HalPXA27xGeneralIOM$GeneralIO$toggle(
# 44 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e828630);
# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void HalPXA27xGeneralIOM$GeneralIO$makeOutput(
# 44 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e828630);
# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void HalPXA27xGeneralIOM$GeneralIO$set(
# 44 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e828630);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$InitL2$init(void);
#line 51
static  error_t PlatformP$InitL0$init(void);
#line 51
static  error_t PlatformP$InitL3$init(void);
# 71 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void PlatformP$OST0M3$setOSMR(uint32_t arg_0x7ee43030);
#line 64
static   uint32_t PlatformP$OST0M3$getOSCR(void);
#line 112
static   bool PlatformP$OST0M3$clearOSSRbit(void);






static   void PlatformP$OST0M3$setOIERbit(bool arg_0x7ee40798);
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerWatchdog.nc"
static   void PlatformP$PXA27xWD$enableWatchdog(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$InitL1$init(void);
# 53 "/opt/tinyos-2.x-contrib/intelmote2/tos/platforms/intelmote2/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void);
#line 146
static inline   void PlatformP$PlatformReset$reset(void);






static inline   void PlatformP$OST0M3$fired(void);






static inline   error_t PlatformP$InitL0$default$init(void);
# 32 "/opt/tinyos-2.x/tos/platforms/intelmote2/PlatformReset.nc"
static   void PMICM$PlatformReset$reset(void);
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
static   uint32_t PMICM$PI2C$getICR(void);
#line 45
static   void PMICM$PI2C$setICR(uint32_t arg_0x7ed81dd0);



static   uint32_t PMICM$PI2C$getISR(void);

static   void PMICM$PI2C$setISAR(uint32_t arg_0x7ed80e38);
#line 43
static   uint32_t PMICM$PI2C$getIDBR(void);
#line 42
static   void PMICM$PI2C$setIDBR(uint32_t arg_0x7ed81608);
# 134 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void PMICM$PMICGPIO$setGAFRpin(uint8_t arg_0x7ed910f8);
#line 101
static   void PMICM$PMICGPIO$setGFERbit(bool arg_0x7ed93718);
#line 52
static   void PMICM$PMICGPIO$setGPDRbit(bool arg_0x7eda11d0);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void PMICM$chargeMonitorTimer$startPeriodic(uint32_t arg_0x7edc0170);
#line 67
static  void PMICM$chargeMonitorTimer$stop(void);
# 101 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
bool PMICM$gotReset;


static error_t PMICM$readPMIC(uint8_t address, uint8_t *value, uint8_t numBytes);
#line 151
static error_t PMICM$writePMIC(uint8_t address, uint8_t value);
#line 171
static inline void PMICM$startLDOs(void);
#line 219
static inline  error_t PMICM$Init$init(void);
#line 259
static inline   void PMICM$PI2C$interruptI2C(void);
#line 274
static   void PMICM$PMICGPIO$interruptGPIOPin(void);
#line 303
static inline  error_t PMICM$PMIC$setCoreVoltage(uint8_t trimValue);
#line 337
static error_t PMICM$getPMICADCVal(uint8_t channel, uint8_t *val);
#line 358
static inline  error_t PMICM$PMIC$getBatteryVoltage(uint8_t *val);
#line 375
static inline  error_t PMICM$PMIC$enableManualCharging(bool enable);
#line 410
static inline  void PMICM$chargeMonitorTimer$fired(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$postTask(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$getNow(void);
#line 118
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x7edb35f0, uint32_t arg_0x7edb3780);
#line 67
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$stop(void);




static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$fired(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7eca0298);
#line 60
enum /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$__nesc_unnamed4257 {
#line 60
  VirtualizeTimerC$0$updateFromTimer = 0U
};
#line 60
typedef int /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$__nesc_sillytask_updateFromTimer[/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer];
#line 42
enum /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$__nesc_unnamed4258 {

  VirtualizeTimerC$0$NUM_TIMERS = 4U, 
  VirtualizeTimerC$0$END_OF_LIST = 255
};








#line 48
typedef struct /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$__nesc_unnamed4259 {

  uint32_t t0;
  uint32_t dt;
  bool isoneshot : 1;
  bool isrunning : 1;
  bool _reserved : 6;
} /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer_t;

/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer_t /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$m_timers[/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$NUM_TIMERS];




static void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$fireTimers(uint32_t now);
#line 89
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
#line 128
static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$fired(void);




static void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot);









static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt);









static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$stop(uint8_t num);
#line 193
static inline   void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$postTask(void);
# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getNow(void);
#line 92
static   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type arg_0x7ec03220, /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type arg_0x7ec033b0);
#line 105
static   /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getAlarm(void);
#line 62
static   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$stop(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$fired(void);
# 63 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
enum /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$__nesc_unnamed4260 {
#line 63
  AlarmToTimerC$0$fired = 1U
};
#line 63
typedef int /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$__nesc_sillytask_fired[/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired];
#line 44
uint32_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_dt;
bool /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_oneshot;

static inline void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$start(uint32_t t0, uint32_t dt, bool oneshot);
#line 60
static inline  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$stop(void);


static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$runTask(void);






static inline   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$fired(void);
#line 82
static inline  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t t0, uint32_t dt);


static inline  uint32_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$getNow(void);
# 71 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSMR(uint32_t arg_0x7ee43030);
#line 64
static   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSCR(void);
#line 78
static   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSMR(void);






static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOMCR(uint32_t arg_0x7ee43d20);
#line 112
static   bool /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$clearOSSRbit(void);
#line 103
static   bool /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSSRbit(void);
#line 57
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSCR(uint32_t arg_0x7ee502e8);
#line 119
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(bool arg_0x7ee40798);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTInit$init(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$postTask(void);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$fired(void);
# 56 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
enum /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$__nesc_unnamed4261 {
#line 56
  HalPXA27xAlarmM$0$lateAlarm = 2U
};
#line 56
typedef int /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$__nesc_sillytask_lateAlarm[/*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm];
#line 53
bool /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning;
uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT;

static  void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$runTask(void);






static inline  error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Init$init(void);
#line 117
static inline   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$stop(void);
#line 132
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$startAt(uint32_t t0, uint32_t dt);
#line 152
static inline   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getNow(void);



static inline   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getAlarm(void);



static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$fired(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xOSTimerM$OST4_11Irq$enable(void);
#line 60
static   error_t HplPXA27xOSTimerM$OST4_11Irq$allocate(void);




static   void HplPXA27xOSTimerM$OST0Irq$enable(void);
#line 60
static   error_t HplPXA27xOSTimerM$OST0Irq$allocate(void);




static   void HplPXA27xOSTimerM$OST1Irq$enable(void);
#line 60
static   error_t HplPXA27xOSTimerM$OST1Irq$allocate(void);




static   void HplPXA27xOSTimerM$OST2Irq$enable(void);
#line 60
static   error_t HplPXA27xOSTimerM$OST2Irq$allocate(void);




static   void HplPXA27xOSTimerM$OST3Irq$enable(void);
#line 60
static   error_t HplPXA27xOSTimerM$OST3Irq$allocate(void);
# 139 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$fired(
# 39 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
uint8_t arg_0x7eb42de0);
#line 53
bool HplPXA27xOSTimerM$gfInitialized = FALSE;

static inline void HplPXA27xOSTimerM$DispatchOSTInterrupt(uint8_t id);





static inline  error_t HplPXA27xOSTimerM$Init$init(void);
#line 87
static inline   void HplPXA27xOSTimerM$PXA27xOST$setOSCR(uint8_t chnl_id, uint32_t val);









static   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSCR(uint8_t chnl_id);










static   void HplPXA27xOSTimerM$PXA27xOST$setOSMR(uint8_t chnl_id, uint32_t val);





static inline   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSMR(uint8_t chnl_id);






static inline   void HplPXA27xOSTimerM$PXA27xOST$setOMCR(uint8_t chnl_id, uint32_t val);
#line 138
static inline   bool HplPXA27xOSTimerM$PXA27xOST$getOSSRbit(uint8_t chnl_id);










static   bool HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(uint8_t chnl_id);
#line 163
static   void HplPXA27xOSTimerM$PXA27xOST$setOIERbit(uint8_t chnl_id, bool flag);
#line 186
static inline   void HplPXA27xOSTimerM$PXA27xWD$enableWatchdog(void);









static inline   void HplPXA27xOSTimerM$OST0Irq$fired(void);




static inline   void HplPXA27xOSTimerM$OST1Irq$fired(void);




static inline   void HplPXA27xOSTimerM$OST2Irq$fired(void);




static inline   void HplPXA27xOSTimerM$OST3Irq$fired(void);




static inline   void HplPXA27xOSTimerM$OST4_11Irq$fired(void);
#line 233
static inline    void HplPXA27xOSTimerM$PXA27xOST$default$fired(uint8_t chnl_id);
# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xInterruptM$PXA27xIrq$fired(
# 51 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
uint8_t arg_0x7ead1010);







static inline uint32_t HplPXA27xInterruptM$getICHP(void);








void hplarmv_irq(void) __attribute((interrupt("IRQ")))   ;
#line 85
void hplarmv_fiq(void) __attribute((interrupt("FIQ")))   ;



static uint8_t HplPXA27xInterruptM$usedPriorities = 0;




static error_t HplPXA27xInterruptM$allocate(uint8_t id, bool level, uint8_t priority);
#line 162
static void HplPXA27xInterruptM$enable(uint8_t id);
#line 188
static inline   error_t HplPXA27xInterruptM$PXA27xIrq$allocate(uint8_t id);




static inline   void HplPXA27xInterruptM$PXA27xIrq$enable(uint8_t id);
#line 227
static inline    void HplPXA27xInterruptM$PXA27xIrq$default$fired(uint8_t id);
# 54 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$interruptI2C(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$enable(void);
#line 60
static   error_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$allocate(void);
# 52 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
bool /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$m_fInit = FALSE;

static inline  error_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$Init$init(void);
#line 90
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setIDBR(uint32_t val);








static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getIDBR(void);







static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setICR(uint32_t val);








static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getICR(void);
#line 132
static inline   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getISR(void);







static inline   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setISAR(uint32_t val);
#line 157
static inline   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$fired(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xGPIOM$GPIOIrq0$enable(void);
#line 60
static   error_t HplPXA27xGPIOM$GPIOIrq0$allocate(void);




static   void HplPXA27xGPIOM$GPIOIrq$enable(void);
#line 60
static   error_t HplPXA27xGPIOM$GPIOIrq$allocate(void);
# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
uint8_t arg_0x7e9c0698);
# 132 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIO.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIO$fired(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
static   void HplPXA27xGPIOM$GPIOIrq1$enable(void);
#line 60
static   error_t HplPXA27xGPIOM$GPIOIrq1$allocate(void);
# 58 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
bool HplPXA27xGPIOM$gfInitialized = FALSE;

static inline  error_t HplPXA27xGPIOM$Init$init(void);
#line 80
static inline   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$getGPLRbit(uint8_t pin);




static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPDRbit(uint8_t pin, bool dir);
#line 101
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPSRbit(uint8_t pin);





static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPCRbit(uint8_t pin);
#line 129
static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGFERbit(uint8_t pin, bool flag);
#line 150
static inline   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$clearGEDRbit(uint8_t pin);







static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGAFRpin(uint8_t pin, uint8_t func);
#line 259
static inline    void HplPXA27xGPIOM$HplPXA27xGPIO$default$fired(void);



static inline   void HplPXA27xGPIOM$GPIOIrq$fired(void);
#line 307
static inline   void HplPXA27xGPIOM$GPIOIrq0$fired(void);




static inline   void HplPXA27xGPIOM$GPIOIrq1$fired(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$SoftwareInit$init(void);
# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
static  void RealMainP$Boot$booted(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RealMainP$PlatformInit$init(void);
# 46 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void RealMainP$Scheduler$init(void);
#line 61
static  void RealMainP$Scheduler$taskLoop(void);
#line 54
static  bool RealMainP$Scheduler$runNextTask(void);
# 52 "/opt/tinyos-2.x/tos/system/RealMainP.nc"
int main(void)   ;
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(
# 45 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x7ef337e0);
# 59 "/opt/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void SchedulerBasicP$McuSleep$sleep(void);
# 50 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP$__nesc_unnamed4262 {

  SchedulerBasicP$NUM_TASKS = 3U, 
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




static inline   void SchedulerBasicP$TaskBasic$default$runTask(uint8_t id);
# 53 "/opt/tinyos-2.x/tos/chips/pxa27x/McuSleepC.nc"
static inline   void McuSleepC$McuSleep$sleep(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void BlinkC$Timer0$startPeriodic(uint32_t arg_0x7edc0170);
#line 53
static  void BlinkC$Timer1$startPeriodic(uint32_t arg_0x7edc0170);
# 56 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
static   void BlinkC$Leds$led0Toggle(void);
#line 72
static   void BlinkC$Leds$led1Toggle(void);
#line 89
static   void BlinkC$Leds$led2Toggle(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void BlinkC$Timer2$startPeriodic(uint32_t arg_0x7edc0170);
# 49 "BlinkC.nc"
static inline  void BlinkC$Boot$booted(void);






static inline  void BlinkC$Timer0$fired(void);





static inline  void BlinkC$Timer1$fired(void);





static inline  void BlinkC$Timer2$fired(void);
# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void LedsP$Led0$toggle(void);



static   void LedsP$Led0$makeOutput(void);
#line 29
static   void LedsP$Led0$set(void);

static   void LedsP$Led1$toggle(void);



static   void LedsP$Led1$makeOutput(void);
#line 29
static   void LedsP$Led1$set(void);

static   void LedsP$Led2$toggle(void);



static   void LedsP$Led2$makeOutput(void);
#line 29
static   void LedsP$Led2$set(void);
# 45 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void);
#line 73
static inline   void LedsP$Leds$led0Toggle(void);
#line 88
static inline   void LedsP$Leds$led1Toggle(void);
#line 103
static inline   void LedsP$Leds$led2Toggle(void);
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGpioInterrupt.nc"
static   void HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$fired(
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e827228);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void HalPXA27xGeneralIOM$GpioInterrupt$fired(
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e827b60);
# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   bool HalPXA27xGeneralIOM$HplPXA27xGPIOPin$getGPLRbit(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428);
# 52 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPDRbit(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428, 
# 52 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
bool arg_0x7eda11d0);
#line 72
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPCRbit(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428);
# 124 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   bool HalPXA27xGeneralIOM$HplPXA27xGPIOPin$clearGEDRbit(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428);
# 66 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPSRbit(
# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
uint8_t arg_0x7e826428);




static inline   void HalPXA27xGeneralIOM$GeneralIO$set(uint8_t pin);










static   void HalPXA27xGeneralIOM$GeneralIO$toggle(uint8_t pin);
#line 94
static inline   void HalPXA27xGeneralIOM$GeneralIO$makeOutput(uint8_t pin);
#line 150
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$interruptGPIOPin(uint8_t pin);







static inline    void HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$default$fired(uint8_t pin);



static inline    void HalPXA27xGeneralIOM$GpioInterrupt$default$fired(uint8_t pin);
# 96 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/pxa27x/pxa27xhardware.h"
 __inline __nesc_atomic_t __nesc_atomic_start(void )
{
  uint32_t result = 0;
  uint32_t temp = 0;

   __asm volatile (
  "mrs %0,CPSR\n\t"
  "orr %1,%2,%4\n\t"
  "msr CPSR_cf,%3" : 
  "=r"(result), "=r"(temp) : 
  "0"(result), "1"(temp), "i"(0x000000C0));

   __asm volatile ("" :  :  : "memory");
  return result;
}

 __inline void __nesc_atomic_end(__nesc_atomic_t oldState)
{
  uint32_t statusReg = 0;

   __asm volatile ("" :  :  : "memory");
  oldState &= 0x000000C0;
   __asm volatile (
  "mrs %0,CPSR\n\t"
  "bic %0, %1, %2\n\t"
  "orr %0, %1, %3\n\t"
  "msr CPSR_c, %1" : 
  "=r"(statusReg) : 
  "0"(statusReg), "i"(0x000000C0), "r"(oldState));


  return;
}

# 59 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
static inline uint32_t HplPXA27xInterruptM$getICHP(void)
#line 59
{
  uint32_t val;

   __asm volatile ("mrc p6,0,%0,c5,c0,0\n\t" : "=r"(val));
  return val;
}

# 112 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   bool PlatformP$OST0M3$clearOSSRbit(void){
#line 112
  unsigned char result;
#line 112

#line 112
  result = HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(3);
#line 112

#line 112
  return result;
#line 112
}
#line 112







inline static   void PlatformP$OST0M3$setOIERbit(bool arg_0x7ee40798){
#line 119
  HplPXA27xOSTimerM$PXA27xOST$setOIERbit(3, arg_0x7ee40798);
#line 119
}
#line 119
# 153 "/opt/tinyos-2.x-contrib/intelmote2/tos/platforms/intelmote2/PlatformP.nc"
static inline   void PlatformP$OST0M3$fired(void)
{
  PlatformP$OST0M3$setOIERbit(FALSE);
  PlatformP$OST0M3$clearOSSRbit();
  return;
}

# 233 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline    void HplPXA27xOSTimerM$PXA27xOST$default$fired(uint8_t chnl_id)
{
  HplPXA27xOSTimerM$PXA27xOST$setOIERbit(chnl_id, FALSE);
  HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(chnl_id);
  return;
}

# 139 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   void HplPXA27xOSTimerM$PXA27xOST$fired(uint8_t arg_0x7eb42de0){
#line 139
  switch (arg_0x7eb42de0) {
#line 139
    case 3:
#line 139
      PlatformP$OST0M3$fired();
#line 139
      break;
#line 139
    case 4:
#line 139
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$fired();
#line 139
      break;
#line 139
    default:
#line 139
      HplPXA27xOSTimerM$PXA27xOST$default$fired(arg_0x7eb42de0);
#line 139
      break;
#line 139
    }
#line 139
}
#line 139
# 55 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline void HplPXA27xOSTimerM$DispatchOSTInterrupt(uint8_t id)
{
  HplPXA27xOSTimerM$PXA27xOST$fired(id);
  return;
}

# 87 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/pxa27x/pxa27xhardware.h"
static __inline uint32_t _pxa27x_clzui(uint32_t i)
#line 87
{
  uint32_t count;

#line 89
   __asm volatile ("clz %0,%1" : "=r"(count) : "r"(i));
  return count;
}

# 216 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   void HplPXA27xOSTimerM$OST4_11Irq$fired(void)
{
  uint32_t statusReg;
  uint8_t chnl;

  statusReg = * (volatile uint32_t *)0x40A00014;
  statusReg &= ~((((1 << 3) | (1 << 2)) | (1 << 1)) | (1 << 0));

  while (statusReg) {
      chnl = 31 - _pxa27x_clzui(statusReg);
      HplPXA27xOSTimerM$DispatchOSTInterrupt(chnl);
      statusReg &= ~(1 << chnl);
    }

  return;
}

#line 211
static inline   void HplPXA27xOSTimerM$OST3Irq$fired(void)
{
  HplPXA27xOSTimerM$DispatchOSTInterrupt(3);
}

#line 206
static inline   void HplPXA27xOSTimerM$OST2Irq$fired(void)
{
  HplPXA27xOSTimerM$DispatchOSTInterrupt(2);
}

#line 201
static inline   void HplPXA27xOSTimerM$OST1Irq$fired(void)
{
  HplPXA27xOSTimerM$DispatchOSTInterrupt(1);
}

#line 196
static inline   void HplPXA27xOSTimerM$OST0Irq$fired(void)
{
  HplPXA27xOSTimerM$DispatchOSTInterrupt(0);
}

# 140 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
static inline   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setISAR(uint32_t val)
#line 140
{
  switch (1) {
      case 0: * (volatile uint32_t *)0x403016A0 = val;
#line 142
      break;
      case 1: * (volatile uint32_t *)0x40F001A0 = val;
#line 143
      break;
      default: break;
    }
  return;
}

# 51 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
inline static   void PMICM$PI2C$setISAR(uint32_t arg_0x7ed80e38){
#line 51
  /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setISAR(arg_0x7ed80e38);
#line 51
}
#line 51
# 132 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
static inline   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getISR(void)
#line 132
{
  switch (1) {
      case 0: return * (volatile uint32_t *)0x40301698;
#line 134
      break;
      case 1: return * (volatile uint32_t *)0x40F00198;
#line 135
      break;
      default: return 0;
    }
}

# 49 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
inline static   uint32_t PMICM$PI2C$getISR(void){
#line 49
  unsigned int result;
#line 49

#line 49
  result = /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getISR();
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 259 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static inline   void PMICM$PI2C$interruptI2C(void)
#line 259
{
  uint32_t status;
#line 260
  uint32_t update = 0;

#line 261
  status = PMICM$PI2C$getISR();
  if (status & (1 << 6)) {
      update |= 1 << 6;
    }


  if (status & (1 << 10)) {
      update |= 1 << 10;
    }

  PMICM$PI2C$setISAR(update);
}

# 54 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
inline static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$interruptI2C(void){
#line 54
  PMICM$PI2C$interruptI2C();
#line 54
}
#line 54
# 157 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
static inline   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$fired(void)
#line 157
{

  /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$interruptI2C();
  return;
}

# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(uint8_t arg_0x7e9c0698){
#line 150
  HalPXA27xGeneralIOM$HplPXA27xGPIOPin$interruptGPIOPin(arg_0x7e9c0698);
#line 150
  switch (arg_0x7e9c0698) {
#line 150
    case 1:
#line 150
      PMICM$PMICGPIO$interruptGPIOPin();
#line 150
      break;
#line 150
  }
#line 150
}
#line 150
# 259 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline    void HplPXA27xGPIOM$HplPXA27xGPIO$default$fired(void)
#line 259
{
  return;
}

# 132 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIO.nc"
inline static   void HplPXA27xGPIOM$HplPXA27xGPIO$fired(void){
#line 132
  HplPXA27xGPIOM$HplPXA27xGPIO$default$fired();
#line 132
}
#line 132
# 263 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   void HplPXA27xGPIOM$GPIOIrq$fired(void)
{

  uint32_t DetectReg;
  uint8_t pin;

  HplPXA27xGPIOM$HplPXA27xGPIO$fired();
  /* atomic removed: atomic calls only */

  DetectReg = * (volatile uint32_t *)0x40E00048 & ~((1 << 1) | (1 << 0));

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(pin);
      DetectReg &= ~(1 << pin);
    }
  /* atomic removed: atomic calls only */
  DetectReg = * (volatile uint32_t *)0x40E0004C;

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(pin + 32);
      DetectReg &= ~(1 << pin);
    }
  /* atomic removed: atomic calls only */
  DetectReg = * (volatile uint32_t *)0x40E00050;

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(pin + 64);
      DetectReg &= ~(1 << pin);
    }
  /* atomic removed: atomic calls only */
  DetectReg = * (volatile uint32_t *)0x40E00148;

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(pin + 96);
      DetectReg &= ~(1 << pin);
    }

  return;
}






static inline   void HplPXA27xGPIOM$GPIOIrq1$fired(void)
{
  HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(1);
}

#line 307
static inline   void HplPXA27xGPIOM$GPIOIrq0$fired(void)
{
  HplPXA27xGPIOM$HplPXA27xGPIOPin$interruptGPIOPin(0);
}

# 227 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
static inline    void HplPXA27xInterruptM$PXA27xIrq$default$fired(uint8_t id)
{
  return;
}

# 75 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
inline static   void HplPXA27xInterruptM$PXA27xIrq$fired(uint8_t arg_0x7ead1010){
#line 75
  switch (arg_0x7ead1010) {
#line 75
    case 6:
#line 75
      /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$fired();
#line 75
      break;
#line 75
    case 7:
#line 75
      HplPXA27xOSTimerM$OST4_11Irq$fired();
#line 75
      break;
#line 75
    case 8:
#line 75
      HplPXA27xGPIOM$GPIOIrq0$fired();
#line 75
      break;
#line 75
    case 9:
#line 75
      HplPXA27xGPIOM$GPIOIrq1$fired();
#line 75
      break;
#line 75
    case 10:
#line 75
      HplPXA27xGPIOM$GPIOIrq$fired();
#line 75
      break;
#line 75
    case 26:
#line 75
      HplPXA27xOSTimerM$OST0Irq$fired();
#line 75
      break;
#line 75
    case 27:
#line 75
      HplPXA27xOSTimerM$OST1Irq$fired();
#line 75
      break;
#line 75
    case 28:
#line 75
      HplPXA27xOSTimerM$OST2Irq$fired();
#line 75
      break;
#line 75
    case 29:
#line 75
      HplPXA27xOSTimerM$OST3Irq$fired();
#line 75
      break;
#line 75
    default:
#line 75
      HplPXA27xInterruptM$PXA27xIrq$default$fired(arg_0x7ead1010);
#line 75
      break;
#line 75
    }
#line 75
}
#line 75
# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$clearGEDRbit(uint8_t pin)
{
  bool flag;

#line 153
  flag = (*(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E00048 + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E00148) & (1 << (pin & 0x1f))) != 0;
  *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E00048 + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E00148) = 1 << (pin & 0x1f);
  return flag;
}

# 124 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   bool HalPXA27xGeneralIOM$HplPXA27xGPIOPin$clearGEDRbit(uint8_t arg_0x7e826428){
#line 124
  unsigned char result;
#line 124

#line 124
  result = HplPXA27xGPIOM$HplPXA27xGPIOPin$clearGEDRbit(arg_0x7e826428);
#line 124

#line 124
  return result;
#line 124
}
#line 124
# 158 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static inline    void HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$default$fired(uint8_t pin)
#line 158
{
  return;
}

# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGpioInterrupt.nc"
inline static   void HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$fired(uint8_t arg_0x7e827228){
#line 65
    HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$default$fired(arg_0x7e827228);
#line 65
}
#line 65
# 162 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static inline    void HalPXA27xGeneralIOM$GpioInterrupt$default$fired(uint8_t pin)
#line 162
{
  return;
}

# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void HalPXA27xGeneralIOM$GpioInterrupt$fired(uint8_t arg_0x7e827b60){
#line 57
    HalPXA27xGeneralIOM$GpioInterrupt$default$fired(arg_0x7e827b60);
#line 57
}
#line 57
# 42 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
inline static   void PMICM$PI2C$setIDBR(uint32_t arg_0x7ed81608){
#line 42
  /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setIDBR(arg_0x7ed81608);
#line 42
}
#line 42

inline static   uint32_t PMICM$PI2C$getIDBR(void){
#line 43
  unsigned int result;
#line 43

#line 43
  result = /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getIDBR();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 186 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   void HplPXA27xOSTimerM$PXA27xWD$enableWatchdog(void)
{
  * (volatile uint32_t *)0x40A00018 = 1 << 0;
}

# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerWatchdog.nc"
inline static   void PlatformP$PXA27xWD$enableWatchdog(void){
#line 45
  HplPXA27xOSTimerM$PXA27xWD$enableWatchdog();
#line 45
}
#line 45
# 64 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   uint32_t PlatformP$OST0M3$getOSCR(void){
#line 64
  unsigned int result;
#line 64

#line 64
  result = HplPXA27xOSTimerM$PXA27xOST$getOSCR(3);
#line 64

#line 64
  return result;
#line 64
}
#line 64







inline static   void PlatformP$OST0M3$setOSMR(uint32_t arg_0x7ee43030){
#line 71
  HplPXA27xOSTimerM$PXA27xOST$setOSMR(3, arg_0x7ee43030);
#line 71
}
#line 71
# 146 "/opt/tinyos-2.x-contrib/intelmote2/tos/platforms/intelmote2/PlatformP.nc"
static inline   void PlatformP$PlatformReset$reset(void)
#line 146
{
  PlatformP$OST0M3$setOSMR(PlatformP$OST0M3$getOSCR() + 1000);
  PlatformP$PXA27xWD$enableWatchdog();
  while (1) ;
  return;
}

# 32 "/opt/tinyos-2.x/tos/platforms/intelmote2/PlatformReset.nc"
inline static   void PMICM$PlatformReset$reset(void){
#line 32
  PlatformP$PlatformReset$reset();
#line 32
}
#line 32
# 112 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   bool /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$clearOSSRbit(void){
#line 112
  unsigned char result;
#line 112

#line 112
  result = HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(4);
#line 112

#line 112
  return result;
#line 112
}
#line 112
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 70 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$fired(void)
{
#line 71
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$postTask();
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$fired(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$fired();
#line 67
}
#line 67
# 86 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

static inline  void SchedulerBasicP$Scheduler$init(void)
{
  /* atomic removed: atomic calls only */
  {
    memset((void *)SchedulerBasicP$m_next, SchedulerBasicP$NO_TASK, sizeof SchedulerBasicP$m_next);
    SchedulerBasicP$m_head = SchedulerBasicP$NO_TASK;
    SchedulerBasicP$m_tail = SchedulerBasicP$NO_TASK;
  }
}

# 46 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$init(void){
#line 46
  SchedulerBasicP$Scheduler$init();
#line 46
}
#line 46
# 66 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPSRbit(uint8_t arg_0x7e826428){
#line 66
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPSRbit(arg_0x7e826428);
#line 66
}
#line 66
# 54 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static inline   void HalPXA27xGeneralIOM$GeneralIO$set(uint8_t pin)
#line 54
{
  /* atomic removed: atomic calls only */
  HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPSRbit(pin);
  return;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$set(void){
#line 29
  HalPXA27xGeneralIOM$GeneralIO$set(105);
#line 29
}
#line 29
inline static   void LedsP$Led1$set(void){
#line 29
  HalPXA27xGeneralIOM$GeneralIO$set(104);
#line 29
}
#line 29
inline static   void LedsP$Led0$set(void){
#line 29
  HalPXA27xGeneralIOM$GeneralIO$set(103);
#line 29
}
#line 29
# 52 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPDRbit(uint8_t arg_0x7e826428, bool arg_0x7eda11d0){
#line 52
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPDRbit(arg_0x7e826428, arg_0x7eda11d0);
#line 52
}
#line 52
# 94 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static inline   void HalPXA27xGeneralIOM$GeneralIO$makeOutput(uint8_t pin)
#line 94
{
  /* atomic removed: atomic calls only */
#line 95
  HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPDRbit(pin, TRUE);
  return;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$makeOutput(void){
#line 35
  HalPXA27xGeneralIOM$GeneralIO$makeOutput(105);
#line 35
}
#line 35
inline static   void LedsP$Led1$makeOutput(void){
#line 35
  HalPXA27xGeneralIOM$GeneralIO$makeOutput(104);
#line 35
}
#line 35
inline static   void LedsP$Led0$makeOutput(void){
#line 35
  HalPXA27xGeneralIOM$GeneralIO$makeOutput(103);
#line 35
}
#line 35
# 45 "/opt/tinyos-2.x/tos/system/LedsP.nc"
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

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$InitL3$init(void){
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
# 171 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static inline void PMICM$startLDOs(void)
#line 171
{

  uint8_t oldVal;
#line 173
  uint8_t newVal;



  PMICM$readPMIC(0x17, &oldVal, 1);
  newVal = (oldVal | 0x2) | 0x4;
  PMICM$writePMIC(0x17, newVal);

  PMICM$readPMIC(0x98, &oldVal, 1);
  newVal = (oldVal | 0x4) | 0x8;
  PMICM$writePMIC(0x98, newVal);




  PMICM$readPMIC(0x97, &oldVal, 1);
  newVal = oldVal | 0x20;
  PMICM$writePMIC(0x97, newVal);
}

#line 303
static inline  error_t PMICM$PMIC$setCoreVoltage(uint8_t trimValue)
#line 303
{
  PMICM$writePMIC(0x15, (trimValue & 0x1f) | 0x80);
  return SUCCESS;
}

# 129 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGFERbit(uint8_t pin, bool flag)
{
  if (flag) {
      *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E0003C + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E0013C) |= 1 << (pin & 0x1f);
    }
  else {
      *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E0003C + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E0013C) &= ~(1 << (pin & 0x1f));
    }
  return;
}

# 101 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void PMICM$PMICGPIO$setGFERbit(bool arg_0x7ed93718){
#line 101
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGFERbit(1, arg_0x7ed93718);
#line 101
}
#line 101
#line 52
inline static   void PMICM$PMICGPIO$setGPDRbit(bool arg_0x7eda11d0){
#line 52
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPDRbit(1, arg_0x7eda11d0);
#line 52
}
#line 52
# 158 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGAFRpin(uint8_t pin, uint8_t func)
{
  func &= 0x3;
  * (volatile uint32_t *)((uint32_t )0x40E00054 + (uint32_t )((pin & 0x70) >> 2)) = (* (volatile uint32_t *)((uint32_t )0x40E00054 + (uint32_t )((pin & 0x70) >> 2)) & ~(3 << ((pin & 0x0f) << 1))) | (func << ((pin & 0x0f) << 1));
  return;
}

# 134 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void PMICM$PMICGPIO$setGAFRpin(uint8_t arg_0x7ed910f8){
#line 134
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGAFRpin(1, arg_0x7ed910f8);
#line 134
}
#line 134
# 46 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2C.nc"
inline static   uint32_t PMICM$PI2C$getICR(void){
#line 46
  unsigned int result;
#line 46

#line 46
  result = /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getICR();
#line 46

#line 46
  return result;
#line 46
}
#line 46
#line 45
inline static   void PMICM$PI2C$setICR(uint32_t arg_0x7ed81dd0){
#line 45
  /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setICR(arg_0x7ed81dd0);
#line 45
}
#line 45
# 219 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static inline  error_t PMICM$Init$init(void)
#line 219
{
  uint8_t val[3];

#line 221
  * (volatile uint32_t *)0x40F0001C |= 1 << 6;
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | ((1 << 6) | (1 << 5)));
  /* atomic removed: atomic calls only */
#line 223
  {
    PMICM$gotReset = FALSE;
  }

  PMICM$PMICGPIO$setGAFRpin(0);
  PMICM$PMICGPIO$setGPDRbit(FALSE);
  PMICM$PMICGPIO$setGFERbit(TRUE);




  PMICM$writePMIC(0x08, (
  0x80 | 0x8) | 0x4);


  PMICM$writePMIC(0x05, ~0x1);
  PMICM$writePMIC(0x06, 0xFF);
  PMICM$writePMIC(0x07, 0xFF);


  PMICM$readPMIC(0x01, val, 3);









  PMICM$PMIC$setCoreVoltage(0x10);

  PMICM$startLDOs();
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$InitL2$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = PMICM$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 55 "/opt/tinyos-2.x/tos/types/TinyError.h"
static inline error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 193 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
static inline   void HplPXA27xInterruptM$PXA27xIrq$enable(uint8_t id)
{
  HplPXA27xInterruptM$enable(id);
  return;
}

# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
inline static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(6);
#line 65
}
#line 65
# 188 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
static inline   error_t HplPXA27xInterruptM$PXA27xIrq$allocate(uint8_t id)
{
  return HplPXA27xInterruptM$allocate(id, FALSE, TOSH_IRP_TABLE[id]);
}

# 60 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
inline static   error_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(6);
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 54 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
static inline  error_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$Init$init(void)
#line 54
{
  bool isInited;

  /* atomic removed: atomic calls only */
#line 57
  {
    isInited = /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$m_fInit;
    /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$m_fInit = TRUE;
  }

  if (!isInited) {
      switch (1) {
          case 0: 
            * (volatile uint32_t *)0x41300004 |= 1 << 14;
          * (volatile uint32_t *)0x40301690 = 0;
          break;
          case 1: 
            * (volatile uint32_t *)0x41300004 |= 1 << 15;
          * (volatile uint32_t *)0x40F00190 = 0;
          break;
          default: 
            break;
        }
      /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$allocate();
      /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2CIrq$enable();
    }

  return SUCCESS;
}

# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
inline static   void HplPXA27xGPIOM$GPIOIrq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(10);
#line 65
}
#line 65
inline static   void HplPXA27xGPIOM$GPIOIrq1$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(9);
#line 65
}
#line 65
inline static   void HplPXA27xGPIOM$GPIOIrq0$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(8);
#line 65
}
#line 65
#line 60
inline static   error_t HplPXA27xGPIOM$GPIOIrq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(10);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xGPIOM$GPIOIrq1$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(9);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xGPIOM$GPIOIrq0$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(8);
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 60 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline  error_t HplPXA27xGPIOM$Init$init(void)
{
  bool isInited;

  /* atomic removed: atomic calls only */
#line 64
  {
    isInited = HplPXA27xGPIOM$gfInitialized;
    HplPXA27xGPIOM$gfInitialized = TRUE;
  }

  if (!isInited) {
      HplPXA27xGPIOM$GPIOIrq0$allocate();
      HplPXA27xGPIOM$GPIOIrq1$allocate();
      HplPXA27xGPIOM$GPIOIrq$allocate();
      HplPXA27xGPIOM$GPIOIrq0$enable();
      HplPXA27xGPIOM$GPIOIrq1$enable();
      HplPXA27xGPIOM$GPIOIrq$enable();
    }
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$InitL1$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = HplPXA27xGPIOM$Init$init();
#line 51
  result = ecombine(result, /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 160 "/opt/tinyos-2.x-contrib/intelmote2/tos/platforms/intelmote2/PlatformP.nc"
static inline   error_t PlatformP$InitL0$default$init(void)
#line 160
{
#line 160
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$InitL0$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = PlatformP$InitL0$default$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 243 "/opt/tinyos-2.x/tos/platforms/intelmote2/hardware.h"
static inline void TOSH_SET_PIN_DIRECTIONS(void )
{

  * (volatile uint32_t *)0x40F00004 = (1 << 5) | (1 << 4);
}

# 53 "/opt/tinyos-2.x-contrib/intelmote2/tos/platforms/intelmote2/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void)
#line 53
{


  * (volatile uint32_t *)0x41300004 = (((1 << 22) | (1 << 20)) | (1 << 15)) | (1 << 9);

  * (volatile uint32_t *)0x48000048 = (((1 << 24) | ((
  0 & 0xF) << 8)) | ((1 & 0xF) << 4)) | ((4 & 0xF) << 0);


  * (volatile uint32_t *)0x41300008 = 1 << 1;
  while ((* (volatile uint32_t *)0x41300008 & (1 << 0)) == 0) ;

  TOSH_SET_PIN_DIRECTIONS();



   __asm volatile ("mcr p15,0,%0,c15,c1,0\n\t" :  : "r"(0x43));
#line 103
  {

    * (volatile uint32_t *)0x41300000 = ((16 & 0x1f) | ((2 & 0xf) << 7)) | (1 << 25);
     __asm volatile (
    "mcr p14,0,%0,c6,c0,0\n\t" :  : 

    "r"(((1 << 3) | (1 << 1)) | (1 << 0)));}
#line 129
  memsetup();
  enableICache();
  enableDCache();





  PlatformP$InitL0$init();
  PlatformP$InitL1$init();
  PlatformP$InitL2$init();
  PlatformP$InitL3$init();


  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
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
# 54 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
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
# 71 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSMR(uint32_t arg_0x7ee43030){
#line 71
  HplPXA27xOSTimerM$PXA27xOST$setOSMR(4, arg_0x7ee43030);
#line 71
}
#line 71
# 138 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   bool HplPXA27xOSTimerM$PXA27xOST$getOSSRbit(uint8_t chnl_id)
{
  bool bFlag = FALSE;

  if ((* (volatile uint32_t *)0x40A00014 & (1 << chnl_id)) != 0) {
      bFlag = TRUE;
    }

  return bFlag;
}

# 103 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   bool /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSSRbit(void){
#line 103
  unsigned char result;
#line 103

#line 103
  result = HplPXA27xOSTimerM$PXA27xOST$getOSSRbit(4);
#line 103

#line 103
  return result;
#line 103
}
#line 103
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 114 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSMR(uint8_t chnl_id)
{
  uint32_t val;

#line 117
  val = *(chnl_id < 4 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00000 + (uint32_t )(chnl_id << 2)) : & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00080 + (uint32_t )((chnl_id - 4) << 2)));
  return val;
}

# 78 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSMR(void){
#line 78
  unsigned int result;
#line 78

#line 78
  result = HplPXA27xOSTimerM$PXA27xOST$getOSMR(4);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 156 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static inline   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getAlarm(void)
#line 156
{
  return /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSMR();
}

# 105 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getAlarm(void){
#line 105
  unsigned int result;
#line 105

#line 105
  result = /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getAlarm();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 64 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSCR(void){
#line 64
  unsigned int result;
#line 64

#line 64
  result = HplPXA27xOSTimerM$PXA27xOST$getOSCR(4);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 152 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static inline   uint32_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getNow(void)
#line 152
{
  return /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSCR();
}

# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getNow(void){
#line 98
  unsigned int result;
#line 98

#line 98
  result = /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 85 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$getNow(void)
{
#line 86
  return /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getNow();
}

# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$getNow(void){
#line 125
  unsigned int result;
#line 125

#line 125
  result = /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$getNow();
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 128 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$fired(void)
{
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$fireTimers(/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$getNow());
}

# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$fired(void){
#line 72
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$fired();
#line 72
}
#line 72
# 153 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$stop(uint8_t num)
{
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$m_timers[num].isrunning = FALSE;
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void PMICM$chargeMonitorTimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$stop(0U);
#line 67
}
#line 67
# 358 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static inline  error_t PMICM$PMIC$getBatteryVoltage(uint8_t *val)
#line 358
{

  return PMICM$getPMICADCVal(0, val);
}

# 143 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$startTimer(num, /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$getNow(), dt, FALSE);
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void PMICM$chargeMonitorTimer$startPeriodic(uint32_t arg_0x7edc0170){
#line 53
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(0U, arg_0x7edc0170);
#line 53
}
#line 53
# 375 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static inline  error_t PMICM$PMIC$enableManualCharging(bool enable)
#line 375
{

  uint8_t val;

  if (enable) {

      PMICM$getPMICADCVal(2, &val);

      if (val > 75) {


          PMICM$writePMIC(0x2A, 8);

          PMICM$writePMIC(0x28, ((1 << 7) | ((1 & 0xF) << 3)) | (7 & 0x7));

          PMICM$writePMIC(0x20, 0x80);

          PMICM$chargeMonitorTimer$startPeriodic(300000);
        }
      else {
        }
    }
  else 
    {

      PMICM$PMIC$getBatteryVoltage(&val);


      PMICM$writePMIC(0x2A, 0);
      PMICM$writePMIC(0x28, 0);
      PMICM$writePMIC(0x20, 0x00);
    }
  return SUCCESS;
}

static inline  void PMICM$chargeMonitorTimer$fired(void)
#line 410
{
  uint8_t val;

#line 412
  PMICM$PMIC$getBatteryVoltage(&val);

  if (val > 130) {
      PMICM$PMIC$enableManualCharging(FALSE);
      PMICM$chargeMonitorTimer$stop();
    }
  return;
}

# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$toggle(void){
#line 31
  HalPXA27xGeneralIOM$GeneralIO$toggle(103);
#line 31
}
#line 31
# 73 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led0Toggle(void)
#line 73
{
  LedsP$Led0$toggle();
  ;
#line 75
  ;
}

# 56 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void BlinkC$Leds$led0Toggle(void){
#line 56
  LedsP$Leds$led0Toggle();
#line 56
}
#line 56
# 56 "BlinkC.nc"
static inline  void BlinkC$Timer0$fired(void)
{
  ;
  BlinkC$Leds$led0Toggle();
}

# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$toggle(void){
#line 31
  HalPXA27xGeneralIOM$GeneralIO$toggle(104);
#line 31
}
#line 31
# 88 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led1Toggle(void)
#line 88
{
  LedsP$Led1$toggle();
  ;
#line 90
  ;
}

# 72 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void BlinkC$Leds$led1Toggle(void){
#line 72
  LedsP$Leds$led1Toggle();
#line 72
}
#line 72
# 62 "BlinkC.nc"
static inline  void BlinkC$Timer1$fired(void)
{
  ;
  BlinkC$Leds$led1Toggle();
}

# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$toggle(void){
#line 31
  HalPXA27xGeneralIOM$GeneralIO$toggle(105);
#line 31
}
#line 31
# 103 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led2Toggle(void)
#line 103
{
  LedsP$Led2$toggle();
  ;
#line 105
  ;
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void BlinkC$Leds$led2Toggle(void){
#line 89
  LedsP$Leds$led2Toggle();
#line 89
}
#line 89
# 68 "BlinkC.nc"
static inline  void BlinkC$Timer2$fired(void)
{
  ;
  BlinkC$Leds$led2Toggle();
}

# 193 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline   void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num)
{
}

# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$fired(uint8_t arg_0x7eca0298){
#line 72
  switch (arg_0x7eca0298) {
#line 72
    case 0U:
#line 72
      PMICM$chargeMonitorTimer$fired();
#line 72
      break;
#line 72
    case 1U:
#line 72
      BlinkC$Timer0$fired();
#line 72
      break;
#line 72
    case 2U:
#line 72
      BlinkC$Timer1$fired();
#line 72
      break;
#line 72
    case 3U:
#line 72
      BlinkC$Timer2$fired();
#line 72
      break;
#line 72
    default:
#line 72
      /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$default$fired(arg_0x7eca0298);
#line 72
      break;
#line 72
    }
#line 72
}
#line 72
# 80 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   bool HplPXA27xGPIOM$HplPXA27xGPIOPin$getGPLRbit(uint8_t pin)
{
  return (*(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E00000 + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E00100) & (1 << (pin & 0x1f))) != 0;
}

# 45 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   bool HalPXA27xGeneralIOM$HplPXA27xGPIOPin$getGPLRbit(uint8_t arg_0x7e826428){
#line 45
  unsigned char result;
#line 45

#line 45
  result = HplPXA27xGPIOM$HplPXA27xGPIOPin$getGPLRbit(arg_0x7e826428);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 107 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static inline   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPCRbit(uint8_t pin)
{
  *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E00024 + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E00124) = 1 << (pin & 0x1f);
  return;
}

# 72 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOPin.nc"
inline static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPCRbit(uint8_t arg_0x7e826428){
#line 72
  HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPCRbit(arg_0x7e826428);
#line 72
}
#line 72
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 119 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(bool arg_0x7ee40798){
#line 119
  HplPXA27xOSTimerM$PXA27xOST$setOIERbit(4, arg_0x7ee40798);
#line 119
}
#line 119
# 117 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static inline   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$stop(void)
#line 117
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 118
    {
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(FALSE);
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning = FALSE;
    }
#line 121
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$stop(void){
#line 62
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$stop();
#line 62
}
#line 62
# 60 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$stop(void)
{
#line 61
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$stop();
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$stop(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$stop();
#line 67
}
#line 67
# 92 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type arg_0x7ec03220, /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$size_type arg_0x7ec033b0){
#line 92
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$startAt(arg_0x7ec03220, arg_0x7ec033b0);
#line 92
}
#line 92
# 47 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$start(uint32_t t0, uint32_t dt, bool oneshot)
{
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_dt = dt;
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_oneshot = oneshot;
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$startAt(t0, dt);
}

#line 82
static inline  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t t0, uint32_t dt)
{
#line 83
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$start(t0, dt, TRUE);
}

# 118 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x7edb35f0, uint32_t arg_0x7edb3780){
#line 118
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$startOneShotAt(arg_0x7edb35f0, arg_0x7edb3780);
#line 118
}
#line 118
# 87 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   void HplPXA27xOSTimerM$PXA27xOST$setOSCR(uint8_t chnl_id, uint32_t val)
{
  uint8_t remap_id;

  remap_id = chnl_id < 4 ? 0 : chnl_id;
  *(remap_id == 0 ? & * (volatile uint32_t *)0x40A00010 : & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00040 + (uint32_t )((remap_id - 4) << 2))) = val;

  return;
}

# 57 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSCR(uint32_t arg_0x7ee502e8){
#line 57
  HplPXA27xOSTimerM$PXA27xOST$setOSCR(4, arg_0x7ee502e8);
#line 57
}
#line 57
# 121 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline   void HplPXA27xOSTimerM$PXA27xOST$setOMCR(uint8_t chnl_id, uint32_t val)
{
  if (chnl_id > 3) {
      * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A000C0 + (uint32_t )((chnl_id - 4) << 2)) = val;
    }
  return;
}

# 85 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimer.nc"
inline static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOMCR(uint32_t arg_0x7ee43d20){
#line 85
  HplPXA27xOSTimerM$PXA27xOST$setOMCR(4, arg_0x7ee43d20);
#line 85
}
#line 85
# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterrupt.nc"
inline static   void HplPXA27xOSTimerM$OST4_11Irq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(7);
#line 65
}
#line 65
inline static   void HplPXA27xOSTimerM$OST3Irq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(29);
#line 65
}
#line 65
inline static   void HplPXA27xOSTimerM$OST2Irq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(28);
#line 65
}
#line 65
inline static   void HplPXA27xOSTimerM$OST1Irq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(27);
#line 65
}
#line 65
inline static   void HplPXA27xOSTimerM$OST0Irq$enable(void){
#line 65
  HplPXA27xInterruptM$PXA27xIrq$enable(26);
#line 65
}
#line 65
#line 60
inline static   error_t HplPXA27xOSTimerM$OST4_11Irq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(7);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xOSTimerM$OST3Irq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(29);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xOSTimerM$OST2Irq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(28);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xOSTimerM$OST1Irq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(27);
#line 60

#line 60
  return result;
#line 60
}
#line 60
inline static   error_t HplPXA27xOSTimerM$OST0Irq$allocate(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HplPXA27xInterruptM$PXA27xIrq$allocate(26);
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 61 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static inline  error_t HplPXA27xOSTimerM$Init$init(void)
{
  bool initflag;

  /* atomic removed: atomic calls only */
#line 64
  {
    initflag = HplPXA27xOSTimerM$gfInitialized;
    HplPXA27xOSTimerM$gfInitialized = TRUE;
  }

  if (!initflag) {
      * (volatile uint32_t *)0x40A0001C = 0x0UL;
      * (volatile uint32_t *)0x40A00014 = 0xFFFFFFFF;
      HplPXA27xOSTimerM$OST0Irq$allocate();
      HplPXA27xOSTimerM$OST1Irq$allocate();
      HplPXA27xOSTimerM$OST2Irq$allocate();
      HplPXA27xOSTimerM$OST3Irq$allocate();
      HplPXA27xOSTimerM$OST4_11Irq$allocate();
      HplPXA27xOSTimerM$OST0Irq$enable();
      HplPXA27xOSTimerM$OST1Irq$enable();
      HplPXA27xOSTimerM$OST2Irq$enable();
      HplPXA27xOSTimerM$OST3Irq$enable();
      HplPXA27xOSTimerM$OST4_11Irq$enable();
    }

  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = HplPXA27xOSTimerM$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 63 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static inline  error_t /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Init$init(void)
#line 63
{

  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTInit$init();
  /* atomic removed: atomic calls only */
  {
    /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning = FALSE;
    switch (2) {
        case 1: 
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT = 10;
        break;
        case 2: 
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT = 1;
        break;
        case 3: 
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT = 1;
        break;
        case 4: 
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT = 300;
        break;
        default: 
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mMinDeltaT = 0;
        break;
      }
    /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOMCR(((1 << 7) | (1 << 6)) | (((2 & 0x8) << 5) | ((2 & 0x7) << 0)));
    /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSCR(0);
  }
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t RealMainP$SoftwareInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void BlinkC$Timer2$startPeriodic(uint32_t arg_0x7edc0170){
#line 53
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(3U, arg_0x7edc0170);
#line 53
}
#line 53
inline static  void BlinkC$Timer1$startPeriodic(uint32_t arg_0x7edc0170){
#line 53
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(2U, arg_0x7edc0170);
#line 53
}
#line 53
inline static  void BlinkC$Timer0$startPeriodic(uint32_t arg_0x7edc0170){
#line 53
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$startPeriodic(1U, arg_0x7edc0170);
#line 53
}
#line 53
# 49 "BlinkC.nc"
static inline  void BlinkC$Boot$booted(void)
{
  BlinkC$Timer0$startPeriodic(250);
  BlinkC$Timer1$startPeriodic(500);
  BlinkC$Timer2$startPeriodic(1000);
}

# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
inline static  void RealMainP$Boot$booted(void){
#line 49
  BlinkC$Boot$booted();
#line 49
}
#line 49
# 164 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
static inline   void SchedulerBasicP$TaskBasic$default$runTask(uint8_t id)
{
}

# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x7ef337e0){
#line 64
  switch (arg_0x7ef337e0) {
#line 64
    case /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer:
#line 64
      /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$runTask();
#line 64
      break;
#line 64
    case /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired:
#line 64
      /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$runTask();
#line 64
      break;
#line 64
    case /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm:
#line 64
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$runTask();
#line 64
      break;
#line 64
    default:
#line 64
      SchedulerBasicP$TaskBasic$default$runTask(arg_0x7ef337e0);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 144 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/pxa27x/pxa27xhardware.h"
static __inline void __nesc_disable_interrupt(void)
#line 144
{

  uint32_t statusReg = 0;

   __asm volatile (
  "mrs %0,CPSR\n\t"
  "orr %0,%1,#0xc0\n\t"
  "msr CPSR_c,%1\n\t" : 
  "=r"(statusReg) : 
  "0"(statusReg));

  return;
}

#line 130
static __inline void __nesc_enable_interrupt(void)
#line 130
{

  uint32_t statusReg = 0;

   __asm volatile (
  "mrs %0,CPSR\n\t"
  "bic %0,%1,#0xc0\n\t"
  "msr CPSR_c, %1" : 
  "=r"(statusReg) : 
  "0"(statusReg));

  return;
}

# 53 "/opt/tinyos-2.x/tos/chips/pxa27x/McuSleepC.nc"
static inline   void McuSleepC$McuSleep$sleep(void)
#line 53
{

   __asm volatile (
  "mcr p14,0,%0,c7,c0,0" :  : 

  "r"(1));

  __nesc_enable_interrupt();
  __nesc_disable_interrupt();
  return;
}

# 59 "/opt/tinyos-2.x/tos/interfaces/McuSleep.nc"
inline static   void SchedulerBasicP$McuSleep$sleep(void){
#line 59
  McuSleepC$McuSleep$sleep();
#line 59
}
#line 59
# 67 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 61 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
inline static  void RealMainP$Scheduler$taskLoop(void){
#line 61
  SchedulerBasicP$Scheduler$taskLoop();
#line 61
}
#line 61
# 68 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
__attribute((interrupt("IRQ")))   void hplarmv_irq(void)
#line 68
{

  uint32_t IRQPending;

  IRQPending = HplPXA27xInterruptM$getICHP();
  IRQPending >>= 16;

  while (IRQPending & (1 << 15)) {
      uint8_t PeripheralID = IRQPending & 0x3f;

#line 77
      HplPXA27xInterruptM$PXA27xIrq$fired(PeripheralID);
      IRQPending = HplPXA27xInterruptM$getICHP();
      IRQPending >>= 16;
    }

  return;
}

# 150 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static   void HalPXA27xGeneralIOM$HplPXA27xGPIOPin$interruptGPIOPin(uint8_t pin)
#line 150
{
  HalPXA27xGeneralIOM$HplPXA27xGPIOPin$clearGEDRbit(pin);
  HalPXA27xGeneralIOM$HalPXA27xGpioInterrupt$fired(pin);
  HalPXA27xGeneralIOM$GpioInterrupt$fired(pin);
  return;
}

# 274 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static   void PMICM$PMICGPIO$interruptGPIOPin(void)
#line 274
{
  uint8_t events[3];
  bool localGotReset;



  PMICM$readPMIC(0x01, events, 3);

  if (events[0] & 0x1) {
      /* atomic removed: atomic calls only */
#line 283
      {
        localGotReset = PMICM$gotReset;
      }
      if (localGotReset == TRUE) {
          PMICM$PlatformReset$reset();
        }
      else {
          /* atomic removed: atomic calls only */
#line 290
          {
            PMICM$gotReset = TRUE;
          }
        }
    }
  else {
    }
}

#line 104
static error_t PMICM$readPMIC(uint8_t address, uint8_t *value, uint8_t numBytes)
#line 104
{

  if (numBytes > 0) {
      PMICM$PI2C$setIDBR(0x49 << 1);
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 0));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
      while (PMICM$PI2C$getICR() & (1 << 3)) ;


      PMICM$PI2C$setIDBR(address);
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 0));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 1));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
      while (PMICM$PI2C$getICR() & (1 << 3)) ;
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 1));


      PMICM$PI2C$setIDBR((0x49 << 1) | 1);
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 0));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
      while (PMICM$PI2C$getICR() & (1 << 3)) ;
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 0));


      while (numBytes > 1) {
          PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
          while (PMICM$PI2C$getICR() & (1 << 3)) ;
          *value = PMICM$PI2C$getIDBR();
          value++;
          numBytes--;
        }

      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 1));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 2));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
      while (PMICM$PI2C$getICR() & (1 << 3)) ;
      *value = PMICM$PI2C$getIDBR();
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 1));
      PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 2));

      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 90 "/opt/tinyos-2.x/tos/chips/pxa27x/i2c/HplPXA27xI2CP.nc"
static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setIDBR(uint32_t val)
#line 90
{
  switch (1) {
      case 0: * (volatile uint32_t *)0x40301688 = val;
#line 92
      break;
      case 1: * (volatile uint32_t *)0x40F00188 = val;
#line 93
      break;
      default: break;
    }
  return;
}









static   void /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$setICR(uint32_t val)
#line 107
{
  switch (1) {
      case 0: * (volatile uint32_t *)0x40301690 = val;
#line 109
      break;
      case 1: * (volatile uint32_t *)0x40F00190 = val;
#line 110
      break;
      default: break;
    }
  return;
}

static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getICR(void)
#line 116
{
  switch (1) {
      case 0: return * (volatile uint32_t *)0x40301690;
#line 118
      break;
      case 1: return * (volatile uint32_t *)0x40F00190;
#line 119
      break;
      default: return 0;
    }
}

#line 99
static   uint32_t /*HplPXA27xPI2CC.HplPXA27xI2CP*/HplPXA27xI2CP$0$I2C$getIDBR(void)
#line 99
{
  switch (1) {
      case 0: return * (volatile uint32_t *)0x40301688;
#line 101
      break;
      case 1: return * (volatile uint32_t *)0x40F00188;
#line 102
      break;
      default: return 0;
    }
}

# 108 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HplPXA27xOSTimerM.nc"
static   void HplPXA27xOSTimerM$PXA27xOST$setOSMR(uint8_t chnl_id, uint32_t val)
{
  *(chnl_id < 4 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00000 + (uint32_t )(chnl_id << 2)) : & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00080 + (uint32_t )((chnl_id - 4) << 2))) = val;
  return;
}

#line 97
static   uint32_t HplPXA27xOSTimerM$PXA27xOST$getOSCR(uint8_t chnl_id)
{
  uint8_t remap_id;
  uint32_t val;

  remap_id = chnl_id < 4 ? 0 : chnl_id;
  val = *(remap_id == 0 ? & * (volatile uint32_t *)0x40A00010 : & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40A00040 + (uint32_t )((remap_id - 4) << 2)));

  return val;
}

#line 163
static   void HplPXA27xOSTimerM$PXA27xOST$setOIERbit(uint8_t chnl_id, bool flag)
{
  if (flag == TRUE) {
      * (volatile uint32_t *)0x40A0001C |= 1 << chnl_id;
    }
  else {
      * (volatile uint32_t *)0x40A0001C &= ~(1 << chnl_id);
    }
  return;
}

#line 149
static   bool HplPXA27xOSTimerM$PXA27xOST$clearOSSRbit(uint8_t chnl_id)
{
  bool bFlag = FALSE;

  if ((* (volatile uint32_t *)0x40A00014 & (1 << chnl_id)) != 0) {
      bFlag = TRUE;
    }


  * (volatile uint32_t *)0x40A00014 = 1 << chnl_id;

  return bFlag;
}

# 160 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$fired(void)
#line 160
{
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$clearOSSRbit();
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(FALSE);
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning = FALSE;
  /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$fired();
  return;
}

# 159 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 85 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
__attribute((interrupt("FIQ")))   void hplarmv_fiq(void)
#line 85
{
}

# 52 "/opt/tinyos-2.x/tos/system/RealMainP.nc"
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

# 94 "/opt/tinyos-2.x/tos/chips/pxa27x/HplPXA27xInterruptM.nc"
static error_t HplPXA27xInterruptM$allocate(uint8_t id, bool level, uint8_t priority)
{
  uint32_t tmp;
  error_t error = FAIL;

  /* atomic removed: atomic calls only */
#line 99
  {
    uint8_t i;

#line 101
    if (HplPXA27xInterruptM$usedPriorities == 0) {
        uint8_t PriorityTable[40];
#line 102
        uint8_t DuplicateTable[40];

#line 103
        for (i = 0; i < 40; i++) {
            DuplicateTable[i] = PriorityTable[i] = 0xFF;
          }

        for (i = 0; i < 40; i++) 
          if (TOSH_IRP_TABLE[i] != 0xff) {
              if (PriorityTable[TOSH_IRP_TABLE[i]] != 0xFF) {


                DuplicateTable[i] = PriorityTable[TOSH_IRP_TABLE[i]];
                }
              else {
#line 114
                PriorityTable[TOSH_IRP_TABLE[i]] = i;
                }
            }

        for (i = 0; i < 40; i++) {
            if (PriorityTable[i] != 0xff) {
                PriorityTable[HplPXA27xInterruptM$usedPriorities] = PriorityTable[i];
                if (i != HplPXA27xInterruptM$usedPriorities) {
                  PriorityTable[i] = 0xFF;
                  }
#line 123
                HplPXA27xInterruptM$usedPriorities++;
              }
          }

        for (i = 0; i < 40; i++) 
          if (DuplicateTable[i] != 0xFF) {
              uint8_t j;
#line 129
              uint8_t ExtraTable[40];

#line 130
              for (j = 0; DuplicateTable[i] != PriorityTable[j]; j++) ;
              memcpy(ExtraTable + j + 1, PriorityTable + j, HplPXA27xInterruptM$usedPriorities - j);
              memcpy(PriorityTable + j + 1, ExtraTable + j + 1, 
              HplPXA27xInterruptM$usedPriorities - j);
              PriorityTable[j] = i;
              HplPXA27xInterruptM$usedPriorities++;
            }

        for (i = 0; i < HplPXA27xInterruptM$usedPriorities; i++) {
            * (volatile uint32_t *)((uint32_t )0x40D0001C + (uint32_t )((i & 0x1F) << 2)) = (1 << 31) | PriorityTable[i];
            tmp = * (volatile uint32_t *)((uint32_t )0x40D0001C + (uint32_t )((i & 0x1F) << 2));
          }
      }

    if (id < 34) {
        if (priority == 0xff) {
            priority = HplPXA27xInterruptM$usedPriorities;
            HplPXA27xInterruptM$usedPriorities++;
            * (volatile uint32_t *)((uint32_t )0x40D0001C + (uint32_t )((priority & 0x1F) << 2)) = (1 << 31) | id;
            tmp = * (volatile uint32_t *)((uint32_t )0x40D0001C + (uint32_t )((priority & 0x1F) << 2));
          }
        if (level) {
            *(id & 0x20 ? & * (volatile uint32_t *)0x40D000A4 : & * (volatile uint32_t *)0x40D00008) |= 1 << (id & 0x1f);
            tmp = *(id & 0x20 ? & * (volatile uint32_t *)0x40D000A4 : & * (volatile uint32_t *)0x40D00008);
          }

        error = SUCCESS;
      }
  }
  return error;
}

static void HplPXA27xInterruptM$enable(uint8_t id)
{
  uint32_t tmp;

  /* atomic removed: atomic calls only */
#line 165
  {
    if (id < 34) {
        *(id & 0x20 ? & * (volatile uint32_t *)0x40D000A0 : & * (volatile uint32_t *)0x40D00004) |= 1 << (id & 0x1f);
        tmp = *(id & 0x20 ? & * (volatile uint32_t *)0x40D000A0 : & * (volatile uint32_t *)0x40D00004);
      }
  }
  return;
}

# 85 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPDRbit(uint8_t pin, bool dir)
{
  if (dir) {
      *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E0000C + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E0010C) |= 1 << (pin & 0x1f);
    }
  else {
      *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E0000C + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E0010C) &= ~(1 << (pin & 0x1f));
    }
  return;
}

# 151 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static error_t PMICM$writePMIC(uint8_t address, uint8_t value)
#line 151
{
  PMICM$PI2C$setIDBR(0x49 << 1);
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 0));
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
  while (PMICM$PI2C$getICR() & (1 << 3)) ;

  * (volatile uint32_t *)0x40F00188 = address;
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 0));
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
  while (PMICM$PI2C$getICR() & (1 << 3)) ;

  * (volatile uint32_t *)0x40F00188 = value;
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 1));
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() | (1 << 3));
  while (PMICM$PI2C$getICR() & (1 << 3)) ;
  PMICM$PI2C$setICR(PMICM$PI2C$getICR() & ~(1 << 1));
#line 166
  * (volatile uint32_t *)0x40F00190 &= ~(1 << 1);

  return SUCCESS;
}

# 101 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HplPXA27xGPIOM.nc"
static   void HplPXA27xGPIOM$HplPXA27xGPIOPin$setGPSRbit(uint8_t pin)
{
  *(pin < 96 ? & * (volatile uint32_t *)((uint32_t )& * (volatile uint32_t *)0x40E00018 + (uint32_t )((pin & 0x60) >> 3)) : & * (volatile uint32_t *)0x40E00118) = 1 << (pin & 0x1f);
  return;
}

# 123 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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

# 56 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static  void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$runTask(void)
#line 56
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 57
    {
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning = FALSE;
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$fired();
    }
#line 60
    __nesc_atomic_end(__nesc_atomic); }
}

# 63 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static  void /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$fired$runTask(void)
{
  if (/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_oneshot == FALSE) {
    /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$start(/*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Alarm$getAlarm(), /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$m_dt, FALSE);
    }
#line 67
  /*HilTimerMilliC.AlarmToTimerMilli32*/AlarmToTimerC$0$Timer$fired();
}

# 132 "/opt/tinyos-2.x/tos/chips/pxa27x/timer/HalPXA27xAlarmM.nc"
static   void /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$Alarm$startAt(uint32_t t0, uint32_t dt)
#line 132
{
  uint32_t tf;
#line 133
  uint32_t t1;
  bool bPending;

#line 135
  tf = t0 + dt;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 137
    {
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(TRUE);
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOSMR(tf);
      /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$mfRunning = TRUE;
      t1 = /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSCR();
      bPending = /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$getOSSRbit();
      if (dt <= t1 - t0 && !bPending) {
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$OSTChnl$setOIERbit(FALSE);
          /*HilTimerMilliC.PhysAlarmMilli32*/HalPXA27xAlarmM$0$lateAlarm$postTask();
        }
    }
#line 147
    __nesc_atomic_end(__nesc_atomic); }

  return;
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$fireTimers(uint32_t now)
{
  uint8_t num;

  for (num = 0; num < /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$m_timers[num];

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
              /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer$fired(num);
              break;
            }
        }
    }
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

# 65 "/opt/tinyos-2.x/tos/chips/pxa27x/gpio/HalPXA27xGeneralIOM.nc"
static   void HalPXA27xGeneralIOM$GeneralIO$toggle(uint8_t pin)
#line 65
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 66
    {
      if (HalPXA27xGeneralIOM$HplPXA27xGPIOPin$getGPLRbit(pin)) {
          HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPCRbit(pin);
        }
      else {
          HalPXA27xGeneralIOM$HplPXA27xGPIOPin$setGPSRbit(pin);
        }
    }
#line 73
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 337 "/opt/tinyos-2.x-contrib/intelmote2/tos/chips/da9030/PMICM.nc"
static error_t PMICM$getPMICADCVal(uint8_t channel, uint8_t *val)
#line 337
{
  uint8_t oldval;
  error_t rval;


  rval = PMICM$readPMIC(0x30, &oldval, 1);
  if (rval == SUCCESS) {
      rval = PMICM$writePMIC(0x30, ((channel & 0x7) | (
      1 << 3)) | (1 << 4));
    }
  if (rval == SUCCESS) {
      rval = PMICM$readPMIC(0x40, val, 1);
    }
  if (rval == SUCCESS) {

      rval = PMICM$writePMIC(0x30, oldval);
    }

  return rval;
}

# 133 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot)
{
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$m_timers[num];

#line 136
  timer->t0 = t0;
  timer->dt = dt;
  timer->isoneshot = isoneshot;
  timer->isrunning = TRUE;
  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

#line 89
static  void /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$updateFromTimer$runTask(void)
{




  uint32_t now = /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$getNow();
  int32_t min_remaining = (1UL << 31) - 1;
  bool min_remaining_isset = FALSE;
  uint8_t num;

  /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$stop();

  for (num = 0; num < /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$NUM_TIMERS; num++) 
    {
      /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$m_timers[num];

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
        /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$fireTimers(now);
        }
      else {
#line 124
        /*HilTimerMilliC.VirtTimersMilli32*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(now, min_remaining);
        }
    }
}

