#define nx_struct struct
#define nx_union union
#define dbg(mode, format, ...) ((void)0)
#define dbg_clear(mode, format, ...) ((void)0)
#define dbg_active(mode) 0
# 65 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/stdint.h"
typedef signed char int8_t;




typedef unsigned char uint8_t;
# 104 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/stdint.h" 3
typedef int int16_t;




typedef unsigned int uint16_t;










typedef long int32_t;




typedef unsigned long uint32_t;










typedef long long int64_t;




typedef unsigned long long uint64_t;
#line 155
typedef int16_t intptr_t;




typedef uint16_t uintptr_t;
# 235 "/usr/lib/ncc/nesc_nx.h"
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
# 213 "/usr/lib/gcc/avr/3.4.3/include/stddef.h" 3
typedef unsigned int size_t;
# 67 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/string.h"
extern void *memcpy(void *, const void *, size_t );

extern void *memset(void *, int , size_t );
# 325 "/usr/lib/gcc/avr/3.4.3/include/stddef.h" 3
typedef int wchar_t;
# 69 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/stdlib.h"
#line 66
typedef struct __nesc_unnamed4242 {
  int quot;
  int rem;
} div_t;





#line 72
typedef struct __nesc_unnamed4243 {
  long quot;
  long rem;
} ldiv_t;


typedef int (*__compar_fn_t)(const void *, const void *);
# 138 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/math.h" 3
extern double sin(double __x) __attribute((const)) ;
# 151 "/usr/lib/gcc/avr/3.4.3/include/stddef.h" 3
typedef int ptrdiff_t;
# 20 "/opt/tinyos-2.x/tos/system/tos.h"
typedef uint8_t bool;
enum __nesc_unnamed4244 {
#line 21
  FALSE = 0, TRUE = 1
};
typedef nx_int8_t nx_bool;
uint16_t TOS_NODE_ID = 1;





struct __nesc_attr_atmostonce {
};
#line 31
struct __nesc_attr_atleastonce {
};
#line 32
struct __nesc_attr_exactlyonce {
};
# 34 "/opt/tinyos-2.x/tos/types/TinyError.h"
enum __nesc_unnamed4245 {
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
# 90 "/usr/lib/gcc/avr/3.4.3/../../../../avr/include/avr/pgmspace.h"
typedef void prog_void __attribute((__progmem__)) ;
typedef char prog_char __attribute((__progmem__)) ;
typedef unsigned char prog_uchar __attribute((__progmem__)) ;

typedef int8_t prog_int8_t __attribute((__progmem__)) ;
typedef uint8_t prog_uint8_t __attribute((__progmem__)) ;
typedef int16_t prog_int16_t __attribute((__progmem__)) ;
typedef uint16_t prog_uint16_t __attribute((__progmem__)) ;

typedef int32_t prog_int32_t __attribute((__progmem__)) ;
typedef uint32_t prog_uint32_t __attribute((__progmem__)) ;


typedef int64_t prog_int64_t __attribute((__progmem__)) ;
typedef uint64_t prog_uint64_t __attribute((__progmem__)) ;
# 25 "/opt/tinyos-2.x/tos/chips/atm128/atm128const.h"
typedef uint8_t const_uint8_t __attribute((__progmem__)) ;
typedef uint16_t const_uint16_t __attribute((__progmem__)) ;
typedef uint32_t const_uint32_t __attribute((__progmem__)) ;
typedef int8_t const_int8_t __attribute((__progmem__)) ;
typedef int16_t const_int16_t __attribute((__progmem__)) ;
typedef int32_t const_int32_t __attribute((__progmem__)) ;
# 82 "/opt/tinyos-2.x/tos/chips/atm128/atm128hardware.h"
static __inline void __nesc_enable_interrupt(void);



static __inline void __nesc_disable_interrupt(void);




typedef uint8_t __nesc_atomic_t;
__nesc_atomic_t __nesc_atomic_start(void );
void __nesc_atomic_end(__nesc_atomic_t original_SREG);









#line 102
__inline __nesc_atomic_t 
__nesc_atomic_start(void )  ;








#line 111
__inline void 
__nesc_atomic_end(__nesc_atomic_t original_SREG)  ;






typedef uint8_t mcu_power_t  ;


enum __nesc_unnamed4246 {
  ATM128_POWER_IDLE = 0, 
  ATM128_POWER_ADC_NR = 1, 
  ATM128_POWER_EXT_STANDBY = 2, 
  ATM128_POWER_SAVE = 3, 
  ATM128_POWER_STANDBY = 4, 
  ATM128_POWER_DOWN = 5
};


static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2);
# 34 "/opt/tinyos-2.x/tos/chips/atm128/adc/Atm128Adc.h"
enum __nesc_unnamed4247 {
  ATM128_ADC_VREF_OFF = 0, 
  ATM128_ADC_VREF_AVCC = 1, 
  ATM128_ADC_VREF_RSVD, 
  ATM128_ADC_VREF_2_56 = 3
};


enum __nesc_unnamed4248 {
  ATM128_ADC_RIGHT_ADJUST = 0, 
  ATM128_ADC_LEFT_ADJUST = 1
};



enum __nesc_unnamed4249 {
  ATM128_ADC_SNGL_ADC0 = 0, 
  ATM128_ADC_SNGL_ADC1, 
  ATM128_ADC_SNGL_ADC2, 
  ATM128_ADC_SNGL_ADC3, 
  ATM128_ADC_SNGL_ADC4, 
  ATM128_ADC_SNGL_ADC5, 
  ATM128_ADC_SNGL_ADC6, 
  ATM128_ADC_SNGL_ADC7, 
  ATM128_ADC_DIFF_ADC00_10x, 
  ATM128_ADC_DIFF_ADC10_10x, 
  ATM128_ADC_DIFF_ADC00_200x, 
  ATM128_ADC_DIFF_ADC10_200x, 
  ATM128_ADC_DIFF_ADC22_10x, 
  ATM128_ADC_DIFF_ADC32_10x, 
  ATM128_ADC_DIFF_ADC22_200x, 
  ATM128_ADC_DIFF_ADC32_200x, 
  ATM128_ADC_DIFF_ADC01_1x, 
  ATM128_ADC_DIFF_ADC11_1x, 
  ATM128_ADC_DIFF_ADC21_1x, 
  ATM128_ADC_DIFF_ADC31_1x, 
  ATM128_ADC_DIFF_ADC41_1x, 
  ATM128_ADC_DIFF_ADC51_1x, 
  ATM128_ADC_DIFF_ADC61_1x, 
  ATM128_ADC_DIFF_ADC71_1x, 
  ATM128_ADC_DIFF_ADC02_1x, 
  ATM128_ADC_DIFF_ADC12_1x, 
  ATM128_ADC_DIFF_ADC22_1x, 
  ATM128_ADC_DIFF_ADC32_1x, 
  ATM128_ADC_DIFF_ADC42_1x, 
  ATM128_ADC_DIFF_ADC52_1x, 
  ATM128_ADC_SNGL_1_23, 
  ATM128_ADC_SNGL_GND
};







#line 85
typedef struct __nesc_unnamed4250 {

  uint8_t mux : 5;
  uint8_t adlar : 1;
  uint8_t refs : 2;
} Atm128Admux_t;




enum __nesc_unnamed4251 {
  ATM128_ADC_PRESCALE_2 = 0, 
  ATM128_ADC_PRESCALE_2b, 
  ATM128_ADC_PRESCALE_4, 
  ATM128_ADC_PRESCALE_8, 
  ATM128_ADC_PRESCALE_16, 
  ATM128_ADC_PRESCALE_32, 
  ATM128_ADC_PRESCALE_64, 
  ATM128_ADC_PRESCALE_128, 



  ATM128_ADC_PRESCALE
};


enum __nesc_unnamed4252 {
  ATM128_ADC_ENABLE_OFF = 0, 
  ATM128_ADC_ENABLE_ON
};


enum __nesc_unnamed4253 {
  ATM128_ADC_START_CONVERSION_OFF = 0, 
  ATM128_ADC_START_CONVERSION_ON
};


enum __nesc_unnamed4254 {
  ATM128_ADC_FREE_RUNNING_OFF = 0, 
  ATM128_ADC_FREE_RUNNING_ON
};


enum __nesc_unnamed4255 {
  ATM128_ADC_INT_FLAG_OFF = 0, 
  ATM128_ADC_INT_FLAG_ON
};


enum __nesc_unnamed4256 {
  ATM128_ADC_INT_ENABLE_OFF = 0, 
  ATM128_ADC_INT_ENABLE_ON
};










#line 141
typedef struct __nesc_unnamed4257 {

  uint8_t adps : 3;
  uint8_t adie : 1;
  uint8_t adif : 1;
  uint8_t adfr : 1;
  uint8_t adsc : 1;
  uint8_t aden : 1;
} Atm128Adcsra_t;

typedef uint8_t Atm128_ADCH_t;
typedef uint8_t Atm128_ADCL_t;
# 29 "/opt/tinyos-2.x/tos/lib/timer/Timer.h"
typedef struct __nesc_unnamed4258 {
} 
#line 29
TMilli;
typedef struct __nesc_unnamed4259 {
} 
#line 30
T32khz;
typedef struct __nesc_unnamed4260 {
} 
#line 31
TMicro;
# 43 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128Timer.h"
enum __nesc_unnamed4261 {
  ATM128_CLK8_OFF = 0x0, 
  ATM128_CLK8_NORMAL = 0x1, 
  ATM128_CLK8_DIVIDE_8 = 0x2, 
  ATM128_CLK8_DIVIDE_32 = 0x3, 
  ATM128_CLK8_DIVIDE_64 = 0x4, 
  ATM128_CLK8_DIVIDE_128 = 0x5, 
  ATM128_CLK8_DIVIDE_256 = 0x6, 
  ATM128_CLK8_DIVIDE_1024 = 0x7
};

enum __nesc_unnamed4262 {
  ATM128_CLK16_OFF = 0x0, 
  ATM128_CLK16_NORMAL = 0x1, 
  ATM128_CLK16_DIVIDE_8 = 0x2, 
  ATM128_CLK16_DIVIDE_64 = 0x3, 
  ATM128_CLK16_DIVIDE_256 = 0x4, 
  ATM128_CLK16_DIVIDE_1024 = 0x5, 
  ATM128_CLK16_EXTERNAL_FALL = 0x6, 
  ATM128_CLK16_EXTERNAL_RISE = 0x7
};


enum __nesc_unnamed4263 {
  AVR_CLOCK_OFF = 0, 
  AVR_CLOCK_ON = 1, 
  AVR_CLOCK_DIVIDE_8 = 2
};


enum __nesc_unnamed4264 {
  ATM128_WAVE8_NORMAL = 0, 
  ATM128_WAVE8_PWM, 
  ATM128_WAVE8_CTC, 
  ATM128_WAVE8_PWM_FAST
};


enum __nesc_unnamed4265 {
  ATM128_COMPARE_OFF = 0, 
  ATM128_COMPARE_TOGGLE, 
  ATM128_COMPARE_CLEAR, 
  ATM128_COMPARE_SET
};
#line 99
#line 89
typedef union __nesc_unnamed4266 {

  uint8_t flat;
  struct __nesc_unnamed4267 {
    uint8_t cs : 3;
    uint8_t wgm1 : 1;
    uint8_t com : 2;
    uint8_t wgm0 : 1;
    uint8_t foc : 1;
  } bits;
} Atm128TimerControl_t;

typedef Atm128TimerControl_t Atm128_TCCR0_t;
typedef uint8_t Atm128_TCNT0_t;
typedef uint8_t Atm128_OCR0_t;

typedef Atm128TimerControl_t Atm128_TCCR2_t;
typedef uint8_t Atm128_TCNT2_t;
typedef uint8_t Atm128_OCR2_t;
#line 121
#line 111
typedef union __nesc_unnamed4268 {

  uint8_t flat;
  struct __nesc_unnamed4269 {
    uint8_t tcr0ub : 1;
    uint8_t ocr0ub : 1;
    uint8_t tcn0ub : 1;
    uint8_t as0 : 1;
    uint8_t rsvd : 4;
  } bits;
} Atm128Assr_t;
#line 137
#line 124
typedef union __nesc_unnamed4270 {

  uint8_t flat;
  struct __nesc_unnamed4271 {
    uint8_t toie0 : 1;
    uint8_t ocie0 : 1;
    uint8_t toie1 : 1;
    uint8_t ocie1b : 1;
    uint8_t ocie1a : 1;
    uint8_t ticie1 : 1;
    uint8_t toie2 : 1;
    uint8_t ocie2 : 1;
  } bits;
} Atm128_TIMSK_t;
#line 154
#line 141
typedef union __nesc_unnamed4272 {

  uint8_t flat;
  struct __nesc_unnamed4273 {
    uint8_t tov0 : 1;
    uint8_t ocf0 : 1;
    uint8_t tov1 : 1;
    uint8_t ocf1b : 1;
    uint8_t ocf1a : 1;
    uint8_t icf1 : 1;
    uint8_t tov2 : 1;
    uint8_t ocf2 : 1;
  } bits;
} Atm128_TIFR_t;
#line 169
#line 158
typedef union __nesc_unnamed4274 {

  uint8_t flat;
  struct __nesc_unnamed4275 {
    uint8_t psr321 : 1;
    uint8_t psr0 : 1;
    uint8_t pud : 1;
    uint8_t acme : 1;
    uint8_t rsvd : 3;
    uint8_t tsm : 1;
  } bits;
} Atm128_SFIOR_t;






enum __nesc_unnamed4276 {
  ATM128_TIMER_COMPARE_NORMAL = 0, 
  ATM128_TIMER_COMPARE_TOGGLE, 
  ATM128_TIMER_COMPARE_CLEAR, 
  ATM128_TIMER_COMPARE_SET
};
#line 193
#line 184
typedef union __nesc_unnamed4277 {

  uint8_t flat;
  struct __nesc_unnamed4278 {
    uint8_t wgm10 : 2;
    uint8_t comC : 2;
    uint8_t comB : 2;
    uint8_t comA : 2;
  } bits;
} Atm128TimerCtrlCompare_t;


typedef Atm128TimerCtrlCompare_t Atm128_TCCR1A_t;


typedef Atm128TimerCtrlCompare_t Atm128_TCCR3A_t;


enum __nesc_unnamed4279 {
  ATM128_WAVE16_NORMAL = 0, 
  ATM128_WAVE16_PWM_8BIT, 
  ATM128_WAVE16_PWM_9BIT, 
  ATM128_WAVE16_PWM_10BIT, 
  ATM128_WAVE16_CTC_COMPARE, 
  ATM128_WAVE16_PWM_FAST_8BIT, 
  ATM128_WAVE16_PWM_FAST_9BIT, 
  ATM128_WAVE16_PWM_FAST_10BIT, 
  ATM128_WAVE16_PWM_CAPTURE_LOW, 
  ATM128_WAVE16_PWM_COMPARE_LOW, 
  ATM128_WAVE16_PWM_CAPTURE_HIGH, 
  ATM128_WAVE16_PWM_COMPARE_HIGH, 
  ATM128_WAVE16_CTC_CAPTURE, 
  ATM128_WAVE16_RESERVED, 
  ATM128_WAVE16_PWM_FAST_CAPTURE, 
  ATM128_WAVE16_PWM_FAST_COMPARE
};
#line 232
#line 222
typedef union __nesc_unnamed4280 {

  uint8_t flat;
  struct __nesc_unnamed4281 {
    uint8_t cs : 3;
    uint8_t wgm32 : 2;
    uint8_t rsvd : 1;
    uint8_t ices1 : 1;
    uint8_t icnc1 : 1;
  } bits;
} Atm128TimerCtrlCapture_t;


typedef Atm128TimerCtrlCapture_t Atm128_TCCR1B_t;


typedef Atm128TimerCtrlCapture_t Atm128_TCCR3B_t;
#line 250
#line 241
typedef union __nesc_unnamed4282 {

  uint8_t flat;
  struct __nesc_unnamed4283 {
    uint8_t rsvd : 5;
    uint8_t focC : 1;
    uint8_t focB : 1;
    uint8_t focA : 1;
  } bits;
} Atm128TimerCtrlClock_t;


typedef Atm128TimerCtrlClock_t Atm128_TCCR1C_t;


typedef Atm128TimerCtrlClock_t Atm128_TCCR3C_t;



typedef uint8_t Atm128_TCNT1H_t;
typedef uint8_t Atm128_TCNT1L_t;
typedef uint8_t Atm128_TCNT3H_t;
typedef uint8_t Atm128_TCNT3L_t;


typedef uint8_t Atm128_OCR1AH_t;
typedef uint8_t Atm128_OCR1AL_t;
typedef uint8_t Atm128_OCR1BH_t;
typedef uint8_t Atm128_OCR1BL_t;
typedef uint8_t Atm128_OCR1CH_t;
typedef uint8_t Atm128_OCR1CL_t;


typedef uint8_t Atm128_OCR3AH_t;
typedef uint8_t Atm128_OCR3AL_t;
typedef uint8_t Atm128_OCR3BH_t;
typedef uint8_t Atm128_OCR3BL_t;
typedef uint8_t Atm128_OCR3CH_t;
typedef uint8_t Atm128_OCR3CL_t;


typedef uint8_t Atm128_ICR1H_t;
typedef uint8_t Atm128_ICR1L_t;
typedef uint8_t Atm128_ICR3H_t;
typedef uint8_t Atm128_ICR3L_t;
#line 300
#line 288
typedef union __nesc_unnamed4284 {

  uint8_t flat;
  struct __nesc_unnamed4285 {
    uint8_t ocie1c : 1;
    uint8_t ocie3c : 1;
    uint8_t toie3 : 1;
    uint8_t ocie3b : 1;
    uint8_t ocie3a : 1;
    uint8_t ticie3 : 1;
    uint8_t rsvd : 2;
  } bits;
} Atm128_ETIMSK_t;
#line 315
#line 303
typedef union __nesc_unnamed4286 {

  uint8_t flat;
  struct __nesc_unnamed4287 {
    uint8_t ocf1c : 1;
    uint8_t ocf3c : 1;
    uint8_t tov3 : 1;
    uint8_t ocf3b : 1;
    uint8_t ocf3a : 1;
    uint8_t icf3 : 1;
    uint8_t rsvd : 2;
  } bits;
} Atm128_ETIFR_t;
# 52 "/opt/tinyos-2.x/tos/platforms/aquisgrain/AGtimer.h"
typedef struct __nesc_unnamed4288 {
} 
#line 52
T64khz;
typedef struct __nesc_unnamed4289 {
} 
#line 53
T128khz;
typedef struct __nesc_unnamed4290 {
} 
#line 54
T2mhz;
typedef struct __nesc_unnamed4291 {
} 
#line 55
T4mhz;
#line 108
typedef T32khz TOne;
typedef TMicro TThree;
typedef uint16_t counter_one_overflow_t;
typedef uint16_t counter_three_overflow_t;

enum __nesc_unnamed4292 {
  AG_PRESCALER_ONE = ATM128_CLK16_DIVIDE_256, 
  AG_DIVIDE_ONE_FOR_32KHZ_LOG2 = 0, 
  AG_PRESCALER_THREE = ATM128_CLK16_DIVIDE_8, 
  AG_DIVIDE_THREE_FOR_MICRO_LOG2 = 0, 
  EXT_STANDBY_T0_THRESHOLD = 12
};





enum __nesc_unnamed4293 {
  PLATFORM_MHZ = 8
};
# 16 "/opt/tinyos-2.x/tos/platforms/aquisgrain/hardware.h"
enum __nesc_unnamed4294 {
  PLATFORM_BAUDRATE = 57600L
};
# 6 "/opt/tinyos-2.x/tos/types/AM.h"
typedef nx_uint8_t nx_am_id_t;
typedef nx_uint8_t nx_am_group_t;
typedef nx_uint16_t nx_am_addr_t;

typedef uint8_t am_id_t;
typedef uint8_t am_group_t;
typedef uint16_t am_addr_t;

enum __nesc_unnamed4295 {
  AM_BROADCAST_ADDR = 0xffff
};









enum __nesc_unnamed4296 {
  TOS_AM_GROUP = 0x22, 
  TOS_AM_ADDRESS = 1
};
# 10 "./Octopus.h"
enum __nesc_unnamed4297 {
  AM_OCTOPUS_COLLECTED_MSG = 0x93, 
  AM_OCTOPUS_BROADCAST_MSG = 0x71, 
  AM_OCTOPUS_SENT_MSG = 0x65, 
  NO_REPLY = 0x00, 
  BATTERY_AND_MODE_REPLY = 0x20, 
  PERIOD_REPLY = 0x40, 
  THRESHOLD_REPLY = 0x60, 
  SLEEP_DUTY_CYCLE_REPLY = 0x80, 
  AWAKE_DUTY_CYCLE_REPLY = 0xA0, 
  REPLY_MASK = 0xE0, 
  MODE_MASK = 0x01, 
  SLEEP_MASK = 0x02, 
  SLEEPING = 0x02, 
  AWAKE = 0x00, 
  SET_MODE_AUTO_REQUEST = 1, 
  SET_MODE_QUERY_REQUEST = 2, 
  SET_PERIOD_REQUEST = 3, 
  SET_THRESHOLD_REQUEST = 4, 
  GET_STATUS_REQUEST = 5, 
  SLEEP_REQUEST = 6, 
  WAKE_UP_REQUEST = 7, 
  GET_PERIOD_REQUEST = 8, 
  GET_THRESHOLD_REQUEST = 9, 
  GET_READING_REQUEST = 10, 
  GET_SLEEP_DUTY_CYCLE_REQUEST = 11, 
  GET_AWAKE_DUTY_CYCLE_REQUEST = 12, 
  SET_SLEEP_DUTY_CYCLE_REQUEST = 13, 
  SET_AWAKE_DUTY_CYCLE_REQUEST = 14, 
  BROADCAST_DIS_KEY = 42, 
  MODE_AUTO = 1, 
  MODE_QUERY = 0
};
# 57 "./OctopusConfig.h"
enum __nesc_unnamed4298 {
  DEFAULT_SAMPLING_PERIOD = 1024, 
  MINIMUM_SAMPLING_PERIOD = 1024, 
  DEFAULT_THRESHOLD = 0, 
  DEFAULT_MODE = MODE_AUTO, 
  DEFAULT_SLEEP_DUTY_CYCLE = 2000, 
  DEFAULT_AWAKE_DUTY_CYCLE = 9000
};
# 57 "./Octopus.h"
#line 50
typedef nx_struct octopus_collected_msg {
  nx_am_addr_t moteId;
  nx_uint16_t count;
  nx_uint16_t reading;
  nx_uint16_t quality;
  nx_am_addr_t parentId;
  nx_uint8_t reply;
} __attribute__((packed)) octopus_collected_msg_t;
#line 93
#line 89
typedef nx_struct octopus_sent_msg {
  nx_am_addr_t targetId;
  nx_uint8_t request;
  nx_uint16_t parameters;
} __attribute__((packed)) octopus_sent_msg_t;
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420.h"
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
enum __nesc_unnamed4299 {

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
  CC2420_SRXENC = 0x0d, 
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
# 72 "/opt/tinyos-2.x/tos/lib/serial/Serial.h"
typedef uint8_t uart_id_t;



enum __nesc_unnamed4300 {
  HDLC_FLAG_BYTE = 0x7e, 
  HDLC_CTLESC_BYTE = 0x7d
};



enum __nesc_unnamed4301 {
  TOS_SERIAL_ACTIVE_MESSAGE_ID = 0, 
  TOS_SERIAL_CC1000_ID = 1, 
  TOS_SERIAL_802_15_4_ID = 2, 
  TOS_SERIAL_UNKNOWN_ID = 255
};


enum __nesc_unnamed4302 {
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
# 49 "/opt/tinyos-2.x/tos/platforms/aquisgrain/platform_message.h"
#line 46
typedef union message_header {
  cc2420_header_t cc2420;
  serial_header_t serial;
} message_header_t;



#line 51
typedef union message_footer {
  cc2420_footer_t cc2420;
} message_footer_t;



#line 55
typedef union message_metadata {
  cc2420_metadata_t cc2420;
} message_metadata_t;
# 19 "/opt/tinyos-2.x/tos/types/message.h"
#line 14
typedef nx_struct message_t {
  nx_uint8_t header[sizeof(message_header_t )];
  nx_uint8_t data[28];
  nx_uint8_t footer[sizeof(message_footer_t )];
  nx_uint8_t metadata[sizeof(message_metadata_t )];
} __attribute__((packed)) message_t;
# 30 "/opt/tinyos-2.x/tos/types/Leds.h"
enum __nesc_unnamed4303 {
  LEDS_LED0 = 1 << 0, 
  LEDS_LED1 = 1 << 1, 
  LEDS_LED2 = 1 << 2, 
  LEDS_LED3 = 1 << 3, 
  LEDS_LED4 = 1 << 4, 
  LEDS_LED5 = 1 << 5, 
  LEDS_LED6 = 1 << 6, 
  LEDS_LED7 = 1 << 7
};
# 39 "/opt/tinyos-2.x/tos/chips/atm128/crc.h"
uint16_t crcTable[256] __attribute((__progmem__))  = { 
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









static uint16_t crcByte(uint16_t oldCrc, uint8_t byte) __attribute((noinline)) ;
# 32 "/opt/tinyos-2.x/tos/chips/atm128/Atm128Uart.h"
typedef uint8_t Atm128_UDR0_t;
typedef uint8_t Atm128_UDR1_t;
#line 48
#line 36
typedef union __nesc_unnamed4304 {
  struct Atm128_UCSRA_t {
    uint8_t mpcm : 1;
    uint8_t u2x : 1;
    uint8_t upe : 1;
    uint8_t dor : 1;
    uint8_t fe : 1;
    uint8_t udre : 1;
    uint8_t txc : 1;
    uint8_t rxc : 1;
  } bits;
  uint8_t flat;
} Atm128UartStatus_t;

typedef Atm128UartStatus_t Atm128_UCSR0A_t;
typedef Atm128UartStatus_t Atm128_UCSR1A_t;
#line 66
#line 54
typedef union __nesc_unnamed4305 {
  struct Atm128_UCSRB_t {
    uint8_t txb8 : 1;
    uint8_t rxb8 : 1;
    uint8_t ucsz2 : 1;
    uint8_t txen : 1;
    uint8_t rxen : 1;
    uint8_t udrie : 1;
    uint8_t txcie : 1;
    uint8_t rxcie : 1;
  } bits;
  uint8_t flat;
} Atm128UartControl_t;

typedef Atm128UartControl_t Atm128_UCSR0B_t;
typedef Atm128UartControl_t Atm128_UCSR1B_t;

enum __nesc_unnamed4306 {
  ATM128_UART_DATA_SIZE_5_BITS = 0, 
  ATM128_UART_DATA_SIZE_6_BITS = 1, 
  ATM128_UART_DATA_SIZE_7_BITS = 2, 
  ATM128_UART_DATA_SIZE_8_BITS = 3
};
#line 89
#line 79
typedef union __nesc_unnamed4307 {
  uint8_t flat;
  struct Atm128_UCSRC_t {
    uint8_t ucpol : 1;
    uint8_t ucsz : 2;
    uint8_t usbs : 1;
    uint8_t upm : 2;
    uint8_t umsel : 1;
    uint8_t rsvd : 1;
  } bits;
} Atm128UartMode_t;

typedef Atm128UartMode_t Atm128_UCSR0C_t;
typedef Atm128UartMode_t Atm128_UCSR1C_t;





enum __nesc_unnamed4308 {
  ATM128_19200_BAUD_4MHZ = 12, 
  ATM128_38400_BAUD_4MHZ = 6, 
  ATM128_57600_BAUD_4MHZ = 3, 

  ATM128_19200_BAUD_4MHZ_2X = 25, 
  ATM128_38400_BAUD_4MHZ_2X = 12, 
  ATM128_57600_BAUD_4MHZ_2X = 8, 

  ATM128_19200_BAUD_7MHZ = 23, 
  ATM128_38400_BAUD_7MHZ = 11, 
  ATM128_57600_BAUD_7MHZ = 7, 

  ATM128_19200_BAUD_7MHZ_2X = 47, 
  ATM128_38400_BAUD_7MHZ_2X = 23, 
  ATM128_57600_BAUD_7MHZ_2X = 15, 

  ATM128_19200_BAUD_8MHZ = 25, 
  ATM128_38400_BAUD_8MHZ = 12, 
  ATM128_57600_BAUD_8MHZ = 8, 

  ATM128_19200_BAUD_8MHZ_2X = 51, 
  ATM128_38400_BAUD_8MHZ_2X = 34, 
  ATM128_57600_BAUD_8MHZ_2X = 11
};

typedef uint8_t Atm128_UBRR0L_t;
typedef uint8_t Atm128_UBRR0H_t;

typedef uint8_t Atm128_UBRR1L_t;
typedef uint8_t Atm128_UBRR1H_t;
# 38 "/opt/tinyos-2.x/tos/chips/cc2420/IEEE802154.h"
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
# 32 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.h"
enum __nesc_unnamed4309 {
  ATM128_SPI_CLK_DIVIDE_4 = 0, 
  ATM128_SPI_CLK_DIVIDE_16 = 1, 
  ATM128_SPI_CLK_DIVIDE_64 = 2, 
  ATM128_SPI_CLK_DIVIDE_128 = 3
};
#line 49
#line 40
typedef struct __nesc_unnamed4310 {
  uint8_t spie : 1;
  uint8_t spe : 1;
  uint8_t dord : 1;
  uint8_t mstr : 1;
  uint8_t cpol : 1;
  uint8_t cpha : 1;
  uint8_t spr : 2;
} 
Atm128SPIControl_s;



#line 50
typedef union __nesc_unnamed4311 {
  uint8_t flat;
  Atm128SPIControl_s bits;
} Atm128SPIControl_t;

typedef Atm128SPIControl_t Atm128_SPCR_t;








#line 58
typedef struct __nesc_unnamed4312 {
  uint8_t spif : 1;
  uint8_t wcol : 1;
  uint8_t rsvd : 5;
  uint8_t spi2x : 1;
} 
Atm128SPIStatus_s;



#line 65
typedef union __nesc_unnamed4313 {
  uint8_t flat;
  Atm128SPIStatus_s bits;
} Atm128SPIStatus_t;

typedef Atm128SPIStatus_t Atm128_SPSR_t;

typedef uint8_t Atm128_SPDR_t;
# 33 "/opt/tinyos-2.x/tos/types/Resource.h"
typedef uint8_t resource_client_id_t;
# 31 "/opt/tinyos-2.x/tos/lib/net/ctp/Collection.h"
enum __nesc_unnamed4314 {
  AM_COLLECTION_DATA = 20, 
  AM_COLLECTION_CONTROL = 21, 
  AM_COLLECTION_DEBUG = 22
};

typedef uint8_t collection_id_t;
typedef nx_uint8_t nx_collection_id_t;
# 51 "/opt/tinyos-2.x/tos/lib/net/ctp/Ctp.h"
enum __nesc_unnamed4315 {

  AM_CTP_DATA = 23, 
  AM_CTP_ROUTING = 24, 
  AM_CTP_DEBUG = 25, 


  CTP_OPT_PULL = 0x80, 
  CTP_OPT_ECN = 0x40
};

typedef nx_uint8_t nx_ctp_options_t;
typedef uint8_t ctp_options_t;









#line 65
typedef nx_struct __nesc_unnamed4316 {
  nx_ctp_options_t options;
  nx_uint8_t thl;
  nx_uint16_t etx;
  nx_am_addr_t origin;
  nx_uint8_t originSeqNo;
  nx_collection_id_t type;
  nx_uint8_t data[0];
} __attribute__((packed)) ctp_data_header_t;






#line 75
typedef nx_struct __nesc_unnamed4317 {
  nx_ctp_options_t options;
  nx_am_addr_t parent;
  nx_uint16_t etx;
  nx_uint8_t data[0];
} __attribute__((packed)) ctp_routing_header_t;
# 60 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngine.h"
enum __nesc_unnamed4318 {



  FORWARD_PACKET_TIME = 32
};


enum __nesc_unnamed4319 {
  SENDDONE_FAIL_OFFSET = 512, 
  SENDDONE_NOACK_OFFSET = FORWARD_PACKET_TIME << 2, 
  SENDDONE_OK_OFFSET = FORWARD_PACKET_TIME << 2, 
  LOOPY_OFFSET = FORWARD_PACKET_TIME << 4, 
  SENDDONE_FAIL_WINDOW = SENDDONE_FAIL_OFFSET - 1, 
  LOOPY_WINDOW = LOOPY_OFFSET - 1, 
  SENDDONE_NOACK_WINDOW = SENDDONE_NOACK_OFFSET - 1, 
  SENDDONE_OK_WINDOW = SENDDONE_OK_OFFSET - 1, 
  CONGESTED_WAIT_OFFSET = FORWARD_PACKET_TIME << 2, 
  CONGESTED_WAIT_WINDOW = CONGESTED_WAIT_OFFSET - 1
};








enum __nesc_unnamed4320 {
  MAX_RETRIES = 30
};
#line 103
#line 97
typedef nx_struct __nesc_unnamed4321 {
  nx_uint8_t control;
  nx_am_addr_t origin;
  nx_uint8_t seqno;
  nx_uint8_t collectid;
  nx_uint16_t gradient;
} __attribute__((packed)) network_header_t;
#line 116
#line 112
typedef struct __nesc_unnamed4322 {
  message_t *msg;
  uint8_t client;
  uint8_t retries;
} fe_queue_entry_t;
# 7 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpDebugMsg.h"
enum __nesc_unnamed4323 {
  NET_C_DEBUG_STARTED = 0xDE, 

  NET_C_FE_MSG_POOL_EMPTY = 0x10, 
  NET_C_FE_SEND_QUEUE_FULL = 0x11, 
  NET_C_FE_NO_ROUTE = 0x12, 
  NET_C_FE_SUBSEND_OFF = 0x13, 
  NET_C_FE_SUBSEND_BUSY = 0x14, 
  NET_C_FE_BAD_SENDDONE = 0x15, 
  NET_C_FE_QENTRY_POOL_EMPTY = 0x16, 
  NET_C_FE_SUBSEND_SIZE = 0x17, 
  NET_C_FE_LOOP_DETECTED = 0x18, 
  NET_C_FE_SEND_BUSY = 0x19, 

  NET_C_FE_SENDQUEUE_EMPTY = 0x50, 
  NET_C_FE_PUT_MSGPOOL_ERR = 0x51, 
  NET_C_FE_PUT_QEPOOL_ERR = 0x52, 
  NET_C_FE_GET_MSGPOOL_ERR = 0x53, 
  NET_C_FE_GET_QEPOOL_ERR = 0x54, 
  NET_C_FE_QUEUE_SIZE = 0x55, 

  NET_C_FE_SENT_MSG = 0x20, 
  NET_C_FE_RCV_MSG = 0x21, 
  NET_C_FE_FWD_MSG = 0x22, 
  NET_C_FE_DST_MSG = 0x23, 
  NET_C_FE_SENDDONE_FAIL = 0x24, 
  NET_C_FE_SENDDONE_WAITACK = 0x25, 
  NET_C_FE_SENDDONE_FAIL_ACK_SEND = 0x26, 
  NET_C_FE_SENDDONE_FAIL_ACK_FWD = 0x27, 
  NET_C_FE_DUPLICATE_CACHE = 0x28, 
  NET_C_FE_DUPLICATE_QUEUE = 0x29, 
  NET_C_FE_DUPLICATE_CACHE_AT_SEND = 0x2A, 
  NET_C_FE_CONGESTION_SENDWAIT = 0x2B, 
  NET_C_FE_CONGESTION_BEGIN = 0x2C, 
  NET_C_FE_CONGESTION_END = 0x2D, 



  NET_C_FE_CONGESTED = 0x2E, 

  NET_C_TREE_NO_ROUTE = 0x30, 
  NET_C_TREE_NEW_PARENT = 0x31, 
  NET_C_TREE_ROUTE_INFO = 0x32, 
  NET_C_TREE_SENT_BEACON = 0x33, 
  NET_C_TREE_RCV_BEACON = 0x34, 

  NET_C_DBG_1 = 0x40, 
  NET_C_DBG_2 = 0x41, 
  NET_C_DBG_3 = 0x42
};
#line 79
#line 58
typedef nx_struct CollectionDebugMsg {
  nx_uint8_t type;
  nx_union __nesc_unnamed4324 {
    nx_uint16_t arg;
    nx_struct __nesc_unnamed4325 {
      nx_uint16_t msg_uid;
      nx_am_addr_t origin;
      nx_am_addr_t other_node;
    } __attribute__((packed)) msg;
    nx_struct __nesc_unnamed4326 {
      nx_am_addr_t parent;
      nx_uint8_t hopcount;
      nx_uint16_t metric;
    } __attribute__((packed)) route_info;
    nx_struct __nesc_unnamed4327 {
      nx_uint16_t a;
      nx_uint16_t b;
      nx_uint16_t c;
    } __attribute__((packed)) dbg;
  } __attribute__((packed)) data;
  nx_uint16_t seqno;
} __attribute__((packed)) CollectionDebugMsg;
# 38 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.h"
enum __nesc_unnamed4328 {


  NUM_ENTRIES_FLAG = 15
};
#line 54
#line 51
typedef nx_struct linkest_header {
  nx_uint8_t flags;
  nx_uint8_t seq;
} __attribute__((packed)) linkest_header_t;







#line 59
typedef nx_struct neighbor_stat_entry {
  nx_am_addr_t ll_addr;
  nx_uint8_t inquality;
} __attribute__((packed)) neighbor_stat_entry_t;




#line 65
typedef nx_struct linkest_footer {
  neighbor_stat_entry_t neighborList[1];
} __attribute__((packed)) linkest_footer_t;



enum __nesc_unnamed4329 {
  VALID_ENTRY = 0x1, 


  MATURE_ENTRY = 0x2, 


  INIT_ENTRY = 0x4, 


  PINNED_ENTRY = 0x8
};
#line 118
#line 86
typedef struct neighbor_table_entry {

  am_addr_t ll_addr;

  uint8_t lastseq;


  uint8_t rcvcnt;

  uint8_t failcnt;

  uint8_t flags;


  uint8_t inage;


  uint8_t outage;


  uint8_t inquality;
  uint8_t outquality;


  uint16_t eetx;



  uint8_t data_success;


  uint8_t data_total;
} neighbor_table_entry_t;
# 4 "/opt/tinyos-2.x/tos/lib/net/ctp/TreeRouting.h"
enum __nesc_unnamed4330 {
  AM_TREE_ROUTING_CONTROL = 0xCE, 
  BEACON_INTERVAL = 8192, 
  INVALID_ADDR = 0xFFFF, 
  ETX_THRESHOLD = 50, 
  PARENT_SWITCH_THRESHOLD = 15, 
  MAX_METRIC = 0xFFFF
};







#line 14
typedef struct __nesc_unnamed4331 {
  am_addr_t parent;
  uint16_t etx;
  bool haveHeard;
  bool congested;
} route_info_t;




#line 21
typedef struct __nesc_unnamed4332 {
  am_addr_t neighbor;
  route_info_t info;
} routing_table_entry;

static __inline void routeInfoInit(route_info_t *ri);
# 40 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngine.h"
enum __nesc_unnamed4333 {
  AM_DISSEMINATION_MESSAGE = 13, 
  AM_DISSEMINATION_PROBE_MESSAGE = 14, 
  DISSEMINATION_SEQNO_UNKNOWN = 0
};





#line 46
typedef nx_struct dissemination_message {
  nx_uint16_t key;
  nx_uint32_t seqno;
  nx_uint8_t data[0];
} __attribute__((packed)) dissemination_message_t;



#line 52
typedef nx_struct dissemination_probe_message {
  nx_uint16_t key;
} __attribute__((packed)) dissemination_probe_message_t;
typedef uint16_t OctopusC$Read$val_t;
typedef octopus_sent_msg_t OctopusC$RequestUpdate$t;
typedef octopus_sent_msg_t OctopusC$RequestValue$t;
typedef TMilli OctopusC$Timer$precision_tag;
enum HilTimerMilliC$__nesc_unnamed4334 {
  HilTimerMilliC$TIMER_COUNT = 8U
};
typedef TMilli /*AlarmCounterMilliP.Atm128AlarmAsyncC*/Atm128AlarmAsyncC$0$precision;
typedef /*AlarmCounterMilliP.Atm128AlarmAsyncC*/Atm128AlarmAsyncC$0$precision /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$precision;
typedef /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$precision /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$precision_tag;
typedef uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$size_type;
typedef /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$precision /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$precision_tag;
typedef uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$size_type;
typedef uint8_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$size_type;
typedef uint8_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$timer_size;
typedef uint8_t HplAtm128Timer0AsyncP$Compare$size_type;
typedef uint8_t HplAtm128Timer0AsyncP$Timer$timer_size;
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
typedef uint16_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$val_t;
typedef uint16_t RandomMlcgP$SeedInit$parameter;
typedef TMicro /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$precision_tag;
typedef uint32_t /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$size_type;
typedef uint16_t HplAtm128Timer3P$CompareA$size_type;
typedef uint16_t HplAtm128Timer3P$Capture$size_type;
typedef uint16_t HplAtm128Timer3P$CompareB$size_type;
typedef uint16_t HplAtm128Timer3P$CompareC$size_type;
typedef uint16_t HplAtm128Timer3P$Timer$timer_size;
typedef uint16_t /*InitThreeP.InitThree*/Atm128TimerInitC$0$timer_size;
typedef /*InitThreeP.InitThree*/Atm128TimerInitC$0$timer_size /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$timer_size;
typedef TThree /*CounterThree16C.NCounter*/Atm128CounterC$0$frequency_tag;
typedef uint16_t /*CounterThree16C.NCounter*/Atm128CounterC$0$timer_size;
typedef /*CounterThree16C.NCounter*/Atm128CounterC$0$frequency_tag /*CounterThree16C.NCounter*/Atm128CounterC$0$Counter$precision_tag;
typedef /*CounterThree16C.NCounter*/Atm128CounterC$0$timer_size /*CounterThree16C.NCounter*/Atm128CounterC$0$Counter$size_type;
typedef /*CounterThree16C.NCounter*/Atm128CounterC$0$timer_size /*CounterThree16C.NCounter*/Atm128CounterC$0$Timer$timer_size;
typedef TMicro /*CounterMicro32C.Transform32*/TransformCounterC$0$to_precision_tag;
typedef uint32_t /*CounterMicro32C.Transform32*/TransformCounterC$0$to_size_type;
typedef TThree /*CounterMicro32C.Transform32*/TransformCounterC$0$from_precision_tag;
typedef uint16_t /*CounterMicro32C.Transform32*/TransformCounterC$0$from_size_type;
typedef counter_three_overflow_t /*CounterMicro32C.Transform32*/TransformCounterC$0$upper_count_type;
typedef /*CounterMicro32C.Transform32*/TransformCounterC$0$from_precision_tag /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$precision_tag;
typedef /*CounterMicro32C.Transform32*/TransformCounterC$0$from_size_type /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$size_type;
typedef /*CounterMicro32C.Transform32*/TransformCounterC$0$to_precision_tag /*CounterMicro32C.Transform32*/TransformCounterC$0$Counter$precision_tag;
typedef /*CounterMicro32C.Transform32*/TransformCounterC$0$to_size_type /*CounterMicro32C.Transform32*/TransformCounterC$0$Counter$size_type;
enum SerialAMQueueP$__nesc_unnamed4335 {
  SerialAMQueueP$NUM_CLIENTS = 1U
};
typedef T32khz CC2420ControlP$StartupTimer$precision_tag;
typedef uint32_t CC2420ControlP$StartupTimer$size_type;
typedef uint16_t CC2420ControlP$ReadRssi$val_t;
typedef uint16_t HplAtm128Timer1P$CompareA$size_type;
typedef uint16_t HplAtm128Timer1P$Capture$size_type;
typedef uint16_t HplAtm128Timer1P$CompareB$size_type;
typedef uint16_t HplAtm128Timer1P$CompareC$size_type;
typedef uint16_t HplAtm128Timer1P$Timer$timer_size;
typedef TOne /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$frequency_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$frequency_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$timer_size;
enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16*/AlarmOne16C$0$__nesc_unnamed4336 {
  AlarmOne16C$0$COMPARE_ID = 0U
};
typedef uint16_t /*InitOneP.InitOne*/Atm128TimerInitC$1$timer_size;
typedef /*InitOneP.InitOne*/Atm128TimerInitC$1$timer_size /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$timer_size;
typedef TOne /*CounterOne16C.NCounter*/Atm128CounterC$1$frequency_tag;
typedef uint16_t /*CounterOne16C.NCounter*/Atm128CounterC$1$timer_size;
typedef /*CounterOne16C.NCounter*/Atm128CounterC$1$frequency_tag /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$precision_tag;
typedef /*CounterOne16C.NCounter*/Atm128CounterC$1$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$size_type;
typedef /*CounterOne16C.NCounter*/Atm128CounterC$1$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$timer_size;
typedef T32khz /*Counter32khz32C.Transform32*/TransformCounterC$1$to_precision_tag;
typedef uint32_t /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type;
typedef T32khz /*Counter32khz32C.Transform32*/TransformCounterC$1$from_precision_tag;
typedef uint16_t /*Counter32khz32C.Transform32*/TransformCounterC$1$from_size_type;
typedef counter_one_overflow_t /*Counter32khz32C.Transform32*/TransformCounterC$1$upper_count_type;
typedef /*Counter32khz32C.Transform32*/TransformCounterC$1$from_precision_tag /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$precision_tag;
typedef /*Counter32khz32C.Transform32*/TransformCounterC$1$from_size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$size_type;
typedef /*Counter32khz32C.Transform32*/TransformCounterC$1$to_precision_tag /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$precision_tag;
typedef /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$size_type;
typedef T32khz /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_precision_tag;
typedef uint32_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type;
typedef TOne /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_precision_tag;
typedef uint16_t /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$size_type;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_precision_tag /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$precision_tag;
typedef /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$size_type;
typedef uint16_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$size_type;
typedef TMilli HplCC2420InterruptsP$CCATimer$precision_tag;
enum /*CC2420ControlC.Spi*/CC2420SpiC$0$__nesc_unnamed4337 {
  CC2420SpiC$0$CLIENT_ID = 0U
};
enum /*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$__nesc_unnamed4338 {
  CC2420SpiC$1$CLIENT_ID = 1U
};
enum /*CC2420ControlC.RssiResource*/CC2420SpiC$2$__nesc_unnamed4339 {
  CC2420SpiC$2$CLIENT_ID = 2U
};
typedef T32khz CC2420TransmitP$BackoffTimer$precision_tag;
typedef uint32_t CC2420TransmitP$BackoffTimer$size_type;
typedef TMilli CC2420TransmitP$LplDisableTimer$precision_tag;
enum /*CC2420TransmitC.Spi*/CC2420SpiC$3$__nesc_unnamed4340 {
  CC2420SpiC$3$CLIENT_ID = 3U
};
enum /*CC2420ReceiveC.Spi*/CC2420SpiC$4$__nesc_unnamed4341 {
  CC2420SpiC$4$CLIENT_ID = 4U
};
enum CtpP$__nesc_unnamed4342 {
  CtpP$CLIENT_COUNT = 1U, CtpP$FORWARD_COUNT = 12, CtpP$TREE_ROUTING_TABLE_SIZE = 10, CtpP$QUEUE_SIZE = CtpP$CLIENT_COUNT + CtpP$FORWARD_COUNT, CtpP$CACHE_SIZE = 4
};
typedef message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$t;
typedef TMilli /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$precision_tag;
typedef TMilli /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$precision_tag;
typedef fe_queue_entry_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t;
typedef fe_queue_entry_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$t;
typedef message_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$t;
typedef message_t /*CtpP.MessagePoolP*/PoolC$0$pool_t;
typedef /*CtpP.MessagePoolP*/PoolC$0$pool_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t;
typedef /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$t;
typedef fe_queue_entry_t /*CtpP.QEntryPoolP*/PoolC$1$pool_t;
typedef /*CtpP.QEntryPoolP*/PoolC$1$pool_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t;
typedef /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$t;
typedef fe_queue_entry_t */*CtpP.SendQueueP*/QueueC$0$queue_t;
typedef /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$t;
typedef message_t */*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$t;
enum AMQueueP$__nesc_unnamed4343 {
  AMQueueP$NUM_CLIENTS = 4U
};
typedef TMilli /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$precision_tag;
typedef TMilli /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$precision_tag;
typedef octopus_sent_msg_t /*OctopusAppC.DisseminatorC*/DisseminatorC$0$t;
enum /*OctopusAppC.DisseminatorC*/DisseminatorC$0$__nesc_unnamed4344 {
  DisseminatorC$0$TIMER_ID = 0U
};
typedef /*OctopusAppC.DisseminatorC*/DisseminatorC$0$t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t;
typedef /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$t;
typedef /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$t;
typedef TMilli /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$precision_tag;
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$Init$init(void);
#line 51
static  error_t MeasureClockC$Init$init(void);
# 60 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128Calibrate.nc"
static   uint16_t MeasureClockC$Atm128Calibrate$baudrateRegister(uint32_t arg_0x7ef53898);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t MotePlatformP$PlatformInit$init(void);
# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$toggle(void);



static   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$set(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$clr(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$toggle(void);



static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$set(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$clr(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$toggle(void);



static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$set(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$clr(void);


static   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$makeInput(void);
#line 30
static   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$clr(void);




static   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set(void);
static   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr(void);




static   void /*HplAtm128GeneralIOC.PortB.Bit1*/HplAtm128GeneralIOPinP$9$IO$makeOutput(void);
#line 35
static   void /*HplAtm128GeneralIOC.PortB.Bit2*/HplAtm128GeneralIOPinP$10$IO$makeOutput(void);
#line 33
static   void /*HplAtm128GeneralIOC.PortB.Bit3*/HplAtm128GeneralIOPinP$11$IO$makeInput(void);

static   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$set(void);



static   void /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$makeInput(void);
#line 32
static   bool /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$get(void);
static   void /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$makeInput(void);
#line 32
static   bool /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$get(void);


static   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$makeOutput(void);
#line 29
static   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$set(void);
static   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$clr(void);

static   bool /*HplAtm128GeneralIOC.PortE.Bit4*/HplAtm128GeneralIOPinP$36$IO$get(void);
#line 32
static   bool /*HplAtm128GeneralIOC.PortE.Bit5*/HplAtm128GeneralIOPinP$37$IO$get(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SchedulerBasicP$TaskBasic$postTask(
# 45 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x7f080b18);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$default$runTask(
# 45 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
uint8_t arg_0x7f080b18);
# 46 "/opt/tinyos-2.x/tos/interfaces/Scheduler.nc"
static  void SchedulerBasicP$Scheduler$init(void);
#line 61
static  void SchedulerBasicP$Scheduler$taskLoop(void);
#line 54
static  bool SchedulerBasicP$Scheduler$runNextTask(void);
# 59 "/opt/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void McuSleepC$McuSleep$sleep(void);
# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
static   void McuSleepC$McuPowerState$update(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void OctopusC$CollectSend$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
static  void OctopusC$Boot$booted(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void OctopusC$SerialControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void OctopusC$SerialControl$stopDone(error_t arg_0x7ebf06e8);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *OctopusC$Snoop$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void OctopusC$RadioControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void OctopusC$RadioControl$stopDone(error_t arg_0x7ebf06e8);
# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  void OctopusC$Read$readDone(error_t arg_0x7eaf5668, OctopusC$Read$val_t arg_0x7eaf57f0);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void OctopusC$SerialSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *OctopusC$SerialReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void OctopusC$serialSendTask$runTask(void);
#line 64
static  void OctopusC$collectSendTask$runTask(void);
# 61 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
static  void OctopusC$RequestValue$changed(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void OctopusC$Timer$fired(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *OctopusC$CollectReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t LedsP$Init$init(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
static   void LedsP$Leds$led0Toggle(void);




static   void LedsP$Leds$led1On(void);










static   void LedsP$Leds$led1Toggle(void);
#line 89
static   void LedsP$Leds$led2Toggle(void);
#line 45
static   void LedsP$Leds$led0On(void);
#line 78
static   void LedsP$Leds$led2On(void);
# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$size_type /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getNow(void);
#line 92
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$startAt(/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$size_type arg_0x7e9d39e0, /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$size_type arg_0x7e9d3b70);
#line 105
static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$size_type /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getAlarm(void);
#line 62
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$stop(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Init$init(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$size_type /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$get(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$overflow(void);
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
static   Atm128_TIFR_t HplAtm128Timer0AsyncP$TimerCtrl$getInterruptFlag(void);
#line 37
static   void HplAtm128Timer0AsyncP$TimerCtrl$setControl(Atm128TimerControl_t arg_0x7e986ce8);
# 54 "/opt/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t HplAtm128Timer0AsyncP$McuPowerOverride$lowestState(void);
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerAsync.nc"
static   int HplAtm128Timer0AsyncP$TimerAsync$compareBusy(void);
#line 32
static   void HplAtm128Timer0AsyncP$TimerAsync$setTimer0Asynchronous(void);
# 39 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   HplAtm128Timer0AsyncP$Compare$size_type HplAtm128Timer0AsyncP$Compare$get(void);





static   void HplAtm128Timer0AsyncP$Compare$set(HplAtm128Timer0AsyncP$Compare$size_type arg_0x7e981c38);










static   void HplAtm128Timer0AsyncP$Compare$start(void);
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   HplAtm128Timer0AsyncP$Timer$timer_size HplAtm128Timer0AsyncP$Timer$get(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask(void);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow(void);
#line 118
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(uint32_t arg_0x7eb05010, uint32_t arg_0x7eb051a0);
#line 67
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void);
#line 125
static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getNow(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 140 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getdt(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 133 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$gett0(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 81 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8, 
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t arg_0x7eb13ce0);








static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8, 
# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
uint32_t arg_0x7eb11338);




static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$runTask(void);
# 55 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  error_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$read(void);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t RandomMlcgP$Random$rand16(void);
#line 35
static   uint32_t RandomMlcgP$Random$rand32(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t RandomMlcgP$Init$init(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(
# 36 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x7e7a9030, 
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(
# 36 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x7e7a9030, 
# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb20600);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 83
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(
# 37 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x7e7a9960, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 67 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *arg_0x7e7c1cd8);
#line 92
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 136
static  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *arg_0x7e7b7258);
#line 151
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
# 83 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t SerialP$SplitControl$start(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$stopDoneTask$runTask(void);
#line 64
static  void SerialP$RunTx$runTask(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t SerialP$Init$init(void);
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
static  void SerialP$SerialFlush$flushDone(void);
#line 38
static  void SerialP$SerialFlush$default$flush(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$startDoneTask$runTask(void);
# 83 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   void SerialP$SerialFrameComm$dataReceived(uint8_t arg_0x7e719010);





static   void SerialP$SerialFrameComm$putDone(void);
#line 74
static   void SerialP$SerialFrameComm$delimiterReceived(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SerialP$defaultSerialFlushTask$runTask(void);
# 60 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   error_t SerialP$SendBytePacket$completeSend(void);
#line 51
static   error_t SerialP$SendBytePacket$startSend(uint8_t arg_0x7e729780);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(
# 40 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e6923e0, 
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 89
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(
# 40 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e6923e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(
# 39 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e693b98, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98, 
# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x7e755808, uint8_t arg_0x7e755998);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98);
# 23 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98, 
# 23 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x7e755010, uint8_t arg_0x7e7551a0);
# 70 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);









static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t arg_0x7e728818);
# 51 "/opt/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);






static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t arg_0x7e725838);










static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t arg_0x7e725e08);
# 79 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
static   void HdlcTranslateC$UartStream$receivedByte(uint8_t arg_0x7e635010);
#line 99
static   void HdlcTranslateC$UartStream$receiveDone(uint8_t *arg_0x7e635ce0, uint16_t arg_0x7e635e70, error_t arg_0x7e633010);
#line 57
static   void HdlcTranslateC$UartStream$sendDone(uint8_t *arg_0x7e637f00, uint16_t arg_0x7e6360b0, error_t arg_0x7e636238);
# 45 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void);
#line 68
static   void HdlcTranslateC$SerialFrameComm$resetReceive(void);
#line 54
static   error_t HdlcTranslateC$SerialFrameComm$putData(uint8_t arg_0x7e721d40);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$Init$init(void);
# 48 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
static   error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$send(uint8_t *arg_0x7e637768, uint16_t arg_0x7e6378f8);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$overflow(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$rxDone(uint8_t arg_0x7e603b30);
#line 47
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$txDone(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$start(void);









static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$stop(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t HplAtm128UartP$Uart0Init$init(void);
# 46 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
static   void HplAtm128UartP$HplUart0$tx(uint8_t arg_0x7e603068);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t HplAtm128UartP$Uart1Init$init(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
static   void HplAtm128UartP$HplUart1$default$rxDone(uint8_t arg_0x7e603b30);
#line 47
static   void HplAtm128UartP$HplUart1$default$txDone(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t HplAtm128UartP$Uart0RxControl$start(void);









static  error_t HplAtm128UartP$Uart0RxControl$stop(void);
#line 74
static  error_t HplAtm128UartP$Uart0TxControl$start(void);









static  error_t HplAtm128UartP$Uart0TxControl$stop(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl16.nc"
static   void HplAtm128Timer3P$TimerCtrl$setCtrlCapture(Atm128TimerCtrlCapture_t arg_0x7e5653f0);
#line 37
static   Atm128TimerCtrlCapture_t HplAtm128Timer3P$TimerCtrl$getCtrlCapture(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer3P$CompareA$default$fired(void);
# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void HplAtm128Timer3P$Capture$default$captured(HplAtm128Timer3P$Capture$size_type arg_0x7e55c120);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer3P$CompareB$default$fired(void);
#line 49
static   void HplAtm128Timer3P$CompareC$default$fired(void);
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   HplAtm128Timer3P$Timer$timer_size HplAtm128Timer3P$Timer$get(void);
#line 95
static   void HplAtm128Timer3P$Timer$setScale(uint8_t arg_0x7e9930f8);
#line 58
static   void HplAtm128Timer3P$Timer$set(HplAtm128Timer3P$Timer$timer_size arg_0x7e9953c0);










static   void HplAtm128Timer3P$Timer$start(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*InitThreeP.InitThree*/Atm128TimerInitC$0$Init$init(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$overflow(void);
#line 61
static   void /*CounterThree16C.NCounter*/Atm128CounterC$0$Timer$overflow(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$overflow(void);
# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *arg_0x7e755808, uint8_t arg_0x7e755998);
#line 15
static   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);







static   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *arg_0x7e755010, uint8_t arg_0x7e7551a0);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *arg_0x7eb20600);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54c58);
#line 89
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);
#line 64
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420ActiveMessageP$SubSend$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ActiveMessageP$SubReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t CC2420ActiveMessageP$AMSend$send(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437398, 
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void *CC2420ActiveMessageP$AMSend$getPayload(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437398, 
# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb20600);
#line 112
static  uint8_t CC2420ActiveMessageP$AMSend$maxPayloadLength(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437398);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ActiveMessageP$Snoop$default$receive(
# 41 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e4354e0, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t CC2420ActiveMessageP$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void *CC2420ActiveMessageP$Packet$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 95
static  uint8_t CC2420ActiveMessageP$Packet$maxPayloadLength(void);
#line 83
static  void CC2420ActiveMessageP$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ActiveMessageP$Receive$default$receive(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437cc8, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t CC2420ActiveMessageP$AMPacket$source(message_t *arg_0x7e7c0360);
#line 57
static  am_addr_t CC2420ActiveMessageP$AMPacket$address(void);









static  am_addr_t CC2420ActiveMessageP$AMPacket$destination(message_t *arg_0x7e7c1cd8);
#line 92
static  void CC2420ActiveMessageP$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 136
static  am_id_t CC2420ActiveMessageP$AMPacket$type(message_t *arg_0x7e7b7258);
#line 151
static  void CC2420ActiveMessageP$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
#line 125
static  bool CC2420ActiveMessageP$AMPacket$isForMe(message_t *arg_0x7e7b9b10);
# 83 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t CC2420CsmaP$SplitControl$start(void);
# 94 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
static   void CC2420CsmaP$RadioBackoff$default$requestCca(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 94 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e441268);
#line 72
static   void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 72 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e4420a8);






static   void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 79 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e442660);







static   void CC2420CsmaP$RadioBackoff$default$requestLplBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 87 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e442c18);
#line 72
static   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *arg_0x7e4420a8);






static   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *arg_0x7e442660);







static   void CC2420CsmaP$SubBackoff$requestLplBackoff(message_t *arg_0x7e442c18);
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
static   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *arg_0x7e35dd90, error_t arg_0x7e35df18);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420CsmaP$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420CsmaP$Init$init(void);
# 76 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
static   void CC2420CsmaP$CC2420Power$startOscillatorDone(void);
#line 56
static   void CC2420CsmaP$CC2420Power$startVRegDone(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420CsmaP$Resource$granted(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420CsmaP$sendDone_task$runTask(void);
#line 64
static  void CC2420CsmaP$stopDone_task$runTask(void);
#line 64
static  void CC2420CsmaP$startDone_task$runTask(void);
# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Config.nc"
static  void CC2420ControlP$CC2420Config$default$syncDone(error_t arg_0x7e326b98);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420ControlP$StartupTimer$fired(void);
# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  void CC2420ControlP$ReadRssi$default$readDone(error_t arg_0x7eaf5668, CC2420ControlP$ReadRssi$val_t arg_0x7eaf57f0);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420ControlP$Init$init(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$SpiResource$granted(void);
#line 92
static  void CC2420ControlP$SyncResource$granted(void);
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
static   error_t CC2420ControlP$CC2420Power$startOscillator(void);
#line 90
static   error_t CC2420ControlP$CC2420Power$rxOn(void);
#line 51
static   error_t CC2420ControlP$CC2420Power$startVReg(void);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$Resource$release(void);
#line 78
static   error_t CC2420ControlP$Resource$request(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420ControlP$syncDone_task$runTask(void);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void CC2420ControlP$InterruptCCA$fired(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$RssiResource$granted(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl16.nc"
static   void HplAtm128Timer1P$TimerCtrl$setCtrlCapture(Atm128TimerCtrlCapture_t arg_0x7e5653f0);
#line 37
static   Atm128TimerCtrlCapture_t HplAtm128Timer1P$TimerCtrl$getCtrlCapture(void);
# 53 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer1P$CompareA$reset(void);
#line 45
static   void HplAtm128Timer1P$CompareA$set(HplAtm128Timer1P$CompareA$size_type arg_0x7e981c38);










static   void HplAtm128Timer1P$CompareA$start(void);


static   void HplAtm128Timer1P$CompareA$stop(void);
# 79 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void HplAtm128Timer1P$Capture$setEdge(bool arg_0x7e55b710);
#line 55
static   void HplAtm128Timer1P$Capture$reset(void);


static   void HplAtm128Timer1P$Capture$start(void);


static   void HplAtm128Timer1P$Capture$stop(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer1P$CompareB$default$fired(void);
#line 49
static   void HplAtm128Timer1P$CompareC$default$fired(void);
# 78 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   bool HplAtm128Timer1P$Timer$test(void);
#line 52
static   HplAtm128Timer1P$Timer$timer_size HplAtm128Timer1P$Timer$get(void);
#line 95
static   void HplAtm128Timer1P$Timer$setScale(uint8_t arg_0x7e9930f8);
#line 58
static   void HplAtm128Timer1P$Timer$set(HplAtm128Timer1P$Timer$timer_size arg_0x7e9953c0);










static   void HplAtm128Timer1P$Timer$start(void);
# 92 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$size_type arg_0x7e9d39e0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$size_type arg_0x7e9d3b70);
#line 62
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$stop(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$overflow(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*InitOneP.InitOne*/Atm128TimerInitC$1$Init$init(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$overflow(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$size_type /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$get(void);






static   bool /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$isOverflowPending(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$overflow(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$overflow(void);
#line 53
static   /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$get(void);
# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$getNow(void);
#line 92
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$size_type arg_0x7e9d39e0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$size_type arg_0x7e9d3b70);
#line 55
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$size_type arg_0x7e9d48c8);






static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$stop(void);




static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$fired(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$overflow(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t NoInitC$Init$init(void);
# 43 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureFallingEdge(void);
#line 42
static   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureRisingEdge(void);
# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$captured(/*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$size_type arg_0x7e55c120);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$fired(void);
# 43 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$enableFallingEdge(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$IrqSignal$fired(void);
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$clear(void);
#line 40
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$disable(void);
#line 59
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$edge(bool arg_0x7e0f14c8);
#line 35
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$enable(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$default$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$IrqSignal$fired(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void HplCC2420InterruptsP$CCATimer$fired(void);
# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
static  void HplCC2420InterruptsP$Boot$booted(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void HplCC2420InterruptsP$stopTask$runTask(void);
# 50 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t HplCC2420InterruptsP$CCA$disable(void);
#line 42
static   error_t HplCC2420InterruptsP$CCA$enableRisingEdge(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void HplCC2420InterruptsP$CCATask$runTask(void);
# 71 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void CC2420SpiImplP$SpiPacket$sendDone(uint8_t *arg_0x7e014290, uint8_t *arg_0x7e014438, uint16_t arg_0x7e0145c8, 
error_t arg_0x7e014760);
# 62 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   error_t CC2420SpiImplP$Fifo$continueRead(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 62 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e039bf0, uint8_t arg_0x7e039d78);
#line 91
static   void CC2420SpiImplP$Fifo$default$writeDone(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e0364c8, uint8_t arg_0x7e036650, error_t arg_0x7e0367d8);
#line 82
static   cc2420_status_t CC2420SpiImplP$Fifo$write(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e038cc8, uint8_t arg_0x7e038e50);
#line 51
static   cc2420_status_t CC2420SpiImplP$Fifo$beginRead(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 51 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e039458, uint8_t arg_0x7e0395e0);
#line 71
static   void CC2420SpiImplP$Fifo$default$readDone(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e0383f0, uint8_t arg_0x7e038578, error_t arg_0x7e038700);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420SpiImplP$SpiResource$granted(void);
# 63 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Ram.nc"
static   cc2420_status_t CC2420SpiImplP$Ram$write(
# 41 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint16_t arg_0x7e01e9f0, 
# 63 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Ram.nc"
uint8_t arg_0x7e30f388, uint8_t *arg_0x7e30f530, uint8_t arg_0x7e30f6b8);
# 47 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420SpiImplP$Reg$read(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01d0f8, 
# 47 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
uint16_t *arg_0x7e30c4a0);







static   cc2420_status_t CC2420SpiImplP$Reg$write(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01d0f8, 
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
uint16_t arg_0x7e30ca10);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiImplP$Resource$release(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01f6b8);
# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiImplP$Resource$immediateRequest(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01f6b8);
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiImplP$Resource$request(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01f6b8);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420SpiImplP$Resource$default$granted(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01f6b8);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420SpiImplP$Strobe$strobe(
# 43 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01d7d8);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void Atm128SpiP$zeroTask$runTask(void);
# 59 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t Atm128SpiP$SpiPacket$send(uint8_t *arg_0x7e0157f0, uint8_t *arg_0x7e015998, uint16_t arg_0x7e015b28);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void Atm128SpiP$ResourceArbiter$granted(
# 84 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfb9bf0);
# 34 "/opt/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t Atm128SpiP$SpiByte$write(uint8_t arg_0x7e018088);
# 92 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
static   void Atm128SpiP$Spi$dataReady(uint8_t arg_0x7dfb2858);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$Resource$release(
# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfbca68);
# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$Resource$immediateRequest(
# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfbca68);
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$Resource$request(
# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfbca68);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void Atm128SpiP$Resource$default$granted(
# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfbca68);
# 72 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
static   void HplAtm128SpiP$SPI$sleep(void);
#line 66
static   void HplAtm128SpiP$SPI$initMaster(void);
#line 105
static   void HplAtm128SpiP$SPI$setMasterBit(bool arg_0x7dfa3548);
#line 96
static   void HplAtm128SpiP$SPI$enableInterrupt(bool arg_0x7dfb2da0);
#line 80
static   uint8_t HplAtm128SpiP$SPI$read(void);
#line 125
static   void HplAtm128SpiP$SPI$setMasterDoubleSpeed(bool arg_0x7dfa0ee0);
#line 114
static   void HplAtm128SpiP$SPI$setClock(uint8_t arg_0x7dfa2d70);
#line 108
static   void HplAtm128SpiP$SPI$setClockPolarity(bool arg_0x7dfa3da0);
#line 86
static   void HplAtm128SpiP$SPI$write(uint8_t arg_0x7dfb2348);
#line 99
static   void HplAtm128SpiP$SPI$enableSpi(bool arg_0x7dfb1598);
#line 111
static   void HplAtm128SpiP$SPI$setClockPhase(bool arg_0x7dfa25a8);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$Init$init(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t arg_0x7def8010);
#line 43
static   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);








static   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t arg_0x7defa5e0);







static   resource_client_id_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
# 43 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$requested(
# 52 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee23e8);
# 51 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$immediateRequested(
# 52 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee23e8);
# 55 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$unconfigure(
# 56 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee2ed0);
# 49 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$configure(
# 56 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee2ed0);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$release(
# 51 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee3a00);
# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$immediateRequest(
# 51 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee3a00);
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$request(
# 51 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee3a00);
# 80 "/opt/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ArbiterInfo$inUse(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$runTask(void);
# 56 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
static   void CC2420TransmitP$RadioBackoff$setLplBackoff(uint16_t arg_0x7e444590);
#line 49
static   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t arg_0x7e444010);
#line 43
static   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t arg_0x7e4459b0);
# 50 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   void CC2420TransmitP$CaptureSFD$captured(uint16_t arg_0x7e124ab8);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420TransmitP$BackoffTimer$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
static   void CC2420TransmitP$CC2420Receive$receive(uint8_t arg_0x7de51408, message_t *arg_0x7de515b8);
# 49 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
static   error_t CC2420TransmitP$Send$send(message_t *arg_0x7e364d08, bool arg_0x7e364e90);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420TransmitP$Init$init(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420TransmitP$startLplTimer$runTask(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420TransmitP$SpiResource$granted(void);
# 39 "/opt/tinyos-2.x/tos/interfaces/RadioTimeStamping.nc"
static   void CC2420TransmitP$TimeStamp$default$transmittedSFD(uint16_t arg_0x7de73460, message_t *arg_0x7de73610);










static   void CC2420TransmitP$TimeStamp$default$receivedSFD(uint16_t arg_0x7de73b40);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420TransmitP$StdControl$start(void);
# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *arg_0x7e0364c8, uint8_t arg_0x7e036650, error_t arg_0x7e0367d8);
#line 71
static   void CC2420TransmitP$TXFIFO$readDone(uint8_t *arg_0x7e0383f0, uint8_t arg_0x7e038578, error_t arg_0x7e038700);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void CC2420TransmitP$LplDisableTimer$fired(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void CC2420ReceiveP$receiveDone_task$runTask(void);
# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
static   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void);
#line 47
static   void CC2420ReceiveP$CC2420Receive$sfd(uint16_t arg_0x7de52aa8);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t CC2420ReceiveP$Init$init(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ReceiveP$SpiResource$granted(void);
# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *arg_0x7e0364c8, uint8_t arg_0x7e036650, error_t arg_0x7e0367d8);
#line 71
static   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *arg_0x7e0383f0, uint8_t arg_0x7e038578, error_t arg_0x7e038700);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void CC2420ReceiveP$InterruptFIFOP$fired(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420ReceiveP$StdControl$start(void);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *CC2420PacketC$CC2420Packet$getHeader(message_t *arg_0x7e448670);




static   cc2420_metadata_t *CC2420PacketC$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0);
# 48 "/opt/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static   error_t CC2420PacketC$Acks$requestAck(message_t *arg_0x7e7b46d8);
#line 74
static   bool CC2420PacketC$Acks$wasAcked(message_t *arg_0x7e7b3568);
# 42 "/opt/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static   am_addr_t ActiveMessageAddressC$amAddress(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void UniqueSendP$SubSend$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
#line 64
static  error_t UniqueSendP$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t UniqueSendP$Init$init(void);
#line 51
static  error_t StateImplP$Init$init(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/State.nc"
static   void StateImplP$State$toIdle(
# 67 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x7dd1b010);
# 45 "/opt/tinyos-2.x/tos/interfaces/State.nc"
static   error_t StateImplP$State$requestState(
# 67 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
uint8_t arg_0x7dd1b010, 
# 45 "/opt/tinyos-2.x/tos/interfaces/State.nc"
uint8_t arg_0x7dd3b6f0);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$SubReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t UniqueReceiveP$Init$init(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 76 "/opt/tinyos-2.x/tos/interfaces/LowPowerListening.nc"
static  void CC2420LplDummyP$LowPowerListening$setLocalDutyCycle(uint16_t arg_0x7eb90890);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$SubReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 50 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEvent(uint8_t arg_0x7dc74e50);
#line 62
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEventMsg(uint8_t arg_0x7dc67338, uint16_t arg_0x7dc674c8, am_addr_t arg_0x7dc67658, am_addr_t arg_0x7dc677e8);
# 43 "/opt/tinyos-2.x/tos/lib/net/CollectionPacket.nc"
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(message_t *arg_0x7dc97920);





static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(message_t *arg_0x7dc94010);
# 67 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$evicted(am_addr_t arg_0x7dc7bf00);
# 31 "/opt/tinyos-2.x/tos/interfaces/Intercept.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$default$forward(
# 136 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc545c0, 
# 31 "/opt/tinyos-2.x/tos/interfaces/Intercept.nc"
message_t *arg_0x7dc9bdf0, void *arg_0x7dc9a010, uint16_t arg_0x7dc9a1a0);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 95
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$maxPayloadLength(void);
#line 83
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$fired(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$default$receive(
# 135 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc56e20, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$send(
# 133 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc57c78, 
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$getPayload(
# 133 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc57c78, 
# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54c58);
#line 101
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$maxPayloadLength(
# 133 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc57c78);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$default$sendDone(
# 133 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc57c78, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$stopDone(error_t arg_0x7ebf06e8);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$fired(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$runTask(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Init$init(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$default$receive(
# 134 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc56680, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 7 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpCongestion.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpCongestion$isCongested(void);
# 51 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$routeFound(void);
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$noRoute(void);
# 51 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpPacket.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$option(message_t *arg_0x7dc87010, ctp_options_t arg_0x7dc871a0);





static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setEtx(message_t *arg_0x7dc86638, uint16_t arg_0x7dc867c8);
#line 48
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$clearOption(message_t *arg_0x7dc919a0, ctp_options_t arg_0x7dc91b30);







static  uint16_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getEtx(message_t *arg_0x7dc86190);


static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(message_t *arg_0x7dc86c90);
#line 45
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setOption(message_t *arg_0x7dc91358, ctp_options_t arg_0x7dc914e8);







static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(message_t *arg_0x7dc87658);








static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(message_t *arg_0x7dc857e8);





static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$matchInstance(message_t *arg_0x7dc83ec8, message_t *arg_0x7dc820a8);
#line 65
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(message_t *arg_0x7dc83358);
#line 54
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setThl(message_t *arg_0x7dc87b00, uint8_t arg_0x7dc87c88);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$StdControl$start(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSnoop$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 46 "/opt/tinyos-2.x/tos/lib/net/CollectionId.nc"
static  collection_id_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$default$fetch(
# 165 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc157e8);
# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$t */*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$get(void);
#line 80
static  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$maxSize(void);
#line 61
static  bool /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$empty(void);
#line 88
static  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$put(/*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$t *arg_0x7dc2ab50);
#line 72
static  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$size(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Init$init(void);
# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$t */*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$get(void);
#line 61
static  bool /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$empty(void);
#line 88
static  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$put(/*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$t *arg_0x7dc2ab50);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Init$init(void);
# 73 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
static  /*CtpP.SendQueueP*/QueueC$0$Queue$t /*CtpP.SendQueueP*/QueueC$0$Queue$head(void);
#line 90
static  error_t /*CtpP.SendQueueP*/QueueC$0$Queue$enqueue(/*CtpP.SendQueueP*/QueueC$0$Queue$t arg_0x7dc30d30);










static  /*CtpP.SendQueueP*/QueueC$0$Queue$t /*CtpP.SendQueueP*/QueueC$0$Queue$element(uint8_t arg_0x7dc2f330);
#line 65
static  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$maxSize(void);
#line 81
static  /*CtpP.SendQueueP*/QueueC$0$Queue$t /*CtpP.SendQueueP*/QueueC$0$Queue$dequeue(void);
#line 50
static  bool /*CtpP.SendQueueP*/QueueC$0$Queue$empty(void);







static  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$size(void);
# 40 "/opt/tinyos-2.x/tos/interfaces/Cache.nc"
static  void /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$insert(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$t arg_0x7dc16088);







static  bool /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$lookup(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$t arg_0x7dc165e0);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Init$init(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *LinkEstimatorP$SubReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 38 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  uint8_t LinkEstimatorP$LinkEstimator$getLinkQuality(uint16_t arg_0x7dc7d4e8);
#line 57
static  error_t LinkEstimatorP$LinkEstimator$txAck(am_addr_t arg_0x7dc7b138);
#line 50
static  error_t LinkEstimatorP$LinkEstimator$pinNeighbor(am_addr_t arg_0x7dc7c7e8);










static  error_t LinkEstimatorP$LinkEstimator$txNoAck(am_addr_t arg_0x7dc7b5d0);
#line 47
static  error_t LinkEstimatorP$LinkEstimator$insertNeighbor(am_addr_t arg_0x7dc7c348);
#line 64
static  error_t LinkEstimatorP$LinkEstimator$clearDLQ(am_addr_t arg_0x7dc7ba70);
#line 53
static  error_t LinkEstimatorP$LinkEstimator$unpinNeighbor(am_addr_t arg_0x7dc7cc88);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t LinkEstimatorP$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void *LinkEstimatorP$Packet$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 95
static  uint8_t LinkEstimatorP$Packet$maxPayloadLength(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t LinkEstimatorP$Send$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void *LinkEstimatorP$Send$getPayload(message_t *arg_0x7eb20600);
#line 112
static  uint8_t LinkEstimatorP$Send$maxPayloadLength(void);
#line 99
static  void LinkEstimatorP$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t LinkEstimatorP$Init$init(void);
# 79 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  void *LinkEstimatorP$Receive$getPayload(message_t *arg_0x7eb45a48, uint8_t *arg_0x7eb45bf0);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t LinkEstimatorP$StdControl$start(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 112
static  uint8_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$maxPayloadLength(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$sendDone(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void */*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$getPayload(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54c58);
#line 101
static  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$maxPayloadLength(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$default$sendDone(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$runTask(void);
#line 64
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask$runTask(void);
# 43 "/opt/tinyos-2.x/tos/lib/net/RootControl.nc"
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$isRoot(void);
#line 41
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$setRoot(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$runTask(void);
# 68 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$default$logEventRoute(uint8_t arg_0x7dc67c90, am_addr_t arg_0x7dc67e20, uint8_t arg_0x7dc66010, uint16_t arg_0x7dc661a0);
# 67 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$evicted(am_addr_t arg_0x7dc7bf00);
# 46 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingPacket.nc"
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpRoutingPacket$getOption(message_t *arg_0x7da337b0, ctp_options_t arg_0x7da33940);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$stopDone(error_t arg_0x7ebf06e8);
# 70 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$recomputeRoutes(void);
#line 58
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerRouteUpdate(void);
#line 51
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getEtx(uint16_t *arg_0x7eb34478);
#line 65
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerImmediateRouteUpdate(void);









static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$setNeighborCongested(am_addr_t arg_0x7eb324d8, bool arg_0x7eb32668);
#line 41
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getParent(am_addr_t *arg_0x7eb43e58);
#line 80
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$isNeighborCongested(am_addr_t arg_0x7eb32b50);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$runTask(void);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$Init$init(void);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$fired(void);
#line 72
static  void /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$fired(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$StdControl$start(void);
# 49 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$Routing$hasRoute(void);
#line 48
static  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$Routing$nextHop(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 46 "/opt/tinyos-2.x/tos/lib/net/CollectionId.nc"
static  collection_id_t /*OctopusAppC.CollectionSenderC.CollectionSenderP.CollectionIdP*/CollectionIdP$0$CollectionId$fetch(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *DisseminationEngineImplP$ProbeReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void DisseminationEngineImplP$ProbeAMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
#line 99
static  void DisseminationEngineImplP$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 82 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void DisseminationEngineImplP$TrickleTimer$fired(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 77 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void DisseminationEngineImplP$TrickleTimer$default$incrementCounter(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 72 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void DisseminationEngineImplP$TrickleTimer$default$reset(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 60 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  error_t DisseminationEngineImplP$TrickleTimer$default$start(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 48 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void DisseminationEngineImplP$DisseminationCache$default$storeData(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0, 
# 48 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
void *arg_0x7d943e80, uint8_t arg_0x7d942030, uint32_t arg_0x7d9421c0);

static  void DisseminationEngineImplP$DisseminationCache$newData(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0);
# 45 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  error_t DisseminationEngineImplP$DisseminationCache$start(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0);
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  uint32_t DisseminationEngineImplP$DisseminationCache$default$requestSeqno(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0);
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void *DisseminationEngineImplP$DisseminationCache$default$requestData(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0, 
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
uint8_t *arg_0x7d9439c0);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *DisseminationEngineImplP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t DisseminationEngineImplP$StdControl$start(void);
#line 74
static  error_t DisseminationEngineImplP$DisseminatorControl$default$start(
# 51 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d937030);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$getPayload(message_t *arg_0x7eb20600);
#line 112
static  uint8_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$maxPayloadLength(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
#line 89
static  void /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestData(uint8_t *arg_0x7d9439c0);
static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$storeData(void *arg_0x7d943e80, uint8_t arg_0x7d942030, uint32_t arg_0x7d9421c0);
static  uint32_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestSeqno(void);
# 52 "/opt/tinyos-2.x/tos/lib/net/DisseminationUpdate.nc"
static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$change(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$t *arg_0x7eb71010);
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
static  const /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$t */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$get(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$StdControl$start(void);
# 82 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$default$fired(
# 50 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
uint8_t arg_0x7d8c0f00);
# 77 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$incrementCounter(
# 50 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
uint8_t arg_0x7d8c0f00);
# 72 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$reset(
# 50 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
uint8_t arg_0x7d8c0f00);
# 60 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$start(
# 50 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
uint8_t arg_0x7d8c0f00);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Init$init(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$runTask(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$fired(void);
# 34 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
static   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clearAll(void);
#line 58
static   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clear(uint16_t arg_0x7d8b7510);
#line 46
static   bool /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$get(uint16_t arg_0x7d8b8a68);





static   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$set(uint16_t arg_0x7d8b7010);
#line 34
static   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clearAll(void);
#line 58
static   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clear(uint16_t arg_0x7d8b7510);
#line 46
static   bool /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$get(uint16_t arg_0x7d8b8a68);





static   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$set(uint16_t arg_0x7d8b7010);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t PlatformP$MoteInit$init(void);
#line 51
static  error_t PlatformP$MeasureClock$init(void);
#line 51
static  error_t PlatformP$LedsInit$init(void);
# 18 "/opt/tinyos-2.x/tos/platforms/aquisgrain/PlatformP.nc"
static inline void PlatformP$power_init(void);






static inline  error_t PlatformP$Init$init(void);
# 33 "/opt/tinyos-2.x/tos/platforms/aquisgrain/MeasureClockC.nc"
enum MeasureClockC$__nesc_unnamed4345 {


  MeasureClockC$MAGIC = 488 / (16 / PLATFORM_MHZ)
};

uint16_t MeasureClockC$cycles;

static inline  error_t MeasureClockC$Init$init(void);
#line 120
static inline   uint16_t MeasureClockC$Atm128Calibrate$baudrateRegister(uint32_t baudrate);
# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
static  error_t MotePlatformP$SubInit$init(void);
# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void MotePlatformP$SerialIdPin$makeInput(void);
#line 30
static   void MotePlatformP$SerialIdPin$clr(void);
# 26 "/opt/tinyos-2.x/tos/platforms/aquisgrain/MotePlatformP.nc"
static inline  error_t MotePlatformP$PlatformInit$init(void);
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$set(void);
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$clr(void);
static inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$toggle(void);



static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$makeOutput(void);
#line 46
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$set(void);
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$clr(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$toggle(void);



static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$makeOutput(void);
#line 46
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$set(void);
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$clr(void);
static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$toggle(void);



static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$makeOutput(void);
#line 47
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$clr(void);


static __inline   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$makeInput(void);
#line 46
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set(void);
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr(void);




static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput(void);
#line 52
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit1*/HplAtm128GeneralIOPinP$9$IO$makeOutput(void);
#line 52
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit2*/HplAtm128GeneralIOPinP$10$IO$makeOutput(void);
#line 50
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit3*/HplAtm128GeneralIOPinP$11$IO$makeInput(void);
#line 46
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$set(void);





static __inline   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$makeOutput(void);
#line 45
static __inline   bool /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$get(void);




static __inline   void /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$makeInput(void);
#line 45
static __inline   bool /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$get(void);




static __inline   void /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$makeInput(void);
#line 46
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$set(void);
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$clr(void);




static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$makeOutput(void);
#line 45
static __inline   bool /*HplAtm128GeneralIOC.PortE.Bit4*/HplAtm128GeneralIOPinP$36$IO$get(void);
#line 45
static __inline   bool /*HplAtm128GeneralIOC.PortE.Bit5*/HplAtm128GeneralIOPinP$37$IO$get(void);
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
uint8_t arg_0x7f080b18);
# 59 "/opt/tinyos-2.x/tos/interfaces/McuSleep.nc"
static   void SchedulerBasicP$McuSleep$sleep(void);
# 50 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
enum SchedulerBasicP$__nesc_unnamed4346 {

  SchedulerBasicP$NUM_TASKS = 29U, 
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
# 54 "/opt/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void);
# 58 "/opt/tinyos-2.x/tos/chips/atm128/McuSleepC.nc"
const_uint8_t McuSleepC$atm128PowerBits[ATM128_POWER_DOWN + 1] = { 
0, 
1 << 3, ((
1 << 2) | (1 << 4)) | (1 << 3), (
1 << 4) | (1 << 3), (
1 << 2) | (1 << 4), 
1 << 4 };

static inline mcu_power_t McuSleepC$getPowerState(void);
#line 97
static inline   void McuSleepC$McuSleep$sleep(void);
#line 109
static inline   void McuSleepC$McuPowerState$update(void);
# 41 "/opt/tinyos-2.x/tos/lib/net/RootControl.nc"
static  error_t OctopusC$RootControl$setRoot(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t OctopusC$CollectSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void *OctopusC$CollectSend$getPayload(message_t *arg_0x7eb54c58);
# 83 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  error_t OctopusC$SerialControl$start(void);
#line 83
static  error_t OctopusC$RadioControl$start(void);
# 76 "/opt/tinyos-2.x/tos/interfaces/LowPowerListening.nc"
static  void OctopusC$LowPowerListening$setLocalDutyCycle(uint16_t arg_0x7eb90890);
# 55 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  error_t OctopusC$Read$read(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t OctopusC$CollectControl$start(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t OctopusC$SerialSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void *OctopusC$SerialSend$getPayload(message_t *arg_0x7eb20600);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t OctopusC$BroadcastControl$start(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t OctopusC$serialSendTask$postTask(void);
# 51 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
static  error_t OctopusC$CollectInfo$getEtx(uint16_t *arg_0x7eb34478);
#line 41
static  error_t OctopusC$CollectInfo$getParent(am_addr_t *arg_0x7eb43e58);
# 56 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
static   void OctopusC$Leds$led0Toggle(void);




static   void OctopusC$Leds$led1On(void);










static   void OctopusC$Leds$led1Toggle(void);
#line 89
static   void OctopusC$Leds$led2Toggle(void);
#line 45
static   void OctopusC$Leds$led0On(void);
#line 78
static   void OctopusC$Leds$led2On(void);
# 52 "/opt/tinyos-2.x/tos/lib/net/DisseminationUpdate.nc"
static  void OctopusC$RequestUpdate$change(OctopusC$RequestUpdate$t *arg_0x7eb71010);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t OctopusC$collectSendTask$postTask(void);
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
static  const OctopusC$RequestValue$t *OctopusC$RequestValue$get(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void OctopusC$Timer$startPeriodic(uint32_t arg_0x7eb13ce0);
#line 67
static  void OctopusC$Timer$stop(void);
# 86 "OctopusC.nc"
enum OctopusC$__nesc_unnamed4347 {
#line 86
  OctopusC$collectSendTask = 0U
};
#line 86
typedef int OctopusC$__nesc_sillytask_collectSendTask[OctopusC$collectSendTask];
enum OctopusC$__nesc_unnamed4348 {
#line 87
  OctopusC$serialSendTask = 1U
};
#line 87
typedef int OctopusC$__nesc_sillytask_serialSendTask[OctopusC$serialSendTask];
#line 65
octopus_collected_msg_t OctopusC$localCollectedMsg;
message_t OctopusC$fwdMsg;
message_t OctopusC$sndMsg;
bool OctopusC$fwdBusy;
#line 68
bool OctopusC$sendBusy;
#line 68
bool OctopusC$uartBusy;
uint16_t OctopusC$samplingPeriod;
uint16_t OctopusC$threshold;
bool OctopusC$modeAuto;
#line 71
bool OctopusC$sleeping;
#line 71
bool OctopusC$root = FALSE;
uint16_t OctopusC$battery;
#line 72
uint16_t OctopusC$sleepDutyCycle;
#line 72
uint16_t OctopusC$awakeDutyCycle;
uint16_t OctopusC$oldSensorValue = 0;


static void OctopusC$fatalProblem(void);





inline static void OctopusC$reportProblem(void);
inline static void OctopusC$reportSent(void);
inline static void OctopusC$reportReceived(void);
static void OctopusC$processRequest(octopus_sent_msg_t *newRequest);


static void OctopusC$fillPacket(void);
static void OctopusC$setLocalDutyCycle(void);






static inline  void OctopusC$Boot$booted(void);
#line 114
static inline  void OctopusC$RadioControl$startDone(error_t error);
#line 127
static inline  void OctopusC$RadioControl$stopDone(error_t error);
static inline  void OctopusC$SerialControl$startDone(error_t error);



static inline  void OctopusC$SerialControl$stopDone(error_t error);





static void OctopusC$processRequest(octopus_sent_msg_t *newRequest);
#line 236
static inline  message_t *OctopusC$SerialReceive$receive(message_t *msg, void *payload, uint8_t len);
#line 249
static inline  void OctopusC$collectSendTask$runTask(void);










static inline  void OctopusC$serialSendTask$runTask(void);










static  void OctopusC$CollectSend$sendDone(message_t *msg, error_t error);







static  void OctopusC$SerialSend$sendDone(message_t *msg, error_t error);
#line 295
static void OctopusC$fillPacket(void);
#line 314
static inline  void OctopusC$RequestValue$changed(void);








static inline  void OctopusC$Timer$fired(void);









static inline  void OctopusC$Read$readDone(error_t ok, uint16_t val);
#line 370
static  message_t *OctopusC$CollectReceive$receive(message_t *msg, void *payload, uint8_t len);
#line 390
static inline  message_t *OctopusC$Snoop$receive(message_t *msg, void *payload, uint8_t len);



static void OctopusC$setLocalDutyCycle(void);
# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void LedsP$Led0$toggle(void);



static   void LedsP$Led0$makeOutput(void);
#line 29
static   void LedsP$Led0$set(void);
static   void LedsP$Led0$clr(void);
static   void LedsP$Led1$toggle(void);



static   void LedsP$Led1$makeOutput(void);
#line 29
static   void LedsP$Led1$set(void);
static   void LedsP$Led1$clr(void);
static   void LedsP$Led2$toggle(void);



static   void LedsP$Led2$makeOutput(void);
#line 29
static   void LedsP$Led2$set(void);
static   void LedsP$Led2$clr(void);
# 45 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline  error_t LedsP$Init$init(void);
#line 63
static inline   void LedsP$Leds$led0On(void);









static inline   void LedsP$Leds$led0Toggle(void);




static inline   void LedsP$Leds$led1On(void);









static inline   void LedsP$Leds$led1Toggle(void);




static inline   void LedsP$Leds$led2On(void);









static inline   void LedsP$Leds$led2Toggle(void);
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
static   Atm128_TIFR_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$getInterruptFlag(void);
#line 37
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$setControl(Atm128TimerControl_t arg_0x7e986ce8);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$fired(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$overflow(void);
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerAsync.nc"
static   int /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$compareBusy(void);
#line 32
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$setTimer0Asynchronous(void);
# 39 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$size_type /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$get(void);





static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$set(/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$size_type arg_0x7e981c38);










static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$start(void);
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$timer_size /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get(void);
# 38 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
uint8_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$set;
uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$t0;
#line 39
uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$dt;
 uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base;



enum /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$__nesc_unnamed4349 {
  Atm128AlarmAsyncP$0$MINDT = 2, 
  Atm128AlarmAsyncP$0$MAXT = 230
};



static void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt(void);


static inline  error_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Init$init(void);
#line 74
static inline void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setOcr0(uint8_t n);
#line 90
static void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt(void);
#line 139
static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$fired(void);
#line 151
static   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$get(void);
#line 194
static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$stop(void);







static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$startAt(uint32_t nt0, uint32_t ndt);









static inline   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getNow(void);



static inline   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getAlarm(void);



static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$overflow(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer0AsyncP$Compare$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void HplAtm128Timer0AsyncP$Timer$overflow(void);
# 50 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   uint8_t HplAtm128Timer0AsyncP$Timer$get(void);
#line 76
static inline   void HplAtm128Timer0AsyncP$TimerCtrl$setControl(Atm128TimerControl_t x);
#line 94
static inline   Atm128_TIFR_t HplAtm128Timer0AsyncP$TimerCtrl$getInterruptFlag(void);
#line 122
static inline   void HplAtm128Timer0AsyncP$Compare$start(void);









static inline   uint8_t HplAtm128Timer0AsyncP$Compare$get(void);


static inline   void HplAtm128Timer0AsyncP$Compare$set(uint8_t t);




static __inline void HplAtm128Timer0AsyncP$stabiliseTimer0(void);
#line 155
static inline   mcu_power_t HplAtm128Timer0AsyncP$McuPowerOverride$lowestState(void);
#line 178
void __vector_15(void) __attribute((signal))   ;





void __vector_16(void) __attribute((signal))   ;
#line 198
static inline   void HplAtm128Timer0AsyncP$TimerAsync$setTimer0Asynchronous(void);







static inline   int HplAtm128Timer0AsyncP$TimerAsync$compareBusy(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$postTask(void);
# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow(void);
#line 92
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x7e9d39e0, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x7e9d3b70);
#line 105
static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(void);
#line 62
static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop(void);
# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired(void);
# 63 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
enum /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$__nesc_unnamed4350 {
#line 63
  AlarmToTimerC$0$fired = 2U
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
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(void);
#line 118
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x7eb05010, uint32_t arg_0x7eb051a0);
#line 67
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$stop(void);




static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$fired(
# 37 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
uint8_t arg_0x7e871cd8);
#line 60
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4351 {
#line 60
  VirtualizeTimerC$0$updateFromTimer = 3U
};
#line 60
typedef int /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_sillytask_updateFromTimer[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer];
#line 42
enum /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4352 {

  VirtualizeTimerC$0$NUM_TIMERS = 8, 
  VirtualizeTimerC$0$END_OF_LIST = 255
};








#line 48
typedef struct /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$__nesc_unnamed4353 {

  uint32_t t0;
  uint32_t dt;
  bool isoneshot : 1;
  bool isrunning : 1;
  bool _reserved : 6;
} /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t;

/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$NUM_TIMERS];




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(uint32_t now);
#line 88
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$runTask(void);
#line 127
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void);




static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot);









static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt);




static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(uint8_t num, uint32_t dt);




static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(uint8_t num);




static inline  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(uint8_t num);
#line 177
static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getNow(uint8_t num);




static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$gett0(uint8_t num);




static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getdt(uint8_t num);




static inline   void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num);
# 47 "/opt/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$postTask(void);
# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  void /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$readDone(error_t arg_0x7eaf5668, /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$val_t arg_0x7eaf57f0);
# 33 "/opt/tinyos-2.x/tos/system/SineSensorC.nc"
enum /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$__nesc_unnamed4354 {
#line 33
  SineSensorC$0$readTask = 4U
};
#line 33
typedef int /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$__nesc_sillytask_readTask[/*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask];
#line 26
uint32_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$counter;






static inline  void /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$runTask(void);







static inline  error_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$read(void);
# 41 "/opt/tinyos-2.x/tos/system/RandomMlcgP.nc"
uint32_t RandomMlcgP$seed;


static inline  error_t RandomMlcgP$Init$init(void);
#line 58
static   uint32_t RandomMlcgP$Random$rand32(void);
#line 78
static inline   uint16_t RandomMlcgP$Random$rand16(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(
# 36 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x7e7a9030, 
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(
# 37 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
am_id_t arg_0x7e7a9960, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 49 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
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







static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len);







static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t *len);










static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg);









static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr);
#line 158
static  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg);




static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void SerialP$SplitControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void SerialP$SplitControl$stopDone(error_t arg_0x7ebf06e8);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$stopDoneTask$postTask(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t SerialP$SerialControl$start(void);









static  error_t SerialP$SerialControl$stop(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$RunTx$postTask(void);
# 38 "/opt/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
static  void SerialP$SerialFlush$flush(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$startDoneTask$postTask(void);
# 45 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   error_t SerialP$SerialFrameComm$putDelimiter(void);
#line 68
static   void SerialP$SerialFrameComm$resetReceive(void);
#line 54
static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x7e721d40);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t SerialP$defaultSerialFlushTask$postTask(void);
# 70 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   uint8_t SerialP$SendBytePacket$nextByte(void);









static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x7e728818);
# 51 "/opt/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
static   error_t SerialP$ReceiveBytePacket$startPacket(void);






static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x7e725838);










static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x7e725e08);
# 189 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
enum SerialP$__nesc_unnamed4355 {
#line 189
  SerialP$RunTx = 5U
};
#line 189
typedef int SerialP$__nesc_sillytask_RunTx[SerialP$RunTx];
#line 320
enum SerialP$__nesc_unnamed4356 {
#line 320
  SerialP$startDoneTask = 6U
};
#line 320
typedef int SerialP$__nesc_sillytask_startDoneTask[SerialP$startDoneTask];





enum SerialP$__nesc_unnamed4357 {
#line 326
  SerialP$stopDoneTask = 7U
};
#line 326
typedef int SerialP$__nesc_sillytask_stopDoneTask[SerialP$stopDoneTask];








enum SerialP$__nesc_unnamed4358 {
#line 335
  SerialP$defaultSerialFlushTask = 8U
};
#line 335
typedef int SerialP$__nesc_sillytask_defaultSerialFlushTask[SerialP$defaultSerialFlushTask];
#line 79
enum SerialP$__nesc_unnamed4359 {
  SerialP$RX_DATA_BUFFER_SIZE = 2, 
  SerialP$TX_DATA_BUFFER_SIZE = 4, 
  SerialP$SERIAL_MTU = 255, 
  SerialP$SERIAL_VERSION = 1, 
  SerialP$ACK_QUEUE_SIZE = 5
};

enum SerialP$__nesc_unnamed4360 {
  SerialP$RXSTATE_NOSYNC, 
  SerialP$RXSTATE_PROTO, 
  SerialP$RXSTATE_TOKEN, 
  SerialP$RXSTATE_INFO, 
  SerialP$RXSTATE_INACTIVE
};

enum SerialP$__nesc_unnamed4361 {
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
typedef enum SerialP$__nesc_unnamed4362 {
  SerialP$BUFFER_AVAILABLE, 
  SerialP$BUFFER_FILLING, 
  SerialP$BUFFER_COMPLETE
} SerialP$tx_data_buffer_states_t;

enum SerialP$__nesc_unnamed4363 {
  SerialP$TX_ACK_INDEX = 0, 
  SerialP$TX_DATA_INDEX = 1, 
  SerialP$TX_BUFFER_COUNT = 2
};






#line 122
typedef struct SerialP$__nesc_unnamed4364 {
  uint8_t writePtr;
  uint8_t readPtr;
  uint8_t buf[SerialP$RX_DATA_BUFFER_SIZE + 1];
} SerialP$rx_buf_t;




#line 128
typedef struct SerialP$__nesc_unnamed4365 {
  uint8_t state;
  uint8_t buf;
} SerialP$tx_buf_t;





#line 133
typedef struct SerialP$__nesc_unnamed4366 {
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
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$postTask(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(
# 40 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e6923e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(
# 39 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e693b98, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98, 
# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x7e755808, uint8_t arg_0x7e755998);
#line 15
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98);
# 23 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
uart_id_t arg_0x7e692d98, 
# 23 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
message_t *arg_0x7e755010, uint8_t arg_0x7e7551a0);
# 60 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$completeSend(void);
#line 51
static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x7e729780);
# 152 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4367 {
#line 152
  SerialDispatcherP$0$signalSendDone = 9U
};
#line 152
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_signalSendDone[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone];
#line 269
enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4368 {
#line 269
  SerialDispatcherP$0$receiveTask = 10U
};
#line 269
typedef int /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_sillytask_receiveTask[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask];
#line 55
#line 51
typedef enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4369 {
  SerialDispatcherP$0$SEND_STATE_IDLE = 0, 
  SerialDispatcherP$0$SEND_STATE_BEGIN = 1, 
  SerialDispatcherP$0$SEND_STATE_DATA = 2
} /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$send_state_t;

enum /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4370 {
  SerialDispatcherP$0$RECV_STATE_IDLE = 0, 
  SerialDispatcherP$0$RECV_STATE_BEGIN = 1, 
  SerialDispatcherP$0$RECV_STATE_DATA = 2
};






#line 63
typedef struct /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$__nesc_unnamed4371 {
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
#line 152
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void);
#line 172
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void);
#line 188
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error);




static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void);



static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which);








static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void);




static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void);
#line 238
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b);
#line 269
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void);
#line 290
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result);
#line 349
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen);


static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen);




static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len);


static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error);
# 48 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x7e637768, uint16_t arg_0x7e6378f8);
# 83 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x7e719010);





static   void HdlcTranslateC$SerialFrameComm$putDone(void);
#line 74
static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void);
# 47 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
#line 44
typedef struct HdlcTranslateC$__nesc_unnamed4372 {
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
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$start(void);









static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$stop(void);
# 79 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receivedByte(uint8_t arg_0x7e635010);
#line 99
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receiveDone(uint8_t *arg_0x7e635ce0, uint16_t arg_0x7e635e70, error_t arg_0x7e633010);
#line 57
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$sendDone(uint8_t *arg_0x7e637f00, uint16_t arg_0x7e6360b0, error_t arg_0x7e636238);
# 46 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$tx(uint8_t arg_0x7e603068);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$start(void);









static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$stop(void);
# 56 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
 uint8_t */*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf;
#line 56
 uint8_t */*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_buf;
 uint16_t /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_len;
#line 57
 uint16_t /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_len;
 uint16_t /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_pos;
#line 58
 uint16_t /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_pos;
 uint16_t /*Atm128Uart0C.UartP*/Atm128UartP$0$m_byte_time;

static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$Init$init(void);







static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$start(void);





static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$stop(void);
#line 107
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$rxDone(uint8_t data);
#line 123
static   error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$send(uint8_t *buf, uint16_t len);
#line 139
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$txDone(void);
#line 174
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$overflow(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
static   void HplAtm128UartP$HplUart0$rxDone(uint8_t arg_0x7e603b30);
#line 47
static   void HplAtm128UartP$HplUart0$txDone(void);

static   void HplAtm128UartP$HplUart1$rxDone(uint8_t arg_0x7e603b30);
#line 47
static   void HplAtm128UartP$HplUart1$txDone(void);
# 60 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128Calibrate.nc"
static   uint16_t HplAtm128UartP$Atm128Calibrate$baudrateRegister(uint32_t arg_0x7ef53898);
# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
static   void HplAtm128UartP$McuPowerState$update(void);
# 87 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart0Init$init(void);
#line 107
static inline  error_t HplAtm128UartP$Uart0TxControl$start(void);






static inline  error_t HplAtm128UartP$Uart0TxControl$stop(void);






static inline  error_t HplAtm128UartP$Uart0RxControl$start(void);






static inline  error_t HplAtm128UartP$Uart0RxControl$stop(void);
#line 167
static   void HplAtm128UartP$HplUart0$tx(uint8_t data);






void __vector_18(void) __attribute((signal))   ;





void __vector_20(void) __attribute((interrupt))   ;



static inline  error_t HplAtm128UartP$Uart1Init$init(void);
#line 271
void __vector_30(void) __attribute((signal))   ;




void __vector_32(void) __attribute((interrupt))   ;





static inline    void HplAtm128UartP$HplUart1$default$txDone(void);
static inline    void HplAtm128UartP$HplUart1$default$rxDone(uint8_t data);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer3P$CompareA$fired(void);
# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void HplAtm128Timer3P$Capture$captured(HplAtm128Timer3P$Capture$size_type arg_0x7e55c120);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer3P$CompareB$fired(void);
#line 49
static   void HplAtm128Timer3P$CompareC$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void HplAtm128Timer3P$Timer$overflow(void);
# 47 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline   uint16_t HplAtm128Timer3P$Timer$get(void);


static inline   void HplAtm128Timer3P$Timer$set(uint16_t t);








static inline   void HplAtm128Timer3P$Timer$setScale(uint8_t s);









static inline   Atm128TimerCtrlCapture_t HplAtm128Timer3P$TimerCtrl$getCtrlCapture(void);









static inline uint16_t HplAtm128Timer3P$TimerCtrlCapture2int(Atm128TimerCtrlCapture_t x);






static inline   void HplAtm128Timer3P$TimerCtrl$setCtrlCapture(Atm128_TCCR3B_t x);
#line 127
static inline   void HplAtm128Timer3P$Timer$start(void);
#line 188
static inline    void HplAtm128Timer3P$CompareA$default$fired(void);
void __vector_26(void) __attribute((interrupt))   ;


static inline    void HplAtm128Timer3P$CompareB$default$fired(void);
void __vector_27(void) __attribute((interrupt))   ;


static inline    void HplAtm128Timer3P$CompareC$default$fired(void);
void __vector_28(void) __attribute((interrupt))   ;


static inline    void HplAtm128Timer3P$Capture$default$captured(uint16_t time);
void __vector_25(void) __attribute((interrupt))   ;



void __vector_29(void) __attribute((interrupt))   ;
# 95 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$setScale(uint8_t arg_0x7e9930f8);
#line 58
static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$set(/*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$timer_size arg_0x7e9953c0);










static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$start(void);
# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline  error_t /*InitThreeP.InitThree*/Atm128TimerInitC$0$Init$init(void);








static inline   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$overflow(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*CounterThree16C.NCounter*/Atm128CounterC$0$Counter$overflow(void);
# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   void /*CounterThree16C.NCounter*/Atm128CounterC$0$Timer$overflow(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*CounterMicro32C.Transform32*/TransformCounterC$0$Counter$overflow(void);
# 56 "/opt/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*CounterMicro32C.Transform32*/TransformCounterC$0$upper_count_type /*CounterMicro32C.Transform32*/TransformCounterC$0$m_upper;

enum /*CounterMicro32C.Transform32*/TransformCounterC$0$__nesc_unnamed4373 {

  TransformCounterC$0$LOW_SHIFT_RIGHT = 0, 
  TransformCounterC$0$HIGH_SHIFT_LEFT = 8 * sizeof(/*CounterMicro32C.Transform32*/TransformCounterC$0$from_size_type ) - /*CounterMicro32C.Transform32*/TransformCounterC$0$LOW_SHIFT_RIGHT, 
  TransformCounterC$0$NUM_UPPER_BITS = 8 * sizeof(/*CounterMicro32C.Transform32*/TransformCounterC$0$to_size_type ) - 8 * sizeof(/*CounterMicro32C.Transform32*/TransformCounterC$0$from_size_type ) + 0, 



  TransformCounterC$0$OVERFLOW_MASK = /*CounterMicro32C.Transform32*/TransformCounterC$0$NUM_UPPER_BITS ? ((/*CounterMicro32C.Transform32*/TransformCounterC$0$upper_count_type )2 << (/*CounterMicro32C.Transform32*/TransformCounterC$0$NUM_UPPER_BITS - 1)) - 1 : 0
};
#line 122
static inline   void /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$overflow(void);
# 40 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen);


static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void */*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x7eb54c58);
# 92 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 151
static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static  error_t /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err);







static inline  void */*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb20600);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 83
static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$postTask(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x7e7c1cd8);
#line 136
static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x7e7b7258);
# 118 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4374 {
#line 118
  AMQueueImplP$0$CancelTask = 11U
};
#line 118
typedef int /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_sillytask_CancelTask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask];
#line 161
enum /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4375 {
#line 161
  AMQueueImplP$0$errorTask = 12U
};
#line 161
typedef int /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_sillytask_errorTask[/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask];
#line 49
#line 47
typedef struct /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$__nesc_unnamed4376 {
  message_t *msg;
} /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t;

uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$current = 1;
/*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue_entry_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[1];
uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$cancelMask[1 / 8 + 1];

static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);

static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$nextPacket(void);
#line 82
static inline  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len);
#line 118
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$CancelTask$runTask(void);
#line 155
static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(uint8_t last, message_t *msg, error_t err);





static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$errorTask$runTask(void);




static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void);
#line 181
static inline  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(am_id_t id, message_t *msg, error_t err);
#line 203
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m);



static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t CC2420ActiveMessageP$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 49 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static  am_addr_t CC2420ActiveMessageP$amAddress(void);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void CC2420ActiveMessageP$AMSend$sendDone(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437398, 
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ActiveMessageP$Snoop$receive(
# 41 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e4354e0, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *CC2420ActiveMessageP$CC2420Packet$getHeader(message_t *arg_0x7e448670);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ActiveMessageP$Receive$receive(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
am_id_t arg_0x7e437cc8, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 54 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
enum CC2420ActiveMessageP$__nesc_unnamed4377 {
  CC2420ActiveMessageP$CC2420_SIZE = MAC_HEADER_SIZE + MAC_FOOTER_SIZE
};


static  error_t CC2420ActiveMessageP$AMSend$send(am_id_t id, am_addr_t addr, 
message_t *msg, 
uint8_t len);
#line 74
static inline  uint8_t CC2420ActiveMessageP$AMSend$maxPayloadLength(am_id_t id);



static inline  void *CC2420ActiveMessageP$AMSend$getPayload(am_id_t id, message_t *m);
#line 98
static inline  void CC2420ActiveMessageP$SubSend$sendDone(message_t *msg, error_t result);





static inline  message_t *CC2420ActiveMessageP$SubReceive$receive(message_t *msg, void *payload, uint8_t len);








static inline  am_addr_t CC2420ActiveMessageP$AMPacket$address(void);



static  am_addr_t CC2420ActiveMessageP$AMPacket$destination(message_t *amsg);




static  am_addr_t CC2420ActiveMessageP$AMPacket$source(message_t *amsg);




static  void CC2420ActiveMessageP$AMPacket$setDestination(message_t *amsg, am_addr_t addr);









static inline  bool CC2420ActiveMessageP$AMPacket$isForMe(message_t *amsg);




static  am_id_t CC2420ActiveMessageP$AMPacket$type(message_t *amsg);




static  void CC2420ActiveMessageP$AMPacket$setType(message_t *amsg, am_id_t type);




static inline   message_t *CC2420ActiveMessageP$Receive$default$receive(am_id_t id, message_t *msg, void *payload, uint8_t len);



static inline   message_t *CC2420ActiveMessageP$Snoop$default$receive(am_id_t id, message_t *msg, void *payload, uint8_t len);










static inline  uint8_t CC2420ActiveMessageP$Packet$payloadLength(message_t *msg);




static  void CC2420ActiveMessageP$Packet$setPayloadLength(message_t *msg, uint8_t len);



static inline  uint8_t CC2420ActiveMessageP$Packet$maxPayloadLength(void);



static  void *CC2420ActiveMessageP$Packet$getPayload(message_t *msg, uint8_t *len);
# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
static  void CC2420CsmaP$SplitControl$startDone(error_t arg_0x7ebf1af0);
#line 117
static  void CC2420CsmaP$SplitControl$stopDone(error_t arg_0x7ebf06e8);
# 94 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
static   void CC2420CsmaP$RadioBackoff$requestCca(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 94 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e441268);
#line 72
static   void CC2420CsmaP$RadioBackoff$requestInitialBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 72 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e4420a8);






static   void CC2420CsmaP$RadioBackoff$requestCongestionBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 79 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e442660);







static   void CC2420CsmaP$RadioBackoff$requestLplBackoff(
# 42 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
am_id_t arg_0x7e36c010, 
# 87 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
message_t *arg_0x7e442c18);
#line 56
static   void CC2420CsmaP$SubBackoff$setLplBackoff(uint16_t arg_0x7e444590);
#line 49
static   void CC2420CsmaP$SubBackoff$setCongestionBackoff(uint16_t arg_0x7e444010);
#line 43
static   void CC2420CsmaP$SubBackoff$setInitialBackoff(uint16_t arg_0x7e4459b0);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *CC2420CsmaP$CC2420Packet$getHeader(message_t *arg_0x7e448670);




static   cc2420_metadata_t *CC2420CsmaP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0);
# 49 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
static   error_t CC2420CsmaP$CC2420Transmit$send(message_t *arg_0x7e364d08, bool arg_0x7e364e90);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void CC2420CsmaP$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t CC2420CsmaP$Random$rand16(void);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t CC2420CsmaP$SubControl$start(void);
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
static   error_t CC2420CsmaP$CC2420Power$startOscillator(void);
#line 90
static   error_t CC2420CsmaP$CC2420Power$rxOn(void);
#line 51
static   error_t CC2420CsmaP$CC2420Power$startVReg(void);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420CsmaP$Resource$release(void);
#line 78
static   error_t CC2420CsmaP$Resource$request(void);
# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t CC2420CsmaP$AMPacket$address(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420CsmaP$sendDone_task$postTask(void);
#line 56
static   error_t CC2420CsmaP$startDone_task$postTask(void);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
enum CC2420CsmaP$__nesc_unnamed4378 {
#line 77
  CC2420CsmaP$startDone_task = 13U
};
#line 77
typedef int CC2420CsmaP$__nesc_sillytask_startDone_task[CC2420CsmaP$startDone_task];

enum CC2420CsmaP$__nesc_unnamed4379 {
#line 79
  CC2420CsmaP$stopDone_task = 14U
};
#line 79
typedef int CC2420CsmaP$__nesc_sillytask_stopDone_task[CC2420CsmaP$stopDone_task];
enum CC2420CsmaP$__nesc_unnamed4380 {
#line 80
  CC2420CsmaP$sendDone_task = 15U
};
#line 80
typedef int CC2420CsmaP$__nesc_sillytask_sendDone_task[CC2420CsmaP$sendDone_task];
#line 58
enum CC2420CsmaP$__nesc_unnamed4381 {
  CC2420CsmaP$S_PREINIT, 
  CC2420CsmaP$S_STOPPED, 
  CC2420CsmaP$S_STARTING, 
  CC2420CsmaP$S_STARTED, 
  CC2420CsmaP$S_STOPPING, 
  CC2420CsmaP$S_TRANSMIT
};

message_t *CC2420CsmaP$m_msg;

uint8_t CC2420CsmaP$m_state = CC2420CsmaP$S_PREINIT;

error_t CC2420CsmaP$sendErr = SUCCESS;


 bool CC2420CsmaP$ccaOn;








static inline  error_t CC2420CsmaP$Init$init(void);








static inline  error_t CC2420CsmaP$SplitControl$start(void);
#line 119
static inline  error_t CC2420CsmaP$Send$send(message_t *p_msg, uint8_t len);
#line 195
static inline   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *p_msg, error_t err);




static inline   void CC2420CsmaP$CC2420Power$startVRegDone(void);



static inline  void CC2420CsmaP$Resource$granted(void);



static inline   void CC2420CsmaP$CC2420Power$startOscillatorDone(void);




static   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *msg);







static inline   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *msg);







static inline   void CC2420CsmaP$SubBackoff$requestLplBackoff(message_t *msg);
#line 242
static inline  void CC2420CsmaP$sendDone_task$runTask(void);






static inline  void CC2420CsmaP$startDone_task$runTask(void);







static inline  void CC2420CsmaP$stopDone_task$runTask(void);
#line 274
static inline    void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(am_id_t amId, 
message_t *msg);


static inline    void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(am_id_t amId, 
message_t *msg);


static inline    void CC2420CsmaP$RadioBackoff$default$requestLplBackoff(am_id_t amId, 
message_t *msg);


static inline    void CC2420CsmaP$RadioBackoff$default$requestCca(am_id_t amId, 
message_t *msg);
# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Config.nc"
static  void CC2420ControlP$CC2420Config$syncDone(error_t arg_0x7e326b98);
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$RXCTRL1$write(uint16_t arg_0x7e30ca10);
# 55 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420ControlP$StartupTimer$start(CC2420ControlP$StartupTimer$size_type arg_0x7e9d48c8);
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$MDMCTRL0$write(uint16_t arg_0x7e30ca10);
# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ControlP$RSTN$makeOutput(void);
#line 29
static   void CC2420ControlP$RSTN$set(void);
static   void CC2420ControlP$RSTN$clr(void);
# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
static  void CC2420ControlP$ReadRssi$readDone(error_t arg_0x7eaf5668, CC2420ControlP$ReadRssi$val_t arg_0x7eaf57f0);
# 47 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$RSSI$read(uint16_t *arg_0x7e30c4a0);







static   cc2420_status_t CC2420ControlP$IOCFG0$write(uint16_t arg_0x7e30ca10);
# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ControlP$CSN$makeOutput(void);
#line 29
static   void CC2420ControlP$CSN$set(void);
static   void CC2420ControlP$CSN$clr(void);




static   void CC2420ControlP$VREN$makeOutput(void);
#line 29
static   void CC2420ControlP$VREN$set(void);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SXOSCON$strobe(void);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$SpiResource$release(void);
#line 78
static   error_t CC2420ControlP$SpiResource$request(void);
#line 110
static   error_t CC2420ControlP$SyncResource$release(void);
# 76 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
static   void CC2420ControlP$CC2420Power$startOscillatorDone(void);
#line 56
static   void CC2420ControlP$CC2420Power$startVRegDone(void);
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420ControlP$IOCFG1$write(uint16_t arg_0x7e30ca10);
#line 55
static   cc2420_status_t CC2420ControlP$FSCTRL$write(uint16_t arg_0x7e30ca10);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SRXON$strobe(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void CC2420ControlP$Resource$granted(void);
# 63 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Ram.nc"
static   cc2420_status_t CC2420ControlP$PANID$write(uint8_t arg_0x7e30f388, uint8_t *arg_0x7e30f530, uint8_t arg_0x7e30f6b8);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420ControlP$syncDone_task$postTask(void);
# 50 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t CC2420ControlP$InterruptCCA$disable(void);
#line 42
static   error_t CC2420ControlP$InterruptCCA$enableRisingEdge(void);
# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t CC2420ControlP$AMPacket$address(void);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ControlP$RssiResource$release(void);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420ControlP$SRFOFF$strobe(void);
# 99 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
enum CC2420ControlP$__nesc_unnamed4382 {
#line 99
  CC2420ControlP$syncDone_task = 16U
};
#line 99
typedef int CC2420ControlP$__nesc_sillytask_syncDone_task[CC2420ControlP$syncDone_task];
#line 84
#line 78
typedef enum CC2420ControlP$__nesc_unnamed4383 {
  CC2420ControlP$S_VREG_STOPPED, 
  CC2420ControlP$S_VREG_STARTING, 
  CC2420ControlP$S_VREG_STARTED, 
  CC2420ControlP$S_XOSC_STARTING, 
  CC2420ControlP$S_XOSC_STARTED
} CC2420ControlP$cc2420_control_state_t;

uint8_t CC2420ControlP$m_channel = 26;



uint16_t CC2420ControlP$m_pan = TOS_AM_GROUP;

uint16_t CC2420ControlP$m_short_addr;

bool CC2420ControlP$m_sync_busy;

 CC2420ControlP$cc2420_control_state_t CC2420ControlP$m_state = CC2420ControlP$S_VREG_STOPPED;





static inline  error_t CC2420ControlP$Init$init(void);
#line 119
static inline   error_t CC2420ControlP$Resource$request(void);







static inline   error_t CC2420ControlP$Resource$release(void);







static inline   error_t CC2420ControlP$CC2420Power$startVReg(void);
#line 155
static inline   error_t CC2420ControlP$CC2420Power$startOscillator(void);
#line 210
static inline   error_t CC2420ControlP$CC2420Power$rxOn(void);
#line 278
static inline  void CC2420ControlP$SyncResource$granted(void);
#line 304
static inline  void CC2420ControlP$SpiResource$granted(void);




static inline  void CC2420ControlP$RssiResource$granted(void);
#line 322
static inline   void CC2420ControlP$StartupTimer$fired(void);









static inline   void CC2420ControlP$InterruptCCA$fired(void);
#line 346
static inline  void CC2420ControlP$syncDone_task$runTask(void);





static inline   void CC2420ControlP$CC2420Config$default$syncDone(error_t error);


static inline   void CC2420ControlP$ReadRssi$default$readDone(error_t error, uint16_t data);
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
static   Atm128_TIFR_t HplAtm128Timer1P$Timer0Ctrl$getInterruptFlag(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer1P$CompareA$fired(void);
# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void HplAtm128Timer1P$Capture$captured(HplAtm128Timer1P$Capture$size_type arg_0x7e55c120);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void HplAtm128Timer1P$CompareB$fired(void);
#line 49
static   void HplAtm128Timer1P$CompareC$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void HplAtm128Timer1P$Timer$overflow(void);
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   uint16_t HplAtm128Timer1P$Timer$get(void);


static inline   void HplAtm128Timer1P$Timer$set(uint16_t t);








static inline   void HplAtm128Timer1P$Timer$setScale(uint8_t s);









static inline   Atm128TimerCtrlCapture_t HplAtm128Timer1P$TimerCtrl$getCtrlCapture(void);









static inline uint16_t HplAtm128Timer1P$TimerCtrlCapture2int(Atm128TimerCtrlCapture_t x);






static inline   void HplAtm128Timer1P$TimerCtrl$setCtrlCapture(Atm128_TCCR1B_t x);
#line 122
static inline   void HplAtm128Timer1P$Capture$setEdge(bool up);



static inline   void HplAtm128Timer1P$Capture$reset(void);
static inline   void HplAtm128Timer1P$CompareA$reset(void);



static inline   void HplAtm128Timer1P$Timer$start(void);
static inline   void HplAtm128Timer1P$Capture$start(void);
static inline   void HplAtm128Timer1P$CompareA$start(void);




static inline   void HplAtm128Timer1P$Capture$stop(void);
static inline   void HplAtm128Timer1P$CompareA$stop(void);




static inline   bool HplAtm128Timer1P$Timer$test(void);
#line 183
static inline   void HplAtm128Timer1P$CompareA$set(uint16_t t);
#line 195
void __vector_12(void) __attribute((interrupt))   ;


static inline    void HplAtm128Timer1P$CompareB$default$fired(void);
void __vector_13(void) __attribute((interrupt))   ;


static inline    void HplAtm128Timer1P$CompareC$default$fired(void);
void __vector_24(void) __attribute((interrupt))   ;



void __vector_11(void) __attribute((interrupt))   ;



void __vector_14(void) __attribute((interrupt))   ;
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$fired(void);
# 53 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$reset(void);
#line 45
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$set(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$size_type arg_0x7e981c38);










static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$start(void);


static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$stop(void);
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$timer_size /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$get(void);
# 65 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$stop(void);








static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size dt);
#line 110
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$fired(void);






static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$overflow(void);
# 95 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$setScale(uint8_t arg_0x7e9930f8);
#line 58
static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$set(/*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$timer_size arg_0x7e9953c0);










static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$start(void);
# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline  error_t /*InitOneP.InitOne*/Atm128TimerInitC$1$Init$init(void);








static inline   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$overflow(void);
# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   void /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$overflow(void);
# 78 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
static   bool /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$test(void);
#line 52
static   /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$get(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   /*CounterOne16C.NCounter*/Atm128CounterC$1$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$get(void);




static inline   bool /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$isOverflowPending(void);









static inline   void /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$overflow(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$get(void);






static   bool /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$isOverflowPending(void);










static   void /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$overflow(void);
# 56 "/opt/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
/*Counter32khz32C.Transform32*/TransformCounterC$1$upper_count_type /*Counter32khz32C.Transform32*/TransformCounterC$1$m_upper;

enum /*Counter32khz32C.Transform32*/TransformCounterC$1$__nesc_unnamed4384 {

  TransformCounterC$1$LOW_SHIFT_RIGHT = 0, 
  TransformCounterC$1$HIGH_SHIFT_LEFT = 8 * sizeof(/*Counter32khz32C.Transform32*/TransformCounterC$1$from_size_type ) - /*Counter32khz32C.Transform32*/TransformCounterC$1$LOW_SHIFT_RIGHT, 
  TransformCounterC$1$NUM_UPPER_BITS = 8 * sizeof(/*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type ) - 8 * sizeof(/*Counter32khz32C.Transform32*/TransformCounterC$1$from_size_type ) + 0, 



  TransformCounterC$1$OVERFLOW_MASK = /*Counter32khz32C.Transform32*/TransformCounterC$1$NUM_UPPER_BITS ? ((/*Counter32khz32C.Transform32*/TransformCounterC$1$upper_count_type )2 << (/*Counter32khz32C.Transform32*/TransformCounterC$1$NUM_UPPER_BITS - 1)) - 1 : 0
};

static   /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$get(void);
#line 122
static inline   void /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$overflow(void);
# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$fired(void);
#line 92
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$size_type arg_0x7e9d39e0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$size_type arg_0x7e9d3b70);
#line 62
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$stop(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$get(void);
# 66 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0;
/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt;

enum /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$__nesc_unnamed4385 {

  TransformAlarmC$0$MAX_DELAY_LOG2 = 8 * sizeof(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_size_type ) - 1 - 0, 
  TransformAlarmC$0$MAX_DELAY = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type )1 << /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$MAX_DELAY_LOG2
};

static inline   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$getNow(void);
#line 91
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$stop(void);




static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$set_alarm(void);
#line 136
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type dt);









static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type dt);




static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$fired(void);
#line 166
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$overflow(void);
# 22 "/opt/tinyos-2.x/tos/system/NoInitC.nc"
static inline  error_t NoInitC$Init$init(void);
# 50 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captured(uint16_t arg_0x7e124ab8);
# 79 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$setEdge(bool arg_0x7e55b710);
#line 55
static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$reset(void);


static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$start(void);


static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$stop(void);
# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$enableCapture(uint8_t mode);









static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureRisingEdge(void);



static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureFallingEdge(void);







static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$captured(uint16_t time);
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$clear(void);
#line 40
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$disable(void);
#line 59
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$edge(bool arg_0x7e0f14c8);
#line 35
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$enable(void);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$fired(void);
# 15 "/opt/tinyos-2.x/tos/chips/atm128/pins/Atm128GpioInterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$enable(bool rising);
#line 29
static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$enableFallingEdge(void);








static inline   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
static   void HplAtm128InterruptSigP$IntSig6$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig1$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig4$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig7$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig2$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig5$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig0$fired(void);
#line 41
static   void HplAtm128InterruptSigP$IntSig3$fired(void);
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSigP.nc"
void __vector_1(void) __attribute((signal))   ;




void __vector_2(void) __attribute((signal))   ;




void __vector_3(void) __attribute((signal))   ;




void __vector_4(void) __attribute((signal))   ;




void __vector_5(void) __attribute((signal))   ;




void __vector_6(void) __attribute((signal))   ;




void __vector_7(void) __attribute((signal))   ;




void __vector_8(void) __attribute((signal))   ;
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$fired(void);
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$clear(void);
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$enable(void);
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$disable(void);



static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$edge(bool low_to_high);
#line 61
static inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$IrqSignal$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$default$fired(void);
# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
static   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$fired(void);
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$IrqSignal$fired(void);

static inline    void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$default$fired(void);
# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void HplCC2420InterruptsP$CCATimer$startPeriodic(uint32_t arg_0x7eb13ce0);








static  void HplCC2420InterruptsP$CCATimer$startOneShot(uint32_t arg_0x7eb11338);




static  void HplCC2420InterruptsP$CCATimer$stop(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t HplCC2420InterruptsP$stopTask$postTask(void);
# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool HplCC2420InterruptsP$CC_CCA$get(void);
# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   void HplCC2420InterruptsP$CCA$fired(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t HplCC2420InterruptsP$CCATask$postTask(void);
# 97 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
enum HplCC2420InterruptsP$__nesc_unnamed4386 {
#line 97
  HplCC2420InterruptsP$CCATask = 17U
};
#line 97
typedef int HplCC2420InterruptsP$__nesc_sillytask_CCATask[HplCC2420InterruptsP$CCATask];
#line 123
enum HplCC2420InterruptsP$__nesc_unnamed4387 {
#line 123
  HplCC2420InterruptsP$stopTask = 18U
};
#line 123
typedef int HplCC2420InterruptsP$__nesc_sillytask_stopTask[HplCC2420InterruptsP$stopTask];
#line 77
 uint8_t HplCC2420InterruptsP$ccaWaitForState;
 uint8_t HplCC2420InterruptsP$ccaLastState;
bool HplCC2420InterruptsP$ccaTimerDisabled = FALSE;








static inline  void HplCC2420InterruptsP$Boot$booted(void);








static inline  void HplCC2420InterruptsP$CCATask$runTask(void);






static inline   error_t HplCC2420InterruptsP$CCA$enableRisingEdge(void);
#line 123
static inline void  HplCC2420InterruptsP$stopTask$runTask(void);






static inline   error_t HplCC2420InterruptsP$CCA$disable(void);








static inline  void HplCC2420InterruptsP$CCATimer$fired(void);
# 59 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   error_t CC2420SpiImplP$SpiPacket$send(uint8_t *arg_0x7e0157f0, uint8_t *arg_0x7e015998, uint16_t arg_0x7e015b28);
# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   void CC2420SpiImplP$Fifo$writeDone(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e0364c8, uint8_t arg_0x7e036650, error_t arg_0x7e0367d8);
#line 71
static   void CC2420SpiImplP$Fifo$readDone(
# 40 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01e068, 
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
uint8_t *arg_0x7e0383f0, uint8_t arg_0x7e038578, error_t arg_0x7e038700);
# 34 "/opt/tinyos-2.x/tos/interfaces/SpiByte.nc"
static   uint8_t CC2420SpiImplP$SpiByte$write(uint8_t arg_0x7e018088);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420SpiImplP$SpiResource$release(void);
#line 87
static   error_t CC2420SpiImplP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420SpiImplP$SpiResource$request(void);
#line 92
static  void CC2420SpiImplP$Resource$granted(
# 39 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
uint8_t arg_0x7e01f6b8);
#line 54
enum CC2420SpiImplP$__nesc_unnamed4388 {
  CC2420SpiImplP$RESOURCE_COUNT = 5U, 
  CC2420SpiImplP$NO_HOLDER = 0xff
};

 uint16_t CC2420SpiImplP$m_addr;
bool CC2420SpiImplP$m_resource_busy = FALSE;
uint8_t CC2420SpiImplP$m_requests = 0;
uint8_t CC2420SpiImplP$m_holder = CC2420SpiImplP$NO_HOLDER;

static inline   void CC2420SpiImplP$Resource$default$granted(uint8_t id);


static   error_t CC2420SpiImplP$Resource$request(uint8_t id);
#line 80
static   error_t CC2420SpiImplP$Resource$immediateRequest(uint8_t id);
#line 94
static   error_t CC2420SpiImplP$Resource$release(uint8_t id);
#line 127
static inline  void CC2420SpiImplP$SpiResource$granted(void);





static inline   cc2420_status_t CC2420SpiImplP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 153
static inline   error_t CC2420SpiImplP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len);




static inline   cc2420_status_t CC2420SpiImplP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len);
#line 202
static   void CC2420SpiImplP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error);






static   cc2420_status_t CC2420SpiImplP$Ram$write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len);
#line 233
static inline   cc2420_status_t CC2420SpiImplP$Reg$read(uint8_t addr, uint16_t *data);
#line 251
static   cc2420_status_t CC2420SpiImplP$Reg$write(uint8_t addr, uint16_t data);
#line 264
static   cc2420_status_t CC2420SpiImplP$Strobe$strobe(uint8_t addr);









static inline    void CC2420SpiImplP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error);
static inline    void CC2420SpiImplP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t Atm128SpiP$zeroTask$postTask(void);
# 71 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
static   void Atm128SpiP$SpiPacket$sendDone(uint8_t *arg_0x7e014290, uint8_t *arg_0x7e014438, uint16_t arg_0x7e0145c8, 
error_t arg_0x7e014760);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$ResourceArbiter$release(
# 84 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfb9bf0);
# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$ResourceArbiter$immediateRequest(
# 84 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfb9bf0);
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t Atm128SpiP$ResourceArbiter$request(
# 84 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfb9bf0);
# 72 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
static   void Atm128SpiP$Spi$sleep(void);
#line 66
static   void Atm128SpiP$Spi$initMaster(void);
#line 96
static   void Atm128SpiP$Spi$enableInterrupt(bool arg_0x7dfb2da0);
#line 80
static   uint8_t Atm128SpiP$Spi$read(void);
#line 125
static   void Atm128SpiP$Spi$setMasterDoubleSpeed(bool arg_0x7dfa0ee0);
#line 114
static   void Atm128SpiP$Spi$setClock(uint8_t arg_0x7dfa2d70);
#line 108
static   void Atm128SpiP$Spi$setClockPolarity(bool arg_0x7dfa3da0);
#line 86
static   void Atm128SpiP$Spi$write(uint8_t arg_0x7dfb2348);
#line 99
static   void Atm128SpiP$Spi$enableSpi(bool arg_0x7dfb1598);
#line 111
static   void Atm128SpiP$Spi$setClockPhase(bool arg_0x7dfa25a8);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void Atm128SpiP$Resource$granted(
# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
uint8_t arg_0x7dfbca68);
# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
static   void Atm128SpiP$McuPowerState$update(void);
# 80 "/opt/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
static   bool Atm128SpiP$ArbiterInfo$inUse(void);
# 207 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
enum Atm128SpiP$__nesc_unnamed4389 {
#line 207
  Atm128SpiP$zeroTask = 19U
};
#line 207
typedef int Atm128SpiP$__nesc_sillytask_zeroTask[Atm128SpiP$zeroTask];
#line 90
uint8_t *Atm128SpiP$txBuffer;
uint8_t *Atm128SpiP$rxBuffer;
uint16_t Atm128SpiP$len;
uint16_t Atm128SpiP$pos;

enum Atm128SpiP$__nesc_unnamed4390 {
  Atm128SpiP$SPI_IDLE, 
  Atm128SpiP$SPI_BUSY, 
  Atm128SpiP$SPI_ATOMIC_SIZE = 10
};




bool Atm128SpiP$started;

static void Atm128SpiP$startSpi(void);
#line 120
static inline void Atm128SpiP$stopSpi(void);








static   uint8_t Atm128SpiP$SpiByte$write(uint8_t tx);
#line 164
static error_t Atm128SpiP$sendNextPart(void);
#line 207
static inline  void Atm128SpiP$zeroTask$runTask(void);
#line 240
static   error_t Atm128SpiP$SpiPacket$send(uint8_t *writeBuf, 
uint8_t *readBuf, 
uint16_t bufLen);
#line 264
static inline   void Atm128SpiP$Spi$dataReady(uint8_t data);
#line 304
static inline   error_t Atm128SpiP$Resource$immediateRequest(uint8_t id);







static   error_t Atm128SpiP$Resource$request(uint8_t id);








static inline   error_t Atm128SpiP$Resource$release(uint8_t id);
#line 335
static inline  void Atm128SpiP$ResourceArbiter$granted(uint8_t id);



static inline   void Atm128SpiP$Resource$default$granted(uint8_t id);
# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void HplAtm128SpiP$MISO$makeInput(void);

static   void HplAtm128SpiP$SCK$makeOutput(void);
#line 35
static   void HplAtm128SpiP$SS$makeOutput(void);
#line 29
static   void HplAtm128SpiP$SS$set(void);
static   void HplAtm128SpiP$SS$clr(void);
# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
static   void HplAtm128SpiP$Mcu$update(void);
# 92 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
static   void HplAtm128SpiP$SPI$dataReady(uint8_t arg_0x7dfb2858);
# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void HplAtm128SpiP$MOSI$makeOutput(void);
# 79 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$initMaster(void);
#line 95
static inline   void HplAtm128SpiP$SPI$sleep(void);



static inline   uint8_t HplAtm128SpiP$SPI$read(void);
static inline   void HplAtm128SpiP$SPI$write(uint8_t d);


void __vector_17(void) __attribute((signal))   ;
#line 116
static   void HplAtm128SpiP$SPI$enableInterrupt(bool enabled);
#line 131
static   void HplAtm128SpiP$SPI$enableSpi(bool enabled);
#line 157
static inline   void HplAtm128SpiP$SPI$setMasterBit(bool isMaster);
#line 170
static inline   void HplAtm128SpiP$SPI$setClockPolarity(bool highWhenIdle);
#line 184
static inline   void HplAtm128SpiP$SPI$setClockPhase(bool sampleOnTrailing);
#line 201
static inline   void HplAtm128SpiP$SPI$setClock(uint8_t v);
#line 214
static inline   void HplAtm128SpiP$SPI$setMasterDoubleSpeed(bool on);
# 39 "/opt/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
enum /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$__nesc_unnamed4391 {
#line 39
  FcfsResourceQueueC$0$NO_ENTRY = 0xFF
};
uint8_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ[1U];
uint8_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
uint8_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qTail = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

static inline  error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$Init$init(void);




static inline   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void);



static inline   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t id);



static inline   resource_client_id_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void);
#line 72
static inline   error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t id);
# 43 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$requested(
# 52 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee23e8);
# 51 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$immediateRequested(
# 52 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee23e8);
# 55 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$unconfigure(
# 56 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee2ed0);
# 49 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$configure(
# 56 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee2ed0);
# 69 "/opt/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$enqueue(resource_client_id_t arg_0x7def8010);
#line 43
static   bool /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$isEmpty(void);
#line 60
static   resource_client_id_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$dequeue(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static  void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$granted(
# 51 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
uint8_t arg_0x7dee3a00);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$postTask(void);
# 69 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
enum /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$__nesc_unnamed4392 {
#line 69
  SimpleArbiterP$0$grantedTask = 20U
};
#line 69
typedef int /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$__nesc_sillytask_grantedTask[/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask];
#line 62
enum /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$__nesc_unnamed4393 {
#line 62
  SimpleArbiterP$0$RES_IDLE = 0, SimpleArbiterP$0$RES_GRANTING = 1, SimpleArbiterP$0$RES_BUSY = 2
};
#line 63
enum /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$__nesc_unnamed4394 {
#line 63
  SimpleArbiterP$0$NO_RES = 0xFF
};
uint8_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_IDLE;
 uint8_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$NO_RES;
 uint8_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$reqResId;



static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$request(uint8_t id);
#line 84
static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$immediateRequest(uint8_t id);
#line 97
static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$release(uint8_t id);
#line 123
static   bool /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ArbiterInfo$inUse(void);
#line 150
static inline  void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$runTask(void);
#line 162
static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$requested(uint8_t id);

static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id);

static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$configure(uint8_t id);

static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id);
# 72 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
static   void CC2420TransmitP$RadioBackoff$requestInitialBackoff(message_t *arg_0x7e4420a8);






static   void CC2420TransmitP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x7e442660);







static   void CC2420TransmitP$RadioBackoff$requestLplBackoff(message_t *arg_0x7e442c18);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$STXONCCA$strobe(void);
# 43 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
static   error_t CC2420TransmitP$CaptureSFD$captureFallingEdge(void);
#line 42
static   error_t CC2420TransmitP$CaptureSFD$captureRisingEdge(void);
# 55 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
static   void CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$BackoffTimer$size_type arg_0x7e9d48c8);






static   void CC2420TransmitP$BackoffTimer$stop(void);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *CC2420TransmitP$CC2420Packet$getHeader(message_t *arg_0x7e448670);




static   cc2420_metadata_t *CC2420TransmitP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0);
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420TransmitP$TXCTRL$write(uint16_t arg_0x7e30ca10);
# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
static   void CC2420TransmitP$CC2420Receive$sfd_dropped(void);
#line 47
static   void CC2420TransmitP$CC2420Receive$sfd(uint16_t arg_0x7de52aa8);
# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
static   void CC2420TransmitP$Send$sendDone(message_t *arg_0x7e35dd90, error_t arg_0x7e35df18);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$SFLUSHTX$strobe(void);
# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$CSN$makeOutput(void);
#line 29
static   void CC2420TransmitP$CSN$set(void);
static   void CC2420TransmitP$CSN$clr(void);
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
static   cc2420_status_t CC2420TransmitP$MDMCTRL1$write(uint16_t arg_0x7e30ca10);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420TransmitP$startLplTimer$postTask(void);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420TransmitP$SpiResource$release(void);
#line 87
static   error_t CC2420TransmitP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420TransmitP$SpiResource$request(void);
# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$CCA$makeInput(void);
#line 32
static   bool CC2420TransmitP$CCA$get(void);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$SNOP$strobe(void);
# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420TransmitP$SFD$makeInput(void);
#line 32
static   bool CC2420TransmitP$SFD$get(void);
# 39 "/opt/tinyos-2.x/tos/interfaces/RadioTimeStamping.nc"
static   void CC2420TransmitP$TimeStamp$transmittedSFD(uint16_t arg_0x7de73460, message_t *arg_0x7de73610);










static   void CC2420TransmitP$TimeStamp$receivedSFD(uint16_t arg_0x7de73b40);
# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   cc2420_status_t CC2420TransmitP$TXFIFO$write(uint8_t *arg_0x7e038cc8, uint8_t arg_0x7e038e50);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420TransmitP$STXON$strobe(void);
# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void CC2420TransmitP$LplDisableTimer$startOneShot(uint32_t arg_0x7eb11338);
# 137 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
enum CC2420TransmitP$__nesc_unnamed4395 {
#line 137
  CC2420TransmitP$startLplTimer = 21U
};
#line 137
typedef int CC2420TransmitP$__nesc_sillytask_startLplTimer[CC2420TransmitP$startLplTimer];
#line 87
#line 75
typedef enum CC2420TransmitP$__nesc_unnamed4396 {
  CC2420TransmitP$S_STOPPED, 
  CC2420TransmitP$S_STARTED, 
  CC2420TransmitP$S_LOAD, 
  CC2420TransmitP$S_SAMPLE_CCA, 
  CC2420TransmitP$S_BEGIN_TRANSMIT, 
  CC2420TransmitP$S_SFD, 
  CC2420TransmitP$S_EFD, 
  CC2420TransmitP$S_ACK_WAIT, 
  CC2420TransmitP$S_LOAD_CANCEL, 
  CC2420TransmitP$S_TX_CANCEL, 
  CC2420TransmitP$S_CCA_CANCEL
} CC2420TransmitP$cc2420_transmit_state_t;





enum CC2420TransmitP$__nesc_unnamed4397 {
  CC2420TransmitP$CC2420_ABORT_PERIOD = 320
};

 message_t *CC2420TransmitP$m_msg;

 bool CC2420TransmitP$m_cca;

 uint8_t CC2420TransmitP$m_tx_power;

CC2420TransmitP$cc2420_transmit_state_t CC2420TransmitP$m_state = CC2420TransmitP$S_STOPPED;

bool CC2420TransmitP$m_receiving = FALSE;

uint16_t CC2420TransmitP$m_prev_time;

bool CC2420TransmitP$signalSendDone;


 bool CC2420TransmitP$continuousModulation;


 int8_t CC2420TransmitP$totalCcaChecks;


 uint16_t CC2420TransmitP$myInitialBackoff;


 uint16_t CC2420TransmitP$myCongestionBackoff;


 uint16_t CC2420TransmitP$myLplBackoff;



static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca);

static void CC2420TransmitP$loadTXFIFO(void);
static void CC2420TransmitP$attemptSend(void);
static void CC2420TransmitP$congestionBackoff(void);
static error_t CC2420TransmitP$acquireSpiResource(void);
static inline error_t CC2420TransmitP$releaseSpiResource(void);
static void CC2420TransmitP$signalDone(error_t err);




static inline  error_t CC2420TransmitP$Init$init(void);







static inline  error_t CC2420TransmitP$StdControl$start(void);
#line 170
static inline   error_t CC2420TransmitP$Send$send(message_t *p_msg, bool useCca);
#line 216
static inline   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t backoffTime);







static inline   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t backoffTime);







static inline   void CC2420TransmitP$RadioBackoff$setLplBackoff(uint16_t backoffTime);
#line 263
static inline   void CC2420TransmitP$CaptureSFD$captured(uint16_t time);
#line 332
static inline   void CC2420TransmitP$CC2420Receive$receive(uint8_t type, message_t *ack_msg);
#line 358
static inline  void CC2420TransmitP$SpiResource$granted(void);
#line 401
static inline   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);
#line 444
static inline   void CC2420TransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error);










static inline   void CC2420TransmitP$BackoffTimer$fired(void);
#line 502
static inline  void CC2420TransmitP$LplDisableTimer$fired(void);
#line 514
static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca);
#line 592
static void CC2420TransmitP$attemptSend(void);
#line 685
static void CC2420TransmitP$congestionBackoff(void);
#line 698
static error_t CC2420TransmitP$acquireSpiResource(void);







static inline error_t CC2420TransmitP$releaseSpiResource(void);
#line 728
static void CC2420TransmitP$loadTXFIFO(void);
#line 754
static void CC2420TransmitP$signalDone(error_t err);







static inline  void CC2420TransmitP$startLplTimer$runTask(void);




static inline    void CC2420TransmitP$TimeStamp$default$transmittedSFD(uint16_t time, message_t *p_msg);


static inline    void CC2420TransmitP$TimeStamp$default$receivedSFD(uint16_t time);
# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool CC2420ReceiveP$FIFO$get(void);
# 58 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static   am_addr_t CC2420ReceiveP$amAddress(void);
# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   bool CC2420ReceiveP$FIFOP$get(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t CC2420ReceiveP$receiveDone_task$postTask(void);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *CC2420ReceiveP$CC2420Packet$getHeader(message_t *arg_0x7e448670);




static   cc2420_metadata_t *CC2420ReceiveP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0);
# 61 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
static   void CC2420ReceiveP$CC2420Receive$receive(uint8_t arg_0x7de51408, message_t *arg_0x7de515b8);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420ReceiveP$SACK$strobe(void);
# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
static   void CC2420ReceiveP$CSN$set(void);
static   void CC2420ReceiveP$CSN$clr(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *CC2420ReceiveP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
static   error_t CC2420ReceiveP$SpiResource$release(void);
#line 87
static   error_t CC2420ReceiveP$SpiResource$immediateRequest(void);
#line 78
static   error_t CC2420ReceiveP$SpiResource$request(void);
# 62 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
static   error_t CC2420ReceiveP$RXFIFO$continueRead(uint8_t *arg_0x7e039bf0, uint8_t arg_0x7e039d78);
#line 51
static   cc2420_status_t CC2420ReceiveP$RXFIFO$beginRead(uint8_t *arg_0x7e039458, uint8_t arg_0x7e0395e0);
# 43 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
static   error_t CC2420ReceiveP$InterruptFIFOP$enableFallingEdge(void);
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
static   cc2420_status_t CC2420ReceiveP$SFLUSHRX$strobe(void);
# 100 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
enum CC2420ReceiveP$__nesc_unnamed4398 {
#line 100
  CC2420ReceiveP$receiveDone_task = 22U
};
#line 100
typedef int CC2420ReceiveP$__nesc_sillytask_receiveDone_task[CC2420ReceiveP$receiveDone_task];
#line 68
#line 63
typedef enum CC2420ReceiveP$__nesc_unnamed4399 {
  CC2420ReceiveP$S_STOPPED, 
  CC2420ReceiveP$S_STARTED, 
  CC2420ReceiveP$S_RX_HEADER, 
  CC2420ReceiveP$S_RX_PAYLOAD
} CC2420ReceiveP$cc2420_receive_state_t;

enum CC2420ReceiveP$__nesc_unnamed4400 {
  CC2420ReceiveP$RXFIFO_SIZE = 128, 
  CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE = 8
};

uint16_t CC2420ReceiveP$m_timestamp_queue[CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE];

uint8_t CC2420ReceiveP$m_timestamp_head;

uint8_t CC2420ReceiveP$m_timestamp_size;

uint8_t CC2420ReceiveP$m_missed_packets;

bool CC2420ReceiveP$fallingEdgeEnabled;

 uint8_t CC2420ReceiveP$m_bytes_left;

 message_t *CC2420ReceiveP$m_p_rx_buf;

message_t CC2420ReceiveP$m_rx_buf;

CC2420ReceiveP$cc2420_receive_state_t CC2420ReceiveP$m_state;


static void CC2420ReceiveP$reset_state(void);
static void CC2420ReceiveP$beginReceive(void);
static void CC2420ReceiveP$receive(void);
static void CC2420ReceiveP$waitForNextPacket(void);
static void CC2420ReceiveP$flush(void);




static inline  error_t CC2420ReceiveP$Init$init(void);






static inline  error_t CC2420ReceiveP$StdControl$start(void);
#line 157
static inline   void CC2420ReceiveP$CC2420Receive$sfd(uint16_t time);








static inline   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void);







static inline   void CC2420ReceiveP$InterruptFIFOP$fired(void);










static inline  void CC2420ReceiveP$SpiResource$granted(void);








static inline   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error);
#line 281
static inline   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error);







static inline  void CC2420ReceiveP$receiveDone_task$runTask(void);
#line 309
static void CC2420ReceiveP$beginReceive(void);
#line 322
static void CC2420ReceiveP$flush(void);
#line 339
static void CC2420ReceiveP$receive(void);









static void CC2420ReceiveP$waitForNextPacket(void);
#line 374
static void CC2420ReceiveP$reset_state(void);
# 50 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420PacketC.nc"
static inline   cc2420_header_t *CC2420PacketC$CC2420Packet$getHeader(message_t *msg);



static inline   cc2420_metadata_t *CC2420PacketC$CC2420Packet$getMetadata(message_t *msg);



static inline   error_t CC2420PacketC$Acks$requestAck(message_t *p_msg);









static inline   bool CC2420PacketC$Acks$wasAcked(message_t *p_msg);
# 46 "/opt/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
am_addr_t ActiveMessageAddressC$addr = TOS_AM_ADDRESS;





static inline   am_addr_t ActiveMessageAddressC$amAddress(void);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t UniqueSendP$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *UniqueSendP$CC2420Packet$getHeader(message_t *arg_0x7e448670);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void UniqueSendP$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t UniqueSendP$Random$rand16(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/State.nc"
static   void UniqueSendP$State$toIdle(void);
#line 45
static   error_t UniqueSendP$State$requestState(uint8_t arg_0x7dd3b6f0);
# 54 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueSendP.nc"
uint8_t UniqueSendP$localSendId;

enum UniqueSendP$__nesc_unnamed4401 {
  UniqueSendP$S_IDLE, 
  UniqueSendP$S_SENDING
};


static inline  error_t UniqueSendP$Init$init(void);
#line 75
static inline  error_t UniqueSendP$Send$send(message_t *msg, uint8_t len);
#line 104
static inline  void UniqueSendP$SubSend$sendDone(message_t *msg, error_t error);
# 74 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
 uint8_t StateImplP$state[2U];

enum StateImplP$__nesc_unnamed4402 {
  StateImplP$S_IDLE = 0
};


static inline  error_t StateImplP$Init$init(void);
#line 96
static inline   error_t StateImplP$State$requestState(uint8_t id, uint8_t reqState);
#line 118
static inline   void StateImplP$State$toIdle(uint8_t id);
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
static   cc2420_header_t *UniqueReceiveP$CC2420Packet$getHeader(message_t *arg_0x7e448670);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *UniqueReceiveP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
#line 67
static  message_t *UniqueReceiveP$DuplicateReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 59 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueReceiveP.nc"
#line 56
struct UniqueReceiveP$__nesc_unnamed4403 {
  am_addr_t source;
  uint8_t dsn;
} UniqueReceiveP$receivedMessages[4];

uint8_t UniqueReceiveP$writeIndex = 0;


uint8_t UniqueReceiveP$recycleSourceElement;

enum UniqueReceiveP$__nesc_unnamed4404 {
  UniqueReceiveP$INVALID_ELEMENT = 0xFF
};


static inline  error_t UniqueReceiveP$Init$init(void);









static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn);
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn);
#line 104
static inline  message_t *UniqueReceiveP$SubReceive$receive(message_t *msg, void *payload, 
uint8_t len);
#line 130
static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn);
#line 156
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn);
#line 177
static inline   message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *msg, void *payload, uint8_t len);
# 54 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420LplDummyP.nc"
static inline  void CC2420LplDummyP$LowPowerListening$setLocalDutyCycle(uint16_t dutyCycle);
# 43 "/opt/tinyos-2.x/tos/lib/net/RootControl.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$RootControl$isRoot(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 112
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$maxPayloadLength(void);
# 50 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(uint8_t arg_0x7dc74e50);
#line 62
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(uint8_t arg_0x7dc67338, uint16_t arg_0x7dc674c8, am_addr_t arg_0x7dc67658, am_addr_t arg_0x7dc677e8);
# 57 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txAck(am_addr_t arg_0x7dc7b138);



static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txNoAck(am_addr_t arg_0x7dc7b5d0);
# 40 "/opt/tinyos-2.x/tos/interfaces/Cache.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$insert(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$t arg_0x7dc16088);







static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$lookup(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$t arg_0x7dc165e0);
# 31 "/opt/tinyos-2.x/tos/interfaces/Intercept.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$forward(
# 136 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc545c0, 
# 31 "/opt/tinyos-2.x/tos/interfaces/Intercept.nc"
message_t *arg_0x7dc9bdf0, void *arg_0x7dc9a010, uint16_t arg_0x7dc9a1a0);
# 81 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$isRunning(void);
#line 62
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$startOneShot(uint32_t arg_0x7eb11338);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$receive(
# 135 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc56e20, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Random$rand16(void);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$sendDone(
# 133 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc57c78, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 81 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$isRunning(void);
#line 62
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$startOneShot(uint32_t arg_0x7eb11338);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask(void);
# 73 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$head(void);
#line 90
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$enqueue(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t arg_0x7dc30d30);










static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$element(uint8_t arg_0x7dc2f330);
#line 65
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$maxSize(void);
#line 81
static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue(void);
#line 50
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$empty(void);







static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$size(void);
# 70 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$recomputeRoutes(void);
#line 58
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerRouteUpdate(void);
#line 51
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$getEtx(uint16_t *arg_0x7eb34478);
#line 65
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerImmediateRouteUpdate(void);









static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$setNeighborCongested(am_addr_t arg_0x7eb324d8, bool arg_0x7eb32668);




static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$isNeighborCongested(am_addr_t arg_0x7eb32b50);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 95
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$maxPayloadLength(void);
#line 83
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$receive(
# 134 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
collection_id_t arg_0x7dc56680, 
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 49 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$hasRoute(void);
#line 48
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$nextHop(void);
# 48 "/opt/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
static   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$requestAck(message_t *arg_0x7e7b46d8);
#line 74
static   bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$wasAcked(message_t *arg_0x7e7b3568);
# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$t */*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$get(void);
#line 61
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$empty(void);
#line 88
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$put(/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$t *arg_0x7dc2ab50);
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$source(message_t *arg_0x7e7c0360);
#line 57
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$address(void);









static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(message_t *arg_0x7e7c1cd8);
# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$t */*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$get(void);
#line 80
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$maxSize(void);
#line 61
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$empty(void);
#line 88
static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$put(/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$t *arg_0x7dc2ab50);
#line 72
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$size(void);
# 46 "/opt/tinyos-2.x/tos/lib/net/CollectionId.nc"
static  collection_id_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$fetch(
# 165 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
uint8_t arg_0x7dc157e8);
#line 259
enum /*CtpP.Forwarder*/CtpForwardingEngineP$0$__nesc_unnamed4405 {
#line 259
  CtpForwardingEngineP$0$sendTask = 23U
};
#line 259
typedef int /*CtpP.Forwarder*/CtpForwardingEngineP$0$__nesc_sillytask_sendTask[/*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask];
#line 175
static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(uint16_t mask, uint16_t offset);
inline static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startCongestionTimer(uint16_t mask, uint16_t offset);


bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientCongested = FALSE;


bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$parentCongested = FALSE;


uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$congestionThreshold;



bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$running = FALSE;



bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$radioOn = FALSE;




bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$ackPending = FALSE;



bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = FALSE;




am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$lastParent;



uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$seqno;

enum /*CtpP.Forwarder*/CtpForwardingEngineP$0$__nesc_unnamed4406 {
  CtpForwardingEngineP$0$CLIENT_COUNT = 1U
};






fe_queue_entry_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientEntries[/*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT];
fe_queue_entry_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[/*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT];







message_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsg;
message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr;

static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Init$init(void);
#line 247
static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$StdControl$start(void);
#line 264
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$startDone(error_t err);
#line 278
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$routeFound(void);



static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$noRoute(void);





static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$stopDone(error_t err);





static inline ctp_data_header_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(message_t *m);
#line 307
static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$send(uint8_t client, message_t *msg, uint8_t len);
#line 357
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$maxPayloadLength(uint8_t client);



static inline  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$getPayload(uint8_t client, message_t *msg);
#line 382
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$runTask(void);
#line 525
static inline void /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendDoneBug(void);
#line 541
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$sendDone(message_t *msg, error_t error);
#line 641
static inline message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$forward(message_t *m);
#line 728
static inline  message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len);
#line 811
static inline  message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSnoop$receive(message_t *msg, void *payload, uint8_t len);
#line 827
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$fired(void);




static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$fired(void);






static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpCongestion$isCongested(void);
#line 861
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(message_t *msg);



static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$setPayloadLength(message_t *msg, uint8_t len);



static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$maxPayloadLength(void);



static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(message_t *msg, uint8_t *len);







static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(message_t *msg);


static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(message_t *msg);






static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(message_t *msg);
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(message_t *msg);
static inline  uint16_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getEtx(message_t *msg);
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(message_t *msg);
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(message_t *msg);

static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setThl(message_t *msg, uint8_t thl);



static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$option(message_t *msg, ctp_options_t opt);



static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setOption(message_t *msg, ctp_options_t opt);



static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$clearOption(message_t *msg, ctp_options_t opt);



static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setEtx(message_t *msg, uint16_t e);





static inline  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$matchInstance(message_t *m1, message_t *m2);
#line 933
static inline   
#line 932
void 
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$default$sendDone(uint8_t client, message_t *msg, error_t error);



static inline   
#line 936
bool 
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$default$forward(collection_id_t collectid, message_t *msg, void *payload, 
uint16_t len);



static inline   message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$default$receive(collection_id_t collectid, message_t *msg, void *payload, 
uint8_t len);



static inline   message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$default$receive(collection_id_t collectid, message_t *msg, void *payload, 
uint8_t len);



static inline   collection_id_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$default$fetch(uint8_t client);



static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(uint16_t mask, uint16_t offset);







inline static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startCongestionTimer(uint16_t mask, uint16_t offset);








static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$evicted(am_addr_t neighbor);







static inline   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEvent(uint8_t type);








static inline   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEventMsg(uint8_t type, uint16_t msg, am_addr_t origin, am_addr_t node);
# 60 "/opt/tinyos-2.x/tos/system/PoolP.nc"
uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$free;
uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$index;
/*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t */*CtpP.MessagePoolP.PoolP*/PoolP$0$queue[12];
/*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool[12];

static inline  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Init$init(void);









static inline  bool /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$empty(void);


static inline  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$size(void);



static inline  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$maxSize(void);



static inline  /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t */*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$get(void);
#line 100
static  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$put(/*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t *newVal);
#line 60
uint8_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free;
uint8_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$index;
/*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t */*CtpP.QEntryPoolP.PoolP*/PoolP$1$queue[12];
/*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool[12];

static inline  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Init$init(void);









static inline  bool /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$empty(void);










static inline  /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t */*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$get(void);
#line 100
static  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$put(/*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t *newVal);
# 48 "/opt/tinyos-2.x/tos/system/QueueC.nc"
/*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$queue[13];
uint8_t /*CtpP.SendQueueP*/QueueC$0$head = 0;
uint8_t /*CtpP.SendQueueP*/QueueC$0$tail = 0;
uint8_t /*CtpP.SendQueueP*/QueueC$0$size = 0;

static inline  bool /*CtpP.SendQueueP*/QueueC$0$Queue$empty(void);



static inline  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$size(void);



static inline  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$maxSize(void);



static inline  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$head(void);



static inline void /*CtpP.SendQueueP*/QueueC$0$printQueue(void);
#line 85
static  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$dequeue(void);
#line 97
static  error_t /*CtpP.SendQueueP*/QueueC$0$Queue$enqueue(/*CtpP.SendQueueP*/QueueC$0$queue_t newVal);
#line 112
static inline  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$element(uint8_t idx);
# 59 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpPacket.nc"
static  am_addr_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getOrigin(message_t *arg_0x7dc86c90);
#line 53
static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getThl(message_t *arg_0x7dc87658);








static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getSequenceNumber(message_t *arg_0x7dc857e8);


static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getType(message_t *arg_0x7dc83358);
# 58 "/opt/tinyos-2.x/tos/lib/net/ctp/LruCtpMsgCacheP.nc"
#line 53
typedef struct /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$__nesc_unnamed4407 {
  am_addr_t origin;
  uint8_t seqno;
  collection_id_t type;
  uint8_t thl;
} /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$ctp_packet_sig_t;

/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$ctp_packet_sig_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[4];
uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first;
uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count;

static inline  error_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Init$init(void);
#line 84
static uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$lookup(message_t *m);
#line 100
static inline void /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$remove(uint8_t i);
#line 116
static inline  void /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$insert(message_t *m);
#line 135
static inline  bool /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$lookup(message_t *m);
# 67 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  void LinkEstimatorP$LinkEstimator$evicted(am_addr_t arg_0x7dc7bf00);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void LinkEstimatorP$Send$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
#line 69
static  error_t LinkEstimatorP$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t LinkEstimatorP$SubPacket$payloadLength(message_t *arg_0x7e7c7ee0);
#line 108
static  void *LinkEstimatorP$SubPacket$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500);
#line 95
static  uint8_t LinkEstimatorP$SubPacket$maxPayloadLength(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  message_t *LinkEstimatorP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198);
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t LinkEstimatorP$SubAMPacket$source(message_t *arg_0x7e7c0360);
#line 57
static  am_addr_t LinkEstimatorP$SubAMPacket$address(void);









static  am_addr_t LinkEstimatorP$SubAMPacket$destination(message_t *arg_0x7e7c1cd8);
# 55 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
enum LinkEstimatorP$__nesc_unnamed4408 {


  LinkEstimatorP$EVICT_EETX_THRESHOLD = 55, 

  LinkEstimatorP$MAX_AGE = 6, 


  LinkEstimatorP$MAX_PKT_GAP = 10, 
  LinkEstimatorP$BEST_EETX = 0, 
  LinkEstimatorP$INVALID_RVAL = 0xff, 
  LinkEstimatorP$INVALID_NEIGHBOR_ADDR = 0xff, 
  LinkEstimatorP$INFINITY = 0xff, 


  LinkEstimatorP$ALPHA = 2, 


  LinkEstimatorP$DLQ_PKT_WINDOW = 5, 


  LinkEstimatorP$BLQ_PKT_WINDOW = 3, 



  LinkEstimatorP$LARGE_EETX_VALUE = 60
};


neighbor_table_entry_t LinkEstimatorP$NeighborTable[10];

uint8_t LinkEstimatorP$linkEstSeq = 0;



uint8_t LinkEstimatorP$prevSentIdx = 0;


static inline linkest_header_t *LinkEstimatorP$getHeader(message_t *m);




static inline linkest_footer_t *LinkEstimatorP$getFooter(message_t *m, uint8_t len);






static inline uint8_t LinkEstimatorP$addLinkEstHeaderAndFooter(message_t *msg, uint8_t len);
#line 150
static void LinkEstimatorP$initNeighborIdx(uint8_t i, am_addr_t ll_addr);
#line 166
static uint8_t LinkEstimatorP$findIdx(am_addr_t ll_addr);
#line 179
static uint8_t LinkEstimatorP$findEmptyNeighborIdx(void);
#line 192
static uint8_t LinkEstimatorP$findWorstNeighborIdx(uint8_t thresholdEETX);
#line 226
static inline void LinkEstimatorP$updateReverseQuality(am_addr_t neighbor, uint8_t outquality);
#line 238
static void LinkEstimatorP$updateEETX(neighbor_table_entry_t *ne, uint16_t newEst);





static void LinkEstimatorP$updateDEETX(neighbor_table_entry_t *ne);
#line 280
static inline uint8_t LinkEstimatorP$computeBidirEETX(uint8_t q1, uint8_t q2);
#line 296
static inline void LinkEstimatorP$updateNeighborTableEst(am_addr_t n);
#line 347
static void LinkEstimatorP$updateNeighborEntryIdx(uint8_t idx, uint8_t seq);
#line 382
static void LinkEstimatorP$print_neighbor_table(void);
#line 396
static void LinkEstimatorP$print_packet(message_t *msg, uint8_t len);










static inline void LinkEstimatorP$initNeighborTable(void);







static inline  error_t LinkEstimatorP$StdControl$start(void);









static inline  error_t LinkEstimatorP$Init$init(void);






static  uint8_t LinkEstimatorP$LinkEstimator$getLinkQuality(am_addr_t neighbor);
#line 466
static inline  error_t LinkEstimatorP$LinkEstimator$insertNeighbor(am_addr_t neighbor);
#line 494
static  error_t LinkEstimatorP$LinkEstimator$pinNeighbor(am_addr_t neighbor);









static inline  error_t LinkEstimatorP$LinkEstimator$unpinNeighbor(am_addr_t neighbor);
#line 516
static  error_t LinkEstimatorP$LinkEstimator$txAck(am_addr_t neighbor);
#line 533
static inline  error_t LinkEstimatorP$LinkEstimator$txNoAck(am_addr_t neighbor);
#line 549
static inline  error_t LinkEstimatorP$LinkEstimator$clearDLQ(am_addr_t neighbor);
#line 564
static inline  error_t LinkEstimatorP$Send$send(am_addr_t addr, message_t *msg, uint8_t len);










static inline  void LinkEstimatorP$AMSend$sendDone(message_t *msg, error_t error);








static inline  uint8_t LinkEstimatorP$Send$maxPayloadLength(void);



static inline  void *LinkEstimatorP$Send$getPayload(message_t *msg);






static inline void LinkEstimatorP$processReceivedMessage(message_t *msg, void *payload, uint8_t len);
#line 678
static inline  message_t *LinkEstimatorP$SubReceive$receive(message_t *msg, 
void *payload, 
uint8_t len);







static inline  void *LinkEstimatorP$Receive$getPayload(message_t *msg, uint8_t *len);
#line 702
static inline  uint8_t LinkEstimatorP$Packet$payloadLength(message_t *msg);
#line 721
static inline  uint8_t LinkEstimatorP$Packet$maxPayloadLength(void);




static  void *LinkEstimatorP$Packet$getPayload(message_t *msg, uint8_t *len);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 101
static  uint8_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$maxPayloadLength(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 151
static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$sendDone(message_t *m, error_t err);



static inline  uint8_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$maxPayloadLength(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$send(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$getPayload(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40, 
# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
message_t *arg_0x7eb20600);
#line 112
static  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$maxPayloadLength(
# 40 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
am_id_t arg_0x7e48ab40);
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$sendDone(
# 38 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
uint8_t arg_0x7e48a1e0, 
# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
message_t *arg_0x7eb54010, error_t arg_0x7eb54198);
# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$payloadLength(message_t *arg_0x7e7c7ee0);
#line 83
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$postTask(void);
# 67 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$destination(message_t *arg_0x7e7c1cd8);
#line 136
static  am_id_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$type(message_t *arg_0x7e7b7258);
# 118 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
enum /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$__nesc_unnamed4409 {
#line 118
  AMQueueImplP$1$CancelTask = 24U
};
#line 118
typedef int /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$__nesc_sillytask_CancelTask[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask];
#line 161
enum /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$__nesc_unnamed4410 {
#line 161
  AMQueueImplP$1$errorTask = 25U
};
#line 161
typedef int /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$__nesc_sillytask_errorTask[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask];
#line 49
#line 47
typedef struct /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$__nesc_unnamed4411 {
  message_t *msg;
} /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue_entry_t;

uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = 4;
/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue_entry_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[4];
uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$cancelMask[4 / 8 + 1];

static void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$tryToSend(void);

static inline void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$nextPacket(void);
#line 82
static  error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len);
#line 118
static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask$runTask(void);
#line 155
static inline void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$sendDone(uint8_t last, message_t *msg, error_t err);





static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$runTask(void);




static void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$tryToSend(void);
#line 181
static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$sendDone(am_id_t id, message_t *msg, error_t err);
#line 199
static inline  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$maxPayloadLength(uint8_t id);



static inline  void */*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$getPayload(uint8_t id, message_t *m);



static   void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$default$sendDone(uint8_t id, message_t *msg, error_t err);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask(void);
# 68 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$logEventRoute(uint8_t arg_0x7dc67c90, am_addr_t arg_0x7dc67e20, uint8_t arg_0x7dc66010, uint16_t arg_0x7dc661a0);
# 50 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$pinNeighbor(am_addr_t arg_0x7dc7c7e8);
#line 47
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$insertNeighbor(am_addr_t arg_0x7dc7c348);
#line 64
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$clearDLQ(am_addr_t arg_0x7dc7ba70);
#line 53
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$unpinNeighbor(am_addr_t arg_0x7dc7cc88);
#line 38
static  uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$getLinkQuality(uint16_t arg_0x7dc7d4e8);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand16(void);
#line 35
static   uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand32(void);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$postTask(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void */*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$getPayload(message_t *arg_0x7eb20600);
#line 112
static  uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$maxPayloadLength(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getNow(void);
#line 140
static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getdt(void);
#line 133
static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$gett0(void);
#line 53
static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startPeriodic(uint32_t arg_0x7eb13ce0);








static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(uint32_t arg_0x7eb11338);




static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$stop(void);
#line 53
static  void /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$startPeriodic(uint32_t arg_0x7eb13ce0);
# 7 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpCongestion.nc"
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpCongestion$isCongested(void);
# 79 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
static  void */*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$getPayload(message_t *arg_0x7eb45a48, uint8_t *arg_0x7eb45bf0);
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$source(message_t *arg_0x7e7c0360);
#line 57
static  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$address(void);
# 51 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$Routing$routeFound(void);
static  void /*CtpP.Router*/CtpRoutingEngineP$0$Routing$noRoute(void);
# 267 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
enum /*CtpP.Router*/CtpRoutingEngineP$0$__nesc_unnamed4412 {
#line 267
  CtpRoutingEngineP$0$updateRouteTask = 26U
};
#line 267
typedef int /*CtpP.Router*/CtpRoutingEngineP$0$__nesc_sillytask_updateRouteTask[/*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask];
#line 385
enum /*CtpP.Router*/CtpRoutingEngineP$0$__nesc_unnamed4413 {
#line 385
  CtpRoutingEngineP$0$sendBeaconTask = 27U
};
#line 385
typedef int /*CtpP.Router*/CtpRoutingEngineP$0$__nesc_sillytask_sendBeaconTask[/*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask];
#line 122
bool /*CtpP.Router*/CtpRoutingEngineP$0$ECNOff = TRUE;



bool /*CtpP.Router*/CtpRoutingEngineP$0$radioOn = FALSE;


bool /*CtpP.Router*/CtpRoutingEngineP$0$running = FALSE;

bool /*CtpP.Router*/CtpRoutingEngineP$0$sending = FALSE;


bool /*CtpP.Router*/CtpRoutingEngineP$0$justEvicted = FALSE;

route_info_t /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo;
bool /*CtpP.Router*/CtpRoutingEngineP$0$state_is_root;
am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$my_ll_addr;

message_t /*CtpP.Router*/CtpRoutingEngineP$0$beaconMsgBuffer;
ctp_routing_header_t */*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg;


routing_table_entry /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[10];
uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive;


uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$parentChanges;


uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$routeUpdateTimerCount;


enum /*CtpP.Router*/CtpRoutingEngineP$0$__nesc_unnamed4414 {
  CtpRoutingEngineP$0$DEATH_TEST_INTERVAL = 1024 * 4 / (BEACON_INTERVAL / 1024)
};


static inline void /*CtpP.Router*/CtpRoutingEngineP$0$routingTableInit(void);
static uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(am_addr_t );
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableUpdateEntry(am_addr_t , am_addr_t , uint16_t );
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableEvict(am_addr_t neighbor);

uint16_t /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval = 1;
uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$t;
bool /*CtpP.Router*/CtpRoutingEngineP$0$tHasPassed;

static void /*CtpP.Router*/CtpRoutingEngineP$0$chooseAdvertiseTime(void);








static inline void /*CtpP.Router*/CtpRoutingEngineP$0$resetInterval(void);




static inline void /*CtpP.Router*/CtpRoutingEngineP$0$decayInterval(void);









static inline void /*CtpP.Router*/CtpRoutingEngineP$0$remainingInterval(void);







static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$Init$init(void);
#line 217
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$StdControl$start(void);
#line 234
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$startDone(error_t error);










static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$stopDone(error_t error);






static inline bool /*CtpP.Router*/CtpRoutingEngineP$0$passLinkEtxThreshold(uint16_t etx);






static inline uint16_t /*CtpP.Router*/CtpRoutingEngineP$0$evaluateEtx(uint8_t quality);







static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$runTask(void);
#line 385
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$runTask(void);
#line 427
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$sendDone(message_t *msg, error_t error);







static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$fired(void);





static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$fired(void);
#line 456
static inline ctp_routing_header_t */*CtpP.Router*/CtpRoutingEngineP$0$getHeader(message_t *m);






static inline  message_t */*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$receive(message_t *msg, void *payload, uint8_t len);
#line 514
static  void /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$evicted(am_addr_t neighbor);
#line 526
static inline  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$Routing$nextHop(void);


static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$Routing$hasRoute(void);




static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getParent(am_addr_t *parent);








static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getEtx(uint16_t *etx);








static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$recomputeRoutes(void);



static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerRouteUpdate(void);
#line 568
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerImmediateRouteUpdate(void);








static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$setNeighborCongested(am_addr_t n, bool congested);
#line 591
static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$isNeighborCongested(am_addr_t n);
#line 607
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$setRoot(void);
#line 632
static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$isRoot(void);
#line 654
static inline void /*CtpP.Router*/CtpRoutingEngineP$0$routingTableInit(void);





static uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(am_addr_t neighbor);
#line 672
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableUpdateEntry(am_addr_t from, am_addr_t parent, uint16_t etx);
#line 715
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableEvict(am_addr_t neighbor);
#line 744
static inline   error_t /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$default$logEventRoute(uint8_t type, am_addr_t parent, uint8_t hopcount, uint16_t etx);



static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpRoutingPacket$getOption(message_t *msg, ctp_options_t opt);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
# 92 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 151
static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$sendDone(message_t *m, error_t err);
# 50 "/opt/tinyos-2.x/tos/lib/net/CollectionIdP.nc"
static inline  collection_id_t /*OctopusAppC.CollectionSenderC.CollectionSenderP.CollectionIdP*/CollectionIdP$0$CollectionId$fetch(void);
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  error_t DisseminationEngineImplP$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0);
#line 125
static  void *DisseminationEngineImplP$AMSend$getPayload(message_t *arg_0x7eb20600);
#line 112
static  uint8_t DisseminationEngineImplP$AMSend$maxPayloadLength(void);
# 77 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void DisseminationEngineImplP$TrickleTimer$incrementCounter(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 72 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void DisseminationEngineImplP$TrickleTimer$reset(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 60 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  error_t DisseminationEngineImplP$TrickleTimer$start(
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d938688);
# 48 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void DisseminationEngineImplP$DisseminationCache$storeData(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0, 
# 48 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
void *arg_0x7d943e80, uint8_t arg_0x7d942030, uint32_t arg_0x7d9421c0);
static  uint32_t DisseminationEngineImplP$DisseminationCache$requestSeqno(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0);
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void *DisseminationEngineImplP$DisseminationCache$requestData(
# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d939bb0, 
# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
uint8_t *arg_0x7d9439c0);
# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
static  error_t DisseminationEngineImplP$DisseminatorControl$start(
# 51 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
uint16_t arg_0x7d937030);
#line 64
enum DisseminationEngineImplP$__nesc_unnamed4415 {
#line 64
  DisseminationEngineImplP$NUM_DISSEMINATORS = 1U
};
message_t DisseminationEngineImplP$m_buf;
bool DisseminationEngineImplP$m_running;
bool DisseminationEngineImplP$m_bufBusy;


static void DisseminationEngineImplP$sendObject(uint16_t key);

static inline  error_t DisseminationEngineImplP$StdControl$start(void);
#line 91
static inline  error_t DisseminationEngineImplP$DisseminationCache$start(uint16_t key);










static inline  void DisseminationEngineImplP$DisseminationCache$newData(uint16_t key);







static inline  void DisseminationEngineImplP$TrickleTimer$fired(uint16_t key);
#line 129
static void DisseminationEngineImplP$sendObject(uint16_t key);
#line 153
static inline  void DisseminationEngineImplP$ProbeAMSend$sendDone(message_t *msg, error_t error);



static inline  void DisseminationEngineImplP$AMSend$sendDone(message_t *msg, error_t error);



static inline  message_t *DisseminationEngineImplP$Receive$receive(message_t *msg, 
void *payload, 
uint8_t len);
#line 217
static inline  message_t *DisseminationEngineImplP$ProbeReceive$receive(message_t *msg, 
void *payload, 
uint8_t len);
#line 234
static inline   void *
DisseminationEngineImplP$DisseminationCache$default$requestData(uint16_t key, uint8_t *size);


static inline   
#line 237
void 
DisseminationEngineImplP$DisseminationCache$default$storeData(uint16_t key, void *data, 
uint8_t size, 
uint32_t seqno);


static inline   
#line 242
uint32_t 
DisseminationEngineImplP$DisseminationCache$default$requestSeqno(uint16_t key);

static inline   error_t DisseminationEngineImplP$TrickleTimer$default$start(uint16_t key);



static inline   void DisseminationEngineImplP$TrickleTimer$default$reset(uint16_t key);

static inline   void DisseminationEngineImplP$TrickleTimer$default$incrementCounter(uint16_t key);

static inline   error_t DisseminationEngineImplP$DisseminatorControl$default$start(uint16_t id);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  error_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010);
#line 114
static  void */*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$getPayload(message_t *arg_0x7eb54c58);
#line 101
static  uint8_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$maxPayloadLength(void);
# 92 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8);
#line 151
static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968);
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len);









static inline  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$sendDone(message_t *m, error_t err);



static inline  uint8_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$maxPayloadLength(void);



static inline  void */*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$getPayload(message_t *m);
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
static  void /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38);
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$Send$sendDone(message_t *m, error_t err);
# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$newData(void);
#line 45
static  error_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$start(void);
# 61 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$changed(void);
# 55 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$valueCache;
bool /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$m_running;



uint32_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno = DISSEMINATION_SEQNO_UNKNOWN;

static inline  error_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$StdControl$start(void);
#line 74
static inline  const /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$get(void);







static inline  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$change(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t *newVal);
#line 94
static inline  void */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestData(uint8_t *size);




static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$storeData(void *data, uint8_t size, 
uint32_t newSeqno);





static inline  uint32_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestSeqno(void);
# 34 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clearAll(void);
#line 58
static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clear(uint16_t arg_0x7d8b7510);
#line 46
static   bool /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$get(uint16_t arg_0x7d8b8a68);





static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$set(uint16_t arg_0x7d8b7010);
#line 34
static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clearAll(void);
#line 58
static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clear(uint16_t arg_0x7d8b7510);
#line 46
static   bool /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$get(uint16_t arg_0x7d8b8a68);





static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$set(uint16_t arg_0x7d8b7010);
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
static   uint16_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Random$rand16(void);
# 82 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$fired(
# 50 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
uint8_t arg_0x7d8c0f00);
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static   error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$postTask(void);
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getNow(void);
#line 140
static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getdt(void);
#line 133
static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$gett0(void);
#line 62
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$startOneShot(uint32_t arg_0x7eb11338);




static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$stop(void);
# 146 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
enum /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$__nesc_unnamed4416 {
#line 146
  TrickleTimerImplP$0$timerTask = 28U
};
#line 146
typedef int /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$__nesc_sillytask_timerTask[/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask];
#line 67
#line 62
typedef struct /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$__nesc_unnamed4417 {
  uint16_t period;
  uint32_t time;
  uint32_t remainder;
  uint8_t count;
} /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickle_t;

/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickle_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[1U];

static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer(void);
static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(uint8_t id);

static inline  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Init$init(void);
#line 92
static inline  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$start(uint8_t id);
#line 122
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$reset(uint8_t id);
#line 142
static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$incrementCounter(uint8_t id);



static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$runTask(void);
#line 168
static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$fired(void);
#line 203
static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer(void);
#line 246
static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(uint8_t id);
#line 270
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$default$fired(uint8_t id);
# 40 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
typedef uint8_t /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$int_type;

enum /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$__nesc_unnamed4418 {

  BitVectorC$0$ELEMENT_SIZE = 8 * sizeof(/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$int_type ), 
  BitVectorC$0$ARRAY_SIZE = (1U + /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$ELEMENT_SIZE - 1) / /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$ELEMENT_SIZE
};

/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$int_type /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$ARRAY_SIZE];

static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getIndex(uint16_t bitnum);




static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getMask(uint16_t bitnum);










static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clearAll(void);









static inline   bool /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$get(uint16_t bitnum);




static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$set(uint16_t bitnum);




static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clear(uint16_t bitnum);
#line 40
typedef uint8_t /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$int_type;

enum /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$__nesc_unnamed4419 {

  BitVectorC$1$ELEMENT_SIZE = 8 * sizeof(/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$int_type ), 
  BitVectorC$1$ARRAY_SIZE = (1U + /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$ELEMENT_SIZE - 1) / /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$ELEMENT_SIZE
};

/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$int_type /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$ARRAY_SIZE];

static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getIndex(uint16_t bitnum);




static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getMask(uint16_t bitnum);










static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clearAll(void);









static inline   bool /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$get(uint16_t bitnum);




static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$set(uint16_t bitnum);




static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clear(uint16_t bitnum);
# 86 "/opt/tinyos-2.x/tos/chips/atm128/atm128hardware.h"
static __inline void __nesc_disable_interrupt(void)
#line 86
{
   __asm volatile ("cli");}

#line 103
 
#line 102
__inline __nesc_atomic_t 
__nesc_atomic_start(void )
{
  __nesc_atomic_t result = * (volatile uint8_t *)(0x3F + 0x20);

#line 106
  __nesc_disable_interrupt();
  return result;
}



 
#line 111
__inline void 
__nesc_atomic_end(__nesc_atomic_t original_SREG)
{
  * (volatile uint8_t *)(0x3F + 0x20) = original_SREG;
}

# 113 "/opt/tinyos-2.x/tos/system/SchedulerBasicP.nc"
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
# 18 "/opt/tinyos-2.x/tos/platforms/aquisgrain/PlatformP.nc"
static inline void PlatformP$power_init(void)
#line 18
{
  /* atomic removed: atomic calls only */
#line 19
  {
    * (volatile uint8_t *)(0x35 + 0x20) = 1 << 5;
  }
}

# 49 "/opt/tinyos-2.x/tos/types/TinyError.h"
static inline error_t ecombine(error_t r1, error_t r2)




{
  return r1 == r2 ? r1 : FAIL;
}

# 79 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline uint16_t HplAtm128Timer3P$TimerCtrlCapture2int(Atm128TimerCtrlCapture_t x)
#line 79
{
#line 79
  union __nesc_unnamed4420 {
#line 79
    Atm128TimerCtrlCapture_t f;
#line 79
    uint16_t t;
  } 
#line 79
  c = { .f = x };

#line 79
  return c.t;
}





static inline   void HplAtm128Timer3P$TimerCtrl$setCtrlCapture(Atm128_TCCR3B_t x)
#line 86
{
  * (volatile uint8_t *)0x8A = HplAtm128Timer3P$TimerCtrlCapture2int(x);
}

#line 69
static inline   Atm128TimerCtrlCapture_t HplAtm128Timer3P$TimerCtrl$getCtrlCapture(void)
#line 69
{
  return * (Atm128TimerCtrlCapture_t *)& * (volatile uint8_t *)0x8A;
}

#line 59
static inline   void HplAtm128Timer3P$Timer$setScale(uint8_t s)
#line 59
{
  Atm128TimerCtrlCapture_t x = HplAtm128Timer3P$TimerCtrl$getCtrlCapture();

#line 61
  x.bits.cs = s;
  HplAtm128Timer3P$TimerCtrl$setCtrlCapture(x);
}

# 95 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$setScale(uint8_t arg_0x7e9930f8){
#line 95
  HplAtm128Timer3P$Timer$setScale(arg_0x7e9930f8);
#line 95
}
#line 95
# 127 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline   void HplAtm128Timer3P$Timer$start(void)
#line 127
{
#line 127
  * (volatile uint8_t *)0x7D |= 1 << 2;
}

# 69 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$start(void){
#line 69
  HplAtm128Timer3P$Timer$start();
#line 69
}
#line 69
# 50 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline   void HplAtm128Timer3P$Timer$set(uint16_t t)
#line 50
{
#line 50
  * (volatile uint16_t *)0x88 = t;
}

# 58 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$set(/*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$timer_size arg_0x7e9953c0){
#line 58
  HplAtm128Timer3P$Timer$set(arg_0x7e9953c0);
#line 58
}
#line 58
# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline  error_t /*InitThreeP.InitThree*/Atm128TimerInitC$0$Init$init(void)
#line 42
{
  /* atomic removed: atomic calls only */
#line 43
  {
    /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$set(0);
    /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$start();
    /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$setScale(2);
  }
  return SUCCESS;
}

# 81 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline uint16_t HplAtm128Timer1P$TimerCtrlCapture2int(Atm128TimerCtrlCapture_t x)
#line 81
{
#line 81
  union __nesc_unnamed4421 {
#line 81
    Atm128TimerCtrlCapture_t f;
#line 81
    uint16_t t;
  } 
#line 81
  c = { .f = x };

#line 81
  return c.t;
}





static inline   void HplAtm128Timer1P$TimerCtrl$setCtrlCapture(Atm128_TCCR1B_t x)
#line 88
{
  * (volatile uint8_t *)(0x2E + 0x20) = HplAtm128Timer1P$TimerCtrlCapture2int(x);
}

#line 71
static inline   Atm128TimerCtrlCapture_t HplAtm128Timer1P$TimerCtrl$getCtrlCapture(void)
#line 71
{
  return * (Atm128TimerCtrlCapture_t *)& * (volatile uint8_t *)(0x2E + 0x20);
}

#line 61
static inline   void HplAtm128Timer1P$Timer$setScale(uint8_t s)
#line 61
{
  Atm128TimerCtrlCapture_t x = HplAtm128Timer1P$TimerCtrl$getCtrlCapture();

#line 63
  x.bits.cs = s;
  HplAtm128Timer1P$TimerCtrl$setCtrlCapture(x);
}

# 95 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$setScale(uint8_t arg_0x7e9930f8){
#line 95
  HplAtm128Timer1P$Timer$setScale(arg_0x7e9930f8);
#line 95
}
#line 95
# 131 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Timer$start(void)
#line 131
{
#line 131
  * (volatile uint8_t *)(0x37 + 0x20) |= 1 << 2;
}

# 69 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$start(void){
#line 69
  HplAtm128Timer1P$Timer$start();
#line 69
}
#line 69
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Timer$set(uint16_t t)
#line 52
{
#line 52
  * (volatile uint16_t *)(0x2C + 0x20) = t;
}

# 58 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$set(/*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$timer_size arg_0x7e9953c0){
#line 58
  HplAtm128Timer1P$Timer$set(arg_0x7e9953c0);
#line 58
}
#line 58
# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline  error_t /*InitOneP.InitOne*/Atm128TimerInitC$1$Init$init(void)
#line 42
{
  /* atomic removed: atomic calls only */
#line 43
  {
    /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$set(0);
    /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$start();
    /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$setScale(4);
  }
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t MotePlatformP$SubInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*InitOneP.InitOne*/Atm128TimerInitC$1$Init$init();
#line 51
  result = ecombine(result, /*InitThreeP.InitThree*/Atm128TimerInitC$0$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)59U &= ~(1 << 4);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void MotePlatformP$SerialIdPin$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$clr();
#line 30
}
#line 30
# 50 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$makeInput(void)
#line 50
{
#line 50
  * (volatile uint8_t *)58U &= ~(1 << 4);
}

# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void MotePlatformP$SerialIdPin$makeInput(void){
#line 33
  /*HplAtm128GeneralIOC.PortA.Bit4*/HplAtm128GeneralIOPinP$4$IO$makeInput();
#line 33
}
#line 33
# 26 "/opt/tinyos-2.x/tos/platforms/aquisgrain/MotePlatformP.nc"
static inline  error_t MotePlatformP$PlatformInit$init(void)
#line 26
{





  MotePlatformP$SerialIdPin$makeInput();
  MotePlatformP$SerialIdPin$clr();

  return MotePlatformP$SubInit$init();
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$MoteInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = MotePlatformP$PlatformInit$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 41 "/opt/tinyos-2.x/tos/platforms/aquisgrain/MeasureClockC.nc"
static inline  error_t MeasureClockC$Init$init(void)
#line 41
{
  /* atomic removed: atomic calls only */



  {
    uint8_t now;
#line 47
    uint8_t wraps;
    uint16_t start;


    * (volatile uint8_t *)(0x2E + 0x20) = 1 << 0;
    * (volatile uint8_t *)(0x30 + 0x20) = 1 << 3;
    * (volatile uint8_t *)(0x33 + 0x20) = (1 << 1) | (1 << 0);




    start = * (volatile uint16_t *)(0x2C + 0x20);
    for (wraps = MeasureClockC$MAGIC / 2; wraps; ) 
      {
        uint16_t next = * (volatile uint16_t *)(0x2C + 0x20);

        if (next < start) {
          wraps--;
          }
#line 65
        start = next;
      }


    now = * (volatile uint8_t *)(0x32 + 0x20);
    while (* (volatile uint8_t *)(0x32 + 0x20) == now) ;


    start = * (volatile uint16_t *)(0x2C + 0x20);
    now = * (volatile uint8_t *)(0x32 + 0x20);
    while (* (volatile uint8_t *)(0x32 + 0x20) == now) ;
    MeasureClockC$cycles = * (volatile uint16_t *)(0x2C + 0x20);

    MeasureClockC$cycles = (MeasureClockC$cycles - start + 16) >> 5;


    * (volatile uint8_t *)(0x30 + 0x20) = * (volatile uint8_t *)(0x2E + 0x20) = * (volatile uint8_t *)(0x33 + 0x20) = 0;
    * (volatile uint8_t *)(0x32 + 0x20) = 0;
    * (volatile uint16_t *)(0x2C + 0x20) = 0;
    * (volatile uint8_t *)0x7C = * (volatile uint8_t *)(0x36 + 0x20) = 0xff;
    while (* (volatile uint8_t *)(0x30 + 0x20) & (((1 << 2) | (1 << 1)) | (1 << 0))) 
      ;
  }
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t PlatformP$MeasureClock$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = MeasureClockC$Init$init();
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)59U |= 1 << 0;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$set();
#line 29
}
#line 29
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)59U |= 1 << 1;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$set();
#line 29
}
#line 29
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)59U |= 1 << 2;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$set();
#line 29
}
#line 29
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)58U |= 1 << 0;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)58U |= 1 << 1;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)58U |= 1 << 2;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$makeOutput();
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
# 25 "/opt/tinyos-2.x/tos/platforms/aquisgrain/PlatformP.nc"
static inline  error_t PlatformP$Init$init(void)
#line 25
{
  error_t ok;

#line 27
  PlatformP$LedsInit$init();



  ok = PlatformP$MeasureClock$init();
  ok = ecombine(ok, PlatformP$MoteInit$init());

  if (ok != SUCCESS) {
    return ok;
    }
  PlatformP$power_init();
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
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 110 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  void DisseminationEngineImplP$TrickleTimer$fired(uint16_t key)
#line 110
{

  if (!DisseminationEngineImplP$m_running || DisseminationEngineImplP$m_bufBusy) {
#line 112
      return;
    }
  DisseminationEngineImplP$sendObject(key);
}

# 270 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$default$fired(uint8_t id)
#line 270
{
  return;
}

# 82 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
inline static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$fired(uint8_t arg_0x7d8c0f00){
#line 82
  switch (arg_0x7d8c0f00) {
#line 82
    case /*OctopusAppC.DisseminatorC*/DisseminatorC$0$TIMER_ID:
#line 82
      DisseminationEngineImplP$TrickleTimer$fired(42);
#line 82
      break;
#line 82
    default:
#line 82
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$default$fired(arg_0x7d8c0f00);
#line 82
      break;
#line 82
    }
#line 82
}
#line 82
# 55 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getMask(uint16_t bitnum)
{
  return 1 << bitnum % /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$ELEMENT_SIZE;
}

#line 50
static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getIndex(uint16_t bitnum)
{
  return bitnum / /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$ELEMENT_SIZE;
}

#line 86
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clear(uint16_t bitnum)
{
  /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getIndex(bitnum)] &= ~/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getMask(bitnum);
}

# 58 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clear(uint16_t arg_0x7d8b7510){
#line 58
  /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clear(arg_0x7d8b7510);
#line 58
}
#line 58
# 76 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   bool /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$get(uint16_t bitnum)
{
  return /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getIndex(bitnum)] & /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getMask(bitnum) ? TRUE : FALSE;
}

# 46 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   bool /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$get(uint16_t arg_0x7d8b8a68){
#line 46
  unsigned char result;
#line 46

#line 46
  result = /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$get(arg_0x7d8b8a68);
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 146 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$runTask(void)
#line 146
{
  uint8_t i;

#line 148
  for (i = 0; i < 1U; i++) {
      bool fire = FALSE;

#line 150
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 150
        {
          if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$get(i)) {
              /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clear(i);
              fire = TRUE;
            }
        }
#line 155
        __nesc_atomic_end(__nesc_atomic); }
      if (fire) {
          ;
          /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$fired(i);
          /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$postTask();
          return;
        }
    }
}

# 78 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline  void *CC2420ActiveMessageP$AMSend$getPayload(am_id_t id, message_t *m)
#line 78
{
  return CC2420ActiveMessageP$Packet$getPayload(m, (void *)0);
}

# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void */*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$getPayload(am_id_t arg_0x7e48ab40, message_t *arg_0x7eb20600){
#line 125
  void *result;
#line 125

#line 125
  result = CC2420ActiveMessageP$AMSend$getPayload(arg_0x7e48ab40, arg_0x7eb20600);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 203 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void */*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$getPayload(uint8_t id, message_t *m)
#line 203
{
  return /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$getPayload(0, m);
}

# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void */*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$getPayload(message_t *arg_0x7eb54c58){
#line 114
  void *result;
#line 114

#line 114
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$getPayload(2U, arg_0x7eb54c58);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 65 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void */*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$getPayload(message_t *m)
#line 65
{
  return /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$getPayload(m);
}

# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void *DisseminationEngineImplP$AMSend$getPayload(message_t *arg_0x7eb20600){
#line 125
  void *result;
#line 125

#line 125
  result = /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$getPayload(arg_0x7eb20600);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 94 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static inline  void */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestData(uint8_t *size)
#line 94
{
  *size = sizeof(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t );
  return &/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$valueCache;
}

# 234 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   void *
DisseminationEngineImplP$DisseminationCache$default$requestData(uint16_t key, uint8_t *size)
#line 235
{
#line 235
  return (void *)0;
}

# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
inline static  void *DisseminationEngineImplP$DisseminationCache$requestData(uint16_t arg_0x7d939bb0, uint8_t *arg_0x7d9439c0){
#line 47
  void *result;
#line 47

#line 47
  switch (arg_0x7d939bb0) {
#line 47
    case 42:
#line 47
      result = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestData(arg_0x7d9439c0);
#line 47
      break;
#line 47
    default:
#line 47
      result = DisseminationEngineImplP$DisseminationCache$default$requestData(arg_0x7d939bb0, arg_0x7d9439c0);
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
# 176 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline  uint8_t CC2420ActiveMessageP$Packet$maxPayloadLength(void)
#line 176
{
  return 28;
}

#line 74
static inline  uint8_t CC2420ActiveMessageP$AMSend$maxPayloadLength(am_id_t id)
#line 74
{
  return CC2420ActiveMessageP$Packet$maxPayloadLength();
}

# 112 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$maxPayloadLength(am_id_t arg_0x7e48ab40){
#line 112
  unsigned char result;
#line 112

#line 112
  result = CC2420ActiveMessageP$AMSend$maxPayloadLength(arg_0x7e48ab40);
#line 112

#line 112
  return result;
#line 112
}
#line 112
# 199 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$maxPayloadLength(uint8_t id)
#line 199
{
  return /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$maxPayloadLength(0);
}

# 101 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  uint8_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$maxPayloadLength(void){
#line 101
  unsigned char result;
#line 101

#line 101
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$maxPayloadLength(2U);
#line 101

#line 101
  return result;
#line 101
}
#line 101
# 61 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  uint8_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$maxPayloadLength(void)
#line 61
{
  return /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$maxPayloadLength();
}

# 112 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  uint8_t DisseminationEngineImplP$AMSend$maxPayloadLength(void){
#line 112
  unsigned char result;
#line 112

#line 112
  result = /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$maxPayloadLength();
#line 112

#line 112
  return result;
#line 112
}
#line 112
# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(2U, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 151 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968){
#line 151
  CC2420ActiveMessageP$AMPacket$setType(arg_0x7e7b77e0, arg_0x7e7b7968);
#line 151
}
#line 151
#line 92
inline static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8){
#line 92
  CC2420ActiveMessageP$AMPacket$setDestination(arg_0x7e7c0928, arg_0x7e7c0ab8);
#line 92
}
#line 92
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setDestination(msg, dest);
  /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMPacket$setType(msg, 13);
  return /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$send(msg, len);
}

# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t DisseminationEngineImplP$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$send(arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 83 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8){
#line 83
  CC2420ActiveMessageP$Packet$setPayloadLength(arg_0x7e7c6570, arg_0x7e7c66f8);
#line 83
}
#line 83
# 136 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_id_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$type(message_t *arg_0x7e7b7258){
#line 136
  unsigned char result;
#line 136

#line 136
  result = CC2420ActiveMessageP$AMPacket$type(arg_0x7e7b7258);
#line 136

#line 136
  return result;
#line 136
}
#line 136
#line 67
inline static  am_addr_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$destination(message_t *arg_0x7e7c1cd8){
#line 67
  unsigned int result;
#line 67

#line 67
  result = CC2420ActiveMessageP$AMPacket$destination(arg_0x7e7c1cd8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$send(am_id_t arg_0x7e48ab40, am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = CC2420ActiveMessageP$AMSend$send(arg_0x7e48ab40, arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 251 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_hton_leuint8(void *target, uint8_t value)
#line 251
{
  uint8_t *base = target;

#line 253
  base[0] = value;
  return value;
}

# 118 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
static inline   void StateImplP$State$toIdle(uint8_t id)
#line 118
{
  StateImplP$state[id] = StateImplP$S_IDLE;
}

# 56 "/opt/tinyos-2.x/tos/interfaces/State.nc"
inline static   void UniqueSendP$State$toIdle(void){
#line 56
  StateImplP$State$toIdle(0U);
#line 56
}
#line 56
# 246 "/usr/lib/ncc/nesc_nx.h"
static __inline uint8_t __nesc_ntoh_leuint8(const void *source)
#line 246
{
  const uint8_t *base = source;

#line 248
  return base[0];
}

#line 269
static __inline uint16_t __nesc_hton_uint16(void *target, uint16_t value)
#line 269
{
  uint8_t *base = target;

#line 271
  base[1] = value;
  base[0] = value >> 8;
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

#line 281
static __inline uint16_t __nesc_hton_leuint16(void *target, uint16_t value)
#line 281
{
  uint8_t *base = target;

#line 283
  base[0] = value;
  base[1] = value >> 8;
  return value;
}

#line 276
static __inline uint16_t __nesc_ntoh_leuint16(const void *source)
#line 276
{
  const uint8_t *base = source;

#line 278
  return ((uint16_t )base[1] << 8) | base[0];
}

# 514 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP$send(message_t *p_msg, bool cca)
#line 514
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 515
    {


      if ((
#line 516
      CC2420TransmitP$m_state == CC2420TransmitP$S_LOAD_CANCEL
       || CC2420TransmitP$m_state == CC2420TransmitP$S_CCA_CANCEL)
       || CC2420TransmitP$m_state == CC2420TransmitP$S_TX_CANCEL) {
          {
            unsigned char __nesc_temp = 
#line 519
            ECANCEL;

            {
#line 519
              __nesc_atomic_end(__nesc_atomic); 
#line 519
              return __nesc_temp;
            }
          }
        }
#line 522
      if (CC2420TransmitP$m_state != CC2420TransmitP$S_STARTED) {
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
#line 526
      CC2420TransmitP$m_state = CC2420TransmitP$S_LOAD;
      CC2420TransmitP$m_cca = cca;
      CC2420TransmitP$m_msg = p_msg;
      CC2420TransmitP$totalCcaChecks = 0;
    }
#line 530
    __nesc_atomic_end(__nesc_atomic); }

  if (CC2420TransmitP$acquireSpiResource() == SUCCESS) {
      CC2420TransmitP$loadTXFIFO();
    }

  return SUCCESS;
}

#line 170
static inline   error_t CC2420TransmitP$Send$send(message_t *p_msg, bool useCca)
#line 170
{
  return CC2420TransmitP$send(p_msg, useCca);
}

# 49 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
inline static   error_t CC2420CsmaP$CC2420Transmit$send(message_t *arg_0x7e364d08, bool arg_0x7e364e90){
#line 49
  unsigned char result;
#line 49

#line 49
  result = CC2420TransmitP$Send$send(arg_0x7e364d08, arg_0x7e364e90);
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 286 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestCca(am_id_t amId, 
message_t *msg)
#line 287
{
}

# 94 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestCca(am_id_t arg_0x7e36c010, message_t *arg_0x7e441268){
#line 94
    CC2420CsmaP$RadioBackoff$default$requestCca(arg_0x7e36c010, arg_0x7e441268);
#line 94
}
#line 94
# 52 "/opt/tinyos-2.x/tos/system/ActiveMessageAddressC.nc"
static inline   am_addr_t ActiveMessageAddressC$amAddress(void)
#line 52
{
  return ActiveMessageAddressC$addr;
}

# 49 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
inline static  am_addr_t CC2420ActiveMessageP$amAddress(void){
#line 49
  unsigned int result;
#line 49

#line 49
  result = ActiveMessageAddressC$amAddress();
#line 49

#line 49
  return result;
#line 49
}
#line 49
#line 113
static inline  am_addr_t CC2420ActiveMessageP$AMPacket$address(void)
#line 113
{
  return CC2420ActiveMessageP$amAddress();
}

# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t CC2420CsmaP$AMPacket$address(void){
#line 57
  unsigned int result;
#line 57

#line 57
  result = CC2420ActiveMessageP$AMPacket$address();
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 54 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420PacketC.nc"
static inline   cc2420_metadata_t *CC2420PacketC$CC2420Packet$getMetadata(message_t *msg)
#line 54
{
  return (cc2420_metadata_t *)msg->metadata;
}

# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_metadata_t *CC2420CsmaP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0){
#line 82
  nx_struct cc2420_metadata_t *result;
#line 82

#line 82
  result = CC2420PacketC$CC2420Packet$getMetadata(arg_0x7e448bc0);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 50 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420PacketC.nc"
static inline   cc2420_header_t *CC2420PacketC$CC2420Packet$getHeader(message_t *msg)
#line 50
{
  return (cc2420_header_t *)(msg->data - sizeof(cc2420_header_t ));
}

# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_header_t *CC2420CsmaP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 119 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  error_t CC2420CsmaP$Send$send(message_t *p_msg, uint8_t len)
#line 119
{
  unsigned char *__nesc_temp47;
  unsigned char *__nesc_temp46;
#line 121
  cc2420_header_t *header = CC2420CsmaP$CC2420Packet$getHeader(p_msg);
  cc2420_metadata_t *metadata = CC2420CsmaP$CC2420Packet$getMetadata(p_msg);

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 124
    {
      if (CC2420CsmaP$m_state != CC2420CsmaP$S_STARTED) 
        {
          unsigned char __nesc_temp = 
#line 126
          FAIL;

          {
#line 126
            __nesc_atomic_end(__nesc_atomic); 
#line 126
            return __nesc_temp;
          }
        }
#line 127
      CC2420CsmaP$m_state = CC2420CsmaP$S_TRANSMIT;
      CC2420CsmaP$m_msg = p_msg;
    }
#line 129
    __nesc_atomic_end(__nesc_atomic); }

  __nesc_hton_leuint8((unsigned char *)&header->length, len);
  (__nesc_temp46 = (unsigned char *)&header->fcf, __nesc_hton_leuint16(__nesc_temp46, __nesc_ntoh_leuint16(__nesc_temp46) & (1 << IEEE154_FCF_ACK_REQ)));
  (__nesc_temp47 = (unsigned char *)&header->fcf, __nesc_hton_leuint16(__nesc_temp47, __nesc_ntoh_leuint16(__nesc_temp47) | ((((IEEE154_TYPE_DATA << IEEE154_FCF_FRAME_TYPE) | (
  1 << IEEE154_FCF_INTRAPAN)) | (
  IEEE154_ADDR_SHORT << IEEE154_FCF_DEST_ADDR_MODE)) | (
  IEEE154_ADDR_SHORT << IEEE154_FCF_SRC_ADDR_MODE))));
  __nesc_hton_leuint16((unsigned char *)&header->src, CC2420CsmaP$AMPacket$address());
  __nesc_hton_int8((unsigned char *)&metadata->ack, FALSE);
  __nesc_hton_uint8((unsigned char *)&metadata->rssi, 0);
  __nesc_hton_uint8((unsigned char *)&metadata->lqi, 0);
  __nesc_hton_uint16((unsigned char *)&metadata->time, 0);

  CC2420CsmaP$ccaOn = TRUE;
  CC2420CsmaP$RadioBackoff$requestCca(__nesc_ntoh_leuint8((unsigned char *)&((cc2420_header_t *)(CC2420CsmaP$m_msg->data - 
  sizeof(cc2420_header_t )))->type), CC2420CsmaP$m_msg);
  CC2420CsmaP$CC2420Transmit$send(CC2420CsmaP$m_msg, CC2420CsmaP$ccaOn);
  return SUCCESS;
}

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t UniqueSendP$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = CC2420CsmaP$Send$send(arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_header_t *UniqueSendP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 96 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
static inline   error_t StateImplP$State$requestState(uint8_t id, uint8_t reqState)
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

# 45 "/opt/tinyos-2.x/tos/interfaces/State.nc"
inline static   error_t UniqueSendP$State$requestState(uint8_t arg_0x7dd3b6f0){
#line 45
  unsigned char result;
#line 45

#line 45
  result = StateImplP$State$requestState(0U, arg_0x7dd3b6f0);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 75 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueSendP.nc"
static inline  error_t UniqueSendP$Send$send(message_t *msg, uint8_t len)
#line 75
{
  error_t error;

#line 77
  if (UniqueSendP$State$requestState(UniqueSendP$S_SENDING) == SUCCESS) {
      __nesc_hton_leuint8((unsigned char *)&UniqueSendP$CC2420Packet$getHeader(msg)->dsn, UniqueSendP$localSendId++);

      if ((error = UniqueSendP$SubSend$send(msg, len)) != SUCCESS) {
          UniqueSendP$State$toIdle();
        }

      return error;
    }

  return EBUSY;
}

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t CC2420ActiveMessageP$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = UniqueSendP$Send$send(arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiImplP$Resource$immediateRequest(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 166 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$configure(uint8_t id)
#line 166
{
}

# 49 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$configure(uint8_t arg_0x7dee2ed0){
#line 49
    /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$configure(arg_0x7dee2ed0);
#line 49
}
#line 49
# 164 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$immediateRequested(uint8_t id)
#line 164
{
}

# 51 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$immediateRequested(uint8_t arg_0x7dee23e8){
#line 51
    /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$immediateRequested(arg_0x7dee23e8);
#line 51
}
#line 51
# 84 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$immediateRequest(uint8_t id)
#line 84
{
  /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$immediateRequested(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId);
  /* atomic removed: atomic calls only */
#line 86
  {
    if (/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state == /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_IDLE) {
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_BUSY;
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId = id;
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$configure(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId);
        {
          unsigned char __nesc_temp = 
#line 91
          SUCCESS;

#line 91
          return __nesc_temp;
        }
      }
#line 93
    {
      unsigned char __nesc_temp = 
#line 93
      FAIL;

#line 93
      return __nesc_temp;
    }
  }
}

# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t Atm128SpiP$ResourceArbiter$immediateRequest(uint8_t arg_0x7dfb9bf0){
#line 87
  unsigned char result;
#line 87

#line 87
  result = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$immediateRequest(arg_0x7dfb9bf0);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 304 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline   error_t Atm128SpiP$Resource$immediateRequest(uint8_t id)
#line 304
{
  error_t result = Atm128SpiP$ResourceArbiter$immediateRequest(id);

#line 306
  if (result == SUCCESS) {
      Atm128SpiP$startSpi();
    }
  return result;
}

# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420SpiImplP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = Atm128SpiP$Resource$immediateRequest(0U);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 109 "/opt/tinyos-2.x/tos/chips/atm128/McuSleepC.nc"
static inline   void McuSleepC$McuPowerState$update(void)
#line 109
{
}

# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
inline static   void HplAtm128SpiP$Mcu$update(void){
#line 44
  McuSleepC$McuPowerState$update();
#line 44
}
#line 44
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)56U &= ~(1 << 0);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$SS$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr();
#line 30
}
#line 30
# 157 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$setMasterBit(bool isMaster)
#line 157
{
  if (isMaster) {
      * (volatile uint8_t *)(0x0D + 0x20) |= 1 << 4;
    }
  else {
      * (volatile uint8_t *)(0x0D + 0x20) &= ~(1 << 4);
    }
}

# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)55U |= 1 << 0;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$SS$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit1*/HplAtm128GeneralIOPinP$9$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)55U |= 1 << 1;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$SCK$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit1*/HplAtm128GeneralIOPinP$9$IO$makeOutput();
#line 35
}
#line 35
# 50 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit3*/HplAtm128GeneralIOPinP$11$IO$makeInput(void)
#line 50
{
#line 50
  * (volatile uint8_t *)55U &= ~(1 << 3);
}

# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$MISO$makeInput(void){
#line 33
  /*HplAtm128GeneralIOC.PortB.Bit3*/HplAtm128GeneralIOPinP$11$IO$makeInput();
#line 33
}
#line 33
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit2*/HplAtm128GeneralIOPinP$10$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)55U |= 1 << 2;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$MOSI$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit2*/HplAtm128GeneralIOPinP$10$IO$makeOutput();
#line 35
}
#line 35
# 79 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$initMaster(void)
#line 79
{
  HplAtm128SpiP$MOSI$makeOutput();
  HplAtm128SpiP$MISO$makeInput();
  HplAtm128SpiP$SCK$makeOutput();
  HplAtm128SpiP$SS$makeOutput();
  HplAtm128SpiP$SPI$setMasterBit(TRUE);
  HplAtm128SpiP$SS$clr();
}

# 66 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$initMaster(void){
#line 66
  HplAtm128SpiP$SPI$initMaster();
#line 66
}
#line 66
# 214 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$setMasterDoubleSpeed(bool on)
#line 214
{
  if (on) {
      * (volatile uint8_t *)(0x0E + 0x20) |= 1 << 0;
    }
  else {
      * (volatile uint8_t *)(0x0E + 0x20) &= ~(1 << 0);
    }
}

# 125 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$setMasterDoubleSpeed(bool arg_0x7dfa0ee0){
#line 125
  HplAtm128SpiP$SPI$setMasterDoubleSpeed(arg_0x7dfa0ee0);
#line 125
}
#line 125
# 170 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$setClockPolarity(bool highWhenIdle)
#line 170
{
  if (highWhenIdle) {
      * (volatile uint8_t *)(0x0D + 0x20) |= 1 << 3;
    }
  else {
      * (volatile uint8_t *)(0x0D + 0x20) &= ~(1 << 3);
    }
}

# 108 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$setClockPolarity(bool arg_0x7dfa3da0){
#line 108
  HplAtm128SpiP$SPI$setClockPolarity(arg_0x7dfa3da0);
#line 108
}
#line 108
# 184 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$setClockPhase(bool sampleOnTrailing)
#line 184
{
  if (sampleOnTrailing) {
      * (volatile uint8_t *)(0x0D + 0x20) |= 1 << 2;
    }
  else {
      * (volatile uint8_t *)(0x0D + 0x20) &= ~(1 << 2);
    }
}

# 111 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$setClockPhase(bool arg_0x7dfa25a8){
#line 111
  HplAtm128SpiP$SPI$setClockPhase(arg_0x7dfa25a8);
#line 111
}
#line 111
# 201 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$setClock(uint8_t v)
#line 201
{
  v &= 1 | 0;
  * (volatile uint8_t *)(0x0D + 0x20) = (* (volatile uint8_t *)(0x0D + 0x20) & ~(1 | 0)) | v;
}

# 114 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$setClock(uint8_t arg_0x7dfa2d70){
#line 114
  HplAtm128SpiP$SPI$setClock(arg_0x7dfa2d70);
#line 114
}
#line 114
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiImplP$Resource$request(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
inline static   error_t CC2420SpiImplP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = Atm128SpiP$Resource$request(0U);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 54 "/opt/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(resource_client_id_t id)
#line 54
{
  return /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ[id] != /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY || /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qTail == id;
}

#line 72
static inline   error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(resource_client_id_t id)
#line 72
{
  /* atomic removed: atomic calls only */
#line 73
  {
    if (!/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEnqueued(id)) {
        if (/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead == /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
          /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead = id;
          }
        else {
#line 78
          /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ[/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qTail] = id;
          }
#line 79
        /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qTail = id;
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

# 69 "/opt/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$enqueue(resource_client_id_t arg_0x7def8010){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$enqueue(arg_0x7def8010);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 162 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$requested(uint8_t id)
#line 162
{
}

# 43 "/opt/tinyos-2.x/tos/interfaces/ResourceRequested.nc"
inline static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$requested(uint8_t arg_0x7dee23e8){
#line 43
    /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$default$requested(arg_0x7dee23e8);
#line 43
}
#line 43
# 71 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$request(uint8_t id)
#line 71
{
  /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceRequested$requested(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId);
  /* atomic removed: atomic calls only */
#line 73
  {
    if (/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state == /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_IDLE) {
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_GRANTING;
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$reqResId = id;
        /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$postTask();
        {
          unsigned char __nesc_temp = 
#line 78
          SUCCESS;

#line 78
          return __nesc_temp;
        }
      }
#line 80
    {
      unsigned char __nesc_temp = 
#line 80
      /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$enqueue(id);

#line 80
      return __nesc_temp;
    }
  }
}

# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t Atm128SpiP$ResourceArbiter$request(uint8_t arg_0x7dfb9bf0){
#line 78
  unsigned char result;
#line 78

#line 78
  result = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$request(arg_0x7dfb9bf0);
#line 78

#line 78
  return result;
#line 78
}
#line 78
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

# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
inline static   cc2420_status_t CC2420TransmitP$TXCTRL$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_TXCTRL, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 100 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$write(uint8_t d)
#line 100
{
#line 100
  * (volatile uint8_t *)(0x0F + 0x20) = d;
}

# 86 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$write(uint8_t arg_0x7dfb2348){
#line 86
  HplAtm128SpiP$SPI$write(arg_0x7dfb2348);
#line 86
}
#line 86
# 59 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   error_t CC2420SpiImplP$SpiPacket$send(uint8_t *arg_0x7e0157f0, uint8_t *arg_0x7e015998, uint16_t arg_0x7e015b28){
#line 59
  unsigned char result;
#line 59

#line 59
  result = Atm128SpiP$SpiPacket$send(arg_0x7e0157f0, arg_0x7e015998, arg_0x7e015b28);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 34 "/opt/tinyos-2.x/tos/interfaces/SpiByte.nc"
inline static   uint8_t CC2420SpiImplP$SpiByte$write(uint8_t arg_0x7e018088){
#line 34
  unsigned char result;
#line 34

#line 34
  result = Atm128SpiP$SpiByte$write(arg_0x7e018088);
#line 34

#line 34
  return result;
#line 34
}
#line 34
# 159 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline   cc2420_status_t CC2420SpiImplP$Fifo$write(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 160
{

  uint8_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 164
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 166
            status;

            {
#line 166
              __nesc_atomic_end(__nesc_atomic); 
#line 166
              return __nesc_temp;
            }
          }
        }
    }
#line 170
    __nesc_atomic_end(__nesc_atomic); }
#line 170
  CC2420SpiImplP$m_addr = addr;

  status = CC2420SpiImplP$SpiByte$write(CC2420SpiImplP$m_addr);
  CC2420SpiImplP$SpiPacket$send(data, (void *)0, len);

  return status;
}

# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
inline static   cc2420_status_t CC2420TransmitP$TXFIFO$write(uint8_t *arg_0x7e038cc8, uint8_t arg_0x7e038e50){
#line 82
  unsigned char result;
#line 82

#line 82
  result = CC2420SpiImplP$Fifo$write(CC2420_TXFIFO, arg_0x7e038cc8, arg_0x7e038e50);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t Atm128SpiP$zeroTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(Atm128SpiP$zeroTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
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

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 278 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$routeFound(void)
#line 278
{
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
}

# 51 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$Routing$routeFound(void){
#line 51
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$routeFound();
#line 51
}
#line 51
# 282 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$noRoute(void)
#line 282
{
}

# 52 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$Routing$noRoute(void){
#line 52
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$noRoute();
#line 52
}
#line 52
# 549 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  error_t LinkEstimatorP$LinkEstimator$clearDLQ(am_addr_t neighbor)
#line 549
{
  neighbor_table_entry_t *ne;
  uint8_t nidx = LinkEstimatorP$findIdx(neighbor);

#line 552
  if (nidx == LinkEstimatorP$INVALID_RVAL) {
      return FAIL;
    }
  ne = &LinkEstimatorP$NeighborTable[nidx];
  ne->data_total = 0;
  ne->data_success = 0;
  return SUCCESS;
}

# 64 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$clearDLQ(am_addr_t arg_0x7dc7ba70){
#line 64
  unsigned char result;
#line 64

#line 64
  result = LinkEstimatorP$LinkEstimator$clearDLQ(arg_0x7dc7ba70);
#line 64

#line 64
  return result;
#line 64
}
#line 64
#line 50
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$pinNeighbor(am_addr_t arg_0x7dc7c7e8){
#line 50
  unsigned char result;
#line 50

#line 50
  result = LinkEstimatorP$LinkEstimator$pinNeighbor(arg_0x7dc7c7e8);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 504 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  error_t LinkEstimatorP$LinkEstimator$unpinNeighbor(am_addr_t neighbor)
#line 504
{
  uint8_t nidx = LinkEstimatorP$findIdx(neighbor);

#line 506
  if (nidx == LinkEstimatorP$INVALID_RVAL) {
      return FAIL;
    }
  LinkEstimatorP$NeighborTable[nidx].flags &= ~PINNED_ENTRY;
  return SUCCESS;
}

# 53 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$unpinNeighbor(am_addr_t arg_0x7dc7cc88){
#line 53
  unsigned char result;
#line 53

#line 53
  result = LinkEstimatorP$LinkEstimator$unpinNeighbor(arg_0x7dc7cc88);
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 744 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline   error_t /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$default$logEventRoute(uint8_t type, am_addr_t parent, uint8_t hopcount, uint16_t etx)
#line 744
{
  return SUCCESS;
}

# 68 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$logEventRoute(uint8_t arg_0x7dc67c90, am_addr_t arg_0x7dc67e20, uint8_t arg_0x7dc66010, uint16_t arg_0x7dc661a0){
#line 68
  unsigned char result;
#line 68

#line 68
  result = /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$default$logEventRoute(arg_0x7dc67c90, arg_0x7dc67e20, arg_0x7dc66010, arg_0x7dc661a0);
#line 68

#line 68
  return result;
#line 68
}
#line 68
# 177 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline void /*CtpP.Router*/CtpRoutingEngineP$0$resetInterval(void)
#line 177
{
  /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval = 1;
  /*CtpP.Router*/CtpRoutingEngineP$0$chooseAdvertiseTime();
}

#line 252
static inline bool /*CtpP.Router*/CtpRoutingEngineP$0$passLinkEtxThreshold(uint16_t etx)
#line 252
{
  return TRUE;
  return etx < ETX_THRESHOLD;
}

# 38 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$getLinkQuality(uint16_t arg_0x7dc7d4e8){
#line 38
  unsigned char result;
#line 38

#line 38
  result = LinkEstimatorP$LinkEstimator$getLinkQuality(arg_0x7dc7d4e8);
#line 38

#line 38
  return result;
#line 38
}
#line 38
# 259 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline uint16_t /*CtpP.Router*/CtpRoutingEngineP$0$evaluateEtx(uint8_t quality)
#line 259
{

  return quality + 10;
}




static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$runTask(void)
#line 267
{
  uint8_t i;
  routing_table_entry *entry;
  routing_table_entry *best;
  uint16_t minEtx;
  uint16_t currentEtx;
  uint16_t linkEtx;
#line 273
  uint16_t pathEtx;

  if (/*CtpP.Router*/CtpRoutingEngineP$0$state_is_root) {
    return;
    }
  best = (void *)0;

  minEtx = MAX_METRIC;

  currentEtx = MAX_METRIC;

  ;


  for (i = 0; i < /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive; i++) {
      entry = &/*CtpP.Router*/CtpRoutingEngineP$0$routingTable[i];


      if (entry->info.parent == INVALID_ADDR || entry->info.parent == /*CtpP.Router*/CtpRoutingEngineP$0$my_ll_addr) {
          ;


          continue;
        }

      linkEtx = /*CtpP.Router*/CtpRoutingEngineP$0$evaluateEtx(/*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$getLinkQuality(entry->neighbor));
      ;


      pathEtx = linkEtx + entry->info.etx;

      if (entry->neighbor == /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent) {
          ;
          currentEtx = pathEtx;

          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 308
            {
              /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx = entry->info.etx;
              /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.congested = entry->info.congested;
            }
#line 311
            __nesc_atomic_end(__nesc_atomic); }
          continue;
        }

      if (entry->info.congested) {
        continue;
        }
      if (!/*CtpP.Router*/CtpRoutingEngineP$0$passLinkEtxThreshold(linkEtx)) {
          ;
          continue;
        }

      if (pathEtx < minEtx) {
          minEtx = pathEtx;
          best = entry;
        }
    }
#line 342
  if (minEtx != MAX_METRIC) {

      if ((
#line 343
      currentEtx == MAX_METRIC || (
      /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.congested && minEtx < /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx + 10)) || 
      minEtx + PARENT_SWITCH_THRESHOLD < currentEtx) {




          /*CtpP.Router*/CtpRoutingEngineP$0$parentChanges++;
          /*CtpP.Router*/CtpRoutingEngineP$0$resetInterval();
          ;
          /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$logEventRoute(NET_C_TREE_NEW_PARENT, best->neighbor, 0, best->info.etx);
          /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$unpinNeighbor(/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent);
          /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$pinNeighbor(best->neighbor);
          /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$clearDLQ(best->neighbor);
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 357
            {
              /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent = best->neighbor;
              /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx = best->info.etx;
              /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.congested = best->info.congested;
            }
#line 361
            __nesc_atomic_end(__nesc_atomic); }
        }
    }




  if (/*CtpP.Router*/CtpRoutingEngineP$0$justEvicted && /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == INVALID_ADDR) {
    /*CtpP.Router*/CtpRoutingEngineP$0$Routing$noRoute();
    }
  else {



    if (
#line 374
    !/*CtpP.Router*/CtpRoutingEngineP$0$justEvicted && 
    currentEtx == MAX_METRIC && 
    minEtx != MAX_METRIC) {
      /*CtpP.Router*/CtpRoutingEngineP$0$Routing$routeFound();
      }
    }
#line 378
  /*CtpP.Router*/CtpRoutingEngineP$0$justEvicted = FALSE;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand32(void){
#line 35
  unsigned long result;
#line 35

#line 35
  result = RandomMlcgP$Random$rand32();
#line 35

#line 35
  return result;
#line 35
}
#line 35
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 94 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   Atm128_TIFR_t HplAtm128Timer0AsyncP$TimerCtrl$getInterruptFlag(void)
#line 94
{
  return * (Atm128_TIFR_t *)& * (volatile uint8_t *)(0x36 + 0x20);
}

# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
inline static   Atm128_TIFR_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$getInterruptFlag(void){
#line 44
  union __nesc_unnamed4272 result;
#line 44

#line 44
  result = HplAtm128Timer0AsyncP$TimerCtrl$getInterruptFlag();
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 264 "/usr/lib/ncc/nesc_nx.h"
static __inline uint16_t __nesc_ntoh_uint16(const void *source)
#line 264
{
  const uint8_t *base = source;

#line 266
  return ((uint16_t )base[0] << 8) | base[1];
}

#line 235
static __inline uint8_t __nesc_ntoh_uint8(const void *source)
#line 235
{
  const uint8_t *base = source;

#line 237
  return base[0];
}

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(1U, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 151 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968){
#line 151
  CC2420ActiveMessageP$AMPacket$setType(arg_0x7e7b77e0, arg_0x7e7b7968);
#line 151
}
#line 151
#line 92
inline static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8){
#line 92
  CC2420ActiveMessageP$AMPacket$setDestination(arg_0x7e7c0928, arg_0x7e7c0ab8);
#line 92
}
#line 92
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setDestination(msg, dest);
  /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMPacket$setType(msg, 24);
  return /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$send(msg, len);
}

# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t LinkEstimatorP$AMSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$send(arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 95 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t LinkEstimatorP$SubPacket$maxPayloadLength(void){
#line 95
  unsigned char result;
#line 95

#line 95
  result = CC2420ActiveMessageP$Packet$maxPayloadLength();
#line 95

#line 95
  return result;
#line 95
}
#line 95
# 98 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline linkest_footer_t *LinkEstimatorP$getFooter(message_t *m, uint8_t len)
#line 98
{
  return (linkest_footer_t *)(len + (uint8_t *)LinkEstimatorP$Packet$getPayload(m, (void *)0));
}

# 108 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void *LinkEstimatorP$SubPacket$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500){
#line 108
  void *result;
#line 108

#line 108
  result = CC2420ActiveMessageP$Packet$getPayload(arg_0x7e7c5358, arg_0x7e7c5500);
#line 108

#line 108
  return result;
#line 108
}
#line 108
# 93 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline linkest_header_t *LinkEstimatorP$getHeader(message_t *m)
#line 93
{
  return (linkest_header_t *)LinkEstimatorP$SubPacket$getPayload(m, (void *)0);
}









static inline uint8_t LinkEstimatorP$addLinkEstHeaderAndFooter(message_t *msg, uint8_t len)
#line 105
{
  unsigned char *__nesc_temp52;
#line 106
  uint8_t newlen;
  linkest_header_t *hdr;
  linkest_footer_t *footer;
  uint8_t i;
#line 109
  uint8_t j;
#line 109
  uint8_t k;
  uint8_t maxEntries;
#line 110
  uint8_t newPrevSentIdx;

#line 111
  ;
  hdr = LinkEstimatorP$getHeader(msg);
  footer = LinkEstimatorP$getFooter(msg, len);

  maxEntries = (LinkEstimatorP$SubPacket$maxPayloadLength() - len - sizeof(linkest_header_t ))
   / sizeof(linkest_footer_t );



  if (maxEntries > NUM_ENTRIES_FLAG) {
      maxEntries = NUM_ENTRIES_FLAG;
    }
  ;

  j = 0;
  newPrevSentIdx = 0;
  for (i = 0; i < 10 && j < maxEntries; i++) {
      k = (LinkEstimatorP$prevSentIdx + i + 1) % 10;
      if (LinkEstimatorP$NeighborTable[k].flags & VALID_ENTRY) {
          __nesc_hton_uint16((unsigned char *)&footer->neighborList[j].ll_addr, LinkEstimatorP$NeighborTable[k].ll_addr);
          __nesc_hton_uint8((unsigned char *)&footer->neighborList[j].inquality, LinkEstimatorP$NeighborTable[k].inquality);
          newPrevSentIdx = k;
          ;

          j++;
        }
    }
  LinkEstimatorP$prevSentIdx = newPrevSentIdx;

  __nesc_hton_uint8((unsigned char *)&hdr->seq, LinkEstimatorP$linkEstSeq++);
  __nesc_hton_uint8((unsigned char *)&hdr->flags, 0);
  (__nesc_temp52 = (unsigned char *)&hdr->flags, __nesc_hton_uint8(__nesc_temp52, __nesc_ntoh_uint8(__nesc_temp52) | (NUM_ENTRIES_FLAG & j)));
  newlen = sizeof(linkest_header_t ) + len + j * sizeof(linkest_footer_t );
  ;
  return newlen;
}

#line 564
static inline  error_t LinkEstimatorP$Send$send(am_addr_t addr, message_t *msg, uint8_t len)
#line 564
{
  uint8_t newlen;

#line 566
  newlen = LinkEstimatorP$addLinkEstHeaderAndFooter(msg, len);
  ;
  ;
  LinkEstimatorP$print_packet(msg, newlen);
  return LinkEstimatorP$AMSend$send(addr, msg, newlen);
}

# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = LinkEstimatorP$Send$send(arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 7 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpCongestion.nc"
inline static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpCongestion$isCongested(void){
#line 7
  unsigned char result;
#line 7

#line 7
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpCongestion$isCongested();
#line 7

#line 7
  return result;
#line 7
}
#line 7
# 385 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$runTask(void)
#line 385
{
  unsigned char *__nesc_temp54;
  unsigned char *__nesc_temp53;
#line 386
  error_t eval;

#line 387
  if (/*CtpP.Router*/CtpRoutingEngineP$0$sending) {
      return;
    }

  __nesc_hton_uint8((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->options, 0);


  if (/*CtpP.Router*/CtpRoutingEngineP$0$CtpCongestion$isCongested()) {
      (__nesc_temp53 = (unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->options, __nesc_hton_uint8(__nesc_temp53, __nesc_ntoh_uint8(__nesc_temp53) | CTP_OPT_ECN));
    }

  __nesc_hton_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->parent, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent);
  if (/*CtpP.Router*/CtpRoutingEngineP$0$state_is_root) {
      __nesc_hton_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->etx, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx);
    }
  else {
#line 402
    if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == INVALID_ADDR) {
        __nesc_hton_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->etx, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx);
        (__nesc_temp54 = (unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->options, __nesc_hton_uint8(__nesc_temp54, __nesc_ntoh_uint8(__nesc_temp54) | CTP_OPT_PULL));
      }
    else 
#line 405
      {
        __nesc_hton_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->etx, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx + 
        /*CtpP.Router*/CtpRoutingEngineP$0$evaluateEtx(/*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$getLinkQuality(/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent)));
      }
    }
  ;



  /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$logEventRoute(NET_C_TREE_SENT_BEACON, __nesc_ntoh_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->parent), 0, __nesc_ntoh_uint16((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg->etx));

  eval = /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$send(AM_BROADCAST_ADDR, 
  &/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsgBuffer, 
  sizeof(ctp_routing_header_t ));
  if (eval == SUCCESS) {
      /*CtpP.Router*/CtpRoutingEngineP$0$sending = TRUE;
    }
  else {
#line 421
    if (eval == EOFF) {
        /*CtpP.Router*/CtpRoutingEngineP$0$radioOn = FALSE;
        ;
      }
    }
}

# 118 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask$runTask(void)
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
  for (i = 0; i < 4 / 8 + 1; i++) {
      if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$cancelMask[i]) {
          for (mask = 1, j = 0; j < 8; j++) {
              if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$cancelMask[i] & mask) {
                  last = i * 8 + j;
                  msg = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[last].msg;
                  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[last].msg = (void *)0;
                  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$cancelMask[i] &= ~mask;
                  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$sendDone(last, msg, ECANCEL);
                }
              mask <<= 1;
            }
        }
    }
}

# 153 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  void DisseminationEngineImplP$ProbeAMSend$sendDone(message_t *msg, error_t error)
#line 153
{
  DisseminationEngineImplP$m_bufBusy = FALSE;
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  DisseminationEngineImplP$ProbeAMSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$AMSend$sendDone(m, err);
}

# 157 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  void DisseminationEngineImplP$AMSend$sendDone(message_t *msg, error_t error)
#line 157
{
  DisseminationEngineImplP$m_bufBusy = FALSE;
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  DisseminationEngineImplP$AMSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$AMSend$sendDone(m, err);
}

# 427 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$sendDone(message_t *msg, error_t error)
#line 427
{
  if (msg != &/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsgBuffer || !/*CtpP.Router*/CtpRoutingEngineP$0$sending) {

      return;
    }
  /*CtpP.Router*/CtpRoutingEngineP$0$sending = FALSE;
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void LinkEstimatorP$Send$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 575 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  void LinkEstimatorP$AMSend$sendDone(message_t *msg, error_t error)
#line 575
{
  return LinkEstimatorP$Send$sendDone(msg, error);
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  LinkEstimatorP$AMSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$AMSend$sendDone(m, err);
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$sendDone(m, err);
}

# 983 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEvent(uint8_t type)
#line 983
{
  return SUCCESS;
}

# 50 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(uint8_t arg_0x7dc74e50){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEvent(arg_0x7dc74e50);
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 525 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline void /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendDoneBug(void)
#line 525
{

  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_BAD_SENDDONE);
}

# 257 "/usr/lib/ncc/nesc_nx.h"
static __inline int8_t __nesc_ntoh_int8(const void *source)
#line 257
{
#line 257
  return __nesc_ntoh_uint8(source);
}

# 68 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420PacketC.nc"
static inline   bool CC2420PacketC$Acks$wasAcked(message_t *p_msg)
#line 68
{
  return __nesc_ntoh_int8((unsigned char *)&CC2420PacketC$CC2420Packet$getMetadata(p_msg)->ack);
}

# 74 "/opt/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static   bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$wasAcked(message_t *arg_0x7e7b3568){
#line 74
  unsigned char result;
#line 74

#line 74
  result = CC2420PacketC$Acks$wasAcked(arg_0x7e7b3568);
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 533 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  error_t LinkEstimatorP$LinkEstimator$txNoAck(am_addr_t neighbor)
#line 533
{
  neighbor_table_entry_t *ne;
  uint8_t nidx = LinkEstimatorP$findIdx(neighbor);

#line 536
  if (nidx == LinkEstimatorP$INVALID_RVAL) {
      return FAIL;
    }

  ne = &LinkEstimatorP$NeighborTable[nidx];
  ne->data_total++;
  if (ne->data_total >= LinkEstimatorP$DLQ_PKT_WINDOW) {
      LinkEstimatorP$updateDEETX(ne);
    }
  return SUCCESS;
}

# 61 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txNoAck(am_addr_t arg_0x7dc7b5d0){
#line 61
  unsigned char result;
#line 61

#line 61
  result = LinkEstimatorP$LinkEstimator$txNoAck(arg_0x7dc7b5d0);
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 552 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$recomputeRoutes(void)
#line 552
{
  /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
}

# 70 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$recomputeRoutes(void){
#line 70
  /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$recomputeRoutes();
#line 70
}
#line 70
# 933 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline   
#line 932
void 
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$default$sendDone(uint8_t client, message_t *msg, error_t error)
#line 933
{
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$sendDone(uint8_t arg_0x7dc57c78, message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  switch (arg_0x7dc57c78) {
#line 89
    case 0U:
#line 89
      OctopusC$CollectSend$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    default:
#line 89
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$default$sendDone(arg_0x7dc57c78, arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$toggle(void){
#line 31
  /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$toggle();
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
inline static   void OctopusC$Leds$led1Toggle(void){
#line 72
  LedsP$Leds$led1Toggle();
#line 72
}
#line 72
# 83 "OctopusC.nc"
inline static void OctopusC$reportSent(void)
#line 83
{
#line 83
  OctopusC$Leds$led1Toggle();
}

# 69 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline void /*CtpP.SendQueueP*/QueueC$0$printQueue(void)
#line 69
{
}

# 57 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txAck(am_addr_t arg_0x7dc7b138){
#line 57
  unsigned char result;
#line 57

#line 57
  result = LinkEstimatorP$LinkEstimator$txAck(arg_0x7dc7b138);
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 78 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$size(void)
#line 78
{
  return /*CtpP.MessagePoolP.PoolP*/PoolP$0$free;
}

# 72 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$size(void){
#line 72
  unsigned char result;
#line 72

#line 72
  result = /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$size();
#line 72

#line 72
  return result;
#line 72
}
#line 72
# 82 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  uint8_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$maxSize(void)
#line 82
{
  return 12;
}

# 80 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$maxSize(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$maxSize();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 65 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpPacket.nc"
inline static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getType(message_t *arg_0x7dc83358){
#line 65
  unsigned char result;
#line 65

#line 65
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(arg_0x7dc83358);
#line 65

#line 65
  return result;
#line 65
}
#line 65
#line 53
inline static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getThl(message_t *arg_0x7dc87658){
#line 53
  unsigned char result;
#line 53

#line 53
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(arg_0x7dc87658);
#line 53

#line 53
  return result;
#line 53
}
#line 53









inline static  uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getSequenceNumber(message_t *arg_0x7dc857e8){
#line 62
  unsigned char result;
#line 62

#line 62
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(arg_0x7dc857e8);
#line 62

#line 62
  return result;
#line 62
}
#line 62
#line 59
inline static  am_addr_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getOrigin(message_t *arg_0x7dc86c90){
#line 59
  unsigned int result;
#line 59

#line 59
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(arg_0x7dc86c90);
#line 59

#line 59
  return result;
#line 59
}
#line 59
# 100 "/opt/tinyos-2.x/tos/lib/net/ctp/LruCtpMsgCacheP.nc"
static inline void /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$remove(uint8_t i)
#line 100
{
  uint8_t j;

#line 102
  if (i >= /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count) {
    return;
    }
#line 104
  if (i == 0) {

      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first = (/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + 1) % 4;
    }
  else 
#line 107
    {

      for (j = i; j < /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count; j++) {
          memcpy(&/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(j + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first) % 4], &/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(j + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + 1) % 4], sizeof(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$ctp_packet_sig_t ));
        }
    }
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count--;
}

static inline  void /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$insert(message_t *m)
#line 116
{
  uint8_t i;

#line 118
  if (/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count == 4) {





      i = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$lookup(m);
      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$remove(i % /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count);
    }

  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count) % 4].origin = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getOrigin(m);
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count) % 4].seqno = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getSequenceNumber(m);
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count) % 4].thl = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getThl(m);
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[(/*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count) % 4].type = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getType(m);
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count++;
}

# 40 "/opt/tinyos-2.x/tos/interfaces/Cache.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$insert(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$t arg_0x7dc16088){
#line 40
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$insert(arg_0x7dc16088);
#line 40
}
#line 40
# 155 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$sendDone(uint8_t last, message_t *msg, error_t err)
#line 155
{
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[last].msg = (void *)0;
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$tryToSend();
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$sendDone(last, msg, err);
}

static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$runTask(void)
#line 161
{
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$sendDone(/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current, /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current].msg, FAIL);
}

#line 57
static inline void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$nextPacket(void)
#line 57
{
  uint8_t i;

#line 59
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current + 1) % 4;
  for (i = 0; i < 4; i++) {
      if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current].msg == (void *)0 || 
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$cancelMask[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current / 8] & (1 << /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current % 8)) 
        {
          /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current + 1) % 4;
        }
      else {
          break;
        }
    }
  if (i >= 4) {
#line 70
    /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = 4;
    }
}

# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_header_t *CC2420ActiveMessageP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 167 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline  uint8_t CC2420ActiveMessageP$Packet$payloadLength(message_t *msg)
#line 167
{
  return __nesc_ntoh_leuint8((unsigned char *)&CC2420ActiveMessageP$CC2420Packet$getHeader(msg)->length) - CC2420ActiveMessageP$CC2420_SIZE;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$payloadLength(message_t *arg_0x7e7c7ee0){
#line 67
  unsigned char result;
#line 67

#line 67
  result = CC2420ActiveMessageP$Packet$payloadLength(arg_0x7e7c7ee0);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 95 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$maxPayloadLength(void){
#line 95
  unsigned char result;
#line 95

#line 95
  result = CC2420ActiveMessageP$Packet$maxPayloadLength();
#line 95

#line 95
  return result;
#line 95
}
#line 95
# 869 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$maxPayloadLength(void)
#line 869
{
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$maxPayloadLength() - sizeof(ctp_data_header_t );
}

# 83 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8){
#line 83
  CC2420ActiveMessageP$Packet$setPayloadLength(arg_0x7e7c6570, arg_0x7e7c66f8);
#line 83
}
#line 83
# 865 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 865
{
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$setPayloadLength(msg, len + sizeof(ctp_data_header_t ));
}

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(0U, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 151 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968){
#line 151
  CC2420ActiveMessageP$AMPacket$setType(arg_0x7e7b77e0, arg_0x7e7b7968);
#line 151
}
#line 151
#line 92
inline static  void /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8){
#line 92
  CC2420ActiveMessageP$AMPacket$setDestination(arg_0x7e7c0928, arg_0x7e7c0ab8);
#line 92
}
#line 92
# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  error_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setDestination(msg, dest);
  /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMPacket$setType(msg, 23);
  return /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$send(msg, len);
}

# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$send(arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 108 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$getPayload(message_t *arg_0x7e7c5358, uint8_t *arg_0x7e7c5500){
#line 108
  void *result;
#line 108

#line 108
  result = CC2420ActiveMessageP$Packet$getPayload(arg_0x7e7c5358, arg_0x7e7c5500);
#line 108

#line 108
  return result;
#line 108
}
#line 108
# 294 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline ctp_data_header_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(message_t *m)
#line 294
{
  return (ctp_data_header_t *)/*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$getPayload(m, (void *)0);
}

#line 909
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$clearOption(message_t *msg, ctp_options_t opt)
#line 909
{
  unsigned char *__nesc_temp51;

#line 910
  (__nesc_temp51 = (unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->options, __nesc_hton_uint8(__nesc_temp51, __nesc_ntoh_uint8(__nesc_temp51) & ~opt));
}

#line 905
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setOption(message_t *msg, ctp_options_t opt)
#line 905
{
  unsigned char *__nesc_temp50;

#line 906
  (__nesc_temp50 = (unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->options, __nesc_hton_uint8(__nesc_temp50, __nesc_ntoh_uint8(__nesc_temp50) | opt));
}

# 58 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420PacketC.nc"
static inline   error_t CC2420PacketC$Acks$requestAck(message_t *p_msg)
#line 58
{
  unsigned char *__nesc_temp48;

#line 59
  (__nesc_temp48 = (unsigned char *)&CC2420PacketC$CC2420Packet$getHeader(p_msg)->fcf, __nesc_hton_leuint16(__nesc_temp48, __nesc_ntoh_leuint16(__nesc_temp48) | (1 << IEEE154_FCF_ACK_REQ)));
  return SUCCESS;
}

# 48 "/opt/tinyos-2.x/tos/interfaces/PacketAcknowledgements.nc"
inline static   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$requestAck(message_t *arg_0x7e7b46d8){
#line 48
  unsigned char result;
#line 48

#line 48
  result = CC2420PacketC$Acks$requestAck(arg_0x7e7b46d8);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 913 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setEtx(message_t *msg, uint16_t e)
#line 913
{
#line 913
  __nesc_hton_uint16((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->etx, e);
}

# 51 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$getEtx(uint16_t *arg_0x7eb34478){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getEtx(arg_0x7eb34478);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 861 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(message_t *msg)
#line 861
{
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$payloadLength(msg) - sizeof(ctp_data_header_t );
}

#line 942
static inline   message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$default$receive(collection_id_t collectid, message_t *msg, void *payload, 
uint8_t len)
#line 944
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$receive(collection_id_t arg_0x7dc56680, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7dc56680) {
#line 67
    case AM_OCTOPUS_COLLECTED_MSG:
#line 67
      result = OctopusC$CollectReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$default$receive(arg_0x7dc56680, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 632 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$isRoot(void)
#line 632
{
  return /*CtpP.Router*/CtpRoutingEngineP$0$state_is_root;
}

# 43 "/opt/tinyos-2.x/tos/lib/net/RootControl.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$RootControl$isRoot(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$isRoot();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 81 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue(void){
#line 81
  struct __nesc_unnamed4322 *result;
#line 81

#line 81
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$dequeue();
#line 81

#line 81
  return result;
#line 81
}
#line 81
# 135 "/opt/tinyos-2.x/tos/lib/net/ctp/LruCtpMsgCacheP.nc"
static inline  bool /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$lookup(message_t *m)
#line 135
{
  return /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$lookup(m) < /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count;
}

# 48 "/opt/tinyos-2.x/tos/interfaces/Cache.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$lookup(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$t arg_0x7dc165e0){
#line 48
  unsigned char result;
#line 48

#line 48
  result = /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Cache$lookup(arg_0x7dc165e0);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 212 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getNow(void)
#line 212
{
  return /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$get();
}

# 98 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow(void){
#line 98
  unsigned long result;
#line 98

#line 98
  result = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getNow();
#line 98

#line 98
  return result;
#line 98
}
#line 98
# 85 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$getNow(void)
{
#line 86
  return /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getNow();
}

# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
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
# 147 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(), dt, TRUE);
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(6U, arg_0x7eb11338);
#line 62
}
#line 62
# 78 "/opt/tinyos-2.x/tos/system/RandomMlcgP.nc"
static inline   uint16_t RandomMlcgP$Random$rand16(void)
#line 78
{
  return (uint16_t )RandomMlcgP$Random$rand32();
}

# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgP$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 966 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
inline static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startCongestionTimer(uint16_t mask, uint16_t offset)
#line 966
{
  uint16_t r = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Random$rand16();

#line 968
  r &= mask;
  r += offset;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$startOneShot(r);
  ;
}

# 157 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  bool /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$isRunning(uint8_t num)
{
  return /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].isrunning;
}

# 81 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$isRunning(void){
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
# 591 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$isNeighborCongested(am_addr_t n)
#line 591
{
  uint8_t idx;

  if (/*CtpP.Router*/CtpRoutingEngineP$0$ECNOff) {
    return FALSE;
    }
  idx = /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(n);
  if (idx < /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive) {
      return /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.congested;
    }
  return FALSE;
}

# 80 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$isNeighborCongested(am_addr_t arg_0x7eb32b50){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$isNeighborCongested(arg_0x7eb32b50);
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 526 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$Routing$nextHop(void)
#line 526
{
  return /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent;
}

# 48 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
inline static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$nextHop(void){
#line 48
  unsigned int result;
#line 48

#line 48
  result = /*CtpP.Router*/CtpRoutingEngineP$0$Routing$nextHop();
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 65 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$head(void)
#line 65
{
  return /*CtpP.SendQueueP*/QueueC$0$queue[/*CtpP.SendQueueP*/QueueC$0$head];
}

# 73 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$head(void){
#line 73
  struct __nesc_unnamed4322 *result;
#line 73

#line 73
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$head();
#line 73

#line 73
  return result;
#line 73
}
#line 73
# 529 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  bool /*CtpP.Router*/CtpRoutingEngineP$0$Routing$hasRoute(void)
#line 529
{
  return /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent != INVALID_ADDR;
}

# 49 "/opt/tinyos-2.x/tos/lib/net/UnicastNameFreeRouting.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$hasRoute(void){
#line 49
  unsigned char result;
#line 49

#line 49
  result = /*CtpP.Router*/CtpRoutingEngineP$0$Routing$hasRoute();
#line 49

#line 49
  return result;
#line 49
}
#line 49
# 53 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline  bool /*CtpP.SendQueueP*/QueueC$0$Queue$empty(void)
#line 53
{
  return /*CtpP.SendQueueP*/QueueC$0$size == 0;
}

# 50 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$empty(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$empty();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 382 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$runTask(void)
#line 382
{
  ;
  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$sending) {
      ;
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SEND_BUSY);
      return;
    }
  else {
#line 389
    if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$empty()) {
        ;
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SENDQUEUE_EMPTY);
        return;
      }
    else {
#line 394
      if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$RootControl$isRoot() && 
      !/*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$hasRoute()) {
          ;
          /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$startOneShot(10000);


          /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_NO_ROUTE);

          return;
        }
      else 








        {
          error_t subsendResult;
          fe_queue_entry_t *qe = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$head();
          uint8_t payloadLen = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$payloadLength(qe->msg);
          am_addr_t dest = /*CtpP.Forwarder*/CtpForwardingEngineP$0$UnicastNameFreeRouting$nextHop();
          uint16_t gradient;

          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$isNeighborCongested(dest)) {


              if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$parentCongested) {
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$parentCongested = TRUE;
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_CONGESTION_BEGIN);
                }
              if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$isRunning()) {
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$startCongestionTimer(CONGESTED_WAIT_WINDOW, CONGESTED_WAIT_OFFSET);
                }
              ;


              return;
            }
          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$parentCongested) {
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$parentCongested = FALSE;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_CONGESTION_END);
            }

          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$lookup(qe->msg)) {
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_DUPLICATE_CACHE_AT_SEND);
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue();
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
              return;
            }



          if (dest != /*CtpP.Forwarder*/CtpForwardingEngineP$0$lastParent) {
              qe->retries = MAX_RETRIES;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$lastParent = dest;
            }

          ;
          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$RootControl$isRoot()) {
              collection_id_t collectid = __nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(qe->msg)->type);

#line 457
              memcpy(/*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr, qe->msg, sizeof(message_t ));
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$ackPending = FALSE;

              ;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$receive(collectid, /*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr, 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(/*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr, (void *)0), 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(/*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr));
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$sendDone(qe->msg, SUCCESS);
              return;
            }


          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$getEtx(&gradient) != SUCCESS) {


              gradient = 0;
            }
          /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setEtx(qe->msg, gradient);

          /*CtpP.Forwarder*/CtpForwardingEngineP$0$ackPending = /*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$requestAck(qe->msg) == SUCCESS;


          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpCongestion$isCongested()) {
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setOption(qe->msg, CTP_OPT_ECN);
            }
          else {
#line 482
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$clearOption(qe->msg, CTP_OPT_ECN);
            }
          subsendResult = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$send(dest, qe->msg, payloadLen);
          if (subsendResult == SUCCESS) {

              /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = TRUE;
              ;
              if (qe->client < /*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT) {
                  ;
                }
              else {
                  ;
                }
              return;
            }
          else {
#line 497
            if (subsendResult == EOFF) {



                /*CtpP.Forwarder*/CtpForwardingEngineP$0$radioOn = FALSE;
                ;

                /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SUBSEND_OFF);
              }
            else {
#line 506
              if (subsendResult == EBUSY) {





                  ;

                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SUBSEND_BUSY);
                }
              else {
#line 516
                if (subsendResult == ESIZE) {
                    ;
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$setPayloadLength(qe->msg, /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$maxPayloadLength());
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SUBSEND_SIZE);
                  }
                }
              }
            }
        }
      }
    }
}

# 49 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline serial_header_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(message_t *msg)
#line 49
{
  return (serial_header_t *)(msg->data - sizeof(serial_header_t ));
}

#line 144
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(message_t *amsg, am_addr_t addr)
#line 144
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 146
  __nesc_hton_uint16((unsigned char *)&header->dest, addr);
}

# 92 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(message_t *arg_0x7e7c0928, am_addr_t arg_0x7e7c0ab8){
#line 92
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setDestination(arg_0x7e7c0928, arg_0x7e7c0ab8);
#line 92
}
#line 92
# 163 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(message_t *amsg, am_id_t type)
#line 163
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 165
  __nesc_hton_uint8((unsigned char *)&header->type, type);
}

# 151 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(message_t *arg_0x7e7b77e0, am_id_t arg_0x7e7b7968){
#line 151
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$setType(arg_0x7e7b77e0, arg_0x7e7b7968);
#line 151
}
#line 151
# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$send(am_id_t arg_0x7e48ab40, am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$send(arg_0x7e48ab40, arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 67 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$destination(message_t *arg_0x7e7c1cd8){
#line 67
  unsigned int result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(arg_0x7e7c1cd8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
#line 136
inline static  am_id_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMPacket$type(message_t *arg_0x7e7b7258){
#line 136
  unsigned char result;
#line 136

#line 136
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(arg_0x7e7b7258);
#line 136

#line 136
  return result;
#line 136
}
#line 136
# 115 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 115
{
  __nesc_hton_uint8((unsigned char *)&/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg)->length, len);
}

# 83 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$setPayloadLength(message_t *arg_0x7e7c6570, uint8_t arg_0x7e7c66f8){
#line 83
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$setPayloadLength(arg_0x7e7c6570, arg_0x7e7c66f8);
#line 83
}
#line 83
# 82 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
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

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$send(0U, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 522 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 51 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$startSend(uint8_t arg_0x7e729780){
#line 51
  unsigned char result;
#line 51

#line 51
  result = SerialP$SendBytePacket$startSend(arg_0x7e729780);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 43 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$dataLinkLength(message_t *msg, uint8_t upperLen)
#line 43
{
  return upperLen + sizeof(serial_header_t );
}

# 352 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(uart_id_t id, message_t *msg, 
uint8_t upperLen)
#line 353
{
  return 0;
}

# 23 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$dataLinkLength(uart_id_t arg_0x7e692d98, message_t *arg_0x7e755010, uint8_t arg_0x7e7551a0){
#line 23
  unsigned char result;
#line 23

#line 23
  switch (arg_0x7e692d98) {
#line 23
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 23
      result = SerialPacketInfoActiveMessageP$Info$dataLinkLength(arg_0x7e755010, arg_0x7e7551a0);
#line 23
      break;
#line 23
    default:
#line 23
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$dataLinkLength(arg_0x7e692d98, arg_0x7e755010, arg_0x7e7551a0);
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
# 40 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$offset(void)
#line 40
{
  return (uint8_t )(sizeof(message_header_t ) - sizeof(serial_header_t ));
}

# 349 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(uart_id_t id)
#line 349
{
  return 0;
}

# 15 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(uart_id_t arg_0x7e692d98){
#line 15
  unsigned char result;
#line 15

#line 15
  switch (arg_0x7e692d98) {
#line 15
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 15
      result = SerialPacketInfoActiveMessageP$Info$offset();
#line 15
      break;
#line 15
    default:
#line 15
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$offset(arg_0x7e692d98);
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
# 100 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
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

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$send(TOS_SERIAL_ACTIVE_MESSAGE_ID, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 48 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$toggle(void)
#line 48
{
#line 48
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 48
    * (volatile uint8_t *)59U ^= 1 << 0;
#line 48
    __nesc_atomic_end(__nesc_atomic); }
}

# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$toggle(void){
#line 31
  /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$toggle();
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
inline static   void OctopusC$Leds$led2Toggle(void){
#line 89
  LedsP$Leds$led2Toggle();
#line 89
}
#line 89
# 84 "OctopusC.nc"
inline static void OctopusC$reportReceived(void)
#line 84
{
#line 84
  OctopusC$Leds$led2Toggle();
}

#line 390
static inline  message_t *OctopusC$Snoop$receive(message_t *msg, void *payload, uint8_t len)
#line 390
{
  return msg;
}

# 948 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline   message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$default$receive(collection_id_t collectid, message_t *msg, void *payload, 
uint8_t len)
#line 950
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$receive(collection_id_t arg_0x7dc56e20, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7dc56e20) {
#line 67
    case AM_OCTOPUS_COLLECTED_MSG:
#line 67
      result = OctopusC$Snoop$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$default$receive(arg_0x7dc56e20, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 75 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$setNeighborCongested(am_addr_t arg_0x7eb324d8, bool arg_0x7eb32668){
#line 75
  /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$setNeighborCongested(arg_0x7eb324d8, arg_0x7eb32668);
#line 75
}
#line 75
# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(3U, arg_0x7eb11338);
#line 62
}
#line 62
# 152 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(uint8_t num)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].isrunning = FALSE;
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(3U);
#line 67
}
#line 67
# 177 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getNow(uint8_t num)
{
  return /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow();
}

# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getNow(void){
#line 125
  unsigned long result;
#line 125

#line 125
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getNow(3U);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 187 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getdt(uint8_t num)
{
  return /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].dt;
}

# 140 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getdt(void){
#line 140
  unsigned long result;
#line 140

#line 140
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getdt(3U);
#line 140

#line 140
  return result;
#line 140
}
#line 140
# 182 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  uint32_t /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$gett0(uint8_t num)
{
  return /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num].t0;
}

# 133 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$gett0(void){
#line 133
  unsigned long result;
#line 133

#line 133
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$gett0(3U);
#line 133

#line 133
  return result;
#line 133
}
#line 133
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgP$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 556 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerRouteUpdate(void)
#line 556
{

  uint16_t beaconDelay = /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand16();

#line 559
  beaconDelay &= 0x3f;
  beaconDelay += 64;

  if (
#line 561
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$gett0() + /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getdt() - 
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$getNow() >= beaconDelay) {
      /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$stop();
      /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(beaconDelay);
    }
}

# 58 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerRouteUpdate(void){
#line 58
  /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerRouteUpdate();
#line 58
}
#line 58
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$source(message_t *arg_0x7e7c0360){
#line 77
  unsigned int result;
#line 77

#line 77
  result = CC2420ActiveMessageP$AMPacket$source(arg_0x7e7c0360);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 811 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSnoop$receive(message_t *msg, void *payload, uint8_t len)
#line 812
{

  am_addr_t proximalSrc = /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$source(msg);



  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$option(msg, CTP_OPT_PULL)) {
    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerRouteUpdate();
    }
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$setNeighborCongested(proximalSrc, /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$option(msg, CTP_OPT_ECN));
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$Snoop$receive(/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(msg), 
  msg, payload + sizeof(ctp_data_header_t ), 
  len - sizeof(ctp_data_header_t ));
}

# 156 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline   message_t *CC2420ActiveMessageP$Snoop$default$receive(am_id_t id, message_t *msg, void *payload, uint8_t len)
#line 156
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420ActiveMessageP$Snoop$receive(am_id_t arg_0x7e4354e0, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7e4354e0) {
#line 67
    case 23:
#line 67
      result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSnoop$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = CC2420ActiveMessageP$Snoop$default$receive(arg_0x7e4354e0, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 65 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerImmediateRouteUpdate(void){
#line 65
  /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerImmediateRouteUpdate();
#line 65
}
#line 65
# 88 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$put(/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$t *arg_0x7dc2ab50){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$put(arg_0x7dc2ab50);
#line 88

#line 88
  return result;
#line 88
}
#line 88
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$put(/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$t *arg_0x7dc2ab50){
#line 88
  unsigned char result;
#line 88

#line 88
  result = /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$put(arg_0x7dc2ab50);
#line 88

#line 88
  return result;
#line 88
}
#line 88
# 81 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$isRunning(void){
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
# 67 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(message_t *arg_0x7e7c1cd8){
#line 67
  unsigned int result;
#line 67

#line 67
  result = CC2420ActiveMessageP$AMPacket$destination(arg_0x7e7c1cd8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 884 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(message_t *msg)
#line 884
{
#line 884
  return __nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->originSeqNo);
}

#line 992
static inline   error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEventMsg(uint8_t type, uint16_t msg, am_addr_t origin, am_addr_t node)
#line 992
{
  return SUCCESS;
}

# 62 "/opt/tinyos-2.x/tos/lib/net/CollectionDebug.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(uint8_t arg_0x7dc67338, uint16_t arg_0x7dc674c8, am_addr_t arg_0x7dc67658, am_addr_t arg_0x7dc677e8){
#line 62
  unsigned char result;
#line 62

#line 62
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$default$logEventMsg(arg_0x7dc67338, arg_0x7dc674c8, arg_0x7dc67658, arg_0x7dc677e8);
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 893 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  uint16_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getEtx(message_t *msg)
#line 893
{
#line 893
  return __nesc_ntoh_uint16((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->etx);
}

# 90 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$enqueue(/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t arg_0x7dc30d30){
#line 90
  unsigned char result;
#line 90

#line 90
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$enqueue(arg_0x7dc30d30);
#line 90

#line 90
  return result;
#line 90
}
#line 90
# 86 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t */*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$get(void)
#line 86
{
  if (/*CtpP.MessagePoolP.PoolP*/PoolP$0$free) {
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t *rval = /*CtpP.MessagePoolP.PoolP*/PoolP$0$queue[/*CtpP.MessagePoolP.PoolP*/PoolP$0$index];

#line 89
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$queue[/*CtpP.MessagePoolP.PoolP*/PoolP$0$index] = (void *)0;
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$free--;
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$index++;
      if (/*CtpP.MessagePoolP.PoolP*/PoolP$0$index == 12) {
          /*CtpP.MessagePoolP.PoolP*/PoolP$0$index = 0;
        }
      return rval;
    }
  return (void *)0;
}

# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$t */*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$get(void){
#line 96
  nx_struct message_t *result;
#line 96

#line 96
  result = /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$get();
#line 96

#line 96
  return result;
#line 96
}
#line 96
# 86 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t */*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$get(void)
#line 86
{
  if (/*CtpP.QEntryPoolP.PoolP*/PoolP$1$free) {
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t *rval = /*CtpP.QEntryPoolP.PoolP*/PoolP$1$queue[/*CtpP.QEntryPoolP.PoolP*/PoolP$1$index];

#line 89
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$queue[/*CtpP.QEntryPoolP.PoolP*/PoolP$1$index] = (void *)0;
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free--;
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$index++;
      if (/*CtpP.QEntryPoolP.PoolP*/PoolP$1$index == 12) {
          /*CtpP.QEntryPoolP.PoolP*/PoolP$1$index = 0;
        }
      return rval;
    }
  return (void *)0;
}

# 96 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$t */*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$get(void){
#line 96
  struct __nesc_unnamed4322 *result;
#line 96

#line 96
  result = /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$get();
#line 96

#line 96
  return result;
#line 96
}
#line 96
# 75 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  bool /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$empty(void)
#line 75
{
  return /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free == 0;
}

# 61 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$empty(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$empty();
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 75 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  bool /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$empty(void)
#line 75
{
  return /*CtpP.MessagePoolP.PoolP*/PoolP$0$free == 0;
}

# 61 "/opt/tinyos-2.x/tos/interfaces/Pool.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$empty(void){
#line 61
  unsigned char result;
#line 61

#line 61
  result = /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$empty();
#line 61

#line 61
  return result;
#line 61
}
#line 61
# 641 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline message_t */*CtpP.Forwarder*/CtpForwardingEngineP$0$forward(message_t *m)
#line 641
{
  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$empty()) {
      ;

      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_MSG_POOL_EMPTY);
    }
  else {
#line 647
    if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$empty()) {
        ;


        /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_QENTRY_POOL_EMPTY);
      }
    else {
        message_t *newMsg;
        fe_queue_entry_t *qe;
        uint16_t gradient;

        qe = /*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$get();
        if (qe == (void *)0) {
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_GET_MSGPOOL_ERR);
            return m;
          }

        newMsg = /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$get();
        if (newMsg == (void *)0) {
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_GET_QEPOOL_ERR);
            return m;
          }

        memset(newMsg, 0, sizeof(message_t ));
        memset(m->metadata, 0, sizeof(message_metadata_t ));

        qe->msg = m;
        qe->client = 0xff;
        qe->retries = MAX_RETRIES;


        if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$enqueue(qe) == SUCCESS) {
            ;

            if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$getEtx(&gradient) == SUCCESS) {

                if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getEtx(m) < gradient) {


                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerImmediateRouteUpdate();
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(LOOPY_WINDOW, LOOPY_OFFSET);
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_LOOP_DETECTED, 
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(m), 
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(m), 
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(m));
                  }
              }

            if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$isRunning()) {


                /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
              }


            return newMsg;
          }
        else 
#line 703
          {

            if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$put(newMsg) != SUCCESS) {
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_MSGPOOL_ERR);
              }
#line 707
            if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$put(qe) != SUCCESS) {
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_QEPOOL_ERR);
              }
          }
      }
    }


  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$triggerImmediateRouteUpdate();
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SEND_QUEUE_FULL);
  return m;
}

#line 937
static inline   
#line 936
bool 
/*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$default$forward(collection_id_t collectid, message_t *msg, void *payload, 
uint16_t len)
#line 938
{
  return TRUE;
}

# 31 "/opt/tinyos-2.x/tos/interfaces/Intercept.nc"
inline static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$forward(collection_id_t arg_0x7dc545c0, message_t *arg_0x7dc9bdf0, void *arg_0x7dc9a010, uint16_t arg_0x7dc9a1a0){
#line 31
  unsigned char result;
#line 31

#line 31
    result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$default$forward(arg_0x7dc545c0, arg_0x7dc9bdf0, arg_0x7dc9a010, arg_0x7dc9a1a0);
#line 31

#line 31
  return result;
#line 31
}
#line 31
# 919 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$matchInstance(message_t *m1, message_t *m2)
#line 919
{
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(m1) == /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(m2) && 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(m1) == /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(m2) && 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(m1) == /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(m2) && 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(m1) == /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(m2);
}

# 112 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$element(uint8_t idx)
#line 112
{
  idx += /*CtpP.SendQueueP*/QueueC$0$head;
  idx %= 13;
  return /*CtpP.SendQueueP*/QueueC$0$queue[idx];
}

# 101 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$element(uint8_t arg_0x7dc2f330){
#line 101
  struct __nesc_unnamed4322 *result;
#line 101

#line 101
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$element(arg_0x7dc2f330);
#line 101

#line 101
  return result;
#line 101
}
#line 101
# 57 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$size(void)
#line 57
{
  return /*CtpP.SendQueueP*/QueueC$0$size;
}

# 58 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$size(void){
#line 58
  unsigned char result;
#line 58

#line 58
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$size();
#line 58

#line 58
  return result;
#line 58
}
#line 58
# 101 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  uint8_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$maxPayloadLength(void){
#line 101
  unsigned char result;
#line 101

#line 101
  result = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$maxPayloadLength(0U);
#line 101

#line 101
  return result;
#line 101
}
#line 101
# 61 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  uint8_t /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$maxPayloadLength(void)
#line 61
{
  return /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$maxPayloadLength();
}

# 112 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$maxPayloadLength(void){
#line 112
  unsigned char result;
#line 112

#line 112
  result = /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$AMSend$maxPayloadLength();
#line 112

#line 112
  return result;
#line 112
}
#line 112
# 897 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setThl(message_t *msg, uint8_t thl)
#line 897
{
#line 897
  __nesc_hton_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->thl, thl);
}

#line 728
static inline  message_t *
/*CtpP.Forwarder*/CtpForwardingEngineP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 729
{
  uint8_t netlen;
  collection_id_t collectid;
  bool duplicate = FALSE;
  fe_queue_entry_t *qe;
  uint8_t i;
#line 734
  uint8_t thl;


  collectid = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(msg);



  thl = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(msg);
  thl++;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$setThl(msg, thl);

  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_RCV_MSG, 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
  if (len > /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$maxPayloadLength()) {
      return msg;
    }



  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$lookup(msg)) {
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_DUPLICATE_CACHE);
      return msg;
    }

  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$size() > 0) {
      for (i = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$size(); --i; ) {
          qe = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$element(i);
          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$matchInstance(qe->msg, msg)) {
              duplicate = TRUE;
              break;
            }
        }
    }

  if (duplicate) {
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_DUPLICATE_QUEUE);
      return msg;
    }
  else {

    if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$RootControl$isRoot()) {
      return /*CtpP.Forwarder*/CtpForwardingEngineP$0$Receive$receive(collectid, msg, 
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(msg, &netlen), 
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(msg));
      }
    else {
      if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$Intercept$forward(collectid, msg, 
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(msg, &netlen), 
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$payloadLength(msg))) {
        return msg;
        }
      else 
#line 786
        {
          ;
          return /*CtpP.Forwarder*/CtpForwardingEngineP$0$forward(msg);
        }
      }
    }
}

# 702 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  uint8_t LinkEstimatorP$Packet$payloadLength(message_t *msg)
#line 702
{
  linkest_header_t *hdr;

#line 704
  hdr = LinkEstimatorP$getHeader(msg);
  return LinkEstimatorP$SubPacket$payloadLength(msg)
   - sizeof(linkest_header_t )
   - sizeof(linkest_footer_t ) * (NUM_ENTRIES_FLAG & __nesc_ntoh_uint8((unsigned char *)&hdr->flags));
}

# 672 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableUpdateEntry(am_addr_t from, am_addr_t parent, uint16_t etx)
#line 672
{
  uint8_t idx;
  uint16_t linkEtx;

#line 675
  linkEtx = /*CtpP.Router*/CtpRoutingEngineP$0$evaluateEtx(/*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$getLinkQuality(from));

  idx = /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(from);
  if (idx == 10) {




      ;
      return FAIL;
    }
  else {
#line 686
    if (idx == /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive) {

        if (/*CtpP.Router*/CtpRoutingEngineP$0$passLinkEtxThreshold(linkEtx)) {
            { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 689
              {
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].neighbor = from;
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.parent = parent;
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.etx = etx;
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.haveHeard = 1;
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.congested = FALSE;
                /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive++;
              }
#line 696
              __nesc_atomic_end(__nesc_atomic); }
            ;
          }
        else 
#line 698
          {
            ;
          }
      }
    else 
#line 701
      {

        { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 703
          {
            /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].neighbor = from;
            /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.parent = parent;
            /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.etx = etx;
            /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.haveHeard = 1;
          }
#line 708
          __nesc_atomic_end(__nesc_atomic); }
        ;
      }
    }
#line 711
  return SUCCESS;
}

# 975 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$evicted(am_addr_t neighbor)
#line 975
{
}

# 67 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  void LinkEstimatorP$LinkEstimator$evicted(am_addr_t arg_0x7dc7bf00){
#line 67
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$evicted(arg_0x7dc7bf00);
#line 67
  /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$evicted(arg_0x7dc7bf00);
#line 67
}
#line 67
# 466 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  error_t LinkEstimatorP$LinkEstimator$insertNeighbor(am_addr_t neighbor)
#line 466
{
  uint8_t nidx;

  nidx = LinkEstimatorP$findIdx(neighbor);
  if (nidx != LinkEstimatorP$INVALID_RVAL) {
      ;
      return SUCCESS;
    }

  nidx = LinkEstimatorP$findEmptyNeighborIdx();
  if (nidx != LinkEstimatorP$INVALID_RVAL) {
      ;
      LinkEstimatorP$initNeighborIdx(nidx, neighbor);
      return SUCCESS;
    }
  else 
#line 480
    {
      nidx = LinkEstimatorP$findWorstNeighborIdx(LinkEstimatorP$BEST_EETX);
      if (nidx != LinkEstimatorP$INVALID_RVAL) {
          ;

          LinkEstimatorP$LinkEstimator$evicted(LinkEstimatorP$NeighborTable[nidx].ll_addr);
          LinkEstimatorP$initNeighborIdx(nidx, neighbor);
          return SUCCESS;
        }
    }
  return FAIL;
}

# 47 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimator.nc"
inline static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$insertNeighbor(am_addr_t arg_0x7dc7c348){
#line 47
  unsigned char result;
#line 47

#line 47
  result = LinkEstimatorP$LinkEstimator$insertNeighbor(arg_0x7dc7c348);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 77 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$source(message_t *arg_0x7e7c0360){
#line 77
  unsigned int result;
#line 77

#line 77
  result = CC2420ActiveMessageP$AMPacket$source(arg_0x7e7c0360);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 463 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  message_t */*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 463
{
  am_addr_t from;
  ctp_routing_header_t *rcvBeacon;
  bool congested;


  if (len != sizeof(ctp_routing_header_t )) {
      ;




      return msg;
    }


  from = /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$source(msg);
  rcvBeacon = (ctp_routing_header_t *)payload;

  congested = /*CtpP.Router*/CtpRoutingEngineP$0$CtpRoutingPacket$getOption(msg, CTP_OPT_ECN);

  ;





  if (__nesc_ntoh_uint16((unsigned char *)&rcvBeacon->parent) != INVALID_ADDR) {



      if (__nesc_ntoh_uint16((unsigned char *)&rcvBeacon->etx) == 0) {
          ;
          /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$insertNeighbor(from);
          /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$pinNeighbor(from);
        }


      /*CtpP.Router*/CtpRoutingEngineP$0$routingTableUpdateEntry(from, __nesc_ntoh_uint16((unsigned char *)&rcvBeacon->parent), __nesc_ntoh_uint16((unsigned char *)&rcvBeacon->etx));
      /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$setNeighborCongested(from, congested);
    }

  if (/*CtpP.Router*/CtpRoutingEngineP$0$CtpRoutingPacket$getOption(msg, CTP_OPT_PULL)) {
      /*CtpP.Router*/CtpRoutingEngineP$0$resetInterval();
    }

  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *LinkEstimatorP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = /*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 226 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline void LinkEstimatorP$updateReverseQuality(am_addr_t neighbor, uint8_t outquality)
#line 226
{
  uint8_t idx;

#line 228
  idx = LinkEstimatorP$findIdx(neighbor);
  if (idx != LinkEstimatorP$INVALID_RVAL) {
      LinkEstimatorP$NeighborTable[idx].outquality = outquality;
      LinkEstimatorP$NeighborTable[idx].outage = LinkEstimatorP$MAX_AGE;
    }
}

# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t LinkEstimatorP$SubAMPacket$address(void){
#line 57
  unsigned int result;
#line 57

#line 57
  result = CC2420ActiveMessageP$AMPacket$address();
#line 57

#line 57
  return result;
#line 57
}
#line 57
#line 77
inline static  am_addr_t LinkEstimatorP$SubAMPacket$source(message_t *arg_0x7e7c0360){
#line 77
  unsigned int result;
#line 77

#line 77
  result = CC2420ActiveMessageP$AMPacket$source(arg_0x7e7c0360);
#line 77

#line 77
  return result;
#line 77
}
#line 77
#line 67
inline static  am_addr_t LinkEstimatorP$SubAMPacket$destination(message_t *arg_0x7e7c1cd8){
#line 67
  unsigned int result;
#line 67

#line 67
  result = CC2420ActiveMessageP$AMPacket$destination(arg_0x7e7c1cd8);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 595 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline void LinkEstimatorP$processReceivedMessage(message_t *msg, void *payload, uint8_t len)
#line 595
{
  uint8_t nidx;
  uint8_t num_entries;

  ;
  LinkEstimatorP$print_packet(msg, len);

  if (LinkEstimatorP$SubAMPacket$destination(msg) == AM_BROADCAST_ADDR) {
      linkest_header_t *hdr = LinkEstimatorP$getHeader(msg);
      linkest_footer_t *footer;
      am_addr_t ll_addr;

      ll_addr = LinkEstimatorP$SubAMPacket$source(msg);

      ;

      num_entries = __nesc_ntoh_uint8((unsigned char *)&hdr->flags) & NUM_ENTRIES_FLAG;
      LinkEstimatorP$print_neighbor_table();
#line 628
      nidx = LinkEstimatorP$findIdx(ll_addr);
      if (nidx != LinkEstimatorP$INVALID_RVAL) {
          ;
          LinkEstimatorP$updateNeighborEntryIdx(nidx, __nesc_ntoh_uint8((unsigned char *)&hdr->seq));
        }
      else 
#line 632
        {
          nidx = LinkEstimatorP$findEmptyNeighborIdx();
          if (nidx != LinkEstimatorP$INVALID_RVAL) {
              ;
              LinkEstimatorP$initNeighborIdx(nidx, ll_addr);
              LinkEstimatorP$updateNeighborEntryIdx(nidx, __nesc_ntoh_uint8((unsigned char *)&hdr->seq));
            }
          else 
#line 638
            {
              nidx = LinkEstimatorP$findWorstNeighborIdx(LinkEstimatorP$EVICT_EETX_THRESHOLD);
              if (nidx != LinkEstimatorP$INVALID_RVAL) {
                  ;

                  LinkEstimatorP$LinkEstimator$evicted(LinkEstimatorP$NeighborTable[nidx].ll_addr);
                  LinkEstimatorP$initNeighborIdx(nidx, ll_addr);
                }
              else 
#line 645
                {
                  ;
                }
            }
        }

      if (nidx != LinkEstimatorP$INVALID_RVAL && num_entries > 0) {
          ;
          footer = (linkest_footer_t *)((uint8_t *)LinkEstimatorP$SubPacket$getPayload(msg, (void *)0)
           + LinkEstimatorP$SubPacket$payloadLength(msg)
           - num_entries * sizeof(linkest_footer_t ));
          {
            uint8_t i;
#line 657
            uint8_t my_ll_addr;

#line 658
            my_ll_addr = LinkEstimatorP$SubAMPacket$address();
            for (i = 0; i < num_entries; i++) {
                ;

                if (__nesc_ntoh_uint16((unsigned char *)&footer->neighborList[i].ll_addr) == my_ll_addr) {
                    LinkEstimatorP$updateReverseQuality(ll_addr, __nesc_ntoh_uint8((unsigned char *)&footer->neighborList[i].inquality));
                  }
              }
          }
        }
      LinkEstimatorP$print_neighbor_table();
    }
}







static inline  message_t *LinkEstimatorP$SubReceive$receive(message_t *msg, 
void *payload, 
uint8_t len)
#line 680
{
  ;
  LinkEstimatorP$processReceivedMessage(msg, payload, len);
  return LinkEstimatorP$Receive$receive(msg, 
  LinkEstimatorP$Packet$getPayload(msg, (void *)0), 
  LinkEstimatorP$Packet$payloadLength(msg));
}

# 294 "/usr/lib/ncc/nesc_nx.h"
static __inline uint32_t __nesc_ntoh_uint32(const void *source)
#line 294
{
  const uint8_t *base = source;

#line 296
  return ((((uint32_t )base[0] << 24) | (
  (uint32_t )base[1] << 16)) | (
  (uint32_t )base[2] << 8)) | base[3];
}

# 142 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$incrementCounter(uint8_t id)
#line 142
{
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].count++;
}

# 251 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   void DisseminationEngineImplP$TrickleTimer$default$incrementCounter(uint16_t key)
#line 251
{
}

# 77 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
inline static  void DisseminationEngineImplP$TrickleTimer$incrementCounter(uint16_t arg_0x7d938688){
#line 77
  switch (arg_0x7d938688) {
#line 77
    case 42:
#line 77
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$incrementCounter(/*OctopusAppC.DisseminatorC*/DisseminatorC$0$TIMER_ID);
#line 77
      break;
#line 77
    default:
#line 77
      DisseminationEngineImplP$TrickleTimer$default$incrementCounter(arg_0x7d938688);
#line 77
      break;
#line 77
    }
#line 77
}
#line 77
# 249 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   void DisseminationEngineImplP$TrickleTimer$default$reset(uint16_t key)
#line 249
{
}

# 72 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
inline static  void DisseminationEngineImplP$TrickleTimer$reset(uint16_t arg_0x7d938688){
#line 72
  switch (arg_0x7d938688) {
#line 72
    case 42:
#line 72
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$reset(/*OctopusAppC.DisseminatorC*/DisseminatorC$0$TIMER_ID);
#line 72
      break;
#line 72
    default:
#line 72
      DisseminationEngineImplP$TrickleTimer$default$reset(arg_0x7d938688);
#line 72
      break;
#line 72
    }
#line 72
}
#line 72
# 238 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   
#line 237
void 
DisseminationEngineImplP$DisseminationCache$default$storeData(uint16_t key, void *data, 
uint8_t size, 
uint32_t seqno)
#line 240
{
}

# 48 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
inline static  void DisseminationEngineImplP$DisseminationCache$storeData(uint16_t arg_0x7d939bb0, void *arg_0x7d943e80, uint8_t arg_0x7d942030, uint32_t arg_0x7d9421c0){
#line 48
  switch (arg_0x7d939bb0) {
#line 48
    case 42:
#line 48
      /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$storeData(arg_0x7d943e80, arg_0x7d942030, arg_0x7d9421c0);
#line 48
      break;
#line 48
    default:
#line 48
      DisseminationEngineImplP$DisseminationCache$default$storeData(arg_0x7d939bb0, arg_0x7d943e80, arg_0x7d942030, arg_0x7d9421c0);
#line 48
      break;
#line 48
    }
#line 48
}
#line 48
# 106 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static inline  uint32_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestSeqno(void)
#line 106
{
  return /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno;
}

# 243 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   
#line 242
uint32_t 
DisseminationEngineImplP$DisseminationCache$default$requestSeqno(uint16_t key)
#line 243
{
#line 243
  return DISSEMINATION_SEQNO_UNKNOWN;
}

# 49 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
inline static  uint32_t DisseminationEngineImplP$DisseminationCache$requestSeqno(uint16_t arg_0x7d939bb0){
#line 49
  unsigned long result;
#line 49

#line 49
  switch (arg_0x7d939bb0) {
#line 49
    case 42:
#line 49
      result = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$requestSeqno();
#line 49
      break;
#line 49
    default:
#line 49
      result = DisseminationEngineImplP$DisseminationCache$default$requestSeqno(arg_0x7d939bb0);
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
# 161 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  message_t *DisseminationEngineImplP$Receive$receive(message_t *msg, 
void *payload, 
uint8_t len)
#line 163
{

  dissemination_message_t *dMsg = 
  (dissemination_message_t *)payload;

  uint16_t key = __nesc_ntoh_uint16((unsigned char *)&dMsg->key);
  uint32_t incomingSeqno = __nesc_ntoh_uint32((unsigned char *)&dMsg->seqno);
  uint32_t currentSeqno = DisseminationEngineImplP$DisseminationCache$requestSeqno(key);

  if (!DisseminationEngineImplP$m_running) {
#line 172
      return msg;
    }
  if (currentSeqno == DISSEMINATION_SEQNO_UNKNOWN && 
  incomingSeqno != DISSEMINATION_SEQNO_UNKNOWN) {

      DisseminationEngineImplP$DisseminationCache$storeData(key, 
      dMsg->data, 
      len - sizeof(dissemination_message_t ), 
      incomingSeqno);

      DisseminationEngineImplP$TrickleTimer$reset(key);
      return msg;
    }

  if (incomingSeqno == DISSEMINATION_SEQNO_UNKNOWN && 
  currentSeqno != DISSEMINATION_SEQNO_UNKNOWN) {

      DisseminationEngineImplP$TrickleTimer$reset(key);
      return msg;
    }

  if ((int32_t )(incomingSeqno - currentSeqno) > 0) {

      DisseminationEngineImplP$DisseminationCache$storeData(key, 
      dMsg->data, 
      len - sizeof(dissemination_message_t ), 
      incomingSeqno);
      ;
      DisseminationEngineImplP$TrickleTimer$reset(key);
    }
  else {
#line 202
    if ((int32_t )(incomingSeqno - currentSeqno) == 0) {

        DisseminationEngineImplP$TrickleTimer$incrementCounter(key);
      }
    else {


        DisseminationEngineImplP$sendObject(key);
      }
    }


  return msg;
}

static inline  message_t *DisseminationEngineImplP$ProbeReceive$receive(message_t *msg, 
void *payload, 
uint8_t len)
#line 219
{

  dissemination_probe_message_t *dpMsg = 
  (dissemination_probe_message_t *)payload;

  if (!DisseminationEngineImplP$m_running) {
#line 224
      return msg;
    }
  if (DisseminationEngineImplP$DisseminationCache$requestSeqno(__nesc_ntoh_uint16((unsigned char *)&dpMsg->key)) != 
  DISSEMINATION_SEQNO_UNKNOWN) {
      DisseminationEngineImplP$sendObject(__nesc_ntoh_uint16((unsigned char *)&dpMsg->key));
    }

  return msg;
}

# 152 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline   message_t *CC2420ActiveMessageP$Receive$default$receive(am_id_t id, message_t *msg, void *payload, uint8_t len)
#line 152
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420ActiveMessageP$Receive$receive(am_id_t arg_0x7e437cc8, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7e437cc8) {
#line 67
    case 13:
#line 67
      result = DisseminationEngineImplP$Receive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    case 14:
#line 67
      result = DisseminationEngineImplP$ProbeReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    case 23:
#line 67
      result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    case 24:
#line 67
      result = LinkEstimatorP$SubReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = CC2420ActiveMessageP$Receive$default$receive(arg_0x7e437cc8, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 137 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline  bool CC2420ActiveMessageP$AMPacket$isForMe(message_t *amsg)
#line 137
{
  return CC2420ActiveMessageP$AMPacket$destination(amsg) == CC2420ActiveMessageP$AMPacket$address() || 
  CC2420ActiveMessageP$AMPacket$destination(amsg) == AM_BROADCAST_ADDR;
}

#line 104
static inline  message_t *CC2420ActiveMessageP$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 104
{
  if (CC2420ActiveMessageP$AMPacket$isForMe(msg)) {
      return CC2420ActiveMessageP$Receive$receive(CC2420ActiveMessageP$AMPacket$type(msg), msg, payload, len - CC2420ActiveMessageP$CC2420_SIZE);
    }
  else {
      return CC2420ActiveMessageP$Snoop$receive(CC2420ActiveMessageP$AMPacket$type(msg), msg, payload, len - CC2420ActiveMessageP$CC2420_SIZE);
    }
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *UniqueReceiveP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = CC2420ActiveMessageP$SubReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 156 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueReceiveP.nc"
static inline void UniqueReceiveP$insert(uint16_t msgSource, uint8_t msgDsn)
#line 156
{
  uint8_t element = UniqueReceiveP$recycleSourceElement;
  bool increment = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 160
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
#line 173
    __nesc_atomic_end(__nesc_atomic); }
}


static inline   message_t *UniqueReceiveP$DuplicateReceive$default$receive(message_t *msg, void *payload, uint8_t len)
#line 177
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *UniqueReceiveP$DuplicateReceive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP$DuplicateReceive$default$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 130 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueReceiveP.nc"
static inline bool UniqueReceiveP$hasSeen(uint16_t msgSource, uint8_t msgDsn)
#line 130
{
  int i;

#line 132
  UniqueReceiveP$recycleSourceElement = UniqueReceiveP$INVALID_ELEMENT;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 134
    {
      for (i = 0; i < 4; i++) {
          if (UniqueReceiveP$receivedMessages[i].source == msgSource) {
              if (UniqueReceiveP$receivedMessages[i].dsn == msgDsn) {

                  {
                    unsigned char __nesc_temp = 
#line 139
                    TRUE;

                    {
#line 139
                      __nesc_atomic_end(__nesc_atomic); 
#line 139
                      return __nesc_temp;
                    }
                  }
                }
#line 142
              UniqueReceiveP$recycleSourceElement = i;
            }
        }
    }
#line 145
    __nesc_atomic_end(__nesc_atomic); }

  return FALSE;
}

# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_header_t *UniqueReceiveP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 104 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueReceiveP.nc"
static inline  message_t *UniqueReceiveP$SubReceive$receive(message_t *msg, void *payload, 
uint8_t len)
#line 105
{
  uint16_t msgSource = __nesc_ntoh_leuint16((unsigned char *)&UniqueReceiveP$CC2420Packet$getHeader(msg)->src);
  uint8_t msgDsn = __nesc_ntoh_leuint8((unsigned char *)&UniqueReceiveP$CC2420Packet$getHeader(msg)->dsn);

  if (UniqueReceiveP$hasSeen(msgSource, msgDsn)) {
      return UniqueReceiveP$DuplicateReceive$receive(msg, payload, len);
    }
  else {
      UniqueReceiveP$insert(msgSource, msgDsn);
      return UniqueReceiveP$Receive$receive(msg, payload, len);
    }
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t *CC2420ReceiveP$Receive$receive(message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  result = UniqueReceiveP$SubReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_metadata_t *CC2420ReceiveP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0){
#line 82
  nx_struct cc2420_metadata_t *result;
#line 82

#line 82
  result = CC2420PacketC$CC2420Packet$getMetadata(arg_0x7e448bc0);
#line 82

#line 82
  return result;
#line 82
}
#line 82
#line 77
inline static   cc2420_header_t *CC2420ReceiveP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 289 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline  void CC2420ReceiveP$receiveDone_task$runTask(void)
#line 289
{
  cc2420_header_t *header = CC2420ReceiveP$CC2420Packet$getHeader(CC2420ReceiveP$m_p_rx_buf);
  cc2420_metadata_t *metadata = CC2420ReceiveP$CC2420Packet$getMetadata(CC2420ReceiveP$m_p_rx_buf);
  uint8_t *buf = (uint8_t *)header;
  uint8_t length = buf[0];

  __nesc_hton_int8((unsigned char *)&metadata->crc, buf[length] >> 7);
  __nesc_hton_uint8((unsigned char *)&metadata->rssi, buf[length - 1]);
  __nesc_hton_uint8((unsigned char *)&metadata->lqi, buf[length] & 0x7f);
  CC2420ReceiveP$m_p_rx_buf = CC2420ReceiveP$Receive$receive(CC2420ReceiveP$m_p_rx_buf, CC2420ReceiveP$m_p_rx_buf->data, 
  length);

  CC2420ReceiveP$waitForNextPacket();
}

# 74 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static inline  const /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t */*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$get(void)
#line 74
{
  return &/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$valueCache;
}

# 47 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
inline static  const OctopusC$RequestValue$t *OctopusC$RequestValue$get(void){
#line 47
  nx_struct octopus_sent_msg const *result;
#line 47

#line 47
  result = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$get();
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 314 "OctopusC.nc"
static inline  void OctopusC$RequestValue$changed(void)
#line 314
{
  octopus_sent_msg_t *newRequest = (octopus_sent_msg_t *)OctopusC$RequestValue$get();




  OctopusC$processRequest(newRequest);
}

# 61 "/opt/tinyos-2.x/tos/lib/net/DisseminationValue.nc"
inline static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$changed(void){
#line 61
  OctopusC$RequestValue$changed();
#line 61
}
#line 61
# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void OctopusC$Timer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(0U);
#line 67
}
#line 67
# 51 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  error_t OctopusC$CollectInfo$getEtx(uint16_t *arg_0x7eb34478){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getEtx(arg_0x7eb34478);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 534 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getParent(am_addr_t *parent)
#line 534
{
  if (parent == (void *)0) {
    return FAIL;
    }
#line 537
  if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == INVALID_ADDR) {
    return FAIL;
    }
#line 539
  *parent = /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent;
  return SUCCESS;
}

# 41 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpInfo.nc"
inline static  error_t OctopusC$CollectInfo$getParent(am_addr_t *arg_0x7eb43e58){
#line 41
  unsigned char result;
#line 41

#line 41
  result = /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getParent(arg_0x7eb43e58);
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 54 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420LplDummyP.nc"
static inline  void CC2420LplDummyP$LowPowerListening$setLocalDutyCycle(uint16_t dutyCycle)
#line 54
{
}

# 76 "/opt/tinyos-2.x/tos/interfaces/LowPowerListening.nc"
inline static  void OctopusC$LowPowerListening$setLocalDutyCycle(uint16_t arg_0x7eb90890){
#line 76
  CC2420LplDummyP$LowPowerListening$setLocalDutyCycle(arg_0x7eb90890);
#line 76
}
#line 76
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgP$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 125 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getNow(void){
#line 125
  unsigned long result;
#line 125

#line 125
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getNow(7U);
#line 125

#line 125
  return result;
#line 125
}
#line 125








inline static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$gett0(void){
#line 133
  unsigned long result;
#line 133

#line 133
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$gett0(7U);
#line 133

#line 133
  return result;
#line 133
}
#line 133
# 55 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getMask(uint16_t bitnum)
{
  return 1 << bitnum % /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$ELEMENT_SIZE;
}

#line 50
static inline uint16_t /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getIndex(uint16_t bitnum)
{
  return bitnum / /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$ELEMENT_SIZE;
}

#line 76
static inline   bool /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$get(uint16_t bitnum)
{
  return /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getIndex(bitnum)] & /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getMask(bitnum) ? TRUE : FALSE;
}

# 46 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   bool /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$get(uint16_t arg_0x7d8b8a68){
#line 46
  unsigned char result;
#line 46

#line 46
  result = /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$get(arg_0x7d8b8a68);
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 86 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clear(uint16_t bitnum)
{
  /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getIndex(bitnum)] &= ~/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getMask(bitnum);
}

# 58 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clear(uint16_t arg_0x7d8b7510){
#line 58
  /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clear(arg_0x7d8b7510);
#line 58
}
#line 58
# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(7U, arg_0x7eb11338);
#line 62
}
#line 62





inline static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(7U);
#line 67
}
#line 67
# 280 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline uint8_t LinkEstimatorP$computeBidirEETX(uint8_t q1, uint8_t q2)
#line 280
{
  uint16_t q;

#line 282
  if (q1 > 0 && q2 > 0) {
      q = 65025u / q1;
      q = 10 * q / q2 - 10;
      if (q > 255) {
          q = LinkEstimatorP$LARGE_EETX_VALUE;
        }
      return (uint8_t )q;
    }
  else 
#line 289
    {
      return LinkEstimatorP$LARGE_EETX_VALUE;
    }
}



static inline void LinkEstimatorP$updateNeighborTableEst(am_addr_t n)
#line 296
{
  uint8_t i;
#line 297
  uint8_t totalPkt;
  neighbor_table_entry_t *ne;
  uint8_t newEst;
  uint8_t minPkt;

  minPkt = LinkEstimatorP$BLQ_PKT_WINDOW;
  ;
  for (i = 0; i < 10; i++) {
      ne = &LinkEstimatorP$NeighborTable[i];
      if (ne->ll_addr == n) {
          if (ne->flags & VALID_ENTRY) {
              if (ne->inage > 0) {
                ne->inage--;
                }
#line 310
              if (ne->outage > 0) {
                ne->outage--;
                }
              if (ne->inage == 0 && ne->outage == 0) {
                  ne->flags ^= VALID_ENTRY;
                  ne->inquality = ne->outquality = 0;
                }
              else 
#line 316
                {
                  ;
                  ne->flags |= MATURE_ENTRY;
                  totalPkt = ne->rcvcnt + ne->failcnt;
                  ;
                  if (totalPkt < minPkt) {
                      totalPkt = minPkt;
                    }
                  if (totalPkt == 0) {
                      ne->inquality = LinkEstimatorP$ALPHA * ne->inquality / 10;
                    }
                  else 
#line 326
                    {
                      newEst = 255 * ne->rcvcnt / totalPkt;
                      ;
                      ne->inquality = (LinkEstimatorP$ALPHA * ne->inquality + (10 - LinkEstimatorP$ALPHA) * newEst) / 10;
                    }
                  ne->rcvcnt = 0;
                  ne->failcnt = 0;
                }
              LinkEstimatorP$updateEETX(ne, LinkEstimatorP$computeBidirEETX(ne->inquality, ne->outquality));
            }
          else {
              ;
            }
        }
    }
}

# 715 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline error_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableEvict(am_addr_t neighbor)
#line 715
{
  uint8_t idx;
#line 716
  uint8_t i;

#line 717
  idx = /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(neighbor);
  if (idx == /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive) {
    return FAIL;
    }
#line 720
  /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive--;
  for (i = idx; i < /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive; i++) {
      /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[i] = /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[i + 1];
    }
  return SUCCESS;
}

# 688 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  void *LinkEstimatorP$Receive$getPayload(message_t *msg, uint8_t *len)
#line 688
{
  return LinkEstimatorP$Packet$getPayload(msg, len);
}

# 79 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  void */*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$getPayload(message_t *arg_0x7eb45a48, uint8_t *arg_0x7eb45bf0){
#line 79
  void *result;
#line 79

#line 79
  result = LinkEstimatorP$Receive$getPayload(arg_0x7eb45a48, arg_0x7eb45bf0);
#line 79

#line 79
  return result;
#line 79
}
#line 79
# 456 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline ctp_routing_header_t */*CtpP.Router*/CtpRoutingEngineP$0$getHeader(message_t *m)
#line 456
{
  return (ctp_routing_header_t *)/*CtpP.Router*/CtpRoutingEngineP$0$BeaconReceive$getPayload(m, (void *)0);
}

# 87 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ReceiveP$SpiResource$immediateRequest(void){
#line 87
  unsigned char result;
#line 87

#line 87
  result = CC2420SpiImplP$Resource$immediateRequest(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 87

#line 87
  return result;
#line 87
}
#line 87
# 153 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline   error_t CC2420SpiImplP$Fifo$continueRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 154
{
  CC2420SpiImplP$SpiPacket$send((void *)0, data, len);
  return SUCCESS;
}

#line 133
static inline   cc2420_status_t CC2420SpiImplP$Fifo$beginRead(uint8_t addr, uint8_t *data, 
uint8_t len)
#line 134
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 138
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 140
            status;

            {
#line 140
              __nesc_atomic_end(__nesc_atomic); 
#line 140
              return __nesc_temp;
            }
          }
        }
    }
#line 144
    __nesc_atomic_end(__nesc_atomic); }
#line 144
  CC2420SpiImplP$m_addr = addr | 0x40;

  status = CC2420SpiImplP$SpiByte$write(CC2420SpiImplP$m_addr);
  CC2420SpiImplP$Fifo$continueRead(addr, data, len);

  return status;
}

# 51 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
inline static   cc2420_status_t CC2420ReceiveP$RXFIFO$beginRead(uint8_t *arg_0x7e039458, uint8_t arg_0x7e0395e0){
#line 51
  unsigned char result;
#line 51

#line 51
  result = CC2420SpiImplP$Fifo$beginRead(CC2420_RXFIFO, arg_0x7e039458, arg_0x7e0395e0);
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ReceiveP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiImplP$Resource$request(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 82 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_metadata_t *CC2420TransmitP$CC2420Packet$getMetadata(message_t *arg_0x7e448bc0){
#line 82
  nx_struct cc2420_metadata_t *result;
#line 82

#line 82
  result = CC2420PacketC$CC2420Packet$getMetadata(arg_0x7e448bc0);
#line 82

#line 82
  return result;
#line 82
}
#line 82
# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void CC2420TransmitP$LplDisableTimer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(2U, arg_0x7eb11338);
#line 62
}
#line 62
# 762 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline  void CC2420TransmitP$startLplTimer$runTask(void)
#line 762
{
  CC2420TransmitP$LplDisableTimer$startOneShot(__nesc_ntoh_uint16((unsigned char *)&CC2420TransmitP$CC2420Packet$getMetadata(CC2420TransmitP$m_msg)->rxInterval) + 10);
}

# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$RXCTRL1$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_RXCTRL1, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static   cc2420_status_t CC2420ControlP$MDMCTRL0$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_MDMCTRL0, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static   cc2420_status_t CC2420ControlP$FSCTRL$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_FSCTRL, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
inline static   cc2420_status_t CC2420ControlP$IOCFG0$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_IOCFG0, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SXOSCON$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SXOSCON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t HplCC2420InterruptsP$CCATask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(HplCC2420InterruptsP$CCATask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   bool /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$get(void)
#line 45
{
#line 45
  return (* (volatile uint8_t *)48U & (1 << 5)) != 0;
}

# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool HplCC2420InterruptsP$CC_CCA$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 104 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline   error_t HplCC2420InterruptsP$CCA$enableRisingEdge(void)
#line 104
{
  /* atomic removed: atomic calls only */
#line 105
  HplCC2420InterruptsP$ccaWaitForState = TRUE;
  /* atomic removed: atomic calls only */
#line 106
  HplCC2420InterruptsP$ccaTimerDisabled = FALSE;
  HplCC2420InterruptsP$ccaLastState = HplCC2420InterruptsP$CC_CCA$get();
  HplCC2420InterruptsP$CCATask$postTask();
  return SUCCESS;
}

# 42 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ControlP$InterruptCCA$enableRisingEdge(void){
#line 42
  unsigned char result;
#line 42

#line 42
  result = HplCC2420InterruptsP$CCA$enableRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$IOCFG1$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_IOCFG1, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 155 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$startOscillator(void)
#line 155
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 156
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_VREG_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 158
            FAIL;

            {
#line 158
              __nesc_atomic_end(__nesc_atomic); 
#line 158
              return __nesc_temp;
            }
          }
        }
#line 161
      CC2420ControlP$m_state = CC2420ControlP$S_XOSC_STARTING;
      CC2420ControlP$IOCFG1$write(CC2420_SFDMUX_XOSC16M_STABLE << 
      CC2420_IOCFG1_CCAMUX);

      CC2420ControlP$InterruptCCA$enableRisingEdge();
      CC2420ControlP$SXOSCON$strobe();

      CC2420ControlP$IOCFG0$write((1 << CC2420_IOCFG0_FIFOP_POLARITY) | (
      127 << CC2420_IOCFG0_FIFOP_THR));

      CC2420ControlP$FSCTRL$write((1 << CC2420_FSCTRL_LOCK_THR) | (((
      CC2420ControlP$m_channel - 11) * 5 + 357)
       << CC2420_FSCTRL_FREQ));

      CC2420ControlP$MDMCTRL0$write(((((((1 << CC2420_MDMCTRL0_RESERVED_FRAME_MODE) | (
      1 << CC2420_MDMCTRL0_ADR_DECODE)) | (
      2 << CC2420_MDMCTRL0_CCA_HYST)) | (
      3 << CC2420_MDMCTRL0_CCA_MOD)) | (
      1 << CC2420_MDMCTRL0_AUTOCRC)) | (



      0 << CC2420_MDMCTRL0_AUTOACK)) | (

      2 << CC2420_MDMCTRL0_PREAMBLE_LENGTH));

      CC2420ControlP$RXCTRL1$write(((((((1 << CC2420_RXCTRL1_RXBPF_LOCUR) | (
      1 << CC2420_RXCTRL1_LOW_LOWGAIN)) | (
      1 << CC2420_RXCTRL1_HIGH_HGM)) | (
      1 << CC2420_RXCTRL1_LNA_CAP_ARRAY)) | (
      1 << CC2420_RXCTRL1_RXMIX_TAIL)) | (
      1 << CC2420_RXCTRL1_RXMIX_VCM)) | (
      2 << CC2420_RXCTRL1_RXMIX_CURRENT));
    }
#line 194
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
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
# 204 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$Resource$granted(void)
#line 204
{
  CC2420CsmaP$CC2420Power$startOscillator();
}

# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void CC2420ControlP$Resource$granted(void){
#line 92
  CC2420CsmaP$Resource$granted();
#line 92
}
#line 92
# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$CSN$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr();
#line 30
}
#line 30
# 304 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline  void CC2420ControlP$SpiResource$granted(void)
#line 304
{
  CC2420ControlP$CSN$clr();
  CC2420ControlP$Resource$granted();
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420ControlP$syncDone_task$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420ControlP$syncDone_task);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SyncResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiImplP$Resource$release(/*CC2420ControlC.SyncSpiC*/CC2420SpiC$1$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)56U |= 1 << 0;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$CSN$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set();
#line 29
}
#line 29
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SRXON$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SRXON);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 63 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Ram.nc"
inline static   cc2420_status_t CC2420ControlP$PANID$write(uint8_t arg_0x7e30f388, uint8_t *arg_0x7e30f530, uint8_t arg_0x7e30f6b8){
#line 63
  unsigned char result;
#line 63

#line 63
  result = CC2420SpiImplP$Ram$write(CC2420_RAM_PANID, arg_0x7e30f388, arg_0x7e30f530, arg_0x7e30f6b8);
#line 63

#line 63
  return result;
#line 63
}
#line 63
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ControlP$SRFOFF$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SRFOFF);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 278 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline  void CC2420ControlP$SyncResource$granted(void)
#line 278
{

  nxle_uint16_t id[2];
  uint8_t channel;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 283
    {
      channel = CC2420ControlP$m_channel;
      __nesc_hton_leuint16((unsigned char *)&id[0], CC2420ControlP$m_pan);
      __nesc_hton_leuint16((unsigned char *)&id[1], CC2420ControlP$m_short_addr);
    }
#line 287
    __nesc_atomic_end(__nesc_atomic); }

  CC2420ControlP$CSN$clr();
  CC2420ControlP$SRFOFF$strobe();
  CC2420ControlP$FSCTRL$write((1 << CC2420_FSCTRL_LOCK_THR) | (((
  channel - 11) * 5 + 357) << CC2420_FSCTRL_FREQ));
  CC2420ControlP$PANID$write(0, (uint8_t *)id, sizeof id);
  CC2420ControlP$CSN$set();
  CC2420ControlP$CSN$clr();
  CC2420ControlP$SRXON$strobe();
  CC2420ControlP$CSN$set();
  CC2420ControlP$SyncResource$release();

  CC2420ControlP$syncDone_task$postTask();
}

#line 355
static inline   void CC2420ControlP$ReadRssi$default$readDone(error_t error, uint16_t data)
#line 355
{
}

# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
inline static  void CC2420ControlP$ReadRssi$readDone(error_t arg_0x7eaf5668, CC2420ControlP$ReadRssi$val_t arg_0x7eaf57f0){
#line 63
  CC2420ControlP$ReadRssi$default$readDone(arg_0x7eaf5668, arg_0x7eaf57f0);
#line 63
}
#line 63
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$RssiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiImplP$Resource$release(/*CC2420ControlC.RssiResource*/CC2420SpiC$2$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 233 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline   cc2420_status_t CC2420SpiImplP$Reg$read(uint8_t addr, uint16_t *data)
#line 233
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 237
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 239
            status;

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
#line 243
  status = CC2420SpiImplP$SpiByte$write(addr | 0x40);
  *data = (uint16_t )CC2420SpiImplP$SpiByte$write(0) << 8;
  *data |= CC2420SpiImplP$SpiByte$write(0);

  return status;
}

# 47 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
inline static   cc2420_status_t CC2420ControlP$RSSI$read(uint16_t *arg_0x7e30c4a0){
#line 47
  unsigned char result;
#line 47

#line 47
  result = CC2420SpiImplP$Reg$read(CC2420_RSSI, arg_0x7e30c4a0);
#line 47

#line 47
  return result;
#line 47
}
#line 47
# 309 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline  void CC2420ControlP$RssiResource$granted(void)
#line 309
{
  uint16_t data;

#line 311
  CC2420ControlP$CSN$clr();
  CC2420ControlP$RSSI$read(&data);
  CC2420ControlP$CSN$set();

  CC2420ControlP$RssiResource$release();
  data += 0x7f;
  data &= 0x00ff;
  CC2420ControlP$ReadRssi$readDone(SUCCESS, data);
}

# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420TransmitP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiImplP$Resource$release(/*CC2420TransmitC.Spi*/CC2420SpiC$3$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 706 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline error_t CC2420TransmitP$releaseSpiResource(void)
#line 706
{
  CC2420TransmitP$SpiResource$release();
  return SUCCESS;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CSN$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set();
#line 29
}
#line 29
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420TransmitP$SFLUSHTX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SFLUSHTX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CSN$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr();
#line 30
}
#line 30
# 358 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline  void CC2420TransmitP$SpiResource$granted(void)
#line 358
{
  uint8_t cur_state;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 361
    {
      cur_state = CC2420TransmitP$m_state;
    }
#line 363
    __nesc_atomic_end(__nesc_atomic); }

  switch (cur_state) {
      case CC2420TransmitP$S_LOAD: 
        CC2420TransmitP$loadTXFIFO();
      break;

      case CC2420TransmitP$S_BEGIN_TRANSMIT: 
        CC2420TransmitP$attemptSend();
      break;

      case CC2420TransmitP$S_LOAD_CANCEL: 
        case CC2420TransmitP$S_CCA_CANCEL: 
          case CC2420TransmitP$S_TX_CANCEL: 
            CC2420TransmitP$CSN$clr();
      CC2420TransmitP$SFLUSHTX$strobe();
      CC2420TransmitP$CSN$set();
      CC2420TransmitP$releaseSpiResource();
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 381
        {
          if (CC2420TransmitP$signalSendDone) {
              CC2420TransmitP$signalDone(ECANCEL);
            }
          else 
#line 384
            {
              CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
            }
        }
#line 387
        __nesc_atomic_end(__nesc_atomic); }
      break;

      default: 
        CC2420TransmitP$releaseSpiResource();
      break;
    }
}

# 185 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline  void CC2420ReceiveP$SpiResource$granted(void)
#line 185
{
  CC2420ReceiveP$receive();
}

# 64 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline   void CC2420SpiImplP$Resource$default$granted(uint8_t id)
#line 64
{
}

# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void CC2420SpiImplP$Resource$granted(uint8_t arg_0x7e01f6b8){
#line 92
  switch (arg_0x7e01f6b8) {
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
      CC2420SpiImplP$Resource$default$granted(arg_0x7e01f6b8);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 127 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline  void CC2420SpiImplP$SpiResource$granted(void)
#line 127
{
  uint8_t holder;

#line 129
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 129
    holder = CC2420SpiImplP$m_holder;
#line 129
    __nesc_atomic_end(__nesc_atomic); }
  CC2420SpiImplP$Resource$granted(holder);
}

# 339 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline   void Atm128SpiP$Resource$default$granted(uint8_t id)
#line 339
{
}

# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void Atm128SpiP$Resource$granted(uint8_t arg_0x7dfbca68){
#line 92
  switch (arg_0x7dfbca68) {
#line 92
    case 0U:
#line 92
      CC2420SpiImplP$SpiResource$granted();
#line 92
      break;
#line 92
    default:
#line 92
      Atm128SpiP$Resource$default$granted(arg_0x7dfbca68);
#line 92
      break;
#line 92
    }
#line 92
}
#line 92
# 335 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline  void Atm128SpiP$ResourceArbiter$granted(uint8_t id)
#line 335
{
  Atm128SpiP$Resource$granted(id);
}

# 92 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static  void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$granted(uint8_t arg_0x7dee3a00){
#line 92
  Atm128SpiP$ResourceArbiter$granted(arg_0x7dee3a00);
#line 92
}
#line 92
# 150 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline  void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$runTask(void)
#line 150
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 151
    {
      /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$reqResId;
      /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_BUSY;
    }
#line 154
    __nesc_atomic_end(__nesc_atomic); }
  /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$configure(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId);
  /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$granted(/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId);
}

# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
inline static   void Atm128SpiP$McuPowerState$update(void){
#line 44
  McuSleepC$McuPowerState$update();
#line 44
}
#line 44
# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void HplAtm128SpiP$SS$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set();
#line 29
}
#line 29
# 95 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   void HplAtm128SpiP$SPI$sleep(void)
#line 95
{
  HplAtm128SpiP$SS$set();
}

# 72 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void Atm128SpiP$Spi$sleep(void){
#line 72
  HplAtm128SpiP$SPI$sleep();
#line 72
}
#line 72
#line 99
inline static   void Atm128SpiP$Spi$enableSpi(bool arg_0x7dfb1598){
#line 99
  HplAtm128SpiP$SPI$enableSpi(arg_0x7dfb1598);
#line 99
}
#line 99
# 120 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline void Atm128SpiP$stopSpi(void)
#line 120
{
  Atm128SpiP$Spi$enableSpi(FALSE);
  Atm128SpiP$started = FALSE;
  /* atomic removed: atomic calls only */
#line 123
  {
    Atm128SpiP$Spi$sleep();
  }
  Atm128SpiP$McuPowerState$update();
}

# 80 "/opt/tinyos-2.x/tos/interfaces/ArbiterInfo.nc"
inline static   bool Atm128SpiP$ArbiterInfo$inUse(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ArbiterInfo$inUse();
#line 80

#line 80
  return result;
#line 80
}
#line 80
# 168 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline    void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$unconfigure(uint8_t id)
#line 168
{
}

# 55 "/opt/tinyos-2.x/tos/interfaces/ResourceConfigure.nc"
inline static   void /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$unconfigure(uint8_t arg_0x7dee2ed0){
#line 55
    /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$default$unconfigure(arg_0x7dee2ed0);
#line 55
}
#line 55
# 58 "/opt/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   resource_client_id_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue(void)
#line 58
{
  /* atomic removed: atomic calls only */
#line 59
  {
    if (/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead != /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
        uint8_t id = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead;

#line 62
        /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ[/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead];
        if (/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead == /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY) {
          /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qTail = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
          }
#line 65
        /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ[id] = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
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
      /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;

#line 68
      return __nesc_temp;
    }
  }
}

# 60 "/opt/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   resource_client_id_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$dequeue(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$dequeue();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 50 "/opt/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline   bool /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty(void)
#line 50
{
  return /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$qHead == /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY;
}

# 43 "/opt/tinyos-2.x/tos/interfaces/ResourceQueue.nc"
inline static   bool /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$isEmpty(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$FcfsQueue$isEmpty();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 97 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static inline   error_t /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$release(uint8_t id)
#line 97
{
  bool released = FALSE;

  /* atomic removed: atomic calls only */
#line 99
  {
    if (/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state == /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_BUSY && /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId == id) {
        if (/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$isEmpty() == FALSE) {
            /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$reqResId = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Queue$dequeue();
            /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_GRANTING;
            /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$postTask();
          }
        else {
            /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$resId = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$NO_RES;
            /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_IDLE;
          }
        released = TRUE;
      }
  }
  if (released == TRUE) {
      /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ResourceConfigure$unconfigure(id);
      return SUCCESS;
    }
  return FAIL;
}

# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t Atm128SpiP$ResourceArbiter$release(uint8_t arg_0x7dfb9bf0){
#line 110
  unsigned char result;
#line 110

#line 110
  result = /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$Resource$release(arg_0x7dfb9bf0);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 321 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline   error_t Atm128SpiP$Resource$release(uint8_t id)
#line 321
{
  error_t error = Atm128SpiP$ResourceArbiter$release(id);

  /* atomic removed: atomic calls only */
#line 323
  {
    if (!Atm128SpiP$ArbiterInfo$inUse()) {
        Atm128SpiP$stopSpi();
      }
  }
  return error;
}

# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420SpiImplP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = Atm128SpiP$Resource$release(0U);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 195 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Transmit$sendDone(message_t *p_msg, error_t err)
#line 195
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 196
    CC2420CsmaP$sendErr = err;
#line 196
    __nesc_atomic_end(__nesc_atomic); }
  CC2420CsmaP$sendDone_task$postTask();
}

# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Transmit.nc"
inline static   void CC2420TransmitP$Send$sendDone(message_t *arg_0x7e35dd90, error_t arg_0x7e35df18){
#line 71
  CC2420CsmaP$CC2420Transmit$sendDone(arg_0x7e35dd90, arg_0x7e35df18);
#line 71
}
#line 71
# 216 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$RadioBackoff$setInitialBackoff(uint16_t backoffTime)
#line 216
{
  CC2420TransmitP$myInitialBackoff = backoffTime + 1;
}

# 43 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$SubBackoff$setInitialBackoff(uint16_t arg_0x7e4459b0){
#line 43
  CC2420TransmitP$RadioBackoff$setInitialBackoff(arg_0x7e4459b0);
#line 43
}
#line 43
# 274 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(am_id_t amId, 
message_t *msg)
#line 275
{
}

# 72 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestInitialBackoff(am_id_t arg_0x7e36c010, message_t *arg_0x7e4420a8){
#line 72
    CC2420CsmaP$RadioBackoff$default$requestInitialBackoff(arg_0x7e36c010, arg_0x7e4420a8);
#line 72
}
#line 72
# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   uint16_t HplAtm128Timer1P$Timer$get(void)
#line 49
{
#line 49
  return * (volatile uint16_t *)(0x2C + 0x20);
}

# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$get(void){
#line 52
  unsigned int result;
#line 52

#line 52
  result = HplAtm128Timer1P$Timer$get();
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 41 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   /*CounterOne16C.NCounter*/Atm128CounterC$1$timer_size /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$get(void)
{
  return /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$get();
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$get(void){
#line 53
  unsigned int result;
#line 53

#line 53
  result = /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
inline static   Atm128_TIFR_t HplAtm128Timer1P$Timer0Ctrl$getInterruptFlag(void){
#line 44
  union __nesc_unnamed4272 result;
#line 44

#line 44
  result = HplAtm128Timer0AsyncP$TimerCtrl$getInterruptFlag();
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 144 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   bool HplAtm128Timer1P$Timer$test(void)
#line 144
{
  return HplAtm128Timer1P$Timer0Ctrl$getInterruptFlag().bits.tov1;
}

# 78 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   bool /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$test(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = HplAtm128Timer1P$Timer$test();
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 46 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   bool /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$isOverflowPending(void)
{
  return /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$test();
}

# 60 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   bool /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$isOverflowPending(void){
#line 60
  unsigned char result;
#line 60

#line 60
  result = /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$isOverflowPending();
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 133 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$CompareA$start(void)
#line 133
{
#line 133
  * (volatile uint8_t *)(0x37 + 0x20) |= 1 << 4;
}

# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$start(void){
#line 56
  HplAtm128Timer1P$CompareA$start();
#line 56
}
#line 56
# 127 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$CompareA$reset(void)
#line 127
{
#line 127
  * (volatile uint8_t *)(0x36 + 0x20) = 1 << 4;
}

# 53 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$reset(void){
#line 53
  HplAtm128Timer1P$CompareA$reset();
#line 53
}
#line 53
# 183 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$CompareA$set(uint16_t t)
#line 183
{
#line 183
  * (volatile uint16_t *)(0x2A + 0x20) = t;
}

# 45 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$set(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$size_type arg_0x7e981c38){
#line 45
  HplAtm128Timer1P$CompareA$set(arg_0x7e981c38);
#line 45
}
#line 45
# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$timer_size /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$get(void){
#line 52
  unsigned int result;
#line 52

#line 52
  result = HplAtm128Timer1P$Timer$get();
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 74 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size dt)
#line 74
{
  /* atomic removed: atomic calls only */






  {
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size now;
#line 83
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size elapsed;
#line 83
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$timer_size expires;

    ;


    now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$get();
    elapsed = now + 3 - t0;
    if (elapsed >= dt) {
      expires = now + 3;
      }
    else {
#line 93
      expires = t0 + dt;
      }



    if (expires == 0) {
      expires = 1;
      }



    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$set(expires - 1);
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$reset();
    /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$start();
  }
}

# 92 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$size_type arg_0x7e9d39e0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$size_type arg_0x7e9d3b70){
#line 92
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$startAt(arg_0x7e9d39e0, arg_0x7e9d3b70);
#line 92
}
#line 92
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420TransmitP$STXONCCA$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_STXONCCA);
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
  result = CC2420SpiImplP$Strobe$strobe(CC2420_STXON);
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
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SNOP);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t CC2420TransmitP$startLplTimer$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(CC2420TransmitP$startLplTimer);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 282 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestLplBackoff(am_id_t amId, 
message_t *msg)
#line 283
{
}

# 87 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestLplBackoff(am_id_t arg_0x7e36c010, message_t *arg_0x7e442c18){
#line 87
    CC2420CsmaP$RadioBackoff$default$requestLplBackoff(arg_0x7e36c010, arg_0x7e442c18);
#line 87
}
#line 87
# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t CC2420CsmaP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgP$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 232 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$RadioBackoff$setLplBackoff(uint16_t backoffTime)
#line 232
{
  CC2420TransmitP$myLplBackoff = backoffTime + 1;
}

# 56 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$SubBackoff$setLplBackoff(uint16_t arg_0x7e444590){
#line 56
  CC2420TransmitP$RadioBackoff$setLplBackoff(arg_0x7e444590);
#line 56
}
#line 56
# 229 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$SubBackoff$requestLplBackoff(message_t *msg)
#line 229
{
  CC2420CsmaP$SubBackoff$setLplBackoff(CC2420CsmaP$Random$rand16() % 10);

  CC2420CsmaP$RadioBackoff$requestLplBackoff(__nesc_ntoh_leuint8((unsigned char *)&((cc2420_header_t *)(msg->data - 
  sizeof(cc2420_header_t )))->type), msg);
}

# 87 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420TransmitP$RadioBackoff$requestLplBackoff(message_t *arg_0x7e442c18){
#line 87
  CC2420CsmaP$SubBackoff$requestLplBackoff(arg_0x7e442c18);
#line 87
}
#line 87
# 278 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline    void CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(am_id_t amId, 
message_t *msg)
#line 279
{
}

# 79 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$RadioBackoff$requestCongestionBackoff(am_id_t arg_0x7e36c010, message_t *arg_0x7e442660){
#line 79
    CC2420CsmaP$RadioBackoff$default$requestCongestionBackoff(arg_0x7e36c010, arg_0x7e442660);
#line 79
}
#line 79
# 224 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$RadioBackoff$setCongestionBackoff(uint16_t backoffTime)
#line 224
{
  CC2420TransmitP$myCongestionBackoff = backoffTime + 1;
}

# 49 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420CsmaP$SubBackoff$setCongestionBackoff(uint16_t arg_0x7e444010){
#line 49
  CC2420TransmitP$RadioBackoff$setCongestionBackoff(arg_0x7e444010);
#line 49
}
#line 49
# 221 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$SubBackoff$requestCongestionBackoff(message_t *msg)
#line 221
{
  CC2420CsmaP$SubBackoff$setCongestionBackoff(CC2420CsmaP$Random$rand16()
   % (0x7 * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP$RadioBackoff$requestCongestionBackoff(__nesc_ntoh_leuint8((unsigned char *)&((cc2420_header_t *)(msg->data - 
  sizeof(cc2420_header_t )))->type), msg);
}

# 79 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420TransmitP$RadioBackoff$requestCongestionBackoff(message_t *arg_0x7e442660){
#line 79
  CC2420CsmaP$SubBackoff$requestCongestionBackoff(arg_0x7e442660);
#line 79
}
#line 79
# 71 "/opt/tinyos-2.x/tos/interfaces/SpiPacket.nc"
inline static   void Atm128SpiP$SpiPacket$sendDone(uint8_t *arg_0x7e014290, uint8_t *arg_0x7e014438, uint16_t arg_0x7e0145c8, error_t arg_0x7e014760){
#line 71
  CC2420SpiImplP$SpiPacket$sendDone(arg_0x7e014290, arg_0x7e014438, arg_0x7e0145c8, arg_0x7e014760);
#line 71
}
#line 71
# 207 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline  void Atm128SpiP$zeroTask$runTask(void)
#line 207
{
  uint8_t *rx;
  uint8_t *tx;
  uint16_t myLen;

#line 211
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 211
    {
      rx = Atm128SpiP$rxBuffer;
      tx = Atm128SpiP$txBuffer;
      myLen = Atm128SpiP$len;
      Atm128SpiP$rxBuffer = (void *)0;
      Atm128SpiP$txBuffer = (void *)0;
      Atm128SpiP$len = 0;
      Atm128SpiP$pos = 0;
      Atm128SpiP$SpiPacket$sendDone(tx, rx, myLen, SUCCESS);
    }
#line 220
    __nesc_atomic_end(__nesc_atomic); }
}

# 444 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$TXFIFO$readDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 445
{
}

# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ReceiveP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiImplP$Resource$release(/*CC2420ReceiveC.Spi*/CC2420SpiC$4$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ReceiveP$CSN$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$set();
#line 29
}
#line 29
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 139 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$CompareA$stop(void)
#line 139
{
#line 139
  * (volatile uint8_t *)(0x37 + 0x20) &= ~(1 << 4);
}

# 59 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$stop(void){
#line 59
  HplAtm128Timer1P$CompareA$stop();
#line 59
}
#line 59
# 65 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$stop(void)
#line 65
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$stop();
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$stop(void){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$stop();
#line 62
}
#line 62
# 91 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$stop(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$stop();
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420TransmitP$BackoffTimer$stop(void){
#line 62
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$stop();
#line 62
}
#line 62
# 77 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Packet.nc"
inline static   cc2420_header_t *CC2420TransmitP$CC2420Packet$getHeader(message_t *arg_0x7e448670){
#line 77
  nx_struct cc2420_header_t *result;
#line 77

#line 77
  result = CC2420PacketC$CC2420Packet$getHeader(arg_0x7e448670);
#line 77

#line 77
  return result;
#line 77
}
#line 77
# 332 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$CC2420Receive$receive(uint8_t type, message_t *ack_msg)
#line 332
{
  cc2420_header_t *ack_header;
  cc2420_header_t *msg_header;
  cc2420_metadata_t *msg_metadata;
  uint8_t *ack_buf;
  uint8_t length;

  if (type == IEEE154_TYPE_ACK) {
      ack_header = CC2420TransmitP$CC2420Packet$getHeader(ack_msg);
      msg_header = CC2420TransmitP$CC2420Packet$getHeader(CC2420TransmitP$m_msg);
      msg_metadata = CC2420TransmitP$CC2420Packet$getMetadata(CC2420TransmitP$m_msg);
      ack_buf = (uint8_t *)ack_header;
      length = __nesc_ntoh_leuint8((unsigned char *)&ack_header->length);

      if (CC2420TransmitP$m_state == CC2420TransmitP$S_ACK_WAIT && __nesc_ntoh_leuint8((unsigned char *)&
      msg_header->dsn) == __nesc_ntoh_leuint8((unsigned char *)&ack_header->dsn)) {
          CC2420TransmitP$BackoffTimer$stop();
          __nesc_hton_int8((unsigned char *)&msg_metadata->ack, TRUE);
          __nesc_hton_uint8((unsigned char *)&msg_metadata->rssi, ack_buf[length - 1]);
          __nesc_hton_uint8((unsigned char *)&msg_metadata->lqi, ack_buf[length] & 0x7f);
          CC2420TransmitP$signalDone(SUCCESS);
        }
    }
}

# 61 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
inline static   void CC2420ReceiveP$CC2420Receive$receive(uint8_t arg_0x7de51408, message_t *arg_0x7de515b8){
#line 61
  CC2420TransmitP$CC2420Receive$receive(arg_0x7de51408, arg_0x7de515b8);
#line 61
}
#line 61
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ReceiveP$SACK$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SACK);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ReceiveP$CSN$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$clr();
#line 30
}
#line 30
# 58 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
inline static   am_addr_t CC2420ReceiveP$amAddress(void){
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
# 62 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
inline static   error_t CC2420ReceiveP$RXFIFO$continueRead(uint8_t *arg_0x7e039bf0, uint8_t arg_0x7e039d78){
#line 62
  unsigned char result;
#line 62

#line 62
  result = CC2420SpiImplP$Fifo$continueRead(CC2420_RXFIFO, arg_0x7e039bf0, arg_0x7e039d78);
#line 62

#line 62
  return result;
#line 62
}
#line 62
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   bool /*HplAtm128GeneralIOC.PortE.Bit4*/HplAtm128GeneralIOPinP$36$IO$get(void)
#line 45
{
#line 45
  return (* (volatile uint8_t *)33U & (1 << 4)) != 0;
}

# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420ReceiveP$FIFOP$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplAtm128GeneralIOC.PortE.Bit4*/HplAtm128GeneralIOPinP$36$IO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   bool /*HplAtm128GeneralIOC.PortE.Bit5*/HplAtm128GeneralIOPinP$37$IO$get(void)
#line 45
{
#line 45
  return (* (volatile uint8_t *)33U & (1 << 5)) != 0;
}

# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420ReceiveP$FIFO$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplAtm128GeneralIOC.PortE.Bit5*/HplAtm128GeneralIOPinP$37$IO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 194 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$RXFIFO$readDone(uint8_t *rx_buf, uint8_t rx_len, 
error_t error)
#line 195
{
  cc2420_header_t *header = CC2420ReceiveP$CC2420Packet$getHeader(CC2420ReceiveP$m_p_rx_buf);
  cc2420_metadata_t *metadata = CC2420ReceiveP$CC2420Packet$getMetadata(CC2420ReceiveP$m_p_rx_buf);
  uint8_t *buf = (uint8_t *)header;
  uint8_t length = buf[0];

  switch (CC2420ReceiveP$m_state) {

      case CC2420ReceiveP$S_RX_HEADER: 
        CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_PAYLOAD;
      if (length + 1 > CC2420ReceiveP$m_bytes_left) {
          CC2420ReceiveP$flush();
        }
      else {
          if (!CC2420ReceiveP$FIFO$get() && !CC2420ReceiveP$FIFOP$get()) {
              CC2420ReceiveP$m_bytes_left -= length + 1;
            }

          if (length <= MAC_PACKET_SIZE) {
              if (length > 0) {

                  CC2420ReceiveP$RXFIFO$continueRead((uint8_t *)CC2420ReceiveP$CC2420Packet$getHeader(
                  CC2420ReceiveP$m_p_rx_buf) + 1, length);
                }
              else {

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

      case CC2420ReceiveP$S_RX_PAYLOAD: 
        CC2420ReceiveP$CSN$set();





      if (((__nesc_ntoh_leuint16((unsigned char *)&
#line 238
      header->fcf) >> IEEE154_FCF_ACK_REQ) & 0x01) == 1
       && __nesc_ntoh_leuint16((unsigned char *)&header->dest) == CC2420ReceiveP$amAddress()
       && ((__nesc_ntoh_leuint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_DATA) {
          CC2420ReceiveP$CSN$clr();
          CC2420ReceiveP$SACK$strobe();
          CC2420ReceiveP$CSN$set();
        }


      CC2420ReceiveP$SpiResource$release();

      if (CC2420ReceiveP$m_timestamp_size) {
          if (length > 10) {
              __nesc_hton_uint16((unsigned char *)&metadata->time, CC2420ReceiveP$m_timestamp_queue[CC2420ReceiveP$m_timestamp_head]);
              CC2420ReceiveP$m_timestamp_head = (CC2420ReceiveP$m_timestamp_head + 1) % CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE;
              CC2420ReceiveP$m_timestamp_size--;
            }
        }
      else 
#line 255
        {
          __nesc_hton_uint16((unsigned char *)&metadata->time, 0xffff);
        }


      if (buf[length] >> 7 && rx_buf) {
          uint8_t type = (__nesc_ntoh_leuint16((unsigned char *)&header->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7;

#line 262
          CC2420ReceiveP$CC2420Receive$receive(type, CC2420ReceiveP$m_p_rx_buf);
          if (type == IEEE154_TYPE_DATA) {
              CC2420ReceiveP$receiveDone_task$postTask();
              return;
            }
        }

      CC2420ReceiveP$waitForNextPacket();
      break;

      default: 
        CC2420ReceiveP$CSN$set();
      CC2420ReceiveP$SpiResource$release();
      break;
    }
}

# 274 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline    void CC2420SpiImplP$Fifo$default$readDone(uint8_t addr, uint8_t *rx_buf, uint8_t rx_len, error_t error)
#line 274
{
}

# 71 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
inline static   void CC2420SpiImplP$Fifo$readDone(uint8_t arg_0x7e01e068, uint8_t *arg_0x7e0383f0, uint8_t arg_0x7e038578, error_t arg_0x7e038700){
#line 71
  switch (arg_0x7e01e068) {
#line 71
    case CC2420_TXFIFO:
#line 71
      CC2420TransmitP$TXFIFO$readDone(arg_0x7e0383f0, arg_0x7e038578, arg_0x7e038700);
#line 71
      break;
#line 71
    case CC2420_RXFIFO:
#line 71
      CC2420ReceiveP$RXFIFO$readDone(arg_0x7e0383f0, arg_0x7e038578, arg_0x7e038700);
#line 71
      break;
#line 71
    default:
#line 71
      CC2420SpiImplP$Fifo$default$readDone(arg_0x7e01e068, arg_0x7e0383f0, arg_0x7e038578, arg_0x7e038700);
#line 71
      break;
#line 71
    }
#line 71
}
#line 71
# 45 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Strobe.nc"
inline static   cc2420_status_t CC2420ReceiveP$SFLUSHRX$strobe(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = CC2420SpiImplP$Strobe$strobe(CC2420_SFLUSHRX);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 53 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$get(void){
#line 53
  unsigned long result;
#line 53

#line 53
  result = /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$get();
#line 53

#line 53
  return result;
#line 53
}
#line 53
# 75 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$getNow(void)
{
  return /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$get();
}

#line 146
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$start(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type dt)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$getNow(), dt);
}

# 55 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$BackoffTimer$size_type arg_0x7e9d48c8){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$start(arg_0x7e9d48c8);
#line 55
}
#line 55
# 72 "/opt/tinyos-2.x/tos/chips/cc2420/RadioBackoff.nc"
inline static   void CC2420TransmitP$RadioBackoff$requestInitialBackoff(message_t *arg_0x7e4420a8){
#line 72
  CC2420CsmaP$SubBackoff$requestInitialBackoff(arg_0x7e4420a8);
#line 72
}
#line 72
# 401 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$TXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, 
error_t error)
#line 402
{

  CC2420TransmitP$CSN$set();
  if (CC2420TransmitP$m_state == CC2420TransmitP$S_LOAD_CANCEL) {
      /* atomic removed: atomic calls only */
#line 406
      {
        CC2420TransmitP$CSN$clr();
        CC2420TransmitP$SFLUSHTX$strobe();
        CC2420TransmitP$CSN$set();
      }
      CC2420TransmitP$releaseSpiResource();
      if (CC2420TransmitP$signalSendDone) {
          CC2420TransmitP$signalDone(ECANCEL);
        }
      else 
#line 414
        {
          CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
        }
    }
  else {
#line 418
    if (!CC2420TransmitP$m_cca) {
        /* atomic removed: atomic calls only */
#line 419
        {
          if (CC2420TransmitP$m_state == CC2420TransmitP$S_LOAD_CANCEL) {
              CC2420TransmitP$m_state = CC2420TransmitP$S_TX_CANCEL;
            }
          else 
#line 422
            {
              CC2420TransmitP$m_state = CC2420TransmitP$S_BEGIN_TRANSMIT;
            }
        }
        CC2420TransmitP$attemptSend();
      }
    else {
        CC2420TransmitP$releaseSpiResource();
        /* atomic removed: atomic calls only */
#line 430
        {
          if (CC2420TransmitP$m_state == CC2420TransmitP$S_LOAD_CANCEL) {
              CC2420TransmitP$m_state = CC2420TransmitP$S_CCA_CANCEL;
            }
          else 
#line 433
            {
              CC2420TransmitP$m_state = CC2420TransmitP$S_SAMPLE_CCA;
            }
        }

        CC2420TransmitP$RadioBackoff$requestInitialBackoff(CC2420TransmitP$m_msg);
        CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myInitialBackoff);
      }
    }
}

# 281 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$RXFIFO$writeDone(uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 281
{
}

# 275 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static inline    void CC2420SpiImplP$Fifo$default$writeDone(uint8_t addr, uint8_t *tx_buf, uint8_t tx_len, error_t error)
#line 275
{
}

# 91 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Fifo.nc"
inline static   void CC2420SpiImplP$Fifo$writeDone(uint8_t arg_0x7e01e068, uint8_t *arg_0x7e0364c8, uint8_t arg_0x7e036650, error_t arg_0x7e0367d8){
#line 91
  switch (arg_0x7e01e068) {
#line 91
    case CC2420_TXFIFO:
#line 91
      CC2420TransmitP$TXFIFO$writeDone(arg_0x7e0364c8, arg_0x7e036650, arg_0x7e0367d8);
#line 91
      break;
#line 91
    case CC2420_RXFIFO:
#line 91
      CC2420ReceiveP$RXFIFO$writeDone(arg_0x7e0364c8, arg_0x7e036650, arg_0x7e0367d8);
#line 91
      break;
#line 91
    default:
#line 91
      CC2420SpiImplP$Fifo$default$writeDone(arg_0x7e01e068, arg_0x7e0364c8, arg_0x7e036650, arg_0x7e0367d8);
#line 91
      break;
#line 91
    }
#line 91
}
#line 91
# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void HplCC2420InterruptsP$CCATimer$stop(void){
#line 67
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$stop(1U);
#line 67
}
#line 67
# 123 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline void  HplCC2420InterruptsP$stopTask$runTask(void)
#line 123
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 124
    {
      if (HplCC2420InterruptsP$ccaTimerDisabled) {
          HplCC2420InterruptsP$CCATimer$stop();
        }
    }
#line 128
    __nesc_atomic_end(__nesc_atomic); }
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void HplCC2420InterruptsP$CCATimer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(1U, arg_0x7eb11338);
#line 62
}
#line 62
# 97 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline  void HplCC2420InterruptsP$CCATask$runTask(void)
#line 97
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 98
    {
      if (!HplCC2420InterruptsP$ccaTimerDisabled) {
        HplCC2420InterruptsP$CCATimer$startOneShot(500);
        }
    }
#line 102
    __nesc_atomic_end(__nesc_atomic); }
}

# 352 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   void CC2420ControlP$CC2420Config$default$syncDone(error_t error)
#line 352
{
}

# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Config.nc"
inline static  void CC2420ControlP$CC2420Config$syncDone(error_t arg_0x7e326b98){
#line 53
  CC2420ControlP$CC2420Config$default$syncDone(arg_0x7e326b98);
#line 53
}
#line 53
# 346 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline  void CC2420ControlP$syncDone_task$runTask(void)
#line 346
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 347
    CC2420ControlP$m_sync_busy = FALSE;
#line 347
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP$CC2420Config$syncDone(SUCCESS);
}

# 181 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$sendDone(am_id_t id, message_t *msg, error_t err)
#line 181
{





  if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current >= 4) {
      return;
    }
  if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current].msg == msg) {
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$sendDone(/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current, msg, err);
    }
  else {
      ;
    }
}

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void CC2420ActiveMessageP$AMSend$sendDone(am_id_t arg_0x7e437398, message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$sendDone(arg_0x7e437398, arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 98 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static inline  void CC2420ActiveMessageP$SubSend$sendDone(message_t *msg, error_t result)
#line 98
{
  CC2420ActiveMessageP$AMSend$sendDone(CC2420ActiveMessageP$AMPacket$type(msg), msg, result);
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void UniqueSendP$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  CC2420ActiveMessageP$SubSend$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
}
#line 89
# 104 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueSendP.nc"
static inline  void UniqueSendP$SubSend$sendDone(message_t *msg, error_t error)
#line 104
{
  UniqueSendP$State$toIdle();
  UniqueSendP$Send$sendDone(msg, error);
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void CC2420CsmaP$Send$sendDone(message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  UniqueSendP$SubSend$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
}
#line 89
# 242 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$sendDone_task$runTask(void)
#line 242
{
  error_t packetErr;

#line 244
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 244
    packetErr = CC2420CsmaP$sendErr;
#line 244
    __nesc_atomic_end(__nesc_atomic); }
  CC2420CsmaP$m_state = CC2420CsmaP$S_STARTED;
  CC2420CsmaP$Send$sendDone(CC2420CsmaP$m_msg, packetErr);
}

# 127 "OctopusC.nc"
static inline  void OctopusC$RadioControl$stopDone(error_t error)
#line 127
{
}

# 288 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$stopDone(error_t err)
#line 288
{
  if (err == SUCCESS) {
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$radioOn = FALSE;
    }
}

# 245 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$stopDone(error_t error)
#line 245
{
  /*CtpP.Router*/CtpRoutingEngineP$0$radioOn = FALSE;
  ;
}

# 117 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void CC2420CsmaP$SplitControl$stopDone(error_t arg_0x7ebf06e8){
#line 117
  /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$stopDone(arg_0x7ebf06e8);
#line 117
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$stopDone(arg_0x7ebf06e8);
#line 117
  OctopusC$RadioControl$stopDone(arg_0x7ebf06e8);
#line 117
}
#line 117
# 257 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$stopDone_task$runTask(void)
#line 257
{
  CC2420CsmaP$m_state = CC2420CsmaP$S_STOPPED;
  CC2420CsmaP$SplitControl$stopDone(SUCCESS);
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void OctopusC$Timer$startPeriodic(uint32_t arg_0x7eb13ce0){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(0U, arg_0x7eb13ce0);
#line 53
}
#line 53
# 81 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$set(uint16_t bitnum)
{
  /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getIndex(bitnum)] |= /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$getMask(bitnum);
}

# 52 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$set(uint16_t arg_0x7d8b7010){
#line 52
  /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$set(arg_0x7d8b7010);
#line 52
}
#line 52
# 92 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$start(uint8_t id)
#line 92
{
  if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time != 0) {
      return EBUSY;
    }
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time = 0;
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].remainder = 0;
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].count = 0;
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(id);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 100
    {
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$set(id);
    }
#line 102
    __nesc_atomic_end(__nesc_atomic); }
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer();
  ;
  return SUCCESS;
}

# 245 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   error_t DisseminationEngineImplP$TrickleTimer$default$start(uint16_t key)
#line 245
{
#line 245
  return FAIL;
}

# 60 "/opt/tinyos-2.x/tos/lib/net/TrickleTimer.nc"
inline static  error_t DisseminationEngineImplP$TrickleTimer$start(uint16_t arg_0x7d938688){
#line 60
  unsigned char result;
#line 60

#line 60
  switch (arg_0x7d938688) {
#line 60
    case 42:
#line 60
      result = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$start(/*OctopusAppC.DisseminatorC*/DisseminatorC$0$TIMER_ID);
#line 60
      break;
#line 60
    default:
#line 60
      result = DisseminationEngineImplP$TrickleTimer$default$start(arg_0x7d938688);
#line 60
      break;
#line 60
    }
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 91 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  error_t DisseminationEngineImplP$DisseminationCache$start(uint16_t key)
#line 91
{
  error_t result = DisseminationEngineImplP$TrickleTimer$start(key);

#line 93
  DisseminationEngineImplP$TrickleTimer$reset(key);
  return result;
}

# 45 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
inline static  error_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$start(void){
#line 45
  unsigned char result;
#line 45

#line 45
  result = DisseminationEngineImplP$DisseminationCache$start(42);
#line 45

#line 45
  return result;
#line 45
}
#line 45
# 62 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static inline  error_t /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$StdControl$start(void)
#line 62
{
  error_t result = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$start();

#line 64
  if (result == SUCCESS) {
#line 64
      /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$m_running = TRUE;
    }
#line 65
  return result;
}

# 253 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline   error_t DisseminationEngineImplP$DisseminatorControl$default$start(uint16_t id)
#line 253
{
#line 253
  return FAIL;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t DisseminationEngineImplP$DisseminatorControl$start(uint16_t arg_0x7d937030){
#line 74
  unsigned char result;
#line 74

#line 74
  switch (arg_0x7d937030) {
#line 74
    case /*OctopusAppC.DisseminatorC*/DisseminatorC$0$TIMER_ID:
#line 74
      result = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$StdControl$start();
#line 74
      break;
#line 74
    default:
#line 74
      result = DisseminationEngineImplP$DisseminatorControl$default$start(arg_0x7d937030);
#line 74
      break;
#line 74
    }
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 73 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  error_t DisseminationEngineImplP$StdControl$start(void)
#line 73
{
  uint8_t i;

#line 75
  for (i = 0; i < DisseminationEngineImplP$NUM_DISSEMINATORS; i++) {
      DisseminationEngineImplP$DisseminatorControl$start(i);
    }
  DisseminationEngineImplP$m_running = TRUE;
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t OctopusC$BroadcastControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = DisseminationEngineImplP$StdControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 607 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$setRoot(void)
#line 607
{
  bool route_found = FALSE;

#line 609
  route_found = /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == INVALID_ADDR;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 610
    {
      /*CtpP.Router*/CtpRoutingEngineP$0$state_is_root = 1;
      /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent = /*CtpP.Router*/CtpRoutingEngineP$0$my_ll_addr;
      /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx = 0;
    }
#line 614
    __nesc_atomic_end(__nesc_atomic); }
  if (route_found) {
    /*CtpP.Router*/CtpRoutingEngineP$0$Routing$routeFound();
    }
#line 617
  ;
  /*CtpP.Router*/CtpRoutingEngineP$0$CollectionDebug$logEventRoute(NET_C_TREE_NEW_PARENT, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent, 0, /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx);
  return SUCCESS;
}

# 41 "/opt/tinyos-2.x/tos/lib/net/RootControl.nc"
inline static  error_t OctopusC$RootControl$setRoot(void){
#line 41
  unsigned char result;
#line 41

#line 41
  result = /*CtpP.Router*/CtpRoutingEngineP$0$RootControl$setRoot();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 415 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  error_t LinkEstimatorP$StdControl$start(void)
#line 415
{
  ;
  return SUCCESS;
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$startPeriodic(uint32_t arg_0x7eb13ce0){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(4U, arg_0x7eb13ce0);
#line 53
}
#line 53
# 217 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$StdControl$start(void)
#line 217
{

  if (!/*CtpP.Router*/CtpRoutingEngineP$0$running) {
      /*CtpP.Router*/CtpRoutingEngineP$0$running = TRUE;
      /*CtpP.Router*/CtpRoutingEngineP$0$resetInterval();
      /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$startPeriodic(BEACON_INTERVAL);
      ;
    }
  return SUCCESS;
}

# 247 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$StdControl$start(void)
#line 247
{
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$running = TRUE;
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t OctopusC$CollectControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$StdControl$start();
#line 74
  result = ecombine(result, /*CtpP.Router*/CtpRoutingEngineP$0$StdControl$start());
#line 74
  result = ecombine(result, LinkEstimatorP$StdControl$start());
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 114 "OctopusC.nc"
static inline  void OctopusC$RadioControl$startDone(error_t error)
#line 114
{
  if (error == SUCCESS) {
      if (OctopusC$CollectControl$start() != SUCCESS) {
        OctopusC$fatalProblem();
        }
#line 118
      if (OctopusC$root) {
        OctopusC$RootControl$setRoot();
        }
#line 120
      if (OctopusC$BroadcastControl$start() != SUCCESS) {
        OctopusC$fatalProblem();
        }
#line 122
      OctopusC$setLocalDutyCycle();
      OctopusC$Timer$startPeriodic(OctopusC$samplingPeriod);
    }
  else {
#line 125
    OctopusC$fatalProblem();
    }
}

# 264 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$startDone(error_t err)
#line 264
{
  if (err == SUCCESS) {
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$radioOn = TRUE;
      if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$empty()) {
          /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
        }
    }
}

# 234 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$startDone(error_t error)
#line 234
{
  /*CtpP.Router*/CtpRoutingEngineP$0$radioOn = TRUE;
  ;
  if (/*CtpP.Router*/CtpRoutingEngineP$0$running) {
      uint16_t nextInt;

#line 239
      nextInt = /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand16() % BEACON_INTERVAL;
      nextInt += BEACON_INTERVAL >> 1;
      /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(nextInt);
    }
}

# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void CC2420CsmaP$SplitControl$startDone(error_t arg_0x7ebf1af0){
#line 92
  /*CtpP.Router*/CtpRoutingEngineP$0$RadioControl$startDone(arg_0x7ebf1af0);
#line 92
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$RadioControl$startDone(arg_0x7ebf1af0);
#line 92
  OctopusC$RadioControl$startDone(arg_0x7ebf1af0);
#line 92
}
#line 92
# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SpiResource$release(void){
#line 110
  unsigned char result;
#line 110

#line 110
  result = CC2420SpiImplP$Resource$release(/*CC2420ControlC.Spi*/CC2420SpiC$0$CLIENT_ID);
#line 110

#line 110
  return result;
#line 110
}
#line 110
# 127 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$Resource$release(void)
#line 127
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 128
    {
      CC2420ControlP$CSN$set();
      {
        unsigned char __nesc_temp = 
#line 130
        CC2420ControlP$SpiResource$release();

        {
#line 130
          __nesc_atomic_end(__nesc_atomic); 
#line 130
          return __nesc_temp;
        }
      }
    }
#line 133
    __nesc_atomic_end(__nesc_atomic); }
}

# 110 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
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
# 210 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$rxOn(void)
#line 210
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 211
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_XOSC_STARTED) {
          {
            unsigned char __nesc_temp = 
#line 213
            FAIL;

            {
#line 213
              __nesc_atomic_end(__nesc_atomic); 
#line 213
              return __nesc_temp;
            }
          }
        }
#line 215
      CC2420ControlP$SRXON$strobe();
    }
#line 216
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 90 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
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
# 42 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$enable(void)
#line 42
{
#line 42
  * (volatile uint8_t *)(0x39 + 0x20) |= 1 << 4;
}

# 35 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$enable(void){
#line 35
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$enable();
#line 35
}
#line 35
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$edge(bool low_to_high)
#line 47
{
  * (volatile uint8_t *)90U |= 1 << 1;

  if (low_to_high) {
    * (volatile uint8_t *)90U |= 1 << 0;
    }
  else {
#line 53
    * (volatile uint8_t *)90U &= ~(1 << 0);
    }
}

# 59 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$edge(bool arg_0x7e0f14c8){
#line 59
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$edge(arg_0x7e0f14c8);
#line 59
}
#line 59
# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$clear(void)
#line 41
{
#line 41
  * (volatile uint8_t *)(0x38 + 0x20) = 1 << 4;
}

# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$clear(void){
#line 45
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$clear();
#line 45
}
#line 45
# 43 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static __inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$disable(void)
#line 43
{
#line 43
  * (volatile uint8_t *)(0x39 + 0x20) &= ~(1 << 4);
}

# 40 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$disable(void){
#line 40
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$disable();
#line 40
}
#line 40
# 15 "/opt/tinyos-2.x/tos/chips/atm128/pins/Atm128GpioInterruptC.nc"
static inline error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$enable(bool rising)
#line 15
{
  /* atomic removed: atomic calls only */
#line 16
  {
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$disable();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$clear();
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$edge(rising);
    /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$enable();
  }
  return SUCCESS;
}





static inline   error_t /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$enableFallingEdge(void)
#line 29
{
  return /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$enable(FALSE);
}

# 43 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ReceiveP$InterruptFIFOP$enableFallingEdge(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$enableFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 110 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline  error_t CC2420ReceiveP$StdControl$start(void)
#line 110
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 111
    {
      CC2420ReceiveP$reset_state();
      CC2420ReceiveP$m_state = CC2420ReceiveP$S_STARTED;



      CC2420ReceiveP$InterruptFIFOP$enableFallingEdge();
    }
#line 118
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128GpioCaptureC.nc"
static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureRisingEdge(void)
#line 52
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$enableCapture(TRUE);
}

# 42 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   error_t CC2420TransmitP$CaptureSFD$captureRisingEdge(void){
#line 42
  unsigned char result;
#line 42

#line 42
  result = /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureRisingEdge();
#line 42

#line 42
  return result;
#line 42
}
#line 42
# 148 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline  error_t CC2420TransmitP$StdControl$start(void)
#line 148
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 149
    {
      CC2420TransmitP$CaptureSFD$captureRisingEdge();
      CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
      CC2420TransmitP$m_receiving = FALSE;
      CC2420TransmitP$m_tx_power = 0;
    }
#line 154
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
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
# 249 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  void CC2420CsmaP$startDone_task$runTask(void)
#line 249
{
  CC2420CsmaP$SubControl$start();
  CC2420CsmaP$CC2420Power$rxOn();
  CC2420CsmaP$Resource$release();
  CC2420CsmaP$m_state = CC2420CsmaP$S_STARTED;
  CC2420CsmaP$SplitControl$startDone(SUCCESS);
}

# 138 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Capture$stop(void)
#line 138
{
#line 138
  * (volatile uint8_t *)(0x37 + 0x20) &= ~(1 << 5);
}

# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$stop(void){
#line 61
  HplAtm128Timer1P$Capture$stop();
#line 61
}
#line 61
# 122 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Capture$setEdge(bool up)
#line 122
{
#line 122
  if (up) {
#line 122
    * (volatile uint8_t *)(0x2E + 0x20) |= 1 << 6;
    }
  else {
#line 122
    * (volatile uint8_t *)(0x2E + 0x20) &= ~(1 << 6);
    }
}

# 79 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$setEdge(bool arg_0x7e55b710){
#line 79
  HplAtm128Timer1P$Capture$setEdge(arg_0x7e55b710);
#line 79
}
#line 79
# 132 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Capture$start(void)
#line 132
{
#line 132
  * (volatile uint8_t *)(0x37 + 0x20) |= 1 << 5;
}

# 58 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$start(void){
#line 58
  HplAtm128Timer1P$Capture$start();
#line 58
}
#line 58
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)59U &= ~(1 << 2);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$clr();
#line 30
}
#line 30
# 63 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led0On(void)
#line 63
{
  LedsP$Led0$clr();
  ;
#line 65
  ;
}

# 45 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void OctopusC$Leds$led0On(void){
#line 45
  LedsP$Leds$led0On();
#line 45
}
#line 45
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)59U &= ~(1 << 1);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led1$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$clr();
#line 30
}
#line 30
# 78 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led1On(void)
#line 78
{
  LedsP$Led1$clr();
  ;
#line 80
  ;
}

# 61 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void OctopusC$Leds$led1On(void){
#line 61
  LedsP$Leds$led1On();
#line 61
}
#line 61
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)59U &= ~(1 << 0);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led2$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortA.Bit0*/HplAtm128GeneralIOPinP$0$IO$clr();
#line 30
}
#line 30
# 93 "/opt/tinyos-2.x/tos/system/LedsP.nc"
static inline   void LedsP$Leds$led2On(void)
#line 93
{
  LedsP$Led2$clr();
  ;
#line 95
  ;
}

# 78 "/opt/tinyos-2.x/tos/interfaces/Leds.nc"
inline static   void OctopusC$Leds$led2On(void){
#line 78
  LedsP$Leds$led2On();
#line 78
}
#line 78
# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  OctopusC$SerialSend$sendDone(arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 57 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(message_t *m, error_t err)
#line 57
{
  /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$sendDone(m, err);
}

# 207 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline   void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(uint8_t id, message_t *msg, error_t err)
#line 207
{
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(uint8_t arg_0x7e48a1e0, message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  switch (arg_0x7e48a1e0) {
#line 89
    case 0U:
#line 89
      /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$default$sendDone(arg_0x7e48a1e0, arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 118 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
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

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 110 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  uint8_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(message_t *msg)
#line 110
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(msg);

#line 112
  return __nesc_ntoh_uint8((unsigned char *)&header->length);
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
inline static  uint8_t /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Packet$payloadLength(message_t *arg_0x7e7c7ee0){
#line 67
  unsigned char result;
#line 67

#line 67
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(arg_0x7e7c7ee0);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 57 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
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

#line 166
static inline void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend(void)
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

# 99 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(am_id_t arg_0x7e7a9030, message_t *arg_0x7eb219b0, error_t arg_0x7eb21b38){
#line 99
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$sendDone(arg_0x7e7a9030, arg_0x7eb219b0, arg_0x7eb21b38);
#line 99
}
#line 99
# 81 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(message_t *msg, error_t result)
#line 81
{
  /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$sendDone(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, result);
}

# 367 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(uart_id_t idxxx, message_t *msg, error_t error)
#line 367
{
  return;
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(uart_id_t arg_0x7e6923e0, message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  switch (arg_0x7e6923e0) {
#line 89
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 89
      /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubSend$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    default:
#line 89
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$default$sendDone(arg_0x7e6923e0, arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 152 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$runTask(void)
#line 152
{
  error_t error;

  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendState = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SEND_STATE_IDLE;
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 156
    error = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError;
#line 156
    __nesc_atomic_end(__nesc_atomic); }

  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendCancelled) {
#line 158
    error = ECANCEL;
    }
#line 159
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Send$sendDone(/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendId, (message_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendBuffer, error);
}

#line 206
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(uint8_t which)
#line 206
{
  if (which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 0;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 0;
    }
}

# 102 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static inline  void DisseminationEngineImplP$DisseminationCache$newData(uint16_t key)
#line 102
{

  if (!DisseminationEngineImplP$m_running || DisseminationEngineImplP$m_bufBusy) {
#line 104
      return;
    }
  DisseminationEngineImplP$sendObject(key);
  DisseminationEngineImplP$TrickleTimer$reset(key);
}

# 50 "/opt/tinyos-2.x/tos/lib/net/DisseminationCache.nc"
inline static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$newData(void){
#line 50
  DisseminationEngineImplP$DisseminationCache$newData(42);
#line 50
}
#line 50
# 82 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static inline  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$change(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t *newVal)
#line 82
{
  if (!/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$m_running) {
#line 83
      return;
    }
#line 84
  memcpy(&/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$valueCache, newVal, sizeof(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t ));

  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno >> 16;
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno++;
  if (/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno == DISSEMINATION_SEQNO_UNKNOWN) {
#line 88
      /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno++;
    }
#line 89
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno = /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno << 16;
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno += TOS_NODE_ID;
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$newData();
}

# 52 "/opt/tinyos-2.x/tos/lib/net/DisseminationUpdate.nc"
inline static  void OctopusC$RequestUpdate$change(OctopusC$RequestUpdate$t *arg_0x7eb71010){
#line 52
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationUpdate$change(arg_0x7eb71010);
#line 52
}
#line 52
# 236 "OctopusC.nc"
static inline  message_t *OctopusC$SerialReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 236
{
  octopus_sent_msg_t *newRequest = payload;

#line 238
  if (len == sizeof(octopus_sent_msg_t )) {

      OctopusC$RequestUpdate$change(newRequest);



      OctopusC$processRequest(newRequest);
    }
  return msg;
}

# 89 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline   message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(uint8_t id, message_t *msg, void *payload, uint8_t len)
#line 89
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(am_id_t arg_0x7e7a9960, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7e7a9960) {
#line 67
    case 101:
#line 67
      result = OctopusC$SerialReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$default$receive(arg_0x7e7a9960, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 102 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  message_t */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 102
{
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Receive$receive(/*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(msg), msg, msg->data, len);
}

# 362 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(uart_id_t idxxx, message_t *msg, 
void *payload, 
uint8_t len)
#line 364
{
  return msg;
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Receive.nc"
inline static  message_t */*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(uart_id_t arg_0x7e693b98, message_t *arg_0x7eb51e50, void *arg_0x7eb45010, uint8_t arg_0x7eb45198){
#line 67
  nx_struct message_t *result;
#line 67

#line 67
  switch (arg_0x7e693b98) {
#line 67
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 67
      result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$SubReceive$receive(arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
#line 67
      break;
#line 67
    default:
#line 67
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$default$receive(arg_0x7e693b98, arg_0x7eb51e50, arg_0x7eb45010, arg_0x7eb45198);
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
# 46 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfoActiveMessageP.nc"
static inline   uint8_t SerialPacketInfoActiveMessageP$Info$upperLength(message_t *msg, uint8_t dataLinkLen)
#line 46
{
  return dataLinkLen - sizeof(serial_header_t );
}

# 356 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline    uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(uart_id_t id, message_t *msg, 
uint8_t dataLinkLen)
#line 357
{
  return 0;
}

# 31 "/opt/tinyos-2.x/tos/lib/serial/SerialPacketInfo.nc"
inline static   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(uart_id_t arg_0x7e692d98, message_t *arg_0x7e755808, uint8_t arg_0x7e755998){
#line 31
  unsigned char result;
#line 31

#line 31
  switch (arg_0x7e692d98) {
#line 31
    case TOS_SERIAL_ACTIVE_MESSAGE_ID:
#line 31
      result = SerialPacketInfoActiveMessageP$Info$upperLength(arg_0x7e755808, arg_0x7e755998);
#line 31
      break;
#line 31
    default:
#line 31
      result = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$default$upperLength(arg_0x7e692d98, arg_0x7e755808, arg_0x7e755998);
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
# 269 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline  void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTask$runTask(void)
#line 269
{
  uart_id_t myType;
  message_t *myBuf;
  uint8_t mySize;
  uint8_t myWhich;

#line 274
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 274
    {
      myType = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskType;
      myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskBuf;
      mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskSize;
      myWhich = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskWhich;
    }
#line 279
    __nesc_atomic_end(__nesc_atomic); }
  mySize -= /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$offset(myType);
  mySize = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$PacketInfo$upperLength(myType, myBuf, mySize);
  myBuf = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$Receive$receive(myType, myBuf, myBuf, mySize);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 283
    {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[myWhich] = myBuf;
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$unlockBuffer(myWhich);
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveTaskPending = FALSE;
    }
#line 287
    __nesc_atomic_end(__nesc_atomic); }
}

# 132 "OctopusC.nc"
static inline  void OctopusC$SerialControl$stopDone(error_t error)
#line 132
{
}

# 117 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$stopDone(error_t arg_0x7ebf06e8){
#line 117
  OctopusC$SerialControl$stopDone(arg_0x7ebf06e8);
#line 117
}
#line 117
# 44 "/opt/tinyos-2.x/tos/interfaces/McuPowerState.nc"
inline static   void HplAtm128UartP$McuPowerState$update(void){
#line 44
  McuSleepC$McuPowerState$update();
#line 44
}
#line 44
# 128 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart0RxControl$stop(void)
#line 128
{
  * (volatile uint8_t *)(0x0A + 0x20) &= ~(1 << 7);
  * (volatile uint8_t *)(0x0A + 0x20) &= ~(1 << 4);
  HplAtm128UartP$McuPowerState$update();
  return SUCCESS;
}

# 84 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = HplAtm128UartP$Uart0RxControl$stop();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 114 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart0TxControl$stop(void)
#line 114
{
  * (volatile uint8_t *)(0x0A + 0x20) &= ~(1 << 6);
  * (volatile uint8_t *)(0x0A + 0x20) &= ~(1 << 3);
  HplAtm128UartP$McuPowerState$update();
  return SUCCESS;
}

# 84 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = HplAtm128UartP$Uart0TxControl$stop();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 75 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$stop(void)
#line 75
{
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$stop();
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$stop();
  return SUCCESS;
}

# 84 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$stop(void){
#line 84
  unsigned char result;
#line 84

#line 84
  result = /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$stop();
#line 84

#line 84
  return result;
#line 84
}
#line 84
# 330 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 338 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFlush$default$flush(void)
#line 338
{
  SerialP$defaultSerialFlushTask$postTask();
}

# 38 "/opt/tinyos-2.x/tos/lib/serial/SerialFlush.nc"
inline static  void SerialP$SerialFlush$flush(void){
#line 38
  SerialP$SerialFlush$default$flush();
#line 38
}
#line 38
# 326 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  void SerialP$stopDoneTask$runTask(void)
#line 326
{
  SerialP$SerialFlush$flush();
}

# 128 "OctopusC.nc"
static inline  void OctopusC$SerialControl$startDone(error_t error)
#line 128
{
  if (error != SUCCESS) {
    OctopusC$fatalProblem();
    }
}

# 92 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  void SerialP$SplitControl$startDone(error_t arg_0x7ebf1af0){
#line 92
  OctopusC$SerialControl$startDone(arg_0x7ebf1af0);
#line 92
}
#line 92
# 121 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart0RxControl$start(void)
#line 121
{
  * (volatile uint8_t *)(0x0A + 0x20) |= 1 << 7;
  * (volatile uint8_t *)(0x0A + 0x20) |= 1 << 4;
  HplAtm128UartP$McuPowerState$update();
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = HplAtm128UartP$Uart0RxControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 107 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart0TxControl$start(void)
#line 107
{
  * (volatile uint8_t *)(0x0A + 0x20) |= 1 << 6;
  * (volatile uint8_t *)(0x0A + 0x20) |= 1 << 3;
  HplAtm128UartP$McuPowerState$update();
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = HplAtm128UartP$Uart0TxControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 69 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$start(void)
#line 69
{
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartTxControl$start();
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUartRxControl$start();
  return SUCCESS;
}

# 74 "/opt/tinyos-2.x/tos/interfaces/StdControl.nc"
inline static  error_t SerialP$SerialControl$start(void){
#line 74
  unsigned char result;
#line 74

#line 74
  result = /*Atm128Uart0C.UartP*/Atm128UartP$0$StdControl$start();
#line 74

#line 74
  return result;
#line 74
}
#line 74
# 320 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  void SerialP$startDoneTask$runTask(void)
#line 320
{
  SerialP$SerialControl$start();
  SerialP$SplitControl$startDone(SUCCESS);
}

# 45 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
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
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 188 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(error_t error)
#line 188
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 189
    /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$sendError = error;
#line 189
    __nesc_atomic_end(__nesc_atomic); }
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$signalSendDone$postTask();
}

# 80 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
inline static   void SerialP$SendBytePacket$sendCompleted(error_t arg_0x7e728818){
#line 80
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$sendCompleted(arg_0x7e728818);
#line 80
}
#line 80
# 242 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
inline static   error_t OctopusC$serialSendTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(OctopusC$serialSendTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
inline static   error_t OctopusC$collectSendTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(OctopusC$collectSendTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 333 "OctopusC.nc"
static inline  void OctopusC$Read$readDone(error_t ok, uint16_t val)
#line 333
{
  unsigned int __nesc_temp45;
  unsigned char *__nesc_temp44;

#line 334
  if (ok == SUCCESS) {
      (__nesc_temp44 = (unsigned char *)&OctopusC$localCollectedMsg.count, __nesc_hton_uint16(__nesc_temp44, (__nesc_temp45 = __nesc_ntoh_uint16(__nesc_temp44)) + 1), __nesc_temp45);
      OctopusC$fillPacket();
      if (!OctopusC$modeAuto) {
          __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, val);
          if (!OctopusC$root) {
            OctopusC$collectSendTask$postTask();
            }
          else {
#line 342
            OctopusC$serialSendTask$postTask();
            }
        }
      else {
#line 343
        if (val > OctopusC$oldSensorValue && !(0xFFFF - OctopusC$oldSensorValue < OctopusC$threshold)) {
            if (OctopusC$oldSensorValue + OctopusC$threshold < val) {
                __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, val);
                if (!OctopusC$root) {
                  OctopusC$collectSendTask$postTask();
                  }
                else {
#line 349
                  OctopusC$serialSendTask$postTask();
                  }
              }
          }
        else {
#line 351
          if (val < OctopusC$oldSensorValue && !(OctopusC$oldSensorValue < OctopusC$threshold)) {
              if (OctopusC$oldSensorValue - OctopusC$threshold > val) {
                  __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, val);
                  if (!OctopusC$root) {
                    OctopusC$collectSendTask$postTask();
                    }
                  else {
#line 357
                    OctopusC$serialSendTask$postTask();
                    }
                }
            }
          }
        }
    }
}

# 63 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
inline static  void /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$readDone(error_t arg_0x7eaf5668, /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$val_t arg_0x7eaf57f0){
#line 63
  OctopusC$Read$readDone(arg_0x7eaf5668, arg_0x7eaf57f0);
#line 63
}
#line 63
# 33 "/opt/tinyos-2.x/tos/system/SineSensorC.nc"
static inline  void /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$runTask(void)
#line 33
{
  float val = (float )/*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$counter;

#line 35
  val = val / 20.0;
  val = sin(val) * 32768.0;
  val += 32768.0;
  /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$counter++;
  /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$readDone(SUCCESS, (uint16_t )val);
}

# 92 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$startAt(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x7e9d39e0, /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type arg_0x7e9d3b70){
#line 92
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$startAt(arg_0x7e9d39e0, arg_0x7e9d3b70);
#line 92
}
#line 92
# 47 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
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

# 118 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(uint32_t arg_0x7eb05010, uint32_t arg_0x7eb051a0){
#line 118
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$startOneShotAt(arg_0x7eb05010, arg_0x7eb051a0);
#line 118
}
#line 118
# 194 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$stop(void)
#line 194
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 195
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$set = FALSE;
#line 195
    __nesc_atomic_end(__nesc_atomic); }
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop(void){
#line 62
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$stop();
#line 62
}
#line 62
# 60 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop(void)
{
#line 61
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$stop();
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$stop(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$stop();
#line 67
}
#line 67
# 88 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
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
#line 123
        /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$startOneShotAt(now, min_remaining);
        }
    }
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 41 "/opt/tinyos-2.x/tos/system/SineSensorC.nc"
static inline  error_t /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$read(void)
#line 41
{
  /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$postTask();
  return SUCCESS;
}

# 55 "/opt/tinyos-2.x/tos/interfaces/Read.nc"
inline static  error_t OctopusC$Read$read(void){
#line 55
  unsigned char result;
#line 55

#line 55
  result = /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$Read$read();
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 323 "OctopusC.nc"
static inline  void OctopusC$Timer$fired(void)
#line 323
{
  if (!OctopusC$sleeping && OctopusC$modeAuto) {
    OctopusC$Read$read();
    }
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 208 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Power$startOscillatorDone(void)
#line 208
{
  CC2420CsmaP$startDone_task$postTask();
}

# 76 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
inline static   void CC2420ControlP$CC2420Power$startOscillatorDone(void){
#line 76
  CC2420CsmaP$CC2420Power$startOscillatorDone();
#line 76
}
#line 76
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t HplCC2420InterruptsP$stopTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(HplCC2420InterruptsP$stopTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 130 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline   error_t HplCC2420InterruptsP$CCA$disable(void)
#line 130
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 131
    HplCC2420InterruptsP$ccaTimerDisabled = TRUE;
#line 131
    __nesc_atomic_end(__nesc_atomic); }
  HplCC2420InterruptsP$stopTask$postTask();
  return SUCCESS;
}

# 50 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   error_t CC2420ControlP$InterruptCCA$disable(void){
#line 50
  unsigned char result;
#line 50

#line 50
  result = HplCC2420InterruptsP$CCA$disable();
#line 50

#line 50
  return result;
#line 50
}
#line 50
# 332 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   void CC2420ControlP$InterruptCCA$fired(void)
#line 332
{
  nxle_uint16_t id[2];

#line 334
  CC2420ControlP$m_state = CC2420ControlP$S_XOSC_STARTED;
  __nesc_hton_leuint16((unsigned char *)&id[0], CC2420ControlP$m_pan);
  __nesc_hton_leuint16((unsigned char *)&id[1], CC2420ControlP$m_short_addr);
  CC2420ControlP$InterruptCCA$disable();
  CC2420ControlP$IOCFG1$write(0);
  CC2420ControlP$PANID$write(0, (uint8_t *)&id, 4);
  CC2420ControlP$CSN$set();
  CC2420ControlP$CSN$clr();
  CC2420ControlP$CC2420Power$startOscillatorDone();
}

# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void HplCC2420InterruptsP$CCA$fired(void){
#line 57
  CC2420ControlP$InterruptCCA$fired();
#line 57
}
#line 57
# 139 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline  void HplCC2420InterruptsP$CCATimer$fired(void)
#line 139
{

  uint8_t CCAState;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 143
    {
      if (HplCC2420InterruptsP$ccaTimerDisabled) {
          {
#line 145
            __nesc_atomic_end(__nesc_atomic); 
#line 145
            return;
          }
        }
    }
#line 148
    __nesc_atomic_end(__nesc_atomic); }
  CCAState = HplCC2420InterruptsP$CC_CCA$get();

  if (HplCC2420InterruptsP$ccaLastState != HplCC2420InterruptsP$ccaWaitForState && CCAState == HplCC2420InterruptsP$ccaWaitForState) {
      HplCC2420InterruptsP$CCA$fired();
    }

  HplCC2420InterruptsP$ccaLastState = CCAState;
  HplCC2420InterruptsP$CCATask$postTask();

  return;
}

# 55 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Register.nc"
inline static   cc2420_status_t CC2420TransmitP$MDMCTRL1$write(uint16_t arg_0x7e30ca10){
#line 55
  unsigned char result;
#line 55

#line 55
  result = CC2420SpiImplP$Reg$write(CC2420_MDMCTRL1, arg_0x7e30ca10);
#line 55

#line 55
  return result;
#line 55
}
#line 55
# 502 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline  void CC2420TransmitP$LplDisableTimer$fired(void)
#line 502
{
  CC2420TransmitP$MDMCTRL1$write(0 << CC2420_MDMCTRL1_TX_MODE);
  CC2420TransmitP$signalDone(SUCCESS);
}

# 182 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline void /*CtpP.Router*/CtpRoutingEngineP$0$decayInterval(void)
#line 182
{
  if (!/*CtpP.Router*/CtpRoutingEngineP$0$state_is_root) {
      /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval *= 2;
      if (/*CtpP.Router*/CtpRoutingEngineP$0$currentInterval > 1024) {
          /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval = 1024;
        }
    }
  /*CtpP.Router*/CtpRoutingEngineP$0$chooseAdvertiseTime();
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startPeriodic(uint32_t arg_0x7eb13ce0){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(3U, arg_0x7eb13ce0);
#line 53
}
#line 53
# 192 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline void /*CtpP.Router*/CtpRoutingEngineP$0$remainingInterval(void)
#line 192
{
  uint32_t remaining = /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval;

#line 194
  remaining *= 1024;
  remaining -= /*CtpP.Router*/CtpRoutingEngineP$0$t;
  /*CtpP.Router*/CtpRoutingEngineP$0$tHasPassed = TRUE;
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startPeriodic(/*CtpP.Router*/CtpRoutingEngineP$0$t);
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
inline static   error_t /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$postTask(void){
#line 56
  unsigned char result;
#line 56

#line 56
  result = SchedulerBasicP$TaskBasic$postTask(/*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask);
#line 56

#line 56
  return result;
#line 56
}
#line 56
# 441 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$fired(void)
#line 441
{
  if (/*CtpP.Router*/CtpRoutingEngineP$0$radioOn && /*CtpP.Router*/CtpRoutingEngineP$0$running) {
      if (!/*CtpP.Router*/CtpRoutingEngineP$0$tHasPassed) {
          /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
          /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$postTask();
          ;
          /*CtpP.Router*/CtpRoutingEngineP$0$remainingInterval();
        }
      else {
          /*CtpP.Router*/CtpRoutingEngineP$0$decayInterval();
        }
    }
}

#line 435
static inline  void /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$fired(void)
#line 435
{
  if (/*CtpP.Router*/CtpRoutingEngineP$0$radioOn && /*CtpP.Router*/CtpRoutingEngineP$0$running) {
      /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
    }
}

# 827 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$fired(void)
#line 827
{
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = FALSE;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
}

static inline  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$fired(void)
#line 832
{


  /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
}

# 81 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$set(uint16_t bitnum)
{
  /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits[/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getIndex(bitnum)] |= /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$getMask(bitnum);
}

# 52 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$set(uint16_t arg_0x7d8b7010){
#line 52
  /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$set(arg_0x7d8b7010);
#line 52
}
#line 52
# 140 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  uint32_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getdt(void){
#line 140
  unsigned long result;
#line 140

#line 140
  result = /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$getdt(7U);
#line 140

#line 140
  return result;
#line 140
}
#line 140
# 168 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$fired(void)
#line 168
{
  uint8_t i;
  uint32_t dt = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getdt();

  for (i = 0; i < 1U; i++) {
      uint32_t remaining = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].time;

#line 174
      if (remaining != 0) {
          remaining -= dt;
          if (remaining == 0) {
              if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].count < 1) {
                  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 178
                    {
                      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$set(i);
                    }
#line 180
                    __nesc_atomic_end(__nesc_atomic); }
                  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$postTask();
                }

              /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(i);







              /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].count = 0;
            }
          else {
              /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].time = remaining;
            }
        }
    }
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer();
}

# 192 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline   void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(uint8_t num)
{
}

# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$fired(uint8_t arg_0x7e871cd8){
#line 72
  switch (arg_0x7e871cd8) {
#line 72
    case 0U:
#line 72
      OctopusC$Timer$fired();
#line 72
      break;
#line 72
    case 1U:
#line 72
      HplCC2420InterruptsP$CCATimer$fired();
#line 72
      break;
#line 72
    case 2U:
#line 72
      CC2420TransmitP$LplDisableTimer$fired();
#line 72
      break;
#line 72
    case 3U:
#line 72
      /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$fired();
#line 72
      break;
#line 72
    case 4U:
#line 72
      /*CtpP.Router*/CtpRoutingEngineP$0$RouteTimer$fired();
#line 72
      break;
#line 72
    case 5U:
#line 72
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$fired();
#line 72
      break;
#line 72
    case 6U:
#line 72
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CongestionTimer$fired();
#line 72
      break;
#line 72
    case 7U:
#line 72
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$fired();
#line 72
      break;
#line 72
    default:
#line 72
      /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$default$fired(arg_0x7e871cd8);
#line 72
      break;
#line 72
    }
#line 72
}
#line 72
# 135 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   void HplAtm128Timer0AsyncP$Compare$set(uint8_t t)
#line 135
{
  * (volatile uint8_t *)(0x31 + 0x20) = t;
}

# 45 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$set(/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$size_type arg_0x7e981c38){
#line 45
  HplAtm128Timer0AsyncP$Compare$set(arg_0x7e981c38);
#line 45
}
#line 45
# 50 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   uint8_t HplAtm128Timer0AsyncP$Timer$get(void)
#line 50
{
#line 50
  return * (volatile uint8_t *)(0x32 + 0x20);
}

# 52 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$timer_size /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get(void){
#line 52
  unsigned char result;
#line 52

#line 52
  result = HplAtm128Timer0AsyncP$Timer$get();
#line 52

#line 52
  return result;
#line 52
}
#line 52
# 206 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   int HplAtm128Timer0AsyncP$TimerAsync$compareBusy(void)
#line 206
{
  return (* (volatile uint8_t *)(0x30 + 0x20) & (1 << 1)) != 0;
}

# 44 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerAsync.nc"
inline static   int /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$compareBusy(void){
#line 44
  int result;
#line 44

#line 44
  result = HplAtm128Timer0AsyncP$TimerAsync$compareBusy();
#line 44

#line 44
  return result;
#line 44
}
#line 44
# 74 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setOcr0(uint8_t n)
#line 74
{
  while (/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$compareBusy()) 
    ;
  if (n == /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get()) {
    n++;
    }


  if (/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base + n + 1 < /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base) {
    n = -/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base - 1;
    }
#line 84
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$set(n);
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 70 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline   void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired(void)
{
#line 71
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$postTask();
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$fired(void){
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$fired();
#line 67
}
#line 67
# 127 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static inline  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired(void)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$fireTimers(/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow());
}

# 72 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired(void){
#line 72
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$fired();
#line 72
}
#line 72
# 216 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getAlarm(void)
#line 216
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 217
    {
      unsigned long __nesc_temp = 
#line 217
      /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$t0 + /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$dt;

      {
#line 217
        __nesc_atomic_end(__nesc_atomic); 
#line 217
        return __nesc_temp;
      }
    }
#line 219
    __nesc_atomic_end(__nesc_atomic); }
}

# 105 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$size_type /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(void){
#line 105
  unsigned long result;
#line 105

#line 105
  result = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$getAlarm();
#line 105

#line 105
  return result;
#line 105
}
#line 105
# 63 "/opt/tinyos-2.x/tos/lib/timer/AlarmToTimerC.nc"
static inline  void /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$fired$runTask(void)
{
  if (/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_oneshot == FALSE) {
    /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$start(/*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Alarm$getAlarm(), /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$m_dt, FALSE);
    }
#line 67
  /*HilTimerMilliC.AlarmToTimerC*/AlarmToTimerC$0$Timer$fired();
}

# 31 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void LedsP$Led0$toggle(void){
#line 31
  /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$toggle();
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
inline static   void OctopusC$Leds$led0Toggle(void){
#line 56
  LedsP$Leds$led0Toggle();
#line 56
}
#line 56
# 82 "OctopusC.nc"
inline static void OctopusC$reportProblem(void)
#line 82
{
#line 82
  OctopusC$Leds$led0Toggle();
}

# 69 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  error_t OctopusC$SerialSend$send(am_addr_t arg_0x7eb22678, message_t *arg_0x7eb22828, uint8_t arg_0x7eb229b0){
#line 69
  unsigned char result;
#line 69

#line 69
  result = /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(arg_0x7eb22678, arg_0x7eb22828, arg_0x7eb229b0);
#line 69

#line 69
  return result;
#line 69
}
#line 69
# 77 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static inline  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(am_id_t id, message_t *m)
#line 77
{
  return /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(m, (void *)0);
}

# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(am_id_t arg_0x7e48ab40, message_t *arg_0x7eb20600){
#line 125
  void *result;
#line 125

#line 125
  result = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMSend$getPayload(arg_0x7e48ab40, arg_0x7eb20600);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 203 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static inline  void */*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(uint8_t id, message_t *m)
#line 203
{
  return /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$AMSend$getPayload(0, m);
}

# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void */*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(message_t *arg_0x7eb54c58){
#line 114
  void *result;
#line 114

#line 114
  result = /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$getPayload(0U, arg_0x7eb54c58);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 65 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static inline  void */*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(message_t *m)
#line 65
{
  return /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$getPayload(m);
}

# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void *OctopusC$SerialSend$getPayload(message_t *arg_0x7eb20600){
#line 125
  void *result;
#line 125

#line 125
  result = /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$getPayload(arg_0x7eb20600);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 260 "OctopusC.nc"
static inline  void OctopusC$serialSendTask$runTask(void)
#line 260
{
  if (!OctopusC$uartBusy && OctopusC$root) {
      octopus_collected_msg_t *o = (octopus_collected_msg_t *)OctopusC$SerialSend$getPayload(&OctopusC$sndMsg);

#line 263
      memcpy(o, &OctopusC$localCollectedMsg, sizeof(octopus_collected_msg_t ));
      if (OctopusC$SerialSend$send(0xffff, &OctopusC$sndMsg, sizeof(octopus_collected_msg_t )) == SUCCESS) {
        OctopusC$uartBusy = TRUE;
        }
      else {
#line 267
        OctopusC$reportProblem();
        }
    }
}

# 50 "/opt/tinyos-2.x/tos/lib/net/CollectionIdP.nc"
static inline  collection_id_t /*OctopusAppC.CollectionSenderC.CollectionSenderP.CollectionIdP*/CollectionIdP$0$CollectionId$fetch(void)
#line 50
{
  return 147;
}

# 954 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline   collection_id_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$default$fetch(uint8_t client)
#line 954
{
  return 0;
}

# 46 "/opt/tinyos-2.x/tos/lib/net/CollectionId.nc"
inline static  collection_id_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$fetch(uint8_t arg_0x7dc157e8){
#line 46
  unsigned char result;
#line 46

#line 46
  switch (arg_0x7dc157e8) {
#line 46
    case 0U:
#line 46
      result = /*OctopusAppC.CollectionSenderC.CollectionSenderP.CollectionIdP*/CollectionIdP$0$CollectionId$fetch();
#line 46
      break;
#line 46
    default:
#line 46
      result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$default$fetch(arg_0x7dc157e8);
#line 46
      break;
#line 46
    }
#line 46

#line 46
  return result;
#line 46
}
#line 46
# 357 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$maxPayloadLength(uint8_t client)
#line 357
{
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$maxPayloadLength();
}

#line 307
static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$send(uint8_t client, message_t *msg, uint8_t len)
#line 307
{
  ctp_data_header_t *hdr;
  fe_queue_entry_t *qe;

#line 310
  ;
  if (!/*CtpP.Forwarder*/CtpForwardingEngineP$0$running) {
#line 311
      return EOFF;
    }
#line 312
  if (len > /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$maxPayloadLength(client)) {
#line 312
      return ESIZE;
    }
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$setPayloadLength(msg, len);
  hdr = /*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg);
  __nesc_hton_uint16((unsigned char *)&hdr->origin, TOS_NODE_ID);
  __nesc_hton_uint8((unsigned char *)&hdr->originSeqNo, /*CtpP.Forwarder*/CtpForwardingEngineP$0$seqno++);
  __nesc_hton_uint8((unsigned char *)&hdr->type, /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionId$fetch(client));
  __nesc_hton_uint8((unsigned char *)&hdr->thl, 0);

  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[client] == (void *)0) {
      ;
      return EBUSY;
    }

  qe = /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[client];
  qe->msg = msg;
  qe->client = client;
  qe->retries = MAX_RETRIES;
  ;
  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$enqueue(qe) == SUCCESS) {
      if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$radioOn && !/*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$isRunning()) {
          /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$postTask();
        }
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[client] = (void *)0;
      return SUCCESS;
    }
  else {
      ;




      /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_SEND_QUEUE_FULL);


      return FAIL;
    }
}

# 64 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  error_t OctopusC$CollectSend$send(message_t *arg_0x7eb60dd8, uint8_t arg_0x7eb55010){
#line 64
  unsigned char result;
#line 64

#line 64
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$send(0U, arg_0x7eb60dd8, arg_0x7eb55010);
#line 64

#line 64
  return result;
#line 64
}
#line 64
# 361 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$getPayload(uint8_t client, message_t *msg)
#line 361
{
  return /*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(msg, (void *)0);
}

# 114 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
inline static  void *OctopusC$CollectSend$getPayload(message_t *arg_0x7eb54c58){
#line 114
  void *result;
#line 114

#line 114
  result = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$getPayload(0U, arg_0x7eb54c58);
#line 114

#line 114
  return result;
#line 114
}
#line 114
# 249 "OctopusC.nc"
static inline  void OctopusC$collectSendTask$runTask(void)
#line 249
{
  if (!OctopusC$sendBusy && !OctopusC$root) {
      octopus_collected_msg_t *o = (octopus_collected_msg_t *)OctopusC$CollectSend$getPayload(&OctopusC$sndMsg);

#line 252
      memcpy(o, &OctopusC$localCollectedMsg, sizeof(octopus_collected_msg_t ));
      if (OctopusC$CollectSend$send(&OctopusC$sndMsg, sizeof(octopus_collected_msg_t )) == SUCCESS) {
        OctopusC$sendBusy = TRUE;
        }
      else {
#line 256
        OctopusC$reportProblem();
        }
    }
}

# 122 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   void HplAtm128Timer0AsyncP$Compare$start(void)
#line 122
{
#line 122
  * (volatile uint8_t *)(0x37 + 0x20) |= 1 << 1;
}

# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$start(void){
#line 56
  HplAtm128Timer0AsyncP$Compare$start();
#line 56
}
#line 56
# 76 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   void HplAtm128Timer0AsyncP$TimerCtrl$setControl(Atm128TimerControl_t x)
#line 76
{
  * (volatile uint8_t *)(0x33 + 0x20) = x.flat;
}

# 37 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerCtrl8.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$setControl(Atm128TimerControl_t arg_0x7e986ce8){
#line 37
  HplAtm128Timer0AsyncP$TimerCtrl$setControl(arg_0x7e986ce8);
#line 37
}
#line 37
# 198 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   void HplAtm128Timer0AsyncP$TimerAsync$setTimer0Asynchronous(void)
#line 198
{
  * (volatile uint8_t *)(0x30 + 0x20) |= 1 << 3;
}

# 32 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128TimerAsync.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$setTimer0Asynchronous(void){
#line 32
  HplAtm128Timer0AsyncP$TimerAsync$setTimer0Asynchronous();
#line 32
}
#line 32
# 54 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline  error_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Init$init(void)
#line 54
{
  /* atomic removed: atomic calls only */
  {
    Atm128TimerControl_t x;

    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerAsync$setTimer0Asynchronous();
    x.flat = 0;
    x.bits.cs = 3;
    x.bits.wgm1 = 1;
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$setControl(x);
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$set(/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MAXT);
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$start();
  }
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt();
  return SUCCESS;
}

# 44 "/opt/tinyos-2.x/tos/system/RandomMlcgP.nc"
static inline  error_t RandomMlcgP$Init$init(void)
#line 44
{
  /* atomic removed: atomic calls only */
#line 45
  RandomMlcgP$seed = (uint32_t )(TOS_NODE_ID + 1);

  return SUCCESS;
}

# 214 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 61 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline  error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$Init$init(void)
#line 61
{
  if (PLATFORM_BAUDRATE == 19200UL) {
    /*Atm128Uart0C.UartP*/Atm128UartP$0$m_byte_time = 200;
    }
  else {
#line 64
    if (PLATFORM_BAUDRATE == 57600UL) {
      /*Atm128Uart0C.UartP*/Atm128UartP$0$m_byte_time = 68;
      }
    }
#line 66
  return SUCCESS;
}

# 120 "/opt/tinyos-2.x/tos/platforms/aquisgrain/MeasureClockC.nc"
static inline   uint16_t MeasureClockC$Atm128Calibrate$baudrateRegister(uint32_t baudrate)
#line 120
{

  return ((uint32_t )MeasureClockC$cycles << 12) / baudrate - 1;
}

# 60 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128Calibrate.nc"
inline static   uint16_t HplAtm128UartP$Atm128Calibrate$baudrateRegister(uint32_t arg_0x7ef53898){
#line 60
  unsigned int result;
#line 60

#line 60
  result = MeasureClockC$Atm128Calibrate$baudrateRegister(arg_0x7ef53898);
#line 60

#line 60
  return result;
#line 60
}
#line 60
# 184 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline  error_t HplAtm128UartP$Uart1Init$init(void)
#line 184
{
  Atm128UartMode_t mode;
  Atm128UartStatus_t stts;
  Atm128UartControl_t ctrl;
  uint16_t ubrr1;

  ctrl.bits = (struct Atm128_UCSRB_t ){ .rxcie = 0, .txcie = 0, .rxen = 0, .txen = 0 };
  stts.bits = (struct Atm128_UCSRA_t ){ .u2x = 1 };
  mode.bits = (struct Atm128_UCSRC_t ){ .ucsz = ATM128_UART_DATA_SIZE_8_BITS };

  ubrr1 = HplAtm128UartP$Atm128Calibrate$baudrateRegister(PLATFORM_BAUDRATE);
  * (volatile uint8_t *)0x99 = ubrr1;
  * (volatile uint8_t *)0x98 = ubrr1 >> 8;
  * (volatile uint8_t *)0x9B = stts.flat;
  * (volatile uint8_t *)0x9D = mode.flat;
  * (volatile uint8_t *)0x9A = ctrl.flat;

  return SUCCESS;
}

#line 87
static inline  error_t HplAtm128UartP$Uart0Init$init(void)
#line 87
{
  Atm128UartMode_t mode;
  Atm128UartStatus_t stts;
  Atm128UartControl_t ctrl;
  uint16_t ubrr0;

  ctrl.bits = (struct Atm128_UCSRB_t ){ .rxcie = 0, .txcie = 0, .rxen = 0, .txen = 0 };
  stts.bits = (struct Atm128_UCSRA_t ){ .u2x = 1 };
  mode.bits = (struct Atm128_UCSRC_t ){ .ucsz = ATM128_UART_DATA_SIZE_8_BITS };

  ubrr0 = HplAtm128UartP$Atm128Calibrate$baudrateRegister(PLATFORM_BAUDRATE);
  * (volatile uint8_t *)(0x09 + 0x20) = ubrr0;
  * (volatile uint8_t *)0x90 = ubrr0 >> 8;
  * (volatile uint8_t *)(0x0B + 0x20) = stts.flat;
  * (volatile uint8_t *)0x95 = mode.flat;
  * (volatile uint8_t *)(0x0A + 0x20) = ctrl.flat;

  return SUCCESS;
}

# 83 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  error_t CC2420CsmaP$Init$init(void)
#line 83
{
  if (CC2420CsmaP$m_state != CC2420CsmaP$S_PREINIT) {
      return FAIL;
    }
  CC2420CsmaP$m_state = CC2420CsmaP$S_STOPPED;
  return SUCCESS;
}

# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t CC2420ControlP$AMPacket$address(void){
#line 57
  unsigned int result;
#line 57

#line 57
  result = CC2420ActiveMessageP$AMPacket$address();
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)55U |= 1 << 5;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$VREN$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$makeOutput();
#line 35
}
#line 35
# 52 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$makeOutput(void)
#line 52
{
#line 52
  * (volatile uint8_t *)49U |= 1 << 7;
}

# 35 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$makeOutput();
#line 35
}
#line 35
inline static   void CC2420ControlP$CSN$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput();
#line 35
}
#line 35
# 102 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline  error_t CC2420ControlP$Init$init(void)
#line 102
{
  CC2420ControlP$CSN$makeOutput();
  CC2420ControlP$RSTN$makeOutput();
  CC2420ControlP$VREN$makeOutput();
  CC2420ControlP$m_short_addr = CC2420ControlP$AMPacket$address();
  return SUCCESS;
}

# 45 "/opt/tinyos-2.x/tos/system/FcfsResourceQueueC.nc"
static inline  error_t /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$Init$init(void)
#line 45
{
  memset(/*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ, /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$NO_ENTRY, sizeof /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$resQ);
  return SUCCESS;
}

# 22 "/opt/tinyos-2.x/tos/system/NoInitC.nc"
static inline  error_t NoInitC$Init$init(void)
#line 22
{
  return SUCCESS;
}

# 50 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$makeInput(void)
#line 50
{
#line 50
  * (volatile uint8_t *)49U &= ~(1 << 4);
}

# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$SFD$makeInput(void){
#line 33
  /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$makeInput();
#line 33
}
#line 33


inline static   void CC2420TransmitP$CSN$makeOutput(void){
#line 35
  /*HplAtm128GeneralIOC.PortB.Bit0*/HplAtm128GeneralIOPinP$8$IO$makeOutput();
#line 35
}
#line 35
# 50 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$makeInput(void)
#line 50
{
#line 50
  * (volatile uint8_t *)49U &= ~(1 << 5);
}

# 33 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420TransmitP$CCA$makeInput(void){
#line 33
  /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$makeInput();
#line 33
}
#line 33
# 140 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline  error_t CC2420TransmitP$Init$init(void)
#line 140
{
  CC2420TransmitP$CCA$makeInput();
  CC2420TransmitP$CSN$makeOutput();
  CC2420TransmitP$SFD$makeInput();
  return SUCCESS;
}

# 103 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline  error_t CC2420ReceiveP$Init$init(void)
#line 103
{
  CC2420ReceiveP$fallingEdgeEnabled = FALSE;
  CC2420ReceiveP$m_p_rx_buf = &CC2420ReceiveP$m_rx_buf;
  return SUCCESS;
}

# 41 "/opt/tinyos-2.x/tos/interfaces/Random.nc"
inline static   uint16_t UniqueSendP$Random$rand16(void){
#line 41
  unsigned int result;
#line 41

#line 41
  result = RandomMlcgP$Random$rand16();
#line 41

#line 41
  return result;
#line 41
}
#line 41
# 62 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueSendP.nc"
static inline  error_t UniqueSendP$Init$init(void)
#line 62
{
  UniqueSendP$localSendId = UniqueSendP$Random$rand16();
  return SUCCESS;
}

# 81 "/opt/tinyos-2.x/tos/system/StateImplP.nc"
static inline  error_t StateImplP$Init$init(void)
#line 81
{
  int i;

#line 83
  for (i = 0; i < 2U; i++) {
      StateImplP$state[i] = StateImplP$S_IDLE;
    }
  return SUCCESS;
}

# 71 "/opt/tinyos-2.x/tos/chips/cc2420/UniqueReceiveP.nc"
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

# 407 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline void LinkEstimatorP$initNeighborTable(void)
#line 407
{
  uint8_t i;

  for (i = 0; i < 10; i++) {
      LinkEstimatorP$NeighborTable[i].flags = 0;
    }
}











static inline  error_t LinkEstimatorP$Init$init(void)
#line 425
{
  ;
  LinkEstimatorP$initNeighborTable();
  return SUCCESS;
}

# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$address(void){
#line 57
  unsigned int result;
#line 57

#line 57
  result = CC2420ActiveMessageP$AMPacket$address();
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 61 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static inline  uint8_t /*CtpP.SendQueueP*/QueueC$0$Queue$maxSize(void)
#line 61
{
  return 13;
}

# 65 "/opt/tinyos-2.x/tos/interfaces/Queue.nc"
inline static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$maxSize(void){
#line 65
  unsigned char result;
#line 65

#line 65
  result = /*CtpP.SendQueueP*/QueueC$0$Queue$maxSize();
#line 65

#line 65
  return result;
#line 65
}
#line 65
# 234 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static inline  error_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$Init$init(void)
#line 234
{
  int i;

#line 236
  for (i = 0; i < /*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT; i++) {
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[i] = /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientEntries + i;
      ;
    }
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$congestionThreshold = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$maxSize() >> 1;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsgPtr = &/*CtpP.Forwarder*/CtpForwardingEngineP$0$loopbackMsg;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$lastParent = /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$address();
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$seqno = 0;
  return SUCCESS;
}

# 721 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  uint8_t LinkEstimatorP$Packet$maxPayloadLength(void)
#line 721
{
  return LinkEstimatorP$SubPacket$maxPayloadLength() - sizeof(linkest_header_t );
}

#line 584
static inline  uint8_t LinkEstimatorP$Send$maxPayloadLength(void)
#line 584
{
  return LinkEstimatorP$Packet$maxPayloadLength();
}

# 112 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$maxPayloadLength(void){
#line 112
  unsigned char result;
#line 112

#line 112
  result = LinkEstimatorP$Send$maxPayloadLength();
#line 112

#line 112
  return result;
#line 112
}
#line 112
# 588 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static inline  void *LinkEstimatorP$Send$getPayload(message_t *msg)
#line 588
{
  return LinkEstimatorP$Packet$getPayload(msg, (void *)0);
}

# 125 "/opt/tinyos-2.x/tos/interfaces/AMSend.nc"
inline static  void */*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$getPayload(message_t *arg_0x7eb20600){
#line 125
  void *result;
#line 125

#line 125
  result = LinkEstimatorP$Send$getPayload(arg_0x7eb20600);
#line 125

#line 125
  return result;
#line 125
}
#line 125
# 57 "/opt/tinyos-2.x/tos/interfaces/AMPacket.nc"
inline static  am_addr_t /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$address(void){
#line 57
  unsigned int result;
#line 57

#line 57
  result = CC2420ActiveMessageP$AMPacket$address();
#line 57

#line 57
  return result;
#line 57
}
#line 57
# 654 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline void /*CtpP.Router*/CtpRoutingEngineP$0$routingTableInit(void)
#line 654
{
  /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive = 0;
}

# 26 "/opt/tinyos-2.x/tos/lib/net/ctp/TreeRouting.h"
static __inline void routeInfoInit(route_info_t *ri)
#line 26
{
  ri->parent = INVALID_ADDR;
  ri->etx = 0;
  ri->haveHeard = 0;
  ri->congested = FALSE;
}

# 200 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static inline  error_t /*CtpP.Router*/CtpRoutingEngineP$0$Init$init(void)
#line 200
{
  uint8_t maxLength;

#line 202
  /*CtpP.Router*/CtpRoutingEngineP$0$routeUpdateTimerCount = 0;
  /*CtpP.Router*/CtpRoutingEngineP$0$radioOn = FALSE;
  /*CtpP.Router*/CtpRoutingEngineP$0$running = FALSE;
  /*CtpP.Router*/CtpRoutingEngineP$0$parentChanges = 0;
  /*CtpP.Router*/CtpRoutingEngineP$0$state_is_root = 0;
  routeInfoInit(&/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo);
  /*CtpP.Router*/CtpRoutingEngineP$0$routingTableInit();
  /*CtpP.Router*/CtpRoutingEngineP$0$my_ll_addr = /*CtpP.Router*/CtpRoutingEngineP$0$AMPacket$address();
  /*CtpP.Router*/CtpRoutingEngineP$0$beaconMsg = /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$getPayload(&/*CtpP.Router*/CtpRoutingEngineP$0$beaconMsgBuffer);
  maxLength = /*CtpP.Router*/CtpRoutingEngineP$0$BeaconSend$maxPayloadLength();
  ;

  return SUCCESS;
}

# 65 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static inline  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Init$init(void)
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$queue[i] = &/*CtpP.MessagePoolP.PoolP*/PoolP$0$pool[i];
    }
  /*CtpP.MessagePoolP.PoolP*/PoolP$0$free = 12;
  /*CtpP.MessagePoolP.PoolP*/PoolP$0$index = 0;
  return SUCCESS;
}

#line 65
static inline  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Init$init(void)
#line 65
{
  int i;

#line 67
  for (i = 0; i < 12; i++) {
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$queue[i] = &/*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool[i];
    }
  /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free = 12;
  /*CtpP.QEntryPoolP.PoolP*/PoolP$1$index = 0;
  return SUCCESS;
}

# 64 "/opt/tinyos-2.x/tos/lib/net/ctp/LruCtpMsgCacheP.nc"
static inline  error_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Init$init(void)
#line 64
{
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first = 0;
  /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count = 0;
  return SUCCESS;
}

# 66 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clearAll(void)
{
  memset(/*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits, 0, sizeof /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$m_bits);
}

# 34 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clearAll(void){
#line 34
  /*DisseminationTimerP.TrickleTimerMilliC.ChangeVector*/BitVectorC$1$BitVector$clearAll();
#line 34
}
#line 34
# 66 "/opt/tinyos-2.x/tos/system/BitVectorC.nc"
static inline   void /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clearAll(void)
{
  memset(/*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits, 0, sizeof /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$m_bits);
}

# 34 "/opt/tinyos-2.x/tos/interfaces/BitVector.nc"
inline static   void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clearAll(void){
#line 34
  /*DisseminationTimerP.TrickleTimerMilliC.PendingVector*/BitVectorC$0$BitVector$clearAll();
#line 34
}
#line 34
# 74 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static inline  error_t /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Init$init(void)
#line 74
{
  int i;

#line 76
  for (i = 0; i < 1U; i++) {
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].period = 1024;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].count = 0;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].time = 0;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].remainder = 0;
    }
  /* atomic removed: atomic calls only */
#line 82
  {
    /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Pending$clearAll();
    /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clearAll();
  }
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/interfaces/Init.nc"
inline static  error_t RealMainP$SoftwareInit$init(void){
#line 51
  unsigned char result;
#line 51

#line 51
  result = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Init$init();
#line 51
  result = ecombine(result, /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$Init$init());
#line 51
  result = ecombine(result, /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Init$init());
#line 51
  result = ecombine(result, /*CtpP.MessagePoolP.PoolP*/PoolP$0$Init$init());
#line 51
  result = ecombine(result, /*CtpP.Router*/CtpRoutingEngineP$0$Init$init());
#line 51
  result = ecombine(result, /*CtpP.Forwarder*/CtpForwardingEngineP$0$Init$init());
#line 51
  result = ecombine(result, LinkEstimatorP$Init$init());
#line 51
  result = ecombine(result, UniqueReceiveP$Init$init());
#line 51
  result = ecombine(result, StateImplP$Init$init());
#line 51
  result = ecombine(result, UniqueSendP$Init$init());
#line 51
  result = ecombine(result, CC2420ReceiveP$Init$init());
#line 51
  result = ecombine(result, CC2420TransmitP$Init$init());
#line 51
  result = ecombine(result, NoInitC$Init$init());
#line 51
  result = ecombine(result, /*Atm128SpiC.Arbiter.Queue*/FcfsResourceQueueC$0$Init$init());
#line 51
  result = ecombine(result, CC2420ControlP$Init$init());
#line 51
  result = ecombine(result, CC2420CsmaP$Init$init());
#line 51
  result = ecombine(result, HplAtm128UartP$Uart0Init$init());
#line 51
  result = ecombine(result, HplAtm128UartP$Uart1Init$init());
#line 51
  result = ecombine(result, /*Atm128Uart0C.UartP*/Atm128UartP$0$Init$init());
#line 51
  result = ecombine(result, SerialP$Init$init());
#line 51
  result = ecombine(result, RandomMlcgP$Init$init());
#line 51
  result = ecombine(result, /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Init$init());
#line 51

#line 51
  return result;
#line 51
}
#line 51
# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 342 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline  error_t SerialP$SplitControl$start(void)
#line 342
{
  SerialP$startDoneTask$postTask();
  return SUCCESS;
}

# 83 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t OctopusC$SerialControl$start(void){
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
# 55 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void CC2420ControlP$StartupTimer$start(CC2420ControlP$StartupTimer$size_type arg_0x7e9d48c8){
#line 55
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$start(arg_0x7e9d48c8);
#line 55
}
#line 55
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)56U |= 1 << 5;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$VREN$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortB.Bit5*/HplAtm128GeneralIOPinP$13$IO$set();
#line 29
}
#line 29
# 135 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$CC2420Power$startVReg(void)
#line 135
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 136
    {
      if (CC2420ControlP$m_state != CC2420ControlP$S_VREG_STOPPED) {
          {
            unsigned char __nesc_temp = 
#line 138
            FAIL;

            {
#line 138
              __nesc_atomic_end(__nesc_atomic); 
#line 138
              return __nesc_temp;
            }
          }
        }
#line 140
      CC2420ControlP$m_state = CC2420ControlP$S_VREG_STARTING;
    }
#line 141
    __nesc_atomic_end(__nesc_atomic); }
  CC2420ControlP$VREN$set();
  CC2420ControlP$StartupTimer$start(CC2420_TIME_VREN);
  return SUCCESS;
}

# 51 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
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
# 92 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline  error_t CC2420CsmaP$SplitControl$start(void)
#line 92
{
  if (CC2420CsmaP$m_state != CC2420CsmaP$S_STOPPED) {
      return FAIL;
    }

  CC2420CsmaP$m_state = CC2420CsmaP$S_STARTING;
  CC2420CsmaP$CC2420Power$startVReg();
  return SUCCESS;
}

# 83 "/opt/tinyos-2.x/tos/interfaces/SplitControl.nc"
inline static  error_t OctopusC$RadioControl$start(void){
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
# 96 "OctopusC.nc"
static inline  void OctopusC$Boot$booted(void)
#line 96
{
  if (OctopusC$RadioControl$start() != SUCCESS) {
    OctopusC$fatalProblem();
    }
#line 99
  if (TOS_NODE_ID == 0) {
      OctopusC$root = TRUE;
      if (OctopusC$SerialControl$start() != SUCCESS) {
        OctopusC$fatalProblem();
        }
    }
#line 104
  __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.moteId, TOS_NODE_ID);
  __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, NO_REPLY);
  OctopusC$samplingPeriod = DEFAULT_SAMPLING_PERIOD;
  OctopusC$threshold = DEFAULT_THRESHOLD;
  OctopusC$modeAuto = DEFAULT_MODE;
  OctopusC$sleeping = FALSE;
  OctopusC$sleepDutyCycle = DEFAULT_SLEEP_DUTY_CYCLE;
  OctopusC$awakeDutyCycle = DEFAULT_AWAKE_DUTY_CYCLE;
}

# 53 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
inline static  void HplCC2420InterruptsP$CCATimer$startPeriodic(uint32_t arg_0x7eb13ce0){
#line 53
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(1U, arg_0x7eb13ce0);
#line 53
}
#line 53
# 88 "/opt/tinyos-2.x/tos/platforms/aquisgrain/chips/cc2420/HplCC2420InterruptsP.nc"
static inline  void HplCC2420InterruptsP$Boot$booted(void)
#line 88
{
  HplCC2420InterruptsP$CCATimer$startPeriodic(100);
}

# 49 "/opt/tinyos-2.x/tos/interfaces/Boot.nc"
inline static  void RealMainP$Boot$booted(void){
#line 49
  HplCC2420InterruptsP$Boot$booted();
#line 49
  OctopusC$Boot$booted();
#line 49
}
#line 49
# 155 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   mcu_power_t HplAtm128Timer0AsyncP$McuPowerOverride$lowestState(void)
#line 155
{
  uint8_t diff;


  if (* (volatile uint8_t *)(0x37 + 0x20) & ((1 << 1) | (1 << 0))) {




      while (* (volatile uint8_t *)(0x30 + 0x20) & (((1 << 2) | (1 << 1)) | (1 << 0))) 
        ;
      diff = * (volatile uint8_t *)(0x31 + 0x20) - * (volatile uint8_t *)(0x32 + 0x20);
      if (diff < EXT_STANDBY_T0_THRESHOLD || 
      * (volatile uint8_t *)(0x32 + 0x20) > 256 - EXT_STANDBY_T0_THRESHOLD) {
        return ATM128_POWER_EXT_STANDBY;
        }
#line 170
      return ATM128_POWER_SAVE;
    }
  else {
      return ATM128_POWER_DOWN;
    }
}

# 54 "/opt/tinyos-2.x/tos/interfaces/McuPowerOverride.nc"
inline static   mcu_power_t McuSleepC$McuPowerOverride$lowestState(void){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HplAtm128Timer0AsyncP$McuPowerOverride$lowestState();
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 66 "/opt/tinyos-2.x/tos/chips/atm128/McuSleepC.nc"
static inline mcu_power_t McuSleepC$getPowerState(void)
#line 66
{





  if (* (volatile uint8_t *)(0x37 + 0x20) & ~((((1 << 1) | (1 << 0)) | (1 << 2)) | (1 << 6)) || 
  * (volatile uint8_t *)0x7D & ~(1 << 2)) {
      return ATM128_POWER_IDLE;
    }
  else {
    if (* (volatile uint8_t *)(uint16_t )& * (volatile uint8_t *)(0x0D + 0x20) & (1 << 6)) {
        return ATM128_POWER_IDLE;
      }
    else {
      if ((* (volatile uint8_t *)(0x0A + 0x20) | * (volatile uint8_t *)0x9A) & ((1 << 6) | (1 << 7))) {
          return ATM128_POWER_IDLE;
        }
      else {
        if (* (volatile uint8_t *)(uint16_t )& * (volatile uint8_t *)0x74 & (1 << 2)) {
            return ATM128_POWER_IDLE;
          }
        else {
          if (* (volatile uint8_t *)(uint16_t )& * (volatile uint8_t *)(0x06 + 0x20) & (1 << 7)) {
              return ATM128_POWER_ADC_NR;
            }
          else {
              return ATM128_POWER_DOWN;
            }
          }
        }
      }
    }
}

# 132 "/opt/tinyos-2.x/tos/chips/atm128/atm128hardware.h"
static inline mcu_power_t mcombine(mcu_power_t m1, mcu_power_t m2)
#line 132
{
  return m1 < m2 ? m1 : m2;
}

# 97 "/opt/tinyos-2.x/tos/chips/atm128/McuSleepC.nc"
static inline   void McuSleepC$McuSleep$sleep(void)
#line 97
{
  uint8_t powerState;

  powerState = mcombine(McuSleepC$getPowerState(), McuSleepC$McuPowerOverride$lowestState());
  * (volatile uint8_t *)(0x35 + 0x20) = ((
  * (volatile uint8_t *)(0x35 + 0x20) & 0xe3) | (1 << 5)) | ({
#line 102
    uint16_t __addr16 = (uint16_t )(uint16_t )&McuSleepC$atm128PowerBits[powerState];
#line 102
    uint8_t __result;

#line 102
     __asm ("lpm %0, Z""\n\t" : "=r"(__result) : "z"(__addr16));__result;
  }
  );
#line 104
   __asm volatile ("sei");
   __asm volatile ("sleep");
   __asm volatile ("cli");}

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
# 140 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static __inline void HplAtm128Timer0AsyncP$stabiliseTimer0(void)
#line 140
{
  * (volatile uint8_t *)(0x33 + 0x20) = * (volatile uint8_t *)(0x33 + 0x20);
  while (* (volatile uint8_t *)(0x30 + 0x20) & (1 << 0)) 
    ;
}

# 47 "/opt/tinyos-2.x/tos/lib/timer/CounterToLocalTimeC.nc"
static inline   void /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow(void)
{
}

# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$overflow(void){
#line 71
  /*HilTimerMilliC.CounterToLocalTimeC*/CounterToLocalTimeC$0$Counter$overflow();
#line 71
}
#line 71
# 82 "/opt/tinyos-2.x/tos/chips/atm128/atm128hardware.h"
static __inline void __nesc_enable_interrupt(void)
#line 82
{
   __asm volatile ("sei");}

# 132 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
static inline   uint8_t HplAtm128Timer0AsyncP$Compare$get(void)
#line 132
{
#line 132
  return * (volatile uint8_t *)(0x31 + 0x20);
}

# 39 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$size_type /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$get(void){
#line 39
  unsigned char result;
#line 39

#line 39
  result = HplAtm128Timer0AsyncP$Compare$get();
#line 39

#line 39
  return result;
#line 39
}
#line 39
# 139 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$fired(void)
#line 139
{
  int overflowed;


  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base += /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$get() + 1U;
  overflowed = !/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base;
  __nesc_enable_interrupt();
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt();
  if (overflowed) {
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$overflow();
    }
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer0AsyncP$Compare$fired(void){
#line 49
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$fired();
#line 49
}
#line 49
# 220 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static inline   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$overflow(void)
#line 220
{
}

# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void HplAtm128Timer0AsyncP$Timer$overflow(void){
#line 61
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$overflow();
#line 61
}
#line 61
# 387 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$dataReceived(uint8_t data)
#line 387
{
  SerialP$rx_state_machine(FALSE, data);
}

# 83 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$dataReceived(uint8_t arg_0x7e719010){
#line 83
  SerialP$SerialFrameComm$dataReceived(arg_0x7e719010);
#line 83
}
#line 83
# 384 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
static inline   void SerialP$SerialFrameComm$delimiterReceived(void)
#line 384
{
  SerialP$rx_state_machine(TRUE, 0);
}

# 74 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$delimiterReceived(void){
#line 74
  SerialP$SerialFrameComm$delimiterReceived();
#line 74
}
#line 74
# 61 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
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

# 79 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receivedByte(uint8_t arg_0x7e635010){
#line 79
  HdlcTranslateC$UartStream$receivedByte(arg_0x7e635010);
#line 79
}
#line 79
# 116 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$UartStream$receiveDone(uint8_t *buf, uint16_t len, error_t error)
#line 116
{
}

# 99 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receiveDone(uint8_t *arg_0x7e635ce0, uint16_t arg_0x7e635e70, error_t arg_0x7e633010){
#line 99
  HdlcTranslateC$UartStream$receiveDone(arg_0x7e635ce0, arg_0x7e635e70, arg_0x7e633010);
#line 99
}
#line 99
# 107 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$rxDone(uint8_t data)
#line 107
{

  if (/*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_buf) {
      /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_buf[/*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_pos++] = data;
      if (/*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_pos >= /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_len) {
          uint8_t *buf = /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_buf;

#line 113
          /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_buf = (void *)0;
          /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receiveDone(buf, /*Atm128Uart0C.UartP*/Atm128UartP$0$m_rx_len, SUCCESS);
        }
    }
  else {
      /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$receivedByte(data);
    }
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
inline static   void HplAtm128UartP$HplUart0$rxDone(uint8_t arg_0x7e603b30){
#line 49
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$rxDone(arg_0x7e603b30);
#line 49
}
#line 49
# 391 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 197 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$lockCurrentBuffer(void)
#line 197
{
  if (/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which) {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked = 1;
    }
  else {
      /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked = 1;
    }
}

#line 193
static inline bool /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$isCurrentBufferLocked(void)
#line 193
{
  return /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufZeroLocked : /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.bufOneLocked;
}

#line 220
static inline   error_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$startPacket(void)
#line 220
{
  error_t result = SUCCESS;

  /* atomic removed: atomic calls only */
#line 222
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

# 51 "/opt/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
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
# 309 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 69 "/opt/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$endPacket(error_t arg_0x7e725e08){
#line 69
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(arg_0x7e725e08);
#line 69
}
#line 69
# 215 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBufferSwap(void)
#line 215
{
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which = /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which ? 0 : 1;
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveBuffer = (uint8_t *)/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$messagePtrs[/*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$receiveState.which];
}

# 56 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
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
# 232 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 238 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(uint8_t b)
#line 238
{
  /* atomic removed: atomic calls only */
#line 239
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
#line 260
            ;
      }
  }
}

# 58 "/opt/tinyos-2.x/tos/lib/serial/ReceiveBytePacket.nc"
inline static   void SerialP$ReceiveBytePacket$byteReceived(uint8_t arg_0x7e725838){
#line 58
  /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$byteReceived(arg_0x7e725838);
#line 58
}
#line 58
# 299 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 55 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static inline   void HdlcTranslateC$SerialFrameComm$resetReceive(void)
#line 55
{
  HdlcTranslateC$state.receiveEscape = 0;
}

# 68 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void SerialP$SerialFrameComm$resetReceive(void){
#line 68
  HdlcTranslateC$SerialFrameComm$resetReceive();
#line 68
}
#line 68
#line 54
inline static   error_t SerialP$SerialFrameComm$putData(uint8_t arg_0x7e721d40){
#line 54
  unsigned char result;
#line 54

#line 54
  result = HdlcTranslateC$SerialFrameComm$putData(arg_0x7e721d40);
#line 54

#line 54
  return result;
#line 54
}
#line 54
# 513 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 60 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
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
# 172 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static inline   uint8_t /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$SendBytePacket$nextByte(void)
#line 172
{
  uint8_t b;
  uint8_t indx;

  /* atomic removed: atomic calls only */
#line 175
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

# 70 "/opt/tinyos-2.x/tos/lib/serial/SendBytePacket.nc"
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
# 642 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

        case SerialP$TXSTATE_INFO: 
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 666
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
#line 684
            __nesc_atomic_end(__nesc_atomic); }
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

# 89 "/opt/tinyos-2.x/tos/lib/serial/SerialFrameComm.nc"
inline static   void HdlcTranslateC$SerialFrameComm$putDone(void){
#line 89
  SerialP$SerialFrameComm$putDone();
#line 89
}
#line 89
# 48 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   error_t HdlcTranslateC$UartStream$send(uint8_t *arg_0x7e637768, uint16_t arg_0x7e6378f8){
#line 48
  unsigned char result;
#line 48

#line 48
  result = /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$send(arg_0x7e637768, arg_0x7e6378f8);
#line 48

#line 48
  return result;
#line 48
}
#line 48
# 104 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
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

# 57 "/opt/tinyos-2.x/tos/interfaces/UartStream.nc"
inline static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$sendDone(uint8_t *arg_0x7e637f00, uint16_t arg_0x7e6360b0, error_t arg_0x7e636238){
#line 57
  HdlcTranslateC$UartStream$sendDone(arg_0x7e637f00, arg_0x7e6360b0, arg_0x7e636238);
#line 57
}
#line 57
# 46 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
inline static   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$tx(uint8_t arg_0x7e603068){
#line 46
  HplAtm128UartP$HplUart0$tx(arg_0x7e603068);
#line 46
}
#line 46
# 139 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$txDone(void)
#line 139
{

  if (/*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_pos < /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_len) {
      /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$tx(/*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf[/*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_pos++]);
    }
  else {
      uint8_t *buf = /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf;

#line 146
      /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf = (void *)0;
      /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$sendDone(buf, /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_len, SUCCESS);
    }
}

# 47 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
inline static   void HplAtm128UartP$HplUart0$txDone(void){
#line 47
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$txDone();
#line 47
}
#line 47
# 283 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline    void HplAtm128UartP$HplUart1$default$rxDone(uint8_t data)
#line 283
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
inline static   void HplAtm128UartP$HplUart1$rxDone(uint8_t arg_0x7e603b30){
#line 49
  HplAtm128UartP$HplUart1$default$rxDone(arg_0x7e603b30);
#line 49
}
#line 49
# 282 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static inline    void HplAtm128UartP$HplUart1$default$txDone(void)
#line 282
{
}

# 47 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128Uart.nc"
inline static   void HplAtm128UartP$HplUart1$txDone(void){
#line 47
  HplAtm128UartP$HplUart1$default$txDone();
#line 47
}
#line 47
# 188 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline    void HplAtm128Timer3P$CompareA$default$fired(void)
#line 188
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer3P$CompareA$fired(void){
#line 49
  HplAtm128Timer3P$CompareA$default$fired();
#line 49
}
#line 49
# 192 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline    void HplAtm128Timer3P$CompareB$default$fired(void)
#line 192
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer3P$CompareB$fired(void){
#line 49
  HplAtm128Timer3P$CompareB$default$fired();
#line 49
}
#line 49
# 196 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline    void HplAtm128Timer3P$CompareC$default$fired(void)
#line 196
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer3P$CompareC$fired(void){
#line 49
  HplAtm128Timer3P$CompareC$default$fired();
#line 49
}
#line 49
# 200 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline    void HplAtm128Timer3P$Capture$default$captured(uint16_t time)
#line 200
{
}

# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void HplAtm128Timer3P$Capture$captured(HplAtm128Timer3P$Capture$size_type arg_0x7e55c120){
#line 51
  HplAtm128Timer3P$Capture$default$captured(arg_0x7e55c120);
#line 51
}
#line 51
# 47 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
static inline   uint16_t HplAtm128Timer3P$Timer$get(void)
#line 47
{
#line 47
  return * (volatile uint16_t *)0x88;
}

# 174 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static inline   void /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$overflow(void)
#line 174
{
}

# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*CounterMicro32C.Transform32*/TransformCounterC$0$Counter$overflow(void){
#line 71
  /*Atm128Uart0C.UartP*/Atm128UartP$0$Counter$overflow();
#line 71
}
#line 71
# 122 "/opt/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline   void /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$overflow(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*CounterMicro32C.Transform32*/TransformCounterC$0$m_upper++;
      if ((/*CounterMicro32C.Transform32*/TransformCounterC$0$m_upper & /*CounterMicro32C.Transform32*/TransformCounterC$0$OVERFLOW_MASK) == 0) {
        /*CounterMicro32C.Transform32*/TransformCounterC$0$Counter$overflow();
        }
    }
#line 130
    __nesc_atomic_end(__nesc_atomic); }
}

# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*CounterThree16C.NCounter*/Atm128CounterC$0$Counter$overflow(void){
#line 71
  /*CounterMicro32C.Transform32*/TransformCounterC$0$CounterFrom$overflow();
#line 71
}
#line 71
# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   void /*CounterThree16C.NCounter*/Atm128CounterC$0$Timer$overflow(void)
{
  /*CounterThree16C.NCounter*/Atm128CounterC$0$Counter$overflow();
}

# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline   void /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$overflow(void)
#line 51
{
}

# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void HplAtm128Timer3P$Timer$overflow(void){
#line 61
  /*InitThreeP.InitThree*/Atm128TimerInitC$0$Timer$overflow();
#line 61
  /*CounterThree16C.NCounter*/Atm128CounterC$0$Timer$overflow();
#line 61
}
#line 61
# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
inline static   error_t CC2420ControlP$SpiResource$request(void){
#line 78
  unsigned char result;
#line 78

#line 78
  result = CC2420SpiImplP$Resource$request(/*CC2420ControlC.Spi*/CC2420SpiC$0$CLIENT_ID);
#line 78

#line 78
  return result;
#line 78
}
#line 78
# 119 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   error_t CC2420ControlP$Resource$request(void)
#line 119
{
  return CC2420ControlP$SpiResource$request();
}

# 78 "/opt/tinyos-2.x/tos/interfaces/Resource.nc"
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
# 200 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static inline   void CC2420CsmaP$CC2420Power$startVRegDone(void)
#line 200
{
  CC2420CsmaP$Resource$request();
}

# 56 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Power.nc"
inline static   void CC2420ControlP$CC2420Power$startVRegDone(void){
#line 56
  CC2420CsmaP$CC2420Power$startVRegDone();
#line 56
}
#line 56
# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$set(void)
#line 46
{
#line 46
  * (volatile uint8_t *)50U |= 1 << 7;
}

# 29 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$set(void){
#line 29
  /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$set();
#line 29
}
#line 29
# 47 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   void /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$clr(void)
#line 47
{
#line 47
  * (volatile uint8_t *)50U &= ~(1 << 7);
}

# 30 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   void CC2420ControlP$RSTN$clr(void){
#line 30
  /*HplAtm128GeneralIOC.PortD.Bit7*/HplAtm128GeneralIOPinP$31$IO$clr();
#line 30
}
#line 30
# 322 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ControlP.nc"
static inline   void CC2420ControlP$StartupTimer$fired(void)
#line 322
{
  if (CC2420ControlP$m_state == CC2420ControlP$S_VREG_STARTING) {
      CC2420ControlP$m_state = CC2420ControlP$S_VREG_STARTED;
      CC2420ControlP$RSTN$clr();
      CC2420ControlP$RSTN$set();
      CC2420ControlP$CC2420Power$startVRegDone();
    }
}

# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420TransmitP$CCA$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplAtm128GeneralIOC.PortD.Bit5*/HplAtm128GeneralIOPinP$29$IO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 456 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$BackoffTimer$fired(void)
#line 456
{
  /* atomic removed: atomic calls only */
#line 457
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

        case CC2420TransmitP$S_CCA_CANCEL: 
          CC2420TransmitP$m_state = CC2420TransmitP$S_TX_CANCEL;


        case CC2420TransmitP$S_BEGIN_TRANSMIT: 
          case CC2420TransmitP$S_TX_CANCEL: 
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

# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$fired(void){
#line 67
  CC2420TransmitP$BackoffTimer$fired();
#line 67
  CC2420ControlP$StartupTimer$fired();
#line 67
}
#line 67
# 151 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$fired(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt == 0) 
        {
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$fired();
        }
      else 
        {
          /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$set_alarm();
        }
    }
#line 163
    __nesc_atomic_end(__nesc_atomic); }
}

# 67 "/opt/tinyos-2.x/tos/lib/timer/Alarm.nc"
inline static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$fired(void){
#line 67
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$fired();
#line 67
}
#line 67
# 110 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$fired(void)
#line 110
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$stop();
  ;
  __nesc_enable_interrupt();
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$Alarm$fired();
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer1P$CompareA$fired(void){
#line 49
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Compare$fired();
#line 49
}
#line 49
# 198 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline    void HplAtm128Timer1P$CompareB$default$fired(void)
#line 198
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer1P$CompareB$fired(void){
#line 49
  HplAtm128Timer1P$CompareB$default$fired();
#line 49
}
#line 49
# 202 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline    void HplAtm128Timer1P$CompareC$default$fired(void)
#line 202
{
}

# 49 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Compare.nc"
inline static   void HplAtm128Timer1P$CompareC$fired(void){
#line 49
  HplAtm128Timer1P$CompareC$default$fired();
#line 49
}
#line 49
# 166 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$CC2420Receive$sfd_dropped(void)
#line 166
{
  if (CC2420ReceiveP$m_timestamp_size) {
      CC2420ReceiveP$m_timestamp_size--;
    }
}

# 53 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
inline static   void CC2420TransmitP$CC2420Receive$sfd_dropped(void){
#line 53
  CC2420ReceiveP$CC2420Receive$sfd_dropped();
#line 53
}
#line 53
# 45 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static __inline   bool /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$get(void)
#line 45
{
#line 45
  return (* (volatile uint8_t *)48U & (1 << 4)) != 0;
}

# 32 "/opt/tinyos-2.x/tos/interfaces/GeneralIO.nc"
inline static   bool CC2420TransmitP$SFD$get(void){
#line 32
  unsigned char result;
#line 32

#line 32
  result = /*HplAtm128GeneralIOC.PortD.Bit4*/HplAtm128GeneralIOPinP$28$IO$get();
#line 32

#line 32
  return result;
#line 32
}
#line 32
# 157 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$CC2420Receive$sfd(uint16_t time)
#line 157
{
  if (CC2420ReceiveP$m_timestamp_size < CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE) {
      uint8_t tail = (CC2420ReceiveP$m_timestamp_head + CC2420ReceiveP$m_timestamp_size) % 
      CC2420ReceiveP$TIMESTAMP_QUEUE_SIZE;

#line 161
      CC2420ReceiveP$m_timestamp_queue[tail] = time;
      CC2420ReceiveP$m_timestamp_size++;
    }
}

# 47 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420Receive.nc"
inline static   void CC2420TransmitP$CC2420Receive$sfd(uint16_t arg_0x7de52aa8){
#line 47
  CC2420ReceiveP$CC2420Receive$sfd(arg_0x7de52aa8);
#line 47
}
#line 47
# 770 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline    void CC2420TransmitP$TimeStamp$default$receivedSFD(uint16_t time)
#line 770
{
}

# 50 "/opt/tinyos-2.x/tos/interfaces/RadioTimeStamping.nc"
inline static   void CC2420TransmitP$TimeStamp$receivedSFD(uint16_t arg_0x7de73b40){
#line 50
  CC2420TransmitP$TimeStamp$default$receivedSFD(arg_0x7de73b40);
#line 50
}
#line 50
# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128GpioCaptureC.nc"
static inline   error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureFallingEdge(void)
#line 56
{
  return /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$enableCapture(FALSE);
}

# 43 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   error_t CC2420TransmitP$CaptureSFD$captureFallingEdge(void){
#line 43
  unsigned char result;
#line 43

#line 43
  result = /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captureFallingEdge();
#line 43

#line 43
  return result;
#line 43
}
#line 43
# 767 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline    void CC2420TransmitP$TimeStamp$default$transmittedSFD(uint16_t time, message_t *p_msg)
#line 767
{
}

# 39 "/opt/tinyos-2.x/tos/interfaces/RadioTimeStamping.nc"
inline static   void CC2420TransmitP$TimeStamp$transmittedSFD(uint16_t arg_0x7de73460, message_t *arg_0x7de73610){
#line 39
  CC2420TransmitP$TimeStamp$default$transmittedSFD(arg_0x7de73460, arg_0x7de73610);
#line 39
}
#line 39
# 263 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static inline   void CC2420TransmitP$CaptureSFD$captured(uint16_t time)
#line 263
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 264
    {
      switch (CC2420TransmitP$m_state) {

          case CC2420TransmitP$S_SFD: 
            CC2420TransmitP$CaptureSFD$captureFallingEdge();
          CC2420TransmitP$TimeStamp$transmittedSFD(time, CC2420TransmitP$m_msg);
          CC2420TransmitP$releaseSpiResource();
          CC2420TransmitP$BackoffTimer$stop();
          CC2420TransmitP$m_state = CC2420TransmitP$S_EFD;
          if (((__nesc_ntoh_leuint16((unsigned char *)&CC2420TransmitP$CC2420Packet$getHeader(CC2420TransmitP$m_msg)->fcf) >> IEEE154_FCF_FRAME_TYPE) & 7) == IEEE154_TYPE_DATA) {
              __nesc_hton_uint16((unsigned char *)&CC2420TransmitP$CC2420Packet$getMetadata(CC2420TransmitP$m_msg)->time, time);
            }

          if (CC2420TransmitP$SFD$get()) {
              break;
            }


          case CC2420TransmitP$S_EFD: 
            CC2420TransmitP$CaptureSFD$captureRisingEdge();
          if (__nesc_ntoh_leuint16((unsigned char *)&CC2420TransmitP$CC2420Packet$getHeader(CC2420TransmitP$m_msg)->fcf) & (1 << IEEE154_FCF_ACK_REQ)) {
              CC2420TransmitP$m_state = CC2420TransmitP$S_ACK_WAIT;
              CC2420TransmitP$BackoffTimer$start(CC2420_ACK_WAIT_DELAY);
            }
          else 
#line 287
            {







              CC2420TransmitP$signalDone(SUCCESS);
            }

          if (!CC2420TransmitP$SFD$get()) {
              break;
            }


          default: 
            if (!CC2420TransmitP$m_receiving) {
                CC2420TransmitP$CaptureSFD$captureFallingEdge();
                CC2420TransmitP$TimeStamp$receivedSFD(time);
                CC2420TransmitP$CC2420Receive$sfd(time);
                CC2420TransmitP$m_receiving = TRUE;
                CC2420TransmitP$m_prev_time = time;
                if (CC2420TransmitP$SFD$get()) {
                    {
                      __nesc_atomic_end(__nesc_atomic); 
#line 312
                      return;
                    }
                  }
              }
          CC2420TransmitP$CaptureSFD$captureRisingEdge();
          CC2420TransmitP$m_receiving = FALSE;
          if (time - CC2420TransmitP$m_prev_time < 10) {
              CC2420TransmitP$CC2420Receive$sfd_dropped();
            }
          break;
        }
    }
#line 323
    __nesc_atomic_end(__nesc_atomic); }
}

# 50 "/opt/tinyos-2.x/tos/interfaces/GpioCapture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captured(uint16_t arg_0x7e124ab8){
#line 50
  CC2420TransmitP$CaptureSFD$captured(arg_0x7e124ab8);
#line 50
}
#line 50
# 126 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
static inline   void HplAtm128Timer1P$Capture$reset(void)
#line 126
{
#line 126
  * (volatile uint8_t *)(0x36 + 0x20) = 1 << 5;
}

# 55 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$reset(void){
#line 55
  HplAtm128Timer1P$Capture$reset();
#line 55
}
#line 55
# 64 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128GpioCaptureC.nc"
static inline   void /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$captured(uint16_t time)
#line 64
{
  /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$reset();
  /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Capture$captured(time);
}

# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Capture.nc"
inline static   void HplAtm128Timer1P$Capture$captured(HplAtm128Timer1P$Capture$size_type arg_0x7e55c120){
#line 51
  /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$captured(arg_0x7e55c120);
#line 51
}
#line 51
# 117 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$overflow(void)
#line 117
{
}

# 166 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static inline   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$overflow(void)
{
}

# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$overflow(void){
#line 71
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$overflow();
#line 71
}
#line 71
# 122 "/opt/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static inline   void /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$overflow(void)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*Counter32khz32C.Transform32*/TransformCounterC$1$m_upper++;
      if ((/*Counter32khz32C.Transform32*/TransformCounterC$1$m_upper & /*Counter32khz32C.Transform32*/TransformCounterC$1$OVERFLOW_MASK) == 0) {
        /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$overflow();
        }
    }
#line 130
    __nesc_atomic_end(__nesc_atomic); }
}

# 71 "/opt/tinyos-2.x/tos/lib/timer/Counter.nc"
inline static   void /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$overflow(void){
#line 71
  /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$overflow();
#line 71
}
#line 71
# 56 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128CounterC.nc"
static inline   void /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$overflow(void)
{
  /*CounterOne16C.NCounter*/Atm128CounterC$1$Counter$overflow();
}

# 51 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128TimerInitC.nc"
static inline   void /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$overflow(void)
#line 51
{
}

# 61 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer.nc"
inline static   void HplAtm128Timer1P$Timer$overflow(void){
#line 61
  /*InitOneP.InitOne*/Atm128TimerInitC$1$Timer$overflow();
#line 61
  /*CounterOne16C.NCounter*/Atm128CounterC$1$Timer$overflow();
#line 61
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Alarm16.NAlarm*/Atm128AlarmC$0$HplAtm128Timer$overflow();
#line 61
}
#line 61
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig0$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin0*/HplAtm128InterruptPinP$0$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig1$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin1*/HplAtm128InterruptPinP$1$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig2$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin2*/HplAtm128InterruptPinP$2$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig3$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin3*/HplAtm128InterruptPinP$3$IrqSignal$fired();
#line 41
}
#line 41
# 174 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static inline   void CC2420ReceiveP$InterruptFIFOP$fired(void)
#line 174
{
  if (CC2420ReceiveP$m_state == CC2420ReceiveP$S_STARTED) {
      CC2420ReceiveP$beginReceive();
    }
  else {
      CC2420ReceiveP$m_missed_packets++;
    }
}

# 57 "/opt/tinyos-2.x/tos/interfaces/GpioInterrupt.nc"
inline static   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$fired(void){
#line 57
  CC2420ReceiveP$InterruptFIFOP$fired();
#line 57
}
#line 57
# 38 "/opt/tinyos-2.x/tos/chips/atm128/pins/Atm128GpioInterruptC.nc"
static inline   void /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$fired(void)
#line 38
{
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Interrupt$fired();
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$fired(void){
#line 64
  /*HplCC2420InterruptsC.InterruptFIFOPC*/Atm128GpioInterruptC$0$Atm128Interrupt$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig4$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin4*/HplAtm128InterruptPinP$4$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig5$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin5*/HplAtm128InterruptPinP$5$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig6$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin6*/HplAtm128InterruptPinP$6$IrqSignal$fired();
#line 41
}
#line 41
# 63 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline    void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$default$fired(void)
#line 63
{
}

# 64 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128Interrupt.nc"
inline static   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$fired(void){
#line 64
  /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$default$fired();
#line 64
}
#line 64
# 61 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptPinP.nc"
static inline   void /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$IrqSignal$fired(void)
#line 61
{
#line 61
  /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$Irq$fired();
}

# 41 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSig.nc"
inline static   void HplAtm128InterruptSigP$IntSig7$fired(void){
#line 41
  /*HplAtm128InterruptC.IntPin7*/HplAtm128InterruptPinP$7$IrqSignal$fired();
#line 41
}
#line 41
# 99 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static inline   uint8_t HplAtm128SpiP$SPI$read(void)
#line 99
{
#line 99
  return * (volatile uint8_t *)(0x0F + 0x20);
}

# 80 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   uint8_t Atm128SpiP$Spi$read(void){
#line 80
  unsigned char result;
#line 80

#line 80
  result = HplAtm128SpiP$SPI$read();
#line 80

#line 80
  return result;
#line 80
}
#line 80
#line 96
inline static   void Atm128SpiP$Spi$enableInterrupt(bool arg_0x7dfb2da0){
#line 96
  HplAtm128SpiP$SPI$enableInterrupt(arg_0x7dfb2da0);
#line 96
}
#line 96
# 264 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static inline   void Atm128SpiP$Spi$dataReady(uint8_t data)
#line 264
{
  bool again;

  /* atomic removed: atomic calls only */
#line 267
  {
    if (Atm128SpiP$rxBuffer != (void *)0) {
        Atm128SpiP$rxBuffer[Atm128SpiP$pos] = data;
      }

    Atm128SpiP$pos++;
  }
  Atm128SpiP$Spi$enableInterrupt(FALSE);
  /* atomic removed: atomic calls only */
  {
    again = Atm128SpiP$pos < Atm128SpiP$len;
  }

  if (again) {
      Atm128SpiP$sendNextPart();
    }
  else {
      uint8_t *rx;
      uint8_t *tx;
      uint16_t myLen;
      uint8_t discard;

      /* atomic removed: atomic calls only */
#line 289
      {
        rx = Atm128SpiP$rxBuffer;
        tx = Atm128SpiP$txBuffer;
        myLen = Atm128SpiP$len;
        Atm128SpiP$rxBuffer = (void *)0;
        Atm128SpiP$txBuffer = (void *)0;
        Atm128SpiP$len = 0;
        Atm128SpiP$pos = 0;
      }
      discard = Atm128SpiP$Spi$read();

      Atm128SpiP$SpiPacket$sendDone(tx, rx, myLen, SUCCESS);
    }
}

# 92 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128Spi.nc"
inline static   void HplAtm128SpiP$SPI$dataReady(uint8_t arg_0x7dfb2858){
#line 92
  Atm128SpiP$Spi$dataReady(arg_0x7dfb2858);
#line 92
}
#line 92
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

#line 164
static   void SchedulerBasicP$TaskBasic$default$runTask(uint8_t id)
{
}

# 64 "/opt/tinyos-2.x/tos/interfaces/TaskBasic.nc"
static  void SchedulerBasicP$TaskBasic$runTask(uint8_t arg_0x7f080b18){
#line 64
  switch (arg_0x7f080b18) {
#line 64
    case OctopusC$collectSendTask:
#line 64
      OctopusC$collectSendTask$runTask();
#line 64
      break;
#line 64
    case OctopusC$serialSendTask:
#line 64
      OctopusC$serialSendTask$runTask();
#line 64
      break;
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
    case /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask:
#line 64
      /*OctopusAppC.Sensor.DemoChannel*/SineSensorC$0$readTask$runTask();
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
    case CC2420ControlP$syncDone_task:
#line 64
      CC2420ControlP$syncDone_task$runTask();
#line 64
      break;
#line 64
    case HplCC2420InterruptsP$CCATask:
#line 64
      HplCC2420InterruptsP$CCATask$runTask();
#line 64
      break;
#line 64
    case HplCC2420InterruptsP$stopTask:
#line 64
      HplCC2420InterruptsP$stopTask$runTask();
#line 64
      break;
#line 64
    case Atm128SpiP$zeroTask:
#line 64
      Atm128SpiP$zeroTask$runTask();
#line 64
      break;
#line 64
    case /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask:
#line 64
      /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$grantedTask$runTask();
#line 64
      break;
#line 64
    case CC2420TransmitP$startLplTimer:
#line 64
      CC2420TransmitP$startLplTimer$runTask();
#line 64
      break;
#line 64
    case CC2420ReceiveP$receiveDone_task:
#line 64
      CC2420ReceiveP$receiveDone_task$runTask();
#line 64
      break;
#line 64
    case /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask:
#line 64
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendTask$runTask();
#line 64
      break;
#line 64
    case /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask:
#line 64
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$CancelTask$runTask();
#line 64
      break;
#line 64
    case /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask:
#line 64
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$runTask();
#line 64
      break;
#line 64
    case /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask:
#line 64
      /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$runTask();
#line 64
      break;
#line 64
    case /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask:
#line 64
      /*CtpP.Router*/CtpRoutingEngineP$0$sendBeaconTask$runTask();
#line 64
      break;
#line 64
    case /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask:
#line 64
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$timerTask$runTask();
#line 64
      break;
#line 64
    default:
#line 64
      SchedulerBasicP$TaskBasic$default$runTask(arg_0x7f080b18);
#line 64
      break;
#line 64
    }
#line 64
}
#line 64
# 129 "/opt/tinyos-2.x/tos/lib/net/DisseminationEngineImplP.nc"
static void DisseminationEngineImplP$sendObject(uint16_t key)
#line 129
{
  void *object;
  uint8_t objectSize = 0;

  dissemination_message_t *dMsg = 
  (dissemination_message_t *)DisseminationEngineImplP$AMSend$getPayload(&DisseminationEngineImplP$m_buf);

  DisseminationEngineImplP$m_bufBusy = TRUE;

  __nesc_hton_uint16((unsigned char *)&dMsg->key, key);
  __nesc_hton_uint32((unsigned char *)&dMsg->seqno, DisseminationEngineImplP$DisseminationCache$requestSeqno(key));

  if (__nesc_ntoh_uint32((unsigned char *)&dMsg->seqno) != DISSEMINATION_SEQNO_UNKNOWN) {
      object = DisseminationEngineImplP$DisseminationCache$requestData(key, &objectSize);
      if (objectSize + sizeof(dissemination_message_t ) > 
      DisseminationEngineImplP$AMSend$maxPayloadLength()) {
          objectSize = DisseminationEngineImplP$AMSend$maxPayloadLength() - sizeof(dissemination_message_t );
        }
      memcpy(dMsg->data, object, objectSize);
    }
  DisseminationEngineImplP$AMSend$send(AM_BROADCAST_ADDR, 
  &DisseminationEngineImplP$m_buf, sizeof(dissemination_message_t ) + objectSize);
}

# 180 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static  void *CC2420ActiveMessageP$Packet$getPayload(message_t *msg, uint8_t *len)
#line 180
{
  if (len != (void *)0) {
      *len = CC2420ActiveMessageP$Packet$payloadLength(msg);
    }
  return msg->data;
}

#line 127
static  void CC2420ActiveMessageP$AMPacket$setDestination(message_t *amsg, am_addr_t addr)
#line 127
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(amsg);

#line 129
  __nesc_hton_leuint16((unsigned char *)&header->dest, addr);
}

#line 147
static  void CC2420ActiveMessageP$AMPacket$setType(message_t *amsg, am_id_t type)
#line 147
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(amsg);

#line 149
  __nesc_hton_leuint8((unsigned char *)&header->type, type);
}

# 82 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static  error_t /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$send(uint8_t clientId, message_t *msg, 
uint8_t len)
#line 83
{
  if (clientId >= 4) {
      return FAIL;
    }
  if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[clientId].msg != (void *)0) {
      return EBUSY;
    }
  ;

  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[clientId].msg = msg;
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$setPayloadLength(msg, len);

  if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current >= 4) {
      error_t err;
      am_id_t amId = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$type(msg);
      am_addr_t dest = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$destination(msg);

      ;
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = clientId;

      err = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$send(amId, dest, msg, len);
      if (err != SUCCESS) {
          ;
          /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current = 4;
          /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[clientId].msg = (void *)0;
        }

      return err;
    }
  else {
      ;
    }
  return SUCCESS;
}

# 172 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static  void CC2420ActiveMessageP$Packet$setPayloadLength(message_t *msg, uint8_t len)
#line 172
{
  __nesc_hton_leuint8((unsigned char *)&CC2420ActiveMessageP$CC2420Packet$getHeader(msg)->length, len + CC2420ActiveMessageP$CC2420_SIZE);
}

#line 142
static  am_id_t CC2420ActiveMessageP$AMPacket$type(message_t *amsg)
#line 142
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(amsg);

#line 144
  return __nesc_ntoh_leuint8((unsigned char *)&header->type);
}

#line 117
static  am_addr_t CC2420ActiveMessageP$AMPacket$destination(message_t *amsg)
#line 117
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(amsg);

#line 119
  return __nesc_ntoh_leuint16((unsigned char *)&header->dest);
}

#line 59
static  error_t CC2420ActiveMessageP$AMSend$send(am_id_t id, am_addr_t addr, 
message_t *msg, 
uint8_t len)
#line 61
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(msg);

#line 63
  __nesc_hton_leuint8((unsigned char *)&header->type, id);
  __nesc_hton_leuint16((unsigned char *)&header->dest, addr);
  __nesc_hton_leuint16((unsigned char *)&header->destpan, TOS_AM_GROUP);

  return CC2420ActiveMessageP$SubSend$send(msg, len + CC2420ActiveMessageP$CC2420_SIZE);
}

# 698 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static error_t CC2420TransmitP$acquireSpiResource(void)
#line 698
{
  error_t error = CC2420TransmitP$SpiResource$immediateRequest();

#line 700
  if (error != SUCCESS) {
      CC2420TransmitP$SpiResource$request();
    }
  return error;
}

# 80 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static   error_t CC2420SpiImplP$Resource$immediateRequest(uint8_t id)
#line 80
{
  error_t error;

#line 82
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 82
    {
      if (CC2420SpiImplP$m_resource_busy) 
        {
          unsigned char __nesc_temp = 
#line 84
          EBUSY;

          {
#line 84
            __nesc_atomic_end(__nesc_atomic); 
#line 84
            return __nesc_temp;
          }
        }
#line 85
      error = CC2420SpiImplP$SpiResource$immediateRequest();
      if (error == SUCCESS) {
          CC2420SpiImplP$m_holder = id;
          CC2420SpiImplP$m_resource_busy = TRUE;
        }
    }
#line 90
    __nesc_atomic_end(__nesc_atomic); }
  return error;
}

# 106 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static void Atm128SpiP$startSpi(void)
#line 106
{
  Atm128SpiP$Spi$enableSpi(FALSE);
  /* atomic removed: atomic calls only */
#line 108
  {
    Atm128SpiP$Spi$initMaster();
    Atm128SpiP$Spi$enableInterrupt(FALSE);
    Atm128SpiP$Spi$setMasterDoubleSpeed(TRUE);
    Atm128SpiP$Spi$setClockPolarity(FALSE);
    Atm128SpiP$Spi$setClockPhase(FALSE);
    Atm128SpiP$Spi$setClock(0);
    Atm128SpiP$Spi$enableSpi(TRUE);
  }
  Atm128SpiP$McuPowerState$update();
}

# 131 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
static   void HplAtm128SpiP$SPI$enableSpi(bool enabled)
#line 131
{
  if (enabled) {
      * (volatile uint8_t *)(0x0D + 0x20) |= 1 << 6;
      HplAtm128SpiP$Mcu$update();
    }
  else {
      * (volatile uint8_t *)(0x0D + 0x20) &= ~(1 << 6);
      HplAtm128SpiP$Mcu$update();
    }
}

#line 116
static   void HplAtm128SpiP$SPI$enableInterrupt(bool enabled)
#line 116
{
  if (enabled) {
      * (volatile uint8_t *)(0x0D + 0x20) |= 1 << 7;
      HplAtm128SpiP$Mcu$update();
    }
  else {
      * (volatile uint8_t *)(0x0D + 0x20) &= ~(1 << 7);
      HplAtm128SpiP$Mcu$update();
    }
}

# 67 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static   error_t CC2420SpiImplP$Resource$request(uint8_t id)
#line 67
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 68
    {
      if (CC2420SpiImplP$m_resource_busy) {
        CC2420SpiImplP$m_requests |= 1 << id;
        }
      else 
#line 71
        {
          CC2420SpiImplP$m_holder = id;
          CC2420SpiImplP$m_resource_busy = TRUE;
          CC2420SpiImplP$SpiResource$request();
        }
    }
#line 76
    __nesc_atomic_end(__nesc_atomic); }
  return SUCCESS;
}

# 312 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static   error_t Atm128SpiP$Resource$request(uint8_t id)
#line 312
{
  /* atomic removed: atomic calls only */
#line 313
  {
    if (!Atm128SpiP$ArbiterInfo$inUse()) {
        Atm128SpiP$startSpi();
      }
  }
  return Atm128SpiP$ResourceArbiter$request(id);
}

# 123 "/opt/tinyos-2.x/tos/system/SimpleArbiterP.nc"
static   bool /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$ArbiterInfo$inUse(void)
#line 123
{
  /* atomic removed: atomic calls only */
#line 124
  {
    if (/*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$state == /*Atm128SpiC.Arbiter.Arbiter*/SimpleArbiterP$0$RES_IDLE) 
      {
        unsigned char __nesc_temp = 
#line 126
        FALSE;

#line 126
        return __nesc_temp;
      }
  }
#line 128
  return TRUE;
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

# 728 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static void CC2420TransmitP$loadTXFIFO(void)
#line 728
{
  cc2420_header_t *header = CC2420TransmitP$CC2420Packet$getHeader(CC2420TransmitP$m_msg);
  uint8_t tx_power = __nesc_ntoh_uint8((unsigned char *)&CC2420TransmitP$CC2420Packet$getMetadata(CC2420TransmitP$m_msg)->tx_power);

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

  CC2420TransmitP$TXFIFO$write((uint8_t *)header, __nesc_ntoh_leuint8((unsigned char *)&header->length) - 1);
}

# 251 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static   cc2420_status_t CC2420SpiImplP$Reg$write(uint8_t addr, uint16_t data)
#line 251
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 252
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 254
            0;

            {
#line 254
              __nesc_atomic_end(__nesc_atomic); 
#line 254
              return __nesc_temp;
            }
          }
        }
    }
#line 258
    __nesc_atomic_end(__nesc_atomic); }
#line 258
  CC2420SpiImplP$SpiByte$write(addr);
  CC2420SpiImplP$SpiByte$write(data >> 8);
  return CC2420SpiImplP$SpiByte$write(data & 0xff);
}

# 129 "/opt/tinyos-2.x/tos/chips/atm128/spi/Atm128SpiP.nc"
static   uint8_t Atm128SpiP$SpiByte$write(uint8_t tx)
#line 129
{
  Atm128SpiP$Spi$enableSpi(TRUE);
  Atm128SpiP$McuPowerState$update();
  Atm128SpiP$Spi$write(tx);
  while (!(* (volatile uint8_t *)(0x0E + 0x20) & 0x80)) ;
  return Atm128SpiP$Spi$read();
}

#line 240
static   error_t Atm128SpiP$SpiPacket$send(uint8_t *writeBuf, 
uint8_t *readBuf, 
uint16_t bufLen)
#line 242
{
  uint8_t discard;

#line 244
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 244
    {
      Atm128SpiP$txBuffer = writeBuf;
      Atm128SpiP$rxBuffer = readBuf;
      Atm128SpiP$len = bufLen;
      Atm128SpiP$pos = 0;
    }
#line 249
    __nesc_atomic_end(__nesc_atomic); }
  if (bufLen > 0) {
      discard = Atm128SpiP$Spi$read();
      return Atm128SpiP$sendNextPart();
    }
  else {
      Atm128SpiP$zeroTask$postTask();
      return SUCCESS;
    }
}

#line 164
static error_t Atm128SpiP$sendNextPart(void)
#line 164
{
  uint16_t end;
  uint16_t tmpPos;
  uint8_t *tx;
  uint8_t *rx;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 170
    {
      tx = Atm128SpiP$txBuffer;
      rx = Atm128SpiP$rxBuffer;
      tmpPos = Atm128SpiP$pos;
      end = Atm128SpiP$pos + Atm128SpiP$SPI_ATOMIC_SIZE;
      end = end > Atm128SpiP$len ? Atm128SpiP$len : end;
    }
#line 176
    __nesc_atomic_end(__nesc_atomic); }

  for (; tmpPos < end - 1; tmpPos++) {
      uint8_t val;

#line 180
      if (tx != (void *)0) {
        val = Atm128SpiP$SpiByte$write(tx[tmpPos]);
        }
      else {
#line 183
        val = Atm128SpiP$SpiByte$write(0);
        }
      if (rx != (void *)0) {
          rx[tmpPos] = val;
        }
    }



  Atm128SpiP$Spi$enableInterrupt(TRUE);
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 193
    {
      if (tx != (void *)0) {
        Atm128SpiP$Spi$write(tx[tmpPos]);
        }
      else {
#line 197
        Atm128SpiP$Spi$write(0);
        }
      Atm128SpiP$pos = tmpPos;
    }
#line 200
    __nesc_atomic_end(__nesc_atomic); }


  return SUCCESS;
}

# 432 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static  uint8_t LinkEstimatorP$LinkEstimator$getLinkQuality(am_addr_t neighbor)
#line 432
{
  uint8_t idx;

#line 434
  idx = LinkEstimatorP$findIdx(neighbor);
  if (idx == LinkEstimatorP$INVALID_RVAL) {
      return LinkEstimatorP$INFINITY;
    }
  else 
#line 437
    {
      return LinkEstimatorP$NeighborTable[idx].eetx;
    }
#line 439
  ;
}

#line 166
static uint8_t LinkEstimatorP$findIdx(am_addr_t ll_addr)
#line 166
{
  uint8_t i;

#line 168
  for (i = 0; i < 10; i++) {
      if (LinkEstimatorP$NeighborTable[i].flags & VALID_ENTRY) {
          if (LinkEstimatorP$NeighborTable[i].ll_addr == ll_addr) {
              return i;
            }
        }
    }
  return LinkEstimatorP$INVALID_RVAL;
}

# 168 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static void /*CtpP.Router*/CtpRoutingEngineP$0$chooseAdvertiseTime(void)
#line 168
{
  /*CtpP.Router*/CtpRoutingEngineP$0$t = /*CtpP.Router*/CtpRoutingEngineP$0$currentInterval;
  /*CtpP.Router*/CtpRoutingEngineP$0$t *= 512;
  /*CtpP.Router*/CtpRoutingEngineP$0$t += /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand32() % /*CtpP.Router*/CtpRoutingEngineP$0$t;
  /*CtpP.Router*/CtpRoutingEngineP$0$tHasPassed = FALSE;
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$stop();
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(/*CtpP.Router*/CtpRoutingEngineP$0$t);
}

# 58 "/opt/tinyos-2.x/tos/system/RandomMlcgP.nc"
static   uint32_t RandomMlcgP$Random$rand32(void)
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
      tmpseed = (uint64_t )33614U * (uint64_t )RandomMlcgP$seed;
      q = tmpseed;
      q = q >> 1;
      p = tmpseed >> 32;
      mlcg = p + q;
      if (mlcg & 0x80000000) {
          mlcg = mlcg & 0x7FFFFFFF;
          mlcg++;
        }
      RandomMlcgP$seed = mlcg;
    }
#line 73
    __nesc_atomic_end(__nesc_atomic); }
  return mlcg;
}

# 132 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(uint8_t num, uint32_t t0, uint32_t dt, bool isoneshot)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer_t *timer = &/*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$m_timers[num];

#line 135
  timer->t0 = t0;
  timer->dt = dt;
  timer->isoneshot = isoneshot;
  timer->isrunning = TRUE;
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

# 151 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static   uint32_t /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$get(void)
#line 151
{
  uint32_t now;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {


      uint8_t now8 = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get();

      if (/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$getInterruptFlag().bits.ocf0) {


        now = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base + /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$get() + 1 + /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get();
        }
      else {

        now = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base + now8;
        }
    }
#line 169
    __nesc_atomic_end(__nesc_atomic); }
#line 169
  return now;
}

# 494 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static  error_t LinkEstimatorP$LinkEstimator$pinNeighbor(am_addr_t neighbor)
#line 494
{
  uint8_t nidx = LinkEstimatorP$findIdx(neighbor);

#line 496
  if (nidx == LinkEstimatorP$INVALID_RVAL) {
      return FAIL;
    }
  LinkEstimatorP$NeighborTable[nidx].flags |= PINNED_ENTRY;
  return SUCCESS;
}

# 839 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpCongestion$isCongested(void)
#line 839
{


  bool congested = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$size() > /*CtpP.Forwarder*/CtpForwardingEngineP$0$congestionThreshold ? 
  TRUE : FALSE;

#line 844
  return congested || /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientCongested ? TRUE : FALSE;
}

# 726 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static  void *LinkEstimatorP$Packet$getPayload(message_t *msg, uint8_t *len)
#line 726
{
  uint8_t *payload = LinkEstimatorP$SubPacket$getPayload(msg, len);
  linkest_header_t *hdr;

#line 729
  hdr = LinkEstimatorP$getHeader(msg);
  if (len != (void *)0) {
      *len = *len - sizeof(linkest_header_t ) - sizeof(linkest_footer_t ) * (NUM_ENTRIES_FLAG & __nesc_ntoh_uint8((unsigned char *)&hdr->flags));
    }
  return payload + sizeof(linkest_header_t );
}

#line 396
static void LinkEstimatorP$print_packet(message_t *msg, uint8_t len)
#line 396
{
  uint8_t i;
  uint8_t *b;

  b = (uint8_t *)msg->data;
  for (i = 0; i < len; i++) 
    ;
  ;
}

# 207 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static   void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$default$sendDone(uint8_t id, message_t *msg, error_t err)
#line 207
{
}

# 89 "/opt/tinyos-2.x/tos/interfaces/Send.nc"
static  void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$sendDone(uint8_t arg_0x7e48a1e0, message_t *arg_0x7eb54010, error_t arg_0x7eb54198){
#line 89
  switch (arg_0x7e48a1e0) {
#line 89
    case 0U:
#line 89
      /*CtpP.AMSenderC.AMQueueEntryP*/AMQueueEntryP$1$Send$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    case 1U:
#line 89
      /*CtpP.SendControl.AMQueueEntryP*/AMQueueEntryP$2$Send$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    case 2U:
#line 89
      /*DisseminationEngineP.DisseminationSendC.AMQueueEntryP*/AMQueueEntryP$3$Send$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    case 3U:
#line 89
      /*DisseminationEngineP.DisseminationProbeSendC.AMQueueEntryP*/AMQueueEntryP$4$Send$sendDone(arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    default:
#line 89
      /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Send$default$sendDone(arg_0x7e48a1e0, arg_0x7eb54010, arg_0x7eb54198);
#line 89
      break;
#line 89
    }
#line 89
}
#line 89
# 541 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubSend$sendDone(message_t *msg, error_t error)
#line 541
{
  fe_queue_entry_t *qe = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$head();

#line 543
  ;
  if (qe == (void *)0 || qe->msg != msg) {
      ;
      /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendDoneBug();
      return;
    }
  else {
#line 549
    if (error != SUCCESS) {

        ;
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_SENDDONE_FAIL, 
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
        /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(SENDDONE_FAIL_WINDOW, SENDDONE_FAIL_OFFSET);
      }
    else {
#line 558
      if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$ackPending && !/*CtpP.Forwarder*/CtpForwardingEngineP$0$PacketAcknowledgements$wasAcked(msg)) {

          /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txNoAck(/*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
          /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpInfo$recomputeRoutes();
          if (-- qe->retries) {
              ;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_SENDDONE_WAITACK, 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(SENDDONE_NOACK_WINDOW, SENDDONE_NOACK_OFFSET);
            }
          else 
#line 569
            {

              if (qe->client < /*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT) {
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[qe->client] = qe;
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$sendDone(qe->client, msg, FAIL);
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_SEND, 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
                }
              else 
#line 578
                {
                  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$put(qe->msg) != SUCCESS) {
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_MSGPOOL_ERR);
                    }
#line 581
                  if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$put(qe) != SUCCESS) {
                    /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_QEPOOL_ERR);
                    }
#line 583
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_SENDDONE_FAIL_ACK_FWD, 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
                  /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
                }
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue();
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = FALSE;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
            }
        }
      else {
#line 593
        if (qe->client < /*CtpP.Forwarder*/CtpForwardingEngineP$0$CLIENT_COUNT) {
            ctp_data_header_t *hdr;
            uint8_t client = qe->client;

#line 596
            ;

            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_SENT_MSG, 
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txAck(/*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$clientPtrs[client] = qe;
            hdr = /*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(qe->msg);
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue();
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$Send$sendDone(client, msg, SUCCESS);
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = FALSE;
            /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
          }
        else {
#line 610
          if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$size() < /*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$maxSize()) {

              ;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEventMsg(NET_C_FE_FWD_MSG, 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getSequenceNumber(msg), 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(msg), 
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$LinkEstimator$txAck(/*CtpP.Forwarder*/CtpForwardingEngineP$0$AMPacket$destination(msg));
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$SentCache$insert(qe->msg);
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$SendQueue$dequeue();
              if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$MessagePool$put(qe->msg) != SUCCESS) {
                /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_MSGPOOL_ERR);
                }
#line 622
              if (/*CtpP.Forwarder*/CtpForwardingEngineP$0$QEntryPool$put(qe) != SUCCESS) {
                /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionDebug$logEvent(NET_C_FE_PUT_QEPOOL_ERR);
                }
#line 624
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$sending = FALSE;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(SENDDONE_OK_WINDOW, SENDDONE_OK_OFFSET);
            }
          else {
              ;
              /*CtpP.Forwarder*/CtpForwardingEngineP$0$sendDoneBug();
            }
          }
        }
      }
    }
}

#line 881
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CollectionPacket$getOrigin(message_t *msg)
#line 881
{
#line 881
  return __nesc_ntoh_uint16((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->origin);
}

#line 958
static void /*CtpP.Forwarder*/CtpForwardingEngineP$0$startRetxmitTimer(uint16_t mask, uint16_t offset)
#line 958
{
  uint16_t r = /*CtpP.Forwarder*/CtpForwardingEngineP$0$Random$rand16();

#line 960
  r &= mask;
  r += offset;
  /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$startOneShot(r);
  ;
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/Timer.nc"
static  void /*CtpP.Forwarder*/CtpForwardingEngineP$0$RetxmitTimer$startOneShot(uint32_t arg_0x7eb11338){
#line 62
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startOneShot(5U, arg_0x7eb11338);
#line 62
}
#line 62
# 244 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static void LinkEstimatorP$updateDEETX(neighbor_table_entry_t *ne)
#line 244
{
  uint16_t estETX;

  if (ne->data_success == 0) {



      estETX = (ne->data_total - 1) * 10;
    }
  else 
#line 252
    {
      estETX = 10 * ne->data_total / ne->data_success - 10;
      ne->data_success = 0;
      ne->data_total = 0;
    }
  LinkEstimatorP$updateEETX(ne, estETX);
}

#line 238
static void LinkEstimatorP$updateEETX(neighbor_table_entry_t *ne, uint16_t newEst)
#line 238
{
  ne->eetx = (LinkEstimatorP$ALPHA * ne->eetx + (10 - LinkEstimatorP$ALPHA) * newEst) / 10;
}

# 271 "OctopusC.nc"
static  void OctopusC$CollectSend$sendDone(message_t *msg, error_t error)
#line 271
{
  if (error != SUCCESS) {
    OctopusC$reportProblem();
    }
#line 274
  OctopusC$sendBusy = FALSE;
  __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, NO_REPLY);
  OctopusC$reportSent();
}

# 48 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128GeneralIOPinP.nc"
static   void /*HplAtm128GeneralIOC.PortA.Bit2*/HplAtm128GeneralIOPinP$2$IO$toggle(void)
#line 48
{
#line 48
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 48
    * (volatile uint8_t *)59U ^= 1 << 2;
#line 48
    __nesc_atomic_end(__nesc_atomic); }
}

#line 48
static   void /*HplAtm128GeneralIOC.PortA.Bit1*/HplAtm128GeneralIOPinP$1$IO$toggle(void)
#line 48
{
#line 48
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 48
    * (volatile uint8_t *)59U ^= 1 << 1;
#line 48
    __nesc_atomic_end(__nesc_atomic); }
}

# 100 "/opt/tinyos-2.x/tos/system/PoolP.nc"
static  error_t /*CtpP.MessagePoolP.PoolP*/PoolP$0$Pool$put(/*CtpP.MessagePoolP.PoolP*/PoolP$0$pool_t *newVal)
#line 100
{
  if (/*CtpP.MessagePoolP.PoolP*/PoolP$0$free >= 12) {
      return FAIL;
    }
  else {
      uint8_t emptyIndex = /*CtpP.MessagePoolP.PoolP*/PoolP$0$index + /*CtpP.MessagePoolP.PoolP*/PoolP$0$free;

#line 106
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$queue[emptyIndex] = newVal;
      /*CtpP.MessagePoolP.PoolP*/PoolP$0$free++;
      return SUCCESS;
    }
}

#line 100
static  error_t /*CtpP.QEntryPoolP.PoolP*/PoolP$1$Pool$put(/*CtpP.QEntryPoolP.PoolP*/PoolP$1$pool_t *newVal)
#line 100
{
  if (/*CtpP.QEntryPoolP.PoolP*/PoolP$1$free >= 12) {
      return FAIL;
    }
  else {
      uint8_t emptyIndex = /*CtpP.QEntryPoolP.PoolP*/PoolP$1$index + /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free;

#line 106
      if (emptyIndex >= 12) {
          emptyIndex -= 12;
        }
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$queue[emptyIndex] = newVal;
      /*CtpP.QEntryPoolP.PoolP*/PoolP$1$free++;
      return SUCCESS;
    }
}

# 85 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static  /*CtpP.SendQueueP*/QueueC$0$queue_t /*CtpP.SendQueueP*/QueueC$0$Queue$dequeue(void)
#line 85
{
  /*CtpP.SendQueueP*/QueueC$0$queue_t t = /*CtpP.SendQueueP*/QueueC$0$Queue$head();

#line 87
  ;
  if (!/*CtpP.SendQueueP*/QueueC$0$Queue$empty()) {
      /*CtpP.SendQueueP*/QueueC$0$head++;
      /*CtpP.SendQueueP*/QueueC$0$head %= 13;
      /*CtpP.SendQueueP*/QueueC$0$size--;
      /*CtpP.SendQueueP*/QueueC$0$printQueue();
    }
  return t;
}

# 516 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static  error_t LinkEstimatorP$LinkEstimator$txAck(am_addr_t neighbor)
#line 516
{
  neighbor_table_entry_t *ne;
  uint8_t nidx = LinkEstimatorP$findIdx(neighbor);

#line 519
  if (nidx == LinkEstimatorP$INVALID_RVAL) {
      return FAIL;
    }
  ne = &LinkEstimatorP$NeighborTable[nidx];
  ne->data_success++;
  ne->data_total++;
  if (ne->data_total >= LinkEstimatorP$DLQ_PKT_WINDOW) {
      LinkEstimatorP$updateDEETX(ne);
    }
  return SUCCESS;
}

# 84 "/opt/tinyos-2.x/tos/lib/net/ctp/LruCtpMsgCacheP.nc"
static uint8_t /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$lookup(message_t *m)
#line 84
{
  uint8_t i;
  uint8_t idx;

#line 87
  for (i = 0; i < /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$count; i++) {
      idx = (i + /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$first) % 4;


      if (
#line 89
      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getOrigin(m) == /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[idx].origin && 
      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getSequenceNumber(m) == /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[idx].seqno && 
      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getThl(m) == /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[idx].thl && 
      /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$CtpPacket$getType(m) == /*CtpP.SentCacheP.CacheP*/LruCtpMsgCacheP$0$cache[idx].type) {
          break;
        }
    }
  return i;
}

# 892 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static  am_addr_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getOrigin(message_t *msg)
#line 892
{
#line 892
  return __nesc_ntoh_uint16((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->origin);
}

#line 894
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getSequenceNumber(message_t *msg)
#line 894
{
#line 894
  return __nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->originSeqNo);
}

#line 895
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getThl(message_t *msg)
#line 895
{
#line 895
  return __nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->thl);
}

#line 891
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$getType(message_t *msg)
#line 891
{
#line 891
  return __nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->type);
}

# 166 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static void /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$tryToSend(void)
#line 166
{
  /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$nextPacket();
  if (/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current < 4) {
      error_t nextErr;
      message_t *nextMsg = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$queue[/*AMQueueP.AMQueueImplP*/AMQueueImplP$1$current].msg;
      am_id_t nextId = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$type(nextMsg);
      am_addr_t nextDest = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMPacket$destination(nextMsg);
      uint8_t len = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$Packet$payloadLength(nextMsg);

#line 174
      nextErr = /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$AMSend$send(nextId, nextDest, nextMsg, len);
      if (nextErr != SUCCESS) {
          /*AMQueueP.AMQueueImplP*/AMQueueImplP$1$errorTask$postTask();
        }
    }
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$payloadLength(message_t *arg_0x7e7c7ee0){
#line 67
  unsigned char result;
#line 67

#line 67
  result = CC2420ActiveMessageP$Packet$payloadLength(arg_0x7e7c7ee0);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 660 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static uint8_t /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(am_addr_t neighbor)
#line 660
{
  uint8_t i;

#line 662
  if (neighbor == INVALID_ADDR) {
    return /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive;
    }
#line 664
  for (i = 0; i < /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive; i++) {
      if (/*CtpP.Router*/CtpRoutingEngineP$0$routingTable[i].neighbor == neighbor) {
        break;
        }
    }
#line 668
  return i;
}

# 370 "OctopusC.nc"
static  message_t *OctopusC$CollectReceive$receive(message_t *msg, void *payload, uint8_t len)
#line 370
{
  octopus_collected_msg_t *collectedMsg = payload;

  if (len == sizeof(octopus_collected_msg_t ) && !OctopusC$fwdBusy) {


      octopus_collected_msg_t *fwdCollectedMsg = OctopusC$SerialSend$getPayload(&OctopusC$fwdMsg);

      *fwdCollectedMsg = *collectedMsg;
      if (OctopusC$SerialSend$send(AM_BROADCAST_ADDR, &OctopusC$fwdMsg, sizeof  (*collectedMsg)) == SUCCESS) {
        OctopusC$fwdBusy = TRUE;
        }
#line 381
      OctopusC$reportReceived();
    }
  return msg;
}

# 123 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static  void */*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$getPayload(message_t *msg, uint8_t *len)
#line 123
{
  if (len != (void *)0) {
      *len = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$Packet$payloadLength(msg);
    }
  return msg->data;
}

# 45 "/opt/tinyos-2.x/tos/system/AMQueueEntryP.nc"
static  error_t /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMSend$send(am_addr_t dest, 
message_t *msg, 
uint8_t len)
#line 47
{
  /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setDestination(msg, dest);
  /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$AMPacket$setType(msg, 147);
  return /*OctopusAppC.SerialCollectSender.AMQueueEntryP*/AMQueueEntryP$0$Send$send(msg, len);
}

# 158 "/opt/tinyos-2.x/tos/lib/serial/SerialActiveMessageP.nc"
static  am_id_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$type(message_t *amsg)
#line 158
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 160
  return __nesc_ntoh_uint8((unsigned char *)&header->type);
}

#line 134
static  am_addr_t /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$AMPacket$destination(message_t *amsg)
#line 134
{
  serial_header_t *header = /*SerialActiveMessageC.AM*/SerialActiveMessageP$0$getHeader(amsg);

#line 136
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

# 502 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 873 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static  void */*CtpP.Forwarder*/CtpForwardingEngineP$0$Packet$getPayload(message_t *msg, uint8_t *len)
#line 873
{
  uint8_t *payload = /*CtpP.Forwarder*/CtpForwardingEngineP$0$SubPacket$getPayload(msg, len);

#line 875
  if (len != (void *)0) {
      *len -= sizeof(ctp_data_header_t );
    }
  return payload + sizeof(ctp_data_header_t );
}

# 543 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static  error_t /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$getEtx(uint16_t *etx)
#line 543
{
  if (etx == (void *)0) {
    return FAIL;
    }
#line 546
  if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == INVALID_ADDR) {
    return FAIL;
    }
#line 548
  *etx = /*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.etx;
  return SUCCESS;
}

# 99 "/opt/tinyos-2.x/tos/lib/net/DisseminatorP.nc"
static  void /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationCache$storeData(void *data, uint8_t size, 
uint32_t newSeqno)
#line 100
{
  memcpy(&/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$valueCache, data, size < sizeof(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t ) ? size : sizeof(/*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$t ));
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$seqno = newSeqno;
  /*OctopusAppC.DisseminatorC.DisseminatorP*/DisseminatorP$0$DisseminationValue$changed();
}

# 138 "OctopusC.nc"
static void OctopusC$processRequest(octopus_sent_msg_t *newRequest)
#line 138
{
  unsigned char *__nesc_temp43;
  unsigned char *__nesc_temp42;

#line 139
  if (__nesc_ntoh_uint16((unsigned char *)&newRequest->targetId) == TOS_NODE_ID || __nesc_ntoh_uint16((unsigned char *)&newRequest->targetId) == 0xFFFF) {
      switch (__nesc_ntoh_uint8((unsigned char *)&newRequest->request)) {
          case SET_MODE_AUTO_REQUEST: 
            OctopusC$modeAuto = TRUE;
          OctopusC$Timer$stop();
          OctopusC$Timer$startPeriodic(OctopusC$samplingPeriod);
          break;
          case SET_MODE_QUERY_REQUEST: 
            OctopusC$modeAuto = FALSE;
          OctopusC$Timer$stop();
          break;
          case SET_PERIOD_REQUEST: 
            OctopusC$samplingPeriod = __nesc_ntoh_uint16((unsigned char *)&newRequest->parameters);
          OctopusC$Timer$stop();
          if (OctopusC$sleeping == FALSE) {
            OctopusC$Timer$startPeriodic(OctopusC$samplingPeriod);
            }
#line 155
          break;
          case SET_THRESHOLD_REQUEST: 
            OctopusC$threshold = __nesc_ntoh_uint16((unsigned char *)&newRequest->parameters);
          break;
          case GET_STATUS_REQUEST: 
            if (OctopusC$modeAuto) {
              __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, BATTERY_AND_MODE_REPLY | MODE_AUTO);
              }
            else {
#line 163
              __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, BATTERY_AND_MODE_REPLY | MODE_QUERY);
              }
#line 164
          if (OctopusC$sleeping) {
            (__nesc_temp42 = (unsigned char *)&OctopusC$localCollectedMsg.reply, __nesc_hton_uint8(__nesc_temp42, __nesc_ntoh_uint8(__nesc_temp42) | SLEEPING));
            }
          else {
#line 167
            (__nesc_temp43 = (unsigned char *)&OctopusC$localCollectedMsg.reply, __nesc_hton_uint8(__nesc_temp43, __nesc_ntoh_uint8(__nesc_temp43) | AWAKE));
            }
#line 168
          __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, OctopusC$battery);
          OctopusC$fillPacket();
          if (!OctopusC$root) {
#line 170
            OctopusC$collectSendTask$postTask();
            }
          else {
#line 170
            OctopusC$serialSendTask$postTask();
            }
#line 171
          break;
          case GET_PERIOD_REQUEST: 
            if (OctopusC$sleeping == FALSE) {
                __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, PERIOD_REPLY);
                __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, OctopusC$samplingPeriod);
                OctopusC$fillPacket();
                if (!OctopusC$root) {
#line 177
                  OctopusC$collectSendTask$postTask();
                  }
                else {
#line 177
                  OctopusC$serialSendTask$postTask();
                  }
              }
#line 179
          break;
          case GET_THRESHOLD_REQUEST: 
            if (OctopusC$sleeping == FALSE) {
                __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, THRESHOLD_REPLY);
                __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, OctopusC$threshold);
                OctopusC$fillPacket();
                if (!OctopusC$root) {
#line 185
                  OctopusC$collectSendTask$postTask();
                  }
                else {
#line 185
                  OctopusC$serialSendTask$postTask();
                  }
              }
#line 187
          break;
          case GET_READING_REQUEST: 
            OctopusC$Read$read();
          break;
          case SLEEP_REQUEST: 
            if (!OctopusC$root) {
                OctopusC$sleeping = TRUE;
                OctopusC$setLocalDutyCycle();
                OctopusC$Timer$stop();
              }
          break;
          case WAKE_UP_REQUEST: 
            if (!OctopusC$root) {
                OctopusC$sleeping = FALSE;
                OctopusC$setLocalDutyCycle();
                if (OctopusC$modeAuto) {
                  OctopusC$Timer$startPeriodic(OctopusC$samplingPeriod);
                  }
              }
#line 205
          break;
          case GET_SLEEP_DUTY_CYCLE_REQUEST: 
            __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, SLEEP_DUTY_CYCLE_REPLY);
          __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, OctopusC$sleepDutyCycle);
          OctopusC$fillPacket();
          if (!OctopusC$root) {
#line 210
            OctopusC$collectSendTask$postTask();
            }
          else {
#line 210
            OctopusC$serialSendTask$postTask();
            }
#line 211
          break;
          case SET_SLEEP_DUTY_CYCLE_REQUEST: 
            OctopusC$sleepDutyCycle = __nesc_ntoh_uint16((unsigned char *)&newRequest->parameters);
          OctopusC$setLocalDutyCycle();
          break;
          case SET_AWAKE_DUTY_CYCLE_REQUEST: 
            OctopusC$awakeDutyCycle = __nesc_ntoh_uint16((unsigned char *)&newRequest->parameters);
          OctopusC$setLocalDutyCycle();
          break;
          case GET_AWAKE_DUTY_CYCLE_REQUEST: 
            __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, AWAKE_DUTY_CYCLE_REPLY);
          __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.reading, OctopusC$awakeDutyCycle);
          OctopusC$fillPacket();
          if (!OctopusC$root) {
#line 224
            OctopusC$collectSendTask$postTask();
            }
          else {
#line 224
            OctopusC$serialSendTask$postTask();
            }
#line 225
          break;
        }
    }
}

# 142 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
static  void /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$Timer$startPeriodic(uint8_t num, uint32_t dt)
{
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$startTimer(num, /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$TimerFrom$getNow(), dt, FALSE);
}

# 295 "OctopusC.nc"
static void OctopusC$fillPacket(void)
#line 295
{
  uint16_t tmp;

  OctopusC$CollectInfo$getEtx(&tmp);



  __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.quality, tmp);
  OctopusC$CollectInfo$getParent(&tmp);
  __nesc_hton_uint16((unsigned char *)&OctopusC$localCollectedMsg.parentId, tmp);
}

#line 394
static void OctopusC$setLocalDutyCycle(void)
#line 394
{
  if (OctopusC$sleeping) {
    OctopusC$LowPowerListening$setLocalDutyCycle(OctopusC$sleepDutyCycle);
    }
  else {
#line 398
    OctopusC$LowPowerListening$setLocalDutyCycle(OctopusC$awakeDutyCycle);
    }
}

# 122 "/opt/tinyos-2.x/tos/lib/net/TrickleTimerImplP.nc"
static  void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$TrickleTimer$reset(uint8_t id)
#line 122
{
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period = 1;
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].count = 0;
  if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time != 0) {
      ;
      { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 127
        {
          /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$set(id);
        }
#line 129
        __nesc_atomic_end(__nesc_atomic); }
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time = 0;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].remainder = 0;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(id);
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer();
    }
  else 
#line 134
    {
      ;
    }
}

#line 246
static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$generateTime(uint8_t id)
#line 246
{
  uint32_t time;
  uint16_t rval;

  if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time != 0) {
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period *= 2;
      if (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period > 1024) {
          /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period = 1024;
        }
    }

  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].remainder;

  time = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period;
  time = time << (10 - 1);

  rval = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Random$rand16() % (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period << (10 - 1));
  time += rval;

  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].remainder = (/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].period << 10) - time;
  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[id].time += time;
  ;
}

#line 203
static void /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$adjustTimer(void)
#line 203
{
  uint8_t i;
  uint32_t lowest = 0;
  bool set = FALSE;





  uint32_t elapsed = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$getNow() - /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$gett0();

  for (i = 0; i < 1U; i++) {
      uint32_t time = /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$trickles[i].time;

#line 216
      if (time != 0) {
          { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 217
            {
              if (!/*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$get(i)) {
                  /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Changed$clear(i);
                  time -= elapsed;
                }
            }
#line 222
            __nesc_atomic_end(__nesc_atomic); }
          if (!set) {
              lowest = time;
              set = TRUE;
            }
          else {
#line 227
            if (time < lowest) {
                lowest = time;
              }
            }
        }
    }
#line 232
  if (set) {
      uint32_t timerVal = lowest;

#line 234
      timerVal = timerVal;
      ;
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$startOneShot(timerVal);
    }
  else {
      /*DisseminationTimerP.TrickleTimerMilliC.TrickleTimerImplP*/TrickleTimerImplP$0$Timer$stop();
    }
}

# 122 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ActiveMessageP.nc"
static  am_addr_t CC2420ActiveMessageP$AMPacket$source(message_t *amsg)
#line 122
{
  cc2420_header_t *header = CC2420ActiveMessageP$CC2420Packet$getHeader(amsg);

#line 124
  return __nesc_ntoh_leuint16((unsigned char *)&header->src);
}

# 382 "/opt/tinyos-2.x/tos/lib/net/le/LinkEstimatorP.nc"
static void LinkEstimatorP$print_neighbor_table(void)
#line 382
{
  uint8_t i;
  neighbor_table_entry_t *ne;

#line 385
  for (i = 0; i < 10; i++) {
      ne = &LinkEstimatorP$NeighborTable[i];
      if (ne->flags & VALID_ENTRY) {
          ;
        }
    }
}

#line 347
static void LinkEstimatorP$updateNeighborEntryIdx(uint8_t idx, uint8_t seq)
#line 347
{
  uint8_t packetGap;

  if (LinkEstimatorP$NeighborTable[idx].flags & INIT_ENTRY) {
      ;
      LinkEstimatorP$NeighborTable[idx].lastseq = seq;
      LinkEstimatorP$NeighborTable[idx].flags &= ~INIT_ENTRY;
    }

  packetGap = seq - LinkEstimatorP$NeighborTable[idx].lastseq;
  ;

  LinkEstimatorP$NeighborTable[idx].lastseq = seq;
  LinkEstimatorP$NeighborTable[idx].rcvcnt++;
  LinkEstimatorP$NeighborTable[idx].inage = LinkEstimatorP$MAX_AGE;
  if (packetGap > 0) {
      LinkEstimatorP$NeighborTable[idx].failcnt += packetGap - 1;
    }
  if (packetGap > LinkEstimatorP$MAX_PKT_GAP) {
      LinkEstimatorP$NeighborTable[idx].failcnt = 0;
      LinkEstimatorP$NeighborTable[idx].rcvcnt = 1;
      LinkEstimatorP$NeighborTable[idx].outage = 0;
      LinkEstimatorP$NeighborTable[idx].outquality = 0;
      LinkEstimatorP$NeighborTable[idx].inquality = 0;
    }

  if (LinkEstimatorP$NeighborTable[idx].rcvcnt >= LinkEstimatorP$BLQ_PKT_WINDOW) {
      LinkEstimatorP$updateNeighborTableEst(LinkEstimatorP$NeighborTable[idx].ll_addr);
    }
}

#line 179
static uint8_t LinkEstimatorP$findEmptyNeighborIdx(void)
#line 179
{
  uint8_t i;

#line 181
  for (i = 0; i < 10; i++) {
      if (LinkEstimatorP$NeighborTable[i].flags & VALID_ENTRY) {
        }
      else 
#line 183
        {
          return i;
        }
    }
  return LinkEstimatorP$INVALID_RVAL;
}

#line 150
static void LinkEstimatorP$initNeighborIdx(uint8_t i, am_addr_t ll_addr)
#line 150
{
  neighbor_table_entry_t *ne;

#line 152
  ne = &LinkEstimatorP$NeighborTable[i];
  ne->ll_addr = ll_addr;
  ne->lastseq = 0;
  ne->rcvcnt = 0;
  ne->failcnt = 0;
  ne->flags = INIT_ENTRY | VALID_ENTRY;
  ne->inage = LinkEstimatorP$MAX_AGE;
  ne->outage = LinkEstimatorP$MAX_AGE;
  ne->inquality = 0;
  ne->outquality = 0;
  ne->eetx = 0;
}

#line 192
static uint8_t LinkEstimatorP$findWorstNeighborIdx(uint8_t thresholdEETX)
#line 192
{
  uint8_t i;
#line 193
  uint8_t worstNeighborIdx;
  uint16_t worstEETX;
#line 194
  uint16_t thisEETX;

  worstNeighborIdx = LinkEstimatorP$INVALID_RVAL;
  worstEETX = 0;
  for (i = 0; i < 10; i++) {
      if (!(LinkEstimatorP$NeighborTable[i].flags & VALID_ENTRY)) {
          ;
          continue;
        }
      if (!(LinkEstimatorP$NeighborTable[i].flags & MATURE_ENTRY)) {
          ;
          continue;
        }
      if (LinkEstimatorP$NeighborTable[i].flags & PINNED_ENTRY) {
          ;
          continue;
        }
      thisEETX = LinkEstimatorP$NeighborTable[i].eetx;
      if (thisEETX >= worstEETX) {
          worstNeighborIdx = i;
          worstEETX = thisEETX;
        }
    }
  if (worstEETX >= thresholdEETX) {
      return worstNeighborIdx;
    }
  else 
#line 219
    {
      return LinkEstimatorP$INVALID_RVAL;
    }
}

# 514 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$LinkEstimator$evicted(am_addr_t neighbor)
#line 514
{
  /*CtpP.Router*/CtpRoutingEngineP$0$routingTableEvict(neighbor);
  ;
  if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == neighbor) {
      routeInfoInit(&/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo);
      /*CtpP.Router*/CtpRoutingEngineP$0$justEvicted = TRUE;
      /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
    }
}

# 67 "/opt/tinyos-2.x/tos/interfaces/Packet.nc"
static  uint8_t LinkEstimatorP$SubPacket$payloadLength(message_t *arg_0x7e7c7ee0){
#line 67
  unsigned char result;
#line 67

#line 67
  result = CC2420ActiveMessageP$Packet$payloadLength(arg_0x7e7c7ee0);
#line 67

#line 67
  return result;
#line 67
}
#line 67
# 748 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static  bool /*CtpP.Router*/CtpRoutingEngineP$0$CtpRoutingPacket$getOption(message_t *msg, ctp_options_t opt)
#line 748
{
  return (__nesc_ntoh_uint8((unsigned char *)&/*CtpP.Router*/CtpRoutingEngineP$0$getHeader(msg)->options) & opt) == opt ? TRUE : FALSE;
}

#line 577
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$setNeighborCongested(am_addr_t n, bool congested)
#line 577
{
  uint8_t idx;

#line 579
  if (/*CtpP.Router*/CtpRoutingEngineP$0$ECNOff) {
    return;
    }
#line 581
  idx = /*CtpP.Router*/CtpRoutingEngineP$0$routingTableFind(n);
  if (idx < /*CtpP.Router*/CtpRoutingEngineP$0$routingTableActive) {
      /*CtpP.Router*/CtpRoutingEngineP$0$routingTable[idx].info.congested = congested;
    }
  if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.congested && !congested) {
    /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
    }
  else {
#line 587
    if (/*CtpP.Router*/CtpRoutingEngineP$0$routeInfo.parent == n && congested) {
      /*CtpP.Router*/CtpRoutingEngineP$0$updateRouteTask$postTask();
      }
    }
}

# 97 "/opt/tinyos-2.x/tos/system/QueueC.nc"
static  error_t /*CtpP.SendQueueP*/QueueC$0$Queue$enqueue(/*CtpP.SendQueueP*/QueueC$0$queue_t newVal)
#line 97
{
  if (/*CtpP.SendQueueP*/QueueC$0$Queue$size() < /*CtpP.SendQueueP*/QueueC$0$Queue$maxSize()) {
      ;
      /*CtpP.SendQueueP*/QueueC$0$queue[/*CtpP.SendQueueP*/QueueC$0$tail] = newVal;
      /*CtpP.SendQueueP*/QueueC$0$tail++;
      /*CtpP.SendQueueP*/QueueC$0$tail %= 13;
      /*CtpP.SendQueueP*/QueueC$0$size++;
      /*CtpP.SendQueueP*/QueueC$0$printQueue();
      return SUCCESS;
    }
  else {
      return FAIL;
    }
}

# 568 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpRoutingEngineP.nc"
static  void /*CtpP.Router*/CtpRoutingEngineP$0$CtpInfo$triggerImmediateRouteUpdate(void)
#line 568
{

  uint16_t beaconDelay = /*CtpP.Router*/CtpRoutingEngineP$0$Random$rand16();

#line 571
  beaconDelay &= 0x7;
  beaconDelay += 4;
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$stop();
  /*CtpP.Router*/CtpRoutingEngineP$0$BeaconTimer$startOneShot(beaconDelay);
}

# 901 "/opt/tinyos-2.x/tos/lib/net/ctp/CtpForwardingEngineP.nc"
static  bool /*CtpP.Forwarder*/CtpForwardingEngineP$0$CtpPacket$option(message_t *msg, ctp_options_t opt)
#line 901
{
  return (__nesc_ntoh_uint8((unsigned char *)&/*CtpP.Forwarder*/CtpForwardingEngineP$0$getHeader(msg)->options) & opt) == opt ? TRUE : FALSE;
}

# 349 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static void CC2420ReceiveP$waitForNextPacket(void)
#line 349
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 350
    {
      if (CC2420ReceiveP$m_state == CC2420ReceiveP$S_STOPPED) {
          {
#line 352
            __nesc_atomic_end(__nesc_atomic); 
#line 352
            return;
          }
        }
      if ((CC2420ReceiveP$m_missed_packets && CC2420ReceiveP$FIFO$get()) || !CC2420ReceiveP$FIFOP$get()) {

          if (CC2420ReceiveP$m_missed_packets) {
              CC2420ReceiveP$m_missed_packets--;
            }

          CC2420ReceiveP$beginReceive();
        }
      else {

          CC2420ReceiveP$m_state = CC2420ReceiveP$S_STARTED;
          CC2420ReceiveP$m_missed_packets = 0;
        }
    }
#line 368
    __nesc_atomic_end(__nesc_atomic); }
}

#line 309
static void CC2420ReceiveP$beginReceive(void)
#line 309
{
  CC2420ReceiveP$m_state = CC2420ReceiveP$S_RX_HEADER;

  if (CC2420ReceiveP$SpiResource$immediateRequest() == SUCCESS) {
      CC2420ReceiveP$receive();
    }
  else 
#line 314
    {
      CC2420ReceiveP$SpiResource$request();
    }
}

#line 339
static void CC2420ReceiveP$receive(void)
#line 339
{
  CC2420ReceiveP$CSN$clr();
  CC2420ReceiveP$RXFIFO$beginRead((uint8_t *)CC2420ReceiveP$CC2420Packet$getHeader(CC2420ReceiveP$m_p_rx_buf), 1);
}

# 592 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static void CC2420TransmitP$attemptSend(void)
#line 592
{
  uint8_t status;
  bool congestion = TRUE;

  CC2420TransmitP$continuousModulation = FALSE;








  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 605
    {
      if (CC2420TransmitP$m_state == CC2420TransmitP$S_TX_CANCEL) {
          CC2420TransmitP$SFLUSHTX$strobe();
          CC2420TransmitP$releaseSpiResource();
          CC2420TransmitP$CSN$set();
          if (CC2420TransmitP$signalSendDone) {
              CC2420TransmitP$signalDone(ECANCEL);
            }
          else 
#line 612
            {
              CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
            }
          {
#line 615
            __nesc_atomic_end(__nesc_atomic); 
#line 615
            return;
          }
        }

      CC2420TransmitP$CSN$clr();

      if (CC2420TransmitP$continuousModulation) {
#line 635
          if (CC2420TransmitP$totalCcaChecks < 20) {
              if (CC2420TransmitP$CCA$get()) {

                  CC2420TransmitP$totalCcaChecks++;
                }
              else 
#line 639
                {

                  CC2420TransmitP$totalCcaChecks = 0;
                }

              CC2420TransmitP$CSN$set();
              CC2420TransmitP$releaseSpiResource();
              CC2420TransmitP$RadioBackoff$requestInitialBackoff(CC2420TransmitP$m_msg);
              CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myInitialBackoff);
              {
#line 648
                __nesc_atomic_end(__nesc_atomic); 
#line 648
                return;
              }
            }
          CC2420TransmitP$MDMCTRL1$write(2 << CC2420_MDMCTRL1_TX_MODE);
        }
      else 
#line 652
        {
          CC2420TransmitP$MDMCTRL1$write(0 << CC2420_MDMCTRL1_TX_MODE);
        }

      status = CC2420TransmitP$m_cca ? CC2420TransmitP$STXONCCA$strobe() : CC2420TransmitP$STXON$strobe();
      if (!(status & CC2420_STATUS_TX_ACTIVE)) {
          status = CC2420TransmitP$SNOP$strobe();
          if (status & CC2420_STATUS_TX_ACTIVE) {
              congestion = FALSE;

              if (CC2420TransmitP$continuousModulation) {
                  CC2420TransmitP$startLplTimer$postTask();
                }
            }
        }

      CC2420TransmitP$m_state = congestion ? CC2420TransmitP$S_SAMPLE_CCA : CC2420TransmitP$S_SFD;
      CC2420TransmitP$CSN$set();
    }
#line 670
    __nesc_atomic_end(__nesc_atomic); }

  if (congestion) {
      CC2420TransmitP$totalCcaChecks = 0;
      CC2420TransmitP$releaseSpiResource();
      CC2420TransmitP$congestionBackoff();
    }
  else 
#line 676
    {
      CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$CC2420_ABORT_PERIOD);
    }
}

# 264 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static   cc2420_status_t CC2420SpiImplP$Strobe$strobe(uint8_t addr)
#line 264
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 265
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 267
            0;

            {
#line 267
              __nesc_atomic_end(__nesc_atomic); 
#line 267
              return __nesc_temp;
            }
          }
        }
    }
#line 271
    __nesc_atomic_end(__nesc_atomic); }
#line 271
  return CC2420SpiImplP$SpiByte$write(addr);
}

#line 94
static   error_t CC2420SpiImplP$Resource$release(uint8_t id)
#line 94
{
  uint8_t i;

#line 96
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 96
    {
      if (CC2420SpiImplP$m_holder != id) {
          {
            unsigned char __nesc_temp = 
#line 98
            FAIL;

            {
#line 98
              __nesc_atomic_end(__nesc_atomic); 
#line 98
              return __nesc_temp;
            }
          }
        }
#line 101
      CC2420SpiImplP$m_holder = CC2420SpiImplP$NO_HOLDER;
      CC2420SpiImplP$SpiResource$release();
      if (!CC2420SpiImplP$m_requests) {
          CC2420SpiImplP$m_resource_busy = FALSE;
        }
      else 
#line 105
        {
          for (i = CC2420SpiImplP$m_holder + 1; ; i++) {
              if (i >= CC2420SpiImplP$RESOURCE_COUNT) {
                  i = 0;
                }

              if (CC2420SpiImplP$m_requests & (1 << i)) {
                  CC2420SpiImplP$m_holder = i;
                  CC2420SpiImplP$m_requests &= ~(1 << i);
                  CC2420SpiImplP$SpiResource$request();
                  {
                    unsigned char __nesc_temp = 
#line 115
                    SUCCESS;

                    {
#line 115
                      __nesc_atomic_end(__nesc_atomic); 
#line 115
                      return __nesc_temp;
                    }
                  }
                }
            }
        }
#line 119
      {
        unsigned char __nesc_temp = 
#line 119
        SUCCESS;

        {
#line 119
          __nesc_atomic_end(__nesc_atomic); 
#line 119
          return __nesc_temp;
        }
      }
    }
#line 122
    __nesc_atomic_end(__nesc_atomic); }
}

# 754 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static void CC2420TransmitP$signalDone(error_t err)
#line 754
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 755
    CC2420TransmitP$m_state = CC2420TransmitP$S_STARTED;
#line 755
    __nesc_atomic_end(__nesc_atomic); }
  CC2420TransmitP$Send$sendDone(CC2420TransmitP$m_msg, err);
}

# 213 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420CsmaP.nc"
static   void CC2420CsmaP$SubBackoff$requestInitialBackoff(message_t *msg)
#line 213
{
  CC2420CsmaP$SubBackoff$setInitialBackoff(CC2420CsmaP$Random$rand16()
   % (0x1F * CC2420_BACKOFF_PERIOD) + CC2420_MIN_BACKOFF);

  CC2420CsmaP$RadioBackoff$requestInitialBackoff(__nesc_ntoh_leuint8((unsigned char *)&((cc2420_header_t *)(msg->data - 
  sizeof(cc2420_header_t )))->type), msg);
}

# 136 "/opt/tinyos-2.x/tos/lib/timer/TransformAlarmC.nc"
static   void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Alarm$startAt(/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type t0, /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type dt)
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 = t0;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt = dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$set_alarm();
    }
#line 143
    __nesc_atomic_end(__nesc_atomic); }
}

#line 96
static void /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$set_alarm(void)
{
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type now = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$Counter$get();
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type expires;
#line 98
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type remaining;




  expires = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt;


  remaining = (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$to_size_type )(expires - now);


  if (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 <= now) 
    {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 && 
      expires <= now) {
        remaining = 0;
        }
    }
  else {
      if (expires >= /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 || 
      expires <= now) {
        remaining = 0;
        }
    }
#line 121
  if (remaining > /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$MAX_DELAY) 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 = now + /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$MAX_DELAY;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt = remaining - /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$MAX_DELAY;
      remaining = /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$MAX_DELAY;
    }
  else 
    {
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_t0 += /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt;
      /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$m_dt = 0;
    }
  /*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$AlarmFrom$startAt((/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_size_type )now << 0, 
  (/*AlarmMultiplexC.Alarm.Alarm32khz32C.Transform32*/TransformAlarmC$0$from_size_type )remaining << 0);
}

# 69 "/opt/tinyos-2.x/tos/lib/timer/TransformCounterC.nc"
static   /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type /*Counter32khz32C.Transform32*/TransformCounterC$1$Counter$get(void)
{
  /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type rv = 0;

#line 72
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*Counter32khz32C.Transform32*/TransformCounterC$1$upper_count_type high = /*Counter32khz32C.Transform32*/TransformCounterC$1$m_upper;
      /*Counter32khz32C.Transform32*/TransformCounterC$1$from_size_type low = /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$get();

#line 76
      if (/*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$isOverflowPending()) 
        {






          high++;
          low = /*Counter32khz32C.Transform32*/TransformCounterC$1$CounterFrom$get();
        }
      {
        /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type high_to = high;
        /*Counter32khz32C.Transform32*/TransformCounterC$1$to_size_type low_to = low >> /*Counter32khz32C.Transform32*/TransformCounterC$1$LOW_SHIFT_RIGHT;

#line 90
        rv = (high_to << /*Counter32khz32C.Transform32*/TransformCounterC$1$HIGH_SHIFT_LEFT) | low_to;
      }
    }
#line 92
    __nesc_atomic_end(__nesc_atomic); }
  return rv;
}

# 685 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420TransmitP.nc"
static void CC2420TransmitP$congestionBackoff(void)
#line 685
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 686
    {
      if (__nesc_ntoh_uint16((unsigned char *)&CC2420TransmitP$CC2420Packet$getMetadata(CC2420TransmitP$m_msg)->rxInterval) > 0) {
          CC2420TransmitP$RadioBackoff$requestLplBackoff(CC2420TransmitP$m_msg);
          CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myLplBackoff);
        }
      else {
          CC2420TransmitP$RadioBackoff$requestCongestionBackoff(CC2420TransmitP$m_msg);
          CC2420TransmitP$BackoffTimer$start(CC2420TransmitP$myCongestionBackoff);
        }
    }
#line 695
    __nesc_atomic_end(__nesc_atomic); }
}

# 210 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420SpiImplP.nc"
static   cc2420_status_t CC2420SpiImplP$Ram$write(uint16_t addr, uint8_t offset, 
uint8_t *data, 
uint8_t len)
#line 212
{

  cc2420_status_t status = 0;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 216
    {
      if (!CC2420SpiImplP$m_resource_busy) {
          {
            unsigned char __nesc_temp = 
#line 218
            status;

            {
#line 218
              __nesc_atomic_end(__nesc_atomic); 
#line 218
              return __nesc_temp;
            }
          }
        }
    }
#line 222
    __nesc_atomic_end(__nesc_atomic); }
#line 222
  addr += offset;

  CC2420SpiImplP$SpiByte$write(addr | 0x80);
  CC2420SpiImplP$SpiByte$write((addr >> 1) & 0xc0);
  for (; len; len--) 
    status = CC2420SpiImplP$SpiByte$write(* data++);

  return status;
}

#line 202
static   void CC2420SpiImplP$SpiPacket$sendDone(uint8_t *tx_buf, uint8_t *rx_buf, 
uint16_t len, error_t error)
#line 203
{
  if (CC2420SpiImplP$m_addr & 0x40) {
    CC2420SpiImplP$Fifo$readDone(CC2420SpiImplP$m_addr & ~0x40, rx_buf, len, error);
    }
  else {
#line 207
    CC2420SpiImplP$Fifo$writeDone(CC2420SpiImplP$m_addr, tx_buf, len, error);
    }
}

# 322 "/opt/tinyos-2.x/tos/chips/cc2420/CC2420ReceiveP.nc"
static void CC2420ReceiveP$flush(void)
#line 322
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

#line 374
static void CC2420ReceiveP$reset_state(void)
#line 374
{
  CC2420ReceiveP$m_bytes_left = CC2420ReceiveP$RXFIFO_SIZE;
  CC2420ReceiveP$m_timestamp_head = 0;
  CC2420ReceiveP$m_timestamp_size = 0;
  CC2420ReceiveP$m_missed_packets = 0;
}

# 42 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128GpioCaptureC.nc"
static error_t /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$enableCapture(uint8_t mode)
#line 42
{
  /* atomic removed: atomic calls only */
#line 43
  {
    /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$stop();
    /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$reset();
    /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$setEdge(mode);
    /*HplCC2420InterruptsC.CaptureSFDC*/Atm128GpioCaptureC$0$Atm128Capture$start();
  }
  return SUCCESS;
}

# 76 "OctopusC.nc"
static void OctopusC$fatalProblem(void)
#line 76
{
  OctopusC$Leds$led0On();
  OctopusC$Leds$led1On();
  OctopusC$Leds$led2On();
  OctopusC$Timer$stop();
}

#line 279
static  void OctopusC$SerialSend$sendDone(message_t *msg, error_t error)
#line 279
{
  if (error != SUCCESS) {
    OctopusC$reportProblem();
    }
#line 282
  if (msg == &OctopusC$fwdMsg) {
    OctopusC$fwdBusy = FALSE;
    }
  else {
#line 285
    OctopusC$uartBusy = FALSE;
    }
#line 286
  __nesc_hton_uint8((unsigned char *)&OctopusC$localCollectedMsg.reply, NO_REPLY);
  OctopusC$reportSent();
}

# 155 "/opt/tinyos-2.x/tos/system/AMQueueImplP.nc"
static void /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$sendDone(uint8_t last, message_t *msg, error_t err)
#line 155
{
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$queue[last].msg = (void *)0;
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$tryToSend();
  /*SerialAMQueueP.AMQueueImplP*/AMQueueImplP$0$Send$sendDone(last, msg, err);
}

# 347 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 86 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
static   error_t HdlcTranslateC$SerialFrameComm$putDelimiter(void)
#line 86
{
  HdlcTranslateC$state.sendEscape = 0;
  HdlcTranslateC$m_data = HDLC_FLAG_BYTE;
  return HdlcTranslateC$UartStream$send(&HdlcTranslateC$m_data, 1);
}

# 123 "/opt/tinyos-2.x/tos/chips/atm128/Atm128UartP.nc"
static   error_t /*Atm128Uart0C.UartP*/Atm128UartP$0$UartStream$send(uint8_t *buf, uint16_t len)
#line 123
{

  if (len == 0) {
    return FAIL;
    }
  else {
#line 127
    if (/*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf) {
      return EBUSY;
      }
    }
#line 130
  /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_buf = buf;
  /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_len = len;
  /*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_pos = 0;
  /*Atm128Uart0C.UartP*/Atm128UartP$0$HplUart$tx(buf[/*Atm128Uart0C.UartP*/Atm128UartP$0$m_tx_pos++]);

  return SUCCESS;
}

# 167 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
static   void HplAtm128UartP$HplUart0$tx(uint8_t data)
#line 167
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
#line 168
    {
      * (volatile uint8_t *)(0x0C + 0x20) = data;
      * (volatile uint8_t *)(0x0B + 0x20) |= 1 << 6;
    }
#line 171
    __nesc_atomic_end(__nesc_atomic); }
}

# 62 "/opt/tinyos-2.x/tos/lib/timer/VirtualizeTimerC.nc"
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
            }
        }
    }
  /*HilTimerMilliC.VirtualizeTimerC*/VirtualizeTimerC$0$updateFromTimer$postTask();
}

# 202 "/opt/tinyos-2.x/tos/chips/atm128/timer/Atm128AlarmAsyncP.nc"
static   void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$startAt(uint32_t nt0, uint32_t ndt)
#line 202
{
  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {
      /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$set = TRUE;
      /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$t0 = nt0;
      /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$dt = ndt;
    }
#line 208
    __nesc_atomic_end(__nesc_atomic); }
  /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt();
}

#line 90
static void /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setInterrupt(void)
#line 90
{
  bool fired = FALSE;

  { __nesc_atomic_t __nesc_atomic = __nesc_atomic_start();
    {



      uint8_t interrupt_in = 1 + /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Compare$get() - /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Timer$get();
      uint8_t newOcr0;

      if (interrupt_in < /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MINDT || /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$TimerCtrl$getInterruptFlag().bits.ocf0) {
        {
#line 102
          __nesc_atomic_end(__nesc_atomic); 
#line 102
          return;
        }
        }
      if (!/*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$set) {
        newOcr0 = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MAXT;
        }
      else {
          uint32_t now = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Counter$get();


          if ((uint32_t )(now - /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$t0) >= /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$dt) 
            {
              /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$set = FALSE;
              fired = TRUE;
              newOcr0 = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MAXT;
            }
          else 
            {


              uint32_t alarm_in = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$t0 + /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$dt - /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$base;

              if (alarm_in > /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MAXT) {
                newOcr0 = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MAXT;
                }
              else {
#line 126
                if ((uint8_t )alarm_in < /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MINDT) {
                  newOcr0 = /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$MINDT;
                  }
                else {
#line 129
                  newOcr0 = alarm_in;
                  }
                }
            }
        }
#line 132
      newOcr0--;
      /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$setOcr0(newOcr0);
    }
#line 134
    __nesc_atomic_end(__nesc_atomic); }
  if (fired) {
    /*AlarmCounterMilliP.Atm128AlarmAsyncC.Atm128AlarmAsyncP*/Atm128AlarmAsyncP$0$Alarm$fired();
    }
}

# 178 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer0AsyncP.nc"
__attribute((signal))   void __vector_15(void)
#line 178
{
  HplAtm128Timer0AsyncP$stabiliseTimer0();
  HplAtm128Timer0AsyncP$Compare$fired();
}


__attribute((signal))   void __vector_16(void)
#line 184
{
  HplAtm128Timer0AsyncP$stabiliseTimer0();
  HplAtm128Timer0AsyncP$Timer$overflow();
}

# 174 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
__attribute((signal))   void __vector_18(void)
#line 174
{
  if ((* (volatile uint8_t *)(0x0B + 0x20) & (1 << 7)) != 0) {
      HplAtm128UartP$HplUart0$rxDone(* (volatile uint8_t *)(0x0C + 0x20));
    }
}

# 402 "/opt/tinyos-2.x/tos/lib/serial/SerialP.nc"
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

# 81 "/opt/tinyos-2.x/tos/chips/atm128/crc.h"
static __attribute((noinline)) uint16_t crcByte(uint16_t oldCrc, uint8_t byte)
{

  uint16_t *table = crcTable;
  uint16_t newCrc;

   __asm ("eor %1,%B3\n"
  "\tlsl %1\n"
  "\tadc %B2, __zero_reg__\n"
  "\tadd %A2, %1\n"
  "\tadc %B2, __zero_reg__\n"
  "\tlpm\n"
  "\tmov %B0, %A3\n"
  "\tmov %A0, r0\n"
  "\tadiw r30,1\n"
  "\tlpm\n"
  "\teor %B0, r0" : 
  "=r"(newCrc), "+r"(byte), "+z"(table) : "r"(oldCrc));
  return newCrc;
}

# 290 "/opt/tinyos-2.x/tos/lib/serial/SerialDispatcherP.nc"
static   void /*SerialDispatcherC.SerialDispatcherP*/SerialDispatcherP$0$ReceiveBytePacket$endPacket(error_t result)
#line 290
{
  uint8_t postsignalreceive = FALSE;

  /* atomic removed: atomic calls only */
#line 292
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

# 180 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
__attribute((interrupt))   void __vector_20(void)
#line 180
{
  HplAtm128UartP$HplUart0$txDone();
}

# 92 "/opt/tinyos-2.x/tos/lib/serial/HdlcTranslateC.nc"
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

# 271 "/opt/tinyos-2.x/tos/chips/atm128/HplAtm128UartP.nc"
__attribute((signal))   void __vector_30(void)
#line 271
{
  if ((* (volatile uint8_t *)0x9B & (1 << 7)) != 0) {
    HplAtm128UartP$HplUart1$rxDone(* (volatile uint8_t *)0x9C);
    }
}

#line 276
__attribute((interrupt))   void __vector_32(void)
#line 276
{
  HplAtm128UartP$HplUart1$txDone();
}

# 189 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer3P.nc"
__attribute((interrupt))   void __vector_26(void)
#line 189
{
  HplAtm128Timer3P$CompareA$fired();
}

__attribute((interrupt))   void __vector_27(void)
#line 193
{
  HplAtm128Timer3P$CompareB$fired();
}

__attribute((interrupt))   void __vector_28(void)
#line 197
{
  HplAtm128Timer3P$CompareC$fired();
}

__attribute((interrupt))   void __vector_25(void)
#line 201
{
  HplAtm128Timer3P$Capture$captured(HplAtm128Timer3P$Timer$get());
}

__attribute((interrupt))   void __vector_29(void)
#line 205
{
  HplAtm128Timer3P$Timer$overflow();
}

# 195 "/opt/tinyos-2.x/tos/chips/atm128/timer/HplAtm128Timer1P.nc"
__attribute((interrupt))   void __vector_12(void)
#line 195
{
  HplAtm128Timer1P$CompareA$fired();
}

__attribute((interrupt))   void __vector_13(void)
#line 199
{
  HplAtm128Timer1P$CompareB$fired();
}

__attribute((interrupt))   void __vector_24(void)
#line 203
{
  HplAtm128Timer1P$CompareC$fired();
}

__attribute((interrupt))   void __vector_11(void)
#line 207
{
  HplAtm128Timer1P$Capture$captured(HplAtm128Timer1P$Timer$get());
}

__attribute((interrupt))   void __vector_14(void)
#line 211
{
  HplAtm128Timer1P$Timer$overflow();
}

# 46 "/opt/tinyos-2.x/tos/chips/atm128/pins/HplAtm128InterruptSigP.nc"
__attribute((signal))   void __vector_1(void)
#line 46
{
  HplAtm128InterruptSigP$IntSig0$fired();
}


__attribute((signal))   void __vector_2(void)
#line 51
{
  HplAtm128InterruptSigP$IntSig1$fired();
}


__attribute((signal))   void __vector_3(void)
#line 56
{
  HplAtm128InterruptSigP$IntSig2$fired();
}


__attribute((signal))   void __vector_4(void)
#line 61
{
  HplAtm128InterruptSigP$IntSig3$fired();
}


__attribute((signal))   void __vector_5(void)
#line 66
{
  HplAtm128InterruptSigP$IntSig4$fired();
}


__attribute((signal))   void __vector_6(void)
#line 71
{
  HplAtm128InterruptSigP$IntSig5$fired();
}


__attribute((signal))   void __vector_7(void)
#line 76
{
  HplAtm128InterruptSigP$IntSig6$fired();
}


__attribute((signal))   void __vector_8(void)
#line 81
{
  HplAtm128InterruptSigP$IntSig7$fired();
}

# 103 "/opt/tinyos-2.x/tos/chips/atm128/spi/HplAtm128SpiP.nc"
__attribute((signal))   void __vector_17(void)
#line 103
{
  HplAtm128SpiP$SPI$dataReady(HplAtm128SpiP$SPI$read());
}

