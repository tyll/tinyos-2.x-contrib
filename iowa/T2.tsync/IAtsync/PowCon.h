#ifndef POWCON_STRUCT 
typedef struct {
   uint16_t  period;    // period length in 1/8 seconds (max = 2.2 hours) 
   uint8_t   livetime;  // alive time per period in 1/8 seconds (max = 32 sec) 
   uint8_t   priority;  // priority within interval (for tie-breaks)   
   } powsched;
typedef powsched * powschedPtr;
enum { WAKE_slots = uniqueCount("PowCon") };
#define POWCON_STRUCT
#endif
