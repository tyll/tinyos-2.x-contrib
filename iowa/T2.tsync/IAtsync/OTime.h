#ifndef TS_OTIME
/**
  * NestArch definition of TimeSync interface structures
  */
typedef struct timeSync_t {
  uint16_t ClockH;  // jiffies for this clock are 1/(4 Mhz) or 0.25 microsec
                    // so we use 48-bit clock (about 2.2 years of jiffies)
  uint32_t ClockL;  
  } timeSync_t;
typedef timeSync_t * timeSyncPtr;

typedef union bigClock {
  struct { uint64_t g; } bigInt;
  struct { uint32_t lo; uint32_t hi; } partsInt;
  } bigClock;

// Tuning Constants for Skew, Sleep, etc

  enum { MAX_SKEW_AMT = 300,
         INTERVAL_WO_SKEW = 1048576u, // 2**20 SysTime units
         INTERVAL_WO_SKEW_POWER = 20, // log of above
         ONE_BYTE_TIME_UNIT = 146,    //  actually rounded (145.636 on MicaZ) 
         DO_SKEW_ADJUST = TRUE        // use skew/or not
        };

  #if defined(PLATFORM_MICAZ) || defined(PLATFORM_MICA2)
  enum { TPS = 921600u };  // the timer rate using 1/8 prescaler 
                           // as determined by Miklos at Vandy
			   // BUT, my own measurements indicate that
			   // the actual rate is 921778
  #endif
  #ifdef PLATFORM_MICA128
  enum { TPS = 500000u };  // on a Mica128, we have 4 Mhz, so 
                           // we have 921.6e3 * (4.0/MicaZ), 
                           // which is something like 
                           // 4.0 / { 7.37 7.36801 7.368 7.3679 7.3728 }e3
                           // --- some variance, hence the guess of 500288
                           // (the atmega128 datasheet says 7.3728 is the
                           // oscillator frequency, which would give us 
                           // 500,000 precisely)
  #endif
  #if defined(PLATFORM_TMOTE) || defined(PLATFORM_TMOTEINVENT) || defined(PLATFORM_TELOSB)
  enum { TPS = 1048576u };  // = 1024*1024, aka, binary million 
  #endif
#define TS_OTIME
#endif
