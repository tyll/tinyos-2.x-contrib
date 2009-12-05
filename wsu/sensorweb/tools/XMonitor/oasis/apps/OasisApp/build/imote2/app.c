#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 4 "/opt/tinyos-1.x/tos/platform/pxa27x/inttypes.h"
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
# 12 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/_types.h"
typedef long _off_t;
__extension__ 
#line 13
typedef long long _off64_t;


typedef int _ssize_t;
# 354 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stddef.h" 3
typedef unsigned int wint_t;
# 33 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/_types.h"
#line 25
typedef struct __nesc_unnamed4242 {

  int __count;
  union __nesc_unnamed4243 {

    wint_t __wch;
    unsigned char __wchb[4];
  } __value;
} _mbstate_t;

typedef int _flock_t;
# 19 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/reent.h"
typedef unsigned long __ULong;
# 40 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/reent.h" 3
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







struct _on_exit_args {
  void *_fnargs[32];
  __ULong _fntypes;
};









struct _atexit {
  struct _atexit *_next;
  int _ind;
  void (*_fns[32])(void );
  struct _on_exit_args _on_exit_args;
};









struct __sbuf {
  unsigned char *_base;
  int _size;
};






typedef long _fpos_t;
#line 160
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
#line 253
typedef struct __sFILE __FILE;


struct _glue {

  struct _glue *_next;
  int _niobs;
  __FILE *_iobs;
};
#line 284
struct _rand48 {
  unsigned short _seed[3];
  unsigned short _mult[3];
  unsigned short _add;
};
#line 533
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
#line 730
struct _reent;
# 213 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stddef.h" 3
typedef long unsigned int size_t;
# 25 "/usr/local/wasabi/usr/local/xscale-elf/include/string.h"
void *memmove(void *, const void *, size_t );

char *strcat(char *, const char *);



char *strcpy(char *, const char *);


size_t strlen(const char *);

int strncmp(const char *, const char *, size_t );
char *strncpy(char *, const char *, size_t );
# 325 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stddef.h" 3
typedef int wchar_t;
# 28 "/usr/local/wasabi/usr/local/xscale-elf/include/stdlib.h"
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
# 17 "/usr/local/wasabi/usr/local/xscale-elf/include/math.h"
union __dmath {

  __ULong i[2];
  double d;
};




union __dmath;
#line 72
typedef float float_t;
typedef double double_t;
#line 292
struct exception {


  int type;
  char *name;
  double arg1;
  double arg2;
  double retval;
  int err;
};
#line 347
enum __fdlibm_version {

  __fdlibm_ieee = -1, 
  __fdlibm_svid, 
  __fdlibm_xopen, 
  __fdlibm_posix
};




enum __fdlibm_version;
# 151 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stddef.h" 3
typedef long int ptrdiff_t;
# 91 "/opt/tinyos-1.x/tos/system/tos.h"
typedef unsigned char bool;






enum __nesc_unnamed4249 {
  FALSE = 0, 
  TRUE = 1
};

uint16_t TOS_LOCAL_ADDRESS = 1;

enum __nesc_unnamed4250 {
  FAIL = 0, 
  SUCCESS = 1
};


static inline uint8_t rcombine(uint8_t r1, uint8_t r2);
typedef uint8_t result_t  ;







static inline result_t rcombine(result_t r1, result_t r2);
#line 140
enum __nesc_unnamed4251 {
  NULL = 0x0
};
# 11 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/utils.h"
void *safe_malloc(size_t size);
void *safe_calloc(size_t nelem, size_t elsize);
void *safe_realloc(void *ptr, size_t size);

void safe_free(void *ptr);
# 11 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/systemUtil.h"
void printFatalErrorMsg(const char *msg, uint32_t numArgs, ...);
void printFatalErrorMsgHex(const char *msg, uint32_t numArgs, ...);
void resetNode(void);

struct mallinfo {
  int arena;
  int ordblks;
  int smblks;
  int hblks;
  int hblkhd;
  int usmblks;
  int fsmblks;
  int uordblks;
  int fordblks;
  int keepcost;
};

struct mallinfo mallinfo(void)   ;
# 8 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/assert.h"
extern void printAssertMsg(const char *file, uint32_t line, char *condition)  ;
# 104 "/opt/tinyos-1.x/tos/platform/pxa27x/pxa27xhardware.h"
static inline void TOSH_wait(void);
#line 125
static __inline void TOSH_uwait(uint16_t usec);
#line 140
static __inline uint32_t _pxa27x_clzui(uint32_t i);








typedef uint32_t __nesc_atomic_t;






__inline __nesc_atomic_t __nesc_atomic_start(void )  ;
#line 181
__inline void __nesc_atomic_end(__nesc_atomic_t oldState)  ;
#line 215
static __inline void __nesc_enable_interrupt(void);
#line 230
static __inline void __nesc_atomic_sleep(void);
# 58 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Const.h"
enum __nesc_unnamed4252 {
  CC2420_TIME_BIT = 4, 
  CC2420_TIME_BYTE = CC2420_TIME_BIT << 3, 
  CC2420_TIME_SYMBOL = 16
};










uint8_t CC2420_CHANNEL = 26;
uint8_t CC2420_RFPOWER = 2;

enum __nesc_unnamed4253 {
  CC2420_MIN_CHANNEL = 11, 
  CC2420_MAX_CHANNEL = 26
};
#line 261
enum __nesc_unnamed4254 {
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
# 46 "/opt/tinyos-1.x/tos/platform/imote2/AM.h"
enum __nesc_unnamed4255 {
  TOS_BCAST_ADDR = 0xffff, 
  TOS_UART_ADDR = 0x007e
};





enum __nesc_unnamed4256 {
  TOS_DEFAULT_AM_GROUP = 0x7D
};

uint8_t TOS_AM_GROUP = TOS_DEFAULT_AM_GROUP;
#line 101
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
  uint32_t time32Low __attribute((aligned(32))) ;
  uint32_t time32High;
} __attribute((aligned(32))) __attribute((packed))  TOS_Msg;

enum __nesc_unnamed4257 {

  MSG_HEADER_SIZE = (size_t )& ((struct TOS_Msg *)0)->data - 1, 

  MSG_FOOTER_SIZE = 2, 

  MSG_DATA_SIZE = (size_t )& ((struct TOS_Msg *)0)->strength + sizeof(uint16_t ), 

  DATA_LENGTH = 74, 

  LENGTH_BYTE_NUMBER = (size_t )& ((struct TOS_Msg *)0)->length + 1
};

typedef TOS_Msg *TOS_MsgPtr;
# 83 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
enum __nesc_unnamed4258 {
  TOSH_period16 = 0x00, 
  TOSH_period32 = 0x01, 
  TOSH_period64 = 0x02, 
  TOSH_period128 = 0x03, 
  TOSH_period256 = 0x04, 
  TOSH_period512 = 0x05, 
  TOSH_period1024 = 0x06, 
  TOSH_period2048 = 0x07
};





const uint8_t TOSH_IRP_TABLE[40] = { 0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0xFF, 
0x02, 
0x03, 
0x04, 
0x00, 
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
0x05, 
0x01, 
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



static __inline void TOSH_SET_RED_LED_PIN(void);
#line 141
static __inline void TOSH_CLR_RED_LED_PIN(void);
static __inline void TOSH_SET_GREEN_LED_PIN(void);
#line 142
static __inline void TOSH_CLR_GREEN_LED_PIN(void);
static __inline void TOSH_SET_YELLOW_LED_PIN(void);
#line 143
static __inline void TOSH_CLR_YELLOW_LED_PIN(void);
#line 181
static __inline void TOSH_SET_CC_VREN_PIN(void);
#line 181
static __inline void TOSH_CLR_CC_VREN_PIN(void);
#line 181
static __inline void TOSH_MAKE_CC_VREN_OUTPUT(void);
static __inline void TOSH_SET_CC_RSTN_PIN(void);
#line 182
static __inline void TOSH_CLR_CC_RSTN_PIN(void);
#line 182
static __inline void TOSH_MAKE_CC_RSTN_OUTPUT(void);
static __inline char TOSH_READ_CC_FIFO_PIN(void);
#line 183
static __inline void TOSH_MAKE_CC_FIFO_INPUT(void);
static __inline char TOSH_READ_RADIO_CCA_PIN(void);
#line 184
static __inline void TOSH_MAKE_RADIO_CCA_INPUT(void);
static __inline char TOSH_READ_CC_FIFOP_PIN(void);
#line 185
static __inline void TOSH_MAKE_CC_FIFOP_INPUT(void);
static __inline char TOSH_READ_CC_SFD_PIN(void);
#line 186
static __inline void TOSH_MAKE_CC_SFD_INPUT(void);
static __inline void TOSH_SET_CC_CSN_PIN(void);
#line 187
static __inline void TOSH_CLR_CC_CSN_PIN(void);
#line 187
static __inline void TOSH_MAKE_CC_CSN_OUTPUT(void);


static inline void TOSH_SET_PIN_DIRECTIONS(void );
# 75 "/home/xu/oasis/system/dbg_modes.h"
typedef long long TOS_dbg_mode;



enum __nesc_unnamed4259 {
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
# 61 "/opt/tinyos-1.x/tos/platform/imote2/sched.c"
#line 56
typedef struct __nesc_unnamed4260 {
  void (*tp)(void);
  void *postingFunction;
  uint32_t timestamp;
  uint32_t executeTime;
} TOSH_sched_entry_T;

enum __nesc_unnamed4261 {




  TOSH_MAX_TASKS = 1 << 8, 



  TOSH_TASK_BITMASK = TOSH_MAX_TASKS - 1
};

uint32_t sys_task_bitmask;
uint32_t sys_max_tasks;

volatile TOSH_sched_entry_T TOSH_queue[TOSH_MAX_TASKS];
uint8_t TOSH_sched_full;
volatile uint8_t TOSH_sched_free;







static inline void TOSH_sched_init(void );
#line 105
bool TOS_post(void (*tp)(void));
#line 119
bool TOS_post(void (*tp)(void))  ;
#line 164
static inline bool TOSH_run_next_task(void);
#line 192
static inline void TOSH_run_task(void);
# 149 "/opt/tinyos-1.x/tos/system/tos.h"
static void *nmemcpy(void *to, const void *from, size_t n);









static inline void *nmemset(void *to, int val, size_t n);
# 28 "/opt/tinyos-1.x/tos/system/Ident.h"
enum __nesc_unnamed4262 {

  IDENT_MAX_PROGRAM_NAME_LENGTH = 16
};






#line 33
typedef struct __nesc_unnamed4263 {

  uint32_t unix_time;
  uint32_t user_hash;
  char program_name[IDENT_MAX_PROGRAM_NAME_LENGTH];
} Ident_t;
#line 52
static const Ident_t G_Ident = { 
.unix_time = 0x4a17227cL, 
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
typedef enum __nesc_unnamed4264 {
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
  TYPE_DATA_LQI = 20, 



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
  EVENT_TYPE_MAC = 5, 
  EVENT_TYPE_DATAMANAGE = 6, 
  EVENT_TYPE_SEISMICEVENT = 7
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
# 65 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHop.h"
enum __nesc_unnamed4265 {
  AM_BEACONMSG = 250
};






#line 69
typedef struct BeaconMsg {
  uint16_t parent;
  uint16_t parent_dup;
  uint16_t cost;
  uint16_t hopcount;
} __attribute((packed))  BeaconMsg;
# 14 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/MMU.h"
void initMMU(void);




void initSyncFlash(void);





void enableICache(void);




void enableDCache(void);
#line 50
void invalidateDCache(uint8_t *address, int32_t numbytes);
# 8 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/queue.h"
enum __nesc_unnamed4266 {
  defaultQueueSize = 256
};





#line 12
typedef struct __nesc_unnamed4267 {
  uint32_t entries[256];
  uint16_t head, tail;
  uint16_t size;
} queue_t;





#line 18
typedef struct __nesc_unnamed4268 {
  void *entries[256];
  uint16_t head, tail;
  uint16_t size;
} ptrqueue_t;
#line 44
int popqueue(queue_t *queue, uint32_t *val);
void *popptrqueue(ptrqueue_t *queue, int *status);
#line 57
void *peekptrqueue(ptrqueue_t *queue, int *status);









void initqueue(queue_t *queue, uint32_t size);
void initptrqueue(ptrqueue_t *queue, uint32_t size);
# 43 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stdarg.h"
typedef __builtin_va_list __gnuc_va_list;
# 24 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/types.h"
typedef short int __int16_t;
typedef unsigned short int __uint16_t;





typedef int __int32_t;
typedef unsigned int __uint32_t;






__extension__ 
#line 39
typedef long long __int64_t;
__extension__ 
#line 40
typedef unsigned long long __uint64_t;
# 36 "/usr/local/wasabi/usr/local/xscale-elf/include/machine/types.h" 3
typedef long int __off_t;
typedef int __pid_t;

__extension__ 
#line 39
typedef long long int __loff_t;
# 78 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/types.h"
typedef unsigned char u_char;
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;



typedef unsigned short ushort;
typedef unsigned int uint;



typedef unsigned long clock_t;




typedef long time_t;




struct timespec {
  time_t tv_sec;
  long tv_nsec;
};

struct itimerspec {
  struct timespec it_interval;
  struct timespec it_value;
};


typedef long daddr_t;
typedef char *caddr_t;
# 121 "/usr/local/wasabi/usr/local/xscale-elf/include/sys/types.h" 3
typedef unsigned short ino_t;
#line 155
typedef short dev_t;




typedef long off_t;

typedef unsigned short uid_t;
typedef unsigned short gid_t;


typedef int pid_t;

typedef long key_t;

typedef _ssize_t ssize_t;
#line 184
typedef unsigned int mode_t __attribute((__mode__(__SI__))) ;




typedef unsigned short nlink_t;
#line 211
typedef long fd_mask;









#line 219
typedef struct _types_fd_set {
  fd_mask fds_bits[(64 + (sizeof(fd_mask ) * 8 - 1)) / (sizeof(fd_mask ) * 8)];
} _types_fd_set;
# 50 "/usr/local/wasabi/usr/local/xscale-elf/include/stdio.h"
typedef __FILE FILE;
# 59 "/usr/local/wasabi/usr/local/xscale-elf/include/stdio.h" 3
typedef _fpos_t fpos_t;
# 172 "/usr/local/wasabi/usr/local/xscale-elf/include/stdio.h"
int fclose(FILE *);








int sscanf(const char *, const char *, ...);
#line 217
int sprintf(char *, const char *, ...);
#line 236
int vsnprintf(char *, size_t , const char *, __gnuc_va_list );
# 8 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/trace.h"
void trace(long long mode, const char *format, ...);

unsigned char trace_active(long long mode);

void trace_unset(void);

void trace_set(long long mode);
# 6 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/frequency.h"
uint32_t getSystemFrequency(void);
uint32_t getSystemBusFrequency(void);
# 3 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_types.h"
enum __nesc_unnamed4269 {

  BLUSH_SUCCESS_DONE = 0, 
  BLUSH_SUCCESS_NOT_DONE, 
  BLUSH_FAIL
};

typedef uint8_t BluSH_result_t;




#line 11
typedef struct __BluSHdata_t {
  uint8_t *src;
  uint32_t len;
  uint8_t state;
} BluSHdata_t;
typedef BluSHdata_t *BluSHdata;
# 3 "/opt/tinyos-1.x/tos/platform/imote2/BluSH.h"
enum __nesc_unnamed4270 {

  BLUSH_APP_COUNT = 13U
};
# 40 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/bufferManagement.h"
#line 37
typedef enum __nesc_unnamed4271 {
  originSendData = 0, 
  originSendDataAlloc
} sendOrigin_t;





#line 42
typedef struct bufferInfo_t {
  uint8_t *pBuf;
  uint32_t numBytes;
  sendOrigin_t origin;
} bufferInfo_t;






#line 48
typedef struct timestampedBufferInfo_t {
  uint8_t *pBuf;
  uint64_t timestamp;
  uint32_t numBytes;
  sendOrigin_t origin;
} timestampedBufferInfo_t;




#line 55
typedef struct bufferInfoInfo_t {
  bufferInfo_t BI;
  char inuse;
} bufferInfoInfo_t;




#line 60
typedef struct timestampedBufferInfoInfo_t {
  timestampedBufferInfo_t BI;
  char inuse;
} timestampedBufferInfoInfo_t;




#line 65
typedef struct buffer_t {
  uint8_t *buf;
  char inuse;
} buffer_t;
#line 81
#line 77
typedef struct bufferSet_t {
  uint32_t numBuffers;
  uint32_t bufferSize;
  buffer_t *pB;
} bufferSet_t;




#line 83
typedef struct bufferInfoSet_t {
  uint32_t numBuffers;
  bufferInfoInfo_t *pBII;
} bufferInfoSet_t;




#line 88
typedef struct timestampedBufferInfoSet_t {
  uint32_t numBuffers;
  timestampedBufferInfoInfo_t *pBII;
} timestampedBufferInfoSet_t;

int initBufferSet(bufferSet_t *pBS, buffer_t *pB, uint8_t **buffers, uint32_t numBuffers, uint32_t bufferSize);



uint8_t *getNextBuffer(bufferSet_t *pBS);







int returnBuffer(bufferSet_t *pBS, uint8_t *buf);


int initBufferInfoSet(bufferInfoSet_t *pBIS, 
bufferInfoInfo_t *pBII, 
uint32_t numBIIs);

bufferInfo_t *getNextBufferInfo(bufferInfoSet_t *pBII);







int returnBufferInfo(bufferInfoSet_t *pBII, bufferInfo_t *pBI);
# 7 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.h"
#line 4
typedef struct __nesc_unnamed4272 {
  uint8_t *RxBuffer;
  uint8_t *TxBuffer;
} BulkTxRxBuffer_t;
# 10 "/opt/tinyos-1.x/tos/platform/pxa27x/DMA.h"
#line 4
typedef enum __nesc_unnamed4273 {

  DMA_ENDINTEN = 1, 
  DMA_STARTINTEN = 2, 
  DMA_EORINTEN = 4, 
  DMA_STOPINTEN = 8
} DMAInterruptEnable_t;






#line 12
typedef enum __nesc_unnamed4274 {

  DMA_8ByteBurst = 1, 
  DMA_16ByteBurst, 
  DMA_32ByteBurst
} DMAMaxBurstSize_t;







#line 19
typedef enum __nesc_unnamed4275 {

  DMA_NonPeripheralWidth = 0, 
  DMA_1ByteWidth, 
  DMA_2ByteWidth, 
  DMA_4ByteWidth
} DMATransferWidth_t;







#line 27
typedef enum __nesc_unnamed4276 {

  DMA_Priority1 = 1, 
  DMA_Priority2 = 2, 
  DMA_Priority3 = 4, 
  DMA_Priority4 = 8
} DMAPriority_t;
#line 107
#line 35
typedef enum __nesc_unnamed4277 {

  DMAID_DREQ0 = 0, 
  DMAID_DREQ1, 
  DMAID_I2S_RX, 
  DMAID_I2S_TX, 
  DMAID_BTUART_RX, 
  DMAID_BTUART_TX, 
  DMAID_FFUART_RX, 
  DMAID_FFUART_TX, 
  DMAID_AC97_MIC, 
  DMAID_AC97_MODEMRX, 
  DMAID_AC97_MODEMTX, 
  DMAID_AC97_AUDIORX, 
  DMAID_AC97_AUDIOTX, 
  DMAID_SSP1_RX, 
  DMAID_SSP1_TX, 
  DMAID_SSP2_RX, 
  DMAID_SSP2_TX, 
  DMAID_ICP_RX, 
  DMAID_ICP_TX, 
  DMAID_STUART_RX, 
  DMAID_STUART_TX, 
  DMAID_MMC_RX, 
  DMAID_MMC_TX, 
  DMAID_USB_END0 = 24, 
  DMAID_USB_ENDA, 
  DMAID_USB_ENDB, 
  DMAID_USB_ENDC, 
  DMAID_USB_ENDD, 
  DMAID_USB_ENDE, 
  DMAID_USB_ENDF, 
  DMAID_USB_ENDG, 
  DMAID_USB_ENDH, 
  DMAID_USB_ENDI, 
  DMAID_USB_ENDJ, 
  DMAID_USB_ENDK, 
  DMAID_USB_ENDL, 
  DMAID_USB_ENDM, 
  DMAID_USB_ENDN, 
  DMAID_USB_ENDP, 
  DMAID_USB_ENDQ, 
  DMAID_USB_ENDR, 
  DMAID_USB_ENDS, 
  DMAID_USB_ENDT, 
  DMAID_USB_ENDU, 
  DMAID_USB_ENDV, 
  DMAID_USB_ENDW, 
  DMAID_USB_ENDX, 
  DMAID_MSL_RX1, 
  DMAID_MSL_TX1, 
  DMAID_MSL_RX2, 
  DMAID_MSL_TX2, 
  DMAID_MSL_RX3, 
  DMAID_MSL_TX3, 
  DMAID_MSL_RX4, 
  DMAID_MSL_TX4, 
  DMAID_MSL_RX5, 
  DMAID_MSL_TX5, 
  DMAID_MSL_RX6, 
  DMAID_MSL_TX6, 
  DMAID_MSL_RX7, 
  DMAID_MSL_TX7, 
  DMAID_USIM_RX, 
  DMAID_USIM_TX, 
  DMAID_MEMSTICK_RX, 
  DMAID_MEMSTICK_TX, 
  DMAID_SSP3_RX, 
  DMAID_SSP3_TX, 
  DMAID_CIF_RX0, 
  DMAID_CIF_RX1, 
  DMAID_DREQ2
} DMAPeripheralID_t;
# 6 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/profile.h"
#line 4
typedef struct __nesc_unnamed4278 {
  unsigned long IC_access, IC_miss, DC_access, DC_miss, cycles;
} profileInfo_t;





#line 8
typedef enum __nesc_unnamed4279 {
  profilePrintAll = 0, 
  profilePrintCycles
} 
profilePrintInfo_t;
# 39 "/opt/tinyos-1.x/tos/interfaces/Timer.h"
enum __nesc_unnamed4280 {
  TIMER_REPEAT = 0, 
  TIMER_ONE_SHOT = 1, 
  NUM_TIMERS = 27U
};
# 34 "/opt/tinyos-1.x/tos/interfaces/Clock.h"
enum __nesc_unnamed4281 {
  TOS_I1024PS = 0, TOS_S1024PS = 3, 
  TOS_I512PS = 1, TOS_S512PS = 3, 
  TOS_I256PS = 3, TOS_S256PS = 3, 
  TOS_I128PS = 7, TOS_S128PS = 3, 
  TOS_I64PS = 15, TOS_S64PS = 3, 
  TOS_I32PS = 31, TOS_S32PS = 3, 
  TOS_I16PS = 63, TOS_S16PS = 3, 
  TOS_I8PS = 127, TOS_S8PS = 3, 
  TOS_I4PS = 255, TOS_S4PS = 3, 
  TOS_I2PS = 15, TOS_S2PS = 7, 
  TOS_I1PS = 31, TOS_S1PS = 7, 
  TOS_I0PS = 0, TOS_S0PS = 0
};
enum __nesc_unnamed4282 {
  DEFAULT_SCALE = 3, DEFAULT_INTERVAL = 255
};
# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/byteorder.h"
static __inline int is_host_lsb(void);





static __inline uint16_t toLSB16(uint16_t a);




static __inline uint16_t fromLSB16(uint16_t a);
# 105 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stdarg.h" 3
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

static uint8_t *eventprintf(const uint8_t *format, ...);
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
enum __nesc_unnamed4283 {

  MAX_BUFFER_SIZE = 56, 
#line 44
  MEM_QUEUE_SIZE = 200, 

  NUM_STATUS = 6
};







#line 48
typedef enum __nesc_unnamed4284 {
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
  SEISMIC_RATE = 100, 
  INFRASONIC_RATE = 50, 
  LIGHTNING_RATE = 1, 
  RVOL_RATE = 1, 
  LQI_RATE = 1, 
  LQI_SAMPLE_INTERVAL = 300
};

enum SamplingPriority {
  SEISMIC_DATA_PRIORITY = 0x2, 
  INFRASONIC_DATA_PRIORITY = 0x1, 
  LIGHTNING_DATA_PRIORITY = 0x6, 
  LQI_DATA_PRIORITY = 0x6, 
  RVOL_DATA_PRIORITY = 0x1, 
  GPS_DATA_PRIORITY = 0x3, 
  RSAM1_DATA_PRIORITY = 0x7, 
  RSAM2_DATA_PRIORITY = 0x6
};


enum SensorConfig {
  MAX_SENSOR_NUM = 16, 
  MAX_FLASH_NUM = 16, 
  MAX_SAMPLING_RATE = 1000UL, 
  MAX_DATA_WIDTH = 2, 



  MAX_SENSING_QUEUE_SIZE = 15, 


  MAX_RSAM_WIN_SIZE = 60, 




  MAX_STA_PERIOD = 2, 




  MAX_LTA_PERIOD = 30, 



  TASK_MASK = 0x000f, 
  TASK_CODE_SIZE = 4, 
  TSTAMPOFFSET = 4, 
  ONE_MS = 1000UL, 
  BATCH_TIMER_INTERVAL = 500UL, 
  ERASE_TIMER_INTERVAL = 60000UL, 
  VOL_TIMER_INTERVAL = 60000UL
};

enum Special_Sensor {
  GPS_CLIENT_ID = 0, 
  RSAM1_CLIENT_ID = 1, 
  RSAM2_CLIENT_ID = 2, 
  COMPRESS_CLIENT_ID = 7, 

  GPS_BLK_NUM = 8, 




  RSAM_BLK_NUM = 8
};
#line 115
#line 105
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


enum sensing_flash {
  BLANK = 0x2fff, 
  WRITTEN = 0x4fff, 
  IDLE = 0xffff, 
  BASE_ADDR = 0x1A00000, 
  NUM_BYTES = 5 * sizeof(SensorClient_t )
};






#line 126
typedef struct TimeStamp {
  uint32_t minute : 6, 
  second : 6, 
  millisec : 10, 
  interval : 10;
} __attribute((packed))  TimeStamp_t;






#line 133
typedef struct FlashClient {
  uint16_t FlashFlag;
  uint32_t ProgID;
  uint16_t RFChannel;
  SensorClient_t FlashSensor[MAX_SENSOR_NUM];
} __attribute((packed))  FlashClient_t;


 SensorClient_t sensor[MAX_SENSOR_NUM];
 FlashClient_t FlashCliUnit;
 uint8_t sensor_num = 0;
# 37 "/opt/tinyos-1.x/tos/platform/imote2/Flash.h"
enum __nesc_unnamed4285 {

  NOTHING_TO_ERASE = 3
};
# 6 "/opt/tinyos-1.x/contrib/nucleus/tos/lib/Nucleus/Ident.h"
enum __nesc_unnamed4286 {
  ATTR_AMAddress = 1, 
  ATTR_AMGroup = 2, 
  ATTR_HardwareID = 3, 
  ATTR_ProgramName = 4, 
  ATTR_ProgramCompilerID = 5, 
  ATTR_ProgramCompileTime = 6
};

enum __nesc_unnamed4287 {
  HARDWARE_ID_LEN = 8
};




#line 19
typedef struct hardwareID {

  char hardwareID[HARDWARE_ID_LEN];
} hardwareID_t;




#line 24
typedef struct programName {

  char programName[IDENT_MAX_PROGRAM_NAME_LENGTH];
} programName_t;
# 27 "/home/xu/oasis/lib/SmartSensing/Compress.h"
const uint8_t biasscalebits = 8;
const uint16_t biasscalealmosthalf = (1 << (8 - 1)) - 1;
const uint8_t muexponent = 15;
const uint16_t halfmu = (1 << (15 - 1)) - 1;

const uint8_t capexponent = 2;
const uint8_t biasquantbits = 10;
const uint8_t weightquantbits = 10;


const float weightinitfactor[5] = { 1.5, -1.25, 0.75, -0.5, 0.5 };

static int biasestimate_r;

float weight_r[3];
int weightquant[3];
int weightquantcost;
uint16_t codeoverheadbits = 0;
const int32_t meancutoff[17] = { 0, 0, 1, 2, 5, 11, 23, 46, 92, 184, 369, 738, 1477, 2954, 5909, 11818, 23637 };

const int maxsample_r = ((1 << 16) - 1) << 14;
const int minsample_r = -(1 << 16) << 14;
static int16_t packetbytepointer = 0;
static int16_t packetbitpointer = 0;
FILE *output_compress = (void *)0;







static uint8_t *thepacket;
static uint16_t packetfoldedsamples[128];

static int16_t packetdebiasedsamples[128];
static int16_t packetdebiasedscaled[128];
static int packetcount = 0;




uint8_t *Init_packet;




static inline int biasquantencode_r(int thebiasestimate_r);
static inline int quantize(int number_r, int resolutionbits);
static inline int reconquantized_r(int quantizedvalue, int resolutionbits);
static void writesignmagnitude(int thevalue, int numbits);
static inline void weightquantencode(void );
static uint16_t foldsample(int thesamplevalue, int32_t theprediction);
static void writebit(int32_t bitvalue);
static inline void encodevalue(uint16_t thevalue, int32_t thecodeparameter);
static inline int32_t codechoice(int32_t foldedsum, int32_t numfoldedvals);
static void writeunsignedint(uint16_t thevalue, uint16_t numbits);
static long predictdebiasedsample_r(int numpacketsamples);
static void encodepacket(int32_t numpacketsamples, int32_t codingparameter, SenBlkPtr outPtr);
static int startnewpacket(void );
static inline void sendpacket(void );










static uint16_t compress(uint16_t *source, uint8_t size, SenBlkPtr outPtr, uint8_t *compress_done);
#line 328
static int startnewpacket(void );
#line 351
static inline int biasquantencode_r(int thebiasestimate_r);
#line 368
static inline int quantize(int number_r, int resolutionbits);
#line 381
static void writesignmagnitude(int thevalue, int numbits);
#line 403
static void writeunsignedint(uint16_t thevalue, uint16_t numbits);








static inline void weightquantencode(void );
#line 515
static void writebit(int32_t bitvalue);
#line 544
static long predictdebiasedsample_r(int numpacketsamples);
#line 574
static inline int32_t codechoice(int32_t foldedsum, int32_t numfoldedvals);
#line 598
static void encodepacket(int32_t numpacketsamples, int32_t codingparameter, SenBlkPtr outPtr);
#line 636
static inline void encodevalue(uint16_t thevalue, int32_t thecodeparameter);
#line 659
static inline void sendpacket(void );
#line 671
static uint16_t foldsample(int thesamplevalue, int32_t theprediction);
#line 713
static inline int reconquantized_r(int quantizedvalue, int resolutionbits);
# 12 "/home/xu/oasis/lib/SmartSensing/ProcessTasks.h"
enum TASK_LIST {
  RSAM_FUNC = 1, 
  PRIORITIZE_FUNC = 2, 
  THRESHOLD_FUNC = 3, 
  COMPRESS_FUNC = 4
};

typedef result_t (*ProcessFunc)(SenBlkPtr inPtr, SenBlkPtr outPtr);

static result_t RsamFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
static result_t PrioritizeFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
static result_t ThresholdFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
static result_t CompressFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);

static inline void StaLtaFunc2(uint32_t rsamvalue, uint32_t curTime);

ProcessFunc processFunc[16] = { 
(void *)0, 
RsamFunc, 
PrioritizeFunc, 
ThresholdFunc, 
CompressFunc };



static uint32_t start_point = 0;
static uint32_t end_point = 0;
static uint32_t delay_end = 0xffffffff;
int32_t sta_period = 0;
int32_t lta_period = 0;
uint8_t eventPrio = 5;


 uint16_t restartRSAM;

 uint16_t eventPri;

static bool event_trigger = FALSE;
 bool event_onset = FALSE;






static result_t RsamFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
#line 144
static inline void StaLtaFunc2(uint32_t rsamvalue, uint32_t curTime);
#line 220
static result_t PrioritizeFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
#line 253
static result_t ThresholdFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
#line 273
static result_t CompressFunc(SenBlkPtr inPtr, SenBlkPtr outPtr);
# 3 "/home/xu/oasis/system/platform/imote2/ADC/sensorboard.h"
enum SamplingChannel {
  TOSH_ACTUAL_SEISMIC_PORT = 0, 
  TOSH_ACTUAL_INFRASONIC_PORT = 4, 
  TOSH_ACTUAL_LIGHTNING_PORT = 1, 
  TOSH_ACTUAL_RVOL_PORT = 15
};
# 35 "/opt/tinyos-1.x/tos/interfaces/ADC.h"
enum __nesc_unnamed4288 {
  TOS_ADCSample3750ns = 0, 
  TOS_ADCSample7500ns = 1, 
  TOS_ADCSample15us = 2, 
  TOS_ADCSample30us = 3, 
  TOS_ADCSample60us = 4, 
  TOS_ADCSample120us = 5, 
  TOS_ADCSample240us = 6, 
  TOS_ADCSample480us = 7
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










enum __nesc_unnamed4289 {
  MAX_NUM_CLIENT = 12, 
  GPS_SYNC = 0, 
  FTSP_SYNC = 1, 
  UC_FIRE_INTERVAL = 1000UL, 
  DAY_END = 86400000UL, 
  HOUR_END = 3600000UL, 

  DEFAULT_SYNC_MODE = 1
};
# 4 "/home/xu/oasis/system/platform/imote2/ADC/gps.h"
enum GPSInfo {

  RAW_SIZE = 600UL, 
  NMEA_SIZE = 38, 
  RAW_HEAD = 0xb5, 
  NMEA_HEAD = 0x24, 
  SYNC_INTERVAL = 20, 
  MAX_ENTRIES = 6
};

enum RTC_NMEA {
  H1 = 7, 
  H2 = 8, 
  M1 = 9, 
  M2 = 10, 
  S1 = 11, 
  S2 = 12, 
  MS1 = 14, 
  MS2 = 15, 
  ACIIOFFSET = 0x30
};






#line 26
typedef struct TableItem {

  uint32_t localTime;
  int32_t timeOffset;
  uint16_t state;
} TimeTable;

enum __nesc_unnamed4290 {
  ENTRY_EMPTY = 0, 
  ENTRY_FULL = 1
};


static __inline uint8_t tr_time(uint8_t *source);
# 36 "/home/xu/oasis/system/platform/imote2/UART/pxa27x_serial.h"
typedef uint8_t uart_status_t;





#line 38
typedef enum __nesc_unnamed4291 {
  EVEN, 
  ODD, 
  NONE
} uart_parity_t;
# 31 "/home/xu/oasis/system/queue.h"
enum __nesc_unnamed4292 {










  MAX_QUEUE_SIZE = 40, 



  NUM_OBJSTATUS = 3
};

typedef TOS_Msg object_type;





#line 51
typedef enum __nesc_unnamed4293 {
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









static result_t initQueue(Queue_t *queue, uint16_t size);
#line 146
static result_t insertElement(Queue_t *queue, object_type *obj);
#line 307
static result_t removeElement(Queue_t *queue, object_type *obj);
#line 368
static object_type *headElement(Queue_t *queue, ObjStatus_t status);
#line 387
static inline uint8_t getRetryCount(object_type **object);









static inline bool incRetryCount(object_type **object);
#line 468
static inline object_type **findObject(Queue_t *queue, object_type *obj);
#line 496
static result_t changeElementStatus(Queue_t *queue, object_type *obj, ObjStatus_t status1, ObjStatus_t status2);
#line 559
static void _private_changeElementStatusByIndex(Queue_t *queue, int16_t ind, ObjStatus_t status1, ObjStatus_t status2);
# 31 "/home/xu/oasis/system/buffer.h"
enum __nesc_unnamed4294 {
  FREEBUF = PENDING, 
  BUSYBUF = PROCESSING
};









static result_t initBufferPool(Queue_t *bufQueue, uint16_t size, TOS_Msg *bufPool);
#line 66
static TOS_MsgPtr allocBuffer(Queue_t *bufQueue);
#line 86
static result_t freeBuffer(Queue_t *bufQueue, TOS_MsgPtr buf);
# 33 "/home/xu/oasis/lib/RamSymbols/RamSymbols.h"
enum __nesc_unnamed4295 {

  MAX_RAM_SYMBOL_SIZE = 74 - (size_t )& ((NetworkMsg *)0)->data - 
  (size_t )& ((ApplicationMsg *)0)->data - (size_t )& ((RpcCommandMsg *)0)->data - sizeof(uint32_t ) - sizeof(uint8_t ) - sizeof(bool ), 
  AM_RAMSYMBOL_T = 134
};
#line 53
#line 42
typedef struct ramSymbol_t {




  uint32_t memAddress;


  uint8_t length;
  bool dereference;
  uint8_t data[MAX_RAM_SYMBOL_SIZE];
} __attribute((packed))  ramSymbol_t;
# 4 "/home/xu/oasis/lib/GenericCommPro/QosRexmit.h"
enum __nesc_unnamed4296 {
  QOS_LEVEL = 7
};

static inline uint8_t qosRexmit(uint8_t qos);
# 50 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
enum __nesc_unnamed4297 {

  COMM_SEND_QUEUE_SIZE = 15, 


  COMM_RECV_QUEUE_SIZE = 15
};


enum __nesc_unnamed4298 {
  RADIO = 1, 
  UART = 2, 
  COMM_WDT_UPDATE_PERIOD = 10, 
  COMM_WDT_UPDATE_UNIT = 1024 * 60
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

enum __nesc_unnamed4299 {
  AM_TIMESYNCMSG = 0xAA, 
  TIMESYNCMSG_LEN = sizeof(TimeSyncMsg ) - sizeof(uint32_t ), 
  TS_TIMER_MODE = 0, 
  TS_USER_MODE = 1, 





  TIMESYNC_LENGTH_SENDFIELDS = 5
};
# 42 "/opt/tinyos-1.x/tos/system/crc.h"
static uint16_t crcByte(uint16_t crc, uint8_t b);
# 37 "/opt/tinyos-1.x/tos/platform/imote2/UART.h"
enum __nesc_unnamed4300 {
  UART_BAUD_300 = 1, 
  UART_BAUD_1200 = 2, 
  UART_BAUD_2400 = 3, 
  UART_BAUD_4800 = 4, 
  UART_BAUD_9600 = 5, 
  UART_BAUD_19200 = 6, 
  UART_BAUD_38400 = 7, 
  UART_BAUD_57600 = 8, 
  UART_BAUD_115200 = 9, 
  UART_BAUD_230400 = 10, 
  UART_BAUD_460800 = 11, 
  UART_BAUD_921600 = 12
};
# 18 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmt.h"
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
  uint8_t lqiRaw;
  uint8_t rssiRaw;
  uint8_t lastHeard;
} NBRTableEntry;









enum __nesc_unnamed4301 {
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

enum __nesc_unnamed4302 {
  LIVELINESS = 8, 
  CHILD_LIVELINESS = 8, 
  ROUTE_INVALID = 0xff, 
  ADDRESS_INVALID = 0xffff
};
# 34 "/home/xu/oasis/system/TinyDWFQ.h"
enum __nesc_unnamed4303 {

  NUM_VIRTUAL_QUEUES = 8, 
  NUM_HEAD_TAIL_POINTERS = 4, 
  TINYDWFQ_SIZE = 40, 
  MAX_ELEMENT_PER_VIRTUALQUEUE = 5, 
  NUM_OBJSTATUS_TINYDWFQ = 4, 
  DQ_WEIGHTS = 4
};

enum __nesc_unnamed4304 {

  VQ_HEAD = 0, 
  VQ_TAIL = 1, 
  VQ_FREE_HEAD = 2, 
  VQ_FREE_TAIL = 3
};







#line 52
typedef enum __nesc_unnamed4305 {

  FREE_TINYDWFQ = 0, 
  PENDING_TINYDWFQ = 1, 
  PROCESSING_TINYDWFQ = 2, 
  NOT_ACKED_TINYDWFQ = 3
} ObjStatusTINYDWFQ_t;

enum DequeueWeights {

  DQ_LOW = 0, 
  DQ_MEDIUM = 1, 
  DQ_HIGH = 2, 
  DQ_URGENT = 3
};




enum VirtualQueueSizes {

  MAX_VQ_0 = 0, 
  MAX_VQ_1 = 24, 
  MAX_VQ_2 = 5, 
  MAX_VQ_3 = 0, 
  MAX_VQ_4 = 0, 
  MAX_VQ_5 = 0, 
  MAX_VQ_6 = 8, 
  MAX_VQ_7 = 3
};

enum VirtualQueueHeadAndTail {

  VQ_0_FREE_HEAD = -1, 
  VQ_0_FREE_TAIL = -1, 
  VQ_1_FREE_HEAD = 0, 
  VQ_1_FREE_TAIL = 23, 
  VQ_2_FREE_HEAD = 24, 
  VQ_2_FREE_TAIL = 28, 
  VQ_3_FREE_HEAD = -1, 
  VQ_3_FREE_TAIL = -1, 
  VQ_4_FREE_HEAD = -1, 
  VQ_4_FREE_TAIL = -1, 
  VQ_5_FREE_HEAD = -1, 
  VQ_5_FREE_TAIL = -1, 
  VQ_6_FREE_HEAD = 29, 
  VQ_6_FREE_TAIL = 36, 
  VQ_7_FREE_HEAD = 37, 
  VQ_7_FREE_TAIL = 39
};
#line 117
#line 104
typedef struct Element_TinyDWFQ_t {
  int16_t next;
  int16_t prev;
  uint8_t status;
  uint8_t retry;
  uint8_t priority;
  uint8_t dummy;

  uint8_t vqIndex;
  int8_t qos;

  object_type *obj;
} 
Element_TinyDWFQ_t;
#line 140
#line 120
typedef struct TinyDWFQ_t {

  int16_t size;
  int16_t total;

  int16_t head[NUM_OBJSTATUS_TINYDWFQ];
  int16_t tail[NUM_OBJSTATUS_TINYDWFQ];

  Element_TinyDWFQ_t element[TINYDWFQ_SIZE];

  int16_t virtualQueues[NUM_VIRTUAL_QUEUES][NUM_HEAD_TAIL_POINTERS];

  int16_t numOfElements_VQ[NUM_VIRTUAL_QUEUES];
  int16_t numOfElements_VQ_Processing[NUM_VIRTUAL_QUEUES];
  int8_t numOfElements_pending;
  int8_t numOfElements_processing;
  int8_t numOfElements_notAcked;

  int8_t maxNumOfElementPerVQ[NUM_VIRTUAL_QUEUES];
} 
TinyDWFQ_t;

typedef TinyDWFQ_t *TinyDWFQPtr;
#line 154
uint8_t virtualQueueDequeueWieghts[NUM_VIRTUAL_QUEUES][DQ_WEIGHTS];





static inline void initializeVirtualQueue(TinyDWFQPtr queue);

static inline uint8_t getNumberOfElementsToBeDqueued(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t freeSpace);
static uint8_t setAndGetDequeueWeight(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t dqPriority, uint8_t freeSpace);

static inline result_t init_TinyDWFQ(TinyDWFQPtr queue, uint8_t size);
#line 228
static inline void initializeVirtualQueue(TinyDWFQPtr queue);
#line 281
static inline result_t insertElement_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg);
#line 365
static inline void markElementAsPendingByQOS_TinyDWFQ(TinyDWFQPtr queue, uint8_t numOfElementsToMark);
#line 495
static inline uint8_t getNumberOfElementsToBeDqueued(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t freeSpace);
#line 520
static uint8_t setAndGetDequeueWeight(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t dqPriority, uint8_t freeSpace);
#line 698
static inline result_t markElementAsNotACKed_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg);
#line 767
static result_t removeElement_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg, ObjStatusTINYDWFQ_t status);
#line 841
static inline result_t isElementInACKList_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg);
#line 859
static result_t isListEmpty_TinyDWFQ(TinyDWFQPtr queue, ObjStatus_t status);
#line 879
static inline object_type *getheadElement_TinyDWFQ(TinyDWFQPtr queue, ObjStatus_t status);
#line 962
static inline object_type *findMessageToReplace(TinyDWFQPtr queue, int8_t newMsgQOS);
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
# 78 "/opt/tinyos-1.x/tos/interfaces/Pot.nc"
static  result_t PotM$Pot$init(uint8_t arg_0x40426ac0);
# 74 "/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
static  result_t HPLPotC$Pot$finalise(void);
#line 59
static  result_t HPLPotC$Pot$decrease(void);







static  result_t HPLPotC$Pot$increase(void);
# 80 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLInitM.nc"
static  result_t HPLInitM$init(void);
# 54 "/opt/tinyos-1.x/tos/platform/imote2/DVFS.nc"
static  result_t DVFSM$DVFS$SwitchCoreFreq(uint32_t arg_0x4044bac0, uint32_t arg_0x4044bc58);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t DVFSM$GetFreq$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t DVFSM$GetFreq$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t DVFSM$SwitchFreq$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t DVFSM$SwitchFreq$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 47 "/opt/tinyos-1.x/tos/platform/imote2/SendDataAlloc.nc"
static  result_t BufferedSTUARTM$SendDataAlloc$default$sendDone(uint8_t *arg_0x404dd010, uint32_t arg_0x404dd1a8, result_t arg_0x404dd338);
# 63 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkReceiveDone(uint8_t *arg_0x404f3720, uint16_t arg_0x404f38b8);







static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkTransmitDone(uint8_t *arg_0x404ff190, uint16_t arg_0x404ff328);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t BufferedSTUARTM$StdControl$init(void);






static  result_t BufferedSTUARTM$StdControl$start(void);
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   void STUARTM$TxDMAChannel$stopInterrupt(uint16_t arg_0x4054a8e0);







static   void STUARTM$TxDMAChannel$startInterrupt(void);
#line 86
static  result_t STUARTM$TxDMAChannel$requestChannelDone(void);
#line 249
static   void STUARTM$TxDMAChannel$eorInterrupt(uint16_t arg_0x4054a280);
#line 236
static   void STUARTM$TxDMAChannel$endInterrupt(uint16_t arg_0x4054cc28);
#line 260
static   void STUARTM$RxDMAChannel$stopInterrupt(uint16_t arg_0x4054a8e0);







static   void STUARTM$RxDMAChannel$startInterrupt(void);
#line 86
static  result_t STUARTM$RxDMAChannel$requestChannelDone(void);
#line 249
static   void STUARTM$RxDMAChannel$eorInterrupt(uint16_t arg_0x4054a280);
#line 236
static   void STUARTM$RxDMAChannel$endInterrupt(uint16_t arg_0x4054cc28);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void STUARTM$UARTInterrupt$fired(void);
# 35 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
static  result_t STUARTM$BulkTxRx$BulkTransmit(uint8_t *arg_0x404f4600, uint16_t arg_0x404f4798);
#line 27
static  result_t STUARTM$BulkTxRx$BulkReceive(uint8_t *arg_0x40501dd8, uint16_t arg_0x404f4010);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XDMAM$Interrupt$fired(void);
# 143 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetAddrIncrement(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 143 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
bool arg_0x4053f608);
#line 161
static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetFlowControl(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 161 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
bool arg_0x4054e188);
#line 260
static   void PXA27XDMAM$PXA27XDMAChannel$default$stopInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054a8e0);
#line 123
static   result_t PXA27XDMAM$PXA27XDMAChannel$setTargetAddr(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 123 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint32_t arg_0x4053aaa8);
#line 268
static   void PXA27XDMAM$PXA27XDMAChannel$default$startInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790);
# 182 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   result_t PXA27XDMAM$PXA27XDMAChannel$setTransferLength(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 182 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054ed20);









static  result_t PXA27XDMAM$PXA27XDMAChannel$setTransferWidth(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 192 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
DMATransferWidth_t arg_0x4054d358);
#line 86
static  result_t PXA27XDMAM$PXA27XDMAChannel$default$requestChannelDone(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790);
# 113 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   result_t PXA27XDMAM$PXA27XDMAChannel$setSourceAddr(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 113 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint32_t arg_0x4053a528);
#line 172
static  result_t PXA27XDMAM$PXA27XDMAChannel$setMaxBurstSize(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 172 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
DMAMaxBurstSize_t arg_0x4054e720);
#line 249
static   void PXA27XDMAM$PXA27XDMAChannel$default$eorInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 249 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054a280);
#line 152
static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceFlowControl(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 152 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
bool arg_0x4053fbd8);
#line 204
static   result_t PXA27XDMAM$PXA27XDMAChannel$run(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 204 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
DMAInterruptEnable_t arg_0x4054d948);
#line 77
static  result_t PXA27XDMAM$PXA27XDMAChannel$requestChannel(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 77 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
DMAPeripheralID_t arg_0x405402f8, 
DMAPriority_t arg_0x405404a0, bool arg_0x40540630);
#line 236
static   void PXA27XDMAM$PXA27XDMAChannel$default$endInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 236 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054cc28);
#line 133
static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceAddrIncrement(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 133 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
bool arg_0x4053f030);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PXA27XDMAM$StdControl$init(void);






static  result_t PXA27XDMAM$StdControl$start(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XFiq$default$fired(
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405de5d0);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XIrq$default$fired(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405ecc80);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XIrq$disable(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405ecc80);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XIrq$enable(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405ecc80);
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   result_t PXA27XInterruptM$PXA27XIrq$allocate(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405ecc80);
# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/UID.nc"
static   uint32_t UIDC$UID$getUID(void);
# 35 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLUSBClientGPIO.nc"
static   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$checkConnection(void);
#line 19
static   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$init(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XGPIOIntM$GPIOIrq0$fired(void);
#line 48
static   void PXA27XGPIOIntM$GPIOIrq$fired(void);
#line 48
static   void PXA27XGPIOIntM$GPIOIrq1$fired(void);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$clear(
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
uint8_t arg_0x40643bb0);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$default$fired(
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
uint8_t arg_0x40643bb0);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$disable(
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
uint8_t arg_0x40643bb0);
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$enable(
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
uint8_t arg_0x40643bb0, 
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
uint8_t arg_0x406321d8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PXA27XGPIOIntM$StdControl$init(void);






static  result_t PXA27XGPIOIntM$StdControl$start(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr PXA27XUSBClientM$ReceiveMsg$default$receive(TOS_MsgPtr arg_0x40620878);
# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
static  result_t PXA27XUSBClientM$SendJTPacket$send(
# 24 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
uint8_t arg_0x4065c5b8, 
# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
uint8_t *arg_0x406141a8, uint32_t arg_0x40614340, uint8_t arg_0x406144c8);







static  result_t PXA27XUSBClientM$SendJTPacket$default$sendDone(
# 24 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
uint8_t arg_0x4065c5b8, 
# 28 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
uint8_t *arg_0x40614b20, uint8_t arg_0x40614ca8, result_t arg_0x40614e38);
# 62 "/opt/tinyos-1.x/tos/interfaces/SendVarLenPacket.nc"
static  result_t PXA27XUSBClientM$SendVarLenPacket$default$sendDone(uint8_t *arg_0x406168e8, result_t arg_0x40616a78);
# 10 "/opt/tinyos-1.x/tos/platform/pxa27x/ReceiveBData.nc"
static  result_t PXA27XUSBClientM$ReceiveBData$default$receive(uint8_t *arg_0x40621118, uint8_t arg_0x406212a8, 
uint32_t arg_0x40621448, uint32_t arg_0x406215d8, uint8_t arg_0x40621760);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XUSBClientM$USBAttached$fired(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XUSBClientM$USBInterrupt$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PXA27XUSBClientM$Control$init(void);






static  result_t PXA27XUSBClientM$Control$start(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t PXA27XUSBClientM$BareSendMsg$default$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 28 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
static  result_t BluSHM$USBSend$sendDone(uint8_t *arg_0x40614b20, uint8_t arg_0x40614ca8, result_t arg_0x40614e38);
# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
static  result_t BluSHM$UartReceive$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t BluSHM$BluSH_AppI$default$callApp(
# 33 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
uint8_t arg_0x40784798, 
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t BluSHM$BluSH_AppI$default$getName(
# 33 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
uint8_t arg_0x40784798, 
# 8 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
static  result_t BluSHM$USBReceive$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0);
# 62 "/opt/tinyos-1.x/tos/platform/imote2/SendData.nc"
static  result_t BluSHM$UartSend$sendDone(uint8_t *arg_0x404e11a8, uint32_t arg_0x404e1340, result_t arg_0x404e14d0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t BluSHM$StdControl$init(void);






static  result_t BluSHM$StdControl$start(void);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t PMICM$BatteryVoltage$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$BatteryVoltage$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PMICM$PI2CInterrupt$fired(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t PMICM$batteryMonitorTimer$fired(void);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t PMICM$ChargingStatus$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$ChargingStatus$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PMICM$PMICInterrupt$fired(void);
# 51 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
static  result_t PMICM$PMIC$setCoreVoltage(uint8_t arg_0x404bd718);
static  result_t PMICM$PMIC$shutDownLDOs(void);


static  result_t PMICM$PMIC$enableCharging(bool arg_0x404bc398);
#line 54
static  result_t PMICM$PMIC$getBatteryVoltage(uint8_t *arg_0x404bdee0);

static  result_t PMICM$PMIC$chargingStatus(uint8_t *arg_0x404bc850, uint8_t *arg_0x404bc9f8, uint8_t *arg_0x404bcba0, uint8_t *arg_0x404bcd50);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t PMICM$chargeMonitorTimer$fired(void);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t PMICM$SetCoreVoltage$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$SetCoreVoltage$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t PMICM$ManualCharging$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$ManualCharging$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t PMICM$ReadPMIC$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$ReadPMIC$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t PMICM$WritePMIC$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t PMICM$WritePMIC$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PMICM$StdControl$init(void);






static  result_t PMICM$StdControl$start(void);
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdog.nc"
static  void PXA27XWatchdogM$PXA27XWatchdog$init(void);
#line 70
static  void PXA27XWatchdogM$PXA27XWatchdog$feedWDT(uint32_t arg_0x408a78a8);
#line 61
static  void PXA27XWatchdogM$PXA27XWatchdog$enableWDT(uint32_t arg_0x408a7340);
# 46 "/opt/tinyos-1.x/tos/interfaces/Reset.nc"
static  void PXA27XWatchdogM$Reset$reset(void);
# 56 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t NoLeds$Leds$init(void);
#line 106
static   result_t NoLeds$Leds$greenToggle(void);
#line 131
static   result_t NoLeds$Leds$yellowToggle(void);
#line 81
static   result_t NoLeds$Leds$redToggle(void);
# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   result_t TimerM$Clock$fire(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimerM$StdControl$init(void);






static  result_t TimerM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$default$fired(
# 50 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
uint8_t arg_0x408cf2b8);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$start(
# 50 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
uint8_t arg_0x408cf2b8, 
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t TimerM$Timer$stop(
# 50 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
uint8_t arg_0x408cf2b8);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XClockM$OSTIrq$fired(void);
# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   void PXA27XClockM$Clock$setInterval(uint32_t arg_0x408ca068);
#line 153
static   uint32_t PXA27XClockM$Clock$readCounter(void);
#line 96
static   result_t PXA27XClockM$Clock$setRate(uint32_t arg_0x408c5460, uint32_t arg_0x408c55f0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PXA27XClockM$StdControl$init(void);






static  result_t PXA27XClockM$StdControl$start(void);
# 41 "/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
static   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SettingsM$StackCheckTimer$fired(void);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t SettingsM$TestTaskQueue$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t SettingsM$TestTaskQueue$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t SettingsM$GoToSleep$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t SettingsM$GoToSleep$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t SettingsM$GetResetCause$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t SettingsM$GetResetCause$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
static  BluSH_result_t SettingsM$ResetNode$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t SettingsM$ResetNode$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SettingsM$StdControl$init(void);






static  result_t SettingsM$StdControl$start(void);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t SettingsM$NodeID$callApp(char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t SettingsM$NodeID$getName(char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 64 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420ControlM$SplitControl$init(void);
#line 77
static  result_t CC2420ControlM$SplitControl$start(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420ControlM$CCA$fired(void);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t CC2420ControlM$HPLChipconRAM$writeDone(uint16_t arg_0x40954010, uint8_t arg_0x40954198, uint8_t *arg_0x40954340);
# 120 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static   result_t CC2420ControlM$CC2420Control$VREFOn(void);
#line 185
static  uint8_t CC2420ControlM$CC2420Control$GetRFPower(void);
#line 206
static   result_t CC2420ControlM$CC2420Control$enableAddrDecode(void);
#line 178
static  result_t CC2420ControlM$CC2420Control$SetRFPower(uint8_t arg_0x4095df20);
#line 192
static   result_t CC2420ControlM$CC2420Control$enableAutoAck(void);
#line 84
static  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t arg_0x40940010);
#line 163
static   result_t CC2420ControlM$CC2420Control$RxMode(void);
#line 94
static  result_t CC2420ControlM$CC2420Control$TuneManual(uint16_t arg_0x409405f8);
#line 220
static  result_t CC2420ControlM$CC2420Control$setShortAddress(uint16_t arg_0x4095b8e8);
#line 106
static  uint8_t CC2420ControlM$CC2420Control$GetPreset(void);
#line 134
static   result_t CC2420ControlM$CC2420Control$OscillatorOn(void);
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XPowerModes.nc"
static  void PXA27XPowerModesM$PXA27XPowerModes$SwitchMode(uint8_t arg_0x40997ab8);
# 56 "/opt/tinyos-1.x/tos/platform/pxa27x/Sleep.nc"
static  result_t SleepM$Sleep$goToDeepSleep(uint32_t arg_0x4090f8e0);
# 53 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static  void SmartSensingM$eraseFlash(void)  ;
# 35 "/home/xu/oasis/interfaces/SensingConfig.nc"
static  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t arg_0x4099f010, uint8_t arg_0x4099f1a0);

static  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t arg_0x4099f638);
#line 31
static  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t arg_0x409a04c8, uint8_t arg_0x409a0650);
#line 49
static  uint8_t SmartSensingM$SensingConfig$getEventPriority(uint8_t arg_0x409be4b0);
#line 27
static  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t arg_0x409a19e0, uint16_t arg_0x409a1b78);





static  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t arg_0x409a0ae8);
#line 29
static  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t arg_0x409a0030);
#line 47
static  result_t SmartSensingM$SensingConfig$setEventPriority(uint8_t arg_0x409bfe20, uint8_t arg_0x409be010);
#line 43
static  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t arg_0x409bf348, uint16_t arg_0x409bf4d8);
#line 39
static  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t arg_0x4099fad8);





static  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t arg_0x409bf980);
#line 41
static  uint8_t SmartSensingM$SensingConfig$getNodePriority(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$SensingTimer$fired(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 46 "/home/xu/oasis/interfaces/GenericSensing.nc"
static  result_t SmartSensingM$GPSSensing$dataReady(uint8_t *arg_0x40ac8268, uint16_t arg_0x40ac83f8);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$initTimer$fired(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t SmartSensingM$ADC$dataReady(
# 65 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
uint8_t arg_0x40aa9310, 
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0x40aa6cc0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SmartSensingM$StdControl$init(void);






static  result_t SmartSensingM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$WatchTimer$fired(void);
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
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t RandomLFSR$Random$rand(void);
#line 57
static   result_t RandomLFSR$Random$init(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$WatchTimer$fired(void);
# 42 "/home/xu/oasis/interfaces/RealTime.nc"
static  bool RealTimeM$RealTime$isSync(void);
#line 40
static  result_t RealTimeM$RealTime$setTimeCount(uint32_t arg_0x40abf6d8, uint8_t arg_0x40abf860);


static  result_t RealTimeM$RealTime$changeMode(uint8_t arg_0x40abd648);
static  uint8_t RealTimeM$RealTime$getMode(void);
#line 39
static  uint32_t RealTimeM$RealTime$getTimeCount(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t RealTimeM$LocalTime$read(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t RealTimeM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   result_t RealTimeM$Clock$fire(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RealTimeM$StdControl$init(void);






static  result_t RealTimeM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$default$fired(
# 31 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
uint8_t arg_0x40b740d0);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$start(
# 31 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
uint8_t arg_0x40b740d0, 
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t RealTimeM$Timer$stop(
# 31 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
uint8_t arg_0x40b740d0);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void RTCClockM$OSTIrq$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RTCClockM$StdControl$init(void);






static  result_t RTCClockM$StdControl$start(void);
# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   void RTCClockM$MicroClock$setInterval(uint32_t arg_0x408ca068);
# 89 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialPacket.nc"
static   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$receiveDone(uint8_t *arg_0x40bf31a8, uint16_t arg_0x40bf3338, uart_status_t arg_0x40bf34c8);
#line 62
static   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$sendDone(uint8_t *arg_0x40bcce68, uint16_t arg_0x40bcb010, uart_status_t arg_0x40bcb1a0);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t GPSSensorM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 7 "/home/xu/oasis/interfaces/GPSGlobalTime.nc"
static   uint32_t GPSSensorM$GPSGlobalTime$getLocalTime(void);
#line 6
static   uint32_t GPSSensorM$GPSGlobalTime$getGlobalTime(void);

static   uint32_t GPSSensorM$GPSGlobalTime$local2Global(uint32_t arg_0x40b6e770);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GPSSensorM$CheckTimer$fired(void);
# 79 "/home/xu/oasis/system/platform/imote2/UART/UartStream.nc"
static   void GPSSensorM$GPSUartStream$receivedByte(uint8_t arg_0x40bd1c28);
#line 99
static   void GPSSensorM$GPSUartStream$receiveDone(uint8_t *arg_0x40bcf920, uint16_t arg_0x40bcfab0, result_t arg_0x40bcfc40);
#line 57
static   void GPSSensorM$GPSUartStream$sendDone(uint8_t *arg_0x40bd2b58, uint16_t arg_0x40bd2ce8, result_t arg_0x40bd2e78);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void GPSSensorM$GPSInterrupt$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GPSSensorM$StdControl$init(void);






static  result_t GPSSensorM$StdControl$start(void);
# 49 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialPacket.nc"
static   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$send(uint8_t *arg_0x40bcc6c8, uint16_t arg_0x40bcc858);
#line 75
static   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$receive(uint8_t *arg_0x40bcb810, uint16_t arg_0x40bcb9a0, uint16_t arg_0x40bcbb30);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HalPXA27xBTUARTP$SerialControl$init(void);






static  result_t HalPXA27xBTUARTP$SerialControl$start(void);
# 81 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
static   void HalPXA27xBTUARTP$UART$interruptUART(void);
# 51 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialCntl.nc"
static   result_t HalPXA27xBTUARTP$HalPXA27xSerialCntl$configPort(uint32_t arg_0x40bf1510, 
uint8_t arg_0x40bf16b0, 
uart_parity_t arg_0x40bf1850, 
uint8_t arg_0x40bf19f0, 
bool arg_0x40bf1b90);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HplPXA27xBTUARTP$UControl$init(void);
# 44 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
static   void HplPXA27xBTUARTP$UART$setDLL(uint32_t arg_0x40c21928);
#line 60
static   void HplPXA27xBTUARTP$UART$setMCR(uint32_t arg_0x40c49068);
#line 53
static   uint32_t HplPXA27xBTUARTP$UART$getIIR(void);
#line 47
static   void HplPXA27xBTUARTP$UART$setDLH(uint32_t arg_0x40c20100);
#line 42
static   void HplPXA27xBTUARTP$UART$setTHR(uint32_t arg_0x40c21480);
#line 63
static   uint32_t HplPXA27xBTUARTP$UART$getLSR(void);
#line 55
static   void HplPXA27xBTUARTP$UART$setFCR(uint32_t arg_0x40c4a3d0);
#line 51
static   uint32_t HplPXA27xBTUARTP$UART$getIER(void);
#line 41
static   uint32_t HplPXA27xBTUARTP$UART$getRBR(void);
#line 57
static   void HplPXA27xBTUARTP$UART$setLCR(uint32_t arg_0x40c4a878);
#line 50
static   void HplPXA27xBTUARTP$UART$setIER(uint32_t arg_0x40c208c8);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void HplPXA27xBTUARTP$UARTIrq$fired(void);
# 51 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static  result_t SNMSM$ledsOn(uint8_t arg_0x40ca8400)  ;
static  void SNMSM$restart(void)  ;
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SNMSM$SNMSTimer$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SNMSM$StdControl$init(void);






static  result_t SNMSM$StdControl$start(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t EventReportM$EventReport$default$eventSendDone(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x40d0b508, 
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
#line 37
static  uint8_t EventReportM$EventReport$eventSend(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x40d0b508, 
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t EventReportM$EventSend$sendDone(TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 47 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
static  uint8_t EventReportM$EventConfig$getReportLevel(uint8_t arg_0x40cae5d0);
#line 38
static  result_t EventReportM$EventConfig$setReportLevel(uint8_t arg_0x40cb1e50, uint8_t arg_0x40cae010);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t EventReportM$StdControl$init(void);






static  result_t EventReportM$StdControl$start(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr arg_0x409b8068, void *arg_0x409b8208, uint16_t arg_0x409b83a0);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RpcM$StdControl$init(void);






static  result_t RpcM$StdControl$start(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$ReceiveMsg$default$receive(
# 71 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40d923e0, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40620878);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$ActivityTimer$fired(void);
# 79 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  uint8_t GenericCommProM$getRFPower(void)  ;
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$UARTSend$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t GenericCommProM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 81 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$initRFChannel(uint8_t arg_0x40d8e8c8);
#line 76
static  result_t GenericCommProM$setRFChannel(uint8_t arg_0x40d8f528)  ;
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$RadioReceive$receive(TOS_MsgPtr arg_0x40620878);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$Control$init(void);






static  result_t GenericCommProM$Control$start(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$RadioSend$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 77 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  uint8_t GenericCommProM$getRFChannel(void)  ;
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t GenericCommProM$SendMsg$send(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40d90c78, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
static  result_t GenericCommProM$SendMsg$default$sendDone(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40d90c78, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$MonitorTimer$fired(void);
# 78 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$setRFPower(uint8_t arg_0x40d8fef0)  ;
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$UARTReceive$receive(TOS_MsgPtr arg_0x40620878);
# 71 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteSelect.nc"
static  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr arg_0x40df7270, uint8_t arg_0x40df73f8, uint8_t arg_0x40df7580);
#line 86
static  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr arg_0x40df7b90, uint8_t arg_0x40df7d18);
# 2 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
static  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool arg_0x40d34010);

static  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void);
#line 3
static  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t arg_0x40d344b8);


static  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void);
#line 5
static  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x40d34c68);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopLQI$Timer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t arg_0x40df3928, uint16_t arg_0x40df3ac0, bool arg_0x40df3c50);
#line 2
static  result_t MultiHopLQI$MultihopCtrl$switchParent(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopLQI$StdControl$init(void);






static  result_t MultiHopLQI$StdControl$start(void);
# 116 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
static  bool MultiHopLQI$RouteControl$isSink(void);
#line 109
static  result_t MultiHopLQI$RouteControl$releaseParent(void);
#line 84
static  uint16_t MultiHopLQI$RouteControl$getQuality(void);
#line 107
static  result_t MultiHopLQI$RouteControl$setParent(uint16_t arg_0x40ad7a78);
#line 49
static  uint16_t MultiHopLQI$RouteControl$getParent(void);
#line 94
static  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t arg_0x40ad7108);
# 33 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
static  ramSymbol_t RamSymbolsM$peek(unsigned int arg_0x40e675f8, uint8_t arg_0x40e67780, bool arg_0x40e67910)  ;
#line 32
static  unsigned int RamSymbolsM$poke(ramSymbol_t *arg_0x40e67010)  ;
# 48 "/opt/tinyos-1.x/tos/interfaces/WDT.nc"
static  void WDTM$WDT$reset(void);
#line 45
static  result_t WDTM$WDT$start(int32_t arg_0x40cb0b70);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t WDTM$StdControl$init(void);






static  result_t WDTM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t WDTM$Timer$fired(void);
# 44 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLWatchdogM.nc"
static  void HPLWatchdogM$reset(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HPLWatchdogM$StdControl$init(void);






static  result_t HPLWatchdogM$StdControl$start(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 36 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
static   uint32_t TimeSyncM$GlobalTime$getLocalTime(void);






static   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b6cdd8);
#line 60
static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *arg_0x40b6b3d0);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t TimeSyncM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 20 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
static  void TimeSyncM$TimeSyncNotify$default$msg_received(void);





static  void TimeSyncM$TimeSyncNotify$default$msg_sent(void);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t TimeSyncM$SendMsg$sendDone(TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimeSyncM$StdControl$init(void);






static  result_t TimeSyncM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimeSyncM$Timer$fired(void);
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
static  result_t CC2420RadioM$Send$send(TOS_MsgPtr arg_0x40615d50);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacControl.nc"
static   void CC2420RadioM$MacControl$enableAck(void);
# 53 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t CC2420RadioM$SFD$captured(uint16_t arg_0x40f18368);
# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t arg_0x40f1cc58, uint8_t *arg_0x40f1ce00);
#line 39
static   result_t CC2420RadioM$HPLChipconFIFO$RXFIFODone(uint8_t arg_0x40f1c4e8, uint8_t *arg_0x40f1c690);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420RadioM$StdControl$init(void);






static  result_t CC2420RadioM$StdControl$start(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
static   int16_t CC2420RadioM$MacBackoff$default$initialBackoff(TOS_MsgPtr arg_0x40f2a8f0);
static   int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr arg_0x40f2adb0);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$CC2420SplitControl$initDone(void);
#line 85
static  result_t CC2420RadioM$CC2420SplitControl$startDone(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$FIFOP_GPIOInt$fired(void);
# 60 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t HPLCC2420M$CaptureSFD$disable(void);
#line 43
static   result_t HPLCC2420M$CaptureSFD$enableCapture(bool arg_0x40f1fd70);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t arg_0x40956010);
#line 54
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t arg_0x40957918, uint16_t arg_0x40957aa8);
#line 47
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t arg_0x40957408);
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   void HPLCC2420M$TxDMAChannel$stopInterrupt(uint16_t arg_0x4054a8e0);







static   void HPLCC2420M$TxDMAChannel$startInterrupt(void);
#line 86
static  result_t HPLCC2420M$TxDMAChannel$requestChannelDone(void);
#line 249
static   void HPLCC2420M$TxDMAChannel$eorInterrupt(uint16_t arg_0x4054a280);
#line 236
static   void HPLCC2420M$TxDMAChannel$endInterrupt(uint16_t arg_0x4054cc28);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$CCA_GPIOInt$fired(void);
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   void HPLCC2420M$RxDMAChannel$stopInterrupt(uint16_t arg_0x4054a8e0);







static   void HPLCC2420M$RxDMAChannel$startInterrupt(void);
#line 86
static  result_t HPLCC2420M$RxDMAChannel$requestChannelDone(void);
#line 249
static   void HPLCC2420M$RxDMAChannel$eorInterrupt(uint16_t arg_0x4054a280);
#line 236
static   void HPLCC2420M$RxDMAChannel$endInterrupt(uint16_t arg_0x4054cc28);
# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t arg_0x40f1dd70, uint8_t *arg_0x40f1df18);
#line 19
static   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t arg_0x40f1d558, uint8_t *arg_0x40f1d700);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t arg_0x40955710, uint8_t arg_0x40955898, uint8_t *arg_0x40955a40);
# 59 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420M$InterruptFIFOP$disable(void);
#line 43
static   result_t HPLCC2420M$InterruptFIFOP$startWait(bool arg_0x40959bc8);
#line 59
static   result_t HPLCC2420M$InterruptCCA$disable(void);
#line 43
static   result_t HPLCC2420M$InterruptCCA$startWait(bool arg_0x40959bc8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HPLCC2420M$StdControl$init(void);






static  result_t HPLCC2420M$StdControl$start(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$FIFO_GPIOInt$fired(void);
#line 48
static   void HPLCC2420M$SFD_GPIOInt$fired(void);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420M$InterruptFIFO$default$fired(void);







static   result_t HPLCC2420M$InterruptFIFO$disable(void);
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t arg_0x40f16428);



static   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);
#line 8
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void TimerJiffyAsyncM$OSTIrq$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t TimerJiffyAsyncM$StdControl$init(void);






static  result_t TimerJiffyAsyncM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t FlashManagerM$EraseTimer$fired(void);
#line 73
static  result_t FlashManagerM$WritingTimer$fired(void);
#line 73
static  result_t FlashManagerM$EraseCheckTimer$fired(void);
# 29 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
static  result_t FlashManagerM$FlashManager$init(void);
#line 53
static  result_t FlashManagerM$FlashManager$read(uint32_t arg_0x40adc9a0, uint8_t *arg_0x40adcb48, uint16_t arg_0x40adcce0);
#line 33
static  result_t FlashManagerM$FlashManager$write(uint32_t arg_0x40ab7c08, void *arg_0x40ab7da8, uint16_t arg_0x40adc010);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FlashManagerM$StdControl$init(void);






static  result_t FlashManagerM$StdControl$start(void);
# 52 "/home/xu/oasis/lib/SmartSensing/Flash.nc"
static  result_t FlashM$Flash$read(uint32_t arg_0x40ad0120, uint8_t *arg_0x40ad02c8, uint32_t arg_0x40ad0460);
#line 28
static  result_t FlashM$Flash$erase(uint32_t arg_0x40ad11d8);
#line 19
static  result_t FlashM$Flash$write(uint32_t arg_0x40ad3868, uint8_t *arg_0x40ad3a10, uint32_t arg_0x40ad3ba8);
#line 54
static  void FlashM$Flash$setFlashPartitionState(uint32_t arg_0x40ad0ad8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FlashM$StdControl$init(void);






static  result_t FlashM$StdControl$start(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t FramerM$ByteComm$txDone(void);
#line 75
static   result_t FramerM$ByteComm$txByteReady(bool arg_0x410a3b30);
#line 66
static   result_t FramerM$ByteComm$rxByteReady(uint8_t arg_0x410a3200, bool arg_0x410a3388, uint16_t arg_0x410a3520);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t FramerM$BareSendMsg$send(TOS_MsgPtr arg_0x40615d50);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FramerM$StdControl$init(void);






static  result_t FramerM$StdControl$start(void);
# 88 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  result_t FramerM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x410a6cf8);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 75 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x410a64c8, uint8_t arg_0x410a6650);
# 97 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
static   result_t UARTM$HPLUART$get(uint8_t arg_0x41111e58);







static   result_t UARTM$HPLUART$putDone(void);
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t UARTM$ByteComm$txByte(uint8_t arg_0x410abc98);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t UARTM$Control$init(void);






static  result_t UARTM$Control$start(void);
# 63 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
static   result_t HPLFFUARTM$UART$init(void);
#line 89
static   result_t HPLFFUARTM$UART$put(uint8_t arg_0x411118c0);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void HPLFFUARTM$Interrupt$fired(void);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658);
#line 33
static   void ClockTimeStampingM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t ClockTimeStampingM$HPLCC2420RAM$writeDone(uint16_t arg_0x40954010, uint8_t arg_0x40954198, uint8_t *arg_0x40954340);
# 39 "/home/xu/oasis/interfaces/TimeStamping.nc"
static  result_t ClockTimeStampingM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40e93010, uint32_t *arg_0x40e931c8);
# 29 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
static  result_t DataMgmtM$DataMgmt$freeBlk(void *arg_0x40abbc80);
#line 28
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t arg_0x40abb7b8);



static  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t arg_0x40abac20);
#line 30
static  result_t DataMgmtM$DataMgmt$saveBlk(void *arg_0x40aba140, uint8_t arg_0x40aba2d0);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t DataMgmtM$BatchTimer$fired(void);
#line 73
static  result_t DataMgmtM$SysCheckTimer$fired(void);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t DataMgmtM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t DataMgmtM$StdControl$init(void);






static  result_t DataMgmtM$StdControl$start(void);
# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
static  result_t ADCM$ADCControl$bindPort(uint8_t arg_0x40aa4340, uint8_t arg_0x40aa44c8);
#line 50
static  result_t ADCM$ADCControl$init(void);
# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   result_t ADCM$Clock$fire(void);
# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t ADCM$ADC$getData(
# 34 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
uint8_t arg_0x411da910);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t ADCM$StdControl$init(void);






static  result_t ADCM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t ADCM$Timer$fired(void);
# 16 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  uint8_t NeighborMgmtM$writeNbrLinkInfo(uint8_t *arg_0x412129e8, uint8_t arg_0x41212b70);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t arg_0x40e1ddf0, uint16_t arg_0x40e1c010, bool arg_0x40e1c1a0);
#line 6
static  bool NeighborMgmtM$NeighborCtrl$clearParent(bool arg_0x40e1d950);








static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t arg_0x40e1bc70, uint16_t arg_0x40e1be00);
#line 4
static  bool NeighborMgmtM$NeighborCtrl$changeParent(uint16_t *arg_0x40e1fc48, uint16_t *arg_0x40e1fdf8, uint16_t *arg_0x40e1d010);
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t arg_0x40e1d4c0);
# 2 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t NeighborMgmtM$StdControl$init(void);






static  result_t NeighborMgmtM$StdControl$start(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t NeighborMgmtM$Timer$fired(void);
#line 73
static  result_t MultiHopEngineM$RouteStatusTimer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Intercept$default$intercept(
# 22 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x41310200, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
#line 86
static  result_t MultiHopEngineM$Snoop$default$intercept(
# 23 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413107e0, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t MultiHopEngineM$Send$send(
# 20 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413114b8, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
#line 106
static  void *MultiHopEngineM$Send$getBuffer(
# 20 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413114b8, 
# 106 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38);
#line 119
static  result_t MultiHopEngineM$Send$default$sendDone(
# 20 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413114b8, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t MultiHopEngineM$EventReport$eventSendDone(TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 6 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopEngineM$StdControl$init(void);






static  result_t MultiHopEngineM$StdControl$start(void);
# 84 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
static  uint16_t MultiHopEngineM$RouteControl$getQuality(void);
#line 49
static  uint16_t MultiHopEngineM$RouteControl$getParent(void);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopEngineM$MonitorTimer$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr CascadesRouterM$ReceiveMsg$receive(
# 39 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x41368228, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40620878);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesRouterM$SubSend$sendDone(
# 40 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x413687d8, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$DTTimer$fired(void);
#line 73
static  result_t CascadesRouterM$RTTimer$fired(void);
#line 73
static  result_t CascadesRouterM$DelayTimer$fired(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr CascadesRouterM$Receive$default$receive(
# 36 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x41369c38, 
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
TOS_MsgPtr arg_0x409b8068, void *arg_0x409b8208, uint16_t arg_0x409b83a0);
# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  result_t CascadesRouterM$CascadeControl$addDirectChild(address_t arg_0x4121abb0);
static  result_t CascadesRouterM$CascadeControl$deleteDirectChild(address_t arg_0x41218088);
static  result_t CascadesRouterM$CascadeControl$parentChanged(address_t arg_0x41218530);
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
uint8_t arg_0x414016a8, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
static  result_t CascadesEngineM$SendMsg$sendDone(
# 39 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x414016a8, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesEngineM$MySend$send(
# 36 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x41402e60, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CascadesEngineM$StdControl$init(void);
# 47 "/opt/tinyos-1.x/tos/system/RealMain.nc"
static  result_t RealMain$hardwareInit(void);
# 78 "/opt/tinyos-1.x/tos/interfaces/Pot.nc"
static  result_t RealMain$Pot$init(uint8_t arg_0x40426ac0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RealMain$StdControl$init(void);






static  result_t RealMain$StdControl$start(void);
# 54 "/opt/tinyos-1.x/tos/system/RealMain.nc"
int main(void)   ;
# 74 "/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
static  result_t PotM$HPLPot$finalise(void);
#line 59
static  result_t PotM$HPLPot$decrease(void);







static  result_t PotM$HPLPot$increase(void);
# 91 "/opt/tinyos-1.x/tos/system/PotM.nc"
uint8_t PotM$potSetting;

static inline void PotM$setPot(uint8_t value);
#line 106
static inline  result_t PotM$Pot$init(uint8_t initialSetting);
# 79 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPotC.nc"
static inline  result_t HPLPotC$Pot$decrease(void);










static inline  result_t HPLPotC$Pot$increase(void);










static inline  result_t HPLPotC$Pot$finalise(void);
# 54 "/opt/tinyos-1.x/tos/platform/imote2/DVFS.nc"
static  result_t HPLInitM$DVFS$SwitchCoreFreq(uint32_t arg_0x4044bac0, uint32_t arg_0x4044bc58);
# 87 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLInitM.nc"
queue_t paramtaskQueue  ;

static inline  result_t HPLInitM$init(void);
# 51 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
static  result_t DVFSM$PMIC$setCoreVoltage(uint8_t arg_0x404bd718);
# 58 "/opt/tinyos-1.x/tos/platform/imote2/DVFSM.nc"
static  result_t DVFSM$DVFS$SwitchCoreFreq(uint32_t coreFreq, uint32_t sysBusFreq);
#line 176
static inline  BluSH_result_t DVFSM$SwitchFreq$getName(char *buff, uint8_t len);





static inline  BluSH_result_t DVFSM$SwitchFreq$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 206
static inline  BluSH_result_t DVFSM$GetFreq$getName(char *buff, uint8_t len);





static inline  BluSH_result_t DVFSM$GetFreq$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
# 47 "/opt/tinyos-1.x/tos/platform/imote2/SendDataAlloc.nc"
static  result_t BufferedSTUARTM$SendDataAlloc$sendDone(uint8_t *arg_0x404dd010, uint32_t arg_0x404dd1a8, result_t arg_0x404dd338);
# 35 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
static  result_t BufferedSTUARTM$BulkTxRx$BulkTransmit(uint8_t *arg_0x404f4600, uint16_t arg_0x404f4798);
#line 27
static  result_t BufferedSTUARTM$BulkTxRx$BulkReceive(uint8_t *arg_0x40501dd8, uint16_t arg_0x404f4010);
# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
static  result_t BufferedSTUARTM$ReceiveData$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0);
# 62 "/opt/tinyos-1.x/tos/platform/imote2/SendData.nc"
static  result_t BufferedSTUARTM$SendData$sendDone(uint8_t *arg_0x404e11a8, uint32_t arg_0x404e1340, result_t arg_0x404e14d0);
# 23 "/opt/tinyos-1.x/tos/platform/imote2/BufferedSTUARTM.nc"
ptrqueue_t outgoingQueue  ;
# 4 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/paramtask.h"
unsigned char TOS_parampost(void (*tp)(void), uint32_t arg)   ;
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
#line 6
typedef enum BufferedSTUARTM$__nesc_unnamed4306 {
  BufferedSTUARTM$originSendData = 0, 
  BufferedSTUARTM$originSendDataAlloc
} BufferedSTUARTM$sendOrigin_t;

bufferInfoSet_t BufferedSTUARTM$receiveBufferInfoSet;
#line 11
bufferInfoInfo_t BufferedSTUARTM$receiveBufferInfoInfo[30];
#line 11
bufferSet_t BufferedSTUARTM$receiveBufferSet;
#line 11
buffer_t BufferedSTUARTM$receiveBufferStructs[30];
#line 11
uint8_t BufferedSTUARTM$receiveBuffers[30][((10 + 31) >> 5) << 5] __attribute((aligned(32))) ;




bool BufferedSTUARTM$gTxActive = FALSE;

static inline void BufferedSTUARTM$transmitDone(uint32_t arg);
static inline void BufferedSTUARTM$_transmitDoneveneer(void);

static inline void BufferedSTUARTM$receiveDone(uint32_t arg);
static inline void BufferedSTUARTM$_receiveDoneveneer(void);






static inline  result_t BufferedSTUARTM$StdControl$init(void);









static inline  result_t BufferedSTUARTM$StdControl$start(void);
#line 122
static inline   result_t BufferedSTUARTM$SendDataAlloc$default$sendDone(uint8_t *data, uint32_t numBytes, result_t success);
#line 192
static inline void BufferedSTUARTM$transmitDone(uint32_t arg);
#line 224
static inline void BufferedSTUARTM$receiveDone(uint32_t arg);
#line 260
static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkReceiveDone(uint8_t *RxBuffer, 
uint16_t NumBytes);
#line 285
static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkTransmitDone(uint8_t *TxBuffer, uint16_t NumBytes);
# 143 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static  result_t STUARTM$TxDMAChannel$enableTargetAddrIncrement(bool arg_0x4053f608);
#line 161
static  result_t STUARTM$TxDMAChannel$enableTargetFlowControl(bool arg_0x4054e188);
#line 123
static   result_t STUARTM$TxDMAChannel$setTargetAddr(uint32_t arg_0x4053aaa8);
#line 182
static   result_t STUARTM$TxDMAChannel$setTransferLength(uint16_t arg_0x4054ed20);









static  result_t STUARTM$TxDMAChannel$setTransferWidth(DMATransferWidth_t arg_0x4054d358);
#line 113
static   result_t STUARTM$TxDMAChannel$setSourceAddr(uint32_t arg_0x4053a528);
#line 172
static  result_t STUARTM$TxDMAChannel$setMaxBurstSize(DMAMaxBurstSize_t arg_0x4054e720);
#line 152
static  result_t STUARTM$TxDMAChannel$enableSourceFlowControl(bool arg_0x4053fbd8);
#line 204
static   result_t STUARTM$TxDMAChannel$run(DMAInterruptEnable_t arg_0x4054d948);
#line 77
static  result_t STUARTM$TxDMAChannel$requestChannel(DMAPeripheralID_t arg_0x405402f8, 
DMAPriority_t arg_0x405404a0, bool arg_0x40540630);
#line 133
static  result_t STUARTM$TxDMAChannel$enableSourceAddrIncrement(bool arg_0x4053f030);









static  result_t STUARTM$RxDMAChannel$enableTargetAddrIncrement(bool arg_0x4053f608);
#line 161
static  result_t STUARTM$RxDMAChannel$enableTargetFlowControl(bool arg_0x4054e188);
#line 123
static   result_t STUARTM$RxDMAChannel$setTargetAddr(uint32_t arg_0x4053aaa8);
#line 182
static   result_t STUARTM$RxDMAChannel$setTransferLength(uint16_t arg_0x4054ed20);









static  result_t STUARTM$RxDMAChannel$setTransferWidth(DMATransferWidth_t arg_0x4054d358);
#line 113
static   result_t STUARTM$RxDMAChannel$setSourceAddr(uint32_t arg_0x4053a528);
#line 172
static  result_t STUARTM$RxDMAChannel$setMaxBurstSize(DMAMaxBurstSize_t arg_0x4054e720);
#line 152
static  result_t STUARTM$RxDMAChannel$enableSourceFlowControl(bool arg_0x4053fbd8);
#line 204
static   result_t STUARTM$RxDMAChannel$run(DMAInterruptEnable_t arg_0x4054d948);
#line 77
static  result_t STUARTM$RxDMAChannel$requestChannel(DMAPeripheralID_t arg_0x405402f8, 
DMAPriority_t arg_0x405404a0, bool arg_0x40540630);
#line 133
static  result_t STUARTM$RxDMAChannel$enableSourceAddrIncrement(bool arg_0x4053f030);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void STUARTM$UARTInterrupt$disable(void);
#line 45
static   result_t STUARTM$UARTInterrupt$allocate(void);
# 63 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
static   uint8_t *STUARTM$BulkTxRx$BulkReceiveDone(uint8_t *arg_0x404f3720, uint16_t arg_0x404f38b8);







static   uint8_t *STUARTM$BulkTxRx$BulkTransmitDone(uint8_t *arg_0x404ff190, uint16_t arg_0x404ff328);
# 41 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
 bool STUARTM$gTxPortInUse = FALSE;
 bool STUARTM$gRxPortInUse = FALSE;
bool STUARTM$gPortInitialized = FALSE;

 uint16_t STUARTM$gNumRxFifoOverruns;

 uint8_t *STUARTM$gRxBuffer;
 uint16_t STUARTM$gRxNumBytes;
#line 48
 uint16_t STUARTM$gRxBufferPos;

 uint8_t *STUARTM$gTxBuffer;
 uint16_t STUARTM$gTxNumBytes;
#line 51
 uint16_t STUARTM$gTxBufferPos;



static void STUARTM$initPort(void);
#line 76
static void STUARTM$configPort(void);
#line 114
static inline result_t STUARTM$openTxPort(bool bTxDMAIntEnable);
#line 146
static inline result_t STUARTM$openRxPort(bool bRxDMAIntEnable);
#line 177
static result_t STUARTM$closeTxPort(void);
#line 199
static result_t STUARTM$closeRxPort(void);
#line 217
static inline void STUARTM$configureRxDMA(uint8_t *RxBuffer, uint16_t NumBytes, bool bEnableTargetAddrIncrement);
#line 240
static inline  result_t STUARTM$BulkTxRx$BulkReceive(uint8_t *RxBuffer, uint16_t NumBytes);
#line 269
static inline  result_t STUARTM$RxDMAChannel$requestChannelDone(void);






static void STUARTM$handleRxDMADone(uint16_t numBytesSent);
#line 296
static inline   void STUARTM$RxDMAChannel$startInterrupt(void);


static inline   void STUARTM$RxDMAChannel$stopInterrupt(uint16_t numbBytesSent);










static inline   void STUARTM$RxDMAChannel$eorInterrupt(uint16_t numBytesSent);




static inline   void STUARTM$RxDMAChannel$endInterrupt(uint16_t numBytesSent);






static inline void STUARTM$configureTxDMA(uint8_t *TxBuffer, uint16_t NumBytes);
#line 335
static inline  result_t STUARTM$BulkTxRx$BulkTransmit(uint8_t *TxBuffer, uint16_t NumBytes);
#line 368
static inline  result_t STUARTM$TxDMAChannel$requestChannelDone(void);






static inline   void STUARTM$TxDMAChannel$startInterrupt(void);




static inline   void STUARTM$TxDMAChannel$stopInterrupt(uint16_t numBytesLeft);




static inline   void STUARTM$TxDMAChannel$eorInterrupt(uint16_t numBytesLeft);




static inline   void STUARTM$TxDMAChannel$endInterrupt(uint16_t numBytesSent);
#line 414
static inline  void STUARTM$printUARTError(void);



static inline   void STUARTM$UARTInterrupt$fired(void);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XDMAM$Interrupt$enable(void);
#line 45
static   result_t PXA27XDMAM$Interrupt$allocate(void);
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   void PXA27XDMAM$PXA27XDMAChannel$stopInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054a8e0);







static   void PXA27XDMAM$PXA27XDMAChannel$startInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790);
# 86 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static  result_t PXA27XDMAM$PXA27XDMAChannel$requestChannelDone(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790);
# 249 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
static   void PXA27XDMAM$PXA27XDMAChannel$eorInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 249 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054a280);
#line 236
static   void PXA27XDMAM$PXA27XDMAChannel$endInterrupt(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
uint8_t arg_0x40593790, 
# 236 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
uint16_t arg_0x4054cc28);
# 4 "/opt/tinyos-1.x/tos/platform/pxa27x/lib/paramtask.h"
unsigned char TOS_parampost(void (*tp)(void), uint32_t arg)   ;
# 87 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
#line 82
typedef struct PXA27XDMAM$__nesc_unnamed4307 {
  uint32_t DDADR;
  uint32_t DSADR;
  uint32_t DTADR;
  uint32_t DCMD;
} PXA27XDMAM$DMADescriptor_t;






#line 89
typedef struct PXA27XDMAM$__nesc_unnamed4308 {
  bool channelValid;
  uint8_t realChannel;
  DMAPeripheralID_t peripheralID;
  uint16_t length;
} PXA27XDMAM$DMAChannelInfo_t;





#line 96
typedef struct PXA27XDMAM$__nesc_unnamed4309 {
  uint8_t virtualChannel;
  bool inUse;
  bool permanent;
} PXA27XDMAM$ChannelMapItem_t;





PXA27XDMAM$DMADescriptor_t PXA27XDMAM$mDescriptorArray[4U];
 PXA27XDMAM$DMAChannelInfo_t PXA27XDMAM$mChannelArray[4U];

PXA27XDMAM$ChannelMapItem_t PXA27XDMAM$mPriorityMap[32];

bool PXA27XDMAM$gInitialized = FALSE;

static inline  result_t PXA27XDMAM$StdControl$init(void);
#line 129
static inline  result_t PXA27XDMAM$StdControl$start(void);
#line 142
static inline void PXA27XDMAM$postRequestChannelDone(uint32_t arg);



static inline void PXA27XDMAM$_postRequestChannelDoneveneer(void);


static  result_t PXA27XDMAM$PXA27XDMAChannel$requestChannel(uint8_t channel, DMAPeripheralID_t peripheralID, 
DMAPriority_t priority, 
bool permanent);
#line 245
static inline   result_t PXA27XDMAM$PXA27XDMAChannel$default$requestChannelDone(uint8_t channel);



static   result_t PXA27XDMAM$PXA27XDMAChannel$setSourceAddr(uint8_t channel, uint32_t val);






static   result_t PXA27XDMAM$PXA27XDMAChannel$setTargetAddr(uint8_t channel, uint32_t val);






static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceAddrIncrement(uint8_t channel, bool enable);





static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetAddrIncrement(uint8_t channel, bool enable);






static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceFlowControl(uint8_t channel, bool enable);






static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetFlowControl(uint8_t channel, bool enable);






static  result_t PXA27XDMAM$PXA27XDMAChannel$setMaxBurstSize(uint8_t channel, DMAMaxBurstSize_t size);
#line 302
static   result_t PXA27XDMAM$PXA27XDMAChannel$setTransferLength(uint8_t channel, uint16_t length);
#line 316
static  result_t PXA27XDMAM$PXA27XDMAChannel$setTransferWidth(uint8_t channel, DMATransferWidth_t width);
#line 346
static   result_t PXA27XDMAM$PXA27XDMAChannel$run(uint8_t channel, DMAInterruptEnable_t interruptEn);
#line 392
static inline    void PXA27XDMAM$PXA27XDMAChannel$default$stopInterrupt(uint8_t channel, uint16_t numBytesSent);



static inline    void PXA27XDMAM$PXA27XDMAChannel$default$startInterrupt(uint8_t channel);



static inline    void PXA27XDMAM$PXA27XDMAChannel$default$eorInterrupt(uint8_t channel, uint16_t numBytesSent);



static inline    void PXA27XDMAM$PXA27XDMAChannel$default$endInterrupt(uint8_t channel, uint16_t numByteSent);




 volatile uint32_t globalDMAVirtualChannelHandled  ;

static inline   void PXA27XDMAM$Interrupt$fired(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XFiq$fired(
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405de5d0);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XInterruptM$PXA27XIrq$fired(
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
uint8_t arg_0x405ecc80);
#line 75
void hplarmv_dabort(void)   __attribute((interrupt("ABORT"))) ;
#line 116
void hplarmv_pabort(void)   __attribute((interrupt("ABORT"))) ;
#line 143
extern  volatile uint32_t globalDMAVirtualChannelHandled  ;


void hplarmv_irq(void)   __attribute((interrupt("IRQ"))) ;
#line 204
void hplarmv_fiq(void)   __attribute((interrupt("FIQ"))) ;
#line 221
static uint8_t PXA27XInterruptM$usedPriorities = 0;




static result_t PXA27XInterruptM$allocate(uint8_t id, bool level, uint8_t priority);
#line 294
static void PXA27XInterruptM$enable(uint8_t id);
#line 306
static void PXA27XInterruptM$disable(uint8_t id);
#line 320
static inline   result_t PXA27XInterruptM$PXA27XIrq$allocate(uint8_t id);




static inline   void PXA27XInterruptM$PXA27XIrq$enable(uint8_t id);





static inline   void PXA27XInterruptM$PXA27XIrq$disable(uint8_t id);
#line 354
static inline    void PXA27XInterruptM$PXA27XIrq$default$fired(uint8_t id);




static inline    void PXA27XInterruptM$PXA27XFiq$default$fired(uint8_t id);
# 11 "/opt/tinyos-1.x/tos/platform/imote2/UIDC.nc"
static inline   uint32_t UIDC$UID$getUID(void);
# 14 "/opt/tinyos-1.x/tos/platform/imote2/HPLUSBClientGPIOM.nc"
static inline   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$init(void);
#line 27
static inline   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$checkConnection(void);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XGPIOIntM$GPIOIrq0$enable(void);
#line 45
static   result_t PXA27XGPIOIntM$GPIOIrq0$allocate(void);
static   void PXA27XGPIOIntM$GPIOIrq$enable(void);
#line 45
static   result_t PXA27XGPIOIntM$GPIOIrq$allocate(void);
static   void PXA27XGPIOIntM$GPIOIrq1$enable(void);
#line 45
static   result_t PXA27XGPIOIntM$GPIOIrq1$allocate(void);
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$fired(
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
uint8_t arg_0x40643bb0);










bool PXA27XGPIOIntM$gfInitialized = FALSE;

static  result_t PXA27XGPIOIntM$StdControl$init(void);
#line 75
static  result_t PXA27XGPIOIntM$StdControl$start(void);
#line 88
static   void PXA27XGPIOIntM$PXA27XGPIOInt$enable(uint8_t pin, uint8_t mode);
#line 112
static   void PXA27XGPIOIntM$PXA27XGPIOInt$disable(uint8_t pin);









static   void PXA27XGPIOIntM$PXA27XGPIOInt$clear(uint8_t pin);








static    void PXA27XGPIOIntM$PXA27XGPIOInt$default$fired(uint8_t pin);





static inline   void PXA27XGPIOIntM$GPIOIrq$fired(void);
#line 179
static inline   void PXA27XGPIOIntM$GPIOIrq0$fired(void);




static inline   void PXA27XGPIOIntM$GPIOIrq1$fired(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr PXA27XUSBClientM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 28 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
static  result_t PXA27XUSBClientM$SendJTPacket$sendDone(
# 24 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
uint8_t arg_0x4065c5b8, 
# 28 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
uint8_t *arg_0x40614b20, uint8_t arg_0x40614ca8, result_t arg_0x40614e38);
# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/UID.nc"
static   uint32_t PXA27XUSBClientM$UID$getUID(void);
# 62 "/opt/tinyos-1.x/tos/interfaces/SendVarLenPacket.nc"
static  result_t PXA27XUSBClientM$SendVarLenPacket$sendDone(uint8_t *arg_0x406168e8, result_t arg_0x40616a78);
# 10 "/opt/tinyos-1.x/tos/platform/pxa27x/ReceiveBData.nc"
static  result_t PXA27XUSBClientM$ReceiveBData$receive(uint8_t *arg_0x40621118, uint8_t arg_0x406212a8, 
uint32_t arg_0x40621448, uint32_t arg_0x406215d8, uint8_t arg_0x40621760);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XUSBClientM$USBAttached$clear(void);
#line 45
static   void PXA27XUSBClientM$USBAttached$enable(uint8_t arg_0x406321d8);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XUSBClientM$USBInterrupt$enable(void);
#line 45
static   result_t PXA27XUSBClientM$USBInterrupt$allocate(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t PXA27XUSBClientM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
static  result_t PXA27XUSBClientM$ReceiveData$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0);
# 35 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLUSBClientGPIO.nc"
static   result_t PXA27XUSBClientM$HPLUSBClientGPIO$checkConnection(void);
#line 19
static   result_t PXA27XUSBClientM$HPLUSBClientGPIO$init(void);
# 14 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.h"
typedef struct PXA27XUSBClientM$DynQueue_T *PXA27XUSBClientM$DynQueue;


static PXA27XUSBClientM$DynQueue PXA27XUSBClientM$DynQueue_new(void);





static inline int PXA27XUSBClientM$DynQueue_getLength(PXA27XUSBClientM$DynQueue oDynQueue);


static void *PXA27XUSBClientM$DynQueue_dequeue(PXA27XUSBClientM$DynQueue oDynQueue);


static int PXA27XUSBClientM$DynQueue_enqueue(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem);


static void *PXA27XUSBClientM$DynQueue_peek(PXA27XUSBClientM$DynQueue oDynQueue);


static void PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem);
# 15 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
struct PXA27XUSBClientM$DynQueue_T {

  int iLength;
  int iPhysLength;
  int index;
  const void **ppvQueue;
};



static PXA27XUSBClientM$DynQueue PXA27XUSBClientM$DynQueue_new(void);
#line 65
static inline int PXA27XUSBClientM$DynQueue_getLength(PXA27XUSBClientM$DynQueue oDynQueue);
#line 78
static void *PXA27XUSBClientM$DynQueue_peek(PXA27XUSBClientM$DynQueue oDynQueue);
#line 90
static void PXA27XUSBClientM$DynQueue_shiftgrow(PXA27XUSBClientM$DynQueue oDynQueue);
#line 114
inline static void PXA27XUSBClientM$DynQueue_shiftshrink(PXA27XUSBClientM$DynQueue oDynQueue);
#line 135
static int PXA27XUSBClientM$DynQueue_enqueue(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem);
#line 153
static void *PXA27XUSBClientM$DynQueue_dequeue(PXA27XUSBClientM$DynQueue oDynQueue);
#line 176
static void PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem);
# 24 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBdata.c"
#line 10
typedef struct PXA27XUSBClientM$__USBdata {
  volatile unsigned long *endpointDR;
  uint32_t fifosize;
  uint8_t *src;
  uint32_t len;
  uint32_t tlen;
  uint32_t index;
  uint32_t pindex;
  uint32_t n;
  uint16_t status;
  uint8_t type;
  uint8_t source;
  uint8_t *param;
  uint8_t channel;
} PXA27XUSBClientM$USBdata_t;
typedef PXA27XUSBClientM$USBdata_t *PXA27XUSBClientM$USBdata;

union PXA27XUSBClientM$string_or_langid {
  uint16_t wLANGID;
  char *bString;
};







#line 32
typedef struct PXA27XUSBClientM$__hid {
  uint16_t bcdHID;
  uint16_t wDescriptorLength;
  uint8_t bCountryCode;
  uint8_t bNumDescriptors;
  uint8_t bDescriptorType;
} PXA27XUSBClientM$USBhid;




#line 40
typedef struct PXA27XUSBClientM$__hidreport {
  uint16_t wLength;
  uint8_t *bString;
} PXA27XUSBClientM$USBhidReport;




#line 45
typedef struct PXA27XUSBClientM$__string {
  uint8_t bLength;
  union PXA27XUSBClientM$string_or_langid uMisc;
} PXA27XUSBClientM$__string_t;
typedef PXA27XUSBClientM$__string_t *PXA27XUSBClientM$USBstring;






#line 51
typedef struct PXA27XUSBClientM$__endpoint {
  uint8_t bEndpointAddress;
  uint8_t bmAttributes;
  uint16_t wMaxPacketSize;
  uint8_t bInterval;
} PXA27XUSBClientM$__endpoint_t;
typedef PXA27XUSBClientM$__endpoint_t *PXA27XUSBClientM$USBendpoint;










#line 59
typedef struct PXA27XUSBClientM$__interface {
  uint8_t bInterfaceID;
  uint8_t bAlternateSetting;
  uint8_t bNumEndpoints;
  uint8_t bInterfaceClass;
  uint8_t bInterfaceSubclass;
  uint8_t bInterfaceProtocol;
  uint8_t iInterface;
  PXA27XUSBClientM$USBendpoint *oEndpoints;
} PXA27XUSBClientM$__interface_t;
typedef PXA27XUSBClientM$__interface_t *PXA27XUSBClientM$USBinterface;









#line 71
typedef struct PXA27XUSBClientM$__configuration {
  uint16_t wTotalLength;
  uint8_t bNumInterfaces;
  uint8_t bConfigurationID;
  uint8_t iConfiguration;
  uint8_t bmAttributes;
  uint8_t MaxPower;
  PXA27XUSBClientM$USBinterface *oInterfaces;
} PXA27XUSBClientM$__configuration_t;
typedef PXA27XUSBClientM$__configuration_t *PXA27XUSBClientM$USBconfiguration;
#line 96
#line 82
typedef struct PXA27XUSBClientM$__device {
  uint16_t bcdUSB;
  uint8_t bDeviceClass;
  uint8_t bDeviceSubclass;
  uint8_t bDeviceProtocol;
  uint8_t bMaxPacketSize0;
  uint16_t idVendor;
  uint16_t idProduct;
  uint16_t bcdDevice;
  uint8_t iManufacturer;
  uint8_t iProduct;
  uint8_t iSerialNumber;
  uint8_t bNumConfigurations;
  PXA27XUSBClientM$USBconfiguration *oConfigurations;
} PXA27XUSBClientM$USBdevice;
# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$writeStringDescriptor(void);
static inline void PXA27XUSBClientM$writeHidDescriptor(void);
static inline void PXA27XUSBClientM$writeHidReportDescriptor(void);
static inline void PXA27XUSBClientM$writeEndpointDescriptor(PXA27XUSBClientM$USBendpoint *endpoints, uint8_t config, uint8_t inter, uint8_t i);
static inline uint16_t PXA27XUSBClientM$writeInterfaceDescriptor(PXA27XUSBClientM$USBinterface *interfaces, uint8_t config, uint8_t i);
static inline void PXA27XUSBClientM$writeConfigurationDescriptor(PXA27XUSBClientM$USBconfiguration *configs, uint8_t i);
static inline void PXA27XUSBClientM$writeDeviceDescriptor(void);
#line 68
static inline void PXA27XUSBClientM$sendStringDescriptor(uint8_t id, uint16_t wLength);
static inline void PXA27XUSBClientM$sendDeviceDescriptor(uint16_t wLength);
static inline void PXA27XUSBClientM$sendConfigDescriptor(uint8_t id, uint16_t wLength);
static inline void PXA27XUSBClientM$sendHidReportDescriptor(uint16_t wLength);









static inline void PXA27XUSBClientM$sendReport(uint8_t *data, uint32_t datalen, uint8_t type, uint8_t source, uint8_t channel);





static  void PXA27XUSBClientM$sendIn(void);





static void PXA27XUSBClientM$sendControlIn(void);





static void PXA27XUSBClientM$clearIn(void);
static void PXA27XUSBClientM$clearUSBdata(PXA27XUSBClientM$USBdata Stream, uint8_t isConst);





static  void PXA27XUSBClientM$processOut(void);




static inline void PXA27XUSBClientM$retrieveOut(void);





static void PXA27XUSBClientM$clearOut(void);










static void PXA27XUSBClientM$handleControlSetup(void);





static void PXA27XUSBClientM$isAttached(void);

static PXA27XUSBClientM$USBdevice PXA27XUSBClientM$Device;
static PXA27XUSBClientM$USBhid PXA27XUSBClientM$Hid;
static PXA27XUSBClientM$USBhidReport PXA27XUSBClientM$HidReport;
static PXA27XUSBClientM$USBstring PXA27XUSBClientM$Strings[3 + 1];

static PXA27XUSBClientM$DynQueue PXA27XUSBClientM$InQueue;
#line 141
static PXA27XUSBClientM$DynQueue PXA27XUSBClientM$OutQueue;

static PXA27XUSBClientM$USBdata_t PXA27XUSBClientM$OutStream[4];




static PXA27XUSBClientM$USBdata PXA27XUSBClientM$InState = (void *)0;
static uint32_t PXA27XUSBClientM$state = 0;

static uint8_t PXA27XUSBClientM$init = 0;
#line 151
static uint8_t PXA27XUSBClientM$InTask = 0;




static inline  result_t PXA27XUSBClientM$Control$init(void);
#line 200
static inline  result_t PXA27XUSBClientM$Control$start(void);
#line 221
static inline   void PXA27XUSBClientM$USBAttached$fired(void);





static inline   void PXA27XUSBClientM$USBInterrupt$fired(void);
#line 389
static inline  result_t PXA27XUSBClientM$SendJTPacket$send(uint8_t channel, uint8_t *data, uint32_t numBytes, uint8_t type);
#line 407
static inline   result_t PXA27XUSBClientM$SendVarLenPacket$default$sendDone(uint8_t *packet, result_t success);



static inline   result_t PXA27XUSBClientM$SendJTPacket$default$sendDone(uint8_t channel, uint8_t *packet, uint8_t type, 
result_t success);



static inline   result_t PXA27XUSBClientM$BareSendMsg$default$sendDone(TOS_MsgPtr msg, result_t success);







static inline   result_t PXA27XUSBClientM$ReceiveBData$default$receive(uint8_t *buffer, uint8_t numBytesRead, uint32_t i, uint32_t n, uint8_t type);



static inline   TOS_MsgPtr PXA27XUSBClientM$ReceiveMsg$default$receive(TOS_MsgPtr m);



static void PXA27XUSBClientM$handleControlSetup(void);
#line 522
static inline void PXA27XUSBClientM$sendReport(uint8_t *data, uint32_t datalen, uint8_t type, uint8_t source, uint8_t channel);
#line 583
static inline void PXA27XUSBClientM$retrieveOut(void);
#line 618
static  void PXA27XUSBClientM$processOut(void);
#line 833
static  void PXA27XUSBClientM$sendIn(void);
#line 947
static void PXA27XUSBClientM$sendControlIn(void);
#line 993
static void PXA27XUSBClientM$isAttached(void);
#line 1024
static inline void PXA27XUSBClientM$sendDeviceDescriptor(uint16_t wLength);
#line 1063
static inline void PXA27XUSBClientM$sendConfigDescriptor(uint8_t id, uint16_t wLength);
#line 1119
static inline void PXA27XUSBClientM$sendStringDescriptor(uint8_t id, uint16_t wLength);
#line 1181
static inline void PXA27XUSBClientM$sendHidReportDescriptor(uint16_t wLength);
#line 1217
static inline void PXA27XUSBClientM$writeHidDescriptor(void);









static inline void PXA27XUSBClientM$writeHidReportDescriptor(void);
#line 1244
static inline void PXA27XUSBClientM$writeStringDescriptor(void);
#line 1267
static inline void PXA27XUSBClientM$writeEndpointDescriptor(PXA27XUSBClientM$USBendpoint *endpoints, uint8_t config, uint8_t inter, uint8_t i);
#line 1300
static inline uint16_t PXA27XUSBClientM$writeInterfaceDescriptor(PXA27XUSBClientM$USBinterface *interfaces, uint8_t config, uint8_t i);
#line 1346
static inline void PXA27XUSBClientM$writeConfigurationDescriptor(PXA27XUSBClientM$USBconfiguration *configs, uint8_t i);
#line 1376
static inline void PXA27XUSBClientM$writeDeviceDescriptor(void);
#line 1417
static void PXA27XUSBClientM$clearIn(void);
#line 1432
static void PXA27XUSBClientM$clearUSBdata(PXA27XUSBClientM$USBdata Stream, uint8_t isConst);









static void PXA27XUSBClientM$clearOut(void);
# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
static  result_t BluSHM$USBSend$send(uint8_t *arg_0x406141a8, uint32_t arg_0x40614340, uint8_t arg_0x406144c8);
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t BluSHM$BluSH_AppI$callApp(
# 33 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
uint8_t arg_0x40784798, 
# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
char *arg_0x404b5888, uint8_t arg_0x404b5a10, 
char *arg_0x404b5bc0, uint8_t arg_0x404b5d48);
#line 8
static  BluSH_result_t BluSHM$BluSH_AppI$getName(
# 33 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
uint8_t arg_0x40784798, 
# 8 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
char *arg_0x404b5250, uint8_t arg_0x404b53d8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t BluSHM$UartControl$init(void);






static  result_t BluSHM$UartControl$start(void);
# 5 "/opt/tinyos-1.x/tos/platform/imote2/cmdlinetools.c"
static inline void BluSHM$killWhiteSpace(char *str);

static inline void BluSHM$killWhiteSpace(char *str);
#line 80
static inline uint16_t BluSHM$firstSpace(char *str, uint16_t start);
# 105 "/usr/local/wasabi/usr/local/lib/gcc-lib/xscale-elf/Wasabi-3.3.1/include/stdarg.h" 3
typedef __gnuc_va_list BluSHM$va_list;
# 14 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.h"
typedef struct BluSHM$DynQueue_T *BluSHM$DynQueue;


static BluSHM$DynQueue BluSHM$DynQueue_new(void);





static inline int BluSHM$DynQueue_getLength(BluSHM$DynQueue oDynQueue);


static void *BluSHM$DynQueue_dequeue(BluSHM$DynQueue oDynQueue);


static int BluSHM$DynQueue_enqueue(BluSHM$DynQueue oDynQueue, const void *pvItem);


static void *BluSHM$DynQueue_peek(BluSHM$DynQueue oDynQueue);
# 15 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
struct BluSHM$DynQueue_T {

  int iLength;
  int iPhysLength;
  int index;
  const void **ppvQueue;
};



static BluSHM$DynQueue BluSHM$DynQueue_new(void);
#line 65
static inline int BluSHM$DynQueue_getLength(BluSHM$DynQueue oDynQueue);
#line 78
static void *BluSHM$DynQueue_peek(BluSHM$DynQueue oDynQueue);
#line 90
inline static void BluSHM$DynQueue_shiftgrow(BluSHM$DynQueue oDynQueue);
#line 114
inline static void BluSHM$DynQueue_shiftshrink(BluSHM$DynQueue oDynQueue);
#line 135
static int BluSHM$DynQueue_enqueue(BluSHM$DynQueue oDynQueue, const void *pvItem);
#line 153
static void *BluSHM$DynQueue_dequeue(BluSHM$DynQueue oDynQueue);
# 55 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static void generalSend(uint8_t *buf, uint32_t buflen)  ;
static  void BluSHM$processIn(void);

static inline void BluSHM$clearIn(void);
static inline void BluSHM$clearBluSHdata(BluSHdata data);

char BluSHM$blush_prompt[32];

char BluSHM$blush_history[4][80];
char BluSHM$blush_cur_line[80];

uint8_t BluSHM$InTaskCount = 0;
BluSHM$DynQueue BluSHM$InQueue;
BluSHM$DynQueue BluSHM$OutQueue;

long long BluSHM$trace_modes;


void trace(long long mode, const char *format, ...)   ;
#line 90
unsigned char trace_active(long long mode)   ;





void trace_unset(void)   ;



void trace_set(long long mode)   ;




static void generalSend(uint8_t *buf, uint32_t buflen)  ;
#line 136
static  void BluSHM$processIn(void);
#line 233
static inline  result_t BluSHM$StdControl$init(void);
#line 257
static inline  result_t BluSHM$StdControl$start(void);
#line 275
static   BluSH_result_t BluSHM$BluSH_AppI$default$getName(uint8_t id, char *buff, uint8_t len);




static inline   BluSH_result_t BluSHM$BluSH_AppI$default$callApp(uint8_t id, char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);







static void BluSHM$queueInput(uint8_t *buff, uint32_t numBytesRead);
#line 450
static inline  result_t BluSHM$UartReceive$receive(uint8_t *buff, uint32_t numBytesRead);





static inline  result_t BluSHM$USBReceive$receive(uint8_t *buff, uint32_t numBytesRead);





static inline  result_t BluSHM$UartSend$sendDone(uint8_t *packet, uint32_t numBytes, result_t success);






static inline  result_t BluSHM$USBSend$sendDone(uint8_t *packet, uint8_t type, result_t success);
#line 493
static inline void BluSHM$clearIn(void);






static inline void BluSHM$clearBluSHdata(BluSHdata data);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PMICM$PI2CInterrupt$enable(void);
#line 45
static   result_t PMICM$PI2CInterrupt$allocate(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t PMICM$batteryMonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t PMICM$GPIOIRQControl$init(void);






static  result_t PMICM$GPIOIRQControl$start(void);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PMICM$PMICInterrupt$clear(void);
#line 45
static   void PMICM$PMICInterrupt$enable(uint8_t arg_0x406321d8);
# 56 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t PMICM$Leds$init(void);
#line 106
static   result_t PMICM$Leds$greenToggle(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t PMICM$chargeMonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t PMICM$chargeMonitorTimer$stop(void);
# 46 "/opt/tinyos-1.x/tos/interfaces/Reset.nc"
static  void PMICM$Reset$reset(void);
# 97 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
bool PMICM$gotReset = FALSE;

static __inline void PMICM$TOSH_CLR_PMIC_TXON_PIN(void);
#line 99
static __inline void PMICM$TOSH_MAKE_PMIC_TXON_OUTPUT(void);

static result_t PMICM$readPMIC(uint8_t address, uint8_t *value, uint8_t numBytes);
static result_t PMICM$writePMIC(uint8_t address, uint8_t value);
static result_t PMICM$getPMICADCVal(uint8_t channel, uint8_t *val);

bool PMICM$accessingPMIC = FALSE;

static bool PMICM$getPI2CBus(void);
#line 119
static inline void PMICM$returnPI2CBus(void);





static inline bool PMICM$isChargerEnabled(void);







static inline uint8_t PMICM$getChargerVoltage(void);





static inline uint8_t PMICM$getBatteryVoltage(void);






static  result_t PMICM$StdControl$init(void);
#line 167
static void PMICM$smartChargeEnable(void);
#line 194
static inline  void PMICM$printReadPMICBusError(void);



static inline  void PMICM$printReadPMICAddresError(void);



static inline  void PMICM$printReadPMICSlaveAddresError(void);



static inline  void PMICM$printReadPMICReadByteError(void);



static result_t PMICM$readPMIC(uint8_t address, uint8_t *value, uint8_t numBytes);
#line 301
static inline  void PMICM$printWritePMICSlaveAddressError(void);



static inline  void PMICM$printWritePMICRegisterAddressError(void);



static inline  void PMICM$printWritePMICWriteError(void);





static result_t PMICM$writePMIC(uint8_t address, uint8_t value);
#line 362
static inline void PMICM$startLDOs(void);
#line 402
static inline  result_t PMICM$StdControl$start(void);
#line 459
static inline   void PMICM$PI2CInterrupt$fired(void);
#line 474
static inline  void PMICM$handlePMICIrq(void);
#line 516
static inline   void PMICM$PMICInterrupt$fired(void);
#line 538
static  result_t PMICM$PMIC$setCoreVoltage(uint8_t trimValue);
#line 609
static inline  result_t PMICM$PMIC$shutDownLDOs(void);
#line 637
static result_t PMICM$getPMICADCVal(uint8_t channel, uint8_t *val);
#line 652
static inline  result_t PMICM$PMIC$getBatteryVoltage(uint8_t *val);




static  result_t PMICM$PMIC$chargingStatus(uint8_t *vBat, uint8_t *vChg, 
uint8_t *iChg, uint8_t *chargeControl);
#line 672
static  result_t PMICM$PMIC$enableCharging(bool enable);
#line 716
static inline  result_t PMICM$batteryMonitorTimer$fired(void);
#line 733
static inline  result_t PMICM$chargeMonitorTimer$fired(void);
#line 751
static inline  BluSH_result_t PMICM$BatteryVoltage$getName(char *buff, uint8_t len);






static inline  BluSH_result_t PMICM$BatteryVoltage$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);










static inline  BluSH_result_t PMICM$ChargingStatus$getName(char *buff, uint8_t len);






static inline  BluSH_result_t PMICM$ChargingStatus$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);







static inline  BluSH_result_t PMICM$ManualCharging$getName(char *buff, uint8_t len);






static inline  BluSH_result_t PMICM$ManualCharging$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);




static inline  BluSH_result_t PMICM$ReadPMIC$getName(char *buff, uint8_t len);







static inline  BluSH_result_t PMICM$ReadPMIC$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 821
static inline  BluSH_result_t PMICM$WritePMIC$getName(char *buff, uint8_t len);







static inline  BluSH_result_t PMICM$WritePMIC$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 843
static inline  BluSH_result_t PMICM$SetCoreVoltage$getName(char *buff, uint8_t len);







static inline  BluSH_result_t PMICM$SetCoreVoltage$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
# 53 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdogM.nc"
bool PXA27XWatchdogM$resetMoteRequest;

static inline  void PXA27XWatchdogM$PXA27XWatchdog$init(void);



static inline  void PXA27XWatchdogM$PXA27XWatchdog$enableWDT(uint32_t interval);





static inline  void PXA27XWatchdogM$PXA27XWatchdog$feedWDT(uint32_t interval);





static inline  void PXA27XWatchdogM$Reset$reset(void);
# 51 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$init(void);
#line 63
static inline   result_t NoLeds$Leds$redToggle(void);
#line 75
static inline   result_t NoLeds$Leds$greenToggle(void);
#line 87
static inline   result_t NoLeds$Leds$yellowToggle(void);
# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   void TimerM$Clock$setInterval(uint32_t arg_0x408ca068);
#line 153
static   uint32_t TimerM$Clock$readCounter(void);
#line 96
static   result_t TimerM$Clock$setRate(uint32_t arg_0x408c5460, uint32_t arg_0x408c55f0);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimerM$Timer$fired(
# 50 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
uint8_t arg_0x408cf2b8);









 uint32_t TimerM$mState;
 uint32_t TimerM$mCurrentInterval;

 int8_t TimerM$queue_head;
 int8_t TimerM$queue_tail;
 uint8_t TimerM$queue_size;
 uint8_t TimerM$queue[NUM_TIMERS];






 
#line 69
struct TimerM$timer_s {
  uint8_t type;
  int32_t ticks;
  int32_t ticksLeft;
} TimerM$mTimerList[NUM_TIMERS];

static  result_t TimerM$StdControl$init(void);










static inline  result_t TimerM$StdControl$start(void);
#line 98
static  result_t TimerM$Timer$start(uint8_t id, char type, 
uint32_t interval);
#line 171
static  result_t TimerM$Timer$stop(uint8_t id);
#line 192
static inline   result_t TimerM$Timer$default$fired(uint8_t id);



static inline void TimerM$enqueue(uint8_t value);







static inline uint8_t TimerM$dequeue(void);
#line 219
static inline  void TimerM$signalOneTimer(void);





static inline   result_t TimerM$Clock$fire(void);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void PXA27XClockM$OSTIrq$enable(void);
#line 45
static   result_t PXA27XClockM$OSTIrq$allocate(void);
# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   result_t PXA27XClockM$Clock$fire(void);
# 81 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
uint8_t PXA27XClockM$gmInterval;


static inline   void PXA27XClockM$OSTIrq$fired(void);
#line 109
static inline  result_t PXA27XClockM$StdControl$init(void);
#line 124
static inline  result_t PXA27XClockM$StdControl$start(void);
#line 167
static inline   result_t PXA27XClockM$Clock$setRate(uint32_t interval, uint32_t scale);
#line 208
static   void PXA27XClockM$Clock$setInterval(uint32_t value);
#line 245
static inline   uint32_t PXA27XClockM$Clock$readCounter(void);
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPowerManagementM.nc"
static inline   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SettingsM$StackCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 56 "/opt/tinyos-1.x/tos/platform/pxa27x/Sleep.nc"
static  result_t SettingsM$Sleep$goToDeepSleep(uint32_t arg_0x4090f8e0);
# 46 "/opt/tinyos-1.x/tos/interfaces/Reset.nc"
static  void SettingsM$Reset$reset(void);
# 83 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
uint32_t SettingsM$ResetCause;

static inline  result_t SettingsM$StdControl$init(void);



static inline  result_t SettingsM$StdControl$start(void);
#line 119
static inline  void SettingsM$testQueue(void);



static inline  void SettingsM$doReset(void);



static inline  BluSH_result_t SettingsM$NodeID$getName(char *buff, uint8_t len);





static inline  BluSH_result_t SettingsM$NodeID$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);




static inline  BluSH_result_t SettingsM$TestTaskQueue$getName(char *buff, uint8_t len);





static inline  BluSH_result_t SettingsM$TestTaskQueue$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 202
static inline  BluSH_result_t SettingsM$GoToSleep$getName(char *buff, uint8_t len);





static inline  BluSH_result_t SettingsM$GoToSleep$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 222
static inline  BluSH_result_t SettingsM$ResetNode$getName(char *buff, uint8_t len);





static inline  BluSH_result_t SettingsM$ResetNode$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);





static inline  BluSH_result_t SettingsM$GetResetCause$getName(char *buff, uint8_t len);





static inline  BluSH_result_t SettingsM$GetResetCause$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen);
#line 260
static inline  result_t SettingsM$StackCheckTimer$fired(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420ControlM$SplitControl$initDone(void);
#line 85
static  result_t CC2420ControlM$SplitControl$startDone(void);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0x40956010);
#line 54
static   uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0x40957918, uint16_t arg_0x40957aa8);
#line 47
static   uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0x40957408);
# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420ControlM$CCA$startWait(bool arg_0x40959bc8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420ControlM$HPLChipconControl$init(void);






static  result_t CC2420ControlM$HPLChipconControl$start(void);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0x40955710, uint8_t arg_0x40955898, uint8_t *arg_0x40955a40);
# 63 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
enum CC2420ControlM$__nesc_unnamed4310 {
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
static  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t chnl);
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
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XPowerModesM.nc"
static inline void PXA27XPowerModesM$DisablePeripherals(void);
#line 90
static inline void PXA27XPowerModesM$EnterDeepSleep(void);
#line 141
static inline  void PXA27XPowerModesM$PXA27XPowerModes$SwitchMode(uint8_t targetMode);
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XPowerModes.nc"
static  void SleepM$PXA27XPowerModes$SwitchMode(uint8_t arg_0x40997ab8);
# 52 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
static  result_t SleepM$PMIC$shutDownLDOs(void);
# 54 "/opt/tinyos-1.x/tos/platform/pxa27x/SleepM.nc"
static inline  result_t SleepM$Sleep$goToDeepSleep(uint32_t sleepTime);
# 28 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
static  void *SmartSensingM$DataMgmt$allocBlk(uint8_t arg_0x40abb7b8);

static  result_t SmartSensingM$DataMgmt$saveBlk(void *arg_0x40aba140, uint8_t arg_0x40aba2d0);
# 90 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static  uint8_t SmartSensingM$writeNbrLinkInfo(uint8_t *arg_0x40adacb0, uint8_t arg_0x40adae38);
# 39 "/home/xu/oasis/interfaces/RealTime.nc"
static  uint32_t SmartSensingM$RealTime$getTimeCount(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t SmartSensingM$LocalTime$read(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t SmartSensingM$Random$rand(void);
# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
static  result_t SmartSensingM$ADCControl$bindPort(uint8_t arg_0x40aa4340, uint8_t arg_0x40aa44c8);
#line 50
static  result_t SmartSensingM$ADCControl$init(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$SensingTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t SmartSensingM$SensingTimer$stop(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t SmartSensingM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SmartSensingM$SubControl$init(void);






static  result_t SmartSensingM$SubControl$start(void);
#line 63
static  result_t SmartSensingM$TimerControl$init(void);






static  result_t SmartSensingM$TimerControl$start(void);
# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t SmartSensingM$Leds$yellowToggle(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$initTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t SmartSensingM$initTimer$stop(void);
# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t SmartSensingM$ADC$getData(
# 65 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
uint8_t arg_0x40aa9310);
# 29 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
static  result_t SmartSensingM$FlashManager$init(void);



static  result_t SmartSensingM$FlashManager$write(uint32_t arg_0x40ab7c08, void *arg_0x40ab7da8, uint16_t arg_0x40adc010);
# 84 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
static  uint16_t SmartSensingM$RouteControl$getQuality(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SmartSensingM$WatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t SmartSensingM$WatchTimer$stop(void);
# 96 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
 uint16_t SmartSensingM$timerInterval;

 uint16_t SmartSensingM$defaultCode;

 bool SmartSensingM$initedClock;

 uint16_t SmartSensingM$LQIFactor;



bool SmartSensingM$realTimeFired;
uint8_t SmartSensingM$global = 0;




SenBlkPtr SmartSensingM$sensingCurBlk;


static inline void SmartSensingM$initDefault(void);
static inline void SmartSensingM$trySample(void);
static void SmartSensingM$saveData(uint8_t type, uint16_t data);
static uint16_t SmartSensingM$calFireInterval(void);
static void SmartSensingM$updateMaxBlkNum(void);
static void SmartSensingM$setrate(void);
static void SmartSensingM$upFlashClient(void);
static inline result_t SmartSensingM$oversample(uint16_t *data, uint8_t client);





static inline void SmartSensingM$initDefault(void);
#line 247
static inline  void SmartSensingM$eraseFlash(void);





static inline  result_t SmartSensingM$initTimer$fired(void);
#line 276
static inline  result_t SmartSensingM$StdControl$init(void);
#line 289
static inline  result_t SmartSensingM$StdControl$start(void);
#line 324
static inline  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t type);
#line 346
static inline  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t type, uint16_t rate);
#line 380
static inline  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t type);
#line 400
static inline  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t type, uint8_t channel);
#line 440
static inline  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t type);
#line 457
static inline  uint8_t SmartSensingM$SensingConfig$getEventPriority(uint8_t type);
#line 475
static inline  result_t SmartSensingM$SensingConfig$setEventPriority(uint8_t type, uint8_t priority);
#line 500
static inline  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t type, uint8_t priority);
#line 527
static inline  uint8_t SmartSensingM$SensingConfig$getNodePriority(void);
#line 546
static inline  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t priority);
#line 572
static inline  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t type);
#line 584
static inline  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t type, uint16_t code);
#line 610
static inline  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);





static inline  result_t SmartSensingM$WatchTimer$fired(void);
#line 643
static inline  result_t SmartSensingM$SensingTimer$fired(void);
#line 674
static inline   result_t SmartSensingM$ADC$dataReady(uint8_t client, uint16_t data);
#line 695
static inline  result_t SmartSensingM$GPSSensing$dataReady(uint8_t *data, uint16_t size);
#line 731
static inline result_t SmartSensingM$oversample(uint16_t *data, uint8_t client);
#line 754
static void SmartSensingM$upFlashClient(void);
#line 775
static void SmartSensingM$saveData(uint8_t client, uint16_t data);
#line 840
static void SmartSensingM$setrate(void);
#line 862
static void SmartSensingM$updateMaxBlkNum(void);
#line 888
static __inline uint16_t SmartSensingM$GCD(uint16_t a, uint16_t b);
#line 906
static uint16_t SmartSensingM$calFireInterval(void);
#line 935
static inline bool SmartSensingM$needSample(uint8_t client);
#line 983
static inline void SmartSensingM$trySample(void);
# 50 "/opt/tinyos-1.x/tos/system/LedsC.nc"
uint8_t LedsC$ledsOn;

enum LedsC$__nesc_unnamed4311 {
  LedsC$RED_BIT = 1, 
  LedsC$GREEN_BIT = 2, 
  LedsC$YELLOW_BIT = 4
};
#line 72
static   result_t LedsC$Leds$redOn(void);








static inline   result_t LedsC$Leds$redOff(void);








static   result_t LedsC$Leds$redToggle(void);










static inline   result_t LedsC$Leds$greenOn(void);








static inline   result_t LedsC$Leds$greenOff(void);








static   result_t LedsC$Leds$greenToggle(void);










static inline   result_t LedsC$Leds$yellowOn(void);








static inline   result_t LedsC$Leds$yellowOff(void);








static   result_t LedsC$Leds$yellowToggle(void);
# 54 "/opt/tinyos-1.x/tos/system/RandomLFSR.nc"
uint16_t RandomLFSR$shiftReg;
uint16_t RandomLFSR$initSeed;
uint16_t RandomLFSR$mask;


static inline   result_t RandomLFSR$Random$init(void);










static   uint16_t RandomLFSR$Random$rand(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$WatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 43 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
static   result_t RealTimeM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b6cdd8);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t RealTimeM$ClockControl$init(void);






static  result_t RealTimeM$ClockControl$start(void);
# 6 "/home/xu/oasis/interfaces/GPSGlobalTime.nc"
static   uint32_t RealTimeM$GPSGlobalTime$getGlobalTime(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t RealTimeM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   void RealTimeM$Clock$setInterval(uint32_t arg_0x408ca068);
# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t RealTimeM$Timer$fired(
# 31 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
uint8_t arg_0x40b740d0);
#line 51
 SyncUser_t RealTimeM$clientList[MAX_NUM_CLIENT];

 uint32_t RealTimeM$mState;

 uint32_t RealTimeM$localTime;

 uint32_t RealTimeM$uc_fire_point;

 uint32_t RealTimeM$uc_fire_interval;

 int32_t RealTimeM$adjustInterval;


 uint32_t RealTimeM$adjustCounter;

 int8_t RealTimeM$queue_head;

 int8_t RealTimeM$queue_tail;

 uint8_t RealTimeM$queue_size;

 uint8_t RealTimeM$queue[30];

 uint8_t RealTimeM$syncMode;

 bool RealTimeM$taskBusy;

 bool RealTimeM$is_synced;

 uint32_t RealTimeM$localTime_t;
 bool RealTimeM$init_sync;

 bool RealTimeM$timerBusy;
 uint32_t RealTimeM$timerCount;
 uint32_t RealTimeM$globaltime_t;
 uint32_t RealTimeM$globaltime_tHist;

 bool RealTimeM$realTimeFired;

static  void RealTimeM$signalOneTimer(void);
static inline  void RealTimeM$updateTimer(void);
static inline void RealTimeM$enqueue(uint8_t value);
static inline uint8_t RealTimeM$dequeue(void);

static inline  result_t RealTimeM$StdControl$init(void);
#line 120
static inline  result_t RealTimeM$StdControl$start(void);
#line 182
static  uint32_t RealTimeM$RealTime$getTimeCount(void);
#line 251
static inline  bool RealTimeM$RealTime$isSync(void);










static inline  result_t RealTimeM$RealTime$changeMode(uint8_t modeValue);
#line 276
static inline  uint8_t RealTimeM$RealTime$getMode(void);






static  result_t RealTimeM$RealTime$setTimeCount(uint32_t newCount, uint8_t userMode);
#line 392
static  result_t RealTimeM$Timer$start(uint8_t id, char type, uint32_t interval);
#line 415
static  result_t RealTimeM$Timer$stop(uint8_t id);
#line 429
static inline void RealTimeM$enqueue(uint8_t value);
#line 441
static inline uint8_t RealTimeM$dequeue(void);
#line 457
static inline  result_t RealTimeM$WatchTimer$fired(void);
#line 475
static  void RealTimeM$signalOneTimer(void);
#line 489
static inline  void RealTimeM$updateTimer(void);
#line 613
static   uint32_t RealTimeM$LocalTime$read(void);
#line 634
static inline   result_t RealTimeM$Clock$fire(void);
#line 653
static inline   result_t RealTimeM$Timer$default$fired(uint8_t id);
#line 666
static inline  result_t RealTimeM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void RTCClockM$OSTIrq$enable(void);
#line 45
static   result_t RTCClockM$OSTIrq$allocate(void);
# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
static   result_t RTCClockM$MicroClock$fire(void);
# 28 "/home/xu/oasis/system/platform/imote2/RTC/RTCClockM.nc"
uint8_t RTCClockM$gmInterval;



static inline   void RTCClockM$OSTIrq$fired(void);






static inline  result_t RTCClockM$StdControl$init(void);




static  result_t RTCClockM$StdControl$start(void);
#line 77
static   void RTCClockM$MicroClock$setInterval(uint32_t value);
# 40 "/home/xu/oasis/interfaces/RealTime.nc"
static  result_t GPSSensorM$RealTime$setTimeCount(uint32_t arg_0x40abf6d8, uint8_t arg_0x40abf860);


static  result_t GPSSensorM$RealTime$changeMode(uint8_t arg_0x40abd648);
static  uint8_t GPSSensorM$RealTime$getMode(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t GPSSensorM$LocalTime$read(void);
# 46 "/home/xu/oasis/interfaces/GenericSensing.nc"
static  result_t GPSSensorM$GenericSensing$dataReady(uint8_t *arg_0x40ac8268, uint16_t arg_0x40ac83f8);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t GPSSensorM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GPSSensorM$GPSSerialControl$init(void);






static  result_t GPSSensorM$GPSSerialControl$start(void);
#line 63
static  result_t GPSSensorM$GPIOControl$init(void);






static  result_t GPSSensorM$GPIOControl$start(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GPSSensorM$CheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void GPSSensorM$GPSInterrupt$clear(void);
#line 45
static   void GPSSensorM$GPSInterrupt$enable(uint8_t arg_0x406321d8);
# 57 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
 uint32_t GPSSensorM$pps_arrive_point[SYNC_INTERVAL];

 uint32_t GPSSensorM$timeCount;

 uint32_t GPSSensorM$gLocalTime;

 uint16_t GPSSensorM$dataCount;

 uint16_t GPSSensorM$rawCount;
uint16_t GPSSensorM$raw_payload_length;





 uint8_t *GPSSensorM$RAWData;
 uint8_t *GPSSensorM$NMEAData;




 uint8_t GPSSensorM$AllData[RAW_SIZE + NMEA_SIZE];


 uint8_t GPSSensorM$ppsIndex;

 uint8_t GPSSensorM$last_pps_index;





 bool GPSSensorM$samplingReady;

 bool GPSSensorM$samplingStart;

 bool GPSSensorM$initialized = FALSE;

 bool GPSSensorM$started = FALSE;

 bool GPSSensorM$checkTimerOn;

 bool GPSSensorM$alreadySetTime;

 bool GPSSensorM$hasGPS;

float GPSSensorM$skew;
uint32_t GPSSensorM$localAverage;
int32_t GPSSensorM$offsetAverage;

TimeTable GPSSensorM$table[MAX_ENTRIES];
uint16_t GPSSensorM$tableEntries;


uint16_t GPSSensorM$numEntries;
uint16_t GPSSensorM$adjustTime;

static inline  void GPSSensorM$gpsTask(void);
static  void GPSSensorM$selfCheckTask(void);
static void GPSSensorM$clearTable(void);

static inline void GPSSensorM$initialize(void);
#line 143
static inline  result_t GPSSensorM$StdControl$init(void);









static inline  result_t GPSSensorM$StdControl$start(void);
#line 170
static   uint32_t GPSSensorM$GPSGlobalTime$getGlobalTime(void);









static inline   uint32_t GPSSensorM$GPSGlobalTime$getLocalTime(void);





static   uint32_t GPSSensorM$GPSGlobalTime$local2Global(uint32_t time);
#line 221
static inline  void GPSSensorM$gpsTask(void);









static inline   void GPSSensorM$GPSUartStream$sendDone(uint8_t *buf, 
uint16_t len, result_t error);
#line 245
static inline   void GPSSensorM$GPSUartStream$receivedByte(uint8_t data);
#line 404
static inline   void GPSSensorM$GPSUartStream$receiveDone(uint8_t *buf, 
uint16_t len, result_t error);







static inline   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$sendDone(uint8_t *buf, 
uint16_t len, 
uart_status_t status);







static inline   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$receiveDone(uint8_t *buf, 
uint16_t len, 
uart_status_t status);
#line 476
static inline  void GPSSensorM$debugDevTask(void);
#line 540
static void GPSSensorM$clearTable(void);









static inline void GPSSensorM$addNewEntry(void);
#line 623
static inline  void GPSSensorM$changeModeTask(void);
#line 639
static  void GPSSensorM$selfCheckTask(void);








static inline  result_t GPSSensorM$CheckTimer$fired(void);
#line 680
static inline   void GPSSensorM$GPSInterrupt$fired(void);
#line 751
static inline  result_t GPSSensorM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);
# 89 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialPacket.nc"
static   uint8_t *HalPXA27xBTUARTP$HalPXA27xSerialPacket$receiveDone(uint8_t *arg_0x40bf31a8, uint16_t arg_0x40bf3338, uart_status_t arg_0x40bf34c8);
#line 62
static   uint8_t *HalPXA27xBTUARTP$HalPXA27xSerialPacket$sendDone(uint8_t *arg_0x40bcce68, uint16_t arg_0x40bcb010, uart_status_t arg_0x40bcb1a0);
# 44 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
static   void HalPXA27xBTUARTP$UART$setDLL(uint32_t arg_0x40c21928);
#line 60
static   void HalPXA27xBTUARTP$UART$setMCR(uint32_t arg_0x40c49068);
#line 53
static   uint32_t HalPXA27xBTUARTP$UART$getIIR(void);
#line 47
static   void HalPXA27xBTUARTP$UART$setDLH(uint32_t arg_0x40c20100);
#line 42
static   void HalPXA27xBTUARTP$UART$setTHR(uint32_t arg_0x40c21480);
#line 63
static   uint32_t HalPXA27xBTUARTP$UART$getLSR(void);
#line 55
static   void HalPXA27xBTUARTP$UART$setFCR(uint32_t arg_0x40c4a3d0);
#line 51
static   uint32_t HalPXA27xBTUARTP$UART$getIER(void);
#line 41
static   uint32_t HalPXA27xBTUARTP$UART$getRBR(void);
#line 57
static   void HalPXA27xBTUARTP$UART$setLCR(uint32_t arg_0x40c4a878);
#line 50
static   void HalPXA27xBTUARTP$UART$setIER(uint32_t arg_0x40c208c8);
# 79 "/home/xu/oasis/system/platform/imote2/UART/UartStream.nc"
static   void HalPXA27xBTUARTP$UartStream$receivedByte(uint8_t arg_0x40bd1c28);
#line 99
static   void HalPXA27xBTUARTP$UartStream$receiveDone(uint8_t *arg_0x40bcf920, uint16_t arg_0x40bcfab0, result_t arg_0x40bcfc40);
#line 57
static   void HalPXA27xBTUARTP$UartStream$sendDone(uint8_t *arg_0x40bd2b58, uint16_t arg_0x40bd2ce8, result_t arg_0x40bd2e78);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HalPXA27xBTUARTP$ChanControl$init(void);
# 102 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
uint8_t *HalPXA27xBTUARTP$txCurrentBuf;
#line 102
uint8_t *HalPXA27xBTUARTP$rxCurrentBuf;

uint32_t HalPXA27xBTUARTP$txCurrentLen;
#line 104
uint32_t HalPXA27xBTUARTP$rxCurrentLen;
#line 104
uint32_t HalPXA27xBTUARTP$rxCurrentIdx;

uint32_t HalPXA27xBTUARTP$gulFCRShadow;

uint32_t HalPXA27xBTUARTP$defaultRate = 9600;

bool HalPXA27xBTUARTP$gbUsingUartStreamSendIF = FALSE;
bool HalPXA27xBTUARTP$gbUsingUartStreamRcvIF = FALSE;
bool HalPXA27xBTUARTP$gbRcvByteEvtEnabled = TRUE;



static inline  result_t HalPXA27xBTUARTP$SerialControl$init(void);
#line 147
static inline  result_t HalPXA27xBTUARTP$SerialControl$start(void);
#line 228
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$send(uint8_t *buf, uint16_t len);
#line 287
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$receive(uint8_t *buf, uint16_t len, uint16_t timeout);
#line 339
static inline void HalPXA27xBTUARTP$DispatchStreamRcvSignal(void);
#line 356
static inline void HalPXA27xBTUARTP$DispatchStreamSendSignal(void);
#line 395
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialCntl$configPort(uint32_t baudrate, 
uint8_t databits, 
uart_parity_t parity, 
uint8_t stopbits, 
bool flow_cntl);
#line 460
static inline   void HalPXA27xBTUARTP$UART$interruptUART(void);
# 81 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
static   void HplPXA27xBTUARTP$UART$interruptUART(void);
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void HplPXA27xBTUARTP$UARTIrq$enable(void);
#line 45
static   result_t HplPXA27xBTUARTP$UARTIrq$allocate(void);
# 57 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
bool HplPXA27xBTUARTP$m_fInit = FALSE;

uint32_t HplPXA27xBTUARTP$base_addr = 0x40200000;

static inline  result_t HplPXA27xBTUARTP$UControl$init(void);
#line 94
static inline   uint32_t HplPXA27xBTUARTP$UART$getRBR(void);
static inline   void HplPXA27xBTUARTP$UART$setTHR(uint32_t val);

static inline   void HplPXA27xBTUARTP$UART$setDLL(uint32_t val);
#line 109
static inline   void HplPXA27xBTUARTP$UART$setDLH(uint32_t val);
#line 121
static inline   void HplPXA27xBTUARTP$UART$setIER(uint32_t val);
static inline   uint32_t HplPXA27xBTUARTP$UART$getIER(void);
static inline   uint32_t HplPXA27xBTUARTP$UART$getIIR(void);
static inline   void HplPXA27xBTUARTP$UART$setFCR(uint32_t val);
static inline   void HplPXA27xBTUARTP$UART$setLCR(uint32_t val);

static inline   void HplPXA27xBTUARTP$UART$setMCR(uint32_t val);

static inline   uint32_t HplPXA27xBTUARTP$UART$getLSR(void);
#line 141
static inline   void HplPXA27xBTUARTP$UARTIrq$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t SNMSM$EReportControl$init(void);






static  result_t SNMSM$EReportControl$start(void);
#line 63
static  result_t SNMSM$WDTControl$init(void);






static  result_t SNMSM$WDTControl$start(void);
# 48 "/opt/tinyos-1.x/tos/interfaces/WDT.nc"
static  void SNMSM$WWDT$reset(void);
#line 45
static  result_t SNMSM$WWDT$start(int32_t arg_0x40cb0b70);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t SNMSM$Leds$greenToggle(void);
#line 131
static   result_t SNMSM$Leds$yellowToggle(void);
#line 81
static   result_t SNMSM$Leds$redToggle(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t SNMSM$SNMSTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t SNMSM$SNMSTimer$stop(void);
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
#line 187
static inline  result_t SNMSM$SNMSTimer$fired(void);
#line 280
static inline  void SNMSM$restart(void);
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  result_t EventReportM$EventReport$eventSendDone(
# 56 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
uint8_t arg_0x40d0b508, 
# 47 "/home/xu/oasis/lib/SNMS/EventReport.nc"
TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t EventReportM$EventSend$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
#line 106
static  void *EventReportM$EventSend$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38);
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
static  uint8_t EventReportM$EventReport$eventSend(uint8_t eventType, uint8_t type, 
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
# 42 "build/imote2/RpcM.nc"
static  void RpcM$SNMSM_restart(void);
#line 39
static  ramSymbol_t RpcM$RamSymbolsM_peek(unsigned int arg_0x40d33b48, uint8_t arg_0x40d33cd0, bool arg_0x40d33e60);
# 2 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setSink(bool arg_0x40d34010);

static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$releaseParent(void);
#line 3
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setParent(uint16_t arg_0x40d344b8);


static  uint16_t RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval(void);
#line 5
static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x40d34c68);
# 35 "/home/xu/oasis/interfaces/SensingConfig.nc"
static  result_t RpcM$SmartSensingM_SensingConfig$setDataPriority(uint8_t arg_0x4099f010, uint8_t arg_0x4099f1a0);

static  uint8_t RpcM$SmartSensingM_SensingConfig$getDataPriority(uint8_t arg_0x4099f638);
#line 31
static  result_t RpcM$SmartSensingM_SensingConfig$setADCChannel(uint8_t arg_0x409a04c8, uint8_t arg_0x409a0650);
#line 49
static  uint8_t RpcM$SmartSensingM_SensingConfig$getEventPriority(uint8_t arg_0x409be4b0);
#line 27
static  result_t RpcM$SmartSensingM_SensingConfig$setSamplingRate(uint8_t arg_0x409a19e0, uint16_t arg_0x409a1b78);





static  uint8_t RpcM$SmartSensingM_SensingConfig$getADCChannel(uint8_t arg_0x409a0ae8);
#line 29
static  uint16_t RpcM$SmartSensingM_SensingConfig$getSamplingRate(uint8_t arg_0x409a0030);
#line 47
static  result_t RpcM$SmartSensingM_SensingConfig$setEventPriority(uint8_t arg_0x409bfe20, uint8_t arg_0x409be010);
#line 43
static  result_t RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(uint8_t arg_0x409bf348, uint16_t arg_0x409bf4d8);
#line 39
static  result_t RpcM$SmartSensingM_SensingConfig$setNodePriority(uint8_t arg_0x4099fad8);





static  uint16_t RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(uint8_t arg_0x409bf980);
#line 41
static  uint8_t RpcM$SmartSensingM_SensingConfig$getNodePriority(void);
# 40 "build/imote2/RpcM.nc"
static  unsigned int RpcM$RamSymbolsM_poke(ramSymbol_t *arg_0x40d36380);
#line 34
static  uint8_t RpcM$GenericCommProM_getRFChannel(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t RpcM$ResponseSend$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
#line 106
static  void *RpcM$ResponseSend$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38);
# 36 "build/imote2/RpcM.nc"
static  result_t RpcM$GenericCommProM_setRFChannel(uint8_t arg_0x40d3d970);




static  result_t RpcM$SNMSM_ledsOn(uint8_t arg_0x40d36820);


static  void RpcM$SmartSensingM_eraseFlash(void);
#line 35
static  uint8_t RpcM$GenericCommProM_getRFPower(void);
# 47 "/home/xu/oasis/lib/SNMS/EventConfig.nc"
static  uint8_t RpcM$EventReportM_EventConfig$getReportLevel(uint8_t arg_0x40cae5d0);
#line 38
static  result_t RpcM$EventReportM_EventConfig$setReportLevel(uint8_t arg_0x40cb1e50, uint8_t arg_0x40cae010);
# 37 "build/imote2/RpcM.nc"
static  result_t RpcM$GenericCommProM_setRFPower(uint8_t arg_0x40d3de18);
#line 50
TOS_Msg RpcM$cmdStore;
TOS_Msg RpcM$sendMsgBuf;
TOS_MsgPtr RpcM$sendMsgPtr;

uint16_t RpcM$cmdStoreLength;


bool RpcM$processingCommand;



bool RpcM$taskBusy;

uint8_t RpcM$seqno;

uint16_t RpcM$debugSequenceNo;

static const uint8_t RpcM$args_sizes[28] = { 
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
sizeof(uint8_t ), 
0, 
sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint8_t ), 
sizeof(uint8_t ), 
sizeof(uint8_t ) + sizeof(uint16_t ), 
sizeof(uint8_t ) + sizeof(uint16_t ), 
0 };


static const uint8_t RpcM$return_sizes[28] = { 
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
sizeof(uint8_t ), 
sizeof(uint16_t ), 
sizeof(uint16_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(result_t ), 
sizeof(void ) };


static inline  result_t RpcM$StdControl$init(void);
#line 142
static inline  result_t RpcM$StdControl$start(void);






static void RpcM$tryNextSend(void);
static inline  void RpcM$sendResponse(void);

static inline  void RpcM$processCommand(void);
#line 647
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr pMsg, void *payload, uint16_t payloadLength);
#line 743
static void RpcM$tryNextSend(void);






static inline  void RpcM$sendResponse(void);
#line 795
static inline  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr pMsg, result_t success);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr GenericCommProM$ReceiveMsg$receive(
# 71 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40d923e0, 
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
TOS_MsgPtr arg_0x40620878);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$ActivityTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t GenericCommProM$Intercept$intercept(TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$UARTSend$send(TOS_MsgPtr arg_0x40615d50);
# 41 "/opt/tinyos-1.x/tos/interfaces/PowerManagement.nc"
static   uint8_t GenericCommProM$PowerManagement$adjustPower(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t GenericCommProM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$RadioControl$init(void);






static  result_t GenericCommProM$RadioControl$start(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacControl.nc"
static   void GenericCommProM$MacControl$enableAck(void);
# 111 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  void GenericCommProM$restart(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t GenericCommProM$TimerControl$init(void);






static  result_t GenericCommProM$TimerControl$start(void);
#line 63
static  result_t GenericCommProM$UARTControl$init(void);






static  result_t GenericCommProM$UARTControl$start(void);
# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t GenericCommProM$Leds$greenToggle(void);
# 58 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t GenericCommProM$RadioSend$send(TOS_MsgPtr arg_0x40615d50);
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t GenericCommProM$SendMsg$sendDone(
# 70 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
uint8_t arg_0x40d90c78, 
# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0);
# 33 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
static  result_t GenericCommProM$FlashManager$write(uint32_t arg_0x40ab7c08, void *arg_0x40ab7da8, uint16_t arg_0x40adc010);
# 185 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static  uint8_t GenericCommProM$CC2420Control$GetRFPower(void);
#line 178
static  result_t GenericCommProM$CC2420Control$SetRFPower(uint8_t arg_0x4095df20);
#line 84
static  result_t GenericCommProM$CC2420Control$TunePreset(uint8_t arg_0x40940010);
#line 106
static  uint8_t GenericCommProM$CC2420Control$GetPreset(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t GenericCommProM$MonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 120 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
bool GenericCommProM$sendTaskBusy;
bool GenericCommProM$recvTaskBusy;








#line 123
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
#line 251
static inline  bool GenericCommProM$Control$start(void);
#line 296
static  result_t GenericCommProM$SendMsg$send(uint8_t id, uint16_t addr, uint8_t len, TOS_MsgPtr msg);
#line 333
static inline  result_t GenericCommProM$ActivityTimer$fired(void);







static inline  result_t GenericCommProM$MonitorTimer$fired(void);
#line 361
static inline  result_t GenericCommProM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);




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
static inline  result_t GenericCommProM$initRFChannel(uint8_t channel);









static inline  result_t GenericCommProM$setRFChannel(uint8_t channel);








static inline  result_t GenericCommProM$setRFPower(uint8_t level);






static inline  uint8_t GenericCommProM$getRFChannel(void);



static inline  uint8_t GenericCommProM$getRFPower(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopLQI$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t MultiHopLQI$Random$rand(void);
# 6 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopLQI$MultihopCtrl$readyToSend(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t MultiHopLQI$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
static  bool MultiHopLQI$NeighborCtrl$addChild(uint16_t arg_0x40e1ddf0, uint16_t arg_0x40e1c010, bool arg_0x40e1c1a0);







static  bool MultiHopLQI$NeighborCtrl$setCost(uint16_t arg_0x40e1bc70, uint16_t arg_0x40e1be00);
#line 4
static  bool MultiHopLQI$NeighborCtrl$changeParent(uint16_t *arg_0x40e1fc48, uint16_t *arg_0x40e1fdf8, uint16_t *arg_0x40e1d010);
static  bool MultiHopLQI$NeighborCtrl$setParent(uint16_t arg_0x40e1d4c0);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopLQI$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
# 91 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
enum MultiHopLQI$__nesc_unnamed4312 {




  MultiHopLQI$TOS_BASE_ADDRESS = 0, 



  MultiHopLQI$BASE_STATION_ADDRESS = 0, 




  MultiHopLQI$BEACON_PERIOD = 10, 





  MultiHopLQI$BEACON_TIMEOUT = 6
};


enum MultiHopLQI$__nesc_unnamed4313 {
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
uint16_t MultiHopLQI$gRecentPacketSender[45];
int16_t MultiHopLQI$gRecentPacketSeqNo[45];

uint8_t MultiHopLQI$gRecentOriginIndex;
uint16_t MultiHopLQI$gRecentOriginPacketSender[45];
int16_t MultiHopLQI$gRecentOriginPacketSeqNo[45];
uint8_t MultiHopLQI$gRecentOriginPacketTTL[45];

bool MultiHopLQI$localBeSink;
uint16_t MultiHopLQI$gbLinkQuality;

static uint16_t MultiHopLQI$adjustLQI(uint8_t val);





static  void MultiHopLQI$SendRouteTask(void);
#line 190
static inline  void MultiHopLQI$TimerTask(void);
#line 225
static inline  result_t MultiHopLQI$StdControl$init(void);
#line 270
static inline  result_t MultiHopLQI$StdControl$start(void);
#line 286
static inline  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr Msg, uint8_t id, 
uint8_t resend);
#line 347
static inline  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr Msg, uint8_t id);
#line 360
static inline  uint16_t MultiHopLQI$RouteControl$getParent(void);



static inline  uint16_t MultiHopLQI$RouteControl$getQuality(void);
#line 382
static inline  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t Interval);









static inline  result_t MultiHopLQI$RouteControl$setParent(uint16_t parentAddr);










static inline  result_t MultiHopLQI$RouteControl$releaseParent(void);
#line 426
static inline  bool MultiHopLQI$RouteControl$isSink(void);


static inline  result_t MultiHopLQI$Timer$fired(void);
#line 441
static inline  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr Msg);
#line 535
static inline  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr pMsg, result_t success);





static inline  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);





static inline  result_t MultiHopLQI$MultihopCtrl$switchParent(void);
#line 570
static inline  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect);









static inline  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool enable);
#line 614
static inline  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t parentAddr);





static inline  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void);





static inline  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t seconds);





static inline  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void);
# 39 "/home/xu/oasis/lib/RamSymbols/RamSymbolsM.nc"
ramSymbol_t RamSymbolsM$symbol;

static inline  unsigned int RamSymbolsM$poke(ramSymbol_t *p_symbol);
#line 53
static inline  ramSymbol_t RamSymbolsM$peek(unsigned int memAddress, uint8_t length, bool dereference);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t WDTM$TimerControl$init(void);






static  result_t WDTM$TimerControl$start(void);
# 50 "/opt/tinyos-1.x/tos/system/WDTM.nc"
static  void WDTM$reset(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t WDTM$WDTControl$init(void);






static  result_t WDTM$WDTControl$start(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t WDTM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 57 "/opt/tinyos-1.x/tos/system/WDTM.nc"
int32_t WDTM$increment;
int32_t WDTM$remaining;

enum WDTM$__nesc_unnamed4314 {
  WDTM$WDT_LATENCY = 500
};



static inline  result_t WDTM$StdControl$init(void);






static inline  result_t WDTM$StdControl$start(void);
#line 87
static inline  result_t WDTM$Timer$fired(void);
#line 99
static inline  result_t WDTM$WDT$start(int32_t interval);








static inline  void WDTM$WDT$reset(void);
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdog.nc"
static  void HPLWatchdogM$PXA27XWatchdog$init(void);
#line 70
static  void HPLWatchdogM$PXA27XWatchdog$feedWDT(uint32_t arg_0x408a78a8);
#line 61
static  void HPLWatchdogM$PXA27XWatchdog$enableWDT(uint32_t arg_0x408a7340);
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLWatchdogM.nc"
static inline  result_t HPLWatchdogM$StdControl$init(void);




static inline  result_t HPLWatchdogM$StdControl$start(void);









static inline  void HPLWatchdogM$reset(void);
# 42 "/home/xu/oasis/interfaces/RealTime.nc"
static  bool TimeSyncM$RealTime$isSync(void);
#line 40
static  result_t TimeSyncM$RealTime$setTimeCount(uint32_t arg_0x40abf6d8, uint8_t arg_0x40abf860);



static  uint8_t TimeSyncM$RealTime$getMode(void);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t TimeSyncM$LocalTime$read(void);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t TimeSyncM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 6 "/home/xu/oasis/interfaces/GPSGlobalTime.nc"
static   uint32_t TimeSyncM$GPSGlobalTime$getGlobalTime(void);
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
static  result_t TimeSyncM$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
# 39 "/home/xu/oasis/interfaces/TimeStamping.nc"
static  result_t TimeSyncM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40e93010, uint32_t *arg_0x40e931c8);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t TimeSyncM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 77 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
enum TimeSyncM$__nesc_unnamed4315 {






  TimeSyncM$MAX_ENTRIES = 8, 





  TimeSyncM$BEACON_RATE = 5, 









  TimeSyncM$ROOT_TIMEOUT = 6, 








  TimeSyncM$IGNORE_ROOT_MSG = 4, 







  TimeSyncM$ENTRY_VALID_LIMIT = 4, 







  TimeSyncM$ENTRY_SEND_LIMIT = 4, 





  TimeSyncM$ENTRY_THROWOUT_LIMIT = 100
};
#line 151
#line 146
typedef struct TimeSyncM$TableItem {

  uint16_t state;
  uint32_t localTime;
  int32_t timeOffset;
} TimeSyncM$TableItem;

enum TimeSyncM$__nesc_unnamed4316 {
  TimeSyncM$ENTRY_EMPTY = 0, 
  TimeSyncM$ENTRY_FULL = 1
};
enum TimeSyncM$__nesc_unnamed4317 {
  TimeSyncM$ERROR_TIMES = 3, 
  TimeSyncM$GPS_VALID = 3
};

TimeSyncM$TableItem TimeSyncM$table[TimeSyncM$MAX_ENTRIES];
uint16_t TimeSyncM$tableEntries;

enum TimeSyncM$__nesc_unnamed4318 {
  TimeSyncM$STATE_IDLE = 0x00, 
  TimeSyncM$STATE_PROCESSING = 0x01, 
  TimeSyncM$STATE_SENDING = 0x02, 
  TimeSyncM$STATE_INIT = 0x04
};

uint16_t TimeSyncM$state;
#line 172
uint16_t TimeSyncM$mode;
uint16_t TimeSyncM$alreadySetTime;
uint16_t TimeSyncM$errTimes;
uint16_t TimeSyncM$hasGPSValid;
#line 187
float TimeSyncM$skew;
uint32_t TimeSyncM$localAverage;
int32_t TimeSyncM$offsetAverage;
uint16_t TimeSyncM$numEntries;

uint16_t TimeSyncM$missedSendStamps;
#line 192
uint16_t TimeSyncM$missedReceiveStamps;

TOS_Msg TimeSyncM$processedMsgBuffer;
TOS_MsgPtr TimeSyncM$processedMsg;

TOS_Msg TimeSyncM$outgoingMsgBuffer;


uint16_t TimeSyncM$heartBeats;

uint16_t TimeSyncM$rootid;

static inline   uint32_t TimeSyncM$GlobalTime$getLocalTime(void);








static result_t TimeSyncM$is_synced(void);




static inline   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *time);
#line 231
static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *time);
#line 250
static inline void TimeSyncM$calculateConversion(void);
#line 311
static void TimeSyncM$clearTable(void);








static inline void TimeSyncM$addNewEntry(TimeSyncMsg *msg);
#line 438
static inline  result_t TimeSyncM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);



static inline void  TimeSyncM$processMsg(void);
#line 538
static inline  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr p);
#line 600
static void TimeSyncM$adjustRootID(void);
#line 653
static  void TimeSyncM$sendMsg(void);
#line 722
static inline  result_t TimeSyncM$SendMsg$sendDone(TOS_MsgPtr ptr, result_t success);
#line 747
static inline void TimeSyncM$timeSyncMsgSend(void);
#line 782
static inline  result_t TimeSyncM$Timer$fired(void);
#line 835
static inline  result_t TimeSyncM$StdControl$init(void);
#line 868
static inline  result_t TimeSyncM$StdControl$start(void);
#line 902
static inline   void TimeSyncM$TimeSyncNotify$default$msg_received(void);
static inline   void TimeSyncM$TimeSyncNotify$default$msg_sent(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$SplitControl$initDone(void);
#line 85
static  result_t CC2420RadioM$SplitControl$startDone(void);
# 59 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t CC2420RadioM$FIFOP$disable(void);
#line 43
static   result_t CC2420RadioM$FIFOP$startWait(bool arg_0x40959bc8);
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0x40f16428);



static   bool CC2420RadioM$BackoffTimerJiffy$isSet(void);
#line 8
static   result_t CC2420RadioM$BackoffTimerJiffy$stop(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t CC2420RadioM$Random$rand(void);
#line 57
static   result_t CC2420RadioM$Random$init(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CC2420RadioM$TimerControl$init(void);






static  result_t CC2420RadioM$TimerControl$start(void);
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0x40620878);
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
static   uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0x40956010);
#line 47
static   uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0x40957408);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658);
# 60 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t CC2420RadioM$SFD$disable(void);
#line 43
static   result_t CC2420RadioM$SFD$enableCapture(bool arg_0x40f1fd70);
# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
static   void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658);
# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0x40f1dd70, uint8_t *arg_0x40f1df18);
#line 19
static   result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0x40f1d558, uint8_t *arg_0x40f1d700);
# 206 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
static   result_t CC2420RadioM$CC2420Control$enableAddrDecode(void);
#line 192
static   result_t CC2420RadioM$CC2420Control$enableAutoAck(void);
#line 163
static   result_t CC2420RadioM$CC2420Control$RxMode(void);
# 74 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
static   int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0x40f2a8f0);
static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0x40f2adb0);
# 64 "/opt/tinyos-1.x/tos/interfaces/SplitControl.nc"
static  result_t CC2420RadioM$CC2420SplitControl$init(void);
#line 77
static  result_t CC2420RadioM$CC2420SplitControl$start(void);
# 76 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
enum CC2420RadioM$__nesc_unnamed4319 {
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
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$FIFOP_GPIOInt$clear(void);
#line 46
static   void HPLCC2420M$FIFOP_GPIOInt$disable(void);
#line 45
static   void HPLCC2420M$FIFOP_GPIOInt$enable(uint8_t arg_0x406321d8);
# 53 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
static   result_t HPLCC2420M$CaptureSFD$captured(uint16_t arg_0x40f18368);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t HPLCC2420M$GPIOControl$init(void);






static  result_t HPLCC2420M$GPIOControl$start(void);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$CCA_GPIOInt$clear(void);
#line 46
static   void HPLCC2420M$CCA_GPIOInt$disable(void);
#line 45
static   void HPLCC2420M$CCA_GPIOInt$enable(uint8_t arg_0x406321d8);
# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
static   result_t HPLCC2420M$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0x40f1cc58, uint8_t *arg_0x40f1ce00);
#line 39
static   result_t HPLCC2420M$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0x40f1c4e8, uint8_t *arg_0x40f1c690);
# 49 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0x40954010, uint8_t arg_0x40954198, uint8_t *arg_0x40954340);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420M$InterruptFIFOP$fired(void);
#line 51
static   result_t HPLCC2420M$InterruptCCA$fired(void);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void HPLCC2420M$FIFO_GPIOInt$clear(void);
#line 46
static   void HPLCC2420M$FIFO_GPIOInt$disable(void);
static   void HPLCC2420M$SFD_GPIOInt$clear(void);
#line 46
static   void HPLCC2420M$SFD_GPIOInt$disable(void);
#line 45
static   void HPLCC2420M$SFD_GPIOInt$enable(uint8_t arg_0x406321d8);
# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
static   result_t HPLCC2420M$InterruptFIFO$fired(void);
# 74 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
uint8_t HPLCC2420M$gbDMAChannelInitDone;
bool HPLCC2420M$gbIgnoreTxDMA;
bool HPLCC2420M$gRadioOpInProgress;

uint8_t *HPLCC2420M$rxbuf;
uint8_t *HPLCC2420M$txbuf;
uint8_t *HPLCC2420M$txrambuf;

uint8_t HPLCC2420M$txlen;
uint8_t HPLCC2420M$rxlen;
uint8_t HPLCC2420M$txramlen;


uint16_t HPLCC2420M$txramaddr;








static inline  result_t HPLCC2420M$StdControl$init(void);
#line 136
static inline  result_t HPLCC2420M$StdControl$start(void);
#line 166
static result_t HPLCC2420M$getSSPPort(void);
#line 180
static result_t HPLCC2420M$releaseSSPPort(void);
#line 198
static inline  void HPLCC2420M$HPLCC2420CmdReleaseError(void);



static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr);
#line 237
static inline  void HPLCC2420M$HPLCC2420WriteContentionError(void);



static inline  void HPLCC2420M$HPLCC2420WriteError(void);



static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data);
#line 282
static inline  void HPLCC2420M$HPLCC2420ReadContentionError(void);



static inline  void HPLCC2420M$HPLCC2420ReadReleaseError(void);








static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr);
#line 422
static inline  void HPLCC2420M$signalRAMWr(void);
#line 435
static inline  void HPLCC2420M$HPLCC2420RAMWriteContentionError(void);


static inline  void HPLCC2420M$HPLCC2420RamWriteReleaseError(void);



static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t length, uint8_t *buffer);
#line 494
static  void HPLCC2420M$signalRXFIFO(void);








static inline  void HPLCC2420M$HPLCC2420FIFOReadRxFifoContentionError(void);


static inline  void HPLCC2420M$HPLCC2420FifoReadRxFifoReleaseError(void);
#line 520
static inline   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t length, uint8_t *data);
#line 665
static  void HPLCC2420M$signalTXFIFO(void);








static inline  void HPLCC2420M$HPLCC2420FifoWriteTxFifoContentioError(void);


static inline  void HPLCC2420M$HPLCC2420FifoWriteTxFifoReleaseError(void);
#line 689
static inline   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t length, uint8_t *data);
#line 777
static   result_t HPLCC2420M$InterruptFIFOP$startWait(bool low_to_high);
#line 807
static inline   result_t HPLCC2420M$InterruptCCA$startWait(bool low_to_high);
#line 822
static   result_t HPLCC2420M$CaptureSFD$enableCapture(bool low_to_high);
#line 841
static inline   result_t HPLCC2420M$InterruptFIFOP$disable(void);





static inline   result_t HPLCC2420M$InterruptFIFO$disable(void);





static inline   result_t HPLCC2420M$InterruptCCA$disable(void);





static inline   result_t HPLCC2420M$CaptureSFD$disable(void);





static inline   void HPLCC2420M$FIFOP_GPIOInt$fired(void);










static inline   void HPLCC2420M$FIFO_GPIOInt$fired(void);










static inline   void HPLCC2420M$CCA_GPIOInt$fired(void);









static inline   void HPLCC2420M$SFD_GPIOInt$fired(void);










static inline  result_t HPLCC2420M$RxDMAChannel$requestChannelDone(void);




static inline   void HPLCC2420M$RxDMAChannel$startInterrupt(void);



static inline   void HPLCC2420M$RxDMAChannel$stopInterrupt(uint16_t numbBytesSent);



static inline   void HPLCC2420M$RxDMAChannel$eorInterrupt(uint16_t numBytesSent);



static inline  void HPLCC2420M$HPLCC2420RxDMAEndInterruptReleaseError(void);



static inline   void HPLCC2420M$RxDMAChannel$endInterrupt(uint16_t numBytesSent);
#line 944
static inline  result_t HPLCC2420M$TxDMAChannel$requestChannelDone(void);




static inline   void HPLCC2420M$TxDMAChannel$startInterrupt(void);



static inline   void HPLCC2420M$TxDMAChannel$stopInterrupt(uint16_t numbBytesSent);



static inline   void HPLCC2420M$TxDMAChannel$eorInterrupt(uint16_t numBytesSent);



static inline  void HPLCC2420M$HPLCC2420TxDmaEndInterrupt(void);


static inline   void HPLCC2420M$TxDMAChannel$endInterrupt(uint16_t numBytesSent);
#line 989
static inline    result_t HPLCC2420M$InterruptFIFO$default$fired(void);
# 12 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$fired(void);
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   result_t TimerJiffyAsyncM$OSTIrq$allocate(void);
# 17 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
uint32_t TimerJiffyAsyncM$jiffy;
bool TimerJiffyAsyncM$bSet;

static void TimerJiffyAsyncM$StartTimer(uint32_t interval);










static inline  result_t TimerJiffyAsyncM$StdControl$init(void);







static inline  result_t TimerJiffyAsyncM$StdControl$start(void);
#line 58
static inline   void TimerJiffyAsyncM$OSTIrq$fired(void);
#line 81
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy);
#line 98
static inline   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void);






static inline   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void);
# 52 "/home/xu/oasis/lib/SmartSensing/Flash.nc"
static  result_t FlashManagerM$Flash$read(uint32_t arg_0x40ad0120, uint8_t *arg_0x40ad02c8, uint32_t arg_0x40ad0460);
#line 28
static  result_t FlashManagerM$Flash$erase(uint32_t arg_0x40ad11d8);
#line 19
static  result_t FlashManagerM$Flash$write(uint32_t arg_0x40ad3868, uint8_t *arg_0x40ad3a10, uint32_t arg_0x40ad3ba8);
#line 54
static  void FlashManagerM$Flash$setFlashPartitionState(uint32_t arg_0x40ad0ad8);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t FlashManagerM$EraseTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 62 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static  result_t FlashManagerM$initRFChannel(uint8_t arg_0x41041bc8);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t FlashManagerM$WritingTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t FlashManagerM$WritingTimer$stop(void);
#line 59
static  result_t FlashManagerM$EraseCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 69 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
 bool FlashManagerM$writeTaskBusy;

 bool FlashManagerM$alreadyStart;

 uint16_t FlashManagerM$eraseTimerCount;



Queue_t FlashManagerM$flashQueue;

 uint16_t FlashManagerM$FlashFlag;
 uint32_t FlashManagerM$ProgID;
uint16_t FlashManagerM$RFChannel;

 FlashClient_t FlashManagerM$buffer_fw;

 SensorClient_t FlashManagerM$sensor_I[MAX_SENSOR_NUM];
uint16_t FlashManagerM$numToWrite;

static  void FlashManagerM$writeTask(void);
static inline  void FlashManagerM$eraseTask(void);

extern uint8_t __Flash_Erase(uint32_t addr) __attribute((noinline))   ;
extern uint8_t __GetEraseStatus(uint32_t addr) __attribute((noinline))   ;
extern uint8_t __EraseFlashSpin(uint32_t addr) __attribute((noinline))   ;





static inline void FlashManagerM$initialize(void);
#line 115
static inline  result_t FlashManagerM$StdControl$init(void);










static inline  result_t FlashManagerM$StdControl$start(void);
#line 146
static inline  result_t FlashManagerM$FlashManager$init(void);
#line 215
static  void FlashManagerM$writeTask(void);
#line 244
static inline  void FlashManagerM$eraseTask(void);
#line 285
static  result_t FlashManagerM$FlashManager$write(uint32_t addr, void *data, uint16_t numBytes);
#line 321
static  result_t FlashManagerM$FlashManager$read(uint32_t addr, uint8_t *data, uint16_t numBytes);
#line 353
static inline  result_t FlashManagerM$EraseTimer$fired(void);







static inline  result_t FlashManagerM$WritingTimer$fired(void);
#line 373
static inline  result_t FlashManagerM$EraseCheckTimer$fired(void);
# 26 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static uint16_t FlashM$unlock(uint32_t addr);




static uint16_t FlashM$writeHelper(uint32_t addr, uint8_t *data, uint32_t numBytes, 
uint8_t prebyte, uint8_t postbyte);
static void FlashM$writeExitHelper(uint32_t addr, uint32_t numBytes);

uint8_t FlashM$FlashPartitionState[16];
uint8_t FlashM$init = 0;
#line 36
uint8_t FlashM$programBufferSupported = 2;
extern uint8_t __Flash_Erase(uint32_t addr) __attribute((noinline))   ;
extern uint8_t __GetEraseStatus(uint32_t addr) __attribute((noinline))   ;
extern uint8_t __EraseFlashSpin(uint32_t addr) __attribute((noinline))   ;

extern uint8_t __Flash_Program_Word(uint32_t addr, uint16_t word) __attribute((noinline))   ;
extern uint8_t __Flash_Program_Buffer(uint32_t addr, uint16_t *data, uint8_t datalen) __attribute((noinline))   ;




static inline  result_t FlashM$StdControl$init(void);
#line 74
static inline  result_t FlashM$StdControl$start(void);







static uint16_t FlashM$writeHelper(uint32_t addr, uint8_t *data, uint32_t numBytes, 
uint8_t prebyte, uint8_t postbyte);
#line 165
static void FlashM$writeExitHelper(uint32_t addr, uint32_t numBytes);







static  result_t FlashM$Flash$write(uint32_t addr, uint8_t *data, uint32_t numBytes);
#line 326
static inline  void FlashM$Flash$setFlashPartitionState(uint32_t addr);





static inline  result_t FlashM$Flash$erase(uint32_t addr);
#line 399
static inline  result_t FlashM$Flash$read(uint32_t addr, uint8_t *data, uint32_t numBytes);
#line 430
static uint16_t FlashM$unlock(uint32_t addr) __attribute((noinline)) ;
# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
static  TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878);
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t FramerM$ByteComm$txByte(uint8_t arg_0x410abc98);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t FramerM$ByteControl$init(void);






static  result_t FramerM$ByteControl$start(void);
# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
static  result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8);
# 75 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x410a64c8, uint8_t arg_0x410a6650);
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
static  TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0x40620878);
# 88 "/opt/tinyos-1.x/tos/interfaces/TokenReceiveMsg.nc"
static  result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x410a6cf8);
# 72 "/opt/tinyos-1.x/tos/system/FramerAckM.nc"
uint8_t FramerAckM$gTokenBuf;

static inline  void FramerAckM$SendAckTask(void);




static inline  TOS_MsgPtr FramerAckM$TokenReceiveMsg$receive(TOS_MsgPtr Msg, uint8_t token);
#line 91
static inline  TOS_MsgPtr FramerAckM$ReceiveMsg$receive(TOS_MsgPtr Msg);
# 63 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
static   result_t UARTM$HPLUART$init(void);
#line 89
static   result_t UARTM$HPLUART$put(uint8_t arg_0x411118c0);
# 83 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
static   result_t UARTM$ByteComm$txDone(void);
#line 75
static   result_t UARTM$ByteComm$txByteReady(bool arg_0x410a3b30);
#line 66
static   result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0x410a3200, bool arg_0x410a3388, uint16_t arg_0x410a3520);
# 58 "/opt/tinyos-1.x/tos/system/UARTM.nc"
bool UARTM$state;

static inline  result_t UARTM$Control$init(void);







static inline  result_t UARTM$Control$start(void);








static inline   result_t UARTM$HPLUART$get(uint8_t data);









static inline   result_t UARTM$HPLUART$putDone(void);
#line 110
static   result_t UARTM$ByteComm$txByte(uint8_t data);
# 97 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
static   result_t HPLFFUARTM$UART$get(uint8_t arg_0x41111e58);







static   result_t HPLFFUARTM$UART$putDone(void);
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
static   void HPLFFUARTM$Interrupt$disable(void);
#line 46
static   void HPLFFUARTM$Interrupt$enable(void);
#line 45
static   result_t HPLFFUARTM$Interrupt$allocate(void);
# 62 "/opt/tinyos-1.x/tos/platform/imote2/HPLFFUARTM.nc"
uint8_t HPLFFUARTM$baudrate = UART_BAUD_115200;

static inline   void HPLFFUARTM$Interrupt$fired(void);
#line 90
static inline void HPLFFUARTM$setBaudRate(uint8_t rate);
#line 148
static inline   result_t HPLFFUARTM$UART$init(void);
#line 214
static inline   result_t HPLFFUARTM$UART$put(uint8_t data);
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
static   uint32_t ClockTimeStampingM$LocalTime$read(void);
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
static   result_t ClockTimeStampingM$HPLCC2420RAM$write(uint16_t arg_0x40955710, uint8_t arg_0x40955898, uint8_t *arg_0x40955a40);
# 26 "/home/xu/oasis/lib/FTSP/TimeSync/ClockTimeStampingM.nc"
uint32_t ClockTimeStampingM$rcv_time;
TOS_MsgPtr ClockTimeStampingM$rcv_message;
enum ClockTimeStampingM$__nesc_unnamed4324 {
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
static  result_t DataMgmtM$BatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
#line 59
static  result_t DataMgmtM$SysCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t DataMgmtM$SysCheckTimer$stop(void);
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t DataMgmtM$Send$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
#line 106
static  void *DataMgmtM$Send$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t DataMgmtM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 61 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void DataMgmtM$restart(void);
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
#line 157
static inline  result_t DataMgmtM$StdControl$init(void);
#line 169
static inline  result_t DataMgmtM$StdControl$start(void);
#line 190
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t client);
#line 227
static  result_t DataMgmtM$DataMgmt$freeBlk(void *obj);
#line 262
static inline  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t type);
#line 305
static  result_t DataMgmtM$DataMgmt$saveBlk(void *obj, uint8_t mediumType);
#line 329
static inline  result_t DataMgmtM$BatchTimer$fired(void);
#line 352
static inline  result_t DataMgmtM$SysCheckTimer$fired(void);
#line 379
static inline  result_t DataMgmtM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);
#line 398
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr pMsg, result_t success);
#line 425
static inline  void DataMgmtM$sendTask(void);
#line 472
static inline result_t DataMgmtM$insertAndStartSend(TOS_MsgPtr msg);
#line 488
static result_t DataMgmtM$tryNextSend(void);
#line 508
static  void DataMgmtM$presendTask(void);
#line 601
static  void DataMgmtM$processTask(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t ADCM$ClockControl$init(void);






static  result_t ADCM$ClockControl$start(void);
# 54 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
static  result_t ADCM$PMIC$getBatteryVoltage(uint8_t *arg_0x404bdee0);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t ADCM$InternalControl$init(void);






static  result_t ADCM$InternalControl$start(void);
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
static   result_t ADCM$ADC$dataReady(
# 34 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
uint8_t arg_0x411da910, 
# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
uint16_t arg_0x40aa6cc0);
# 54 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
 
#line 50
struct ADCM$reading {

  uint16_t data;
  uint8_t id;
} ADCM$reading[40];

 uint8_t ADCM$dataindex = 0;
 uint8_t ADCM$channel[MAX_SENSOR_NUM];
 bool ADCM$taskBusy;
 bool ADCM$initialized = FALSE;

 int8_t ADCM$queue_head;
 int8_t ADCM$queue_tail;
 uint8_t ADCM$queue_size;
 uint8_t ADCM$queue[40];
 uint16_t ADCM$time_flag;


static inline uint16_t ADCM$readADC(uint8_t addr);

static inline  result_t ADCM$StdControl$init(void);







static inline  result_t ADCM$StdControl$start(void);
#line 90
static  result_t ADCM$ADCControl$init(void);
#line 121
static  result_t ADCM$ADCControl$bindPort(uint8_t port, uint8_t adcPort);










static inline void ADCM$enqueue(uint8_t value);










static inline uint8_t ADCM$dequeue(void);
#line 159
static  void ADCM$signalOneSensor(void);










static   result_t ADCM$ADC$getData(uint8_t client);
#line 190
static inline uint16_t ADCM$readADC(uint8_t actrualPort);
#line 240
static inline   result_t ADCM$Clock$fire(void);





static inline  result_t ADCM$Timer$fired(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t NeighborMgmtM$Random$rand(void);
# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  result_t NeighborMgmtM$CascadeControl$addDirectChild(address_t arg_0x4121abb0);
static  result_t NeighborMgmtM$CascadeControl$deleteDirectChild(address_t arg_0x41218088);
static  result_t NeighborMgmtM$CascadeControl$parentChanged(address_t arg_0x41218530);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t NeighborMgmtM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 22 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
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
#line 105
static inline  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr msg, void *payload, uint16_t payloadLen);
#line 121
static inline uint8_t NeighborMgmtM$findEntry(uint16_t id);









static inline void NeighborMgmtM$newEntry(uint8_t indes, uint16_t id);
#line 149
static uint8_t NeighborMgmtM$findPreparedIndex(uint16_t id);
#line 165
static inline uint8_t NeighborMgmtM$findEntryToBeReplaced(void);
#line 183
static inline  void NeighborMgmtM$timerTask(void);



static inline void NeighborMgmtM$updateTable(void);
#line 232
static uint16_t NeighborMgmtM$adjustLQI(uint8_t val);





static inline  bool NeighborMgmtM$NeighborCtrl$changeParent(uint16_t *newParent, uint16_t *parentCost, uint16_t *linkEst);
#line 270
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t parent);
#line 286
static  bool NeighborMgmtM$NeighborCtrl$clearParent(bool reset);
#line 302
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect);
#line 384
static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t addr, uint16_t parentCost);
#line 410
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void);
#line 444
static inline  uint8_t NeighborMgmtM$writeNbrLinkInfo(uint8_t *start, uint8_t maxlen);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopEngineM$RouteStatusTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 71 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteSelect.nc"
static  result_t MultiHopEngineM$RouteSelect$selectRoute(TOS_MsgPtr arg_0x40df7270, uint8_t arg_0x40df73f8, uint8_t arg_0x40df7580);
#line 86
static  result_t MultiHopEngineM$RouteSelect$initializeFields(TOS_MsgPtr arg_0x40df7b90, uint8_t arg_0x40df7d18);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Intercept$intercept(
# 22 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x41310200, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
# 116 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
static  bool MultiHopEngineM$RouteSelectCntl$isSink(void);
#line 84
static  uint16_t MultiHopEngineM$RouteSelectCntl$getQuality(void);
#line 49
static  uint16_t MultiHopEngineM$RouteSelectCntl$getParent(void);
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
static  result_t MultiHopEngineM$Snoop$intercept(
# 23 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413107e0, 
# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t MultiHopEngineM$Send$sendDone(
# 20 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
uint8_t arg_0x413114b8, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
static  uint8_t MultiHopEngineM$EventReport$eventSend(uint8_t arg_0x409b7ab0, 
uint8_t arg_0x409b7c48, 
uint8_t *arg_0x409b7e00);
# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
static  result_t MultiHopEngineM$MultihopCtrl$addChild(uint16_t arg_0x40df3928, uint16_t arg_0x40df3ac0, bool arg_0x40df3c50);
#line 2
static  result_t MultiHopEngineM$MultihopCtrl$switchParent(void);
# 42 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static  void MultiHopEngineM$restart(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t MultiHopEngineM$SubControl$init(void);






static  result_t MultiHopEngineM$SubControl$start(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
static   result_t MultiHopEngineM$Leds$redToggle(void);
#line 64
static   result_t MultiHopEngineM$Leds$redOn(void);
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
static  result_t MultiHopEngineM$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t MultiHopEngineM$MonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
# 57 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
#line 50
typedef struct MultiHopEngineM$SendQueueEntryInfo {
  uint8_t valid;
  uint8_t AMID;
  uint8_t resend;
  uint16_t length;
  TOS_MsgPtr msgPtr;
  TOS_MsgPtr originalTOSPtr;
} MultiHopEngineM$SendQueueEntryInfo;

enum MultiHopEngineM$__nesc_unnamed4325 {
  MultiHopEngineM$NETWORKMSG_HEADER_LENGTH = 10, 
  MultiHopEngineM$SUCCESSIVE_TRANSMITE_FAILURE_THRESHOLD = 15, 
  MultiHopEngineM$ROUTE_STATUS_CHECK_PERIOD = 10 * 1024, 

  MultiHopEngineM$WDT_UPDATE_PERIOD = 10, 
  MultiHopEngineM$WDT_UPDATE_UNIT = 1024 * 60
};
bool MultiHopEngineM$sendTaskBusy;
TinyDWFQ_t MultiHopEngineM$sendQueue;
Queue_t MultiHopEngineM$buffQueue;
TOS_Msg MultiHopEngineM$poolBuffer[40];
MultiHopEngineM$SendQueueEntryInfo MultiHopEngineM$queueEntryInfo[40];
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
#line 111
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
#line 154
static  result_t MultiHopEngineM$Send$send(uint8_t AMID, TOS_MsgPtr msg, uint16_t length);
#line 181
static  void *MultiHopEngineM$Send$getBuffer(uint8_t AMID, TOS_MsgPtr msg, uint16_t *length);
#line 193
static inline  void MultiHopEngineM$sendTask(void);
#line 266
static inline  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr msg, result_t success);
#line 349
static result_t MultiHopEngineM$insertAndStartSend(TOS_MsgPtr msg, 
uint16_t AMID, 
uint16_t length, 
TOS_MsgPtr originalTOSPtr);
#line 422
static result_t MultiHopEngineM$tryNextSend(void);
#line 441
static inline  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr msg);
#line 501
static inline  result_t MultiHopEngineM$MonitorTimer$fired(void);
#line 518
static inline  result_t MultiHopEngineM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success);




static inline  result_t MultiHopEngineM$RouteStatusTimer$fired(void);
#line 543
static inline  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void);
#line 555
static inline result_t MultiHopEngineM$checkForDuplicates(TOS_MsgPtr msg, bool disable);
#line 582
static inline  uint16_t MultiHopEngineM$RouteControl$getParent(void);



static inline  uint16_t MultiHopEngineM$RouteControl$getQuality(void);
#line 633
static inline uint8_t MultiHopEngineM$allocateInfoEntry(void);










static uint8_t MultiHopEngineM$findInfoEntry(TOS_MsgPtr pMsg);
#line 657
static result_t MultiHopEngineM$freeInfoEntry(uint8_t ind);
#line 672
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
uint8_t arg_0x413687d8, 
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$DTTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
#line 59
static  result_t CascadesRouterM$RTTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t CascadesRouterM$RTTimer$stop(void);
#line 59
static  result_t CascadesRouterM$DelayTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t CascadesRouterM$DelayTimer$stop(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
static   uint16_t CascadesRouterM$Random$rand(void);
# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
static  result_t CascadesRouterM$SubControl$init(void);
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
static  TOS_MsgPtr CascadesRouterM$Receive$receive(
# 36 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
uint8_t arg_0x41369c38, 
# 81 "/opt/tinyos-1.x/tos/interfaces/Receive.nc"
TOS_MsgPtr arg_0x409b8068, void *arg_0x409b8208, uint16_t arg_0x409b83a0);
# 2 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
static  uint16_t CascadesRouterM$CascadeControl$getParent(void);
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
static  result_t CascadesRouterM$ResetTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);








static  result_t CascadesRouterM$ResetTimer$stop(void);
#line 59
static  result_t CascadesRouterM$ACKTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10);
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
static  result_t CascadesRouterM$CascadeControl$parentChanged(address_t newParent);
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
uint8_t arg_0x414016a8, 
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0);
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
static  result_t CascadesEngineM$MySend$sendDone(
# 36 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
uint8_t arg_0x41402e60, 
# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8);
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
# 54 "/opt/tinyos-1.x/tos/platform/imote2/DVFS.nc"
inline static  result_t HPLInitM$DVFS$SwitchCoreFreq(uint32_t arg_0x4044bac0, uint32_t arg_0x4044bc58){
#line 54
  unsigned char result;
#line 54

#line 54
  result = DVFSM$DVFS$SwitchCoreFreq(arg_0x4044bac0, arg_0x4044bc58);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 184 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_MAKE_RADIO_CCA_INPUT(void)
#line 184
{
#line 184
  {
#line 184
    * (volatile uint32_t *)(0x40E0000C + (116 < 96 ? ((116 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (116 < 96 ? ((116 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (116 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (116 < 96 ? ((116 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (116 & 0x1f));
#line 184
    * (volatile uint32_t *)(0x40E00054 + ((116 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((116 & 0x7f) >> 4) * 4) & ~(3 << (116 & 0xf) * 2)) | (0 << (116 & 0xf) * 2);
  }
#line 184
  ;
#line 184
  * (volatile uint32_t *)(0x40E0000C + (116 < 96 ? ((116 & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (116 & 0x1f));
}

#line 186
static __inline void TOSH_MAKE_CC_SFD_INPUT(void)
#line 186
{
#line 186
  {
#line 186
    * (volatile uint32_t *)(0x40E0000C + (16 < 96 ? ((16 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (16 < 96 ? ((16 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (16 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (16 < 96 ? ((16 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (16 & 0x1f));
#line 186
    * (volatile uint32_t *)(0x40E00054 + ((16 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((16 & 0x7f) >> 4) * 4) & ~(3 << (16 & 0xf) * 2)) | (0 << (16 & 0xf) * 2);
  }
#line 186
  ;
#line 186
  * (volatile uint32_t *)(0x40E0000C + (16 < 96 ? ((16 & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (16 & 0x1f));
}

#line 183
static __inline void TOSH_MAKE_CC_FIFO_INPUT(void)
#line 183
{
#line 183
  {
#line 183
    * (volatile uint32_t *)(0x40E0000C + (114 < 96 ? ((114 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (114 < 96 ? ((114 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (114 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (114 < 96 ? ((114 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (114 & 0x1f));
#line 183
    * (volatile uint32_t *)(0x40E00054 + ((114 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((114 & 0x7f) >> 4) * 4) & ~(3 << (114 & 0xf) * 2)) | (0 << (114 & 0xf) * 2);
  }
#line 183
  ;
#line 183
  * (volatile uint32_t *)(0x40E0000C + (114 < 96 ? ((114 & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (114 & 0x1f));
}

#line 185
static __inline void TOSH_MAKE_CC_FIFOP_INPUT(void)
#line 185
{
#line 185
  {
#line 185
    * (volatile uint32_t *)(0x40E0000C + (0 < 96 ? ((0 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (0 < 96 ? ((0 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (0 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (0 < 96 ? ((0 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (0 & 0x1f));
#line 185
    * (volatile uint32_t *)(0x40E00054 + ((0 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((0 & 0x7f) >> 4) * 4) & ~(3 << (0 & 0xf) * 2)) | (0 << (0 & 0xf) * 2);
  }
#line 185
  ;
#line 185
  * (volatile uint32_t *)(0x40E0000C + (0 < 96 ? ((0 & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (0 & 0x1f));
}

#line 187
static __inline void TOSH_MAKE_CC_CSN_OUTPUT(void)
#line 187
{
#line 187
  {
#line 187
    * (volatile uint32_t *)(0x40E0000C + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (39 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (39 & 0x1f));
#line 187
    * (volatile uint32_t *)(0x40E00054 + ((39 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((39 & 0x7f) >> 4) * 4) & ~(3 << (39 & 0xf) * 2)) | (0 << (39 & 0xf) * 2);
  }
#line 187
  ;
#line 187
  * (volatile uint32_t *)(0x40E0000C + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (39 & 0x1f);
}

#line 187
static __inline void TOSH_SET_CC_CSN_PIN(void)
#line 187
{
#line 187
  * (volatile uint32_t *)(0x40E00018 + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (39 & 0x1f);
}

#line 181
static __inline void TOSH_MAKE_CC_VREN_OUTPUT(void)
#line 181
{
#line 181
  {
#line 181
    * (volatile uint32_t *)(0x40E0000C + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (115 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (115 & 0x1f));
#line 181
    * (volatile uint32_t *)(0x40E00054 + ((115 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((115 & 0x7f) >> 4) * 4) & ~(3 << (115 & 0xf) * 2)) | (0 << (115 & 0xf) * 2);
  }
#line 181
  ;
#line 181
  * (volatile uint32_t *)(0x40E0000C + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (115 & 0x1f);
}

#line 181
static __inline void TOSH_CLR_CC_VREN_PIN(void)
#line 181
{
#line 181
  * (volatile uint32_t *)(0x40E00024 + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (115 & 0x1f);
}

#line 182
static __inline void TOSH_MAKE_CC_RSTN_OUTPUT(void)
#line 182
{
#line 182
  {
#line 182
    * (volatile uint32_t *)(0x40E0000C + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (22 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (22 & 0x1f));
#line 182
    * (volatile uint32_t *)(0x40E00054 + ((22 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((22 & 0x7f) >> 4) * 4) & ~(3 << (22 & 0xf) * 2)) | (0 << (22 & 0xf) * 2);
  }
#line 182
  ;
#line 182
  * (volatile uint32_t *)(0x40E0000C + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (22 & 0x1f);
}

#line 182
static __inline void TOSH_CLR_CC_RSTN_PIN(void)
#line 182
{
#line 182
  * (volatile uint32_t *)(0x40E00024 + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (22 & 0x1f);
}






static inline void TOSH_SET_PIN_DIRECTIONS(void )
{

  * (volatile uint32_t *)0x40F00004 = (1 << 5) | (1 << 4);
  TOSH_CLR_CC_RSTN_PIN();
  TOSH_MAKE_CC_RSTN_OUTPUT();
  TOSH_CLR_CC_VREN_PIN();
  TOSH_MAKE_CC_VREN_OUTPUT();
  TOSH_SET_CC_CSN_PIN();
  TOSH_MAKE_CC_CSN_OUTPUT();
  TOSH_MAKE_CC_FIFOP_INPUT();
  TOSH_MAKE_CC_FIFO_INPUT();
  TOSH_MAKE_CC_SFD_INPUT();
  TOSH_MAKE_RADIO_CCA_INPUT();
}

# 89 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLInitM.nc"
static inline  result_t HPLInitM$init(void)
#line 89
{
  * (volatile uint32_t *)0x41300004 = (((1 << 22) | (1 << 20)) | (1 << 15)) | (1 << 9);
  * (volatile uint32_t *)0x41300008 = 1 << 1;

  while ((* (volatile uint32_t *)0x41300008 & 1) == 0) ;

  TOSH_SET_PIN_DIRECTIONS();
  initqueue(&paramtaskQueue, defaultQueueSize);




  * (volatile uint32_t *)0x48000064 = (1 & 0x3) << 12;
  * (volatile uint32_t *)0x48000008 = ((* (volatile uint32_t *)0x48000008 | (1 << 3)) | (1 << 15)) | 2;
  * (volatile uint32_t *)0x4800000C = * (volatile uint32_t *)0x4800000C | (1 << 3);
  * (volatile uint32_t *)0x48000010 = * (volatile uint32_t *)0x48000010 | (1 << 3);


  * (volatile uint32_t *)0x48000014 = 0;
#line 120
  * (volatile uint32_t *)0x48000000 = 0x0B002BCC;






  initMMU();
  enableICache();
  initSyncFlash();
  enableDCache();
#line 142
  HPLInitM$DVFS$SwitchCoreFreq(13, 13);


  return SUCCESS;
}

# 47 "/opt/tinyos-1.x/tos/system/RealMain.nc"
inline static  result_t RealMain$hardwareInit(void){
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
# 51 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
inline static  result_t DVFSM$PMIC$setCoreVoltage(uint8_t arg_0x404bd718){
#line 51
  unsigned char result;
#line 51

#line 51
  result = PMICM$PMIC$setCoreVoltage(arg_0x404bd718);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 99 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static __inline void PMICM$TOSH_MAKE_PMIC_TXON_OUTPUT(void)
#line 99
{
#line 99
  {
#line 99
    * (volatile uint32_t *)(0x40E0000C + (108 < 96 ? ((108 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (108 < 96 ? ((108 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (108 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (108 < 96 ? ((108 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (108 & 0x1f));
#line 99
    * (volatile uint32_t *)(0x40E00054 + ((108 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((108 & 0x7f) >> 4) * 4) & ~(3 << (108 & 0xf) * 2)) | (0 << (108 & 0xf) * 2);
  }
#line 99
  ;
#line 99
  * (volatile uint32_t *)(0x40E0000C + (108 < 96 ? ((108 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (108 & 0x1f);
}

#line 99
static __inline void PMICM$TOSH_CLR_PMIC_TXON_PIN(void)
#line 99
{
#line 99
  * (volatile uint32_t *)(0x40E00024 + (108 < 96 ? ((108 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (108 & 0x1f);
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t PMICM$GPIOIRQControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = PXA27XGPIOIntM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 320 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static inline   result_t PXA27XInterruptM$PXA27XIrq$allocate(uint8_t id)
{
  return PXA27XInterruptM$allocate(id, FALSE, TOSH_IRP_TABLE[id]);
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t PXA27XGPIOIntM$GPIOIrq0$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(8);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   result_t PXA27XGPIOIntM$GPIOIrq1$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(9);
#line 45

#line 45
  return result;
#line 45
}
#line 45
inline static   result_t PXA27XGPIOIntM$GPIOIrq$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(10);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 51 "/opt/tinyos-1.x/tos/system/NoLeds.nc"
static inline   result_t NoLeds$Leds$init(void)
#line 51
{
  return SUCCESS;
}

# 56 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t PMICM$Leds$init(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = NoLeds$Leds$init();
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t PMICM$PI2CInterrupt$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(6);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 65 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static inline int PXA27XUSBClientM$DynQueue_getLength(PXA27XUSBClientM$DynQueue oDynQueue)



{

  if (oDynQueue == (void *)0) {
    return 0;
    }
#line 73
  return oDynQueue->iLength;
}

# 522 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$sendReport(uint8_t *data, uint32_t datalen, uint8_t type, uint8_t source, uint8_t channel)
#line 522
{
  PXA27XUSBClientM$USBdata InStream;
  uint8_t statetemp;
#line 524
  uint8_t InTaskTemp;
  PXA27XUSBClientM$DynQueue QueueTemp;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 527
    statetemp = PXA27XUSBClientM$state;
#line 527
    __nesc_atomic_end(__nesc_atomic); }

  if (statetemp != 3) {
    return;
    }




  if ((* (volatile uint32_t *)0x40600104 & (1 << (1 & 0x1f))) != 0) {
    * (volatile uint32_t *)0x40600104 |= 1 << (1 & 0x1f);
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 539
    {
      InStream = (PXA27XUSBClientM$USBdata )safe_malloc(sizeof(PXA27XUSBClientM$USBdata_t ));

      InStream->channel = channel;
      InStream->endpointDR = (volatile unsigned long *const )0x40600304;
      InStream->fifosize = PXA27XUSBClientM$Device.oConfigurations[1]->oInterfaces[0]->oEndpoints[0]->wMaxPacketSize;
      InStream->pindex = InStream->index = 0;
      InStream->type = type;
      InStream->source = source;
      InStream->len = datalen;
      InStream->src = data;
      InStream->param = (uint8_t *)1;
    }
#line 551
    __nesc_atomic_end(__nesc_atomic); }

  if (datalen <= 15871) {
      InStream->type |= 0 << 2;
      InStream->n = (uint8_t )(datalen / 62);
      InStream->tlen = InStream->n * InStream->fifosize + 3 + 
      datalen % 62;
    }
  else {
#line 559
    if (datalen <= 3997695) {
        InStream->type |= 1 << 2;
        InStream->n = (uint16_t )(datalen / 61);
        InStream->tlen = InStream->n * InStream->fifosize + 4 + 
        datalen % 61;
      }
    else {
#line 565
      if (datalen <= 0xFFFFFFFF) {
          InStream->type |= 2 << 2;
          InStream->n = datalen / 61;
          InStream->tlen = InStream->n * InStream->fifosize + 6 + 
          datalen % 59;
        }
      else {
        }
      }
    }
#line 574
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 574
    InTaskTemp = PXA27XUSBClientM$InTask;
#line 574
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 575
    QueueTemp = PXA27XUSBClientM$InQueue;
#line 575
    __nesc_atomic_end(__nesc_atomic); }
  PXA27XUSBClientM$DynQueue_enqueue(QueueTemp, InStream);
  if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) == 1 && InTaskTemp == 0) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 578
        PXA27XUSBClientM$InTask = 1;
#line 578
        __nesc_atomic_end(__nesc_atomic); }
      TOS_post(PXA27XUSBClientM$sendIn);
    }
}

#line 389
static inline  result_t PXA27XUSBClientM$SendJTPacket$send(uint8_t channel, uint8_t *data, uint32_t numBytes, uint8_t type)
#line 389
{
  uint8_t statetemp;

#line 391
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 391
    statetemp = PXA27XUSBClientM$state;
#line 391
    __nesc_atomic_end(__nesc_atomic); }
  if (statetemp != 3) {
    return FAIL;
    }
#line 394
  PXA27XUSBClientM$sendReport(data, numBytes, type, 1, channel);
  return SUCCESS;
}

# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
inline static  result_t BluSHM$USBSend$send(uint8_t *arg_0x406141a8, uint32_t arg_0x40614340, uint8_t arg_0x406144c8){
#line 20
  unsigned char result;
#line 20

#line 20
  result = PXA27XUSBClientM$SendJTPacket$send(0U, arg_0x406141a8, arg_0x40614340, arg_0x406144c8);
#line 20

#line 20
  return result;
#line 20
}
#line 20
# 90 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
inline static void BluSHM$DynQueue_shiftgrow(BluSHM$DynQueue oDynQueue)




{

  if (oDynQueue == (void *)0) {
    return;
    }
  if (oDynQueue->index > 2 && oDynQueue->index > oDynQueue->iPhysLength / 8) {
      memmove((void *)oDynQueue->ppvQueue, (void *)(oDynQueue->ppvQueue + oDynQueue->index), sizeof(void *) * oDynQueue->iLength);
      oDynQueue->index = 0;
    }
  else {
      oDynQueue->iPhysLength *= 2;
      oDynQueue->ppvQueue = (const void **)safe_realloc(oDynQueue->ppvQueue, 
      sizeof(void *) * oDynQueue->iPhysLength);
    }
}

# 301 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  void PMICM$printWritePMICSlaveAddressError(void)
#line 301
{
  trace(DBG_USR1, "FATAL ERROR:  writePMIC() Unable to write slave address\r\n");
}

#line 119
static inline void PMICM$returnPI2CBus(void)
#line 119
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 120
    {
      PMICM$accessingPMIC = FALSE;
    }
#line 122
    __nesc_atomic_end(__nesc_atomic); }
}

#line 305
static inline  void PMICM$printWritePMICRegisterAddressError(void)
#line 305
{
  trace(DBG_USR1, "FATAL ERROR:  writePMIC() Unable to write target register address\r\n");
}

static inline  void PMICM$printWritePMICWriteError(void)
#line 309
{
  trace(DBG_USR1, "FATAL ERROR:  writePMIC() Unable to write value\r\n");
}

# 101 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPotC.nc"
static inline  result_t HPLPotC$Pot$finalise(void)
#line 101
{




  return SUCCESS;
}

# 74 "/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$finalise(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = HPLPotC$Pot$finalise();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 90 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPotC.nc"
static inline  result_t HPLPotC$Pot$increase(void)
#line 90
{







  return SUCCESS;
}

# 67 "/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$increase(void){
#line 67
  unsigned char result;
#line 67

#line 67
  result = HPLPotC$Pot$increase();
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 79 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPotC.nc"
static inline  result_t HPLPotC$Pot$decrease(void)
#line 79
{







  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/HPLPot.nc"
inline static  result_t PotM$HPLPot$decrease(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = HPLPotC$Pot$decrease();
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 93 "/opt/tinyos-1.x/tos/system/PotM.nc"
static inline void PotM$setPot(uint8_t value)
#line 93
{
  uint8_t i;

#line 95
  for (i = 0; i < 151; i++) 
    PotM$HPLPot$decrease();

  for (i = 0; i < value; i++) 
    PotM$HPLPot$increase();

  PotM$HPLPot$finalise();

  PotM$potSetting = value;
}

static inline  result_t PotM$Pot$init(uint8_t initialSetting)
#line 106
{
  PotM$setPot(initialSetting);
  return SUCCESS;
}

# 78 "/opt/tinyos-1.x/tos/interfaces/Pot.nc"
inline static  result_t RealMain$Pot$init(uint8_t arg_0x40426ac0){
#line 78
  unsigned char result;
#line 78

#line 78
  result = PotM$Pot$init(arg_0x40426ac0);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 88 "/opt/tinyos-1.x/tos/platform/imote2/sched.c"
static inline void TOSH_sched_init(void )
{
  int i;

#line 91
  sys_task_bitmask = TOSH_TASK_BITMASK;
  sys_max_tasks = TOSH_MAX_TASKS;
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

# 44 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  result_t NeighborMgmtM$StdControl$init(void)
#line 44
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
# 55 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdogM.nc"
static inline  void PXA27XWatchdogM$PXA27XWatchdog$init(void)
#line 55
{
  PXA27XWatchdogM$resetMoteRequest = FALSE;
}

# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdog.nc"
inline static  void HPLWatchdogM$PXA27XWatchdog$init(void){
#line 52
  PXA27XWatchdogM$PXA27XWatchdog$init();
#line 52
}
#line 52
# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLWatchdogM.nc"
static inline  result_t HPLWatchdogM$StdControl$init(void)
#line 52
{
  HPLWatchdogM$PXA27XWatchdog$init();
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t WDTM$WDTControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HPLWatchdogM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
inline static  result_t WDTM$TimerControl$init(void){
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
# 66 "/opt/tinyos-1.x/tos/system/WDTM.nc"
static inline  result_t WDTM$StdControl$init(void)
#line 66
{
  result_t ok1 = WDTM$TimerControl$init();
  result_t ok2 = WDTM$WDTControl$init();

#line 69
  WDTM$increment = 0;
#line 69
  WDTM$remaining = 1;
  return rcombine(ok1, ok2);
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$WDTControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = WDTM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 129 "build/imote2/RpcM.nc"
static inline  result_t RpcM$StdControl$init(void)
#line 129
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










  SNMSM$WDTControl$init();



  SNMSM$EReportControl$init();
  SNMSM$rstdelayCount = 0;
  SNMSM$toBeRestart = FALSE;
  return SUCCESS;
}

# 835 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$StdControl$init(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 837
    {
      TimeSyncM$skew = 0.0;
      TimeSyncM$localAverage = 0;
      TimeSyncM$offsetAverage = 0;
    }
#line 841
    __nesc_atomic_end(__nesc_atomic); }
#line 841
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
#line 863
    TimeSyncM$missedSendStamps = TimeSyncM$missedReceiveStamps = 0;
#line 863
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

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HPLCC2420M$GPIOControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = PXA27XGPIOIntM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 96 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  result_t HPLCC2420M$StdControl$init(void)
#line 96
{

  {
#line 98
    * (volatile uint32_t *)(0x40E0000C + (34 < 96 ? ((34 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (34 < 96 ? ((34 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (34 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (34 < 96 ? ((34 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (34 & 0x1f));
#line 98
    * (volatile uint32_t *)(0x40E00054 + ((34 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((34 & 0x7f) >> 4) * 4) & ~(3 << (34 & 0xf) * 2)) | (3 << (34 & 0xf) * 2);
  }
#line 98
  ;
  {
#line 99
    * (volatile uint32_t *)(0x40E0000C + (35 < 96 ? ((35 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (35 < 96 ? ((35 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (35 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (35 < 96 ? ((35 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (35 & 0x1f));
#line 99
    * (volatile uint32_t *)(0x40E00054 + ((35 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((35 & 0x7f) >> 4) * 4) & ~(3 << (35 & 0xf) * 2)) | (3 << (35 & 0xf) * 2);
  }
#line 99
  ;
  {
#line 100
    * (volatile uint32_t *)(0x40E0000C + (41 < 96 ? ((41 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (41 < 96 ? ((41 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (41 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (41 < 96 ? ((41 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (41 & 0x1f));
#line 100
    * (volatile uint32_t *)(0x40E00054 + ((41 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((41 & 0x7f) >> 4) * 4) & ~(3 << (41 & 0xf) * 2)) | (3 << (41 & 0xf) * 2);
  }
#line 100
  ;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 103
    {



      HPLCC2420M$gbDMAChannelInitDone = 0;

      HPLCC2420M$gRadioOpInProgress = FALSE;
    }
#line 110
    __nesc_atomic_end(__nesc_atomic); }
#line 131
  HPLCC2420M$GPIOControl$init();

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HPLCC2420M$StdControl$init();
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
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t TimerJiffyAsyncM$OSTIrq$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(7);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 31 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static inline  result_t TimerJiffyAsyncM$StdControl$init(void)
{

  TimerJiffyAsyncM$OSTIrq$allocate();
  * (volatile uint32_t *)0x40A000C8 = ((1 << 7) | (1 << 3)) | (0x4 & 0x7);
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
# 176 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  bool GenericCommProM$Control$init(void)
#line 176
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
#line 219
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

# 225 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$StdControl$init(void)
#line 225
{
  int n;

  MultiHopLQI$gRecentIndex = 0;
  for (n = 0; n < 45; n++) {
      MultiHopLQI$gRecentPacketSender[n] = TOS_BCAST_ADDR;
      MultiHopLQI$gRecentPacketSeqNo[n] = 0;
    }

  MultiHopLQI$gRecentOriginIndex = 0;
  for (n = 0; n < 45; n++) {
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
#line 250
    MultiHopLQI$msgBufBusy = FALSE;
#line 250
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
# 85 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline void MultiHopEngineM$initialize(void)
{
  uint8_t ind;

#line 88
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
  for (ind = 0; ind < 40; ind++) {
      MultiHopEngineM$queueEntryInfo[ind].valid = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].AMID = 0;
      MultiHopEngineM$queueEntryInfo[ind].resend = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].length = 0;
      MultiHopEngineM$queueEntryInfo[ind].originalTOSPtr = (void *)0;
      MultiHopEngineM$queueEntryInfo[ind].msgPtr = (void *)0;
    }
}

# 228 "/home/xu/oasis/system/TinyDWFQ.h"
static inline void initializeVirtualQueue(TinyDWFQPtr queue)
{
  uint8_t i;

#line 231
  for (i = 0; i < NUM_VIRTUAL_QUEUES; i++) 
    {
      queue->virtualQueues[i][VQ_TAIL] = queue->virtualQueues[i][VQ_HEAD] = -1;
      queue->numOfElements_VQ[i] = 0;
      queue->numOfElements_VQ_Processing[i] = 0;
      switch (i) 
        {
          case 0: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_0_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_0_FREE_TAIL;
          queue->element[VQ_0_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_0;
          break;
          case 1: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_1_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_1_FREE_TAIL;
          queue->element[VQ_1_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_1;
          break;
          case 2: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_2_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_2_FREE_TAIL;
          queue->element[VQ_2_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_2;
          break;
          case 3: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_3_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_3_FREE_TAIL;
          queue->element[VQ_3_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_3;
          break;
          case 4: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_4_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_4_FREE_TAIL;
          queue->element[VQ_4_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_4;
          break;
          case 5: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_5_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_5_FREE_TAIL;
          queue->element[VQ_5_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_5;
          break;
          case 6: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_6_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_6_FREE_TAIL;
          queue->element[VQ_6_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_6;
          break;
          case 7: queue->virtualQueues[i][VQ_FREE_HEAD] = VQ_7_FREE_HEAD;
          queue->virtualQueues[i][VQ_FREE_TAIL] = VQ_7_FREE_TAIL;
          queue->element[VQ_7_FREE_TAIL].next = -1;
          queue->maxNumOfElementPerVQ[i] = MAX_VQ_7;
          break;
        }
    }
}

#line 165
static inline result_t init_TinyDWFQ(TinyDWFQPtr queue, uint8_t size)
{
  int8_t i;
#line 167
  int8_t vqIndex;

  if (size > TINYDWFQ_SIZE || size <= 0) 
    {
      ;
      return FAIL;
    }

  queue->size = size;
  queue->total = 0;


  queue->head[FREE_TINYDWFQ] = 0;
  queue->tail[FREE_TINYDWFQ] = queue->size - 1;
  queue->head[PENDING_TINYDWFQ] = queue->tail[PENDING_TINYDWFQ] = -1;
  queue->head[PROCESSING_TINYDWFQ] = queue->tail[PROCESSING_TINYDWFQ] = -1;
  queue->head[NOT_ACKED_TINYDWFQ] = queue->tail[NOT_ACKED_TINYDWFQ] = -1;

  queue->numOfElements_pending = 0;
  queue->numOfElements_processing = 0;
  queue->numOfElements_notAcked = 0;

  vqIndex = 1;
  for (i = 0; i < size; i++) 
    {
      queue->element[i].status = FREE_TINYDWFQ;
      queue->element[i].obj = (void *)0;
      queue->element[i].retry = 0;
      queue->element[i].priority = 0;
      queue->element[i].qos = -1;


      if (VQ_0_FREE_HEAD <= i && i <= VQ_0_FREE_TAIL) {
        queue->element[i].vqIndex = 0;
        }
      else {
#line 201
        if (VQ_1_FREE_HEAD <= i && i <= VQ_1_FREE_TAIL) {
          queue->element[i].vqIndex = 1;
          }
        else {
#line 203
          if (VQ_2_FREE_HEAD <= i && i <= VQ_2_FREE_TAIL) {
            queue->element[i].vqIndex = 2;
            }
          else {
#line 205
            if (VQ_3_FREE_HEAD <= i && i <= VQ_3_FREE_TAIL) {
              queue->element[i].vqIndex = 3;
              }
            else {
#line 207
              if (VQ_4_FREE_HEAD <= i && i <= VQ_4_FREE_TAIL) {
                queue->element[i].vqIndex = 4;
                }
              else {
#line 209
                if (VQ_5_FREE_HEAD <= i && i <= VQ_5_FREE_TAIL) {
                  queue->element[i].vqIndex = 5;
                  }
                else {
#line 211
                  if (VQ_6_FREE_HEAD <= i && i <= VQ_6_FREE_TAIL) {
                    queue->element[i].vqIndex = 6;
                    }
                  else {
#line 213
                    if (VQ_7_FREE_HEAD <= i && i <= VQ_7_FREE_TAIL) {
                      queue->element[i].vqIndex = 7;
                      }
                    }
                  }
                }
              }
            }
          }
        }
#line 216
      queue->element[i].prev = i - 1;
      if (i == size - 1) {
        queue->element[i].next = -1;
        }
      else {
#line 220
        queue->element[i].next = i + 1;
        }
    }
  initializeVirtualQueue(queue);

  return SUCCESS;
}

# 121 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$StdControl$init(void)
{
  init_TinyDWFQ(&MultiHopEngineM$sendQueue, 40);
  initBufferPool(&MultiHopEngineM$buffQueue, 40, &MultiHopEngineM$poolBuffer[0]);
  MultiHopEngineM$initialize();
  return MultiHopEngineM$SubControl$init();
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t RTCClockM$OSTIrq$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(7);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 39 "/home/xu/oasis/system/platform/imote2/RTC/RTCClockM.nc"
static inline  result_t RTCClockM$StdControl$init(void)
#line 39
{
  RTCClockM$OSTIrq$allocate();
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealTimeM$ClockControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = RTCClockM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 95 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$StdControl$init(void)
#line 95
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 96
    {
      RealTimeM$localTime = 0;
      RealTimeM$mState = 0;
      RealTimeM$queue_head = RealTimeM$queue_tail = -1;
      RealTimeM$queue_size = 0;
      RealTimeM$uc_fire_interval = UC_FIRE_INTERVAL;
      RealTimeM$uc_fire_point = RealTimeM$uc_fire_interval;
      RealTimeM$adjustInterval = 0;
      RealTimeM$adjustCounter = 0;
      RealTimeM$taskBusy = FALSE;
      RealTimeM$syncMode = DEFAULT_SYNC_MODE;
      RealTimeM$is_synced = FALSE;
      RealTimeM$init_sync = FALSE;
      RealTimeM$timerCount = 0;
      RealTimeM$localTime_t = 0;
      RealTimeM$globaltime_t = 0;
      RealTimeM$globaltime_tHist = 0;
      RealTimeM$timerBusy = FALSE;
      RealTimeM$realTimeFired = TRUE;
    }
#line 115
    __nesc_atomic_end(__nesc_atomic); }
  RealTimeM$ClockControl$init();
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
inline static  result_t GPSSensorM$GPIOControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = PXA27XGPIOIntM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 124 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setFCR(uint32_t val)
#line 124
{
#line 124
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x08) = val;
}

# 55 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setFCR(uint32_t arg_0x40c4a3d0){
#line 55
  HplPXA27xBTUARTP$UART$setFCR(arg_0x40c4a3d0);
#line 55
}
#line 55
# 127 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setMCR(uint32_t val)
#line 127
{
#line 127
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x10) = val;
}

# 60 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setMCR(uint32_t arg_0x40c49068){
#line 60
  HplPXA27xBTUARTP$UART$setMCR(arg_0x40c49068);
#line 60
}
#line 60
# 125 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setLCR(uint32_t val)
#line 125
{
#line 125
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) = val;
}

# 57 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setLCR(uint32_t arg_0x40c4a878){
#line 57
  HplPXA27xBTUARTP$UART$setLCR(arg_0x40c4a878);
#line 57
}
#line 57
# 109 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setDLH(uint32_t val)
#line 109
{
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) |= 1 << 7;
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x04) = val;
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) &= ~(1 << 7);
}

# 47 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setDLH(uint32_t arg_0x40c20100){
#line 47
  HplPXA27xBTUARTP$UART$setDLH(arg_0x40c20100);
#line 47
}
#line 47
# 97 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setDLL(uint32_t val)
#line 97
{
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) |= 1 << 7;
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0) = val;
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) &= ~(1 << 7);
}

# 44 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setDLL(uint32_t arg_0x40c21928){
#line 44
  HplPXA27xBTUARTP$UART$setDLL(arg_0x40c21928);
#line 44
}
#line 44
# 395 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialCntl$configPort(uint32_t baudrate, 
uint8_t databits, 
uart_parity_t parity, 
uint8_t stopbits, 
bool flow_cntl)
#line 399
{
  uint32_t uiDivisor;
  uint32_t valLCR = 0;
  uint32_t valMCR = 1 << 3;

  uiDivisor = 921600 / baudrate;


  if (uiDivisor & 0xFFFF0000 || uiDivisor == 0) {
      return SUCCESS;
    }

  if (databits > 8 || databits < 5) {
      return SUCCESS;
    }
  valLCR |= (databits - 5) & 0x3;

  switch (parity) {
      case EVEN: 
        valLCR |= 1 << 4;

      case ODD: 
        valLCR |= 1 << 3;
      break;
      case NONE: 
        break;
      default: 
        return SUCCESS;
      break;
    }

  if (stopbits > 2 || stopbits < 1) {
      return SUCCESS;
    }
  else {
#line 433
    if (stopbits == 2) {
        valLCR |= 1 << 2;
      }
    }
  if (flow_cntl) {
      valMCR |= 1 << 5;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 441
    {
      HalPXA27xBTUARTP$UART$setDLL(uiDivisor & 0xFF);
      HalPXA27xBTUARTP$UART$setDLH((uiDivisor >> 8) & 0xFF);
      HalPXA27xBTUARTP$UART$setLCR(valLCR);
      HalPXA27xBTUARTP$UART$setMCR(valMCR);
    }
#line 446
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 325 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static inline   void PXA27XInterruptM$PXA27XIrq$enable(uint8_t id)
{
  PXA27XInterruptM$enable(id);
  return;
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void HplPXA27xBTUARTP$UARTIrq$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(21);
#line 46
}
#line 46
#line 45
inline static   result_t HplPXA27xBTUARTP$UARTIrq$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(21);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 61 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline  result_t HplPXA27xBTUARTP$UControl$init(void)
#line 61
{
  bool isInited;

  /* atomic removed: atomic calls only */
#line 64
  {
    isInited = HplPXA27xBTUARTP$m_fInit;
    HplPXA27xBTUARTP$m_fInit = TRUE;
  }

  if (!isInited) {

      * (volatile uint32_t *)0x41300004 |= 1 << 7;

      HplPXA27xBTUARTP$UARTIrq$allocate();
      HplPXA27xBTUARTP$UARTIrq$enable();
      * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) |= 1 << 7;
      * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0) = 0x60;
      * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x04) = 0x00;
      * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x0C) &= ~(1 << 7);
    }

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HalPXA27xBTUARTP$ChanControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HplPXA27xBTUARTP$UControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 116 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline  result_t HalPXA27xBTUARTP$SerialControl$init(void)
#line 116
{

  result_t error = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 120
    {

      {
#line 122
        * (volatile uint32_t *)(0x40E0000C + (42 < 96 ? ((42 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (42 < 96 ? ((42 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (42 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (42 < 96 ? ((42 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (42 & 0x1f));
#line 122
        * (volatile uint32_t *)(0x40E00054 + ((42 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((42 & 0x7f) >> 4) * 4) & ~(3 << (42 & 0xf) * 2)) | (1 << (42 & 0xf) * 2);
      }
#line 122
      ;
      {
#line 123
        * (volatile uint32_t *)(0x40E0000C + (43 < 96 ? ((43 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (43 < 96 ? ((43 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (43 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (43 < 96 ? ((43 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (43 & 0x1f));
#line 123
        * (volatile uint32_t *)(0x40E00054 + ((43 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((43 & 0x7f) >> 4) * 4) & ~(3 << (43 & 0xf) * 2)) | (2 << (43 & 0xf) * 2);
      }
#line 123
      ;


      HalPXA27xBTUARTP$ChanControl$init();
      HalPXA27xBTUARTP$txCurrentBuf = HalPXA27xBTUARTP$rxCurrentBuf = (void *)0;
      HalPXA27xBTUARTP$gbUsingUartStreamSendIF = FALSE;
      HalPXA27xBTUARTP$gbUsingUartStreamRcvIF = FALSE;
      HalPXA27xBTUARTP$gbRcvByteEvtEnabled = TRUE;
      HalPXA27xBTUARTP$gulFCRShadow = (((1 << 0) | (1 << 1)) | (1 << 2)) | ((0 & 0x3) << 6);
    }
#line 132
    __nesc_atomic_end(__nesc_atomic); }









  error = HalPXA27xBTUARTP$HalPXA27xSerialCntl$configPort(HalPXA27xBTUARTP$defaultRate, 8, NONE, 1, FALSE);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 143
    {
#line 143
      HalPXA27xBTUARTP$UART$setFCR(HalPXA27xBTUARTP$gulFCRShadow);
    }
#line 144
    __nesc_atomic_end(__nesc_atomic); }
#line 144
  return error;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GPSSensorM$GPSSerialControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HalPXA27xBTUARTP$SerialControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 118 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline void GPSSensorM$initialize(void)
#line 118
{
  GPSSensorM$dataCount = 0;
  GPSSensorM$rawCount = 0;

  GPSSensorM$timeCount = 0;
  GPSSensorM$ppsIndex = 0;
  GPSSensorM$last_pps_index = 0;
  GPSSensorM$gLocalTime = 0;
  GPSSensorM$checkTimerOn = FALSE;
  GPSSensorM$alreadySetTime = FALSE;
  GPSSensorM$hasGPS = FALSE;


  GPSSensorM$NMEAData = (void *)0;
  GPSSensorM$RAWData = (void *)0;
  GPSSensorM$skew = 0.0;
  GPSSensorM$localAverage = 0;
  GPSSensorM$offsetAverage = 0;
  GPSSensorM$tableEntries = 0;
  GPSSensorM$numEntries = 0;
  GPSSensorM$adjustTime = 0;
  GPSSensorM$samplingReady = FALSE;
  GPSSensorM$samplingStart = FALSE;
}

static inline  result_t GPSSensorM$StdControl$init(void)
#line 143
{
  if (GPSSensorM$initialized != TRUE) {
      GPSSensorM$initialize();
      GPSSensorM$clearTable();
      GPSSensorM$GPSSerialControl$init();
      GPSSensorM$GPIOControl$init();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 149
        GPSSensorM$initialized = TRUE;
#line 149
        __nesc_atomic_end(__nesc_atomic); }
    }
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t ADCM$ClockControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = RTCClockM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
inline static  result_t ADCM$InternalControl$init(void){
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
# 70 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline  result_t ADCM$StdControl$init(void)
#line 70
{
  ADCM$InternalControl$init();
  ADCM$ADCControl$init();
  ADCM$ClockControl$init();
  ADCM$time_flag = 0;
  return SUCCESS;
}

# 99 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static inline void FlashManagerM$initialize(void)
#line 99
{
  FlashManagerM$eraseTimerCount = 0;
  FlashManagerM$FlashFlag = 0;
  FlashManagerM$ProgID = 0;
  FlashManagerM$RFChannel = 0;
  FlashManagerM$numToWrite = 0;
  FlashManagerM$alreadyStart = FALSE;

  FlashManagerM$writeTaskBusy = FALSE;
}






static inline  result_t FlashManagerM$StdControl$init(void)
#line 115
{

  initQueue(&FlashManagerM$flashQueue, MAX_FLASH_NUM);
  FlashManagerM$initialize();
  ;
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
# 122 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline void DataMgmtM$initialize(void)
#line 122
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
  DataMgmtM$headSendQueue = (void *)0;
  DataMgmtM$presendTaskCount = 0;
  DataMgmtM$processTaskCount = 0;
  DataMgmtM$trynextSendCount = 0;
  DataMgmtM$allocbuffercount = 0;
  DataMgmtM$f_allocbuffercount = 0;
  DataMgmtM$freebuffercount = 0;
  DataMgmtM$nothingtosend = 0;
  DataMgmtM$batchTimerCount = 0;

  start_point = 0;
  end_point = 0;
  sta_period = MAX_STA_PERIOD;
  lta_period = MAX_LTA_PERIOD;
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

# 157 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$StdControl$init(void)
#line 157
{
  initBufferPool(&DataMgmtM$buffQueue, MAX_SENSING_QUEUE_SIZE, DataMgmtM$buffMsg);
  initQueue(&DataMgmtM$sendQueue, MAX_SENSING_QUEUE_SIZE);
  initSenorMem(&DataMgmtM$sensorMem, MEM_QUEUE_SIZE);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 161
    DataMgmtM$initialize();
#line 161
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
  result = rcombine(result, FlashManagerM$StdControl$init());
#line 63
  result = rcombine(result, ADCM$StdControl$init());
#line 63
  result = rcombine(result, GPSSensorM$StdControl$init());
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
# 276 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$StdControl$init(void)
#line 276
{
  SmartSensingM$ADCControl$init();
  SmartSensingM$SubControl$init();
  SmartSensingM$TimerControl$init();
  return SUCCESS;
}

# 85 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  result_t SettingsM$StdControl$init(void)
#line 85
{
  return SUCCESS;
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t PXA27XClockM$OSTIrq$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(7);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 109 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static inline  result_t PXA27XClockM$StdControl$init(void)
#line 109
{










  PXA27XClockM$OSTIrq$allocate();
  return SUCCESS;
}

# 29 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static inline  result_t BufferedSTUARTM$StdControl$init(void)
#line 29
{
  initptrqueue(&outgoingQueue, defaultQueueSize);

  do {
#line 32
      initBufferInfoSet(&BufferedSTUARTM$receiveBufferInfoSet, BufferedSTUARTM$receiveBufferInfoInfo, 30);
#line 32
      initBufferSet(&BufferedSTUARTM$receiveBufferSet, BufferedSTUARTM$receiveBufferStructs, (uint8_t **)BufferedSTUARTM$receiveBuffers, 30, ((10 + 31) >> 5) << 5);
    }
  while (
#line 32
  0);

  BufferedSTUARTM$gTxActive = FALSE;

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t BluSHM$UartControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = BufferedSTUARTM$StdControl$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 233 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$StdControl$init(void)
#line 233
{
  uint16_t i;


  for (i = 0; i < 4; i++) 
    BluSHM$blush_history[i][0] = '\0';


  trace_set(((DBG_USR1 | DBG_USR2) | DBG_USR3) | DBG_TEMP);





  BluSHM$UartControl$init();
  strncpy(BluSHM$blush_prompt, "BluSH>", 32);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 250
    {
      BluSHM$InQueue = BluSHM$DynQueue_new();
      BluSHM$OutQueue = BluSHM$DynQueue_new();
    }
#line 253
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t PXA27XDMAM$Interrupt$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(25);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 113 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline  result_t PXA27XDMAM$StdControl$init(void)
#line 113
{

  int i;

#line 116
  if (PXA27XDMAM$gInitialized == FALSE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 117
        {
          for (i = 0; i < 4U; i++) {
              PXA27XDMAM$mChannelArray[i].channelValid = FALSE;
            }
        }
#line 121
        __nesc_atomic_end(__nesc_atomic); }
      PXA27XDMAM$Interrupt$allocate();
      PXA27XDMAM$gInitialized = TRUE;
    }

  return SUCCESS;
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   result_t PXA27XUSBClientM$USBInterrupt$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(11);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void PXA27XUSBClientM$USBAttached$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(13, arg_0x406321d8);
#line 45
}
#line 45
# 14 "/opt/tinyos-1.x/tos/platform/imote2/HPLUSBClientGPIOM.nc"
static inline   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$init(void)
#line 14
{
  * (volatile uint32_t *)(0x40E0000C + (13 < 96 ? ((13 & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (13 & 0x1f));

  * (volatile uint32_t *)(0x40E0000C + (88 < 96 ? ((88 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (88 & 0x1f);
  * (volatile uint32_t *)(0x40E00018 + (88 < 96 ? ((88 & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (88 & 0x1f);
  return SUCCESS;
}

# 19 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLUSBClientGPIO.nc"
inline static   result_t PXA27XUSBClientM$HPLUSBClientGPIO$init(void){
#line 19
  unsigned char result;
#line 19

#line 19
  result = HPLUSBClientGPIOM$HPLUSBClientGPIO$init();
#line 19

#line 19
  return result;
#line 19
}
#line 19
# 1227 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$writeHidReportDescriptor(void)
#line 1227
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1228
    {
      PXA27XUSBClientM$HidReport.wLength = PXA27XUSBClientM$Hid.wDescriptorLength;
      PXA27XUSBClientM$HidReport.bString = (uint8_t *)safe_malloc(PXA27XUSBClientM$HidReport.wLength);
      * (uint32_t *)PXA27XUSBClientM$HidReport.bString = ((0x06 | (0xA0 << 8)) | (0xFF << 16)) | (0x09 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 4) = ((0xA5 | (0xA1 << 8)) | (0x01 << 16)) | (0x09 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 8) = ((0xA6 | (0x09 << 8)) | (0xA7 << 16)) | (0x15 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 12) = ((0x80 | (0x25 << 8)) | (0x7F << 16)) | (0x75 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 16) = ((0x08 | (0x95 << 8)) | (0x40 << 16)) | (0x81 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 20) = ((0x02 | (0x09 << 8)) | (0xA9 << 16)) | (0x15 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 24) = ((0x80 | (0x25 << 8)) | (0x7F << 16)) | (0x75 << 24);
      * (uint32_t *)(PXA27XUSBClientM$HidReport.bString + 28) = ((0x08 | (0x95 << 8)) | (0x40 << 16)) | (0x91 << 24);
      * (uint8_t *)(PXA27XUSBClientM$HidReport.bString + 32) = 0x02;
      * (uint8_t *)(PXA27XUSBClientM$HidReport.bString + 33) = 0xC0;
    }
#line 1241
    __nesc_atomic_end(__nesc_atomic); }
}

#line 1217
static inline void PXA27XUSBClientM$writeHidDescriptor(void)
#line 1217
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1218
    {
      PXA27XUSBClientM$Hid.bcdHID = 0x0110;
      PXA27XUSBClientM$Hid.bCountryCode = 0;
      PXA27XUSBClientM$Hid.bNumDescriptors = 1;
      PXA27XUSBClientM$Hid.bDescriptorType = 0x22;
      PXA27XUSBClientM$Hid.wDescriptorLength = 0x22;
    }
#line 1224
    __nesc_atomic_end(__nesc_atomic); }
}

# 11 "/opt/tinyos-1.x/tos/platform/imote2/UIDC.nc"
static inline   uint32_t UIDC$UID$getUID(void)
#line 11
{
  return * (uint32_t *)0x01FE0000;
}

# 20 "/opt/tinyos-1.x/tos/platform/pxa27x/UID.nc"
inline static   uint32_t PXA27XUSBClientM$UID$getUID(void){
#line 20
  unsigned int result;
#line 20

#line 20
  result = UIDC$UID$getUID();
#line 20

#line 20
  return result;
#line 20
}
#line 20
# 1244 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$writeStringDescriptor(void)
#line 1244
{
  uint8_t i;
  char *buf = (char *)safe_malloc(80);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1248
    {
      for (i = 0; i < 3 + 1; i++) 
        PXA27XUSBClientM$Strings[i] = (PXA27XUSBClientM$USBstring )safe_malloc(sizeof(PXA27XUSBClientM$__string_t ));

      PXA27XUSBClientM$Strings[0]->bLength = 4;
      PXA27XUSBClientM$Strings[0]->uMisc.wLANGID = 0x0409;

      PXA27XUSBClientM$Strings[1]->uMisc.bString = "SNO";
      PXA27XUSBClientM$Strings[2]->uMisc.bString = "Intel Mote 2 Embedded Device";

      sprintf(buf, "%x", PXA27XUSBClientM$UID$getUID());
      safe_realloc(buf, strlen(buf) + 1);
      PXA27XUSBClientM$Strings[3]->uMisc.bString = buf;

      for (i = 1; i < 3 + 1; i++) 
        PXA27XUSBClientM$Strings[i]->bLength = 2 + 2 * strlen(PXA27XUSBClientM$Strings[i]->uMisc.bString);
    }
#line 1264
    __nesc_atomic_end(__nesc_atomic); }
}

static inline void PXA27XUSBClientM$writeEndpointDescriptor(PXA27XUSBClientM$USBendpoint *endpoints, uint8_t config, uint8_t inter, uint8_t i)
#line 1267
{
  PXA27XUSBClientM$USBendpoint End;

#line 1269
  End = (PXA27XUSBClientM$USBendpoint )safe_malloc(sizeof(PXA27XUSBClientM$__endpoint_t ));

  endpoints[i] = End;
  End->bEndpointAddress = i + 1;
  switch (config) {
      case 1: 
        switch (inter) {
            case 0: 
              switch (i) {
                  case 0: 
                    End->bEndpointAddress |= 1 << (7 & 0x1f);
                  End->bmAttributes = 0x3;
                  End->wMaxPacketSize = 0x40;
                  End->bInterval = 0x01;

                  * (volatile uint32_t *)0x40600404 |= (((((1 << 25) | ((End->bEndpointAddress & 0xF) << 15)) | ((End->bmAttributes & 0x3) << 13)) | (((End->bEndpointAddress & (1 << (7 & 0x1f))) != 0) << 12)) | (End->wMaxPacketSize << 2)) | 1;
                  break;
                  case 1: 
                    End->bmAttributes = 0x3;
                  End->wMaxPacketSize = 0x40;
                  End->bInterval = 0x01;

                  * (volatile uint32_t *)0x40600408 |= (((((1 << 25) | ((End->bEndpointAddress & 0xF) << 15)) | ((End->bmAttributes & 0x3) << 13)) | (((End->bEndpointAddress & (1 << (7 & 0x1f))) != 0) << 12)) | (End->wMaxPacketSize << 2)) | 1;
                  break;
                }
            break;
          }
      break;
    }
}

static inline uint16_t PXA27XUSBClientM$writeInterfaceDescriptor(PXA27XUSBClientM$USBinterface *interfaces, uint8_t config, uint8_t i)
#line 1300
{
  uint8_t j;
  uint16_t length;
  PXA27XUSBClientM$USBinterface Inter;

#line 1304
  Inter = (PXA27XUSBClientM$USBinterface )safe_malloc(sizeof(PXA27XUSBClientM$__interface_t ));

  interfaces[i] = Inter;
  length = 9;
  Inter->bInterfaceID = i;
  switch (config) {
      case 0: 
        switch (i) {
            case 0: 
              Inter->bAlternateSetting = 0;
            Inter->bNumEndpoints = 0;
            Inter->bInterfaceClass = 0;
            Inter->bInterfaceSubclass = 0;
            Inter->bInterfaceProtocol = 0;
            Inter->iInterface = 0;
            break;
          }
      break;
      case 1: 
        switch (i) {
            case 0: 
              Inter->bAlternateSetting = 0;
            Inter->bNumEndpoints = 2;
            Inter->bInterfaceClass = 0x03;
            Inter->bInterfaceSubclass = 0x00;
            Inter->bInterfaceProtocol = 0x00;
            Inter->iInterface = 0;
            length += 0x09;
            break;
          }
    }

  if (Inter->bNumEndpoints > 0) {
      Inter->oEndpoints = (PXA27XUSBClientM$USBendpoint *)safe_malloc(sizeof(PXA27XUSBClientM$__endpoint_t ) * Inter->bNumEndpoints);

      length += Inter->bNumEndpoints * 7;
      for (j = 0; j < Inter->bNumEndpoints; j++) 
        PXA27XUSBClientM$writeEndpointDescriptor(Inter->oEndpoints, config, i, j);
    }
  return length;
}

static inline void PXA27XUSBClientM$writeConfigurationDescriptor(PXA27XUSBClientM$USBconfiguration *configs, uint8_t i)
#line 1346
{
  uint8_t j;
  PXA27XUSBClientM$USBconfiguration Config;

#line 1349
  Config = (PXA27XUSBClientM$USBconfiguration )safe_malloc(sizeof(PXA27XUSBClientM$__configuration_t ));

  configs[i] = Config;
  Config->wTotalLength = 9;
  Config->bConfigurationID = i;

  switch (i) {
      case 0: 
        Config->bNumInterfaces = 1;
      Config->iConfiguration = 0;
      Config->bmAttributes = 0x80;
      Config->MaxPower = 125;
      break;
      case 1: 
        Config->bNumInterfaces = 1;
      Config->iConfiguration = 0;
      Config->bmAttributes = 0x80;
      Config->MaxPower = 125;
    }

  Config->oInterfaces = (PXA27XUSBClientM$USBinterface *)safe_malloc(sizeof(PXA27XUSBClientM$__interface_t ) * Config->bNumInterfaces);

  for (j = 0; j < Config->bNumInterfaces; j++) 
    Config->wTotalLength += PXA27XUSBClientM$writeInterfaceDescriptor(Config->oInterfaces, i, j);
}


static inline void PXA27XUSBClientM$writeDeviceDescriptor(void)
#line 1376
{
  uint8_t i;

#line 1378
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1378
    {
      PXA27XUSBClientM$Device.bcdUSB = 0x0110;
      PXA27XUSBClientM$Device.bDeviceClass = PXA27XUSBClientM$Device.bDeviceSubclass = PXA27XUSBClientM$Device.bDeviceProtocol = 0;
      PXA27XUSBClientM$Device.bMaxPacketSize0 = 16;
      PXA27XUSBClientM$Device.idVendor = 0x042b;
      PXA27XUSBClientM$Device.idProduct = 0x1337;
      PXA27XUSBClientM$Device.bcdDevice = 0x0312;
      PXA27XUSBClientM$Device.iManufacturer = 1;
      PXA27XUSBClientM$Device.iProduct = 2;
      PXA27XUSBClientM$Device.iSerialNumber = 3;
      PXA27XUSBClientM$Device.bNumConfigurations = 2;
      PXA27XUSBClientM$Device.oConfigurations = (PXA27XUSBClientM$USBconfiguration *)safe_malloc(sizeof(PXA27XUSBClientM$__configuration_t ) * PXA27XUSBClientM$Device.bNumConfigurations);
    }
#line 1390
    __nesc_atomic_end(__nesc_atomic); }

  for (i = 0; i < PXA27XUSBClientM$Device.bNumConfigurations; i++) 
    PXA27XUSBClientM$writeConfigurationDescriptor(PXA27XUSBClientM$Device.oConfigurations, i);
}

#line 156
static inline  result_t PXA27XUSBClientM$Control$init(void)
#line 156
{
  uint8_t i;
  PXA27XUSBClientM$DynQueue QueueTemp;

#line 159
  if (PXA27XUSBClientM$init == 0) {
      PXA27XUSBClientM$writeDeviceDescriptor();
      PXA27XUSBClientM$writeStringDescriptor();
      PXA27XUSBClientM$writeHidDescriptor();
      PXA27XUSBClientM$writeHidReportDescriptor();

      QueueTemp = PXA27XUSBClientM$DynQueue_new();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 166
        PXA27XUSBClientM$InQueue = QueueTemp;
#line 166
        __nesc_atomic_end(__nesc_atomic); }
      QueueTemp = PXA27XUSBClientM$DynQueue_new();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 168
        PXA27XUSBClientM$OutQueue = QueueTemp;
#line 168
        __nesc_atomic_end(__nesc_atomic); }
    }

  PXA27XUSBClientM$HPLUSBClientGPIO$init();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 173
    {
      * (volatile uint32_t *)0x41300004 |= 1 << 11;

      * (volatile uint32_t *)0x40600008 |= 1 << (27 & 0x1f);
      * (volatile uint32_t *)0x40600008 |= 1 << (31 & 0x1f);
      * (volatile uint32_t *)0x40600004 |= 1 << (0 & 0x1f);
      * (volatile uint32_t *)0x40600004 |= 1 << (2 & 0x1f);
      * (volatile uint32_t *)0x40600004 |= 1 << (4 & 0x1f);

      for (i = 0; i < 4; i++) {
          PXA27XUSBClientM$OutStream[i].endpointDR = (volatile unsigned long *const )0x40600308;
          PXA27XUSBClientM$OutStream[i].fifosize = PXA27XUSBClientM$Device.oConfigurations[1]->oInterfaces[
          0]->oEndpoints[1]->wMaxPacketSize;
          PXA27XUSBClientM$OutStream[i].len = PXA27XUSBClientM$OutStream[i].index = PXA27XUSBClientM$OutStream[i].status = 
          PXA27XUSBClientM$OutStream[i].type = 0;
        }
      PXA27XUSBClientM$state = 0;
    }
#line 190
    __nesc_atomic_end(__nesc_atomic); }
  PXA27XUSBClientM$USBAttached$enable(3);

  PXA27XUSBClientM$USBInterrupt$allocate();

  PXA27XUSBClientM$isAttached();

  return SUCCESS;
}

# 47 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static inline  result_t FlashM$StdControl$init(void)
#line 47
{
  int i = 0;

#line 49
  if (FlashM$init != 0) {
    return SUCCESS;
    }
#line 51
  FlashM$init = 1;
  for (i = 0; i < 16; i++) 
    FlashM$FlashPartitionState[i] = 0;

   __asm volatile (
  ".equ FLASH_READARRAY,(0x00FF);         		 .equ FLASH_CFIQUERY,(0x0098);		 		 .equ FLASH_READSTATUS,(0x0070);	 		 .equ FLASH_CLEARSTATUS,(0x0050);	 		 .equ FLASH_PROGRAMWORD,(0x0040);	 		 .equ FLASH_PROGRAMBUFFER,(0x00E8);	 		 .equ FLASH_ERASEBLOCK,(0x0020);	 		 .equ FLASH_DLOCKBLOCK,(0x0060);	 		 .equ FLASH_PROGRAMBUFFERCONF,(0x00D0);	 		 .equ FLASH_LOCKCONF,(0x0001);		 		 .equ FLASH_UNLOCKCONF,(0x00D0);	 		 .equ FLASH_ERASECONF,(0x00D0);		                  .equ FLASH_OP_NOT_SUPPORTED,(0x10);");
#line 70
  ;
  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealMain$StdControl$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = FlashM$StdControl$init();
#line 63
  result = rcombine(result, PXA27XUSBClientM$Control$init());
#line 63
  result = rcombine(result, PXA27XGPIOIntM$StdControl$init());
#line 63
  result = rcombine(result, PXA27XDMAM$StdControl$init());
#line 63
  result = rcombine(result, BluSHM$StdControl$init());
#line 63
  result = rcombine(result, PXA27XClockM$StdControl$init());
#line 63
  result = rcombine(result, PMICM$StdControl$init());
#line 63
  result = rcombine(result, SettingsM$StdControl$init());
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
# 27 "/opt/tinyos-1.x/tos/platform/imote2/HPLUSBClientGPIOM.nc"
static inline   result_t HPLUSBClientGPIOM$HPLUSBClientGPIO$checkConnection(void)
#line 27
{
  if ((* (volatile uint32_t *)(0x40E00000 + (13 < 96 ? ((13 & 0x7f) >> 5) * 4 : 0x100)) & (1 << (13 & 0x1f))) != 0) {
    return SUCCESS;
    }
  else {
#line 31
    return FAIL;
    }
}

# 35 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLUSBClientGPIO.nc"
inline static   result_t PXA27XUSBClientM$HPLUSBClientGPIO$checkConnection(void){
#line 35
  unsigned char result;
#line 35

#line 35
  result = HPLUSBClientGPIOM$HPLUSBClientGPIO$checkConnection();
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 114 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
inline static void PXA27XUSBClientM$DynQueue_shiftshrink(PXA27XUSBClientM$DynQueue oDynQueue)



{

  if (oDynQueue == (void *)0) {
    return;
    }
  if (oDynQueue->index > 0) {
      memmove((void *)oDynQueue->ppvQueue, (void *)(oDynQueue->ppvQueue + oDynQueue->index), sizeof(void *) * oDynQueue->iLength);
      oDynQueue->index = 0;
    }
  oDynQueue->iPhysLength /= 2;
  oDynQueue->ppvQueue = (const void **)safe_realloc(oDynQueue->ppvQueue, 
  sizeof(void *) * oDynQueue->iPhysLength);
}

# 167 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static inline   result_t PXA27XClockM$Clock$setRate(uint32_t interval, uint32_t scale)
#line 167
{






  PXA27XClockM$Clock$setInterval(interval);
#line 205
  return SUCCESS;
}

# 96 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   result_t TimerM$Clock$setRate(uint32_t arg_0x408c5460, uint32_t arg_0x408c55f0){
#line 96
  unsigned char result;
#line 96

#line 96
  result = PXA27XClockM$Clock$setRate(arg_0x408c5460, arg_0x408c55f0);
#line 96

#line 96
  return result;
#line 96
}
#line 96
# 159 "/opt/tinyos-1.x/tos/system/tos.h"
static inline void *nmemset(void *to, int val, size_t n)
{
  char *cto = to;

  while (n--) * cto++ = val;

  return to;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t NeighborMgmtM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(18U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t NeighborMgmtM$Random$rand(void){
#line 63
  unsigned short result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 49 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  result_t NeighborMgmtM$StdControl$start(void)
#line 49
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
# 59 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdogM.nc"
static inline  void PXA27XWatchdogM$PXA27XWatchdog$enableWDT(uint32_t interval)
#line 59
{
  * (volatile uint32_t *)0x40A0000C = * (volatile uint32_t *)0x40A00010 + interval;

  * (volatile uint32_t *)0x40A00018 = 1;
}

# 61 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdog.nc"
inline static  void HPLWatchdogM$PXA27XWatchdog$enableWDT(uint32_t arg_0x408a7340){
#line 61
  PXA27XWatchdogM$PXA27XWatchdog$enableWDT(arg_0x408a7340);
#line 61
}
#line 61
# 57 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLWatchdogM.nc"
static inline  result_t HPLWatchdogM$StdControl$start(void)
#line 57
{
  HPLWatchdogM$PXA27XWatchdog$enableWDT(3250000);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t WDTM$WDTControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = HPLWatchdogM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t WDTM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(8U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 86 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static inline  result_t TimerM$StdControl$start(void)
#line 86
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t WDTM$TimerControl$start(void){
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
# 73 "/opt/tinyos-1.x/tos/system/WDTM.nc"
static inline  result_t WDTM$StdControl$start(void)
#line 73
{
  result_t ok1 = WDTM$TimerControl$start();
  result_t ok2 = WDTM$Timer$start(TIMER_REPEAT, WDTM$WDT_LATENCY);

#line 76
  if (rcombine(ok1, ok2) == SUCCESS) {
      return WDTM$WDTControl$start();
    }
  return FAIL;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t SNMSM$WDTControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = WDTM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 99 "/opt/tinyos-1.x/tos/system/WDTM.nc"
static inline  result_t WDTM$WDT$start(int32_t interval)
#line 99
{
  if (WDTM$increment == 0) {
      WDTM$increment = interval;
      WDTM$remaining = WDTM$increment;
      return SUCCESS;
    }
  return FAIL;
}

# 45 "/opt/tinyos-1.x/tos/interfaces/WDT.nc"
inline static  result_t SNMSM$WWDT$start(int32_t arg_0x40cb0b70){
#line 45
  unsigned char result;
#line 45

#line 45
  result = WDTM$WDT$start(arg_0x40cb0b70);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SNMSM$SNMSTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(7U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 142 "build/imote2/RpcM.nc"
static inline  result_t RpcM$StdControl$start(void)
#line 142
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










  SNMSM$SNMSTimer$start(TIMER_REPEAT, 100);
  SNMSM$WWDT$start(1000);
  SNMSM$WDTControl$start();



  SNMSM$EReportControl$start();

  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t TimeSyncM$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(9U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 868 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$StdControl$start(void)
#line 868
{
  TimeSyncM$mode = TS_TIMER_MODE;
  TimeSyncM$heartBeats = 0;
  ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->nodeID = TOS_LOCAL_ADDRESS;
  TimeSyncM$Timer$start(TIMER_REPEAT, (uint32_t )1000 * TimeSyncM$BEACON_RATE);

  return SUCCESS;
}

# 54 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$write(uint8_t arg_0x40957918, uint16_t arg_0x40957aa8){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HPLCC2420M$HPLCC2420$write(arg_0x40957918, arg_0x40957aa8);
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
# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLPowerManagementM.nc"
static inline   uint8_t HPLPowerManagementM$PowerManagement$adjustPower(void)
#line 51
{
  return 0;
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
inline static  result_t GenericCommProM$MonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(11U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
inline static  result_t GenericCommProM$ActivityTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(10U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420ControlM$HPLChipcon$cmd(uint8_t arg_0x40957408){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0x40957408);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$CCA_GPIOInt$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(116, arg_0x406321d8);
#line 45
}
#line 45


inline static   void HPLCC2420M$CCA_GPIOInt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(116);
#line 47
}
#line 47
#line 46
inline static   void HPLCC2420M$CCA_GPIOInt$disable(void){
#line 46
  PXA27XGPIOIntM$PXA27XGPIOInt$disable(116);
#line 46
}
#line 46
# 807 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$InterruptCCA$startWait(bool low_to_high)
#line 807
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 809
    {
      HPLCC2420M$CCA_GPIOInt$disable();
      HPLCC2420M$CCA_GPIOInt$clear();
      if (low_to_high) {
          HPLCC2420M$CCA_GPIOInt$enable(1);
        }
      else {
          HPLCC2420M$CCA_GPIOInt$enable(2);
        }
    }
#line 818
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420ControlM$CCA$startWait(bool arg_0x40959bc8){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420M$InterruptCCA$startWait(arg_0x40959bc8);
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

# 104 "/opt/tinyos-1.x/tos/platform/pxa27x/pxa27xhardware.h"
static inline void TOSH_wait(void)
{
   __asm volatile ("nop");
   __asm volatile ("nop");}

# 182 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_SET_CC_RSTN_PIN(void)
#line 182
{
#line 182
  * (volatile uint32_t *)(0x40E00018 + (22 < 96 ? ((22 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (22 & 0x1f);
}

# 125 "/opt/tinyos-1.x/tos/platform/pxa27x/pxa27xhardware.h"
static __inline void TOSH_uwait(uint16_t usec)
{
  uint32_t start;
#line 127
  uint32_t mark = usec;



  start = * (volatile uint32_t *)0x40A00010;
  mark <<= 2;
  mark *= 13;
  mark >>= 2;


  while (* (volatile uint32_t *)0x40A00010 - start < mark) ;
}

# 181 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_SET_CC_VREN_PIN(void)
#line 181
{
#line 181
  * (volatile uint32_t *)(0x40E00018 + (115 < 96 ? ((115 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (115 & 0x1f);
}

# 400 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static inline   result_t CC2420ControlM$CC2420Control$VREFOn(void)
#line 400
{
  TOSH_SET_CC_VREN_PIN();

  TOSH_uwait(600);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t HPLCC2420M$GPIOControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = PXA27XGPIOIntM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 136 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  result_t HPLCC2420M$StdControl$start(void)
#line 136
{


  * (volatile uint32_t *)0x41300004 |= 1 << 4;



  * (volatile uint32_t *)0x41900004 = ((1 << 22) | ((8 & 0xF) << 10)) | ((8 & 0xF) << 6);
  * (volatile uint32_t *)0x41900028 = 96 * 8;
  * (volatile uint32_t *)0x41900000 = ((((1 & 0xFFF) << 8) | ((0 & 0x3) << 4)) | ((0x7 & 0xF) << 0)) | (1 << 7);

  HPLCC2420M$GPIOControl$start();
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t CC2420ControlM$HPLChipconControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = HPLCC2420M$StdControl$start();
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
# 39 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static inline  result_t TimerJiffyAsyncM$StdControl$start(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 41
    TimerJiffyAsyncM$bSet = FALSE;
#line 41
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
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void HPLFFUARTM$Interrupt$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(22);
#line 46
}
#line 46
#line 45
inline static   result_t HPLFFUARTM$Interrupt$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(22);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 90 "/opt/tinyos-1.x/tos/platform/imote2/HPLFFUARTM.nc"
static inline void HPLFFUARTM$setBaudRate(uint8_t rate)
#line 90
{

  switch (rate) {
      case UART_BAUD_300: 
        * (volatile uint32_t *)0x40100000 = 0x0;
      * (volatile uint32_t *)0x40100004 = 0xC;
      break;
      case UART_BAUD_1200: 
        * (volatile uint32_t *)0x40100000 = 0x0;
      * (volatile uint32_t *)0x40100004 = 0x3;
      break;
      case UART_BAUD_2400: 
        * (volatile uint32_t *)0x40100000 = 0x80;
      * (volatile uint32_t *)0x40100004 = 0x1;
      break;
      case UART_BAUD_4800: 
        * (volatile uint32_t *)0x40100000 = 0xC0;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_9600: 
        * (volatile uint32_t *)0x40100000 = 0x60;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_19200: 
        * (volatile uint32_t *)0x40100000 = 0x30;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_38400: 
        * (volatile uint32_t *)0x40100000 = 0x18;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_57600: 
        * (volatile uint32_t *)0x40100000 = 0x10;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_115200: 
        * (volatile uint32_t *)0x40100000 = 0x8;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_230400: 
        * (volatile uint32_t *)0x40100000 = 0x4;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_460800: 
        * (volatile uint32_t *)0x40100000 = 0x2;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      case UART_BAUD_921600: 
        * (volatile uint32_t *)0x40100000 = 0x1;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
      default: 
        * (volatile uint32_t *)0x40100000 = 0x8;
      * (volatile uint32_t *)0x40100004 = 0;
      break;
    }
}

# 331 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static inline   void PXA27XInterruptM$PXA27XIrq$disable(uint8_t id)
{
  PXA27XInterruptM$disable(id);
  return;
}

# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void HPLFFUARTM$Interrupt$disable(void){
#line 47
  PXA27XInterruptM$PXA27XIrq$disable(22);
#line 47
}
#line 47
# 148 "/opt/tinyos-1.x/tos/platform/imote2/HPLFFUARTM.nc"
static inline   result_t HPLFFUARTM$UART$init(void)
#line 148
{










  {
#line 159
    * (volatile uint32_t *)(0x40E0000C + (96 < 96 ? ((96 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (96 < 96 ? ((96 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (96 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (96 < 96 ? ((96 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (96 & 0x1f));
#line 159
    * (volatile uint32_t *)(0x40E00054 + ((96 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((96 & 0x7f) >> 4) * 4) & ~(3 << (96 & 0xf) * 2)) | (3 << (96 & 0xf) * 2);
  }
#line 159
  ;
  {
#line 160
    * (volatile uint32_t *)(0x40E0000C + (99 < 96 ? ((99 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (99 < 96 ? ((99 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (99 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (99 < 96 ? ((99 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (99 & 0x1f));
#line 160
    * (volatile uint32_t *)(0x40E00054 + ((99 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((99 & 0x7f) >> 4) * 4) & ~(3 << (99 & 0xf) * 2)) | (3 << (99 & 0xf) * 2);
  }
#line 160
  ;
  HPLFFUARTM$Interrupt$disable();

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 163
    {
      * (volatile uint32_t *)0x4010000C |= 1 << 7;






      HPLFFUARTM$setBaudRate(HPLFFUARTM$baudrate);

      * (volatile uint32_t *)0x4010000C &= ~(1 << 7);
    }
#line 174
    __nesc_atomic_end(__nesc_atomic); }
  * (volatile uint32_t *)0x4010000C |= 0x3;

  * (volatile uint32_t *)0x40100010 &= ~(1 << 4);
  * (volatile uint32_t *)0x40100010 |= 1 << 3;
  * (volatile uint32_t *)0x40100004 |= 1 << 0;
  * (volatile uint32_t *)0x40100004 |= 1 << 1;
  * (volatile uint32_t *)0x40100004 |= 1 << 6;




  * (volatile uint32_t *)0x40100008 = 1 << 0;

  HPLFFUARTM$Interrupt$allocate();
  HPLFFUARTM$Interrupt$enable();








  * (volatile uint32_t *)0x41300004 |= 1 << 6;

  return SUCCESS;
}

# 63 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
inline static   result_t UARTM$HPLUART$init(void){
#line 63
  unsigned char result;
#line 63

#line 63
  result = HPLFFUARTM$UART$init();
#line 63

#line 63
  return result;
#line 63
}
#line 63
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
# 251 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  bool GenericCommProM$Control$start(void)
#line 251
{
  bool ok = SUCCESS;

  ok = GenericCommProM$TimerControl$start() && ok;

  ok = GenericCommProM$UARTControl$start() && ok;

  ok = GenericCommProM$RadioControl$start() && ok;
  ok = GenericCommProM$ActivityTimer$start(TIMER_REPEAT, 1000) && ok;


  ok = GenericCommProM$MonitorTimer$start(TIMER_REPEAT, COMM_WDT_UPDATE_UNIT) && ok;


  if (SUCCESS != GenericCommProM$PowerManagement$adjustPower()) {
      ;
    }





  GenericCommProM$MacControl$enableAck();

  return ok;
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t MultiHopLQI$Random$rand(void){
#line 63
  unsigned short result;
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
inline static  result_t MultiHopLQI$Timer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(21U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 270 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$StdControl$start(void)
#line 270
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
inline static  result_t MultiHopEngineM$RouteStatusTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(20U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
inline static  result_t MultiHopEngineM$MonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(19U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 129 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$StdControl$start(void)
{

  MultiHopEngineM$MonitorTimer$start(TIMER_ONE_SHOT, MultiHopEngineM$WDT_UPDATE_UNIT);

  MultiHopEngineM$RouteStatusTimer$start(TIMER_REPEAT, MultiHopEngineM$ROUTE_STATUS_CHECK_PERIOD);
  return MultiHopEngineM$SubControl$start();
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$initTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(4U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
inline static  result_t SmartSensingM$SensingTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = RealTimeM$Timer$start(0U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
inline static  result_t RealTimeM$WatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(5U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   void RealTimeM$Clock$setInterval(uint32_t arg_0x408ca068){
#line 105
  RTCClockM$MicroClock$setInterval(arg_0x408ca068);
#line 105
}
#line 105
# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealTimeM$ClockControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = RTCClockM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 120 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$StdControl$start(void)
#line 120
{
  RealTimeM$ClockControl$start();
  RealTimeM$Clock$setInterval(RealTimeM$uc_fire_point);
  RealTimeM$WatchTimer$start(TIMER_REPEAT, 1024);
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
# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void GPSSensorM$GPSInterrupt$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(93, arg_0x406321d8);
#line 45
}
#line 45
# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GPSSensorM$GPIOControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = PXA27XGPIOIntM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 121 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setIER(uint32_t val)
#line 121
{
#line 121
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x04) = val;
}

# 50 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setIER(uint32_t arg_0x40c208c8){
#line 50
  HplPXA27xBTUARTP$UART$setIER(arg_0x40c208c8);
#line 50
}
#line 50
# 147 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline  result_t HalPXA27xBTUARTP$SerialControl$start(void)
#line 147
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 148
    {

      HalPXA27xBTUARTP$UART$setIER((1 << 6) | (1 << 0));
    }
#line 151
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t GPSSensorM$GPSSerialControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = HalPXA27xBTUARTP$SerialControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 153 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  result_t GPSSensorM$StdControl$start(void)
#line 153
{
  if (GPSSensorM$started != TRUE) {
      GPSSensorM$GPSSerialControl$start();
      GPSSensorM$GPIOControl$start();
      GPSSensorM$GPSInterrupt$enable(1);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 158
        GPSSensorM$started = TRUE;
#line 158
        __nesc_atomic_end(__nesc_atomic); }
      TOS_post(GPSSensorM$selfCheckTask);
    }
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t ADCM$ClockControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = RTCClockM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
inline static  result_t ADCM$InternalControl$start(void){
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
# 78 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline  result_t ADCM$StdControl$start(void)
#line 78
{
  ADCM$InternalControl$start();
  ADCM$ClockControl$start();
  return SUCCESS;
}

# 126 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static inline  result_t FlashManagerM$StdControl$start(void)
#line 126
{

  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t DataMgmtM$BatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(15U, arg_0x40818878, arg_0x40818a10);
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
# 169 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$StdControl$start(void)
#line 169
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
  result = rcombine(result, FlashManagerM$StdControl$start());
#line 70
  result = rcombine(result, ADCM$StdControl$start());
#line 70
  result = rcombine(result, GPSSensorM$StdControl$start());
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 28 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
inline static  void *SmartSensingM$DataMgmt$allocBlk(uint8_t arg_0x40abb7b8){
#line 28
  void *result;
#line 28

#line 28
  result = DataMgmtM$DataMgmt$allocBlk(arg_0x40abb7b8);
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 89 "/opt/tinyos-1.x/tos/interfaces/ADCControl.nc"
inline static  result_t SmartSensingM$ADCControl$bindPort(uint8_t arg_0x40aa4340, uint8_t arg_0x40aa44c8){
#line 89
  unsigned char result;
#line 89

#line 89
  result = ADCM$ADCControl$bindPort(arg_0x40aa4340, arg_0x40aa44c8);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 128 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline void SmartSensingM$initDefault(void)
#line 128
{
  SmartSensingM$initedClock = FALSE;





  SmartSensingM$defaultCode = (PRIORITIZE_FUNC << TASK_CODE_SIZE) | RSAM_FUNC;

  restartRSAM = 1;



  SmartSensingM$LQIFactor = 0;
  sensor_num = 0;
  SmartSensingM$sensingCurBlk = (void *)0;



  if ((void *)0 != (sensor[GPS_CLIENT_ID].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(GPS_CLIENT_ID))) {
      sensor[GPS_CLIENT_ID].samplingRate = 0;
      sensor[GPS_CLIENT_ID].timerCount = 0;
      sensor[GPS_CLIENT_ID].type = TYPE_DATA_GPS;
      sensor[GPS_CLIENT_ID].maxBlkNum = GPS_BLK_NUM;
      sensor[GPS_CLIENT_ID].dataPriority = GPS_DATA_PRIORITY;
      ++sensor_num;
    }

  if ((void *)0 != (sensor[RSAM1_CLIENT_ID].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(RSAM1_CLIENT_ID))) {
      sensor[RSAM1_CLIENT_ID].samplingRate = 0;
      sensor[RSAM1_CLIENT_ID].timerCount = 0;
      sensor[RSAM1_CLIENT_ID].type = TYPE_DATA_RSAM1;
      sensor[RSAM1_CLIENT_ID].maxBlkNum = RSAM_BLK_NUM;
      sensor[RSAM1_CLIENT_ID].dataPriority = RSAM1_DATA_PRIORITY;
      ++sensor_num;
    }

  if ((void *)0 != (sensor[RSAM2_CLIENT_ID].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(RSAM2_CLIENT_ID))) {
      sensor[RSAM2_CLIENT_ID].samplingRate = 0;
      sensor[RSAM2_CLIENT_ID].timerCount = 0;
      sensor[RSAM2_CLIENT_ID].type = TYPE_DATA_RSAM2;
      sensor[RSAM2_CLIENT_ID].maxBlkNum = RSAM_BLK_NUM;
      sensor[RSAM2_CLIENT_ID].dataPriority = RSAM2_DATA_PRIORITY;
      ++sensor_num;
    }


  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / SEISMIC_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_SEISMIC;
      sensor[sensor_num].channel = TOSH_ACTUAL_SEISMIC_PORT;
      sensor[sensor_num].dataPriority = SEISMIC_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_SEISMIC_PORT);
      ++sensor_num;
    }


  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / INFRASONIC_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_INFRASONIC;
      sensor[sensor_num].channel = TOSH_ACTUAL_INFRASONIC_PORT;
      sensor[sensor_num].dataPriority = INFRASONIC_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_INFRASONIC_PORT);
      ++sensor_num;
    }


  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / LIGHTNING_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_LIGHTNING;
      sensor[sensor_num].channel = TOSH_ACTUAL_LIGHTNING_PORT;
      sensor[sensor_num].dataPriority = LIGHTNING_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_LIGHTNING_PORT);
      ++sensor_num;
    }

  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / RVOL_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_RVOL;
      sensor[sensor_num].channel = TOSH_ACTUAL_RVOL_PORT;
      sensor[sensor_num].dataPriority = RVOL_DATA_PRIORITY;
      SmartSensingM$ADCControl$bindPort(sensor_num, TOSH_ACTUAL_RVOL_PORT);
      ++sensor_num;
    }

  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / LQI_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_LQI;

      sensor[sensor_num].dataPriority = LQI_DATA_PRIORITY;

      ++sensor_num;
    }

  if ((void *)0 != (sensor[sensor_num].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(sensor_num))) {
      sensor[sensor_num].samplingRate = 1000UL / SEISMIC_RATE;
      sensor[sensor_num].timerCount = 0;
      sensor[sensor_num].type = TYPE_DATA_COMPRESS;

      sensor[sensor_num].dataPriority = SEISMIC_DATA_PRIORITY;
    }



  SmartSensingM$updateMaxBlkNum();
  SmartSensingM$timerInterval = SmartSensingM$calFireInterval();
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t SmartSensingM$Random$rand(void){
#line 63
  unsigned short result;
#line 63

#line 63
  result = RandomLFSR$Random$rand();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 289 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$StdControl$start(void)
#line 289
{
  uint16_t randomtimer;

#line 291
  randomtimer = (SmartSensingM$Random$rand() & 0xff) + 0xf;
  SmartSensingM$initDefault();

  ;
  SmartSensingM$SubControl$start();
  SmartSensingM$TimerControl$start();
  SmartSensingM$SensingTimer$start(TIMER_ONE_SHOT, randomtimer);

  SmartSensingM$initTimer$start(TIMER_ONE_SHOT, 1024 * 25);

  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SettingsM$StackCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(2U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 89 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  result_t SettingsM$StdControl$start(void)
#line 89
{









  SettingsM$StackCheckTimer$start(TIMER_REPEAT, 5000);





  SettingsM$ResetCause = * (volatile uint32_t *)0x40F00030;
  * (volatile uint32_t *)0x40F00030 = 0xf;

  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t PMICM$batteryMonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(1U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 362 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline void PMICM$startLDOs(void)
#line 362
{
  uint8_t oldVal;
#line 363
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



  PMICM$readPMIC(0x97, &oldVal, 1);
  newVal = oldVal & ~0x1;
  PMICM$writePMIC(0x97, newVal);
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void PMICM$PMICInterrupt$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(1, arg_0x406321d8);
#line 45
}
#line 45
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PMICM$PI2CInterrupt$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(6);
#line 46
}
#line 46
# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t PMICM$GPIOIRQControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = PXA27XGPIOIntM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 402 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  result_t PMICM$StdControl$start(void)
#line 402
{

  uint8_t val[3];
  uint8_t mask;
  static bool start = 0;

  if (start == 0) {
      PMICM$GPIOIRQControl$start();
      PMICM$PI2CInterrupt$enable();

      PMICM$PMICInterrupt$enable(2);





      PMICM$writePMIC(0x08, (
      0x80 | 0x8) | 0x4);


      mask = (1 | (1 << 2)) | (1 << 7);
      PMICM$writePMIC(0x05, ~mask);
      mask = 1 | (1 << 1);
      PMICM$writePMIC(0x06, ~mask);
      PMICM$writePMIC(0x07, 0xFF);


      PMICM$readPMIC(0x01, val, 3);




      PMICM$startLDOs();





      PMICM$PMIC$enableCharging(TRUE);


      PMICM$batteryMonitorTimer$start(TIMER_REPEAT, 60 * 5 * 1000);

      start = 1;
    }
  return SUCCESS;
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XClockM$OSTIrq$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(7);
#line 46
}
#line 46
# 124 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static inline  result_t PXA27XClockM$StdControl$start(void)
#line 124
{


  * (volatile uint32_t *)0x40A000C4 = (1 << 7) | (0x2 & 0x7);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 128
    {
      * (volatile uint32_t *)0x40A0001C |= 1 << 5;
      * (volatile uint32_t *)0x40A00044 = 0x1;
    }
#line 131
    __nesc_atomic_end(__nesc_atomic); }
  PXA27XClockM$OSTIrq$enable();
#line 152
  return SUCCESS;
}

# 77 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static  result_t STUARTM$RxDMAChannel$requestChannel(DMAPeripheralID_t arg_0x405402f8, DMAPriority_t arg_0x405404a0, bool arg_0x40540630){
#line 77
  unsigned char result;
#line 77

#line 77
  result = PXA27XDMAM$PXA27XDMAChannel$requestChannel(0U, arg_0x405402f8, arg_0x405404a0, arg_0x40540630);
#line 77

#line 77
  return result;
#line 77
}
#line 77
#line 192
inline static  result_t STUARTM$RxDMAChannel$setTransferWidth(DMATransferWidth_t arg_0x4054d358){
#line 192
  unsigned char result;
#line 192

#line 192
  result = PXA27XDMAM$PXA27XDMAChannel$setTransferWidth(0U, arg_0x4054d358);
#line 192

#line 192
  return result;
#line 192
}
#line 192
#line 172
inline static  result_t STUARTM$RxDMAChannel$setMaxBurstSize(DMAMaxBurstSize_t arg_0x4054e720){
#line 172
  unsigned char result;
#line 172

#line 172
  result = PXA27XDMAM$PXA27XDMAChannel$setMaxBurstSize(0U, arg_0x4054e720);
#line 172

#line 172
  return result;
#line 172
}
#line 172










inline static   result_t STUARTM$RxDMAChannel$setTransferLength(uint16_t arg_0x4054ed20){
#line 182
  unsigned char result;
#line 182

#line 182
  result = PXA27XDMAM$PXA27XDMAChannel$setTransferLength(0U, arg_0x4054ed20);
#line 182

#line 182
  return result;
#line 182
}
#line 182
#line 161
inline static  result_t STUARTM$RxDMAChannel$enableTargetFlowControl(bool arg_0x4054e188){
#line 161
  unsigned char result;
#line 161

#line 161
  result = PXA27XDMAM$PXA27XDMAChannel$enableTargetFlowControl(0U, arg_0x4054e188);
#line 161

#line 161
  return result;
#line 161
}
#line 161
#line 152
inline static  result_t STUARTM$RxDMAChannel$enableSourceFlowControl(bool arg_0x4053fbd8){
#line 152
  unsigned char result;
#line 152

#line 152
  result = PXA27XDMAM$PXA27XDMAChannel$enableSourceFlowControl(0U, arg_0x4053fbd8);
#line 152

#line 152
  return result;
#line 152
}
#line 152
#line 143
inline static  result_t STUARTM$RxDMAChannel$enableTargetAddrIncrement(bool arg_0x4053f608){
#line 143
  unsigned char result;
#line 143

#line 143
  result = PXA27XDMAM$PXA27XDMAChannel$enableTargetAddrIncrement(0U, arg_0x4053f608);
#line 143

#line 143
  return result;
#line 143
}
#line 143
#line 133
inline static  result_t STUARTM$RxDMAChannel$enableSourceAddrIncrement(bool arg_0x4053f030){
#line 133
  unsigned char result;
#line 133

#line 133
  result = PXA27XDMAM$PXA27XDMAChannel$enableSourceAddrIncrement(0U, arg_0x4053f030);
#line 133

#line 133
  return result;
#line 133
}
#line 133
#line 123
inline static   result_t STUARTM$RxDMAChannel$setTargetAddr(uint32_t arg_0x4053aaa8){
#line 123
  unsigned char result;
#line 123

#line 123
  result = PXA27XDMAM$PXA27XDMAChannel$setTargetAddr(0U, arg_0x4053aaa8);
#line 123

#line 123
  return result;
#line 123
}
#line 123
#line 113
inline static   result_t STUARTM$RxDMAChannel$setSourceAddr(uint32_t arg_0x4053a528){
#line 113
  unsigned char result;
#line 113

#line 113
  result = PXA27XDMAM$PXA27XDMAChannel$setSourceAddr(0U, arg_0x4053a528);
#line 113

#line 113
  return result;
#line 113
}
#line 113
# 217 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline void STUARTM$configureRxDMA(uint8_t *RxBuffer, uint16_t NumBytes, bool bEnableTargetAddrIncrement)
#line 217
{
  STUARTM$RxDMAChannel$setSourceAddr(0x40700000);
  STUARTM$RxDMAChannel$setTargetAddr((uint32_t )RxBuffer);
  STUARTM$RxDMAChannel$enableSourceAddrIncrement(FALSE);
  STUARTM$RxDMAChannel$enableTargetAddrIncrement(bEnableTargetAddrIncrement);
  STUARTM$RxDMAChannel$enableSourceFlowControl(TRUE);
  STUARTM$RxDMAChannel$enableTargetFlowControl(FALSE);
  STUARTM$RxDMAChannel$setTransferLength(NumBytes);

  STUARTM$RxDMAChannel$setMaxBurstSize(DMA_8ByteBurst);
  STUARTM$RxDMAChannel$setTransferWidth(DMA_4ByteWidth);
}

#line 146
static inline result_t STUARTM$openRxPort(bool bRxDMAIntEnable)
#line 146
{

  result_t status = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 150
    {
      if (STUARTM$gRxPortInUse == TRUE) {
          status = FAIL;
        }
      else {
          STUARTM$gRxPortInUse = TRUE;
        }
    }
#line 157
    __nesc_atomic_end(__nesc_atomic); }
  if (status == FAIL) {
      return FAIL;
    }

  if (STUARTM$gPortInitialized == FALSE) {
      STUARTM$initPort();
      STUARTM$gPortInitialized = TRUE;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 167
    {
      if (STUARTM$gTxPortInUse == FALSE) {

          STUARTM$configPort();
        }
    }
#line 172
    __nesc_atomic_end(__nesc_atomic); }

  return SUCCESS;
}

# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void STUARTM$UARTInterrupt$disable(void){
#line 47
  PXA27XInterruptM$PXA27XIrq$disable(20);
#line 47
}
#line 47
# 240 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline  result_t STUARTM$BulkTxRx$BulkReceive(uint8_t *RxBuffer, uint16_t NumBytes)
#line 240
{

  if (!RxBuffer || !NumBytes) {
      return FAIL;
    }


  STUARTM$UARTInterrupt$disable();


  if (STUARTM$openRxPort(TRUE) == FAIL) {
      return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 253
    {
      STUARTM$gRxBuffer = RxBuffer;
      STUARTM$gRxNumBytes = NumBytes;
      STUARTM$gNumRxFifoOverruns = 0;
      STUARTM$gRxBufferPos = 0;
    }
#line 258
    __nesc_atomic_end(__nesc_atomic); }


  STUARTM$configureRxDMA(RxBuffer, NumBytes, TRUE);

  STUARTM$RxDMAChannel$requestChannel(DMAID_STUART_RX, DMA_Priority4, FALSE);


  return SUCCESS;
}

# 27 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
inline static  result_t BufferedSTUARTM$BulkTxRx$BulkReceive(uint8_t *arg_0x40501dd8, uint16_t arg_0x404f4010){
#line 27
  unsigned char result;
#line 27

#line 27
  result = STUARTM$BulkTxRx$BulkReceive(arg_0x40501dd8, arg_0x404f4010);
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 39 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static inline  result_t BufferedSTUARTM$StdControl$start(void)
#line 39
{

  uint8_t *rxBuffer = getNextBuffer(&BufferedSTUARTM$receiveBufferSet);

  BufferedSTUARTM$BulkTxRx$BulkReceive(rxBuffer, 10);
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t BluSHM$UartControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = BufferedSTUARTM$StdControl$start();
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 257 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$StdControl$start(void)
{
  BluSHM$UartControl$start();
  generalSend("\r\n", 2);
  generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
  return SUCCESS;
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XDMAM$Interrupt$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(25);
#line 46
}
#line 46
# 129 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline  result_t PXA27XDMAM$StdControl$start(void)
#line 129
{

  PXA27XDMAM$Interrupt$enable();

  return SUCCESS;
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XUSBClientM$USBInterrupt$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(11);
#line 46
}
#line 46
# 200 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline  result_t PXA27XUSBClientM$Control$start(void)
#line 200
{
  PXA27XUSBClientM$USBInterrupt$enable();
  return SUCCESS;
}

# 74 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static inline  result_t FlashM$StdControl$start(void)
#line 74
{
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/StdControl.nc"
inline static  result_t RealMain$StdControl$start(void){
#line 70
  unsigned char result;
#line 70

#line 70
  result = FlashM$StdControl$start();
#line 70
  result = rcombine(result, PXA27XUSBClientM$Control$start());
#line 70
  result = rcombine(result, PXA27XGPIOIntM$StdControl$start());
#line 70
  result = rcombine(result, PXA27XDMAM$StdControl$start());
#line 70
  result = rcombine(result, BluSHM$StdControl$start());
#line 70
  result = rcombine(result, PXA27XClockM$StdControl$start());
#line 70
  result = rcombine(result, PMICM$StdControl$start());
#line 70
  result = rcombine(result, SettingsM$StdControl$start());
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
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XGPIOIntM$GPIOIrq0$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(8);
#line 46
}
#line 46
inline static   void PXA27XGPIOIntM$GPIOIrq1$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(9);
#line 46
}
#line 46
inline static   void PXA27XGPIOIntM$GPIOIrq$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(10);
#line 46
}
#line 46
#line 45
inline static   result_t STUARTM$UARTInterrupt$allocate(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = PXA27XInterruptM$PXA27XIrq$allocate(20);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 204 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   result_t STUARTM$TxDMAChannel$run(DMAInterruptEnable_t arg_0x4054d948){
#line 204
  unsigned char result;
#line 204

#line 204
  result = PXA27XDMAM$PXA27XDMAChannel$run(1U, arg_0x4054d948);
#line 204

#line 204
  return result;
#line 204
}
#line 204
# 368 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline  result_t STUARTM$TxDMAChannel$requestChannelDone(void)
#line 368
{

  STUARTM$TxDMAChannel$run(TRUE);

  return SUCCESS;
}

# 204 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   result_t STUARTM$RxDMAChannel$run(DMAInterruptEnable_t arg_0x4054d948){
#line 204
  unsigned char result;
#line 204

#line 204
  result = PXA27XDMAM$PXA27XDMAChannel$run(0U, arg_0x4054d948);
#line 204

#line 204
  return result;
#line 204
}
#line 204
# 269 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline  result_t STUARTM$RxDMAChannel$requestChannelDone(void)
#line 269
{

  STUARTM$RxDMAChannel$run(DMA_ENDINTEN | DMA_EORINTEN);

  return SUCCESS;
}

# 944 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  result_t HPLCC2420M$TxDMAChannel$requestChannelDone(void)
#line 944
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 945
    {
#line 945
      HPLCC2420M$gbDMAChannelInitDone -= 1;
    }
#line 946
    __nesc_atomic_end(__nesc_atomic); }
#line 946
  return SUCCESS;
}

#line 908
static inline  result_t HPLCC2420M$RxDMAChannel$requestChannelDone(void)
#line 908
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 909
    {
#line 909
      HPLCC2420M$gbDMAChannelInitDone -= 1;
    }
#line 910
    __nesc_atomic_end(__nesc_atomic); }
#line 910
  return SUCCESS;
}

# 245 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline   result_t PXA27XDMAM$PXA27XDMAChannel$default$requestChannelDone(uint8_t channel)
#line 245
{
  return FAIL;
}

# 86 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static  result_t PXA27XDMAM$PXA27XDMAChannel$requestChannelDone(uint8_t arg_0x40593790){
#line 86
  unsigned char result;
#line 86

#line 86
  switch (arg_0x40593790) {
#line 86
    case 0U:
#line 86
      result = STUARTM$RxDMAChannel$requestChannelDone();
#line 86
      break;
#line 86
    case 1U:
#line 86
      result = STUARTM$TxDMAChannel$requestChannelDone();
#line 86
      break;
#line 86
    case 2U:
#line 86
      result = HPLCC2420M$RxDMAChannel$requestChannelDone();
#line 86
      break;
#line 86
    case 3U:
#line 86
      result = HPLCC2420M$TxDMAChannel$requestChannelDone();
#line 86
      break;
#line 86
    default:
#line 86
      result = PXA27XDMAM$PXA27XDMAChannel$default$requestChannelDone(arg_0x40593790);
#line 86
      break;
#line 86
    }
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 142 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline void PXA27XDMAM$postRequestChannelDone(uint32_t arg)
#line 142
{
  uint8_t channel = (uint8_t )arg;

#line 144
  PXA27XDMAM$PXA27XDMAChannel$requestChannelDone(channel);
}

#line 146
static inline void PXA27XDMAM$_postRequestChannelDoneveneer(void)
#line 146
{
#line 146
  uint32_t argument;

#line 146
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 146
    {
#line 146
      popqueue(&paramtaskQueue, &argument);
    }
#line 147
    __nesc_atomic_end(__nesc_atomic); }
#line 146
  PXA27XDMAM$postRequestChannelDone(argument);
}

# 194 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  void PMICM$printReadPMICBusError(void)
#line 194
{
  trace(DBG_USR1, "FATAL ERROR:  readPMIC() Unable to obtain bus\r\n");
}

static inline  void PMICM$printReadPMICAddresError(void)
#line 198
{
  trace(DBG_USR1, "FATAL ERROR:  readPMIC() Unable to send address\r\n");
}

static inline  void PMICM$printReadPMICSlaveAddresError(void)
#line 202
{
  trace(DBG_USR1, "FATAL ERROR: readPMIC() unable to write slave address\r\n");
}

static inline  void PMICM$printReadPMICReadByteError(void)
#line 206
{
  trace(DBG_USR1, "FATAL ERROR:  readPMIC() Unable to read byte from PMIC\r\n");
}

#line 133
static inline uint8_t PMICM$getChargerVoltage(void)
#line 133
{
  uint8_t chargerVoltage;

#line 135
  PMICM$getPMICADCVal(2, &chargerVoltage);
  return chargerVoltage;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t PMICM$chargeMonitorTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(0U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 245 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static inline   uint32_t PXA27XClockM$Clock$readCounter(void)
#line 245
{


  return * (volatile uint32_t *)0x40A00044;
}

# 153 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   uint32_t TimerM$Clock$readCounter(void){
#line 153
  unsigned int result;
#line 153

#line 153
  result = PXA27XClockM$Clock$readCounter();
#line 153

#line 153
  return result;
#line 153
}
#line 153
# 262 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$DataMgmt$freeBlkByType(uint8_t type)
#line 262
{
  result_t result = FAIL;
  SenBlkPtr p = headMemElement(&DataMgmtM$sensorMem, MEMPENDING);
  int16_t nextInd = -1;

#line 266
  while (p != (void *)0) {
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
      while (p != (void *)0) {
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
      return (void *)0;
    }
  if (bufQueue->total >= bufQueue->size) {
      ;
      return (void *)0;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 171
    head = bufQueue->head[FREEMEM];
#line 171
    __nesc_atomic_end(__nesc_atomic); }
  if (-1 != head) {
      if (FAIL == _private_changeMemStatusByIndex(bufQueue, head, FREEMEM, FILLING)) {
          ;
          return (void *)0;
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
      return (void *)0;
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
# 888 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static __inline uint16_t SmartSensingM$GCD(uint16_t a, uint16_t b)
#line 888
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

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void RTCClockM$OSTIrq$enable(void){
#line 46
  PXA27XInterruptM$PXA27XIrq$enable(7);
#line 46
}
#line 46
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t GPSSensorM$CheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(6U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 237 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$HPLCC2420WriteContentionError(void)
#line 237
{
  trace(DBG_USR1, "ERROR:  HPLCC2420.write has attempted to access the radio during an existing radio operation\r\n");
}

static inline  void HPLCC2420M$HPLCC2420WriteError(void)
#line 241
{
  trace(DBG_USR1, "ERROR:  HPLCC2420.write failed while attempting to release the SSP port\r\n");
}

#line 198
static inline  void HPLCC2420M$HPLCC2420CmdReleaseError(void)
#line 198
{
  trace(DBG_USR1, "ERROR:  HPLCC2420.cmd failed while attempting to release the SSP port\r\n");
}

# 181 "/opt/tinyos-1.x/tos/platform/pxa27x/pxa27xhardware.h"
 __inline void __nesc_atomic_end(__nesc_atomic_t oldState)
{



  uint32_t statusReg = 0;

  oldState &= 0x000000C0;
#line 202
   __asm volatile (
  "mrs %0,CPSR\n\t"
  "bic %0, %1, %2\n\t"
  "orr %0, %1, %3\n\t"
  "msr CPSR_c, %1" : 
  "=r"(statusReg) : 
  "0"(statusReg), "i"(0x000000C0), "r"(oldState));


  return;
}


static __inline void __nesc_enable_interrupt(void)
#line 215
{


  uint32_t statusReg = 0;

   __asm volatile (
  "mrs %0,CPSR\n\t"
  "bic %0,%1,#0x80\n\t"
  "msr CPSR_c, %1" : 
  "=r"(statusReg) : 
  "0"(statusReg));

  return;
}

static __inline void __nesc_atomic_sleep(void)
{




  __nesc_enable_interrupt();
  return;
}

#line 156
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
#line 178
  return result;
}

# 164 "/opt/tinyos-1.x/tos/platform/imote2/sched.c"
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
  TOSH_queue[old_full].executeTime = * (volatile uint32_t *)0x40A00010;
  __nesc_atomic_end(fInterruptFlags);
  func();
  TOSH_queue[old_full].executeTime = * (volatile uint32_t *)0x40A00010 - TOSH_queue[old_full].executeTime;

  return 1;
}

static inline void TOSH_run_task(void)
#line 192
{
  for (; ; ) 
    TOSH_run_next_task();
}

# 414 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline  void STUARTM$printUARTError(void)
#line 414
{
  trace(DBG_USR1, "UART ERROR\r\n");
}

# 63 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
inline static   uint8_t *STUARTM$BulkTxRx$BulkReceiveDone(uint8_t *arg_0x404f3720, uint16_t arg_0x404f38b8){
#line 63
  unsigned char *result;
#line 63

#line 63
  result = BufferedSTUARTM$BulkTxRx$BulkReceiveDone(arg_0x404f3720, arg_0x404f38b8);
#line 63

#line 63
  return result;
#line 63
}
#line 63








inline static   uint8_t *STUARTM$BulkTxRx$BulkTransmitDone(uint8_t *arg_0x404ff190, uint16_t arg_0x404ff328){
#line 71
  unsigned char *result;
#line 71

#line 71
  result = BufferedSTUARTM$BulkTxRx$BulkTransmitDone(arg_0x404ff190, arg_0x404ff328);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 418 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline   void STUARTM$UARTInterrupt$fired(void)
#line 418
{
  uint8_t error;
#line 419
  uint8_t intSource = * (volatile uint32_t *)0x40700008;

#line 420
  intSource = (intSource >> 1) & 0x3;
  switch (intSource) {
      case 0: 

        break;
      case 1: 


        if (STUARTM$gTxBuffer) {
            if (STUARTM$gTxBufferPos < STUARTM$gTxNumBytes) {

                * (volatile uint32_t *)0x40700000 = STUARTM$gTxBuffer[STUARTM$gTxBufferPos];
                STUARTM$gTxBufferPos++;
              }
            else {

                STUARTM$gTxBuffer = STUARTM$BulkTxRx$BulkTransmitDone(STUARTM$gTxBuffer, 
                STUARTM$gTxNumBytes);
                if (STUARTM$gTxBuffer) {
                    * (volatile uint32_t *)0x40700000 = STUARTM$gTxBuffer[0];
                    STUARTM$gTxBufferPos = 1;
                  }
                else {
                    STUARTM$gTxBufferPos = 0;
                    STUARTM$closeTxPort();
                  }
              }
          }
      break;
      case 2: 

        if (STUARTM$gRxBuffer) {
            while (* (volatile uint32_t *)0x40700014 & (1 << 0)) {
                STUARTM$gRxBuffer[STUARTM$gRxBufferPos] = * (volatile uint32_t *)0x40700000;
                STUARTM$gRxBufferPos++;
                if (STUARTM$gRxBufferPos == STUARTM$gRxNumBytes) {
                    STUARTM$gRxBuffer = STUARTM$BulkTxRx$BulkReceiveDone(STUARTM$gRxBuffer, 
                    STUARTM$gRxNumBytes);
                    STUARTM$gRxBufferPos = 0;
                    if (STUARTM$gRxBuffer == (void *)0) {
                        STUARTM$closeRxPort();
                      }
                  }
              }
          }

      break;
      case 3: 

        error = * (volatile uint32_t *)0x40700014;
      TOS_post(STUARTM$printUARTError);
      break;
    }
  return;
}

# 182 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   result_t STUARTM$TxDMAChannel$setTransferLength(uint16_t arg_0x4054ed20){
#line 182
  unsigned char result;
#line 182

#line 182
  result = PXA27XDMAM$PXA27XDMAChannel$setTransferLength(1U, arg_0x4054ed20);
#line 182

#line 182
  return result;
#line 182
}
#line 182
#line 113
inline static   result_t STUARTM$TxDMAChannel$setSourceAddr(uint32_t arg_0x4053a528){
#line 113
  unsigned char result;
#line 113

#line 113
  result = PXA27XDMAM$PXA27XDMAChannel$setSourceAddr(1U, arg_0x4053a528);
#line 113

#line 113
  return result;
#line 113
}
#line 113
# 390 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline   void STUARTM$TxDMAChannel$endInterrupt(uint16_t numBytesSent)
#line 390
{

  STUARTM$gTxBuffer = STUARTM$BulkTxRx$BulkTransmitDone(STUARTM$gTxBuffer, 
  STUARTM$gTxNumBytes);
  if (STUARTM$gTxBuffer) {



      STUARTM$TxDMAChannel$setSourceAddr((uint32_t )STUARTM$gTxBuffer);
      STUARTM$TxDMAChannel$setTransferLength(STUARTM$gTxNumBytes);
      STUARTM$TxDMAChannel$run(TRUE);
    }
  else {
      STUARTM$closeTxPort();
    }
  return;
}

#line 315
static inline   void STUARTM$RxDMAChannel$endInterrupt(uint16_t numBytesSent)
#line 315
{

  STUARTM$handleRxDMADone(numBytesSent);
  return;
}

# 961 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$HPLCC2420TxDmaEndInterrupt(void)
#line 961
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.writeTXFIFO DMA version failed while attempting to release the SSP port\r\n");
}

#line 964
static inline   void HPLCC2420M$TxDMAChannel$endInterrupt(uint16_t numBytesSent)
#line 964
{
  uint8_t tmp;
#line 965
  uint8_t localIgnoreTxDMA;

#line 966
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 966
    {
      localIgnoreTxDMA = HPLCC2420M$gbIgnoreTxDMA;
    }
#line 968
    __nesc_atomic_end(__nesc_atomic); }
  if (localIgnoreTxDMA == FALSE) {
      * (volatile uint32_t *)0x41900004 &= ~(1 << 21);

      while (* (volatile uint32_t *)0x41900008 & (1 << 3)) {
          tmp = * (volatile uint32_t *)0x41900010;
        }
      {
#line 975
        TOSH_uwait(1);
#line 975
        TOSH_SET_CC_CSN_PIN();
      }
#line 975
      ;
      if (HPLCC2420M$releaseSSPPort() == FAIL) {
          TOS_post(HPLCC2420M$HPLCC2420TxDmaEndInterrupt);
        }

      TOS_post(HPLCC2420M$signalTXFIFO);
    }
  return;
}

#line 925
static inline  void HPLCC2420M$HPLCC2420RxDMAEndInterruptReleaseError(void)
#line 925
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.readRXFIFO DMA version failed while attempting to release the SSP port\r\n");
}

static inline   void HPLCC2420M$RxDMAChannel$endInterrupt(uint16_t numBytesSent)
#line 929
{

  {
#line 931
    TOSH_uwait(1);
#line 931
    TOSH_SET_CC_CSN_PIN();
  }
#line 931
  ;
  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420RxDMAEndInterruptReleaseError);
    }

  * (volatile uint32_t *)0x41900004 &= ~(1 << 20);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 937
    {
      invalidateDCache(HPLCC2420M$rxbuf, HPLCC2420M$rxlen);
    }
#line 939
    __nesc_atomic_end(__nesc_atomic); }
  TOS_post(HPLCC2420M$signalRXFIFO);
  return;
}

# 404 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline    void PXA27XDMAM$PXA27XDMAChannel$default$endInterrupt(uint8_t channel, uint16_t numByteSent)
#line 404
{
  return;
}

# 236 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   void PXA27XDMAM$PXA27XDMAChannel$endInterrupt(uint8_t arg_0x40593790, uint16_t arg_0x4054cc28){
#line 236
  switch (arg_0x40593790) {
#line 236
    case 0U:
#line 236
      STUARTM$RxDMAChannel$endInterrupt(arg_0x4054cc28);
#line 236
      break;
#line 236
    case 1U:
#line 236
      STUARTM$TxDMAChannel$endInterrupt(arg_0x4054cc28);
#line 236
      break;
#line 236
    case 2U:
#line 236
      HPLCC2420M$RxDMAChannel$endInterrupt(arg_0x4054cc28);
#line 236
      break;
#line 236
    case 3U:
#line 236
      HPLCC2420M$TxDMAChannel$endInterrupt(arg_0x4054cc28);
#line 236
      break;
#line 236
    default:
#line 236
      PXA27XDMAM$PXA27XDMAChannel$default$endInterrupt(arg_0x40593790, arg_0x4054cc28);
#line 236
      break;
#line 236
    }
#line 236
}
#line 236
# 385 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline   void STUARTM$TxDMAChannel$eorInterrupt(uint16_t numBytesLeft)
#line 385
{

  return;
}

#line 310
static inline   void STUARTM$RxDMAChannel$eorInterrupt(uint16_t numBytesSent)
#line 310
{

  STUARTM$handleRxDMADone(numBytesSent);
}

# 957 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$TxDMAChannel$eorInterrupt(uint16_t numBytesSent)
#line 957
{
  return;
}

#line 921
static inline   void HPLCC2420M$RxDMAChannel$eorInterrupt(uint16_t numBytesSent)
#line 921
{
  return;
}

# 400 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline    void PXA27XDMAM$PXA27XDMAChannel$default$eorInterrupt(uint8_t channel, uint16_t numBytesSent)
#line 400
{
  return;
}

# 249 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   void PXA27XDMAM$PXA27XDMAChannel$eorInterrupt(uint8_t arg_0x40593790, uint16_t arg_0x4054a280){
#line 249
  switch (arg_0x40593790) {
#line 249
    case 0U:
#line 249
      STUARTM$RxDMAChannel$eorInterrupt(arg_0x4054a280);
#line 249
      break;
#line 249
    case 1U:
#line 249
      STUARTM$TxDMAChannel$eorInterrupt(arg_0x4054a280);
#line 249
      break;
#line 249
    case 2U:
#line 249
      HPLCC2420M$RxDMAChannel$eorInterrupt(arg_0x4054a280);
#line 249
      break;
#line 249
    case 3U:
#line 249
      HPLCC2420M$TxDMAChannel$eorInterrupt(arg_0x4054a280);
#line 249
      break;
#line 249
    default:
#line 249
      PXA27XDMAM$PXA27XDMAChannel$default$eorInterrupt(arg_0x40593790, arg_0x4054a280);
#line 249
      break;
#line 249
    }
#line 249
}
#line 249
# 380 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline   void STUARTM$TxDMAChannel$stopInterrupt(uint16_t numBytesLeft)
#line 380
{

  return;
}

#line 299
static inline   void STUARTM$RxDMAChannel$stopInterrupt(uint16_t numbBytesSent)
#line 299
{
}

# 953 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$TxDMAChannel$stopInterrupt(uint16_t numbBytesSent)
#line 953
{
  return;
}

#line 917
static inline   void HPLCC2420M$RxDMAChannel$stopInterrupt(uint16_t numbBytesSent)
#line 917
{
  return;
}

# 392 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline    void PXA27XDMAM$PXA27XDMAChannel$default$stopInterrupt(uint8_t channel, uint16_t numBytesSent)
#line 392
{
  return;
}

# 260 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   void PXA27XDMAM$PXA27XDMAChannel$stopInterrupt(uint8_t arg_0x40593790, uint16_t arg_0x4054a8e0){
#line 260
  switch (arg_0x40593790) {
#line 260
    case 0U:
#line 260
      STUARTM$RxDMAChannel$stopInterrupt(arg_0x4054a8e0);
#line 260
      break;
#line 260
    case 1U:
#line 260
      STUARTM$TxDMAChannel$stopInterrupt(arg_0x4054a8e0);
#line 260
      break;
#line 260
    case 2U:
#line 260
      HPLCC2420M$RxDMAChannel$stopInterrupt(arg_0x4054a8e0);
#line 260
      break;
#line 260
    case 3U:
#line 260
      HPLCC2420M$TxDMAChannel$stopInterrupt(arg_0x4054a8e0);
#line 260
      break;
#line 260
    default:
#line 260
      PXA27XDMAM$PXA27XDMAChannel$default$stopInterrupt(arg_0x40593790, arg_0x4054a8e0);
#line 260
      break;
#line 260
    }
#line 260
}
#line 260
# 375 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline   void STUARTM$TxDMAChannel$startInterrupt(void)
#line 375
{

  return;
}

#line 296
static inline   void STUARTM$RxDMAChannel$startInterrupt(void)
#line 296
{
}

# 949 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$TxDMAChannel$startInterrupt(void)
#line 949
{
  return;
}

#line 913
static inline   void HPLCC2420M$RxDMAChannel$startInterrupt(void)
#line 913
{
  return;
}

# 396 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline    void PXA27XDMAM$PXA27XDMAChannel$default$startInterrupt(uint8_t channel)
#line 396
{
  return;
}

# 268 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static   void PXA27XDMAM$PXA27XDMAChannel$startInterrupt(uint8_t arg_0x40593790){
#line 268
  switch (arg_0x40593790) {
#line 268
    case 0U:
#line 268
      STUARTM$RxDMAChannel$startInterrupt();
#line 268
      break;
#line 268
    case 1U:
#line 268
      STUARTM$TxDMAChannel$startInterrupt();
#line 268
      break;
#line 268
    case 2U:
#line 268
      HPLCC2420M$RxDMAChannel$startInterrupt();
#line 268
      break;
#line 268
    case 3U:
#line 268
      HPLCC2420M$TxDMAChannel$startInterrupt();
#line 268
      break;
#line 268
    default:
#line 268
      PXA27XDMAM$PXA27XDMAChannel$default$startInterrupt(arg_0x40593790);
#line 268
      break;
#line 268
    }
#line 268
}
#line 268
# 140 "/opt/tinyos-1.x/tos/platform/pxa27x/pxa27xhardware.h"
static __inline uint32_t _pxa27x_clzui(uint32_t i)
#line 140
{
  uint32_t count;

#line 142
   __asm volatile ("clz %0,%1" : 
  "=r"(count) : 
  "r"(i));

  return count;
}

# 411 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static inline   void PXA27XDMAM$Interrupt$fired(void)
{
  uint32_t IntReg;
  uint32_t realChannel;
#line 414
  uint32_t virtualChannel;
#line 414
  uint32_t status;
#line 414
  uint32_t update;
#line 414
  uint32_t dcmd;
  uint16_t currentLength;

  IntReg = * (volatile uint32_t *)0x400000F0;



  realChannel = 31 - _pxa27x_clzui(IntReg);
  virtualChannel = PXA27XDMAM$mPriorityMap[realChannel].virtualChannel;
  currentLength = PXA27XDMAM$mChannelArray[virtualChannel].length;

  status = * (volatile uint32_t *)(0x40000000 + realChannel * 4);
  dcmd = * (volatile uint32_t *)(0x4000020C + realChannel * 16);

  update = (status & 0xFFA00000) | (1 << 22);

  if (status & 1) {

      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update | 1;
    }

  if (status & (1 << 1)) {

      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update | (1 << 1);
      if (dcmd & (1 << 22)) {

          PXA27XDMAM$PXA27XDMAChannel$startInterrupt(virtualChannel);
        }
    }


  if (status & ((1 << 3) | (1 << 29))) {
      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update & (1 << 29);
      PXA27XDMAM$PXA27XDMAChannel$stopInterrupt(virtualChannel, currentLength - (* (volatile uint32_t *)(0x4000020C + realChannel * 16) & 0x1FFF));
    }

  if (status & ((1 << 4) | (1 << 23))) {
      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update | (1 << 4);
    }

  if (status & (1 << 9)) {

      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update | (1 << 9);
      if (status & (1 << 28)) {

          PXA27XDMAM$PXA27XDMAChannel$eorInterrupt(virtualChannel, currentLength - (* (volatile uint32_t *)(0x4000020C + realChannel * 16) & 0x1FFF));
        }
    }

  if (status & (1 << 2)) {

      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = update | (1 << 2);
      if (dcmd & (1 << 21)) {

          PXA27XDMAM$PXA27XDMAChannel$endInterrupt(virtualChannel, currentLength);
        }
    }

  globalDMAVirtualChannelHandled = virtualChannel;

  return;
}

# 137 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static inline   void PXA27XGPIOIntM$GPIOIrq$fired(void)
{

  uint32_t DetectReg;
  uint8_t pin;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 144
    DetectReg = * (volatile uint32_t *)0x40E00048 & ~((1 << 1) | (1 << 0));
#line 144
    __nesc_atomic_end(__nesc_atomic); }

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      PXA27XGPIOIntM$PXA27XGPIOInt$fired(pin);
      DetectReg &= ~(1 << pin);
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 152
    DetectReg = * (volatile uint32_t *)0x40E0004C;
#line 152
    __nesc_atomic_end(__nesc_atomic); }

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      PXA27XGPIOIntM$PXA27XGPIOInt$fired(pin + 32);
      DetectReg &= ~(1 << pin);
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 160
    DetectReg = * (volatile uint32_t *)0x40E00050;
#line 160
    __nesc_atomic_end(__nesc_atomic); }

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      PXA27XGPIOIntM$PXA27XGPIOInt$fired(pin + 64);
      DetectReg &= ~(1 << pin);
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 168
    DetectReg = * (volatile uint32_t *)0x40E00148;
#line 168
    __nesc_atomic_end(__nesc_atomic); }

  while (DetectReg) {
      pin = 31 - _pxa27x_clzui(DetectReg);
      PXA27XGPIOIntM$PXA27XGPIOInt$fired(pin + 96);
      DetectReg &= ~(1 << pin);
    }

  return;
}






static inline   void PXA27XGPIOIntM$GPIOIrq1$fired(void)
{
  PXA27XGPIOIntM$PXA27XGPIOInt$fired(1);
}

#line 179
static inline   void PXA27XGPIOIntM$GPIOIrq0$fired(void)
{
  PXA27XGPIOIntM$PXA27XGPIOInt$fired(0);
}

# 583 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$retrieveOut(void)
#line 583
{
  uint16_t i = 0;
  uint8_t *buff;
  uint32_t temp;
  uint8_t bufflen;

  for (i = 0; i < 4; i++) 
    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 590
      PXA27XUSBClientM$OutStream[i].endpointDR = (volatile unsigned long *const )0x40600308;
#line 590
      __nesc_atomic_end(__nesc_atomic); }

  bufflen = PXA27XUSBClientM$Device.oConfigurations[1]->oInterfaces[0]->oEndpoints[1]->wMaxPacketSize;
  buff = (uint8_t *)safe_malloc(bufflen);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 595
    {
      for (i = 0; (* (volatile uint32_t *)(PXA27XUSBClientM$OutStream[0].endpointDR - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600200) & 0x1FF) > 0 && i < bufflen; i += 4) {
          temp = * (volatile uint32_t *)PXA27XUSBClientM$OutStream[0].endpointDR;
          * (uint32_t *)(buff + i) = temp;
        }
    }
#line 600
    __nesc_atomic_end(__nesc_atomic); }
  PXA27XUSBClientM$DynQueue_enqueue(PXA27XUSBClientM$OutQueue, buff);
#line 615
  TOS_post(PXA27XUSBClientM$processOut);
}

#line 416
static inline   result_t PXA27XUSBClientM$BareSendMsg$default$sendDone(TOS_MsgPtr msg, result_t success)
#line 416
{
  return SUCCESS;
}

# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t PXA27XUSBClientM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8){
#line 67
  unsigned char result;
#line 67

#line 67
  result = PXA27XUSBClientM$BareSendMsg$default$sendDone(arg_0x4061e348, arg_0x4061e4d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 469 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$USBSend$sendDone(uint8_t *packet, uint8_t type, result_t success)
{
  BluSHdata temp;

#line 472
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 472
    {
      temp = (BluSHdata )BluSHM$DynQueue_peek(BluSHM$OutQueue);
    }
#line 474
    __nesc_atomic_end(__nesc_atomic); }
  if (temp->src == packet) {
      safe_free(packet);
      safe_free(temp);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 478
        {
          BluSHM$DynQueue_dequeue(BluSHM$OutQueue);
        }
#line 480
        __nesc_atomic_end(__nesc_atomic); }
    }
  return SUCCESS;
}

# 411 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   result_t PXA27XUSBClientM$SendJTPacket$default$sendDone(uint8_t channel, uint8_t *packet, uint8_t type, 
result_t success)
#line 412
{
  return SUCCESS;
}

# 28 "/opt/tinyos-1.x/tos/platform/pxa27x/SendJTPacket.nc"
inline static  result_t PXA27XUSBClientM$SendJTPacket$sendDone(uint8_t arg_0x4065c5b8, uint8_t *arg_0x40614b20, uint8_t arg_0x40614ca8, result_t arg_0x40614e38){
#line 28
  unsigned char result;
#line 28

#line 28
  switch (arg_0x4065c5b8) {
#line 28
    case 0U:
#line 28
      result = BluSHM$USBSend$sendDone(arg_0x40614b20, arg_0x40614ca8, arg_0x40614e38);
#line 28
      break;
#line 28
    default:
#line 28
      result = PXA27XUSBClientM$SendJTPacket$default$sendDone(arg_0x4065c5b8, arg_0x40614b20, arg_0x40614ca8, arg_0x40614e38);
#line 28
      break;
#line 28
    }
#line 28

#line 28
  return result;
#line 28
}
#line 28
# 407 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   result_t PXA27XUSBClientM$SendVarLenPacket$default$sendDone(uint8_t *packet, result_t success)
#line 407
{
  return SUCCESS;
}

# 62 "/opt/tinyos-1.x/tos/interfaces/SendVarLenPacket.nc"
inline static  result_t PXA27XUSBClientM$SendVarLenPacket$sendDone(uint8_t *arg_0x406168e8, result_t arg_0x40616a78){
#line 62
  unsigned char result;
#line 62

#line 62
  result = PXA27XUSBClientM$SendVarLenPacket$default$sendDone(arg_0x406168e8, arg_0x40616a78);
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 227 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   void PXA27XUSBClientM$USBInterrupt$fired(void)
#line 227
{
  uint32_t statusreg;
  uint8_t statetemp;
  PXA27XUSBClientM$DynQueue QueueTemp;
  PXA27XUSBClientM$USBdata InStateTemp;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 233
    statetemp = PXA27XUSBClientM$state;
#line 233
    __nesc_atomic_end(__nesc_atomic); }




  switch (statetemp) {
      case 1: 
        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 240
          {
            if ((* (volatile uint32_t *)0x40600010 & (1 << (27 & 0x1f))) != 0) {
                PXA27XUSBClientM$state = 2;
                * (volatile uint32_t *)0x40600010 = 1 << (27 & 0x1f);
              }

            if ((* (volatile uint32_t *)0x4060000C & (1 << (0 & 0x1f))) != 0) {
              * (volatile uint32_t *)0x4060000C = 1 << (0 & 0x1f);
              }
#line 248
            if ((* (volatile uint32_t *)0x4060000C & (1 << (2 & 0x1f))) != 0) {
              * (volatile uint32_t *)0x4060000C = 1 << (2 & 0x1f);
              }
#line 250
            if ((* (volatile uint32_t *)0x4060000C & (1 << (4 & 0x1f))) != 0) {
              * (volatile uint32_t *)0x4060000C = 1 << (4 & 0x1f);
              }
#line 252
            if ((* (volatile uint32_t *)0x40600010 & (1 << (31 & 0x1f))) != 0) {
              * (volatile uint32_t *)0x40600010 = 1 << (31 & 0x1f);
              }
          }
#line 255
          __nesc_atomic_end(__nesc_atomic); }
#line 255
      break;
      case 2: 
        case 3: 
          if ((* (volatile uint32_t *)0x40600010 & (1 << (27 & 0x1f))) != 0) {
              PXA27XUSBClientM$clearIn();
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 260
                {
                  PXA27XUSBClientM$state = 2;
                  * (volatile uint32_t *)0x40600010 = 1 << (27 & 0x1f);
                }
#line 263
                __nesc_atomic_end(__nesc_atomic); }
            }

      if ((* (volatile uint32_t *)0x40600010 & (1 << (31 & 0x1f))) != 0) {
          PXA27XUSBClientM$handleControlSetup();
          * (volatile uint32_t *)0x40600010 = 1 << (31 & 0x1f);
        }
      else {
#line 270
        if ((* (volatile uint32_t *)0x4060000C & (1 << (0 & 0x1f))) != 0) {
            {
              statusreg = * (volatile uint32_t *)0x40600100;
              * (volatile uint32_t *)0x4060000C = 1 << (0 & 0x1f);
            }
            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 275
              InStateTemp = PXA27XUSBClientM$InState;
#line 275
              __nesc_atomic_end(__nesc_atomic); }
            if ((statusreg & (1 << (7 & 0x1f))) != 0) {
                PXA27XUSBClientM$handleControlSetup();
              }
            else {
#line 279
              if (InStateTemp != (void *)0 && InStateTemp->endpointDR == (volatile unsigned long *const )0x40600300 && 
              InStateTemp->index != 0) 
                {
                  if (!((InStateTemp->status & (1 << (1 & 0x1f))) != 0)) {



                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 286
                        QueueTemp = PXA27XUSBClientM$InQueue;
#line 286
                        __nesc_atomic_end(__nesc_atomic); }
                      PXA27XUSBClientM$clearUSBdata((PXA27XUSBClientM$USBdata )PXA27XUSBClientM$DynQueue_dequeue(QueueTemp), 0);
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 288
                        PXA27XUSBClientM$InState = (void *)0;
#line 288
                        __nesc_atomic_end(__nesc_atomic); }
                      if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) > 0) {
                        PXA27XUSBClientM$sendControlIn();
                        }
                      else {
#line 292
                        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 292
                          PXA27XUSBClientM$InTask = 0;
#line 292
                          __nesc_atomic_end(__nesc_atomic); }
                        }
                    }
                  else 
#line 294
                    {



                      PXA27XUSBClientM$sendControlIn();
                    }
                }
              else 
                {
                }
              }
          }
        }
      if ((* (volatile uint32_t *)0x4060000C & (1 << (2 & 0x1f))) != 0) {



          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 311
            statetemp = PXA27XUSBClientM$state;
#line 311
            __nesc_atomic_end(__nesc_atomic); }
          * (volatile uint32_t *)0x4060000C = 1 << (2 & 0x1f);
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 313
            InStateTemp = PXA27XUSBClientM$InState;
#line 313
            __nesc_atomic_end(__nesc_atomic); }
          if (statetemp != 3) {
            * (volatile uint32_t *)0x40600108 |= 1 << (1 & 0x1f);
            }
          else {
#line 317
            if (
#line 316
            InStateTemp != (void *)0 && InStateTemp->endpointDR == (volatile unsigned long *const )0x40600304 && 
            InStateTemp->index != 0 && statetemp == 3) 
              {


                if (!((InStateTemp->status & (1 << (1 & 0x1f))) != 0)) {



                    if (InStateTemp->source == 0) {
                      PXA27XUSBClientM$SendVarLenPacket$sendDone(InStateTemp->src, SUCCESS);
                      }
                    else {
#line 327
                      if (InStateTemp->source == 1) {
                        PXA27XUSBClientM$SendJTPacket$sendDone(InStateTemp->channel, InStateTemp->src, 
                        InStateTemp->type, SUCCESS);
                        }
                      else {
#line 330
                        if (InStateTemp->source == 2) {
                          PXA27XUSBClientM$BareSendMsg$sendDone((TOS_MsgPtr )InStateTemp->src, 
                          SUCCESS);
                          }
                        }
                      }
#line 333
                    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 333
                      QueueTemp = PXA27XUSBClientM$InQueue;
#line 333
                      __nesc_atomic_end(__nesc_atomic); }
                    PXA27XUSBClientM$clearUSBdata((PXA27XUSBClientM$USBdata )PXA27XUSBClientM$DynQueue_dequeue(QueueTemp), 1);
                    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 335
                      PXA27XUSBClientM$InState = (void *)0;
#line 335
                      __nesc_atomic_end(__nesc_atomic); }
                    if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) > 0) {
                      TOS_post(PXA27XUSBClientM$sendIn);
                      }
                    else {
#line 339
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 339
                        PXA27XUSBClientM$InTask = 0;
#line 339
                        __nesc_atomic_end(__nesc_atomic); }
                      }
                  }
                else {



                    TOS_post(PXA27XUSBClientM$sendIn);
                  }
              }
            }
        }
#line 350
      if ((* (volatile uint32_t *)0x4060000C & (1 << (4 & 0x1f))) != 0) {




          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 355
            statetemp = PXA27XUSBClientM$state;
#line 355
            __nesc_atomic_end(__nesc_atomic); }
          * (volatile uint32_t *)0x4060000C = 1 << (4 & 0x1f);
          if (statetemp == 3) {
            PXA27XUSBClientM$retrieveOut();
            }
          else 
#line 359
            {
              * (volatile uint32_t *)0x40600108 = 1 << (1 & 0x1f);
            }
        }

      break;
      default: 
        if ((* (volatile uint32_t *)0x4060000C & (1 << (0 & 0x1f))) != 0) {
          * (volatile uint32_t *)0x4060000C = 1 << (0 & 0x1f);
          }
#line 368
      if ((* (volatile uint32_t *)0x4060000C & (1 << (2 & 0x1f))) != 0) {
        * (volatile uint32_t *)0x4060000C = 1 << (2 & 0x1f);
        }
#line 370
      if ((* (volatile uint32_t *)0x4060000C & (1 << (4 & 0x1f))) != 0) {
        * (volatile uint32_t *)0x4060000C = 1 << (4 & 0x1f);
        }
#line 372
      if ((* (volatile uint32_t *)0x40600010 & (1 << (31 & 0x1f))) != 0) {
        * (volatile uint32_t *)0x40600010 = 1 << (31 & 0x1f);
        }
#line 374
      if ((* (volatile uint32_t *)0x40600010 & (1 << (27 & 0x1f))) != 0) {
        * (volatile uint32_t *)0x40600010 = 1 << (27 & 0x1f);
        }
#line 376
      break;
    }
}

# 459 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline   void PMICM$PI2CInterrupt$fired(void)
#line 459
{
  uint32_t status;
#line 460
  uint32_t update = 0;

#line 461
  status = * (volatile uint32_t *)0x40F00198;
  if (status & (1 << 6)) {
      update |= 1 << 6;
    }


  if (status & (1 << 10)) {
      update |= 1 << 10;
    }

  * (volatile uint32_t *)0x40F00198 = update;
}

# 105 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   void TimerM$Clock$setInterval(uint32_t arg_0x408ca068){
#line 105
  PXA27XClockM$Clock$setInterval(arg_0x408ca068);
#line 105
}
#line 105
# 196 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static inline void TimerM$enqueue(uint8_t value)
#line 196
{
  if (TimerM$queue_tail == NUM_TIMERS - 1) {
    TimerM$queue_tail = -1;
    }
#line 199
  TimerM$queue_tail++;
  TimerM$queue_size++;
  TimerM$queue[(uint8_t )TimerM$queue_tail] = value;
}

# 139 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline uint8_t PMICM$getBatteryVoltage(void)
#line 139
{
  uint8_t batteryVoltage;

#line 141
  PMICM$getPMICADCVal(0, &batteryVoltage);
  return batteryVoltage;
}

#line 716
static inline  result_t PMICM$batteryMonitorTimer$fired(void)
#line 716
{
  uint8_t vBat;

  vBat = PMICM$getBatteryVoltage();
  trace(DBG_USR1, "Battery Status:  Current Battery Voltage is %.3fV\r\n", vBat * .01035 + 2.65);
  if (vBat * .01035 + 2.65 < 3.4) {

      PMICM$smartChargeEnable();
    }

  if (vBat * .01035 + 2.65 < 3.3) {
      trace(DBG_USR1, "Battery voltage is below minimum of %f....turning off mote\r\n", 3.3);
    }

  return SUCCESS;
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t PMICM$chargeMonitorTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(0U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 733 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  result_t PMICM$chargeMonitorTimer$fired(void)
#line 733
{
  uint8_t vBat;
#line 734
  uint8_t vChg;
#line 734
  uint8_t iChg;
#line 734
  uint8_t chargeControl;

#line 735
  PMICM$PMIC$chargingStatus(&vBat, &vChg, &iChg, &chargeControl);

  trace(DBG_USR1, "Charging Status:  vBat = %.3fV %vChg = %.3fV iChg = %.3fA chargeControl =%#x\r\n", 
  vBat * .01035 + 2.65, 
  vChg * 6 * .01035, 
  iChg * .01035 / 1.656, 
  chargeControl);

  if (vBat * .01035 + 2.65 > 4.0) {
      trace(DBG_USR1, "Charging Status:  Battery is charged...Battery Voltage is %.3fV\r\n", vBat * .01035 + 2.65);
      PMICM$PMIC$enableCharging(FALSE);
      PMICM$chargeMonitorTimer$stop();
    }
  return SUCCESS;
}

# 260 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  result_t SettingsM$StackCheckTimer$fired(void)
#line 260
{






  extern uint32_t _SVC_MODE_STACK;
#line 267
  extern uint32_t _IRQ_MODE_STACK;
#line 267
  extern uint32_t _FIQ_MODE_STACK;
#line 267
  extern uint32_t _UND_MODE_STACK;
#line 267
  extern uint32_t _ABT_MODE_STACK;

#line 268
  (void )(_SVC_MODE_STACK == 0xDEADBEEF || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc", (int )268, "_SVC_MODE_STACK == 0xDEADBEEF"), 0));
  (void )(_IRQ_MODE_STACK == 0xDEADBEEF || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc", (int )269, "_IRQ_MODE_STACK == 0xDEADBEEF"), 0));
  (void )(_FIQ_MODE_STACK == 0xDEADBEEF || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc", (int )270, "_FIQ_MODE_STACK == 0xDEADBEEF"), 0));
  (void )(_UND_MODE_STACK == 0xDEADBEEF || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc", (int )271, "_UND_MODE_STACK == 0xDEADBEEF"), 0));
  (void )(_ABT_MODE_STACK == 0xDEADBEEF || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc", (int )272, "_ABT_MODE_STACK == 0xDEADBEEF"), 0));
#line 307
  return SUCCESS;
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$initTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(4U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 84 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420Control.nc"
inline static  result_t GenericCommProM$CC2420Control$TunePreset(uint8_t arg_0x40940010){
#line 84
  unsigned char result;
#line 84

#line 84
  result = CC2420ControlM$CC2420Control$TunePreset(arg_0x40940010);
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 737 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$initRFChannel(uint8_t channel)
#line 737
{
  if (channel >= 11 && channel <= 26) {
      return GenericCommProM$CC2420Control$TunePreset(channel);
    }
  else {
    return FAIL;
    }
}

# 62 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
inline static  result_t FlashManagerM$initRFChannel(uint8_t arg_0x41041bc8){
#line 62
  unsigned char result;
#line 62

#line 62
  result = GenericCommProM$initRFChannel(arg_0x41041bc8);
#line 62

#line 62
  return result;
#line 62
}
#line 62
#line 146
static inline  result_t FlashManagerM$FlashManager$init(void)
#line 146
{
  uint8_t i;
  uint8_t j;
  uint32_t destAddr = 0;
  uint32_t length = 0;
  static uint16_t addrindex = 0;
  uint32_t temp = 0;


  if (addrindex == 0) {
      destAddr = BASE_ADDR + 2 * addrindex;
      FlashManagerM$FlashManager$read(destAddr, (void *)&FlashManagerM$FlashFlag, 2);
      ;
      if (1 != FlashManagerM$FlashFlag) {
          addrindex = 0;
          return FAIL;
        }
      else 
#line 162
        {
          addrindex++;
        }
    }


  if (addrindex == 1) {
      destAddr = BASE_ADDR + 2 * addrindex;
      FlashManagerM$FlashManager$read(destAddr, (void *)&FlashManagerM$ProgID, 4);
      ;
      if (FlashManagerM$ProgID == G_Ident.unix_time) {
          ;
          addrindex++;
        }
      else 
#line 175
        {
          addrindex = 0;
          return FAIL;
        }
    }

  if (addrindex == 2) {
      destAddr = BASE_ADDR + 3 * addrindex;
      FlashManagerM$FlashManager$read(destAddr, (void *)&FlashManagerM$RFChannel, 2);
      ;
      FlashManagerM$buffer_fw.RFChannel = FlashManagerM$RFChannel;
      FlashManagerM$initRFChannel((uint8_t )FlashManagerM$RFChannel);
      addrindex++;
    }

  if (addrindex > 2) {
      length = 5 * sizeof(SensorClient_t );
      destAddr = BASE_ADDR + 8;
      if (FlashManagerM$FlashManager$read(destAddr, (void *)FlashManagerM$sensor_I, length)) {
          if (0xFFFF != FlashManagerM$sensor_I[0].samplingRate && FlashManagerM$sensor_I[0].samplingRate > 0) {
              for (i = 3; i < 7; i++) {
                  j = i - 3;
                  sensor[i].samplingRate = FlashManagerM$sensor_I[j].samplingRate;
                  sensor[i].channel = FlashManagerM$sensor_I[j].channel;
                  sensor[i].type = FlashManagerM$sensor_I[j].type;
                }
              ;
            }
          else {
              return FAIL;
            }
        }
      addrindex = 0;
    }

  return SUCCESS;
}

# 29 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
inline static  result_t SmartSensingM$FlashManager$init(void){
#line 29
  unsigned char result;
#line 29

#line 29
  result = FlashManagerM$FlashManager$init();
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 253 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$initTimer$fired(void)
#line 253
{
  ;

  if (SmartSensingM$FlashManager$init() == SUCCESS) {
      SmartSensingM$updateMaxBlkNum();
      SmartSensingM$setrate();
      ;
      SmartSensingM$initTimer$stop();
    }
  else 
#line 261
    {
      ;
    }
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$SensingTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = RealTimeM$Timer$stop(0U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t SmartSensingM$LocalTime$read(void){
#line 27
  unsigned int result;
#line 27

#line 27
  result = RealTimeM$LocalTime$read();
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 39 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  uint32_t SmartSensingM$RealTime$getTimeCount(void){
#line 39
  unsigned int result;
#line 39

#line 39
  result = RealTimeM$RealTime$getTimeCount();
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 616 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$WatchTimer$fired(void)
#line 616
{
  uint32_t temptimeW = 0;
  uint32_t templocaltime = 0;

  if (!SmartSensingM$realTimeFired) {
      temptimeW = SmartSensingM$RealTime$getTimeCount();
      templocaltime = SmartSensingM$LocalTime$read();







      SmartSensingM$SensingTimer$stop();
      SmartSensingM$SensingTimer$start(TIMER_REPEAT, SmartSensingM$timerInterval);
    }
  SmartSensingM$realTimeFired = FALSE;
}

# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t RealTimeM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 457 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$WatchTimer$fired(void)
#line 457
{
  uint16_t i = 0;

#line 459
  if (!RealTimeM$realTimeFired) {

      for (i = 0; i < MAX_NUM_CLIENT; i++) {
          RealTimeM$EventReport$eventSend(EVENT_TYPE_DATAMANAGE, 
          EVENT_LEVEL_URGENT, 
          eventprintf("RTC STOP at firecount[%i] %i of globaltime %i g_H %i.\n", i, RealTimeM$clientList[i].fireCount, RealTimeM$globaltime_t, RealTimeM$globaltime_tHist));
        }
    }


  RealTimeM$realTimeFired = FALSE;
}

# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t GPSSensorM$LocalTime$read(void){
#line 27
  unsigned int result;
#line 27

#line 27
  result = RealTimeM$LocalTime$read();
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t GPSSensorM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 262 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$RealTime$changeMode(uint8_t modeValue)
#line 262
{
  RealTimeM$syncMode = modeValue;
  RealTimeM$is_synced = FALSE;








  return SUCCESS;
}

# 43 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  result_t GPSSensorM$RealTime$changeMode(uint8_t arg_0x40abd648){
#line 43
  unsigned char result;
#line 43

#line 43
  result = RealTimeM$RealTime$changeMode(arg_0x40abd648);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 623 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  void GPSSensorM$changeModeTask(void)
#line 623
{
  GPSSensorM$RealTime$changeMode(FTSP_SYNC);


  GPSSensorM$EventReport$eventSend(EVENT_TYPE_SENSING, EVENT_LEVEL_URGENT, 
  eventprintf("Node %i to FTSP at LTime %i pps_index %i \n", TOS_LOCAL_ADDRESS, GPSSensorM$LocalTime$read(), GPSSensorM$ppsIndex));
}

# 276 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  uint8_t RealTimeM$RealTime$getMode(void)
#line 276
{
  return RealTimeM$syncMode;
}

# 44 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  uint8_t GPSSensorM$RealTime$getMode(void){
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
# 648 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  result_t GPSSensorM$CheckTimer$fired(void)
#line 648
{







  if (GPSSensorM$last_pps_index == GPSSensorM$ppsIndex && GPSSensorM$checkTimerOn == TRUE) {

      if (GPSSensorM$RealTime$getMode() == GPS_SYNC) {
          TOS_post(GPSSensorM$changeModeTask);
        }

      GPSSensorM$hasGPS = FALSE;
      GPSSensorM$alreadySetTime = FALSE;
    }

  GPSSensorM$checkTimerOn = FALSE;
  TOS_post(GPSSensorM$selfCheckTask);
  return SUCCESS;
}

# 108 "/opt/tinyos-1.x/tos/system/WDTM.nc"
static inline  void WDTM$WDT$reset(void)
#line 108
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 109
    {
      WDTM$remaining = WDTM$increment;
    }
#line 111
    __nesc_atomic_end(__nesc_atomic); }
}

# 48 "/opt/tinyos-1.x/tos/interfaces/WDT.nc"
inline static  void SNMSM$WWDT$reset(void){
#line 48
  WDTM$WDT$reset();
#line 48
}
#line 48
# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SNMSM$SNMSTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(7U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 187 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  result_t SNMSM$SNMSTimer$fired(void)
#line 187
{
  if (SNMSM$toBeRestart) {
      SNMSM$rstdelayCount++;
      if (SNMSM$rstdelayCount >= 50) {
        SNMSM$SNMSTimer$stop();
        }
    }
#line 193
  SNMSM$WWDT$reset();
  return SUCCESS;
}

# 65 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdogM.nc"
static inline  void PXA27XWatchdogM$PXA27XWatchdog$feedWDT(uint32_t interval)
#line 65
{
  if (!PXA27XWatchdogM$resetMoteRequest) {
      * (volatile uint32_t *)0x40A0000C = * (volatile uint32_t *)0x40A00010 + interval;
    }
}

# 70 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdog.nc"
inline static  void HPLWatchdogM$PXA27XWatchdog$feedWDT(uint32_t arg_0x408a78a8){
#line 70
  PXA27XWatchdogM$PXA27XWatchdog$feedWDT(arg_0x408a78a8);
#line 70
}
#line 70
# 67 "/opt/tinyos-1.x/tos/platform/pxa27x/HPLWatchdogM.nc"
static inline  void HPLWatchdogM$reset(void)
#line 67
{
  HPLWatchdogM$PXA27XWatchdog$feedWDT(3250000);
}

# 50 "/opt/tinyos-1.x/tos/system/WDTM.nc"
inline static  void WDTM$reset(void){
#line 50
  HPLWatchdogM$reset();
#line 50
}
#line 50
#line 87
static inline  result_t WDTM$Timer$fired(void)
#line 87
{
  if (WDTM$increment != 0) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 89
        {
          WDTM$remaining = WDTM$remaining - WDTM$WDT_LATENCY;
        }
#line 91
        __nesc_atomic_end(__nesc_atomic); }
    }
  if (WDTM$remaining > 0) {
    WDTM$reset();
    }
#line 95
  return SUCCESS;
}

# 747 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline void TimeSyncM$timeSyncMsgSend(void)
#line 747
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

# 251 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  bool RealTimeM$RealTime$isSync(void)
#line 251
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
# 782 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$Timer$fired(void)
#line 782
{








  if (TimeSyncM$RealTime$getMode() == GPS_SYNC) {
      if (TimeSyncM$RealTime$isSync()) {
          TimeSyncM$mode = TS_USER_MODE;
        }
    }
  else {
#line 796
    TimeSyncM$mode = TS_TIMER_MODE;
    }
  TimeSyncM$timeSyncMsgSend();
  return SUCCESS;
}

# 280 "/home/xu/oasis/lib/SNMS/SNMSM.nc"
static inline  void SNMSM$restart(void)
#line 280
{


  SNMSM$rstdelayCount = 0;
  SNMSM$toBeRestart = TRUE;
}

# 111 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
inline static  void GenericCommProM$restart(void){
#line 111
  SNMSM$restart();
#line 111
}
#line 111
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t GenericCommProM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 341 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$MonitorTimer$fired(void)
#line 341
{
  if (GenericCommProM$wdtTimerCnt++ < COMM_WDT_UPDATE_PERIOD) {
      return SUCCESS;
    }
  GenericCommProM$wdtTimerCnt = 0;
  if (!GenericCommProM$radioRecvActive) {
      GenericCommProM$EventReport$eventSend(EVENT_TYPE_SNMS, 
      EVENT_LEVEL_URGENT, eventprintf("Comm: Restart For No Recv"));
      GenericCommProM$restart();
    }
  else {
#line 350
    if (!GenericCommProM$radioSendActive) {
        GenericCommProM$EventReport$eventSend(EVENT_TYPE_SNMS, 
        EVENT_LEVEL_URGENT, eventprintf("Comm: Restart For No Send"));
        GenericCommProM$restart();
      }
    else 
#line 354
      {
        GenericCommProM$radioRecvActive = FALSE;
        GenericCommProM$radioSendActive = FALSE;
      }
    }
#line 358
  return SUCCESS;
}

#line 333
static inline  result_t GenericCommProM$ActivityTimer$fired(void)
#line 333
{
  GenericCommProM$lastCount = GenericCommProM$counter;
  GenericCommProM$counter = 0;
  GenericCommProM$tryNextSend();
  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t FlashManagerM$WritingTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(13U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 326 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static inline  void FlashM$Flash$setFlashPartitionState(uint32_t addr)
{
  addr = addr / 0x20000 * 0x20000;
  FlashM$FlashPartitionState[addr / 0x200000] = 0;
}

# 54 "/home/xu/oasis/lib/SmartSensing/Flash.nc"
inline static  void FlashManagerM$Flash$setFlashPartitionState(uint32_t arg_0x40ad0ad8){
#line 54
  FlashM$Flash$setFlashPartitionState(arg_0x40ad0ad8);
#line 54
}
#line 54
# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t FlashManagerM$EraseCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(14U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 373 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static inline  result_t FlashManagerM$EraseCheckTimer$fired(void)
#line 373
{
  uint16_t status = 0xFFFF;

  status = __GetEraseStatus(BASE_ADDR);
  if (!(status & 0x80)) {
      FlashManagerM$EraseCheckTimer$start(TIMER_ONE_SHOT, 200);
    }
  else 
#line 379
    {
      status = __EraseFlashSpin(BASE_ADDR);
      FlashManagerM$Flash$setFlashPartitionState(BASE_ADDR);
      if (status != 0x80) {
          ;
        }
      else 
#line 384
        {
          ;
          FlashManagerM$WritingTimer$start(TIMER_ONE_SHOT, 1024 * 5);
        }
    }
  return SUCCESS;
}

#line 361
static inline  result_t FlashManagerM$WritingTimer$fired(void)
#line 361
{
  ;
  if (TRUE != FlashManagerM$writeTaskBusy) {
      TOS_post(FlashManagerM$writeTask);
    }
  else 
#line 365
    {
      FlashManagerM$WritingTimer$start(TIMER_ONE_SHOT, 1024 * 60);
      ;
    }
  return SUCCESS;
}

# 332 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static inline  result_t FlashM$Flash$erase(uint32_t addr)
{
  uint16_t status;
#line 334
  uint16_t i;
  uint32_t j;

  if (addr > 0x02000000) {
    return FAIL;
    }
#line 339
  if (addr < 0x00200000) {
    return FAIL;
    }
  addr = addr / 0x20000 * 0x20000;

  for (i = 0; i < 16; i++) 

    if (
#line 345
    i != addr / 0x200000 && 
    FlashM$FlashPartitionState[i] != 0 && 
    FlashM$FlashPartitionState[i] != 3) 
      {
        trace(DBG_USR1, "Flash partition not read active and inactive\n");
        return FAIL;
      }
  if (FlashM$FlashPartitionState[addr / 0x200000] != 0) 
    {
      trace(DBG_USR1, "Flash Partition not read read inactive %x\n", addr);
      return FAIL;
    }
  FlashM$FlashPartitionState[addr / 0x200000] = 2;

  for (j = 0; j < 0x20000; j++) {
      uint32_t tempCheck = * (uint32_t *)(addr + j);

#line 361
      if (tempCheck != 0xFFFFFFFF) {
        break;
        }
#line 363
      if (j == 0x20000 - 1) {
          FlashM$FlashPartitionState[addr / 0x200000] = 0;
          return SUCCESS;
        }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 368
    {
      FlashM$unlock(addr);
      ;
      status = __Flash_Erase(addr);
      ;

      ;
    }
#line 375
    __nesc_atomic_end(__nesc_atomic); }







  return SUCCESS;
}

# 28 "/home/xu/oasis/lib/SmartSensing/Flash.nc"
inline static  result_t FlashManagerM$Flash$erase(uint32_t arg_0x40ad11d8){
#line 28
  unsigned char result;
#line 28

#line 28
  result = FlashM$Flash$erase(arg_0x40ad11d8);
#line 28

#line 28
  return result;
#line 28
}
#line 28
#line 19
inline static  result_t FlashManagerM$Flash$write(uint32_t arg_0x40ad3868, uint8_t *arg_0x40ad3a10, uint32_t arg_0x40ad3ba8){
#line 19
  unsigned char result;
#line 19

#line 19
  result = FlashM$Flash$write(arg_0x40ad3868, arg_0x40ad3a10, arg_0x40ad3ba8);
#line 19

#line 19
  return result;
#line 19
}
#line 19
# 244 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static inline  void FlashManagerM$eraseTask(void)
#line 244
{
  result_t result;

  FlashManagerM$Flash$write(BASE_ADDR, (void *)&FlashManagerM$buffer_fw, 2);
  result = FlashManagerM$Flash$erase(BASE_ADDR);

  if (result != SUCCESS) {
      ;
    }
  else {
      FlashManagerM$EraseCheckTimer$start(TIMER_ONE_SHOT, 2000);
      ;
    }
}

#line 353
static inline  result_t FlashManagerM$EraseTimer$fired(void)
#line 353
{
  ;
  FlashManagerM$alreadyStart = FALSE;
  TOS_post(FlashManagerM$eraseTask);
  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t DataMgmtM$SysCheckTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(16U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t DataMgmtM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SENSING, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 61 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
inline static  void DataMgmtM$restart(void){
#line 61
  SNMSM$restart();
#line 61
}
#line 61
#line 352
static inline  result_t DataMgmtM$SysCheckTimer$fired(void)
#line 352
{

  if (DataMgmtM$sysCheckCount == 6) {
      DataMgmtM$restart();
      DataMgmtM$sysCheckCount = 0;
    }
  else {
      if (DataMgmtM$sysCheckCount == 5) {
          DataMgmtM$EventReport$eventSend(EVENT_TYPE_SENSING, EVENT_LEVEL_URGENT, 
          eventprintf("Node %i failed to send packet for 5 minutes\n", TOS_LOCAL_ADDRESS));
        }
      ++DataMgmtM$sysCheckCount;
      DataMgmtM$SysCheckTimer$start(TIMER_ONE_SHOT, 60000UL);
    }

  return SUCCESS;
}

#line 329
static inline  result_t DataMgmtM$BatchTimer$fired(void)
#line 329
{
  DataMgmtM$batchTimerCount++;

  DataMgmtM$BatchTimer$start(TIMER_ONE_SHOT, BATCH_TIMER_INTERVAL);
  if (DataMgmtM$processTaskBusy != TRUE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 334
        DataMgmtM$processTaskBusy = TRUE;
#line 334
        __nesc_atomic_end(__nesc_atomic); }

      if ((void *)0 != headMemElement(&DataMgmtM$sensorMem, FILLED) || (void *)0 != headMemElement(&DataMgmtM$sensorMem, MEMPROCESSING)) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 337
            DataMgmtM$processTaskBusy = TOS_post(DataMgmtM$processTask);
#line 337
            __nesc_atomic_end(__nesc_atomic); }
        }
      else 
        {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 341
            DataMgmtM$processTaskBusy = FALSE;
#line 341
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return SUCCESS;
}

# 246 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline  result_t ADCM$Timer$fired(void)
#line 246
{
  return SUCCESS;
}

# 394 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$CascadeControl$deleteDirectChild(address_t childID)
#line 394
{
  CascadesRouterM$delFromChildrenList(childID);
  return SUCCESS;
}

# 4 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$deleteDirectChild(address_t arg_0x41218088){
#line 4
  unsigned char result;
#line 4

#line 4
  result = CascadesRouterM$CascadeControl$deleteDirectChild(arg_0x41218088);
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 187 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline void NeighborMgmtM$updateTable(void)
#line 187
{
  NBRTableEntry *pNbr;
  uint8_t childLiveOrigin = 0;
  uint8_t i = 0;

#line 191
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

#line 183
static inline  void NeighborMgmtM$timerTask(void)
#line 183
{
  NeighborMgmtM$updateTable();
}

#line 69
static inline  result_t NeighborMgmtM$Timer$fired(void)
#line 69
{
  if (NeighborMgmtM$initTime) {
      NeighborMgmtM$initTime = FALSE;
      return NeighborMgmtM$Timer$start(TIMER_REPEAT, 1024);
    }
  else {
      return TOS_post(NeighborMgmtM$timerTask);
    }
}

# 543 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$MultihopCtrl$readyToSend(void)
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
inline static  bool MultiHopLQI$NeighborCtrl$setParent(uint16_t arg_0x40e1d4c0){
#line 5
  unsigned char result;
#line 5

#line 5
  result = NeighborMgmtM$NeighborCtrl$setParent(arg_0x40e1d4c0);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t MultiHopLQI$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 190 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  void MultiHopLQI$TimerTask(void)
#line 190
{
  uint8_t val;

#line 192
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 192
    val = ++MultiHopLQI$gLastHeard;
#line 192
    __nesc_atomic_end(__nesc_atomic); }







  if (!MultiHopLQI$localBeSink && val > MultiHopLQI$BEACON_TIMEOUT) {
      MultiHopLQI$EventReport$eventSend(EVENT_TYPE_SNMS, 
      EVENT_LEVEL_URGENT, eventprintf("Engine:from %i timeout val:%i", MultiHopLQI$gbCurrentParent, val));
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

#line 429
static inline  result_t MultiHopLQI$Timer$fired(void)
#line 429
{
  TOS_post(MultiHopLQI$TimerTask);

  MultiHopLQI$MultihopCtrl$readyToSend();

  if (MultiHopLQI$localBeSink) {
    MultiHopLQI$Timer$start(TIMER_ONE_SHOT, 1024 * MultiHopLQI$gUpdateInterval + 1);
    }
  else {
#line 437
    MultiHopLQI$Timer$start(TIMER_ONE_SHOT, 1024 * MultiHopLQI$gUpdateInterval + 1);
    }
#line 438
  return SUCCESS;
}

# 5 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$parentChanged(address_t arg_0x41218530){
#line 5
  unsigned char result;
#line 5

#line 5
  result = CascadesRouterM$CascadeControl$parentChanged(arg_0x41218530);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 238 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  bool NeighborMgmtM$NeighborCtrl$changeParent(uint16_t *newParent, uint16_t *parentCost, uint16_t *linkEst)
#line 238
{
  uint32_t totalCost = 0xffff;
  uint32_t tempCost = 0x7fff;
  uint8_t bestLinkEntry = 16;
  uint8_t ind = 0;

#line 243
  for (ind = 0; ind < 16; ind++) {
      if (NeighborMgmtM$NeighborTbl[ind].flags & NBRFLAG_VALID) {
          if (NeighborMgmtM$NeighborTbl[ind].relation & (NBR_CHILD | NBR_PARENT) || NeighborMgmtM$NeighborTbl[ind].liveliness == 0) {
              continue;
            }
          tempCost = (uint32_t )NeighborMgmtM$adjustLQI(NeighborMgmtM$NeighborTbl[ind].linkEst) + (uint32_t )NeighborMgmtM$NeighborTbl[ind].parentCost;
          if (tempCost < totalCost) {
              bestLinkEntry = ind;
              totalCost = tempCost;
            }
        }
    }
  if (bestLinkEntry == 16 || totalCost == 0xffff) {
      return FALSE;
    }
  else {
      NeighborMgmtM$NeighborCtrl$clearParent(TRUE);
      *newParent = NeighborMgmtM$NeighborTbl[bestLinkEntry].id;
      *parentCost = NeighborMgmtM$NeighborTbl[bestLinkEntry].parentCost;
      *linkEst = NeighborMgmtM$adjustLQI(NeighborMgmtM$NeighborTbl[bestLinkEntry].linkEst);
      ;
      NeighborMgmtM$NeighborTbl[bestLinkEntry].relation = NBR_PARENT;
      NeighborMgmtM$CascadeControl$parentChanged(*newParent);
      return TRUE;
    }
}

# 4 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$changeParent(uint16_t *arg_0x40e1fc48, uint16_t *arg_0x40e1fdf8, uint16_t *arg_0x40e1d010){
#line 4
  unsigned char result;
#line 4

#line 4
  result = NeighborMgmtM$NeighborCtrl$changeParent(arg_0x40e1fc48, arg_0x40e1fdf8, arg_0x40e1d010);
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 547 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$MultihopCtrl$switchParent(void)
#line 547
{

  if (MultiHopLQI$NeighborCtrl$changeParent(&MultiHopLQI$gbCurrentParent, &MultiHopLQI$gbCurrentCost, &MultiHopLQI$gbCurrentLinkEst)) {
    return SUCCESS;
    }
  else 
#line 551
    {
#line 564
      return FAIL;
    }
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
# 360 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteControl$getParent(void)
#line 360
{
  return MultiHopLQI$gbCurrentParent;
}

# 49 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
inline static  uint16_t MultiHopEngineM$RouteSelectCntl$getParent(void){
#line 49
  unsigned short result;
#line 49

#line 49
  result = MultiHopLQI$RouteControl$getParent();
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 582 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  uint16_t MultiHopEngineM$RouteControl$getParent(void)
#line 582
{
  return MultiHopEngineM$RouteSelectCntl$getParent();
}

#line 523
static inline  result_t MultiHopEngineM$RouteStatusTimer$fired(void)
#line 523
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

#line 42
inline static  void MultiHopEngineM$restart(void){
#line 42
  SNMSM$restart();
#line 42
}
#line 42
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t MultiHopEngineM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SNMS, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 501 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$MonitorTimer$fired(void)
#line 501
{
  if (MultiHopEngineM$wdtTimerCnt++ < MultiHopEngineM$WDT_UPDATE_PERIOD) {
      MultiHopEngineM$MonitorTimer$start(TIMER_ONE_SHOT, MultiHopEngineM$WDT_UPDATE_UNIT);
      return SUCCESS;
    }
  MultiHopEngineM$wdtTimerCnt = 0;
  if (!MultiHopEngineM$beRadioActive) {
      MultiHopEngineM$EventReport$eventSend(EVENT_TYPE_SNMS, 
      EVENT_LEVEL_URGENT, eventprintf("Engine:RST Inactive"));
      MultiHopEngineM$restart();
    }
  else 
#line 511
    {
      MultiHopEngineM$beRadioActive = FALSE;
      MultiHopEngineM$MonitorTimer$start(TIMER_ONE_SHOT, MultiHopEngineM$WDT_UPDATE_UNIT);
    }
  return SUCCESS;
}

# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t CascadesRouterM$SubSend$send(uint8_t arg_0x413687d8, TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0){
#line 83
  unsigned char result;
#line 83

#line 83
  result = CascadesEngineM$MySend$send(arg_0x413687d8, arg_0x409bc330, arg_0x409bc4c0);
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
inline static  result_t CascadesRouterM$ResetTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(24U, arg_0x40818878, arg_0x40818a10);
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
  unsigned short result;
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
inline static  result_t CascadesRouterM$DTTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(23U, arg_0x40818878, arg_0x40818a10);
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
  TOS_MsgPtr tempPtr = (void *)0;
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
  result = TimerM$Timer$stop(22U);
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
  TOS_MsgPtr tempPtr = (void *)0;

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

# 192 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static inline   result_t TimerM$Timer$default$fired(uint8_t id)
#line 192
{
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t TimerM$Timer$fired(uint8_t arg_0x408cf2b8){
#line 73
  unsigned char result;
#line 73

#line 73
  switch (arg_0x408cf2b8) {
#line 73
    case 0U:
#line 73
      result = PMICM$chargeMonitorTimer$fired();
#line 73
      break;
#line 73
    case 1U:
#line 73
      result = PMICM$batteryMonitorTimer$fired();
#line 73
      break;
#line 73
    case 2U:
#line 73
      result = SettingsM$StackCheckTimer$fired();
#line 73
      break;
#line 73
    case 3U:
#line 73
      result = SmartSensingM$WatchTimer$fired();
#line 73
      break;
#line 73
    case 4U:
#line 73
      result = SmartSensingM$initTimer$fired();
#line 73
      break;
#line 73
    case 5U:
#line 73
      result = RealTimeM$WatchTimer$fired();
#line 73
      break;
#line 73
    case 6U:
#line 73
      result = GPSSensorM$CheckTimer$fired();
#line 73
      break;
#line 73
    case 7U:
#line 73
      result = SNMSM$SNMSTimer$fired();
#line 73
      break;
#line 73
    case 8U:
#line 73
      result = WDTM$Timer$fired();
#line 73
      break;
#line 73
    case 9U:
#line 73
      result = TimeSyncM$Timer$fired();
#line 73
      break;
#line 73
    case 10U:
#line 73
      result = GenericCommProM$ActivityTimer$fired();
#line 73
      break;
#line 73
    case 11U:
#line 73
      result = GenericCommProM$MonitorTimer$fired();
#line 73
      break;
#line 73
    case 12U:
#line 73
      result = FlashManagerM$EraseTimer$fired();
#line 73
      break;
#line 73
    case 13U:
#line 73
      result = FlashManagerM$WritingTimer$fired();
#line 73
      break;
#line 73
    case 14U:
#line 73
      result = FlashManagerM$EraseCheckTimer$fired();
#line 73
      break;
#line 73
    case 15U:
#line 73
      result = DataMgmtM$BatchTimer$fired();
#line 73
      break;
#line 73
    case 16U:
#line 73
      result = DataMgmtM$SysCheckTimer$fired();
#line 73
      break;
#line 73
    case 17U:
#line 73
      result = ADCM$Timer$fired();
#line 73
      break;
#line 73
    case 18U:
#line 73
      result = NeighborMgmtM$Timer$fired();
#line 73
      break;
#line 73
    case 19U:
#line 73
      result = MultiHopEngineM$MonitorTimer$fired();
#line 73
      break;
#line 73
    case 20U:
#line 73
      result = MultiHopEngineM$RouteStatusTimer$fired();
#line 73
      break;
#line 73
    case 21U:
#line 73
      result = MultiHopLQI$Timer$fired();
#line 73
      break;
#line 73
    case 22U:
#line 73
      result = CascadesRouterM$RTTimer$fired();
#line 73
      break;
#line 73
    case 23U:
#line 73
      result = CascadesRouterM$DTTimer$fired();
#line 73
      break;
#line 73
    case 24U:
#line 73
      result = CascadesRouterM$ResetTimer$fired();
#line 73
      break;
#line 73
    case 25U:
#line 73
      result = CascadesRouterM$DelayTimer$fired();
#line 73
      break;
#line 73
    case 26U:
#line 73
      result = CascadesRouterM$ACKTimer$fired();
#line 73
      break;
#line 73
    default:
#line 73
      result = TimerM$Timer$default$fired(arg_0x408cf2b8);
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
# 204 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static inline uint8_t TimerM$dequeue(void)
#line 204
{
  uint8_t ret;

#line 206
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 206
    {
      if (TimerM$queue_size == 0) {
          ret = NUM_TIMERS;
        }
      else {
#line 210
        if (TimerM$queue_head == NUM_TIMERS - 1) {
          TimerM$queue_head = -1;
          }
        }
#line 212
      TimerM$queue_head++;
      TimerM$queue_size--;
      ret = TimerM$queue[(uint8_t )TimerM$queue_head];
    }
#line 215
    __nesc_atomic_end(__nesc_atomic); }
  return ret;
}

static inline  void TimerM$signalOneTimer(void)
#line 219
{
  uint8_t itimer = TimerM$dequeue();

#line 221
  if (itimer < NUM_TIMERS) {
    TimerM$Timer$fired(itimer);
    }
}

#line 225
static inline   result_t TimerM$Clock$fire(void)
#line 225
{

  uint32_t newInterval = ~ (uint32_t )0;
  uint32_t i;

  if (TimerM$mState) {
      for (i = 0; i < NUM_TIMERS; i++) {
          if (TimerM$mState & (0x1L << i)) {
              TimerM$mTimerList[i].ticksLeft -= TimerM$mCurrentInterval;
              if (TimerM$mTimerList[i].ticksLeft <= 0) {
                  if (TOS_post(TimerM$signalOneTimer)) {
                      if (TimerM$mTimerList[i].type == TIMER_REPEAT) {
                          TimerM$mTimerList[i].ticksLeft = TimerM$mTimerList[i].ticks;
                        }
                      else {
                          TimerM$mState &= ~(0x1L << i);
                        }
                      TimerM$enqueue(i);
                    }
                  else {
                      printFatalErrorMsg("TimerM found Task queue full", 0);
                      return FAIL;
                    }
                }
              if (TimerM$mTimerList[i].ticksLeft < newInterval && TimerM$mTimerList[i].ticksLeft != 0) {
                  newInterval = TimerM$mTimerList[i].ticksLeft;
                }
            }
        }
    }

  if (newInterval != ~ (uint32_t )0) {

      TimerM$mCurrentInterval = newInterval;
      TimerM$Clock$setInterval(TimerM$mCurrentInterval);
    }
  else {
      TimerM$mCurrentInterval = 0;
    }
  return SUCCESS;
}

# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   result_t PXA27XClockM$Clock$fire(void){
#line 180
  unsigned char result;
#line 180

#line 180
  result = TimerM$Clock$fire();
#line 180

#line 180
  return result;
#line 180
}
#line 180
# 84 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static inline   void PXA27XClockM$OSTIrq$fired(void)
#line 84
{




  if (* (volatile uint32_t *)0x40A00014 & (1 << 5)) {

      * (volatile uint32_t *)0x40A00014 = 1 << 5;

      PXA27XClockM$Clock$fire();
    }
}

# 429 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline void RealTimeM$enqueue(uint8_t value)
#line 429
{
  if (RealTimeM$queue_tail == 30 - 1) {
      RealTimeM$queue_tail = -1;
    }
  RealTimeM$queue_tail++;
  RealTimeM$queue_size++;
  RealTimeM$queue[(uint8_t )RealTimeM$queue_tail] = value;
}

# 6 "/home/xu/oasis/interfaces/GPSGlobalTime.nc"
inline static   uint32_t RealTimeM$GPSGlobalTime$getGlobalTime(void){
#line 6
  unsigned int result;
#line 6

#line 6
  result = GPSSensorM$GPSGlobalTime$getGlobalTime();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t TimeSyncM$LocalTime$read(void){
#line 27
  unsigned int result;
#line 27

#line 27
  result = RealTimeM$LocalTime$read();
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 204 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   uint32_t TimeSyncM$GlobalTime$getLocalTime(void)
{



  return TimeSyncM$LocalTime$read();
}







static inline   result_t TimeSyncM$GlobalTime$getGlobalTime(uint32_t *time)
{
  *time = TimeSyncM$GlobalTime$getLocalTime();






  return TimeSyncM$GlobalTime$local2Global(time);
}

# 43 "/home/xu/oasis/lib/FTSP/TimeSync/GlobalTime.nc"
inline static   result_t RealTimeM$GlobalTime$getGlobalTime(uint32_t *arg_0x40b6cdd8){
#line 43
  unsigned char result;
#line 43

#line 43
  result = TimeSyncM$GlobalTime$getGlobalTime(arg_0x40b6cdd8);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 489 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  void RealTimeM$updateTimer(void)
#line 489
{
  int32_t i = 0;







  if (RealTimeM$syncMode == FTSP_SYNC) {
      RealTimeM$GlobalTime$getGlobalTime(&RealTimeM$globaltime_t);

      RealTimeM$globaltime_t = RealTimeM$globaltime_t % DAY_END;
    }

  if (RealTimeM$syncMode == GPS_SYNC) {
      RealTimeM$globaltime_t = RealTimeM$GPSGlobalTime$getGlobalTime();
      RealTimeM$globaltime_t = RealTimeM$globaltime_t % DAY_END;
    }



  if (RealTimeM$mState) {
      while (i < MAX_NUM_CLIENT) {
          if (RealTimeM$mState & (0x1L << i)) {
              if (RealTimeM$clientList[i].fireCount >= DAY_END) {
                  RealTimeM$clientList[i].fireCount -= DAY_END;
                }
              if (RealTimeM$clientList[i].fireCount <= RealTimeM$globaltime_t && RealTimeM$globaltime_t - RealTimeM$clientList[i].fireCount < DAY_END >> 1) {
                  if (RealTimeM$clientList[i].type == TIMER_REPEAT) {
                      while (RealTimeM$clientList[i].fireCount <= RealTimeM$globaltime_t) {
                          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 520
                            RealTimeM$clientList[i].fireCount += RealTimeM$clientList[i].syncInterval;
#line 520
                            __nesc_atomic_end(__nesc_atomic); }
                        }
                    }
                  else 


                    {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 527
                        RealTimeM$mState &= ~(0x1L << i);
#line 527
                        __nesc_atomic_end(__nesc_atomic); }
                    }

                  if (TRUE != RealTimeM$taskBusy) {
                      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 531
                        RealTimeM$taskBusy = TOS_post(RealTimeM$signalOneTimer);
#line 531
                        __nesc_atomic_end(__nesc_atomic); }
                    }
                  RealTimeM$enqueue(i);
                  RealTimeM$realTimeFired = TRUE;
                }
              else {
#line 535
                if (RealTimeM$globaltime_t <= RealTimeM$clientList[i].fireCount && RealTimeM$globaltime_t < RealTimeM$globaltime_tHist) {
                    while (RealTimeM$clientList[i].fireCount - DAY_END < RealTimeM$globaltime_t) {
                        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 537
                          RealTimeM$clientList[i].fireCount += RealTimeM$clientList[i].syncInterval;
#line 537
                          __nesc_atomic_end(__nesc_atomic); }
                      }
                  }
                }
            }
#line 541
          ++i;
        }
    }
  RealTimeM$globaltime_tHist = RealTimeM$globaltime_t;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 545
    RealTimeM$timerBusy = FALSE;
#line 545
    __nesc_atomic_end(__nesc_atomic); }
}

#line 634
static inline   result_t RealTimeM$Clock$fire(void)
#line 634
{
  uint32_t globaltime = 0;
  int32_t i = 0;

  ++RealTimeM$localTime;

  if (RealTimeM$localTime >= DAY_END) {
      RealTimeM$localTime -= DAY_END;
    }

  if (RealTimeM$timerBusy == FALSE) {
      if (TOS_post(RealTimeM$updateTimer) == SUCCESS) {
        RealTimeM$timerBusy = TRUE;
        }
    }
  return SUCCESS;
}

# 240 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline   result_t ADCM$Clock$fire(void)
#line 240
{


  return SUCCESS;
}

# 180 "/opt/tinyos-1.x/tos/platform/pxa27x/Clock.nc"
inline static   result_t RTCClockM$MicroClock$fire(void){
#line 180
  unsigned char result;
#line 180

#line 180
  result = ADCM$Clock$fire();
#line 180
  result = rcombine(result, RealTimeM$Clock$fire());
#line 180

#line 180
  return result;
#line 180
}
#line 180
# 32 "/home/xu/oasis/system/platform/imote2/RTC/RTCClockM.nc"
static inline   void RTCClockM$OSTIrq$fired(void)
#line 32
{
  if (* (volatile uint32_t *)0x40A00014 & (1 << 10)) {
      RTCClockM$MicroClock$fire();
      * (volatile uint32_t *)0x40A00014 = 1 << 10;
    }
}

# 129 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   uint32_t HplPXA27xBTUARTP$UART$getLSR(void)
#line 129
{
#line 129
  return * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x14);
}

# 63 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   uint32_t HalPXA27xBTUARTP$UART$getLSR(void){
#line 63
  unsigned int result;
#line 63

#line 63
  result = HplPXA27xBTUARTP$UART$getLSR();
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 39 "/home/xu/oasis/system/platform/imote2/ADC/gps.h"
static __inline uint8_t tr_time(uint8_t *source)
#line 39
{
#line 39
  return (*source - ACIIOFFSET) * 10 + *(source + 1) - ACIIOFFSET;
}

# 30 "/home/xu/oasis/lib/SmartSensing/DataMgmt.nc"
inline static  result_t SmartSensingM$DataMgmt$saveBlk(void *arg_0x40aba140, uint8_t arg_0x40aba2d0){
#line 30
  unsigned char result;
#line 30

#line 30
  result = DataMgmtM$DataMgmt$saveBlk(arg_0x40aba140, arg_0x40aba2d0);
#line 30

#line 30
  return result;
#line 30
}
#line 30
# 695 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$GPSSensing$dataReady(uint8_t *data, uint16_t size)
#line 695
{
  uint8_t *dst = (void *)0;
  int16_t length = size;
  uint16_t leftLength = 0;
  SenBlkPtr p = sensor[GPS_CLIENT_ID].curBlkPtr;
  uint32_t temptime = SmartSensingM$RealTime$getTimeCount();

#line 701
  while (length > 0) {
      if ((void *)0 != p) {
          p->time = temptime;
          p->interval = 0;
          p->type = sensor[GPS_CLIENT_ID].type;
          p->priority = sensor[GPS_CLIENT_ID].dataPriority + sensor[GPS_CLIENT_ID].nodePriority;
          p->size = 0;
          p->taskCode = SmartSensingM$defaultCode;
          dst = p->buffer;
          if (length < MAX_BUFFER_SIZE) {
              leftLength = length;
            }
          else {
              leftLength = MAX_BUFFER_SIZE;
            }
          while (p->size < leftLength) {
              * dst++ = * data++;
              p->size++;
            }
          SmartSensingM$DataMgmt$saveBlk((void *)p, 0);
          length -= MAX_BUFFER_SIZE;
        }
      p = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(GPS_CLIENT_ID);
      SmartSensingM$sensingCurBlk = p;
    }
  sensor[GPS_CLIENT_ID].curBlkPtr = p;
  return SUCCESS;
}

# 46 "/home/xu/oasis/interfaces/GenericSensing.nc"
inline static  result_t GPSSensorM$GenericSensing$dataReady(uint8_t *arg_0x40ac8268, uint16_t arg_0x40ac83f8){
#line 46
  unsigned char result;
#line 46

#line 46
  result = SmartSensingM$GPSSensing$dataReady(arg_0x40ac8268, arg_0x40ac83f8);
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 221 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  void GPSSensorM$gpsTask(void)
#line 221
{
  if (GPSSensorM$rawCount != 0) {
      GPSSensorM$GenericSensing$dataReady(GPSSensorM$RAWData, GPSSensorM$rawCount);
    }
}

#line 245
static inline   void GPSSensorM$GPSUartStream$receivedByte(uint8_t data)
#line 245
{
  uint16_t *lengthPtr;






  if (GPSSensorM$dataCount < RAW_SIZE + NMEA_SIZE) {
      if (GPSSensorM$dataCount == 0 && data != 0xb5) {
#line 254
        return;
        }
      GPSSensorM$AllData[GPSSensorM$dataCount] = data;
      GPSSensorM$dataCount++;







      if (
#line 263
      GPSSensorM$dataCount >= 8
       && GPSSensorM$AllData[0] == 0xb5 && GPSSensorM$AllData[1] == 0x62
       && GPSSensorM$AllData[2] == 0x02 && GPSSensorM$AllData[3] == 0x10) {

          GPSSensorM$RAWData = GPSSensorM$AllData;



          lengthPtr = (uint16_t *)(GPSSensorM$RAWData + 4);

          GPSSensorM$raw_payload_length = *lengthPtr;


          if (GPSSensorM$dataCount == GPSSensorM$raw_payload_length + 8) {

              GPSSensorM$rawCount = GPSSensorM$dataCount;
              TOS_post(GPSSensorM$gpsTask);
              GPSSensorM$NMEAData = GPSSensorM$AllData + GPSSensorM$dataCount;
            }
          else {



              if (
#line 283
              GPSSensorM$NMEAData != (void *)0 && GPSSensorM$dataCount == NMEA_SIZE + GPSSensorM$raw_payload_length + 8
               && GPSSensorM$NMEAData[NMEA_SIZE - 2] == 0x0D && GPSSensorM$NMEAData[NMEA_SIZE - 1] == 0x0A
               && GPSSensorM$NMEAData[0] == 0x24 && GPSSensorM$NMEAData[1] == 0x47
               && GPSSensorM$NMEAData[2] == 0x50 && GPSSensorM$NMEAData[3] == 0x5a) {


                  GPSSensorM$timeCount = (uint32_t )tr_time(GPSSensorM$NMEAData + H1) * 3600UL + (uint32_t )tr_time(GPSSensorM$NMEAData + M1) * 60UL + (uint32_t )tr_time(GPSSensorM$NMEAData + S1) + 1;
                  GPSSensorM$timeCount = GPSSensorM$timeCount * 1000UL % DAY_END;
                  GPSSensorM$samplingReady = TRUE;
                  GPSSensorM$dataCount = 0;
                  GPSSensorM$NMEAData = (void *)0;
                }
            }
        }
    }
  else 



    {
      ;
      GPSSensorM$dataCount = 0;
      GPSSensorM$NMEAData = (void *)0;
    }


  return;
}

# 79 "/home/xu/oasis/system/platform/imote2/UART/UartStream.nc"
inline static   void HalPXA27xBTUARTP$UartStream$receivedByte(uint8_t arg_0x40bd1c28){
#line 79
  GPSSensorM$GPSUartStream$receivedByte(arg_0x40bd1c28);
#line 79
}
#line 79
# 122 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   uint32_t HplPXA27xBTUARTP$UART$getIER(void)
#line 122
{
#line 122
  return * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x04);
}

# 51 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   uint32_t HalPXA27xBTUARTP$UART$getIER(void){
#line 51
  unsigned int result;
#line 51

#line 51
  result = HplPXA27xBTUARTP$UART$getIER();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 287 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$receive(uint8_t *buf, uint16_t len, uint16_t timeout)
#line 287
{
  uint32_t rxAddr;
  uint32_t DMAFlags;
  result_t error = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 292
    {
      if (HalPXA27xBTUARTP$rxCurrentBuf == (void *)0) {
          HalPXA27xBTUARTP$rxCurrentBuf = buf;
          HalPXA27xBTUARTP$rxCurrentLen = len;
          HalPXA27xBTUARTP$rxCurrentIdx = 0;
        }
      else {
          error = FAIL;
        }
    }
#line 301
    __nesc_atomic_end(__nesc_atomic); }

  if (!error) {
    return error;
    }
  if (len < 8) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 307
        {

          HalPXA27xBTUARTP$gulFCRShadow = (HalPXA27xBTUARTP$gulFCRShadow & ~((3 & 0x3) << 6)) | ((0 & 0x3) << 6);
          HalPXA27xBTUARTP$UART$setFCR(HalPXA27xBTUARTP$gulFCRShadow);
          HalPXA27xBTUARTP$UART$setIER(HalPXA27xBTUARTP$UART$getIER() | (1 << 0));
        }
#line 312
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
    }
#line 336
  return error;
}

# 423 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$receiveDone(uint8_t *buf, 
uint16_t len, 
uart_status_t status)
#line 425
{
  return (void *)0;
}

# 89 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialPacket.nc"
inline static   uint8_t *HalPXA27xBTUARTP$HalPXA27xSerialPacket$receiveDone(uint8_t *arg_0x40bf31a8, uint16_t arg_0x40bf3338, uart_status_t arg_0x40bf34c8){
#line 89
  unsigned char *result;
#line 89

#line 89
  result = GPSSensorM$GPSHalPXA27xSerialPacket$receiveDone(arg_0x40bf31a8, arg_0x40bf3338, arg_0x40bf34c8);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 404 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   void GPSSensorM$GPSUartStream$receiveDone(uint8_t *buf, 
uint16_t len, result_t error)
#line 405
{
  return;
}

# 99 "/home/xu/oasis/system/platform/imote2/UART/UartStream.nc"
inline static   void HalPXA27xBTUARTP$UartStream$receiveDone(uint8_t *arg_0x40bcf920, uint16_t arg_0x40bcfab0, result_t arg_0x40bcfc40){
#line 99
  GPSSensorM$GPSUartStream$receiveDone(arg_0x40bcf920, arg_0x40bcfab0, arg_0x40bcfc40);
#line 99
}
#line 99
# 339 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline void HalPXA27xBTUARTP$DispatchStreamRcvSignal(void)
#line 339
{
  uint8_t *pBuf = HalPXA27xBTUARTP$rxCurrentBuf;
  uint16_t len = HalPXA27xBTUARTP$rxCurrentLen;

#line 342
  HalPXA27xBTUARTP$rxCurrentBuf = (void *)0;

  if (HalPXA27xBTUARTP$gbUsingUartStreamRcvIF) {
      HalPXA27xBTUARTP$gbUsingUartStreamRcvIF = FALSE;
      HalPXA27xBTUARTP$UartStream$receiveDone(pBuf, len, SUCCESS);
    }
  else {
      pBuf = HalPXA27xBTUARTP$HalPXA27xSerialPacket$receiveDone(pBuf, len, SUCCESS);
      if (pBuf) {
#line 350
          HalPXA27xBTUARTP$HalPXA27xSerialPacket$receive(pBuf, len, 0);
        }
    }
#line 352
  return;
}

# 94 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   uint32_t HplPXA27xBTUARTP$UART$getRBR(void)
#line 94
{
#line 94
  return * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0);
}

# 41 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   uint32_t HalPXA27xBTUARTP$UART$getRBR(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = HplPXA27xBTUARTP$UART$getRBR();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 95 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UART$setTHR(uint32_t val)
#line 95
{
#line 95
  * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0) = val;
}

# 42 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HalPXA27xBTUARTP$UART$setTHR(uint32_t arg_0x40c21480){
#line 42
  HplPXA27xBTUARTP$UART$setTHR(arg_0x40c21480);
#line 42
}
#line 42
# 228 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline   result_t HalPXA27xBTUARTP$HalPXA27xSerialPacket$send(uint8_t *buf, uint16_t len)
#line 228
{
  uint32_t txAddr;
  uint32_t DMAFlags;
  result_t error = SUCCESS;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 233
    {
      if (HalPXA27xBTUARTP$txCurrentBuf == (void *)0) {
          HalPXA27xBTUARTP$txCurrentBuf = buf;
          HalPXA27xBTUARTP$txCurrentLen = len;
        }
      else {
          error = FAIL;
        }
    }
#line 241
    __nesc_atomic_end(__nesc_atomic); }

  if (!error) {
    return error;
    }

  if (len < 8) {
      uint16_t i;

#line 249
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
        {





          HalPXA27xBTUARTP$gulFCRShadow |= 1 << 3;
          HalPXA27xBTUARTP$UART$setFCR(HalPXA27xBTUARTP$gulFCRShadow);
        }
#line 258
        __nesc_atomic_end(__nesc_atomic); }
      for (i = 0; i < len; i++) {
          HalPXA27xBTUARTP$UART$setTHR(buf[i]);
        }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 262
        HalPXA27xBTUARTP$UART$setIER(HalPXA27xBTUARTP$UART$getIER() | (1 << 1));
#line 262
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
    }
#line 284
  return error;
}

# 413 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   uint8_t *GPSSensorM$GPSHalPXA27xSerialPacket$sendDone(uint8_t *buf, 
uint16_t len, 
uart_status_t status)
#line 415
{
  return (void *)0;
}

# 62 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xSerialPacket.nc"
inline static   uint8_t *HalPXA27xBTUARTP$HalPXA27xSerialPacket$sendDone(uint8_t *arg_0x40bcce68, uint16_t arg_0x40bcb010, uart_status_t arg_0x40bcb1a0){
#line 62
  unsigned char *result;
#line 62

#line 62
  result = GPSSensorM$GPSHalPXA27xSerialPacket$sendDone(arg_0x40bcce68, arg_0x40bcb010, arg_0x40bcb1a0);
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 231 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   void GPSSensorM$GPSUartStream$sendDone(uint8_t *buf, 
uint16_t len, result_t error)
#line 232
{
  return;
}

# 57 "/home/xu/oasis/system/platform/imote2/UART/UartStream.nc"
inline static   void HalPXA27xBTUARTP$UartStream$sendDone(uint8_t *arg_0x40bd2b58, uint16_t arg_0x40bd2ce8, result_t arg_0x40bd2e78){
#line 57
  GPSSensorM$GPSUartStream$sendDone(arg_0x40bd2b58, arg_0x40bd2ce8, arg_0x40bd2e78);
#line 57
}
#line 57
# 356 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline void HalPXA27xBTUARTP$DispatchStreamSendSignal(void)
#line 356
{
  uint8_t *pBuf = HalPXA27xBTUARTP$txCurrentBuf;
  uint16_t len = HalPXA27xBTUARTP$txCurrentLen;

#line 359
  HalPXA27xBTUARTP$txCurrentBuf = (void *)0;

  if (HalPXA27xBTUARTP$gbUsingUartStreamSendIF) {
      HalPXA27xBTUARTP$gbUsingUartStreamSendIF = FALSE;
      HalPXA27xBTUARTP$UartStream$sendDone(pBuf, len, SUCCESS);
    }
  else {
      pBuf = HalPXA27xBTUARTP$HalPXA27xSerialPacket$sendDone(pBuf, len, SUCCESS);
      if (pBuf) {
#line 367
          HalPXA27xBTUARTP$HalPXA27xSerialPacket$send(pBuf, len);
        }
    }
#line 369
  return;
}

# 123 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   uint32_t HplPXA27xBTUARTP$UART$getIIR(void)
#line 123
{
#line 123
  return * (volatile uint32_t *)((uint32_t )HplPXA27xBTUARTP$base_addr + (uint32_t )0x08);
}

# 53 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   uint32_t HalPXA27xBTUARTP$UART$getIIR(void){
#line 53
  unsigned int result;
#line 53

#line 53
  result = HplPXA27xBTUARTP$UART$getIIR();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 460 "/home/xu/oasis/system/platform/imote2/UART/HalPXA27xBTUARTP.nc"
static inline   void HalPXA27xBTUARTP$UART$interruptUART(void)
#line 460
{
  uint8_t error;
#line 461
  uint8_t intSource;
  uint8_t ucByte;

  intSource = HalPXA27xBTUARTP$UART$getIIR();

  intSource &= 0x3 << 1;
  intSource = intSource >> 1;

  switch (intSource) {
      case 0: 
        break;
      case 1: 
        HalPXA27xBTUARTP$UART$setIER(HalPXA27xBTUARTP$UART$getIER() & ~(1 << 1));
      HalPXA27xBTUARTP$DispatchStreamSendSignal();
      break;
      case 2: 
        while (HalPXA27xBTUARTP$UART$getLSR() & (1 << 0)) 
          {
            ucByte = HalPXA27xBTUARTP$UART$getRBR();

            if (HalPXA27xBTUARTP$rxCurrentBuf != (void *)0) {
                HalPXA27xBTUARTP$rxCurrentBuf[HalPXA27xBTUARTP$rxCurrentIdx] = ucByte;
                HalPXA27xBTUARTP$rxCurrentIdx++;
                if (HalPXA27xBTUARTP$rxCurrentIdx >= HalPXA27xBTUARTP$rxCurrentLen) {
                  HalPXA27xBTUARTP$DispatchStreamRcvSignal();
                  }
              }
            else {
#line 487
              if (HalPXA27xBTUARTP$gbRcvByteEvtEnabled) {
                  HalPXA27xBTUARTP$UartStream$receivedByte(ucByte);
                }
              }
          }
#line 491
      break;
      case 3: 
        error = HalPXA27xBTUARTP$UART$getLSR();
      break;
      default: 
        break;
    }
  return;
}

# 81 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xUART.nc"
inline static   void HplPXA27xBTUARTP$UART$interruptUART(void){
#line 81
  HalPXA27xBTUARTP$UART$interruptUART();
#line 81
}
#line 81
# 141 "/home/xu/oasis/system/platform/imote2/UART/HplPXA27xBTUARTP.nc"
static inline   void HplPXA27xBTUARTP$UARTIrq$fired(void)
#line 141
{

  HplPXA27xBTUARTP$UART$interruptUART();
}

# 449 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$BackoffTimerJiffy$fired(void)
#line 449
{
  uint8_t currentstate;

#line 451
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 451
    currentstate = CC2420RadioM$stateRadio;
#line 451
    __nesc_atomic_end(__nesc_atomic); }

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





            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 469
              {
                CC2420RadioM$txbufptr->ack = 0;
                CC2420RadioM$stateRadio = CC2420RadioM$POST_TX_ACK_STATE;
              }
#line 472
              __nesc_atomic_end(__nesc_atomic); }
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
# 58 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static inline   void TimerJiffyAsyncM$OSTIrq$fired(void)
#line 58
{
  uint32_t localjiffy;

#line 60
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 60
    localjiffy = TimerJiffyAsyncM$jiffy;
#line 60
    __nesc_atomic_end(__nesc_atomic); }

  if (* (volatile uint32_t *)0x40A00014 & (1 << 6)) {
      * (volatile uint32_t *)0x40A00014 = 1 << 6;
      if (localjiffy < (1 << 27) - 1) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 65
            {
              * (volatile uint32_t *)0x40A0001C &= ~(1 << 6);
            }
#line 67
            __nesc_atomic_end(__nesc_atomic); }
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 68
            TimerJiffyAsyncM$bSet = FALSE;
#line 68
            __nesc_atomic_end(__nesc_atomic); }
          TimerJiffyAsyncM$TimerJiffyAsync$fired();
        }
      else {
          localjiffy = localjiffy - ((1 << 27) - 1);

          TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(localjiffy);
        }
    }

  return;
}

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

# 382 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  TOS_MsgPtr GenericCommProM$UARTReceive$receive(TOS_MsgPtr packet)
#line 382
{

  packet->group = TOS_AM_GROUP;
  return GenericCommProM$received(packet);
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr FramerAckM$ReceiveCombined$receive(TOS_MsgPtr arg_0x40620878){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = GenericCommProM$UARTReceive$receive(arg_0x40620878);
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
inline static  TOS_MsgPtr FramerM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$ReceiveMsg$receive(arg_0x40620878);
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
inline static  result_t FramerAckM$TokenReceiveMsg$ReflectToken(uint8_t arg_0x410a6cf8){
#line 88
  unsigned char result;
#line 88

#line 88
  result = FramerM$TokenReceiveMsg$ReflectToken(arg_0x410a6cf8);
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
inline static  TOS_MsgPtr FramerM$TokenReceiveMsg$receive(TOS_MsgPtr arg_0x410a64c8, uint8_t arg_0x410a6650){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = FramerAckM$TokenReceiveMsg$receive(arg_0x410a64c8, arg_0x410a6650);
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
inline static   result_t UARTM$ByteComm$rxByteReady(uint8_t arg_0x410a3200, bool arg_0x410a3388, uint16_t arg_0x410a3520){
#line 66
  unsigned char result;
#line 66

#line 66
  result = FramerM$ByteComm$rxByteReady(arg_0x410a3200, arg_0x410a3388, arg_0x410a3520);
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

# 97 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
inline static   result_t HPLFFUARTM$UART$get(uint8_t arg_0x41111e58){
#line 97
  unsigned char result;
#line 97

#line 97
  result = UARTM$HPLUART$get(arg_0x41111e58);
#line 97

#line 97
  return result;
#line 97
}
#line 97
# 55 "/opt/tinyos-1.x/tos/interfaces/ByteComm.nc"
inline static   result_t FramerM$ByteComm$txByte(uint8_t arg_0x410abc98){
#line 55
  unsigned char result;
#line 55

#line 55
  result = UARTM$ByteComm$txByte(arg_0x410abc98);
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
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 488
        FramerM$gTxState = FramerM$TXSTATE_ERROR;
#line 488
        __nesc_atomic_end(__nesc_atomic); }
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
inline static   result_t UARTM$ByteComm$txByteReady(bool arg_0x410a3b30){
#line 75
  unsigned char result;
#line 75

#line 75
  result = FramerM$ByteComm$txByteReady(arg_0x410a3b30);
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

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 90
    {
      {
      }
#line 91
      ;
      oldState = UARTM$state;
      UARTM$state = FALSE;
    }
#line 94
    __nesc_atomic_end(__nesc_atomic); }








  if (oldState) {
      UARTM$ByteComm$txDone();
      UARTM$ByteComm$txByteReady(TRUE);
    }
  return SUCCESS;
}

# 105 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
inline static   result_t HPLFFUARTM$UART$putDone(void){
#line 105
  unsigned char result;
#line 105

#line 105
  result = UARTM$HPLUART$putDone();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 64 "/opt/tinyos-1.x/tos/platform/imote2/HPLFFUARTM.nc"
static inline   void HPLFFUARTM$Interrupt$fired(void)
#line 64
{
  uint8_t error;
#line 65
  uint8_t intSource = * (volatile uint32_t *)0x40100008;

#line 66
  intSource = (intSource >> 1) & 0x3;
  switch (intSource) {
      case 0: 

        break;
      case 1: 

        HPLFFUARTM$UART$putDone();
      break;
      case 2: 

        while (* (volatile uint32_t *)0x40100014 & (1 << 0)) {
            HPLFFUARTM$UART$get(* (volatile uint32_t *)0x40100000);
          }
      break;
      case 3: 

        error = * (volatile uint32_t *)0x40100014;
      trace(DBG_USR1, "UART Error %d\r\n", error);
      break;
    }
  return;
}

# 354 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static inline    void PXA27XInterruptM$PXA27XIrq$default$fired(uint8_t id)
{
  return;
}

# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XInterruptM$PXA27XIrq$fired(uint8_t arg_0x405ecc80){
#line 48
  switch (arg_0x405ecc80) {
#line 48
    case 6:
#line 48
      PMICM$PI2CInterrupt$fired();
#line 48
      break;
#line 48
    case 7:
#line 48
      TimerJiffyAsyncM$OSTIrq$fired();
#line 48
      RTCClockM$OSTIrq$fired();
#line 48
      PXA27XClockM$OSTIrq$fired();
#line 48
      break;
#line 48
    case 8:
#line 48
      PXA27XGPIOIntM$GPIOIrq0$fired();
#line 48
      break;
#line 48
    case 9:
#line 48
      PXA27XGPIOIntM$GPIOIrq1$fired();
#line 48
      break;
#line 48
    case 10:
#line 48
      PXA27XGPIOIntM$GPIOIrq$fired();
#line 48
      break;
#line 48
    case 11:
#line 48
      PXA27XUSBClientM$USBInterrupt$fired();
#line 48
      break;
#line 48
    case 20:
#line 48
      STUARTM$UARTInterrupt$fired();
#line 48
      break;
#line 48
    case 21:
#line 48
      HplPXA27xBTUARTP$UARTIrq$fired();
#line 48
      break;
#line 48
    case 22:
#line 48
      HPLFFUARTM$Interrupt$fired();
#line 48
      break;
#line 48
    case 25:
#line 48
      PXA27XDMAM$Interrupt$fired();
#line 48
      break;
#line 48
    default:
#line 48
      PXA27XInterruptM$PXA27XIrq$default$fired(arg_0x405ecc80);
#line 48
      break;
#line 48
    }
#line 48
}
#line 48
# 371 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$UARTSend$sendDone(TOS_MsgPtr msg, result_t success)
#line 371
{
  GenericCommProM$state = FALSE;
  return GenericCommProM$reportSendDone(msg, success);
}

# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t FramerM$BareSendMsg$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8){
#line 67
  unsigned char result;
#line 67

#line 67
  result = GenericCommProM$UARTSend$sendDone(arg_0x4061e348, arg_0x4061e4d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 468 "/home/xu/oasis/system/queue.h"
static inline object_type **findObject(Queue_t *queue, object_type *obj)
#line 468
{
  int16_t ind;

#line 470
  if (queue->size <= 0) {
      ;
      return (void *)0;
    }

  if (queue->total <= 0) {
      ;
      return (void *)0;
    }

  for (ind = 0; ind < queue->size; ind++) {
      if (queue->element[ind].status != FREE && queue->element[ind].obj == obj) {
          ;
          return & (&queue->element[ind])->obj;
        }
    }
  ;
  return (void *)0;
}

#line 397
static inline bool incRetryCount(object_type **object)
#line 397
{
  Element_t *el;

#line 399
  if (object == (void *)0) {
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
  if (object == (void *)0) {
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
      case 5: return 5;
      case 6: return 6;
      case 7: return 7;
      default: return 1;
    }
}

# 63 "/opt/tinyos-1.x/tos/interfaces/Random.nc"
inline static   uint16_t CC2420RadioM$Random$rand(void){
#line 63
  unsigned short result;
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
inline static   int16_t CC2420RadioM$MacBackoff$initialBackoff(TOS_MsgPtr arg_0x40f2a8f0){
#line 74
  short result;
#line 74

#line 74
  result = CC2420RadioM$MacBackoff$default$initialBackoff(arg_0x40f2a8f0);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 6 "/opt/tinyos-1.x/tos/lib/CC2420Radio/TimerJiffyAsync.nc"
inline static   result_t CC2420RadioM$BackoffTimerJiffy$setOneShot(uint32_t arg_0x40f16428){
#line 6
  unsigned char result;
#line 6

#line 6
  result = TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(arg_0x40f16428);
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
inline static  result_t GenericCommProM$RadioSend$send(TOS_MsgPtr arg_0x40615d50){
#line 58
  unsigned char result;
#line 58

#line 58
  result = CC2420RadioM$Send$send(arg_0x40615d50);
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
inline static  result_t GenericCommProM$UARTSend$send(TOS_MsgPtr arg_0x40615d50){
#line 58
  unsigned char result;
#line 58

#line 58
  result = FramerM$BareSendMsg$send(arg_0x40615d50);
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
  if (m == (void *)0) {
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

      if (headElement(&GenericCommProM$sendQueue, PROCESSING) == (void *)0) {
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

# 214 "/opt/tinyos-1.x/tos/platform/imote2/HPLFFUARTM.nc"
static inline   result_t HPLFFUARTM$UART$put(uint8_t data)
#line 214
{
  * (volatile uint32_t *)0x40100000 = data;
  return SUCCESS;
}

# 89 "/opt/tinyos-1.x/tos/platform/imote2/HPLUART.nc"
inline static   result_t UARTM$HPLUART$put(uint8_t arg_0x411118c0){
#line 89
  unsigned char result;
#line 89

#line 89
  result = HPLFFUARTM$UART$put(arg_0x411118c0);
#line 89

#line 89
  return result;
#line 89
}
#line 89
# 535 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$SendMsg$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 535
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 536
    MultiHopLQI$msgBufBusy = FALSE;
#line 536
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 795 "build/imote2/RpcM.nc"
static inline  result_t RpcM$ResponseSend$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 795
{


  ;



  return SUCCESS;
}

# 672 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Send$default$sendDone(uint8_t AMID, TOS_MsgPtr pMsg, 
result_t success)
#line 673
{
  MultiHopEngineM$falseType++;
  return SUCCESS;
}

# 119 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t MultiHopEngineM$Send$sendDone(uint8_t arg_0x413114b8, TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8){
#line 119
  unsigned char result;
#line 119

#line 119
  switch (arg_0x413114b8) {
#line 119
    case NW_DATA:
#line 119
      result = DataMgmtM$Send$sendDone(arg_0x409ba768, arg_0x409ba8f8);
#line 119
      break;
#line 119
    case NW_SNMS:
#line 119
      result = EventReportM$EventSend$sendDone(arg_0x409ba768, arg_0x409ba8f8);
#line 119
      break;
#line 119
    case NW_RPCR:
#line 119
      result = RpcM$ResponseSend$sendDone(arg_0x409ba768, arg_0x409ba8f8);
#line 119
      break;
#line 119
    default:
#line 119
      result = MultiHopEngineM$Send$default$sendDone(arg_0x413114b8, arg_0x409ba768, arg_0x409ba8f8);
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
# 426 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  bool MultiHopLQI$RouteControl$isSink(void)
#line 426
{
  return MultiHopLQI$localBeSink;
}

# 116 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
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
# 841 "/home/xu/oasis/system/TinyDWFQ.h"
static inline result_t isElementInACKList_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg)
{
  int8_t ind;

#line 844
  ind = queue->head[NOT_ACKED_TINYDWFQ];
  while (ind != -1) 
    {
      if (queue->element[ind].obj == msg) 
        {
          return SUCCESS;
        }
      else 
        {
          ind = queue->element[ind].next;
        }
    }
  return FAIL;
}

# 81 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t MultiHopEngineM$Leds$redToggle(void){
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
# 266 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$SendMsg$sendDone(TOS_MsgPtr msg, result_t success)
{
  uint8_t infoIn = 0;
  TOS_MsgPtr *mPPtr = (void *)0;

#line 270
  MultiHopEngineM$Leds$redToggle();
  if (isElementInACKList_TinyDWFQ(&MultiHopEngineM$sendQueue, msg) == FAIL) 
    {
      ;
      return SUCCESS;
    }

  if ((infoIn = MultiHopEngineM$findInfoEntry(msg)) == 40) 
    {
      ;
    }
  if (MultiHopEngineM$RouteSelectCntl$isSink() || msg->addr != TOS_UART_ADDR) {
    MultiHopEngineM$beRadioActive = TRUE;
    }

  if (
#line 284
  success != SUCCESS && 
  msg->addr != TOS_BCAST_ADDR && 
  msg->addr != TOS_UART_ADDR) 
    {
      ;
      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != (void *)0) {
        MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, FAIL);
        }
#line 291
      MultiHopEngineM$numLocalPendingPkt--;
      MultiHopEngineM$numberOfSendFailures++;
      MultiHopEngineM$numOfSuccessiveFailures++;
    }
  else 
    {
      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != (void *)0) 
        {
          MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, SUCCESS);
          MultiHopEngineM$numLocalPendingPkt--;
        }

      MultiHopEngineM$numberOfSendSuccesses++;
      if (msg->addr != TOS_BCAST_ADDR) 
        {
          MultiHopEngineM$numOfSuccessiveFailures = 0;
          MultiHopEngineM$beParentActive = TRUE;
        }
    }

  if (SUCCESS != removeElement_TinyDWFQ(&MultiHopEngineM$sendQueue, msg, NOT_ACKED_TINYDWFQ)) 
    {
      ;
    }
  else 
    {
      ;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 319
    MultiHopEngineM$numOfPktProcessing--;
#line 319
    __nesc_atomic_end(__nesc_atomic); }
  freeBuffer(&MultiHopEngineM$buffQueue, msg);
  MultiHopEngineM$freeInfoEntry(infoIn);
  MultiHopEngineM$tryNextSend();
  return SUCCESS;
}

# 903 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   void TimeSyncM$TimeSyncNotify$default$msg_sent(void)
#line 903
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
# 722 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
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

# 366 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline   result_t GenericCommProM$SendMsg$default$sendDone(uint8_t id, TOS_MsgPtr msg, result_t success)
#line 366
{
  return SUCCESS;
}

# 49 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t GenericCommProM$SendMsg$sendDone(uint8_t arg_0x40d90c78, TOS_MsgPtr arg_0x40d90650, result_t arg_0x40d907e0){
#line 49
  unsigned char result;
#line 49

#line 49
  switch (arg_0x40d90c78) {
#line 49
    case AM_NETWORKMSG:
#line 49
      result = MultiHopEngineM$SendMsg$sendDone(arg_0x40d90650, arg_0x40d907e0);
#line 49
      break;
#line 49
    case AM_CASCTRLMSG:
#line 49
      result = CascadesEngineM$SendMsg$sendDone(AM_CASCTRLMSG, arg_0x40d90650, arg_0x40d907e0);
#line 49
      break;
#line 49
    case AM_CASCADESMSG:
#line 49
      result = CascadesEngineM$SendMsg$sendDone(AM_CASCADESMSG, arg_0x40d90650, arg_0x40d907e0);
#line 49
      break;
#line 49
    case AM_TIMESYNCMSG:
#line 49
      result = TimeSyncM$SendMsg$sendDone(arg_0x40d90650, arg_0x40d907e0);
#line 49
      break;
#line 49
    case AM_BEACONMSG:
#line 49
      result = MultiHopLQI$SendMsg$sendDone(arg_0x40d90650, arg_0x40d907e0);
#line 49
      break;
#line 49
    default:
#line 49
      result = GenericCommProM$SendMsg$default$sendDone(arg_0x40d90c78, arg_0x40d90650, arg_0x40d907e0);
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
# 141 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_SET_RED_LED_PIN(void)
#line 141
{
#line 141
  * (volatile uint32_t *)(0x40E00018 + (103 < 96 ? ((103 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (103 & 0x1f);
}

# 81 "/opt/tinyos-1.x/tos/system/LedsC.nc"
static inline   result_t LedsC$Leds$redOff(void)
#line 81
{
  {
  }
#line 82
  ;
  /* atomic removed: atomic calls only */
#line 83
  {
    TOSH_SET_RED_LED_PIN();
    LedsC$ledsOn &= ~LedsC$RED_BIT;
  }
  return SUCCESS;
}

# 141 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_CLR_RED_LED_PIN(void)
#line 141
{
#line 141
  * (volatile uint32_t *)(0x40E00024 + (103 < 96 ? ((103 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (103 & 0x1f);
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t DataMgmtM$SysCheckTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(16U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
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
inline static  result_t DataMgmtM$Send$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_DATA, arg_0x409bc330, arg_0x409bc4c0);
#line 83

#line 83
  return result;
#line 83
}
#line 83
#line 106
inline static  void *DataMgmtM$Send$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_DATA, arg_0x409bcb88, arg_0x409bcd38);
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 425 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  void DataMgmtM$sendTask(void)
#line 425
{
  TOS_MsgPtr msg = (void *)0;
  ApplicationMsg *pApp = (void *)0;
  uint16_t length = 0;

  if ((void *)0 == (msg = headElement(&DataMgmtM$sendQueue, PENDING))) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 431
        DataMgmtM$sendTaskBusy = FALSE;
#line 431
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
#line 448
        {

          ;
          DataMgmtM$sendTaskBusy = FALSE;
          DataMgmtM$tryNextSend();
        }
#line 453
        __nesc_atomic_end(__nesc_atomic); }

      return;
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 458
        {
          DataMgmtM$sendTaskBusy = FALSE;
          DataMgmtM$sendQueueLen = (&DataMgmtM$sendQueue)->total;
        }
#line 461
        __nesc_atomic_end(__nesc_atomic); }

      ;
      return;
    }
}

# 347 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteSelect$initializeFields(TOS_MsgPtr Msg, uint8_t id)
#line 347
{
  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];

#line 349
  pNWMsg->type = id;
  pNWMsg->linksource = pNWMsg->source = TOS_LOCAL_ADDRESS;
  pNWMsg->seqno = MultiHopLQI$gCurrentSeqNo++;
  pNWMsg->ttl = 31;
  return SUCCESS;
}

# 86 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteSelect.nc"
inline static  result_t MultiHopEngineM$RouteSelect$initializeFields(TOS_MsgPtr arg_0x40df7b90, uint8_t arg_0x40df7d18){
#line 86
  unsigned char result;
#line 86

#line 86
  result = MultiHopLQI$RouteSelect$initializeFields(arg_0x40df7b90, arg_0x40df7d18);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 633 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline uint8_t MultiHopEngineM$allocateInfoEntry(void)
#line 633
{
  uint8_t i = 0;

#line 635
  for (i = 0; i < 40; i++) {
      if (MultiHopEngineM$queueEntryInfo[i].valid == FALSE) {
        return i;
        }
    }
#line 639
  if (i == 40) {
    ;
    }
#line 641
  return i;
}

# 281 "/home/xu/oasis/system/TinyDWFQ.h"
static inline result_t insertElement_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg)
{
  result_t retVal;
  int8_t ind;
  int8_t i;
  NetworkMsg *netMsg = (NetworkMsg *)msg->data;
  int8_t vqIndex;

  int8_t nextFreeHead = -1;

#line 290
  vqIndex = netMsg->qos;

  if (queue->size <= 0) 
    {

      retVal = FAIL;
    }
  else {
#line 297
    if (queue->total >= queue->size) 
      {

        retVal = FAIL;
      }
    }
  ind = -1;

  if (queue->numOfElements_VQ[vqIndex] == queue->maxNumOfElementPerVQ[vqIndex]) 
    {
      i = vqIndex - 1;
      while (i >= 0) 
        {
          if (queue->numOfElements_VQ[i] == queue->maxNumOfElementPerVQ[i]) {
            i--;
            }
          else {
              ind = queue->virtualQueues[i][VQ_FREE_HEAD];
              nextFreeHead = queue->element[ind].next;
              vqIndex = i;
              break;
            }
        }
    }
  else 
    {
      ind = queue->virtualQueues[vqIndex][VQ_FREE_HEAD];
      nextFreeHead = queue->element[ind].next;
    }
  if (ind != -1 && msg != 0) 
    {

      if (nextFreeHead != -1) {
        queue->virtualQueues[vqIndex][VQ_FREE_HEAD] = nextFreeHead;
        }
      else {
#line 332
        queue->virtualQueues[vqIndex][VQ_FREE_HEAD] = queue->virtualQueues[vqIndex][VQ_FREE_TAIL] = -1;
        }

      if (queue->virtualQueues[vqIndex][VQ_HEAD] == -1) {
        queue->virtualQueues[vqIndex][VQ_HEAD] = queue->virtualQueues[vqIndex][VQ_TAIL] = ind;
        }
      else {

          queue->element[queue->virtualQueues[vqIndex][VQ_TAIL]].next = ind;
          queue->virtualQueues[vqIndex][VQ_TAIL] = ind;
        }
      queue->numOfElements_VQ[vqIndex]++;
      queue->numOfElements_VQ_Processing[vqIndex]++;

      queue->element[ind].next = -1;
      queue->element[ind].obj = msg;
      queue->element[ind].qos = netMsg->qos;

      queue->element[ind].status = PROCESSING_TINYDWFQ;

      queue->numOfElements_processing++;
      queue->total++;

      retVal = SUCCESS;
    }
  else 
    {

      retVal = FAIL;
    }
  return retVal;
}

#line 495
static inline uint8_t getNumberOfElementsToBeDqueued(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t freeSpace)
{
  int16_t congestionUQ = 0;

  congestionUQ = queue->total * 100 / TINYDWFQ_SIZE;

  if (0 <= congestionUQ && congestionUQ <= 40) 
    {
      congestionUQ = setAndGetDequeueWeight(queue, virtualQueueIndex, DQ_LOW, freeSpace);
    }
  else {
#line 505
    if (41 <= congestionUQ && congestionUQ <= 75) 
      {
        congestionUQ = setAndGetDequeueWeight(queue, virtualQueueIndex, DQ_MEDIUM, freeSpace);
      }
    else {
#line 509
      if (76 <= congestionUQ && congestionUQ <= 90) 
        {
          congestionUQ = setAndGetDequeueWeight(queue, virtualQueueIndex, DQ_HIGH, freeSpace);
        }
      else {
#line 513
        if (91 <= congestionUQ && congestionUQ <= 100) 
          {
            congestionUQ = setAndGetDequeueWeight(queue, virtualQueueIndex, DQ_URGENT, freeSpace);
          }
        }
      }
    }
#line 517
  return congestionUQ;
}

#line 365
static inline void markElementAsPendingByQOS_TinyDWFQ(TinyDWFQPtr queue, uint8_t numOfElementsToMark)
{
  int8_t vqIndex;
  int8_t ind;
#line 368
  int8_t nextVQhead = -1;
  int8_t numElementsTobeDQed;


  if (queue->numOfElements_processing > 0) 
    {

      if (queue->numOfElements_processing <= numOfElementsToMark) 
        {

          vqIndex = NUM_VIRTUAL_QUEUES;
          while (numOfElementsToMark > 0 && vqIndex != 0 && queue->numOfElements_processing) 
            {
              while (numOfElementsToMark > 0 && queue->numOfElements_VQ_Processing[vqIndex - 1] > 0 && queue->numOfElements_processing) 
                {

                  ind = queue->virtualQueues[vqIndex - 1][VQ_HEAD];
                  if (queue->numOfElements_VQ_Processing[vqIndex - 1] != 0 && ind != -1 && queue->element[ind].obj) 
                    {
                      nextVQhead = queue->element[ind].next;


                      queue->element[ind].next = -1;


                      queue->element[ind].status = PENDING_TINYDWFQ;
                      if (queue->head[PENDING_TINYDWFQ] == -1) 
                        {
                          queue->head[PENDING_TINYDWFQ] = queue->tail[PENDING_TINYDWFQ] = ind;
                        }
                      else 
                        {
                          queue->element[queue->tail[PENDING_TINYDWFQ]].next = ind;
                          queue->tail[PENDING_TINYDWFQ] = ind;
                        }
                      queue->numOfElements_pending++;


                      if (nextVQhead == -1) 
                        {
                          queue->virtualQueues[vqIndex - 1][VQ_HEAD] = queue->virtualQueues[vqIndex - 1][VQ_TAIL] = -1;
                        }
                      else 
                        {
                          queue->virtualQueues[vqIndex - 1][VQ_HEAD] = nextVQhead;
                        }
                      queue->numOfElements_processing--;
                      queue->numOfElements_VQ_Processing[vqIndex - 1]--;


                      numOfElementsToMark--;
                    }
                }
              vqIndex--;
            }
        }
      else 
        {

          vqIndex = NUM_VIRTUAL_QUEUES;
          while (numOfElementsToMark > 0 && vqIndex != 0) 
            {
              if (numOfElementsToMark > 0 && queue->numOfElements_VQ_Processing[vqIndex - 1] != 0) 
                {
                  numElementsTobeDQed = getNumberOfElementsToBeDqueued(queue, vqIndex - 1, numOfElementsToMark);


                  if (numElementsTobeDQed == 0) 
                    {
                      numElementsTobeDQed = 1;
                    }
                  while (numElementsTobeDQed > 0) 
                    {
                      ind = queue->virtualQueues[vqIndex - 1][VQ_HEAD];
                      if (queue->numOfElements_VQ_Processing[vqIndex - 1] != 0 && ind != -1 && queue->element[ind].obj != (void *)0) {
#line 442
                        ;
                        }
#line 443
                      {
                        nextVQhead = queue->element[ind].next;


                        queue->element[ind].next = -1;


                        queue->element[ind].status = PENDING_TINYDWFQ;
                        if (queue->head[PENDING_TINYDWFQ] == -1) 
                          {
                            queue->head[PENDING_TINYDWFQ] = queue->tail[PENDING_TINYDWFQ] = ind;
                          }
                        else 
                          {
                            queue->element[queue->tail[PENDING_TINYDWFQ]].next = ind;
                            queue->tail[PENDING_TINYDWFQ] = ind;
                          }
                        queue->numOfElements_pending++;


                        if (nextVQhead == -1) 
                          {
                            queue->virtualQueues[vqIndex - 1][VQ_HEAD] = queue->virtualQueues[vqIndex - 1][VQ_TAIL] = -1;
                          }
                        else 
                          {
                            queue->virtualQueues[vqIndex - 1][VQ_HEAD] = nextVQhead;
                          }
                        queue->numOfElements_processing--;
                        queue->numOfElements_VQ_Processing[vqIndex - 1]--;


                        numElementsTobeDQed--;
                        numOfElementsToMark--;
                      }
                    }
                }
              else 
                {
                  vqIndex--;
                }
            }
        }
    }
}

#line 962
static inline object_type *findMessageToReplace(TinyDWFQPtr queue, int8_t newMsgQOS)
{
  int16_t ind;

  ind = queue->head[PENDING_TINYDWFQ];
  while (ind != -1) 
    {
      if (queue->element[ind].qos < newMsgQOS) 
        {
          return queue->element[ind].obj;
        }
      else {
        ind = queue->element[ind].next;
        }
    }
#line 976
  return (void *)0;
}

#line 698
static inline result_t markElementAsNotACKed_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg)
{
  int8_t ind;
#line 700
  int8_t prevIndex;
  int8_t nextHead;

#line 702
  ind = queue->head[PENDING_TINYDWFQ];
  prevIndex = ind;

  while (ind != -1) 
    {
      if (queue->element[ind].obj == msg) 
        {

          nextHead = queue->element[ind].next;


          queue->element[ind].status = NOT_ACKED_TINYDWFQ;
          queue->element[ind].next = -1;
          queue->numOfElements_pending--;


          if (queue->head[NOT_ACKED_TINYDWFQ] == -1) 
            {

              queue->head[NOT_ACKED_TINYDWFQ] = queue->tail[NOT_ACKED_TINYDWFQ] = ind;
            }
          else 
            {

              queue->element[queue->tail[NOT_ACKED_TINYDWFQ]].next = ind;
              queue->tail[NOT_ACKED_TINYDWFQ] = ind;
            }
          queue->numOfElements_notAcked++;


          if (ind == queue->head[PENDING_TINYDWFQ]) 
            {

              if (nextHead == -1) 
                {
                  queue->head[PENDING_TINYDWFQ] = queue->tail[PENDING_TINYDWFQ] = -1;
                }
              else 
                {
                  queue->head[PENDING_TINYDWFQ] = nextHead;
                }
            }
          else {
#line 744
            if (ind == queue->tail[PENDING_TINYDWFQ]) 
              {

                queue->tail[PENDING_TINYDWFQ] = prevIndex;
                queue->element[prevIndex].next = -1;
              }
            else 
              {

                queue->element[prevIndex].next = nextHead;
              }
            }
#line 755
          return SUCCESS;
        }
      else 
        {
          prevIndex = ind;
          ind = queue->element[ind].next;
        }
    }
  return FAIL;
}

# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t MultiHopEngineM$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_NETWORKMSG, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 64 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
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
# 286 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteSelect$selectRoute(TOS_MsgPtr Msg, uint8_t id, 
uint8_t resend)
#line 287
{
  int i;
  int8_t ttlDiff = 0;
  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];

  if (pNWMsg->source != TOS_LOCAL_ADDRESS && resend == 0) {

      for (i = 0; i < 45; i++) {

          if (
#line 295
          MultiHopLQI$gRecentOriginPacketSender[i] == pNWMsg->source && 
          MultiHopLQI$gRecentOriginPacketSeqNo[i] == pNWMsg->seqno && 
          !MultiHopLQI$localBeSink) {

              ttlDiff = MultiHopLQI$gRecentOriginPacketTTL[i] >= pNWMsg->ttl ? MultiHopLQI$gRecentOriginPacketTTL[i] - pNWMsg->ttl : pNWMsg->ttl - MultiHopLQI$gRecentOriginPacketTTL[i];
              if (ttlDiff >= 2) {
                  MultiHopLQI$EventReport$eventSend(EVENT_TYPE_SNMS, 
                  EVENT_LEVEL_URGENT, eventprintf("Engine:Loop ttl:%i", pNWMsg->ttl));
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
      MultiHopLQI$gRecentOriginIndex = (MultiHopLQI$gRecentOriginIndex + 1) % 45;
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

# 71 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteSelect.nc"
inline static  result_t MultiHopEngineM$RouteSelect$selectRoute(TOS_MsgPtr arg_0x40df7270, uint8_t arg_0x40df73f8, uint8_t arg_0x40df7580){
#line 71
  unsigned char result;
#line 71

#line 71
  result = MultiHopLQI$RouteSelect$selectRoute(arg_0x40df7270, arg_0x40df73f8, arg_0x40df7580);
#line 71

#line 71
  return result;
#line 71
}
#line 71
# 879 "/home/xu/oasis/system/TinyDWFQ.h"
static inline object_type *getheadElement_TinyDWFQ(TinyDWFQPtr queue, ObjStatus_t status)
{
  if (queue->head[status] == -1) {
    return (void *)0;
    }
  else {
#line 884
    return queue->element[queue->head[status]].obj;
    }
}

# 193 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  void MultiHopEngineM$sendTask(void)
{
  TOS_MsgPtr msgPtr = getheadElement_TinyDWFQ(&MultiHopEngineM$sendQueue, PENDING_TINYDWFQ);
  uint8_t infoIn = 0;

#line 197
  MultiHopEngineM$sendTaskBusy = FALSE;
  if (msgPtr == (void *)0) 
    {
      return;
    }

  MultiHopEngineM$messageIsRetransmission = MultiHopEngineM$queueEntryInfo[infoIn].resend;
  infoIn = MultiHopEngineM$findInfoEntry(msgPtr);
  if (infoIn == 40) 
    {
      ;
    }
  if (MultiHopEngineM$queueEntryInfo[infoIn].valid == FALSE) 
    {
      goto out;
    }
  if (MultiHopEngineM$RouteSelect$selectRoute(msgPtr, MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$messageIsRetransmission) != SUCCESS) 
    {
      ;
      if (MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr != (void *)0) 
        {
          MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoIn].AMID, MultiHopEngineM$queueEntryInfo[infoIn].originalTOSPtr, FAIL);
          MultiHopEngineM$numLocalPendingPkt--;
          ;
        }
      out: 
        removeElement_TinyDWFQ(&MultiHopEngineM$sendQueue, msgPtr, PENDING_TINYDWFQ);
      freeBuffer(&MultiHopEngineM$buffQueue, msgPtr);
      MultiHopEngineM$freeInfoEntry(infoIn);
      MultiHopEngineM$numberOfSendFailures++;
      MultiHopEngineM$numOfSuccessiveFailures++;
      MultiHopEngineM$tryNextSend();
      return;
    }
  else 
    {
      if (msgPtr->addr == TOS_BCAST_ADDR) 
        {
          ;
          MultiHopEngineM$Leds$redOn();

          return;
        }

      if (MultiHopEngineM$SendMsg$send(msgPtr->addr, MultiHopEngineM$queueEntryInfo[infoIn].length, msgPtr) == SUCCESS) 
        {
          if (SUCCESS != markElementAsNotACKed_TinyDWFQ(&MultiHopEngineM$sendQueue, msgPtr)) 
            {
              ;
            }
          MultiHopEngineM$numOfPktProcessing++;
          ;
          MultiHopEngineM$tryNextSend();
          return;
        }
      else 
        {


          MultiHopEngineM$queueEntryInfo[infoIn].resend = TRUE;
          if (!isListEmpty_TinyDWFQ(&MultiHopEngineM$sendQueue, NOT_ACKED_TINYDWFQ)) 
            {
              MultiHopEngineM$tryNextSend();
            }
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

# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t EventReportM$EventSend$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_SNMS, arg_0x409bc330, arg_0x409bc4c0);
#line 83

#line 83
  return result;
#line 83
}
#line 83
#line 106
inline static  void *EventReportM$EventSend$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_SNMS, arg_0x409bcb88, arg_0x409bcd38);
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
  if (msgPtr == (void *)0) {
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
      if (headElement(&EventReportM$sendQueue, PROCESSING) == (void *)0) {

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

# 121 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline uint8_t NeighborMgmtM$findEntry(uint16_t id)
#line 121
{
  uint8_t i = 0;

#line 123
  for (i = 0; i < 16; i++) {
      if (NeighborMgmtM$NeighborTbl[i].flags & NBRFLAG_VALID && NeighborMgmtM$NeighborTbl[i].id == id) {
          return i;
        }
    }
  return ROUTE_INVALID;
}

#line 165
static inline uint8_t NeighborMgmtM$findEntryToBeReplaced(void)
#line 165
{
  uint8_t i = 0;
  uint8_t minLinkEst = -1;
  uint8_t minLinkEstIndex = ROUTE_INVALID;

#line 169
  for (i = 0; i < 16; i++) {
      if ((NeighborMgmtM$NeighborTbl[i].flags & NBRFLAG_VALID) == 0) {
          return i;
        }
      if (NeighborMgmtM$NeighborTbl[i].relation & NBR_PARENT) {
        continue;
        }
#line 175
      if (minLinkEst > NeighborMgmtM$NeighborTbl[i].linkEst) {
          minLinkEst = NeighborMgmtM$NeighborTbl[i].linkEst;
          minLinkEstIndex = i;
        }
    }
  return minLinkEstIndex;
}

#line 131
static inline void NeighborMgmtM$newEntry(uint8_t indes, uint16_t id)
#line 131
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
inline static  result_t CascadesEngineM$SendMsg$send(uint8_t arg_0x414016a8, uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0){
#line 48
  unsigned char result;
#line 48

#line 48
  switch (arg_0x414016a8) {
#line 48
    case AM_CASCTRLMSG:
#line 48
      result = GenericCommProM$SendMsg$send(AM_CASCTRLMSG, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
#line 48
      break;
#line 48
    case AM_CASCADESMSG:
#line 48
      result = GenericCommProM$SendMsg$send(AM_CASCADESMSG, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
#line 48
      break;
#line 48
    default:
#line 48
      result = CascadesEngineM$SendMsg$default$send(arg_0x414016a8, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
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
  if (msg == (void *)0) {
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

#line 698
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
inline static  result_t CascadesEngineM$MySend$sendDone(uint8_t arg_0x41402e60, TOS_MsgPtr arg_0x409ba768, result_t arg_0x409ba8f8){
#line 119
  unsigned char result;
#line 119

#line 119
  result = CascadesRouterM$SubSend$sendDone(arg_0x41402e60, arg_0x409ba768, arg_0x409ba8f8);
#line 119

#line 119
  return result;
#line 119
}
#line 119
# 146 "/home/xu/oasis/lib/Cascades/CascadesEngineM.nc"
static inline void CascadesEngineM$updateProtocolField(TOS_MsgPtr msg, uint8_t type, uint8_t len)
#line 146
{
  msg->type = type;
  msg->length = len;
}

# 610 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 610
{
  return SUCCESS;
}

# 666 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline  result_t RealTimeM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 666
{
  return SUCCESS;
}

# 751 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  result_t GPSSensorM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 751
{
  return SUCCESS;
}

# 438 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  result_t TimeSyncM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 438
{
  return SUCCESS;
}

# 361 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 361
{
  return SUCCESS;
}

# 379 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline  result_t DataMgmtM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 379
{
  return SUCCESS;
}

# 541 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 541
{
  return SUCCESS;
}

# 518 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  result_t MultiHopEngineM$EventReport$eventSendDone(TOS_MsgPtr pMsg, result_t success)
#line 518
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
inline static  result_t EventReportM$EventReport$eventSendDone(uint8_t arg_0x40d0b508, TOS_MsgPtr arg_0x409b64e0, result_t arg_0x409b6670){
#line 47
  unsigned char result;
#line 47

#line 47
  switch (arg_0x40d0b508) {
#line 47
    case EVENT_TYPE_SNMS:
#line 47
      result = MultiHopEngineM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670);
#line 47
      result = rcombine(result, MultiHopLQI$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      result = rcombine(result, MultiHopLQI$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      result = rcombine(result, GenericCommProM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      result = rcombine(result, GPSSensorM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      result = rcombine(result, RealTimeM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      break;
#line 47
    case EVENT_TYPE_SENSING:
#line 47
      result = DataMgmtM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670);
#line 47
      result = rcombine(result, TimeSyncM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      result = rcombine(result, SmartSensingM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670));
#line 47
      break;
#line 47
    case EVENT_TYPE_DATAMANAGE:
#line 47
      result = SmartSensingM$EventReport$eventSendDone(arg_0x409b64e0, arg_0x409b6670);
#line 47
      break;
#line 47
    default:
#line 47
      result = EventReportM$EventReport$default$eventSendDone(arg_0x40d0b508, arg_0x409b64e0, arg_0x409b6670);
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
# 79 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  void NeighborMgmtM$processSnoopMsg(void)
#line 79
{
  uint8_t iNbr;

#line 81
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


  NeighborMgmtM$NeighborTbl[iNbr].lqiRaw = NeighborMgmtM$lqiBuf;
  NeighborMgmtM$NeighborTbl[iNbr].rssiRaw = NeighborMgmtM$rssiBuf;
  NeighborMgmtM$NeighborTbl[iNbr].lastHeard = TRUE;
  NeighborMgmtM$NeighborTbl[iNbr].liveliness = LIVELINESS;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 103
    NeighborMgmtM$processTaskBusy = FALSE;
#line 103
    __nesc_atomic_end(__nesc_atomic); }
}

#line 105
static inline  result_t NeighborMgmtM$Snoop$intercept(TOS_MsgPtr msg, void *payload, uint16_t payloadLen)
#line 105
{

  if (!NeighborMgmtM$processTaskBusy) {


      NeighborMgmtM$lqiBuf = msg->lqi;
      NeighborMgmtM$rssiBuf = msg->strength;
      NeighborMgmtM$nwMsg = (NetworkMsg *)msg->data;
      NeighborMgmtM$linkaddrBuf = NeighborMgmtM$nwMsg->linksource;
      if (TOS_post(NeighborMgmtM$processSnoopMsg) == SUCCESS) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 115
            NeighborMgmtM$processTaskBusy = TRUE;
#line 115
            __nesc_atomic_end(__nesc_atomic); }
        }
    }
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t GenericCommProM$Intercept$intercept(TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990){
#line 86
  unsigned char result;
#line 86

#line 86
  result = NeighborMgmtM$Snoop$intercept(arg_0x40d8d658, arg_0x40d8d7f8, arg_0x40d8d990);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 15 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$setCost(uint16_t arg_0x40e1bc70, uint16_t arg_0x40e1be00){
#line 15
  unsigned char result;
#line 15

#line 15
  result = NeighborMgmtM$NeighborCtrl$setCost(arg_0x40e1bc70, arg_0x40e1be00);
#line 15

#line 15
  return result;
#line 15
}
#line 15
# 441 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  TOS_MsgPtr MultiHopLQI$ReceiveMsg$receive(TOS_MsgPtr Msg)
#line 441
{

  NetworkMsg *pNWMsg = (NetworkMsg *)&Msg->data[0];
  BeaconMsg *pRP = (BeaconMsg *)&pNWMsg->data[0];
  uint16_t oldParent = 0;

#line 446
  MultiHopLQI$receivedBeacon = TRUE;

  if (pNWMsg->linksource != pNWMsg->source || 
  pRP->parent != pRP->parent_dup) {
      return Msg;
    }
  if (MultiHopLQI$localBeSink) {
#line 452
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
#line 469
            MultiHopLQI$NeighborCtrl$setCost(pNWMsg->source, pRP->cost);
            }
        }
      else 
#line 471
        {


          if (!MultiHopLQI$localBeSink) {
              invalidate: 
                ;
              MultiHopLQI$EventReport$eventSend(EVENT_TYPE_SNMS, 
              EVENT_LEVEL_URGENT, eventprintf("Engine:loop p:%i", MultiHopLQI$gbCurrentParent));
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
#line 492
    {


      MultiHopLQI$NeighborCtrl$setCost(pNWMsg->source, pRP->cost);






      if (MultiHopLQI$fixedParent) {
#line 502
        return Msg;
        }





      if (
#line 505
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

# 678 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Intercept$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen)
#line 680
{
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t MultiHopEngineM$Intercept$intercept(uint8_t arg_0x41310200, TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990){
#line 86
  unsigned char result;
#line 86

#line 86
    result = MultiHopEngineM$Intercept$default$intercept(arg_0x41310200, arg_0x40d8d658, arg_0x40d8d7f8, arg_0x40d8d990);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 555 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline result_t MultiHopEngineM$checkForDuplicates(TOS_MsgPtr msg, bool disable)
{
  TOS_MsgPtr oldMsg;
  NetworkMsg *checkingMsg;
  NetworkMsg *passedMsg = (NetworkMsg *)msg->data;
  uint16_t ind;
  TinyDWFQ_t *queue = &MultiHopEngineM$sendQueue;

#line 562
  for (ind = 0; ind < queue->size; ind++) 
    {
      if (queue->element[ind].obj != (void *)0) 
        {
          oldMsg = queue->element[ind].obj;
          checkingMsg = (NetworkMsg *)oldMsg->data;
          if (checkingMsg->source == passedMsg->source && 
          checkingMsg->seqno == passedMsg->seqno) 
            {
              if (disable == TRUE) 
                {
                }

              return FAIL;
            }
        }
    }
  return SUCCESS;
}

# 7 "/home/xu/oasis/interfaces/NeighborCtrl.nc"
inline static  bool MultiHopLQI$NeighborCtrl$addChild(uint16_t arg_0x40e1ddf0, uint16_t arg_0x40e1c010, bool arg_0x40e1c1a0){
#line 7
  unsigned char result;
#line 7

#line 7
  result = NeighborMgmtM$NeighborCtrl$addChild(arg_0x40e1ddf0, arg_0x40e1c010, arg_0x40e1c1a0);
#line 7

#line 7
  return result;
#line 7
}
#line 7
# 570 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$MultihopCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect)
#line 570
{
  return MultiHopLQI$NeighborCtrl$addChild(childAddr, priorHop, isDirect);
}

# 4 "/home/xu/oasis/interfaces/MultihopCtrl.nc"
inline static  result_t MultiHopEngineM$MultihopCtrl$addChild(uint16_t arg_0x40df3928, uint16_t arg_0x40df3ac0, bool arg_0x40df3c50){
#line 4
  unsigned char result;
#line 4

#line 4
  result = MultiHopLQI$MultihopCtrl$addChild(arg_0x40df3928, arg_0x40df3ac0, arg_0x40df3c50);
#line 4

#line 4
  return result;
#line 4
}
#line 4
# 684 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline   result_t MultiHopEngineM$Snoop$default$intercept(uint8_t AMID, TOS_MsgPtr pMsg, 
void *payload, 
uint16_t payloadLen)
#line 686
{
  return SUCCESS;
}

# 86 "/opt/tinyos-1.x/tos/interfaces/Intercept.nc"
inline static  result_t MultiHopEngineM$Snoop$intercept(uint8_t arg_0x413107e0, TOS_MsgPtr arg_0x40d8d658, void *arg_0x40d8d7f8, uint16_t arg_0x40d8d990){
#line 86
  unsigned char result;
#line 86

#line 86
    result = MultiHopEngineM$Snoop$default$intercept(arg_0x413107e0, arg_0x40d8d658, arg_0x40d8d7f8, arg_0x40d8d990);
#line 86

#line 86
  return result;
#line 86
}
#line 86
# 441 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  TOS_MsgPtr MultiHopEngineM$ReceiveMsg$receive(TOS_MsgPtr msg)
{
  NetworkMsg *multiHopMsg = (NetworkMsg *)msg->data;
  uint16_t correctedLength = msg->length - (size_t )& ((NetworkMsg *)0)->data;
  uint8_t AMID = msg->type;


  if (msg->length < MultiHopEngineM$NETWORKMSG_HEADER_LENGTH || 
  msg->length > 74) {
    return msg;
    }
  if (msg->addr != TOS_LOCAL_ADDRESS) 
    {
      MultiHopEngineM$Snoop$intercept(AMID, msg, 
      &multiHopMsg->data[0], 
      correctedLength);
    }
  else 
    {


      if (multiHopMsg->source == multiHopMsg->linksource) {
        MultiHopEngineM$MultihopCtrl$addChild(multiHopMsg->source, multiHopMsg->linksource, TRUE);
        }
      else {
#line 465
        MultiHopEngineM$MultihopCtrl$addChild(multiHopMsg->source, multiHopMsg->linksource, FALSE);
        }
      if (MultiHopEngineM$checkForDuplicates(msg, FALSE) == SUCCESS) 
        {
          if (MultiHopEngineM$Intercept$intercept(AMID, msg, &multiHopMsg->data[0], correctedLength) == SUCCESS) 
            {
              if (MultiHopEngineM$insertAndStartSend(msg, AMID, msg->length, (void *)0) != SUCCESS) 
                {
                  MultiHopEngineM$numberOfSendFailures++;
                  ;
                }
              else 
                {

                  ;
                }
            }
          else 
            {
              ;
            }
        }
      else 
        {
          ;
        }
    }
  return msg;
}

# 902 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline   void TimeSyncM$TimeSyncNotify$default$msg_received(void)
#line 902
{
}

# 20 "/home/xu/oasis/interfaces/TimeSyncNotify.nc"
inline static  void TimeSyncM$TimeSyncNotify$msg_received(void){
#line 20
  TimeSyncM$TimeSyncNotify$default$msg_received();
#line 20
}
#line 20
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t TimeSyncM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SENSING, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 40 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  result_t TimeSyncM$RealTime$setTimeCount(uint32_t arg_0x40abf6d8, uint8_t arg_0x40abf860){
#line 40
  unsigned char result;
#line 40

#line 40
  result = RealTimeM$RealTime$setTimeCount(arg_0x40abf6d8, arg_0x40abf860);
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
# 250 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
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
#line 304
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
# 320 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline void TimeSyncM$addNewEntry(TimeSyncMsg *msg)
{
  int8_t i;
#line 322
  int8_t freeItem = -1;
#line 322
  int8_t oldestItem = 0;
  uint32_t age;
#line 323
  uint32_t oldestTime = 0;
  int32_t timeError;
  int32_t ErrTS;

  TimeSyncM$tableEntries = 0;


  ErrTS = msg->arrivalTime;
  TimeSyncM$GlobalTime$local2Global(&ErrTS);
  timeError = msg->arrivalTime;
  TimeSyncM$GlobalTime$local2Global(&timeError);
  timeError -= msg->sendingTime;

  if (TimeSyncM$is_synced() && (timeError > TimeSyncM$ENTRY_THROWOUT_LIMIT || timeError < -TimeSyncM$ENTRY_THROWOUT_LIMIT)) {
      TimeSyncM$errTimes += 1;
      if (TimeSyncM$errTimes >= TimeSyncM$ERROR_TIMES) {
          TimeSyncM$clearTable();


          TimeSyncM$EventReport$eventSend(EVENT_TYPE_SENSING, EVENT_LEVEL_URGENT, 
          eventprintf("Node %i received 3 cont bad time message %i.\n", TOS_LOCAL_ADDRESS, ErrTS));
        }
      else {
        return;
        }
    }
  if (msg->sendingTime - msg->arrivalTime > DAY_END >> 1 && msg->sendingTime - msg->arrivalTime < -(DAY_END >> 1)) {
      return;
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

#line 442
static inline void  TimeSyncM$processMsg(void)
{
  TimeSyncMsg *msg = (TimeSyncMsg *)TimeSyncM$processedMsg->data;
  uint32_t globalSettime = 0;

#line 460
  if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->hasGPS == msg->hasGPS) {
      if (msg->rootID < ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID && ~(TimeSyncM$heartBeats < TimeSyncM$IGNORE_ROOT_MSG && ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS)) {
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID = msg->rootID;
          ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->seqNum = msg->seqNum;
          TimeSyncM$rootid = msg->rootID;
        }
      else {
#line 466
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
#line 485
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
#line 502
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

              TimeSyncM$GlobalTime$getGlobalTime(&globalSettime);
              TimeSyncM$EventReport$eventSend(EVENT_TYPE_SENSING, EVENT_LEVEL_URGENT, 
              eventprintf("Node %i reset the timecount in RTC at %i.\n", TOS_LOCAL_ADDRESS, globalSettime));

              TimeSyncM$skew = 0.0;
              TimeSyncM$offsetAverage = 0;
              TimeSyncM$localAverage = 0;
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
inline static  result_t TimeSyncM$TimeStamping$getStamp(TOS_MsgPtr arg_0x40e93010, uint32_t *arg_0x40e931c8){
#line 39
  unsigned char result;
#line 39

#line 39
  result = ClockTimeStampingM$TimeStamping$getStamp(arg_0x40e93010, arg_0x40e931c8);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 538 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static inline  TOS_MsgPtr TimeSyncM$ReceiveMsg$receive(TOS_MsgPtr p)
#line 538
{

  TOS_MsgPtr old;
  TimeSyncMsg *newMessage = (TimeSyncMsg *)p->data;

#line 555
  if (TimeSyncM$mode == TS_USER_MODE) {
      return p;
    }







  if (
#line 564
  TimeSyncM$TimeStamping$getStamp(p, 
  & newMessage->arrivalTime) != SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 566
        TimeSyncM$missedReceiveStamps++;
#line 566
        __nesc_atomic_end(__nesc_atomic); }



      return p;
    }





  if (newMessage->wroteStamp != SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 578
        TimeSyncM$missedSendStamps++;
#line 578
        __nesc_atomic_end(__nesc_atomic); }

      return p;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 583
    {
      if (TimeSyncM$state & TimeSyncM$STATE_PROCESSING) {
          {
            struct TOS_Msg *__nesc_temp = 
#line 585
            p;

            {
#line 585
              __nesc_atomic_end(__nesc_atomic); 
#line 585
              return __nesc_temp;
            }
          }
        }
      else 
#line 586
        {
          TimeSyncM$state |= TimeSyncM$STATE_PROCESSING;
        }
    }
#line 589
    __nesc_atomic_end(__nesc_atomic); }



  old = TimeSyncM$processedMsg;
  TimeSyncM$processedMsg = p;

  TOS_post(TimeSyncM$processMsg);
  return old;
}

# 377 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline   TOS_MsgPtr GenericCommProM$ReceiveMsg$default$receive(uint8_t id, TOS_MsgPtr msg)
#line 377
{
  return msg;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr GenericCommProM$ReceiveMsg$receive(uint8_t arg_0x40d923e0, TOS_MsgPtr arg_0x40620878){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  switch (arg_0x40d923e0) {
#line 75
    case AM_NETWORKMSG:
#line 75
      result = MultiHopEngineM$ReceiveMsg$receive(arg_0x40620878);
#line 75
      break;
#line 75
    case AM_CASCTRLMSG:
#line 75
      result = CascadesRouterM$ReceiveMsg$receive(AM_CASCTRLMSG, arg_0x40620878);
#line 75
      break;
#line 75
    case AM_CASCADESMSG:
#line 75
      result = CascadesRouterM$ReceiveMsg$receive(AM_CASCADESMSG, arg_0x40620878);
#line 75
      break;
#line 75
    case AM_TIMESYNCMSG:
#line 75
      result = TimeSyncM$ReceiveMsg$receive(arg_0x40620878);
#line 75
      break;
#line 75
    case AM_BEACONMSG:
#line 75
      result = MultiHopLQI$ReceiveMsg$receive(arg_0x40620878);
#line 75
      break;
#line 75
    default:
#line 75
      result = GenericCommProM$ReceiveMsg$default$receive(arg_0x40d923e0, arg_0x40620878);
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
# 389 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static inline  result_t CascadesRouterM$CascadeControl$addDirectChild(address_t childID)
#line 389
{
  CascadesRouterM$addToChildrenList(childID);
  return SUCCESS;
}

# 3 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  result_t NeighborMgmtM$CascadeControl$addDirectChild(address_t arg_0x4121abb0){
#line 3
  unsigned char result;
#line 3

#line 3
  result = CascadesRouterM$CascadeControl$addDirectChild(arg_0x4121abb0);
#line 3

#line 3
  return result;
#line 3
}
#line 3
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t MultiHopLQI$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_BEACONMSG, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 2 "/home/xu/oasis/lib/NeighborMgmt/CascadeControl.nc"
inline static  uint16_t CascadesRouterM$CascadeControl$getParent(void){
#line 2
  unsigned short result;
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
  TOS_MsgPtr tempPtr = (void *)0;
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
inline static  result_t CascadesRouterM$ACKTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(26U, arg_0x40818878, arg_0x40818a10);
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
  TOS_MsgPtr tempPtr = (void *)0;
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
  result = TimerM$Timer$stop(24U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
#line 59
inline static  result_t CascadesRouterM$DelayTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(25U, arg_0x40818878, arg_0x40818a10);
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
inline static  TOS_MsgPtr CascadesRouterM$Receive$receive(uint8_t arg_0x41369c38, TOS_MsgPtr arg_0x409b8068, void *arg_0x409b8208, uint16_t arg_0x409b83a0){
#line 81
  struct TOS_Msg *result;
#line 81

#line 81
  switch (arg_0x41369c38) {
#line 81
    case NW_RPCC:
#line 81
      result = RpcM$CommandReceive$receive(arg_0x409b8068, arg_0x409b8208, arg_0x409b83a0);
#line 81
      break;
#line 81
    default:
#line 81
      result = CascadesRouterM$Receive$default$receive(arg_0x41369c38, arg_0x409b8068, arg_0x409b8208, arg_0x409b83a0);
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
inline static  result_t CascadesRouterM$RTTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(22U, arg_0x40818878, arg_0x40818a10);
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
  result = TimerM$Timer$stop(25U);
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
  TOS_MsgPtr tempPtr = (void *)0;
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

# 247 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  void SmartSensingM$eraseFlash(void)
#line 247
{
}

# 44 "build/imote2/RpcM.nc"
inline static  void RpcM$SmartSensingM_eraseFlash(void){
#line 44
  SmartSensingM$eraseFlash();
#line 44
}
#line 44
# 584 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setTaskSchedulingCode(uint8_t type, uint16_t code)
#line 584
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 585
    SmartSensingM$defaultCode = code;
#line 585
    __nesc_atomic_end(__nesc_atomic); }



  return SUCCESS;
}

# 43 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(uint8_t arg_0x409bf348, uint16_t arg_0x409bf4d8){
#line 43
  unsigned char result;
#line 43

#line 43
  result = SmartSensingM$SensingConfig$setTaskSchedulingCode(arg_0x409bf348, arg_0x409bf4d8);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 33 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
inline static  result_t SmartSensingM$FlashManager$write(uint32_t arg_0x40ab7c08, void *arg_0x40ab7da8, uint16_t arg_0x40adc010){
#line 33
  unsigned char result;
#line 33

#line 33
  result = FlashManagerM$FlashManager$write(arg_0x40ab7c08, arg_0x40ab7da8, arg_0x40adc010);
#line 33

#line 33
  return result;
#line 33
}
#line 33
# 346 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setSamplingRate(uint8_t type, uint16_t rate)
#line 346
{
  int8_t client;
  uint16_t oldrate;

  uint32_t addr;

  if (rate > MAX_SAMPLING_RATE) {
      return FAIL;
    }
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          oldrate = sensor[client].samplingRate;
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 358
            sensor[client].samplingRate = rate == 0 ? 0 : 1000UL / rate;
#line 358
            __nesc_atomic_end(__nesc_atomic); }
          if (oldrate != sensor[client].samplingRate) {
              SmartSensingM$updateMaxBlkNum();
              SmartSensingM$setrate();

              SmartSensingM$upFlashClient();
              SmartSensingM$FlashManager$write(0, (void *)&FlashCliUnit, 8 + NUM_BYTES);
            }

          return SUCCESS;
        }
    }
  return FAIL;
}

# 27 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setSamplingRate(uint8_t arg_0x409a19e0, uint16_t arg_0x409a1b78){
#line 27
  unsigned char result;
#line 27

#line 27
  result = SmartSensingM$SensingConfig$setSamplingRate(arg_0x409a19e0, arg_0x409a1b78);
#line 27

#line 27
  return result;
#line 27
}
#line 27
# 546 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setNodePriority(uint8_t priority)
#line 546
{
  int8_t client;

  uint32_t addr;

  if (priority < 8) {
      for (client = sensor_num - 1; client >= 0; client--) {

          sensor[client].nodePriority = priority;
        }






      return SUCCESS;
    }
  return FAIL;
}

# 39 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setNodePriority(uint8_t arg_0x4099fad8){
#line 39
  unsigned char result;
#line 39

#line 39
  result = SmartSensingM$SensingConfig$setNodePriority(arg_0x4099fad8);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 475 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setEventPriority(uint8_t type, uint8_t priority)
#line 475
{
  int8_t client;

  if (priority < 8) {
      for (client = sensor_num - 1; client >= 0; client--) {
          if (sensor[client].type == type) {
              eventPrio = priority;
              return SUCCESS;
            }
        }
    }
  return FAIL;
}

# 47 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setEventPriority(uint8_t arg_0x409bfe20, uint8_t arg_0x409be010){
#line 47
  unsigned char result;
#line 47

#line 47
  result = SmartSensingM$SensingConfig$setEventPriority(arg_0x409bfe20, arg_0x409be010);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 500 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setDataPriority(uint8_t type, uint8_t priority)
#line 500
{
  int8_t client;

  uint32_t addr;

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
inline static  result_t RpcM$SmartSensingM_SensingConfig$setDataPriority(uint8_t arg_0x4099f010, uint8_t arg_0x4099f1a0){
#line 35
  unsigned char result;
#line 35

#line 35
  result = SmartSensingM$SensingConfig$setDataPriority(arg_0x4099f010, arg_0x4099f1a0);
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 400 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingConfig$setADCChannel(uint8_t type, uint8_t channel)
#line 400
{
  int8_t client;

  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          sensor[client].channel = channel;
          SmartSensingM$ADCControl$bindPort(client, channel);

          SmartSensingM$upFlashClient();
          SmartSensingM$FlashManager$write(0, (void *)&FlashCliUnit, 128);

          return SUCCESS;
        }
    }

  if (sensor_num < MAX_SENSOR_NUM) {
      sensor[sensor_num].type = type;
      sensor[sensor_num].channel = channel;
      SmartSensingM$ADCControl$bindPort(sensor_num, channel);

      SmartSensingM$upFlashClient();
      SmartSensingM$FlashManager$write(0, (void *)&FlashCliUnit, 128);
      ++sensor_num;



      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 31 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  result_t RpcM$SmartSensingM_SensingConfig$setADCChannel(uint8_t arg_0x409a04c8, uint8_t arg_0x409a0650){
#line 31
  unsigned char result;
#line 31

#line 31
  result = SmartSensingM$SensingConfig$setADCChannel(arg_0x409a04c8, arg_0x409a0650);
#line 31

#line 31
  return result;
#line 31
}
#line 31
# 572 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint16_t SmartSensingM$SensingConfig$getTaskSchedulingCode(uint8_t type)
#line 572
{
  return SmartSensingM$defaultCode;
}

# 45 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint16_t RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(uint8_t arg_0x409bf980){
#line 45
  unsigned short result;
#line 45

#line 45
  result = SmartSensingM$SensingConfig$getTaskSchedulingCode(arg_0x409bf980);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 324 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint16_t SmartSensingM$SensingConfig$getSamplingRate(uint8_t type)
#line 324
{
  int8_t client;

#line 326
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
inline static  uint16_t RpcM$SmartSensingM_SensingConfig$getSamplingRate(uint8_t arg_0x409a0030){
#line 29
  unsigned short result;
#line 29

#line 29
  result = SmartSensingM$SensingConfig$getSamplingRate(arg_0x409a0030);
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 527 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getNodePriority(void)
#line 527
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
# 457 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getEventPriority(uint8_t type)
#line 457
{
  int8_t client;

#line 459
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          return eventPrio;
        }
    }
  return -1;
}

# 49 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getEventPriority(uint8_t arg_0x409be4b0){
#line 49
  unsigned char result;
#line 49

#line 49
  result = SmartSensingM$SensingConfig$getEventPriority(arg_0x409be4b0);
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 440 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getDataPriority(uint8_t type)
#line 440
{
  int8_t client;

#line 442
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          return sensor[client].dataPriority;
        }
    }
  return -1;
}

# 37 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getDataPriority(uint8_t arg_0x4099f638){
#line 37
  unsigned char result;
#line 37

#line 37
  result = SmartSensingM$SensingConfig$getDataPriority(arg_0x4099f638);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 380 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  uint8_t SmartSensingM$SensingConfig$getADCChannel(uint8_t type)
#line 380
{
  int8_t client;

#line 382
  for (client = sensor_num - 1; client >= 0; client--) {
      if (sensor[client].type == type) {
          return sensor[client].channel;
        }
    }
  return -1;
}

# 33 "/home/xu/oasis/interfaces/SensingConfig.nc"
inline static  uint8_t RpcM$SmartSensingM_SensingConfig$getADCChannel(uint8_t arg_0x409a0ae8){
#line 33
  unsigned char result;
#line 33

#line 33
  result = SmartSensingM$SensingConfig$getADCChannel(arg_0x409a0ae8);
#line 33

#line 33
  return result;
#line 33
}
#line 33
# 42 "build/imote2/RpcM.nc"
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

# 41 "build/imote2/RpcM.nc"
inline static  result_t RpcM$SNMSM_ledsOn(uint8_t arg_0x40d36820){
#line 41
  unsigned char result;
#line 41

#line 41
  result = SNMSM$ledsOn(arg_0x40d36820);
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

# 40 "build/imote2/RpcM.nc"
inline static  unsigned int RpcM$RamSymbolsM_poke(ramSymbol_t *arg_0x40d36380){
#line 40
  unsigned int result;
#line 40

#line 40
  result = RamSymbolsM$poke(arg_0x40d36380);
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

# 39 "build/imote2/RpcM.nc"
inline static  ramSymbol_t RpcM$RamSymbolsM_peek(unsigned int arg_0x40d33b48, uint8_t arg_0x40d33cd0, bool arg_0x40d33e60){
#line 39
  struct ramSymbol_t result;
#line 39

#line 39
  result = RamSymbolsM$peek(arg_0x40d33b48, arg_0x40d33cd0, arg_0x40d33e60);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 580 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteRpcCtrl$setSink(bool enable)
#line 580
{
  if (enable) {
      if (MultiHopLQI$localBeSink) {
#line 582
        return SUCCESS;
        }
#line 583
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
#line 597
        return SUCCESS;
        }
#line 598
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

# 2 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setSink(bool arg_0x40d34010){
#line 2
  unsigned char result;
#line 2

#line 2
  result = MultiHopLQI$RouteRpcCtrl$setSink(arg_0x40d34010);
#line 2

#line 2
  return result;
#line 2
}
#line 2
# 392 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$setParent(uint16_t parentAddr)
#line 392
{
  MultiHopLQI$fixedParent = TRUE;
  MultiHopLQI$gbCurrentParent = parentAddr;

  MultiHopLQI$NeighborCtrl$setParent(MultiHopLQI$gbCurrentParent);



  return SUCCESS;
}

#line 614
static inline  result_t MultiHopLQI$RouteRpcCtrl$setParent(uint16_t parentAddr)
#line 614
{
  if (parentAddr == TOS_LOCAL_ADDRESS || MultiHopLQI$localBeSink) {
    return FAIL;
    }
#line 617
  return MultiHopLQI$RouteControl$setParent(parentAddr);
}

# 3 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setParent(uint16_t arg_0x40d344b8){
#line 3
  unsigned char result;
#line 3

#line 3
  result = MultiHopLQI$RouteRpcCtrl$setParent(arg_0x40d344b8);
#line 3

#line 3
  return result;
#line 3
}
#line 3
# 382 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$setUpdateInterval(uint16_t Interval)
#line 382
{
  MultiHopLQI$gUpdateInterval = Interval;
  return SUCCESS;
}

#line 626
static inline  result_t MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(uint16_t seconds)
#line 626
{
  if (seconds <= 0 || seconds >= 60) {
    return FAIL;
    }
#line 629
  return MultiHopLQI$RouteControl$setUpdateInterval(seconds);
}

# 5 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
inline static  result_t RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(uint16_t arg_0x40d34c68){
#line 5
  unsigned char result;
#line 5

#line 5
  result = MultiHopLQI$RouteRpcCtrl$setBeaconUpdateInterval(arg_0x40d34c68);
#line 5

#line 5
  return result;
#line 5
}
#line 5
# 403 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  result_t MultiHopLQI$RouteControl$releaseParent(void)
#line 403
{
  if (!MultiHopLQI$fixedParent) {
#line 404
    return FAIL;
    }
#line 405
  MultiHopLQI$fixedParent = FALSE;


  MultiHopLQI$gbCurrentParentCost = 0x7fff;
  MultiHopLQI$gbCurrentLinkEst = 0x7fff;
  MultiHopLQI$gbLinkQuality = 0;
  MultiHopLQI$gbCurrentParent = TOS_BCAST_ADDR;
  MultiHopLQI$gbCurrentHopCount = MultiHopLQI$ROUTE_INVALID;
  return SUCCESS;
}

#line 620
static inline  result_t MultiHopLQI$RouteRpcCtrl$releaseParent(void)
#line 620
{
  if (MultiHopLQI$localBeSink) {
    return FAIL;
    }
#line 623
  return MultiHopLQI$RouteControl$releaseParent();
}

# 4 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
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
# 632 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteRpcCtrl$getBeaconUpdateInterval(void)
#line 632
{
  return MultiHopLQI$gUpdateInterval;
}

# 6 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteRpcCtrl.nc"
inline static  uint16_t RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval(void){
#line 6
  unsigned short result;
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
inline static  result_t GenericCommProM$CC2420Control$SetRFPower(uint8_t arg_0x4095df20){
#line 178
  unsigned char result;
#line 178

#line 178
  result = CC2420ControlM$CC2420Control$SetRFPower(arg_0x4095df20);
#line 178

#line 178
  return result;
#line 178
}
#line 178
# 756 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$setRFPower(uint8_t level)
#line 756
{
  if (level >= 1 && level <= 31) {
    return GenericCommProM$CC2420Control$SetRFPower(level);
    }
  else {
#line 760
    return FAIL;
    }
}

# 37 "build/imote2/RpcM.nc"
inline static  result_t RpcM$GenericCommProM_setRFPower(uint8_t arg_0x40d3de18){
#line 37
  unsigned char result;
#line 37

#line 37
  result = GenericCommProM$setRFPower(arg_0x40d3de18);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 33 "/home/xu/oasis/lib/SmartSensing/FlashManager.nc"
inline static  result_t GenericCommProM$FlashManager$write(uint32_t arg_0x40ab7c08, void *arg_0x40ab7da8, uint16_t arg_0x40adc010){
#line 33
  unsigned char result;
#line 33

#line 33
  result = FlashManagerM$FlashManager$write(arg_0x40ab7c08, arg_0x40ab7da8, arg_0x40adc010);
#line 33

#line 33
  return result;
#line 33
}
#line 33
# 747 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$setRFChannel(uint8_t channel)
#line 747
{
  if (channel >= 11 && channel <= 26) {
      GenericCommProM$FlashManager$write(0, (void *)&channel, 1);
      return GenericCommProM$CC2420Control$TunePreset(channel);
    }
  else {
    return FAIL;
    }
}

# 36 "build/imote2/RpcM.nc"
inline static  result_t RpcM$GenericCommProM_setRFChannel(uint8_t arg_0x40d3d970){
#line 36
  unsigned char result;
#line 36

#line 36
  result = GenericCommProM$setRFChannel(arg_0x40d3d970);
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
# 767 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  uint8_t GenericCommProM$getRFPower(void)
#line 767
{
  return GenericCommProM$CC2420Control$GetRFPower();
}

# 35 "build/imote2/RpcM.nc"
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
# 763 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  uint8_t GenericCommProM$getRFChannel(void)
#line 763
{
  return GenericCommProM$CC2420Control$GetPreset();
}

# 34 "build/imote2/RpcM.nc"
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
inline static  result_t RpcM$EventReportM_EventConfig$setReportLevel(uint8_t arg_0x40cb1e50, uint8_t arg_0x40cae010){
#line 38
  unsigned char result;
#line 38

#line 38
  result = EventReportM$EventConfig$setReportLevel(arg_0x40cb1e50, arg_0x40cae010);
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
inline static  uint8_t RpcM$EventReportM_EventConfig$getReportLevel(uint8_t arg_0x40cae5d0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = EventReportM$EventConfig$getReportLevel(arg_0x40cae5d0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 106 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  void *RpcM$ResponseSend$getBuffer(TOS_MsgPtr arg_0x409bcb88, uint16_t *arg_0x409bcd38){
#line 106
  void *result;
#line 106

#line 106
  result = MultiHopEngineM$Send$getBuffer(NW_RPCR, arg_0x409bcb88, arg_0x409bcd38);
#line 106

#line 106
  return result;
#line 106
}
#line 106
# 152 "build/imote2/RpcM.nc"
static inline  void RpcM$processCommand(void)
#line 152
{

  ApplicationMsg *RecvMsg = (ApplicationMsg *)RpcM$cmdStore.data;
  RpcCommandMsg *msg = (RpcCommandMsg *)RecvMsg->data;

  uint8_t *byteSrc = msg->data;
  uint16_t maxLength;
  uint16_t id = msg->commandID;

  NetworkMsg *NMsg = (NetworkMsg *)RpcM$sendMsgPtr->data;

  ApplicationMsg *AppMsg = (ApplicationMsg *)RpcM$ResponseSend$getBuffer(RpcM$sendMsgPtr, &maxLength);
  RpcResponseMsg *responseMsg = (RpcResponseMsg *)AppMsg->data;

#line 165
  NMsg->qos = 7;
  {
  }
#line 166
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
#line 182
    if (id < 28 && msg->dataLength != RpcM$args_sizes[id]) {
        responseMsg->errorCode = RPC_GARBAGE_ARGS;
        {
        }
#line 184
        ;
      }
    else {
#line 185
      if (id < 28 && RpcM$return_sizes[id] + sizeof(RpcResponseMsg ) > maxLength) {
          responseMsg->errorCode = RPC_RESPONSE_TOO_LARGE;
          {
          }
#line 187
          ;
        }
      else 
#line 188
        {


          switch (id) {


              case 0: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 197
                  {
                  }
#line 197
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$EventReportM_EventConfig$getReportLevel(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 201
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 203
                  ;
                  {
                  }
#line 204
                  ;
                }
#line 205
              break;


              case 1: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_level;

#line 212
                  {
                  }
#line 212
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_level, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$EventReportM_EventConfig$setReportLevel(RPC_type, RPC_level);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 218
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 220
                  ;
                  {
                  }
#line 221
                  ;
                }
#line 222
              break;


              case 2: {
                  uint8_t RPC_returnVal;

#line 227
                  {
                  }
#line 227
                  ;
                  RPC_returnVal = RpcM$GenericCommProM_getRFChannel();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 230
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 232
                  ;
                  {
                  }
#line 233
                  ;
                }
#line 234
              break;


              case 3: {
                  uint8_t RPC_returnVal;

#line 239
                  {
                  }
#line 239
                  ;
                  RPC_returnVal = RpcM$GenericCommProM_getRFPower();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 242
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 244
                  ;
                  {
                  }
#line 245
                  ;
                }
#line 246
              break;


              case 4: {
                  result_t RPC_returnVal;
                  uint8_t RPC_channel;

#line 252
                  {
                  }
#line 252
                  ;
                  nmemcpy(&RPC_channel, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$GenericCommProM_setRFChannel(RPC_channel);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 256
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 258
                  ;
                  {
                  }
#line 259
                  ;
                }
#line 260
              break;


              case 5: {
                  result_t RPC_returnVal;
                  uint8_t RPC_level;

#line 266
                  {
                  }
#line 266
                  ;
                  nmemcpy(&RPC_level, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$GenericCommProM_setRFPower(RPC_level);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 270
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 272
                  ;
                  {
                  }
#line 273
                  ;
                }
#line 274
              break;


              case 6: {
                  uint16_t RPC_returnVal;

#line 279
                  {
                  }
#line 279
                  ;
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$getBeaconUpdateInterval();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 282
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 284
                  ;
                  {
                  }
#line 285
                  ;
                }
#line 286
              break;


              case 7: {
                  result_t RPC_returnVal;

#line 291
                  {
                  }
#line 291
                  ;
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$releaseParent();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 294
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 296
                  ;
                  {
                  }
#line 297
                  ;
                }
#line 298
              break;


              case 8: {
                  result_t RPC_returnVal;
                  uint16_t RPC_seconds;

#line 304
                  {
                  }
#line 304
                  ;
                  nmemcpy(&RPC_seconds, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setBeaconUpdateInterval(RPC_seconds);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 308
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 310
                  ;
                  {
                  }
#line 311
                  ;
                }
#line 312
              break;


              case 9: {
                  result_t RPC_returnVal;
                  uint16_t RPC_parentAddr;

#line 318
                  {
                  }
#line 318
                  ;
                  nmemcpy(&RPC_parentAddr, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setParent(RPC_parentAddr);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 322
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 324
                  ;
                  {
                  }
#line 325
                  ;
                }
#line 326
              break;


              case 10: {
                  result_t RPC_returnVal;
                  bool RPC_enable;

#line 332
                  {
                  }
#line 332
                  ;
                  nmemcpy(&RPC_enable, byteSrc, sizeof(bool ));
                  RPC_returnVal = RpcM$MultiHopLQI_RouteRpcCtrl$setSink(RPC_enable);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 336
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 338
                  ;
                  {
                  }
#line 339
                  ;
                }
#line 340
              break;


              case 11: {
                  ramSymbol_t RPC_returnVal;
                  unsigned int RPC_memAddress;
                  uint8_t RPC_length;
                  bool RPC_dereference;

#line 348
                  {
                  }
#line 348
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
#line 356
                  ;
                  responseMsg->dataLength = sizeof(ramSymbol_t );
                  {
                  }
#line 358
                  ;
                  {
                  }
#line 359
                  ;
                }
#line 360
              break;


              case 12: {
                  unsigned int RPC_returnVal;
                  ramSymbol_t RPC_symbol;

#line 366
                  {
                  }
#line 366
                  ;
                  nmemcpy(&RPC_symbol, byteSrc, sizeof(ramSymbol_t ));
                  RPC_returnVal = RpcM$RamSymbolsM_poke(&RPC_symbol);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(unsigned int ));
                  {
                  }
#line 370
                  ;
                  responseMsg->dataLength = sizeof(unsigned int );
                  {
                  }
#line 372
                  ;
                  {
                  }
#line 373
                  ;
                }
#line 374
              break;


              case 13: {
                  result_t RPC_returnVal;
                  uint8_t RPC_ledColorParam;

#line 380
                  {
                  }
#line 380
                  ;
                  nmemcpy(&RPC_ledColorParam, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SNMSM_ledsOn(RPC_ledColorParam);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 384
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 386
                  ;
                  {
                  }
#line 387
                  ;
                }
#line 388
              break;


              case 14: {
                  {
                  }
#line 392
                  ;
                  RpcM$SNMSM_restart();
                  {
                  }
#line 394
                  ;
                  {
                  }
#line 395
                  ;
                }
#line 396
              break;


              case 15: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 402
                  {
                  }
#line 402
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getADCChannel(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 406
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 408
                  ;
                  {
                  }
#line 409
                  ;
                }
#line 410
              break;


              case 16: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 416
                  {
                  }
#line 416
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getDataPriority(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 420
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 422
                  ;
                  {
                  }
#line 423
                  ;
                }
#line 424
              break;


              case 17: {
                  uint8_t RPC_returnVal;
                  uint8_t RPC_type;

#line 430
                  {
                  }
#line 430
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getEventPriority(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 434
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 436
                  ;
                  {
                  }
#line 437
                  ;
                }
#line 438
              break;


              case 18: {
                  uint8_t RPC_returnVal;

#line 443
                  {
                  }
#line 443
                  ;
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getNodePriority();
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint8_t ));
                  {
                  }
#line 446
                  ;
                  responseMsg->dataLength = sizeof(uint8_t );
                  {
                  }
#line 448
                  ;
                  {
                  }
#line 449
                  ;
                }
#line 450
              break;


              case 19: {
                  uint16_t RPC_returnVal;
                  uint8_t RPC_type;

#line 456
                  {
                  }
#line 456
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getSamplingRate(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 460
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 462
                  ;
                  {
                  }
#line 463
                  ;
                }
#line 464
              break;


              case 20: {
                  uint16_t RPC_returnVal;
                  uint8_t RPC_type;

#line 470
                  {
                  }
#line 470
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$getTaskSchedulingCode(RPC_type);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(uint16_t ));
                  {
                  }
#line 474
                  ;
                  responseMsg->dataLength = sizeof(uint16_t );
                  {
                  }
#line 476
                  ;
                  {
                  }
#line 477
                  ;
                }
#line 478
              break;


              case 21: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_channel;

#line 485
                  {
                  }
#line 485
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_channel, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setADCChannel(RPC_type, RPC_channel);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 491
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 493
                  ;
                  {
                  }
#line 494
                  ;
                }
#line 495
              break;


              case 22: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_priority;

#line 502
                  {
                  }
#line 502
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_priority, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setDataPriority(RPC_type, RPC_priority);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 508
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 510
                  ;
                  {
                  }
#line 511
                  ;
                }
#line 512
              break;


              case 23: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint8_t RPC_priority;

#line 519
                  {
                  }
#line 519
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_priority, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setEventPriority(RPC_type, RPC_priority);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 525
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 527
                  ;
                  {
                  }
#line 528
                  ;
                }
#line 529
              break;


              case 24: {
                  result_t RPC_returnVal;
                  uint8_t RPC_priority;

#line 535
                  {
                  }
#line 535
                  ;
                  nmemcpy(&RPC_priority, byteSrc, sizeof(uint8_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setNodePriority(RPC_priority);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 539
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 541
                  ;
                  {
                  }
#line 542
                  ;
                }
#line 543
              break;


              case 25: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint16_t RPC_samplingRate;

#line 550
                  {
                  }
#line 550
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_samplingRate, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setSamplingRate(RPC_type, RPC_samplingRate);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 556
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 558
                  ;
                  {
                  }
#line 559
                  ;
                }
#line 560
              break;


              case 26: {
                  result_t RPC_returnVal;
                  uint8_t RPC_type;
                  uint16_t RPC_code;

#line 567
                  {
                  }
#line 567
                  ;
                  nmemcpy(&RPC_type, byteSrc, sizeof(uint8_t ));
                  byteSrc += sizeof(uint8_t );
                  nmemcpy(&RPC_code, byteSrc, sizeof(uint16_t ));
                  RPC_returnVal = RpcM$SmartSensingM_SensingConfig$setTaskSchedulingCode(RPC_type, RPC_code);
                  nmemcpy(&responseMsg->data[0], &RPC_returnVal, sizeof(result_t ));
                  {
                  }
#line 573
                  ;
                  responseMsg->dataLength = sizeof(result_t );
                  {
                  }
#line 575
                  ;
                  {
                  }
#line 576
                  ;
                }
#line 577
              break;


              case 27: {
                  {
                  }
#line 581
                  ;
                  RpcM$SmartSensingM_eraseFlash();
                  {
                  }
#line 583
                  ;
                  {
                  }
#line 584
                  ;
                }
#line 585
              break;

              default: 
                {
                }
#line 588
              ;
              responseMsg->errorCode = RPC_PROCEDURE_UNAVAIL;
            }
        }
      }
    }
#line 593
  {
  }
#line 593
  ;
  {
  }
#line 594
  ;


  AppMsg->type = TYPE_SNMS_RPCRESPONSE;
  AppMsg->length = responseMsg->dataLength + (size_t )& ((RpcResponseMsg *)0)->data;
  AppMsg->seqno = RpcM$seqno++;


  ;


  if (msg->responseDesired == 0) {
      {
      }
#line 606
      ;
      RpcM$processingCommand = FALSE;
    }
  else {

      RpcM$processingCommand = FALSE;
      RpcM$tryNextSend();
    }
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t FlashManagerM$EraseTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(12U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 142 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_SET_GREEN_LED_PIN(void)
#line 142
{
#line 142
  * (volatile uint32_t *)(0x40E00018 + (104 < 96 ? ((104 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (104 & 0x1f);
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

# 142 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_CLR_GREEN_LED_PIN(void)
#line 142
{
#line 142
  * (volatile uint32_t *)(0x40E00024 + (104 < 96 ? ((104 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (104 & 0x1f);
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

# 143 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_SET_YELLOW_LED_PIN(void)
#line 143
{
#line 143
  * (volatile uint32_t *)(0x40E00018 + (105 < 96 ? ((105 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (105 & 0x1f);
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

# 143 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_CLR_YELLOW_LED_PIN(void)
#line 143
{
#line 143
  * (volatile uint32_t *)(0x40E00024 + (105 < 96 ? ((105 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (105 & 0x1f);
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

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$WatchTimer$stop(void){
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
# 83 "/opt/tinyos-1.x/tos/interfaces/Send.nc"
inline static  result_t RpcM$ResponseSend$send(TOS_MsgPtr arg_0x409bc330, uint16_t arg_0x409bc4c0){
#line 83
  unsigned char result;
#line 83

#line 83
  result = MultiHopEngineM$Send$send(NW_RPCR, arg_0x409bc330, arg_0x409bc4c0);
#line 83

#line 83
  return result;
#line 83
}
#line 83
# 750 "build/imote2/RpcM.nc"
static inline  void RpcM$sendResponse(void)
#line 750
{
  uint16_t maxLength;
  ApplicationMsg *AppMsg = (ApplicationMsg *)RpcM$ResponseSend$getBuffer(RpcM$sendMsgPtr, &maxLength);
  RpcResponseMsg *responseMsg = (RpcResponseMsg *)AppMsg->data;








  if (RpcM$ResponseSend$send(RpcM$sendMsgPtr, 
  responseMsg->dataLength + (size_t )& ((RpcResponseMsg *)0)->data + (size_t )& ((ApplicationMsg *)0)->data)) {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 765
        RpcM$taskBusy = FALSE;
#line 765
        __nesc_atomic_end(__nesc_atomic); }
    }
  else 
    {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 769
        RpcM$taskBusy = FALSE;
#line 769
        __nesc_atomic_end(__nesc_atomic); }
      ;
      RpcM$tryNextSend();
    }
}

# 393 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  result_t GenericCommProM$RadioSend$sendDone(TOS_MsgPtr msg, result_t status)
#line 393
{
  GenericCommProM$radioSendActive = TRUE;
  return GenericCommProM$reportSendDone(msg, status);
}

# 67 "/opt/tinyos-1.x/tos/interfaces/BareSendMsg.nc"
inline static  result_t CC2420RadioM$Send$sendDone(TOS_MsgPtr arg_0x4061e348, result_t arg_0x4061e4d8){
#line 67
  unsigned char result;
#line 67

#line 67
  result = GenericCommProM$RadioSend$sendDone(arg_0x4061e348, arg_0x4061e4d8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 677 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$HPLCC2420FifoWriteTxFifoReleaseError(void)
#line 677
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.writeTXFIFO failed while attempting to release the SSP port\r\n");
}

# 187 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline void TOSH_CLR_CC_CSN_PIN(void)
#line 187
{
#line 187
  * (volatile uint32_t *)(0x40E00024 + (39 < 96 ? ((39 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (39 & 0x1f);
}

# 674 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$HPLCC2420FifoWriteTxFifoContentioError(void)
#line 674
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.writeTXFIFO has attempted to access the radio during an existing radio operation\r\n");
}

#line 689
static inline   result_t HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(uint8_t length, uint8_t *data)
#line 689
{
  uint8_t OkToUse;

#line 691
  if (HPLCC2420M$getSSPPort() == FAIL) {

      TOS_post(HPLCC2420M$HPLCC2420FifoWriteTxFifoContentioError);
      return FAIL;
    }






  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 702
    {
      HPLCC2420M$txbuf = data;
      HPLCC2420M$txlen = length;
      OkToUse = HPLCC2420M$gbDMAChannelInitDone;
    }
#line 706
    __nesc_atomic_end(__nesc_atomic); }
#line 732
  {

    int i;
    uint8_t tmp;

    {
#line 737
      while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
    }
#line 737
    ;

    {
#line 739
      TOSH_CLR_CC_CSN_PIN();
#line 739
      TOSH_uwait(1);
    }
#line 739
    ;
    * (volatile uint32_t *)0x41900010 = 0x3E;
    while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;

    while (length > 16) {

        for (i = 0; i < 16; i++) {
            * (volatile uint32_t *)0x41900010 = * data++;
          }
        while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
        length -= 16;
      }
    for (i = 0; i < length; i++) {
        * (volatile uint32_t *)0x41900010 = * data++;
      }
    while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;


    for (i = 0; i < 16; i++) {
        tmp = * (volatile uint32_t *)0x41900010;
      }
    TOS_post(HPLCC2420M$signalTXFIFO);
    {
#line 761
      TOSH_uwait(1);
#line 761
      TOSH_SET_CC_CSN_PIN();
    }
#line 761
    ;
    {
#line 762
      while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
    }
#line 762
    ;

    if (HPLCC2420M$releaseSSPPort() == FAIL) {
        TOS_post(HPLCC2420M$HPLCC2420FifoWriteTxFifoReleaseError);
        return 0;
      }




    return SUCCESS;
  }
}

# 29 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$writeTXFIFO(uint8_t arg_0x40f1dd70, uint8_t *arg_0x40f1df18){
#line 29
  unsigned char result;
#line 29

#line 29
  result = HPLCC2420M$HPLCC2420FIFO$writeTXFIFO(arg_0x40f1dd70, arg_0x40f1df18);
#line 29

#line 29
  return result;
#line 29
}
#line 29
# 721 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline   result_t CC2420RadioM$HPLChipconFIFO$TXFIFODone(uint8_t length, uint8_t *data)
#line 721
{
  CC2420RadioM$tryToSend();
  return SUCCESS;
}

# 50 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t HPLCC2420M$HPLCC2420FIFO$TXFIFODone(uint8_t arg_0x40f1cc58, uint8_t *arg_0x40f1ce00){
#line 50
  unsigned char result;
#line 50

#line 50
  result = CC2420RadioM$HPLChipconFIFO$TXFIFODone(arg_0x40f1cc58, arg_0x40f1ce00);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 61 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint16_t CC2420RadioM$HPLChipcon$read(uint8_t arg_0x40956010){
#line 61
  unsigned short result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0x40956010);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 282 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$HPLCC2420ReadContentionError(void)
#line 282
{
  trace(DBG_USR1, "ERROR:  HPLCC2420.read has attempted to access the radio during an existing radio operation\r\n");
}

static inline  void HPLCC2420M$HPLCC2420ReadReleaseError(void)
#line 286
{
  trace(DBG_USR1, "ERROR:  HPLCC2420.read failed while attempting to release the SSP port\r\n");
}

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$FIFOP_GPIOInt$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(0, arg_0x406321d8);
#line 45
}
#line 45
# 184 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline char TOSH_READ_RADIO_CCA_PIN(void)
#line 184
{
#line 184
  return (* (volatile uint32_t *)(0x40E00000 + (116 < 96 ? ((116 & 0x7f) >> 5) * 4 : 0x100)) & (1 << (116 & 0x1f))) != 0;
}

# 751 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
static inline    int16_t CC2420RadioM$MacBackoff$default$congestionBackoff(TOS_MsgPtr m)
#line 751
{
  return (CC2420RadioM$Random$rand() & 0x3F) + 1;
}

# 75 "/opt/tinyos-1.x/tos/lib/CC2420Radio/MacBackoff.nc"
inline static   int16_t CC2420RadioM$MacBackoff$congestionBackoff(TOS_MsgPtr arg_0x40f2adb0){
#line 75
  short result;
#line 75

#line 75
  result = CC2420RadioM$MacBackoff$default$congestionBackoff(arg_0x40f2adb0);
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

# 43 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t CC2420RadioM$SFD$enableCapture(bool arg_0x40f1fd70){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420M$CaptureSFD$enableCapture(arg_0x40f1fd70);
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420.nc"
inline static   uint8_t CC2420RadioM$HPLChipcon$cmd(uint8_t arg_0x40957408){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420$cmd(arg_0x40957408);
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

# 45 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$SFD_GPIOInt$enable(uint8_t arg_0x406321d8){
#line 45
  PXA27XGPIOIntM$PXA27XGPIOInt$enable(16, arg_0x406321d8);
#line 45
}
#line 45
# 180 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   uint32_t GPSSensorM$GPSGlobalTime$getLocalTime(void)
#line 180
{
  uint32_t localtime;

#line 182
  localtime = GPSSensorM$LocalTime$read();
  return localtime;
}

# 441 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline uint8_t RealTimeM$dequeue(void)
#line 441
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 442
    {
      if (RealTimeM$queue_size == 0) {
          {
            unsigned char __nesc_temp = 
#line 444
            30;

            {
#line 444
              __nesc_atomic_end(__nesc_atomic); 
#line 444
              return __nesc_temp;
            }
          }
        }
      else 
#line 446
        {
          if (RealTimeM$queue_head == 30 - 1) {
              RealTimeM$queue_head = -1;
            }
          RealTimeM$queue_head++;
          RealTimeM$queue_size--;
          {
            unsigned char __nesc_temp = 
#line 452
            RealTimeM$queue[(uint8_t )RealTimeM$queue_head];

            {
#line 452
              __nesc_atomic_end(__nesc_atomic); 
#line 452
              return __nesc_temp;
            }
          }
        }
    }
#line 456
    __nesc_atomic_end(__nesc_atomic); }
}

# 52 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t SmartSensingM$ADC$getData(uint8_t arg_0x40aa9310){
#line 52
  unsigned char result;
#line 52

#line 52
  result = ADCM$ADC$getData(arg_0x40aa9310);
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 935 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline bool SmartSensingM$needSample(uint8_t client)
#line 935
{
  SenBlkPtr p = (void *)0;

#line 937
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

  if ((void *)0 != (p = sensor[client].curBlkPtr)) {

      if (0 == p->time) {
          p->time = SmartSensingM$RealTime$getTimeCount();
          p->interval = sensor[client].samplingRate;
          p->type = sensor[client].type;
        }

      return TRUE;
    }
  else {
      if ((void *)0 != (sensor[client].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(client))) {
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
#line 983
{
  uint8_t client;

#line 985
  for (client = 0; client < sensor_num; client++) {
      if (FALSE != SmartSensingM$needSample(client)) {
          if (sensor[client].type == TYPE_DATA_LQI) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 988
                SmartSensingM$saveData(client, 0);
#line 988
                __nesc_atomic_end(__nesc_atomic); }
            }
          else 
#line 989
            {
              SmartSensingM$ADC$getData((uint8_t )client);
            }
        }
    }
  return;
}

# 59 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t SmartSensingM$WatchTimer$start(char arg_0x40818878, uint32_t arg_0x40818a10){
#line 59
  unsigned char result;
#line 59

#line 59
  result = TimerM$Timer$start(3U, arg_0x40818878, arg_0x40818a10);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 643 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline  result_t SmartSensingM$SensingTimer$fired(void)
#line 643
{
  SmartSensingM$global++;

  if (TRUE != SmartSensingM$initedClock) {
      SmartSensingM$initedClock = TRUE;
      SmartSensingM$SensingTimer$start(TIMER_REPEAT, SmartSensingM$timerInterval);
      SmartSensingM$WatchTimer$start(TIMER_REPEAT, 1024);
    }
  else {

      if (SmartSensingM$global % 200 == 0) {
          ;
        }

      SmartSensingM$realTimeFired = TRUE;
      SmartSensingM$trySample();
    }
  return SUCCESS;
}

# 653 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static inline   result_t RealTimeM$Timer$default$fired(uint8_t id)
#line 653
{
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t RealTimeM$Timer$fired(uint8_t arg_0x40b740d0){
#line 73
  unsigned char result;
#line 73

#line 73
  switch (arg_0x40b740d0) {
#line 73
    case 0U:
#line 73
      result = SmartSensingM$SensingTimer$fired();
#line 73
      break;
#line 73
    default:
#line 73
      result = RealTimeM$Timer$default$fired(arg_0x40b740d0);
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
# 444 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static inline  uint8_t NeighborMgmtM$writeNbrLinkInfo(uint8_t *start, uint8_t maxlen)
#line 444
{
  uint8_t i = 0;
  uint8_t *wpos = start;
  uint8_t count = 0;

#line 448
  for (i = 0; i < 16; i++) {
      if (NeighborMgmtM$NeighborTbl[i].flags & NBRFLAG_VALID && NeighborMgmtM$NeighborTbl[i].lastHeard == TRUE) {
          *wpos = (uint8_t )NeighborMgmtM$NeighborTbl[i].id;
          wpos++;
          *wpos = NeighborMgmtM$NeighborTbl[i].lqiRaw;
          wpos++;
          *wpos = NeighborMgmtM$NeighborTbl[i].rssiRaw;
          wpos++;
          count += 1;
          NeighborMgmtM$NeighborTbl[i].lastHeard = 0;
          if (count * 3 >= maxlen) {
            break;
            }
        }
    }
#line 462
  return count * 3;
}

# 90 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
inline static  uint8_t SmartSensingM$writeNbrLinkInfo(uint8_t *arg_0x40adacb0, uint8_t arg_0x40adae38){
#line 90
  unsigned char result;
#line 90

#line 90
  result = NeighborMgmtM$writeNbrLinkInfo(arg_0x40adacb0, arg_0x40adae38);
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 364 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static inline  uint16_t MultiHopLQI$RouteControl$getQuality(void)
#line 364
{
  return MultiHopLQI$gbLinkQuality;
}

# 84 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
inline static  uint16_t MultiHopEngineM$RouteSelectCntl$getQuality(void){
#line 84
  unsigned short result;
#line 84

#line 84
  result = MultiHopLQI$RouteControl$getQuality();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 586 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static inline  uint16_t MultiHopEngineM$RouteControl$getQuality(void)
#line 586
{
  return MultiHopEngineM$RouteSelectCntl$getQuality();
}

# 84 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/RouteControl.nc"
inline static  uint16_t SmartSensingM$RouteControl$getQuality(void){
#line 84
  unsigned short result;
#line 84

#line 84
  result = MultiHopEngineM$RouteControl$getQuality();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 131 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t SmartSensingM$Leds$yellowToggle(void){
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
# 37 "/home/xu/oasis/lib/SNMS/EventReport.nc"
inline static  uint8_t SmartSensingM$EventReport$eventSend(uint8_t arg_0x409b7ab0, uint8_t arg_0x409b7c48, uint8_t *arg_0x409b7e00){
#line 37
  unsigned char result;
#line 37

#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_SENSING, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37
  result = EventReportM$EventReport$eventSend(EVENT_TYPE_DATAMANAGE, arg_0x409b7ab0, arg_0x409b7c48, arg_0x409b7e00);
#line 37

#line 37
  return result;
#line 37
}
#line 37
# 652 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  result_t PMICM$PMIC$getBatteryVoltage(uint8_t *val)
#line 652
{

  return PMICM$getPMICADCVal(0, val);
}

# 54 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
inline static  result_t ADCM$PMIC$getBatteryVoltage(uint8_t *arg_0x404bdee0){
#line 54
  unsigned char result;
#line 54

#line 54
  result = PMICM$PMIC$getBatteryVoltage(arg_0x404bdee0);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 190 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline uint16_t ADCM$readADC(uint8_t actrualPort)
#line 190
{

  static uint16_t data = 0;
  uint8_t addr;
  uint8_t tmp;
  uint16_t t = 0;
  uint16_t i = 0;





  if (actrualPort != TOSH_ACTUAL_RVOL_PORT) {
      addr = (actrualPort << 4) | 0x86;

      {
#line 205
        while (* (volatile uint32_t *)0x41000008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41000010;
      }
#line 205
      ;

      {
#line 207
        * (volatile uint32_t *)(0x40E00024 + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (24 & 0x1f);
#line 207
        TOSH_uwait(1);
      }
#line 207
      ;
      * (volatile uint32_t *)0x41000010 = addr;
      while (* (volatile uint32_t *)0x41000008 & (1 << 4)) ;
      * (volatile uint32_t *)0x41000010 = 0xffff;
      {
#line 211
        TOSH_uwait(1);
#line 211
        * (volatile uint32_t *)(0x40E00018 + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (24 & 0x1f);
      }
#line 211
      ;






      {
#line 218
        * (volatile uint32_t *)(0x40E00024 + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (24 & 0x1f);
#line 218
        TOSH_uwait(1);
      }
#line 218
      ;
      data = * (volatile uint32_t *)0x41000010;
      {
#line 220
        TOSH_uwait(1);
#line 220
        * (volatile uint32_t *)(0x40E00018 + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) = 1 << (24 & 0x1f);
      }
#line 220
      ;

      {
#line 222
        while (* (volatile uint32_t *)0x41000008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41000010;
      }
#line 222
      ;
    }
  else {
      ADCM$PMIC$getBatteryVoltage(&tmp);
      data = tmp;
    }





  return data;
}

#line 143
static inline uint8_t ADCM$dequeue(void)
#line 143
{
  if (ADCM$queue_size == 0) {
      return 40;
    }
  else {
      if (ADCM$queue_head == 40 - 1) {
          ADCM$queue_head = -1;
        }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 151
        {
          ADCM$queue_head++;
          ADCM$queue_size--;
        }
#line 154
        __nesc_atomic_end(__nesc_atomic); }
      return ADCM$queue[(uint8_t )ADCM$queue_head];
    }
}

# 731 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static inline result_t SmartSensingM$oversample(uint16_t *data, uint8_t client)
#line 731
{
   static uint8_t count[MAX_SENSOR_NUM];
   static uint32_t value[MAX_SENSOR_NUM];

#line 734
  if (sensor[client].type == TYPE_DATA_SEISMIC || sensor[client].type == TYPE_DATA_INFRASONIC) {
      ++count[client];
      value[client] += *data;
      if (count[client] >= 4) {
          value[client] = value[client] >> 2;
          *data = value[client];
          count[client] = 0;
          value[client] = 0;
          return SUCCESS;
        }
      else {
          SmartSensingM$ADC$getData((uint8_t )client);
          return FAIL;
        }
    }
  else {
      return SUCCESS;
    }
}

#line 674
static inline   result_t SmartSensingM$ADC$dataReady(uint8_t client, uint16_t data)
#line 674
{

  if (SmartSensingM$oversample(&data, client) != SUCCESS) {
      return SUCCESS;
    }

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 680
    SmartSensingM$saveData(client, data);
#line 680
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 70 "/opt/tinyos-1.x/tos/interfaces/ADC.nc"
inline static   result_t ADCM$ADC$dataReady(uint8_t arg_0x411da910, uint16_t arg_0x40aa6cc0){
#line 70
  unsigned char result;
#line 70

#line 70
  result = SmartSensingM$ADC$dataReady(arg_0x411da910, arg_0x40aa6cc0);
#line 70

#line 70
  return result;
#line 70
}
#line 70
# 132 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static inline void ADCM$enqueue(uint8_t value)
#line 132
{
  if (ADCM$queue_tail == 40 - 1) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 134
        ADCM$queue_tail = -1;
#line 134
        __nesc_atomic_end(__nesc_atomic); }
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 136
    {
      ADCM$queue_tail++;
      ADCM$queue_size++;
      ADCM$queue[(uint8_t )ADCM$queue_tail] = value;
    }
#line 140
    __nesc_atomic_end(__nesc_atomic); }
}

# 472 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static inline result_t DataMgmtM$insertAndStartSend(TOS_MsgPtr msg)
#line 472
{
  result_t result = FALSE;

#line 474
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 474
    {
      result = insertElement(&DataMgmtM$sendQueue, msg);
      DataMgmtM$tryNextSend();
    }
#line 477
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}

# 68 "/opt/tinyos-1.x/tos/interfaces/Timer.nc"
inline static  result_t FlashManagerM$WritingTimer$stop(void){
#line 68
  unsigned char result;
#line 68

#line 68
  result = TimerM$Timer$stop(13U);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 6 "/home/xu/oasis/interfaces/GPSGlobalTime.nc"
inline static   uint32_t TimeSyncM$GPSGlobalTime$getGlobalTime(void){
#line 6
  unsigned int result;
#line 6

#line 6
  result = GPSSensorM$GPSGlobalTime$getGlobalTime();
#line 6

#line 6
  return result;
#line 6
}
#line 6
# 48 "/opt/tinyos-1.x/tos/interfaces/SendMsg.nc"
inline static  result_t TimeSyncM$SendMsg$send(uint16_t arg_0x40d93e70, uint8_t arg_0x40d90010, TOS_MsgPtr arg_0x40d901a0){
#line 48
  unsigned char result;
#line 48

#line 48
  result = GenericCommProM$SendMsg$send(AM_TIMESYNCMSG, arg_0x40d93e70, arg_0x40d90010, arg_0x40d901a0);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 399 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static inline  result_t FlashM$Flash$read(uint32_t addr, uint8_t *data, uint32_t numBytes)
{
  uint32_t curPtr = 0;
  uint32_t address = addr;
  uint32_t tmpdata = 0;

  while (curPtr < numBytes) 
    {
      if (address % 2) 
        {
          address = address - 1;
          tmpdata = * (uint32_t *)address;
          tmpdata = (tmpdata >> 8) & 0xFFFF;
          nmemcpy(data + curPtr, &tmpdata, 1);
          curPtr = curPtr + 1;
        }
      else 
        {
          tmpdata = * (uint32_t *)address;
          nmemcpy(data + curPtr, &tmpdata, numBytes - curPtr >= 2 ? 2 : 1);
          curPtr = curPtr + 2;
        }
      address += 2;
    }

  return SUCCESS;
}

# 52 "/home/xu/oasis/lib/SmartSensing/Flash.nc"
inline static  result_t FlashManagerM$Flash$read(uint32_t arg_0x40ad0120, uint8_t *arg_0x40ad02c8, uint32_t arg_0x40ad0460){
#line 52
  unsigned char result;
#line 52

#line 52
  result = FlashM$Flash$read(arg_0x40ad0120, arg_0x40ad02c8, arg_0x40ad0460);
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 125 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline bool PMICM$isChargerEnabled(void)
#line 125
{
  uint8_t chargerState;

  PMICM$readPMIC(0x28, &chargerState, 1);

  return chargerState > 0 ? TRUE : FALSE;
}

# 1024 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline void PXA27XUSBClientM$sendDeviceDescriptor(uint16_t wLength)
#line 1024
{
  PXA27XUSBClientM$USBdata InStream;
  uint8_t InTaskTemp;
  PXA27XUSBClientM$DynQueue QueueTemp;




  if (wLength == 0) {
    return;
    }
#line 1034
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1034
    {
      InStream = (PXA27XUSBClientM$USBdata )safe_malloc(sizeof(PXA27XUSBClientM$USBdata_t ));

      InStream->endpointDR = (volatile unsigned long *const )0x40600300;
      InStream->fifosize = 16;
      InStream->src = (uint8_t *)safe_malloc(0x12);

      InStream->len = wLength < 0x12 ? wLength : 0x12;
      InStream->index = 0;
      InStream->param = 0;

      * (uint32_t *)InStream->src = (0x12 | (0x01 << 8)) | (PXA27XUSBClientM$Device.bcdUSB << 16);
      * (uint32_t *)(InStream->src + 4) = ((PXA27XUSBClientM$Device.bDeviceClass | (PXA27XUSBClientM$Device.bDeviceSubclass << 8)) | (PXA27XUSBClientM$Device.bDeviceProtocol << 16)) | (PXA27XUSBClientM$Device.bMaxPacketSize0 << 24);

      * (uint32_t *)(InStream->src + 8) = PXA27XUSBClientM$Device.idVendor | (PXA27XUSBClientM$Device.idProduct << 16);
      * (uint32_t *)(InStream->src + 12) = (PXA27XUSBClientM$Device.bcdDevice | (PXA27XUSBClientM$Device.iManufacturer << 16)) | (PXA27XUSBClientM$Device.iProduct << 24);
      *(InStream->src + 16) = PXA27XUSBClientM$Device.iSerialNumber;
      *(InStream->src + 17) = PXA27XUSBClientM$Device.bNumConfigurations;

      InTaskTemp = PXA27XUSBClientM$InTask;
      QueueTemp = PXA27XUSBClientM$InQueue;
      PXA27XUSBClientM$DynQueue_enqueue(QueueTemp, InStream);
      if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) == 1 && InTaskTemp == 0) {
          PXA27XUSBClientM$InTask = 1;
          PXA27XUSBClientM$sendControlIn();
        }
    }
#line 1060
    __nesc_atomic_end(__nesc_atomic); }
}

static inline void PXA27XUSBClientM$sendConfigDescriptor(uint8_t id, uint16_t wLength)
#line 1063
{
  PXA27XUSBClientM$USBconfiguration Config;
  PXA27XUSBClientM$USBinterface Inter;
  PXA27XUSBClientM$USBendpoint EndpointIn;
#line 1066
  PXA27XUSBClientM$USBendpoint EndpointOut;
  PXA27XUSBClientM$USBdata InStream;
  uint8_t InTaskTemp;
  PXA27XUSBClientM$DynQueue QueueTemp;





  if (wLength == 0) {
    return;
    }
#line 1077
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1077
    {
      Config = PXA27XUSBClientM$Device.oConfigurations[1];
      Inter = Config->oInterfaces[0];
      EndpointIn = Inter->oEndpoints[0];
      EndpointOut = Inter->oEndpoints[1];

      InStream = (PXA27XUSBClientM$USBdata )safe_malloc(sizeof(PXA27XUSBClientM$USBdata_t ));

      InStream->endpointDR = (volatile unsigned long *const )0x40600300;
      InStream->fifosize = 16;
      InStream->src = (uint8_t *)safe_malloc(Config->wTotalLength);

      InStream->len = wLength < Config->wTotalLength ? wLength : Config->wTotalLength;
      InStream->index = 0;
      InStream->param = 0;

      * (uint32_t *)InStream->src = (0x09 | (0x02 << 8)) | (Config->wTotalLength << 16);
      * (uint32_t *)(InStream->src + 4) = ((Config->bNumInterfaces | (Config->bConfigurationID << 8)) | (Config->iConfiguration << 16)) | (Config->bmAttributes << 24);

      * (uint32_t *)(InStream->src + 8) = ((Config->MaxPower | (0x09 << 8)) | (0x04 << 16)) | (Inter->bInterfaceID << 24);

      * (uint32_t *)(InStream->src + 12) = ((Inter->bAlternateSetting | (Inter->bNumEndpoints << 8)) | (Inter->bInterfaceClass << 16)) | (Inter->bInterfaceSubclass << 24);

      * (uint32_t *)(InStream->src + 16) = ((Inter->bInterfaceProtocol | (Inter->iInterface << 8)) | (0x09 << 16)) | (0x21 << 24);
      * (uint32_t *)(InStream->src + 20) = (PXA27XUSBClientM$Hid.bcdHID | (PXA27XUSBClientM$Hid.bCountryCode << 16)) | (PXA27XUSBClientM$Hid.bNumDescriptors << 24);
      * (uint32_t *)(InStream->src + 24) = (0x22 | (PXA27XUSBClientM$Hid.wDescriptorLength << 8)) | (0x07 << 24);
      * (uint32_t *)(InStream->src + 28) = ((0x05 | (EndpointIn->bEndpointAddress << 8)) | (EndpointIn->bmAttributes << 16)) | (EndpointIn->wMaxPacketSize << 24);
      * (uint32_t *)(InStream->src + 32) = ((((EndpointIn->wMaxPacketSize >> 8) & 0xFF) | (EndpointIn->bInterval << 8)) | (0x07 << 16)) | (0x05 << 24);
      * (uint32_t *)(InStream->src + 36) = (EndpointOut->bEndpointAddress | (EndpointOut->bmAttributes << 8)) | (EndpointOut->wMaxPacketSize << 16);
      * (uint8_t *)(InStream->src + 40) = EndpointOut->bInterval;


      InTaskTemp = PXA27XUSBClientM$InTask;
      QueueTemp = PXA27XUSBClientM$InQueue;
      PXA27XUSBClientM$DynQueue_enqueue(QueueTemp, InStream);
      if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) == 1 && InTaskTemp == 0) {
          PXA27XUSBClientM$InTask = 1;
          PXA27XUSBClientM$sendControlIn();
        }
    }
#line 1116
    __nesc_atomic_end(__nesc_atomic); }
}

static inline void PXA27XUSBClientM$sendStringDescriptor(uint8_t id, uint16_t wLength)
#line 1119
{
  PXA27XUSBClientM$USBstring str;
  uint8_t count = 0;
#line 1121
  uint8_t InTaskTemp;
  uint8_t *src = (void *)0;
  PXA27XUSBClientM$USBdata InStream = (void *)0;
  PXA27XUSBClientM$DynQueue QueueTemp;

  str = PXA27XUSBClientM$Strings[id];




  if (wLength == 0) {
    return;
    }
#line 1133
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1133
    {
      InStream = (PXA27XUSBClientM$USBdata )safe_malloc(sizeof(PXA27XUSBClientM$USBdata_t ));
      InStream->endpointDR = (volatile unsigned long *const )0x40600300;
      InStream->fifosize = 16;
      InStream->src = (uint8_t *)safe_malloc(str->bLength);
      InStream->param = 0;







      InStream->len = wLength < str->bLength ? wLength : str->bLength;
      InStream->index = 0;

      if (id == 0) {
        * (uint32_t *)InStream->src = (str->bLength | (0x03 << 8)) | (str->uMisc.wLANGID << 16);
        }
      else 
#line 1151
        {
          src = str->uMisc.bString;




          * (uint32_t *)InStream->src = (str->bLength | (0x03 << 8)) | (*src << 16);
          src++;
          for (count = 1; *src != '\0'; count++, src++) {
              if (*(src + 1) == '\0') {
                  *(InStream->src + count * 4) = (uint8_t )*src;
                  *(InStream->src + count * 4 + 1) = (uint8_t )0;
                }
              else {
                  * (uint32_t *)(InStream->src + count * 4) = *src | (*(src + 1) << 16);
                  src++;
                }
            }
        }

      InTaskTemp = PXA27XUSBClientM$InTask;
      QueueTemp = PXA27XUSBClientM$InQueue;
      PXA27XUSBClientM$DynQueue_enqueue(QueueTemp, InStream);
      if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) == 1 && InTaskTemp == 0) {
          PXA27XUSBClientM$InTask = 1;
          PXA27XUSBClientM$sendControlIn();
        }
    }
#line 1178
    __nesc_atomic_end(__nesc_atomic); }
}

static inline void PXA27XUSBClientM$sendHidReportDescriptor(uint16_t wLength)
#line 1181
{
  PXA27XUSBClientM$USBdata InStream;
  uint8_t InTaskTemp;
  PXA27XUSBClientM$DynQueue QueueTemp;






  if (wLength == 0) {
    return;
    }
#line 1193
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1193
    {
      InStream = (PXA27XUSBClientM$USBdata )safe_malloc(sizeof(PXA27XUSBClientM$USBdata_t ));

      InStream->endpointDR = (volatile unsigned long *const )0x40600300;
      InStream->fifosize = 16;
      InStream->src = (uint8_t *)safe_malloc(PXA27XUSBClientM$HidReport.wLength);

      InStream->len = wLength < PXA27XUSBClientM$HidReport.wLength ? wLength : PXA27XUSBClientM$HidReport.wLength;
      InStream->index = 0;
      InStream->param = 0;

      nmemcpy(InStream->src, PXA27XUSBClientM$HidReport.bString, PXA27XUSBClientM$HidReport.wLength);

      InTaskTemp = PXA27XUSBClientM$InTask;
      QueueTemp = PXA27XUSBClientM$InQueue;
      PXA27XUSBClientM$DynQueue_enqueue(QueueTemp, InStream);
      if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) == 1 && InTaskTemp == 0) {
          PXA27XUSBClientM$InTask = 1;
          PXA27XUSBClientM$sendControlIn();
        }
      PXA27XUSBClientM$state = 3;
    }
#line 1214
    __nesc_atomic_end(__nesc_atomic); }
}

# 114 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
inline static void BluSHM$DynQueue_shiftshrink(BluSHM$DynQueue oDynQueue)



{

  if (oDynQueue == (void *)0) {
    return;
    }
  if (oDynQueue->index > 0) {
      memmove((void *)oDynQueue->ppvQueue, (void *)(oDynQueue->ppvQueue + oDynQueue->index), sizeof(void *) * oDynQueue->iLength);
      oDynQueue->index = 0;
    }
  oDynQueue->iPhysLength /= 2;
  oDynQueue->ppvQueue = (const void **)safe_realloc(oDynQueue->ppvQueue, 
  sizeof(void *) * oDynQueue->iPhysLength);
}

# 428 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   TOS_MsgPtr PXA27XUSBClientM$ReceiveMsg$default$receive(TOS_MsgPtr m)
#line 428
{
  return (void *)0;
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr PXA27XUSBClientM$ReceiveMsg$receive(TOS_MsgPtr arg_0x40620878){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = PXA27XUSBClientM$ReceiveMsg$default$receive(arg_0x40620878);
#line 75

#line 75
  return result;
#line 75
}
#line 75
# 424 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   result_t PXA27XUSBClientM$ReceiveBData$default$receive(uint8_t *buffer, uint8_t numBytesRead, uint32_t i, uint32_t n, uint8_t type)
#line 424
{
  return SUCCESS;
}

# 10 "/opt/tinyos-1.x/tos/platform/pxa27x/ReceiveBData.nc"
inline static  result_t PXA27XUSBClientM$ReceiveBData$receive(uint8_t *arg_0x40621118, uint8_t arg_0x406212a8, uint32_t arg_0x40621448, uint32_t arg_0x406215d8, uint8_t arg_0x40621760){
#line 10
  unsigned char result;
#line 10

#line 10
  result = PXA27XUSBClientM$ReceiveBData$default$receive(arg_0x40621118, arg_0x406212a8, arg_0x40621448, arg_0x406215d8, arg_0x40621760);
#line 10

#line 10
  return result;
#line 10
}
#line 10
# 456 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$USBReceive$receive(uint8_t *buff, uint32_t numBytesRead)
#line 456
{
  BluSHM$queueInput(buff, numBytesRead);
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
inline static  result_t PXA27XUSBClientM$ReceiveData$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0){
#line 73
  unsigned char result;
#line 73

#line 73
  result = BluSHM$USBReceive$receive(arg_0x404d6b18, arg_0x404d6cb0);
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 7 "/opt/tinyos-1.x/tos/platform/imote2/cmdlinetools.c"
static inline void BluSHM$killWhiteSpace(char *str)
{
  uint16_t i;
#line 9
  uint16_t j;
  uint16_t startIdx;


  for (i = 0; str[i] != '\0'; i++) 
    {
      if (str[i] != ' ') 
        {
          break;
        }
    }


  if (str[i] == '\0') 
    {

      str[0] = '\0';
      return;
    }


  startIdx = 0;
  while (1) 
    {




      j = startIdx;
      while (str[i] != '\0') 
        {
          str[j] = str[i];
          i++;
          j++;
        }

      str[j] = '\0';


      for (; str[startIdx] != ' ' && str[startIdx] != '\0'; startIdx++) 
        {
        }


      for (j = startIdx; str[j] != '\0'; j++) 
        {
          if (str[j] != ' ') 
            {
              break;
            }
        }


      if (str[j] == '\0') 
        {


          str[startIdx] = '\0';
          return;
        }


      str[startIdx] = ' ';
      startIdx++;


      i = j;
    }
}


static inline uint16_t BluSHM$firstSpace(char *str, uint16_t start)
{
  uint16_t i;

#line 83
  for (i = start; str[i] != '\0'; i++) 
    {
      if (str[i] == ' ') 
        {
          return i;
        }
    }
  return start;
}

# 127 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  BluSH_result_t SettingsM$NodeID$getName(char *buff, uint8_t len)
#line 127
{
  const char name[7] = "NodeID";

#line 129
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 222
static inline  BluSH_result_t SettingsM$ResetNode$getName(char *buff, uint8_t len)
#line 222
{
  const char name[10] = "ResetNode";

#line 224
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 139
static inline  BluSH_result_t SettingsM$TestTaskQueue$getName(char *buff, uint8_t len)
#line 139
{
  const char name[14] = "TestTaskQueue";

#line 141
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 202
static inline  BluSH_result_t SettingsM$GoToSleep$getName(char *buff, uint8_t len)
#line 202
{
  const char name[10] = "GoToSleep";

#line 204
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 235
static inline  BluSH_result_t SettingsM$GetResetCause$getName(char *buff, uint8_t len)
#line 235
{
  const char name[14] = "GetResetCause";

#line 237
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

# 751 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  BluSH_result_t PMICM$BatteryVoltage$getName(char *buff, uint8_t len)
#line 751
{

  const char name[15] = "BatteryVoltage";

#line 754
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 786
static inline  BluSH_result_t PMICM$ManualCharging$getName(char *buff, uint8_t len)
#line 786
{

  const char name[15] = "ManualCharging";

#line 789
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 770
static inline  BluSH_result_t PMICM$ChargingStatus$getName(char *buff, uint8_t len)
#line 770
{

  const char name[15] = "ChargingStatus";

#line 773
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 799
static inline  BluSH_result_t PMICM$ReadPMIC$getName(char *buff, uint8_t len)
#line 799
{

  const char name[9] = "ReadPMIC";

#line 802
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 821
static inline  BluSH_result_t PMICM$WritePMIC$getName(char *buff, uint8_t len)
#line 821
{

  const char name[10] = "WritePMIC";

#line 824
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 843
static inline  BluSH_result_t PMICM$SetCoreVoltage$getName(char *buff, uint8_t len)
#line 843
{

  const char name[15] = "SetCoreVoltage";

#line 846
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

# 176 "/opt/tinyos-1.x/tos/platform/imote2/DVFSM.nc"
static inline  BluSH_result_t DVFSM$SwitchFreq$getName(char *buff, uint8_t len)
#line 176
{
  const char name[11] = "SwitchFreq";

#line 178
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

#line 206
static inline  BluSH_result_t DVFSM$GetFreq$getName(char *buff, uint8_t len)
#line 206
{
  const char name[8] = "GetFreq";

#line 208
  strcpy(buff, name);
  return BLUSH_SUCCESS_DONE;
}

static inline  BluSH_result_t DVFSM$GetFreq$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 213
{
  sprintf(resBuff, "Current Core/Bus Frequency = [%d/%d]\r\n", getSystemFrequency(), getSystemBusFrequency());
  return BLUSH_SUCCESS_DONE;
}

#line 182
static inline  BluSH_result_t DVFSM$SwitchFreq$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 183
{
  uint32_t target_freq;
  uint32_t t_bus_freq;

  if (strlen(cmdBuff) < 12) {
      sprintf(resBuff, "SwitchFreq <Target Freq in MHz>\r\n");
    }
  else 
#line 189
    {
      sscanf(cmdBuff, "SwitchFreq %d", &target_freq);
      if (target_freq != 416) {
          t_bus_freq = target_freq;
        }
      else 
#line 193
        {
          t_bus_freq = target_freq / 2;
        }
      if (DVFSM$DVFS$SwitchCoreFreq(target_freq, t_bus_freq) == SUCCESS) {
          sprintf(resBuff, "Switched to %3d [%3d] MHz successfully\r\n", target_freq, t_bus_freq);
        }
      else 
#line 198
        {
          sprintf(resBuff, "Failed to switch to %3d MHz\r\n", target_freq);
        }
    }

  return BLUSH_SUCCESS_DONE;
}

# 851 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  BluSH_result_t PMICM$SetCoreVoltage$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 852
{
  uint32_t voltage;
  uint32_t trim;

#line 855
  if (strlen(cmdBuff) < strlen("SetCoreVoltage 222")) {
      sprintf(resBuff, "Please enter the voltage in mV, range 850 - 1625 in 25mV steps\r\n");
    }
  else {
      sscanf(cmdBuff, "SetCoreVoltage %d", &voltage);
      if (voltage < 850 || voltage > 1625) {
          trace(DBG_USR1, "Invalid voltage %d mV", voltage);
          return BLUSH_SUCCESS_DONE;
        }

      trim = (uint8_t )((voltage - 850) / 25);
      PMICM$PMIC$setCoreVoltage(trim);
      trace(DBG_USR1, "Wrote voltage %d, trim %d\r\n", trim * 25 + 850, trim);
    }
  return BLUSH_SUCCESS_DONE;
}

#line 829
static inline  BluSH_result_t PMICM$WritePMIC$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 830
{
  uint32_t address;
#line 831
  uint32_t data;

#line 832
  if (strlen(cmdBuff) < strlen("WritePMIC 22 22")) {
      sprintf(resBuff, "Please enter an address and a value to write\r\n");
    }
  else {
      sscanf(cmdBuff, "WritePMIC %x %x", &address, &data);
      PMICM$writePMIC(address, data);
      trace(DBG_USR1, "Wrote %#x to PMIC address %#x\r\n", data, address);
    }
  return BLUSH_SUCCESS_DONE;
}

#line 807
static inline  BluSH_result_t PMICM$ReadPMIC$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 808
{
  uint32_t address;
  uint8_t data;

#line 811
  if (strlen(cmdBuff) < strlen("ReadPMIC 22")) {
      sprintf(resBuff, "Please enter an address to read\r\n");
    }
  else {
      sscanf(cmdBuff, "ReadPMIC %x", &address);
      PMICM$readPMIC(address, &data, 1);
      trace(DBG_USR1, "read %#x from PMIC address %#x\r\n", data, address);
    }
  return BLUSH_SUCCESS_DONE;
}

#line 777
static inline  BluSH_result_t PMICM$ChargingStatus$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 778
{
  uint8_t vBat;
#line 779
  uint8_t vChg;
#line 779
  uint8_t iChg;
#line 779
  uint8_t chargeControl;

#line 780
  PMICM$PMIC$chargingStatus(&vBat, &vChg, &iChg, &chargeControl);
  trace(DBG_USR1, "vBat = %.3fV %vChg = %.3fV iChg = %.3fA chargeControl =%#x\r\n", vBat * .01035 + 2.65, vChg * 6 * .01035, iChg * .01035 / 1.656, chargeControl);

  return BLUSH_SUCCESS_DONE;
}








static inline  BluSH_result_t PMICM$ManualCharging$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 794
{
  PMICM$smartChargeEnable();
  return BLUSH_SUCCESS_DONE;
}

#line 758
static inline  BluSH_result_t PMICM$BatteryVoltage$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 759
{
  uint8_t val;

#line 761
  if (PMICM$PMIC$getBatteryVoltage(&val)) {
      trace(DBG_USR1, "Battery Voltage is %.3fV\r\n", val * .01035 + 2.65);
    }
  else {
      trace(DBG_USR1, "Error:  getBatteryVoltage failed\r\n");
    }
  return BLUSH_SUCCESS_DONE;
}

# 241 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  BluSH_result_t SettingsM$GetResetCause$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 242
{
  uint8_t gpio_rst;
#line 243
  uint8_t sleep_rst;
#line 243
  uint8_t wdt_rst;
#line 243
  uint8_t hw_rst;

#line 244
  gpio_rst = (SettingsM$ResetCause & (1 << 3)) == 1 << 3;
  sleep_rst = (SettingsM$ResetCause & (1 << 2)) == 1 << 2;
  wdt_rst = (SettingsM$ResetCause & (1 << 1)) == 1 << 1;
  hw_rst = (SettingsM$ResetCause & 1) == 1;
  trace(DBG_USR1, "GPIO %d, Sleep %d, WDT %d, Power On %d\r\n", 
  gpio_rst, sleep_rst, wdt_rst, hw_rst);
  return BLUSH_SUCCESS_DONE;
}

# 52 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XPowerModesM.nc"
static inline void PXA27XPowerModesM$DisablePeripherals(void)
#line 52
{






  * (volatile uint32_t *)0x40700004 &= ~(1 << 6);
  * (volatile uint32_t *)0x40200004 &= ~(1 << 6);
  * (volatile uint32_t *)0x40100004 &= ~(1 << 6);


  * (volatile uint32_t *)0x41000000 &= ~(1 << 7);
  * (volatile uint32_t *)0x41700000 &= ~(1 << 7);
  * (volatile uint32_t *)0x41900000 &= ~(1 << 7);


  * (volatile uint32_t *)0x40600000 &= ~(1 << 0);


  * (volatile uint32_t *)0x40301690 &= ~(1 << 6);
  * (volatile uint32_t *)0x40F00190 &= ~(1 << 6);


  * (volatile uint32_t *)0x40A000C0 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000C4 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000C8 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000CC &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000D0 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000D4 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000D8 &= ~(7 & 0x7);
  * (volatile uint32_t *)0x40A000DC &= ~(7 & 0x7);
}





static inline void PXA27XPowerModesM$EnterDeepSleep(void)
#line 90
{

  PXA27XPowerModesM$DisablePeripherals();






  * (volatile uint32_t *)0x40F0000C = (1 << 31) | (1 << 1);
  * (volatile uint32_t *)0x40F00010 |= 1 << 1;
  * (volatile uint32_t *)0x40F00014 |= 1 << 1;










  * (volatile uint32_t *)0x40F00034 &= ~((((1 << 11) | (1 << 10)) | (1 << 9)) | (1 << 8));
  * (volatile uint32_t *)0x40F00034 &= ~((3 & 0x3) << 2);






  * (volatile uint32_t *)0x41300008 |= 1 << 1;


  * (volatile uint32_t *)0x40F0001C = * (volatile uint32_t *)0x40F0001C & ~(1 << 11);


  * (volatile uint32_t *)0x40F0001C = * (volatile uint32_t *)0x40F0001C | 1;
  while ((* (volatile uint32_t *)0x41300008 & 1) == 0) ;


  * (volatile uint32_t *)0x40F0001C = * (volatile uint32_t *)0x40F0001C | (1 << 7);


   __asm volatile (
  "mcr p14, 0, %0, c7, c0, 0" :  : 

  "r"(7));

  while (1) ;
}

static inline  void PXA27XPowerModesM$PXA27XPowerModes$SwitchMode(uint8_t targetMode)
#line 141
{
  switch (targetMode) {
      case 1: 

        PXA27XPowerModesM$EnterDeepSleep();
      break;
      default: 
        break;
    }
}

# 51 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XPowerModes.nc"
inline static  void SleepM$PXA27XPowerModes$SwitchMode(uint8_t arg_0x40997ab8){
#line 51
  PXA27XPowerModesM$PXA27XPowerModes$SwitchMode(arg_0x40997ab8);
#line 51
}
#line 51
# 609 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  result_t PMICM$PMIC$shutDownLDOs(void)
#line 609
{
  uint8_t oldVal;
#line 610
  uint8_t newVal;








  PMICM$readPMIC(0x17, &oldVal, 1);
  newVal = (oldVal & ~0x8) & ~0x10;
  newVal = (newVal & ~0x2) & ~0x4;
  PMICM$writePMIC(0x17, newVal);

  PMICM$readPMIC(0x97, &oldVal, 1);
  newVal = ((((oldVal & ~0x2) & ~0x10) & ~0x20) & 
  ~0x40) & ~0x80;
  PMICM$writePMIC(0x97, newVal);

  PMICM$readPMIC(0x98, &oldVal, 1);
  newVal = (((((oldVal & ~0x1) & ~0x2) & ~0x4) & 
  ~0x8) & ~0x20) & ~0x40;
  PMICM$writePMIC(0x98, newVal);

  return SUCCESS;
}

# 52 "/opt/tinyos-1.x/tos/platform/imote2/PMIC.nc"
inline static  result_t SleepM$PMIC$shutDownLDOs(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = PMICM$PMIC$shutDownLDOs();
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 54 "/opt/tinyos-1.x/tos/platform/pxa27x/SleepM.nc"
static inline  result_t SleepM$Sleep$goToDeepSleep(uint32_t sleepTime)
#line 54
{


  * (volatile uint32_t *)0x40900008 |= 1 << 2;
  * (volatile uint32_t *)0x40900004 = * (volatile uint32_t *)0x40900000 + sleepTime;


  * (volatile uint32_t *)0x40900008 &= ~(1 << 15);
  * (volatile uint32_t *)0x40900008 &= ~(1 << 12);


  SleepM$PMIC$shutDownLDOs();
  SleepM$PXA27XPowerModes$SwitchMode(1);
  return SUCCESS;
}

# 56 "/opt/tinyos-1.x/tos/platform/pxa27x/Sleep.nc"
inline static  result_t SettingsM$Sleep$goToDeepSleep(uint32_t arg_0x4090f8e0){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SleepM$Sleep$goToDeepSleep(arg_0x4090f8e0);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 208 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  BluSH_result_t SettingsM$GoToSleep$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 209
{
  uint32_t sleep_time;

  if (strlen(cmdBuff) < 11) {
      sprintf(resBuff, "GoToSleep <Sleep time in seconds>\r\n");
    }
  else 
#line 214
    {
      sscanf(cmdBuff, "GoToSleep %d", &sleep_time);
      SettingsM$Sleep$goToDeepSleep(sleep_time);
    }

  return BLUSH_SUCCESS_DONE;
}

#line 119
static inline  void SettingsM$testQueue(void)
#line 119
{
  trace(DBG_USR1, "Task Executed\r\n");
}

#line 145
static inline  BluSH_result_t SettingsM$TestTaskQueue$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 146
{
  TOS_post(SettingsM$testQueue);
  return BLUSH_SUCCESS_DONE;
}

# 71 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XWatchdogM.nc"
static inline  void PXA27XWatchdogM$Reset$reset(void)
#line 71
{

  PXA27XWatchdogM$resetMoteRequest = TRUE;
  resetNode();
}

# 46 "/opt/tinyos-1.x/tos/interfaces/Reset.nc"
inline static  void SettingsM$Reset$reset(void){
#line 46
  PXA27XWatchdogM$Reset$reset();
#line 46
}
#line 46
# 123 "/opt/tinyos-1.x/tos/platform/imote2/SettingsM.nc"
static inline  void SettingsM$doReset(void)
#line 123
{
  SettingsM$Reset$reset();
}

#line 228
static inline  BluSH_result_t SettingsM$ResetNode$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 229
{
  trace(DBG_USR1, "Resetting\r\n");
  TOS_post(SettingsM$doReset);
  return BLUSH_SUCCESS_DONE;
}

#line 133
static inline  BluSH_result_t SettingsM$NodeID$callApp(char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 134
{
  trace(DBG_USR1, "0x%x\r\n", TOS_LOCAL_ADDRESS);
  return BLUSH_SUCCESS_DONE;
}

# 280 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline   BluSH_result_t BluSHM$BluSH_AppI$default$callApp(uint8_t id, char *cmdBuff, uint8_t cmdLen, 
char *resBuff, uint8_t resLen)
#line 281
{
  resBuff[0] = '\0';
  return BLUSH_SUCCESS_DONE;
}

# 9 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
inline static  BluSH_result_t BluSHM$BluSH_AppI$callApp(uint8_t arg_0x40784798, char *arg_0x404b5888, uint8_t arg_0x404b5a10, char *arg_0x404b5bc0, uint8_t arg_0x404b5d48){
#line 9
  unsigned char result;
#line 9

#line 9
  switch (arg_0x40784798) {
#line 9
    case 0U:
#line 9
      result = DVFSM$SwitchFreq$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 1U:
#line 9
      result = DVFSM$GetFreq$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 2U:
#line 9
      result = PMICM$BatteryVoltage$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 3U:
#line 9
      result = PMICM$ManualCharging$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 4U:
#line 9
      result = PMICM$ChargingStatus$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 5U:
#line 9
      result = PMICM$ReadPMIC$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 6U:
#line 9
      result = PMICM$WritePMIC$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 7U:
#line 9
      result = PMICM$SetCoreVoltage$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 8U:
#line 9
      result = SettingsM$NodeID$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 9U:
#line 9
      result = SettingsM$ResetNode$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 10U:
#line 9
      result = SettingsM$TestTaskQueue$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 11U:
#line 9
      result = SettingsM$GoToSleep$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    case 12U:
#line 9
      result = SettingsM$GetResetCause$callApp(arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    default:
#line 9
      result = BluSHM$BluSH_AppI$default$callApp(arg_0x40784798, arg_0x404b5888, arg_0x404b5a10, arg_0x404b5bc0, arg_0x404b5d48);
#line 9
      break;
#line 9
    }
#line 9

#line 9
  return result;
#line 9
}
#line 9
# 500 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline void BluSHM$clearBluSHdata(BluSHdata data)
#line 500
{
  safe_free(data->src);
  safe_free(data);
}

# 65 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static inline int BluSHM$DynQueue_getLength(BluSHM$DynQueue oDynQueue)



{

  if (oDynQueue == (void *)0) {
    return 0;
    }
#line 73
  return oDynQueue->iLength;
}

# 493 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline void BluSHM$clearIn(void)
#line 493
{
  BluSHM$DynQueue QueueTemp;

#line 495
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 495
    QueueTemp = BluSHM$InQueue;
#line 495
    __nesc_atomic_end(__nesc_atomic); }
  while (BluSHM$DynQueue_getLength(QueueTemp) > 0) 
    BluSHM$clearBluSHdata((BluSHdata )BluSHM$DynQueue_dequeue(QueueTemp));
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$FIFOP_GPIOInt$disable(void){
#line 46
  PXA27XGPIOIntM$PXA27XGPIOInt$disable(0);
#line 46
}
#line 46
# 841 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$InterruptFIFOP$disable(void)
#line 841
{

  HPLCC2420M$FIFOP_GPIOInt$disable();
  return SUCCESS;
}

# 59 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t CC2420RadioM$FIFOP$disable(void){
#line 59
  unsigned char result;
#line 59

#line 59
  result = HPLCC2420M$InterruptFIFOP$disable();
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

# 183 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline char TOSH_READ_CC_FIFO_PIN(void)
#line 183
{
#line 183
  return (* (volatile uint32_t *)(0x40E00000 + (114 < 96 ? ((114 & 0x7f) >> 5) * 4 : 0x100)) & (1 << (114 & 0x1f))) != 0;
}

# 105 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static inline   result_t TimerJiffyAsyncM$TimerJiffyAsync$stop(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 107
    {
      TimerJiffyAsyncM$bSet = FALSE;
      {
        * (volatile uint32_t *)0x40A0001C &= ~(1 << 6);
      }
    }
#line 112
    __nesc_atomic_end(__nesc_atomic); }
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
# 98 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static inline   bool TimerJiffyAsyncM$TimerJiffyAsync$isSet(void)
{
  bool val;

#line 101
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 101
    val = TimerJiffyAsyncM$bSet;
#line 101
    __nesc_atomic_end(__nesc_atomic); }
  return val;
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

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 611
    {
      if (TOS_post(CC2420RadioM$delayedRXFIFOtask)) {
          CC2420RadioM$FIFOP$disable();
        }
      else {
          CC2420RadioM$flushRXFIFO();
        }
    }
#line 618
    __nesc_atomic_end(__nesc_atomic); }


  return SUCCESS;
}

# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420M$InterruptFIFOP$fired(void){
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
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$FIFOP_GPIOInt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(0);
#line 47
}
#line 47
# 865 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$FIFOP_GPIOInt$fired(void)
#line 865
{
  result_t result;

#line 867
  HPLCC2420M$FIFOP_GPIOInt$clear();
  result = HPLCC2420M$InterruptFIFOP$fired();
  if (FAIL == result) {
      HPLCC2420M$InterruptFIFOP$disable();
    }

  return;
}

#line 506
static inline  void HPLCC2420M$HPLCC2420FifoReadRxFifoReleaseError(void)
#line 506
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.readRXFIFO failed while attempting to release the SSP port\r\n");
}

#line 503
static inline  void HPLCC2420M$HPLCC2420FIFOReadRxFifoContentionError(void)
#line 503
{
  trace(DBG_USR1, "ERROR:  HPLCC2420FIFO.readRXFIFO has attempted to access the radio during an existing radio operation\r\n");
}

#line 520
static inline   result_t HPLCC2420M$HPLCC2420FIFO$readRXFIFO(uint8_t length, uint8_t *data)
#line 520
{
  uint32_t temp32;
  uint8_t status;
#line 522
  uint8_t tmp;
#line 522
  uint8_t OkToUse;
  uint8_t pktlen;
  result_t ret;

  if (HPLCC2420M$getSSPPort() == FAIL) {

      TOS_post(HPLCC2420M$HPLCC2420FIFOReadRxFifoContentionError);
      return 0;
    }







  {
#line 538
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 538
  ;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 541
    {
      HPLCC2420M$rxbuf = data;
      OkToUse = HPLCC2420M$gbDMAChannelInitDone;
    }
#line 544
    __nesc_atomic_end(__nesc_atomic); }
#line 565
  {
#line 565
    TOSH_CLR_CC_CSN_PIN();
#line 565
    TOSH_uwait(1);
  }
#line 565
  ;


  * (volatile uint32_t *)0x41900010 = 0x3F | 0x40;
  * (volatile uint32_t *)0x41900010 = 0;
  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
  status = * (volatile uint32_t *)0x41900010;
  pktlen = * (volatile uint32_t *)0x41900010;
  data[0] = pktlen;
  data++;


  pktlen++;




  if (pktlen > 0 && OkToUse == 0) {

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 584
        {
          HPLCC2420M$rxlen = pktlen < length ? pktlen : length;
        }
#line 586
        __nesc_atomic_end(__nesc_atomic); }
#line 615
      {

        int i;

#line 618
        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 618
          {
            length = HPLCC2420M$rxlen;
          }
#line 620
          __nesc_atomic_end(__nesc_atomic); }
        while (length > 16) {

            for (i = 0; i < 16; i++) {
                * (volatile uint32_t *)0x41900010 = 0;
              }
            while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
            for (i = 0; i < 16; i++) {
                temp32 = * (volatile uint32_t *)0x41900010;
                * data++ = temp32;
              }
            length -= 16;
          }
        for (i = 0; i < length; i++) {
            * (volatile uint32_t *)0x41900010 = 0;
          }
        while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
        for (i = 0; i < length; i++) {
            temp32 = * (volatile uint32_t *)0x41900010;
            * data++ = temp32;
          }
        TOS_post(HPLCC2420M$signalRXFIFO);
        {
#line 642
          TOSH_uwait(1);
#line 642
          TOSH_SET_CC_CSN_PIN();
        }
#line 642
        ;
        ret = SUCCESS;
      }
    }
  else 






    {
      {
#line 654
        TOSH_uwait(1);
#line 654
        TOSH_SET_CC_CSN_PIN();
      }
#line 654
      ;
      ret = FAIL;
    }
  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420FifoReadRxFifoReleaseError);
      return 0;
    }

  return ret;
}

# 19 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420FIFO.nc"
inline static   result_t CC2420RadioM$HPLChipconFIFO$readRXFIFO(uint8_t arg_0x40f1d558, uint8_t *arg_0x40f1d700){
#line 19
  unsigned char result;
#line 19

#line 19
  result = HPLCC2420M$HPLCC2420FIFO$readRXFIFO(arg_0x40f1d558, arg_0x40f1d700);
#line 19

#line 19
  return result;
#line 19
}
#line 19
# 185 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline char TOSH_READ_CC_FIFOP_PIN(void)
#line 185
{
#line 185
  return (* (volatile uint32_t *)(0x40E00000 + (0 < 96 ? ((0 & 0x7f) >> 5) * 4 : 0x100)) & (1 << (0 & 0x1f))) != 0;
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
# 398 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static inline  TOS_MsgPtr GenericCommProM$RadioReceive$receive(TOS_MsgPtr msg)
#line 398
{
  GenericCommProM$radioRecvActive = TRUE;
  GenericCommProM$Leds$greenToggle();
  return GenericCommProM$received(msg);
}

# 75 "/opt/tinyos-1.x/tos/interfaces/ReceiveMsg.nc"
inline static  TOS_MsgPtr CC2420RadioM$Receive$receive(TOS_MsgPtr arg_0x40620878){
#line 75
  struct TOS_Msg *result;
#line 75

#line 75
  result = GenericCommProM$RadioReceive$receive(arg_0x40620878);
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
inline static   result_t HPLCC2420M$HPLCC2420FIFO$RXFIFODone(uint8_t arg_0x40f1c4e8, uint8_t *arg_0x40f1c690){
#line 39
  unsigned char result;
#line 39

#line 39
  result = CC2420RadioM$HPLChipconFIFO$RXFIFODone(arg_0x40f1c4e8, arg_0x40f1c690);
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$FIFO_GPIOInt$disable(void){
#line 46
  PXA27XGPIOIntM$PXA27XGPIOInt$disable(114);
#line 46
}
#line 46
# 847 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$InterruptFIFO$disable(void)
#line 847
{

  HPLCC2420M$FIFO_GPIOInt$disable();
  return SUCCESS;
}

#line 989
static inline    result_t HPLCC2420M$InterruptFIFO$default$fired(void)
#line 989
{
  return FAIL;
}

# 51 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Interrupt.nc"
inline static   result_t HPLCC2420M$InterruptFIFO$fired(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = HPLCC2420M$InterruptFIFO$default$fired();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$FIFO_GPIOInt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(114);
#line 47
}
#line 47
# 876 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$FIFO_GPIOInt$fired(void)
#line 876
{
  result_t result;

#line 878
  HPLCC2420M$FIFO_GPIOInt$clear();
  result = HPLCC2420M$InterruptFIFO$fired();
  if (FAIL == result) {
      HPLCC2420M$InterruptFIFO$disable();
    }

  return;
}

#line 853
static inline   result_t HPLCC2420M$InterruptCCA$disable(void)
#line 853
{

  HPLCC2420M$CCA_GPIOInt$disable();
  return SUCCESS;
}

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
inline static   result_t CC2420RadioM$FIFOP$startWait(bool arg_0x40959bc8){
#line 43
  unsigned char result;
#line 43

#line 43
  result = HPLCC2420M$InterruptFIFOP$startWait(arg_0x40959bc8);
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
inline static   result_t CC2420ControlM$HPLChipconRAM$write(uint16_t arg_0x40955710, uint8_t arg_0x40955898, uint8_t *arg_0x40955a40){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420RAM$write(arg_0x40955710, arg_0x40955898, arg_0x40955a40);
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
inline static   uint16_t CC2420ControlM$HPLChipcon$read(uint8_t arg_0x40956010){
#line 61
  unsigned short result;
#line 61

#line 61
  result = HPLCC2420M$HPLCC2420$read(arg_0x40956010);
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
inline static   result_t HPLCC2420M$InterruptCCA$fired(void){
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
# 887 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$CCA_GPIOInt$fired(void)
#line 887
{
  result_t result;

#line 889
  HPLCC2420M$CCA_GPIOInt$clear();
  result = HPLCC2420M$InterruptCCA$fired();
  if (FAIL == result) {
      HPLCC2420M$InterruptCCA$disable();
    }
  return;
}

#line 435
static inline  void HPLCC2420M$HPLCC2420RAMWriteContentionError(void)
#line 435
{
  trace(DBG_USR1, "ERROR:  HPLCC2420RAM.write has attempted to access the radio during an existing radio operation\r\n");
}

#line 438
static inline  void HPLCC2420M$HPLCC2420RamWriteReleaseError(void)
#line 438
{
  trace(DBG_USR1, "ERROR:  HPLCC2420RAM.write failed while attempting to release the SSP port\r\n");
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
inline static   result_t HPLCC2420M$HPLCC2420RAM$writeDone(uint16_t arg_0x40954010, uint8_t arg_0x40954198, uint8_t *arg_0x40954340){
#line 49
  unsigned char result;
#line 49

#line 49
  result = ClockTimeStampingM$HPLCC2420RAM$writeDone(arg_0x40954010, arg_0x40954198, arg_0x40954340);
#line 49
  result = rcombine(result, CC2420ControlM$HPLChipconRAM$writeDone(arg_0x40954010, arg_0x40954198, arg_0x40954340));
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 422 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline  void HPLCC2420M$signalRAMWr(void)
#line 422
{
  uint16_t ramaddr;
  uint8_t ramlen;
  uint8_t *rambuf;

#line 426
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 426
    {
      ramaddr = HPLCC2420M$txramaddr;
      ramlen = HPLCC2420M$txramlen;
      rambuf = HPLCC2420M$txrambuf;
    }
#line 430
    __nesc_atomic_end(__nesc_atomic); }

  HPLCC2420M$HPLCC2420RAM$writeDone(ramaddr, ramlen, rambuf);
}

# 46 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$SFD_GPIOInt$disable(void){
#line 46
  PXA27XGPIOIntM$PXA27XGPIOInt$disable(16);
#line 46
}
#line 46
# 859 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   result_t HPLCC2420M$CaptureSFD$disable(void)
#line 859
{

  HPLCC2420M$SFD_GPIOInt$disable();
  return SUCCESS;
}

# 27 "/home/xu/oasis/lib/FTSP/TimeSync/LocalTime.nc"
inline static   uint32_t ClockTimeStampingM$LocalTime$read(void){
#line 27
  unsigned int result;
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
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 126
    {
      ClockTimeStampingM$rcv_time = ClockTimeStampingM$LocalTime$read();
      ClockTimeStampingM$rcv_message = msgBuff;
    }
#line 129
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 33 "/opt/tinyos-1.x/tos/interfaces/RadioCoordinator.nc"
inline static   void CC2420RadioM$RadioReceiveCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658){
#line 33
  ClockTimeStampingM$RadioReceiveCoordinator$startSymbol(arg_0x40f28340, arg_0x40f284c8, arg_0x40f28658);
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

# 60 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420Capture.nc"
inline static   result_t CC2420RadioM$SFD$disable(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = HPLCC2420M$CaptureSFD$disable();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 47 "/opt/tinyos-1.x/tos/lib/CC2420Radio/HPLCC2420RAM.nc"
inline static   result_t ClockTimeStampingM$HPLCC2420RAM$write(uint16_t arg_0x40955710, uint8_t arg_0x40955898, uint8_t *arg_0x40955a40){
#line 47
  unsigned char result;
#line 47

#line 47
  result = HPLCC2420M$HPLCC2420RAM$write(arg_0x40955710, arg_0x40955898, arg_0x40955a40);
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

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    send_time = ClockTimeStampingM$LocalTime$read() - ClockTimeStampingM$SEND_TIME_CORRECTION;
#line 83
    __nesc_atomic_end(__nesc_atomic); }




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
inline static   void CC2420RadioM$RadioSendCoordinator$startSymbol(uint8_t arg_0x40f28340, uint8_t arg_0x40f284c8, TOS_MsgPtr arg_0x40f28658){
#line 33
  ClockTimeStampingM$RadioSendCoordinator$startSymbol(arg_0x40f28340, arg_0x40f284c8, arg_0x40f28658);
#line 33
}
#line 33
# 186 "/opt/tinyos-1.x/tos/platform/imote2/hardware.h"
static __inline char TOSH_READ_CC_SFD_PIN(void)
#line 186
{
#line 186
  return (* (volatile uint32_t *)(0x40E00000 + (16 < 96 ? ((16 & 0x7f) >> 5) * 4 : 0x100)) & (1 << (16 & 0x1f))) != 0;
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
inline static   result_t HPLCC2420M$CaptureSFD$captured(uint16_t arg_0x40f18368){
#line 53
  unsigned char result;
#line 53

#line 53
  result = CC2420RadioM$SFD$captured(arg_0x40f18368);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void HPLCC2420M$SFD_GPIOInt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(16);
#line 47
}
#line 47
# 897 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static inline   void HPLCC2420M$SFD_GPIOInt$fired(void)
#line 897
{
  result_t result;

#line 899
  HPLCC2420M$SFD_GPIOInt$clear();
  result = HPLCC2420M$CaptureSFD$captured(0);
  if (result == FAIL) {
      HPLCC2420M$CaptureSFD$disable();
    }

  return;
}

# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void GPSSensorM$GPSInterrupt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(93);
#line 47
}
#line 47
# 476 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline  void GPSSensorM$debugDevTask(void)
#line 476
{

  float newSkew = GPSSensorM$skew;
  uint32_t newLocalAverage;
  int32_t newOffsetAverage;
  int32_t localSum;
  int32_t offsetSum;
  int8_t i;

  for (i = 0; i < MAX_ENTRIES && GPSSensorM$table[i].state != ENTRY_FULL; ++i) 
    ;

  if (i >= MAX_ENTRIES) {
    return;
    }



  newLocalAverage = GPSSensorM$table[i].localTime;
  newOffsetAverage = GPSSensorM$table[i].timeOffset;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 497
    {
      localSum = 0;
      offsetSum = 0;
    }
#line 500
    __nesc_atomic_end(__nesc_atomic); }
  while (++i < MAX_ENTRIES) {
      if (GPSSensorM$table[i].state == ENTRY_FULL) {
          localSum += (int32_t )(GPSSensorM$table[i].localTime - newLocalAverage) / GPSSensorM$tableEntries;
          offsetSum += (int32_t )(GPSSensorM$table[i].timeOffset - newOffsetAverage) / GPSSensorM$tableEntries;
        }
    }
  newLocalAverage += localSum;
  newOffsetAverage += offsetSum;

  localSum = offsetSum = 0;

  for (i = 0; i < MAX_ENTRIES; ++i) {
      if (GPSSensorM$table[i].state == ENTRY_FULL) {
          int32_t a = GPSSensorM$table[i].localTime - newLocalAverage;
          int32_t b = GPSSensorM$table[i].timeOffset - newOffsetAverage;

          localSum += (int32_t )a * a;
          offsetSum += (int32_t )a * b;
        }
    }

  if (localSum != 0) {
    newSkew = (float )offsetSum / (float )localSum;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      GPSSensorM$skew = newSkew;
      GPSSensorM$offsetAverage = newOffsetAverage;
      GPSSensorM$localAverage = newLocalAverage;
      GPSSensorM$numEntries = GPSSensorM$tableEntries;
    }
#line 531
    __nesc_atomic_end(__nesc_atomic); }
}

#line 550
static inline void GPSSensorM$addNewEntry(void)
#line 550
{
  int8_t i;
#line 551
  int8_t freeItem = -1;
#line 551
  int8_t oldestItem = 0;
  uint32_t age;
#line 552
  uint32_t oldestTime = 0;
  int32_t timeError;

  GPSSensorM$tableEntries = 0;


  timeError = GPSSensorM$gLocalTime;
  GPSSensorM$GPSGlobalTime$local2Global(&timeError);

  timeError = GPSSensorM$timeCount - timeError % DAY_END;
  if (timeError > 1000UL || timeError < -1000UL) {

      return;
    }
  else {
#line 565
    if (GPSSensorM$timeCount - GPSSensorM$gLocalTime > DAY_END >> 2 || GPSSensorM$timeCount - GPSSensorM$gLocalTime < -(DAY_END >> 2)) {

        return;
      }
    }
  for (i = 0; i < MAX_ENTRIES; ++i) {
      ++GPSSensorM$tableEntries;
      age = GPSSensorM$gLocalTime - GPSSensorM$table[i].localTime;





      if (age >= 0x7FFFFFFFUL) {
        GPSSensorM$table[i].state = ENTRY_EMPTY;
        }
      if (GPSSensorM$table[i].state == ENTRY_EMPTY) {
          --GPSSensorM$tableEntries;
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
#line 595
    ++GPSSensorM$tableEntries;
    }
  GPSSensorM$table[freeItem].state = ENTRY_FULL;
  GPSSensorM$table[freeItem].localTime = GPSSensorM$gLocalTime;
  timeError = GPSSensorM$timeCount - GPSSensorM$gLocalTime;








  GPSSensorM$table[freeItem].timeOffset = timeError;
}

# 40 "/home/xu/oasis/interfaces/RealTime.nc"
inline static  result_t GPSSensorM$RealTime$setTimeCount(uint32_t arg_0x40abf6d8, uint8_t arg_0x40abf860){
#line 40
  unsigned char result;
#line 40

#line 40
  result = RealTimeM$RealTime$setTimeCount(arg_0x40abf6d8, arg_0x40abf860);
#line 40

#line 40
  return result;
#line 40
}
#line 40
# 680 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static inline   void GPSSensorM$GPSInterrupt$fired(void)
#line 680
{


  uint32_t timeTemp = 0;

  timeTemp = GPSSensorM$LocalTime$read();
  GPSSensorM$pps_arrive_point[GPSSensorM$ppsIndex] = timeTemp;
  timeTemp = GPSSensorM$GPSGlobalTime$local2Global(timeTemp);



  GPSSensorM$checkTimerOn = FALSE;




  if (TRUE == GPSSensorM$samplingReady) {


      GPSSensorM$hasGPS = TRUE;
      if (GPSSensorM$RealTime$getMode() == FTSP_SYNC) {
          GPSSensorM$RealTime$changeMode(GPS_SYNC);
          GPSSensorM$alreadySetTime = FALSE;
        }







      GPSSensorM$gLocalTime = GPSSensorM$pps_arrive_point[GPSSensorM$ppsIndex];


      if (GPSSensorM$alreadySetTime != TRUE) {

          GPSSensorM$RealTime$setTimeCount(GPSSensorM$timeCount, GPS_SYNC);
          GPSSensorM$alreadySetTime = TRUE;
          GPSSensorM$gLocalTime = GPSSensorM$LocalTime$read();
          GPSSensorM$clearTable();
        }
      GPSSensorM$samplingStart = FALSE;
      GPSSensorM$samplingReady = FALSE;
      GPSSensorM$addNewEntry();
      TOS_post(GPSSensorM$debugDevTask);
    }
  else 
#line 725
    {
    }
#line 738
  GPSSensorM$GPSInterrupt$clear();

  if (++GPSSensorM$ppsIndex == SYNC_INTERVAL) {
      if (GPSSensorM$hasGPS == FALSE) {
          GPSSensorM$alreadySetTime = FALSE;
        }
      GPSSensorM$ppsIndex = 0;
    }

  return;
}

# 46 "/opt/tinyos-1.x/tos/interfaces/Reset.nc"
inline static  void PMICM$Reset$reset(void){
#line 46
  PXA27XWatchdogM$Reset$reset();
#line 46
}
#line 46
# 474 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline  void PMICM$handlePMICIrq(void)
#line 474
{
  uint8_t events[3];

  PMICM$readPMIC(0x01, events, 3);

  if (events[0] & 0x1) {
      if (PMICM$gotReset == TRUE) {

          PMICM$Reset$reset();
        }
      else {
          PMICM$gotReset = TRUE;
        }
    }

  if (events[0] & 0x4) {

      trace(DBG_USR1, "USB Cable Insertion/Removal event\r\n");
      PMICM$smartChargeEnable();
    }

  if (events[0] & 0x80) {

      trace(DBG_USR1, "Charger Status:  Charger Over Current Error\r\n");
      PMICM$PMIC$enableCharging(FALSE);
    }

  if (events[1] & 0x1) {

      trace(DBG_USR1, "Charger Status:  Total Charging Timeout Expired\r\n");
      PMICM$PMIC$enableCharging(FALSE);
    }

  if (events[1] & 0x2) {

      trace(DBG_USR1, "Charger Status:  Total Constant Current Charging Timeout Expired\r\n");
      PMICM$PMIC$enableCharging(FALSE);
    }
}

# 106 "/opt/tinyos-1.x/tos/interfaces/Leds.nc"
inline static   result_t PMICM$Leds$greenToggle(void){
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
# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void PMICM$PMICInterrupt$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(1);
#line 47
}
#line 47
# 516 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static inline   void PMICM$PMICInterrupt$fired(void)
#line 516
{

  PMICM$PMICInterrupt$clear();
  PMICM$Leds$greenToggle();

  TOS_post(PMICM$handlePMICIrq);
}

# 47 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
inline static   void PXA27XUSBClientM$USBAttached$clear(void){
#line 47
  PXA27XGPIOIntM$PXA27XGPIOInt$clear(13);
#line 47
}
#line 47
# 221 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static inline   void PXA27XUSBClientM$USBAttached$fired(void)
{
  PXA27XUSBClientM$isAttached();
  PXA27XUSBClientM$USBAttached$clear();
}

# 450 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$UartReceive$receive(uint8_t *buff, uint32_t numBytesRead)
#line 450
{
  BluSHM$queueInput(buff, numBytesRead);
  return SUCCESS;
}

# 73 "/opt/tinyos-1.x/tos/platform/imote2/ReceiveData.nc"
inline static  result_t BufferedSTUARTM$ReceiveData$receive(uint8_t *arg_0x404d6b18, uint32_t arg_0x404d6cb0){
#line 73
  unsigned char result;
#line 73

#line 73
  result = BluSHM$UartReceive$receive(arg_0x404d6b18, arg_0x404d6cb0);
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 224 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static inline void BufferedSTUARTM$receiveDone(uint32_t arg)
#line 224
{
  bufferInfo_t *pBI = (bufferInfo_t *)arg;

#line 226
  if (pBI == (void *)0) {
      return;
    }







  invalidateDCache(pBI->pBuf, pBI->numBytes);
  BufferedSTUARTM$ReceiveData$receive(pBI->pBuf, pBI->numBytes);
  returnBuffer(&BufferedSTUARTM$receiveBufferSet, pBI->pBuf);
  returnBufferInfo(&BufferedSTUARTM$receiveBufferInfoSet, pBI);
}

#line 22
static inline void BufferedSTUARTM$_receiveDoneveneer(void)
#line 22
{
#line 22
  uint32_t argument;

#line 22
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 22
    {
#line 22
      popqueue(&paramtaskQueue, &argument);
    }
#line 23
    __nesc_atomic_end(__nesc_atomic); }
#line 22
  BufferedSTUARTM$receiveDone(argument);
}

# 77 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAChannel.nc"
inline static  result_t STUARTM$TxDMAChannel$requestChannel(DMAPeripheralID_t arg_0x405402f8, DMAPriority_t arg_0x405404a0, bool arg_0x40540630){
#line 77
  unsigned char result;
#line 77

#line 77
  result = PXA27XDMAM$PXA27XDMAChannel$requestChannel(1U, arg_0x405402f8, arg_0x405404a0, arg_0x40540630);
#line 77

#line 77
  return result;
#line 77
}
#line 77
#line 192
inline static  result_t STUARTM$TxDMAChannel$setTransferWidth(DMATransferWidth_t arg_0x4054d358){
#line 192
  unsigned char result;
#line 192

#line 192
  result = PXA27XDMAM$PXA27XDMAChannel$setTransferWidth(1U, arg_0x4054d358);
#line 192

#line 192
  return result;
#line 192
}
#line 192
#line 172
inline static  result_t STUARTM$TxDMAChannel$setMaxBurstSize(DMAMaxBurstSize_t arg_0x4054e720){
#line 172
  unsigned char result;
#line 172

#line 172
  result = PXA27XDMAM$PXA27XDMAChannel$setMaxBurstSize(1U, arg_0x4054e720);
#line 172

#line 172
  return result;
#line 172
}
#line 172
#line 161
inline static  result_t STUARTM$TxDMAChannel$enableTargetFlowControl(bool arg_0x4054e188){
#line 161
  unsigned char result;
#line 161

#line 161
  result = PXA27XDMAM$PXA27XDMAChannel$enableTargetFlowControl(1U, arg_0x4054e188);
#line 161

#line 161
  return result;
#line 161
}
#line 161
#line 152
inline static  result_t STUARTM$TxDMAChannel$enableSourceFlowControl(bool arg_0x4053fbd8){
#line 152
  unsigned char result;
#line 152

#line 152
  result = PXA27XDMAM$PXA27XDMAChannel$enableSourceFlowControl(1U, arg_0x4053fbd8);
#line 152

#line 152
  return result;
#line 152
}
#line 152
#line 143
inline static  result_t STUARTM$TxDMAChannel$enableTargetAddrIncrement(bool arg_0x4053f608){
#line 143
  unsigned char result;
#line 143

#line 143
  result = PXA27XDMAM$PXA27XDMAChannel$enableTargetAddrIncrement(1U, arg_0x4053f608);
#line 143

#line 143
  return result;
#line 143
}
#line 143
#line 133
inline static  result_t STUARTM$TxDMAChannel$enableSourceAddrIncrement(bool arg_0x4053f030){
#line 133
  unsigned char result;
#line 133

#line 133
  result = PXA27XDMAM$PXA27XDMAChannel$enableSourceAddrIncrement(1U, arg_0x4053f030);
#line 133

#line 133
  return result;
#line 133
}
#line 133
#line 123
inline static   result_t STUARTM$TxDMAChannel$setTargetAddr(uint32_t arg_0x4053aaa8){
#line 123
  unsigned char result;
#line 123

#line 123
  result = PXA27XDMAM$PXA27XDMAChannel$setTargetAddr(1U, arg_0x4053aaa8);
#line 123

#line 123
  return result;
#line 123
}
#line 123
# 322 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static inline void STUARTM$configureTxDMA(uint8_t *TxBuffer, uint16_t NumBytes)
#line 322
{
  STUARTM$TxDMAChannel$setSourceAddr((uint32_t )TxBuffer);
  STUARTM$TxDMAChannel$setTargetAddr(0x40700000);
  STUARTM$TxDMAChannel$enableSourceAddrIncrement(TRUE);
  STUARTM$TxDMAChannel$enableTargetAddrIncrement(FALSE);
  STUARTM$TxDMAChannel$enableSourceFlowControl(FALSE);
  STUARTM$TxDMAChannel$enableTargetFlowControl(TRUE);
  STUARTM$TxDMAChannel$setTransferLength(NumBytes);
  STUARTM$TxDMAChannel$setMaxBurstSize(DMA_8ByteBurst);
  STUARTM$TxDMAChannel$setTransferWidth(DMA_4ByteWidth);
}

#line 114
static inline result_t STUARTM$openTxPort(bool bTxDMAIntEnable)
#line 114
{

  result_t status = SUCCESS;

  /* atomic removed: atomic calls only */
#line 118
  {
    if (STUARTM$gTxPortInUse == TRUE) {
        status = FAIL;
      }
    else {
        STUARTM$gTxPortInUse = TRUE;
      }
  }
  if (status == FAIL) {
      return FAIL;
    }

  if (STUARTM$gPortInitialized == FALSE) {
      STUARTM$initPort();
      STUARTM$gPortInitialized = TRUE;
    }
  /* atomic removed: atomic calls only */
  {
    if (STUARTM$gRxPortInUse == FALSE) {

        STUARTM$configPort();
      }
  }

  return SUCCESS;
}

#line 335
static inline  result_t STUARTM$BulkTxRx$BulkTransmit(uint8_t *TxBuffer, uint16_t NumBytes)
#line 335
{

  if (!TxBuffer || !NumBytes) {
      return FAIL;
    }

  if (STUARTM$openTxPort(TRUE) == FAIL) {

      return FAIL;
    }
  /* atomic removed: atomic calls only */

  {
    STUARTM$gTxBuffer = TxBuffer;
    STUARTM$gTxNumBytes = NumBytes;
    STUARTM$gTxBufferPos = 0;
  }







  STUARTM$configureTxDMA(TxBuffer, NumBytes);


  STUARTM$TxDMAChannel$requestChannel(DMAID_STUART_TX, DMA_Priority4, FALSE);


  return SUCCESS;
}

# 35 "/opt/tinyos-1.x/tos/platform/imote2/BulkTxRx.nc"
inline static  result_t BufferedSTUARTM$BulkTxRx$BulkTransmit(uint8_t *arg_0x404f4600, uint16_t arg_0x404f4798){
#line 35
  unsigned char result;
#line 35

#line 35
  result = STUARTM$BulkTxRx$BulkTransmit(arg_0x404f4600, arg_0x404f4798);
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 462 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static inline  result_t BluSHM$UartSend$sendDone(uint8_t *packet, uint32_t numBytes, result_t success)
{

  return SUCCESS;
}

# 62 "/opt/tinyos-1.x/tos/platform/imote2/SendData.nc"
inline static  result_t BufferedSTUARTM$SendData$sendDone(uint8_t *arg_0x404e11a8, uint32_t arg_0x404e1340, result_t arg_0x404e14d0){
#line 62
  unsigned char result;
#line 62

#line 62
  result = BluSHM$UartSend$sendDone(arg_0x404e11a8, arg_0x404e1340, arg_0x404e14d0);
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 122 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static inline   result_t BufferedSTUARTM$SendDataAlloc$default$sendDone(uint8_t *data, uint32_t numBytes, result_t success)
#line 122
{

  return success;
}

# 47 "/opt/tinyos-1.x/tos/platform/imote2/SendDataAlloc.nc"
inline static  result_t BufferedSTUARTM$SendDataAlloc$sendDone(uint8_t *arg_0x404dd010, uint32_t arg_0x404dd1a8, result_t arg_0x404dd338){
#line 47
  unsigned char result;
#line 47

#line 47
  result = BufferedSTUARTM$SendDataAlloc$default$sendDone(arg_0x404dd010, arg_0x404dd1a8, arg_0x404dd338);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 192 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static inline void BufferedSTUARTM$transmitDone(uint32_t arg)
#line 192
{
  int status;
  bufferInfo_t *pBI = (bufferInfo_t *)arg;

  switch (pBI->origin) {
      case BufferedSTUARTM$originSendDataAlloc: 
        BufferedSTUARTM$SendDataAlloc$sendDone(pBI->pBuf, pBI->numBytes, SUCCESS);
      break;
      case BufferedSTUARTM$originSendData: 
        BufferedSTUARTM$SendData$sendDone(pBI->pBuf, pBI->numBytes, SUCCESS);

      safe_free(pBI->pBuf);

      break;
      default: 
        printFatalErrorMsg("BufferedUart.c found unknown interface origin = ", pBI->origin);
    }

  safe_free(pBI);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 211
    {
      pBI = peekptrqueue(&outgoingQueue, &status);
      if (status == 1) {

          BufferedSTUARTM$BulkTxRx$BulkTransmit(pBI->pBuf, pBI->numBytes);
        }
      else {
          BufferedSTUARTM$gTxActive = FALSE;
        }
    }
#line 220
    __nesc_atomic_end(__nesc_atomic); }
}

#line 19
static inline void BufferedSTUARTM$_transmitDoneveneer(void)
#line 19
{
#line 19
  uint32_t argument;

#line 19
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 19
    {
#line 19
      popqueue(&paramtaskQueue, &argument);
    }
#line 20
    __nesc_atomic_end(__nesc_atomic); }
#line 19
  BufferedSTUARTM$transmitDone(argument);
}

# 359 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static inline    void PXA27XInterruptM$PXA27XFiq$default$fired(uint8_t id)
{
  return;
}

# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterrupt.nc"
inline static   void PXA27XInterruptM$PXA27XFiq$fired(uint8_t arg_0x405de5d0){
#line 48
    PXA27XInterruptM$PXA27XFiq$default$fired(arg_0x405de5d0);
#line 48
}
#line 48
# 144 "/home/xu/oasis/lib/SmartSensing/ProcessTasks.h"
static inline void StaLtaFunc2(uint32_t rsamvalue, uint32_t curTime)
#line 144
{
  static uint32_t RSAMBuffer[MAX_RSAM_WIN_SIZE];
  static uint32_t STA = 0;
  static uint32_t LTA = 0;
  static uint8_t curInd = 0;
  static bool frozen_lta = FALSE;


  int8_t staTailInd = 0;
  int8_t ltaTailInd = 0;
  int32_t delta = 0;

  RSAMBuffer[curInd] = rsamvalue;
  staTailInd = curInd - sta_period;
  ltaTailInd = curInd - lta_period;

  if (staTailInd < 0) {
      staTailInd += MAX_RSAM_WIN_SIZE;
    }
  if (ltaTailInd < 0) {
      ltaTailInd += MAX_RSAM_WIN_SIZE;
    }
  if (frozen_lta != TRUE) {
      delta = (int32_t )(RSAMBuffer[curInd] - RSAMBuffer[ltaTailInd]) / lta_period;
      if (delta < 0) {
          if (LTA <= (uint32_t )-delta) {
              LTA = 0;
            }
          else {
              LTA += delta;
            }
        }
      else {
          LTA += delta;
        }
    }

  delta = (int32_t )(RSAMBuffer[curInd] - RSAMBuffer[staTailInd]) / sta_period;
  if (delta < 0) {
      if (STA <= (uint32_t )-delta) {
          STA = 0;
        }
      else {
          STA += delta;
        }
    }
  else {
      STA += delta;
    }

  if (STA >> 1UL > LTA) {
      if (TRUE != event_trigger) {
          if (curTime > 2000UL) {
              start_point = curTime - 2000UL;
            }
          end_point = curTime + ONE_MS;
          event_trigger = TRUE;
          event_onset = TRUE;
        }
      else {
          end_point += ONE_MS;
        }
    }
  else {
      if (FALSE != event_trigger) {
          end_point = curTime + 200UL;
          event_trigger = FALSE;
          frozen_lta = FALSE;
        }
    }
  if (++curInd == MAX_RSAM_WIN_SIZE) {
      curInd = 0;
    }
}

# 713 "/home/xu/oasis/lib/SmartSensing/Compress.h"
static inline int reconquantized_r(int quantizedvalue, int resolutionbits)
#line 713
{
  int reconvalue_r;

  if (quantizedvalue) {
    if (quantizedvalue < 0) {
      reconvalue_r = -(-quantizedvalue << (14 + 16 - resolutionbits));
      }
    else {
#line 720
      reconvalue_r = quantizedvalue << (14 + 16 - resolutionbits);
      }
    }
  else {
#line 722
    reconvalue_r = 0;
    }
  return reconvalue_r;
}

#line 368
static inline int quantize(int number_r, int resolutionbits)
#line 368
{
  int nearhalf = (1 << (14 + 16 - resolutionbits - 1)) - 1;
  int quantresult;

  if (number_r < 0) {
    quantresult = -((-number_r + nearhalf) >> (14 + 16 - resolutionbits));
    }
  else {
#line 375
    quantresult = (number_r + nearhalf) >> (14 + 16 - resolutionbits);
    }
  return quantresult;
}

#line 351
static inline int biasquantencode_r(int thebiasestimate_r)
#line 351
{
  int newbiasestimate_r;
  int biasquantized;


  biasquantized = quantize(thebiasestimate_r, biasquantbits);

  writesignmagnitude(biasquantized, biasquantbits);


  newbiasestimate_r = reconquantized_r(biasquantized, biasquantbits);

  return newbiasestimate_r;
}

#line 412
static inline void weightquantencode(void )
#line 412
{
  int i;
#line 413
  int thismagnitude;
  int weightqshift = 14 + capexponent - weightquantbits + 1;
  int halfq;
  int quantindex;
  int NormalFlag;
#line 417
  int lastsign;

  halfq = (1 << (weightqshift - 1)) - 1;

  for (i = 0; i < 3; i++) {

      if (weight_r[i] < 0) {
          thismagnitude = -weight_r[i];
          quantindex = -((thismagnitude + halfq) >> weightqshift);
          quantindex = (thismagnitude + halfq) >> weightqshift;

          if (quantindex >= 1 << (weightquantbits - 1)) {
            quantindex = (1 << (weightquantbits - 1)) - 1;
            }
#line 430
          quantindex = -quantindex;
        }
      else 
#line 431
        {
          thismagnitude = weight_r[i];
          quantindex = (thismagnitude + halfq) >> weightqshift;

          if (quantindex >= 1 << (weightquantbits - 1)) {
            quantindex = (1 << (weightquantbits - 1)) - 1;
            }
        }
      weightquant[i] = quantindex;




      if (quantindex > 0) {
          weight_r[i] = quantindex << weightqshift;
        }
      else {
#line 447
        if (quantindex < 0) {
            weight_r[i] = -(-quantindex << weightqshift);
          }
        else {
            weight_r[i] = 0;
          }
        }
    }
#line 471
  NormalFlag = TRUE;
  lastsign = 1;
  for (i = 0; i < 3; i++) {
      if (lastsign * weightquant[i] < 0) {
        NormalFlag = FALSE;
        }
#line 476
      lastsign = -lastsign;
    }
  lastsign = 1;
  for (i = 1; i < 3; i++) {
      if (lastsign * weightquant[i - 1] < -lastsign * weightquant[i]) {
        NormalFlag = FALSE;
        }
#line 482
      lastsign = -lastsign;
    }


  if (NormalFlag) {
      int magnitude;
#line 487
      int magnitudebits;

      writebit(0);
      weightquantcost = 1;

      lastsign = 1;
      magnitudebits = weightquantbits - 1;
      for (i = 0; i < 3; i++) {
          magnitude = lastsign * weightquant[i];
          writeunsignedint(magnitude, magnitudebits);
          weightquantcost += magnitudebits;
          lastsign = -lastsign;
          magnitudebits = 0;
          while (magnitude > 0) {
              magnitude >>= 1;
              magnitudebits++;
            }
          if (magnitudebits == 0) {
            magnitudebits = 1;
            }
        }
    }
  else 
#line 507
    {
      writebit(1);
      for (i = 0; i < 3; i++) 
        writesignmagnitude(weightquant[i], weightquantbits);
      weightquantcost = 1 + weightquantbits * 3;
    }
}

#line 574
static inline int32_t codechoice(int32_t foldedsum, int32_t numfoldedvals)
#line 574
{
  int32_t k;
#line 575
  int32_t foldvalue;

  if (foldedsum > numfoldedvals * meancutoff[16]) {

      return -1;
    }



  foldvalue = (foldedsum << 7) + numfoldedvals * 49;
  for (k = 0; numfoldedvals << (k + 8) <= foldvalue; k++) 
    ;


  if (k > 16 - 2) {
    k = 16 - 2;
    }
  return k;
}

#line 636
static inline void encodevalue(uint16_t thevalue, int32_t thecodeparameter)
#line 636
{
  int32_t i;

  if (thecodeparameter == -1) {

      for (i = 0; i < 16; i++) 
        writebit(thevalue & (1 << i));
    }
  else {

      for (i = 0; i < thevalue >> thecodeparameter; i++) {
          writebit(0);
        }
      writebit(1);


      for (i = 0; i < thecodeparameter; i++) {
          writebit(thevalue & (1 << i));
        }
    }
}


static inline void sendpacket(void )
#line 659
{

  while (packetbytepointer < 56) {
      writebit(0);
    }



  packetbitpointer = 0;
  packetbytepointer = 0;
}

# 119 "/opt/tinyos-1.x/tos/platform/imote2/sched.c"
 bool TOS_post(void (*tp)(void))
#line 119
{
  __nesc_atomic_t fInterruptFlags;
  uint8_t tmp;



  fInterruptFlags = __nesc_atomic_start();

  tmp = TOSH_sched_free;

  if (TOSH_queue[tmp].tp == NULL) {






      TOSH_sched_free = (tmp + 1) & TOSH_TASK_BITMASK;
      TOSH_queue[tmp].tp = tp;
      TOSH_queue[tmp].postingFunction = (void *)__builtin_return_address(0);
      TOSH_queue[tmp].timestamp = * (volatile uint32_t *)0x40A00010;
      __nesc_atomic_end(fInterruptFlags);

      return TRUE;
    }
  else {



      __nesc_atomic_end(fInterruptFlags);
      printFatalErrorMsg("TaskQueue Full.  Size = ", 1, TOSH_MAX_TASKS);
      return FALSE;
    }
}

# 54 "/opt/tinyos-1.x/tos/system/RealMain.nc"
  int main(void)
#line 54
{
  RealMain$hardwareInit();
  RealMain$Pot$init(10);
  TOSH_sched_init();

  RealMain$StdControl$init();
  RealMain$StdControl$start();
  __nesc_enable_interrupt();

  while (1) {
      TOSH_run_task();
    }
}

# 58 "/opt/tinyos-1.x/tos/platform/imote2/DVFSM.nc"
static  result_t DVFSM$DVFS$SwitchCoreFreq(uint32_t coreFreq, uint32_t sysBusFreq)
#line 58
{





  uint32_t clkcfg;
  uint32_t cccr;

  switch (coreFreq) {
      case 13: 
        if (sysBusFreq != 13) {
            return FAIL;
          }
      DVFSM$PMIC$setCoreVoltage(0x4);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 73
        {
          * (volatile uint32_t *)0x41300000 = (1 << 31) | (1 << 25);
           __asm volatile (
          "mcr p14,0,%0,c6,c0,0\n\t" :  : 

          "r"(0x2));


          while ((* (volatile uint32_t *)0x4130000C & (1 << 31)) == 0) ;
        }
#line 82
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;

      case 104: 
        if (sysBusFreq != 104) {
            return FAIL;
          }

      DVFSM$PMIC$setCoreVoltage(0x4);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 91
        {
          * (volatile uint32_t *)0x41300000 = ((8 & 0x1F) | ((2 & 0xF) << 7)) | (1 << 25);
           __asm volatile (
          "mcr p14,0,%0,c6,c0,0\n\t" :  : 

          "r"(0xb));



          while ((* (volatile uint32_t *)0x4130000C & (1 << 29)) == 0) ;
        }
#line 101
        __nesc_atomic_end(__nesc_atomic); }

      return SUCCESS;

      case 208: 
        switch (sysBusFreq) {
            case 104: 
              clkcfg = 1 | (1 << 1);
            cccr = 0;
            if (DVFSM$PMIC$setCoreVoltage(0x8) != SUCCESS) {

                return FAIL;
              }

            break;
            case 208: 
              clkcfg = (1 | (1 << 3)) | (1 << 1);
            cccr = 1 << 25;
            if (DVFSM$PMIC$setCoreVoltage(0xE) != SUCCESS) {

                return FAIL;
              }

            break;
            default: 
              return FAIL;
          }



      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 131
        {
          * (volatile uint32_t *)0x41300000 = ((16 & 0x1F) | ((2 & 0xF) << 7)) | cccr;
           __asm volatile (
          "mcr p14,0,%0,c6,c0,0\n\t" :  : 

          "r"(clkcfg));



          while ((* (volatile uint32_t *)0x4130000C & (1 << 29)) == 0) ;
        }
#line 141
        __nesc_atomic_end(__nesc_atomic); }

      return SUCCESS;

      case 416: 
        if (sysBusFreq != 208) {
            trace(DBG_TEMP, "Fail bus freq %d\r\n", sysBusFreq);
            return FAIL;
          }

      if (DVFSM$PMIC$setCoreVoltage(0x14) != SUCCESS) {
          return FAIL;
        }

      clkcfg = (1 | (1 << 3)) | (1 << 1);

      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 157
        {
          * (volatile uint32_t *)0x41300000 = ((16 & 0x1F) | ((4 & 0xF) << 7)) | (1 << 25);
           __asm volatile (
          "mcr p14,0,%0,c6,c0,0\n\t" :  : 

          "r"(clkcfg));



          while ((* (volatile uint32_t *)0x4130000C & (1 << 29)) == 0) ;
        }
#line 167
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;


      default: 
        return FAIL;
    }
}

# 538 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static  result_t PMICM$PMIC$setCoreVoltage(uint8_t trimValue)
#line 538
{

  PMICM$StdControl$init();

  return PMICM$writePMIC(0x15, (trimValue & 0x1f) | 0x80);
}

#line 146
static  result_t PMICM$StdControl$init(void)
#line 146
{
  static bool init = 0;

  if (init == 0) {
      * (volatile uint32_t *)0x41300004 |= 1 << 15;
      * (volatile uint32_t *)0x40F0001C |= 1 << 6;
      * (volatile uint32_t *)0x40F00190 = (1 << 6) | (1 << 5);

      PMICM$TOSH_MAKE_PMIC_TXON_OUTPUT();
      PMICM$TOSH_CLR_PMIC_TXON_PIN();

      PMICM$GPIOIRQControl$init();
      init = 1;
      PMICM$Leds$init();
      return PMICM$PI2CInterrupt$allocate();
    }
  else {
      return SUCCESS;
    }
}

# 59 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static  result_t PXA27XGPIOIntM$StdControl$init(void)
#line 59
{
  bool isInited;

#line 61
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 61
    {
      isInited = PXA27XGPIOIntM$gfInitialized;
      PXA27XGPIOIntM$gfInitialized = TRUE;
    }
#line 64
    __nesc_atomic_end(__nesc_atomic); }

  if (!isInited) {
      PXA27XGPIOIntM$GPIOIrq0$allocate();
      PXA27XGPIOIntM$GPIOIrq1$allocate();
      PXA27XGPIOIntM$GPIOIrq$allocate();
    }

  return SUCCESS;
}

# 226 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static result_t PXA27XInterruptM$allocate(uint8_t id, bool level, uint8_t priority)
{
  uint32_t tmp;
  result_t result = FAIL;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 231
    {
      uint8_t i;

#line 233
      if (PXA27XInterruptM$usedPriorities == 0) {
          uint8_t PriorityTable[40];
#line 234
          uint8_t DuplicateTable[40];

#line 235
          for (i = 0; i < 40; i++) {
              DuplicateTable[i] = PriorityTable[i] = 0xFF;
            }

          for (i = 0; i < 40; i++) 
            if (TOSH_IRP_TABLE[i] != 0xff) {
                if (PriorityTable[TOSH_IRP_TABLE[i]] != 0xFF) {


                  DuplicateTable[i] = PriorityTable[TOSH_IRP_TABLE[i]];
                  }
                else {
#line 246
                  PriorityTable[TOSH_IRP_TABLE[i]] = i;
                  }
              }

          for (i = 0; i < 40; i++) {
              if (PriorityTable[i] != 0xff) {
                  PriorityTable[PXA27XInterruptM$usedPriorities] = PriorityTable[i];
                  if (i != PXA27XInterruptM$usedPriorities) {
                    PriorityTable[i] = 0xFF;
                    }
#line 255
                  PXA27XInterruptM$usedPriorities++;
                }
            }

          for (i = 0; i < 40; i++) 
            if (DuplicateTable[i] != 0xFF) {
                uint8_t j;
#line 261
                uint8_t ExtraTable[40];

#line 262
                for (j = 0; DuplicateTable[i] != PriorityTable[j]; j++) ;
                nmemcpy(ExtraTable + j + 1, PriorityTable + j, PXA27XInterruptM$usedPriorities - j);
                nmemcpy(PriorityTable + j + 1, ExtraTable + j + 1, 
                PXA27XInterruptM$usedPriorities - j);
                PriorityTable[j] = i;
                PXA27XInterruptM$usedPriorities++;
              }

          for (i = 0; i < PXA27XInterruptM$usedPriorities; i++) {
              * (volatile uint32_t *)(0x40D0001C + (i < 32 ? i * 4 : i * 4 + 20)) = (1 << 31) | PriorityTable[i];
              tmp = * (volatile uint32_t *)(0x40D0001C + (i < 32 ? i * 4 : i * 4 + 20));
            }
        }

      if (id < 34) {
          if (priority == 0xff) {
              priority = PXA27XInterruptM$usedPriorities;
              PXA27XInterruptM$usedPriorities++;
              * (volatile uint32_t *)(0x40D0001C + (priority < 32 ? priority * 4 : priority * 4 + 20)) = (1 << 31) | id;
              tmp = * (volatile uint32_t *)(0x40D0001C + (priority < 32 ? priority * 4 : priority * 4 + 20));
            }
          if (level) {
              * (volatile uint32_t *)(0x40D00008 + (id < 32 ? 0 : 0x9c)) |= 1 << id % 32;
              tmp = * (volatile uint32_t *)(0x40D00008 + (id < 32 ? 0 : 0x9c));
            }

          result = SUCCESS;
        }
    }
#line 290
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}

# 149 "/opt/tinyos-1.x/tos/system/tos.h"
static void *nmemcpy(void *to, const void *from, size_t n)
{
  char *cto = to;
  const char *cfrom = from;

  while (n--) * cto++ = * cfrom++;

  return to;
}

# 315 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static result_t PMICM$writePMIC(uint8_t address, uint8_t value)
#line 315
{

  uint32_t loopCount;





  if (PMICM$getPI2CBus() == FALSE) {
      return FAIL;
    }

  * (volatile uint32_t *)0x40F00188 = 0x49 << 1;
  * (volatile uint32_t *)0x40F00190 |= 1 << 0;
  * (volatile uint32_t *)0x40F00190 |= 1 << 3;
  for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
  if (loopCount == 1000) {
      TOS_post(PMICM$printWritePMICSlaveAddressError);
      PMICM$returnPI2CBus();
      return FAIL;
    }

  * (volatile uint32_t *)0x40F00188 = address;
  * (volatile uint32_t *)0x40F00190 &= ~(1 << 0);
  * (volatile uint32_t *)0x40F00190 |= 1 << 3;
  for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
  if (loopCount == 1000) {
      TOS_post(PMICM$printWritePMICRegisterAddressError);
      PMICM$returnPI2CBus();
      return FAIL;
    }

  * (volatile uint32_t *)0x40F00188 = value;
  * (volatile uint32_t *)0x40F00190 |= 1 << 1;
  * (volatile uint32_t *)0x40F00190 |= 1 << 3;
  for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
  if (loopCount == 1000) {
      TOS_post(PMICM$printWritePMICWriteError);
      PMICM$returnPI2CBus();
      return FAIL;
    }
  * (volatile uint32_t *)0x40F00190 &= ~(1 << 1);

  PMICM$returnPI2CBus();
  return SUCCESS;
}

#line 107
static bool PMICM$getPI2CBus(void)
#line 107
{

  if (PMICM$accessingPMIC == FALSE) {
      PMICM$accessingPMIC = TRUE;
      return TRUE;
    }
  else {
      trace(DBG_USR1, "FATAL ERROR:  Contention Error encountered while acquiring PI2C Bus\r\n");
      return FALSE;
    }
}

# 73 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
  void trace(long long mode, const char *format, ...)
#line 73
{
  if (trace_active(mode)) {
      char buf[200 + 1];
      uint16_t buflen = 0;
      BluSHM$va_list args;

      __builtin_va_start(args, format);
      if (!(mode & (1ull << 21))) {
          buflen = vsnprintf(buf, 200, format, args);

          buflen = buflen >= 200 ? 200 : buflen;
          buf[200] = 0;
          generalSend(buf, buflen);
        }
    }
}

  unsigned char trace_active(long long mode)
#line 90
{
  unsigned char result;

#line 92
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 92
    result = (BluSHM$trace_modes & mode) != 0;
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return result;
}










static  void generalSend(uint8_t *buf, uint32_t buflen)
#line 105
{
  BluSHM$DynQueue QueueTemp;

  uint8_t *tempBuf;
  BluSHdata temp;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 112
    QueueTemp = BluSHM$OutQueue;
#line 112
    __nesc_atomic_end(__nesc_atomic); }







  temp = (BluSHdata )safe_malloc(sizeof(BluSHdata_t ));
  tempBuf = (uint8_t *)safe_malloc(buflen);
  nmemcpy(tempBuf, buf, buflen);
  temp->src = tempBuf;
  temp->len = buflen;
  if (BluSHM$USBSend$send(tempBuf, buflen, 3) == SUCCESS) {
      temp->state = 0;
      BluSHM$DynQueue_enqueue(QueueTemp, temp);
    }
  else {
      safe_free(tempBuf);
      safe_free(temp);
    }
}

# 135 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static int PXA27XUSBClientM$DynQueue_enqueue(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem)

{

  if (oDynQueue == (void *)0) {
    return 0;
    }
  if (oDynQueue->iLength + oDynQueue->index == oDynQueue->iPhysLength) {
    PXA27XUSBClientM$DynQueue_shiftgrow(oDynQueue);
    }
  oDynQueue->ppvQueue[oDynQueue->index + oDynQueue->iLength] = pvItem;
  oDynQueue->iLength++;

  return oDynQueue->iLength;
}

#line 90
static void PXA27XUSBClientM$DynQueue_shiftgrow(PXA27XUSBClientM$DynQueue oDynQueue)




{

  if (oDynQueue == (void *)0) {
    return;
    }
  if (oDynQueue->index > 2 && oDynQueue->index > oDynQueue->iPhysLength / 8) {
      memmove((void *)oDynQueue->ppvQueue, (void *)(oDynQueue->ppvQueue + oDynQueue->index), sizeof(void *) * oDynQueue->iLength);
      oDynQueue->index = 0;
    }
  else {
      oDynQueue->iPhysLength *= 2;
      oDynQueue->ppvQueue = (const void **)safe_realloc(oDynQueue->ppvQueue, 
      sizeof(void *) * oDynQueue->iPhysLength);
    }
}

# 833 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static  void PXA27XUSBClientM$sendIn(void)
#line 833
{
  uint16_t i = 0;
  uint8_t buf[64];
  uint8_t valid;
  PXA27XUSBClientM$DynQueue QueueTemp;
  PXA27XUSBClientM$USBdata InStateTemp;




  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 843
    QueueTemp = PXA27XUSBClientM$InQueue;
#line 843
    __nesc_atomic_end(__nesc_atomic); }
  if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) <= 0) {
    return;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 847
    {
      PXA27XUSBClientM$InState = (PXA27XUSBClientM$USBdata )PXA27XUSBClientM$DynQueue_peek(QueueTemp);
      PXA27XUSBClientM$InState->status |= 1 << (1 & 0x1f);
      InStateTemp = PXA27XUSBClientM$InState;
    }
#line 851
    __nesc_atomic_end(__nesc_atomic); }
  if ((uint32_t )InStateTemp->param != 1) {
      PXA27XUSBClientM$sendControlIn();
      return;
    }

  if (InStateTemp->pindex <= InStateTemp->n) {
    if (((InStateTemp->type >> 2) & 0x3) == 0) {
        buf[0] = InStateTemp->type;

        if (InStateTemp->pindex == 0) {
            buf[0] |= 1 << (4 & 0x1f);
            buf[1] = InStateTemp->n;
          }
        else {
          buf[1] = InStateTemp->pindex;
          }
        if (InStateTemp->pindex == InStateTemp->n) {
            valid = (uint8_t )(InStateTemp->len % 62);
            buf[1 + 1] = valid;
          }
        else {
          valid = (uint8_t )62;
          }
#line 874
        nmemcpy(buf + 1 + 1 + (InStateTemp->pindex == InStateTemp->n ? 1 : 0), 
        InStateTemp->src + InStateTemp->pindex * 62, valid);
      }
    else {
#line 877
      if (((InStateTemp->type >> 2) & 0x3) == 
      1) {
          buf[0] = InStateTemp->type;
          if (InStateTemp->pindex == 0) {
              buf[0] |= 1 << (4 & 0x1f);
              buf[1] = (uint8_t )(InStateTemp->n >> 8);
              buf[1 + 1] = (uint8_t )InStateTemp->n;
            }
          else {
              buf[1] = (uint8_t )(InStateTemp->pindex >> 8);
              buf[1 + 1] = (uint8_t )InStateTemp->pindex;
            }

          if (InStateTemp->pindex == InStateTemp->n) {
              valid = (uint8_t )(InStateTemp->len % 61);
              buf[1 + 2] = valid;
            }
          else {
            valid = (uint8_t )61;
            }
#line 896
          nmemcpy(buf + 1 + 2 + (InStateTemp->pindex == InStateTemp->n ? 1 : 0), 
          InStateTemp->src + InStateTemp->pindex * 61, valid);
        }
      else {
#line 899
        if (((InStateTemp->type >> 2) & 0x3) == 
        2) {
            buf[0] = InStateTemp->type;
            if (InStateTemp->pindex == 0) {
                buf[0] |= 1 << (4 & 0x1f);
                buf[1] = (uint8_t )(InStateTemp->n >> 24);
                buf[1 + 1] = (uint8_t )(InStateTemp->n >> 16);
                buf[1 + 2] = (uint8_t )(InStateTemp->n >> 8);
                buf[1 + 3] = (uint8_t )InStateTemp->n;
              }
            else {
                buf[1] = (uint8_t )(InStateTemp->pindex >> 24);
                buf[1 + 1] = (uint8_t )(InStateTemp->pindex >> 16);
                buf[1 + 2] = (uint8_t )(InStateTemp->pindex >> 8);
                buf[1 + 3] = (uint8_t )InStateTemp->pindex;
              }

            if (InStateTemp->pindex == InStateTemp->n) {
                valid = (uint8_t )(InStateTemp->len % 59);
                buf[1 + 4] = valid;
              }
            else {
              valid = (uint8_t )59;
              }
#line 922
            nmemcpy(buf + 1 + 4 + (InStateTemp->pindex == 
            InStateTemp->n ? 1 : 0), 
            InStateTemp->src + InStateTemp->pindex * 
            59, valid);
          }
        }
      }
    }
#line 927
  {
    InStateTemp->pindex++;
    if (InStateTemp->index < InStateTemp->tlen) {
      while (i < InStateTemp->fifosize) {
          * (volatile uint32_t *)InStateTemp->endpointDR = * (uint32_t *)(buf + i);
          InStateTemp->index += 4;
          i += 4;
        }
      }
    if (InStateTemp->index >= InStateTemp->tlen && InStateTemp->index % InStateTemp->fifosize != 0) {
        if (i < InStateTemp->fifosize) {
          * (volatile uint32_t *)(InStateTemp->endpointDR - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 1 << ((InStateTemp->endpointDR == (volatile unsigned long *const )0x40600300 ? 1 : 7) & 0x1f);
          }
#line 939
        InStateTemp->status &= ~(1 << (1 & 0x1f));
      }
    else {
#line 941
      if (InStateTemp->index >= InStateTemp->tlen && InStateTemp->index % InStateTemp->fifosize == 0) {
        InStateTemp->index++;
        }
      }
  }
}

# 78 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static void *PXA27XUSBClientM$DynQueue_peek(PXA27XUSBClientM$DynQueue oDynQueue)

{


  if (oDynQueue == (void *)0 || oDynQueue->iLength <= 0) {
    return (void *)0;
    }
#line 85
  return (void *)oDynQueue->ppvQueue[oDynQueue->index];
}

# 947 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static void PXA27XUSBClientM$sendControlIn(void)
#line 947
{
  uint16_t i = 0;
  PXA27XUSBClientM$DynQueue QueueTemp;
  PXA27XUSBClientM$USBdata InStateTemp;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 952
    QueueTemp = PXA27XUSBClientM$InQueue;
#line 952
    __nesc_atomic_end(__nesc_atomic); }
  if (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) <= 0) {
    return;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 956
    PXA27XUSBClientM$InState = (PXA27XUSBClientM$USBdata )PXA27XUSBClientM$DynQueue_peek(QueueTemp);
#line 956
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 957
    InStateTemp = PXA27XUSBClientM$InState;
#line 957
    __nesc_atomic_end(__nesc_atomic); }
  if ((uint32_t )InStateTemp->param != 0) {
    return;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 961
    PXA27XUSBClientM$InState->status |= 1 << (1 & 0x1f);
#line 961
    __nesc_atomic_end(__nesc_atomic); }

  {
    while (InStateTemp->index < InStateTemp->len && 
    i < InStateTemp->fifosize) {
        if (InStateTemp->len - InStateTemp->index > 3 && 
        InStateTemp->fifosize - i > 3) {
            * (volatile uint32_t *)InStateTemp->endpointDR = * (uint32_t *)(InStateTemp->src + 
            InStateTemp->index);
            InStateTemp->index += 4;
            i += 4;
          }
        else {
            * (volatile uint8_t *)InStateTemp->endpointDR = *(InStateTemp->src + InStateTemp->index);
            InStateTemp->index++;
            i++;
          }
      }
    if (InStateTemp->index >= InStateTemp->len && 
    InStateTemp->index % InStateTemp->fifosize != 0) {
        if (i < InStateTemp->fifosize) {
          * (volatile uint32_t *)(InStateTemp->endpointDR - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 
          1 << ((InStateTemp->endpointDR == (volatile unsigned long *const )0x40600300 ? 1 : 7) & 0x1f);
          }
        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 985
          PXA27XUSBClientM$InState->status &= ~(1 << (1 & 0x1f));
#line 985
          __nesc_atomic_end(__nesc_atomic); }
      }
    else {
#line 987
      if (InStateTemp->index == InStateTemp->len && 
      InStateTemp->index % InStateTemp->fifosize == 0) {
        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 989
          PXA27XUSBClientM$InState->index++;
#line 989
          __nesc_atomic_end(__nesc_atomic); }
        }
      }
  }
}

# 135 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static int BluSHM$DynQueue_enqueue(BluSHM$DynQueue oDynQueue, const void *pvItem)

{

  if (oDynQueue == (void *)0) {
    return 0;
    }
  if (oDynQueue->iLength + oDynQueue->index == oDynQueue->iPhysLength) {
    BluSHM$DynQueue_shiftgrow(oDynQueue);
    }
  oDynQueue->ppvQueue[oDynQueue->index + oDynQueue->iLength] = pvItem;
  oDynQueue->iLength++;

  return oDynQueue->iLength;
}

#line 25
static PXA27XUSBClientM$DynQueue PXA27XUSBClientM$DynQueue_new(void)



{
  PXA27XUSBClientM$DynQueue oDynQueue;

  oDynQueue = (PXA27XUSBClientM$DynQueue )safe_malloc(sizeof(struct PXA27XUSBClientM$DynQueue_T ));

  if (oDynQueue == (void *)0) {
    return (void *)0;
    }
  oDynQueue->iLength = 0;
  oDynQueue->iPhysLength = 2;
  oDynQueue->ppvQueue = 
  (const void **)safe_calloc(oDynQueue->iPhysLength, sizeof(void *));

  if (oDynQueue->ppvQueue == (void *)0) {
    return (void *)0;
    }
  oDynQueue->index = 0;
  return oDynQueue;
}

# 88 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$enable(uint8_t pin, uint8_t mode)
{
  if (pin < 121) {
      switch (mode) {
          case 1: 
            * (volatile uint32_t *)(0x40E00030 + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (pin & 0x1f);
          * (volatile uint32_t *)(0x40E0003C + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (pin & 0x1f));
          break;
          case 2: 
            * (volatile uint32_t *)(0x40E00030 + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (pin & 0x1f));
          * (volatile uint32_t *)(0x40E0003C + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (pin & 0x1f);
          break;
          case 3: 
            * (volatile uint32_t *)(0x40E00030 + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (pin & 0x1f);
          * (volatile uint32_t *)(0x40E0003C + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) |= 1 << (pin & 0x1f);
          break;
          default: 
            break;
        }
    }
  return;
}

# 993 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static void PXA27XUSBClientM$isAttached(void)
#line 993
{
  uint8_t statetemp;

  if (PXA27XUSBClientM$HPLUSBClientGPIO$checkConnection() == SUCCESS) {




    * (volatile uint32_t *)0x40600000 |= 1 << (((1 << 0) - 1) & 0x1f);
    }

  if ((* (volatile uint32_t *)0x40600000 & (1 << (3 & 0x1f))) != 0) {



    ;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1010
    statetemp = PXA27XUSBClientM$state;
#line 1010
    __nesc_atomic_end(__nesc_atomic); }
  if (statetemp == 0) {
    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1012
      PXA27XUSBClientM$state = 1;
#line 1012
      __nesc_atomic_end(__nesc_atomic); }
    }
  else 
#line 1013
    {



      * (volatile uint32_t *)0x40600000 &= ~(1 << ((1 << 0) & 0x1f));
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1018
        PXA27XUSBClientM$state = 0;
#line 1018
        __nesc_atomic_end(__nesc_atomic); }
      PXA27XUSBClientM$clearIn();
      PXA27XUSBClientM$clearOut();
    }
}

#line 1417
static void PXA27XUSBClientM$clearIn(void)
#line 1417
{
  PXA27XUSBClientM$DynQueue QueueTemp;

#line 1419
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1419
    QueueTemp = PXA27XUSBClientM$InQueue;
#line 1419
    __nesc_atomic_end(__nesc_atomic); }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1420
    {
      while (PXA27XUSBClientM$DynQueue_getLength(QueueTemp) > 0) {
          uint8_t temp;

#line 1423
          PXA27XUSBClientM$InState = (PXA27XUSBClientM$USBdata )PXA27XUSBClientM$DynQueue_dequeue(QueueTemp);
          temp = (uint32_t )PXA27XUSBClientM$InState->param == 1;
          PXA27XUSBClientM$clearUSBdata(PXA27XUSBClientM$InState, temp);
        }
      PXA27XUSBClientM$InState = (void *)0;
      PXA27XUSBClientM$InTask = 0;
    }
#line 1429
    __nesc_atomic_end(__nesc_atomic); }
}

# 153 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static void *PXA27XUSBClientM$DynQueue_dequeue(PXA27XUSBClientM$DynQueue oDynQueue)

{
  const void *pvItem;



  if (oDynQueue == (void *)0 || oDynQueue->iLength <= 0) {
    return (void *)0;
    }
  pvItem = oDynQueue->ppvQueue[oDynQueue->index];
  oDynQueue->ppvQueue[oDynQueue->index] = (void *)0;

  oDynQueue->iLength--;
  oDynQueue->index++;

  if (oDynQueue->iLength + 5 < oDynQueue->iPhysLength / 2) {
    PXA27XUSBClientM$DynQueue_shiftshrink(oDynQueue);
    }
#line 171
  return (void *)pvItem;
}

# 1432 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static void PXA27XUSBClientM$clearUSBdata(PXA27XUSBClientM$USBdata Stream, uint8_t isConst)
#line 1432
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1433
    {
      if (isConst == 0) {
        safe_free(Stream->src);
        }
#line 1436
      Stream->src = (void *)0;
      safe_free(Stream);
      Stream = (void *)0;
    }
#line 1439
    __nesc_atomic_end(__nesc_atomic); }
}

static void PXA27XUSBClientM$clearOut(void)
#line 1442
{
  uint8_t i;

#line 1444
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 1444
    {
      for (i = 0; i < 4; i++) {
          safe_free(PXA27XUSBClientM$OutStream[i].src);
          PXA27XUSBClientM$OutStream[i].endpointDR = (void *)0;
          PXA27XUSBClientM$OutStream[i].src = (void *)0;
          PXA27XUSBClientM$OutStream[i].status = 0;
          PXA27XUSBClientM$OutStream[i].type = 0;
          PXA27XUSBClientM$OutStream[i].index = 0;
          PXA27XUSBClientM$OutStream[i].n = 0;
          PXA27XUSBClientM$OutStream[i].len = 0;
        }
    }
#line 1455
    __nesc_atomic_end(__nesc_atomic); }
}

# 100 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
  void trace_set(long long mode)
#line 100
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 101
    BluSHM$trace_modes = mode;
#line 101
    __nesc_atomic_end(__nesc_atomic); }
}

# 25 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static BluSHM$DynQueue BluSHM$DynQueue_new(void)



{
  BluSHM$DynQueue oDynQueue;

  oDynQueue = (BluSHM$DynQueue )safe_malloc(sizeof(struct BluSHM$DynQueue_T ));

  if (oDynQueue == (void *)0) {
    return (void *)0;
    }
  oDynQueue->iLength = 0;
  oDynQueue->iPhysLength = 2;
  oDynQueue->ppvQueue = 
  (const void **)safe_calloc(oDynQueue->iPhysLength, sizeof(void *));

  if (oDynQueue->ppvQueue == (void *)0) {
    return (void *)0;
    }
  oDynQueue->index = 0;
  return oDynQueue;
}

# 90 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static  result_t ADCM$ADCControl$init(void)
#line 90
{
  uint8_t i = 0;

#line 92
  if (ADCM$initialized != TRUE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 93
        {
          {
#line 94
            * (volatile uint32_t *)(0x40E0000C + (23 < 96 ? ((23 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (23 < 96 ? ((23 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (23 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (23 < 96 ? ((23 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (23 & 0x1f));
#line 94
            * (volatile uint32_t *)(0x40E00054 + ((23 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((23 & 0x7f) >> 4) * 4) & ~(3 << (23 & 0xf) * 2)) | (2 << (23 & 0xf) * 2);
          }
#line 94
          ;
          {
#line 95
            * (volatile uint32_t *)(0x40E0000C + (25 < 96 ? ((25 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (25 < 96 ? ((25 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (25 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (25 < 96 ? ((25 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (25 & 0x1f));
#line 95
            * (volatile uint32_t *)(0x40E00054 + ((25 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((25 & 0x7f) >> 4) * 4) & ~(3 << (25 & 0xf) * 2)) | (2 << (25 & 0xf) * 2);
          }
#line 95
          ;
          {
#line 96
            * (volatile uint32_t *)(0x40E0000C + (26 < 96 ? ((26 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (26 < 96 ? ((26 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (26 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (26 < 96 ? ((26 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (26 & 0x1f));
#line 96
            * (volatile uint32_t *)(0x40E00054 + ((26 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((26 & 0x7f) >> 4) * 4) & ~(3 << (26 & 0xf) * 2)) | (1 << (26 & 0xf) * 2);
          }
#line 96
          ;
          {
#line 97
            * (volatile uint32_t *)(0x40E0000C + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (24 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (24 < 96 ? ((24 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (24 & 0x1f));
#line 97
            * (volatile uint32_t *)(0x40E00054 + ((24 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((24 & 0x7f) >> 4) * 4) & ~(3 << (24 & 0xf) * 2)) | (0 << (24 & 0xf) * 2);
          }
#line 97
          ;

          * (volatile uint32_t *)0x41300004 |= 1 << 23;
          * (volatile uint32_t *)0x41000004 = ((7 & 0xF) << 10) | ((7 & 0xF) << 6);
          * (volatile uint32_t *)0x41000028 = 96 * 8;


          * (volatile uint32_t *)0x41000000 = ((((4 & 0xFFF) << 8) | ((2 & 0x3) << 4)) | ((0xff & 0xF) << 0)) | (1 << 7);
          ADCM$initialized = TRUE;
          ADCM$taskBusy = FALSE;
          ADCM$queue_head = ADCM$queue_tail = -1;
          ADCM$queue_size = 0;
        }
#line 109
        __nesc_atomic_end(__nesc_atomic); }
      for (i = 0; i < MAX_SENSOR_NUM; i++) {
          ADCM$channel[i] = 0xff;
        }
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
      queue->element[i].obj = (void *)0;
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

# 75 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static  result_t TimerM$StdControl$init(void)
#line 75
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 76
    {
      TimerM$mState = 0;
      TimerM$queue_head = TimerM$queue_tail = -1;
      TimerM$queue_size = 0;

      TimerM$mCurrentInterval = 0;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return TimerM$Clock$setRate(0, 0);
}

# 208 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XClockM.nc"
static   void PXA27XClockM$Clock$setInterval(uint32_t value)
#line 208
{


  * (volatile uint32_t *)0x40A00084 = value;
  * (volatile uint32_t *)0x40A00044 = 0x0;


  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 215
    {
      PXA27XClockM$gmInterval = value;
    }
#line 217
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 540 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static void GPSSensorM$clearTable(void)
#line 540
{
  int8_t i;

#line 542
  for (i = 0; i < MAX_ENTRIES; ++i) 
    GPSSensorM$table[i].state = ENTRY_EMPTY;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 545
    GPSSensorM$numEntries = 0;
#line 545
    __nesc_atomic_end(__nesc_atomic); }
}

# 294 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static void PXA27XInterruptM$enable(uint8_t id)
{
  uint32_t tmp;

#line 297
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 297
    {
      if (id < 34) {
          * (volatile uint32_t *)(0x40D00004 + (id < 32 ? 0 : 0x9c)) |= 1 << id % 32;
          tmp = * (volatile uint32_t *)(0x40D00004 + (id < 32 ? 0 : 0x9c));
        }
    }
#line 302
    __nesc_atomic_end(__nesc_atomic); }
  return;
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
      FramerM$gpTxMsg = (void *)0;

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

# 311 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static void TimeSyncM$clearTable(void)
{
  int8_t i;

#line 314
  for (i = 0; i < TimeSyncM$MAX_ENTRIES; ++i) {
      TimeSyncM$table[i].state = TimeSyncM$ENTRY_EMPTY;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 317
    TimeSyncM$numEntries = 0;
#line 317
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

# 59 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static void NeighborMgmtM$initialize(void)
#line 59
{
  nmemset(NeighborMgmtM$NeighborTbl, 0, sizeof(NBRTableEntry ) * 16);
  NeighborMgmtM$initTime = TRUE;
  NeighborMgmtM$processTaskBusy = FALSE;
  NeighborMgmtM$lqiBuf = 0;
  NeighborMgmtM$rssiBuf = 0;
  NeighborMgmtM$linkaddrBuf = 0;
  NeighborMgmtM$ticks = 0;
}

# 75 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static  result_t PXA27XGPIOIntM$StdControl$start(void)
#line 75
{
  PXA27XGPIOIntM$GPIOIrq0$enable();
  PXA27XGPIOIntM$GPIOIrq1$enable();
  PXA27XGPIOIntM$GPIOIrq$enable();
  return SUCCESS;
}

# 306 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
static void PXA27XInterruptM$disable(uint8_t id)
{
  uint32_t tmp;

#line 309
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 309
    {
      if (id < 34) {
          * (volatile uint32_t *)(0x40D00004 + (id < 32 ? 0 : 0x9c)) &= ~(1 << id % 32);
          tmp = * (volatile uint32_t *)(0x40D00004 + (id < 32 ? 0 : 0x9c));
        }
    }
#line 314
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 55 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static void STUARTM$initPort(void)
#line 55
{


  {
#line 58
    * (volatile uint32_t *)(0x40E0000C + (46 < 96 ? ((46 & 0x7f) >> 5) * 4 : 0x100)) = 0 == 1 ? * (volatile uint32_t *)(0x40E0000C + (46 < 96 ? ((46 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (46 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (46 < 96 ? ((46 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (46 & 0x1f));
#line 58
    * (volatile uint32_t *)(0x40E00054 + ((46 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((46 & 0x7f) >> 4) * 4) & ~(3 << (46 & 0xf) * 2)) | (2 << (46 & 0xf) * 2);
  }
#line 58
  ;
  {
#line 59
    * (volatile uint32_t *)(0x40E0000C + (47 < 96 ? ((47 & 0x7f) >> 5) * 4 : 0x100)) = 1 == 1 ? * (volatile uint32_t *)(0x40E0000C + (47 < 96 ? ((47 & 0x7f) >> 5) * 4 : 0x100)) | (1 << (47 & 0x1f)) : * (volatile uint32_t *)(0x40E0000C + (47 < 96 ? ((47 & 0x7f) >> 5) * 4 : 0x100)) & ~(1 << (47 & 0x1f));
#line 59
    * (volatile uint32_t *)(0x40E00054 + ((47 & 0x7f) >> 4) * 4) = (* (volatile uint32_t *)(0x40E00054 + ((47 & 0x7f) >> 4) * 4) & ~(3 << (47 & 0xf) * 2)) | (1 << (47 & 0xf) * 2);
  }
#line 59
  ;










  STUARTM$UARTInterrupt$allocate();
}




static void STUARTM$configPort(void)
#line 76
{


  * (volatile uint32_t *)0x41300004 |= 1 << 5;






  * (volatile uint32_t *)0x40700004 = 1 << 7;


  * (volatile uint32_t *)0x40700004 |= 1 << 6;


  * (volatile uint32_t *)0x4070000C |= 1 << 7;
  * (volatile uint32_t *)0x40700000 = 8;
  * (volatile uint32_t *)0x40700004 = 0;
  * (volatile uint32_t *)0x4070000C &= ~(1 << 7);

  * (volatile uint32_t *)0x4070000C |= 0x3;






  * (volatile uint32_t *)0x40700008 = ((((((2 & 0x3) << 6) | (1 << 5)) | (1 << 4)) | (1 << 3)) | (1 << 2)) | (1 << 0);


  * (volatile uint32_t *)0x40700010 &= ~(1 << 4);
  * (volatile uint32_t *)0x40700010 |= 1 << 3;
}

# 249 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XDMAM.nc"
static   result_t PXA27XDMAM$PXA27XDMAChannel$setSourceAddr(uint8_t channel, uint32_t val)
#line 249
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 250
    {
      PXA27XDMAM$mDescriptorArray[channel].DSADR = val;
    }
#line 252
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static   result_t PXA27XDMAM$PXA27XDMAChannel$setTargetAddr(uint8_t channel, uint32_t val)
#line 256
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 257
    {
      PXA27XDMAM$mDescriptorArray[channel].DTADR = val;
    }
#line 259
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceAddrIncrement(uint8_t channel, bool enable)
#line 263
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 264
    {
      PXA27XDMAM$mDescriptorArray[channel].DCMD = enable == TRUE ? PXA27XDMAM$mDescriptorArray[channel].DCMD | (1 << 31) : PXA27XDMAM$mDescriptorArray[channel].DCMD & ~(1 << 31);
    }
#line 266
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 269
static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetAddrIncrement(uint8_t channel, bool enable)
#line 269
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 270
    {
      PXA27XDMAM$mDescriptorArray[channel].DCMD = enable == TRUE ? PXA27XDMAM$mDescriptorArray[channel].DCMD | (1 << 30) : PXA27XDMAM$mDescriptorArray[channel].DCMD & ~(1 << 30);
    }
#line 272
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static  result_t PXA27XDMAM$PXA27XDMAChannel$enableSourceFlowControl(uint8_t channel, bool enable)
#line 276
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 277
    {
      PXA27XDMAM$mDescriptorArray[channel].DCMD = enable == TRUE ? PXA27XDMAM$mDescriptorArray[channel].DCMD | (1 << 29) : PXA27XDMAM$mDescriptorArray[channel].DCMD & ~(1 << 29);
    }
#line 279
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static  result_t PXA27XDMAM$PXA27XDMAChannel$enableTargetFlowControl(uint8_t channel, bool enable)
#line 283
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 284
    {
      PXA27XDMAM$mDescriptorArray[channel].DCMD = enable == TRUE ? PXA27XDMAM$mDescriptorArray[channel].DCMD | (1 << 28) : PXA27XDMAM$mDescriptorArray[channel].DCMD & ~(1 << 28);
    }
#line 286
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 302
static   result_t PXA27XDMAM$PXA27XDMAChannel$setTransferLength(uint8_t channel, uint16_t length)
#line 302
{
  if (length > 8191) {

      return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 307
    {
      PXA27XDMAM$mChannelArray[channel].length = length;

      PXA27XDMAM$mDescriptorArray[channel].DCMD &= ~(0x1FFF & 0x1FFF);
      PXA27XDMAM$mDescriptorArray[channel].DCMD |= length & 0x1FFF;
    }
#line 312
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 290
static  result_t PXA27XDMAM$PXA27XDMAChannel$setMaxBurstSize(uint8_t channel, DMAMaxBurstSize_t size)
#line 290
{
  if (size >= DMA_8ByteBurst && size <= DMA_32ByteBurst) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 292
        {

          PXA27XDMAM$mDescriptorArray[channel].DCMD &= ~((3 & 0x3) << 16);
          PXA27XDMAM$mDescriptorArray[channel].DCMD |= (size & 0x3) << 16;
        }
#line 296
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  return FAIL;
}

#line 316
static  result_t PXA27XDMAM$PXA27XDMAChannel$setTransferWidth(uint8_t channel, DMATransferWidth_t width)
#line 316
{
  if (width >= DMA_NonPeripheralWidth && width <= DMA_4ByteWidth) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 318
        {

          PXA27XDMAM$mDescriptorArray[channel].DCMD &= ~((3 & 0x3) << 14);
          PXA27XDMAM$mDescriptorArray[channel].DCMD |= (width & 0x3) << 14;
        }
#line 322
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  return FAIL;
}

#line 149
static  result_t PXA27XDMAM$PXA27XDMAChannel$requestChannel(uint8_t channel, DMAPeripheralID_t peripheralID, 
DMAPriority_t priority, 
bool permanent)
#line 151
{



  uint32_t i;
#line 155
  uint32_t realChannel;
  bool foundChannel = FALSE;

#line 157
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 157
    {
      if (PXA27XDMAM$mChannelArray[channel].channelValid == TRUE) {
          foundChannel = TRUE;
        }

      if (foundChannel == FALSE && priority & DMA_Priority1) {
          for (i = 0; i < 7; i++) {
              realChannel = i < 4 ? i : i + 12;
              if (PXA27XDMAM$mPriorityMap[realChannel].inUse == FALSE) {

                  PXA27XDMAM$mPriorityMap[realChannel].inUse = TRUE;
                  PXA27XDMAM$mPriorityMap[realChannel].virtualChannel = channel;
                  PXA27XDMAM$mPriorityMap[realChannel].permanent = permanent;
                  PXA27XDMAM$mChannelArray[channel].channelValid = TRUE;
                  PXA27XDMAM$mChannelArray[channel].realChannel = realChannel;
                  PXA27XDMAM$mChannelArray[channel].peripheralID = peripheralID;
                  foundChannel = TRUE;
                  break;
                }
            }
        }
      if (foundChannel == FALSE && priority & DMA_Priority2) {
          for (i = 0; i < 7; i++) {
              realChannel = i < 4 ? i + 4 : i + 16;
              if (PXA27XDMAM$mPriorityMap[realChannel].inUse == FALSE) {

                  PXA27XDMAM$mPriorityMap[realChannel].inUse = TRUE;
                  PXA27XDMAM$mPriorityMap[realChannel].virtualChannel = channel;
                  PXA27XDMAM$mPriorityMap[realChannel].permanent = permanent;
                  PXA27XDMAM$mChannelArray[channel].channelValid = TRUE;
                  PXA27XDMAM$mChannelArray[channel].realChannel = realChannel;
                  PXA27XDMAM$mChannelArray[channel].peripheralID = peripheralID;
                  foundChannel = TRUE;
                  break;
                }
            }
        }
      if (foundChannel == FALSE && priority & DMA_Priority3) {
          for (i = 0; i < 7; i++) {
              realChannel = i < 4 ? i + 8 : i + 20;
              if (PXA27XDMAM$mPriorityMap[realChannel].inUse == FALSE) {

                  PXA27XDMAM$mPriorityMap[realChannel].inUse = TRUE;
                  PXA27XDMAM$mPriorityMap[realChannel].virtualChannel = channel;
                  PXA27XDMAM$mPriorityMap[realChannel].permanent = permanent;
                  PXA27XDMAM$mChannelArray[channel].channelValid = TRUE;
                  PXA27XDMAM$mChannelArray[channel].realChannel = realChannel;
                  PXA27XDMAM$mChannelArray[channel].peripheralID = peripheralID;
                  foundChannel = TRUE;
                  break;
                }
            }
        }
      if (foundChannel == FALSE && priority & DMA_Priority4) {
          for (i = 0; i < 7; i++) {
              realChannel = i < 4 ? i + 12 : i + 24;
              if (PXA27XDMAM$mPriorityMap[realChannel].inUse == FALSE) {

                  PXA27XDMAM$mPriorityMap[realChannel].inUse = TRUE;
                  PXA27XDMAM$mPriorityMap[realChannel].virtualChannel = channel;
                  PXA27XDMAM$mPriorityMap[realChannel].permanent = permanent;
                  PXA27XDMAM$mChannelArray[channel].channelValid = TRUE;
                  PXA27XDMAM$mChannelArray[channel].realChannel = realChannel;
                  PXA27XDMAM$mChannelArray[channel].peripheralID = peripheralID;
                  foundChannel = TRUE;
                  break;
                }
            }
        }
    }
#line 226
    __nesc_atomic_end(__nesc_atomic); }
  if (foundChannel == TRUE) {
      TOS_parampost(PXA27XDMAM$_postRequestChannelDoneveneer, (uint32_t )channel);
    }


  return SUCCESS;
}

#line 346
static   result_t PXA27XDMAM$PXA27XDMAChannel$run(uint8_t channel, DMAInterruptEnable_t interruptEn)
#line 346
{
  uint8_t realChannel;
  uint32_t width;
  uint32_t DCSRinterrupts;
#line 349
  uint32_t DCMDinterrupts;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 351
    {
      realChannel = PXA27XDMAM$mChannelArray[channel].realChannel;
      width = (PXA27XDMAM$mDescriptorArray[channel].DCMD >> 14) & 0x3;

      * (volatile uint32_t *)(0x40000100 + (PXA27XDMAM$mChannelArray[channel].peripheralID < 64 ? PXA27XDMAM$mChannelArray[channel].peripheralID * 4 : PXA27XDMAM$mChannelArray[channel].peripheralID * 4 + 3840)) = (realChannel & 0x1F) | (1 << 7);
      if (width) {
          * (volatile uint32_t *)0x400000A0 |= 1 << realChannel;
        }
      else {
          * (volatile uint32_t *)0x400000A0 &= ~(1 << realChannel);
        }

      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = 1 << 30;

      DCSRinterrupts = (interruptEn & DMA_EORINTEN ? (1 << 28) | (1 << 26) : 0) | (interruptEn & DMA_STOPINTEN ? 1 << 29 : 0);


      DCMDinterrupts = (interruptEn & DMA_ENDINTEN ? 1 << 21 : 0) | (interruptEn & DMA_STARTINTEN ? 1 << 22 : 0);

      * (volatile uint32_t *)(0x4000020C + realChannel * 16) = PXA27XDMAM$mDescriptorArray[channel].DCMD | DCMDinterrupts;

      * (volatile uint32_t *)(0x40000204 + realChannel * 16) = PXA27XDMAM$mDescriptorArray[channel].DSADR;
      * (volatile uint32_t *)(0x40000208 + realChannel * 16) = PXA27XDMAM$mDescriptorArray[channel].DTADR;
      * (volatile uint32_t *)(0x40000000 + realChannel * 4) = ((1 << 31) | (1 << 30)) | DCSRinterrupts;
    }
#line 375
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 210 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static result_t PMICM$readPMIC(uint8_t address, uint8_t *value, uint8_t numBytes)
#line 210
{


  uint32_t loopCount;




  if (PMICM$getPI2CBus() == FALSE) {
      return FAIL;
    }

  if (numBytes > 0) {
      * (volatile uint32_t *)0x40F00188 = 0x49 << 1;
      * (volatile uint32_t *)0x40F00190 |= 1 << 0;
      * (volatile uint32_t *)0x40F00190 |= 1 << 3;
      for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
      if (loopCount == 1000) {
          TOS_post(PMICM$printReadPMICBusError);
          PMICM$returnPI2CBus();
          return FAIL;
        }

      * (volatile uint32_t *)0x40F00188 = address;
      * (volatile uint32_t *)0x40F00190 &= ~(1 << 0);
      * (volatile uint32_t *)0x40F00190 |= 1 << 1;
      * (volatile uint32_t *)0x40F00190 |= 1 << 3;

      for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
      if (loopCount == 1000) {
          TOS_post(PMICM$printReadPMICAddresError);
          PMICM$returnPI2CBus();
          return FAIL;
        }
      * (volatile uint32_t *)0x40F00190 &= ~(1 << 1);



      * (volatile uint32_t *)0x40F00188 = (0x49 << 1) | 1;
      * (volatile uint32_t *)0x40F00190 |= 1 << 0;
      * (volatile uint32_t *)0x40F00190 |= 1 << 3;

      for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
      if (loopCount == 1000) {
          TOS_post(PMICM$printReadPMICSlaveAddresError);
          PMICM$returnPI2CBus();
          return FAIL;
        }

      * (volatile uint32_t *)0x40F00190 &= ~(1 << 0);


      while (numBytes > 1) {
          * (volatile uint32_t *)0x40F00190 |= 1 << 3;

          for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
          if (loopCount == 1000) {
              TOS_post(PMICM$printReadPMICReadByteError);
              PMICM$returnPI2CBus();
              return FAIL;
            }

          *value = * (volatile uint32_t *)0x40F00188;
          value++;
          numBytes--;
        }

      * (volatile uint32_t *)0x40F00190 |= 1 << 1;
      * (volatile uint32_t *)0x40F00190 |= 1 << 2;
      * (volatile uint32_t *)0x40F00190 |= 1 << 3;

      for (loopCount = 0; * (volatile uint32_t *)0x40F00190 & (1 << 3) && loopCount < 1000; loopCount++) ;
      if (loopCount == 1000) {
          TOS_post(PMICM$printReadPMICReadByteError);
          PMICM$returnPI2CBus();
          return FAIL;
        }

      *value = * (volatile uint32_t *)0x40F00188;
      * (volatile uint32_t *)0x40F00190 &= ~(1 << 1);
      * (volatile uint32_t *)0x40F00190 &= ~(1 << 2);

      PMICM$returnPI2CBus();
      return SUCCESS;
    }
  else {
      PMICM$returnPI2CBus();
      return FAIL;
    }
}

#line 672
static  result_t PMICM$PMIC$enableCharging(bool enable)
#line 672
{

  uint8_t val;

  if (enable) {

      val = PMICM$getChargerVoltage();

      if (val > 70) {
          trace(DBG_USR1, "Enabling Charger...Charger Voltage is %.3fV\r\n", val * 6 * .01035);


          PMICM$writePMIC(0x2A, 15);


          PMICM$writePMIC(0x28, ((1 << 7) | ((1 & 0xF) << 3)) | (4 & 0x7));

          PMICM$writePMIC(0x20, 0x80);

          PMICM$writePMIC(0x30, 1 << 4);
          PMICM$writePMIC(0x31, 0xE);

          PMICM$chargeMonitorTimer$start(TIMER_REPEAT, 60 * 5 * 1000);
          return SUCCESS;
        }
      else {
          trace(DBG_USR1, "Charger Voltage is %.3fV...charger not enabled\r\n", val * 6 * .01035);
        }
    }



  PMICM$PMIC$getBatteryVoltage(&val);
  trace(DBG_USR1, "Disabling Charger...Battery Voltage is %.3fV\r\n", val * .01035 + 2.65);

  PMICM$writePMIC(0x2A, 0x0);
  PMICM$writePMIC(0x28, 0x0);
  PMICM$writePMIC(0x20, 0x0);
  PMICM$writePMIC(0x30, 0x0);
  PMICM$writePMIC(0x31, 0x0);
  PMICM$chargeMonitorTimer$stop();
  return SUCCESS;
}

#line 637
static result_t PMICM$getPMICADCVal(uint8_t channel, uint8_t *val)
#line 637
{
  uint8_t oldval;
  result_t rval;


  rval = PMICM$readPMIC(0x30, &oldval, 1);
  rcombine(rval, PMICM$writePMIC(0x30, 1 << 4));
  TOSH_uwait(20);
  rcombine(rval, PMICM$writePMIC(0x30, ((channel & 0x7) | (1 << 3)) | (1 << 4)));
  rcombine(rval, PMICM$readPMIC(0x40, val, 1));

  rcombine(rval, PMICM$writePMIC(0x30, oldval));
  return rval;
}

# 98 "/opt/tinyos-1.x/tos/platform/pxa27x/TimerM.nc"
static  result_t TimerM$Timer$start(uint8_t id, char type, 
uint32_t interval)
#line 99
{
  uint32_t countRemaining;
#line 100
  uint32_t currentCount;

  if (id >= NUM_TIMERS) {
      return FAIL;
    }
  if (type > TIMER_ONE_SHOT) {
      return FAIL;
    }



  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 111
    {





      TimerM$mTimerList[id].ticks = interval;
      TimerM$mTimerList[id].ticksLeft = interval;
      TimerM$mTimerList[id].type = type;


      currentCount = TimerM$Clock$readCounter();

      countRemaining = TimerM$mCurrentInterval - currentCount;


      TimerM$mState |= 0x1L << id;
#line 140
      if (TimerM$mCurrentInterval == 0) {



          TimerM$mCurrentInterval = interval;
          TimerM$Clock$setInterval(interval);
        }
      else {

          if (interval < countRemaining) {
              if (countRemaining - interval > 1) {



                  TimerM$mCurrentInterval = interval + currentCount;
                  TimerM$Clock$setInterval(TimerM$mCurrentInterval);
                }
              else {
                }
            }
          else 

            {

              TimerM$mTimerList[id].ticksLeft += currentCount;
            }
        }
    }
#line 167
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

static  result_t TimerM$Timer$stop(uint8_t id)
#line 171
{

  result_t ret = FAIL;

#line 174
  if (id >= NUM_TIMERS) {
#line 174
    return FAIL;
    }
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 176
    {
      if (TimerM$mState & (0x1L << id)) {
          TimerM$mState &= ~(0x1L << id);

          if (!TimerM$mState) {
              TimerM$mCurrentInterval = 0;
              TimerM$Clock$setInterval(0);
            }

          ret = SUCCESS;
        }
    }
#line 187
    __nesc_atomic_end(__nesc_atomic); }
  return ret;
}

# 190 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void *DataMgmtM$DataMgmt$allocBlk(uint8_t client)
#line 190
{
  SenBlkPtr p = (void *)0;
  result_t result = SUCCESS;

  if (sensor[client].maxBlkNum != 0) {
      if (sensor[client].curBlkNum >= sensor[client].maxBlkNum) {
          result = DataMgmtM$DataMgmt$freeBlkByType(sensor[client].type);
        }
    }

  if (FAIL != result) {
      p = allocSensorMem(&DataMgmtM$sensorMem);
      if (p != (void *)0) {
          sensor[client].curBlkNum++;

          DataMgmtM$Leds$yellowToggle();
        }
      else 
#line 206
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
      return (void *)0;
    }
  else {
      return &queue->element[ind];
    }
}

# 227 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  result_t DataMgmtM$DataMgmt$freeBlk(void *obj)
#line 227
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
#line 249
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
      return (void *)0;
    }
  else {
      return &queue->element[ind];
    }
}

# 121 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static  result_t ADCM$ADCControl$bindPort(uint8_t port, uint8_t adcPort)
#line 121
{
  result_t result = FAIL;

#line 123
  if (port < MAX_SENSOR_NUM) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 124
        {
          ADCM$channel[port] = adcPort;
          result = SUCCESS;
        }
#line 127
        __nesc_atomic_end(__nesc_atomic); }
    }
  return result;
}

# 862 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static void SmartSensingM$updateMaxBlkNum(void)
#line 862
{
  uint8_t i;
  uint16_t totalRate = 0;
  uint16_t usedBlkNum = 0;

#line 866
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

#line 906
static uint16_t SmartSensingM$calFireInterval(void)
#line 906
{
  uint8_t client = 0;
  uint16_t gcd = 0;
  uint16_t value1 = 0;

#line 910
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

# 44 "/home/xu/oasis/system/platform/imote2/RTC/RTCClockM.nc"
static  result_t RTCClockM$StdControl$start(void)
#line 44
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 45
    {
      * (volatile uint32_t *)0x40A000D8 = (((1 << 7) | (1 << 3)) | (1 << 6)) | (0x4 & 0x7);

      * (volatile uint32_t *)0x40A0001C |= 1 << 10;
      * (volatile uint32_t *)0x40A00058 = 0x1;
      * (volatile uint32_t *)0x40A00098 = 0xffffffff;
    }
#line 51
    __nesc_atomic_end(__nesc_atomic); }
  RTCClockM$OSTIrq$enable();
  return SUCCESS;
}

# 639 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static  void GPSSensorM$selfCheckTask(void)
#line 639
{
  if (GPSSensorM$checkTimerOn != TRUE) {
      GPSSensorM$last_pps_index = GPSSensorM$ppsIndex;
      GPSSensorM$checkTimerOn = GPSSensorM$CheckTimer$start(TIMER_ONE_SHOT, (uint16_t )(SYNC_INTERVAL >> 1) * 1000UL);
    }
}

# 77 "/home/xu/oasis/system/platform/imote2/RTC/RTCClockM.nc"
static   void RTCClockM$MicroClock$setInterval(uint32_t value)
#line 77
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 78
    {
      * (volatile uint32_t *)0x40A00098 = value;
      * (volatile uint32_t *)0x40A00058 = 0x0;
      RTCClockM$gmInterval = value;
    }
#line 82
    __nesc_atomic_end(__nesc_atomic); }
  return;
}

# 392 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static  result_t RealTimeM$Timer$start(uint8_t id, char type, uint32_t interval)
#line 392
{
  if (type > TIMER_ONE_SHOT) {
      return FAIL;
    }
  if (interval > 0) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 397
        {
          RealTimeM$clientList[id].type = type;
          RealTimeM$clientList[id].syncInterval = interval;
          RealTimeM$clientList[id].fireCount = (RealTimeM$localTime + interval - RealTimeM$localTime % interval) % DAY_END;
          RealTimeM$mState |= 0x1L << id;
        }
#line 402
        __nesc_atomic_end(__nesc_atomic); }

      return SUCCESS;
    }
  else {
      RealTimeM$Timer$stop(id);
      return FAIL;
    }
}




static  result_t RealTimeM$Timer$stop(uint8_t id)
#line 415
{
  if (RealTimeM$mState & (0x1L << id)) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 417
        RealTimeM$mState &= ~(0x1L << id);
#line 417
        __nesc_atomic_end(__nesc_atomic); }
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 245 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static   uint8_t HPLCC2420M$HPLCC2420$write(uint8_t addr, uint16_t data)
#line 245
{
  uint8_t status = 0;
  uint8_t tmp;

  if (HPLCC2420M$getSSPPort() == FAIL) {

      TOS_post(HPLCC2420M$HPLCC2420WriteContentionError);
      return 0;
    }






  {
#line 260
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 260
  ;

  {
#line 262
    TOSH_CLR_CC_CSN_PIN();
#line 262
    TOSH_uwait(1);
  }
#line 262
  ;

  * (volatile uint32_t *)0x41900010 = addr;
  * (volatile uint32_t *)0x41900010 = (data >> 8) & 0xFF;
  * (volatile uint32_t *)0x41900010 = data & 0xFF;

  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;

  {
#line 270
    TOSH_uwait(1);
#line 270
    TOSH_SET_CC_CSN_PIN();
  }
#line 270
  ;
  status = * (volatile uint32_t *)0x41900010;

  {
#line 273
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 273
  ;

  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420WriteError);
      return 0;
    }
  return status;
}

#line 166
static result_t HPLCC2420M$getSSPPort(void)
#line 166
{
  result_t res;

#line 168
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 168
    {
      if (HPLCC2420M$gRadioOpInProgress) {
          res = FAIL;
        }
      else {
          res = SUCCESS;
          HPLCC2420M$gRadioOpInProgress = TRUE;
        }
    }
#line 176
    __nesc_atomic_end(__nesc_atomic); }
  return res;
}

static result_t HPLCC2420M$releaseSSPPort(void)
#line 180
{
  result_t res;

#line 182
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 182
    {
      if (HPLCC2420M$gRadioOpInProgress) {
          res = SUCCESS;
          HPLCC2420M$gRadioOpInProgress = FALSE;
        }
      else {
          res = FAIL;
        }
    }
#line 190
    __nesc_atomic_end(__nesc_atomic); }
  return res;
}

# 112 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$disable(uint8_t pin)
{
  if (pin < 121) {
      * (volatile uint32_t *)(0x40E00030 + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (pin & 0x1f));
      * (volatile uint32_t *)(0x40E0003C + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) &= ~(1 << (pin & 0x1f));
    }

  return;
}

static   void PXA27XGPIOIntM$PXA27XGPIOInt$clear(uint8_t pin)
{
  if (pin < 121) {
      * (volatile uint32_t *)(0x40E00048 + (pin < 96 ? ((pin & 0x7f) >> 5) * 4 : 0x100)) = 1 << (pin & 0x1f);
    }

  return;
}

# 202 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static   uint8_t HPLCC2420M$HPLCC2420$cmd(uint8_t addr)
#line 202
{
  uint8_t status = 0;
  uint8_t tmp;

  if (HPLCC2420M$getSSPPort() == FAIL) {


      return 0;
    }


  {
#line 213
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 213
  ;

  {
#line 215
    TOSH_CLR_CC_CSN_PIN();
#line 215
    TOSH_uwait(1);
  }
#line 215
  ;
  * (volatile uint32_t *)0x41900010 = addr;
  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
  {
#line 218
    TOSH_uwait(1);
#line 218
    TOSH_SET_CC_CSN_PIN();
  }
#line 218
  ;
  status = * (volatile uint32_t *)0x41900010;

  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420CmdReleaseError);
      return 0;
    }



  return status;
}

# 75 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
  __attribute((interrupt("ABORT"))) void hplarmv_dabort(void)
#line 75
{

  uint32_t fault_status;
#line 77
  uint32_t fault_address;
  uint32_t oldsp;

   __asm volatile (
  " mrc p15,0,r1,C5,C0,0               \n"
  " mov r2, %0                         \n"
  " str r1,[r2]                        \n" :  : 

  "r"(&fault_status) : 
  "r1", "r2");


   __asm volatile (
  " mrc p15,0,r1,C6,C0,0               \n"
  " mov r2, %0                         \n"
  " str r1,[r2]                        \n" :  : 

  "r"(&fault_address) : 
  "r1", "r2");



   __asm volatile (
  "mov	r0, #0xD3\n\t"
  "msr	CPSR_c, R0\n\t"
  "mov  r0 , %0\n\t"
  "str  sp, [r0]\n\t"
  "mov	r0, #0xD7\n\t"
  "msr	CPSR_c, R0\n\t" :  : 

  "r"(&oldsp) : 
  "r0");


  fault_status = ((fault_status & 0x400) >> 6) | (fault_status & 0xF);
  printFatalErrorMsgHex("Data Abort Exception.  [Fault Status, Fault Addr, SVC_SP] = ", 3, fault_status, fault_address, oldsp);
  return;
}

  __attribute((interrupt("ABORT"))) void hplarmv_pabort(void)
#line 116
{

  uint32_t fault_status;
#line 118
  uint32_t fault_address;

   __asm volatile (
  " mrc p15,0,r1,C5,C0,0               \n"
  " mov r2, %0                         \n"
  " str r1,[r2]                        \n" :  : 

  "r"(&fault_status) : 
  "r1", "r2");


   __asm volatile (
  " mrc p15,0,r1,C6,C0,0               \n"
  " mov r2, %0                         \n"
  " str r1,[r2]                        \n" :  : 

  "r"(&fault_address) : 
  "r1", "r2");


  fault_status = ((fault_status & 0x400) >> 6) | (fault_status & 0xF);
  printFatalErrorMsgHex("Prefetch Abort Exception.  [Fault Status, Fault Addr] = ", 2, fault_status, fault_address);
  return;
}




  __attribute((interrupt("IRQ"))) void hplarmv_irq(void)
#line 146
{

  uint32_t IRQPending;

  IRQPending = * (volatile uint32_t *)0x40D00018;
  IRQPending >>= 16;

  while (IRQPending & (1 << 15)) {
      uint8_t PeripheralID = IRQPending & 0x3f;





      PXA27XInterruptM$PXA27XIrq$fired(PeripheralID);
#line 198
      IRQPending = * (volatile uint32_t *)0x40D00018;
      IRQPending >>= 16;
    }
  return;
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
        FramerM$gpTxMsg = (void *)0;
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
  TOS_MsgPtr *mPPtr = (void *)0;
  uint8_t ind = 0;
  uint8_t retry;

  NetworkMsg *NMsg;

  GenericCommProM$state = FALSE;
  mPPtr = findObject(&GenericCommProM$sendQueue, msg);
  if (mPPtr == (void *)0) {
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

#line 709
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


          queue->element[ind].obj = (void *)0;

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

# 513 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static result_t GenericCommProM$tryNextSend(void)
#line 513
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 514
    {



      if (!GenericCommProM$sendTaskBusy && headElement(&GenericCommProM$sendQueue, PENDING) != (void *)0) {

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

# 368 "/home/xu/oasis/system/queue.h"
static object_type *headElement(Queue_t *queue, ObjStatus_t status)
#line 368
{

  if (queue->head[status] == -1) {
    return (void *)0;
    }
  else {
#line 373
    return queue->element[queue->head[status]].obj;
    }
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

# 81 "/opt/tinyos-1.x/tos/platform/imote2/TimerJiffyAsyncM.nc"
static   result_t TimerJiffyAsyncM$TimerJiffyAsync$setOneShot(uint32_t _jiffy)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 83
    {
      TimerJiffyAsyncM$jiffy = _jiffy;
      TimerJiffyAsyncM$bSet = TRUE;
    }
#line 86
    __nesc_atomic_end(__nesc_atomic); }

  if (_jiffy > (1 << 27) - 1) {
      TimerJiffyAsyncM$StartTimer((1 << 27) - 1);
    }
  else {
      TimerJiffyAsyncM$StartTimer(_jiffy);
    }

  return SUCCESS;
}

#line 20
static void TimerJiffyAsyncM$StartTimer(uint32_t interval)
#line 20
{

  * (volatile uint32_t *)0x40A00088 = interval << 5;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 23
    {
      * (volatile uint32_t *)0x40A0001C |= 1 << 6;
    }
#line 25
    __nesc_atomic_end(__nesc_atomic); }
  * (volatile uint32_t *)0x40A00048 = 0x0UL;
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

#line 72
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

# 644 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static uint8_t MultiHopEngineM$findInfoEntry(TOS_MsgPtr pMsg)
#line 644
{
  uint8_t i = 0;

#line 646
  for (i = 0; i < 40; i++) {
      if (MultiHopEngineM$queueEntryInfo[i].valid == TRUE && MultiHopEngineM$queueEntryInfo[i].msgPtr == pMsg) {
          break;
        }
    }
  if (i == 40) {
      ;
    }
  return i;
}

# 398 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  result_t DataMgmtM$Send$sendDone(TOS_MsgPtr pMsg, result_t success)
#line 398
{
  DataMgmtM$sendDoneR_num++;
  if (success == SUCCESS) {
      DataMgmtM$SysCheckTimer$stop();
      DataMgmtM$sysCheckCount = 0;
      DataMgmtM$SysCheckTimer$start(TIMER_ONE_SHOT, 60000UL);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 404
        DataMgmtM$sendDoneFailCheckCount = 0;
#line 404
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {

    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 408
      DataMgmtM$sendDoneFailCheckCount++;
#line 408
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

# 488 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static result_t DataMgmtM$tryNextSend(void)
#line 488
{

  if (!DataMgmtM$sendTaskBusy && headElement(&DataMgmtM$sendQueue, PENDING) != (void *)0) {
      DataMgmtM$Leds$greenToggle();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 492
        DataMgmtM$sendTaskBusy = TOS_post(DataMgmtM$sendTask);
#line 492
        __nesc_atomic_end(__nesc_atomic); }
      DataMgmtM$trynextSendCount++;
    }
  return SUCCESS;
}

# 181 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static  void *MultiHopEngineM$Send$getBuffer(uint8_t AMID, TOS_MsgPtr msg, uint16_t *length)
#line 181
{
  NetworkMsg *NMsg = (NetworkMsg *)msg->data;

#line 183
  *length = 74 - (size_t )& ((NetworkMsg *)0)->data;
  return &NMsg->data[0];
}

#line 154
static  result_t MultiHopEngineM$Send$send(uint8_t AMID, TOS_MsgPtr msg, uint16_t length)
#line 154
{
  uint16_t correctedLength = (size_t )& ((NetworkMsg *)0)->data + length;

#line 156
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

#line 349
static result_t MultiHopEngineM$insertAndStartSend(TOS_MsgPtr msg, 
uint16_t AMID, 
uint16_t length, 
TOS_MsgPtr originalTOSPtr)
{
  result_t result = FALSE;
  TOS_MsgPtr msgPtr;
  uint8_t infoInd;
  NetworkMsg *NMsg;
  NetworkMsg *NMsgCome = (NetworkMsg *)msg->data;

#line 359
  TryInsert: 
    if ((void *)0 != (msgPtr = allocBuffer(&MultiHopEngineM$buffQueue))) 
      {
        if ((infoInd = MultiHopEngineM$allocateInfoEntry()) == 40) 
          {
            ;
          }
        MultiHopEngineM$queueEntryInfo[infoInd].valid = TRUE;
        MultiHopEngineM$queueEntryInfo[infoInd].AMID = AMID;
        MultiHopEngineM$queueEntryInfo[infoInd].resend = FALSE;
        MultiHopEngineM$queueEntryInfo[infoInd].length = length;
        MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr = originalTOSPtr;
        MultiHopEngineM$queueEntryInfo[infoInd].msgPtr = msgPtr;
        nmemcpy(msgPtr, msg, sizeof(TOS_Msg ));

        result = insertElement_TinyDWFQ(&MultiHopEngineM$sendQueue, msgPtr);
        if (!result) 
          {
            freeBuffer(&MultiHopEngineM$buffQueue, msgPtr);
            MultiHopEngineM$freeInfoEntry(infoInd);
          }
        markElementAsPendingByQOS_TinyDWFQ(&MultiHopEngineM$sendQueue, 8);
      }
    else 
      {
        if (!MultiHopEngineM$useMhopPriority) {
          result = FAIL;
          }
        else {
            msgPtr = findMessageToReplace(&MultiHopEngineM$sendQueue, NMsgCome->qos);
            if (msgPtr == (void *)0) 
              {
                ;
                result = FAIL;
                goto outInsert;
              }
            else 
              {
                infoInd = MultiHopEngineM$findInfoEntry(msgPtr);
                if (infoInd == 40) 
                  {
                    ;
                  }
                if (MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr != (void *)0) 
                  {
                    MultiHopEngineM$Send$sendDone(MultiHopEngineM$queueEntryInfo[infoInd].AMID, MultiHopEngineM$queueEntryInfo[infoInd].originalTOSPtr, FAIL);
                  }
                if (SUCCESS != removeElement_TinyDWFQ(&MultiHopEngineM$sendQueue, msgPtr, PENDING_TINYDWFQ)) 
                  {
                    ;
                  }
                freeBuffer(&MultiHopEngineM$buffQueue, msgPtr);
                MultiHopEngineM$freeInfoEntry(infoInd);
                MultiHopEngineM$numberOfSendFailures++;
                goto TryInsert;
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
  if ((void *)0 != (head = headElement(bufQueue, FREEBUF))) {
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

      return (void *)0;
    }
}

# 657 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static result_t MultiHopEngineM$freeInfoEntry(uint8_t ind)
#line 657
{
  if (ind < 40) {
      MultiHopEngineM$queueEntryInfo[ind].valid = FALSE;
      MultiHopEngineM$queueEntryInfo[ind].AMID = 0;
      MultiHopEngineM$queueEntryInfo[ind].length = 0;
      MultiHopEngineM$queueEntryInfo[ind].originalTOSPtr = (void *)0;
      MultiHopEngineM$queueEntryInfo[ind].msgPtr = (void *)0;
      return SUCCESS;
    }
  else 
#line 665
    {
      ;
      return FALSE;
    }
}

# 520 "/home/xu/oasis/system/TinyDWFQ.h"
static uint8_t setAndGetDequeueWeight(TinyDWFQPtr queue, uint8_t virtualQueueIndex, uint8_t dqPriority, uint8_t freeSpace)
{
  uint8_t dequeueWeight = 0;


  if (virtualQueueIndex == 7) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[7][DQ_LOW] = 20 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[7][DQ_MEDIUM] = 30 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[7][DQ_HIGH] = 40 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[7][DQ_URGENT] = 50 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 6) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[6][DQ_LOW] = 20 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[6][DQ_MEDIUM] = 20 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[6][DQ_HIGH] = 20 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[6][DQ_URGENT] = 15 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 5) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[5][DQ_LOW] = 15 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[5][DQ_MEDIUM] = 15 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[5][DQ_HIGH] = 15 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[5][DQ_URGENT] = 10 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 4) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[4][DQ_LOW] = 15 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[4][DQ_MEDIUM] = 10 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[4][DQ_HIGH] = 10 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[4][DQ_URGENT] = 10 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 3) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[3][DQ_LOW] = 10 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[3][DQ_MEDIUM] = 10 * freeSpace / 100;
        }

      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[3][DQ_HIGH] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[3][DQ_URGENT] = 5 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 2) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[2][DQ_LOW] = 10 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[2][DQ_MEDIUM] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[2][DQ_HIGH] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[2][DQ_URGENT] = 5 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 1) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[1][DQ_LOW] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[1][DQ_MEDIUM] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[1][DQ_HIGH] = 2.5 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[1][DQ_URGENT] = 2.5 * freeSpace / 100;
        }
    }


  if (virtualQueueIndex == 0) 
    {
      if (dqPriority == DQ_LOW) 
        {
          virtualQueueDequeueWieghts[0][DQ_LOW] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_MEDIUM) 
        {
          virtualQueueDequeueWieghts[0][DQ_MEDIUM] = 5 * freeSpace / 100;
        }
      if (dqPriority == DQ_HIGH) 
        {
          virtualQueueDequeueWieghts[0][DQ_HIGH] = 2.5 * freeSpace / 100;
        }
      if (dqPriority == DQ_URGENT) 
        {
          virtualQueueDequeueWieghts[0][DQ_URGENT] = 2.5 * freeSpace / 100;
        }
    }

  dequeueWeight = virtualQueueDequeueWieghts[virtualQueueIndex][dqPriority];
  return dequeueWeight;
}

#line 767
static result_t removeElement_TinyDWFQ(TinyDWFQPtr queue, TOS_MsgPtr msg, ObjStatusTINYDWFQ_t status)
{
  int8_t ind;
#line 769
  int8_t vqIndex;
#line 769
  int8_t prevIndex;
  int8_t nextHead;

#line 771
  ind = queue->head[status];
  prevIndex = ind;

  while (ind != -1) 
    {
      if (queue->element[ind].obj == msg) 
        {

          nextHead = queue->element[ind].next;
          vqIndex = queue->element[ind].vqIndex;


          queue->element[ind].status = FREE_TINYDWFQ;
          queue->element[ind].next = -1;
          queue->element[ind].obj = (void *)0;


          if (queue->virtualQueues[vqIndex][VQ_FREE_HEAD] == -1) 
            {
              queue->virtualQueues[vqIndex][VQ_FREE_HEAD] = queue->virtualQueues[vqIndex][VQ_FREE_TAIL] = ind;
            }
          else 
            {
              queue->element[queue->virtualQueues[vqIndex][VQ_FREE_TAIL]].next = ind;
              queue->virtualQueues[vqIndex][VQ_FREE_TAIL] = ind;
            }
          queue->numOfElements_VQ[vqIndex]--;
          queue->total--;


          if (ind == queue->head[status]) 
            {

              if (nextHead == -1) 
                {
                  queue->head[status] = queue->tail[status] = -1;
                }
              else 
                {
                  queue->head[status] = nextHead;
                }
            }
          else {
#line 813
            if (ind == queue->tail[status]) 
              {

                queue->tail[status] = prevIndex;
                queue->element[prevIndex].next = -1;
              }
            else 
              {

                queue->element[prevIndex].next = nextHead;
              }
            }
          if (status == PENDING_TINYDWFQ) {
            queue->numOfElements_pending--;
            }
          else {
#line 828
            queue->numOfElements_notAcked--;
            }
          return SUCCESS;
        }
      else 
        {
          prevIndex = ind;
          ind = queue->element[ind].next;
        }
    }
  return FAIL;
}

# 422 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopEngineM.nc"
static result_t MultiHopEngineM$tryNextSend(void)
{

  if (!MultiHopEngineM$sendTaskBusy && !isListEmpty_TinyDWFQ(&MultiHopEngineM$sendQueue, PENDING_TINYDWFQ) && MultiHopEngineM$numOfPktProcessing < 4) 
    {
      if (SUCCESS != TOS_post(MultiHopEngineM$sendTask)) {
        MultiHopEngineM$sendTaskBusy = FALSE;
        }
      else {
#line 430
        MultiHopEngineM$sendTaskBusy = TRUE;
        }
    }
#line 432
  return SUCCESS;
}

# 859 "/home/xu/oasis/system/TinyDWFQ.h"
static result_t isListEmpty_TinyDWFQ(TinyDWFQPtr queue, ObjStatus_t status)
{
  result_t retVal;

#line 862
  if (status == NOT_ACKED_TINYDWFQ) 
    {
      if (queue->numOfElements_notAcked) {
        retVal = FAIL;
        }
      else {
#line 867
        retVal = SUCCESS;
        }
    }
  else {
#line 869
    if (status == PENDING_TINYDWFQ) 
      {
        if (queue->numOfElements_pending) {
          retVal = FAIL;
          }
        else {
#line 874
          retVal = SUCCESS;
          }
      }
    }
#line 876
  return retVal;
}

# 187 "/home/xu/oasis/lib/SNMS/EventReportM.nc"
static  uint8_t EventReportM$EventReport$eventSend(uint8_t eventType, uint8_t type, 
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

          if ((void *)0 != (msgPtr = allocBuffer(&EventReportM$buffQueue))) {


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

#line 298
static void EventReportM$tryNextSend(void)
#line 298
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 299
    {
      if (!EventReportM$taskBusy && headElement(&EventReportM$sendQueue, PENDING) != (void *)0) {
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

# 66 "/home/xu/oasis/lib/SNMS/Event.h"
static uint8_t *eventprintf(const uint8_t *format, ...)
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
  __builtin_va_start(ap, format);
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

# 270 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$setParent(uint16_t parent)
#line 270
{
  uint8_t ind = 0;

#line 272
  ind = NeighborMgmtM$findPreparedIndex(parent);
  if (ind == ROUTE_INVALID) {
    return FALSE;
    }
  else 
#line 275
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

#line 149
static uint8_t NeighborMgmtM$findPreparedIndex(uint16_t id)
#line 149
{
  uint8_t indes = NeighborMgmtM$findEntry(id);

#line 151
  if (indes == (uint8_t )ROUTE_INVALID) {
      indes = NeighborMgmtM$findEntryToBeReplaced();
      NeighborMgmtM$newEntry(indes, id);
    }
  return indes;
}

#line 286
static  bool NeighborMgmtM$NeighborCtrl$clearParent(bool reset)
#line 286
{
  uint8_t ind = 0;

#line 288
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
static  result_t CascadesRouterM$CascadeControl$parentChanged(address_t newParent)
#line 407
{
  TOS_MsgPtr tempPtr = (void *)0;

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

#line 323
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

# 410 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  uint16_t NeighborMgmtM$CascadeControl$getParent(void)
#line 410
{
  uint8_t ind = 0;

#line 412
  for (ind = 0; ind < 16; ind++) {
      if (NeighborMgmtM$NeighborTbl[ind].flags & NBRFLAG_VALID) {
          if (NeighborMgmtM$NeighborTbl[ind].relation & NBR_PARENT) {
            return NeighborMgmtM$NeighborTbl[ind].id;
            }
        }
    }
#line 418
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
      if (!CascadesEngineM$sendTaskBusy && headElement(&CascadesEngineM$sendQueue, PENDING) != (void *)0) {
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

# 296 "/home/xu/oasis/lib/GenericCommPro/GenericCommProM.nc"
static  result_t GenericCommProM$SendMsg$send(uint8_t id, uint16_t addr, uint8_t len, TOS_MsgPtr msg)
#line 296
{


  uint8_t ind = 0;

#line 300
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

# 42 "/opt/tinyos-1.x/tos/system/crc.h"
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
#line 52
      crc = crc << 1;
      }
  while (
#line 53
  --i);

  return crc;
}

# 470 "/opt/tinyos-1.x/tos/system/FramerM.nc"
static result_t FramerM$TxArbitraryByte(uint8_t inByte)
#line 470
{
  if (inByte == FramerM$HDLC_FLAG_BYTE || inByte == FramerM$HDLC_CTLESC_BYTE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 472
        {
          FramerM$gPrevTxState = FramerM$gTxState;
          FramerM$gTxState = FramerM$TXSTATE_ESC;
          FramerM$gTxEscByte = inByte;
        }
#line 476
        __nesc_atomic_end(__nesc_atomic); }
      inByte = FramerM$HDLC_CTLESC_BYTE;
    }

  return FramerM$ByteComm$txByte(inByte);
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

# 283 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static  result_t RealTimeM$RealTime$setTimeCount(uint32_t newCount, uint8_t userMode)
#line 283
{
  uint8_t i = 0;
  uint32_t interval = 0;
  uint32_t localcount = 0;
  result_t result = FAIL;



  uint32_t microcount = 0;

  int32_t diff;

#line 342
  if (RealTimeM$syncMode == FTSP_SYNC && userMode == FTSP_SYNC) {


      RealTimeM$GlobalTime$getGlobalTime(&localcount);
      if (localcount) {
          if (RealTimeM$is_synced != TRUE) {
              RealTimeM$localTime = localcount;
              ;
              RealTimeM$is_synced = TRUE;
              result = SUCCESS;
            }
        }
    }






  if (RealTimeM$syncMode == GPS_SYNC && userMode == GPS_SYNC) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 362
        RealTimeM$localTime = newCount;
#line 362
        __nesc_atomic_end(__nesc_atomic); }
      RealTimeM$uc_fire_point = RealTimeM$uc_fire_interval;
      RealTimeM$Clock$setInterval(RealTimeM$uc_fire_point);
      RealTimeM$is_synced = TRUE;
      result = SUCCESS;
    }

  if (RealTimeM$mState && RealTimeM$is_synced) {
      for (i = 0; i < MAX_NUM_CLIENT; i++) {
          if (RealTimeM$mState & (0x1L << i)) {
              interval = RealTimeM$clientList[i].syncInterval;
              if (interval != 0) {
                  RealTimeM$clientList[i].fireCount = (RealTimeM$localTime + interval - RealTimeM$localTime % interval) % DAY_END;
                }
            }
        }
    }

  return result;
}

#line 613
static   uint32_t RealTimeM$LocalTime$read(void)
#line 613
{
  uint32_t time;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 616
    time = RealTimeM$localTime;
#line 616
    __nesc_atomic_end(__nesc_atomic); }
  return time;
}

# 231 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static   result_t TimeSyncM$GlobalTime$local2Global(uint32_t *time)
{



  *time += TimeSyncM$offsetAverage + (int32_t )(TimeSyncM$skew * (int32_t )(*time - TimeSyncM$localAverage));
  return TimeSyncM$is_synced();
}

#line 213
static result_t TimeSyncM$is_synced(void)
{
  return TimeSyncM$numEntries >= TimeSyncM$ENTRY_VALID_LIMIT || ((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS;
}

# 302 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$addChild(uint16_t childAddr, uint16_t priorHop, bool isDirect)
#line 302
{
  uint8_t ind = 0;

#line 304
  ind = NeighborMgmtM$findPreparedIndex(childAddr);
  if (ind == ROUTE_INVALID) {
    return FALSE;
    }
  else 
#line 307
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

#line 167
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

# 146 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static uint16_t MultiHopLQI$adjustLQI(uint8_t val)
#line 146
{
  uint16_t result = 80 - (val - 50);

#line 148
  result = (result * result >> 3) * result >> 3;
  return result;
}

# 384 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static  bool NeighborMgmtM$NeighborCtrl$setCost(uint16_t addr, uint16_t parentCost)
#line 384
{
  uint8_t ind = 0;

#line 386
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

# 152 "/home/xu/oasis/lib/MultiHopOasis-DWFQ/MultiHopLQI.nc"
static  void MultiHopLQI$SendRouteTask(void)
#line 152
{
  NetworkMsg *pNWMsg = (NetworkMsg *)&MultiHopLQI$msgBuf.data[0];
  BeaconMsg *pRP = (BeaconMsg *)&pNWMsg->data[0];
  uint8_t length = (size_t )& ((NetworkMsg *)0)->data + sizeof(BeaconMsg );

  {
  }
#line 157
  ;

  if (MultiHopLQI$gbCurrentParent != TOS_BCAST_ADDR) {
      {
      }
#line 160
      ;
    }

  if (MultiHopLQI$msgBufBusy) {



      ;
      if (MultiHopLQI$localBeSink) {
          MultiHopLQI$EventReport$eventSend(EVENT_TYPE_SNMS, 
          EVENT_LEVEL_URGENT, eventprintf("Engine:from %i ROUTE BUSY", TOS_LOCAL_ADDRESS));
        }
      return;
    }

  {
  }
#line 175
  ;


  pRP->parent = MultiHopLQI$gbCurrentParent;
  pRP->parent_dup = MultiHopLQI$gbCurrentParent;
  pRP->cost = MultiHopLQI$gbCurrentParentCost + MultiHopLQI$gbCurrentLinkEst;
  pNWMsg->linksource = pNWMsg->source = TOS_LOCAL_ADDRESS;
  pRP->hopcount = MultiHopLQI$gbCurrentHopCount;
  pNWMsg->seqno = MultiHopLQI$gCurrentSeqNo++;

  if (MultiHopLQI$SendMsg$send(TOS_BCAST_ADDR, length, &MultiHopLQI$msgBuf) == SUCCESS) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 186
        MultiHopLQI$msgBufBusy = TRUE;
#line 186
        __nesc_atomic_end(__nesc_atomic); }
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

#line 254
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

# 647 "build/imote2/RpcM.nc"
static  TOS_MsgPtr RpcM$CommandReceive$receive(TOS_MsgPtr pMsg, void *payload, uint16_t payloadLength)
#line 647
{


  NetworkMsg *nwMsg = (NetworkMsg *)pMsg->data;
  ApplicationMsg *AMsg = (ApplicationMsg *)payload;
  RpcCommandMsg *msg = (RpcCommandMsg *)AMsg->data;


  RpcM$debugSequenceNo = nwMsg->seqno;



  if (RpcM$processingCommand == FALSE) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 660
        RpcM$processingCommand = TRUE;
#line 660
        __nesc_atomic_end(__nesc_atomic); }
      if (msg->address == TOS_LOCAL_ADDRESS || msg->address == TOS_BCAST_ADDR) {
          nmemcpy(RpcM$cmdStore.data, payload, payloadLength);
          RpcM$cmdStoreLength = payloadLength;

          RpcM$debugSequenceNo = nwMsg->seqno;

          if (SUCCESS != TOS_post(RpcM$processCommand)) {
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 668
                RpcM$processingCommand = FALSE;
#line 668
                __nesc_atomic_end(__nesc_atomic); }
              ;
              return (void *)0;
            }
          else {

              ;
            }
        }
      else {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 678
            RpcM$processingCommand = FALSE;
#line 678
            __nesc_atomic_end(__nesc_atomic); }
          ;
        }
    }
  else {
      ;
      return (void *)0;
    }

  return pMsg;
}

# 285 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static  result_t FlashManagerM$FlashManager$write(uint32_t addr, void *data, uint16_t numBytes)
#line 285
{

  if (TRUE != FlashManagerM$writeTaskBusy) {
      if (numBytes > 2) {
          nmemcpy(&FlashManagerM$buffer_fw, (void *)data, numBytes);
          FlashManagerM$numToWrite = numBytes;
          FlashManagerM$buffer_fw.RFChannel = FlashManagerM$RFChannel;
          ;
        }
      else {
#line 293
        if (numBytes == 1) {
            FlashManagerM$RFChannel = FlashManagerM$buffer_fw.RFChannel;
            nmemcpy(& FlashManagerM$buffer_fw.RFChannel, (void *)data, numBytes);
            if (FlashManagerM$RFChannel == FlashManagerM$buffer_fw.RFChannel) {
                return SUCCESS;
              }
            FlashManagerM$buffer_fw.FlashFlag = 1;
            FlashManagerM$buffer_fw.ProgID = G_Ident.unix_time;
            FlashManagerM$RFChannel = FlashManagerM$buffer_fw.RFChannel;
            ;
          }
        }
    }
  else 
#line 304
    {
      ;
    }

  if (TRUE != FlashManagerM$alreadyStart) {
      FlashManagerM$EraseTimer$start(TIMER_ONE_SHOT, ERASE_TIMER_INTERVAL);
      FlashManagerM$alreadyStart = TRUE;
    }

  return SUCCESS;
}

# 264 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420ControlM.nc"
static  result_t CC2420ControlM$CC2420Control$TunePreset(uint8_t chnl)
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

# 119 "/opt/tinyos-1.x/tos/system/LedsC.nc"
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

# 754 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static void SmartSensingM$upFlashClient(void)
#line 754
{

  FlashCliUnit.RFChannel = 0;
  FlashCliUnit.FlashFlag = 1;

  FlashCliUnit.ProgID = G_Ident.unix_time;
  nmemcpy((void *)& (&FlashCliUnit)->FlashSensor, (void *)(sensor + 3), 5 * sizeof(SensorClient_t ));
}

#line 840
static void SmartSensingM$setrate(void)
#line 840
{
  uint16_t oldInterval = SmartSensingM$timerInterval;

#line 842
  SmartSensingM$timerInterval = SmartSensingM$calFireInterval();
  if (oldInterval != SmartSensingM$timerInterval) {
      SmartSensingM$SensingTimer$start(TIMER_REPEAT, SmartSensingM$timerInterval);
    }
  if (0 != SmartSensingM$timerInterval) {
      SmartSensingM$WatchTimer$start(TIMER_REPEAT, 1024);
    }
  else {
#line 849
    SmartSensingM$WatchTimer$stop();
    }
}

# 743 "build/imote2/RpcM.nc"
static void RpcM$tryNextSend(void)
#line 743
{
  if (TRUE != RpcM$taskBusy) {
      RpcM$taskBusy = TOS_post(RpcM$sendResponse);
    }
  return;
}

# 575 "/home/xu/oasis/lib/Cascades/CascadesRouterM.nc"
static  void CascadesRouterM$sigRcvTask(void)
#line 575
{
  TOS_MsgPtr tempPtr = (void *)0;
  NetworkMsg *nwMsg = (void *)0;
  int8_t i;

  for (i = MAX_CAS_BUF - 1; i >= 0; i--) {
      tempPtr = & CascadesRouterM$myBuffer[i].tmsg;
      if (tempPtr != (void *)0) {
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

# 393 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
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

#line 113
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

# 665 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static  void HPLCC2420M$signalTXFIFO(void)
#line 665
{
  uint8_t len;
#line 666
  uint8_t *buf;

#line 667
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 667
    {
      len = HPLCC2420M$txlen;
      buf = HPLCC2420M$txbuf;
    }
#line 670
    __nesc_atomic_end(__nesc_atomic); }
  HPLCC2420M$HPLCC2420FIFO$TXFIFODone(len, buf);
}

# 410 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
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

# 295 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static   uint16_t HPLCC2420M$HPLCC2420$read(uint8_t addr)
#line 295
{
  uint16_t data = 0;
  uint8_t tmp;

  if (HPLCC2420M$getSSPPort() == FAIL) {

      TOS_post(HPLCC2420M$HPLCC2420ReadContentionError);
      return 0;
    }






  {
#line 310
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 310
  ;

  {
#line 312
    TOSH_CLR_CC_CSN_PIN();
#line 312
    TOSH_uwait(1);
  }
#line 312
  ;

  * (volatile uint32_t *)0x41900010 = addr | 0x40;
  * (volatile uint32_t *)0x41900010 = 0;
  * (volatile uint32_t *)0x41900010 = 0;

  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
  {
#line 319
    TOSH_uwait(1);
#line 319
    TOSH_SET_CC_CSN_PIN();
  }
#line 319
  ;

  tmp = * (volatile uint32_t *)0x41900010;
  data = * (volatile uint32_t *)0x41900010;
  data = (data << 8) & 0xFF00;
  data |= * (volatile uint32_t *)0x41900010;

  {
#line 326
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 326
  ;

  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420ReadReleaseError);
      return 0;
    }

  return data;
}

#line 777
static   result_t HPLCC2420M$InterruptFIFOP$startWait(bool low_to_high)
#line 777
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 779
    {
      HPLCC2420M$FIFOP_GPIOInt$disable();
      HPLCC2420M$FIFOP_GPIOInt$clear();
      if (low_to_high) {
          HPLCC2420M$FIFOP_GPIOInt$enable(1);
        }
      else {
          HPLCC2420M$FIFOP_GPIOInt$enable(2);
        }
    }
#line 788
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

#line 822
static   result_t HPLCC2420M$CaptureSFD$enableCapture(bool low_to_high)
#line 822
{

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 824
    {


      HPLCC2420M$SFD_GPIOInt$enable(3);
    }
#line 828
    __nesc_atomic_end(__nesc_atomic); }








  return SUCCESS;
}

# 168 "/opt/tinyos-1.x/tos/lib/CC2420Radio/CC2420RadioM.nc"
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

# 182 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static  uint32_t RealTimeM$RealTime$getTimeCount(void)
#line 182
{
  uint32_t temp;



  if (RealTimeM$syncMode == FTSP_SYNC) {
    RealTimeM$GlobalTime$getGlobalTime(&temp);
    }


  if (RealTimeM$syncMode == GPS_SYNC) {
    temp = RealTimeM$GPSGlobalTime$getGlobalTime();
    }
  if (temp >= DAY_END) {
      return temp - DAY_END;
    }
  return temp;
}

# 170 "/home/xu/oasis/system/platform/imote2/ADC/GPSSensorM.nc"
static   uint32_t GPSSensorM$GPSGlobalTime$getGlobalTime(void)
#line 170
{
  uint32_t time = 0;

#line 172
  time = GPSSensorM$GPSGlobalTime$getLocalTime();
  time = GPSSensorM$GPSGlobalTime$local2Global(time);



  return time;
}







static   uint32_t GPSSensorM$GPSGlobalTime$local2Global(uint32_t time)
#line 186
{
  uint32_t temp = 0;

#line 188
  temp = (uint32_t )(GPSSensorM$offsetAverage + (int32_t )(GPSSensorM$skew * (int32_t )(time - GPSSensorM$localAverage)));
  temp += time;
  return temp;
}

# 305 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  result_t DataMgmtM$DataMgmt$saveBlk(void *obj, uint8_t mediumType)
#line 305
{
  result_t result = FAIL;

#line 307
  if (obj != 0) {
      result = changeMemStatus(&DataMgmtM$sensorMem, (SenBlkPtr )obj, ((SenBlkPtr )obj)->status, FILLED);
    }

  return result;
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

# 475 "/home/xu/oasis/system/platform/imote2/RTC/RealTimeM.nc"
static  void RealTimeM$signalOneTimer(void)
#line 475
{
  uint8_t itimer;

#line 477
  if ((itimer = RealTimeM$dequeue()) < 30) {
      RealTimeM$Timer$fired(itimer);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 479
        RealTimeM$taskBusy = TOS_post(RealTimeM$signalOneTimer);
#line 479
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 482
        RealTimeM$taskBusy = FALSE;
#line 482
        __nesc_atomic_end(__nesc_atomic); }
    }
}

# 775 "/home/xu/oasis/lib/SmartSensing/SmartSensingM.nc"
static void SmartSensingM$saveData(uint8_t client, uint16_t data)
#line 775
{
  SenBlkPtr p = sensor[client].curBlkPtr;
  result_t result;

  if ((void *)0 != p) {

      if (p->type == TYPE_DATA_LQI) {
          if (SmartSensingM$LQIFactor++ % LQI_SAMPLE_INTERVAL == 0) {
              p->size = SmartSensingM$writeNbrLinkInfo(p->buffer, MAX_BUFFER_SIZE);
              p->taskCode = 0;
              p->priority = sensor[client].dataPriority + sensor[client].nodePriority;
              SmartSensingM$DataMgmt$saveBlk((void *)p, 0);
              sensor[client].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(client);
              return;
            }
          else {
            return;
            }
        }
      p->priority = sensor[client].dataPriority + sensor[client].nodePriority;
      if (p->priority == 0) {
          return;
        }


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
          result = SmartSensingM$DataMgmt$saveBlk((void *)p, 0);
          if (result == SUCCESS) {
              SmartSensingM$Leds$yellowToggle();
            }
          else 
#line 817
            {

              SmartSensingM$EventReport$eventSend(EVENT_TYPE_DATAMANAGE, 
              EVENT_LEVEL_URGENT, eventprintf("Smartsensing: Node %i Fail to save data.\n", TOS_LOCAL_ADDRESS));
            }

          sensor[client].curBlkPtr = (SenBlkPtr )SmartSensingM$DataMgmt$allocBlk(client);
        }
    }
  else 
    {
      ;
      return;
    }
}

# 170 "/home/xu/oasis/system/platform/imote2/ADC/ADCM.nc"
static   result_t ADCM$ADC$getData(uint8_t client)
#line 170
{
  if (client >= MAX_SENSOR_NUM) {
      return FAIL;
    }
  ADCM$reading[ADCM$dataindex].id = client;
  ADCM$reading[ADCM$dataindex].data = ADCM$readADC(ADCM$channel[client]);
  if (TRUE != ADCM$taskBusy) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 177
        ADCM$taskBusy = TOS_post(ADCM$signalOneSensor);
#line 177
        __nesc_atomic_end(__nesc_atomic); }
    }
  ADCM$enqueue(ADCM$dataindex);
  if (++ADCM$dataindex >= 40) {
      ADCM$dataindex = 0;
    }
  return SUCCESS;
}

#line 159
static  void ADCM$signalOneSensor(void)
#line 159
{
  uint8_t client;

#line 161
  if ((client = ADCM$dequeue()) < 40) {
      ADCM$ADC$dataReady(ADCM$reading[client].id, ADCM$reading[client].data);
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 163
        ADCM$taskBusy = TOS_post(ADCM$signalOneSensor);
#line 163
        __nesc_atomic_end(__nesc_atomic); }
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 166
        ADCM$taskBusy = FALSE;
#line 166
        __nesc_atomic_end(__nesc_atomic); }
    }
}

# 232 "/home/xu/oasis/lib/NeighborMgmt/NeighborMgmtM.nc"
static uint16_t NeighborMgmtM$adjustLQI(uint8_t val)
#line 232
{
  uint16_t result = 80 - (val - 50);

#line 234
  result = (result * result >> 3) * result >> 3;
  return result;
}

# 601 "/home/xu/oasis/lib/SmartSensing/DataMgmtM.nc"
static  void DataMgmtM$processTask(void)
#line 601
{
  SenBlkPtr inPtr = (void *)0;
  uint16_t taskCode = 0;

  SenBlkPtr outPtr = (void *)0;
  int16_t nextInd = -1;



  DataMgmtM$processTaskCount++;
  DataMgmtM$processloopCount = 0;
  DataMgmtM$GlobaltaskCode = 0;
  if ((void *)0 != (inPtr = headMemElement(&DataMgmtM$sensorMem, FILLED))) {
      taskCode = inPtr->taskCode;


      while (taskCode != 0) {
          DataMgmtM$processloopCount++;
          DataMgmtM$GlobaltaskCode = taskCode;


          if ((taskCode & TASK_MASK) == RSAM_FUNC) {
              if (inPtr->type == TYPE_DATA_SEISMIC) {
                  outPtr = sensor[RSAM1_CLIENT_ID].curBlkPtr;
                }
              else {
#line 626
                if (inPtr->type == TYPE_DATA_INFRASONIC) {
                    outPtr = sensor[RSAM2_CLIENT_ID].curBlkPtr;
                  }
                else {
                    taskCode = taskCode >> TASK_CODE_SIZE;
                    inPtr->taskCode = taskCode;
                    continue;
                  }
                }
#line 634
              if ((void *)0 != outPtr) {
                  if (outPtr->time == 0) {
                      outPtr->time = inPtr->time;
                    }
                  if (outPtr->size + MAX_DATA_WIDTH >= MAX_BUFFER_SIZE) {
                      DataMgmtM$DataMgmt$saveBlk((void *)outPtr, 0);
                      outPtr = (void *)0;
                    }
                }
              if ((void *)0 == outPtr) {
                  if (inPtr->type == TYPE_DATA_SEISMIC) {
                      sensor[RSAM1_CLIENT_ID].curBlkPtr = (SenBlkPtr )DataMgmtM$DataMgmt$allocBlk(RSAM1_CLIENT_ID);
                      outPtr = sensor[RSAM1_CLIENT_ID].curBlkPtr;
                    }
                  else {
                      sensor[RSAM2_CLIENT_ID].curBlkPtr = (SenBlkPtr )DataMgmtM$DataMgmt$allocBlk(RSAM2_CLIENT_ID);
                      outPtr = sensor[RSAM2_CLIENT_ID].curBlkPtr;
                    }
                }
              if ((void *)0 != outPtr) {
                  outPtr->interval = ONE_MS;
                  outPtr->taskCode = 0;
                  if (inPtr->type == TYPE_DATA_SEISMIC) {
                      outPtr->priority = RSAM1_DATA_PRIORITY;
                      outPtr->type = TYPE_DATA_RSAM1;
                    }
                  else {
                      outPtr->priority = RSAM2_DATA_PRIORITY;
                      outPtr->type = TYPE_DATA_RSAM2;
                    }
                }
            }

          if ((taskCode & TASK_MASK) == COMPRESS_FUNC) {
              if (inPtr->type != TYPE_DATA_SEISMIC) {
                  taskCode = taskCode >> TASK_CODE_SIZE;
                  inPtr->taskCode = taskCode;
                  break;
                }
              outPtr = headMemElement(&DataMgmtM$sensorMem, MEMCOMPRESSING);










              if ((void *)0 != outPtr && outPtr->size >= MAX_BUFFER_SIZE) {
                  outPtr->size = MAX_BUFFER_SIZE;
                  outPtr->taskCode = 0;

                  outPtr->priority = inPtr->priority;
                  DataMgmtM$DataMgmt$saveBlk((void *)outPtr, 0);
                  outPtr = (void *)0;
                }
              if ((void *)0 == outPtr) {
                  if ((void *)0 != (outPtr = DataMgmtM$DataMgmt$allocBlk(COMPRESS_CLIENT_ID))) {
                      changeMemStatus(&DataMgmtM$sensorMem, outPtr, outPtr->status, MEMCOMPRESSING);
                      outPtr->time = inPtr->time;
                      outPtr->type = TYPE_DATA_COMPRESS;
                      outPtr->compressnum = 0;
                      outPtr->interval = inPtr->interval;
                    }
                }
            }


          if (FAIL != processFunc[taskCode & TASK_MASK](inPtr, outPtr)) {

              if ((taskCode & TASK_MASK) == COMPRESS_FUNC) {
                  DataMgmtM$DataMgmt$freeBlk((void *)inPtr);
                  break;
                }
              else {







                  taskCode = taskCode >> TASK_CODE_SIZE;
                  inPtr->taskCode = taskCode;
                }
            }
          else 
            {

              changeMemStatus(&DataMgmtM$sensorMem, inPtr, inPtr->status, MEMPROCESSING);
              if ((taskCode & TASK_MASK) == COMPRESS_FUNC) {
                  if (outPtr->size >= MAX_BUFFER_SIZE) {
                      outPtr->size = MAX_BUFFER_SIZE;
                      outPtr->taskCode = 0;

                      outPtr->priority = inPtr->priority;
                      DataMgmtM$DataMgmt$saveBlk((void *)outPtr, 0);
                      outPtr = (void *)0;
                    }
                  else {
                    }

                  if ((void *)0 == outPtr) {
                      if ((void *)0 != (outPtr = DataMgmtM$DataMgmt$allocBlk(COMPRESS_CLIENT_ID))) {

                          changeMemStatus(&DataMgmtM$sensorMem, outPtr, outPtr->status, MEMCOMPRESSING);
                          outPtr->time = inPtr->time;
                          outPtr->type = TYPE_DATA_COMPRESS;
                          outPtr->compressnum = 0;
                          outPtr->interval = inPtr->interval;
                        }
                    }
                }







              break;
            }
        }


      if (TRUE == event_onset) {






          event_onset = FALSE;
        }

      DataMgmtM$processloopCount = 0;
      if (taskCode == 0) {
          changeMemStatus(&DataMgmtM$sensorMem, inPtr, inPtr->status, MEMPENDING);
        }
    }


  if ((void *)0 != (inPtr = headMemElement(&DataMgmtM$sensorMem, MEMPROCESSING))) {

      taskCode = inPtr->taskCode;

      while (taskCode != 0) {

          if (FAIL != processFunc[taskCode & TASK_MASK](inPtr, outPtr)) {
              if ((taskCode & TASK_MASK) == COMPRESS_FUNC && inPtr->type == TYPE_DATA_SEISMIC) {
                  DataMgmtM$DataMgmt$freeBlk((void *)inPtr);
                  break;
                }
              else {
                  taskCode = taskCode >> TASK_CODE_SIZE;
                  inPtr->taskCode = taskCode;
                }
            }
          else {
              break;
            }
        }

      if (taskCode == 0) {
          changeMemStatus(&DataMgmtM$sensorMem, inPtr, inPtr->status, MEMPENDING);
        }
    }

  if (TRUE != DataMgmtM$presendTaskBusy) {
      if ((void *)0 != headMemElement(&DataMgmtM$sensorMem, MEMPENDING)) {
          ;
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 807
            DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 807
            __nesc_atomic_end(__nesc_atomic); }
        }
    }


  if ((void *)0 != headMemElement(&DataMgmtM$sensorMem, FILLED)) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 813
        DataMgmtM$processTaskBusy = TOS_post(DataMgmtM$processTask);
#line 813
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  else {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 817
        DataMgmtM$processTaskBusy = FALSE;
#line 817
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
}

#line 508
static  void DataMgmtM$presendTask(void)
#line 508
{

  NetworkMsg *nwMsg = (void *)0;
  ApplicationMsg *appMsg = (void *)0;
  TOS_MsgPtr msg = (void *)0;
  SenBlkPtr p = (void *)0;
  TimeStamp_t *ts = (void *)0;

#line 515
  DataMgmtM$presendTaskCount++;

  if ((void *)0 != (p = headMemElement(&DataMgmtM$sensorMem, MEMPENDING))) {

      if ((void *)0 != (msg = allocBuffer(&DataMgmtM$buffQueue))) {
          DataMgmtM$allocbuffercount++;
          nwMsg = (NetworkMsg *)msg->data;
          nwMsg->qos = p->priority;
          appMsg = (ApplicationMsg *)nwMsg->data;
          appMsg->length = TSTAMPOFFSET + p->size;
          appMsg->type = p->type;
          appMsg->seqno = DataMgmtM$seqno;


          if (nwMsg->qos == 0) {
              DataMgmtM$DataMgmt$freeBlk((void *)p);
              freeBuffer(&DataMgmtM$buffQueue, msg);
              DataMgmtM$presendTaskBusy = FALSE;
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 533
                DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 533
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
#line 551
                DataMgmtM$presendTaskBusy = FALSE;
#line 551
                __nesc_atomic_end(__nesc_atomic); }
              return;
            }
          else {
              if (p->type == TYPE_DATA_COMPRESS && p->compressnum > 0) {
                  DataMgmtM$seqno += p->compressnum - 1;
                }

              DataMgmtM$DataMgmt$freeBlk((void *)p);
              { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 560
                DataMgmtM$seqno++;
#line 560
                __nesc_atomic_end(__nesc_atomic); }
            }
        }
      else 
        {
          DataMgmtM$f_allocbuffercount++;
          DataMgmtM$tryNextSend();

          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 568
            DataMgmtM$presendTaskBusy = FALSE;
#line 568
            __nesc_atomic_end(__nesc_atomic); }
          return;
        }
    }
  else {

      DataMgmtM$nothingtosend++;
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 576
        DataMgmtM$presendTaskBusy = FALSE;
#line 576
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  if (headMemElement(&DataMgmtM$sensorMem, MEMPENDING) != (void *)0) {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 581
        DataMgmtM$presendTaskBusy = TOS_post(DataMgmtM$presendTask);
#line 581
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  else {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 586
        DataMgmtM$presendTaskBusy = FALSE;
#line 586
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
}

# 173 "/home/xu/oasis/lib/SmartSensing/FlashM.nc"
static  result_t FlashM$Flash$write(uint32_t addr, uint8_t *data, uint32_t numBytes)
#line 173
{
  uint32_t i;
  uint16_t status;
  uint8_t blocklen;
  uint32_t blockAddr = addr / 0x20000 * 0x20000;

  if (addr + numBytes > 0x02000000) {
    return FAIL;
    }
#line 181
  if (addr < 0x00200000) {
    return FAIL;
    }

  for (i = 0; i < 16; i++) 

    if (
#line 186
    i != addr / 0x200000 && 
    FlashM$FlashPartitionState[i] != 0 && 
    FlashM$FlashPartitionState[i] != 3) {
      return FAIL;
      }

  for (i = addr / 0x200000; 
  i < (numBytes + addr) / 0x200000; 
  i++) 
    if (FlashM$FlashPartitionState[i] != 0) {
      return FAIL;
      }
  for (i = addr / 0x200000; 
  i < (numBytes + addr) / 0x200000; 
  i++) 
    FlashM$FlashPartitionState[i] = 1;



  for (blocklen = 0, i = blockAddr; 
  i < addr + numBytes; 
  i += 0x20000, blocklen++) 
    FlashM$unlock(i);


  if (FlashM$programBufferSupported == 2) {
      uint16_t testBuf[1];

      if (addr % 2 == 0) {
          testBuf[0] = data[0] | (* (uint8_t *)(addr + 1) << 8);
          status = __Flash_Program_Buffer(addr, testBuf, 1 - 1);
        }
      else {
          testBuf[0] = * (uint8_t *)(addr - 1) | (data[0] << 8);
          status = __Flash_Program_Buffer(addr - 1, testBuf, 1 - 1);
        }
      if (status == 0x100) {
        FlashM$programBufferSupported = 0;
        }
      else {
#line 225
        FlashM$programBufferSupported = 1;
        }
    }
  if (blocklen == 1) {
      status = FlashM$writeHelper(addr, data, numBytes, 0xFF, 0xFF);
      if (status == FAIL) {
          trace(DBG_USR1, "Write helper failed... returning failed\n");
          FlashM$writeExitHelper(addr, numBytes);
          return FAIL;
        }
    }
  else {
      uint32_t bytesLeft = numBytes;

#line 238
      status = FlashM$writeHelper(addr, data, blockAddr + 0x20000 - addr, 0xFF, 0xFF);
      if (status == FAIL) {
          trace(DBG_USR1, "**Flash.write1: FS ERROR **: Flash Write Failed with status == %d \r\n", status);
          FlashM$writeExitHelper(addr, numBytes);
          return FAIL;
        }
      bytesLeft = numBytes - (0x20000 - (addr - blockAddr));
      for (i = 1; i < blocklen - 1; i++) {
          status = FlashM$writeHelper(blockAddr + i * 0x20000, (uint8_t *)(data + numBytes - bytesLeft), 
          0x20000, 0xFF, 0xFF);
          bytesLeft -= 0x20000;
          if (status == FAIL) {
              trace(DBG_USR1, "**Flash.write2: FS ERROR **: Flash Write Failed with status == %d \r\n", status);
              FlashM$writeExitHelper(addr, numBytes);
              return FAIL;
            }
        }
      status = FlashM$writeHelper(blockAddr + i * 0x20000, data + (numBytes - bytesLeft), bytesLeft, 0xFF, 0xFF);
      if (status == FAIL) {
          trace(DBG_USR1, "** Flash.write3:FS ERROR **: Flash Write Failed with status == %d \r\n", status);
          FlashM$writeExitHelper(addr, numBytes);
          return FAIL;
        }
    }

  FlashM$writeExitHelper(addr, numBytes);
  return SUCCESS;
}

#line 430
static __attribute((noinline)) uint16_t FlashM$unlock(uint32_t addr)
#line 430
{

  addr = addr / 0x20000 * 0x20000;
   __asm volatile (
  "ldr r1,=0x0060\n\t"
  "ldr r2,=0x00FF\n\t"
  "ldr r3,=0x00D0\n\t"
  "ldr r4,=0x0050\n\t"
  "b _goUnlockCacheLine\n\t"
  ".align 5\n\t"
  "_goUnlockCacheLine:\n\t"
  "strh r4,[%0]\n\t"
  "strh r1,[%0]\n\t"
  "strh r3,[%0]\n\t"
  "strh r2,[%0]\n\t"
  "ldrh r2,[%0]\n\t"
  "nop\n\t"
  "nop\n\t"
  "nop\n\t" :  : 

  "r"(addr) : 
  "r1", "r2", "r3", "r4", "memory");
  return SUCCESS;
}

#line 82
static uint16_t FlashM$writeHelper(uint32_t addr, uint8_t *data, uint32_t numBytes, 
uint8_t prebyte, uint8_t postbyte)
#line 83
{
  uint32_t i = 0;
#line 84
  uint32_t j = 0;
#line 84
  uint32_t k = 0;
  uint16_t status;
  uint16_t buffer[32];

  if (numBytes == 0) {
    return FAIL;
    }
  if (addr % 2 == 1) {
      status = __Flash_Program_Word(addr - 1, prebyte | (data[i] << 8));

      i++;
      if (status != 0x80) 
        {
          trace(DBG_USR1, "** Write helper1:FS ERROR **: Flash Write Failed with status == %d \r\n", status);
          return FAIL;
        }
    }


  if (addr % 2 == numBytes % 2) {
      if (FlashM$programBufferSupported == 1) {
        for (; i < numBytes; i = k) {
            for (j = 0, k = i; k < numBytes && 
            j < 32; j++, k += 2) 
              buffer[j] = data[k] | (data[k + 1] << 8);

            status = __Flash_Program_Buffer(addr + i, buffer, j - 1);
            if (status != 0x80) 
              {
                trace(DBG_USR1, "** Write Helper 2: FS ERROR **: Flash Write Failed with status == %d \r\n", status);
                return FAIL;
              }
          }
        }
      else {
#line 118
        for (; i < numBytes; i += 2) {

            status = __Flash_Program_Word(addr + i, (data[i + 1] << 8) | data[i]);
            if (status != 0x80) 
              {
                trace(DBG_USR1, "** Write Helper 3: FS ERROR **: Flash Write Failed with status == %d \r\n", status);
                return FAIL;
              }
          }
        }
    }
  else 
#line 128
    {
      if (FlashM$programBufferSupported == 1) {
        for (; i < numBytes - 1; i = k) {
            for (j = 0, k = i; k < numBytes - 1 && 
            j < 32; j++, k += 2) 
              buffer[j] = data[k] | (data[k + 1] << 8);

            status = __Flash_Program_Buffer(addr + i, buffer, j - 1);
            if (status != 0x80) 
              {
                trace(DBG_USR1, "**  Write Helper 4:FS ERROR **: Flash Write Failed with status == %d \r\n", status);
                return FAIL;
              }
          }
        }
      else {
#line 143
        for (; i < numBytes - 1; i += 2) {

            status = __Flash_Program_Word(addr + i, (data[i + 1] << 8) | data[i]);
            if (status != 0x80) 
              {
                trace(DBG_USR1, "**  Write Helper 5:FS ERROR **: Flash Write Failed with status == %d \r\n", status);
                return FAIL;
              }
          }
        }
      status = __Flash_Program_Word(addr + i, data[i] | (postbyte << 8));
      if (status != 0x80) 
        {
          trace(DBG_USR1, "**  Write Helper 5:FS ERROR **: Flash Write Failed with status == %d \r\n", status);
          return FAIL;
        }
    }
  if (addr >= 0x1e00000) {
    trace(DBG_USR1, "Returning success from writehelper\n");
    }
#line 162
  return SUCCESS;
}

static void FlashM$writeExitHelper(uint32_t addr, uint32_t numBytes)
#line 165
{
  uint32_t i = 0;

#line 167
  for (i = addr / 0x200000; 
  i < (numBytes + addr) / 0x200000; 
  i++) 
    FlashM$FlashPartitionState[i] = 0;
}

# 215 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static  void FlashManagerM$writeTask(void)
#line 215
{
  static uint32_t Addr = BASE_ADDR;
  static uint32_t destAddr = BASE_ADDR + 8 + NUM_BYTES;
  static uint16_t i = 0;


  FlashManagerM$writeTaskBusy = TRUE;

  if (Addr == BASE_ADDR) {
      FlashManagerM$Flash$write(Addr, (void *)&FlashManagerM$buffer_fw, 8);
      ;
      Addr += 8;
      FlashManagerM$WritingTimer$stop();
      TOS_post(FlashManagerM$writeTask);
    }
  else {
#line 229
    if (Addr < destAddr) {
        ;
        FlashManagerM$Flash$write(Addr, (void *)((&FlashManagerM$buffer_fw)->FlashSensor + i), 16);
        Addr += 16;
        ++i;
        TOS_post(FlashManagerM$writeTask);
      }
    else 
#line 235
      {
        ;
        i = 0;
        Addr = BASE_ADDR;
      }
    }
#line 240
  FlashManagerM$writeTaskBusy = FALSE;
}

# 600 "/home/xu/oasis/lib/FTSP/TimeSync/TimeSyncM.nc"
static void TimeSyncM$adjustRootID(void)
#line 600
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
#line 653
{
  uint32_t localTime;
#line 654
  uint32_t globalTime_t;

  localTime = TimeSyncM$GlobalTime$getLocalTime();

  if (TimeSyncM$mode != TS_USER_MODE) {
      TimeSyncM$GlobalTime$getGlobalTime(&globalTime_t);
    }
  else 
#line 660
    {

      globalTime_t = TimeSyncM$GPSGlobalTime$getGlobalTime();
    }




  if (((TimeSyncMsg *)TimeSyncM$outgoingMsgBuffer.data)->rootID == TOS_LOCAL_ADDRESS) {
      if ((int32_t )(localTime - TimeSyncM$localAverage) >= 0x20000000) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 670
            {
              TimeSyncM$localAverage = localTime;
              TimeSyncM$offsetAverage = globalTime_t - localTime;
            }
#line 673
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

# 321 "/home/xu/oasis/lib/SmartSensing/FlashManagerM.nc"
static  result_t FlashManagerM$FlashManager$read(uint32_t addr, uint8_t *data, uint16_t numBytes)
#line 321
{
  result_t result;

  result = FlashManagerM$Flash$read(addr, (void *)data, numBytes);

  if (result == SUCCESS) {
      ;
    }
  else {
      ;
    }

  return result;
}

# 657 "/opt/tinyos-1.x/tos/platform/imote2/PMICM.nc"
static  result_t PMICM$PMIC$chargingStatus(uint8_t *vBat, uint8_t *vChg, 
uint8_t *iChg, uint8_t *chargeControl)
#line 658
{

  if (vBat && vChg && iChg && chargeControl) {
      PMICM$readPMIC(0x41, vBat, 1);
      PMICM$readPMIC(0x48, vChg, 1);
      PMICM$readPMIC(0x46, iChg, 1);
      PMICM$readPMIC(0x28, chargeControl, 1);
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

#line 167
static void PMICM$smartChargeEnable(void)
#line 167
{
  uint8_t val;

#line 169
  if (PMICM$isChargerEnabled() == TRUE) {

      val = PMICM$getChargerVoltage();
      trace(DBG_USR1, "Charger Status:  Charger Voltage is %.3fV\r\n", val * 6 * .01035);
      if (val > 70) {
        }
      else 
        {

          PMICM$PMIC$enableCharging(FALSE);
        }
    }
  else {

      if (PMICM$getChargerVoltage() > 70) {

          PMICM$PMIC$enableCharging(TRUE);
        }
      else {
        }
    }
}

# 432 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static void PXA27XUSBClientM$handleControlSetup(void)
#line 432
{
  uint32_t data[2];
  uint8_t statetemp;

  PXA27XUSBClientM$clearIn();
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 437
    statetemp = PXA27XUSBClientM$state;
#line 437
    __nesc_atomic_end(__nesc_atomic); }

  {
    data[0] = * (volatile uint32_t *)0x40600300;
    data[1] = * (volatile uint32_t *)0x40600300;







    * (volatile uint32_t *)0x40600100 |= 1 << (7 & 0x1f);
  }

  if (((((
#line 451
  data[0] >> (0 & 0x03) * 8) & 0xFF) >> (6 & 0x1F)) & 0x01) == 0 && ((((
  data[0] >> (0 & 0x03) * 8) & 0xFF) >> (5 & 0x1F)) & 0x01) == 0 && ((
  data[0] >> (1 & 0x03) * 8) & 0xFF) == 0x06) {

      switch ((data[0] >> (3 & 0x03) * 8) & 0xFF) 
        {
          case 0x01: 
            PXA27XUSBClientM$sendDeviceDescriptor((data[1] >> 16) & 0xFFFF);
          break;
          case 0x02: 
            PXA27XUSBClientM$sendConfigDescriptor((data[0] >> (2 & 0x03) * 8) & 0xFF, (data[1] >> 16) & 0xFFFF);
          break;
          case 0x03: 
            PXA27XUSBClientM$sendStringDescriptor((data[0] >> (2 & 0x03) * 8) & 0xFF, (data[1] >> 16) & 0xFFFF);
          break;
          case 0x22: 
            PXA27XUSBClientM$sendHidReportDescriptor((data[1] >> 16) & 0xFFFF);
          break;
          default: 


            break;
        }
    }
  else {
    if (((((
#line 475
    data[0] >> (0 & 0x03) * 8) & 0xFF) >> (6 & 0x1F)) & 0x01) == 0 && ((((
    data[0] >> (0 & 0x03) * 8) & 0xFF) >> (5 & 0x1F)) & 0x01) == 0 && ((
    data[0] >> (1 & 0x03) * 8) & 0xFF) == 0x09) {
        * (volatile uint32_t *)0x40600000 |= 1 << (4 & 0x1f);

        if ((* (volatile uint32_t *)0x40600000 & (1 << (3 & 0x1f))) != 0) {





          ;
          }
      }
    else {
#line 489
      if (((((data[0] >> (0 & 0x03) * 8) & 0xFF) >> (6 & 0x1F)) & 0x01) == 0 && ((((
      data[0] >> (0 & 0x03) * 8) & 0xFF) >> (5 & 0x1F)) & 0x01) == 1) {
          switch ((data[0] >> (1 & 0x03) * 8) & 0xFF) {
              case 0x01: 

                break;
              case 0x02: 

                break;
              case 0x03: 

                break;
              case 0x09: 

                break;
              case 0x0A: 

                * (volatile uint32_t *)0x40600100 |= 1 << (5 & 0x1f);
              break;
              case 0x0B: 

                break;
            }
        }
      else 

        {
        }
      }
    }
}

# 78 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static void *BluSHM$DynQueue_peek(BluSHM$DynQueue oDynQueue)

{


  if (oDynQueue == (void *)0 || oDynQueue->iLength <= 0) {
    return (void *)0;
    }
#line 85
  return (void *)oDynQueue->ppvQueue[oDynQueue->index];
}

#line 153
static void *BluSHM$DynQueue_dequeue(BluSHM$DynQueue oDynQueue)

{
  const void *pvItem;



  if (oDynQueue == (void *)0 || oDynQueue->iLength <= 0) {
    return (void *)0;
    }
  pvItem = oDynQueue->ppvQueue[oDynQueue->index];
  oDynQueue->ppvQueue[oDynQueue->index] = (void *)0;

  oDynQueue->iLength--;
  oDynQueue->index++;

  if (oDynQueue->iLength + 5 < oDynQueue->iPhysLength / 2) {
    BluSHM$DynQueue_shiftshrink(oDynQueue);
    }
#line 171
  return (void *)pvItem;
}

# 618 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XUSBClientM.nc"
static  void PXA27XUSBClientM$processOut(void)
#line 618
{
  uint8_t *buff;
  uint8_t type;
#line 620
  uint8_t valid = 0;
  PXA27XUSBClientM$USBdata OutStreamTemp;

#line 636
  buff = (uint8_t *)PXA27XUSBClientM$DynQueue_dequeue(PXA27XUSBClientM$OutQueue);







  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 644
    PXA27XUSBClientM$OutStream[0].endpointDR = (volatile unsigned long *const )0x40600308;
#line 644
    __nesc_atomic_end(__nesc_atomic); }
  type = *(buff + 0);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 646
    OutStreamTemp = &PXA27XUSBClientM$OutStream[type & 0x3];
#line 646
    __nesc_atomic_end(__nesc_atomic); }
  if ((type & (1 << (4 & 0x1f))) != 0) {
      PXA27XUSBClientM$clearOut();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 649
        PXA27XUSBClientM$OutStream[type & 0x3].type = type;
#line 649
        __nesc_atomic_end(__nesc_atomic); }
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 650
        PXA27XUSBClientM$OutStream[0].endpointDR = (volatile unsigned long *const )0x40600308;
#line 650
        __nesc_atomic_end(__nesc_atomic); }

      switch ((OutStreamTemp->type >> 2) & 3) {
          case 0: 
            OutStreamTemp->n = *(buff + 1);
          if (OutStreamTemp->n == 0) {
              valid = *(buff + 1 + 1);
              OutStreamTemp->len = valid;
            }
          else {
              valid = 62;
              OutStreamTemp->len = (OutStreamTemp->n + 1) * 
              62 - 1;
            }
          OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
          if (OutStreamTemp->src == (void *)0) {
              PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
              TOS_post(PXA27XUSBClientM$processOut);
              return;
            }

          nmemcpy(OutStreamTemp->src, buff + 1 + 1 + (
          OutStreamTemp->n == 0 ? 1 : 0), valid);
          break;
          case 1: 
            OutStreamTemp->n = (*(buff + 1) << 8) | *(buff + 1 + 1);
          if (OutStreamTemp->n == 0) {
              valid = *(buff + 1 + 2);
              OutStreamTemp->len = valid;
            }
          else {
              valid = 61;
              OutStreamTemp->len = (OutStreamTemp->n + 1) * 
              61 - 1;
            }
          OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
          if (OutStreamTemp->src == (void *)0) {
              PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
              TOS_post(PXA27XUSBClientM$processOut);
              return;
            }

          nmemcpy(OutStreamTemp->src, buff + 1 + 2 + (
          OutStreamTemp->n == 0 ? 1 : 0), valid);
          break;
          case 2: 
            OutStreamTemp->n = (((*(buff + 1) << 24) | (*(buff + 1 + 1) << 16)) | (*(buff + 1 + 2) << 8)) | *(buff + 1 + 3);
          if (OutStreamTemp->n == 0) {
              valid = *(buff + 1 + 4);
              OutStreamTemp->len = valid;
            }
          else {
              valid = 59;
              OutStreamTemp->len = (OutStreamTemp->n + 1) * 
              59 - 1;
            }
          OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
          if (OutStreamTemp->src == (void *)0) {
              PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
              TOS_post(PXA27XUSBClientM$processOut);
              return;
            }

          nmemcpy(OutStreamTemp->src, buff + 1 + 4 + (
          OutStreamTemp->n == 0 ? 1 : 0), valid);
        }
    }
  else {
#line 717
    if ((OutStreamTemp->type & (1 << (4 & 0x1f))) != 0) {
        switch ((OutStreamTemp->type >> 2) & 3) {
            case 0: 
              if (OutStreamTemp->index != *(buff + 1)) {

                  PXA27XUSBClientM$clearOut();
                  safe_free(buff);
                  buff = (void *)0;
                  * (volatile uint32_t *)((volatile unsigned long *const )0x40600308 - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 1 << (1 & 0x1f);

                  return;
                }
            if (OutStreamTemp->n == OutStreamTemp->index) {
              valid = *(buff + 1 + 1);
              }
            else {
#line 732
              valid = 62;
              }
            OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
            if (OutStreamTemp->src == (void *)0 && valid != 0) {
                PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
                TOS_post(PXA27XUSBClientM$processOut);
                return;
              }
            nmemcpy(OutStreamTemp->src, buff + 1 + 1 + (
            OutStreamTemp->n == OutStreamTemp->index ? 1 : 0), valid);
            break;
            case 1: 
              if (OutStreamTemp->index != ((*(buff + 1) << 8) | *(buff + 1 + 1))) {

                  PXA27XUSBClientM$clearOut();
                  safe_free(buff);
                  buff = (void *)0;
                  * (volatile uint32_t *)((volatile unsigned long *const )0x40600308 - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 1 << (1 & 0x1f);

                  return;
                }

            if (OutStreamTemp->n == OutStreamTemp->index) {
              valid = *(buff + 1 + 2);
              }
            else {
#line 757
              valid = 61;
              }
            OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
            if (OutStreamTemp->src == (void *)0) {
                PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
                TOS_post(PXA27XUSBClientM$processOut);
                return;
              }
            nmemcpy(OutStreamTemp->src, buff + 1 + 2 + (
            OutStreamTemp->n == OutStreamTemp->index ? 1 : 0), valid);
            break;
            case 2: 
              if (OutStreamTemp->index != ((((*(buff + 1) << 24) | (*(buff + 1 + 1) << 16)) | (*(buff + 1 + 2) << 8)) | *(buff + 1 + 3))) {

                  PXA27XUSBClientM$clearOut();
                  safe_free(buff);
                  buff = (void *)0;
                  * (volatile uint32_t *)((volatile unsigned long *const )0x40600308 - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 1 << (1 & 0x1f);

                  return;
                }
            if (OutStreamTemp->n == OutStreamTemp->index) {
              valid = *(buff + 1 + 4);
              }
            else {
#line 781
              valid = 59;
              }
            OutStreamTemp->src = (uint8_t *)safe_malloc(valid);
            if (OutStreamTemp->src == (void *)0) {
                PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$OutQueue, buff);
                TOS_post(PXA27XUSBClientM$processOut);
                return;
              }
            nmemcpy(OutStreamTemp->src, buff + 1 + 4 + (OutStreamTemp->n == OutStreamTemp->index ? 1 : 0), valid);
            break;
          }
      }
    else {
      ;
      }
    }
#line 796
  if ((OutStreamTemp->type & 0x3) == 2) {
    PXA27XUSBClientM$ReceiveMsg$receive((TOS_MsgPtr )OutStreamTemp->src);
    }
  else {
#line 798
    if ((OutStreamTemp->type & 0x3) == 1) {
      PXA27XUSBClientM$ReceiveBData$receive(OutStreamTemp->src, valid, 
      OutStreamTemp->index, OutStreamTemp->n, type);
      }
    else {




      if (((
#line 806
      OutStreamTemp->type & 0xE3) == 64 || (
      OutStreamTemp->type & 0xE3) == 128) || (
      OutStreamTemp->type & 0xE3) == 96) 
        {
          * (volatile uint32_t *)0x40A0000C = * (volatile uint32_t *)0x40A00010 + 9000;
          * (volatile uint32_t *)0x40A00018 = 1;
          while (1) ;
        }
      else {

        PXA27XUSBClientM$ReceiveData$receive(OutStreamTemp->src, valid);
        }
      }
    }
#line 818
  safe_free(OutStreamTemp->src);
  OutStreamTemp->src = (void *)0;
  OutStreamTemp->index++;
  safe_free(buff);
  buff = (void *)0;
  * (volatile uint32_t *)((volatile unsigned long *const )0x40600308 - (volatile unsigned long *const )0x40600300 + (volatile unsigned long *const )0x40600100) |= 1 << (1 & 0x1f);
}

# 176 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27Xdynqueue.c"
static void PXA27XUSBClientM$DynQueue_push(PXA27XUSBClientM$DynQueue oDynQueue, const void *pvItem)
#line 176
{

  if (oDynQueue == (void *)0) {
    return;
    }
  if (oDynQueue->iLength == oDynQueue->iPhysLength) {
    PXA27XUSBClientM$DynQueue_shiftgrow(oDynQueue);
    }
  if (oDynQueue->index > 0) {
    oDynQueue->index--;
    }
  else {
#line 187
    memmove((void *)(oDynQueue->ppvQueue + 1), (void *)oDynQueue->ppvQueue, sizeof(void *) * oDynQueue->iLength);
    }
#line 188
  oDynQueue->iLength++;
  oDynQueue->ppvQueue[oDynQueue->index] = pvItem;
}

# 289 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
static void BluSHM$queueInput(uint8_t *buff, uint32_t numBytesRead)
#line 289
{
  uint32_t i;
  BluSHdata data;
  char temp[80];
  static uint8_t uSpecialChar = 0;
  static uint16_t blush_cmdline_idx = 0;
  static uint16_t blush_history_idx = 0;

  for (i = 0; i < numBytesRead; i++) 
    switch (buff[i]) {
        case 0x0a: 

          break;
        case 0x0d: 
          blush_history_idx = 0;
        generalSend("\r\n", 2);
        BluSHM$blush_cur_line[blush_cmdline_idx] = '\0';
        blush_cmdline_idx = 0;
        if (BluSHM$blush_cur_line[0] != '\0') {
            BluSHM$killWhiteSpace(BluSHM$blush_cur_line);
            data = (BluSHdata )safe_malloc(sizeof(BluSHdata_t ));
            data->len = strlen(BluSHM$blush_cur_line) + 1;
            data->src = (uint8_t *)safe_malloc(data->len);
            nmemcpy(data->src, BluSHM$blush_cur_line, data->len);
            BluSHM$DynQueue_enqueue(BluSHM$InQueue, data);
            if (BluSHM$InTaskCount < 5) {
                { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 315
                  BluSHM$InTaskCount++;
#line 315
                  __nesc_atomic_end(__nesc_atomic); }
                TOS_post(BluSHM$processIn);
              }
          }
        else {
          generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
          }
#line 321
        if (i + 1 < numBytesRead && buff[i + 1] == '\n') {
          i++;
          }
#line 323
        BluSHM$blush_cur_line[0] = '\0';
        break;
        case 0x03: 

          blush_history_idx = 0;
        blush_cmdline_idx = 0;
        BluSHM$blush_cur_line[0] = '\0';
        BluSHM$clearIn();
        generalSend("\r\n", 2);
        generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
        break;
        case 0x09: 
          for (i = 0; i < BLUSH_APP_COUNT; i++) {
              BluSHM$BluSH_AppI$getName(i, temp, 80);
              if (strncmp(BluSHM$blush_cur_line, temp, strlen(BluSHM$blush_cur_line)) == 0) {
                  generalSend(temp + strlen(BluSHM$blush_cur_line), 
                  strlen(temp) - strlen(BluSHM$blush_cur_line));
                  generalSend(" ", 1);
                  strcat(BluSHM$blush_cur_line, temp + strlen(BluSHM$blush_cur_line));
                  strcat(BluSHM$blush_cur_line, " ");
                  blush_cmdline_idx = strlen(temp) + 1;
                  break;
                }
            }
        if (i >= BLUSH_APP_COUNT) {

            generalSend("\a", 1);
          }
        break;
        case '\b': 
          if (blush_cmdline_idx > 0) {

              generalSend("\b \b", 3);
              blush_cmdline_idx--;
              BluSHM$blush_cur_line[blush_cmdline_idx] = '\0';
            }
          else {
            generalSend("\a", 1);
            }
#line 361
        break;
        default: 
          if (buff[i] == 0x1b || uSpecialChar != 0) {
              static int special_i = 0;

              switch (special_i) {
                  case 0: 
                    uSpecialChar = 1;
                  special_i++;
                  continue;
                  case 1: 
                    if (buff[i] != 0x5b) {
                        uSpecialChar = 0;
                        special_i = 0;





                        continue;
                      }
                  special_i++;
                  continue;
                  case 2: 
                    uSpecialChar = buff[i];
                  special_i = 0;
                  if (uSpecialChar == 0x41) {
                      if (blush_history_idx < 4 - 1) {
                          if (blush_history_idx == 0) {
                            strcpy(BluSHM$blush_history[0], BluSHM$blush_cur_line);
                            }
#line 391
                          blush_history_idx++;

                          for (i = 0; i < blush_cmdline_idx; i++) 

                            generalSend("\b \b", 3);


                          strcpy(BluSHM$blush_cur_line, BluSHM$blush_history[blush_history_idx]);
                          generalSend(BluSHM$blush_cur_line, strlen(BluSHM$blush_cur_line));
                          blush_cmdline_idx = strlen(BluSHM$blush_cur_line);
                        }
                      else {
                          generalSend("\a", 1);
                        }
                      uSpecialChar = 0;
                      continue;
                    }
                  else {
#line 408
                    if (uSpecialChar == 0x42) {
                        if (blush_history_idx > 0) {


                            for (i = 0; i < blush_cmdline_idx; i++) {

                                generalSend("\b \b", 3);
                              }

                            blush_history_idx--;

                            strcpy(BluSHM$blush_cur_line, BluSHM$blush_history[blush_history_idx]);
                            generalSend(BluSHM$blush_cur_line, strlen(BluSHM$blush_cur_line));
                            blush_cmdline_idx = strlen(BluSHM$blush_cur_line);
                          }
                        else {
                          generalSend("\a", 1);
                          }
                        uSpecialChar = 0;
                        continue;
                      }
                    else {
                        uSpecialChar = 0;
                        continue;
                      }
                    }
                }
            }
        if (blush_cmdline_idx < 80 - 1) {
            BluSHM$blush_cur_line[blush_cmdline_idx] = buff[i];
            blush_cmdline_idx++;

            BluSHM$blush_cur_line[blush_cmdline_idx] = '\0';

            generalSend(buff + i, 1);
          }
        else {
          generalSend("\a", 1);
          }
#line 446
        break;
      }
}

#line 136
static  void BluSHM$processIn(void)
#line 136
{
  uint16_t hist_idx;
  BluSHdata data;

  if (BluSHM$DynQueue_getLength(BluSHM$InQueue) < 1) {
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 141
        BluSHM$InTaskCount--;
#line 141
        __nesc_atomic_end(__nesc_atomic); }
      return;
    }
  data = (BluSHdata )BluSHM$DynQueue_dequeue(BluSHM$InQueue);

  strcpy(BluSHM$blush_history[0], data->src);
  if (0 == strncmp("help", data->src, strlen("help"))) {
      generalSend("Blue Shell v1.1 (BluSH)\r\nhelp - Display this list\r\nls - Display all application commands\r\nhistory - Display the command history\r\nprompt - Allows you to change the prompt\r\n", 




      strlen("Blue Shell v1.1 (BluSH)\r\nhelp - Display this list\r\nls - Display all application commands\r\nhistory - Display the command history\r\nprompt - Allows you to change the prompt\r\n"));




      generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
    }
  else {
#line 160
    if (0 == strncmp("history", data->src, strlen("history"))) {
        for (hist_idx = 4 - 1; 1; hist_idx--) {
            if (BluSHM$blush_history[hist_idx][0] != '\0') {
                generalSend(BluSHM$blush_history[hist_idx], strlen(BluSHM$blush_history[hist_idx]));
                generalSend("\r\n", strlen("\r\n"));
              }
            if (hist_idx == 0) {
              break;
              }
          }
#line 169
        generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
      }
    else {
#line 171
      if (0 == strncmp("prompt", data->src, strlen("prompt"))) {
          uint8_t frstSpc = BluSHM$firstSpace(data->src, 0);

#line 173
          if (frstSpc == 0) {
            generalSend("prompt <new prompt string>\r\n", strlen("prompt <new prompt string>\r\n"));
            }
          else {
#line 176
            strncpy(BluSHM$blush_prompt, data->src + frstSpc + 1, 32);
            }
#line 177
          generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
        }
      else {
#line 179
        if (0 == strncmp("ls", data->src, strlen("ls"))) {
            unsigned int i;
            char temp[80];

            for (i = 0; i < BLUSH_APP_COUNT; i++) {
                BluSHM$BluSH_AppI$getName(i, temp, 80);
                generalSend(temp, strlen(temp));
                generalSend("\r\n", 2);
              }
            generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
          }
        else {

            uint32_t j;
            char retStr[50];
            char temp[80];

#line 195
            for (j = 0; j < BLUSH_APP_COUNT; j++) {
                BluSHM$BluSH_AppI$getName(j, temp, 80);
                if (strncmp(temp, data->src, strlen(temp)) == 0 && (
                data->src[strlen(temp)] == ' ' || data->src[strlen(temp)] == '\0')) {
                    *retStr = 0;
                    BluSHM$BluSH_AppI$callApp(j, data->src, 80, retStr, 50);

                    retStr[50 - 1] = '\0';
                    generalSend(retStr, strlen(retStr));
                    break;
                  }
              }
            if (j == BLUSH_APP_COUNT) {
              generalSend("Bad command\r\n", strlen("Bad command\r\n"));
              }





            generalSend(BluSHM$blush_prompt, strlen(BluSHM$blush_prompt));
          }
        }
      }
    }
#line 219
  for (hist_idx = 4 - 1; hist_idx > 0; hist_idx--) 
    strcpy(BluSHM$blush_history[hist_idx], BluSHM$blush_history[hist_idx - 1]);
  BluSHM$blush_history[0][0] = '\0';

  if (BluSHM$InTaskCount <= 5 && BluSHM$DynQueue_getLength(BluSHM$InQueue) > 0) {
    TOS_post(BluSHM$processIn);
    }
  else {
#line 226
    { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 226
      BluSHM$InTaskCount--;
#line 226
      __nesc_atomic_end(__nesc_atomic); }
    }
  safe_free(data->src);
  safe_free(data);
}

#line 275
static   BluSH_result_t BluSHM$BluSH_AppI$default$getName(uint8_t id, char *buff, uint8_t len)
#line 275
{
  buff[0] = '\0';
  return BLUSH_SUCCESS_DONE;
}

# 8 "/opt/tinyos-1.x/tos/platform/imote2/BluSH_AppI.nc"
static  BluSH_result_t BluSHM$BluSH_AppI$getName(uint8_t arg_0x40784798, char *arg_0x404b5250, uint8_t arg_0x404b53d8){
#line 8
  unsigned char result;
#line 8

#line 8
  switch (arg_0x40784798) {
#line 8
    case 0U:
#line 8
      result = DVFSM$SwitchFreq$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 1U:
#line 8
      result = DVFSM$GetFreq$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 2U:
#line 8
      result = PMICM$BatteryVoltage$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 3U:
#line 8
      result = PMICM$ManualCharging$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 4U:
#line 8
      result = PMICM$ChargingStatus$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 5U:
#line 8
      result = PMICM$ReadPMIC$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 6U:
#line 8
      result = PMICM$WritePMIC$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 7U:
#line 8
      result = PMICM$SetCoreVoltage$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 8U:
#line 8
      result = SettingsM$NodeID$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 9U:
#line 8
      result = SettingsM$ResetNode$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 10U:
#line 8
      result = SettingsM$TestTaskQueue$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 11U:
#line 8
      result = SettingsM$GoToSleep$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    case 12U:
#line 8
      result = SettingsM$GetResetCause$getName(arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    default:
#line 8
      result = BluSHM$BluSH_AppI$default$getName(arg_0x40784798, arg_0x404b5250, arg_0x404b53d8);
#line 8
      break;
#line 8
    }
#line 8

#line 8
  return result;
#line 8
}
#line 8
# 131 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOIntM.nc"
static    void PXA27XGPIOIntM$PXA27XGPIOInt$default$fired(uint8_t pin)
{
  return;
}

# 48 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XGPIOInt.nc"
static   void PXA27XGPIOIntM$PXA27XGPIOInt$fired(uint8_t arg_0x40643bb0){
#line 48
  switch (arg_0x40643bb0) {
#line 48
    case 0:
#line 48
      HPLCC2420M$FIFOP_GPIOInt$fired();
#line 48
      break;
#line 48
    case 1:
#line 48
      PMICM$PMICInterrupt$fired();
#line 48
      break;
#line 48
    case 13:
#line 48
      PXA27XUSBClientM$USBAttached$fired();
#line 48
      break;
#line 48
    case 16:
#line 48
      HPLCC2420M$SFD_GPIOInt$fired();
#line 48
      break;
#line 48
    case 93:
#line 48
      GPSSensorM$GPSInterrupt$fired();
#line 48
      break;
#line 48
    case 114:
#line 48
      HPLCC2420M$FIFO_GPIOInt$fired();
#line 48
      break;
#line 48
    case 116:
#line 48
      HPLCC2420M$CCA_GPIOInt$fired();
#line 48
      break;
#line 48
    default:
#line 48
      PXA27XGPIOIntM$PXA27XGPIOInt$default$fired(arg_0x40643bb0);
#line 48
      break;
#line 48
    }
#line 48
}
#line 48
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

# 494 "/opt/tinyos-1.x/tos/platform/imote2/HPLCC2420M.nc"
static  void HPLCC2420M$signalRXFIFO(void)
#line 494
{
  uint8_t len;
#line 495
  uint8_t *buf;

#line 496
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 496
    {
      len = HPLCC2420M$rxlen;
      buf = HPLCC2420M$rxbuf;
    }
#line 499
    __nesc_atomic_end(__nesc_atomic); }
  HPLCC2420M$HPLCC2420FIFO$RXFIFODone(len, buf);
}

#line 442
static   result_t HPLCC2420M$HPLCC2420RAM$write(uint16_t addr, uint8_t length, uint8_t *buffer)
#line 442
{
  uint8_t i = 0;
#line 443
  uint8_t tmp;





  if (HPLCC2420M$getSSPPort() == FAIL) {

      TOS_post(HPLCC2420M$HPLCC2420RAMWriteContentionError);
      return 0;
    }

  {
#line 455
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 455
  ;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 456
    {
      HPLCC2420M$txramaddr = addr;
      HPLCC2420M$txramlen = length;
      HPLCC2420M$txrambuf = buffer;
    }
#line 460
    __nesc_atomic_end(__nesc_atomic); }

  {
#line 462
    TOSH_CLR_CC_CSN_PIN();
#line 462
    TOSH_uwait(1);
  }
#line 462
  ;

  * (volatile uint32_t *)0x41900010 = (addr & 0x7F) | 0x80;
  * (volatile uint32_t *)0x41900010 = (addr >> 1) & 0xC0;
  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;

  while (length > 16) {

      for (i = 0; i < 16; i++) {
          * (volatile uint32_t *)0x41900010 = * buffer++;
        }
      while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;
      length -= 16;
    }
  for (i = 0; i < length; i++) {
      * (volatile uint32_t *)0x41900010 = * buffer++;
    }
  while (* (volatile uint32_t *)0x41900008 & (1 << 4)) ;


  {
#line 482
    TOSH_uwait(1);
#line 482
    TOSH_SET_CC_CSN_PIN();
  }
#line 482
  ;

  {
#line 484
    while (* (volatile uint32_t *)0x41900008 & (1 << 3)) tmp = * (volatile uint32_t *)0x41900010;
  }
#line 484
  ;

  if (HPLCC2420M$releaseSSPPort() == FAIL) {
      TOS_post(HPLCC2420M$HPLCC2420RamWriteReleaseError);
      return 0;
    }

  return TOS_post(HPLCC2420M$signalRAMWr);
}

# 276 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static void STUARTM$handleRxDMADone(uint16_t numBytesSent)
#line 276
{

  STUARTM$gRxBuffer = STUARTM$BulkTxRx$BulkReceiveDone(STUARTM$gRxBuffer, 
  numBytesSent);
  if (STUARTM$gRxBuffer) {


      STUARTM$RxDMAChannel$setTargetAddr((uint32_t )STUARTM$gRxBuffer);
      STUARTM$RxDMAChannel$setTransferLength(STUARTM$gRxNumBytes);
      STUARTM$RxDMAChannel$run(DMA_ENDINTEN | DMA_EORINTEN);
    }
  else {
      if (STUARTM$gNumRxFifoOverruns > 0) {
        }


      STUARTM$closeRxPort();
    }
}

# 260 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkReceiveDone(uint8_t *RxBuffer, 
uint16_t NumBytes)
#line 261
{

  bufferInfo_t *pBI;
  uint8_t *newBuffer;

  pBI = getNextBufferInfo(&BufferedSTUARTM$receiveBufferInfoSet);
  (void )(pBI || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c", (int )267, "pBI"), 0));

  pBI->pBuf = RxBuffer;
  pBI->numBytes = NumBytes;

  TOS_parampost(BufferedSTUARTM$_receiveDoneveneer, (uint32_t )pBI);

  newBuffer = getNextBuffer(&BufferedSTUARTM$receiveBufferSet);

  (void )(newBuffer || (printAssertMsg("/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c", (int )276, "newBuffer"), 0));

  return newBuffer;
}

# 199 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static result_t STUARTM$closeRxPort(void)
#line 199
{



  STUARTM$gRxPortInUse = FALSE;
  STUARTM$gRxBuffer = (void *)0;
  STUARTM$gRxNumBytes = 0;








  return SUCCESS;
}

# 285 "/opt/tinyos-1.x/tos/platform/imote2/BufferedUART.c"
static   uint8_t *BufferedSTUARTM$BulkTxRx$BulkTransmitDone(uint8_t *TxBuffer, uint16_t NumBytes)
#line 285
{

  bufferInfo_t *pBI;
  int status;

#line 289
  pBI = popptrqueue(&outgoingQueue, &status);
  if (status == 1) {

      if (pBI->pBuf == TxBuffer && pBI->numBytes == NumBytes) {

          TOS_parampost(BufferedSTUARTM$_transmitDoneveneer, (uint32_t )pBI);
        }
      else {
          printFatalErrorMsg("BufferedUART.c found unexpected buffer in queue", 0);
        }
    }
  else {
      printFatalErrorMsg("BufferedUART.c found tranmit queue empty after sending data", 0);
    }
  return (void *)0;
}

# 177 "/opt/tinyos-1.x/tos/platform/imote2/UART.c"
static result_t STUARTM$closeTxPort(void)
#line 177
{



  STUARTM$gTxPortInUse = FALSE;
  STUARTM$gTxBuffer = (void *)0;
  STUARTM$gTxNumBytes = 0;
#line 196
  return SUCCESS;
}

# 204 "/opt/tinyos-1.x/tos/platform/pxa27x/PXA27XInterruptM.nc"
  __attribute((interrupt("FIQ"))) void hplarmv_fiq(void)
#line 204
{

  uint32_t FIQPending;

  FIQPending = * (volatile uint32_t *)0x40D00018;
  FIQPending &= 0xFF;

  while (FIQPending & (1 << 15)) {
      uint8_t PeripheralID = FIQPending & 0x3f;

#line 213
      PXA27XInterruptM$PXA27XFiq$fired(PeripheralID);
      FIQPending = * (volatile uint32_t *)0x40D00018;
      FIQPending &= 0xFF;
    }

  return;
}

# 96 "/opt/tinyos-1.x/tos/platform/imote2/BluSHM.nc"
  void trace_unset(void)
#line 96
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 97
    BluSHM$trace_modes = 0;
#line 97
    __nesc_atomic_end(__nesc_atomic); }
}

# 57 "/home/xu/oasis/lib/SmartSensing/ProcessTasks.h"
static result_t RsamFunc(SenBlkPtr inPtr, SenBlkPtr outPtr)
#line 57
{
  uint16_t *srcStart;
  uint16_t *srcEnd;
  uint16_t *dst;
  uint16_t interval;
  int32_t temp = 0;
  static uint32_t rsam1_amp = 0;
  static uint32_t rsam1_count = 0;
  static uint32_t rsam1_time = 0;
  static uint32_t rsam2_amp = 0;
  static uint32_t rsam2_count = 0;
  static uint32_t rsam2_time = 0;
  static uint32_t rsam1_avg = 0;
  static uint32_t rsam2_avg = 0;
  static uint32_t rsam1_rawamp = 0;
  static uint32_t rsam2_rawamp = 0;

  if ((void *)0 != inPtr && (void *)0 != outPtr) {
      srcStart = (uint16_t *)inPtr->buffer;
      srcEnd = (uint16_t *)(inPtr->buffer + inPtr->size);
      dst = (uint16_t *)(outPtr->buffer + outPtr->size);
      interval = inPtr->interval;
      if (TYPE_DATA_RSAM1 == outPtr->type) {
          while (srcStart < srcEnd) {
              temp = *srcStart - rsam1_avg;
              rsam1_rawamp += * srcStart++;
              if (temp < 0) {
                  rsam1_amp -= temp;
                }
              else {
                  rsam1_amp += temp;
                }
              rsam1_time += interval;
              ++rsam1_count;
              if (rsam1_time >= ONE_MS && rsam1_count != 0) {
                  rsam1_avg = rsam1_rawamp / rsam1_count;
                  if (restartRSAM == 1) {
                      *dst = 0;

                      restartRSAM = 0;
                    }
                  else {
                      *dst = rsam1_amp / rsam1_count;
                    }
                  outPtr->size += MAX_DATA_WIDTH;

                  StaLtaFunc2(*dst, inPtr->time);
                  ++dst;
                  if (inPtr->time > 2000UL) 
                    {
                      delay_end = inPtr->time - 2000UL;
                    }
                  else {
                      delay_end = 0xffffffff - inPtr->time;
                    }
                  rsam1_amp = rsam1_time = rsam1_count = rsam1_rawamp = 0;
                }
            }
        }
      else {
          while (srcStart < srcEnd) {
              temp = *srcStart - rsam2_avg;
              rsam2_rawamp += * srcStart++;
              if (temp < 0) {
                  rsam2_amp -= temp;
                }
              else {
                  rsam2_amp += temp;
                }
              rsam2_time += interval;
              ++rsam2_count;
              if (rsam2_time >= ONE_MS && rsam2_count != 0) {
                  rsam2_avg = rsam2_rawamp / rsam2_count;
                  * dst++ = rsam2_amp / rsam2_count;

                  outPtr->size += MAX_DATA_WIDTH;
                  rsam2_amp = rsam2_time = rsam2_count = rsam2_rawamp = 0;
                }
            }
        }
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

#line 220
static result_t PrioritizeFunc(SenBlkPtr inPtr, SenBlkPtr outPtr)
#line 220
{
  if ((void *)0 != inPtr) {
      if (inPtr->type == TYPE_DATA_SEISMIC || inPtr->type == TYPE_DATA_INFRASONIC) {
          if (delay_end > inPtr->time) {

              if (
#line 224
              start_point != end_point
               && inPtr->time >= start_point && inPtr->time <= end_point) {
                  if (inPtr->priority < 5) {

                      inPtr->priority = eventPrio;
                    }
                  else {
                      inPtr->priority = 7;
                    }
                  eventPri++;
                  ;
                }
              return SUCCESS;
            }
          else {
              return FAIL;
            }
        }
      return SUCCESS;
    }
  return FAIL;
}







static result_t ThresholdFunc(SenBlkPtr inPtr, SenBlkPtr outPtr)
#line 253
{
  uint16_t *srcStart;
  uint16_t *srcEnd;

  if ((void *)0 != inPtr) {
      srcStart = (uint16_t *)inPtr->buffer;
      srcEnd = (uint16_t *)(inPtr->buffer + inPtr->size);
      while (srcStart < srcEnd) {
          if (*srcStart > 60000UL) {
              inPtr->priority += 1;
              break;
            }
          ++srcStart;
        }
    }
  return SUCCESS;
}



static result_t CompressFunc(SenBlkPtr inPtr, SenBlkPtr outPtr)
#line 273
{

  static SenBlkPtr lastInPtr = (void *)0;

  static uint16_t lastLen = 0;
  uint8_t compress_done = 0;



  uint16_t processingLen = 0;

  if (inPtr != (void *)0 && outPtr != (void *)0) {



      if (inPtr == lastInPtr) {
          processingLen = compress((uint16_t *)inPtr->buffer + lastLen, inPtr->size / 2 - lastLen, outPtr, &compress_done);
        }
      else 

        {




          processingLen = compress((uint16_t *)inPtr->buffer, inPtr->size / 2, outPtr, &compress_done);
        }


      lastInPtr = inPtr;






      if (processingLen + lastLen < inPtr->size / 2 && processingLen + lastLen > 0) {
          lastLen += processingLen;



          inPtr->time += inPtr->interval * lastLen;
          return FAIL;
        }
      else {
#line 316
        if (processingLen + lastLen >= inPtr->size / 2) {
            lastLen = 0;


            return SUCCESS;
          }
        else 
#line 321
          {
            lastLen = 0;
            return SUCCESS;
          }
        }
    }
  else {
      return FAIL;
    }
}

# 98 "/home/xu/oasis/lib/SmartSensing/Compress.h"
static uint16_t compress(uint16_t *source, uint8_t size, SenBlkPtr outPtr, uint8_t *compress_done)
#line 98
{

  static uint32_t foldedtotal;
  static int32_t codeparam;
  static int32_t oldcodeparam;
  static uint16_t packetsamplecount = 0;
  static uint16_t compress_start = 0;
  static int packetbitcost = 0;
  static int thispacketoverhead;
  static int uncodedcost = 0;
  static int total_samplecount = 0;
  static int32_t last_sample = 0;

  int thisdebiasedsample = 0;
  uint8_t samplecount = 0;
  int32_t newsample = 0;
  uint16_t foldedsample = 0;
  int32_t i = 0;
  int err_r;
  uint16_t processingLen = 0;
  long predicteddebiased_r;
  long predictedsample_r;

  int temp = 16 - 1;

#line 122
  codeoverheadbits = 0;
  while (temp > 0) {
      temp >>= 1;
      codeoverheadbits++;
    }


  if (compress_start == 0) 
    {
      if (thepacket != outPtr->buffer) {
          Init_packet = outPtr->buffer;
          thepacket = outPtr->buffer;
        }


      thispacketoverhead = startnewpacket();
      compress_start = 2;
    }
  if (compress_start == 1) {
      if (thepacket != outPtr->buffer) {
          Init_packet = outPtr->buffer;
          thepacket = outPtr->buffer;
        }

      packetsamplecount = 0;
      thispacketoverhead = startnewpacket();

      predicteddebiased_r = predictdebiasedsample_r(0);
      predictedsample_r = predicteddebiased_r + biasestimate_r;


      if (predictedsample_r > maxsample_r) {
        predictedsample_r = maxsample_r;
        }
#line 155
      if (predictedsample_r < minsample_r) {
        predictedsample_r = minsample_r;
        }
      thisdebiasedsample = last_sample - ((biasestimate_r + ((1 << (14 - 1)) - 1)) >> 14);
      packetdebiasedsamples[0] = thisdebiasedsample;
      packetdebiasedscaled[0] = ((thisdebiasedsample << 14) + halfmu) >> muexponent;

      foldedsample = foldsample(last_sample, predictedsample_r);
      packetfoldedsamples[0] = foldedsample;
      foldedtotal = foldedsample;


      packetsamplecount += 1;


      biasestimate_r -= (biasestimate_r - (last_sample << 14) + biasscalealmosthalf) >> biasscalebits;
      compress_start = 2;
    }


  while (samplecount < size) {

      total_samplecount++;
      newsample = * source++;

      ++processingLen;

      predicteddebiased_r = predictdebiasedsample_r(packetsamplecount);
      predictedsample_r = predicteddebiased_r + biasestimate_r;



      if (predictedsample_r > maxsample_r) {
        predictedsample_r = maxsample_r;
        }
#line 189
      if (predictedsample_r < minsample_r) {
        predictedsample_r = minsample_r;
        }
      thisdebiasedsample = newsample - ((biasestimate_r + ((1 << (14 - 1)) - 1)) >> 14);
      packetdebiasedsamples[packetsamplecount] = thisdebiasedsample;
      packetdebiasedscaled[packetsamplecount] = ((thisdebiasedsample << 14) + halfmu) >> muexponent;

      foldedsample = foldsample(newsample, predictedsample_r);
      packetfoldedsamples[packetsamplecount] = foldedsample;
      foldedtotal += foldedsample;

      ++packetsamplecount;




      oldcodeparam = codeparam;
      uncodedcost = thispacketoverhead + packetsamplecount * 16;

      if (uncodedcost < 56 * 8) {


          packetbitcost = uncodedcost;
          codeparam = -1;
        }
      else 
#line 213
        {


          codeparam = codechoice(foldedtotal, packetsamplecount);









          if (codeparam == -1) {
            packetbitcost = uncodedcost;
            }
          else 
#line 228
            {


              if (oldcodeparam == codeparam) {
                  packetbitcost += codeparam + (packetfoldedsamples[packetsamplecount - 1] >> codeparam) + 1;
                }
              else 
#line 233
                {
                  packetbitcost = thispacketoverhead;
                  for (i = 0; i < packetsamplecount; i++) 
                    packetbitcost += codeparam + (packetfoldedsamples[i] >> codeparam) + 1;
                  if (packetbitcost > uncodedcost) {
                      packetbitcost = uncodedcost;
                      codeparam = -1;
                    }
                }
            }
        }





      if (packetbitcost < 56 * 8) {


          if (packetsamplecount > 3) {
              err_r = predicteddebiased_r - (thisdebiasedsample << 14);

              if (err_r < 0) {
                  for (i = 0; i < 3; i++) {
                      weight_r[i] += packetdebiasedscaled[packetsamplecount - i - 2];
                    }
                }
              else {
                  for (i = 0; i < 3; i++) {
                      weight_r[i] -= packetdebiasedscaled[packetsamplecount - i - 2];
                    }
                }
            }


          biasestimate_r -= (biasestimate_r - (newsample << 14) + biasscalealmosthalf) >> biasscalebits;
        }
      else 


        {




          if (packetbitcost == 56 * 8) {
              encodepacket(packetsamplecount, codeparam, outPtr);
              *compress_done = 1;

              compress_start = 0;



              packetsamplecount = 0;
              foldedtotal = 0;

              fclose(output_compress);
              packetcount++;
              if (packetsamplecount % 28 != 0) {
                  outPtr->compressnum = packetsamplecount / 28 + 1;
                }
              else 
#line 293
                {
                  outPtr->compressnum = packetsamplecount / 28;
                }
              return processingLen;
            }
          else 
#line 297
            {

              encodepacket(packetsamplecount - 1, oldcodeparam, outPtr);
              *compress_done = 1;


              compress_start = 1;


              last_sample = newsample;

              fclose(output_compress);
              packetcount++;
              if ((packetsamplecount - 1) % 28 != 0) {
                  outPtr->compressnum = (packetsamplecount - 1) / 28 + 1;
                }
              else 
#line 312
                {
                  outPtr->compressnum = (packetsamplecount - 1) / 28;
                }
              return processingLen - 1;
            }
        }

      samplecount++;
    }

  *compress_done = 0;
  return processingLen;
}



static int startnewpacket(void )
#line 328
{
  int i = 0;

  packetbitpointer = 0;
  packetbytepointer = 0;


  for (i = 0; i < 3; i++) 
    weight_r[i] = (1 << 14) * weightinitfactor[i];



  biasestimate_r = biasquantencode_r(biasestimate_r);

  weightquantencode();


  return codeoverheadbits + 8 * packetbytepointer + packetbitpointer;
}

#line 381
static void writesignmagnitude(int thevalue, int numbits)
#line 381
{
  int themagnitude;


  if (thevalue < 0) {
    themagnitude = -thevalue;
    }
  else {
#line 388
    themagnitude = thevalue;
    }

  writeunsignedint(themagnitude, numbits - 1);


  if (themagnitude) {
    if (thevalue < 0) {
      writebit(1);
      }
    else {
#line 398
      writebit(0);
      }
    }
}

static void writeunsignedint(uint16_t thevalue, uint16_t numbits)
#line 403
{
  int i;

  for (i = 0; i < numbits; i++) 
    writebit(thevalue & (1 << i));
}

#line 515
static void writebit(int32_t bitvalue)
#line 515
{


  if (packetbytepointer >= 56) {


      ;
      return;
    }

  if (bitvalue) {
    thepacket[packetbytepointer] |= 1 << packetbitpointer;
    }
  else {
#line 528
    thepacket[packetbytepointer] &= ~(1 << packetbitpointer);
    }

  packetbitpointer++;
  if (packetbitpointer == 8) {
      packetbitpointer = 0;
      packetbytepointer++;
    }
}







static long predictdebiasedsample_r(int numpacketsamples)
#line 544
{
  int predictedvalue_r = 0;
  int i;

  if (numpacketsamples >= 3) {

      for (i = 0; i < 3; i++) 
        predictedvalue_r += weight_r[i] * packetdebiasedsamples[numpacketsamples - i - 1];
    }
  else {
#line 553
    if (numpacketsamples > 0) {
        for (i = 0; i < numpacketsamples; i++) 
          predictedvalue_r += weight_r[i] * packetdebiasedsamples[numpacketsamples - i - 1];

        for (i = numpacketsamples; i < 3; i++) 
          predictedvalue_r += weight_r[i] * packetdebiasedsamples[0];
      }
    }







  return predictedvalue_r;
}

#line 671
static uint16_t foldsample(int thesamplevalue, int32_t theprediction)
#line 671
{

  uint16_t foldedvalue;
  int roundprediction;
  int delta;
#line 675
  int theta;


  roundprediction = (theprediction + ((1 << (14 - 1)) - 1)) >> 14;

  delta = thesamplevalue - roundprediction;
  theta = roundprediction - -(1 << 16) < (1 << 16) - 1 - roundprediction ? roundprediction - -(1 << 16) : (1 << 16) - 1 - roundprediction;



  if (roundprediction << 14 > theprediction) {

      if (delta >= 0 && delta <= theta) {
        foldedvalue = delta << 1;
        }
      else {
#line 689
        if (delta < 0 && delta >= -theta) {
          foldedvalue = (-delta << 1) - 1;
          }
        else {
#line 692
          if (delta < 0) {
            foldedvalue = theta - delta;
            }
          else {
#line 695
            foldedvalue = theta + delta;
            }
          }
        }
    }
  else 
#line 697
    {

      if (delta <= 0 && delta >= -theta) {
        foldedvalue = -delta << 1;
        }
      else {
#line 701
        if (delta > 0 && delta <= theta) {
          foldedvalue = (delta << 1) - 1;
          }
        else {
#line 704
          if (delta < 0) {
            foldedvalue = theta - delta;
            }
          else {
#line 707
            foldedvalue = theta + delta;
            }
          }
        }
    }
#line 709
  return foldedvalue;
}

#line 598
static void encodepacket(int32_t numpacketsamples, int32_t codingparameter, SenBlkPtr outPtr)
#line 598
{
  int32_t i;










  if (codingparameter == -1) {
      for (i = 0; i < codeoverheadbits; i++) 
        writebit(1);
    }
  else 
#line 613
    {
      for (i = 0; i < codeoverheadbits; i++) {
          writebit(codingparameter & (1 << i));
        }
    }






  for (i = 0; i < numpacketsamples; i++) {
      encodevalue(packetfoldedsamples[i], codingparameter);
    }


  outPtr->size = 56;


  sendpacket();
}

